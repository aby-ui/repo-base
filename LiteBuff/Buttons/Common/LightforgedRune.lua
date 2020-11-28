--if UnitLevel("player") > 119 then return end
------------------------------------------------------------
-- copy from CrystalOfInsanity.lua by 163ui 2017/10
-- modified for 8.3 by abyui 2020/03
------------------------------------------------------------
if UnitLevel("player") > 59 then return end

local _, addon = ...
local L = addon.L

local AURA_NAME = GetSpellInfo(317065)
local CONFLICTS = addon:BuildSpellList(nil, 270058) --addon:BuildSpellList(nil, 127230, 105689, 105691, 105693, 105694, 105696, 242551).conflicts

local itemName, itemLink

local button = addon:CreateActionButton("LightforgedRune", L["Lightning-Forged Augment Rune"], nil, 3600, "PLAYER_AURA", "ITEM")
button:SetItem(174906) --160053
button:RequireItem(174906)
button:SetFlyProtect("type", "item")
button.icon.text:Hide()

LibItemQuery:QueryItem(174906, button, 1)

function button:OnItemInfoReceived(itemId, name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture)
	self:SetAttribute("item", name)
	itemName = name
	itemLink = "|cff0070dd"..name.."|r"
	self.icon:SetIcon(texture)
end

function button:OnTooltipTitle(tooltip)
	if itemLink then
		tooltip:AddLine(itemLink)
	end
end

function button:OnTooltipLeftText(tooltip)
	if itemLink then
		tooltip:AddLine(L["left click"]..L["use"].. itemLink, 1, 1, 1, 1)
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