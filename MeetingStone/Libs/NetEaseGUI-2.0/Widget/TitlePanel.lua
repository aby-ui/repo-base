
local WIDGET, VERSION = 'TitlePanel', 1

local GUI = LibStub('NetEaseGUI-2.0')
local TitlePanel = GUI:NewClass(WIDGET, 'Frame', VERSION)
if not TitlePanel then
    return
end

function TitlePanel:Constructor(parent)
    self:EnableMouse(true)
    self:SetBackdrop{
        bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]],
        edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]],
        insets = { left = 8, right = 8, top = 8, bottom = 8 },
        tileSize = 24, edgeSize = 24, tile = true,
    }

    local Header = self:CreateTexture(nil, 'ARTWORK')
    Header:SetPoint('TOP', 0 ,12)
    Header:SetSize(250, 64)
    Header:SetTexture([[INTERFACE\DialogFrame\UI-DialogBox-Header]])

    local Title = self:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
    Title:SetPoint('TOP')

    local CloseButton = CreateFrame('Button', nil, self)
    CloseButton:SetPoint('TOPRIGHT')
    CloseButton:SetFrameLevel(parent:GetFrameLevel() + 6)
    CloseButton:SetSize(32, 32)
    CloseButton:SetNormalTexture([[Interface\Buttons\UI-Panel-MinimizeButton-Up]])
    CloseButton:SetDisabledTexture([[Interface\Buttons\UI-Panel-MinimizeButton-Disabled]])
    CloseButton:SetPushedTexture([[Interface\Buttons\UI-Panel-MinimizeButton-Down]])
    CloseButton:SetHighlightTexture([[Interface\Buttons\UI-Panel-MinimizeButton-Highlight]], 'ADD')

    local border = CloseButton:CreateTexture(nil, 'BACKGROUND')
    border:SetTexture([[Interface\DialogFrame\UI-DialogBox-Corner]])
    border:SetPoint('TOPRIGHT', -4, -4)

    CloseButton:SetScript('OnClick', HideParentPanelAby)

    self.Title = Title
    self.CloseButton = CloseButton
end

function TitlePanel:SetText(text)
    self.Title:SetText(text)
end

function TitlePanel:GetText()
    return self.Title:GetText()
end
