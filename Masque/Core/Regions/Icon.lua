--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For bug reports,
	suggestions and license information, please visit https://github.com/SFX-WoW/Masque.

	* File...: Core\Regions\Icon.lua
	* Author.: StormFX

	'Icon' Region

	* See Skins\Default.lua for region defaults.

]]

local _, Core = ...

----------------------------------------
-- Lua API
---

local error, type = error, type

----------------------------------------
-- WoW API
---

local hooksecurefunc = hooksecurefunc

----------------------------------------
-- Internal
---

-- @ Core\Utility
local GetSize, GetTexCoords, SetPoints = Core.GetSize, Core.GetTexCoords, Core.SetPoints
local GetTypeSkin = Core.GetTypeSkin

-- @ Core\Regions\Mask
local SkinMask = Core.SkinMask

-- @ Core\Regions\Normal
local UpdateNormal = Core.UpdateNormal

----------------------------------------
-- SetEmpty
---

-- Sets a button's empty state and updates its regions.
local function SetEmpty(Button, IsEmpty, Limit)
	IsEmpty = (IsEmpty and true) or nil
	Button.__MSQ_Empty = IsEmpty

	local Shadow = Button.__MSQ_Shadow
	local Gloss = Button.__MSQ_Gloss

	if IsEmpty then
		if Shadow then Shadow:Hide() end
		if Gloss then Gloss:Hide() end
	else
		if Shadow then Shadow:Show() end
		if Gloss then Gloss:Show() end
	end

	if not Limit then
		UpdateNormal(Button, IsEmpty)
	end
end

----------------------------------------
-- Hooks
---

-- Types of buttons to hook.
local IconHook = {
	Action = true,
	Pet = true,
}

-- We don't need to hook these in Retail. 
-- @ Core\Button Hooks
if not Core.WOW_RETAIL then
	IconHook.BagSlot = true
	IconHook.Item = true
end

-- Sets a button's empty state to empty.
local function Hook_Hide(Region)
	local Button = Region.__MSQ_Button
	if not Button then return end

	SetEmpty(Button, true)
end

-- Sets a button's empty state to not empty.
local function Hook_Show(Region)
	local Button = Region.__MSQ_Button
	if not Button then return end

	SetEmpty(Button)
end

----------------------------------------
-- Core
---

Core.SetEmpty = SetEmpty

-- Skins the 'Icon' region of a button.
function Core.SkinIcon(Region, Button, Skin, xScale, yScale)
	local bType = Button.__MSQ_bType

	Button.__MSQ_Icon = Region
	Region.__MSQ_Button = Button

	-- Skin
	Skin = GetTypeSkin(Button, bType, Skin)

	Region:SetParent(Button)
	Region:SetTexCoord(GetTexCoords(Skin.TexCoords))
	Region:SetDrawLayer(Skin.DrawLayer or "BACKGROUND", Skin.DrawLevel or 0)
	Region:SetSize(GetSize(Skin.Width, Skin.Height, xScale, yScale, Button))
	SetPoints(Region, Button, Skin, nil, Skin.SetAllPoints)

	-- Mask
	SkinMask(Region, Button, Skin, xScale, yScale)

	if not Button.__MSQ_Enabled then
		Region.__MSQ_Button = nil
	end

	if Button.__MSQ_EmptyType then
		-- Empty Status
		local IsEmpty = not Region:IsShown() or Region:GetAlpha() == 0
		SetEmpty(Button, IsEmpty)

		-- Hooks
		if IconHook[bType] and not Region.__MSQ_Hooked then
			hooksecurefunc(Region, "Hide", Hook_Hide)
			hooksecurefunc(Region, "Show", Hook_Show)
			Region.__MSQ_Hooked = true
		end
	end
end

----------------------------------------
-- API
---

-- Sets the button's empty status.
function Core.API:SetEmpty(Button, IsEmpty)
	if type(Button) ~= "table" then
		if Core.db.profile.Debug then
			error("Bad argument to API method 'SetEmpty'. 'Button' must be a button object.", 2)
		end
		return
	end

	SetEmpty(Button, IsEmpty)
end
