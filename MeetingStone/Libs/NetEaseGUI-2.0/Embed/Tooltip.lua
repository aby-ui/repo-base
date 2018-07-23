
local GUI = LibStub('NetEaseGUI-2.0')
local Tooltip = GUI:NewEmbed('Tooltip', 1)
if not Tooltip then
    return
end

local Class = LibStub('LibClass-2.0')

local _Tooltips do
    Tooltip._Tooltips = Tooltip._Tooltips or {}
    _Tooltips = Tooltip._Tooltips
end

local function OnEnter(self)
    if not _Tooltips[self].text then
        return
    end
    if self.tooltipAnchor then
        GameTooltip:SetOwner(self, self.tooltipAnchor)
    else
        GameTooltip_SetDefaultAnchor(GameTooltip, self)
    end
    GameTooltip:SetText(_Tooltips[self].text)
    for i, v in ipairs(_Tooltips[self]) do
        GameTooltip:AddLine(v, 1, 1, 1, true)
    end
    GameTooltip:Show()
end

local function OnLeave(self)
    GameTooltip:Hide()
end

function Tooltip:SetTooltip(text, ...)
    if not (Class:IsUIClass(self) or Class:IsWidget(self)) then
        error([[bad argument #self to 'SetTooltip' (widget/class expected)]], 2)
    end

    if not _Tooltips[self] then
        self:HookScript('OnEnter', OnEnter)
        self:HookScript('OnLeave', OnLeave)
    end

    _Tooltips[self] = {...}
    _Tooltips[self].text = text
end

function Tooltip:SetTooltipAnchor(anchor)
    self.tooltipAnchor = anchor
end
