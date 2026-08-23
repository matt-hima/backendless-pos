const PORTAL_URL = 'https://remote-order.web.app/portal';

chrome.runtime.onInstalled.addListener(() => {
  chrome.storage.local.set({portalUrl: PORTAL_URL});
});

chrome.action.onClicked.addListener(() => openPortal());

chrome.commands?.onCommand.addListener((command) => {
  if (command === 'open-portal') openPortal();
});

function openPortal() {
  chrome.tabs.create({url: PORTAL_URL, pinned: true});
}
