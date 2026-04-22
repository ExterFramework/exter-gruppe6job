Core = Bridge.GetFrameworkObject()

local framework = Bridge.FrameworkName

local function isQB()
    return framework == 'qbcore' or framework == 'qbox'
end

function GetPlayer(src)
    if not Core then return nil end
    if isQB() then
        return Core.Functions.GetPlayer(src)
    elseif framework == 'esx' then
        return Core.GetPlayerFromId(src)
    end
    return nil
end

function Notify(src, msg, typ)
    if framework == 'esx' then
        TriggerClientEvent('esx:showNotification', src, msg)
    else
        TriggerClientEvent('QBCore:Notify', src, msg, typ or 'primary')
    end
end

function GetItembyName(item, player)
    if not player or not item then return false end

    if Bridge.InventoryName == 'ox_inventory' then
        return (exports.ox_inventory:GetItem(player.PlayerData and player.PlayerData.source or player.source, item, nil, true) or 0) > 0
    end

    if isQB() then
        return player.Functions.GetItemByName(item) ~= nil
    end

    if framework == 'esx' then
        local invItem = player.getInventoryItem(item)
        return invItem and invItem.count and invItem.count > 0
    end

    return false
end

function GetPlayerCID(src)
    local player = GetPlayer(src)
    if not player then return nil end

    if isQB() then
        return player.PlayerData.citizenid
    elseif framework == 'esx' then
        return player.identifier
    end

    return tostring(src)
end

function GetPlayerCharName(src)
    local player = GetPlayer(src)
    if not player then return 'Unknown' end

    if isQB() then
        return (player.PlayerData.charinfo.firstname or '') .. ' ' .. (player.PlayerData.charinfo.lastname or '')
    elseif framework == 'esx' then
        return player.getName()
    end

    return ('Player %s'):format(src)
end

function RegisterCallback(name, func)
    if isQB() then
        Core.Functions.CreateCallback(name, func)
    elseif framework == 'esx' then
        Core.RegisterServerCallback(name, func)
    end
end

function ItemManager(item, amount, op, player, info)
    if not player then return false end

    if isQB() then
        if op == 'remove' then
            return player.Functions.RemoveItem(item, amount)
        end
        return player.Functions.AddItem(item, amount, false, info or {})
    elseif framework == 'esx' then
        if op == 'remove' then
            player.removeInventoryItem(item, amount)
        else
            player.addInventoryItem(item, amount)
        end
        return true
    end

    return false
end
