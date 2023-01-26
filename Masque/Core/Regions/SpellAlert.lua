--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For bug reports,
	suggestions and license information, please visit https://github.com/SFX-WoW/Masque.

	* File...: Core\Regions\SpellAlert.lua
	* Author.: StormFX

	'SpellAlert' Region

	* TODO: Improve the textures.

]]

local _, Core = ...

----------------------------------------
-- Lua API
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
	-- Retail: Button.SpellActivationAlert
	-- Classic: Button.overlay
	local Region = Button.SpellActivationAlert or Button.overlay

	if not Region or not Region.spark then
		return
	end

	local Shape = Button.__MSQ_Shape

	if Region.__MSQ_Shape ~= Shape then
		local Glow, Ants

		if Shape and Alerts[Shape] then
			Glow = Alerts[Shape].Glow or Alerts.Square.Glow
			Ants = Alerts[Shape].Ants or Alerts.Square.Ants
		else
			Glow = Alerts.Square.Glow
			Ants = Alerts.Square.Ants
		end

		Region.innerGlow:SetTexture(Glow)
		Region.innerGlowOver:SetTexture(Glow)
		Region.outerGlow:SetTexture(Glow)
		Region.outerGlowOver:SetTexture(Glow)
		Region.spark:SetTexture(Glow)
		Region.ants:SetTexture(Ants)

		Region.__MSQ_Shape = Shape
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

	local Region = Alerts[Shape] or {}

	if type(Glow) == "string" then
		Region.Glow = Glow
	end

	if type(Ants) == "string" then
		Region.Ants = Ants
	end

	Alerts[Shape] = Region
end

-- Retrieves a 'SpellAlert' texture set.
function API:GetSpellAlert(Shape)
	if type(Shape) ~= "string" then
		if Core.Debug then
			error("Bad argument to API method 'GetSpellAlert'. 'Shape' must be a string.", 2)
		end
		return
	end

	local Region = Alerts[Shape]

	if Region then
		return Region.Glow, Region.Ants
	end
end
