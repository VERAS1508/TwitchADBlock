/**
 * Reloads open Twitch tabs when the user toggles ad blocking in the popup.
 * VAFT only injects at document_start, so a reload is required for changes to apply.
 */
chrome.storage.onChanged.addListener((changes, areaName) => {
  if (areaName !== "local" || !changes.enabled) {
    return;
  }

  chrome.tabs.query({ url: ["*://*.twitch.tv/*"] }, (tabs) => {
    for (const tab of tabs) {
      if (tab.id !== undefined) {
        chrome.tabs.reload(tab.id);
      }
    }
  });
});
