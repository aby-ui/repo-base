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
local assert = _G.assert
local ipairs = _G.ipairs
local setmetatable = _G.setmetatable
local tinsert = _G.tinsert
local tsort = _G.table.sort
local type = _G.type
local wipe = _G.wipe
--GLOBALS>

--------------------------------------------------------------------------------
-- Filter prototype
--------------------------------------------------------------------------------

local filterProto = setmetatable({
	isFilter = true,
	priority = 0,
	OpenOptions = function(self)
		return addon:OpenOptions("filters", self.filterName)
	end,
}, { __index = addon.moduleProto })
addon.filterProto = filterProto

function filterProto:GetPriority()
	return addon.db.profile.filterPriorities[self.filterName] or self.priority or 0
end

function filterProto:SetPriority(value)
	if value ~= self:GetPriority() then
		addon.db.profile.filterPriorities[self.filterName] = (value ~= self.priority) and value or nil
		addon:UpdateFilters()
	end
end

--------------------------------------------------------------------------------
-- Filter handling
--------------------------------------------------------------------------------

function addon:InitializeFilters()
	self:SetupDefaultFilters()
	self:UpdateFilters()
end

local function CompareFilters(a, b)
	local prioA, prioB = a:GetPriority(), b:GetPriority()
	if prioA == prioB then
		return a.filterName < b.filterName
	else
		return prioA > prioB
	end
end

local GetAllFilters, GetActiveFilters
do
	local activeFilters
	local allFilters

	function addon:UpdateFilters()
		activeFilters, allFilters = nil, nil
		self:SendMessage('AdiBags_FiltersChanged')
	end

	function GetAllFilters()
		if allFilters then
			return allFilters
		end
		allFilters = {}
		for name, filter in addon:IterateModules() do
			if filter.isFilter then
				tinsert(allFilters, filter)
			end
		end
		tsort(allFilters, CompareFilters)
		return allFilters
	end

	function GetActiveFilters()
		if activeFilters then
			return activeFilters
		end
		activeFilters = {}
		for i, filter in ipairs(GetAllFilters()) do
			if filter:IsEnabled() then
				tinsert(activeFilters, filter)
			end
		end
		return activeFilters
	end
end

function addon:IterateFilters()
	return ipairs(GetAllFilters())
end

function addon:RegisterFilter(name, priority, Filter, ...)
	local filter
	if type(Filter) == "function" then
		filter = addon:NewModule(name, filterProto, ...)
		filter.Filter = Filter
	elseif Filter then
		filter = addon:NewModule(name, filterProto, Filter, ...)
	else
		filter = addon:NewModule(name, filterProto)
	end
	filter.filterName = name
	filter.priority = priority
	return filter
end

function addon:OnModuleCreated(module)
	self:UpdateFilters()
end

--------------------------------------------------------------------------------
-- Filtering process
--------------------------------------------------------------------------------

local safecall = addon.safecall
function addon:Filter(slotData, defaultSection, defaultCategory)
	for i, filter in ipairs(GetActiveFilters()) do
		local sectionName, category = safecall(filter.Filter, filter, slotData)
		if sectionName then
			--[===[@alpha@
			assert(type(sectionName) == "string", "Filter "..filter.name.." returned "..type(sectionName).." as section name instead of a string")
			assert(category == nil or type(category) == "string", "Filter "..filter.name.." returned "..type(category).." as category instead of a string")
			--@end-alpha@]===]
			return sectionName, category, filter.uiName
		end
	end
	return defaultSection, defaultCategory
end
