--[[
@Date    : 2016-06-16 14:01:43
@Author  : DengSir (ldz5@qq.com)
@Link    : https://dengsir.github.io
@Version : $Id$
]]

local WIDGET, VERSION = 'LeftTabPanel', 2

local GUI = LibStub('NetEaseGUI-2.0')
local LeftTabPanel = GUI:NewClass(WIDGET, 'Frame', VERSION, 'TabPanel')
if not LeftTabPanel then
    return
end

function LeftTabPanel:Constructor()
    local LBackground = self:CreateTexture(nil, 'BORDER') do
        LBackground:SetWidth(209)
        LBackground:SetPoint('TOPLEFT')
        LBackground:SetPoint('BOTTOMLEFT')
        LBackground:SetTexture([[Interface\Common\bluemenu-main]])
        LBackground:SetTexCoord(0.00390625, 0.82421875, 0.18554688, 0.58984375)

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

        local TFiligree = self:CreateTexture(nil, 'BORDER') do
            TFiligree:SetSize(185, 55)
            TFiligree:SetPoint('TOP', LBackground, 'TOP', 0, -6)
            TFiligree:SetTexture([[Interface\Common\bluemenu-main]])
            TFiligree:SetTexCoord(0.00390625, 0.72656250, 0.12988281, 0.18359375)
        end

        local BFiligree = self:CreateTexture(nil, 'BORDER') do
            BFiligree:SetSize(185, 55)
            BFiligree:SetPoint('BOTTOM', LBackground, 'BOTTOM', 0, 6)
            BFiligree:SetTexture([[Interface\Common\bluemenu-main]])
            BFiligree:SetTexCoord(0.26171875, 0.98437500, 0.06542969, 0.11914063)
        end

        local HLine = self:CreateTexture(nil, 'ARTWORK') do
            HLine:SetPoint('TOPLEFT', TRCorner, 'TOPRIGHT')
            HLine:SetPoint('BOTTOMLEFT', BRCorner, 'BOTTOMRIGHT')
            HLine:SetWidth(5)
            HLine:SetTexCoord(0.00781250, 0.04687500, 0, 1)
            HLine:SetTexture([[Interface\Common\bluemenu-vert]])
        end
    end

    local Title = self:CreateFontString(nil, 'OVERLAY', 'QuestFont_Super_Huge') do
        Title:SetPoint('TOPLEFT', LBackground, 'TOPRIGHT', 30, -15)
    end

    local TabFrame = GUI:GetClass('TabView'):New(self) do
        TabFrame:SetHeight(1)
        TabFrame:SetPoint('TOPLEFT', LBackground, 'TOPLEFT', -6, -60)
        TabFrame:SetPoint('TOPRIGHT', LBackground, 'TOPRIGHT', -6, -60)
        TabFrame:SetOrientation('VERTICAL', 'LEFT')
        TabFrame:SetItemClass(GUI:GetClass('LeftTabItem'))
        TabFrame:EnableMenu(nil)
        TabFrame:SetItemList(self:GetPanelList())
        TabFrame:SetCallback('OnItemFormatted', function(TabFrame, button, data)
            button:SetText(data.name)
            button:SetIcon(data.icon)
        end)
        TabFrame:SetCallback('OnSelectChanged', function(TabFrame, index, data)
            for i, data in ipairs(self:GetPanelList()) do
                data.panel:SetShown(i == index)
            end
            Title:SetText(self:GetPanelList()[index].name)
        end)

        TabFrame.GetItemSpacing = function()
            local tabs = #self:GetPanelList()
            if tabs <= 1 or tabs >= 4 then
                return 0
            elseif tabs == 2 then
                return 25
            elseif tabs == 3 then
                return 15
            end
        end
    end

    local Inset = CreateFrame('Frame', nil, self, 'InsetFrameTemplate') do
        Inset:SetPoint('BOTTOMRIGHT', 0, 22)
        Inset:SetPoint('TOPLEFT', LBackground, 'TOPRIGHT', 10, -48)
    end

    self.TabFrame = TabFrame
    self.Inset = Inset
    self.LBackground = LBackground
    self.Title = Title
end

function LeftTabPanel:GetTabFrame()
    return self.TabFrame
end

function LeftTabPanel:SetTopHeight(topHeight)
    self.Inset:SetPoint('TOPLEFT', self.LBackground, 'TOPRIGHT', 10, -topHeight)
    self.Title:SetPoint('TOPLEFT', self.LBackground, 'TOPRIGHT', 30, -topHeight / 2 + 9)
end

function LeftTabPanel:SetBottomHeight(bottomHeight)
    self.Inset:SetPoint('BOTTOMRIGHT', 0, bottomHeight)
end

function LeftTabPanel:InjectPanelArgs()
    return {
        padding      = 3,
        topHeight    = 20,
        bottomHeight = 1,
        noInset      = true,
    }
end

local orig_RegisterPanel = LeftTabPanel.RegisterPanel
function LeftTabPanel:RegisterPanel(name, icon, ...)
    orig_RegisterPanel(self, name, ...).icon = icon
end
