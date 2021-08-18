--[[

 The majority of the lua parsing code in LibParse is based on the JSON
 Lua 5.1 Encoder and Parser found here:
 
 http://www.chipmunkav.com/downloads/Json.lua
 
 ------------------------------------------------------------------------------
 
 Permission is hereby granted, free of charge, to any person 
 obtaining a copy of this software to deal in the Software without 
 restriction, including without limitation the rights to use, 
 copy, modify, merge, publish, distribute, sublicense, and/or 
 sell copies of the Software, and to permit persons to whom the 
 Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be 
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR 
 ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
 CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
 CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

 Usage:

 -- Lua script:
 local lib = LibStub("LibParse")
 local t = { 
	["name1"] = "value1",
	["name2"] = {1, false, true, 23.54, "a \021 string"},
	name3 = Json.Null() 
 }

 local json = lib:JsonEncode (t)
 print (json) 
 --> {"name1":"value1","name3":null,"name2":[1,false,true,23.54,"a \u0015 string"]}

 local t = lib:JsonDecode(json)
 print(t.name2[4])
 --> 23.54
 
 -- WoW test script:
 /run local lib = LibStub("LibParse") local t = {name1 = "value1", ["name2"]={1, false, true, 23.54, "a \u0015 string"}} local json = lib:JSONEncode(t) print(json) local tt = lib:JSONDecode(json) print(tt.name2[4])
 --> {"name1":"value1","name3":null,"name2":[1,false,true,23.54,"a \u0015 string"]}
 --> 23.54
 
 Notes:
 1) Encodable Lua types: string, number, boolean, table, nil
 2) Use Json.Null() to insert a null value into a Json object
 3) All control chars are encoded to \uXXXX format eg "\021" encodes to "\u0015"
 4) All Json \uXXXX chars are decoded to chars (0-255 byte range only)
 5) Json single line // and /* */ block comments are discarded during decoding
 6) Numerically indexed Lua arrays are encoded to Json Lists eg [1,2,3]
 7) Lua dictionary tables are converted to Json objects eg {"one":1,"two":2}
 8) Json nulls are decoded to Lua nil and treated by Lua in the normal way

--]]

local lib = LibStub:NewLibrary("LibParse", 2)
if not lib then return end

local pairs, ipairs, tonumber, tostring = pairs, ipairs, tonumber, tostring
local setmetatable, type, error = setmetatable, type, error
local format, gsub, strfind, strsub, strchar, strbyte, floor = format, gsub, strfind, strsub, strchar, strbyte, floor

local null = {} -- table ref to use for Null


local JsonWriter = {
	backslashes = {
		['\b'] = "\\b",
		['\t'] = "\\t",	
		['\n'] = "\\n", 
		['\f'] = "\\f",
		['\r'] = "\\r", 
		['"']  = "\\\"", 
		['\\'] = "\\\\", 
		['/']  = "\\/"
	}
}

function JsonWriter:New()
	local o = {buffer={}}
	setmetatable(o, self)
	self.__index = self
	return o
end

function JsonWriter:Append(s)
	self.buffer[#self.buffer+1] = s
	if #self.buffer > 1000 then
		local temp = table.concat(self.buffer)
		self.buffer = {temp}
	end
end

function JsonWriter:ToString()
	return table.concat(self.buffer)
end

function JsonWriter:Write(o)
	local t = type(o)
	if t == "nil" or o == null then
		self:Append("null")
	elseif t == "boolean" or t == "number" then
		self:Append(tostring(o))
	elseif t == "string" then
		self:ParseString(o)
	elseif t == "table" then
		self:WriteTable(o)
	else
		error(format("Encoding of %s unsupported", tostring(o)))
	end
end

function JsonWriter:ParseString(s)
	self:Append('"')
	self:Append(gsub(s, "[%z%c\\\"/]", function(n)
			local c = self.backslashes[n]
			if c then return c end
			return format("\\u%.4X", strbyte(n))
		end))
	self:Append('"')
end

function JsonWriter:IsArray(t)
	local count = 0
	local isindex = function(k) 
		if type(k) == "number" and k > 0 then
			if floor(k) == k then
				return true
			end
		end
		return false
	end
	for k,v in pairs(t) do
		if not isindex(k) then
			return false, '{', '}'
		else
			count = max(count, k)
		end
	end
	return true, '[', ']', count
end

function JsonWriter:WriteTable(t)
	local ba, st, et, n = self:IsArray(t)
	self:Append(st)	
	if ba then		
		for i = 1, n do
			self:Write(t[i])
			if i < n then
				self:Append(',')
			end
		end
	else
		local first = true;
		for k, v in pairs(t) do
			if not first then
				self:Append(',')
			end
			first = false;			
			self:ParseString(k)
			self:Append(':')
			self:Write(v)			
		end
	end
	self:Append(et)
end


local StringReader = {
	s = "",
	i = 0
}

function StringReader:New(s)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.s = s or o.s
	return o	
end

function StringReader:Peek()
	local i = self.i + 1
	if i <= #self.s then
		return strsub(self.s, i, i)
	end
	return nil
end

function StringReader:Next()
	self.i = self.i+1
	if self.i <= #self.s then
		return strsub(self.s, self.i, self.i)
	end
	return nil
end

function StringReader:All()
	return self.s
end

local JsonReader = {
	escapes = {
		['t'] = '\t',
		['n'] = '\n',
		['f'] = '\f',
		['r'] = '\r',
		['b'] = '\b',
	}
}

function JsonReader:New(s)
	local o = {}
	o.reader = StringReader:New(s)
	setmetatable(o, self)
	self.__index = self
	return o;
end

function JsonReader:Read()
	self:SkipWhiteSpace()
	local peek = self:Peek()
	if peek == nil then
		error(format("Nil string: '%s'", self:All()))
	elseif peek == '{' then
		return self:ReadObject()
	elseif peek == '[' then
		return self:ReadArray()
	elseif peek == '"' then
		return self:ReadString()
	elseif strfind(peek, "[%+%-%d]") then
		return self:ReadNumber()
	elseif peek == 't' then
		return self:ReadTrue()
	elseif peek == 'f' then
		return self:ReadFalse()
	elseif peek == 'n' then
		return self:ReadNull()
	elseif peek == '/' then
		self:ReadComment()
		return self:Read()
	else
		error(format("Invalid input: '%s'", self:All()))
	end
end
		
function JsonReader:ReadTrue()
	self:TestReservedWord{'t','r','u','e'}
	return true
end

function JsonReader:ReadFalse()
	self:TestReservedWord{'f','a','l','s','e'}
	return false
end

function JsonReader:ReadNull()
	self:TestReservedWord{'n','u','l','l'}
	return nil
end

function JsonReader:TestReservedWord(t)
	for i, v in ipairs(t) do
		if self:Next() ~= v then
			error(format("Error reading '%s': %s", table.concat(t), self:All()))
		end
	end
end

function JsonReader:ReadNumber()
	local result = self:Next()
	local peek = self:Peek()
	while peek ~= nil and strfind(peek, "[%+%-%d%.eE]") do
		result = result .. self:Next()
		peek = self:Peek()
	end
	result = tonumber(result)
	if result == nil then
		error(format("Invalid number: '%s'", result))
	else
		return result
	end
end

function JsonReader:ReadString()
	local result = ""
	if self:Next() ~= '"' then error("Assertion error: self:Next() ~= '\"'") end
	while self:Peek() ~= '"' do
		local ch = self:Next()
		if ch == '\\' then
			ch = self:Next()
			if self.escapes[ch] then
				ch = self.escapes[ch]
			end
		end
		result = result .. ch
	end
	
	if self:Next() ~= '"' then error("Assertion error: self:Next() ~= '\"'") end
	return gsub(result, "u%x%x(%x%x)", function(m) return strchar(tonumber(m, 16)) end)
end

function JsonReader:ReadComment()
	if self:Next() ~= '/' then error("Assertion error: self:Next() ~= '/'") end
	local second = self:Next()
	if second == '/' then
		self:ReadSingleLineComment()
	elseif second == '*' then
		self:ReadBlockComment()
	else
		error(format("Invalid comment: %s", self:All()))
	end
end

function JsonReader:ReadBlockComment()
	local done = false
	while not done do
		local ch = self:Next()		
		if ch == '*' and self:Peek() == '/' then
			done = true
		end
		if not done and ch == '/' and self:Peek() == "*" then
			error(format("Invalid comment: %s, '/*' illegal.", self:All()))
		end
	end
	self:Next()
end

function JsonReader:ReadSingleLineComment()
	local ch = self:Next()
	while ch ~= '\r' and ch ~= '\n' do
		ch = self:Next()
	end
end

function JsonReader:ReadArray()
	local result = {}
	if self:Next() ~= '[' then error("Assertion error: self:Next() ~= '['") end
	local done = false
	if self:Peek() == ']' then
		done = true;
	end
	while not done do
		local item = self:Read()
		result[#result+1] = item
		self:SkipWhiteSpace()
		if self:Peek() == ']' then
			done = true
		end
		if not done then
			local ch = self:Next()
			if ch ~= ',' then
				error(format("Invalid array: '%s' due to: '%s'", self:All(), ch))
			end
		end
	end
	if self:Next() ~= ']' then error("Assertion error: self:Next() ~= ']'") end
	return result
end

function JsonReader:ReadObject()
	local result = {}
	if self:Next() ~= '{' then error("Assertion error: self:Next() ~= '{'") end
	local done = false
	if self:Peek() == '}' then
		done = true
	end
	while not done do
		local key = self:Read()
		if type(key) ~= "string" then
			error(format("Invalid non-string object key: %s", key))
		end
		self:SkipWhiteSpace()
		local ch = self:Next()
		if ch ~= ':' then
			error(format("Invalid object: '%s' due to: '%s'", self:All(), ch))
		end
		self:SkipWhiteSpace()
		local val = self:Read()
		result[key] = val
		self:SkipWhiteSpace()
		if self:Peek() == '}' then
			done = true
		end
		if not done then
			ch = self:Next()
			if ch ~= ',' then
				error(format("Invalid array: '%s' near: '%s'", self:All(), ch))
			end
		end
	end
	if self:Next() ~= "}" then error("Assertion error: self:Next() ~= '}'") end
	return result
end

function JsonReader:SkipWhiteSpace()
	local p = self:Peek()
	while p ~= nil and strfind(p, "[%s/]") do
		if p == '/' then
			self:ReadComment()
		else
			self:Next()
		end
		p = self:Peek()
	end
end

function JsonReader:Peek()
	return self.reader:Peek()
end

function JsonReader:Next()
	return self.reader:Next()
end

function JsonReader:All()
	return self.reader:All()
end

function lib:JSONEncode(o)
	local writer = JsonWriter:New()
	writer:Write(o)
	return writer:ToString()
end

function lib:JSONDecode(s)
	local reader = JsonReader:New(s)
	return reader:Read()
end

function lib:JSONNull()
	return null
end




-- ###############################################################
--                         CSV Functions
-- ###############################################################

function lib:CSVEncode(keys, data)
	local lines = {}
	tinsert(lines, table.concat(keys, ","))
	for _, entry in ipairs(data) do
		local lineParts = {}
		for _, key in ipairs(keys) do
			tinsert(lineParts, entry[key] or "")
		end
		tinsert(lines, table.concat(lineParts, ","))
	end
	return table.concat(lines, "\n")
end

local function SafeStrSplit(str, sep)
	local parts = {}
	local s = 1
	while true do
		local e = strfind(str, sep, s)
		if not e then
			tinsert(parts, strsub(str, s))
			break
		end
		tinsert(parts, strsub(str, s, e-1))
		s = e + 1
	end
	return parts
end

function lib:CSVDecode(str)
	local keys
	local result = {}
	local lines = SafeStrSplit(str, "\n")
	for i, line in ipairs(lines) do
		if i == 1 then
			keys = {(","):split(lines[1])}
		else
			local entry = {}
			local lineParts = {(","):split(line)}
			for j, key in ipairs(keys) do
				if lineParts[j] ~= "" then
					entry[key] = tonumber(lineParts[j]) or lineParts[j]
				end
			end
			tinsert(result, entry)
		end
	end
	return keys, result
end
