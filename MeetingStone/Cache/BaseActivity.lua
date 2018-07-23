
BuildEnv(...)

BaseActivity = Addon:NewClass('BaseActivity', Object)

BaseActivity:InitAttr{
    'ActivityID',
    'GroupID',
    'CustomID',
    'VoiceChat',
    'ItemLevel',
    'HonorLevel',
    'Name',

    'Summary',
    'Comment',
    'MinLevel',
    'MaxLevel',
    'PvPRating',
    'Source',

    'Mode',
    'Loot',
    'Version',
    'IsMeetingStone',

    'Leader',
    'LeaderClass',
    'LeaderItemLevel',
    'LeaderHonorLevel',
    'LeaderProgression',
    'LeaderPvPRating',

    'SavedInstance',
}

function BaseActivity:GetModeText()
    return GetModeName(self:GetMode())
end

function BaseActivity:GetLootShortText()
    return GetLootShortName(self:GetLoot())
end

function BaseActivity:GetLootText()
    return GetLootName(self:GetLoot())
end

function BaseActivity:GetLeaderText()
    return GetClassColoredText(self:GetLeaderClass(), self:GetLeader())
end

function BaseActivity:GetLeaderShortText()
    return GetClassColoredText(self:GetLeaderClass(), self:GetLeaderShort())
end

function BaseActivity:GetCode()
    return GetActivityCode(self:GetActivityID(), self:GetCustomID())
end

function BaseActivity:UpdateCustomData(comment, title)
    local valid, summary, proto = DecodeCommetData(comment)
    if not valid then
        return false
    end

    if proto then
        return false
    end

    if proto then
        local customId = proto:GetCustomID()
        if customId == 0 then
            customId = nil
        end
        local changeTo = ACTIVITY_CUSTOM_CHANGETO[customId]
        if changeTo then
            customId = nil
            self:SetActivityID(changeTo)
        end
        self:SetVersion(proto:GetVersion())
        self:SetMode(proto:GetMode())
        self:SetLoot(proto:GetLoot())
        self:SetSummary(summary)
        self:SetComment(nil)
        self:SetCustomID(customId)
        self:SetMinLevel(proto:GetMinLevel() or 1)
        self:SetMaxLevel(proto:GetMaxLevel() or MAX_PLAYER_LEVEL)
        self:SetPvPRating(proto:GetPvPRating() or 0)
        self:SetSource(proto:GetAddonSource())
        self:SetSavedInstance(proto:GetSavedInstance())
        self:SetIsMeetingStone(true)

        local check = proto:GetCheck()
        if check ~= nil and check ~= format('%s-%s-%s', self:GetModeText(), self:GetLootText(), self:GetName()) then
            
            return false
        end

        if title ~= format('%s-%s-%s-%s', L['集合石'], self:GetLootText(), self:GetModeText(), self:GetName()) then
            
            return false
        end

        creator = creator and Ambiguate(creator, 'none')
        if creator and creator ~= self:GetLeader() then
            self:SetLeaderClass(nil)
            self:SetLeaderItemLevel(nil)
            self:SetLeaderPvPRating(nil)
            self:SetLeaderProgression(nil)
            self:SetLeaderHonorLevel(nil)
        else
            self:SetLeaderClass(proto:GetLeaderClass())
            self:SetLeaderItemLevel(proto:GetLeaderItemLevel())
            self:SetLeaderPvPRating(proto:GetLeaderPvPRating())
            self:SetLeaderProgression(proto:GetLeaderProgression())
            self:SetLeaderHonorLevel(proto:GetLeaderHonorLevel())
        end
    else
        self:SetVersion(nil)
        self:SetMode(0xFF)
        self:SetLoot(0xFF)
        self:SetLeaderClass(nil)
        self:SetLeaderItemLevel(nil)
        self:SetLeaderProgression(nil)
        self:SetSummary(title)
        self:SetComment(summary)
        self:SetCustomID(nil)
        self:SetMinLevel(1)
        self:SetMaxLevel(MAX_PLAYER_LEVEL)
        self:SetPvPRating(0)
        self:SetSource(nil)
        self:SetSavedInstance(nil)
        self:SetIsMeetingStone(false)
    end

    return true
end

function BaseActivity:HasInvalidContent()
    return CheckContent(self:GetSummary()) or CheckContent(self:GetComment()) or CheckContent(self:GetVoiceChat())
end

function BaseActivity:CheckSpamWord()
    return CheckSpamWord(self:GetSummary()) or CheckSpamWord(self:GetComment()) or CheckSpamWord(self:GetVoiceChat())
end

function BaseActivity:GetName()
    return GetActivityName(self:GetActivityID(), self:GetCustomID())
end

function BaseActivity:GetShortName()
    return GetActivityShortName(self:GetActivityID(), self:GetCustomID())
end

function BaseActivity:IsUseHonorLevel()
    return IsUseHonorLevel(self:GetActivityID())
end

function BaseActivity:IsSoloActivity()
    return IsSoloCustomID(self:GetCustomID())
end

function BaseActivity:GetLeaderFullName()
    return GetFullName(self:GetLeader())
end

function BaseActivity:IsValidCustomActivity()
    local customId = self:GetCustomID()
    return not customId or ACTIVITY_CUSTOM_IDS[customId]
end
