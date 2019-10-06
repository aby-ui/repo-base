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

local Base = {}

----------------------------------------
-- SetEmpty
---

-- Sets a button's empty state and updates its regions.
local function SetEmpty(Button, IsEmpty)
	if IsEmpty == nil then
		local Icon = Button.__MSQ_Icon
		IsEmpty = (Icon and not Icon:IsShown()) or nil
	else
		IsEmpty = (IsEmpty and true) or nil
	end

	Button.__MSQ_Empty = IsEmpty

	local Normal = Button.__MSQ_Normal
	local Skin = Button.__MSQ_NormalSkin

	if Normal and (Skin and not Skin.Hide) then
		local Texture = Button.__MSQ_Random or Skin.Texture or DEF_TEXTURE
		local Color = Button.__MSQ_NormalColor or DEF_COLOR

		if IsEmpty then
			Normal:SetTexture(Skin.EmptyTexture or Texture)
			Normal:SetTexCoord(GetTexCoords(Skin.EmptyCoords or Skin.TexCoords))
			Normal:SetVertexColor(GetColor(Skin.EmptyColor or Color))
		else
			Normal:SetTexture(Texture)
			Normal:SetTexCoord(GetTexCoords(Skin.TexCoords))
			Normal:SetVertexColor(GetColor(Color))
		end
	end

	local Shadow = Button.__MSQ_Shadow
	local Gloss = Button.__MSQ_Gloss

	if IsEmpty then
		if Shadow then Shadow:Hide() end
		if Gloss then Gloss:Hide() end
	else
		if Shadow then Shadow:Show() end
		if Gloss then Gloss:Show() end
	end
end

----------------------------------------
-- Hook
---

-- Counters changes to a button's 'Normal' texture.
-- * The default behavior for action buttons is to set the 'Normal' region's
--   alpha to 0.5, but the PetBar and some add-ons still change the texture.
local function Hook_SetNormalTexture(Button, Texture)
	if Button.__MSQ_NormalSkin then
		local Region = Button.__MSQ_Normal
		local Normal = Button:GetNormalTexture()

		if Normal and Normal ~= Region then
			Normal:SetTexture()
			Normal:Hide()
		end

		local Skin = Button.__MSQ_NormalSkin

		if Skin and Skin.Hide then
			Region:SetTexture()
			Region:Hide()
		end
	end

	SetEmpty(Button)
end

----------------------------------------
-- Core
---

-- Skins the 'Normal' layer of a button.
function Core.SkinNormal(Region, Button, Skin, Color, xScale, yScale)
	Region = Region or Button:GetNormalTexture()

	local Custom = Base[Button]

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
			Region:SetAlpha(0) -- Fix for BT4's Pet buttons.
			Region:SetTexture()
			Region:Hide()
		end

		Region = Custom or Button:CreateTexture()
		Base[Button] = Region
	end

	local bType = Button.__MSQ_bType
	Skin = (bType and Skin[bType]) or Skin

	Color = Color or Skin.Color or DEF_COLOR

	Button.__MSQ_Normal = Region
	Button.__MSQ_NormalSkin = Skin
	Button.__MSQ_NormalColor = Color

	local Textures = Skin.Textures
	local Random

	if type(Textures) == "table" and #Textures > 0 then
		local i = random(1, #Textures)
		Random = Textures[i]
	end

	Button.__MSQ_Random = Random

	if Skin.Hide then
		if Region then
			Region:SetTexture()
			Region:Hide()
		end
		return
	end

	Region:SetAlpha(1) -- Counter BT4 fix.
	SetEmpty(Button)

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

	if not Button.__MSQ_NormalHook then
		hooksecurefunc(Button, "SetNormalTexture", Hook_SetNormalTexture)
		Button.__MSQ_NormalHook = true
	end
end

----------------------------------------
-- API
---

local API = Core.API

-- Retrieves the 'Normal' region of a button.
function API:GetNormal(Button)
	if type(Button) ~= "table" then
		if Core.db.profile.Debug then
			error("Bad argument to API method 'GetNormal'. 'Button' must be a button object.", 2)
		end
		return
	end

	return Button.__MSQ_Normal or Button:GetNormalTexture()
end

-- Sets the button's empty status.
function API:SetEmpty(Button, IsEmpty)
	if type(Button) ~= "table" then
		return
	end

	SetEmpty(Button, IsEmpty)
end
