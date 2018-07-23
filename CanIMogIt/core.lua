--[[
    Check http://wow.gamepedia.com/Localizing_an_addon for how this works.
]]

CanIMogIt = LibStub("AceAddon-3.0"):NewAddon("CanIMogIt", "AceConsole-3.0", "AceEvent-3.0")

CanIMogIt.L = CanIMogIt.L or setmetatable({}, {
    __index = function(t, k)
        rawset(t, k, k)
        return k
    end,
    __newindex = function(t, k, v)
        if v == true then
            rawset(t, k, k)
        else
            rawset(t, k, v)
        end
    end,
})


function CanIMogIt:RegisterLocale(locale, tbl)
    if not tbl then return end
    if locale == "enUS" or locale == GetLocale() then
        for k,v in pairs(tbl) do
            if v == true then
                self.L[k] = k
            elseif type(v) == "string" then
                self.L[k] = v
            else
                self.L[k] = k
            end
        end
    end
end
