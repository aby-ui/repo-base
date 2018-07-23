
local GUI = LibStub('NetEaseGUI-2.0')
local View = GUI:NewEmbed('View', 1)
if not View then
    return
end

function View:SetItemList(itemList)
    self.itemList = itemList
end

function View:GetItemList()
    return self.itemList
end

function View:SetItemHeight(itemHeight)
    self.itemHeight = itemHeight
end

function View:GetItemHeight()
    return self.itemHeight or 20
end

function View:SetItemSpacing(itemSpacing)
    self.itemSpacing = itemSpacing
end

function View:GetItemSpacing()
    return self.itemSpacing or 0
end

function View:SetExcludeCount(excludeCount)
    self.excludeCount = excludeCount
end

function View:GetExcludeCount()
    return self.excludeCount or 0
end

function View:SetItemClass(itemClass)
    self.itemClass = itemClass
end

function View:GetItemClass()
    return self.itemClass or GUI:GetClass('ItemButton')
end

function View:GetItem(index)
    return self.filterList and self.filterList[index] or self.itemList and self.itemList[index]
end

function View:GetItemCount()
    return self.filterList and #self.filterList or self.itemList and #self.itemList - self:GetExcludeCount() or 0
end

function View:GetShownCount()
    for i = #self.buttons, 1, -1 do
        if self.buttons[i]:IsShown() then
            return i
        end
    end
    return 0
end

function View:SetPadding(...)
    self.leftPadding,
    self.rightPadding,
    self.topPadding,
    self.botPadding = ...
end

function View:GetPadding()
    return  self.leftPadding or 0,
            self.rightPadding or self.leftPadding or 0,
            self.topPadding or self.leftPadding or 0,
            self.botPadding or self.leftPadding or 0
end

function View:GetButton(i)
    if not self.buttons[i] then
        local parent = self.GetScrollChild and self:GetScrollChild() or self
        local button = self:GetItemClass():New(parent, self.highlightWithoutChecked)

        button:Hide()
        button:SetOwner(self)
        button:SetFrameLevel(parent:GetFrameLevel()+1)

        self.buttons[i] = button
        self:UpdateItemPosition(i)
        self:Fire('OnItemCreated', button, i)
    end
    return self.buttons[i]
end

function View:Enable()
    self.disabled = nil
    self:Refresh()
end

function View:Disable()
    self.disabled = true
    self:Refresh()
end

function View:SetEnabled(flag)
    if flag then
        self:Enable()
    else
        self:Disable()
    end
end

function View:IsEnabled()
    return not self.disabled
end

function View:SetItemHighlightWithoutChecked(flag)
    self.highlightWithoutChecked = flag or nil
end

function View:SetGroupHandle(handle)
    if type(handle) == 'function' then
        self.groupHandle = handle
    end
end

function View:GetGroupHandle()
    return self.groupHandle
end

function View:SetSingularAdapter(enable)
    self.singularAdapter = enable
end

function View:GetSingularAdapter()
    return self.singularAdapter
end
