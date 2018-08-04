
local function CheckSound(self)
	local sound = self:GetChecked() and 'On' or 'Off'
	PlaySound(self:GetChecked() and 856 or 857) --'igMainMenuOptionCheckBox'.. sound
end


-- Creates a checkbox.
-- All args optional but parent is highly recommended
local function NewCheckBox(parent, size, ...)
	local check = CreateFrame("CheckButton", nil, parent)
	check:SetWidth(size or 26)
	check:SetHeight(size or 26)
	if select(1, ...) then check:SetPoint(...) end

	check:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
	check:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
	check:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight")
	check:SetDisabledCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
	check:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")

	check:SetScript("PreClick", CheckSound)

	return check
end

local aceEvent = LibStub'AceEvent-3.0'

local GameTooltip = GameTooltip

local L = {
	helmtip = "Toggles helmet model.",
	cloaktip = "Toggles cloak model.",
}


local GameTooltip = GameTooltip 
local helmcb = CreateFrame("CheckButton", nil, PaperDollFrame) 
helmcb:ClearAllPoints() 
helmcb:SetSize(22,22) 
helmcb:SetFrameLevel(31) 
helmcb:SetPoint("TOPLEFT", CharacterHeadSlot, "RIGHT", 5, 5) 
helmcb:SetScript("OnClick", function() ShowHelm(not ShowingHelm()) end) 
helmcb:SetScript("OnEnter", function(self) 
   GameTooltip:SetOwner(self, "ANCHOR_RIGHT") 
   GameTooltip:SetText("头盔") 
end) 
helmcb:SetScript("OnLeave", function() GameTooltip:Hide() end) 
helmcb:SetScript("OnEvent", function() helmcb:SetChecked(ShowingHelm()) end) 
helmcb:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up") 
helmcb:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down") 
helmcb:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight") 
helmcb:SetDisabledCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
 helmcb:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check") 
helmcb:RegisterEvent("UNIT_MODEL_CHANGED") 

local cloakcb = CreateFrame("CheckButton", nil, PaperDollFrame) 
cloakcb:ClearAllPoints() 
cloakcb:SetSize(22,22) 
cloakcb:SetFrameLevel(31) 
cloakcb:SetPoint("TOPLEFT", CharacterBackSlot, "RIGHT", 5, 5) 
cloakcb:SetScript("OnClick", function() ShowCloak(not ShowingCloak()) end) 
cloakcb:SetScript("OnEnter", function(self) 
   GameTooltip:SetOwner(self, "ANCHOR_RIGHT") 
   GameTooltip:SetText("披风") 
end) 
cloakcb:SetScript("OnLeave", function() GameTooltip:Hide() end) 
cloakcb:SetScript("OnEvent", function() cloakcb:SetChecked(ShowingCloak()) end) 
cloakcb:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up") 
cloakcb:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down") 
cloakcb:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight") 
cloakcb:SetDisabledCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
 cloakcb:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check") 
cloakcb:RegisterEvent("UNIT_MODEL_CHANGED") 


local function OnLoad()
	helmcb:SetChecked(ShowingHelm()) 
	cloakcb:SetChecked(ShowingCloak())
end
aceEvent:RegisterEvent("UNIT_MODEL_CHANGED", OnLoad)
aceEvent:RegisterEvent("PLAYER_LOGIN", OnLoad)