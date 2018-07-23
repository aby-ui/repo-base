
local MAJOR, MINOR = 'LibClass-2.0', 997
local Class = LibStub:NewLibrary(MAJOR, MINOR)
if not Class then
    return
end

Class._UIBaseClass = Class._UIBaseClass or {}
Class._Classes = Class._Classes or {}

Class.Object = Class.Object or {}

---- Lua APIS

local assert, error, pcall, type = assert, error, pcall, type
local wipe, pairs, rawget, rawset = wipe, pairs, rawget, rawset
local setmetatable, hooksecurefunc = setmetatable, hooksecurefunc
local tconcat, loadstring, xpcall = table.concat, loadstring, xpcall
local geterrorhandler = geterrorhandler
local format, wipe, select = string.format, wipe, select

---- WOW APIS

local CreateFrame = CreateFrame


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

local function safereturn(success, ...)
    if success then
        return ...
    end
end

-----------------------------
--                     Object
-----------------------------

local Object = wipe(Class.Object)

local function Constructor(class, object, ...)
    if not class then
        return
    end
    Constructor(class:GetSuper(), object, ...)

    local ctor = rawget(class, 'Constructor')
    if type(ctor) == 'function' then
        ctor(object, ...)
    end
    return object
end

local function Create(_Meta)
    local object

    if not _Meta.__ui then
        object = {}
    elseif not _Meta.__uiname then
        object = CreateFrame(_Meta.__ui, nil, nil, _Meta.__inherit)
    else
        _Meta.__uiindex = (_Meta.__uiindex or 0) + 1

        object = CreateFrame(_Meta.__ui, _Meta.__uiname .. _Meta.__uiindex, nil, _Meta.__inherit)
    end
    return setmetatable(object, _Meta)
end

function Object:New(...)
    if not Class:IsClass(self) then
        error([[bad argument #self to 'New' (class expected)]], 2)
    end
    return Constructor(self, Create(self._Meta), ...)
end

function Object:GetSuper()
    return self._Meta.__super
end

function Object:GetType()
    return self._Meta.__type
end

function Object:GetInherit()
    return self._Meta.__inherit
end

function Object:IsType(class)
    if not self.GetType then
        return false
    end
    if not Class:IsClass(class) then
        return false
    end
    if self:GetType() == class then
        return true
    end
    local super = self:GetSuper()
    return super and super:IsType(class) or false
end

function Object:IsInstance(object)
    return Class:IsObject(object) and object:IsType(self._Meta.__type)
end

function Object:SetCallback(name, func)
    if type(func) == 'function' then
        self.events = self.events or {}
        self.events[name] = func
    end
end

function Object:Fire(name, ...)
    if self.events and self.events[name] then
        return safereturn(safecall(self.events[name], self, ...))
    end
end

function Object:SuperCall(method, ...)
    local super = self:GetSuper()
    if not super then
        error([[this class not have a super class]], 2)
    end
    if type(method) ~= 'string' then
        error(format([[bad argument #1 to 'SuperCall' (string expected, got %s)]], type(method)), 2)
    end
    if type(super[method]) ~= 'function' then
        error(format([[attempt to call global '%s' (a nil value)]], method), 2)
    end

    while super do
        if super[method] == self[method] then
            super = super:GetSuper()
        else
            return super[method](self, ...)
        end
    end
end

-----------------------------
--                      Class
-----------------------------

local _UIBaseClass = setmetatable(Class._UIBaseClass, {__index = function(t, k)
    local ok, class = pcall(CreateFrame, k)
    if ok then
        class._Meta = {
            __index = class,
            __type  = class,
            __ui    = k == "scrollframe" and "ScrollFrame" or class:GetObjectType(),
        }
        class:Hide()
        class.Constructor = class.SetParent

        for k, v in pairs(Object) do
            class[k] = v
        end

        t[k] = class
    else
        t[k] = false
    end
    return t[k]
end})

function Class:SuperHelper(super)
    if type(super) == 'string' then
        local objType, inherit = super:match('^(%a+)%.?([%w_]*)$')
        local baseSuper = _UIBaseClass[objType:lower()]
        if not baseSuper then
            error(format([['%s' isnot blizzard widget object.]], super), 4)
        else
            return baseSuper, inherit ~= '' and inherit or nil
        end
    elseif Class:IsClass(super) then
        return super, super._Meta.__inherit
    elseif not super then
        return
    else
        error([[bad argument #1 to 'New' (string/class/widget expected)]], 4)
    end
end

local function Inherit(class, super)
    if not super then
        return
    end
    Inherit(class, super:GetSuper())

    local inherit = rawget(super, 'Inherit')
    if type(inherit) == 'function' then
        inherit(class)
    end
end

local function CloneMeta(super)
    if not super then
        return {}
    else
        local _Meta = {}
        for k, v in pairs(super._Meta) do
            _Meta[k] = v
        end
        return _Meta
    end
end

function Class:New(super)
    if self ~= Class then
        error([[Usage: Class:New(name[, super])]], 2)
    end

    local super, inherit = self:SuperHelper(super)
    local class = {}

    class._Meta = CloneMeta(super)
    class._Meta.__index = class
    class._Meta.__super = super
    class._Meta.__type  = class

    if super then
        class._Meta.__inherit = inherit

        setmetatable(class, super._Meta)

        Inherit(class, super)
    end

    for k, v in pairs(Object) do
        class[k] = v
    end
    return class
end

function Class:IsClass(value)
    if self ~= Class then
        error([[Usage: Class:IsClass(value)]], 2)
    end
    if type(value) ~= 'table' then
        return false
    end
    local _Meta = rawget(value, '_Meta')
    if not _Meta then
        return false
    end
    return _Meta.__type == value
end

function Class:IsObject(value)
    if self ~= Class then
        error([[Usage: Class:IsObject(value)]], 2)
    end
    if type(value) ~= 'table' then
        return false
    end
    if rawget(value, '_Meta') then
        return false
    end
    local _Meta = value._Meta
    if not _Meta then
        return false
    end
    return Class:IsClass(_Meta.__type)
end

function Class:IsWidget(value)
    if self ~= Class then
        error([[Usage: Class:IsWidget(value)]], 2)
    end
    if type(value) ~= 'table' then
        return false
    end
    return value.GetObjectType and type(rawget(value, 0)) == 'userdata' or false
end

function Class:IsUIClass(value)
    if self ~= Class then
        error([[Usage: Class:IsClass(value)]], 2)
    end
    if type(value) ~= 'table' then
        return false
    end
    local _Meta = rawget(value, '_Meta')
    if not _Meta then
        return false
    end
    return _Meta.__ui
end

-----------------------------
--                    Library
-----------------------------

local _Classes = setmetatable(Class._Classes, {__index = function(t, k)
    t[k] = {}
    return t[k]
end})

function Class:NewClass(name, ...)
    if _Classes[self][name] then
        return
    end
    local class = Class:New(...)
    _Classes[self][name] = class
    return class
end

function Class:GetClass(name)
    return _Classes[self][name]
end

function Class:Embed(target)
    target.NewClass = Class.NewClass
    target.GetClass = Class.GetClass
end
