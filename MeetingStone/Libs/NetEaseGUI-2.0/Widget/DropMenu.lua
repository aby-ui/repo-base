
local WIDGET, VERSION = 'DropMenu', 10

local GUI = LibStub('NetEaseGUI-2.0')
local DropMenu = GUI:NewClass(WIDGET, GUI:GetClass('GridView'), VERSION, 'Owner')
if not DropMenu then
    return
end

local Tooltip = GUI:GetClass('Tooltip')

DropMenu._Objects = DropMenu._Objects or {}

local function check(value, data, owner)
    if type(value) == 'function' then
        return value(data, owner)
    end
    return value
end

function DropMenu:Constructor(_, style, withOtherMenu, menuList, level)
    self.menuList = menuList or setmetatable({}, {__index = function(t, i)
        local menu = DropMenu:New(UIParent, style, withOtherMenu, self.menuList, i)
        t[i] = menu
        return menu
    end})

    level = level or 1

    if style == 'MENU' then
        self:SetPadding(15)
        self:SetBackdrop{
            bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
            edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
            edgeSize = 16, tileSize = 16, tile = true,
            insets = {left = 4, right = 4, top = 4, bottom = 4},
        }
        self:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b)
        self:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)
    else
        self:SetPadding(18, 18, 15, 15)
        self:SetBackdrop{
            bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]],
            edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]],
            insets = { left = 11, right = 12, top = 12, bottom = 9 },
            tileSize = 32, edgeSize = 32, tile = true,
        }
    end

    self:Hide()
    self:SetSize(100, 100)
    self:SetItemClass(GUI:GetClass('DropMenuItem'))
    self:SetItemHeight(16)
    self:SetAutoSize(true)
    self:SetClampedToScreen(true)
    self:SetFrameStrata('FULLSCREEN_DIALOG')
    self:EnableMouse(true)
    self:SetLevel(level)
    self:SetCallback('OnItemFormatted', self.OnItemFormatted)
    self:SetCallback('OnItemClick', self.OnItemClick)
    self:SetCallback('OnItemEnter', self.OnItemEnter)
    self:SetCallback('OnItemLeave', self.OnItemLeave)
    self:SetScript('OnHide', self.OnHide)
    self.withOtherMenu = withOtherMenu

    if level == 1 then
        tinsert(self._Objects, self)
        self.menuList[1] = self

        local AutoHide = GUI:GetClass('AutoHideController'):New(self) do
            AutoHide.IsMenuOver = function()
                for _, menu in ipairs(self.menuList) do
                    if menu:IsMouseOver() then
                        return true
                    end
                end
            end
        end

        if not withOtherMenu then
            AutoHide:SetCallback('OnUpdateCheck', function()
                return DropDownList1:IsVisible()
            end)
            self:SetScript('OnShow', self.CloseOtherMenu)
        end

        self.AutoHide = AutoHide
    else
        self:SetCallback('OnRefresh', self.OnRefresh)
        self:SetFrameLevel(self.menuList[level-1]:GetFrameLevel()+5)
    end
end

function DropMenu:Open(level, menuTable, owner, ...)
    if type(menuTable) == 'function' then
        menuTable = menuTable()
    end

    if type(menuTable) ~= 'table' then
        return self:Close()
    end

    for i = #menuTable, 1, -1 do
        local v = menuTable[i]
        if check(v.hidden, v, owner) then
            tremove(menuTable, i)
        end
    end

    level = level or 1

    for i = level + 1, #self.menuList do
        self.menuList[i]:Hide()
    end

    if not self.withOtherMenu then
        CloseDropDownMenus(1)
    end

    local maxItem, hasMaxItem
    if select('#', ...) > 0 then
        local arg1 = ...
        if type(arg1) == 'number' or type(arg1) == 'nil' then
            maxItem = tonumber(arg1)
            hasMaxItem = true
        end
    end

    local menu = self.menuList[level]
    menu.maxItem = maxItem
    menu:SetRowCount(maxItem)
    menu:SetScrollStep(max((maxItem or 0)-1, 1))
    if menu:GetItemList() ~= menuTable then
        menu:SetOffset(1)
    end
    menu:SetItemList(menuTable)
    menu:SetOwner(owner)
    menu:ClearAllPoints()
    menu:SetPoint(self:GetOpenPosition(owner, select(hasMaxItem and 2 or 1, ...)))
    menu:Show()
    menu:Refresh()
    menu:SetScale(menu:GetParent() and 1
            or GetCVarBool('useUIScale') and min(UIParent:GetScale(), tonumber(GetCVar('uiscale')))
            or UIParent:GetScale())
end

function DropMenu:Toggle(level, menuTable, owner, ...)
    level = level or 1
    local menu = self.menuList[level]
    if menu:IsShown() and menu:GetOwner() == owner then
        menu:Hide()
        return
    end
    menu:Hide()
    self:Open(level, menuTable, owner, ...)
end

function DropMenu:RefreshMenu(level)
    local menu = self.menuList[level or 1]
    if menu then
        menu:Refresh()
    end
end

function DropMenu:Close(level)
    level = level or 1
    self.menuList[level]:Hide()
end

function DropMenu:CloseOtherMenu()
    for _, object in ipairs(self._Objects) do
        if object ~= self then
            object:Close(1)
        end
    end
end

function DropMenu:OnRefresh()
    local prevMenu = self.menuList[self:GetLevel() - 1]
    local anchor = select(2, self:GetPoint())

    self:ClearAllPoints()

    if self:GetWidth() > GetScreenWidth() - prevMenu:GetRight() then
        self:SetPoint('TOPRIGHT', anchor, 'TOPLEFT', 0, 10)
    else
        self:SetPoint('TOPLEFT', anchor, 'TOPRIGHT', 0, 10)
    end
end

function DropMenu:OnItemClick(button, data)
    if data.notClickable then
        return
    end
    if not data.keepShownOnClick then
        self:Hide()
    end

    local owner = self:GetOwner()
    if type(data.func) == 'function' then
        if data.confirm then
            if data.confirmInput then
                GUI:CallInputDialog(data.confirm, data.func, data.confirmKey, data.confirmDefault, data.confirmMaxBytes, data.confirmInput, owner, data)
            else
                GUI:CallMessageDialog(data.confirm, data.func, data.confirmKey, owner, data)
            end
        else
            data.func(owner, data, self, button:GetChecked())
        end
    end
    if owner then
        if type(owner.SetItem) == 'function' then
            owner:SetItem(data)
        end
    end

    if data.keepShownOnClick then
        self:Refresh()
    end
    if data.refreshParentOnClick and self:GetLevel() > 1 then
        self:RefreshMenu(self:GetLevel() - 1)
    end
end

function DropMenu:OnItemFormatted(button, data)
    if data.isSeparator then
        button:Disable()
        button:SetText()
        button:SetCheckState()
        button:SetHasArrow()
        button:SetSeparator(true)
    else
        button:SetText(check(data.text, self:GetOwner()))
        button:SetCheckState(data.checkable, data.isNotRadio, check(data.checked, data, self:GetOwner()))
        button:SetHasArrow(data.hasArrow)
        button:SetSeparator()
        button:SetFontObject(check(data.fontObject, data, self:GetOwner()))

        if check(data.disabled, data, self:GetOwner()) then
            button:Disable()
            button:SetDisabledFontObject('GameFontDisableSmallLeft')
        elseif data.isTitle then
            button:Disable()
            button:SetDisabledFontObject('GameFontNormalSmallLeft')
        else
            button:Enable()
        end
    end
    button:SetWidth(button:GetAutoWidth())
end

function DropMenu:OnItemEnter(button, data)
    if not data.hasArrow then
        self:Close(self:GetLevel() + 1)
    else
        self:Open(self:GetLevel() + 1,
            data.menuTable,
            self:GetOwner(), self.maxItem, 'TOPLEFT', button, 'TOPRIGHT', 0, 10)
    end

    local tip = Tooltip:GetGlobalTooltip()

    if (data.tooltipTitle or data.tooltipText or data.tooltipMore) and (data.tooltipWhileDisabled or button:IsEnabled()) then
        if data.tooltipOnButton then
            tip:SetOwner(button, button:GetLeft() < GetScreenWidth() / 2 and 'ANCHOR_RIGHT' or 'ANCHOR_LEFT')
        else
            GameTooltip_SetDefaultAnchor(tip, button)
        end
        if data.tooltipTitle then
            tip:SetText(data.tooltipTitle, 1, 1, 1)
        end
        if data.tooltipText then
            tip:AddLine(data.tooltipText, nil, nil, nil, true)
        end
        if type(data.tooltipMore) == 'function' then
            data.tooltipMore(tip, data)
        end
        tip:Show()
    end
end

function DropMenu:OnItemLeave()
    Tooltip:GetGlobalTooltip():Hide()
end

function DropMenu:OnHide()
    self:Close(self:GetLevel() + 1)
end

function DropMenu:GetOpenPosition(owner, point, ...)
    if point == 'cursor' then
        local x, y = GetCursorPosition()
        local uiScale = owner:GetEffectiveScale()

        x = x / uiScale - owner:GetLeft() + 20
        y = y / uiScale - owner:GetTop() - 2

        return 'TOPLEFT', owner, 'TOPLEFT', x, y
    elseif point then
        return point, ...
    elseif owner:GetBottom() >= GetScreenHeight() - owner:GetTop() then
        return 'TOPLEFT', owner, 'BOTTOMLEFT'
    else
        return 'BOTTOMLEFT', owner, 'TOPLEFT'
    end
end

function DropMenu:SetLevel(level)
    self.level = level
end

function DropMenu:GetLevel()
    return self.level
end
