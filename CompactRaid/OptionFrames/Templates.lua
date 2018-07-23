------------------------------------------------------------
-- Templates.lua
--
-- Abin
-- 2010/10/31
------------------------------------------------------------

local _G = _G
local type = type
local tostring = tostring
local tonumber = tonumber
local strfind = strfind
local pairs = pairs
local CreateFrame = CreateFrame
local StaticPopup_Hide = StaticPopup_Hide
local GameTooltip = GameTooltip
local NORMAL_FONT_COLOR = NORMAL_FONT_COLOR
local ColorPickerFrame = ColorPickerFrame

local _, addon = ...
local L = addon.L
local templates = {}
addon.optionTemplates = templates

function addon:NormalizeNumber(number, low, high, default)
	if type(number) ~= "number" then
		return default
	end
	return number >= low and number <= high and number or default
end

function addon:PackColor(r, g, b)
	return format("%.1f,%.1f,%.1f", r, g, b)
end

function addon:UnpackColor(text, defaultR, defaultG, defaultB)
	if type(text) == "string" then
		local r, g, b = strmatch(text, "(.+),(.+),(.+)")
		if r and g and b then
			r, g, b = tonumber(r), tonumber(g), tonumber(b)
			if r and g and b then
				return r, g, b
			end
		end
	end
	return defaultR, defaultG, defaultB
end

-- Just do a "function" type check before calling, but I do need the error messages to popup!
local function _pcall(func, ...)
	if type(func) == "function" then
		return func(...)
	end
end

local function DefaultsButton_OnClick(self)
	addon:RestoreModuleDefaults(self.module)
end

local function ModuleGroup_OnCheckInit(self, value)
	if value == "enable" then
		return self.module:IsEnabled()
	else
		return self.module:IsSpecsSynced()
	end
end

local function ModuleGroup_OnCheckChanged(self, value, checked, button)
	local module = self.module
	if not module then
		return
	end

	if value == "enable" then
		local func = checked and module.OnPreEnable or module.OnPreDisable
		if type(func) == "function" and func(module) then
			button:SetChecked(not checked)
		else
			if checked then
				module:Enable()
			else
				module:Disable()
			end
		end
	else
		if checked then
			module:SyncSpecs()
		else
			module:UnsyncSpecs()
		end
	end
end

addon:RegisterEventCallback("OnModuleEnable", function(module)
	local page = module.optionPage
	if page and page == addon.optionFrame:GetSelectedPage() then
		addon.optionFrame.disabledPage:Hide()
		page:Show()
	end
end)

addon:RegisterEventCallback("OnModuleDisable", function(module)
	local page = module.optionPage
	if page and page == addon.optionFrame:GetSelectedPage() then
		page:Hide()
		addon.optionFrame.disabledPage:Show()
	end
end)

addon:RegisterEventCallback("OnModuleSync", function(module)
	local page = module.optionPage
	if page then
		page:SetSpecSymbol(0)
	end
end)

addon:RegisterEventCallback("OnModuleUnsync", function(module)
	local page = module.optionPage
	if page then
		page:SetSpecSymbol()
	end
end)

addon:RegisterEventCallback("OnModuleRestoreDefaults", function(module)
	local page = module.optionPage
	if page and page:IsVisible() then
		page:Hide()
		page:Show()
	end
end)

local function ModulePage_SetSpecSymbol(self, spec)
	local frame = self.specSymbolFrame
	if not frame then
		return
	end

	frame:Hide()
	if spec == 0 or type(LibPlayerSpells) ~= "table" or not LibPlayerSpells.GetSpecialization then
		return
	end

	local _, _, name, _, icon = LibPlayerSpells:GetSpecialization()
	if not name then
		return
	end

	frame.icon:SetTexture(icon)
	frame.text:SetText(name)
	frame:Show()
end

function templates:CreateModulePage(module, page)
	if module.spec then
		local frame = CreateFrame("Frame", nil, page)
		page.specSymbolFrame = frame
		frame:SetSize(16, 16)
		frame:SetPoint("LEFT", page.title, "RIGHT", 8, 0)
		frame:Hide()

		local icon = frame:CreateTexture(nil, "ARTWORK")
		frame.icon = icon
		icon:SetSize(16, 16)
		icon:SetPoint("LEFT")
		icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

		local text = frame:CreateFontString(nil, "ARTWORK", "GameFontGreenSmall")
		frame.text = text
		text:SetPoint("LEFT", icon, "RIGHT", 2, 0)
	end

	page.module = module
	module.optionPage = page
	page.SetSpecSymbol = ModulePage_SetSpecSymbol

	local defaults = page:CreatePressButton(DEFAULTS, module.secure)
	page.buttonDefaults = defaults
	defaults.module = module
	defaults:SetSize(96, 24)
	defaults:SetPoint("RIGHT", addon.optionFrame:GetOperationButton(1), "LEFT")
	defaults.tooltipText = format(L["restore defaults tooltip"], module.title)
	defaults:SetScript("OnClick", DefaultsButton_OnClick)

	if type(module.IsEnabled) == "function" then
		local group = page:CreateMultiSelectionGroup(nil, 1)
		group.module = module
		group.OnCheckInit = ModuleGroup_OnCheckInit
		group.OnCheckChanged = ModuleGroup_OnCheckChanged

		local enable = group:AddButton(L["enable module"], "enable", module.secure)
		page.buttonEnable = enable
		enable:ClearAllPoints()
		enable:SetPoint("TOPLEFT", addon.optionFrame.rightPanel, "BOTTOMLEFT", 0, -5)
		enable.tooltipText = format(L["enable module tooltip"], module.title)

		if module.spec then
			local sync = group:AddButton(L["sync dual-talent settings"], "sync", module.secure)
			page.buttonSync = sync
			sync.tooltipText = format(L["sync dual-talent tooltip"], module.title)
		end
	end
end

function templates:CreateScrollFrame(name, parent, scrollRespondingFrame, createChild)
	local frame = CreateFrame("ScrollFrame", name, parent, "UIPanelScrollFrameTemplate")
	frame.scrollBarHideable = 1
	frame.scrollBarFrame = _G[name.."ScrollBar"]
	frame.scrollBarFrame:Hide()

	local scrollBarBk = CreateFrame("Frame", nil, frame)
	scrollBarBk:SetBackdrop({ edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16, insets = {left = 5, right = 5, top = 5, bottom = 5 }})
	scrollBarBk:SetBackdropBorderColor(0.75, 0.75, 0.75, 0.75)
	scrollBarBk:SetPoint("TOPLEFT", _G[name.."ScrollBarScrollUpButton"], "TOPLEFT", -4, 4)
	scrollBarBk:SetPoint("BOTTOMRIGHT", _G[name.."ScrollBarScrollDownButton"], "BOTTOMRIGHT", 2, -4)
	scrollBarBk:SetParent(_G[name.."ScrollBar"])
	scrollBarBk:SetScale(0.6)

	local scrollChild
	if createChild then
		scrollChild = CreateFrame("Frame", name.."ScrollChild", frame)
		scrollChild:SetSize(100, 100)
		frame:SetScrollChild(scrollChild)
	end

	local respondFrame = scrollRespondingFrame or parent or frame
	respondFrame:EnableMouseWheel(true)
	respondFrame:SetScript("OnMouseWheel", function(self, delta) ScrollFrameTemplate_OnMouseWheel(frame, delta) end)

	frame:HookScript("OnScrollRangeChanged", function(self, xOffset, yOffset)
		if yOffset == 0 then
			self.scrollBarFrame:Hide()
		else
			self.scrollBarFrame:Show()
		end
	end)

	frame:HookScript("OnSizeChanged", function(self, x, y)
		if x then
			self:GetScrollChild():SetWidth(x)
		end
	end)

	return frame, scrollChild
end

local editToolltip = CreateFrame("Button", "CompactRaidOptionPageTooltip", UIParent)
templates.editToolltip = editToolltip

editToolltip:SetBackdrop({ edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16, insets = {left = 5, right = 5, top = 5, bottom = 5 }, })
editToolltip:SetFrameStrata("TOOLTIP")
editToolltip:SetClampedToScreen(true)
editToolltip:SetWidth(240)

local tooltipBk = editToolltip:CreateTexture(nil, "BORDER")
tooltipBk:SetTexture("Interface\\BUTTONS\\WHITE8X8.BLP")
tooltipBk:SetVertexColor(0, 0, 0, 1)
tooltipBk:SetPoint("TOPLEFT", 4, -4)
tooltipBk:SetPoint("BOTTOMRIGHT", -4, 4)

editToolltip.text = editToolltip:CreateFontString(editToolltip:GetName().."Text", "ARTWORK", "GameFontHighlightSmallLeftTop")
editToolltip.text:SetPoint("TOPLEFT", 10, -10)
editToolltip.text:SetWidth(220)
editToolltip.text:SetTextColor(1, 0.5, 0)
editToolltip.text:SetNonSpaceWrap(true)
editToolltip:Hide()

function editToolltip:Display(editbox)
	self.text:SetText(editbox:IsMultiLine() and L["edit prompt multiline"] or L["edit prompt"])
	self:SetHeight(self.text:GetHeight() + 20)
	self:ClearAllPoints()
	self:SetPoint("TOPLEFT", editbox, "BOTTOMLEFT")
	self:Show()
end

function templates:SetEditBoxAutoPrompt(editbox)

	editbox:HookScript("OnEditFocusGained", function(self)
		editToolltip.owner = self
		editToolltip:Display(self)
	end)

	editbox:HookScript("OnEditFocusLost", function(self)
		if editToolltip.owner == self then
			editToolltip.owner = nil
			editToolltip:Hide()
		end
	end)
end

function templates:CreateSubEdit(parent, frame, text, key, disableInCombat, textColor)
	local edit = parent:CreateEditBox(text, true, disableInCombat, textColor)
	edit.key = key
	frame.editboxes[key] = edit
	edit:SetParent(frame)
	edit:SetWidth(50)
	edit:SetJustifyH("CENTER")
	edit.default = 0

	edit.text:ClearAllPoints()
	edit:SetPoint("LEFT", edit.text, "RIGHT", 2, 0)

	templates:SetEditBoxAutoPrompt(edit)

	edit.ValidateValue = function(self, value)
		if type(value) ~= "number" then
			return self.default
		elseif self.min and value < self.min then
			return self.min
		elseif self.max and value > self.max then
			return self.max
		end
	end

	edit.OnTextValidate = function(self, text)
		local err = self:ValidateValue(tonumber(text))
		if err then
			return 1, tostring(err)
		end
	end

	edit.OnTextCommit = function(self, text)
		self:GetParent():OnTextCommit(self, self:GetNumber())
	end

	edit.OnTextCancel = function(self)
		local value = self:GetParent():OnTextCancel(self)
		if value then
			return tostring(value)
		end
	end

	edit.Commit = function(self)
		local text = self:GetText()
		local invalid, newText = self:OnTextValidate(text)
		if invalid then
			text = newText
			self:SetText(text)
		end

		self:ClearFocus()
		return tonumber(text)
	end

	return edit
end

function templates:CreateScaleOffsetGroup(parent, disableInCombat, textColor)
	local frame = parent:CreateSubControl("Frame")
	frame:SetSize(26, 26)
	frame.editboxes = {}

	local scale = templates:CreateSubEdit(parent, frame, L["scale"], "scale", disableInCombat, textColor)
	scale.min, scale.max, scale.default = 10, 300, 100
	scale:SetNumeric(true)
	scale.text:ClearAllPoints()
	scale.text:SetPoint("LEFT", frame, "LEFT")
	scale:SetPoint("LEFT", scale.text, "RIGHT", 2, 0)

	local percLabel = scale:CreateFontString(nil, "ARTWORK", "GameFontNormalLeft")
	scale.percLabel = percLabel
	percLabel:SetText("%")
	percLabel:SetPoint("LEFT", scale, "RIGHT")

	local xoffset = templates:CreateSubEdit(parent, frame, L["x-offset"], "xoffset", disableInCombat, textColor)
	xoffset.text:SetPoint("LEFT", percLabel, "RIGHT", 8, 0)

	local yoffset =  templates:CreateSubEdit(parent, frame, L["y-offset"], "yoffset", disableInCombat, textColor)
	yoffset.text:SetPoint("LEFT", xoffset, "RIGHT", 8, 0)

	frame.OnTextCommit = function(self, editbox, value)
		if editbox.key == "scale" then
			_pcall(self.OnScaleApply, self, value)
		elseif editbox.key == "xoffset" or editbox.key == "yoffset" then
			if editbox.key == "xoffset" then
				_pcall(self.OnOffsetApply, self, value, self.editboxes.yoffset:Commit())
			elseif editbox.key == "yoffset" then
				_pcall(self.OnOffsetApply, self, self.editboxes.xoffset:Commit(), value)
			end
		end
	end

	frame.OnTextCancel = function(self, editbox)
		if editbox.key == "scale" then
			return _pcall(self.OnScaleCancel, self)
		elseif editbox.key == "xoffset" or editbox.key == "yoffset" then
			local x, y = _pcall(self.OnOffsetCancel, self)
			return editbox.key == "xoffset" and x or y
		end
	end

	frame.ClearFocus = function(self)
		local editbox
		for _, editbox in pairs(self.editboxes) do
			editbox:ClearFocus()
		end
	end

	frame.SetFocus = function(self, key)
		local editbox = self.editboxes[key]
		if editbox then
			editbox:SetFocus()
		end
	end

	frame.SetValue = function(self, key, value, value2)
		if key == "offset" then
			if type(value) ~= "number" then
				value = 0
			end
			self.editboxes.xoffset:SetNumber(value)

			if type(value2) ~= "number" then
				value2 = 0
			end
			self.editboxes.yoffset:SetNumber(value2)
			return value, value2
		else
			local edit = self.editboxes[key]
			if edit then
				local err = edit:ValidateValue(value)
				if err then
					value = err
				end
				edit:SetNumber(value)
				return value
			end
		end
	end

	return frame
end

-- Make the stupid ColorPickerFrame callback system a little bit object-oriented
local SWATCH_UNIQUE = "CompactRaidColorSwatchUniqueFlag"
local function SwatchFunc(restore)
	local swatch = templates.selectedColorSwatch
	if not swatch or not swatch[SWATCH_UNIQUE] then
		return
	end

	local r, g, b
	if restore then
		r, g, b = restore.r, restore.g, restore.b
	else
		r, g, b = ColorPickerFrame:GetColorRGB()
	end

	swatch:SetColor(r, g, b)
	_pcall(swatch.OnColorChange, swatch, r, g, b)
	if restore then
		_pcall(swatch.OnColorCancel, swatch, r, g, b)
	end
end

function templates:CreateColorSwatch(name, parent)
	local colorSwatch = CreateFrame("Button", name, parent)
	colorSwatch[SWATCH_UNIQUE] = 1
	colorSwatch:SetWidth(16)
	colorSwatch:SetHeight(16)
	colorSwatch.r, colorSwatch.g, colorSwatch.b = 0, 1, 0

	colorSwatch:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 8 })
	colorSwatch:SetBackdropColor(0, 0, 0, 1)

	colorSwatch.bg = colorSwatch:CreateTexture(nil, "BORDER")
	colorSwatch.bg:SetPoint("TOPLEFT", 1, -1)
	colorSwatch.bg:SetPoint("BOTTOMRIGHT", -1, 1)
	colorSwatch.bg:SetTexture("Interface\\BUTTONS\\WHITE8X8.BLP")
	colorSwatch.bg:SetVertexColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)

	colorSwatch.swatch = colorSwatch:CreateTexture(nil, "ARTWORK")
	colorSwatch.swatch:SetPoint("TOPLEFT", 2, -2)
	colorSwatch.swatch:SetPoint("BOTTOMRIGHT", -2, 2)
	colorSwatch.swatch:SetTexture("Interface\\BUTTONS\\WHITE8X8.BLP")
	colorSwatch.swatch:SetVertexColor(0, 1, 0)

	colorSwatch._Enable = colorSwatch.Enable
	colorSwatch.Enable = function(self)
		self.swatch:SetVertexColor(self.r, self.g, self.b)
		self:_Enable()
		_pcall(self.OnEnable, self)
	end

	colorSwatch._Disable = colorSwatch.Disable
	colorSwatch.Disable = function(self)
		if templates.selectedColorSwatch == self and ColorPickerFrame.func == SwatchFunc then
			templates.selectedColorSwatch = nil
			ColorPickerFrame:Hide()
		end
		self.swatch:SetVertexColor(0.25, 0.25, 0.25)
		self:_Disable()
		_pcall(self.OnDisable, self)
	end

	colorSwatch.SetColor = function(self, r, g, b)
		self.r, self.g, self.b = r, g, b
		if self:IsEnabled() then
			self.swatch:SetVertexColor(r, g, b)
		end
	end

	colorSwatch.GetColor = function(self)
		return self.r, self.g, self.b
	end

	colorSwatch:SetScript("OnEnter", function(self)
		self.bg:SetVertexColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:ClearLines()
		GameTooltip:AddLine(L["click to change color"], nil, nil, nil, 1)
		GameTooltip:Show()
	end)

	colorSwatch:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
		self.bg:SetVertexColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end)

	colorSwatch:SetScript("OnClick", function(self)
		GameTooltip:Hide()
		ColorPickerFrame:Hide()
		templates.selectedColorSwatch = self
		ColorPickerFrame.func = SwatchFunc
		ColorPickerFrame:SetColorRGB(self.r, self.g, self.b)
		ColorPickerFrame.previousValues = { r = self.r, g = self.g, b = self.b }
		ColorPickerFrame.cancelFunc = SwatchFunc
		ColorPickerFrame.hasOpacity = nil
		ColorPickerFrame:Show()
	end)

	colorSwatch:SetScript("OnShow", function(self)
		local r, g, b = _pcall(self.OnColorRequest, self)
		if not r then
			if self.r then
				r, g, b = self.r, self.g, self.b
			else
				r, g, b = 0, 1, 0
			end
		end

		self:SetColor(r, g, b)
	end)

	colorSwatch:SetScript("OnHide", function(self)
		if templates.selectedColorSwatch == self and ColorPickerFrame.func == SwatchFunc then
			templates.selectedColorSwatch = nil
			ColorPickerFrame:Hide()
		end
	end)

	return colorSwatch
end

function templates:CreateLabeledColorSwatch(name, parent, text, dbkey)
	local colorSwatch = templates:CreateColorSwatch(name, parent)
	colorSwatch.dbkey = dbkey

	colorSwatch.text = colorSwatch:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	colorSwatch.text:SetPoint("LEFT", colorSwatch, "RIGHT", 8, 0)
	colorSwatch.text:SetText(text)

	colorSwatch.OnColorRequest = function(self)
		return addon:UnpackColor(addon.db[self.dbkey])
	end

	colorSwatch.OnColorChange = function(self, r, g, b)
		local key = self.dbkey
		addon.db[key] = addon:PackColor(r, g, b)
		addon:BroadcastOptionEvent(key, r, g, b)
	end

	return colorSwatch
end

function templates:CreateCustomColorGroup(parent, text)
	local group = parent:CreateSingleSelectionGroup(text, 1)
	group:AddButton(L["auto"], 1)
	local customeButton = group:AddButton(CUSTOM, 0)

	local colorSwatch = templates:CreateColorSwatch(customeButton:GetName().."ColorSwatch", customeButton)
	group.colorSwatch = colorSwatch
	colorSwatch.group = group
	colorSwatch:SetPoint("LEFT", customeButton.text, "RIGHT", 4, 0)

	colorSwatch.OnColorChange = function(self, r, g, b)
		_pcall(group.OnColorChange, group, r, g, b)
		--_pcall(group.OnApplyOption, group)
	end

	colorSwatch:SetScript("OnShow", function(self)
		local r, g, b = _pcall(group.OnColorRequest, group)
		if not r then
			r, g, b = 0, 1, 0
		end
		self:SetColor(r, g, b)
	end)

	group.OnCheckInit = function(self, value)
		local checked = _pcall(self.OnOptionInit, self, value)
		if value == 1 then
			if checked then
				self.colorSwatch:Disable()
			else
				self.colorSwatch:Enable()
			end
		end
		return checked
	end

	group.OnSelectionChanged = function(self, value)
		if value == 1 then
			self.colorSwatch:Disable()
		else
			self.colorSwatch:Enable()
		end
		_pcall(self.OnOptionChange, self, value)
		_pcall(group.OnApplyOption, group)
	end

	return group
end

function templates:CreateChildCombo(parent, text, disableInCombat)
	local combo = parent:CreateComboBox(text, 1, disableInCombat)
	combo.text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	combo.text:ClearAllPoints()
	combo:SetPoint("LEFT", combo.text, "RIGHT", 6, 0)
	return combo
end

function templates:CreateOptionCombo(parent, dbkey, text, disableInCombat)
	local combo = templates:CreateChildCombo(parent, text, disableInCombat)
	combo.dbkey = dbkey

	combo.OnComboInit = function(self)
		return addon.db[self.dbkey]
	end

	combo.OnComboChanged = function(self, value)
		local key = self.dbkey
		addon.db[key] = value
		addon:ApplyOption(key, value)
	end

	return combo
end

function templates:CreateOptionMultiSelectionGroup(parent, text)
	local group = parent:CreateMultiSelectionGroup(text)

	group.OnCheckInit = function(self, value, button)
		if button.charOption then
			return addon.chardb[value]
		else
			return addon.db[value]
		end
	end

	group.OnCheckChanged = function(self, value, checked, button)
		if button.charOption then
			addon.chardb[value] = checked
		else
			addon.db[value] = checked
		end
		addon:ApplyOption(value, checked)
	end

	return group
end

function templates:CreateOptionSingleSelectionGroup(parent, text, dbkey)
	local group = parent:CreateSingleSelectionGroup(text, 1)
	group.dbkey = dbkey

	group.OnCheckInit = function(self, value)
		return addon.db[self.dbkey] == value
	end

	group.OnSelectionChanged = function(self, value)
		addon.db[self.dbkey] = value
		addon:ApplyOption(self.dbkey, value)
	end

	return group
end

function templates:CreateOptionSlider(parent, dbKey, ...)
	local slider = parent:CreateSmallSlider(...)
	slider.dbKey = dbKey

	slider.OnSliderInit = function(self)
		return addon.db[self.dbKey]
	end

	slider.OnSliderChanged = function(self, value)
		addon.db[self.dbKey] = value
		addon:ApplyOption(self.dbKey, value)
	end

	return slider
end

function templates:CreateColorSelectionGroup(parent, text, dbKey, dbColorKey)
	local group = templates:CreateCustomColorGroup(parent, text)
	group.dbKey, group.dbColorKey = dbKey, dbColorKey

	group.OnColorRequest = function(self)
		return addon:UnpackColor(addon.db[self.dbColorKey])
	end

	group.OnColorChange = function(self, r, g, b)
		local key = self.dbColorKey
		addon.db[key] = addon:PackColor(r, g, b)
		addon:BroadcastOptionEvent(key, r, g, b)
	end

	group.OnOptionInit = function(self, value)
		if addon.db[self.dbKey] then
			return value == 0
		else
			return value == 1
		end
	end

	group.OnOptionChange = function(self, value)
		if value == 0 then
			addon.db[self.dbKey] = 1
		else
			addon.db[self.dbKey] = nil
		end
	end

	group.OnApplyOption = function(self)
		local key = self.dbKey
		addon:BroadcastOptionEvent(key, addon.db[key])
	end

	return group
end

local function NotifyFrame_SetText(self, text)
	self.text:SetText(text)
	self:SetHeight(self.text:GetHeight() + 30)
end

local function NotifyFrame_IsClosed(self)
	return self.manualClosed
end

local function NotifyFrameCloseButton_OnClick(self)
	local parent = self:GetParent()
	parent:Hide()
	parent.manualClosed = 1
	if type(parent.OnClose) == "function" then
		parent:OnClose()
	end
end

function templates:CreateNotifyFrame(name, parent, width, closable, arrowFlag)
	local frame = CreateFrame("Frame", name, parent, "GlowBoxTemplate")
	frame:SetSize(width, 56)
	frame:Hide()
	frame:SetFrameStrata("FULLSCREEN_DIALOG")

	local arrow = CreateFrame("Frame", frame:GetName().."Arrow", frame, "GlowBoxArrowTemplate")
	frame.arrow = arrow

	if arrowFlag == "LEFT" then
		arrow:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 4, 4)
	elseif arrowFlag == "RIGHT" then
		arrow:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", -4, 4)
	else
		arrow:SetPoint("TOP", frame, "BOTTOM", 0, 4)
	end

	local text = frame:CreateFontString(frame:GetName().."Text", "OVERLAY", "GameFontHighlightLeft")
	frame.text = text
	text:SetNonSpaceWrap(true)
	text:SetPoint("TOPLEFT", 12, -16)
	text:SetWidth(width - 24)

	if closable then
		local topClose = CreateFrame("Button", frame:GetName().."TopClose", frame, "UIPanelCloseButton")
		frame.topClose = topClose
		topClose:SetSize(32, 32)
		topClose:SetPoint("TOPRIGHT", 6, 6)
		topClose:SetScript("OnClick", NotifyFrameCloseButton_OnClick)
	end

	frame.SetText = NotifyFrame_SetText
	frame.IsClosed = NotifyFrame_IsClosed

	return frame
end

function templates:CreateDisabledPage(parent)
	local page = UICreateInterfaceOptionPage(parent:GetName().."DisabledPage", "disabled", "disabled", nil, parent)
	page:SetAllPoints(parent)

	local texture = page:CreateTexture(nil, "BORDER")
	texture:SetPoint("TOPLEFT", 0, -150)
	texture:SetPoint("TOPRIGHT", 0, -150)
	texture:SetHeight(96)
	texture:SetTexture(0.25, 0.25, 0.25, 0.75)

	local disableText = page:CreateFontString(nil, "ARTWORK", "GameFontDisable")
	disableText:SetPoint("CENTER", texture, "CENTER")
	disableText:SetFont(STANDARD_TEXT_FONT, 20, 1)
	disableText:SetText(L["module disabled mono"])

	local notify = templates:CreateNotifyFrame(page:GetName().."NotifyFrame", page, 220, nil, "LEFT")
	page.notifyFrame = notify

	notify:Show()
	notify:SetPoint("BOTTOMLEFT", 0, 20)

	page:SetScript("OnShow", function(self)
		local peer = self.peerPage
		local button = peer and peer.buttonEnable
		if button then
			self.title:SetText(peer.title:GetText())
			self.subTitle:SetText(peer.subTitle:GetText())
			button:SetParent(self)

			self.notifyFrame:SetText(format(L["check to enable"], peer.module.title))
		end
	end)

	page:SetScript("OnHide", function(self)
		local peer = self.peerPage
		local button = peer and peer.buttonEnable
		if button then
			button:SetParent(peer)
		end
	end)

	return page
end

local function InfoButton_OnEnter(self)
	local func = self.OnTooltip
	if type(func) == "function" then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:ClearLines()
		self:OnTooltip(GameTooltip)
		GameTooltip:Show()
	end
end

local function InfoButton_OnLeave(self)
	GameTooltip:Hide()
end

local function InfoButton_OnClick(self, ...)
	if type(self.OnClick) == "function" then
		self:OnClick(...)
	end
end

function templates:CreateInfoButton(name, parent, clickable)
	local button = CreateFrame("Button", name, parent, "UIPanelInfoButton")
	if clickable then
		button:SetScript("OnClick", InfoButton_OnClick)
	else
		button:SetScript("OnMouseDown", nil)
		button:SetScript("OnMouseUp", nil)
	end

	button:SetScript("OnEnter", InfoButton_OnEnter)
	button:SetScript("OnLeave", InfoButton_OnLeave)
	return button
end

local function CheckButtonInfo_OnTooltip(self, tooltip)
	tooltip:AddLine(self.tooltipTitle)
	tooltip:AddLine(self.tooltipText, 1, 1, 1, 1)
end

function templates:CreateCheckButtonInfo(checkButton, tooltipTitle, tooltipText)
	local button = self:CreateInfoButton(checkButton:GetName().."InfoButton", checkButton, clickable)
	button:SetPoint("LEFT", checkButton.text, "RIGHT", 2, 0)
	button.tooltipTitle, button.tooltipText = tooltipTitle, tooltipText
	button.OnTooltip = CheckButtonInfo_OnTooltip
	return button
end
