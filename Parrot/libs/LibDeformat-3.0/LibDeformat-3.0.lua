--[[
Name: LibDeformat-3.0
Author(s): ckknight (ckknight@gmail.com)
Website: http://www.wowace.com/projects/libdeformat-3-0/
Description: A library to convert a post-formatted string back to its original arguments given its format string.
License: MIT
]]

local LibDeformat = LibStub:NewLibrary("LibDeformat-3.0", 1)

if not LibDeformat then
    return
end

-- this function does nothing and returns nothing
local function do_nothing()
end

-- a dictionary of format to match entity
local FORMAT_SEQUENCES = {
    ["s"] = ".+",    
    ["c"] = ".",
    ["%d*d"] = "%%-?%%d+",
    ["[fg]"] = "%%-?%%d+%%.?%%d*",
    ["%%%.%d[fg]"] = "%%-?%%d+%%.?%%d*",
}

-- a set of format sequences that are string-based, i.e. not numbers.
local STRING_BASED_SEQUENCES = {
    ["s"] = true,
    ["c"] = true,
}

local cache = setmetatable({}, {__mode='k'})
-- generate the deformat function for the pattern, or fetch from the cache.
local function get_deformat_function(pattern)
    local func = cache[pattern]
    if func then
        return func
    end
    
    -- escape the pattern, so that string.match can use it properly
    local unpattern = '^' .. pattern:gsub("([%(%)%.%*%+%-%[%]%?%^%$%%])", "%%%1") .. '$'
    
    -- a dictionary of index-to-boolean representing whether the index is a number rather than a string.
    local number_indexes = {}
    
    -- (if the pattern is a numbered format,) a dictionary of index-to-real index.
    local index_translation = nil
    
    -- the highest found index, also the number of indexes found.
	local highest_index
    if not pattern:find("%%1%$") then
        -- not a numbered format
        
        local i = 0
        while true do
            i = i + 1
            local first_index
            local first_sequence
            for sequence in pairs(FORMAT_SEQUENCES) do
                local index = unpattern:find("%%%%" .. sequence)
                if index and (not first_index or index < first_index) then
                    first_index = index
                    first_sequence = sequence
                end
            end
            if not first_index then
                break
            end
            unpattern = unpattern:gsub("%%%%" .. first_sequence, "(" .. FORMAT_SEQUENCES[first_sequence] .. ")", 1)
            number_indexes[i] = not STRING_BASED_SEQUENCES[first_sequence]
        end
        
        highest_index = i - 1
    else
        -- a numbered format
        
        local i = 0
		while true do
		    i = i + 1
			local found_sequence
            for sequence in pairs(FORMAT_SEQUENCES) do
				if unpattern:find("%%%%" .. i .. "%%%$" .. sequence) then
					found_sequence = sequence
					break
				end
			end
			if not found_sequence then
				break
			end
			unpattern = unpattern:gsub("%%%%" .. i .. "%%%$" .. found_sequence, "(" .. FORMAT_SEQUENCES[found_sequence] .. ")", 1)
			number_indexes[i] = not STRING_BASED_SEQUENCES[found_sequence]
		end
        highest_index = i - 1
		
		i = 0
		index_translation = {}
		pattern:gsub("%%(%d)%$", function(w)
		    i = i + 1
		    index_translation[i] = tonumber(w)
		end)
    end
    
    if highest_index == 0 then
        cache[pattern] = do_nothing
    else
        --[=[
            -- resultant function looks something like this:
            local unpattern = ...
            return function(text)
                local a1, a2 = text:match(unpattern)
                if not a1 then
                    return nil, nil
                end
                return a1+0, a2
            end
            
            -- or if it were a numbered pattern,
            local unpattern = ...
            return function(text)
                local a2, a1 = text:match(unpattern)
                if not a1 then
                    return nil, nil
                end
                return a1+0, a2
            end
        ]=]
        
        local t = {}
        t[#t+1] = [=[
            return function(text)
                local ]=]
        
        for i = 1, highest_index do
            if i ~= 1 then
                t[#t+1] = ", "
            end
            t[#t+1] = "a"
            if not index_translation then
                t[#t+1] = i
            else
                t[#t+1] = index_translation[i]
            end
        end
        
        t[#t+1] = [=[ = text:match(]=]
        t[#t+1] = ("%q"):format(unpattern)
        t[#t+1] = [=[)
                if not a1 then
                    return ]=]
        
        for i = 1, highest_index do
            if i ~= 1 then
                t[#t+1] = ", "
            end
            t[#t+1] = "nil"
        end
        
        t[#t+1] = "\n"
        t[#t+1] = [=[
                end
                ]=]
        
        t[#t+1] = "return "
        for i = 1, highest_index do
            if i ~= 1 then
                t[#t+1] = ", "
            end
            t[#t+1] = "a"
            t[#t+1] = i
            if number_indexes[i] then
                t[#t+1] = "+0"
            end
        end
        t[#t+1] = "\n"
        t[#t+1] = [=[
            end
        ]=]
        
        t = table.concat(t, "")
        
        -- print(t)
        
        cache[pattern] = assert(loadstring(t))()
    end
    
    return cache[pattern]
end

--- Return the arguments of the given format string as found in the text.
-- @param text The resultant formatted text.
-- @param pattern The pattern used to create said text.
-- @return a tuple of values, either strings or numbers, based on the pattern.
-- @usage LibDeformat.Deformat("Hello, friend", "Hello, %s") == "friend"
-- @usage LibDeformat.Deformat("Hello, friend", "Hello, %1$s") == "friend"
-- @usage LibDeformat.Deformat("Cost: $100", "Cost: $%d") == 100
-- @usage LibDeformat.Deformat("Cost: $100", "Cost: $%1$d") == 100
-- @usage LibDeformat.Deformat("Alpha, Bravo", "%s, %s") => "Alpha", "Bravo"
-- @usage LibDeformat.Deformat("Alpha, Bravo", "%1$s, %2$s") => "Alpha", "Bravo"
-- @usage LibDeformat.Deformat("Alpha, Bravo", "%2$s, %1$s") => "Bravo", "Alpha"
-- @usage LibDeformat.Deformat("Hello, friend", "Cost: $%d") == nil
-- @usage LibDeformat("Hello, friend", "Hello, %s") == "friend"
function LibDeformat.Deformat(text, pattern)
    if type(text) ~= "string" then
        error(("Argument #1 to `Deformat' must be a string, got %s (%s)."):format(type(text), text), 2)
    elseif type(pattern) ~= "string" then
        error(("Argument #2 to `Deformat' must be a string, got %s (%s)."):format(type(pattern), pattern), 2)
    end
    
    return get_deformat_function(pattern)(text)
end

--[===[@debug@
function LibDeformat.Test()
    local function tuple(success, ...)
        if success then
            return true, { n = select('#', ...), ... }
        else
            return false, ...
        end
    end
    
    local function check(text, pattern, ...)
        local success, results = tuple(pcall(LibDeformat.Deformat, text, pattern))
        if not success then
            return false, results
        end
        
        if select('#', ...) ~= results.n then
            return false, ("Differing number of return values. Expected: %d. Actual: %d."):format(select('#', ...), results.n)
        end
        
        for i = 1, results.n do
            local expected = select(i, ...)
            local actual = results[i]
            if type(expected) ~= type(actual) then
                return false, ("Return #%d differs by type. Expected: %s (%s). Actual: %s (%s)"):format(type(expected), expected, type(actual), actual)
            elseif expected ~= actual then
                return false, ("Return #%d differs. Expected: %s. Actual: %s"):format(expected, actual)
            end
        end
        
        return true
    end
    
    local function test(text, pattern, ...)
        local success, problem = check(text, pattern, ...)
        if not success then
            print(("Problem with (%q, %q): %s"):format(text, pattern, problem or ""))
        end
    end
    
    test("Hello, friend", "Hello, %s", "friend")
    test("Hello, friend", "Hello, %1$s", "friend")
    test("Cost: $100", "Cost: $%d", 100)
    test("Cost: $100", "Cost: $%1$d", 100)
    test("Alpha, Bravo", "%s, %s", "Alpha", "Bravo")
    test("Alpha, Bravo", "%1$s, %2$s", "Alpha", "Bravo")
    test("Alpha, Bravo", "%2$s, %1$s", "Bravo", "Alpha")
    test("Alpha, Bravo, Charlie, Delta, Echo", "%s, %s, %s, %s, %s", "Alpha", "Bravo", "Charlie", "Delta", "Echo")
    test("Alpha, Bravo, Charlie, Delta, Echo", "%1$s, %2$s, %3$s, %4$s, %5$s", "Alpha", "Bravo", "Charlie", "Delta", "Echo")
    test("Alpha, Bravo, Charlie, Delta, Echo", "%5$s, %4$s, %3$s, %2$s, %1$s", "Echo", "Delta", "Charlie", "Bravo", "Alpha")
    test("Alpha, Bravo, Charlie, Delta, Echo", "%2$s, %3$s, %4$s, %5$s, %1$s", "Echo", "Alpha", "Bravo", "Charlie", "Delta")
    test("Alpha, Bravo, Charlie, Delta, Echo", "%3$s, %4$s, %5$s, %1$s, %2$s", "Delta", "Echo", "Alpha", "Bravo", "Charlie")
    test("Alpha, Bravo, Charlie, Delta", "%s, %s, %s, %s, %s", nil, nil, nil, nil, nil)
    test("Hello, friend", "Cost: $%d", nil)
    print("LibDeformat-3.0: Tests completed.")
end
--@end-debug@]===]

setmetatable(LibDeformat, { __call = function(self, ...) return self.Deformat(...) end })