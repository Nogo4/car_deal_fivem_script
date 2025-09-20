print("[NOGO: car_deal] Client script loaded")

TriggerServerEvent('nogo:get_job')

local menuState = false
local mainMenu = RageUI.CreateMenu("Concessionnaire", "Intéraction")
local current_car = 1
local currentExpoVehicle = nil

Citizen.CreateThread(function ()
    create_concess_ped()
end)

mainMenu.Closed = function ()
    menuState = false
    
    if currentExpoVehicle and DoesEntityExist(currentExpoVehicle) then
        DeleteEntity(currentExpoVehicle)
        currentExpoVehicle = nil
    end
end

function GetClosestPlayer(maxDistance)
    local maxDistance = maxDistance or 5.0
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    
    local closestPlayer = -1
    local closestDistance = maxDistance
    
    for _, playerId in pairs(GetActivePlayers()) do
        local targetPed = GetPlayerPed(playerId)
        
        if targetPed ~= playerPed and DoesEntityExist(targetPed) then
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(playerCoords - targetCoords)
            
            if distance < closestDistance then
                closestDistance = distance
                closestPlayer = GetPlayerServerId(playerId)
            end
        end
    end
    
    return closestPlayer, closestDistance
end

function GetPlayerInfo(playerId)
    local playerName = GetPlayerName(playerId)
    return {
        id = playerId,
        name = playerName or "Inconnu"
    }
end

function SpwanVehicleForVisual(vehiculeName)
    if currentExpoVehicle and DoesEntityExist(currentExpoVehicle) then
        DeleteEntity(currentExpoVehicle)
    end
    
    local vl = loadVehicule(vehiculeName)
    local vehicle = CreateVehicle(vl, Config.vl_spawn_pos.x, Config.vl_spawn_pos.y, Config.vl_spawn_pos.z, 90, true, false)
    
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleDoorsLocked(vehicle, 2)
    SetEntityInvincible(vehicle, true)
    FreezeEntityPosition(vehicle, true)
    SetVehicleEngineOn(vehicle, false, true, true)
    SetVehicleCanBeUsedByFleeingPeds(vehicle, false)
    SetVehicleCanBeVisiblyDamaged(vehicle, false)
    SetEntityProofs(vehicle, true, true, true, true, true, true, true, true)
    SetVehicleNumberPlateText(vehicle, "EXPO")
    currentExpoVehicle = vehicle
end

local function OpenConcessMenu()
    if menuState then
        return
    end

    menuState = true
    RageUI.Visible(mainMenu, true)
    SpwanVehicleForVisual(Config.vehicule_model_name[current_car])

    CreateThread(function ()

        while menuState do
            RageUI.IsVisible(mainMenu, function()

                RageUI.List("Liste voitures", Config.vehicules_label_list, current_car, nil, {}, true, {
                    onListChange = function(Index, Item)
                        current_car = Index
                        SpwanVehicleForVisual(Config.vehicule_model_name[current_car])
                    end
                })
                RageUI.Separator(string.format("Prix : %i$", Config.vehicules_price[current_car]))
                RageUI.Button("Acheter voiture", nil, {}, true, {
                    onSelected = function()
                        local plate = generate_plate()
                        print(plate)
                        TriggerServerEvent('nogo:pay', Config.vehicules_price[current_car], plate, Config.vehicule_model_name[current_car])
                        return
                    end
                })
            end)
            Wait(1)
        end
    end)
end

Citizen.CreateThread(function ()
    local ms = 500

    while true do
        Citizen.Wait(ms)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(playerCoords - vector3(Config.concess_ped.pos.x, Config.concess_ped.pos.y, Config.concess_ped.pos.z - 1))


        if distance < 2.0 then
            ms = 0
            SetTextComponentFormat("STRING")
            AddTextComponentString("Appuyer sur ~INPUT_CONTEXT~ pour ouvrir le menu du concessionnaire.")
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
            if IsControlJustReleased(0, 51) then
                OpenConcessMenu()
            end
        end
    end
    
end)

RegisterNetEvent('nogo:paid')
AddEventHandler('nogo:paid', function (plate)
    local vehicle_model = loadVehicule(Config.vehicule_model_name[current_car])

    if currentExpoVehicle and DoesEntityExist(currentExpoVehicle) then
        DeleteEntity(currentExpoVehicle)
    end
    local vehicule = CreateVehicle(vehicle_model, Config.vl_spawn_pos.x, Config.vl_spawn_pos.y, Config.vl_spawn_pos.z, Config.vl_spawn_pos.z, true, false)
    SetVehicleNumberPlateText(vehicule, plate)
end
)
