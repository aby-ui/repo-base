--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For license information,
	please see the included License.txt file or visit https://github.com/StormFX/Masque.

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
local GetSize, SetPoints = Core.GetSize, Core.SetPoints
local GetColor, GetScale = Core.GetColor, Core.GetScale

----------------------------------------
-- Locals
---

local DEF_COLOR = Default.Color

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
		Region:SetEdgeTexture(MSQ_EDGE)
	end

	Region.__EdgeHook = nil
end

----------------------------------------
-- Cooldown
---

-- Skins the 'Cooldown' or 'ChargeCooldown' frame of a button.
local function SkinCooldown(Region, Button, Skin, Color, xScale, yScale)
	local bType = Button.__MSQ_bType
	Skin = (bType and Skin[bType]) or Skin

	local UseCircle = Button.__MSQ_Shape == "Circle"

	if Button.__MSQ_Enabled then
		if Region:GetDrawSwipe() then
			Region.__MSQ_Color = Color or Skin.Color or DEF_COLOR

			Region:SetSwipeTexture(Skin.Texture or (UseCircle and MSQ_SWIPE_CIRCLE) or MSQ_SWIPE)
			Hook_SetSwipeColor(Region)
			Hook_SetEdgeTexture(Region)

			if not Region.__MSQ_Hooked then
				hooksecurefunc(Region, "SetSwipeColor", Hook_SetSwipeColor)
				hooksecurefunc(Region, "SetEdgeTexture", Hook_SetEdgeTexture)
				Region.__MSQ_Hooked = true
			end
		else
			Region:SetEdgeTexture(MSQ_EDGE)
		end
	else
		Region.__MSQ_Color = nil

		if Region:GetDrawSwipe() then
			Region:SetSwipeTexture(0, 0, 0, 0.8)
		end

		Region:SetEdgeTexture([[Interface\Cooldown\edge]])
	end

	Region:SetUseCircularEdge(UseCircle)
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
