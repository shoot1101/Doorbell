ESX = exports["es_extended"]:getSharedObject()


local function notifyPlayer(xPlayer, title, description, duration, type)
    TriggerClientEvent('ox_lib:notify', xPlayer.source, {
        title = title,
        description = description,
        duration = duration,
        type = type
    })
end

RegisterNetEvent('es_doorbell:NotifyJob')
AddEventHandler('es_doorbell:NotifyJob', function(job)
    local players = ESX.GetPlayers()

    for _, playerId in ipairs(players) do
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer and xPlayer.getJob().name == job then
            notifyPlayer(xPlayer, Config.Bell, Config.SomeoneRang, 5000, 'inform')
            TriggerClientEvent('InteractSound_CL:PlayOnOne', xPlayer.source, Config.SoundName, 1.3)
        end
    end
end)

PlayAnimation = function(dict, anim, duration)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
    TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, 1.0, duration, 49, 0, false, false, false)
    Wait(duration)
    ClearPedTasks(PlayerPedId())
end

local function handleBellInteraction(job)
    if zeit == nil or zeit <= 0 then
        lib.showTextUI(Config.Ring)
        if IsControlJustReleased(0, 38) then 
            PlayAnimation("anim@apt_trans@buzzer", "buzz_reg", 1500) 
            TriggerEvent('InteractSound_CL:PlayOnOne', Config.SoundName, 0.2) 
            TriggerServerEvent('es_doorbell:NotifyJob', job)
            zeit = Config.WaitingTime
            if Config.UseInteractSound then
                TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 3.5, Config.SoundName, 0.2)
            end
            TriggerEvent("es_doorbell:startwaittime")
        end
    elseif zeit >= 0 and zeit <= Config.WaitingTime then
        lib.showTextUI(Config.Wait1 ..zeit.. Config.Wait2)
    end
end

Citizen.CreateThread(function()
    for _, s in ipairs(Config.Bells) do
        local box = lib.zones.box({
            coords = s.coords,
            size = vec3(1, 1, 2),
            inside = function() handleBellInteraction(s.job) end,
            onExit = function() lib.hideTextUI() end
        })
    end
end)

RegisterNetEvent("es_doorbell:startwaittime")
AddEventHandler("es_doorbell:startwaittime", function()
    if zeit == nil then
        zeit = Config.WaitingTime
    end
    while zeit >= 0 do
        Citizen.Wait(1000)
        zeit = zeit - 1
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local isNearBell = false
        
        for __, s in ipairs(Config.Bells) do
            local distance = GetDistanceBetweenCoords(playerCoords, s.coords.x, s.coords.y, s.coords.z, true)
            if distance < 2.0 then
                isNearBell = true
                DrawMarker(1, s.coords.x, s.coords.y, s.coords.z - 0.98, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3, 255, 255, 255, 200, false, true, 2, false, false, false, false)
            end
        end
        
        if not isNearBell then
            Citizen.Wait(500) 
        end
    end
end)

