--[[
	slider.lua
		A options slider
--]]
local _, Addon = ...
local Slider = Addon.Classy:New('Slider')
Addon.Slider = Slider

function Slider:New(name, parent, low, high, step)
    local f = self:Bind(CreateFrame('Slider', parent:GetName() .. '_' .. name, parent, 'OptionsSliderTemplate'))
    f:SetMinMaxValues(low, high)
    f:SetValueStep(step)
    f:EnableMouseWheel(true)

    f.Text:SetText(name)
    f.Text:SetFontObject('GameFontNormalLeft')
    f.Text:ClearAllPoints()
    f.Text:SetPoint('BOTTOMLEFT', f, 'TOPLEFT')
    f.Low:SetText('')
    f.High:SetText('')

    local text = f:CreateFontString(nil, 'BACKGROUND', 'GameFontHighlightSmall')
    text:SetJustifyH('RIGHT')
    text:SetPoint('BOTTOMRIGHT', f, 'TOPRIGHT')
    f.valText = text

    f:SetScript('OnShow', f.OnShow)
    f:SetScript('OnMouseWheel', f.OnMouseWheel)
    f:SetScript('OnValueChanged', f.OnValueChanged)
    f:SetScript('OnMouseWheel', f.OnMouseWheel)
    f:SetScript('OnEnter', f.OnEnter)
    f:SetScript('OnLeave', f.OnLeave)

    return f
end

function Slider:OnShow()
    self:UpdateValue()
end

function Slider:OnValueChanged(value)
    self:SetSavedValue(value)
    self:UpdateText(self:GetSavedValue())
end

function Slider:OnMouseWheel(direction)
    local step = self:GetValueStep() * direction
    local value = self:GetValue()
    local minVal, maxVal = self:GetMinMaxValues()

    if step > 0 then
        self:SetValue(math.min(value + step, maxVal))
    else
        self:SetValue(math.max(value + step, minVal))
    end
end

function Slider:OnEnter()
    if not GameTooltip:IsOwned(self) and self.tooltip then
        GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
        GameTooltip:SetText(self.tooltip)
    end
end

function Slider:OnLeave()
    if GameTooltip:IsOwned(self) then
        GameTooltip:Hide()
    end
end

-- update methods
function Slider:SetSavedValue(value)
    assert(false, 'Hey, you forgot to set SetSavedValue for ' .. self:GetName())
end

function Slider:GetSavedValue()
    assert(false, 'Hey, you forgot to set GetSavedValue for ' .. self:GetName())
end

function Slider:UpdateValue()
    self:SetValue(self:GetSavedValue())
    self:UpdateText(self:GetSavedValue())
end

function Slider:UpdateText(value)
    if self.GetFormattedText then
        self.valText:SetText(self:GetFormattedText(value))
    else
        self.valText:SetText(value)
    end
end
