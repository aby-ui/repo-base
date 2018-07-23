------------------------------------------------------------
-- OptionFrame.lua
--
-- Abin
-- 2010/10/16
------------------------------------------------------------

local CreateFrame = CreateFrame
local pairs = pairs
local ipairs = ipairs
local type = type
local tostring = tostring
local tonumber = tonumber
local GetSpellInfo = GetSpellInfo
local strtrim = strtrim
local CloseDropDownMenus = CloseDropDownMenus
local UIDropDownMenu_AddButton = UIDropDownMenu_AddButton
local ToggleDropDownMenu = ToggleDropDownMenu
local ColorPickerFrame = ColorPickerFrame
local _

local L = CompactRaid:GetLocale("CornerIndicators")
local module = CompactRaid:GetModule("CornerIndicators")
if not module then return end

local auraGroups = _G["LibBuffGroups-1.0"]

module.optionData = {}
local activeOptionKey, activeOptionDB

local templates = CompactRaid.optionTemplates

local page = module.optionPage

local tabFrame = UICreateTabFrame(page:GetName().."TabFrame", page)
page.tabFrame = tabFrame
page:AnchorToTopLeft(tabFrame, 0, -24)
tabFrame:SetWidth(556)
tabFrame:SetHeight(420)

do
	local i
	for i = 1, #module.INDICATOR_KEYS do
		local key = module.INDICATOR_KEYS[i]
		tabFrame:AddTab(L[key], key)
		module.optionData[key] = module:DecodeData()
	end

	activeOptionKey = "TOPLEFT"
	activeOptionDB = module.optionData.TOPLEFT
end

local scaleoffset = templates:CreateScaleOffsetGroup(page)
scaleoffset:SetPoint("TOPLEFT", tabFrame, "TOPLEFT", 20, -20)

function scaleoffset:OnScaleApply(scale)
	activeOptionDB.scale = scale
	module:SaveOptionData()
	module:UpdateAllIndicators(activeOptionKey, nil, nil, 1)
end

function scaleoffset:OnScaleCancel()
	return activeOptionDB.scale
end

function scaleoffset:OnOffsetApply(xoffset, yoffset)
	activeOptionDB.xoffset, activeOptionDB.yoffset = xoffset, yoffset
	module:SaveOptionData()
	module:UpdateAllIndicators(activeOptionKey, nil, nil, nil, 1)
end

function scaleoffset:OnOffsetCancel()
	return activeOptionDB.xoffset, activeOptionDB.yoffset
end

local styleGroup = page:CreateSingleSelectionGroup(L["indicator style"], 1)
styleGroup:SetPoint("TOPLEFT", scaleoffset, "BOTTOMLEFT", 0, -20)
styleGroup:AddButton(L["icon"], 0):ClearAllPoints()
styleGroup[1]:SetPoint("LEFT", styleGroup, "LEFT", 48, 0)
styleGroup:AddButton(L["color block"], 1)
styleGroup:AddButton(L["numerical"], 2)
styleGroup:AddButton(HIDE, 3)

function styleGroup:OnCheckInit(value)
	return value == activeOptionDB.style
end

function styleGroup:OnSelectionChanged(value)
	activeOptionDB.style = value
	module:SaveOptionData()
	page:UpdateOptionStats()
	module:UpdateAllIndicators(activeOptionKey, 1)
end

local function CreateStageOption(text, key)
	local colorSwatch = templates:CreateColorSwatch(page:GetName().."Swatch"..key, page)
	colorSwatch.key = key

	local label = page:CreateFontString(nil, "ARTWORK", "GameFontHighlightLeft")
	colorSwatch.label = label
	label:SetPoint("LEFT", colorSwatch, "RIGHT")
	label:SetText(" - "..text)

	if key > 1 then
		local combo = page:CreateComboBox()
		colorSwatch.combo = combo
		combo.key = key
		combo:SetPoint("LEFT", label, "RIGHT", 7, 0)
		combo:SetWidth(100)

		if key == 2 then
			combo:AddLine("75%", 75)
			combo:AddLine("50%", 50)
			combo:AddLine("25%", 25)
			combo:AddLine(NONE, 0)
		else
			combo:AddLine(format(INT_SPELL_DURATION_SEC, 10), 10)
			combo:AddLine(format(INT_SPELL_DURATION_SEC, 7), 7)
			combo:AddLine(format(INT_SPELL_DURATION_SEC, 5), 5)
			combo:AddLine(format(INT_SPELL_DURATION_SEC, 3), 3)
			combo:AddLine(NONE, 0)
		end

		combo.OnComboChanged = function(self, value)
			activeOptionDB["threshold"..self.key] = value
			module:SaveOptionData()
		end
	end

	colorSwatch.OnColorChange = function(self, r, g, b)
		local key = self.key
		activeOptionDB["r"..key] = r
		activeOptionDB["g"..key] = g
		activeOptionDB["b"..key] = b
		module:SaveOptionData()
	end

	colorSwatch.OnEnable = function(self)
		self.label:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		if self.combo then
			self.combo:Enable()
		end
	end

	colorSwatch.OnDisable = function(self)
		self.label:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
		if self.combo then
			self.combo:Disable()
		end
	end

	return colorSwatch
end

local auraEdit = page:CreateEditBox(L["aura name"], 1)
auraEdit:SetWidth(210)
auraEdit.text:ClearAllPoints()
auraEdit.text:SetPoint("TOPLEFT", styleGroup, "BOTTOMLEFT", 0, -24)
auraEdit:SetPoint("LEFT", auraEdit.text, "LEFT", 50, 0)
templates:SetEditBoxAutoPrompt(auraEdit)

function auraEdit:OnTextCommit(text)
	text = strtrim(text)
	if text == "" or text == L["type spell name"] then
		text = nil
	end

	local spellId = tonumber(text)
	if spellId then
		text = GetSpellInfo(spellId)
		self:SetText(text or L["type spell name"])
	end

	activeOptionDB.aura = text
	module:SaveOptionData()
	page:UpdateSimilarPrompt()
	module:UpdateAllIndicators(activeOptionKey, nil, 1)

	if not text then
		self:SetText(L["type spell name"])
	end
end

function auraEdit:OnTextCancel()
	return activeOptionDB.aura or L["type spell name"]
end

auraEdit:HookScript("OnEditFocusGained", function(self)
	CloseDropDownMenus()
end)

local similarButton = page:CreateSubControl("Button")
similarButton.icon = similarButton:CreateTexture(nil, "BORDER")
similarButton.icon:SetAllPoints(similarButton)
similarButton.icon:SetTexture("Interface\\Icons\\Ability_Rogue_ShadowStrikes")
similarButton.count = similarButton:CreateFontString(nil, "ARTWORK", "TextStatusBarText")
similarButton.count:SetPoint("BOTTOMRIGHT", -1, 1)
similarButton:SetSize(20, 20)
similarButton:SetPoint("LEFT", auraEdit, "RIGHT", 4, 0)

function page:UpdateSimilarPrompt()
	local aura = activeOptionDB.aura
	local list = auraGroups:GetGroupAuras(auraGroups:GetAuraGroup(aura))
	if list then
		activeOptionDB.checkSimilar = 1
		similarButton.tooltipTitle = aura
		local similar, text
		local count = 0
		for similar in pairs(list) do
			if similar ~= aura then
				count = count + 1
				if text then
					text = text.."\n"..similar
				else
					text = similar
				end
			end
		end

		similarButton.tooltipText = "\n"..L["similars/conflicts"].."\n|cffffffff"..(text or "").."|r"
		similarButton.icon:SetDesaturated(false)
		similarButton.count:SetText(count)
	else
		activeOptionDB.checkSimilar, similarButton.tooltipTitle, similarButton.tooltipText = nil
		similarButton.icon:SetDesaturated(true)
		similarButton.count:SetText()
	end

	if GameTooltip:IsOwned(similarButton) then
		similarButton:Hide()
		similarButton:Show()
	end
end

local spellButton = page:CreateSubControl("Button")
spellButton:SetWidth("28")
spellButton:SetHeight("58")
spellButton:SetScale(0.7)
spellButton:SetPoint("LEFT", similarButton, "RIGHT", 4, 11)
LoadMicroButtonTextures(spellButton, "Spellbook")
spellButton:SetHitRectInsets(0, 0, 22, 0)

local BUILTIN_SPELLS = module.DEFAULT_SPELLS[select(2, UnitClass("player"))]
if BUILTIN_SPELLS then
	local spellList = {}
	local spellid
	for _, spellid in ipairs(BUILTIN_SPELLS) do
		local name, _, icon = GetSpellInfo(spellid)
		if name then
			spellList[name] = icon
		end
	end

	local spellMenu = CreateFrame("Button", spellButton:GetName().."SpellMenu", spellButton, "UIDropDownMenuTemplate")
	spellMenu.point = "TOPRIGHT"
	spellMenu.relativeTo = spellButton
	spellMenu.relativePoint = "TOPLEFT"
	spellMenu.xOffset = 0
	spellMenu.yOffset = -14

	local function OnMenuClick(self, spell)
		if spell then
			auraEdit:SetText(spell)
			auraEdit:OnTextCommit(spell)
			auraEdit:ClearFocus()
		end
	end

	UIDropDownMenu_Initialize(spellMenu, function()
		local text = strtrim(auraEdit:GetText())
		local name, icon
		for name, icon in pairs(spellList) do
			local sel = name == text
			UIDropDownMenu_AddButton({ text = name, icon = icon, arg1 = name, func = OnMenuClick, checked = sel })
		end
	end, "MENU")

	spellButton:SetScript("OnClick", function()
		auraEdit:ClearFocus()
		ToggleDropDownMenu(nil, nil, spellMenu)
	end)
else
	spellButton:Disable()
end

function page:UpdateOptionStats()
	local i
	for i = 1, 3 do
		local colorSwatch = self.stages[i]
		if activeOptionDB.style == 0 or activeOptionDB.showlacks then
			colorSwatch:Disable()
		else
			colorSwatch:Enable()
		end
	end
end

local spellGroup = page:CreateMultiSelectionGroup(CALENDAR_FILTERS, 1)
spellGroup:SetPoint("TOPLEFT", auraEdit.text, "BOTTOMLEFT", 0, -20)

spellGroup:AddButton(L["self cast"], "selfcast")
spellGroup:AddButton(L["show lacks"], "showlacks"):ClearAllPoints()
spellGroup:AddButton(L["ignore outranged"], "ignoreOutRanged"):ClearAllPoints()
spellGroup:AddButton(L["ignore vehicles"], "ignoreVehicle"):ClearAllPoints()
spellGroup:AddButton(L["ignore physical classes"], "ignorePhysical"):ClearAllPoints()
spellGroup:AddButton(L["ignore magical classes"], "ignoreMagical"):ClearAllPoints()
page.showLacksCheck = spellGroup[2]

-- [aura name]   [book]
-- [1] selfcast		[2] show misses
-- [3] ignore outranged	[4] ignore vehicle
-- [5] ignore physical	[6] ignore magical

spellGroup[2]:SetPoint("LEFT", spellGroup[1], "LEFT", 210, 0)
spellGroup[3]:SetPoint("TOPLEFT", spellGroup[1], "BOTTOMLEFT")
spellGroup[4]:SetPoint("TOPLEFT", spellGroup[2], "BOTTOMLEFT")
spellGroup[5]:SetPoint("TOPLEFT", spellGroup[3], "BOTTOMLEFT")
spellGroup[6]:SetPoint("TOPLEFT", spellGroup[4], "BOTTOMLEFT")

function spellGroup:OnCheckInit(value)
	return activeOptionDB[value]
end

function spellGroup:OnCheckChanged(value, checked)
	activeOptionDB[value] = checked
	module:SaveOptionData()
	module:UpdateAllIndicators(activeOptionKey, nil, 1)
	if value == "showlacks" then
		page:UpdateOptionStats()
	end
end

local colorLabel = page:CreateFontString(nil, "ARTWORK", "GameFontNormal")
colorLabel:SetPoint("TOPLEFT", spellGroup[5], "BOTTOMLEFT", 0, -20)
colorLabel:SetText(L["stage colors"])

page.stages = {}
page.stages[1] = CreateStageOption(L["normal stage"], 1)
page.stages[1]:SetPoint("TOPLEFT", colorLabel, "BOTTOMLEFT", 8, -10)

--hooksecurefunc(page.stages[1], "SetColor", function(self, r, g, b) print("setcolor", r, g, b) end)

page.stages[2] = CreateStageOption(L["remaining time"], 2)
page.stages[2]:SetPoint("TOPLEFT", page.stages[1], "BOTTOMLEFT", 0, -8)

page.stages[3] = CreateStageOption(L["remaining time"], 3)
page.stages[3]:SetPoint("TOPLEFT", page.stages[2], "BOTTOMLEFT", 0, -8)

local function LoadStageData(stage)
	local colorSwatch = page.stages[stage]
	colorSwatch:SetColor(activeOptionDB["r"..stage], activeOptionDB["g"..stage], activeOptionDB["b"..stage])
	if stage > 1 then
		colorSwatch.combo:SetSelection(activeOptionDB["threshold"..stage], 1)
	end
end

function tabFrame:OnTabSelected(id, key)
	if not key or not module.talentdb then
		return -- Should never happen
	end

	activeOptionKey = key
	activeOptionDB = module.optionData[key]

	scaleoffset:ClearFocus()
	auraEdit:ClearFocus()
	ColorPickerFrame:Hide()
	CloseDropDownMenus()

	scaleoffset:SetValue("scale", activeOptionDB.scale)
	scaleoffset:SetValue("offset", activeOptionDB.xoffset, activeOptionDB.yoffset)
	styleGroup:SetSelection(activeOptionDB.style, 1)

	auraEdit:SetText(activeOptionDB.aura or L["type spell name"])
	if not activeOptionDB.aura then
		auraEdit:HighlightText()
	end

	spellGroup:SetChecked("selfcast", activeOptionDB.selfcast, 1)
	spellGroup:SetChecked("showlacks", activeOptionDB.showlacks, 1)
	spellGroup:SetChecked("ignoreOutRanged", activeOptionDB.ignoreOutRanged, 1)
	spellGroup:SetChecked("ignoreVehicle", activeOptionDB.ignoreVehicle, 1)
	spellGroup:SetChecked("ignorePhysical", activeOptionDB.ignorePhysical, 1)
	spellGroup:SetChecked("ignoreMagical", activeOptionDB.ignoreMagical, 1)
	page:UpdateSimilarPrompt()
	LoadStageData(1)
	LoadStageData(2)
	LoadStageData(3)
	page:UpdateOptionStats()
end

function module:InitOptionData()
	local db = self.talentdb
	if not db then
		return
	end

	local key
	for _, key in ipairs(self.INDICATOR_KEYS) do
		self.optionData[key] = self:DecodeData(db[key])
	end

	tabFrame:DeselectTab()
	tabFrame:SelectTab(1)

	local indicator
	for _, indicator in ipairs(self.indicators) do
		indicator.db = self.optionData[indicator.key]
	end
end

function module:SaveOptionData()
	if self.talentdb then
		self.talentdb[activeOptionKey] = self:EncodeData(activeOptionDB)
	end
end
