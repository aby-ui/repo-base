
local GUI = tdCore('GUI')

local CheckBox = GUI:NewModule('CheckBox', CreateFrame('CheckButton'), 'UIObject', 'Control')
CheckBox:SetVerticalArgs(40, 0, 0)

function CheckBox:New(parent)
    local obj = self:Bind(CreateFrame('CheckButton', nil, parent))
    
    obj.__depends = {}
    obj:SetSize(26, 26)
    obj:SetHitRectInsets(0, -100, 0, 0)
    
    obj:SetNormalTexture([[Interface\Buttons\UI-CheckBox-Up]])
    obj:SetPushedTexture([[Interface\Buttons\UI-CheckBox-Down]])
    obj:SetHighlightTexture([[Interface\Buttons\UI-CheckBox-Highlight]])
    obj:SetCheckedTexture([[Interface\Buttons\UI-CheckBox-Check]])
    obj:SetDisabledCheckedTexture([[Interface\Buttons\UI-CheckBox-Check-Disabled]])
    
    obj:GetLabelFontString():SetPoint('LEFT', obj, 'RIGHT', 5, 0)
    obj:SetFontString(obj:GetLabelFontString())
    obj:SetNormalFontObject('GameFontNormalSmall')
    obj:SetHighlightFontObject('GameFontHighlightSmall')
    obj:SetDisabledFontObject('GameFontDisableSmall')
    
    obj:SetScript('OnClick', self.OnClick)
    
    return obj
end

function CheckBox:OnClick()
    PlaySound163(self:GetChecked() and 'igMainMenuOptionCheckBoxOff' or 'igMainMenuOptionCheckBoxOn')
    self:SetProfileValue(self:GetChecked() and true or false)
    self:UpdateDepends()
end

function CheckBox:Update()
    self:SetChecked(self:GetProfileValue())
    self:UpdateDepends()
end

function CheckBox:AddDepend(obj)
    tinsert(self.__depends, obj)
end

function CheckBox:UpdateDepends()
    if self:GetChecked() then
        self:EnableAll()
    else
        self:DisableAll()
    end
end

function CheckBox:EnableAll()
    for _, obj in ipairs(self.__depends) do
        obj:Enable()
        if obj:IsWidgetType('CheckBox') and obj:GetChecked() then
            obj:EnableAll()
        end
    end
end

function CheckBox:DisableAll()
    for _, obj in ipairs(self.__depends) do
        obj:Disable()
        if obj:IsWidgetType('CheckBox') then
            obj:DisableAll()
        end
    end
end
