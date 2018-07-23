-----------------------------------------------------------
-- InterfaceOptionPage-1.0.lua
-----------------------------------------------------------
-- A simple function set for implementing Blizzard Interface Option style option
-- pages and common GUI option elements.
--
-----------------------------------------------------------
-- Sample Usage:
-----------------------------------------------------------
--
-- page = UICreateInterfaceOptionPage("name", "title" [, "subTitle" [, "categoryParent" [, parentFrame]]])
-- page:AnchorToTopLeft(control [, xOffset, yOffset])
-- page:AddCombatDisableItem(control)
-- page:Open() -- Show the frame

-- page:SetDialogStyle("style" [, hideOnEscape]) -- Set dialog style for stand-alone option frames, style must be one of "TITLE_DIALOG", "DIALOG", "TOOLTIP", "THIN", "NONE", default is "NONE" which removes existing dialog style
-- page:Toggle() -- Show/hide the frame, only for stand-alone option frames

-- slider = page:CreateSlider("text", minVal, maxVal [, step [, "valueFormat" [, disableInCombat]]])
-- slider = page:CreateSmallSlider("text", minVal, maxVal [, step [, "valueFormat" [, disableInCombat]]]) -- The slider is smaller
-- slider.OnSliderInit = function(self) return someValue end
-- slider.OnSliderChanged = function(self, value) end

-- combo = page:CreateComboBox("text" [, horizontal [, disableInCombat]])
-- combo:AddLine(text, value [, icon [, flag [, r, g, b [, position]]]]) -- flag: 1-isTitle, 2-disabled, 3-notClickable, 4-notCheckable
-- combo:OnMenuRequest() -- Callback, if this function exists, "AddLine" will have no effect outside of "OnMenuRequest"
-- combo:DeleteLine(value [, noNotify])
-- combo:NumLines()
-- combo:GetSelection()
-- combo:SetSelection(value [, noNotify])
-- combo:SetSelectionByPosition(position [, noNotify])
-- combo:GetValueByPosition(position)
-- combo.OnComboInit = function(self) return someValue end
-- combo.OnComboChanged = function(self, value) end

-- editbox = page:CreateEditBox("text" [, horizontal [, disableInCombat]])
-- editbox:CommitText() -- Commit the text and clear focus if succeeds
-- cancel, newText = editbox:OnTextValidate(text) -- called when ENTER key is pressed
-- editbox:OnTextCommit(text) -- called after editbox:OnTextValidate succeeds
-- newText = editbox:OnTextCancel() -- called when ESC key is pressed

-- pressButton = page:CreatePressButton("text" [, disableInCombat])

-- multiGroup = page:CreateMultiSelectionGroup("title" [, horizontal])
-- multiGroup:AddButton("text", value [, disableInCombat [, key1, value1 [, ...]])
-- multiGroup.OnCheckInit = function(self, value) return someValue end
-- multiGroup.OnCheckChanged = function(self, value, checked) end

-- multiGroup:SetChecked(value, checked [, noNotify])
-- multiGroup:GetChecked(value)

-- singleGroup = page:CreateSingleSelectionGroup("title" [, horizontal])
-- singleGroup:AddButton("text", value [, disableInCombat [, key1, value1 [, ...]])
-- singleGroup.OnCheckInit = function(self, value) return value == someValue end
-- singleGroup.OnSelectionChanged = function(self, value) end

-- singleGroup:SetSelection(value [, noNotify])
-- singleGroup:GetSelection()

-- page:CreatePanel(frame [, noBkgnd [, noBorder]]) -- Creates or decorates a panel with backgroud and border

-- control.tooltipTitle -- string, tooltip title to display
-- control.tooltipText -- string, tooltip text to display

-- or

-- control:OnTooltipRequest(tooltip)

-- frame:CreateRoundButton("name", parent, "icon" [, "text" [, disableInCombat]])

-----------------------------------------------------------

local pcall = pcall
local type = type
local error = error
local min = min
local max = max
local CreateFrame = CreateFrame
local ipairs = ipairs
local pairs = pairs
local tinsert = tinsert
local tremove = tremove
local format = format
local strtrim = strtrim
local strupper = strupper
local getglobal = getglobal
local hooksecurefunc = hooksecurefunc
local CloseDropDownMenus = CloseDropDownMenus
local InterfaceOptions_AddCategory = InterfaceOptions_AddCategory
local InterfaceOptionsFrame_OpenToCategory = InterfaceOptionsFrame_OpenToCategory
local _G = _G
local UISpecialFrames = UISpecialFrames
local _

local MAJOR_VERSION = 1
local MINOR_VERSION = 65

-- To prevent older libraries from over-riding newer ones...
if type(UICreateInterfaceOptionPage_IsNewerVersion) == "function" and not UICreateInterfaceOptionPage_IsNewerVersion(MAJOR_VERSION, MINOR_VERSION) then return end

local GUID = "{FF87CB54-703B-432B-A8E3-1DF612BFC3D0}"
local frame = _G[GUID]
if not frame then
	frame = CreateFrame("Frame")
	_G[GUID] = frame
	frame.items = {}
	frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	frame:RegisterEvent("PLAYER_REGEN_ENABLED")
end

frame:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_REGEN_ENABLED" then
		local item
		for item in pairs(self.items) do
			if type(item) == "table" and item.__flag_combatDisabled == GUID then
				item.__flag_combatDisabled = nil
				pcall(item.Enable, item)
			end
		end
	elseif event == "PLAYER_REGEN_DISABLED" then
		local item
		for item in pairs(self.items) do
			if type(item) == "table" then
				local _, enabled = pcall(item.IsEnabled, item)
				if enabled then
					item.__flag_combatDisabled = GUID
					pcall(item.Disable, item)
				end
			end
		end
	end
end)

local function ClearAndHook(self, script, func)
	self:SetScript(script, nil)
	self:HookScript(script, func)
end

local function AddCombatDisableItem(self, item)
	if type(item) == "table" and type(item.GetObjectType) == "function" then
		frame.items[item] = 1
		return 1
	end
end

local function GetNextControlName(self, prefix)
	self.subControlId = (self.subControlId or 0) + 1
	return format("%s_%s_%d", self:GetName(), prefix or "SubControl", self.subControlId)
end

local function SubControl_OnShow(self)
	pcall(self.OnShow, self)
	if not self._firstShownDone then
		self._firstShownDone = 1
		pcall(self.OnInitShow, self)
	end
end

local function SubControl_OnEnter(self)
	local func = self.OnTooltipRequest
	if type(func) ~= "function" then
		func = nil
	end

	if not func and not self.tooltipTitle and not self.tooltipText then
		return
	end

	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:ClearLines()

	if func then
		func(self, GameTooltip)
	else
		if self.tooltipTitle then
			GameTooltip:AddLine(self.tooltipTitle)
		end

		if self.tooltipText then
			GameTooltip:AddLine(self.tooltipText, 1, 1, 1, 1)
		end
	end

	GameTooltip:Show()
end

local function SubControl_OnLeave(self)
	GameTooltip:Hide()
end

local function CreateSubControl(self, frameType, text, template, disableInCombat)
	local frame = CreateFrame(frameType, self:GetNextControlName(frameType), self, template)
	frame.text = getglobal(frame:GetName().."Text")

	if text then
		if frame.text then
			frame.text:SetText(text)
		else
			pcall(frame.SetText, frame, text)
		end
	end

	if disableInCombat then
		AddCombatDisableItem(self, frame)
	end

	ClearAndHook(frame, "OnShow", SubControl_OnShow)
	ClearAndHook(frame, "OnEnter", SubControl_OnEnter)
	ClearAndHook(frame, "OnLeave", SubControl_OnLeave)
	return frame
end

local function CreatePanel(self, frame, noBackground, noEdge)
	if type(frame) ~= "table" or type(frame.SetBackdrop) ~= "function" then
		frame = CreateSubControl(self, "Frame")
	end

	local backdrop = {}
	if not noEdge then
		backdrop.edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border"
		backdrop.edgeSize = 16
		backdrop.insets = {left = 5, right = 5, top = 5, bottom = 5 }
	end

	if not noBackground then
		backdrop.bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background"
		backdrop.tile = true
		backdrop.tileSize = 16
	end

	frame:SetBackdrop(backdrop)
	if not noEdge then
		frame:SetBackdropBorderColor(0.75, 0.75, 0.75, 0.75)
	end

	return frame
end

local function CreatePressButton(self, text, disableInCombat)
	local button = CreateSubControl(self, "Button", text, "UIPanelButtonTemplate", disableInCombat)
	button:SetSize(96, 24)
	button:SetMotionScriptsWhileDisabled(true)
	return button
end

local function CheckButton_Text_OnSetText(self)
	self:GetParent():SetHitRectInsets(0, -self:GetWidth(), 0, 0)
end

local function CheckButton_OnEnable(self)
	self.text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
end

local function CheckButton_OnDisable(self)
	self.text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
end

local function CheckButton_OnClick(self)
	pcall(self.OnClick, self, self:GetChecked())
end

local function CreateCheckButton(self, text, disableInCombat)
	local button = CreateSubControl(self, "CheckButton", text, "InterfaceOptionsCheckButtonTemplate", disableInCombat)
	button:SetMotionScriptsWhileDisabled(true)
	hooksecurefunc(button.text, "SetText", CheckButton_Text_OnSetText)
	button.text:SetText(text)
	button:SetScript("OnClick", nil)
	hooksecurefunc(button, "Enable", CheckButton_OnEnable)
	hooksecurefunc(button, "Disable", CheckButton_OnDisable)
	return button
end

local function CheckGroup_OnShow(self)
	local valid, value = pcall(self.group.OnCheckInit, self.group, self.value, self)
	if valid then
		self:SetChecked(value)
		if value then
			self.group._recentSelection = self.value
		end
	end
end

local function CheckGroup_OnClick(self)
	pcall(self.group.OnCheckChanged, self.group, self.value, self:GetChecked(), self)
end

local function CheckGroup_GetButton(self, idx)
	if type(idx) ~= "number" or idx < 1 then
		return self[-1]
	end
	return self.buttons[idx] or self[-1]
end


local function CheckGroup_AddButton(self, text, value, disableInCombat, ...)
	local button = CreateCheckButton(self:GetParent(), text, disableInCombat)
	button.group = self
	button.value = value

	local pairCount = select("#", ...)
	local i
	for i = 1, pairCount, 2 do
		local key = select(i, ...)
		local value = select(i + 1, ...)
		if type(key) == "string" then
			button[key] = value
		end
	end

	tinsert(self.buttons, button)
	button.OnShow = CheckGroup_OnShow
	button:HookScript("OnClick", CheckGroup_OnClick)

	local anchor = self[-1]
	if anchor and self.horiz then
		anchor = anchor.text
	end

	if anchor then
		button:SetPoint(self.horiz and "LEFT" or "TOPLEFT", anchor, self.horiz and "RIGHT" or "BOTTOMLEFT", self.horiz and 12 or 0, 0)
	else
		button:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -6)
	end

	tinsert(self, button)
	self[-1] = button
	return button
end

local function MultiGroup_SetChecked(self, value, checked, noNotify)
	checked = checked and 1 or nil
	local button
	for _, button in ipairs(self.buttons) do
		if button.value == value then
			if button:GetChecked() ~= checked then
				button:SetChecked(checked)
				if not noNotify then
					pcall(self.OnCheckChanged, self, value, checked, button)
				end
			end
			return
		end
	end
end

local function MultiGroup_GetChecked(self, value)
	local button
	for _, button in ipairs(self.buttons) do
		if button.value == value then
			return button:GetChecked()
		end
	end
end

local function CreateMultiSelectionGroup(self, title, horizontal)
	local group = self:CreateFontString(GetNextControlName(self, "FontString"), "ARTWORK", "GameFontNormalLeft")
	group:SetText(title)
	group.buttons = {}
	group.horiz = horizontal
	group.AddButton = CheckGroup_AddButton
	group.GetButton = CheckGroup_GetButton
	group.SetChecked = MultiGroup_SetChecked
	group.GetChecked = MultiGroup_GetChecked
	return group
end

local function SingleGroup_OnCheckChanged(self, value, checked, button)
	if checked then
		local other, changed
		for _, other in ipairs(self.buttons) do
			if other ~= button and other:GetChecked() then
				other:SetChecked(nil)
				changed = 1
			end
		end

		self._recentSelection = button.value
		if changed then
			pcall(self.OnSelectionChanged, self, value, button)
		end
	else
		button:SetChecked(1)
	end
end

local function SingleGroup_SetSelection(self, value, noNotify)
	local button, found
	for _, button in ipairs(self.buttons) do
		if button.value == value then
			found = button
			button:SetChecked(1)
			self._recentSelection = value
		else
			button:SetChecked(nil)
		end
	end

	if found and not noNotify then
		pcall(self.OnSelectionChanged, self, value, found)
	end
end

local function SingleGroup_GetSelection(self)
	return self._recentSelection
end

local function CreateSingleSelectionGroup(self, ...)
	local group = CreateMultiSelectionGroup(self, ...)
	group.OnCheckChanged = SingleGroup_OnCheckChanged
	group.SetSelection = SingleGroup_SetSelection
	group.GetSelection = SingleGroup_GetSelection
	return group
end

local function Slider_OnShow(self)
	local valid, value = pcall(self.OnSliderInit, self)
	if valid and type(value) == "number" then
		self._pausechange = 1
		self:SetValue(value)
		self._pausechange = nil
	end
end

local function Slider_OnValueChanged(self, value)
	self.value:SetText(format(self.valueFormat, value))
	if not self._pausechange then
		pcall(self.OnSliderChanged, self, value)
	end
end

local function Slider_OnEnable(self)
	local textColor = self.defaultColor or NORMAL_FONT_COLOR
	self.text:SetTextColor(textColor.r, textColor.g, textColor.b)
	self.value:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	self.low:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	self.high:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
end

local function Slider_OnDisable(self)
	self.text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
	self.value:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
	self.low:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
	self.high:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
end

local function CreateSlider(self, text, minVal, maxVal, step, valueFormat, disableInCombat, textColor)
	local slider = CreateSubControl(self, "Slider", text, "OptionsSliderTemplate", disableInCombat)
	slider:SetWidth(200)
	slider:SetMinMaxValues(minVal or 0, maxVal or 1)
	slider:SetValueStep(step or 1)
	slider.valueFormat = type(valueFormat) == "string" and valueFormat or "%d"

	if type(textColor) == "table" then
		slider.defaultColor = textColor
	end

	slider.text:ClearAllPoints()
	slider.text:SetPoint("BOTTOMLEFT", slider, "TOPLEFT")

	slider.value = slider:CreateFontString(slider:GetName().."Value", "ARTWORK", "GameFontGreen")
	slider.value:SetPoint("BOTTOMRIGHT", slider, "TOPRIGHT")

	slider.low = getglobal(slider:GetName().."Low")
	slider.low:ClearAllPoints()
	slider.low:SetPoint("TOPLEFT", slider, "BOTTOMLEFT", 0, 2)
	slider.low:SetText(format(slider.valueFormat, minVal or 0))

	slider.high = getglobal(slider:GetName().."High")
	slider.high:ClearAllPoints()
	slider.high:SetPoint("TOPRIGHT", slider, "BOTTOMRIGHT", 0, 2)
	slider.high:SetText(format(slider.valueFormat, maxVal or 1))

	Slider_OnEnable(slider)
	hooksecurefunc(slider, "Enable", Slider_OnEnable)
	hooksecurefunc(slider, "Disable", Slider_OnDisable)

	slider.OnShow = Slider_OnShow
	ClearAndHook(slider, "OnValueChanged", Slider_OnValueChanged)

	return slider
end

local function CreateSmallSlider(self, text, minVal, maxVal, step, valueFormat, disableInCombat)
	local slider = CreateSlider(self, text, minVal, maxVal, step, valueFormat, disableInCombat, HIGHLIGHT_FONT_COLOR)
	slider:SetWidth(180)
	slider:SetHeight(15)
	slider:SetScale(0.9)
	return slider
end

local VOID_LINE = {}
local function ComboBox_UpdateSelection(self, line, noNotify)
	if not line then
		line = VOID_LINE
	end

	if not line.notCheckable then
		self.dropdown.text:SetText(line.text)
		if self:IsEnabled() then
			self.dropdown.text:SetTextColor(line.r or HIGHLIGHT_FONT_COLOR.r, line.g or HIGHLIGHT_FONT_COLOR.g, line.b or HIGHLIGHT_FONT_COLOR.b)
		else
			self.dropdown.text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
		end

		self.value = line.value
	end

	if not noNotify then
		pcall(self.OnComboChanged, self, line.value, line.text)
	end
	return self.value
end

local function ComboBox_OnSelect(_, self, line)
	ComboBox_UpdateSelection(self, line)
end

local function ComboBox_GetSelection(self)
	return self.value
end

local function ComboBox_SetSelection(self, value, noNotify)
	local line, found
	for _, line in ipairs(self.dropdown.lines) do
		if line.value == value then
			found = line
			break
		end
	end

	return ComboBox_UpdateSelection(self, found, noNotify)
end

local function ComboBox_SetSelectionByPosition(self, position, noNotify)
	if position == -1 then
		position = #self.dropdown.lines
	end

	return ComboBox_UpdateSelection(self, self.dropdown.lines[position], noNotify)
end

local function ComboBox_AddLine(self, text, value, icon, flags, r, g, b, position)
	local line = { text = text, value = value, icon = icon }
	if type(flags) == "string" then
		local symbols = { strsplit(",", flags) }
		local flag
		for _, flag in ipairs(symbols) do
			flag = strtrim(flag)
			if flag ~= "" then
				line[flag] = 1
			end
		end

	elseif type(flags) == "number" then
		if flags == 1 then
			line.isTitle = 1
		elseif flags == 2 then
			line.disabled = 1
		elseif flags == 3 then
			line.notClickable = 1
		elseif flags == 4 then
			line.notCheckable = 1
		end
	end

	if type(r) == "number" and type(g) == "number" and type(b) == "number" then
		line.r, line.g, line.b = r, g, b
		line.colorCode = format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
	end

	if type(position) == "number" then
		tinsert(self.dropdown.lines, position, line)
	else
		tinsert(self.dropdown.lines, line)
	end

	return line
end

local function ComboBox_DeleteLine(self, value, noNotify)
	local i, line
	for i, line in ipairs(self.dropdown.lines) do
		if line.value == value then
			tremove(self.dropdown.lines, i)
			if self.value == value then
				self.value = nil
				self.dropdown.text:SetText()
				if not noNotify then
					pcall(self.OnComboChanged, self)
				end
			end
			return 1
		end
	end
end

local function ComboBox_ClearLines(self, noNotify)
	wipe(self.dropdown.lines)
	self.value = nil
	self.dropdown.text:SetText()
	if not noNotify then
		pcall(self.OnComboChanged, self)
	end
end

local function ComboBox_NumLines(self)
	return #self.dropdown.lines
end

local function ComboBox_GetValueByPosition(self, position)
	local line = self.dropdown.lines[position]
	if line then
		return line.value
	end
end

local function Dropdown_InitFunc(self)
	local parent = self:GetParent()
	if type(parent.OnMenuRequest) == "function" then
		wipe(self.lines)
		parent:OnMenuRequest()
	end

	local i
	for i = 1, #(self.lines) do
		local line = self.lines[i]
		local data = {}
		local k, v
		for k, v in pairs(line) do
			data[k] = v
		end
		data.checked = not line.notCheckable and parent.value == line.value
		data.func = ComboBox_OnSelect
		data.arg1 = parent
		data.arg2 = line
		UIDropDownMenu_AddButton(data)
	end
end

local function ComboBox_OnShow(self)
	local valid, value = pcall(self.OnComboInit, self)
	if valid then
		ComboBox_SetSelection(self, value, 1)
	end
end

local function ComboBox_OnClick(self)
	self.toggleButton:Click()
end

local function ComboBox_OnEnable(self)
	self.toggleButton:Enable()
	local textColor = self.defaultColor or NORMAL_FONT_COLOR
	self.text:SetTextColor(textColor.r, textColor.g, textColor.b)
	ComboBox_SetSelection(self, self.value, 1)
end

local function ComboBox_OnDisable(self)
	self.toggleButton:Disable()
	self.text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
	ComboBox_SetSelection(self, self.value, 1)
end

local function CreateComboBox(self, text, horizontal, disableInCombat, textColor)
	local frame = CreateSubControl(self, "Button", nil, nil, disableInCombat)
	frame:SetWidth(160)
	frame:SetHeight(26)
	frame:SetMotionScriptsWhileDisabled(true)
	frame.borderFrame = CreatePanel(self, frame)

	local dropdown = CreateFrame("Frame", frame:GetName().."Dropdown", frame, "UIDropDownMenuTemplate")
	dropdown:SetAllPoints(frame)
	local name = dropdown:GetName()
	getglobal(name.."Left"):Hide()
	getglobal(name.."Middle"):Hide()
	getglobal(name.."Right"):Hide()

	local button = getglobal(name.."Button")
	frame.toggleButton = button
	button:ClearAllPoints()
	button:SetPoint("RIGHT")
	button:SetMotionScriptsWhileDisabled(true)

	if type(textColor) == "table" then
		frame.defaultColor = textColor
	end

	dropdown.text = getglobal(name.."Text")
	dropdown.text:SetJustifyH("LEFT")
	dropdown.text:ClearAllPoints()
	dropdown.text:SetPoint("LEFT", 8, 0)
	dropdown.text:SetPoint("RIGHT", button, "LEFT")

	frame.dropdown = dropdown
	frame.text = frame:CreateFontString(name.."Label", "ARTWORK", "GameFontNormalLeft")
	frame.text:SetText(text)


	if type(horizontal) == "number" and horizontal > 10 then
		frame.text:SetWidth(horizontal)
	end

	if horizontal then
		frame.text:SetPoint("RIGHT", frame, "LEFT", -2, 0)
	else
		frame.text:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, 2)
	end

	dropdown.lines = {}
	dropdown.displayMode = "MENU"
	dropdown.point, dropdown.relativeTo, dropdown.relativePoint, dropdown.xOffset, dropdown.yOffset = "TOPLEFT", frame, "BOTTOMLEFT", 0, 3
	UIDropDownMenu_Initialize(dropdown, Dropdown_InitFunc)
	ComboBox_OnEnable(frame)

	frame:SetScript("OnClick", ComboBox_OnClick)
	hooksecurefunc(frame, "Enable", ComboBox_OnEnable)
	hooksecurefunc(frame, "Disable", ComboBox_OnDisable)

	frame.OnShow = ComboBox_OnShow
	frame.ClearLines = ComboBox_ClearLines
	frame.AddLine = ComboBox_AddLine
	frame.NumLines = ComboBox_NumLines
	frame.DeleteLine = ComboBox_DeleteLine
	frame.SetSelection = ComboBox_SetSelection
	frame.SetSelectionByPosition = ComboBox_SetSelectionByPosition
	frame.GetSelection = ComboBox_GetSelection
	frame.GetValueByPosition = ComboBox_GetValueByPosition
	return frame
end

local function EditBox_IsEnabled(self)
	return self.isEnabled
end

local function EditBox_Enable(self)
	local textColor = self.defaultColor or NORMAL_FONT_COLOR
	self.text:SetTextColor(textColor.r, textColor.g, textColor.b)
	self:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	self:EnableMouse(true)
	self:EnableKeyboard(true)
	self.isEnabled = true
end

local function EditBox_Disable(self)
	self:ClearFocus()
	self.text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
	self:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
	self:EnableMouse(false)
	self:EnableKeyboard(false)
	self.isEnabled = nil
end

local function EditBox_OnEditFocusGained(self)
	self:HighlightText()
	self.__contentsNeedCommit = 1
end

local function EditBox_OnEditFocusLost(self)
	self:HighlightText(0, 0)
	if self.__contentsNeedCommit and type(self.OnTextCancel) == "function" then
		local newText = self:OnTextCancel()
		if newText then
			self:SetText(newText)
		end
	end
end

local function EditBox_OnEnterPressed(self)
	if self:IsMultiLine() then
		if IsShiftKeyDown() or IsControlKeyDown() or IsAltKeyDown() then
			self:Insert("\n")
			return
		end
	end

	local text = self:GetText()

	local abort, newText
	if type(self.OnTextValidate) == "function" then
		abort, newText = self:OnTextValidate(text)
		if newText then
			text = newText
			self:SetText(text)
		end
	end

	if abort then
		self:HighlightText()
	elseif type(self.OnTextCommit) == "function" then
		self:OnTextCommit(text)
		self.__contentsNeedCommit = nil
		self:ClearFocus()
	end
end

local function EditBox_OnEscapePressed(self)
	self:ClearFocus()
end

local function CreateEditBox(self, text, horizontal, disableInCombat, textColor)
	local editbox = CreateSubControl(self, "EditBox", nil, nil, disableInCombat)
	editbox:SetAutoFocus(false)
	editbox:SetWidth(144)
	editbox:SetHeight(26)
	editbox:SetTextInsets(6, 6, 7, 7)
	editbox:SetFontObject("GameFontHighlight")
	editbox.borderFrame = CreatePanel(self, editbox)

	if type(textColor) == "table" then
		editbox.defaultColor = textColor
	end

	editbox.text = editbox:CreateFontString(editbox:GetName().."Label", "ARTWORK", "GameFontNormalLeft")
	editbox.text:SetText(text)

	if editbox.defaultColor then
		editbox.text:SetTextColor(editbox.defaultColor.r, editbox.defaultColor.g, editbox.defaultColor.b)
	end

	if type(horizontal) == "number" and horizontal > 10 then
		editbox.text:SetWidth(horizontal)
	end

	if horizontal then
		editbox.text:SetPoint("RIGHT", editbox, "LEFT", -2, 0)
	else
		editbox.text:SetPoint("BOTTOMLEFT", editbox, "TOPLEFT", 0, 2)
	end

	EditBox_Enable(editbox)

	editbox:SetScript("OnEnterPressed", EditBox_OnEnterPressed)
	editbox:SetScript("OnEscapePressed", EditBox_OnEscapePressed)
	editbox:SetScript("OnEditFocusGained", EditBox_OnEditFocusGained)
	editbox:SetScript("OnEditFocusLost", EditBox_OnEditFocusLost)

	editbox.IsEnabled = EditBox_IsEnabled
	editbox.Enable = EditBox_Enable
	editbox.Disable = EditBox_Disable
	editbox.CommitText = EditBox_OnEnterPressed

	return editbox
end

local function CreateRoundButton(self, name, parent, icon, text, disableInCombat)
	local button = CreateFrame("Button", name, parent)
	button:SetSize(31, 31)
	button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

	button:SetScript("OnEnter", SubControl_OnEnter)
	button:SetScript("OnLeave", SubControl_OnLeave)

	local border = button:CreateTexture(name and name.."Border", "OVERLAY")
	border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
	border:SetSize(53, 53)
	border:SetPoint("TOPLEFT")

	button.icon = button:CreateTexture(name and name.."Icon", "ARTWORK")
	button.icon:SetSize(20, 20)
	button.icon:SetPoint("CENTER", 0, 1)
	button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	button.icon:SetTexture(icon)

	button.text = button:CreateFontString(name and name.."Text", "ARTWORK", "GameFontHighlight")
	button.text:SetPoint("LEFT", button, "RIGHT", 1, 0)
	button.text:SetFont(STANDARD_TEXT_FONT, 13)
	button.text:SetText(text)

	if disableInCombat then
		AddCombatDisableItem(self, button)
	end

	return button
end

local function AnchorToTopLeft(self, control, xOffset, yOffset)
	if type(control) == "table" and type(control.ClearAllPoints) == "function" then
		control:ClearAllPoints()
		control:SetPoint("TOPLEFT", self.subTitle, "BOTTOMLEFT", (xOffset or 0), (yOffset or 0) - 12)
	end
end

local function Toggle(self)
	if self:IsShown() then
		self:Hide()
	else
		self:Show()
	end
end

local function OpenInterfaceOptionPage(self)
	InterfaceOptionsFrame_OpenToCategory(self)
	InterfaceOptionsFrame_OpenToCategory(self)
end

local DIALOG_STYLES = {
	TITLE_DIALOG = function(self)
		self:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", tile = true, tileSize = 32, edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", edgeSize = 32, insets = {left = 11, right = 12, top = 12, bottom = 11 }, })
		self.title:SetPoint("TOP", 0, 1)

		-- this style needs a dialog header
		if not self.headerTexture then
			self.headerTexture = self:CreateTexture(nil, "ARTWORK")
			self.headerTexture:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
			self.headerTexture:SetHeight(62)
			self.headerTexture:SetPoint("TOP", 1, 13)

			-- Set text will also need to resize header texture
			self.title.parent = self
			hooksecurefunc(self.title, "SetText", function(self)
				self.parent.headerTexture:SetWidth(self:GetWidth() + 200)
			end)

			self.title:SetText(self.title:GetText())
		end

		self.headerTexture:Show()
	end,

	DIALOG = function(self)
		self:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", tile = true, tileSize = 32, edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", edgeSize = 32, insets = {left = 11, right = 12, top = 12, bottom = 11 } })
		self.title:SetPoint("TOP", 0, -14)
	end,

	TOOLTIP = function(self)
		self:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", tile = true, tileSize = 16, edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16, insets = {left = 5, right = 5, top = 5, bottom = 5 } })
		self.title:SetPoint("TOP", 0, -10)
	end,

	THIN = function(self)
		self:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", tile = true, tileSize = 16 })
		self.title:SetPoint("TOP", 0, -10)
	end,

	NONE = function(self)
		self:SetBackdrop(nil)
		self.title:SetPoint("TOP", 0, -10)
	end,
}

local function IsHideOnEscape(self)
	local k, v
	for k, v in ipairs(UISpecialFrames) do
		if v == self or v == self:GetName() then
			return k
		end
	end
end

local function SetDialogStyle(self, style, hideOnEscape)
	style = type(style) == "string" and strtrim(strupper(style))
	local func = DIALOG_STYLES[style]
	if not func or style == "NONE" then
		style = nil
		func = DIALOG_STYLES.NONE
	end

	if self.dialogStyle == style then
		return
	end

	self.dialogStyle = style
	local isDialog = type(style) == "string"

	self:SetFrameStrata(isDialog and "DIALOG" or "MEDIUM")
	self:SetMovable(isDialog)
	self:EnableMouse(isDialog)
	self:SetToplevel(isDialog)

	if isDialog and hideOnEscape then
		if not IsHideOnEscape(self) then
			tinsert(UISpecialFrames, self:GetName())
		end
	else
		local id = IsHideOnEscape(self)
		if id then
			tremove(UISpecialFrames, id)
		end
	end

	if isDialog then
		self:SetUserPlaced(false)
		self:SetDontSavePosition(true)
		self:RegisterForDrag("LeftButton")
		self:SetScript("OnDragStart", self.StartMoving)
		self:SetScript("OnDragStop", self.StopMovingOrSizing)

		if not self.topClose then
			self.topClose = CreateFrame("Button", nil, self, "UIPanelCloseButton")
			self.topClose:SetWidth(24)
			self.topClose:SetHeight(24)
			self.topClose:SetPoint("TOPRIGHT", -5, -5)
		end
		self.topClose:Show()
	else
		self:SetScript("OnDragStart", nil)
		self:SetScript("OnDragStop", nil)

		if self.topClose then
			self.topClose:Hide()
		end
	end

	if self.headerTexture then
		self.headerTexture:Hide()
	end

	self.title:ClearAllPoints()
	func(self)
end

local function Frame_OnSizeChanged(self, x, y)
	self.subTitle:SetWidth(x - 40)
end

function UICreateInterfaceOptionPage(name, title, subTitle, categoryParent, parentFrame)
	if type(name) ~= "string" then
		error(format("bad argument #1 to 'UICreateInterfaceOptionPage' (string expected, got %s)", type(name)))
		return
	end

	if type(title) ~= "string" then
		error(format("bad argument #2 to 'UICreateInterfaceOptionPage' (string expected, got %s)", type(title)))
		return
	end

	if subTitle ~= nil and type(subTitle) ~= "string" then
		error(format("bad argument #3 to 'UICreateInterfaceOptionPage' (nil or string expected, got %s)", type(subTitle)))
		return
	end

	if parentFrame and categoryParent ~= nil and type(categoryParent) ~= "string" then
		error(format("bad argument #4 to 'UICreateInterfaceOptionPage' (nil or string expected, got %s)", type(categoryParent)))
		return
	end

	local page = CreateFrame("Frame", name, parentFrame)
	page:Hide()

	page.title = page:CreateFontString(name.."Title", "ARTWORK", "GameFontNormal")
	page.title:SetText(title)
	page.title:SetJustifyV("TOP")
	page.title:SetPoint("TOPLEFT", 16, -16)

	page.subTitle = page:CreateFontString(name.."SubTitle", "ARTWORK", "GameFontHighlightSmallLeftTop")
	page.subTitle:SetPoint("TOPLEFT", 16, -38)
	page.subTitle:SetWidth(500)
	page.subTitle:SetNonSpaceWrap(true)
	page.subTitle:SetText(subTitle)

	if parentFrame then
		page.SetDialogStyle = SetDialogStyle
		page.Open = page.Show
		page.Toggle = Toggle
	else
		-- Inject to Blizzard UI option
		page.name = title
		page.parent = categoryParent
		InterfaceOptions_AddCategory(page)
		page.Open = OpenInterfaceOptionPage
	end

	page:HookScript("OnShow", SubControl_OnShow)
	page:HookScript("OnSizeChanged", Frame_OnSizeChanged)
	page.GetNextControlName = GetNextControlName
	page.CreateSubControl = CreateSubControl
	page.CreatePressButton = CreatePressButton
	page.CreateCheckButton = CreateCheckButton
	page.CreateMultiSelectionGroup = CreateMultiSelectionGroup
	page.CreateSingleSelectionGroup = CreateSingleSelectionGroup
	page.CreateSlider = CreateSlider
	page.CreateSmallSlider = CreateSmallSlider
	page.CreateComboBox = CreateComboBox
	page.CreateEditBox = CreateEditBox
	page.AnchorToTopLeft = AnchorToTopLeft
	page.AddCombatDisableItem = AddCombatDisableItem
	page.CreatePanel = CreatePanel
	page.CreateRoundButton = CreateRoundButton

	return page
end

-- Provides version check
function UICreateInterfaceOptionPage_IsNewerVersion(major, minor)
	if type(major) ~= "number" or type(minor) ~= "number" then
		return false
	end

	if major > MAJOR_VERSION then
		return true
	elseif major < MAJOR_VERSION then
		return false
	else -- major equal, check minor
		return minor > MINOR_VERSION
	end
end