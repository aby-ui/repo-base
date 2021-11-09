local _, dc = ...
dc.utils = {}

local utils = dc.utils

function utils:isEmpty(table)
    for _, _ in pairs(table) do
        return false
    end
    return true
end

function utils:isNumeric(x)
    if tonumber(x) ~= nil then
        return true
    end
    return false
end

function utils:split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result
end

function utils:splitName(name)
    local result = utils:split(name, '-')
    return result[1], result[2]
end

function utils:splitMessage(msg)
    local result = utils:split(msg, ':')
    return result[1], result[2], result[3]
end

function utils:splitAskMessage(msg)
    local result = utils:split(msg, ':')
    return result[1], result[2]
end

function utils:splitCommand(msg)
    local result = utils:split(msg, ' ')
    return result[1], result[2]
end

function utils:isValidGUID(guid) 
    if guid then
        local unitType = utils:split(guid, '-')
        return unitType[1] == "Player"
    end
    return false
end
