--[[
BaseApply.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

BuildEnv(...)

local BaseApply = Addon:NewClass('BaseApply', Object)

BaseApply:InitAttr{
    'ActivityID',
    'CustomID',
    'CategoryID',
    'GroupID',
    'Search',
    'Code',
    'IsTank',
    'IsHealer',
    'IsDamager',
}

function BaseApply:Constructor(activityId, customId)
    self:SetActivityID(activityId)
    self:SetCustomID(customId)
    self:SetCode(GetActivityCode(activityId, customId))

    local _, _, categoryId, groupId = C_LFGList.GetActivityInfo(activityId)

    self:SetCategoryID(categoryId)
    self:SetGroupID(groupId)
end

function BaseApply:Match()
    return false
end

function BaseApply:IsOneBreak()
    return true
end

function BaseApply:GetName()
    return GetActivityName(self:GetActivityID(), self:GetCustomID())
end

function BaseApply:GetSearchArgs()
    local search = self:GetSearch() and LFGListSearchPanel_ParseSearchTerms(self:GetSearch())
    return self:GetCategoryID(),  search or self:GetName(), 0, self:GetBaseFilters()
end

function BaseApply:GetBaseFilters()
    return CATEGORY_BASEFILTERS[self:GetCategoryID()]
end

BaseApply.Log = nop
BaseApply.LogDone = nop
