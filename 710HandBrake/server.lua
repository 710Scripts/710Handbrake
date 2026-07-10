local handbrakeStates = {}

RegisterNetEvent('handbrake:syncState', function(vehicleNetId, isEngaged)
    local src = source
    local playerName = GetPlayerName(src)

    handbrakeStates[vehicleNetId] = {
        engaged = isEngaged,
        player = src,
        timestamp = os.time()
    }

    if Config.EnableLogs then
        print(string.format('^2[Handbrake] ^3%s ^7has %s the handbrake on vehicle %s',
            playerName,
            isEngaged and 'activated' or 'deactivated',
            vehicleNetId
        ))
    end

    TriggerClientEvent('handbrake:syncState', -1, vehicleNetId, isEngaged, src)
end)

RegisterNetEvent('handbrake:cleanup', function()
    local src = source
    for vehicleNetId, data in pairs(handbrakeStates) do
        if data.player == src then
            handbrakeStates[vehicleNetId] = nil
            TriggerClientEvent('handbrake:syncState', -1, vehicleNetId, false, src)
        end
    end
end)

-- Empty command to silence errors if someone types /handbrake in chat
RegisterCommand('handbrake', function(source, args, rawCommand)
    -- Does nothing, just prevents "unknown command" errors
end, false)