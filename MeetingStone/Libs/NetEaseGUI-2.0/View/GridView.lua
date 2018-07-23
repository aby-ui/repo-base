
local WIDGET, VERSION = 'GridView', 4

local GUI = LibStub('NetEaseGUI-2.0')
local GridView = GUI:NewClass(WIDGET, 'Frame', VERSION, 'Refresh', 'View', 'Scroll', 'Select', 'Owner')
if not GridView then
    return
end

function GridView:Constructor()
    self.buttons = {}
    self:SetSelectMode('NONE')
    self:SetScript('OnShow', self.Refresh)
    self:SetScript('OnSizeChanged', self.OnSizeChanged)
end

function GridView:OnSizeChanged()
    if self.rowCountLocked then
        return
    end
    self.rowCount = nil
    self:Refresh()
    self:UpdateLayout()
end

function GridView:Update()
    self:UpdateScrollBar()
    self:UpdateItems()
end

function GridView:GetMaxCount()
    return self:GetRowCount() * self:GetColumnCount()
end

function GridView:UpdateLayout()
    for i in ipairs(self.buttons) do
        self:UpdateItemPosition(i)
    end
end

function GridView:UpdateItemPosition(i)
    local button = self:GetButton(i)
    local itemSpacing1, itemSpacing2 = self:GetItemSpacing()
    local itemHeight = self:GetItemHeight()
    local itemWidth = self:GetItemWidth()
    local lineCount = self:GetColumnCount()
    local left, right, top, bot = self:GetPadding()

    right = right + self:GetScrollBarFixedWidth()

    button:ClearAllPoints()

    if lineCount == 1 and self:GetRowCount() ~= 1 then
        button:SetHeight(itemHeight)
        button:SetPoint('TOPLEFT', left, -top-(i-1)*(itemHeight+itemSpacing1))
        button:SetPoint('TOPRIGHT', -right, -top-(i-1)*(itemHeight+itemSpacing1))
    else
        local row = floor((i-1)/lineCount)
        local col = (i-1)%lineCount

        button:SetSize(itemWidth, itemHeight)
        button:SetPoint('TOPLEFT', left+col*(itemWidth+itemSpacing2), -top-row*(itemHeight+itemSpacing1))
    end
end

function GridView:UpdateItems()
    local offset = self:GetOffset()
    local maxCount = min(self:GetColumnCount() * self:GetRowCount(), self:GetItemCount())
    local autoWidth = self:GetItemWidth() or 1
    local maxRight = 0
    
    local column = self:GetColumnCount()
    offset = ceil((offset - 1) / column) * column + 1

    for i = 1, maxCount do
        local button = self:GetButton(i)
        local index = offset + i - 1 + self:GetExcludeCount()
        
        if self:GetItem(index) then
            button:SetEnabled(self:IsEnabled())
            button:SetID(index)
            button:SetChecked(self:IsSelected(index))
            button:Show()
            button:FireFormat()
            
            autoWidth = max(autoWidth, button:GetAutoWidth() or 0)
            maxRight = max(maxRight, button:GetRight())
        else
            button:Hide()
        end
    end

    for i = maxCount + 1, #self.buttons do
        self:GetButton(i):Hide()
    end

    if maxCount > 0 and self:GetAutoSize() then
        local left, right, top, bot = self:GetPadding()
        local height = self:GetTop() - self:GetButton(maxCount):GetBottom() + bot
        local width = self:GetScrollBarFixedWidth()

        if self:GetColumnCount() == 1 then
            width = width + autoWidth + left + right
        else
            width = width + maxRight - self:GetLeft() + right
        end
        self:SetSize(width, height)
    end

    local desc = self:GetDescription()
    if not desc then
        return
    end

    if maxCount == 0 then
        desc:Hide()
    else
        desc:ClearAllPoints()
        desc:SetPoint(desc.anchor, self:GetButton(maxCount), desc.relativePoint, desc.x, desc.y)
        desc:Show()
    end
end

function GridView:SetColumnCount(columnCount)
    if not self.autoSize then
        -- error([[Must set autosize do it.]], 2)
    end
    self.columnCount = columnCount
    self:SetScrollStep(columnCount)
end

function GridView:GetColumnCount()
    return self.columnCount or 1
end

function GridView:SetRowCount(rowCount)
    self.rowCount = rowCount
    self:SetScript('OnSizeChanged', nil)
end

function GridView:GetRowCount()
    if not self.rowCount then
        if self.autoSize then
            return self:GetItemCount()
        else
            local itemHeight = self:GetItemHeight()
            local itemSpacing = self:GetItemSpacing()
            local top, bot = select(2, self:GetPadding())
            local height = self:GetHeight() - top - bot + itemSpacing

            self.rowCount = floor(height / (itemHeight + itemSpacing))
        end
    end
    return self.rowCount
end

function GridView:SetAutoSize(autoSize)
    self.autoSize = autoSize
    self:SetScript('OnSizeChanged', not autosize and self.OnSizeChanged or nil)
end

function GridView:GetAutoSize()
    return self.autoSize
end

function GridView:SetItemWidth(itemWidth)
    self.itemWidth = itemWidth
end

function GridView:GetItemWidth()
    if not self:GetAutoSize() then
        local left, right = self:GetPadding()
        local _, itemSpacing2 = self:GetItemSpacing()
        local columnCount = self:GetColumnCount()
        local width = self:GetWidth() - left - right - (columnCount-1) * itemSpacing2 - self:GetScrollBarFixedWidth()
        self.itemWidth = width / columnCount

        return self.itemWidth
    end
    return self.itemWidth or 20
end

function GridView:SetDescription(text, anchor, relativePoint, x, y)
    self.Description = self.Description or self:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall2')
    self.Description:Hide()
    self.Description:SetText(text)
    self.Description.anchor = anchor or 'TOP'
    self.Description.relativePoint = relativePoint or 'BOTTOM'
    self.Description.x = x or 0
    self.Description.y = y or -5
end

function GridView:GetDescription()
    return self.Description
end

function GridView:SetItemSpacing(spacing1, spacing2)
    self.itemSpacing = spacing1
    self.itemSpacing2 = spacing2 or spacing1
end

function GridView:GetItemSpacing()
    return self.itemSpacing or 0, self.itemSpacing2 or 0
end
