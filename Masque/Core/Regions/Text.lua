--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For bug reports,
	suggestions and license information, please visit https://github.com/SFX-WoW/Masque.

	* File...: Core\Regions\Text.lua
	* Author.: StormFX

	Text Regions

	* See Skins\Default.lua for region defaults.

]]

local _, Core = ...

----------------------------------------
-- Internal
---

-- @ Skins\Default
local Defaults = Core.Skins.Default

-- @ Core\Utility
local GetSize, SetPoints = Core.GetSize, Core.SetPoints

----------------------------------------
-- Core
---

-- Skins a text layer of a button.
function Core.SkinText(Layer, Region, Button, Skin, xScale, yScale)
	local bType = Button.__MSQ_bType
	local Default = Defaults[Layer]

	Skin = Skin[bType] or Skin
	Default = Default[bType] or Default

	Region:SetJustifyH(Skin.JustifyH or Default.JustifyH)
	Region:SetJustifyV(Skin.JustifyV or "MIDDLE")
	Region:SetDrawLayer(Skin.DrawLayer or Default.DrawLayer)
	Region:SetSize(GetSize(Skin.Width, Skin.Height or 10, xScale, yScale))
	SetPoints(Region, Button, Skin, Default)
end
