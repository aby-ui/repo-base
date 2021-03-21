---------------------------------------------------------------------------------

-- Inline label with highlighted URL field widget for AceGUI-3.0
-- Written as part of OmniCD by Treebonker

-- Parameters:
-- hidden = boolean,
-- disabled = boolean,
-- name = "label",
-- desc = "tooltip",
-- type = "input",
-- get = function() return "URL" end,

---------------------------------------------------------------------------------

--[[-----------------------------------------------------------------------------
EditBox Widget
-------------------------------------------------------------------------------]]
local Type, Version = "Link-OmniCD", 1
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

-- Lua APIs
local tostring, pairs = tostring, pairs

-- WoW APIs
local CreateFrame, UIParent = CreateFrame, UIParent

--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]
local function Control_OnEnter(frame)
	frame.obj:Fire("OnEnter")
end

local function Control_OnLeave(frame)
	frame.obj:Fire("OnLeave")
end

local function Frame_OnShowFocus(frame)
	frame.obj.editbox:SetFocus()
	frame:SetScript("OnShow", nil)
end

local function EditBox_OnEscapePressed(frame)
	AceGUI:ClearFocus()
end

local function EditBox_OnTextChanged(frame, isUserInput)
	if isUserInput then
		local self = frame.obj
		self.editbox:SetText(self.lasttext or "")
		self.editbox:HighlightText()
	end
end

local function EditBox_OnChar(frame)
	local self = frame.obj
	self.editbox:SetText(self.lasttext or "")
	self.editbox:HighlightText()
end

local function EditBox_OnFocusGained(frame)
	AceGUI:SetFocus(frame.obj)
	frame.obj.editbox:HighlightText()
end

local function EditBox_OnFocusLost(frame)
	local self = frame.obj
	self.editbox:SetText(self.lasttext or "")
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		self:SetFullWidth(true)
		self:SetDisabled(false)
		self:SetLabel()
		self:SetText()
		self:SetMaxLetters(0)
	end,

	["OnRelease"] = function(self)
		self:ClearFocus()
	end,

	["SetDisabled"] = function(self, disabled)
		self.disabled = disabled
		if disabled then
			self.editbox:EnableMouse(false)
			self.editbox:ClearFocus()
			self.editbox:SetTextColor(0.5,0.5,0.5)
			self.label:SetTextColor(0.5,0.5,0.5)
		else
			self.editbox:EnableMouse(true)
			self.editbox:SetTextColor(1,1,1)
			self.label:SetTextColor(1,.82,0)
		end
	end,

	["SetText"] = function(self, text)
		self.lasttext = text or ""
		self.editbox:SetText(text or "")
		self.editbox:SetCursorPosition(0)
	end,

	["GetText"] = function(self, text)
		return self.editbox:GetText()
	end,

	["SetLabel"] = function(self, text)
		if text and text ~= "" then
			self.label:SetText(text)
			self.label:Show()
		else
			self.label:SetText("")
			self.label:Hide()
		end
	end,

	["SetMaxLetters"] = function (self, num)
		self.editbox:SetMaxLetters(num or 0)
	end,

	["ClearFocus"] = function(self)
		self.editbox:ClearFocus()
		self.frame:SetScript("OnShow", nil)
	end,

	["SetFocus"] = function(self)
		self.editbox:SetFocus()
		if not self.frame:IsShown() then
			self.frame:SetScript("OnShow", Frame_OnShowFocus)
		end
	end,
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local function Constructor()
	local num  = AceGUI:GetNextWidgetNum(Type)
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:Hide()
	frame:SetHeight(26)

	local label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall-OmniCD") --GameFontNormalSmall
	label:SetPoint("TOPLEFT")
	label:SetJustifyH("LEFT")
	label:SetWidth(100)
	label:SetHeight(26)

	local editbox = CreateFrame("EditBox", "AceGUI-3.0EditBox-OmniCD"..num, frame, "BackdropTemplate")
	editbox:SetAutoFocus(false)
	editbox:SetFontObject("GameFontHighlight-OmniCD") --ChatFontNormal
	editbox:SetScript("OnEnter", Control_OnEnter)
	editbox:SetScript("OnLeave", Control_OnLeave)
	editbox:SetScript("OnEscapePressed", EditBox_OnEscapePressed)
	editbox:SetScript("OnTextChanged", EditBox_OnTextChanged)
	editbox:SetScript("OnChar", EditBox_OnChar) -- prevent blinking
	editbox:SetScript("OnEditFocusGained", EditBox_OnFocusGained)

	editbox:SetScript("OnEditFocusLost", EditBox_OnFocusLost)
	editbox:SetTextInsets(0, 0, 3, 3)
	editbox:SetMaxLetters(256)
	editbox:SetPoint("TOPLEFT", label, "TOPRIGHT", 10, 0)
	editbox:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, 0)
	OmniCD[1].BackdropTemplate(editbox)
	editbox:SetBackdropColor(1, 1, 1, 0.05)
	editbox:SetBackdropBorderColor(0, 0, 0)

	local widget = {
		editbox     = editbox,
		label       = label,
		frame       = frame,
		type        = Type
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end
	editbox.obj = widget

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
