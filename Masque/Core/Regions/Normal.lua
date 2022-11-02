--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For bug reports,
	suggestions and license information, please visit https://github.com/SFX-WoW/Masque.

	* File...: Core\Regions\Normal.lua
	* Author.: StormFX

	'Normal' Region

	* See Skins\Default.lua for region defaults.

]]

local _, Core = ...

----------------------------------------
-- Lua API
---

local error, type = error, type

----------------------------------------
-- WoW API
---

local hooksecurefunc, random = hooksecurefunc, random

----------------------------------------
-- Internal
---

-- @ Skins\Default
local Default = Core.DEFAULT_SKIN.Normal

-- @ Core\Utility
local GetColor, GetSize, GetTexCoords = Core.GetColor, Core.GetSize, Core.GetTexCoords
local GetTypeSkin, SetPoints = Core.GetTypeSkin, Core.SetPoints

----------------------------------------
-- Locals
---

local DEF_ATLAS = Default.Atlas
local DEF_COLOR = Default.Color
local DEF_TEXTURE = Default.Texture
local DEF_USESIZE = Default.UseAtlasSize

----------------------------------------
-- UpdateNormal
---

-- Updates the 'Normal' texture of a region.
local function UpdateNormal(Button, IsEmpty)
	IsEmpty = IsEmpty or Button.__MSQ_Empty

	local Region = Button.__MSQ_Normal
	local Skin = Button.__MSQ_NormalSkin

	if Region and (Skin and not Skin.Hide) then
		local Atlas = Skin.Atlas
		local Texture = Button.__MSQ_Random or Skin.Texture
		local Color = Button.__MSQ_NormalColor or DEF_COLOR
		local UseEmpty = Button.__MSQ_EmptyType and IsEmpty
		local Coords

		Color = (UseEmpty and Skin.EmptyColor) or Color

		if Atlas then
			Atlas = (UseEmpty and Skin.EmptyAtlas) or Atlas
			Region:SetAtlas(Atlas, Skin.UseAtlasSize)
		elseif Texture then
			Texture = (UseEmpty and Skin.EmptyTexture) or Texture
			Coords = (UseEmpty and Skin.EmptyCoords) or Skin.TexCoords
			Region:SetTexture(Texture)
		elseif DEF_ATLAS then
			Region:SetAtlas(DEF_ATLAS, DEF_USESIZE)
		elseif DEF_TEXTURE then
			Coords = Default.TexCoords
			Region:SetTexture(DEF_TEXTURE)
		end

		Region:SetTexCoord(GetTexCoords(Coords))
		Region:SetVertexColor(GetColor(Color))
	end
end

----------------------------------------
-- Hook
---

-- Counters changes to a button's 'Normal' Texture or Atlas.
-- * The behavior of changing the texture when a button is empty is only used
--   by Classic UI in the case of Pet buttons. Some add-ons still use this
--   behavior for other button types, so it needs to be countered.
-- * In Dragonflight, the UpdateButtonArt method swaps the `Normal` Atlas for one with
--   Edit Mode indicators, so we need to counter that, too.
-- * See `UpdateNormal` above.
local function Hook_SetNormal(Button, Texture)
	local Skin = Button.__MSQ_NormalSkin
	if not Skin then return end

	local Region = Button.__MSQ_Normal
	local Normal = Button:GetNormalTexture()

	-- Hide the original texture if using a custom texture.
	if Normal and Normal ~= Region then
		Normal:SetTexture()
		Normal:Hide()
	end

	-- Counter changes to the region being hidden.
	if Skin.Hide then
		Region:SetTexture()
		Region:Hide()
	end

	UpdateNormal(Button)
end

----------------------------------------
-- Core
---

-- Skins the `Normal` layer of a button and sets up any necessary hooks.
function Core.SkinNormal(Region, Button, Skin, Color, xScale, yScale)
	local IsButton = Button.GetNormalTexture
	local Custom = Button.__MSQ_NewNormal
	local Normal = IsButton and Button:GetNormalTexture()

	-- Catch add-ons using a custom `Normal` texture.
	if (Region and Normal) and Region ~= Normal then
		Normal:SetTexture()
		Normal:Hide()
	else
		Region = Region or Normal
	end

	-- States Enabled
	if Skin.UseStates then
		if Custom then
			Custom:SetTexture()
			Custom:Hide()
		end

		if not Region then return end

	-- States Disabled
	else
		if Region then
			-- Fix for BT4's Pet buttons.
			Region:SetAlpha(0)
			Region:SetTexture()
			Region:Hide()
		end

		Region = Custom or Button:CreateTexture()
		Button.__MSQ_NewNormal = Region
	end

	Skin = GetTypeSkin(Button, Button.__MSQ_bType, Skin)
	Button.__MSQ_Normal = Region
	Button.__MSQ_NormalSkin = Skin
	Button.__MSQ_NormalColor = Color or Skin.Color or DEF_COLOR

	if Skin.Hide then
		if Region then
			Region:SetTexture()
			Region:Hide()
		end
		return
	end

	local Textures = Skin.Textures
	local Random

	if type(Textures) == "table" and #Textures > 0 then
		local i = random(1, #Textures)
		Random = Textures[i]
	end

	Button.__MSQ_Random = Random

	-- Counter the BT4 fix above.
	Region:SetAlpha(1)
	UpdateNormal(Button)

	if not Button.__MSQ_Enabled then
		Button.__MSQ_Normal = nil
		Button.__MSQ_NormalSkin = nil
		Button.__MSQ_NormalColor = nil
		Button.__MSQ_Random = nil
	end

	Region:SetBlendMode(Skin.BlendMode or "BLEND")
	Region:SetDrawLayer(Skin.DrawLayer or "ARTWORK", Skin.DrawLevel or 0)

	if not Skin.UseAtlasSize then
		Region:SetSize(GetSize(Skin.Width, Skin.Height, xScale, yScale, Button))
	end

	SetPoints(Region, Button, Skin, nil, Skin.SetAllPoints)
	Region:Show()

	if IsButton and Button.__MSQ_EmptyType and not Button.__MSQ_NormalHook then
		hooksecurefunc(Button, "SetNormalAtlas", Hook_SetNormal)
		hooksecurefunc(Button, "SetNormalTexture", Hook_SetNormal)
		Button.__MSQ_NormalHook = true
	end
end

----------------------------------------
-- Core
---

-- Sets the color of the 'Normal' region.
function Core.SetNormalColor(Region, Button, Skin, Color)
	Region = Region or Button.__MSQ_Normal

	if Region then
		Skin = GetTypeSkin(Button, Button.__MSQ_bType, Skin)
		Button.__MSQ_NormalColor = Color or Skin.Color or DEF_COLOR
		UpdateNormal(Button)
	end
end

Core.UpdateNormal = UpdateNormal

----------------------------------------
-- API
---

-- Retrieves the 'Normal' region of a button.
function Core.API:GetNormal(Button)
	if type(Button) ~= "table" then
		if Core.db.profile.Debug then
			error("Bad argument to API method 'GetNormal'. 'Button' must be a button object.", 2)
		end
		return
	end

	return Button.__MSQ_Normal or Button:GetNormalTexture()
end
