// Client-side order storage. IndexedDB is the durable browser cache for the
// customer-facing menu; DuckDB remains the relational portal/export database.
(() => {
  const DB_NAME = 'dolibarr_client_db';
  const DB_VERSION = 7;
  const ALL_STORES = ['llx_product', 'llx_commande', 'llx_commandedet', 'llx_societe', 'llx_channel', 'llx_livechat', 'cms_items', 'bookings'];
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
