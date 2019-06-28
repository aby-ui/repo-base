------------------------------------------------------------
-- Pets.lua
--
-- Abin
-- 2011/11/13
------------------------------------------------------------

if select(2, UnitClass("player")) ~= "WARLOCK" then return end

local UnitExists = UnitExists
local IsSpellKnown = IsSpellKnown

local _, addon = ...
local L = addon.L

local PET_SPELLS_1 = { 3110, 3716, 7814, 19505, 30151 }
local PET_SPELLS_2 = { 115746, 170176, 115748, 115284, 30151 }
local petSpells = PET_SPELLS_1

local spellList = {}
addon:BuildSpellList(spellList, 688)
addon:BuildSpellList(spellList, 697)
addon:BuildSpellList(spellList, 712)
addon:BuildSpellList(spellList, 691)
addon:BuildSpellList(spellList, 30146)

local button = addon:CreateActionButton("WarlockPets", L["pets"], nil, 3600, "DUAL")
button:SetFlyProtect()
button:SetScrollable(spellList, "spell1")
button:SetSpell2(108503)
button:SetAttribute("spell2", button.spell2)

function button:OnUpdateTimer()
	local expires = addon:GetUnitBuffTimer("player", self.spell2, 1)
	if expires then
		return expires and "NONE" or "R", expires
	end

	if UnitHealth("pet") > 0 then
		local spell = petSpells[self.index]
		return spell and IsSpellKnown(spell, true) and "NONE"
	end
end

local wasKnown
function button:OnSpellUpdate()
	if IsSpellKnown(30146) then
		self:SetMaxIndex()
	else
		self:SetMaxIndex(4)
	end

	if IsSpellKnown(108503) then
		self:SetSpell2(108503)
	else
		self:SetSpell2()
	end

	local known = IsSpellKnown(108499)
	if not wasKnown ~= not known then
		wasKnown = known
		addon:UpdateSpellListIcons(spellList)

		if known then
			petSpells = PET_SPELLS_2
		else
			petSpells = PET_SPELLS_1
		end

		self.icon:SetSpell(spellList[self.index])
	end



	self:UpdateTimer()
end