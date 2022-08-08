-- QuestItem.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 4/19/2021, 2:58:09 PM
--
BuildEnv(...)

if not ADDON_REGIONSUPPORT then
    return
end

---@class QuestItem: Object,Frame
QuestItem = Addon:NewClass('QuestItem', GUI:GetClass('ItemButton'))

function QuestItem:Create(parent, ...)
    return self:Bind(CreateFrame('CheckButton', nil, parent, 'MeetingStoneQuestItemTemplate'), ...)
end

local function RewardOnClick(self)
    self:GetParent():FireHandler('OnItemRewardClick')
    self:SetCountdown(10)
end

function QuestItem:Constructor()
    for _, button in ipairs(self.Items) do
        button:Disable()
    end

    self.Reward:SetScript('OnClick', RewardOnClick)
    CountdownButton:Bind(self.Reward)
    self.Reward:SetCountdownObject(QuestItem)

    local function UpdateProgressPoint()
        local rightControl
        if self.Reward:IsShown() then
            rightControl = self.Reward
        elseif self.Extern:IsShown() then
            rightControl = self.Extern
        end

        if rightControl then
            self.Progress:SetPoint('RIGHT', rightControl, 'LEFT', -10, 0)
        else
            self.Progress:SetPoint('RIGHT', self, -5, 0)
        end
    end

    self.Reward:HookScript('OnShow', UpdateProgressPoint)
    self.Reward:HookScript('OnHide', UpdateProgressPoint)
    self.Extern:HookScript('OnShow', UpdateProgressPoint)
    self.Extern:HookScript('OnHide', UpdateProgressPoint)
end

---@param quest Quest
function QuestItem:SetQuest(quest)
    self.Text:SetText(quest:GetTitle())

    self.Reward:SetShown(quest:CanReward())
    self.Reward:SetEnabled(quest:IsCompleted() and not quest.rewarded)
    self.Reward:SetText(quest.rewarded and '已领取' or '领取奖励')

    self.Extern:SetShown(quest.extern)
    self.Extern:SetText(quest.extern)
    ApplyUrlButton(self.Extern, quest.url)

    if quest.progressValue and quest.progressMaxValue then
        self.Progress:SetFormattedText('%d/%d', quest.progressValue, quest.progressMaxValue)
    else
        self.Progress:SetText('')
    end

    local rightButton
    for i, button in ipairs(self.Items) do
        local reward = quest.rewards[i]
        if reward then
            rightButton = button
            button:Show()
            button:SetItem(reward.id)
            button:SetItemButtonCount(reward.count)
        else
            button:Hide()
        end
    end

    self.Text:SetPoint('LEFT', rightButton, 'RIGHT', 5, 0)
end

function QuestItem:SetData(data)
    self.Item:SetItem(data.item)
    self.Text:SetText(data.text)
    self.Item:SetItemButtonCount(1)
    self.Reward:Hide()
    self.Progress:SetText('')
end
