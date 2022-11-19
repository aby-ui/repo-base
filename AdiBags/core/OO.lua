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
local safecall = addon.safecall

--<GLOBALS
local _G = _G
local assert = _G.assert
local CreateFrame = _G.CreateFrame
local format = _G.format
local next = _G.next
local pairs = _G.pairs
local print = _G.print
local select = _G.select
local setmetatable = _G.setmetatable
local SlashCmdList = _G.SlashCmdList
local tostring = _G.tostring
--GLOBALS>

--------------------------------------------------------------------------------
-- Classes
--------------------------------------------------------------------------------

-- Required as some "OnLoad" function refers to the frame parent (since 6.0)
local defaultParent = CreateFrame("Frame")

local classes = {}

local function Meta_ToString(self)
	return self:ToString()
end

local function Class_Create(class, ...)
	class.serial = class.serial + 1
	local self = CreateFrame(class.frameType, addonName..class.name..class.serial, defaultParent, class.frameTemplate)
	self.GetItemContextMatchResult = nil -- We're not using the ContainerFrameItemButtonMixin
	self:SetParent(nil) -- Get rid of the parent once the OnLoad handler has been called
	setmetatable(self, class.metatable)
	self:ClearAllPoints()
	self:Hide()
	safecall(self, "OnCreate", ...)
	return self
end

local function NewClass(name, parent, ...)
	local prototype, mixins = {}, {}

	local class = {
		name = name,
		prototype = prototype,
		parent = parent,
		mixins = mixins,
		serial = 0,
		metatable = {
			__index = prototype,
			__tostring = Meta_ToString
		},
		Create = Class_Create,
	}

	if parent.mixins then
		setmetatable(mixins, { __index = parent.mixins })
	end
	for i = 1, select('#', ...) do
		local name = select(i, ...)
		if not mixins[name] then
			local mixin = LibStub(name)
			mixins[name] = mixin
			safecall(mixin, "Embed", prototype)
		end
	end

	prototype.class = class
	prototype.Debug = addon.Debug
	if parent.prototype then
		setmetatable(class, { __index = parent })
		setmetatable(prototype, { __index = parent.prototype })
		return class, prototype, parent.prototype
	else
		setmetatable(prototype, { __index = parent })
		return class, prototype, parent
	end
end

local function NewRootClass(name, frameType, frameTemplate, ...)
	local class, prototype, parent
	if frameTemplate and LibStub(frameTemplate, true) then
		class, prototype, parent = NewClass(name, CreateFrame(frameType), frameTemplate, ...)
		frameTemplate = nil
	else
		class, prototype, parent = NewClass(name, CreateFrame(frameType), ...)
	end
	class.frameType = frameType
	class.frameTemplate = frameTemplate
	prototype.ToString = parent.GetName
	return class, prototype, parent
end

function addon:NewClass(name, frameType, ...)
	local class, prototype, parent
	if classes[frameType] then
		class, prototype, parent = NewClass(name, classes[frameType], ...)
	else
		class, prototype, parent = NewRootClass(name, frameType, ...)
	end
	classes[name] = class
	return class, prototype, parent
end

function addon:GetClass(name)
	return name and classes[name]
end

--------------------------------------------------------------------------------
-- Object pools
--------------------------------------------------------------------------------

local pools = {}

local poolProto = {}
local poolMeta = { __index = poolProto }

function poolProto:Acquire(...)
	local object = next(self.heap)
	if object then
		assert(not object.acquired, "Found an acquired object in the pool")
		self.heap[object] = nil
	else
		object = self.class:Create()
	end
	self.actives[object] = true
	object.acquired = true
	for name, mixin in pairs(self.class.mixins) do
		safecall(mixin, "OnEmbedEnable", object)
	end
	safecall(object, "OnAcquire", ...)
	return object
end

function poolProto:Release(object)
	assert(object.acquired, "Trying to release an object that wasn't acquired")
	object:Hide()
	object:ClearAllPoints()
	object:SetParent(nil)
	safecall(object, "OnRelease")
	for name, mixin in pairs(self.class.mixins) do
		safecall(mixin, "OnEmbedDisable", object)
	end
	object.acquired = nil
	self.actives[object] = nil
	self.heap[object] = true
end

function poolProto:PreSpawn(number)
	for i = 1, number do
		local object = self.class:Create()
		self.heap[object] = true
	end
end

local function PoolIterator(data, current)
	current = next(data.pool[data.attribute], current)
	if current == nil and data.attribute == "heap" then
		data.attribute = "actives"
		return next(data.pool.actives)
	end
	return current
end

function poolProto:IterateAllObjects()
	return PoolIterator, { pool = self, attribute = "heap" }
end

function poolProto:IterateHeap()
	return pairs(self.heap)
end

function poolProto:IterateActiveObjects()
	return pairs(self.actives)
end

local function Instance_Release(self)
	return self.class.pool:Release(self)
end

function addon:CreatePool(class, acquireMethod)
	local pool = setmetatable({
		heap = {},
		actives = {},
		class = class,
	}, poolMeta)
	class.pool = pool
	class.prototype.Release = Instance_Release
	pools[class.name] = pool
	if acquireMethod then
		self[acquireMethod] = function(self, ...) return pool:Acquire(...) end
	end
	return pool
end

function addon:GetPool(name)
	return name and pools[name]
end

--[===[@debug@
-- Globals: SLASH_ADIBAGSOODEBUG1
SLASH_ADIBAGSOODEBUG1 = "/aboo"
function SlashCmdList.ADIBAGSOODEBUG()
	print('Classes:')
	for name, class in pairs(classes) do
		print(format("- %s: type: %s, template: %s, serial: %d", name, class.frameType, tostring(class.frameTemplate), class.serial))
	end
	print('Pools:')
	for name, pool in pairs(pools) do
		local heapSize, numActives = 0, 0
		for k in pairs(pool.activtes) do
			numActives = numActives + 1
		end
		for k in pairs(pool.heap) do
			heapSize = heapSize + 1
		end
		print(format("- %s: heap size: %d, number of active objects: %d", name, heapSize, numActives))
	end
end
--@end-debug@]===]
