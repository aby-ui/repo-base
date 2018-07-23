--[[
WorldQuestApply.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

BuildEnv(...)

local WorldQuestApply = Addon:NewClass('WorldQuestApply', Addon:GetClass('BaseApply'))

WorldQuestApply:InitAttr{
    'MaxMembers',
    'MinMembers',
    'QuestTitle',
}

function WorldQuestApply:Match(activity)
    return activity:GetCode() == self:GetCode() and
           activity:GetSummary():find(self:GetQuestTitle(), nil, true) and
           activity:GetNumMembers() < self:GetMaxMembers() and
           activity:GetNumMembers() >= self:GetMinMembers(), true
end

function WorldQuestApply:IsOneBreak()
    return false
end

function WorldQuestApply:SortHandler(activity)
    return self:GetMaxMembers() - activity:GetNumMembers()
end

function WorldQuestApply:Log(activity, flag)
    if not flag then
        return
    end

    System:Logf(L['已快速申请活动“%s-%s”'], activity:GetName(), activity:GetSummary())
end

function WorldQuestApply:LogDone(count)
    if count == 0 then
        System:Logf(L['本次快速申请完成，|cffff0000没有找到合适的活动|r。'])
    else
        System:Logf(L['本次快速申请完成，已为你自动申请%s个活动。'], count)
    end
end

function WorldQuestApply:IsDamager()
    return true
end

function WorldQuestApply:SetQuestID(questId)
    local title = C_TaskQuest.GetQuestInfoByQuestID(questId)
    local rarity = select(4, GetQuestTagInfo(questId))

    if rarity == LE_WORLD_QUEST_QUALITY_EPIC then
        self:SetMinMembers(5)
        self:SetMaxMembers(40)
    else
        self:SetMinMembers(1)
        self:SetMaxMembers(5)
    end
    self:SetQuestTitle(title)
end
