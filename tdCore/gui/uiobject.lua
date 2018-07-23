
local getmetatable, select, type, unpack = getmetatable, select, type, unpack
local tdCore = tdCore

local GUI = tdCore('GUI')
local UIObject = {}

function UIObject:GetWidgetType()
    return self:GetClassName()
end

function UIObject:IsWidgetType(widgetType)
    local obj = self
    while true do
        local wType = GUI:GetWidgetType(obj)
        if not wType then
            return false
        elseif wType == widgetType then
            return true
        else
            obj = getmetatable(obj)
        end
    end
end

function UIObject:GetLabelFontString()
    if not self.__labelFontString then
        self.__labelFontString = self:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
    end
    return self.__labelFontString
end

function UIObject:GetValueFontString()
    if not self.__valueFontString then
        self.__valueFontString = self:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmall')
    end
    return self.__valueFontString
end

function UIObject:SetLabelFontString(fontString)
    self.__labelFontString = fontString
end

function UIObject:SetValueFontString(fontString)
    self.__valueFontString = fontString
end

function UIObject:SetLabelText(text)
    self:GetLabelFontString():SetText(text)
end

function UIObject:SetValueText(text)
    self:GetValueFontString():SetText(text)
end

function UIObject:GetLabelText()
    return self:GetLabelFontString():GetText()
end

function UIObject:GetValueText()
    return self:GetValueFontString():GetText()
end

-- HORIZONTAL or VERTICAL
function UIObject:SetHorizontalArgs(width, xOffset, yOffsetTop, yOffsetBottom)
    self.__ho_width = width
    self.__ho_xOffset = xOffset
    self.__ho_yOffsetTop = yOffsetTop
    self.__ho_yOffsetBottom = yOffsetBottom
end

function UIObject:GetHorizontalArgs()
    return  self.__ho_width,
            self.__ho_xOffset,
            self.__ho_yOffsetTop,
            self.__ho_yOffsetBottom
end

function UIObject:SetVerticalArgs(height, yOffset, xOffsetLeft, xOffsetRight)
    self.__vo_height = height
    self.__vo_yOffset = yOffset
    self.__vo_xOffsetLeft = xOffsetLeft
    self.__vo_xOffsetRight = xOffsetRight
end

function UIObject:GetVerticalArgs()
    return  self.__vo_height,
            self.__vo_yOffset,
            self.__vo_xOffsetLeft,
            self.__vo_xOffsetRight
end

function UIObject:Into(...)
    local parent = self:GetParent()
    if parent and parent.AddWidget then
        parent:AddWidget(self, ...)
    end
end

function UIObject:SetNormalColor(r, g, b, a)
    self.__rNormal = r
    self.__gNormal = g
    self.__bNormal = b
    self.__aNormal = a
end

function UIObject:GetNormalColor()
    return  self.__rNormal or 0.7,
            self.__gNormal or 0.7,
            self.__bNormal or 0.7,
            self.__aNormal or 1
end

function UIObject:SetDisabledColor(r, g, b, a)
    self.__rDisable = r
    self.__gDisable = g
    self.__bDisable = b
    self.__aDisable = a
end

function UIObject:GetDisabledColor()
    return  self.__rDisable or 0.4,
            self.__gDisable or 0.4,
            self.__bDisable or 0.4,
            self.__aDisable or 1
end

function UIObject:OnEnable()
    if self.__labelFontString then
        self.__labelFontString:SetFontObject('GameFontNormalSmall')
    end
    if self.__valueFontString then
        self.__valueFontString:SetFontObject('GameFontHighlightSmall')
    end
    self:SetBackdropBorderColor(self:GetNormalColor())
end

function UIObject:OnDisable()
    if self.__labelFontString then
        self.__labelFontString:SetFontObject('GameFontDisableSmall')
    end
    if self.__valueFontString then
        self.__valueFontString:SetFontObject('GameFontDisableSmall')
    end
    self:SetBackdropBorderColor(self:GetDisabledColor())
end

local function OnEnter(self)
    if not (self:GetHandle('OnNote') or self.__note) then
        return
    end
    
    GameTooltip:SetOwner(self, self:GetRight() > (GetScreenWidth() / 2) and 'ANCHOR_LEFT' or 'ANCHOR_RIGHT')
    
    if self:GetHandle('OnNote') then
        self:RunHandle('OnNote')
    else
        if type(self.__note) == 'string' then
            GameTooltip:SetText(self.__note)
        elseif type(self.__note) == 'table' then
            local hasText
            for i, t in ipairs(self.__note) do
                if type(t) == 'string' then
                    if hasText then
                        GameTooltip:AddLine(t, 1, 1, 1)
                    else
                        GameTooltip:SetText(t)
                        hasText = true
                    end
                end
            end
        end
    end
    GameTooltip:Show()
end

local function OnLeave(self)
    GameTooltip:Hide()
end

function UIObject:SetNote(note)
    self.__note = note
    self:SetAllowEnter(true)
end

function UIObject:SetAllowEnter(enable)
    if enable then
        self:SetScript('OnEnter', OnEnter)
        self:SetScript('OnLeave', OnLeave)
    else
        self:SetScript('OnEnter', nil)
        self:SetScript('OnLeave', nil)
    end
end

function UIObject:SetPoints(...)
    for i = 1, select('#', ...) do
        self:SetPoint(unpack((select(i, ...))))
    end
end

function UIObject:ToggleMenu(menu, ...)
    GUI:ToggleMenu(self, menu, ...)
end

function UIObject:ShowDialog(name, text, ...)
    GUI:ShowDialog(self, name, text, ...)
end

tdCore('GUI'):RegisterEmbed('UIObject', UIObject)
