--[[
Recent.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

BuildEnv(...)

Recent = Addon:NewModule('Recent', 'AceTimer-3.0', 'AceBucket-3.0', 'AceEvent-3.0', 'NetEaseSocket-2.0')

function Recent:OnInitialize()
    self.managers = {}

    self.groupManagers = setmetatable({}, {__index = function(t, k)
        t[k] = {}
        return t[k]
    end})

    self:InitRecentManagers()

    self:RegisterBucketEvent('GROUP_ROSTER_UPDATE', 1)
    self:RegisterEvent('LFG_LIST_ACTIVE_ENTRY_UPDATE')

    self:RegisterMessage('MEETINGSTONE_DB_SHUTDOWN')
    self:RegisterMessage('MEETINGSTONE_GROUP_CLOSED')
    self:RegisterBucketMessage('MEETINGSTONE_MEMBER_UPDATE', 2, 'CacheRecent')
    self:RegisterBucketMessage('MEETINGSTONE_MEMBER_UPDATE', 10, 'BroadcastInfo')

    self:ListenSocket('NE_RECENT')
    self:RegisterSocket('RECENT_INFO')
end

function Recent:OnEnable()
    self:LFG_LIST_ACTIVE_ENTRY_UPDATE()
    self:GROUP_ROSTER_UPDATE()
end

function Recent:InitRecentManagers()
    for activityCode in Profile:IterateRecentDB() do
        self:NewRecentManager(activityCode)
    end
end

function Recent:NewRecentManager(activityCode)
    local manager = RecentManager:New(activityCode)

    self.managers[activityCode] = manager
    self.groupManagers[manager:GetCategoryCode()][manager] = true
    self.groupManagers[manager:GetGroupCode()][manager]    = true
    self.groupManagers[manager:GetActivityCode()][manager] = true

    return manager
end

function Recent:GetRecentManager(activityCode)
    return self.managers[activityCode] or self:NewRecentManager(activityCode)
end

function Recent:BroadcastInfo()
    if not IsInGroup(LE_PARTY_CATEGORY_HOME) then
        return
    end
    if not self:GetCurrentActivity() then
        return
    end

    self:SendSocket('@GROUP', 'RECENT_INFO',
        GetPlayerBattleTag(),
        GetPlayerItemLevel()
    )
end

function Recent:MEETINGSTONE_DB_SHUTDOWN()
    for activityCode, manager in pairs(self.managers) do
        Profile:SetRecentDB(activityCode, manager:ToDB())
    end
end

function Recent:RECENT_INFO(_, name, battleTag, itemLevel)
    local activity = self:GetCurrentActivity()
    if not activity then
        return
    end

    local player = self:GetRecentManager(activity:GetCode()):GetUnit(GetFullName(name))
    if not player then
        return
    end

    player:SetBattleTag(battleTag)
    player:SetItemLevel(itemLevel)
end

function Recent:GetCurrentActivity()
    return self.activity
end

function Recent:LFG_LIST_ACTIVE_ENTRY_UPDATE()
    if C_LFGList.HasActiveEntryInfo() then
        local activity = CreatePanel:GetCurrentActivity()
        if not activity:IsSoloActivity() then
            self.activity = CreatePanel:GetCurrentActivity()
        end
    else
        self:ScheduleTimer(function()
            self.activity = nil
        end, 300)
    end
end

function Recent:GROUP_ROSTER_UPDATE()
    if not IsInGroup(LE_PARTY_CATEGORY_HOME) then
        return self:SendMessage('MEETINGSTONE_GROUP_CLOSED')
    end
    self:SendMessage('MEETINGSTONE_MEMBER_UPDATE')
end

function Recent:MEETINGSTONE_GROUP_CLOSED()
    self:CancelAllTimers()
    self.activity = nil
end

function Recent:CacheRecent()
    local activity = self:GetCurrentActivity()
    if not activity then
        return
    end

    local manager = self:GetRecentManager(activity:GetCode())

    for _, unit in IterateGroupUnits() do
        if UnitExists(unit) and UnitName(unit) ~= UnitName('none') and not UnitIsUnit(unit, 'player') then
            local name = UnitFullName(unit)
            local player = manager:GetUnit(name) or RecentPlayer:New(manager)

            player:SetName(name)
            player:SetClass(select(3, UnitClass(unit)))
            player:SetRole(UnitGroupRolesAssigned(unit))
            player:SetIsLeader(UnitIsGroupLeader(unit, LE_PARTY_CATEGORY_HOME) or nil)
            player:SetTime(time())

            manager:AddUnit(player)
        end
    end
end

function Recent:GetRecentList(code)
    local list = {}
    for manager in pairs(self.groupManagers[code]) do
        for _, player in manager:IteratePlayers() do
            tinsert(list, player)
        end
    end
    return list
end
