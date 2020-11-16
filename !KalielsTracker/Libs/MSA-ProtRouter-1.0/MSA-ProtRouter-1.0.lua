--- MSA-ProtRouter-1.0 - Router for Protected functions
--- Copyright (c) 2019-2020, Marouan Sabbagh <mar.sabbagh@gmail.com>
--- All Rights Reserved.
---
--- https://www.curseforge.com/wow/addons/msa-protrouter-10

local name, version = "MSA-ProtRouter-1.0", 1

local lib, oldVersion = LibStub:NewLibrary(name, version)
if not lib then return end

local forceUpdate = (oldVersion and oldVersion <= 0)

-- Lua API
local tinsert = table.insert
local tremove = table.remove
local type = type
local unpack = unpack

-- WoW API
local _G = _G
local InCombatLockdown = InCombatLockdown

lib.combatLockdown = InCombatLockdown()
lib.protectedActions = {}

local function protRunStoredActions()
    while #lib.protectedActions > 0 do
        if lib.combatLockdown then break end
        local func, params = unpack(lib.protectedActions[1])
        func(unpack(params))
        tremove(lib.protectedActions, 1)
    end
end

function lib:prot(object, method, ...)
    local func, params, region
    if type(object) == "string" then
        func = object
        params = { method, ... }
    else
        func = object[method]
        params = { object, ... }
        region = object
    end
    local isProtected = false
    if region then
        isProtected = region:IsProtected()
    end

    if lib.combatLockdown and isProtected then
        tinsert(lib.protectedActions, { func, params })
    else
        func(unpack(params))
    end
end

-- Events
lib.eventFrame = lib.eventFrame or CreateFrame("Frame")
lib.eventFrame:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_REGEN_DISABLED" then
        lib.combatLockdown = true
    elseif event == "PLAYER_REGEN_ENABLED" then
        lib.combatLockdown = false
        protRunStoredActions()
    end
end)
lib.eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
lib.eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")

------------------------------------------------------------------------------------------------------------------------
-- Embed handling
------------------------------------------------------------------------------------------------------------------------

lib.embeds = lib.embeds or {}

local mixins = {
    "combatLockdown",
    "prot"
}

function lib:Embed(target)
    lib.embeds[target] = true
    for _,v in next, mixins do
        target[v] = lib[v]
    end
    return target
end

for addon in next, lib.embeds do
    lib:Embed(addon)
end