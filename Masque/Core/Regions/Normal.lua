--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For license information,
	please see the included License.txt file or visit https://github.com/StormFX/Masque.

	* File...: Core\Regions\Normal.lua
	* Author.: StormFX

	'Normal' Region

	* See Skins\Default.lua for region defaults.

]]

local _, Core = ...

----------------------------------------
-- Lua
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
local Default = Core.Skins.Default.Normal

-- @ Core\Utility
local GetSize, SetPoints = Core.GetSize, Core.SetPoints
local GetColor, GetTexCoords = Core.GetColor, Core.GetTexCoords

----------------------------------------
-- Locals
---

local DEF_TEXTURE = Default.Texture
local DEF_COLOR = Default.Color

----------------------------------------
-- UpdateNormal
---

-- Updates the 'Normal' texture of a region.
local function UpdateNormal(Button, IsEmpty)
	IsEmpty = IsEmpty or Button.__MSQ_Empty

	local Normal = Button.__MSQ_Normal
	local Skin = Button.__MSQ_NormalSkin

	if Normal and (Skin and not Skin.Hide) then
		local Texture = Button.__MSQ_Random or Skin.Texture or DEF_TEXTURE
		local Color = Button.__MSQ_NormalColor or DEF_COLOR

		-- Only allow texture changes for Pet buttons.
		if Button.__MSQ_bType == "Pet" and IsEmpty then
			Normal:SetTexture(Skin.EmptyTexture or Texture)
			Normal:SetTexCoord(GetTexCoords(Skin.EmptyCoords or Skin.TexCoords))
			Normal:SetVertexColor(GetColor(Skin.EmptyColor or Color))
		else
			Normal:SetTexture(Texture)
			Normal:SetTexCoord(GetTexCoords(Skin.TexCoords))
			Normal:SetVertexColor(GetColor(Color))
		end
	end
end

----------------------------------------
-- Hook
---

-- Counters changes to a button's 'Normal' texture.
-- * The behavior of changing the texture when a button is empty is only used
--   by default UI in the case of Pet buttons. Some add-ons still use this
--   behavior for other button types, so it needs to be countered.
local function Hook_SetNormalTexture(Button, Texture)
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

-- Skins the 'Normal' layer of a button and sets up the hooks.
function Core.SkinNormal(Region, Button, Skin, Color, xScale, yScale)
	Region = Region or Button:GetNormalTexture()

	local Custom = Button.__MSQ_NewNormal

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

	local bType = Button.__MSQ_bType
	Skin = Skin[bType] or Skin

	Color = Color or Skin.Color or DEF_COLOR

	Button.__MSQ_Normal = Region
	Button.__MSQ_NormalSkin = Skin
	Button.__MSQ_NormalColor = Color

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
	Region:SetSize(GetSize(Skin.Width, Skin.Height, xScale, yScale))
	SetPoints(Region, Button, Skin, nil, Skin.SetAllPoints)
	Region:Show()

	if Button.__MSQ_EmptyType and not Button.__MSQ_NormalHook then
		hooksecurefunc(Button, "SetNormalTexture", Hook_SetNormalTexture)
		Button.__MSQ_NormalHook = true
	end
end

----------------------------------------
-- Core
---

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
