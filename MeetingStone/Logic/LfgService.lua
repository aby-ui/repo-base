-- LfgService.lua
-- @Author : DengSir (tdaddon@163.com)
-- @Link   : https://dengsir.github.io/
-- @Date   : 2018-1-17 10:29:00

BuildEnv(...)

LfgService = Addon:NewModule('LfgService', 'AceEvent-3.0', 'AceBucket-3.0', 'AceTimer-3.0', 'AceHook-3.0')

function LfgService:OnInitialize()
    self.activityHash = {}
    self.activityList = {}
    self.activityRemoved = {}

    self:RegisterEvent('LFG_LIST_SEARCH_RESULTS_RECEIVED')
    self:RegisterEvent('LFG_LIST_SEARCH_FAILED', 'LFG_LIST_SEARCH_RESULTS_RECEIVED')
    self:RegisterEvent('LFG_LIST_APPLICATION_STATUS_UPDATED', 'LFG_LIST_SEARCH_RESULT_UPDATED')
    self:RegisterEvent('LFG_LIST_SEARCH_RESULT_UPDATED')

    -- self:RegisterBucketEvent('LFG_LIST_SEARCH_RESULT_UPDATED', 0.1, 'LFG_LIST_SEARCH_RESULT_UPDATED_BUCKET')

    self:SecureHook(C_LFGList, 'Search', 'C_LFGList_Search')
end

function LfgService:C_LFGList_Search()
    self.inSearch = true
    self.dirty = true
end

function LfgService:GetActivity(id)
    return self.activityHash[id]
end

function LfgService:GetActivityCount()
    return #self.activityList
end

function LfgService:GetActivityList()
    return self.activityList
end

function LfgService:RemoveActivity(id)
    self.activityRemoved[id] = true

    local activity = self:GetActivity(id)
    if not activity then
        return
    end
    tDeleteItem(self.activityList, activity)
    self.activityHash[id] = nil
end

function LfgService:IsActivityRemoved(id)
    return self.activityRemoved[id]
end

function LfgService:UpdateActivity(id)
    if self:IsActivityRemoved(id) then
        return
    end

    local activity = self:GetActivity(id)
    if not activity then
        self:CacheActivity(id)
        self:SendMessage('MEETINGSTONE_ACTIVITIES_COUNT_UPDATED', #self.activityList)
    else
        if not activity:Update() then
            self:RemoveActivity(id)
        end
    end
end

function LfgService:IterateActivities()
    return pairs(self.activityList)
end

function LfgService:CacheActivity(id)
    if not self:_CacheActivity(id) then
        self:RemoveActivity(id)
    end
end

function LfgService:_CacheActivity(id)
    local _id, activityId, title, comment = C_LFGList.GetSearchResultInfo(id)
    if not _id then
        return
    elseif not activityId then
        return
    end

    -- local activityItem = self.ActivityDropdown:GetItem()
    local activity = Activity:New(id)

    if not activity:Update() then
        -- debug(id, title, comment)
        return
    end

    if self.activityId and activity:GetActivityID() ~= self.activityId then
        return
    end

    -- if activityItem then
    --     if activityItem.activityId and not ACTIVITY_CUSTOM_DATA.A[activityItem.activityId] then
    --         if activityItem.activityId ~= activity:GetActivityID() or activityItem.customId ~= activity:GetCustomID() then
    --             return
    --         end
    --     end
    --     if activity:IsSoloActivity() and activityItem.customId ~= activity:GetCustomID() then
    --         return
    --     end
    -- end
    if activity:HasInvalidContent() then
        return
    end
    if not activity:IsValidCustomActivity() then
        return
    end

    tinsert(self.activityList, activity)
    self.activityHash[id] = activity

    return true
end

function LfgService:LFG_LIST_SEARCH_RESULTS_RECEIVED(event)
    table.wipe(self.activityList)
    table.wipe(self.activityHash)
    table.wipe(self.activityRemoved)

    self.inSearch = false

    

    local applications = C_LFGList.GetApplications()

    for _, id in ipairs(applications) do
        self:CacheActivity(id)
    end

    local _, resultList = C_LFGList.GetSearchResults()
    for _, id in ipairs(resultList) do
        self:CacheActivity(id)
    end

    self:SendMessage('MEETINGSTONE_ACTIVITIES_COUNT_UPDATED', self:GetActivityCount())
    self:SendMessage('MEETINGSTONE_ACTIVITIES_RESULT_RECEIVED', event == 'LFG_LIST_SEARCH_FAILED')
end

function LfgService:LFG_LIST_SEARCH_RESULT_UPDATED_BUCKET(results)
    for id in pairs(results) do
        self:UpdateActivity(id)
    end
    self:SendMessage('MEETINGSTONE_ACTIVITIES_RESULT_UPDATED')
end

function LfgService:LFG_LIST_SEARCH_RESULT_UPDATED(_, id)
    if self.inSearch then
        return
    end
    
    self:UpdateActivity(id)
    self:SendMessage('MEETINGSTONE_ACTIVITIES_RESULT_UPDATED')
end

function LfgService:Search(categoryId, baseFilter, activityId)
    self.ourSearch = true
    self.activityId = activityId

    if activityId then
        C_LFGList.SetSearchToActivity(activityId)
    end

    C_LFGList.Search(categoryId, 0, baseFilter)
    C_LFGList.ClearSearchTextFields()
    self.ourSearch = false
    self.dirty = false
end

function LfgService:IsDirty()
    return self.dirty
end
