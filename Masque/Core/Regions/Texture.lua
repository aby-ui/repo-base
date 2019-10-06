--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For license information,
	please see the included License.txt file or visit https://github.com/StormFX/Masque.

	* File...: Core\Regions\Texture.lua
	* Author.: StormFX

	Texture Regions

	* See Skins\Default.lua for region defaults.

]]

local _, Core = ...

----------------------------------------
-- Internal
---

-- @ Skins\Regions
local Settings = Core.RegTypes.Legacy

-- @ Skins\Default
local Defaults = Core.Skins.Default

-- @ Core\Utility
local GetSize, SetPoints = Core.GetSize, Core.SetPoints
local GetColor, GetTexCoords = Core.GetColor, Core.GetTexCoords

-- @ Core\Regions\Mask
local SkinMask = Core.SkinMask

----------------------------------------
-- Core
---

-- Skins a texture region of a button.
function Core.SkinTexture(Region, Button, Layer, Skin, Color, xScale, yScale)
	if Skin.Hide then
		Region:SetTexture()
		Region:Hide()
		return
	end

	local bType = Button.__MSQ_bType
	local Config = Settings[Layer]
	local Default = Defaults[Layer]

	if bType then
		Skin = Skin[bType] or Skin
		Config = Config[bType] or Config
		Default = Default[bType] or Default
	end

	if not Config.NoTexture then
		local Texture = Skin.Texture
		Color = Color or Skin.Color

		local SetColor = not Config.NoColor
		local UseColor = Config.UseColor

		if Skin.UseColor and UseColor then
			Region:SetTexture()
			Region:SetVertexColor(1, 1, 1, 1)
			Region:SetColorTexture(GetColor(Color))
		elseif Texture then
			Region:SetTexture(Texture)
			Region:SetTexCoord(GetTexCoords(Skin.TexCoords))

			if SetColor then
				Region:SetVertexColor(GetColor(Color))
			end
		else
			local Atlas = Default.Atlas
			Texture = Default.Texture

			if Atlas then
				Region:SetAtlas(Atlas)

				if SetColor then
					Region:SetVertexColor(GetColor(Default.Color))
				end
			elseif Texture then
				Region:SetTexture(Default.Texture)
				Region:SetTexCoord(GetTexCoords(Default.TexCoords))

				if SetColor then
					Region:SetVertexColor(GetColor(Default.Color))
				end
			elseif UseColor then
				Region:SetTexture()
				Region:SetVertexColor(1, 1, 1, 1)
				Region:SetColorTexture(GetColor(Default.Color))
			end
		end
	end

	Region:SetBlendMode(Skin.BlendMode or Default.BlendMode or "BLEND")
	Region:SetDrawLayer(Skin.DrawLayer or Default.DrawLayer, Skin.DrawLevel or Default.DrawLevel or 0)
	Region:SetSize(GetSize(Skin.Width, Skin.Height, xScale, yScale))

	local SetAllPoints = Skin.SetAllPoints or (not Skin.Point and Default.SetAllPoints)
	SetPoints(Region, Button, Skin, Default, SetAllPoints)

	-- Mask
	if Config.CanMask then
		SkinMask(Button, Region, Skin, xScale, yScale)
	end
end
