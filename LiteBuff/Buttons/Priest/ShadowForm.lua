------------------------------------------------------------
-- ShadowForm.lua
--
-- Abin
-- 2011/11/13
------------------------------------------------------------
if select(2, UnitClass("player")) ~= "PRIEST" then return end

local IsSpellKnown = IsSpellKnown

local _, addon = ...
local L = addon.L

local spellList = {}
addon:BuildSpellList(spellList, 15473)

local vampire = addon:BuildSpellList(nil, 15286)

local button = addon:CreateActionButton("PriestShadowForm", 15473, nil, nil, "DUAL", "PLAYER_AURA")
button:SetSpell(15473)
button:SetAttribute("spell1", button.spell)
button:SetAttribute("spell2", vampire.spell)
button:SetFlyProtect()
button:RequireSpell(15473)

function button:OnSpellUpdate()
	if IsSpellKnown(15286) then
		button:SetSpell2(vampire)
	else
		button:SetSpell2(nil)
	end
end

function button:OnUpdateTimer(spell, spell2)
	local expires = addon:GetUnitBuffTimer("player", spell)
	self.icon:SetActive(expires and "Interface\\Icons\\Spell_Shadow_ChillTouch")

	if not spell2 then
		return expires
	end

	local secondary = addon:GetUnitBuffTimer("player", spell2)
	if expires and secondary then
		return 1
	elseif expires or secondary then
		return -1
	end
end
