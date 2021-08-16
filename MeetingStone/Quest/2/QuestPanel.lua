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
        button:SetCountdown(10)
    end)

    self.Summary.Text:SetText([[1. 玩家可以自由组队完成“个人地下城周常”；
2. 玩家使用游戏内符合等级要求的钥石进行游戏即可参与挑战；
3. 玩家可在符合等级条件的任意地下城中完成任务；
4. 完成更高等级的任务会累计较低等级的任务进度；
5. 周常进度和奖励领取在每周副本CD更新时重置，请及时领取奖励，未领取视作放弃。为避免进度更新失败，请尽量避免临近CD更新时（每周四凌晨3点）完成任务。
6. 本次活动所有奖励在插件上领取，完成任务后可插件内领取奖励，若您在完成任务后超过72小时仍无法领取奖励，请联系人工客服进行反馈；
7. 没有安装插件的玩家将无法兑换相应的奖励；
8. 活动到期后，通关记录将不再被计入本次活动，也无法再获取相关奖励；
9. 同一种虚拟物品奖励，每个角色至多可以领取3次，不同挑战活动的不同虚拟物品奖励，每个角色达到任务目标后都可以领取，不同角色可以重复参与活动并且在达到挑战目标后领取相应的虚拟物品奖励；
10. 若在72小时内奖励未发送至游戏角色邮箱，请联系人工客服进行反馈；
11. 本次挑战活动由于数量较大，当您完成通关后，请点击左上角的【刷新】按钮查看最新进度，刷新后每30分钟更新一次数据结果。]])

    self:RegisterMessage('MEETINGSTONE_QUEST_FETCHED')
    self:RegisterMessage('MEETINGSTONE_QUEST_UPDATE', 'MEETINGSTONE_QUEST_FETCHED')
end

function QuestPanel:MEETINGSTONE_QUEST_FETCHED()
    local questGroup = QuestServies.questGroup
    if questGroup.id ~= QuestServies.QuestType.GoldLeader then
        self.Body.Time:SetFormattedText('活动时间：%s - %s', date('%Y/%m/%d %H:%M', questGroup.startTime),
                                        date('%Y/%m/%d %H:%M', questGroup.endTime))
        self.Quests:SetItemList(questGroup.quests)
        self.Quests:Refresh()
    end
end
