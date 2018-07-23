------------------------------------------------------------
-- Templates.lua
--
-- Abin
-- 2012/1/14
------------------------------------------------------------

local tinsert = tinsert
local CreateFrame = CreateFrame
local UnitExists = UnitExists
local GetRaidTargetIndex = GetRaidTargetIndex
local UnitPopupButtons = UnitPopupButtons
local UIErrorsFrame = UIErrorsFrame
local ERR_ARENA_TEAM_PERMISSIONS = ERR_ARENA_TEAM_PERMISSIONS

local _, addon = ...

local toolboxParent = CreateFrame("Frame", "CompactRaidToolboxParentFrame", addon:GetMainFrame(), "SecureFrameTemplate")
addon.toolboxParent = toolboxParent
toolboxParent:SetSize(16, 16)
toolboxParent:SetPoint("BOTTOMLEFT", addon:GetMainFrame(), "TOPLEFT", -12, 11)

addon:RegisterOptionCallback("showToolboxes", function(value)
	if value then
		toolboxParent:Show()
	else
		toolboxParent:Hide()
	end
end)

local toolFrames = {}

local menuCount = 0
local refFrame = CreateFrame("Frame", "CompactRaidToolMenusRefFrame", addon:GetMainFrame(), "SecureHandlerBaseTemplate")

addon:RegisterOptionCallback("containerBorderSize", function(value)
	toolFrames[1]:ClearAllPoints()
	toolFrames[1]:SetPoint("BOTTOMLEFT", addon:GetMainFrame(), "TOPLEFT", -value, value - 1)
end)

function addon:PrintPermissionError(msg)
	UIErrorsFrame:AddMessage(msg or ERR_ARENA_TEAM_PERMISSIONS, 1, 0, 0)
end

local function Button_OnEnter(self) self.highlight:Show() end
local function Button_OnLeave(self) self.highlight:Hide() end

local function Button_Grayout(self, gray)
	self.grayed = gray
	if gray then
		self.check:SetDesaturated(true)
		self.text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
	elseif self:IsEnabled() then
		self.check:SetDesaturated(false)
		self.text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
end

local function Button_OnEnable(self)
	if not self.grayed then
		self.check:SetDesaturated(false)
		self.text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
	if self.hideCheckOnDisabled then
		self.check:SetAlpha(1)
	end
end

local function Button_OnDisable(self)
	Button_OnLeave(self)
	self.check:SetDesaturated(true)
	self.text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
	if self.hideCheckOnDisabled then
		self.check:SetAlpha(0)
	end
end

local function Menu_AddButton(self, text, templates, disabled, hideCheckOnDisabled)
	local button = CreateFrame("Button", nil, self, templates)
	button:SetHeight(18)
	button.hideCheckOnDisabled = hideCheckOnDisabled

	local prev = self.buttons[#self.buttons]
	if prev then
		button:SetPoint("TOPLEFT", prev, "BOTTOMLEFT")
		button:SetPoint("TOPRIGHT", prev, "BOTTOMRIGHT")
	else
		button:SetPoint("TOPLEFT", 12, -30)
		button:SetPoint("TOPRIGHT", -12, -30)
	end

	button.Grayout = Button_Grayout

	tinsert(self.buttons, button)
	local buttoncount = #self.buttons
	self:SetAttribute("buttoncount", buttoncount)
	self:SetFrameRef("menubutton"..buttoncount, button)

	local highlight = button:CreateTexture(nil, "BORDER")
	button.highlight = highlight
	highlight:Hide()
	highlight:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
	highlight:SetBlendMode("ADD")
	highlight:SetVertexColor(1, 1, 1, 0.7)
	highlight:SetAllPoints(button)

	local check = button:CreateTexture(nil, "ARTWORK")
	button.check = check
	check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
	check:SetWidth(24)
	check:SetHeight(24)
	check:SetPoint("CENTER", button, "LEFT", 10, 0)
	check:Hide()

	local fs = button:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	button.text = fs
	fs:SetPoint("LEFT", check, "RIGHT")
	fs:SetText(text)

	button:HookScript("OnEnter", Button_OnEnter)
	button:HookScript("OnLeave", Button_OnLeave)
	button:SetScript("OnEnable", Button_OnEnable)
	button:SetScript("OnDisable", Button_OnDisable)

	if disabled then
		button:Disable()
	end
	return button
end

local function NOOP() end
local function Menu_AddClickButton(self, text, templates, disabled, hideCheckOnDisabled)
	local button = Menu_AddButton(self, text, templates and templates..",SecureHandlerClickTemplate" or "SecureHandlerClickTemplate", disabled, hideCheckOnDisabled)
	button.OnClick = NOOP
	button:SetAttribute("_onclick", [[
		self:GetParent():Hide()
		self:CallMethod("OnClick")
	]])
	return button
end

local function Menu_Finish(self)
	local button = Menu_AddButton(self, CLOSE, "SecureHandlerClickTemplate")
	button:SetAttribute("_onclick", [[ self:GetParent():Hide() ]])

	local COUNT = #self.buttons

	local maxTextLen = self.title:GetWidth()
	local i
	for i = 1, COUNT do
		local b = self.buttons[i]
		local text = b.text
		local len = text:GetWidth()
		if len > maxTextLen then
			maxTextLen = len
		end

	end

	maxTextLen = maxTextLen + 60
	if self.rightIcon then
		maxTextLen = maxTextLen + 20
	end

	self:SetSize(max(124, maxTextLen), (COUNT + 1) * 18 + 24)
	return button
end

local function Menu_OnShow(self)
	self:GetParent():LockHighlight()
end

local function Menu_OnHide(self)
	self:GetParent():UnlockHighlight()
end

local function Frame_CreateSecureMenu(self, title, rightIcon)
	local menu = CreateFrame("Button", nil, self, "SecureHandlerShowHideTemplate,SecureHandlerClickTemplate")
	menu:Hide()
	menu.rightIcon = rightIcon
	menu.buttons = {}
	menu:SetPoint("BOTTOMLEFT", self, "TOPLEFT")
	menu:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16, insets = {left = 5, right = 5, top = 5, bottom = 5 }, })
	menu:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b)
	menu:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)
	menu:SetToplevel(true)
	menu:SetClampedToScreen(true)
	menu:SetFrameStrata("FULLSCREEN_DIALOG")
	menu:RegisterForClicks("AnyUp")

	menu._OnShow = Menu_OnShow
	menu._OnHide = Menu_OnHide

	menu:SetFrameRef("refframe", refFrame)
	menuCount = menuCount + 1
	menu:SetAttribute("menuid", menuCount)
	refFrame:SetFrameRef("menu"..menuCount, menu)

	menu:SetAttribute("_onclick", [[
		self:Hide()
	]])

	menu:SetAttribute("_onshow", [[
		local refFrame = self:GetFrameRef("refframe")
		local opened = refFrame:GetAttribute("openedid")
		local id = self:GetAttribute("menuid")
		if opened and opened ~= id then
			refFrame:GetFrameRef("menu"..opened):Hide()
		end

		refFrame:SetAttribute("openedid", id)
		self:GetParent():SetAttribute("menushown", 1)
		self:RegisterAutoHide(0.5)
		self:AddToAutoHide(self:GetParent())

		local count = self:GetAttribute("buttoncount") or 0
		local i
		for i = 1, count do
			self:AddToAutoHide(self:GetFrameRef("menubutton"..i))
		end

		self:CallMethod("_OnShow")
	]])

	menu:SetAttribute("_onhide", [[
		local refFrame = self:GetFrameRef("refframe")
		local opened = refFrame:GetAttribute("openedid")
		local id = self:GetAttribute("menuid")
		if opened == id then
			refFrame:SetAttribute("openedid", nil)
		end

		self:GetParent():SetAttribute("menushown", nil)
		self:UnregisterAutoHide()
		self:CallMethod("_OnHide")
	]])

	self:SetFrameRef("menuframe", menu)

	local titleText = menu:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	menu.title = titleText
	titleText:SetPoint("TOPLEFT", 34, -12)
	titleText:SetText(title)

	menu.AddButton = Menu_AddButton
	menu.AddClickButton = Menu_AddClickButton
	menu.Finish = Menu_Finish
	return menu
end

local function Frame_OnEnter(self)
	if self.tooltipTitle then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:ClearLines()
		GameTooltip:AddLine(self.tooltipTitle)
		GameTooltip:AddLine(self.tooltipText, 1, 1, 1, 1)
		GameTooltip:Show()
	end
end

local function Frame_OnLeave(self)
	GameTooltip:Hide()
end

function addon:CreateToolbox(name, r, g, b, tooltipTitle, tooltipText)
	local frame = CreateFrame("Button", name, toolboxParent, "SecureHandlerClickTemplate,UIMenuButtonStretchTemplate")
	local prev = toolFrames[#toolFrames]
	if prev then
		frame:SetPoint("LEFT", prev, "RIGHT", -2, 0)
	else
		frame:SetPoint("TOPLEFT")
	end

	tinsert(toolFrames, frame)
	frame:SetSize(24, 15)
	self:RegisterMainFrameMover(frame)
	frame.tooltipTitle, frame.tooltipText = tooltipTitle, tooltipText

	local texture = frame:CreateTexture(name.."Texture", "ARTWORK")
	texture:SetSize(10, 10)
	texture:SetPoint("CENTER", 0, -1)
	texture:SetTexture("Interface\\RaidFrame\\Raid-WorldPing")
	texture:SetVertexColor(r, g, b)

	frame:SetScript("OnEnter", Frame_OnEnter)
	frame:SetScript("OnLeave", Frame_OnLeave)

	frame:SetAttribute("_onclick", [[
		local menuframe = self:GetFrameRef("menuframe")
		if menuframe then
			if self:GetAttribute("menushown") then
				menuframe:Hide()
			else
				menuframe:Show()
			end
		end
	]])

	frame:SetScript("PreClick", Frame_OnLeave)
	frame.CreateMenu = Frame_CreateSecureMenu
	return frame
end