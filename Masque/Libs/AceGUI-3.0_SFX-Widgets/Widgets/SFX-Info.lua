--[[

	This file is part of 'AceGUI-3.0: SFX Widgets', an add-on for World of Warcraft. For bug reports,
	documentation and license information, please visit https://github.com/SFX-WoW/AceGUI-3.0_SFX-Widgets.

	* File...: SFX-Info.lua
	* Author.: StormFX

]]

-- GLOBALS: LibStub

----------------------------------------
-- Locals
---

local Type, Version = "SFX-Info", 2
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)

-- Exit if a current or newer version is loaded.
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

----------------------------------------
-- Lua API
---

local max, pairs = math.max, pairs

----------------------------------------
-- WoW API
---

local CreateFrame, UIParent = CreateFrame, UIParent

----------------------------------------
-- Utility
---

-- Frame:OnEnter()
local function Frame_OnEnter(self)
	self.obj:Fire("OnEnter")
end

-- Frame:OnLeave()
local function Frame_OnLeave(self)
	self.obj:Fire("OnLeave")
end

-- Height Update
local function UpdateHeight(self)
	if self.resizing then return end

	self.resizing = true

	local Frame, Info = self.frame, self.Info
	local Width = (Frame.width or Frame:GetWidth() or 0) - 83

	Width = (Width > 0 and Width) or 0

	Info:SetWidth(Width)
	Frame:SetHeight(Info:GetStringHeight())

	self.resizing = nil
end

----------------------------------------
-- Widget Methods
---

local Methods = {

	-- Widget:OnAcquire()
	-- Fires when the widget is initialized.
	OnAcquire = function(self)
		-- Reset the widget.
		self.resizing = true

		self:SetDisabled(true)
		self:SetLabel()
		self:SetColon()
		self:SetText()
		self:SetFullWidth(true)

		self.resizing = nil
		UpdateHeight(self)
	end,

	-- Widget:OnAcquire()
	-- Fires when the widget's width is changed.
	OnWidthSet = function(self)
		UpdateHeight(self)
	end,

	-- Widget:SetDisabled()
	-- Toggles showing of the tooltip.
	SetDisabled = function(self, Disabled)
		self.disabled = Disabled
		local frame = self.frame

		if Disabled then
			frame:SetScript("OnEnter", nil)
			frame:SetScript("OnLeave", nil)
		else
			frame:SetScript("OnEnter", Frame_OnEnter)
			frame:SetScript("OnLeave", Frame_OnLeave)
		end
	end,

	-- Widget:SetColon()
	-- Sets the column separator.
	SetColon = function(self, Text)
		self.Colon:SetText(Text or ":")
	end,

	-- Widget:SetLabel()
	-- Sets the text of the Label field.
	SetLabel = function(self, Text)
		Text = Text or ""
		self.Label:SetText(Text)

		if Text == "" then
			self:SetColon(Text)
		end
	end,

	-- Widget:GetText()
	-- Returns the text of the Info field.
	GetText = function(self)
		return self.Info:GetText() or ""
	end,

	-- Widget:SetText()
	-- Sets the text of the Info field.
	SetText = function(self, Text)
		Text = Text or ""

		self.Info:SetText(Text)
		UpdateHeight(self)
	end,

	-- Unused Methods
	-- OnRelease = nil,
	-- OnHeightSet = nil,
}

----------------------------------------
-- Constructor
---

local function Constructor()
	-- Container Frame
	local Frame = CreateFrame("Frame", nil, UIParent)

	-- Label: Left Text
	local Label = Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	Label:SetPoint("TOPLEFT", Frame, "TOPLEFT")
	Label:SetPoint("BOTTOM", Frame, "BOTTOM")
	Label:SetWidth(75)
	Label:SetJustifyH("RIGHT")
	Label:SetJustifyV("TOP")

	-- Colon: Column Separator
	local Colon = Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	Colon:SetPoint("TOPLEFT", Label, "TOPRIGHT")
	Colon:SetPoint("BOTTOM", Frame, "BOTTOM")
	Colon:SetWidth(8)
	Colon:SetJustifyH("LEFT")
	Colon:SetJustifyV("TOP")

	-- Info: Right Text
	local Info = Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	Info:SetPoint("TOPLEFT", Colon, "TOPRIGHT")
	Info:SetJustifyH("LEFT")
	Info:SetJustifyV("TOP")

	local Widget = {
		type  = Type,
		frame = Frame,
		--num = AceGUI:GetNextWidgetNum(Type),

		Label = Label,
		Colon = Colon,
		Info = Info,
	}

	for method, func in pairs(Methods) do
		Widget[method] = func
	end

	Frame.obj = Widget

	return AceGUI:RegisterAsWidget(Widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
