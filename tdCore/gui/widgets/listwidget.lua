
local GUI = tdCore('GUI')
local L = tdCore:GetLocale('tdCore')

local LIST_SPACING = 5
local EXTRA_BUTTON_SIZE = 24

local ListWidget = GUI:NewModule('ListWidget', CreateFrame('Frame'), 'UIObject', 'View', 'Control', 'Update')
ListWidget:RegisterHandle('OnItemClick', 'OnAdd', 'OnDelete', 'OnSelectAll', 'OnSelectNone', 'OnCustom1', 'OnCustom2', 'OnCustom3')

function ListWidget:GetWheelStep()
    return self:GetMaxCount() - 1
end

function ListWidget:New(parent)
    local obj = self:Bind(CreateFrame('Frame', nil, parent))
    
    obj:SetBackdrop{
        bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
        edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
        edgeSize = 14, tileSize = 20, tile = true,
        insets = {left = 2, right = 2, top = 2, bottom = 2},
    }
    obj:SetBackdropColor(0, 0, 0, 0.4)
    obj:SetBackdropBorderColor(1, 1, 1, 1)
    obj:GetLabelFontString():SetPoint('BOTTOMLEFT', obj, 'TOPLEFT')
    
    obj.__children = {}
    obj.__startIndex = 1
    
    obj.__scrollBar = GUI('ScrollBar'):New(obj)
    
    obj:SetSelectMode('NONE')
    obj:EnableMouseWheel(true)
    obj:SetScript('OnMouseWheel', GUI('Widget').OnMouseWheel)
    obj:SetScript('OnSizeChanged', self.OnSizeChanged)
    obj:SetScript('OnShow', self.Refresh)
    obj:SetScript('OnHide', self.OnHide)
    
    obj:SetHandle('OnDelete', self.OnDelete)
    obj:SetHandle('OnSelectAll', self.OnSelectAll)
    obj:SetHandle('OnSelectNone', self.OnSelectNone)
    
    return obj
end

---- scripts

function ListWidget:OnDelete()
    self:ShowDialog(
        'Dialog',
        L['Are you sure to delete the selected item?'],
        GUI.DialogIcon.Warning,
        function()
            for i = self:GetItemCount(), 1, -1 do
                if self:GetSelected(i) then
                    self:GetItemList():RemoveItem(i)
                end
            end
            self:SetProfileValue(self:GetItemList(), true)
            self:Refresh()
            self:SelectAll(false)
        end
    )
end

function ListWidget:OnSelectAll()
    self:SelectAll(true)
end

function ListWidget:OnSelectNone()
    self:SelectAll(false)
end

function ListWidget:OnScrollValueChanged(value)
    self:SetStartIndex(value)
    self:Refresh()
end

function ListWidget:OnSizeChanged(width, height)
    self.__maxCount = floor((height - LIST_SPACING * 2 - (self:GetExtraButtonCount() > 0 and EXTRA_BUTTON_SIZE + 10 or 0))
        / (self:GetItemHeight() + self:GetItemSpacing()))
    self:Refresh()
end

function ListWidget:OnHide()
    self:SelectAll(false)
end

local function DoNothing() return end
local SELECTMODES = setmetatable({
    NONE = {
        GetSelected = DoNothing,
        SetSelected = DoNothing,
        SelectAll = DoNothing,
        
        __selected = nil,
    },
    RADIO = {
        GetSelected = function(self, index)
            return self.__selected == index
        end,
        SetSelected = function(self, index)
            index = self:FindIndex(index)
            if not index then return end
            
            self.__selected = index
            self:Refresh()
        end,
        SelectAll = DoNothing,
        
        __selected = nil,
    },
    MULTI = {
        GetSelected = function(self, index)
            return self.__selected[index]
        end,
        SetSelected = function(self, index, checked)
            index = self:FindIndex(index)
            if not index then return end
            
            self.__selected[index] = checked or nil
            self:Refresh()
        end,
        SelectAll = function(self, enable)
            if enable then
                for i = 1, self:GetItemCount() do
                    self.__selected[i] = true
                end
            else
                wipe(self.__selected)
            end
            self:Refresh()
        end,
        
        __selected = {},
    },
}, {__index = function(o, k)
    return o.NONE
end})

function ListWidget:SetSelectMode(mode)
    self.__selectMode = mode
    
    for k, v in pairs(SELECTMODES[mode]) do
        self[k] = v
    end
end

function ListWidget:GetSelectMode()
    return self.__selectMode or 'NONE'
end

function ListWidget:CreateExtraButton(index, args)
    if not self.__extraButtons[index] then
        self.__extraButtons[index] = GUI('ListWidgetButton'):New(self, args)
        self.__extraButtons[index]:SetSize(EXTRA_BUTTON_SIZE, EXTRA_BUTTON_SIZE)
    end
    return self.__extraButtons[index]
end

function ListWidget:GetExtraButtonCount()
    return self.__extraButtons and #self.__extraButtons or 0
end

function ListWidget:SetExtraButton(list)
    self.__extraButtons = self.__extraButtons or {}
    for i, v in ipairs(list) do
        local button = self:CreateExtraButton(i, v)
        
        button:ClearAllPoints()
        if i == 1 then
            button:SetPoint('BOTTOMLEFT', 10, 10)
        else
            button:SetPoint('LEFT', self.__extraButtons[i-1], 'RIGHT', 8, 0)
        end
    end
end

function ListWidget:SetAllowOrder(allowOrder)
    self.__allowOrder = allowOrder
end

function ListWidget:GetAllowOrder()
    return self.__allowOrder
end

function ListWidget:SetAutoSize(autoSize)
    self.__autoSize = autoSize
    self:SetScript('OnSizeChanged', not autoSize and self.OnSizeChanged or nil)
end

function ListWidget:SetItemHeight(height)
    self.__itemHeight = height
end

function ListWidget:GetItemHeight()
    return self.__itemHeight or 20
end

function ListWidget:SetItemSpacing(spacing)
    self.__itemSpacing = spacing
end

function ListWidget:GetItemSpacing()
    return self.__itemSpacing or 0
end

function ListWidget:SetItemObject(obj)
    self.__itemObject = obj
end

function ListWidget:GetItemObject()
    return self.__itemObject or GUI('ListWidgetItem')
end

function ListWidget:SetListObject(obj)
    self.__listObject = obj
end

function ListWidget:GetListObject()
    return self.__listObject or GUI('List')
end

function ListWidget:SetItemList(list)
    self.__itemList = self:GetListObject():New(list)
end

function ListWidget:GetItemList()
    if not self.__itemList then
        local value = self:GetProfileValue()
        if value and type(value) == 'table' then
            self.__itemList = self:GetListObject():New(value)
        end
    end
    return self.__itemList
end

function ListWidget:SetMaxCount(count)
    self.__maxCount = count
end

function ListWidget:GetMaxCount()
    if not self.__maxCount and not self.__autoSize then
        self:OnSizeChanged(self:GetSize())
    end
    return self.__maxCount or 20
end

function ListWidget:GetItemCount()
    local list = self:GetItemList()
    
    return list and list:GetItemCount()
end

function ListWidget:GetItemText(i)
    local list = self:GetItemList()
    
    return list and list:GetText(i)
end

function ListWidget:GetItemValue(i)
    local list = self:GetItemList()
    
    return list and list:GetValue(i)
end

function ListWidget:GetItemClick(i)
    local list = self:GetItemList()
    
    return list and list:GetClick(i)
end

function ListWidget:SetStartIndex(index)
    if index < 1 or index > self:GetItemCount() - self:GetMaxCount() + 1 then
        return
    end
    self.__startIndex = index
end

function ListWidget:GetStartIndex()
    local itemCount = self:GetItemCount()
    local maxCount = self:GetMaxCount()
    
    if itemCount > maxCount and self.__startIndex + maxCount > itemCount then
        self.__startIndex = itemCount - maxCount + 1
    end
    return self.__startIndex
end

function ListWidget:GetEndIndex()
    return min(self:GetStartIndex() + self:GetMaxCount() - 1, self:GetItemCount())
end

---- update

function ListWidget:Update()
    local value = self:GetProfileValue()
    if value and value ~= self:GetItemList() then
        self:SetItemList(self:GetListObject():New(value))
    end
    self:Refresh()
end

function ListWidget:CreateButton(i)
    if not self:GetChild(i) then
        self.__children[i] = self:GetItemObject():New(self)
    end
    return self:GetChild(i)
end

function ListWidget:Refresh()
    if not self:IsVisible() then return end
    
    local bIndex = 1
    local maxWidth = 0
    local itemHeight = self:GetItemHeight()
    local itemSpacing = self:GetItemSpacing()
    local start = self:GetStartIndex()
    
    self:UpdateScrollBar(start)
        
    local scrollShown = self.__scrollBar:IsShown()
    
    for i = start, self:GetEndIndex() do
        local button = self:CreateButton(bIndex)
        button:SetHeight(itemHeight)
        button:SetChecked(self:GetSelected(i) or nil)
        button:SetIndex(i)
        button:SetText(self:GetItemText(i))
        button:SetValue(self:GetItemValue(i))
        button:SetClick(self:GetItemClick(i))
        button:Show()
        
        if self.__movingIndex == i or not self:GetItemValue(i) then
            button:Hide()
        end
        
        local y = -LIST_SPACING * 2 - (itemHeight + itemSpacing) * (bIndex - 1 + (movingIndex and movingIndex <= i and 1 or 0))
        button:ClearAllPoints()
        button:SetPoint('TOPLEFT', self, 'TOPLEFT', LIST_SPACING, y)
        button:SetPoint('TOPRIGHT', self, 'TOPRIGHT', - LIST_SPACING - (scrollShown and 20 or 0), y)

        maxWidth = max(maxWidth, button:GetLabelFontString():GetStringWidth())
        
        bIndex = bIndex + 1
    end
    
    for i = self:GetEndIndex() + 1, self:GetChildrenCount() do
        local button = self:GetChild(i)
        if button then
            button:Hide()
        end
    end
    
    if self.__autoSize then
        self:SetSize(max(maxWidth + 20 + (scrollShown and 20 or 0), 100),
            min(self:GetMaxCount(), self:GetItemCount()) * (itemHeight + itemSpacing) - itemSpacing + 4 * LIST_SPACING +
            (self:GetExtraButtonCount() > 0 and EXTRA_BUTTON_SIZE or 0))
    end
end

function ListWidget:UpdateScrollBar(value)
    local scrollbar = self.__scrollBar
    if not scrollbar then
        return
    end
    
    local maxValue = self:GetItemCount() - self:GetMaxCount() + 1
    if maxValue < 1 then
        maxValue = 1
    end
    
    local _, max = scrollbar:GetMinMaxValues()
    if max ~= maxValue then
        scrollbar:SetMinMaxValues(1, maxValue)
    end
    
    if value ~= scrollbar:GetValue() then
        scrollbar:SetValue(value)
    end
end

---- interface

local FINDINDEXS = setmetatable({
    table = function(self, obj)
        for i = 1, self:GetItemCount() do
            if obj == self:GetItemValue(i) then
                return i
            end
        end
    end,
    number = function(self, index)
        if index < 1 or index > self:GetItemCount() then
            return
        end
        return index
    end,
    string = function(self, text)
        for i = 1, self:GetItemCount() do
            if self:GetItemText(i) == text or self:GetItemValue(i) == text then
                return i
            end
        end
    end,
}, {__index = function(o, k)
    return DoNothing
end})

function ListWidget:FindIndex(arg1)
    return FINDINDEXS[type(arg1)](self, arg1)
end

---- order button

function ListWidget:GetScreenClamped()
    local screenWidth, screenHeight = GetScreenWidth(), GetScreenHeight()
    local left, bottom, width, height = self:GetRect()
    
    return  - (left + LIST_SPACING),
            screenWidth - left - width + LIST_SPACING + (self.__scrollBar:IsShown() and 20 or 0),
            screenHeight - bottom - height + LIST_SPACING,
            - bottom - LIST_SPACING - (self:GetExtraButtonCount() > 0 and (EXTRA_BUTTON_SIZE + 10) or 0)
end

function ListWidget:GetMoveToIndex()
    if not self.__movingButton then
        return
    end
    
    local startIndex, endIndex = self:GetStartIndex(), self:GetEndIndex()
    local index = floor((self:GetTop() - self.__movingButton:GetTop()) / self:GetItemHeight() + 0.5) + startIndex - 1
    if index < startIndex then
        index = startIndex
    end
    if index > endIndex then
        index = endIndex
    end
    return index
end

function ListWidget:ChangeStartIndex()
    if abs(self:GetTop() - self.__movingButton:GetTop()) < LIST_SPACING * 2 then
        self:SetStartIndex(self:GetStartIndex() - 1)
    elseif abs(self:GetBottom() - self.__movingButton:GetBottom()) < LIST_SPACING * 2 then
        self:SetStartIndex(self:GetStartIndex() + 1)
    end
end

function ListWidget:OnUpdate(elapsed)
    self:ChangeStartIndex()
    
    local index = self:GetMoveToIndex()
    if self.__movingIndex ~= index then
        self:GetItemList():ItemMoveTo(self.__movingIndex, index)
        self.__movingIndex = index
        self:Refresh()
    end
end

function ListWidget:ButtonStartMoving(button)
    local index = button:GetIndex()
    
    self:SelectAll(false)
    
    self.__movingIndex = index
    
    self.__movingButton = self.__movingButton or self:GetItemObject():New(self)
    self.__movingButton:UnlockHighlight()
    
    self.__children[index - self:GetStartIndex() + 1], self.__movingButton = self.__movingButton, button
    
    button:SetMovable(true)
    button:SetToplevel(true)
    button:SetClampedToScreen(true)
    button:SetClampRectInsets(self:GetScreenClamped())
    button:StartMoving()
    button:LockHighlight()
    button:Show()
    
    self:StartUpdate(0.3)
end

function ListWidget:ButtonStopMoving(button)
    self:StopUpdate()
    self.__movingIndex = nil
    
    button:SetMovable(false)
    button:SetToplevel(false)
    button:SetClampedToScreen(false)
    button:StopMovingOrSizing()
    button:UnlockHighlight()
    button:Hide()
    
    self:SetProfileValue(self:GetItemList())
    self:Refresh()
end
