
local GUI = LibStub('NetEaseGUI-2.0')

local L = LibStub('AceLocale-3.0'):GetLocale('NetEaseGUI-2.0')

StaticPopupDialogs['NECLOUD_CONFIRM_DIALOG'] = {}
StaticPopupDialogs['NETEASE_COPY_URL'] = {
    text = L.DialogCopyUrl,
    button1 = OKAY,
    timeout = 0,
    exclusive = 1,
    whileDead = 1,
    hideOnEscape = 1,
    hasEditBox = true,
    editBoxWidth = 260,
    EditBoxOnTextChanged = function(editBox, url)
        if editBox:GetText() ~= url then
            editBox:SetMaxBytes(nil)
            editBox:SetMaxLetters(nil)
            editBox:SetText(url)
            editBox:HighlightText()
            editBox:SetCursorPosition(0)
            editBox:SetFocus()
        end
    end
}

function GUI:CallWarningDialog(text, showAlert, key, callback, ...)
    local t = wipe(StaticPopupDialogs['NECLOUD_CONFIRM_DIALOG'])

    t.text = text
    t.whileDead = 1
    t.hideOnEscape = 1
    t.button1 = OKAY
    t.showAlert = showAlert

    if type(callback) == 'function' then
        local args = {...}
        local argCount = select('#', ...)
        t.OnAccept = function()
            callback(unpack(args, 1, argCount))
        end
    end

    return StaticPopup_Show('NECLOUD_CONFIRM_DIALOG', nil, nil, key)
end

function GUI:CallMessageDialog(text, callback, key, ...)
    local t = wipe(StaticPopupDialogs['NECLOUD_CONFIRM_DIALOG'])

    t.text = text
    t.whileDead = 1
    t.hideOnEscape = 1
    t.button1 = OKAY
    t.button2 = CANCEL

    if type(callback) == 'function' then
        local args = {...}
        local argCount = select('#', ...)
        t.OnAccept = function()
            callback(true, nil, unpack(args, 1, argCount))
        end
        t.OnCancel = function()
            callback(false, nil, unpack(args, 1, argCount))
        end
    end

    return StaticPopup_Show('NECLOUD_CONFIRM_DIALOG', nil, nil, key)
end

function GUI:CallInputDialog(text, callback, key, default, maxBytes, width, ...)
    local t = wipe(StaticPopupDialogs['NECLOUD_CONFIRM_DIALOG'])

    t.text = text
    t.whileDead = 1
    t.hideOnEscape = 1
    t.button1 = OKAY
    t.button2 = CANCEL
    t.hasEditBox = true
    t.maxLetters = maxBytes or 32
    t.maxBytes = maxBytes or 255
    t.timeout = 60
    t.editBoxWidth = width

    if type(callback) == 'function' then
        local args = {...}
        local argCount = select('#', ...)

        t.OnAccept = function(self)
            callback(true, self.editBox:GetText(), unpack(args, 1, argCount))
        end
        t.EditBoxOnEnterPressed = function(self)
            callback(true, self:GetText(), unpack(args, 1, argCount))
            self:GetParent():Hide()
        end
        t.EditBoxOnEscapePressed = function(self)
            callback(false, nil, unpack(args, 1, argCount))
            self:GetParent():Hide()
        end
        t.OnCancel = function()
            callback(false, nil, unpack(args, 1, argCount))
        end
    end

    local dialog = StaticPopup_Show('NECLOUD_CONFIRM_DIALOG', nil, nil, key)
    if dialog and default and default ~= '' then
        dialog.editBox:SetText(default)
        dialog.editBox:HighlightText(0, #default)
    end
    return dialog
end

function GUI:CallUrlDialog(url, title, showAlert)
    local info = StaticPopupDialogs['NETEASE_COPY_URL']

    info.text = title or L.DialogCopyUrl
    info.showAlert = showAlert or nil

    StaticPopup_Show('NETEASE_COPY_URL', nil, nil, url)
end

function GUI:IsDialogVisible(key)
    for i = 1, STATICPOPUP_NUMDIALOGS, 1 do
        local frame = _G['StaticPopup'..i]
        if frame:IsShown() and frame.which == 'NECLOUD_CONFIRM_DIALOG' and frame.data == key then
            return frame
        end
    end
    return nil
end

function GUI:CloseDialog(key)
    StaticPopup_Hide('NECLOUD_CONFIRM_DIALOG', key)
end
