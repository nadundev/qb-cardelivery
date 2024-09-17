local QBCore = exports['qb-core']:GetCoreObject()
local isDeliveryActive = false
local vehicleEntity
local vehicleBlip
local deliveryBlip
local startBlip
local deliveryZone

-- Function to create blips
local function CreateMissionBlip(coords, sprite, color, text)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
    return blip
end

-- Create start mission blip
CreateThread(function()
    startBlip = CreateMissionBlip(Config.StartLocation.xyz, 523, 5, "Start Exotic Car Delivery")
end)

-- Function to start the delivery mission
local function StartDeliveryMission()
    if not isDeliveryActive then
        isDeliveryActive = true
        local vehicleSpawnLocation = Config.VehicleSpawnLocations[math.random(#Config.VehicleSpawnLocations)]
        local vehicleHash = GetHashKey(Config.VehicleModel)

        RequestModel(vehicleHash)
        while not HasModelLoaded(vehicleHash) do
            Wait(0)
        end

        vehicleEntity = CreateVehicle(vehicleHash, vehicleSpawnLocation.x, vehicleSpawnLocation.y, vehicleSpawnLocation.z, vehicleSpawnLocation.w, true, false)
        SetVehicleEngineOn(vehicleEntity, true, true, false)
        SetEntityAsMissionEntity(vehicleEntity, true, true)

        vehicleBlip = CreateMissionBlip(vector3(vehicleSpawnLocation.x, vehicleSpawnLocation.y, vehicleSpawnLocation.z), 225, 5, "Exotic Car")
        deliveryBlip = CreateMissionBlip(Config.DeliveryLocation.xyz, 501, 5, "Delivery Location")

        QBCore.Functions.Notify('Find the exotic car and deliver it to the marked location', 'success')

        -- Create delivery zone
        CreateThread(function()
            while true do
                Wait(0)
                if isDeliveryActive then
                    local playerPed = PlayerPedId()
                    local playerCoords = GetEntityCoords(playerPed)
                    local distance = #(playerCoords - Config.DeliveryLocation.xyz)
        
                    if distance < 10.0 then
                        if IsPedInAnyVehicle(playerPed, false) then
                            local vehicle = GetVehiclePedIsIn(playerPed, false)
                            if vehicle == vehicleEntity then
                                DrawText3D(Config.DeliveryLocation.xyz, "Press ~g~E~w~ to deliver the vehicle")
                                if IsControlJustReleased(0, 38) then -- 38 is the key code for E
                                    CompleteMission()
                                end
                            end
                        end
                    else
                        Wait(1000)
                    end
                else
                    Wait(1000)
                end
            end
        end)
    else
        QBCore.Functions.Notify('You already have an active delivery mission', 'error')
    end
end

-- Function to complete the mission
function CompleteMission()
    if isDeliveryActive then
        isDeliveryActive = false
        DeleteVehicle(vehicleEntity)
        RemoveBlip(vehicleBlip)
        RemoveBlip(deliveryBlip)
        TriggerServerEvent('qb-exoticcarsteal:server:RewardPlayer', Config.DeliveryReward)
        QBCore.Functions.Notify('Vehicle delivered successfully', 'success')
        vehicleEntity = nil
        vehicleBlip = nil
        deliveryBlip = nil
    end
end

-- Event to start the delivery mission
RegisterNetEvent('qb-exoticcarsteal:client:StartDelivery', function()
    StartDeliveryMission()
end)

-- Create a target for starting the mission
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    CreateStartingPoint()
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    CreateStartingPoint()
end)

function CreateStartingPoint()
    exports['qb-target']:AddBoxZone("ExoticCarDeliveryStart", Config.StartLocation.xyz, 1.5, 1.5, {
        name = "ExoticCarDeliveryStart",
        heading = Config.StartLocation.w,
        debugPoly = false,
        minZ = Config.StartLocation.z - 1,
        maxZ = Config.StartLocation.z + 1,
    }, {
        options = {
            {
                type = "client",
                event = "qb-exoticcarsteal:client:StartDelivery",
                icon = "fas fa-car",
                label = "Start Exotic Car Delivery",
            },
        },
        distance = 2.5
    })
end