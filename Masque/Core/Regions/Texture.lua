--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For bug reports,
	suggestions and license information, please visit https://github.com/SFX-WoW/Masque.

	* File...: Core\Regions\Texture.lua
	* Author.: StormFX

	Texture Regions

	* See Skins\Default.lua for region defaults.

]]

local _, Core = ...

----------------------------------------
-- Internal
---

-- @ Skins\Default
local Defaults = Core.DEFAULT_SKIN

-- @ Skins\Regions
local Settings = Core.RegTypes.Legacy

-- @ Core\Utility
local GetColor, GetSize, GetTexCoords = Core.GetColor, Core.GetSize, Core.GetTexCoords
local GetTypeSkin, SetPoints = Core.GetTypeSkin, Core.SetPoints

-- @ Core\Regions\Mask
local SkinMask = Core.SkinMask

----------------------------------------
-- locals
---

-- Regions we need to store the colors for.
local StoreColor = {
	Pushed = true,
	Highlight = true,
	SlotHighlight = true,
}

----------------------------------------
-- Core
---

-- Skins a texture region of a button.
function Core.SkinTexture(Layer, Region, Button, Skin, Color, xScale, yScale)
	local bType = Button.__MSQ_bType
	local Config = Settings[Layer]

	Skin = GetTypeSkin(Button, bType, Skin)
	Config = Config[bType] or Config

	if Config.CanHide and Skin.Hide then
		Region:SetTexture()
		Region:Hide()
		return
	end

	local Resize = true
	local Default = Defaults[Layer]
	Default = GetTypeSkin(Button, bType, Default)

	if not Config.NoTexture then
		local Atlas = Skin.Atlas
		local Texture = Skin.Texture

		Color = Color or Skin.Color

		if StoreColor[Layer] then
			local ColorKey = "__MSQ_"..Layer.."Color"
			Button[ColorKey] = Color
		end

		local SetColor = not Config.NoColor
		local UseColor = Config.UseColor
		local Coords

		-- Skin
		if Skin.UseColor and UseColor then
			Region:SetTexture()
			Region:SetVertexColor(1, 1, 1, 1)
			Region:SetColorTexture(GetColor(Color))
		elseif Texture then
			Coords = Skin.TexCoords
			Region:SetTexture(Texture)

			if SetColor then
				Region:SetVertexColor(GetColor(Color))
			end
		elseif Atlas then
			local UseAtlasSize = Skin.UseAtlasSize

			Region:SetAtlas(Atlas, UseAtlasSize)
			Resize = not UseAtlasSize

			if SetColor then
				Region:SetVertexColor(GetColor(Default.Color))
			end

		-- Default
		else
			Atlas = Default.Atlas
			Texture = Default.Texture

			if Atlas then
				local UseAtlasSize = Skin.UseAtlasSize
				Region:SetAtlas(Atlas, UseAtlasSize)
				Resize = not UseAtlasSize

				if SetColor then
					Region:SetVertexColor(GetColor(Default.Color))
				end
			elseif Texture then
				Coords = Default.TexCoords
				Region:SetTexture(Default.Texture)

				if SetColor then
					Region:SetVertexColor(GetColor(Default.Color))
				end
			elseif UseColor then
				Region:SetTexture()
				Region:SetVertexColor(1, 1, 1, 1)
				Region:SetColorTexture(GetColor(Default.Color))
			end
		end

		Region:SetTexCoord(GetTexCoords(Coords))
	end

	Region:SetBlendMode(Skin.BlendMode or Default.BlendMode or "BLEND")

	if Layer == "Highlight" then
		Region:SetDrawLayer("HIGHLIGHT", Skin.DrawLevel or Default.DrawLevel or 0)
	else
		Region:SetDrawLayer(Skin.DrawLayer or Default.DrawLayer, Skin.DrawLevel or Default.DrawLevel or 0)
	end

	if Resize then
		Region:SetSize(GetSize(Skin.Width, Skin.Height, xScale, yScale, Button))
	end

	local SetAllPoints = Skin.SetAllPoints or (not Skin.Point and Default.SetAllPoints)
	SetPoints(Region, Button, Skin, Default, SetAllPoints)

	-- Mask
	if Config.CanMask then
		SkinMask(Region, Button, Skin, xScale, yScale)
	end
end

-- Sets the color of a texture region.
function Core.SetTextureColor(Layer, Region, Button, Skin, Color)
	if Region then
		local bType = Button.__MSQ_bType
		local Config = Settings[Layer]

		Skin = GetTypeSkin(Button, bType, Skin)
		Config = Config[bType] or Config
		Color = Color or Skin.Color

		if Skin.UseColor and Config.UseColor then
			Region:SetVertexColor(1, 1, 1, 1)
			Region:SetColorTexture(GetColor(Color))
		else
			Region:SetVertexColor(GetColor(Color))
		end
	end
end
