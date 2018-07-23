local ignore_missing = true
--[===[@debug@
ignore_missing = false
--@end-debug@]===]

local L = LibStub("AceLocale-3.0"):NewLocale("GridStatusRaidDebuff", "enUS", true, ignore_missing)
if not L then return end

L["Aura Refresh Frequency"] = true
L["Border"] = true
L["Center Icon"] = true
L["Color"] = true
L["Color Priority"] = true
L["colorDesc"] = "Modify Color"
L["Custom Color"] = true
L["Detected debuff"] = true
L["detector"] = "Detect new debuff"
L["Enable"] = true
L["Enable %s"] = true
L["Icon Priority"] = true
L["Ignore dispellable debuff"] = true
L["Ignore undispellable debuff"] = true
L["Import Debuff"] = true
L["Import Debuff Desc"] = "Import a new raid debuff for this zone"
L["Load"] = true
L["msgAct"] = "Debuff detector is activated."
L["msgDeact"] = "Debuff detector is deactivated."
L["Only color"] = "Only show color, Ignore icon"
L["Option for %s"] = true
L["Raid Debuff"] = true
L["Remained time"] = true
L["Remove"] = true
L["Remove detected debuff"] = true
L["Stackable debuff"] = true


