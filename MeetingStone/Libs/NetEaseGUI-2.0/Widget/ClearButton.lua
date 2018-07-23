
local WIDGET, VERSION = 'ClearButton', 1

local GUI = LibStub('NetEaseGUI-2.0')
local ClearButton = GUI:NewClass(WIDGET, 'Button', VERSION)
if not ClearButton then
    return
end

function ClearButton:Constructor()
    self:SetSize(17, 17)
    self:SetNormalTexture([[Interface\FriendsFrame\ClearBroadcastIcon]])
    self:GetNormalTexture():ClearAllPoints()

    self:OnLeave()
    self:OnMouseUp()

    self:SetScript('OnEnter', self.OnEnter)
    self:SetScript('OnLeave', self.OnLeave)
    self:SetScript('OnMouseDown', self.OnMouseDown)
    self:SetScript('OnMouseUp', self.OnMouseUp)
end

function ClearButton:OnEnter()
    self:GetNormalTexture():SetAlpha(1)
end

function ClearButton:OnLeave()
    self:GetNormalTexture():SetAlpha(0.3)
end

function ClearButton:OnMouseDown()
    if self:IsEnabled() then
        self:GetNormalTexture():SetPoint("TOPLEFT", 1, -1)
    end
end

function ClearButton:OnMouseUp()
    self:GetNormalTexture():SetPoint("TOPLEFT", 0, 0)
end
