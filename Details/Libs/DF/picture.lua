
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
local APIImageFunctions = false

do
	local metaPrototype = {
		WidgetType = "image",
		SetHook = DF.SetHook,
		RunHooksForWidget = DF.RunHooksForWidget,

		dversion = DF.dversion,
	}

	--check if there's a metaPrototype already existing
	if (_G[DF.GlobalWidgetControlNames["image"]]) then
		--get the already existing metaPrototype
		local oldMetaPrototype = _G[DF.GlobalWidgetControlNames ["image"]]
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
		_G[DF.GlobalWidgetControlNames ["image"]] = metaPrototype
	end
end

local ImageMetaFunctions = _G[DF.GlobalWidgetControlNames ["image"]]

------------------------------------------------------------------------------------------------------------
--> metatables

	ImageMetaFunctions.__call = function (_table, value)
		return self.image:SetTexture (value)
	end
	
------------------------------------------------------------------------------------------------------------
--> members

	--> shown
	local gmember_shown = function (_object)
		return _object:IsShown()
	end
	--> frame width
	local gmember_width = function (_object)
		return _object.image:GetWidth()
	end
	--> frame height
	local gmember_height = function (_object)
		return _object.image:GetHeight()
	end
	--> texture
	local gmember_texture = function (_object)
		return _object.image:GetTexture()
	end
	--> alpha
	local gmember_alpha = function (_object)
		return _object.image:GetAlpha()
	end

	ImageMetaFunctions.GetMembers = ImageMetaFunctions.GetMembers or {}
	ImageMetaFunctions.GetMembers ["shown"] = gmember_shown
	ImageMetaFunctions.GetMembers ["alpha"] = gmember_alpha
	ImageMetaFunctions.GetMembers ["width"] = gmember_width
	ImageMetaFunctions.GetMembers ["height"] = gmember_height
	ImageMetaFunctions.GetMembers ["texture"] = gmember_texture

	ImageMetaFunctions.__index = function (_table, _member_requested)

		local func = ImageMetaFunctions.GetMembers [_member_requested]
		if (func) then
			return func (_table, _member_requested)
		end
		
		local fromMe = _rawget (_table, _member_requested)
		if (fromMe) then
			return fromMe
		end
		
		return ImageMetaFunctions [_member_requested]
	end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
	--> texture
	local smember_texture = function (_object, _value)
		if (type (_value) == "table") then
			local r, g, b, a = DF:ParseColors (_value)
			_object.image:SetTexture (r, g, b, a or 1)
		else
			if (DF:IsHtmlColor (_value)) then
				local r, g, b, a = DF:ParseColors (_value)
				_object.image:SetTexture (r, g, b, a or 1)
			else
				_object.image:SetTexture (_value)
			end
		end
	end
	--> width
	local smember_width = function (_object, _value)
		return _object.image:SetWidth (_value)
	end
	--> height
	local smember_height = function (_object, _value)
		return _object.image:SetHeight (_value)
	end
	--> alpha
	local smember_alpha = function (_object, _value)
		return _object.image:SetAlpha (_value)
	end	
	--> color
	local smember_color = function (_object, _value)
		local r, g, b, a = DF:ParseColors (_value)
		_object.image:SetColorTexture (r, g, b, a or 1)
	end
	--> vertex color
	local smember_vertexcolor = function (_object, _value)
		local r, g, b, a = DF:ParseColors (_value)
		_object.image:SetVertexColor (r, g, b, a or 1)
	end	
	--> desaturated
	local smember_desaturated = function (_object, _value)
		if (_value) then
			_object:SetDesaturated (true)
		else
			_object:SetDesaturated (false)
		end
	end
	--> texcoords
	local smember_texcoord = function (_object, _value)
		if (_value) then
			_object:SetTexCoord (unpack (_value))
		else
			_object:SetTexCoord (0, 1, 0, 1)
		end
	end

	ImageMetaFunctions.SetMembers = ImageMetaFunctions.SetMembers or {}
	ImageMetaFunctions.SetMembers ["show"] = smember_show
	ImageMetaFunctions.SetMembers ["hide"] = smember_hide
	ImageMetaFunctions.SetMembers ["alpha"] = smember_alpha
	ImageMetaFunctions.SetMembers ["width"] = smember_width
	ImageMetaFunctions.SetMembers ["height"] = smember_height
	ImageMetaFunctions.SetMembers ["texture"] = smember_texture
	ImageMetaFunctions.SetMembers ["texcoord"] = smember_texcoord
	ImageMetaFunctions.SetMembers ["color"] = smember_color
	ImageMetaFunctions.SetMembers ["vertexcolor"] = smember_vertexcolor
	ImageMetaFunctions.SetMembers ["blackwhite"] = smember_desaturated

	ImageMetaFunctions.__newindex = function (_table, _key, _value)
		local func = ImageMetaFunctions.SetMembers [_key]
		if (func) then
			return func (_table, _value)
		else
			return _rawset (_table, _key, _value)
		end
	end
	
------------------------------------------------------------------------------------------------------------
--> methods
--> show & hide
	function ImageMetaFunctions:IsShown()
		return self.image:IsShown()
	end
	function ImageMetaFunctions:Show()
		return self.image:Show()
	end
	function ImageMetaFunctions:Hide()
		return self.image:Hide()
	end
	
-- setpoint
	function ImageMetaFunctions:SetPoint (v1, v2, v3, v4, v5)
		v1, v2, v3, v4, v5 = DF:CheckPoints (v1, v2, v3, v4, v5, self)
		if (not v1) then
			print ("Invalid parameter for SetPoint")
			return
		end
		return self.widget:SetPoint (v1, v2, v3, v4, v5)
	end

-- sizes
	function ImageMetaFunctions:SetSize (w, h)
		if (w) then
			self.image:SetWidth (w)
		end
		if (h) then
			return self.image:SetHeight (h)
		end
	end
	
------------------------------------------------------------------------------------------------------------
--> scripts

------------------------------------------------------------------------------------------------------------
--> object constructor

function DF:CreateImage (parent, texture, w, h, layer, coords, member, name)
	return DF:NewImage (parent, texture, w, h, layer, coords, member, name)
end

function DF:NewImage (parent, texture, w, h, layer, coords, member, name)

	if (not parent) then
		return error ("Details! FrameWork: parent not found.", 2)
	end
	
	if (not name) then
		name = "DetailsFrameworkPictureNumber" .. DF.PictureNameCounter
		DF.PictureNameCounter = DF.PictureNameCounter + 1
	end
	
	if (name:find ("$parent")) then
		local parentName = DF.GetParentName (parent)
		name = name:gsub ("$parent", parentName)
	end
	
	local ImageObject = {type = "image", dframework = true}

	if (member) then
		parent [member] = ImageObject
	end
	
	if (parent.dframework) then
		parent = parent.widget
	end

	texture = texture or ""
	
	ImageObject.image = parent:CreateTexture (name, layer or "OVERLAY")
	ImageObject.widget = ImageObject.image
	DF:Mixin (ImageObject.image, DF.WidgetFunctions)
	
	if (not APIImageFunctions) then
		APIImageFunctions = true
		local idx = getmetatable (ImageObject.image).__index
		for funcName, funcAddress in pairs (idx) do 
			if (not ImageMetaFunctions [funcName]) then
				ImageMetaFunctions [funcName] = function (object, ...)
					local x = loadstring ( "return _G['"..object.image:GetName().."']:"..funcName.."(...)")
					return x (...)
				end
			end
		end
	end	
	
	ImageObject.image.MyObject = ImageObject

	if (w) then
		ImageObject.image:SetWidth (w)
	end
	if (h) then
		ImageObject.image:SetHeight (h)
	end
	if (texture) then
		if (type (texture) == "table") then
			local r, g, b = DF:ParseColors (texture)
			ImageObject.image:SetTexture (r,g,b)
		else
			if (DF:IsHtmlColor (texture)) then
				local r, g, b = DF:ParseColors (texture)
				ImageObject.image:SetTexture (r, g, b)
			else
				ImageObject.image:SetTexture (texture)
			end
		end
	end
	
	if (coords and type (coords) == "table" and coords [4]) then
		ImageObject.image:SetTexCoord (unpack (coords))
	end
	
	ImageObject.HookList = {
	}
	
	setmetatable (ImageObject, ImageMetaFunctions)
	
	return ImageObject
end
