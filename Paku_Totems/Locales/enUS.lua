local addonName = ...
local debug = false
--@debug@ debug = true
--@end-debug@
local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "enUS", true, debug)
if not L then return end

-- Options
L["World Map Icon Size"] = true
L["Minimap Icon Size"] = true

-- Locations
L["The Sliver (North)"] = true
L["The Sliver (South)"] = true
L["Top of Zanchul"] = true
L["East Zanchul"] = true
L["West Zanchul"] = true
L["Terrace of the Chosen"] = true
L["Altar of Pa'ku"] = true
L["The Great Seal Ledge"] = true
L["The Golden Throne"] = true
L["Beastcaller Inn (Warbeast Kraal)"] = true
L["Grand Bazaar"] = true
L["Terrace of Crafters"] = true
L["The Zocalo"] = true