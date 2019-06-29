local addon = select(2,...)
local TCL = addon.TomCatsLibs

local function ADDON_LOADED(_, event, ...)
    local var1 = select(1, ...)
    if (var1 == addon.name) then
        local characterSavedVarsName = "TomCats_Mechagon_Character"
        local accountSavedVarsName = "TomCats_Mechagon_Account"
        _G[characterSavedVarsName] = _G[characterSavedVarsName] or {}
        _G[accountSavedVarsName] = _G[accountSavedVarsName] or {}
        addon.savedVariables = {
            character = _G[characterSavedVarsName],
            account = _G[accountSavedVarsName]
        }
        addon.savedVariables.character.preferences = addon.savedVariables.character.preferences or {}
        addon.savedVariables.account.preferences = addon.savedVariables.account.preferences or {}
        TCL.Events.UnregisterEvent("ADDON_LOADED", ADDON_LOADED)
    end
end

function TCL.SavedVariables.init()
    TCL.Events.RegisterEvent("ADDON_LOADED", ADDON_LOADED)
end
