Config = {}

--[[ Framework & Inventory Configurations ]]

Config.Framework = 'QBCore' -- QBCore or ESX

Config.FrameworkFolder = 'qb-core' -- qb-core or es_extended

Config.Inventory = 'qb-inventory' -- qb-inventory & ox_inventory


--[[ Start Job - Waiting for Offer Time.. ]]

Config.StartJobTime = math.random(10000, 30000) -- 10 - 30 seconds..


--[[ Cooldown to start a new Delivery Contract ]]

-- Config.CooldownTime = math.random(3 * 60 * 1000, 5 * 60 * 1000) -- Min 3 minutes - Max 5 minutes

Config.CooldownTime = math.random(1 * 60 * 1000, 2 * 60 * 1000)

--[[ Developer Mode ( to use prints ) ]]

Config.DebugPrint = true -- As you have the script running well, we recommend to be false :)


--[[ Waiting for offers Time.. ]]

Config.StartDeliveryTime = math.random(10000, 30000) -- Min 10 seconds - Max 30 seconds


--[[ Gruppe6 Bags Props Models (for vehicles) ]]

Config.BagsPropModels = 'ba_prop_battle_bag_01a' -- GTA V Default Prop


--[[ Vehicles ]]

Config.SpeedoVehicle = 'gruppe6van' -- Gruppe 6 Speedo (exter Developments)

Config.StockadeVehicle = 'stockade' -- Stockade Vehicle (GTA V Default)

Config.BrickadeVehicle = 'brickade' -- Brickade Vehicle (GTA V Default)

Config.WorkVehicles = {
    {
        model = 'gruppe6van',
        coords = vector4(-33.9608, -673.7042, 32.1190, 187.9795),
        price = 2000
    },
    {
        model = 'stockade',
        coords = vector4(-19.1917, -672.4606, 31.9424, 182.4225),
        price = 15000
    },
    {
        model = 'brickade',
        coords = vector4(-4.7091, -672.3158, 32.6851, 187.4057),
        price = 40000
    },
}

Config.propLocations = {
        {x = -0.3, y = -1.0, z = -0.25}, 
        {x = 0.3, y = -1.0, z = -0.25}, -- Relative positions inside the vehicle
        {x = 1, y = -1.0, z = -0.25},
    
        {x = -0.3, y = -2.0, z = -0.25},
        {x = 0.3, y = -2.0, z = -0.25},
        {x = 1, y = -2.0, z = -0.25},
    
        {x = -0.3, y = -1.0, z = -0}, 
        {x = 0.3, y = -1.0, z = -0}, -- Relative positions inside the vehicle
        {x = 1, y = -1.0, z = -0},
    
        {x = -0.3, y = -2.0, z = -0},
        {x = 0.3, y = -2.0, z = -0},
        {x = 1, y = -2.0, z = -0},
}

Config.StockadePropLocations = {
    {x = -0.3, y = -1.0, z = 0.4}, 
    {x = 0.3, y = -1.0, z =  0.4}, 
    {x = 1, y = -1.0, z =  0.4},
    {x = -0.3, y = -1.7, z =  0.4},
    {x = 0.3, y = -1.7, z =  0.4},
    {x = 1, y = -1.7, z =  0.4},

    {x = -0.3, y = -1.0, z = 0.65}, 
    {x = 0.3, y = -1.0, z = 0.65}, 
    {x = 1, y = -1.0, z = 0.65},
    {x = -0.3, y = -1.7, z = 0.65},
    {x = 0.3, y = -1.7, z = 0.65},
    {x = 1, y = -1.7, z = 0.65},

    {x = -0.3, y = -2.4, z = 0.4}, 
    {x = 0.3, y = -2.4, z =  0.4}, 
    {x = 1, y = -2.4, z =  0.4},
    {x = -0.3, y = -2.98, z =  0.4},
    {x = 0.3, y = -2.98, z =  0.4},
    {x = 1, y = -2.98, z =  0.4},

    {x = -0.3, y = -2.4, z = 0.65}, 
    {x = 0.3, y = -2.4, z = 0.65},
    {x = 1, y = -2.4, z = 0.65},
    {x = -0.3, y = -2.98, z = 0.65},
    {x = 0.3, y = -2.98, z = 0.65},
    {x = 1, y = -2.98, z = 0.65},
    
}


--[[ Gruppe6 Contracts Configuration ]]

Config.Contracts = {
    {
        index = 1, -- Position (1st contract)
        tier = 1, -- Tier of the Contract
        requiredRep = 0, -- Required Reputation (works with our exter-contacts)
        type = 'Bank Delivery', -- Type of Contract (Bank Delivery or Refill Atm)
        veh = 'Speedo', -- The Vehicle that will be used on the Job.
        bags = 12, -- Bags that you need to delivery
        payout = 532, -- Payment once you finish the Job.
        gainRep = 0.2 -- How many Reputation you will get with this Job.
    },
    {
        index = 2,  -- Position (1st contract)
        tier = 2, -- Tier of the Contract
        requiredRep = 150, -- Required Reputation (works with our exter-contacts)
        type = 'Refill Atm', -- Type of Contract (Bank Delivery or Refill Atm)
        veh = 'Stockade', -- The Vehicle that will be used on the Job.
        bags = 24, -- Bags that you need to delivery
        payout = 1532, -- Payment once you finish the Job.
        gainRep = 1 -- How many Reputation you will get with this Job.
    },
    {
        index = 3, -- Position (1st contract)
        tier = 3, -- Tier of the Contract
        requiredRep = 300, -- Required Reputation (works with our exter-contacts)
        type = 'Bank Delivery', -- Type of Contract (Bank Delivery or Refill Atm)
        veh = 'Stockade', -- The Vehicle that will be used on the Job.
        bags = 24, -- Bags that you need to delivery
        payout = 1344,  -- Payment once you finish the Job.
        gainRep = 0.3 -- How many Reputation you will get with this Job.
    },
    {
        index = 4, -- Position (1st contract)
        tier = 4, -- Tier of the Contract
        requiredRep = 300, -- Required Reputation (works with our exter-contacts)
        type = 'Bank Delivery', -- Type of Contract (Bank Delivery or Refill Atm)
        veh = 'Blockade', -- The Vehicle that will be used on the Job.
        bags = 40, -- Bags that you need to delivery
        payout = 1653, -- Payment once you finish the Job.
        gainRep = 0.5 -- How many Reputation you will get with this Job.
    },
    
}

--[[ Central Bank Location ]]

Config.CentralBank = vector4(-1318.0621, -832.3465, 16.9693, 129.8353) -- Baycity Maze Bank (store.nopixel.net)

Config.Pickups = {
    
    -- Fleeca Banks

    vector4(143.0965, -1043.7474, 28.3679, 331.3074),
    vector4(307.4865, -282.1480, 53.1646, 338.3643),
    vector4(-357.6189, -52.7991, 48.0364, 339.4532),
    vector4(-1215.1132, -337.3853, 36.7808, 21.8552),
    vector4(-2957.9370, 477.4565, 14.6969, 81.8521),
    vector4(1180.3684, 2711.5984, 37.0878, 177.3706),
    vector4(-103.2327, 6469.9932, 30.6267, 126.2157),
    
    -- Others Banks 

    vector4(417.2283, -986.8294, 28.4038, 87.1777), --mrpd
    vector4(89.5961, -1745.1992, 29.0871, 323.7994), --MegaMall
    -- vector4(-33.3338, -1102.3392, 25.4224, 83.7222), --PDM
    vector4(-33.5231, -1101.8055, 26.2744, 81.9511), -- Gabz PDM (GABZ PDM)
    vector4(975.2338, 13.4697, 80.0410, 199.8926), --Diamond Casino
    vector4(-546.8247, -207.3085, 37.0825, 229.8685), --City Hall
    vector4(-1178.0718, -891.3958, 12.7654, 9.7767), --Burgershot
    
}

--[[ ATM Props (do not change if you don't know what you are doing) ]]

Config.AtmProps = {'prop_atm_01', 'prop_atm_02', 'prop_fleeca_atm', 'prop_atm_03'}

--[[ ATM's Locations ]]

Config.Atms = {

    --Please fill more ATMs locations by standing next to an ATM

    vector3(89.7633, 2.3376, 68.3069), 
    vector3(147.5608, -1035.6760, 29.3432),
    vector3(112.7072, -819.3462, 31.3375),
    vector3(-258.7773, -723.3928, 33.4680),
    vector3(-866.7311, -187.6472, 37.8430), 
    vector3(-821.5939, -1082.0067, 11.1324),
    vector3(-710.0455, -818.8943, 23.7289),
    vector3(-712.9207, -819.0791, 23.7289),
    vector3(-2072.3391, -317.2032, 13.3160),
}

function maxVehFuel(veh)  
    exports["cdn-fuel"]:SetFuel(veh, 100)
end