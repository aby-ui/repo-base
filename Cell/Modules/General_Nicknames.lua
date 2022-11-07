local _, Cell = ...
local L = Cell.L
local F = Cell.funcs
local P = Cell.pixelPerfectFuncs

local nicknameOptionsFrame
local nicknameEB, syncCB, customCB, list, newItem
local LoadList
local customs = {}

local function CreateNicknameOptionsFrame()
    nicknameOptionsFrame = CreateFrame("Frame", "CellOptionsFrame_Nicknames", Cell.frames.generalTab, "BackdropTemplate")
    Cell:StylizeFrame(nicknameOptionsFrame, nil, Cell:GetAccentColorTable())
    nicknameOptionsFrame:SetFrameStrata("DIALOG")
    nicknameOptionsFrame:SetFrameLevel(50)
    nicknameOptionsFrame:Hide()

    nicknameOptionsFrame:SetPoint("LEFT", Cell.frames.generalTab.nicknameOptionsBtn, "RIGHT", 5, 0)
    nicknameOptionsFrame:SetPoint("TOPRIGHT", -5, -5)
    nicknameOptionsFrame:SetPoint("BOTTOMRIGHT", -5, 5)

    nicknameOptionsFrame:SetScript("OnHide", function()
        nicknameOptionsFrame:Hide()
        Cell.frames.generalTab.mask:Hide()
        Cell.frames.generalTab.nicknameOptionsBtn:SetFrameStrata("HIGH")
        newItem:Hide()
    end)

    -- my nickname
    nicknameEB = Cell:CreateEditBox(nicknameOptionsFrame, 20, 20)
    nicknameEB:SetPoint("TOPLEFT", 10, -10)
    nicknameEB:SetPoint("TOPRIGHT", -10, -10)
    nicknameEB:SetScript("OnTextChanged", function(self, userChanged)
        local text = strtrim(nicknameEB:GetText())

        if text == "" then
            nicknameEB.tip:Show()
        else
            nicknameEB.tip:Hide()
        end
        
        if userChanged then
            if CellDB["nicknames"]["mine"] ~= "" then -- already set a nickname
                if text ~= CellDB["nicknames"]["mine"] then -- not the same nickname
                    nicknameEB.confirmBtn:Show()
                else
                    nicknameEB.confirmBtn:Hide()
                end
            elseif text ~= "" then -- nickname not set, expect a non-empty string
                nicknameEB.confirmBtn:Show()
            else
                nicknameEB.confirmBtn:Hide()
            end
        end
    end)

    nicknameEB.confirmBtn = Cell:CreateButton(nicknameEB, L["Awesome!"], "accent", {77, 20})
    nicknameEB.confirmBtn:SetPoint("TOPRIGHT", nicknameEB)
    nicknameEB.confirmBtn:Hide()
    nicknameEB.confirmBtn:SetScript("OnHide", function()
        nicknameEB.confirmBtn:Hide()
    end)
    nicknameEB.confirmBtn:SetScript("OnClick", function()
        local text = strtrim(nicknameEB:GetText())
        nicknameEB:SetText(text)
        CellDB["nicknames"]["mine"] = text
        Cell:Fire("UpdateNicknames", "mine", text)
        nicknameEB.confirmBtn:Hide()
        nicknameEB:ClearFocus()
    end)

    nicknameEB.tip = nicknameEB:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    nicknameEB.tip:SetPoint("LEFT", 5, 0)
    nicknameEB.tip:SetTextColor(0.4, 0.4, 0.4, 1)
    nicknameEB.tip:SetText(L["My Nickname"])

    -- sync with others
    syncCB = Cell:CreateCheckButton(nicknameOptionsFrame, L["Sync Nicknames with Others"], function(checked, self)
        CellDB["nicknames"]["sync"] = checked
        Cell:Fire("UpdateNicknames", "sync", checked)
    end)
    syncCB:SetPoint("TOPLEFT", nicknameEB, "BOTTOMLEFT", 0, -10)

    -- custom
    customCB = Cell:CreateCheckButton(nicknameOptionsFrame, L["Custom Nicknames"], function(checked, self)
        CellDB["nicknames"]["custom"] = checked
        Cell:Fire("UpdateNicknames", "custom", checked)
        if checked then
            list.mask:Hide()
        else
            list.mask:Show()
        end
    end, L["Only visible to me"])
    customCB:SetPoint("TOPLEFT", syncCB, "BOTTOMLEFT", 0, -26)

    -- list
    list = Cell:CreateFrame(nil, nicknameOptionsFrame)
    list:SetPoint("TOPLEFT", customCB, "BOTTOMLEFT", 0, -10)
    list:SetPoint("BOTTOMRIGHT", -10, 10)
    list:Show()

    Cell:CreateMask(list, L["Disabled"])
    list.mask:SetFrameStrata("DIALOG")
    list.mask:Hide()

    -- list new
    newItem = Cell:CreateFrame(nil, list)
    newItem:SetFrameLevel(list:GetFrameLevel()+10)
    newItem:SetAllPoints(list)

    newItem.playerName = Cell:CreateEditBox(newItem, 20, 20)
    newItem.playerName:SetPoint("LEFT", 5, 0)
    newItem.playerName:SetPoint("RIGHT", -5, 0)
    newItem.playerName:SetPoint("TOP", 0, -127)
    newItem.playerName.tip = newItem.playerName:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    newItem.playerName.tip:SetTextColor(0.4, 0.4, 0.4, 1)
    newItem.playerName.tip:SetPoint("LEFT", 5, 0)
    newItem.playerName.tip:SetText(L["Name or Name-Server"])
    newItem.playerName:SetScript("OnTextChanged", function(self, userChanged)
        if userChanged then
            local text = strtrim(newItem.playerName:GetText())

            if text == "" then
                newItem.playerName.tip:Show()
                newItem.playerName.isValid = false
                newItem.playerName.text = nil
            else
                newItem.playerName.tip:Hide()
                if not Cell.vars.nicknameCustoms[text] then
                    newItem.playerName.isValid = true
                    newItem.playerName.text = text
                else
                    newItem.playerName.isValid = false
                    newItem.playerName.text = nil
                end
            end

            newItem.add:SetEnabled(newItem.playerName.isValid and newItem.nickname.isValid)
        end
    end)
    newItem.playerName:SetScript("OnTabPressed", function()
        newItem.nickname:SetFocus()
    end)

    newItem.nickname = Cell:CreateEditBox(newItem, 20, 20)
    newItem.nickname:SetPoint("TOPLEFT", newItem.playerName, "BOTTOMLEFT", 0, -5)
    newItem.nickname:SetPoint("TOPRIGHT", newItem.playerName, "BOTTOMRIGHT", 0, -5)
    newItem.nickname.tip = newItem.nickname:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    newItem.nickname.tip:SetTextColor(0.4, 0.4, 0.4, 1)
    newItem.nickname.tip:SetPoint("LEFT", 5, 0)
    newItem.nickname.tip:SetText(L["Nickname"])
    newItem.nickname:SetScript("OnTextChanged", function(self, userChanged)
        if userChanged then
            local text = strtrim(newItem.nickname:GetText())

            if text == "" then
                newItem.nickname.tip:Show()
                newItem.nickname.isValid = false
                newItem.nickname.text = nil
            else
                newItem.nickname.tip:Hide()
                newItem.nickname.isValid = true
                newItem.nickname.text = text
            end

            newItem.add:SetEnabled(newItem.playerName.isValid and newItem.nickname.isValid)
        end
    end)
    newItem.nickname:SetScript("OnTabPressed", function()
        newItem.playerName:SetFocus()
    end)

    newItem.add = Cell:CreateButton(newItem, L["Add"], "green", {120, 20})
    newItem.add:SetPoint("TOPLEFT", newItem.nickname, "BOTTOMLEFT", 0, -5)
    newItem.add:SetScript("OnClick", function()
        tinsert(CellDB["nicknames"]["list"], newItem.playerName.text..":"..newItem.nickname.text)
        Cell:Fire("UpdateNicknames", "list-add", newItem.playerName.text, newItem.nickname.text)
        newItem:Hide()
        LoadList()
    end)
    
    newItem.cancel = Cell:CreateButton(newItem, L["Cancel"], "red", {120, 20})
    newItem.cancel:SetPoint("TOPRIGHT", newItem.nickname, "BOTTOMRIGHT", 0, -5)
    newItem.cancel:SetScript("OnClick", function()
        newItem:Hide()
    end)
    
    -- list scroll
    Cell:CreateScrollFrame(list)
    list.scrollFrame:SetScrollStep(19)

    customs[0] = Cell:CreateButton(list.scrollFrame.content, "", "accent-hover", {20, 20})
    customs[0]:SetTexture("Interface\\AddOns\\Cell\\Media\\Icons\\new", {16, 16}, {"RIGHT", -1, 0})
    customs[0]:SetScript("OnClick", function()
        newItem.playerName:SetText("")
        newItem.playerName.tip:Show()
        newItem.playerName.isValid = nil
        newItem.nickname:SetText("")
        newItem.nickname.tip:Show()
        newItem.nickname.isValid = nil
        newItem.add:SetEnabled(false)
        newItem:Show()
    end)
end

-------------------------------------------------
-- functions
-------------------------------------------------
LoadList = function()
    list.scrollFrame:Reset()

    customs[0]:SetParent(list.scrollFrame.content)
    customs[0]:Show()
    customs[0]:SetPoint("BOTTOMLEFT")
    customs[0]:SetPoint("RIGHT")

    for i, v in ipairs(CellDB["nicknames"]["list"]) do
        if not customs[i] then
            customs[i] = Cell:CreateButton(list.scrollFrame.content, "", "accent-hover", {20, 20})
            -- playerName
            customs[i].playerName = customs[i]:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
            customs[i].playerName:SetPoint("LEFT", 5, 0)
            customs[i].playerName:SetWidth(130)
            customs[i].playerName:SetJustifyH("LEFT")
            customs[i].playerName:SetWordWrap(false)
            -- separator1
            customs[i].separator1 = customs[i]:CreateTexture(nil, "ARTWORK")
            customs[i].separator1:SetPoint("LEFT", 140, 0)
            customs[i].separator1:SetColorTexture(0, 0, 0, 1)
            P:Size(customs[i].separator1, 1, 20)
            -- nickname
            customs[i].nickname = customs[i]:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
            customs[i].nickname:SetPoint("LEFT", 145, 0)
            customs[i].nickname:SetPoint("RIGHT", -22, 0)
            customs[i].nickname:SetJustifyH("LEFT")
            customs[i].nickname:SetWordWrap(false)
            -- separator2
            customs[i].separator2 = customs[i]:CreateTexture(nil, "ARTWORK")
            customs[i].separator2:SetPoint("RIGHT", -17, 0)
            customs[i].separator2:SetColorTexture(0, 0, 0, 1)
            P:Size(customs[i].separator2, 1, 20)
            -- del
            customs[i].del = Cell:CreateButton(customs[i], "", "none", {18, 20}, true, true)
            customs[i].del:SetTexture("Interface\\AddOns\\Cell\\Media\\Icons\\delete", {16, 16}, {"CENTER", 0, 0})
            customs[i].del:SetPoint("RIGHT")
            customs[i].del.tex:SetVertexColor(0.6, 0.6, 0.6, 1)
            customs[i].del:SetScript("OnEnter", function()
                customs[i]:GetScript("OnEnter")(customs[i])
                customs[i].del.tex:SetVertexColor(1, 1, 1, 1)
            end)
            customs[i].del:SetScript("OnLeave",  function()
                customs[i]:GetScript("OnLeave")(customs[i])
                customs[i].del.tex:SetVertexColor(0.6, 0.6, 0.6, 1)
            end)
            -- edit
            -- customs[i].edit = Cell:CreateButton(customs[i], "", "none", {18, 20}, true, true)
            -- customs[i].edit:SetPoint("RIGHT", customs[i].del, "LEFT", 1, 0)
            -- customs[i].edit:SetTexture("Interface\\AddOns\\Cell\\Media\\Icons\\info", {16, 16}, {"CENTER", 0, 0})
            -- customs[i].edit.tex:SetVertexColor(0.6, 0.6, 0.6, 1)
            -- customs[i].edit:SetScript("OnEnter", function()
            --     customs[i]:GetScript("OnEnter")(customs[i])
            --     customs[i].edit.tex:SetVertexColor(1, 1, 1, 1)
            -- end)
            -- customs[i].edit:SetScript("OnLeave",  function()
            --     customs[i]:GetScript("OnLeave")(customs[i])
            --     customs[i].edit.tex:SetVertexColor(0.6, 0.6, 0.6, 1)
            -- end)
        end

        local playerName, nickname = strsplit(":", v, 2)
        customs[i].playerName:SetText(playerName)
        customs[i].nickname:SetText(nickname)

        customs[i].del:SetScript("OnClick", function()
            tremove(CellDB["nicknames"]["list"], i)
            Cell:Fire("UpdateNicknames", "list-delete", playerName)
            LoadList()
        end)

        customs[i]:SetParent(list.scrollFrame.content)
        customs[i]:Show()

        customs[i]:SetPoint("RIGHT")
        if i == 1 then
            customs[i]:SetPoint("TOPLEFT")
        else
            customs[i]:SetPoint("TOPLEFT", customs[i-1], "BOTTOMLEFT", 0, 1)
        end
    end

    list.scrollFrame:SetContentHeight((#CellDB["nicknames"]["list"]+1)*19+1)
end

local function LoadData()
    nicknameEB:SetText(CellDB["nicknames"]["mine"])
    syncCB:SetChecked(CellDB["nicknames"]["sync"])
    customCB:SetChecked(CellDB["nicknames"]["custom"])
    if CellDB["nicknames"]["custom"] then
        list.mask:Hide()
    else
        list.mask:Show()
    end
    LoadList()
end

function F:ShowNicknameOptions()
    if not nicknameOptionsFrame then
        CreateNicknameOptionsFrame()
    end

    if nicknameOptionsFrame:IsShown() then
        nicknameOptionsFrame:Hide()
        Cell.frames.generalTab.nicknameOptionsBtn:SetFrameStrata("HIGH")
    else
        nicknameOptionsFrame:Show()
        Cell.frames.generalTab.nicknameOptionsBtn:SetFrameStrata("DIALOG")
        Cell.frames.generalTab.mask:Show()
        LoadData()
    end
end