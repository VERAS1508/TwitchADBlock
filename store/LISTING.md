# Chrome Web Store Listing — Twitch AdBlock

Category: **Privacy & Security**

Privacy policy URL: `https://github.com/VERAS1508/TwitchADBlock/blob/main/PRIVACY.md`

---

## Extension name

Twitch AdBlock

---

## Short description (max 132 characters)

Block Twitch video ads at the stream level. Privacy-focused, no data collection, open source, and a simple on/off toggle.

---

## Detailed description

Watch Twitch without pre-roll and mid-roll video interruptions.

Twitch AdBlock is a lightweight, privacy-focused Chrome extension that blocks video ads on Twitch.tv before they reach the player. Instead of hiding banners after they appear, it works at the stream level by intercepting Twitch's video pipeline early — helping you enjoy live streams with fewer forced ad breaks.

**Why users choose Twitch AdBlock**

• Blocks pre-roll and mid-roll video ads on Twitch live streams  
• Privacy-first design — no account required, no analytics, no data sent to the developer  
• Stores only one local setting: whether ad blocking is enabled  
• Simple toolbar popup with an on/off toggle  
• Open source and fully auditable on GitHub  
• No remote code — all logic is bundled inside the extension

**Built for privacy and security**

Twitch AdBlock is designed with a minimal footprint. It does not collect personal information, browsing history, or viewing habits. The only data stored on your device is your enable/disable preference, saved locally through Chrome's storage API.

Permissions are limited to what is required for core functionality: running on Twitch pages, saving your toggle setting, and reloading open Twitch tabs when you change that setting.

**How it works**

Twitch delivers video through background workers and HLS stream playlists. Twitch AdBlock injects at document start and applies proven stream-level ad-blocking logic to detect ad segments and request clean stream variants when needed — before ads are rendered in the player.

**Easy to control**

Click the extension icon to turn ad blocking on or off at any time. When you change the setting, open Twitch tabs reload automatically so the new state takes effect immediately.

**Compatibility note**

Do not use this extension together with other Twitch-specific worker-level ad blockers (such as AdGuard Extra or duplicate VAFT userscripts). Running multiple solutions that hook the same browser APIs can cause playback issues.

**Open source**

Source code, updates, and issue reporting are available on GitHub: https://github.com/VERAS1508/TwitchADBlock

**Disclaimer**

This extension is not affiliated with, endorsed by, or sponsored by Twitch Interactive, Inc. It is provided as-is for personal use. Please review Twitch's Terms of Service.

---

## Single purpose description (if required)

This extension has a single purpose: to block video advertisements on Twitch.tv.

---

## Permission justifications (if prompted)

| Permission | Justification |
| --- | --- |
| `storage` | Save whether ad blocking is enabled (on/off toggle). |
| `tabs` | Reload open Twitch tabs when the user changes the on/off setting. |
| Host access to `twitch.tv`, `ttvnw.net`, `gql.twitch.tv` | Required to run the content script that enables stream-level ad blocking on Twitch pages. |

---

## Suggested store keywords (internal reference)

twitch, adblock, ad blocker, no ads, privacy, security, stream, livestream, video ads, twitch ads

---

## Asset checklist

| Asset | File | Size |
| --- | --- | --- |
| Store icon | `store/icon-128.png` | 128 × 128 |
| Screenshot 1 | `store/screenshot-01-hero.png` | 1280 × 800 |
| Screenshot 2 | `store/screenshot-02-popup.png` | 1280 × 800 |
| Screenshot 3 | `store/screenshot-03-privacy.png` | 1280 × 800 |
| Screenshot 4 | `store/screenshot-04-how-it-works.png` | 1280 × 800 |
| Screenshot 5 | `store/screenshot-05-control.png` | 1280 × 800 |
| Small promo tile | `store/promo-small-440x280.png` | 440 × 280 |
| Marquee promo tile | `store/promo-marquee-1400x560.png` | 1400 × 560 |

All images are 24-bit PNG without alpha channel, as required by the Chrome Web Store.
