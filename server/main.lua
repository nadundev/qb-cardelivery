local QBCore = exports['qb-core']:GetCoreObject()

-- Event to reward the player for successful delivery
RegisterNetEvent('qb-exoticcarsteal:server:RewardPlayer', function(reward)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.AddMoney('bank', reward)
        TriggerClientEvent('QBCore:Notify', src, 'You received $' .. reward .. ' in your bank account for the delivery', 'success')
    end
end)

-- Command to start the delivery mission (for testing purposes)
QBCore.Commands.Add('startdelivery', 'Start the exotic car delivery mission', {}, false, function(source)
    TriggerClientEvent('qb-exoticcarsteal:client:StartDelivery', source)
end, 'admin')