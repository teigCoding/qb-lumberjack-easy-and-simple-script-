local QBCore = exports['qb-core']:GetCoreObject()

-- BLIP ON MAP
blip = nil
function initializeBlip()
    local blipName = Config.BlipSettings.blipName
    local blipCoords = Config.BlipSettings.blipCoords
    blip = AddBlipForCoord(blipCoords.x, blipCoords.y, blipCoords.z)
    SetBlipScale(blip, 1.00) 
    SetBlipSprite(blip, 85)
    SetBlipColour(blip, 2)
    SetBlipAlpha(blip, 255) 
    AddTextEntry(blipName, blipName)
    BeginTextCommandSetBlipName(blipName) 
    SetBlipCategory(blip, 1)
    EndTextCommandSetBlipName(blip) 
    SetBlipAsShortRange(blip, true)


end

Citizen.CreateThread(initializeBlip) -- does not need to be done every frame, just once

RegisterNetEvent("qb-lumberjack:client:respawnTree")
AddEventHandler("qb-lumberjack:client:respawnTree", function(args)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  --made by teig#7530
    Wait(Config.TreeRespawnTime)
    Config.TreeLocations[args.number]["isChopped"] = false
end)


function axe()
    local ped = PlayerPedId()
    local pedWeapon = GetSelectedPedWeapon(ped)
    local weapon_required = GetHashKey(Config.weapon_required)
    if pedWeapon == weapon_required then
        return true
    end
end
local function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(3)
    end
end


RegisterNetEvent("qb-lumberjack:client:StartChopping")
AddEventHandler("qb-lumberjack:client:StartChopping", function(args)
    if Config.TreeLocations[args.number]["isChopped"] == false then
        if axe() then
            TriggerEvent("qb-lumberjack:client:respawnTree",args)
            local animDict = "melee@hatchet@streamed_core"
            local animName = "plyr_rear_takedown_b"
            local trClassic = PlayerPedId()
            chopping = true
            FreezeEntityPosition(trClassic, true)
            QBCore.Functions.Progressbar("job_progress", Lang:t("label.cutting"), 7000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
            Config.TreeLocations[args.number]["isChopped"] = true
            TaskPlayAnim(trClassic, animDict, "exit", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
            FreezeEntityPosition(trClassic, false)
            chopping = false
            TriggerServerEvent("qb-lumberjack:server:giveRewards",source)
            end, function()
                chopping = false
                ClearPedTasks(trClassic)
                TaskPlayAnim(trClassic, animDict, "exit", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
                FreezeEntityPosition(trClassic, false)
            end)
            CreateThread(function()
                while chopping do
                    loadAnimDict(animDict)
                    TaskPlayAnim(trClassic, animDict, animName, 3.0, 3.0, -1, 2, 0, 0, 0, 0 )
                    Wait(3000)
                end
            end)
        else
            TriggerEvent('QBCore:Notify', Lang:t("error.no_axe"), "error")
        end
    else
        TriggerEvent('QBCore:Notify', Lang:t("error.already_cut"), "error")
    end

end)


RegisterNetEvent('qb-lumberjack:client:progress')
AddEventHandler('qb-lumberjack:client:progress',function()
    ExecuteCommand('e idle11')
    QBCore.Functions.Progressbar("job_progress", Lang:t("label.selling"), 3000, false, true, {
        disableMovement = true,
    }, {}, {}, {}, function() -- Done
        ExecuteCommand('e c')
        TriggerServerEvent("qb-lumberjack:server:payUser",source)

    end)

end)

RegisterNetEvent('qb-lumberjack:client:progress-bark')
AddEventHandler('qb-lumberjack:client:progress-bark',function(amountResources)
    ExecuteCommand('e mechanic4')
    QBCore.Functions.Progressbar("job_progress", Lang:t("label.processing"), 7000, false, true, {
        disableMovement = true,
    }, {}, {}, {}, function() -- Done
    ExecuteCommand('e c')
    TriggerServerEvent("qb-lumberjack:server:payUser-bark",amountResources)

    end)

end)

RegisterNetEvent('qb-lumberjack:client:sellResources')
AddEventHandler('qb-lumberjack:client:sellResources',function()

    Citizen.CreateThread(function ()
        exports['qb-menu']:openMenu({
            {
                header = Lang:t("label.header"),
                isMenuHeader = true
            },
            {
                header = Lang:t("label.header2"),
                txt = Lang:t("label.header2_1"),
                params = {
                    isServer = true,
                    event = 'qb-lumberjack:server:sell',
                    args = {
                        item = Config.TreeReward
                    }
                }},
                {
                    header = Lang:t("label.header3"),
                    txt = Lang:t("label.header3_1"),
                    params = {
                        isServer = true,
                        event = 'qb-lumberjack:server:sell',
                        args = {
                            item = Config.ProcessReward
                        }
                    }},
              })
                
            
        end)
end)


RegisterNetEvent('qb-digging:client:rivBark')
AddEventHandler('qb-digging:client:rivBark', function()

    TriggerServerEvent('qb-lumberjack:server:rivAvBark',source)
end)

--Ped Lumberjack
local dealerPed = Config.Ped

Citizen.CreateThread(function()
	for _,v in pairs(dealerPed) do
		RequestModel(GetHashKey(v[7]))
		while not HasModelLoaded(GetHashKey(v[7])) do
			Wait(1)
		end
		CokeProcPed = CreatePed(4, v[6],v[1],v[2],v[3], 3374176, false, true)
		SetEntityHeading(CokeProcPed, v[5])
		FreezeEntityPosition(CokeProcPed, true)
		SetEntityInvincible(CokeProcPed, true)
		SetBlockingOfNonTemporaryEvents(CokeProcPed, true)
		TaskStartScenarioInPlace(CokeProcPed, "WORLD_HUMAN_AA_SMOKE", 0, true) 
	end
end)


--TARGETS
Citizen.CreateThread(function ()
    exports['qb-target']:AddBoxZone("sellhoggern", vector3(Config.Ped[1][1], Config.Ped[1][2], Config.Ped[1][3]), 1, 1, {
        name = "sellhoggern",
        heading = 256.69,
        debugPoly = false,
    }, {
        options = {
            {
                type = "Client",
                event = 'qb-lumberjack:client:sellResources',
                icon = "fa-solid fa-tree",
                label = Lang:t("label.sell_resources")
            }, 
        },
        distance = 2.5
    })
end)


CreateThread(function()
    for k, v in pairs(Config.TreeLocations) do
        exports["qb-target"]:AddBoxZone("trees" .. k, v.coords, 2, 2, {
            name = "trees" .. k,
            heading = 40,
            minZ = v.coords["z"] - 2,
            maxZ = v.coords["z"] + 2,
            debugPoly = false
        }, {
            options = { {
                    type = "client",
                    event = "qb-lumberjack:client:StartChopping",
                    icon = "fa-solid fa-tree",
                    label = Lang:t("label.cut"),
                    
                    number = k,
                    coords = v.coords,
                    
                }
            },
            distance = 1.1
        })
    end
    exports['qb-target']:AddBoxZone("rivbark", vector3(-551.75, 5329.45, 74.52), 2, 2, {
        name = "rivbark",
        heading = 340.22,
        minZ = 70,
        maxZ = 76,

        debugPoly = false,
    }, {
        options = {
            {
                type = "Client",
                event = 'qb-digging:client:rivBark',
                icon = "fa-solid fa-tree",
                label = Lang:t("label.process")
            },
        },
        distance = 2.5
    })
   
    
end)
