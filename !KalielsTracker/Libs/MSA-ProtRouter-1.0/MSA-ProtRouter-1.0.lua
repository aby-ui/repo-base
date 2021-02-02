--- MSA-ProtRouter-1.0 - Router for Protected functions
--- Copyright (c) 2019-2021, Marouan Sabbagh <mar.sabbagh@gmail.com>
--- All Rights Reserved.
---
--- https://www.curseforge.com/wow/addons/msa-protrouter-10

local name, version = "MSA-ProtRouter-1.0", 2

local lib, oldVersion = LibStub:NewLibrary(name, version)
if not lib then return end

local forceUpdate = (oldVersion and oldVersion <= 0)

-- Lua API
local ipairs = ipairs
local tinsert = table.insert
local tremove = table.remove
local type = type
local unpack = unpack

-- WoW API
local InCombatLockdown = InCombatLockdown

local combatLockdown = InCombatLockdown()

lib.protectedActions = {}

local function protRunStoredActions()
    while #lib.protectedActions > 0 do
        if combatLockdown then break end
        local func, params = unpack(lib.protectedActions[1])
        func(unpack(params))
        tremove(lib.protectedActions, 1)
    end
end

function lib:prot(method, object, ...)
    local func, region
    if type(method) == "string" then
        func = object[method]
        region = object
    else
        func = method
    end
    local params = { object, ... }
    local isProtected = false
    if region then
        isProtected = region:IsProtected()
    end

    if combatLockdown and isProtected then
        tinsert(lib.protectedActions, { func, params })
    else
        func(unpack(params))
    end
end

function lib:protStop(method, object, ...)
    local func
    if type(method) == "string" then
        func = object[method]
    else
        func = method
    end
    local params = { object, ... }

    if combatLockdown then
        local stored = false
        for _, action in ipairs(lib.protectedActions) do
            if action[1] == func then
                stored = true
                break
            end
        end
        if not stored then
            tinsert(lib.protectedActions, { func, params })
        end
    else
        func(unpack(params))
    end
end

-- Events
lib.eventFrame = lib.eventFrame or CreateFrame("Frame")
lib.eventFrame:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_REGEN_DISABLED" then
        combatLockdown = true
    elseif event == "PLAYER_REGEN_ENABLED" then
        combatLockdown = false
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
    "prot",
    "protStop"
}

function lib:Embed(target)
    lib.embeds[target] = true
    for _, v in next, mixins do
        target[v] = lib[v]
    end
    return target
end

for addon in next, lib.embeds do
    lib:Embed(addon)
end