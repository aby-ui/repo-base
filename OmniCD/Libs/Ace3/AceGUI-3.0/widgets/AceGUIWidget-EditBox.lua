---------------------------------------------------------------------------------

-- Customized for OmniCD by permission of the copyright owner.

---------------------------------------------------------------------------------

--[[-----------------------------------------------------------------------------
EditBox Widget
-------------------------------------------------------------------------------]]
local Type, Version = "EditBox-OmniCD", 28
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

-- Lua APIs
local tostring, pairs = tostring, pairs

-- WoW APIs
local PlaySound = PlaySound
local GetCursorInfo, ClearCursor, GetSpellInfo = GetCursorInfo, ClearCursor, GetSpellInfo
local CreateFrame, UIParent = CreateFrame, UIParent
local _G = _G

-- Global vars/functions that we don't upvalue since they might get hooked, or upgraded
-- List them here for Mikk's FindGlobals script
-- GLOBALS: AceGUIEditBoxInsertLink, ChatFontNormal, OKAY

--[[-----------------------------------------------------------------------------
Support functions
-------------------------------------------------------------------------------]]
if not AceGUIEditBoxInsertLink then
	-- upgradeable hook
	hooksecurefunc("ChatEdit_InsertLink", function(...) return _G.AceGUIEditBoxInsertLink(...) end)
end

function _G.AceGUIEditBoxInsertLink(text)
	for i = 1, AceGUI:GetWidgetCount(Type) do
		local editbox = _G["AceGUI-3.0EditBox-OmniCD"..i]
		if editbox and editbox:IsVisible() and editbox:HasFocus() then
			editbox:Insert(text)
			return true
		end
	end
end

local function ShowButton(self)
	if not self.disablebutton then
		--[[ s r (not hiding btn)
		self.button:Show()
		self.editbox:SetTextInsets(0, 20, 3, 3)
		]]
		self.button:SetBackdropColor(0.725, 0.008, 0.008)
		self.button.Text:SetTextColor(1, 1, 1)
		self.button:EnableMouse(true)
		-- e
	end
end

local function HideButton(self)
	--[[ s r (this func is used as 'Disabled' instead)
	self.button:Hide()
	self.editbox:SetTextInsets(0, 0, 3, 3)
	]]
	self.button:SetBackdropColor(0.2, 0.2, 0.2)
	self.button.Text:SetTextColor(0.5, 0.5, 0.5)
	self.button:EnableMouse(false)
	-- e
end

--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]
local function Control_OnEnter(frame)
	frame.obj:Fire("OnEnter")
	frame.obj.editbox:SetBackdropBorderColor(0.5, 0.5, 0.5)  -- s a (match range slider editbox)
end

local function Control_OnLeave(frame)
	frame.obj:Fire("OnLeave")
	frame.obj.editbox:SetBackdropBorderColor(0.2, 0.2, 0.25) -- s a (match range slider editbox)
end

local function Frame_OnShowFocus(frame)
	frame.obj.editbox:SetFocus()
	frame:SetScript("OnShow", nil)
end

local function EditBox_OnEscapePressed(frame)
	AceGUI:ClearFocus()
end

local function EditBox_OnEnterPressed(frame)
	local self = frame.obj
	local value = frame:GetText()
	local cancel = self:Fire("OnEnterPressed", value)
	--[[ s r
	if not cancel then
		PlaySound(856) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON
		HideButton(self)
	end
	]]
	if not cancel then
		self.lasttext = value -- now we can update
		PlaySound(856) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON
		HideButton(self)
	end
	-- e
end

local function EditBox_OnReceiveDrag(frame)
	local self = frame.obj
	local type, id, info = GetCursorInfo()
	local name
	if type == "item" then
		name = info
	elseif type == "spell" then
		name = GetSpellInfo(id, info)
	elseif type == "macro" then
		name = GetMacroInfo(id)
	end
	if name then
		self:SetText(name)
		self:Fire("OnEnterPressed", name)
		ClearCursor()
		HideButton(self)
		AceGUI:ClearFocus()
	end
end

local function EditBox_OnTextChanged(frame)
	local self = frame.obj
	local value = frame:GetText()
	--[[ s r
	if tostring(value) ~= tostring(self.lasttext) then
		self:Fire("OnTextChanged", value)
		self.lasttext = value
		ShowButton(self)
	end
	]]
	-- update lastetext when we hit enter/okay -> more intuituve (atleast for non-multitext; edits)
	if tostring(value) ~= tostring(self.lasttext) then
		self:Fire("OnTextChanged", value)
		ShowButton(self)
	else -- rehide if we end up with the same initial text
		HideButton(self)
	end
	-- e
end

local function EditBox_OnFocusGained(frame)
	AceGUI:SetFocus(frame.obj)
end

local function Button_OnClick(frame)
	local editbox = frame.obj.editbox
	editbox:ClearFocus()
	EditBox_OnEnterPressed(editbox)
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		-- height is controlled by SetLabel
		self:SetWidth(200)
		self:SetDisabled(false)
		self:SetLabel()
		self:SetText()
		self:DisableButton(false)
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
		HideButton(self)
	end,

	["GetText"] = function(self, text)
		return self.editbox:GetText()
	end,

	["SetLabel"] = function(self, text)
		if text and text ~= "" then
			self.label:SetText(text)
			self.label:Show()
			--[[ s r
			self.editbox:SetPoint("TOPLEFT",self.frame,"TOPLEFT",7,-18)
			]]
			self.editbox:SetPoint("TOPLEFT",self.frame,"TOPLEFT",0,-19)
			-- e
			self:SetHeight(44)
			self.alignoffset = 30
		else
			self.label:SetText("")
			self.label:Hide()
			--[[ s r
			self.editbox:SetPoint("TOPLEFT",self.frame,"TOPLEFT",7,0)
			]]
			self.editbox:SetPoint("TOPLEFT",self.frame,"TOPLEFT",0,-1)
			-- e
			self:SetHeight(26)
			self.alignoffset = 12
		end
	end,

	["DisableButton"] = function(self, disabled)
		self.disablebutton = disabled
		if disabled then
			--[[ s r
			HideButton(self)
			]]
			self.button:SetBackdropColor(0.2, 0.2, 0.2)
			--self.button.Text:SetTextColor(0.5, 0.5, 0.5)
			self.button:enableMouse(false)
			-- e
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

	["HighlightText"] = function(self, from, to)
		self.editbox:HighlightText(from, to)
	end
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local function Constructor()
	local num  = AceGUI:GetNextWidgetNum(Type)
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:Hide()

	--[[ s r
	local editbox = CreateFrame("EditBox", "AceGUI-3.0EditBox"..num, frame, "InputBoxTemplate")
	]]
	local editbox = CreateFrame("EditBox", "AceGUI-3.0EditBox-OmniCD"..num, frame, BackdropTemplateMixin and "InputBoxTemplate, BackdropTemplate" or "InputBoxTemplate")
	-- e
	editbox:SetAutoFocus(false)
	--[[ s r
	editbox:SetFontObject(ChatFontNormal)
	]]
	editbox:SetFontObject("GameFontHighlight-OmniCD")
	-- e
	editbox:SetScript("OnEnter", Control_OnEnter)
	editbox:SetScript("OnLeave", Control_OnLeave)
	editbox:SetScript("OnEscapePressed", EditBox_OnEscapePressed)
	editbox:SetScript("OnEnterPressed", EditBox_OnEnterPressed)
	editbox:SetScript("OnTextChanged", EditBox_OnTextChanged)
	editbox:SetScript("OnReceiveDrag", EditBox_OnReceiveDrag)
	editbox:SetScript("OnMouseDown", EditBox_OnReceiveDrag)
	editbox:SetScript("OnEditFocusGained", EditBox_OnFocusGained)
	--[[ s r
	editbox:SetTextInsets(0, 0, 3, 3)
	]]
	editbox:SetTextInsets(3, 20, 3, 3) -- instead of hiding button, we're changing backdropcolor
	-- e
	editbox:SetMaxLetters(256)
	--[[ s r
	editbox:SetPoint("BOTTOMLEFT", 6, 0)
	editbox:SetPoint("BOTTOMRIGHT")
	editbox:SetHeight(19)
	]]
	editbox:SetPoint("BOTTOMRIGHT", 0, 3) -- TOPLEFT done in SetLabel
	editbox.Left:SetTexture(nil)
	editbox.Right:SetTexture(nil)
	editbox.Middle:SetTexture(nil)
	OmniCD[1].BackdropTemplate(editbox)
	editbox:SetBackdropColor(0, 0, 0, 0.5)
	editbox:SetBackdropBorderColor(0.2, 0.2, 0.25)
	-- e

	local label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall-OmniCD")
	label:SetPoint("TOPLEFT", 0, -2)
	label:SetPoint("TOPRIGHT", 0, -2)
	label:SetJustifyH("LEFT")
	label:SetHeight(18)

	--[[ s r
	local button = CreateFrame("Button", nil, editbox, "UIPanelButtonTemplate")
	]]
	local button = CreateFrame("Button", nil, editbox, BackdropTemplateMixin and "UIPanelButtonTemplate, BackdropTemplate" or "UIPanelButtonTemplate")
	-- e
	button:SetWidth(40)
	--[[ s r
	button:SetHeight(20)
	button:SetPoint("RIGHT", -2, 0)
	]]
	-- inherits UIPanelButtonNoTooltipTemplate <Size x="40" y="22"/>
	button:SetPoint("TOPRIGHT")
	button:SetPoint("BOTTOMRIGHT")
	-- e
	button:SetText(OKAY)
	button:SetScript("OnClick", Button_OnClick)
	--[[ s -r (we're no longer hiding)
	button:Hide()
	]]

	-- s b
	-- inherits UIPanelButtonNoTooltipTemplate (combination of Lt, Rt, Mid, and Highlight texture)
	button.Left:Hide() -- SetTexture is called repeatedly on disable etc, only Hide will work
	button.Right:Hide()
	button.Middle:Hide()
	button:SetHighlightTexture(nil)
	OmniCD[1].BackdropTemplate(button)
	button:SetBackdropColor(0.725, 0.008, 0.008)
	button:SetBackdropBorderColor(0.2, 0.2, 0.25)
	button:SetNormalFontObject("GameFontHighlight-OmniCD")
	button:SetHighlightFontObject("GameFontHighlight-OmniCD")
	button:SetDisabledFontObject("GameFontDisable-OmniCD")
	-- TODO: add flash or onenter/leave border
	-- e

	local widget = {
		alignoffset = 30,
		editbox     = editbox,
		label       = label,
		button      = button,
		frame       = frame,
		type        = Type
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end
	editbox.obj, button.obj = widget, widget

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
