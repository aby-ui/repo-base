
local GUI = tdCore('GUI')

local Accuracy = 1 / 0.00001

local Slider = GUI:NewModule('Slider', CreateFrame('Slider'), 'UIObject', 'Control')
Slider:SetVerticalArgs(40, -15, 0, 0)
Slider:SetNormalColor(1, 1, 1, 1)
Slider:SetDisabledColor(0.7, 0.7, 0.7, 0.7)

function Slider:New(parent)
    local obj = self:Bind(CreateFrame('Slider', nil, parent))
    
    obj:SetBackdrop{
        bgFile = [[Interface\Buttons\UI-SliderBar-Background]],
        edgeFile = [[Interface\Buttons\UI-SliderBar-Border]],
        edgeSize = 8, tileSize = 8, tile = true, 
        insets = {left = 3, right = 3, top = 6, bottom = 6}
    }
    obj:SetOrientation('HORIZONTAL')
    obj:SetHitRectInsets(0, 0, 0, 0)
    obj:SetThumbTexture([[Interface\Buttons\UI-SliderBar-Button-Horizontal]])
    obj:SetHeight(17)
    obj:SetValueStep(1)
    
    obj:GetLabelFontString():SetPoint('BOTTOMLEFT', obj, 'TOPLEFT')
    obj:GetValueFontString():SetPoint('BOTTOMRIGHT', obj, 'TOPRIGHT')
    
    obj:SetScript('OnValueChanged', self.OnValueChanged)
    obj:SetScript('OnEnable', self.OnEnable)
    obj:SetScript('OnDisable', self.OnDisable)
    
    return obj
end

function Slider:Update()
    self:SetValue(self:GetProfileValue())
end

function Slider:OnValueChanged(value)
    value = floor(value * Accuracy + 0.5) / Accuracy
    
    if self.__prevValue and self.__prevValue == value then
        return
    end
    self.__prevValue = value
    
    self:SetProfileValue(value)
    self:SetValueText(value)
end
