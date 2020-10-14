--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For bug reports,
	suggestions and license information, please visit https://github.com/SFX-WoW/Masque.

	* File...: Core\Regions\Mask.lua
	* Author.: StormFX

	Button/Region Mask

]]

local _, Core = ...

----------------------------------------
-- Lua
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
	local ButtonMask = Button.__MSQ_Mask

	-- Region
	if Region then
		local SkinMask = Skin.Mask

		-- Button Mask
		if Skin.UseMask and ButtonMask and not SkinMask then
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

		if SkinMask then
			if not RegionMask then
				RegionMask = Button:CreateMaskTexture()
				Region.__MSQ_Mask = RegionMask
			end

			if type(SkinMask) == "table" then
				RegionMask:SetTexture(SkinMask.Texture)
				RegionMask:SetSize(GetSize(SkinMask.Width, SkinMask.Height, xScale, yScale))
				SetPoints(RegionMask, Region, Skin, nil, SkinMask.SetAllPoints)
			else
				RegionMask:SetTexture(SkinMask)
				RegionMask:SetAllPoints(Region)
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

		if type(Skin) == "table" then
			ButtonMask:SetTexture(Skin.Texture)
			ButtonMask:SetSize(GetSize(Skin.Width, Skin.Height, xScale, yScale))
			SetPoints(ButtonMask, Button, Skin, nil, Skin.SetAllPoints)
		else
			ButtonMask:SetTexture(Skin)
			ButtonMask:SetAllPoints(Button)
		end
	end
end
