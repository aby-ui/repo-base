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
local CLOSE = _G.CLOSE
local ClearCursor = _G.ClearCursor
local CreateFrame = _G.CreateFrame
local GetCursorInfo = _G.GetCursorInfo
local GetItemInfo = _G.GetItemInfo
local IsAltKeyDown = _G.IsAltKeyDown
local ToggleDropDownMenu = _G.ToggleDropDownMenu
local UIDropDownMenu_AddButton = _G.UIDropDownMenu_AddButton
local format = _G.format
local gsub = _G.gsub
local ipairs = _G.ipairs
local pairs = _G.pairs
local select = _G.select
local setmetatable = _G.setmetatable
local strmatch = _G.strmatch
local strsplit = _G.strsplit
local strtrim = _G.strtrim
local tinsert = _G.tinsert
local tonumber = _G.tonumber
local tostring = _G.tostring
local tremove = _G.tremove
local tsort = _G.table.sort
local type = _G.type
local unpack = _G.unpack
local wipe = _G.wipe
--GLOBALS>

local BuildSectionKey = addon.BuildSectionKey
local SplitSectionKey = addon.SplitSectionKey

local JUNK, FREE_SPACE, REAGENT_FREE_SPACE = GetItemSubClassInfo(_G.Enum.ItemClass.Miscellaneous, 0), L["Free space"], L["Reagent Free space"]
local JUNK_KEY, FREE_SPACE_KEY, REAGENT_FREE_SPACE_KEY = BuildSectionKey(JUNK, JUNK), BuildSectionKey(FREE_SPACE, FREE_SPACE), BuildSectionKey(REAGENT_FREE_SPACE, REAGENT_FREE_SPACE)

local mod = addon:RegisterFilter("FilterOverride", 95, "ABEvent-1.0")
mod.uiName = L['Manual filtering']
mod.uiDesc = L['Allow you manually redefine the section in which an item should be put. Simply drag an item on the section title.']

function mod:OnInitialize()

	-- This module was named "mod" for quite a while, retrieve the old data if they exists
	if addon.db.sv.namespaces and addon.db.sv.namespaces.mod ~= nil then
		addon.db.sv.namespaces[self.moduleName] = addon.db.sv.namespaces.mod
		addon.db.sv.namespaces.mod = nil
	end

	self.db = addon.db:RegisterNamespace(self.moduleName, { profile = { version = 0, overrides = {} } })
	self.db.RegisterCallback(self, "UpgradeProfile")
	self:UpgradeProfile()
end

function mod:UpgradeProfile()
	if self.db.profile.version < 2 then
		local overrides = self.db.profile.overrides
		-- Backup the old filters
		local backup, changed = {}, false
		-- Convert old section#category "tuple" to a section key using the common utility function
		for itemId, oldKey in pairs(overrides) do
			backup[itemId] = oldKey
			local section, category = strsplit('#', oldKey)
			if addon:GetCategoryOrder(category) == 0 and addon:GetCategoryOrder(section) ~= 0 then
				-- It seems the section is a category but the category is not, swap them
				section, category = category, section
			end
			local newKey = BuildSectionKey(section, category)
			if newKey ~= oldKey then
				overrides[itemId] = newKey
				changed = true
			end
		end
		if changed then
			addon:Print("Custom filters upgraded. Old values are still available in the SV file AdiBags.lua.")
			if not self.db.profile.backups then
				self.db.profile.backups = {}
			end
			tinsert(self.db.profile.backups, backup)
		end
		self.db.profile.version = 2
	end
	if self.db.profile.version < 3 then
		local overrides = self.db.profile.overrides
		for itemId, key in pairs(overrides) do
			if key == FREE_SPACE_KEY or REAGENT_FREE_SPACE_KEY then
				overrides[itemId] = nil
			end
		end
		self.db.profile.version = 3
	end
end

function mod:OnEnable()
	self:UpdateOptions()
	if addon.isRetail or addon.isWrath then
		self:RegisterEvent('CURSOR_CHANGED')
	else
		self:RegisterEvent('CURSOR_UPDATE', 'CURSOR_CHANGED')
	end
	addon.RegisterSectionHeaderScript(self, 'OnTooltipUpdate', 'OnTooltipUpdateSectionHeader')
	addon.RegisterSectionHeaderScript(self, 'OnClick', 'OnClickSectionHeader')
	self:CURSOR_CHANGED()
end

function mod:OnDisable()
	addon.UnregisterAllSectionHeaderScripts(self)
end

function mod:Filter(slotData)
	local override = self.db.profile.overrides[slotData.itemId]
	if override then
		return SplitSectionKey(override)
	end
end

function mod:AssignItems(section, category, ...)
	local key = section and BuildSectionKey(section, category) or nil
	for i = 1, select('#', ...) do
		local itemId = select(i, ...)
		mod.db.profile.overrides[itemId] = key
	end
	self:SendMessage('AdiBags_OverrideFilter', section, category, ...)
	self:SendMessage('AdiBags_FiltersChanged')
	local acr = LibStub('AceConfigRegistry-3.0', true)
	if acr then
		acr:NotifyChange(addonName)
	end
end

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

-- Replaced by something more useful when the options are initialized
mod.UpdateOptions = function() end
mod.OptionPreselectItem = mod.UpdateOptions

local options
function mod:GetOptions()
	if options then return options end

	local categoryValues = {}
	for name in addon:IterateCategories() do
		if name ~= FREE_SPACE or REAGENT_FREE_SPACE then
			categoryValues[name] = name
		end
	end

	local function GetItemId(str)
		if type(str) == "string" and strmatch(str, "battlepet:") then
			return 82800 -- Official item (Pet Cage)
		elseif type(str) == "string" and strmatch(str, "keystone:") then
			return 138019 -- Official item (Mythic Keystone)
		elseif str then
			local link = select(2, GetItemInfo(str))
			return link and tonumber(link:match("item:(%d+)"))
		end
	end

	local t = {}
	local handlerProto = setmetatable({
		SetItemAssoc = function(self, section, category)
			wipe(t)
			for itemId in pairs(self.values) do
				tinsert(t, itemId)
			end
			local n = #t
			if n > 0 then
				-- Filter with a lot of items will cause some upvalue errors in CallbackHandler
				-- so assign items by batches of 20
				for i = 1, n, 20 do
					mod:AssignItems(section, category, unpack(t, i, min(i + 19, n)))
				end
				wipe(t)
				mod:UpdateOptions(self.category, category)
			end
		end,
		GetName = function(self) return self.name end,
		SetName = function(self, info, input) return self:SetItemAssoc(input, self.category) end,
		ValidateName = function(self, info, input) return type(input) == "string" and strtrim(input) ~= "" end,
		GetCategory = function(self) return self.category end,
		SetCategory = function(self, info, input) return self:SetItemAssoc(self.name, input) end,
		ListCategories = function() return categoryValues end,
		Remove = function(self) return self:SetItemAssoc() end,
		ValidateItem = function(self, info, input) return not not GetItemId(input) end,
		AddItem = function(self, info, input, ...)
			mod:AssignItems(self.name, self.category, GetItemId(input))
			mod:UpdateOptions()
		end,
		SetItem = function(self, info, itemId, value)
			if value then
				mod:AssignItems(self.name, self.category, itemId)
			else
				mod:AssignItems(nil, nil, itemId)
			end
			mod:UpdateOptions(self.category)
		end,
		ListItems = function(self)
			wipe(self.values)
			for itemId, key in pairs(mod.db.profile.overrides) do
				if key == self.key then
					self.values[itemId] = true
				end
			end
			return self.values
		end,
	}, { __index = addon:GetOptionHandler(self) })
	local handlerMeta = { __index = handlerProto }

	local optionProto = {
		type = 'group',
		inline = true,
		args = {
			name = {
				name = L['Section'],
				type = 'input',
				order = 10,
				get = 'GetName',
				set = 'SetName',
				validate = 'ValidateName',
			},
			category = {
				name = L['Category'],
				type = 'select',
				order = 20,
				get = 'GetCategory',
				set = 'SetCategory',
				values = 'ListCategories',
			},
			remove = {
				name = L['Remove'],
				type = 'execute',
				order = 30,
				confirm = true,
				confirmText = L['Are you sure you want to remove this section ?'],
				func = 'Remove',
			},
			items = {
				name = L['Items'],
				desc = L['Click on a item to remove it from the list. You can drop an item on the empty slot to add it to the list.'],
				type = 'multiselect',
				width = 'full',
				dialogControl = 'ItemList',
				order = 40,
				get = function() return true end,
				set = 'SetItem',
				values = 'ListItems',
			},
		},
	}
	local optionMeta = { __index = optionProto }
	local sectionHeap = {}
	local categories = {}
	local categoryHeap = {}

	local AceConfigDialog = LibStub('AceConfigDialog-3.0')
	mod.UpdateOptions = function(self, selectCategory, fallbackSelectCategory)
		for category, categoryGroup in pairs(categories) do
			options[category] = nil
			for _, sectionGroup in pairs(categoryGroup.args) do
				wipe(sectionGroup.handler.values)
				tinsert(sectionHeap, sectionGroup)
			end
			wipe(categoryGroup.args)
			tinsert(categoryHeap, categoryGroup)
		end
		wipe(categories)
		for itemId, override in pairs(self.db.profile.overrides) do
			local section, category = SplitSectionKey(override)
			local categoryGroup = categories[category]
			if not categoryGroup then
				categoryGroup = tremove(categoryHeap)
				if not categoryGroup then
					categoryGroup = { name = category, type = 'group', args = {} }
				end
				categoryGroup.name, categoryGroup.order = category, addon:GetCategoryOrder(category)
				categories[category] = categoryGroup
				options[category] = categoryGroup
			end
			local key = gsub(section, "%W", "")
			local sectionGroup = categoryGroup.args[key]
			if not sectionGroup then
				sectionGroup = tremove(sectionHeap)
				if not sectionGroup then
					sectionGroup = setmetatable({handler = setmetatable({values = {}}, handlerMeta)}, optionMeta)
				end
				sectionGroup.name = section
				sectionGroup.handler.key = override
				sectionGroup.handler.name = section
				sectionGroup.handler.category = category
				categoryGroup.args[key] = sectionGroup
			end
		end
		if selectCategory or fallbackSelectCategory then
			if options[selectCategory] then
				AceConfigDialog:SelectGroup(addonName, "filters", mod.filterName, selectCategory)
			elseif options[fallbackSelectCategory] then
				AceConfigDialog:SelectGroup(addonName, "filters", mod.filterName, fallbackSelectCategory)
			else
				AceConfigDialog:SelectGroup(addonName, "filters", mod.filterName)
			end
		end
	end

	local newItemId, newSection, newCategory
	options = {
		newAssoc = {
			type = 'group',
			name = L["New Override"],
			desc = L["Use this section to define any item-section association."],
			order = 10,
			inline = true,
			args = {
				item = {
					type = 'input',
					name = L['Item'],
					desc = L["Enter the name, link or itemid of the item to associate with the section. You can also drop an item into this box."],
					order = 10,
					get = function() return newItemId and select(2, GetItemInfo(newItemId)) end,
					set = function(_, value) newItemId = GetItemId(value) end,
					validate = function(_, value) return not not GetItemId(value) end,
				},
				section = {
					type = 'input',
					name = L['Section'],
					desc = L["Enter the name of the section to associate with the item."],
					order = 20,
					get = function() return newSection end,
					set = function(_, value) newSection = value end,
					validate = function(_, value) return value and value:trim() ~= "" end,
				},
				category = {
					type = 'select',
					name = L['Section category'],
					desc = L["Select the category of the section to associate. This is used to group sections together."],
					order = 30,
					get = function() return newCategory end,
					set = function(_, value) newCategory = value end,
					values = categoryValues,
				},
				add = {
					type = 'execute',
					name = L['Add association'],
					desc = L["Click on this button to create the new association."],
					order = 40,
					func = function()
						mod:AssignItems(newSection, newCategory, newItemId)
						mod:UpdateOptions(newCategory)
						newItemId, newCategory, newSection = nil, nil, nil
					end,
					disabled = function()
						return not newItemId or not newSection or not newCategory
					end,
				},
			},
		},
	}

	local AceConfigRegistry = LibStub('AceConfigRegistry-3.0')
	function mod:OptionPreselectItem(section, category, itemId)
		newItemId, newSection, newCategory = itemId, section, category
		AceConfigRegistry:NotifyChange(addonName)
	end

	mod:UpdateOptions()

	return options
end

--------------------------------------------------------------------------------
-- Section header menu
--------------------------------------------------------------------------------

local FilterDropDownMenu_Initialize
do
	local function Assign(_, key, itemId, checked)
		local section, category = SplitSectionKey(key)
		if checked then
			mod:AssignItems(nil, nil, itemId)
		else
			mod:AssignItems(section, category, itemId)
		end
		ClearCursor()
	end

	local function NewSection(_, key, itemId)
		local section, category = SplitSectionKey(key)
		mod:OpenOptions()
		mod:OptionPreselectItem(section, category, itemId)
		ClearCursor()
	end

	local info = {}
	local sections = {}
	function FilterDropDownMenu_Initialize(self, level)
		if not level then return end

		local itemId, header = self.itemId, self.header
		local container = header.section.container

		-- Title
		wipe(info)
		info.isTitle = true
		local _, link = GetItemInfo(itemId)
		info.text =  format(L['Assign %s to ...'], link)
		info.notCheckable = true
		UIDropDownMenu_AddButton(info, level)

		-- Get section from
		wipe(sections)
		container:GetSectionKeys(true, sections)

		-- Add customized sections
		for id, key in pairs(mod.db.profile.overrides) do
			if not sections[key] then
				sections[key] = true
				tinsert(sections, key)
			end
		end

		-- Sort sections
		tsort(sections, addon.CompareSectionKeys)

		-- Build the section list
		local itemKey = mod.db.profile.overrides[itemId]
		for i, key in ipairs(sections) do
			local _, _, name, category, title = container:GetSectionInfo(key)
			if name ~= FREE_SPACE or REAGENT_FREE_SPACE then
				-- Add an radio button for each section
				wipe(info)
				info.text = title
				info.checked = (itemKey == key)
				info.arg1 = key
				info.arg2 = itemId
				info.func = Assign
				UIDropDownMenu_AddButton(info, level)
			end
		end

		-- New section
		wipe(info)
		info.notCheckable = true
		info.text = L['New section']
		info.arg1 = BuildSectionKey(header.section.name, header.section.category)
		info.arg2 = itemId
		info.func = NewSection
		UIDropDownMenu_AddButton(info, level)

		-- Close
		wipe(info)
		info.notCheckable = true
		info.text = CLOSE
		UIDropDownMenu_AddButton(info, level)
	end
end

--------------------------------------------------------------------------------
-- Section header hooks
--------------------------------------------------------------------------------

function mod:OnTooltipUpdateSectionHeader(_, header, tooltip)
	if GetCursorInfo() == "item" then
		if header.section.name ~= FREE_SPACE then
			tooltip:AddLine(L["Click here with your item to add it to this section."])
			tooltip:AddLine(L["Press Alt while doing so to open a dropdown menu."])
		end
	elseif header.section:GetKey() ~= JUNK_KEY  then
		tooltip:AddLine(L["Alt-right-click to configure manual filtering."])
	end
end

function mod:OnClickSectionHeader(_, header, button)
	if GetCursorInfo() == "item" then
		if header.section.name ~= FREE_SPACE then
			self:OnReceiveDragSectionHeader(_, header)
		end
	elseif header.section:GetKey() ~= JUNK_KEY and button == "RightButton" and IsAltKeyDown() then
		self:OpenOptions()
	end
end

local dropdownFrame
function mod:OnReceiveDragSectionHeader(_, header)
	local contentType, itemId = GetCursorInfo()
	if contentType == "item" then
		if IsAltKeyDown() then
			if not dropdownFrame then
				dropdownFrame = CreateFrame("Frame", addonName.."FilterOverrideDropDownMenu")
				dropdownFrame.displayMode = "MENU"
				dropdownFrame.initialize = FilterDropDownMenu_Initialize
				dropdownFrame.point = "BOTTOMRIGHT"
				dropdownFrame.relativePoint = "BOTTOMLEFT"
			end
			dropdownFrame.header = header
			dropdownFrame.itemId = itemId
			ToggleDropDownMenu(1, nil, dropdownFrame, 'cursor')
		else
			self:AssignItems(header.section.name, header.section.category, itemId)
			self:UpdateOptions()
			ClearCursor()
		end
	end
end

function mod:CURSOR_CHANGED()
	if GetCursorInfo() == "item" then
		addon.RegisterSectionHeaderScript(self, 'OnReceiveDrag', 'OnReceiveDragSectionHeader')
	else
		addon.UnregisterSectionHeaderScript(self, 'OnReceiveDrag')
	end
end

