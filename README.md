# Twitch AdBlock

A lightweight **Chrome extension** (Manifest V3) that blocks video ads on [Twitch](https://www.twitch.tv/) at the stream level — before ads reach the player.

Built on the proven [**VAFT**](https://github.com/pixeltris/TwitchAdSolutions) engine from [TwitchAdSolutions](https://github.com/pixeltris/TwitchAdSolutions) (MIT License).

![Manifest V3](https://img.shields.io/badge/Manifest-V3-4285F4)
![License](https://img.shields.io/badge/License-MIT-green)
![Chrome](https://img.shields.io/badge/Chrome-Extension-9146FF)

## Features

- Blocks pre-roll and mid-roll video ads on Twitch live streams
- Injects at `document_start` — hooks Twitch workers before the player initializes
- Simple on/off toggle from the toolbar popup
- No remote code — all logic is bundled locally (Chrome Web Store compliant)
- Open source and free to use

## How it works

Twitch serves video through HLS workers that fetch `.m3u8` playlists. VAFT intercepts that pipeline:

1. **Worker hook** — replaces `window.Worker` to inject ad-blocking logic into Twitch's workers
2. **Playlist inspection** — detects ad segments in `.m3u8` manifests
3. **Clean stream fallback** — requests ad-free backup player variants when needed

## Installation

### Download release (recommended)

1. Open [Releases](https://github.com/VERAS1508/TwitchADBlock/releases) and download `twitch-adblock-v1.0.0.zip`
2. **Chrome Web Store:** upload the ZIP as-is in the [Developer Dashboard](https://chrome.google.com/webstore/devconsole)
3. **Local install:** extract the ZIP, then go to `chrome://extensions` → **Load unpacked** → select the extracted folder
4. Reload any open Twitch tabs

### Build from source

1. Clone this repository:
   ```bash
   git clone https://github.com/VERAS1508/TwitchADBlock.git
   ```
2. Open Chrome and go to `chrome://extensions`
3. Enable **Developer mode** (top right)
4. Click **Load unpacked** and select the project folder
5. Reload any open Twitch tabs

### Verify it is working

1. Open a Twitch stream
2. Open DevTools (`F12`) → **Console**
3. Look for `hookWorkerFetch (vaft)` — this confirms VAFT is active

## Usage

Click the extension icon in the toolbar to open the popup.

| Setting | Behavior |
| --- | --- |
| **Block video ads** (on) | VAFT injects on Twitch page load |
| **Block video ads** (off) | No injection; open Twitch tabs reload automatically |

## Compatibility

**Do not run this extension alongside other Twitch-specific ad blockers** that hook `window.Worker`, including:

- [AdGuard Extra](https://github.com/AdguardTeam/AdGuardExtra)
- Tampermonkey / Violentmonkey with VAFT or TwitchAdSolutions scripts
- Other VAFT-based Twitch extensions

Running multiple worker-level blockers can cause infinite loading screens or playback freezes. Pick one solution.

General ad blockers (uBlock Origin filter lists, AdGuard without Extra) are usually fine, but avoid duplicate Twitch scripts.

## Updating VAFT

The bundled engine lives in [`src/vaft.js`](src/vaft.js). To update from upstream:

1. Download the latest [vaft.user.js](https://github.com/pixeltris/TwitchAdSolutions/raw/master/vaft/vaft.user.js)
2. Remove the userscript header (`// ==UserScript==` … `// ==/UserScript==`)
3. Save as `src/vaft.js`
4. Reload the extension on `chrome://extensions`

## Chrome Web Store

To publish or update a listing:

1. Download the latest `twitch-adblock-v*.zip` from [Releases](https://github.com/VERAS1508/TwitchADBlock/releases)
2. Upload it in the [Chrome Web Store Developer Dashboard](https://chrome.google.com/webstore/devconsole)
3. Link to [`PRIVACY.md`](PRIVACY.md) as your privacy policy

To build a new package locally:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/package-release.ps1
```

Output is written to `dist/twitch-adblock-v{version}.zip`.

## Project structure

```
TwitchADBlock/
├── manifest.json       # Extension manifest (MV3)
├── background.js       # Reloads Twitch tabs on toggle change
├── src/
│   ├── content.js      # Storage check + page-context injection
│   └── vaft.js         # VAFT ad-blocking engine (bundled)
├── popup/              # Toolbar popup UI
├── icons/              # Extension icons
├── LICENSE
├── PRIVACY.md
└── README.md
```

## Known limitations

- Twitch may change its player — VAFT updates may be required periodically
- Occasional buffering or freezing is a known upstream VAFT behavior; mitigation is built in
- Not a replacement for Twitch Turbo or channel subscriptions
- Squad streams are not supported by VAFT
- Use at your own discretion; review Twitch's Terms of Service

## License

MIT — see [LICENSE](LICENSE).

Ad-blocking logic is derived from [TwitchAdSolutions](https://github.com/pixeltris/TwitchAdSolutions) (MIT License). Credit to the TwitchAdSolutions contributors and the original VAFT authors.

## Disclaimer

This project is not affiliated with, endorsed by, or sponsored by Twitch Interactive, Inc. It is provided as-is without warranty.
