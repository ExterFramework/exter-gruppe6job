Bridge = Bridge or {}

local function resourceStarted(name)
    local state = GetResourceState(name)
    return state == 'starting' or state == 'started'
end

local function detectFromList(preferred, list, fallback)
    if preferred and preferred ~= 'auto' then
        return preferred
    end

    for _, item in ipairs(list or {}) do
        if resourceStarted(item.resource) then
            return item.name
        end
    end

    return fallback
end

Bridge.FrameworkName = detectFromList((Config.Framework or 'auto'):lower(), Config.AutoDetect.Frameworks, 'standalone')
Bridge.InventoryName = detectFromList(Config.Inventory, Config.AutoDetect.Inventories, 'standalone')
Bridge.FuelName = detectFromList(Config.FuelSystem, Config.AutoDetect.FuelSystems, 'standalone')

function Bridge.Debug(message)
    if Config.DebugPrint then
        print(('[exter-gruppe6job] %s'):format(message))
    end
end

function Bridge.GetFrameworkObject()
    if Bridge.FrameworkName == 'qbcore' then
        local coreResource = Config.FrameworkFolder ~= 'qb-core' and Config.FrameworkFolder or 'qb-core'
        if not resourceStarted(coreResource) then coreResource = 'qb-core' end
        return exports[coreResource]:GetCoreObject()
    elseif Bridge.FrameworkName == 'qbox' then
        return exports.qbx_core:GetCoreObject()
    elseif Bridge.FrameworkName == 'esx' then
        local esxResource = Config.FrameworkFolder ~= 'es_extended' and Config.FrameworkFolder or 'es_extended'
        if not resourceStarted(esxResource) then esxResource = 'es_extended' end
        return exports[esxResource]:getSharedObject()
    end

    return nil
end

function Bridge.SetVehicleFuel(vehicle, fuel)
    fuel = fuel or 100

    if Bridge.FuelName == 'LegacyFuel' and resourceStarted('LegacyFuel') then
        exports['LegacyFuel']:SetFuel(vehicle, fuel)
        return true
    elseif Bridge.FuelName == 'cdn-fuel' and resourceStarted('cdn-fuel') then
        exports['cdn-fuel']:SetFuel(vehicle, fuel)
        return true
    elseif Bridge.FuelName == 'ox_fuel' and resourceStarted('ox_fuel') then
        Entity(vehicle).state.fuel = fuel
        return true
    elseif (Bridge.FuelName == 'qb-fuel' or Bridge.FuelName == 'ps-fuel') and (resourceStarted('qb-fuel') or resourceStarted('ps-fuel')) then
        exports[Bridge.FuelName]:SetFuel(vehicle, fuel)
        return true
    end

    if SetVehicleFuelLevel then
        SetVehicleFuelLevel(vehicle, fuel + 0.0)
    end

    return false
end

function maxVehFuel(vehicle)
    return Bridge.SetVehicleFuel(vehicle, 100)
end
