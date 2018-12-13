local addon = select(2,...)
local TCL = addon.TomCatsLibs

local function ADDON_LOADED(_, event, ...)
    local var1 = select(1, ...)
    if (var1 == addon.name) then
        local varPrefix = string.gsub(addon.name, "-", "_")
        local characterSavedVarsName = varPrefix .. "_Character"
        local accountSavedVarsName = varPrefix .. "_Account"
        _G[characterSavedVarsName] = _G[characterSavedVarsName] or {}
        _G[accountSavedVarsName] = _G[accountSavedVarsName] or {}
        addon.savedVariables = {
            character = _G[characterSavedVarsName],
            account = _G[accountSavedVarsName]
        }
        addon.savedVariables.character.preferences = addon.savedVariables.character.preferences or {}
        TCL.Events.UnregisterEvent("ADDON_LOADED", ADDON_LOADED)
    end
end

function TCL.SavedVariables.init()
    TCL.Events.RegisterEvent("ADDON_LOADED", ADDON_LOADED)
end
