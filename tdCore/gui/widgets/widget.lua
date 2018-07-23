
local GUI = tdCore('GUI')

local Widget = GUI:NewModule('Widget', CreateFrame('ScrollFrame'), 'UIObject', 'View', 'Control')
Widget:SetPadding(10, -10, 10, 10)

function Widget:New(parent, noScroll)
    local obj = self:Bind(CreateFrame('ScrollFrame', nil, parent))
    if parent then
        obj.__children = {}
        obj.__childOffset = 0
        
        obj:SetBackdrop{
            bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
            edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
            edgeSize = 14, tileSize = 20, tile = true,
            insets = {left = 2, right = 2, top = 2, bottom = 2},
        }
        obj:SetBackdropColor(0, 0, 0, .4)
        obj:SetBackdropBorderColor(1, 1, 1, 1)
        obj:GetLabelFontString():SetPoint('BOTTOMLEFT', obj, 'TOPLEFT')
        
        if not noScroll then
            obj:EnableScroll()
        end
    end
    return obj
end

function Widget:EnableScroll(child, scrollStep)
    if not child then
        child = CreateFrame('Frame', nil, self)
        child:SetPoint('CENTER')
        child:SetSize(100, 100)
    end
    
    if type(scrollStep) == 'number' then
        self.__scrollStep = scrollStep
    end
    self.__scrollBar = GUI('ScrollBar'):New(self)
    self.__childParent = child
    self:SetScrollChild(child)
    self:EnableMouseWheel(true)
    self:SetScript('OnMouseWheel', self.OnMouseWheel)
    self:SetScript('OnSizeChanged', self.OnSizeChanged)
    self:SetScript('OnScrollRangeChanged', self.OnScrollRangeChanged)
end

function Widget:SetScrollStep(scrollStep)
    self.__scrollStep = scrollStep
end

function Widget:GetScrollStep()
    return self.__scrollStep or 40
end

function Widget:SetWheelStep(wheelStep)
    self.__wheelStep = wheelStep
end

function Widget:GetWheelStep()
    return self.__wheelStep or 1
end

function Widget:OnMouseWheel(y)
    if y > 0 then
        self.__scrollBar:Up(self:GetWheelStep())
    else
        self.__scrollBar:Down(self:GetWheelStep())
    end
end

function Widget:OnSizeChanged()
    self:OnScrollHide()
    self:OnScrollRangeChanged()
end

function Widget:OnScrollRangeChanged()
    local range = ceil(self:GetVerticalScrollRange() / self:GetScrollStep())
    local value = self.__scrollBar:GetValue()
    
    if value > range then
        value = range
    end
    
    self.__scrollBar:SetMinMaxValues(0, range)
    self.__scrollBar:SetValue(value)
end

function Widget:OnScrollValueChanged(value)
    self:SetVerticalScroll(value * self:GetScrollStep())
end

function Widget:OnScrollShow()
    local width, height = self:GetSize()
    self.__childParent:SetSize(width - 20, height)
end

function Widget:OnScrollHide()
    self.__childParent:SetSize(self:GetSize())
end

function Widget:IsInTabWidget()
    return self.__inTabWidget
end

function Widget:Enable()
    if self:IsInTabWidget() then
        local status = self:GetLabelFontString():GetStatus()
        self:GetLabelFontString():SetStatus(status == 'DISABLED' and 'NORMAL' or status)
    end
end

function Widget:Disable()
    if self:IsInTabWidget() then
        self:GetLabelFontString():SetStatus('DISABLED')
    end
end
