
local GUI = tdCore('GUI')

local Button = GUI:NewModule('Button', CreateFrame('Button'), 'UIObject')
Button:SetVerticalArgs(40, -8, 0)

function Button:New(parent)
    local obj = self:Bind(CreateFrame('Button', nil, parent))
    if parent then
        obj:SetSize(100, 22)

        obj:SetHighlightFontObject('GameFontHighlightSmall')
        obj:SetNormalFontObject('GameFontNormalSmall')

        obj:SetNormalTexture([[Interface\Buttons\UI-Panel-Button-Up]])
        obj:SetPushedTexture([[Interface\Buttons\UI-Panel-Button-Down]])
        obj:SetHighlightTexture([[Interface\Buttons\UI-Panel-Button-Highlight]])
        obj:SetDisabledTexture([[Interface\Buttons\UI-Panel-Button-Disabled]])
        obj:GetNormalTexture():SetTexCoord(0, 0.625, 0, 0.6875)
        obj:GetPushedTexture():SetTexCoord(0, 0.625, 0, 0.6875)
        obj:GetHighlightTexture():SetTexCoord(0, 0.625, 0, 0.6875)
        obj:GetDisabledTexture():SetTexCoord(0, 0.625, 0, 0.6875)
    end
    return obj
end

function Button:Update()

end

Button.SetLabelText = Button.SetText
Button.GetLabelText = Button.GetText
