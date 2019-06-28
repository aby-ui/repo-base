local addonName, addon = ...
local core = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceEvent-3.0", "AceTimer-3.0", "AceBucket-3.0")

-- GLOBALS: SavedInstances

SavedInstances = addon
addon.core = core:NewModule("Core", "AceEvent-3.0", "AceTimer-3.0", "AceBucket-3.0")
addon.LDB = LibStub("LibDataBroker-1.1", true)
addon.icon = addon.LDB and LibStub("LibDBIcon-1.0", true)
addon.scantt = CreateFrame("GameTooltip", "SavedInstancesScanTooltip", UIParent, "GameTooltipTemplate")
