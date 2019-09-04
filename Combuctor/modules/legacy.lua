--[[
	legacy.lua
		Emulates the old ruleset API to support outdated plugins
		Do not implement new addons using this API
--]]

local ADDON, Addon = ...
local Legacy = Addon:NewModule('Sets')
local Rules = Addon.Rules

local function adaptRule(rule, player, bag, slot, bagLink, itemLink, count)
	local bagType, name, quality, ilvl, level, type, subType, equipSlot, _
	if itemLink then
		name, _, quality, ilvl, level, type, subType, _, equipSlot = GetItemInfo(itemLink)
	end

	if bagLink then
		bagType = GetItemFamily(bagLink)
	end

	return rule(player, bagType, name, itemLink, quality, level, ilvl, type, subType, count, equipSlot, bag, slot)
end

function Legacy:Register(name, icon, rule)
	Rules:New(name, nil, icon, rule and function(...)
		return adaptRule(rule, ...)
	end)
end

function Legacy:RegisterSubSet(name, parent, icon, rule)
	local id = parent .. '/' .. name
	local parent = Rules:Get(parent)

	Rules:New(id, name, icon, rule and function(...)
		return parent.func(...) and adaptRule(rule, ...)
	end or parent.func)
end

function Legacy:Unregister(name, parent)
	-- not supported
end

function Legacy:Get(name, parent)
	if parent then
		return Rules:Get(parent .. '/' .. name)
	end

	return Rules:Get(name)
end

function Legacy:GetParentSets()
	return Rules:IterateParents()
end

function Legacy:GetChildSets(parent)
	return pairs(Rules:Get(parent).children)
end
