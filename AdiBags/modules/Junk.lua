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
local format = _G.format
local GameTooltip = _G.GameTooltip
local GetItemInfo = _G.GetItemInfo
local hooksecurefunc = _G.hooksecurefunc
local IsAddOnLoaded = _G.IsAddOnLoaded
local ITEM_QUALITY_POOR
local ITEM_QUALITY_UNCOMMON
if addon.isRetail then
	ITEM_QUALITY_POOR = _G.Enum.ItemQuality.Poor
	ITEM_QUALITY_UNCOMMON = _G.Enum.ItemQuality.Uncommon
else
	ITEM_QUALITY_POOR = _G.LE_ITEM_QUALITY_POOR
	ITEM_QUALITY_UNCOMMON = _G.LE_ITEM_QUALITY_UNCOMMON
end
local print = _G.print
local select = _G.select
local setmetatable = _G.setmetatable
local tonumber = _G.tonumber
local type = _G.type
local UseContainerItem = C_Container and _G.C_Container.UseContainerItem or _G.UseContainerItem
local wipe = _G.wipe
--GLOBALS>

local JUNK = GetItemSubClassInfo(_G.Enum.ItemClass.Miscellaneous, 0)
local JUNK_KEY = addon.BuildSectionKey(JUNK, JUNK)

local mod = addon:RegisterFilter("Junk", 85, "ABEvent-1.0", "AceHook-3.0")
mod.uiName = JUNK
mod.uiDesc = L['Put items of poor quality or labeled as junk in the "Junk" section.']

local DEFAULTS = {
	profile = {
		sources = { ['*'] = true },
		include = {},
		exclude = {
			[  6948] = true, -- Hearthstone
			[110560] = true, -- Garrison Hearhstone
			[140192] = true, -- Dalaran Hearthstone
		},
	},
}

local prefs

local cache = setmetatable({}, { __index = function(t, itemId)
	local isJunk = mod:CheckItem(itemId)
	t[itemId] = isJunk
	return isJunk
end})

function mod:OnInitialize()
	self.db = addon.db:RegisterNamespace(self.moduleName, DEFAULTS)
	prefs = self.db.profile
end

function mod:OnEnable()
	prefs = self.db.profile
	self:RegisterMessage('AdiBags_OverrideFilter')
	self:Hook(addon, 'IsJunk')
	wipe(cache)
	addon.RegisterSectionHeaderScript(self, 'OnTooltipUpdate', 'OnTooltipUpdateSectionHeader')
	addon.RegisterSectionHeaderScript(self, 'OnClick', 'OnClickSectionHeader')
	if not self.hooked then
		if IsAddOnLoaded('Scrap_Merchant') then
			self:ADDON_LOADED('OnEnable', 'Scrap_Merchant')
		else
			self:RegisterEvent('ADDON_LOADED')
		end
	end
end

function mod:ADDON_LOADED(_, name)
	if name ~= 'Scrap_Merchant' then return end
	self:UnregisterEvent('ADDON_LOADED')
	self:HookScrap()
	self.hooked = true
end

function mod:OnDisable()
	addon.UnregisterAllSectionHeaderScripts(self)
end

function mod:BaseCheckItem(itemId, force)
	local _, _, quality, _, _, class, subclass = GetItemInfo(itemId)
	if ((force or prefs.sources.lowQuality) and quality == ITEM_QUALITY_POOR)
		or ((force or prefs.sources.junkCategory) and quality and quality < ITEM_QUALITY_UNCOMMON and (class == JUNK or subclass == JUNK)) then
		return true
	end
	return false
end

function mod:ExtendedCheckItem(itemId, force)
	return false
end

function mod:CheckItem(itemId)
	if not itemId then
		return false
	elseif not GetItemInfo(itemId) then
		return nil -- Should cause to rescan later
	elseif prefs.exclude[itemId] then
		return false
	elseif prefs.include[itemId] then
		return true
	elseif self:BaseCheckItem(itemId) then
		return true
	elseif self:ExtendedCheckItem(itemId) then
		return true
	end
	return false
end

function mod:IsJunk(_, itemId)
	return tonumber(itemId) and cache[tonumber(itemId)] or false
end

function mod:Filter(slotData)
	return cache[slotData.itemId] and JUNK or nil
end

function mod:AdiBags_OverrideFilter(event, section, category, ...)
	local changed = false
	local include, exclude = prefs.include, prefs.exclude
	for i = 1, select('#', ...) do
		local id = select(i, ...)
		local incFlag, exclFlag
		if section == JUNK and category == JUNK then
			incFlag = not self:BaseCheckItem(id, true) or nil
		else
			exclFlag = (self:BaseCheckItem(id, true) or self:ExtendedCheckItem(id, true)) and true or nil
		end
		if include[id] ~= incFlag or exclude[id] ~= exclFlag then
			include[id], exclude[id] = incFlag, exclFlag
			changed = true
		end
	end
	if changed then
		self:Update()
	end
end

function mod:Update()
	wipe(cache)
	self:SendMessage('AdiBags_FiltersChanged')
	local acr = LibStub('AceConfigRegistry-3.0', true)
	if acr then
		acr:NotifyChange(addonName)
	end
end

function mod:OnTooltipUpdateSectionHeader(_, header, tooltip)
	if header.section:GetKey() ~= JUNK_KEY then
		return
	end
	if addon:GetInteractingWindow() == "MERCHANT" then
		tooltip:AddLine(L['Right-click to sell these items.'])
	end
	tooltip:AddLine(L['Alt-right-click to configure the Junk module.'])
end

function mod:OnClickSectionHeader(_, header, button)
	if header.section:GetKey() ~= JUNK_KEY or button ~= "RightButton" then
		return
	end
	if IsAltKeyDown() then
		mod:OpenOptions()
	elseif addon:GetInteractingWindow() == "MERCHANT" then
		local stacks = 0
		for slotId, bag, slot, itemId in header.section:IterateContainerSlots() do
			local sellPrice = select(11, GetItemInfo(itemId))
			if sellPrice and sellPrice > 0 then
				UseContainerItem(bag, slot)
				stacks = stacks + 1
			end
		end
		if stacks == 0 then
			print(format("|cfffee00%s %s: %s|r", addonName, JUNK, L['Nothing to sell.']))
		end
	end
end

-- Options

local sourceList = {
	lowQuality = L['Low quality items'],
	junkCategory = L['Junk category'],
}
function mod:GetOptions()
	local handler = addon:GetOptionHandler(self, false, function() return self:Update() end)

	function handler:ListItems(info)
		return prefs[info[#info]]
	end

	function handler:SetItem(info, key, value)
		return self:Set(info, key, value and true or nil)
	end

	local function True() return true end

	return {
		sources = {
			type = 'multiselect',
			name = L['Included categories'],
			values = sourceList,
			order = 10,
		},
		include = {
			type = 'multiselect',
			width = 'full',
			dialogControl = 'ItemList',
			name = L['Include list'],
			desc = L['Items in this list are always considered as junk. Click an item to remove it from the list.'],
			order = 20,
			values = 'ListItems',
			get = True,
			set = 'SetItem',
		},
		exclude = {
			type = 'multiselect',
			width = 'full',
			dialogControl = 'ItemList',
			name = L['Exclude list'],
			desc = L['Items in this list are never considered as junk. Click an item to remove it from the list.'],
			order = 30,
			values = 'ListItems',
			get = True,
			set = 'SetItem',
		},
	}, handler
end

-- Third-party addon support

local Scrap = _G.Scrap
local BrainDead = LibStub('AceAddon-3.0'):GetAddon('BrainDead', true)

if Scrap and type(Scrap.IsJunk) == "function" then
	-- Scrap support

	function mod:ExtendedCheckItem(itemId, force)
		return (force or prefs.sources.Scrap) and Scrap:IsJunk(itemId)
	end

	local function hook()
		if prefs.sources.Scrap then
			wipe(cache)
			addon:SendMessage("AdiBags_FiltersChanged")
		end
	end

	if Scrap.HookScript then
		-- Fallback support for older versions; no longer a ScriptObject.
		Scrap:HookScript('OnReceiveDrag', hook)
	end

	if Scrap.ToggleJunk then
		hooksecurefunc(Scrap, 'ToggleJunk', hook)
	end

	function mod:HookScrap()
		if Scrap.Merchant then
			Scrap.Merchant:HookScript('OnReceiveDrag', hook)
		end
	end

	sourceList.Scrap = "Scrap"

elseif BrainDead then
	-- BrainDead support

	local SellJunk = BrainDead:GetModule('SellJunk')

	function mod:ExtendedCheckItem(itemId, force)
		return (force or prefs.sources.BrainDead) and SellJunk.db.profile.items[itemId]
	end

	sourceList.BrainDead = "BrainDead"
end
