local QBCore = exports['qb-core']:GetCoreObject()
local isDeliveryActive = false
local vehicleEntity
local vehicleBlip
local deliveryBlip

-- Event to start the delivery mission
RegisterNetEvent('qb-exoticcarsteal:client:StartDelivery', function()
    if not isDeliveryActive then
        isDeliveryActive = true
        local vehicleSpawnLocation = Config.VehicleSpawnLocations[math.random(#Config.VehicleSpawnLocations)]
        local vehicleHash = GetHashKey(Config.VehicleModel)

        RequestModel(vehicleHash)
        while not HasModelLoaded(vehicleHash) do
            Wait(0)
        end

        vehicleEntity = CreateVehicle(vehicleHash, vehicleSpawnLocation, GetEntityHeading(PlayerPedId()), true, false)
        SetVehicleEngineOn(vehicleEntity, true, true, false)
        SetEntityAsMissionEntity(vehicleEntity, true, true)

        vehicleBlip = AddBlipForEntity(vehicleEntity)
        SetBlipSprite(vehicleBlip, 225)
        SetBlipColour(vehicleBlip, 5)
        SetBlipAsShortRange(vehicleBlip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Exotic Car")
        EndTextCommandSetBlipName(vehicleBlip)

        deliveryBlip = AddBlipForCoord(Config.DeliveryLocation)
        SetBlipSprite(deliveryBlip, 501)
        SetBlipColour(deliveryBlip, 5)
        SetBlipAsShortRange(deliveryBlip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Delivery Location")
        EndTextCommandSetBlipName(deliveryBlip)

        QBCore.Functions.Notify('Find the exotic car and deliver it to the marked location', 'success')
    else
        QBCore.Functions.Notify('You already have an active delivery mission', 'error')
    end
end)

-- Thread for checking if the player is near the delivery location
CreateThread(function()
    local deliveryZone = CreatePolyZone(Config.DeliveryLocation, 10.0, 10.0, false)

    while true do
        local sleep = 1000
        if isDeliveryActive then
            sleep = 0
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local vehicleCoords = GetEntityCoords(vehicleEntity)

            if deliveryZone:isPointInside(playerCoords) and #(playerCoords - vehicleCoords) < 10.0 then
                DrawText3D(Config.DeliveryLocation, "Press [E] to deliver the vehicle")
                if IsControlJustReleased(0, 38) then
                    isDeliveryActive = false
                    DeleteVehicle(vehicleEntity)
                    RemoveBlip(vehicleBlip)
                    RemoveBlip(deliveryBlip)
                    TriggerServerEvent('qb-exoticcarsteal:server:RewardPlayer', Config.DeliveryReward)
                    QBCore.Functions.Notify('Vehicle delivered successfully', 'success')
                end
            end
        end
        Wait(sleep)
    end
end)

-- Event to start the delivery mission (triggered from server or command)
RegisterNetEvent('qb-exoticcarsteal:client:StartDelivery', function()
    TriggerEvent('qb-exoticcarsteal:client:StartDelivery')
end)