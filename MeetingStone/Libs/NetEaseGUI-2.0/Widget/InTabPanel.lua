
local WIDGET, VERSION = 'InTabPanel', 2

local GUI = LibStub('NetEaseGUI-2.0')
local InTabPanel = GUI:NewClass(WIDGET, 'Frame', VERSION, 'TabPanel')
if not InTabPanel then
    return
end

function InTabPanel:Constructor()
    local TabFrame = GUI:GetClass('TabView'):New(self)
    TabFrame:SetSize(1, 22)
    TabFrame:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 10, 0)
    TabFrame:EnableMenu(nil)
    TabFrame:SetItemClass(GUI:GetClass('InTabButton'))
    TabFrame:SetItemList(self:GetPanelList())
    TabFrame:SetCallback('OnItemFormatted', function(tabframe, button, data)
        button:SetText(data.name)
    end)
    TabFrame:SetCallback('OnSelectChanged', function(tabframe, index, data)
        for i, data in ipairs(self:GetPanelList()) do
            data.panel:SetShown(i == index)
        end
    end)

    self.TabFrame = TabFrame
    self.Inset = self

    self:SetScript('OnShow', self.UpdateTab)
end

function InTabPanel:GetTabFrame()
    return self.TabFrame
end