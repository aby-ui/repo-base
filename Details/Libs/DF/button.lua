
local DF = _G["DetailsFramework"]

if (not DF or not DetailsFrameworkCanLoad) then
	return
end

local _
local emptyFunction = function() end
local APIButtonFunctions = false

do
	local metaPrototype = {
		WidgetType = "button",
		dversion = DF.dversion
	}

	--check if there's a metaPrototype already existing
	if (_G[DF.GlobalWidgetControlNames["button"]]) then
		--get the already existing metaPrototype
		local oldMetaPrototype = _G[DF.GlobalWidgetControlNames["button"]]
		--check if is older
		if ( (not oldMetaPrototype.dversion) or (oldMetaPrototype.dversion < DF.dversion) ) then
			--the version is older them the currently loading one
			--copy the new values into the old metatable
			for funcName, _ in pairs(metaPrototype) do
				oldMetaPrototype[funcName] = metaPrototype[funcName]
			end
		end
	else
		--first time loading the framework
		_G[DF.GlobalWidgetControlNames["button"]] = metaPrototype
	end
end

local ButtonMetaFunctions = _G[DF.GlobalWidgetControlNames["button"]]

DF:Mixin(ButtonMetaFunctions, DF.SetPointMixin)
DF:Mixin(ButtonMetaFunctions, DF.FrameMixin)
DF:Mixin(ButtonMetaFunctions, DF.TooltipHandlerMixin)
DF:Mixin(ButtonMetaFunctions, DF.ScriptHookMixin)

------------------------------------------------------------------------------------------------------------
--metatables

	ButtonMetaFunctions.__call = function(self)
		local frameWidget = self.widget
		DF:CoreDispatch((frameWidget:GetName() or "Button") .. ":__call()", self.func, frameWidget, "LeftButton", self.param1, self.param2)
	end

------------------------------------------------------------------------------------------------------------
--members

	--tooltip
	local gmember_tooltip = function(object)
		return object:GetTooltip()
	end

	--shown
	local gmember_shown = function(object)
		return object:IsShown()
	end
	--frame width
	local gmember_width = function(object)
		return object.button:GetWidth()
	end

	--frame height
	local gmember_height = function(object)
		return object.button:GetHeight()
	end

	--text
	local gmember_text = function(object)
		return object.button.text:GetText()
	end

	--function
	local gmember_function = function(object)
		return rawget(object, "func")
	end

	--text color
	local gmember_textcolor = function(object)
		return object.button.text:GetTextColor()
	end

	--text font
	local gmember_textfont = function(object)
		local fontface = object.button.text:GetFont()
		return fontface
	end

	--text size
	local gmember_textsize = function(object)
		local _, fontsize = object.button.text:GetFont()
		return fontsize
	end

	--texture
	local gmember_texture = function(object)
		return {object.button:GetNormalTexture(), object.button:GetHighlightTexture(), object.button:GetPushedTexture(), object.button:GetDisabledTexture()}
	end

	--locked
	local gmember_locked = function(object)
		return rawget(object, "is_locked")
	end

	ButtonMetaFunctions.GetMembers = ButtonMetaFunctions.GetMembers or {}
	ButtonMetaFunctions.GetMembers["tooltip"] = gmember_tooltip
	ButtonMetaFunctions.GetMembers["shown"] = gmember_shown
	ButtonMetaFunctions.GetMembers["width"] = gmember_width
	ButtonMetaFunctions.GetMembers["height"] = gmember_height
	ButtonMetaFunctions.GetMembers["text"] = gmember_text
	ButtonMetaFunctions.GetMembers["clickfunction"] = gmember_function
	ButtonMetaFunctions.GetMembers["texture"] = gmember_texture
	ButtonMetaFunctions.GetMembers["locked"] = gmember_locked
	ButtonMetaFunctions.GetMembers["fontcolor"] = gmember_textcolor
	ButtonMetaFunctions.GetMembers["fontface"] = gmember_textfont
	ButtonMetaFunctions.GetMembers["fontsize"] = gmember_textsize
	ButtonMetaFunctions.GetMembers["textcolor"] = gmember_textcolor --alias
	ButtonMetaFunctions.GetMembers["textfont"] = gmember_textfont --alias
	ButtonMetaFunctions.GetMembers["textsize"] = gmember_textsize --alias

	ButtonMetaFunctions.__index = function(object, key)
		local func = ButtonMetaFunctions.GetMembers[key]
		if (func) then
			return func(object, key)
		end

		local alreadyHaveKey = rawget(object, key)
		if (alreadyHaveKey) then
			return alreadyHaveKey
		end

		return ButtonMetaFunctions[key]
	end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

	--tooltip
	local smember_tooltip = function(object, value)
		return object:SetTooltip (value)
	end

	--show
	local smember_show = function(object, value)
		if (value) then
			return object:Show()
		else
			return object:Hide()
		end
	end

	--hide
	local smember_hide = function(object, value)
		if (not value) then
			return object:Show()
		else
			return object:Hide()
		end
	end

	--frame width
	local smember_width = function(object, value)
		return object.button:SetWidth(value)
	end

	--frame height
	local smember_height = function(object, value)
		return object.button:SetHeight(value)
	end

	--text
	local smember_text = function(object, value)
		return object.button.text:SetText(value)
	end

	--function
	local smember_function = function(object, value)
		return rawset(object, "func", value)
	end

	--param1
	local smember_param1 = function(object, value)
		return rawset(object, "param1", value)
	end

	--param2
	local smember_param2 = function(object, value)
		return rawset(object, "param2", value)
	end

	--text color
	local smember_textcolor = function(object, value)
		local value1, value2, value3, value4 = DF:ParseColors(value)
		return object.button.text:SetTextColor(value1, value2, value3, value4)
	end

	--text font
	local smember_textfont = function(object, value)
		return DF:SetFontFace (object.button.text, value)
	end

	--text size
	local smember_textsize = function(object, value)
		return DF:SetFontSize(object.button.text, value)
	end

	--texture
	local smember_texture = function(object, value)
		if (type(value) == "table") then
			local value1, value2, value3, value4 = unpack(value)
			if (value1) then
				object.button:SetNormalTexture(value1)
			end
			if (value2) then
				object.button:SetHighlightTexture(value2, "ADD")
			end
			if (value3) then
				object.button:SetPushedTexture(value3)
			end
			if (value4) then
				object.button:SetDisabledTexture(value4)
			end
		else
			object.button:SetNormalTexture(value)
			object.button:SetHighlightTexture(value, "ADD")
			object.button:SetPushedTexture(value)
			object.button:SetDisabledTexture(value)
		end
		return
	end

	--locked
	local smember_locked = function(object, value)
		if (value) then
			object.button:SetMovable(false)
			return rawset(object, "is_locked", true)
		else
			object.button:SetMovable(true)
			rawset(object, "is_locked", false)
			return
		end
	end

	--text align
	local smember_textalign = function(object, value)
		if (value == "left" or value == "<") then
			object.button.text:SetPoint("left", object.button, "left", 2, 0)
			object.capsule_textalign = "left"

		elseif (value == "center" or value == "|") then
			object.button.text:SetPoint("center", object.button, "center", 0, 0)
			object.capsule_textalign = "center"

		elseif (value == "right" or value == ">") then
			object.button.text:SetPoint("right", object.button, "right", -2, 0)
			object.capsule_textalign = "right"
		end
	end

	ButtonMetaFunctions.SetMembers= ButtonMetaFunctions.SetMembers or {}
	ButtonMetaFunctions.SetMembers["tooltip"] = smember_tooltip
	ButtonMetaFunctions.SetMembers["show"] = smember_show
	ButtonMetaFunctions.SetMembers["hide"] = smember_hide
	ButtonMetaFunctions.SetMembers["width"] = smember_width
	ButtonMetaFunctions.SetMembers["height"] = smember_height
	ButtonMetaFunctions.SetMembers["text"] = smember_text
	ButtonMetaFunctions.SetMembers["clickfunction"] = smember_function
	ButtonMetaFunctions.SetMembers["param1"] = smember_param1
	ButtonMetaFunctions.SetMembers["param2"] = smember_param2
	ButtonMetaFunctions.SetMembers["textcolor"] = smember_textcolor
	ButtonMetaFunctions.SetMembers["textfont"] = smember_textfont
	ButtonMetaFunctions.SetMembers["textsize"] = smember_textsize
	ButtonMetaFunctions.SetMembers["fontcolor"] = smember_textcolor--alias
	ButtonMetaFunctions.SetMembers["fontface"] = smember_textfont--alias
	ButtonMetaFunctions.SetMembers["fontsize"] = smember_textsize--alias
	ButtonMetaFunctions.SetMembers["texture"] = smember_texture
	ButtonMetaFunctions.SetMembers["locked"] = smember_locked
	ButtonMetaFunctions.SetMembers["textalign"] = smember_textalign

	ButtonMetaFunctions.__newindex = function(object, key, value)
		local func = ButtonMetaFunctions.SetMembers[key]
		if (func) then
			return func(object, value)
		else
			return rawset(object, key, value)
		end
	end

------------------------------------------------------------------------------------------------------------
--methods

--functions
	function ButtonMetaFunctions:SetClickFunction(func, param1, param2, clickType)
		if (not clickType or string.find(string.lower(clickType), "left")) then
			if (func) then
				rawset(self, "func", func)
			else
				rawset(self, "func", emptyFunction)
			end

			if (param1 ~= nil) then
				rawset(self, "param1", param1)
			end
			if (param2 ~= nil) then
				rawset(self, "param2", param2)
			end

		elseif (clickType or string.find(string.lower(clickType), "right")) then
			if (func) then
				rawset(self, "funcright", func)
			else
				rawset(self, "funcright", emptyFunction)
			end
		end
	end

--text
	function ButtonMetaFunctions:SetText(text)
		self.button.text:SetText(text)
	end

--text color
	function ButtonMetaFunctions:SetTextColor(...)
		local red, green, blue, alpha = DF:ParseColors(...)
		self.button.text:SetTextColor(red, green, blue, alpha)
	end
	ButtonMetaFunctions.SetFontColor = ButtonMetaFunctions.SetTextColor --alias

--text size
	function ButtonMetaFunctions:SetFontSize(...)
		DF:SetFontSize(self.button.text, ...)
	end

--text font
	function ButtonMetaFunctions:SetFontFace(font)
		DF:SetFontFace(self.button.text, font)
	end

--textures
	function ButtonMetaFunctions:SetTexture(normalTexture, highlightTexture, pressedTexture, disabledTexture)
		if (normalTexture) then
			self.button:SetNormalTexture(normalTexture)
		elseif (type(normalTexture) ~= "boolean") then
			self.button:SetNormalTexture("")
		end

		if (type(highlightTexture) == "boolean") then
			if (highlightTexture and normalTexture and type(normalTexture) ~= "boolean") then
				self.button:SetHighlightTexture(normalTexture, "ADD")
			end
		elseif (highlightTexture == nil) then
			self.button:SetHighlightTexture("")
		else
			self.button:SetHighlightTexture(highlightTexture, "ADD")
		end

		if (type(pressedTexture) == "boolean") then
			if (pressedTexture and normalTexture and type(normalTexture) ~= "boolean") then
				self.button:SetPushedTexture(normalTexture)
			end
		elseif (pressedTexture == nil) then
			self.button:SetPushedTexture("")
		else
			self.button:SetPushedTexture(pressedTexture, "ADD")
		end

		if (type(disabledTexture) == "boolean") then
			if (disabledTexture and normalTexture and type(normalTexture) ~= "boolean") then
				self.button:SetDisabledTexture(normalTexture)
			end
		elseif (disabledTexture == nil) then
			self.button:SetDisabledTexture("")
		else
			self.button:SetDisabledTexture(disabledTexture, "ADD")
		end
	end

--icon
	function ButtonMetaFunctions:GetIconTexture()
		if (self.icon) then
			return self.icon:GetTexture()
		end
	end

	function ButtonMetaFunctions:SetIcon(texture, width, height, layout, texcoord, overlay, textDistance, leftPadding, textHeight, shortMethod)
		if (not self.icon) then
			self.icon = self:CreateTexture(nil, "artwork")
			self.icon:SetSize(self.height * 0.8, self.height * 0.8)
			self.icon:SetPoint("left", self.widget, "left", 4 + (leftPadding or 0), 0)
			self.icon.leftPadding = leftPadding or 0
			self.widget.text:ClearAllPoints()
			self.widget.text:SetPoint("left", self.icon, "right", textDistance or 2, 0 + (textHeight or 0))
		end

		if (type(texture) == "string") then
			local isAtlas = C_Texture.GetAtlasInfo(texture)
			if (isAtlas) then
				self.icon:SetAtlas(texture)

			elseif (DF:IsHtmlColor(texture)) then
				local r, g, b, a = DF:ParseColors(texture)
				self.icon:SetColorTexture(r, g, b, a)
			else
				self.icon:SetTexture(texture)
			end
		elseif (type(texture) == "table") then
			local r, g, b, a = DF:ParseColors(texture)
			self.icon:SetColorTexture(r, g, b, a)
		else
			self.icon:SetTexture(texture)
		end

		self.icon:SetSize(width or self.height * 0.8, height or self.height * 0.8)
		self.icon:SetDrawLayer(layout or "artwork")

		if (texcoord) then
			self.icon:SetTexCoord(unpack(texcoord))
		else
			self.icon:SetTexCoord(0, 1, 0, 1)
		end

		if (overlay) then
			if (type(overlay) == "string") then
				local r, g, b, a = DF:ParseColors(overlay)
				self.icon:SetVertexColor(r, g, b, a)
			else
				self.icon:SetVertexColor(unpack(overlay))
			end
		else
			self.icon:SetVertexColor(1, 1, 1, 1)
		end

		local buttonWidth = self.button:GetWidth()
		local iconWidth = self.icon:GetWidth()
		local textWidth = self.button.text:GetStringWidth()
		if (textWidth > buttonWidth - 15 - iconWidth) then
			if (shortMethod == false) then

			elseif (not shortMethod) then
				local new_width = textWidth + 15 + iconWidth
				self.button:SetWidth(new_width)

			elseif (shortMethod == 1) then
				local loop = true
				local textSize = 11
				while (loop) do
					if (textWidth + 15 + iconWidth < buttonWidth or textSize < 8) then
						loop = false
						break
					else
						DF:SetFontSize(self.button.text, textSize)
						textWidth = self.button.text:GetStringWidth()
						textSize = textSize - 1
					end
				end
			end
		end
	end

--enabled
	function ButtonMetaFunctions:IsEnabled()
		return self.button:IsEnabled()
	end

	function ButtonMetaFunctions:Enable()
		return self.button:Enable()
	end

	function ButtonMetaFunctions:Disable()
		return self.button:Disable()
	end

--exec
	function ButtonMetaFunctions:Exec()
		local frameWidget = self.widget
		DF:CoreDispatch((frameWidget:GetName() or "Button") .. ":Exec()", self.func, frameWidget, "LeftButton", self.param1, self.param2)
	end

	function ButtonMetaFunctions:Click()
		local frameWidget = self.widget
		DF:CoreDispatch((frameWidget:GetName() or "Button") .. ":Click()", self.func, frameWidget, "LeftButton", self.param1, self.param2)
	end

	function ButtonMetaFunctions:RightClick()
		local frameWidget = self.widget
		DF:CoreDispatch((frameWidget:GetName() or "Button") .. ":RightClick()", self.funcright, frameWidget, "RightButton", self.param1, self.param2)
	end

--custom textures
	function ButtonMetaFunctions:InstallCustomTexture()
		--function deprecated, now just set a the standard template
		self:SetTemplate(DF:GetTemplate("button", "OPTIONS_BUTTON_TEMPLATE"))
	end

------------------------------------------------------------------------------------------------------------
--scripts

	local OnEnter = function(button)
		local object = button.MyObject

		local kill = object:RunHooksForWidget("OnEnter", button, object)
		if (kill) then
			return
		end

		object.is_mouse_over = true

		if (button.texture) then
			if (button.texture.coords) then
				button.texture:SetTexCoord(unpack(button.texture.coords.Highlight))
			else
				button.texture:SetTexCoord(0, 1, 0.24609375, 0.49609375)
			end
		end

		if (object.onenter_backdrop_border_color) then
			button:SetBackdropBorderColor(unpack(object.onenter_backdrop_border_color))
		end

		if (object.onenter_backdrop) then
			button:SetBackdropColor(unpack(object.onenter_backdrop))
		end

		object:ShowTooltip()
	end

	local OnLeave = function(button)
		local object = button.MyObject

		local kill = object:RunHooksForWidget("OnLeave", button, object)
		if (kill) then
			return
		end

		object.is_mouse_over = false

		if (button.texture and not object.is_mouse_down) then
			if (button.texture.coords) then
				button.texture:SetTexCoord(unpack(button.texture.coords.Normal))
			else
				button.texture:SetTexCoord(0, 1, 0, 0.24609375)
			end
		end

		if (object.onleave_backdrop_border_color) then
			button:SetBackdropBorderColor(unpack(object.onleave_backdrop_border_color))
		end

		if (object.onleave_backdrop) then
			button:SetBackdropColor(unpack(object.onleave_backdrop))
		end

		object:HideTooltip()
	end

	local OnHide = function(button)
		local object = button.MyObject
		local kill = object:RunHooksForWidget("OnHide", button, object)
		if (kill) then
			return
		end
	end

	local OnShow = function(button)
		local object = button.MyObject
		local kill = object:RunHooksForWidget("OnShow", button, object)
		if (kill) then
			return
		end
	end

	local OnMouseDown = function(button, buttontype)
		if (not button:IsEnabled()) then
			return
		end

		local object = button.MyObject

		local kill = object:RunHooksForWidget("OnMouseDown", button, object)
		if (kill) then
			return
		end

		object.is_mouse_down = true

		if (button.texture) then
			if (button.texture.coords) then
				button.texture:SetTexCoord(unpack(button.texture.coords.Pushed))
			else
				button.texture:SetTexCoord(0, 1, 0.5078125, 0.75)
			end
		end

		if (object.capsule_textalign) then
			if (object.icon) then
				object.icon:SetPoint("left", button, "left", 5 + (object.icon.leftpadding or 0), -1)

			elseif (object.capsule_textalign == "left") then
				button.text:SetPoint("left", button, "left", 3, -1)

			elseif (object.capsule_textalign == "center") then
				button.text:SetPoint("center", button, "center", 1, -1)

			elseif (object.capsule_textalign == "right") then
				button.text:SetPoint("right", button, "right", -1, -1)
			end
		else
			if (object.icon) then
				object.icon:SetPoint("left", button, "left", 5 + (object.icon.leftpadding or 0), -1)
			else
				button.text:SetPoint("center", button,"center", 1, -1)
			end
		end

		button.mouse_down = GetTime()
		local x, y = GetCursorPosition()
		button.x = floor(x)
		button.y = floor(y)

		if (not object.container.isLocked and object.container:IsMovable()) then
			if (not button.isLocked and button:IsMovable()) then
				object.container.isMoving = true
				object.container:StartMoving()
			end
		end

		if (object.options.OnGrab) then
			if (type(object.options.OnGrab) == "string" and object.options.OnGrab == "PassClick") then
				if (buttontype == "LeftButton") then
					DF:CoreDispatch((button:GetName() or "Button") .. ":OnMouseDown()", object.func, button, buttontype, object.param1, object.param2)
				else
					DF:CoreDispatch((button:GetName() or "Button") .. ":OnMouseDown()", object.funcright, button, buttontype, object.param1, object.param2)
				end
			end
		end
	end

	local OnMouseUp = function(button, buttonType)
		if (not button:IsEnabled()) then
			return
		end

		local object = button.MyObject

		local kill = object:RunHooksForWidget("OnMouseUp", button, object)
		if (kill) then
			return
		end

		object.is_mouse_down = false

		if (button.texture) then
			if (button.texture.coords) then
				if (object.is_mouse_over) then
					button.texture:SetTexCoord(unpack(button.texture.coords.Highlight))
				else
					button.texture:SetTexCoord(unpack(coords.Normal))
				end
			else
				if (object.is_mouse_over) then
					button.texture:SetTexCoord(0, 1, 0.24609375, 0.49609375)
				else
					button.texture:SetTexCoord(0, 1, 0, 0.24609375)
				end
			end
		end

		if (object.capsule_textalign) then
			if (object.icon) then
				object.icon:SetPoint("left", button, "left", 4 + (object.icon.leftpadding or 0), 0)

			elseif (object.capsule_textalign == "left") then
				button.text:SetPoint("left", button, "left", 2, 0)

			elseif (object.capsule_textalign == "center") then
				button.text:SetPoint("center", button, "center", 0, 0)

			elseif (object.capsule_textalign == "right") then
				button.text:SetPoint("right", button, "right", -2, 0)
			end
		else
			if (object.icon) then
				object.icon:SetPoint("left", button, "left", 4 + (object.icon.leftpadding or 0), 0)
			else
				button.text:SetPoint("center", button,"center", 0, 0)
			end
		end

		if (object.container.isMoving) then
			object.container:StopMovingOrSizing()
			object.container.isMoving = false
		end

		local x, y = GetCursorPosition()
		x = floor(x)
		y = floor(y)

		button.mouse_down = button.mouse_down or 0 --avoid issues when the button was pressed while disabled and release when enabled

		if ((x == button.x and y == button.y) or (button.mouse_down + 0.5 > GetTime() and button:IsMouseOver())) then
			if (buttonType == "LeftButton") then
				DF:CoreDispatch((button:GetName() or "Button") .. ":OnMouseUp()", object.func, button, buttonType, object.param1, object.param2)
			else
				DF:CoreDispatch((button:GetName() or "Button") .. ":OnMouseUp()", object.funcright, button, buttonType, object.param1, object.param2)
			end
		end
	end

------------------------------------------------------------------------------------------------------------

function ButtonMetaFunctions:SetTemplate(template)
	if (type(template) == "string") then
		template = DF:GetTemplate("button", template)
	end

	if (not template) then
		DF:Error("template not found")
		return
	end

	if (template.width) then
		self:SetWidth(template.width)
	end

	if (template.height) then
		self:SetHeight(template.height)
	end

	if (template.backdrop) then
		self:SetBackdrop(template.backdrop)
	end

	if (template.backdropcolor) then
		local r, g, b, a = DF:ParseColors(template.backdropcolor)
		self:SetBackdropColor(r, g, b, a)
		self.onleave_backdrop = {r, g, b, a}
	end

	if (template.backdropbordercolor) then
		local r, g, b, a = DF:ParseColors(template.backdropbordercolor)
		self:SetBackdropBorderColor(r, g, b, a)
		self.onleave_backdrop_border_color = {r, g, b, a}
	end

	if (template.onentercolor) then
		local r, g, b, a = DF:ParseColors(template.onentercolor)
		self.onenter_backdrop = {r, g, b, a}
	end

	if (template.onleavecolor) then
		local r, g, b, a = DF:ParseColors(template.onleavecolor)
		self.onleave_backdrop = {r, g, b, a}
	end

	if (template.onenterbordercolor) then
		local r, g, b, a = DF:ParseColors(template.onenterbordercolor)
		self.onenter_backdrop_border_color = {r, g, b, a}
	end

	if (template.onleavebordercolor) then
		local r, g, b, a = DF:ParseColors(template.onleavebordercolor)
		self.onleave_backdrop_border_color = {r, g, b, a}
	end

	if (template.icon) then
		local iconInfo = template.icon
		self:SetIcon(iconInfo.texture, iconInfo.width, iconInfo.height, iconInfo.layout, iconInfo.texcoord, iconInfo.color, iconInfo.textdistance, iconInfo.leftpadding)
	end

	if (template.textsize) then
		self.textsize = template.textsize
	end

	if (template.textfont) then
		self.textfont = template.textfont
	end

	if (template.textcolor) then
		self.textcolor = template.textcolor
	end

	if (template.textalign) then
		self.textalign = template.textalign
	end
end

------------------------------------------------------------------------------------------------------------
--object constructor
	local onDisableFunc = function(self)
		self.texture_disabled:Show()
		self.texture_disabled:SetVertexColor(0, 0, 0)
		self.texture_disabled:SetAlpha(.5)
	end

	local onEnableFunc = function(self)
		self.texture_disabled:Hide()
	end

	local createButtonWidgets = function(self)
		self:SetSize(100, 20)

		self.text = self:CreateFontString("$parent_Text", "ARTWORK", "GameFontNormal")
		self.text:SetJustifyH("CENTER")
		self.text:SetPoint("CENTER", self, "CENTER", 0, 0)
		self:SetFontString(self.text)
		DF:SetFontSize(self.text, 10)

		self.texture_disabled = self:CreateTexture("$parent_TextureDisabled", "OVERLAY")
		self.texture_disabled:SetAllPoints()
		self.texture_disabled:Hide()
		self.texture_disabled:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")

		self:SetScript("OnDisable", onDisableFunc)
		self:SetScript("OnEnable", onEnableFunc)
	end

	function DF:CreateButton(parent, func, width, height, text, param1, param2, texture, member, name, shortMethod, buttonTemplate, textTemplate)
		return DF:NewButton(parent, parent, name, member, width, height, func, param1, param2, texture, text, shortMethod, buttonTemplate, textTemplate)
	end

	function DF:NewButton(parent, container, name, member, width, height, func, param1, param2, texture, text, shortMethod, buttonTemplate, textTemplate)
		if (not name) then
			name = "DetailsFrameworkButtonNumber" .. DF.ButtonCounter
			DF.ButtonCounter = DF.ButtonCounter + 1

		elseif (not parent) then
			return error("Details! FrameWork: parent not found.", 2)
		end

		if (name:find("$parent")) then
			local parentName = DF.GetParentName(parent)
			name = name:gsub("$parent", parentName)
		end

		local buttonObject = {type = "button", dframework = true}

		if (member) then
			parent[member] = buttonObject
		end

		if (parent.dframework) then
			parent = parent.widget
		end

		--container is used to move the 'container' frame when attempt to move the button
		buttonObject.container = container or parent

		--default members
		buttonObject.is_locked = true
		buttonObject.options = {OnGrab = false}

		buttonObject.button = CreateFrame("button", name, parent, "BackdropTemplate")
		DF:Mixin(buttonObject.button, DF.WidgetFunctions)

		createButtonWidgets(buttonObject.button)
		buttonObject.button:SetSize(width or 100, height or 20)
		buttonObject.widget = buttonObject.button
		buttonObject.button.MyObject = buttonObject

		if (not APIButtonFunctions) then
			APIButtonFunctions = true
			local idx = getmetatable(buttonObject.button).__index
			for funcName, funcAddress in pairs(idx) do
				if (not ButtonMetaFunctions[funcName]) then
					ButtonMetaFunctions[funcName] = function(object, ...)
						local x = loadstring("return _G['"..object.button:GetName().."']:"..funcName.."(...)")
						return x(...)
					end
				end
			end
		end

		buttonObject.text_overlay = _G[name .. "_Text"]
		buttonObject.disabled_overlay = _G[name .. "_TextureDisabled"]

		texture = texture or ""
		buttonObject.button:SetNormalTexture(texture)
		buttonObject.button:SetPushedTexture(texture)
		buttonObject.button:SetDisabledTexture(texture)
		buttonObject.button:SetHighlightTexture(texture, "ADD")

		local locTable = text
		DF.Language.SetTextWithLocTableWithDefault(buttonObject.button.text, locTable, text)

		buttonObject.button.text:SetPoint("center", buttonObject.button, "center")

		local textWidth = buttonObject.button.text:GetStringWidth()
		if (textWidth > width - 15 and buttonObject.button.text:GetText() ~= "") then
			if (shortMethod == false) then --if is false, do not use auto resize
				--do nothing
			elseif (not shortMethod) then --if the value is omitted, use the default resize
				local new_width = textWidth + 15
				buttonObject.button:SetWidth(new_width)

			elseif (shortMethod == 1) then
				local loop = true
				local textsize = 11
				while (loop) do
					if (textWidth + 15 < width or textsize < 8) then
						loop = false
						break
					else
						DF:SetFontSize(buttonObject.button.text, textsize)
						textWidth = buttonObject.button.text:GetStringWidth()
						textsize = textsize - 1
					end
				end
			elseif (shortMethod == 2) then

			end
		end

		buttonObject.func = func or emptyFunction
		buttonObject.funcright = emptyFunction
		buttonObject.param1 = param1
		buttonObject.param2 = param2
		buttonObject.short_method = shortMethod

		if (textTemplate) then
			if (textTemplate.size) then
				DF:SetFontSize(buttonObject.button.text, textTemplate.size)
			end

			if (textTemplate.color) then
				local r, g, b, a = DF:ParseColors(textTemplate.color)
				buttonObject.button.text:SetTextColor(r, g, b, a)
			end

			if (textTemplate.font) then
				local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
				local font = SharedMedia:Fetch("font", textTemplate.font)
				DF:SetFontFace(buttonObject.button.text, font)
			end
		end

		--hooks
		buttonObject.HookList = {
			OnEnter = {},
			OnLeave = {},
			OnHide = {},
			OnShow = {},
			OnMouseDown = {},
			OnMouseUp = {},
		}

		buttonObject.button:SetScript("OnEnter", OnEnter)
		buttonObject.button:SetScript("OnLeave", OnLeave)
		buttonObject.button:SetScript("OnHide", OnHide)
		buttonObject.button:SetScript("OnShow", OnShow)
		buttonObject.button:SetScript("OnMouseDown", OnMouseDown)
		buttonObject.button:SetScript("OnMouseUp", OnMouseUp)

		setmetatable(buttonObject, ButtonMetaFunctions)

		if (buttonTemplate) then
			buttonObject:SetTemplate(buttonTemplate)
		end

		return buttonObject
	end

------------------------------------------------------------------------------------------------------------
--color picker button

	local pickcolorCallback = function(self, red, green, blue, alpha, button)
		alpha = abs(alpha - 1)
		button.MyObject.color_texture:SetVertexColor(red, green, blue, alpha)

		--safecall
		DF:CoreDispatch((self:GetName() or "ColorPicker") .. ".pickcolor_callback()", button.MyObject.color_callback, button.MyObject, red, green, blue, alpha)
		button.MyObject:RunHooksForWidget("OnColorChanged", button.MyObject, red, green, blue, alpha)
	end

	local pickcolor = function(self)
		local red, green, blue, alpha = self.MyObject.color_texture:GetVertexColor()
		alpha = abs(alpha - 1)
		DF:ColorPick(self, red, green, blue, alpha, pickcolorCallback)
	end

	local setColorPickColor = function(button, ...)
		local red, green, blue, alpha = DF:ParseColors(...)
		button.color_texture:SetVertexColor(red, green, blue, alpha)
	end

	local colorpickCancel = function(self)
		ColorPickerFrame:Hide()
	end

	local getColorPickColor = function(self)
		return self.color_texture:GetVertexColor()
	end

	function DF:CreateColorPickButton(parent, name, member, callback, alpha, buttonTemplate)
		return DF:NewColorPickButton(parent, name, member, callback, alpha, buttonTemplate)
	end

	function DF:NewColorPickButton(parent, name, member, callback, alpha, buttonTemplate)
		--button
		local colorPickButton = DF:NewButton(parent, _, name, member, 16, 16, pickcolor, alpha, "param2", nil, nil, nil, buttonTemplate)
		colorPickButton.color_callback = callback
		colorPickButton.Cancel = colorpickCancel
		colorPickButton.SetColor = setColorPickColor
		colorPickButton.GetColor = getColorPickColor

		colorPickButton.HookList.OnColorChanged = {}

		if (not buttonTemplate) then
			colorPickButton:SetTemplate(DF:GetTemplate("button", "OPTIONS_BUTTON_TEMPLATE"))
		end

		--background showing a grid to indicate the transparency
		local background = colorPickButton:CreateTexture(nil, "background", nil, 2)
		background:SetPoint("topleft", colorPickButton.widget, "topleft", 0, 0)
		background:SetPoint("bottomright", colorPickButton.widget, "bottomright", 0, 0)
		background:SetTexture([[Interface\ITEMSOCKETINGFRAME\UI-EMPTYSOCKET]])
		background:SetTexCoord(3/16, 13/16, 3/16, 13/16)
		background:SetAlpha(0.3)

		--texture which shows the texture color
		local colorTexture = DF:NewImage(colorPickButton, nil, 16, 16, nil, nil, "color_texture", "$parentTex")
		colorTexture:SetColorTexture(1, 1, 1)
		colorTexture:SetPoint("topleft", colorPickButton.widget, "topleft", 0, 0)
		colorTexture:SetPoint("bottomright", colorPickButton.widget, "bottomright", 0, 0)
		colorTexture:SetDrawLayer("background", 3)

		return colorPickButton
	end

    function DF:SetRegularButtonTexture(button, texture, left, right, top, bottom)
        if (type(left) == "table") then
            left, right, top, bottom = unpack(left)
        end

        if (not left) then
            left, right, top, bottom = 0, 1, 0, 1
        end

        local atlas
        if (type(texture) == "string") then
            atlas = C_Texture.GetAtlasInfo(texture)
        end

        local normalTexture = button:GetNormalTexture()
        local pushedTexture = button:GetPushedTexture()
        local highlightTexture = button:GetHightlightTexture()
        local disabledTexture = button:GetDisabledTexture()

        if (atlas) then
            normalTexture:SetAtlas(texture)
            pushedTexture:SetAtlas(texture)
            highlightTexture:SetAtlas(texture)
            disabledTexture:SetAtlas(texture)
        else
            normalTexture:SetTexture(texture)
            pushedTexture:SetTexture(texture)
            highlightTexture:SetTexture(texture)
            disabledTexture:SetTexture(texture)
            normalTexture:SetTexCoord(left, right, top, bottom)
            pushedTexture:SetTexCoord(left, right, top, bottom)
            highlightTexture:SetTexCoord(left, right, top, bottom)
            disabledTexture:SetTexCoord(left, right, top, bottom)
        end
    end

	function DF:SetRegularButtonVertexColor(button, ...)
        local r, g, b, a = DF:ParseColor(...)
        local normalTexture = button:GetNormalTexture()
        local pushedTexture = button:GetPushedTexture()
        local highlightTexture = button:GetHightlightTexture()
        local disabledTexture = button:GetDisabledTexture()

        normalTexture:SetVertexColor(r, g, b, a)
        pushedTexture:SetVertexColor(r, g, b, a)
        highlightTexture:SetVertexColor(r, g, b, a)
        disabledTexture:SetVertexColor(r, g, b, a)
    end
