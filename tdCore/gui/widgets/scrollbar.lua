
local GUI = tdCore('GUI')

local ScrollBar = GUI:NewModule('ScrollBar', CreateFrame('Slider'))

local function PageOnClick(self)
    PlaySound163("UChatScrollButton")
    local parent = self:GetParent()
    parent:SetValue(parent:GetValue() + self.y)
end

function ScrollBar:New(parent)
    local obj = self:Bind(CreateFrame('Slider', nil, parent))
    obj:SetWidth(16)
    obj:SetPoint('TOPRIGHT', -8, -24)
    obj:SetPoint('BOTTOMRIGHT', -8, 24)
    obj:SetValueStep(1)
    obj:SetThumbTexture([[Interface\Buttons\UI-ScrollBar-Knob]])
    obj:SetScript('OnValueChanged', self.OnValueChanged)
    obj:SetScript('OnShow', self.OnShow)
    obj:SetScript('OnHide', self.OnHide)
    
    local up = CreateFrame('Button', nil, obj)
    up:SetPoint('BOTTOM', obj, 'TOP')
    up:SetSize(16, 16)
    up:SetNormalTexture([[Interface\Buttons\UI-ScrollBar-ScrollUpButton-Up]])
    up:SetPushedTexture([[Interface\Buttons\UI-ScrollBar-ScrollUpButton-Down]])
    up:SetDisabledTexture([[Interface\Buttons\UI-ScrollBar-ScrollUpButton-Disabled]])
    up:SetHighlightTexture([[Interface\Buttons\UI-ScrollBar-ScrollUpButton-Highlight]])

    up:GetNormalTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
    up:GetPushedTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
    up:GetDisabledTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
    up:GetHighlightTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
    up:GetHighlightTexture():SetBlendMode('ADD')
    
    up.y = -1
    up:SetScript('OnClick', PageOnClick)

    local down = CreateFrame('Button', nil, obj)
    down:SetPoint('TOP', obj, 'BOTTOM')
    down:SetSize(16, 16)
    down:SetNormalTexture([[Interface\Buttons\UI-ScrollBar-ScrollDownButton-Up]])
    down:SetPushedTexture([[Interface\Buttons\UI-ScrollBar-ScrollDownButton-Down]])
    down:SetDisabledTexture([[Interface\Buttons\UI-ScrollBar-ScrollDownButton-Disabled]])
    down:SetHighlightTexture([[Interface\Buttons\UI-ScrollBar-ScrollDownButton-Highlight]])

    down:GetNormalTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
    down:GetPushedTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
    down:GetDisabledTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
    down:GetHighlightTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
    down:GetHighlightTexture():SetBlendMode('ADD')
    
    down.y = 1
    down:SetScript('OnClick', PageOnClick)
    
    local thumb = obj:GetThumbTexture()
    thumb:SetSize(16, 24)
    thumb:SetTexCoord(1/4, 3/4, 1/8, 7/8)

    local border = CreateFrame('Frame', nil, obj)
    border:SetPoint('TOPLEFT', up, -5, 5)
    border:SetPoint('BOTTOMRIGHT', down, 5, -3)
    border:SetBackdrop{
        edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
        tile = true,
        tileSize = 16,
        edgeSize = 12,
        insets = { left = 0, right = 0, top = 5, bottom = 5 }
    }
    border:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b, 0.5)
    
    obj.up = up
    obj.down = down
    
    return obj
end

function ScrollBar:OnValueChanged(value)
    self:UpdateButton(value, self:GetMinMaxValues())
    
    local parent = self:GetParent()
    if parent and type(parent.OnScrollValueChanged) == 'function' then
        parent:OnScrollValueChanged(value)
    end
end

function ScrollBar:OnShow()
    local parent = self:GetParent()
    if parent and type(parent.OnScrollShow) == 'function' then
        parent:OnScrollShow()
    end
end

function ScrollBar:OnHide()
    local parent = self:GetParent()
    if parent and type(parent.OnScrollHide) == 'function' then
        parent:OnScrollHide()
    end
end

local orig_ScrollBar_SetMinMaxValues = ScrollBar.SetMinMaxValues
function ScrollBar:SetMinMaxValues(min, max)
    if min == max then
        self:Hide()
    else
        self:Show()
    end
    orig_ScrollBar_SetMinMaxValues(self, min, max)
    self:UpdateButton(self:GetValue(), min, max)
end

function ScrollBar:UpdateButton(value, min, max)
    if value == min then
        self.up:Disable()
    else
        self.up:Enable()
    end
    if value == max then
        self.down:Disable()
    else
        self.down:Enable()
    end
end

function ScrollBar:Up(step)
    self:SetValue(self:GetValue() - step or 1)
end

function ScrollBar:Down(step)
    self:SetValue(self:GetValue() + step or 1)
end
