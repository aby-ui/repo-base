local MAJOR_VERSION = "LibDogTag-3.0"
local MINOR_VERSION = 90000 + (tonumber(("20200115020223"):match("%d+")) or 33333333333333)

if MINOR_VERSION > _G.DogTag_MINOR_VERSION then
	_G.DogTag_MINOR_VERSION = MINOR_VERSION
end

local type, error, rawget, next, pairs, ipairs, setmetatable, loadstring, pcall, table, tonumber, tostring, math, assert, unpack =
	  type, error, rawget, next, pairs, ipairs, setmetatable, loadstring, pcall, table, tonumber, tostring, math, assert, unpack
-- #AUTODOC_NAMESPACE DogTag

DogTag_funcs[#DogTag_funcs+1] = function(DogTag)

local L = DogTag.L

local Tags = DogTag.Tags
local newList, newDict, newSet, del, deepCopy, deepDel = DogTag.newList, DogTag.newDict, DogTag.newSet, DogTag.del, DogTag.deepCopy, DogTag.deepDel

local fixNamespaceList = DogTag.fixNamespaceList
local select2 = DogTag.select2
local joinSet = DogTag.joinSet
local unpackNamespaceList = DogTag.unpackNamespaceList
local getASTType = DogTag.getASTType
local kwargsToKwargTypes = DogTag.kwargsToKwargTypes
local kwargsToKwargTypesWithTableCache = DogTag.kwargsToKwargTypesWithTableCache
local memoizeTable = DogTag.memoizeTable
local unparse, parse, standardize, codeToEventList, clearCodes
DogTag_funcs[#DogTag_funcs+1] = function()
	unparse = DogTag.unparse
	parse = DogTag.parse
	standardize = DogTag.standardize
	codeToEventList = DogTag.codeToEventList
	clearCodes = DogTag.clearCodes
end

local compilationSteps
do
	local mt = {__index = function(self, ns)
		self[ns] = newList()
		return self[ns]
	end}
	if DogTag.oldLib and DogTag.oldLib.compilationSteps then
		compilationSteps = DogTag.oldLib.compilationSteps
		setmetatable(compilationSteps.pre, mt)
		compilationSteps.pre.Base = {}
		setmetatable(compilationSteps.start, mt)
		compilationSteps.start.Base = {}
		setmetatable(compilationSteps.tag, mt)
		compilationSteps.tag.Base = {}
		setmetatable(compilationSteps.tagevents, mt)
		compilationSteps.tagevents.Base = {}
		setmetatable(compilationSteps.finish, mt)
		compilationSteps.finish.Base = {}
	else
		compilationSteps = {}
		compilationSteps.pre = setmetatable({ ['Base'] = {} }, mt)
		compilationSteps.start = setmetatable({ ['Base'] = {} }, mt)
		compilationSteps.tag = setmetatable({ ['Base'] = {} }, mt)
		compilationSteps.tagevents = setmetatable({ ['Base'] = {} }, mt)
		compilationSteps.finish = setmetatable({ ['Base'] = {} }, mt)
	end
end
DogTag.compilationSteps = compilationSteps

local correctTagCasing = setmetatable({}, {__index = function(self, tag)
	for ns, data in pairs(Tags) do
		if data[tag] then
			self[tag] = tag
			return tag
		end
	end
	
	local tag_lower = tag:lower()
	for ns, data in pairs(Tags) do
		for t in pairs(data) do
			if tag_lower == t:lower() then
				self[tag] = t
				return t
			end
		end
	end
	self[tag] = tag
	return tag
end})

local function correctASTCasing(ast)
	if type(ast) ~= "table" then
		return
	end
	local astType = ast[1]
	if astType == "tag" or astType == "mod" then
		ast[2] = correctTagCasing[ast[2]]
		if ast.kwarg then
			for k,v in pairs(ast.kwarg) do
				correctASTCasing(v)
			end
		end
	end
	for i = 1, #ast do
		correctASTCasing(ast[i])
	end
end
DogTag.correctASTCasing = correctASTCasing

local codeToFunction
do
	local codeToFunction_mt_mt = {__index = function(self, code)
		if not code then
			return self[""]
		end
		local nsList = self[1]
		local kwargTypes = self[2]
		
		local s, functions = DogTag:CreateFunctionFromCode(code, nsList, kwargTypes, true)
		local func, err = loadstring(s)
		local val
		if not func then
			local _, minor = LibStub(MAJOR_VERSION)
			geterrorhandler()(("%s.%d: Error (%s) loading code %q. Please inform ckknight."):format(MAJOR_VERSION, minor, err, code))
			val = self[""]
		else
			DogTag.__functions = functions
			local status, result = pcall(func)
			DogTag.__functions = nil
			if not status then
				local _, minor = LibStub(MAJOR_VERSION)
				geterrorhandler()(("%s.%d: Error (%s) loading code %q. Please inform ckknight."):format(MAJOR_VERSION, minor, result, code))
				val = self[""]
			else
				val = result
			end
		end
		if functions then
			functions = del(functions)
		end
		self[code] = val
		return val
	end}
	local codeToFunction_mt = {__index = function(self, kwargTypes)
		local t = setmetatable(newList(self[1], kwargTypes), codeToFunction_mt_mt)
		self[kwargTypes] = t
		return t
	end}
	codeToFunction = setmetatable({}, {__index = function(self, nsList)
		local t = setmetatable(newList(nsList), codeToFunction_mt)
		self[nsList] = t
		return t
	end})
end
DogTag.codeToFunction = codeToFunction

local operators = {
	["+"] = 'plus',
	["-"] = 'minus',
	["*"] = 'times',
	["/"] = 'divide',
	["%"] = 'modulus',
	["^"] = 'raise',
	["<"] = 'less',
	[">"] = 'greater',
	["<="] = 'lessequal',
	[">="] = 'greaterequal',
	["="] = 'equal',
	["~="] = 'inequal',
	["unm"] = 'unm',
}

local figureCachedTags
do
	function figureCachedTags(ast)
		local cachedTags = newList()
		if type(ast) ~= "table" then
			return cachedTags
		end
		local astType = ast[1]
		if astType == 'tag' or operators[astType] then
			local tagName = astType == 'tag' and ast[2] or astType
			if not cachedTags[tagName] then
				cachedTags[tagName] = 0
			end
			if not ast.kwarg then
				cachedTags[tagName] = cachedTags[tagName] + 1
			else
				for key, value in pairs(ast.kwarg) do
					local data = figureCachedTags(value)
					for k,v in pairs(data) do
						cachedTags[k] = (cachedTags[k] or 0) + v
					end
					data = del(data)
				end
			end
		end
		for i = 2, #ast do
			local data = figureCachedTags(ast[i])
			for k, v in pairs(data) do
				cachedTags[k] = (cachedTags[k] or 0) + v
			end
			data = del(data)
		end
		return cachedTags
	end
end

local function enumLines(text)
	text = text:gsub("\r\n", "\n"):gsub("\t", "    ")
	local lines = newList(("\n"):split(text))
	local t = newList()
	local indent = 0
	for i, v in ipairs(lines) do
		if v:match("end;?$") or v:match("else$") or v:match("^ *elseif") then
			indent = indent - 1
		end
		for j = 1, indent do
			t[#t+1] = "    "
		end
		t[#t+1] = v:gsub(";\s*$", "")
		t[#t+1] = " -- "
		t[#t+1] = i
		t[#t+1] = "\n"
		if v:match("then$") or v:match("do$") or v:match("else$") or v:match("function%(.-%)") then
			indent = indent + 1
		end
	end
	lines = del(lines)
	local s = table.concat(t)
	t = del(t)
	return s
end

local newUniqueVar, clearUniqueVars, getNumUniqueVars
do
	local num = 0
	local pool = {}
	function newUniqueVar()
		num = num + 1
		return 'arg' .. num
	end
	function clearUniqueVars()
		num = 0
	end
	function getNumUniqueVars()
		return num
	end
end


local function getTagData(tag, nsList)
	for _, ns in ipairs(unpackNamespaceList[nsList]) do
		local Tags_ns = Tags[ns]
		if Tags_ns then
			local Tags_ns_tag = Tags_ns[tag]
			if Tags_ns_tag then
				return Tags_ns_tag, ns
			end
		end
	end
end
DogTag.getTagData = getTagData

local function getKwargsForAST(ast, nsList, extraKwargs)
	local tag
	if ast[1] == "tag" then
		tag = ast[2]
	else
		tag = ast[1]
	end
	
	local tagData = getTagData(tag, nsList)
	
	local arg = tagData.arg
	if not arg then
		return newList() -- no issue, but no point
	end
	
	local kwargs = newList()
	if extraKwargs then
		-- extra kwargs specified on fontstring registration, e.g. { unit = "player" }
		for k,v in pairs(extraKwargs) do
			kwargs[k] = extraKwargs
		end
	end
	
	if ast.kwarg then
		for k,v in pairs(ast.kwarg) do
			kwargs[k] = v
		end
	end
	
	return kwargs
end

local function mytonumber(value)
	local type_value = type(value)
	if type_value == "number" then
		return value
	elseif type_value ~= "string" then
		return nil
	end
	if value:match("^0x") then
		return nil
	elseif value:match("%.$") or value:match("%.%d*0$") then
		return nil
	elseif value:match("^0%d+") then
		return nil
	elseif value:match("^%+") then
		return nil
	end
	return tonumber(value)
end
DogTag.__mytonumber = mytonumber

local allOperators = {
	["concat"] = true,
	["and"] = true,
	["or"] = true,
	["if"] = true,
	["not"] = true,
}
for k in pairs(operators) do
	allOperators[k] = true
end

local function numberToString(num)
	if type(num) ~= "number" then
		return tostring(num)
	elseif num == math.huge then
		return "NaN"
	elseif num == -math.huge then
		return "-NaN"
	elseif math.floor(num) == num then
		return tostring(num)
	else
		return ("%.22f"):format(num):gsub("0+$", "")
	end
end

local function forceTypes(storeKey, types, staticValue, forceToTypes, t)
	types = newSet((";"):split(types))
	forceToTypes = newSet((";"):split(forceToTypes))
	if forceToTypes["undef"] then
		forceToTypes["undef"] = nil
		forceToTypes["nil"] = true
	end
	
	if types["boolean"] and staticValue == nil then
		assert(type(storeKey) == "string" and (storeKey:match("^arg%d+$") or storeKey == "result"))
		if not types["string"] then
			if not types["number"] then
				t[#t+1] = storeKey
				t[#t+1] = [=[ = not not ]=]
				t[#t+1] = storeKey
				t[#t+1] = [=[;]=]
				t[#t+1] = "\n"
			else
				t[#t+1] = [=[if type(]=]
				t[#t+1] = storeKey
				t[#t+1] = [=[) ~= "number" then]=]
				t[#t+1] = "\n"
				t[#t+1] = storeKey
				t[#t+1] = [=[ = not not ]=]
				t[#t+1] = storeKey
				t[#t+1] = [=[;]=]
				t[#t+1] = "\n"
				t[#t+1] = "end;\n"
			end
		else
			t[#t+1] = [=[if ]=]
			t[#t+1] = storeKey
			t[#t+1] = [=[ == true then]=]
			t[#t+1] = "\n"
			t[#t+1] = storeKey
			t[#t+1] = [=[ = ]=]
			t[#t+1] = ([=[%q]=]):format(L["True"])
			t[#t+1] = [=[;]=]
			t[#t+1] = "\n"
			t[#t+1] = "end;\n"
			types["boolean"] = nil
			types["nil"] = true
		end
	end
	
	local unfulfilledTypes = newList()
	local finalTypes = newList()
	for k in pairs(types) do
		if not forceToTypes[k] then
			unfulfilledTypes[k] = true
		else
			finalTypes[k] = true
		end
	end
	types = del(types)
	if not next(unfulfilledTypes) then
		unfulfilledTypes = del(unfulfilledTypes)
		local types = joinSet(finalTypes, ';')
		finalTypes = del(finalTypes)
		forceToTypes = del(forceToTypes)
		if type(storeKey) ~= "string" or (not storeKey:match("^arg%d+$") and storeKey ~= "result" and not storeKey:match("^%(.*%)$")) then
			storeKey = "(" .. storeKey .. ")"
		end
		return storeKey, types, staticValue
	end
	if unfulfilledTypes['nil'] then
		-- we have a possible unrequested nil
		if forceToTypes['boolean'] then
			if type(storeKey) == "string" and storeKey:match("^arg%d+$") then
				t[#t+1] = storeKey
				t[#t+1] = [=[ = ]=]
				if unfulfilledTypes['number'] or unfulfilledTypes['string'] then
					-- and a possible unrequested number or string
					t[#t+1] = [=[not not ]=]
					t[#t+1] = storeKey
					t[#t+1] = [=[;]=]
					t[#t+1] = "\n"
					staticValue = nil
				else
					t[#t+1] = [=[false;]=]
					t[#t+1] = "\n"
					staticValue = false
				end
			else
				assert(storeKey == "nil" or storeKey == "(nil)")
				storeKey = "false"
				staticValue = false
			end
			finalTypes['boolean'] = true
		elseif forceToTypes['string'] then
			if type(storeKey) == "string" and storeKey:match("^arg%d+$") then
				t[#t+1] = storeKey
				t[#t+1] = [=[ = ]=]
				if unfulfilledTypes['number'] then
					-- and a possible unrequested number
					t[#t+1] = [=[tostring(]=]
					t[#t+1] = storeKey
					t[#t+1] = [=[ or '');]=]
					t[#t+1] = "\n"
					staticValue = nil
				elseif forceToTypes['number'] then	
					t[#t+1] = storeKey
					t[#t+1] = [=[ or '';]=]
					t[#t+1] = "\n"
					finalTypes['number'] = true
					staticValue = nil
				else
					t[#t+1] = [=['';]=]
					t[#t+1] = "\n"
					staticValue = ''
				end
			else
				if storeKey == "nil" then
					storeKey = "''"
					staticValue = ''
				else
					storeKey = tostring(storeKey or "''")
					staticValue = nil
				end
			end
			finalTypes['string'] = true
		elseif forceToTypes['number'] then
			if type(storeKey) == "string" and storeKey:match("^arg%d+$") then
				if unfulfilledTypes["string"] then
					t[#t+1] = storeKey
					t[#t+1] = [=[ = tonumber(]=]
					t[#t+1] = storeKey
					t[#t+1] = [=[) or 0;]=]
					t[#t+1] = "\n"
				else
					t[#t+1] = [=[if not ]=]
					t[#t+1] = storeKey
					t[#t+1] = [=[ then]=]
					t[#t+1] = "\n"
					t[#t+1] = storeKey
					t[#t+1] = [=[ = ]=]
					t[#t+1] = [=[0;]=]
					t[#t+1] = "\n"
					t[#t+1] = "end;\n"
				end
				staticValue = nil
			else
				if storeKey == "nil" then
					storeKey = "0"
					staticValue = 0
				else	
					staticValue = tonumber(storeKey) or 0
					storeKey = numberToString(staticValue)
				end
			end	
			finalTypes['number'] = true
		end
	elseif unfulfilledTypes['number'] then
		-- we have a possible unrequested number
		if forceToTypes['boolean'] then
			if type(storeKey) == "string" and storeKey:match("^arg%d+$") then
				t[#t+1] = storeKey
				t[#t+1] = [=[ = true;]=]
				t[#t+1] = "\n"
			else
				storeKey = "true"
			end
			finalTypes['boolean'] = true
			staticValue = true
		elseif forceToTypes['string'] then
			if type(storeKey) == "string" and storeKey:match("^arg%d+$") then
				if forceToTypes['nil'] then
					t[#t+1] = [=[if ]=]
					t[#t+1] = storeKey
					t[#t+1] = [=[ then]=]
					t[#t+1] = "\n"
				end
				t[#t+1] = storeKey
				t[#t+1] = [=[ = tostring(]=]
				t[#t+1] = storeKey
				t[#t+1] = [=[);]=]
				t[#t+1] = "\n"
				if forceToTypes['nil'] then
					t[#t+1] = "end;\n"
				end
				staticValue = nil
			else
				if not forceToTypes['nil'] and storeKey ~= 'nil' and storeKey ~= '(nil)' then
					if storeKey:match("^%(.*%)$") then
						storeKey = storeKey:sub(2, -2)+0
					else
						storeKey = storeKey+0
					end
					staticValue = tostring(storeKey)
					storeKey = ("%q"):format(tostring(storeKey))
				end
			end
			finalTypes['string'] = true
		elseif forceToTypes['nil'] then
			if type(storeKey) == "string" and storeKey:match("^arg%d+$") then
				t[#t+1] = storeKey
				t[#t+1] = [=[ = nil;]=]
				t[#t+1] = "\n"
			else
				storeKey = "nil"
			end
			staticValue = "@nil"
			finalTypes['nil'] = true
		end
	elseif unfulfilledTypes['string'] then
		-- we have a possible unrequested string
		if forceToTypes['boolean'] then
			if type(storeKey) == "string" and storeKey:match("^arg%d+$") then
				t[#t+1] = storeKey
				t[#t+1] = [=[ = true;]=]
				t[#t+1] = "\n"
			else
				storeKey = "true"
			end
			staticValue = true
			finalTypes['boolean'] = true
		elseif forceToTypes['number'] then
			if type(storeKey) == "string" and storeKey:match("^arg%d+$") then
				t[#t+1] = storeKey
				t[#t+1] = [=[ = tonumber(]=]
				t[#t+1] = storeKey
				t[#t+1] = [=[)]=]
				if not forceToTypes['nil'] then
					t[#t+1] = [=[ or 0]=]
				else
					finalTypes['nil'] = true
				end
				t[#t+1] = [=[;]=]
				t[#t+1] = "\n"
				staticValue = nil
			else
				staticValue = tonumber(staticValue)
				if not forceToTypes['nil'] and not staticValue then
					staticValue = 0
				end
				storeKey = numberToString(staticValue)
			end
			finalTypes['number'] = true
		elseif forceToTypes['nil'] then
			if type(storeKey) == "string" and storeKey:match("^arg%d+$") then
				t[#t+1] = storeKey
				t[#t+1] = [=[ = nil;]=]
				t[#t+1] = "\n"
			else
				storeKey = "nil"
			end
			finalTypes['nil'] = true
			staticValue = "@nil"
		end
	elseif unfulfilledTypes["boolean"] then
		if forceToTypes["string"] then
			if staticValue == nil then
				t[#t+1] = [=[if ]=]
				t[#t+1] = storeKey
				t[#t+1] = [=[ then]=]
				t[#t+1] = "\n"
				t[#t+1] = storeKey
				t[#t+1] = [=[ = ]=]
				t[#t+1] = ([=[%q]=]):format(L["True"])
				t[#t+1] = [=[;]=]
				t[#t+1] = "\n"
				t[#t+1] = [=[else]=]
				t[#t+1] = "\n"
				t[#t+1] = storeKey
				t[#t+1] = [=[ = ]=]
				if forceToTypes["nil"] then
					t[#t+1] = [=[nil]=]
					finalTypes['nil'] = true
				else
					t[#t+1] = [=['']=]
				end
				t[#t+1] = [=[;]=]
				t[#t+1] = "\n"
				t[#t+1] = "end;\n"
				finalTypes['string'] = true
			else
				if staticValue then
					staticValue = L["True"]
					storeKey = ("%q"):format(staticValue)
					finalTypes['string'] = true
				else
					if forceToTypes['nil'] then
						staticValue = "@nil"
						storeKey = 'nil'
						finalTypes['nil'] = true
					else
						staticValue = ""
						storeKey = "''"
						finalTypes['string'] = true
					end
				end
			end
		elseif forceToTypes["number"] then
			if staticValue == nil then
				t[#t+1] = [=[if ]=]
				t[#t+1] = storeKey
				t[#t+1] = [=[ then]=]
				t[#t+1] = "\n"
				t[#t+1] = storeKey
				t[#t+1] = [=[ = 1;]=]
				t[#t+1] = "\n"
				t[#t+1] = [=[else]=]
				t[#t+1] = "\n"
				t[#t+1] = storeKey
				t[#t+1] = [=[ = ]=]
				if forceToTypes["nil"] then
					t[#t+1] = [=[nil]=]
					finalTypes['nil'] = true
				else
					t[#t+1] = [=[0]=]
				end
				t[#t+1] = [=[;]=]
				t[#t+1] = "\n"
				t[#t+1] = "end;\n"
				finalTypes['number'] = true
			else
				if staticValue then
					staticValue = 1
					storeKey = "1"
					finalTypes['number'] = true
				else
					if forceToTypes['nil'] then
						staticValue = "@nil"
						storeKey = 'nil'
						finalTypes['nil'] = true
					else
						staticValue = ""
						storeKey = "0"
						finalTypes['number'] = true
					end
				end
			end
		elseif forceToTypes["nil"] then
			t[#t+1] = storeKey
			t[#t+1] = [=[ = nil;]=]
			t[#t+1] = "\n"
			finalTypes['nil'] = true
			staticValue = "@nil"
		end
	end
	unfulfilledTypes = del(unfulfilledTypes)
	forceToTypes = del(forceToTypes)
	local types = joinSet(finalTypes, ';')
	finalTypes = del(finalTypes)
	if type(storeKey) ~= "string" or (not storeKey:match("^arg%d+$") and storeKey ~= "result" and not storeKey:match("^%(.*%)$")) then
		storeKey = "(" .. storeKey .. ")"
	end
	return storeKey, types, staticValue
end

local function compile(ast, nsList, t, cachedTags, events, functions, extraKwargs, forceToTypes, storeKey, saveFirstArg)
	if #t ~= 0 then
		error(("Assertion failed: %s == %s"):format(#t, 0))
	end
	local astType = getASTType(ast)
	if astType == 'nil' or ast == "@undef" then
		if storeKey then
			t[#t+1] = storeKey
			t[#t+1] = [=[ = nil;]=]
			t[#t+1] = "\n"
			return forceTypes(storeKey, "nil", "@nil", forceToTypes, t)
		else
			return forceTypes("nil", "nil", "@nil", forceToTypes, t)
		end
	elseif astType == 'kwarg' then
		local kwarg = extraKwargs[ast[2]]
		local arg, types = kwarg[1], kwarg[2]
		if storeKey then
			t[#t+1] = storeKey
			t[#t+1] = [=[ = ]=]
			t[#t+1] = arg
			t[#t+1] = [=[;]=]
			t[#t+1] = "\n"
			return forceTypes(storeKey, types, nil, forceToTypes, t)
		else
			return forceTypes(arg, types, nil, forceToTypes, t)
		end
	elseif astType == 'string' then
		if ast == '' then
			return compile(nil, nsList, t, cachedTags, events, functions, extraKwargs, forceToTypes, storeKey)
		else
			if storeKey then
				t[#t+1] = storeKey
				t[#t+1] = [=[ = ]=]
				t[#t+1] = ([=[%q]=]):format(ast)
				t[#t+1] = [=[;]=]
				t[#t+1] = "\n"
				return forceTypes(storeKey, "string", ast, forceToTypes, t)
			else
				return forceTypes(([=[%q]=]):format(ast), "string", ast, forceToTypes, t)
			end
		end
	elseif astType == 'number' then
		if storeKey then
			t[#t+1] = storeKey
			t[#t+1] = [=[ = ]=]
			t[#t+1] = numberToString(ast)
			t[#t+1] = [=[;]=]
			t[#t+1] = "\n"
			return forceTypes(storeKey, "number", ast, forceToTypes, t)
		else
			return forceTypes(numberToString(ast), "number", ast, forceToTypes, t)
		end
	elseif astType == 'tag' or operators[astType] then
		local tag = ast[astType == 'tag' and 2 or 1]
		local tagData, tagNS = getTagData(tag, nsList)
		if not storeKey then
			storeKey = newUniqueVar()
		end
		local caching, cachingFirst
		if astType == 'tag' and not ast.kwarg and cachedTags[tag] then
			caching = true
			cachingFirst = cachedTags[tag] == 1
			cachedTags[tag] = 2
		end
		local static_t_num = #t
		if caching and not cachingFirst then
			t[#t+1] = [=[if cache_]=]
			t[#t+1] = tag
			t[#t+1] = [=[ ~= NIL then]=]
			t[#t+1] = "\n"
			t[#t+1] = storeKey
			t[#t+1] = [=[ = cache_]=]
			t[#t+1] = tag
			t[#t+1] = [=[;]=]
			t[#t+1] = "\n"
			t[#t+1] = [=[else]=]
			t[#t+1] = "\n"
		else
			t[#t+1] = [=[do]=]
			t[#t+1] = "\n"
		end
		local kwargs = getKwargsForAST(ast, nsList, extraKwargs)
		
		local arg = tagData.arg
		
		local allArgsStatic = true
		local compiledKwargs = newList()
		local firstAndNonNil
		local firstMaybeNumber = false
		for k,v in pairs(kwargs) do
			if v == extraKwargs then
				compiledKwargs[k] = newList(unpack(extraKwargs[k]))
				allArgsStatic = false
			else
				local argTypes = "nil;number;string;boolean"
				local arg_num
				local arg_default = false
				if not k:match("^%.%.%.%d+$") then
					for i = 1, #arg, 3 do
						if arg[i] == k then
							argTypes = arg[i+1]
							arg_num = (i-1)/3 + 1
							arg_default = arg[i+2]
							break
						end
					end
				else
					for i = 1, #arg, 3 do
						if arg[i] == "..." then
							arg_num = (i-1)/3 + 1
							if arg[i+1]:match("^tuple%-") then
								argTypes = arg[i+1]:sub(7)
							else
								break
							end
						end
					end
				end
				if arg_num == 1 and (arg_default == "@req" or arg_default == "@undef") then
					local a = newSet((";"):split(argTypes))
					firstAndNonNil = not a["nil"] and not a["boolean"] and k
					if firstAndNonNil then
						a["undef"] = nil
						a["nil"] = true
						argTypes = joinSet(a, ";")
					end
					a = del(a)
				end	
				local u = newList()
				local arg, types, static
				if arg_num == 1 then
					local rawTypes
					arg, rawTypes, static = compile(v, nsList, u, cachedTags, events, functions, extraKwargs, "boolean;nil;number;string")
					arg, types, static = forceTypes(arg, rawTypes, static, argTypes, u)
					local a = newSet((";"):split(rawTypes))
					firstMaybeNumber = a['number'] and rawTypes
					a = del(a)
				else
					arg, types, static = compile(v, nsList, u, cachedTags, events, functions, extraKwargs, argTypes)
				end	
				for i,v in ipairs(u) do
					t[#t+1] = v
				end
				u = del(u)
				if static == nil then
					allArgsStatic = false
				end
				if firstAndNonNil == k then
					local returns = newSet((";"):split(types))
					if v == "@undef" then
						firstAndNonNil = nil
					--	firstAndNonNil_t_num = nil	-- unused
					elseif not returns["nil"] then
						firstAndNonNil = nil
					--	firstAndNonNil_t_num = nil	-- unused
					elseif returns["string"] or returns["number"] then
					--	firstAndNonNil_t_num = nil	-- unused
					end
					returns = del(returns)
				end
				compiledKwargs[k] = newList(arg, types, static)
			end
		end
		if firstAndNonNil then
			local compiledKwargs_firstAndNonNil = compiledKwargs[firstAndNonNil]
			t[#t+1] = [=[if ]=]
			t[#t+1] = compiledKwargs_firstAndNonNil[1]
			t[#t+1] = [=[ then]=]
			t[#t+1] = "\n"
			local args = newSet((';'):split(compiledKwargs_firstAndNonNil[2]))
			args['nil'] = nil
			compiledKwargs_firstAndNonNil[2] = joinSet(args, ';')
			args = del(args)
		end
		
		local step_t_num = #t
		for step in pairs(compilationSteps.tag[tagNS]) do
			step(ast, t, tag, tagData, kwargs, extraKwargs, compiledKwargs)
		end
		if step_t_num ~= #t then
			allArgsStatic = false
		end
		
		local passData = newList() -- data that will be passed into functions like ret, code, etc.
		for k, v in pairs(kwargs) do
			local passData_k = newList()
			passData[k] = passData_k
			if type(v) ~= "table" or v[1] == "nil" then
				local value = type(v) ~= "table" and v or nil
				passData_k.isLiteral = true
				passData_k.value = value
				passData_k.types = type(value)
			else
				passData_k.isLiteral = false
				passData_k.value = v
				passData_k.types = compiledKwargs[k][2]
			end
		end
		
		local code = tagData.code
		local ret = tagData.ret
		local evs = tagData.events
		local static = tagData.static
		
		if type(ret) == "function" then
			ret = ret(passData)
		end
		local funcName
		if tagData.dynamicCode then
			code = code(passData)
			for k, v in pairs(functions) do
				if v == code then
					funcName = k
				end
			end
			if not funcName then
				local pre = (operators[tag] or tag) .. "_"
				local num = 1
				while functions[pre .. num] do
					num = num + 1
				end
				funcName = pre .. num
				functions[funcName] = code
			end
		else
			functions[operators[tag] or tag] = tag
		end
		if type(evs) == "function" then
			evs = evs(passData)
		end
		if type(static) == "function" then
			static = static(passData)
		end
		for k, v in pairs(passData) do
			passData[k] = del(v)
		end
		passData = del(passData)
		
		evs = evs and newSet((";"):split(evs)) or newSet()
		ret = ret and newSet((";"):split(ret)) or newSet("nil")
		local u = newList()
		for step in pairs(compilationSteps.tagevents[tagNS]) do
			u[#u+1] = newList()
			step(ast, t, u[#u], tag, tagData, kwargs, extraKwargs, compiledKwargs, evs, ret)
			if not next(u[#u]) then
				u[#u] = del(u[#u])
			end
		end
		local r = joinSet(ret, ";")
		ret = del(ret)
		ret = r
		local afterAdditions = newList()
		for i = #u, 1, -1 do
			for _, v in ipairs(u[i]) do
				afterAdditions[#afterAdditions+1] = v
			end
			u[i] = del(u[i])
		end
		u = del(u)
		
		for k in pairs(evs) do
			local ev_params = newList(("#"):split(k))
			local ev = ev_params[1]
			local events_ev = events[ev]
			if events_ev ~= true then
				if #ev_params >= 2 then
					for i = 2, #ev_params do
						local param = ev_params[i]
						if param:match("^%$") then
							local real_param = param:sub(2)
							local compiledKwargs_real_param = compiledKwargs[real_param]
							if not compiledKwargs_real_param then
								error(("Unknown event parameter %q for tag %s. Please inform ckknight."):format(real_param, tag))
							end
							local compiledKwargs_real_param_1 = compiledKwargs_real_param[1]
							if not compiledKwargs_real_param_1:match("^kwargs_[a-z]+$") then
								local kwargs_real_param = kwargs[real_param]
								if type(kwargs_real_param) == "table" then
									if kwargs_real_param[1] == "kwarg" then
										param = "$" .. kwargs_real_param[2]
									else
										param = unparse(kwargs_real_param)
									end
								else
									param = kwargs_real_param or true
								end
								ev_params[i] = param
							end
						end
					end
					local paramResult
					if #ev_params == 2 then
						paramResult = ev_params[2]
					else
						paramResult = table.concat(ev_params, '#', 2, #ev_params)
					end
					if type(events_ev) == "table" then
						if paramResult == true then
							del(events_ev)
							events[ev] = true
						else
							events_ev[paramResult] = true
						end
					elseif events_ev and events_ev ~= paramResult then
						if paramResult == true then
							events[ev] = true
						else
							events[ev] = newSet(events_ev, paramResult)
						end
					else
						events[ev] = paramResult
					end
				else
					if type(events_ev) == "table" then
						del(events_ev)
					end
					events[ev] = true
				end
			end
			ev_params = del(ev_params)
		end
		evs = del(evs)
		
		
		local savedArg, savedArgTypes, savedArgStatic
		for k,v in pairs(compiledKwargs) do
			if saveFirstArg and k == arg[1] then
				savedArg = v[1]
				savedArgTypes = v[2]
				savedArgStatic = v[3]
			end
		end
		
		if tagData.static and allArgsStatic then
			local args = newList()
			local argNum = 0
			if tagData.arg then
				local hasTuple = false
				for i = 1, #tagData.arg, 3 do
					local argName = tagData.arg[i]
					if argName == "..." then
						hasTuple = true
					else
						argNum = argNum + 1
						local stat = compiledKwargs[argName][3]
						if stat == "@nil" then
							stat = nil
						end
						args[argNum] = stat
					end
				end
				if hasTuple then
					local j = 0
					while true do
						j = j + 1
						local kwarg = compiledKwargs["..." .. j]
						if not kwarg then
							break
						end
						argNum = argNum + 1
						local stat = kwarg[3]
						if stat == "@nil" then
							stat = nil
						end
						args[argNum] = stat
					end
				end
			end
			
			local result
			if firstAndNonNil and not args[1] then
				result = nil
			else
				result = code(unpack(args, 1, argNum))
			end
			args = del(args)
			if firstMaybeNumber then
				if mytonumber(result) then
					result = result+0
				end
			end
			local key
			local type_result = type(result)
			if type_result == "string" then
				key = ("(%q)"):format(result)
			else
				key = ("(%s)"):format(numberToString(result))
			end
			for i = static_t_num+1, #t do
				t[i] = nil
			end
			
			for k,v in pairs(compiledKwargs) do
				compiledKwargs[k] = del(v)
			end
			compiledKwargs = del(compiledKwargs)
			kwargs = del(kwargs)
			
			local type_result = type(result)
			if result == nil then
				result = "@nil"
			end
			local a, b, c = forceTypes(key, type_result, result, forceToTypes, t)
			return a, b, c, savedArg, savedArgTypes, savedArgStatic
		end
		
		t[#t+1] = storeKey
		t[#t+1] = " = tag_"
		if funcName then
			t[#t+1] = funcName
		else
			if operators[tag] then
				t[#t+1] = operators[tag]
			else
				t[#t+1] = tag
			end
		end
		t[#t+1] = "("
		if tagData.arg then
			local hasTuple = false
			local first = true
			for i = 1, #tagData.arg, 3 do
				local argName = tagData.arg[i]
				if argName == "..." then
					hasTuple = true
				else
					if not first then
						t[#t+1] = ", "
					else
						first = false
					end
					t[#t+1] = compiledKwargs[argName][1]
				end
			end
			if hasTuple then
				local j = 0
				while true do
					j = j + 1
					local kwarg = compiledKwargs["..." .. j]
					if not kwarg then
						break
					end
					if not first then
						t[#t+1] = ", "
					else
						first = false
					end
					t[#t+1] = kwarg[1]
				end
			end
		end	
		t[#t+1] = [=[);]=]
		t[#t+1] = "\n"
		
		for i,v in ipairs(afterAdditions) do
			t[#t+1] = v
		end
		afterAdditions = del(afterAdditions)
		
		for k,v in pairs(compiledKwargs) do
			compiledKwargs[k] = del(v)
		end
		compiledKwargs = del(compiledKwargs)
		
		if firstAndNonNil then
			t[#t+1] = "end;\n"
			local returns = newSet((";"):split(ret))
			returns["nil"] = true
			ret = joinSet(returns, ";")
			returns = del(returns)
		end
		
		if caching then
			t[#t+1] = [=[cache_]=]
			t[#t+1] = tag
			t[#t+1] = [=[ = ]=]
			t[#t+1] = storeKey
			t[#t+1] = [=[;]=]
			t[#t+1] = "\n"
		end
		t[#t+1] = "end;\n"
		
		kwargs = del(kwargs)
		if firstMaybeNumber then
			local types = newSet((";"):split(forceToTypes))
			if types['number'] then
				local retData = newSet((";"):split(ret))
				if retData['string'] and not retData['number'] then
					t[#t+1] = [=[if mytonumber(]=]
					t[#t+1] = storeKey
					t[#t+1] = [=[) then]=]
					t[#t+1] = "\n"
					t[#t+1] = storeKey
					t[#t+1] = [=[ = ]=]
					t[#t+1] = storeKey
					t[#t+1] = [=[+0;]=]
					t[#t+1] = "\n"
					t[#t+1] = "end;\n"
					retData['number'] = true
					ret = joinSet(retData, ';')
				end
				retData = del(retData)
			end
			types = del(types)
		end
		local a, b, c = forceTypes(storeKey, ret, nil, forceToTypes, t)
		return a, b, c, savedArg, savedArgTypes, savedArgStatic
	elseif astType == "concat" then
		local t_num = #t
		local args = newList()
		local argTypes = newList()
		for i = 2, #ast do
			local u = newList()
			local arg, err = compile(ast[i], nsList, u, cachedTags, events, functions, extraKwargs, "nil;number;string")
			if #u > 0 then
				t[#t+1] = "do\n"
				for i,v in ipairs(u) do
					t[#t+1] = v
				end
				t[#t+1] = "end;\n"
			end
			u = del(u)
			args[#args+1] = arg
			argTypes[#argTypes+1] = err
		end
		if not storeKey then
			storeKey = newUniqueVar()
		end
		t[#t+1] = storeKey
		t[#t+1] = [=[ = ]=]
		local finalTypes = newList()
		local lastCouldBeNil = false
		for i,v in ipairs(args) do
			if i > 1 then
				t[#t+1] = [=[ .. ]=]
			end
			local types = argTypes[i]
			types = newSet((';'):split(types))
			if types['nil'] and (types['string'] or types['number']) then
				t[#t+1] = "("
				t[#t+1] = v
				t[#t+1] = " or '')"
				lastCouldBeNil = v
			elseif types['nil'] then
				-- just nil
				t[#t+1] = "''"
				lastCouldBeNil = true
			else
				-- non-nil
				if lastCouldBeNil and v:match("^%(\"%s") then
					t[#t+1] = "("
					if lastCouldBeNil ~= true then
						t[#t+1] = '(('
						t[#t+1] = lastCouldBeNil
						t[#t+1] = " or '') == ''"
						t[#t+1] = ') and '
					end
					t[#t+1] = v:gsub("^%(\"%s", "(\"")
					if lastCouldBeNil ~= true then
						t[#t+1] = ' or '
						t[#t+1] = v
					end
					t[#t+1] = ")"
				else
					t[#t+1] = v
				end
				lastCouldBeNil = nil
			end
			if types['nil'] then
				if not next(finalTypes) then
					finalTypes['nil'] = true
				end
			else
				finalTypes['nil'] = nil
			end
			if types['number'] and not finalTypes['string'] then
				if finalTypes['number'] then
					finalTypes['string'] = true
				end
				finalTypes['number'] = true
			end
			if types['string'] then
				if not types['number'] then
					finalTypes['number'] = nil
				end
				finalTypes['string'] = true
			end
			types = del(types)
		end
		t[#t+1] = [=[;]=]
		t[#t+1] = "\n"
		if lastCouldBeNil then
			t[#t+1] = storeKey
			t[#t+1] = [=[ = (]=]
			t[#t+1] = storeKey
			t[#t+1] = [=[):gsub("%s$", "");]=]
			t[#t+1] = "\n"
		end
		if finalTypes['number'] then
			t[#t+1] = [=[if mytonumber(]=]
			t[#t+1] = storeKey
			t[#t+1] = [=[) then]=]
			t[#t+1] = "\n"
			t[#t+1] = storeKey
			t[#t+1] = [=[ = ]=]
			t[#t+1] = storeKey
			t[#t+1] = [=[+0;]=]
			t[#t+1] = "\n"
		end
		if finalTypes['nil'] then
			if finalTypes['number'] then
				t[#t+1] = [=[elseif ]=]
			else
				t[#t+1] = [=[if ]=]
			end
			t[#t+1] = storeKey
			t[#t+1] = [=[ == '' then]=]
			t[#t+1] = "\n"
			t[#t+1] = storeKey
			t[#t+1] = [=[ = nil;]=]
			t[#t+1] = "\n"
			t[#t+1] = "end;\n"
		else
			if finalTypes['number'] then
				t[#t+1] = "end;\n"
			end
		end
		args = del(args)
		argTypes = del(argTypes)
		local s = joinSet(finalTypes, ';')
		finalTypes = del(finalTypes)
		return forceTypes(storeKey, s, nil, forceToTypes, t) -- TODO: maybe static
	elseif astType == 'and' or astType == 'or' then
		if not storeKey then
			storeKey = newUniqueVar()
		end
		local t_num = #t
		local u = newList()
		local arg, firstResults, staticValue = compile(ast[2], nsList, u, cachedTags, events, functions, extraKwargs, astType == 'and' and "boolean;nil;number;string" or "nil;number;string", storeKey)
		firstResults = newSet((";"):split(firstResults))
		local totalResults = newList()
		if #u > 0 then
			t[#t+1] = "do\n"
			for i, v in ipairs(u) do
				t[#t+1] = v
			end
			t[#t+1] = "end;\n"
		end
		u = del(u)
		if firstResults["nil"] and not firstResults['boolean'] and not firstResults['string'] and not firstResults['number'] then
			for i = t_num, #t do
				t[i] = nil
			end
			if astType == 'or' then
				local arg, secondResults
				local u = newList()
				arg, secondResults, staticValue = compile(ast[3], nsList, u, cachedTags, events, functions, extraKwargs, "nil;number;string", storeKey)
				for i, v in ipairs(u) do
					t[#t+1] = v
				end
				u = del(u)
				secondResults = newSet((";"):split(secondResults))
				for k in pairs(totalResults) do
					totalResults[k] = nil
				end
				for k in pairs(secondResults) do
					totalResults[k] = true
				end
				secondResults = del(secondResults)
			else
				staticValue = "@nil"
			end
		elseif firstResults["nil"] or firstResults['boolean'] then
			t[#t+1] = [=[if ]=]
			if astType == 'or' then
				t[#t+1] = [=[not ]=]
			end
			t[#t+1] = storeKey
			t[#t+1] = [=[ then]=]
			t[#t+1] = "\n"
			if astType == 'and' then
				t[#t+1] = storeKey
				t[#t+1] = [=[ = nil;]=]
				t[#t+1] = "\n"
			end
			local u = newList()
			local arg, secondResults, static = compile(ast[3], nsList, u, cachedTags, events, functions, extraKwargs, "nil;number;string", storeKey)
			for i, v in ipairs(u) do
				t[#t+1] = v
			end
			u = del(u)
			secondResults = newSet((";"):split(secondResults))
			if static then
				t[#t+1] = storeKey
				t[#t+1] = [=[ = ]=]
				t[#t+1] = arg
				t[#t+1] = [=[;]=]
				t[#t+1] = "\n"
			end
			t[#t+1] = "end;\n"
			if astType == 'and' then
				for k in pairs(firstResults) do
					if k == "nil" or k == "boolean" then
						totalResults[k] = true
					end
				end
			else
				for k in pairs(firstResults) do
					if k ~= "nil" and k ~= "boolean" then
						totalResults[k] = true
					end
				end
			end
			for k in pairs(secondResults) do
				totalResults[k] = true
			end
			secondResults = del(secondResults)
			staticValue = nil
		else
			if astType == 'and' then
				for i = t_num, #t do
					t[i] = nil
				end
				local arg, secondResults
				arg, secondResults, staticValue = compile(ast[3], nsList, t, cachedTags, events, functions, extraKwargs, "nil;number;string", storeKey)
				secondResults = newSet((";"):split(secondResults))
				for k in pairs(totalResults) do
					totalResults[k] = nil
				end
				for k in pairs(secondResults) do
					totalResults[k] = true
				end
				secondResults = del(secondResults)
			else
				for k in pairs(firstResults) do
					totalResults[k] = true
				end
			end
		end
		firstResults = del(firstResults)
		local s = joinSet(totalResults, ';')
		totalResults = del(totalResults)
		return forceTypes(storeKey, s, staticValue, forceToTypes, t)
	elseif astType == 'if' then
		if not storeKey then
			storeKey = newUniqueVar()
		end
		local hasElse = not not ast[4]
		local t_num = #t
		local u = newList()
		local storeKey, condResults, staticValue = compile(ast[2], nsList, u, cachedTags, events, functions, extraKwargs, "boolean;nil;number;string", storeKey)
		condResults = newSet((';'):split(condResults))
		if #u > 0 then
			t[#t+1] = "do\n"
			for i, v in ipairs(u) do
				t[#t+1] = v
			end
			t[#t+1] = "end;\n"
		end
		u = del(u)
		if condResults["boolean"] or (condResults["nil"] and (condResults["string"] or condResults["number"])) then
			condResults = del(condResults)
			t[#t+1] = [=[if ]=]
			t[#t+1] = storeKey
			t[#t+1] = [=[ then]=]
			t[#t+1] = "\n"
			t[#t+1] = storeKey
			t[#t+1] = [=[ = nil;]=]
			t[#t+1] = "\n"
			local u = newList(u)
			local arg, firstResults, static = compile(ast[3], nsList, u, cachedTags, events, functions, extraKwargs, forceToTypes, storeKey)
			for i, v in ipairs(u) do
				t[#t+1] = v
			end
			u = del(u)
			if static then
				t[#t+1] = storeKey
				t[#t+1] = [=[ = ]=]
				t[#t+1] = arg
				t[#t+1] = [=[;]=]
				t[#t+1] = "\n"
			end
			local totalResults = newSet((";"):split(firstResults))
			t[#t+1] = [=[else]=]
			t[#t+1] = "\n"
			local secondResults
			if hasElse then
				local u = newList()
				storeKey, secondResults, static = compile(ast[4], nsList, u, cachedTags, events, functions, extraKwargs, forceToTypes, storeKey)
				for i, v in ipairs(u) do
					t[#t+1] = v
				end
				u = del(u)
				if static then
					t[#t+1] = storeKey
					t[#t+1] = [=[ = ]=]
					t[#t+1] = arg
					t[#t+1] = [=[;]=]
					t[#t+1] = "\n"
				end
			else
				t[#t+1] = storeKey
				t[#t+1] = [=[ = nil;]=]
				t[#t+1] = "\n"
				storeKey, secondResults = forceTypes(storeKey, "nil", "@nil", forceToTypes, t)
			end
			secondResults = newSet((";"):split(secondResults))
			for k in pairs(secondResults) do
				totalResults[k] = true
			end
			secondResults = del(secondResults)
			t[#t+1] = "end;\n"
			
			local s = joinSet(totalResults, ';')
			totalResults = del(totalResults)
			return forceTypes(storeKey, s, nil, forceToTypes, t)
		elseif condResults["nil"] then
			-- just nil
			condResults = del(condResults)
			for i = t_num, #t do
				t[i] = nil
			end
			return compile(ast[4], nsList, t, cachedTags, events, functions, extraKwargs, forceToTypes, storeKey)
		else
			-- non-nil
			condResults = del(condResults)
			for i = t_num, #t do
				t[i] = nil
			end
			return compile(ast[3], nsList, t, cachedTags, events, functions, extraKwargs, forceToTypes, storeKey)
		end
	elseif astType == 'not' then
		local t_num = #t
		local s, results, staticValue, savedArg, savedArgTypes, savedArgStatic = compile(ast[2], nsList, t, cachedTags, events, functions, extraKwargs, "boolean;nil;number;string", storeKey, true)
		
		results = newSet((";"):split(results))
		if results["boolean"] or (results["nil"] and (results["string"] or results["number"])) then
			results = del(results)
			storeKey = s
			
			local types = newList()
			
			if savedArg then
				types["nil"] = true
				t[#t+1] = [=[if ]=]
				t[#t+1] = storeKey
				t[#t+1] = [=[ then]=]
				t[#t+1] = "\n"
				t[#t+1] = storeKey
				t[#t+1] = [=[ = nil;]=]
				t[#t+1] = "\n"
				t[#t+1] = [=[else]=]
				t[#t+1] = "\n"
				t[#t+1] = storeKey
				t[#t+1] = [=[ = ]=]
				t[#t+1] = savedArg
				savedArgTypes = newSet((";"):split(savedArgTypes))
				if savedArgTypes["nil"] then
					t[#t+1] = [=[ or ]=]
					t[#t+1] = ("%q"):format(L["True"])
					savedArgTypes["string"] = true
					savedArgTypes["nil"] = nil
				elseif savedArgTypes["boolean"] then
					t[#t] = ("%q"):format(L["True"])
					savedArgTypes["string"] = true
					savedArgTypes["boolean"] = nil
				end
				for k in pairs(savedArgTypes) do
					types[k] = true
				end
				savedArgTypes = del(savedArgTypes)
				t[#t+1] = [=[;]=]
				t[#t+1] = "\n"
				t[#t+1] = "end;\n"
			else
				t[#t+1] = storeKey
				t[#t+1] = [=[ = not ]=]
				t[#t+1] = storeKey
				t[#t+1] = [=[;]=]
				t[#t+1] = "\n"
				types["boolean"] = true
			end
			local s = joinSet(types, ";")
			types = del(types)
			return forceTypes(storeKey, s, nil, forceToTypes, t)
		elseif results["nil"] then	
			-- just nil
			results = del(results)
			
			if savedArg then
				storeKey = s
				
				local types = newList()
				t[#t+1] = storeKey
				t[#t+1] = [=[ = ]=]
				t[#t+1] = savedArg
				savedArgTypes = newSet((";"):split(savedArgTypes))
				local hasNil = savedArgTypes["nil"]
				if hasNil then
					t[#t+1] = [=[ or ]=]
					t[#t+1] = ("%q"):format(L["True"])
					savedArgTypes["string"] = true
					savedArgTypes["nil"] = nil
				end	
				t[#t+1] = [=[;]=]
				t[#t+1] = "\n"
				for k in pairs(savedArgTypes) do
					types[k] = true
				end
				savedArgTypes = del(savedArgTypes)
				local s = joinSet(types, ';')
				types = del(types)
				return forceTypes(storeKey, s, not hasNil and savedArgStatic or nil, forceToTypes, t)
			else
				for i = t_num, #t do
					t[i] = nil
				end
				if storeKey then
					t[#t+1] = storeKey
					t[#t+1] = [=[ = ]=]
					t[#t+1] = ("%q"):format(L["True"])
					t[#t+1] = [=[;]=]
					t[#t+1] = "\n"
					return forceTypes(storeKey, "string", L["True"], forceToTypes, t)
				else
					return forceTypes(("%q"):format(L["True"]), "string", L["True"], forceToTypes, t)
				end
			end
		else
			-- non-nil
			results = del(results)
			
			for i = t_num, #t do
				t[i] = nil
			end
			if storeKey then
				t[#t+1] = storeKey
				t[#t+1] = [=[ = nil;]=]
				t[#t+1] = "\n"
				return forceTypes(storeKey, "nil", "@nil", forceToTypes, t)
			else
				return forceTypes("nil", "nil", "@nil", forceToTypes, t)
			end
		end
	elseif astType == '...' then
		t[#t+1] = [=[do return "... used inappropriately" end;]=]
		return "nil", "nil", nil
	end
	error(("Unknown astType: %q"):format(tostring(astType or '')))
end

local unalias
do
	local function replaceArg(ast, argName, value)
		local astType = getASTType(ast)
		if astType ~= "tag" and not allOperators[astType] then
			return
		end
		local argStart = astType == "tag" and 3 or 2
		for i = argStart, #ast do
			local v = ast[i]
			local astType = getASTType(v)
			if astType == "tag" and v[2] == argName then
				deepDel(v)
				ast[i] = deepCopy(value)
			else
				replaceArg(v, argName, value)
			end
		end
		if ast.kwarg then
			for k, v in pairs(ast.kwarg) do
				local astType = getASTType(v)
				if astType == "tag" and v[2] == argName then
					deepDel(v)
					ast.kwarg[k] = deepCopy(value)
				else
					replaceArg(v, argName, value)
				end
			end
		end
	end
	
	local function replaceTupleArg(ast, tupleArgs)
		local astType = getASTType(ast)
		if astType ~= "tag" and not allOperators[astType] then
			return
		end
		local argStart = astType == "tag" and 3 or 2
		for i = argStart, #ast do
			local v = ast[i]
			local astType = getASTType(v)
			if astType == "..." then
				deepDel(v)
				ast[i] = nil
				for j, u in ipairs(tupleArgs) do
					ast[i+j-1] = u
				end
				break
			else
				replaceTupleArg(v, tupleArgs)
			end
		end
	end
	
	function unalias(ast, nsList, kwargTypes)
		if type(ast) ~= "table" then
			return ast
		end
		local astType = getASTType(ast)
		for i = 2, #ast do
			local err
			ast[i], err = unalias(ast[i], nsList, kwargTypes)
			if not ast[i] then
				ast = deepDel(ast)
				return nil, err
			end
		end
		if astType ~= "tag" and not operators[astType] then
			return ast
		end
		local isTag = astType == "tag"
		local startArg = isTag and 3 or 2
		local tag = isTag and ast[2] or astType
		local tagData = getTagData(tag, nsList)
	
		if not tagData or tagData.code then
			for i = 2, #ast do
				local err
				ast[i], err = unalias(ast[i], nsList, kwargTypes)
				if not ast[i] then
					ast = deepDel(ast)
					return nil, err
				end
			end
			return ast
		end
		
		local alias = "[" .. tagData.alias .. "]"
		local args = newList()
		local tupleArgs = newList()
		local extraKwargs = newList()
		local arg = tagData.arg
		if arg then
			for i = 1, #arg, 3 do
				local argName = arg[i]
				if argName == "..." then
					local num = 0
					while true do
						num = num + 1
						local val = ast[(i-1)/3 + startArg - 1 + num]
						if not val then
							break
						end
						tupleArgs[num] = deepCopy(val)
					end
					break
				else
					local val = ast[(i-1)/3 + startArg] or ast.kwarg and ast.kwarg[argName]
					if not val and kwargTypes[argName] then
						val = newList("kwarg", argName)
						extraKwargs[val] = true
					end
					if not val and arg[i+2] == "@req" then
						tupleArgs = del(tupleArgs)
						args = del(args)
						ast = deepDel(ast)
						extraKwargs = deepDel(extraKwargs)
						return nil, ("Arg #%d (%s) req'd for %s"):format((i-1)/3+1, argName, tag)
					end
					if not val then
						val = arg[i+2]
					end
					args[argName] = deepCopy(val)
				end
			end
		end
		local parsedAlias = parse(alias)
		if not parsedAlias then
			tupleArgs = deepDel(tupleArgs)
			extraKwargs = deepDel(extraKwargs)
			args = deepDel(args)
			ast = deepDel(ast)
			return nil, ("Syntax error with alias %s"):format(tag)
		end
		local parsedAlias = standardize(parsedAlias)
		for k,v in pairs(args) do
			replaceArg(parsedAlias, k, v)
		end
		replaceTupleArg(parsedAlias, tupleArgs)
		deepDel(ast)
		tupleArgs = del(tupleArgs)
		args = del(args)
		extraKwargs = deepDel(extraKwargs)
		
		ast = parsedAlias
		ast = standardize(ast)
		correctASTCasing(ast)
		return unalias(ast, nsList, kwargTypes)
	end
end

local function readjustKwargs(ast, nsList, kwargTypes)
	if type(ast) ~= "table" then
		return ast
	end
	local astType = ast[1]
	for i = 2, #ast do
		local err
		ast[i], err = readjustKwargs(ast[i], nsList, kwargTypes)
		if ast[i] == nil then
			ast = deepDel(ast)
			return nil, err
		end
	end
	if ast.kwarg then
		for k,v in pairs(ast.kwarg) do
			local err
			ast.kwarg[k], err = readjustKwargs(v, nsList, kwargTypes)
			if ast.kwarg[k] == nil then
				ast = deepDel(ast)
				return nil, err
			end
		end
	end
	if astType == "tag" or operators[astType] then
		local start = astType == "tag" and 3 or 2
		local tag = astType == "tag" and ast[2] or astType
		local tagData = getTagData(tag, nsList)
		if not tagData then
			if kwargTypes[tag] then
				ast[1] = "kwarg"
				return ast
			end
			ast = deepDel(ast)
			return nil, ("Unknown tag %s"):format(tostring(tag))
		end
		local arg = tagData.arg
		if not ast.kwarg then
			ast.kwarg = newList()
		end
		local arg_num = 0
		local hitTuple = false
		local ast_len = #ast
		if arg then
			arg_num = #arg
			for i = 1, arg_num, 3 do
				local argName = arg[i]
				local default = arg[i+2]
				if default == true then
					default = L["True"]
				end
				if argName == "..." then
					hitTuple = true
					for j = start + ((i-1)/3), ast_len do
						local num = j - start - ((i-1)/3) + 1
						ast.kwarg["..." .. num] = ast[j]
						ast[j] = nil
					end
					for j = i+3, arg_num, 3 do
						argName = arg[j]
						default = arg[j+2]
						if not ast.kwarg[argName] and not kwargTypes[argName] then
							if default == "@req" then
								ast = deepDel(ast)
								return nil, ("Keyword-Arg %s req'd for %s"):format(argName, tag)
							end
							ast.kwarg[argName] = default
						end
					end
					break
				else
					local astVar = ast[start + ((i-1)/3)]
					if not astVar then
						if not ast.kwarg[argName] and not kwargTypes[argName] then
							if default == "@req" then
								ast = deepDel(ast)
								return nil, ("Arg #%d (%s) req'd for %s"):format((i-1)/3 + 1, argName, tag)
							end
							ast.kwarg[argName] = default
						end
					else
						ast.kwarg[argName] = astVar
						ast[start + ((i-1)/3)] = nil
					end
				end
			end
		end	
		if not hitTuple then
			if arg_num/3 < (ast_len - start + 1) then
				ast = deepDel(ast)
				return nil, ("Too many args for %s"):format(tag)
			end
		end
		if not next(ast.kwarg) then
			ast.kwarg = del(ast.kwarg)
		end
		if #ast ~= start-1 then
			error(("Assertion failed: %s == %s"):format(#ast, start-1))
		end
	end
	return ast
end

--[[
Notes:
	This is mostly used for debugging purposes
Arguments:
	string - a tag sequence
	[optional] string - a semicolon-separated list of namespaces. Base is implied
	[optional] table - a dictionary of default kwargs for all tags in the code to receive
Returns:
	string - a block of code which could have loadstring called on it.
Example:
	local funcCode = LibStub("LibDogTag-3.0"):CreateFunctionFromCode("[Name]", "Unit", { unit = 'player' })
]]
function DogTag:CreateFunctionFromCode(code, nsList, kwargs, notDebug)
	if type(code) ~= "string" then
		error(("Bad argument #2 to `CreateFunctionFromCode'. Expected %q, got %q."):format("string", type(code)), 2)
	elseif nsList and type(nsList) ~= "string" then
		error(("Bad argument #3 to `CreateFunctionFromCode'. Expected %q, got %q."):format("string", type(nsList)), 2)
	elseif kwargs and type(kwargs) ~= "table" then
		error(("Bad argument #4 to `CreateFunctionFromCode'. Expected %q, got %q."):format("table", type(kwargs)), 2)
	end
	local kwargTypes
	if notDebug then
		kwargTypes = kwargs
	else
		kwargTypes = kwargsToKwargTypes[kwargs] -- NOT safe for kwargsToKwargTypesWithTableCache
		kwargs = nil
		nsList = fixNamespaceList[nsList]
	end
	codeToEventList[nsList][kwargTypes][code] = false
	
	local ast = parse(code)
	if not ast then
		return ("return function() return %q, nil end"):format("Syntax error")
	end
	ast = standardize(ast)
	correctASTCasing(ast)
	local err
	ast, err = unalias(ast, nsList, kwargTypes)
	if not ast then
		return ("return function() return %q, nil end"):format(tostring(err))
	end
	ast, err = readjustKwargs(ast, nsList, kwargTypes)
	if not ast then
		return ("return function() return %q, nil end"):format(tostring(err))
	end
	for _, ns in ipairs(unpackNamespaceList[nsList]) do
		for step in pairs(compilationSteps.pre[ns]) do
			ast, err = step(ast, kwargTypes)
			if not ast then
				return ("return function() return %q, nil end"):format(tostring(err))
			end
		end
	end
	
	local t = newList()
	t[#t+1] = [=[local _G = _G;]=]
	t[#t+1] = "\n"
	t[#t+1] = ([=[local DogTag = _G.LibStub(%q);]=]):format(MAJOR_VERSION)
	t[#t+1] = "\n"
	t[#t+1] = [=[local colors = DogTag.__colors;]=]
	t[#t+1] = "\n"
	t[#t+1] = [=[local NIL = DogTag.__NIL;]=]
	t[#t+1] = "\n"
	t[#t+1] = [=[local mytonumber = DogTag.__mytonumber;]=]
	t[#t+1] = "\n"
	local t_num = #t
	t[#t+1] = [=[return function(kwargs)]=]
	t[#t+1] = "\n"
	t[#t+1] = [=[local result;]=]
	t[#t+1] = "\n"
	local cachedTags = figureCachedTags(ast)
	for k, v in pairs(cachedTags) do
		if v >= 2 then
			t[#t+1] = [=[local cache_]=]
			t[#t+1] = k
			t[#t+1] = [=[ = NIL;]=]
			t[#t+1] = "\n"
			cachedTags[k] = 1
		else
			cachedTags[k] = nil
		end
	end
	
	local u = newList()
	local extraKwargs = newList()
	for k, v in pairs(kwargTypes) do
		local arg = "kwargs_" .. k
		u[#u+1] = [=[local ]=]
		u[#u+1] = arg
		u[#u+1] = [=[ = kwargs["]=]
		u[#u+1] = k
		u[#u+1] = [=["];]=]
		u[#u+1] = "\n"
		extraKwargs[k] = newList(arg, v)
	end
	
	for _, ns in ipairs(unpackNamespaceList[nsList]) do
		for step in pairs(compilationSteps.start[ns]) do
			step(u, ast, kwargTypes, extraKwargs)
		end
	end
	
	local w = newList()
	local events = newList()
	local functions = newList()
	
	local good, ret, types, static = pcall(compile, ast, nsList, w, cachedTags, events, functions, extraKwargs, 'nil;number;string', 'result')
	if not good then
		DogTag.tagError(code, nsList, ret)
	end	
	
	for i, v in ipairs(w) do
		u[#u+1] = v
	end
	w = del(w)
	if not good then
		u = del(u)
		functions = del(functions)
		events = del(events)
		return ("return function() return %q end"):format(tostring(ret))
	end
	local w = newList()
	for k, v in pairs(functions) do
		w[#w+1] = [=[local tag_]=]
		w[#w+1] = k
		if type(v) == "string" then
			w[#w+1] = [=[ = DogTag.Tags.]=]
			local tagData, tagNS = getTagData(v, nsList)
			w[#w+1] = tagNS
			w[#w+1] = [=[[]=]
			w[#w+1] = ("%q"):format(v)
			w[#w+1] = [=[].code;]=]
			w[#w+1] = "\n"
		else
			w[#w+1] = [=[ = DogTag.__functions.]=]
			w[#w+1] = k
			w[#w+1] = [=[;]=]
			w[#w+1] = "\n"
		end
	end
	for i, v in ipairs(w) do
		table.insert(t, t_num+i, v)
	end
	w = del(w)
	for k, v in pairs(extraKwargs) do
		extraKwargs[k] = del(v)
	end
	if static then
		if static == "@nil" then
			static = nil
		end
		local literal
		if type(static) == "string" then
			if static == '' then
				static = nil
			elseif mytonumber(static) then
				static = static+0
			end
		end
		if type(static) == "string" then
			literal = ("%q"):format(static)
		elseif type(static) == "number" then
			literal = numberToString(static)
		else
			literal = "nil"
		end
		
		events = del(events)
		extraKwargs = del(extraKwargs)
		ast = deepDel(ast)
		cachedTags = del(cachedTags)
		t = del(t)
		u = del(u)
		clearUniqueVars()
		
		return ("return function() return %s end"):format(literal)
	end
	
	if not next(events) then
		events = del(events)
	else
		events = memoizeTable(events)
		codeToEventList[nsList][kwargTypes][code] = events
	end
	local num = getNumUniqueVars()
	if num > 0 then
		t[#t+1] = [=[local ]=]
		for i = 1, getNumUniqueVars() do
			if i > 1 then
				t[#t+1] = [=[, ]=]
			end
			t[#t+1] = [=[arg]=]
			t[#t+1] = i
		end
		t[#t+1] = [=[;]=]
		t[#t+1] = "\n"
	end
	for _,v in ipairs(u) do
		t[#t+1] = v
	end
	u = del(u)
	clearUniqueVars()
	
	types = newSet((";"):split(types))
	if types["string"] then
		t[#t+1] = "if type(result) == 'string' then\n"
--		t[#t+1] = "result = result:trim();\n"
--		t[#t+1] = "result = result:gsub('  +', ' ');\n"
		t[#t+1] = "if result == '' then\n"
		t[#t+1] = "result = nil;\n"
		t[#t+1] = "elseif mytonumber(result) then\n"
		t[#t+1] = "result = result+0;\n"
		t[#t+1] = "end;\n"
		t[#t+1] = "end;\n"
	end
	types = del(types)
	
	for _, ns in ipairs(unpackNamespaceList[nsList]) do
		for step in pairs(compilationSteps.finish[ns]) do
			step(t, ast, kwargTypes, extraKwargs)
		end
	end
	
	extraKwargs = del(extraKwargs)
	ast = deepDel(ast)
	
	t[#t+1] = [=[local opacity = DogTag.opacity;]=]
	t[#t+1] = "\n"
	t[#t+1] = [=[local outline = DogTag.outline;]=]
	t[#t+1] = "\n"
	t[#t+1] = [=[DogTag.opacity = nil;]=]
	t[#t+1] = "\n"
	t[#t+1] = [=[DogTag.outline = nil;]=]
	t[#t+1] = "\n"
	t[#t+1] = [=[return result or nil, opacity, outline;]=]
	t[#t+1] = "\n"
	t[#t+1] = "end;\n"
	
	cachedTags = del(cachedTags)
	local s = table.concat(t)
	t = del(t)
	if not notDebug then
		s = enumLines(s) -- avoid interning the new string if not debugging
		functions = del(functions)
		return s
	else
		return s, functions
	end
end

local codeEvaluationTime_mt = {__index = function(self, kwargTypes)
	local t = newList()
	self[kwargTypes] = t
	return t
end, __mode='k'}
local codeEvaluationTime = setmetatable({}, {__index = function(self, nsList)
	local t = setmetatable(newList(), codeEvaluationTime_mt)
	self[nsList] = t
	return t
end})
DogTag.codeEvaluationTime = codeEvaluationTime

local function evaluate(code, nsList, kwargs, kwargTypes)

	-- kwargTypes is passed in if calling from DogTag:Evaluate() because it cannot be cached,
	-- but otherwise we should be able to safely get from the table cached version of kwargsToKwargTypes.
	-- Just make sure that where ever evaluate() is called, a 'safe' kwargs table is passed in
	-- (one that DogTag generated from memoizeTable, not one that was passed in externally from another addon)
	kwargTypes = kwargTypes or kwargsToKwargTypesWithTableCache[kwargs]

	DogTag.__isMouseOver = false
	
	local func = codeToFunction[nsList][kwargTypes][code]
	codeEvaluationTime[nsList][kwargTypes][code] = GetTime()
	
	local madeKwargs = not kwargs
	if madeKwargs then
		kwargs = newList()
	end
	
	local success, text, opacity, outline = pcall(func, kwargs)
	if not success then
		DogTag.tagError(code, nsList, text)
		return
	end
	
	if madeKwargs then
		kwargs = del(kwargs)
	end
	if success then
		return text, opacity, outline
	end
end
DogTag.evaluate = evaluate

--[[
Arguments:
	string - the tag sequence to compile and evaluate
	[optional] string - a semicolon-separated list of namespaces. Base is implied
	[optional] table - a dictionary of default kwargs for all tags in the code to receive
Returns:
	string, number, or nil - the resultant generated text
	number or nil - the expected opacity of the generated text, specified by the [Alpha(num)] tag. nil if not specified.
	string - the outline style, can be "", "OUTLINE", or "OUTLINE, THICKOUTLINE"
Example:
	local text = LibStub("LibDogTag-3.0"):Evaluate("[Name]", "Unit", { unit = 'player' })
]]
function DogTag:Evaluate(code, nsList, kwargs)
	if type(code) ~= "string" then
		error(("Bad argument #2 to `Evaluate'. Expected %q, got %q"):format("string", type(code)), 2)
	elseif nsList and type(nsList) ~= "string" then
		error(("Bad argument #3 to `Evaluate'. Expected %q, got %q"):format("string", type(nsList)), 2)
	elseif kwargs and type(kwargs) ~= "table" then
		error(("Bad argument #4 to `Evaluate'. Expected %q, got %q"):format("table", type(kwargs)), 2)
	end
	nsList = fixNamespaceList[nsList]
	
	
	-- kwargTypes is passed into evaluate() instead of determined inside of evaluate() because
	-- evaluate will obtain kwargTypes from kwargsToKwargTypesWithTableCache if it is not passed in.
	-- This function's kwargs are not 'secure' and so there is no guarentee that the table isn't being
	-- reused with different values and types. (see definition of kwargsToKwargTypesWithTableCache in Helpers.lua for an explanation)
	
	local kwargTypes = kwargsToKwargTypes[kwargs]
	
	return evaluate(code, nsList, kwargs, kwargTypes)
end

--[[
Note:
	Add a step to the compilation process
	This should only be done by sublibraries or addons that add tags
Arguments:
	string - namespace to run the compilation step on
	string - kind of compilation step, can be "pre", "start", "tag", "tagevents", or "finish"
	function - the function to run
Example:
	DogTag:AddCompilationStep("MyNamespace", "start", function(t, ast, kwargTypes, extraKwargs)
		-- do something here
	end)
]]
function DogTag:AddCompilationStep(namespace, kind, func)
	if type(namespace) ~= "string" then
		error(("Bad argument #2 to `AddCompilationStep'. Expected %q, got %q"):format("string", type(namespace)), 2)
	end
	if type(kind) ~= "string" then
		error(("Bad argument #3 to `AddCompilationStep'. Expected %q, got %q"):format("string", type(kind)), 2)
	elseif kind ~= "pre" and kind ~= "start" and kind ~= "tag" and kind ~= "tagevents" and kind ~= "finish" then
		error(("Bad argument #3 to `AddCompilationStep'. Expected %q, %q, %q, %q, or %q, got %q"):format("pre", "start", "tag", "tagevents", "finish", kind), 2)
	end
	if type(func) ~= "function" then
		error(("Bad argument #4 to `AddCompilationStep'. Expected %q, got %q"):format("function", type(func)), 2)
	end
	compilationSteps[kind][namespace][func] = true
	clearCodes(namespace)
end

--[[
Note:
	Remove a step from the compilation process
	This should only be done by sublibraries or addons that add tags
Arguments:
	string - namespace to run the compilation step on
	string - kind of compilation step, can be "pre", "start", "tag", "tagevents", or "finish"
	function - the function to run
Example:
	DogTag:RemoveCompilationStep("MyNamespace", "start", func)
]]
function DogTag:RemoveCompilationStep(namespace, kind, func)
	if type(namespace) ~= "string" then
		error(("Bad argument #2 to `AddCompilationStep'. Expected %q, got %q"):format("string", type(namespace)), 2)
	end
	if type(kind) ~= "string" then
		error(("Bad argument #3 to `AddCompilationStep'. Expected %q, got %q"):format("string", type(kind)), 2)
	elseif kind ~= "pre" and kind ~= "start" and kind ~= "tag" and kind ~= "tagevents" and kind ~= "finish" then
		error(("Bad argument #3 to `AddCompilationStep'. Expected %q, %q, %q, %q, or %q, got %q"):format("pre", "start", "tag", "tagevents", "finish", kind), 2)
	end
	if type(func) ~= "function" then
		error(("Bad argument #4 to `AddCompilationStep'. Expected %q, got %q"):format("function", type(func)), 2)
	end
	compilationSteps[kind][namespace][func] = nil
	clearCodes(namespace)
end

--[[
Note:
	Remove all steps from the compilation process
	This should only be done by sublibraries or addons that add tags
Arguments:
	string - namespace to run the compilation step on
	[optional] string - kind of compilation step, can be "pre", "start", "tag", "tagevents", or "finish", if not specified, then all kinds
Example:
	DogTag:RemoveAllCompilationSteps("MyNamespace", "start")
	DogTag:RemoveAllCompilationSteps("MyNamespace")
]]
function DogTag:RemoveAllCompilationSteps(namespace, kind)
	if type(namespace) ~= "string" then
		error(("Bad argument #3 to `AddCompilationStep'. Expected %q, got %q"):format("string", type(namespace)), 2)
	end
	if kind then
		if type(kind) ~= "string" then
			error(("Bad argument #3 to `AddCompilationStep'. Expected %q, got %q"):format("string", type(kind)), 2)
		elseif kind ~= "pre" and kind ~= "start" and kind ~= "tag" and kind ~= "tagevents" and kind ~= "finish" then
			error(("Bad argument #3 to `AddCompilationStep'. Expected %q, %q, %q, %q, or %q, got %q"):format("pre", "start", "tag", "tagevents", "finish", kind), 2)
		end
		local compilationSteps_kind_namespace = rawget(compilationSteps[kind], namespace)
		if compilationSteps_kind_namespace then
			compilationSteps[kind][namespace] = del(compilationSteps_kind_namespace)
		end
	else
		for kind, data in pairs(compilationSteps) do
			local data_namespace = rawget(data, namespace)
			if data_namespace then
				data[namespace] = del(data_namespace)
			end
		end
	end
	clearCodes(namespace)
end

end