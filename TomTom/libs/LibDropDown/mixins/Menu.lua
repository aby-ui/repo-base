--[[ Menu:header
Documentation for the [Menu](Menu) object.
Created with [LibDropDown:NewMenu()](LibDropDown#libdropdownnewmenuparent-name).
--]]
local lib = LibStub('LibDropDown')

local function OnShow(self)
	-- gather some size data
	local padding = self.parent.padding
	local spacing = self.parent.spacing
	local minWidth = self.parent.minWidth
	local maxWidth = self.parent.maxWidth
	local width = 0
	local height = -spacing

	for _, Line in next, self.lines do
		if(Line:IsShown()) then
			local lineWidth
			if(Line.Text:IsShown()) then
				lineWidth = Line.Text:GetWidth()
			else
				lineWidth = Line:GetTextWidth()
			end
			if(Line.Radio:IsShown()) then
				lineWidth = lineWidth + Line.Radio:GetWidth() + padding
			end
			lineWidth = math.max(lineWidth, minWidth)

			if(maxWidth) then
				lineWidth = math.min(lineWidth, maxWidth)
			end

			if(lineWidth > width) then
				width = lineWidth
			end

			height = height + (16 + spacing)
		end
	end

	-- make sure all lines are the same width
	for _, Line in next, self.lines do
		Line:SetWidth(width)
	end

	-- resize the entire frame
	self:SetSize(width, height)
	self.Backdrop:SetSize(width + padding * 2, height + padding * 2)

	-- positioning
	self:ClearAllPoints()
	if(self.parent == self) then
		-- this is the first menu
		if(self.parent.anchorCursor) then
			local x, y = GetCursorPosition()
			local scale = UIParent:GetScale()
			self:SetPoint('TOP', UIParent, 'BOTTOMLEFT', x / scale, (y / scale) + 8) -- 8 to let the cursor end up on the first line
		else
			self:SetPoint(unpack(self.parent.anchor))
		end
	else
		-- submenu
		self:SetPoint('TOPLEFT', self:GetParent(), 'TOPRIGHT', self.parent.gap, 0)
	end
end

local menuMixin = {}
--[[ Menu:Toggle()
Toggles the dropdown menu, closing all others (see [LibDropDown:CloseAll()](LibDropDown#libdropdowncloseall)).
--]]
function menuMixin:Toggle()
	-- hide everything first
	lib:CloseAll(self)

	-- toggle this
	self:SetShown(not self:IsShown())
end

local dummyFontInstance = CreateFont('LibDropDownDummyFontObject')
--[[ Menu:UpdateLine(_index, data_)
Update a line with the given index with the supplied data.

* `index`: menu line index _(integer)_
* `data`: line data _(table)_ (see [Menu:AddLine(_data_)](Menu#menuaddlinedata))
--]]
function menuMixin:UpdateLine(index, data)
	local Line = self.lines[index]
	if(not Line) then
		Line = lib:CreateLine(self)
		Line:SetPoint('TOPLEFT', 0, -((16 + self.parent.spacing) * (index - 1)))
		table.insert(self.lines, Line)
	end

	Line:Reset()

	Line.func = data.func
	Line.args = data.args
	Line.tooltip = data.tooltip
	Line.tooltipTitle = data.tooltipTitle
	Line.keepShown = data.keepShown

	local fontName, fontSize, fontFlags
	if(data.font) then
		fontName = data.font
		fontSize = data.fontSize or 12
		fontFlags = data.fontFlags
	elseif(data.disabled) then
		dummyFontInstance:SetFontObject(data.fontObjectDisabled or self.parent.disabledFont)
		fontName, fontSize, fontFlags = dummyFontInstance:GetFont()
	else
		dummyFontInstance:SetFontObject(data.fontObjectDisabled or self.parent.disabledFont)
		fontName, fontSize, fontFlags = dummyFontInstance:GetFont()
	end

	if(data.isSpacer) then
		Line.Spacer:Show()
		Line:EnableMouse(false)
	elseif(data.isTitle) then
		local text = data.text
		assert(text and type(text) == 'string', 'Missing required data "text"')
		Line.Text:SetText(text)
		Line:EnableMouse(false)
		Line:SetNormalFontObject(self.parent.titleFont)
	else
		Line:EnableMouse(true)

		local text = data.text
		assert(text and type(text) == 'string', 'Missing required data "text"')

		Line.Text:SetFont(fontName, fontSize, fontFlags)
		Line.Text:SetText(text)

		Line:SetTexture(data.texture, data.textureColor)

		if(data.icon) then
			local width = data.iconWidth or 16
			local height = data.iconHeight or 16
			local fileWidth = data.iconFileWidth or width
			local fileHeight = data.iconFileHeight or height

			local left, right, top, bottom = 0, 1, 0, 1
			if(data.iconTexCoords) then
				left, right, top, bottom = unpack(data.iconTexCoords)
			end

			Line:SetIcon(data.icon, fileWidth, fileHeight, width, height, left, right, top, bottom)
		end

		if(data.atlas) then
			local atlas = C_Texture.GetAtlasInfo(data.atlas)
			assert(atlas and (atlas.filename or atlas.file), 'No atlas \'' .. data.atlas .. '\' exists')

			local width = data.atlasWidth
			local height = data.atlasHeight

			if(not height) then
				-- default to line height
				height = 16
			end

			if(not width) then
				-- keeping aspect ratio of the atlas
				width = (atlas.width / atlas.height) * height
			end

			local x = data.atlasOffsetX or data.atlasOffset or 0
			local y = data.atlasOffsetY or data.atlasOffset or 0

			Line:SetAtlas(data.atlas, height, width, x, y)
		end

		if(data.disabled) then
			Line:Disable()
			Line:SetMotionScriptsWhileDisabled(not not data.forceMotion)
		else
			Line:Enable()
		end

		if(data.menu) then
			Line.Expand:Show()
		else
			if(data.isColorPicker) then
				local r, g, b, a = data.colorR, data.colorG, data.colorB, data.colorOpacity
				local callback = data.colorPickerCallback
				assert(r and type(r) == 'number', 'Missing required data "colorR"')
				assert(g and type(g) == 'number', 'Missing required data "colorG"')
				assert(b and type(b) == 'number', 'Missing required data "colorB"')
				assert(callback and type(callback) == 'function', 'Missing required data "colorPickerCallback"')

				if(not Line.colors) then
					Line.colors = CreateColor(r, g, b, a)
				else
					Line.colors:SetRGBA(r, g, b, a)
				end

				Line.colorPickerCallback = callback
				Line.ColorSwatch.Swatch:SetVertexColor(r, g, b, a or 1)
				Line.ColorSwatch:Show()
			else
				if(data.checked ~= nil) then
					Line.Radio:Show()

					if(type(data.checked) == 'function') then
						Line.checked = data.checked
						Line.isRadio = data.isRadio
					else
						if(data.isRadio) then
							Line:SetRadioState(not not data.checked)
						else
							Line:SetCheckedState(not not data.checked)
						end
					end

					if self.parent.checkButtonAlignment == 'LEFT' then
						Line.Radio:ClearAllPoints()
						Line.Radio:SetPoint('LEFT', Line)
						Line.Text:ClearAllPoints()
						Line.Text:SetPoint('LEFT', Line.Radio, 'RIGHT')
					else
						Line.Radio:ClearAllPoints()
						Line.Radio:SetPoint('RIGHT')
						Line.Text:ClearAllPoints()
						Line.Text:SetPoint('LEFT')
					end
				end
			end
		end

		-- TODO: slider
		-- TODO: editbox
		-- TODO: scrolling
	end

	Line:Show()
	return Line
end

--[[ Menu:AddLines(_..._)
See [Menu:AddLine(_data_)](Menu#menuaddlinedata), this one does the exact same thing, except  
this one can add more than one line at a time.

* `...`: One or more tables containing line information.
--]]
function menuMixin:AddLines(...)
	for index = 1, select('#', ...) do
		self:AddLine(select(index, ...))
	end
end

--[[ Menu:AddLine(_data_)
Adds a line using the given data to the menu menu.  
Everything™ is optional, some are exclusive with others.

* `data`:
	* `text`: Text to show on the line _(string)_
	* `isTitle`: Turns the `text` into a title _(boolean)_
	* `isSpacer`: Turns the line into a spacer _(boolean)_
	* `func`: Function to execute when clicking the line _(function)_  
		Arguments passed: `button`, `args` (unpacked).
	* `keepShown`: Keeps the dropdown shown after clicking the line _(boolean)_
	* `args`: Table of arguments to pass through to the click function _(table)_
	* `tooltip`: Tooltip contents _(string)_
	* `tooltipTitle`: Tooltip title _(string)_
	* `tooltipWhileDisabled`: Enable tooltips while disabled _(boolean)_
	* `checked`: Show or hide a checkbox _(boolean/function)_
	* `isRadio`: Turns the checkbox into a radio button _(boolean)_
	* `isColorPicker`: Adds a color picker to the line _(boolean)_
	* `colorR`: Red color channel, 0-1 _(number)_
	* `colorG`: Green color channel, 0-1 _(number)_
	* `colorB`: Blue color channel, 0-1 _(number)_
	* `colorOpacity`: Alpha channel, 0-1 _(number)_
	* `colorPickerCallback`: Callback function for the color picker _(function)_  
		Arguments passed: `color`, see [SharedXML\Util.lua's ColorMixin](https://www.townlong-yak.com/framexml/live/go/ColorMixin).
	* `icon`: Texture path for the icon to embed into the start of `text` _(string)_
	* `iconTexCoords`: Texture coordinates for cropping the `icon` _(array)_
	* `iconWidth`: Width of the displayed `icon` _(number)_
	* `iconHeight`: Height of the displayed `icon` _(number)_
	* `iconFileWidth`: File width of the `icon` _(number)_
	* `iconFileHeight`: File height of the `icon` _(number)_
	* `atlas`: Atlas to embed into the start of `text` _(string)_
	* `atlasWidth`: Width of the displayed `atlas` _(number)_
	* `atlasHeight`: Height of the displayed `atlas` _(number)_
	* `atlasOffsetX`: Horizontal offset for `atlas` _(number)_
	* `atlasOffsetY`: Vertical offset for `atlas` _(number)_
	* `atlasOffset`: Common offset for both axis for `atlas` _(number)_
	* `disabled`: Disables the whole line _(boolean)_
	* `texture`: Sets background texture that spans the line _(string)_
	* `textureColor`: Sets the color of the background texture _([ColorMixin object](https://www.townlong-yak.com/framexml/live/go/ColorMixin))_
	* `font`: Font to use for the line _(string)_
	* `fontSize`: Font size to use for the line, requires `font` to be set _(number)_
	* `fontFlags`: Font flags to use for the line, requires `font` to be set _(string)_
	* `fontObject`: Font object to use for the line _(string/[FontInstance](http://wowprogramming.com/docs/widgets/FontInstance))_
	* `menu`: Sub-menu for the current menu line _(array)_  
		This needs to contain one or more tables of `data` (all of the above) in an  
		indexed array. Can be chained.

#### Notes

The following are exclusive options, only one can be used at a time:

* `isSpacer`
* `isTitle`
* `menu`
* `isColorPicker`
* `checked`
* `font`
* `fontObject`
--]]
function menuMixin:AddLine(data)
	if(not self.data) then
		self.data = {}
	end

	table.insert(self.data, data)
	local Line = self:UpdateLine(#self.data, data)

	if(data.menu) then
		local Menu = lib:NewMenu(Line)
		Menu:AddLines(unpack(data.menu))

		if(#data.menu == 0) then
			error('Sub-menu created but no entries found.')
		end

		table.insert(self.menus, Menu)
		Line.Menu = Menu
	else
		Line.Menu = nil
	end
end

--[[ Menu:RemoveLine(_index_)
Removes a specific line by index.

- `index`: Number between 1 and [Menu:NumLines()](Menu#menunumlines)
--]]
function menuMixin:RemoveLine(index)
	assert(index >= 1 and index <= self:NumLines(), 'index out of scope')
	table.remove(self.data, index)
	self.lines[index]:Hide()
end

--[[ Menu:ClearLines()
Removes all lines in the menu.
--]]
function menuMixin:ClearLines()
	if(self.data) then
		table.wipe(self.data)

		for _, Line in next, self.lines do
			Line:Hide()
		end
	end
end

--[[ Menu:NumLines()
Returns the number of lines in the menu.
--]]
function menuMixin:NumLines()
	return #self.lines
end

--[[ Menu:SetStyle(_name_)
Sets the active style for all menus related to this one.

- `name`: Name of registered style (see [LibDropDown:RegisterStyle](LibDropDown#libdropdownregisterstyle))
--]]
function menuMixin:SetStyle(name)
	if(not name) then
		name = self.parent.style or 'DEFAULT'
	elseif(not lib.styles[name]) then
		error('Style "' .. name .. '" does not exist.')
	end

	self.parent.style = name

	local data = lib.styles[name]
	self.parent.spacing = data.spacing or 0
	self.parent.padding = data.padding or 10
	self.parent.minWidth = data.minWidth or 100
	self.parent.maxWidth = data.maxWidth
	self.parent.gap = data.gap or 10
	self.parent.normalFont = data.normalFont or 'GameFontHighlightSmallLeft'
	self.parent.highlightFont = data.highlightFont or self.parent.normalFont
	self.parent.disabledFont = data.disabledFont or 'GameFontDisableSmallLeft'
	self.parent.titleFont = data.titleFont or 'GameFontNormal'
	self.parent.radioTexture = data.radioTexture or [[Interface\Common\UI-DropDownRadioChecks]]
	self.parent.highlightTexture = data.highlightTexture or [[Interface\QuestFrame\UI-QuestTitleHighlight]]
	self.parent.expandTexture = data.expandTexture or [[Interface\ChatFrame\ChatFrameExpandArrow]]
	self.parent.checkButtonAlignment = data.checkButtonAlignment or 'RIGHT'

	self.Backdrop:SetBackdrop(data.backdrop)
	self.Backdrop:SetBackdropColor((data.backdropColor or HIGHLIGHT_FONT_COLOR):GetRGBA())
	self.Backdrop:SetBackdropBorderColor((data.backdropBorderColor or HIGHLIGHT_FONT_COLOR):GetRGBA())
end

--[[ Menu:GetStyle()
Returns the name of the active style for the menu (and child menus).
--]]
function menuMixin:GetStyle()
	return self.parent.style
end

--[[ Menu:SetAnchor(_point, anchor, relativePoint, x, y_)
Replaces the default anchor with a custom one.
Exact same parameters as in [Widgets:SetPoint](http://wowprogramming.com/docs/widgets/Region/SetPoint), read that documentation instead.
--]]
function menuMixin:SetAnchor(point, anchor, relativePoint, x, y)
	self.parent.anchor[1] = point
	self.parent.anchor[2] = anchor
	self.parent.anchor[3] = relativePoint
	self.parent.anchor[4] = x
	self.parent.anchor[5] = y
end

--[[ Menu:GetAnchor()
Returns the point data for the registered anchor (see [Widgets:GetPoint](http://wowprogramming.com/docs/widgets/Region/GetPoint)).
--]]
function menuMixin:GetAnchor()
	return unpack(self.parent.anchor)
end

--[[ Menu:SetAnchorCursor(_state_)
Allows the anchor to be overridden and places the menu on the cursor.

* `state`: Enables/disables cursor anchoring _(boolean)_
--]]
function menuMixin:SetAnchorCursor(state)
	self.parent.anchorCursor = state
end

--[[ Menu:IsAnchorCursor()
Returns the boolean state of whether the menu should be anchored to the cursor or not.
--]]
function menuMixin:IsAnchorCursor()
	return self.parent.anchorCursor
end

--[[ Menu:SetCheckAlignment(_alignment_)
Sets the alignment of check/radio buttons within the menu.

* `alignment`: Either "LEFT" or "RIGHT" (default) _(string)_
--]]
function menuMixin:SetCheckAlignment(alignment)
	if alignment == 'LEFT' or alignment == 'RIGHT' then
		self.parent.checkButtonAlignment = alignment
	end
end

--[[ LibDropDown:NewMenu(_parent_, _name_)
Creates and returns a new, empty dropdown [Menu](Menu).

* `parent`: Frame for parenting. _(frame/string)_
* `name`: Global name for the menu. Falls back to `parent` name with suffix. _(string)_
--]]
function lib:NewMenu(parent, name)
	assert(parent, 'A menu requires a given parent')

	if(type(parent) == 'string') then
		parent = _G[parent]
	end

	local Menu = Mixin(CreateFrame('Button', (name or parent:GetDebugName() .. 'Menu'), parent), menuMixin, CallbackRegistryMixin)
	Menu:Hide()
	Menu:EnableMouse(true)
	Menu:SetClampedToScreen(true)
	Menu:SetScript('OnShow', OnShow)

	local Backdrop = CreateFrame('Frame', '$parentBackdrop', Menu, 'BackdropTemplate')
	Backdrop:SetPoint('CENTER')
	Menu.Backdrop = Backdrop

	Menu.parent = parent.parent or Menu
	Menu.lines = {}
	Menu.menus = {}

	Menu:SetStyle()

	table.insert(UIMenus, Menu:GetDebugName())

	Menu.anchor = {'TOP', Menu:GetParent(), 'BOTTOM', 0, -12} -- 8, 22
	Menu.anchorCursor = false
	Menu:SetClampRectInsets(-20, 20, 20, -20)

	lib.dropdowns[Menu] = true
	return Menu
end
