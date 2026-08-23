document.getElementById('open').addEventListener('click', () => {
  chrome.tabs.create({url: 'https://remote-order.web.app/portal', pinned: true});
  window.close();
});
