--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For bug reports,
	suggestions and license information, please visit https://github.com/SFX-WoW/Masque.

	* File...: Core\Regions\Mask.lua
	* Author.: StormFX

	Button/Region Mask

]]

local _, Core = ...

----------------------------------------
-- Lua API
---

local type = type

----------------------------------------
-- Internal
---

-- @ Core\Utility
local GetSize, SetPoints = Core.GetSize, Core.SetPoints

----------------------------------------
-- Core
---

-- Skins a button or region mask.
function Core.SkinMask(Region, Button, Skin, xScale, yScale)
	local ButtonMask = Button.__MSQ_Mask or Button.IconMask
	local CircleMask = Button.CircleMask

	-- Disable the bag slot mask in 10.0 to enable custom masks.
	if CircleMask then
		local Icon = Button.icon

		if Icon then
			Icon:RemoveMaskTexture(CircleMask)
		end

		CircleMask:SetTexture()
	end

	-- Region
	if Region then
		local SkinMask = Skin.Mask

		-- Button Mask
		if Skin.UseMask and ButtonMask and not SkinMask then
			if not Region.__MSQ_ButtonMask then
				Region:AddMaskTexture(ButtonMask)
				Region.__MSQ_ButtonMask = true
			end
		elseif ButtonMask then
			Region:RemoveMaskTexture(ButtonMask)
			Region.__MSQ_ButtonMask = nil
		end

		-- Region Mask
		local RegionMask = Region.__MSQ_Mask
		local Type = type(SkinMask)

		if SkinMask then
			if not RegionMask then
				RegionMask = Button:CreateMaskTexture()
				Region.__MSQ_Mask = RegionMask
			end

			if Type == "table" then
				local Atlas, Texture = SkinMask.Atlas, SkinMask.Texture

				if Atlas then
					local UseAtlasSize = SkinMask.UseAtlasSize

					ButtonMask:SetAtlas(Atlas, UseAtlasSize)

					if not UseAtlasSize then
						ButtonMask:SetSize(GetSize(SkinMask.Width, SkinMask.Height, xScale, yScale, Button))
					end

					SetPoints(RegionMask, Region, SkinMask, nil, SkinMask.SetAllPoints)
				elseif Texture then
					RegionMask:SetTexture(Texture, SkinMask.WrapH, SkinMask.WrapV)
					RegionMask:SetSize(GetSize(SkinMask.Width, SkinMask.Height, xScale, yScale, Button))
					SetPoints(RegionMask, Region, SkinMask, nil, SkinMask.SetAllPoints)
				end
			elseif Type == "string" then
				RegionMask:SetTexture(SkinMask, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
				RegionMask:SetAllPoints(Region)
			else
				return
			end

			if not Region.__MSQ_RegionMask then
				Region:AddMaskTexture(RegionMask)
				Region.__MSQ_RegionMask = true
			end
		elseif Region.__MSQ_RegionMask then
			Region:RemoveMaskTexture(RegionMask)
			Region.__MSQ_RegionMask = nil
		end

	-- Button
	else
		ButtonMask = ButtonMask or Button:CreateMaskTexture()
		Button.__MSQ_Mask = ButtonMask

		local Type = type(Skin)

		if Type == "table" then
			local Atlas, Texture = Skin.Atlas, Skin.Texture

			if Atlas then
				local UseAtlasSize = Skin.UseAtlasSize
				ButtonMask:SetAtlas(Atlas, UseAtlasSize)

				if not UseAtlasSize then
					ButtonMask:SetSize(GetSize(Skin.Width, Skin.Height, xScale, yScale, Button))
				end

				SetPoints(ButtonMask, Button, Skin, nil, Skin.SetAllPoints)
			elseif Texture then
				ButtonMask:SetTexture(Texture, Skin.WrapH, Skin.WrapV)
				ButtonMask:SetSize(GetSize(Skin.Width, Skin.Height, xScale, yScale, Button))
				SetPoints(ButtonMask, Button, Skin, nil, Skin.SetAllPoints)
			end
		elseif Type == "string" then
			ButtonMask:SetTexture(Skin, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
			ButtonMask:SetAllPoints(Button)
		end
	end
end
