
local MAJOR, MINOR = 'NetEaseEnv-1.0', 2
local Env = LibStub:NewLibrary(MAJOR, MINOR)
if not Env then return end

Env._NSList = Env._NSList or {}
Env._NSModules = Env._NSModules or {}
Env._NSInclude = Env._NSInclude or setmetatable({}, {__index = function(o, k)
    o[k] = {}
    return o[k]
end})

local _NSList = Env._NSList
local _NSModules = Env._NSModules
local _NSInclude = Env._NSInclude

local function FindKey(current, name)
    for _, ns in pairs(_NSInclude[current]) do
        if ns[name] then
            return ns[name]
        end
    end
    return _G[name]
end

local _Meta = {
    __index = function(o, k)
        local v = FindKey(o, k)
        o[k] = v
        return v
    end
}

local function include(current, name, slient)
    local ns = _NSList[name]
    if ns then
        _NSInclude[current][name] = ns
    elseif not slient then
        error(([[Cannot find namespace '%s']]):format(name), 2)
    end
end

local function require(name)
    return _NSModules[name]
end

local function buildNameSpace(name)
    if not _NSList[name] then
        local _ENV = setmetatable({
            require = require,
        }, _Meta)

        _ENV._ENV = _ENV
        _NSList[name] = _ENV
    end
    return _NSList[name]
end

local function buildModule(name)
    if not _NSModules[name] then
        local _M = {}
        _M._M = _M

        _NSModules[name] = _M
    end
    return _NSModules[name]
end

function BuildEnv(name, ...)
    local ns = buildNameSpace(name)
    for i = 1, select('#', ...) do
        local n = select(i, ...)
        if type(n) == 'string' then
            include(ns, n)
        end
    end
    setfenv(2, ns)
end

function BuildModule(name)
    setfenv(2, buildModule(name))
end
