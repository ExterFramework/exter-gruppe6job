if Config.Framework == 'QBCore'then
    QBCore = exports[Config.FrameworkFolder]:GetCoreObject()
else
    ESX = exports[Config.FrameworkFolder]:getSharedObject()
end

local currentRep = 0

function Rep()
    local p = promise.new()
    
    if Config.Framework == 'QBCore'then
        QBCore.Functions.TriggerCallback('exter-contacts:getRep', function(result)
            p:resolve(result)    
        end, "Gruppe 6") 
    else
        ESX.TriggerServerCallback('exter-contacts:getRep', function(result)
            p:resolve(result)    
        end, "Gruppe 6") 
    end

    return Citizen.Await(p)
end

function Notify(msg, typ)
    if Config.Framework == 'QBCore'then
        QBCore.Functions.Notify(msg, typ)
    else
        ESX.ShowHelpNotification(msg)
    end
end