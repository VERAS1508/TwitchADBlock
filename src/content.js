/**
 * Injects the VAFT ad-blocking script into the page context at document_start.
 * Runs in the extension's isolated world; VAFT must run in the page world to hook Workers.
 */
chrome.storage.local.get({ enabled: true }, ({ enabled }) => {
  if (!enabled) {
    return;
  }

  const script = document.createElement("script");
  script.src = chrome.runtime.getURL("src/vaft.js");
  script.onload = () => script.remove();
  (document.head || document.documentElement).appendChild(script);
});
