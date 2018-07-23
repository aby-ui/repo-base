
local WIDGET, VERSION = 'EditBox', 2

local GUI = LibStub('NetEaseGUI-2.0')
local EditBox = GUI:NewClass(WIDGET, 'Frame', VERSION)
if not EditBox then
    return
end

function EditBox:Constructor(parent)
    local TL = self:CreateTexture(nil, 'BACKGROUND') do
        TL:SetPoint('TOPLEFT')
        TL:SetSize(8, 8)
        TL:SetTexture([[Interface\COMMON\Common-Input-Border-TL]])
    end

    local TR = self:CreateTexture(nil, 'BACKGROUND') do
        TR:SetPoint('TOPRIGHT')
        TR:SetSize(8, 8)
        TR:SetTexture([[Interface\COMMON\Common-Input-Border-TR]])
    end

    local BL = self:CreateTexture(nil, 'BACKGROUND') do
        BL:SetPoint('BOTTOMLEFT')
        BL:SetSize(8, 8)
        BL:SetTexture([[Interface\COMMON\Common-Input-Border-BL]])
    end

    local BR = self:CreateTexture(nil, 'BACKGROUND') do
        BR:SetPoint('BOTTOMRIGHT')
        BR:SetSize(8, 8)
        BR:SetTexture([[Interface\COMMON\Common-Input-Border-BR]])
    end

    local T = self:CreateTexture(nil, 'BACKGROUND') do
        T:SetPoint('TOPLEFT', TL, 'TOPRIGHT')
        T:SetPoint('BOTTOMRIGHT', TR, 'BOTTOMLEFT')
        T:SetTexture([[Interface\COMMON\Common-Input-Border-T]])
    end

    local B = self:CreateTexture(nil, 'BACKGROUND') do
        B:SetPoint('TOPLEFT', BL, 'TOPRIGHT')
        B:SetPoint('BOTTOMRIGHT', BR, 'BOTTOMLEFT')
        B:SetTexture([[Interface\COMMON\Common-Input-Border-B]])
    end

    local L = self:CreateTexture(nil, 'BACKGROUND') do
        L:SetPoint('TOPLEFT', TL, 'BOTTOMLEFT')
        L:SetPoint('BOTTOMRIGHT', BL, 'TOPRIGHT')
        L:SetTexture([[Interface\COMMON\Common-Input-Border-L]])
    end

    local R = self:CreateTexture(nil, 'BACKGROUND') do
        R:SetPoint('TOPLEFT', TR, 'BOTTOMLEFT')
        R:SetPoint('BOTTOMRIGHT', BR, 'TOPRIGHT')
        R:SetTexture([[Interface\COMMON\Common-Input-Border-R]])
    end

    local M = self:CreateTexture(nil, 'BACKGROUND') do
        M:SetPoint('TOPLEFT', TL, 'BOTTOMRIGHT')
        M:SetPoint('BOTTOMRIGHT', BR, 'TOPLEFT')
        M:SetTexture([[Interface\COMMON\Common-Input-Border-M]])
    end

    local ScrollFrame = CreateFrame('ScrollFrame', nil, self, 'UIPanelScrollFrameTemplate') do
        ScrollFrame:SetPoint('TOPLEFT', 5, -5)
        ScrollFrame:SetPoint('BOTTOMRIGHT', -26, 5)
    end

    local EditBox = CreateFrame('EditBox', nil, ScrollFrame) do
        EditBox:SetFontObject('GameFontHighlightSmall')
        EditBox:SetPoint('TOPLEFT')
        EditBox:SetSize(64, 64)
        EditBox:SetAutoFocus(false)
        EditBox:SetMultiLine(true)
        EditBox:SetFontObject('ChatFontNormal')
        EditBox:SetScript('OnCursorChanged', ScrollingEdit_OnCursorChanged)
        EditBox:SetScript('OnTextChanged', function(EditBox, ...)
            ScrollingEdit_OnTextChanged(EditBox, EditBox:GetParent())
            self.Prompt:SetShown(EditBox:GetText() == '')
            self:Fire('OnTextChanged', ...)
        end)
        EditBox:SetScript('OnUpdate', ScrollingEdit_OnUpdate)
        EditBox:SetScript('OnEscapePressed', EditBox.ClearFocus)
        EditBox:SetScript('OnEditFocusGained', function()
            self.FocusGrabber:Hide()
            self:Fire('OnEditFocusGained')
        end)
        EditBox:SetScript('OnEditFocusLost', function()
            self.FocusGrabber:Show()
            self:Fire('OnEditFocusLost')
        end)
    end

    local Prompt = EditBox:CreateFontString(nil, 'BACKGROUND', 'GameFontNormalSmallLeft') do
        Prompt:SetPoint('TOPLEFT', 3, 0)
        Prompt:SetTextColor(0.35, 0.35, 0.35)
        Prompt:SetJustifyV('TOP')
        Prompt:Hide()
    end

    local FocusGrabber = CreateFrame('Button', nil, self) do
        FocusGrabber:SetAllPoints(ScrollFrame)
        FocusGrabber:SetFrameLevel(EditBox:GetFrameLevel() + 5)
        FocusGrabber:SetScript('OnClick', function()
            self.EditBox:SetCursorPosition(self.EditBox:GetText():len())
            self.EditBox:SetFocus()
        end)
    end

    ScrollFrame:SetScrollChild(EditBox)

    ScrollFrame:SetScript('OnSizeChanged', function(self, width, height)
        EditBox:SetSize(width, height)
        Prompt:SetSize(width - 6, height)
    end)

    self.Prompt = Prompt
    self.ScrollFrame = ScrollFrame
    self.EditBox = EditBox
    self.FocusGrabber = FocusGrabber

    self:SetAutoHide(true)
    self:SetTop(true)
end

function EditBox:SetPrompt(text)
    if text then
        self.Prompt:SetText(text)
        self.Prompt:Show()
    else
        self.Prompt:Hide()
    end
end

function EditBox:SetAutoHide(auto)
    local scrollBar = self.ScrollFrame.ScrollBar
    scrollBar.scrollBarHideable = auto
    scrollBar.ScrollDownButton:Disable()
    scrollBar.ScrollUpButton:Disable()
    if auto then
        scrollBar:Hide()
    else
        scrollBar:Show()
    end
end

function EditBox:GetAutoHide()
    return self.ScrollFrame.ScrollBar.scrollBarHideable
end

function EditBox:GetText()
    return self.EditBox:GetText()
end

function EditBox:SetText(text)
    self.EditBox:SetText(text or '')
end

function EditBox:SetReadOnly(readonly)
    self.EditBox:SetEnabled(readonly)
    self.FocusGrabber:SetFrameLevel(self.EditBox:GetFrameLevel() + (readonly and 2 or 0))
end

function EditBox:GetEditBox()
    return self.EditBox
end

function EditBox:SetTop(isTop)
    self.ScrollFrame.isTop = isTop
end

function EditBox:SetFocus(flag)
    if flag then
        self.EditBox:SetFocus()
    else
        self.EditBox:ClearFocus()
    end
end

function EditBox:SetTabPressed(func)
    if type(func) == 'function' then
        self.EditBox:SetScript('OnTabPressed', function(self)
            func()
        end)
    end
end

function EditBox:ClearFocus()
    self:SetFocus()
end

function EditBox:ClearCopy()
    self.FocusGrabber:SetScript('OnDoubleClick', nil)
end

function EditBox:SetMaxLetters(maxLetters)
    self.EditBox:SetMaxLetters(maxLetters)
end

function EditBox:SetMaxBytes(maxBytes)
    self.EditBox:SetMaxBytes(maxBytes)
end

function EditBox:SetSinglelLine()
    self.Prompt:SetJustifyH('CENTER')
    self.Prompt:SetJustifyV('MIDDLE')
    self.Prompt:SetAllPoints(true)
    self.EditBox:SetAllPoints(true)
    self.EditBox:SetMultiLine(false)
    self.EditBox:SetHitRectInsets(0,0,0,0)
    self.EditBox:SetJustifyH('CENTER')
end
