
local DF = _G["DetailsFramework"]
if (not DF or not DetailsFrameworkCanLoad) then
	return
end

local _
local APISliderFunctions = false

do
	local metaPrototype = {
		WidgetType = "slider",
		SetHook = DF.SetHook,
		HasHook = DF.HasHook,
		ClearHooks = DF.ClearHooks,
		RunHooksForWidget = DF.RunHooksForWidget,
		dversion = DF.dversion
	}

	--check if there's a metaPrototype already existing
	if (_G[DF.GlobalWidgetControlNames["slider"]]) then
		--get the already existing metaPrototype
		local oldMetaPrototype = _G[DF.GlobalWidgetControlNames["slider"]]
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
		_G[DF.GlobalWidgetControlNames["slider"]] = metaPrototype
	end
end

local DFSliderMetaFunctions = _G[DF.GlobalWidgetControlNames["slider"]]

DF:Mixin(DFSliderMetaFunctions, DF.SetPointMixin)
DF:Mixin(DFSliderMetaFunctions, DF.FrameMixin)

------------------------------------------------------------------------------------------------------------
--metatables

	DFSliderMetaFunctions.__call = function(object, value)
		if (not value) then
			if (object.isSwitch) then
				if (type(value) == "boolean") then
					object.slider:SetValue(1)
					return
				end

				if (object.slider:GetValue() == 1) then
					return false
				else
					return true
				end
			end

			return object.slider:GetValue()
		else
			if (object.isSwitch) then
				if (type(value) == "boolean") then
					if (value) then
						object.slider:SetValue(2)
					else
						object.slider:SetValue(1)
					end
				else
					object.slider:SetValue(value)
				end
				return
			end

			return object.slider:SetValue(value)
		end
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
		return object.slider:GetWidth()
	end

	--frame height
	local gmember_height = function(object)
		return object.slider:GetHeight()
	end

	--locked
	local gmember_locked = function(object)
		return rawget(object, "lockdown")
	end

	--fractional
	local gmember_fractional = function(object)
		return rawget(object, "useDecimals")
	end

	--value
	local gmember_value = function(object)
		return object()
	end

	DFSliderMetaFunctions.GetMembers = DFSliderMetaFunctions.GetMembers or {}
	DFSliderMetaFunctions.GetMembers["tooltip"] = gmember_tooltip
	DFSliderMetaFunctions.GetMembers["shown"] = gmember_shown
	DFSliderMetaFunctions.GetMembers["width"] = gmember_width
	DFSliderMetaFunctions.GetMembers["height"] = gmember_height
	DFSliderMetaFunctions.GetMembers["locked"] = gmember_locked
	DFSliderMetaFunctions.GetMembers["fractional"] = gmember_fractional
	DFSliderMetaFunctions.GetMembers["value"] = gmember_value

	DFSliderMetaFunctions.__index = function(object, key)
		local func = DFSliderMetaFunctions.GetMembers[key]
		if (func) then
			return func(object, key)
		end

		local fromMe = rawget(object, key)
		if (fromMe) then
			return fromMe
		end

		return DFSliderMetaFunctions[key]
	end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
		return object.slider:SetWidth(value)
	end

	--frame height
	local smember_height = function(object, value)
		return object.slider:SetHeight(value)
	end

	--locked
	local smember_locked = function(object, value)
		if (value) then
			return object:Disable()
		else
			return object:Enable()
		end
	end

	--backdrop
	local smember_backdrop = function(object, value)
		return object.slider:SetBackdrop(value)
	end

	--fractional
	local smember_fractional = function(object, value)
		return rawset(object, "useDecimals", value)
	end

	--value
	local smember_value = function(object, value)
		object(value)
	end

	DFSliderMetaFunctions.SetMembers = DFSliderMetaFunctions.SetMembers or {}
	DFSliderMetaFunctions.SetMembers["tooltip"] = smember_tooltip
	DFSliderMetaFunctions.SetMembers["show"] = smember_show
	DFSliderMetaFunctions.SetMembers["hide"] = smember_hide
	DFSliderMetaFunctions.SetMembers["backdrop"] = smember_backdrop
	DFSliderMetaFunctions.SetMembers["width"] = smember_width
	DFSliderMetaFunctions.SetMembers["height"] = smember_height
	DFSliderMetaFunctions.SetMembers["locked"] = smember_locked
	DFSliderMetaFunctions.SetMembers["fractional"] = smember_fractional
	DFSliderMetaFunctions.SetMembers["value"] = smember_value

	DFSliderMetaFunctions.__newindex = function(object, key, value)
		local func = DFSliderMetaFunctions.SetMembers[key]
		if (func) then
			return func(object, value)
		else
			return rawset(object, key, value)
		end
	end

------------------------------------------------------------------------------------------------------------
--methods

	--fixed value
	function DFSliderMetaFunctions:SetFixedParameter(value)
		rawset(self, "FixedValue", value)
	end

	--set value
	function DFSliderMetaFunctions:SetValue(value)
		return self(value)
	end

	-- thumb size
	function DFSliderMetaFunctions:SetThumbSize(width, height)
		if (not width) then
			width = self.thumb:GetWidth()
		end
		if (not height) then
			height = self.thumb:GetHeight()
		end
		return self.thumb:SetSize(width, height)
	end

	--tooltip
	function DFSliderMetaFunctions:SetTooltip(tooltip)
		if (tooltip) then
			return rawset(self, "have_tooltip", tooltip)
		else
			return rawset(self, "have_tooltip", nil)
		end
	end
	function DFSliderMetaFunctions:GetTooltip()
		return rawget(self, "have_tooltip")
	end

	--clear focus
	function DFSliderMetaFunctions:ClearFocus()
		local editbox = DFSliderMetaFunctions.editbox_typevalue
		if editbox and self.typing_value then
			editbox:ClearFocus()
			editbox:Hide()
			editbox:GetParent().MyObject.typing_value = false
			editbox:GetParent().MyObject.value = self.typing_value_started
		end
	end

	--enabled
	function DFSliderMetaFunctions:IsEnabled()
		return not rawget(self, "lockdown")
	end

	function DFSliderMetaFunctions:Enable()
		self.slider:Enable()
		if (not self.is_checkbox) then
			if (not self.lock_texture) then
				DF:NewImage(self, [[Interface\PetBattles\PetBattle-LockIcon]], 12, 12, "overlay", {0.0546875, 0.9453125, 0.0703125, 0.9453125}, "lock_texture", "$parentLockTexture")
				self.lock_texture:SetDesaturated(true)
				self.lock_texture:SetPoint("center", self.amt, "center")
			end
			self.lock_texture:Hide()
		end
		self.slider.amt:Show()
		self:SetAlpha(1)

		if (self.is_checkbox) then
			self.checked_texture:Show()
		end
		return rawset(self, "lockdown", false)
	end

	function DFSliderMetaFunctions:Disable()
		self:ClearFocus()
		self.slider:Disable()
		self.slider.amt:Hide()
		self:SetAlpha (.4)

		if (not self.is_checkbox) then
			if (not self.lock_texture) then
				DF:NewImage (self, [[Interface\PetBattles\PetBattle-LockIcon]], 12, 12, "overlay", {0.0546875, 0.9453125, 0.0703125, 0.9453125}, "lock_texture", "$parentLockTexture")
				self.lock_texture:SetDesaturated(true)
				self.lock_texture:SetPoint("center", self.amt, "center")
			end
			self.lock_texture:Show()
		end

		if (self.is_checkbox) then
			self.checked_texture:Show()
		end

		return rawset(self, "lockdown", true)
	end

------------------------------------------------------------------------------------------------------------
--scripts

	local OnEnter = function(slider)
		if (rawget (slider.MyObject, "lockdown")) then
			return
		end
	
		DetailsFrameworkSliderButtons1:ShowMe(slider)
	
		local capsule = slider.MyObject
		local kill = capsule:RunHooksForWidget ("OnEnter", slider, capsule)
		if (kill) then
			return
		end

		slider.thumb:SetAlpha (1)
	
		if (slider.MyObject.onenter_backdrop_border_color) then
			slider:SetBackdropBorderColor(unpack (slider.MyObject.onenter_backdrop_border_color))
		end
	
		if (slider.MyObject.have_tooltip and slider.MyObject.have_tooltip ~= "Right Click to Type the Value") then
			GameCooltip2:Preset (2)
			GameCooltip2:AddLine (slider.MyObject.have_tooltip)
			GameCooltip2:ShowCooltip(slider, "tooltip")
		else
			GameCooltip2:Preset (2)
			GameCooltip2:AddLine ("Right Click to Type the Value", "", 1, "", "", 10)
			GameCooltip2:AddIcon ([[Interface\TUTORIALFRAME\UI-TUTORIAL-FRAME]], 1, 1, 16, 16, 0.015625, 0.15671875, 0.640625, 0.798828125)
			GameCooltip2:ShowCooltip(slider, "tooltip")
		end
	end
	
	local OnLeave = function(slider)
	
		if (rawget (slider.MyObject, "lockdown")) then
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
			slider:SetBackdropBorderColor(unpack (slider.MyObject.onleave_backdrop_border_color))
		end
	
		GameCooltip2:ShowMe(false)

	end
	

	local f = DetailsFrameworkSliderButtons1 or CreateFrame("frame", "DetailsFrameworkSliderButtons1", UIParent, "BackdropTemplate")
	f:Hide()
	f:SetHeight(18)

	local t = 0
	f.isGoingToHide = false
	local goingHide = function(self, elapsed)
		t = t + elapsed
		if (t > 0.3) then
			f:Hide()
			f:SetScript("OnUpdate", nil)
			f.isGoingToHide = false
		end
	end

	function f:ShowMe(host)
		f:SetParent(host)
		f:ClearAllPoints()
		f:SetPoint("bottomleft", host, "topleft", -5, -5)
		f:SetPoint("bottomright", host, "topright", 5, -5)

		f:SetFrameStrata("FULLSCREEN")
		f:SetFrameLevel (host:GetFrameLevel() + 1000)
		f:Show()
		if (f.isGoingToHide) then
			f:SetScript("OnUpdate", nil)
			f.isGoingToHide = false
		end

		f.host = host.MyObject
	end
	
	function f:PrepareToHide()
		f.isGoingToHide = true
		t = 0
		f:SetScript("OnUpdate", goingHide)
	end
	
	local buttonPlus = CreateFrame("button", "DetailsFrameworkSliderButtonsPlusButton", f, "BackdropTemplate")
	local buttonMinor = CreateFrame("button", "DetailsFrameworkSliderButtonsMinorButton", f, "BackdropTemplate")
	buttonPlus:SetFrameStrata(f:GetFrameStrata())
	buttonMinor:SetFrameStrata(f:GetFrameStrata())
	
	buttonPlus:SetScript("OnEnter", function(self)
		if (f.isGoingToHide) then
			f:SetScript("OnUpdate", nil)
			f.isGoingToHide = false
		end
	end)
	buttonMinor:SetScript("OnEnter", function(self)
		if (f.isGoingToHide) then
			f:SetScript("OnUpdate", nil)
			f.isGoingToHide = false
		end
	end)
	
	buttonPlus:SetScript("OnLeave", function(self)
		f:PrepareToHide()
	end)
	buttonMinor:SetScript("OnLeave", function(self)
		f:PrepareToHide()
	end)
	
	buttonPlus:SetNormalTexture([[Interface\Buttons\UI-PlusButton-Up]])
	buttonMinor:SetNormalTexture([[Interface\Buttons\UI-MinusButton-Up]])
	
	buttonPlus:SetPushedTexture([[Interface\Buttons\UI-PlusButton-Down]])
	buttonMinor:SetPushedTexture([[Interface\Buttons\UI-MinusButton-Down]])
	
	buttonPlus:SetDisabledTexture ([[Interface\Buttons\UI-PlusButton-Disabled]])
	buttonMinor:SetDisabledTexture ([[Interface\Buttons\UI-MinusButton-Disabled]])
	
	buttonPlus:SetHighlightTexture([[Interface\Buttons\UI-PlusButton-Hilight]])
	buttonMinor:SetHighlightTexture([[Interface\Buttons\UI-PlusButton-Hilight]])

	local plusNormalTexture = buttonPlus:GetNormalTexture()
	plusNormalTexture:SetDesaturated(true)
	local minorNormalTexture = buttonMinor:GetNormalTexture()
	minorNormalTexture:SetDesaturated(true)

	buttonMinor:ClearAllPoints()
	buttonPlus:ClearAllPoints()
	buttonMinor:SetPoint("bottomright", f, "bottomright", 13, -13)
	buttonPlus:SetPoint("left", buttonMinor, "right", -2, 0)
	
	buttonPlus:SetSize(16, 16)
	buttonMinor:SetSize(16, 16)
	
	local timer = 0
	local change_timer = 0
	
	-- -- --
	
	local plus_button_script = function()

		local current = f.host.value
		local editbox = DFSliderMetaFunctions.editbox_typevalue
		
		if (f.host.fine_tuning) then
			f.host:SetValue(current + f.host.fine_tuning)
			if (editbox and DFSliderMetaFunctions.editbox_typevalue:IsShown()) then
				DFSliderMetaFunctions.editbox_typevalue:SetText(tostring (string.format("%.2f", current + f.host.fine_tuning)))
			end
		else
			if (f.host.useDecimals) then
				f.host:SetValue(current + 0.1)
				if (editbox and DFSliderMetaFunctions.editbox_typevalue:IsShown()) then
					DFSliderMetaFunctions.editbox_typevalue:SetText(string.format("%.2f", current + 0.1))
				end
			else
				f.host:SetValue(current + 1)
				if (editbox and DFSliderMetaFunctions.editbox_typevalue:IsShown()) then
					DFSliderMetaFunctions.editbox_typevalue:SetText(tostring (math.floor (current + 1)))
				end
			end
		end

	end
	
	buttonPlus:SetScript("OnMouseUp", function(self)
		if (not buttonPlus.got_click) then
			plus_button_script()
		end
		buttonPlus.got_click = false
		self:SetScript("OnUpdate", nil)
	end)
	
	local on_update = function(self, elapsed)
		timer = timer + elapsed
		if (timer > 0.4) then
			change_timer = change_timer + elapsed
			if (change_timer > 0.1) then
				change_timer = 0
				plus_button_script()
				buttonPlus.got_click = true
			end
		end
	end
	buttonPlus:SetScript("OnMouseDown", function(self)
		timer = 0
		change_timer = 0
		self:SetScript("OnUpdate", on_update)
	end)
	
	-- -- --
	
	local minor_button_script = function()
		local current = f.host.value
		local editbox = DFSliderMetaFunctions.editbox_typevalue
		
		if (f.host.fine_tuning) then
			f.host:SetValue(current - f.host.fine_tuning)
			if (editbox and DFSliderMetaFunctions.editbox_typevalue:IsShown()) then
				DFSliderMetaFunctions.editbox_typevalue:SetText(tostring (string.format("%.2f", current - f.host.fine_tuning)))
			end
		else
			if (f.host.useDecimals) then
				f.host:SetValue(current - 0.1)
				if (editbox and DFSliderMetaFunctions.editbox_typevalue:IsShown()) then
					DFSliderMetaFunctions.editbox_typevalue:SetText(string.format("%.2f", current - 0.1))
				end
			else
				f.host:SetValue(current - 1)
				if (editbox and DFSliderMetaFunctions.editbox_typevalue:IsShown()) then
					DFSliderMetaFunctions.editbox_typevalue:SetText(tostring (math.floor (current - 1)))
				end
			end
		end
	end
	
	buttonMinor:SetScript("OnMouseUp", function(self)
		if (not buttonMinor.got_click) then
			minor_button_script()
		end
		buttonMinor.got_click = false
		self:SetScript("OnUpdate", nil)
	end)
	
	local on_update = function(self, elapsed)
		timer = timer + elapsed
		if (timer > 0.4) then
			change_timer = change_timer + elapsed
			if (change_timer > 0.1) then
				change_timer = 0
				minor_button_script()
				buttonMinor.got_click = true
			end
		end
	end
	buttonMinor:SetScript("OnMouseDown", function(self)
		timer = 0
		change_timer = 0
		self:SetScript("OnUpdate", on_update)
	end)
	
	local do_precision = function(text)
		if (type(text) == "string" and text:find ("%.")) then
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
	DF.TextToFloor = do_precision
	
	function DFSliderMetaFunctions:TypeValue()
		if (not self.isSwitch) then
		
			if (not DFSliderMetaFunctions.editbox_typevalue) then
			
				local editbox = CreateFrame("EditBox", "DetailsFrameworkSliderEditBox", UIParent, "BackdropTemplate")
				
				editbox:SetSize(40, 20)
				editbox:SetJustifyH("center")
				editbox:SetBackdrop({bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]],
				edgeFile = "Interface\\Buttons\\UI-SliderBar-Border", --edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
				tile = true, edgeSize = 8, tileSize = 5})
				editbox:SetFontObject ("GameFontHighlightSmall")

				editbox:SetScript("OnEnterPressed", function()
					editbox:ClearFocus()
					editbox:Hide()
					editbox:GetParent().MyObject.typing_value = false
					editbox:GetParent().MyObject.value = tonumber (editbox:GetText()) --do_precision (editbox:GetText())
				end)
				
				editbox:SetScript("OnEscapePressed", function()
					editbox:ClearFocus()
					editbox:Hide()
					editbox:GetParent().MyObject.typing_value = false
					editbox:GetParent().MyObject.value = self.typing_value_started --do_precision (self.typing_value_started)
				end)

				editbox:SetScript("OnTextChanged", function()
					editbox:GetParent().MyObject.typing_can_change = true
					editbox:GetParent().MyObject.value = tonumber (editbox:GetText()) --do_precision 
					editbox:GetParent().MyObject.typing_can_change = false
				end)
				
				DFSliderMetaFunctions.editbox_typevalue = editbox
			end
			
			local pvalue = self.previous_value [2]
			self:SetValue(pvalue)
			
			self.typing_value = true
			self.typing_value_started = pvalue
			
			DFSliderMetaFunctions.editbox_typevalue:SetSize(self.width, self.height)
			DFSliderMetaFunctions.editbox_typevalue:SetPoint("center", self.widget, "center")
			DFSliderMetaFunctions.editbox_typevalue:SetFocus()
			DFSliderMetaFunctions.editbox_typevalue:SetParent(self.widget)
			DFSliderMetaFunctions.editbox_typevalue:SetFrameLevel (self.widget:GetFrameLevel()+1)
			
			if (self.useDecimals) then
				DFSliderMetaFunctions.editbox_typevalue:SetText(tostring (string.format("%.1f", self.value)))
			else
				DFSliderMetaFunctions.editbox_typevalue:SetText(tostring (math.floor (self.value)))
			end
			
			DFSliderMetaFunctions.editbox_typevalue:HighlightText()
			
			DFSliderMetaFunctions.editbox_typevalue:Show()
		end
	end
	
	local OnMouseDown = function(slider, button)
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
	
	local OnMouseUp = function(slider, button)
		slider.MyObject.IsValueChanging = nil
		
		local capsule = slider.MyObject
		local kill = capsule:RunHooksForWidget ("OnMouseUp", slider, button, capsule)
		if (kill) then
			return
		end
	end
	
	local OnHide = function(slider)
		local capsule = slider.MyObject
		local kill = capsule:RunHooksForWidget ("OnHide", slider, capsule)
		if (kill) then
			return
		end
		
		if (slider.MyObject.typing_value) then
			DFSliderMetaFunctions.editbox_typevalue:ClearFocus()
			DFSliderMetaFunctions.editbox_typevalue:SetText("")
			slider.MyObject.typing_valu = false
		end
	end
	
	local OnShow = function(slider)
		local capsule = slider.MyObject
		local kill = capsule:RunHooksForWidget ("OnShow", slider, capsule)
		if (kill) then
			return
		end
	end
	
	local table_insert = table.insert
	local table_remove = table.remove
	
	local OnValueChanged = function(slider)
	
		local amt
		if (slider.MyObject.useDecimals) then
			amt = slider:GetValue()
		else
			amt = do_precision(slider:GetValue())
		end

		if (slider.MyObject.typing_value and not slider.MyObject.typing_can_change) then
			slider.MyObject:SetValue(slider.MyObject.typing_value_started)
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
			slider.amt:SetText(string.format("%.2f", amt))
		else
			slider.amt:SetText(math.floor (amt))
		end
		slider.MyObject.ivalue = amt

	end

------------------------------------------------------------------------------------------------------------
--object constructor

local SwitchOnClick = function(self, button, forced_value, value)

	local slider = self.MyObject
	
	if (rawget (slider, "lockdown")) then
		return
	end
	
	if (forced_value) then
		rawset (slider, "value", not value)
	end

	if (rawget (slider, "value")) then --actived
		rawset (slider, "value", false)
		
		if (slider.backdrop_disabledcolor) then
			slider:SetBackdropColor(unpack (slider.backdrop_disabledcolor))
		else
			slider:SetBackdropColor(1, 0, 0, 0.4)
		end
		
		if (slider.is_checkbox) then
			slider.checked_texture:Hide()
		else
			slider._text:SetText(slider._ltext)
			slider._thumb:ClearAllPoints()
			slider._thumb:SetPoint("left", slider.widget, "left")
		end
	else
		rawset (slider, "value", true)
		if (slider.backdrop_enabledcolor) then
			slider:SetBackdropColor(unpack (slider.backdrop_enabledcolor))
		else
			slider:SetBackdropColor(0, 0, 1, 0.4)
		end
		if (slider.is_checkbox) then
			slider.checked_texture:Show()
		else
			slider._text:SetText(slider._rtext)
			slider._thumb:ClearAllPoints()
			slider._thumb:SetPoint("right", slider.widget, "right")
		end
	end

	if (slider.OnSwitch and not forced_value) then
		local value = rawget (slider, "value")
		if (slider.return_func) then
			value = slider:return_func (value)
		end

		local success, errorText = xpcall (slider.OnSwitch, geterrorhandler(), slider, slider.FixedValue, value)
		if (not success) then
			return
		end

		--trigger hooks
		slider:RunHooksForWidget ("OnSwitch", slider, slider.FixedValue, value)
	end

end

local default_switch_func = function(self, passed_value)
	if (self.value) then
		return false
	else
		return true
	end
end

local switch_get_value = function(self)
	return self.value
end

local switch_set_value = function(self, value)
	if (self.switch_func) then
		value = self:switch_func (value)
	end
	
	SwitchOnClick (self.widget, nil, true, value)
end

local switch_set_fixparameter = function(self, value)
	rawset (self, "FixedValue", value)
end

local switch_disable = function(self)	
	
	if (self.is_checkbox) then
		self.checked_texture:Hide()
	else
		self._text:Hide()
		if (not self.lock_texture) then
			DF:NewImage (self, [[Interface\PetBattles\PetBattle-LockIcon]], 12, 12, "overlay", {0.0546875, 0.9453125, 0.0703125, 0.9453125}, "lock_texture", "$parentLockTexture")
			self.lock_texture:SetDesaturated (true)
			self.lock_texture:SetPoint("center", self._thumb, "center")
		end
		self.lock_texture:Show()
	end
	
	self:SetAlpha (.4)
	rawset (self, "lockdown", true)
end
local switch_enable = function(self)
	if (self.is_checkbox) then
		if (rawget (self, "value")) then
			self.checked_texture:Show()
		else
			self.checked_texture:Hide()
		end
	else
		if (not self.lock_texture) then
			DF:NewImage (self, [[Interface\PetBattles\PetBattle-LockIcon]], 12, 12, "overlay", {0.0546875, 0.9453125, 0.0703125, 0.9453125}, "lock_texture", "$parentLockTexture")
			self.lock_texture:SetDesaturated (true)
			self.lock_texture:SetPoint("center", self._thumb, "center")
		end
		self.lock_texture:Hide()
		self._text:Show()
	end
	
	self:SetAlpha (1)
	return rawset (self, "lockdown", false)
end

local set_switch_func = function(self, newFunction)
	self.OnSwitch = newFunction
end

local set_as_checkbok = function(self)
	if self.is_checkbox and self.checked_texture then return end
	local checked = self:CreateTexture(self:GetName() .. "CheckTexture", "overlay")
	checked:SetTexture([[Interface\Buttons\UI-CheckBox-Check]])
	checked:SetPoint("center", self.button, "center", -1, -1)
	local size_pct = self:GetWidth()/32
	checked:SetSize(32*size_pct, 32*size_pct)
	self.checked_texture = checked
	
	self._thumb:Hide()
	self._text:Hide()
	
	self.is_checkbox = true
	
	if (rawget (self, "value")) then
		self.checked_texture:Show()
		if (self.backdrop_enabledcolor) then
			self:SetBackdropColor(unpack (self.backdrop_enabledcolor))
		else
			self:SetBackdropColor(0, 0, 1, 0.4)
		end		
	else
		self.checked_texture:Hide()
		if (self.backdrop_disabledcolor) then
			self:SetBackdropColor(unpack (self.backdrop_disabledcolor))
		else
			self:SetBackdropColor(0, 0, 1, 0.4)
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

--early checks
	if (not name) then
		name = "DetailsFrameWorkSlider" .. DF.SwitchCounter
		DF.SwitchCounter = DF.SwitchCounter + 1
	elseif (not parent) then
		return error ("Details! FrameWork: parent not found.", 2)
	end
	if (not container) then
		container = parent
	end
	
--defaults
	ltext = ltext or "OFF"
	rtext = rtext or "ON"
	
--build frames
	w = w or 60
	h = h or 20
	
	local slider = DF:NewButton(parent, container, name, member, w, h)
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
	
	slider:SetBackdrop({edgeFile = [[Interface\Buttons\UI-SliderBar-Border]], edgeSize = 8,
	bgFile = [[Interface\AddOns\Details\images\background]], insets = {left = 3, right = 3, top = 5, bottom = 5}})
	
	local thumb = slider:CreateTexture(nil, "artwork")
	thumb:SetTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
	thumb:SetSize(34+(h*0.2), h*1.2)
	thumb:SetAlpha (0.7)
	thumb:SetPoint("left", slider.widget, "left")
	
	local text = slider:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
	text:SetTextColor (.8, .8, .8, 1)
	text:SetPoint("center", thumb, "center")
	
	slider._text = text
	slider._thumb = thumb
	slider._ltext = ltext
	slider._rtext = rtext
	slider.thumb = thumb

	slider.invert_colors = color_inverted
	
	slider:SetScript("OnClick", SwitchOnClick)

	slider:SetValue(default_value)

	slider.isSwitch = true
	
	if (switch_template) then
		slider:SetTemplate (switch_template)
	end
	
	if (with_label) then
		local label = DF:CreateLabel(slider.widget, with_label, nil, nil, nil, "label", nil, "overlay")
		label.text = with_label
		slider.widget:SetPoint("left", label.widget, "right", 2, 0)
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
	end
	if (template.backdropbordercolor) then
		local r, g, b, a = DF:ParseColors(template.backdropbordercolor)
		self:SetBackdropBorderColor(r, g, b, a)
		self.onleave_backdrop_border_color = {r, g, b, a}
	end
	
	if (template.onenterbordercolor) then
		local r, g, b, a = DF:ParseColors(template.onenterbordercolor)
		self.onenter_backdrop_border_color = {r, g, b, a}
	end
	
	if (template.onleavebordercolor) then
		local r, g, b, a = DF:ParseColors(template.onleavebordercolor)
		self.onleave_backdrop_border_color = {r, g, b, a}
	end

	if (template.thumbtexture) then
		if (self.thumb) then
			self.thumb:SetTexture(template.thumbtexture)
		end
	end
	if (template.thumbwidth) then
		if (self.thumb) then
			self.thumb:SetWidth(template.thumbwidth)
		end
	end
	if (template.thumbheight) then
		if (self.thumb) then
			self.thumb:SetHeight(template.thumbheight)
		end
	end
	if (template.thumbcolor) then
		if (self.thumb) then
			local r, g, b, a = DF:ParseColors(template.thumbcolor)
			self.thumb:SetVertexColor (r, g, b, a)
		end
	end
	
	--switch only
	if (template.enabled_backdropcolor) then
		local r, g, b, a = DF:ParseColors(template.enabled_backdropcolor)
		self.backdrop_enabledcolor = {r, g, b, a}
	end
	if (template.disabled_backdropcolor) then
		local r, g, b, a = DF:ParseColors(template.disabled_backdropcolor)
		self.backdrop_disabledcolor = {r, g, b, a}
	end
end

function DF:CreateSlider (parent, w, h, min, max, step, defaultv, isDecemal, member, name, with_label, slider_template, label_template)
	local slider, label = DF:NewSlider (parent, parent, name, member, w, h, min, max, step, defaultv, isDecemal, false, with_label, slider_template, label_template)
	return slider, label
end

function DF:NewSlider (parent, container, name, member, w, h, min, max, step, defaultv, isDecemal, isSwitch, with_label, slider_template, label_template)
	
--early checks
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
	
--defaults	
	min = min or 1
	max = max or 2
	step = step or 1
	defaultv = defaultv or min
	
	w = w or 130
	h = h or 19
	
	--default members:
		SliderObject.lockdown = false
		SliderObject.container = container
		
	SliderObject.slider = CreateFrame("slider", name, parent,"BackdropTemplate")
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
		for funcName, funcAddress in pairs(idx) do 
			if (not DFSliderMetaFunctions [funcName]) then
				DFSliderMetaFunctions [funcName] = function(object, ...)
					local x = loadstring ( "return _G['"..object.slider:GetName().."']:"..funcName.."(...)")
					return x (...)
				end
			end
		end
	end
	
	SliderObject.slider.MyObject = SliderObject
	SliderObject.slider:SetWidth(w)
	SliderObject.slider:SetHeight(h)
	SliderObject.slider:SetOrientation ("horizontal")
	SliderObject.slider:SetMinMaxValues (min, max)
	SliderObject.slider:SetValue(defaultv)
	SliderObject.ivalue = defaultv

	SliderObject.slider:SetBackdrop({edgeFile = "Interface\\Buttons\\UI-SliderBar-Border", edgeSize = 8})
	SliderObject.slider:SetBackdropColor(0.9, 0.7, 0.7, 1.0)

	SliderObject.thumb = SliderObject.slider:CreateTexture(nil, "artwork")
	SliderObject.thumb:SetTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
	SliderObject.thumb:SetSize(30+(h*0.2), h*1.2)
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
		SliderObject.amt:SetText(string.format("%.2f", amt))
	else
		SliderObject.amt:SetText(math.floor (amt))
	end
	
	SliderObject.amt:SetTextColor (.8, .8, .8, 1)
	SliderObject.amt:SetPoint("center", SliderObject.thumb, "center")
	SliderObject.slider.amt = SliderObject.amt

	SliderObject.previous_value = {defaultv or 0, 0, 0}
	
	--hooks
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
	
	SliderObject.slider:SetScript("OnEnter", OnEnter)
	SliderObject.slider:SetScript("OnLeave", OnLeave)
	SliderObject.slider:SetScript("OnHide", OnHide)
	SliderObject.slider:SetScript("OnShow", OnShow)
	SliderObject.slider:SetScript("OnValueChanged", OnValueChanged)
	SliderObject.slider:SetScript("OnMouseDown", OnMouseDown)
	SliderObject.slider:SetScript("OnMouseUp", OnMouseUp)

	setmetatable (SliderObject, DFSliderMetaFunctions)
	
	if (with_label) then
		local label = DF:CreateLabel(SliderObject.slider, with_label, nil, nil, nil, "label", nil, "overlay")
		label.text = with_label
		SliderObject.slider:SetPoint("left", label.widget, "right", 2, 0)
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

DF.AdjustmentSliderOptions = {
	width = 70,
	height = 20,
	scale_factor = 1,
}

DF.AdjustmentSliderFunctions = {
	SetScaleFactor = function(self, scalar)
		self.options.scale_factor = scalar or 1
	end,

	GetScaleFactor = function(self, scalar)
		return self.options.scale_factor
	end,

	SetCallback = function(self, func)
		self.callback = func
	end,

	SetPayload = function(self, ...)
		self.payload = {...}
	end,

	RunCallback = function(adjustmentSlider, valueX, valueY, isLiteral)
		local result, errorText = pcall(adjustmentSlider.callback, adjustmentSlider, valueX, valueY, isLiteral, adjustmentSlider:DumpPayload())
		if (not result) then
			DF:Msg("AdjustmentSlider callback Error:", errorText)
			return false
		end
	end,

	--calculate if the mouse has moved and call a callback
	PressingOnUpdate = function(adjustmentSlider, deltaTime)
		if (GetTime() > adjustmentSlider.NextTick) then
			--get currentr mouse position
			local mouseX, mouseY = GetCursorPosition()
			local verticalValue
			local horizontalValue

			--find distance
			local xDelta = adjustmentSlider.MouseX - mouseX --moving the mouse to right or up result in a negative delta
			local yDelta = adjustmentSlider.MouseY - mouseY

			if (adjustmentSlider.buttonPressed ~= "center") then
				if (adjustmentSlider.buttonPressedTime + 0.5 < GetTime()) then
					local scaleResultBy = adjustmentSlider:GetScaleFactor()
					if (adjustmentSlider.buttonPressed == "left") then
						DF.AdjustmentSliderFunctions.RunCallback(adjustmentSlider, -1 * scaleResultBy, 0, true)

					elseif (adjustmentSlider.buttonPressed == "right") then
						DF.AdjustmentSliderFunctions.RunCallback(adjustmentSlider, 1 * scaleResultBy, 0, true)
					end
				end

			elseif (xDelta ~= 0 or yDelta ~= 0) then
				if (adjustmentSlider.buttonPressed == "center") then
					--invert axis as left is positive and right is negative in the deltas
					xDelta = xDelta * -1
					yDelta = yDelta * -1

					horizontalValue = DF:MapRangeClamped(-20, 20, -1, 1, xDelta)
					verticalValue = DF:MapRangeClamped(-20, 20, -1, 1, yDelta)

					local speed = 6 --how fast it moves
					local mouseDirection = CreateVector2D(mouseX - adjustmentSlider.initialMouseX, mouseY - adjustmentSlider.initialMouseY)
					local length = DF:MapRangeClamped(-100, 100, -1, 1, mouseDirection:GetLength())
					mouseDirection:Normalize()
					mouseDirection:ScaleBy(speed * length)
					adjustmentSlider.centerArrowArtwork:SetPoint("center", adjustmentSlider.centerButton.widget, "center", mouseDirection:GetXY())
				end

				local scaleResultBy = adjustmentSlider:GetScaleFactor()
				DF.AdjustmentSliderFunctions.RunCallback(adjustmentSlider, horizontalValue * scaleResultBy, verticalValue * scaleResultBy, false)

				adjustmentSlider.MouseX = mouseX
				adjustmentSlider.MouseY = mouseY
			end

			adjustmentSlider.NextTick = GetTime() + 0.05
		end
	end,

	--button can be the left or right button
	OnButtonDownkHook = function(button)
		button = button.MyObject

		--change the icon
		if (button.direction == "center") then
			DF:DisableOnEnterScripts()
		end

		local adjustmentSlider = button:GetParent()
		adjustmentSlider.NextTick = GetTime() + 0.05

		--save where the mouse is on the moment of the click
		local mouseX, mouseY = GetCursorPosition()
		adjustmentSlider.MouseX = mouseX
		adjustmentSlider.MouseY = mouseY
		adjustmentSlider.initialMouseX = mouseX
		adjustmentSlider.initialMouseY = mouseY

		adjustmentSlider.buttonPressed = button.direction

		--start monitoring the mouse moviment
		adjustmentSlider.buttonPressedTime = GetTime()
		adjustmentSlider:SetScript("OnUpdate", DF.AdjustmentSliderFunctions.PressingOnUpdate)
	end,

	--button can be the left or right button
	OnButtonUpHook = function(button)
		button = button.MyObject

		--change the icon
		if (button.direction == "center") then
			DF:EnableOnEnterScripts()
		end

		local adjustmentSlider = button:GetParent()

		--check if the mouse did not moved at all, if not send a callback with a value of 1
		local mouseX, mouseY = GetCursorPosition()
		if (mouseX == adjustmentSlider.MouseX and mouseY == adjustmentSlider.MouseY and adjustmentSlider.buttonPressedTime+0.5 > GetTime()) then
			if (button.direction == "left") then
				DF.AdjustmentSliderFunctions.RunCallback(adjustmentSlider, -1, 0, true)
			elseif (button.direction == "right") then
				DF.AdjustmentSliderFunctions.RunCallback(adjustmentSlider, 1, 0, true)
			end
		end

		adjustmentSlider.centerArrowArtwork:SetPoint("center", adjustmentSlider.centerButton.widget, "center", 0, 0)

		adjustmentSlider:SetScript("OnUpdate", nil)
	end,

	Disable = function(adjustmentSlider)
		adjustmentSlider.leftButton:Disable()
		adjustmentSlider.rightButton:Disable()
		adjustmentSlider.centerButton:Disable()
	end,

	Enable = function(adjustmentSlider)
		adjustmentSlider.leftButton:Enable()
		adjustmentSlider.rightButton:Enable()
		adjustmentSlider.centerButton:Enable()
	end,
}

local createAdjustmentSliderFrames = function(parent, options, name)
	--frame it self
	local adjustmentSlider = CreateFrame("frame", name, parent, "BackdropTemplate")

	DF:Mixin(adjustmentSlider, DF.OptionsFunctions)
	DF:Mixin(adjustmentSlider, DF.AdjustmentSliderFunctions)
	DF:Mixin(adjustmentSlider, DF.PayloadMixin)
	DF:Mixin(adjustmentSlider, DF.SetPointMixin)
	--DF:Mixin(adjustmentSlider, DF.FrameMixin)

	adjustmentSlider:BuildOptionsTable(DF.AdjustmentSliderOptions, options)
	adjustmentSlider:SetSize(adjustmentSlider.options.width, adjustmentSlider.options.height)

	local leftButton = DF:CreateButton(adjustmentSlider, function()end, 20, 20, "", "left", -1, nil, nil, name .. "LeftButton")
	local rightButton = DF:CreateButton(adjustmentSlider, function()end, 20, 20, "", "right", 1, nil, nil, name .. "RightButton")

	leftButton:SetHook("OnMouseDown", DF.AdjustmentSliderFunctions.OnButtonDownkHook)
	rightButton:SetHook("OnMouseDown", DF.AdjustmentSliderFunctions.OnButtonDownkHook)
	leftButton:SetHook("OnMouseUp", DF.AdjustmentSliderFunctions.OnButtonUpHook)
	rightButton:SetHook("OnMouseUp", DF.AdjustmentSliderFunctions.OnButtonUpHook)

	leftButton:SetPoint("left", adjustmentSlider, "left", 0, 0)
	rightButton:SetPoint("right", adjustmentSlider, "right", 0, 0)

	leftButton:SetIcon("Minimal_SliderBar_Button_Left", 8, 14)
	rightButton:SetIcon("Minimal_SliderBar_Button_Right", 8, 14)

	leftButton.direction = "left"
	rightButton.direction = "right"

	--center button
	local centerButton = DF:CreateButton(adjustmentSlider, function()end, 20, 20, "", "center", 0, nil, nil, name .. "CenterButton")
	centerButton:SetPoint("center", adjustmentSlider, "center", -3, 0)
	centerButton:SetIcon("Minimal_SliderBar_Button", nil, nil, nil, nil, "transparent")
	centerButton.direction = "center"
	centerButton:SetHook("OnMouseDown", DF.AdjustmentSliderFunctions.OnButtonDownkHook)
	centerButton:SetHook("OnMouseUp", DF.AdjustmentSliderFunctions.OnButtonUpHook)

	local centerArrowArtwork = centerButton:CreateTexture("$parentCenterArrowArtwork", "artwork")
	centerArrowArtwork:SetAtlas("Minimal_SliderBar_Button")
	centerArrowArtwork:SetPoint("center", centerButton.widget, "center", 0, 0)
	centerArrowArtwork:SetSize(16, 16)
	centerArrowArtwork:SetAlpha(1)

	adjustmentSlider.leftButton = leftButton
	adjustmentSlider.rightButton = rightButton
	adjustmentSlider.centerButton = centerButton
	adjustmentSlider.centerArrowArtwork = centerArrowArtwork

	return adjustmentSlider
end

--creates a slider with left and right buttons and a center button, on click the hold, mouse moviments adjust the value and trigger a callback with a normallized x and y values of the mouse movement
--@parent: who is the parent of this frame
--@callback: run when there's a change in any of the two axis
--@options: a table containing options for the frame, see /dump DetailsFramework.AdjustmentSliderOptions
--@name: the name of the frame, if none a generic name is created
function DF:CreateAdjustmentSlider(parent, callback, options, name, ...)
	if (not name) then
		name = "DetailsFrameworkAdjustmentSlider" .. DF.SliderCounter
		DF.SliderCounter = DF.SliderCounter + 1

	elseif (not parent) then
		return error("DF:CreateAdjustmentSlider(): parent not found.", 2)
	end

	local ASFrame = createAdjustmentSliderFrames(parent, options, name)
	ASFrame:SetPayload(...)
	ASFrame.callback = callback

	return ASFrame
end

----------------------------------------------------------------------------------------------------------------
function DF:DisableOnEnterScripts()
	local ignoreOnEnterZone = DF:CreateOnEnterIgnoreZone()
	ignoreOnEnterZone:Show()
end

function DF:EnableOnEnterScripts()
	local ignoreOnEnterZone = DF:CreateOnEnterIgnoreZone()
	ignoreOnEnterZone:Hide()
end

function DF:CreateOnEnterIgnoreZone()
	if (not _G.DetailsFrameworkIgnoreHoverOverFrame) then
		local ignoreOnEnterFrame = CreateFrame("frame", "DetailsFrameworkIgnoreHoverOverFrame", UIParent)
		ignoreOnEnterFrame:SetFrameStrata("TOOLTIP")
		ignoreOnEnterFrame:SetFrameLevel(9999)
		ignoreOnEnterFrame:SetAllPoints()
		ignoreOnEnterFrame:EnableMouse(true)
		ignoreOnEnterFrame:Hide()
	end

	return _G.DetailsFrameworkIgnoreHoverOverFrame
end
