-- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--		Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--		Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak
-- --------------------


if not TMW then return end

local TMW = TMW
local L = TMW.L
local print = TMW.print

local CNDT = TMW.CNDT

local tostring, loadstring, setfenv, wipe, type, next, pairs, max, select
	= tostring, loadstring, setfenv, wipe, type, next, pairs, max, select
local huge = math.huge



--- A [[api/conditions/api-documentation/condition-object/|ConditionObject]] represents a group of individual conditions. 
-- 
-- 
-- It stores state information about them and provides methods for keeping them properly updated. ConditionObjects should not be manually instantiated - you should use {{{CNDT:GetConditionObject()}}} or {{{ConditionObjectConstructor:Construct()}}} (which wraps {{{CNDT:GetConditionObject()}}}) instead. 
-- 
-- Only the methods documented here may be called outside of the conditions core.
-- 
-- ConditionObjects are cached so that duplicate objects will not be created to check the exact same conditions.
-- Changes to a ConditionObject's state may be listed to by registering to the {{{TMW_CNDT_OBJ_PASSING_CHANGED(ConditionObject, failed)}}} event with {{{TMW:RegisterCallback()}}}.
-- 
-- @class file
-- @name ConditionObject.lua


local ConditionObject = TMW:NewClass("ConditionObject")
ConditionObject.numArgsForEventString = 1

ConditionObject:MakeInstancesWeak()

-- [INTERNAL] because condition objects should not be directly instantiated by their implementor.
function ConditionObject:OnNewInstance(Conditions, conditionString)
	self.conditionString = conditionString

	self.AutoUpdateRequesters = {}
	self.ExternalUpdaters = {}
	self.RequestedEvents = {}
	
	self.UpdateNeeded = true
	self.NextUpdateTime = huge
	self.UpdateMethod = "OnUpdate"
	
	local types = ""
	if TMW.debug then
		types = tostring(self):gsub("table: ", "_0x")
	end
	for n, condition in TMW:InNLengthTable(Conditions) do
		types = types .. "_" .. condition.Type
	end
	self.funcIdentifier = types
	
	local func, err = loadstring(conditionString, "Condition" .. self.funcIdentifier)
	if func then
		-- func = setfenv(func, TMW.CNDT.Env) -- why was this here? commented out because it is redundant
		self.CheckFunction = setfenv(func, TMW.CNDT.Env)
	elseif err then
		TMW:Error(err)
	end
	
	self:CompileUpdateFunction(Conditions)
end

local argCheckerStringsReusable = {}
-- [INTERNAL] Compiles the update function (event handling and anticipation)
-- and sets up event updating if needed.
function ConditionObject:CompileUpdateFunction(Conditions)
	local argCheckerStrings = wipe(argCheckerStringsReusable)
	local numAnticipatorResults = 0
	local anticipatorstr = ""

	for _, c in TMW:InNLengthTable(Conditions) do
		local t = c.Type
		local condition = CNDT.ConditionsByType[t]
		
		if condition and condition.events then
			local voidNext
			for n, argCheckerString in TMW:Vararg(TMW.get(condition.events, self, c)) do
				if argCheckerString == false or argCheckerString == nil then
					return
				elseif type(argCheckerString) == "string" then
					if argCheckerString == "OnUpdate" then
						return
					elseif argCheckerString == "" then
						TMW:Error("Condition.events shouldn't return blank strings! (From condition %q). Return STRING 'false' if you don't want the condition to update OnUpdate but it also has no events (basically, if it is static).", t)
					else
						argCheckerStrings[argCheckerString] = true
					end
				end
			end
		else
			return
		end

		-- handle code that anticipates when a change in state will occur.
		-- this is usually used to predict when a duration threshold will be used, but you could really use it for whatever you want.
		if condition.anticipate then
			numAnticipatorResults = numAnticipatorResults + 1

			local thisstr = TMW.get(condition.anticipate, c) -- get the anticipator string from the condition data
			thisstr = CNDT:DoConditionSubstitutions(condition, c, thisstr) -- substitute in any user settings

			-- append a check to make sure that the smallest value out of all anticipation checks isnt less than the current time.
			thisstr = thisstr .. [[
			
			if VALUE <= time then
				VALUE = huge
			end
			]]

			-- change VALUE to the appropriate ANTICIPATOR_RESULT#
			thisstr = thisstr:gsub("VALUE", "ANTICIPATOR_RESULT" .. numAnticipatorResults)

			thisstr = "-- Anticipator #" .. numAnticipatorResults .. "\r\n" .. thisstr
			
			anticipatorstr = anticipatorstr .. "\r\n" .. thisstr
		end
	end

	if not next(argCheckerStrings) then
		return
	end

	local doesAnticipate
	if anticipatorstr ~= "" then
		local allVars = ""
		for i = 1, numAnticipatorResults do
			allVars = allVars .. "ANTICIPATOR_RESULT" .. i .. ","
		end
		allVars = allVars:sub(1, -2)

		anticipatorstr = anticipatorstr .. ([[
		
		-- Calculate next update time:
		local nextTime = %s
		if nextTime == 0 then
			nextTime = huge
		end
		ConditionObject.NextUpdateTime = nextTime]]):format((numAnticipatorResults == 1 and allVars or "min(" .. allVars .. ")"))

		doesAnticipate = true
	end

	self.UpdateMethod = "OnEvent"
	
	-- Begin creating the final string that will be used to make the function.
	local funcstr = "if (not event or \r\n"
	
	-- Compile all of the arg checker strings into one single composite that can be checked in an (if ... then) statement.
	local argCheckerStringComposite = ""
	for argCheckerString in pairs(argCheckerStrings) do
		if argCheckerString ~= "" then
			argCheckerStringComposite = argCheckerStringComposite .. "    (" .. argCheckerString .. ") or \r\n"
		end
	end
	
	if argCheckerStringComposite ~= "" then
		-- If any arg checkers were added to the composite (it isnt a blank string),
		-- trim off the final ") or " at the end of it.
		argCheckerStringComposite = argCheckerStringComposite:sub(1, -6) .. "\r\n"
	else
		-- The arg checker string should never ever be blank. Raise an error if it was.
		TMW:Error("The arg checker string compiled for ConditionObject %s was blank. This should not have happened.", tostring(self))
	end

	-- Tack on the composite arg checker string to the function, and then close the elseif that it goes into.
	funcstr = funcstr .. argCheckerStringComposite .. [[) then
	]] .. anticipatorstr .. [[
	
	
		-- Don't check the condition or request an immediate check if event is nil
		-- since event is only nil when manually calling from within :Check()
		if not event then return end
		
		-- Check the condition:
		if ConditionObject.doesAutoUpdate then
			ConditionObject:Check()
		else
			ConditionObject.UpdateNeeded = true
		end
	end]]
	
	-- Finally, create the header of the function that will get all of the args passed into it.
	local argHeader = [[local ConditionObject, event]]
	for i = 1, self.numArgsForEventString do 
		argHeader = argHeader .. [[, arg]] .. i
	end
	
	-- argHeader now looks like: local ConditionObject, event, arg1, arg2, arg3, ..., argN
	
	-- Set the variables that accept the args to the vararg with all of the function input,
	-- and tack on the body of the function
	funcstr = argHeader .. " = ... \r\n" .. funcstr

	funcstr = funcstr:gsub("	", "  ") -- tabs to spaces
	
	local func, err = loadstring(funcstr, "ConditionEvents" .. self.funcIdentifier)
	if func then
		func = setfenv(func, TMW.CNDT.Env)
	elseif err then
		TMW:Error(err)
	end
	
	self.updateString = funcstr

	self.AnticipateFunction = doesAnticipate and func
	self.UpdateFunction = func

	-- Register the events and the object with the UpdateEngine
	-- self:RegisterForUpdating()
end

-- [INTERNAL] Registers the ConditionObject with the update engine.
function ConditionObject:RegisterForUpdating()
	self.registeredForUpdating = true

	CNDT.UpdateEngine:RegisterObject(self)

	TMW.safecall(self.Check, self)
end

-- [INTERNAL] Unregisters the ConditionObject from the update engine.
function ConditionObject:UnregisterForUpdating()
	CNDT.UpdateEngine:UnregisterObject(self)

	self.registeredForUpdating = false
end


-----------------------------------
-- Public Methods
-----------------------------------


--- Runs a check on the condition. The current state of a ConditionObject should always be obtained by reading the value of ConditionObject.Failed.
-- 
-- This method should only be called under the following conditions:
-- <<code lua>>
--	if ConditionObject.UpdateNeeded or ConditionObject.NextUpdateTime < TMW.time then
--		ConditionObject:Check()
--	end
-- <</code>>
-- You may also wish to call ConditionObject:RequestAutoUpdates() if you don't want to have to worry about manually updating the ConditionObjects that you are interested in.
function ConditionObject:Check()
	if self.CheckFunction then
		if not self.registeredForUpdating then
			TMW:Debug("condition was checked, but nobody said they would be checking it!")
		end

		local failed = not self:CheckFunction()
		if self.Failed ~= failed then
			self.Failed = failed
			TMW:Fire("TMW_CNDT_OBJ_PASSING_CHANGED", self, failed)
		end
	
		if self.UpdateMethod == "OnEvent" then
			if self.AnticipateFunction then
				self:AnticipateFunction()
			end
			
			self.UpdateNeeded = nil
		end
		
		if self.NextUpdateTime < TMW.time then
			self.NextUpdateTime = huge
		end
	end
end

--- Requests that the condition update itself automatically.
-- @param requester [table] Something that will uniquely identify what it is that is requesting auto updates. This is used to keep track of how many requesters are currently requesting auto updates so that auto updating can be disabled when there are zero requesters.
-- @param doRequest [boolean] True if {{{requester}}} is requesting auto updates. False/nil if {{{requester}}} is notifying the ConditionObject that it no longer needs to auto update.
function ConditionObject:RequestAutoUpdates(requester, doRequest)
	if doRequest then
	
		-- self.doesAutoUpdate must be true before calling RegisterForUpdating().
		-- :RegisterForUpdating() will update the current state of the condition.
		self.doesAutoUpdate = true
		self:RegisterForUpdating()
		
		self.AutoUpdateRequesters[requester] = true
	else
		self.AutoUpdateRequesters[requester] = nil
		
		if not next(self.AutoUpdateRequesters) then
			self.doesAutoUpdate = false
		end

		if not self.getsExternallyUpdated and not self.doesAutoUpdate then
			self:UnregisterForUpdating()
		end
	end
end


--- Declares that the requester will update the condition object as needed.
-- @param requester [table] Something that will uniquely identify what it is that is requesting auto updates. This is used to keep track of how many requesters are currently updating the condition so that events can be unregistered when there are zero updaters.
-- @param doRequest [boolean] True if {{{requester}}} will update the condition. False/nil if {{{requester}}} is notifying the ConditionObject that it no longer cares about the condition.
function ConditionObject:DeclareExternalUpdater(requester, doRequest)
	if doRequest then
	
		self.getsExternallyUpdated = true
		self:RegisterForUpdating()
		
		self.ExternalUpdaters[requester] = true
	else
		self.ExternalUpdaters[requester] = nil
		
		if not next(self.ExternalUpdaters) then
			self.getsExternallyUpdated = false
		end

		if not self.getsExternallyUpdated and not self.doesAutoUpdate then
			self:UnregisterForUpdating()
		end
	end
end


--- (//For use in the events function of a condition type declaration//)
-- Tells the condition the maximum number of event args that it will be checking (so that it knows how many local variables to create in the event checker function that is compiled).
-- Attempting to manually check event args (by using references to local variable "argN") will result in a global lookup instead of a local lookup, which will create very volatile and unpredictable behavior.
-- 
-- This method is automatically called by {{{ConditionObject:GenerateNormalEventString()}}}
-- @param num [number] the number of args that will be checked by the event checker. Passing in a value lower that the current number of requested args will be silently ignored.
-- @usage events = function(ConditionObject, c)
--   ConditionObject:RequestEvent("TMW_COMMON_SWINGTIMER_CHANGED")
--   ConditionObject:SetNumEventArgs(1)
--   return
--     "event == 'TMW_COMMON_SWINGTIMER_CHANGED' and arg1.slot == " .. GetInventorySlotInfo("MainHandSlot")
-- end
function ConditionObject:SetNumEventArgs(num)
	self.numArgsForEventString = max(self.numArgsForEventString, num)
end

--- (//For use in the events function of a condition type declaration//)
-- Notifies the ConditionObject that it should register the specified event if the ConditionObject as a whole can be OnEvent-driven.
-- @param event [string] An event to request. Can either be a Blizzard event or a TMW event.
-- @usage events = function(ConditionObject, c)
--   ConditionObject:RequestEvent("TMW_COMMON_SWINGTIMER_CHANGED")
--   ConditionObject:SetNumEventArgs(1)
--   return
--     "event == 'TMW_COMMON_SWINGTIMER_CHANGED' and arg1.slot == " .. GetInventorySlotInfo("MainHandSlot")
-- end
function ConditionObject:RequestEvent(event)
	-- Note that this function does not actually register the event with CNDT.UpdateEngine
	-- It simply tells the object that it needs to register the event with CNDT.UpdateEngine
	-- once processing is done and it has been determined that the entire condition set can be event driven
	-- (if it has no OnUpdate conditions in it)
	self.RequestedEvents[event] = true
end

--- (//For use in the events function of a condition type declaration//)
-- Returns a string that will be used to check the event and its args to determine if a condition update is needed. Automatically requests the passed in event and the number of args it was given to check.
-- @param event [string] An event to check. Can either be a Blizzard event or a TMW event.
-- @param ... [number|string|boolean|nil] Any number of args that must match the args of the event in order to trigger a condition update.
-- @return [string] A string that will be used to check the event and its args to determine if a condition update is needed.
-- E.g. <<code lua>> "event == 'SPELL_UPDATE_COOLDOWN'" <</code>>
-- E.g. <<code lua>> "event == 'UNIT_INVENTORY_CHANGED' and arg1 == 'player'" <</code>>
-- @usage events = function(ConditionObject, c)
--   return
--     ConditionObject:GenerateNormalEventString("GROUP_ROSTER_UPDATE")
-- end,
function ConditionObject:GenerateNormalEventString(event, ...)
	self:RequestEvent(event)
	self:SetNumEventArgs(select("#", ...))
	
	local str = "event == '"
    str = str .. event
    str = str .. "'"
    
	for n, arg in TMW:Vararg(...) do
		
		local arg_type = type(arg)
		if 
			arg_type ~= "number" and 
			arg_type ~= "string" and 
			arg_type ~= "boolean" and 
			arg_type ~= "nil" 
		then
			TMW:Error("Unsupported event arg type: " .. arg_type)
		elseif arg ~= nil then
			str = str .. " and arg"
			str = str .. n
			str = str .. " == "
			
			if arg_type == "string" then
				str = str .. format("%q", arg)
			else -- number, boolean
				str = str .. tostring(arg)
			end
		end
	end
	
	return str
end

--- (//For use in the events function of a condition type declaration//)
-- Gets an event checker string that will have the proper event checking for monitoring when the unit changes (you change target, summon a pet, etc).
-- @param unit [string] A unitID to check the unit for. Should be the return value of a call to CNDT:GetUnit(unit).
-- @return [string] A string that will be used to check the calculated event and its args to determine if a condition update is needed.
-- E.g. <<code lua>> "event == 'UNIT_PET' and arg1 == 'player'" <</code>>
-- @usage events = function(ConditionObject, c)
--   return
--     ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit)),
--     ConditionObject:GenerateNormalEventString("UNIT_AURA", CNDT:GetUnit(c.Unit))
-- end,
function ConditionObject:GetUnitChangedEventString(unit)
	if unit == "player" then
		-- Returning false (as a string, not a boolean) won't cause responses to any events,
		-- and it also won't make the ConditionObject default to being OnUpdate driven.
		
		return "false"
	elseif unit == "target" then
		return self:GenerateNormalEventString("PLAYER_TARGET_CHANGED")
	elseif unit == "pet" then
		return self:GenerateNormalEventString("UNIT_PET", "player")
	elseif unit == "focus" then
		return self:GenerateNormalEventString("PLAYER_FOCUS_CHANGED")
	elseif unit:find("^raid%d+$") then
		return self:GenerateNormalEventString("GROUP_ROSTER_UPDATE")
	elseif unit:find("^party%d+$") then
		return self:GenerateNormalEventString("GROUP_ROSTER_UPDATE")
	elseif unit:find("^boss%d+$") then
		return self:GenerateNormalEventString("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
	elseif unit:find("^arena%d+$") then
		return self:GenerateNormalEventString("ARENA_OPPONENT_UPDATE")
	end
	
	return false
end





