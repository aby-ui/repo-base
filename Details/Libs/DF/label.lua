
local DF = _G ["DetailsFramework"]
if (not DF or not DetailsFrameworkCanLoad) then
	return
end

local _
local loadedAPILabelFunctions = false

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

	LabelMetaFunctions.__call = function(object, value)
		return object.label:SetText(value)
	end

------------------------------------------------------------------------------------------------------------
--> members

	--shown
	local gmember_shown = function(object)
		return object:IsShown()
	end
	--get text
	local gmember_text = function(object)
		return object.label:GetText()
	end
	--text width
	local gmember_width = function(object)
		return object.label:GetStringWidth()
	end
	--text height
	local gmember_height = function(object)
		return object.label:GetStringHeight()
	end
	--text color
	local gmember_textcolor = function(object)
		return object.label:GetTextColor()
	end
	--text font
	local gmember_textfont = function(object)
		local fontface = object.label:GetFont()
		return fontface
	end
	--text size
	local gmember_textsize = function(object)
		local _, fontsize = object.label:GetFont()
		return fontsize
	end

	LabelMetaFunctions.GetMembers = LabelMetaFunctions.GetMembers or {}
	LabelMetaFunctions.GetMembers["shown"] = gmember_shown
	LabelMetaFunctions.GetMembers["width"] = gmember_width
	LabelMetaFunctions.GetMembers["height"] = gmember_height
	LabelMetaFunctions.GetMembers["text"] = gmember_text
	LabelMetaFunctions.GetMembers["fontcolor"] = gmember_textcolor
	LabelMetaFunctions.GetMembers["fontface"] = gmember_textfont
	LabelMetaFunctions.GetMembers["fontsize"] = gmember_textsize
	LabelMetaFunctions.GetMembers["textcolor"] = gmember_textcolor --alias
	LabelMetaFunctions.GetMembers["textfont"] = gmember_textfont --alias
	LabelMetaFunctions.GetMembers["textsize"] = gmember_textsize --alias

	LabelMetaFunctions.__index = function(object, key)
		local func = LabelMetaFunctions.GetMembers[key]
		if (func) then
			return func(object, key)
		end

		local alreadyHaveKey = rawget(object, key)
		if (alreadyHaveKey) then
			return alreadyHaveKey
		end

		return LabelMetaFunctions[key]
	end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
	--text
	local smember_text = function(object, value)
		return object.label:SetText(value)
	end
	--text color
	local smember_textcolor = function(object, value)
		local value1, value2, value3, value4 = DF:ParseColors(value)
		return object.label:SetTextColor(value1, value2, value3, value4)
	end
	--text font
	local smember_textfont = function(object, value)
		return DF:SetFontFace(object.label, value)
	end
	--text size
	local smember_textsize = function(object, value)
		return DF:SetFontSize(object.label, value)
	end
	--text align
	local smember_textalign = function(object, value)
		if (value == "<") then
			value = "left"
		elseif (value == ">") then
			value = "right"
		elseif (value == "|") then
			value = "center"
		end
		return object.label:SetJustifyH(value)
	end
	--text valign
	local smember_textvalign = function(object, value)
		if (value == "^") then
			value = "top"
		elseif (value == "_") then
			value = "bottom"
		elseif (value == "|") then
			value = "middle"
		end
		return object.label:SetJustifyV(value)
	end
	--field size width
	local smember_width = function(object, value)
		return object.label:SetWidth(value)
	end
	--field size height
	local smember_height = function(object, value)
		return object.label:SetHeight(value)
	end
	--outline (shadow)
	local smember_outline = function(object, value)
		DF:SetFontOutline(object.label, value)
	end
	--text rotation
	local smember_rotation = function(object, rotation)
		if (type(rotation) == "number") then
			if (not object.__rotationAnimation) then
				object.__rotationAnimation = DF:CreateAnimationHub(object.label)
				object.__rotationAnimation.rotator = DF:CreateAnimation(object.__rotationAnimation, "rotation", 1, 0, 0)
				object.__rotationAnimation.rotator:SetEndDelay(10^8)
				object.__rotationAnimation.rotator:SetSmoothProgress(1)
			end
			object.__rotationAnimation.rotator:SetDegrees(rotation)
			object.__rotationAnimation:Play()
			object.__rotationAnimation:Pause()
		end
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
	LabelMetaFunctions.SetMembers["rotation"] = smember_rotation--alias

	LabelMetaFunctions.__newindex = function(object, key, value)
		local func = LabelMetaFunctions.SetMembers[key]
		if (func) then
			return func(object, value)
		else
			return rawset(object, key, value)
		end
	end

------------------------------------------------------------------------------------------------------------
--> methods

--show & hide
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
	function LabelMetaFunctions:SetTextTruncated(text, maxWidth)
		self.widget:SetText(text)
		DF:TruncateText(self.widget, maxWidth)
	end

--textcolor
	function LabelMetaFunctions:SetTextColor(r, g, b, a)
		r, g, b, a = DF:ParseColors(r, g, b, a)
		return self.label:SetTextColor(r, g, b, a)
	end

-- setpoint
	function LabelMetaFunctions:SetPoint(v1, v2, v3, v4, v5)
		v1, v2, v3, v4, v5 = DF:CheckPoints(v1, v2, v3, v4, v5, self)
		if (not v1) then
			print("Invalid parameter for SetPoint")
			return
		end
		return self.widget:SetPoint(v1, v2, v3, v4, v5)
	end

------------------------------------------------------------------------------------------------------------

	function LabelMetaFunctions:SetTemplate(template)
		if (template.size) then
			DF:SetFontSize(self.label, template.size)
		end
		if (template.color) then
			local r, g, b, a = DF:ParseColors(template.color)
			self:SetTextColor(r, g, b, a)
		end
		if (template.font) then
			local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
			local font = SharedMedia:Fetch("font", template.font)
			DF:SetFontFace(self.label, font)
		end
	end

------------------------------------------------------------------------------------------------------------
--> object constructor
function DF:CreateLabel(parent, text, size, color, font, member, name, layer)
	return DF:NewLabel(parent, nil, name, member, text, font, size, color, layer)
end

function DF:NewLabel(parent, container, name, member, text, font, size, color, layer)
	if (not parent) then
		return error("Details! Framework: parent not found.", 2)
	end
	if (not container) then
		container = parent
	end

	if (not name) then
		name = "DetailsFrameworkLabelNumber" .. DF.LabelNameCounter
		DF.LabelNameCounter = DF.LabelNameCounter + 1
	end

	if (name:find("$parent")) then
		local parentName = DF.GetParentName(parent)
		name = name:gsub("$parent", parentName)
	end

	local LabelObject = {type = "label", dframework = true}

	if (member) then
		parent[member] = LabelObject
	end

	if (parent.dframework) then
		parent = parent.widget
	end

	if (container.dframework) then
		container = container.widget
	end

	font = font == "" and "GameFontHighlightSmall" or font or "GameFontHighlightSmall"

	LabelObject.label = parent:CreateFontString(name, layer or "OVERLAY", font)
	LabelObject.widget = LabelObject.label
	LabelObject.label.MyObject = LabelObject

	if (not loadedAPILabelFunctions) then
		loadedAPILabelFunctions = true
		local idx = getmetatable(LabelObject.label).__index
		for funcName, funcAddress in pairs(idx) do
			if (not LabelMetaFunctions[funcName]) then
				LabelMetaFunctions[funcName] = function (object, ...)
					local x = loadstring( "return _G['"..object.label:GetName().."']:"..funcName.."(...)")
					return x(...)
				end
			end
		end
	end

	LabelObject.label:SetText(text)

	if (color) then
		local r, g, b, a = DF:ParseColors(color)
		LabelObject.label:SetTextColor(r, g, b, a)
	end

	if (size and type(size) == "number") then
		DF:SetFontSize(LabelObject.label, size)
	end

	LabelObject.HookList = {
	}

	LabelObject.label:SetJustifyH("LEFT")

	setmetatable(LabelObject, LabelMetaFunctions)

	--if template has been passed as the third parameter
	if (size and type(size) == "table") then
		LabelObject:SetTemplate(size)
	end

	return LabelObject
end
