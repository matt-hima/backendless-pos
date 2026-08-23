(() => {
  const key = 'lilygo-merchant-links-v1';

  function read() {
    try { return JSON.parse(localStorage.getItem(key) || '{}'); }
    catch (_) { return {}; }
  }

  window.MerchantLinksBridge = {
    save(channel, link, name) {
      const links = read();
      links[channel] = {
        channel,
        link,
        name: name || channel,
        saved_at: new Date().toISOString(),
      };
      localStorage.setItem(key, JSON.stringify(links));
    },
    list() { return JSON.stringify(Object.values(read())); },
    remove(channel) {
      const links = read();
      delete links[channel];
      localStorage.setItem(key, JSON.stringify(links));
    },
  };
})();
