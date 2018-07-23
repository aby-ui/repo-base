
local ipairs, tinsert, type = ipairs, table.insert, type

local GUI = tdCore('GUI')

local ICON_SIZE, DIALOG_PADDING = 64, 10
local BUTTON_WIDTH, BUTTON_HEIGHT = 100, 22

local Dialog = GUI:NewModule('Dialog', CreateFrame('Frame'), 'UIObject', 'Update')
Dialog:RegisterHandle('OnAccept', 'OnCancel')

local function DialogButtonOnClick(self)
    self:GetParent():SetResultHandle(self.handle)
    self:GetParent():Hide()
end

local dialogs = {}

function Dialog:New(parent)
    local obj = self:Bind(CreateFrame('Frame', nil, parent))
    
    if parent then
        local label = obj:GetLabelFontString()
        label:ClearAllPoints()
        label:SetPoint('TOPLEFT', DIALOG_PADDING, -DIALOG_PADDING)
        label:SetPoint('TOPRIGHT', -ICON_SIZE-DIALOG_PADDING, -DIALOG_PADDING)
        label:SetJustifyH('LEFT')
        label:SetJustifyV('TOP')
        label:SetHeight(100)
        
        local icon = obj:CreateTexture(nil, 'OVERLAY')
        icon:SetPoint('RIGHT', 0, 0)
        
        local accept = GUI('Button'):New(obj)
        accept:SetText(OKAY)
        accept:SetPoint('BOTTOMLEFT', DIALOG_PADDING, DIALOG_PADDING)
        accept:SetSize(BUTTON_WIDTH, BUTTON_HEIGHT)
        accept:SetScript('OnClick', DialogButtonOnClick)
        accept.handle = 'OnAccept'
        
        local cancel = GUI('Button'):New(obj)
        cancel:SetText(CANCEL)
        cancel:SetPoint('LEFT', accept, 'RIGHT', 5, 0)
        cancel:SetSize(BUTTON_WIDTH, BUTTON_HEIGHT)
        cancel:SetScript('OnClick', DialogButtonOnClick)
        cancel.handle = 'OnCancel'
        
        obj.icon = icon
        obj.accept = accept
        obj.cancel = cancel
        
        obj:SetBackdrop{
            bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
            edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
            edgeSize = 14, tileSize = 20, tile = true,
            insets = {left = 2, right = 2, top = 2, bottom = 2},
        }
        obj:SetBackdropColor(0, 0, 0, 0.8)
        obj:SetBackdropBorderColor(1, 1, 1, 1)
        
        obj:Hide()
        obj:SetWidth(300)
        obj:SetFrameStrata('DIALOG')
        obj:SetScript('OnShow', self.OnShow)
        obj:SetScript('OnHide', self.OnHide)
        
        tinsert(dialogs, obj)
    end
    
    return obj
end

function Dialog:RefreshAll()
    local prevDlg
    for _, dlg in ipairs(dialogs) do
        if dlg:IsVisible() then
            dlg:ClearAllPoints()
            if prevDlg then
                dlg:SetPoint('TOP', prevDlg, 'BOTTOM', 0, -5)
            else
                dlg:SetPoint('CENTER')
            end
            prevDlg = dlg
        end
    end
end

function Dialog:OnHide()
    PlaySound163("igMainMenuClose")
    self:RunHandle(self:GetResultHandle(), self:GetResultValue())
    self:SetHandle('OnAccept', nil)
    self:SetHandle('OnCancel', nil)
    self:RefreshAll()
    self:SetCaller(nil)
end

function Dialog:OnShow()
    PlaySound163("igMainMenuOpen")
    self:SetHeight(self:GetShowHeight())
    self:RefreshAll()
end

function Dialog:GetShowHeight()
    local label = self:GetLabelFontString()
    
    return ceil(label:GetStringWidth() / (self:GetWidth() - DIALOG_PADDING * 2 - ICON_SIZE) + 0.5) *
            label:GetStringHeight() + DIALOG_PADDING * 2 + BUTTON_HEIGHT
end

function Dialog:SetIcon(icon)
    self.icon:SetTexture(type(icon) == 'string' and icon or GUI.DialogIcon.Default)
end

function Dialog:SetButton(isOneButton)
    if isOneButton then
        self.cancel:Hide()
    else
        self.cancel:Show()
    end
end

function Dialog:SetResultHandle(handle)
    self.__resultHandle = handle
end

function Dialog:GetResultHandle()
    return self.__resultHandle or 'OnCancel'
end

function Dialog:GetIdleDialog()
    for _, dlg in ipairs(dialogs) do
        if not dlg:IsVisible() and dlg:GetWidgetType() == self:GetClassName() then
            return dlg
        end
    end
    return self:New(UIParent)
end

function Dialog:SetCaller(caller)
    self.__caller = caller
end

function Dialog:GetCaller()
    return self.__caller
end

function Dialog:ShowDialog(text, ...)
    local icon, OnAccept, OnCancel = ...
    if type(icon) == 'function' then
        icon, OnAccept, OnCancel = nil, ...
    end
    
    local dlg = self:GetIdleDialog()
    
    dlg:SetLabelText(text)
    dlg:SetIcon(icon)
    dlg:SetButton(not OnAccept and not OnCancel)
    dlg:SetHandle('OnAccept', OnAccept)
    dlg:SetHandle('OnCancel', OnCancel)
    dlg:Show()
    
    return dlg
end

function Dialog:GetResultValue()
    return
end

function Dialog:GetDialog(name, caller)
    for i, dlg in ipairs(dialogs) do
        if dlg:IsVisible() and dlg:GetWidgetType() == name and dlg:GetCaller() == caller then
            return dlg
        end
    end
end

function Dialog:GetDialogClass(name)
    local class = GUI(name)
    if class:IsWidgetType('Dialog') then
        return class
    end
end

function GUI:ShowDialog(caller, name, text, ...)
    if Dialog:GetDialog(name, caller) then
        return
    end
    
    local class = Dialog:GetDialogClass(name)
    if class then
        class:ShowDialog(text, ...):SetCaller(caller)
    end
end
