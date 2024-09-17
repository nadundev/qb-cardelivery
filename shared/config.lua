Config = {}

Config.PayPhoneLocation = vector3(-664.59, -671.46, 31.42) -- Location of the pay phone to start the mission
Config.ExoticCarLocations = {
    vector4(-1477.71, 520.84, 115.38, 285.94),
    vector4(-1805.39, 438.51, 128.37, 125.67),
    vector4(-1363.33, 624.6, 133.89, 25.92),
    -- Add more locations as needed
}

Config.DeliveryLocation = vector3(1173.67, 2634.37, 37.75) -- Location where the player needs to deliver the car
Config.DeliveryZoneRadius = 10.0 -- Radius of the delivery zone

Config.DeliveryMarkerType = 27 -- Marker type for the delivery location (https://docs.fivem.net/docs/game-references/markers/)
Config.DeliveryMarkerScale = vector3(5.0, 5.0, 5.0) -- Scale of the delivery marker
Config.DeliveryMarkerColor = {r = 255, g = 0, b = 0, a = 100} -- Color of the delivery marker (RGBA)

Config.PaymentAmount = 10000 -- Amount of money the player will receive upon successful delivery
