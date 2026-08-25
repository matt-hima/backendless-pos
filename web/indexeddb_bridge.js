// Client-side order storage. IndexedDB is the durable browser cache for the
// customer-facing menu; DuckDB remains the relational portal/export database.
(() => {
  const DB_NAME = 'dolibarr_client_db';
  const DB_VERSION = 9;
  const ALL_STORES = ['llx_product', 'llx_commande', 'llx_commandedet', 'llx_societe', 'llx_channel', 'llx_livechat', 'cms_items', 'bookings', 'member_session', 'sync_meta'];
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
        if (!db.objectStoreNames.contains('llx_societe')) db.createObjectStore('llx_societe', {keyPath: 'rowid'});
        if (!db.objectStoreNames.contains('llx_channel')) db.createObjectStore('llx_channel', {keyPath: 'code'});
        const chat = db.objectStoreNames.contains('llx_livechat') ? request.transaction.objectStore('llx_livechat') : db.createObjectStore('llx_livechat', {keyPath: 'rowid'});
        if (!chat.indexNames.contains('channel')) chat.createIndex('channel', 'channel');
        const cms = db.objectStoreNames.contains('cms_items') ? request.transaction.objectStore('cms_items') : db.createObjectStore('cms_items', {keyPath: 'rowid'});
        if (!cms.indexNames.contains('collection')) cms.createIndex('collection', 'collection');
        if (!db.objectStoreNames.contains('bookings')) db.createObjectStore('bookings', {keyPath: 'id'});
        if (!db.objectStoreNames.contains('member_session')) db.createObjectStore('member_session', {keyPath: 'id'});
        if (!db.objectStoreNames.contains('sync_meta')) db.createObjectStore('sync_meta', {keyPath: 'id'});
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
      const legacy = await requestValue(transaction(['llx_product']).objectStore('llx_product').getAll());
      const cleanup = transaction(['llx_product'], 'readwrite');
      for (const product of legacy) {
        if (String(product.ref || '').startsWith('DTF-')) cleanup.objectStore('llx_product').delete(product.rowid);
      }
      await new Promise((resolve, reject) => { cleanup.oncomplete = resolve; cleanup.onerror = () => reject(cleanup.error); });
      await seed(JSON.parse(productsJson));
    },
    async products() {
      await open();
      const rows = await requestValue(transaction(['llx_product']).objectStore('llx_product').getAll());
      return JSON.stringify(rows);
    },
    async saveProducts(productsJson, revision = null) {
      await open();
      const products = JSON.parse(productsJson);
      const tx = transaction(['llx_product', 'sync_meta'], 'readwrite');
      const store = tx.objectStore('llx_product');
      store.clear();
      for (const product of products) store.put(product);
      tx.objectStore('sync_meta').put({id: 'catalog', revision, updated_at: new Date().toISOString()});
      await new Promise((resolve, reject) => { tx.oncomplete = resolve; tx.onerror = () => reject(tx.error); });
    },
    async catalogRevision() {
      await open();
      const row = await requestValue(transaction(['sync_meta']).objectStore('sync_meta').get('catalog'));
      return row?.revision || null;
    },
    async saveWalletThirdParty(thirdpartyJson) {
      await open();
      const thirdparty = JSON.parse(thirdpartyJson);
      const tx = transaction(['llx_societe'], 'readwrite');
      tx.objectStore('llx_societe').put(thirdparty);
      await new Promise((resolve, reject) => { tx.oncomplete = resolve; tx.onerror = () => reject(tx.error); });
    },
    async walletThirdParty(wallet) {
      await open();
      const rows = await requestValue(transaction(['llx_societe']).objectStore('llx_societe').getAll());
      return JSON.stringify(rows.find((row) => row.wallet === wallet) || null);
    },
    async saveMemberSession(sessionJson) {
      await open();
      const session = JSON.parse(sessionJson);
      const tx = transaction(['member_session'], 'readwrite');
      tx.objectStore('member_session').put(session);
      await new Promise((resolve, reject) => { tx.oncomplete = resolve; tx.onerror = () => reject(tx.error); });
    },
    async expireMemberData(nowIso) {
      await open();
      const now = new Date(nowIso).getTime();
      const sessions = await requestValue(transaction(['member_session']).objectStore('member_session').getAll());
      for (const session of sessions) {
        if (new Date(session.expires_at).getTime() <= now) {
          const expiredRows = {};
          for (const storeName of ['llx_commande', 'llx_societe', 'llx_livechat']) {
            expiredRows[storeName] = (await requestValue(transaction([storeName]).objectStore(storeName).getAll()))
              .filter((row) => row.wallet === session.wallet);
          }
          const tx = transaction(['member_session', 'llx_commande', 'llx_societe', 'llx_livechat'], 'readwrite');
          tx.objectStore('member_session').delete(session.id);
          for (const [storeName, rows] of Object.entries(expiredRows)) {
            for (const row of rows) tx.objectStore(storeName).delete(row.rowid);
          }
          await new Promise((resolve, reject) => { tx.oncomplete = resolve; tx.onerror = () => reject(tx.error); });
        }
      }
    },
    async memberSession() {
      await open();
      const sessions = await requestValue(transaction(['member_session']).objectStore('member_session').getAll());
      const valid = sessions
        .filter((session) => new Date(session.expires_at).getTime() > Date.now())
        .sort((a, b) => new Date(b.expires_at).getTime() - new Date(a.expires_at).getTime());
      return JSON.stringify(valid[0] || null);
    },
    async saveEncryptedTransaction(transactionJson) {
      await open();
      const transactionObject = JSON.parse(transactionJson);
      transactionObject.portal_status = 'pending';
      const tx = transaction(['llx_commande'], 'readwrite');
      tx.objectStore('llx_commande').put(transactionObject);
      await new Promise((resolve, reject) => { tx.oncomplete = resolve; tx.onerror = () => reject(tx.error); });
    },
    async updateTransactionStatus(rowid, status) {
      await open();
      await new Promise((resolve, reject) => {
        const tx = transaction(['llx_commande'], 'readwrite');
        const store = tx.objectStore('llx_commande');
        const request = store.get(rowid);
        request.onsuccess = () => {
          if (request.result) {
            request.result.portal_status = status;
            store.put(request.result);
          }
        };
        tx.oncomplete = resolve;
        tx.onerror = () => reject(tx.error);
      });
    },
    async transactions(channel, wallet) {
      await open();
      const rows = await requestValue(transaction(['llx_commande']).objectStore('llx_commande').getAll());
      return JSON.stringify(rows.filter((row) => row.channel === channel && row.wallet === wallet));
    },
    async createChannel(name, merchantId) {
      await open();
      const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
      let code;
      for (let attempt = 0; attempt < 20; attempt++) {
        const bytes = crypto.getRandomValues(new Uint8Array(6));
        const candidate = Array.from(bytes, (byte) => alphabet[byte % alphabet.length]).join('');
        const existing = await requestValue(
          transaction(['llx_channel']).objectStore('llx_channel').get(candidate),
        );
        if (!existing) { code = candidate; break; }
      }
      if (!code) throw new Error('Could not create a unique merchant channel');
      const channel = {code, merchant_id: merchantId || null, name: name || `Channel ${code}`, created_at: new Date().toISOString()};
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
    async saveLivechatMessage(messageJson) {
      await open();
      const message = JSON.parse(messageJson);
      const tx = transaction(['llx_livechat'], 'readwrite');
      tx.objectStore('llx_livechat').put(message);
      await new Promise((resolve, reject) => { tx.oncomplete = resolve; tx.onerror = () => reject(tx.error); });
    },
    async livechatMessages(channel, wallet) {
      await open();
      const rows = await requestValue(transaction(['llx_livechat']).objectStore('llx_livechat').getAll());
      return JSON.stringify(rows
        .filter((row) => row.channel === channel && row.wallet === wallet)
        .sort((a, b) => a.created_at.localeCompare(b.created_at)));
    },
    async dumpAll() {
      await open();
      const dump = {};
      for (const store of ALL_STORES) {
        dump[store] = await requestValue(transaction([store]).objectStore(store).getAll());
      }
      return JSON.stringify(dump);
    },
    async restoreAll(dumpJson) {
      await open();
      const dump = JSON.parse(dumpJson);
      for (const store of ALL_STORES) {
        const tx = transaction([store], 'readwrite');
        const objectStore = tx.objectStore(store);
        objectStore.clear();
        for (const row of (dump[store] || [])) objectStore.put(row);
        await new Promise((resolve, reject) => { tx.oncomplete = resolve; tx.onerror = () => reject(tx.error); });
      }
    },
    async resetAll() {
      await open();
      for (const store of ALL_STORES) {
        const tx = transaction([store], 'readwrite');
        tx.objectStore(store).clear();
        await new Promise((resolve, reject) => { tx.oncomplete = resolve; tx.onerror = () => reject(tx.error); });
      }
    },
    async saveCmsItems(collection, itemsJson) {
      await open();
      const items = JSON.parse(itemsJson);
      const tx = transaction(['cms_items'], 'readwrite');
      const store = tx.objectStore('cms_items');
      const existing = await requestValue(store.index('collection').getAllKeys(collection));
      for (const key of existing) store.delete(key);
      for (const item of items) store.put({...item, collection});
      await new Promise((resolve, reject) => { tx.oncomplete = resolve; tx.onerror = () => reject(tx.error); });
    },
    async cmsItems(collection) {
      await open();
      const rows = await requestValue(transaction(['cms_items']).objectStore('cms_items').index('collection').getAll(collection));
      return JSON.stringify(rows);
    },
    async saveBooking(bookingJson) {
      await open();
      const booking = JSON.parse(bookingJson);
      const tx = transaction(['bookings'], 'readwrite');
      tx.objectStore('bookings').put(booking);
      await new Promise((resolve, reject) => { tx.oncomplete = resolve; tx.onerror = () => reject(tx.error); });
    },
    async bookings() {
      await open();
      const rows = await requestValue(transaction(['bookings']).objectStore('bookings').getAll());
      return JSON.stringify(rows);
    },
  };
})();
