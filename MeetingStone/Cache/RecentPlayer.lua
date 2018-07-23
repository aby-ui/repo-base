--[[
RecentPlayer.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

BuildEnv(...)

RecentPlayer = Addon:NewClass('RecentPlayer', Object)

RecentPlayer:InitAttr{
    'Name',
    'BattleTag',
    'Role',
    'ItemLevel',
    'Notes',
    'Class',
    'Time',
    'IsLeader',
    'Manager',
}

function RecentPlayer:Constructor(manager)
    self:SetManager(manager)
end

function RecentPlayer:GetNameText()
    return GetClassColoredText(self:GetClass(), self:GetName())
end

function RecentPlayer:GetTimeText()
    return date('%Y/%m/%d %H:%M:%S', self:GetTime())
end

function RecentPlayer:BaseSortHandler()
    if not self._baseSortValue then
        self:UpdateSortValue()
    end
    return self._baseSortValue
end

function RecentPlayer:UpdateSortValue()
    self._baseSortValue = format('%12s%s',
        0xFFFFFFFF - self:GetTime(),
        self:GetName())
end

function RecentPlayer:FromDB(manager, db)
    local unit = RecentPlayer:New(manager)

    unit:SetName(db.name)
    unit:SetBattleTag(db.bTag)
    unit:SetRole(db.role)
    unit:SetItemLevel(db.iLvl)
    unit:SetNotes(db.notes)
    unit:SetClass(db.class)
    unit:SetTime(db.time)
    unit:SetIsLeader(db.leader)

    return unit
end

function RecentPlayer:ToDB()
    return {
        name   = self:GetName(),
        bTag   = self:GetBattleTag(),
        role   = self:GetRole(),
        iLvl   = self:GetItemLevel(),
        notes  = self:GetNotes(),
        class  = self:GetClass(),
        time   = self:GetTime(),
        leader = self:IsLeader(),
    }
end

function RecentPlayer:Match(text, class, role)
    if class ~= 0 and self:GetClass() ~= class then
        return false
    end
    if role ~= 0 and self:GetRole() ~= role then
        return false
    end
    if text then
        return self:GetName():find(text, nil, true)
    end
    return true
end

function RecentPlayer:IsTimeOut()
    return time() - self:GetTime() > 86400 * 30
end
