------------------------------------------------------------
-- Templates.lua
--
-- Abin
-- 2015-9-06
------------------------------------------------------------

local CreateFrame = CreateFrame
local GetTime = GetTime
local tinsert = tinsert
local UISpecialFrames = UISpecialFrames
local CLASS_ICON_TCOORDS = CLASS_ICON_TCOORDS

local addon = WhisperPop
local L = addon.L

local templates = {}
addon.templates = templates

function templates.CreateFrame(name, parent, movable)
	local frame = CreateFrame("Frame", name, parent)
	frame:EnableMouse(true)
	frame:SetClampedToScreen(true)
	frame:SetBackdrop({ bgFile = addon.BACKGROUND, tile = true, tileSize = 16, edgeFile = addon.BORDER, edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 } })

	if movable then
		frame:SetMovable(true)
		frame:SetUserPlaced(true)
		frame:SetDontSavePosition(false)
		frame:RegisterForDrag("LeftButton")
		frame:SetScript("OnDragStart", frame.StartMoving)
		frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
	end

	local text = frame:CreateFontString(name.."Text", "ARTWORK", "GameFontNormal")
	frame.text = text
	text:SetPoint("TOP", 0, -10)

	local topClose = CreateFrame("Button", name.."TopCloseButton", frame, "UIPanelCloseButton")
	frame.topClose = topClose
	topClose:SetSize(24, 24)
	topClose:SetPoint("TOPRIGHT", -5, -5)

	local topLine = frame:CreateTexture(name.."TopLine", "ARTWORK")
	frame.topLine = topLine
	topLine:SetTexture("Interface\\OptionsFrame\\UI-OptionsFrame-Spacer")
	topLine:SetVertexColor(1, 1, 1, 0.5)
	topLine:SetHeight(16)
	topLine:SetPoint("LEFT", frame, "TOPLEFT", 4, -28)
	topLine:SetPoint("RIGHT", frame, "TOPRIGHT", -4, -28)

	tinsert(UISpecialFrames, name)
	return frame
end

local function DelayHideFrame_StartCounting(self)
	self.hideTime = GetTime() + 0.2
end

local function DelayHideFrame_StopCounting(self, show)
	self.hideTime = nil
	if show then
		self:Show()
	end
end

local function DelayHideFrame_OnUpdate(self, elapsed)
	if self.hideTime and GetTime() > self.hideTime then
		self.hideTime = nil
		self:Hide()
	end
end

function templates.RegisterDelayHideFrame(frame)
	frame:SetScript("OnUpdate", DelayHideFrame_OnUpdate)
	frame:SetScript("OnEnter", DelayHideFrame_StopCounting)
	frame:SetScript("OnLeave", DelayHideFrame_StartCounting)
	frame.StartCounting = DelayHideFrame_StartCounting
	frame.StopCounting = DelayHideFrame_StopCounting
end

local function IconButton_OnMouseDown(self)
	self.icon:SetPoint("CENTER", 1, -1)
end

local function IconButton_OnMouseUp(self)
	self.icon:SetPoint("CENTER")
end

function templates.CreateIconButton(name, parent, icon, size, checkable)
	local button = CreateFrame(checkable and "CheckButton" or "Button", name, parent)
	button:SetSize(size, size)
	button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
	button:SetPushedTexture("Interface\\Buttons\\UI-Quickslot-Depress")
	if checkable then
		button:SetCheckedTexture("Interface\\Buttons\\CheckButtonHilight", "ADD")
	end

	button.icon = button:CreateTexture(name and (name.."Icon"), "ARTWORK")
	button.icon:SetSize(size, size)
	button.icon:SetPoint("CENTER")
	button.icon:SetTexture(icon)
	button:SetScript("OnMouseDown", IconButton_OnMouseDown)
	button:SetScript("OnMouseUp", IconButton_OnMouseUp)
	return button
end

function templates.ShowPlayerInfo(data, texture, fontString, forceRealm)
	if not data then
		return
	end

	if data.class == "GM" then
		texture:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-Blizz")
		texture:SetTexCoord(0.18, 0.82, 0, 1)
	elseif data.class == "BN" then
		texture:SetTexture("Interface\\FriendsFrame\\PlusManz-BattleNet")
		texture:SetTexCoord(0, 1, 0, 1)
	else
		local coords = CLASS_ICON_TCOORDS[data.class]
		if coords then
			texture:SetTexture("Interface\\WorldStateFrame\\Icons-Classes")
			texture:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
		else
			texture:SetTexture()
		end
	end

	fontString:SetText(addon:GetDisplayName(data.name, forceRealm))
end

local function FlashFrame_OnUpdate(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed < 0.5 then
		return
	end
	self.elapsed = 0

	if self.stopTime and GetTime() > self.stopTime then
		self:Hide()
	else
		if self.texture:IsShown() then
			self.texture:Hide()
		else
			self.texture:Show()
		end
	end
end

local function FlashFrame_OnShow(self)
	self.elapsed = 0
	self.texture:Show()
end

local function FlashParent_StartFlash(self, duration)
	if type(duration) ~= "number" or duration <= 0 then
		duration = nil
	end

	if duration then
		self.flashFrame.stopTime = GetTime() + duration
	else
		self.flashFrame.stopTime = nil
	end

	self.flashFrame:Show()
end

local function FlashParent_StopFlash(self)
	self.flashFrame:Hide()
end

function templates.CreateFlash(parent)
	local name = parent:GetName()
	local frame = CreateFrame("Frame", name and name.."FlashFrame", parent)
	parent.flashFrame = frame
	frame:SetAllPoints(parent)
	frame:Hide()

	frame:SetScript("OnUpdate", FlashFrame_OnUpdate)
	frame:SetScript("OnShow", FlashFrame_OnShow)

	local texture = frame:CreateTexture(name and name.."FlashFrameTexture", "OVERLAY")
	frame.texture = texture
	texture:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-BlinkHilight")
	texture:SetAllPoints(frame)
	texture:Hide()

	parent.StartFlash = FlashParent_StartFlash
	parent.StopFlash = FlashParent_StopFlash

	return frame
end