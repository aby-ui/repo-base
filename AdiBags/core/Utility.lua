--[[
AdiBags - Adirelle's bag addon.
Copyright 2010-2021 Adirelle (adirelle@gmail.com)
All rights reserved.

This file is part of AdiBags.

AdiBags is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

AdiBags is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with AdiBags.  If not, see <http://www.gnu.org/licenses/>.
--]]

-- Various utility functions

local addonName, addon = ...
local L = addon.L

--<GLOBALS
local _G = _G
local band = _G.bit.band
local floor = _G.floor
local GameTooltip = _G.GameTooltip
local GetContainerItemInfo = C_Container and C_Container.GetContainerItemInfo or GetContainerItemInfo
local GetContainerItemQuestInfo = C_Container and C_Container.GetContainerItemQuestInfo or GetContainerItemQuestInfo
local GetContainerNumFreeSlots = C_Container and C_Container.GetContainerNumFreeSlots or GetContainerNumFreeSlots
local geterrorhandler = _G.geterrorhandler
local GetItemFamily = _G.GetItemFamily
local GetItemInfo = _G.GetItemInfo
local ITEM_QUALITY_POOR
local ITEM_QUALITY_UNCOMMON

if addon.isRetail then
	ITEM_QUALITY_POOR = _G.Enum.ItemQuality.Poor
	ITEM_QUALITY_UNCOMMON = _G.Enum.ItemQuality.Uncommon
else
	ITEM_QUALITY_POOR = _G.LE_ITEM_QUALITY_POOR
	ITEM_QUALITY_UNCOMMON = _G.LE_ITEM_QUALITY_UNCOMMON
end

local pairs = _G.pairs
local pcall = _G.pcall
local select = _G.select
local setmetatable = _G.setmetatable
local strjoin = _G.strjoin
local strmatch = _G.strmatch
local strsplit = _G.strsplit
local strsplittable = _G.strsplittable
local tonumber = _G.tonumber
local tostring = _G.tostring
local type = _G.type

--GLOBALS>

local FAMILY_TAGS = addon.FAMILY_TAGS
local FAMILY_ICONS = addon.FAMILY_ICONS

--------------------------------------------------------------------------------
-- (bag,slot) <=> slotId conversion
--------------------------------------------------------------------------------

function addon.GetSlotId(bag, slot)
	if bag and slot then
		return bag * 100 + slot
	end
end

function addon.GetBagSlotFromId(slotId)
	if slotId then
		return floor(slotId / 100), slotId % 100
	end
end

--------------------------------------------------------------------------------
-- Safe call
--------------------------------------------------------------------------------

local function safecall_return(success, ...)
	if success then
		return ...
	else
		geterrorhandler()((...))
	end
end

function addon.safecall(funcOrSelf, argOrMethod, ...)
	local func, arg
	if type(funcOrSelf) == "table" and type(argOrMethod) == "string" then
		func, arg = funcOrSelf[argOrMethod], funcOrSelf
	else
		func, arg = funcOrSelf, argOrMethod
	end
	if type(func) == "function" then
		return safecall_return(pcall(func, arg, ...))
	end
end

--------------------------------------------------------------------------------
-- Attaching tooltip to widgets
--------------------------------------------------------------------------------

local function WidgetTooltip_OnEnter(self)
	GameTooltip:SetOwner(self, self.tooltipAnchor, self.tootlipAnchorXOffset, self.tootlipAnchorYOffset)
	self:UpdateTooltip()
end

local function WidgetTooltip_OnLeave(self)
	if GameTooltip:GetOwner() == self then
		GameTooltip:Hide()
	end
end

local function WidgetTooltip_Update(self)
	GameTooltip:ClearLines()
	addon.safecall(self, "tooltipCallback", GameTooltip)
	GameTooltip:Show()
end

function addon.SetupTooltip(widget, content, anchor, xOffset, yOffset)
	if type(content) == "string" then
		widget.tooltipCallback = function(self, tooltip)
			tooltip:AddLine(content)
		end
	elseif type(content) == "table" then
		widget.tooltipCallback = function(self, tooltip)
			tooltip:AddLine(tostring(content[1]), 1, 1, 1)
			for i = 2, #content do
				tooltip:AddLine(tostring(content[i]))
			end
		end
	elseif type(content) == "function" then
		widget.tooltipCallback = content
	else
		return
	end
	widget.tooltipAnchor = anchor or "ANCHOR_TOPLEFT"
	widget.tootlipAnchorXOffset = xOffset or 0
	widget.tootlipAnchorYOffset = yOffset or 0
	widget.UpdateTooltip = WidgetTooltip_Update
	if widget:GetScript('OnEnter') then
		widget:HookScript('OnEnter', WidgetTooltip_OnEnter)
	else
		widget:SetScript('OnEnter', WidgetTooltip_OnEnter)
	end
	if widget:GetScript('OnLeave') then
		widget:HookScript('OnLeave', WidgetTooltip_OnLeave)
	else
		widget:SetScript('OnLeave', WidgetTooltip_OnLeave)
	end
end

function addon.RemoveTooltip(widget)
	widget:SetScript('OnEnter', nil)
	widget:SetScript('OnLeave', nil)
	widget.tooltipCallback = nil
	widget.UpdateTooltip = nil
end
--------------------------------------------------------------------------------
-- Item link checking
--------------------------------------------------------------------------------

function addon.IsValidItemLink(link)
	if type(link) == "string" and (strmatch(link, "battlepet:") or strmatch(link, "keystone:") or (strmatch(link, 'item:[-:%d]+') and not strmatch(link, 'item:%d+:0:0:0:0:0:0:0:0:0'))) then
		return true
	end
end

-- ParseItemLink parses an item link for it's distinct attributes and
-- returns a table with every attribute. Updated as of retail 9.2.7.
function addon.ParseItemLink(link)
	-- Parse the first elements that have no variable length
	local _, itemID, enchantID, gemID1, gemID2, gemID3, gemID4,
	suffixID, uniqueID, linkLevel, specializationID, modifiersMask,
	itemContext, rest = strsplit(":", link, 14)

	-- The next several link items have a variable length and must be parsed
	-- out one by one. There is definitely a more clever way of doing this,
	-- but we want to optimize for readability. Blizzard has upended item links
	-- before, which would make this code diffcult to update if it's too "clever".
	local numBonusIDs
	local bonusIDs
	numBonusIDs, rest = strsplit(":", rest, 2)
	if numBonusIDs ~= "" then
		local splits = (tonumber(numBonusIDs))+1
		bonusIDs = strsplittable(":", rest, splits)
		rest = table.remove(bonusIDs, splits)
	end

	local numModifiers
	local modifierIDs
	numModifiers, rest = strsplit(":", rest, 2)
	if numModifiers ~= "" then
		local splits = (tonumber(numModifiers)*2)+1
		modifierIDs = strsplittable(":", rest, splits)
		rest = table.remove(modifierIDs, splits)
	end

	local relic1NumBonusIDs
	local relic1BonusIDs
	relic1NumBonusIDs, rest = strsplit(":", rest, 2)
	if relic1NumBonusIDs ~= "" then
		local splits = (tonumber(relic1NumBonusIDs))+1
		relic1BonusIDs = strsplittable(":", rest, splits)
		rest = table.remove(relic1BonusIDs, splits)
	end

	local relic2NumBonusIDs
	local relic2BonusIDs
	relic2NumBonusIDs, rest = strsplit(":", rest, 2)
	if relic2NumBonusIDs ~= "" then
		local splits = (tonumber(relic2NumBonusIDs))+1
		relic2BonusIDs = strsplittable(":", rest, (tonumber(relic2NumBonusIDs))+1)
		rest = table.remove(relic2BonusIDs, splits)
	end

	local relic3NumBonusIDs
	local relic3BonusIDs
	relic3NumBonusIDs, rest = strsplit(":", rest, 2)
	if relic3NumBonusIDs ~= "" then
		local splits = (tonumber(relic3NumBonusIDs))+1
		relic3BonusIDs = strsplittable(":", rest, (tonumber(relic3NumBonusIDs))+1)
		rest = table.remove(relic3BonusIDs, splits)
	end

	local crafterGUID, extraEnchantID = strsplit(":", rest, 3)

	return {
		itemID = itemID,
		enchantID = enchantID,
		gemID1 = gemID1,
		gemID2 = gemID2,
		gemID3 = gemID3,
		gemID4 = gemID4,
		suffixID = suffixID,
		uniqueID = uniqueID,
		linkLevel = linkLevel,
		specializationID = specializationID,
		modifiersMask = modifiersMask,
		itemContext = itemContext,
		bonusIDs = bonusIDs or {},
		modifierIDs = modifierIDs or {},
		relic1BonusIDs = relic1BonusIDs or {},
		relic2BonusIDs = relic2BonusIDs or {},
		relic3BonusIDs = relic3BonusIDs or {},
		crafterGUID = crafterGUID,
		extraEnchantID = extraEnchantID
	}
end

--------------------------------------------------------------------------------
-- Get distinct item IDs from item links
--------------------------------------------------------------------------------

local function __GetDistinctItemID(link)
	if not link or not addon.IsValidItemLink(link) then return end
	if strmatch(link, "battlepet:") or strmatch(link, "keystone:") then
		return link
	else
		local itemData = addon.ParseItemLink(link)
		if not itemData then return end
		local newLink
		local id = tonumber(itemData.itemID)
		local equipSlot = select(9, GetItemInfo(id))
		if equipSlot and equipSlot ~= "" and equipSlot ~= "INVTYPE_BAG" then
			-- Rebuild an item link without any unique identifiers that are out of the player's control.
			newLink = strjoin(':', '|Hitem',
			itemData.itemID, itemData.enchantID, itemData.gemID1, itemData.gemID2, itemData.gemID3, itemData.gemID4,
			itemData.suffixID, itemData.uniqueID, itemData.linkLevel, itemData.specializationID,
			itemData.modifiersMask, itemData.itemContext,
			#itemData.bonusIDs,
			table.concat(itemData.bonusIDs, ":"),
			#itemData.modifierIDs,
			table.concat(itemData.modifierIDs),
			"", -- Relic 1
			"", -- Relic 2
			"", -- Relic 3
			"", -- Crafter GUID
			itemData.extraEnchantID or "" -- Fix for non-retail.
			)
		end
		return newLink
	end
end

local distinctIDs = setmetatable({}, {__index = function(t, link)
	local result = __GetDistinctItemID(link)
	if result then
		t[link] = result
		return result
	else
		return link
	end
end})

function addon.GetDistinctItemID(link)
	return link and distinctIDs[link]
end

--------------------------------------------------------------------------------
-- Compare two links ignoring character level part
--------------------------------------------------------------------------------

function addon.IsSameLinkButLevel(a, b)
	if not a or not b then return false end

	-- take color coding, etc
	-- take itemID, enchantID, 4 gem IDs, suffixID, uniqueID (8 parts)
	-- skip linkLevel part
	-- take the rest of the link
	local linkRegExp = '(.*)(item:%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+):%-?%d+:(.*)'

	local partsA = {strmatch(a, linkRegExp)}
	local partsB = {strmatch(b, linkRegExp)}

	for i = 1, #partsA do
		if partsA[i] ~= partsB[i] then
			return false
		end
	end

	return true
end

--------------------------------------------------------------------------------
-- Basic junk test
--------------------------------------------------------------------------------

local JUNK = GetItemSubClassInfo(Enum.ItemClass.Miscellaneous, 0)
function addon:IsJunk(itemId)
	local _, _, quality, _, _, class, subclass = GetItemInfo(itemId)
	return quality == ITEM_QUALITY_POOR or (quality and quality < ITEM_QUALITY_UNCOMMON and (class == JUNK or subclass == JUNK))
end

--------------------------------------------------------------------------------
-- Convert (name, category) pair to section key and conversely
--------------------------------------------------------------------------------

local function BuildSectionKey(name, category)
	-- TODO(lobato): I think this is a bug, but I'm not sure. If the name is nil, then the category is used as the key,
	-- which leads to duplicate keys.
	assert(name ~= nil and name ~= "", "Tried to build a section key with no name. Report this to github.com/AdiAddons/AdiBags/issues please!")
	if name ~= nil then
		return strjoin('#', tostring(category or name), tostring(name))
	end
end
addon.BuildSectionKey = BuildSectionKey

local function SplitSectionKey(key)
	if key ~= nil then
		local category, name = strsplit('#', tostring(key))
		return name or category, category
	end
end
addon.SplitSectionKey = SplitSectionKey

function addon.CompareSectionKeys(a, b)
	if a and b then
		local nameA, catA = SplitSectionKey(a)
		local nameB, catB = SplitSectionKey(b)
		local orderA = addon:GetCategoryOrder(catA)
		local orderB = addon:GetCategoryOrder(catB)
		if orderA == orderB then
			if catA == catB then
				return nameA < nameB
			else
				return catA < catB
			end
		else
			return orderA > orderB
		end
	end
end

--------------------------------------------------------------------------------
-- Item and container family
--------------------------------------------------------------------------------

function addon.GetItemFamily(item)
	if (type(item) == "string" and (strmatch(item, "battlepet:") or strmatch(item, "keystone:"))) or select(9, GetItemInfo(item)) == "INVTYPE_BAG" then
		return 0
	else
		return GetItemFamily(item)
	end
end

function addon:GetFamilyTag(family)
	if family and family ~= 0 then
		for mask, tag in pairs(FAMILY_TAGS) do
			if band(family, mask) ~= 0 then
				return tag, FAMILY_ICONS[mask]
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Wrappers for GetContainerItemInfo
--------------------------------------------------------------------------------
local fieldMappings = {
	texture = {field = "iconFileID", returnSlot = 1},
	stackCount = {field = "stackCount", returnSlot = 2},
	locked = {field = "isLocked", returnSlot = 3},
	quality = {field = "quality", returnSlot = 4},
	filtered = {field = "isFiltered", returnSlot = 8},
}

local function unwrapItemInfo(field, ...)
	if not select(1, ...) then
		return
	elseif type(select(1, ...)) == "table" then
		local result = ...
		return result and result[fieldMappings[field].field]
	else
		return select(fieldMappings[field].returnSlot, ...)
	end
end

function addon:GetContainerItemLocked(containerIndex, slotIndex)
	return unwrapItemInfo("locked", GetContainerItemInfo(containerIndex, slotIndex))
end

function addon:GetContainerItemQuality(containerIndex, slotIndex)
	return unwrapItemInfo("quality", GetContainerItemInfo(containerIndex, slotIndex))
end

function addon:GetContainerItemStackCount(containerIndex, slotIndex)
	return unwrapItemInfo("stackCount", GetContainerItemInfo(containerIndex, slotIndex))
end

function addon:GetContainerItemTexture(containerIndex, slotIndex)
	return unwrapItemInfo("texture", GetContainerItemInfo(containerIndex, slotIndex))
end

function addon:GetContainerItemTextureCountLocked(containerIndex, slotIndex)
	local texture, slotCount, locked = GetContainerItemInfo(containerIndex, slotIndex)

	if texture and type(texture) == "table" then
		local result = texture
		return result.iconFileID, result.stackCount, result.isLocked
	else
		return texture, slotCount, locked
	end
end

function addon:GetContainerItemFiltered(containerIndex, slotIndex)
	return unwrapItemInfo("filtered", GetContainerItemInfo(containerIndex, slotIndex))
end

function addon:GetContainerItemQuestInfo(containerIndex, slotIndex)
	-- This function isn't present on classic-era in any form

	if C_Container then
		local result = C_Container.GetContainerItemQuestInfo(containerIndex, slotIndex)
		return result.isQuestItem, result.questID, result.isActive
	elseif GetContainerItemQuestInfo then
		return GetContainerItemQuestInfo(containerIndex, slotIndex)
	end
end
