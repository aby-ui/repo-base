
BuildEnv(...)

ManagerPanel = Addon:NewModule(CreateFrame('Frame'), 'ManagerPanel', 'AceEvent-3.0', 'AceBucket-3.0')

local CHECK_USEABLE_EVENTS = {
    'PARTY_LEADER_CHANGED',
    'GROUP_ROSTER_UPDATE',
    'UPDATE_BATTLEFIELD_STATUS',
    'LFG_UPDATE',
    'LFG_ROLE_CHECK_UPDATE',
    'LFG_PROPOSAL_UPDATE',
    'LFG_PROPOSAL_FAILED',
    'LFG_PROPOSAL_SUCCEEDED',
    'LFG_PROPOSAL_SHOW',
    'LFG_QUEUE_STATUS_UPDATE',
}

function ManagerPanel:OnInitialize()
    GUI:Embed(self, 'Owner', 'Tab', 'Refresh')

    MainPanel:RegisterPanel(L['管理活动'], self, 5, 70)

    -- frames
    local FullBlocker = Addon:GetClass('Cover'):New(self) do
        FullBlocker:SetPoint('TOPLEFT', -3, 3)
        FullBlocker:SetPoint('BOTTOMRIGHT', 3, -3)
        FullBlocker:SetStyle('CIRCLE')
        FullBlocker:SetBackground([[Interface\DialogFrame\UI-DialogBox-Background-Dark]])
        FullBlocker:Hide()
    end

    local ApplicantListBlocker = Addon:GetClass('Cover'):New(self) do
        ApplicantListBlocker:SetPoint('TOPLEFT', 219, 0)
        ApplicantListBlocker:SetPoint('BOTTOMRIGHT')
        ApplicantListBlocker:SetStyle('LINE')
        ApplicantListBlocker:Hide()
    end

    local RefreshButton = Addon:GetClass('RefreshButton'):New(self) do
        RefreshButton:SetPoint('TOPRIGHT', self:GetOwner(), 'TOPRIGHT', -10, -23)
        RefreshButton:SetTooltip(LFG_LIST_REFRESH)
        RefreshButton:SetScript('OnClick', function()
            if self:HasActivity() then
                C_LFGList.RefreshApplicants()
            end
        end)
    end

    self.FullBlocker = FullBlocker
    self.ApplicantListBlocker = ApplicantListBlocker
    self.RefreshButton = RefreshButton

    -- 检查是否可以创建活动
    self:RegisterBucketEvent(CHECK_USEABLE_EVENTS, 0.1, 'CheckUseable')

    self:RegisterMessage('MEETINGSTONE_CREATING_ACTIVITY', 'ShowCreatingBlocker')

    self:RegisterEvent('LFG_LIST_ENTRY_CREATION_FAILED', 'HideCreatingBlocker')
    self:RegisterEvent('LFG_LIST_ACTIVE_ENTRY_UPDATE', 'HideCreatingBlocker')

    self:SetScript('OnShow', self.CheckUseable)
end

function ManagerPanel:CheckUseable()
    C_LFGList.RefreshApplicants()

    local isLeader = IsGroupLeader()
    local isManager = IsActivityManager()
    local msg = LFGListUtil_GetActiveQueueMessage(false)

    self.RefreshButton:Disable()

    if self:HasActivity() then
        if isLeader or isManager then
            self.RefreshButton:Enable()
            self:SetApplicantListBlocker(false)
        else
            self:SetApplicantListBlocker(LFG_LIST_GROUP_FORMING)
        end
    else
        if isLeader then
            self:SetApplicantListBlocker(msg or L['请创建活动'])
        else
            self:SetApplicantListBlocker(msg or L['只有团长才能预创建队伍'])
        end
    end
    self:SendMessage('MEETINGSTONE_PERMISSION_UPDATE', isLeader and not msg, isManager)
end

function ManagerPanel:HasActivity()
    return C_LFGList.GetActiveEntryInfo()
end

function ManagerPanel:HideCreatingBlocker()
    self:SetBlocker(false)
    self:CheckUseable()
end

function ManagerPanel:ShowCreatingBlocker()
    self:SetBlocker(LFG_LIST_CREATING_ENTRY, true)
end

function ManagerPanel:SetBlocker(text, showIcon)
    self.FullBlocker:SetText(text, not showIcon)
    self.FullBlocker:SetShown(text)
    if text then
        self:SetApplicantListBlocker(false)
    end
end

function ManagerPanel:SetApplicantListBlocker(text)
    if text and not self.FullBlocker:IsVisible() then
        self.ApplicantListBlocker:SetText(text)
        self.ApplicantListBlocker:Show()
    else
        self.ApplicantListBlocker:Hide()
    end
end
