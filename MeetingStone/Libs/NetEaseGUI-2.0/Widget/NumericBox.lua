
local WIDGET, VERSION = 'NumericBox', 2

local GUI = LibStub('NetEaseGUI-2.0')
local NumericBox = GUI:NewClass(WIDGET, GUI:GetClass('InputBox'), VERSION)
if not NumericBox then
    return
end

local function ButtonOnClick(self)
    -- local parent = self:GetParent()
    -- parent:SetNumber(parent:GetNumber() + self.delta * parent.step)
    self:GetParent():OnMouseWheel(self.delta)
end

local function ButtonOnEnable(self)
    self.Texture:SetDesaturated(false)
    self.Texture:SetAlpha(1)
end

local function ButtonOnDisable(self)
    self.Texture:SetDesaturated(true)
    self.Texture:SetAlpha(0.5)
end

function NumericBox:Constructor(parent)
    self:SetNumeric(true)
    self:SetMinMaxValues(0, 99)
    self:SetValueStep(1)

    self:SetScript('OnTextChanged', self.OnTextChanged)
    self:SetScript('OnMouseWheel', self.OnMouseWheel)
    self:SetScript('OnEditFocusLost', self.OnTextChanged)
end

function NumericBox:SetNumber(num)
    if num < self.minValue then
        num = self.minValue
    elseif num > self.maxValue then
        num = self.maxValue
    end
    self:SuperCall('SetNumber', num)
end

function NumericBox:SetMinMaxValues(minValue, maxValue)
    if type(minValue) ~= 'number' then
        error(([[bad argument #1 to 'SetMinMaxValues' (number expected, got %s)]]):format(type(minValue)), 2)
    end
    if type(maxValue) ~= 'number' then
        error(([[bad argument #2 to 'SetMinMaxValues' (number expected, got %s)]]):format(type(maxValue)), 2)
    end
    if minValue < 0 then
        error('err min value', 2)
    end
    if minValue > maxValue then
        error('err max value', 2)
    end

    self.minValue = floor(minValue)
    self.maxValue = floor(maxValue)

    self:SetMaxBytes(#(tostring(self.maxValue)) + 1)
    self:OnTextChanged()
    self:OnEnableChanged()

    self:Fire('OnMinMaxChanged', minValue, maxValue)
end

function NumericBox:SetValueStep(step)
    self.step = step
end

function NumericBox:OnTextChanged(userInput)
    if not userInput or #self:GetText() == self:GetMaxBytes() - 1 then
        local value = self:GetNumber()
        if value < self.minValue then
            return self:SetNumber(self.minValue)
        elseif value > self.maxValue then
            return self:SetNumber(self.maxValue)
        end
    end

    self:OnEnableChanged()
    self:Fire('OnValueChanged', self:GetNumber())
end

function NumericBox:OnMouseWheel(delta)
    if not self:IsEnabled() then
        return
    end
    self:SetNumber(self:GetNumber() + delta * self.step)
end

function NumericBox:OnEnableChanged()
    if not self.PlusButton then
        return
    end
    local isEnabled = self:IsEnabled()
    local value = self:GetNumber()

    self.PlusButton:SetEnabled(isEnabled and value < self.maxValue)
    self.MinusButton:SetEnabled(isEnabled and value > self.minValue)
end

function NumericBox:EnableControl()
    local PlusButton = CreateFrame('Button', nil, self) do
        PlusButton:SetSize(12, 8)
        PlusButton:SetPoint('BOTTOMRIGHT', self, 'RIGHT', -1, 0)
        PlusButton:SetScript('OnClick', ButtonOnClick)
        PlusButton:SetScript('OnEnable', ButtonOnEnable)
        PlusButton:SetScript('OnDisable', ButtonOnDisable)

        PlusButton.delta = 1

        local Texture = PlusButton:CreateTexture(nil, 'ARTWORK') do
            Texture:SetAllPoints(PlusButton)
            Texture:SetTexture([[Interface\BUTTONS\Arrow-Up-Down]])
            Texture:SetTexCoord(0, 1, 0.5, 0.9)
        end
        PlusButton.Texture = Texture
    end
    
    local MinusButton = CreateFrame('Button', nil, self) do
        MinusButton:SetSize(12, 8)
        MinusButton:SetPoint('TOPRIGHT', self, 'RIGHT', -1, 0)
        MinusButton:SetScript('OnClick', ButtonOnClick)
        MinusButton:SetScript('OnEnable', ButtonOnEnable)
        MinusButton:SetScript('OnDisable', ButtonOnDisable)

        MinusButton.delta = -1

        local Texture = MinusButton:CreateTexture(nil, 'ARTWORK') do
            Texture:SetAllPoints(MinusButton)
            Texture:SetTexture([[Interface\BUTTONS\Arrow-Down-Down]])
            Texture:SetTexCoord(0, 1, 0.1, 0.5)
        end
        MinusButton.Texture = Texture
    end

    self.PlusButton = PlusButton
    self.MinusButton = MinusButton

    self:HookScript('OnEnable', self.OnEnableChanged)
    self:HookScript('OnDisable', self.OnEnableChanged)
end
