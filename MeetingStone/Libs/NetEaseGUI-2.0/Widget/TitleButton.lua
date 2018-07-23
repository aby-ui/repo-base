
local WIDGET, VERSION = 'TitleButton', 2

local GUI = LibStub('NetEaseGUI-2.0')
local TitleButton = GUI:NewClass(WIDGET, 'Button', VERSION)
if not TitleButton then
    return
end

function TitleButton:Constructor()
    self:SetSize(16, 16)
    self:SetHighlightTexture([[INTERFACE\Challenges\challenges-metalglow]], 'ADD')
    self:GetHighlightTexture():SetTexCoord(0.25, 0.75, 0.25, 0.75)

    self:SetScript('OnEnter', self.OnEnter)
    self:SetScript('OnLeave', GameTooltip_Hide)
end

function TitleButton:SetTexture(texture, left, right, top, bottom)
    self:SetNormalTexture(texture)
    self:GetNormalTexture():SetTexCoord(left or 0, right or 1, top or 0, bottom or 1)
end

function TitleButton:SetTooltip(...)
    self.tooltips = {...}
end

function TitleButton:OnEnter()
    if not self.tooltips then
        return
    end
    GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
    for i, v in ipairs(self.tooltips) do
        if i == 1 then
            GameTooltip:SetText(v)
        else
            GameTooltip:AddLine(v, 1, 1, 1, 1)
        end
    end
    GameTooltip:Show()
end

local function AnimOnShow(self)
    self.Group:Play()
end

local function AnimOnHide(self)
    self.Group:Stop()
end

function TitleButton:PlayAnimation()
    if not self.Anim then
        local Anim = CreateFrame('Frame', nil, self)
        Anim:Hide()
        Anim:SetAllPoints(self)
        Anim:SetScript('OnShow', AnimOnShow)
        Anim:SetScript('OnHide', AnimOnHide)
        local Icon = Anim:CreateTexture(nil, 'OVERLAY')
        Icon:SetPoint('CENTER', 1, 0)
        Icon:SetSize(48, 48)
        Icon:SetTexture([[INTERFACE\Cooldown\star4]])
        Icon:SetBlendMode('ADD')
        -- Icon:SetVertexColor(0, 1, 0)
        local Group = Anim:CreateAnimationGroup()
        Group:SetLooping('BOUNCE')
        local Alpha = Group:CreateAnimation('Alpha')
        Alpha:SetDuration(0.75)
        Alpha:SetFromAlpha(1)
        Alpha:SetToAlpha(0.3)
        local Scale = Group:CreateAnimation('Scale')
        Scale:SetDuration(0.75)
        Scale:SetScale(0.5, 0.5)

        Anim.Group = Group
        self.Anim = Anim
    end
    self.Anim:Show()
end

function TitleButton:StopAnimation()
    if self.Anim then
        self.Anim:Hide()
    end
end
