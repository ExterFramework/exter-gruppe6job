Config = {}

--[[
    Framework configuration
    Supported: qbcore, esx, qbox, standalone
]]
Config.Framework = 'auto' -- auto | qbcore | esx | qbox | standalone
Config.FrameworkFolder = 'qb-core' -- used when Framework is not auto

--[[
    Inventory configuration
    Supported: qb-inventory, ox_inventory, esx_inventory, qs-inventory, codem-inventory, standalone
]]
Config.Inventory = 'auto' -- auto | qb-inventory | ox_inventory | esx_inventory | qs-inventory | codem-inventory | standalone

--[[
    Fuel configuration
    Supported: LegacyFuel, cdn-fuel, ox_fuel, qb-fuel, ps-fuel, standalone
]]
Config.FuelSystem = 'auto' -- auto | LegacyFuel | cdn-fuel | ox_fuel | qb-fuel | ps-fuel | standalone

Config.AutoDetect = {
    Frameworks = {
        { name = 'qbox', resource = 'qbx_core' },
        { name = 'qbcore', resource = 'qb-core' },
        { name = 'esx', resource = 'es_extended' },
    },
    Inventories = {
        { name = 'ox_inventory', resource = 'ox_inventory' },
        { name = 'qb-inventory', resource = 'qb-inventory' },
        { name = 'qs-inventory', resource = 'qs-inventory' },
        { name = 'esx_inventory', resource = 'esx_inventoryhud' },
        { name = 'codem-inventory', resource = 'codem-inventory' },
    },
    FuelSystems = {
        { name = 'ox_fuel', resource = 'ox_fuel' },
        { name = 'LegacyFuel', resource = 'LegacyFuel' },
        { name = 'cdn-fuel', resource = 'cdn-fuel' },
        { name = 'qb-fuel', resource = 'qb-fuel' },
        { name = 'ps-fuel', resource = 'ps-fuel' },
    }
}

--[[ Runtime / QoL ]]
Config.StartJobTime = math.random(10000, 30000)
Config.CooldownTime = math.random(1 * 60 * 1000, 2 * 60 * 1000)
Config.DebugPrint = false
Config.StartDeliveryTime = math.random(10000, 30000)

--[[ Props ]]
Config.BagsPropModels = {
    'ba_prop_battle_bag_01a'
}

--[[ Vehicles ]]
Config.SpeedoVehicle = 'gruppe6van'
Config.StockadeVehicle = 'stockade'
Config.BrickadeVehicle = 'brickade'

Config.WorkVehicles = {
    { model = 'gruppe6van', coords = vector4(-33.9608, -673.7042, 32.1190, 187.9795), price = 2000 },
    { model = 'stockade', coords = vector4(-19.1917, -672.4606, 31.9424, 182.4225), price = 15000 },
    { model = 'brickade', coords = vector4(-4.7091, -672.3158, 32.6851, 187.4057), price = 40000 },
}

Config.propLocations = {
    {x = -0.3, y = -1.0, z = -0.25}, {x = 0.3, y = -1.0, z = -0.25}, {x = 1, y = -1.0, z = -0.25},
    {x = -0.3, y = -2.0, z = -0.25}, {x = 0.3, y = -2.0, z = -0.25}, {x = 1, y = -2.0, z = -0.25},
    {x = -0.3, y = -1.0, z = -0.0}, {x = 0.3, y = -1.0, z = -0.0}, {x = 1, y = -1.0, z = -0.0},
    {x = -0.3, y = -2.0, z = -0.0}, {x = 0.3, y = -2.0, z = -0.0}, {x = 1, y = -2.0, z = -0.0},
}

Config.StockadePropLocations = {
    {x = -0.3, y = -1.0, z = 0.4}, {x = 0.3, y = -1.0, z = 0.4}, {x = 1, y = -1.0, z = 0.4},
    {x = -0.3, y = -1.7, z = 0.4}, {x = 0.3, y = -1.7, z = 0.4}, {x = 1, y = -1.7, z = 0.4},
    {x = -0.3, y = -1.0, z = 0.65}, {x = 0.3, y = -1.0, z = 0.65}, {x = 1, y = -1.0, z = 0.65},
    {x = -0.3, y = -1.7, z = 0.65}, {x = 0.3, y = -1.7, z = 0.65}, {x = 1, y = -1.7, z = 0.65},
    {x = -0.3, y = -2.4, z = 0.4}, {x = 0.3, y = -2.4, z = 0.4}, {x = 1, y = -2.4, z = 0.4},
    {x = -0.3, y = -2.98, z = 0.4}, {x = 0.3, y = -2.98, z = 0.4}, {x = 1, y = -2.98, z = 0.4},
    {x = -0.3, y = -2.4, z = 0.65}, {x = 0.3, y = -2.4, z = 0.65}, {x = 1, y = -2.4, z = 0.65},
    {x = -0.3, y = -2.98, z = 0.65}, {x = 0.3, y = -2.98, z = 0.65}, {x = 1, y = -2.98, z = 0.65},
}

Config.Contracts = {
    { index = 1, tier = 1, requiredRep = 0, type = 'Bank Delivery', veh = 'Speedo', bags = 12, payout = 532, gainRep = 0.2 },
    { index = 2, tier = 2, requiredRep = 150, type = 'Refill Atm', veh = 'Stockade', bags = 24, payout = 1532, gainRep = 1 },
    { index = 3, tier = 3, requiredRep = 300, type = 'Bank Delivery', veh = 'Stockade', bags = 24, payout = 1344, gainRep = 0.3 },
    { index = 4, tier = 4, requiredRep = 300, type = 'Bank Delivery', veh = 'Blockade', bags = 40, payout = 1653, gainRep = 0.5 },
}

Config.CentralBank = vector4(-1318.0621, -832.3465, 16.9693, 129.8353)

Config.Pickups = {
    vector4(143.0965, -1043.7474, 28.3679, 331.3074), vector4(307.4865, -282.1480, 53.1646, 338.3643),
    vector4(-357.6189, -52.7991, 48.0364, 339.4532), vector4(-1215.1132, -337.3853, 36.7808, 21.8552),
    vector4(-2957.9370, 477.4565, 14.6969, 81.8521), vector4(1180.3684, 2711.5984, 37.0878, 177.3706),
    vector4(-103.2327, 6469.9932, 30.6267, 126.2157), vector4(417.2283, -986.8294, 28.4038, 87.1777),
    vector4(89.5961, -1745.1992, 29.0871, 323.7994), vector4(-33.5231, -1101.8055, 26.2744, 81.9511),
    vector4(975.2338, 13.4697, 80.0410, 199.8926), vector4(-546.8247, -207.3085, 37.0825, 229.8685),
    vector4(-1178.0718, -891.3958, 12.7654, 9.7767),
}

Config.AtmProps = {'prop_atm_01', 'prop_atm_02', 'prop_fleeca_atm', 'prop_atm_03'}

Config.Atms = {
    vector3(89.7633, 2.3376, 68.3069), vector3(147.5608, -1035.6760, 29.3432), vector3(112.7072, -819.3462, 31.3375),
    vector3(-258.7773, -723.3928, 33.4680), vector3(-866.7311, -187.6472, 37.8430), vector3(-821.5939, -1082.0067, 11.1324),
    vector3(-710.0455, -818.8943, 23.7289), vector3(-712.9207, -819.0791, 23.7289), vector3(-2072.3391, -317.2032, 13.3160),
}
