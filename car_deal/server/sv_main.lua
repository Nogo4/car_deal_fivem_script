print("[NOGO: car_deal] Server script loaded")

local function pay_price(price, xPlayer)
    print("[concess_script] Vérification des fonds - Prix: " .. price)
    
    local response = MySQL.query.await('SELECT `accounts` FROM `users` WHERE `identifier` = ?', {
        xPlayer.identifier
    })

    if not response or #response == 0 then
        print("[concess_script] Erreur: Impossible de récupérer les comptes du joueur")
        xPlayer.showNotification("~r~Erreur lors de la récupération de vos comptes.")
        return false
    end

    response = json.decode(response[1].accounts)
    print("[concess_script] Argent en banque: " .. response.bank .. ", Prix demandé: " .. price)
    
    if response.bank >= price then
        print("[concess_script] Débit en cours...")
        MySQL.update.await('UPDATE `users` SET `accounts` = ? WHERE `identifier` = ?', {
            json.encode({
                bank = response.bank - price,
                money = response.money,
                black_money = response.black_money
            }),
            xPlayer.identifier
        })
        print("[concess_script] Débit effectué - Nouveau solde: " .. (response.bank - price))
        xPlayer.showNotification(string.format("Vous avez payé ~g~$%d~s~ pour la voiture.", price))
        return true
    else
        print("[concess_script] Fonds insuffisants")
        xPlayer.showNotification("~r~Vous n'avez pas assez d'argent sur vous.")
        return false
    end
end

local function add_vl_in_db(vl_model, plate, owner)
    MySQL.insert.await('INSERT INTO owned_vehicles (owner, plate, vehicle, type, job, stored) VALUES (?, ?, ?, ?, ?, ?)', {
        owner,
        plate,
        json.encode({
            model = GetHashKey(vl_model),
            plate = plate
        }),
        'car',
        '(NULL)',
        0,
    })
end

RegisterNetEvent('nogo:pay')
AddEventHandler('nogo:pay', function (price, plate, vl_model)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    
    if xPlayer then
        if pay_price(price, xPlayer) then
            add_vl_in_db(vl_model, plate, xPlayer.identifier)
            TriggerClientEvent('nogo:paid', _source, plate)
        end
    end
end)
