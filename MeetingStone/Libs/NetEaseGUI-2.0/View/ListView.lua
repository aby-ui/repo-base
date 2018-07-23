
local WIDGET, VERSION = 'ListView', 3

local GUI = LibStub('NetEaseGUI-2.0')
local ListView = GUI:NewClass(WIDGET, 'ScrollFrame', VERSION, 'Refresh', 'View', 'Scroll', 'Select', 'Filter')
if not ListView then
    return
end

local floor, max, min = math.floor, math.max, math.min

function ListView:Constructor()
    self.buttons = {}
    self:SetScrollChild(CreateFrame('Frame', nil, self))

    self:SetScript('OnSizeChanged', self.OnSizeChanged)
    self:SetScript('OnScrollRangeChanged', self.Refresh)
    self:SetScript('OnShow', self.Refresh)

    self:SetSelectMode('NONE')
end

function ListView:OnSizeChanged()
    self.maxCount = nil
    self:UpdateLayout()
    self:Refresh()
end

function ListView:Update()
    self:UpdateFilter()
    self:UpdateScrollBar()
    self:UpdateItems()
    self:UpdateScrollRange()
end

function ListView:UpdateScrollRange()
    local range = self:GetVerticalScrollRange()
    self:SetVerticalScroll(0)
    if self:GetReverse() then
        self:SetVerticalScroll(self:AtTop() and -range or 0)
    else
        self:SetVerticalScroll(self:AtBottom() and range or 0)
    end
end

function ListView:UpdateLayout()
    local child = self:GetScrollChild()
    local width, height = self:GetSize()

    child:ClearAllPoints()
    child:SetPoint('TOPLEFT')
    child:SetSize(width - self:GetScrollBarFixedWidth(), height)
end

function ListView:UpdateItems()
    local offset = self:GetOffset()
    local itemCount = self:GetItemCount()
    local maxCount = self:GetMaxCount()
    local itemHeight = self:GetItemHeight()
    local realCount

    if itemCount > maxCount then
        if self:GetReverse() then
            if not self:AtTop() then
                offset = offset - 1
            end
        else
            if self:AtBottom() then
                offset = offset - 1
            end
        end
        realCount = maxCount + 1
    else
        realCount = itemCount
    end

    local isSingularAdapter = self:GetSingularAdapter()
    local groupHandle = self:GetGroupHandle()
    local prevItemGroupData, startButton, endButton
    local singularLine = true

    for i = 1, realCount do
        local index = self:GetReverse() and offset + realCount - i or offset + i - 1
        local button = self:GetButton(i)
        button:SetID(index)
        button:SetHeight(itemHeight)
        button:SetChecked(self:IsSelected(index))
        button:Show()

        if groupHandle then
            local item = self:GetItem(index)
            local itemGroupData = groupHandle(item)

            startButton = startButton or button
            endButton = endButton or button
            prevItemGroupData = prevItemGroupData or itemGroupData

            if itemGroupData == prevItemGroupData then
                button:Group(nil, nil, startButton)
                endButton = button
            else
                startButton:Group(singularLine, endButton)
                startButton:FireFormat()

                startButton = button
                endButton = button
                singularLine = not singularLine
            end

            prevItemGroupData = itemGroupData

            if i == realCount then
                startButton:Group(singularLine, endButton)
                startButton:FireFormat()
            end
        elseif isSingularAdapter then
            button:Group(i % 2 == 0)
        end

        button:FireFormat()
    end

    for i = realCount + 1, #self.buttons do
        self:GetButton(i):Hide()
    end
end

function ListView:UpdateItemPosition(i)
    local button = self:GetButton(i)
    button:ClearAllPoints()

    local itemSpacing = self:GetItemSpacing()

    if self:GetReverse() then
        if i == 1 then
            button:SetPoint('BOTTOMLEFT')
            button:SetPoint('BOTTOMRIGHT')
        else
            button:SetPoint('BOTTOMLEFT', self:GetButton(i-1), 'TOPLEFT', 0, itemSpacing)
            button:SetPoint('BOTTOMRIGHT', self:GetButton(i-1), 'TOPRIGHT', 0, itemSpacing)
        end
    else
        if i == 1 then
            button:SetPoint('TOPLEFT')
            button:SetPoint('TOPRIGHT')
        else
            button:SetPoint('TOPLEFT', self:GetButton(i-1), 'BOTTOMLEFT', 0, -itemSpacing)
            button:SetPoint('TOPRIGHT', self:GetButton(i-1), 'BOTTOMRIGHT', 0, -itemSpacing)
        end
    end
end

function ListView:UpdatePosition()
    for i in ipairs(self.buttons) do
        button:UpdateItemPosition(i)
    end
end

function ListView:SetReverse(reverse)
    self.reverse = reverse
    self:UpdatePosition()
end

function ListView:GetReverse()
    return self.reverse
end

function ListView:GetMaxCount()
    if not self.maxCount then
        local itemHeight = self:GetItemHeight()
        local itemSpacing = self:GetItemSpacing()
        local height = self:GetScrollChild():GetHeight()

        self.maxCount = floor((height + itemSpacing) / (itemHeight + itemSpacing))
    end
    return self.maxCount
end

function ListView:Clear()
    local list = self:GetItemList()
    if not list then
        return
    end
    wipe(list)

    self:Refresh()
end