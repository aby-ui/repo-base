--[[
@Date    : 2016-06-17 15:07:47
@Author  : DengSir (ldz5@qq.com)
@Link    : https://dengsir.github.io
@Version : $Id$
]]

BuildEnv(...)

local AppEmptyBlocker = Addon:NewClass('AppEmptyBlocker', 'Frame')

function AppEmptyBlocker:Constructor()
    local TopLeft = self:CreateTexture(nil, 'BACKGROUND') do
        TopLeft:SetPoint('TOPLEFT')
    end

    local Top = self:CreateTexture(nil, 'BACKGROUND') do
        Top:SetPoint('TOPLEFT', TopLeft, 'TOPRIGHT')
        Top:SetGradientAlpha('HORIZONTAL', 1, 1, 1, 1, 0.3, 0.3, 0.3, 0.3)
    end

    local TopRight = self:CreateTexture(nil, 'BACKGROUND') do
        TopRight:SetPoint('TOPLEFT', Top, 'TOPRIGHT')
        TopRight:SetVertexColor(0.3, 0.3, 0.3, 0.3)
    end

    local BottomLeft = self:CreateTexture(nil, 'BACKGROUND') do
        BottomLeft:SetPoint('TOPLEFT', TopLeft, 'BOTTOMLEFT')
    end

    local Bottom = self:CreateTexture(nil, 'BACKGROUND') do
        Bottom:SetPoint('TOPLEFT', BottomLeft, 'TOPRIGHT')
        Bottom:SetGradientAlpha('HORIZONTAL', 1, 1, 1, 1, 0.3, 0.3, 0.3, 0.3)
    end

    local BottomRight = self:CreateTexture(nil, 'BACKGROUND') do
        BottomRight:SetPoint('TOPLEFT', Bottom, 'TOPRIGHT')
        BottomRight:SetVertexColor(0.3, 0.3, 0.3, 0.3)
    end

    self.TopLeft = TopLeft
    self.Top = Top
    self.TopRight = TopRight
    self.BottomLeft = BottomLeft
    self.Bottom = Bottom
    self.BottomRight = BottomRight
    self.Summary = Summary

    self:SetScript('OnSizeChanged', self.OnSizeChanged)
end

BASE_SIZE = 256

function AppEmptyBlocker:OnSizeChanged()
    local width, height = self:GetSize()
    if width == 0 or height == 0 then
        return
    end
    local leftCut     = self:GetLeftCut()
    local tSize       = height / 2
    local tWidthLeft  = tSize * (BASE_SIZE - leftCut) / BASE_SIZE
    local tWidthRight = min(width - tSize * 2, tSize)

    self.TopLeft:SetSize(tWidthLeft, tSize)
    self.BottomLeft:SetSize(tWidthLeft, tSize)

    self.Top:SetSize(tSize, tSize)
    self.Bottom:SetSize(tSize, tSize)

    self.TopRight:SetSize(tWidthRight, tSize)
    self.BottomRight:SetSize(tWidthRight, tSize)

    self.TopRight:SetTexCoord(0, tWidthRight/tSize, 0, 1)
    self.BottomRight:SetTexCoord(0, tWidthRight/tSize, 0, 1)

    self.TopLeft:SetTexCoord(leftCut / BASE_SIZE, 1, 0, 1)
    self.BottomLeft:SetTexCoord(leftCut / BASE_SIZE, 1, 0, 1)
end

function AppEmptyBlocker:SetLeftCut(cut)
    self.leftCut = cut
end

function AppEmptyBlocker:GetLeftCut()
    return self.leftCut or 0
end

function AppEmptyBlocker:SetTextureGroup(t)
    if #t < 6 then
        error('texture group length < 6', 2)
    end

    self.TopLeft:SetTexture(t[1])
    self.Top:SetTexture(t[2])
    self.TopRight:SetTexture(t[3])
    self.BottomLeft:SetTexture(t[4])
    self.Bottom:SetTexture(t[5])
    self.BottomRight:SetTexture(t[6])

    self:OnSizeChanged()
end
