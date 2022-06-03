--[[

	This file is part of 'AceGUI-3.0: SFX Widgets', an add-on for World of Warcraft. For bug reports,
	documentation and license information, please visit https://github.com/SFX-WoW/AceGUI-3.0_SFX-Widgets.

	* File...: SFX-Info-URL.lua
	* Author.: StormFX

]]

-- GLOBALS: GetLocale, LibStub

----------------------------------------
-- Locals
---

local Type, Version = "SFX-Info-URL", 2
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
-- Locales
---

local L = {
	["Click to select this text."] = "Click to select this text.",
	["Copy"] = "Copy",
	["CTRL+C"] = "CTRL+C",
	["ESC"] = "ESC",
	["Press %s to cancel."] = "Press %s to cancel.",
	["Press %s to copy."] = "Press %s to copy.",
	["Select"] = "Select"
}

local Locale = GetLocale()

--if Locale == "deDE" then
--elseif Locale == "esMX" or Locale == "esES" then
--elseif Locale == "frFR" then
if Locale == "itIT" then
	L["Click to select this text."] = "Clicca per selezionare questo testo."
	L["Copy"] = "Copia"
	L["CTRL+C"] = "CTRL+C"
	L["ESC"] = "ESC"
	L["Press %s to cancel."] = "Premi %s per cancellare."
	L["Press %s to copy."] = "Premi %s per copiare."
	L["Select"] = "Seleziona"
--elseif Locale == "koKR" then
--elseif Locale == "ptBR" then
elseif Locale == "ruRU" then
	L["Click to select this text."] = "Щелкните, чтобы выделить этот текст."
	L["Copy"] = "Копировать"
	L["CTRL+C"] = "CTRL+C"
	L["ESC"] = "ESC"
	L["Press %s to cancel."] = "Нажмите %s для отмены"
	L["Press %s to copy."] = "Нажмите %s для копирования."
	L["Select"] = "Выбор"
--elseif Locale == "zhCN" then
elseif Locale == "zhTW" then
	L["Click to select this text."] = "點一下選擇此文字。"
	L["Copy"] = "複製"
	L["CTRL+C"] = "CTRL+C"
	L["ESC"] = "ESC"
	L["Press %s to cancel."] = "按 %s 取消。"
	L["Press %s to copy."] = "按 %s 複製。"
	L["Select"] = "選擇"
end

----------------------------------------
-- Strings
---

local KEY_COPY = "|cffffcc00"..L["CTRL+C"].."|r"
local KEY_EXIT = "|cffffcc00"..L["ESC"].."|r"
local TXT_COPY = (L["Press %s to copy."]):format(KEY_COPY)
local TXT_EXIT = (L["Press %s to cancel."]):format(KEY_EXIT)

----------------------------------------
-- Tooltip
---

local Tooltip = CreateFrame("GameTooltip", "SFX-Widgets-Tooltip", UIParent, "GameTooltipTemplate")

----------------------------------------
-- EditBox
---

local EditBox

-- EditBox:OnEnter()
local function EditBox_OnEnter(self)
	Tooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
	Tooltip:SetText(L["Copy"])
	Tooltip:AddLine(TXT_COPY, 1, 1, 1)
	Tooltip:AddLine(TXT_EXIT, 1, 1, 1)
	Tooltip:Show()
end

-- EditBox:OnLeave()
local function EditBox_OnLeave(self)
	Tooltip:Hide()
end

-- EditBox:OnFocusGained()
local function EditBox_OnFocusGained(self)
	self:HighlightText()
	self:SetCursorPosition(0)
end

-- EditBox:OnFocusLost()
local function EditBox_OnFocusLost(self)
	if self.obj then
		self.obj.Info:Show()
		self.obj = nil
	end

	self:Hide()
end

-- EditBox:OnTextChanged()
local function EditBox_OnTextChanged(self)
	local Text = (self:GetParent()).Value or ""

	self:SetText(Text)
	EditBox_OnFocusGained(self)
end

----------------------------------------
-- Button
---

-- Storage
local Buttons = {}

-- Button:OnEnter()
local function Button_OnEnter(self)
	Tooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
	Tooltip:SetText(L["Select"])
	Tooltip:AddLine(L["Click to select this text."], 1, 1, 1)
	Tooltip:Show()
end

-- Button:OnLeave()
local function Button_OnLeave(self)
	Tooltip:Hide()
end

-- Button:OnClick()
local function Button_OnClick(self)
	-- Explicit Call
	EditBox:ClearFocus()
	EditBox:SetParent(self)

	local obj = self.obj
	local Info = obj.Info
	local Text = self.Value or obj:GetText() or ""

	EditBox:ClearAllPoints()
	EditBox:SetPoint("TOPLEFT", Info, -2, 2)
	EditBox:SetPoint("BOTTOMRIGHT", Info, 0, -2)
	EditBox:SetText(Text)

	local Height = Info:GetStringHeight()
	local Multi = ((Height > 14) and true) or false

	EditBox:SetMultiLine(Multi)
	EditBox:Show()
	EditBox:SetFocus()
	EditBox.obj = obj

	Info:Hide()
end

----------------------------------------
-- Widget Methods
---

local Methods = {

	-- Widget:OnAcquire()
	-- Fires when the widget is initialized.
	OnAcquire = function(self)
		-- Reset the widget.
		self:SetDisabled(true)
		self:SetLabel()
		self:SetColon()
		self:SetText()
		self:SetFullWidth(true)
	end,

	-- Widget:SetDisabled()
	-- Toggles the ability to copy the right text.
	SetDisabled = function(self, Disabled)
		self.disabled = Disabled
		local Info = self.Info

		-- Disable Copy
		if Disabled then
			-- Cache the button.
			local Button = self.Button

			if Button then
				Buttons[#Buttons+1] = Button
				Button.Value = nil
				Button.obj = nil
				Button:SetParent(nil)
				Button:Hide()
				self.Button = nil
			end

			Info:SetTextColor(1, 1, 1)

		-- Enable Copy
		else
			-- Set up the EditBox.
			if not EditBox then
				EditBox = CreateFrame("EditBox", "AceGUI-3.0_SFX-InfoRow_EditBox", self.frame, "BackdropTemplate")
				EditBox:SetAutoFocus(true)
				EditBox:SetBackdrop({
					bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
					edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
					tile = true, edgeSize = 0.8, tileSize = 5,
				})
				EditBox:SetBackdropColor(0, 0, 0, 0.5)
				EditBox:SetBackdropBorderColor(1, 1, 1, 0.2)
				EditBox:SetFontObject("GameFontHighlight")
				EditBox:SetHeight(14)
				EditBox:SetJustifyH("LEFT")
				EditBox:SetJustifyV("TOP")
				EditBox:SetTextInsets(2, 1, 1, 1)

				EditBox:SetScript("OnEnter", EditBox_OnEnter)
				EditBox:SetScript("OnLeave", EditBox_OnLeave)
				EditBox:SetScript("OnTextChanged", EditBox_OnTextChanged)
				EditBox:SetScript("OnEnterPressed", EditBox.ClearFocus)
				EditBox:SetScript("OnEscapePressed", EditBox.ClearFocus)
				EditBox:SetScript("OnEditFocusLost", EditBox_OnFocusLost)
				EditBox:SetScript("OnEditFocusGained", EditBox_OnFocusGained)

				EditBox:Hide()
			end

			-- Set up a Button.
			local Button = self.Button

			if not Button then
				local i = #Buttons
				if i > 0 then
					Button = Buttons[i]
					Buttons[i] = nil
					Button:SetParent(self.frame)
				else
					Button = CreateFrame("Button", nil, self.frame)
					Button:SetScript("OnClick", Button_OnClick)
					Button:SetScript("OnEnter", Button_OnEnter)
					Button:SetScript("OnLeave", Button_OnLeave)
				end
			end

			Button.obj = self
			Button.Value = self:GetText()
			Button:ClearAllPoints()
			Button:SetAllPoints(Info)
			Button:Show()

			self.Button = Button
			Info:SetTextColor(0, 0.6, 1)
		end
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

	-- :Widget:SetColon()
	-- Sets the column separator.
	SetColon = function(self, Text)
		self.Colon:SetText(Text or ":")
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

		local Info = self.Info
		Info:SetText(Text)

		local Height = max(self.Label:GetStringHeight(), Info:GetStringHeight())
		self:SetHeight(Height)
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
	Info:SetPoint("BOTTOMRIGHT", Frame, "BOTTOMRIGHT")
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

	return AceGUI:RegisterAsWidget(Widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
