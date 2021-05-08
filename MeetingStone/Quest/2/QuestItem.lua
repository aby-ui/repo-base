-- QuestItem.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 4/19/2021, 2:58:09 PM
--
BuildEnv(...)


QuestItem = Addon:NewClass('QuestItem', GUI:GetClass('ItemButton'))

function QuestItem:Create(parent, ...)
    return self:Bind(CreateFrame('CheckButton', nil, parent, 'MeetingStoneQuestItemTemplate'), ...)
end

local function RewardOnClick(self)
    self:GetParent():FireHandler('OnItemRewardClick')
    self:SetCountdown(10)
end

function QuestItem:Constructor()
    self.Item:Disable()
    self.Reward:SetScript('OnClick', RewardOnClick)
    CountdownButton:Bind(self.Reward)
    self.Reward:SetCountdownObject(QuestItem)
end


function QuestItem:SetQuest(quest)
    self.Text:SetText(quest:GetTitle())
    self.Reward:SetShown(quest.rewards)
    self.Reward:SetEnabled(quest:IsCompleted() and not quest.rewarded)
    self.Reward:SetText(quest.rewarded and '已领取' or '领取奖励')
    self.Progress:SetFormattedText('%d/%d', quest.progressValue, quest.progressMaxValue)
    self.Item:SetItem(quest.rewards[1].id)
    self.Item:SetItemButtonCount(quest.rewards[1].count)
end

function QuestItem:SetData(data)
    self.Item:SetItem(data.item)
    self.Text:SetText(data.text)
    self.Item:SetItemButtonCount(1)
    self.Reward:Hide()
    self.Progress:SetText('')
end
