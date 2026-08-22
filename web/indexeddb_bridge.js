// Client-side order storage. IndexedDB is the durable browser cache for the
// customer-facing menu; DuckDB remains the relational portal/export database.
(() => {
  const DB_NAME = 'dolibarr_client_db';
  const DB_VERSION = 3;
  let database;

  function open() {
    if (database) return Promise.resolve(database);
    return new Promise((resolve, reject) => {
      const request = indexedDB.open(DB_NAME, DB_VERSION);
      request.onupgradeneeded = () => {
        const db = request.result;
        const products = db.objectStoreNames.contains('llx_product') ? request.transaction.objectStore('llx_product') : db.createObjectStore('llx_product', {keyPath: 'rowid'});
        if (!products.indexNames.contains('ref')) products.createIndex('ref', 'ref', {unique: true});
        if (!products.indexNames.contains('category')) products.createIndex('category', 'category');
        if (!db.objectStoreNames.contains('llx_commande')) db.createObjectStore('llx_commande', {keyPath: 'rowid'});
        const lines = db.objectStoreNames.contains('llx_commandedet') ? request.transaction.objectStore('llx_commandedet') : db.createObjectStore('llx_commandedet', {keyPath: 'rowid'});
        if (!lines.indexNames.contains('fk_commande')) lines.createIndex('fk_commande', 'fk_commande');
        if (!db.objectStoreNames.contains('llx_channel')) db.createObjectStore('llx_channel', {keyPath: 'code'});
      };
      request.onsuccess = () => { database = request.result; resolve(database); };
      request.onerror = () => reject(request.error);
      request.onblocked = () => reject(new Error('IndexedDB upgrade is blocked by another open tab'));
    });
  }

  function transaction(storeNames, mode = 'readonly') {
    return database.transaction(storeNames, mode);
  }

  function requestValue(request) {
    return new Promise((resolve, reject) => {
      request.onsuccess = () => resolve(request.result);
      request.onerror = () => reject(request.error);
    });
  }

  async function seed(products) {
    const db = await open();
    const tx = transaction(['llx_product'], 'readwrite');
    const store = tx.objectStore('llx_product');
    const complete = new Promise((resolve, reject) => { tx.oncomplete = resolve; tx.onerror = () => reject(tx.error); tx.onabort = () => reject(tx.error); });
    for (const product of products) store.put(product);
    await complete;
  }

  window.IndexedDbBridge = {
    async init(productsJson) {
      await open();
      await seed(JSON.parse(productsJson));
    },
    async products() {
      await open();
      const rows = await requestValue(transaction(['llx_product']).objectStore('llx_product').getAll());
      return JSON.stringify(rows);
    },
    async saveEncryptedTransaction(transactionJson) {
      await open();
      const transactionObject = JSON.parse(transactionJson);
      const tx = transaction(['llx_commande'], 'readwrite');
      tx.objectStore('llx_commande').put(transactionObject);
      await new Promise((resolve, reject) => { tx.oncomplete = resolve; tx.onerror = () => reject(tx.error); });
    },
    async transactions(channel, wallet) {
      await open();
      const rows = await requestValue(transaction(['llx_commande']).objectStore('llx_commande').getAll());
      return JSON.stringify(rows.filter((row) => row.channel === channel && row.wallet === wallet));
    },
    async createChannel(name) {
      await open();
      const code = Math.random().toString(36).slice(2, 8).toUpperCase();
      const channel = {code, name: name || `Channel ${code}`, created_at: new Date().toISOString()};
      const tx = transaction(['llx_channel'], 'readwrite');
      tx.objectStore('llx_channel').put(channel);
      await new Promise((resolve, reject) => { tx.oncomplete = resolve; tx.onerror = () => reject(tx.error); });
      return JSON.stringify(channel);
    },
    async channels() {
      await open();
      const rows = await requestValue(transaction(['llx_channel']).objectStore('llx_channel').getAll());
      return JSON.stringify(rows);
    },
  };
})();
