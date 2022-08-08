-- QuestServies.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 3/3/2021, 1:43:41 PM
--
BuildEnv(...)

if not ADDON_REGIONSUPPORT then
    return
end

---@class QuestServies: AceAddon, AceEvent
QuestServies = Addon:NewModule('QuestServies', 'NetEaseSocket-2.0', 'AceEvent-3.0')
local QuestType = {Challenge = 1, GoldLeader = 2}

function QuestServies:OnInitialize()
    self:ListenSocket('NERB', ADDON_SERVER)
    self:ConnectServer()
end

function QuestServies:OnEnable()
    self:RegisterServer('QSQ')
    self:RegisterServer('QSP')
    self:RegisterServer('QSF')
    self:RegisterServer('QCS')
    self:RegisterServer('SERVER_CONNECTED')
end

function QuestServies:SERVER_CONNECTED()
    self.connected = true
    self:SendMessage('MEETINGSTONE_QUEST_CONNECTED')
end

function QuestServies:IsConnected()
    return self.connected
end

function QuestServies:IsQuering()
    return self.quering
end

function QuestServies:IsActive()
    return self.active
end

function QuestServies:QSQ(_, active, questGroupData, progressData)
    self.active = active
    self.questGroup = questGroupData and QuestGroup:FromProto(questGroupData)
    if self.questGroup then
        local localQuestData = QUEST_GROUP_DATA[self.questGroup.id]

        if localQuestData then
            self.questGroup:Fill(localQuestData.localQuest)
            self:QueryScore()
        end

        if progressData then
            self:QSP(nil, progressData)
        else
            self:SendMessage('MEETINGSTONE_QUEST_UPDATE')
        end

    end
    self.fetched = true
    self.quering = nil
    if self.queringTimer then
        self.queringTimer:Cancel()
        self.queringTimer = nil
    end

    self:SendMessage('MEETINGSTONE_QUEST_FETCHED')
end

function QuestServies:QSP(_, progress)
    for _, p in ipairs(progress) do
        local quest = self.questGroup:GetQuest(p[1])
        quest:UpdateProgress(unpack(p, 2))
    end

    self:SendMessage('MEETINGSTONE_QUEST_UPDATE')
end

function QuestServies:QSF(_, err, id)
    if err == 0 then
        local quest = self.questGroup.questMap[id]
        if quest then
            quest.rewarded = true
            self:SendMessage('MEETINGSTONE_QUEST_UPDATE')
        end
    end
end

function QuestServies:QueryQuestList()
    if not self.connected or self.fetched or self.quering then
        return
    end

    self.quering = true
    self.queringTimer = C_Timer.NewTimer(10, function()
        self.quering = nil
        self.queringTimer = nil
    end)

    self:SendServer('QCQ', UnitGUID('player'), ADDON_VERSION)
end

function QuestServies:QueryQuestProgress()
    self:SendServer('QCP', UnitGUID('player'))
end

function QuestServies:QueryScore()
    local localQuestData = QUEST_GROUP_DATA[self.questGroup.id]
    if localQuestData.score then
        self:SendServer('QCS', UnitGUID('player'))
    end
end

function QuestServies:QCS(_, score)
    self:SendMessage('MEETINGSTONE_UPDATE_SCORE', score)
end

QuestServies.QuestType = QuestType
