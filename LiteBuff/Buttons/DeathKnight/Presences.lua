------------------------------------------------------------
-- Presences.lua
--
-- Abin
-- 2011/11/13
------------------------------------------------------------

if select(2, UnitClass("player")) ~= "DEATHKNIGHT" then return end

local _, addon = ...
local L = addon.L

local spellList = {}
addon:BuildSpellList(spellList, 48263)
addon:BuildSpellList(spellList, 48266)
addon:BuildSpellList(spellList, 48265)

local button = addon:CreateActionButton("DeathKnightPresences", L["presences"], nil, nil, "STANCE")
button:SetAttribute("type", "spell")
button:SetScrollable(spellList)