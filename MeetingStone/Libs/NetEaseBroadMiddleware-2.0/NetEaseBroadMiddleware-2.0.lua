
local AceSerializer = assert(LibStub('AceSerializer-3.0', true), 'BroadHandler-1.0 requires AceSerializer-3.0')
local CallbackHandler = assert(LibStub('CallbackHandler-1.0', true), 'BroadHandler-1.0 requires CallbackHandler-1.0')
local CTL = assert(ChatThrottleLib, 'BroadHandler-1.0 requires ChatThrottleLib')
local Base64 = assert(LibStub('NetEaseBase64-1.0', true), 'BroadHandler-1,0 requires NetEaseBase64-1.0')

local MAJOR, MINOR = 'NetEaseBroadMiddleware-2.0', 1
local BroadMiddleware,oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not BroadMiddleware then return end

local msgCacheMeta = {__index = function(t, k)
    t[k] = {}
    return t[k]
end}

BroadMiddleware.EventHandler = BroadMiddleware.EventHandler or CreateFrame('Frame')

BroadMiddleware.channels = BroadMiddleware.channels or {}
BroadMiddleware.handlers = BroadMiddleware.handlers or setmetatable({}, {
    __index = function(t, k)
        t[k] = {}
        t[k].msgCache = setmetatable({}, msgCacheMeta)
        t[k].FireBroad = CallbackHandler:New(t[k], 'RegisterBroad', 'UnregisterBroad', 'UnregisterAllBroad').Fire
        t[k].FireServerBroad = CallbackHandler:New(t[k], 'RegisterServerBroad', 'UnregisterServerBroad', 'UnregisterAllServerBroad').Fire
        return t[k]
    end
})

local handlers = BroadMiddleware.handlers
local channels = BroadMiddleware.channels
local EventHandler = BroadMiddleware.EventHandler

local PACKET_FIRST = '#'
local PACKET_NEXT  = '&'
local PACKET_LAST  = '$'
local PACKET_ONE   = '@'
local MAX_LEN = 254

EventHandler:UnregisterAllEvents()
EventHandler:RegisterEvent('CHAT_MSG_CHANNEL')
EventHandler:SetScript('OnEvent', function(self, event, msg, target, _, _, _, flag, _, channelId, channelName)
    if not channels[channelName] then
        return
    end

    local control, data = msg:match('^([#&$@])(.*)$')
    if not control then
        return
    end

    local target = Ambiguate(target, 'none')
    local handler = handlers[channelName]
    local cache = handler.msgCache[target]

    if control == PACKET_FIRST then
        tinsert(wipe(cache), data)
    elseif control == PACKET_NEXT or control == PACKET_LAST then
        tinsert(cache, data)
    end

    if control == PACKET_LAST or control == PACKET_ONE then
        if control == PACKET_LAST then
            data = tconcat(cache)
            wipe(cache)
        end
        self:DealPacket(handler, target, flag, self:Decode(data))
    end
end)

function EventHandler:Decode(data)
    return AceSerializer:Deserialize(Base64:DeCode(data))
end

function EventHandler:Encode(...)
    return Base64:EnCode(AceSerializer:Serialize(...))
end

function EventHandler:DealPacket(handler, target, flag, ok, cmd, ...)
    if not ok then
        return
    end
    if flag ~= 'GM' then
        handler:FireBroad(cmd, target, ...)
    else
        handler:FireServerBroad(cmd, ...)
    end
end

function BroadMiddleware:Listen(channelName)
    local old = channels[self]
    if old then
        local handler = handlers[old]
        handler.UnregisterAllBroad(self)
        handler.UnregisterAllServerBroad(self)
    end

    local handler = handlers[channelName]

    self.RegisterBroad = handler.RegisterBroad
    self.UnregisterBroad = handler.UnregisterBroad
    self.UnregisterAllBroad = handler.UnregisterAllBroad
    self.RegisterServerBroad = handler.RegisterServerBroad
    self.UnregisterServerBroad = handler.UnregisterServerBroad
    self.UnregisterAllServerBroad = handler.UnregisterAllServerBroad
    self.SendBroad = BroadMiddleware.Send

    channels[channelName] = true
    channels[self] = channelName
end

function BroadMiddleware:Send(cmd, ...)
    if not channels[self] then
        return
    end

    local channelId = GetChannelName(channels[self])
    if not channelId or channelId == 0 then
        return
    end

    local chatType = 'CHANNEL'
    local id = channelId
    local data = EventHandler:Encode(cmd, ...)
    local dataLen = #data
    local queueName = cmd

    if dataLen < MAX_LEN then
        CTL:SendChatMessage('NORMAL', cmd, PACKET_ONE..data, chatType, nil, id, queueName)
    else
        local chunk = strsub(data, 1, MAX_LEN)
        
        CTL:SendChatMessage('NORMAL', cmd, PACKET_FIRST..chunk, chatType, nil, id, queueName)

        local pos = 1 + MAX_LEN
        while pos + MAX_LEN <= dataLen do
            chunk = strsub(data, pos, pos + MAX_LEN - 1)

            CTL:SendChatMessage('NORMAL', cmd, PACKET_NEXT..chunk, chatType, nil, id, queueName)
            pos = pos + MAX_LEN
        end

        chunk = strsub(data, pos)
        CTL:SendChatMessage('NORMAL', cmd, PACKET_LAST..chunk, chatType, nil, id, queueName)
    end
end