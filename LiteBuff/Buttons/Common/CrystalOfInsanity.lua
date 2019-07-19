------------------------------------------------------------
-- CrystalOfInsanity.lua
--
-- Abin
-- 2013/9/20
------------------------------------------------------------

local _, addon = ...
local L = addon.L

local AURA_NAME = GetSpellInfo(127230)
local CONFLICTS = addon:BuildSpellList(nil, 127230, 105689, 105691, 105693, 105694, 105696, 242551, 188031, 188034, 188035, 188033, 251839, 251837, 251836, 251838, 298841, 298836, 298837, 298839).conflicts

local crystalName, crystalLink

local button = addon:CreateActionButton("CrystalOfInsanity", L["crystal of insanity"], nil, 3600, "PLAYER_AURA", "ITEM")
button:SetItem(147707)
button:RequireItem(147707)
button:SetFlyProtect("type", "item")
button.icon.text:Hide()

LibItemQuery:QueryItem(147707, button, 1)

function button:OnItemInfoReceived(itemId, name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture)
	self:SetAttribute("item", name)
	crystalName = name
	crystalLink = "|cff0070dd"..name.."|r"
	self.icon:SetIcon(texture)
end

function button:OnTooltipTitle(tooltip)
	if crystalLink then
		tooltip:AddLine(crystalLink)
	end
end

function button:OnTooltipLeftText(tooltip)
	if crystalLink then
		tooltip:AddLine(L["left click"]..L["use"]..crystalLink, 1, 1, 1, 1)
	end
end

function button:OnUpdateTimer(spell)
	local conflict
	local expires = addon:GetUnitBuffTimer("player", AURA_NAME)
	if expires then
		return 1, expires
	end

	local other, icon
	for other, icon in pairs(CONFLICTS) do
		expires = addon:GetUnitBuffTimer("player", other)
		if expires then
			conflict = icon
			break
		end
	end

	self:SetConflictIcon(conflict)
	return (expires or conflict) and "NONE" or "R", expires
end