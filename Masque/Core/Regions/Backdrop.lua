--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For bug reports,
	suggestions and license information, please visit https://github.com/SFX-WoW/Masque.

	* File...: Core\Regions\Backdrop.lua
	* Author.: StormFX

	'Backdrop' Region

	* See Skins\Default.lua for region defaults.

]]

local _, Core = ...

----------------------------------------
-- Lua
---

local error, type = error, type

----------------------------------------
-- Internal
---

-- @ Skins\Default
local Default = Core.Skins.Default.Backdrop

-- @ Core\Utility
local GetColor, GetSize = Core.GetColor, Core.GetSize
local GetTexCoords, SetPoints = Core.GetTexCoords, Core.SetPoints

-- @ Core\Regions\Mask
local SkinMask = Core.SkinMask

----------------------------------------
-- Locals
---

local DEF_COLOR = Default.Color
local DEF_TEXTURE = Default.Texture

local Cache = {}

----------------------------------------
-- Functions
---

-- Removes the 'Backdrop' region from a button.
local function RemoveBackdrop(Region, Button)
	Region = Region or Button.__MSQ_Backdrop

	if Region then
		Region:Hide()

		if Button.__MSQ_Backdrop then
			-- Remove the button mask.
			local ButtonMask = Button.__MSQ_Mask

			if ButtonMask and Region.__MSQ_ButtonMask then
				Region:RemoveMaskTexture(ButtonMask)
				Region.__MSQ_ButtonMask = nil
			end

			Region:SetTexture()

			Cache[#Cache + 1] = Region
			Button.__MSQ_Backdrop = nil
		end
	end
end

-- Skins or creates the 'Backdrop' region of a button.
local function AddBackdrop(Region, Button, Skin, Color, xScale, yScale)
	Button.FloatingBG = Region
	Region = Region or Button.__MSQ_Backdrop

	if not Region then
		local i = #Cache

		if i > 0 then
			Region = Cache[i]
			Cache[i] = nil
		else
			Region = Button:CreateTexture()
		end

		Button.__MSQ_Backdrop = Region
	end

	Region:SetParent(Button)
	Color = Color or Skin.Color

	if Skin.UseColor then
		Region:SetTexture()
		Region:SetVertexColor(1, 1, 1, 1)
		Region:SetColorTexture(GetColor(Color or DEF_COLOR))
	else
		Region:SetTexture(Skin.Texture or DEF_TEXTURE)
		Region:SetTexCoord(GetTexCoords(Skin.TexCoords))
		Region:SetVertexColor(GetColor(Color or DEF_COLOR))
	end

	Region:SetBlendMode(Skin.BlendMode or "BLEND")
	Region:SetDrawLayer(Skin.DrawLayer or "BACKGROUND", Skin.DrawLevel or -1)
	Region:SetSize(GetSize(Skin.Width, Skin.Height, xScale, yScale))
	SetPoints(Region, Button, Skin, nil, Skin.SetAllPoints)
	Region:Show()

	-- Mask
	SkinMask(Region, Button, Skin, xScale, yScale)
end

----------------------------------------
-- Core
---

-- Sets the color of the 'Backdrop' region.
function Core.SetBackdropColor(Region, Button, Skin, Color)
	Region = Region or Button.__MSQ_Backdrop

	if Region then
		local bType = Button.__MSQ_bType
		Skin = Skin[bType] or Skin

		Color = Color or Skin.Color

		if Skin.UseColor then
			Region:SetColorTexture(GetColor(Color or DEF_COLOR))
		else
			Region:SetVertexColor(GetColor(Color or DEF_COLOR))
		end
	end
end

-- Add or removes a 'Backdrop' region.
function Core.SkinBackdrop(Enabled, Region, Button, Skin, Color, xScale, yScale)
	local bType = Button.__MSQ_bType
	Skin = Skin[bType] or Skin

	if Enabled and not Skin.Hide then
		AddBackdrop(Region, Button, Skin, Color, xScale, yScale)
	else
		RemoveBackdrop(Region, Button)
	end
end

----------------------------------------
-- API
---

-- Retrieves the 'Backdrop' region of a button.
function Core.API:GetBackdrop(Button)
	if type(Button) ~= "table" then
		if Core.Debug then
			error("Bad argument to API method 'GetBackdrop'. 'Button' must be a button object.", 2)
		end
		return
	end

	return Button.FloatingBG or Button.__MSQ_Backdrop
end
