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

local addonName, addon = ...
local L = addon.L

--<GLOBALS
local _G = _G
local ceil = _G.ceil
local CreateFont = _G.CreateFont
local CreateFrame = _G.CreateFrame
local floor = _G.floor
local format = _G.format
local GetItemInfo = _G.GetItemInfo
local ipairs = _G.ipairs
local max = _G.max
local min = _G.min
local next = _G.next
local pairs = _G.pairs
local setmetatable = _G.setmetatable
local strjoin = _G.strjoin
local strsplit = _G.strsplit
local tinsert = _G.tinsert
local tostring = _G.tostring
local tsort = _G.table.sort
local wipe = _G.wipe
--GLOBALS>

local BuildSectionKey = addon.BuildSectionKey

local ITEM_SIZE = addon.ITEM_SIZE
local ITEM_SPACING = addon.ITEM_SPACING
local SECTION_SPACING = addon.SECTION_SPACING
local SLOT_OFFSET = ITEM_SIZE + ITEM_SPACING
local HEADER_SIZE = addon.HEADER_SIZE

--------------------------------------------------------------------------------
-- Section ordering
--------------------------------------------------------------------------------

local categoryOrder = {
	[L["Free space"]] = -100,
	[L["Reagent Free space"]] = -101
}

function addon:SetCategoryOrder(name, order)
	categoryOrder[name] = order
end

function addon:SetCategoryOrders(t)
	for name, order in pairs(t) do
		categoryOrder[name] = order
	end
end

function addon:IterateCategories()
	return pairs(categoryOrder)
end

function addon:GetCategoryOrder(name)
	return categoryOrder[name] or 0
end

--------------------------------------------------------------------------------
-- Initialization and release
--------------------------------------------------------------------------------

local sectionClass, sectionProto = addon:NewClass("Section", "Frame", "ABEvent-1.0")
local sectionPool = addon:CreatePool(sectionClass, "AcquireSection")

function sectionProto:OnCreate()
	self.buttons = {}
	self.slots = {}
	self.freeSlots = {}

	local header = CreateFrame("Button", nil, self)
	header.section = self
	header:SetNormalFontObject(addon.sectionFont)
	header:SetPoint("TOPLEFT", 0, 0)
	header:SetPoint("TOPRIGHT", SECTION_SPACING - ITEM_SPACING, 0)
	header:SetHeight(HEADER_SIZE)
	header:EnableMouse(true)
	header:SetText("DUMMY")
	header:GetFontString():SetAllPoints()
	addon.SetupTooltip(header, function(header, tooltip) return self:ShowHeaderTooltip(header, tooltip) end, "ANCHOR_NONE")
	self.Header = header
	self:SendMessage('AdiBags_SectionCreated', self)

	self:SetScript('OnShow', self.OnShow)
	self:SetScript('OnHide', self.OnHide)
end

function sectionProto:OnShow()
	for button in pairs(self.buttons) do
		button:Show()
	end
end

function sectionProto:OnHide()
	for button in pairs(self.buttons) do
		button:Hide()
	end
end

function sectionProto:ToString()
	return format("Section[%q,%q]", tostring(self.name), tostring(self.category))
end

function sectionProto:OnAcquire(container, name, category)
	self:SetParent(container)
	self.name = name
	self.category = category or name
	self.key = BuildSectionKey(name, category)
	self:SetSizeInSlots(0, 0)
	self.count = 0
	self.container = container
	self:RegisterMessage('AdiBags_OrderChanged', 'FullLayout')
	self.Header:SetText(self.name)
	self:UpdateHeaderScripts()
end

function sectionProto:OnRelease()
	wipe(self.freeSlots)
	wipe(self.slots)
	wipe(self.buttons)
	self.name = nil
	self.category = nil
	self.container = nil
end

function sectionProto:GetOrder()
	return self.category and categoryOrder[self.category] or 0
end

function sectionProto:GetKey()
	return self.key
end

function sectionProto:IsCollapsed()
	return addon.db.char.collapsedSections[self.key]
end

function sectionProto:SetCollapsed(collapsed)
	collapsed = not not collapsed
	if addon.db.char.collapsedSections[self.key] ~= collapsed then
		addon.db.char.collapsedSections[self.key] = collapsed
		if collapsed then
			self:Hide()
		else
			self:Show()
		end
		self:SendMessage('AdiBags_LayoutChanged')
	end
end

--------------------------------------------------------------------------------
-- Section hooks
--------------------------------------------------------------------------------

local scriptDispatcher = LibStub('CallbackHandler-1.0'):New(addon, 'RegisterSectionHeaderScript', 'UnregisterSectionHeaderScript', 'UnregisterAllSectionHeaderScripts')

local DispatchOnClick = function(...) return scriptDispatcher:Fire('OnClick', ...) end
local DispatchOnReceiveDrag = function(...) return scriptDispatcher:Fire('DispatchOnReceiveDrag', ...) end

function sectionProto:ShowHeaderTooltip(header, tooltip)
	local self = header.section
	tooltip:SetPoint("BOTTOMRIGHT", self.container, "TOPRIGHT", 0, 4)
	if self.category ~= self.name then
		tooltip:AddDoubleLine(self.name, "("..self.category..")", 1, 1, 1)
	else
		tooltip:AddLine(self.name, 1, 1, 1)
	end
	scriptDispatcher:Fire('OnTooltipUpdate', header, tooltip)
end

local usedScripts = {}

function sectionProto:UpdateHeaderScripts()
	local header = self.Header
	if usedScripts.OnClick and not header:GetScript('OnClick') then
		header:SetScript('OnClick', DispatchOnClick)
		header:RegisterForClicks("AnyUp")
	elseif not usedScripts.OnClick and header:GetScript('OnClick') then
		header:SetScript('OnClick', nil)
		header:RegisterForClicks()
	end
	if usedScripts.OnReceiveDrag and not header:GetScript('OnReceiveDrag') then
		header:SetScript('OnReceiveDrag', DispatchOnReceiveDrag)
	elseif not usedScripts.OnReceiveDrag and header:GetScript('OnReceiveDrag') then
		header:SetScript('OnReceiveDrag', nil)
	end
end

function scriptDispatcher:OnUsed(_, name)
	if name == "OnClick" or name == "OnReceiveDrag" or name == "OnTooltipUpdate" then
		addon:Debug('Used SectionHeaderScript', name)
		usedScripts[name] = true
		for section in sectionPool:IterateActiveObjects() do
			section:UpdateHeaderScripts()
		end
	end
end

function scriptDispatcher:OnUnused(_, name)
	if name == "OnClick" or name == "OnReceiveDrag" or name == "OnTooltipUpdate" then
		addon:Debug('Used SectionHeaderScript', name)
		usedScripts[name] = nil
		for section in sectionPool:IterateActiveObjects() do
			section:UpdateHeaderScripts()
		end
	end
end

--------------------------------------------------------------------------------
-- Button handling
--------------------------------------------------------------------------------

function sectionProto:AddItemButton(slotId, button)
	if self.buttons[button] then
		return
	end
	button:SetSection(self)
	self.count = self.count + 1
	self.buttons[button] = slotId
	if self:IsCollapsed() then
		return button:Hide()
	end
	local index = next(self.freeSlots)
	if not index then
		return button:Hide()
	end
	self:PutButtonAt(button, index)
	button:Show()
end

function sectionProto:RemoveItemButton(button)
	if not self.buttons[button] then
		return
	end
	local index = self.slots[button]
	if index and index <= self.total then
		self.freeSlots[index] = true
	end
	self.count = self.count - 1
	self.slots[button] = nil
	self.buttons[button] = nil
	if button:GetSection() == self then
		button:SetSection(nil)
	end
end

function sectionProto:Clear()
	for button in pairs(self.buttons) do
		button:SetSection(nil)
	end
end

function sectionProto:IsEmpty()
	return self.count == 0
end

--------------------------------------------------------------------------------
-- Iterating
--------------------------------------------------------------------------------

function sectionProto:IterateContainerSlots()
	local button, iter, data
	return function(_, previous)
		while true do
			if not iter then
				button = next(self.buttons, button)
				if not button then
					return
				end
				iter, data, previous = button:IterateSlots()
			end
			local slotId, bag, slot, itemId, count = iter(data, previous)
			if slotId then
				return slotId, bag, slot, itemId, count
			end
			iter, data, previous = nil
		end
	end
end

--------------------------------------------------------------------------------
-- Layout
--------------------------------------------------------------------------------

function sectionProto:PutButtonAt(button, index)
	local oldIndex = self.slots[button]
	if oldIndex ~= index then
		if oldIndex then
			self.freeSlots[oldIndex] = true
		end
		self.slots[button] = index
		self.freeSlots[index] = nil
	end
	if self.width == 0 then return end
	local row, col = floor((index-1) / self.width), (index-1) % self.width
	button:SetPoint("TOPLEFT", self, "TOPLEFT", col * SLOT_OFFSET, - HEADER_SIZE - row * SLOT_OFFSET)
end

function sectionProto:SetSizeInSlots(width, height)
	if self.width == width and self.height == height then return end
	self.width, self.height, self.total = width, height, width * height

	if width == 0 or height == 0 then
		self:SetSize(0.5, 0.5)
	else
		self:SetSize(
			SLOT_OFFSET * width - ITEM_SPACING,
			HEADER_SIZE + SLOT_OFFSET * height - ITEM_SPACING
		)
	end
	self:Debug('SetSizeInSlots', width, height, '=>', self:GetSize())
	return true
end

function sectionProto:SetHeaderOverflow(overflow)
	if self.headerOverflow ~= overflow then
		self.headerOverflow = overflow
		if overflow then
			self.Header:SetPoint("TOPRIGHT", SECTION_SPACING, 0)
		else
			self.Header:SetPoint("TOPRIGHT", 0, 0)
		end
	end
end

function sectionProto:Layout()
	-- NOOP
end

local CompareButtons
local buttonOrder = {}
function sectionProto:FullLayout()
	if not self:IsVisible() then
		return
	elseif self:IsCollapsed() then
		return self:Hide()
	end

	for button in pairs(self.buttons) do
		button:Show()
		tinsert(buttonOrder, button)
	end
	tsort(buttonOrder, CompareButtons)

	self:Debug('FullLayout', #buttonOrder, 'buttons')

	local slots, freeSlots = self.slots, self.freeSlots
	wipe(freeSlots)
	wipe(slots)
	for index, button in ipairs(buttonOrder) do
		self:PutButtonAt(button, index)
	end
	for index = self.count + 1, self.total do
		freeSlots[index] = true
	end

	wipe(buttonOrder)
end

--------------------------------------------------------------------------------
-- Item sorting
--------------------------------------------------------------------------------

local EQUIP_LOCS = {
	INVTYPE_AMMO = 0,
	INVTYPE_HEAD = 1,
	INVTYPE_NECK = 2,
	INVTYPE_SHOULDER = 3,
	INVTYPE_BODY = 4,
	INVTYPE_CHEST = 5,
	INVTYPE_ROBE = 5,
	INVTYPE_WAIST = 6,
	INVTYPE_LEGS = 7,
	INVTYPE_FEET = 8,
	INVTYPE_WRIST = 9,
	INVTYPE_HAND = 10,
	INVTYPE_FINGER = 11,
	INVTYPE_TRINKET = 13,
	INVTYPE_CLOAK = 15,
	INVTYPE_WEAPON = 16,
	INVTYPE_SHIELD = 17,
	INVTYPE_2HWEAPON = 16,
	INVTYPE_WEAPONMAINHAND = 16,
	INVTYPE_WEAPONOFFHAND = 17,
	INVTYPE_HOLDABLE = 17,
	INVTYPE_RANGED = 18,
	INVTYPE_THROWN = 18,
	INVTYPE_RANGEDRIGHT = 18,
	INVTYPE_RELIC = 18,
	INVTYPE_TABARD = 19,
	INVTYPE_BAG = 20,
}

local sortingFuncs = {

	default = function(linkA, linkB, nameA, nameB)
		local _, _, qualityA, levelA, _, classA, subclassA, _, equipSlotA = GetItemInfo(linkA)
		local _, _, qualityB, levelB, _, classB, subclassB, _, equipSlotB = GetItemInfo(linkB)
		local equipLocA = EQUIP_LOCS[equipSlotA or ""]
		local equipLocB = EQUIP_LOCS[equipSlotB or ""]
		if equipLocA and equipLocB and equipLocA ~= equipLocB then
			return equipLocA < equipLocB
		elseif classA ~= classB then
			return classA < classB
		elseif subclassA ~= subclassB then
			return subclassA < subclassB
		elseif qualityA ~= qualityB then
			return qualityA > qualityB
		elseif levelA ~= levelB then
			return levelA > levelB
		else
			return nameA < nameB
		end
	end,

	byName = function(linkA, linkB, nameA, nameB)
		return nameA < nameB
	end,

	byQualityAndLevel = function(linkA, linkB, nameA, nameB)
		local _, _, qualityA, levelA = GetItemInfo(linkA)
		local _, _, qualityB, levelB = GetItemInfo(linkB)
		if qualityA ~= qualityB then
			return qualityA > qualityB
		elseif levelA ~= levelB then
			return levelA > levelB
		else
			return nameA < nameB
		end
	end,

}

local currentSortingFunc = sortingFuncs.default

local itemCompareCache = setmetatable({}, {
	__index = function(t, key)
		local linkA, linkB = strsplit(';', key, 2)
		local nameA, nameB = GetItemInfo(linkA), GetItemInfo(linkB)
		if nameA and nameB then
			local result = currentSortingFunc(linkA, linkB, nameA, nameB)
			t[key] = result
			return result
		else
			return linkA < linkB
		end
	end
})

function addon:SetSortingOrder(order)
	local func = sortingFuncs[order]
	if func and func ~= currentSortingFunc then
		self:Debug('SetSortingOrder', order, func)
		currentSortingFunc = func
		wipe(itemCompareCache)
		self:SendMessage('AdiBags_OrderChanged')
	end
end

function CompareButtons(a, b)
	local linkA, linkB = a:GetItemLink(), b:GetItemLink()
	if linkA and linkB then
		if linkA ~= linkB then
			return itemCompareCache[format("%s;%s", linkA, linkB)]
		else
			return a:GetCount() > b:GetCount()
		end
	elseif not linkA and not linkB then
		local famA, famB = a:GetBagFamily(), b:GetBagFamily()
		if famA and famB and famA ~= famB then
			return famA < famB
		end
	end
	return (linkA and 1 or 0) > (linkB and 1 or 0)
end
