--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For bug reports,
	suggestions and license information, please visit https://github.com/SFX-WoW/Masque.

	* File...: Core\Regions\Gloss.lua
	* Author.: StormFX

	'Gloss' Region

]]

local _, Core = ...

----------------------------------------
-- Lua
---

local error, type = error, type

----------------------------------------
-- Internal
---

-- @ Core\Utility
local GetColor, GetSize = Core.GetColor, Core.GetSize
local GetTexCoords, SetPoints = Core.GetTexCoords, Core.SetPoints

----------------------------------------
-- Locals
---

local Cache = {}

----------------------------------------
-- Functions
---

-- Removes the 'Gloss' region from a button.
local function RemoveGloss(Button)
	local Region = Button.__MSQ_Gloss

	if Region then
		Region:SetTexture()
		Region:Hide()

		Cache[#Cache + 1] = Region
		Button.__MSQ_Gloss = nil
	end
end

-- Skins or creates the 'Gloss' region of a button.
local function AddGloss(Button, Skin, Color, xScale, yScale)
	local Region = Button.__MSQ_Gloss

	if not Region then
		local i = #Cache

		if i > 0 then
			Region = Cache[i]
			Cache[i] = nil
		else
			Region = Button:CreateTexture()
		end

		Button.__MSQ_Gloss = Region
	end

	Region:SetParent(Button)
	Region:SetTexture(Skin.Texture)
	Region:SetTexCoord(GetTexCoords(Skin.TexCoords))
	Region:SetBlendMode(Skin.BlendMode or "BLEND")
	Region:SetVertexColor(GetColor(Color or Skin.Color))
	Region:SetDrawLayer(Skin.DrawLayer or "OVERLAY", Skin.DrawLevel or 0)
	Region:SetSize(GetSize(Skin.Width, Skin.Height, xScale, yScale))
	SetPoints(Region, Button, Skin, nil, Skin.SetAllPoints)

	if Button.__MSQ_Empty then
		Region:Hide()
	else
		Region:Show()
	end
end

----------------------------------------
-- Core
---

-- Skins or removes a 'Gloss' region.
function Core.SkinGloss(Enabled, Button, Skin, Color, xScale, yScale)
	local bType = Button.__MSQ_bType
	Skin = Skin[bType] or Skin

	if Enabled and not Skin.Hide and Skin.Texture then
		AddGloss(Button, Skin, Color, xScale, yScale)
	else
		RemoveGloss(Button)
	end
end

-- Sets the color of the 'Gloss' region.
function Core.SetGlossColor(Region, Button, Skin, Color)
	Region = Region or Button.__MSQ_Gloss

	if Region then
		local bType = Button.__MSQ_bType
		Skin = Skin[bType] or Skin

		Region:SetVertexColor(GetColor(Color or Skin.Color))
	end
end

----------------------------------------
-- API
---

-- Retrieves the 'Gloss' region of a button.
function Core.API:GetGloss(Button)
	if type(Button) ~= "table" then
		if Core.Debug then
			error("Bad argument to API method 'GetGloss'. 'Button' must be a button object.", 2)
		end
		return
	end

	return Button.__MSQ_Gloss
end
