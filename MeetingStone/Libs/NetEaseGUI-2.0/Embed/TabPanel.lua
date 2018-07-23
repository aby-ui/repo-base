
local GUI = LibStub('NetEaseGUI-2.0')
local View = GUI:NewEmbed('TabPanel', 4)
if not View then
    return
end

View._PanelList = View._PanelList or setmetatable({}, {__index = function(t, k)
    t[k] = {}
    return t[k]
end})

local _PanelList = View._PanelList

function View:EnableTabFrame(flag)
    self.noTab = not flag or nil
    if self.TabFrame then
        self.TabFrame:Hide()
    end
end

function View:GetPanelList()
    return _PanelList[self]
end

function View:UpdateTab()
    if not self.noTab then
        if self.selectTab then
            self:GetTabFrame():SetSelected(self.selectTab)
            self.selectTab = nil
        end
        self:GetTabFrame():Refresh()
    else
        local data = _PanelList[self][1]
        if data then
            data.panel:Show()

            if self.Inset2 then
                self.Inset:SetShown(not data.noInset)
                self.Inset2:SetShown(data.noInset)
            elseif self.Inset then
                self.Inset:Show()
            end
        end
    end
end

local function parseArgs(panel, opts, ...)
    if type(opts) ~= 'table' then
        opts = {
            padding = opts,
        }
        opts.topHeight, opts.bottomHeight, opts.noInset = ...
    end

    if panel.InjectPanelArgs then
        local default = panel:InjectPanelArgs()
        if default then
            for k, v in pairs(default) do
                if opts[k] == nil then
                    opts[k] = v
                end
            end
        end
    end
    return opts
end

function View:RegisterPanel(name, panel, ...)
    if self.noTab then
        if #_PanelList[self] > 0 then
            error([[Can register only one panel into notab container.]], 2)
        end
    end
    if self:IsPanelRegistered(name) then
        error([[Cannot register panel (same name)]], 2)
    end

    GUI:Embed(panel, 'Owner')

    local opts = parseArgs(panel, ...)
    local data = {
        name         = name,
        panel        = panel,
        topHeight    = opts.topHeight or self.GetTopHeight and self:GetTopHeight() or 0,
        bottomHeight = opts.bottomHeight or self.GetBottomHeight and self:GetBottomHeight() or 0,
        noInset      = opts.noInset,
    }

    local offset
    if opts.before then
        local i, v = self:IsPanelRegistered(opts.before)
        if i then
            offset = i
        end
    elseif opts.after then
        local i, v = self:IsPanelRegistered(opts.after)
        if i then
            offset = i + 1
        end
    end

    if offset then
        tinsert(_PanelList[self], offset, data)

        local selectTab = self:GetSelectedTab()
        if selectTab and selectTab >= offset then
            self:SelectTab(selectTab + 1)
        end
    else
        tinsert(_PanelList[self], data)
    end

    local padding = opts.padding or 10

    panel:Hide()
    panel:SetOwner(self)
    panel:SetParent(opts.noInset and self.Inset2 or self.Inset)
    panel:ClearAllPoints()
    panel:SetPoint('TOPLEFT', padding, -padding)
    panel:SetPoint('BOTTOMRIGHT', -padding, padding)
    panel:SetFrameLevel(self.Inset:GetFrameLevel()+1)

    self:UpdateTab()

    if self.PortraitFrame then
        self.PortraitFrame:SetFrameLevel(max(panel:GetFrameLevel()+1, self.PortraitFrame:GetFrameLevel()))
    end

    return data
end

function View:UnregisterPanel(name)
    local i, v = self:IsPanelRegistered(name)
    if i then
        tremove(_PanelList[self], i)

        v.panel:Hide()
        v.panel:ClearAllPoints()
        v.panel:SetParent(nil)
    end
end

function View:IsPanelRegistered(name)
    for i, v in ipairs(_PanelList[self]) do
        if v.name == name then
            return i, v
        end
    end
end

function View:UnregisterAllPanels()
    for i, v in ipairs(_PanelList[self]) do
        v.panel:Hide()
        v.panel:ClearAllPoints()
        v.panel:SetParent(nil)
    end
    wipe(_PanelList[self])
end

function View:EnableTab(index)
    local tabframe = self:GetTabFrame()
    if tabframe then
        tabframe:EnableTab(index)
    end
end

function View:DisableTab(index)
    local tabframe = self:GetTabFrame()
    if tabframe then
        tabframe:DisableTab(index)
    end
end

function View:SetTabEnabled(index, flag)
    local tabframe = self:GetTabFrame()
    if tabframe then
        tabframe:SetTabEnabled(index, flag)
    end
end

function View:SelectTab(index)
    self.selectTab = index
    local tabframe = self:GetTabFrame()
    if tabframe then
        tabframe:SetSelected(index)
    end
end

function View:SetTabText(index, text)
    local tabframe = self:GetTabFrame()
    if not tabframe then
        return
    end
    if _PanelList[self] and _PanelList[self][index] then
        _PanelList[self][index].name = text
    end
    tabframe:Refresh()
end

function View:GetPanelIndex(panel)
    for i, v in ipairs(_PanelList[self]) do
        if v.panel == panel then
            return i
        end
    end
end

function View:SelectPanel(panel)
    local index = self:GetPanelIndex(panel)
    if index then
        self:SelectTab(index)
    end
end

function View:EnablePanel(panel)
    local index = self:GetPanelIndex(panel)
    if index then
        self:EnableTab(index)
    end
end

function View:DisablePanel(panel)
    local index = self:GetPanelIndex(panel)
    if index then
        self:DisableTab(index)
    end
end

function View:SetPanelEnabled(panel, flag)
    local index = self:GetPanelIndex(panel)
    if index then
        self:SetTabEnabled(index, flag)
    end
end

function View:SetPanelText(panel, text)
    local index = self:GetPanelIndex(panel)
    if index then
        self:SetTabText(index, text)
    end
end

function View:GetSelectedTab()
    local tabframe = self:GetTabFrame()
    if tabframe then
        return tabframe:GetSelected()
    end
end

function View:GetSelectedPanel()
    local index = self:GetSelectedTab()
    return _PanelList[self][index] and _PanelList[self][index].panel
end

function View:GetPanelByIndex(index)
    return _PanelList[self][index] and _PanelList[self][index].panel
end

function View:FlashTab(index, flag)
    local tabframe = self:GetTabFrame()
    if tabframe then
        return tabframe:FlashTab(index, flag)
    end
end

function View:FlashTabByPanel(panel, flag)
    local index = self:GetPanelIndex(panel)
    if index then
        return self:FlashTab(index, flag)
    end
end
