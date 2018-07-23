
local GUI = tdCore('GUI')
local L = GUI:GetLocale()

local ListWidgetItem = GUI:NewModule('ListWidgetItem', CreateFrame('CheckButton'), 'UIObject')
ListWidgetItem:RegisterHandle('OnSetValue')

local function OnClick(self, button)
    PlaySound163('igMainMenuOptionCheckBoxOn')
    if type(self.__onClick) == 'function' then
        self:__onClick()
    end
    
    self:SetChecked(false)
    
    local parent = self:GetParent()
    parent:RunHandle('OnItemClick', self:GetIndex())
    parent:SetSelected(self:GetIndex(), not parent:GetSelected(self:GetIndex()))
end

local function OnDragStart(self)
    self:GetParent():ButtonStartMoving(self)
end

local function OnDragStop(self)
    self:GetParent():ButtonStopMoving(self)
end

function ListWidgetItem:New(parent)
    local obj = self:Bind(CreateFrame('CheckButton', nil, parent))
    obj:Hide()
    
    if GUI:IsWidgetType(parent, 'ListWidget') then
        obj:GetLabelFontString():SetPoint('LEFT', 5, 0)
        obj:SetFontString(obj:GetLabelFontString())
        obj:SetNormalFontObject('GameFontNormalSmall')
        obj:SetHighlightFontObject('GameFontHighlightSmall')
        
        obj:SetHighlightTexture([[Interface\QuestFrame\UI-QuestLogTitleHighlight]])
        obj:SetCheckedTexture([[Interface\QuestFrame\UI-QuestLogTitleHighlight]])
        
        obj:GetHighlightTexture():SetVertexColor(0.196, 0.388, 0.8)
        obj:GetCheckedTexture():SetVertexColor(0.82, 0.5, 0)
        
        obj:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
        obj:SetScript('OnClick', OnClick)
        
        if parent:GetAllowOrder() then
            obj:RegisterForDrag('LeftButton')
            
            obj:SetScript('OnDragStart', OnDragStart)
            obj:SetScript('OnDragStop', OnDragStop)
        end
    end
    return obj
end

function ListWidgetItem:SetIndex(index)
    self.__idx = index
end

function ListWidgetItem:GetIndex()
    return self.__idx
end

function ListWidgetItem:GetValue()
    return self.__value or self:GetText()
end

function ListWidgetItem:SetValue(value)
    self.__value = value
end

function ListWidgetItem:SetClick(onClick)
    self.__onClick = onClick
end

---- ListWidgetLinkItem

local ListWidgetLinkItem = GUI:NewModule('ListWidgetLinkItem', ListWidgetItem:New(), 'Update')
ListWidgetLinkItem:RegisterHandle('OnNote')

function ListWidgetLinkItem:New(parent)
    local obj = self:Bind(ListWidgetItem:New(parent))
    if parent then
        obj:SetAllowEnter(true)
        obj:SetHandle('OnNote', self.OnNote)
    end
    return obj
end

--[[
local linktypes = {
    item = true,
    enchant = true,
    spell = true,
    quest = true,
    unit = true,
    talent = true,
    achievement = true,
    glyph = true,
    instancelock = true
}
--]]

function ListWidgetLinkItem:OnUpdate()
    self:SetText(self.__text)
end

function ListWidgetLinkItem:GetInfo(text)
    local linkType, id
    if type(text) == 'number' then
        linkType, id = 'item', text
    elseif type(text) == 'string' then
        linkType, id = text:match('^(.+):(%d+)$')
    end
    
    if linkType == 'item' then
        local name, link, quality, _, _, _, _, _, _, icon = GetItemInfo(id)
        if not name or not icon or not quality then
            self:StartUpdate(0.2)
            return
        end
        
        local r, g, b = GetItemQualityColor(quality)
        return ('|T%s:16|t |cff%02x%02x%02x%s|r'):format(icon, (r or 1) * 0xff, (g or 1) * 0xff, (b or 1) * 0xff, name), link
    elseif linkType == 'spell' then
        local name, _, icon = GetSpellInfo(id)
        if not name or not icon then
            self:StartUpdate(0.2)
            return
        end
        return ('|T%s:16|t |cff71d5ff%s|r'):format(icon, name), (GetSpellLink(id))
    elseif linkType == 'currency' then
        local name, _, icon = GetCurrencyInfo(id)
        return ('|TInterface\\Icons\\%s:16|t |cff00aa00%s|r'):format(icon, name), (GetCurrencyLink(id))
    end
    return text
end

function ListWidgetLinkItem:SetText(text)
    self.__text = text
    
    local text, link = self:GetInfo(text)
    if text then
        self.__link = link
        self:GetLabelFontString():SetText(text)
        self:StopUpdate()
    else
        self:GetLabelFontString():SetText('Loading ...')
    end
end

function ListWidgetLinkItem:OnNote()
    if self.__link then
        GameTooltip:SetHyperlink(self.__link)
    end
end
