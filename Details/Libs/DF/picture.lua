
local detailsFramework = _G["DetailsFramework"]
if (not detailsFramework or not DetailsFrameworkCanLoad) then
	return
end

local _
local APIImageFunctions = false

do
	local metaPrototype = {
		WidgetType = "image",
		dversion = detailsFramework.dversion,
	}

	--check if there's a metaPrototype already existing
	if (_G[detailsFramework.GlobalWidgetControlNames["image"]]) then
		--get the already existing metaPrototype
		local oldMetaPrototype = _G[detailsFramework.GlobalWidgetControlNames["image"]]
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
		_G[detailsFramework.GlobalWidgetControlNames["image"]] = metaPrototype
	end
end

local ImageMetaFunctions = _G[detailsFramework.GlobalWidgetControlNames["image"]]

detailsFramework:Mixin(ImageMetaFunctions, detailsFramework.SetPointMixin)
detailsFramework:Mixin(ImageMetaFunctions, detailsFramework.ScriptHookMixin)

------------------------------------------------------------------------------------------------------------
--metatables

	ImageMetaFunctions.__call = function(object, value)
		return object.image:SetTexture(value)
	end

------------------------------------------------------------------------------------------------------------
--members

	--frame width
	local gmember_width = function(object)
		return object.image:GetWidth()
	end

	--frame height
	local gmember_height = function(object)
		return object.image:GetHeight()
	end

	--texture
	local gmember_texture = function(object)
		return object.image:GetTexture()
	end

	--alpha
	local gmember_alpha = function(object)
		return object.image:GetAlpha()
	end

	--saturation
	local gmember_saturation = function(object)
		return object.image:GetDesaturated()
	end

	--atlas
	local gmember_atlas = function(object)
		return object.image:GetAtlas()
	end

	--texcoords
	local gmember_texcoord = function(object)
		return object.image:GetTexCoord()
	end

	ImageMetaFunctions.GetMembers = ImageMetaFunctions.GetMembers or {}
	detailsFramework:Mixin(ImageMetaFunctions.GetMembers, detailsFramework.DefaultMetaFunctionsGet)
	detailsFramework:Mixin(ImageMetaFunctions.GetMembers, detailsFramework.LayeredRegionMetaFunctionsGet)

	ImageMetaFunctions.GetMembers["alpha"] = gmember_alpha
	ImageMetaFunctions.GetMembers["width"] = gmember_width
	ImageMetaFunctions.GetMembers["height"] = gmember_height
	ImageMetaFunctions.GetMembers["texture"] = gmember_texture
	ImageMetaFunctions.GetMembers["blackwhite"] = gmember_saturation
	ImageMetaFunctions.GetMembers["desaturated"] = gmember_saturation
	ImageMetaFunctions.GetMembers["atlas"] = gmember_atlas
	ImageMetaFunctions.GetMembers["texcoord"] = gmember_texcoord

	ImageMetaFunctions.__index = function(object, key)
		local func = ImageMetaFunctions.GetMembers[key]
		if (func) then
			return func(object, key)
		end

		local fromMe = rawget(object, key)
		if (fromMe) then
			return fromMe
		end

		return ImageMetaFunctions[key]
	end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	--texture
	local smember_texture = function(object, value)
		if (type(value) == "table") then
			local red, green, blue, alpha = detailsFramework:ParseColors(value)
			object.image:SetTexture(red, green, blue, alpha)
		else
			if (detailsFramework:IsHtmlColor(value)) then
				local red, green, blue, alpha = detailsFramework:ParseColors(value)
				object.image:SetTexture(red, green, blue, alpha)
			else
				object.image:SetTexture(value)
			end
		end
	end

	--width
	local smember_width = function(object, value)
		return object.image:SetWidth(value)
	end

	--height
	local smember_height = function(object, value)
		return object.image:SetHeight(value)
	end

	--alpha
	local smember_alpha = function(object, value)
		return object.image:SetAlpha(value)
	end

	--color
	local smember_color = function(object, value)
		local red, green, blue, alpha = detailsFramework:ParseColors(value)
		object.image:SetColorTexture(red, green, blue, alpha)
	end

	--vertex color
	local smember_vertexcolor = function(object, value)
		local red, green, blue, alpha = detailsFramework:ParseColors(value)
		object.image:SetVertexColor(red, green, blue, alpha)
	end

	--desaturated
	local smember_desaturated = function(object, value)
		if (value) then
			object:SetDesaturated(true)
		else
			object:SetDesaturated(false)
		end
	end

	--texcoords
	local smember_texcoord = function(object, value)
		if (value) then
			object:SetTexCoord(unpack(value))
		else
			object:SetTexCoord(0, 1, 0, 1)
		end
	end

	--atlas
	local smember_atlas = function(object, value)
		if (value) then
			object:SetAtlas(value)
		end
	end

	--gradient
	local smember_gradient = function(object, value)
		if (type(value) == "table" and value.gradient and value.fromColor and value.toColor) then
			object.image:SetColorTexture(1, 1, 1, 1)
			local fromColor = detailsFramework:FormatColor("tablemembers", value.fromColor)
			local toColor = detailsFramework:FormatColor("tablemembers", value.toColor)
			object.image:SetGradient(value.gradient, fromColor, toColor)
		else
			error("texture.gradient expect a table{gradient = 'gradient type', fromColor = 'color', toColor = 'color'}")
		end
	end

	ImageMetaFunctions.SetMembers = ImageMetaFunctions.SetMembers or {}
	detailsFramework:Mixin(ImageMetaFunctions.SetMembers, detailsFramework.DefaultMetaFunctionsSet)
	detailsFramework:Mixin(ImageMetaFunctions.SetMembers, detailsFramework.LayeredRegionMetaFunctionsSet)

	ImageMetaFunctions.SetMembers["alpha"] = smember_alpha
	ImageMetaFunctions.SetMembers["width"] = smember_width
	ImageMetaFunctions.SetMembers["height"] = smember_height
	ImageMetaFunctions.SetMembers["texture"] = smember_texture
	ImageMetaFunctions.SetMembers["texcoord"] = smember_texcoord
	ImageMetaFunctions.SetMembers["color"] = smember_color
	ImageMetaFunctions.SetMembers["vertexcolor"] = smember_vertexcolor
	ImageMetaFunctions.SetMembers["blackwhite"] = smember_desaturated
	ImageMetaFunctions.SetMembers["desaturated"] = smember_desaturated
	ImageMetaFunctions.SetMembers["atlas"] = smember_atlas
	ImageMetaFunctions.SetMembers["gradient"] = smember_gradient

	ImageMetaFunctions.__newindex = function(object, key, value)
		local func = ImageMetaFunctions.SetMembers[key]
		if (func) then
			return func(object, value)
		else
			return rawset(object, key, value)
		end
	end

------------------------------------------------------------------------------------------------------------
--methods
	--size
	function ImageMetaFunctions:SetSize(width, height)
		if (width) then
			self.image:SetWidth(width)
		end
		if (height) then
			return self.image:SetHeight(height)
		end
	end

	function ImageMetaFunctions:SetGradient(gradientType, fromColor, toColor)
		fromColor = detailsFramework:FormatColor("tablemembers", fromColor)
		toColor = detailsFramework:FormatColor("tablemembers", toColor)
		self.image:SetGradient(gradientType, fromColor, toColor)
	end

------------------------------------------------------------------------------------------------------------
--object constructor

	function detailsFramework:CreateTexture(parent, texture, width, height, layer, coords, member, name)
		return detailsFramework:NewImage(parent, texture, width, height, layer, coords, member, name)
	end

	function detailsFramework:CreateImage(parent, texture, width, height, layer, coords, member, name)
		return detailsFramework:NewImage(parent, texture, width, height, layer, coords, member, name)
	end

	function detailsFramework:NewImage(parent, texture, width, height, layer, texCoord, member, name)
		if (not parent) then
			return error("DetailsFrameWork: NewImage() parent not found.", 2)
		end

		if (not name) then
			name = "DetailsFrameworkPictureNumber" .. detailsFramework.PictureNameCounter
			detailsFramework.PictureNameCounter = detailsFramework.PictureNameCounter + 1
		end

		if (name:find("$parent")) then
			local parentName = detailsFramework.GetParentName(parent)
			name = name:gsub("$parent", parentName)
		end

		local ImageObject = {type = "image", dframework = true}

		if (member) then
			parent[member] = ImageObject
		end

		if (parent.dframework) then
			parent = parent.widget
		end

		texture = texture or ""

		ImageObject.image = parent:CreateTexture(name, layer or "overlay")
		ImageObject.widget = ImageObject.image

		detailsFramework:Mixin(ImageObject.image, detailsFramework.WidgetFunctions)

		if (not APIImageFunctions) then
			APIImageFunctions = true
			local idx = getmetatable(ImageObject.image).__index
			for funcName, funcAddress in pairs(idx) do
				if (not ImageMetaFunctions[funcName]) then
					ImageMetaFunctions[funcName] = function(object, ...)
						local x = loadstring( "return _G['" .. object.image:GetName() .. "']:" .. funcName .. "(...)")
						return x(...)
					end
				end
			end
		end

		ImageObject.image.MyObject = ImageObject

		if (width) then
			ImageObject.image:SetWidth(width)
		end
		if (height) then
			ImageObject.image:SetHeight(height)
		end

		if (texture) then
			if (type(texture) == "table") then
				if (texture.gradient) then
					if (detailsFramework.IsDragonflight() or detailsFramework.IsWotLKWowWithRetailAPI()) then
						ImageObject.image:SetColorTexture(1, 1, 1, 1)
						local fromColor = detailsFramework:FormatColor("tablemembers", texture.fromColor)
						local toColor = detailsFramework:FormatColor("tablemembers", texture.toColor)
						ImageObject.image:SetGradient(texture.gradient, fromColor, toColor)
					else
						local fromR, fromG, fromB, fromA = detailsFramework:ParseColors(texture.fromColor)
						local toR, toG, toB, toA = detailsFramework:ParseColors(texture.toColor)
						ImageObject.image:SetColorTexture(1, 1, 1, 1)
						ImageObject.image:SetGradientAlpha(texture.gradient, fromR, fromG, fromB, fromA, toR, toG, toB, toA)
					end
				else
					local r, g, b, a = detailsFramework:ParseColors(texture)
					ImageObject.image:SetColorTexture(r, g, b, a)
				end

			elseif (type(texture) == "string") then
				local isAtlas = C_Texture.GetAtlasInfo(texture)
				if (isAtlas) then
					ImageObject.image:SetAtlas(texture)
				else
					if (detailsFramework:IsHtmlColor(texture)) then
						local r, g, b = detailsFramework:ParseColors(texture)
						ImageObject.image:SetColorTexture(r, g, b)
					else
						ImageObject.image:SetTexture(texture)
					end
				end
			else
				ImageObject.image:SetTexture(texture)
			end
		end

		if (texCoord and type(texCoord) == "table" and texCoord[4]) then
			ImageObject.image:SetTexCoord(unpack(texCoord))
		end

		ImageObject.HookList = {
		}

		setmetatable(ImageObject, ImageMetaFunctions)

		return ImageObject
	end
