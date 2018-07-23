--[[
AutoApply.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

BuildEnv(...)

AutoApply = Addon:NewModule('AutoApply', 'AceEvent-3.0', 'AceBucket-3.0', 'AceTimer-3.0')

function AutoApply:OnInitialize()
    self.applies = {}
    self.events  = {'LFG_LIST_SEARCH_RESULT_UPDATED', 'LFG_LIST_SEARCH_RESULTS_RECEIVED'}
end

function AutoApply:Add(apply)
    tinsert(self.applies, apply)
end

function AutoApply:Pickup()
    return tremove(self.applies, 1)
end

function AutoApply:Start()
    if self.co then
        return
    end

    self.co = coroutine.create(function()
        self:Process()
        self.co = nil
        
    end)
    assert(coroutine.resume(self.co))
end

function AutoApply:Reset()
    if self.bucket then
        self:UnregisterBucket(self.bucket)
        self.bucket = nil
    end
    if self.timer then
        self:CancelTimer(self.timer)
        self.timer = nil
    end
    self:UnregisterEvent('LFG_LIST_SEARCH_FAILED')
end

function AutoApply:Wakeup(flag, ...)
    self:Reset()
    assert(coroutine.resume(self.co, flag, ...))
end

function AutoApply:Search(apply)
    C_LFGList.Search(apply:GetSearchArgs())

    self.timer = self:ScheduleTimer(function()
        return self:Wakeup(true)
    end, 10)

    self.bucket = self:RegisterBucketEvent(self.events, 1, function()
        local activities = {}
        local wait = false
        local count, list = C_LFGList.GetSearchResults()

        for _, id in ipairs(list) do
            local activity = Activity:Get(id)
            if not activity:IsDelisted() or not activity:GetActivityID() then
                local match, ready = apply:Match(activity)
                wait = wait or not ready

                if match then
                    tinsert(activities, activity)

                    if apply:IsOneBreak() then
                        return self:Wakeup(true, activities)
                    end
                end
            end
        end

        if not wait then
            return self:Wakeup(true, activities)
        end
    end)

    self:RegisterEvent('LFG_LIST_SEARCH_FAILED', function()
        self:Reset()
        self:ScheduleTimer('Search', 3, apply)
    end)
end

function AutoApply:SearchApply(apply)
    self:Search(apply)
    return coroutine.yield()
end

function AutoApply:Sleep(n)
    C_Timer.After(n, function()
        coroutine.resume(self.co)
    end)
    coroutine.yield()
end

function AutoApply:Process()
    repeat
        local apply = self:Pickup()
        if not apply then
            return
        end

        local activityName = apply:GetName()
        local flag, activities = self:SearchApply(apply)
        if not flag or not activities then
            return
        end

        if type(apply.SortHandler) == 'function' then
            sort(activities, function(a, b)
                return apply:SortHandler(a) < apply:SortHandler(b)
            end)
        end

        local count = 0
        for _, activity in ipairs(activities) do
            local usable, reason do
                if activity then
                    usable, reason = BrowsePanel:CheckSignUpStatus(activity)
                else
                    usable, reason = false, L['没有找到活动']
                end
            end

            if activity and usable then
                C_LFGList.ApplyToGroup(activity:GetID(), '', apply:IsTank(), apply:IsHealer(), apply:IsDamager())
                count = count + 1
                apply:Log(activity, true, reason)
                self:Sleep(2)
            else
                apply:Log(activity, false, reason)
            end
        end
        apply:LogDone(count, #activities)
    until false
end
