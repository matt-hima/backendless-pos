(() => {
  let wakeLock = null;
  window.NotificationBridge = {
    supported: () => 'Notification' in window,
    permission: () => ('Notification' in window ? Notification.permission : 'unsupported'),
    request: () => ('Notification' in window ? Notification.requestPermission() : Promise.resolve('unsupported')),
    show: (title, body) => {
      if (!('Notification' in window) || Notification.permission !== 'granted') return false;
      new Notification(title, {body, tag: 'lilygo-erp'});
      return true;
    },
    wakeSupported: () => 'wakeLock' in navigator,
    async keepAwake() {
      if (!('wakeLock' in navigator)) return false;
      wakeLock = await navigator.wakeLock.request('screen');
      wakeLock.addEventListener('release', () => { wakeLock = null; });
      return true;
    },
    async releaseAwake() {
      await wakeLock?.release();
      wakeLock = null;
      return true;
    },
    awake: () => wakeLock != null,
  };
})();
