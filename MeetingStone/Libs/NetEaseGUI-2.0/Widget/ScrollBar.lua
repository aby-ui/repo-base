
local WIDGET, VERSION = 'ScrollBar', 2

local GUI = LibStub('NetEaseGUI-2.0')
local ScrollBar = GUI:NewClass(WIDGET, 'Slider.UIPanelScrollBarTemplate', VERSION)
if not ScrollBar then
    return
end

function ScrollBar:Constructor()
    self:SetScript('OnValueChanged', self.OnValueChanged)
    self:SetScript('OnMinMaxChanged', self.OnMinMaxChanged)
    -- self:SetScript('OnMouseUp', self.UpdateButton)
    self:SetValueStep(1)
    self:SetMinMaxValues(0, 1)
    self:SetValue(0)
    self:Hide()
    self:SetStepsPerPage(1)
    self.scrollStep = 1
end

function ScrollBar:OnValueChanged(value)
    value = floor(value + 0.5)
    if value ~= self.prevValue then
        self.prevValue = value
        self:UpdateButton()
        self:GetParent():SetOffset(value)
    end
end

function ScrollBar:OnMinMaxChanged(...)
    self.minVal, self.maxVal = ...
    self:UpdateButton()
    self:UpdateShown()
end

function ScrollBar:UpdateButton()
    self.ScrollUpButton:Enable()
    self.ScrollDownButton:Enable()

    local value = self:SuperCall('GetValue')
    local minVal, maxVal = self:GetMinMaxValues()

    if value == minVal then
        self.ScrollUpButton:Disable()
    end
    if value == maxVal then
        self.ScrollDownButton:Disable()
    end
end

function ScrollBar:UpdateShown()
    if self.noScrollBarHidden then
        return
    end
    self:SetShown(self.minVal ~= self.maxVal)
end

function ScrollBar:SetScrollStep(scrollStep)
    self.scrollStep = scrollStep
    self:SetStepsPerPage(scrollStep)
end

ScrollBar.GetScrollStep = ScrollBar.GetStepsPerPage

function ScrollBar:AtTop()
    return self:GetValue() == self.minVal
end

function ScrollBar:AtBottom()
    return self:GetValue() == self.maxVal
end

function ScrollBar:ScrollToTop()
    self:SetValue(self.minVal)
end

function ScrollBar:ScrollToBottom()
    self:SetValue(self.maxVal)
end

function ScrollBar:GetValue()
    return floor(self:SuperCall('GetValue') + 0.5)
end

function ScrollBar:GetFixedWidth()
    return 18
end
