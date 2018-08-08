local Parrot = Parrot
local Parrot_TriggerConditions = Parrot:NewModule("TriggerConditions", "AceEvent-3.0")
local self = Parrot_TriggerConditions

local debug = Parrot.debug
local del = Parrot.del

local L = LibStub("AceLocale-3.0"):GetLocale("Parrot_TriggerConditions")

local _,playerClass = UnitClass("player")

local conditions = {}
local lastStates = {}
local secondaryConditions = {}

local primaryChoices = {}
local secondaryChoices = {}

local onEnableFuncs = {}
local Parrot_Triggers
function Parrot_TriggerConditions:OnEnable()
	Parrot_Triggers = Parrot:GetModule("Triggers")
	-- TODO remove
	for k, v in pairs(conditions) do
		if v.getCurrent then
			lastStates[k] = v.getCurrent()
		end
	end
	Parrot:RegisterCombatLog(self)
	for _,v in ipairs(onEnableFuncs) do
		v()
	end
end

local onDisableFuncs = {}
function Parrot_TriggerConditions:OnDisable()
	for _,v in ipairs(onDisableFuncs) do
		v()
	end
end

table.insert(onDisableFuncs, function() Parrot:UnregisterCombatLog(self) end)

local function RefreshEvents()
	local self = Parrot_TriggerConditions
	Parrot:UnRegisterAllEvents(self)

	if not self:IsEnabled() then
		return
	end
	for k, v in pairs(conditions) do
		if v.events then
			for event in pairs(v.events) do
				local event_ns, event_ev = (";"):split(event, 2)
				if not event_ev then
					event_ns, event_ev = "Blizzard", event_ns
				end
				Parrot:RegisterBlizzardEvent(self, event_ev, "EventHandler")
			end
		end
	end
end

-- #NODOC
function Parrot_TriggerConditions:EventHandler(uid, event, arg1, ...)
	local fullEvent = event
	for k, v in pairs(conditions) do
		if v.events then
			local arg = v.events[fullEvent]
			local info
			if type(arg) == 'function' then
				info = arg(arg1, ...)
			elseif arg == true then
				info = true
			else
				info = arg == arg1
			end
			if info then
				self:FirePrimaryTriggerCondition(v.name, info, uid, v.check)
			end
			--[[if arg == true or (arg1 ~= nil and arg == arg1) then
				if v.getCurrent then
					local state = v.getCurrent()
					local name = v.name
					local oldState = lastStates[name]
					lastStates[name] = state
					if state ~= nil and state ~= oldState then
						self:FirePrimaryTriggerCondition(name, state)
					end
				else
					self:FirePrimaryTriggerCondition(v.name, arg1)
				end
			end--]]
		end
	end
end

self.combatLogEvents = {}
--[[----------------------------------------------------------------------------------
Arguments:
	string - the name of the trigger condition to fire, in English.
	[optional] string or number - a vital argument to provide information about the trigger condition.
Notes:
	* You have to register a trigger condition with :RegisterPrimaryTriggerCondition(data) first.
	* In most cases, if you use normal events in the registration or Parser-3.0, this shouldn't need to be called.
Example:
	Parrot:FirePrimaryTriggerCondition("My trigger condition", 50)
------------------------------------------------------------------------------------]]
function Parrot_TriggerConditions:FirePrimaryTriggerCondition(name, arg, uid)
	self = Parrot_TriggerConditions -- in case someone calls Parrot:FirePrimaryTriggerCondition

	if Parrot_Triggers and Parrot_Triggers:IsEnabled() then
		local check
		if conditions[name] then
			check = conditions[name].check
		end
		Parrot_Triggers:OnTriggerCondition(name, arg, uid, check)
	end
end
Parrot.FirePrimaryTriggerCondition = Parrot_TriggerConditions.FirePrimaryTriggerCondition

--[[----------------------------------------------------------------------------------
Arguments:
	table - a data table holding the details of a primary trigger condition.
Notes:
	The data table is of the following style:
	<pre>{
		name = "Name of the condition in English",
		localName = "Name of the condition in the current locale",
		events = { -- this is optional
			NAME_OF_EVENT = value, -- where NAME_OF_EVENT is the event to check, only works when value is equal to arg1. Also, value could be true in which case it is always checked.
			-- there can be multiple events.
		},
		getCurrent = function() -- this is optional and to be used with events.
			if not SomeCondition() then
				return nil -- condition won't fire.
			else
				return value -- numeric value.
			end
		end,
		param = {
			-- AceOptions argument here.
			-- do not specify get, set, name, or desc.
		}
	}</pre>
	-- TODO documentation
Example:
	Parrot:RegisterPrimaryTriggerCondition {
		name = "Incoming block",
		localName = L[ [=[Incoming block]=] ],
		parserEvent = {
			eventType = "Miss",
			missType = "Block",
			recipientID = "player",
		},
	}
------------------------------------------------------------------------------------]]
function Parrot_TriggerConditions:RegisterPrimaryTriggerCondition(data)
	self = Parrot_TriggerConditions -- in case someone calls Parrot:RegisterPrimaryTriggerCondition
	local name = data.name
	if type(name) ~= "string" then
		error(("Bad argument #2 to `RegisterCombatEvent'. name must be a %q, got %q."):format("string", type(name)), 2)
	end
	local localName = data.localName
	if type(localName) ~= "string" then
		error(("Bad argument #2 to `RegisterCombatEvent'. localName must be a %q, got %q."):format("string", type(localName)), 2)
	end
	local events = data.events
	if events then
		if type(events) ~= "table" then
			error(("Bad argument #2 to `RegisterCombatEvent'. localName must be a %q, got %q."):format("table", type(events)), 2)
		end
		local getCurrent = data.getCurrent
		if type(getCurrent) ~= "function" and type(getCurrent) ~= "nil" then
			error(("Bad argument #2 to `RegisterCombatEvent'. localName must be a %q or nil, got %q."):format("function", type(check)), 2)
		end
	end
	if conditions[name] then
		error(("Trigger condition %q already registered"):format(name), 2)
	end
	conditions[name] = data
	primaryChoices[name] = localName

	-- combatlog-stuff
	local combatLogEvents = data.combatLogEvents
	if combatLogEvents then
		for _, v in ipairs(combatLogEvents) do

			local eventType = v.eventType
			if not self.combatLogEvents[eventType] then
				self.combatLogEvents[eventType] = {}
			end
			table.insert(self.combatLogEvents[eventType], { category = data.category, name = data.name, triggerData = v.triggerData })
		end

	end

	RefreshEvents()
end
Parrot.RegisterPrimaryTriggerCondition = Parrot_TriggerConditions.RegisterPrimaryTriggerCondition

--[[----------------------------------------------------------------------------------
Arguments:
	table - a data table holding the details of a secondary trigger condition.
Notes:
	The data table is of the following style:
	<pre>{
		name = "Name of the condition in English",
		localName = "Name of the condition in the current locale",
		check = function(param)
			return GetSomeValue() == param
		end,
		defaultParam = 0.5, -- the default value
		param = {
			-- AceOptions argument here.
			-- do not specify get, set, name, or desc.
		}
	}</pre>
Example:
	Parrot:RegisterSecondaryTriggerCondition {
		name = "Minimum power amount",
		localName = L[ [=[Minimum power amount]=] ],
		defaultParam = 0.5,
		param = {
			type = 'range',
			min = 0,
			max = 10000,
			step = 1,
			bigStep = 50,
		},
		check = function(param)
			if UnitIsDeadOrGhost("player") then
				return false
			end
			return UnitPower("player")/UnitPowerMax("player") >= param
		end,
	}
------------------------------------------------------------------------------------]]
function Parrot_TriggerConditions:RegisterSecondaryTriggerCondition(data)
	self = Parrot_TriggerConditions -- in case someone calls Parrot:RegisterSecondaryTriggerCondition
	local name = data.name
	if type(name) ~= "string" then
		error(("Bad argument #2 to `RegisterCombatEvent'. name must be a %q, got %q."):format("string", type(name)), 2)
	end
	local localName = data.localName
	if type(localName) ~= "string" then
		error(("Bad argument #2 to `RegisterCombatEvent'. localName must be a %q, got %q."):format("string", type(localName)), 2)
	end
	secondaryConditions[name] = data
	secondaryChoices[name] = localName
	local notLocalName = data.notLocalName
	if type(notLocalName) == "string" then
		secondaryChoices["~" .. name] = notLocalName
	end
end
Parrot.RegisterSecondaryTriggerCondition = Parrot_TriggerConditions.RegisterSecondaryTriggerCondition

-- #NODOC
function Parrot_TriggerConditions:GetPrimaryConditionChoices()
	return primaryChoices
end

-- #NODOC
function Parrot_TriggerConditions:GetSecondaryConditionChoices()
	return secondaryChoices
end

-- #NODOC
function Parrot_TriggerConditions:GetPrimaryConditionParamDetails(name)
	local data = conditions[name]
	if not data then
		return
	end
	return data.param, data.defaultParam
end

function Parrot_TriggerConditions:GetSecondary()
	return secondaryConditions
end

-- #NODOC
function Parrot_TriggerConditions:GetSecondaryConditionParamDetails(name)
	local data = secondaryConditions[name]
	if not data then
		if name:find("^~") then
			data = secondaryConditions[name:sub(2)]
		end
		if not data then
			return
		end
	end
	return data.param, data.defaultParam
end

function Parrot_TriggerConditions:IsExclusive(name)
	if not conditions[name] then
		return false
	else
		return not not conditions[name].exclusive
	end
end

function Parrot_TriggerConditions:SecondaryIsExclusive(name)
	if name:match("^~.*") then
		name = name:sub(2)
	end
	if not secondaryConditions[name] then
		return false
	else
		return not not secondaryConditions[name].exclusive
	end
end

function Parrot_TriggerConditions:IsStateful(name)
	if not conditions[name] then
		return false
	else
		return not not conditions[name].stateful
	end
end

-- #NODOC
function Parrot_TriggerConditions:DoesSecondaryTriggerConditionPass(name, arg)
	local notted = false
	if name:find("^~") then
		notted = true
		name = name:sub(2)
	end
	local data = secondaryConditions[name]
	if not data then
		return false
	end
	if not arg and data.param then
		return false
	end
	local value = data.check(arg)
	if notted then
		return not value
	else
		return value
	end
end

function Parrot_TriggerConditions:HandleCombatlogEvent(uid, _, timestamp, eventType, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, ...)
	local registeredHandlers = self.combatLogEvents[eventType]
	if registeredHandlers then
		for _,v in ipairs(registeredHandlers) do
			local arg = v.triggerData(sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, ...)
			if arg == true then
				self:FirePrimaryTriggerCondition(v.name, nil, uid)
			else
				self:FirePrimaryTriggerCondition(v.name, arg, uid)
			end
			if type(arg) == 'table' then
				arg = del(arg)
			end
		end
	end
end

--[[function Parrot_TriggerConditions:COMBAT_LOG_EVENT_UNFILTERED(_, _, timestamp, eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)

	if not Parrot:IsModuleActive(Parrot_TriggerConditions) then
		return
	end

	local registeredHandlers = self.combatLogEvents[eventType]
	if registeredHandlers then
		for _, v in ipairs(registeredHandlers) do
			local arg = v.triggerData(srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
			if arg == true then
				local uid = (srcGUID or 0) + (dstGUID or 0) - timestamp
				self:FirePrimaryTriggerCondition(v.name, nil, uid)
			elseif arg then
				local uid = (srcGUID or 0) + (dstGUID or 0) - timestamp
				self:FirePrimaryTriggerCondition(v.name, arg, uid)
			end
		end
	end

end
--]]
