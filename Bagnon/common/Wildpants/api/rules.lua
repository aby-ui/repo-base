--[[
	rules.lua
		Methods for creating and browsing item rulesets.
		See https://github.com/tullamods/Wildpants/wiki/Ruleset-API for details.
--]]


local ADDON, Addon = ...
local Rules = Addon:NewModule('Rules', 'MutexDelay-1.0')
Rules.registry = {}
Rules.hierarchy = {}


--[[ Public API ]]--

function Rules:New(id, name, icon, func)
	assert(type(id) == 'string', 'Unique ID must be a string')

	local parent = self:ParentID(id)
	local hierarchy = self.hierarchy

	if parent then
		parent = self:Get(parent)
		assert(parent, 'Specified parent item ruleset is not know')
		hierarchy = parent.children
	end

	local rule = hierarchy[id] or {children = {}}
	rule.name = name or id
	rule.icon = icon
	rule.func = func
	rule.id = id
	hierarchy[id] = rule

	self.registry[id] = rule
	self:Delay(0, 'SendSignal', 'RULES_LOADED')
end

function Rules:Get(id)
	return type(id) == 'string' and self.registry[id]
end

function Rules:Iterate()
	return pairs(self.registry)
end

function Rules:IterateParents()
	return pairs(self.hierarchy)
end


--[[ Additional Methods ]]--

function Rules:ParentID(id)
	local parent = id:match('^(.+)/.-$')
	if parent then
		return parent
	end
end
