local _, MySlot = ...

local L = MySlot.L


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

-- export editbox
local exportEditbox
do
    local t = CreateFrame("ScrollFrame", "MYSLOT_ScrollFrame", f, "UIPanelScrollFrameTemplate")
    t:EnableMouse(true)
    t:SetPoint("TOPLEFT", f, 25, -30)
    t:SetWidth(580)
    t:SetHeight(500)
    local edit = CreateFrame("EditBox", "MYSLOT_ReportFrame_EditBox", t)
    edit:SetWidth(560)
    edit:SetHeight(480)
    edit:SetPoint("TOPLEFT", t, 0, 0)
    edit:SetAutoFocus(false)
    edit:SetMaxLetters(99999999)
    edit:SetMultiLine(true)
    edit:SetFontObject(GameTooltipTextSmall)
    edit:SetScript("OnTextChanged", function(self)
        ScrollingEdit_OnTextChanged(self, t)
    end)
    edit:SetScript("OnCursorChanged", ScrollingEdit_OnCursorChanged)
    edit:SetScript("OnUpdate", function(self, elapsed)
        ScrollingEdit_OnUpdate(self, elapsed, t)
    end)
    edit:SetScript("OnEscapePressed", edit.ClearFocus)
    edit:SetScript("OnTextSet", edit.HighlightText)
    edit:SetScript("OnMouseUp", edit.HighlightText)

    t:SetScript("OnMouseDown", function()
        edit:SetFocus()
    end)

    t:SetScrollChild(edit)
    exportEditbox = edit
end

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

-- import
do
    local b = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
    b:SetWidth(125)
    b:SetHeight(25)
    b:SetPoint("BOTTOMLEFT", 200, 15)
    b:SetText(L["Import"])
    b:SetScript("OnClick", function()
        local msg = MySlot:Import(exportEditbox:GetText(), {
            force = forceImportCheckbox:GetChecked()
        })

        if not msg then
            return
        end
        
        StaticPopupDialogs["MYSLOT_MSGBOX"].OnAccept = function()
            StaticPopup_Hide("MYSLOT_MSGBOX")
            MySlot:RecoverData(msg)
        end
        StaticPopup_Show("MYSLOT_MSGBOX")
    end)
end

-- export
do
    local b = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
    b:SetWidth(125)
    b:SetHeight(25)
    b:SetPoint("BOTTOMLEFT", 40, 15)
    b:SetText(L["Export"])
    b:SetScript("OnClick", function()
        local s = MySlot:Export()
        exportEditbox:SetText(s)
        ScrollingEdit_SetCursorOffsets(exportEditbox, 0, 0)
    end)
end

SlashCmdList["MYSLOT"] = function(msg, editbox)
    local cmd, what = msg:match("^(%S*)%s*(%S*)%s*$")

    if cmd == "clear" then
        MySlot:Clear(what)
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
