
local WIDGET, VERSION = 'InputBox2', 1

local GUI = LibStub('NetEaseGUI-2.0')
local InputBox2 = GUI:NewClass(WIDGET, 'EditBox', VERSION, 'Owner')
if not InputBox2 then
    return
end

function InputBox2:Constructor()
    self:SetBackdrop{
        bgFile = [[Interface\DialogFrame\UI-DialogBox-Background]],
        edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
        insets = { left = 2, right = 2, top = 2, bottom = 2 },
        tileSize = 16, edgeSize = 16, tile=true
        }
    self:SetBackdropBorderColor(0.8, 0.8, 0.8, 0.8)
    self:SetBackdropColor(0, 0, 0, 0.8)

    self:SetFont(ChatFontNormal:GetFont(), 18)
    self:SetJustifyH('CENTER')

    self:SetAutoFocus(false)
    self:SetTextInsets(8, 8, 0, 0)

    self:SetScript('OnEscapePressed', self.ClearFocus)
    self:SetScript('OnEditFocusGained', self.HighlightText)
    self:SetScript('OnEditFocusLost', self.OnEditFocusLost)
    self:SetScript('OnEnable', self.OnEnable)
    self:SetScript('OnDisable', self.OnDisable)
end

function InputBox2:OnEditFocusLost()
    self:HighlightText(0, 0)
end

function InputBox2:OnEnable()
    self:SetTextColor(1, 1, 1)
end

function InputBox2:OnDisable()
    self:SetTextColor(0.4, 0.4, 0.4)
end
