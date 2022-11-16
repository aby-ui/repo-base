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

local ContainerFrame_GetContainerNumSlots, hooksecurefunc = ContainerFrame_GetContainerNumSlots, hooksecurefunc

----------------------------------------
-- Internal
---

-- @ Masque
local WOW_RETAIL = Core.WOW_RETAIL

-- @ Skins\Blizzard(_Classic)
local DEFAULT_SKIN = Core.DEFAULT_SKIN

-- @ Skins\Skins
local Skins = Core.Skins

-- @ Skins\Regions
local ActionTypes, AuraTypes, EmptyTypes = Core.ActionTypes, Core.AuraTypes, Core.EmptyTypes
local ItemTypes, RegTypes = Core.ItemTypes, Core.RegTypes

-- @ Core\Utility
local GetScale, GetTypeSkin = Core.GetScale, Core.GetTypeSkin

-- @ Core\Regions\Icon
local SetEmpty = Core.SetEmpty

-- @ Core\Regions\*
local SkinBackdrop, SkinCooldown, SkinFrame = Core.SkinBackdrop, Core.SkinCooldown, Core.SkinFrame
local SkinGloss, SkinIcon, SkinIconBorder = Core.SkinGloss, Core.SkinIcon, Core.SkinIconBorder
local SkinMask, SkinNewItem, SkinNormal = Core.SkinMask, Core.SkinNewItem, Core.SkinNormal
local SkinQuestBorder, SkinShadow, SkinSlotIcon = Core.SkinQuestBorder, Core.SkinShadow, Core.SkinSlotIcon
local SkinText, SkinTexture, UpdateSpellAlert = Core.SkinText, Core.SkinTexture, Core.UpdateSpellAlert

----------------------------------------
-- Locals
---

local __Empty = {}
local IsBackground = {
	[136511] = true,
	["Interface\\PaperDoll\\UI-PaperDoll-Slot-Bag"] = true,
	[4701874] = true,
	["Interface\\ContainerFrame\\BagsItemSlot2x"] = true,
}

----------------------------------------
-- Functions
---

-- Function to toggle the icon backdrops.
local function SetIconBackdrop(Button, Limit)
	local Icon = Button:GetItemButtonIconTexture()
	local Texture = Icon:GetTexture()
	local Alpha, IsEmpty = 1, nil

	if IsBackground[Texture] then
		Alpha = 0
		IsEmpty = true
	end

	Icon:SetAlpha(Alpha)
	SetEmpty(Button, IsEmpty, Limit)
end

-- Function to toggle the button art.
local function UpdateButtonArt(Button)
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

-- Function to update the textures.
local function UpdateTextures(Button, Limit)
	local Skin = Button.__MSQ_Skin

	if Skin then
		local IsEmpty
		local BagID = Button.GetBagID and Button:GetBagID()

		if BagID then
			local Size = ContainerFrame_GetContainerNumSlots(BagID)
			IsEmpty = (Size == 0) or nil
		end

		SetEmpty(Button, IsEmpty, Limit)

		local Normal = Button:GetNormalTexture()
		local Pushed = Button:GetPushedTexture()
		local Highlight = Button:GetHighlightTexture()
		local SlotHighlight = Button.SlotHighlightTexture

		local xScale, yScale = GetScale(Button)

		if Normal then
			SkinNormal(Normal, Button, Skin.Normal, Button.__MSQ_NormalColor, xScale, yScale)
		end
		if Pushed then
			SkinTexture("Pushed", Pushed, Button, Skin.Pushed, Button.__MSQ_PushedColor, xScale, yScale)
		end
		if Highlight then
			SkinTexture("Highlight", Highlight, Button, Skin.Highlight, Button.__MSQ_HighlightColor, xScale, yScale)
		end
		if SlotHighlight then
			SkinTexture("SlotHighlight", SlotHighlight, Button, Skin.SlotHighlight, Button.__MSQ_SlotHighlightColor, xScale, yScale)
		end
	end
end

----------------------------------------
-- Hooks
---

-- Hook to counter 10.0 Icon backdrops.
local function Hook_SetItemButtonTexture(Button, Texture)
	if Button.__MSQ_Exit_SetItemButtonTexture then return end

	SetIconBackdrop(Button)
end

-- Hook to counter 10.0 Action button texture changes.
local function Hook_UpdateButtonArt(Button, HideDivider)
	if Button.__MSQ_Exit_UpdateArt then return end

	UpdateButtonArt(Button)

	if not Button.__MSQ_Enabled then return end

	local Pushed, Skin = Button.PushedTexture, Button.__MSQ_Skin

	if Pushed and Skin then
		SkinTexture("Pushed", Pushed, Button, Skin.Pushed, Button.__MSQ_PushedColor, GetScale(Button))
	end
end

-- Hook to counter 10.0 HotKey position changes.
local function Hook_UpdateHotKeys(Button, ActionButtonType)
	if Button.__MSQ_Exit_UpdateHotKeys then return end

	local HotKey, Skin = Button.HotKey, Button.__MSQ_Skin

	if (HotKey and HotKey:GetText() ~= "") and Skin then
		SkinText("HotKey", HotKey, Button, Skin.HotKey, GetScale(Button))
	end
end

-- Hook to counter 10.0 Bag button texture changes.
local function Hook_UpdateTextures(Button)
	if Button.__MSQ_Exit_UpdateTextures then return end

	UpdateTextures(Button)
end

----------------------------------------
-- Core
---

-- List of methods to hook.
local Hook_Methods = {
	SetItemButtonTexture = Hook_SetItemButtonTexture,
	UpdateButtonArt = Hook_UpdateButtonArt,
	UpdateHotKeys = Hook_UpdateHotKeys,
	UpdateTextures = Hook_UpdateTextures,
}

-- Applies a skin to a button and its associated layers.
function Core.SkinButton(Button, Regions, SkinID, Backdrop, Shadow, Gloss, Colors, Scale, Pulse)
	if not Button then return end

	local bType = Button.__MSQ_bType
	local Skin, Disabled

	if SkinID then
		Skin = Skins[SkinID] or DEFAULT_SKIN
		Button.__MSQ_Skin = Skin
	else
		local Addon = Button.__MSQ_Addon or false
		Skin = Skins[Addon] or DEFAULT_SKIN
		Button.__MSQ_Skin = nil
		Disabled = true
		Pulse = true
	end

	local Enabled = not Disabled

	Button.__MSQ_Enabled = (Enabled and true) or nil
	Button.__MSQ_Scale = Scale
	Button.__MSQ_Shape = Skin.Shape

	-- Set/remove type flags.
	Button.__MSQ_IsAction = ActionTypes[bType]
	Button.__MSQ_IsAura = AuraTypes[bType]
	Button.__MSQ_IsItem = ItemTypes[bType]

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
	local FloatingBG = Button.FloatingBG or Regions.Backdrop

	if Disabled then
		Backdrop = (FloatingBG and true) or false
	end

	SkinBackdrop(Backdrop, FloatingBG, Button, Skin.Backdrop, Colors.Backdrop, xScale, yScale)

	-- Icon/SlotIcon
	if bType == "Backpack" and WOW_RETAIL then
		SkinSlotIcon(Enabled, Button, Skin.SlotIcon, xScale, yScale)
	else
		local Icon = Regions.Icon

		if Icon then
			SkinIcon(Icon, Button, Skin.Icon, xScale, yScale)
		end
	end

	-- Shadow
	Shadow = (Shadow and Enabled) or false
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

	-- Dragonflight Stuff
	if WOW_RETAIL then
		-- Toggle Icon backdrops.
		if Button.SetItemButtonTexture then
			SetIconBackdrop(Button, true)
		end

		-- Set the button art.
		if Button.UpdateButtonArt then
			UpdateButtonArt(Button)
		end

		-- Set the button art.
		if Button.UpdateTextures then
			UpdateTextures(Button, true)
		end

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
	end

	-- IconBorder
	local IconBorder = Regions.IconBorder

	if IconBorder then
		SkinIconBorder(IconBorder, Button, Skin.IconBorder, xScale, yScale)
	end

	-- Gloss
	Gloss = (Gloss and Enabled) or false
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
