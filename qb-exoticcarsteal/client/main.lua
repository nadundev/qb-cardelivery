local QBCore = exports['qb-core']:GetCoreObject()
local isInMission = false
local currentVehicle = nil
local blip = nil
local deliveryZone = nil
local carBlip = nil
local deliveryBlip = nil

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    local payPhoneBlip = AddBlipForCoord(Config.PayPhoneLocation)
    SetBlipSprite(payPhoneBlip, 285)
    SetBlipDisplay(payPhoneBlip, 4)
    SetBlipScale(payPhoneBlip, 0.6)
    SetBlipColour(payPhoneBlip, 5)
    SetBlipAsShortRange(payPhoneBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Exotic Car Steal")
    EndTextCommandSetBlipName(payPhoneBlip)

    deliveryZone = BoxZone:Create(
        Config.DeliveryLocation,
        Config.DeliveryZoneRadius, Config.DeliveryZoneRadius, {
            name = "qb-exoticcarsteal_delivery_zone",
            heading = 0.0,
            debugPoly = false
        }
    )
end)

CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local payPhoneDistance = #(playerCoords - Config.PayPhoneLocation)

        if payPhoneDistance < 2.0 then
            sleep = 0
            if not isInMission then
                DrawText3D(Config.PayPhoneLocation.x, Config.PayPhoneLocation.y, Config.PayPhoneLocation.z, 'Press ~g~E~w~ to start the mission')
                if IsControlJustReleased(0, 38) then
                    StartMission()
                end
            end
        end

        if isInMission then
            sleep = 0
            local playerVehicle = GetVehiclePedIsIn(playerPed, false)

            if playerVehicle == currentVehicle then
                if IsPedInAnyVehicle(playerPed, false) then
                    if deliveryBlip == nil then
                        deliveryBlip = AddBlipForCoord(Config.DeliveryLocation)
                        SetBlipSprite(deliveryBlip, 501)
                        SetBlipColour(deliveryBlip, 5)
                        SetBlipRoute(deliveryBlip, true)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString("Delivery Location")
                        EndTextCommandSetBlipName(deliveryBlip)
                    end
                else
                    RemoveBlip(deliveryBlip)
                    deliveryBlip = nil
                end

                if deliveryZone:isPointInside(playerCoords) then
                    DrawText3D(Config.DeliveryLocation.x, Config.DeliveryLocation.y, Config.DeliveryLocation.z, 'Press ~g~E~w~ to deliver the car')
                    if IsControlJustReleased(0, 38) then
                        QBCore.Functions.DeleteVehicle(currentVehicle)
                        RemoveBlip(deliveryBlip)
                        TriggerServerEvent('qb-exoticcarsteal:server:PayPlayer')
                        QBCore.Functions.Notify('Mission completed! You received $' .. Config.PaymentAmount .. ' for delivering the exotic car.', 'success')
                        isInMission = false
                        currentVehicle = nil
                        blip = nil
                        carBlip = nil
                        deliveryBlip = nil
                    end
                end
            end
        end

        Wait(sleep)
    end
end)

function StartMission()
    isInMission = true
    local randomLocation = Config.ExoticCarLocations[math.random(1, #Config.ExoticCarLocations)]
    local vehicleModel = GetHashKey('t20')

    RequestModel(vehicleModel)
    while not HasModelLoaded(vehicleModel) do
        Wait(0)
    end

    currentVehicle = CreateVehicle(vehicleModel, randomLocation.x, randomLocation.y, randomLocation.z, randomLocation.w, true, true)
    SetEntityAsMissionEntity(currentVehicle, true, true)
    SetVehicleEngineOn(currentVehicle, true, true, true)
    SetVehicleFuelLevel(currentVehicle, 100.0)
    SetVehicleDoorsLocked(currentVehicle, 1)

    carBlip = AddBlipForEntity(currentVehicle)
    SetBlipSprite(carBlip, 225)
    SetBlipColour(carBlip, 5)
    SetBlipRoute(carBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Exotic Car")
    EndTextCommandSetBlipName(carBlip)

    QBCore.Functions.Notify('Go to the marked location and steal the exotic car. Deliver it to the delivery location to get paid.', 'success')
end

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    if isInMission then
        QBCore.Functions.DeleteVehicle(currentVehicle)
        RemoveBlip(carBlip)
        RemoveBlip(deliveryBlip)
        isInMission = false
        currentVehicle = nil
        blip = nil
        carBlip = nil
        deliveryBlip = nil
    end
end)
