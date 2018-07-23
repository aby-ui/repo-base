
local WIDGET, VERSION = 'TitleWidget', 3

local GUI = LibStub('NetEaseGUI-2.0')
local TitleWidget = GUI:NewClass(WIDGET, 'Frame', VERSION)
if not TitleWidget then
    return
end

function TitleWidget:Constructor()
    local Bg = self:CreateTexture(nil, 'BACKGROUND')
    Bg:SetAllPoints(self)
    Bg:SetColorTexture(0.95, 0.95, 1, 0.09)

    local Text = self:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
    Text:SetPoint('TOPLEFT', 5, -5)

    self.Text = Text
    self.Bg = Bg
end

function TitleWidget:SetText(text)
    self.Text:SetText(text)
end

function TitleWidget:GetText()
    return self.Text:GetText()
end

function TitleWidget:SetObject(object, left, right, top, bottom)
    left = left or 5
    right = right or left or 5
    top = top or left or 5
    bottom = top or left or 5

    object:SetParent(self)
    object:ClearAllPoints()
    object:SetPoint('TOPLEFT', self, 'TOPLEFT', left, -top-15)
    object:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', -right, bottom)
    object:Show()

    self.Object = object
    return object
end

function TitleWidget:GetObject()
    return self.Object
end

function TitleWidget:SetBgShown(enable)
    self.Bg:SetShown(enable)
end
