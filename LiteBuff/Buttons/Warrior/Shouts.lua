------------------------------------------------------------
-- Shouts.lua
--
-- Abin
-- 2011/11/13
------------------------------------------------------------

if select(2, UnitClass("player")) ~= "WARRIOR" then return end

local UnitClass = UnitClass

local _, addon = ...
local L = addon.L

-- local spellList = {}
-- addon:BuildSpellList(spellList, 6673, "ATTACK_POWER")
-- addon:BuildSpellList(spellList, 469, "STAMINA")

local button = addon:CreateActionButton("WarriorShouts", L["shouts"], nil, 3600, "GROUP_AURA")
button:SetSpell(6673, "ATTACK_POWER")
button:SetAttribute("spell", button.spell)
button:RequireSpell(6673)
button:SetFlyProtect()

function button:OnGroupVerifyUnit(unit)
	if self.index == 2 then
		return true
	end

	local _, class = UnitClass(unit)
	return class ~= "MAGE" and class ~= "WARLOCK" and class ~= "PRIEST"
end
