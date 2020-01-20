local MAJOR_VERSION = "LibDogTag-3.0"
local MINOR_VERSION = 90000 + (tonumber(("20200115020223"):match("%d+")) or 33333333333333)

if MINOR_VERSION > _G.DogTag_MINOR_VERSION then
	_G.DogTag_MINOR_VERSION = MINOR_VERSION
end

local _G, string, table, math, error = _G, string, table, math, error 

-- #AUTODOC_NAMESPACE DogTag

DogTag_funcs[#DogTag_funcs+1] = function(DogTag)

--[=[
DOGTAG              = { SEGMENT }
SEGMENT             = TAG_SEQUENCE | OUTER_STRING
OUTER_STRING        = ( ANY - "[", ) { ANY - "[" }
TAG_SEQUENCE        = "[", MULTI_SPACE, INNER_TAG_SEQUENCE, MULTI_SPACE, "]"
INNER_TAG_SEQUENCE  = IF_STATEMENT
CHUNK_WITH_MODIFIER = UNARY_MINUS, { MULTI_SPACE, ":", [ "~", ] TAG, [ PARAM_LIST ] }
UNARY_MINUS         = [ "-", MULTI_SPACE, ] CHUNK
CHUNK               = GROUPING | STRING | NUMBER | "nil" | "true" | "false" | TAG, [ PARAM_LIST ] | "..."
GROUPING            = "(", MULTI_SPACE, INNER_TAG_SEQUENCE, MULTI_SPACE, ")"
                    | "[", MULTI_SPACE, INNER_TAG_SEQUENCE, MULTI_SPACE, "]"
TAG                 = ALPHANUM
PARAM_LIST          = "(", MULTI_SPACE, INNER_PARAM_LIST, MULTI_SPACE, ")"
INNER_PARAM_LIST    = INNER_TAG_SEQUENCE, { MULTI_SPACE, ",", MULTI_SPACE, INNER_TAG_SEQUENCE }, { MULTI_SPACE, ",", MULTI_SPACE, ALPHANUM, "=", INNER_TAG_SEQUENCE }
STRING              = '"', ( ANY - '"' ), '"' | "'", ( ANY - "'" ), "'" -- actually more complicated, as it supports backslashes and escaping.
NUMBER              = SIGNED_INTEGER, [ ".", MULTI_DIGIT | ("e" | "E"), SIGNED_INTEGER ]
SIGNED_INTEGER      = [ "-", ] MULTI_DIGIT
ALPHANUM            = ('A'..'Z' | 'a'..'z' | '_'), { '0'..'9' | 'A'..'Z' | 'a'..'z' | '_' }
MULTI_DIGIT         = '0'..'9', { '0'..'9' }
MULTI_SPACE         = { SPACE }
SPACE               = " " | "\t" | "\n" | "\r"
IF_STATEMENT        = COMPARISON, [ MULTI_SPACE, "?", MULTI_SPACE, IF_STATEMENT, [ MULTI_SPACE, "!", MULTI_SPACE, IF_STATEMENT ] ]
                    | "if", MULTI_SPACE, IF_STATEMENT, MULTI_SPACE, "then", MULTI_SPACE, IF_STATEMENT, { MULTI_SPACE, "elseif" MULTI_SPACE, IF_STATEMENT, MULTI_SPACE, "then" MULTI_SPACE, IF_STATEMENT, } [ MULTI_SPACE, "else", MULTI_SPACE, IF_STATEMENT, [ "end" ] ]
COMPARISON          = LOGIC, { MULTI_SPACE, ("<=" | "<" | ">" | ">=" | "=" | "~="), MULTI_SPACE, LOGIC }
LOGIC               = CONCATENATION, { MULTI_SPACE, ( "and" | "or" | "&" | "|" | "||" ), MULTI_SPACE, CONCATENATION }
CONCATENATION       = ADDITION, { SPACE, MULTI_SPACE, ADDITION }
ADDITION            = MULTIPLICATION, { SPACE, MULTI_SPACE, "-", MULTIPLICATION | MULTI_SPACE, ( "+" | "-" ), MULTI_SPACE, MULTIPLICATION }
MULTIPLICATION      = NEGATION, { MULTI_SPACE, ( "*" | "/" | "%" ), MULTI_SPACE, NEGATION }
NEGATION            = { ( "not" | "~" ), MULTI_SPACE, } EXPONENTIATION
EXPONENTIATION      = CHUNK_WITH_MODIFIER, { MULTI_SPACE, "^", MULTI_SPACE CHUNK_WITH_MODIFIER }
]=]

local L = DogTag.L

local DOGTAG, SEGMENT, TAG_SEQUENCE, CHUNK, SPACE, MULTI_SPACE, EXPONENTIATION, MULTIPLICATION, ADDITION, CONCATENATION, LOGIC, MULTI_DIGIT, ALPHANUM, SIGNED_INTEGER, INNER_PARAM_LIST, COMPARISON, IF_STATEMENT, INNER_TAG_SEQUENCE, TAG, PARAM_LIST, NUMBER, STRING, GROUPING, NEGATION, CHUNK_WITH_MODIFIER, UNARY_MINUS, OUTER_STRING

local _G = _G
local table_concat = _G.table.concat
local table_insert = _G.table.insert
local table_sort = _G.table.sort
local string_char = _G.string.char
local type = _G.type
local pairs = _G.pairs
local ipairs = _G.ipairs
local tostring = _G.tostring
local tonumber = _G.tonumber
local unpack = _G.unpack
local newList, del, deepDel = DogTag.newList, DogTag.del, DogTag.deepDel
local correctASTCasing
DogTag_funcs[#DogTag_funcs+1] = function()
	correctASTCasing = DogTag.correctASTCasing
end

local reserved = {
	["if"] = true,
	["then"] = true,
	["else"] = true,
	["elseif"] = true,
	["end"] = true,
	["and"] = true,
	["or"] = true,
	["not"] = true,
}

local A_byte = ('A'):byte()
local a_byte = ('a'):byte()
local Z_byte = ('Z'):byte()
local z_byte = ('z'):byte()
local e_byte = ('e'):byte()
local n_byte = ('n'):byte()
local newline_byte = ('\n'):byte()
local zero_byte = ('0'):byte()
local nine_byte = ('9'):byte()
local underscore_byte = ('_'):byte()
local open_bracket_byte = ('['):byte()
local close_bracket_byte = (']'):byte()
local open_parenthesis_byte = ('('):byte()
local close_parenthesis_byte = (')'):byte()
local colon_byte = (':'):byte()
local tilde_byte = ('~'):byte()
local period_byte = ('.'):byte()
local comma_byte = (','):byte()
local equals_byte = ('='):byte()
local left_angle_byte = ('<'):byte()
local right_angle_byte = ('>'):byte()
local ampersand_byte = ('&'):byte()
local pipe_byte = ('|'):byte()
local plus_byte = ('+'):byte()
local minus_byte = ('-'):byte()
local asterix_byte = ('*'):byte()
local slash_byte = ('/'):byte()
local percent_byte = ('%'):byte()
local carat_byte = ('^'):byte()
local question_mark_byte = ('?'):byte()
local exclamation_point_byte = ('!'):byte()
local backslash_byte = ([=[\]=]):byte()
local single_quote_byte = ([=[']=]):byte()
local double_quote_byte = ([=["]=]):byte()

local string_byte = string.byte
local string_char = string.char

local function stringToTokenList(str)
	local tokens = newList()
	for i = 1, #str do
		tokens[i] = string_byte(str, i)
	end
	return tokens
end

local function tokenListToString(tokens)
	for i = 1, #tokens do
		tokens[i] = string_char(tokens[i])
	end
	local s = table.concat(tokens)
	tokens = del(tokens)
	return s
end

local lower = {}
for i = 1, 26 do
	lower[A_byte+i-1] = a_byte+i-1
end

local function matches(tokens, position, phrase)
	for i = 1, #phrase do
		local v = string_byte(phrase, i)
		local c = tokens[position+i-1]
		if not c or (c ~= v and lower[c] ~= v) then
			return false
		end
	end
	local c = tokens[position + #phrase]
	if c and ((c >= a_byte and c <= z_byte) or (c >= A_byte and c <= Z_byte)) and phrase:match("^[a-z]+$") then
		return false
	end
	return true
end

function DOGTAG(tokens)
	local position = 1
	local isConcatList = false
	local list
	while true do
		local pos, data = SEGMENT(tokens, position)
		if pos then
			position = pos
			if list then
				if isConcatList then
					list[#list+1] = data
				else
					list = newList("concat", list, data)
					isConcatList = true
				end
			else
				list = data
			end
		elseif position <= #tokens then
			if type(list) == "table" then
				list = del(list)
			end
			return nil
		else
			break
		end
	end
	return list
end

function SEGMENT(tokens, position)
	local pos, data = OUTER_STRING(tokens, position)
	if pos then
		return pos, data
	end
	
	local pos, data = TAG_SEQUENCE(tokens, position)
	if pos then
		return pos, data
	end
	
	return nil
end

function OUTER_STRING(tokens, position)
	local c = tokens[position]
	if not c or c == open_bracket_byte then
		return nil
	end
	
	local t = newList(c)
	position = position + 1
	while true do
		c = tokens[position]
		if not c or c == open_bracket_byte then
			return position, tokenListToString(t)
		end
		t[#t+1] = c
		position = position + 1
	end
end

function TAG_SEQUENCE(tokens, position)
	if tokens[position] ~= open_bracket_byte then
		return nil
	end
	
	position = MULTI_SPACE(tokens, position+1)
	
	local position, data = INNER_TAG_SEQUENCE(tokens, position)
	if not position then
		return nil
	end
	
	position = MULTI_SPACE(tokens, position)
	
	if tokens[position] ~= close_bracket_byte then
		data = deepDel(data)
		return nil
	end
	return position+1, data
end

function INNER_TAG_SEQUENCE(tokens, position)
	local position, data = IF_STATEMENT(tokens, position)
	if not position then
		return nil
	end
	return position, data
end

function CHUNK_WITH_MODIFIER(tokens, position)
	local position, data = UNARY_MINUS(tokens, position)
	if not position then
		return nil
	end
	
	while true do
		local pos = MULTI_SPACE(tokens, position)
		
		if tokens[pos] ~= colon_byte then
			return position, data
		end
	
		pos = MULTI_SPACE(tokens, pos+1)
	
		if tokens[pos] == tilde_byte then
			pos = MULTI_SPACE(tokens, pos+1)
		
			local pos, d = TAG(tokens, pos)
			if not pos then
				return position, data
			end
			local p, list = PARAM_LIST(tokens, pos)
			if p then
				table_insert(list, 1, "mod")
				table_insert(list, 2, d)
				table_insert(list, 3, data)
				position, data = p, newList("~", list)
			else
				position, data = pos, newList("~", newList("mod", d, data))
			end
		else
			local pos, d = TAG(tokens, pos)
			if not pos then
				return position, data
			end
			local p, list = PARAM_LIST(tokens, pos)
			if p then
				table_insert(list, 1, "mod")
				table_insert(list, 2, d)
				table_insert(list, 3, data)
				position, data = p, list
			else
				position, data = pos, newList("mod", d, data)
			end
		end
	end
end

function UNARY_MINUS(tokens, position)
	local op = tokens[position]

	if op ~= minus_byte then
		local position, data = CHUNK(tokens, position)
		if not position then
			return nil
		end
		return position, data
	end

	local pos = MULTI_SPACE(tokens, position+1)

	if tokens[pos] == minus_byte then
		-- don't have double negatives without parentheses
		return nil
	end
	local position, data = CHUNK(tokens, pos)
	if not position then
		return nil
	end
	if type(data) == "number" then
		return position, -data
	else
		return position, newList("unm", data)
	end
end

function CHUNK(tokens, position)
	local pos, data = GROUPING(tokens, position)
	if pos then
		return pos, data
	end
	
	pos, data = STRING(tokens, position)
	if pos then
		return pos, data
	end
	
	pos, data = NUMBER(tokens, position)
	if pos then
		return pos, data
	end
	
	if matches(tokens, position, "nil") then
		return position+3, newList("nil")
	end
	
	if matches(tokens, position, "true") then
		return position+4, newList("true")
	end
	
	if matches(tokens, position, "false") then
		return position+5, newList("false")
	end
	
	if matches(tokens, position, "...") then
		return position+3, newList("...")
	end
	
	pos, data = TAG(tokens, position)
	if pos then
		local data_lower = data:lower()
		local p, list = PARAM_LIST(tokens, pos)
		if p then
			table_insert(list, 1, "tag")
			table_insert(list, 2, data)
			return p, list
		else
			return pos, newList("tag", data)
		end
	end
	
	return nil
end

local groupings = {
	[open_bracket_byte] = close_bracket_byte,
	[open_parenthesis_byte] = close_parenthesis_byte
}

function GROUPING(tokens, position)
	local start = tokens[position]
	local shouldFinish = groupings[start]
	if not shouldFinish then
		return nil
	end
	
	position = MULTI_SPACE(tokens, position+1)
	
	local position, data = INNER_TAG_SEQUENCE(tokens, position)
	if not position then
		return nil
	end
	
	position = MULTI_SPACE(tokens, position)
	
	if tokens[position] ~= shouldFinish then
		data = deepDel(data)
		return nil
	end
	return position+1, newList(string_char(start), data)
end

function TAG(tokens, position)
	local position, tag = ALPHANUM(tokens, position)
	if not position then
		return nil
	end
	if tag and type(tag) == "string" then
		local tag_lower = tag:lower()
		if reserved[tag_lower] then
			return nil
		end
	end
	return position, tag
end

-- INNER_TAG_SEQUENCE, { MULTI_SPACE, ",", MULTI_SPACE, INNER_TAG_SEQUENCE }, { MULTI_SPACE, ",", MULTI_SPACE, ALPHANUM, "=", INNER_TAG_SEQUENCE }
function INNER_PARAM_LIST(tokens, position)
	local pos, key = ALPHANUM(tokens, position)
	local data
	if pos and tokens[pos] == equals_byte and key:lower() == key then
		local value
		position, value = INNER_TAG_SEQUENCE(tokens, pos+1)
		if not position then
			return nil
		end
		data = newList()
		data.kwarg = newList()
		data.kwarg[key] = value
	else
		position, data = INNER_TAG_SEQUENCE(tokens, position)
		if not position then
			return nil
		end
		data = newList(data)
	end
	
	while true do
		position = MULTI_SPACE(tokens, position)
		if tokens[position] ~= comma_byte then
			return position, data
		end
		position = MULTI_SPACE(tokens, position+1)
		local pos, key = ALPHANUM(tokens, position)
		if pos and tokens[pos] == equals_byte and key:lower() == key then
			local pos, value = INNER_TAG_SEQUENCE(tokens, pos+1)
			if not pos then
				return position, data
			end
			position = pos
			if not data.kwarg then
				data.kwarg = newList()
			end
			data.kwarg[key] = value
		elseif not data.kwarg then
			local pos, chunk = INNER_TAG_SEQUENCE(tokens, position)
			if not pos then
				return position, data
			end
			position = pos
			data[#data+1] = chunk
		end
	end
end

function PARAM_LIST(tokens, position)
	if tokens[position] ~= open_parenthesis_byte then
		return nil
	end
	
	position = MULTI_SPACE(tokens, position+1)
	
	local position, data = INNER_PARAM_LIST(tokens, position)
	if not position then
		return nil
	end
	
	position = MULTI_SPACE(tokens, position)
	
	if tokens[position] ~= close_parenthesis_byte then
		data = deepDel(data)
		return nil
	end
	
	return position+1, data
end

local quotes = {
	[single_quote_byte] = true,
	[double_quote_byte] = true,
}

function STRING(tokens, position)
	local c = tokens[position]
	if not quotes[c] then
		return nil
	end
	local t = newList()
	local lastEscape = false
	local i = position
	while i < #tokens do
		i = i + 1
		local v = tokens[i]
		if v == backslash_byte then
			if lastEscape then
				lastEscape = false
				t[#t+1] = backslash_byte
			else
				lastEscape = true
			end
		elseif v == c then
			if lastEscape then
				lastEscape = false
				t[#t+1] = c
			else
				return i+1, newList(string_char(c), tokenListToString(t))
			end
		else
			if lastEscape then
				lastEscape = false
				if v >= zero_byte and v <= nine_byte then
					local num = v - zero_byte
					if tokens[i+1] and tokens[i+1] >= zero_byte and tokens[i+1] <= nine_byte then
						num = num*10 + tokens[i+1] - zero_byte
						if tokens[i+2] and tokens[i+2] >= zero_byte and tokens[i+2] <= nine_byte then
							num = num*10 + tokens[i+2] - zero_byte
							i = i + 1
						end
						i = i + 1
					end
					t[#t+1] = num
				elseif v == n_byte then
					t[#t+1] = newline_byte
				else
					t[#t+1] = backslash_byte
					t[#t+1] = v
				end
			else
				t[#t+1] = v
			end
		end
	end
	t = del(t)
	return nil
end

function NUMBER(tokens, position)
	local pos, number = SIGNED_INTEGER(tokens, position)
	if not pos then
		return nil
	end
	
	local c = tokens[pos]
	if c == period_byte then
		local pos2, num = MULTI_DIGIT(tokens, pos+1)
		if pos2 then
			local negative = number < 0
			if negative then
				number = -number
			end
			for i = 1, #num do
				number = number + (10^-i)*(string_byte(num, i) - zero_byte)
			end
			if negative then
				number = -number
			end
			return pos2, number
		end
	elseif c == e_byte or lower[c] == e_byte then
		local pos2, n = SIGNED_INTEGER(tokens, pos+1)
		if pos2 then
			return pos2, number * 10^(n+0)
		end
	end
	return pos, number
end

function SIGNED_INTEGER(tokens, position)
	local c = tokens[position]
	if c == minus_byte then
		local pos, number = MULTI_DIGIT(tokens, position+1)
		if pos then
			return pos, 0-number
		else
			return nil
		end
	else
		local pos, number = MULTI_DIGIT(tokens, position)
		if pos then
			return pos, 0+number
		else
			return nil
		end
	end
end

function ALPHANUM(tokens, position)
	local c = tokens[position]
	if not c or ((c < A_byte or c > Z_byte) and (c < a_byte or c > z_byte) and c ~= underscore_byte) then
		return nil
	end
	local t = newList(c)
	position = position + 1
	while true do
		local c = tokens[position]
		if c and ((c >= zero_byte and c <= nine_byte) or (c >= A_byte and c <= Z_byte) or (c >= a_byte and c <= z_byte) or c == underscore_byte) then
			t[#t+1] = c
		else
			return position, tokenListToString(t)
		end
		position = position + 1
	end
end

function MULTI_DIGIT(tokens, position)
	local c = tokens[position]
	if not c or c < zero_byte or c > nine_byte then
		return nil
	end
	local t = newList(c)
	position = position + 1
	while true do
		local c = tokens[position]
		if c and c >= zero_byte and c <= nine_byte then
			t[#t+1] = c
		else
			return position, tokenListToString(t)
		end
		position = position + 1
	end
end

function MULTI_SPACE(tokens, position)
	while true do
		local pos = SPACE(tokens, position)
		if pos then
			position = pos
		else
			return position
		end
	end
end

local spaces = {
	[(' '):byte()] = true,
	[('\t'):byte()] = true,
	[('\n'):byte()] = true,
	[('\r'):byte()] = true,
}

function SPACE(tokens, position)
	local c = tokens[position]
	if spaces[c] then
		return position+1
	else
		return nil
	end
end

--[[
IF_STATEMENT        = COMPARISON, [ MULTI_SPACE, "?", MULTI_SPACE, IF_STATEMENT, [ MULTI_SPACE, "!", MULTI_SPACE, IF_STATEMENT ] ]
                    | "if", MULTI_SPACE, IF_STATEMENT, MULTI_SPACE, "then", MULTI_SPACE, IF_STATEMENT, { MULTI_SPACE, "elseif" MULTI_SPACE, IF_STATEMENT, MULTI_SPACE, "then" MULTI_SPACE, IF_STATEMENT, } [ MULTI_SPACE, "else", MULTI_SPACE, IF_STATEMENT, [ "end" ] ]
]]


function IF_STATEMENT(tokens, position)
	if matches(tokens, position, "if") then
		position = MULTI_SPACE(tokens, position+2)
		local position, data = COMPARISON(tokens, position)
		if not position then
			return nil
		end
		position = MULTI_SPACE(tokens, position)
		if not matches(tokens, position, "then") then
			data = deepDel(data)
			return nil
		end
		position = MULTI_SPACE(tokens, position+4)
		local position, d = IF_STATEMENT(tokens, position)
		if not position then
			data = deepDel(data)
			return nil
		end
		data = newList("if", data, d)
		
		local currentData = data
		while true do
			local pos = MULTI_SPACE(tokens, position)
			if matches(tokens, pos, "elseif") then
				pos = MULTI_SPACE(tokens, pos+6)
		
				pos, d = IF_STATEMENT(tokens, pos)
				if not pos then
					return position, data
				end
				pos = MULTI_SPACE(tokens, pos)
		
				if not matches(tokens, pos, "then") then
					return position, data
				end
				pos = MULTI_SPACE(tokens, pos+4)
		
				local e
				pos, e = IF_STATEMENT(tokens, pos)
				if not pos then
					return position, data
				end
				position = pos
				currentData[4] = newList("if", d, e)
				currentData = currentData[4]
			else
				break
			end
		end
		
		local pos = MULTI_SPACE(tokens, position)
		
		if matches(tokens, pos, "else") then
			pos = MULTI_SPACE(tokens, pos+4)

			pos, d = IF_STATEMENT(tokens, pos)
			if not pos then
				return position, data
			end
			position = pos
			currentData[4] = d
		end
		
		pos = MULTI_SPACE(tokens, position)

		if matches(tokens, pos, "end") then
			return pos+3, data
		else
			return position, data
		end
	else
		local position, data = COMPARISON(tokens, position)
		if not position then
			return nil
		end
	
		local pos = MULTI_SPACE(tokens, position)
	
		if tokens[pos] ~= question_mark_byte then
			return position, data
		end
	
		pos = MULTI_SPACE(tokens, pos+1)
	
		local pos, d = IF_STATEMENT(tokens, pos)
		if not pos then
			return position, data
		end
		position = pos
		data = newList("?", data, d)
		
		pos = MULTI_SPACE(tokens, pos)
	
		if tokens[pos] ~= exclamation_point_byte then
			return position, data
		end
	
		pos = MULTI_SPACE(tokens, pos+1)
		
		pos, d = IF_STATEMENT(tokens, pos)
		if not pos then
			return position, data
		end
		position = pos
		data[4] = d
	
		return position, data
	end
end

function COMPARISON(tokens, position)
	local position, data = LOGIC(tokens, position)
	if not position then
		return nil
	end
	
	while true do
		local pos = MULTI_SPACE(tokens, position)
		local c = tokens[pos]
		local op
		if c == left_angle_byte then
			if tokens[pos+1] == equals_byte then
				op = "<="
				pos = pos+1
			else
				op = "<"
			end
		elseif c == right_angle_byte then
			if tokens[pos+1] == equals_byte then
				op = ">="
				pos = pos+1
			else
				op = ">"
			end
		elseif c == equals_byte then
			op = "="
		elseif c == tilde_byte then
			if tokens[pos+1] ~= equals_byte then
				break
			end
			pos = pos+1
			op = "~="
		else
			break
		end
		pos = MULTI_SPACE(tokens, pos+1)
		local pos, chunk = LOGIC(tokens, pos)
		if not pos then
			break
		end
		position = pos
		data = newList(op, data, chunk)
	end
	
	return position, data
end

function LOGIC(tokens, position)
	local position, data = CONCATENATION(tokens, position)
	if not position then
		return nil
	end
	
	while true do
		local pos = MULTI_SPACE(tokens, position)
		local op = tokens[pos]
		if matches(tokens, pos, "and") then
			op = "and"
		elseif matches(tokens, pos, "or") then
			op = "or"
		elseif op == ampersand_byte then
			op = "&"
		elseif matches(tokens, pos, "||") then
			op = "||"
		elseif op == pipe_byte then
			op = "|"
		else
			break
		end
		pos = MULTI_SPACE(tokens, pos+op:len())
		if op == "||" then
			op = "|"
		end
		local pos, chunk = CONCATENATION(tokens, pos)
		if not pos then
			break
		end
		position = pos
		data = newList(op, data, chunk)
	end
	
	return position, data
end

local function flattenConcatenation(ast)
	local newAst = newList()
	newAst[1] = "concat"
	for i = 2, #ast do
		local v = ast[i]
		if type(v) == "table" and v[1] == "concat" then
			flattenConcatenation(v)
			for i = 2, #v do
				newAst[#newAst+1] = v[i]
			end
			v = del(v)
		else
			newAst[#newAst+1] = v
		end
	end
	for k in pairs(ast) do
		ast[k] = nil
	end
	for k, v in pairs(newAst) do
		ast[k] = v
	end
	newAst = del(newAst)
end

function CONCATENATION(tokens, position)
	local position, data = ADDITION(tokens, position)
	if not position then
		return nil
	end
	
	local list
	
	while true do
		local pos = SPACE(tokens, position)
		if not pos then
			break
		end
		pos = MULTI_SPACE(tokens, pos)
		local pos, chunk = ADDITION(tokens, pos)
		if not pos then
			break
		end
		position = pos
		if list then
			list[#list+1] = chunk
		else
			list = newList("concat", data, chunk)
		end
	end
	
	if list then
		flattenConcatenation(list)
	end
	
	return position, list or data
end

-- ADDITION            = MULTIPLICATION, { SPACE, MULTI_SPACE, "-", MULTIPLICATION | MULTI_SPACE, ( "+" | "-" ), MULTI_SPACE, MULTIPLICATION }
function ADDITION(tokens, position)
	local position, data = MULTIPLICATION(tokens, position)
	if not position then
		return nil
	end
	
	while true do
		local pos = SPACE(tokens, position)
		local pass
		if pos then
			pos = MULTI_SPACE(tokens, pos)
			if tokens[pos] == minus_byte then
				local data2
				pass, data2 = MULTIPLICATION(tokens, pos+1)
				if pass then
					position = pass
					if type(data2) == "number" then
						data2 = -data2
					else
						data2 = newList("unm", data2)
					end
					data = newList("concat", data, data2)
				end
			end
		end
		if not pass then
			local pos = MULTI_SPACE(tokens, position)
			local op = tokens[pos]
			if op == plus_byte then
				op = "+"
			elseif op == minus_byte then
				op = "-"
			else
				break
			end
			pos = MULTI_SPACE(tokens, pos+1)
			local pos, chunk = MULTIPLICATION(tokens, pos)
			if not pos then
				break
			end
			position = pos
			data = newList(op, data, chunk)
		end
	end
	
	return position, data
end

function MULTIPLICATION(tokens, position)
	local position, data = NEGATION(tokens, position)
	if not position then
		return nil
	end
	
	while true do
		local pos = MULTI_SPACE(tokens, position)
		local op = tokens[pos]
		if op == asterix_byte then
			op = "*"
		elseif op == slash_byte then
			op = "/"
		elseif op == percent_byte then
			op = "%"
		else
			break
		end
		pos = MULTI_SPACE(tokens, pos+1)
		local pos, chunk = NEGATION(tokens, pos)
		if not pos then
			break
		end
		position = pos
		data = newList(op, data, chunk)
	end
	
	return position, data
end

function NEGATION(tokens, position)
	local nots = newList()
	while true do
		local op
		if matches(tokens, position, "not") then
			op = "not"
		elseif tokens[position] == tilde_byte then
			op = "~"
		else
			local data
			position, data = EXPONENTIATION(tokens, position)
			if not position then
				nots = del(nots)
				return nil
			end
			for i = #nots, 1, -1 do
				data = newList(nots[i], data)
			end
			nots = del(nots)
			return position, data
		end
		
		nots[#nots+1] = op
		
		position = MULTI_SPACE(tokens, position+op:len())
	end
end

function EXPONENTIATION(tokens, position)
	local position, data = CHUNK_WITH_MODIFIER(tokens, position)
	if not position then
		return nil
	end
	
	while true do
		local pos = MULTI_SPACE(tokens, position)
		local op = tokens[pos]
		if op ~= carat_byte then
			break
		end
		pos = MULTI_SPACE(tokens, pos+1)
		local pos, chunk = CHUNK_WITH_MODIFIER(tokens, pos)
		if not pos then
			break
		end
		position = pos
		data = newList("^", data, chunk)
	end
	
	return position, data
end


local function parse(code)
	if code == "" then
		return newList("nil")
	end
	local tokens = stringToTokenList(code)
	local ast = DOGTAG(tokens)
	tokens = del(tokens)
	return ast
end
DogTag.parse = parse

local standardizations = {
	['mod'] = 'tag',
	['?'] = 'if',
	['&'] = 'and',
	['|'] = 'or',
	['~'] = 'not',
	['false'] = 'nil',
}

local function standardize(ast)
	local type_ast = type(ast)
	if type_ast == "table" then
		if ast[1] == "'" or ast[1] == '"' then
			local ast_2 = ast[2]
			ast = del(ast)
			ast = ast_2
			type_ast = 'string'
		end
	end
	if type_ast ~= "table" then
--		if type_ast == "string" and DogTag.__mytonumber(ast) and not ast:match("e") then
--			return ast+0
--		end
		return ast
	end
	
	local kind = ast[1]
	
	if kind == "(" or kind == "[" then
		local ast_2 = ast[2]
		ast_2 = standardize(ast_2)
		del(ast)
		return ast_2
	elseif kind == "true" then
		del(ast)
		return L["True"]
	else
		ast[1] = standardizations[kind] or kind
	
		for i = 2, #ast do
			ast[i] = standardize(ast[i])
		end
		local kwarg = ast.kwarg
		if kwarg then
			for k,v in pairs(kwarg) do
				kwarg[k] = standardize(v, kwarg)
			end
		end
	end
	
	return ast
end
DogTag.standardize = standardize

local orderOfOperations = {
	"GROUPING",
	"MODIFIER",
	"UNARY_MINUS",
	"EXPONENTIATION",
	"NEGATION",
	"MULTIPLICATION",
	"ADDITION",
	"CONCATENATION",
	"LOGIC",
	"COMPARISON",
	"IF_STATEMENT",
}
do
	local tmp = orderOfOperations
	orderOfOperations = newList()
	for i,v in ipairs(tmp) do
		orderOfOperations[v] = i
	end
	tmp = del(tmp)
end

local operators = {
	["+"] = "ADDITION",
	["-"] = "ADDITION",
	["*"] = "MULTIPLICATION",
	["/"] = "MULTIPLICATION",
	["%"] = "MULTIPLICATION",
	["^"] = "EXPONENTIATION",
	["<"] = "COMPARISON",
	[">"] = "COMPARISON",
	["<="] = "COMPARISON",
	[">="] = "COMPARISON",
	["="] = "COMPARISON",
	["~="] = "COMPARISON",
	["and"] = "LOGIC",
	["or"] = "LOGIC",
	["&"] = "LOGIC",
	["||"] = "LOGIC",
	["mod"] = "MODIFIER",
	["tag"] = "MODIFIER",
	["kwarg"] = "MODIFIER",
	["string"] = "MODIFIER",
	["number"] = "MODIFIER",
	["concat"] = "CONCATENATION",
	["~"] = "NEGATION",
	["not"] = "NEGATION",
	["if"] = "IF_STATEMENT",
	["?"] = "IF_STATEMENT",
	["unm"] = "UNARY_MINUS",
	["("] = "GROUPING",
	["["] = "GROUPING",
}
for k,v in pairs(operators) do
	operators[k] = orderOfOperations[v]
end

local function getKind(ast)
	local type_ast = type(ast)
	if type_ast ~= "table" then
		return type_ast
	else
		return ast[1]
	end
end

local colors = {
	tag = "00ffff", -- cyan
	number = "ff7f7f", -- pink
	modifier = "00ff00", -- green
	literal = "ff7f7f", -- pink
	operator = "ff7fff", -- fuchsia
	grouping = "ffffff", -- white
	kwarg = "ff0000", -- red
	result = "ffffff", -- white
}

local function getLiteralString(str, doubleQuote)
	local quote_byte = doubleQuote and double_quote_byte or single_quote_byte
	local data = newList(str:byte(1, #str))
	local t = newList()
	t[#t+1] = quote_byte
	local i = 1
	while i <= #data do
		local v = data[i]
		if v == quote_byte then
			t[#t+1] = backslash_byte
			t[#t+1] = quote_byte
		elseif v == newline_byte then
			t[#t+1] = backslash_byte
			t[#t+1] = n_byte
		elseif v == pipe_byte and data[i+1] == pipe_byte then
			t[#t+1] = pipe_byte
			t[#t+1] = pipe_byte
			i = i + 1
		elseif v < 32 or v > 128 or v == pipe_byte then
			t[#t+1] = backslash_byte
			local a, b, c = math.floor(v / 100), math.floor((v % 100) / 10), v % 10
			t[#t+1] = a + zero_byte
			t[#t+1] = b + zero_byte
			t[#t+1] = c + zero_byte
		else
			t[#t+1] = v
		end
		i = i + 1
	end
	t[#t+1] = quote_byte
	data = del(data)
	return tokenListToString(t)
end

local function unparse(ast, t, inner, negated, parent_type_ast, indent)
	if not indent then
		indent = 0
	end
	local parentOperatorPrecedence = operators[parent_type_ast]
	local type_ast = getKind(ast)
	if type_ast == "|" then
		type_ast = "||"
	end
	if type_ast == "string" or type_ast == "'" or type_ast == '"' then
		local data = ast
		if type_ast ~= "string" then
			data = ast[2]
		end
		if not inner and not data:match("[%[%]]") then
			if t then
				t[#t+1] = data
				return
			else
				return data
			end
		else
			local doubleQuote
			if data:match('"') and not data:match("'") then
				doubleQuote = false
			elseif data:match("'") and not data:match('"') then
				doubleQuote = true
			elseif type_ast == "'" then
				doubleQuote = false
			else
				doubleQuote = true
			end
			local str = getLiteralString(data, doubleQuote)
			if not inner then
				str = "[" .. str .. "]"
			end
			if t then
				t[#t+1] = str
				return
			else
				return str
			end
		end
	elseif type_ast == "number" then
		if t then
			t[#t+1] = ast
			return
		else
			return tostring(ast)
		end
	elseif type_ast == "nil" then
		if t then
			if not inner then
				return
			else
				t[#t+1] = "nil"
				return
			end
		else
			if not inner then
				return ""
			else
				return "nil"
			end
		end
	elseif type_ast == "true" or type_ast == "false" then
		if t then
			if not inner then
				t[#t+1] = "["
			end	
			t[#t+1] = type_ast
			if not inner then
				t[#t+1] = "]"
			end
			return
		else
			if not inner then
				return ("[%s]"):format(type_ast)
			else
				return type_ast
			end
		end
	end
	local madeT = not t
	if madeT then
		t = newList()
	end
	
	local operators_type_ast = operators[type_ast]
	if not operators_type_ast then
		_G.error(("Unknown operator: %q"):format(type_ast))
	end
	local manualGrouping = false
	if inner and parentOperatorPrecedence then
		if parentOperatorPrecedence == operators_type_ast then
			if type_ast ~= parent_type_ast and (type_ast == "&" or type_ast == "and" or type_ast == "||" or type_ast == "or") then
				manualGrouping = true
			end
		else
			manualGrouping = parentOperatorPrecedence < operators_type_ast
		end
	end
	if type_ast == "concat" then
		if inner then
			if manualGrouping then
				t[#t+1] = "("
			end
			unparse(ast[2], t, true, false, type_ast, indent)
			for i = 3, #ast do
				t[#t+1] = " "
				unparse(ast[i], t, true, false, type_ast, indent)
			end
			if manualGrouping then
				t[#t+1] = ")"
			end
		else
			local need_to_do_last = false
			local bracket_open = false
			for i = 2, #ast do
				if type(ast[i]) == "string" then
					if need_to_do_last then
						if bracket_open then
							t[#t+1] = " "
							unparse(ast[i-1], t, true, false, type_ast, indent)
							t[#t+1] = "]"
							bracket_open = false
						else
							unparse(ast[i-1], t, false, false, type_ast, indent)
						end
					end
					unparse(ast[i], t, false, false, type_ast, indent)
					need_to_do_last = false
				else
					if need_to_do_last then
						if bracket_open then
							if type(ast[i-2]) == "table" and ast[i-2][1] == "tag" and (ast[i-2][2] == "Alpha" or ast[i-2][2] == "Outline" or ast[i-2][2] == "ThickOutline") then
								t[#t+1] = "]["
							else
								t[#t+1] = " "
							end
						else
							t[#t+1] = "["
							bracket_open = true
						end
						unparse(ast[i-1], t, true, false, type_ast, indent)
					end
					need_to_do_last = true
				end
			end
			if need_to_do_last then
				if bracket_open then
					if type(ast[#ast-1]) == "table" and ast[#ast-1][1] == "tag" and (ast[#ast-1][2] == "Alpha" or ast[#ast-1][2] == "Outline" or ast[#ast-1][2] == "ThickOutline") then
						t[#t+1] = "]["
					else
						t[#t+1] = " "
					end
					unparse(ast[#ast], t, true, false, type_ast, indent)
					t[#t+1] = "]"
				else
					unparse(ast[#ast], t, false, false, type_ast, indent)
				end
			end
		end
	else
		if not inner then
			t[#t+1] = "["
		end
		if manualGrouping then
			t[#t+1] = "("
		end
		if groupings[type_ast:byte()] then
			t[#t+1] = type_ast
			unparse(ast[2], t, true, false, nil, indent)
			t[#t+1] = string_char(groupings[type_ast:byte()])
		elseif type_ast == "kwarg" then
			t[#t+1] = ast[2]
		elseif type_ast == "tag" then
			if negated then
				t[#t+1] = '~'
			end
			t[#t+1] = ast[2]
			if ast[3] or ast.kwarg then
				t[#t+1] = '('
				local first = true
				for i = 3, #ast do
					if not first then
						t[#t+1] = ', '
					end
					first = false
					unparse(ast[i], t, true, false, nil, indent)
				end
				if ast.kwarg then
					local keys = newList()
					for k in pairs(ast.kwarg) do
						keys[#keys+1] = k
					end
					table_sort(keys)
					for _,k in ipairs(keys) do
						if not first then
							t[#t+1] = ', '
						end
						first = false
						t[#t+1] = k
						t[#t+1] = '='
						unparse(ast.kwarg[k], t, true, false, nil, indent)
					end
					keys = del(keys)
				end
				t[#t+1] = ')'
			end
		elseif type_ast == "mod" then
			unparse(ast[3], t, true, false, type_ast, indent)
			t[#t+1] = ':'
			if negated then
				t[#t+1] = '~'
			end
			t[#t+1] = ast[2]
			if ast[4] or ast.kwarg then
				t[#t+1] = '('
				local first = true
				for i = 4, #ast do
					if not first then
						t[#t+1] = ', '
					end
					first = false
					unparse(ast[i], t, true, false, nil, indent)
				end
				if ast.kwarg then
					local keys = newList()
					for k in pairs(ast.kwarg) do
						keys[#keys+1] = k
					end
					table_sort(keys)
					for _,k in ipairs(keys) do
						if not first then
							t[#t+1] = ', '
						end
						first = false
						t[#t+1] = k
						t[#t+1] = '='
						unparse(ast.kwarg[k], t, true, false, nil, indent)
					end
					keys = del(keys)
				end
				t[#t+1] = ')'
			end
		elseif type_ast == "~" then
			if type(ast[2]) == "table" and (ast[2][1] == "tag" or ast[2][1] == "mod") then
				unparse(ast[2], t, true, true, type_ast, indent)
			else
				t[#t+1] = '~'
				unparse(ast[2], t, true, false, type_ast, indent)
			end
		elseif type_ast == "not" then
			t[#t+1] = 'not '
			unparse(ast[2], t, true, false, type_ast, indent)
		elseif type_ast == "?" then
			unparse(ast[2], t, true, false, type_ast, indent)
			t[#t+1] = ' ? '
			unparse(ast[3], t, true, false, type_ast, indent)
			if ast[4] then
				t[#t+1] = ' ! '
				unparse(ast[4], t, true, false, type_ast, indent)
			end
		elseif type_ast == "if" then
			t[#t+1] = 'if '
			unparse(ast[2], t, true, false, type_ast, indent)
			t[#t+1] = ' then'
			t[#t+1] = '\n'
			for i = 1, indent+1 do
				t[#t+1] = '    '
			end
			unparse(ast[3], t, true, false, type_ast, indent+1)
			if ast[4] then
				t[#t+1] = '\n'
				for i = 1, indent do
					t[#t+1] = '    '
				end
				t[#t+1] = 'else'
				if getKind(ast[4]) == "if" then
					unparse(ast[4], t, true, false, type_ast, indent)
				else
					t[#t+1] = '\n'
					for i = 1, indent+1 do
						t[#t+1] = '    '
					end
					unparse(ast[4], t, true, false, type_ast, indent+1)
					t[#t+1] = '\n'
					for i = 1, indent do
						t[#t+1] = '    '
					end
					t[#t+1] = 'end'
				end
			else
				t[#t+1] = '\n'
				for i = 1, indent do
					t[#t+1] = '    '
				end
				t[#t+1] = 'end'
			end
		elseif type_ast == "unm" then
			t[#t+1] = "-"
			unparse(ast[2], t, true, false, type_ast, indent)
		elseif operators_type_ast then
			unparse(ast[2], t, true, false, type_ast, indent)
			t[#t+1] = ' '
			t[#t+1] = type_ast
			t[#t+1] = ' '
			unparse(ast[3], t, true, false, type_ast, indent)
		end
		if manualGrouping then
			t[#t+1] = ")"
		end
		if not inner then
			t[#t+1] = "]"
		end
	end
	
	if madeT then
		local s = table_concat(t)
		t = del(t)
		return s
	end
end
DogTag.unparse = unparse

local function cleanAST(ast)
	if type(ast) ~= "table" then
		return ast
	end
	
	local astType = ast[1]
	for i = 2, #ast do
		ast[i] = cleanAST(ast[i])
	end
	local kwarg = ast.kwarg
	if kwarg then
		for k,v in pairs(kwarg) do
			kwarg[k] = cleanAST(v)
		end
	end
	if groupings[astType:byte()] then
		local ast_2 = ast[2]
		if type(ast_2) ~= "table" or ast_2[1] == "tag" or ast_2[1] == "mod" or ast_2[1] == "'" or ast_2[1] == '"' then
			del(ast)
			return ast_2
		end
	end
	return ast
end

--[[
Notes:
	This takes a tag sequence that a user can enter and updates it for style purposes.
	e.g. [name] => [Name], [5-12] => [5 - 12]
Arguments:
	string - the tag sequence to check
Returns:
	string - the same tag sequence, corrected for style.
Example:
	local code = LibStub("LibDogTag-3.0"):CleanCode("[name][level]") -- "[Name Level]"
]]
function DogTag:CleanCode(code)
	if type(code) ~= "string" then
		error(("Bad argument #2 to `CleanCode'. Expected %q, got %q"):format("string", type(code)), 2)
	end
	code = code:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
	local ast = parse(code)
	if not ast then
		return code
	end
	ast = cleanAST(ast)
	correctASTCasing(ast)
	local result = unparse(ast)
	ast = deepDel(ast)
	return result
end

local reservedOperators = {
	["if"] = true,
	["then"] = true,
	["else"] = true,
	["elseif"] = true,
	["and"] = true,
	["end"] = true,
	["or"] = true,
	["not"] = true,
	["+"] = true,
	["-"] = true,
	["*"] = true,
	["/"] = true,
	["%"] = true,
	["^"] = true,
	["<"] = true,
	[">"] = true,
	["<="] = true,
	[">="] = true,
	["="] = true,
	["~="] = true,
	["&"] = true,
	["||"] = true,
	["|"] = true,
	["?"] = true,
	["!"] = true,
	["~"] = true,
	[":"] = true,
}
do
	local tmp = newList()
	for k in pairs(reservedOperators) do
		tmp[#tmp+1] = k
		reservedOperators[k] = nil
	end
	table.sort(tmp, function(alpha, bravo)
		if #alpha ~= #bravo then
			return #alpha > #bravo
		else
			return alpha < bravo
		end
	end)
	for i, v in ipairs(tmp) do
		reservedOperators[i] = v
	end
	tmp = del(tmp)
end

--[[
Notes:
	This colorizes a tag sequence by syntax to make it easier to understand.
	This does not correct casing or change whitespace, merely adds tags.
Arguments:
	string - the tag sequence to check
Returns:
	string - the same tag sequence, with colors applied.
Example:
	local code = LibStub("LibDogTag-3.0"):ColorizeCode("[Name] [5 + 17]")
]]
function DogTag:ColorizeCode(code)
	if type(code) ~= "string" then
		error(("Bad argument #2 to `ColorizeCode'. Expected %q, got %q"):format("string", type(code)), 2)
	end
	code = code:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
	local tokens = stringToTokenList(code)
	local t = newList()
	t[#t+1] = "|cff"
	t[#t+1] = colors.literal
	local inCode = 0
	local inString = false
	local lastStringBackslash = false
	local i = 0
	local num_tokens = #tokens
	local lastChar
	while i < num_tokens do
		i = i + 1
		local v = tokens[i]
		if inString then
			if v == inString and not lastStringBackslash then
				inString = false
				t[#t+1] = string_char(v)
			else
				t[#t+1] = string_char(v)
			end
		elseif v == open_bracket_byte then
			t[#t+1] = "|cff"
			t[#t+1] = colors.grouping
			t[#t+1] = "["
			inCode = inCode + 1
		elseif v == close_bracket_byte then
			t[#t+1] = "|cff"
			t[#t+1] = colors.grouping
			t[#t+1] = "]"
			inCode = inCode - 1
			if inCode == 0 then
				t[#t+1] = "|cff"
				t[#t+1] = colors.literal
			end
		elseif inCode <= 0 then
			t[#t+1] = string_char(v)
		elseif v == open_parenthesis_byte then
			t[#t+1] = "|cff"
			t[#t+1] = colors.grouping
			t[#t+1] = "("
		elseif v == close_parenthesis_byte then
			t[#t+1] = "|cff"
			t[#t+1] = colors.grouping
			t[#t+1] = ")"
		elseif v == comma_byte then
			t[#t+1] = "|cff"
			t[#t+1] = colors.grouping
			t[#t+1] = ","
		elseif quotes[v] then
			t[#t+1] = "|cff"
			t[#t+1] = colors.literal
			t[#t+1] = string_char(v)
			inString = v
		elseif spaces[v] then
			t[#t+1] = string_char(v)
		else
			local isReserved = false
			for _, r in ipairs(reservedOperators) do
				if matches(tokens, i, r) then
					isReserved = r
					break
				end
			end
			if isReserved then
				t[#t+1] = "|cff"
				t[#t+1] = colors.operator
				t[#t+1] = isReserved
				i = i + #isReserved - 1
			else
				local j = i
				local x = tokens[j]
				while x and ((x >= A_byte and x <= Z_byte) or (x >= a_byte and x <= z_byte)) do
					j = j + 1
					x = tokens[j]
				end
				j = j - 1
				if j >= i then
					t[#t+1] = "|cff"
					if (lastChar == open_parenthesis_byte or lastChar == comma_byte) and tokens[j+1] == equals_byte then
						t[#t+1] = colors.kwarg
					elseif lastChar == colon_byte then
						t[#t+1] = colors.modifier
					else
						t[#t+1] = colors.tag
					end
					for q = i, j do
						t[#t+1] = string_char(tokens[q])
					end
					i = j
				else
					j = i
					x = tokens[j]
					local hitPeriod, hitE = false, false
					while x and ((x >= zero_byte and x <= nine_byte) or (not hitPeriod and not hitE and x == period_byte) or (not hitE and x == e_byte)) do
						if x == period_byte then
							hitPeriod = true
						elseif x == e_byte then
							hitE = true
						end
						j = j + 1
						x = tokens[j]
					end
					j = j - 1
					if j >= i then
						t[#t+1] = "|cff"
						t[#t+1] = colors.number
						for q = i, j do
							t[#t+1] = string_char(tokens[q])
						end
						i = j
					else
						t[#t+1] = string_char(v)
					end
				end
			end
		end
		if not spaces[v] then
			lastChar = tokens[i]
		end
	end
	t[#t+1] = "|r"
	tokens = del(tokens)
	local s = table.concat(t)
	s = s:gsub("|c%x%x%x%x%x%x%x%x(|[cr])", "%1")
	if s == "|r" then
		s = ""
	end
	t = del(t)
	return s
end

end
