--[[ Variables ]]
local framework = Bridge.FrameworkName
Core = Core or Bridge.GetFrameworkObject()

local currentJobStage = "WAITING"
local GroupID = 0
local isGroupLeader = false
local cooldown = false -- Dev Test
local createdATMs = {}
local atmLeft = {}
local createdNPCs = {}
local npcPedsDict = {}

local deliveryVehNetId = nil
local storageId = nil
local bankId = nil
local reqVeh = nil

local totalPickups = 0
local totalPicked = 0

local tempPickups = 0
local tempPicked = 0

local SetRoutes = {}

local blip = nil
local pickupType = nil
local returnVh = false
local lastDeleted = nil
local currentIndex = 0
local execOnce = false
local loadedProps = {}


--[[ Functions ]]

function round(num)
    return num >= 0 and math.floor(num + 0.5) or math.ceil(num - 0.5)
end

function deleteAllNPCs()
    if createdNPCs then
        for _, npcPed in ipairs(createdNPCs) do
            if DoesEntityExist(npcPed) then
                DeletePed(npcPed)
            end
        end
        createdNPCs = {}
    end
end

local function PickupMission(index)
    TriggerServerEvent("exter-gruppe6job:sv:getStopsList", totalPickups, GroupID, index)
end

local function SpawnFleet()
    for k, v in pairs(Config.WorkVehicles) do
        if v.model and not IsAnyVehicleNearPoint(v.coords.x, v.coords.y, v.coords.z, 2.0) then
            local model = GetHashKey(v.model)
            RequestModel(model)
            while not HasModelLoaded(model) do Citizen.Wait(0) end
            local vehicle = CreateVehicle(model, v.coords.x, v.coords.y, v.coords.z, false, false)
            SetModelAsNoLongerNeeded(model)
            Wait(100)
            SetVehicleOnGroundProperly(vehicle)
            SetEntityInvincible(vehicle, true)
            SetVehicleDirtLevel(vehicle, 0.0)
            SetVehicleDoorsLocked(vehicle, 3)
            SetEntityHeading(vehicle, v.coords.w)
            FreezeEntityPosition(vehicle, true)
            SetVehicleNumberPlateText(vehicle, "GRUPPE6");

            if v.model == 'gruppe6van' then
                SetVehicleLivery(vehicle, 1)
            elseif v.model == 'brickade' then
                SetVehicleColours(vehicle, 0, 0)
            end

            exports.interact:AddLocalEntityInteraction({
                entity = vehicle,
                name = 'vehF', -- optional
                id = 'vehF'..math.random(100, 999), -- needed for removing interactions
                distance = 10.0, -- optional
                interactDst = 6.0, -- optional
                ignoreLos = true, -- optional ignores line of sight
                options = {
                    {
                        label = Config.InteractGetDeliveryVehicle,
                        action = function(entity, coords, args)
                            TriggerEvent("exter-gruppe6job:DeliveryVeh", { v.model })
                        end,
                    },
                }
            })

        end
    end
end

function LoadItem(vehicle)
    local propModel = Config.BagsPropModels[math.random(1, #Config.BagsPropModels)]
    local propLocation = Config.propLocations[#loadedProps + 1]

    if propLocation then
        RequestModel(propModel)
        while not HasModelLoaded(propModel) do
            Wait(0)
        end

        local prop = CreateObject(propModel, 0, 0, 0, true, true, true)

        AttachEntityToEntity(prop, vehicle, 0, propLocation.x, propLocation.y, propLocation.z, 0.0, 0.0, 95.0, false, false, false, true, 2, true)


        table.insert(loadedProps, prop)
    end
end

function UnloadItem()
    if #loadedProps > 0 then
        local lastProp = loadedProps[#loadedProps]
        DeleteObject(lastProp)
        table.remove(loadedProps, #loadedProps)
    end
end

function UnloadAllItems()
    for _, prop in ipairs(loadedProps) do
        DeleteObject(prop)
    end
    loadedProps = {}
end

function deleteRouteByName(name)
    for i, stopInfo in ipairs(SetRoutes) do
        for stopName, _ in pairs(stopInfo) do
            if stopName == name then
                table.remove(SetRoutes, i)
                return true  -- Return true if deletion is successful
            end
        end
    end
    return false  -- Return false if no matching entry is found
end


function getPickRoute()
    local hasEntries = #SetRoutes > 0
    if hasEntries then
        local coords
        local amount
        for _, stopInfo in ipairs(SetRoutes) do
            for name, data in pairs(stopInfo) do
                coords = data[1]
                amount = data[2]
                break  -- Break after getting the first entry
            end
            break  -- Break after processing the first stopInfo
        end
        HeadToLocation()
        blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 586)
        SetBlipColour(blip, 25)
        SetBlipDisplay(blip, 2)

        SetBlipScale(blip, 0.7)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("Gruppe6 Pickup")
        EndTextCommandSetBlipName(blip)

        SetBlipRoute(blip , true)

        Wait(math.random(10000, 20000))
        tempPickups = tempPickups + amount

        GrabBagsInsideVault(tempPicked, tempPickups)

    else

        if blip then
            RemoveBlip(blip)
        end

        HeadtoCityVault()

        local coords = Config.CentralBank
        blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 500)
        SetBlipColour(blip, 5)
        SetBlipDisplay(blip, 2)

        SetBlipScale(blip, 0.7)


        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("Central Bank Deposit")
        EndTextCommandSetBlipName(blip)

        SetBlipRoute(blip , true)
    end
end


--[[ Core Events ]]

AddEventHandler("onResourceStart", function(resource)
    if resource == GetCurrentResourceName() then
        Wait(1000)

    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        deleteAllNPCs()
    end
end)

--[[ Script Events ]]

RegisterNetEvent("groups:updateJobStage", function(stage)
    currentJobStage = stage

end)


RegisterNetEvent("groups:JoinGroup", function(id)
    GroupID = id
end)

RegisterNetEvent("groups:UpdateLeader", function()
    isGroupLeader = true
end)

RegisterNetEvent("groups:GroupDestroy", function()
    currentJobStage = "WAITING"
    GroupID = 0
    isGroupLeader = false
end)

local isNotAssigned = false
RegisterNetEvent("exter-gruppe6job:cl:assignDV", function(netId)
    deliveryVehNetId = netId
    isNotAssigned = true
    local veh = NetworkGetEntityFromNetworkId(deliveryVehNetId)
    if veh and GetVehicleNumberPlateText(veh) then
        storageId = "G6VAN"..GetVehicleNumberPlateText(veh)


        exports.interact:AddLocalEntityInteraction({
            entity = veh,
            name = 'viewStorg', -- optional
            id = 'viewStorg'..math.random(100, 999), -- needed for removing interactions
            distance = 6.0, -- optional
            interactDst = 4.0, -- optional
            ignoreLos = true, -- optional ignores line of sight
            options = {
                {
                    label = Config.ViewStorage,
                    action = function(entity, coords, args)
                        TriggerEvent("exter-gruppe6job:vehicleStorage")
                    end,
                },
            }
        })

    else


        CreateThread(function()
            while isNotAssigned do
                local veh = NetworkGetEntityFromNetworkId(deliveryVehNetId)
                if veh and GetVehicleNumberPlateText(veh) then
                    storageId = "G6VAN"..GetVehicleNumberPlateText(veh)


                    exports.interact:AddLocalEntityInteraction({
                        entity = veh,
                        name = 'viewStorg', -- optional
                        id = 'viewStorg'..math.random(100, 999), -- needed for removing interactions
                        distance = 6.0, -- optional
                        interactDst = 4.0, -- optional
                        ignoreLos = true, -- optional ignores line of sight
                        options = {
                            {
                                label = Config.ViewStorage,
                                action = function(entity, coords, args)
                                    TriggerEvent("exter-gruppe6job:vehicleStorage")
                                end,
                            },
                        }
                    })

                    isNotAssigned = false

                end
                Wait(500)
            end
        end)
    end
end)


RegisterNetEvent("exter-gruppe6job:vehicleStorage", function()
    if deliveryVehNetId and NetworkGetEntityFromNetworkId(deliveryVehNetId) then
        local veh = NetworkGetEntityFromNetworkId(deliveryVehNetId)

        local slots = 12
        local weight = 650000

        if GetEntityModel(veh) == GetHashKey(Config.WorkVehicles[2].model) then
            slots = 24
            weight = 1250000
        elseif GetEntityModel(veh) == GetHashKey(Config.WorkVehicles[3].model) then
            slots = 40
            weight = 3300000
        end

        if Bridge.InventoryName == "ox_inventory" then
            TriggerServerEvent("exter-gruppe6job:sv:OpenInventory", storageId, weight, slots)
        else
            TriggerServerEvent("inventory:server:OpenInventory", "stash", storageId, {
                maxweight = weight,
                slots = slots,
            })
            TriggerEvent("inventory:client:SetCurrentStash", storageId)
        end

    end
end)

RegisterNetEvent("exter-gruppe6job:OpenST", function(name, amnt)
    amnt = amnt or 40

    --TriggerServerEvent("exter-gruppe6job:sv:OpenInventory", name, 3300000, amnt)

    if Bridge.InventoryName == "ox_inventory" then
        TriggerServerEvent("exter-gruppe6job:sv:OpenInventory", name, 3300000, amnt)
    else
        TriggerServerEvent('inventory:server:OpenInventory', 'stash', name, {
            maxweight = 3300000,
            slots = amnt,
        })
        TriggerEvent("inventory:client:SetCurrentStash", name)
    end
end)

RegisterNetEvent("exter-gruppe6:npc-Signin", function()
    Signin()
end)

RegisterNetEvent("exter-gruppe6job:Sign", function()
    if GroupID == 0 then
        TriggerEvent("exter-tablet:fB2")
        NotifyGroupError()
        return
    end

    local currentRep = Rep() or 0

    SendNUIMessage({
        type = "open",
        rep = currentRep,
        contracts = Config.Contracts
    })
    SetNuiFocus(true, true)

end)

RegisterNetEvent("exter-gruppe6job:GetRoutes", function(Routes, bid, typeC, totalpickupNumber, index)
    SetRoutes = Routes
    Wait(5000)
    bankId = bid

    currentIndex = index
    totalPickups = totalpickupNumber

    if typeC == 1 then

        for i, stopInfo in ipairs(Routes) do
            for name, data in pairs(stopInfo) do

                local coords = data[1]
                local amount = data[2]

                local npcPed = CreatePed(4, GetHashKey('s_m_m_armoured_02'), coords.x, coords.y, coords.z, coords.w, false, false)
                FreezeEntityPosition(npcPed, true)
                SetEntityInvincible(npcPed, true)
                SetBlockingOfNonTemporaryEvents(npcPed, true)
                npcPedsDict[name] = npcPed

                exports.interact:AddLocalEntityInteraction({
                    entity = npcPed,
                    name = name, -- optional
                    id = name..math.random(100, 999), -- needed for removing interactions
                    distance = 6.0, -- optional
                    -- offset = vec3(0.0, 1.0, 0.0),
                    interactDst = 4.0, -- optional
                    ignoreLos = true, -- optional ignores line of sight
                    options = {
                        {
                            label = Config.PickupBags,
                            action = function(entity, coords, args)
                                TriggerServerEvent("exter-gruppe6job:sv:getBags", { name, amount, GroupID })
                            end,
                        },
                    }
                })


                table.insert(createdNPCs, npcPed)

            end
        end

        getPickRoute()

    elseif typeC == 2 then

        HeadtoCityVaultXD()

        local coords = Config.CentralBank
        blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 500)
        SetBlipColour(blip, 5)
        SetBlipDisplay(blip, 2)

        SetBlipScale(blip, 0.7)


        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("Central Bank Deposit")
        EndTextCommandSetBlipName(blip)

        SetNewWaypoint(coords.x, coords.y)


        --Here it should setup atm points...
        for i, stopInfo in ipairs(Routes) do
            for name, data in pairs(stopInfo) do

                local coords = data[1]
                local amount = data[2]

                exports.interact:AddInteraction({
                    coords = coords,
                    distance = 6.0, -- optional
                    interactDst = 2.0, -- optional
                    -- offset = vec3(0.0, 1.0, 0.0),
                    id = name, -- needed for removing interactions
                    options = {
                         {
                            label = Config.OpenATM,
                            action = function(entity, coords, args)
                                TriggerEvent("exter-gruppe6job:cl:FillAtm", { name, amount, GroupID })
                            end,
                        },
                    }
                })
                local blipy = AddBlipForCoord(coords.x, coords.y, coords.z)
                SetBlipSprite(blipy, 586)
                SetBlipColour(blipy, 25)
                SetBlipDisplay(blipy, 0)

                SetBlipScale(blipy, 0.8)

                BeginTextCommandSetBlipName('STRING')
                AddTextComponentString("Refill Atm")
                EndTextCommandSetBlipName(blip)

                createdATMs[name] = {0, amount, blipy}

                table.insert(atmLeft, name)
                if Config.DebugPrint == true then
                print("[DEBUG] - [exter-gruppe6job] - Created ATM on name "..name)
                end

            end
        end

        local cZone = BoxZone:Create(Config.CentralBank, 80.0, 80.0, {
            name = 'gruppe6HQ',
            heading = Config.CentralBank.w,
            minZ = Config.CentralBank.z - 5,
            maxZ = Config.CentralBank.z + 7,
            debugPoly = false
        })
        cZone:onPlayerInOut(function(inside)
            Wait(8000)
            if inside and not execOnce then
                execOnce = true
                local textEntries = ATMsReful()
                local i = 1
                for key, value in pairs(createdATMs) do
                    table.insert(textEntries, "#"..i.." ATM "..value[1].."/"..value[2])
                    if value[3] then
                        SetBlipDisplay(value[3], 2)
                    end
                    i = i + 1
                end

                if blip then
                    RemoveBlip(blip)
                end

                ATMsRefill(textEntries)
                cZone:destroy()
            end
        end)


    end
end)

RegisterNetEvent("exter-gruppe6job:cl:FillAtm", function(data)
    TriggerServerEvent("exter-gruppe6job:sv:FillAtm", { data[1], data[2], data[3], atmLeft })
end)

RegisterNetEvent("exter-gruppe6job:DeliverBags", function()

    if Bridge.InventoryName == "ox_inventory" then
        TriggerServerEvent("exter-gruppe6job:sv:OpenInventory", bankId, 3300000, 40)
    else
        TriggerServerEvent("inventory:server:OpenInventory", "stash", bankId, {
            maxweight = 3300000,
            slots = 40,
        })
        TriggerEvent("inventory:client:SetCurrentStash", bankId)
    end
end)

RegisterNetEvent("exter-gruppe6job:AskAtmCompleteDeliveryy", function(cAtm)

    if GroupID then
        local playerCoords = GetEntityCoords(PlayerPedId(-1))

        local dist = 40
        TriggerServerEvent("exter-gruppe6job:sv:Grantcompletion", totalPickups, GroupID, bankId, currentIndex, dist)

    end
end)

RegisterNetEvent("exter-gruppe6job:AskCompleteDeliveryy", function(totalpickupNumber, index)
    if totalPickups and GroupID and totalPickups > 1 then

        if tempPicked < totalPickups then
            ExploitTentativeError()
        else
            local playerCoords = GetEntityCoords(PlayerPedId(-1))

            local dist = #(playerCoords - vector3(Config.CentralBank.x, Config.CentralBank.y, Config.CentralBank.z))
            TriggerServerEvent("exter-gruppe6job:sv:Grantcompletion", totalPickups, GroupID, bankId, currentIndex, dist)
        end
    end
end)

RegisterNetEvent("exter-gruppe6job:AskCompleteDelivery", function()
    TriggerServerEvent("exter-gruppe6job:sv:Grantcompletionn", totalPickups, currentIndex, GroupID, bankId)
end)

RegisterNetEvent("exter-gruppe6job:CompleteDelivery", function()
    ReturnTheDeliveryVehicle()
    DepositSuccessfully()
    SetNewWaypoint(-27.31, -664.14)
    returnVh = true
    cooldown = true
    if blip then
        RemoveBlip(blip)
    end

    SetRoutes = {}
    atmLeft = {}
    totalPickups = 0
    deliveryVehNetId = nil
    storageId = nil
    bankId = nil
    totalPicked = 0
    tempPickups = 0
    tempPicked = 0
    blip = nil
    pickupType = nil
    lastDeleted = nil
    currentIndex = 0
    execOnce = false
    reqVeh = nil
    isNotAssigned = false

    UnloadAllItems()
    deleteAllNPCs()
    createdATMs = {}
    npcPedsDict = {}

end)

RegisterNetEvent("exter-gruppe6job:RemovePickup", function(name, amnt)

    if lastDeleted ~= name then
        deleteRouteByName(name)
        lastDeleted = name
        tempPicked = tempPicked + amnt

        GrabBagsInsideVault(tempPicked, tempPickups)

        if blip then
            RemoveBlip(blip)
        end
        Wait(math.random(3000, 5000))
        WaitingLeaders()
        if tempPicked > #loadedProps then
            local a = tempPicked - #loadedProps
            TriggerServerEvent("exter-gruppe6job:sv:BagTask", a, GroupID)
        end
        Wait(math.random(5000, 15000))
        getPickRoute()
    end
end)

RegisterNetEvent("exter-gruppe6job:RemoveAtmPickup", function(name, amnt)
    local bb = createdATMs[name][3]

    createdATMs[name][1] = amnt

    removeElementByValue(atmLeft, name)

    tempPicked = tempPicked + amnt

    exports.interact:RemoveInteraction(name)

    if bb then
        RemoveBlip(bb)
    end

    Wait(math.random(7000, 8000))

    local textEntries = ATMsReful()
    local i = 1
    for key, value in pairs(createdATMs) do
        table.insert(textEntries, "#"..i.." ATM "..value[1].."/"..value[2])
        i = i + 1
    end

    ATMsRefill(textEntries)

end)

RegisterNetEvent("exter-gruppe6job:ReturnVeh", function()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local veh = GetVehiclePedIsIn(ped)

        if DoesEntityExist(veh) then
            DeleteEntity(veh)
        end

        deliveryVehNetId = nil
    end
end)

RegisterNetEvent("exter-gruppe6job:BagTask", function(type, amnt)
    if deliveryVehNetId and NetworkGetEntityFromNetworkId(deliveryVehNetId) then
        local veh = NetworkGetEntityFromNetworkId(deliveryVehNetId)
        if type == 'load' then
            for i = 1, amnt do
                LoadItem(veh)
            end
        elseif type == 'unload' then
            for i = 1, amnt do
                UnloadItem()
            end
        else
            UnloadAllItems()
        end
    end
end)

RegisterNetEvent("exter-gruppe6job:DeliveryVeh", function(args)
    local m = args[1]

    local spawnPoint = vector4(-34.5018, -696.8900, 31.9448, 341.4272)

    if IsAnyVehicleNearPoint(spawnPoint.x, spawnPoint.y,spawnPoint.z, 2.0) then
        NotifySpawnOccupied()
    else

        if deliveryVehNetId and NetworkGetEntityFromNetworkId(deliveryVehNetId) then
            NotifyAlreadyVehicleSpawned()
            return
        end

        local tmpVeh
        if reqVeh == "Speedo" then tmpVeh = Config.SpeedoVehicle
        elseif reqVeh == "Blockade" then tmpVeh = Config.BrickadeVehicle
        elseif reqVeh == "Stockade" then tmpVeh = Config.StockadeVehicle
        end

        if m ~= tmpVeh then
            WrongVehicle()
            return
        end

        if framework == 'qbcore' or framework == 'qbox' then
            Core.Functions.SpawnVehicle(m, function(veh)
                SetEntityHeading(veh, spawnPoint.w)
                SetVehicleEngineOn(veh, false, false)
                SetVehicleOnGroundProperly(veh)
                SetVehicleNeedsToBeHotwired(veh, false)
                maxVehFuel(veh)
                TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
                SetVehicleDoorsLocked(veh,1)
                vehicleNet = NetworkGetNetworkIdFromEntity(veh)

                if m == Config.SpeedoVehicle then
                    SetVehicleLivery(veh, 1)
                elseif m == Config.BrickadeVehicle then
                    SetVehicleColours(veh, 0, 0)
                end

                local netId = NetworkGetNetworkIdFromEntity(veh)
                TriggerServerEvent("exter-gruppe6job:sv:assignDV", netId, GroupID)

            end, spawnPoint, true)
        elseif framework == 'esx' then
            Core.Game.SpawnVehicle(m, spawnPoint, spawnPoint.w, function(veh)
                SetEntityHeading(veh, spawnPoint.w)
                SetVehicleEngineOn(veh, false, false)
                SetVehicleOnGroundProperly(veh)
                SetVehicleNeedsToBeHotwired(veh, false)
                maxVehFuel(veh)

                TriggerEvent("keys:received", GetVehicleNumberPlateText(veh))
                SetVehicleDoorsLocked(veh,1)

                if m == Config.SpeedoVehicle then
                    SetVehicleLivery(veh, 1)
                elseif m == Config.BrickadeVehicle then
                    SetVehicleColours(veh, 0, 0)
                end

                local netId = NetworkGetNetworkIdFromEntity(veh)
                TriggerServerEvent("exter-gruppe6job:sv:assignDV", netId, GroupID)

            end)
        end
    end
end)

--[[ NUI Events ]]

local isCooldownNotificationActive = false

RegisterNUICallback("exter-gruppe6job:StartShit", function(data)
    if cooldown == true then
        if not isCooldownNotificationActive then
            isCooldownNotificationActive = true
            NotifyCooldownRepeatedly()
            if Config.DebugPrint == true then
                print("[DEBUG] - [exter-gruppe6job] - I got cooldown: " .. tostring(cooldown))
            end
            -- Define um temporizador para desativar a proteção após o cooldown
            Citizen.SetTimeout(Config.CooldownTime, function()
                isCooldownNotificationActive = false
            end)
        end
        return
    end

    -- Se o cooldown não estiver ativo, continue com a lógica normal
    Signin()

    Citizen.Wait(Config.StartJobTime)

    SetNuiFocus(false, false)

    if totalPickups and totalPickups > 0 then
        NotifyForceFinishjob()
    end

    local index = data.index
    currentIndex = index
    reqVeh = Config.Contracts[index].veh
    totalPickups = Config.Contracts[index].bags

    TriggerServerEvent("exter-gruppe6job:StartGrpPickups", index, GroupID)

    if deliveryVehNetId == nil then
        GrabDeliveryVehicle()
    end

    while deliveryVehNetId == nil do
        Citizen.Wait(5000)
    end

    if Config.Contracts[index].type == 'Bank Delivery' or Config.Contracts[index].type == 'Refill Atm' then
        if cooldown == true then
            if not isCooldownNotificationActive then
                isCooldownNotificationActive = true
                NotifyCooldownRepeatedly()
                if Config.DebugPrint == true then
                    print("[DEBUG] - [exter-gruppe6job] - I got cooldown: " .. tostring(cooldown))
                end
                Citizen.SetTimeout(Config.CooldownTime, function()
                    isCooldownNotificationActive = false
                end)
            end
            Citizen.Wait(Config.CooldownTime)
            cooldown = false
        elseif cooldown == false then
            PickupMission(index)
        end
    end
end)

function NotifyCooldown()
    -- Convert milliseconds to minutes
    local minutes = math.floor(Config.CooldownTime / 60000)
    Notify("You have a cooldown of " .. minutes .. " minutes.", "error")
end

function NotifyCooldownRepeatedly()
    local cooldownStart = GetGameTimer() -- Get the current game time in milliseconds
    local cooldownEnd = cooldownStart + Config.CooldownTime

    while GetGameTimer() < cooldownEnd do
        local timeRemaining = cooldownEnd - GetGameTimer()
        local minutesRemaining = math.floor(timeRemaining / 60000)
        local secondsRemaining = math.floor((timeRemaining % 60000) / 1000)

        -- Display the remaining time in the notification
        Notify("You have a cooldown of " .. minutesRemaining .. " minutes and " .. secondsRemaining .. " seconds remaining.", "error")

        Citizen.Wait(30000) -- Wait for 30 seconds
    end

    -- Final notification after cooldown ends (optional)
    Notify("Cooldown period has ended. Good Work !", "success")
    cooldown = false
    isCooldownNotificationActive = false
end

RegisterNUICallback("exter-gruppe6job:hideMenu", function()
    SetNuiFocus(false, false)
    TriggerEvent("exter-tablet:fB2")
end)

RegisterNetEvent("exter-gruppe6job:consumeBag", function()
    if framework == 'qbcore' or framework == 'qbox' then
        Core.Functions.Progressbar('openg6bag', 'Opening Gruppe6 Bag', 5000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true
        }, {}, {}, {}, function()
            TriggerServerEvent('exter-gruppe6job:sv:consumeBag')
        end)
    else
        TriggerServerEvent('exter-gruppe6job:sv:consumeBag')
    end
end)


--[[ Threads ]]

Citizen.CreateThread(function()
    local coords = vector4(-20.6319, -670.8425, 32.3381, -20)
    local hqZone = BoxZone:Create(coords, 80.0, 100.0, {
        name = 'gruppe6HQ',
        heading = coords.w,
        minZ = coords.z - 5,
        maxZ = coords.z + 7,
        debugPoly = false
    })
    hqZone:onPlayerInOut(function(inside)
        if inside then
            SpawnFleet()
            if returnVh then
                CloseTasksUI()
                returnVh = false
            end
        end
    end)

    local hqBlip = AddBlipForCoord(-27.31, -664.14, 33.4)
    SetBlipSprite(hqBlip, 616)
    SetBlipDisplay(hqBlip, 4)
    SetBlipScale(hqBlip, 0.65)
    SetBlipAsShortRange(hqBlip, true)
    SetBlipColour(hqBlip, 5)
    AddTextEntry("gruppe6", "Gruppe 6 HQ")
    BeginTextCommandSetBlipName("gruppe6")
    EndTextCommandSetBlipName(hqBlip)
end)

CreateThread(function()
    while true do
        sleep = 1000
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local v = vector3(-20.829, -706.984, 32.338)

            local dist = #(pos - vector3(v.x, v.y, v.z))
            if dist < 40 then
                sleep = 0
                DrawMarker(39, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0, 0, 255, 0, 222, false, false, false, true, false, false, false)
                if dist < 1.5 then
                    if IsControlJustReleased(0, 38) then
                        if IsPedInAnyVehicle(ped, false) then
                            local vehicle = GetVehiclePedIsIn(ped, false)
                            local model = GetEntityModel(vehicle)
                            if model == GetHashKey(Config.SpeedoVehicle) or model == GetHashKey(Config.StockadeVehicle) or model == GetHashKey(Config.BrickadeVehicle) then
                                DeleteVehicle(vehicle)
                                NotifyVehicleStoredSucessfully()
                            else
                                Notify("Do you think that i'm a fucking garage?", "error")
                            end
                        end
                    end
                end
            end
        Wait(500)
    end
end)
