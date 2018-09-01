--- AceEvent-3.0 provides event registration and secure dispatching.
-- All dispatching is done using **CallbackHandler-1.0**. AceEvent is a simple wrapper around
-- CallbackHandler, and dispatches all game events or addon message to the registrees.
--
-- **AceEvent-3.0** can be embeded into your addon, either explicitly by calling AceEvent:Embed(MyAddon) or by 
-- specifying it as an embeded library in your AceAddon. All functions will be available on your addon object
-- and can be accessed directly, without having to explicitly call AceEvent itself.\\
-- It is recommended to embed AceEvent, otherwise you'll have to specify a custom `self` on all calls you
-- make into AceEvent.
-- @class file
-- @name AceEvent-3.0
-- @release $Id: AceEvent-3.0.lua 1161 2017-08-12 14:30:16Z funkydude $
local CallbackHandler = LibStub("CallbackHandler-1.0")

local MAJOR, MINOR = "AceEvent-3.0", 99994
local AceEvent = LibStub:NewLibrary(MAJOR, MINOR)

if not AceEvent then return end

-- Lua APIs
local pairs = pairs

AceEvent.frame = AceEvent.frame or CreateFrame("Frame", "AceEvent30Frame") -- our event frame
AceEvent.embeds = AceEvent.embeds or {} -- what objects embed this lib

-- APIs and registry for blizzard events, using CallbackHandler lib
if not AceEvent.events then
	AceEvent.events = CallbackHandler:New(AceEvent, 
		"RegisterEvent", "UnregisterEvent", "UnregisterAllEvents")
end

function AceEvent.events:OnUsed(target, eventname) 
	AceEvent.frame:RegisterEvent(eventname)
end

function AceEvent.events:OnUnused(target, eventname) 
	AceEvent.frame:UnregisterEvent(eventname)
end


-- APIs and registry for IPC messages, using CallbackHandler lib
if not AceEvent.messages then
	AceEvent.messages = CallbackHandler:New(AceEvent, 
		"RegisterMessage", "UnregisterMessage", "UnregisterAllMessages"
	)
	AceEvent.SendMessage = AceEvent.messages.Fire
end

--- embedding and embed handling
local mixins = {
	"RegisterEvent", "UnregisterEvent",
	"RegisterMessage", "UnregisterMessage",
	"SendMessage",
	"UnregisterAllEvents", "UnregisterAllMessages",
}

--- Register for a Blizzard Event.
-- The callback will be called with the optional `arg` as the first argument (if supplied), and the event name as the second (or first, if no arg was supplied)
-- Any arguments to the event will be passed on after that.
-- @name AceEvent:RegisterEvent
-- @class function
-- @paramsig event[, callback [, arg]]
-- @param event The event to register for
-- @param callback The callback function to call when the event is triggered (funcref or method, defaults to a method with the event name)
-- @param arg An optional argument to pass to the callback function

--- Unregister an event.
-- @name AceEvent:UnregisterEvent
-- @class function
-- @paramsig event
-- @param event The event to unregister

--- Register for a custom AceEvent-internal message.
-- The callback will be called with the optional `arg` as the first argument (if supplied), and the event name as the second (or first, if no arg was supplied)
-- Any arguments to the event will be passed on after that.
-- @name AceEvent:RegisterMessage
-- @class function
-- @paramsig message[, callback [, arg]]
-- @param message The message to register for
-- @param callback The callback function to call when the message is triggered (funcref or method, defaults to a method with the event name)
-- @param arg An optional argument to pass to the callback function

--- Unregister a message
-- @name AceEvent:UnregisterMessage
-- @class function
-- @paramsig message
-- @param message The message to unregister

--- Send a message over the AceEvent-3.0 internal message system to other addons registered for this message.
-- @name AceEvent:SendMessage
-- @class function
-- @paramsig message, ...
-- @param message The message to send
-- @param ... Any arguments to the message

local sp_events = {
    COMBAT_LOG_EVENT_UNFILTERED = true, --45625
    UNIT_AURA = true, --24192
    UNIT_POWER_UPDATE = true, --13044 --Gladius
    UNIT_HEAL_PREDICTION = true, --12316 --GridStatusHeals
    UNIT_POWER_FREQUENT = true,
    UNIT_HEALTH_FREQUENT = true,
    --UNIT_HEALTH = true, --7389
    --UNIT_SPELLCAST_SUCCEEDED = true, --4550
}

-- Embeds AceEvent into the target object making the functions from the mixins list available on target:..
-- @param target target object to embed AceEvent in
function AceEvent:Embed(target)
	for k, v in pairs(mixins) do
		target[v] = self[v]
	end
	self.embeds[target] = true
	
    --warbaby make frequent event direct
    hooksecurefunc(target, "RegisterEvent", function(self, event, method, ...)
        if sp_events[event] then
            self:UnregisterEvent(event, 163)
            local eventframe = "_ef_".. event
            self[eventframe] = self[eventframe] or CreateFrame("Frame")
            self[eventframe]:RegisterEvent(event)
            method = method or event
            local regfunc
            if type(method) == "string" then
                if select("#",...)>=1 then	-- this is not the same as testing for arg==nil!
                    local arg=select(1,...)
                    regfunc = function(...) return self[method](self,arg,...) end
                else
                    regfunc = function(...) return self[method](self,...) end
                end
            else
                if select("#",...)>=1 then	-- this is not the same as testing for arg==nil!
                    local arg=select(1,...)
                    regfunc = function(...) return method(arg,...) end
                else
                    regfunc = method
                end
            end
            if regfunc then
                self[eventframe]:SetScript("OnEvent", function(_, ...) return regfunc(...) end)
            end
        end
    end)
    hooksecurefunc(target, "UnregisterEvent", function(self, event, flag)
        if flag==163 then return end
        if sp_events[event] then
            local eventframe = self["_ef_".. event]
            if eventframe then eventframe:UnregisterEvent(event) end
        end
    end)
    hooksecurefunc(target, "UnregisterAllEvents", function(self)
        for sp_event,_ in pairs(sp_events) do
            local eventframe = self["_ef_"..sp_event]
            if eventframe then eventframe:UnregisterEvent(sp_event) end
        end
    end)
    
	return target
end

-- AceEvent:OnEmbedDisable( target )
-- target (object) - target object that is being disabled
--
-- Unregister all events messages etc when the target disables.
-- this method should be called by the target manually or by an addon framework
function AceEvent:OnEmbedDisable(target)
	target:UnregisterAllEvents()
	target:UnregisterAllMessages()
end

-- Script to fire blizzard events into the event listeners
local events = AceEvent.events
AceEvent.frame:SetScript("OnEvent", function(this, event, ...)
--[[
	if DEBUG_MODE then
		if not AceEvent.eventCounts then
			AceEvent.eventCounts = {}
			hooksecurefunc("ResetCPUUsage", function() table.wipe(AceEvent.eventCounts) end)
		end
		AceEvent.eventCounts[event] = (AceEvent.eventCounts[event] or 0) + 1 
	end
]]
	events:Fire(event, ...)
end)

--- Finally: upgrade our old embeds
for target, v in pairs(AceEvent.embeds) do
	AceEvent:Embed(target)
end
