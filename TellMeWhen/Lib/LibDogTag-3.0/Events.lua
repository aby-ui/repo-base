local MAJOR_VERSION = "LibDogTag-3.0"
local MINOR_VERSION = 90000 + ((tonumber(("20200115020223"):match("%d+")) or 33333333333333))

if MINOR_VERSION > _G.DogTag_MINOR_VERSION then
	_G.DogTag_MINOR_VERSION = MINOR_VERSION
end

local type, error, math, next, pairs, ipairs, select, rawget, setmetatable, _G, assert =
	  type, error, math, next, pairs, ipairs, select, rawget, setmetatable, _G, assert

-- #AUTODOC_NAMESPACE DogTag

DogTag_funcs[#DogTag_funcs+1] = function(DogTag)

local newList, del, deepCopy = DogTag.newList, DogTag.del, DogTag.deepCopy
local fixNamespaceList = DogTag.fixNamespaceList
local memoizeTable = DogTag.memoizeTable
local select2 = DogTag.select2
local kwargsToKwargTypes = DogTag.kwargsToKwargTypes
local kwargsToKwargTypesWithTableCache = DogTag.kwargsToKwargTypesWithTableCache
local codeToFunction, codeEvaluationTime, evaluate, fsToKwargs, fsToFrame, fsToNSList, fsToCode,  updateFontString, updateFontStrings
local fsNeedUpdate, fsNeedQuickUpdate
local _clearCodes
DogTag_funcs[#DogTag_funcs+1] = function()
	codeToFunction = DogTag.codeToFunction
	codeEvaluationTime = DogTag.codeEvaluationTime
	evaluate = DogTag.evaluate
	fsToFrame = DogTag.fsToFrame
	fsToKwargs = DogTag.fsToKwargs
	fsToNSList = DogTag.fsToNSList
	fsToCode = DogTag.fsToCode
	updateFontString = DogTag.updateFontString
	updateFontStrings = DogTag.updateFontStrings
	for fs in pairs(fsToFrame) do
		fsNeedQuickUpdate[fs] = true
	end
	_clearCodes = DogTag._clearCodes
end

local EventHandlers, TimerHandlers

if DogTag.oldLib then
	fsNeedUpdate = DogTag.oldLib.fsNeedUpdate
	for k in pairs(fsNeedUpdate) do
		fsNeedUpdate[k] = nil
	end
	fsNeedQuickUpdate = DogTag.oldLib.fsNeedQuickUpdate
	for k in pairs(fsNeedQuickUpdate) do
		fsNeedQuickUpdate[k] = nil
	end
	EventHandlers = DogTag.oldLib.EventHandlers or {}
	TimerHandlers = DogTag.oldLib.TimerHandlers or {}
else
	fsNeedUpdate = {}
	fsNeedQuickUpdate = {}
	EventHandlers = {}
	TimerHandlers = {}
end
DogTag.fsNeedUpdate = fsNeedUpdate
DogTag.fsNeedQuickUpdate = fsNeedQuickUpdate
DogTag.EventHandlers = EventHandlers
DogTag.TimerHandlers = TimerHandlers

local frame
if DogTag.oldLib then
	frame = DogTag.oldLib.frame
	frame:SetScript("OnEvent", nil)
	frame:SetScript("OnUpdate", nil)
	frame:Show()
	frame:UnregisterAllEvents()
else
	frame = CreateFrame("Frame")
end
DogTag.frame = frame
frame:RegisterAllEvents()

local codeToEventList
do
	local codeToEventList_mt = {__index = function(self, kwargTypes)
		local t = newList()
		t[""] = false
		self[kwargTypes] = t
		return t
	end}
	codeToEventList = setmetatable({}, {__index = function(self, nsList)
		local t = setmetatable(newList(), codeToEventList_mt)
		self[nsList] = t
		return t
	end})
end
DogTag.codeToEventList = codeToEventList

DogTag.callback_num = 0
local callbackToNSList, callbackToKwargs, callbackToFunction, callbackToCode, callbackToExtraArg
if DogTag.oldLib and DogTag.oldLib.callbackToNSList then
	local oldLib = DogTag.oldLib
	DogTag.callback_num = oldLib.callback_num
	callbackToNSList = oldLib.callbackToNSList
	callbackToKwargs = {}
	for uid, kwargs in pairs(oldLib.callbackToKwargs) do
		callbackToKwargs[uid] = memoizeTable(deepCopy(kwargs))
	end
	callbackToFunction = oldLib.callbackToFunction
	callbackToCode = oldLib.callbackToCode
	callbackToExtraArg = oldLib.callbackToExtraArg
else
	callbackToNSList = {}
	callbackToKwargs = {}
	callbackToFunction = {}
	callbackToCode = {}
	callbackToExtraArg = {}
	if DogTag.oldLib and DogTag.oldLib.callbacks then
		for nsList, callbacks_nsList in pairs(DogTag.oldLib.callbacks) do
			for kwargTypes, callbacks_nsList_kwargTypes in pairs(callbacks_nsList) do
				for kwargs, callbacks_nsList_kwargTypes_kwargs in pairs(callbacks_nsList_kwargTypes) do
					for code, callbacks_nsList_kwargTypes_kwargs_code in pairs(callbacks_nsList_kwargTypes_kwargs) do
						if type(callbacks_nsList_kwargTypes_kwargs_code) == "function" then
							local uid = DogTag.callback_num + 1
							DogTag.callback_num = uid
							callbackToNSList[uid] = nsList
							callbackToKwargs[uid] = memoizeTable(deepCopy(kwargs))
							callbackToFunction[uid] = callbacks_nsList_kwargTypes_kwargs_code
							callbackToCode[uid] = code
						else -- table
							for k in pairs(callbacks_nsList_kwargTypes_kwargs_code) do
								local uid = DogTag.callback_num + 1
								DogTag.callback_num = uid
								callbackToNSList[uid] = nsList
								callbackToKwargs[uid] = memoizeTable(deepCopy(kwargs))
								callbackToFunction[uid] = k
								callbackToCode[uid] = code
							end
						end
					end
				end
			end
		end
	end
end
local callbackToKwargTypes = {}
for uid, kwargs in pairs(callbackToKwargs) do
	callbackToKwargTypes[uid] = kwargsToKwargTypesWithTableCache[kwargs]
end

DogTag.callbackToNSList = callbackToNSList
DogTag.callbackToKwargs = callbackToKwargs
DogTag.callbackToFunction = callbackToFunction
DogTag.callbackToCode = callbackToCode
DogTag.callbackToKwargTypes = callbackToKwargTypes
DogTag.callbackToExtraArg = callbackToExtraArg

local eventData = setmetatable({}, {__index = function(self, key)
	local t = newList()
	self[key] = t
	return t
end})
DogTag.eventData = eventData

function DogTag.hasEvent(event)
	local hasEvent = not not rawget(eventData, event)
	if hasEvent then
		return true
	end
	
	for uid, nsList in pairs(callbackToNSList) do
		local kwargTypes = callbackToKwargTypes[uid]
		local code = callbackToCode[uid]
		local eventList = codeToEventList[nsList][kwargTypes][code]
		if eventList then
			local eventList_event = eventList[event]
			if eventList_event then
				return true
			end
		end
	end
	return false
end

--[[
Notes:
	Adds a callback that will be called if the code in question is to be updated.
Arguments:
	string - the tag sequence
	function - the function to be called
	[optional] string - a semicolon-separated list of namespaces. Base is implied
	[optional] table - a dictionary of default kwargs for all tags in the code to receive
	[optional] value - a value that will be passed into the callback
Example:
	LibStub("LibDogTag-3.0"):AddCallback("[Name]", function(code, kwargs)
		-- do something here
	end, "Unit", { unit = 'player' })
]]
function DogTag:AddCallback(code, callback, nsList, kwargs, extraArg)
	if type(code) ~= "string" then
		error(("Bad argument #2 to `AddCallback'. Expected %q, got %q."):format("string", type(code)), 2)
	elseif type(callback) ~= "function" then
		error(("Bad argument #3 to `AddCallback'. Expected %q, got %q."):format("function", type(callback)), 2)
	elseif nsList and type(nsList) ~= "string" then
		error(("Bad argument #4 to `AddCallback'. Expected %q, got %q."):format("string", type(nsList)), 2)
	elseif kwargs and type(kwargs) ~= "table" then
		error(("Bad argument #5 to `AddCallback'. Expected %q, got %q."):format("table", type(kwargs)), 2)
	end
	
	kwargs = memoizeTable(deepCopy(kwargs or false))
	
	nsList = fixNamespaceList[nsList]
	local kwargTypes = kwargsToKwargTypesWithTableCache[kwargs]
	local codeToEventList_nsList_kwargTypes = codeToEventList[nsList][kwargTypes]
	local eventList = codeToEventList_nsList_kwargTypes[code]
	if eventList == nil then
		local _ = codeToFunction[nsList][kwargTypes][code]
		eventList = codeToEventList_nsList_kwargTypes[code]
		assert(eventList ~= nil)
	end
	
	local uid = DogTag.callback_num + 1
	DogTag.callback_num = uid
	
	callbackToNSList[uid] = nsList
	callbackToKwargs[uid] = kwargs
	callbackToCode[uid] = code
	callbackToFunction[uid] = callback
	callbackToKwargTypes[uid] = kwargTypes
	callbackToExtraArg[uid] = extraArg
end

--[[
Notes:
	Remove a callback that has been previously added
Arguments:
	string - the tag sequence
	function - the function to be called
	[optional] string - a semicolon-separated list of namespaces. Base is implied
	[optional] table - a dictionary of default kwargs for all tags in the code to receive
Example:
	LibStub("LibDogTag-3.0"):RemoveCallback("[Name]", func, "Unit", { unit = 'player' })
]]
function DogTag:RemoveCallback(code, callback, nsList, kwargs, extraArg)
	if type(code) ~= "string" then
		error(("Bad argument #2 to `RemoveCallback'. Expected %q, got %q."):format("string", type(code)), 2)
	elseif type(callback) ~= "function" then
		error(("Bad argument #3 to `RemoveCallback'. Expected %q, got %q."):format("function", type(callback)), 2)
	elseif nsList and type(nsList) ~= "string" then
		error(("Bad argument #4 to `RemoveCallback'. Expected %q, got %q."):format("string", type(nsList)), 2)
	elseif kwargs and type(kwargs) ~= "table" then
		error(("Bad argument #5 to `RemoveCallback'. Expected %q, got %q."):format("table", type(kwargs)), 2)
	end
	nsList = fixNamespaceList[nsList]
	kwargs = memoizeTable(deepCopy(kwargs or false))
	
	for uid, n in pairs(callbackToNSList) do
		if n == nsList and callbackToKwargs[uid] == kwargs and callbackToCode[uid] == code and callbackToFunction[uid] == callback and callbackToExtraArg[uid] == extraArg then
			callbackToNSList[uid] = nil
			callbackToCode[uid] = nil
			callbackToKwargs[uid] = nil
			callbackToKwargTypes[uid] = nil
			callbackToFunction[uid] = nil
			callbackToExtraArg[uid] = nil
			break
		end
	end
end

local function OnEvent(this, event, ...)
	if DogTag[event] then
		DogTag[event](DogTag, event, ...)
	end
	for namespace, data in pairs(EventHandlers) do
		if data[event] then
			for func in pairs(data[event]) do
				func(event, ...)
			end
		end
	end
	local arg1 = (...)
	for uid, nsList in pairs(callbackToNSList) do
		local kwargTypes = callbackToKwargTypes[uid]
		local code = callbackToCode[uid]
		local eventList = codeToEventList[nsList][kwargTypes][code]
		if eventList then
			local eventList_event = eventList[event]
			if eventList_event then
				local good = false
				local checkKwargs = false
				local mustEvaluate = false
				local checkTable = false
				local multiArg = false
				if eventList_event == true then
					good = true
				elseif type(eventList_event) == "table" then
					good = true
					checkTable = true
				else
					local tab = newList(("#"):split(eventList_event))
					if #tab == 1 then
						if eventList_event == arg1 then
							good = true
						elseif eventList_event:match("^%$") then
							good = true
							checkKwargs = eventList_event:sub(2)
						elseif eventList_event:match("^%[.*%]$") then
							good = true
							mustEvaluate = eventList_event
						end
						tab = del(tab)
					else
						good = true
						multiArg = tab
					end
				end
				if good then
					local kwargs = callbackToKwargs[uid]
					good = true
					if multiArg then
						good = false
						for i, v in ipairs(multiArg) do
							local arg = select(i, ...)
							if not arg then
								good = false
							elseif v == arg then
								good = true
							elseif v:match("^%$") then
								good = kwargs[v:sub(2)] == arg
							elseif v:match("^%[.*%]$") then
								good = evaluate(v, nsList, kwargs) == arg
							else
								good = false
							end
							if not good then
								break
							end
						end
						multiArg = del(multiArg)
					elseif checkTable then
						good = false
						for k in pairs(eventList_event) do
							if k == arg1 then
								good = true
							else
								local multiArg = newList(("#"):split(k))
								for i, v in ipairs(multiArg) do
									local arg = select(i, ...)
									if not arg then
										good = false
									elseif v == arg then
										good = true
									elseif v:match("^%$") then
										good = kwargs[v:sub(2)] == arg
									elseif v:match("^%[.*%]$") then
										good = evaluate(v, nsList, kwargs) == arg
									else
										good = false
									end
									if not good then
										break
									end
								end
								multiArg = del(multiArg)
							end
							if good then
								break
							end
						end
					elseif mustEvaluate then
						good = evaluate(mustEvaluate, nsList, kwargs) == arg1
					elseif checkKwargs then
						good = kwargs[checkKwargs] == arg1
					end
					if good then
						local func = callbackToFunction[uid]
						local extraArg = callbackToExtraArg[uid]
						if extraArg ~= nil then
							func(extraArg, code, nsList, kwargs or nil)
						else
							func(code, nsList, kwargs or nil)
						end
					end
				end
			end
		end
	end
	
	local eventData_event = eventData[event]
	for fs, param in pairs(eventData_event) do
		local kwargs = fsToKwargs[fs]
		local nsList = fsToNSList[fs]
		local good = false
		local checkKwargs = false
		local mustEvaluate = false
		local checkTable = false
		local multiArg = false
		if param == true then
			good = true
		elseif type(param) == "table" then
			good = true
			checkTable = true
		else
			local tab = newList(("#"):split(param))
			if #tab == 1 then
				if param == arg1 then
					good = true
				elseif type(param) == "string" then
					if param:match("^%$") then
						good = true
						checkKwargs = param:sub(2)
					elseif param:match("^%[.*%]$") then
						good = true
						mustEvaluate = param
					end
				end
				tab = del(tab)
			else
				good = true
				multiArg = tab
			end
		end
		if good then
			if multiArg then
				good = false
				for i, v in ipairs(multiArg) do
					local arg = select(i, ...)
					if not arg then
						good = false
					elseif v == arg then
						good = true
					elseif tonumber(v) and type(arg) == "number" then
						good = tonumber(v) == arg
					elseif v:match("^%$") then
						good = kwargs[v:sub(2)] == arg
					elseif v:match("^%[.*%]$") then
						good = evaluate(v, nsList, kwargs) == arg
					else
						good = false
					end
					if not good then
						break
					end
				end
				multiArg = del(multiArg)
			elseif checkTable then
				good = false
				for k in pairs(param) do
					if k == arg1 then
						good = true
					else	
						local multiArg = newList(("#"):split(k))
						for i, v in ipairs(multiArg) do
							local arg = select(i, ...)
							if not arg then
								good = false
							elseif v == arg then
								good = true
							elseif tonumber(v) and type(arg) == "number" then
								good = tonumber(v) == arg
							elseif v:match("^%$") then
								good = kwargs[v:sub(2)] == arg
							elseif v:match("^%[.*%]$") then
								good = evaluate(v, nsList, kwargs) == arg
							else
								good = false
							end
							if not good then
								break
							end
						end
						multiArg = del(multiArg)
					end
					if good then
						break
					end
				end
			elseif mustEvaluate then
				good = evaluate(mustEvaluate, nsList, kwargs) == arg1
			elseif checkKwargs then
				good = kwargs[checkKwargs] == arg1
			end
			if good then
				fsNeedUpdate[fs] = true
			end
		end
	end
end
frame:SetScript("OnEvent", OnEvent)

local GetTime = _G.GetTime
--[[
-- I'm sorry, but this shit is just stupidly wasteful of CPU time.
local GetMilliseconds
if DogTag_DEBUG then
	function GetMilliseconds()
		return math.floor(GetTime() * 1000 + 0.5)
	end
else
	function GetMilliseconds()
		return GetTime() * 1000
	end
end]]

do	-- OnUpdate
	local nextTime = 0
	local nextUpdateTime = 0
	local nextSlowUpdateTime = 0
	local nextCacheInvalidationTime = 0
	local num = 0

	local start -- start time of each cycle

	-- Limit in milliseconds for each OnUpdate cycle.
	-- Under max load, this will let FPS drop no lower than 33 FPS (1000/30)
	-- as a result of the code in this function.
	local CoroutineLimit = 30

	-- Checks to see if we need to yield because the CoroutineLimit was exceeded.
	-- Call this after every significant call
	-- (especially external calls that will take an unknown amount of time)
	-- You can also call this externally through DogTag.checkYield()
	-- if you have an event handler that might take particularly long.
	local function checkYield()
		if running and InCombatLockdown() and debugprofilestop() - start > CoroutineLimit then
			coroutine.yield()
		end
	end
	DogTag.checkYield = checkYield

	local function OnUpdate_Coroutine()
		while true do
			running = true

			_clearCodes()
			num = num + 1

			local currentTime = GetTime()

			local oldMouseover = DogTag.__lastMouseover
			local newMouseover = GetMouseFocus()
			DogTag.__lastMouseover = newMouseover
			if oldMouseover ~= DogTag.__lastMouseover then
				for fs, frame in pairs(fsToFrame) do
					if frame == oldMouseover or frame == newMouseover then
						-- TODO: only update if has a mouseover event
						fsNeedQuickUpdate[fs] = true
					end
				end
			end

			if currentTime >= nextTime then
				DogTag:FireEvent("FastUpdate")
				checkYield()

				if currentTime >= nextUpdateTime then
					nextUpdateTime = currentTime + 0.15
					DogTag:FireEvent("Update")
					checkYield()
				end

				if currentTime >= nextSlowUpdateTime then
					nextSlowUpdateTime = currentTime + 10
					DogTag:FireEvent("SlowUpdate")
					checkYield()
				end

				if currentTime >= nextCacheInvalidationTime then
					nextCacheInvalidationTime = currentTime + 15

					-- The following code only happens out of combat,
					-- so there is no need to check for yields here.
					if not InCombatLockdown() then
						local oldTime = currentTime - 180
						for nsList, codeToFunction_nsList in pairs(codeToFunction) do
							for kwargTypes, codeToFunction_nsList_kwargTypes in pairs(codeToFunction_nsList) do
								if kwargTypes ~= 1 then
									for code in pairs(codeToFunction_nsList_kwargTypes) do
										if code ~= 1 and code ~= 2 then
											local x = codeEvaluationTime[nsList][kwargTypes][code]
											local good = false
											if x and x > oldTime then
												good = true
											else
												for fs, c in pairs(fsToCode) do
													if c == code and fsToNSList[fs] == nsList then
														good = true
														break
													end
												end
												if not good then
													for uid, c in pairs(callbackToCode) do
														if c == code and callbackToNSList[uid] == nsList then
															good = true
															break
														end
													end
												end
											end
											if not good then
												codeToFunction_nsList_kwargTypes[code] = nil
												codeToEventList[nsList][kwargTypes][code] = nil
											end
										end
									end
								end
							end
						end
					end
				end

				nextTime = currentTime + 0.05

				for i = 1, 9 do
					for ns, data in pairs(TimerHandlers) do
						local data_i = data[i]
						if data_i then
							for func in pairs(data_i) do
								func(num, currentTime)

								checkYield()
							end
						end
					end
				end
				
				for fs in pairs(fsNeedUpdate) do
					fsNeedQuickUpdate[fs] = true
					fsNeedUpdate[fs] = nil
				end
			end
			
			-- debugprofilestop is used now instead of GetTime because
			-- GetTime isn't updated until each frame is drawn. (recent change, WoW 4.3.0 i think?)
			-- Since this whole process takes place within one frame,
			-- GetTime will have the same value throughout.
			-- debugprofilestop is always updated (unless some jerkface resets it with debugprofilestart), so we have to use it instead
			
			-- Addendum to this explanation 8/1/2013 (r251):
			-- This part of the code now yields out of the coroutine instead of breaking the loop
			-- It still uses its own execution cap because the time spent updating font strings should be more tightly limited
			-- By yielding out instead of breaking the loop,
			-- we prevent the problem of only having the front strings that are in the top of the table get updated 
			-- while some sit in the bottom and never get seen.


			-- Don't define this until we loop through at least one frame
			-- so that we don't call debugprofilestop unless we need to:
			local finish_time --= debugprofilestop() + 10
			local n = 0
			
			for fs in pairs(fsNeedQuickUpdate) do
				n = n + 1
				if not finish_time then
					finish_time = debugprofilestop() + 10 -- 10 as in 10 miliseconds

				elseif n%20 == 0 and debugprofilestop() >= finish_time then

					-- Set finish_time to nil so that it will be recalculated when we resume.
					finish_time = nil

					coroutine.yield()
				end
				updateFontString(fs)
			end

			running = false

			-- Since this function is one continual while(true) loop,
			-- yield at the end each time and wait for the next resume
			-- triggered by the script handler.
			coroutine.yield()

		end
	end

	local Coroutine
	local function OnUpdate()
		start = debugprofilestop()

		-- Recreate the coroutine if it is dead (or create it if we haven't yet)
		-- (It will die if there was an error thrown in the middle of the last cycle).
		if not Coroutine or coroutine.status(Coroutine) == "dead" then
			Coroutine = coroutine.create(OnUpdate_Coroutine)
		end

		assert(coroutine.resume(Coroutine))
	end

	frame:SetScript("OnUpdate", OnUpdate)
end

--[[
Notes:
	Register a function to be called when the event is fired
	This should only be called by sublibraries
Arguments:
	string - the namespace to mark ownership with
	string - the name of the event
	function - the function to be called
Example:
	LibStub("LibDogTag-3.0"):AddEventHandler("MyNamespace", "PLAYER_LOGIN", function(event, ...)
		-- do something here.
	end)
]]
function DogTag:AddEventHandler(namespace, event, func)
	if type(namespace) ~= "string" then
		error(("Bad argument #2 to `AddEventHandler'. Expected %q, got %q"):format("string", type(namespace)), 2)
	end
	if type(event) ~= "string" then
		error(("Bad argument #3 to `AddEventHandler'. Expected %q, got %q"):format("string", type(event)), 2)
	end
	if type(func) ~= "function" then
		error(("Bad argument #4 to `AddEventHandler'. Expected %q, got %q"):format("function", type(func)), 2)
	end
	if not EventHandlers[namespace] then
		EventHandlers[namespace] = newList()
	end
	if not EventHandlers[namespace][event] then
		EventHandlers[namespace][event] = newList()
	end
	EventHandlers[namespace][event][func] = true
end

--[[
Notes:
	Remove an event handler that has been previously added
	This should only be called by sublibraries
Arguments:
	string - the namespace to mark ownership with
	string - the name of the event
	function - the function to be called
Example:
	LibStub("LibDogTag-3.0"):RemoveEventHandler("MyNamespace", "PLAYER_LOGIN", func)
]]
function DogTag:RemoveEventHandler(namespace, event, func)
	if type(namespace) ~= "string" then
		error(("Bad argument #2 to `RemoveEventHandler'. Expected %q, got %q"):format("string", type(namespace)), 2)
	end
	if type(event) ~= "string" then
		error(("Bad argument #3 to `RemoveEventHandler'. Expected %q, got %q"):format("string", type(event)), 2)
	end
	if type(func) ~= "function" then
		error(("Bad argument #4 to `RemoveEventHandler'. Expected %q, got %q"):format("function", type(func)), 2)
	end
	local EventHandlers_namespace = EventHandlers[namespace]
	if not EventHandlers_namespace then
		return
	end
	local EventHandlers_namespace_event = EventHandlers_namespace[event]
	if not EventHandlers_namespace_event then
		return
	end
	EventHandlers_namespace_event[func] = nil
	if not next(EventHandlers_namespace_event) then
		EventHandlers_namespace[event] = del(EventHandlers_namespace_event)
	end
	if not next(EventHandlers_namespace) then
		EventHandlers[namespace] = del(EventHandlers_namespace)
	end
end

--[[
Notes:
	Fire an event that any tags, handlers, or callbacks will see.
Arguments:
	string - name of the event
	tuple - a tuple of arguments
Example:
	LibStub("LibDogTag-3.0"):FireEvent("MyEvent", "Data", "goes", "here", 52)
]]
function DogTag:FireEvent(event, ...)
	OnEvent(frame, event, ...)
end

--[[
Notes:
	Register a function to be called roughly every 0.05 seconds
	This should only be called by sublibraries
Arguments:
	string - the namespace to mark ownership with
	function - the function to be called
	[optional] number - a number from 1 to 9 specifying the priority it will be called compared to other timers. 1 being called first and 9 being called last. Is 5 by default.
Example:
	LibStub("LibDogTag-3.0"):AddTimerHandler("MyNamespace", function(num, currentTime)
		-- do something here.
	end)
]]
function DogTag:AddTimerHandler(namespace, func, priority)
	if type(namespace) ~= "string" then
		error(("Bad argument #2 to `AddTimerHandler'. Expected %q, got %q"):format("string", type(namespace)), 2)
	end
	if type(func) ~= "function" then
		error(("Bad argument #3 to `AddTimerHandler'. Expected %q, got %q"):format("function", type(func)), 2)
	end
	if not priority then
		priority = 5
	elseif type(priority) ~= "number" then
		error(("Bad argument #4 to `AddTimerHandler'. Expected %q, got %q"):format("number", type(priority)), 2)
	elseif math.floor(priority) ~= priority then
		error("Bad argument #4 to `AddTimerHandler'. Expected integer, got number", 2)
	elseif priority < 1 or priority > 9 then
		error(("Bad argument #4 to `AddTimerHandler'. Expected [1, 9], got %d"):format(priority), 2)
	end
	self:RemoveTimerHandler(namespace, func)
	if not TimerHandlers[namespace] then
		TimerHandlers[namespace] = newList()
	end
	if not TimerHandlers[namespace][priority] then
		TimerHandlers[namespace][priority] = newList()
	end
	TimerHandlers[namespace][priority][func] = true
end

--[[
Notes:
	Remove a timer handler that has previously been added
	This should only be called by sublibraries
Arguments:
	string - the namespace to mark ownership with
	function - the function to be called
Example:
	LibStub("LibDogTag-3.0"):RemoveTimerHandler("MyNamespace", func)
]]
function DogTag:RemoveTimerHandler(namespace, func)
	if type(namespace) ~= "string" then
		error(("Bad argument #2 to `RemoveTimerHandler'. Expected %q, got %q"):format("string", type(namespace)), 2)
	end
	if type(func) ~= "function" then
		error(("Bad argument #3 to `RemoveTimerHandler'. Expected %q, got %q"):format("function", type(func)), 2)
	end
	if not TimerHandlers[namespace] then
		return
	end
	for k, v in pairs(TimerHandlers[namespace]) do
		v[func] = nil
		if not next(v) then
			TimerHandlers[namespace][k] = del(v)
		end
	end
	if not next(TimerHandlers[namespace]) then
		TimerHandlers[namespace] = del(TimerHandlers[namespace])
	end
end

end
