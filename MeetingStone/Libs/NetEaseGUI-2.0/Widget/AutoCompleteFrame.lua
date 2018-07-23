
local WIDGET, VERSION = 'AutoCompleteFrame', 1

local GUI = LibStub('NetEaseGUI-2.0')
local AutoCompleteFrame = GUI:NewClass(WIDGET, GUI:GetClass('GridView'), VERSION)
if not AutoCompleteFrame then
    return
end

function AutoCompleteFrame:Constructor()
    self:SetItemClass(GUI:GetClass('AutoCompleteItem'))
    self:SetItemHeight(22)
    self:SetItemSpacing(0)
    self:SetAutoSize(true)
    self:SetSelectMode('RADIO')

    local bottomLeft = self:CreateTexture(nil, 'ARTWORK') do
        bottomLeft:SetTexture([[Interface\FrameGeneral\UI-Frame]])
        bottomLeft:SetTexCoord(0.00781250, 0.11718750, 0.63281250, 0.74218750)
        bottomLeft:SetPoint('BOTTOMLEFT', -8, -8)
        bottomLeft:SetSize(14, 14)
    end

    local bottomRight = self:CreateTexture(nil, 'ARTWORK') do
        bottomRight:SetTexture([[Interface\FrameGeneral\UI-Frame]])
        bottomRight:SetTexCoord(0.13281250, 0.21875000, 0.89843750, 0.98437500)
        bottomRight:SetPoint('BOTTOMRIGHT', 4, -8)
        bottomRight:SetSize(11, 11)
    end

    local bottom = self:CreateTexture(nil, 'ARTWORK') do
        bottom:SetTexture([[Interface\FrameGeneral\_UI-Frame]])
        bottom:SetTexCoord(0.00000000, 1.00000000, 0.20312500, 0.27343750)
        bottom:SetHorizTile(true)
        bottom:SetPoint('BOTTOMLEFT', bottomLeft, 'BOTTOMRIGHT')
        bottom:SetPoint('BOTTOMRIGHT', bottomRight, 'BOTTOMLEFT')
        bottom:SetHeight(9)
    end

    local left = self:CreateTexture(nil, 'ARTWORK') do
        left:SetTexture([[Interface\FrameGeneral\!UI-Frame]])
        left:SetTexCoord(0.35937500, 0.60937500, 0.00000000, 1.00000000)
        left:SetVertTile(true)
        left:SetPoint('TOPLEFT', -8, 0)
        left:SetPoint('BOTTOMLEFT', bottomLeft, 'TOPLEFT', -8, 0)
        left:SetWidth(16)
    end

    local right = self:CreateTexture(nil, 'ARTWORK') do
        right:SetTexture([[Interface\FrameGeneral\!UI-Frame]])
        right:SetTexCoord(0.17187500, 0.32812500, 0.00000000, 1.00000000)
        right:SetVertTile(true)
        right:SetPoint('TOPRIGHT', 5, 0)
        right:SetPoint('BOTTOMRIGHT', bottomRight, 'TOPRIGHT', 5, 0)
        right:SetWidth(10)
    end

    local bg = self:CreateTexture(nil, 'BACKGROUND') do
        bg:SetAllPoints(true)
        bg:SetTexture([[Interface\FrameGeneral\UI-Background-Marble]])
    end

    self:SetScript('OnHide', self.OnHide)
end

function AutoCompleteFrame:OnHide()
    self:SetSelected(nil)
end
