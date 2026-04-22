Utils = Utils or {}
Utils.Functions = Utils.Functions or {}

function isTableEmpty(tbl)
    if type(tbl) ~= 'table' then return true end
    return next(tbl) == nil
end

function removeElementByValue(tbl, valueToRemove)
    if type(tbl) ~= 'table' then return false end
    for key, value in pairs(tbl) do
        if value == valueToRemove then
            tbl[key] = nil
            return true
        end
    end
    return false
end

function Utils.Functions.printTable(value, indent)
    indent = indent or 0

    if type(value) ~= 'table' then
        print(('%s%s'):format(string.rep('  ', indent), tostring(value)))
        return
    end

    for k, v in pairs(value) do
        local prefix = ('%s%s: '):format(string.rep('  ', indent), tostring(k))
        if type(v) == 'table' then
            print(prefix)
            Utils.Functions.printTable(v, indent + 1)
        else
            print(prefix .. tostring(v))
        end
    end
end

function Utils.Functions.debugPrint(data)
    if not Config.DebugPrint then return end
    print('[exter-gruppe6job:DEBUG]')
    Utils.Functions.printTable(data)
    print('[END DEBUG]')
end

function Utils.Functions.hasResource(name)
    return GetResourceState(name):find('start') ~= nil
end

function Utils.Functions.GetFramework()
    return Bridge.GetFrameworkObject()
end

function Utils.Functions.deepCopy(orig)
    if type(orig) ~= 'table' then return orig end
    local copy = {}
    for key, value in next, orig do
        copy[Utils.Functions.deepCopy(key)] = Utils.Functions.deepCopy(value)
    end
    return setmetatable(copy, Utils.Functions.deepCopy(getmetatable(orig)))
end
