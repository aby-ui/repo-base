--[[
AppQrDialog.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

BuildEnv(...)

AppQrDialog = CreateFrame('Frame', nil, UIParent)
AppQrDialog:Hide()
AppQrDialog:SetScript('OnShow', function(self)
    self:SetScript('OnShow', nil)
    self:Init()
end)

function AppQrDialog:Init()
    self:SetPoint('CENTER')
    self:SetSize(260, 320)
    self:SetBackdrop{
        bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]],
        edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
        edgeSize = 16, tileSize = 16, tile = true,
        insets = {left = 4, right = 4, top = 4, bottom = 4},
    }
    self:SetBackdropColor(0, 0, 0, 1)
    self:SetMovable(true)
    self:EnableMouse(true)
    self:SetClampedToScreen(true)
    self:RegisterForDrag('LeftButton')
    self:SetScript('OnDragStart', self.StartMoving)
    self:SetScript('OnDragStop', self.StopMovingOrSizing)

    local CloseButton = CreateFrame('Button', nil, self, 'UIPanelCloseButton') do
        CloseButton:SetPoint('TOPRIGHT')
    end

    local QrWidget = GUI:GetClass('QRCodeWidget'):New(self) do
        QrWidget:SetPoint('TOPLEFT', 20, -20)
        QrWidget:SetSize(220, 220)
        QrWidget:SetMargin(5)
        QrWidget:SetValue(APP_DOWNLOAD_URL)
        QrWidget:Show()
        QrWidget:EnableMouse(false)
    end

    local Icon = QrWidget.CodeFrame:CreateTexture(nil, 'OVERLAY', 1) do
        Icon:SetSize(45, 45)
        Icon:SetPoint('CENTER')
        Icon:SetTexture([[Interface\AddOns\MeetingStone\Media\appicon]])
    end

    local Label = self:CreateFontString(nil, 'ARTWORK') do
        Label:SetFont(STANDARD_TEXT_FONT, 26)
        Label:SetShadowColor(0, 0, 0)
        Label:SetShadowOffset(2, -2)
        Label:SetTextColor(NORMAL_FONT_COLOR:GetRGB())
        Label:SetPoint('TOP', QrWidget, 'BOTTOM', 0, -10)
        Label:SetText(L['扫描二维码\n下载随身集合石APP'])
    end
end
