--[[
	This file is part of 'Masque', an add-on for World of Warcraft. For license information,
	please see the included License.txt file.

	* File...: Core\Button.lua
	* Author.: StormFX, JJSheets

]]

local _, Core = ...

-- Lua Functions
local error, hooksecurefunc, pairs, random, type = error, hooksecurefunc, pairs, random, type

-- GLOBALS: InCombatLockdown

local Skins = Core.Skins
local __MTT = {}

---------------------------------------------
-- Utility Functions
---------------------------------------------

local function GetColor(Color, Alpha)
	if type(Color) == "table" then
		return Color[1] or 1, Color[2] or 1, Color[3] or 1, Alpha or Color[4] or 1
	else
		return 1, 1, 1, Alpha or 1
	end
end
Core.GetColor = GetColor

-- Returns a set of texture coordinates.
local function GetTexCoords(Coords)
	if type(Coords) == "table" then
		return Coords[1] or 0, Coords[2] or 1, Coords[3] or 0, Coords[4] or 1
	else
		return 0, 1, 0, 1
	end
end

-- Returns the x and y scale of a button.
local function GetScale(Button)
	local x = (Button:GetWidth() or 36) / 36
	local y = (Button:GetHeight() or 36) / 36
	return x, y
end

-- Returns the height and width of a region.
local function GetSize(Width, Height, xScale, yScale)
	local w = (Width or 36) * xScale
	local h = (Height or 36) * yScale
	return w, h
end

-- Returns a random table key.
local function Random(v)
	if type(v) == "table" and #v > 1 then
		local i = random(1, #v)
		return v[i]
	end
end

---------------------------------------------
-- Backdrop Texture Layer
---------------------------------------------

local SkinBackdrop, RemoveBackdrop

do
	local Cache = {}

	-- Removes the 'Backdrop' texture from a button.
	function RemoveBackdrop(Button)
		local Region = Button.__MSQ_Background or Button.__MSQ_Backdrop
		if Region then
			Region:Hide()
			if Button.__MSQ_Backdrop then
				Cache[#Cache + 1] = Region
				Button.__MSQ_Backdrop = nil
			end
		end
	end

	-- Adds a 'Backdrop' texture to a button.
	function SkinBackdrop(Button, Skin, Color, xScale, yScale)
		local Region = Button.__MSQ_Background or Button.__MSQ_Backdrop
		if not Region then
			local i = #Cache
			if i > 0 then
				Region = Cache[i]
				Cache[i] = nil
			else
				Region = Button:CreateTexture()
			end
			Button.__MSQ_Backdrop = Region
		end
		Region:SetParent(Button.__MSQ_BaseFrame or Button)
		Region:SetTexture(Skin.Texture)
		Region:SetTexCoord(GetTexCoords(Skin.TexCoords))
		Region:SetDrawLayer("BACKGROUND", 0)
		Region:SetBlendMode(Skin.BlendMode or "BLEND")
		Region:SetVertexColor(GetColor(Color or Skin.Color))
		Region:SetSize(GetSize(Skin.Width, Skin.Height, xScale, yScale))
		Region:ClearAllPoints()
		Region:SetPoint("CENTER", Button, "CENTER", Skin.OffsetX or 0, Skin.OffsetY or 0)
		Region:Show()
	end

	-- API: Returns the 'Backdrop' layer of a button.
	function Core.API:GetBackdrop(Button)
		if type(Button) ~= "table" then
			if Core.db.profile.Debug then
				error("Bad argument to method 'GetBackdrop'. 'Button' must be a button object.", 2)
			end
			return
		end
		return Button.__MSQ_Background or Button.__MSQ_Backdrop
	end
end

---------------------------------------------
-- Icon Layer
---------------------------------------------

local function SkinIcon(Button, Region, Skin, xScale, yScale)
	Region:SetParent(Button.__MSQ_BaseFrame or Button)
	Region:SetTexCoord(GetTexCoords(Skin.TexCoords))
	Region:SetDrawLayer("BORDER", 0)
	Region:SetSize(GetSize(Skin.Width, Skin.Height, xScale, yScale))
	Region:ClearAllPoints()
	Region:SetPoint("CENTER", Button, "CENTER", Skin.OffsetX or 0, Skin.OffsetY or 0)
	-- Mask support added in 7.2. @InfusOnWoW
	if Skin.Mask then
		if not Region.__MSQ_Mask then
			Region.__MSQ_Mask = Button:CreateMaskTexture()
		end
		local Mask = Region.__MSQ_Mask
		Mask:SetTexture(Skin.Mask)
		Mask:SetSize(GetSize(Skin.MaskWidth or Skin.Width, Skin.MaskHeight or Skin.Height, xScale, yScale))
		Mask:SetPoint("CENTER", Button, "CENTER", 0, 0)
		if not Mask.active then
			Region:AddMaskTexture(Mask)
			Mask.active = true
		end
	else
		local Mask = Region.__MSQ_Mask
		if Mask and Mask.active then
			Region:RemoveMaskTexture(Mask)
			Mask.active = false
		end
	end
end

---------------------------------------------
-- Normal Texture Layer
---------------------------------------------

local SkinNormal

do
	local Base = {}

	-- Hook to catch changes to a button's 'Normal' texture.
	local function Hook_SetNormalTexture(Button, Texture)
		local Region = Button.__MSQ_NormalTexture
		local Normal = Button:GetNormalTexture()
		if Normal ~= Region then
			Normal:SetTexture("")
			Normal:Hide()
		end
		local Skin = Button.__MSQ_NormalSkin
		local Gloss = Button.__MSQ_Gloss
		if Texture == "Interface\\Buttons\\UI-Quickslot" then
			Region:SetTexture(Skin.EmptyTexture or Skin.Texture)
			Region:SetTexCoord(GetTexCoords(Skin.EmptyCoords or Skin.TexCoords))
			Region:SetVertexColor(GetColor(Skin.EmptyColor or Button.__MSQ_NormalColor))
			Button.__MSQ_Empty = true
			if Gloss then
				Gloss:Hide()
			end
		elseif Texture == "Interface\\Buttons\\UI-Quickslot2" then
			Region:SetTexture(Button.__MSQ_RandomTexture or Skin.Texture)
			Region:SetTexCoord(GetTexCoords(Skin.TexCoords))
			Region:SetVertexColor(GetColor(Button.__MSQ_NormalColor))
			Button.__MSQ_Empty = nil
			if Gloss then
				Gloss:Show()
			end
		end
	end

	-- Skins the 'Normal' layer of a button.
	function SkinNormal(Button, Region, Skin, Color, xScale, yScale)
		Region = Region or Button:GetNormalTexture()
		local Texture = Region and Region:GetTexture()
		-- Explicitly specify Static = false to enable the default states.
		if Skin.Static == false then
			if Base[Button] then
				Base[Button]:Hide()
			end
		else
			if Region then
				Region:SetTexture("")
				Region:Hide()
			end
			Region = Base[Button] or Button:CreateTexture()
			Base[Button] = Region
		end
		if not Region then return end
		Button.__MSQ_NormalTexture = Region
		-- Random Texture
		if Skin.Random then
			Button.__MSQ_RandomTexture = Random(Skin.Textures)
		else
			Button.__MSQ_RandomTexture = nil
		end
		Button.__MSQ_NormalColor = Color or Skin.Color
		if Texture == "Interface\\Buttons\\UI-Quickslot" or Button.__MSQ_Empty then
			Region:SetTexture(Skin.EmptyTexture or Skin.Texture)
			Region:SetTexCoord(GetTexCoords(Skin.EmptyCoords or Skin.TexCoords))
			Region:SetVertexColor(GetColor(Skin.EmptyColor or Button.__MSQ_NormalColor))
		else
			Region:SetTexture(Button.__MSQ_RandomTexture or Skin.Texture)
			Region:SetTexCoord(GetTexCoords(Skin.TexCoords))
			Region:SetVertexColor(GetColor(Button.__MSQ_NormalColor))
		end
		if not Button.__MSQ_NormalHook then
			hooksecurefunc(Button, "SetNormalTexture", Hook_SetNormalTexture)
			Button.__MSQ_NormalHook = true
		end
		Button.__MSQ_NormalSkin = Skin
		Region:Show()
		if Skin.Hide then
			Region:SetTexture("")
			Region:Hide()
			return
		end
		Region:SetDrawLayer("BORDER", 0)
		Region:SetBlendMode(Skin.BlendMode or "BLEND")
		Region:SetSize(GetSize(Skin.Width, Skin.Height, xScale, yScale))
		Region:ClearAllPoints()
		Region:SetPoint("CENTER", Button, "CENTER", Skin.OffsetX or 0, Skin.OffsetY or 0)
	end

	-- API: Returns the 'Normal' layer of a button.
	function Core.API:GetNormal(Button)
		if type(Button) ~= "table" then
			if Core.db.profile.Debug then
				error("Bad argument to method 'GetNormal'. 'Button' must be a button object.", 2)
			end
			return
		end
		return Button.__MSQ_NormalTexture or (Button.GetNormalTexture and Button:GetNormalTexture())
	end
end

---------------------------------------------
-- Gloss Texture Layer
---------------------------------------------

local SkinGloss, RemoveGloss

do
	local Cache = {}

	-- Removes the 'Gloss' texture from a button.
	function RemoveGloss(Button)
		local Region = Button.__MSQ_Gloss
		Button.__MSQ_Gloss = nil
		if Region then
			Region:Hide()
			Cache[#Cache+1] = Region
		end
	end

	-- Adds a 'Gloss' texture to a button.
	function SkinGloss(Button, Skin, Color, Alpha, xScale, yScale)
		local Region = Button.__MSQ_Gloss
		if not Region then
			local i = #Cache
			if i > 0 then
				Region = Cache[i]
				Cache[i] = nil
			else
				Region = Button:CreateTexture()
			end
			Button.__MSQ_Gloss = Region
		end
		Region:SetParent(Button)
		Region:SetTexture(Skin.Texture)
		Region:SetTexCoord(GetTexCoords(Skin.TexCoords))
		Region:SetDrawLayer("OVERLAY", 0)
		Region:SetBlendMode(Skin.BlendMode or "BLEND")
		Region:SetVertexColor(GetColor(Color or Skin.Color, Alpha))
		Region:SetSize(GetSize(Skin.Width, Skin.Height, xScale, yScale))
		Region:ClearAllPoints()
		Region:SetPoint("CENTER", Button, "CENTER", Skin.OffsetX or 0, Skin.OffsetY or 0)
		if Button.__MSQ_Empty then
			Region:Hide()
		else
			Region:Show()
		end
	end

	-- API: Returns the 'Gloss' layer of a button.
	function Core.API:GetGloss(Button)
		if type(Button) ~= "table" then
			if Core.db.profile.Debug then
				error("Bad argument to method 'GetGloss'. 'Button' must be a button object.", 2)
			end
			return
		end
		return Button.__MSQ_Gloss
	end
end

---------------------------------------------
-- Border Layer
---------------------------------------------

local SkinBorder

do
	-- Default Color
	local BaseColor = {0, 1, 0, 0.35}

	-- Hook to counter color changes.
	local function Hook_SetVertexColor(Region, ...)
		if Region.__ExitHook then return end
		Region.__ExitHook = true
		Region:SetVertexColor(GetColor(Region.__MSQ_Color))
		Region.__ExitHook = nil
	end

	-- Skins the Border layer.
	function SkinBorder(Button, Region, Skin, Color, xScale, yScale, IsActionButton)
		if Skin.Hide then
			Region:SetTexture("")
			Region:Hide()
			return
		end
		local Texture = Skin.Texture or Region:GetTexture()
		Region:SetTexture(Texture)
		Region:SetTexCoord(GetTexCoords(Skin.TexCoords))
		Region:SetBlendMode(Skin.BlendMode or "ADD")
		Region:SetDrawLayer("ARTWORK", 0)
		if IsActionButton then
			Region.__MSQ_Color = Color or Skin.Color or BaseColor
			if not Region.__MSQ_Hooked then
				hooksecurefunc(Region, "SetVertexColor", Hook_SetVertexColor)
				Region.__MSQ_Hooked = true
			end
			Hook_SetVertexColor(Region)
		end
		Region:SetSize(GetSize(Skin.Width, Skin.Height, xScale, yScale))
		Region:ClearAllPoints()
		Region:SetPoint("CENTER", Button, "CENTER", Skin.OffsetX or 0, Skin.OffsetY or 0)
	end
end

---------------------------------------------
-- Texture Layer
---------------------------------------------

-- Draw Layers
local Layers = {
		Flash = "ARTWORK",
		Pushed = "BACKGROUND",
		Disabled = "BORDER",
		Checked = "BORDER",
		AutoCastable = "OVERLAY",
		Highlight = "HIGHLIGHT",
}

local SkinTexture

do
	-- Draw Levels
	local Levels = {
		Flash = 0,
		Pushed = 0,
		Disabled = 1,
		Checked = 2,
		AutoCastable = 1,
		Highlight = 0,
	}

	-- Skins a texture layer.
	function SkinTexture(Button, Region, Layer, Skin, Color, xScale, yScale)
		if Skin.Hide then
			Region:SetTexture("")
			Region:Hide()
			return
		end
		local Texture = Skin.Texture or Region:GetTexture()
		Region:SetTexture(Texture)
		Region:SetTexCoord(GetTexCoords(Skin.TexCoords))
		Region:SetBlendMode(Skin.BlendMode or "BLEND")
		Region:SetDrawLayer(Layers[Layer], Levels[Layer])
		Region:SetVertexColor(GetColor(Color or Skin.Color))
		Region:SetSize(GetSize(Skin.Width, Skin.Height, xScale, yScale))
		Region:ClearAllPoints()
		Region:SetPoint("CENTER", Button, "CENTER", Skin.OffsetX or 0, Skin.OffsetY or 0)
	end
end

---------------------------------------------
-- Text Layer
---------------------------------------------

local SkinText

-- Horizontal Justification
local Justify = {
	Name = "CENTER",
	Count = "RIGHT",
	Duration = "CENTER",
	HotKey = "RIGHT",
}

do
	-- Point
	local Point = {
		Name = "BOTTOM",
		Count = "BOTTOMRIGHT",
		Duration = "TOP",
	}

	-- Relative Point
	local RelPoint = {
		Name = "BOTTOM",
		Count = "BOTTOMRIGHT",
		Duration = "BOTTOM",
	}

	-- Hook to counter add-ons that call HotKey.SetPoint after Masque has skinned the region.
	local function Hook_SetPoint(Region, ...)
		if Region.__ExitHook then return end
		Region.__ExitHook = true
		local Skin = Region.__MSQ_Skin
		Region:SetPoint("TOPLEFT", Region.__MSQ_Button, "TOPLEFT", Skin.OffsetX or 0, Skin.OffsetY or 0)
		Region.__ExitHook = nil
	end

	-- Skins a text layer.
	function SkinText(Button, Region, Layer, Skin, Color, xScale, yScale)
		Region:SetJustifyH(Skin.JustifyH or Justify[Layer])
		Region:SetJustifyV(Skin.JustifyV or "MIDDLE")
		Region:SetDrawLayer("OVERLAY")
		Region:SetSize(GetSize(Skin.Width, Skin.Height or 10, xScale, yScale))
		Region:ClearAllPoints()
		if Layer == "HotKey" then
			Region.__MSQ_Button = Button
			Region.__MSQ_Skin = Skin
			if not Region.__MSQ_Hooked then
				hooksecurefunc(Region, "SetPoint", Hook_SetPoint)
				Region.__MSQ_Hooked = true
			end
			Hook_SetPoint(Region)
		else
			Region:SetVertexColor(GetColor(Color or Skin.Color))
			Region:SetPoint(Point[Layer], Button, RelPoint[Layer], Skin.OffsetX or 0, Skin.OffsetY or 0)
		end
	end
end

---------------------------------------------
-- Cooldown Frame Layer
---------------------------------------------

local SkinCooldown

do
	local BaseColor = {0, 0, 0, 0.8}

	-- Hook to counter unwanted changes.
	local function Hook_SetSwipeColor(Region, ...)
		if Region.__ExitHook then return end
		Region.__ExitHook = true
		Region:SetSwipeColor(GetColor(Region.__MSQ_Color))
		Region.__ExitHook = nil
	end

	-- Skins the Cooldown frame.
	function SkinCooldown(Button, Region, Skin, Color, xScale, yScale)
		if Skin.Hide then
			Region:Hide()
			return
		end
		if Region.SetSwipeTexture then
			Region:SetSwipeTexture(Skin.Texture or "")
		end
		if Region.SetSwipeColor then
			Region.__MSQ_Color = Color or Skin.Color or BaseColor
			if not Region.__MSQ_Hooked then
				hooksecurefunc(Region, "SetSwipeColor", Hook_SetSwipeColor)
				Region.__MSQ_Hooked = true
			end
			Hook_SetSwipeColor(Region)
		end
		Region:SetSize(GetSize(Skin.Width, Skin.Height, xScale, yScale))
		Region:ClearAllPoints()
		Region:SetPoint("CENTER", Button, "CENTER", Skin.OffsetX or 0, Skin.OffsetY or 0)
	end
end

---------------------------------------------
-- Frame Layer
---------------------------------------------

-- Skins an animation frame.
local function SkinFrame(Button, Region, Skin, xScale, yScale, Color)
	if Skin.Hide then
		Region:Hide()
		return
	end
	Region:SetSize(GetSize(Skin.Width, Skin.Height, xScale, yScale))
	Region:ClearAllPoints()
	Region:SetPoint("CENTER", Button, "CENTER", Skin.OffsetX or 0, Skin.OffsetY or 0)
end

---------------------------------------------
-- Charge Cooldown
---------------------------------------------

-- Skins the ChargeCooldown.
local function UpdateCharge(Button)
	local Charge = Button.chargeCooldown
	local Skin = Button.__MSQ_ChargeSkin
	if not Charge or not Charge.parent or not Skin then return end
	local xScale, yScale = GetScale(Button)
	SkinFrame(Button, Charge, Skin, xScale, yScale)
end
hooksecurefunc("StartChargeCooldown", UpdateCharge)

-- API: Allows add-ons to call the update when not using the native API.
function Core.API:UpdateCharge(Button)
	if type(Button) ~= "table" then
		return
	end
	UpdateCharge(Button)
end

---------------------------------------------
-- Spell Alert
---------------------------------------------

local UpdateSpellAlert

do
	local Alerts = {
		Square = {
			Glow = "Interface\\SpellActivationOverlay\\IconAlert",
			Ants = "Interface\\SpellActivationOverlay\\IconAlertAnts",
		},
		Circle = {
			Glow = "Interface\\AddOns\\Masque\\Textures\\IconAlert-Circle",
			Ants = "Interface\\AddOns\\Masque\\Textures\\IconAlertAnts-Circle",
		},
	}

	-- Hook to update the spell alert animation.
	function UpdateSpellAlert(Button)
		local Overlay = Button.overlay
		if (not Overlay) or (not Overlay.spark) then return end
		if Overlay.__MSQ_Shape ~= Button.__MSQ_Shape then
			local Shape = Button.__MSQ_Shape
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
			Overlay.__MSQ_Shape = Button.__MSQ_Shape
		end
	end
	hooksecurefunc("ActionButton_ShowOverlayGlow", UpdateSpellAlert)

	-- API: Allows add-ons to call the update when not using the native API.
	function Core.API:UpdateSpellAlert(Button)
		if type(Button) ~= "table" then
			return
		end
		UpdateSpellAlert(Button)
	end

	-- API: Adds a spell alert texture set.
	function Core.API:AddSpellAlert(Shape, Glow, Ants)
		if type(Shape) ~= "string" then
			if Core.db.profile.Debug then
				error("Bad argument to method 'AddSpellAlert'. 'Shape' must be a string.", 2)
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

	-- API: Returns a spell alert texture set.
	function Core.API:GetSpellAlert(Shape)
		if type(Shape) ~= "string" then
			if Core.db.profile.Debug then
				error("Bad argument to method 'GetSpellAlert'. 'Shape' must be a string.", 2)
			end
			return
		end
		local Overlay = Alerts[Shape]
		if Overlay then
			return Overlay.Glow, Overlay.Ants
		end
	end
end

---------------------------------------------
-- Button Skinning Function
---------------------------------------------

do
	-- Hook to automatically adjust the button's additional frame levels.
	local function Hook_SetFrameLevel(Button, Level)
		local base = Level or Button:GetFrameLevel()
		if base < 3 then base = 3 end
		if Button.__MSQ_BaseFrame then
			Button.__MSQ_BaseFrame:SetFrameLevel(base - 2)
		end
		if Button.__MSQ_Cooldown then
			Button.__MSQ_Cooldown:SetFrameLevel(base - 1)
		end
		if Button.__MSQ_Shine then
			Button.__MSQ_Shine:SetFrameLevel(base + 1)
		end
	end

	-- Applies a skin to a button and its associated layers.
	function Core.SkinButton(Button, ButtonData, SkinID, Gloss, Backdrop, Colors, IsActionButton)
		if not Button then return end
		if not Button.__MSQ_BaseFrame then
			Button.__MSQ_BaseFrame = CreateFrame("Frame", nil, Button)
		end
		local Skin = (SkinID and Skins[SkinID]) or Skins["Blizzard"]
		if type(Colors) ~= "table" then
			Colors = __MTT
		end
		local xScale, yScale = GetScale(Button)
		-- Backdrop
		Button.__MSQ_Background = ButtonData.FloatingBG
		if type(Gloss) ~= "number" then
			Gloss = (Gloss and 1) or 0
		end
		if Backdrop and not Skin.Backdrop.Hide then
			SkinBackdrop(Button, Skin.Backdrop, Colors.Backdrop, xScale, yScale)
		else
			RemoveBackdrop(Button)
		end
		-- Icon
		local Icon = ButtonData.Icon
		if Icon then
			SkinIcon(Button, Icon, Skin.Icon, xScale, yScale)
		end
		-- Normal
		local Normal = ButtonData.Normal
		if Normal ~= false then
			SkinNormal(Button, Normal, Skin.Normal, Colors.Normal, xScale, yScale)
		end
		-- Border
		local Border = ButtonData.Border
		if Border then
			SkinBorder(Button, Border, Skin.Border, Colors.Border, xScale, yScale, IsActionButton)
		end
		-- Textures
		for Layer in pairs(Layers) do
			local Region = ButtonData[Layer]
			if Region then
				SkinTexture(Button, Region, Layer, Skin[Layer], Colors[Layer], xScale, yScale)
			end
		end
		-- Gloss
		if Gloss > 0 and not Skin.Gloss.Hide then
			SkinGloss(Button, Skin.Gloss, Colors.Gloss, Gloss, xScale, yScale)
		else
			RemoveGloss(Button)
		end
		-- Text
		for Layer in pairs(Justify) do
			local Region = ButtonData[Layer]
			if Region then
				SkinText(Button, Region, Layer, Skin[Layer], Colors[Layer], xScale, yScale)
			end
		end
		-- Cooldown
		local Cooldown = ButtonData.Cooldown
		if Cooldown then
			Button.__MSQ_Cooldown = Cooldown
			SkinCooldown(Button, Cooldown, Skin.Cooldown, Colors.Cooldown, xScale, yScale)
		end
		-- Charge Cooldown
		local Charge = Button.chargeCooldown
		Button.__MSQ_ChargeSkin = Skin.ChargeCooldown or Skin.Cooldown
		if Charge then
			SkinFrame(Button, Charge, Button.__MSQ_ChargeSkin, xScale, yScale)
		end
		-- Shine (AutoCast)
		local Shine = ButtonData.Shine
		if Shine then
			Button.__MSQ_Shine = Shine
			SkinFrame(Button, Shine, Skin.Shine, xScale, yScale)
		end
		-- Spell Alert
		Button.__MSQ_Shape = Skin.Shape
		if Button:GetObjectType() == "CheckButton" then
			UpdateSpellAlert(Button)
		end
		-- Frame Level
		if not Button.__MSQ_FrameHook then
			hooksecurefunc(Button, "SetFrameLevel", Hook_SetFrameLevel)
			Button.__MSQ_FrameHook = true
		end
		-- Taint protection, just in case.
		if Button.IsProtected and Button:IsProtected() and InCombatLockdown() then
			return
		end
		local level = Button:GetFrameLevel()
		if level < 4 then
			level = 4
		end
		Button:SetFrameLevel(level)
	end
end
