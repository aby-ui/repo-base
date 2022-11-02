--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For bug reports,
	suggestions and license information, please visit https://github.com/SFX-WoW/Masque.

	* File...: Core\Regions\NewItem.lua
	* Author.: StormFX

	'NewItem' Region

	* See Skins\Default.lua for region defaults.

]]

local _, Core = ...

----------------------------------------
-- WoW API
---

local hooksecurefunc = hooksecurefunc

----------------------------------------
-- Internal
---

-- @ Skins\Default
local Default = Core.DEFAULT_SKIN.NewItem

-- @ Core\Utility
local GetColor, GetSize, GetTexCoords = Core.GetColor, Core.GetSize, Core.GetTexCoords
local GetTypeSkin, SetPoints = Core.GetTypeSkin, Core.SetPoints

----------------------------------------
-- Locals
---

local DEF_ATLAS, DEF_COLOR = Default.Atlas, Default.Color

local Colors = {
	["bags-glow-white"] = {1, 1, 1, 1},
	["bags-glow-green"] = {0.12, 1, 0, 1},
	["bags-glow-blue"] = {0, 0.44, 0.87, 1},
	["bags-glow-purple"] = {0.64, 0.21, 0.93, 1},
	["bags-glow-orange"] = {1, 0.5, 0, 1},
	["bags-glow-artifact"] = {0.9, 0.8, 0.5, 1},
	["bags-glow-heirloom"] = {0, 0.8, 1, 1},
}

----------------------------------------
-- Hook
---

-- Counters atlas changes when using a static skin texture.
local function Hook_SetAtlas(Region, Atlas, UseAtlasSize)
	if Region.__ExitHook or not Region.__MSQ_Skin then
		return
	end

	Atlas = Atlas or DEF_ATLAS
	Region.__MSQ_Atlas = Atlas

	local Skin = Region.__MSQ_Skin
	local SkinAtlas = Skin.Atlas
	local Texture = Skin.Texture
	local Coords

	if SkinAtlas then
		Region.__ExitHook = true
		Region:SetAtlas(SkinAtlas, Skin.UseAtlasSize)
		Region.__ExitHook = nil
	elseif Texture then
		Coords = Skin.TexCoords
		Region:SetTexture(Texture)
	end

	Region:SetTexCoord(GetTexCoords(Coords))
	Region:SetVertexColor(GetColor(Colors[Atlas]))
end

----------------------------------------
-- Core
---

-- Skins the 'NewItem' region of a button.
function Core.SkinNewItem(Region, Button, Skin, xScale, yScale)
	Skin = GetTypeSkin(Button, Button.__MSQ_bType, Skin)

	local Atlas = Region.__MSQ_Atlas or Region:GetAtlas() or DEF_ATLAS
	Region.__MSQ_Atlas = Atlas
	Region.__MSQ_Skin = Skin

	local SkinAtlas = Skin.Atlas
	local UseAtlasSize = Skin.UseAtlasSize
	local Texture = Skin.Texture
	local Coords

	if SkinAtlas then
		Hook_SetAtlas(Region, Atlas)
	elseif Texture then
		Coords = Skin.TexCoords
		Region:SetTexture(Texture)
		Region:SetVertexColor(GetColor(Colors[Atlas]))
	else
		Region.__MSQ_Skin = nil

		UseAtlasSize = Default.UseAtlasSize
		Region:SetAtlas(Atlas, UseAtlasSize)
		Region:SetVertexColor(GetColor(DEF_COLOR))
	end

	Region:SetTexCoord(GetTexCoords(Coords))
	Region:SetBlendMode(Skin.BlendMode or "ADD")
	Region:SetDrawLayer(Skin.DrawLayer or "OVERLAY", Skin.DrawLevel or 2)

	if not UseAtlasSize then
		Region:SetSize(GetSize(Skin.Width, Skin.Height, xScale, yScale))
	end

	SetPoints(Region, Button, Skin, nil, Skin.SetAllPoints)

	-- Hook
	if not Region.__MSQ_Hooked then
		hooksecurefunc(Region, "SetAtlas", Hook_SetAtlas)
		Region.__MSQ_Hooked = true
	end
end
