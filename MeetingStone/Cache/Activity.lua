
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

function Activity:Update()
    local id, activityId, title, comment, voiceChat, iLvl, honorLevel, age,
        numBNetFriends, numCharFriends, numGuildMates, isDelisted, leader, numMembers = C_LFGList.GetSearchResultInfo(self:GetID())

    if not activityId then
        return false
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
    end

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

    self._baseSortValue = format('%d%s%04x%02x%02x%08x',
        self._statusSortValue,
        self:GetTypeSortValue(),
        0xFFFF - self:GetItemLevel(),
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

function Activity:Match(search, bossFilter, enableSpamWord, spamLength, enableSpamChar)
    local summary, comment = self:GetSummary(), self:GetComment()
    if summary then
        summary = summary:lower()
    end
    if comment then
        comment = comment:lower()
    end

    if enableSpamWord and (CheckSpamWord(summary) or CheckSpamWord(comment)) then
        return false
    end

    if enableSpamChar then
        return false
    end

    --163ui code from nga
    local activityItem=MeetingStone_BrowsePanel:GetCurrentActivity()
    if activityItem and activityItem.activityId and not ACTIVITY_CUSTOM_DATA.A[activityItem.activityId] then
        if activityItem.activityId ~= self:GetActivityID() or activityItem.customId ~= self:GetCustomID() then
           return false
        end
    end
    local filterLevel = MeetingStone_BrowsePanel.LootDropdown:GetValue() or 0;
    if(not self:IsUseHonorLevel() and filterLevel > 0 and self:GetItemLevel() < filterLevel) then return false end

    if search then
        if summary and summary:find(search, 1, true) then
            return true
        elseif comment and comment:find(search, 1, true) then
            return true
        elseif self:GetLeader() and self:GetLeader():lower():find(search, 1, true) then
            return true
        else
            return false
        end
    end

    if spamLength and ((summary and strlenutf8(summary) > spamLength) or (comment and strlenutf8(comment) > spamLength)) then

        return false
    end

    if bossFilter and next(bossFilter) then
        for boss, flag in pairs(bossFilter) do
            if flag then
                if self:IsBossKilled(boss) then
                    return false
                end
            else
                if not self:IsBossKilled(boss) then
                    return false
                end
            end
        end
    end
    return true
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
