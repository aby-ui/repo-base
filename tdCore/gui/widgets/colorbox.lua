
local GUI = tdCore('GUI')

local ColorButton = GUI:NewModule('ColorButton', CreateFrame('Button'), 'UIObject')

function ColorButton:New(parent)
    local obj = self:Bind(CreateFrame('Button', nil, parent))
    if parent then
        obj:SetNormalTexture([[Interface\ChatFrame\ChatFrameColorSwatch]])
        obj:SetHighlightTexture([[Interface\Buttons\ButtonHilight-Square]])
        obj:SetSize(26, 26)
    end
    return obj
end

function ColorButton:SetColor(r, g, b)
    self.r, self.g, self.b = r, g, b
    return self:GetNormalTexture():SetVertexColor(r, g, b)
end

function ColorButton:GetColor()
    return self.r, self.g, self.b
end

----- ColorBox

local ColorBox = GUI:NewModule('ColorBox', ColorButton:New(), 'Control')
ColorBox:SetVerticalArgs(40, 0, 0)
ColorBox:RegisterHandle('OnColorChanged')

function ColorBox:New(parent)
    local obj = self:Bind(ColorButton:New(parent))
    
    obj:GetLabelFontString():SetPoint('LEFT', obj, 'RIGHT', 5, 0)
    obj:SetFontString(obj:GetLabelFontString())
    obj:SetNormalFontObject('GameFontNormalSmall')
    obj:SetHighlightFontObject('GameFontHighlightSmall')
    obj:SetDisabledFontObject('GameFontDisableSmall')
    
    obj:SetHitRectInsets(0, -100, 0, 0)
    
    obj:SetScript('OnClick', self.OnClick)
    obj:SetHandle('OnColorChanged', self.OnColorChanged)
    
    return obj
end

function ColorBox:Update()
    local value = self:GetProfileValue()
    self:SetColor(value.r, value.g, value.b)
end

function ColorBox:OnClick()
    self:ToggleMenu('ColorMenu')
end

function ColorBox:OnColorChanged(r, g, b)
    self:SetProfileValue{r = r, g = g, b = b}
end
