
local GUI = tdCore('GUI')

local LineEdit = GUI:NewModule('LineEdit', CreateFrame('EditBox'), 'UIObject', 'Control')
LineEdit:SetVerticalArgs(40, -15, 0, 0)

function LineEdit:New(parent)
    local obj = self:Bind(CreateFrame('EditBox', nil, parent))
    
    obj:SetAutoFocus(nil)
    obj:SetHeight(20)
    obj:SetFontObject('ChatFontNormal')
    obj:SetTextInsets(8, 8, 0, 0)
    obj:SetBackdrop{
        bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
        edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
        edgeSize = 14, tileSize = 20, tile = true,
        insets = {left = 2, right = 2, top = 2, bottom = 2},
    }
    obj:SetBackdropColor(0, 0, 0, 0.4)
    obj:SetBackdropBorderColor(0.7, 0.7, 0.7, 0.7)
    
    obj:SetScript('OnEscapePressed', self.Update)
    obj:SetScript('OnEnterPressed', self.OnEnterPressed)
    obj:SetScript('OnTextChanged', self.OnTextChanged)
    obj:SetScript('OnEnable', self.OnEnable)
    obj:SetScript('OnDisable', self.OnDisable)
    
    obj:GetLabelFontString():SetPoint('BOTTOMLEFT', obj, 'TOPLEFT')
    
    return obj
end

function LineEdit:IsNumeric()
    return self.__numeric
end

function LineEdit:SetNumeric(numeric)
    self.__numeric = numeric
end

function LineEdit:SetValue(value)
    if not value then
        return
    end
    if self:IsNumeric() then
        self:SetNumber(tonumber(value) or 0)
    else
        self:SetText(value)
    end
end

function LineEdit:GetValue()
    if self:IsNumeric() then
        return self:GetNumber()
    else
        return self:GetText()
    end
end

function LineEdit:Update()
    self:SetValue(self:GetProfileValue())
    self:ClearFocus()
end

function LineEdit:OnEnterPressed()
    local value = self:GetValue()
    if value then
        self:SetProfileValue(value)
    end
    self:ClearFocus()
end

local validnumber = {
    [''] = true,
    ['-'] = true,
    ['0.'] = true,
    ['-0'] = true,
    ['-0.'] = true,
}
function LineEdit:OnTextChanged()
    if not self:HasFocus() then
        self:SetCursorPosition(0)
        self:HighlightText(0, 100)
    end
    
    local text = self:GetText()
    if self:IsNumeric() and not validnumber[text] then
        local value = tonumber(text)
        if not value then
            self:SetText(self.prevValue)
            return
        elseif value == 0 then
            self.prevValue = 0
            self:SetText(0)
            return
        end
    end
    self.prevValue = text
end
