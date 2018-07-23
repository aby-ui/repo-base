------------------------------------------------------------
-- OptionFrame.lua
--
-- Abin
-- 2010/10/30
------------------------------------------------------------

local wipe = wipe
local pairs = pairs
local type = type
local ipairs = ipairs
local strtrim = strtrim
local CloseDropDownMenus = CloseDropDownMenus
local _G = _G
local _

local L = CompactRaid:GetLocale("ClickSets")
local module = CompactRaid:GetModule("ClickSets")
if not module then return end

local templates = CompactRaid.optionTemplates

local BINDING_MODIFIERS_DISPLAY = { L["direct"], "Shift-", "Ctrl-", "Alt-", "Ctrl-Shift-", "Alt-Shift-", "Alt-Ctrl-", "Alt-Ctrl-Shift-" }
local actionCombos = {} -- Option combos for 8 modifiers: "Shift", "Ctrl", etc

local page = module.optionPage
page:AddCombatDisableItem(page.checkButtonSync)

local tabFrame = UICreateTabFrame(page:GetName().."TabFrame", page)
page.tabFrame = tabFrame
page:AnchorToTopLeft(tabFrame, 0, -24)
tabFrame:SetSize(556, 468)

tabFrame:AddTab(L["left button"])
tabFrame:AddTab(L["right button"])
tabFrame:AddTab(L["middle button"])
tabFrame:AddTab("4")
tabFrame:AddTab("5")
tabFrame:AddTab(L["wheel up"])
tabFrame:AddTab(L["wheel down"])

do
	local i
	for i = 1, tabFrame:NumTabs() do
		page:AddCombatDisableItem(tabFrame:GetTabButton(i))
	end
end

function tabFrame:OnTabTooltip(id)
	if id == 6 then
		GameTooltip:AddLine(KEY_MOUSEWHEELUP)
	elseif id == 7 then
		GameTooltip:AddLine(KEY_MOUSEWHEELDOWN)
	elseif id then
		GameTooltip:AddLine(_G["KEY_BUTTON"..id])
	end
end

local scrollFrame = CompactRaid.optionTemplates:CreateScrollFrame(page:GetName().."ScrollFrame", tabFrame, page, 1)
scrollFrame:SetPoint("TOPLEFT", 6, -6)
scrollFrame:SetPoint("BOTTOMRIGHT", -28, 6)

local frame = scrollFrame:GetScrollChild()

local spellEdit = page:CreateEditBox()
spellEdit:SetParent(frame)
spellEdit:SetWidth(342)
spellEdit:Hide()
page:AddCombatDisableItem(spellEdit)
templates:SetEditBoxAutoPrompt(spellEdit)

function spellEdit:StartEdit(combo, text)
	if self.editing ~= combo then
		self.editing = combo
		self:ClearAllPoints()
		self:SetPoint("TOPRIGHT", combo, "BOTTOMRIGHT")
		if combo.nextCombo then
			combo.nextCombo:ClearAllPoints()
			combo.nextCombo:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT")
		end
		self:Show()
	end

	self:SetText(text or "")
	self:SetFocus()
	self:HighlightText()
end

function spellEdit:EndEdit()
	local combo = self.editing
	if combo and combo.nextCombo then
		combo.nextCombo:ClearAllPoints()
		combo.nextCombo:SetPoint("TOPRIGHT", combo, "BOTTOMRIGHT")
	end
	self.editing = nil
	self:Hide()
end

function spellEdit:IsEditing()
	return self.editing
end

function spellEdit:OnTextCommit(text)
	text = strtrim(text)
	if text == "" then
		text = nil
	end
	self.editing:OnTextCommit(text)
	self:EndEdit()
end

function spellEdit:OnTextCancel()
	if self.editing then
		self.editing:OnTextCancel()
	end
	self:EndEdit()
end

function tabFrame:OnTabSelected(id)
	CloseDropDownMenus()
	spellEdit:EndEdit()

	if not id or not module.talentdb then
		return
	end

	local modifier, combo
	for modifier, combo in pairs(actionCombos) do
		combo.id = id
		combo.text:SetText(BINDING_MODIFIERS_DISPLAY[combo.modIndex]..(id > 5 and L["scroll"] or L["click"]))

		local action, extra = strmatch(module.talentdb[combo.modifier..id] or "", "(.-):(.+)")
		combo.action, combo.extra = action, extra
		combo.oldAction, combo.oldExtra = nil

		local value
		if action == "action" or action == "buildin" then
			value = extra
		else
			value = action
		end

		local line = combo.dropdown.lines[1]
		if modifier == "" and (id == 1 or id == 2) then
			line.disabled = 1
			if not value then
				value = id == 2 and "togglemenu" or "target"
			end
		else
			line.disabled = nil
		end

		combo:SetSelection(value, 1)

		if action == "spell" or action == "macro" then
			combo.detailText:SetActionText(extra)
		else
			combo.detailText:SetText()
		end
	end
end

local DEF_SPELL_LIST = module.DEFAULT_SPELLS[select(2, UnitClass("player"))]

local i, prev
for i = 1, #module.BINDING_MODIFIERS do
	local modifier = module.BINDING_MODIFIERS[i]
	local text = BINDING_MODIFIERS_DISPLAY[i]

	-- Combo for choosing actions: spell, macro, etc
	local combo = page:CreateComboBox(nil, 142, 1)
	combo:SetParent(frame)
	combo:SetWidth(196)

	combo.modifier = modifier
	combo.modIndex = i

	combo:AddLine(NONE)
	combo:AddLine(TARGET, "target")
	combo:AddLine(L["menu"], "togglemenu")
	combo:AddLine(BINDING_NAME_ASSISTTARGET, "assist")
	combo:AddLine(SET_FOCUS, "focus")
	combo:AddLine(FOLLOW, "follow")

	local line = combo:AddLine(L["transfer special spell"], "special", emergentIcon)
	line.tooltipTitle = L["transfer special spell"]
	line.tooltipText = module:GetSpecialMacro()
	line.tooltipOnButton = 1

	combo:AddLine(L["built-in spells"], "spacer", nil, "isTitle,notCheckable")

	local emergentMacro, emergentIcon = module:GetEmergentMacro()
	if emergentMacro then
		local line = combo:AddLine(L["Emergent macro"], "emergent", emergentIcon)
		line.tooltipTitle = L["Emergent macro"]
		line.tooltipText = emergentMacro
		line.tooltipOnButton = 1
	end

	if DEF_SPELL_LIST then
		local id
		for _, id in ipairs(DEF_SPELL_LIST) do
			local spell, _, icon = GetSpellInfo(id)
			if spell then
				combo:AddLine(spell, spell, icon)
			end
		end
	end

	combo:AddLine(L["custom action"], "spacer", nil, "isTitle,notCheckable")

	combo:AddLine(PLAYERSTAT_SPELL_COMBAT, "spell")
	combo:AddLine(MACRO, "macro")

	-- A little bit hacking...
	local dropdownText = combo.dropdown.text
	dropdownText:ClearAllPoints()
	dropdownText:SetPoint("LEFT", 8, 0)

	local detailText = combo:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmallLeft")
	combo.detailText = detailText
	detailText:SetPoint("LEFT", dropdownText, "RIGHT")
	detailText:SetPoint("RIGHT", combo.toggleButton, "LEFT")

	combo.toggleButton:HookScript("OnClick", function(self) spellEdit:OnTextCancel() end)

	detailText.SetActionText = function(self, text)
		if text then
			self:SetText(" = "..gsub(text, "\n", " "))
		else
			self:SetText(" =")
		end
	end

	combo.ApplyBind = function(self)
		module:ChangeBinding(self.modifier, self.id, self.action, self.extra)
	end

	combo.OnComboChanged = function(self, value)
		spellEdit:EndEdit()
		self.oldAction, self.oldExtra = self.action, self.extra

		if value == "spell" or value == "macro" then
			-- User spell/macro
			self.action = value
			local text = (self.oldAction == "spell" or self.oldAction == "macro") and self.extra or nil
			self.detailText:SetActionText(text)
			spellEdit:SetMultiLine(value == "macro")
			spellEdit:SetHeight(26)
			spellEdit:StartEdit(self, text)

		elseif module.ACTION_TYPES[value] == 1 then
			-- target, focus, follow, etc
			self.action = "action"
			self.extra = value
			self.detailText:SetText()
			self:ApplyBind()

		elseif value then
			-- buildin spell
			self.action = "buildin"
			self.extra = value
			self.detailText:SetText()
			self:ApplyBind()
		else
			-- none
			self.action = nil
			self.detailText:SetText()
			self:ApplyBind()
		end
	end

	combo.OnTextCommit = function(self, text)
		self.extra = text
		if text then
			self.detailText:SetActionText(text)
			self:ApplyBind()
		else
			self.detailText:SetText()
			self:SetSelection(nil)
		end
	end

	combo.OnTextCancel = function(self)
		self.action, self.extra = self.oldAction, self.oldExtra
		if self.action == "action" or self.action == "buildin" then
			self:SetSelection(self.extra, 1)
		else
			self:SetSelection(self.action, 1)
		end

		if action == "spell" or action == "macro" then
			self.detailText:SetActionText(self.extra)
		else
			self.detailText:SetText()
		end
	end

	actionCombos[modifier] = combo

	-- Align combo
	if prev then
		prev.nextCombo = combo
		combo:SetPoint("TOPRIGHT", prev, "BOTTOMRIGHT")
	else
		combo:SetPoint("TOPLEFT", 152, -6)
	end
	prev = combo
end

function module:InitOptionData()
	tabFrame:DeselectTab()
	tabFrame:SelectTab(1)
end
