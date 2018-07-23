
--[[

by ldz5

--]]

local MAJOR, MINOR = "LibModule-1.0", 2
local Module, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not Module then
    return
end

local pairs, tconcat, tinsert = pairs, table.concat, table.insert
local format, tostring, select = string.format, tostring, select
local type, xpcall, assert, loadstring = type, xpcall, assert, loadstring
local setmetatable, rawset, error = setmetatable, rawset, error
local geterrorhandler = geterrorhandler

--[[
     xpcall safecall implementation
]]

local function errorhandler(err)
    return geterrorhandler()(err)
end

local function CreateDispatcher(argCount)
    local code = [[
        local xpcall, eh = ...
        local method, ARGS
        local function call() return method(ARGS) end
    
        local function dispatch(func, ...)
            method = func
            if not method then return end
            ARGS = ...
            return xpcall(call, eh)
        end
    
        return dispatch
    ]]
    
    local ARGS = {}
    for i = 1, argCount do ARGS[i] = "arg"..i end
    code = code:gsub("ARGS", tconcat(ARGS, ", "))
    return assert(loadstring(code, "safecall Dispatcher["..argCount.."]"))(xpcall, errorhandler)
end

local Dispatchers = setmetatable({}, {__index=function(self, argCount)
    local dispatcher = CreateDispatcher(argCount)
    rawset(self, argCount, dispatcher)
    return dispatcher
end})
Dispatchers[0] = function(func)
    return xpcall(func, errorhandler)
end
 
local function safecall(func, ...)
    return Dispatchers[select("#", ...)](func, ...)
end

local AceAddon = LibStub('AceAddon-3.0')

local function IsModuleTrue(self) return true end

function Module:NewModule(objectorname, ...)
    local object,name,prototype
    local i=2
    if type(objectorname)=="table" then
        object=objectorname
        name,prototype=...
        i=3
    else
        name=objectorname
        prototype=...
    end
    if type(name) ~= "string" then error(("Usage: NewModule([object,] name, [prototype, [lib, lib, lib, ...]): 'name' - string expected got '%s'."):format(type(name)), 2) end
    if type(prototype) ~= "string" and type(prototype) ~= "table" and type(prototype) ~= "nil" then error(("Usage: NewModule([object,] name, [prototype, [lib, lib, lib, ...]): 'prototype' - table (prototype), string (lib) or nil expected got '%s'."):format(type(prototype)), 2) end
    
    if self.modules[name] then error(("Usage: NewModule([object,]name, [prototype, [lib, lib, lib, ...]): 'name' - Module '%s' already exists."):format(name), 2) end
    
    local module
    if object then
        module = AceAddon:NewAddon(object, format("%s_%s", self.name or tostring(self), name))
    else
        module = AceAddon:NewAddon(format("%s_%s", self.name or tostring(self), name))
    end

    module.IsModule = IsModuleTrue
    module:SetEnabledState(self.defaultModuleState)
    module.moduleName = name

    if type(prototype) == "string" then
        AceAddon:EmbedLibraries(module, prototype, select(i, ...))
    else
        AceAddon:EmbedLibraries(module, select(i, ...))
    end
    AceAddon:EmbedLibraries(module, unpack(self.defaultModuleLibraries))

    if not prototype or type(prototype) == "string" then
        prototype = self.defaultModulePrototype or nil
    end

    if type(prototype) == "table" then
        for k, v in pairs(prototype) do
            module[k] = v
        end
    end
    
    safecall(self.OnModuleCreated, self, module) -- Was in Ace2 and I think it could be a cool thing to have handy.
    self.modules[name] = module
    tinsert(self.orderedModules, module)
    
    return module
end

function Module:ShowModule(name, ...)
    local module = self:GetModule(name, true)
    if not module then
        error(([[Cannot show module '%s' (module not exists)]]):format(name), 2)
    end
    if not (type(module[0]) == 'userdata' and module.GetObjectType) then
        error(([[Cannot show module '%s' (is not uiobject)]]):format(name), 2)
    end
    HideUIPanel(module)
    if type(module.SetArguments) == 'function' then
        module:SetArguments(...)
    end
    ShowUIPanel(module)
end

function Module:HideModule(name)
    local module = self:GetModule(name, true)
    if not module then
        error(([[Cannot hide module '%s' (module not exists)]]):format(name), 2)
    end
    if not (type(module[0]) == 'userdata' and module.GetObjectType) then
        error(([[Cannot hide module '%s' (is not uiobject)]]):format(name), 2)
    end
    HideUIPanel(module)
end

function Module:ToggleModule(name, ...)
    local module = self:GetModule(name, true)
    if not module then
        error(([[Cannot toggle module '%s' (module not exists)]]):format(name), 2)
    end
    if not (type(module[0]) == 'userdata' and module.GetObjectType) then
        error(([[Cannot toggle module '%s' (is not uiobject)]]):format(name), 2)
    end
    if module:IsShown() then
        -- HideUIPanel(module)
        self:HideModule(name)
    else
        -- ShowUIPanel(module)
        self:ShowModule(name, ...)
    end
end

local mixins = {
    'NewModule',
    'ShowModule',
    'HideModule',
    'ToggleModule',
}

function Module:Embed(target)
    for i, v in ipairs(mixins) do
        target[v] = self[v]
    end
end
