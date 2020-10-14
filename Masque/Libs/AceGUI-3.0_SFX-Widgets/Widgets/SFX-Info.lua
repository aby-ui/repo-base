--[[

	This file is part of 'AceGUI-3.0: SFX Widgets', an add-on for World of Warcraft. For bug reports,
	suggestions and license information, please visit https://github.com/SFX-WoW/AceGUI-3.0_SFX-Widgets.

	* File...: SFX-Info.lua
	* Author.: StormFX

]]

-- GLOBALS: CreateFrame, LibStub, UIParent

----------------------------------------
-- Locals
---

local Type, Version = "SFX-Info", 1
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)

-- Exit if a current or newer version is loaded.
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

----------------------------------------
-- Lua
---

local max = math.max

----------------------------------------
-- WoW API
---

local CreateFrame = CreateFrame

do
	----------------------------------------
	-- Frame
	---

	-- Frame:OnEnter()
	local function Frame_OnEnter(self)
		self.obj:Fire("OnEnter")
	end

	-- Frame:OnLeave()
	local function Frame_OnLeave(self)
		self.obj:Fire("OnLeave")
	end

	----------------------------------------
	-- Widget
	---

	-- Widget:OnAcquire()
	local function Widget_OnAcquire(self)
		-- Default to disabled.
		self:SetDisabled(true)
		self:SetLabel()
		self:SetColon()
		self:SetText()
		self:SetFullWidth(true)
	end

	-- Widget:OnRelease()
	local function Widget_OnRelease(self)
		self:SetDisabled(true)
		self.frame:ClearAllPoints()
	end

	-- Widget:SetDisabled()
	-- Toggles showing of the tooltip.
	local function Widget_SetDisabled(self, Disabled)
		self.disabled = Disabled
		local frame = self.frame

		-- Disable Tooltip
		if Disabled then
			frame:SetScript("OnEnter", nil)
			frame:SetScript("OnLeave", nil)

		-- Enable Tooltip
		else
			frame:SetScript("OnEnter", Frame_OnEnter)
			frame:SetScript("OnLeave", Frame_OnLeave)
		end
	end

	-- Widget:SetColon()
	-- Sets the column separator.
	local function Widget_SetColon(self, Text)
		self.Colon:SetText(Text or ":")
	end

	-- Widget:SetLabel()
	-- Sets the text of the Label field.
	local function Widget_SetLabel(self, Text)
		Text = Text or ""
		self.Label:SetText(Text)

		if Text == "" then
			self:SetColon(Text)
		end
	end

	-- Widget:GetText()
	-- Returns the text of the Info field.
	local function Widget_GetText(self)
		return self.Info:GetText() or ""
	end

	-- Widget:SetText()
	-- Sets the text of the Info field.
	local function Widget_SetText(self, Text)
		Text = Text or ""

		local Info = self.Info
		Info:SetText(Text)

		local Height = max(self.Label:GetStringHeight(), Info:GetStringHeight())
		self:SetHeight(Height)
	end

	-- Widget:SetWidth()
	-- * Uses :SetFullWidth(true).
	local function Widget_SetWidth(self, Width)
		--self.frame:SetWidth(Width)
	end

	----------------------------------------
	-- Constructor
	---

	local function Constructor()
		local Widget = {}

		-- Container Frame
		local Frame = CreateFrame("Frame", nil, UIParent)

		Widget.frame = Frame
		Frame.obj = Widget

		-- Label: Left Text
		local Label = Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		Label:SetWidth(75)
		Label:SetPoint("TOPLEFT", Frame, "TOPLEFT")
		Label:SetPoint("BOTTOM", Frame, "BOTTOM")
		Label:SetJustifyH("RIGHT")
		Label:SetJustifyV("TOP")

		Widget.Label = Label
		Label.obj = Widget

		-- Colon: Column Separator
		local Colon = Frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		Colon:SetWidth(8)
		Colon:SetPoint("TOPLEFT", Label, "TOPRIGHT")
		Colon:SetPoint("BOTTOM", Frame, "BOTTOM")
		Colon:SetJustifyH("LEFT")
		Colon:SetJustifyV("TOP")

		Widget.Colon = Colon
		Colon.obj = Widget

		-- Info: Right Text
		local Info = Frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		Info:SetPoint("TOPLEFT", Colon, "TOPRIGHT")
		Info:SetPoint("BOTTOMRIGHT", Frame, "BOTTOMRIGHT")
		Info:SetJustifyH("LEFT")
		Info:SetJustifyV("TOP")

		Widget.Info = Info
		Info.obj = Widget

		-- Widget
		Widget.type  = Type
		Widget.num   = AceGUI:GetNextWidgetNum(Type)

		Widget.OnAcquire = Widget_OnAcquire
		Widget.OnRelease = Widget_OnRelease
		Widget.SetDisabled = Widget_SetDisabled

		Widget.SetColon = Widget_SetColon
		Widget.SetLabel = Widget_SetLabel
		Widget.GetText = Widget_GetText
		Widget.SetText = Widget_SetText
		Widget.SetWidth = Widget_SetWidth

		return AceGUI:RegisterAsWidget(Widget)
	end
	AceGUI:RegisterWidgetType(Type, Constructor, Version)
end
