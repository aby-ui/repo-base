
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

local ROLES_GROUP = { TANK = {}, DAMAGER = {}, HEALER = {}, }
local ROLES_ORDER = { "TANK", "HEALER", "DAMAGER", }
local function ClearClassLines(parent)
    for i = 1, 5 do
        local icon = parent.Enumerate["Icon"..i]
        if icon.line then icon.line:SetAlpha(0) end
    end
end
local function LFGListGroupDataDisplay_Update(self, activityID, displayData, disabled, activity)
    local activityInfo = C_LFGList.GetActivityInfoTable(activityID);
   	if(not activityInfo) then
   		return;
   	end
    if activityInfo.displayType == Enum.LfgListDisplayType.RoleCount or activityInfo.displayType == Enum.LfgListDisplayType.HideAll then
        self.RoleCount:Show()
        self.Enumerate:Hide()
        self.PlayerCount:Hide()
        LFGListGroupDataDisplayRoleCount_Update(self.RoleCount, displayData, disabled)
    elseif activityInfo.displayType == Enum.LfgListDisplayType.RoleEnumerate then
        self.RoleCount:Hide()
        self.Enumerate:Show()
        self.PlayerCount:Hide()
        LFGListGroupDataDisplayEnumerate_Update(self.Enumerate, activityInfo.maxNumPlayers, displayData, disabled, LFG_LIST_GROUP_DATA_ROLE_ORDER)
        --abyui learn from WindTools
        if Profile:GetSetting("showClassLine") then
            for _, v in pairs(ROLES_GROUP) do wipe(v) end
            for i = 1, activity:GetNumMembers() do
                local role, class = C_LFGList.GetSearchResultMemberInfo(activity:GetID(), i)
                table.insert(ROLES_GROUP[role], class)
            end
            local i = 0
            for _, v in ipairs(ROLES_ORDER) do
                for _, class in ipairs(ROLES_GROUP[v]) do
                    i = i + 1
                    local icon = self.Enumerate["Icon"..(5 - i + 1)]
                    if not icon.line then
                        local line = self.Enumerate:CreateTexture(nil, "ARTWORK")
                        icon.line = line
                        line:SetTexture([[Interface\Buttons\WHITE8X8]])
                        line:SetSize(icon:GetWidth()-4, 3)
                        line:SetPoint("TOP", icon, "BOTTOM", 0, -1)
                    end
                    local r, g, b = GetClassColor(class)
                    icon.line:SetVertexColor(r, g, b)
                    icon.line:SetAlpha(1)
                end
            end
            for i = 1, 5 - activity:GetNumMembers() do
                local icon = self.Enumerate["Icon"..i]
                if icon.line then icon.line:SetAlpha(0) end
            end
        else
            ClearClassLines(self)
        end

    elseif activityInfo.displayType == Enum.LfgListDisplayType.ClassEnumerate then
        self.RoleCount:Hide()
        self.Enumerate:Show()
        self.PlayerCount:Hide()
        LFGListGroupDataDisplayEnumerate_Update(self.Enumerate, activityInfo.maxNumPlayers, displayData, disabled, LFG_LIST_GROUP_DATA_CLASS_ORDER)
        ClearClassLines(self)
    elseif activityInfo.displayType == Enum.LfgListDisplayType.PlayerCount then
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
        LFGListGroupDataDisplay_Update(self.DataDisplay, activity:GetActivityID(), displayData, activity:IsDelisted() or activity:IsApplicationFinished(), activity)
        self.DataDisplay:Show()
    else
        self.DataDisplay:Hide()
    end
end
