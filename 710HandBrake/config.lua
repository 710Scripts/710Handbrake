Config = {}

-- ============================================
-- HUD CONFIGURATION
-- ============================================
-- hudStyle options:
--   'text'        -> Show only text (e.g., "HANDBRAKE ON/OFF")
--   'image'       -> Show only image icon
--   'image_text'  -> Show both image and text (default)
Config.HudStyle = 'image_text'

-- HUD Position (corner of the screen)
-- Options: 'bottom-left', 'bottom-right', 'top-left', 'top-right'
Config.HudPosition = 'bottom-left'

-- HUD Size (scale factor: 0.5 = half size, 1.0 = normal, 1.5 = bigger)
Config.HudScale = 1.0

-- Show the ugly GTA V notifications (true = show, false = hide)
Config.ShowNotifications = false  -- <--- CAMBIADO A FALSE POR DEFECTO

-- ============================================
-- HANDBRAKE SETTINGS
-- ============================================
Config.HandbrakeKey = 'LSHIFT'
Config.EnableLogs = true
Config.SyncDistance = 50.0

-- Physics
Config.GravityForce = 6.0
Config.SlopeAngle = 1.5
Config.MaxRollSpeed = 40.0
Config.HandbrakeFriction = 0.15
Config.HandbrakeSpeedThreshold = 15.0

-- Language (en, es, fr, de, pt, ru, it, zh, ja, ko, ar, nl, pl, sv, tr)
Config.Locale = 'es'