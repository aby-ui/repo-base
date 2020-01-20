--[[
Name: LibDogTag-3.0
Revision: $Rev$
Author: Cameron Kenneth Knight (ckknight@gmail.com)
Website: http://www.wowace.com/
Description: A library to provide a markup syntax
]]

local MAJOR_VERSION = "LibDogTag-3.0"
local MINOR_VERSION = 90000 + (tonumber(("20200115020223"):match("%d+")) or 33333333333333)

if MINOR_VERSION > _G.DogTag_MINOR_VERSION then
	_G.DogTag_MINOR_VERSION = MINOR_VERSION
end

local type, error, pairs, ipairs, next, pcall, _G = type, error, pairs, ipairs, next, pcall, _G

-- #AUTODOC_NAMESPACE DogTag

DogTag_funcs[#DogTag_funcs+1] = function(DogTag)

local L = DogTag.L

local newList, newSet, del, deepCopy = DogTag.newList, DogTag.newSet, DogTag.del, DogTag.deepCopy
local select2 = DogTag.select2
local fixNamespaceList = DogTag.fixNamespaceList
local memoizeTable = DogTag.memoizeTable
local deepCompare = DogTag.deepCompare
local kwargsToKwargTypes = DogTag.kwargsToKwargTypes
local kwargsToKwargTypesWithTableCache = DogTag.kwargsToKwargTypesWithTableCache
local fsNeedUpdate, fsNeedQuickUpdate, codeToFunction, codeToEventList, eventData, clearCodes
local clearCodes = DogTag.clearCodes
DogTag_funcs[#DogTag_funcs+1] = function()
	fsNeedUpdate = DogTag.fsNeedUpdate
	fsNeedQuickUpdate = DogTag.fsNeedQuickUpdate
	codeToFunction = DogTag.codeToFunction
	codeToEventList = DogTag.codeToEventList
	eventData = DogTag.eventData
end

local fsToFrame, fsToCode, fsToNSList, fsToKwargs, Tags, AddonFinders
if DogTag.oldLib then
	local oldLib = DogTag.oldLib
	fsToFrame = oldLib.fsToFrame
	fsToCode = oldLib.fsToCode
	fsToNSList = oldLib.fsToNSList
	fsToKwargs = oldLib.fsToKwargs
	local tmp = {}
	for fs, kwargs in pairs(fsToKwargs) do
		tmp[fs] = memoizeTable(deepCopy(kwargs))
		fsToKwargs[fs] = nil
	end
	for fs, kwargs in pairs(tmp) do
		fsToKwargs[fs] = kwargs
	end
	tmp = nil
	Tags = oldLib.Tags
	Tags["Base"] = {}
	AddonFinders = oldLib.AddonFinders
	AddonFinders["Base"] = {}
else
	fsToFrame = {}
	fsToCode = {}
	fsToNSList = {}
	fsToKwargs = {}
	Tags = { ["Base"] = {} }
	AddonFinders = { ["Base"] = {} }
end
DogTag.fsToFrame = fsToFrame
DogTag.fsToCode = fsToCode
DogTag.fsToNSList = fsToNSList
DogTag.fsToKwargs = fsToKwargs

DogTag.Tags = Tags
DogTag.AddonFinders = AddonFinders

local sortStringList = DogTag.sortStringList

DogTag.__colors = {
	minHP = { 1, 0, 0 },
	midHP = { 1, 1, 0 },
	maxHP = { 0, 1, 0 },
	unknown = { 0.8, 0.8, 0.8 },
	hostile = { 226/255, 45/255, 75/255 },
	neutral = { 1, 1, 34/255 },
	friendly = { 0.2, 0.8, 0.15 },
	civilian = { 48/255, 113/255, 191/255 },
	dead = { 0.6, 0.6, 0.6 },
	tapped = { 0.5, 0.5, 0.5 },
	disconnected = { 0.7, 0.7, 0.7 },
	petHappy = { 0, 1, 0 },
	petNeutral = { 1, 1, 0 },
	petAngry = { 1, 0, 0 },
	rage = { 226/255, 45/255, 75/255 },
	energy = { 1, 220/255, 25/255 },
	focus = { 1, 210/255, 0 },
	mana = { 48/255, 113/255, 191/255 },
	runicPower = { 0, 209/255, 1 },
}
for class, data in pairs(_G.RAID_CLASS_COLORS) do
	DogTag.__colors[class] = { data.r, data.g, data.b, }
end

--[[
Notes:
	Adds a tag to the specified namespace
Arguments:
	string - namespace to add to
	string - name of the tag
	table - data of the tag
Example:
	LibStub("LibDogTag-3.0"):AddTag("MyNamespace", "Square", {
		code = function(number) -- actual function that will be called
			return number * number
		end,
		arg = {
			'number', 'number', '@req', -- name, types, default
		},
		ret = 'number', -- return value
		events = "SOME_EVENT#$number", -- will update when SOME_EVENT with the argument `number` is dispatched
		doc = "Return the square of number", -- the description
		example = '[4:Square] => "16"; [5:Square] => "25"', -- show one or more examples in this format
		category = "Category name",
	})
]]
function DogTag:AddTag(namespace, tag, data)
	if type(namespace) ~= "string" then
		error(("Bad argument #2 to `AddTag'. Expected %q, got %q"):format("string", type(namespace)), 2)
	end
	if type(tag) ~= "string" then
		error(("Bad argument #3 to `AddTag'. Expected %q, got %q"):format("string", type(tag)), 2)
	end
	if type(data) ~= "table" then
		error(("Bad argument #4 to `AddTag'. Expected %q, got %q"):format("table", type(data)), 2)
	end
	
	if not Tags[namespace] then
		Tags[namespace] = {}
	end
	if Tags["Base"][tag] or Tags[namespace][tag] then
		error(("Bad argument #3 to `AddTag'. %q already registered"):format(tag), 2)
	end
	local tagData = newList()
	Tags[namespace][tag] = tagData
	
	local arg = data.arg
	if arg then
		if type(arg) ~= "table" then
			error("arg must be a table", 2)
		end
		if #arg % 3 ~= 0 then
			error("arg must be a table with a length a multiple of 3", 2)
		end
		for i = 1, #arg, 3 do
			local key, types, default = arg[i], arg[i+1], arg[i+2]
			if type(key) ~= "string" then
				error("arg must have its keys as strings", 2)
			end
			if type(types) ~= "string" then
				error("arg must have its types as strings", 2)
			end
			if types:match("^tuple%-") then
				if key ~= "..." then
					error("arg must have its key be ... if it is a tuple.", 2)
				end
				local tupleTypes = types:sub(7)
				local t = newSet((';'):split(tupleTypes))
				for k in pairs(t) do
					if k ~= "nil" and k ~= "number" and k ~= "string" and k ~= "boolean" then
						error("arg can only have tuples of nil, number, string, or boolean", 2)
					end
				end
				if t["boolean"] and (next(t, "boolean") or next(t) ~= "boolean") then
					error("arg cannot specify both boolean and something else", 2)
				end
				t = del(t)
				arg[i+1] = "tuple-" .. sortStringList(tupleTypes)
			else
				local t = newSet((';'):split(types))
				for k in pairs(t) do
					if k ~= "nil" and k ~= "number" and k ~= "string" and k ~= "undef" and k ~= "boolean" then
						error("arg must have nil, number, string, undef, boolean, or tuple", 2)
					end
				end
				if not key:match("^[a-z]+$") then
					error("arg must have its key be a string of lowercase letters.", 2)
				end
				if t["nil"] and t["undef"] then
					error("arg cannot specify both nil and undef", 2)
				end
				if t["boolean"] and (next(t, "boolean") or next(t) ~= "boolean") then
					error("arg cannot specify both boolean and something else", 2)
				end
				t = del(t)
				arg[i+1] = sortStringList(types)
			end
		end
		tagData.arg = arg
	end
	if data.alias then
		if type(data.alias) == "string" then
			tagData.alias = data.alias
		else -- function
			tagData.alias = data.alias()
			tagData.aliasFunc = data.alias
		end
	else
		local ret = data.ret
		if type(ret) == "string" then
			tagData.ret = sortStringList(ret)
			if ret then
				local rets = newSet((";"):split(ret))
				for k in pairs(rets) do
					if k ~= "nil" and k ~= "number" and k ~= "string" and k ~= "boolean" then
						error("ret must have nil, number, string, or boolean", 2)
					end
				end
				rets = del(rets)
			end
		elseif type(ret) == "function" then
			tagData.ret = ret
		else
			error(("ret must be a string or a function which returns a string, got %s"):format(type(ret)), 2)
		end
		if data.events then
			if type(data.events) == "string" then
				tagData.events = sortStringList(data.events)
			elseif type(data.events) == "function" then
				tagData.events = data.events
			else
				error(("events must be a string, function, or nil, got %s"):format(type(data.events)), 2)
			end
		end
		tagData.alias = data.fakeAlias
		if type(data) == "function" then
			tagData.static = data.static
		else
			tagData.static = data.static and true or nil
		end
		if tagData.static and tagData.events then
			error("Cannot specify both static and events", 2)
		end
		if type(data.code) ~= "function" then
			error(("code must be a function, got %s"):format(type(data.code)), 2)
		end
		tagData.code = data.code
		tagData.dynamicCode = data.dynamicCode and true or nil
	end
	tagData.doc = data.doc
	if data.doc and type(data.doc) ~= "string" then
		error(("doc must be nil or a string, got %s"):format(type(data.doc)), 2)
	end
	tagData.example = data.example
	if data.doc then
		if type(data.example) ~= "string" then
			error(("if doc is supplied, example must be a string, got %s"):format(type(data.example)), 2)
		end
		local examples = newList((";"):split(data.example))
		for i, v in ipairs(examples) do
			if not v:trim():match("^%[.*%] => \".*\"$") then
				error(("example must be in the form of [Tag sequence] => \"Result\", %s is not in said form."):format(v:trim()))
			end
		end
	else
		if data.example then
			error("if doc is not supplied, example must be nil", 2)
		end
	end
	tagData.category = data.category
	if data.doc then
		if type(data.category) ~= "string" then
			error(("if doc is supplied, category must be a string, got %s"):format(type(data.category)), 2)
		end
	else
		if data.category then
			error("if doc is not supplied, category must be nil", 2)
		end
	end
	if data.noDoc and type(data.doc) ~= "nil" then
		error(("doc must be nil if noDoc is true, got %s"):format(type(data.doc)), 2)
	end
	tagData.noDoc = data.noDoc
	del(data)
	clearCodes(namespace)
end

local function updateFontString(fs)
	fsNeedUpdate[fs] = nil
	fsNeedQuickUpdate[fs] = nil
	
	local code = fsToCode[fs]
	if code then
		local nsList = fsToNSList[fs]
		local kwargs = fsToKwargs[fs]
		local kwargTypes = kwargsToKwargTypesWithTableCache[kwargs]
		local func = codeToFunction[nsList][kwargTypes][code]
		DogTag.__isMouseOver = DogTag.__lastMouseover == fsToFrame[fs]
		
		local success, text, opacity, outline = pcall(func, kwargs)
		if not success then
			DogTag.tagError(code, nsList, text)
			return
		end
	
		if success then
			fs:SetText(text)
			if opacity then
				fs:SetAlpha(opacity)
			end
			local a, b, c = fs:GetFont()
			if c ~= (outline or '') then
				fs:SetFont(a, b, outline or '')
			end
		end
	end
end
DogTag.updateFontString = updateFontString

--[[
Notes:
	Manually updates a FontString previously registered.
Arguments:
	frame - the FontString previously registered
Example:
	LibStub("LibDogTag-3.0"):UpdateFontString(fs)
]]
function DogTag:UpdateFontString(fs)
	local code = fsToCode[fs]
	if code then
		updateFontString(fs)
	end
end

--[[
Notes:
	Manually updates all FontStrings on a specified frame.
Arguments:
	frame - the frame which to update all FontStrings on
Example:
	LibStub("LibDogTag-3.0"):UpdateAllForFrame(frame)
]]
function DogTag:UpdateAllForFrame(frame)
	for fs, f in pairs(fsToFrame) do
		if frame == f then
			updateFontString(fs)
		end
	end
end

--[[
Notes:
	Adds a FontString to LibDogTag-3.0's registry, which will be updated automatically.
	You can add twice without removing. It will just overwrite the previous registration.
	You can specify any number of namespaces. "Base" is always included as a namespace.
	The kwargs table is optional and always goes on the end after the namespaces. You can recycle the table after registering.
Arguments:
	frame - the FontString to register
	frame - the Frame which holds the FontString
	string - the tag sequence
	[optional] string - a semicolon-separated list of namespaces. Base is implied
	[optional] table - a dictionary of default kwargs for all tags in the code to receive
Example:
	LibStub("LibDogTag-3.0"):AddFontString(fs, fs:GetParent(), "[Name]", "Unit", { unit = 'mouseover' })
	LibStub("LibDogTag-3.0"):AddFontString(fs, fs:GetParent(), "[Tag]", "MyNamespace")
	LibStub("LibDogTag-3.0"):AddFontString(fs, fs:GetParent(), "[Tag] [Name]", "MyNamespace;Unit", { value = 5, unit = 'player', }) -- two namespaces at once
]]
function DogTag:AddFontString(fs, frame, code, nsList, kwargs)
	if type(fs) ~= "table" then
		error(("Bad argument #2 to `AddFontString'. Expected %q, got %q."):format("table", type(fs)), 2)
	elseif type(frame) ~= "table" then
		error(("Bad argument #3 to `AddFontString'. Expected %q, got %q."):format("table", type(frame)), 2)
	elseif type(code) ~= "string" then
		error(("Bad argument #4 to `AddFontString'. Expected %q, got %q."):format("string", type(code)), 2)
	elseif nsList and type(nsList) ~= "string" then
		error(("Bad argument #5 to `AddFontString'. Expected %q, got %q."):format("string", type(nsList)), 2)
	elseif kwargs and type(kwargs) ~= "table" then
		error(("Bad argument #6 to `AddFontString'. Expected %q, got %q."):format("table", type(kwargs)), 2)
	end
	nsList = fixNamespaceList[nsList]
	
	--[[ Cybeloras 7-4-2012:
		Noticed a massive performance bottleneck in this function, and this is what I discovered:
		
		Using a kwargs table of {color=true,group=3,icons=108} (a pretty normal table, just 3 values),
		the following were the results of two different methods to test if the tables are the same:
		
		Over 500,000 iterations:
			memoizeTable(deepCopy(kwargs))		averaged an execution time of 0.0270833 seconds
			deepCompare(fsToKwargs[fs], kwargs)	averaged an execution time of 0.0038213 seconds
		
		Giving a 608.74% speed advantage to deepCompare
		
		If we deepCompare first to see if we can return early (which should happen almost all the time,
		because kwargs change very infrequently), the performance boost is massive. If deepCompare reveals that the kwargs have changed,
		then we can go on to memoizeTable for the rest of the function.
		
		Code changes:
			Moved ( kwargs = memoizeTable(deepCopy(kwargs)) ) down below the if block
			Changed ( fsToKwargs[fs] == kwargs ) to ( deepCompare(fsToKwargs[fs], kwargs) )
			Added function DogTag.deepCompare to Helpers.lua
			Added deepCompare = DogTag.deepCompare upvalue to this file's header
	]]
	
	if fsToCode[fs] then
		if fsToFrame[fs] == frame and fsToCode[fs] == code and fsToNSList[fs] == nsList and deepCompare(fsToKwargs[fs], kwargs) then
			fsNeedUpdate[fs] = true
			return
		end
		self:RemoveFontString(fs)
	end
	
	kwargs = memoizeTable(deepCopy(kwargs))
	
	fsToFrame[fs] = frame
	fsToCode[fs] = code
	fsToNSList[fs] = nsList
	fsToKwargs[fs] = kwargs
	
	local kwargTypes = kwargsToKwargTypesWithTableCache[kwargs]
	
	local codeToEventList_nsList_kwargTypes_code = codeToEventList[nsList][kwargTypes][code]
	if codeToEventList_nsList_kwargTypes_code == nil then
		local _ = codeToFunction[nsList][kwargTypes][code] -- i guess this is just to invoke a metamethod. everybody loves commented code!
		codeToEventList_nsList_kwargTypes_code = codeToEventList[nsList][kwargTypes][code]
		if codeToEventList_nsList_kwargTypes_code == nil then
			local _, minor = LibStub(MAJOR_VERSION)
			error(("%s.%d: Error with code %q (%s). Event list not created. Please inform ckknight."):format(MAJOR_VERSION, minor, code, nsList))
		end
	end
	if codeToEventList_nsList_kwargTypes_code then
		for event, arg in pairs(codeToEventList_nsList_kwargTypes_code) do
			eventData[event][fs] = arg
		end
	end
	
	updateFontString(fs)
end

--[[
Notes:
	Removes a registered FontString from LibDogTag-3.0's registry.
	You can remove twice without issues.
Arguments:
	frame - the FontString previously registered
Example:
	LibStub("LibDogTag-3.0"):RemoveFontString(fs)
]]
function DogTag:RemoveFontString(fs)
	if type(fs) ~= "table" then
		error(("Bad argument #2 to `RemoveFontString'. Expected %q, got %q"):format("table", type(fs)), 2)
	end
	local code = fsToCode[fs]
	if not code then
		return
	end
	local frame = fsToFrame[fs]
	local nsList = fsToNSList[fs]
	local kwargs = fsToKwargs[fs]
	
	fsToCode[fs], fsToFrame[fs], fsToNSList[fs], fsToKwargs[fs] = nil, nil, nil, nil
	fsNeedUpdate[fs], fsNeedQuickUpdate[fs] = nil, nil
	
	local kwargTypes = kwargsToKwargTypesWithTableCache[kwargs]
	
	local codeToEventList_nsList_kwargTypes_code = codeToEventList[nsList][kwargTypes][code]
	if codeToEventList_nsList_kwargTypes_code then
		for event in pairs(codeToEventList_nsList_kwargTypes_code) do
			eventData[event][fs] = nil
		end
	end
	
	fs:SetText(nil)
	local a, b = fs:GetFont()
	fs:SetFont(a, b, "")
end

--[[
Notes:
	Adds a handler to be called when an addon or library comes into being
	This should only really be called by sublibraries or addons that register tags.
Arguments:
	string - namespace the addon finder is associated with
	string - "_G" for a value on the global table or "LibStub", "Rock", "AceLibrary" for a library of the specified type
	string - name of the addon or library
	function - function to be called when addon or library is found
Example:
	LibStub("DogTag-3.0"):AddAddonFinder("MyNamespace", "LibStub", "LibMonkey-1.0", function(LibMonkey)
		-- do something with LibMonkey now
	end)
]]
function DogTag:AddAddonFinder(namespace, kind, name, func)
	if type(namespace) ~= "string" then
		error(("Bad argument #2 to `AddAddonFinder'. Expected %q, got %q"):format("string", type(namespace)), 2)
	end
	if type(kind) ~= "string" then
		error(("Bad argument #3 to `AddAddonFinder'. Expected %q, got %q"):format("string", type(kind)), 2)
	end
	if kind ~= "_G" and kind ~= "LibStub" and kind ~= "Rock" and kind ~= "AceLibrary" then
		error(("Bad argument #3 to `AddAddonFinder'. Expected %q, %q, %q or %q, got %q"):format("_G", "LibStub", "Rock", "AceLibrary", kind), 2)
	end
	if type(name) ~= "string" then
		error(("Bad argument #4 to `AddAddonFinder'. Expected %q, got %q"):format("string", type(name)), 2)
	end
	if type(func) ~= "function" then
		error(("Bad argument #5 to `AddAddonFinder'. Expected %q, got %q"):format("function", type(func)), 2)
	end
	if not AddonFinders[namespace] then
		AddonFinders[namespace] = {}
	end
	AddonFinders[namespace][newList(kind, name, func)] = true
end

local inADDON_LOADED = false
local accessed_ADDON_LOADED = false
function DogTag:ADDON_LOADED()
	if inADDON_LOADED then
		accessed_ADDON_LOADED = true
		return
	end
	inADDON_LOADED = true
	accessed_ADDON_LOADED = false
	for namespace, data in pairs(AddonFinders) do
		local refresh = false
		for k in pairs(data) do
			local kind, name, func = k[1], k[2], k[3]
			if kind == "_G" then
				if _G[name] then
					data[k] = nil
					del(k)
					func(_G[name])
					refresh = true
				end
			elseif kind == "AceLibrary" then
				if AceLibrary and AceLibrary:HasInstance(name) then
					data[k] = nil
					del(k)
					func(AceLibrary(name))
					refresh = true
				end
			elseif kind == "Rock" then
				if Rock and Rock:HasLibrary(name) then
					data[k] = nil
					del(k)
					func(Rock:GetLibrary(name))
					refresh = true
				end
			elseif kind == "LibStub" then
				if Rock then
					Rock:HasLibrary(name) -- try to load
				end
				if AceLibrary then
					AceLibrary:HasInstance(name) -- try to load
				end
				LoadAddOn(name)
				if LibStub:GetLibrary(name, true) then
					data[k] = nil
					del(k)
					func(LibStub:GetLibrary(name))
					refresh = true
				end
			end
		end
		if refresh then
			clearCodes(namespace)
		end
	end
	inADDON_LOADED = false
	if accessed_ADDON_LOADED then
		self:ADDON_LOADED()
	end
end

--[[
Notes:
	Clears a namespace's tags and any other relevant data.
	This should be called when a sublibrary is upgrading.
Arguments:
	string - namespace that is to be cleared
Example:
	LibStub("LibDogTag-3.0"):ClearNamespace("MyNamespace")
]]
function DogTag:ClearNamespace(namespace)
	if type(namespace) ~= "string" then
		error(("Bad argument #2 to `ClearNamespace'. Expected %q, got %q"):format("string", type(namespace)), 2)
	end
	Tags[namespace] = nil
	AddonFinders[namespace] = nil
	self.EventHandlers[namespace] = nil
	self.TimerHandlers[namespace] = nil
	clearCodes(namespace)
	collectgarbage('collect')
end

end
