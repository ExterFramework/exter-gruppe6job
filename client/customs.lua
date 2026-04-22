local framework = Bridge.FrameworkName
Core = Core or Bridge.GetFrameworkObject()

local function isQB()
    return framework == 'qbcore' or framework == 'qbox'
end

local currentRep = 0

function Rep()
    local p = promise.new()

    if isQB() then
        Core.Functions.TriggerCallback('exter-contacts:getRep', function(result)
            p:resolve(result)
        end, 'Gruppe 6')
    elseif framework == 'esx' then
        Core.TriggerServerCallback('exter-contacts:getRep', function(result)
            p:resolve(result)
        end, 'Gruppe 6')
    else
        p:resolve(0)
    end

    return Citizen.Await(p)
end

function Notify(msg, typ)
    if isQB() then
        Core.Functions.Notify(msg, typ or 'primary')
    elseif framework == 'esx' then
        Core.ShowNotification(msg)
    else
        print(('[exter-gruppe6job] %s'):format(msg))
    end
end
