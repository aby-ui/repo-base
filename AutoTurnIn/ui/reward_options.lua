local addonName, ptable = ...
local L, C = ptable.L, ptable.CONST
local O = addonName .. "RewardPanel"
AutoTurnIn.RewardPanel = CreateFrame("Frame", O)
AutoTurnIn.RewardPanel.name = QUEST_REWARDS
AutoTurnIn.RewardPanel.parent = addonName
local RewardPanel = AutoTurnIn.RewardPanel

local function CreateCheckbox(name, parent, marginx, marginy, text)
	local cb = CreateFrame("CheckButton", "$parent"..name,  parent, "OptionsCheckButtonTemplate")
	cb:SetPoint("TOPLEFT", parent, marginx, marginy)
	_G[cb:GetName().."Text"]:SetText(text and text or name)
	cb:SetScript("OnClick", function(self)
		parent.GetConfig()[name] = (self:GetChecked() or nil)
	end)
	tinsert(parent.buttons, cb)
	return cb
end 

local function CreatePanel(name, text, w, h)
	local panel = CreateFrame("Frame", O..name,  RewardPanel, "OptionsBoxTemplate")
	panel:SetWidth(w)
	panel:SetHeight(h)
	panel.buttons = {}
	panel.config=config
	function panel:ClearCheckBoxes() 
		for k,v in ipairs(self.buttons) do 
			v:SetChecked(false)
		end
	end
	function panel:GetConfig()
		if name == "StatPanel" then 
			return ptable.TempConfig.stat
		elseif name == "ArmorPanel" then
			return ptable.TempConfig.armor
		elseif name == "WeaponPanel" then 
			return ptable.TempConfig.weapon
		elseif name == "SecStatPanel" then
			return ptable.TempConfig.secondary		
		end
	end
	_G[panel:GetName().."Title"]:SetText(text)
	return panel
end

-- Description
local description = RewardPanel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
description:SetText(L["rewardlootoptions"])

-- WEAPON
local WeaponPanel = CreatePanel("WeaponPanel", C.WEAPONLABEL, 590, 170)
CreateCheckbox(C.weapon[1], WeaponPanel, 10, -8)
CreateCheckbox(C.weapon[2], WeaponPanel, 206, -8)
CreateCheckbox(C.weapon[10], WeaponPanel, 402, -8)
	-- 2nd line 
CreateCheckbox(C.weapon[5], WeaponPanel, 10, -40)
CreateCheckbox(C.weapon[6], WeaponPanel, 206, -40)
CreateCheckbox(C.weapon[11], WeaponPanel, 402, -40)
    -- 3rd line
CreateCheckbox(C.weapon[8], WeaponPanel, 10, -72)
CreateCheckbox(C.weapon[9], WeaponPanel, 206, -72)
CreateCheckbox(C.weapon[16], WeaponPanel, 402, -72)
	-- 4rd line
CreateCheckbox(C.weapon[13], WeaponPanel, 10, -104)
CreateCheckbox(C.weapon[7], WeaponPanel, 206, -104)
CreateCheckbox(C.weapon[14], WeaponPanel, 402, -104)
	-- 5th line
CreateCheckbox("Ranged", WeaponPanel, 10, -136, string.format("%s, %s, %s", C.weapon[3], C.weapon[4], C.weapon[15]) )

-- ARMOR 
local ArmorPanel = CreatePanel("ArmorPanel", C.ARMORLABEL, 590, 70)
local ArmorDropDown = CreateFrame("Frame", O.."ToggleKeyDropDown", ArmorPanel, "UIDropDownMenuTemplate")
local ARMORCONST = {NONE_KEY, C.armor[2], C.armor[3], C.armor[4], C.armor[5]}
UIDropDownMenu_Initialize(ArmorDropDown, function (self, level)
    for k, v in ipairs(ARMORCONST) do
        local info = UIDropDownMenu_CreateInfo()
		info.text, info.value = v, k
        info.func = function(self)			
						UIDropDownMenu_SetSelectedID(ArmorDropDown, self:GetID())
						if ArmorDropDown.value > 1 then
							ptable.TempConfig.armor[ARMORCONST[ArmorDropDown.value]] = nil
						end
						if self:GetID() > 1 then
							ArmorDropDown.value = self:GetID()
							ptable.TempConfig.armor[self:GetText()] = true
						end															
					end
        UIDropDownMenu_AddButton(info, level)
    end
end)
UIDropDownMenu_SetWidth(ArmorDropDown, 200);
UIDropDownMenu_JustifyText(ArmorDropDown, "LEFT")
ArmorDropDown:SetPoint("TOPLEFT", ArmorPanel, 0, -8)
CreateCheckbox(C.armor[7], ArmorPanel, 402, -8)
	-- 2nd line 
CreateCheckbox("Jewelry", ArmorPanel, 10, -40, L['Jewelry'] )
CreateCheckbox('INVTYPE_HOLDABLE', ArmorPanel, 206, -40, INVTYPE_HOLDABLE)
CreateCheckbox('INVTYPE_CLOAK', ArmorPanel, 402, -40, INVTYPE_CLOAK)
	
-- ATTRIBUTES
local StatPanel = CreatePanel("StatPanel", STAT_CATEGORY_ATTRIBUTES, 590, 40) 
CreateCheckbox('ITEM_MOD_STRENGTH_SHORT', StatPanel, 10, -8, SPELL_STAT1_NAME)
CreateCheckbox('ITEM_MOD_AGILITY_SHORT', StatPanel, 152, -8, SPELL_STAT2_NAME)
CreateCheckbox('ITEM_MOD_INTELLECT_SHORT', StatPanel, 292, -8, SPELL_STAT4_NAME)
--CreateCheckbox('ITEM_MOD_SPIRIT_SHORT', StatPanel, 436, -8, SPELL_STAT5_NAME)

local SecStatPanel = CreatePanel("SecStatPanel", STAT_CATEGORY_ATTRIBUTES .. "-2", 590, 102) 
CreateCheckbox('ITEM_MOD_CRIT_RATING_SHORT', SecStatPanel, 10, -8, ITEM_MOD_CRIT_RATING_SHORT)
CreateCheckbox('ITEM_MOD_CR_LIFESTEAL_SHORT', SecStatPanel, 206, -8, ITEM_MOD_CR_LIFESTEAL_SHORT)
CreateCheckbox('ITEM_MOD_HASTE_RATING_SHORT', SecStatPanel, 402, -8, ITEM_MOD_HASTE_RATING_SHORT)
	-- 2nd line 
CreateCheckbox('ITEM_MOD_CR_MULTISTRIKE_SHORT', SecStatPanel, 10, -40, ITEM_MOD_CR_MULTISTRIKE_SHORT)
CreateCheckbox('ITEM_MOD_MASTERY_RATING_SHORT', SecStatPanel, 206, -40, ITEM_MOD_MASTERY_RATING_SHORT)
CreateCheckbox('ITEM_MOD_VERSATILITY', SecStatPanel, 402, -40, ITEM_MOD_VERSATILITY)
    -- 3rd line
CreateCheckbox('ITEM_MOD_SPELL_POWER_SHORT', SecStatPanel, 10, -72, ITEM_MOD_SPELL_POWER_SHORT)
CreateCheckbox('ITEM_MOD_SPIRIT_SHORT', SecStatPanel, 206, -72, ITEM_MOD_SPIRIT_SHORT)
-- CreateCheckbox('ITEM_MOD_VERSATILITY', SecStatPanel, 402, -72, ITEM_MOD_VERSATILITY)


-- 'Greed' CheckBox
local GreedAfterNeed = CreateFrame("CheckButton", O.."Enable", RewardPanel, "OptionsCheckButtonTemplate")
_G[GreedAfterNeed:GetName().."Text"]:SetText(L["greedifnothing"])
GreedAfterNeed:SetScript("OnClick", function(self)
	ptable.TempConfig.greedifnothingfound = self:GetChecked()
end)

--[[ CONTROL PLACEMENT]]--
description:SetPoint("TOPLEFT", 16, -8)
WeaponPanel:SetPoint("TOPLEFT", description, "BOTTOMLEFT", 0, -20)
ArmorPanel:SetPoint("TOPLEFT", WeaponPanel, "BOTTOMLEFT", 0, -20)
StatPanel:SetPoint("TOPLEFT", ArmorPanel, "BOTTOMLEFT", 0, -20)
SecStatPanel:SetPoint("TOPLEFT", StatPanel, "BOTTOMLEFT", 0, -20)
GreedAfterNeed:SetPoint("TOPLEFT", SecStatPanel, "BOTTOMLEFT", 8, -16)

--[[ PANEL FUNCTIONS ]]--
RewardPanel.refresh = function()
	WeaponPanel:ClearCheckBoxes()
	ArmorPanel:ClearCheckBoxes()
	StatPanel:ClearCheckBoxes()
	SecStatPanel:ClearCheckBoxes()
	for k,v in pairs(ptable.TempConfig.weapon) do
		_G[WeaponPanel:GetName()..k]:SetChecked(v)
	end
	for k,v in pairs(ptable.TempConfig.stat) do
		_G[StatPanel:GetName()..k]:SetChecked(v)
	end
	for k,v in pairs(ptable.TempConfig.secondary) do
		_G[SecStatPanel:GetName()..k]:SetChecked(v)
	end	

	for k,v in pairs(ptable.TempConfig.armor) do
		-- check is necessary: armor types and concrete subtypes held in one array. while subtypes have it's checkboxes, armor types rendered in a DropBox 
		-- -> hence, no global control exists and _G[armorType] leads to silent exception
		local checkbox = _G[ArmorPanel:GetName()..k];
		if (checkbox) then 
			_G[ArmorPanel:GetName()..k]:SetChecked(v)
		end
	end	
		
	GreedAfterNeed:SetChecked(ptable.TempConfig.greedifnothingfound )
	-- Armor types dropdown
	ArmorDropDown.value = nil
	
	for index, armorName in ipairs(ARMORCONST) do
		if ptable.TempConfig.armor[armorName] then
			ArmorDropDown.value=index			
		end
	end
	
	ArmorDropDown.value = ArmorDropDown.value and ArmorDropDown.value or 1
	UIDropDownMenu_SetSelectedID(ArmorDropDown, ArmorDropDown.value)
	UIDropDownMenu_SetText(ArmorDropDown, ARMORCONST[ArmorDropDown.value])
end
--RewardPanel.default = function() end
--RewardPanel.okay = function()end

--[[ REGISTERING PANEL ]]--
InterfaceOptions_AddCategory(RewardPanel)
