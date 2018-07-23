
local GUI = tdCore('GUI')

local ListWidgetItem = GUI('ListWidgetItem')
local ListWidgetFontItem = GUI:NewModule('ListWidgetFontItem', ListWidgetItem:New())

local FontMenu = GUI:NewMenu('FontMenu', GUI('ListWidget'):New(UIParent))

function ListWidgetFontItem:New(parent)
    local obj = self:Bind(ListWidgetItem:New(parent))
    
    obj:GetLabelFontString():SetText('abcdef 123456 字体预览')
    
    return obj
end

function ListWidgetFontItem:SetText(font)
    self:GetLabelFontString():SetFont(font, 12, 'OUTLINE')
end

do
    FontMenu:SetMaxCount(20)
    FontMenu:SetAutoSize(true)
    FontMenu:SetItemHeight(20)
    FontMenu:SetAllowOrder(true)
    FontMenu:SetItemObject(ListWidgetFontItem)
    FontMenu:SetItemList(GUI('Media'):GetFonts())
    FontMenu:SetHandle('OnItemClick', function(self, index)
        self:GetCaller():SetValue(self:GetItemValue(index))
        self:Hide()
    end)
end
