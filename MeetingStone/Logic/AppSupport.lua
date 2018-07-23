--[[
@Date    : 2016-06-12 10:47:29
@Author  : DengSir (ldz5@qq.com)
@Link    : https://dengsir.github.io
@Version : $Id$
]]


BuildEnv(...)

AppSupport = Addon:NewModule('AppSupport', 'AceEvent-3.0', 'AceHook-3.0', 'AceBucket-3.0', 'AceTimer-3.0')
AppSupport:Disable()

function AppSupport:OnEnable()
    self:GroupMemberInit()
    self:GuildMOTDInit()
    self:StatInit()
    self:ChallengeInit()
    self:DataInit()
    self:RaidInit()
end

function AppSupport:OnDisable()
    self.inviter = nil
    self.prevGroupType = nil
end

---- Stat

function AppSupport:StatInit()
    local prevStatCache = {}
    local statApis = {}

    local function GetCacheKey(key, id)
        return id and format('%s.%d', key, id) or key
    end

    local function RegisterStat(key, event, api)
        self:RegisterBucketEvent(event, COMMIT_INTERVAL, function()
            local value, id = api()
            if not value then
                return
            end
            local cacheKey = GetCacheKey(key, id)
            if not prevStatCache[cacheKey] or value ~= prevStatCache[cacheKey] then
                prevStatCache[cacheKey] = value
                App:SendServer('APP_STATISTIC', key, value, id)
            end
        end)
        statApis[key] = api
    end

    ---- PVP Killed
    RegisterStat('PvpKilled', 'PLAYER_PVP_KILLS_CHANGED', function()
        return tonumber((GetStatistic(588)))
    end)

    ---- ItemLevel
    RegisterStat('ItemLevel', 'PLAYER_AVG_ITEM_LEVEL_UPDATE', function()
        return floor(GetAverageItemLevel())
    end)

    ---- Quest
    -- RegisterStat('QuestCount', 'QUEST_FINISHED', function()
    --     local completed = GetQuestsCompleted()
    --     local count = 0
    --     for _, id in ipairs(QUEST_LIST) do
    --         if completed[id] then
    --             count = count + 1
    --         end
    --     end
    --     return count
    -- end)

    -- RegisterStat('OrderHallQuestCount', 'GARRISON_MISSION_COMPLETE_RESPONSE', function()
    --     return tonumber((GetStatistic(11236)))
    -- end)

    ---- Achievement
    -- RegisterStat('AchievementPoint', 'ACHIEVEMENT_EARNED', function()
    --     local value = 0
    --     for id = 10439, 13000 do
    --         local _, _, points, completed, _, _, _, _, _, _, _, isGuild = GetAchievementInfo(id)
    --         if not isGuild and completed then
    --             value = value + points
    --         end
    --     end
    --     return value
    -- end)

    ---- Mount
    -- RegisterStat('MountCount', 'COMPANION_LEARNED', function()
    --     local count = 0
    --     for _, mountId in ipairs(C_MountJournal.GetMountIDs()) do
    --         local _, id, _, _, _, _, _, _, _, _, collected = C_MountJournal.GetMountInfoByID(mountId)
    --         if collected and MOUNT_MAP[id] then
    --             count = count + 1
    --         end
    --     end
    --     return count
    -- end)

    ----
    -- RegisterStat('ArtifactPower', {'ARTIFACT_XP_UPDATE', 'PLAYER_EQUIPMENT_CHANGED'}, function()
    --     local count = 0
    --     local id, _, _, _, xp, pointsSpent, _, _, _, _, _, _, artifactTier = C_ArtifactUI.GetEquippedArtifactInfo()
    --     if not id then
    --         return
    --     end
    --     for i = 1, pointsSpent - 1 do
    --         count = count + C_ArtifactUI.GetCostForPointAtRank(i, artifactTier)
    --     end
    --     return count + xp, id
    -- end)

    for key, api in pairs(statApis) do
        local value, id = api()
        if value then
            prevStatCache[GetCacheKey(key, id)] = value
        end
    end
    App:SendServer('APP_STATISTIC_INIT', prevStatCache)
end

---- App Data

function AppSupport:DataInit()
    local function RegisterData(key, events, fn, interval, all)
        local val
        local function cb(...)
            local newval = fn(...)
            if newval and (all or newval ~= val) then
                val = newval
                App:SendServer('APP_DATA', key, val)
            end
        end

        if type(events) == 'table' and (not interval or interval <= 0) then
            interval = 1
        end

        if interval and interval > 0 then
            self:RegisterBucketEvent(events, interval, cb)
        else
            self:RegisterEvent(events, cb)
        end
    end

    local function GetLegendaryItem(_, msg, _, _, _, unit)
        if not UnitIsUnit('player', unit) then
            return
        end
        local item = msg:match('(|cff%x%x%x%x%x%x|Hitem:.+|r)')
        if not item then
            return
        end
        local name, _, quality, itemLevel, reqLevel = GetItemInfo(item)
        if not name then
            return
        end
        return quality == LE_ITEM_QUALITY_LEGENDARY and itemLevel >= 940 and IsEquippableItem(item) and item
    end

    RegisterData('Zone', {'ZONE_CHANGED_NEW_AREA', 'ZONE_CHANGED_INDOORS', 'ZONE_CHANGED'}, GetZoneText, COMMIT_INTERVAL)
    -- RegisterData('ItemPush2', 'CHAT_MSG_LOOT', GetLegendaryItem, 0, true)
end

---- Group Member

function AppSupport:GroupMemberInit()
    self.groupMembers = {}
    self:RegisterEvent('PARTY_INVITE_REQUEST')
    self:RegisterBucketEvent('GROUP_ROSTER_UPDATE', 1)
    self:SecureHook('DeclineGroup')
    self:SecureHook('AcceptGroup')
    self:RegisterBucketMessage('APP_GROUP_MEMBER', COMMIT_INTERVAL)
end

function AppSupport:ClearInviter()
    self.inviter = nil
    self:CancelTimer(self.inviterTimer)
end

function AppSupport:SetInviter(inviter)
    self.inviter = inviter
    self.inviterTimer = self:ScheduleTimer(function()
        self.inviter = nil
    end, 120)
end

function AppSupport:PARTY_INVITE_REQUEST(_, inviter)
    self:SetInviter(GetFullName(inviter))
end

function AppSupport:AcceptGroup()
    if self.inviter then
        self:SaveMember(self.inviter, true)
        self:ClearInviter()
    end
end

function AppSupport:DeclineGroup()
    self:ClearInviter()
end

function AppSupport:GetGroupLeader(groupType)
    if IsInRaid(groupType or self:GetGroupType()) then
        for i = 1, 40 do
            local unit = 'raid' .. i
            if UnitIsGroupLeader(unit) then
                return UnitFullName(unit)
            end
        end
    else
        for i = 1, 4 do
            local unit = 'party' .. i
            if UnitIsGroupLeader(unit) then
                return UnitFullName(unit)
            end
        end
    end
end

function AppSupport:GetGroupType()
    return IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and LE_PARTY_CATEGORY_INSTANCE or IsInGroup(LE_PARTY_CATEGORY_HOME) and LE_PARTY_CATEGORY_HOME
end

function AppSupport:APP_GROUP_MEMBER()
    if not next(self.groupMembers) then
        return
    end
    local list = {} do
        for _, v in pairs(self.groupMembers) do
            tinsert(list, {
                name = v.name,
                role = v.role,
                guid = self:FindMemberGUID(v.name),
            })
        end
    end
    App:SendServer('APP_GROUP_MEMBER', list)
    wipe(self.groupMembers)
end

function AppSupport:FindMemberGUID(name)
    for i = 1, 4 do
        local unit = 'party' .. i
        if UnitExists(unit) and UnitFullName(unit) == name then
            return UnitGUID(unit)
        end
    end
    for i = 1, 40 do
        local unit = 'raid' .. i
        if UnitExists(unit) and UnitFullName(unit) == name then
            return UnitGUID(unit)
        end
    end
    return false
end

function AppSupport:GROUP_ROSTER_UPDATE()
    local groupType = self:GetGroupType()
    if self.prevGroupType ~= groupType then
        self.prevGroupType = groupType
        local leader = self:GetGroupLeader(groupType)
        if leader then
            self:SaveMember(leader, false)
        end
    end
end

function AppSupport:SaveMember(target, is_inviter)
    local role = is_inviter and 1 or 2
    local key = format('%s:%d', target, role)
    self.groupMembers[key] = {
        name = target,
        role = role,
    }
    self:SendMessage('APP_GROUP_MEMBER')
end

---- Guild MOTD

function AppSupport:GuildMOTDInit()
    self:RegisterBucketMessage('GUILD_MOTD', COMMIT_INTERVAL)
    self:SecureHook('GuildSetMOTD')
end

function AppSupport:GuildSetMOTD(text)
    self:SendMessage('GUILD_MOTD')
end

function AppSupport:GUILD_MOTD()
    App:SendServer('APP_GUILD_MOTD', GetGuildName(), GetGuildRosterMOTD())
end

----

local UnitRole do
    local ROLE_TYPES = { TANK = 1, HEALER = 2, DAMAGER = 3, }
    function UnitRole(unit)
        return ROLE_TYPES[UnitGroupRolesAssigned(unit)] or 0
    end
end

function AppSupport:CHALLENGE_MODE_COMPLETED()
    local _, level, time = C_ChallengeMode.GetCompletionInfo()
    local mapId = C_ChallengeMode.GetActiveChallengeMapID() or self.lastMapId

    local class = select(3, UnitClass('player'))
    local itemLevel = math.floor( select(2, GetAverageItemLevel()) )
    local combatData = CombatStat:GetCombatData()

    

    App:SendServer('APP_CHALLENGE2', mapId, level, time, class, itemLevel, UnitRole('player'), self:GetChallengeMembers(), combatData)
    CombatStat:Disable()
    self.lastMapId = nil
end

function AppSupport:CHALLENGE_MODE_START()
    CombatStat:Reset()
    self:StartCombatStat()
end

function AppSupport:GetChallengeMembers()
    local members = {}

    for i = 1, 4 do
        local unit = 'party' .. i
        if UnitExists(unit) then
            local name  = UnitFullName(unit)
            local class = select(3, UnitClass(unit))
            local role  = UnitRole(unit)
            local guid  = UnitGUID(unit)
            local item  = format('%s.%d.%d.%s', name, class, role, guid)

            tinsert(members, item)
        end
    end
    return members
end

function AppSupport:ChallengeInit()
    self:RegisterEvent('CHALLENGE_MODE_COMPLETED')
    self:RegisterEvent('CHALLENGE_MODE_START')
    self:StartCombatStat()
end

function AppSupport:StartCombatStat()
    self.lastMapId = C_ChallengeMode.GetActiveChallengeMapID() or self.lastMapId
    if self.lastMapId then
        CombatStat:Enable()
    end
end

---- raid

function AppSupport:RaidInit()
    self:RegisterEvent('ENCOUNTER_END')
    self:RegisterEvent('ENCOUNTER_START')
end

function AppSupport:ENCOUNTER_START(_, id, name, difficulty, size)
    if not self:GetInstanceId() then
        
        return
    end
    CombatStat:Reset()
    CombatStat:Enable()
    self.encounterStartStamp = time()
    
end

function AppSupport:ENCOUNTER_END(_, bossId, name, difficulty, maxPlayers, status)
    local instanceId = self:GetInstanceId()
    if not instanceId then
        return
    end
    if status == 1 then
        local class = select(3, UnitClass('player'))
        local itemLevel = math.floor( select(2, GetAverageItemLevel()) )
        local combatData = CombatStat:GetCombatData()
        local hash, leaderGuid = self:GetRaidInfo()

        App:SendServer('APP_RAID', instanceId, bossId, difficulty, maxPlayers, class, itemLevel, hash, leaderGuid, combatData, UnitRole('player'), time() - self.encounterStartStamp)
        
    end
    CombatStat:Disable()
end

function AppSupport:GetInstanceId()
    local name, type, difficulty, _, maxPlayers, _, isDynamicInstance, mapId, instanceGroupSize = GetInstanceInfo()
    return APP_RAID_DIFFICULTIES[difficulty] and APP_RAID_MAPS[mapId] and mapId or nil
end

function AppSupport:GetRaidInfo()
    local units = {}
    local leaderGuid
    local hash
    local hasError = false

    for _, unit in IterateGroupUnits() do
        if UnitExists(unit) then
            local guid = UnitGUID(unit)
            if guid then
                if UnitIsGroupLeader(unit) then
                    leaderGuid = guid
                end
                table.insert(units, unit)
            else
                hasError = true
            end
        end
    end

    if not hasError then
        table.sort(units)
        hash = crc32(table.concat(units, ',')), leaderGuid
    end
    return hash, leaderGuid
end
