# 🚗 710HandBrake - Realistic Handbrake System for FiveM

A **standalone**, realistic handbrake system for FiveM servers. Designed for serious roleplay, this script simulates a progressive handbrake with physics-based rolling on slopes, a visual HUD, sound effects, and multi-language support.

---

## ✨ Features

- 🔧 **Standalone** – No dependencies. Works on any FiveM server (ESX, QBCore, or no framework).
- 🧠 **Progressive Handbrake** – Smooth braking at high speeds vs. parking brake at low speeds.
- 🏔️ **Physics-Based Rolling** – Vehicles roll naturally on slopes when the handbrake is off.
- 🎮 **Manual Key Capture** – Uses `LSHIFT` without interfering with chat or other binds.
- 🖥️ **Visual HUD** – Shows handbrake status (ON/OFF) in real-time.
- 🔊 **Sound Effects** – Custom audio feedback for engaging/disengaging. (Currently working on solving the issue regarding this feature)
- 🌍 **Multi-Language Support** – 15 languages included (English, Spanish, French, German, Portuguese, Russian, Italian, Chinese, Japanese, Korean, Arabic, Dutch, Polish, Swedish, Turkish).
- 🔄 **Full Synchronization** – Handbrake status and effects are synced across all players.
- 🚫 **No Brake Lights** – More realistic.
- 🛠️ **Highly Configurable** – Almost every aspect of the script can be tuned to fit your server's playstyle, from physics and keybinds to audio and HUD behavior.
- ⚡ **Lightweight & Optimized** – Minimal performance impact with efficient code.

---

## 📥 Installation

### 1. Download & Extract
- Download the latest release from [GitHub Releases](https://github.com/710Scripts/710HandBrake/releases) or clone the repository:
  ```bash
  git clone https://github.com/710Scripts/710HandBrake.git

### 2. Add to server.cfg
- Add the following line to your server.cfg:
ensure 710HandBrake

### 3. Start Your Server
- Restart your server



## ⚙️ Configuration
All settings are located in config.lua. The script is highly configurable, allowing you to adjust:

Physics (gravity force, slope angle, max speed, friction).

Keybinds (change the handbrake key).

Visuals (enable/disable notifications, HUD position, style, scale).

Language (choose from 15 built-in languages or add your own).

## 🎮 How It Works
🚦 Handbrake Logic
Above 15 km/h → Applies progressive braking with a gentle slowdown and drift effect (if steering).

Below 15 km/h → Engages the parking brake and freezes the vehicle when stopped.

Slopes → When the handbrake is off, the vehicle rolls naturally based on pitch angle and weight.

🖥️ HUD
Displays a sleek indicator in the corner of your screen showing:

🟢 ON – Handbrake engaged.

🔴 OFF – Handbrake released.

The HUD position, size, and style can be customized in config.lua.

🔊 Audio
Uses native GTA V sounds (PlaySoundFrontend) as fallback.

Custom audio feedback system is currently being improved for future releases.

"SELECT" sound when engaging the handbrake.

"BACK" sound when disengaging.

🌐 Multi-Language
Change Config.Locale in config.lua to switch languages.

Add new languages by creating a new .lua file in /locales and adding it to fxmanifest.lua.

🛠️ Customization
Adding a New Language
Create a new file in /locales, e.g., it.lua.

Copy the structure from en.lua and translate the strings.

Add the file to fxmanifest.lua:

lua
'locales/it.lua',
Set Config.Locale = 'it' in config.lua.

Changing HUD Style
Config.HudStyle = 'text' → Only text.

Config.HudStyle = 'image' → Only image icon.

Config.HudStyle = 'image_text' → Both image and text (default).

Adjusting Physics
Config.GravityForce – Increase for faster rolling, decrease for slower.

Config.SlopeAngle – Lower to detect milder slopes, higher to require steeper inclines.

Config.MaxRollSpeed – Set the maximum rolling speed (km/h) to prevent unrealistic acceleration.

📋 Requirements
FiveM Server (1.9.0 or higher recommended)

No external dependencies (standalone)

📄 License
This project is licensed under CC BY-NC-ND 4.0 (Creative Commons Attribution-NonCommercial-NoDerivatives).

You are free to:

✅ Use this script on your FiveM server.

✅ Share it with others (with attribution).

You may NOT:

❌ Modify, adapt, or create derivative works.

❌ Sell, rent, or sublicense this script.

❌ Use it for commercial purposes (including including it in paid packs).

Configuration is obviously NOT considered modification – you are free to tweak config.lua to fit your server's needs.

Full license: https://creativecommons.org/licenses/by-nc-nd/4.0/

🙏 Credits

Author: 710Scripts

📞 Support

Issues: Report bugs or request features via GitHub Issues or through any of our social media.

Instagram: 710scripts

TikTok: 710scripts

Discord: Coming soon.

🚀 Show Your Support
If you find this script useful, please consider:

⭐ Starring the repository on GitHub.

🔄 Sharing it with other server owners.

💬 Providing feedback and suggestions.

Made with ❤️ for the FiveM community.
  
