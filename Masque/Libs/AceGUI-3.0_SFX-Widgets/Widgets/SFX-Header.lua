--[[

	This file is part of 'AceGUI-3.0: SFX Widgets', an add-on for World of Warcraft. For bug reports,
	documentation and license information, please visit https://github.com/SFX-WoW/AceGUI-3.0_SFX-Widgets.

	* File...: SFX-Header.lua
	* Author.: StormFX

]]

-- GLOBALS: LibStub

----------------------------------------
-- Locals
---

local Type, Version = "SFX-Header", 1
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)

-- Exit if a current or newer version is loaded.
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

----------------------------------------
-- Lua API
---

local gsub, pairs = string.gsub, pairs

----------------------------------------
-- WoW API
---

local CreateFrame, UIParent = CreateFrame, UIParent

----------------------------------------
-- Utililty
---

-- Updates the borders' visibility.
local function UpdateBorders(self)
	-- No borders.
	if self.disabled then
		self.Left:Hide()
		self.Right:Hide()

	-- Left and right borders.
	elseif self.Center then
		self.Left:Show()
		self.Right:Show()

	-- Right border only.
	else
		self.Left:Hide()
		self.Right:Show()
	end
end

----------------------------------------
-- Widget Methods
---

local Methods = {

	-- Widget:OnAcquire()
	-- Fires when the widget is initialized.
	OnAcquire = function(self)
		-- Reset the widget.
		self.disabled = nil
		self:SetText()
		self:SetFullWidth(true)
		self:SetHeight(18)
	end,

	-- Widget:SetDisabled()
	-- Sets the text alignment.
	SetCenter = function(self, Center)
		Center = (Center and self.Text ~= "") or nil
		self.Center = Center

		local Label = self.Label

		if Center then
			Label:ClearAllPoints()
			Label:SetPoint("TOP")
			Label:SetPoint("BOTTOM")
		else
			Label:ClearAllPoints()
			Label:SetPoint("TOPLEFT")
			Label:SetPoint("BOTTOMLEFT")
		end

		UpdateBorders(self)
	end,

	-- Widget:SetDisabled()
	-- Toggles the border.
	SetDisabled = function(self, Disabled)
		self.disabled = Disabled
		UpdateBorders(self)
	end,

	-- Widget:SetText()
	-- Sets the header text.
	SetText = function(self, Text)
		local Text, Count = gsub(Text or "", ">>>", "")
		self.Text = Text

		local Label = self.Label
		Label:SetText(Text)

		if Text == "" then
			self.Right:SetPoint("LEFT")
		else
			self.Right:SetPoint("LEFT", Label, "RIGHT", 5, 0)
		end

		self:SetCenter(Count > 0)
	end,

	-- Unused Methods
	-- OnRelease = nil,
	-- OnHeightSet = nil,
	-- OnWidthSet = nil,
}

----------------------------------------
-- Constructor
---

local function Constructor()
	local Frame = CreateFrame("Frame", nil, UIParent)
	Frame:Hide()

	local Label = Frame:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
	Label:SetJustifyH("CENTER")
	Label:SetPoint("TOPLEFT")
	Label:SetPoint("BOTTOMLEFT")

	local Left = Frame:CreateTexture(nil, "BACKGROUND")
	Left:SetTexture(137057) -- Interface\\Tooltips\\UI-Tooltip-Border
	Left:SetTexCoord(0.81, 0.94, 0.5, 1)
	Left:SetVertexColor(0.6, 0.6, 0.6)
	Left:SetHeight(8)
	Left:SetPoint("LEFT")
	Left:SetPoint("RIGHT", Label, "LEFT", -5, 0)

	local Right = Frame:CreateTexture(nil, "BACKGROUND")
	Right:SetTexture(137057) -- Interface\\Tooltips\\UI-Tooltip-Border
	Right:SetTexCoord(0.81, 0.94, 0.5, 1)
	Right:SetVertexColor(0.6, 0.6, 0.6)
	Right:SetHeight(8)
	Right:SetPoint("RIGHT")
	Right:SetPoint("LEFT", Label, "RIGHT", 5, 0)

	local Widget = {
		type  = Type,
		frame = Frame,

		Label = Label,
		Left  = Left,
		Right = Right,
	}

	for method, func in pairs(Methods) do
		Widget[method] = func
	end

	return AceGUI:RegisterAsWidget(Widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
