------------------------------------------------------------
-- OptionFrame.lua
--
-- Abin
-- 2010-9-28
------------------------------------------------------------

local IsShiftKeyDown = IsShiftKeyDown
local tostring = tostring
local tonumber = tonumber
local format = format
local GameTooltip = GameTooltip
local SETTINGS = SETTINGS

local addon = WhisperPop
local L = addon.L

-- Key binding stuff
BINDING_HEADER_WHISPERPOP_TITLE = "WhisperPop"
BINDING_NAME_WHISPERPOP_TOGGLE = L["toggle frame"]

local configButton = addon.templates.CreateIconButton(addon.frame:GetName().."Config", addon.frame, "Interface\\Icons\\Trade_Engineering", 16)
configButton:SetPoint("TOPLEFT", 11, -9)

configButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:ClearLines()
	GameTooltip:AddLine(SETTINGS)
	GameTooltip:AddLine(L["settings tooltip 1"], 1, 1, 1, 1)
	GameTooltip:AddLine(L["settings tooltip 2"], 1, 1, 1, 1)
	GameTooltip:Show()
end)

configButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

configButton:SetScript("OnClick", function(self)
	if IsShiftKeyDown() then
		addon:PopupShowConfirm(L["clear all confirm"], addon.Clear, addon)
	else
		addon.optionFrame:Open()
	end
end)

local frame = UICreateInterfaceOptionPage("WhisperPopOptionFrame", L["title"], L["desc"])
addon.optionFrame = frame

local generalGroup = frame:CreateMultiSelectionGroup(L["general options"])
frame:AnchorToTopLeft(generalGroup, 0, -10)

generalGroup:AddButton(L["show notify button"], "notifyButton")
generalGroup:AddButton(L["receive only"], "receiveOnly")
generalGroup:AddButton(L["sound notify"], "sound")

local realmCheck = generalGroup:AddButton(L["show realms"], "showRealm")

local foreignCheck = generalGroup:AddButton(L["foreign realms"], "foreignOnly")
foreignCheck:ClearAllPoints()
foreignCheck:SetPoint("TOPLEFT", realmCheck, "BOTTOMLEFT", foreignCheck:GetWidth(), 0)

local timeCheck = generalGroup:AddButton(L["timestamp"], "time")
timeCheck:ClearAllPoints()
timeCheck:SetPoint("TOPLEFT", foreignCheck, "BOTTOMLEFT", -foreignCheck:GetWidth(), 0)

generalGroup:AddButton(L["ignore tag messages"], "ignoreTags")
generalGroup:AddButton(L["apply third-party filters"], "applyFilters")
generalGroup:AddButton(L["save messages"], "save")

function generalGroup:OnCheckInit(value)
	return addon.db[value]
end

function generalGroup:OnCheckChanged(value, checked)
	addon.db[value] = checked
	addon:BroadcastOptionEvent(value, checked)

	if value == "sound" and checked then
		addon:PlaySound163()
	end
end

addon:RegisterOptionCallback("showRealm", function(value)
	if value then
		foreignCheck:Enable()
	else
		foreignCheck:Disable()
	end
end)

local function Slider_OnSliderInit(self)
	return addon.db[self.key]
end

local function Slider_OnSliderChanged(self, value)
	addon.db[self.key] = value
	addon:BroadcastOptionEvent(self.key, value)
end

local function CreateSlider(text, key, fmt)
	local config = addon.DB_DEFAULTS[key]
	local slider = frame:CreateSlider(text, config.min, config.max, config.step, fmt)
	slider.key = key
	slider.text:SetTextColor(1, 1, 1)
	slider.OnSliderInit = Slider_OnSliderInit
	slider.OnSliderChanged = Slider_OnSliderChanged
	return slider
end

local frameLabel = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
frameLabel:SetText(L["frame settings"])
frameLabel:SetPoint("TOPLEFT", generalGroup[-1], "BOTTOMLEFT", 0, -16)

local notifySlider = CreateSlider(L["button scale"], "buttonScale", "%d%%")
notifySlider:SetPoint("TOPLEFT", frameLabel, "BOTTOMLEFT", 8, -30)

local mainSlider = CreateSlider(L["list scale"], "listScale", "%d%%")
mainSlider:SetPoint("LEFT", notifySlider, "RIGHT", 24, 0)

local widthSlider = CreateSlider(L["list width"], "listWidth")
widthSlider:SetPoint("TOPLEFT", notifySlider, "BOTTOMLEFT", 0, -40)

local heightSlider = CreateSlider(L["list height"], "listHeight")
heightSlider:SetPoint("LEFT", widthSlider, "RIGHT", 24, 0)

local function OnResetFrames()
	notifySlider:SetValue(100)
	mainSlider:SetValue(100)
	widthSlider:SetValue(addon.DB_DEFAULTS.listWidth.default)
	heightSlider:SetValue(addon.DB_DEFAULTS.listHeight.default)
	addon:BroadcastEvent("OnResetFrames")
end

local resetButton = frame:CreatePressButton(L["reset frames"])
resetButton:SetWidth(120)
resetButton:SetPoint("TOPLEFT", frameLabel, "BOTTOMLEFT", 8, -138)

function resetButton:OnClick()
	addon:PopupShowConfirm(L["reset frames confirm"], OnResetFrames)
end

local clearButton = frame:CreatePressButton(L["clear all"])
clearButton:SetWidth(120)
clearButton:SetPoint("LEFT", resetButton, "RIGHT", 8, 0)

function clearButton:OnClick()
	addon:PopupShowConfirm(L["clear all confirm"], addon.Clear, addon)
end