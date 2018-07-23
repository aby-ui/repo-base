
local WIDGET, VERSION = 'ScrollSummaryHtml', 4

local GUI = LibStub('NetEaseGUI-2.0')
local ScrollSummaryHtml = GUI:NewClass(WIDGET, GUI:GetClass('ScrollFrame'), VERSION)
if not ScrollSummaryHtml then
    return
end

function ScrollSummaryHtml:Constructor()
    local SummaryHtml = GUI:GetClass('SummaryHtml'):New(self) do
        self:SetScrollChild(SummaryHtml)
    end

    self.SummaryHtml = SummaryHtml

    self:SetScript('OnShow', function()
        SummaryHtml:SetText(SummaryHtml:GetText())
    end)
end

local apis = {
    'GetContentHeight',
    'GetFont',
    'GetFontObject',
    'GetHyperlinkFormat',
    'GetHyperlinksEnabled',
    'GetIndentedWordWrap',
    'GetJustifyH',
    'GetJustifyV',
    'GetShadowColor',
    'GetShadowOffset',
    'GetSpacing',
    'GetText',
    'GetTextColor',
    'SetFont',
    'SetFontObject',
    'SetHyperlinkFormat',
    'SetHyperlinksEnabled',
    'SetIndentedWordWrap',
    'SetJustifyH',
    'SetJustifyV',
    'SetShadowColor',
    'SetShadowOffset',
    'SetSpacing',
    'SetText',
    'SetTextColor',
    'SetCallback',
}

for i, v in ipairs(apis) do
    ScrollSummaryHtml[v] = function(self, ...)
        self.SummaryHtml[v](self.SummaryHtml, ...)
    end
end