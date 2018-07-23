
local DF = _G ["DetailsFramework"]
if (not DF or not DetailsFrameworkCanLoad) then
	return 
end

local _
local _rawset = rawset --> lua locals
local _rawget = rawget --> lua locals
local _setmetatable = setmetatable --> lua locals
local _unpack = unpack --> lua locals
local _type = type --> lua locals
local _math_floor = math.floor --> lua locals

local SharedMedia = LibStub:GetLibrary ("LibSharedMedia-3.0")

local cleanfunction = function() end
local APIBarFunctions

do
	local metaPrototype = {
		WidgetType = "normal_bar",
		SetHook = DF.SetHook,
		RunHooksForWidget = DF.RunHooksForWidget,
	}

	_G [DF.GlobalWidgetControlNames ["normal_bar"]] = _G [DF.GlobalWidgetControlNames ["normal_bar"]] or metaPrototype
end

local BarMetaFunctions = _G [DF.GlobalWidgetControlNames ["normal_bar"]]

------------------------------------------------------------------------------------------------------------
--> metatables

	BarMetaFunctions.__call = function (_table, value)
		if (not value) then
			return _table.statusbar:GetValue()
		else
			return _table.statusbar:SetValue (value)
		end
	end

	BarMetaFunctions.__add = function (v1, v2) 
		if (_type (v1) == "table") then
			local v = v1.statusbar:GetValue()
			v = v + v2
			v1.statusbar:SetValue (v)
		else
			local v = v2.statusbar:GetValue()
			v = v + v1
			v2.statusbar:SetValue (v)
		end
	end

	BarMetaFunctions.__sub = function (v1, v2) 
		if (_type (v1) == "table") then
			local v = v1.statusbar:GetValue()
			v = v - v2
			v1.statusbar:SetValue (v)
		else
			local v = v2.statusbar:GetValue()
			v = v - v1
			v2.statusbar:SetValue (v)
		end
	end

------------------------------------------------------------------------------------------------------------
--> members

	--> tooltip
	local function gmember_tooltip (_object)
		return _object:GetTooltip()
	end
	--> shown
	local gmember_shown = function (_object)
		return _object.statusbar:IsShown()
	end
	--> frame width
	local gmember_width = function (_object)
		return _object.statusbar:GetWidth()
	end
	--> frame height
	local gmember_height = function (_object)
		return _object.statusbar:GetHeight()
	end
	--> value
	local gmember_value = function (_object)
		return _object.statusbar:GetValue()
	end
	--> right text
	local gmember_rtext = function (_object)
		return _object.textright:GetText()
	end
	--> left text
	local gmember_ltext = function (_object)
		return _object.textleft:GetText()
	end
	--> left color
	local gmember_color = function (_object)
		return _object._texture.original_colors
	end
	--> icon
	local gmember_icon = function (_object)
		return _object._icon:GetTexture()
	end
	--> texture
	local gmember_texture = function (_object)
		return _object._texture:GetTexture()
	end	
	--> font size
	local gmember_textsize = function (_object)
		local _, fontsize = _object.textleft:GetFont()
		return fontsize
	end
	--> font face
	local gmember_textfont = function (_object)
		local fontface = _object.textleft:GetFont()
		return fontface
	end
	--> font color
	local gmember_textcolor = function (_object)
		return _object.textleft:GetTextColor()
	end

	BarMetaFunctions.GetMembers = BarMetaFunctions.GetMembers or {}
	BarMetaFunctions.GetMembers ["tooltip"] = gmember_tooltip
	BarMetaFunctions.GetMembers ["shown"] = gmember_shown
	BarMetaFunctions.GetMembers ["width"] = gmember_width
	BarMetaFunctions.GetMembers ["height"] = gmember_height
	BarMetaFunctions.GetMembers ["value"] = gmember_value
	BarMetaFunctions.GetMembers ["lefttext"] = gmember_ltext
	BarMetaFunctions.GetMembers ["righttext"] = gmember_rtext
	BarMetaFunctions.GetMembers ["color"] = gmember_color
	BarMetaFunctions.GetMembers ["icon"] = gmember_icon
	BarMetaFunctions.GetMembers ["texture"] = gmember_texture
	BarMetaFunctions.GetMembers ["fontsize"] = gmember_textsize
	BarMetaFunctions.GetMembers ["fontface"] = gmember_textfont
	BarMetaFunctions.GetMembers ["fontcolor"] = gmember_textcolor
	BarMetaFunctions.GetMembers ["textsize"] = gmember_textsize --alias
	BarMetaFunctions.GetMembers ["textfont"] = gmember_textfont --alias
	BarMetaFunctions.GetMembers ["textcolor"] = gmember_textcolor --alias
	
	BarMetaFunctions.__index = function (_table, _member_requested)

		local func = BarMetaFunctions.GetMembers [_member_requested]
		if (func) then
			return func (_table, _member_requested)
		end
		
		local fromMe = _rawget (_table, _member_requested)
		if (fromMe) then
			return fromMe
		end
		
		return BarMetaFunctions [_member_requested]
	end
	
	
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


	--> tooltip
	local smember_tooltip = function (_object, _value)
		return _object:SetTooltip (_value)
	end
	--> show
	local smember_shown = function (_object, _value)
		if (_value) then
			return _object:Show()
		else
			return _object:Hide()
		end
	end
	--> hide
	local smember_hide = function (_object, _value)
		if (_value) then
			return _object:Hide()
		else
			return _object:Show()
		end
	end
	--> width
	local smember_width = function (_object, _value)
		return _object.statusbar:SetWidth (_value)
	end
	--> height
	local smember_height = function (_object, _value)
		return _object.statusbar:SetHeight (_value)
	end
	--> statusbar value
	local smember_value = function (_object, _value)
		_object.statusbar:SetValue (_value)
		return _object.div:SetPoint ("left", _object.statusbar, "left", _value * (_object.statusbar:GetWidth()/100) - 16, 0)
	end
	--> right text
	local smember_rtext = function (_object, _value)
		return _object.textright:SetText (_value)
	end
	--> left text
	local smember_ltext = function (_object, _value)
		return _object.textleft:SetText (_value)
	end
	--> color
	local smember_color = function (_object, _value)
		local _value1, _value2, _value3, _value4 = DF:ParseColors (_value)
		
		_object.statusbar:SetStatusBarColor (_value1, _value2, _value3, _value4)
		_object._texture.original_colors = {_value1, _value2, _value3, _value4}
		_object.timer_texture:SetVertexColor (_value1, _value2, _value3, _value4)
		
		_object.timer_textureR:SetVertexColor (_value1, _value2, _value3, _value4)

		return _object._texture:SetVertexColor (_value1, _value2, _value3, _value4)
	end
	--> background color
	local smember_backgroundcolor = function (_object, _value)
		local _value1, _value2, _value3, _value4 = DF:ParseColors (_value)
		return _object.background:SetVertexColor (_value1, _value2, _value3, _value4)
	end
	--> icon
	local smember_icon = function (_object, _value)
		if (type (_value) == "table") then
			local _value1, _value2 = _unpack (_value)
			_object._icon:SetTexture (_value1)
			if (_value2) then
				_object._icon:SetTexCoord (_unpack (_value2))
			end
		else
			_object._icon:SetTexture (_value)
		end
		return
	end
	--> texture
	local smember_texture = function (_object, _value)
		if (type (_value) == "table") then
			local _value1, _value2 = _unpack (_value)
			_object._texture:SetTexture (_value1)
			_object.timer_texture:SetTexture (_value1)
			_object.timer_textureR:SetTexture (_value1)
			if (_value2) then
				_object._texture:SetTexCoord (_unpack (_value2))
				_object.timer_texture:SetTexCoord (_unpack (_value2))
				_object.timer_textureR:SetTexCoord (_unpack (_value2))
			end
		else
			if (_value:find ("\\")) then
				_object._texture:SetTexture (_value)
			else
				local file = SharedMedia:Fetch ("statusbar", _value)
				if (file) then
					_object._texture:SetTexture (file)
					_object.timer_texture:SetTexture (file)
					_object.timer_textureR:SetTexture (file)
				else
					_object._texture:SetTexture (_value)
					_object.timer_texture:SetTexture (_value)
					_object.timer_textureR:SetTexture (_value)
				end
			end
		end
		return
	end
	--> background texture
	local smember_backgroundtexture = function (_object, _value)
		if (_value:find ("\\")) then
			_object.background:SetTexture (_value)
		else
			local file = SharedMedia:Fetch ("statusbar", _value)
			if (file) then
				_object.background:SetTexture (file)
			else
				_object.background:SetTexture (_value)
			end
		end
		return
	end
	--> font face
	local smember_textfont = function (_object, _value)
		DF:SetFontFace (_object.textleft, _value)
		return DF:SetFontFace (_object.textright, _value)
	end
	--> font size
	local smember_textsize = function (_object, _value)
		DF:SetFontSize (_object.textleft, _value)
		return DF:SetFontSize (_object.textright, _value)
	end
	--> font color
	local smember_textcolor = function (_object, _value)
		local _value1, _value2, _value3, _value4 = DF:ParseColors (_value)
		_object.textleft:SetTextColor (_value1, _value2, _value3, _value4)
		return _object.textright:SetTextColor (_value1, _value2, _value3, _value4)
	end
	--> outline (shadow)
	local smember_outline = function (_object, _value)
		DF:SetFontOutline (_object.textleft, _value)
		return DF:SetFontOutline (_object.textright, _value)
	end

	BarMetaFunctions.SetMembers = BarMetaFunctions.SetMembers or {}
	BarMetaFunctions.SetMembers["tooltip"] = smember_tooltip
	BarMetaFunctions.SetMembers["shown"] = smember_shown
	BarMetaFunctions.SetMembers["width"] = smember_width
	BarMetaFunctions.SetMembers["height"] = smember_height
	BarMetaFunctions.SetMembers["value"] = smember_value
	BarMetaFunctions.SetMembers["righttext"] = smember_rtext
	BarMetaFunctions.SetMembers["lefttext"] = smember_ltext
	BarMetaFunctions.SetMembers["color"] = smember_color
	BarMetaFunctions.SetMembers["backgroundcolor"] = smember_backgroundcolor
	BarMetaFunctions.SetMembers["icon"] = smember_icon
	BarMetaFunctions.SetMembers["texture"] = smember_texture
	BarMetaFunctions.SetMembers["backgroundtexture"] = smember_backgroundtexture
	BarMetaFunctions.SetMembers["fontsize"] = smember_textsize
	BarMetaFunctions.SetMembers["fontface"] = smember_textfont
	BarMetaFunctions.SetMembers["fontcolor"] = smember_textcolor
	BarMetaFunctions.SetMembers["textsize"] = smember_textsize --alias
	BarMetaFunctions.SetMembers["textfont"] = smember_textfont --alias
	BarMetaFunctions.SetMembers["textcolor"] = smember_textcolor --alias
	BarMetaFunctions.SetMembers["shadow"] = smember_outline
	BarMetaFunctions.SetMembers["outline"] = smember_outline --alias
	
	BarMetaFunctions.__newindex = function (_table, _key, _value)
	
		local func = BarMetaFunctions.SetMembers [_key]
		if (func) then
			return func (_table, _value)
		else
			return _rawset (_table, _key, _value)
		end
	end

------------------------------------------------------------------------------------------------------------
--> methods

--> show & hide
	function BarMetaFunctions:Show()
		self.statusbar:Show()
	end
	function BarMetaFunctions:Hide()
		self.statusbar:Hide()
	end

--> set value (status bar)
	function BarMetaFunctions:SetValue (value)
		if (not value) then
			value = 0
		end
		self.statusbar:SetValue (value)
		self.div:SetPoint ("left", self.statusbar, "left", value * (self.statusbar:GetWidth()/100) - 16, 0)
	end
	
--> set point
	function BarMetaFunctions:SetPoint (v1, v2, v3, v4, v5)
		v1, v2, v3, v4, v5 = DF:CheckPoints (v1, v2, v3, v4, v5, self)
		if (not v1) then
			print ("Invalid parameter for SetPoint")
			return
		end
		return self.widget:SetPoint (v1, v2, v3, v4, v5)
	end
	
--> set sizes
	function BarMetaFunctions:SetSize (w, h)
		if (w) then
			self.statusbar:SetWidth (w)
		end
		if (h) then
			self.statusbar:SetHeight (h)
		end
	end

--> set texture
	function BarMetaFunctions:SetTexture (texture)
		self._texture:SetTexture (texture)
	end
	
--> set texts
	function BarMetaFunctions:SetLeftText (text)
		self.textleft:SetText (text)
	end
	function BarMetaFunctions:SetRightText (text)
		self.textright:SetText (text)
	end
	
--> set color
	function BarMetaFunctions:SetColor (r, g, b, a)
		r, g, b, a = DF:ParseColors (r, g, b, a)
		
		self._texture:SetVertexColor (r, g, b, a)
		self.statusbar:SetStatusBarColor (r, g, b, a)
		self._texture.original_colors = {r, g, b, a}
	end
	
--> set icons
	function BarMetaFunctions:SetIcon (texture, ...)
		self._icon:SetTexture (texture)
		if (...) then
			local L, R, U, D = _unpack (...)
			self._icon:SetTexCoord (L, R, U, D)
		end
	end

--> show div
	function BarMetaFunctions:ShowDiv (bool)
		if (bool) then
			self.div:Show()
		else
			self.div:Hide()
		end
	end

-- tooltip
	function BarMetaFunctions:SetTooltip (tooltip)
		if (tooltip) then
			return _rawset (self, "have_tooltip", tooltip)
		else
			return _rawset (self, "have_tooltip", nil)
		end
	end
	function BarMetaFunctions:GetTooltip()
		return _rawget (self, "have_tooltip")
	end
	
-- frame levels
	function BarMetaFunctions:GetFrameLevel()
		return self.statusbar:GetFrameLevel()
	end
	function BarMetaFunctions:SetFrameLevel (level, frame)
		if (not frame) then
			return self.statusbar:SetFrameLevel (level)
		else
			local framelevel = frame:GetFrameLevel (frame) + level
			return self.statusbar:SetFrameLevel (framelevel)
		end
	end

-- frame stratas
	function BarMetaFunctions:SetFrameStrata()
		return self.statusbar:GetFrameStrata()
	end
	function BarMetaFunctions:SetFrameStrata (strata)
		if (_type (strata) == "table") then
			self.statusbar:SetFrameStrata (strata:GetFrameStrata())
		else
			self.statusbar:SetFrameStrata (strata)
		end
	end
	
--> container
	function BarMetaFunctions:SetContainer (container)
		self.container = container
	end
	
------------------------------------------------------------------------------------------------------------
--> scripts

	local OnEnter = function (frame)
		local capsule = frame.MyObject
		local kill = capsule:RunHooksForWidget ("OnEnter", frame, capsule)
		if (kill) then
			return
		end
		
		frame.MyObject.background:Show()
		
		if (frame.MyObject.have_tooltip) then 
			GameCooltip2:Reset()
			GameCooltip2:AddLine (frame.MyObject.have_tooltip)
			GameCooltip2:ShowCooltip (frame, "tooltip")
		end

	end
	
	local OnLeave = function (frame)
		local capsule = frame.MyObject
		local kill = capsule:RunHooksForWidget ("OnLeave", frame, capsule)
		if (kill) then
			return
		end
		
		if (frame.MyObject.have_tooltip) then 
			GameCooltip2:ShowMe (false)
		end
	end
	
	local OnHide = function (frame)
		local capsule = frame.MyObject
		local kill = capsule:RunHooksForWidget ("OnHide", frame, capsule)
		if (kill) then
			return
		end
	end
	
	local OnShow = function (frame)
		local capsule = frame.MyObject
		local kill = capsule:RunHooksForWidget ("OnShow", frame, capsule)
		if (kill) then
			return
		end
	end
	
	local OnMouseDown = function (frame, button)
		local capsule = frame.MyObject
		local kill = capsule:RunHooksForWidget ("OnMouseDown", frame, button, capsule)
		if (kill) then
			return
		end
		
		if (not frame.MyObject.container.isLocked and frame.MyObject.container:IsMovable()) then
			if (not frame.isLocked and frame:IsMovable()) then
				frame.MyObject.container.isMoving = true
				frame.MyObject.container:StartMoving()
			end
		end
	end
	
	local OnMouseUp = function (frame, button)
		local capsule = frame.MyObject
		local kill = capsule:RunHooksForWidget ("OnMouseUp", frame, button, capsule)
		if (kill) then
			return
		end
		
		if (frame.MyObject.container.isMoving) then
			frame.MyObject.container:StopMovingOrSizing()
			frame.MyObject.container.isMoving = false
		end
	end
	
------------------------------------------------------------------------------------------------------------
--> timer
	
	function BarMetaFunctions:OnTimerEnd()
		local capsule = self
		local kill = capsule:RunHooksForWidget ("OnTimerEnd", self.widget, capsule)
		if (kill) then
			return
		end
		
		self.timer_texture:Hide()
		self.timer_textureR:Hide()
		self.div_timer:Hide()
		self:Hide()
		self.timer = false
	end

	function BarMetaFunctions:CancelTimerBar (no_timer_end)
		if (not self.HasTimer) then
			return
		end
		if (self.TimerScheduled) then
			DF:CancelTimer (self.TimerScheduled)
			self.TimerScheduled = nil
		else
			if (self.statusbar:GetScript ("OnUpdate")) then
				self.statusbar:SetScript ("OnUpdate", nil)
			end
		end
		self.righttext = ""
		if (not no_timer_end) then
			self:OnTimerEnd()
		end
	end

	local OnUpdate = function (self, elapsed)
		--> percent of elapsed
		local pct = abs (self.end_timer - GetTime() - self.tempo) / self.tempo
		if (self.inverse) then
			self.t:SetWidth (self.total_size * pct)
		else
			self.t:SetWidth (self.total_size * abs (pct-1))
		end
		
		--> right text
		self.remaining = self.remaining - elapsed
		if (self.MyObject.RightTextIsTimer) then
			self.righttext:SetText (DF:IntegerToTimer (self.remaining))
		else
			self.righttext:SetText (_math_floor (self.remaining))
		end

		if (pct >= 1) then
			self.righttext:SetText ("")
			self:SetScript ("OnUpdate", nil)
			self.MyObject.HasTimer = nil
			self.MyObject:OnTimerEnd()
		end
	end
	
	function BarMetaFunctions:SetTimer (tempo, end_at)

		if (end_at) then
			self.statusbar.tempo = end_at - tempo
			self.statusbar.remaining = end_at - GetTime()
			self.statusbar.end_timer = end_at
		else
			self.statusbar.tempo = tempo
			self.statusbar.remaining = tempo
			self.statusbar.end_timer = GetTime() + tempo
		end

		self.statusbar.total_size = self.statusbar:GetWidth()
		self.statusbar.inverse = self.BarIsInverse
		
		self (0)
		
		self.div_timer:Show()
		self.background:Show()
		self:Show()
		
		if (self.LeftToRight) then
			self.timer_texture:Hide()
			self.timer_textureR:Show()
			self.statusbar.t = self.timer_textureR
			self.timer_textureR:ClearAllPoints()
			self.timer_textureR:SetPoint ("right", self.statusbar, "right")
			self.div_timer:SetPoint ("left", self.timer_textureR, "left", -14, -1)
		else
			self.timer_texture:Show()
			self.timer_textureR:Hide()
			self.statusbar.t = self.timer_texture
			self.timer_texture:ClearAllPoints()
			self.timer_texture:SetPoint ("left", self.statusbar, "left")
			self.div_timer:SetPoint ("left", self.timer_texture, "right", -16, -1)
		end
		
		if (self.BarIsInverse) then
			self.statusbar.t:SetWidth (1)
		else
			self.statusbar.t:SetWidth (self.statusbar.total_size)
		end
		
		self.timer = true
		
		self.HasTimer = true
		self.TimerScheduled = DF:ScheduleTimer ("StartTimeBarAnimation", 0.1, self)
	end
	
	function DF:StartTimeBarAnimation (timebar)
		timebar.TimerScheduled = nil
		timebar.statusbar:SetScript ("OnUpdate", OnUpdate)
	end
	
------------------------------------------------------------------------------------------------------------
--> object constructor

function DetailsFrameworkNormalBar_OnCreate (self)
	self.texture.original_colors = {1, 1, 1, 1}
	self.background.original_colors = {.3, .3, .3, .3}
	self.timertexture.original_colors = {.3, .3, .3, .3}
	return true
end

function DF:CreateBar (parent, texture, w, h, value, member, name)
	return DF:NewBar (parent, parent, name, member, w, h, value, texture)
end

function DF:NewBar (parent, container, name, member, w, h, value, texture_name)

	if (not name) then
		name = "DetailsFrameworkBarNumber" .. DF.BarNameCounter
		DF.BarNameCounter = DF.BarNameCounter + 1

	elseif (not parent) then
		return error ("Details! FrameWork: parent not found.", 2)
	elseif (not container) then
		container = parent
	end
	
	if (name:find ("$parent")) then
		local parentName = DF.GetParentName (parent)
		name = name:gsub ("$parent", parentName)
	end
	
	local BarObject = {type = "bar", dframework = true}
	
	if (member) then
		parent [member] = BarObject
	end
	
	if (parent.dframework) then
		parent = parent.widget
	end
	if (container.dframework) then
		container = container.widget
	end	
	
	value = value or 0
	w = w or 150
	h = h or 14

	--> default members:
		--> misc
		BarObject.locked = false

	BarObject.container = container
	
	--> create widgets
		BarObject.statusbar = CreateFrame ("statusbar", name, parent, "DetailsFrameworkNormalBarTemplate")
		BarObject.widget = BarObject.statusbar
		
		if (not APIBarFunctions) then
			APIBarFunctions = true
			local idx = getmetatable (BarObject.statusbar).__index
			for funcName, funcAddress in pairs (idx) do 
				if (not BarMetaFunctions [funcName]) then
					BarMetaFunctions [funcName] = function (object, ...)
						local x = loadstring ( "return _G['"..object.statusbar:GetName().."']:"..funcName.."(...)")
						return x (...)
					end
				end
			end
		end
		
		BarObject.statusbar:SetHeight (h)
		BarObject.statusbar:SetWidth (w)
		BarObject.statusbar:SetFrameLevel (parent:GetFrameLevel()+1)
		BarObject.statusbar:SetMinMaxValues (0, 100)
		BarObject.statusbar:SetValue (value or 50)
		BarObject.statusbar.MyObject = BarObject

		BarObject.timer_texture = _G [name .. "_timerTexture"]
		BarObject.timer_texture:SetWidth (w)
		BarObject.timer_texture:SetHeight (h)
		
		BarObject.timer_textureR = _G [name .. "_timerTextureR"]
		BarObject.timer_textureR:Hide()
		
		BarObject._texture = _G [name .. "_statusbarTexture"]
		BarObject.background = _G [name .. "_background"]
		BarObject._icon = _G [name .. "_icon"]
		BarObject.textleft = _G [name .. "_TextLeft"]
		BarObject.textright = _G [name .. "_TextRight"]
		BarObject.div = _G [name .. "_sparkMouseover"]
		BarObject.div_timer = _G [name .. "_sparkTimer"]
	
	--> hooks
		BarObject.HookList = {
			OnEnter = {},
			OnLeave = {},
			OnHide = {},
			OnShow = {},
			OnMouseDown = {},
			OnMouseUp = {},
			OnTimerEnd = {},
		}
	
		BarObject.statusbar:SetScript ("OnEnter", OnEnter)
		BarObject.statusbar:SetScript ("OnLeave", OnLeave)
		BarObject.statusbar:SetScript ("OnHide", OnHide)
		BarObject.statusbar:SetScript ("OnShow", OnShow)
		BarObject.statusbar:SetScript ("OnMouseDown", OnMouseDown)
		BarObject.statusbar:SetScript ("OnMouseUp", OnMouseUp)
		
	--> set class
		_setmetatable (BarObject, BarMetaFunctions)

	--> set texture
		if (texture_name) then
			smember_texture (BarObject, texture_name)
		end
		
	return BarObject
end --endd
