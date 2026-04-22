if Config.Framework == 'QBCore'then
    QBCore = exports[Config.FrameworkFolder]:GetCoreObject()
else
    ESX = exports[Config.FrameworkFolder]:getSharedObject()
end

RegisterNetEvent("exter-gruppe6job:sv:Grantcompletion", function(totalpickupNumber, grpId, bankId, index, dist)
    local src = source

    local calculatedPay = Config.Contracts[index].payout

    --Check if the player is close to the central bank as a verification that he actually did the job
    -- and aint just farming with the group
    if dist <= 50 then
        
        if Config.Framework == 'QBCore'then
            local Player = QBCore.Functions.GetPlayer(src)
            Player.Functions.AddMoney("cash", calculatedPay, "g6pay")
        else
            local xPlayer = ESX.GetPlayerFromId(src)
            xPlayer.addAccountMoney("money", calculatedPay)
        end
        
        --QBCore.Functions.Notify("You got paid "..calculatedPay.." for the last contract!", src, "success")
        --You can here actually check for the total of bages delivered inside bankId 
--[[         print(source)
        print(calculatedPay)
        print(Config.Contracts[index].gainRep) ]]
        TriggerEvent("exter-contacts:modifyRepS", source, "Gruppe 6", Config.Contracts[index].gainRep)
    end

    exports["exter-groupsystem"]:GroupEvent(grpId, "exter-gruppe6job:CompleteDelivery", {}) 
end)

RegisterNetEvent("exter-gruppe6job:sv:SetStashItems", function(StashName, itms)
    local src = source
    if Config.Inventory == "qb-inventory" then
        TriggerEvent('inventory:server:SetStashItems', StashName, itms)

    elseif Config.Inventory == "ox_inventory" then

        local inventory = exports.ox_inventory:GetInventory(StashName, false)
        if inventory == nil or inventory == false then
            exports.ox_inventory:RegisterStash(StashName, StashName, 20, 3300000)
        end
        if isTableEmpty(itms) then

            exports.ox_inventory:ClearInventory(StashName, false)
        else
            for _, item in ipairs(itms) do
                local uniqueId = tostring(math.random(100000, 999999))

                exports.ox_inventory:AddItem(StashName, item.name, item.amount, {uniqueId = uniqueId})
            end
        end
    end
end)

RegisterNetEvent("exter-gruppe6job:sv:OpenInventory", function(storageId, weight, slots)
    local src = source
    if Config.Inventory == "qb-inventory" then
        weight = weight or 3300000
        slots = slots or 40
        if storageId then
            TriggerClientEvent("inventory:client:SetCurrentStash", src, storageId)
            Wait(0)
            TriggerEvent("inventory:server:OpenInventory", "stash", storageId, {
                maxweight = weight,
                slots = slots,
            })
        else
        end
    elseif Config.Inventory == "ox_inventory" then
        local weight = weight or 3300000
        local slots = slots or 40
        local inventory = exports.ox_inventory:GetInventory(storageId, false)
        print(json.encode(inventory, { indent = true }))
        if inventory == nil or inventory == false then
            exports.ox_inventory:RegisterStash(storageId, storageId, slots, weight)
        end
        exports.ox_inventory:forceOpenInventory(src, 'stash', storageId)
    end
end)

if Config.Framework == 'QBCore'then
    QBCore.Functions.CreateCallback('exter-contacts:getReps', function(source, cb, domain)
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        if not Player then
            cb(nil)
            return
        end
    
        local citizen_id = Player.PlayerData.citizenid
    
        exports.oxmysql:execute('SELECT reputation FROM reputation WHERE citizen_id = ? AND domain = ?', {citizen_id, domain}, function(result)
            if result and result[0] then
                cb(result[0].reputation)
            else
                cb(0)
            end
        end)
    end)
else
    ESX.RegisterServerCallback('exter-contacts:getReps', function(source, cb, domain)
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        if not Player then
            cb(nil)
            return
        end
    
        local citizen_id = Player.PlayerData.citizenid
    
        exports.oxmysql:execute('SELECT reputation FROM reputation WHERE citizen_id = ? AND domain = ?', {citizen_id, domain}, function(result)
            if result and result[0] then
                cb(result[0].reputation)
            else
                cb(0)
            end
        end)
    end)
end

