
BuildEnv(...)

if not ADDON_REGIONSUPPORT then
    return
end

ExchangePanel = Addon:NewModule(GUI:GetClass('InTabPanel'):New(MainPanel), 'ExchangePanel', 'AceTimer-3.0', 'AceEvent-3.0')

function ExchangePanel:OnInitialize()
    GUI:Embed(self, 'Owner')
    self.TabFrame:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 60, 0)

    MainPanel:RegisterPanel(L['兑换平台'], self, 0, 70)

    local WorkingCover = Addon:GetClass('Cover'):New(self) do
        WorkingCover:SetPoint('TOPLEFT', 5, -5)
        WorkingCover:SetPoint('BOTTOMRIGHT', -5, 5)
        WorkingCover:SetStyle('CIRCLE')
        WorkingCover:SetBackground([[Interface\DialogFrame\UI-DialogBox-Background-Dark]])
        WorkingCover:Hide()
    end

    local Loading = WorkingCover:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
    Loading:SetPoint('TOPRIGHT')

    self.timeout = 180
    self.Loading = Loading
    self.WorkingCover = WorkingCover

    self:RegisterMessage('MEETINGSTONE_SERVER_STATUS_UPDATED', 'UpdateStatus')

    self:UpdateStatus()
end

function ExchangePanel:SetCover(enable, text, callback)
    if not self.IsConnectServer then
        if enable then
            self.LastCover = {enable, text, callback}
        else
            self.LastCover = nil
        end
        return
    end

    if enable then
        self.WorkingCover:SetText(text)
        self.Loading:SetText(self.timeout)

        if type(callback) == 'function' then
            self:StartTimer(callback)
        else
            self:UpdateLoading(false)
        end

        self.WorkingCover:Show()
    else
        self:StopTimer()
        self.WorkingCover:Hide()
    end
end

function ExchangePanel:StartTimer(callback)
    if self.timeoutId then
        self:CancelTimer(self.timeoutId)
    end

    if self.loadingId then
        self:CancelTimer(self.loadingId)
    end

    self.timeoutId = self:ScheduleTimer(callback, self.timeout)
    self.loadingId = self:ScheduleRepeatingTimer('UpdateLoading', 1, true)
end

function ExchangePanel:StopTimer()
    self:CancelTimer(self.timeoutId)
    self:CancelTimer(self.loadingId)
    self.timeoutId = nil
    self.loadingId = nil
    self.Loading.t = nil
end

function ExchangePanel:UpdateLoading(enable)
    local Loading = self.Loading
    if enable then
        if Loading.t == 0 then
            Loading.t = self.timeout
            self:CancelTimer(self.loadingId)
            self.loadingId = nil
        else
            Loading.t = not Loading.t and self.timeout or Loading.t
            Loading.t = Loading.t - 1
        end
        Loading:SetText(Loading.t)
        Loading:Show()
    else
        Loading:Hide()
    end
end

function ExchangePanel:UpdateStatus(event, isConnected)
    self.IsConnectServer = isConnected

    if isConnected then
        self.WorkingCover:Hide()
        if self.LastCover then
            self:SetCover(unpack(self.LastCover))
            self.LastCover = nil
        end
    else
        self:StopTimer()
        self.WorkingCover:SetText(L['服务器连线中，请稍候'])
        self.WorkingCover:Show()
    end
end
