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
local GetContainerNumFreeSlots = C_Container and _G.C_Container.GetContainerNumFreeSlots or _G.GetContainerNumFreeSlots
local GetContainerNumSlots = C_Container and _G.C_Container.GetContainerNumSlots or _G.GetContainerNumSlots
local ipairs = _G.ipairs
local pairs = _G.pairs
local REAGENTBAG_CONTAINER = ( Enum.BagIndex and Enum.BagIndex.REAGENTBAG_CONTAINER ) or 5
local strjoin = _G.strjoin
local tconcat = _G.table.concat
local tinsert = _G.tinsert
local wipe = _G.wipe
--GLOBALS>

local mod = addon:NewModule('DataSource', 'ABEvent-1.0', 'ABBucket-1.0')
mod.uiName = L['LDB Plugin']
mod.uiDesc = L['Provides a LDB data source to be displayed by LDB display addons.']
mod.cannotDisable = true

local dataobj = {
	type = 'data source',
	label = addonName,
	text = addonName,
	icon = [[Interface\Buttons\Button-Backpack-Up]],
	OnClick = function(_, button)
		if button == "RightButton" then
			addon:OpenOptions()
		else
			addon:OpenAllBags()
		end
	end,
}

function mod:OnInitialize()
	self.db = addon.db:RegisterNamespace(self.moduleName, {
		profile = {
			format = 'free/total',
			showBank = true,
			mergeBags = false,
			showIcons = true,
			showTags = true,
		},
	})
end

local created = false
function mod:OnEnable()
	if not created then
		LibStub('LibDataBroker-1.1'):NewDataObject(addonName, dataobj)
		created = true
	end
	self:RegisterBucketEvent('BAG_UPDATE', 0.5, "Update")
	self:RegisterEvent('BANKFRAME_OPENED')
	self:RegisterEvent('BANKFRAME_CLOSED')
	self:Update()
end

function mod:BANKFRAME_OPENED()
	self.atBank = true
	return self:Update()
end

function mod:BANKFRAME_CLOSED()
	self.atBank = false
	return self:Update()
end

local FAMILY_ORDER = {
	0x00000, -- Regular bag
	0x00001, -- Quiver
	0x00002, -- Ammo Pouch
	0x00004, -- Soul Bag
	0x00008, -- Leatherworking Bag
	0x00010, -- Inscription Bag
	0x00020, -- Herb Bag
	0x00040, -- Enchanting Bag
	0x00080, -- Engineering Bag
	0x00100, -- Keyring
	0x00200, -- Gem Bag
	0x00400, -- Mining Bag
	0x00800, -- Reagent Bag
	0x08000, -- Tackle Box
	0x10000, -- Refrigerator
}

local size = {}
local free = {}
local data = {}

local FORMATS = {
	['free/total'] = "%1$d/%2$d",
	['inUse/total'] = "%3$d/%2$d",
	['free'] = "%1$d",
	['inUse'] = "%3$d",
}

local function BuildSpaceString(bags)
	wipe(size)
	wipe(free)
	for bag in pairs(bags) do
		local bagSize = GetContainerNumSlots(bag)
		if bagSize and bagSize > 0 then
			local bagFree, bagFamily = GetContainerNumFreeSlots(bag)
			if mod.db.profile.mergeBags then bagFamily = 0 end
			size[bagFamily] = (size[bagFamily] or 0) + bagSize
			free[bagFamily] = (free[bagFamily] or 0) + bagFree
		end
	end
	wipe(data)
	local spaceformat = FORMATS[mod.db.profile.format]
	local showIcons, showTags = mod.db.profile.showIcons, mod.db.profile.showTags
	local numIcons = 0
	for i, family in ipairs(FAMILY_ORDER) do
		if size[family] then
			local tag, icon = addon:GetFamilyTag(family)
			local text = spaceformat:format(free[family], size[family], size[family] - free[family])
			if showIcons and icon then
				numIcons = numIcons + 1 -- fix a bug with fontstring embedding several textures
				text = format("%s|T%s:0:0:0:%d:64:64:4:60:4:60|t", text, icon, -numIcons)
			elseif (showIcons or showTags) and tag then
				text = strjoin(':', tag, text)
			end
			tinsert(data, text)
		end
	end
	return tconcat(data, " ")
end

function mod:Update(event)
	local bags = BuildSpaceString(addon.BAG_IDS.BAGS)
	if self.atBank and self.db.profile.showBank then
		dataobj.text = format("%s |cff7777ff%s|r", bags, BuildSpaceString(addon.BAG_IDS.BANK))
	else
		dataobj.text = bags
	end
end

function mod:GetOptions()
	return {
		format = {
			name = L['Bag usage format'],
			desc = L['Select how bag usage should be formatted in the plugin.'],
			type = 'select',
			order = 10,
			values = {
				['free/total'] = L['Free space / total space'],
				['inUse/total'] = L['Space in use / total space'],
				['free'] = L['Free space'],
				['inUse'] = L['Space in use']
			}
		},
		showBank = {
			name = L['Show bank usage'],
			desc = L['Check this to show space at your bank in the plugin.'],
			type = 'toggle',
			order = 20,
		},
		mergeBags = {
			name = L['Merge bag types'],
			desc = L['Check this to display only one value counting all equipped bags, ignoring their type.'],
			type = 'toggle',
			order = 30,
		},
		showIcons = {
			name = L['Show bag type icons'],
			desc = L['Check this to display an icon after usage of each type of bags.'],
			type = 'toggle',
			order = 40,
			disabled = function(info) return info.handler:IsDisabled(info) or self.db.profile.mergeBags end,
		},
		showTags = {
			name = L['Show bag type tags'],
			desc = L['Check this to display an textual tag before usage of each type of bags.'],
			type = 'toggle',
			order = 50,
			disabled = function(info) return info.handler:IsDisabled(info) or self.db.profile.mergeBags end,
		},
	}, addon:GetOptionHandler(self, false, function() return self:Update() end)
end
