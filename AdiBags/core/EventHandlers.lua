--[[
AdiBags - Adirelle's bag addon.
Copyright 2014-2021 Adirelle (adirelle@gmail.com)
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

local _G = _G
local CreateFrame = _G.CreateFrame
local C_Timer = _G.C_Timer
local geterrorhandler = _G.geterrorhandler
local ipairs = _G.ipairs
local next = _G.next
local pairs = _G.pairs
local type = _G.type
local wipe = _G.wipe
local xpcall = _G.xpcall

local CBH = LibStub('CallbackHandler-1.0')

-- Event dispatching and messagging

local eventLib = LibStub:NewLibrary("ABEvent-1.0", 1)

local events = CBH:New(eventLib, 'RegisterEvent', 'UnregisterEvent', 'UnregisterAllEvents')
local eventFrame = CreateFrame("Frame")
eventFrame:SetScript('OnEvent', function(_, ...) return events:Fire(...) end)
function events:OnUsed(_, event) return eventFrame:RegisterEvent(event) end
function events:OnUnused(_, event) return eventFrame:UnregisterEvent(event) end

local messages = CBH:New(eventLib, 'RegisterMessage', 'UnregisterMessage', 'UnregisterAllMessages')
eventLib.SendMessage = messages.Fire

function eventLib:Embed(target)
	for _, name in ipairs{'RegisterEvent', 'UnregisterEvent', 'UnregisterAllEvents', 'RegisterMessage', 'UnregisterMessage', 'UnregisterAllMessages', 'SendMessage'} do
		target[name] = eventLib[name]
	end
end

function eventLib:OnEmbedDisable(target)
	target:UnregisterAllEvents()
	target:UnregisterAllMessages()
end

-- Event/message bucketing

local bucketLib = LibStub:NewLibrary("ABBucket-1.0", 1)
local buckets = {}

local function RegisterBucket(target, event, delay, callback, regFunc, unregFunc)

	local received, timer, cancelled = {}, false, false
	local handle = tostring(received):sub(8)

	local actualCallback
	if type(callback) == "string" then
		actualCallback = function() return target[callback](target, received) end
	else
		actualCallback = function() return callback(received) end
	end

	local function Fire()
		timer = nil
		if not cancelled and next(received) then
			xpcall(actualCallback, geterrorhandler())
		end
		wipe(received)
	end

	local function Handler(event, arg)
		if arg == nil then
			arg = "nil"
		end
		received[arg] = (received[arg] or 0) + 1
		if not timer then
			timer = true
			C_Timer.After(delay, Fire)
		end
	end

	local function Cancel()
		unregFunc(received)
		cancelled = true
		buckets[target][handle] = nil
	end

	if type(event) == "table" then
		for _, ev in ipairs(event) do
			regFunc(received, ev, Handler)
		end
	else
		regFunc(received, event, Handler)
	end

	if not buckets[target] then
		buckets[target] = {}
	end
	buckets[target][handle] = Cancel

	return handle
end

function bucketLib:RegisterBucketEvent(event, delay, callback)
	return RegisterBucket(self, event, delay, callback, eventLib.RegisterEvent, eventLib.UnregisterAllEvents)
end

function bucketLib:RegisterBucketMessage(event, delay, callback)
	return RegisterBucket(self, event, delay, callback, eventLib.RegisterMessage, eventLib.UnregisterAllMessages)
end

function bucketLib:UnregisterBucket(handle)
	local cancel = buckets[self] and buckets[self][handle]
	if cancel then
		xpcall(cancel, geterrorhandler())
	end
end

function bucketLib:UnregisterAllBuckets()
	if not buckets[self] then return end
	for _, cancel in pairs(buckets[self]) do
		xpcall(cancel, geterrorhandler())
	end
end

function bucketLib:Embed(target)
	for _, name in ipairs{"RegisterBucketEvent", "RegisterBucketMessage", "UnregisterBucket", "UnregisterAllBuckets"} do
		target[name] = bucketLib[name]
	end
end

function bucketLib:OnEmbedDisable(target)
	target:UnregisterAllBuckets()
end
