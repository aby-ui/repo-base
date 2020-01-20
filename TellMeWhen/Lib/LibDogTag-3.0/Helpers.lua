local MAJOR_VERSION = "LibDogTag-3.0"
local MINOR_VERSION = 90000 + (tonumber(("20200115020223"):match("%d+")) or 33333333333333)

if MINOR_VERSION > _G.DogTag_MINOR_VERSION then
	_G.DogTag_MINOR_VERSION = MINOR_VERSION
end

local _G, pairs, ipairs, type, table, tostring, rawget, assert, next, select, error, setmetatable, unpack, next =
	  _G, pairs, ipairs, type, table, tostring, rawget, assert, next, select, error, setmetatable, unpack, next

-- #AUTODOC_NAMESPACE DogTag

DogTag_funcs[#DogTag_funcs+1] = function(DogTag)

local poolNum = 0
local newList, newDict, newSet, del, deepDel, deepCopy
do
	local pool = setmetatable({}, {__mode='k'})
	function newList(...)
		poolNum = poolNum + 1
		local t = next(pool)
		if t then
			pool[t] = nil
			for i = 1, select('#', ...) do
				t[i] = select(i, ...)
			end
		else
			t = { ... }
		end
		-- if TABLE_DEBUG and pool == normalPool then
		-- 	TABLE_DEBUG[#TABLE_DEBUG+1] = { '***', "newList", poolNum, tostring(t), debugstack() }
		-- end
		return t
	end
	function newDict(...)
		poolNum = poolNum + 1
		local t = next(pool)
		if t then
			pool[t] = nil
		else
			t = {}
		end
		for i = 1, select('#', ...), 2 do
			t[select(i, ...)] = select(i+1, ...)
		end
		-- if TABLE_DEBUG and pool == normalPool then
		-- 	TABLE_DEBUG[#TABLE_DEBUG+1] = { '***', "newDict", poolNum, tostring(t), debugstack() }
		-- end
		return t
	end
	function newSet(...)
		poolNum = poolNum + 1
		local t = next(pool)
		if t then
			pool[t] = nil
		else
			t = {}
		end
		for i = 1, select('#', ...) do
			t[select(i, ...)] = true
		end
		-- if TABLE_DEBUG and pool == normalPool then
		-- 	TABLE_DEBUG[#TABLE_DEBUG+1] = { '***', "newSet", poolNum, tostring(t), debugstack() }
		-- end
		return t
	end
	function del(t)
		if type(t) ~= "table" then
			error(("Bad argument #1 to `del'. Expected %q, got %q (%s)."):format("table", type(t), tostring(t)), 2)
		end
		if pool[t] then
			error("Double-free syndrome.", 2)
		end
		pool[t] = true
		poolNum = poolNum - 1
		for k in pairs(t) do
			t[k] = nil
		end
		setmetatable(t, nil)
		t[''] = true
		t[''] = nil
		
		-- if TABLE_DEBUG then
		-- 	local tostring_t = tostring(t)
		-- 	TABLE_DEBUG[#TABLE_DEBUG+1] = { '***', "del", poolNum, tostring_t, debugstack() }
		-- 	for _, line in ipairs(TABLE_DEBUG) do
		-- 		if line[4] == tostring_t then
		-- 			line[1] = ''
		-- 		end
		-- 	end
		-- 	pool[t] = nil
		-- end
		return nil
	end
	local deepDel_data
	function deepDel(t)
		local made_deepDel_data = not deepDel_data
		if made_deepDel_data then
			deepDel_data = newList()
		end
		if type(t) == "table" and not deepDel_data[t] then
			deepDel_data[t] = true
			for k,v in pairs(t) do
				deepDel(v)
				deepDel(k)
			end
			del(t)
		end
		if made_deepDel_data then
			deepDel_data = del(deepDel_data)
		end
		return nil
	end
	function deepCopy(t)
		if type(t) ~= "table" then
			return t
		else
			local u = newList()
			for k, v in pairs(t) do
				u[deepCopy(k)] = deepCopy(v)
			end
			return u
		end
	end
end
DogTag.newList, DogTag.newDict, DogTag.newSet, DogTag.del, DogTag.deepDel, DogTag.deepCopy = newList, newDict, newSet, del, deepDel, deepCopy

local DEBUG = _G.DogTag_DEBUG -- set in test.lua
if DEBUG then
	DogTag.getPoolNum = function()
		return poolNum
	end
	DogTag.setPoolNum = function(value)
		poolNum = value
	end
end

local function sortStringList(s)
	if not s then
		return nil
	end
	local set = newSet((";"):split(s))
	local list = newList()
	for k in pairs(set) do
		list[#list+1] = k
	end
	set = del(set)
	table.sort(list)
	local q = table.concat(list, ';')
	list = del(list)
	return q
end
DogTag.sortStringList = sortStringList

local function select2(min, max, ...)
	if min <= max then
		return select(min, ...), select2(min+1, max, ...)
	end
end
DogTag.select2 = select2

local function joinSet(set, connector)
	local t = newList()
	for k in pairs(set) do
		t[#t+1] = k
	end
	table.sort(t)
	local s = table.concat(t, connector)
	t = del(t)
	return s
end
DogTag.joinSet = joinSet

local fixNamespaceList = setmetatable({}, {__index = function(self, nsList)
	if not nsList then
		return self[""]
	end
	local t = newSet((";"):split(nsList))
	t[""] = nil
	t["Base"] = true
	local s = joinSet(t, ';')
	t = del(t)
	self[nsList] = s
	return s
end})
DogTag.fixNamespaceList = fixNamespaceList

local unpackNamespaceList = setmetatable({}, {__index = function(self, key)
	local t = {(";"):split(key)}
	self[key] = t
	return t
end, __call = function(self, key)
	return unpack(self[key])
end})
DogTag.unpackNamespaceList = unpackNamespaceList

local function getASTType(ast)
	if not ast then
		return "nil"
	end
	local type_ast = type(ast)
	if type_ast ~= "table" then
		return type_ast
	end
	return ast[1]
end
DogTag.getASTType = getASTType

local memoizeTable
do
	local function key_sort(alpha, bravo)
		local type_alpha, type_bravo = type(alpha), type(bravo)
		if type_alpha ~= type_bravo then
			return type_alpha < type_bravo
		end
		if type_alpha == "string" or type_alpha == "number" then
			return alpha < bravo
		elseif type_alpha == "boolean" then
			return not alpha and bravo
		elseif type_alpha == "table" then
			local alpha_len, bravo_len = #alpha, #bravo
			if alpha_len ~= bravo_len then
				return alpha_len < bravo_len
			end
			for i, v in ipairs(alpha) do
				local u = bravo[i]
				local one = key_sort(v, u)
				if not one then
					local two = key_sort(u, v)
					if two then
						return false
					end
				else
					return true
				end
			end
			local alpha_klen, bravo_klen = 0, 0
			for k in pairs(alpha) do
				alpha_klen = alpha_klen + 1
			end
			for k in pairs(bravo) do
				bravo_klen = bravo_klen + 1
			end
			if alpha_klen ~= bravo_klen then
				return alpha_klen < bravo_klen
			end
			if alpha_klen ~= alpha_len then
				local alpha_keys, bravo_keys = newList(), newList()
				for k in pairs(alpha) do
					alpha_keys[#alpha_keys+1] = k
				end
				table.sort(alpha_keys, key_sort)
				for k in pairs(bravo) do
					bravo_keys[#bravo_keys+1] = k
				end
				table.sort(bravo_keys, key_sort)
				for i, k in ipairs(alpha_keys) do
					local l = bravo_keys[i]
					local one = key_sort(k, l)
					if not one then
						local two = key_sort(l, k)
						if two then
							alpha_keys, bravo_keys = del(alpha_keys), del(bravo_keys)
							return false
						end
					else
						alpha_keys, bravo_keys = del(alpha_keys), del(bravo_keys)
						return true
					end
					local v, u = alpha[k], bravo[l]
					local one = key_sort(v, u)
					if not one then
						local two = key_sort(u, v)
						if two then
							alpha_keys, bravo_keys = del(alpha_keys), del(bravo_keys)
							return false
						end
					else
						alpha_keys, bravo_keys = del(alpha_keys), del(bravo_keys)
						return true
					end
				end
				alpha_keys, bravo_keys = del(alpha_keys), del(bravo_keys)
			end
			return false
		end
		return false
	end
	local function tableToString(tab, t)
		local type_tab = type(tab)
		if type_tab ~= "table" then
			if type_tab == "number" or type_tab == "string" then
				t[#t+1] = tab
			else
				t[#t+1] = tostring(tab)
			end
			return
		end
		local keys = newList()
		for k in pairs(tab) do
			keys[#keys+1] = k
		end
		table.sort(keys, key_sort)
		for _, k in ipairs(keys) do
			local v = tab[k]
			tableToString(k, t)
			t[#t+1] = '='
			tableToString(v, t)
			t[#t+1] = ';'
		end
		keys = del(keys)
	end
	
	local pool = setmetatable({}, {__mode='v'})
	function memoizeTable(tab)
		if type(tab) ~= "table" then
			return tab
		end
		local t = newList()
		tableToString(tab, t)
		local key = table.concat(t)
		t = del(t)
		local pool_key = pool[key]
		if pool_key then
			deepDel(tab)
			return pool_key
		else
			pool[key] = tab
			return tab
		end
	end
end
DogTag.memoizeTable = memoizeTable

local function deepCompare(t1,t2)
	local ty1 = type(t1)
	local ty2 = type(t2)
	if ty1 ~= ty2 then return false end
	-- non-table types can be directly compared
	if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end
	for k1,v1 in pairs(t1) do
		local v2 = t2[k1]
		if v2 == nil or not deepCompare(v1,v2) then return false end
	end
	for k2,v2 in pairs(t2) do
		local v1 = t1[k2]
		if v1 == nil or not deepCompare(v1,v2) then return false end
	end
	return true
end
DogTag.deepCompare = deepCompare

local kwargsToKwargTypes, kwargsToKwargTypesWithTableCache
do
	
	kwargsToKwargTypes = setmetatable({}, { __index = function(self, kwargs)
		if not kwargs then
			return self[""]
		elseif kwargs == "" then
			local t = {}
			self[false] = t
			self[""] = t
			return t
		end
		
		local kwargTypes = newList()
		local keys = newList()
		for k in pairs(kwargs) do
			keys[#keys+1] = k
		end
		table.sort(keys)
		local t = newList()
		for i,k in ipairs(keys) do
			if i > 1 then
				t[#t+1] = ";"
			end
			local v = kwargs[k]
			t[#t+1] = k
			t[#t+1] = "="
			local type_v = type(v)
			t[#t+1] = type_v
			kwargTypes[k] = type_v
		end
		keys = del(keys)
		local s = table.concat(t)
		t = del(t)
		local self_s = rawget(self, s)
		if self_s then
			kwargTypes = del(kwargTypes)
			
			return self_s
		end
		local t = {}
		for k, v in pairs(kwargTypes) do
			t[k] = v
		end
		kwargTypes = del(kwargTypes)
		kwargTypes = t
		self[s] = kwargTypes
		
		return kwargTypes
	end, __mode='kv' })
	
	-- This is separate from kwargsToKwargTypes because in some cases,
	-- a reused kwargs (reused by the addon providing it to DogTag)
	-- will cause a possibly incorrect kwargTypes table to be returned.
	-- This cache should only be used in places where we are certain that the kwargs
	-- table is not being reused - this is usually true if:
	-- 		We memoizeTable(deepCopy(kwargs))
	-- 		Or if kwargs is obtained from fsToKwargs[fs] or callbackToKwargs[uid]
	--			(because all kwargs in these tables have had memoizeTable(deepCopy(kwargs)) performed)
	
	kwargsToKwargTypesWithTableCache = setmetatable({}, { __index = function(self, kwargs)
		local kwargTypes = kwargsToKwargTypes[kwargs]
		if not kwargs then
			return kwargTypes
		end
		self[kwargs] = kwargTypes
		return kwargTypes
	end, __mode='kv' })
end
DogTag.kwargsToKwargTypes = kwargsToKwargTypes
DogTag.kwargsToKwargTypesWithTableCache = kwargsToKwargTypesWithTableCache

local codeToFunction, codeToEventList, callbackToNSList, callbackToCode, callbackToKwargTypes, eventData
local fsToNSList, fsToKwargs, fsToCode, fsNeedQuickUpdate
DogTag_funcs[#DogTag_funcs+1] = function()
	codeToFunction = DogTag.codeToFunction
	codeToEventList = DogTag.codeToEventList
	callbackToNSList = DogTag.callbackToNSList
	callbackToCode = DogTag.callbackToCode
	callbackToKwargTypes = DogTag.callbackToKwargTypes
	eventData = DogTag.eventData
	fsToNSList = DogTag.fsToNSList
	fsToKwargs = DogTag.fsToKwargs
	fsToCode = DogTag.fsToCode
	fsNeedQuickUpdate = DogTag.fsNeedQuickUpdate
end

local codesToClear = {}
local function _clearCodes()
	if not next(codesToClear) then
		return
	end
	for nsList, codeToFunction_nsList in pairs(codeToFunction) do
		for _, ns in ipairs(unpackNamespaceList[nsList]) do
			if codesToClear[ns] then
				for kwargTypes, d in pairs(codeToFunction_nsList) do
					if type(kwargTypes) ~= "number" then
						codeToFunction_nsList[kwargTypes] = del(d)
					end
				end
				codeToFunction[nsList] = del(codeToFunction_nsList)
				break
			end
		end
	end
	for nsList, codeToEventList_nsList in pairs(codeToEventList) do
		for _, ns in ipairs(unpackNamespaceList[nsList]) do
			if codesToClear[ns] then
				for kwargTypes, d in pairs(codeToEventList_nsList) do
					if type(kwargTypes) ~= "number" then
						codeToEventList_nsList[kwargTypes] = del(d)
					end
				end
				codeToEventList[nsList] = del(codeToEventList_nsList)
				break
			end
		end
	end
	for event, eventData_event in pairs(eventData) do
		eventData[event] = del(eventData_event)
	end
	
	for uid, nsList in pairs(callbackToNSList) do
		for _, ns in ipairs(unpackNamespaceList[nsList]) do
			if codesToClear[ns] then
				local kwargTypes = callbackToKwargTypes[uid]
				local code = callbackToCode[uid]
				local eventList = codeToEventList[nsList][kwargTypes][code]
				if eventList == nil then
					local _ = codeToFunction[nsList][kwargTypes][code]
					eventList = codeToEventList[nsList][kwargTypes][code]
					assert(eventList ~= nil)
				end
				break
			end
		end
	end
	
	for fs, nsList in pairs(fsToNSList) do
		local kwargs = fsToKwargs[fs]
		local code = fsToCode[fs]
		
		local kwargTypes = kwargsToKwargTypesWithTableCache[kwargs]
		
		local codeToEventList_nsList_kwargTypes_code = codeToEventList[nsList][kwargTypes][code]
		if codeToEventList_nsList_kwargTypes_code == nil then
			local _ = codeToFunction[nsList][kwargTypes][code]
			codeToEventList_nsList_kwargTypes_code = codeToEventList[nsList][kwargTypes][code]
			assert(codeToEventList_nsList_kwargTypes_code ~= nil)
		end
		if codeToEventList_nsList_kwargTypes_code then
			for event, arg in pairs(codeToEventList_nsList_kwargTypes_code) do
				eventData[event][fs] = arg
			end
		end
		fsNeedQuickUpdate[fs] = true
	end
	for k in pairs(codesToClear) do
		codesToClear[k] = nil
	end
end
DogTag._clearCodes = _clearCodes
local function clearCodes(namespace)
	codesToClear[namespace or ''] = true
end
DogTag.clearCodes = clearCodes

function DogTag.tagError(code, nsList, err)
	local _, minor = LibStub(MAJOR_VERSION)
	local message = ("%s.%d: Error with code %q (%s). %s"):format(MAJOR_VERSION, minor/1000000, code, nsList, err)
	geterrorhandler()(message)
	return message, code, nsList, err
end
end