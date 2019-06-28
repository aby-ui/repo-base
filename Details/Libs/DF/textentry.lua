
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
local APITextEntryFunctions = false

do
	local metaPrototype = {
		WidgetType = "textentry",
		SetHook = DF.SetHook,
		RunHooksForWidget = DF.RunHooksForWidget,
	}

	_G [DF.GlobalWidgetControlNames ["textentry"]] = _G [DF.GlobalWidgetControlNames ["textentry"]] or metaPrototype
end

local TextEntryMetaFunctions = _G [DF.GlobalWidgetControlNames ["textentry"]]
DF.TextEntryCounter = DF.TextEntryCounter or 1

------------------------------------------------------------------------------------------------------------
--> metatables

	TextEntryMetaFunctions.__call = function (_table, value)
		--> unknow
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
		return _object.editbox:GetWidth()
	end
	--> frame height
	local gmember_height = function (_object)
		return _object.editbox:GetHeight()
	end
	--> get text
	local gmember_text = function (_object)
		return _object.editbox:GetText()
	end

	TextEntryMetaFunctions.GetMembers = TextEntryMetaFunctions.GetMembers or {}
	TextEntryMetaFunctions.GetMembers ["tooltip"] = gmember_tooltip
	TextEntryMetaFunctions.GetMembers ["shown"] = gmember_shown
	TextEntryMetaFunctions.GetMembers ["width"] = gmember_width
	TextEntryMetaFunctions.GetMembers ["height"] = gmember_height
	TextEntryMetaFunctions.GetMembers ["text"] = gmember_text

	TextEntryMetaFunctions.__index = function (_table, _member_requested)
		local func = TextEntryMetaFunctions.GetMembers [_member_requested]
		if (func) then
			return func (_table, _member_requested)
		end
		
		local fromMe = _rawget (_table, _member_requested)
		if (fromMe) then
			return fromMe
		end
		
		return TextEntryMetaFunctions [_member_requested]
	end
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
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
		return _object.editbox:SetWidth (_value)
	end
	--> frame height
	local smember_height = function (_object, _value)
		return _object.editbox:SetHeight (_value)
	end
	--> set text
	local smember_text = function (_object, _value)
		return _object.editbox:SetText (_value)
	end
	--> set multiline
	local smember_multiline = function (_object, _value)
		if (_value) then
			return _object.editbox:SetMultiLine (true)
		else
			return _object.editbox:SetMultiLine (false)
		end
	end
	--> text horizontal pos
	local smember_horizontalpos = function (_object, _value)
		return _object.editbox:SetJustifyH (string.lower (_value))
	end
	
	TextEntryMetaFunctions.SetMembers = TextEntryMetaFunctions.SetMembers or {}
	TextEntryMetaFunctions.SetMembers ["tooltip"] = smember_tooltip
	TextEntryMetaFunctions.SetMembers ["show"] = smember_show
	TextEntryMetaFunctions.SetMembers ["hide"] = smember_hide
	TextEntryMetaFunctions.SetMembers ["width"] = smember_width
	TextEntryMetaFunctions.SetMembers ["height"] = smember_height
	TextEntryMetaFunctions.SetMembers ["text"] = smember_text
	TextEntryMetaFunctions.SetMembers ["multiline"] = smember_multiline
	TextEntryMetaFunctions.SetMembers ["align"] = smember_horizontalpos
	
	TextEntryMetaFunctions.__newindex = function (_table, _key, _value)
		local func = TextEntryMetaFunctions.SetMembers [_key]
		if (func) then
			return func (_table, _value)
		else
			return _rawset (_table, _key, _value)
		end
	end

------------------------------------------------------------------------------------------------------------
--> methods
	local cleanfunction = function()end
	function TextEntryMetaFunctions:SetEnterFunction (func, param1, param2)
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
	end

--> set point
	function TextEntryMetaFunctions:SetPoint (MyAnchor, SnapTo, HisAnchor, x, y, Width)
	
		if (type (MyAnchor) == "boolean" and MyAnchor and self.space) then
			local textWidth = self.label:GetStringWidth()+2
			self.editbox:SetWidth (self.space - textWidth - 15)
			return
			
		elseif (type (MyAnchor) == "boolean" and MyAnchor and not self.space) then
			self.space = self.label:GetStringWidth()+2 + self.editbox:GetWidth()
		end
		
		if (Width) then
			self.space = Width
		end
		
		MyAnchor, SnapTo, HisAnchor, x, y = DF:CheckPoints (MyAnchor, SnapTo, HisAnchor, x, y, self)
		if (not MyAnchor) then
			print ("Invalid parameter for SetPoint")
			return
		end
	
		if (self.space) then
			self.label:ClearAllPoints()
			self.editbox:ClearAllPoints()
			
			self.label:SetPoint (MyAnchor, SnapTo, HisAnchor, x, y)
			self.editbox:SetPoint ("left", self.label, "right", 2, 0)
			
			local textWidth = self.label:GetStringWidth()+2
			self.editbox:SetWidth (self.space - textWidth - 15)
		else
			self.label:ClearAllPoints()
			self.editbox:ClearAllPoints()
			self.editbox:SetPoint (MyAnchor, SnapTo, HisAnchor, x, y)
		end

	end
	
	function TextEntryMetaFunctions:SetText (text)
		self.editbox:SetText (text)
	end	
	function TextEntryMetaFunctions:GetText()
		return self.editbox:GetText()
	end
	
--> frame levels
	function TextEntryMetaFunctions:GetFrameLevel()
		return self.editbox:GetFrameLevel()
	end
	function TextEntryMetaFunctions:SetFrameLevel (level, frame)
		if (not frame) then
			return self.editbox:SetFrameLevel (level)
		else
			local framelevel = frame:GetFrameLevel (frame) + level
			return self.editbox:SetFrameLevel (framelevel)
		end
	end

--> select all text
	function TextEntryMetaFunctions:SelectAll()
		self.editbox:HighlightText()
	end
	
--> set labal description
	function TextEntryMetaFunctions:SetLabelText (text)
		if (text) then
			self.label:SetText (text)
		else
			self.label:SetText ("")
		end
		self:SetPoint (true) --> refresh
	end

--> set tab order
	function TextEntryMetaFunctions:SetNext (nextbox)
		self.next = nextbox
	end
	
--> blink
	function TextEntryMetaFunctions:Blink()
		self.label:SetTextColor (1, .2, .2, 1)
	end	
	
--> show & hide
	function TextEntryMetaFunctions:IsShown()
		return self.editbox:IsShown()
	end
	function TextEntryMetaFunctions:Show()
		return self.editbox:Show()
	end
	function TextEntryMetaFunctions:Hide()
		return self.editbox:Hide()
	end
	
-- tooltip
	function TextEntryMetaFunctions:SetTooltip (tooltip)
		if (tooltip) then
			return _rawset (self, "have_tooltip", tooltip)
		else
			return _rawset (self, "have_tooltip", nil)
		end
	end
	function TextEntryMetaFunctions:GetTooltip()
		return _rawget (self, "have_tooltip")
	end
	
--> hooks
	function TextEntryMetaFunctions:Enable()
		if (not self.editbox:IsEnabled()) then
			self.editbox:Enable()
			self.editbox:SetBackdropBorderColor (unpack (self.enabled_border_color))
			self.editbox:SetBackdropColor (unpack (self.enabled_backdrop_color))
			self.editbox:SetTextColor (unpack (self.enabled_text_color))
			if (self.editbox.borderframe) then
				self.editbox.borderframe:SetBackdropColor (unpack (self.editbox.borderframe.onleave_backdrop))
			end
		end
	end
	
	function TextEntryMetaFunctions:Disable()
		if (self.editbox:IsEnabled()) then
			self.enabled_border_color = {self.editbox:GetBackdropBorderColor()}
			self.enabled_backdrop_color = {self.editbox:GetBackdropColor()}
			self.enabled_text_color = {self.editbox:GetTextColor()}

			self.editbox:Disable()

			self.editbox:SetBackdropBorderColor (.5, .5, .5, .5)
			self.editbox:SetBackdropColor (.5, .5, .5, .5)
			self.editbox:SetTextColor (.5, .5, .5, .5)
			
			if (self.editbox.borderframe) then
				self.editbox.borderframe:SetBackdropColor (.5, .5, .5, .5)
			end
		end
	end
	
------------------------------------------------------------------------------------------------------------
--> scripts and hooks

	local OnEnter = function (textentry)
		local capsule = textentry.MyObject
		
		local kill = capsule:RunHooksForWidget ("OnEnter", textentry, capsule)
		if (kill) then
			return
		end

		if (capsule.have_tooltip) then 
			GameCooltip2:Preset (2)
			GameCooltip2:AddLine (capsule.have_tooltip)
			GameCooltip2:ShowCooltip (textentry, "tooltip")
		end
		
		textentry.mouse_over = true 

		if (textentry:IsEnabled()) then 
			textentry.current_bordercolor = textentry.current_bordercolor or {textentry:GetBackdropBorderColor()}
			textentry:SetBackdropBorderColor (1, 1, 1, 1)
		end
	end
	
	local OnLeave = function (textentry)
		local capsule = textentry.MyObject
	
		local kill = capsule:RunHooksForWidget ("OnLeave", textentry, capsule)
		if (kill) then
			return
		end

		if (textentry.MyObject.have_tooltip) then 
			GameCooltip2:ShowMe (false)
		end
		
		textentry.mouse_over = false 
		
		if (textentry:IsEnabled()) then 
			textentry:SetBackdropBorderColor (unpack (textentry.current_bordercolor))
		end
	end
	
	local OnHide = function (textentry)
		local capsule = textentry.MyObject
		
		local kill = capsule:RunHooksForWidget ("OnHide", textentry, capsule)
		if (kill) then
			return
		end
	end
	
	local OnShow = function (textentry)
		local capsule = textentry.MyObject
		
		local kill = capsule:RunHooksForWidget ("OnShow", textentry, capsule)
		if (kill) then
			return
		end
	end

	local OnEnterPressed = function (textentry, byScript)
		local capsule = textentry.MyObject
	
		local kill = capsule:RunHooksForWidget ("OnEnterPressed", textentry, capsule, capsule.text)
		if (kill) then
			return
		end
	
		local texto = DF:trim (textentry:GetText())
		if (_string_len (texto) > 0) then 
			textentry.text = texto
			if (textentry.MyObject.func) then 
				textentry.MyObject.func (textentry.MyObject.param1, textentry.MyObject.param2, texto, textentry, byScript or textentry)
			end
		else
			textentry:SetText ("")
			textentry.MyObject.currenttext = ""
		end
		
		if (not capsule.NoClearFocusOnEnterPressed) then
			textentry.focuslost = true --> quando estiver editando e clicar em outra caixa
			textentry:ClearFocus()
			
			if (textentry.MyObject.tab_on_enter and textentry.MyObject.next) then
				textentry.MyObject.next:SetFocus()
			end
		end
	end
	
	local OnEscapePressed = function (textentry)
		local capsule = textentry.MyObject
	
		local kill = capsule:RunHooksForWidget ("OnEscapePressed", textentry, capsule, capsule.text)
		if (kill) then
			return
		end	

		textentry.focuslost = true
		textentry:ClearFocus() 
	end
	
	local OnSpacePressed = function (textentry)
		local capsule = textentry.MyObject
		
		local kill = capsule:RunHooksForWidget ("OnSpacePressed", textentry, capsule)
		if (kill) then
			return
		end
	end
	
	local OnEditFocusLost = function (textentry)

		local capsule = textentry.MyObject
	
		if (textentry:IsShown()) then
		
			local kill = capsule:RunHooksForWidget ("OnEditFocusLost", textentry, capsule, capsule.text)
			if (kill) then
				return
			end
		
			if (not textentry.focuslost) then
				local texto = DF:trim (textentry:GetText())
				if (_string_len (texto) > 0) then 
					textentry.MyObject.currenttext = texto
					if (textentry.MyObject.func) then 
						textentry.MyObject.func (textentry.MyObject.param1, textentry.MyObject.param2, texto, textentry, nil)
					end
				else 
					textentry:SetText ("") 
					textentry.MyObject.currenttext = ""
				end 
			else
				textentry.focuslost = false
			end
			
			textentry.MyObject.label:SetTextColor (.8, .8, .8, 1)

		end
	end
	
	local OnEditFocusGained = function (textentry)
	
		local capsule = textentry.MyObject
		
		local kill = capsule:RunHooksForWidget ("OnEditFocusGained", textentry, capsule)
		if (kill) then
			return
		end

		textentry.MyObject.label:SetTextColor (1, 1, 1, 1)
	end
	
	local OnChar = function (textentry, char)
		local capsule = textentry.MyObject
	
		local kill = capsule:RunHooksForWidget ("OnChar", textentry, char, capsule)
		if (kill) then
			return
		end
	end
	
	local OnTextChanged = function (textentry, byUser) 
		local capsule = textentry.MyObject
		
		local kill = capsule:RunHooksForWidget ("OnTextChanged", textentry, byUser, capsule)
		if (kill) then
			return
		end
	end
	
	local OnTabPressed = function (textentry) 
	
		local capsule = textentry.MyObject
	
		local kill = capsule:RunHooksForWidget ("OnTabPressed", textentry, byUser, capsule)
		if (kill) then
			return
		end
		
		if (textentry.MyObject.next) then 
			OnEnterPressed (textentry, false)
			textentry.MyObject.next:SetFocus()
		end
	end
	
	function TextEntryMetaFunctions:PressEnter (byScript)
		OnEnterPressed (self.editbox, byScript)
	end
	
------------------------------------------------------------------------------------------------------------

function TextEntryMetaFunctions:SetTemplate (template)
	if (template.width) then
		self.editbox:SetWidth (template.width)
	end
	if (template.height) then
		self.editbox:SetHeight (template.height)
	end
	
	if (template.backdrop) then
		self.editbox:SetBackdrop (template.backdrop)
	end
	if (template.backdropcolor) then
		local r, g, b, a = DF:ParseColors (template.backdropcolor)
		self.editbox:SetBackdropColor (r, g, b, a)
		self.onleave_backdrop = {r, g, b, a}
	end
	if (template.backdropbordercolor) then
		local r, g, b, a = DF:ParseColors (template.backdropbordercolor)
		self.editbox:SetBackdropBorderColor (r, g, b, a)
		self.editbox.current_bordercolor[1] = r
		self.editbox.current_bordercolor[2] = g
		self.editbox.current_bordercolor[3] = b
		self.editbox.current_bordercolor[4] = a
		self.onleave_backdrop_border_color = {r, g, b, a}
	end
end

------------------------------------------------------------------------------------------------------------
--> object constructor

function DF:CreateTextEntry (parent, func, w, h, member, name, with_label, entry_template, label_template)
	return DF:NewTextEntry (parent, parent, name, member, w, h, func, nil, nil, nil, with_label, entry_template, label_template)
end

function DF:NewTextEntry (parent, container, name, member, w, h, func, param1, param2, space, with_label, entry_template, label_template)
	
	if (not name) then
		name = "DetailsFrameworkTextEntryNumber" .. DF.TextEntryCounter
		DF.TextEntryCounter = DF.TextEntryCounter + 1
		
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
	
	local TextEntryObject = {type = "textentry", dframework = true}
	
	if (member) then
		parent [member] = TextEntryObject
	end

	if (parent.dframework) then
		parent = parent.widget
	end
	if (container.dframework) then
		container = container.widget
	end
	
	--> default members:
		--> hooks
		TextEntryObject.OnEnterHook = nil
		TextEntryObject.OnLeaveHook = nil
		TextEntryObject.OnHideHook = nil
		TextEntryObject.OnShowHook = nil
		TextEntryObject.OnEnterPressedHook = nil
		TextEntryObject.OnEscapePressedHook = nil
		TextEntryObject.OnEditFocusGainedHook = nil
		TextEntryObject.OnEditFocusLostHook = nil
		TextEntryObject.OnCharHook = nil
		TextEntryObject.OnTextChangedHook = nil
		TextEntryObject.OnTabPressedHook = nil

		--> misc
		TextEntryObject.container = container
		TextEntryObject.have_tooltip = nil

	TextEntryObject.editbox = CreateFrame ("EditBox", name, parent)
	TextEntryObject.editbox:SetSize (232, 20)
	TextEntryObject.editbox:SetBackdrop ({bgFile = [["Interface\DialogFrame\UI-DialogBox-Background"]], tileSize = 64, tile = true, edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]], edgeSize = 10, insets = {left = 1, right = 1, top = 0, bottom = 0}})
	
	TextEntryObject.editbox.label = TextEntryObject.editbox:CreateFontString ("$parent_Desc", "OVERLAY", "GameFontHighlightSmall")
	TextEntryObject.editbox.label:SetJustifyH ("left")
	TextEntryObject.editbox.label:SetPoint ("RIGHT", TextEntryObject.editbox, "LEFT", -2, 0)
	
	TextEntryObject.widget = TextEntryObject.editbox
	
	TextEntryObject.editbox:SetTextInsets (3, 0, 0, -3)

	if (not APITextEntryFunctions) then
		APITextEntryFunctions = true
		local idx = getmetatable (TextEntryObject.editbox).__index
		for funcName, funcAddress in pairs (idx) do 
			if (not TextEntryMetaFunctions [funcName]) then
				TextEntryMetaFunctions [funcName] = function (object, ...)
					local x = loadstring ( "return _G['"..object.editbox:GetName().."']:"..funcName.."(...)")
					return x (...)
				end
			end
		end
	end
	
	TextEntryObject.editbox.MyObject = TextEntryObject
	
	if (not w and space) then
		w = space
	elseif (w and space) then
		if (DF.debug) then
			--print ("warning: you are using width and space, try use only space for better results.")
		end
	end
	
	TextEntryObject.editbox:SetWidth (w)
	TextEntryObject.editbox:SetHeight (h)

	TextEntryObject.editbox:SetJustifyH ("center")
	TextEntryObject.editbox:EnableMouse (true)
	TextEntryObject.editbox:SetText ("")

	TextEntryObject.editbox:SetAutoFocus (false)
	TextEntryObject.editbox:SetFontObject ("GameFontHighlightSmall")

	TextEntryObject.editbox.current_bordercolor = {1, 1, 1, 0.7}
	TextEntryObject.editbox:SetBackdropBorderColor (1, 1, 1, 0.7)
	TextEntryObject.enabled_border_color = {TextEntryObject.editbox:GetBackdropBorderColor()}
	TextEntryObject.enabled_backdrop_color = {TextEntryObject.editbox:GetBackdropColor()}
	TextEntryObject.enabled_text_color = {TextEntryObject.editbox:GetTextColor()}
	TextEntryObject.onleave_backdrop = {TextEntryObject.editbox:GetBackdropColor()}
	TextEntryObject.onleave_backdrop_border_color = {TextEntryObject.editbox:GetBackdropBorderColor()}
	
	TextEntryObject.func = func
	TextEntryObject.param1 = param1
	TextEntryObject.param2 = param2
	TextEntryObject.next = nil
	TextEntryObject.space = space
	TextEntryObject.tab_on_enter = false
	
	TextEntryObject.label = _G [name .. "_Desc"]
	
	TextEntryObject.editbox:SetBackdrop ({bgFile = DF.folder .. "background", tileSize = 64, edgeFile = DF.folder .. "border_2", edgeSize = 10, insets = {left = 1, right = 1, top = 1, bottom = 1}})
	
	--> hooks
	
		TextEntryObject.HookList = {
			OnEnter = {},
			OnLeave = {},
			OnHide = {},
			OnShow = {},
			OnEnterPressed = {},
			OnEscapePressed = {},
			OnSpacePressed = {},
			OnEditFocusLost = {},
			OnEditFocusGained = {},
			OnChar = {},
			OnTextChanged = {},
			OnTabPressed = {},
		}
		
		TextEntryObject.editbox:SetScript ("OnEnter", OnEnter)
		TextEntryObject.editbox:SetScript ("OnLeave", OnLeave)
		TextEntryObject.editbox:SetScript ("OnHide", OnHide)
		TextEntryObject.editbox:SetScript ("OnShow", OnShow)
		
		TextEntryObject.editbox:SetScript ("OnEnterPressed", OnEnterPressed)
		TextEntryObject.editbox:SetScript ("OnEscapePressed", OnEscapePressed)
		TextEntryObject.editbox:SetScript ("OnSpacePressed", OnSpacePressed)
		TextEntryObject.editbox:SetScript ("OnEditFocusLost", OnEditFocusLost)
		TextEntryObject.editbox:SetScript ("OnEditFocusGained", OnEditFocusGained)
		TextEntryObject.editbox:SetScript ("OnChar", OnChar)
		TextEntryObject.editbox:SetScript ("OnTextChanged", OnTextChanged)
		TextEntryObject.editbox:SetScript ("OnTabPressed", OnTabPressed)
		
	_setmetatable (TextEntryObject, TextEntryMetaFunctions)
	
	if (with_label) then
		local label = DF:CreateLabel (TextEntryObject.editbox, with_label, nil, nil, nil, "label", nil, "overlay")
		label.text = with_label
		TextEntryObject.editbox:SetPoint ("left", label.widget, "right", 2, 0)
		if (label_template) then
			label:SetTemplate (label_template)
		end
		with_label = label
	end
	
	if (entry_template) then
		TextEntryObject:SetTemplate (entry_template)
	end	
	
	return TextEntryObject, with_label
	
end

function DF:NewSpellEntry (parent, func, w, h, param1, param2, member, name)
	local editbox = DF:NewTextEntry (parent, parent, name, member, w, h, func, param1, param2)
	
--	editbox:SetHook ("OnEditFocusGained", SpellEntryOnEditFocusGained)
--	editbox:SetHook ("OnTextChanged", SpellEntryOnTextChanged)
	
	return editbox	
end

local function_gettext = function (self)
	return self.editbox:GetText()
end
local function_settext = function (self, text)
	return self.editbox:SetText (text)
end
local function_clearfocus = function (self)
	return self.editbox:ClearFocus()
end
local function_setfocus = function (self)
	return self.editbox:SetFocus (true)
end




------------------------------------------------------------------------------------
--auto complete

-- block -------------------
--code author Saiket from  http://www.wowinterface.com/forums/showpost.php?p=245759&postcount=6
--- @return StartPos, EndPos of highlight in this editbox.
local function GetTextHighlight ( self )
	local Text, Cursor = self:GetText(), self:GetCursorPosition();
	self:Insert( "" ); -- Delete selected text
	local TextNew, CursorNew = self:GetText(), self:GetCursorPosition();
	-- Restore previous text
	self:SetText( Text );
	self:SetCursorPosition( Cursor );
	local Start, End = CursorNew, #Text - ( #TextNew - CursorNew );
	self:HighlightText( Start, End );
	return Start, End;
end
local StripColors;
do
	local CursorPosition, CursorDelta;
	--- Callback for gsub to remove unescaped codes.
	local function StripCodeGsub ( Escapes, Code, End )
		if ( #Escapes % 2 == 0 ) then -- Doesn't escape Code
			if ( CursorPosition and CursorPosition >= End - 1 ) then
				CursorDelta = CursorDelta - #Code;
			end
			return Escapes;
		end
	end
	--- Removes a single escape sequence.
	local function StripCode ( Pattern, Text, OldCursor )
		CursorPosition, CursorDelta = OldCursor, 0;
		return Text:gsub( Pattern, StripCodeGsub ), OldCursor and CursorPosition + CursorDelta;
	end
	--- Strips Text of all color escape sequences.
	-- @param Cursor  Optional cursor position to keep track of.
	-- @return Stripped text, and the updated cursor position if Cursor was given.
	function StripColors ( Text, Cursor )
		Text, Cursor = StripCode( "(|*)(|c%x%x%x%x%x%x%x%x)()", Text, Cursor );
		return StripCode( "(|*)(|r)()", Text, Cursor );
	end
end

local COLOR_END = "|r";
--- Wraps this editbox's selected text with the given color.
local function ColorSelection ( self, ColorCode )
	local Start, End = GetTextHighlight( self );
	local Text, Cursor = self:GetText(), self:GetCursorPosition();
	if ( Start == End ) then -- Nothing selected
		--Start, End = Cursor, Cursor; -- Wrap around cursor
		return; -- Wrapping the cursor in a color code and hitting backspace crashes the client!
	end
	-- Find active color code at the end of the selection
	local ActiveColor;
	if ( End < #Text ) then -- There is text to color after the selection
		local ActiveEnd;
		local CodeEnd, _, Escapes, Color = 0;
		while ( true ) do
			_, CodeEnd, Escapes, Color = Text:find( "(|*)(|c%x%x%x%x%x%x%x%x)", CodeEnd + 1 );
			if ( not CodeEnd or CodeEnd > End ) then
				break;
			end
			if ( #Escapes % 2 == 0 ) then -- Doesn't escape Code
				ActiveColor, ActiveEnd = Color, CodeEnd;
			end
		end

		if ( ActiveColor ) then
			-- Check if color gets terminated before selection ends
			CodeEnd = 0;
			while ( true ) do
				_, CodeEnd, Escapes = Text:find( "(|*)|r", CodeEnd + 1 );
				if ( not CodeEnd or CodeEnd > End ) then
					break;
				end
				if ( CodeEnd > ActiveEnd and #Escapes % 2 == 0 ) then -- Terminates ActiveColor
					ActiveColor = nil;
					break;
				end
			end
		end
	end

	local Selection = Text:sub( Start + 1, End );
	-- Remove color codes from the selection
	local Replacement, CursorReplacement = StripColors( Selection, Cursor - Start );

	self:SetText( ( "" ):join(
		Text:sub( 1, Start ),
		ColorCode, Replacement, COLOR_END,
		ActiveColor or "", Text:sub( End + 1 )
	) );

	-- Restore cursor and highlight, adjusting for wrapper text
	Cursor = Start + CursorReplacement;
	if ( CursorReplacement > 0 ) then -- Cursor beyond start of color code
		Cursor = Cursor + #ColorCode;
	end
	if ( CursorReplacement >= #Replacement ) then -- Cursor beyond end of color
		Cursor = Cursor + #COLOR_END;
	end
	
	self:SetCursorPosition( Cursor );
	-- Highlight selection and wrapper
	self:HighlightText( Start, #ColorCode + ( #Replacement - #Selection ) + #COLOR_END + End );
end
-- end of the block ---------------------

local get_last_word = function (self)
	self.lastword = ""
	local cursor_pos = self.editbox:GetCursorPosition()
	local text = self.editbox:GetText()
	for i = cursor_pos, 1, -1 do
		local character = text:sub (i, i)
		if (character:match ("%a")) then
			self.lastword = character .. self.lastword
			--print (self.lastword)
		else
			break
		end
	end
end

--On Text Changed
local AutoComplete_OnTextChanged = function (editboxWidget, byUser, capsule)
	capsule = capsule or editboxWidget.MyObject or editboxWidget
	
	local chars_now = editboxWidget:GetText():len()
	if (not editboxWidget.ignore_textchange) then
		--> backspace
		if (chars_now == capsule.characters_count -1) then
			capsule.lastword = capsule.lastword:sub (1, capsule.lastword:len()-1)
		--> delete lots of text
		elseif (chars_now < capsule.characters_count) then
			--o auto complete selecionou outra palavra bem menor e caiu nesse filtro
			editboxWidget.end_selection = nil
			capsule:GetLastWord()
		end
	else
		editboxWidget.ignore_textchange = nil
	end
	capsule.characters_count = chars_now
end

local AutoComplete_OnSpacePressed = function (editboxWidget, capsule)
	capsule = capsule or editboxWidget.MyObject or editboxWidget

--	if (not gotMatch) then
		--editboxWidget.end_selection = nil
--	end
end

local AutoComplete_OnEscapePressed = function (editboxWidget)
	editboxWidget.end_selection = nil
end

local AutoComplete_OnEnterPressed = function (editboxWidget)

	local capsule = editboxWidget.MyObject or editboxWidget
	if (editboxWidget.end_selection) then
		editboxWidget:SetCursorPosition (editboxWidget.end_selection)
		editboxWidget:HighlightText (0, 0)
		editboxWidget.end_selection = nil
		--editboxWidget:Insert (" ") --estava causando a adi��o de uma palavra a mais quando o pr�ximo catactere for um espa�o
	else
		if (editboxWidget:IsMultiLine()) then
			editboxWidget:Insert ("\n")
			--reseta a palavra se acabou de ganhar focus e apertou enter
			if (editboxWidget.focusGained) then
				capsule.lastword = ""
				editboxWidget.focusGained = nil
			end
		else
			editboxWidget:Insert ("")
			editboxWidget.focuslost = true
			editboxWidget:ClearFocus()
		end
	end
	capsule.lastword = ""

end

local AutoComplete_OnEditFocusGained = function (editboxWidget)
	local capsule = editboxWidget.MyObject or editboxWidget
	capsule:GetLastWord()
	--print ("last word:", editboxWidget.lastword)
	editboxWidget.end_selection = nil
	editboxWidget.focusGained = true
	capsule.characters_count = editboxWidget:GetText():len()	
end

local OptimizeAutoCompleteTable = function (self, wordList)
	local optimizedTable = {}
	
	local lower = string.lower
	local sub = string.sub
	local len = string.len
	
	local subTables = 0
	
	for i = 1, #wordList do
		local thisWord = wordList [i]
		if (len (thisWord) > 0) then
			thisWord = lower (thisWord)
		
			local firstCharacter = sub (thisWord, 1, 1)
			
			local charTable = optimizedTable [firstCharacter]
			if (not charTable) then
				charTable = {}
				optimizedTable [firstCharacter] = charTable
				
				subTables = subTables + 1
			end
			
			charTable [#charTable+1] = thisWord
		end
	end
	
	wordList.Optimized = optimizedTable
end

local AutoComplete_OnChar = function (editboxWidget, char, capsule)
	if (char == "") then
		return
	end
	
	capsule = capsule or editboxWidget.MyObject or editboxWidget
 	editboxWidget.end_selection = nil
	
	if (editboxWidget.ignore_input) then
		return
	end
	
	--reseta a palavra se acabou de ganhar focus e apertou espa�o
	if (editboxWidget.focusGained and char == " ") then
		capsule.lastword = ""
		editboxWidget.focusGained = nil
	else
		editboxWidget.focusGained = nil
	end
	
	if (char:match ("%a") or (char == " " and capsule.lastword ~= "")) then
		capsule.lastword = capsule.lastword .. char
	else
		capsule.lastword = ""
	end
	
	editboxWidget.ignore_input = true
	
	if (capsule.lastword:len() >= 2) then
	
		local wordList = capsule [capsule.poolName]
		if (not wordList) then
			error ("Details! Framework: TextEntry has AutoComplete but no word list table.")
			return
		end
		
		if (capsule.ShouldOptimizeAutoComplete) then
			if (not wordList.Optimized) then
				OptimizeAutoCompleteTable (capsule, wordList)
			end
			
			local firstCharacter = string.lower (string.sub (capsule.lastword, 1, 1))
			wordList = wordList.Optimized [firstCharacter]
			
			if (wordList) then
				for i = 1, #wordList do
					local thisWord = wordList [i]
					if (thisWord and (thisWord:find ("^" .. capsule.lastword) or thisWord:lower():find ("^" .. capsule.lastword))) then
						local rest = thisWord:gsub (capsule.lastword, "")
						rest = rest:lower():gsub (capsule.lastword, "")
						local cursor_pos = editboxWidget:GetCursorPosition()
						editboxWidget:Insert (rest)
						editboxWidget:HighlightText (cursor_pos, cursor_pos + rest:len())
						editboxWidget:SetCursorPosition (cursor_pos)
						editboxWidget.end_selection = cursor_pos + rest:len()
						editboxWidget.ignore_textchange = true
						break
					end
				end
			end
			
			editboxWidget.ignore_input = false
			return
		end
	
		for i = 1, #wordList do
			local thisWord = wordList [i]
			if (thisWord and (thisWord:find ("^" .. capsule.lastword) or thisWord:lower():find ("^" .. capsule.lastword))) then
				local rest = thisWord:gsub (capsule.lastword, "")
				rest = rest:lower():gsub (capsule.lastword, "")
				local cursor_pos = editboxWidget:GetCursorPosition()
				editboxWidget:Insert (rest)
				editboxWidget:HighlightText (cursor_pos, cursor_pos + rest:len())
				editboxWidget:SetCursorPosition (cursor_pos)
				editboxWidget.end_selection = cursor_pos + rest:len()
				editboxWidget.ignore_textchange = true
				break
			end
		end
	end
	
	editboxWidget.ignore_input = false
end

function TextEntryMetaFunctions:SetAsAutoComplete (poolName, poolTable, shouldOptimize)
	
	if (not self.SetHook) then
		--self is borderframe
		self = self.editbox
		self.editbox = self --compatible with fw functions
		
		self.lastword = ""
		self.characters_count = 0
		self.poolName = poolName
		self.GetLastWord = get_last_word --editbox:GetLastWord()
		self.NoClearFocusOnEnterPressed = true --avoid auto clear focus
		self.ShouldOptimizeAutoComplete = shouldOptimize
		
		if (poolTable) then
			self [poolName] = poolTable
		end
		
		self:HookScript ("OnEditFocusGained", AutoComplete_OnEditFocusGained)
		self:HookScript ("OnEnterPressed", AutoComplete_OnEnterPressed)
		self:HookScript ("OnEscapePressed", AutoComplete_OnEscapePressed)
		self:HookScript ("OnTextChanged", AutoComplete_OnTextChanged)
		self:HookScript ("OnChar", AutoComplete_OnChar)
		self:HookScript ("OnSpacePressed", AutoComplete_OnSpacePressed)
	else
		--fw textfield
		self.lastword = ""
		self.characters_count = 0
		self.poolName = poolName
		self.GetLastWord = get_last_word --editbox:GetLastWord()
		self.NoClearFocusOnEnterPressed = true --avoid auto clear focus
		self.ShouldOptimizeAutoComplete = shouldOptimize
		
		self:SetHook ("OnEditFocusGained", AutoComplete_OnEditFocusGained)
		self:SetHook ("OnEnterPressed", AutoComplete_OnEnterPressed)
		self.editbox:HookScript ("OnEscapePressed", AutoComplete_OnEscapePressed)
		self.editbox:SetScript ("OnTextChanged", AutoComplete_OnTextChanged)
		self.editbox:SetScript ("OnChar", AutoComplete_OnChar)
		self.editbox:SetScript ("OnSpacePressed", AutoComplete_OnSpacePressed)
	end

end

function DF:NewSpecialLuaEditorEntry (parent, w, h, member, name, nointent)
	
	if (name:find ("$parent")) then
		local parentName = DF.GetParentName (parent)
		name = name:gsub ("$parent", parentName)
	end
	
	local borderframe = CreateFrame ("Frame", name, parent)
	borderframe:SetSize (w, h)
	
	if (member) then
		parent [member] = borderframe
	end
	
	local scrollframe = CreateFrame ("ScrollFrame", name, borderframe, "UIPanelScrollFrameTemplate")
	scrollframe:SetSize (232, 20)
	scrollframe.editbox = CreateFrame ("editbox", "$parentEditBox", scrollframe)
	scrollframe.editbox:SetMultiLine (true)
	scrollframe.editbox:SetAutoFocus (false)
	scrollframe.editbox:SetSize (232, 20)
	scrollframe.editbox:SetAllPoints()
	
	scrollframe.editbox:SetScript ("OnCursorChanged", _G.ScrollingEdit_OnCursorChanged)
	scrollframe.editbox:SetScript ("OnEscapePressed", _G.EditBox_ClearFocus)
	scrollframe.editbox:SetFontObject ("GameFontHighlightSmall")
	
	scrollframe:SetScrollChild (scrollframe.editbox)
	
	--letters="255"
	--countInvisibleLetters="true"

	borderframe.SetAsAutoComplete = TextEntryMetaFunctions.SetAsAutoComplete
	
	scrollframe:SetScript ("OnSizeChanged", function (self)
		scrollframe.editbox:SetSize (self:GetSize())
	end)
	
	scrollframe:SetPoint ("topleft", borderframe, "topleft", 10, -10)
	scrollframe:SetPoint ("bottomright", borderframe, "bottomright", -30, 10)
	
	scrollframe.editbox:SetMultiLine (true)
	scrollframe.editbox:SetJustifyH ("left")
	scrollframe.editbox:SetJustifyV ("top")
	scrollframe.editbox:SetMaxBytes (1024000)
	scrollframe.editbox:SetMaxLetters (128000)
	
	borderframe.GetText = function_gettext
	borderframe.SetText = function_settext
	borderframe.ClearFocus = function_clearfocus
	borderframe.SetFocus = function_setfocus
	
	borderframe.Enable = TextEntryMetaFunctions.Enable
	borderframe.Disable = TextEntryMetaFunctions.Disable
	
	borderframe.SetTemplate = TextEntryMetaFunctions.SetTemplate
	
	if (not nointent) then
		IndentationLib.enable (scrollframe.editbox, nil, 4)
	end
	
	borderframe:SetBackdrop ({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]], 
		tile = 1, tileSize = 16, edgeSize = 16, insets = {left = 5, right = 5, top = 5, bottom = 5}})
	
	scrollframe.editbox.current_bordercolor = {1, 1, 1, 0.7}
	borderframe:SetBackdropBorderColor (1, 1, 1, 0.7)
	borderframe:SetBackdropColor (0.090195, 0.090195, 0.188234, 1)
	
	borderframe.enabled_border_color = {borderframe:GetBackdropBorderColor()}
	borderframe.enabled_backdrop_color = {borderframe:GetBackdropColor()}
	borderframe.enabled_text_color = {scrollframe.editbox:GetTextColor()}

	borderframe.onleave_backdrop = {scrollframe.editbox:GetBackdropColor()}
	borderframe.onleave_backdrop_border_color = {scrollframe.editbox:GetBackdropBorderColor()}
	
	borderframe.scroll = scrollframe
	borderframe.editbox = scrollframe.editbox
	borderframe.editbox.borderframe = borderframe
	
	return borderframe
end

-- encryption table
local base64chars = {[0]='A',[1]='B',[2]='C',[3]='D',[4]='E',[5]='F',[6]='G',[7]='H',[8]='I',[9]='J',[10]='K',[11]='L',[12]='M',[13]='N',[14]='O',[15]='P',[16]='Q',[17]='R',[18]='S',[19]='T',[20]='U',[21]='V',[22]='W',[23]='X',[24]='Y',[25]='Z',[26]='a',[27]='b',[28]='c',[29]='d',[30]='e',[31]='f',[32]='g',[33]='h',[34]='i',[35]='j',[36]='k',[37]='l',[38]='m',[39]='n',[40]='o',[41]='p',[42]='q',[43]='r',[44]='s',[45]='t',[46]='u',[47]='v',[48]='w',[49]='x',[50]='y',[51]='z',[52]='0',[53]='1',[54]='2',[55]='3',[56]='4',[57]='5',[58]='6',[59]='7',[60]='8',[61]='9',[62]='-',[63]='_'}

-- decryption table
local base64bytes = {['A']=0,['B']=1,['C']=2,['D']=3,['E']=4,['F']=5,['G']=6,['H']=7,['I']=8,['J']=9,['K']=10,['L']=11,['M']=12,['N']=13,['O']=14,['P']=15,['Q']=16,['R']=17,['S']=18,['T']=19,['U']=20,['V']=21,['W']=22,['X']=23,['Y']=24,['Z']=25,['a']=26,['b']=27,['c']=28,['d']=29,['e']=30,['f']=31,['g']=32,['h']=33,['i']=34,['j']=35,['k']=36,['l']=37,['m']=38,['n']=39,['o']=40,['p']=41,['q']=42,['r']=43,['s']=44,['t']=45,['u']=46,['v']=47,['w']=48,['x']=49,['y']=50,['z']=51,['0']=52,['1']=53,['2']=54,['3']=55,['4']=56,['5']=57,['6']=58,['7']=59,['8']=60,['9']=61,['-']=62,['_']=63,['=']=nil}

-- shift left
local function lsh (value,shift)
	return (value*(2^shift)) % 256
end

-- shift right
local function rsh (value,shift)
	return math.floor(value/2^shift) % 256
end

-- return single bit (for OR)
local function bit (x,b)
	return (x % 2^b - x % 2^(b-1) > 0)
end

local function lor (x,y)
	result = 0
	for p=1,8 do result = result + (((bit(x,p) or bit(y,p)) == true) and 2^(p-1) or 0) end
	return result
end

function DF.EncodeString (data)
	local bytes = {}
	local result = ""
	for spos=0,string.len(data)-1,3 do
		for byte=1,3 do bytes[byte] = string.byte(string.sub(data,(spos+byte))) or 0 end
		result = string.format('%s%s%s%s%s',result,base64chars[rsh(bytes[1],2)],base64chars[lor(lsh((bytes[1] % 4),4), rsh(bytes[2],4))] or "=",((#data-spos) > 1) and base64chars[lor(lsh(bytes[2] % 16,2), rsh(bytes[3],6))] or "=",((#data-spos) > 2) and base64chars[(bytes[3] % 64)] or "=")
	end
	return result
end

function DF.DecodeString (data)
	local chars = {}
	local result=""
	for dpos=0,string.len(data)-1,4 do
		for char=1,4 do chars[char] = base64bytes[(string.sub(data,(dpos+char),(dpos+char)) or "=")] end
		result = string.format('%s%s%s%s',result,string.char(lor(lsh(chars[1],2), rsh(chars[2],4))),(chars[3] ~= nil) and string.char(lor(lsh(chars[2],4), rsh(chars[3],2))) or "",(chars[4] ~= nil) and string.char(lor(lsh(chars[3],6) % 192, (chars[4]))) or "")
	end
	return result
end


DF.AutoCompleteAPI = {
	"local",
	"AddTrackedAchievement", -- [1]
	"CanShowAchievementUI", -- [2]
	"ClearAchievementComparisonUnit", -- [3]
	"GetAchievementCategory", -- [4]
	"GetAchievementComparisonInfo", -- [5]
	"GetAchievementCriteriaInfo", -- [6]
	"GetAchievementInfo", -- [7]
	"GetAchievementInfoFromCriteria", -- [8]
	"GetAchievementLink", -- [9]
	"GetAchievementNumCriteria", -- [10]
	"GetAchievementNumRewards", -- [11]
	"GetCategoryInfo", -- [12]
	"GetCategoryList", -- [13]
	"GetCategoryNumAchievements", -- [14]
	"GetComparisonAchievementPoints", -- [15]
	"GetComparisonCategoryNumAchievements", -- [16]
	"GetComparisonStatistic", -- [17]
	"GetLatestCompletedAchievements", -- [18]
	"GetLatestCompletedComparisonAchievements", -- [19]
	"GetLatestUpdatedComparisonStatsGetLatestUpdatedStats", -- [20]
	"GetNextAchievement", -- [21]
	"GetNumComparisonCompletedAchievements", -- [22]
	"GetNumCompletedAchievements", -- [23]
	"GetPreviousAchievement", -- [24]
	"GetStatistic", -- [25]
	"GetStatisticsCategoryList", -- [26]
	"GetTotalAchievementPoints", -- [27]
	"GetTrackedAchievements", -- [28]
	"GetNumTrackedAchievements", -- [29]
	"RemoveTrackedAchievement", -- [30]
	"SetAchievementComparisonUnit", -- [31]
	"ActionButtonDown", -- [32]
	"ActionButtonUp", -- [33]
	"ActionHasRange", -- [34]
	"CameraOrSelectOrMoveStart", -- [35]
	"CameraOrSelectOrMoveStop", -- [36]
	"ChangeActionBarPage", -- [37]
	"GetActionBarPage", -- [38]
	"GetActionBarToggles", -- [39]
	"GetActionCooldown", -- [40]
	"GetActionCount", -- [41]
	"GetActionInfo", -- [42]
	"GetActionText", -- [43]
	"GetActionTexture", -- [44]
	"GetBonusBarOffset", -- [45]
	"GetMouseButtonClicked", -- [46]
	"GetMultiCastBarOffset", -- [47]
	"GetPossessInfo", -- [48]
	"HasAction", -- [49]
	"IsActionInRange", -- [50]
	"IsAttackAction", -- [51]
	"IsAutoRepeatAction", -- [52]
	"IsCurrentAction", -- [53]
	"IsConsumableAction", -- [54]
	"IsEquippedAction", -- [55]
	"IsUsableAction", -- [56]
	"PetHasActionBar", -- [57]
	"PickupAction", -- [58]
	"PickupPetAction", -- [59]
	"PlaceAction", -- [60]
	"SetActionBarToggles", -- [61]
	"StopAttack", -- [62]
	"TurnOrActionStart", -- [63]
	"TurnOrActionStop", -- [64]
	"UseAction", -- [65]
	"AcceptDuel", -- [66]
	"AttackTarget", -- [67]
	"CancelDuel", -- [68]
	"CancelLogout", -- [69]
	"ClearTutorials", -- [70]
	"CancelSummon", -- [71]
	"ConfirmSummon", -- [72]
	"DescendStop", -- [73]
	"Dismount", -- [74]
	"FlagTutorial", -- [75]
	"ForceQuit", -- [76]
	"GetPVPTimer", -- [77]
	"GetSummonConfirmAreaName", -- [78]
	"GetSummonConfirmSummoner", -- [79]
	"GetSummonConfirmTimeLeft", -- [80]
	"RandomRoll", -- [81]
	"SetPVP", -- [82]
	"StartDuel", -- [84]
	"TogglePVP", -- [85]
	"ToggleSheath", -- [86]
	"UseSoulstone", -- [87]
	"CanSolveArtifact", -- [89]
	"UIParent", -- [90]
	"GetArtifactInfoByRace", -- [91]
	"GetArtifactProgress", -- [92]
	"GetNumArtifactsByRace", -- [93]
	"GetSelectedArtifactInfo", -- [94]
	"IsArtifactCompletionHistoryAvailable", -- [95]
	"ItemAddedToArtifact", -- [96]
	"RemoveItemFromArtifact", -- [97]
	"RequestArtifactCompletionHistory", -- [98]
	"SocketItemToArtifact", -- [99]
	"AcceptArenaTeam", -- [101]
	"ArenaTeamInviteByName", -- [102]
	"ArenaTeamSetLeaderByName", -- [103]
	"ArenaTeamLeave", -- [104]
	"ArenaTeamRoster", -- [105]
	"ArenaTeamUninviteByName", -- [106]
	"ArenaTeamDisband", -- [107]
	"DeclineArenaTeam", -- [108]
	"GetArenaTeam", -- [109]
	"GetArenaTeamGdfInf", -- [110]
	"oGetArenaTeamRosterInfo", -- [111]
	"GetBattlefieldTeamInfo", -- [112]
	"GetCurrentArenaSeason", -- [113]
	"GetInspectArenaTeamData", -- [114]
	"GetNumArenaTeamMembers", -- [115]
	"GetPreviousArenaSeason", -- [116]
	"IsActiveBattlefieldArena", -- [117]
	"IsArenaTeamCaptain", -- [118]
	"IsInArenaTeam", -- [119]
	"CalculateAuctionDeposit", -- [121]
	"CanCancelAuction", -- [122]
	"CancelSell", -- [123]
	"CanSendAuctionQuery", -- [124]
	"CancelAuction", -- [125]
	"ClickAuctionSellItemButton", -- [126]
	"CloseAuctionHouse", -- [127]
	"GetAuctionHouseDepositRate", -- [128]
	"GetAuctionInvTypes", -- [129]
	"GetAuctionItemClasses", -- [130]
	"GetAuctionItemInfo", -- [131]
	"GetAuctionItemLink", -- [132]
	"GetAuctionItemSubClasses", -- [133]
	"GetAuctionItemTimeLeft", -- [134]
	"GetAuctionSellItemInfo", -- [135]
	"GetBidderAuctionItems", -- [136]
	"GetNumAuctionItems", -- [137]
	"GetOwnerAuctionItems", -- [138]
	"GetSelectedAuctionItem", -- [139]
	"IsAuctionSortReversed", -- [140]
	"PlaceAuctionBid", -- [141]
	"QueryAuctionItems", -- [142]
	"SetAuctionsTabShowing", -- [143]
	"SetSelectedAuctionItem", -- [144]
	"SortAuctionItems", -- [145]
	"StartAuction", -- [146]
	"BankButtonIDToInvSlotID", -- [148]
	"CloseBankFrame", -- [149]
	"GetBankSlotCost", -- [150]
	"GetNumBankSlots", -- [151]
	"PurchaseSlot", -- [152]
	"AcceptAreaSpiritHeal", -- [154]
	"AcceptBattlefieldPort", -- [155]
	"CancelAreaSpiritHeal", -- [156]
	"CanJoinBattlefieldAsGroup", -- [157]
	"CheckSpiritHealerDist", -- [158]
	"GetAreaSpiritHealerTime", -- [159]
	"GetBattlefieldEstimatedWaitTime", -- [160]
	"GetBattlefieldFlagPosition", -- [161]
	"GetBattlefieldInstanceExpiration", -- [162]
	"GetBattlefieldInstanceRunTime", -- [163]
	"GetBattlefieldMapIconScale", -- [164]
	"GetBattlefieldPortExpiration", -- [165]
	"GetBattlefieldPosition", -- [166]
	"GetBattlefieldScore", -- [167]
	"GetBattlefieldStatData", -- [168]
	"GetBattlefieldStatInfo", -- [169]
	"GetBattlefieldStatus", -- [170]
	"GetBattlefieldTimeWaited", -- [171]
	"GetBattlefieldWinner", -- [172]
	"GetBattlegroundInfo", -- [173]
	"GetNumBattlefieldFlagPositions", -- [174]
	"GetNumBattlefieldPositions", -- [175]
	"GetNumBattlefieldScores", -- [176]
	"GetNumBattlefieldStats", -- [177]
	"GetNumWorldStateUI", -- [178]
	"GetWintergraspWaitTime", -- [179]
	"GetWorldStateUIInfo", -- [180]
	"IsPVPTimerRunning", -- [181]
	"JoinBattlefield", -- [182]
	"LeaveBattlefield", -- [183]
	"ReportPlayerIsPVPAFK", -- [184]
	"RequestBattlefieldPositions", -- [185]
	"RequestBattlefieldScoreData", -- [186]
	"RequestBattlegroundInstanceInfo", -- [187]
	"SetBattlefieldScoreFaction", -- [188]
	"GetBinding", -- [190]
	"GetBindingAction", -- [191]
	"GetBindingKey", -- [192]
	"GetBindingText", -- [193]
	"GetCurrentBindingSet", -- [194]
	"GetNumBindings", -- [195]
	"LoadBindings", -- [196]
	"RunBinding", -- [197]
	"SaveBindings", -- [198]
	"SetBinding", -- [199]
	"SetBindingSpell", -- [200]
	"SetBindingClick", -- [201]
	"SetBindingItem", -- [202]
	"SetBindingMacro", -- [203]
	"SetConsoleKey", -- [204]
	"SetOverrideBinding", -- [205]
	"SetOverrideBindingSpell", -- [206]
	"SetOverrideBindingClick", -- [207]
	"SetOverrideBindingItem", -- [208]
	"SetOverrideBindingMacro", -- [209]
	"ClearOverrideBindings", -- [210]
	"SetMouselookOverrideBinding", -- [211]
	"IsModifierKeyDown", -- [212]
	"IsModifiedClick", -- [213]
	"IsMouseButtonDown", -- [214]
	"CancelUnitBuff", -- [216]
	"CancelShapeshiftForm", -- [217]
	"CancelItemTempEnchantment", -- [218]
	"GetWeaponEnchantInfo", -- [219]
	"UnitAura", -- [220]
	"UnitBuff", -- [221]
	"UnitDebuff", -- [222]
	"AddChatWindowChannel", -- [224]
	"ChannelBan", -- [225]
	"ChannelInvite", -- [226]
	"ChannelKick", -- [227]
	"ChannelModerator", -- [228]
	"ChannelMute", -- [229]
	"ChannelToggleAnnouncements", -- [230]
	"ChannelUnban", -- [231]
	"ChannelUnmoderator", -- [232]
	"ChannelUnmute", -- [233]
	"DisplayChannelOwner", -- [234]
	"DeclineInvite", -- [235]
	"EnumerateServerChannels", -- [236]
	"GetChannelList", -- [237]
	"GetChannelName", -- [238]
	"GetChatWindowChannels", -- [239]
	"JoinChannelByName", -- [240]
	"LeaveChannelByName", -- [241]
	"ListChannelByName", -- [242]
	"ListChannels", -- [243]
	"RemoveChatWindowChannel", -- [244]
	"SendChatMessage", -- [245]
	"SetChannelOwner", -- [246]
	"SetChannelPassword", -- [247]
	"AcceptResurrect", -- [249]
	"AcceptXPLoss", -- [250]
	"CheckBinderDist", -- [251]
	"ConfirmBinder", -- [252]
	"DeclineResurrect", -- [253]
	"DestroyTotem", -- [254]
	"GetBindLocation", -- [255]
	"GetComboPoints", -- [256]
	"GetCorpseRecoveryDelay", -- [257]
	"GetCurrentTitle", -- [258]
	"GetMirrorTimerInfo", -- [259]
	"GetMirrorTimerProgress", -- [260]
	"GetMoney", -- [261]
	"GetNumTitles", -- [262]
	"GetPlayerFacing", -- [263]
	"GetPVPDesired", -- [264]
	"GetReleaseTimeRemaining", -- [265]
	"GetResSicknessDuration", -- [266]
	"GetRestState", -- [267]
	"GetRuneCooldown", -- [268]
	"GetRuneCount", -- [269]
	"GetRuneType", -- [270]
	"GetTimeToWellRested", -- [271]
	"GetTitleName", -- [272]
	"GetUnitPitch", -- [273]
	"GetXPExhaustion", -- [274]
	"HasFullControl", -- [275]
	"HasSoulstone", -- [276]
	"IsFalling", -- [277]
	"IsFlying", -- [278]
	"IsFlyableArea", -- [279]
	"IsIndoors", -- [280]
	"IsMounted", -- [281]
	"IsOutdoors", -- [282]
	"IsOutOfBounds", -- [283]
	"IsResting", -- [284]
	"IsStealthed", -- [285]
	"IsSwimming", -- [286]
	"IsTitleKnown", -- [287]
	"IsXPUserDisabled", -- [288]
	"NotWhileDeadError", -- [289]
	"ResurrectHasSickness", -- [290]
	"ResurrectHasTimer", -- [291]
	"ResurrectGetOfferer", -- [292]
	"RetrieveCorpse", -- [293]
	"SetCurrentTitle", -- [294]
	"TargetTotem", -- [295]
	"GetArmorPenetration", -- [296]
	"GetAttackPowerForStat", -- [297]
	"GetAverageItemLevel", -- [298]
	"GetBlockChance", -- [299]
	"GetCombatRating", -- [300]
	"GetCombatRatingBonus", -- [301]
	"GetCritChance", -- [302]
	"GetCritChanceFromAgility", -- [303]
	"GetDodgeChance", -- [304]
	"GetExpertise", -- [305]
	"GetExpertisePercent", -- [306]
	"GetManaRegen", -- [307]
	"GetMaxCombatRatingBonus", -- [308]
	"GetParryChance", -- [309]
	"GetPetSpellBonusDamage", -- [310]
	"GetPowerRegen", -- [311]
	"GetSpellBonusDamage", -- [312]
	"GetRangedCritChance", -- [313]
	"GetSpellBonusHealing", -- [314]
	"GetSpellCritChance", -- [315]
	"GetShieldBlock", -- [316]
	"GetSpellCritChanceFromIntellect", -- [317]
	"GetSpellPenetration", -- [318]
	"AddChatWindowChannel", -- [319]
	"ChangeChatColor", -- [320]
	"ChatFrame_AddChannel", -- [321]
	"ChatFrame_AddMessageEventFilter", -- [322]
	"ChatFrame_GetMessageEventFilters", -- [323]
	"ChatFrame_OnHyperlinkShow", -- [324]
	"ChatFrame_RemoveMessageEventFilter", -- [325]
	"GetAutoCompleteResults", -- [326]
	"GetChatTypeIndex", -- [327]
	"GetChatWindowChannels", -- [328]
	"GetChatWindowInfo", -- [329]
	"GetChatWindowMessages", -- [330]
	"JoinChannelByName", -- [331]
	"LoggingChat", -- [332]
	"LoggingCombat", -- [333]
	"RemoveChatWindowChannel", -- [334]
	"RemoveChatWindowMessages", -- [335]
	"SetChatWindowAlpha", -- [336]
	"SetChatWindowColor", -- [337]
	"SetChatWindowDocked", -- [338]
	"SetChatWindowLocked", -- [339]
	"SetChatWindowName", -- [340]
	"SetChatWindowShown", -- [341]
	"SetChatWindowSize", -- [342]
	"SetChatWindowUninteractable", -- [343]
	"DoEmote", -- [345]
	"GetDefaultLanguage", -- [346]
	"GetLanguageByIndex", -- [347]
	"GetNumLanguages", -- [348]
	"GetRegisteredAddonMessagePrefixes", -- [349]
	"IsAddonMessagePrefixRegistered", -- [350]
	"RegisterAddonMessagePrefix", -- [352]
	"SendAddonMessage", -- [353]
	"SendChatMessage", -- [354]
	"CallCompanion", -- [356]
	"DismissCompanion", -- [357]
	"GetCompanionInfo", -- [358]
	"GetNumCompanions", -- [359]
	"GetCompanionCooldown", -- [360]
	"PickupCompanion", -- [361]
	"SummonRandomCritter", -- [362]
	"ContainerIDToInventoryID", -- [364]
	"GetBagName", -- [365]
	"GetContainerItemCooldown", -- [366]
	"GetContainerItemDurability", -- [367]
	"GetContainerItemGems", -- [368]
	"GetContainerItemID", -- [369]
	"GetContainerItemInfo", -- [370]
	"GetContainerItemLink", -- [371]
	"GetContainerNumSlots", -- [372]
	"GetContainerItemQuestInfo", -- [373]
	"GetContainerNumFreeSlots", -- [374]
	"OpenAllBags", -- [376]
	"CloseAllBags", -- [377]
	"PickupBagFromSlot", -- [378]
	"PickupContainerItem", -- [379]
	"PutItemInBackpack", -- [380]
	"PutItemInBag", -- [381]
	"PutKeyInKeyRing", -- [382]
	"SplitContainerItem", -- [383]
	"ToggleBackpack", -- [384]
	"ToggleBag", -- [385]
	"GetCoinText", -- [388]
	"GetCoinTextureString", -- [389]
	"GetCurrencyInfo", -- [390]
	"GetCurrencyListSize", -- [391]
	"GetCurrencyListInfo", -- [392]
	"ExpandCurrencyList", -- [393]
	"SetCurrencyUnused", -- [394]
	"GetNumWatchedTokens", -- [395]
	"GetBackpackCurrencyInfo", -- [396]
	"SetCurrencyBackpack", -- [397]
	"AutoEquipCursorItem", -- [399]
	"ClearCursor", -- [400]
	"CursorCanGoInSlot", -- [401]
	"CursorHasItem", -- [402]
	"CursorHasMoney", -- [403]
	"CursorHasSpell", -- [404]
	"DeleteCursorItem", -- [405]
	"DropCursorMoney", -- [406]
	"DropItemOnUnit", -- [407]
	"EquipCursorItem", -- [408]
	"GetCursorInfo", -- [409]
	"GetCursorPosition", -- [410]
	"HideRepairCursor", -- [411]
	"InRepairMode", -- [412]
	"PickupAction", -- [413]
	"PickupBagFromSlot", -- [414]
	"PickupContainerItem", -- [415]
	"PickupInventoryItem", -- [416]
	"PickupItem", -- [417]
	"PickupMacro", -- [418]
	"PickupMerchantItem", -- [419]
	"PickupPetAction", -- [420]
	"PickupSpell", -- [421]
	"PickupStablePet", -- [422]
	"PickupTradeMoney", -- [423]
	"PlaceAction", -- [424]
	"PutItemInBackpack", -- [425]
	"PutItemInBag", -- [426]
	"ResetCursor", -- [427]
	"SetCursor", -- [428]
	"ShowContainerSellCursor", -- [429]
	"ShowInspectCursor", -- [430]
	"ShowInventorySellCursor", -- [431]
	"ShowMerchantSellCursor", -- [432]
	"ShowRepairCursor", -- [433]
	"SplitContainerItem", -- [434]
	"GetWeaponEnchantInfo", -- [435]
	"ReplaceEnchant", -- [436]
	"ReplaceTradeEnchant", -- [437]
	"BindEnchant", -- [438]
	"CollapseFactionHeader", -- [439]
	"CollapseAllFactionHeaders", -- [440]
	"ExpandFactionHeader", -- [441]
	"ExpandAllFactionHeaders", -- [442]
	"FactionToggleAtWar", -- [443]
	"GetFactionInfo", -- [444]
	"GetNumFactions", -- [445]
	"GetSelectedFaction", -- [446]
	"GetWatchedFactionInfo", -- [447]
	"IsFactionInactive", -- [448]
	"SetFactionActive", -- [449]
	"SetFactionInactive", -- [450]
	"SetSelectedFaction", -- [451]
	"SetWatchedFactionIndex", -- [452]
	"UnitFactionGroup", -- [453]
	"CreateFrame", -- [454]
	"CreateFont", -- [455]
	"GetFramesRegisteredForEvent", -- [456]
	"GetNumFrames", -- [457]
	"EnumerateFrames", -- [458]
	"GetMouseFocus", -- [459]
	"ToggleDropDownMenu", -- [460]
	"UIFrameFadeIn", -- [461]
	"UIFrameFadeOut", -- [462]
	"UIFrameFlash", -- [463]
	"EasyMenu", -- [464]
	"AddFriend", -- [466]
	"AddOrRemoveFriend", -- [467]
	"GetFriendInfo", -- [468]
	"SetFriendNotes", -- [469]
	"GetNumFriends", -- [470]
	"GetSelectedFriend", -- [471]
	"RemoveFriend", -- [472]
	"SetSelectedFriend", -- [473]
	"ShowFriends", -- [474]
	"ToggleFriendsFrame", -- [475]
	"GetNumGlyphSockets", -- [477]
	"GetGlyphSocketInfo", -- [478]
	"GetGlyphLink", -- [479]
	"GlyphMatchesSocket", -- [480]
	"PlaceGlyphInSocket", -- [481]
	"RemoveGlyphFromSocket", -- [482]
	"SpellCanTargetGlyph", -- [483]
	"CanComplainChat", -- [485]
	"CanComplainInboxItem", -- [486]
	"ComplainChat", -- [487]
	"ComplainInboxItem", -- [488]
	"CloseGossip", -- [501]
	"ForceGossip", -- [502]
	"GetGossipActiveQuests", -- [503]
	"GetGossipAvailableQuests", -- [504]
	"GetGossipOptions", -- [505]
	"GetGossipText", -- [506]
	"GetNumGossipActiveQuests", -- [507]
	"GetNumGossipAvailableQuests", -- [508]
	"GetNumGossipOptions", -- [509]
	"SelectGossipActiveQuest", -- [510]
	"SelectGossipAvailableQuest", -- [511]
	"SelectGossipOption", -- [512]
	"AcceptGroup", -- [514]
	"ConfirmReadyCheck", -- [515]
	"ConvertToRaid", -- [516]
	"DeclineGroup", -- [517]
	"DoReadyCheck", -- [518]
	"GetLootMethod", -- [519]
	"GetLootThreshold", -- [520]
	"GetMasterLootCandidate", -- [521]
	"GetNumPartyMembers", -- [522]
	"GetRealNumPartyMembers", -- [523]
	"GetPartyLeaderIndex", -- [524]
	"GetPartyMember", -- [525]
	"InviteUnit", -- [526]
	"IsPartyLeader", -- [527]
	"LeaveParty", -- [528]
	"PromoteToLeader", -- [529]
	"SetLootMethod", -- [530]
	"SetLootThreshold", -- [531]
	"UninviteUnit", -- [532]
	"UnitInParty", -- [533]
	"UnitIsPartyLeader", -- [534]
	"AcceptGuild", -- [536]
	"BuyGuildCharter", -- [537]
	"CanEditGuildEvent", -- [538]
	"CanEditGuildInfo", -- [539]
	"CanEditMOTD", -- [540]
	"CanEditOfficerNote", -- [541]
	"CanEditPublicNote", -- [542]
	"CanGuildDemote", -- [543]
	"CanGuildInvite", -- [544]
	"CanGuildPromote", -- [545]
	"CanGuildRemove", -- [546]
	"CanViewOfficerNote", -- [547]
	"CloseGuildRegistrar", -- [548]
	"CloseGuildRoster", -- [549]
	"CloseTabardCreation", -- [550]
	"DeclineGuild", -- [551]
	"GetGuildCharterCost", -- [552]
	"GetGuildEventInfo", -- [553]
	"GetGuildInfo", -- [554]
	"GetGuildInfoText", -- [555]
	"GetGuildRosterInfo", -- [556]
	"GetGuildRosterLastOnline", -- [557]
	"GetGuildRosterMOTD", -- [558]
	"GetGuildRosterSelection", -- [559]
	"GetGuildRosterShowOffline", -- [560]
	"GetNumGuildEvents", -- [561]
	"GetNumGuildMembers", -- [562]
	"GetTabardCreationCost", -- [563]
	"GetTabardInfo", -- [564]
	"GuildControlAddRank", -- [565]
	"GuildControlDelRank", -- [566]
	"GuildControlGetNumRanks", -- [567]
	"GuildControlGetRankFlags", -- [568]
	"GuildControlGetRankName", -- [569]
	"GuildControlSaveRank", -- [570]
	"GuildControlSetRank", -- [571]
	"GuildControlSetRankFlag", -- [572]
	"GuildDemote", -- [573]
	"GuildDisband", -- [574]
	"GuildInfo", -- [575]
	"GuildInvite", -- [576]
	"GuildLeave", -- [577]
	"GuildPromote", -- [578]
	"GuildRoster", -- [579]
	"GuildRosterSetOfficerNote", -- [580]
	"GuildRosterSetPublicNote", -- [581]
	"GuildSetMOTD", -- [582]
	"GuildSetLeader", -- [583]
	"GuildUninvite", -- [584]
	"IsGuildLeader", -- [585]
	"IsInGuild", -- [586]
	"QueryGuildEventLog", -- [587]
	"SetGuildInfoText", -- [588]
	"SetGuildRosterSelection", -- [589]
	"SetGuildRosterShowOffline", -- [590]
	"SortGuildRoster", -- [591]
	"UnitGetGuildXP", -- [592]
	"AutoStoreGuildBankItem", -- [593]
	"BuyGuildBankTab", -- [594]
	"CanGuildBankRepair", -- [595]
	"CanWithdrawGuildBankMoney", -- [596]
	"CloseGuildBankFrame", -- [597]
	"DepositGuildBankMoney", -- [598]
	"GetCurrentGuildBankTab", -- [599]
	"GetGuildBankItemInfo", -- [600]
	"GetGuildBankItemLink", -- [601]
	"GetGuildBankMoney", -- [602]
	"GetGuildBankMoneyTransaction", -- [603]
	"GetGuildBankTabCost", -- [604]
	"GetGuildBankTabInfo", -- [605]
	"GetGuildBankTabPermissions", -- [606]
	"GetGuildBankText", -- [607]
	"GetGuildBankTransaction", -- [608]
	"GetGuildTabardFileNames", -- [611]
	"GetNumGuildBankMoneyTransactions", -- [612]
	"GetNumGuildBankTabs", -- [613]
	"GetNumGuildBankTransactions", -- [614]
	"PickupGuildBankItem", -- [615]
	"PickupGuildBankMoney", -- [616]
	"QueryGuildBankLog", -- [617]
	"QueryGuildBankTab", -- [618]
	"SetCurrentGuildBankTab", -- [619]
	"SetGuildBankTabInfo", -- [620]
	"SetGuildBankTabPermissions", -- [621]
	"SplitGuildBankItem", -- [624]
	"WithdrawGuildBankMoney", -- [625]
	"GetHolidayBGHonorCurrencyBonuses", -- [627]
	"GetInspectHonorData", -- [628]
	"GetPVPLifetimeStats", -- [629]
	"GetPVPRankInfo", -- [630]
	"GetPVPRankProgress", -- [631]
	"GetPVPSessionStats", -- [632]
	"GetPVPYesterdayStats", -- [633]
	"GetRandomBGHonorCurrencyBonuses", -- [634]
	"HasInspectHonorData", -- [635]
	"RequestInspectHonorData", -- [636]
	"UnitPVPName", -- [637]
	"UnitPVPRank", -- [638]
	"AddIgnore", -- [640]
	"AddOrDelIgnore", -- [641]
	"DelIgnore", -- [642]
	"GetIgnoreName", -- [643]
	"GetNumIgnores", -- [644]
	"GetSelectedIgnore", -- [645]
	"SetSelectedIgnore", -- [646]
	"CanInspect", -- [648]
	"CheckInteractDistance", -- [649]
	"ClearInspectPlayer", -- [650]
	"GetInspectArenaTeamData", -- [651]
	"HasInspectHonorData", -- [652]
	"RequestInspectHonorData", -- [653]
	"GetInspectHonorData", -- [654]
	"NotifyInspect", -- [655]
	"InspectUnit", -- [656]
	"CanShowResetInstances", -- [658]
	"GetBattlefieldInstanceExpiration", -- [659]
	"GetBattlefieldInstanceInfo", -- [660]
	"GetBattlefieldInstanceRunTime", -- [661]
	"GetInstanceBootTimeRemaining", -- [662]
	"GetInstanceInfo", -- [663]
	"GetNumSavedInstances", -- [664]
	"GetSavedInstanceInfo", -- [665]
	"IsInInstance", -- [666]
	"ResetInstances", -- [667]
	"GetDungeonDifficulty", -- [668]
	"SetDungeonDifficulty", -- [669]
	"GetInstanceDifficulty", -- [670]
	"GetInstanceLockTimeRemaining", -- [671]
	"GetInstanceLockTimeRemainingEncounter", -- [672]
	"AutoEquipCursorItem", -- [674]
	"BankButtonIDToInvSlotID", -- [675]
	"CancelPendingEquip", -- [676]
	"ConfirmBindOnUse", -- [677]
	"ContainerIDToInventoryID", -- [678]
	"CursorCanGoInSlot", -- [679]
	"EquipCursorItem", -- [680]
	"EquipPendingItem", -- [681]
	"GetInventoryAlertStatus", -- [682]
	"GetInventoryItemBroken", -- [683]
	"GetInventoryItemCooldown", -- [684]
	"GetInventoryItemCount", -- [685]
	"GetInventoryItemDurability", -- [686]
	"GetInventoryItemGems", -- [687]
	"GetInventoryItemID", -- [688]
	"GetInventoryItemLink", -- [689]
	"GetInventoryItemQuality", -- [690]
	"GetInventoryItemTexture", -- [691]
	"GetInventorySlotInfo", -- [692]
	"GetWeaponEnchantInfo", -- [693]
	"HasWandEquipped", -- [694]
	"IsInventoryItemLocked", -- [695]
	"KeyRingButtonIDToInvSlotID", -- [696]
	"PickupBagFromSlot", -- [697]
	"PickupInventoryItem", -- [698]
	"UpdateInventoryAlertStatus", -- [699]
	"UseInventoryItem", -- [700]
	"EquipItemByName", -- [702]
	"GetAuctionItemLink", -- [703]
	"GetContainerItemLink", -- [704]
	"GetItemCooldown", -- [705]
	"GetItemCount", -- [706]
	"GetItemFamily", -- [707]
	"GetItemIcon", -- [708]
	"GetItemInfo", -- [709]
	"GetItemQualityColor", -- [710]
	"GetItemSpell", -- [711]
	"GetItemStats", -- [712]
	"GetMerchantItemLink", -- [713]
	"GetQuestItemLink", -- [714]
	"GetQuestLogItemLink", -- [715]
	"GetTradePlayerItemLink", -- [716]
	"GetTradeSkillItemLink", -- [717]
	"GetTradeSkillReagentItemLink", -- [718]
	"GetTradeTargetItemLink", -- [719]
	"IsUsableItem", -- [720]
	"IsConsumableItem", -- [721]
	"IsCurrentItem", -- [722]
	"IsEquippedItem", -- [723]
	"IsEquippableItem", -- [724]
	"IsEquippedItemType", -- [725]
	"IsItemInRange", -- [726]
	"ItemHasRange", -- [727]
	"OffhandHasWeapon", -- [728]
	"SplitContainerItem", -- [729]
	"SetItemRef", -- [730]
	"AcceptSockets", -- [731]
	"ClickSocketButton", -- [732]
	"CloseSocketInfo", -- [733]
	"GetSocketItemInfo", -- [734]
	"GetSocketItemRefundable", -- [735]
	"GetSocketItemBoundTradeable", -- [736]
	"GetNumSockets", -- [737]
	"GetSocketTypes", -- [738]
	"GetExistingSocketInfo", -- [739]
	"GetExistingSocketLink", -- [740]
	"GetNewSocketInfo", -- [741]
	"GetNewSocketLink", -- [742]
	"SocketInventoryItem", -- [743]
	"SocketContainerItem", -- [744]
	"CloseItemText", -- [745]
	"ItemTextGetCreator", -- [746]
	"ItemTextGetItem", -- [747]
	"ItemTextGetMaterial", -- [748]
	"ItemTextGetPage", -- [749]
	"ItemTextGetText", -- [750]
	"ItemTextHasNextPage", -- [751]
	"ItemTextNextPage", -- [752]
	"ItemTextPrevPage", -- [753]
	"GetMinimapZoneText", -- [755]
	"GetRealZoneText", -- [756]
	"GetSubZoneText", -- [757]
	"GetZonePVPInfo", -- [758]
	"GetZoneText", -- [759]
	"CompleteLFGRoleCheck", -- [760]
	"GetLFGDeserterExpiration", -- [761]
	"GetLFGRandomCooldownExpiration", -- [762]
	"GetLFGBootProposal", -- [763]
	"GetLFGMode", -- [764]
	"GetLFGQueueStats", -- [765]
	"GetLFGRoles", -- [766]
	"GetLFGRoleUpdate", -- [767]
	"GetLFGRoleUpdateSlot", -- [768]
	"SetLFGBootVote", -- [769]
	"SetLFGComment", -- [770]
	"SetLFGRoles", -- [771]
	"UninviteUnit", -- [772]
	"UnitGroupRolesAssigned", -- [773]
	"UnitHasLFGDeserter", -- [774]
	"UnitHasLFGRandomCooldown", -- [775]
	"CloseLoot", -- [777]
	"ConfirmBindOnUse", -- [778]
	"ConfirmLootRoll", -- [779]
	"ConfirmLootSlot", -- [780]
	"GetLootMethod", -- [781]
	"GetLootRollItemInfo", -- [782]
	"GetLootRollItemLink", -- [783]
	"GetLootRollTimeLeft", -- [784]
	"GetLootSlotInfo", -- [785]
	"GetLootSlotLink", -- [786]
	"GetLootThreshold", -- [787]
	"GetMasterLootCandidate", -- [788]
	"GetNumLootItems", -- [789]
	"GetOptOutOfLoot", -- [790]
	"GiveMasterLoot", -- [791]
	"IsFishingLoot", -- [792]
	"LootSlot", -- [793]
	"LootSlotIsCoin", -- [794]
	"LootSlotIsCurrency", -- [795]
	"LootSlotIsItem", -- [796]
	"RollOnLoot", -- [797]
	"SetLootMethod", -- [798]
	"SetLootPortrait", -- [799]
	"SetLootThreshold", -- [800]
	"SetOptOutOfLoot", -- [801]
	"CursorHasMacro", -- [804]
	"DeleteMacro", -- [805]
	"GetMacroBody", -- [807]
	"GetMacroIconInfo", -- [808]
	"GetMacroItemIconInfo", -- [809]
	"GetMacroIndexByName", -- [810]
	"GetMacroInfo", -- [811]
	"GetNumMacroIcons", -- [812]
	"GetNumMacroItemIcons", -- [813]
	"GetNumMacros", -- [814]
	"PickupMacro", -- [815]
	"RunMacro", -- [816]
	"RunMacroText", -- [817]
	"SecureCmdOptionParse", -- [818]
	"StopMacro", -- [819]
	"AutoLootMailItem", -- [821]
	"CheckInbox", -- [822]
	"ClearSendMail", -- [823]
	"ClickSendMailItemButton", -- [824]
	"CloseMail", -- [825]
	"DeleteInboxItem", -- [826]
	"GetCoinIcon", -- [827]
	"GetInboxHeaderInfo", -- [828]
	"GetInboxItem", -- [829]
	"GetInboxItemLink", -- [830]
	"GetInboxNumItems", -- [831]
	"GetInboxText", -- [832]
	"GetInboxInvoiceInfo", -- [833]
	"GetNumPackages", -- [834]
	"GetNumStationeries", -- [835]
	"GetPackageInfo", -- [836]
	"GetSelectedStationeryTexture", -- [837]
	"GetSendMailCOD", -- [838]
	"GetSendMailItem", -- [839]
	"GetSendMailItemLink", -- [840]
	"GetSendMailMoney", -- [841]
	"GetSendMailPrice", -- [842]
	"GetStationeryInfo", -- [843]
	"HasNewMail", -- [844]
	"InboxItemCanDelete", -- [845]
	"ReturnInboxItem", -- [846]
	"SelectPackage", -- [847]
	"SelectStationery", -- [848]
	"SendMail", -- [849]
	"SetSendMailCOD", -- [850]
	"SetSendMailMoney", -- [851]
	"TakeInboxItem", -- [852]
	"TakeInboxMoney", -- [853]
	"TakeInboxTextItem", -- [854]
	"ClickLandmark", -- [856]
	"GetCorpseMapPosition", -- [857]
	"GetCurrentMapContinent", -- [858]
	"GetCurrentMapDungeonLevel", -- [859]
	"GetNumDungeonMapLevels", -- [860]
	"GetCurrentMapAreaID", -- [861]
	"GetCurrentMapZone", -- [862]
	"GetMapContinents", -- [863]
	"GetMapDebugObjectInfo", -- [864]
	"GetMapInfo", -- [865]
	"GetMapLandmarkInfo", -- [866]
	"GetMapOverlayInfo", -- [867]
	"GetMapZones", -- [868]
	"GetNumMapDebugObjects", -- [869]
	"GetNumMapLandmarks", -- [870]
	"GetNumMapOverlays", -- [871]
	"GetPlayerMapPosition", -- [872]
	"ProcessMapClick", -- [873]
	"RequestBattlefieldPositions", -- [874]
	"SetDungeonMapLevel", -- [875]
	"SetMapByID", -- [876]
	"SetMapToCurrentZone", -- [877]
	"SetMapZoom", -- [878]
	"SetupFullscreenScale", -- [879]
	"UpdateMapHighlight", -- [880]
	"CreateWorldMapArrowFrame", -- [881]
	"UpdateWorldMapArrowFrames", -- [882]
	"ShowWorldMapArrowFrame", -- [883]
	"PositionWorldMapArrowFrame", -- [884]
	"ZoomOut", -- [885]
	"BuyMerchantItem", -- [887]
	"BuybackItem", -- [888]
	"CanMerchantRepair", -- [889]
	"CloseMerchant", -- [890]
	"GetBuybackItemInfo", -- [891]
	"GetBuybackItemLink", -- [892]
	"GetMerchantItemCostInfo", -- [893]
	"GetMerchantItemCostItem", -- [894]
	"GetMerchantItemInfo", -- [895]
	"GetMerchantItemLink", -- [896]
	"GetMerchantItemMaxStack", -- [897]
	"GetMerchantNumItems", -- [898]
	"GetRepairAllCost", -- [899]
	"HideRepairCursor", -- [900]
	"InRepairMode", -- [901]
	"PickupMerchantItem", -- [902]
	"RepairAllItems", -- [903]
	"ShowMerchantSellCursor", -- [904]
	"ShowRepairCursor", -- [905]
	"GetNumBuybackItems", -- [906]
	"CastPetAction", -- [908]
	"ClosePetStables", -- [909]
	"DropItemOnUnit", -- [910]
	"GetPetActionCooldown", -- [911]
	"GetPetActionInfo", -- [912]
	"GetPetActionSlotUsable", -- [913]
	"GetPetActionsUsable", -- [914]
	"GetPetExperience", -- [915]
	"GetPetFoodTypes", -- [916]
	"GetPetHappiness", -- [917]
	"GetPetIcon", -- [918]
	"GetPetTimeRemaining", -- [919]
	"GetStablePetFoodTypes", -- [920]
	"GetStablePetInfo", -- [921]
	"HasPetSpells", -- [922]
	"HasPetUI", -- [923]
	"PetAbandon", -- [924]
	"PetAggressiveMode", -- [925]
	"PetAttack", -- [926]
	"IsPetAttackActive", -- [927]
	"PetStopAttack", -- [928]
	"PetCanBeAbandoned", -- [929]
	"PetCanBeDismissed", -- [930]
	"PetCanBeRenamed", -- [931]
	"PetDefensiveMode", -- [932]
	"PetDismiss", -- [933]
	"PetFollow", -- [934]
	"PetHasActionBar", -- [935]
	"PetPassiveMode", -- [936]
	"PetRename", -- [937]
	"PetWait", -- [938]
	"PickupPetAction", -- [939]
	"PickupStablePet", -- [940]
	"SetPetStablePaperdoll", -- [941]
	"TogglePetAutocast", -- [942]
	"ToggleSpellAutocast", -- [943]
	"GetSpellAutocast", -- [944]
	"AddQuestWatch", -- [946]
	"GetActiveLevel", -- [947]
	"GetActiveTitle", -- [948]
	"GetAvailableLevel", -- [949]
	"GetAvailableTitle", -- [950]
	"GetAvailableQuestInfo", -- [951]
	"GetGreetingText", -- [952]
	"GetNumQuestLeaderBoards", -- [953]
	"GetNumQuestWatches", -- [954]
	"GetObjectiveText", -- [955]
	"GetProgressText", -- [956]
	"GetQuestGreenRange", -- [957]
	"GetQuestIndexForWatch", -- [958]
	"GetQuestLink", -- [959]
	"GetQuestLogGroupNum", -- [960]
	"GetQuestLogLeaderBoard", -- [961]
	"GetQuestLogTitle", -- [962]
	"GetQuestReward", -- [963]
	"GetRewardArenaPoints", -- [964]
	"GetRewardHonor", -- [965]
	"GetRewardMoney", -- [966]
	"GetRewardSpell", -- [967]
	"GetRewardTalents", -- [968]
	"GetRewardText", -- [969]
	"GetRewardTitle", -- [970]
	"GetRewardXP", -- [971]
	"IsQuestWatched", -- [972]
	"IsUnitOnQuest", -- [973]
	"QuestFlagsPVP", -- [974]
	"QuestGetAutoAccept", -- [975]
	"RemoveQuestWatch", -- [976]
	"ShiftQuestWatches", -- [977]
	"SortQuestWatches", -- [978]
	"QueryQuestsCompleted", -- [979]
	"GetQuestsCompleted", -- [980]
	"QuestIsDaily", -- [981]
	"QuestIsWeekly", -- [982]
	"ClearRaidMarker", -- [984]
	"ConvertToRaid", -- [985]
	"ConvertToParty", -- [986]
	"DemoteAssistant", -- [987]
	"GetAllowLowLevelRaid", -- [988]
	"GetNumRaidMembers", -- [989]
	"GetRealNumRaidMembers", -- [990]
	"GetPartyAssignment", -- [991]
	"GetPartyAssignment", -- [992]
	"GetRaidRosterInfo", -- [993]
	"GetRaidTargetIndex", -- [994]
	"GetReadyCheckStatus", -- [995]
	"InitiateRolePoll", -- [996]
	"IsRaidLeader", -- [997]
	"IsRaidOfficer", -- [998]
	"PlaceRaidMarker", -- [999]
	"PromoteToAssistant", -- [1000]
	"RequestRaidInfo", -- [1001]
	"SetPartyAssignment", -- [1002]
	"SetAllowLowLevelRaid", -- [1003]
	"SetRaidRosterSelection", -- [1004]
	"SetRaidSubgroup", -- [1005]
	"SwapRaidSubgroup", -- [1006]
	"SetRaidTarget", -- [1007]
	"UnitInRaid", -- [1008]
	"LFGGetDungeonInfoByID", -- [1009]
	"GetInstanceLockTimeRemainingEncounter", -- [1010]
	"RefreshLFGList", -- [1011]
	"SearchLFGGetEncounterResults", -- [1012]
	"SearchLFGGetJoinedID", -- [1013]
	"SearchLFGGetNumResults", -- [1014]
	"SearchLFGGetPartyResults", -- [1015]
	"SearchLFGGetResults", -- [1016]
	"SearchLFGJoin", -- [1017]
	"SearchLFGLeave", -- [1018]
	"SearchLFGSort", -- [1019]
	"SetLFGComment", -- [1020]
	"ClearAllLFGDungeons", -- [1021]
	"JoinLFG", -- [1022]
	"LeaveLFG", -- [1023]
	"RequestLFDPartyLockInfo", -- [1024]
	"RequestLFDPlayerLockInfo", -- [1025]
	"SetLFGDungeon", -- [1026]
	"SetLFGDungeonEnabled", -- [1027]
	"SetLFGHeaderCollapsed", -- [1028]
	"GetAddOnCPUUsage", -- [1029]
	"GetAddOnMemoryUsage", -- [1030]
	"GetEventCPUUsage", -- [1031]
	"GetFrameCPUUsage", -- [1032]
	"GetFunctionCPUUsage", -- [1033]
	"GetScriptCPUUsage", -- [1034]
	"ResetCPUUsage", -- [1035]
	"UpdateAddOnCPUUsage", -- [1036]
	"UpdateAddOnMemoryUsage", -- [1037]
	"issecure", -- [1038]
	"forceinsecure", -- [1039]
	"issecurevariable", -- [1040]
	"securecall", -- [1041]
	"hooksecurefunc", -- [1042]
	"InCombatLockdown", -- [1043]
	"CombatTextSetActiveUnit", -- [1046]
	"DownloadSettings", -- [1047]
	"GetCVar", -- [1048]
	"GetCVarDefault", -- [1049]
	"GetCVarBool", -- [1050]
	"GetCVarInfo", -- [1051]
	"GetCurrentMultisampleFormat", -- [1052]
	"GetCurrentResolution", -- [1053]
	"GetGamma", -- [1054]
	"GetMultisampleFormats", -- [1055]
	"GetRefreshRates", -- [1056]
	"GetScreenResolutions", -- [1057]
	"GetVideoCaps", -- [1058]
	"IsThreatWarningEnabled", -- [1059]
	"RegisterCVar", -- [1060]
	"ResetPerformanceValues", -- [1061]
	"ResetTutorials", -- [1062]
	"SetCVar", -- [1063]
	"SetEuropeanNumbers", -- [1064]
	"SetGamma", -- [1065]
	"SetLayoutMode", -- [1066]
	"SetMultisampleFormat", -- [1067]
	"SetScreenResolution", -- [1068]
	"ShowCloak", -- [1069]
	"ShowHelm", -- [1070]
	"ShowNumericThreat", -- [1071]
	"ShowingCloak", -- [1072]
	"ShowingHelm", -- [1073]
	"UploadSettings", -- [1074]
	"AbandonSkill", -- [1076]
	"CastShapeshiftForm", -- [1078]
	"CastSpell", -- [1079]
	"CastSpellByName", -- [1080]
	"GetMultiCastTotemSpells", -- [1081]
	"GetNumShapeshiftForms", -- [1082]
	"GetNumSpellTabs", -- [1083]
	"GetShapeshiftForm", -- [1084]
	"GetShapeshiftFormCooldown", -- [1085]
	"GetShapeshiftFormInfo", -- [1086]
	"GetSpellAutocast", -- [1087]
	"GetSpellBookItemInfo", -- [1088]
	"GetSpellBookItemName", -- [1089]
	"GetSpellCooldown", -- [1090]
	"GetSpellDescription", -- [1091]
	"GetSpellInfo", -- [1092]
	"GetSpellLink", -- [1093]
	"GetSpellTabInfo", -- [1094]
	"GetSpellTexture", -- [1095]
	"GetTotemInfo", -- [1096]
	"IsAttackSpell", -- [1097]
	"IsAutoRepeatSpell", -- [1098]
	"IsPassiveSpell", -- [1099]
	"IsSpellInRange", -- [1100]
	"IsUsableSpell", -- [1101]
	"PickupSpell", -- [1102]
	"QueryCastSequence", -- [1103]
	"SetMultiCastSpell", -- [1104]
	"SpellCanTargetUnit", -- [1105]
	"SpellHasRange", -- [1106]
	"SpellIsTargeting", -- [1107]
	"SpellStopCasting", -- [1108]
	"SpellStopTargeting", -- [1109]
	"SpellTargetUnit", -- [1110]
	"ToggleSpellAutocast", -- [1111]
	"UnitCastingInfo", -- [1112]
	"UnitChannelInfo", -- [1113]
	"ConsoleExec", -- [1115]
	"DetectWowMouse", -- [1116]
	"GetBuildInfo", -- [1117]
	"geterrorhandler", -- [1118]
	"GetCurrentKeyBoardFocus", -- [1119]
	"GetExistingLocales", -- [1120]
	"GetFramerate", -- [1121]
	"GetGameTime", -- [1122]
	"GetLocale", -- [1123]
	"GetCursorPosition", -- [1124]
	"GetNetStats", -- [1125]
	"GetRealmName", -- [1126]
	"GetScreenHeight", -- [1127]
	"GetScreenWidth", -- [1128]
	"GetText", -- [1129]
	"GetTime", -- [1130]
	"IsAltKeyDown", -- [1131]
	"InCinematic", -- [1132]
	"IsControlKeyDown", -- [1133]
	"IsDebugBuild", -- [1134]
	"IsDesaturateSupported", -- [1135]
	"IsLeftAltKeyDown", -- [1136]
	"IsLeftControlKeyDown", -- [1137]
	"IsLeftShiftKeyDown", -- [1138]
	"IsLinuxClient", -- [1139]
	"IsLoggedIn", -- [1140]
	"IsMacClient", -- [1141]
	"IsRightAltKeyDown", -- [1142]
	"IsRightControlKeyDown", -- [1143]
	"IsRightShiftKeyDown", -- [1144]
	"IsShiftKeyDown", -- [1145]
	"IsStereoVideoAvailable", -- [1146]
	"IsWindowsClient", -- [1147]
	"OpeningCinematic", -- [1148]
	"PlayMusic", -- [1149]
	"PlaySound", -- [1150]
	"PlaySoundFile", -- [1151]
	"ReloadUI", -- [1152]
	"RepopMe", -- [1153]
	"RequestTimePlayed", -- [1154]
	"RestartGx", -- [1155]
	"RunScript", -- [1156]
	"Screenshot", -- [1157]
	"SetAutoDeclineGuildInvites", -- [1158]
	"seterrorhandler", -- [1159]
	"StopCinematic", -- [1160]
	"StopMusic", -- [1161]
	"UIParentLoadAddOn", -- [1162]
	"TakeScreenshot", -- [1163]
	"BuyTrainerService", -- [1168]
	"CheckTalentMasterDist", -- [1169]
	"ConfirmTalentWipe", -- [1170]
	"GetActiveTalentGroup", -- [1171]
	"GetNumTalentTabs", -- [1172]
	"GetNumTalents", -- [1173]
	"GetTalentInfo", -- [1174]
	"GetTalentLink", -- [1175]
	"GetTalentPrereqs", -- [1176]
	"GetTalentTabInfo", -- [1177]
	"LearnTalent", -- [1178]
	"SetActiveTalentGroup", -- [1179]
	"GetNumTalentGroups", -- [1180]
	"GetActiveTalentGroup", -- [1181]
	"AddPreviewTalentPoints", -- [1182]
	"GetGroupPreviewTalentPointsSpent", -- [1183]
	"GetPreviewTalentPointsSpent", -- [1184]
	"GetUnspentTalentPoints", -- [1185]
	"LearnPreviewTalents", -- [1186]
	"ResetGroupPreviewTalentPoints", -- [1187]
	"ResetPreviewTalentPoints", -- [1188]
	"AssistUnit", -- [1190]
	"AttackTarget", -- [1191]
	"ClearTarget", -- [1192]
	"ClickTargetTradeButton", -- [1193]
	"TargetLastEnemy", -- [1194]
	"TargetLastTarget", -- [1195]
	"TargetNearestEnemy", -- [1196]
	"TargetNearestEnemyPlayer", -- [1197]
	"TargetNearestFriend", -- [1198]
	"TargetNearestFriendPlayer", -- [1199]
	"TargetNearestPartyMember", -- [1200]
	"TargetNearestRaidMember", -- [1201]
	"TargetUnit", -- [1202]
	"ToggleBackpack", -- [1204]
	"ToggleBag", -- [1205]
	"ToggleCharacter", -- [1206]
	"ToggleFriendsFrame", -- [1207]
	"ToggleSpellBook", -- [1208]
	"TradeSkill", -- [1209]
	"CloseTradeSkill", -- [1210]
	"CollapseTradeSkillSubClass", -- [1211]
	"PickupPlayerMoney", -- [1212]
	"PickupTradeMoney", -- [1213]
	"SetTradeMoney", -- [1214]
	"ReplaceTradeEnchant", -- [1215]
	"AssistUnit", -- [1217]
	"CheckInteractDistance", -- [1218]
	"DropItemOnUnit", -- [1219]
	"FollowUnit", -- [1220]
	"FocusUnit", -- [1221]
	"ClearFocus", -- [1222]
	"GetUnitName", -- [1223]
	"GetUnitPitch", -- [1224]
	"GetUnitSpeed", -- [1225]
	"InviteUnit", -- [1226]
	"IsUnitOnQuest", -- [1227]
	"SpellCanTargetUnit", -- [1228]
	"SpellTargetUnit", -- [1229]
	"TargetUnit", -- [1230]
	"UnitAffectingCombat", -- [1231]
	"UnitArmor", -- [1232]
	"UnitAttackBothHands", -- [1233]
	"UnitAttackPower", -- [1234]
	"UnitAttackSpeed", -- [1235]
	"UnitAura", -- [1236]
	"UnitBuff", -- [1237]
	"UnitCanAssist", -- [1238]
	"UnitCanAttack", -- [1239]
	"UnitCanCooperate", -- [1240]
	"UnitClass", -- [1241]
	"UnitClassification", -- [1242]
	"UnitCreatureFamily", -- [1243]
	"UnitCreatureType", -- [1244]
	"UnitDamage", -- [1245]
	"UnitDebuff", -- [1246]
	"UnitDefense", -- [1247]
	"UnitDetailedThreatSituation", -- [1248]
	"UnitExists", -- [1249]
	"UnitFactionGroup", -- [1250]
	"UnitGroupRolesAssigned", -- [1251]
	"UnitGUID", -- [1252]
	"GetPlayerInfoByGUID", -- [1253]
	"UnitHasLFGDeserter", -- [1254]
	"UnitHasLFGRandomCooldown", -- [1255]
	"UnitHasRelicSlot", -- [1256]
	"UnitHealth", -- [1257]
	"UnitHealthMax", -- [1258]
	"UnitInParty", -- [1259]
	"UnitInRaid", -- [1260]
	"UnitInBattleground", -- [1261]
	"UnitIsInMyGuild", -- [1262]
	"UnitInRange", -- [1263]
	"UnitIsAFK", -- [1264]
	"UnitIsCharmed", -- [1265]
	"UnitIsConnected", -- [1266]
	"UnitIsCorpse", -- [1267]
	"UnitIsDead", -- [1268]
	"UnitIsDeadOrGhost", -- [1269]
	"UnitIsDND", -- [1270]
	"UnitIsEnemy", -- [1271]
	"UnitIsFeignDeath", -- [1272]
	"UnitIsFriend", -- [1273]
	"UnitIsGhost", -- [1274]
	"UnitIsPVP", -- [1275]
	"UnitIsPVPFreeForAll", -- [1276]
	"UnitIsPVPSanctuary", -- [1277]
	"UnitIsPartyLeader", -- [1278]
	"UnitIsPlayer", -- [1279]
	"UnitIsPossessed", -- [1280]
	"UnitIsRaidOfficer", -- [1281]
	"UnitIsSameServer", -- [1282]
	"UnitIsTapped", -- [1283]
	"UnitIsTappedByPlayer", -- [1284]
	"UnitIsTappedByAllThreatList", -- [1285]
	"UnitIsTrivial", -- [1286]
	"UnitIsUnit", -- [1287]
	"UnitIsVisible", -- [1288]
	"UnitLevel", -- [1289]
	"UnitMana", -- [1290]
	"UnitManaMax", -- [1291]
	"UnitName", -- [1292]
	"UnitOnTaxi", -- [1293]
	"UnitPlayerControlled", -- [1294]
	"UnitPlayerOrPetInParty", -- [1295]
	"UnitPlayerOrPetInRaid", -- [1296]
	"UnitPVPName", -- [1297]
	"UnitPVPRank", -- [1298]
	"UnitPower", -- [1299]
	"UnitPowerMax", -- [1300]
	"UnitPowerType", -- [1301]
	"UnitRace", -- [1302]
	"UnitRangedAttack", -- [1303]
	"UnitRangedAttackPower", -- [1304]
	"UnitRangedDamage", -- [1305]
	"UnitReaction", -- [1306]
	"UnitResistance", -- [1307]
	"UnitSelectionColor", -- [1308]
	"UnitSex", -- [1309]
	"UnitStat", -- [1310]
	"UnitThreatSituation", -- [1311]
	"UnitUsingVehicle", -- [1312]
	"GetThreatStatusColor", -- [1313]
	"UnitXP", -- [1314]
	"UnitXPMax", -- [1315]
	"SetPortraitTexture", -- [1316]
	"SetPortraitToTexture", -- [1317]
	"tinsert", -- [1318]
}

-- endp
