--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For bug reports,
	suggestions and license information, please visit https://github.com/SFX-WoW/Masque.

	* File...: Core\Regions\SlotIcon.lua
	* Author.: StormFX

	'SlotIcon' Region

]]

local _, Core = ...

----------------------------------------
-- Lua API
---

local error, type = error, type

----------------------------------------
-- Internal
---

-- @ Core\Utility
local GetColor, GetSize, GetTexCoords = Core.GetColor, Core.GetSize, Core.GetTexCoords
local SetPoints = Core.SetPoints

-- @ Core\Regions\Mask
local SkinMask = Core.SkinMask

----------------------------------------
-- Locals
---

local DEF_TEXTURE = [[Interface\Icons\INV_Misc_Bag_08]]

----------------------------------------
-- Functions
---

-- Skins or creates the 'SlotIcon' region of a button.
local function AddSlotIcon(Button, Skin, xScale, yScale)
	local Region = Button.__MSQ_SlotIcon

	if not Region then
		Region = Button:CreateTexture()
		Button.__MSQ_SlotIcon = Region
	end

	Region:SetParent(Button)
	Region:SetTexture(Skin.Texture or DEF_TEXTURE)
	Region:SetTexCoord(GetTexCoords(Skin.TexCoords))
	Region:SetBlendMode(Skin.BlendMode or "BLEND")
	Region:SetVertexColor(GetColor(Skin.Color))
	Region:SetDrawLayer(Skin.DrawLayer or "BACKGROUND", Skin.DrawLevel or 0)
	Region:SetSize(GetSize(Skin.Width, Skin.Height, xScale, yScale))
	SetPoints(Region, Button, Skin, nil, Skin.SetAllPoints)
	SkinMask(Region, Button, Skin, xScale, yScale)
end

-- Removes the 'SlotIcon' region from a button.
local function RemoveSlotIcon(Button)
	local Region = Button.__MSQ_SlotIcon

	if Region then
		Region:SetTexture()
		Region:Hide()

		Button.__MSQ_SlotIcon = nil
	end
end

----------------------------------------
-- Core
---

-- Skins or removes a 'SlotIcon' region.
function Core.SkinSlotIcon(Enabled, Button, Skin, xScale, yScale)
	if Enabled and not Skin.Hide and Skin.Texture then
		AddSlotIcon(Button, Skin, xScale, yScale)
	else
		RemoveSlotIcon(Button)
	end
end

----------------------------------------
-- API
---

-- Retrieves the 'SlotIcon' region of a button.
function Core.API:GetSlotIcon(Button)
	if type(Button) ~= "table" then
		if Core.Debug then
			error("Bad argument to API method 'GetGloss'. 'Button' must be a button object.", 2)
		end
		return
	end

	return Button.__MSQ_SlotIcon
end
