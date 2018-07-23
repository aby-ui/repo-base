-- -------------------------------------------------------------------------- --
-- BattlegroundTargets utf8.lua                                               --
-- From utf8.lua (c) Kyle Smith                                               --
-- Modified by kunda (utf8replace mapping is used for transliteration)        --
-- -------------------------------------------------------------------------- --

local strbyte, strlen, strsub, strupper, type = string.byte, string.len, string.sub, string.upper, type

-- determine bytes needed for character, based on RFC 3629
local function utf8charbytes(s, i)
	if type(s) ~= "string" then
		error("bad argument #1 to 'utf8charbytes' (string expected, got " .. type(s) .. ")")
	end
	if type(i) ~= "number" then
		error("bad argument #2 to 'utf8charbytes' (number expected, got " .. type(i) .. ")")
	end

	local c = strbyte(s, i)

	if c > 0 and c <= 127 then -- UTF8-1
		return 1
	elseif c >= 194 and c <= 223 then -- UTF8-2
		local c2 = strbyte(s, i + 1)
		if not c2 then
			error("UTF-8 string terminated early")
		end
		if c2 < 128 or c2 > 191 then
			error("Invalid UTF-8 character")
		end
		return 2
	elseif c >= 224 and c <= 239 then -- UTF8-3
		local c2 = strbyte(s, i + 1)
		local c3 = strbyte(s, i + 2)
		if not c2 or not c3 then
			error("UTF-8 string terminated early")
		end
		if c == 224 and (c2 < 160 or c2 > 191) then
			error("Invalid UTF-8 character")
		elseif c == 237 and (c2 < 128 or c2 > 159) then
			error("Invalid UTF-8 character")
		elseif c2 < 128 or c2 > 191 then
			error("Invalid UTF-8 character")
		end
		if c3 < 128 or c3 > 191 then
			error("Invalid UTF-8 character")
		end
		return 3
	elseif c >= 240 and c <= 244 then -- UTF8-4
		local c2 = strbyte(s, i + 1)
		local c3 = strbyte(s, i + 2)
		local c4 = strbyte(s, i + 3)
		if not c2 or not c3 or not c4 then
			error("UTF-8 string terminated early")
		end
		if c == 240 and (c2 < 144 or c2 > 191) then
			error("Invalid UTF-8 character")
		elseif c == 244 and (c2 < 128 or c2 > 143) then
			error("Invalid UTF-8 character")
		elseif c2 < 128 or c2 > 191 then
			error("Invalid UTF-8 character")
		end
		if c3 < 128 or c3 > 191 then
			error("Invalid UTF-8 character")
		end
		if c4 < 128 or c4 > 191 then
			error("Invalid UTF-8 character")
		end
		return 4
	else
		error("Invalid UTF-8 character")
	end
end

-- replace UTF-8 characters based on a mapping table
local _, prg = ...
prg.utf8replace = function(s, mapping)
	if type(s) ~= "string" then
		error("bad argument #1 to 'utf8replace' (string expected, got " .. type(s) .. ")")
	end
	if type(mapping) ~= "table" then
		error("bad argument #2 to 'utf8replace' (table expected, got " .. type(mapping) .. ")")
	end

	local pos = 1
	local bytes = strlen(s)
	local charbytes
	local newstr = ""
	local upval

	while pos <= bytes do
		charbytes = utf8charbytes(s, pos)
		local c = strsub(s, pos, pos + charbytes - 1)
		newstr = newstr .. (mapping[c] or c)
		pos = pos + charbytes
		if not upval and strlen(newstr) > 0 and utf8charbytes(newstr, 1) == 1 then -- uppercase first character
			newstr = strupper(strsub(newstr, 1, 1)) .. strsub(newstr, 2)
			upval = true
		end
	end

	if newstr == "" then newstr = UNKNOWN end
	return newstr
end