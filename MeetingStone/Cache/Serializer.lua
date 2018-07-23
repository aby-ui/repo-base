-- Serializer.lua
-- @Author : DengSir (tdaddon@163.com)
-- @Link   : https://dengsir.github.io/
-- @Date   : 2018-2-6 10:26:48

BuildEnv(...)

Serializer = Addon:NewClass('Serializer')

local AceSerializer = LibStub('AceSerializer-3.0')
local memorize      = require('NetEaseMemorize-1.0')

local MakeChecker = memorize.normal(function(checker)
    local types = {} do
        for _, v in ipairs({strsplit(',', checker)}) do
            types[v] = true
        end
    end

    return function(value)
        return types[type(value)]
    end
end)

local function Deserialize(self, ok, ...)
    if not ok then
        return false, true
    end
    local len = select('#', ...)
    if len > #self._properties then
        return true, false
    end

    for i, v in ipairs(self._properties) do
        local value = select(i, ...)
        local checker = v.checker

        if not v.checker(value) then
            
            return true, false
        end
        self._args[i] = value
    end
    return true, true
end

function Serializer:Constructor()
    self._args = {}
end

function Serializer:Inherit()
    self._properties = {}
end

function Serializer:Property(key, checker)
    if type(checker) == 'string' then
        checker = MakeChecker(checker)
    elseif type(checker) ~= 'function' then
        error(format('Bad argument #2 to `Property` (string|function expected, got %s)', type(checker)))
    end
    table.insert(self._properties, {
        key = key,
        checker = checker,
    })

    local i = #self._properties

    self['Set' .. key] = function(self, value)
        if not checker(value) then
            return
        end
        self._args[i] = value
    end

    self[key:find('^Is') and key or 'Get' .. key] = function(self)
        return self._args[i]
    end
end

function Serializer:Deserialize(data)
    if data:find('%^[ZBbTt][^^]') then
        
        return
    end
    if data:find('%^%^.') then
        
        return
    end

    local ok, valid = Deserialize(self, AceSerializer:Deserialize(data))
    return ok, valid
end

function Serializer:Serialize()
    return AceSerializer:Serialize(unpack(self._args, 1, #self._properties))
end
