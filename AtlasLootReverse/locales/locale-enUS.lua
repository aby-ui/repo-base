local L = LibStub("AceLocale-3.0"):NewLocale("AtlasLootReverse", "enUS", true)
if not L then return end

L["AtlasLootReverse"] = true

-- Chat commands
L["atlaslootreverse"] = true
L["alr"] = true
L["Tooltip embedded: "] = true
L["Commands:\n/alr embed - Toggles the tooltip being embedded or split into another box"] = true

L["Drops from %s"] = true  -- %s is boss (instance)
L["Heroic %s"] = true  -- %s is instance
L["25 Man %s"] = true  -- %s is instance
L["25 Man Heroic %s"] = true  -- %s is instance
L["PvP %s Set"] = true  -- %s is level
L["Tier %s"] = true  -- %s is number