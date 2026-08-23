// Remove the deprecated Flutter worker and reload once so an existing tab
// cannot keep rendering an older cached main.dart.js bundle.
(() => {
  if (!('serviceWorker' in navigator)) return;
  const reloadKey = 'lilygo-pwa-clean-v3';
  Promise.all([
    navigator.serviceWorker.getRegistrations().then((registrations) =>
      Promise.all(registrations.map((registration) => registration.unregister()))),
    window.caches
      ? caches.keys().then((keys) => Promise.all(keys.map((key) => caches.delete(key))))
      : Promise.resolve(),
  ]).then(() => {
    if (!sessionStorage.getItem(reloadKey)) {
      sessionStorage.setItem(reloadKey, '1');
      window.location.reload();
    }
  });
})();
