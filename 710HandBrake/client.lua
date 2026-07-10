-- client.lua
Config = Config or {}
Config.GravityForce = Config.GravityForce or 6.0
Config.SlopeAngle = Config.SlopeAngle or 1.5
Config.MaxRollSpeed = Config.MaxRollSpeed or 40.0
Config.HandbrakeFriction = Config.HandbrakeFriction or 0.15
Config.HandbrakeSpeedThreshold = Config.HandbrakeSpeedThreshold or 15.0
Config.SyncDistance = Config.SyncDistance or 50.0
Config.ShowNotifications = (Config.ShowNotifications == nil) and true or Config.ShowNotifications
Config.HandbrakeKey = Config.HandbrakeKey or 'LSHIFT'
Config.Locale = Config.Locale or 'en'
Config.HudStyle = Config.HudStyle or 'image_text'
Config.HudPosition = Config.HudPosition or 'bottom-left'
Config.HudScale = Config.HudScale or 1.0

-- ============================================
-- LANGUAGE SYSTEM
-- ============================================
Locales = Locales or {}
local function _(key)
    if Locales[Config.Locale] and Locales[Config.Locale][key] then
        return Locales[Config.Locale][key]
    elseif Locales['en'] and Locales['en'][key] then
        return Locales['en'][key]
    else
        return key
    end
end

-- ============================================
-- GLOBAL VARIABLES
-- ============================================
local isHandbrakeEngaged = false
local currentVehicle = nil
local lastVehicle = nil
local forceAccumulator = 0
local wasOnSlope = false
local isVehicleFrozen = false

-- ============================================
-- NUI FUNCTIONS (sounds and HUD)
-- ============================================
local function sendNUI(type, data)
    SendNUIMessage({
        type = type,
        data = data
    })
end

local function updateHandbrakeUI(engaged)
    sendNUI('updateHandbrake', { engaged = engaged })
end

local function playHandbrakeSound(engaged)
    if engaged then
        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    else
        PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    end
end

-- ============================================
-- MAIN FUNCTIONS
-- ============================================
local function getPlayerVehicle()
    local ped = PlayerPedId()
    return GetVehiclePedIsIn(ped, false)
end

local function showNotification(msg)
    if not Config.ShowNotifications then return end
    SetNotificationTextEntry('STRING')
    AddTextComponentString(msg)
    DrawNotification(false, true)
end

local function syncWithServer(vehicle, engaged)
    if not vehicle or vehicle == 0 then return end
    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    if netId and netId ~= 0 then
        TriggerServerEvent('handbrake:syncState', netId, engaged)
    end
end

local function getVehicleMass(vehicle)
    if not vehicle or not DoesEntityExist(vehicle) then return 1000.0 end
    local mass = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fMass')
    return (mass and mass > 0) and mass or 1000.0
end

-- ============================================
-- SLOPE DETECTION (by pitch)
-- ============================================
local function getSlopeDirection(vehicle)
    if not vehicle or not DoesEntityExist(vehicle) then return nil end
    local pitch = GetEntityPitch(vehicle)
    if math.abs(pitch) < Config.SlopeAngle then return nil end
    local forward = GetEntityForwardVector(vehicle)
    local dir
    if pitch > 0 then
        dir = vector3(-forward.x, -forward.y, -0.5)
    else
        dir = vector3(forward.x, forward.y, -0.5)
    end
    local len = math.sqrt(dir.x^2 + dir.y^2 + dir.z^2)
    if len < 0.001 then return nil end
    return vector3(dir.x / len, dir.y / len, dir.z / len)
end

local function applyGravityForce(vehicle)
    if not vehicle or not DoesEntityExist(vehicle) then return end
    local speedKmh = GetEntitySpeed(vehicle) * 3.6
    if speedKmh > Config.MaxRollSpeed then return end
    local slopeDir = getSlopeDirection(vehicle)
    if not slopeDir then return end
    local mass = getVehicleMass(vehicle)
    local baseForce = mass * Config.GravityForce * 0.08
    forceAccumulator = math.min(forceAccumulator + 0.03, 1.0)
    local currentForce = math.min(baseForce * forceAccumulator, mass * 1.5)
    local forceX = slopeDir.x * currentForce
    local forceY = slopeDir.y * currentForce
    local forceZ = slopeDir.z * currentForce - math.abs(currentForce) * 0.2
    ApplyForceToEntity(vehicle, 1, forceX, forceY, forceZ, 0,0,0,0,false,false,false,false,false)
end

-- ============================================
-- PROGRESSIVE HANDBRAKE (NO BRAKE LIGHTS)
-- ============================================
local function applyProgressiveHandbrake(vehicle)
    if not vehicle or not DoesEntityExist(vehicle) then return end
    local speed = GetEntitySpeed(vehicle)
    local speedKmh = speed * 3.6

    -- Low speed: normal handbrake + freeze when stopped
    if speedKmh < Config.HandbrakeSpeedThreshold then
        SetVehicleHandbrake(vehicle, true)
        if speed < 0.3 then
            FreezeEntityPosition(vehicle, true)
            isVehicleFrozen = true
        else
            FreezeEntityPosition(vehicle, false)
            isVehicleFrozen = false
        end
        return
    end

    -- High speed: smooth braking + drift
    SetVehicleHandbrake(vehicle, false)

    -- 1. Braking force opposite to movement
    local velocity = GetEntityVelocity(vehicle)
    local speedVec = math.sqrt(velocity.x^2 + velocity.y^2 + velocity.z^2)
    if speedVec > 0.1 then
        local dir = vector3(-velocity.x / speedVec, -velocity.y / speedVec, 0)
        local mass = getVehicleMass(vehicle)
        local forceMag = mass * Config.HandbrakeFriction * math.min(speedKmh / 50, 1.0)
        ApplyForceToEntity(vehicle, 1, dir.x * forceMag, dir.y * forceMag, 0, 0,0,0,0,false,false,false,false,false)
    end

    -- 2. Lateral force for drifting (manual right vector)
    local steer = GetVehicleSteeringAngle(vehicle)
    if math.abs(steer) > 0.1 then
        local forward = GetEntityForwardVector(vehicle)
        local right = vector3(-forward.y, forward.x, 0)
        local len = math.sqrt(right.x^2 + right.y^2)
        if len > 0.001 then
            right = vector3(right.x / len, right.y / len, 0)
            local lateralForce = steer * 0.2 * speed * 2
            ApplyForceToEntity(vehicle, 1, right.x * lateralForce, right.y * lateralForce, 0, 0,0,0,0,false,false,false,false,false)
        end
    end

    -- 3. Do not freeze while moving
    FreezeEntityPosition(vehicle, false)
    isVehicleFrozen = false
end

-- ============================================
-- HANDBRAKE TOGGLE (WITH LANGUAGE SUPPORT)
-- ============================================
local function toggleHandbrake()
    local vehicle = getPlayerVehicle()
    if not vehicle or vehicle == 0 then
        if Config.ShowNotifications then
            showNotification(_('not_in_vehicle'))
        end
        return
    end

    isHandbrakeEngaged = not isHandbrakeEngaged
    currentVehicle = vehicle
    lastVehicle = vehicle

    if isHandbrakeEngaged then
        applyProgressiveHandbrake(vehicle)
        syncWithServer(vehicle, true)
        if Config.ShowNotifications then
            showNotification(_('handbrake_on'))
        end
        updateHandbrakeUI(true)
        playHandbrakeSound(true)
    else
        FreezeEntityPosition(vehicle, false)
        SetVehicleHandbrake(vehicle, false)
        isVehicleFrozen = false
        forceAccumulator = 0
        wasOnSlope = false
        syncWithServer(vehicle, false)
        if Config.ShowNotifications then
            showNotification(_('handbrake_off'))
        end
        updateHandbrakeUI(false)
        playHandbrakeSound(false)
    end
end

-- ============================================
-- MAIN THREAD
-- ============================================
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)
        local vehicle = getPlayerVehicle()
        local ped = PlayerPedId()

        if vehicle and vehicle ~= 0 then
            lastVehicle = vehicle
            currentVehicle = vehicle
        end

        -- Inside vehicle (driver)
        if vehicle and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == ped then
            local speed = GetEntitySpeed(vehicle)
            local pitch = GetEntityPitch(vehicle)
            local onSlope = math.abs(pitch) > Config.SlopeAngle

            if isHandbrakeEngaged then
                applyProgressiveHandbrake(vehicle)
            end

            -- Rolling on slopes (only if handbrake is OFF)
            if not isHandbrakeEngaged then
                if onSlope and speed < 0.5 then
                    FreezeEntityPosition(vehicle, false)
                    SetVehicleHandbrake(vehicle, false)
                    SetVehicleCurrentGear(vehicle, 0)
                    applyGravityForce(vehicle)
                    wasOnSlope = true
                else
                    if wasOnSlope and not onSlope then
                        forceAccumulator = 0
                        wasOnSlope = false
                    end
                    if forceAccumulator > 0 then
                        forceAccumulator = math.max(0, forceAccumulator - 0.02)
                    end
                end
            end
        end

        -- Outside vehicle (remember last vehicle)
        if (not vehicle or vehicle == 0) and lastVehicle and DoesEntityExist(lastVehicle) then
            if not isHandbrakeEngaged then
                FreezeEntityPosition(lastVehicle, false)
                SetVehicleHandbrake(lastVehicle, false)
                SetVehicleCurrentGear(lastVehicle, 0)

                local pitch = GetEntityPitch(lastVehicle)
                local onSlope = math.abs(pitch) > Config.SlopeAngle
                local speed = GetEntitySpeed(lastVehicle)

                if onSlope and speed < 0.5 then
                    applyGravityForce(lastVehicle)
                    wasOnSlope = true
                else
                    if wasOnSlope and not onSlope then
                        forceAccumulator = 0
                        wasOnSlope = false
                    end
                    if forceAccumulator > 0 then
                        forceAccumulator = math.max(0, forceAccumulator - 0.02)
                    end
                end
            else
                FreezeEntityPosition(lastVehicle, true)
                SetVehicleHandbrake(lastVehicle, true)
                isVehicleFrozen = true
            end
        end
    end
end)

-- ============================================
-- ENVIAR ESTADO DEL VEHÍCULO AL NUI
-- ============================================
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        local vehicle = getPlayerVehicle()
        local inVehicle = (vehicle and vehicle ~= 0)
        sendNUI('setVehicleStatus', { inVehicle = inVehicle })
    end
end)

-- ============================================
-- SYNC EVENT (NO BRAKE LIGHTS)
-- ============================================
RegisterNetEvent('handbrake:syncState', function(vehicleNetId, isEngaged, playerSrc)
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    if vehicle and DoesEntityExist(vehicle) then
        if isEngaged then
            SetVehicleHandbrake(vehicle, true)
        else
            FreezeEntityPosition(vehicle, false)
            SetVehicleHandbrake(vehicle, false)
            SetVehicleCurrentGear(vehicle, 0)
        end
    end
end)

-- ============================================
-- MANUAL LSHIFT CAPTURE (Control 21)
-- ============================================
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 21) then
            local vehicle = getPlayerVehicle()
            if vehicle and vehicle ~= 0 then
                toggleHandbrake()
            end
        end
    end
end)

-- ============================================
-- CLEANUP ON RESTART
-- ============================================
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        if lastVehicle and DoesEntityExist(lastVehicle) then
            FreezeEntityPosition(lastVehicle, false)
            SetVehicleHandbrake(lastVehicle, false)
        end
    end
end)

-- ============================================
-- SEND HUD CONFIG TO NUI
-- ============================================
local function sendHudConfig()
    sendNUI('hudConfig', {
        hudStyle = Config.HudStyle or 'image_text',
        hudPosition = Config.HudPosition or 'bottom-left',
        hudScale = Config.HudScale or 1.0,
        hudLabel = _('hud_label'),
        hudOnText = _('hud_on'),
        hudOffText = _('hud_off')
    })
end

-- Send config when script starts
Citizen.CreateThread(function()
    Citizen.Wait(1000)
    sendHudConfig()
end)

print('^2[Handbrake] ' .. _('script_loaded_hud'))