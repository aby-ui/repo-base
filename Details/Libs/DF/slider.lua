
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

local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")

local cleanfunction = function() end
local APISliderFunctions = false

do
	local metaPrototype = {
		WidgetType = "slider",
		SetHook = DF.SetHook,
		HasHook = DF.HasHook,
		ClearHooks = DF.ClearHooks,
		RunHooksForWidget = DF.RunHooksForWidget,

		dversion = DF.dversion,
	}

	--check if there's a metaPrototype already existing
	if (_G[DF.GlobalWidgetControlNames["slider"]]) then
		--get the already existing metaPrototype
		local oldMetaPrototype = _G[DF.GlobalWidgetControlNames ["slider"]]
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
		_G[DF.GlobalWidgetControlNames ["slider"]] = metaPrototype
	end
end

local DFSliderMetaFunctions = _G[DF.GlobalWidgetControlNames ["slider"]]

------------------------------------------------------------------------------------------------------------
--> metatables

	DFSliderMetaFunctions.__call = function (_table, value)
		if (not value) then
			if (_table.isSwitch) then
			
				if (type (value) == "boolean") then --> false
					return _table.slider:SetValue (1)
				end
			
				if (_table.slider:GetValue() == 1) then
					return false
				else
					return true
				end
			end
			return _table.slider:GetValue()
		else
			if (_table.isSwitch) then
				if (type (value) == "boolean") then
					if (value) then
						_table.slider:SetValue (2)
					else
						_table.slider:SetValue (1)
					end
				else
					_table.slider:SetValue (value)
				end
				return
			end
			
			return _table.slider:SetValue (value)
		end
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
		return _object.slider:GetWidth()
	end
	--> frame height
	local gmember_height = function (_object)
		return _object.slider:GetHeight()
	end
	--> locked
	local gmember_locked = function (_object)
		return _rawget (_object, "lockdown")
	end
	--> fractional
	local gmember_fractional = function (_object)
		return _rawget (_object, "useDecimals")
	end	
	--> value
	local gmember_value = function (_object)
		return _object()
	end	

	DFSliderMetaFunctions.GetMembers = DFSliderMetaFunctions.GetMembers or {}
	DFSliderMetaFunctions.GetMembers ["tooltip"] = gmember_tooltip
	DFSliderMetaFunctions.GetMembers ["shown"] = gmember_shown
	DFSliderMetaFunctions.GetMembers ["width"] = gmember_width
	DFSliderMetaFunctions.GetMembers ["height"] = gmember_height
	DFSliderMetaFunctions.GetMembers ["locked"] = gmember_locked
	DFSliderMetaFunctions.GetMembers ["fractional"] = gmember_fractional
	DFSliderMetaFunctions.GetMembers ["value"] = gmember_value

	DFSliderMetaFunctions.__index = function (_table, _member_requested)

		local func = DFSliderMetaFunctions.GetMembers [_member_requested]
		if (func) then
			return func (_table, _member_requested)
		end
		
		local fromMe = _rawget (_table, _member_requested)
		if (fromMe) then
			return fromMe
		end
		
		return DFSliderMetaFunctions [_member_requested]
	end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
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
		return _object.slider:SetWidth (_value)
	end
	--> frame height
	local smember_height = function (_object, _value)
		return _object.slider:SetHeight (_value)
	end
	--> locked
	local smember_locked = function (_object, _value)
		if (_value) then
			return self:Disable()
		else
			return self:Enable()
		end
	end	
	--> backdrop
	local smember_backdrop = function (_object, _value)
		return _object.slider:SetBackdrop (_value)
	end
	--> fractional
	local smember_fractional = function (_object, _value)
		return _rawset (_object, "useDecimals", _value)
	end
	--> value
	local smember_value = function (_object, _value)
		_object (_value)
	end
	
	DFSliderMetaFunctions.SetMembers = DFSliderMetaFunctions.SetMembers or {}
	DFSliderMetaFunctions.SetMembers ["tooltip"] = smember_tooltip
	DFSliderMetaFunctions.SetMembers ["show"] = smember_show
	DFSliderMetaFunctions.SetMembers ["hide"] = smember_hide
	DFSliderMetaFunctions.SetMembers ["backdrop"] = smember_backdrop
	DFSliderMetaFunctions.SetMembers ["width"] = smember_width
	DFSliderMetaFunctions.SetMembers ["height"] = smember_height
	DFSliderMetaFunctions.SetMembers ["locked"] = smember_locked
	DFSliderMetaFunctions.SetMembers ["fractional"] = smember_fractional
	DFSliderMetaFunctions.SetMembers ["value"] = smember_value
	
	DFSliderMetaFunctions.__newindex = function (_table, _key, _value)
		local func = DFSliderMetaFunctions.SetMembers [_key]
		if (func) then
			return func (_table, _value)
		else
			return _rawset (_table, _key, _value)
		end
	end	
	
------------------------------------------------------------------------------------------------------------
--> methods

--> show & hide
	function DFSliderMetaFunctions:IsShown()
		return self.slider:IsShown()
	end
	function DFSliderMetaFunctions:Show()
		return self.slider:Show()
	end
	function DFSliderMetaFunctions:Hide()
		return self.slider:Hide()
	end
	
--> fixed value
	function DFSliderMetaFunctions:SetFixedParameter (value)
		_rawset (self, "FixedValue", value)
	end
	
--> set value
	function DFSliderMetaFunctions:SetValue (value)
		return self (value)
	end
	
-- thumb size
	function DFSliderMetaFunctions:SetThumbSize (w, h)
		if (not w) then
			w = self.thumb:GetWidth()
		end
		if (not h) then
			h = self.thumb:GetHeight()
		end
		return self.thumb:SetSize (w, h)
	end	
	
	
-- setpoint
	function DFSliderMetaFunctions:SetPoint (v1, v2, v3, v4, v5)
		v1, v2, v3, v4, v5 = DF:CheckPoints (v1, v2, v3, v4, v5, self)
		if (not v1) then
			print ("Invalid parameter for SetPoint")
			return
		end
		return self.widget:SetPoint (v1, v2, v3, v4, v5)
	end

-- sizes
	function DFSliderMetaFunctions:SetSize (w, h)
		if (w) then
			self.slider:SetWidth (w)
		end
		if (h) then
			return self.slider:SetHeight (h)
		end
	end
	
-- tooltip
	function DFSliderMetaFunctions:SetTooltip (tooltip)
		if (tooltip) then
			return _rawset (self, "have_tooltip", tooltip)
		else
			return _rawset (self, "have_tooltip", nil)
		end
	end
	function DFSliderMetaFunctions:GetTooltip()
		return _rawget (self, "have_tooltip")
	end
	
-- frame levels
	function DFSliderMetaFunctions:GetFrameLevel()
		return self.slider:GetFrameLevel()
	end
	function DFSliderMetaFunctions:SetFrameLevel (level, frame)
		if (not frame) then
			return self.slider:SetFrameLevel (level)
		else
			local framelevel = frame:GetFrameLevel (frame) + level
			return self.slider:SetFrameLevel (framelevel)
		end
	end

-- frame stratas
	function DFSliderMetaFunctions:SetFrameStrata()
		return self.slider:GetFrameStrata()
	end
	function DFSliderMetaFunctions:SetFrameStrata (strata)
		if (_type (strata) == "table") then
			self.slider:SetFrameStrata (strata:GetFrameStrata())
		else
			self.slider:SetFrameStrata (strata)
		end
	end
	
-- clear focus
	function DFSliderMetaFunctions:ClearFocus()
		local editbox = DFSliderMetaFunctions.editbox_typevalue
		if editbox and self.typing_value then
			editbox:ClearFocus()
			editbox:Hide()
			editbox:GetParent().MyObject.typing_value = false
			editbox:GetParent().MyObject.value = self.typing_value_started
		end
	end
	
-- enabled
	function DFSliderMetaFunctions:IsEnabled()
		return not _rawget (self, "lockdown")
	end
		
	function DFSliderMetaFunctions:Enable()
		self.slider:Enable()
		if (not self.is_checkbox) then
			if (not self.lock_texture) then
				DF:NewImage (self, [[Interface\PetBattles\PetBattle-LockIcon]], 12, 12, "overlay", {0.0546875, 0.9453125, 0.0703125, 0.9453125}, "lock_texture", "$parentLockTexture")
				self.lock_texture:SetDesaturated (true)
				self.lock_texture:SetPoint ("center", self.amt, "center")
			end
			self.lock_texture:Hide()
		end
		self.slider.amt:Show()
		self:SetAlpha (1)
		
		if (self.is_checkbox) then
			self.checked_texture:Show()
		end
		return _rawset (self, "lockdown", false)
	end
	
	function DFSliderMetaFunctions:Disable()
	
		self:ClearFocus()
		self.slider:Disable()
		self.slider.amt:Hide()
		self:SetAlpha (.4)

		if (not self.is_checkbox) then
			if (not self.lock_texture) then
				DF:NewImage (self, [[Interface\PetBattles\PetBattle-LockIcon]], 12, 12, "overlay", {0.0546875, 0.9453125, 0.0703125, 0.9453125}, "lock_texture", "$parentLockTexture")
				self.lock_texture:SetDesaturated (true)
				self.lock_texture:SetPoint ("center", self.amt, "center")
			end
			self.lock_texture:Show()
		end
		
		if (self.is_checkbox) then
			self.checked_texture:Show()
		end
		
		--print ("result 2:", self.checked_texture:IsShown(), self.checked_texture:GetAlpha(), self.checked_texture:GetSize())
		
		return _rawset (self, "lockdown", true)
	end

------------------------------------------------------------------------------------------------------------
--> scripts

	local OnEnter = function (slider)
		if (_rawget (slider.MyObject, "lockdown")) then
			return
		end
	
		DetailsFrameworkSliderButtons1:ShowMe (slider)
	
		local capsule = slider.MyObject
		local kill = capsule:RunHooksForWidget ("OnEnter", slider, capsule)
		if (kill) then
			return
		end

		slider.thumb:SetAlpha (1)
	
		if (slider.MyObject.onenter_backdrop_border_color) then
			slider:SetBackdropBorderColor (unpack (slider.MyObject.onenter_backdrop_border_color))
		end
	
		if (slider.MyObject.have_tooltip and slider.MyObject.have_tooltip ~= "Right Click to Type the Value") then
			GameCooltip2:Preset (2)
			GameCooltip2:AddLine (slider.MyObject.have_tooltip)
			GameCooltip2:ShowCooltip (slider, "tooltip")
		else
			GameCooltip2:Preset (2)
			GameCooltip2:AddLine ("Right Click to Type the Value", "", 1, "", "", 10)
			GameCooltip2:AddIcon ([[Interface\TUTORIALFRAME\UI-TUTORIAL-FRAME]], 1, 1, 16, 16, 0.015625, 0.15671875, 0.640625, 0.798828125)
			GameCooltip2:ShowCooltip (slider, "tooltip")
		end
	end
	
	local OnLeave = function (slider)
	
		if (_rawget (slider.MyObject, "lockdown")) then
			return
		end
	
		DetailsFrameworkSliderButtons1:PrepareToHide()
	
		local capsule = slider.MyObject
		local kill = capsule:RunHooksForWidget ("OnLeave", slider, capsule)
		if (kill) then
			return
		end
		
		slider.thumb:SetAlpha (.7)
	
		if (slider.MyObject.onleave_backdrop_border_color) then
			slider:SetBackdropBorderColor (unpack (slider.MyObject.onleave_backdrop_border_color))
		end
	
		GameCooltip2:ShowMe (false)

	end
	

	local f = CreateFrame ("frame", "DetailsFrameworkSliderButtons1", UIParent)
	f:Hide()
	f:SetHeight (18)
	
	local t = 0
	f.is_going_hide = false
	local going_hide = function (self, elapsed)
		t = t + elapsed
		if (t > 0.3) then
			f:Hide()
			f:SetScript ("OnUpdate", nil)
			f.is_going_hide = false
		end
	end
	
	function f:ShowMe (host)
		f:SetPoint ("bottomleft", host, "topleft", -3, -5)
		f:SetPoint ("bottomright", host, "topright", 3, -5)
		--f:SetFrameStrata (host:GetFrameStrata())
		f:SetFrameStrata ("FULLSCREEN")
		f:SetFrameLevel (host:GetFrameLevel() + 1000)
		f:Show()
		if (f.is_going_hide) then
			f:SetScript ("OnUpdate", nil)
			f.is_going_hide = false
		end
		
		f.host = host.MyObject
	end
	
	function f:PrepareToHide()
		f.is_going_hide = true
		t = 0
		f:SetScript ("OnUpdate", going_hide)
	end
	
	local button_plus = CreateFrame ("button", "DetailsFrameworkSliderButtonsPlusButton", f)
	local button_minor = CreateFrame ("button", "DetailsFrameworkSliderButtonsMinorButton", f)
	button_plus:SetFrameStrata (f:GetFrameStrata())
	button_minor:SetFrameStrata (f:GetFrameStrata())
	
	button_plus:SetScript ("OnEnter", function (self)
		if (f.is_going_hide) then
			f:SetScript ("OnUpdate", nil)
			f.is_going_hide = false
		end
	end)
	button_minor:SetScript ("OnEnter", function (self)
		if (f.is_going_hide) then
			f:SetScript ("OnUpdate", nil)
			f.is_going_hide = false
		end
	end)
	
	button_plus:SetScript ("OnLeave", function (self)
		f:PrepareToHide()
	end)
	button_minor:SetScript ("OnLeave", function (self)
		f:PrepareToHide()
	end)
	
	button_plus:SetNormalTexture ([[Interface\Buttons\UI-PlusButton-Up]])
	button_minor:SetNormalTexture ([[Interface\Buttons\UI-MinusButton-Up]])
	
	button_plus:SetPushedTexture ([[Interface\Buttons\UI-PlusButton-Down]])
	button_minor:SetPushedTexture ([[Interface\Buttons\UI-MinusButton-Down]])
	
	button_plus:SetDisabledTexture ([[Interface\Buttons\UI-PlusButton-Disabled]])
	button_minor:SetDisabledTexture ([[Interface\Buttons\UI-MinusButton-Disabled]])
	
	button_plus:SetHighlightTexture ([[Interface\Buttons\UI-PlusButton-Hilight]])
	button_minor:SetHighlightTexture ([[Interface\Buttons\UI-PlusButton-Hilight]])
	
	--button_minor:SetPoint ("bottomleft", f, "bottomleft", -6, -13)
	--button_plus:SetPoint ("bottomright", f, "bottomright", 6, -13)
	
	button_minor:SetPoint ("bottomright", f, "bottomright", 13, -13)
	button_plus:SetPoint ("left", button_minor, "right", -2, 0)
	
	button_plus:SetSize (16, 16)
	button_minor:SetSize (16, 16)
	
	local timer = 0
	local change_timer = 0
	
	-- -- --
	
	local plus_button_script = function()

		local current = f.host.value
		local editbox = DFSliderMetaFunctions.editbox_typevalue
		
		if (f.host.fine_tuning) then
			f.host:SetValue (current + f.host.fine_tuning)
			if (editbox and DFSliderMetaFunctions.editbox_typevalue:IsShown()) then
				DFSliderMetaFunctions.editbox_typevalue:SetText (tostring (string.format ("%.2f", current + f.host.fine_tuning)))
			end
		else
			if (f.host.useDecimals) then
				f.host:SetValue (current + 0.1)
				if (editbox and DFSliderMetaFunctions.editbox_typevalue:IsShown()) then
					DFSliderMetaFunctions.editbox_typevalue:SetText (string.format ("%.2f", current + 0.1))
				end
			else
				f.host:SetValue (current + 1)
				if (editbox and DFSliderMetaFunctions.editbox_typevalue:IsShown()) then
					DFSliderMetaFunctions.editbox_typevalue:SetText (tostring (math.floor (current + 1)))
				end
			end
		end

	end
	
	button_plus:SetScript ("OnMouseUp", function (self)
		if (not button_plus.got_click) then
			plus_button_script()
		end
		button_plus.got_click = false
		self:SetScript ("OnUpdate", nil)
	end)
	
	local on_update = function (self, elapsed)
		timer = timer + elapsed
		if (timer > 0.4) then
			change_timer = change_timer + elapsed
			if (change_timer > 0.1) then
				change_timer = 0
				plus_button_script()
				button_plus.got_click = true
			end
		end
	end
	button_plus:SetScript ("OnMouseDown", function (self)
		timer = 0
		change_timer = 0
		self:SetScript ("OnUpdate", on_update)
	end)
	
	-- -- --
	
	local minor_button_script = function()
		local current = f.host.value
		local editbox = DFSliderMetaFunctions.editbox_typevalue
		
		if (f.host.fine_tuning) then
			f.host:SetValue (current - f.host.fine_tuning)
			if (editbox and DFSliderMetaFunctions.editbox_typevalue:IsShown()) then
				DFSliderMetaFunctions.editbox_typevalue:SetText (tostring (string.format ("%.2f", current - f.host.fine_tuning)))
			end
		else
			if (f.host.useDecimals) then
				f.host:SetValue (current - 0.1)
				if (editbox and DFSliderMetaFunctions.editbox_typevalue:IsShown()) then
					DFSliderMetaFunctions.editbox_typevalue:SetText (string.format ("%.2f", current - 0.1))
				end
			else
				f.host:SetValue (current - 1)
				if (editbox and DFSliderMetaFunctions.editbox_typevalue:IsShown()) then
					DFSliderMetaFunctions.editbox_typevalue:SetText (tostring (math.floor (current - 1)))
				end
			end
		end
	end
	
	button_minor:SetScript ("OnMouseUp", function (self)
		if (not button_minor.got_click) then
			minor_button_script()
		end
		button_minor.got_click = false
		self:SetScript ("OnUpdate", nil)
	end)
	
	local on_update = function (self, elapsed)
		timer = timer + elapsed
		if (timer > 0.4) then
			change_timer = change_timer + elapsed
			if (change_timer > 0.1) then
				change_timer = 0
				minor_button_script()
				button_minor.got_click = true
			end
		end
	end
	button_minor:SetScript ("OnMouseDown", function (self)
		timer = 0
		change_timer = 0
		self:SetScript ("OnUpdate", on_update)
	end)
	
	local do_precision = function (text)
		if (type (text) == "string" and text:find ("%.")) then
			local left, right = strsplit (".", text)
			left = tonumber (left)
			right = tonumber (right)
			
			if (left and right) then
				local newString = tostring (left) .. "." .. tostring (right)
				local newNumber = tonumber (newString)
				
				if (newNumber) then
					return newNumber
				end
			end
		end
		
		return tonumber (text)
	end
	
	function DFSliderMetaFunctions:TypeValue()
		if (not self.isSwitch) then
		
			if (not DFSliderMetaFunctions.editbox_typevalue) then
			
				local editbox = CreateFrame ("EditBox", "DetailsFrameworkSliderEditBox", UIParent)
				
				editbox:SetSize (40, 20)
				editbox:SetJustifyH ("center")
				editbox:SetBackdrop ({bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]],
				edgeFile = "Interface\\Buttons\\UI-SliderBar-Border", --edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
				tile = true, edgeSize = 8, tileSize = 5})
				editbox:SetFontObject ("GameFontHighlightSmall")

				editbox:SetScript ("OnEnterPressed", function()
					editbox:ClearFocus()
					editbox:Hide()
					editbox:GetParent().MyObject.typing_value = false
					editbox:GetParent().MyObject.value = tonumber (editbox:GetText()) --do_precision (editbox:GetText())
				end)
				
				editbox:SetScript ("OnEscapePressed", function()
					editbox:ClearFocus()
					editbox:Hide()
					editbox:GetParent().MyObject.typing_value = false
					editbox:GetParent().MyObject.value = self.typing_value_started --do_precision (self.typing_value_started)
				end)

				editbox:SetScript ("OnTextChanged", function()
					editbox:GetParent().MyObject.typing_can_change = true
					editbox:GetParent().MyObject.value = tonumber (editbox:GetText()) --do_precision 
					editbox:GetParent().MyObject.typing_can_change = false
				end)
				
				DFSliderMetaFunctions.editbox_typevalue = editbox
			end
			
			local pvalue = self.previous_value [2]
			self:SetValue (pvalue)
			
			self.typing_value = true
			self.typing_value_started = pvalue
			
			DFSliderMetaFunctions.editbox_typevalue:SetSize (self.width, self.height)
			DFSliderMetaFunctions.editbox_typevalue:SetPoint ("center", self.widget, "center")
			DFSliderMetaFunctions.editbox_typevalue:SetFocus()
			DFSliderMetaFunctions.editbox_typevalue:SetParent (self.widget)
			DFSliderMetaFunctions.editbox_typevalue:SetFrameLevel (self.widget:GetFrameLevel()+1)
			
			if (self.useDecimals) then
				DFSliderMetaFunctions.editbox_typevalue:SetText (tostring (string.format ("%.1f", self.value)))
			else
				DFSliderMetaFunctions.editbox_typevalue:SetText (tostring (math.floor (self.value)))
			end
			
			DFSliderMetaFunctions.editbox_typevalue:HighlightText()
			
			DFSliderMetaFunctions.editbox_typevalue:Show()
		end
	end
	
	local OnMouseDown = function (slider, button)
		slider.MyObject.IsValueChanging = true
		
		local capsule = slider.MyObject
		local kill = capsule:RunHooksForWidget ("OnMouseDown", slider, button, capsule)
		if (kill) then
			return
		end
		
		if (button == "RightButton") then
			slider.MyObject:TypeValue()
		end
	end
	
	local OnMouseUp = function (slider, button)
		slider.MyObject.IsValueChanging = nil
		
		local capsule = slider.MyObject
		local kill = capsule:RunHooksForWidget ("OnMouseUp", slider, button, capsule)
		if (kill) then
			return
		end
	end
	
	local OnHide = function (slider)
		local capsule = slider.MyObject
		local kill = capsule:RunHooksForWidget ("OnHide", slider, capsule)
		if (kill) then
			return
		end
		
		if (slider.MyObject.typing_value) then
			DFSliderMetaFunctions.editbox_typevalue:ClearFocus()
			DFSliderMetaFunctions.editbox_typevalue:SetText ("")
			slider.MyObject.typing_valu = false
		end
	end
	
	local OnShow = function (slider)
		local capsule = slider.MyObject
		local kill = capsule:RunHooksForWidget ("OnShow", slider, capsule)
		if (kill) then
			return
		end
	end
	
	local table_insert = table.insert
	local table_remove = table.remove
	
	local OnValueChanged = function (slider)
	
		local amt
		if (slider.MyObject.useDecimals) then
			amt = slider:GetValue()
		else
			amt = do_precision (slider:GetValue())
		end
		
		if (slider.MyObject.typing_value and not slider.MyObject.typing_can_change) then
			slider.MyObject:SetValue (slider.MyObject.typing_value_started)
			return
		end
	
		table_insert (slider.MyObject.previous_value, 1, amt)
		table_remove (slider.MyObject.previous_value, 4)
		
		local capsule = slider.MyObject

		--some plugins registered OnValueChanged and others with OnValueChange
		local kill = capsule:RunHooksForWidget ("OnValueChanged", slider, capsule.FixedValue, amt, capsule)
		if (kill) then
			return
		end
		local kill = capsule:RunHooksForWidget ("OnValueChange", slider, capsule.FixedValue, amt, capsule)
		if (kill) then
			return
		end	
		
		if (slider.MyObject.OnValueChanged) then
			slider.MyObject.OnValueChanged (slider, slider.MyObject.FixedValue, amt)
		end
		
		if (amt < 10 and amt >= 1) then
			amt = "0"..amt
		end
		
		if (slider.MyObject.useDecimals) then
			slider.amt:SetText (string.format ("%.2f", amt))
		else
			slider.amt:SetText (math.floor (amt))
		end
		slider.MyObject.ivalue = amt

	end

------------------------------------------------------------------------------------------------------------
--> object constructor

local SwitchOnClick = function (self, button, forced_value, value)

	local slider = self.MyObject
	
	if (_rawget (slider, "lockdown")) then
		return
	end
	
	if (forced_value) then
		_rawset (slider, "value", not value)
	end

	if (_rawget (slider, "value")) then --actived
		_rawset (slider, "value", false)
		
		if (slider.backdrop_disabledcolor) then
			slider:SetBackdropColor (unpack (slider.backdrop_disabledcolor))
		else
			slider:SetBackdropColor (1, 0, 0, 0.4)
		end
		
		if (slider.is_checkbox) then
			slider.checked_texture:Hide()
		else
			slider._text:SetText (slider._ltext)
			slider._thumb:ClearAllPoints()
			slider._thumb:SetPoint ("left", slider.widget, "left")
		end
	else
		_rawset (slider, "value", true)
		if (slider.backdrop_enabledcolor) then
			slider:SetBackdropColor (unpack (slider.backdrop_enabledcolor))
		else
			slider:SetBackdropColor (0, 0, 1, 0.4)
		end
		if (slider.is_checkbox) then
			slider.checked_texture:Show()
		else
			slider._text:SetText (slider._rtext)
			slider._thumb:ClearAllPoints()
			slider._thumb:SetPoint ("right", slider.widget, "right")
		end
	end
	
	if (slider.OnSwitch and not forced_value) then
		local value = _rawget (slider, "value")
		if (slider.return_func) then
			value = slider:return_func (value)
		end
		
		--> safe call
		local success, errorText = pcall (slider.OnSwitch, slider, slider.FixedValue, value)
		if (not success) then
			error ("Details! Framework: OnSwitch() " .. (button.GetName and button:GetName() or "-NONAME-") ..  " error: " .. (errorText or ""))
		end
		
		--> trigger hooks
		slider:RunHooksForWidget ("OnSwitch", slider, slider.FixedValue, value)
	end
	
end

local default_switch_func = function (self, passed_value)
	if (self.value) then
		return false
	else
		return true
	end
end

local switch_get_value = function (self)
	return self.value
end

local switch_set_value = function (self, value)
	if (self.switch_func) then
		value = self:switch_func (value)
	end
	
	SwitchOnClick (self.widget, nil, true, value)
end

local switch_set_fixparameter = function (self, value)
	_rawset (self, "FixedValue", value)
end

local switch_disable = function (self)	
	
	if (self.is_checkbox) then
		self.checked_texture:Hide()
	else
		self._text:Hide()
		if (not self.lock_texture) then
			DF:NewImage (self, [[Interface\PetBattles\PetBattle-LockIcon]], 12, 12, "overlay", {0.0546875, 0.9453125, 0.0703125, 0.9453125}, "lock_texture", "$parentLockTexture")
			self.lock_texture:SetDesaturated (true)
			self.lock_texture:SetPoint ("center", self._thumb, "center")
		end
		self.lock_texture:Show()
	end
	
	self:SetAlpha (.4)
	_rawset (self, "lockdown", true)
end
local switch_enable = function (self)
	if (self.is_checkbox) then
		if (_rawget (self, "value")) then
			self.checked_texture:Show()
		else
			self.checked_texture:Hide()
		end
	else
		if (not self.lock_texture) then
			DF:NewImage (self, [[Interface\PetBattles\PetBattle-LockIcon]], 12, 12, "overlay", {0.0546875, 0.9453125, 0.0703125, 0.9453125}, "lock_texture", "$parentLockTexture")
			self.lock_texture:SetDesaturated (true)
			self.lock_texture:SetPoint ("center", self._thumb, "center")
		end
		self.lock_texture:Hide()
		self._text:Show()
	end
	
	self:SetAlpha (1)
	return _rawset (self, "lockdown", false)
end

local set_switch_func = function (self, newFunction)
	self.OnSwitch = newFunction
end

local set_as_checkbok = function (self)
	if self.is_checkbox and self.checked_texture then return end
	local checked = self:CreateTexture (self:GetName() .. "CheckTexture", "overlay")
	checked:SetTexture ([[Interface\Buttons\UI-CheckBox-Check]])
	checked:SetPoint ("center", self.button, "center", -1, -1)
	local size_pct = self:GetWidth()/32
	checked:SetSize (32*size_pct, 32*size_pct)
	self.checked_texture = checked
	
	self._thumb:Hide()
	self._text:Hide()
	
	self.is_checkbox = true
	
	if (_rawget (self, "value")) then
		self.checked_texture:Show()
		if (self.backdrop_enabledcolor) then
			self:SetBackdropColor (unpack (self.backdrop_enabledcolor))
		else
			self:SetBackdropColor (0, 0, 1, 0.4)
		end		
	else
		self.checked_texture:Hide()
		if (self.backdrop_disabledcolor) then
			self:SetBackdropColor (unpack (self.backdrop_disabledcolor))
		else
			self:SetBackdropColor (0, 0, 1, 0.4)
		end
	end

end

function DF:CreateSwitch (parent, on_switch, default_value, w, h, ltext, rtext, member, name, color_inverted, switch_func, return_func, with_label, switch_template, label_template)
	local switch, label = DF:NewSwitch (parent, parent, name, member, w or 60, h or 20, ltext, rtext, default_value, color_inverted, switch_func, return_func, with_label, switch_template, label_template)
	if (on_switch) then
		switch.OnSwitch = on_switch
	end
	return switch, label
end

function DF:NewSwitch (parent, container, name, member, w, h, ltext, rtext, default_value, color_inverted, switch_func, return_func, with_label, switch_template, label_template)

--> early checks
	if (not name) then
		name = "DetailsFrameWorkSlider" .. DF.SwitchCounter
		DF.SwitchCounter = DF.SwitchCounter + 1
	elseif (not parent) then
		return error ("Details! FrameWork: parent not found.", 2)
	end
	if (not container) then
		container = parent
	end
	
--> defaults
	ltext = ltext or "OFF"
	rtext = rtext or "ON"
	
--> build frames
	w = w or 60
	h = h or 20
	
	local slider = DF:NewButton (parent, container, name, member, w, h)
	slider.HookList.OnSwitch = {}
	
	slider.switch_func = switch_func
	slider.return_func = return_func
	slider.SetValue = switch_set_value
	slider.GetValue = switch_get_value
	slider.SetFixedParameter = switch_set_fixparameter
	slider.Disable = switch_disable
	slider.Enable = switch_enable
	slider.SetAsCheckBox = set_as_checkbok
	slider.SetTemplate = DFSliderMetaFunctions.SetTemplate
	slider.SetSwitchFunction = set_switch_func
	
	if (member) then
		parent [member] = slider
	end
	
	slider:SetBackdrop ({edgeFile = [[Interface\Buttons\UI-SliderBar-Border]], edgeSize = 8,
	bgFile = [[Interface\AddOns\Details\images\background]], insets = {left = 3, right = 3, top = 5, bottom = 5}})
	
	local thumb = slider:CreateTexture (nil, "artwork")
	thumb:SetTexture ("Interface\\Buttons\\UI-ScrollBar-Knob")
	thumb:SetSize (34+(h*0.2), h*1.2)
	thumb:SetAlpha (0.7)
	thumb:SetPoint ("left", slider.widget, "left")
	
	local text = slider:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
	text:SetTextColor (.8, .8, .8, 1)
	text:SetPoint ("center", thumb, "center")
	
	slider._text = text
	slider._thumb = thumb
	slider._ltext = ltext
	slider._rtext = rtext
	slider.thumb = thumb

	slider.invert_colors = color_inverted
	
	slider:SetScript ("OnClick", SwitchOnClick)

	slider:SetValue (default_value)

	slider.isSwitch = true
	
	if (switch_template) then
		slider:SetTemplate (switch_template)
	end
	
	if (with_label) then
		local label = DF:CreateLabel (slider.widget, with_label, nil, nil, nil, "label", nil, "overlay")
		label.text = with_label
		slider.widget:SetPoint ("left", label.widget, "right", 2, 0)
		with_label = label
		
		if (label_template) then
			label:SetTemplate (label_template)
		end
	end

	return slider, with_label
end

function DFSliderMetaFunctions:SetTemplate (template)

	--slider e switch
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
	end
	if (template.backdropbordercolor) then
		local r, g, b, a = DF:ParseColors (template.backdropbordercolor)
		self:SetBackdropBorderColor (r, g, b, a)
		self.onleave_backdrop_border_color = {r, g, b, a}
	end
	
	if (template.onenterbordercolor) then
		local r, g, b, a = DF:ParseColors (template.onenterbordercolor)
		self.onenter_backdrop_border_color = {r, g, b, a}
	end
	
	if (template.onleavebordercolor) then
		local r, g, b, a = DF:ParseColors (template.onleavebordercolor)
		self.onleave_backdrop_border_color = {r, g, b, a}
	end

	if (template.thumbtexture) then
		if (self.thumb) then
			self.thumb:SetTexture (template.thumbtexture)
		end
	end
	if (template.thumbwidth) then
		if (self.thumb) then
			self.thumb:SetWidth (template.thumbwidth)
		end
	end
	if (template.thumbheight) then
		if (self.thumb) then
			self.thumb:SetHeight (template.thumbheight)
		end
	end
	if (template.thumbcolor) then
		if (self.thumb) then
			local r, g, b, a = DF:ParseColors (template.thumbcolor)
			self.thumb:SetVertexColor (r, g, b, a)
		end
	end
	
	--switch only
	if (template.enabled_backdropcolor) then
		local r, g, b, a = DF:ParseColors (template.enabled_backdropcolor)
		self.backdrop_enabledcolor = {r, g, b, a}
	end
	if (template.disabled_backdropcolor) then
		local r, g, b, a = DF:ParseColors (template.disabled_backdropcolor)
		self.backdrop_disabledcolor = {r, g, b, a}
	end
end

function DF:CreateSlider (parent, w, h, min, max, step, defaultv, isDecemal, member, name, with_label, slider_template, label_template)
	local slider, label = DF:NewSlider (parent, parent, name, member, w, h, min, max, step, defaultv, isDecemal, false, with_label, slider_template, label_template)
	return slider, label
end

function DF:NewSlider (parent, container, name, member, w, h, min, max, step, defaultv, isDecemal, isSwitch, with_label, slider_template, label_template)
	
--> early checks
	if (not name) then
		name = "DetailsFrameworkSlider" .. DF.SliderCounter
		DF.SliderCounter = DF.SliderCounter + 1
	end
	if (not parent) then
		return error ("Details! FrameWork: parent not found.", 2)
	end
	if (not container) then
		container = parent
	end
	
	if (name:find ("$parent")) then
		local parentName = DF.GetParentName (parent)
		name = name:gsub ("$parent", parentName)
	end
	
	local SliderObject = {type = "slider", dframework = true}
	
	if (member) then
		parent [member] = SliderObject
	end	
	
	if (parent.dframework) then
		parent = parent.widget
	end
	if (container.dframework) then
		container = container.widget
	end
	
--> defaults	
	min = min or 1
	max = max or 2
	step = step or 1
	defaultv = defaultv or min
	
	w = w or 130
	h = h or 19
	
	--> default members:
		SliderObject.lockdown = false
		SliderObject.container = container
		
	SliderObject.slider = CreateFrame ("slider", name, parent)
	SliderObject.widget = SliderObject.slider

	SliderObject.useDecimals = isDecemal or false
	
	if (SliderObject.useDecimals) then
		SliderObject.slider:SetValueStep (0.01)
	else
		SliderObject.slider:SetValueStep (step)
	end
	
	if (not APISliderFunctions) then
		APISliderFunctions = true
		local idx = getmetatable (SliderObject.slider).__index
		for funcName, funcAddress in pairs (idx) do 
			if (not DFSliderMetaFunctions [funcName]) then
				DFSliderMetaFunctions [funcName] = function (object, ...)
					local x = loadstring ( "return _G['"..object.slider:GetName().."']:"..funcName.."(...)")
					return x (...)
				end
			end
		end
	end
	
	SliderObject.slider.MyObject = SliderObject
	SliderObject.slider:SetWidth (w)
	SliderObject.slider:SetHeight (h)
	SliderObject.slider:SetOrientation ("horizontal")
	SliderObject.slider:SetMinMaxValues (min, max)
	SliderObject.slider:SetValue (defaultv)
	SliderObject.ivalue = defaultv

	SliderObject.slider:SetBackdrop ({edgeFile = "Interface\\Buttons\\UI-SliderBar-Border", edgeSize = 8})
	SliderObject.slider:SetBackdropColor (0.9, 0.7, 0.7, 1.0)

	SliderObject.thumb = SliderObject.slider:CreateTexture (nil, "artwork")
	SliderObject.thumb:SetTexture ("Interface\\Buttons\\UI-ScrollBar-Knob")
	SliderObject.thumb:SetSize (30+(h*0.2), h*1.2)
	SliderObject.thumb.originalWidth = SliderObject.thumb:GetWidth()
	SliderObject.thumb.originalHeight =SliderObject.thumb:GetHeight()
	SliderObject.thumb:SetAlpha (0.7)
	SliderObject.slider:SetThumbTexture (SliderObject.thumb)
	SliderObject.slider.thumb = SliderObject.thumb
	
	if (not isSwitch) then
		SliderObject.have_tooltip = "Right Click to Type the Value"
	end
	
	SliderObject.amt = SliderObject.slider:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
	
	local amt = defaultv
	if (amt < 10 and amt >= 1) then
		amt = "0"..amt
	end
	
	if (SliderObject.useDecimals) then
		SliderObject.amt:SetText (string.format ("%.2f", amt))
	else
		SliderObject.amt:SetText (math.floor (amt))
	end
	
	SliderObject.amt:SetTextColor (.8, .8, .8, 1)
	SliderObject.amt:SetPoint ("center", SliderObject.thumb, "center")
	SliderObject.slider.amt = SliderObject.amt

	SliderObject.previous_value = {defaultv or 0, 0, 0}
	
	--> hooks
	SliderObject.HookList = {
		OnEnter = {},
		OnLeave = {},
		OnHide = {},
		OnShow = {},
		OnMouseDown = {},
		OnMouseUp = {},
		
		OnValueChange = {},
		OnValueChanged = {},
	}
	
	SliderObject.slider:SetScript ("OnEnter", OnEnter)
	SliderObject.slider:SetScript ("OnLeave", OnLeave)
	SliderObject.slider:SetScript ("OnHide", OnHide)
	SliderObject.slider:SetScript ("OnShow", OnShow)
	SliderObject.slider:SetScript ("OnValueChanged", OnValueChanged)
	SliderObject.slider:SetScript ("OnMouseDown", OnMouseDown)
	SliderObject.slider:SetScript ("OnMouseUp", OnMouseUp)

	_setmetatable (SliderObject, DFSliderMetaFunctions)
	
	if (with_label) then
		local label = DF:CreateLabel (SliderObject.slider, with_label, nil, nil, nil, "label", nil, "overlay")
		label.text = with_label
		SliderObject.slider:SetPoint ("left", label.widget, "right", 2, 0)
		with_label = label
		
		if (label_template) then
			label:SetTemplate (label_template)
		end
	end
	
	if (slider_template) then
		SliderObject:SetTemplate (slider_template)
	end
	
	return SliderObject, with_label
	
end
