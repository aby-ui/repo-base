--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For bug reports,
	suggestions and license information, please visit https://github.com/SFX-WoW/Masque.

	* File...: Core\Regions\Shadow.lua
	* Author.: StormFX

	'Shadow' Region

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

-- Removes the 'Shadow' region from a button.
local function RemoveShadow(Button)
	local Region = Button.__MSQ_Shadow

	if Region then
		Region:SetTexture()
		Region:Hide()

		Cache[#Cache + 1] = Region
		Button.__MSQ_Shadow = nil
	end
end

-- Skins or creates the 'Shadow' region of a button.
local function AddShadow(Button, Skin, Color, xScale, yScale)
	local Region = Button.__MSQ_Shadow

	if not Region then
		local i = #Cache

		if i > 0 then
			Region = Cache[i]
			Cache[i] = nil
		else
			Region = Button:CreateTexture()
		end

		Button.__MSQ_Shadow = Region
	end

	Region:SetParent(Button)
	Region:SetTexture(Skin.Texture)
	Region:SetTexCoord(GetTexCoords(Skin.TexCoords))
	Region:SetVertexColor(GetColor(Color or Skin.Color))
	Region:SetBlendMode(Skin.BlendMode or "BLEND")
	Region:SetDrawLayer(Skin.DrawLayer or "ARTWORK", Skin.DrawLevel or -1)
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

-- Sets the color of the 'Shadow' region.
function Core.SetShadowColor(Region, Button, Skin, Color)
	Region = Region or Button.__MSQ_Shadow

	if Region then
		local bType = Button.__MSQ_bType
		Skin = Skin[bType] or Skin

		Region:SetVertexColor(GetColor(Color or Skin.Color))
	end
end

-- Add or removes a 'Shadow' region.
function Core.SkinShadow(Enabled, Button, Skin, Color, xScale, yScale)
	local bType = Button.__MSQ_bType
	Skin =  Skin[bType] or Skin

	if Enabled and not Skin.Hide and Skin.Texture then
		AddShadow(Button, Skin, Color, xScale, yScale)
	else
		RemoveShadow(Button)
	end
end

----------------------------------------
-- API
---

-- Retrieves the 'Shadow' region of a button.
function Core.API:GetShadow(Button)
	if type(Button) ~= "table" then
		if Core.Debug then
			error("Bad argument to API method 'GetShadow'. 'Button' must be a button object.", 2)
		end
		return
	end

	return Button.__MSQ_Shadow
end
