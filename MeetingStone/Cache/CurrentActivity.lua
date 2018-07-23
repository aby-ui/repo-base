
BuildEnv(...)

CurrentActivity = Addon:NewClass('CurrentActivity', BaseActivity)

CurrentActivity:InitAttr{
    'Title',
    'PrivateGroup',
}

function CurrentActivity:FromAddon(data)
    local obj = CurrentActivity:New()
    obj:_FromAddon(data)
    return obj
end

function CurrentActivity:FromSystem(...)
    local obj = CurrentActivity:New()
    obj:UpdateBySystem(...)
    return obj
end

function CurrentActivity:_FromAddon(data)
    for k, v in pairs(data) do
        local func = self['Set' .. k]
        if type(func) == 'function' then
            func(self, v)
        end
    end
end

function CurrentActivity:UpdateBySystem(activityId, ilvl, honorLevel, title, comment, voiceChat, privateGroup)
    self:SetActivityID(activityId)
    self:SetItemLevel(ilvl)
    self:SetHonorLevel(honorLevel)
    self:SetVoiceChat(voiceChat)
    self:UpdateCustomData(comment, title)
    self:SetPrivateGroup(privateGroup)
end

function CurrentActivity:GetTitle()
    return format('%s-%s-%s-%s', L['集合石'], self:GetLootText(), self:GetModeText(), self:GetName())
end

function CurrentActivity:GetCreateArguments(autoAccept)
    local comment = CodeCommentData(self)
    return  self:GetActivityID(),
            self:GetItemLevel(),
            self:GetHonorLevel(),
            autoAccept,
            self:GetPrivateGroup()
end
