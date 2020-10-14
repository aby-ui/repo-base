
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
local _string_len = string.len --> lua local

local cleanfunction = function() end
local APIDropDownFunctions = false

do
	local metaPrototype = {
		WidgetType = "dropdown",
		SetHook = DF.SetHook,
		HasHook = DF.HasHook,
		ClearHooks = DF.ClearHooks,
		RunHooksForWidget = DF.RunHooksForWidget,

		dversion = DF.dversion,
	}

	--check if there's a metaPrototype already existing
	if (_G[DF.GlobalWidgetControlNames["dropdown"]]) then
		--get the already existing metaPrototype
		local oldMetaPrototype = _G[DF.GlobalWidgetControlNames ["dropdown"]]
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
		_G[DF.GlobalWidgetControlNames ["dropdown"]] = metaPrototype
	end
end

local DropDownMetaFunctions = _G[DF.GlobalWidgetControlNames ["dropdown"]]

------------------------------------------------------------------------------------------------------------
--> metatables

	DropDownMetaFunctions.__call = function (_table, value)
		--> unknow
	end
	
------------------------------------------------------------------------------------------------------------
--> members

	--> selected value
	local gmember_value = function (_object)
		return _object:GetValue()
	end
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
	--> current text
	local gmember_text = function (_object)
		return _object.label:GetText()
	end
	--> menu creation function
	local gmember_function = function (_object)
		return _object:GetFunction()
	end
	--> menu width
	local gmember_menuwidth = function (_object)
		return _rawget (self, "realsizeW")
	end
	--> menu height
	local gmember_menuheight = function (_object)
		return _rawget (self, "realsizeH")
	end
	
	DropDownMetaFunctions.GetMembers = DropDownMetaFunctions.GetMembers or {}
	DropDownMetaFunctions.GetMembers ["value"] = gmember_value
	DropDownMetaFunctions.GetMembers ["text"] = gmember_text
	DropDownMetaFunctions.GetMembers ["shown"] = gmember_shown
	DropDownMetaFunctions.GetMembers ["width"] = gmember_width
	DropDownMetaFunctions.GetMembers ["menuwidth"] = gmember_menuwidth
	DropDownMetaFunctions.GetMembers ["height"] = gmember_height
	DropDownMetaFunctions.GetMembers ["menuheight"] = gmember_menuheight
	DropDownMetaFunctions.GetMembers ["tooltip"] = gmember_tooltip
	DropDownMetaFunctions.GetMembers ["func"] = gmember_function	
	
	DropDownMetaFunctions.__index = function (_table, _member_requested)

		local func = DropDownMetaFunctions.GetMembers [_member_requested]
		if (func) then
			return func (_table, _member_requested)
		end
		
		local fromMe = _rawget (_table, _member_requested)
		if (fromMe) then
			return fromMe
		end
		
		return DropDownMetaFunctions [_member_requested]
	end
	
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
		return _object.dropdown:SetWidth (_value)
	end
	--> frame height
	local smember_height = function (_object, _value)
		return _object.dropdown:SetHeight (_value)
	end	
	--> menu creation function
	local smember_function = function (_object, _value)
		return _object:SetFunction (_value)
	end
	--> menu width
	local smember_menuwidth = function (_object, _value)
		_object:SetMenuSize (_value, nil)
	end
	--> menu height
	local smember_menuheight = function (_object, _value)
		_object:SetMenuSize (nil, _value)
	end
	
	DropDownMetaFunctions.SetMembers = DropDownMetaFunctions.SetMembers or {}
	DropDownMetaFunctions.SetMembers ["tooltip"] = smember_tooltip
	DropDownMetaFunctions.SetMembers ["show"] = smember_show
	DropDownMetaFunctions.SetMembers ["hide"] = smember_hide
	DropDownMetaFunctions.SetMembers ["width"] = smember_width
	DropDownMetaFunctions.SetMembers ["menuwidth"] = smember_menuwidth
	DropDownMetaFunctions.SetMembers ["height"] = smember_height
	DropDownMetaFunctions.SetMembers ["menuheight"] = smember_menuheight
	DropDownMetaFunctions.SetMembers ["func"] = smember_function
	
	DropDownMetaFunctions.__newindex = function (_table, _key, _value)
		local func = DropDownMetaFunctions.SetMembers [_key]
		if (func) then
			return func (_table, _value)
		else
			return _rawset (_table, _key, _value)
		end
	end

------------------------------------------------------------------------------------------------------------

function DropDownMetaFunctions:SetBackdrop(...)
	return self.dropdown:SetBackdrop(...)
end

function DropDownMetaFunctions:SetBackdropColor(...)
	return self.dropdown:SetBackdropColor(...)
end

function DropDownMetaFunctions:SetBackdropBorderColor(...)
	return self.dropdown:SetBackdropBorderColor(...)
end

--> methods
	function DropDownMetaFunctions:IsShown()
		return self.dropdown:IsShown()
	end
	function DropDownMetaFunctions:Show()
		return self.dropdown:Show()
	end
	function DropDownMetaFunctions:Hide()
		return self.dropdown:Hide()
	end

--> menu width and height
	function DropDownMetaFunctions:SetMenuSize (w, h)
		if (w) then
			return _rawset (self, "realsizeW", w)
		end
		if (h) then
			return _rawset (self, "realsizeH", h)
		end
	end
	function DropDownMetaFunctions:GetMenuSize()
		return _rawget (self, "realsizeW"), _rawget (self, "realsizeH")
	end
	
--> function
	function DropDownMetaFunctions:SetFunction (func)
		return _rawset (self, "func", func)
	end
	function DropDownMetaFunctions:GetFunction()
		return _rawget (self, "func")
	end
	
--> value
	function DropDownMetaFunctions:GetValue()
		return _rawget (self, "myvalue")
	end
	function DropDownMetaFunctions:SetValue (value)
		return _rawset (self, "myvalue", value)
	end

--> setpoint
	function DropDownMetaFunctions:SetPoint (v1, v2, v3, v4, v5)
		v1, v2, v3, v4, v5 = DF:CheckPoints (v1, v2, v3, v4, v5, self)
		if (not v1) then
			print ("Invalid parameter for SetPoint")
			return
		end
		return self.widget:SetPoint (v1, v2, v3, v4, v5)
	end

--> sizes
	function DropDownMetaFunctions:SetSize (w, h)
		if (w) then
			self.dropdown:SetWidth (w)
		end
		if (h) then
			return self.dropdown:SetHeight (h)
		end
	end
	
--> tooltip
	function DropDownMetaFunctions:SetTooltip (tooltip)
		if (tooltip) then
			return _rawset (self, "have_tooltip", tooltip)
		else
			return _rawset (self, "have_tooltip", nil)
		end
	end
	function DropDownMetaFunctions:GetTooltip()
		return _rawget (self, "have_tooltip")
	end
	
--> frame levels
	function DropDownMetaFunctions:GetFrameLevel()
		return self.dropdown:GetFrameLevel()
	end
	function DropDownMetaFunctions:SetFrameLevel (level, frame)
		if (not frame) then
			return self.dropdown:SetFrameLevel (level)
		else
			local framelevel = frame:GetFrameLevel (frame) + level
			return self.dropdown:SetFrameLevel (framelevel)
		end
	end

--> frame stratas
	function DropDownMetaFunctions:GetFrameStrata()
		return self.dropdown:GetFrameStrata()
	end
	function DropDownMetaFunctions:SetFrameStrata (strata)
		if (_type (strata) == "table") then
			self.dropdown:SetFrameStrata (strata:GetFrameStrata())
		else
			self.dropdown:SetFrameStrata (strata)
		end
	end
	
--> enabled
	function DropDownMetaFunctions:IsEnabled()
		return self.dropdown:IsEnabled()
	end
	
	function DropDownMetaFunctions:Enable()
		
		self:SetAlpha (1)
		_rawset (self, "lockdown", false)
		
		if (self.OnEnable) then
			self.OnEnable (self)
		end
		--return self.dropdown:Enable()
	end
	
	function DropDownMetaFunctions:Disable()
	
		self:SetAlpha (.4)
		_rawset (self, "lockdown", true)
		
		if (self.OnDisable) then
			self.OnDisable (self)
		end
		--return self.dropdown:Disable()
	end

--> fixed value
	function DropDownMetaFunctions:SetFixedParameter (value)
		_rawset (self, "FixedValue", value)
	end
	
------------------------------------------------------------------------------------------------------------
--> scripts

local last_opened = false

local function isOptionVisible (thisOption)
	if (_type (thisOption.shown) == "boolean" or _type (thisOption.shown) == "function") then
		if (not thisOption.shown) then
			return false
		elseif (not thisOption.shown()) then
			return false
		end
	end
	return true
end

function DropDownMetaFunctions:Refresh()
	--> do a safe call
	local menu =  DF:Dispatch (self.func, self)

	if (#menu == 0) then
		self:NoOption (true)
		self.no_options = true
		return false
		
	elseif (self.no_options) then
		self.no_options = false
		self:NoOption (false)
		self:NoOptionSelected()
		return true
	end

	return true
end

function DropDownMetaFunctions:NoOptionSelected()
	if (self.no_options) then
		return
	end
	self.label:SetText (self.empty_text or "no option selected")
	self.label:SetPoint ("left", self.icon, "right", 2, 0)
	self.label:SetTextColor (1, 1, 1, 0.4)
	if (self.empty_icon) then
		self.icon:SetTexture (self.empty_icon)
	else
		self.icon:SetTexture ([[Interface\COMMON\UI-ModelControlPanel]])
		self.icon:SetTexCoord (0.625, 0.78125, 0.328125, 0.390625)
	end
	self.icon:SetVertexColor (1, 1, 1, 0.4)
	
	self.last_select = nil
end

function DropDownMetaFunctions:NoOption (state)
	if (state) then
		self:Disable()
		self:SetAlpha (0.5)
		self.no_options = true
		self.label:SetText ("no options")
		self.label:SetPoint ("left", self.icon, "right", 2, 0)
		self.label:SetTextColor (1, 1, 1, 0.4)
		self.icon:SetTexture ([[Interface\CHARACTERFRAME\UI-Player-PlayTimeUnhealthy]])
		self.icon:SetTexCoord (0, 1, 0, 1)
		self.icon:SetVertexColor (1, 1, 1, 0.4)		
	else
		self.no_options = false
		self:Enable()
		self:SetAlpha (1)
	end
end

function DropDownMetaFunctions:Select (optionName, byOptionNumber)

	if (type (optionName) == "boolean" and not optionName) then
		self:NoOptionSelected()
		return false
	end

	local menu =  DF:Dispatch (self.func, self)

	if (#menu == 0) then
		self:NoOption (true)
		return true
	else
		self:NoOption (false)
	end
	
	if (byOptionNumber and type (optionName) == "number") then
		if (not menu [optionName]) then --> invalid index
			self:NoOptionSelected()
			return false
		end
		self:Selected (menu [optionName])
		return true
	end
	
	for _, thisMenu in ipairs (menu) do 
		if ( ( thisMenu.label == optionName or thisMenu.value == optionName ) and isOptionVisible (thisMenu)) then
			self:Selected (thisMenu)
			return true
		end
	end
	
	return false
end

function DropDownMetaFunctions:SetEmptyTextAndIcon (text, icon)
	if (text) then
		self.empty_text = text
	end
	if (icon) then
		self.empty_icon = icon
	end

	self:Selected (self.last_select)
end

function DropDownMetaFunctions:Selected (_table)

	if (not _table) then

		--> there is any options?
		if (not self:Refresh()) then
			self.last_select = nil
			return
		end

		--> exists options but none selected
		self:NoOptionSelected()
		return
	end
	
	self.last_select = _table
	self:NoOption (false)
	
	self.label:SetText (_table.label)
	self.icon:SetTexture (_table.icon)
	
	if (_table.icon) then
		self.label:SetPoint ("left", self.icon, "right", 2, 0)
		if (_table.texcoord) then
			self.icon:SetTexCoord (unpack (_table.texcoord))
		else
			self.icon:SetTexCoord (0, 1, 0, 1)
		end
		
		if (_table.iconcolor) then
			if (type (_table.iconcolor) == "string") then
				self.icon:SetVertexColor (DF:ParseColors (_table.iconcolor))
			else
				self.icon:SetVertexColor (unpack (_table.iconcolor))
			end
		else
			self.icon:SetVertexColor (1, 1, 1, 1)
		end
		
		self.icon:SetSize (self:GetHeight()-2, self:GetHeight()-2)
	else
		self.label:SetPoint ("left", self.label:GetParent(), "left", 4, 0)
	end

	if (_table.statusbar) then
		self.statusbar:SetTexture (_table.statusbar)
		if (_table.statusbarcolor) then
			self.statusbar:SetVertexColor (unpack(_table.statusbarcolor))
		end
	else
		self.statusbar:SetTexture ([[Interface\Tooltips\CHATBUBBLE-BACKGROUND]])
	end
	
	if (_table.color) then
		local _value1, _value2, _value3, _value4 = DF:ParseColors (_table.color)
		self.label:SetTextColor (_value1, _value2, _value3, _value4)
	else
		self.label:SetTextColor (1, 1, 1, 1)
	end
	
	if (_table.font) then
		self.label:SetFont (_table.font, 10)
	else
		self.label:SetFont ("GameFontHighlightSmall", 10)
	end
	
	self:SetValue (_table.value)

end

function DetailsFrameworkDropDownOptionClick (button)

	--> update name and icon on main frame
	button.object:Selected (button.table)
	
	--> close menu frame
		button.object:Close()
		
	--> exec function if any
		if (button.table.onclick) then
		
			local success, errorText = pcall (button.table.onclick, button:GetParent():GetParent():GetParent().MyObject, button.object.FixedValue, button.table.value)
			if (not success) then
				error ("Details! Framework: dropdown " .. button:GetParent():GetParent():GetParent().MyObject:GetName() ..  " error: " .. errorText)
			end
			
			button:GetParent():GetParent():GetParent().MyObject:RunHooksForWidget ("OnOptionSelected", button:GetParent():GetParent():GetParent().MyObject, button.object.FixedValue, button.table.value)
		end
		
	--> set the value of selected option in main object
		button.object.myvalue = button.table.value
		button.object.myvaluelabel = button.table.label
end

function DropDownMetaFunctions:Open()
	self.dropdown.dropdownframe:Show()
	self.dropdown.dropdownborder:Show()
	--self.dropdown.arrowTexture:SetTexture ("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Down")
	self.opened = true
	if (last_opened) then
		last_opened:Close()
	end
	last_opened = self
end

function DropDownMetaFunctions:Close()
	--> when menu is being close, just hide the border and the script will call back this again
	if (self.dropdown.dropdownborder:IsShown()) then
		self.dropdown.dropdownborder:Hide()
		return
	end
	self.dropdown.dropdownframe:Hide()
	--self.dropdown.arrowTexture:SetTexture ("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Up")
	
	local selectedTexture = _G [self:GetName() .. "_ScrollFrame_ScrollChild_SelectedTexture"]
	selectedTexture:Hide()
	 
	self.opened = false
	last_opened = false
end

--> close by escape key
function DetailsFrameworkDropDownOptionsFrameOnHide (frame)
	frame:GetParent().MyObject:Close()
end

function DetailsFrameworkDropDownOptionOnEnter (frame)
	if (frame.table.desc) then
		GameCooltip2:Preset (2)
		GameCooltip2:AddLine (frame.table.desc)
		if (frame.table.descfont) then
			GameCooltip2:SetOption ("TextFont", frame.table.descfont)
		end
		
		if (frame.table.tooltipwidth) then
			GameCooltip2:SetOption ("FixedWidth", frame.table.tooltipwidth)
		end
		
		GameCooltip2:SetHost (frame, "topleft", "topright", 10, 0)
		
		GameCooltip2:ShowCooltip (nil, "tooltip")
		frame.tooltip = true
	end
	frame:GetParent().mouseover:SetPoint ("left", frame)
	frame:GetParent().mouseover:Show()
end

function DetailsFrameworkDropDownOptionOnLeave (frame)
	if (frame.table.desc) then
		GameCooltip2:ShowMe (false)
	end
	frame:GetParent().mouseover:Hide()
end

function DetailsFrameworkDropDownOnMouseDown (button)
	
	local object = button.MyObject

	if (not object.opened and not _rawget (object, "lockdown")) then --> click to open
		
		local menu = object:func()
		object.builtMenu = menu
		
		local frame_witdh = object.realsizeW
		
		if (menu [1]) then
			--> build menu
			
			local scrollFrame = _G [button:GetName() .. "_ScrollFrame"]
			local scrollChild = _G [button:GetName() .. "_ScrollFrame_ScrollChild"]
			local scrollBorder = _G [button:GetName() .. "_Border"]
			local selectedTexture = _G [button:GetName() .. "_ScrollFrame_ScrollChild_SelectedTexture"]
			local mouseOverTexture = _G [button:GetName() .. "_ScrollFrame_ScrollChild_MouseOverTexture"]
			
			local i = 1
			local showing = 0
			local currentText = button.text:GetText() or ""
			local currentIndex
			
			if (object.OnMouseDownHook) then
				local interrupt = object.OnMouseDownHook (button, buttontype, menu, scrollFrame, scrollChild, selectedTexture)
				if (interrupt) then
					return
				end
			end
			
			for tindex, _table in ipairs (menu) do 
				
				local show = isOptionVisible (_table)

				if (show) then
					local _this_row = object.menus [i]
					showing = showing + 1
					
					if (not _this_row) then
					
						local name = button:GetName() .. "Row" .. i
						local parent = scrollChild
						
						_this_row = DF:CreateDropdownButton (parent, name)
						local anchor_i = i-1
						_this_row:SetPoint ("topleft", parent, "topleft", 1, (-anchor_i*20)-0)
						_this_row:SetPoint ("topright", parent, "topright", 0, (-anchor_i*20)-0)
						_this_row.object = object
						object.menus [i] = _this_row
					end
					
					_this_row:SetFrameStrata (_this_row:GetParent():GetFrameStrata())
					_this_row:SetFrameLevel (_this_row:GetParent():GetFrameLevel()+10)
					
					_this_row.icon:SetTexture (_table.icon)
					if (_table.icon) then
					
						_this_row.label:SetPoint ("left", _this_row.icon, "right", 5, 0)
						
						if (_table.texcoord) then
							_this_row.icon:SetTexCoord (unpack (_table.texcoord))
						else
							_this_row.icon:SetTexCoord (0, 1, 0, 1)
						end
						
						if (_table.iconcolor) then
							if (type (_table.iconcolor) == "string") then
								_this_row.icon:SetVertexColor (DF:ParseColors (_table.iconcolor))
							else
								_this_row.icon:SetVertexColor (unpack (_table.iconcolor))
							end
						else
							_this_row.icon:SetVertexColor (1, 1, 1, 1)
						end
					else
						_this_row.label:SetPoint ("left", _this_row.statusbar, "left", 2, 0)
					end
					
					if (_table.iconsize) then
						_this_row.icon:SetSize (_table.iconsize[1], _table.iconsize[2])
					else
						_this_row.icon:SetSize (20, 20)
					end
					
					if (_table.font) then
						_this_row.label:SetFont (_table.font, 10.5)
					else
						_this_row.label:SetFont ("GameFontHighlightSmall", 10.5)
					end
					
					if (_table.statusbar) then
						_this_row.statusbar:SetTexture (_table.statusbar)
						if (_table.statusbarcolor) then
							_this_row.statusbar:SetVertexColor (unpack(_table.statusbarcolor))
						end
					else
						_this_row.statusbar:SetTexture ([[Interface\Tooltips\CHATBUBBLE-BACKGROUND]])
					end

					--an extra button in the right side of the row
					--run a given function passing the button in the first argument, the row on 2nd and the _table in the 3rd
					if (_table.rightbutton) then
						DF:Dispatch (_table.rightbutton, _this_row.rightButton, _this_row, _table)
					else
						_this_row.rightButton:Hide()
					end
					
					_this_row.label:SetText (_table.label)
					
					if (currentText and currentText == _table.label) then
						if (_table.icon) then
							selectedTexture:SetPoint ("left", _this_row.icon, "left", -3, 0)
						else
							selectedTexture:SetPoint ("left", _this_row.statusbar, "left", 0, 0)
						end
						
						selectedTexture:Show()
						selectedTexture:SetVertexColor (1, 1, 1, .3)
						selectedTexture:SetTexCoord (0, 29/32, 5/32, 27/32)
						
						currentIndex = tindex
						currentText = nil
					end
					
					if (_table.color) then
						local _value1, _value2, _value3, _value4 = DF:ParseColors (_table.color)
						_this_row.label:SetTextColor (_value1, _value2, _value3, _value4)
					else
						_this_row.label:SetTextColor (1, 1, 1, 1)
					end
					
					_this_row.table = _table
					
					local labelwitdh = _this_row.label:GetStringWidth()
					if (labelwitdh+40 > frame_witdh) then
						frame_witdh = labelwitdh+40
					end
					_this_row:Show()
					
					i = i + 1
				end
				
			end
			
			if (currentText) then
				selectedTexture:Hide()
			else
				selectedTexture:SetWidth (frame_witdh-20)
			end
			
			for i = showing+1, #object.menus do
				object.menus [i]:Hide()
			end
			
			local size = object.realsizeH
			
			if (showing*20 > size) then
				--show scrollbar and setup scroll
				object:ShowScroll()
				scrollFrame:EnableMouseWheel (true)
				object.scroll:Altura (size-35)
				object.scroll:SetMinMaxValues (0, (showing*20) - size + 2)
				--width
				scrollBorder:SetWidth (frame_witdh+20)
				scrollFrame:SetWidth (frame_witdh+20)
				scrollChild:SetWidth (frame_witdh+20)
				--height
				scrollBorder:SetHeight (size+2)
				scrollFrame:SetHeight (size+2)
				scrollChild:SetHeight ((showing*20)+20)
				--mouse over texture
				mouseOverTexture:SetWidth (frame_witdh-7)
				--selected
				selectedTexture:SetWidth (frame_witdh - 9)
				
				for index, row in ipairs (object.menus) do
					row:SetPoint ("topright", scrollChild, "topright", -22, ((-index-1)*20)-5)
				end
				
			else
				--hide scrollbar and disable wheel
				object:HideScroll()
				scrollFrame:EnableMouseWheel (false)
				--width
				scrollBorder:SetWidth (frame_witdh)
				scrollFrame:SetWidth (frame_witdh)
				scrollChild:SetWidth (frame_witdh)
				--height
				scrollBorder:SetHeight ((showing*20) + 1)
				scrollFrame:SetHeight ((showing*20) + 1)
				--mouse over texture
				mouseOverTexture:SetWidth (frame_witdh - 1)
				--selected
				selectedTexture:SetWidth (frame_witdh - 1)
				
				for index, row in ipairs (object.menus) do
					row:SetPoint ("topright", scrollChild, "topright", -5, ((-index-1)*20)-5)
				end
			end

			if (object.myvaluelabel and currentIndex and scrollFrame.slider:IsShown()) then
				object.scroll:SetValue (max ((currentIndex*20) - 80, 0))
			else
				object.scroll:SetValue (0)
			end
			
			object:Open()
			
		else
			--> clear menu
			
		end
	
	else --> click to close

		object:Close()
	end
	
end

function DetailsFrameworkDropDownOnEnter (self)

	local capsule = self.MyObject
	local kill = capsule:RunHooksForWidget ("OnEnter", self, capsule)
	if (kill) then
		return
	end

	if (self.MyObject.onenter_backdrop) then
		self:SetBackdropColor (unpack (self.MyObject.onenter_backdrop))
	else
		self:SetBackdropColor (.2, .2, .2, .2)
	end
	
	if (self.MyObject.onenter_backdrop_border_color) then
		self:SetBackdropBorderColor (unpack (self.MyObject.onenter_backdrop_border_color))
	end
	
	self.arrowTexture2:Show()
	
	if (self.MyObject.have_tooltip) then 
		GameCooltip2:Preset (2)
		
		if (type (self.MyObject.have_tooltip) == "function") then
			GameCooltip2:AddLine (self.MyObject.have_tooltip() or "")
		else
			GameCooltip2:AddLine (self.MyObject.have_tooltip)
		end

		GameCooltip2:SetOwner (self)
		GameCooltip2:ShowCooltip()
	end

end

function DetailsFrameworkDropDownOnLeave (self)
	local capsule = self.MyObject
	local kill = capsule:RunHooksForWidget ("OnLeave", self, capsule)
	if (kill) then
		return
	end

	if (self.MyObject.onleave_backdrop) then
		self:SetBackdropColor (unpack (self.MyObject.onleave_backdrop))
	else
		self:SetBackdropColor (1, 1, 1, .5)
	end
	
	if (self.MyObject.onleave_backdrop_border_color) then
		self:SetBackdropBorderColor (unpack (self.MyObject.onleave_backdrop_border_color))
	end
	
	self.arrowTexture2:Hide()
	
	if (self.MyObject.have_tooltip) then 
		GameCooltip2:ShowMe (false)
	end
end

function DetailsFrameworkDropDownOnSizeChanged (self, w, h)
	self.MyObject.label:SetSize (self:GetWidth()-40, 10)
end

function DetailsFrameworkDropDownOnShow (self)
	local capsule = self.MyObject
	local kill = capsule:RunHooksForWidget ("OnShow", self, capsule)
	if (kill) then
		return
	end
end

function DetailsFrameworkDropDownOnHide (self)
	local capsule = self.MyObject
	local kill = capsule:RunHooksForWidget ("OnHide", self, capsule)
	if (kill) then
		return
	end
	
	self.MyObject:Close()
end

function DF:BuildDropDownFontList (on_click, icon, icon_texcoord, icon_size)
	local t = {}
	local SharedMedia = LibStub:GetLibrary ("LibSharedMedia-3.0")
	for name, fontPath in pairs (SharedMedia:HashTable ("font")) do 
		t[#t+1] = {value = name, label = name, onclick = on_click, icon = icon, iconsize = icon_size, texcoord = icon_texcoord, font = fontPath, descfont = "abcdefg ABCDEFG"}
	end
	table.sort (t, function (t1, t2) return t1.label < t2.label end)
	return t
end

------------------------------------------------------------------------------------------------------------
function DropDownMetaFunctions:SetTemplate (template)

	self.template = template

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

	self:RefreshDropIcon()
end

function DropDownMetaFunctions:RefreshDropIcon()
	local template = self.template

	if (not template) then
		return
	end

	if (template.dropicon) then
		self.dropdown.arrowTexture:SetTexture(template.dropicon)
		self.dropdown.arrowTexture2:SetTexture(template.dropicon)

		if (template.dropiconsize) then
			self.dropdown.arrowTexture:SetSize(unpack(template.dropiconsize))
			self.dropdown.arrowTexture2:SetSize(unpack(template.dropiconsize))
		end

		if (template.dropiconcoords) then
			self.dropdown.arrowTexture:SetTexCoord(unpack(template.dropiconcoords))
		else
			self.dropdown.arrowTexture:SetTexCoord(0, 1, 0, 1)
		end

		if (template.dropiconpoints) then
			self.dropdown.arrowTexture:ClearAllPoints()
			self.dropdown.arrowTexture2:ClearAllPoints()
			self.dropdown.arrowTexture:SetPoint("right", self.dropdown, "right", unpack(template.dropiconpoints))
			self.dropdown.arrowTexture2:SetPoint("right", self.dropdown, "right", unpack(template.dropiconpoints))
		end

		
	end
end

------------------------------------------------------------------------------------------------------------
--> object constructor

function DF:CreateDropDown (parent, func, default, w, h, member, name, template)
	return DF:NewDropDown (parent, parent, name, member, w, h, func, default, template)
end

function DF:NewDropDown (parent, container, name, member, w, h, func, default, template)

	if (not name) then
		name = "DetailsFrameworkDropDownNumber" .. DF.DropDownCounter
		DF.DropDownCounter = DF.DropDownCounter + 1
		
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
	
	local DropDownObject = {type = "dropdown", dframework = true}
	
	if (member) then
		parent [member] = DropDownObject
	end	
	
	if (parent.dframework) then
		parent = parent.widget
	end
	if (container.dframework) then
		container = container.widget
	end	
	
	if (default == nil) then
		default = 1
	end

	--> default members:
		--> misc
		DropDownObject.container = container
		
	DropDownObject.dropdown = DF:CreateNewDropdownFrame (parent, name)
	
	DropDownObject.widget = DropDownObject.dropdown
	
	DropDownObject.__it = {nil, nil}

	if (not APIDropDownFunctions) then
		APIDropDownFunctions = true
		local idx = getmetatable (DropDownObject.dropdown).__index
		for funcName, funcAddress in pairs (idx) do 
			if (not DropDownMetaFunctions [funcName]) then
				DropDownMetaFunctions [funcName] = function (object, ...)
					local x = loadstring ( "return _G['"..object.dropdown:GetName().."']:"..funcName.."(...)")
					return x (...)
				end
			end
		end
	end
	
	DropDownObject.dropdown.MyObject = DropDownObject
	
	DropDownObject.dropdown:SetWidth (w)
	DropDownObject.dropdown:SetHeight (h)

	DropDownObject.func = func
	DropDownObject.realsizeW = 150
	DropDownObject.realsizeH = 150
	DropDownObject.FixedValue = nil
	DropDownObject.opened = false
	DropDownObject.menus = {}
	DropDownObject.myvalue = nil
	
	DropDownObject.label = _G [name .. "_Text"]
	
	DropDownObject.icon = _G [name .. "_IconTexture"]
	DropDownObject.statusbar = _G [name .. "_StatusBarTexture"]
	DropDownObject.select = _G [name .. "_SelectedTexture"]
	
	local scroll = _G [DropDownObject.dropdown:GetName() .. "_ScrollFrame"]

	DropDownObject.scroll = DF:NewScrollBar (scroll, _G [DropDownObject.dropdown:GetName() .. "_ScrollFrame".."_ScrollChild"], -18, -18)
	DF:ReskinSlider (scroll)
	
	function DropDownObject:HideScroll()
		scroll.baixo:Hide()
		scroll.cima:Hide()
		scroll.slider:Hide()
	end
	function DropDownObject:ShowScroll()
		scroll.baixo:Show()
		scroll.cima:Show()
		scroll.slider:Show()
	end
	
	DropDownObject:HideScroll()
	DropDownObject.label:SetSize (DropDownObject.dropdown:GetWidth()-40, 10)
	
	DropDownObject.HookList = {
		OnEnter = {},
		OnLeave = {},
		OnHide = {},
		OnShow = {},
		OnOptionSelected = {},
	}	
	
	DropDownObject.dropdown:SetScript ("OnShow", DetailsFrameworkDropDownOnShow)
	DropDownObject.dropdown:SetScript ("OnHide", DetailsFrameworkDropDownOnHide)
	DropDownObject.dropdown:SetScript ("OnEnter", DetailsFrameworkDropDownOnEnter)
	DropDownObject.dropdown:SetScript ("OnLeave", DetailsFrameworkDropDownOnLeave)
	
	--> setup class
	_setmetatable (DropDownObject, DropDownMetaFunctions)

	--> initialize first menu selected
	if (type (default) == "string") then
		DropDownObject:Select (default)
		
	elseif (type (default) == "number") then
		if (not DropDownObject:Select (default)) then
			DropDownObject:Select (default, true)
		end
	end

	if (template) then
		DropDownObject:SetTemplate(template)
	end
	
	return DropDownObject

end

local default_backdrop = {bgFile = [[Interface\DialogFrame\UI-DialogBox-Background]], edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]], 
edgeSize = 1, tile = true, tileSize = 16, insets = {left = 1, right = 1, top = 0, bottom = 1}}
local border_backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, insets = {left = 0, right = 0, top = 0, bottom = 0}}
local child_backdrop = {bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 256, insets = {left = 0, right = 0, top = 0, bottom = 0}}

function DF:CreateNewDropdownFrame (parent, name)
	local f = CreateFrame ("button", name, parent,"BackdropTemplate")
	f:SetBackdrop (default_backdrop)
	f:SetSize (150, 20)
	
	local statusbar = f:CreateTexture ("$parent_StatusBarTexture", "BACKGROUND")
	statusbar:SetPoint ("topleft", f, "topleft", 0, 0)
	statusbar:SetPoint ("bottomright", f, "bottomright", 0, 0)
	f.statusbar = statusbar
	
	local icon = f:CreateTexture ("$parent_IconTexture", "ARTWORK")
	icon:SetPoint ("left", f, "left", 2, 0)
	icon:SetSize (20, 20)
	icon:SetTexture ([[Interface\COMMON\UI-ModelControlPanel]])
	icon:SetTexCoord (0.625, 0.78125, 0.328125, 0.390625)
	icon:SetVertexColor (1, 1, 1, 0.4)
	f.icon = icon
	
	local text = f:CreateFontString ("$parent_Text", "ARTWORK", "GameFontHighlightSmall")
	text:SetPoint ("left", icon, "right", 5, 0)
	text:SetJustifyH ("left")
	text:SetText ("no option selected")
	text:SetTextColor (1, 1, 1, 0.4)
	DF:SetFontSize (text, 10)
	f.text = text
	
	local arrow = f:CreateTexture ("$parent_ArrowTexture2", "OVERLAY")
	arrow:SetPoint ("right", f, "right", 5, -1)
	arrow:SetBlendMode ("ADD")
	arrow:SetTexture ([[Interface\Buttons\UI-ScrollBar-ScrollDownButton-Highlight]])
	arrow:Hide()
	arrow:SetSize (32, 28)
	f.arrowTexture2 = arrow
	
	local buttonTexture = f:CreateTexture ("$parent_ArrowTexture", "OVERLAY")
	buttonTexture:SetPoint ("right", f, "right", 5, -1)
	buttonTexture:SetTexture ([[Interface\Buttons\UI-ScrollBar-ScrollDownButton-Up]])
	buttonTexture:SetSize (32, 28)
	f.arrowTexture = buttonTexture
	
	--scripts
	f:SetScript ("OnSizeChanged", DetailsFrameworkDropDownOnSizeChanged)
	f:SetScript ("OnMouseDown", DetailsFrameworkDropDownOnMouseDown)
	
	--on load
	f:SetBackdropColor (1, 1, 1, .5)
	f.arrowTexture:SetDrawLayer ("OVERLAY", 1)
	f.arrowTexture2:SetDrawLayer ("OVERLAY", 2)
	
	--dropdown
	local border = CreateFrame ("frame", "$Parent_Border", f,"BackdropTemplate")
	border:Hide()
	border:SetFrameStrata ("FULLSCREEN")
	border:SetSize (150, 150)
	border:SetPoint ("topleft", f, "bottomleft")
	border:SetBackdrop (border_backdrop)
	border:SetScript ("OnHide", DetailsFrameworkDropDownOptionsFrameOnHide)
	border:SetBackdropColor (0, 0, 0, 0.92)
	border:SetBackdropBorderColor (0, 0, 0, 1)
	f.dropdownborder = border
	
	local scroll = CreateFrame ("ScrollFrame", "$Parent_ScrollFrame", f,"BackdropTemplate")
	scroll:Hide()
	scroll:SetFrameStrata ("FULLSCREEN")
	scroll:SetSize (150, 150)
	scroll:SetPoint ("topleft", f, "bottomleft", 0, 0)
	f.dropdownframe = scroll

	local child = CreateFrame ("frame", "$Parent_ScrollChild", scroll,"BackdropTemplate")
	child:SetSize (150, 150)
	child:SetPoint ("topleft", scroll, "topleft", 0, 0)
	child:SetBackdrop (child_backdrop)
	child:SetBackdropColor (0, 0, 0, 1)
	
	DF:ApplyStandardBackdrop (child)
	
	local selected = child:CreateTexture ("$parent_SelectedTexture", "BACKGROUND")
	selected:SetSize (150, 16)
	selected:Hide()
	selected:SetPoint ("left", child, "left", 2, 0)
	selected:SetTexture ([[Interface\RAIDFRAME\Raid-Bar-Hp-Fill]])
	child.selected = selected
	
	local mouseover = child:CreateTexture ("$parent_MouseOverTexture", "ARTWORK")
	mouseover:SetBlendMode ("ADD")
	mouseover:Hide()
	mouseover:SetTexture ([[Interface\Buttons\UI-Listbox-Highlight]])
	mouseover:SetSize (150, 15)
	mouseover:SetPoint ("left", child, "left", 2, 0)
	child.mouseover = mouseover
	
	scroll:SetScrollChild (child)
	tinsert (UISpecialFrames, f.dropdownborder:GetName())
	tinsert (UISpecialFrames, f.dropdownframe:GetName())
	
	return f
end

function DF:CreateDropdownButton (parent, name)

	local f = CreateFrame ("button", name, parent,"BackdropTemplate")
	f:SetSize (150, 20)

	local statusbar = f:CreateTexture ("$parent_StatusBarTexture", "ARTWORK")
	statusbar:SetPoint ("topleft", f, "topleft", 0, 0)
	statusbar:SetPoint ("bottomright", f, "bottomright", 0, 0)
	statusbar:SetSize (150, 20)
	statusbar:SetTexture ([[Interface\Tooltips\UI-Tooltip-Background]])
	f.statusbar = statusbar
	
	local icon = f:CreateTexture ("$parent_IconTexture", "OVERLAY")
	icon:SetPoint ("left", f, "left", 2, 0)
	icon:SetSize (20, 20)
	icon:SetTexture ([[Interface\ICONS\Spell_ChargePositive]])
	f.icon = icon
	
	local text = f:CreateFontString ("$parent_Text", "OVERLAY", "GameFontHighlightSmall")
	text:SetPoint ("left", icon, "right", 5, 0)
	text:SetJustifyH ("left")
	DF:SetFontSize (text, 10)
	f.label = text
	
	local rightButton = DF:CreateButton(f, function()end, 16, 16, "", 0, 0, "", "rightButton", "$parentRightButton", nil, DF:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
	rightButton:SetPoint("right", f, "right", -2, 0)
	rightButton:Hide()

	f:SetScript ("OnMouseDown", DetailsFrameworkDropDownOptionClick)
	f:SetScript ("OnEnter", DetailsFrameworkDropDownOptionOnEnter)
	f:SetScript ("OnLeave", DetailsFrameworkDropDownOptionOnLeave)

	return f
end
