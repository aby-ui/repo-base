
local WIDGET, VERSION = 'PanelBlocker', 2

local GUI = LibStub('NetEaseGUI-2.0')
local PanelBlocker = GUI:NewClass(WIDGET, 'Frame', VERSION)
if not PanelBlocker then
    return
end

function PanelBlocker:Constructor()
    self:Hide()
    self:EnableMouse(true)
    self:EnableMouseWheel(true)
    self:SetScript('OnMouseWheel', nop)
    self:SetScript('OnShow', self.OnInit)
end

function PanelBlocker:OnInit()
    local LBackground = self:CreateTexture(nil, 'BORDER', 'NetEaseBlockerBgTemplate') do
        LBackground:SetAllPoints(true)

        local TLCorner = self:CreateTexture(nil, 'ARTWORK') do
            TLCorner:SetSize(64, 64)
            TLCorner:SetPoint('TOPLEFT', LBackground, 'TOPLEFT')
            TLCorner:SetTexture([[Interface\Common\bluemenu-main]])
            TLCorner:SetTexCoord(0.00390625, 0.25390625, 0.00097656, 0.06347656)
        end

        local TRCorner = self:CreateTexture(nil, 'ARTWORK') do
            TRCorner:SetSize(64, 64)
            TRCorner:SetPoint('TOPRIGHT', LBackground, 'TOPRIGHT')
            TRCorner:SetTexture([[Interface\Common\bluemenu-main]])
            TRCorner:SetTexCoord(0.51953125, 0.76953125, 0.00097656, 0.06347656)
        end

        local BRCorner = self:CreateTexture(nil, 'ARTWORK') do
            BRCorner:SetSize(64, 64)
            BRCorner:SetPoint('BOTTOMRIGHT', LBackground, 'BOTTOMRIGHT')
            BRCorner:SetTexture([[Interface\Common\bluemenu-main]])
            BRCorner:SetTexCoord(0.00390625, 0.25390625, 0.06542969, 0.12792969)
        end

        local BLCorner = self:CreateTexture(nil, 'ARTWORK') do
            BLCorner:SetSize(64, 64)
            BLCorner:SetPoint('BOTTOMLEFT', LBackground, 'BOTTOMLEFT')
            BLCorner:SetTexture([[Interface\Common\bluemenu-main]])
            BLCorner:SetTexCoord(0.26171875, 0.51171875, 0.00097656, 0.06347656)
        end

        local LLine = self:CreateTexture(nil, 'ARTWORK') do
            LLine:SetWidth(43)
            LLine:SetPoint('TOPLEFT', TLCorner, 'BOTTOMLEFT')
            LLine:SetPoint('BOTTOMLEFT', BLCorner, 'TOPLEFT')
            LLine:SetTexture([[Interface\Common\bluemenu-vert]])
            LLine:SetTexCoord(0.06250000, 0.39843750, 0.00000000, 1.00000000)
        end

        local RLine = self:CreateTexture(nil, 'ARTWORK') do
            RLine:SetWidth(43)
            RLine:SetPoint('TOPRIGHT', TRCorner, 'BOTTOMRIGHT')
            RLine:SetPoint('BOTTOMRIGHT', BRCorner, 'TOPRIGHT')
            RLine:SetTexture([[Interface\Common\bluemenu-vert]])
            RLine:SetTexCoord(0.41406250, 0.75000000, 0.00000000, 1.00000000)
        end

        local BLine = self:CreateTexture(nil, 'ARTWORK') do
            BLine:SetHeight(43)
            BLine:SetPoint('BOTTOMLEFT', BLCorner, 'BOTTOMRIGHT')
            BLine:SetPoint('BOTTOMRIGHT', BRCorner, 'BOTTOMLEFT')
            BLine:SetTexture([[Interface\Common\bluemenu-goldborder-horiz]])
            BLine:SetTexCoord(0.00000000, 1.00000000, 0.35937500, 0.69531250)
        end

        local TLine = self:CreateTexture(nil, 'ARTWORK') do
            TLine:SetHeight(43)
            TLine:SetPoint('TOPLEFT', TLCorner, 'TOPRIGHT')
            TLine:SetPoint('TOPRIGHT', TRCorner, 'TOPLEFT')
            TLine:SetTexture([[Interface\Common\bluemenu-goldborder-horiz]])
            TLine:SetTexCoord(0.00000000, 1.00000000, 0.00781250, 0.34375000)
        end
    end

    self:SetScript('OnShow', nil)
    self:Fire('OnInit')

    for i, v in ipairs({self:GetChildren()}) do
        v:SetFrameLevel(self:GetFrameLevel() + 1)
    end
end

function PanelBlocker:SetOrder(order)
    self.order = order
end

function PanelBlocker:GetOrder()
    return self.order
end

function PanelBlocker:SetBlockTabs(blockTabs)
    self.blockTabs = blockTabs
end

function PanelBlocker:GetBlockTabs()
    return self.blockTabs
end
