
local GUI = tdCore('GUI')

local InputDialog = GUI:NewModule('InputDialog', GUI('Dialog'):New())

local function DialogButtonOnClick(self)
    self:GetParent():SetResultHandle(self.handle)
    self:GetParent():Hide()
end

function InputDialog:New(parent)
    local obj = self:Bind(GUI('Dialog'):New(parent))
    if parent then
        local lineedit = GUI('LineEdit'):New(self)
        lineedit:SetPoint('BOTTOMLEFT', self.okay, 'TOPLEFT', 5, 0)
        lineedit:SetPoint('RIGHT', -10, 0)
    end
    return obj
end

function InputDialog:GetResultValue()
    return self.lineedit:GetText()
end

function InputDialog:GetShowHeight()
    return GUI('Dialog').GetShowHeight(self) + self.lineedit:GetHeight() + 5
end
