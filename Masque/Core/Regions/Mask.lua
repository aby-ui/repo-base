--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For license information,
	please see the included License.txt file or visit https://github.com/StormFX/Masque.

	* File...: Core\Regions\Mask.lua
	* Author.: StormFX

	Button/Region Mask

]]

local _, Core = ...

----------------------------------------
-- Internal
---

-- @ Core\Utility
local GetSize, SetPoints = Core.GetSize, Core.SetPoints

----------------------------------------
-- Core
---

-- Skins a button or region mask.
function Core.SkinMask(Button, Region, Skin, xScale, yScale)
	local ButtonMask = Button.__MSQ_Mask

	-- Region
	if Region then
		-- Button Mask
		if Skin.UseMask and ButtonMask then
			if not Region.__MSQ_ButtonMask then
				Region:AddMaskTexture(ButtonMask)
				Region.__MSQ_ButtonMask = true
			end
		elseif Region.__MSQ_ButtonMask then
			Region:RemoveMaskTexture(ButtonMask)
			Region.__MSQ_ButtonMask = nil
		end

		-- Region Mask
		local RegionMask = Region.__MSQ_Mask
		local Texture = Skin.Mask

		if Texture then
			if not RegionMask then
				RegionMask = Button:CreateMaskTexture()
				Region.__MSQ_Mask = RegionMask
			end

			RegionMask:SetTexture(Texture)
			RegionMask:SetAllPoints(Region)

			if not Region.__MSQ_RegionMask then
				Region:AddMaskTexture(RegionMask)
				Region.__MSQ_RegionMask = true
			end
		elseif RegionMask then
			Region:RemoveMaskTexture(RegionMask)
			Region.__MSQ_RegionMask = nil
		end

	-- Button
	else
		ButtonMask = ButtonMask or Button:CreateMaskTexture()
		Button.__MSQ_Mask = ButtonMask

		ButtonMask:SetTexture(Skin.Texture)
		ButtonMask:SetSize(GetSize(Skin.Width, Skin.Height, xScale, yScale))
		SetPoints(ButtonMask, Button, Skin, nil, Skin.SetAllPoints)
	end
end
