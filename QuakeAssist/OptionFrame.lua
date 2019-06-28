------------------------------------------------------------
-- OptionFrame.lua
--
-- Abin
-- 2017/6/22
------------------------------------------------------------

local _, addon = ...
local L = addon.L

local frame = UICreateInterfaceOptionPage(addon.name.."OptionFrame", L["title"], L["desc"])
addon.optionFrame = frame

local group = frame:CreateMultiSelectionGroup(GENERAL)
frame:AnchorToTopLeft(group)

group:AddButton(L["predict next quake"], "predict")
group:AddButton(L["lock position"], "lock")
group:AddButton(L["voice alert"], "voice")

function group:OnCheckInit(value)
	return addon.db[value]
end

function group:OnCheckChanged(value, checked)
	addon.db[value] = checked
	addon:BroadcastOptionEvent(value, checked)
end

local testButton = frame:CreatePressButton(L["test"])
testButton:SetPoint("LEFT", group[-1].text, "RIGHT", 10, 0)

function testButton:OnClick()
	addon:VoiceAlert()
end

--[[
local toleranceSlider = frame:CreateSlider(L["risk tolerance"], 0, 500, 100, "%d"..MILLISECONDS_ABBR)
toleranceSlider:SetPoint("TOPLEFT", group[-1], "BOTTOMLEFT", 8, -40)

function toleranceSlider:OnSliderInit()
	return addon.db.tolerance or 0
end

function toleranceSlider:OnSliderChanged(value)
	addon.db.tolerance = value
end
--]]

local scaleSlider = frame:CreateSlider(L["frame scale"], 50, 200, 5, "%d%%")
scaleSlider:SetPoint("TOPLEFT", group[-1], "BOTTOMLEFT", 8, -40)

function scaleSlider:OnSliderInit()
	return addon.db.scale
end

function scaleSlider:OnSliderChanged(value)
	addon.db.scale = value
	addon:BroadcastOptionEvent("scale", value)
end

local resetButton = frame:CreatePressButton(RESET)
resetButton:SetPoint("TOP", scaleSlider, "BOTTOM", 0, -20)

function resetButton:OnClick()
	scaleSlider:SetValue(100)
	addon.db.position = nil
	addon:BroadcastOptionEvent("position")
end

addon:RegisterEventCallback("OnInitialize", function(db, isNew)
	if isNew then
		db.lock = 1
		db.voice = 1
		db.predict = 1
	end

	--if type(db.tolerance) ~= "number" or db.tolerance < 0 or db.tolerance > 500 then
	--	db.tolerance = 0
	--end

	if type(db.scale) ~= "number" or db.scale < 50 or db.scale > 200 then
		db.scale = 100
	end

	addon:BroadcastOptionEvent("lock", db.lock)
	addon:BroadcastOptionEvent("position", db.position)
	addon:BroadcastOptionEvent("scale", db.scale)
end)
