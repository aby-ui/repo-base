------------------------------------------------------------
-- Talents.lua
--
-- Abin
-- 2011/11/13
------------------------------------------------------------

local InCombatLockdown = InCombatLockdown
local IsFlying = IsFlying
local GetActiveSpecGroup = GetActiveSpecGroup
local tostring = tostring
local GetNumSpecGroups = GetNumSpecGroups
local SetActiveSpecGroup = SetActiveSpecGroup
local GetSpecializationInfo = GetSpecializationInfo
local GetSpecialization = GetSpecialization

local _, addon = ...
local L = addon.L

local NONE = NONE
local QUESTIONMARK = "Interface\\Icons\\INV_Misc_QuestionMark"
local ERR_SPEC_WIPE_ERROR = ERR_SPEC_WIPE_ERROR

local spellList = {}
spellList[1] = { icon = QUESTIONMARK, name = NONE, desc = "" }
spellList[2] = { icon = QUESTIONMARK, name = NONE, desc = "" }

local dualTalents

local button = addon:CreateActionButton("TalentSwitch", L["switch talents"])
button:SetFlyProtect(nil)

button:SetScript("OnClick", function(self)
	if not InCombatLockdown() and not IsFlying() then
		SetActiveSpecGroup(GetActiveSpecGroup() == 1 and 2 or 1)
	end
end)

function button:OnValidate()
	return GetNumSpecGroups() > 1
end

local function ValidateButton()
	if button:IsEnabled() and button:OnValidate() then
		button:Show()
	else
		button:Hide()
	end
end

local function UpdateSpecInfo(id)
	local spec = GetSpecialization(nil, false, id)
	if spec then
		_, spellList[id].name, spellList[id].desc, spellList[id].icon = GetSpecializationInfo(spec)
	else
		spellList[id].name, spellList[id].desc, spellList[id].icon = NONE, ERR_SPEC_WIPE_ERROR, QUESTIONMARK
	end
end

function button:OnTalentUpdate(combat)
	if not combat then
		ValidateButton()
	end

	if self:OnValidate() then
		UpdateSpecInfo(1)
		UpdateSpecInfo(2)
		self:UpdateTimer()
	end
end

function button:OnTooltipText(tooltip)
	if GetActiveSpecGroup() == 2 then
		tooltip:AddLine(spellList[1].name..": "..spellList[1].desc, 0.6, 0.6, 0.6, 1)
		tooltip:AddLine(spellList[2].name..": "..spellList[2].desc, 0, 1, 0, 1)
	else
		tooltip:AddLine(spellList[1].name..": "..spellList[1].desc, 0, 1, 0, 1)
		tooltip:AddLine(spellList[2].name..": "..spellList[2].desc, 0.6, 0.6, 0.6, 1)
	end
end

function button:OnUpdateTimer()
	local spec = GetActiveSpecGroup()
	--163uiedit
	--self.icon:SetSpell(spellList[1])
	--self.icon2:SetSpell(spellList[2])
	self.icon:SetSpell(spellList[spec])
	self.text:SetText(spellList[spec].name and spellList[spec].name:sub(1,6))
	--if spec == 2 then
	--	self.icon:SetAlpha(0.4)
	--	self.icon2:SetAlpha(1)
	--else
	--	self.icon:SetAlpha(1)
	--	self.icon2:SetAlpha(0.4)
	--end
	return nil
end

function button:OnLeaveCombat()
	ValidateButton()
end
