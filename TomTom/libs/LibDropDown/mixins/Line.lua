--[[ Line:header
Documentation for the [Line](Line) object.
Created with [LibDropDown:CreateLine()](LibDropDown#libdropdowncreatelinemenu).
--]]
local lib = LibStub('LibDropDown')

local function OnShow(self)
	if(self.checked) then
		if(self.isRadio) then
			self:SetRadioState(self:checked())
		else
			self:SetCheckedState(self:checked())
		end
	end
end

local function OnEnter(self)
	-- hide all submenues for the current menu
	for _, Menu in next, self:GetParent().menus do
		Menu:Hide()
	end

	if(self.Expand:IsShown()) then
		-- show this line's submenu
		self.Menu:Show()
	end

	self.Highlight:Show()

	if(self.tooltip) then
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')

		if(self.tooltipTitle) then
			GameTooltip:AddLine(self.tooltipTitle, 1, 1, 1)
		end

		GameTooltip:AddLine(self.tooltip, nil, nil, nil, true)
		GameTooltip:Show()
	end
end

local function OnLeave(self)
	self.Highlight:Hide()

	if(self.tooltip) then
		GameTooltip:Hide()
	end
end

local function OnClick(self, button)
	if(self.ColorSwatch:IsShown()) then
		ColorPickerFrame.func = function()
			local r, g, b = ColorPickerFrame:GetColorRGB()
			local a = ColorPickerFrame.hasOpacity and (1 - OpacitySliderFrame:GetValue()) or 1
			self.colorPickerCallback(CreateColor(r, g, b , a))
		end

		ColorPickerFrame.opacityFunc = ColorPickerFrame.func
		ColorPickerFrame.cancelFunc = function()
			self.colorPickerCallback(self.colors)
		end

		local r, g, b, a = self.colors:GetRGBA()
		ColorPickerFrame.hasOpacity = not not a
		ColorPickerFrame.opacity = a
		-- BUG: ColorSelect not reacting to SetColorRGB in build 24015
		ColorPickerFrame:SetColorRGB(r, g, b)

		ShowUIPanel(ColorPickerFrame)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	else
		pcall(self.func, self, button, unpack(self.args or {}))
	end

	if(not self.keepShown) then
		lib:CloseAll()
	end
end

local lineMixin = {}
--[[ Line:SetRadioState(_state_)
Sets the state of a radio button.

* `state`: Enables/disables a radio button _(boolean)_
--]]
function lineMixin:SetRadioState(state)
	self.Radio.state = state

	if(state) then
		self.Radio:SetTexCoord(0, 0.5, 0.5, 1)
	else
		self.Radio:SetTexCoord(0.5, 1, 0.5, 1)
	end
end

--[[ Line:GetRadioState()
Returns the current boolean state of a radio button.
--]]
function lineMixin:GetRadioState()
	return self.Radio.state
end

--[[ Line:SetCheckedState(_state_)
Sets the state of a checkbutton.

* `state`: Enables/disables a checkbutton _(boolean)_
--]]
function lineMixin:SetCheckedState(state)
	self.Radio.state = state

	if(state) then
		self.Radio:SetTexCoord(0, 0.5, 0, 0.5)
	else
		self.Radio:SetTexCoord(0.5, 1, 0, 0.5)
	end
end

--[[ Line:GetCheckedState()
Returns the current boolean state of a checkbutton.
--]]
function lineMixin:GetCheckedState()
	return self.Radio.state
end

--[[ Line:SetIcon(_..._)
See [FrameXML/Util.lua's CreateTextureMarkup](https://www.townlong-yak.com/framexml/live/go/CreateTextureMarkup)
--]]
function lineMixin:SetIcon(...)
	local markup = CreateTextureMarkup(...)
	self.__icon = markup .. ' '
	self:UpdateText()
end

--[[ Line:GetIcon()
See [FrameXML/Util.lua's CreateTextureMarkup](https://www.townlong-yak.com/framexml/live/go/CreateTextureMarkup)
--]]
function lineMixin:GetIcon()
	return self.__icon
end

--[[ Line:SetAtlas(_..._)
See [FrameXML/Util.lua's CreateAtlasMarkup](https://www.townlong-yak.com/framexml/live/go/CreateAtlasMarkup)
--]]
function lineMixin:SetAtlas(...)
	local markup = CreateAtlasMarkup(...)
	self.__atlas = markup .. ' '
	self:UpdateText()
end

--[[ Line:GetAtlas()
See [FrameXML/Util.lua's CreateAtlasMarkup](https://www.townlong-yak.com/framexml/live/go/CreateAtlasMarkup)
--]]
function lineMixin:GetAtlas()
	return self.__atlas
end

--[[ Line:SetText(_text_)
Sets the Line text.

* `text` - text to set on the Line _(string)_
--]]
function lineMixin:SetText(text)
	self.Text:SetFormattedText('%s%s', self.__icon or self.__atlas or '', text)
end

--[[ Line:UpdateText()
Updates the Line text.
--]]
function lineMixin:UpdateText()
	local text = self.Text:GetText():gsub('|T.*|t', ''):gsub('|A.*|a', '')
	self.Text:SetText(text)
end

--[[ Line:SetTexture(_texture[, color]_)
Sets the texture (and optional color) on the Line.

* `texture` - texture to set _(string)_
* `color` - color to set _(object)_
--]]
function lineMixin:SetTexture(texture, color)
	self.Texture:SetTexture(texture)
	if(color) then
		self.Texture:SetVertexColor(color:GetRGBA())
	else
		self.Texture:SetVertexColor(1, 1, 1, 1)
	end

	self.Texture:Show()
end

--[[ Line:Reset()
Resets the state of the Line back to default.  
Is called at the start of [Menu:UpdateLine()](Menu#menuupdatelineindexdata).
--]]
function lineMixin:Reset()
	self.checked = nil
	self.isRadio = nil
	self.__icon = nil
	self.__atlas = nil

	self.Texture:Hide()
	self.Highlight:Hide()
	self.Radio:Hide()
	self.Expand:Hide()
	self.Spacer:Hide()
	self.ColorSwatch:Hide()

	self.Text:SetText('')
end

--[[ LibDropDown:CreateLine(_Menu_)
Creates and returns a new [Line](Line) object for the given [Menu](Menu).

* `Menu` - [Menu](Menu) object to parent the new [Line](Line) _(object)_
--]]
function lib:CreateLine(Menu)
	local Line = Mixin(CreateFrame('Button', nil, Menu), lineMixin)
	Line:SetSize(1, 16)
	Line:SetScript('OnShow', OnShow)
	Line:SetScript('OnEnter', OnEnter)
	Line:SetScript('OnLeave', OnLeave)
	Line:SetScript('OnClick', OnClick)
	Line:SetFrameLevel(Menu:GetFrameLevel() + 2)
	Line.parent = Menu.parent

	Line:SetNormalFontObject(Menu.parent.normalFont or 'GameFontHighlightSmallLeft')
	Line:SetHighlightFontObject(Menu.parent.highlightFont or 'GameFontHighlightSmallLeft')
	Line:SetDisabledFontObject(Menu.parent.disabledFont or 'GameFontDisableSmallLeft')

	local Texture = Line:CreateTexture('$parentTexture', 'BACKGROUND')
	Texture:SetAllPoints()
	Line.Texture = Texture

	local Highlight = Line:CreateTexture('$parentHighlight', 'BACKGROUND')
	Highlight:SetAllPoints()
	Highlight:SetBlendMode('ADD')
	Highlight:SetTexture(Menu.parent.highlightTexture or 'Interface\\QuestFrame\\UI-QuestTitleHighlight')
	Line.Highlight = Highlight

	local Radio = Line:CreateTexture('$parentRadio', 'ARTWORK')
	Radio:SetPoint('RIGHT')
	Radio:SetSize(16, 16)
	Radio:SetTexture(Menu.parent.radioTexture or 'Interface\\Common\\UI-DropDownRadioChecks')
	Line.Radio = Radio

	local Expand = Line:CreateTexture('$parentExpand', 'ARTWORK')
	Expand:SetPoint('RIGHT')
	Expand:SetSize(16, 16)
	Expand:SetTexture(Menu.parent.expandTexture or 'Interface\\ChatFrame\\ChatFrameExpandArrow')
	Line.Expand = Expand

	local Spacer = Line:CreateTexture('$parentSpacer', 'ARTWORK')
	Spacer:SetPoint('LEFT')
	Spacer:SetPoint('RIGHT')
	Spacer:SetSize(1, 1)
	Spacer:SetAlpha(0.5)
	Spacer:SetTexture('Interface\\ChatFrame\\ChatFrameBackground')
	Line.Spacer = Spacer

	local Text = Line:CreateFontString('$parentText', 'ARTWORK', 'GameFontHighlightSmallLeft')
	Text:SetPoint('LEFT')
	Line.Text = Text

	local ColorSwatch = CreateFrame('Button', '$parentColorSwatch', Line)
	ColorSwatch:SetPoint('RIGHT')
	ColorSwatch:SetSize(16, 16)
	Line.ColorSwatch = ColorSwatch

	local ColorSwatchBackground = ColorSwatch:CreateTexture('$parentBackground', 'BACKGROUND')
	ColorSwatchBackground:SetPoint('CENTER')
	ColorSwatchBackground:SetSize(14, 14)
	ColorSwatchBackground:SetColorTexture(1, 1, 1)
	ColorSwatch.Background = ColorSwatchBackground

	local ColorSwatchCheckers = ColorSwatch:CreateTexture('$parentCheckers', 'BACKGROUND')
	ColorSwatchCheckers:SetPoint('CENTER')
	ColorSwatchCheckers:SetSize(14, 14)
	ColorSwatchCheckers:SetTexture('Tileset\\Generic\\Checkers')
	ColorSwatchCheckers:SetTexCoord(0.25, 0, 0.5, 0.25)
	ColorSwatchCheckers:SetDesaturated(true)
	ColorSwatchCheckers:SetVertexColor(1, 1, 1, 0.75)
	ColorSwatch.Checkers = ColorSwatchCheckers

	local ColorSwatchSwatch = ColorSwatch:CreateTexture('$parentSwatch', 'OVERLAY')
	ColorSwatchSwatch:SetPoint('CENTER')
	ColorSwatchSwatch:SetSize(20, 20)
	ColorSwatchSwatch:SetTexture('Interface\\ChatFrame\\ChatFrameColorSwatch')
	ColorSwatch.Swatch = ColorSwatchSwatch

	return Line
end
