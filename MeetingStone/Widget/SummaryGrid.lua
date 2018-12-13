
BuildEnv(...)

local SummaryGrid = Addon:NewClass('SummaryGrid', GUI:GetClass('DataGridViewGridItem'))

function SummaryGrid:Constructor()
    local ExpirationTime = self:CreateFontString(nil, 'ARTWORK', 'GameFontGreenSmall') do
        ExpirationTime:SetWidth(35)
        ExpirationTime:SetPoint('RIGHT', -35, 0)
        ExpirationTime:Hide()
        ExpirationTime:SetJustifyH('LEFT')
    end

    local PendingLabel = self:CreateFontString(nil, 'ARTWORK', 'GameFontGreenSmall') do
        PendingLabel:SetText(LFG_LIST_PENDING)
        PendingLabel:SetWidth(70)
        PendingLabel:SetPoint('RIGHT', ExpirationTime, 'LEFT', -3, 0)
        PendingLabel:Hide()
        PendingLabel:SetJustifyH('RIGHT')
    end

    local CancelButton = CreateFrame('Button', nil, self, 'UIMenuButtonStretchTemplate') do
        CancelButton:SetSize(26, 24)
        CancelButton:SetPoint('RIGHT', -9, 0)
        CancelButton:Hide()
        CancelButton:SetScript('OnClick', function()
            self:GetParent():FireHandler('OnItemDecline')
        end)

        local Icon = CancelButton:CreateTexture(nil, 'ARTWORK') do
            Icon:SetAtlas('groupfinder-icon-redx', true)
            Icon:SetPoint('CENTER')
        end

        CancelButton:SetScript('OnEnable', function()
            Icon:SetDesaturated(false)
        end)
        CancelButton:SetScript('OnDisable', function()
            Icon:SetDesaturated(true)
        end)
    end

    local Spinner = CreateFrame('Frame', nil, self, 'LoadingSpinnerTemplate') do
        Spinner:Hide()
        Spinner:SetSize(48, 48)
        Spinner:SetPoint('RIGHT', 0, 0)
        Spinner:SetScript('OnShow', function(Spinner)
            Spinner.Anim:Play()
        end)
        Spinner:SetScript('OnHide', function(Spinner)
            Spinner.Anim:Stop()
        end)
    end

    local VoiceChat = CreateFrame('Button', nil, self) do
        VoiceChat:SetPoint('LEFT')
        VoiceChat:SetSize(16, 14)
        VoiceChat:SetScript('OnShow', function(VoiceChat)
            VoiceChat:SetWidth(16)
        end)
        VoiceChat:SetScript('OnHide', function(VoiceChat)
            VoiceChat:SetWidth(1)
        end)
        VoiceChat:SetScript('OnEnter', function(VoiceChat)
            GameTooltip:SetOwner(VoiceChat, 'ANCHOR_RIGHT')
            GameTooltip:SetText(format(L['语音聊天：|cffffffff%s|r'], self.voiceChat))
            GameTooltip:Show()
        end)
        VoiceChat:SetScript('OnLeave', GameTooltip_Hide)

        local Icon = VoiceChat:CreateTexture(nil, 'ARTWORK') do
            Icon:SetAllPoints(true)
            Icon:SetAtlas('groupfinder-icon-voice')
        end
    end

    local Summary = self:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightLeft') do
        Summary:SetPoint('LEFT', VoiceChat, 'RIGHT', 1, 0)
        Summary:SetPoint('RIGHT', -2, 0)
        Summary:SetWordWrap(false)
    end

    self.VoiceChat = VoiceChat
    self.ExpirationTime = ExpirationTime
    self.PendingLabel = PendingLabel
    self.CancelButton = CancelButton
    self.Spinner = Spinner
    self.Summary = Summary
end

function SummaryGrid:SetActivity(activity)
    local appStatus, pendingStatus = activity:GetApplicationStatus(), activity:GetPendingStatus()

    self.expiration = activity:GetApplicationExpiration()
    self.voiceChat = activity:GetVoiceChat()
    self.Spinner:SetShown(pendingStatus == 'applied')
    self.Summary:SetText(activity:GetComment())
    self.Summary:SetFontObject((activity:IsDelisted() or activity:IsApplicationFinished()) and 'GameFontDisableLeft' or 'GameFontHighlightLeft')
    self.CancelButton:SetEnabled(LFGListUtil_IsAppEmpowered())
    self.CancelButton.tooltip = not LFGListUtil_IsAppEmpowered() and LFG_LIST_APP_UNEMPOWERED
    self.VoiceChat:SetShown(activity:GetVoiceChat())

    if pendingStatus == 'applied' and C_LFGList.GetRoleCheckInfo() then
        self.PendingLabel:SetText(LFG_LIST_ROLE_CHECK)
        self.PendingLabel:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
        self.PendingLabel:Show()
        self.ExpirationTime:Hide()
        self.CancelButton:Hide()
    elseif pendingStatus == 'cancelled' or appStatus == 'cancelled' or appStatus == 'failed' then
        self.PendingLabel:SetText(LFG_LIST_APP_CANCELLED)
        self.PendingLabel:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
        self.PendingLabel:Show()
        self.ExpirationTime:Hide()
        self.CancelButton:Hide()
    elseif appStatus == 'declined' or appStatus == 'declined_full' or appStatus == 'declined_delisted' then
        self.PendingLabel:SetText(LFG_LIST_APP_DECLINED)
        self.PendingLabel:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
        self.PendingLabel:Show()
        self.ExpirationTime:Hide()
        self.CancelButton:Hide()
    elseif appStatus == 'timedout' then
        self.PendingLabel:SetText(LFG_LIST_APP_TIMED_OUT)
        self.PendingLabel:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
        self.PendingLabel:Show()
        self.ExpirationTime:Hide()
        self.CancelButton:Hide()
    elseif appStatus == 'invited' then
        self.PendingLabel:SetText(LFG_LIST_APP_INVITED)
        self.PendingLabel:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
        self.PendingLabel:Show()
        self.ExpirationTime:Hide()
        self.CancelButton:Hide()
    elseif appStatus == 'inviteaccepted' then
        self.PendingLabel:SetText(LFG_LIST_APP_INVITE_ACCEPTED)
        self.PendingLabel:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
        self.PendingLabel:Show()
        self.ExpirationTime:Hide()
        self.CancelButton:Hide()
    elseif appStatus == 'invitedeclined' then
        self.PendingLabel:SetText(LFG_LIST_APP_INVITE_DECLINED)
        self.PendingLabel:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
        self.PendingLabel:Show()
        self.ExpirationTime:Hide()
        self.CancelButton:Hide()
    elseif activity:IsApplication() and pendingStatus ~= 'applied' then
        self.PendingLabel:SetText(LFG_LIST_PENDING)
        self.PendingLabel:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
        self.PendingLabel:Show()
        self.ExpirationTime:Show()
        self.CancelButton:Show()
    else
        self.PendingLabel:Hide()
        self.ExpirationTime:Hide()
        self.CancelButton:Hide()
    end

    if self.ExpirationTime:IsShown() then
        self.PendingLabel:SetPoint('RIGHT', self.ExpirationTime, 'LEFT', -3, 0);
    else
        self.PendingLabel:SetPoint('RIGHT', self.ExpirationTime, 'RIGHT', -3, 0);
    end

    if self.PendingLabel:IsShown() or self.Spinner:IsShown() then
        self.Summary:SetPoint('RIGHT', self.PendingLabel, 'LEFT', -2, 0)
    else
        self.Summary:SetPoint('RIGHT', -2, 0)
    end

    if activity:IsApplication() then
        self:SetScript('OnUpdate', self.UpdateExpiration)
    else
        self:SetScript('OnUpdate', nil)
    end
end

function SummaryGrid:UpdateExpiration()
    local duration = 0
    local now = GetTime()
    if self.expiration and self.expiration > now then
        duration = self.expiration - now;
    end

    local minutes = math.floor(duration / 60);
    local seconds = duration % 60;
    self.ExpirationTime:SetFormattedText('%d:%.2d', minutes, seconds);
end
