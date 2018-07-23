
BuildEnv(...)

Misc = Addon:NewModule('Misc', 'AceHook-3.0')

local MAX_IGNORE_LIST = 50

local events = {
    'CHAT_MSG_ACHIEVEMENT',
    'CHAT_MSG_BATTLEGROUND',
    'CHAT_MSG_BATTLEGROUND_LEADER',
    'CHAT_MSG_CHANNEL',
    'CHAT_MSG_CHANNEL_JOIN',
    'CHAT_MSG_CHANNEL_LEAVE',
    'CHAT_MSG_EMOTE',
    'CHAT_MSG_GUILD',
    'CHAT_MSG_GUILD_ACHIEVEMENT',
    'CHAT_MSG_OFFICER',
    'CHAT_MSG_PARTY',
    'CHAT_MSG_RAID',
    'CHAT_MSG_RAID_LEADER',
    'CHAT_MSG_RAID_WARNING',
    'CHAT_MSG_SAY',
    'CHAT_MSG_SYSTEM',
    'CHAT_MSG_TEXT_EMOTE',
    'CHAT_MSG_WHISPER',
    'CHAT_MSG_WHISPER_INFORM',
    'CHAT_MSG_YELL',
}

local function chatMessageFilter(self, event, message, from)
    return from and Profile:IsIgnored(from)
end

function Misc:OnInitialize()
    self:Disable()
end

function Misc:OnEnable()
    for i, v in ipairs(events) do
        ChatFrame_AddMessageEventFilter(v, chatMessageFilter)
    end

    self:RawHook('AddOrDelIgnore', true)
    self:RawHook('GetNumIgnores', true)
    self:RawHook('DelIgnore', true)
    self:RawHook('AddIgnore', true)
    self:RawHook('GetIgnoreName', true)
    self:RawHook('GetSelectedIgnore', true)
    self:RawHook('SetSelectedIgnore', true)
    self:RawHook('IsIgnored', true)
    self:Hook('ChatFrame_OnHyperlinkShow', true)
end

function Misc:OnDisable()
    for i, v in ipairs(events) do
        ChatFrame_RemoveMessageEventFilter(v, chatMessageFilter)
    end

    self:Unhook('AddOrDelIgnore')
    self:Unhook('GetNumIgnores')
    self:Unhook('DelIgnore')
    self:Unhook('AddIgnore')
    self:Unhook('GetIgnoreName')
    self:Unhook('GetSelectedIgnore')
    self:Unhook('SetSelectedIgnore')
    self:Unhook('IsIgnored')
    self:Unhook('ChatFrame_OnHyperlinkShow')
    self.selectedIgnore = nil
end

function Misc:GetNumIgnores()
    return self.hooks.GetNumIgnores() + Profile:GetNumIgnores()
end

function Misc:ChangeIgnoreName(name)
    return Ambiguate(ChatTargetAppToSystem(name), 'none')
end

function Misc:DelIgnore(name)
    if not name then
        return
    end

    if type(name) == 'number' then
        name = self:GetIgnoreName(name)
    end

    name = self:ChangeIgnoreName(name)

    if self.hooks.IsIgnored(name) then
        self.hooks.DelIgnore(name)
    elseif Profile:IsIgnored(name) then
        Profile:DelIgnore(name)
        IgnoreList_Update()
    end
end

function Misc:IsIgnored(name)
    if not name then
        return false
    end
    if UnitExists(name) then
        name = UnitFullName(name)
    end

    name = self:ChangeIgnoreName(name)

    return self.hooks.IsIgnored(name) or Profile:IsIgnored(name)
end

function Misc:AddIgnore(name)
    if not name then
        return
    end

    local name = self:ChangeIgnoreName(name)

    if self:IsIgnored(name) then
        SendSystemMessage(format(ERR_IGNORE_ALREADY_S, name))
    else
        if self.hooks.GetNumIgnores() < MAX_IGNORE_LIST then
            self.hooks.AddIgnore(name)
        else
            Profile:AddIgnore(name)
            SendSystemMessage(format(ERR_IGNORE_ADDED_S, name))
            IgnoreList_Update()
        end
    end
end

function Misc:GetIgnoreName(index)
    if not index then
        return
    end

    local num = self.hooks.GetNumIgnores()
    if index > num then
        return Profile:GetIgnoreName(index - num)
    else
        return self.hooks.GetIgnoreName(index)
    end
end

function Misc:AddOrDelIgnore(name)
    if not name then
        return
    end

    if self:IsIgnored(name) then
        self:DelIgnore(name)
    else
        self:AddIgnore(name, log)
        Logic:AddIgnore(name, self:GetChatLog(name))
    end
end

function Misc:GetChatLog(name)
    local chatFrame, link = self:PopLink()

    if not chatFrame or not link or not name then
        return
    end

    if not link:match(name:gsub('-', '%%-')) then
        return
    end

    local text = link:gsub('([%[%]-])', '%%%1')
    for i = chatFrame:GetNumMessages(), 1, -1 do
        local rawText = chatFrame:GetMessageInfo(i)
        if rawText:match(text) then
            return rawText
        end
    end
end

function Misc:GetSelectedIgnore()
    return self:GetNumIgnores() > 0 and self.selectedIgnore or self.hooks.GetSelectedIgnore()
end

function Misc:SetSelectedIgnore(index)
    self.selectedIgnore = index
end

function Misc:ChatFrame_OnHyperlinkShow(chatFrame, link, text, button)
    self._chatFrame = chatFrame
    self._link = link
end

function Misc:PopLink()
    local link = self._link
    local chatFrame = self._chatFrame
    self._link = nil
    self._chatFrame = nil
    return chatFrame, link
end
