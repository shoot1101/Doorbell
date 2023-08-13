Config = {}

Config.Bell = "Doorbell"
Config.YouRang = "You rang the bell"
Config.SomeoneRang = "Someone rang the bell"
Config.Ring = "[E] - Doorbell"
Config.Wait1 = "Wait "
Config.Wait2 = " seconds"
Config.UseInteractSound = true --REQUIRES: https://github.com/plunkettscott/interact-sound/releases 
Config.SoundName = "doorbell"
Config.DrawDistance    = 10.0

-- // SETTINGS //

-- Put here the time the player needs to wait before he can ring again (in seconds)
Config.WaitingTime = 30

-- //  SETTINGS BELLS //

Config.Bells = {

    {
        coords = vec3(-283.87, 281.44, 88.89),  -- Enter bell position
        job = 'police'  -- Enter job name here
    },

    {
        coords = vec3(300.2, -581.32, 42.36),  
        job = 'ambulance'
    },
	
	{
        coords = vec3(58.18, -1581.44, 28.6),   
        job = 'mechanic'
    },
	
	{
        coords = vec3(-543.82, -203.32, 37.32),     
        job = 'gouvernement'
    },
	
	{
        coords = vec3(170.78, -1044.42, 28.32),  
        job = 'vigneron'
    },
	
	{
        coords = vec3(130.19, -1298.31, 28.24),
        job = 'nightclub'
    },

    {
        coords = vec3(908.88, -158.87, 73.25),
        job = 'taxi'
    },

    {
        coords = vec3(-710.42, -916.94, 18.51),
        job = 'shop'
    }
}

