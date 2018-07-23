
local WIDGET, VERSION = 'TabView', 3

local GUI = LibStub('NetEaseGUI-2.0')
local TabView = GUI:NewClass(WIDGET, 'Frame', VERSION, 'Refresh', 'View')
if not TabView then
    return
end

GUI:GetEmbed('Select').SetSelectMode(TabView, 'RADIO')

function TabView:Constructor()
    self.buttons = {}
    self:SetScript('OnShow', self.Refresh)
    self:SetScript('OnSizeChanged', self.Refresh)
end

function TabView:Update()
    if not self:GetSelected() then
        return self:SetSelected(1)
    end
    if not self:GetItemList() then
        return
    end
    if self.menu then
        self.menu:Hide()
    end
    -- for _, button in pairs(self.buttons) do
    --     button:Hide()
    -- end
    self:UpdateItems()
end

function TabView:GetItemPoint(i)
    local orientation, align = self:GetOrientation()
    local itemSpacing = self:GetItemSpacing()

    if orientation == 'HORIZONTAL' then
        if i == 1 then
            return align .. 'LEFT'
        else
            return align .. 'LEFT', self:GetButton(i-1), align .. 'RIGHT', itemSpacing, 0
        end
    else
        if i == 1 then
            return 'TOP' .. align
        else
            return 'TOP' .. align, self:GetButton(i-1), 'BOTTOM' .. align, 0, -itemSpacing
        end
    end
end

function TabView:IsButtonOverflow(i)
    local button = self:GetButton(i)

    if self.noMenu then
        return
    end

    if self:GetOrientation() == 'HORIZONTAL' then
        return button:GetRight() > self:GetRight()
    else
        return button:GetBottom() < self:GetBottom()
    end
end

function TabView:UpdateItemPosition(i)
    local button = self:GetButton(i)
    button:ClearAllPoints()
    button:SetPoint(self:GetItemPoint(i == 0 and self:GetShownCount() + 1 or i))
end

function TabView:UpdateItems()
    if self:GetButton(self:GetSelected() or 1).status == 'DISABLED' then
        for i = 1, self:GetItemCount() do
            local button = self:GetButton(i)
            if button.status ~= 'DISABLED' then
                return self:SetSelected(i)
            end
        end
    end

    for i = 1, self:GetItemCount() do
        local button = self:GetButton(i)
        local status

        if self:IsSelected(i) then
            status = 'SELECTED'
        elseif button.status and button.status ~= 'SELECTED' then
            status = button.status
        else
            status = 'NORMAL'
        end

        button.status = status
        button:SetID(i)
        button:SetChecked(self:IsSelected(i))
        button:Show()
        button:FireFormat()
        button:SetStatus(status)

        self:UpdateItemPosition(i)

        if self:IsButtonOverflow(i) then
            button:Hide()
            break
        end
        self.shownCount = i
    end

    for i = self.shownCount + 1, #self.buttons do
        local button = self.buttons[i]
        button:Hide()
    end

    if self.noMenu then
        return
    end

    if self.shownCount >= self:GetItemCount() then
        return
    end

    local more = self:GetButton(0)
    more:SetStatus('MORE')
    more:Show()

    repeat
        local button = self:GetButton(self.shownCount)
        self:UpdateItemPosition(0)

        if self:IsButtonOverflow(0) then
            button:Hide()
            self.shownCount = self.shownCount - 1
        end
    until button:IsShown()
end

--[[
orientation: HORIZONTAL or VERTICAL
--]]

function TabView:SetOrientation(orientation, align)
    if type(orientation) ~= 'string' then
        error(([[bad argument #1 to 'SetOrientation' (string expected, got %s)]]):format(type(orientation)), 2)
    end
    if type(align) ~= 'string' then
        error(([[bad argument #2 to 'SetOrientation' (string expected, got %s)]]):format(type(align)), 2)
    end

    orientation = orientation:upper()

    if orientation == 'HORIZONTAL' then
        align = (align or 'BOTTOM'):upper()

        if not (align == 'TOP' or align == 'BOTTOM') then
            error(([[Cannot set align to '%s']]):format(align), 2)
        end
    elseif orientation == 'VERTICAL' then
        align = (align or 'LEFT'):upper()
        if not (align == 'LEFT' or align == 'RIGHT') then
            error(([[Cannot set align to '%s']]):format(align), 2)
        end
    else
        error(([[Cannot set orientation to '%s']]):format(orientation), 2)
    end

    self.align = align
    self.orientation = orientation
end

function TabView:GetOrientation()
    return self.orientation or 'HORIZONTAL', self.align or 'BOTTOM'
end

function TabView:EnableMenu(flag)
    self.noMenu = not flag or nil
end

function TabView:GetMenu()
    if not self.menu then
        local menu = GUI:GetClass('GridView'):New(UIParent)
        menu:SetFrameStrata('DIALOG')
        menu:Hide()
        menu:SetSize(1, 1)
        menu:SetBackdrop{
            bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
            edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
            edgeSize = 14, tileSize = 20, tile = true,
            insets = {left = 2, right = 2, top = 2, bottom = 2},
        }
        menu:SetBackdropColor(0, 0, 0, 0.6)
        menu:SetItemList(self:GetItemList())
        menu:SetItemClass(self:GetItemClass())
        menu:SetItemHeight(self:GetItemHeight())
        menu:SetAutoSize(true)
        menu:SetItemSpacing(2)
        menu:SetPadding(5)
        menu:SetRowCount(30)
        menu:SetColumnCount(1)
        menu:SetCallback('OnItemCreated', function(_, button)
            self:Fire('OnItemCreated', button, 'MENU')
            button:SetOwner(self)
            button:SetStatus('MENU')
        end)
        menu:SetOwner(self)
        GUI:GetClass('AutoHideController'):New(menu)

        self.menu = menu
    end
    return self.menu
end

function TabView:ToggleMenu(anchor)
    local menu = self:GetMenu()
    if menu:IsShown() then
        menu:Hide()
    else
        menu:SetExcludeCount(self:GetShownCount())

        menu:ClearAllPoints()
        if anchor:GetBottom() > GetScreenHeight() - anchor:GetTop() then
            menu:SetPoint('TOPLEFT', anchor, 'BOTTOMLEFT')
        else
            menu:SetPoint('BOTTOMLEFT', anchor, 'TOPLEFT')
        end
        menu:Show()
    end
end

function TabView:CloseTab(index)
    self:Fire('OnItemClosed', _, tremove(self:GetItemList(), index))

    if self:IsSelected(index) then
        self:SetSelected(1)
    elseif self:GetSelected() > index then
        self:SetSelected(self:GetSelected() - 1)
    else
        self:Refresh()
    end
end

function TabView:GetShownCount()
    return self.shownCount or 0
end

function TabView:HasMoreButton()
    return self.shownCount < self:GetItemCount()
end

function TabView:GetMoreButton()
    return self:GetButton(0)
end

function TabView:SetSelected(index)
    local itemCount = self:GetItemCount()
    if index > itemCount or index <= 0 or itemCount == 0 then
        return self:Refresh()
    end

    local shownCount = self:GetShownCount()
    if not self.noMenu and shownCount < index then
        tinsert(self.itemList, 1, (tremove(self.itemList, index)))
        index = 1
    end

    self.selected = index
    self:Refresh()
    self:Fire('OnSelectChanged', index, self:GetItem(index))
end

function TabView:GetSelected()
    return self.selected
end

function TabView:IsSelected(index)
    return self.selected == index
end

function TabView:DisableTab(index)
    local button = self:GetButton(index)
    button.status = 'DISABLED'
    button:SetStatus('DISABLED')
    self:Refresh()
end

function TabView:EnableTab(index)
    local button = self:GetButton(index)
    button.status = 'NORMAL'
    button:SetStatus('NORMAL')
    self:Refresh()
end

function TabView:SetTabEnabled(index, flag)
    if flag then
        self:EnableTab(index)
    else
        self:DisableTab(index)
    end
end

function TabView:FlashTab(index, flag)
    local button = self:GetButton(index)
    if flag then
        button:StartFlash()
    else
        button:StopFlash()
    end
end
