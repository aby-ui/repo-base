--[[
RecentManager.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

BuildEnv(...)

RecentManager = Addon:NewClass('RecentManager', Object)

RecentManager:InitAttr{
    'Code',
    'ActivityID',
    'GroupID',
    'CustomID',
    'CategoryID',

    'CategoryCode',
    'GroupCode',
    'ActivityCode',
}

function RecentManager:Constructor(activityCode)
    self.players = {}

    local categoryId, groupId, activityId, customId = strsplit('-', activityCode)

    self:SetCode(activityCode)
    self:SetCategoryID(tonumber(categoryId))
    self:SetGroupID(tonumber(groupId))
    self:SetActivityID(tonumber(activityId))
    self:SetCustomID(tonumber(customId))
    self:SetCategoryCode(format('%s-0-0-0', categoryId))
    self:SetGroupCode(format('%s-%s-0-0', categoryId, groupId))
    self:SetActivityCode(format('%s-%s-%s-0', categoryId, groupId, activityId))

    for _, db in ipairs(Profile:GetRecentDB(activityCode)) do
        tinsert(self.players, RecentPlayer:FromDB(self, db))
    end
end

function RecentManager:GetName()
    return GetActivityName(self:GetActivityID(), self:GetCustomID())
end

function RecentManager:AddUnit(player)
    if tContains(self.players, player) then
        return
    end
    return tinsert(self.players, player)
end

function RecentManager:RemoveUnit(player)
    return tDeleteItem(self.players, player)
end

function RecentManager:GetUnit(name)
    for i, v in ipairs(self.players) do
        if v:GetName() == name then
            return v
        end
    end
end

function RecentManager:ClearAllUnits()
    wipe(self.players)
end

function RecentManager:GetUnitCount()
    return #self.players
end

function RecentManager:GetList()
    return self.players
end

function RecentManager:IteratePlayers()
    return pairs(self.players)
end

function RecentManager:ToDB()
    local db = {}
    for i, player in ipairs(self.players) do
        if player:GetNotes() or not player:IsTimeOut() then
            tinsert(db, player:ToDB())
        end
    end
    return next(db) and db or nil
end
