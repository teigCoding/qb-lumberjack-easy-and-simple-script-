local QBCore = exports['qb-core']:GetCoreObject()


RegisterNetEvent("qb-lumberjack:server:giveRewards")
AddEventHandler("qb-lumberjack:server:giveRewards", function(src)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src) 
    local amount = math.random(3,5)
    Player.Functions.AddItem(Config.TreeReward, amount)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.TreeReward], "add", amount)

end)

RegisterNetEvent('qb-lumberjack:server:rivAvBark')
AddEventHandler('qb-lumberjack:server:rivAvBark', function(src)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local stillHaveItem = true
    amountResources = 0
    item = Config.TreeReward
    if Player.Functions.GetItemByName(item) ~= nil then
        while stillHaveItem == true do
            if amountResources < 10 then
                if Player.Functions.GetItemByName(item) ~= nil then
                    amountResources = amountResources + 1
                    Player.Functions.RemoveItem(item, 1, k)
                else
                    stillHaveItem = false
                end
            else
                stillHaveItem = false
            end
        end
        TriggerClientEvent('qb-lumberjack:client:progress-bark',src,amountResources)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         --made by teig#7530

    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.no_logs"), "error")
    end
end)

RegisterNetEvent('qb-lumberjack:server:sell')
AddEventHandler('qb-lumberjack:server:sell', function(args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local prisPerTommer = Config.pricePerLog
    local prisPerPlanke = Config.pricePerProcessed

    local stillHaveItem = true
    price = 0
    amountResources = 0
    item = args.item
    if args.item == Config.TreeReward and Player.Functions.GetItemByName(Config.TreeReward) ~= nil then
        while stillHaveItem == true do
            if Player.Functions.GetItemByName(Config.TreeReward) ~= nil then
                amountResources = amountResources + 1
                Player.Functions.RemoveItem(Config.TreeReward, 1, k)
            else
                price = amountResources*prisPerTommer
                stillHaveItem = false
                --Player.Functions.AddMoney('cash', price)
                --TriggerClientEvent('QBCore:Notify', src, amountResources .." solgt for ".. price .. " kr", "success")
                --TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove", amountResources)
            end
        end
        TriggerClientEvent('qb-lumberjack:client:progress',src)
    elseif args.item == Config.ProcessReward and Player.Functions.GetItemByName(Config.ProcessReward) ~= nil then
        while stillHaveItem == true do
            if Player.Functions.GetItemByName(Config.ProcessReward) ~= nil then
                amountResources = amountResources + 1
                Player.Functions.RemoveItem(Config.ProcessReward, 1, k)
            else
                stillHaveItem = false
                price = (amountResources*prisPerPlanke)
                --Player.Functions.AddMoney('cash', price)
                --TriggerClientEvent('QBCore:Notify', src, amountResources .." solgt for ".. price .. " kr", "success")
                --TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove", amountResources)
            end
        end 
        TriggerClientEvent('qb-lumberjack:client:progress',src)

    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.nothing_tosell"), "error")
    end

end)


RegisterNetEvent("qb-lumberjack:server:payUser")
AddEventHandler("qb-lumberjack:server:payUser", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.AddMoney('cash', price,"tommer-salg")
    TriggerClientEvent('QBCore:Notify', src, amountResources ..Lang:t("success.sell").. price .. "!", "success")
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove", amountResources)

end)

RegisterNetEvent("qb-lumberjack:server:payUser-bark")
AddEventHandler("qb-lumberjack:server:payUser-bark", function(amountResources)

    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem(Config.ProcessReward, amountResources)
    --TriggerClientEvent('QBCore:Notify', src, Lang:t("success.process"), "success")
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.TreeReward], "remove", amountResources)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.ProcessReward], "add", amountResources)


end)

