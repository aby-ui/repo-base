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

--hold spellIds and which custom caches the spell is in
--map[spellId] = map[filterName] = true
local spellsWithCustomFiltersCache = {}

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

function openRaidLib.PackTableAndSubTables(table)
    local totalSize = 0
    local subTablesAmount = #table
    for i = 1, subTablesAmount do
        totalSize = totalSize + #table[i]
    end

    local newString = "" .. totalSize .. ","

    for i = 1, subTablesAmount do
        local subTable = table[i]
        for subIndex = 1, #subTable do
            newString = newString .. subTable[subIndex] .. ","
        end
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
local selectIndexes = function(table, startIndex, amountIndexes, zeroIfNil)
    local values = {}
    for i = startIndex, startIndex+amountIndexes do
        values[#values+1] = tonumber(table[i]) or (zeroIfNil and 0) or table[i]
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
                local values = selectIndexes(table, i+1, max(amountOfValues-2, 1), true)
                result[key] = values
            else
                local key = tonumber(table[i])
                local value = tonumber(table[i+1])
                result[key] = value
            end
        end
    else
        if (valueIsTable) then
            for i = indexStart, indexEnd, amountOfValues do
                local values = selectIndexes(table, i, amountOfValues - 1)
                tinsert(result, values)
            end
        else
            for i = indexStart, indexEnd do
                local value = tonumber(table[i])
                result[#result+1] = value
            end
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
            local unitName = GetUnitName("raid"..i, true)
            if (unitName) then
                openRaidLib.UnitIDCache[unitName] = "raid"..i
            end
        end

    elseif (IsInGroup()) then
        for i = 1, GetNumGroupMembers() - 1 do
            local unitName = GetUnitName("party"..i, true)
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

--report: "filterStringToCooldownType doesn't include the new filters."
--answer: custom filter does not have a cooldown type, it is a mesh of spells
local filterStringToCooldownType = {
    ["defensive-raid"] = CONST_COOLDOWN_TYPE_DEFENSIVE_RAID,
    ["defensive-target"] = CONST_COOLDOWN_TYPE_DEFENSIVE_TARGET,
    ["defensive-personal"] = CONST_COOLDOWN_TYPE_DEFENSIVE_PERSONAL,
    ["ofensive"] = CONST_COOLDOWN_TYPE_OFFENSIVE,
    ["utility"] = CONST_COOLDOWN_TYPE_UTILITY,
    ["interrupt"] = CONST_COOLDOWN_TYPE_INTERRUPT,
}

local filterStringToCooldownTypeReverse = {
    [CONST_COOLDOWN_TYPE_DEFENSIVE_RAID] = "defensive-raid",
    [CONST_COOLDOWN_TYPE_DEFENSIVE_TARGET] = "defensive-target",
    [CONST_COOLDOWN_TYPE_DEFENSIVE_PERSONAL] = "defensive-personal",
    [CONST_COOLDOWN_TYPE_OFFENSIVE] = "ofensive",
    [CONST_COOLDOWN_TYPE_UTILITY] = "utility",
    [CONST_COOLDOWN_TYPE_INTERRUPT] = "interrupt",
}

local removeSpellFromCustomFilterCache = function(spellId, filterName)
    local spellFilterCache = spellsWithCustomFiltersCache[spellId]
    if (spellFilterCache) then
        spellFilterCache[filterName] = nil
    end
end

local addSpellToCustomFilterCache = function(spellId, filterName)
    local spellFilterCache = spellsWithCustomFiltersCache[spellId]
    if (not spellFilterCache) then
        spellFilterCache = {}
        spellsWithCustomFiltersCache[spellId] = spellFilterCache
    end
    spellFilterCache[filterName] = true
end

local getSpellCustomFiltersFromCache = function(spellId)
    local spellFilterCache = spellsWithCustomFiltersCache[spellId]
    local result = {}
    if (spellFilterCache) then
        for filterName in pairs(spellFilterCache) do
            result[filterName] = true
        end
    end
    return result
end

--LIB_OPEN_RAID_COOLDOWNS_INFO store all registered cooldowns in the file ThingsToMantain_<game version>
function openRaidLib.CooldownManager.GetAllRegisteredCooldowns()
    return LIB_OPEN_RAID_COOLDOWNS_INFO
end

function openRaidLib.CooldownManager.GetCooldownInfo(spellId)
    return openRaidLib.CooldownManager.GetAllRegisteredCooldowns()[spellId]
end

--return a map of filter names which the spell is in, map: {[filterName] = true}
--API Call documented in the docs.txt as openRaidLib.GetSpellFilters() the declaration is on the main file of the lib
function openRaidLib.CooldownManager.GetSpellFilters(spellId, defaultFilterOnly, customFiltersOnly)
    local result = {}

    if (not customFiltersOnly) then
        local thisCooldownInfo = openRaidLib.CooldownManager.GetCooldownInfo(spellId)
        local cooldownTypeFilter = filterStringToCooldownTypeReverse[thisCooldownInfo.type]
        if (cooldownTypeFilter) then
            result[cooldownTypeFilter] = true
        end
    end

    if (defaultFilterOnly) then
        return result
    end

    local customFilters = getSpellCustomFiltersFromCache(spellId)
    for filterName in pairs(customFilters) do
        result[filterName] = true
    end

    return result
end

function openRaidLib.CooldownManager.DoesSpellPassFilters(spellId, filters)
    --table with information about a single cooldown
    local thisCooldownInfo = openRaidLib.CooldownManager.GetCooldownInfo(spellId)
    --check if this spell is registered as a cooldown
    if (thisCooldownInfo) then
        for filter in filters:gmatch("([^,%s]+)") do
            --filterStringToCooldownType is a map where the key is the filter name and value is the cooldown type
            local cooldownType = filterStringToCooldownType[filter]
            --cooldown type is a number from 1 to 8 telling its type
            if (cooldownType == thisCooldownInfo.type) then
                return true

            --check for custom filter, the custom filter name is set as a key in the cooldownInfo: cooldownInfo[filterName] = true
            elseif (thisCooldownInfo[filter]) then
                return true
            end
        end
    end

    return false
end

local getCooldownsForFilter = function(unitName, allCooldowns, unitDataFilteredCache, filter)
    local allCooldownsData = openRaidLib.CooldownManager.GetAllRegisteredCooldowns()
    local filterTable = unitDataFilteredCache[filter]
    --if the unit already sent its full list of cooldowns, the cache can be built
    --when NeedRebuildFilters is true, HasFullCooldownList is always true

    --bug: filterTable is nil and HasFullCooldownList is also nil, happening after leaving a group internal callback
    --November 06, 2022 note: is this bug still happening?

    local doesNotHaveFilterYet = not filterTable and openRaidLib.CooldownManager.HasFullCooldownList[unitName]
    local isDirty = openRaidLib.CooldownManager.NeedRebuildFilters[unitName]

    if (doesNotHaveFilterYet or isDirty) then
        --reset the filterTable
        filterTable = {}
        unitDataFilteredCache[filter] = filterTable

        --
        for spellId, cooldownInfo in pairs(allCooldowns) do
            local cooldownData = allCooldownsData[spellId]
            if (cooldownData) then
                if (cooldownData.type == filterStringToCooldownType[filter]) then
                    filterTable[spellId] = cooldownInfo

                elseif (cooldownData[filter]) then --custom filter
                    filterTable[spellId] = cooldownInfo
                end
            end
        end
    end
    return filterTable
end

--API Call
--@filterName: a string representing a name of the filter
--@spells: an array of spellIds
--important: a spell can be part of any amount of custom filters,
--declaring a spell on a new filter does NOT remove it from other filters where it was previously added
function openRaidLib.AddCooldownFilter(filterName, spells)
    --integrity check
    if (type(filterName) ~= "string") then
        openRaidLib.DiagnosticError("Usage: openRaidLib.AddFilter(string: filterName, table: spells)", debugstack())
        return false

    elseif (type(spells) ~= "table") then
        openRaidLib.DiagnosticError("Usage: openRaidLib.AddFilter(string: filterName, table: spells)", debugstack())
        return false
    end

    local allCooldownsData = openRaidLib.CooldownManager.GetAllRegisteredCooldowns()

    --iterate among the all cooldowns table and erase the filterName from all spells
    for spellId, cooldownData in pairs(allCooldownsData) do
        cooldownData[filterName] = nil
        removeSpellFromCustomFilterCache(spellId, filterName)
    end

    --iterate among spells passed within the spells table and set the new filter on them
    --problem: the filter is set directly into the global cooldown table
    --this could in rare cases make an addon to override settings of another addon
    for spellIndex, spellId in ipairs(spells) do
        local cooldownData = allCooldownsData[spellId]
        if (cooldownData) then
            cooldownData[filterName] = true
            addSpellToCustomFilterCache(spellId, filterName)
        else
            openRaidLib.DiagnosticError("A spellId on your spell list for openRaidLib.AddFilter isn't registered as cooldown:", spellId, debugstack())
        end
    end

    --tag all cache filters as dirt
    local allUnitsCooldowns = openRaidLib.GetAllUnitsCooldown()
    for unitName in pairs(allUnitsCooldowns) do
        openRaidLib.CooldownManager.NeedRebuildFilters[unitName] = true
    end

    return true
end

--API Call
--@allCooldowns: all cooldowns sent by a unit, map{[spellId] = cooldownInfo}
--@filters: string with filter names: array{"defensive-raid, "defensive-personal"}
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

--use to check if a spell is a flask buff, return a table containing .tier{}
function openRaidLib.GetFlaskInfoBySpellId(spellId)
    return LIB_OPEN_RAID_FLASK_BUFF[spellId]
end

--return a number indicating the flask tier, if the aura isn't a flask return nil
function openRaidLib.GetFlaskTierFromAura(auraInfo)
    local flaskTable = openRaidLib.GetFlaskInfoBySpellId(auraInfo.spellId)
    if (flaskTable) then
        local points = auraInfo.points
        if (points) then
            for i = 1, #points do
                local flaskTier = flaskTable.tier[points[i]]
                if (flaskTier) then
                    return flaskTier
                end
            end
        end
    end
    return nil
end

--use to check if a spell is a food buff, return a table containing .tier{} .status{} .localized{}
function openRaidLib.GetFoodInfoBySpellId(spellId)
    return LIB_OPEN_RAID_FOOD_BUFF[spellId]
end

--return a number indicating the food tier, if the aura isn't a food return nil
function openRaidLib.GetFoodTierFromAura(auraInfo)
    local foodTable = openRaidLib.GetFoodInfoBySpellId(auraInfo.spellId)
    if (foodTable) then
        local points = auraInfo.points
        if (points) then
            for i = 1, #points do
                local foodTier = foodTable.tier[points[i]]
                if (foodTier) then
                    return foodTier
                end
            end
        end
    end
    return nil
end

--called from AddUnitGearList() on LibOpenRaid file
function openRaidLib.GearManager.BuildEquipmentItemLinks(equippedGearList)
    equippedGearList = equippedGearList or {} --nil table for older versions

    for i = 1, #equippedGearList do
        local equipmentTable = equippedGearList[i]

        --equippedGearList is a indexed table with 4 indexes:
        local slotId = equipmentTable[1]
        local numGemSlots = equipmentTable[2]
        local itemLevel = equipmentTable[3]
        local partialItemLink = equipmentTable[4]

        if (partialItemLink and type(partialItemLink) == "string") then
            --get the itemId from the partial link to query the itemName with GetItemInfo
            local itemId = partialItemLink:match("^%:(%d+)%:")
            itemId = tonumber(itemId)

            if (itemId) then
                local itemName = GetItemInfo(itemId)
                if (itemName) then
                    --build the full item link
                    local itemLink = "|cFFEEEEEE|Hitem" .. partialItemLink .. "|h[" .. itemName .. "]|r"

                    --use GetItemInfo again with the now completed itemLink to query the item color
                    local _, _, itemQuality = GetItemInfo(itemLink)
                    itemQuality = itemQuality or 1
                    local qualityColor = ITEM_QUALITY_COLORS[itemQuality]

                    --replace the item color
                    --local r, g, b, hex = GetItemQualityColor(qualityColor)
                    itemLink = itemLink:gsub("FFEEEEEE", qualityColor.color:GenerateHexColor())

                    wipe(equipmentTable)

                    equipmentTable.slotId = slotId
                    equipmentTable.gemSlots = numGemSlots
                    equipmentTable.itemLevel = itemLevel
                    equipmentTable.itemLink = itemLink
                    equipmentTable.itemQuality = itemQuality
                    equipmentTable.itemId = itemId
                    equipmentTable.itemName = itemName

                    local _, _, enchantId, gemId1, gemId2, gemId3, gemId4, suffixId, uniqueId, levelOfTheItem, specId, upgradeInfo, instanceDifficultyId, numBonusIds, restLink = strsplit(":", itemLink)

                    local enchantAttribute = LIB_OPEN_RAID_ENCHANT_SLOTS[slotId]
                    local nEnchantId = 0
                    if (enchantAttribute) then --this slot can receive an enchat
                        if (enchantId and enchantId ~= "") then
                            enchantId = tonumber(enchantId)
                            nEnchantId = enchantId
                        end

                        --6400 and above is dragonflight enchantId number space
                        if (nEnchantId < 6300 and not LIB_OPEN_RAID_DEATHKNIGHT_RUNEFORGING_ENCHANT_IDS[nEnchantId]) then
                            nEnchantId = 0
                        end
                    end
                    equipmentTable.enchantId = nEnchantId

                    local nGemId = 0
                    local gemsIds = {gemId1, gemId2, gemId3, gemId4}

                    --check if the item has a socket
                    if (numGemSlots) then
                        --check if the socket is empty
                        for gemSlotId = 1, numGemSlots do
                            local gemId = tonumber(gemsIds[gemSlotId])
                            if (gemId and gemId >= 180000) then
                                nGemId = gemId
                                break
                            end
                        end
                    end

                    equipmentTable.gemId = nGemId
                end
            end
        end
    end
end
