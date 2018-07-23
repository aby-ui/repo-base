

BuildEnv(...)

local Cover = Addon:NewClass('Cover', 'Frame')

function Cover:Constructor(parent)
    if parent then
        self:SetFrameLevel(parent:GetFrameLevel() + 20)
    end
    self:EnableMouse(true)
    self:EnableMouseWheel(true)
    self:SetScript('OnMouseWheel', nop)

    local bg = self:CreateTexture(nil, 'BACKGROUND') do
        bg:SetAllPoints(true)
        bg:SetColorTexture(0.035, 0.071, 0.118, 0.5)
    end

    local html = GUI:GetClass('SummaryHtml'):New(self) do
        html:SetPoint('CENTER', 0, 20)
        html:SetWidth(500)
    end

    local text = self:CreateFontString(nil, 'OVERLAY', 'GameFontNormal') do
        text:Hide()
        text:SetWidth(500)
        text:SetWordWrap(true)
    end

    local anim = CreateFrame('Frame', nil, self, 'NetEaseCoverAnimation') do
        anim:SetPoint('TOP', html, 'BOTTOM', 0, 10)
        anim:SetSize(100, 50)
        anim:Hide()
    end

    local Spinner = CreateFrame('Frame', nil, self, 'LoadingSpinnerTemplate') do
        Spinner:SetPoint('BOTTOM', html, 'TOP', 0, 16)
        Spinner.Anim:Play()
        Spinner:Hide()
    end

    self.Html = html
    self.Background = bg
    self.Spinner = Spinner
    self.Animation = anim
    self.Text = text
end

function Cover:SetStyle(style)
    if style == 'CIRCLE' then
        self.Icon = self.Spinner
    elseif style == 'LINE' then
        self.Icon = self.Animation
    end
end

function Cover:SetText(text, hideIcon)
    if not text then
        return
    elseif not text:match('<%w+>') then
        text = format('<html><body><p align="center">%s</p></body></html>', text)
    end

    self.Text:SetText(text:gsub('<[^>]+>', ''))
    local height = self.Text:GetHeight()

    self.Html:SetHeight(height)
    self.Html:SetText(text)


    if height < 40 then
        self.Html:SetPoint('CENTER', 0, 20)
    else
        self.Html:SetPoint('CENTER', 0, -20)
    end

    if self.Icon then
        self.Icon:SetShown(not hideIcon)
    end
end

function Cover:SetBackground(texture)
    self.Background:SetTexture(texture)
end