🚗 710HandBrake - Realistic Handbrake System for FiveM
https://img.shields.io/badge/FiveM-1.9.0+-blue.svg
https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg
https://img.shields.io/badge/Version-3.3.0-orange.svg

📖 Overview
710HandBrake is a standalone, highly realistic handbrake system for FiveM servers, built from the ground up for serious roleplay and immersion. Unlike the default GTA V handbrake—which simply locks the rear wheels and stops the car instantly—this script simulates real-world physics with progressive braking, slope rolling, and a fully customizable visual HUD.

Whether you're drifting through the hills of Los Santos, parking on a steep hill, or just want a more authentic driving experience, 710HandBrake delivers realism without compromising performance.

🔥 Key Features
🧠 Progressive Handbrake Logic
High Speed (>15 km/h): The handbrake applies smooth, progressive braking instead of an instant lock-up. The vehicle slows down gradually, allowing for controlled drifts and realistic handling.

Low Speed (<15 km/h): The handbrake engages the parking brake and freezes the vehicle when it comes to a complete stop—just like a real car.

No Brake Lights: The handbrake does not activate brake lights, as in real life (only the foot brake should).

🏔️ Physics-Based Rolling on Slopes
When the handbrake is off and the vehicle is on a slope, it will roll naturally downhill based on its weight and the angle of the incline.

The rolling speed is mass-dependent—heavier vehicles roll slower, lighter vehicles roll faster—just like in reality.

🖥️ Customizable Visual HUD
Always visible while inside a vehicle, showing the handbrake status in real-time.

Three display styles:

text → Shows "HANDBRAKE ON/OFF"

image → Shows a visual icon (handbrake lever)

image_text → Shows both icon and text (default)

Configurable position: Bottom-left, bottom-right, top-left, top-right.

Configurable scale: Make it smaller or larger to fit your UI preferences.

Automatically hides when you exit the vehicle—no screen clutter.

🔊 Audio Feedback (Native GTA V Sounds)
Uses PlaySoundFrontend (GTA V native sounds) for 100% reliability—no external audio files needed.

"SELECT" sound when engaging the handbrake.

"BACK" sound when disengaging.

No setup, no missing files, no errors—it just works.

🌍 Multi-Language Support
15 languages included out of the box:

English, Spanish, French, German, Portuguese, Russian, Italian, Chinese, Japanese, Korean, Arabic, Dutch, Polish, Swedish, Turkish.

Easily add your own language by creating a new file in the locales/ folder.

All notifications and HUD labels are fully translated.

🔄 Full Synchronization
Handbrake status and effects are synced across all players in real-time.

Other players will see your handbrake engaged (vehicle frozen, lights off) and hear the sounds if nearby.

⚡ Lightweight & Optimized
Zero performance impact—runs on a single thread with minimal CPU usage.

Standalone—no dependencies on ESX, QBCore, or any other framework.

Compatible with any server, from small RP communities to large public servers.

🎮 How It Works
Handbrake Logic (Step-by-Step)
Speed	Action
> 15 km/h	Applies smooth braking force opposite to the vehicle's movement. If the player steers, adds lateral drift force for realistic slides.
< 15 km/h	Engages the parking brake (locks rear wheels).
Stopped (< 0.3 m/s)	Freezes the vehicle completely—no rolling, no sliding.
Handbrake OFF on slope	Vehicle rolls naturally downhill with mass-dependent speed.
Slope Detection
Uses the vehicle's pitch angle to detect slopes.

The minimum angle is configurable (Config.SlopeAngle).

Rolling speed is limited to a configurable maximum (Config.MaxRollSpeed) to prevent unrealistic acceleration.

Key Binding
Default: LSHIFT (Left Shift)

Configurable: Change to any key in config.lua (Config.HandbrakeKey = 'B', 'CAPSLOCK', etc.)

🛠️ Configuration
All settings are in config.lua. Here's what you can tweak:

lua
-- ============================================
-- HUD CONFIGURATION
-- ============================================
Config.HudStyle = 'image_text'     -- 'text', 'image', 'image_text'
Config.HudPosition = 'bottom-left' -- 'bottom-left', 'bottom-right', 'top-left', 'top-right'
Config.HudScale = 1.0              -- 0.5 = half size, 1.5 = bigger

-- ============================================
-- HANDBRAKE SETTINGS
-- ============================================
Config.HandbrakeKey = 'LSHIFT'
Config.ShowNotifications = false   -- Hide the ugly GTA V notifications
Config.EnableLogs = true           -- Server-side logs
Config.SyncDistance = 50.0         -- Sync range in meters

-- Physics
Config.GravityForce = 6.0          -- Slope rolling force
Config.SlopeAngle = 1.5            -- Minimum angle to detect slope
Config.MaxRollSpeed = 40.0         -- Maximum rolling speed (km/h)
Config.HandbrakeFriction = 0.15    -- Braking force at high speed
Config.HandbrakeSpeedThreshold = 15.0 -- Speed threshold for progressive braking

-- Language
Config.Locale = 'es'               -- 'en', 'es', 'fr', 'de', 'pt', 'ru', 'it', 'zh', 'ja', 'ko', 'ar', 'nl', 'pl', 'sv', 'tr'
📥 Installation
Step 1: Download
Clone the repository:

bash
git clone https://github.com/710Scripts/710HandBrake.git
Or download the ZIP from Releases.

Step 2: Add to Server
Place the 710HandBrake folder in your server's resources/ directory.

Step 3: Add to server.cfg
cfg
ensure 710HandBrake
Step 4: Restart
Restart your server or run restart 710HandBrake in the console.

🌍 Adding a New Language
Create a new file in locales/, e.g., it.lua.

Copy the structure from en.lua and translate the strings.

Add the file to fxmanifest.lua:

lua
'locales/it.lua',
Set Config.Locale = 'it' in config.lua.

📄 License
This project is licensed under CC BY-NC-ND 4.0 (Creative Commons Attribution-NonCommercial-NoDerivatives).

You are free to:

✅ Use this script on your FiveM server.

✅ Share it with others (with attribution).

You may NOT:

❌ Modify, adapt, or create derivative works.

❌ Sell, rent, or sublicense this script.

❌ Use it for commercial purposes (including including it in paid packs).

Configuration is NOT considered modification—you are free to tweak config.lua to fit your server's needs.

Full license: https://creativecommons.org/licenses/by-nc-nd/4.0/

🙏 Credits
Author: 710Scripts

📞 Support
Issues: GitHub Issues or Social Media

Discord: https://discord.gg/aJ2wgTAB8

🚀 Show Your Support
If you find this script useful, please consider:

⭐ Starring the repository on GitHub.

🔄 Sharing it with other server owners.

💬 Providing feedback and suggestions.

Made with ❤️ for the FiveM community.
