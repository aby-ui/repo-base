--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For bug reports,
	suggestions and license information, please visit https://github.com/SFX-WoW/Masque.

	* File...: Core\Regions\Icon.lua
	* Author.: StormFX

	'Icon' Region

	* See Skins\Default.lua for region defaults.

]]

local _, Core = ...

----------------------------------------
-- Internal
---

-- @ Core\Utility
local GetSize, SetPoints = Core.GetSize, Core.SetPoints
local GetTexCoords = Core.GetTexCoords

-- @ Core\Regions\Mask
local SkinMask = Core.SkinMask

----------------------------------------
-- Core
---

-- Skins the 'Icon' region of a button.
function Core.SkinIcon(Region, Button, Skin, xScale, yScale)
	Button.__MSQ_Icon = Region

	local bType = Button.__MSQ_bType
	Skin = (bType and Skin[bType]) or Skin

	Region:SetParent(Button)
	Region:SetTexCoord(GetTexCoords(Skin.TexCoords))
	Region:SetDrawLayer(Skin.DrawLayer or "BACKGROUND", Skin.DrawLevel or 0)
	Region:SetSize(GetSize(Skin.Width, Skin.Height, xScale, yScale))
	SetPoints(Region, Button, Skin, nil, Skin.SetAllPoints)

	-- Mask
	SkinMask(Region, Button, Skin, xScale, yScale)
end
