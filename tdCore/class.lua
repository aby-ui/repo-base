
local assert, select = assert, select
local rawget, rawset, setmetatable = rawget, rawset, setmetatable
local format = string.format
local tdCore = tdCore

local handles = {}

local function Debug(self, ...)
    if tdCore:GetAllowDebug() then
        tdCore:Debug('tdCore', self:GetClassName(), ...)
    end
end

local function Bind(self, obj)
    if not rawget(self, '__index') then
        rawset(self, '__index', self)
    end
    return setmetatable(obj, self)
end

local function GetClassName(self)
    return self.__className
end

local function GetVersion()
    return self.__version
end

local function RegisterHandle(self, ...)
    for i = 1, select('#', ...) do
        local name = select(i, ...)
        
        assert(type(name) == 'string', format('Bad argument #%d to `RegisterHandle\' (string expected)', i))
        
        self.__handles = self.__handles or {}
        self.__handles[name] = true
    end
end

local function GetHandle(self, name)
    assert(type(name) == 'string', 'Bad argument #1 to `GetHandle\' (string expected)')
    
    return handles[self] and handles[self][name]
end

local function HasHandle(self, name)
    assert(type(name) == 'string', 'Bad argument #1 to `HasHandle\' (string expected)')
    
    return self.__handles and self.__handles[name]
end

local function SetHandle(self, name, method)
    assert(type(name) == 'string', 'Bad argument #1 to `SetHandle\' (string expected)')
    assert(type(method) == 'function' or method == nil, 'Bad argument #3 `SetHandle\' (function or nil expected)')
    assert(HasHandle(self, name), format('Bad argument #2 to `SetHandle\' (not has this handle [ %s ] )', name))
    
    handles[self] = handles[self] or {}
    handles[self][name] = method
end

local function RunHandle(self, name, ...)
    assert(type(name) == 'string', 'Bad argument #1 to `RunHandle\' (string expected)')
    
    local method = GetHandle(self, name)
    if method then
        method(self, ...)
    end
end

function tdCore:NewClass(name, obj)
    assert(type(name) == 'string', 'Bad argument #1 to `NewClass\' (string expected)')
    
    obj = type(obj) == 'table' and obj or {}
    
    obj.__className = name
    
    obj.Bind = Bind
    obj.HasHandle = HasHandle
    obj.GetHandle = GetHandle
    obj.SetHandle = SetHandle
    obj.RunHandle = RunHandle
    obj.RegisterHandle = RegisterHandle
    
    obj.GetClassName = GetClassName
    obj.GetVersion = GetVersion
    
    return obj
end

local librarys = {}

function tdCore:NewLibrary(name, obj, version)
    assert(type(name) == 'string', 'Bad argument #1 to `NewLibrary\' (string expected)')
    
    local lib = self:NewClass(name, obj)
    
    lib.__version = tonumber(version) or 1
    
    librarys[name] = lib
    
    return lib
end

function tdCore:GetLibrary(name)
    assert(type(name) == 'string', 'Bad argument #1 to `GetLibrary\' (string expected)')
    
    return librarys[name]
end

