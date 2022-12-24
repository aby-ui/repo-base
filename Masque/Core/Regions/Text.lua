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
local Defaults = Core.DEFAULT_SKIN

-- @ Core\Utility
local GetSize, GetTypeSkin, SetPoints = Core.GetSize, Core.GetTypeSkin, Core.SetPoints

----------------------------------------
-- Core
---

-- Skins a text layer of a button.
function Core.SkinText(Layer, Region, Button, Skin, xScale, yScale)
	local bType = Button.__MSQ_bType
	local Default = Defaults[Layer]

	Skin = GetTypeSkin(Button, bType, Skin)
	Default = Default[bType] or Default

	local Wrap = (Skin.Wrap and true) or false

	Region:SetJustifyH(Skin.JustifyH or Default.JustifyH)
	Region:SetJustifyV(Skin.JustifyV or "MIDDLE")
	Region:SetWordWrap(Wrap)
	Region:SetDrawLayer(Skin.DrawLayer or Default.DrawLayer)
	Region:SetSize(GetSize(Skin.Width or 36, Skin.Height == 0 and 10 or Skin.Height or 10, xScale, yScale, Button))
	SetPoints(Region, Button, Skin, Default)
end
