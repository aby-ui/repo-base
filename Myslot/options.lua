local _, MySlot = ...
local L = MySlot.L
local RegEvent = MySlot.regevent


local f = CreateFrame("Frame", nil, UIParent)
f.name = L["Myslot"]
InterfaceOptions_AddCategory(f)

do
    local t = f:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    t:SetText(L["Myslot"])
    t:SetPoint("TOPLEFT", f, 15, -15)
end

do
    local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    t:SetText(L["Feedback"] .. "  farmer1992@gmail.com")
    t:SetPoint("TOPLEFT", f, 15, -50)
end


do
    local b = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
    b:SetWidth(200)
    b:SetHeight(25)
    b:SetPoint("TOPLEFT", 15, -80)
    b:SetText(L["Open Myslot"])
    b:SetScript("OnClick", function()
        MySlot.MainFrame:Show()
        InterfaceOptionsFrame_Show()
    end)
end

do
    local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    t:SetText(RED_FONT_COLOR:WrapTextInColorCode(L["DANGEROUS"]))
    t:SetPoint("TOPLEFT", f, 15, -120)
end

do
    local b = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
    b:SetWidth(200)
    b:SetHeight(25)
    b:SetPoint("TOPLEFT", 15, -140)
    b:SetText(L["Remove everything in ActionBar"])
    b:SetScript("OnClick", function()
        StaticPopup_Show("MYSLOT_CONFIRM_CLEAR", "ACTION", nil, "ACTION")
    end)
end

do
    local b = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
    b:SetWidth(200)
    b:SetHeight(25)
    b:SetPoint("TOPLEFT", 15, -170)
    b:SetText(L["Remove all Key Bindings"])
    b:SetScript("OnClick", function()
        StaticPopup_Show("MYSLOT_CONFIRM_CLEAR", "BINDING", nil, "BINDING")
    end)
end

do
    local b = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
    b:SetWidth(200)
    b:SetHeight(25)
    b:SetPoint("TOPLEFT", 15, -200)
    b:SetText(L["Remove all Macros"])
    b:SetScript("OnClick", function()
        StaticPopup_Show("MYSLOT_CONFIRM_CLEAR", "MACRO", nil, "MACRO")
    end)
end

StaticPopupDialogs["MYSLOT_CONFIRM_CLEAR"] = {
    text = L["Please type %s to confirm"],
    button1 = ACCEPT,
    button2 = CANCEL,
    hasEditBox = true,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1,
    multiple = 0,
    OnAccept = function(self, data)
        local tx = self.editBox:GetText()

        if tx == data then
            MySlot:Clear(data)
        else
            MySlot:Print(L["Please type %s to confirm"]:format(data))
        end
        
    end,
}
