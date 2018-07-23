
local GUI = tdCore('GUI')

local EditBox = {}
function EditBox:New(parent)
    local obj = CreateFrame('EditBox', nil, parent)
    
    obj:SetFontObject('ChatFontNormal')
    obj:SetTextInsets(4, 4, 4, 4)
    obj:SetMultiLine(true)
    obj:SetAutoFocus(false)
    obj:SetPoint('TOPLEFT')
    
    obj:SetScript('OnTextChanged', self.OnTextChanged)
    obj:SetScript('OnCursorChanged', self.OnCursorChanged)
    obj:SetScript('OnUpdate', self.OnUpdate)
    obj:SetScript('OnEscapePressed', obj.ClearFocus)
    
    return obj
end

function EditBox:OnTextChanged()
    if self.readonly then
        self:SetText(self.text or '')
    else
        self.handleCursorChange = true
        EditBox.OnUpdate(self, 0)
    end
end

function EditBox:OnCursorChanged(x, y, w, h)
    self.cursorOffset = y
    self.cursorHeight = h
    self.handleCursorChange = true
end

function EditBox:OnUpdate()
    local height, range, scroll, cursorOffset
    if self.handleCursorChange then
        local scrollFrame = self:GetParent()
        
        height = scrollFrame:GetHeight()
        range = scrollFrame:GetVerticalScrollRange()
        scroll = scrollFrame:GetVerticalScroll()
        cursorOffset = - (self.cursorOffset or 0)
        
        if math.floor(height) <= 0 or math.floor(range) <= 0 then
            return
        end
        
        while cursorOffset < scroll do
            scroll = scroll - (height / 2)
            if ( scroll < 0 ) then
                scroll = 0
            end
            scrollFrame:SetVerticalScroll(scroll)
        end

        while (cursorOffset + self.cursorHeight) > (scroll + height) and scroll < range do
            scroll = scroll + (height / 2)
            if scroll > range then
                scroll = range
            end
            scrollFrame:SetVerticalScroll(scroll)
        end
        self.handleCursorChange = false
    end
end

local TextEdit = GUI:NewModule('TextEdit', GUI('Widget'):New())

TextEdit.__index = function(o, k)
    if TextEdit[k] then
        return TextEdit[k]
    end
    
    local editbox = rawget(o, '__childParent')
    if editbox and type(editbox[k]) == 'function' then
        o[k] = function(self, ...)
            return editbox[k](editbox, ...)
        end
        return o[k]
    end
end

function TextEdit:New(parent)
    local obj = self:Bind(GUI('Widget'):New())
    
    local tl = obj:CreateTexture(nil, 'OVERLAY')
    local bl = obj:CreateTexture(nil, 'OVERLAY')
    local br = obj:CreateTexture(nil, 'OVERLAY')
    local tr = obj:CreateTexture(nil, 'OVERLAY')
    local l = obj:CreateTexture(nil, 'OVERLAY')
    local r = obj:CreateTexture(nil, 'OVERLAY')
    local b = obj:CreateTexture(nil, 'OVERLAY')
    local t = obj:CreateTexture(nil, 'OVERLAY')
    
    tl:SetTexture([[Interface\Tooltips\UI-Tooltip-Border]])
    bl:SetTexture([[Interface\Tooltips\UI-Tooltip-Border]])
    br:SetTexture([[Interface\Tooltips\UI-Tooltip-Border]])
    tr:SetTexture([[Interface\Tooltips\UI-Tooltip-Border]])
    l:SetTexture([[Interface\Tooltips\UI-Tooltip-Border]])
    r:SetTexture([[Interface\Tooltips\UI-Tooltip-Border]])
    b:SetTexture([[Interface\OptionsFrame\UI-OptionsFrame-Spacer]])
    t:SetTexture([[Interface\OptionsFrame\UI-OptionsFrame-Spacer]])
    
    tl:SetTexCoord(0.5, 0.625, 0, 1)
    bl:SetTexCoord(0.75, 0.875, 0, 1)
    br:SetTexCoord(0.875, 1, 0, 1)
    tr:SetTexCoord(0.625, 0.75, 0, 1)
    l:SetTexCoord(0, 0.125, 0, 1)
    r:SetTexCoord(0.125, 0.25, 0, 1)
    
    tl:SetSize(16, 16)
    bl:SetSize(16, 16)
    br:SetSize(16, 16)
    tr:SetSize(16, 16)
    
    tl:SetPoint('TOPLEFT', -5, 5)
    bl:SetPoint('BOTTOMLEFT', -5, -5)
    br:SetPoint('BOTTOMRIGHT', 5, -5)
    tr:SetPoint('TOPRIGHT', 5, 5)
    
    l:SetPoint('TOPLEFT', tl, 'BOTTOMLEFT')
    l:SetPoint('BOTTOMRIGHT', bl, 'TOPRIGHT')
    
    r:SetPoint('TOPLEFT', tr, 'BOTTOMLEFT')
    r:SetPoint('BOTTOMRIGHT', br, 'TOPRIGHT')
    
    b:SetPoint('TOPLEFT', bl, 'TOPRIGHT', 0, -2)
    b:SetPoint('BOTTOMRIGHT', br, 'BOTTOMLEFT', 0, -2)
    
    t:SetPoint('TOPLEFT', tl, 'TOPRIGHT', 0, 7)
    t:SetPoint('BOTTOMRIGHT', tr, 'BOTTOMLEFT', 0, 7)

    obj:SetBackdrop{bgFile = [[Interface\ChatFrame\ChatFrameBackground]]}
    obj:SetBackdropColor(0, 0, 0, 0.4)
    
    obj:SetParent(parent)
    obj:GetLabelFontString():SetPoint('BOTTOMLEFT', obj, 'TOPLEFT', -5, 5)
    obj:EnableScroll(EditBox:New(self), 1)
    
    obj.__scrollBar:ClearAllPoints()
    obj.__scrollBar:SetPoint('TOPRIGHT', -3, -19)
    obj.__scrollBar:SetPoint('BOTTOMRIGHT', -3, 19)
    
    obj:SetScript('OnSizeChanged', self.OnSizeChanged)
    obj:SetScript('OnMouseUp', self.OnMouseUp)
    
    return obj
end

local orig_TextEdit_GetVerticalArgs = TextEdit.GetVerticalArgs
function TextEdit:GetVerticalArgs()
    if rawget(self, '__vo_height') then
        return orig_TextEdit_GetVerticalArgs(self)
    end
    return self:GetHeight() + 20, -20, 5, -5
end

function TextEdit:OnSizeChanged(width, height)
    self.__childParent:SetSize(width, height)
    self:SetWheelStep(height / 2)
    self:OnScrollRangeChanged()
end

function TextEdit:OnMouseUp()
    self.__childParent:SetFocus()
end

function TextEdit:SetReadOnly(readonly)
    self.__childParent.readonly = readonly
end

function TextEdit:Update()
    
end

function TextEdit:SetText(text)
    self.__childParent.text = text
    self.__childParent:SetText(text)
end
