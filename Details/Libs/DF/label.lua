
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
local APILabelFunctions = false

do
	local metaPrototype = {
		WidgetType = "label",
		SetHook = DF.SetHook,
		RunHooksForWidget = DF.RunHooksForWidget,

		dversion = DF.dversion,
	}

	--check if there's a metaPrototype already existing
	if (_G[DF.GlobalWidgetControlNames["label"]]) then
		--get the already existing metaPrototype
		local oldMetaPrototype = _G[DF.GlobalWidgetControlNames ["label"]]
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
		_G[DF.GlobalWidgetControlNames ["label"]] = metaPrototype
	end
end

local LabelMetaFunctions = _G[DF.GlobalWidgetControlNames ["label"]]

------------------------------------------------------------------------------------------------------------
--> metatables

	LabelMetaFunctions.__call = function (_table, value)
		return self.label:SetText (value)
	end

------------------------------------------------------------------------------------------------------------
--> members

	--> shown
	local gmember_shown = function (_object)
		return _object:IsShown()
	end
	--> frame width
	local gmember_width = function (_object)
		return _object.label:GetStringWidth()
	end
	--> frame height
	local gmember_height = function (_object)
		return _object.label:GetStringHeight()
	end
	--> text
	local gmember_text = function (_object)
		return _object.label:GetText()
	end
	--> text color
	local gmember_textcolor = function (_object)
		return _object.label:GetTextColor()
	end
	--> text font
	local gmember_textfont = function (_object)
		local fontface = _object.label:GetFont()
		return fontface
	end
	--> text size
	local gmember_textsize = function (_object)
		local _, fontsize = _object.label:GetFont()
		return fontsize
	end

	LabelMetaFunctions.GetMembers = LabelMetaFunctions.GetMembers or {}
	LabelMetaFunctions.GetMembers ["shown"] = gmember_shown
	LabelMetaFunctions.GetMembers ["width"] = gmember_width
	LabelMetaFunctions.GetMembers ["height"] = gmember_height
	LabelMetaFunctions.GetMembers ["text"] = gmember_text
	LabelMetaFunctions.GetMembers ["fontcolor"] = gmember_textcolor
	LabelMetaFunctions.GetMembers ["fontface"] = gmember_textfont
	LabelMetaFunctions.GetMembers ["fontsize"] = gmember_textsize
	LabelMetaFunctions.GetMembers ["textcolor"] = gmember_textcolor --alias
	LabelMetaFunctions.GetMembers ["textfont"] = gmember_textfont --alias
	LabelMetaFunctions.GetMembers ["textsize"] = gmember_textsize --alias

	LabelMetaFunctions.__index = function (_table, _member_requested)

		local func = LabelMetaFunctions.GetMembers [_member_requested]
		if (func) then
			return func (_table, _member_requested)
		end
		
		local fromMe = _rawget (_table, _member_requested)
		if (fromMe) then
			return fromMe
		end
		
		return LabelMetaFunctions [_member_requested]
	end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
	--> text
	local smember_text = function (_object, _value)
		return _object.label:SetText (_value)
	end
	--> text color
	local smember_textcolor = function (_object, _value)
		local _value1, _value2, _value3, _value4 = DF:ParseColors (_value)
		return _object.label:SetTextColor (_value1, _value2, _value3, _value4)	
	end
	--> text font
	local smember_textfont = function (_object, _value)
		return DF:SetFontFace (_object.label, _value)
	end
	--> text size
	local smember_textsize = function (_object, _value)
		return DF:SetFontSize (_object.label, _value)
	end
	--> text align
	local smember_textalign = function (_object, _value)
		if (_value == "<") then
			_value = "left"
		elseif (_value == ">") then
			_value = "right"
		elseif (_value == "|") then
			_value = "center"
		end
		return _object.label:SetJustifyH (_value)
	end
	--> text valign
	local smember_textvalign = function (_object, _value)
		if (_value == "^") then
			_value = "top"
		elseif (_value == "_") then
			_value = "bottom"
		elseif (_value == "|") then
			_value = "middle"
		end
		return _object.label:SetJustifyV (_value)
	end
	--> field size width
	local smember_width = function (_object, _value)
		return _object.label:SetWidth (_value)
	end
	--> field size height
	local smember_height = function (_object, _value)
		return _object.label:SetHeight (_value)
	end
	--> outline (shadow)
	local smember_outline = function (_object, _value)
		DF:SetFontOutline (_object.label, _value)
	end
	
	LabelMetaFunctions.SetMembers = LabelMetaFunctions.SetMembers or {}
	LabelMetaFunctions.SetMembers["show"] = smember_show
	LabelMetaFunctions.SetMembers["hide"] = smember_hide
	LabelMetaFunctions.SetMembers["align"] = smember_textalign
	LabelMetaFunctions.SetMembers["valign"] = smember_textvalign
	LabelMetaFunctions.SetMembers["text"] = smember_text
	LabelMetaFunctions.SetMembers["width"] = smember_width
	LabelMetaFunctions.SetMembers["height"] = smember_height
	LabelMetaFunctions.SetMembers["fontcolor"] = smember_textcolor
	LabelMetaFunctions.SetMembers["color"] = smember_textcolor--alias
	LabelMetaFunctions.SetMembers["fontface"] = smember_textfont
	LabelMetaFunctions.SetMembers["fontsize"] = smember_textsize
	LabelMetaFunctions.SetMembers["textcolor"] = smember_textcolor--alias
	LabelMetaFunctions.SetMembers["textfont"] = smember_textfont--alias
	LabelMetaFunctions.SetMembers["textsize"] = smember_textsize--alias
	LabelMetaFunctions.SetMembers["shadow"] = smember_outline
	LabelMetaFunctions.SetMembers["outline"] = smember_outline--alias
	
	LabelMetaFunctions.__newindex = function (_table, _key, _value)
		local func = LabelMetaFunctions.SetMembers [_key]
		if (func) then
			return func (_table, _value)
		else
			return _rawset (_table, _key, _value)
		end
	end
	
------------------------------------------------------------------------------------------------------------
--> methods
	
--> show & hide
	function LabelMetaFunctions:IsShown()
		return self.label:IsShown()
	end
	function LabelMetaFunctions:Show()
		return self.label:Show()
	end
	function LabelMetaFunctions:Hide()
		return self.label:Hide()
	end
	
--text text
	function LabelMetaFunctions:SetTextTruncated (text, maxWidth)
		self.widget:SetText (text)
		DF:TruncateText (self.widget, maxWidth)
	end
	
-- textcolor
	function LabelMetaFunctions:SetTextColor (color, arg2, arg3, arg4)
		if (arg2) then
			return self.label:SetTextColor (color, arg2, arg3, arg4 or 1)
		end
		local _value1, _value2, _value3, _value4 = DF:ParseColors (color)
		return self.label:SetTextColor (_value1, _value2, _value3, _value4)
	end
	
-- setpoint
	function LabelMetaFunctions:SetPoint (v1, v2, v3, v4, v5)
		v1, v2, v3, v4, v5 = DF:CheckPoints (v1, v2, v3, v4, v5, self)
		if (not v1) then
			print ("Invalid parameter for SetPoint")
			return
		end
		return self.widget:SetPoint (v1, v2, v3, v4, v5)
	end

------------------------------------------------------------------------------------------------------------

	function LabelMetaFunctions:SetTemplate (template)
		if (template.size) then
			DF:SetFontSize (self.label, template.size)
		end
		if (template.color) then
			local r, g, b, a = DF:ParseColors (template.color)
			self:SetTextColor (r, g, b, a)
		end
		if (template.font) then
			local SharedMedia = LibStub:GetLibrary ("LibSharedMedia-3.0")
			local font = SharedMedia:Fetch ("font", template.font)
			DF:SetFontFace (self.label, font)
		end
	end
	
------------------------------------------------------------------------------------------------------------
--> object constructor
function DF:CreateLabel (parent, text, size, color, font, member, name, layer)
	return DF:NewLabel (parent, nil, name, member, text, font, size, color, layer)
end

function DF:NewLabel (parent, container, name, member, text, font, size, color, layer)

	if (not parent) then
		return error ("Details! FrameWork: parent not found.", 2)
	end
	if (not container) then
		container = parent
	end
	
	if (not name) then
		name = "DetailsFrameworkLabelNumber" .. DF.LabelNameCounter
		DF.LabelNameCounter = DF.LabelNameCounter + 1
	end
	
	if (name:find ("$parent")) then
		local parentName = DF.GetParentName (parent)
		name = name:gsub ("$parent", parentName)
	end
	
	local LabelObject = {type = "label", dframework = true}
	
	if (member) then
		parent [member] = LabelObject
		--container [member] = LabelObject.label
	end
	
	if (parent.dframework) then
		parent = parent.widget
	end
	if (container.dframework) then
		container = container.widget
	end

	font = font == "" and "GameFontHighlightSmall" or font or "GameFontHighlightSmall"

	LabelObject.label = parent:CreateFontString (name, layer or "OVERLAY", font)
	LabelObject.widget = LabelObject.label
	
	LabelObject.label.MyObject = LabelObject
	
	if (not APILabelFunctions) then
		APILabelFunctions = true
		local idx = getmetatable (LabelObject.label).__index
		for funcName, funcAddress in pairs (idx) do 
			if (not LabelMetaFunctions [funcName]) then
				LabelMetaFunctions [funcName] = function (object, ...)
					local x = loadstring ( "return _G['"..object.label:GetName().."']:"..funcName.."(...)")
					return x (...)
				end
			end
		end
	end	
	
	LabelObject.label:SetText (text)
	
	if (color) then
		local r, g, b, a = DF:ParseColors (color)
		LabelObject.label:SetTextColor (r, g, b, a)
	end	
	
	if (size and type (size) == "number") then
		DF:SetFontSize (LabelObject.label, size)
	end
	
	LabelObject.HookList = {
	}
	
	LabelObject.label:SetJustifyH ("LEFT")
	
	setmetatable (LabelObject, LabelMetaFunctions)

	if (size and type (size) == "table") then
		LabelObject:SetTemplate (size)
	end
	
	return LabelObject
end
