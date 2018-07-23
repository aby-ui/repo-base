
local WIDGET, VERSION = 'VerticalLine', 1

local GUI = LibStub('NetEaseGUI-2.0')
local VerticalLine = GUI:NewClass(WIDGET, 'Frame', VERSION)
if not VerticalLine then
    return
end

function VerticalLine:Constructor()
    self:SetWidth(12)

    local top = self:CreateTexture(nil, 'OVERLAY')
    top:SetSize(12, 12)
    top:SetTexture([[Interface\FriendsFrame\UI-ChannelFrame-VerticalBar]])
    top:SetTexCoord(0, 12/64, 0, 12/128)
    top:SetPoint('TOP')

    local bottom = self:CreateTexture(nil, 'OVERLAY')
    bottom:SetTexture([[Interface\FriendsFrame\UI-ChannelFrame-VerticalBar]])
    bottom:SetTexCoord(52/64, 1, 112/128, 124/128)
    bottom:SetSize(12, 12)
    bottom:SetPoint('BOTTOM')

    local middle = self:CreateTexture(nil, 'OVERLAY')
    middle:SetTexture([[Interface\FriendsFrame\UI-ChannelFrame-VerticalBar]])
    middle:SetTexCoord(0, 12/64, 12/128, 1)
    middle:SetPoint('TOPLEFT', top, 'BOTTOMLEFT')
    middle:SetPoint('BOTTOMRIGHT', bottom, 'TOPRIGHT')
end
