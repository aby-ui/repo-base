
local DF = _G ["DetailsFramework"]
if (not DF or not DetailsFrameworkCanLoad) then
	return
end

local _
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
		local oldMetaPrototype = _G[DF.GlobalWidgetControlNames["dropdown"]]
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
		_G[DF.GlobalWidgetControlNames["dropdown"]] = metaPrototype
	end
end

local DropDownMetaFunctions = _G[DF.GlobalWidgetControlNames["dropdown"]]

------------------------------------------------------------------------------------------------------------
--metatables

	DropDownMetaFunctions.__call = function(_table, value)
		--unknown
	end

------------------------------------------------------------------------------------------------------------
--> members

	--selected value
	local gmember_value = function(object)
		return object:GetValue()
	end
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
	--current text
	local gmember_text = function(object)
		return object.label:GetText()
	end
	--menu creation function
	local gmember_function = function(object)
		return object:GetFunction()
	end
	--menu width
	local gmember_menuwidth = function(object)
		return rawget(object, "realsizeW")
	end
	--menu height
	local gmember_menuheight = function(object)
		return rawget(object, "realsizeH")
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

	DropDownMetaFunctions.__index = function(object, memberName)
		local func = DropDownMetaFunctions.GetMembers[memberName]
		if (func) then
			return func(object, memberName)
		end

		local fromMe = rawget(object, memberName)
		if (fromMe) then
			return fromMe
		end

		return DropDownMetaFunctions[memberName]
	end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	--tooltip
	local smember_tooltip = function(object, value)
		return object:SetTooltip(value)
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
		return object.dropdown:SetWidth(value)
	end
	--frame height
	local smember_height = function(object, value)
		return object.dropdown:SetHeight(value)
	end	
	--menu creation function
	local smember_function = function(object, value)
		return object:SetFunction(value)
	end
	--menu width
	local smember_menuwidth = function(object, value)
		object:SetMenuSize(value, nil)
	end
	--menu height
	local smember_menuheight = function(object, value)
		object:SetMenuSize(nil, value)
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

	DropDownMetaFunctions.__newindex = function(object, key, value)
		local func = DropDownMetaFunctions.SetMembers[key]
		if (func) then
			return func(object, value)
		else
			return rawset(object, key, value)
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
	function DropDownMetaFunctions:SetMenuSize(width, height)
		if (width) then
			return rawset(self, "realsizeW", width)
		end
		if (height) then
			return rawset(self, "realsizeH", height)
		end
	end
	function DropDownMetaFunctions:GetMenuSize()
		return rawget(self, "realsizeW"), rawget(self, "realsizeH")
	end

--> function
	function DropDownMetaFunctions:SetFunction(func)
		return rawset(self, "func", func)
	end
	function DropDownMetaFunctions:GetFunction()
		return rawget(self, "func")
	end

--> value
	function DropDownMetaFunctions:GetValue()
		return rawget(self, "myvalue")
	end
	function DropDownMetaFunctions:SetValue(value)
		return rawset(self, "myvalue", value)
	end

--> setpoint
	function DropDownMetaFunctions:SetPoint(v1, v2, v3, v4, v5)
		v1, v2, v3, v4, v5 = DF:CheckPoints(v1, v2, v3, v4, v5, self)
		if (not v1) then
			print("Invalid parameter for SetPoint")
			return
		end
		return self.widget:SetPoint(v1, v2, v3, v4, v5)
	end

--> sizes
	function DropDownMetaFunctions:SetSize(width, height)
		if (width) then
			self.dropdown:SetWidth(width)
		end
		if (height) then
			return self.dropdown:SetHeight(height)
		end
	end

--> tooltip
	function DropDownMetaFunctions:SetTooltip(tooltip)
		if (tooltip) then
			return rawset(self, "have_tooltip", tooltip)
		else
			return rawset(self, "have_tooltip", nil)
		end
	end
	function DropDownMetaFunctions:GetTooltip()
		return rawget(self, "have_tooltip")
	end

--> frame levels
	function DropDownMetaFunctions:GetFrameLevel()
		return self.dropdown:GetFrameLevel()
	end
	function DropDownMetaFunctions:SetFrameLevel(level, frame)
		if (not frame) then
			return self.dropdown:SetFrameLevel(level)
		else
			local framelevel = frame:GetFrameLevel(frame) + level
			return self.dropdown:SetFrameLevel(framelevel)
		end
	end

--> frame stratas
	function DropDownMetaFunctions:GetFrameStrata()
		return self.dropdown:GetFrameStrata()
	end
	function DropDownMetaFunctions:SetFrameStrata(strata)
		if (type(strata) == "table") then
			self.dropdown:SetFrameStrata(strata:GetFrameStrata())
		else
			self.dropdown:SetFrameStrata(strata)
		end
	end

--> enabled
	function DropDownMetaFunctions:IsEnabled()
		return self.dropdown:IsEnabled()
	end

	function DropDownMetaFunctions:Enable()

		self:SetAlpha(1)
		rawset(self, "lockdown", false)

		if (self.OnEnable) then
			self.OnEnable(self)
		end
	end

	function DropDownMetaFunctions:Disable()
		self:SetAlpha(.4)
		rawset(self, "lockdown", true)

		if (self.OnDisable) then
			self.OnDisable(self)
		end
	end

--> fixed value
	function DropDownMetaFunctions:SetFixedParameter(value)
		rawset(self, "FixedValue", value)
	end

------------------------------------------------------------------------------------------------------------
--> scripts

local lastOpened = false

local isOptionVisible = function(self, thisOption)
	if (type(thisOption.shown) == "boolean") then
		return thisOption.shown

	elseif (type(thisOption.shown) == "function") then
		local result = DF:Dispatch(thisOption.shown, self)
		return result
	end

	return true
end

--return a table containing all frames of options in the menu
function DropDownMetaFunctions:GetMenuFrames() --not tested
	if (self.MyObject) then
		self = self.MyObject
	end
	return self.menus
end

function DropDownMetaFunctions:GetFrameForOption(optionsTable, value) --not tested
	if (self.MyObject) then
		self = self.MyObject
	end

	if (type(value) == "string") then
		for i = 1, #optionsTable do
			local thisOption = optionsTable[i]
			if (thisOption.value == value or thisOption.label == value) then
				return self.menus[i]
			end
		end

	elseif (type(value) == "number") then
		return self.menus[value]
	end
end

function DropDownMetaFunctions:Refresh()
	local optionsTable = DF:Dispatch(self.func, self)

	if (#optionsTable == 0) then
		self:NoOption(true)
		self.no_options = true
		return false

	elseif (self.no_options) then
		self.no_options = false
		self:NoOption(false)
		self:NoOptionSelected()
		return true
	end

	return true
end

function DropDownMetaFunctions:NoOptionSelected()
	if (self.no_options) then
		return
	end

	self.label:SetText(self.empty_text or "no option selected")
	self.label:SetPoint("left", self.icon, "right", 2, 0)
	self.label:SetTextColor(1, 1, 1, 0.4)

	if (self.empty_icon) then
		self.icon:SetTexture(self.empty_icon)
	else
		self.icon:SetTexture([[Interface\COMMON\UI-ModelControlPanel]])
		self.icon:SetTexCoord(0.625, 0.78125, 0.328125, 0.390625)
	end

	self.icon:SetVertexColor(1, 1, 1, 0.4)
	self.last_select = nil
end

function DropDownMetaFunctions:NoOption(state)
	if (state) then
		self:Disable()
		self:SetAlpha(0.5)
		self.no_options = true
		self.label:SetText("no options")
		self.label:SetPoint("left", self.icon, "right", 2, 0)
		self.label:SetTextColor(1, 1, 1, 0.4)
		self.icon:SetTexture([[Interface\CHARACTERFRAME\UI-Player-PlayTimeUnhealthy]])
		self.icon:SetTexCoord(0, 1, 0, 1)
		self.icon:SetVertexColor(1, 1, 1, 0.4)
	else
		self.no_options = false
		self:Enable()
		self:SetAlpha(1)
	end
end

--@button: the frame button of the option
--button.table refers to the optionTable
local runCallbackFunctionForButton = function(button)
	--exec function if any
	if (button.table.onclick) then
		--need: the the callback func, the object of the dropdown (capsule), the object (capsule) of the button to get FixedValue and the last need the value of the optionTable
		local success, errorText = pcall(button.table.onclick, button:GetParent():GetParent():GetParent().MyObject, button.object.FixedValue, button.table.value)
		if (not success) then
			error ("Details! Framework: dropdown " .. button:GetParent():GetParent():GetParent().MyObject:GetName() ..  " error: " .. errorText)
		end
		button:GetParent():GetParent():GetParent().MyObject:RunHooksForWidget ("OnOptionSelected", button:GetParent():GetParent():GetParent().MyObject, button.object.FixedValue, button.table.value)
	end
end

local canRunCallbackFunctionForOption = function(canRunCallback, optionTable, dropdownObject)
	if (canRunCallback) then
		local fixedValue = rawget(dropdownObject, "FixedValue")
		if (optionTable.onclick) then
			local success, errorText = pcall(optionTable.onclick, dropdownObject, fixedValue, optionTable.value)
			if (not success) then
				error ("Details! Framework: dropdown " .. dropdownObject:GetName() ..  " error: " .. errorText)
			end
			dropdownObject:RunHooksForWidget("OnOptionSelected", dropdownObject, fixedValue, optionTable.value)
		end
	end
end

--if onlyShown is true it'll first create a table with visible options that has .shown and then select in this table the index passed (if byOptionNumber)
--@optionName: value or string shown in the name of the option
--@byOptionNumber: the option name is considered a number and selects the index of the menu
--@onlyShown: the selected option index when selecting by option number must be visible
--@runCallback: run the callback (onclick) function after selecting the option
function DropDownMetaFunctions:Select(optionName, byOptionNumber, onlyShown, runCallback)
	if (type(optionName) == "boolean" and not optionName) then
		self:NoOptionSelected()
		return false
	end

	local optionsTable = DF:Dispatch(self.func, self)

	if (#optionsTable == 0) then
		self:NoOption(true)
		return true
	else
		self:NoOption(false)
	end

	if (byOptionNumber and type(optionName) == "number") then
		local optionIndex = optionName

		if (onlyShown) then
			local onlyShownOptions = {}

			for i = 1, #optionsTable do
				local thisOption = optionsTable[i]
				if (thisOption.shown) then
					--only accept a function or a boolean into shown member
					if (type(thisOption.shown) == "function") then
						local isOptionShown = DF:Dispatch(thisOption.shown, self)
						if (isOptionShown) then
							onlyShownOptions[#onlyShownOptions+1] = thisOption
						end

					elseif (type(thisOption.shown) == "boolean" and thisOption.shown) then
						onlyShownOptions[#onlyShownOptions+1] = thisOption
					end
				end
			end

			local optionTableSelected = onlyShownOptions[optionIndex]

			if (not optionTableSelected) then
				self:NoOptionSelected()
				return false
			end

			self:Selected(optionTableSelected)
			canRunCallbackFunctionForOption(runCallback, optionTableSelected, self)
			return true
		else
			local optionTableSelected = optionsTable[optionIndex]

			--is an invalid index?
			if (not optionTableSelected) then
				self:NoOptionSelected()
				return false
			end

			self:Selected(optionTableSelected)
			canRunCallbackFunctionForOption(runCallback, optionTableSelected, self)
			return true
		end
	else
		for i = 1, #optionsTable do
			local thisOption = optionsTable[i]
			if ((thisOption.label == optionName or thisOption.value == optionName) and isOptionVisible(self, thisOption)) then
				self:Selected(thisOption)
				canRunCallbackFunctionForOption(runCallback, thisOption, self)
				return true
			end
		end
	end

	return false
end

function DropDownMetaFunctions:SetEmptyTextAndIcon(text, icon)
	if (text) then
		self.empty_text = text
	end

	if (icon) then
		self.empty_icon = icon
	end

	self:Selected(self.last_select)
end

function DropDownMetaFunctions:Selected(thisOption)
	if (not thisOption) then
		--does not have any options?
		if (not self:Refresh()) then
			self.last_select = nil
			return
		end

		--exists options but none selected
		self:NoOptionSelected()
		return
	end

	self.last_select = thisOption
	self:NoOption(false)

	self.label:SetText(thisOption.label)
	self.icon:SetTexture(thisOption.icon)

	if (thisOption.icon) then
		self.label:SetPoint("left", self.icon, "right", 2, 0)
		if (thisOption.texcoord) then
			self.icon:SetTexCoord(unpack(thisOption.texcoord))
		else
			self.icon:SetTexCoord(0, 1, 0, 1)
		end

		if (thisOption.iconcolor) then
			local r, g, b, a = DF:ParseColors(thisOption.iconcolor)
			self.icon:SetVertexColor(r, g, b, a)
		else
			self.icon:SetVertexColor(1, 1, 1, 1)
		end

		self.icon:SetSize(self:GetHeight()-4, self:GetHeight()-4)
	else
		self.label:SetPoint("left", self.label:GetParent(), "left", 4, 0)
	end

	if (thisOption.statusbar) then
		self.statusbar:SetTexture(thisOption.statusbar)
		if (thisOption.statusbarcolor) then
			self.statusbar:SetVertexColor(unpack(thisOption.statusbarcolor))
		end
	else
		self.statusbar:SetTexture([[Interface\Tooltips\CHATBUBBLE-BACKGROUND]])
	end

	if (thisOption.color) then
		local r, g, b, a = DF:ParseColors(thisOption.color)
		self.label:SetTextColor(r, g, b, a)
	else
		self.label:SetTextColor(1, 1, 1, 1)
	end

	if (thisOption.font) then
		self.label:SetFont(thisOption.font, 10)
	else
		self.label:SetFont("GameFontHighlightSmall", 10)
	end

	self:SetValue(thisOption.value)
end

function DetailsFrameworkDropDownOptionClick(button)
	--update name and icon on main frame
	button.object:Selected(button.table)

	--close menu frame
	button.object:Close()

	--run callbacks
	runCallbackFunctionForButton(button)

	--set the value of selected option in main object
	button.object.myvalue = button.table.value
	button.object.myvaluelabel = button.table.label
end

function DropDownMetaFunctions:Open()
	self.dropdown.dropdownframe:Show()
	self.dropdown.dropdownborder:Show()
	self.opened = true
	if (lastOpened) then
		lastOpened:Close()
	end
	lastOpened = self
end

function DropDownMetaFunctions:Close()
	--when menu is being close, just hide the border and the script will call back this again
	if (self.dropdown.dropdownborder:IsShown()) then
		self.dropdown.dropdownborder:Hide()
		return
	end
	self.dropdown.dropdownframe:Hide()

	local selectedTexture = _G[self:GetName() .. "_ScrollFrame_ScrollChild_SelectedTexture"]
	selectedTexture:Hide()

	self.opened = false
	lastOpened = false
end

--close by escape key
function DetailsFrameworkDropDownOptionsFrameOnHide(self)
	self:GetParent().MyObject:Close()
end

function DetailsFrameworkDropDownOptionOnEnter(self)
	if (self.table.desc) then
		GameCooltip2:Preset(2)
		GameCooltip2:AddLine(self.table.desc)
		if (self.table.descfont) then
			GameCooltip2:SetOption("TextFont", self.table.descfont)
		end

		if (self.table.tooltipwidth) then
			GameCooltip2:SetOption("FixedWidth", self.table.tooltipwidth)
		end

		GameCooltip2:SetHost(self, "topleft", "topright", 10, 0)

		GameCooltip2:ShowCooltip(nil, "tooltip")
		self.tooltip = true
	end

	self:GetParent().mouseover:SetPoint("left", self)
	self:GetParent().mouseover:Show()
end

function DetailsFrameworkDropDownOptionOnLeave(frame)
	if (frame.table.desc) then
		GameCooltip2:ShowMe(false)
	end
	frame:GetParent().mouseover:Hide()
end

--@button is the raw button frame, object is the button capsule
function DetailsFrameworkDropDownOnMouseDown(button, buttontype)
	local object = button.MyObject

	--click to open
	if (not object.opened and not rawget(object, "lockdown")) then
		local optionsTable = DF:Dispatch(object.func, object)
		object.builtMenu = optionsTable
		local frameWitdh = object.realsizeW

		--has at least 1 option?
		if (optionsTable and optionsTable[1]) then
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
				local interrupt = object.OnMouseDownHook(button, buttontype, optionsTable, scrollFrame, scrollChild, selectedTexture)
				if (interrupt) then
					return
				end
			end

			for tindex, thisOption in ipairs(optionsTable) do
				local show = isOptionVisible(button, thisOption)

				if (show) then
					local thisOptionFrame = object.menus[i]
					showing = showing + 1

					if (not thisOptionFrame) then
						local name = button:GetName() .. "Row" .. i
						local parent = scrollChild

						thisOptionFrame = DF:CreateDropdownButton(parent, name)
						local optionIndex = i - 1
						thisOptionFrame:SetPoint("topleft", parent, "topleft", 1, (-optionIndex*20)-0)
						thisOptionFrame:SetPoint("topright", parent, "topright", 0, (-optionIndex*20)-0)
						thisOptionFrame.object = object
						object.menus[i] = thisOptionFrame
					end

					thisOptionFrame:SetFrameStrata(thisOptionFrame:GetParent():GetFrameStrata())
					thisOptionFrame:SetFrameLevel(thisOptionFrame:GetParent():GetFrameLevel()+10)

					thisOptionFrame.icon:SetTexture(thisOption.icon)
					if (thisOption.icon) then
						thisOptionFrame.label:SetPoint("left", thisOptionFrame.icon, "right", 5, 0)

						if (thisOption.texcoord) then
							thisOptionFrame.icon:SetTexCoord(unpack(thisOption.texcoord))
						else
							thisOptionFrame.icon:SetTexCoord(0, 1, 0, 1)
						end

						if (thisOption.iconcolor) then
							local r, g, b, a = DF:ParseColors(thisOption.iconcolor)
							thisOptionFrame.icon:SetVertexColor(r, g, b, a)
						else
							thisOptionFrame.icon:SetVertexColor(1, 1, 1, 1)
						end
					else
						thisOptionFrame.label:SetPoint("left", thisOptionFrame.statusbar, "left", 2, 0)
					end

					if (thisOption.iconsize) then
						thisOptionFrame.icon:SetSize(thisOption.iconsize[1], thisOption.iconsize[2])
					else
						thisOptionFrame.icon:SetSize(thisOptionFrame:GetHeight()-6, thisOptionFrame:GetHeight()-6)
					end

					if (thisOption.font) then
						thisOptionFrame.label:SetFont(thisOption.font, 10.5)
					else
						thisOptionFrame.label:SetFont("GameFontHighlightSmall", 10.5)
					end

					if (thisOption.statusbar) then
						thisOptionFrame.statusbar:SetTexture(thisOption.statusbar)
						if (thisOption.statusbarcolor) then
							thisOptionFrame.statusbar:SetVertexColor(unpack(thisOption.statusbarcolor))
						end
					else
						thisOptionFrame.statusbar:SetTexture([[Interface\Tooltips\CHATBUBBLE-BACKGROUND]])
					end

					--an extra button in the right side of the row
					--run a given function passing the button in the first argument, the row on 2nd and the thisOption in the 3rd
					if (thisOption.rightbutton) then
						DF:Dispatch(thisOption.rightbutton, thisOptionFrame.rightButton, thisOptionFrame, thisOption)
					else
						thisOptionFrame.rightButton:Hide()
					end

					thisOptionFrame.label:SetText(thisOption.label)

					if (currentText and currentText == thisOption.label) then
						if (thisOption.icon) then
							selectedTexture:SetPoint("left", thisOptionFrame.icon, "left", -3, 0)
						else
							selectedTexture:SetPoint("left", thisOptionFrame.statusbar, "left", 0, 0)
						end

						selectedTexture:Show()
						selectedTexture:SetVertexColor(1, 1, 1, .3)
						selectedTexture:SetTexCoord(0, 29/32, 5/32, 27/32)

						currentIndex = tindex
						currentText = nil
					end

					if (thisOption.color) then
						local r, g, b, a = DF:ParseColors(thisOption.color)
						thisOptionFrame.label:SetTextColor(r, g, b, a)
					else
						thisOptionFrame.label:SetTextColor(1, 1, 1, 1)
					end

					thisOptionFrame.table = thisOption

					local labelwitdh = thisOptionFrame.label:GetStringWidth()
					if (labelwitdh+40 > frameWitdh) then
						frameWitdh = labelwitdh+40
					end
					thisOptionFrame:Show()

					i = i + 1
				end
			end

			if (currentText) then
				selectedTexture:Hide()
			else
				selectedTexture:SetWidth(frameWitdh-20)
			end

			for i = showing + 1, #object.menus do
				object.menus[i]:Hide()
			end

			local size = object.realsizeH

			if (showing*20 > size) then
				--show scrollbar and setup scroll
				object:ShowScroll()
				scrollFrame:EnableMouseWheel(true)
				object.scroll:Altura(size-35) --height
				object.scroll:SetMinMaxValues(0, (showing*20) - size + 2)

				--width
				scrollBorder:SetWidth(frameWitdh+20)
				scrollFrame:SetWidth(frameWitdh+20)
				scrollChild:SetWidth(frameWitdh+20)

				--height
				scrollBorder:SetHeight(size+2)
				scrollFrame:SetHeight(size+2)
				scrollChild:SetHeight((showing*20)+20)

				--mouse over texture
				mouseOverTexture:SetWidth(frameWitdh-7)

				--selected
				selectedTexture:SetWidth(frameWitdh - 9)

				for index, row in ipairs(object.menus) do
					row:SetPoint("topright", scrollChild, "topright", -22, ((-index-1)*20)-5)
				end
			else
				--hide scrollbar and disable wheel
				object:HideScroll()
				scrollFrame:EnableMouseWheel(false)
				--width
				scrollBorder:SetWidth(frameWitdh)
				scrollFrame:SetWidth(frameWitdh)
				scrollChild:SetWidth(frameWitdh)
				--height
				scrollBorder:SetHeight((showing*20) + 1)
				scrollFrame:SetHeight((showing*20) + 1)
				--mouse over texture
				mouseOverTexture:SetWidth(frameWitdh - 1)
				--selected
				selectedTexture:SetWidth(frameWitdh - 1)

				for index, row in ipairs(object.menus) do
					row:SetPoint("topright", scrollChild, "topright", -5, ((-index-1)*20)-5)
				end
			end

			if (object.myvaluelabel and currentIndex and scrollFrame.slider:IsShown()) then
				object.scroll:SetValue(max((currentIndex*20) - 80, 0))
			else
				object.scroll:SetValue(0)
			end

			object:Open()
		else
			--clear menu
		end
	else
		--click to close
		object:Close()
	end
end

function DetailsFrameworkDropDownOnEnter(self)
	local capsule = self.MyObject
	local kill = capsule:RunHooksForWidget("OnEnter", self, capsule)
	if (kill) then
		return
	end

	if (self.MyObject.onenter_backdrop) then
		self:SetBackdropColor(unpack(self.MyObject.onenter_backdrop))
	else
		self:SetBackdropColor(.2, .2, .2, .2)
	end

	if (self.MyObject.onenter_backdrop_border_color) then
		self:SetBackdropBorderColor(unpack(self.MyObject.onenter_backdrop_border_color))
	end

	self.arrowTexture2:Show()
	if (self.MyObject.have_tooltip) then
		GameCooltip2:Preset(2)

		if (type(self.MyObject.have_tooltip) == "function") then
			GameCooltip2:AddLine(self.MyObject.have_tooltip() or "")
		else
			GameCooltip2:AddLine(self.MyObject.have_tooltip)
		end

		GameCooltip2:SetOwner(self)
		GameCooltip2:ShowCooltip()
	end
end

function DetailsFrameworkDropDownOnLeave(self)
	local capsule = self.MyObject
	local kill = capsule:RunHooksForWidget("OnLeave", self, capsule)
	if (kill) then
		return
	end

	if (self.MyObject.onleave_backdrop) then
		self:SetBackdropColor(unpack(self.MyObject.onleave_backdrop))
	else
		self:SetBackdropColor(1, 1, 1, .5)
	end

	if (self.MyObject.onleave_backdrop_border_color) then
		self:SetBackdropBorderColor(unpack(self.MyObject.onleave_backdrop_border_color))
	end

	self.arrowTexture2:Hide()

	if (self.MyObject.have_tooltip) then
		GameCooltip2:ShowMe(false)
	end
end

function DetailsFrameworkDropDownOnSizeChanged(self)
	self.MyObject.label:SetSize(self:GetWidth()-40, 10)
end

function DetailsFrameworkDropDownOnShow(self)
	local capsule = self.MyObject
	local kill = capsule:RunHooksForWidget("OnShow", self, capsule)
	if (kill) then
		return
	end
end

function DetailsFrameworkDropDownOnHide(self)
	local capsule = self.MyObject
	local kill = capsule:RunHooksForWidget("OnHide", self, capsule)
	if (kill) then
		return
	end
	self.MyObject:Close()
end

function DF:BuildDropDownFontList(onClick, icon, iconTexcoord, iconSize)
	local t = {}
	local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
	for name, fontPath in pairs(SharedMedia:HashTable("font")) do
		t[#t+1] = {value = name, label = name, onclick = onClick, icon = icon, iconsize = iconSize, texcoord = iconTexcoord, font = fontPath, descfont = "abcdefg ABCDEFG"}
	end
	table.sort(t, function(t1, t2) return t1.label < t2.label end)
	return t
end

------------------------------------------------------------------------------------------------------------
--> template

function DropDownMetaFunctions:SetTemplate(template)
	self.template = template

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

function DF:CreateDropDown(parent, func, default, width, height, member, name, template)
	return DF:NewDropDown(parent, parent, name, member, width, height, func, default, template)
end

function DF:NewDropDown(parent, container, name, member, width, height, func, default, template)
	if (not name) then
		name = "DetailsFrameworkDropDownNumber" .. DF.DropDownCounter
		DF.DropDownCounter = DF.DropDownCounter + 1

	elseif (not parent) then
		return error("Details! FrameWork: parent not found.", 2)
	end

	if (not container) then
		container = parent
	end

	if (name:find("$parent")) then
		local parentName = DF.GetParentName(parent)
		name = name:gsub("$parent", parentName)
	end

	local dropDownObject = {type = "dropdown", dframework = true}

	if (member) then
		parent[member] = dropDownObject
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

	dropDownObject.dropdown = DF:CreateNewDropdownFrame(parent, name)
	dropDownObject.dropdown:SetWidth(width)
	dropDownObject.dropdown:SetHeight(height)

	dropDownObject.container = container
	dropDownObject.widget = dropDownObject.dropdown
	dropDownObject.dropdown.MyObject = dropDownObject

	if (not APIDropDownFunctions) then
		APIDropDownFunctions = true
		local idx = getmetatable(dropDownObject.dropdown).__index
		for funcName, funcAddress in pairs(idx) do
			if (not DropDownMetaFunctions[funcName]) then
				DropDownMetaFunctions[funcName] = function(object, ...)
					local x = loadstring( "return _G['"..object.dropdown:GetName().."']:"..funcName.."(...)")
					return x(...)
				end
			end
		end
	end

	dropDownObject.func = func
	dropDownObject.realsizeW = 150
	dropDownObject.realsizeH = 150
	dropDownObject.FixedValue = nil
	dropDownObject.opened = false
	dropDownObject.menus = {}
	dropDownObject.myvalue = nil
	dropDownObject.label = 	_G[name .. "_Text"]
	dropDownObject.icon = 	_G[name .. "_IconTexture"]
	dropDownObject.statusbar = _G[name .. "_StatusBarTexture"]
	dropDownObject.select = _G[name .. "_SelectedTexture"]

	local scroll = _G[dropDownObject.dropdown:GetName() .. "_ScrollFrame"]
	dropDownObject.scroll = DF:NewScrollBar(scroll, _G[dropDownObject.dropdown:GetName() .. "_ScrollFrame" .. "_ScrollChild"], -18, -18)
	DF:ReskinSlider(scroll)

	function dropDownObject:HideScroll()
		scroll.baixo:Hide()
		scroll.cima:Hide()
		scroll.slider:Hide()
	end

	function dropDownObject:ShowScroll()
		scroll.baixo:Show()
		scroll.cima:Show()
		scroll.slider:Show()
	end

	dropDownObject:HideScroll()
	dropDownObject.label:SetSize(dropDownObject.dropdown:GetWidth()-40, 10)

	--hook list
	dropDownObject.HookList = {
		OnEnter = {},
		OnLeave = {},
		OnHide = {},
		OnShow = {},
		OnOptionSelected = {},
	}

	--set default scripts
	dropDownObject.dropdown:SetScript("OnShow", DetailsFrameworkDropDownOnShow)
	dropDownObject.dropdown:SetScript("OnHide", DetailsFrameworkDropDownOnHide)
	dropDownObject.dropdown:SetScript("OnEnter", DetailsFrameworkDropDownOnEnter)
	dropDownObject.dropdown:SetScript("OnLeave", DetailsFrameworkDropDownOnLeave)

	setmetatable(dropDownObject, DropDownMetaFunctions)

	--initialize first menu selected
	if (type(default) == "string") then
		dropDownObject:Select(default)
	elseif (type(default) == "number") then
		if (not dropDownObject:Select(default)) then
			dropDownObject:Select(default, true)
		end
	end

	if (template) then
		dropDownObject:SetTemplate(template)
	end

	return dropDownObject
end

local defaultBackdrop = {bgFile = [[Interface\DialogFrame\UI-DialogBox-Background]], edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]], 
edgeSize = 1, tile = true, tileSize = 16, insets = {left = 1, right = 1, top = 0, bottom = 1}}
local borderBackdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, insets = {left = 0, right = 0, top = 0, bottom = 0}}
local childBackdrop = {bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 256, insets = {left = 0, right = 0, top = 0, bottom = 0}}

function DF:CreateNewDropdownFrame(parent, name)
	local f = CreateFrame("button", name, parent, "BackdropTemplate")
	f:SetBackdrop(defaultBackdrop)
	f:SetBackdropColor(1, 1, 1, .5)
	f:SetSize(150, 20)

	local statusbar = f:CreateTexture("$parent_StatusBarTexture", "BACKGROUND")
	statusbar:SetPoint("topleft", f, "topleft", 0, 0)
	statusbar:SetPoint("bottomright", f, "bottomright", 0, 0)
	f.statusbar = statusbar

	local icon = f:CreateTexture("$parent_IconTexture", "ARTWORK")
	icon:SetPoint("left", f, "left", 2, 0)
	icon:SetSize(20, 20)
	icon:SetTexture([[Interface\COMMON\UI-ModelControlPanel]])
	icon:SetTexCoord(0.625, 0.78125, 0.328125, 0.390625)
	icon:SetVertexColor(1, 1, 1, 0.4)
	f.icon = icon

	local text = f:CreateFontString("$parent_Text", "ARTWORK", "GameFontHighlightSmall")
	text:SetPoint("left", icon, "right", 5, 0)
	text:SetJustifyH("left")
	text:SetText("no option selected")
	text:SetTextColor(1, 1, 1, 0.4)
	DF:SetFontSize(text, 10)
	f.text = text

	local arrowHightlight = f:CreateTexture ("$parent_ArrowTexture2", "OVERLAY", nil, 2)
	arrowHightlight:SetPoint ("right", f, "right", 5, -1)
	arrowHightlight:SetBlendMode ("ADD")
	arrowHightlight:SetTexture ([[Interface\Buttons\UI-ScrollBar-ScrollDownButton-Highlight]])
	arrowHightlight:Hide()
	arrowHightlight:SetSize (32, 28)
	f.arrowTexture2 = arrowHightlight

	local arrowTexture = f:CreateTexture("$parent_ArrowTexture", "OVERLAY", nil, 1)
	arrowTexture:SetPoint("right", f, "right", 5, -1)
	arrowTexture:SetTexture([[Interface\Buttons\UI-ScrollBar-ScrollDownButton-Up]])
	arrowTexture:SetSize(32, 28)
	f.arrowTexture = arrowTexture

	--scripts
	f:SetScript ("OnSizeChanged", DetailsFrameworkDropDownOnSizeChanged)
	f:SetScript ("OnMouseDown", DetailsFrameworkDropDownOnMouseDown)

	--dropdown
	local border = CreateFrame("frame", "$Parent_Border", f, "BackdropTemplate")
	border:Hide()
	border:SetFrameStrata("FULLSCREEN")
	border:SetSize(150, 150)
	border:SetPoint("topleft", f, "bottomleft", 0, 0)
	border:SetBackdrop(borderBackdrop)
	border:SetScript("OnHide", DetailsFrameworkDropDownOptionsFrameOnHide)
	border:SetBackdropColor(0, 0, 0, 0.92)
	border:SetBackdropBorderColor(0, 0, 0, 1)
	f.dropdownborder = border

	local scroll = CreateFrame("ScrollFrame", "$Parent_ScrollFrame", f, "BackdropTemplate")
	scroll:SetFrameStrata("FULLSCREEN")
	scroll:SetSize(150, 150)
	scroll:SetPoint("topleft", f, "bottomleft", 0, 0)
	scroll:Hide()
	f.dropdownframe = scroll

	local child = CreateFrame("frame", "$Parent_ScrollChild", scroll, "BackdropTemplate")
	child:SetSize(150, 150)
	child:SetPoint("topleft", scroll, "topleft", 0, 0)
	child:SetBackdrop(childBackdrop)
	child:SetBackdropColor (0, 0, 0, 1)

	local backgroundTexture = child:CreateTexture(nil, "background")
	backgroundTexture:SetAllPoints()
	backgroundTexture:SetColorTexture(0, 0, 0, 1)

	DF:ApplyStandardBackdrop(child)

	local selected = child:CreateTexture("$parent_SelectedTexture", "BACKGROUND")
	selected:SetSize(150, 16)
	selected:SetPoint("left", child, "left", 2, 0)
	selected:SetTexture([[Interface\RAIDFRAME\Raid-Bar-Hp-Fill]])
	selected:Hide()
	child.selected = selected

	local mouseover = child:CreateTexture("$parent_MouseOverTexture", "ARTWORK")
	mouseover:SetBlendMode("ADD")
	mouseover:SetTexture([[Interface\Buttons\UI-Listbox-Highlight]])
	mouseover:SetSize(150, 15)
	mouseover:SetPoint("left", child, "left", 2, 0)
	mouseover:Hide()
	child.mouseover = mouseover

	scroll:SetScrollChild(child)
	tinsert(UISpecialFrames, f.dropdownborder:GetName())
	--tinsert(UISpecialFrames, f.dropdownframe:GetName()) --not adding this solves an issue with ConsolePort addon and stackoverflows on Hide...

	return f
end

function DF:CreateDropdownButton(parent, name)
	local f = CreateFrame("button", name, parent, "BackdropTemplate")
	f:SetSize(150, 20)

	local statusbar = f:CreateTexture("$parent_StatusBarTexture", "ARTWORK")
	statusbar:SetPoint("topleft", f, "topleft", 0, 0)
	statusbar:SetPoint("bottomright", f, "bottomright", 0, 0)
	statusbar:SetTexture([[Interface\Tooltips\UI-Tooltip-Background]])
	f.statusbar = statusbar

	local icon = f:CreateTexture("$parent_IconTexture", "OVERLAY")
	icon:SetPoint("left", f, "left", 2, 0)
	icon:SetSize(20, 20)
	icon:SetTexture([[Interface\ICONS\Spell_ChargePositive]])
	f.icon = icon

	local text = f:CreateFontString("$parent_Text", "OVERLAY", "GameFontHighlightSmall")
	text:SetPoint("left", icon, "right", 5, 0)
	text:SetJustifyH("left")
	DF:SetFontSize(text, 10)
	f.label = text

	local rightButton = DF:CreateButton(f, function()end, 16, 16, "", 0, 0, "", "rightButton", "$parentRightButton", nil, DF:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
	rightButton:SetPoint("right", f, "right", -2, 0)
	rightButton:Hide()

	f:SetScript("OnMouseDown", DetailsFrameworkDropDownOptionClick)
	f:SetScript("OnEnter", DetailsFrameworkDropDownOptionOnEnter)
	f:SetScript("OnLeave", DetailsFrameworkDropDownOptionOnLeave)

	return f
end
