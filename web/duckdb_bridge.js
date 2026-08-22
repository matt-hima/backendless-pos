// DuckDB-Wasm browser adapter. Loaded by web/index.html before Flutter starts.
window.DuckDBBridge = { state: 'loading' };
(() => {
  let duckdb;
  const moduleReady = import('https://cdn.jsdelivr.net/npm/@duckdb/duckdb-wasm@1.29.0/+esm')
    .then((module) => { duckdb = module; });
  let database;
  let connection;
  let exportBytes;

  Object.assign(window.DuckDBBridge, {
    async init() {
      await moduleReady;
      if (connection) return;
      const bundles = duckdb.getJsDelivrBundles();
      // Keep the worker and WASM binary same-origin with Flutter. Chrome blocks
      // a Worker constructed directly from the jsDelivr origin.
      const localRoot = new URL('duckdb/', document.baseURI).toString();
      bundles.eh.mainWorker = `${localRoot}duckdb-browser-eh.worker.js`;
      bundles.eh.mainModule = `${localRoot}duckdb-eh.wasm`;
      bundles.mvp.mainWorker = `${localRoot}duckdb-browser-mvp.worker.js`;
      bundles.mvp.mainModule = `${localRoot}duckdb-mvp.wasm`;
      const bundle = await duckdb.selectBundle(bundles);
      const worker = await duckdb.createWorker(bundle.mainWorker);
      database = new duckdb.AsyncDuckDB(new duckdb.ConsoleLogger(), worker);
      await database.instantiate(bundle.mainModule, bundle.pthreadWorker);
      connection = await database.connect();
    },
    async exec(sql) {
      await moduleReady;
      await connection.query(sql);
    },
    async queryScalar(sql) {
      await moduleReady;
      const result = await connection.query(sql);
      const rows = result.toArray();
      if (!rows.length) return '';
      const first = rows[0];
      return String(first[Object.keys(first)[0]]);
    },
    async queryRows(sql) {
      await moduleReady;
      const result = await connection.query(sql);
      return JSON.stringify(result.toArray().map((row) => Object.fromEntries(
        Object.entries(row).map(([key, value]) => [key, typeof value === 'bigint' ? Number(value) : value])
      )));
    },
    async exportParquet() {
      await moduleReady;
      await connection.query(`COPY (
        SELECT c.rowid AS order_id, c.ref AS order_ref, s.rowid AS thirdparty_id,
          s.nom AS thirdparty_name, s.code_client, s.email,
          p.firstname, p.lastname, c.total_ht, c.total_ttc, c.updated_at
        FROM llx_commande c
        JOIN llx_societe s ON s.rowid = c.fk_soc
        LEFT JOIN llx_socpeople p ON p.fk_soc = s.rowid
      ) TO 'dolibarr_orders.parquet' (FORMAT PARQUET)`);
      exportBytes = await database.copyFileToBuffer('dolibarr_orders.parquet');
    },
    async readExportBase64() {
      await moduleReady;
      const bytes = new Uint8Array(exportBytes);
      let binary = '';
      const chunkSize = 0x8000;
      for (let i = 0; i < bytes.length; i += chunkSize) {
        binary += String.fromCharCode(...bytes.subarray(i, i + chunkSize));
      }
      return btoa(binary);
    },
  });
  window.dispatchEvent(new Event('duckdb-bridge-ready'));
  moduleReady.catch((error) => console.error('DuckDB-Wasm failed to load', error));
})();
