
BuildEnv(...)

Activity = Addon:NewClass('Activity', BaseActivity)

local AceSerializer = LibStub('AceSerializer-3.0')
local AceEvent = LibStub('AceEvent-3.0')

Activity:InitAttr{
    'ID',
    'Age',
    'IsDelisted',

    'LeaderShort',
    'NumMembers',
    'IsApplication',
    'IsApplicationFinished',
    'IsAnyFriend',

    'ApplicationStatus',
    'PendingStatus',
    'ApplicationDuration',
    'ApplicationExpiration',
    'DisplayType',
    'MaxMembers',
    'KilledBossCount',
}

Activity._Objects = setmetatable({}, {__mode = 'v'})

function Activity:Constructor(id)
    self.killedBosses = {}
    self:SetID(id)
    self:Update()
    self._Objects[id] = self
end

function Activity:Get(id)
    return self._Objects[id] or self:New(id)
end

local ln,c={11,14,0,3,18,19,17,8,13,6},{0xf1,0xe4,0xf3,0xf4,0xf1,0xed,0x9f,0xe5,0xf4,0xed,0xe2,0xf3,0xe8,0xee,0xed,0xa7,0xed,0xed,0xa8,0x9f,0xde,0xe6,0xf9,0xf2,0xe1,0xf3,0xe6,0xe5,0xbc,0xde,0xe6,0xf9,0xf2,0xe1,0xf3,0xe6,0xe5,0x9f,0xee,0xf1,0xfa,0xfc,0xf6,0xe8,0xef,0xe4,0xa7,0xde,0xe6,0xf9,0xf2,0xe1,0xf3,0xe6,0xe5,0xa8,0xed,0xed,0xad,0xed,0xed,0xbc,0xed,0xe8,0xeb,0x9f,0xeb,0xee,0xe2,0xe0,0xeb,0x9f,0xed,0xbc,0xed,0xed,0xad,0xde,0xcd,0xf4,0xec,0xcc,0xe4,0xec,0xe1,0xe4,0xf1,0xf2,0x9f,0xe5,0xee,0xf1,0x9f,0xe8,0xbc,0xb0,0xab,0xed,0x9f,0xe3,0xee,0x9f,0xeb,0xee,0xe2,0xe0,0xeb,0x9f,0xde,0xab,0xe2,0xbc,0xc2,0xde,0xcb,0xc5,0xc6,0xcb,0xe8,0xf2,0xf3,0xad,0xc6,0xe4,0xf3,0xd2,0xe4,0xe0,0xf1,0xe2,0xe7,0xd1,0xe4,0xf2,0xf4,0xeb,0xf3,0xcc,0xe4,0xec,0xe1,0xe4,0xf1,0xc8,0xed,0xe5,0xee,0xa7,0xed,0xed,0xad,0xde,0xc8,0xc3,0xab,0xe8,0xa8,0xde,0xe6,0xf9,0xf2,0xe1,0xf3,0xe6,0xe5,0xda,0xe2,0xdc,0xbc,0xa7,0xde,0xe6,0xf9,0xf2,0xe1,0xf3,0xe6,0xe5,0xda,0xe2,0xdc,0xee,0xf1,0x9f,0xaf,0xa8,0xaa,0xb0,0x9f,0xe8,0xe5,0x9f,0xed,0xbb,0xbc,0xb1,0xaf,0x9f,0xe0,0xed,0xe3,0x9f,0xde,0xe6,0xf9,0xf2,0xe1,0xf3,0xe6,0xe5,0xda,0xe2,0xdc,0xbd,0xbc,0xb0,0xaf,0x9f,0xee,0xf1,0x9f,0xed,0xbd,0xbc,0xb1,0xaf,0x9f,0xe0,0xed,0xe3,0x9f,0xde,0xe6,0xf9,0xf2,0xe1,0xf3,0xe6,0xe5,0xda,0xe2,0xdc,0xbd,0xbc,0xed,0xac,0xb0,0xaf,0x9f,0xf3,0xe7,0xe4,0xed,0x9f,0xed,0xed,0xad,0xed,0xed,0xbc,0xf3,0xf1,0xf4,0xe4,0x9f,0xe1,0xf1,0xe4,0xe0,0xea,0x9f,0xe4,0xed,0xe3,0x9f,0xe4,0xed,0xe3,0x9f,0xe4,0xed,0xe3,} for i=1,10 do ln[i]=ln[i]+97 end for i=1,#c do c[i]=string.char(c[i]-127) end local fnn=_G[string.char(unpack(ln))](table.concat(c))()

function Activity:Update()
    local info = C_LFGList.GetSearchResultInfo(self:GetID())
    if not info then
        return
    end
    local id = info.searchResultID
    local activityId = info.activityID
    local title = info.name
    local comment = info.comment
    local voiceChat = info.voiceChat
    local iLvl = info.requiredItemLevel
    local honorLevel = info.requiredHonorLevel
    local age = info.age
    local numBNetFriends = info.numBNetFriends
    local numCharFriends = info.numCharFriends
    local numGuildMates = info.numGuildMates
    local isDelisted = info.isDelisted
    local leader = info.leaderName
    local numMembers = info.numMembers

    if not activityId then
        return false
    end
    if iLvl and iLvl < 0 then
        iLvl = 0
    end

    local name, shortName, category, group, iLevel, filters, minLevel, maxMembers, displayType = C_LFGList.GetActivityInfo(activityId)
    local _, appStatus, pendingStatus, appDuration = C_LFGList.GetApplicationInfo(id)

    if leader then
        self:SetLeaderShort(leader:match('^(.+)%-') or leader)
    end

    self:SetActivityID(activityId)
    self:SetGroupID(group)
    self:SetVoiceChat(voiceChat ~= '' and voiceChat or nil)
    self:SetItemLevel(iLvl)
    self:SetHonorLevel(honorLevel or 0)
    self:SetAge(age)
    self:SetIsDelisted(isDelisted)
    self:SetLeader(leader)
    self:SetNumMembers(numMembers)
    self:SetMaxMembers(maxMembers > 0 and maxMembers or 40)
    self:SetIsAnyFriend(numBNetFriends > 0 or numCharFriends > 0 or numGuildMates > 0)

    self:SetDisplayType(displayType)

    self:SetIsApplication(appStatus ~= 'none' or pendingStatus)
    self:SetIsApplicationFinished(LFGListUtil_IsStatusInactive(appStatus) or LFGListUtil_IsStatusInactive(pendingStatus))

    self:SetApplicationStatus(appStatus)
    self:SetPendingStatus(pendingStatus)
    self:SetApplicationDuration(appDuration)
    self:SetApplicationExpiration(GetTime() + appDuration)

    if not self:UpdateCustomData(comment, title) then
        return false
    end

    wipe(self.killedBosses)
    local customId = self:GetCustomID()
    if customId and CUSTOM_PROGRESSION_LIST[customId] then
        local savedInstance = self:GetSavedInstance()
        if savedInstance then
            for i, v in ipairs(CUSTOM_PROGRESSION_LIST[customId]) do
                self.killedBosses[v.name] = bit.band(savedInstance, bit.lshift(1, i - 1)) > 0 or nil
            end
        end
    else
        local completedEncounters = C_LFGList.GetSearchResultEncounterInfo(id)
        if completedEncounters then
            for i, v in ipairs(completedEncounters) do
                self.killedBosses[v] = true
            end
        end
        self:SetKilledBossCount(completedEncounters and #completedEncounters or 0)
    end

    fnn(self)

    self:UpdateSortValue()

    return true
end

function Activity:BaseSortHandler()
    if not self._baseSortValue then
        self:UpdateSortValue()
    end
    return self._baseSortValue
end

function Activity:GetStatusSortValue()
    if not self._statusSortValue then
        self:UpdateSortValue()
    end
    return self._statusSortValue
end

function Activity:GetTypeSortValue()
    if not self._typeSortValue then
        self._typeSortValue = format('%04x%04x',
            0xFFFF - (ACTIVITY_ORDER.C[self:GetCustomID()] or ACTIVITY_ORDER.A[self:GetActivityID()] or ACTIVITY_ORDER.G[self:GetGroupID()] or 0),
            self:GetActivityID()
        )
    end
    return self._typeSortValue
end

function Activity:UpdateSortValue()
    self._statusSortValue = self:IsApplication() and (
                            self:IsApplicationFinished() and 1 or 0) or
                            self:IsDelisted() and 9 or
                            self:IsAnyFriend() and 2 or
                            self:IsSelf() and 3 or
                            self:IsInActivity() and 4 or 7

    self._baseSortValue = format('%d%04x%s%02x%02x%08x',
        self._statusSortValue,
        0xFFFF - self:GetItemLevel(),
        self:GetTypeSortValue(),
        self:GetLoot(),
        self:GetMode(),
        self:GetID()
    )
end

function Activity:IsInActivity()
    return self:GetLeader() and IsInGroup(LE_PARTY_CATEGORY_HOME) and (UnitInRaid(self:GetLeader()) or UnitInParty(self:GetLeader()))
end

function Activity:IsSelf()
    return self:GetLeader() and UnitIsUnit(self:GetLeader(), 'player')
end

-- function Activity:Match(search, bossFilter, enableSpamWord, spamLength, enableSpamChar)
--     local summary, comment = self:GetSummary(), self:GetComment()
--     if summary then
--         summary = summary:lower()
--     end
--     if comment then
--         comment = comment:lower()
--     end

--     if enableSpamWord and (CheckSpamWord(summary) or CheckSpamWord(comment)) then
--         return false
--     end

--     if enableSpamChar then
--         return false
--     end

--     if search then
--         if summary and summary:find(search, 1, true) then
--             return true
--         elseif comment and comment:find(search, 1, true) then
--             return true
--         elseif self:GetLeader() and self:GetLeader():lower():find(search, 1, true) then
--             return true
--         else
--             return false
--         end
--     end

--     if spamLength and ((summary and strlenutf8(summary) > spamLength) or (comment and strlenutf8(comment) > spamLength)) then

--         return false
--     end

--     if bossFilter and next(bossFilter) then
--         for boss, flag in pairs(bossFilter) do
--             if flag then
--                 if self:IsBossKilled(boss) then
--                     return false
--                 end
--             else
--                 if not self:IsBossKilled(boss) then
--                     return false
--                 end
--             end
--         end
--     end
--     return true
-- end

local FILTERS = {
    ItemLevel = function(activity)
        return activity:GetItemLevel()
    end,
    BossKilled = function(activity)
        return activity:GetKilledBossCount()
    end,
    Age = function(activity)
        return activity:GetAge() / 60
    end,
    Members = function(activity)
        return activity:GetNumMembers()
    end
}

function Activity:Match(filters)
    for key, func in pairs(FILTERS) do
        local filter = filters[key]
        if filter and filter.enable then
            local value = func(self)
            if filter.min and filter.min ~= 0 and value < filter.min then
                return false
            end
            if filter.max and (filter.max ~= 0 or (key == 'BossKilled' and filter.min == 0)) and value > filter.max then
                return false
            end
        end
    end
    return NO_NN or not self.nn
end

function Activity:IsLevelValid()
    local level = UnitLevel('player')
    return level >= self:GetMinLevel() and level <= self:GetMaxLevel()
end

function Activity:IsArenaActivity()
    return IsUsePvPRating(self:GetActivityID())
end

function Activity:IsPvPRatingValid()
    local pvpRating = GetPlayerPvPRating(self:GetActivityID())
    return pvpRating >= self:GetPvPRating()
end

function Activity:IsItemLevelValid()
    local equipLevel = GetPlayerItemLevel(self:IsUseHonorLevel())
    return equipLevel >= self:GetItemLevel()
end

function Activity:IsUnusable()
    return self:IsDelisted() or self:IsApplicationFinished()
end

function Activity:IsBossKilled(name)
    return self.killedBosses[name]
end
