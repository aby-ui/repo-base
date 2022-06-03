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
local Default = Core.Skins.Default.NewItem

-- @ Core\Utility
local GetColor, GetSize = Core.GetColor, Core.GetSize
local GetTexCoords, SetPoints = Core.GetTexCoords, Core.SetPoints

----------------------------------------
-- Locals
---

local DEF_ATLAS = Default.Atlas

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
local function Hook_SetAtlas(Region, Atlas)
	if not Region.__MSQ_Skin then return end

	Atlas = Atlas or DEF_ATLAS
	Region.__MSQ_Atlas = Atlas

	local Skin = Region.__MSQ_Skin

	Region:SetTexture(Skin.Texture)
	Region:SetTexCoord(GetTexCoords(Skin.TexCoords))
	Region:SetVertexColor(GetColor(Colors[Atlas]))
end

----------------------------------------
-- Core
---

-- Skins the 'NewItem' region of a button.
function Core.SkinNewItem(Region, Button, Skin, xScale, yScale)
	local Atlas = Region.__MSQ_Atlas or Region:GetAtlas() or DEF_ATLAS
	local Texture = Skin.Texture

	if Texture then
		Region.__MSQ_Skin = Skin
		Region.__MSQ_Atlas = Atlas

		Region:SetTexture(Texture)
		Region:SetTexCoord(GetTexCoords(Skin.TexCoords))
		Region:SetVertexColor(GetColor(Colors[Atlas]))

		if not Region.__MSQ_Hooked then
			hooksecurefunc(Region, "SetAtlas", Hook_SetAtlas)
			Region.__MSQ_Hooked = true
		end
	else
		Region.__MSQ_Skin = nil
		Region.__MSQ_Atlas = nil

		Region:SetAtlas(Atlas)
		Region:SetVertexColor(1, 1, 1, 1)
	end

	Region:SetBlendMode(Skin.BlendMode or "ADD")
	Region:SetDrawLayer(Skin.DrawLayer or "OVERLAY", Skin.DrawLevel or 2)
	Region:SetSize(GetSize(Skin.Width, Skin.Height, xScale, yScale))
	SetPoints(Region, Button, Skin, nil, Skin.SetAllPoints)
end
