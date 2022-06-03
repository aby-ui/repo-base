--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For bug reports,
	suggestions and license information, please visit https://github.com/SFX-WoW/Masque.

	* File...: Core\Regions\Frame.lua
	* Author.: StormFX

	Frame Regions

	* See Skins\Default.lua for region defaults.

]]

local _, Core = ...

----------------------------------------
-- Lua
---

local type = type

----------------------------------------
-- WoW API
---

local hooksecurefunc = hooksecurefunc

----------------------------------------
-- Internal
---

-- @ Skins\Default
local Default = Core.Skins.Default.Cooldown

-- @ Core\Utility
local GetColor, GetScale = Core.GetColor, Core.GetScale
local GetSize, SetPoints = Core.GetSize, Core.SetPoints

----------------------------------------
-- Locals
---

local DEF_COLOR = Default.Color
local DEF_PULSE = Default.PulseTexture

local MSQ_EDGE = [[Interface\AddOns\Masque\Textures\Cooldown\Edge]]
local MSQ_EDGE_LOC = [[Interface\AddOns\Masque\Textures\Cooldown\Edge-LoC]]

local MSQ_SWIPE = [[Interface\AddOns\Masque\Textures\Cooldown\Swipe]]
local MSQ_SWIPE_CIRCLE = [[Interface\AddOns\Masque\Textures\Cooldown\Swipe-Circle]]

----------------------------------------
-- Frame
---

-- Sets the size and points of a frame.
local function SkinFrame(Region, Button, Skin, xScale, yScale)
	Region:SetSize(GetSize(Skin.Width, Skin.Height, xScale, yScale))
	SetPoints(Region, Button, Skin, nil, Skin.SetAllPoints)
end

----------------------------------------
-- Hooks
---

-- Counters color changes triggered by LoC events.
local function Hook_SetSwipeColor(Region, r, g, b)
	if Region.__SwipeHook or not Region.__MSQ_Color then
		return
	end

	Region.__SwipeHook = true

	if r == 0.17 and g == 0 and b == 0 then
		Region:SetSwipeColor(0.2, 0, 0, 0.8)
	else
		Region:SetSwipeColor(GetColor(Region.__MSQ_Color))
	end

	Region.__SwipeHook = nil
end

-- Counters texture changes triggered by LoC events.
local function Hook_SetEdgeTexture(Region, Texture)
	if Region.__EdgeHook or not Region.__MSQ_Color then
		return
	end

	Region.__EdgeHook = true

	if Texture == [[Interface\Cooldown\edge-LoC]] then
		Region:SetEdgeTexture(MSQ_EDGE_LOC)
	else
		Region:SetEdgeTexture(Region.__MSQ_Edge or MSQ_EDGE)
	end

	Region.__EdgeHook = nil
end

----------------------------------------
-- Cooldown
---

-- Skins the 'Cooldown' or 'ChargeCooldown' frame of a button.
local function SkinCooldown(Region, Button, Skin, Color, xScale, yScale, Pulse)
	local bType = Button.__MSQ_bType
	Skin = Skin[bType] or Skin

	local IsRound = false

	if (Button.__MSQ_Shape == "Circle") or Skin.IsRound then
		IsRound = true
	end

	if Button.__MSQ_Enabled then
		-- Swipe
		if Region:GetDrawSwipe() then
			Region.__MSQ_Color = Color or Skin.Color or DEF_COLOR
			Region.__MSQ_Edge = Skin.EdgeTexture or MSQ_EDGE

			Region:SetSwipeTexture(Skin.Texture or (IsRound and MSQ_SWIPE_CIRCLE) or MSQ_SWIPE)
			Hook_SetSwipeColor(Region)
			Hook_SetEdgeTexture(Region)

			if not Region.__MSQ_Hooked then
				hooksecurefunc(Region, "SetSwipeColor", Hook_SetSwipeColor)
				hooksecurefunc(Region, "SetEdgeTexture", Hook_SetEdgeTexture)
				Region.__MSQ_Hooked = true
			end

		-- Edge Only
		else
			Region:SetEdgeTexture(Skin.EdgeTexture or MSQ_EDGE)
		end
	else
		Region.__MSQ_Color = nil

		if Region:GetDrawSwipe() then
			Region:SetSwipeTexture(0, 0, 0, 0.8)
		end

		Region:SetEdgeTexture([[Interface\Cooldown\edge]])
	end

	Region:SetBlingTexture(Skin.PulseTexture or DEF_PULSE)
	Region:SetDrawBling(Pulse)
	Region:SetUseCircularEdge(IsRound)
	SkinFrame(Region, Button, Skin, xScale, yScale)
end

----------------------------------------
-- ChargeCooldown
---

-- Updates the 'ChargeCooldown' frame of a button.
local function UpdateCharge(Button)
	local Region = Button.chargeCooldown
	local Skin = Button.__MSQ_ChargeSkin

	if not Region or not Skin then
		return
	end

	SkinCooldown(Region, Button, Skin, nil, GetScale(Button))

	if not Button.__MSQ_Enabled then
		Button.__MSQ_ChargeSkin = nil
	end
end

-- @ FrameXML\ActionButton.lua
hooksecurefunc("StartChargeCooldown", UpdateCharge)

----------------------------------------
-- Core
---

-- Sets the color of the 'Cooldown' region.
function Core.SetCooldownColor(Region, Button, Skin, Color)
	if Region and Button.__MSQ_Enabled then
		local bType = Button.__MSQ_bType
		Skin = Skin[bType] or Skin

		Region.__MSQ_Color = Color or Skin.Color or DEF_COLOR
		Hook_SetSwipeColor(Region)
	end
end

-- Updates the pulse effects on a button's cooldowns.
function Core.SetPulse(Button, Pulse)
	local Regions = Button.__Regions

	local Cooldown = Regions and Regions.Cooldown
	local ChargeCooldown = Regions and Regions.ChargeCooldown

	if Cooldown then
		Cooldown:SetDrawBling(Pulse)
	end
	if ChargeCooldown then
		ChargeCooldown:SetDrawBling(Pulse)
	end
end

Core.SkinFrame = SkinFrame
Core.SkinCooldown = SkinCooldown

----------------------------------------
-- API
---

-- Allows add-ons to update the 'ChargeCooldown' region when not using the native API.
function Core.API:UpdateCharge(Button)
	if type(Button) ~= "table" then
		return
	end

	UpdateCharge(Button)
end
