local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qb-exoticcarsteal:server:AlertPolice', function(coords)
    local src = source
    local alertData = {
        title = 'Exotic Car Theft',
        coords = coords,
        description = 'An exotic car has been stolen. Respond immediately!'
    }
    TriggerClientEvent('qb-policealerts:client:AddPoliceAlert', -1, alertData)
end)

RegisterNetEvent('qb-exoticcarsteal:server:PayPlayer', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.AddMoney('cash', Config.PaymentAmount)
        TriggerClientEvent('QBCore:Notify', src, 'You received $' .. Config.PaymentAmount .. ' for delivering the exotic car.', 'success')
    end
end)