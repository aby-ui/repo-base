local AddonName, Addon = ...
local ParentAddonName = GetAddOnDependencies(AddonName)
local ParentAddon = LibStub("AceAddon-3.0"):GetAddon(ParentAddonName)

local tbl = LibStub("AceDBOptions-3.0"):GetOptionsTable(ParentAddon.db, true)
tbl.args.choose.width = "double"
tbl.args.copyfrom.width = "double"
tbl.args.delete.width = "double"
Addon:AddOptionsPanelOptions(
    "profiles", 
    LibStub("AceDBOptions-3.0"):GetOptionsTable(ParentAddon.db, true)
)