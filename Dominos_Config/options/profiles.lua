local AddonName, Addon = ...
local ParentAddonName = GetAddOnDependencies(AddonName)
local ParentAddon = LibStub("AceAddon-3.0"):GetAddon(ParentAddonName)

Addon:AddOptionsPanelOptions(
    "profiles", 
    LibStub("AceDBOptions-3.0"):GetOptionsTable(ParentAddon.db, true)
)