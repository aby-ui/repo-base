
local WIDGET, VERSION = 'Panel', 5

local GUI = LibStub('NetEaseGUI-2.0')
local Panel = GUI:NewClass(WIDGET, 'Frame.NetEasePanelTemplate', VERSION, 'TabPanel')
if not Panel then
    return
end

function Panel:Constructor()
    self:EnableMouse(true)
    self:SetToplevel(true)
    self:SetSize(338, 424)

    self:SetScript('OnShow', self.OnShow)
    self:SetScript('OnHide', self.OnHide)
end

function Panel:OnShow()
    PlaySound(SOUNDKIT and SOUNDKIT.IG_CHARACTER_INFO_OPEN or 'igCharacterInfoOpen')
    self:UpdateTab()
end

function Panel:OnHide()
    PlaySound(SOUNDKIT and SOUNDKIT.IG_CHARACTER_INFO_CLOSE or 'igCharacterInfoClose')
end

function Panel:HidePortrait()
    self.PortraitFrame:Hide()
    self.TopLeftCorner:Show()
    self.TopBorderBar:SetPoint('TOPLEFT', self.TopLeftCorner, 'TOPRIGHT',  0, 0)
    self.LeftBorderBar:SetPoint('TOPLEFT', self.TopLeftCorner, 'BOTTOMLEFT',  0, 0)
end

function Panel:ShowPortrait()
    self.PortraitFrame:Show();
    self.TopLeftCorner:Hide();
    self.TopBorderBar:SetPoint('TOPLEFT', self.PortraitFrame, 'TOPRIGHT',  0, -10)
    self.LeftBorderBar:SetPoint('TOPLEFT', self.PortraitFrame, 'BOTTOMLEFT',  8, 0)
end

function Panel:SetTopHeight(height)
    self.topHeight = height
    self.Inset:SetPoint('TOPLEFT', 4, -height)
    self.Inset2:SetPoint('TOPLEFT', 4, -height)
end

function Panel:SetBottomHeight(height)
    self.bottomHeight = height
    self.Inset:SetPoint('BOTTOMRIGHT', -6, height)
    self.Inset2:SetPoint('BOTTOMRIGHT', -6, height)
end

function Panel:GetTopHeight()
    return self.topHeight or 60
end

function Panel:GetBottomHeight()
    return self.bottomHeight or 26
end

function Panel:SetIcon(texture, left, right, top, bottom)
    if texture == 'player' or texture == 'target' or texture == 'focus' or type(texture) == 'table' then
        SetPortraitTexture(self.Portrait, type(texture) == 'table' and texture[1] or texture)
    elseif left then
        self.Portrait:SetTexture(texture)
        self.Portrait:SetTexCoord(left, right, top, bottom)
    else
        self.Portrait:SetTexture(texture)
        SetPortraitToTexture(self.Portrait, texture)
    end
end

function Panel:SetText(text)
    self.TitleText:SetText(text)
end

function Panel:GetText()
    return self.TitleText:GetText()
end

function Panel:SetArguments(...)
    self.args = {...}
end

function Panel:GetArguments()
    if self.args then
        return unpack(self.args)
    end
end

function Panel:EnableUIPanel(flag)
    self:SetPoint('CENTER')

    self:Hide()

    if flag then
        self:SetAttribute('UIPanelLayout-defined', true)
        self:SetAttribute('UIPanelLayout-enabled', true)
        self:SetAttribute('UIPanelLayout-whileDead', true)
        self:SetAttribute('UIPanelLayout-area', 'left')
        self:SetAttribute('UIPanelLayout-pushable', 1)
    else
        self:SetAttribute('UIPanelLayout-defined', false)
        self:SetAttribute('UIPanelLayout-enabled', false)
        self:SetAttribute('UIPanelLayout-whileDead', false)
        self:SetAttribute('UIPanelLayout-area', nil)
        self:SetAttribute('UIPanelLayout-pushable', nil)
    end
end

function Panel:Open(name, icon, ...)
    self:SetArguments(...)
    self:SetText(name)
    self:SetIcon(icon)

    self:Show()
end

function Panel:Refresh()
    for i, v in ipairs(self:GetPanelList()) do
        v.panel:Refresh()
    end
    if self.TabFrame then
        self.TabFrame:Refresh()
    end
end

function Panel:SetTabStyle(style)
    self.tabStyle = style
end

function Panel:GetTabFrame()
    if self.noTab then
        return
    end
    if self.TabFrame then
        return self.TabFrame
    end
    if not self.tabStyle or self.tabStyle == 'IN' then
        local TabFrame = GUI:GetClass('TabView'):New(self)
        TabFrame:SetSize(1, 22)
        TabFrame:SetPoint('BOTTOMLEFT', self.Inset, 'TOPLEFT', 55, 0)
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
        return TabFrame
    elseif self.tabStyle == 'BOTTOM' then
        local TabFrame = GUI:GetClass('TabView'):New(self)
        TabFrame:SetSize(1, 22)
        TabFrame:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 10, -8)
        TabFrame:EnableMenu(nil)
        TabFrame:SetItemClass(GUI:GetClass('BottomTabButton'))
        TabFrame:SetItemList(self:GetPanelList())
        TabFrame:SetCallback('OnItemFormatted', function(tabframe, button, data)
            button:SetText(data.name)
        end)
        TabFrame:SetCallback('OnSelectChanged', function(tabframe, index, data)
            for i, data in ipairs(self:GetPanelList()) do
                if i == index then
                    self.Inset:SetShown(not data.noInset)
                    self.Inset2:SetShown(data.noInset)
                    self:SetTopHeight(data.topHeight)
                    self:SetBottomHeight(data.bottomHeight)
                    data.panel:Show()
                else
                    data.panel:Hide()
                end
            end
        end)
        TabFrame:SetCallback('OnFlashCreated', function(TabFrame, button, _, Flash)
            Flash:ClearAllPoints()
            Flash:SetTexture([[Interface\PaperDollInfoFrame\UI-Character-Tab-RealHighlight]], 'ADD')
            Flash:SetPoint('TOPLEFT', 4, 5)
            Flash:SetPoint('BOTTOMRIGHT', -4, 0)
            Flash:SetTexCoord(0.1, 0.9, 0, 1)
            Flash:SetDuration(0.8)
        end)
        self.TabFrame = TabFrame
        return TabFrame
    end
end

local function unpack(t, ...)
    if type(t) == 'table' then
        return _G.unpack(t, ...)
    else
        return t, ...
    end
end

function Panel:CreateTitleButton(t)
    self.titleButtons = self.titleButtons or {}

    local button = GUI:GetClass('TitleButton'):New(self)
    button:SetScript('OnClick', t.callback or t.onClick)
    button:SetTexture(t.texture, unpack(t.coords))
    button:SetTooltip(t.title or t.text, unpack(t.notes))

    if t.size then
        button:SetSize(unpack(t.size))
    end

    if #self.titleButtons == 0 then
        button:SetPoint('TOPRIGHT', -30, -3)
    else
        button:SetPoint('RIGHT', self.titleButtons[#self.titleButtons], 'LEFT', -2, 0)
    end

    tinsert(self.titleButtons, button)
    return button
end
