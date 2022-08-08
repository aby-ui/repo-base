-- QuestPanel.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 4/19/2021, 9:45:22 AM
--
BuildEnv(...)

if not ADDON_REGIONSUPPORT then
    return
end

local Frame = CreateFrame('Frame', nil, nil, 'MeetingStoneQuestPanelTemplate')

---@class QuestPanel: AceAddon,AceEvent,Frame
QuestPanel = Addon:NewModule(Frame, 'QuestPanel', 'AceEvent-3.0')

function QuestPanel:OnInitialize()
    self.Quests = GUI:GetClass('ListView'):Bind(self.Body.Quests)
    self.Quests:SetItemClass(QuestItem)
    self.Quests:SetItemHeight(55)
    self.Quests:SetCallback('OnItemFormatted', function(_, button, item)
        button:SetQuest(item)
    end)
    ---@param item Quest
    self.Quests:SetCallback('OnItemRewardClick', function(_, button, item)
        if item:IsCompleted() and not item.rewarded then
            QuestServies:SendServer('QCF', UnitGUID('player'), item.id)
        end
    end)

    CountdownButton:Bind(self.Body.Refresh)

    self.Body.Refresh:SetScript('OnClick', function(button)
        QuestServies:QueryQuestProgress()
        QuestServies:QueryScore()
        button:SetCountdown(10)
    end)

    self:RegisterMessage('MEETINGSTONE_QUEST_FETCHED')
    self:RegisterMessage('MEETINGSTONE_QUEST_UPDATE', 'MEETINGSTONE_QUEST_FETCHED')
end

function QuestPanel:MEETINGSTONE_QUEST_FETCHED()
    if not self:IsVisible() then
        return
    end
    local questGroup = QuestServies.questGroup
    self.Body.Time:SetFormattedText('活动时间：%s - %s', date('%Y/%m/%d %H:%M', questGroup.startTime),
                                    date('%Y/%m/%d %H:%M', questGroup.endTime))
    self.Quests:SetItemList(questGroup.quests)
    self.Quests:Refresh()

    local localQuestData = QUEST_GROUP_DATA[questGroup.id]
    if localQuestData then
        self.Summary.Text:SetText(localQuestData.summary or '')

        if localQuestData.extern then
            self.Body.Extern:Show()
            self.Body.Extern:SetText(localQuestData.extern)
            ApplyUrlButton(self.Body.Extern, localQuestData.url)
        else
            self.Body.Extern:Hide()
        end

        if localQuestData.score then
            self:RegisterMessage('MEETINGSTONE_UPDATE_SCORE')
            self.Body.ScoreLabel:Show()
        else
            self.Body.ScoreLabel:Hide()
        end
    end
end

function QuestPanel:MEETINGSTONE_UPDATE_SCORE(name, score)
    local questGroup = QuestServies.questGroup
    if questGroup then
        local localQuestData = QUEST_GROUP_DATA[questGroup.id]
        if localQuestData and localQuestData.score then
            self.Body.ScoreLabel:SetText(localQuestData.score .. score)
        end
    end
end
