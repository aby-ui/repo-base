local ADDONNAME, ADDONSELF = ...

local f = CreateFrame("Frame")
local m = {}
f:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local name = select(1, ...)

        if ADDONNAME ~= name then
            return
        end
    end

    local cbs = m[event]
    if cbs then
        for _, cb in pairs(cbs) do
            cb(...)
        end
    end
end)

ADDONSELF.regevent = function(event, cb)
    if not m[event] then
        m[event] = {}
    end

    f:RegisterEvent(event)
    table.insert(m[event] , cb)
end
