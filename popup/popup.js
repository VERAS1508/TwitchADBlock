const enabledInput = document.getElementById("enabled");
const statusEl = document.getElementById("status");

function setStatus(enabled) {
  statusEl.textContent = enabled
    ? "Enabled. Open Twitch tabs will reload automatically."
    : "Disabled. Open Twitch tabs will reload automatically.";
  statusEl.classList.toggle("is-active", enabled);
  statusEl.classList.toggle("is-inactive", !enabled);
}

chrome.storage.local.get({ enabled: true }, ({ enabled }) => {
  enabledInput.checked = enabled;
  setStatus(enabled);
});

enabledInput.addEventListener("change", () => {
  const enabled = enabledInput.checked;
  chrome.storage.local.set({ enabled }, () => {
    setStatus(enabled);
  });
});
