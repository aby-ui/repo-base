------------------------------------------------------------
-- HornOfWinter.lua
--
-- Abin
-- 2011/11/13
------------------------------------------------------------

if select(2, UnitClass("player")) ~= "DEATHKNIGHT" then return end

local UnitClass = UnitClass

local _, addon = ...
local L = addon.L

local button = addon:CreateActionButton("DeathKnightHornOfWinter", 57330, nil, 120, "GROUP_AURA")
button:SetSpell(57330, "ATTACK_POWER")
button:SetAttribute("spell", button.spell)
button:RequireSpell(57330)
button:SetFlyProtect()

function button:OnGroupVerifyUnit(unit)
	local _, class = UnitClass(unit)
	return class ~= "MAGE" and class ~= "WARLOCK" and class ~= "PRIEST"
end
