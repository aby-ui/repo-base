--[==[
@Date    : 2016-05-04 15:19:33
@Author  : DengSir (ldz5@qq.com)
@Link    : https://dengsir.github.io
@Version : $Id$
]==]

BuildEnv(...)

App = Addon:NewModule('App', 'NetEaseSocket-2.0', 'AceHook-3.0', 'AceTimer-3.0', 'AceEvent-3.0', 'AceBucket-3.0')

function App:OnInitialize()
    self:ListenSocket('NERB', ADDON_SERVER)
    self:ConnectServer()
end

function App:OnEnable()
    self.appWhispers = {}
    -- self:RegisterServer('APP_WHISPER')
    -- self:RegisterServer('APP_WHISPER_FAILED')
    -- self:RegisterServer('APP_WHISPER_INFORM')
    -- self:RawHook('SendChatMessage', true)

    self:RegisterServer('SERVER_CONNECTED')

    self:RegisterServer('APP_QUERY_RESULT')
    self:RegisterServer('APP_FOLLOW')
    self:RegisterServer('APP_FOLLOW_RESULT')
    self:RegisterServer('APP_BITFOLLOWED')
    self:RegisterServer('APP_APPLY_ACTIVITIES')

    self.followQueryList = {}
    self.remoteApplyActivities = {}
end

function App:OnDisable()
    wipe(self.appWhispers)
    self.hasApp = nil
end

local _SendServer = App.SendServer
function App:SendServer(cmd, ...)
    return _SendServer(self, cmd, UnitGUID('player'), ...)
end

function App:HasApp()
    return self.hasApp
end

function App:IsConnected()
    return self.isConnected
end

function App:IsFirstLogin()
    return not self.hasApp and self.alive and Profile:IsProfileKeyNew('appShine')
end

function App:SERVER_CONNECTED()
    self.isConnected = true
    self:ScheduleTimer('SendServer', 1, 'APP_QUERY', GetGuildName())
end

function App:APP_QUERY_RESULT(_, flag, enable, alive)
    if flag then
        self.hasApp = true
        Addon:EnableModule('AppParent')
    end
    if enable then
        Addon:EnableModule('AppSupport')
    end
    if alive then
        self.alive = true
        MainPanel:RegisterPanel(L['随身集合石'], AppParent, {after = L['最新活动']})
    end
    self:SendMessage('MEETINGSTONE_APP_READY')
end

---- Remote Apply

function App:APP_APPLY_ACTIVITIES(_, activities)
    for leader, args in pairs(activities) do
        local apply = Addon:GetClass('RemoteApply'):New(args.activityId, args.customId)

        apply:SetSearch(leader)
        apply:SetIsTank(args.tank)
        apply:SetIsHealer(args.healer)
        apply:SetIsDamager(args.damager)

        AutoApply:Add(apply)
    end
    AutoApply:Start()
end

---- App Whisper

-- function App:APP_WHISPER_RAW(_, target, guid, text)
--     if _G.IsIgnored(Ambiguate(target, 'none')) then
--         return
--     end
--     self.appWhispers[target] = guid
--     self:MakeAppWhisper('CHAT_MSG_APP_WHISPER', text, ChatTargetSystemToApp(target))
-- end

-- function App:APP_WHISPER_FAILED(_, target, guid, text, status)
--     self:APP_WHISPER_RAW(_, target, guid, text)
--     Profile:AddFollow(target, guid, status)
-- end

-- function App:APP_WHISPER(_, target, guid, text)
--     self:APP_WHISPER_RAW(_, target, guid, text)
--     Profile:AddFollow(target, guid, FOLLOW_STATUS_FRIEND)
-- end

-- function App:APP_WHISPER_INFORM(_, target, guid, text)
--     self:MakeAppWhisper('CHAT_MSG_APP_WHISPER_INFORM', text, ChatTargetSystemToApp(target))
--     Profile:AddFollow(target, guid, FOLLOW_STATUS_FRIEND)
-- end

-- function App:SendChatMessage(text, chatType, languageIndex, channel)
--     if chatType == 'WHISPER' and IsChatTargetApp(channel) then
--         local target = ChatTargetAppToSystem(channel)
--         local guid = self:GetWhisperGuid(target)

--         self:MakeAppWhisper('CHAT_MSG_APP_WHISPER_INFORM', text, channel)
--         self:SendServer('APP_WHISPER', target, guid, text)
--     else
--         return self.hooks.SendChatMessage(text, chatType, languageIndex, channel)
--     end
-- end

-- function App:GetWhisperGuid(target)
--     return self.appWhispers[target] or Profile:GetFollowGuid(target)
-- end

-- function App:MakeAppWhisper(...)
--     return AppWhisper:MakeAppWhisper(...)
-- end

----

function App:RemoveFollowQuery(target)
    for i, v in ipairs(self.followQueryList) do
        if v:GetName() == target then
            tremove(self.followQueryList, i)

            self:SendMessage('MEETINGSTONE_APP_FOLLOWQUERYLIST_UPDATE', #self.followQueryList)
            return
        end
    end
end

local followThrottle = Addon:GetClass('Throttle'):New(10, 5)
function App:Follow(target, targetGuid)
    if followThrottle:IsThrottled() then
        self:APP_FOLLOW_RESULT(nil, target, targetGuid, FOLLOW_STATUS_THROTTLED)
    else
        followThrottle:Mark()
        self:SendServer('APP_FOLLOW', target, targetGuid, GetPlayerClass(), UnitLevel('player'), GetPlayerItemLevel())
        self:RemoveFollowQuery(target)
    end
end

function App:FollowIgnore(target, targetGuid)
    self:SendServer('APP_FOLLOW_IGNORE', target, targetGuid)
    self:RemoveFollowQuery(target)
end

function App:APP_FOLLOW(_, target, targetGuid, class, level, itemLevel)
    local followQuery = FollowQuery:Get(target)
    followQuery:SetGuid(targetGuid)
    followQuery:SetLevel(level)
    followQuery:SetItemLevel(itemLevel)
    followQuery:SetClass(class)

    if not tContains(self.followQueryList, followQuery) then
        tinsert(self.followQueryList, 1, followQuery)
        self.hasNewFollower = true
        self:SendMessage('MEETINGSTONE_APP_NEW_FOLLOWER_STATUS_UPDATE')
    end
    if select(2, Profile:IsFollowed(target)) then
        Profile:AddFollow(target, targetGuid, FOLLOW_STATUS_UNKNOWN)
    end
    self:SendMessage('MEETINGSTONE_APP_FOLLOWQUERYLIST_UPDATE', #self.followQueryList)
end

function App:APP_FOLLOW_RESULT(_, target, targetGuid, status)
    if status == FOLLOW_STATUS_STARED then
        System:Logf(L['你已关注%s。'], target)
        Profile:AddFollow(target, targetGuid, FOLLOW_STATUS_STARED)
    elseif status == FOLLOW_STATUS_FRIEND then
        System:Logf(L['你和%s已经互相关注了，可以通过随身集合石APP随时沟通了。'], target)
        Profile:AddFollow(target, targetGuid, FOLLOW_STATUS_FRIEND)
    elseif status == FOLLOW_STATUS_THROTTLED then
        System:Logf(L['关注失败，操作太频繁。'])
    elseif status == FOLLOW_STATUS_MAX then
        System:Logf(L['关注失败，你的关注人数已经达到上限了。'])
    else
        System:Logf(L['关注失败，请稍后再试。'])
    end
end

function App:APP_BITFOLLOWED(_, target, targetGuid)
    Profile:AddFollow(target, targetGuid, FOLLOW_STATUS_FRIEND)
end

function App:GetFollowQueryList()
    return self.followQueryList
end

function App:HasNewFollower()
    return self.hasNewFollower
end

function App:ClearNewFollower()
    self.hasNewFollower = false
    self:SendMessage('MEETINGSTONE_APP_NEW_FOLLOWER_STATUS_UPDATE')
end
