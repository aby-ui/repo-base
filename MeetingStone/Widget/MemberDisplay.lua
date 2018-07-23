
BuildEnv(...)

MemberDisplay = Addon:NewClass('MemberDisplay', GUI:GetClass('DataGridViewGridItem'))

function MemberDisplay:Constructor()
    local DataDisplay = CreateFrame('Frame', nil, self, 'LFGListGroupDataDisplayTemplate') do
        DataDisplay:SetPoint('CENTER')
        DataDisplay.RoleCount.DamagerCount:SetWidth(18)
        DataDisplay.RoleCount.HealerCount:SetWidth(18)
        DataDisplay.RoleCount.TankCount:SetWidth(18)
        DataDisplay.PlayerCount.Count:SetWidth(20)
    end

    self.DataDisplay = DataDisplay
end

function LFGListGroupDataDisplay_Update(self, activityID, displayData, disabled)
    local fullName, shortName, categoryID, groupID, iLevel, filters, minLevel, maxPlayers, displayType = C_LFGList.GetActivityInfo(activityID)
    if displayType == LE_LFG_LIST_DISPLAY_TYPE_ROLE_COUNT or displayType == LE_LFG_LIST_DISPLAY_TYPE_HIDE_ALL then
        self.RoleCount:Show()
        self.Enumerate:Hide()
        self.PlayerCount:Hide()
        LFGListGroupDataDisplayRoleCount_Update(self.RoleCount, displayData, disabled)
    elseif displayType == LE_LFG_LIST_DISPLAY_TYPE_ROLE_ENUMERATE then
        self.RoleCount:Hide()
        self.Enumerate:Show()
        self.PlayerCount:Hide()
        LFGListGroupDataDisplayEnumerate_Update(self.Enumerate, maxPlayers, displayData, disabled, LFG_LIST_GROUP_DATA_ROLE_ORDER)
    elseif displayType == LE_LFG_LIST_DISPLAY_TYPE_CLASS_ENUMERATE then
        self.RoleCount:Hide()
        self.Enumerate:Show()
        self.PlayerCount:Hide()
        LFGListGroupDataDisplayEnumerate_Update(self.Enumerate, maxPlayers, displayData, disabled, LFG_LIST_GROUP_DATA_CLASS_ORDER)
    elseif displayType == LE_LFG_LIST_DISPLAY_TYPE_PLAYER_COUNT then
        self.RoleCount:Hide()
        self.Enumerate:Hide()
        self.PlayerCount:Show()
        LFGListGroupDataDisplayPlayerCount_Update(self.PlayerCount, displayData, disabled)
    else
        self.RoleCount:Hide()
        self.Enumerate:Hide()
        self.PlayerCount:Hide()
    end
end

function MemberDisplay:SetActivity(activity)
    local displayData = C_LFGList.GetSearchResultMemberCounts(activity:GetID())
    if displayData then
        LFGListGroupDataDisplay_Update(self.DataDisplay, activity:GetActivityID(), displayData, activity:IsDelisted() or activity:IsApplicationFinished())
        self.DataDisplay:Show()
    else
        self.DataDisplay:Hide()
    end
end
