--[[
Name: DRList-1.0
Description: Diminishing returns database. Fork of DRData-1.0.
Website: https://www.curseforge.com/wow/addons/drlist-1-0
Documentation: https://wardz.github.io/DRList-1.0/
Version: v1.1.1
Dependencies: LibStub
License: MIT
]]

--- DRList-1.0
-- @module DRList-1.0
local MAJOR, MINOR = "DRList-1.0", 9
local Lib = assert(LibStub, MAJOR .. " requires LibStub."):NewLibrary(MAJOR, MINOR)
if not Lib then return end -- already loaded

-------------------------------------------------------------------------------
-- *** LOCALIZATIONS ARE AUTOMATICALLY GENERATED ***
-- Please see Curseforge localization page if you'd like to help translate.
-- https://www.curseforge.com/wow/addons/drlist-1-0/localization
local L = {}
Lib.L = L
L["DISARMS"] = "Disarms"
L["DISORIENTS"] = "Disorients"
L["INCAPACITATES"] = "Incapacitates"
L["KNOCKBACKS"] = "Knockbacks"
L["ROOTS"] = "Roots"
L["SILENCES"] = "Silences"
L["STUNS"] = "Stuns"
L["TAUNTS"] = "Taunts"

-- Classic
L["FEARS"] = "Fears"
L["RANDOM_ROOTS"] = "Random roots"
L["RANDOM_STUNS"] = "Random stuns"
L["MIND_CONTROL"] = GetSpellInfo(605)
L["FROST_SHOCK"] = GetSpellInfo(8056) or GetSpellInfo(196840)
L["KIDNEY_SHOT"] = GetSpellInfo(408)

-- luacheck: push ignore 542
local locale = GetLocale()
if locale == "deDE" then
    --@localization(locale="deDE", namespace="Categories", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "frFR" then
    --@localization(locale="frFR", namespace="Categories", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "itIT" then
    --@localization(locale="itIT", namespace="Categories", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "koKR" then
    --@localization(locale="koKR", namespace="Categories", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "ptBR" then
    --@localization(locale="ptBR", namespace="Categories", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "ruRU" then
    --@localization(locale="ruRU", namespace="Categories", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "esES" then
    --@localization(locale="esES", namespace="Categories", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "esMX" then
    --@localization(locale="esMX", namespace="Categories", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "zhCN" then
    --@localization(locale="zhCN", namespace="Categories", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "zhTW" then
    --@localization(locale="zhTW", namespace="Categories", format="lua_additive_table", handle-unlocalized="ignore")@
end
-- luacheck: pop
-------------------------------------------------------------------------------

-- Whether we're running Classic or Retail WoW
Lib.gameExpansion = select(4, GetBuildInfo()) < 80000 and "classic" or "retail"

-- How long it takes for a DR to expire
Lib.resetTimes = {
    retail = {
        ["default"] = 18.3, -- Always 18s after patch 6.1. (We add extra 0.3s to account for latency)
        ["knockback"] = 10.3, -- Knockbacks are immediately immune and only DRs for 10s
    },

    classic = {
        -- In classic this is between 15s and 20s, (first server tick after 15s have passed)
        -- We use 18.5 as an average reset time, 20s reset should only be in worst case scenarios.
        -- Note: This is how it worked in Vanilla, but I haven't confirmed yet if it still work this way
        -- on Classic.
        ["default"] = 18.5,
    },
}

-- List of all DR categories, english -> localized.
-- Note: unlocalized categories used for the API are always singular,
-- and localized user facing categories are always plural. (Except spell names in classic)
Lib.categoryNames = {
    retail = {
        ["disorient"] = L.DISORIENTS,
        ["incapacitate"] = L.INCAPACITATES,
        ["silence"] = L.SILENCES,
        ["stun"] = L.STUNS,
        ["root"] = L.ROOTS,
        ["disarm"] = L.DISARMS,
        ["taunt"] = L.TAUNTS,
        ["knockback"] = L.KNOCKBACKS,
    },

    classic = {
        ["incapacitate"] = L.INCAPACITATES,
        ["silence"] = L.SILENCES,
        ["stun"] = L.STUNS, -- controlled stun
        ["root"] = L.ROOTS, -- controlled root
        ["random_stun"] = L.RANDOM_STUNS, -- random proc stun, usually short (<3s)
        ["random_root"] = L.RANDOM_ROOTS, -- May be removed in the future!
        ["fear"] = L.FEARS,
        ["mind_control"] = L.MIND_CONTROL,
        ["frost_shock"] = L.FROST_SHOCK,
        ["kidney_shot"] = L.KIDNEY_SHOT,
    },
}

-- Categories that have DR against mobs (not pets).
-- Note that only elites and quest bosses usually have root/taunt DR.
Lib.categoriesPvE = {
    retail = {
        ["taunt"] = L.TAUNTS,
        ["stun"] = L.STUNS,
        ["root"] = L.ROOTS,
    },

    classic = {
        ["stun"] = L.STUNS,
        ["kidney_shot"] = L.KIDNEY_SHOT,
    },
}

-- Successives diminished durations
Lib.diminishedDurations = {
    retail = {
        -- Decreases by 50%, immune at the 4th application
        ["default"] = { 0.50, 0.25 },
        -- Decreases by 35%, immune at the 5th application
        ["taunt"] = { 0.65, 0.42, 0.27 },
        -- Immediately immune
        ["knockback"] = {},
    },

    classic = {
        ["default"] = { 0.50, 0.25 },
    },
}

-------------------------------------------------------------------------------
-- Public API
-------------------------------------------------------------------------------

--- Get table of all spells that DRs.
-- Key is the spellID, and value is the unlocalized DR category.
-- For Classic the key is the localized spell name instead, and value
-- is a table containing both the DR category and spell ID.
-- @see IterateSpellsByCategory
-- @treturn ?table {number=string}|table {string=table}
function Lib:GetSpells()
    return Lib.spellList
end

--- Get table of all DR categories.
-- Key is unlocalized name used for API functions, value is localized name used for UI.
-- @treturn table {string=string}
function Lib:GetCategories()
    return Lib.categoryNames[Lib.gameExpansion]
end

--- Get table of all categories that DRs in PvE only.
-- Key is unlocalized name used for API functions, value is localized name used for UI.
-- Tip: you can combine :GetPvECategories() and :IterateSpellsByCategory() to get spellIDs only for PvE aswell.
-- @treturn table {string=string}
function Lib:GetPvECategories()
    return Lib.categoriesPvE[Lib.gameExpansion]
end

--- Get constant for how long a DR lasts.
-- @tparam[opt="default"] string category Unlocalized category name
-- @treturn number
function Lib:GetResetTime(category)
    return Lib.resetTimes[Lib.gameExpansion][category or "default"] or Lib.resetTimes[Lib.gameExpansion].default
end

--- Get unlocalized DR category by spell ID.
-- For Classic you should pass in the spell name instead of ID.
-- For Classic you also get an optional second return value
-- which is the spell ID of the spell name you passed in.
-- @tparam number spellID
-- @treturn[1] string|nil The category name.
-- @treturn[2] number|nil The spell ID. (Classic only)
function Lib:GetCategoryBySpellID(spellID)
    if Lib.gameExpansion == "retail" then
        return Lib.spellList[spellID]
    end

    local data = Lib.spellList[spellID]
    if data then return data.category, data.spellID end
end

--- Get localized category from unlocalized category name, case sensitive.
-- @tparam string category Unlocalized category name
-- @treturn ?string|nil The localized category name.
function Lib:GetCategoryLocalization(category)
    return Lib.categoryNames[Lib.gameExpansion][category]
end

--- Check if a category has DR against mobs.
-- Note that this is only for mobs, player pets have DR on all categories.
-- Also taunt, root & cyclone only have DR against special mobs.
-- See UnitClassification() and UnitIsQuestBoss().
-- @tparam string category Unlocalized category name
-- @treturn bool
function Lib:IsPvECategory(category)
    return Lib.categoriesPvE[Lib.gameExpansion][category] and true or false -- make sure bool is always returned here
end

--- Get next successive diminished duration
-- @tparam number diminished How many times the DR has been applied so far
-- @tparam[opt="default"] string category Unlocalized category name
-- @usage local reduction = DRList:GetNextDR(1) -- returns 0.50, half duration on debuff
-- @treturn number DR percentage in decimals. Returns 0 if max DR is reached or arguments are invalid.
function Lib:GetNextDR(diminished, category)
    local durations = Lib.diminishedDurations[Lib.gameExpansion][category or "default"]
    if not durations and Lib.categoryNames[Lib.gameExpansion][category] then
        -- Redirect to default when "stun", "root" etc is passed
        durations = Lib.diminishedDurations[Lib.gameExpansion]["default"]
    end

    return durations and durations[diminished] or 0
end

do
    local next = _G.next

    local function CategoryIterator(category, index)
        local newCat
        repeat
            index, newCat = next(Lib.spellList, index)
            if index then
                if newCat == category or newCat.category == category then
                    return index, category
                end
            end
        until not index
    end

    --- Iterate through the spells of a given category.
    -- @tparam string category Unlocalized category name
    -- @usage for spellID in DRList:IterateSpellsByCategory("root") do print(spellID) end
    -- @warning Slow function, do not use for combat related stuff unless you cache results.
    -- @return Iterator function
    function Lib:IterateSpellsByCategory(category)
        assert(Lib.categoryNames[Lib.gameExpansion][category], "invalid category")
        return CategoryIterator, category
    end
end

-- keep same API as DRData-1.0 for easier transitions
Lib.GetCategoryName = Lib.GetCategoryLocalization
Lib.IsPVE = Lib.IsPvECategory
Lib.NextDR = Lib.GetNextDR
Lib.GetSpellCategory = Lib.GetCategoryBySpellID
Lib.IterateSpells = Lib.IterateSpellsByCategory
Lib.RESET_TIME = Lib.resetTimes[Lib.gameExpansion].default
Lib.pveDR = Lib.categoriesPvE
