-- This file is loaded from "CanIMogIt.toc"

local L = CanIMogIt.L

CanIMogIt.DressUpModel = CreateFrame('DressUpModel')
CanIMogIt.DressUpModel:SetUnit('player')


-----------------------------
-- Maps                    --
-----------------------------

---- Transmog Categories
-- 1 Head
-- 2 Shoulder
-- 3 Back
-- 4 Chest
-- 5 Shirt
-- 6 Tabard
-- 7 Wrist
-- 8 Hands
-- 9 Waist
-- 10 Legs
-- 11 Feet
-- 12 Wand
-- 13 One-Handed Axes
-- 14 One-Handed Swords
-- 15 One-Handed Maces
-- 16 Daggers
-- 17 Fist Weapons
-- 18 Shields
-- 19 Held In Off-hand
-- 20 Two-Handed Axes
-- 21 Two-Handed Swords
-- 22 Two-Handed Maces
-- 23 Staves
-- 24 Polearms
-- 25 Bows
-- 26 Guns
-- 27 Crossbows
-- 28 Warglaives


local HEAD = "INVTYPE_HEAD"
local SHOULDER = "INVTYPE_SHOULDER"
local BODY = "INVTYPE_BODY"
local CHEST = "INVTYPE_CHEST"
local ROBE = "INVTYPE_ROBE"
local WAIST = "INVTYPE_WAIST"
local LEGS = "INVTYPE_LEGS"
local FEET = "INVTYPE_FEET"
local WRIST = "INVTYPE_WRIST"
local HAND = "INVTYPE_HAND"
local CLOAK = "INVTYPE_CLOAK"
local WEAPON = "INVTYPE_WEAPON"
local SHIELD = "INVTYPE_SHIELD"
local WEAPON_2HAND = "INVTYPE_2HWEAPON"
local WEAPON_MAIN_HAND = "INVTYPE_WEAPONMAINHAND"
local RANGED = "INVTYPE_RANGED"
local RANGED_RIGHT = "INVTYPE_RANGEDRIGHT"
local WEAPON_OFF_HAND = "INVTYPE_WEAPONOFFHAND"
local HOLDABLE = "INVTYPE_HOLDABLE"
local TABARD = "INVTYPE_TABARD"
local BAG = "INVTYPE_BAG"


local inventorySlotsMap = {
    [HEAD] = {1},
    [SHOULDER] = {3},
    [BODY] = {4},
    [CHEST] = {5},
    [ROBE] = {5},
    [WAIST] = {6},
    [LEGS] = {7},
    [FEET] = {8},
    [WRIST] = {9},
    [HAND] = {10},
    [CLOAK] = {15},
    [WEAPON] = {16, 17},
    [SHIELD] = {17},
    [WEAPON_2HAND] = {16, 17},
    [WEAPON_MAIN_HAND] = {16},
    [RANGED] = {16},
    [RANGED_RIGHT] = {16},
    [WEAPON_OFF_HAND] = {17},
    [HOLDABLE] = {17},
    [TABARD] = {19},
}


local MISC = 0
local CLOTH = 1
local LEATHER = 2
local MAIL = 3
local PLATE = 4
local COSMETIC = 5

local classArmorTypeMap = {
    ["DEATHKNIGHT"] = PLATE,
    ["DEMONHUNTER"] = LEATHER,
    ["DRUID"] = LEATHER,
    ["HUNTER"] = MAIL,
    ["MAGE"] = CLOTH,
    ["MONK"] = LEATHER,
    ["PALADIN"] = PLATE,
    ["PRIEST"] = CLOTH,
    ["ROGUE"] = LEATHER,
    ["SHAMAN"] = MAIL,
    ["WARLOCK"] = CLOTH,
    ["WARRIOR"] = PLATE,
}


-- Class Masks
local classMask = {
    [1] = "WARRIOR",
    [2] = "PALADIN",
    [4] = "HUNTER",
    [8] = "ROGUE",
    [16] = "PRIEST",
    [32] = "DEATHKNIGHT",
    [64] = "SHAMAN",
    [128] = "MAGE",
    [256] = "WARLOCK",
    [512] = "MONK",
    [1024] = "DRUID",
    [2048] = "DEMONHUNTER",
}


local armorTypeSlots = {
    [HEAD] = true,
    [SHOULDER] = true,
    [CHEST] = true,
    [ROBE] = true,
    [WRIST] = true,
    [HAND] = true,
    [WAIST] = true,
    [LEGS] = true,
    [FEET] = true,
}


local miscArmorExceptions = {
    [HOLDABLE] = true,
    [BODY] = true,
    [TABARD] = true,
}


local APPEARANCES_ITEMS_TAB = 1
local APPEARANCES_SETS_TAB = 2


-- Get the name for Cosmetic. Uses http://www.wowhead.com/item=130064/deadeye-monocle.
local COSMETIC_NAME = select(3, GetItemInfoInstant(130064))


-- Built-in colors
-- TODO: move to constants
local BLIZZARD_RED = "|cffff1919"
local BLIZZARD_GREEN = "|cff19ff19"
local BLIZZARD_DARK_GREEN = "|cff40c040"
local BLIZZARD_YELLOW = "|cffffd100"


-------------------------
-- Text related tables --
-------------------------


-- Maps a text to its simpler version
local simpleTextMap = {
    [CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER] = CanIMogIt.KNOWN,
    [CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER_BOE] = CanIMogIt.KNOWN_BOE,
    [CanIMogIt.KNOWN_BUT_TOO_LOW_LEVEL] = CanIMogIt.KNOWN,
    [CanIMogIt.KNOWN_BUT_TOO_LOW_LEVEL_BOE] = CanIMogIt.KNOWN_BOE,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL] = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL_BOE] = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BOE,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER] = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER_BOE] = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BOE,
}


-- List of all Known texts
local knownTexts = {
    [CanIMogIt.KNOWN] = true,
    [CanIMogIt.KNOWN_BOE] = true,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM] = true,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BOE] = true,
    [CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER] = true,
    [CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER_BOE] = true,
    [CanIMogIt.KNOWN_BUT_TOO_LOW_LEVEL] = true,
    [CanIMogIt.KNOWN_BUT_TOO_LOW_LEVEL_BOE] = true,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL] = true,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL_BOE] = true,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER] = true,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER_BOE] = true,
}


local unknownTexts = {
    [CanIMogIt.UNKNOWN] = true,
    [CanIMogIt.UNKNOWABLE_BY_CHARACTER] = true,
}


-----------------------------
-- Exceptions              --
-----------------------------


local exceptionItems = {
    [HEAD] = {
        -- [134110] = CanIMogIt.KNOWN, -- Hidden Helm
        [133320] = CanIMogIt.NOT_TRANSMOGABLE, -- Illidari Blindfold (Alliance)
        [112450] = CanIMogIt.NOT_TRANSMOGABLE, -- Illidari Blindfold (Horde)
        -- [150726] = CanIMogIt.NOT_TRANSMOGABLE, -- Illidari Blindfold (Alliance) - starting item
        -- [150716] = CanIMogIt.NOT_TRANSMOGABLE, -- Illidari Blindfold (Horde) - starting item
        [130064] = CanIMogIt.NOT_TRANSMOGABLE, -- Deadeye Monocle
    },
    [SHOULDER] = {
        [119556] = CanIMogIt.NOT_TRANSMOGABLE, -- Trailseeker Spaulders - 100 Salvage Yard ilvl 610
        [117106] = CanIMogIt.NOT_TRANSMOGABLE, -- Trailseeker Spaulders - 90 boost ilvl 483
        [129714] = CanIMogIt.NOT_TRANSMOGABLE, -- Trailseeker Spaulders - 100 trial/boost ilvl 640
        [150642] = CanIMogIt.NOT_TRANSMOGABLE, -- Trailseeker Spaulders - 100 trial/boost ilvl 600
        [153810] = CanIMogIt.NOT_TRANSMOGABLE, -- Trailseeker Spaulders - 110 trial/boost ilvl 870
        [162796] = CanIMogIt.NOT_TRANSMOGABLE, -- Wildguard Spaulders - 8.0 BfA Pre-Patch event
        [119588] = CanIMogIt.NOT_TRANSMOGABLE, -- Mistdancer Pauldrons - 100 Salvage Yard ilvl 610
        [117138] = CanIMogIt.NOT_TRANSMOGABLE, -- Mistdancer Pauldrons - 90 boost ilvl 483
        [129485] = CanIMogIt.NOT_TRANSMOGABLE, -- Mistdancer Pauldrons - 100 trial/boost ilvl 640
        [150658] = CanIMogIt.NOT_TRANSMOGABLE, -- Mistdancer Pauldrons - 100 trial/boost ilvl 600
        [153842] = CanIMogIt.NOT_TRANSMOGABLE, -- Mistdancer Pauldrons - 110 trial/boost ilvl 870
        [162812] = CanIMogIt.NOT_TRANSMOGABLE, -- Serene Disciple's Padding - 8.0 BfA Pre-Patch event
        [134112] = CanIMogIt.KNOWN, -- Hidden Shoulders
    },
    [BODY] = {},
    [CHEST] = {},
    [ROBE] = {},
    [WAIST] = {
        [143539] = CanIMogIt.KNOWN, -- Hidden Belt
    },
    [LEGS] = {},
    [FEET] = {},
    [WRIST] = {},
    [HAND] = {
        [119585] = CanIMogIt.NOT_TRANSMOGABLE, -- Mistdancer Handguards - 100 Salvage Yard ilvl 610
        [117135] = CanIMogIt.NOT_TRANSMOGABLE, -- Mistdancer Handguards - 90 boost ilvl 483
        [129482] = CanIMogIt.NOT_TRANSMOGABLE, -- Mistdancer Handguards - 100 trial/boost ilvl 640
        [150655] = CanIMogIt.NOT_TRANSMOGABLE, -- Mistdancer Handguards - 100 trial/boost ilvl 600
        [153839] = CanIMogIt.NOT_TRANSMOGABLE, -- Mistdancer Handguards - 110 trial/boost ilvl 870
        [162809] = CanIMogIt.NOT_TRANSMOGABLE, -- Serene Disciple's Handguards - 8.0 BfA Pre-Patch event
    },
    [CLOAK] = {
        -- [134111] = CanIMogIt.KNOWN, -- Hidden Cloak
        [112462] = CanIMogIt.NOT_TRANSMOGABLE, -- Illidari Drape
    },
    [WEAPON] = {},
    [SHIELD] = {},
    [WEAPON_2HAND] = {},
    [WEAPON_MAIN_HAND] = {},
    [RANGED] = {},
    [RANGED_RIGHT] = {},
    [WEAPON_OFF_HAND] = {},
    [HOLDABLE] = {},
    [TABARD] = {
        -- [142504] = CanIMogIt.KNOWN, -- Hidden Tabard
    },
}


-----------------------------
-- Helper functions        --
-----------------------------

CanIMogIt.Utils = {}


function CanIMogIt.Utils.pairsByKeys (t, f)
    -- returns a sorted iterator for a table.
    -- https://www.lua.org/pil/19.3.html
    -- Why is it not a built in function? ¯\_(ツ)_/¯
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
        table.sort(a, f)
        local i = 0      -- iterator variable
        local iter = function ()   -- iterator function
        i = i + 1
        if a[i] == nil then return nil
            else return a[i], t[a[i]]
        end
    end
    return iter
end


function CanIMogIt.Utils.copyTable (t)
    -- shallow-copy a table
    if type(t) ~= "table" then return t end
    local target = {}
    for k, v in pairs(t) do target[k] = v end
    return target
end


function CanIMogIt.Utils.spairs(t, order)
    -- Returns an iterator that is a sorted table. order is the function to sort by.
    -- http://stackoverflow.com/questions/15706270/sort-a-table-in-lua
    -- Again, why is this not a built in function? ¯\_(ツ)_/¯

    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end


function CanIMogIt.Utils.strsplit(delimiter, text)
    -- from http://lua-users.org/wiki/SplitJoin
    -- Split text into a list consisting of the strings in text,
    -- separated by strings matching delimiter (which may be a pattern).
    -- example: strsplit(",%s*", "Anna, Bob, Charlie,Dolores")
    local list = {}
    local pos = 1
    if string.find("", delimiter, 1) then -- this would result in endless loops
       error("delimiter matches empty string!")
    end
    while 1 do
       local first, last = string.find(text, delimiter, pos)
       if first then -- found?
          table.insert(list, string.sub(text, pos, first-1))
          pos = last+1
       else
          table.insert(list, string.sub(text, pos))
          break
       end
    end
    return list
end


function CanIMogIt.Utils.tablelength(T)
    -- Count the number of keys in a table, because tables don't bother
    -- counting themselves if it's filled with key-value pairs...
    -- ¯\_(ツ)_/¯
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end


-----------------------------
-- CanIMogIt Core methods  --
-----------------------------

-- Variables for managing updating appearances.
local appearanceIndex = 0
local sourceIndex = 0
local getAppearancesDone = false;
local sourceCount = 0
local appearanceCount = 0
local buffer = 0
local sourcesAdded = 0
local sourcesRemoved = 0


local appearancesTable = {}
local removeAppearancesTable = nil
local appearancesTableGotten = false
local doneAppearances = {}


local function GetAppearancesTable()
    -- Sort the C_TransmogCollection.GetCategoryAppearances tables into something
    -- more usable.
    if appearancesTableGotten then return end
    for categoryID=1,28 do
        local categoryAppearances = C_TransmogCollection.GetCategoryAppearances(categoryID)
        for i, categoryAppearance in pairs(categoryAppearances) do
            if categoryAppearance.isCollected then
                appearanceCount = appearanceCount + 1
                appearancesTable[categoryAppearance.visualID] = true
            end
        end
    end
    appearancesTableGotten = true
end


local function AddSource(source, appearanceID)
    -- Adds the source to the database, and increments the buffer.
    buffer = buffer + 1
    sourceCount = sourceCount + 1
    local sourceID = source.sourceID
    local sourceItemLink = CanIMogIt:GetItemLinkFromSourceID(sourceID)
    local added = CanIMogIt:DBAddItem(sourceItemLink, appearanceID, sourceID)
    if added then
        sourcesAdded = sourcesAdded + 1
    end
end


local function AddAppearance(appearanceID)
    -- Adds all of the sources for this appearanceID to the database.
    -- returns early if the buffer is reached.
    local sources = C_TransmogCollection.GetAppearanceSources(appearanceID)
    for i, source in pairs(sources) do
        if source.isCollected then
            AddSource(source, appearanceID)
        end
    end
end


-- Remembering iterators for later
local appearancesIter, removeIter = nil, nil


local function _GetAppearances()
    -- Core logic for getting the appearances.
    if getAppearancesDone then return end
    C_TransmogCollection.ClearSearch(APPEARANCES_ITEMS_TAB)
    GetAppearancesTable()
    buffer = 0

    if appearancesIter == nil then appearancesIter = CanIMogIt.Utils.pairsByKeys(appearancesTable) end
    -- Add new appearances learned.
    for appearanceID, collected in appearancesIter do
        AddAppearance(appearanceID)
        if buffer >= CanIMogIt.bufferMax then return end
        appearancesTable[appearanceID] = nil
    end

    if removeIter == nil then removeIter = CanIMogIt.Utils.pairsByKeys(removeAppearancesTable) end
    -- Remove appearances that are no longer learned.
    for appearanceHash, sources in removeIter do
        for sourceID, source in pairs(sources.sources) do
            if not C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(sourceID) then
                local itemLink = CanIMogIt:GetItemLinkFromSourceID(sourceID)
                local appearanceID = CanIMogIt:GetAppearanceIDFromSourceID(sourceID)
                CanIMogIt:DBRemoveItem(appearanceID, sourceID, itemLink)
                sourcesRemoved = sourcesRemoved + 1
            end
            buffer = buffer + 1
        end
        if buffer >= CanIMogIt.bufferMax then return end
        removeAppearancesTable[appearanceHash] = nil
    end

    getAppearancesDone = true
    appearancesTable = {} -- cleanup
    CanIMogIt:ResetCache()
    appearancesIter = nil
    removeIter = nil
    CanIMogIt.frame:SetScript("OnUpdate", nil)
    if CanIMogItOptions["printDatabaseScan"] then
        CanIMogIt:Print(CanIMogIt.DATABASE_DONE_UPDATE_TEXT..CanIMogIt.BLUE.."+" .. sourcesAdded .. ", "..CanIMogIt.ORANGE.."-".. sourcesRemoved)
    end
end


local timer = 0
local function GetAppearancesOnUpdate(self, elapsed)
    -- OnUpdate function with a reset timer to throttle getting appearances.
    timer = timer + elapsed
    if timer >= CanIMogIt.throttleTime then
        _GetAppearances()
        timer = 0
    end
end


function CanIMogIt:GetAppearances()
    -- Gets a table of all the appearances known to
    -- a character and adds it to the database.
    if CanIMogItOptions["printDatabaseScan"] then
        --CanIMogIt:Print(CanIMogIt.DATABASE_START_UPDATE_TEXT)
    end
    removeAppearancesTable = CanIMogIt.Utils.copyTable(CanIMogIt.db.global.appearances)
    CanIMogIt.frame:SetScript("OnUpdate", GetAppearancesOnUpdate)
end


function CIMI_GetVariantSets(setID)
    --[[
        It seems that C_TransmogSets.GetVariantSets(setID) returns a number
        (instead of the expected table of sets) if it can't find a matching
        base set. We currently are checking that it's returning a table first
        to prevent issues.
    ]]
    local variantSets = C_TransmogSets.GetVariantSets(setID)
    if type(variantSets) == "table" then
        return variantSets
    end
    return {}
end


function CanIMogIt:GetSets()
    -- Gets a table of all of the sets available to the character,
    -- along with their items, and adds them to the sets database.
    C_TransmogCollection.ClearSearch(APPEARANCES_SETS_TAB)
    for i, set in pairs(C_TransmogSets.GetAllSets()) do
        -- This is a base set, so we need to get the variant sets as well
        for i, sourceID in pairs(C_TransmogSets.GetAllSourceIDs(set.setID)) do
            CanIMogIt:SetsDBAddSetItem(set, sourceID)
        end
        for i, variantSet in pairs(CIMI_GetVariantSets(set.setID)) do
            for i, sourceID in pairs(C_TransmogSets.GetAllSourceIDs(variantSet.setID)) do
                CanIMogIt:SetsDBAddSetItem(variantSet, sourceID)
            end
        end
    end
end


function CanIMogIt:_GetRatio(setID)
    -- Gets the count of known and total sources for the given setID.
    local have = 0
    local total = 0
    for _, knownSource in pairs(C_TransmogSets.GetSetSources(setID)) do
        total = total + 1
        if knownSource then
            have = have + 1
        end
    end
    return have, total
end


function CanIMogIt:_GetRatioTextColor(have, total)
    if have == total then
        return CanIMogIt.BLUE
    elseif have > 0 then
        return CanIMogIt.RED_ORANGE
    else
        return CanIMogIt.GRAY
    end
end


function CanIMogIt:_GetRatioText(setID)
    -- Gets the ratio text (and color) of known/total for the given setID.
    local have, total = CanIMogIt:_GetRatio(setID)

    local ratioText = CanIMogIt:_GetRatioTextColor(have, total)
    ratioText = ratioText .. "(" .. have .. "/" .. total .. ")"
    return ratioText
end


function CanIMogIt:GetSetClass(set)
    --[[
        Returns the set's class. If it belongs to more than one class,
        return an empty string.

        This is done based on the player's sex.
        Player's sex
        1 = Neutrum / Unknown
        2 = Male
        3 = Female
    ]]
    local playerSex = UnitSex("player")
    local className
    if playerSex == 2 then
        className = LOCALIZED_CLASS_NAMES_MALE[classMask[set.classMask]]
    else
        className = LOCALIZED_CLASS_NAMES_FEMALE[classMask[set.classMask]]
    end
    return className or ""
end


local classSetIDs = nil


function CanIMogIt:CalculateSetsText(itemLink)
    --[[
        Gets the two lines of text to display on the tooltip related to sets.

        Example:

        Demon Hunter: Garb of the Something or Other
        Ulduar: 25 Man Normal (2/8)

        This function is not cached, so avoid calling often!
        Use GetSetsText whenever possible!
    ]]
    local sourceID = CanIMogIt:GetSourceID(itemLink)
    if not sourceID then return end
    local setID = CanIMogIt:SetsDBGetSetFromSourceID(sourceID)
    if not setID then return end

    local set = C_TransmogSets.GetSetInfo(setID)

    local ratioText = CanIMogIt:_GetRatioText(setID)

    -- Build the classSetIDs table, if it hasn't been built yet.
    if classSetIDs == nil then
        classSetIDs = {}
        for i, baseSet in pairs(C_TransmogSets.GetBaseSets()) do
            classSetIDs[baseSet.setID] = true
            for i, variantSet in pairs(C_TransmogSets.GetVariantSets(baseSet.setID)) do
                classSetIDs[variantSet.setID] = true
            end
        end
    end

    local setNameColor, otherClass
    if classSetIDs[set.setID] then
        setNameColor = CanIMogIt.WHITE
        otherClass = ""
    else
        setNameColor = CanIMogIt.GRAY
        otherClass = CanIMogIt:GetSetClass(set) .. ": "
    end


    local secondLineText = ""
    if set.label and set.description then
        secondLineText = CanIMogIt.WHITE .. set.label .. ": " .. BLIZZARD_GREEN ..  set.description .. " "
    elseif set.label then
        secondLineText = CanIMogIt.WHITE .. set.label .. " "
    elseif set.description then
        secondLineText = BLIZZARD_GREEN .. set.description .. " "
    end
    -- TODO: replace CanIMogIt.WHITE with setNameColor, add otherClass
    -- e.g.: setNameColor .. otherClass .. set.name
    return CanIMogIt.WHITE .. set.name, secondLineText .. ratioText
end


function CanIMogIt:GetSetsText(itemLink)
    -- Gets the cached text regarding the sets info for the given item.
    local line1, line2;
    if CanIMogIt.cache:GetSetsInfoTextValue(itemLink) then
        line1, line2 = unpack(CanIMogIt.cache:GetSetsInfoTextValue(itemLink))
        return line1, line2
    end

    line1, line2 = CanIMogIt:CalculateSetsText(itemLink)

    CanIMogIt.cache:SetSetsInfoTextValue(itemLink, {line1, line2})

    return line1, line2
end


function CanIMogIt:CalculateSetsVariantText(setID)
    --[[
        Given a setID, calculate the sum of all known sources for this set
        and it's variants.
    ]]

    local baseSetID = C_TransmogSets.GetBaseSetID(setID)

    local variantSets = {C_TransmogSets.GetSetInfo(baseSetID)}
    for i, variantSet in ipairs(CIMI_GetVariantSets(baseSetID)) do
        variantSets[#variantSets+1] = variantSet
    end

    local variantsText = ""

    for i, variantSet in CanIMogIt.Utils.spairs(variantSets, function(t,a,b) return t[a].uiOrder < t[b].uiOrder end) do
        local variantHave, variantTotal = CanIMogIt:_GetRatio(variantSet.setID)

        variantsText = variantsText .. CanIMogIt:_GetRatioTextColor(variantHave, variantTotal)

        -- There is intentionally an extra space before the newline, for positioning.
        variantsText = variantsText .. variantHave .. "/" .. variantTotal .. " \n"
    end

    -- uncomment for debug
    -- variantsText = variantsText .. "setID: " .. setID

    return string.sub(variantsText, 1, -2)
end


function CanIMogIt:GetSetsVariantText(setID)
    -- Gets the cached text regarding the sets info for the given item.
    if not setID then return end
    local line1;
    if CanIMogIt.cache:GetSetsSumRatioTextValue(setID) then
        line1 = CanIMogIt.cache:GetSetsSumRatioTextValue(setID)
        return line1
    end

    line1 = CanIMogIt:CalculateSetsVariantText(setID)

    CanIMogIt.cache:SetSetsSumRatioTextValue(setID, line1)

    return line1
end


function CanIMogIt:ResetCache()
    -- Resets the cache, and calls things relying on the cache being reset.
    CanIMogIt.cache:Clear()
    CanIMogIt:SendMessage("ResetCache")
    -- Fake a BAG_UPDATE event to updating the icons. TODO: Replace this with message
    CanIMogIt.frame:ItemOverlayEvents("BAG_UPDATE")
end


function CanIMogIt:CalculateSourceLocationText(itemLink)
    --[[
        Calculates the sources for this item.
        This function is not cached, so avoid calling often!
        Use GetSourceLocationText whenever possible!
    ]]
    local output = ""

    local appearanceID = CanIMogIt:GetAppearanceID(itemLink)
    if appearanceID == nil then return end
    local sources = C_TransmogCollection.GetAppearanceSources(appearanceID)
    if sources then
        local totalSourceTypes = { 0, 0, 0, 0, 0, 0 }
        local knownSourceTypes = { 0, 0, 0, 0, 0, 0 }
        local totalUnknownType = 0
        local knownUnknownType = 0
        for _, source in pairs(sources) do
            if source.sourceType ~= 0 and source.sourceType ~= nil then
                totalSourceTypes[source.sourceType] = totalSourceTypes[source.sourceType] + 1
                if source.isCollected then
                    knownSourceTypes[source.sourceType] = knownSourceTypes[source.sourceType] + 1
                end
            elseif source.sourceType == 0 and source.isCollected then
                totalUnknownType = totalUnknownType + 1
                knownUnknownType = knownUnknownType + 1
            end
        end
        for sourceType, totalCount in ipairs(totalSourceTypes) do
            if (totalCount > 0) then
                local knownCount = knownSourceTypes[sourceType]
                local knownColor = CanIMogIt.RED_ORANGE
                if knownCount == totalCount then
                    knownColor = CanIMogIt.GRAY
                elseif knownCount > 0 then
                    knownColor = CanIMogIt.BLUE
                end
                output = string.format("%s"..knownColor.."%s ("..knownColor.."%i/%i"..knownColor..")"..CanIMogIt.WHITE..", ",
                    output, _G["TRANSMOG_SOURCE_"..sourceType], knownCount, totalCount)
            end
        end
        if totalUnknownType > 0 then
            output = string.format("%s"..CanIMogIt.GRAY.."Unobtainable ("..CanIMogIt.GRAY.."%i/%i"..CanIMogIt.GRAY..")"..CanIMogIt.WHITE..", ",
                output, knownUnknownType, totalUnknownType)
        end
        output = string.sub(output, 1, -3)
    end
    return output
end


function CanIMogIt:GetSourceLocationText(itemLink)
    -- Returns string of the all the types of sources which can provide an item with this appearance.

    cached_value = CanIMogIt.cache:GetItemSourcesValue(itemLink)
    if cached_value then
        return cached_value
    end

    local output = CanIMogIt:CalculateSourceLocationText(itemLink)

    CanIMogIt.cache:SetItemSourcesValue(itemLink, output)

    return output
end


function CanIMogIt:GetPlayerArmorTypeName()
    local playerArmorTypeID = classArmorTypeMap[select(2, UnitClass("player"))]
    return select(1, GetItemSubClassInfo(4, playerArmorTypeID))
end


function CanIMogIt:GetItemID(itemLink)
    return tonumber(itemLink:match("item:(%d+)"))
end


function CanIMogIt:GetItemLinkFromSourceID(sourceID)
    return select(6, C_TransmogCollection.GetAppearanceSourceInfo(sourceID))
end


function CanIMogIt:GetItemQuality(itemID)
    return select(3, GetItemInfo(itemID))
end


function CanIMogIt:GetItemMinLevel(itemLink)
    return select(5, GetItemInfo(itemLink))
end


function CanIMogIt:GetItemClassName(itemLink)
    return select(2, GetItemInfoInstant(itemLink))
end


function CanIMogIt:GetItemSubClassName(itemLink)
    return select(3, GetItemInfoInstant(itemLink))
end


function CanIMogIt:GetItemSlotName(itemLink)
    return select(4, GetItemInfoInstant(itemLink))
end


function CanIMogIt:IsReadyForCalculations(itemLink)
    -- Returns true of the item's GetItemInfo is ready, or if it's a keystone.
    local itemInfo = GetItemInfo(itemLink)
    local type = string.match(itemLink, ".*(keystone):.*")
    if not itemInfo and type ~= "keystone" then
        return false
    end
    return true
end


function CanIMogIt:IsItemArmor(itemLink)
    local itemClass = CanIMogIt:GetItemClassName(itemLink)
    if itemClass == nil then return end
    return GetItemClassInfo(4) == itemClass
end


function CanIMogIt:IsArmorSubClassID(subClassID, itemLink)
    local itemSubClass = CanIMogIt:GetItemSubClassName(itemLink)
    if itemSubClass == nil then return end
    return select(1, GetItemSubClassInfo(4, subClassID)) == itemSubClass
end


function CanIMogIt:IsArmorSubClassName(subClassName, itemLink)
    local itemSubClass = CanIMogIt:GetItemSubClassName(itemLink)
    if itemSubClass == nil then return end
    return subClassName == itemSubClass
end


function CanIMogIt:IsItemSubClassIdentical(itemLinkA, itemLinkB)
    local subClassA = CanIMogIt:GetItemSubClassName(itemLinkA)
    local subClassB = CanIMogIt:GetItemSubClassName(itemLinkB)
    if subClassA == nil or subClassB == nil then return end
    return subClassA == subClassB
end


function CanIMogIt:IsArmorCosmetic(itemLink)
    return CanIMogIt:IsArmorSubClassID(COSMETIC, itemLink)
end


function CanIMogIt:IsArmorAppropriateForPlayer(itemLink)
    local playerArmorTypeID = CanIMogIt:GetPlayerArmorTypeName()
    local slotName = CanIMogIt:GetItemSlotName(itemLink)
    if slotName == nil then return end
    local isArmorCosmetic = CanIMogIt:IsArmorCosmetic(itemLink)
    if isArmorCosmetic == nil then return end
    if armorTypeSlots[slotName] and isArmorCosmetic == false then
        return playerArmorTypeID == CanIMogIt:GetItemSubClassName(itemLink)
    else
        return true
    end
end


function CanIMogIt:CharacterCanEquipItem(itemLink)
    if CanIMogIt:IsItemArmor(itemLink) and CanIMogIt:IsArmorCosmetic(itemLink) then
        return true
    end
    local redText = CanIMogItTooltipScanner:GetRedText(itemLink)
    if redText == "" or redText == nil then
        return true
    end
    local itemID = CanIMogIt:GetItemID(itemLink)
    if redText == _G["ITEM_SPELL_KNOWN"] and C_Heirloom.IsItemHeirloom(itemID) then
        -- Special case for heirloom items. They always have red text if it was learned.
        return true
    end
    return false
end


function CanIMogIt:IsValidAppearanceForCharacter(itemLink)
    if CanIMogIt:CharacterCanEquipItem(itemLink) then
        if CanIMogIt:IsItemArmor(itemLink) then
            return CanIMogIt:IsArmorAppropriateForPlayer(itemLink)
        else
            return true
        end
    else
        return false
    end
end


function CanIMogIt:CharacterIsTooLowLevelForItem(itemLink)
    local minLevel = CanIMogIt:GetItemMinLevel(itemLink)
    if minLevel == nil then return end
    return UnitLevel("player") < minLevel
end


function CanIMogIt:IsItemSoulbound(itemLink, bag, slot)
    return CanIMogItTooltipScanner:IsItemSoulbound(itemLink, bag, slot)
end


function CanIMogIt:IsItemBindOnEquip(itemLink, bag, slot)
    return CanIMogItTooltipScanner:IsItemBindOnEquip(itemLink, bag, slot)
end


function CanIMogIt:GetItemClassRestrictions(itemLink)
    if not itemLink then return end
    return CanIMogItTooltipScanner:GetClassesRequired(itemLink)
end


function CanIMogIt:GetExceptionText(itemLink)
    -- Returns the exception text for this item, if it has one.
    local itemID = CanIMogIt:GetItemID(itemLink)
    local slotName = CanIMogIt:GetItemSlotName(itemLink)
    if slotName == nil then return end
    local slotExceptions = exceptionItems[slotName]
    if slotExceptions then
        return slotExceptions[itemID]
    end
end


function CanIMogIt:IsEquippable(itemLink)
    -- Returns whether the item is equippable or not (exluding bags)
    local slotName = CanIMogIt:GetItemSlotName(itemLink)
    if slotName == nil then return end
    return slotName ~= "" and slotName ~= BAG
end


function CanIMogIt:GetSourceID(itemLink)
    local sourceID = select(2, C_TransmogCollection.GetItemInfo(itemLink))
    if sourceID then
        return sourceID, "C_TransmogCollection.GetItemInfo"
    end

    -- Some items don't have the C_TransmogCollection.GetItemInfo data,
    -- so use the old way to find the sourceID (using the DressUpModel).
    local itemID, _, _, slotName = GetItemInfoInstant(itemLink)
    local slots = inventorySlotsMap[slotName]

    if slots == nil or slots == false or IsDressableItem(itemLink) == false then return end

    local cached_source = CanIMogIt.cache:GetDressUpModelSource(itemLink)
    if cached_source then
        return cached_source, "DressUpModel:GetSlotTransmogSources cache"
    end
    CanIMogIt.DressUpModel:SetUnit('player')
    CanIMogIt.DressUpModel:Undress()
    for i, slot in pairs(slots) do
        CanIMogIt.DressUpModel:TryOn(itemLink, slot)
        sourceID = CanIMogIt.DressUpModel:GetSlotTransmogSources(slot)
        if sourceID ~= nil and sourceID ~= 0 then
            if not CanIMogIt:IsSourceIDFromItemLink(sourceID, itemLink) then
                -- This likely means that the game hasn't finished loading things
                -- yet, so let's wait until we get good data before caching it.
                return
            end
            CanIMogIt.cache:SetDressUpModelSource(itemLink, sourceID)
            return sourceID, "DressUpModel:GetSlotTransmogSources"
        end
    end
end


function CanIMogIt:IsSourceIDFromItemLink(sourceID, itemLink)
    -- Returns whether the source ID given matches the itemLink.
    local sourceItemLink = select(6, C_TransmogCollection.GetAppearanceSourceInfo(sourceID))
    if not sourceItemLink then return false end
    return CanIMogIt:DoItemIDsMatch(sourceItemLink, itemLink)
end


function CanIMogIt:DoItemIDsMatch(itemLinkA, itemLinkB)
    return CanIMogIt:GetItemID(itemLinkA) == CanIMogIt:GetItemID(itemLinkB)
end


function CanIMogIt:GetAppearanceID(itemLink)
    -- Gets the appearanceID of the given item. Also returns the sourceID, for convenience.
    local sourceID = CanIMogIt:GetSourceID(itemLink)
    return CanIMogIt:GetAppearanceIDFromSourceID(sourceID), sourceID
end


function CanIMogIt:GetAppearanceIDFromSourceID(sourceID)
    -- Gets the appearanceID from the sourceID.
    if sourceID ~= nil then
        local appearanceID = select(2, C_TransmogCollection.GetAppearanceSourceInfo(sourceID))
        return appearanceID
    end
end


function CanIMogIt:_PlayerKnowsTransmog(itemLink, appearanceID)
    -- Internal logic for determining if the item is known or not.
    -- Does not use the CIMI database.
    if itemLink == nil or appearanceID == nil then return end
    local sources = C_TransmogCollection.GetAppearanceSources(appearanceID)
    if sources then
        for i, source in pairs(sources) do
            local sourceItemLink = CanIMogIt:GetItemLinkFromSourceID(source.sourceID)
            if CanIMogIt:IsItemSubClassIdentical(itemLink, sourceItemLink) and source.isCollected then
                return true
            end
        end
    end
    return false
end


function CanIMogIt:PlayerKnowsTransmog(itemLink)
    -- Returns whether this item's appearance is already known by the player.
    local appearanceID = CanIMogIt:GetAppearanceID(itemLink)
    if appearanceID == nil then return false end
    local requirements = CanIMogIt.Requirements:GetRequirements()
    if CanIMogIt:DBHasAppearanceForRequirements(appearanceID, itemLink, requirements) then
        if CanIMogIt:IsItemArmor(itemLink) then
            -- The character knows the appearance, check that it's from the same armor type.
            for sourceID, knownItem in pairs(CanIMogIt:DBGetSources(appearanceID, itemLink)) do
                if CanIMogIt:IsArmorSubClassName(knownItem.subClass, itemLink)
                        or knownItem.subClass == COSMETIC_NAME then
                    return true
                end
            end
        else
            -- Is not armor, don't worry about same appearance for different types
            return true
        end
    end

    -- Don't know from the database, try using the API.
    local knowsTransmog = CanIMogIt:_PlayerKnowsTransmog(itemLink, appearanceID)
    if knowsTransmog then
        CanIMogIt:DBAddItem(itemLink)
    end
    return knowsTransmog
end


function CanIMogIt:PlayerKnowsTransmogFromItem(itemLink)
    -- Returns whether the transmog is known from this item specifically.
    local slotName = CanIMogIt:GetItemSlotName(itemLink)
    if slotName == TABARD then
        local itemID = CanIMogIt:GetItemID(itemLink)
        return C_TransmogCollection.PlayerHasTransmog(itemID)
    end
    local appearanceID, sourceID = CanIMogIt:GetAppearanceID(itemLink)
    if sourceID == nil then return end

    -- First check the Database
    if CanIMogIt:DBHasSource(appearanceID, sourceID, itemLink) then
        return true
    end

    local hasTransmog;
    hasTransmog = C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(sourceID)

    -- Update Database
    if hasTransmog then
        CanIMogIt:DBAddItem(itemLink, appearanceID, sourceID)
    end

    return hasTransmog
end


function CanIMogIt:CharacterCanLearnTransmog(itemLink)
    -- Returns whether the player can learn the item or not.
    local slotName = CanIMogIt:GetItemSlotName(itemLink)
    if slotName == TABARD then return true end
    local sourceID = CanIMogIt:GetSourceID(itemLink)
    if sourceID == nil then return end
    if select(2, C_TransmogCollection.PlayerCanCollectSource(sourceID)) then
        return true
    end
    return false
end


function CanIMogIt:GetReason(itemLink)
    local reason = CanIMogItTooltipScanner:GetRedText(itemLink)
    if reason == "" then
        reason = CanIMogIt:GetItemSubClassName(itemLink)
    end
    return reason
end


function CanIMogIt:IsTransmogable(itemLink)
    -- Returns whether the item is transmoggable or not.

    -- White items are not transmoggable.
    local quality = CanIMogIt:GetItemQuality(itemLink)
    if quality == nil then return end
    if quality <= 1 then
        return false
    end

    local is_misc_subclass = CanIMogIt:IsArmorSubClassID(MISC, itemLink)
    if is_misc_subclass and miscArmorExceptions[CanIMogIt:GetItemSlotName(itemLink)] == nil then
        return false
    end

    local itemID, _, _, slotName = GetItemInfoInstant(itemLink)

    -- See if the game considers it transmoggable
    local transmoggable = select(3, C_Transmog.GetItemInfo(itemID))
    if transmoggable == false then
        return false
    end

    -- See if the item is in a valid transmoggable slot
    if inventorySlotsMap[slotName] == nil then
        return false
    end
    return true
end


function CanIMogIt:TextIsKnown(text)
    -- Returns whether the text is considered to be a KNOWN value or not.
    return knownTexts[text] or false
end


function CanIMogIt:TextIsUnknown(unmodifiedText)
    -- Returns whether the text is considered to be an UNKNOWN value or not.
    return unknownTexts[unmodifiedText] or false
end


function CanIMogIt:PreLogicOptionsContinue(itemLink)
    -- Apply the options. Returns false if it should stop the logic.
    if CanIMogItOptions["showEquippableOnly"] and
            not CanIMogIt:IsEquippable(itemLink) then
        -- Don't bother if it's not equipable.
        return false
    end

    return true
end


function CanIMogIt:PostLogicOptionsText(text, unmodifiedText)
    -- Apply the options to the text. Returns the relevant text.

    if CanIMogItOptions["showUnknownOnly"] and not CanIMogIt:TextIsUnknown(unmodifiedText) then
        -- We don't want to show the tooltip if it's already known.
        return "", ""
    end

    if CanIMogItOptions["showTransmoggableOnly"]
            and (unmodifiedText == CanIMogIt.NOT_TRANSMOGABLE
            or unmodifiedText == CanIMogIt.NOT_TRANSMOGABLE_BOE) then
        -- If we don't want to show the tooltip if it's not transmoggable
        return "", ""
    end

    if not CanIMogItOptions["showVerboseText"] then
        text = simpleTextMap[text] or text
    end

    return text, unmodifiedText
end


function CanIMogIt:CalculateTooltipText(itemLink, bag, slot)
    --[[
        Calculate the tooltip text.
        No caching is done here, so don't call this often!
        Use GetTooltipText whenever possible!
    ]]
    local exception_text = CanIMogIt:GetExceptionText(itemLink)
    if exception_text then
        return exception_text, exception_text
    end

    local isTransmogable = CanIMogIt:IsTransmogable(itemLink)
    -- if isTransmogable == nil then return end

    local playerKnowsTransmogFromItem, isValidAppearanceForCharacter, characterIsTooLowLevel,
        playerKnowsTransmog, characterCanLearnTransmog, isItemSoulbound, text, unmodifiedText;

    local isItemSoulbound = CanIMogIt:IsItemSoulbound(itemLink, bag, slot)
    if isItemSoulbound == nil then return end

    if isTransmogable then
        --Calculating the logic for each rule
        playerKnowsTransmogFromItem = CanIMogIt:PlayerKnowsTransmogFromItem(itemLink)
        if playerKnowsTransmogFromItem == nil then return end

        isValidAppearanceForCharacter = CanIMogIt:IsValidAppearanceForCharacter(itemLink)
        if isValidAppearanceForCharacter == nil then return end

        characterIsTooLowLevel = CanIMogIt:CharacterIsTooLowLevelForItem(itemLink)
        if characterIsTooLowLevel == nil then return end

        playerKnowsTransmog = CanIMogIt:PlayerKnowsTransmog(itemLink)
        if playerKnowsTransmog == nil then return end

        characterCanLearnTransmog = CanIMogIt:CharacterCanLearnTransmog(itemLink)
        if characterCanLearnTransmog == nil then return end

        if playerKnowsTransmogFromItem then
            if isValidAppearanceForCharacter then
                -- Player knows appearance and can transmog it
                text = CanIMogIt.KNOWN
                unmodifiedText = CanIMogIt.KNOWN
            else
                -- Player knows appearance but this character cannot transmog it
                if characterCanLearnTransmog and characterIsTooLowLevel then
                    -- If this character is too low level
                    text = CanIMogIt.KNOWN_BUT_TOO_LOW_LEVEL
                    unmodifiedText = CanIMogIt.KNOWN_BUT_TOO_LOW_LEVEL
                else
                    -- If this character cannot use the transmog
                    text = CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER
                    unmodifiedText = CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER
                end
            end
        elseif playerKnowsTransmog then
            if isValidAppearanceForCharacter then
                -- Player knows appearance from another item
                text = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM
                unmodifiedText = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM
            else
                -- Player knows appearance from another item but cannot transmog it
                if characterCanLearnTransmog and characterIsTooLowLevel then
                    text = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL
                    unmodifiedText = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL
                else
                    text = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER
                    unmodifiedText = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER
                end
            end
        else
            if characterCanLearnTransmog then
                -- Player does not know the appearance and can learn it on this character.
                text = CanIMogIt.UNKNOWN
                unmodifiedText = CanIMogIt.UNKNOWN
            else
                if isItemSoulbound then
                    -- Cannot learn it because it is soulbound.
                    text = CanIMogIt.UNKNOWABLE_SOULBOUND
                            .. BLIZZARD_RED .. CanIMogIt:GetReason(itemLink)
                    unmodifiedText = CanIMogIt.UNKNOWABLE_SOULBOUND
                else
                    -- Cannot learn it and it is Bind on Equip.
                    text = CanIMogIt.UNKNOWABLE_BY_CHARACTER
                            .. BLIZZARD_RED .. CanIMogIt:GetReason(itemLink)
                    unmodifiedText = CanIMogIt.UNKNOWABLE_BY_CHARACTER
                end
            end
        end
    else
        text = CanIMogIt.NOT_TRANSMOGABLE
        unmodifiedText = CanIMogIt.NOT_TRANSMOGABLE
    end

    -- if CanIMogItOptions["showBoEColors"] then
    --     -- Apply the option, if it is enabled then check item bind.
    --     text, unmodifiedText = CanIMogIt:CheckItemBindType(text, unmodifiedText, itemLink, bag, slot)
    -- end

    return text, unmodifiedText
end


function CanIMogIt:CheckItemBindType(text, unmodifiedText, itemLink, bag, slot)
    --[[
        Check what binding text is used on the tooltip and then
        change the Can I Mog It text where appropirate.
    ]]
    local isItemBindOnEquip = CanIMogIt:IsItemBindOnEquip(itemLink, bag, slot)
    if isItemBindOnEquip == nil then return end

    if isItemBindOnEquip then
        if unmodifiedText == CanIMogIt.KNOWN then
            text = CanIMogIt.KNOWN_BOE
            unmodifiedText = CanIMogIt.KNOWN_BOE
        elseif unmodifiedText == CanIMogIt.KNOWN_BUT_TOO_LOW_LEVEL then
            text = CanIMogIt.KNOWN_BUT_TOO_LOW_LEVEL_BOE
            unmodifiedText = CanIMogIt.KNOWN_BUT_TOO_LOW_LEVEL_BOE
        elseif unmodifiedText == CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER then
            text = CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER_BOE
            unmodifiedText = CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER_BOE
        elseif unmodifiedText == CanIMogIt.KNOWN_FROM_ANOTHER_ITEM then
            text = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BOE
            unmodifiedText = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BOE
        elseif unmodifiedText == CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL then
            text = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL_BOE
            unmodifiedText = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL_BOE
        elseif unmodifiedText == CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER then
            text = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER_BOE
            unmodifiedText = CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER_BOE
        elseif unmodifiedText == CanIMogIt.NOT_TRANSMOGABLE then
            text = CanIMogIt.NOT_TRANSMOGABLE_BOE
            unmodifiedText = CanIMogIt.NOT_TRANSMOGABLE_BOE
        end
    -- elseif BoA
    end
    return text, unmodifiedText
end


local foundAnItemFromBags = false


function CanIMogIt:GetTooltipText(itemLink, bag, slot)
    --[[
        Gets the text to display on the tooltip from the itemLink.

        If bag and slot are given, this will use the itemLink from
        bag and slot instead.

        Returns two things:
            the text to display.
            the unmodifiedText that can be used for lookup values.
    ]]
    if bag and slot then
        itemLink = GetContainerItemLink(bag, slot)
        if not itemLink then
            if foundAnItemFromBags then
                return "", ""
            else
                -- If we haven't found any items in the bags yet, then
                -- it's likely that the inventory hasn't been loaded yet.
                return nil
            end
        else
            foundAnItemFromBags = true
        end
    end
    if not itemLink then return "", "" end
    if not CanIMogIt:IsReadyForCalculations(itemLink) then
        return
    end

    local text = ""
    local unmodifiedText = ""

    if not CanIMogIt:PreLogicOptionsContinue(itemLink) then return "", "" end

    -- Return cached items
    local cachedData = CanIMogIt.cache:GetItemTextValue(itemLink)
    if cachedData then
        local cachedText, cachedUnmodifiedText = unpack(cachedData)
        return cachedText, cachedUnmodifiedText
    end

    text, unmodifiedText = CanIMogIt:CalculateTooltipText(itemLink, bag, slot)

    text = CanIMogIt:PostLogicOptionsText(text, unmodifiedText)

    -- Update cached items
    if text ~= nil then
        CanIMogIt.cache:SetItemTextValue(itemLink, {text, unmodifiedText})
    end

    return text, unmodifiedText
end


function CanIMogIt:GetIconText(itemLink, bag, slot)
    --[[
        Gets the icon as text for this itemLink/bag+slot. Does not include the other text
        that is also caluculated.
    ]]
    local text, unmodifiedText = CanIMogIt:GetTooltipText(itemLink, bag, slot)
    local icon
    if text ~= "" and text ~= nil then
        icon = CanIMogIt.tooltipIcons[unmodifiedText]
    else
        icon = ""
    end
    return icon
end
