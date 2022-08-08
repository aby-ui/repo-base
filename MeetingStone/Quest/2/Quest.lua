-- Quest.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 3/3/2021, 1:07:57 PM
BuildEnv(...)

if not ADDON_REGIONSUPPORT then
    return
end

---@class Quest: ProtoBase
---@field private baseTitle string
---@field private title string
---@field id number
---@field cfgId number
---@field progressMaxValue number
---@field progressValue number
---@field style number
---@field startTime number
---@field endTime number
---@field timeLimit boolean
Quest = Addon:NewClass('Quest', ProtoBase)

Quest.PROTO = {'id', 'cfgId', 'progressMaxValue', '_rewards'}

function Quest:Constructor()
    self.progressValue = 0
end

---@generic T
---@param self T
---@param data any[]
---@return T
function Quest:FromProto(data)
    local quest = Quest:New()

    quest:ApplyProto(self.PROTO, data)

    local questData = QUEST_CFG_DATA[quest.cfgId]
    quest.baseTitle = questData.title

    if data[4] then
        quest.rewards = {}

        if type(data[4][1]) ~= 'table' then
            tinsert(quest.rewards, {id = data[4][1], count = data[4][2]})
        else
            for _, v in ipairs(data[4]) do
                tinsert(quest.rewards, {id = v[1], count = v[2]})
            end
        end
    end

    quest:ApplyProto(questData.proto, data, #self.PROTO)
    return quest
end

function Quest:UpdateProgress(progressValue, rewarded)
    self.progressValue = progressValue
    self.rewarded = rewarded and rewarded > 0
end

function Quest:GetTitle()
    self.title = self.title or FormatSummary(self.baseTitle, self)
    return self.title
end

function Quest:IsCompleted()
    return self.progressValue == self.progressMaxValue
end

function Quest:IsStarted()
    return self.progressValue > 0
end

function Quest:GetTimeLimitText()
    return self.timeLimit and '在时限内'
end

function Quest:GetNoReset()
    return self.noReset and '活动期间，累计'
end

function Quest:CanReward()
    return self.rewards and not self.url
end
