
BuildEnv(...)

local Button = Addon:NewClass('Button', 'Button') do
    GUI:Embed(Button, 'Tooltip')
    Button:SetTooltipAnchor('ANCHOR_RIGHT')
end

function Button:Constructor()
    self:EnableMouse(true)
    self:RegisterForClicks('LeftButtonUp')
    self:SetSize(36, 36)
    self:SetBackdrop{
        edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
        insets = { left = 2, right = 2, top = 2, bottom = 2 },
        tileSize = 16, edgeSize = 16, tile=true
    }
    self:SetBackdropBorderColor(0.8, 0.8, 0.8, 0.8)
    self:SetMotionScriptsWhileDisabled(true)

    local Text = self:CreateFontString(nil, 'OVERLAY')
    Text:SetPoint('LEFT', self, 'RIGHT', 2, 0)
    self:SetFontString(Text)
    self:SetNormalFontObject('GameFontNormalSmallLeft')
    self:SetHighlightFontObject('GameFontHighlightSmallLeft')
    self:SetDisabledFontObject('GameFontDisableSmallLeft')

    local Icon = self:CreateTexture(nil, 'BACKGROUND')
    Icon:SetPoint('TOPLEFT', 3, -3)
    Icon:SetPoint('BOTTOMRIGHT', -3, 3)

    local Highlight = self:CreateTexture(nil, 'HIGHLIGHT')
    Highlight:SetPoint('TOPLEFT', 3, -3)
    Highlight:SetPoint('BOTTOMRIGHT', -3, 3)
    Highlight:SetTexture([[INTERFACE\BUTTONS\ButtonHilight-Square]])
    Highlight:SetBlendMode('ADD')

    self:SetScript('OnEnable', self.OnEnable)
    self:SetScript('OnDisable', self.OnDisable)

    self.Icon = Icon
    self.Text = Text
end

function Button:SetText(text)
    self.Text:SetText(text)
    self:SetHitRectInsets(0, -self.Text:GetWidth(), 0, 0)
end

function Button:OnEnable()
    if self.Cooldown then
        self.Cooldown:SetCooldown(0, 0)
    else
        self.Icon:SetDesaturated(false)
    end
end

function Button:OnDisable()
    if self.Cooldown then
        self.Cooldown:SetCooldown(GetTime(), self.cooldown)
    else
        self.Icon:SetDesaturated(true)
    end
end

function Button:SetIcon(icon)
    self.Icon:SetTexture(icon)
end

function Button:SetIconTexCoord(left, right, top, bottom)
    self.Icon:SetTexCoord(left, right, top, bottom)
end

function Button:SetCooldown(cooldown)
    if not self.Cooldown then
        local Cooldown = CreateFrame('Cooldown', nil, self, 'CooldownFrameTemplate') do
            Cooldown:SetPoint('TOPLEFT', 4, -4)
            Cooldown:SetPoint('BOTTOMRIGHT', -4, 4)
            Cooldown:SetHideCountdownNumbers(true)
            Cooldown:SetScript('OnCooldownDone', function()
                self:Enable()
            end)
        end
        self.Cooldown = Cooldown
        self:SetDisabledFontObject('GameFontNormalSmallLeft')
    end
    self.cooldown = cooldown
    self.Icon:SetDesaturated(false)
end
