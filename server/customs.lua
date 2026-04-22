local framework = Bridge.FrameworkName

RegisterNetEvent('exter-gruppe6job:sv:Grantcompletion', function(totalpickupNumber, grpId, bankId, index, dist)
    local src = source
    local contract = Config.Contracts[index]
    if not contract then return end

    if (dist or 9999) <= 50 then
        local pay = contract.payout or 0
        local player = GetPlayer(src)

        if player and pay > 0 then
            if framework == 'esx' then
                player.addAccountMoney('money', pay)
            else
                player.Functions.AddMoney('cash', pay, 'g6pay')
            end
        end

        TriggerEvent('exter-contacts:modifyRepS', src, 'Gruppe 6', contract.gainRep or 0)
    end

    exports['exter-groupsystem']:GroupEvent(grpId, 'exter-gruppe6job:CompleteDelivery', {})
end)

local function clearOrCreateStash(stashName, items)
    if Bridge.InventoryName == 'qb-inventory' then
        TriggerEvent('inventory:server:SetStashItems', stashName, items)
        return
    end

    if Bridge.InventoryName == 'ox_inventory' then
        local inventory = exports.ox_inventory:GetInventory(stashName, false)
        if not inventory then
            exports.ox_inventory:RegisterStash(stashName, stashName, 40, 3300000)
        end

        exports.ox_inventory:ClearInventory(stashName, false)
        for _, item in ipairs(items) do
            exports.ox_inventory:AddItem(stashName, item.name, item.amount or 1, item.info or {})
        end
        return
    end

    if framework == 'esx' then
        -- No universal ESX stash API, best-effort fallback for custom inventory bridges.
        TriggerEvent('exter-gruppe6job:inventory:setStashItems', stashName, items)
    end
end

RegisterNetEvent('exter-gruppe6job:sv:SetStashItems', function(stashName, items)
    clearOrCreateStash(stashName, items or {})
end)

RegisterNetEvent('exter-gruppe6job:sv:OpenInventory', function(storageId, weight, slots)
    local src = source
    weight = weight or 3300000
    slots = slots or 40

    if Bridge.InventoryName == 'qb-inventory' then
        TriggerClientEvent('inventory:client:SetCurrentStash', src, storageId)
        Wait(0)
        TriggerEvent('inventory:server:OpenInventory', 'stash', storageId, { maxweight = weight, slots = slots })
        return
    end

    if Bridge.InventoryName == 'ox_inventory' then
        local inventory = exports.ox_inventory:GetInventory(storageId, false)
        if not inventory then
            exports.ox_inventory:RegisterStash(storageId, storageId, slots, weight)
        end
        exports.ox_inventory:forceOpenInventory(src, 'stash', storageId)
        return
    end

    TriggerClientEvent('exter-gruppe6job:cl:openFallbackInventory', src, storageId)
end)

local function reputationCallback(source, cb, domain)
    local player = GetPlayer(source)
    if not player then
        cb(0)
        return
    end

    local citizenId = GetPlayerCID(source)
    if not citizenId then
        cb(0)
        return
    end

    exports.oxmysql:execute('SELECT reputation FROM reputation WHERE citizen_id = ? AND domain = ?', { citizenId, domain }, function(result)
        if result and result[1] then
            cb(result[1].reputation)
            return
        end

        cb(0)
    end)
end

RegisterCallback('exter-contacts:getRep', reputationCallback)
RegisterCallback('exter-contacts:getReps', reputationCallback)
