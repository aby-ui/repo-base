
local assert, type = assert, type
local GetLocale = GetLocale

local locales = {}

local Locale = tdCore:NewLibrary('Locale', tdCore.Locale, 1)
Locale.__index = function(o, k) return k end

function Locale:New(name, locale)
    assert(type(name) == 'string', 'Bad argument #1 to `New\' (string expected)')
    
    if GetLocale() ~= locale then
        return
    end
    return self:Get(name)
end

function Locale:Get(name)
    assert(type(name) == 'string', 'Bad argument #1 to `Get\' (string expected)')
    
    locales[name] = locales[name] or self:Bind{}
    return locales[name]
end