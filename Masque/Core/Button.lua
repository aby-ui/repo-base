--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For bug reports,
	suggestions and license information, please visit https://github.com/SFX-WoW/Masque.

	* File...: Core\Button.lua
	* Author.: StormFX, JJSheets

	Button-Skinning API

]]

local _, Core = ...

----------------------------------------
-- Lua API
---

local pairs, type = pairs, type

----------------------------------------
-- WoW API
---

local hooksecurefunc = hooksecurefunc

----------------------------------------
-- Internal
---

-- @ Masque
local WOW_RETAIL = Core.WOW_RETAIL

-- @ Skins\Default(_Classic)
local DEFAULT_SKIN = Core.DEFAULT_SKIN

-- @ Skins\Skins
local Skins = Core.Skins

-- @ Skins\Regions
local ActionTypes, AuraTypes, EmptyTypes = Core.ActionTypes, Core.AuraTypes, Core.EmptyTypes
local ItemTypes, RegTypes = Core.ItemTypes, Core.RegTypes

-- @ Core\Utility
local GetScale, GetTypeSkin = Core.GetScale, Core.GetTypeSkin

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

-- Function to toggle the button art.
local function SetButtonArt(Button)
	local SlotArt, SlotBackground = Button.SlotArt, Button.SlotBackground

	if Button.__MSQ_Enabled then
		if SlotArt then
			SlotArt:SetTexture()
			SlotArt:Hide()
		end
		if SlotBackground then
			SlotBackground:SetTexture()
			SlotBackground:Hide()
		end
	else
		if SlotArt then
			SlotArt:SetAtlas("UI-HUD-ActionBar-IconFrame-Slot")
		end
		if SlotBackground then
			SlotBackground:SetAtlas("UI-HUD-ActionBar-IconFrame-Background")
		end
	end
end

-- Hook to counter 10.0 `Action` button texture changes.
local function Hook_UpdateArt(Button, HideDivider)
	if Button.__MSQ_Exit_UpdateArt then return end

	SetButtonArt(Button)

	if not Button.__MSQ_Enabled then return end

	local Pushed, Skin = Button.PushedTexture, Button.__MSQ_Skin

	if Pushed and Skin then
		SkinTexture("Pushed", Pushed, Skin.Pushed, Button, Button.__MSQ_PushedColor, GetScale(Button))
	end
end

-- Hook to counter 10.0 `HotKey` position changes.
local function Hook_UpdateHotKeys(Button, ActionButtonType)
	if Button.__MSQ_Exit_UpdateHotKeys then return end

	local HotKey, Skin = Button.HotKey, Button.__MSQ_Skin

	if (HotKey and HotKey:GetText() ~= "") and Skin then
		SkinText("HotKey", HotKey, Button, Skin.HotKey, GetScale(Button))
	end
end

-- Hook to counter 10.0 `Bag` button texture changes.
local function Hook_UpdateTextures(Button)
	if Button.__MSQ_Exit_UpdateTextures then return end

	local Skin = Button.__MSQ_Skin

	if Skin then
		local Pushed = Button:GetPushedTexture()
		local Highlight = Button:GetHighlightTexture()
		local SlotHighlight = Button.SlotHighlightTexture

		local xScale, yScale = GetScale(Button)

		if Pushed then
			SkinTexture("Pushed", Pushed, Skin.Pushed, Button, Button.__MSQ_PushedColor, xScale, yScale)
		end
		if Highlight then
			SkinTexture("Highlight", Highlight, Skin.Highlight, Button, Button.__MSQ_HighlightColor, xScale, yScale)
		end
		if SlotHighlight then
			SkinTexture("SlotHighlight", SlotHighlight, Skin.SlotHighlight, Button, Button.__MSQ_SlotHighlightColor, xScale, yScale)
		end
	end
end

-- List of methods to hook.
local Hook_Methods = {
	UpdateArt = Hook_UpdateArt,
	UpdateHotKeys = Hook_UpdateHotKeys,
	UpdateTextures = Hook_UpdateTextures,
}

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
		Button.__MSQ_Skin = Skin
	else
		local Addon = Button.__MSQ_Addon or false
		Skin = Skins[Addon] or DEFAULT_SKIN
		Button.__MSQ_Skin = nil
		Disabled = true
		Pulse = true
	end

	Button.__MSQ_Enabled = (not Disabled and true) or nil
	Button.__MSQ_Shape = Skin.Shape

	-- Set/remove type flags.
	Button.__MSQ_IsAction = ActionTypes[bType]
	Button.__MSQ_IsAura = AuraTypes[bType]
	Button.__MSQ_IsItem = ItemTypes[bType]

	-- Flag Retail `Action` buttons.
	Button.__MSQ_ReSize = (WOW_RETAIL and ActionTypes[bType]) or nil

	local EmptyType = EmptyTypes[bType]
	Button.__MSQ_EmptyType = EmptyType

	if Disabled or type(Colors) ~= "table" then
		Colors = __Empty
	end

	local xScale, yScale = GetScale(Button)

	-- Mask
	local Mask = Skin.Mask

	if Mask then
		if type(Mask) == "table" then
			Mask = GetTypeSkin(Button, bType, Mask)
		end

		SkinMask(nil, Button, Mask, xScale, yScale)
	end

	-- Backdrop
	-- * Only buttons that can be seen while empty need backdrops.
	if EmptyType then
		local FloatingBG = Button.FloatingBG or Regions.Backdrop

		if Disabled then
			Backdrop = (FloatingBG and true) or false
		end

		SkinBackdrop(Backdrop, FloatingBG, Button, Skin.Backdrop, Colors.Backdrop, xScale, yScale)
	end

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

	-- Set the button art.
	SetButtonArt(Button)

	-- Hooks
	for Method, Hook in pairs(Hook_Methods) do
		if Button[Method] then
			local Key = "__MSQ_"..Method
			local ExitKey = "__MSQ_Exit_"..Method

			if Disabled then
				Button[ExitKey] = true
			else
				if not Button[Key] then
					hooksecurefunc(Button, Method, Hook)
					Button[Key] = true
				end

				Button[ExitKey] = nil
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
