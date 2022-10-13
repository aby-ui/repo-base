
local DF = _G ["DetailsFramework"]
if (not DF or not DetailsFrameworkCanLoad) then
	return
end

local _
local loadstring = loadstring --lua local
local APITextEntryFunctions = false

do
	local metaPrototype = {
		WidgetType = "textentry",
		SetHook = DF.SetHook,
		HasHook = DF.HasHook,
		ClearHooks = DF.ClearHooks,
		RunHooksForWidget = DF.RunHooksForWidget,
		dversion = DF.dversion,
	}

	--check if there's a metaPrototype already existing
	if (_G[DF.GlobalWidgetControlNames["textentry"]]) then
		--get the already existing metaPrototype
		local oldMetaPrototype = _G[DF.GlobalWidgetControlNames["textentry"]]
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
		_G[DF.GlobalWidgetControlNames["textentry"]] = metaPrototype
	end
end

local TextEntryMetaFunctions = _G[DF.GlobalWidgetControlNames["textentry"]]

DF:Mixin(TextEntryMetaFunctions, DF.SetPointMixin)
DF:Mixin(TextEntryMetaFunctions, DF.FrameMixin)


DF.TextEntryCounter = DF.TextEntryCounter or 1

------------------------------------------------------------------------------------------------------------
--metatables

	TextEntryMetaFunctions.__call = function(object, value)
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
		return object.editbox:GetWidth()
	end

	--frame height
	local gmember_height = function(object)
		return object.editbox:GetHeight()
	end

	--get text
	local gmember_text = function(object)
		return object.editbox:GetText()
	end

	--return if the text entry has focus
	local gmember_hasfocus = function(object)
		return object:HasFocus()
	end

	TextEntryMetaFunctions.GetMembers = TextEntryMetaFunctions.GetMembers or {}
	TextEntryMetaFunctions.GetMembers["tooltip"] = gmember_tooltip
	TextEntryMetaFunctions.GetMembers["shown"] = gmember_shown
	TextEntryMetaFunctions.GetMembers["width"] = gmember_width
	TextEntryMetaFunctions.GetMembers["height"] = gmember_height
	TextEntryMetaFunctions.GetMembers["text"] = gmember_text
	TextEntryMetaFunctions.GetMembers["hasfocus"] = gmember_hasfocus

	TextEntryMetaFunctions.__index = function(object, key)
		local func = TextEntryMetaFunctions.GetMembers[key]
		if (func) then
			return func(object, key)
		end

		local fromMe = rawget(object, key)
		if (fromMe) then
			return fromMe
		end

		return TextEntryMetaFunctions[key]
	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
		return object.editbox:SetWidth(value)
	end

	--frame height
	local smember_height = function(object, value)
		return object.editbox:SetHeight(value)
	end

	--set text
	local smember_text = function(object, value)
		return object.editbox:SetText(value)
	end

	--set multiline
	local smember_multiline = function(object, value)
		if (value) then
			return object.editbox:SetMultiLine(true)
		else
			return object.editbox:SetMultiLine(false)
		end
	end

	--text horizontal pos
	local smember_horizontalpos = function(object, value)
		return object.editbox:SetJustifyH(string.lower(value))
	end

	TextEntryMetaFunctions.SetMembers = TextEntryMetaFunctions.SetMembers or {}
	TextEntryMetaFunctions.SetMembers["tooltip"] = smember_tooltip
	TextEntryMetaFunctions.SetMembers["show"] = smember_show
	TextEntryMetaFunctions.SetMembers["hide"] = smember_hide
	TextEntryMetaFunctions.SetMembers["width"] = smember_width
	TextEntryMetaFunctions.SetMembers["height"] = smember_height
	TextEntryMetaFunctions.SetMembers["text"] = smember_text
	TextEntryMetaFunctions.SetMembers["multiline"] = smember_multiline
	TextEntryMetaFunctions.SetMembers["align"] = smember_horizontalpos

	TextEntryMetaFunctions.__newindex = function(object, key, value)
		local func = TextEntryMetaFunctions.SetMembers[key]
		if (func) then
			return func(object, value)
		else
			return rawset(object, key, value)
		end
	end

------------------------------------------------------------------------------------------------------------
--methods

	local cleanfunction = function()end
	function TextEntryMetaFunctions:SetEnterFunction(func, param1, param2)
		if (func) then
			rawset(self, "func", func)
		else
			rawset(self, "func", cleanfunction)
		end

		if (param1 ~= nil) then
			rawset(self, "param1", param1)
		end
		if (param2 ~= nil) then
			rawset(self, "param2", param2)
		end
	end

	function TextEntryMetaFunctions:SetText(text)
		self.editbox:SetText(text)
	end

	function TextEntryMetaFunctions:GetText()
		return self.editbox:GetText()
	end

	--select all text
	function TextEntryMetaFunctions:SelectAll()
		self.editbox:HighlightText()
	end

	function TextEntryMetaFunctions:SetAutoSelectTextOnFocus(value)
		self.autoSelectAllText = value
	end

	--set label description
	function TextEntryMetaFunctions:SetLabelText(text)
		self.label:SetText(text)
	end

	--set tab order
	function TextEntryMetaFunctions:SetNext(nextbox)
		self.next = nextbox
	end

	--blink
	function TextEntryMetaFunctions:Blink()
		self.label:SetTextColor(1, .2, .2, 1)
	end

	--tooltip
	function TextEntryMetaFunctions:SetTooltip(tooltip)
		if (tooltip) then
			return rawset(self, "have_tooltip", tooltip)
		else
			return rawset(self, "have_tooltip", nil)
		end
	end

	function TextEntryMetaFunctions:GetTooltip()
		return rawget(self, "have_tooltip")
	end

	--hooks
	function TextEntryMetaFunctions:Enable()
		if (not self.editbox:IsEnabled()) then
			self.editbox:Enable()
			self.editbox:SetBackdropBorderColor(unpack (self.enabled_border_color))
			self.editbox:SetBackdropColor(unpack (self.enabled_backdrop_color))
			self.editbox:SetTextColor (unpack (self.enabled_text_color))
			if (self.editbox.borderframe) then
				local r, g, b, a = DF:ParseColors(unpack(self.editbox.borderframe.onleave_backdrop))
				self.editbox.borderframe:SetBackdropColor(r, g, b, a)
			end
		end
	end

	function TextEntryMetaFunctions:Disable()
		if (self.editbox:IsEnabled()) then
			self.enabled_border_color = {self.editbox:GetBackdropBorderColor()}
			self.enabled_backdrop_color = {self.editbox:GetBackdropColor()}
			self.enabled_text_color = {self.editbox:GetTextColor()}

			self.editbox:Disable()

			self.editbox:SetBackdropBorderColor(.5, .5, .5, .5)
			self.editbox:SetBackdropColor(.5, .5, .5, .5)
			self.editbox:SetTextColor(.5, .5, .5, .5)

			if (self.editbox.borderframe) then
				self.editbox.borderframe:SetBackdropColor(.5, .5, .5, .5)
			end
		end
	end

	function TextEntryMetaFunctions:SetCommitFunction(func)
		if (type(func) == "function") then
			self.func = func
		end
	end

	function TextEntryMetaFunctions:IgnoreNextCallback()
		self.ignoreNextCallback = true
	end

------------------------------------------------------------------------------------------------------------
--scripts and hooks

	local OnEnter = function(textentry)
		local capsule = textentry.MyObject
		
		local kill = capsule:RunHooksForWidget ("OnEnter", textentry, capsule)
		if (kill) then
			return
		end

		if (capsule.have_tooltip) then 
			GameCooltip2:Preset (2)
			GameCooltip2:AddLine (capsule.have_tooltip)
			GameCooltip2:ShowCooltip(textentry, "tooltip")
		end
		
		textentry.mouse_over = true 

		if (textentry:IsEnabled()) then 
			textentry.current_bordercolor = textentry.current_bordercolor or {textentry:GetBackdropBorderColor()}
			textentry:SetBackdropBorderColor(1, 1, 1, 1)
		end
	end
	
	local OnLeave = function(textentry)
		local capsule = textentry.MyObject
	
		local kill = capsule:RunHooksForWidget ("OnLeave", textentry, capsule)
		if (kill) then
			return
		end

		if (textentry.MyObject.have_tooltip) then 
			GameCooltip2:ShowMe(false)
		end
		
		textentry.mouse_over = false 
		
		if (textentry:IsEnabled()) then 
			textentry:SetBackdropBorderColor(unpack (textentry.current_bordercolor))
		end
	end
	
	local OnHide = function(textentry)
		local capsule = textentry.MyObject
		
		local kill = capsule:RunHooksForWidget ("OnHide", textentry, capsule)
		if (kill) then
			return
		end
	end
	
	local OnShow = function(textentry)
		local capsule = textentry.MyObject
		
		local kill = capsule:RunHooksForWidget ("OnShow", textentry, capsule)
		if (kill) then
			return
		end
	end

	local OnEnterPressed = function(textentry, byScript)
		local object = textentry.MyObject

		if (object.ignoreNextCallback) then
			DF.Schedules.RunNextTick(function() object.ignoreNextCallback = nil end)
			return
		end

		local kill = object:RunHooksForWidget("OnEnterPressed", textentry, object, object.text)
		if (kill) then
			return
		end

		local text = DF:Trim(textentry:GetText())
		if (string.len(text) > 0) then
			textentry.text = text
			if (textentry.MyObject.func) then
				textentry.MyObject.func(textentry.MyObject.param1, textentry.MyObject.param2, text, textentry, byScript or textentry)
			end
		else
			textentry:SetText("")
			textentry.MyObject.currenttext = ""
		end

		if (not object.NoClearFocusOnEnterPressed) then
			textentry.focuslost = true --quando estiver editando e clicar em outra caixa
			textentry:ClearFocus()
			if (textentry.MyObject.tab_on_enter and textentry.MyObject.next) then
				textentry.MyObject.next:SetFocus()
			end
		end
	end
	
	local OnEscapePressed = function(textentry)
		local capsule = textentry.MyObject
	
		local kill = capsule:RunHooksForWidget ("OnEscapePressed", textentry, capsule, capsule.text)
		if (kill) then
			return
		end	

		textentry.focuslost = true
		textentry:ClearFocus() 
	end

	local OnSpacePressed = function(textEntry)
		local object = textEntry.MyObject
		local kill = object:RunHooksForWidget ("OnSpacePressed", textEntry, object)
		if (kill) then
			return
		end
	end

	local OnEditFocusLost = function(textEntry)
		local object = textEntry.MyObject

		if (object.ignoreNextCallback) then
			DF.Schedules.RunNextTick(function() object.ignoreNextCallback = nil end)
			return
		end

		if (textEntry:IsShown()) then
			local kill = object:RunHooksForWidget("OnEditFocusLost", textEntry, object, object.text)
			if (kill) then
				return
			end

			if (not textEntry.focuslost) then
				local text = DF:Trim(textEntry:GetText())
				if (string.len(text) > 0) then
					textEntry.MyObject.currenttext = text
					if (textEntry.MyObject.func) then
						textEntry.MyObject.func(textEntry.MyObject.param1, textEntry.MyObject.param2, text, textEntry, nil)
					end
				else
					textEntry:SetText("")
					textEntry.MyObject.currenttext = ""
				end
			else
				textEntry.focuslost = false
			end

			textEntry.MyObject.label:SetTextColor (.8, .8, .8, 1)
		end
	end

	local OnEditFocusGained = function(textentry)
		local object = textentry.MyObject
		local kill = object:RunHooksForWidget ("OnEditFocusGained", textentry, object)
		if (kill) then
			return
		end
		textentry.MyObject.label:SetTextColor(1, 1, 1, 1)

		if (object.autoSelectAllText) then
			object:SelectAll()
		end
	end

	local OnChar = function(textentry, char)
		local object = textentry.MyObject
		local kill = object:RunHooksForWidget ("OnChar", textentry, char, object)
		if (kill) then
			return
		end
	end
	
	local OnTextChanged = function(textentry, byUser) 
		local capsule = textentry.MyObject
		
		local kill = capsule:RunHooksForWidget ("OnTextChanged", textentry, byUser, capsule)
		if (kill) then
			return
		end
	end
	
	local OnTabPressed = function(textentry) 
	
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
		self.editbox:SetWidth(template.width)
	end
	if (template.height) then
		self.editbox:SetHeight(template.height)
	end
	
	if (template.backdrop) then
		self.editbox:SetBackdrop(template.backdrop)
	end
	if (template.backdropcolor) then
		local r, g, b, a = DF:ParseColors(template.backdropcolor)
		self.editbox:SetBackdropColor(r, g, b, a)
		self.onleave_backdrop = {r, g, b, a}
	end
	if (template.backdropbordercolor) then
		local r, g, b, a = DF:ParseColors(template.backdropbordercolor)
		self.editbox:SetBackdropBorderColor(r, g, b, a)
		self.editbox.current_bordercolor[1] = r
		self.editbox.current_bordercolor[2] = g
		self.editbox.current_bordercolor[3] = b
		self.editbox.current_bordercolor[4] = a
		self.onleave_backdrop_border_color = {r, g, b, a}
	end
end

------------------------------------------------------------------------------------------------------------
--object constructor

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
	
	--default members:
		--hooks
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

		--misc
		TextEntryObject.container = container
		TextEntryObject.have_tooltip = nil

	TextEntryObject.editbox = CreateFrame("EditBox", name, parent,"BackdropTemplate")
	TextEntryObject.editbox:SetSize(232, 20)
	TextEntryObject.editbox:SetBackdrop({bgFile = [["Interface\DialogFrame\UI-DialogBox-Background"]], tileSize = 64, tile = true, edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]], edgeSize = 10, insets = {left = 1, right = 1, top = 0, bottom = 0}})
	
	TextEntryObject.editbox.label = TextEntryObject.editbox:CreateFontString ("$parent_Desc", "OVERLAY", "GameFontHighlightSmall")
	TextEntryObject.editbox.label:SetJustifyH("left")
	TextEntryObject.editbox.label:SetPoint("RIGHT", TextEntryObject.editbox, "LEFT", -2, 0)
	
	TextEntryObject.widget = TextEntryObject.editbox
	
	TextEntryObject.editbox:SetTextInsets (3, 0, 0, -3)

	if (not APITextEntryFunctions) then
		APITextEntryFunctions = true
		local idx = getmetatable (TextEntryObject.editbox).__index
		for funcName, funcAddress in pairs(idx) do 
			if (not TextEntryMetaFunctions [funcName]) then
				TextEntryMetaFunctions [funcName] = function(object, ...)
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
	
	TextEntryObject.editbox:SetWidth(w)
	TextEntryObject.editbox:SetHeight(h)

	TextEntryObject.editbox:SetJustifyH("center")
	TextEntryObject.editbox:EnableMouse (true)
	TextEntryObject.editbox:SetText("")

	TextEntryObject.editbox:SetAutoFocus (false)
	TextEntryObject.editbox:SetFontObject ("GameFontHighlightSmall")

	TextEntryObject.editbox.current_bordercolor = {1, 1, 1, 0.7}
	TextEntryObject.editbox:SetBackdropBorderColor(1, 1, 1, 0.7)
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
	TextEntryObject.editbox:SetBackdrop({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, insets = {left = 1, right = 1, top = 1, bottom = 1}})
	TextEntryObject.editbox:SetBackdropColor(.2, .2, .2, 1)

	--hooks
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
		
		TextEntryObject.editbox:SetScript("OnEnter", OnEnter)
		TextEntryObject.editbox:SetScript("OnLeave", OnLeave)
		TextEntryObject.editbox:SetScript("OnHide", OnHide)
		TextEntryObject.editbox:SetScript("OnShow", OnShow)
		
		TextEntryObject.editbox:SetScript("OnEnterPressed", OnEnterPressed)
		TextEntryObject.editbox:SetScript("OnEscapePressed", OnEscapePressed)
		TextEntryObject.editbox:SetScript("OnSpacePressed", OnSpacePressed)
		TextEntryObject.editbox:SetScript("OnEditFocusLost", OnEditFocusLost)
		TextEntryObject.editbox:SetScript("OnEditFocusGained", OnEditFocusGained)
		TextEntryObject.editbox:SetScript("OnChar", OnChar)
		TextEntryObject.editbox:SetScript("OnTextChanged", OnTextChanged)
		TextEntryObject.editbox:SetScript("OnTabPressed", OnTabPressed)
		
	setmetatable (TextEntryObject, TextEntryMetaFunctions)
	
	if (with_label) then
		local label = DF:CreateLabel(TextEntryObject.editbox, with_label, nil, nil, nil, "label", nil, "overlay")
		label.text = with_label
		TextEntryObject.editbox:SetPoint("left", label.widget, "right", 2, 0)
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
	
--	editbox:SetHook("OnEditFocusGained", SpellEntryOnEditFocusGained)
--	editbox:SetHook("OnTextChanged", SpellEntryOnTextChanged)
	
	return editbox	
end

local function_gettext = function(self)
	return self.editbox:GetText()
end
local function_settext = function(self, text)
	return self.editbox:SetText(text)
end
local function_clearfocus = function(self)
	return self.editbox:ClearFocus()
end
local function_setfocus = function(self)
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

local get_last_word = function(self)
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
local AutoComplete_OnTextChanged = function(editboxWidget, byUser, capsule)
	capsule = capsule or editboxWidget.MyObject or editboxWidget
	
	local chars_now = editboxWidget:GetText():len()
	if (not editboxWidget.ignore_textchange) then
		--backspace
		if (chars_now == capsule.characters_count -1) then
			capsule.lastword = capsule.lastword:sub (1, capsule.lastword:len()-1)
		--delete lots of text
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

local AutoComplete_OnSpacePressed = function(editboxWidget, capsule)
	capsule = capsule or editboxWidget.MyObject or editboxWidget

--	if (not gotMatch) then
		--editboxWidget.end_selection = nil
--	end
end

local AutoComplete_OnEscapePressed = function(editboxWidget)
	editboxWidget.end_selection = nil
end

local AutoComplete_OnEnterPressed = function(editboxWidget)

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

local AutoComplete_OnEditFocusGained = function(editboxWidget)
	local capsule = editboxWidget.MyObject or editboxWidget
	capsule:GetLastWord()
	--print ("last word:", editboxWidget.lastword)
	editboxWidget.end_selection = nil
	editboxWidget.focusGained = true
	capsule.characters_count = editboxWidget:GetText():len()	
end

local OptimizeAutoCompleteTable = function(self, wordList)
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

local AutoComplete_OnChar = function(editboxWidget, char, capsule)
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
		
		self:SetHook("OnEditFocusGained", AutoComplete_OnEditFocusGained)
		self:SetHook("OnEnterPressed", AutoComplete_OnEnterPressed)
		self.editbox:HookScript ("OnEscapePressed", AutoComplete_OnEscapePressed)
		self.editbox:SetScript("OnTextChanged", AutoComplete_OnTextChanged)
		self.editbox:SetScript("OnChar", AutoComplete_OnChar)
		self.editbox:SetScript("OnSpacePressed", AutoComplete_OnSpacePressed)
	end

end

local set_speciallua_editor_font_size = function(borderFrame, newSize)
	local file, size, flags = borderFrame.editbox:GetFont()
	borderFrame.editbox:SetFont (file, newSize, flags)

	borderFrame.editboxlines:SetFont (file, newSize, flags)
end

function DF:NewSpecialLuaEditorEntry (parent, w, h, member, name, nointent, showLineNumbers)

	if (name:find ("$parent")) then
		local parentName = DF.GetParentName (parent)
		name = name:gsub ("$parent", parentName)
	end
	
	local borderframe = CreateFrame("Frame", name, parent,"BackdropTemplate")
	borderframe:SetSize(w, h)
	
	if (member) then
		parent [member] = borderframe
	end
	
	local scrollframe = CreateFrame("ScrollFrame", name, borderframe, "UIPanelScrollFrameTemplate, BackdropTemplate")
	local scrollframeNumberLines = CreateFrame("ScrollFrame", name .. "NumberLines", borderframe, "UIPanelScrollFrameTemplate, BackdropTemplate")

	scrollframe.editbox = CreateFrame("editbox", "$parentEditBox", scrollframe,"BackdropTemplate")
	scrollframe.editbox:SetMultiLine (true)
	scrollframe.editbox:SetAutoFocus (false)
	scrollframe.editbox:SetScript("OnCursorChanged", _G.ScrollingEdit_OnCursorChanged)
	scrollframe.editbox:SetScript("OnEscapePressed", _G.EditBox_ClearFocus)
	scrollframe.editbox:SetFontObject ("GameFontHighlightSmall")
	scrollframe:SetScrollChild (scrollframe.editbox)

	--line number
	if (showLineNumbers) then
		scrollframeNumberLines.editbox = CreateFrame("editbox", "$parentLineNumbers", scrollframeNumberLines, "BackdropTemplate")
		scrollframeNumberLines.editbox:SetMultiLine (true)
		scrollframeNumberLines.editbox:SetAutoFocus (false)
		scrollframeNumberLines.editbox:SetEnabled (false)
		scrollframeNumberLines.editbox:SetFontObject ("GameFontHighlightSmall")
		scrollframeNumberLines.editbox:SetJustifyH("left")
		scrollframeNumberLines.editbox:SetJustifyV ("top")
		scrollframeNumberLines.editbox:SetTextColor(.3, .3, .3, .5)
		scrollframeNumberLines.editbox:SetPoint("topleft", borderframe, "topleft", 10, -10)
		scrollframeNumberLines.editbox:SetPoint("bottomright", borderframe, "bottomright", -30, 10)

		scrollframeNumberLines:SetScrollChild (scrollframeNumberLines.editbox)
		scrollframeNumberLines:EnableMouseWheel(false)

		for i = 1, 1000 do
			scrollframeNumberLines.editbox:Insert (i .. "\n")
		end

		--place the lua code field 20 pixels to the right to make run to the lines scroll
		scrollframe:SetPoint("topleft", borderframe, "topleft", 30, -10)
		scrollframe:SetPoint("bottomright", borderframe, "bottomright", -10, 10)

		--when the lua code field scrolls, make the lua field scroll too
		scrollframe:SetScript("OnVerticalScroll", function(self, offset)
			scrollframeNumberLines:SetVerticalScroll(scrollframe:GetVerticalScroll())
			scrollframeNumberLines.ScrollBar:Hide()
		end)

		--place the number lines scroll in the begining of the editing code space
		scrollframeNumberLines:SetPoint("topleft", borderframe, "topleft", 10, -10)
		scrollframeNumberLines:SetPoint("bottomright", borderframe, "bottomright", -10, 10)

		scrollframeNumberLines.editbox:SetJustifyH("left")
		scrollframeNumberLines.editbox:SetJustifyV ("top")

		scrollframeNumberLines:SetScript("OnSizeChanged", function(self)
			scrollframeNumberLines.editbox:SetSize(self:GetSize())
			scrollframeNumberLines.ScrollBar:Hide()
		end)

		scrollframeNumberLines.ScrollBar:HookScript("OnShow", function(self)
			self:Hide()
		end)

		borderframe.scrollnumberlines = scrollframeNumberLines
		borderframe.editboxlines = scrollframeNumberLines.editbox
		borderframe.editboxlines.borderframe = borderframe

		scrollframeNumberLines.ScrollBar:Hide()
		scrollframeNumberLines:SetBackdrop(nil)
		scrollframeNumberLines.editbox:SetBackdrop(nil)

	else
		scrollframe:SetPoint("topleft", borderframe, "topleft", 10, -10)
		scrollframe:SetPoint("bottomright", borderframe, "bottomright", -10, 10)
		scrollframeNumberLines:SetPoint("topleft", borderframe, "topleft", 10, -10)
		scrollframeNumberLines:SetPoint("bottomright", borderframe, "bottomright", -10, 10)
		scrollframeNumberLines:Hide()
	end

	borderframe.SetAsAutoComplete = TextEntryMetaFunctions.SetAsAutoComplete
	
	scrollframe:SetScript("OnSizeChanged", function(self)
		scrollframe.editbox:SetSize(self:GetSize())
	end)
	
	scrollframe.editbox:SetJustifyH("left")
	scrollframe.editbox:SetJustifyV ("top")
	scrollframe.editbox:SetMaxBytes (1024000)
	scrollframe.editbox:SetMaxLetters (128000)
	
	borderframe.GetText = function_gettext
	borderframe.SetText = function_settext
	borderframe.ClearFocus = function_clearfocus
	borderframe.SetFocus = function_setfocus
	borderframe.SetTextSize = set_speciallua_editor_font_size
	
	borderframe.Enable = TextEntryMetaFunctions.Enable
	borderframe.Disable = TextEntryMetaFunctions.Disable
	
	borderframe.SetTemplate = TextEntryMetaFunctions.SetTemplate
	
	if (not nointent) then
		IndentationLib.enable (scrollframe.editbox, nil, 4)
	end

	borderframe:SetBackdrop({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]], 
		tile = 1, tileSize = 16, edgeSize = 16, insets = {left = 5, right = 5, top = 5, bottom = 5}})
	
	scrollframe.editbox.current_bordercolor = {1, 1, 1, 0.7}
	borderframe:SetBackdropBorderColor(1, 1, 1, 0.7)
	borderframe:SetBackdropColor(0.090195, 0.090195, 0.188234, 1)
	
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
	local result = 0
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
