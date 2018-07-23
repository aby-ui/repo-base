------------------------------------------------------------
-- Chakra.lua
--
-- Abin
-- 2011/11/13
------------------------------------------------------------
if select(2, UnitClass("player")) ~= "PRIEST" then return end

local _, addon = ...
local L = addon.L

local spellList = {}
addon:BuildSpellList(spellList, 81208)
addon:BuildSpellList(spellList, 81206)
addon:BuildSpellList(spellList, 81209)

local CATEGORY = GetSpellInfo(126172)

local button = addon:CreateActionButton("PriestChakra", CATEGORY, nil, nil, "PLAYER_AURA")
button:SetAttribute("type", "spell")
button:SetScrollable(spellList)
button:SetFlyProtect()
--163uiedit
button:RequireSpell(34861)
