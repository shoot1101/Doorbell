ESX = exports["es_extended"]:getSharedObject()

-- // Zone

local zeit = 0
local soundid = GetSoundId()

CreateThread(function()
    while true do 
        Wait(0)
        for __, s in ipairs(Config.Bells) do
            local coords = GetEntityCoords(PlayerPedId())
            if(GetDistanceBetweenCoords(coords, s.coords.x, s.coords.y, s.coords.z, true) < Config.DrawDistance) then

                DrawMarker(25, s.coords.x, s.coords.y, s.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 16, 192, 37, 100, false, true, 2, false, false, false, false)
    
            end
        end
    end
end)


CreateThread(function()

    for __, s in ipairs(Config.Bells) do

        function onExit(self)
            lib.hideTextUI()
        end
        
        function insideZone(self)

            if zeit <= 0 then

                lib.showTextUI(Config.Ring)

                if IsControlJustReleased(0,  38) then
                    TriggerServerEvent('es_doorbell:NotifyJob', s.job)
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

        local box = lib.zones.box({
            coords = s.coords,
            size = vec3(1, 1, 2),
            inside = insideZone,
            onExit = onExit
        })

    end

end)

RegisterNetEvent("es_doorbell:startwaittime")
AddEventHandler("es_doorbell:startwaittime", function()
    while zeit >= 0 do
        Wait(1000)
        zeit = zeit - 1
    end
end)
