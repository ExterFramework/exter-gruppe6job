--[[ Variables ]]

if Config.Framework == 'QBCore'then
    QBCore = exports[Config.FrameworkFolder]:GetCoreObject()
else
    ESX = exports[Config.FrameworkFolder]:getSharedObject()
end

function getRandomStops(totalpickupNumber, typeC)
    local pickups

    if typeC == 1 then
        pickups = Config.Pickups
    else
        pickups = Config.Atms
    end

    -- Shuffle the list of pickups
    for i = #pickups, 2, -1 do
        local j = math.random(i)
        pickups[i], pickups[j] = pickups[j], pickups[i]
    end

    local numStops = math.min(math.max(math.floor(totalpickupNumber / 4), 3), 6)
    local selectedStops = {}
    local remainingPickups = totalpickupNumber

    --print("TotalShouldBe " .. totalpickupNumber)
    for i = 1, numStops do
        local stop = pickups[i]
        local name = "g6pk" .. i .. math.random(100, 999)
        local minPickups = 2
        local maxPickups = 8

        -- Adjust pickup numbers based on special conditions
        if totalpickupNumber == 24 then
            minPickups = 4
            maxPickups = 12
        elseif totalpickupNumber >= 40 then
            minPickups = 12
            maxPickups = totalpickupNumber - (12 * (numStops - 1))
        end

        -- Adjustment to ensure the last stop compensates for any shortfall
        if i == numStops then
            pickupsInRange = remainingPickups  -- Assign all remaining pickups to the last stop
        else
            maxPickups = math.min(maxPickups, remainingPickups - (minPickups * (numStops - i)))
            pickupsInRange = math.random(minPickups, maxPickups)
        end

        remainingPickups = remainingPickups - pickupsInRange
       -- print("Added " .. pickupsInRange)

        table.insert(selectedStops, { [name] = {stop, pickupsInRange} })
    end

    return selectedStops
end

RegisterNetEvent('exter-gruppe6job:StartGrpPickups')
AddEventHandler('exter-gruppe6job:StartGrpPickups', function(index, grpId)
    local src = source

    local typeR = Config.Contracts[index].type

    if typeR == "Bank Delivery" or typeR == "Refill Atm" then
        pickupType = "g6cashbag"
    else
        pickupType = "g6cashpallet"
    end

    exports["exter-groupsystem"]:GroupEvent(grpId, "exter-gruppe6job:StartPickup", {index, pickupType}) 
end)


RegisterNetEvent('exter-gruppe6job:sv:BagTask')
AddEventHandler('exter-gruppe6job:sv:BagTask', function(amnt, grpId)
    local src = source
    exports["exter-groupsystem"]:GroupEvent(grpId, "exter-gruppe6job:BagTask", {'load', amnt}) 
end)


RegisterNetEvent("exter-gruppe6job:sv:getStopsList", function(totalpickupNumber, grpId, index)
    
    local bankId = "BNKST"..grpId..math.random(10, 55)

    local contractType = Config.Contracts[index].type
    local stops
    local pickupType
    local givenR = 0
    

    if contractType == "Bank Delivery"  then
        --print("exe1")
        stops = getRandomStops(totalpickupNumber, 1)
        pickupType = "g6cashbag"

        givenR = 1
        for i, stopInfo in ipairs(stops) do
            for name, data in pairs(stopInfo) do          

                local amount = data[2]
    
                local itms = {}
                
                for i = 1, amount do
                    table.insert(itms, {
                        slot = i,
                        name = pickupType,
                        amount = 1,
                        info = {},
                        type = 'item'
                    })
                    
                end               
                
                local StashName = name
                --print(StashName)
                TriggerEvent('exter-gruppe6job:sv:SetStashItems', StashName, itms)    
            end
        end
        TriggerEvent('exter-gruppe6job:sv:SetStashItems', bankId, {})
    elseif contractType == "Refill Atm" then
        givenR = 2
        pickupType = "g6cashbag"
        local itms = {}
        for i = 1, totalpickupNumber do
            table.insert(itms, {
                slot = i,
                name = pickupType,
                amount = 1,
                info = {},
                type = 'item'
            })
            
        end               
        
        local StashName = bankId
        TriggerEvent('exter-gruppe6job:sv:SetStashItems', StashName, itms) 

        stops = getRandomStops(totalpickupNumber, 2)
        
    else
        givenR = 3
        --TO BE ADDED LATER
        pickupType = "g6cashpallet"
    end
   
    exports["exter-groupsystem"]:GroupEvent(grpId, "exter-gruppe6job:GetRoutes", {stops, bankId, givenR, totalpickupNumber, index}) 
end)

RegisterNetEvent("exter-gruppe6job:sv:Grantcompletionn", function(totalpickupNumber, index, grpId, bankId)

    TriggerEvent('exter-gruppe6job:sv:SetStashItems', bankId, {})
    exports["exter-groupsystem"]:GroupEvent(grpId, "exter-gruppe6job:AskCompleteDeliveryy", {totalpickupNumber, index}) 

    exports["exter-groupsystem"]:GroupEvent(grpId, "exter-gruppe6job:BagTask", {'unloadall', 0}) 
end)


RegisterNetEvent("exter-gruppe6job:sv:FillAtm", function(data)
    local src = source

    local name=data[1] 
    local amount=data[2] 
    local gropId=data[3]

    local atmLeft=data[4]

    TriggerClientEvent("exter-gruppe6job:OpenST", src, name, amount)

    exports["exter-groupsystem"]:GroupEvent(gropId, "exter-gruppe6job:RemoveAtmPickup", {name, amount}) 

    removeElementByValue(atmLeft, name)

    TriggerEvent('exter-gruppe6job:sv:SetStashItems', name, {})

    if isTableEmpty(atmLeft) then
       Wait(math.random(8000, 9500))  
       exports["exter-groupsystem"]:GroupEvent(gropId, "exter-gruppe6job:AskAtmCompleteDeliveryy", {atmLeft}) 
    end
    
end)

RegisterNetEvent("exter-gruppe6job:sv:getBags", function(data)
    local src = source

    local name=data[1] 
    local amount=data[2] 
    local gropId=data[3]

    TriggerClientEvent("exter-gruppe6job:OpenST", src, name)

    exports["exter-groupsystem"]:GroupEvent(gropId, "exter-gruppe6job:RemovePickup", {name, amount}) 

end)

RegisterNetEvent("exter-gruppe6job:sv:assignDV", function(netId, grpId)
    deliveryVehNetId = netId
    exports["exter-groupsystem"]:GroupEvent(grpId, "exter-gruppe6job:cl:assignDV", {netId}) 
end)

RegisterNetEvent("exter-gruppe6job:sv:consumeBag", function()
    ItemManager('g6cashbag', 1, 'remove', GetPlayer(source))
    ItemManager('g6markedcash', 15, 'add', GetPlayer(source))
end)

if Config.Framework == 'QBCore' then
    QBCore.Functions.CreateUseableItem('g6cashbag', function(source)
        TriggerClientEvent('exter-gruppe6job:consumeBag', source)
    end)
end