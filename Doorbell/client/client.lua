ESX = exports["es_extended"]:getSharedObject()

local createdCamera = 0
local zeit = nil
local isDisplayingBellText = false
local isDisplayingCameraText = false
local cameraActive = false

local function notifyPlayer(xPlayer, title, description, duration, type)
    TriggerClientEvent('ox_lib:notify', xPlayer.source, {
        title = title,
        description = description,
        duration = duration,
        type = type
    })
end

local function PlayAnimation(dict, anim, duration)
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
        if not isDisplayingBellText then
            lib.showTextUI(Config.Ring)
            isDisplayingBellText = true
        end
        local ped = PlayerPedId()
        local playerCoords = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(playerCoords, job.coords.x, job.coords.y, job.coords.z, true)

        if IsControlJustReleased(0, 38) and distance <= Config.DrawDistance then 
            PlayAnimation("anim@apt_trans@buzzer", "buzz_reg", 1500) 
            TriggerEvent('InteractSound_CL:PlayOnOne', Config.SoundName, 0.2) 
            TriggerServerEvent('es_doorbell:NotifyJob', job.job)
            zeit = Config.WaitingTime
            if Config.UseInteractSound then
                TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 3.5, Config.SoundName, 0.2)
            end
            TriggerEvent("es_doorbell:startwaittime")
        end
    else
        lib.showTextUI(Config.Wait1 .. zeit .. Config.Wait2)
    end
end

local function displayCameraText()
    if not isDisplayingCameraText then
        lib.showTextUI(Config.CameraTextKey)
        isDisplayingCameraText = true
    end
end

local function hideCameraText()
    if isDisplayingCameraText then
        lib.hideTextUI()
        isDisplayingCameraText = false
    end
end

function createBellProps()
    for _, job in ipairs(Config.Bells) do
        if job.bellcoords then
            local prop = CreateObject(GetHashKey('prop_door_bell_01'), job.bellcoords.x, job.bellcoords.y, job.bellcoords.z, true, false, false)
            SetEntityHeading(prop, job.heading or 0.0) 
            FreezeEntityPosition(prop, true)
        end
    end
end

function deleteBellProps()    
    for _, handle in pairs(GetGamePool('CObject')) do               
        local hdlCoord = GetEntityCoords(handle)                    
        
        for _, job in ipairs(Config.Bells) do                       
            local coord = job.bellcoords                            

            if GetDistanceBetweenCoords(hdlCoord, coord) < 0.1 then 
                SetEntityAsMissionEntity(handle, true, true)
                DeleteObject(handle)                                
            end
        end
    end
end

Citizen.CreateThread(function()
    deleteBellProps()   
    Wait(1000)
    createBellProps()   
end)

Citizen.CreateThread(function()
    while true do
        local pedPos = GetEntityCoords(PlayerPedId())
        local isNearBell = false

        for _, job in ipairs(Config.Bells) do    
            local distance = GetDistanceBetweenCoords(pedPos, job.coords.x, job.coords.y, job.coords.z, true)
            
            if distance <= 2 then
                isNearBell = true
                handleBellInteraction(job)
                break 
            end
        end

        if not isNearBell then
            if isDisplayingBellText then
                lib.hideTextUI()
                isDisplayingBellText = false
            end
            Citizen.Wait(500) 
        else
            Citizen.Wait(0) 
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local pedPos = GetEntityCoords(PlayerPedId())
        local playerJob = ESX.GetPlayerData().job
        local isNearCamera = false

        for _, job in ipairs(Config.Bells) do
            local cameraPos = Config.CameraPositions[job.job]
            if cameraPos then
                local distance = Vdist(pedPos.x, pedPos.y, pedPos.z, cameraPos.position.x, cameraPos.position.y, cameraPos.position.z)
                if distance <= 2.0 then
                    isNearCamera = true
                    DrawMarker(1, cameraPos.position.x, cameraPos.position.y, cameraPos.position.z - 0.98, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3, 255, 255, 255, 200, false, true, 2, false, false, false, false)
                    if job.job == playerJob.name then
                        displayCameraText()
                        if IsControlJustPressed(1, 38) and createdCamera == 0 and distance <= 1.2 then
                            SetFocusArea(cameraPos.position.x, cameraPos.position.y, cameraPos.position.z, cameraPos.position.x, cameraPos.position.y, cameraPos.position.z)
                            DisplayCamera(job.job)
                            SendNUIMessage({ type = "enablecam", label = job.job, box = job.job })
                            createdCamera = 1
                            FreezeEntityPosition(PlayerPedId(), true)
                        elseif IsControlJustPressed(1, 38) and createdCamera ~= 0 then
                            CloseSecurityCamera()
                            createdCamera = 0
                            FreezeEntityPosition(PlayerPedId(), false)
                        end
                    end
                end
            end
        end

        if not isNearCamera then
            hideCameraText()
            Citizen.Wait(500)
        else
            Citizen.Wait(0)
        end
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local isNearBell = false
        
        for _, s in ipairs(Config.Bells) do
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

function DisplayCamera(job)
    local cameraPos = Config.CameraPositions[job]
    if cameraPos then
        ChangeSecurityCamera(cameraPos.position.x, cameraPos.position.y, cameraPos.position.z, cameraPos.rotation, cameraPos.viewPosition)
    end
end

function ChangeSecurityCamera(x, y, z, rotation, viewPosition)
    if createdCamera ~= 0 then
        DestroyCam(createdCamera, 0)
        createdCamera = 0
    end

    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, viewPosition.x, viewPosition.y, viewPosition.z)
    SetCamRot(cam, rotation.x, rotation.y, rotation.z, 2)
    RenderScriptCams(1, 0, 0, 1, 1)

    ClearTimecycleModifier()
    SetTimecycleModifier("CAMERA_BW")
    SetTimecycleModifierStrength(0.5)
    
    Citizen.Wait(250)
    createdCamera = cam
end

function CloseSecurityCamera()
    DestroyCam(createdCamera, 0)
    RenderScriptCams(0, 0, 1, 1, 1)
    createdCamera = 0
    ClearTimecycleModifier("scanline_cam_cheap")
    SetFocusEntity(PlayerPedId())
    if Config.CameraPositions.HideRadar then
        DisplayRadar(true)
    end
    FreezeEntityPosition(PlayerPedId(), false)
end

if Config.debug then
    RegisterCommand("debugdel", function(source, args, rawCommand)
        deleteBellProps()
    end)
end
