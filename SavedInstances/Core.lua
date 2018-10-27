local addonName, addon = ...
local core = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceEvent-3.0", "AceTimer-3.0", "AceBucket-3.0")
local L = addon.L

addon.LDB = LibStub("LibDataBroker-1.1", true)
addon.icon = addon.LDB and LibStub("LibDBIcon-1.0", true)

local scantt = CreateFrame("GameTooltip", "SavedInstancesScanTooltip", UIParent, "GameTooltipTemplate")
addon.scantt = scantt
