------------------------------------------------------------
-- Stances.lua
--
-- Abin
-- 2011/11/13
------------------------------------------------------------

if select(2, UnitClass("player")) ~= "WARRIOR" then return end

local _, addon = ...
local L = addon.L

local spellList = {}
addon:BuildSpellList(spellList, 2457)
addon:BuildSpellList(spellList, 71)

local button = addon:CreateActionButton("WarriorStances", L["stances"], nil, nil, "STANCE")
button:SetAttribute("type", "spell")
button:SetScrollable(spellList)