
local GUI = tdCore('GUI')
local ColorMenu = GUI:NewMenu('ColorMenu', GUI('Widget'):New(UIParent, true))

function ColorMenu:SetColor(r, g, b)
    self.colorSelect:SetColorRGB(r, g, b)
end

do
    ColorMenu:SetSize(254, 230)
    
    local function OnClick(self)
        local caller = ColorMenu:GetCaller()
        
        local r1, g1, b1 = self:GetColor()
        local r2, g2, b2 = caller:GetColor()
        if r1 ~= r2 or g1 ~= g2 or b1 ~= b2 then
            caller:SetColor(self:GetColor())
            caller:RunHandle('OnColorChanged', r1, g1, b1)
        end
        ColorMenu:Hide()
    end
    
    local NUMS = 3
    local WIDTH = 26
    
    for rows = 1, NUMS do
        local r = (1 / (NUMS - 1)) * (rows - 1)
        for cols = 1, NUMS * NUMS do
            local g = (1 / (NUMS - 1)) * (floor((cols - 1) / NUMS))
            local b = (1 / (NUMS - 1)) * ((cols - 1) % NUMS)
            
            local colorButton = GUI('ColorButton'):New(ColorMenu)
            colorButton:SetColor(r, g, b)
            colorButton:Into(cols == NUMS * NUMS and WIDTH or 0, 0, (cols - 1) * WIDTH)
            colorButton:SetScript('OnClick', OnClick)
        end
    end
    
    local colorSelect = CreateFrame('ColorSelect', nil, ColorMenu)
    colorSelect:SetPoint('BOTTOMLEFT', 10, 10)
    colorSelect:EnableMouse(true)
    colorSelect:SetSize(175, 128)
    
    local wheelTexture = colorSelect:CreateTexture(nil, 'OVERLAY')
    wheelTexture:SetSize(128, 128)
    wheelTexture:SetPoint('BOTTOMLEFT')
    
    colorSelect:SetColorWheelTexture(wheelTexture)
    colorSelect:SetColorWheelThumbTexture([[Interface\Buttons\UI-ColorPicker-Buttons]])
    colorSelect:GetColorWheelThumbTexture():SetSize(10, 10)
    colorSelect:GetColorWheelThumbTexture():SetTexCoord(0, 0.15625, 0, 0.625)
    
    local valueTexture = colorSelect:CreateTexture(nil, 'OVERLAY')
    valueTexture:SetSize(32, 128)
    valueTexture:SetPoint('LEFT', wheelTexture, 'RIGHT', 10, 0)
    
    colorSelect:SetColorValueTexture(valueTexture)
    colorSelect:SetColorValueThumbTexture([[Interface\Buttons\UI-ColorPicker-Buttons]])
    colorSelect:GetColorValueThumbTexture():SetSize(48, 14)
    colorSelect:GetColorValueThumbTexture():SetTexCoord(0.25, 1.0, 0, 0.875)
    
    local selectColorButton = GUI('ColorButton'):New(ColorMenu)
    selectColorButton:SetSize(32, 32)
    selectColorButton:SetScript('OnClick', OnClick)
    selectColorButton:Into(128, -100, nil, 0)
    
    colorSelect:SetScript('OnColorSelect', function(self, r, g, b)
        selectColorButton:SetColor(r, g, b)
    end)
    
    colorSelect:SetScript('OnShow', function(self)
        local caller = ColorMenu:GetCaller()
        if caller and type(caller.GetColor) == 'function' then
            self:SetColorRGB(caller:GetColor())
        end
    end)
    
    ColorMenu.colorSelect = colorSelect
end
