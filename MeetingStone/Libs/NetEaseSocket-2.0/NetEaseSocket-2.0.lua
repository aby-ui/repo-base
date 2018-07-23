
local SocketHandler = LibStub('SocketHandler-2.0')

local MAJOR, MINOR = 'NetEaseSocket-2.0', 2
local Socket,oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not Socket then return end

Socket.handlers = Socket.handlers or setmetatable({}, {
    __index = function(o, k)
        o[k] = SocketHandler:New()
        return o[k]
    end
})

do
    local function call(obj, method, ...)
        local handler = Socket.handlers[obj]
        if handler and handler[method] then
            handler[method](handler, ...)
        end
    end

    local interfaces = {
        'ListenSocket',
        'SendSocket',
        'SendServer',
        'SendBroad',
        'ConnectServer',
        'ConnectChannel',
    }

    for i, v in ipairs(interfaces) do
        Socket[v] = function(self, ...)
            return call(self, v, ...)
        end
    end

    local interfaces = {
        'RegisterBroad',
        'UnregisterBroad',
        'UnregisterAllBroad',
        'RegisterServerBroad',
        'UnregisterServerBroad',
        'UnregisterAllServerBroad',
    }

    local function call(obj, method, ...)
        local handler = Socket.handlers[obj]
        if handler and handler[method] then
            handler[method](obj, ...)
        end
    end

    for i, v in ipairs(interfaces) do
        Socket[v] = function(self, ...)
            return call(self, v, ...)
        end
    end
end

local mixins = {
    'RegisterSocket', 'UnregisterSocket', 'UnregisterAllSocket',
    'RegisterServer', 'UnregisterServer', 'UnregisterAllServer',
    'RegisterBroad',  'UnregisterBroad',  'UnregisterAllBroad',
    'RegisterServerBroad', 'UnregisterServerBroad', 'UnregisterAllServerBroad',
    'SendSocket', 'SendServer', 'SendBroad',
    'ListenSocket', 'ConnectServer', 'ConnectChannel',
}

function Socket:Embed(target)
    local handler = Socket.handlers[target]
    for i, v in ipairs(mixins) do
        target[v] = self[v] or handler[v]
    end
end
