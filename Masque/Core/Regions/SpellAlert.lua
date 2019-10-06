--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For license information,
	please see the included License.txt file or visit https://github.com/StormFX/Masque.

	* File...: Core\Regions\SpellAlert.lua
	* Author.: StormFX

	'SpellAlert' Region

	* TODO: Improve the textures.

]]

-- GLOBALS: hooksecurefunc

local _, Core = ...

----------------------------------------
-- Lua
---

local error, type = error, type

----------------------------------------
-- Locals
---

local Alerts = {
	Square = {
		Glow = [[Interface\SpellActivationOverlay\IconAlert]],
		Ants = [[Interface\SpellActivationOverlay\IconAlertAnts]],
	},
	Circle = {
		Glow = [[Interface\AddOns\Masque\Textures\SpellAlert\IconAlert-Circle]],
		Ants = [[Interface\AddOns\Masque\Textures\SpellAlert\IconAlertAnts-Circle]],
	},
}

----------------------------------------
-- Update
---

-- Hook to update the 'SpellAlert' animation.
local function UpdateSpellAlert(Button)
	local Overlay = Button.overlay

	if not Overlay or not Overlay.spark then
		return
	end

	local Shape = Button.__MSQ_Shape

	if Overlay.__MSQ_Shape ~= Shape then
		local Glow, Ants

		if Shape and Alerts[Shape] then
			Glow = Alerts[Shape].Glow or Alerts.Square.Glow
			Ants = Alerts[Shape].Ants or Alerts.Square.Ants
		else
			Glow = Alerts.Square.Glow
			Ants = Alerts.Square.Ants
		end

		Overlay.innerGlow:SetTexture(Glow)
		Overlay.innerGlowOver:SetTexture(Glow)
		Overlay.outerGlow:SetTexture(Glow)
		Overlay.outerGlowOver:SetTexture(Glow)
		Overlay.spark:SetTexture(Glow)
		Overlay.ants:SetTexture(Ants)

		Overlay.__MSQ_Shape = Shape
	end
end

-- @ FrameXML\ActionButton.lua
hooksecurefunc("ActionButton_ShowOverlayGlow", UpdateSpellAlert)

----------------------------------------
-- Core
---

Core.UpdateSpellAlert = UpdateSpellAlert

----------------------------------------
-- API
---

local API = Core.API

-- Wrapper for the Update function.
-- * Allows add-ons to call the function when not using the native API.
function API:UpdateSpellAlert(Button)
	if type(Button) ~= "table" then
		return
	end

	UpdateSpellAlert(Button)
end

-- Adds or overwrites a 'SpellAlert' texture set.
function API:AddSpellAlert(Shape, Glow, Ants)
	if type(Shape) ~= "string" then
		if Core.Debug then
			error("Bad argument to API method 'AddSpellAlert'. 'Shape' must be a string.", 2)
		end
		return
	end

	local Overlay = Alerts[Shape] or {}

	if type(Glow) == "string" then
		Overlay.Glow = Glow
	end

	if type(Ants) == "string" then
		Overlay.Ants = Ants
	end

	Alerts[Shape] = Overlay
end

-- Retrieves a 'SpellAlert' texture set.
function API:GetSpellAlert(Shape)
	if type(Shape) ~= "string" then
		if Core.Debug then
			error("Bad argument to API method 'GetSpellAlert'. 'Shape' must be a string.", 2)
		end
		return
	end

	local Overlay = Alerts[Shape]

	if Overlay then
		return Overlay.Glow, Overlay.Ants
	end
end
