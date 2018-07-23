
BuildEnv(...)

local OperationGrid = Addon:NewClass('OperationGrid', GUI:GetClass('DataGridViewGridItem'))

function OperationGrid:Constructor()
    local function ButtonOnClick(object)
        self:SetSpinner(true)
        self:GetParent():FireHandler(object.Handler)
    end

    local InviteButton = CreateFrame('Button', nil, self, 'UIMenuButtonStretchTemplate') do
        InviteButton:SetSize(70, 22)
        InviteButton:SetPoint('TOPLEFT', 10, -5)
        InviteButton:SetScript('OnClick', ButtonOnClick)
        InviteButton.Handler = 'OnInviteClick'
    end

    local DeclineButton = CreateFrame('Button', nil, self, 'UIMenuButtonStretchTemplate') do
        DeclineButton:SetSize(24, 22)
        DeclineButton:SetPoint('TOPLEFT', InviteButton, 'TOPRIGHT', 3, 0)
        DeclineButton:SetPoint('BOTTOMLEFT', InviteButton, 'BOTTOMRIGHT', 3, 0)
        DeclineButton:SetScript('OnClick', ButtonOnClick)
        DeclineButton.Handler = 'OnDeclineClick'

        local Icon = DeclineButton:CreateTexture(nil, 'ARTWORK')
        Icon:SetPoint('CENTER')
        Icon:SetAtlas('groupfinder-icon-redx', true)
    end

    local Spinner = CreateFrame('Frame', nil, self, 'LoadingSpinnerTemplate') do
        Spinner:SetPoint('LEFT', DeclineButton, 'RIGHT', -5, 0)
        Spinner:SetSize(32, 32)
        Spinner.Anim:Play()
        Spinner:Hide()
    end

    local StatusText = self:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmall') do
        StatusText:SetPoint('TOPLEFT', 10, -5)
        StatusText:Show()
    end

    self.InviteButton = InviteButton
    self.DeclineButton = DeclineButton
    self.BanButton = BanButton
    self.StatusText = StatusText
    self.Spinner = Spinner
end

function OperationGrid:SetMember(applicant, activityID)
    local status = applicant:GetStatus()
    local numMembers = applicant:GetNumMembers()

    local numAllowed = select(ACTIVITY_RETURN_VALUES.maxPlayers, C_LFGList.GetActivityInfo(activityID))
    if numAllowed == 0 then
        numAllowed = MAX_RAID_MEMBERS
    end

    local currentCount = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME)
    local numInvited = C_LFGList.GetNumInvitedApplicantMembers()

    local enable = self:GetParent():IsBackgroundShown()
    self:SetInviteButton(enable, applicant:GetNumMembers())

    if numMembers + currentCount > numAllowed then
        self:SetText(LFG_LIST_GROUP_TOO_FULL)
    elseif numMembers + currentCount + numInvited > numAllowed then
        self:SetText(L['你的邀请已满。'])
    elseif status == 'applied' then
        self.DeclineButton:SetShown(enable)
        self:SetSpinner(enable and applicant:GetPendingStatus())
    else
        self:SetText(INVITE_STATUS_NAMES[status])
    end
end

function OperationGrid:SetInviteButton(enable, numMembers)
    if enable then
        self.InviteButton:Show()
        self.InviteButton:SetPoint('BOTTOM', self:GetParent().bg, 'BOTTOM', 0, 5)
        self.StatusText:SetPoint('BOTTOM', self:GetParent().bg, 'BOTTOM', 0, 5)
        if numMembers > 1 then
            self.InviteButton:SetFormattedText(LFG_LIST_INVITE_GROUP, numMembers)
        else
            self.InviteButton:SetText(INVITE)
        end
    else
        self.InviteButton:SetPoint('BOTTOM', self, 'BOTTOM', 0, 5)
        self.StatusText:SetPoint('BOTTOM', self, 'BOTTOM', 0, 5)
        self.InviteButton:Hide()
    end
end

function OperationGrid:SetSpinner(enable)
    self.InviteButton:SetEnabled(not enable)
    self.DeclineButton:SetEnabled(not enable)
    self.Spinner:SetShown(enable)
    self.StatusText:Hide()
end

function OperationGrid:SetText(text)
    if self.InviteButton:IsShown() then
        self.StatusText:Show()
        self.StatusText:SetText(text)
    end
    self.InviteButton:Hide()
    self.DeclineButton:Hide()
    self.Spinner:Hide()
end
