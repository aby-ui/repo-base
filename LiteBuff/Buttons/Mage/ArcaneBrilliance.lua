------------------------------------------------------------
-- ArcaneBrilliance.lua
--
-- Abin
-- 2011/11/13
------------------------------------------------------------

if select(2, UnitClass("player")) ~= "MAGE" then return end

local UnitPowerType = UnitPowerType

local _, addon = ...
local L = addon.L

local button = addon:CreateActionButton("MageArcaneBrilliance", 1459, nil, 3600, "GROUP_AURA")
button:SetSpell(1459, "SPELL_POWER")
button:SetAttribute("spell", button.spell)
button:RequireSpell(1459)
button:SetFlyProtect()

function button:OnGroupVerifyUnit(unit)
	return UnitPowerType(unit) == 0
end