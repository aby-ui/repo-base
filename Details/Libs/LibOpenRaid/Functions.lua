--[=[
    Dumping logical functions here, make the code of the main file smaller
--]=]



if (not LIB_OPEN_RAID_CAN_LOAD) then
	return
end

local openRaidLib = LibStub:GetLibrary("LibOpenRaid-1.0")

local CONST_FRACTION_OF_A_SECOND = 0.01

local CONST_COOLDOWN_TYPE_OFFENSIVE = 1
local CONST_COOLDOWN_TYPE_DEFENSIVE_PERSONAL = 2
local CONST_COOLDOWN_TYPE_DEFENSIVE_TARGET = 3
local CONST_COOLDOWN_TYPE_DEFENSIVE_RAID = 4
local CONST_COOLDOWN_TYPE_UTILITY = 5
local CONST_COOLDOWN_TYPE_INTERRUPT = 6

--simple non recursive table copy
function openRaidLib.TCopy(tableToReceive, tableToCopy)
    if (not tableToCopy) then
        print(debugstack())
    end
    for key, value in pairs(tableToCopy) do
        tableToReceive[key] = value
    end
end

--find the normalized percent of the value in the range. e.g range of 200-400 and a value of 250 result in 0.25
--from details! framework
function openRaidLib.GetRangePercent(minValue, maxValue, value)
	return (value - minValue) / max((maxValue - minValue), 0.0000001)
end

--transform a table index into a string dividing values with a comma
--@table: an indexed table with unknown size
function openRaidLib.PackTable(table)
    local tableSize = #table
    local newString = "" .. tableSize .. ","
    for i = 1, tableSize do
        newString = newString .. table[i] .. ","
    end

    newString = newString:gsub(",$", "")
    return newString
end

--return is a number is almost equal to another within a tolerance range
function openRaidLib.isNearlyEqual(value1, value2, tolerance)
    tolerance = tolerance or CONST_FRACTION_OF_A_SECOND
    return abs(value1 - value2) <= tolerance
end

--return true if the lib is allowed to receive comms from other players
function openRaidLib.IsCommAllowed()
    return IsInGroup() or IsInRaid()
end

--stract some indexes of a table
local selectIndexes = function(table, startIndex, amountIndexes)
    local values = {}
    for i = startIndex, startIndex+amountIndexes do
        values[#values+1] = tonumber(table[i]) or 0
    end
    return values
end

--transform a string table into a regular table
--@table: a table with unknown values
--@index: where in the table is the information we want
--@isPair: if true treat the table as pairs(), ipairs() otherwise
--@valueAsTable: return {value1, value2, value3}
--@amountOfValues: for the parameter above
function openRaidLib.UnpackTable(table, index, isPair, valueIsTable, amountOfValues)
    local result = {}
    local reservedIndexes = table[index]
    if (not reservedIndexes) then
        return result
    end
    local indexStart = index+1
    local indexEnd = reservedIndexes+index

    if (isPair) then
        amountOfValues = amountOfValues or 2
        for i = indexStart, indexEnd, amountOfValues do
            if (valueIsTable) then
                local key = tonumber(table[i])
                local values = selectIndexes(table, i+1, max(amountOfValues-2, 1))
                result[key] = values
            else
                local key = tonumber(table[i])
                local value = tonumber(table[i+1])
                result[key] = value
            end
        end
    else
        for i = indexStart, indexEnd do
            local value = tonumber(table[i])
            result[#result+1] = value
        end
    end
    
    return result
end

--returns if the player is in group
function openRaidLib.IsInGroup()
    local inParty = IsInGroup()
    local inRaid = IsInRaid()
    return inParty or inRaid
end

function openRaidLib.UpdateUnitIDCache()
    openRaidLib.UnitIDCache = {}
    if (IsInRaid()) then
        for i = 1, GetNumGroupMembers() do
            local unitName = UnitName("raid"..i)
            if (unitName) then
                openRaidLib.UnitIDCache[unitName] = "raid"..i
            end
        end
    elseif (IsInGroup()) then
        for i = 1, GetNumGroupMembers() - 1 do
            local unitName = UnitName("party"..i)
            if (unitName) then
                openRaidLib.UnitIDCache[unitName] = "party"..i
            end
        end
    end
    openRaidLib.UnitIDCache[UnitName("player")] = "player"
end

function openRaidLib.GetUnitID(playerName)
    return openRaidLib.UnitIDCache[playerName] or playerName
end


local filterStringToCooldownType = {
    ["defensive-raid"] = CONST_COOLDOWN_TYPE_DEFENSIVE_RAID,
    ["defensive-target"] = CONST_COOLDOWN_TYPE_DEFENSIVE_TARGET,
    ["defensive-personal"] = CONST_COOLDOWN_TYPE_DEFENSIVE_PERSONAL,
    ["ofensive"] = CONST_COOLDOWN_TYPE_OFFENSIVE,
    ["utility"] = CONST_COOLDOWN_TYPE_UTILITY,
    ["interrupt"] = CONST_COOLDOWN_TYPE_INTERRUPT,
}

function openRaidLib.CooldownManager.DoesSpellPassFilter(spellId, filters)
    local allCooldownsData = LIB_OPEN_RAID_COOLDOWNS_INFO
    local cooldownData = allCooldownsData[spellId]
    if (cooldownData) then
        for filter in filters:gmatch("([^,%s]+)") do
            local cooldownType = filterStringToCooldownType[filter]
            if (cooldownData.type == cooldownType) then
                return true
            end
        end
    else
        return false
    end
end

local getCooldownsForFilter = function(unitName, allCooldowns, unitDataFilteredCache, filter)
    local allCooldownsData = LIB_OPEN_RAID_COOLDOWNS_INFO
    local filterTable = unitDataFilteredCache[filter]
    --if the unit already sent its full list of cooldowns, the cache can be built
    --when NeedRebuildFilters is true, HasFullCooldownList is always true

    --bug: filterTable is nil and HasFullCooldownList is also nil, happening after leaving a grou´p internal callback
    if ((not filterTable and openRaidLib.CooldownManager.HasFullCooldownList[unitName]) or openRaidLib.CooldownManager.NeedRebuildFilters[unitName]) then
        filterTable = {}
        unitDataFilteredCache[filter] = filterTable

        for spellId, cooldownInfo in pairs(allCooldowns) do
            local cooldownData = allCooldownsData[spellId]
            if (cooldownData and cooldownData.type == filterStringToCooldownType[filter]) then
                filterTable[spellId] = cooldownInfo
            end
        end
    end
    return filterTable
end

--@allCooldowns: all cooldowns sent by an unit, {[spellId] = cooldownInfo}
--@filters: string with filters, "defensive-raid, "defensive-personal"
function openRaidLib.FilterCooldowns(unitName, allCooldowns, filters)
    local allDataFiltered = openRaidLib.CooldownManager.UnitDataFilterCache --["unitName"] = {defensive-raid = {[spellId = cooldownInfo]}}
    local unitDataFilteredCache = allDataFiltered[unitName]
    if (not unitDataFilteredCache) then
        unitDataFilteredCache = {}
        allDataFiltered[unitName] = unitDataFilteredCache
    end

    --before break the string into parts and build the filters, attempt to get cooldowns from the cache using the whole filter string
    local filterAlreadyInCache = unitDataFilteredCache[filters]
    if (filterAlreadyInCache and not openRaidLib.CooldownManager.NeedRebuildFilters[unitName]) then
        return filterAlreadyInCache
    end

    local allCooldownsData = LIB_OPEN_RAID_COOLDOWNS_INFO
    local resultFilters = {}

    --break the string into pieces and filter cooldowns
    for filter in filters:gmatch("([^,%s]+)") do
        local filterTable = getCooldownsForFilter(unitName, allCooldowns, unitDataFilteredCache, filter)
        if (filterTable) then
            openRaidLib.TCopy(resultFilters, filterTable)  --filter table is nil
        end
    end

    --cache the whole filter string
    if (next(resultFilters)) then
        unitDataFilteredCache[filters] = resultFilters
    end

    return resultFilters
end
