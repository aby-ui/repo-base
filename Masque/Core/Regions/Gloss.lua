--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For license information,
	please see the included License.txt file or visit https://github.com/StormFX/Masque.

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
local GetSize, SetPoints = Core.GetSize, Core.SetPoints
local GetColor, GetTexCoords = Core.GetColor, Core.GetTexCoords

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
local function SkinGloss(Button, Skin, Color, xScale, yScale)
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
	Skin = (bType and Skin[bType]) or Skin

	if Enabled and not Skin.Hide and Skin.Texture then
		SkinGloss(Button, Skin, Color, xScale, yScale)
	else
		RemoveGloss(Button)
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
