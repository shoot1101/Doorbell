ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('es_doorbell:NotifyJob')
AddEventHandler('es_doorbell:NotifyJob', function(job)

    local xPlayers = ESX.GetPlayers()

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('ox_lib:notify', xPlayer.source, {title = Config.Bell, description = Config.YouRang, duration = 5000, type = 'success'})  
        if xPlayer.getJob().name == job then
            TriggerClientEvent('ox_lib:notify', xPlayer.source, {title = Config.Bell, description = Config.SomeoneRang, duration = 5000, type = 'inform'})
            TriggerClientEvent('InteractSound_CL:PlayOnOne', xPlayer.source, Config.SoundName, 0.1)
        end
    end

end)