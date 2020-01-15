local _, MySlot = ...

local L = MySlot.L
local RegEvent = MySlot.regevent


local f = CreateFrame("Frame", "MYSLOT_ReportFrame", UIParent)
f:SetWidth(650)
f:SetHeight(600)
f:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 32,
    edgeSize = 32,
    insets = {left = 8, right = 8, top = 10, bottom = 10}
})

f:SetBackdropColor(0, 0, 0)
f:SetPoint("CENTER", 0, 0)
f:SetToplevel(true)
f:EnableMouse(true)
f:SetMovable(true)
f:RegisterForDrag("LeftButton")
f:SetScript("OnDragStart", f.StartMoving)
f:SetScript("OnDragStop", f.StopMovingOrSizing)
f:Hide()

MySlot.MainFrame = f

-- title
do
    local t = f:CreateTexture(nil, "ARTWORK")
    t:SetTexture("Interface/DialogFrame/UI-DialogBox-Header")
    t:SetWidth(256)
    t:SetHeight(64)
    t:SetPoint("TOP", f, 0, 12)
    f.texture = t
end
    
do
    local t = f:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    t:SetText(L["Myslot"])
    t:SetPoint("TOP", f.texture, 0, -14)
end

local exportEditbox

-- close
do
    local b = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
    b:SetWidth(100)
    b:SetHeight(25)
    b:SetPoint("BOTTOMRIGHT", -40, 15)
    b:SetText(L["Close"])
    b:SetScript("OnClick", function() f:Hide() end)
end

local forceImportCheckbox
do
    local b = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
    b.text = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    b.text:SetPoint("LEFT", b, "RIGHT", 0, 1)
    b:SetPoint("BOTTOMLEFT", 340, 13)
    b.text:SetText(L["Force Import"])
    b:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP");
        GameTooltip:SetText(L["Skip CRC32, version and any other validation before importing. May cause unknown behavior"], nil, nil, nil, nil, true);
        GameTooltip:Show();
    end)
    b:SetScript("OnLeave", GameTooltip_Hide)
    forceImportCheckbox = b
end

local ignoreActionCheckbox
local ignoreBindingCheckbox
local ignoreMacroCheckbox

do
    do
        local b = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
        b.text = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        b.text:SetPoint("LEFT", b, "RIGHT", 0, 1)
        b:SetPoint("BOTTOMLEFT", 38, 95)
        b.text:SetText(L["Ignore Import/Export Action"])
        -- b:SetScript("OnEnter", function(self)
        --     GameTooltip:SetOwner(self, "ANCHOR_TOP");
        --     GameTooltip:SetText(L[""], nil, nil, nil, nil, true);
        --     GameTooltip:Show();
        -- end)
        -- b:SetScript("OnLeave", GameTooltip_Hide)
        ignoreActionCheckbox = b
    end

    do
        local b = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
        b.text = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        b.text:SetPoint("LEFT", b, "RIGHT", 0, 1)
        b:SetPoint("BOTTOMLEFT", 38, 70)
        b.text:SetText(L["Ignore Import/Export Key Binding"])
        -- b:SetScript("OnEnter", function(self)
        --     GameTooltip:SetOwner(self, "ANCHOR_TOP");
        --     GameTooltip:SetText(L[""], nil, nil, nil, nil, true);
        --     GameTooltip:Show();
        -- end)
        -- b:SetScript("OnLeave", GameTooltip_Hide)
        ignoreBindingCheckbox = b
    end

    do
        local b = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
        b.text = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        b.text:SetPoint("LEFT", b, "RIGHT", 0, 1)
        b:SetPoint("BOTTOMLEFT", 38, 45)
        b.text:SetText(L["Ignore Import/Export Macro"])
        -- b:SetScript("OnEnter", function(self)
        --     GameTooltip:SetOwner(self, "ANCHOR_TOP");
        --     GameTooltip:SetText(L[""], nil, nil, nil, nil, true);
        --     GameTooltip:Show();
        -- end)
        -- b:SetScript("OnLeave", GameTooltip_Hide)
        ignoreMacroCheckbox = b
    end
end

-- import
do
    local b = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
    b:SetWidth(125)
    b:SetHeight(25)
    b:SetPoint("BOTTOMLEFT", 200, 15)
    b:SetText(L["Import"])
    b:SetScript("OnClick", function()
        local msg = MySlot:Import(exportEditbox:GetText(), {
            force = forceImportCheckbox:GetChecked(),
        })

        if not msg then
            return
        end

        StaticPopupDialogs["MYSLOT_MSGBOX"].OnAccept = function()
            StaticPopup_Hide("MYSLOT_MSGBOX")
            MySlot:RecoverData(msg, {
                ignoreAction = ignoreActionCheckbox:GetChecked(),
                ignoreBinding = ignoreBindingCheckbox:GetChecked(),
                ignoreMacro = ignoreMacroCheckbox:GetChecked(),
            })
        end
        StaticPopup_Show("MYSLOT_MSGBOX")
    end)
end

local infolabel

-- export
do
    local b = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
    b:SetWidth(125)
    b:SetHeight(25)
    b:SetPoint("BOTTOMLEFT", 40, 15)
    b:SetText(L["Export"])
    b:SetScript("OnClick", function()
        local s = MySlot:Export({
            ignoreAction = ignoreActionCheckbox:GetChecked(),
            ignoreBinding = ignoreBindingCheckbox:GetChecked(),
            ignoreMacro = ignoreMacroCheckbox:GetChecked(),
        })
        exportEditbox:SetText(s)
        infolabel.ShowUnsaved()
    end)
end

RegEvent("ADDON_LOADED", function()
    do
        local t = CreateFrame("Frame", nil, f)
        t:SetWidth(600)
        t:SetHeight(400)
        t:SetPoint("TOPLEFT", f, 25, -75)
        t:SetBackdrop({ 
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            tile = true,
            tileEdge = true,
            tileSize = 16,
            edgeSize = 16,
            insets = { left = -2, right = -2, top = -2, bottom = -2 },    
        })
        t:SetBackdropColor(0, 0, 0, 0)
    
        local s = CreateFrame("ScrollFrame", "MYSLOT_ScrollFrame", t, "UIPanelScrollFrameTemplate")
        s:SetWidth(560)
        s:SetHeight(375)
        s:SetPoint("TOPLEFT", 10, -10)


        local edit = CreateFrame("EditBox", "MYSLOT_ReportFrame_EditBox", s)
        s.cursorOffset = 0
        edit:SetWidth(550)
        s:SetScrollChild(edit)
        edit:SetAutoFocus(false)
        edit:EnableMouse(true)
        edit:SetMaxLetters(99999999)
        edit:SetMultiLine(true)
        edit:SetFontObject(GameTooltipText)
        edit:SetScript("OnEscapePressed", edit.ClearFocus)
        edit:SetScript("OnTextSet", edit.HighlightText)
        edit:SetScript("OnMouseUp", edit.HighlightText)

        -- edit:SetScript("OnTextChanged", function()
        --     infolabel:SetText(L["Unsaved"])
        -- end)
        edit:SetScript("OnTextSet", function()
            edit.savedtxt = edit:GetText()
            infolabel:SetText("")
        end)
        edit:SetScript("OnChar", function(self, c)
            infolabel.ShowUnsaved()
        end)

        t:SetScript("OnMouseDown", function()
            edit:SetFocus()
        end)

        exportEditbox = edit
    end    


    do
        local t = CreateFrame("Frame", nil, f, "UIDropDownMenuTemplate")
        t:SetPoint("TOPLEFT", f, 5, -45)
        UIDropDownMenu_SetWidth(t, 200)
        do
            local tt = t:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            tt:SetPoint("BOTTOMLEFT", t, "TOPLEFT", 20, 0)

            tt.ShowUnsaved = function()
                tt:SetText(YELLOW_FONT_COLOR:WrapTextInColorCode(L["Unsaved"]))
            end
            
            infolabel = tt
        end

        if not MyslotExports then
            MyslotExports = {}
        end
        if not MyslotExports["exports"] then
            MyslotExports["exports"] = {}
        end
        local exports = MyslotExports["exports"]

        local onclick = function(self)
            local idx = self.value
            UIDropDownMenu_SetSelectedValue(t, idx)

            local n = exports[idx] and exports[idx].name or ""
            UIDropDownMenu_SetText(t, n)

            local v = exports[idx] and exports[idx].value or ""
            exportEditbox:SetText(v)
        end

        local create = function(name)
            local txt = {
                name = name
            }
            table.insert(exports, txt)

            local info = UIDropDownMenu_CreateInfo()
            info.text = txt.name
            info.value = #exports
            info.func = onclick
            UIDropDownMenu_AddButton(info)
        end

        local save = function(force)
            local c = UIDropDownMenu_GetSelectedValue(t)
            local v = exportEditbox:GetText()
            if not force and v == "" then
                return
            end
            if (not c) or (not exports[c]) then
                local n = date()
                create(n)
                UIDropDownMenu_SetSelectedValue(t, #exports)
                UIDropDownMenu_SetText(t, n)
                c = #exports
            end

            exports[c].value = v
            infolabel:SetText("")
        end
        -- exportEditbox:SetScript("OnTextChanged", function() save(false) end)

        UIDropDownMenu_Initialize(t, function()
            for i, txt in pairs(exports) do
                -- print(txt.name)
                local info = UIDropDownMenu_CreateInfo()
                info.text = txt.name
                info.value = i
                info.func = onclick
                UIDropDownMenu_AddButton(info)
            end
        end)

        local popctx = {}

        StaticPopupDialogs["MYSLOT_EXPORT_TITLE"].OnShow = function(self)
            local c = popctx.current

            if c and exports[c] then
                self.editBox:SetText(exports[c].name or "")
            end
            self.editBox:SetFocus()
        end


        StaticPopupDialogs["MYSLOT_EXPORT_TITLE"].OnAccept = function(self)
            local c = popctx.current

            -- if c then rename
            if c and exports[c] then
                local n = self.editBox:GetText()
                if n ~= "" then
                    exports[c].name = n
                    UIDropDownMenu_SetText(t, n)
                end
                return
            end

            create(self.editBox:GetText())
            onclick({value = #exports})
        end

        do
            local b = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
            b:SetWidth(70)
            b:SetHeight(25)
            b:SetPoint("TOPLEFT", t, 240, 0)
            b:SetText(NEW)
            b:SetScript("OnClick", function()
                popctx.current = nil
                StaticPopup_Show("MYSLOT_EXPORT_TITLE")
            end)
        end

        do
            local b = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
            b:SetWidth(70)
            b:SetHeight(25)
            b:SetPoint("TOPLEFT", t, 315, 0)
            b:SetText(SAVE)
            b:SetScript("OnClick", function() save(true) end)
        end

        do
            local b = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
            b:SetWidth(70)
            b:SetHeight(25)
            b:SetPoint("TOPLEFT", t, 390, 0)
            b:SetText(DELETE)
            b:SetScript("OnClick", function()
                local c = UIDropDownMenu_GetSelectedValue(t)

                if c then
                    StaticPopupDialogs["MYSLOT_CONFIRM_DELETE"].OnAccept = function()
                        StaticPopup_Hide("MYSLOT_CONFIRM_DELETE")
                        table.remove(exports, c)
                        
                        if #exports == 0 then
                            UIDropDownMenu_SetSelectedValue(t, nil)
                            UIDropDownMenu_SetText(t, "")
                            exportEditbox:SetText("")
                        else
                            onclick({value = #exports})
                        end
                    end
                    StaticPopup_Show("MYSLOT_CONFIRM_DELETE", exports[c].name)
                end
            end)
        end
       
        do
            local b = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
            b:SetWidth(70)
            b:SetHeight(25)
            b:SetPoint("TOPLEFT", t, 465, 0)
            b:SetText(L["Rename"])
            b:SetScript("OnClick", function()
                local c = UIDropDownMenu_GetSelectedValue(t)

                if c and exports[c] then
                    popctx.current = c
                    StaticPopup_Show("MYSLOT_EXPORT_TITLE")
                end
            end)
        end

    end

end)

SlashCmdList["MYSLOT"] = function(msg, editbox)
    local cmd, what = msg:match("^(%S*)%s*(%S*)%s*$")

    if cmd == "clear" then
        -- MySlot:Clear(what)
        InterfaceOptionsFrame_OpenToCategory(L["Myslot"])
        InterfaceOptionsFrame_OpenToCategory(L["Myslot"])
    else
        f:Show()
    end
end
SLASH_MYSLOT1 = "/MYSLOT"

StaticPopupDialogs["MYSLOT_MSGBOX"] = {
    text = L["Are you SURE to import ?"],
    button1 = ACCEPT,
    button2 = CANCEL,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1,
    multiple = 0,
}

StaticPopupDialogs["MYSLOT_EXPORT_TITLE"] = {
    text = L["Name of exported text"],
    button1 = ACCEPT,
    button2 = CANCEL,
    hasEditBox = true,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1,
    multiple = 0,
    OnAccept = function()
    end,
    OnShow = function()
    end,
}

StaticPopupDialogs["MYSLOT_CONFIRM_DELETE"] = {
    text = L["Are you SURE to delete '%s'?"],
    button1 = ACCEPT,
    button2 = CANCEL,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1,
    multiple = 0,
}
