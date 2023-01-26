--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For bug reports,
	suggestions and license information, please visit https://github.com/SFX-WoW/Masque.

	* File...: Skins\Skins.lua
	* Author.: StormFX, JJSheets

	Skin API

]]

local _, Core = ...

----------------------------------------
-- Lua API
---

local error, setmetatable, t_insert = error, setmetatable, table.insert
local t_sort, type = table.sort, type

----------------------------------------
-- Internal
---

-- @ Skins\Regions
local Layers = Core.RegTypes.Legacy

----------------------------------------
-- Locals
---

local AddedSkins, BaseSkins = {}, {}
local Skins, SkinList, SkinOrder = {}, {}, {}
local Hidden = {Hide = true}

-- Legacy Skin IDs
local LegacyIDs = {
	["Blizzard"] = "Blizzard Classic",
	["Classic"] = "Classic Redux",
	["Default"] = "Blizzard Classic",
	["Default (Classic)"] = "Blizzard Classic",
}

-- Layers that need to be validated for older skins.
local vLayers = {
	-- Using "Shine" or "AutoCast"
	["AutoCastShine"] = function(Skin)
		return Skin.AutoCastShine or Skin.Shine or Skin.AutoCast
	end,
	-- "ChargeCoolDown" Undefined
	["ChargeCooldown"] = function(Skin)
		return Skin.ChargeCooldown or Skin.Cooldown
	end,
	-- Using Border.Debuff / "DebuffBorder" Undefined
	["DebuffBorder"] = function(Skin)
		local Border = Skin.Border
		if type(Border) == "table" then
			Border = Border.Debuff or Border
		end
		return Border
	end,
	-- Using Border.Enchant / "EnchantBorder" Undefined
	["EnchantBorder"] = function(Skin)
		local Border = Skin.Border
		if type(Border) == "table" then
			Border = Border.Enchant or Border
		end
		return Border
	end,
	-- Using Border.Item / "IconBorder" Undefined
	["IconBorder"] = function(Skin)
		local Border = Skin.Border
		if type(Border) == "table" then
			Border = Border.Item or Border
		end
		return Border
	end,
}

----------------------------------------
-- Functions
---

-- Returns a valid shape.
local function GetShape(Shape)
	if type(Shape) ~= "string" then
		Shape = "Square"
	end
	return Shape
end

-- Returns the ID of a renamed skin.
local function GetSkinID(SkinID)
	return LegacyIDs[SkinID]
end

-- Sorts the `SkinOrder` table, for display in drop-downs.
local function SortSkins()
	t_sort(AddedSkins)

	local c = #BaseSkins

	for k, v in ipairs(AddedSkins) do
		SkinOrder[k + c] = v
	end
end

-- Adds data to the skin tables.
local function AddSkin(SkinID, SkinData, Base)
	-- Legacy Layer Validation
	for Layer, GetLayer in pairs(vLayers) do
		if not SkinData[Layer] then
			SkinData[Layer] = GetLayer(SkinData)
		end
	end

	local Skin_API = SkinData.API_VERSION or SkinData.Masque_Version
	local Template = SkinData.Template

	if Template then
		-- Only do this for skins using "Default" to reference "Blizzard Modern".
		if Skin_API == 100000 and Template == "Default" then
			Template = "Blizzard Modern"
		end

		setmetatable(SkinData, {__index = Skins[Template]})
	end

	local Default = Core.DEFAULT_SKIN

	for Layer, Info in pairs(Layers) do
		local Skin = SkinData[Layer]
		local sType = type(Skin)

		if sType == "string" then
			Skin = SkinData[Skin]
		elseif (sType ~= "table") or (Skin.Hide and not Info.CanHide) then
			Skin = Default[Layer]
		elseif Info.Hide then
			Skin = Hidden
		end

		SkinData[Layer] = Skin
	end

	SkinData.SkinID = SkinID
	SkinData.API_VERSION = Skin_API

	local Shape = SkinData.Shape
	SkinData.Shape = GetShape(Shape)

	Skins[SkinID] = SkinData

	if not SkinData.Disable then
		if Base then
			t_insert(BaseSkins, SkinID)
			t_insert(SkinOrder, SkinID)
		else
			t_insert(AddedSkins, SkinID)
			SortSkins()
		end

		SkinList[SkinID] = SkinID
	end
end

----------------------------------------
-- Core
---

Core.__Hidden = Hidden
Core.AddSkin = AddSkin
Core.GetSkinID = GetSkinID

Core.Skins = setmetatable(Skins, {
	__index = function(self, SkinID)
		local NewID = GetSkinID(SkinID)

		if NewID then
			return self[NewID]
		end
	end
})

Core.SkinList = SkinList
Core.SkinOrder = SkinOrder

----------------------------------------
-- API
---

local API = Core.API

-- Wrapper for the AddSkin function.
function API:AddSkin(SkinID, SkinData, Replace)
	local Debug = Core.Debug

	if type(SkinID) ~= "string" then
		if Debug then
			error("Bad argument to API method 'AddSkin'. 'SkinID' must be a string.", 2)
		end
		return
	end

	if Skins[SkinID] then return end

	if type(SkinData) ~= "table" then
		if Debug then
			error("Bad argument to API method 'AddSkin'. 'SkinData' must be a table.", 2)
		end
		return
	end

	local Template = SkinData.Template

	if Template then
		if type(Template) ~= "string" then
			if Debug then
				error(("Invalid template reference by skin '%s'. 'Template' must be a string."):format(SkinID), 2)
			end
			return
		end

		local Parent = Skins[Template]

		if type(Parent) ~= "table"  then
			if Debug then
				error(("Invalid template reference by skin '%s'. Template '%s' does not exist or is not a table."):format(SkinID, Template), 2)
			end
			return
		end
	end

	AddSkin(SkinID, SkinData)
end

-- Retrieves the default skin.
function API:GetDefaultSkin()
	return Core.DEFAULT_SKIN_ID, Core.DEFAULT_SKIN
end

-- Retrieves the skin data for the specified skin.
function API:GetSkin(SkinID)
	return SkinID and Skins[SkinID]
end

-- Retrieves the Skins table.
function API:GetSkins()
	return Skins
end
