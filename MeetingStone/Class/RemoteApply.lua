--[[
RemoteApply.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

BuildEnv(...)

local RemoteApply = Addon:NewClass('RemoteApply', Addon:GetClass('BaseApply'))

function RemoteApply:Match(activity)
    if not activity:GetLeader() then
        return false, false
    end
    return activity:GetActivityID() == self:GetActivityID() and
           activity:GetCustomID() == self:GetCustomID() and
           activity:GetLeaderFullName() == self:GetSearch(), true
end

function RemoteApply:IsOneBreak()
    return true
end

function RemoteApply:Log(activity, flag, reason)
    if flag then
        System:Logf(L['预申请活动“%s-%s”成功。'], self:GetName(), self:GetSearch())
    else
        System:Logf(L['预申请活动“%s-%s”失败，%s'], self:GetName(), self:GetSearch(), reason)
    end
end

function RemoteApply:LogDone(count, total)
    if count == 0 and total == 0 then
        System:Logf(L['预申请活动“%s-%s”失败，|cffff0000没有找到合适的活动|r。'], self:GetName(), self:GetSearch())
    end
end
