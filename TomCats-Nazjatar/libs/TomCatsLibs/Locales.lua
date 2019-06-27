local addon = select(2, ...)
local lib = addon.TomCatsLibs.Locales

setmetatable(lib, {
    __index = function(_, key)
        return key
    end
})

function lib.AddLocaleLookup(locale, lookup)
    if (locale == "enUS" or GetLocale() == locale) then
        Mixin(lib, lookup)
    end
end

lib.init = false
