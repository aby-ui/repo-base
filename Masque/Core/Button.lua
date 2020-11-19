--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For bug reports,
	suggestions and license information, please visit https://github.com/SFX-WoW/Masque.

	* File...: Core\Button.lua
	* Author.: StormFX, JJSheets

	Button-Skinning API

]]

local _, Core = ...

----------------------------------------
-- Lua
---

local pairs, type = pairs, type

----------------------------------------
-- Internal
---

-- @ Skins\Skins
local Skins = Core.Skins

-- @ Skins\Regions
local RegTypes = Core.RegTypes

-- @ Core\Utility
local GetScale = Core.GetScale

-- @ Core\Regions\*
local SkinBackdrop, SkinCooldown, SkinFrame = Core.SkinBackdrop, Core.SkinCooldown, Core.SkinFrame
local SkinGloss, SkinIcon, SkinIconBorder = Core.SkinGloss, Core.SkinIcon, Core.SkinIconBorder
local SkinMask, SkinNewItem, SkinNormal = Core.SkinMask, Core.SkinNewItem, Core.SkinNormal
local SkinQuestBorder, SkinShadow, SkinText = Core.SkinQuestBorder, Core.SkinShadow, Core.SkinText
local SkinTexture, UpdateSpellAlert = Core.SkinTexture, Core.UpdateSpellAlert

----------------------------------------
-- Locals
---

local __Empty = {}

----------------------------------------
-- Core
---

-- Applies a skin to a button and its associated layers.
function Core.SkinButton(Button, Regions, SkinID, Backdrop, Shadow, Gloss, Colors, Pulse)
	if not Button then return end

	local bType = Button.__MSQ_bType
	local Skin, Disabled

	if SkinID then
		Skin = Skins[SkinID] or Skins.Classic
	else
		local Addon = Button.__MSQ_Addon or false
		Skin = Skins[Addon] or Skins.Default
		Disabled = true
		Pulse = true
	end

	Button.__MSQ_Enabled = (not Disabled and true) or nil
	Button.__MSQ_Shape = Skin.Shape

	if Disabled or type(Colors) ~= "table" then
		Colors = __Empty
	end

	local xScale, yScale = GetScale(Button)

	-- Mask
	local Mask = Skin.Mask

	if Mask then
		SkinMask(nil, Button, Mask, xScale, yScale)
	end

	-- Backdrop
	local FloatingBG = Button.FloatingBG or Regions.Backdrop

	if Disabled then
		Backdrop = (FloatingBG and true) or false
	end

	SkinBackdrop(Backdrop, FloatingBG, Button, Skin.Backdrop, Colors.Backdrop, xScale, yScale)

	-- Icon
	local Icon = Regions.Icon

	if Icon then
		SkinIcon(Icon, Button, Skin.Icon, xScale, yScale)
	end

	-- Shadow
	Shadow = (Shadow and not Disabled) or false
	SkinShadow(Shadow, Button, Skin.Shadow, Colors.Shadow, xScale, yScale)

	-- Normal
	local Normal = Regions.Normal

	if Normal ~= false then
		SkinNormal(Normal, Button, Skin.Normal, Colors.Normal, xScale, yScale)
	end

	-- FontStrings and Textures
	local Layers = RegTypes[bType] or RegTypes.Legacy

	for Layer, Info in pairs(Layers) do
		if Info.Iterate then
			local Region = Regions[Layer]
			local Type = Info.Type

			if Region then
				if Type == "FontString" then
					SkinText(Layer, Region, Button, Skin[Layer], xScale, yScale)
				else
					SkinTexture(Layer, Region, Button, Skin[Layer], Colors[Layer], xScale, yScale)
				end
			end
		end
	end

	-- IconBorder
	local IconBorder = Regions.IconBorder

	if IconBorder then
		SkinIconBorder(IconBorder, Button, Skin.IconBorder, xScale, yScale)
	end

	-- Gloss
	Gloss = (Gloss and not Disabled) or false
	SkinGloss(Gloss, Button, Skin.Gloss, Colors.Gloss, xScale, yScale)

	-- NewItem
	local NewItem = Regions.NewItem

	if NewItem then
		SkinNewItem(NewItem, Button, Skin.NewItem, xScale, yScale)
	end

	-- QuestBorder
	local QuestBorder = Regions.QuestBorder

	if QuestBorder then
		SkinQuestBorder(QuestBorder, Button, Skin.QuestBorder, xScale, yScale)
	end

	-- Cooldown
	local Cooldown = Regions.Cooldown

	if Cooldown then
		SkinCooldown(Cooldown, Button, Skin.Cooldown, Colors.Cooldown, xScale, yScale, Pulse)
	end

	-- ChargeCooldown
	local Charge = Regions.ChargeCooldown or Button.chargeCooldown
	local ChargeSkin = Skin.ChargeCooldown

	Button.__MSQ_ChargeSkin = ChargeSkin

	if Charge then
		SkinCooldown(Charge, Button, ChargeSkin, nil, xScale, yScale, Pulse)
	end

	-- AutoCastShine
	local Shine = Regions.AutoCastShine

	if Shine then
		SkinFrame(Shine, Button, Skin.AutoCastShine, xScale, yScale)
	end

	-- SpellAlert
	UpdateSpellAlert(Button)
end
