
local DF = _G ["DetailsFramework"]

if (not DF or not DetailsFrameworkCanLoad) then
	return 
end

local _
local _rawset = rawset --> lua local
local _rawget = rawget --> lua local
local _setmetatable = setmetatable --> lua local
local _unpack = unpack --> lua local
local _type = type --> lua local
local _math_floor = math.floor --> lua local
local loadstring = loadstring --> lua local

local cleanfunction = function() end
local APIButtonFunctions = false

do
	local metaPrototype = {
		WidgetType = "button",
		SetHook = DF.SetHook,
		HasHook = DF.HasHook,
		ClearHooks = DF.ClearHooks,
		RunHooksForWidget = DF.RunHooksForWidget,
	}

	_G [DF.GlobalWidgetControlNames ["button"]] = _G [DF.GlobalWidgetControlNames ["button"]] or metaPrototype
end

local ButtonMetaFunctions = _G [DF.GlobalWidgetControlNames ["button"]]

------------------------------------------------------------------------------------------------------------
--> metatables

	ButtonMetaFunctions.__call = function (self)
		local frameWidget = self.widget
		DF:CoreDispatch ((frameWidget:GetName() or "Button") .. ":__call()", self.func, frameWidget, "LeftButton", self.param1, self.param2)
	end

------------------------------------------------------------------------------------------------------------
--> members

	--> tooltip
	local gmember_tooltip = function (_object)
		return _object:GetTooltip()
	end
	--> shown
	local gmember_shown = function (_object)
		return _object:IsShown()
	end
	--> frame width
	local gmember_width = function (_object)
		return _object.button:GetWidth()
	end
	--> frame height
	local gmember_height = function (_object)
		return _object.button:GetHeight()
	end
	--> text
	local gmember_text = function (_object)
		return _object.button.text:GetText()
	end
	--> function
	local gmember_function = function (_object)
		return _rawget (_object, "func")
	end
	--> text color
	local gmember_textcolor = function (_object)
		return _object.button.text:GetTextColor()
	end
	--> text font
	local gmember_textfont = function (_object)
		local fontface = _object.button.text:GetFont()
		return fontface
	end
	--> text size
	local gmember_textsize = function (_object)
		local _, fontsize = _object.button.text:GetFont()
		return fontsize
	end
	--> texture
	local gmember_texture = function (_object)
		return {_object.button:GetNormalTexture(), _object.button:GetHighlightTexture(), _object.button:GetPushedTexture(), _object.button:GetDisabledTexture()}
	end
	--> locked
	local gmember_locked = function (_object)
		return _rawget (_object, "is_locked")
	end

	ButtonMetaFunctions.GetMembers = ButtonMetaFunctions.GetMembers or {}
	ButtonMetaFunctions.GetMembers ["tooltip"] = gmember_tooltip
	ButtonMetaFunctions.GetMembers ["shown"] = gmember_shown
	ButtonMetaFunctions.GetMembers ["width"] = gmember_width
	ButtonMetaFunctions.GetMembers ["height"] = gmember_height
	ButtonMetaFunctions.GetMembers ["text"] = gmember_text
	ButtonMetaFunctions.GetMembers ["clickfunction"] = gmember_function
	ButtonMetaFunctions.GetMembers ["texture"] = gmember_texture
	ButtonMetaFunctions.GetMembers ["locked"] = gmember_locked
	ButtonMetaFunctions.GetMembers ["fontcolor"] = gmember_textcolor
	ButtonMetaFunctions.GetMembers ["fontface"] = gmember_textfont
	ButtonMetaFunctions.GetMembers ["fontsize"] = gmember_textsize
	ButtonMetaFunctions.GetMembers ["textcolor"] = gmember_textcolor --alias
	ButtonMetaFunctions.GetMembers ["textfont"] = gmember_textfont --alias
	ButtonMetaFunctions.GetMembers ["textsize"] = gmember_textsize --alias	

	ButtonMetaFunctions.__index = function (_table, _member_requested)

		local func = ButtonMetaFunctions.GetMembers [_member_requested]
		if (func) then
			return func (_table, _member_requested)
		end
		
		local fromMe = _rawget (_table, _member_requested)
		if (fromMe) then
			return fromMe
		end
		
		return ButtonMetaFunctions [_member_requested]
	end
	
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

	--> tooltip
	local smember_tooltip = function (_object, _value)
		return _object:SetTooltip (_value)
	end
	--> show
	local smember_show = function (_object, _value)
		if (_value) then
			return _object:Show()
		else
			return _object:Hide()
		end
	end
	--> hide
	local smember_hide = function (_object, _value)
		if (not _value) then
			return _object:Show()
		else
			return _object:Hide()
		end
	end
	--> frame width
	local smember_width = function (_object, _value)
		return _object.button:SetWidth (_value)
	end
	--> frame height
	local smember_height = function (_object, _value)
		return _object.button:SetHeight (_value)
	end
	--> text
	local smember_text = function (_object, _value)
		return _object.button.text:SetText (_value)
	end
	--> function
	local smember_function = function (_object, _value)
		return _rawset (_object, "func", _value)
	end
	--> param1
	local smember_param1 = function (_object, _value)
		return _rawset (_object, "param1", _value)
	end
	--> param2
	local smember_param2 = function (_object, _value)
		return _rawset (_object, "param2", _value)
	end
	--> text color
	local smember_textcolor = function (_object, _value)
		local _value1, _value2, _value3, _value4 = DF:ParseColors (_value)
		return _object.button.text:SetTextColor (_value1, _value2, _value3, _value4)	
	end
	--> text font
	local smember_textfont = function (_object, _value)
		return DF:SetFontFace (_object.button.text, _value)
	end
	--> text size
	local smember_textsize = function (_object, _value)
		return DF:SetFontSize (_object.button.text, _value)
	end
	--> texture
	local smember_texture = function (_object, _value)
		if (_type (_value) == "table") then
			local _value1, _value2, _value3, _value4 = unpack (_value)
			if (_value1) then
				_object.button:SetNormalTexture (_value1)
			end
			if (_value2) then
				_object.button:SetHighlightTexture (_value2, "ADD")
			end
			if (_value3) then
				_object.button:SetPushedTexture (_value3)
			end
			if (_value4) then
				_object.button:SetDisabledTexture (_value4)
			end
		else
			_object.button:SetNormalTexture (_value)
			_object.button:SetHighlightTexture (_value, "ADD")
			_object.button:SetPushedTexture (_value)
			_object.button:SetDisabledTexture (_value)
		end
		return
	end
	--> locked
	local smember_locked = function (_object, _value)
		if (_value) then
			_object.button:SetMovable (false)
			return _rawset (_object, "is_locked", true)
		else
			_object.button:SetMovable (true)
			_rawset (_object, "is_locked", false)
			return
		end
	end	
	--> text align
	local smember_textalign = function (_object, _value)
		if (_value == "left" or _value == "<") then
			_object.button.text:SetPoint ("left", _object.button, "left", 2, 0)
			_object.capsule_textalign = "left"
		elseif (_value == "center" or _value == "|") then
			_object.button.text:SetPoint ("center", _object.button, "center", 0, 0)
			_object.capsule_textalign = "center"
		elseif (_value == "right" or _value == ">") then
			_object.button.text:SetPoint ("right", _object.button, "right", -2, 0)
			_object.capsule_textalign = "right"
		end
	end
	
	ButtonMetaFunctions.SetMembers = ButtonMetaFunctions.SetMembers or {}
	ButtonMetaFunctions.SetMembers ["tooltip"] = smember_tooltip
	ButtonMetaFunctions.SetMembers ["show"] = smember_show
	ButtonMetaFunctions.SetMembers ["hide"] = smember_hide
	ButtonMetaFunctions.SetMembers ["width"] = smember_width
	ButtonMetaFunctions.SetMembers ["height"] = smember_height
	ButtonMetaFunctions.SetMembers ["text"] = smember_text
	ButtonMetaFunctions.SetMembers ["clickfunction"] = smember_function
	ButtonMetaFunctions.SetMembers ["param1"] = smember_param1
	ButtonMetaFunctions.SetMembers ["param2"] = smember_param2
	ButtonMetaFunctions.SetMembers ["textcolor"] = smember_textcolor
	ButtonMetaFunctions.SetMembers ["textfont"] = smember_textfont
	ButtonMetaFunctions.SetMembers ["textsize"] = smember_textsize
	ButtonMetaFunctions.SetMembers ["texture"] = smember_texture
	ButtonMetaFunctions.SetMembers ["locked"] = smember_locked
	ButtonMetaFunctions.SetMembers ["textalign"] = smember_textalign
	
	ButtonMetaFunctions.__newindex = function (_table, _key, _value)
		local func = ButtonMetaFunctions.SetMembers [_key]
		if (func) then
			return func (_table, _value)
		else
			return _rawset (_table, _key, _value)
		end
	end
	
------------------------------------------------------------------------------------------------------------
--> methods

--> show & hide
	function ButtonMetaFunctions:IsShown()
		return self.button:IsShown()
	end
	function ButtonMetaFunctions:Show()
		return self.button:Show()
	end
	function ButtonMetaFunctions:Hide()
		return self.button:Hide()
	end
	
-- setpoint
	function ButtonMetaFunctions:SetPoint (v1, v2, v3, v4, v5)
		v1, v2, v3, v4, v5 = DF:CheckPoints (v1, v2, v3, v4, v5, self)
		if (not v1) then
			error ("SetPoint: Invalid parameter.")
			return
		end
		return self.widget:SetPoint (v1, v2, v3, v4, v5)
	end

-- sizes
	function ButtonMetaFunctions:SetSize (w, h)
		if (w) then
			self.button:SetWidth (w)
		end
		if (h) then
			return self.button:SetHeight (h)
		end
	end
	
-- tooltip
	function ButtonMetaFunctions:SetTooltip (tooltip)
		if (tooltip) then
			return _rawset (self, "have_tooltip", tooltip)
		else
			return _rawset (self, "have_tooltip", nil)
		end
	end
	function ButtonMetaFunctions:GetTooltip()
		return _rawget (self, "have_tooltip")
	end
	
-- functions
	function ButtonMetaFunctions:SetClickFunction (func, param1, param2, clicktype)
		if (not clicktype or string.find (string.lower (clicktype), "left")) then
			if (func) then
				_rawset (self, "func", func)
			else
				_rawset (self, "func", cleanfunction)
			end
			
			if (param1 ~= nil) then
				_rawset (self, "param1", param1)
			end
			if (param2 ~= nil) then
				_rawset (self, "param2", param2)
			end
			
		elseif (clicktype or string.find (string.lower (clicktype), "right")) then
			if (func) then
				_rawset (self, "funcright", func)
			else
				_rawset (self, "funcright", cleanfunction)
			end
		end
	end
	
-- text
	function ButtonMetaFunctions:SetText (text)
		if (text) then
			self.button.text:SetText (text)
		else
			self.button.text:SetText (nil)
		end
	end
	
-- textcolor
	function ButtonMetaFunctions:SetTextColor (color, arg2, arg3, arg4)
		if (arg2) then
			return self.button.text:SetTextColor (color, arg2, arg3, arg4 or 1)
		end
		local _value1, _value2, _value3, _value4 = DF:ParseColors (color)
		return self.button.text:SetTextColor (_value1, _value2, _value3, _value4)
	end
	
-- textsize
	function ButtonMetaFunctions:SetTextSize (size)
		return DF:SetFontSize (self.button.text, _value)
	end
	
-- textfont
	function ButtonMetaFunctions:SetTextFont (font)
		return DF:SetFontFace (_object.button.text, _value)
	end
	
-- textures
	function ButtonMetaFunctions:SetTexture (normal, highlight, pressed, disabled)
		if (normal) then
			self.button:SetNormalTexture (normal)
		elseif (_type (normal) ~= "boolean") then
			self.button:SetNormalTexture (nil)
		end
		
		if (_type (highlight) == "boolean") then
			if (highlight and normal and _type (normal) ~= "boolean") then
				self.button:SetHighlightTexture (normal, "ADD")
			end
		elseif (highlight == nil) then
			self.button:SetHighlightTexture (nil)
		else
			self.button:SetHighlightTexture (highlight, "ADD")
		end
		
		if (_type (pressed) == "boolean") then
			if (pressed and normal and _type (normal) ~= "boolean") then
				self.button:SetPushedTexture (normal)
			end
		elseif (pressed == nil) then
			self.button:SetPushedTexture (nil)
		else
			self.button:SetPushedTexture (pressed, "ADD")
		end
		
		if (_type (disabled) == "boolean") then
			if (disabled and normal and _type (normal) ~= "boolean") then
				self.button:SetDisabledTexture (normal)
			end
		elseif (disabled == nil) then
			self.button:SetDisabledTexture (nil)
		else
			self.button:SetDisabledTexture (disabled, "ADD")
		end
		
	end
	
-- frame levels
	function ButtonMetaFunctions:GetFrameLevel()
		return self.button:GetFrameLevel()
	end
	function ButtonMetaFunctions:SetFrameLevel (level, frame)
		if (not frame) then
			return self.button:SetFrameLevel (level)
		else
			local framelevel = frame:GetFrameLevel (frame) + level
			return self.button:SetFrameLevel (framelevel)
		end
	end

-- icon
	function ButtonMetaFunctions:GetIconTexture()
		if (self.icon) then
			return self.icon:GetTexture()
		end
	end
	
	function ButtonMetaFunctions:SetIcon (texture, width, height, layout, texcoord, overlay, textdistance, leftpadding, textheight, short_method)
		if (not self.icon) then
			self.icon = self:CreateTexture (nil, "artwork")
			self.icon:SetSize (self.height*0.8, self.height*0.8)
			self.icon:SetPoint ("left", self.widget, "left", 4 + (leftpadding or 0), 0)
			self.icon.leftpadding = leftpadding or 0
			self.widget.text:ClearAllPoints()
			self.widget.text:SetPoint ("left", self.icon, "right", textdistance or 2, 0 + (textheight or 0))
		end
		
		self.icon:SetTexture (texture)
		self.icon:SetSize (width or self.height*0.8, height or self.height*0.8)
		self.icon:SetDrawLayer (layout or "artwork")
		if (texcoord) then
			self.icon:SetTexCoord (unpack (texcoord))
		else
			self.icon:SetTexCoord (0, 1, 0, 1)
		end
		if (overlay) then
			if (type (overlay) == "string") then
				local r, g, b, a = DF:ParseColors (overlay)
				self.icon:SetVertexColor (r, g, b, a)
			else
				self.icon:SetVertexColor (unpack (overlay))
			end
		else
			self.icon:SetVertexColor (1, 1, 1, 1)
		end
		
		local w = self.button:GetWidth()
		local iconw = self.icon:GetWidth()
		local text_width = self.button.text:GetStringWidth()
		if (text_width > w-15-iconw) then

			if (short_method == false) then
			
			elseif (not short_method) then
				local new_width = text_width+15+iconw
				self.button:SetWidth (new_width)
				
			elseif (short_method == 1) then
				local loop = true
				local textsize = 11
				while (loop) do
					if (text_width+15+iconw < w or textsize < 8) then
						loop = false
						break
					else
						DF:SetFontSize (self.button.text, textsize)
						text_width = self.button.text:GetStringWidth()
						textsize = textsize - 1
					end
				end
				
			end
		end
		
	end
	
-- frame stratas
	function ButtonMetaFunctions:SetFrameStrata()
		return self.button:GetFrameStrata()
	end
	function ButtonMetaFunctions:SetFrameStrata (strata)
		if (_type (strata) == "table") then
			self.button:SetFrameStrata (strata:GetFrameStrata())
		else
			self.button:SetFrameStrata (strata)
		end
	end
	
-- enabled
	function ButtonMetaFunctions:IsEnabled()
		return self.button:IsEnabled()
	end
	function ButtonMetaFunctions:Enable()
		return self.button:Enable()
	end
	function ButtonMetaFunctions:Disable()
		return self.button:Disable()
	end
	
-- exec
	function ButtonMetaFunctions:Exec()
		local frameWidget = self.widget
		DF:CoreDispatch ((frameWidget:GetName() or "Button") .. ":Exec()", self.func, frameWidget, "LeftButton", self.param1, self.param2)
	end
	function ButtonMetaFunctions:Click()
		local frameWidget = self.widget
		DF:CoreDispatch ((frameWidget:GetName() or "Button") .. ":Click()", self.func, frameWidget, "LeftButton", self.param1, self.param2)
	end
	function ButtonMetaFunctions:RightClick()
		local frameWidget = self.widget
		DF:CoreDispatch ((frameWidget:GetName() or "Button") .. ":RightClick()", self.funcright, frameWidget, "RightButton", self.param1, self.param2)
	end

--> custom textures
	function ButtonMetaFunctions:InstallCustomTexture (texture, rect, coords, use_split, side_textures, side_textures2)
	
		self.button:SetNormalTexture (nil)
		self.button:SetPushedTexture (nil)
		self.button:SetDisabledTexture (nil)
		self.button:SetHighlightTexture (nil)

		local button = self.button
		
		if (use_split) then
		
			--> 4 corners
			button.textureTopLeft = button:CreateTexture (nil, "artwork"); button.textureTopLeft:SetSize (8, 8); button.textureTopLeft:SetPoint ("topleft", button)
			button.textureTopRight = button:CreateTexture (nil, "artwork"); button.textureTopRight:SetSize (8, 8); button.textureTopRight:SetPoint ("topright", button)
			button.textureBottomLeft = button:CreateTexture (nil, "artwork"); button.textureBottomLeft:SetSize (8, 8); button.textureBottomLeft:SetPoint ("bottomleft", button)
			button.textureBottomRight = button:CreateTexture (nil, "artwork"); button.textureBottomRight:SetSize (8, 8); button.textureBottomRight:SetPoint ("bottomright", button)

			button.textureLeft = button:CreateTexture (nil, "artwork"); button.textureLeft:SetWidth (4); button.textureLeft:SetPoint ("topleft", button.textureTopLeft, "bottomleft"); button.textureLeft:SetPoint ("bottomleft", button.textureBottomLeft, "topleft")
			button.textureRight = button:CreateTexture (nil, "artwork"); button.textureRight:SetWidth (4); button.textureRight:SetPoint ("topright", button.textureTopRight, "bottomright"); button.textureRight:SetPoint ("bottomright", button.textureBottomRight, "topright")
			button.textureTop = button:CreateTexture (nil, "artwork"); button.textureTop:SetHeight (4); button.textureTop:SetPoint ("topleft", button.textureTopLeft, "topright"); button.textureTop:SetPoint ("topright", button.textureTopRight, "topleft");
			button.textureBottom = button:CreateTexture (nil, "artwork"); button.textureBottom:SetHeight (4); button.textureBottom:SetPoint ("bottomleft", button.textureBottomLeft, "bottomright"); button.textureBottom:SetPoint ("bottomright", button.textureBottomRight, "bottomleft");
			
			button.textureLeft:SetTexCoord (0, 4/128, 9/128, 24/128)
			button.textureRight:SetTexCoord (124/128, 1, 9/128, 24/128)
			button.textureTop:SetTexCoord (9/128, 120/128, 0, 4/128)
			button.textureBottom:SetTexCoord (9/128, 119/128, 28/128, 32/128)
			
			button.textureTopLeft:SetTexCoord (0, 8/128, 0, 8/128)
			button.textureTopRight:SetTexCoord (121/128, 1, 0, 8/128)
			button.textureBottomLeft:SetTexCoord (0, 8/128, 24/128, 32/128)
			button.textureBottomRight:SetTexCoord (120/128, 1, 24/128, 32/128)
			
			button.textureTopLeft:SetTexture ([[Interface\AddOns\Details\images\default_button]])
			button.textureTopRight:SetTexture ([[Interface\AddOns\Details\images\default_button]])
			button.textureBottomLeft:SetTexture ([[Interface\AddOns\Details\images\default_button]])
			button.textureBottomRight:SetTexture ([[Interface\AddOns\Details\images\default_button]])
			button.textureLeft:SetTexture ([[Interface\AddOns\Details\images\default_button]])
			button.textureRight:SetTexture ([[Interface\AddOns\Details\images\default_button]])
			button.textureTop:SetTexture ([[Interface\AddOns\Details\images\default_button]])
			button.textureBottom:SetTexture ([[Interface\AddOns\Details\images\default_button]])
		
		else
			texture = texture or "Interface\\AddOns\\Details\\images\\default_button"
			self.button.texture = self.button:CreateTexture (nil, "artwork")
			
			if (not rect) then 
				self.button.texture:SetAllPoints (self.button)
			else
				self.button.texture:SetPoint ("topleft", self.button, "topleft", rect.x1, rect.y1)
				self.button.texture:SetPoint ("bottomright", self.button, "bottomright", rect.x2, rect.y2)
			end
			
			if (coords) then
				self.button.texture.coords = coords
				self.button.texture:SetTexCoord (_unpack (coords.Normal))
			else
				self.button.texture:SetTexCoord (0, 1, 0, 0.24609375)
			end
			
			self.button.texture:SetTexture (texture)
		end
		
		if (side_textures) then
			local left = self.button:CreateTexture (nil, "overlay")
			left:SetTexture ([[Interface\TALENTFRAME\talent-main]])
			left:SetTexCoord (0.13671875, 0.25, 0.486328125, 0.576171875)
			left:SetPoint ("left", self.button, 0, 0)
			left:SetWidth (10)
			left:SetHeight (self.button:GetHeight()+2)
			self.button.left_border = left
			
			local right = self.button:CreateTexture (nil, "overlay")
			right:SetTexture ([[Interface\TALENTFRAME\talent-main]])
			right:SetTexCoord (0.01953125, 0.13671875, 0.486328125, 0.576171875)
			right:SetPoint ("right", self.button, 0, 0)	
			right:SetWidth (10)
			right:SetHeight (self.button:GetHeight()+2)
			self.button.right_border = right
			
		elseif (side_textures2) then
			
			local left = self.button:CreateTexture (nil, "overlay")
			left:SetTexture ([[Interface\AddOns\Details\images\icons]])
			left:SetTexCoord (94/512, 123/512, 42/512, 87/512)
			left:SetPoint ("left", self.button, 0, 0)
			left:SetWidth (10)
			left:SetHeight (self.button:GetHeight()+2)
			self.button.left_border = left
			
			local right = self.button:CreateTexture (nil, "overlay")
			right:SetTexture ([[Interface\AddOns\Details\images\icons]])
			right:SetTexCoord (65/512, 94/512, 42/512, 87/512)
			right:SetPoint ("right", self.button, 0, 0)	
			right:SetWidth (10)
			right:SetHeight (self.button:GetHeight()+2)
			self.button.right_border = right
		end
	end

------------------------------------------------------------------------------------------------------------
--> scripts

	local OnEnter = function (button)

		local capsule = button.MyObject

		if (button.textureTopLeft) then
			button.textureLeft:SetTexCoord (0, 4/128, 40/128, 56/128)
			button.textureRight:SetTexCoord (124/128, 1, 40/128, 56/128)
			button.textureTop:SetTexCoord (9/128, 120/128, 33/128, 37/128)
			button.textureBottom:SetTexCoord (9/128, 119/128, 60/128, 64/128)
			
			button.textureTopLeft:SetTexCoord (0, 8/128, 33/128, 40/128)
			button.textureTopRight:SetTexCoord (121/128, 1, 33/128, 40/128)
			button.textureBottomLeft:SetTexCoord (0, 8/128, 56/128, 64/128)
			button.textureBottomRight:SetTexCoord (120/128, 1, 56/128, 64/128)
		end
		
		local kill = capsule:RunHooksForWidget ("OnEnter", button, capsule)
		if (kill) then
			return
		end

		button.MyObject.is_mouse_over = true
		
		if (button.texture) then
			if (button.texture.coords) then
				button.texture:SetTexCoord (_unpack (button.texture.coords.Highlight))
			else
				button.texture:SetTexCoord (0, 1, 0.24609375, 0.49609375)
			end
		end

		if (button.MyObject.onenter_backdrop_border_color) then
			button:SetBackdropBorderColor (unpack (button.MyObject.onenter_backdrop_border_color))
		end
		
		if (button.MyObject.onenter_backdrop) then
			button:SetBackdropColor (unpack (button.MyObject.onenter_backdrop))
		end
		
		if (button.MyObject.have_tooltip) then 
			GameCooltip2:Preset (2)
			if (type (button.MyObject.have_tooltip) == "function") then
				GameCooltip2:AddLine (button.MyObject.have_tooltip() or "")
			else
				GameCooltip2:AddLine (button.MyObject.have_tooltip)
			end
			GameCooltip2:ShowCooltip (button, "tooltip")
		end
	end
	
	local OnLeave = function (button)
	
		local capsule = button.MyObject
		
		if (button.textureLeft and not button.MyObject.is_mouse_down) then
			button.textureLeft:SetTexCoord (0, 4/128, 9/128, 24/128)
			button.textureRight:SetTexCoord (124/128, 1, 9/128, 24/128)
			button.textureTop:SetTexCoord (9/128, 120/128, 0, 4/128)
			button.textureBottom:SetTexCoord (9/128, 119/128, 28/128, 32/128)
			
			button.textureTopLeft:SetTexCoord (0, 8/128, 0, 8/128)
			button.textureTopRight:SetTexCoord (121/128, 1, 0, 8/128)
			button.textureBottomLeft:SetTexCoord (0, 8/128, 24/128, 32/128)
			button.textureBottomRight:SetTexCoord (120/128, 1, 24/128, 32/128)
		end
		
		local kill = capsule:RunHooksForWidget ("OnLeave", button, capsule)
		if (kill) then
			return
		end
		
		button.MyObject.is_mouse_over = false
		
		if (button.texture and not button.MyObject.is_mouse_down) then
			if (button.texture.coords) then
				button.texture:SetTexCoord (_unpack (button.texture.coords.Normal))
			else		
				button.texture:SetTexCoord (0, 1, 0, 0.24609375)
			end
		end

		if (button.MyObject.onleave_backdrop_border_color) then
			button:SetBackdropBorderColor (unpack (button.MyObject.onleave_backdrop_border_color))
		end
		
		if (button.MyObject.onleave_backdrop) then
			button:SetBackdropColor (unpack (button.MyObject.onleave_backdrop))
		end
		
		if (button.MyObject.have_tooltip) then
			if (GameCooltip2:GetText (1) == button.MyObject.have_tooltip or type (button.MyObject.have_tooltip) == "function") then
				GameCooltip2:Hide()
			end
		end
	end
	
	local OnHide = function (button)
		local capsule = button.MyObject
		local kill = capsule:RunHooksForWidget ("OnHide", button, capsule)
		if (kill) then
			return
		end
	end
	
	local OnShow = function (button)
		local capsule = button.MyObject
		local kill = capsule:RunHooksForWidget ("OnShow", button, capsule)
		if (kill) then
			return
		end
	end
	
	local OnMouseDown = function (button, buttontype)
		local capsule = button.MyObject
		
		if (not button:IsEnabled()) then
			return
		end		
		
		if (button.textureTopLeft) then
			button.textureLeft:SetTexCoord (0, 4/128, 72/128, 88/128)
			button.textureRight:SetTexCoord (124/128, 1, 72/128, 88/128)
			button.textureTop:SetTexCoord (9/128, 120/128, 65/128, 68/128)
			button.textureBottom:SetTexCoord (9/128, 119/128, 92/128, 96/128)
			
			button.textureTopLeft:SetTexCoord (0, 8/128, 65/128, 71/128)
			button.textureTopRight:SetTexCoord (121/128, 1, 65/128, 71/128)
			button.textureBottomLeft:SetTexCoord (0, 8/128, 88/128, 96/128)
			button.textureBottomRight:SetTexCoord (120/128, 1, 88/128, 96/128)
		end

		local kill = capsule:RunHooksForWidget ("OnMouseDown", button, capsule)
		if (kill) then
			return
		end
		
		button.MyObject.is_mouse_down = true
		
		if (button.texture) then
			if (button.texture.coords) then
				button.texture:SetTexCoord (_unpack (button.texture.coords.Pushed))
			else		
				button.texture:SetTexCoord (0, 1, 0.5078125, 0.75)
			end
		end
		
		if (button.MyObject.capsule_textalign) then
			if (button.MyObject.icon) then
				button.MyObject.icon:SetPoint ("left", button, "left", 5 + (button.MyObject.icon.leftpadding or 0), -1)
			elseif (button.MyObject.capsule_textalign == "left") then
				button.text:SetPoint ("left", button, "left", 3, -1)
			elseif (button.MyObject.capsule_textalign == "center") then
				button.text:SetPoint ("center", button, "center", 1, -1)
			elseif (button.MyObject.capsule_textalign == "right") then
				button.text:SetPoint ("right", button, "right", -1, -1)
			end
		else
			if (button.MyObject.icon) then
				button.MyObject.icon:SetPoint ("left", button, "left", 7 + (button.MyObject.icon.leftpadding or 0), -2)
			else
				button.text:SetPoint ("center", button,"center", 1, -1)
			end
		end

		button.mouse_down = GetTime()
		local x, y = GetCursorPosition()
		button.x = _math_floor (x)
		button.y = _math_floor (y)
	
		if (not button.MyObject.container.isLocked and button.MyObject.container:IsMovable()) then
			if (not button.isLocked and button:IsMovable()) then
				button.MyObject.container.isMoving = true
				button.MyObject.container:StartMoving()
			end
		end
		
		if (button.MyObject.options.OnGrab) then
			if (_type (button.MyObject.options.OnGrab) == "string" and button.MyObject.options.OnGrab == "PassClick") then
				if (buttontype == "LeftButton") then
					DF:CoreDispatch ((button:GetName() or "Button") .. ":OnMouseDown()", button.MyObject.func, button, buttontype, button.MyObject.param1, button.MyObject.param2)
				else
					DF:CoreDispatch ((button:GetName() or "Button") .. ":OnMouseDown()", button.MyObject.funcright, button, buttontype, button.MyObject.param1, button.MyObject.param2)
				end
			end
		end
	end

	local OnMouseUp = function (button, buttontype)
		if (not button:IsEnabled()) then
			return
		end
		
		if (button.textureLeft) then
			if (button.MyObject.is_mouse_over) then
				button.textureLeft:SetTexCoord (0, 4/128, 40/128, 56/128)
				button.textureRight:SetTexCoord (124/128, 1, 40/128, 56/128)
				button.textureTop:SetTexCoord (9/128, 120/128, 33/128, 37/128)
				button.textureBottom:SetTexCoord (9/128, 119/128, 60/128, 64/128)
				
				button.textureTopLeft:SetTexCoord (0, 8/128, 33/128, 40/128)
				button.textureTopRight:SetTexCoord (121/128, 1, 33/128, 40/128)
				button.textureBottomLeft:SetTexCoord (0, 8/128, 56/128, 64/128)
				button.textureBottomRight:SetTexCoord (120/128, 1, 56/128, 64/128)
			else
				button.textureLeft:SetTexCoord (0, 4/128, 9/128, 24/128)
				button.textureRight:SetTexCoord (124/128, 1, 9/128, 24/128)
				button.textureTop:SetTexCoord (9/128, 120/128, 0, 4/128)
				button.textureBottom:SetTexCoord (9/128, 119/128, 28/128, 32/128)
				
				button.textureTopLeft:SetTexCoord (0, 8/128, 0, 8/128)
				button.textureTopRight:SetTexCoord (121/128, 1, 0, 8/128)
				button.textureBottomLeft:SetTexCoord (0, 8/128, 24/128, 32/128)
				button.textureBottomRight:SetTexCoord (120/128, 1, 24/128, 32/128)
			end
		end
		
		local capsule = button.MyObject
		local kill = capsule:RunHooksForWidget ("OnMouseUp", button, capsule)
		if (kill) then
			return
		end
		
		button.MyObject.is_mouse_down = false
		
		if (button.texture) then
			if (button.texture.coords) then
				if (button.MyObject.is_mouse_over) then
					button.texture:SetTexCoord (_unpack (button.texture.coords.Highlight))
				else
					button.texture:SetTexCoord (_unpack (coords.Normal))
				end
			else	
				if (button.MyObject.is_mouse_over) then
					button.texture:SetTexCoord (0, 1, 0.24609375, 0.49609375)
				else
					button.texture:SetTexCoord (0, 1, 0, 0.24609375)
				end
			end
		end

		if (button.MyObject.capsule_textalign) then
			if (button.MyObject.icon) then
				button.MyObject.icon:SetPoint ("left", button, "left", 4 + (button.MyObject.icon.leftpadding or 0), 0)
			elseif (button.MyObject.capsule_textalign == "left") then
				button.text:SetPoint ("left", button, "left", 2, 0)
			elseif (button.MyObject.capsule_textalign == "center") then
				button.text:SetPoint ("center", button, "center", 0, 0)
			elseif (button.MyObject.capsule_textalign == "right") then
				button.text:SetPoint ("right", button, "right", -2, 0)
			end
		else
			if (button.MyObject.icon) then
				button.MyObject.icon:SetPoint ("left", button, "left", 4 + (button.MyObject.icon.leftpadding or 0), 0)
			else
				button.text:SetPoint ("center", button,"center", 0, 0)
			end
		end
		
		if (button.MyObject.container.isMoving) then
			button.MyObject.container:StopMovingOrSizing()
			button.MyObject.container.isMoving = false
		end

		local x, y = GetCursorPosition()
		x = _math_floor (x)
		y = _math_floor (y)
		
		button.mouse_down = button.mouse_down or 0 --avoid issues when the button was pressed while disabled and release when enabled
		
		if (
			(x == button.x and y == button.y) or
			(button.mouse_down+0.5 > GetTime() and button:IsMouseOver())
		) then
			if (buttontype == "LeftButton") then
				DF:CoreDispatch ((button:GetName() or "Button") .. ":OnMouseUp()", button.MyObject.func, button, buttontype, button.MyObject.param1, button.MyObject.param2)
			else
				DF:CoreDispatch ((button:GetName() or "Button") .. ":OnMouseUp()", button.MyObject.funcright, button, buttontype, button.MyObject.param1, button.MyObject.param2)
			end
		end
	end

------------------------------------------------------------------------------------------------------------

function ButtonMetaFunctions:SetTemplate (template)
	
	if (type (template) == "string") then
		template = DF:GetTemplate ("button", template)
	end
	
	if (not template) then
		DF:Error ("template not found")
		return
	end
	
	if (template.width) then
		self:SetWidth (template.width)
	end
	if (template.height) then
		self:SetHeight (template.height)
	end
	
	if (template.backdrop) then
		self:SetBackdrop (template.backdrop)
	end
	if (template.backdropcolor) then
		local r, g, b, a = DF:ParseColors (template.backdropcolor)
		self:SetBackdropColor (r, g, b, a)
		self.onleave_backdrop = {r, g, b, a}
	end
	if (template.backdropbordercolor) then
		local r, g, b, a = DF:ParseColors (template.backdropbordercolor)
		self:SetBackdropBorderColor (r, g, b, a)
		self.onleave_backdrop_border_color = {r, g, b, a}
	end
	
	if (template.onentercolor) then
		local r, g, b, a = DF:ParseColors (template.onentercolor)
		self.onenter_backdrop = {r, g, b, a}
	end
	
	if (template.onleavecolor) then
		local r, g, b, a = DF:ParseColors (template.onleavecolor)
		self.onleave_backdrop = {r, g, b, a}
	end
	
	if (template.onenterbordercolor) then
		local r, g, b, a = DF:ParseColors (template.onenterbordercolor)
		self.onenter_backdrop_border_color = {r, g, b, a}
	end
	
	if (template.onleavebordercolor) then
		local r, g, b, a = DF:ParseColors (template.onleavebordercolor)
		self.onleave_backdrop_border_color = {r, g, b, a}
	end
	
	if (template.icon) then
		local i = template.icon
		self:SetIcon (i.texture, i.width, i.height, i.layout, i.texcoord, i.color, i.textdistance, i.leftpadding)
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
--> object constructor

local build_button = function (self)
	self:SetSize (100, 20)
	
	self.text = self:CreateFontString ("$parent_Text", "ARTWORK", "GameFontNormal")
	self.text:SetJustifyH ("CENTER")
	DF:SetFontSize (self.text, 10)
	self.text:SetPoint ("CENTER", self, "CENTER", 0, 0)
	
	self.texture_disabled = self:CreateTexture ("$parent_TextureDisabled", "OVERLAY")
	self.texture_disabled:SetAllPoints()
	self.texture_disabled:Hide()
	self.texture_disabled:SetTexture ("Interface\\Tooltips\\UI-Tooltip-Background")
	
	self:SetScript ("OnDisable", function (self)
		self.texture_disabled:Show()
		self.texture_disabled:SetVertexColor (0, 0, 0)
		self.texture_disabled:SetAlpha (.5)
	end)
	
	self:SetScript ("OnEnable", function (self)
		self.texture_disabled:Hide()
	end)
end

function DF:CreateButton (parent, func, w, h, text, param1, param2, texture, member, name, short_method, button_template, text_template)
	return DF:NewButton (parent, parent, name, member, w, h, func, param1, param2, texture, text, short_method, button_template, text_template)
end

function DF:NewButton (parent, container, name, member, w, h, func, param1, param2, texture, text, short_method, button_template, text_template)
	
	if (not name) then
		name = "DetailsFrameworkButtonNumber" .. DF.ButtonCounter
		DF.ButtonCounter = DF.ButtonCounter + 1
		
	elseif (not parent) then
		return error ("Details! FrameWork: parent not found.", 2)
	end
	if (not container) then
		container = parent
	end
	
	if (name:find ("$parent")) then
		local parentName = DF.GetParentName (parent)
		name = name:gsub ("$parent", parentName)
	end

	local ButtonObject = {type = "button", dframework = true}
	
	if (member) then
		parent [member] = ButtonObject
	end	
	
	if (parent.dframework) then
		parent = parent.widget
	end
	if (container.dframework) then
		container = container.widget
	end
	
	--> default members:
		ButtonObject.is_locked = true
		ButtonObject.container = container
		ButtonObject.options = {OnGrab = false}

	ButtonObject.button = CreateFrame ("button", name, parent)
	DF:Mixin (ButtonObject.button, DF.WidgetFunctions)
	
	build_button (ButtonObject.button)
	
	ButtonObject.widget = ButtonObject.button

	--ButtonObject.button:SetBackdrop ({bgFile = DF.folder .. "background", tileSize = 64, edgeFile = DF.folder .. "border_2", edgeSize = 10, insets = {left = 1, right = 1, top = 1, bottom = 1}})
	ButtonObject.button:SetBackdropColor (0, 0, 0, 0.4)
	ButtonObject.button:SetBackdropBorderColor (1, 1, 1, 1)
	
	if (not APIButtonFunctions) then
		APIButtonFunctions = true
		local idx = getmetatable (ButtonObject.button).__index
		for funcName, funcAddress in pairs (idx) do 
			if (not ButtonMetaFunctions [funcName]) then
				ButtonMetaFunctions [funcName] = function (object, ...)
					local x = loadstring ( "return _G['"..object.button:GetName().."']:"..funcName.."(...)")
					return x (...)
				end
			end
		end
	end

	
	ButtonObject.button:SetWidth (w or 100)
	ButtonObject.button:SetHeight (h or 20)
	ButtonObject.button.MyObject = ButtonObject
	
	ButtonObject.text_overlay = _G [name .. "_Text"]
	ButtonObject.disabled_overlay = _G [name .. "_TextureDisabled"]
	
	ButtonObject.button:SetNormalTexture (texture)
	ButtonObject.button:SetPushedTexture (texture)
	ButtonObject.button:SetDisabledTexture (texture)
	ButtonObject.button:SetHighlightTexture (texture, "ADD")
	
	ButtonObject.button.text:SetText (text)
	ButtonObject.button.text:SetPoint ("center", ButtonObject.button, "center")

	local text_width = ButtonObject.button.text:GetStringWidth()
	if (text_width > w-15 and ButtonObject.button.text:GetText() ~= "") then
		if (short_method == false) then --> if is false, do not use auto resize
			--do nothing
		elseif (not short_method) then --> if the value is omitted, use the default resize
			local new_width = text_width+15
			ButtonObject.button:SetWidth (new_width)
			
		elseif (short_method == 1) then
			local loop = true
			local textsize = 11
			while (loop) do
				if (text_width+15 < w or textsize < 8) then
					loop = false
					break
				else
					DF:SetFontSize (ButtonObject.button.text, textsize)
					text_width = ButtonObject.button.text:GetStringWidth()
					textsize = textsize - 1
				end
			end
			
		elseif (short_method == 2) then
			
		end
	end
	
	ButtonObject.func = func or cleanfunction
	ButtonObject.funcright = cleanfunction
	ButtonObject.param1 = param1
	ButtonObject.param2 = param2
	
	ButtonObject.short_method = short_method
	
	if (text_template) then
		if (text_template.size) then
			DF:SetFontSize (ButtonObject.button.text, text_template.size)
		end
		if (text_template.color) then
			local r, g, b, a = DF:ParseColors (text_template.color)
			ButtonObject.button.text:SetTextColor (r, g, b, a)
		end
		if (text_template.font) then
			local SharedMedia = LibStub:GetLibrary ("LibSharedMedia-3.0")
			local font = SharedMedia:Fetch ("font", text_template.font)
			DF:SetFontFace (ButtonObject.button.text, font)
		end
	end
	
	--> hooks
		ButtonObject.HookList = {
			OnEnter = {},
			OnLeave = {},
			OnHide = {},
			OnShow = {},
			OnMouseDown = {},
			OnMouseUp = {},
		}
	
		ButtonObject.button:SetScript ("OnEnter", OnEnter)
		ButtonObject.button:SetScript ("OnLeave", OnLeave)
		ButtonObject.button:SetScript ("OnHide", OnHide)
		ButtonObject.button:SetScript ("OnShow", OnShow)
		ButtonObject.button:SetScript ("OnMouseDown", OnMouseDown)
		ButtonObject.button:SetScript ("OnMouseUp", OnMouseUp)
		
	_setmetatable (ButtonObject, ButtonMetaFunctions)
	
	if (button_template) then
		ButtonObject:SetTemplate (button_template)
	end
	
	return ButtonObject
	
end

local pickcolor_callback = function (self, r, g, b, a, button)
	a = abs (a-1)
	button.MyObject.color_texture:SetVertexColor (r, g, b, a)
	
	--> safecall
	DF:CoreDispatch ((self:GetName() or "ColorPicker") .. ".pickcolor_callback()", button.MyObject.color_callback, button.MyObject, r, g, b, a)
	button.MyObject:RunHooksForWidget ("OnColorChanged", button.MyObject, r, g, b, a)
end

local pickcolor = function (self, alpha, param2)
	local r, g, b, a = self.MyObject.color_texture:GetVertexColor()
	a = abs (a-1)
	DF:ColorPick (self, r, g, b, a, pickcolor_callback)
end

local color_button_height = 16
local color_button_width = 16

local set_colorpick_color = function (button, r, g, b, a)
	a = a or 1
	button.color_texture:SetVertexColor (r, g, b, a)
end

local colorpick_cancel = function (self)
	ColorPickerFrame:Hide()
end

function DF:CreateColorPickButton (parent, name, member, callback, alpha, button_template)
	return DF:NewColorPickButton (parent, name, member, callback, alpha, button_template)
end

function DF:NewColorPickButton (parent, name, member, callback, alpha, button_template)

	--button
	local button = DF:NewButton (parent, _, name, member, color_button_width, color_button_height, pickcolor, alpha, "param2", nil, nil, nil, button_template)
	button.color_callback = callback
	button.Cancel = colorpick_cancel
	button.SetColor = set_colorpick_color
	
	button.HookList.OnColorChanged = {}
	
	if (not button_template) then
		button:InstallCustomTexture()
		button:SetBackdrop ({edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]], edgeSize = 6,
		bgFile = [[Interface\DialogFrame\UI-DialogBox-Background]], insets = {left = 0, right = 0, top = 0, bottom = 0}})
	end
	
	--textura do fundo
	local background = DF:NewImage (button, nil, color_button_width, color_button_height, nil, nil, nil, "$parentBck")
	--background:SetTexture ([[Interface\AddOns\Details\images\icons]])
	background:SetPoint ("topleft", button.widget, "topleft", 1, -2)
	background:SetPoint ("bottomright", button.widget, "bottomright", -1, 1)
	background:SetTexCoord (0.337890625, 0.390625, 0.625, 0.658203125)
	background:SetDrawLayer ("background", 1)
	
	--textura da cor
	local img = DF:NewImage (button, nil, color_button_width, color_button_height, nil, nil, "color_texture", "$parentTex")
	img:SetColorTexture (1, 1, 1)
	img:SetPoint ("topleft", button.widget, "topleft", 1, -2)
	img:SetPoint ("bottomright", button.widget, "bottomright", -1, 1)
	img:SetDrawLayer ("background", 2)
	
	return button
	
end
