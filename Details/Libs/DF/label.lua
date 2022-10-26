
local detailsFramework = _G["DetailsFramework"]
if (not detailsFramework or not DetailsFrameworkCanLoad) then
	return
end

local _
local loadedAPILabelFunctions = false

do
	local metaPrototype = {
		WidgetType = "label",
		dversion = detailsFramework.dversion,
	}

	--check if there's a metaPrototype already existing
	if (_G[detailsFramework.GlobalWidgetControlNames["label"]]) then
		--get the already existing metaPrototype
		local oldMetaPrototype = _G[detailsFramework.GlobalWidgetControlNames ["label"]]
		--check if is older
		if ( (not oldMetaPrototype.dversion) or (oldMetaPrototype.dversion < detailsFramework.dversion) ) then
			--the version is older them the currently loading one
			--copy the new values into the old metatable
			for funcName, _ in pairs(metaPrototype) do
				oldMetaPrototype[funcName] = metaPrototype[funcName]
			end
		end
	else
		--first time loading the framework
		_G[detailsFramework.GlobalWidgetControlNames ["label"]] = metaPrototype
	end
end

local LabelMetaFunctions = _G[detailsFramework.GlobalWidgetControlNames ["label"]]

detailsFramework:Mixin(LabelMetaFunctions, detailsFramework.SetPointMixin)
detailsFramework:Mixin(LabelMetaFunctions, detailsFramework.ScriptHookMixin)

------------------------------------------------------------------------------------------------------------
--metatables

	LabelMetaFunctions.__call = function(object, value)
		return object.label:SetText(value)
	end

------------------------------------------------------------------------------------------------------------
--members

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
	detailsFramework:Mixin(LabelMetaFunctions.GetMembers, detailsFramework.LayeredRegionMetaFunctionsGet)
	detailsFramework:Mixin(LabelMetaFunctions.GetMembers, detailsFramework.DefaultMetaFunctionsGet)

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

	--text
	local smember_text = function(object, value)
		return object.label:SetText(value)
	end

	--text color
	local smember_textcolor = function(object, value)
		local value1, value2, value3, value4 = detailsFramework:ParseColors(value)
		return object.label:SetTextColor(value1, value2, value3, value4)
	end

	--text font
	local smember_textfont = function(object, value)
		return detailsFramework:SetFontFace(object.label, value)
	end

	--text size
	local smember_textsize = function(object, value)
		return detailsFramework:SetFontSize(object.label, value)
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
		detailsFramework:SetFontOutline(object.label, value)
	end

	--text rotation
	local smember_rotation = function(object, rotation)
		if (type(rotation) == "number") then
			if (not object.__rotationAnimation) then
				object.__rotationAnimation = detailsFramework:CreateAnimationHub(object.label)
				object.__rotationAnimation.rotator = detailsFramework:CreateAnimation(object.__rotationAnimation, "rotation", 1, 0, 0)
				object.__rotationAnimation.rotator:SetEndDelay(10^8)
				object.__rotationAnimation.rotator:SetSmoothProgress(1)
			end
			object.__rotationAnimation.rotator:SetDegrees(rotation)
			object.__rotationAnimation:Play()
			object.__rotationAnimation:Pause()
		end
	end

	LabelMetaFunctions.SetMembers = LabelMetaFunctions.SetMembers or {}
	detailsFramework:Mixin(LabelMetaFunctions.SetMembers, detailsFramework.LayeredRegionMetaFunctionsSet)
	detailsFramework:Mixin(LabelMetaFunctions.SetMembers, detailsFramework.DefaultMetaFunctionsSet)

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
	LabelMetaFunctions.SetMembers["rotation"] = smember_rotation

	LabelMetaFunctions.__newindex = function(object, key, value)
		local func = LabelMetaFunctions.SetMembers[key]
		if (func) then
			return func(object, value)
		else
			return rawset(object, key, value)
		end
	end

------------------------------------------------------------------------------------------------------------
--methods

	--text text
	function LabelMetaFunctions:SetTextTruncated(text, maxWidth)
		self.widget:SetText(text)
		detailsFramework:TruncateText(self.widget, maxWidth)
	end

	--textcolor
	function LabelMetaFunctions:SetTextColor(r, g, b, a)
		r, g, b, a = detailsFramework:ParseColors(r, g, b, a)
		return self.label:SetTextColor(r, g, b, a)
	end

------------------------------------------------------------------------------------------------------------
--template

	function LabelMetaFunctions:SetTemplate(template)
		if (template.size) then
			detailsFramework:SetFontSize(self.label, template.size)
		end
		if (template.color) then
			local r, g, b, a = detailsFramework:ParseColors(template.color)
			self:SetTextColor(r, g, b, a)
		end
		if (template.font) then
			local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
			local font = SharedMedia:Fetch("font", template.font)
			detailsFramework:SetFontFace(self.label, font)
		end
	end

------------------------------------------------------------------------------------------------------------
--object constructor

	function detailsFramework:CreateLabel(parent, text, size, color, font, member, name, layer)
		return detailsFramework:NewLabel(parent, nil, name, member, text, font, size, color, layer)
	end

	function detailsFramework:NewLabel(parent, container, name, member, text, font, size, color, layer)
		if (not parent) then
			return error("Details! Framework: parent not found.", 2)
		end
		if (not container) then
			container = parent
		end

		if (not name) then
			name = "DetailsFrameworkLabelNumber" .. detailsFramework.LabelNameCounter
			detailsFramework.LabelNameCounter = detailsFramework.LabelNameCounter + 1
		end

		if (name:find("$parent")) then
			local parentName = detailsFramework.GetParentName(parent)
			name = name:gsub("$parent", parentName)
		end

		local labelObject = {type = "label", dframework = true}

		if (member) then
			parent[member] = labelObject
		end

		if (parent.dframework) then
			parent = parent.widget
		end

		if (container.dframework) then
			container = container.widget
		end

		if (not font or font == "") then
			font = "GameFontNormal"
		end

		labelObject.label = parent:CreateFontString(name, layer or "OVERLAY", font)
		labelObject.widget = labelObject.label
		labelObject.label.MyObject = labelObject

		if (not loadedAPILabelFunctions) then
			loadedAPILabelFunctions = true
			local idx = getmetatable(labelObject.label).__index
			for funcName, funcAddress in pairs(idx) do
				if (not LabelMetaFunctions[funcName]) then
					LabelMetaFunctions[funcName] = function(object, ...)
						local x = loadstring( "return _G['"..object.label:GetName().."']:"..funcName.."(...)")
						return x(...)
					end
				end
			end
		end

		--if the text is a table, it means a language table has been passed
		if (type(text) == "table") then
			local locTable = text
			if (detailsFramework.Language.IsLocTable(locTable)) then
				detailsFramework.Language.SetTextWithLocTable(labelObject.widget, locTable)
			else
				labelObject.label:SetText(text)
			end
		else
			labelObject.label:SetText(text)
		end

		labelObject.label:SetJustifyH("left")

		if (color) then
			local r, g, b, a = detailsFramework:ParseColors(color)
			labelObject.label:SetTextColor(r, g, b, a)
		end

		if (size and type(size) == "number") then
			detailsFramework:SetFontSize(labelObject.label, size)
		end

		labelObject.HookList = {}

		setmetatable(labelObject, LabelMetaFunctions)

		--if template has been passed as the third parameter
		if (size and type(size) == "table") then
			labelObject:SetTemplate(size)
		end

		return labelObject
	end
