--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For bug reports,
	suggestions and license information, please visit https://github.com/SFX-WoW/Masque.

	* File...: Core\Regions\QuestBorder.lua
	* Author.: StormFX

	Quest Item Border Texture

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
local Default = Core.Skins.Default.QuestBorder

-- @ Core\Utility
local GetColor, GetSize = Core.GetColor, Core.GetSize
local GetTexCoords, SetPoints = Core.GetTexCoords, Core.SetPoints

----------------------------------------
-- Locals
---

local DEFAULT_TEXTURE = Default.Texture
local BORDER_TEXTURE = Default.Border

----------------------------------------
-- Hook
---

-- Counters texture changes for the quest border texture.
local function Hook_SetTexture(Region, Texture)
	if Region.__ExitHook or not Region.__MSQ_Skin then
		return
	end

	Region.__ExitHook = true

	local Skin = Region.__MSQ_Skin
	local SkinTexture = Skin.Texture

	if Texture == DEFAULT_TEXTURE then
		SkinTexture = SkinTexture or Texture
		Region.__MSQ_Texture = Texture
	else
		SkinTexture = Skin.Border or BORDER_TEXTURE
		Region.__MSQ_Texture = BORDER_TEXTURE
	end

	Region:SetTexture(SkinTexture)
	Region.__ExitHook = nil
end

----------------------------------------
-- Core
---

-- Skins the 'QuestBorder' region of a button.
function Core.SkinQuestBorder(Region, Button, Skin, xScale, yScale)
	local Texture = Region.__MSQ_Texture or Region:GetTexture()

	if Button.__MSQ_Enabled then
		Region.__MSQ_Skin = Skin
		Region.__MSQ_Texture = Texture

		Hook_SetTexture(Region, Texture)
	else
		Region.__MSQ_Skin = nil
		Region.__MSQ_Texture = nil

		Region:SetTexture(Texture)
	end

	Region:SetTexCoord(GetTexCoords(Skin.TexCoords))
	Region:SetVertexColor(GetColor(Skin.Color))
	Region:SetBlendMode(Skin.BlendMode or "BLEND")
	Region:SetDrawLayer(Skin.DrawLayer or "OVERLAY", Skin.DrawLevel or 0)
	Region:SetSize(GetSize(Skin.Width, Skin.Height, xScale, yScale))
	SetPoints(Region, Button, Skin, nil, Skin.SetAllPoints)

	if not Region.__MSQ_Hooked then
		hooksecurefunc(Region, "SetTexture", Hook_SetTexture)
		Region.__MSQ_Hooked = true
	end
end
