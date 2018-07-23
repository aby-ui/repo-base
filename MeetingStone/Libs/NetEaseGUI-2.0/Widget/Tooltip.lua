
local WIDGET, VERSION = 'Tooltip', 5

local GUI = LibStub('NetEaseGUI-2.0')
local Tooltip = GUI:NewClass(WIDGET, 'GameTooltip.GameTooltipTemplate', VERSION)
if not Tooltip then
    return
end

Tooltip._Meta.__uiname = 'NetEaseGUI20_' .. WIDGET .. VERSION

local function checkcolor(r, g, b)
    if not r and not b and not g then
        return NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b
    else
        return r or 0, g or 0, b or 0
    end
end

function Tooltip:Constructor()
    self.separators = {}
    self.numSeparators = 0
    self:SetFrameStrata('TOOLTIP')
end

function Tooltip:AddHeader(text, r, g, b, wrap)
    self:SuperCall('AddLine', text, nil, nil, nil, wrap)

    local line = self:NumLines()
    local textLeft = self:GetFontStrings(line)

    if line > 1 then
        local prevTextLeft = self:GetFontStrings(line - 1)
        textLeft:SetFontObject('GameTooltipHeaderText')
        textLeft:SetPoint('TOPLEFT', prevTextLeft, 'BOTTOMLEFT', 0, -10)

        local separator = self:GetSeparator()
        separator:Show()
        separator:SetPoint('TOP', prevTextLeft, 'BOTTOM', 0, -3)

        self.numHeaders = self.numHeaders + 1
    end

    textLeft:SetTextColor(checkcolor(r, g, b))
end

function Tooltip:AddSepatator()
    if self:NumLines() == 0 then
        return
    end

    self:SuperCall('AddLine', ' ')

    local separator = self:GetSeparator()
    separator:Show()
    separator:SetPoint('TOP', self:GetFontStrings(self:NumLines()), 'TOP', 0, -5)
end

function Tooltip:AddLine(text, r, g, b, wrap)
    self:SuperCall('AddLine', text, nil, nil, nil, wrap)
    local textLeft = self:GetFontStrings(self:NumLines())
    textLeft:SetFontObject('GameTooltipText')
    textLeft:SetTextColor(checkcolor(r, g, b))
end

function Tooltip:AddDoubleLine(textL, textR, rL, gL, bL, rR, gR, bR)
    self:SuperCall('AddDoubleLine', textL, textR)

    local numLines = self:NumLines()
    local textLeft, textRight = self:GetFontStrings(numLines)
    textLeft:SetFontObject('GameTooltipText')
    textLeft:SetTextColor(checkcolor(rL, gL, bL))
    textRight:SetFontObject('GameTooltipText')
    textRight:SetTextColor(checkcolor(rR, gR, bR))
end

function Tooltip:GetFontStrings(line)
    local name = self:GetName()

    return _G[name .. 'TextLeft' .. line], _G[name .. 'TextRight' .. line]
end

function Tooltip:SetOwner(...)
    self:SuperCall('SetOwner', ...)

    for i, separator in ipairs(self.separators) do
        separator:Hide()
    end
    self.numSeparators = 0
    self.numHeaders = 0
end

function Tooltip:Show()
    self:SuperCall('Show')
    self:SetHeight(self:GetHeight() + self.numHeaders*8)
end

function Tooltip:GetSeparator()
    self.numSeparators = self.numSeparators + 1
    return self.separators[self.numSeparators] or self:CreateSeparator()
end

function Tooltip:CreateSeparator()
    local separator = self:CreateTexture(nil, 'OVERLAY')
    separator:SetColorTexture(0.3, 0.3, 0.3, 0.7)
    separator:SetHeight(2)
    separator:SetPoint('LEFT', 5, 0)
    separator:SetPoint('RIGHT', -5, 0)
    tinsert(self.separators, separator)
    return separator
end

if Tooltip.GlobalTooltip then
    Tooltip.GlobalTooltip:Hide()
    Tooltip.GlobalTooltip = nil
end

function Tooltip:GetGlobalTooltip()
    if not Tooltip.GlobalTooltip then
        Tooltip.GlobalTooltip = Tooltip:New(UIParent)
    end
    return Tooltip.GlobalTooltip
end
