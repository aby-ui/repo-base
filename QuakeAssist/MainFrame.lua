------------------------------------------------------------
-- MainFrame.lua
--
-- Abin
-- 2017/6/22
------------------------------------------------------------

local GetTime = GetTime

local _, addon = ...
local L = addon.L

local BAR_WIDTH = 160
local BAR_HEIGHT = 18
local BAR_SPACING = 2
local BAR_TEXTURE = addon.path.."\\StatusBar.tga" -- Maybe "Interface\\BUTTONS\\WHITE8X8.BLP" better?

local frame = CreateFrame("Frame", addon.name.."Frame", UIParent)
addon.frame = frame
frame:SetPoint("CENTER")
frame:SetSize(BAR_WIDTH + BAR_HEIGHT + BAR_SPACING, BAR_HEIGHT * 2 + BAR_SPACING)
frame:SetMovable(true)
frame:SetUserPlaced(false)
frame:SetDontSavePosition(true)
frame:SetFrameStrata("HIGH")
frame:SetClampedToScreen(true)

function frame:Disable()
	self.quakeBar:Hide()
	self.predictBar:Hide()
end

local warningText = frame:CreateFontString(frame:GetName().."WarningText", "ARTWORK", "TextStatusBarText")
frame.warningText = warningText
warningText:SetPoint("BOTTOM", frame, "TOP", BAR_HEIGHT + BAR_SPACING, 6)
warningText:SetFont(DAMAGE_TEXT_FONT, 26, "OUTLINE")
warningText:SetTextColor(1, 0, 0)
warningText:Hide()
warningText:SetText(L["stop casting"])

local mover = CreateFrame("Button", frame:GetName().."Mover", UIParent)
frame.mover = mover
mover:SetAllPoints(frame)
mover:Hide()
mover:SetFrameStrata("FULLSCREEN_DIALOG")

local moverTitle = mover:CreateFontString(mover:GetName().."Title", "ARTWORK", "GameFontNormal")
moverTitle:SetPoint("BOTTOM", mover, "TOP", 0, 3)
moverTitle:SetText(addon.title)

mover:RegisterForDrag("LeftButton")

mover:SetScript("OnDragStart", function(self)
	frame:StartMoving()
end)

mover:SetScript("OnDragStop", function(self)
	frame:StopMovingOrSizing()
	local position = addon.db.position
	if type(position) ~= "table" then
		position = {}
		addon.db.position = position
	end

	position.point, position.relativeTo, position.relativePoint, position.xOffset, position.yOffset = frame:GetPoint(1)
end)

mover:RegisterForClicks("AnyUp")
mover:SetScript("OnClick", function(self)
	addon.optionFrame:Open()
end)

local function Status_OnUpdate(self)
	local minVal, maxVal = self:GetMinMaxValues()
	if not maxVal then
		return -- should never happen but who the hell knows
	end

	local now = GetTime()
	if now > maxVal then
		now = maxVal
	end

	self:SetValue(now)
	self.text:SetFormattedText("%.1f", maxVal - now)
end

local function CreateStatusBar(name, texture, parent, r, g, b)
	local statusBar = CreateFrame("StatusBar", frame:GetName()..name, parent or addon.frame)
	statusBar:Hide()
	statusBar:SetStatusBarTexture(BAR_TEXTURE)
	statusBar:SetMinMaxValues(0, 1)
	statusBar:SetHeight(BAR_HEIGHT)

	local icon = statusBar:CreateTexture(name.."Icon", "ARTWORK")
	statusBar.icon = icon
	icon:SetSize(BAR_HEIGHT, BAR_HEIGHT)
	icon:SetPoint("RIGHT", statusBar, "LEFT", -BAR_SPACING, 0)

	if texture then
		icon:SetTexture(texture)
	end

	local background = statusBar:CreateTexture(name.."Bkgnd", "BORDER")
	statusBar.bkgnd = background
	background:SetAllPoints(statusBar)
	background:SetTexture(BAR_TEXTURE)

	local spark = statusBar:CreateTexture(name.."Spark", "OVERLAY")
	statusBar.spark = spark
	spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	spark:SetBlendMode("ADD")
	spark:SetPoint("CENTER", statusBar:GetStatusBarTexture(), "RIGHT")
	spark:SetSize(BAR_HEIGHT * 0.45, BAR_HEIGHT * 1.8)

	local text = statusBar:CreateFontString(name.."Text", "ARTWORK", "TextStatusBarText")
	statusBar.text = text
	text:SetPoint("LEFT", statusBar, "RIGHT", 2, 0)

	local tile1 = mover:CreateTexture(nil, "OVERLAY")
	tile1:SetAllPoints(icon)
	tile1:SetTexture("Interface\\BUTTONS\\WHITE8X8.BLP")
	tile1:SetVertexColor(0, 1, 0, 0.4)

	local tile2 = mover:CreateTexture(nil, "OVERLAY")
	tile2:SetAllPoints(statusBar)
	tile2:SetTexture("Interface\\BUTTONS\\WHITE8X8.BLP")
	tile2:SetVertexColor(0, 1, 0, 0.4)

	if r then
		statusBar:SetStatusBarColor(r, g, b)
		background:SetVertexColor(r / 2, g / 2, b / 2)
	end

	statusBar:SetScript("OnUpdate", Status_OnUpdate)
	statusBar:SetScript("OnShow", Status_OnUpdate)

	return statusBar
end

local quakeBar = CreateStatusBar("QuakeBar", addon.QUAKE_ICON, addon.frame, 0.75, 0.75, 0)
frame.quakeBar = quakeBar
quakeBar:SetPoint("TOPLEFT", BAR_HEIGHT + BAR_SPACING, 0)
quakeBar:SetPoint("TOPRIGHT")

local predictBar = CreateStatusBar("PredictBar", 134377, addon.frame, 0.5, 0.5, 1)
frame.predictBar = predictBar
predictBar:SetAllPoints(quakeBar)

local castingBar = CreateStatusBar("CastingBar", nil, quakeBar)
frame.castingBar = castingBar
castingBar:SetPoint("TOPLEFT", quakeBar, "BOTTOMLEFT", 0, -BAR_SPACING)
castingBar:SetWidth(BAR_WIDTH)
castingBar.nameText = castingBar:CreateFontString(castingBar:GetName().."NameText", "ARTWORK", "TextStatusBarText")
castingBar.nameText:SetPoint("TOP", castingBar, "BOTTOM", 0, -2)

function predictBar:RequestNextQuakeInfo()
	local nextStart, nextEnd = addon:PredictNextQuake()
	if nextStart then
		self:SetMinMaxValues(nextStart, nextEnd)
		Status_OnUpdate(self)
		self:Show()
	else
		self:Hide()
	end
end

predictBar:SetScript("OnUpdate", function(self)
	local nextQuakeTime = addon.nextQuakeStartTime
	if not nextQuakeTime then
		return
	end

	if nextQuakeTime >= GetTime() then
		Status_OnUpdate(self)
	else
		self:RequestNextQuakeInfo()
	end
end)

addon:RegisterEventCallback("OnQuake", function(startTime, endTime)
	if startTime then
		quakeBar:SetMinMaxValues(startTime, endTime)
		quakeBar:Show()
		predictBar:Hide()
	else
		quakeBar:Hide()
		if addon.db.predict then
			predictBar:RequestNextQuakeInfo()
		end
	end
end)

addon:RegisterEventCallback("OnCasting", function(name, texture, startTime, endTime)
	if endTime then
		castingBar.icon:SetTexture(texture)
		castingBar.nameText:SetText(name)
		castingBar:SetMinMaxValues(startTime, endTime)
		castingBar:Show()
	else
		castingBar:Hide()
	end
end)

addon:RegisterEventCallback("OnAlert", function(dangerous)
	if dangerous then
		castingBar:SetStatusBarColor(1, 0, 0)
		castingBar.bkgnd:SetVertexColor(0.5, 0, 0)
		warningText:Show()
	else
		castingBar:SetStatusBarColor(0, 1, 0)
		castingBar.bkgnd:SetVertexColor(0, 0.5, 0)
		warningText:Hide()
	end
end)

addon:RegisterOptionCallback("position", function(position)
	frame:ClearAllPoints()
	if type(position) == "table" and type(position.point) == "string" then
		frame:SetPoint(position.point, position.relativeTo, position.relativePoint, position.xOffset, position.yOffset)
	else
		frame:SetPoint("CENTER", 0, -100)
	end
end)

addon:RegisterOptionCallback("scale", function(value)
	if type(value) == "number" and value > 20 and value < 300 then
		frame:SetScale(value / 100)
	end
end)

addon:RegisterOptionCallback("predict", function(value)
	if value then
		predictBar:RequestNextQuakeInfo()
	else
		predictBar:Hide()
	end
end)

addon:RegisterOptionCallback("lock", function(value)
	if value then
		mover:Hide()
	else
		mover:Show()
	end
end)
