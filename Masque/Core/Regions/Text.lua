--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For license information,
	please see the included License.txt file or visit https://github.com/StormFX/Masque.

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
-- Hook
---

-- Counter calls to SetPoint() after the HotKey region has been skinned.
local function Hook_SetPoint(Region, ...)
	if Region.__ExitHook or not Region.__MSQ_Skin then
		return
	end

	Region.__ExitHook = true
	SetPoints(Region, Region.__MSQ_Button, Region.__MSQ_Skin, Defaults.HotKey)
	Region.__ExitHook = nil
end

----------------------------------------
-- Core
---

-- Skins a text layer of a button.
function Core.SkinText(Region, Button, Layer, Skin, xScale, yScale)
	local bType = Button.__MSQ_bType
	local Default = Defaults[Layer]

	if bType then
		Skin = Skin[bType] or Skin
		Default = Default[bType] or Default
	end

	Region:SetJustifyH(Skin.JustifyH or Default.JustifyH)
	Region:SetJustifyV(Skin.JustifyV or "MIDDLE")
	Region:SetDrawLayer(Skin.DrawLayer or Default.DrawLayer)
	Region:SetSize(GetSize(Skin.Width, Skin.Height or 10, xScale, yScale))

	if Layer == "HotKey" then
		if Button.__MSQ_Enabled then
			Region.__MSQ_Skin = Skin
			Region.__MSQ_Button = Button

			if not Region.__MSQ_Hooked then
				hooksecurefunc(Region, "SetPoint", Hook_SetPoint)
				Region.__MSQ_Hooked = true
			end

			Hook_SetPoint(Region)
		else
			Region.__MSQ_Skin = nil
			Region.__MSQ_Button = nil

			SetPoints(Region, Button, Skin, Default)
		end
	else
		SetPoints(Region, Button, Skin, Default)
	end
end
