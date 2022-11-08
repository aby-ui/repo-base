--[[-------------------------------------------------------------------------
-- AddonCore.lua
--
-- This is a very simple, bare-minimum core for addon development. It provide
-- methods to register events, call initialization functions, and sets up the
-- localization table so it can be used elsewhere. This file is designed to be
-- loaded first, as it has no further dependencies.
--
-- Events registered:
--   * ADDON_LOADED - Watch for saved variables to be loaded, and call the
--       'Initialize' function in response.
--   * PLAYER_LOGIN - Call the 'Enable' method once the major UI elements
--       have been loaded and initialized.
-------------------------------------------------------------------------]]--

local addonName, addon = ...

-- Set global name of addon
_G[addonName] = addon

-- Globals used in this library
local CreateFrame = CreateFrame
local GetAddOnMetadata = GetAddOnMetadata
local GetBuildInfo = GetBuildInfo
local geterrorhandler = geterrorhandler
local GetLocale = GetLocale
local InCombatLockdown = InCombatLockdown
local IsLoggedIn = IsLoggedIn
local Mixin = Mixin
---@diagnostic disable-next-line: undefined-field
local twipe = table.wipe
local UIParent = UIParent

-- Extract version information from TOC file
addon.version = GetAddOnMetadata(addonName, "Version")
if addon.version == "@project-version" or addon.version == "wowi:version" then
    addon.version = "SCM"
end

local errorHandler = geterrorhandler()

--[[-------------------------------------------------------------------------
--  Debug support
-------------------------------------------------------------------------]]--

local EMERGENCY_DEBUG = false
if EMERGENCY_DEBUG then
    local private = {}
    for k,v in pairs(addon) do
        rawset(private, k, v)
        rawset(addon, k, nil)
    end

    setmetatable(addon, {
        __index = function(t, k)
            local value = rawget(private, k)
            if type(value) == "function" then
                print("CALL", addonName .. "." .. tostring(k))
            end
            return value
        end,
        __newindex = function(t, k, v)
            print(addonName, "NEWINDEX", k, v)
            rawset(private, k, v)
        end,
    })
end

--[[-------------------------------------------------------------------------
--  API compatibility support
-------------------------------------------------------------------------]]--

-- Returns true if the API value is true-ish (handles old 1/nil returns)
function addon:APIIsTrue(val, ...)
	if type(val) == "boolean" then
		return val
	elseif type(val) == "number" then
		return val == 1
	else
		return false
	end
end

local projects = {
    retail = "WOW_PROJECT_MAINLINE",
    classic = "WOW_PROJECT_CLASSIC",
    bcc = "WOW_PROJECT_BURNING_CRUSADE_CLASSIC",
    wrath = "WOW_PROJECT_WRATH_CLASSIC",
}

local project_id = _G["WOW_PROJECT_ID"]

function addon:ProjectIsRetail()
    return project_id == _G[projects.retail]
end

function addon:ProjectIsClassic()
    return project_id == _G[projects.classic]
end

function addon:ProjectIsBCC()
    return project_id == _G[projects.bcc]
end

function addon:ProjectIsWrath()
    return project_id ==  _G[projects.wrath]
end

function addon:IsDragonflight()
    local toc = select(4, GetBuildInfo())
    return toc >= 100000
end

--[[-------------------------------------------------------------------------
--  Print/Printf support
-------------------------------------------------------------------------]]--

local printHeader = "|cFF33FF99%s|r: "

function addon:Printf(msg, ...)
    msg = printHeader .. msg
    local success, txt = pcall(string.format, msg, addonName, ...)
    if success then
        print(txt)
    else
        error(string.gsub(txt, "'%?'", string.format("'%s'", "Printf")), 3)
    end
end

--[[-------------------------------------------------------------------------
--  Event registration and dispatch
-------------------------------------------------------------------------]]--

addon.eventFrame = CreateFrame("Frame", addonName .. "EventFrame", UIParent)
local eventMap = {}
local EventedMixin = {}

-- Allow multiple handlers to be registered, called in registration order
function EventedMixin:RegisterEvent(event, handler)
    local handler = handler and handler or event
    if eventMap[event] then
        local found = false

        for idx, value in ipairs(eventMap[event]) do
            if type(handler) == "function" and value == handler then
                found = true
            elseif type(handler) == "string" and type(value) == "table" and value.key == handler then
                found = true
            end
        end

        if found then
            assert(eventMap[event] == nil, string.format("Attempt to re-register event '%s' with handler '%s'", tostring(event), tostring(handler)))
        end
    end

    eventMap[event] = eventMap[event] or {}

    -- Convert handler to a table if it's a string
    if type(handler) == "string" then
        handler = {
            type = "method",
            key = handler,
            obj = self,
        }
    end

    table.insert(eventMap[event], handler)

    if #eventMap[event] == 1 then
        addon.eventFrame:RegisterEvent(event)
    end
end

-- Remove event registration for a specific handler, idempotent
function EventedMixin:UnregisterEvent(event, handler)
    assert(type(event) == "string", "Invalid argument to 'UnregisterEvent'")

    local handler = handler and handler or event
    if eventMap[event] then
        local foundIdx = nil
        for idx, value in ipairs(eventMap[event]) do
            if type(handler) == "function" and value == handler then
                foundIdx = idx
            elseif type(handler) == "string" and type(value) == "table" and value.key == handler then
                foundIdx = idx
            end
        end

        if foundIdx and foundIdx > 0 then
            table.remove(eventMap[event], foundIdx)
        end

        if #eventMap[event] == 0 then
            eventMap[event] = nil
            addon.eventFrame:UnregisterEvent(event)
        end
    end
end

addon.eventFrame:SetScript("OnEvent", function(frame, event, ...)
    local handlers = eventMap[event]

    for idx, handler in ipairs(handlers) do
        local handler_t = type(handler)
        if handler_t == "function" then
            xpcall(handler, errorHandler, event, ...)
        elseif handler_t == "table" then
            local obj = handler.obj
            local key = handler.key
            if obj[key] then
                xpcall(obj[key], errorHandler, obj, event, ...)
            end
        end
    end
end)

Mixin(addon, EventedMixin)

--[[-------------------------------------------------------------------------
--  Module support
-------------------------------------------------------------------------]]--

local modules = {}

-- Declared here, but defined below in initialize/init
local initializeModule

function addon:RegisterModule(module, name)
    assert(type(name) == "string", "Invalid argument to 'RegisterModule'")

    module.name = name
    for idx, value in ipairs(modules) do
        if value == module then
            error(string.format("Attempt to re-register module: %s (%s)", name, tostring(module)))
        end
    end

    table.insert(modules, module)

    Mixin(module, EventedMixin)
    Mixin(module, {
        Printf = addon.Printf,
    })

    -- See if we need to initialize due to late registration
    initializeModule(module)
end

--[[-------------------------------------------------------------------------
--  Setup Initialize/Enable support
-------------------------------------------------------------------------]]--

local enableCalled = false
local initializeCalled = false

local enableHandler = function(event, ...)
    enableCalled = true
    local handler = "Enable"

    if type(addon[handler]) == "function" then
        xpcall(addon[handler], errorHandler, addon)
    end

    for idx, module in ipairs(modules) do
        if type(module[handler]) == "function" then
            xpcall(module[handler], errorHandler, module)
        end
    end
end

-- Pre-declare so it can be used within the closure
local initializeHandler
initializeHandler = function(event, ...)
    initializeCalled = true
    local handler = "Initialize"

    if ... == addonName then
        addon:UnregisterEvent("ADDON_LOADED", initializeHandler)
        if type(addon[handler]) == "function" then
            xpcall(addon[handler], errorHandler, addon)
        end

        for idx, module in ipairs(modules) do
            if type(module[handler]) == "function" then
                xpcall(module[handler], errorHandler, module)
            end
        end

        -- If this addon was loaded-on-demand, trigger 'Enable' as well
        if IsLoggedIn() then
            -- defer to the enableHandler directly
            enableHandler()
        end
    end
end

initializeModule = function(module)
    if initializeCalled and type(module["Initialize"]) == "function" then
        xpcall(module["Initialize"], module)
    end

    if enableCalled and type(module["Enable"]) == "function" then
        xpcall(module["Enable"], module)
    end
end

addon:RegisterEvent("PLAYER_LOGIN", enableHandler)
addon:RegisterEvent("ADDON_LOADED", initializeHandler)

--[[-------------------------------------------------------------------------
--  Message support
-------------------------------------------------------------------------]]--

local messageMap = {}

function addon:RegisterMessage(name, handler)
    assert(messageMap[name] == nil, "Attempt to re-register message: " .. tostring(name))
    messageMap[name] = handler and handler or name
end

function addon:UnregisterMessage(name)
    assert(type(name) == "string", "Invalid argument to 'UnregisterMessage'")
    messageMap[name] = nil
end

function addon:FireMessage(name, ...)
    assert(type(name) == "string", "Invalid argument to 'FireMessage'")
    local handler = messageMap[name]
    local handler_t = type(handler)
    if handler_t == "function" then
        handler(name, ...)
    elseif handler_t == "string" and addon[handler] then
        addon[handler](addon, name, ...)
    end
end

--[[-------------------------------------------------------------------------
--  Support for deferred execution (when in-combat)
-------------------------------------------------------------------------]]--

local deferframe = CreateFrame("Frame")
deferframe.queue = {}

local function runDeferred(thing)
    local thing_t = type(thing)
    if thing_t == "string" and addon[thing] then
        addon[thing](addon)
    elseif thing_t == "function" then
        thing(addon)
    end
end

-- This method will defer the execution of a method or function until the
-- player has exited combat. If they are already out of combat, it will
-- execute the function immediately.
function addon:Defer(...)
    for i = 1, select("#", ...) do
        local thing = select(i, ...)
        local thing_t = type(thing)
        if thing_t == "string" or thing_t == "function" then
            if InCombatLockdown() then
                deferframe.queue[#deferframe.queue + 1] = select(i, ...)
            else
                runDeferred(thing)
            end
        else
            error("Invalid object passed to 'Defer'")
        end
    end
end

deferframe:RegisterEvent("PLAYER_REGEN_ENABLED")
deferframe:SetScript("OnEvent", function(self, event, ...)
    for idx, thing in ipairs(deferframe.queue) do
        runDeferred(thing)
    end
    twipe(deferframe.queue)
end)

--[[-------------------------------------------------------------------------
--  Localization
-------------------------------------------------------------------------]]--

addon.L = addon.L or setmetatable({}, {
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

function addon:RegisterLocale(locale, tbl)
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
