Config = {}

Config.debug = true
Config.Bell = "Doorbell"
Config.YouRang = "You rang the bell"
Config.SomeoneRang = "Someone rang the bell"
Config.Ring = "[E] - Doorbell"
Config.CameraTextKey = "[E] - Open Camera"

Config.Wait1 = "Wait "
Config.Wait2 = " seconds"
Config.UseInteractSound = true --REQUIRES: https://github.com/plunkettscott/interact-sound/releases 
Config.SoundName = "doorbell"
Config.DrawDistance    = 10.0

-- Put here the time the player needs to wait before he can ring again (in seconds)
Config.WaitingTime = 15

-- SETTINGS BELLS

Config.Bells = {
    {
        coords = vec3(431.53, -985.4, 30.73),  -- Enter bell position 
        bellcoords = vec3(431.63, -985.3, 30.73),  -- Doorbell prop position
        heading = 270.0,  --Props angle
        job = 'police'  -- Enter job name here
    },
    {
        coords = vec3(431.53, -985.4, 30.73),  -- Enter bell position 
        bellcoords = vec3(431.63, -985.2, 30.73),  -- Doorbell prop position
        heading = 270.0,  --Props angle
        job = 'ambulance'  -- Enter job name here
    },
    -- Add other bells with contact details and corresponding jobs here
}

-- SETTINGS CAMERA POSITIONS

Config.CameraPositions = {
    police = { 
        position = vector3(453.7, -983.95, 30.73), -- Point to view camera
        rotation = vector3(0.0, 0.0, 90.0), -- Camera direction angle (x, y, z)
        viewPosition = vector3(431.53, -985.4, 30.73) -- Camera view position
    },
    -- Add camera positions for other jobs here
}
