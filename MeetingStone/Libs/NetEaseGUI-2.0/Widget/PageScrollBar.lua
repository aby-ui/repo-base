--[[
@Date    : 2016-06-16 17:27:38
@Author  : DengSir (ldz5@qq.com)
@Link    : https://dengsir.github.io
@Version : $Id$
]]


local WIDGET, VERSION = 'PageScrollBar', 2

local GUI = LibStub('NetEaseGUI-2.0')
local PageScrollBar = GUI:NewClass(WIDGET, 'Slider', VERSION)
if not PageScrollBar then
    return
end

local ScrollBar = GUI:GetClass('ScrollBar')

local function ScrollUpButtonOnClick(self)
    local parent = self:GetParent()
    local scrollStep = self:GetParent().scrollStep or (parent:GetHeight() / 2)
    parent:SetValue(parent:GetValue() - scrollStep)
    PlaySound(SOUNDKIT and SOUNDKIT.U_CHAT_SCROLL_BUTTON or 'UChatScrollButton')
end

local function ScrollDownButtonOnClick(self)
    local parent = self:GetParent()
    local scrollStep = self:GetParent().scrollStep or (parent:GetHeight() / 2)
    parent:SetValue(parent:GetValue() + scrollStep)
    PlaySound(SOUNDKIT and SOUNDKIT.U_CHAT_SCROLL_BUTTON or 'UChatScrollButton')
end

function PageScrollBar:Constructor(parent)
    local ScrollUpButton = CreateFrame('Button', nil, self) do
        ScrollUpButton:SetSize(32, 32)
        ScrollUpButton:SetPoint('TOPLEFT')
        ScrollUpButton:SetNormalTexture([[Interface\Buttons\UI-SpellbookIcon-PrevPage-Up]])
        ScrollUpButton:SetPushedTexture([[Interface\Buttons\UI-SpellbookIcon-PrevPage-Down]])
        ScrollUpButton:SetDisabledTexture([[Interface\Buttons\UI-SpellbookIcon-PrevPage-Disabled]])
        ScrollUpButton:SetHighlightTexture([[Interface\Buttons\UI-Common-MouseHilight]], 'ADD')
        ScrollUpButton:SetScript('OnClick', ScrollUpButtonOnClick)
    end

    local ScrollDownButton = CreateFrame('Button', nil, self) do
        ScrollDownButton:SetSize(32, 32)
        ScrollDownButton:SetPoint('LEFT', ScrollUpButton, 'RIGHT')
        ScrollDownButton:SetNormalTexture([[Interface\Buttons\UI-SpellbookIcon-NextPage-Up]])
        ScrollDownButton:SetPushedTexture([[Interface\Buttons\UI-SpellbookIcon-NextPage-Down]])
        ScrollDownButton:SetDisabledTexture([[Interface\Buttons\UI-SpellbookIcon-NextPage-Disabled]])
        ScrollDownButton:SetHighlightTexture([[Interface\Buttons\UI-Common-MouseHilight]], 'ADD')
        ScrollDownButton:SetScript('OnClick', ScrollDownButtonOnClick)
    end

    self.ScrollUpButton = ScrollUpButton
    self.ScrollDownButton = ScrollDownButton

    self:SetSize(64, 32)
    self:Disable()
    self:SetScript('OnValueChanged', ScrollBar.OnValueChanged)
    self:SetScript('OnMinMaxChanged', ScrollBar.OnMinMaxChanged)
    self:SetValueStep(1)
    self:SetMinMaxValues(0, 1)
    self:SetValue(0)
    self:SetStepsPerPage(1)
    self.scrollStep = 1
end

local apis = {
    'OnValueChanged',
    'OnMinMaxChanged',
    'UpdateButton',
    'SetScrollStep',
    'GetScrollStep',
    'AtTop',
    'AtBottom',
    'ScrollToTop',
    'ScrollToBottom',
    'GetValue',
}

for _, v in pairs(apis) do
    PageScrollBar[v] = ScrollBar[v]
end

PageScrollBar.UpdateShown = nop

function PageScrollBar:GetFixedWidth()
    return 0
end