
local DF = _G ["DetailsFramework"]
if (not DF or not DetailsFrameworkCanLoad) then
	return
end

local _
local loadedAPIDropDownFunctions = false

do
	local metaPrototype = {
		WidgetType = "dropdown",
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

DF:Mixin(DropDownMetaFunctions, DF.SetPointMixin)
DF:Mixin(DropDownMetaFunctions, DF.FrameMixin)
DF:Mixin(DropDownMetaFunctions, DF.TooltipHandlerMixin)
DF:Mixin(DropDownMetaFunctions, DF.ScriptHookMixin)

------------------------------------------------------------------------------------------------------------
--metatables

	DropDownMetaFunctions.__call = function(object, value)
		--unknown
	end

------------------------------------------------------------------------------------------------------------
--members
	--selected value
	local gmemberValue = function(object)
		return object:GetValue()
	end

	--tooltip
	local gmemberTooltip = function(object)
		return object:GetTooltip()
	end

	--shown
	local gmemberShown = function(object)
		return object:IsShown()
	end

	--frame width
	local gmemberWidth = function(object)
		return object.button:GetWidth()
	end

	--frame height
	local gmemberHeight = function(object)
		return object.button:GetHeight()
	end

	--current text
	local gmemberText = function(object)
		return object.label:GetText()
	end

	--menu creation function
	local gmemberFunction = function(object)
		return object:GetFunction()
	end

	--menu width
	local gmemberMenuWidth = function(object)
		return rawget(object, "realsizeW")
	end

	--menu height
	local gmemberMenuHeight = function(object)
		return rawget(object, "realsizeH")
	end

	DropDownMetaFunctions.GetMembers = DropDownMetaFunctions.GetMembers or {}
	DropDownMetaFunctions.GetMembers["value"] = gmemberValue
	DropDownMetaFunctions.GetMembers["text"] = gmemberText
	DropDownMetaFunctions.GetMembers["shown"] = gmemberShown
	DropDownMetaFunctions.GetMembers["width"] = gmemberWidth
	DropDownMetaFunctions.GetMembers["menuwidth"] = gmemberMenuWidth
	DropDownMetaFunctions.GetMembers["height"] = gmemberHeight
	DropDownMetaFunctions.GetMembers["menuheight"] = gmemberMenuHeight
	DropDownMetaFunctions.GetMembers["tooltip"] = gmemberTooltip
	DropDownMetaFunctions.GetMembers["func"] = gmemberFunction

	DropDownMetaFunctions.__index = function(object, key)
		local func = DropDownMetaFunctions.GetMembers[key]
		if (func) then
			return func(object, key)
		end

		local alreadyHaveKey = rawget(object, key)
		if (alreadyHaveKey) then
			return alreadyHaveKey
		end

		return DropDownMetaFunctions[key]
	end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	--tooltip
	local smemberTooltip = function(object, value)
		return object:SetTooltip(value)
	end

	--show
	local smemberShow = function(object, value)
		if (value) then
			return object:Show()
		else
			return object:Hide()
		end
	end

	--hide
	local smemberHide = function(object, value)
		if (not value) then
			return object:Show()
		else
			return object:Hide()
		end
	end

	--frame width
	local smemberWidth = function(object, value)
		return object.dropdown:SetWidth(value)
	end

	--frame height
	local smemberHeight = function(object, value)
		return object.dropdown:SetHeight(value)
	end

	--menu creation function
	local smemberFunction = function(object, value)
		return object:SetFunction(value)
	end

	--menu width
	local smemberMenuWidth = function(object, value)
		object:SetMenuSize(value, nil)
	end

	--menu height
	local smemberMenuHeight = function(object, value)
		object:SetMenuSize(nil, value)
	end

	DropDownMetaFunctions.SetMembers = DropDownMetaFunctions.SetMembers or {}
	DropDownMetaFunctions.SetMembers["tooltip"] = smemberTooltip
	DropDownMetaFunctions.SetMembers["show"] = smemberShow
	DropDownMetaFunctions.SetMembers["hide"] = smemberHide
	DropDownMetaFunctions.SetMembers["width"] = smemberWidth
	DropDownMetaFunctions.SetMembers["menuwidth"] = smemberMenuWidth
	DropDownMetaFunctions.SetMembers["height"] = smemberHeight
	DropDownMetaFunctions.SetMembers["menuheight"] = smemberMenuHeight
	DropDownMetaFunctions.SetMembers["func"] = smemberFunction

	DropDownMetaFunctions.__newindex = function(object, key, value)
		local func = DropDownMetaFunctions.SetMembers[key]
		if (func) then
			return func(object, value)
		else
			return rawset(object, key, value)
		end
	end

------------------------------------------------------------------------------------------------------------

--menu width and height
	function DropDownMetaFunctions:SetMenuSize(width, height)
		if (width) then
			rawset(self, "realsizeW", width)
		end
		if (height) then
			rawset(self, "realsizeH", height)
		end
	end

	function DropDownMetaFunctions:GetMenuSize()
		return rawget(self, "realsizeW"), rawget(self, "realsizeH")
	end

--function
	function DropDownMetaFunctions:SetFunction(func)
		return rawset(self, "func", func)
	end

	function DropDownMetaFunctions:GetFunction()
		return rawget(self, "func")
	end

--value
	function DropDownMetaFunctions:GetValue()
		return rawget(self, "myvalue")
	end

	function DropDownMetaFunctions:SetValue(value)
		return rawset(self, "myvalue", value)
	end

--frame levels
	function DropDownMetaFunctions:SetFrameLevel(level, frame)
		if (not frame) then
			return self.dropdown:SetFrameLevel(level)
		else
			local framelevel = frame:GetFrameLevel(frame) + level
			return self.dropdown:SetFrameLevel(framelevel)
		end
	end

--enabled
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

--fixed value
	function DropDownMetaFunctions:SetFixedParameter(value)
		rawset(self, "FixedValue", value)
	end

------------------------------------------------------------------------------------------------------------
--scripts

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
			error("Details! Framework: dropdown " .. button:GetParent():GetParent():GetParent().MyObject:GetName() ..  " error: " .. errorText)
		end
		button:GetParent():GetParent():GetParent().MyObject:RunHooksForWidget("OnOptionSelected", button:GetParent():GetParent():GetParent().MyObject, button.object.FixedValue, button.table.value)
	end
end

local canRunCallbackFunctionForOption = function(canRunCallback, optionTable, dropdownObject)
	if (canRunCallback) then
		local fixedValue = rawget(dropdownObject, "FixedValue")
		if (optionTable.onclick) then
			local success, errorText = pcall(optionTable.onclick, dropdownObject, fixedValue, optionTable.value)
			if (not success) then
				error("Details! Framework: dropdown " .. dropdownObject:GetName() ..  " error: " .. errorText)
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

	if (thisOption.centerTexture) then
		self.dropdown.centerTexture:SetTexture(thisOption.centerTexture)
	else
		self.dropdown.centerTexture:SetTexture("")
	end

	if (thisOption.rightTexture) then
		self.dropdown.rightTexture:SetTexture(thisOption.rightTexture)
	else
		self.dropdown.rightTexture:SetTexture("")
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

--on click on any option in the dropdown
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

--on click on the dropdown show the menu frame with the options to select
function DropDownMetaFunctions:Open()
	self.dropdown.dropdownframe:Show()
	self.dropdown.dropdownborder:Show()

	self.opened = true
	if (lastOpened) then
		lastOpened:Close()
	end
	lastOpened = self
end

--close the menu showing the options
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

--on enter an option in the menu dropdown
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

	if (self.table.audiocue) then
		if (DF.CurrentSoundHandle) then
			StopSound(DF.CurrentSoundHandle, 0.1)
		end

		local willPlay, soundHandle = PlaySoundFile(self.table.audiocue, "Master")
		if (willPlay) then
			DF.CurrentSoundHandle = soundHandle
		end
	end

	self:GetParent().mouseover:SetPoint("left", self)
	self:GetParent().mouseover:Show()
end

--on leave an option on the menu dropdown
function DetailsFrameworkDropDownOptionOnLeave(frame)
	if (frame.table.desc) then
		GameCooltip2:ShowMe(false)
	end
	frame:GetParent().mouseover:Hide()
end

--@button is the raw button frame, object is the button capsule
--click on the main dropdown frame (not the menu options popup)
function DetailsFrameworkDropDownOnMouseDown(button, buttontype)
	local object = button.MyObject

	--click to open
	if (not object.opened and not rawget(object, "lockdown")) then
		local optionsTable = DF:Dispatch(object.func, object)
		object.builtMenu = optionsTable
		local frameWitdh = object.realsizeW

		--has at least 1 option?
		if (optionsTable and optionsTable[1]) then
			local scrollFrame = _G[button:GetName() .. "_ScrollFrame"]
			local scrollChild = _G[button:GetName() .. "_ScrollFrame_ScrollChild"]
			local scrollBorder = _G[button:GetName() .. "_Border"]
			local selectedTexture = _G[button:GetName() .. "_ScrollFrame_ScrollChild_SelectedTexture"]
			local mouseOverTexture = _G[button:GetName() .. "_ScrollFrame_ScrollChild_MouseOverTexture"]

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
				local bIsOptionVisible = isOptionVisible(button, thisOption)

				if (bIsOptionVisible) then
					local thisOptionFrame = object.menus[i]
					showing = showing + 1

					if (not thisOptionFrame) then
						local name = button:GetName() .. "Row" .. i
						local parent = scrollChild

						thisOptionFrame = DF:CreateDropdownButton(parent, name)
						local optionIndex = i - 1
						thisOptionFrame:SetPoint("topleft", parent, "topleft", 1, (-optionIndex * 20))
						thisOptionFrame:SetPoint("topright", parent, "topright", 0, (-optionIndex * 20))
						thisOptionFrame.object = object
						object.menus[i] = thisOptionFrame
					end

					thisOptionFrame:SetFrameStrata(thisOptionFrame:GetParent():GetFrameStrata())
					thisOptionFrame:SetFrameLevel(thisOptionFrame:GetParent():GetFrameLevel() + 10)

					if (thisOption.rightTexture) then
						thisOptionFrame.rightTexture:SetTexture(thisOption.rightTexture)
					else
						thisOptionFrame.rightTexture:SetTexture("")
					end

					if (thisOption.centerTexture) then
						thisOptionFrame.centerTexture:SetTexture(thisOption.centerTexture)
					else
						thisOptionFrame.centerTexture:SetTexture("")
					end

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
					if (labelwitdh + 40 > frameWitdh) then
						frameWitdh = labelwitdh + 40
					end
					thisOptionFrame:Show()

					i = i + 1
				end
			end

			if (currentText) then
				selectedTexture:Hide()
			else
				selectedTexture:SetWidth(frameWitdh - 20)
			end

			for o = showing + 1, #object.menus do
				object.menus[o]:Hide()
			end

			local size = object.realsizeH

			if (showing * 20 > size) then
				--show scrollbar and setup scroll
				object:ShowScroll()
				scrollFrame:EnableMouseWheel(true)
				object.scroll:Altura(size-35) --height
				object.scroll:SetMinMaxValues(0, (showing * 20) - size + 2)

				--width
				scrollBorder:SetWidth(frameWitdh+20)
				scrollFrame:SetWidth(frameWitdh+20)
				scrollChild:SetWidth(frameWitdh+20)

				--height
				scrollBorder:SetHeight(size+2)
				scrollFrame:SetHeight(size+2)
				scrollChild:SetHeight((showing * 20) + 20)

				--mouse over texture
				mouseOverTexture:SetWidth(frameWitdh - 7)

				--selected
				selectedTexture:SetWidth(frameWitdh - 9)

				for index, row in ipairs(object.menus) do
					row:SetPoint("topright", scrollChild, "topright", -22, ((-index-1) * 20) - 5)
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
				scrollBorder:SetHeight((showing * 20) + 1)
				scrollFrame:SetHeight((showing * 20) + 1)
				--mouse over texture
				mouseOverTexture:SetWidth(frameWitdh - 1)
				--selected
				selectedTexture:SetWidth(frameWitdh - 1)

				for index, row in ipairs(object.menus) do
					row:SetPoint("topright", scrollChild, "topright", -5, ((-index-1) * 20) -5)
				end
			end

			if (object.myvaluelabel and currentIndex and scrollFrame.slider:IsShown()) then
				object.scroll:SetValue(max((currentIndex * 20) - 80, 0))
			else
				object.scroll:SetValue(0)
			end

			object:Open()

			--scrollFrame:SetHeight(300)
			--scrollChild:SetHeight(300)
			--scrollBorder:SetHeight(300)
		else
			--clear menu
		end
	else
		--click to close
		object:Close()
	end
end

function DetailsFrameworkDropDownOnEnter(self)
	local object = self.MyObject
	local kill = object:RunHooksForWidget("OnEnter", self, object)
	if (kill) then
		return
	end

	if (object.onenter_backdrop) then
		self:SetBackdropColor(unpack(object.onenter_backdrop))
	else
		self:SetBackdropColor(.2, .2, .2, .2)
	end

	if (object.onenter_backdrop_border_color) then
		self:SetBackdropBorderColor(unpack(object.onenter_backdrop_border_color))
	end

	self.arrowTexture2:Show()

	object:ShowTooltip()
end

function DetailsFrameworkDropDownOnLeave(self)
	local object = self.MyObject
	local kill = object:RunHooksForWidget("OnLeave", self, object)
	if (kill) then
		return
	end

	if (object.onleave_backdrop) then
		self:SetBackdropColor(unpack(object.onleave_backdrop))
	else
		self:SetBackdropColor(1, 1, 1, .5)
	end

	if (object.onleave_backdrop_border_color) then
		self:SetBackdropBorderColor(unpack(object.onleave_backdrop_border_color))
	end

	self.arrowTexture2:Hide()

	object:HideTooltip()
end

function DetailsFrameworkDropDownOnSizeChanged(self)
	local object = self.MyObject
	object.label:SetSize(self:GetWidth() - 40, 10)
end

function DetailsFrameworkDropDownOnShow(self)
	local object = self.MyObject
	local kill = object:RunHooksForWidget("OnShow", self, object)
	if (kill) then
		return
	end
end

function DetailsFrameworkDropDownOnHide(self)
	local object = self.MyObject
	local kill = object:RunHooksForWidget("OnHide", self, object)
	if (kill) then
		return
	end
	object:Close()
end

function DF:BuildDropDownFontList(onClick, icon, iconTexcoord, iconSize)
	local fontTable = {}

	local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
	for name, fontPath in pairs(SharedMedia:HashTable("font")) do
		fontTable[#fontTable+1] = {value = name, label = name, onclick = onClick, icon = icon, iconsize = iconSize, texcoord = iconTexcoord, font = fontPath, descfont = "abcdefg ABCDEFG"}
	end

	table.sort(fontTable, function(t1, t2) return t1.label < t2.label end)

	return fontTable
end

------------------------------------------------------------------------------------------------------------
--template

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
--object constructor

function DF:CreateDropDown(parent, func, default, width, height, member, name, template)
	return DF:NewDropDown(parent, parent, name, member, width, height, func, default, template)
end

function DF:NewDropDown(parent, container, name, member, width, height, func, default, template)
	if (not name) then
		name = "DetailsFrameworkDropDownNumber" .. DF.DropDownCounter
		DF.DropDownCounter = DF.DropDownCounter + 1

	elseif (not parent) then
		return error("Details! Framework: parent not found.", 2)
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

	if (not loadedAPIDropDownFunctions) then
		loadedAPIDropDownFunctions = true
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
	dropDownObject.realsizeW = 165
	dropDownObject.realsizeH = 300
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
	local newDropdownFrame = CreateFrame("button", name, parent, "BackdropTemplate")
	newDropdownFrame:SetBackdrop(defaultBackdrop)
	newDropdownFrame:SetBackdropColor(1, 1, 1, .5)
	newDropdownFrame:SetSize(150, 20)

	local statusbar = newDropdownFrame:CreateTexture("$parent_StatusBarTexture", "BACKGROUND")
	statusbar:SetPoint("topleft", newDropdownFrame, "topleft", 0, 0)
	statusbar:SetPoint("bottomright", newDropdownFrame, "bottomright", 0, 0)
	newDropdownFrame.statusbar = statusbar

	local icon = newDropdownFrame:CreateTexture("$parent_IconTexture", "ARTWORK")
	icon:SetPoint("left", newDropdownFrame, "left", 2, 0)
	icon:SetSize(20, 20)
	icon:SetTexture([[Interface\COMMON\UI-ModelControlPanel]])
	icon:SetTexCoord(0.625, 0.78125, 0.328125, 0.390625)
	icon:SetVertexColor(1, 1, 1, 0.4)
	newDropdownFrame.icon = icon

	local rightTexture = newDropdownFrame:CreateTexture("$parent_RightTexture", "OVERLAY")
	rightTexture:SetPoint("right", newDropdownFrame, "right", -2, 0)
	rightTexture:SetSize(20, 20)
	newDropdownFrame.rightTexture = rightTexture

	local centerTexture = newDropdownFrame:CreateTexture("$parent_CenterTexture", "OVERLAY")
	centerTexture:SetPoint("center", newDropdownFrame, "center", 0, 0)
	centerTexture:SetSize(20, 20)
	newDropdownFrame.centerTexture = centerTexture

	local text = newDropdownFrame:CreateFontString("$parent_Text", "ARTWORK", "GameFontHighlightSmall")
	text:SetPoint("left", icon, "right", 5, 0)
	text:SetJustifyH("left")
	text:SetText("no option selected")
	text:SetTextColor(1, 1, 1, 0.4)
	DF:SetFontSize(text, 10)
	newDropdownFrame.text = text

	local arrowHightlight = newDropdownFrame:CreateTexture("$parent_ArrowTexture2", "OVERLAY", nil, 2)
	arrowHightlight:SetPoint("right", newDropdownFrame, "right", 5, -1)
	arrowHightlight:SetBlendMode("ADD")
	arrowHightlight:SetTexture([[Interface\Buttons\UI-ScrollBar-ScrollDownButton-Highlight]])
	arrowHightlight:Hide()
	arrowHightlight:SetSize(32, 28)
	newDropdownFrame.arrowTexture2 = arrowHightlight

	local arrowTexture = newDropdownFrame:CreateTexture("$parent_ArrowTexture", "OVERLAY", nil, 1)
	arrowTexture:SetPoint("right", newDropdownFrame, "right", 5, -1)
	arrowTexture:SetTexture([[Interface\Buttons\UI-ScrollBar-ScrollDownButton-Up]])
	arrowTexture:SetSize(32, 28)
	newDropdownFrame.arrowTexture = arrowTexture

	--scripts
	newDropdownFrame:SetScript("OnSizeChanged", DetailsFrameworkDropDownOnSizeChanged)
	newDropdownFrame:SetScript("OnMouseDown", DetailsFrameworkDropDownOnMouseDown)

	--dropdown
	local border = CreateFrame("frame", "$Parent_Border", newDropdownFrame, "BackdropTemplate")
	border:Hide()
	border:SetFrameStrata("FULLSCREEN")
	border:SetSize(150, 300)
	border:SetPoint("topleft", newDropdownFrame, "bottomleft", 0, 0)
	border:SetBackdrop(borderBackdrop)
	border:SetScript("OnHide", DetailsFrameworkDropDownOptionsFrameOnHide)
	border:SetBackdropColor(0, 0, 0, 0.92)
	border:SetBackdropBorderColor(.2, .2, .2, 0.8)
	newDropdownFrame.dropdownborder = border

	local scroll = CreateFrame("ScrollFrame", "$Parent_ScrollFrame", newDropdownFrame, "BackdropTemplate")
	scroll:SetFrameStrata("FULLSCREEN")
	scroll:SetSize(150, 300)
	scroll:SetPoint("topleft", newDropdownFrame, "bottomleft", 0, 0)
	scroll:Hide()
	newDropdownFrame.dropdownframe = scroll

	local child = CreateFrame("frame", "$Parent_ScrollChild", scroll, "BackdropTemplate")
	--child:SetAllPoints()
	child:SetSize(150, 300)
	child:SetPoint("topleft", scroll, "topleft", 0, 0)
	DF:ApplyStandardBackdrop(child)

	local backgroundTexture = child:CreateTexture(nil, "background")
	backgroundTexture:SetAllPoints()
	backgroundTexture:SetColorTexture(0, 0, 0, 1)

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
	tinsert(UISpecialFrames, newDropdownFrame.dropdownborder:GetName())
	--tinsert(UISpecialFrames, f.dropdownframe:GetName()) --not adding this solves an issue with ConsolePort addon and stackoverflows on Hide...

	return newDropdownFrame
end

function DF:CreateDropdownButton(parent, name)
	local newButton = CreateFrame("button", name, parent, "BackdropTemplate")
	newButton:SetSize(150, 20)

	local statusbar = newButton:CreateTexture("$parent_StatusBarTexture", "ARTWORK")
	statusbar:SetPoint("topleft", newButton, "topleft", 0, 0)
	statusbar:SetPoint("bottomright", newButton, "bottomright", 0, 0)
	statusbar:SetTexture([[Interface\Tooltips\UI-Tooltip-Background]])
	newButton.statusbar = statusbar

	local icon = newButton:CreateTexture("$parent_IconTexture", "OVERLAY")
	icon:SetPoint("left", newButton, "left", 2, 0)
	icon:SetSize(20, 20)
	icon:SetTexture([[Interface\ICONS\Spell_ChargePositive]])
	newButton.icon = icon

	local text = newButton:CreateFontString("$parent_Text", "OVERLAY", "GameFontHighlightSmall")
	text:SetPoint("left", icon, "right", 5, 0)
	text:SetJustifyH("left")
	DF:SetFontSize(text, 10)
	newButton.label = text

	local rightButton = DF:CreateButton(newButton, function()end, 16, 16, "", 0, 0, "", "rightButton", "$parentRightButton", nil, DF:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
	rightButton:SetPoint("right", newButton, "right", -2, 0)
	rightButton:Hide()

	local rightTexture = newButton:CreateTexture("$parent_RightTexture", "OVERLAY")
	rightTexture:SetPoint("right", newButton, "right", -2, 0)
	rightTexture:SetSize(20, 20)
	newButton.rightTexture = rightTexture

	local centerTexture = newButton:CreateTexture("$parent_CenterTexture", "OVERLAY")
	centerTexture:SetPoint("center", newButton, "center", 0, 0)
	centerTexture:SetSize(20, 20)
	newButton.centerTexture = centerTexture

	newButton:SetScript("OnMouseDown", DetailsFrameworkDropDownOptionClick)
	newButton:SetScript("OnEnter", DetailsFrameworkDropDownOptionOnEnter)
	newButton:SetScript("OnLeave", DetailsFrameworkDropDownOptionOnLeave)

	return newButton
end
