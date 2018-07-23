
local WIDGET, VERSION = 'ScrollFrame', 1

local GUI = LibStub('NetEaseGUI-2.0')
local ScrollFrame = GUI:NewClass(WIDGET, 'ScrollFrame', VERSION)
if not ScrollFrame then
    return
end

local function ScrollBarOnShow(self)
    local parent = self:GetParent()
    local child = parent:GetScrollChild()
    if not child then
        return
    end
    local width, height = parent:GetSize()
    child:SetSize(width - 20, height)
end

local function ScrollBarOnHide(self)
    local parent = self:GetParent()
    local child = parent:GetScrollChild()
    if not child then
        return
    end
    child:SetSize(parent:GetSize())
end

function ScrollFrame:Constructor()
    local ScrollBar = GUI:GetClass('ScrollBar'):New(self)
    ScrollBar:SetPoint('TOPRIGHT', 0, -16)
    ScrollBar:SetPoint('BOTTOMRIGHT', 0, 16)
    ScrollBar:SetScrollStep(40)

    ScrollBar:SetScript('OnShow', ScrollBarOnShow)
    ScrollBar:SetScript('OnHide', ScrollBarOnHide)

    self:EnableMouseWheel(true)
    self:SetScript('OnScrollRangeChanged', self.OnScrollRangeChanged)
    self:SetScript('OnMouseWheel', self.OnMouseWheel)
    self:SetScript('OnSizeChanged', self.OnSizeChanged)

    self.ScrollBar = ScrollBar
end

-- local orig_SetScrollChild = ScrollFrame.SetScrollChild
function ScrollFrame:SetScrollChild(frame)
    frame:SetParent(self)
    frame:ClearAllPoints()
    frame:SetPoint('TOPLEFT')
    self:SuperCall('SetScrollChild', frame)
    -- orig_SetScrollChild(self, frame)

    self:OnSizeChanged()
end

function ScrollFrame:OnSizeChanged()
    if self.ScrollBar:IsShown() then
        ScrollBarOnShow(self.ScrollBar)
    else
        ScrollBarOnHide(self.ScrollBar)
    end
    self:OnScrollRangeChanged()
end

function ScrollFrame:OnScrollRangeChanged()
    local range = self:GetVerticalScrollRange()
    local value = self.ScrollBar:GetValue()
    
    if value > range then
        value = range
    end
    
    self.ScrollBar:SetMinMaxValues(0, range)
    self.ScrollBar:SetValue(value)
end

function ScrollFrame:SetOffset(offset)
    self:SetVerticalScroll(offset)
end

function ScrollFrame:OnMouseWheel(y)
    self.ScrollBar:SetValue(self.ScrollBar:GetValue() - y * self.ScrollBar:GetScrollStep())
end
