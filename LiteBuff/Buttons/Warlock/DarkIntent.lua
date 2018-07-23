------------------------------------------------------------
-- DarkIntent.lua
--
-- Abin
-- 2011/11/13
------------------------------------------------------------

if select(2, UnitClass("player")) ~= "WARLOCK" then return end

local _, addon = ...

local button = addon:CreateActionButton("WarlockDarkIntent", 109773, nil, 3600, "DUAL", "GROUP_AURA")
button:SetSpell(109773, "SPELL_POWER")
button:SetAttribute("spell", button.spell)
button:RequireSpell(109773)
button:SetFlyProtect()