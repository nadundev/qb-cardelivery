Config = {}

Config.StartLocation = vector3(123.45, -678.90, 32.12) -- Location where players start the mission
Config.VehicleSpawnLocations = { -- Possible locations where the vehicle can spawn
    vector3(456.78, -901.23, 25.45),
    vector3(-234.56, 789.01, 32.67),
    -- Add more locations as needed
}
Config.DeliveryLocation = vector3(-901.23, 456.78, 25.45) -- Location where the vehicle needs to be delivered
Config.VehicleModel = 'adder' -- Model name of the vehicle to be delivered
Config.DeliveryReward = 10000 -- Reward amount for successful delivery
Config.DrawTextLocation = 'left' -- Location for drawing text ('left', 'right', 'top')
