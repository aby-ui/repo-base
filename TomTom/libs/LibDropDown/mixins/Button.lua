--[[ Button:header
Documentation for the [Button](Button) object.
Created with [LibDropDown:NewButton()](LibDropDown#libdropdownnewbuttonparent-name).

For all intents and purposes, this is the equivalent to [UIDropDownMenuButtonTemplate](https://www.townlong-yak.com/framexml/live/go/UIDropDownMenuButtonTemplate).
--]]
local lib = LibStub('LibDropDown')

local function OnEnter(self)
	local script = self:GetParent():GetScript('OnEnter')
	if(script) then
		script(self:GetParent())
	end
end

local function OnLeave(self)
	local script = self:GetParent():GetScript('OnLeave')
	if(script) then
		script(self:GetParent())
	end
end

local function OnClick(self)
	self:GetParent():Toggle()
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
end

local function OnHide()
	lib:CloseAll()
end

local buttonMixin = {}
--[[ Button:Add(_..._)
See [Menu:AddLines()](Menu#menuaddlines).
--]]
function buttonMixin:Add(...)
	self.Menu:AddLines(...)
end

--[[ Button:Remove(_..._)
See [Menu:RemoveLine()](Menu#menuremoveline).
--]]
function buttonMixin:Remove(...)
	self.Menu:RemoveLine(...)
end

--[[ Button:Clear()
See [Menu:ClearLines()](Menu#menuclearlines)
--]]
function buttonMixin:Clear()
	self.Menu:ClearLines()
end

--[[ Button:Toggle()
See [Menu:Toggle()](Menu#menutoggle).
--]]
function buttonMixin:Toggle()
	self.Menu:Toggle()
end

--[[ Button:SetAnchor(_..._)
See [Menu:SetAnchor(_point, anchor, relativePoint, x, y_)](Menu#menusetanchorpointanchorrelativepointxy).
--]]
function buttonMixin:SetAnchor(...)
	self.Menu:SetAnchor(...)
end

--[[ Button:GetAnchor()
See [Menu:GetAnchor()](Menu#menugetanchor).
--]]
function buttonMixin:GetAnchor()
	return self.Menu:GetAnchor()
end

--[[ Button:SetAnchorCursor(_flag_)
See [Menu:SetAnchorCursor(_flag_)](Menu#menusetanchorcursorflag).
--]]
function buttonMixin:SetAnchorCursor(...)
	self.Menu:SetAnchorCursor(...)
end

--[[ Button:IsAnchorCursor()
See [Menu:IsAnchorCursor()](Menu#menuisanchorcursor).
--]]
function buttonMixin:IsAnchorCursor()
	return self.Menu:IsAnchorCursor()
end

--[[ Button:SetStyle(...)
See [Menu:SetStyle(_name_)](Menu#menusetstylename).
--]]
function buttonMixin:SetStyle(...)
	self.Menu:SetStyle(...)
end

--[[ Button:GetStyle()
See [Menu:GetStyle()](Menu#menugetstyle).
--]]
function buttonMixin:GetStyle()
	return self.Menu:GetStyle()
end

--[[ Button:SetJustifyH(_..._)
See [Widget:SetJustifyH](http://wowprogramming.com/docs/widgets/FontInstance/SetJustifyH).
--]]
function buttonMixin:SetJustifyH(...)
	self.Text:SetJustifyH(...)
end

--[[ Button:GetJustifyH()
See [Widget:GetJustifyH](http://wowprogramming.com/docs/widgets/FontInstance/GetJustifyH).
--]]
function buttonMixin:GetJustifyH()
	return self.Text:GetJustifyH()
end

--[[ Button:SetText(_..._)
See [Widget:SetText](http://wowprogramming.com/docs/widgets/Button/SetText).
--]]
function buttonMixin:SetText(...)
	self.Text:SetText(...)
end

--[[ Button:GetText()
See [Widget:GetText](http://wowprogramming.com/docs/widgets/Button/GetText).
--]]
function buttonMixin:GetText()
	return self.Text:GetText()
end

--[[ Button:SetFormattedText(_..._)
See [Widget:SetFormattedText](http://wowprogramming.com/docs/widgets/Button/SetFormattedText).
--]]
function buttonMixin:SetFormattedText(...)
	self.Text:SetFormattedText(...)
end

--[[ Button:SetCheckAlignment(...)
See [Menu:SetCheckAlignment(...)](Menu#menusetcheckalignment).
--]]
function buttonMixin:SetCheckAlignment(...)
	self.Menu:SetCheckAlignment(...)
end

--[[ LibDropDown:NewButton(_parent[, name]_)
Creates and returns a new menu button object.

* `parent`: parent for the new button _(string|object)_
* `name`: name for the new button _(string, default = derived from parent)_
--]]
function lib:NewButton(parent, name)
	assert(parent, 'A button requres a given parent')

	if(type(parent) == 'string') then
		parent = _G[parent]
	end

	local Button = Mixin(CreateFrame('Frame', (name or parent:GetDebugName() .. 'MenuButton'), parent), buttonMixin, CallbackRegistryMixin)
	Button:SetSize(165, 32)
	Button:SetScript('OnHide', OnHide)
	Button.Menu = lib:NewMenu(Button)

	local Left = Button:CreateTexture('$parentLeft', 'ARTWORK')
	Left:SetPoint('TOPLEFT', 0, 17)
	Left:SetSize(25, 64)
	Left:SetTexture('Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame')
	Left:SetTexCoord(0, 0.1953125, 0, 1)
	Button.Left = Left

	local Right = Button:CreateTexture('$parentRight', 'ARTWORK')
	Right:SetPoint('TOPRIGHT', 0, 17)
	Right:SetSize(25, 64)
	Right:SetTexture('Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame')
	Right:SetTexCoord(0.8046875, 1, 0, 1)
	Button.Right = Right

	local Middle = Button:CreateTexture('$parentMiddle', 'ARTWORK')
	Middle:SetPoint('LEFT', Left, 'RIGHT')
	Middle:SetPoint('RIGHT', Right, 'LEFT')
	Middle:SetSize(115, 64)
	Middle:SetTexture('Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame')
	Middle:SetTexCoord(0.1953125, 0.8046875, 0, 1)
	Button.Middle = Middle

	local Text = Button:CreateFontString('$parentText', 'ARTWORK', 'GameFontHighlightSmall')
	Text:SetPoint('RIGHT', Right, -43, 2)
	Text:SetPoint('LEFT', Left, 27, 2)
	Text:SetSize(0, 10)
	Text:SetWordWrap(false)
	Text:SetJustifyH('RIGHT')
	Button.Text = Text

	local Icon = Button:CreateTexture('$parentIcon', 'OVERLAY')
	Icon:SetPoint('LEFT', 30, 2)
	Icon:SetSize(16, 16)
	Icon:Hide()
	Button.Icon = Icon

	local OpenButton = CreateFrame('Button', '$parentButton', Button)
	OpenButton:SetPoint('TOPRIGHT', Right, -16, -18)
	OpenButton:SetSize(24, 24)
	OpenButton:SetScript('OnEnter', OnEnter)
	OpenButton:SetScript('OnLeave', OnLeave)
	OpenButton:SetScript('OnClick', OnClick)
	OpenButton:SetMotionScriptsWhileDisabled(true)
	OpenButton:SetNormalTexture('Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up')
	OpenButton:GetNormalTexture():SetPoint('RIGHT')
	OpenButton:GetNormalTexture():SetSize(24, 24)
	OpenButton:SetPushedTexture('Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down')
	OpenButton:GetPushedTexture():SetPoint('RIGHT')
	OpenButton:GetPushedTexture():SetSize(24, 24)
	OpenButton:SetDisabledTexture('Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled')
	OpenButton:GetDisabledTexture():SetPoint('RIGHT')
	OpenButton:GetDisabledTexture():SetSize(24, 24)
	OpenButton:SetHighlightTexture('Interface\\Buttons\\UI-Common-MouseHilight')
	OpenButton:GetHighlightTexture():SetPoint('RIGHT')
	OpenButton:GetHighlightTexture():SetSize(24, 24)
	OpenButton:GetHighlightTexture():SetBlendMode('ADD')
	Button.Button = OpenButton

	return Button
end
