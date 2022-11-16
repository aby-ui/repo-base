local _, Cell = ...
local L = Cell.L
local F = Cell.funcs
local P = Cell.pixelPerfectFuncs

local glowsTab = Cell:CreateFrame("CellOptionsFrame_GlowsTab", Cell.frames.optionsFrame, nil, nil, true)
Cell.frames.glowsTab = glowsTab
glowsTab:SetAllPoints(Cell.frames.optionsFrame)
glowsTab:Hide()

local whichGlowOption, srGlowOptionsBtn, drGlowOptionsBtn
local ShowSpellEditFrame

-------------------------------------------------
-- spell request
-------------------------------------------------
local waTips, srEnabledCB, srExistsCB, srKnownOnlyCB, srFreeCDOnlyCB, srReplyCDCB, srReplyCastEB, srResponseDD, srResponseText, srTimeoutDD, srTimeoutText, srSpellsDD, srSpellsText, srAddBtn, srDeleteBtn, srMacroText, srMacroEB
local srSelectedSpell, canEdit

local function ShowSpellOptions(index)
    if whichGlowOption == "spellRequest" then
        F:HideGlowOptions()
        Cell:StopRainbowText(srGlowOptionsBtn:GetFontString())
    end

    srSelectedSpell = index

    local responseType = CellDB["glows"]["spellRequest"]["responseType"]
    local spellId = CellDB["glows"]["spellRequest"]["spells"][index]["spellId"]
    local macroText, keywords
    
    if responseType == "all" then
        srMacroText:SetText(L["Macro"])
        macroText = "/run C_ChatInfo.SendAddonMessage(\"CELL_REQ_S\",\""..spellId.."\",\"RAID\")"
    elseif responseType == "me" then
        srMacroText:SetText(L["Macro"])
        macroText = "/run C_ChatInfo.SendAddonMessage(\"CELL_REQ_S\",\""..spellId..":"..GetUnitName("player").."\",\"RAID\")"
    else -- whisper
        srMacroText:SetText(L["Contains"])
        keywords = CellDB["glows"]["spellRequest"]["spells"][index]["keywords"]
    end

    if macroText then
        srMacroEB:SetText(macroText)
        srMacroEB.gauge:SetText(macroText)
        srMacroEB:SetScript("OnTextChanged", function(self, userChanged)
            if userChanged then
                srMacroEB:SetText(macroText)
                srMacroEB:HighlightText()
            end
        end)
    else
        srMacroEB:SetText(keywords)
        srMacroEB.gauge:SetText(keywords)
        srMacroEB:SetScript("OnTextChanged", function(self, userChanged)
            if userChanged then
                CellDB["glows"]["spellRequest"]["spells"][index]["keywords"] = strtrim(self:GetText())
                Cell:Fire("UpdateGlows", "spellRequest")
            end
        end)
    end

    canEdit = not CellDB["glows"]["spellRequest"]["spells"][index]["isBuiltIn"] -- not built-in
    srDeleteBtn:SetEnabled(canEdit)
    srGlowOptionsBtn:SetEnabled(true)
    srMacroText:Show()
    srMacroEB:SetCursorPosition(0)
    srMacroEB:Show()
end

local function HideSpellOptions()
    if whichGlowOption == "spellRequest" then
        F:HideGlowOptions()
        Cell:StopRainbowText(srGlowOptionsBtn:GetFontString())
    end
    srSelectedSpell = nil
    canEdit = nil
    srMacroText:Hide()
    srMacroEB:Hide()
    srSpellsDD:SetSelected()
    srDeleteBtn:SetEnabled(false)
    srGlowOptionsBtn:SetEnabled(false)
end

local function LoadSpellsDropdown()
    local items = {}
    for i, t in pairs(CellDB["glows"]["spellRequest"]["spells"]) do
        local name, _, icon = GetSpellInfo(t["spellId"])
        tinsert(items, {
            ["text"] = "|T"..icon..":0::0:0:16:16:1:15:1:15|t "..name,
            ["value"] = t["spellId"],
            ["onClick"] = function()
                ShowSpellOptions(i)
            end
        })
    end
    srSpellsDD:SetItems(items)
end

local function UpdateSRWidgets()
    CellDropdownList:Hide()
    Cell:SetEnabled(CellDB["glows"]["spellRequest"]["enabled"], waTips, srExistsCB, srKnownOnlyCB, srResponseDD, srResponseText, srTimeoutDD, srTimeoutText, srSpellsDD, srSpellsText, srAddBtn, srDeleteBtn, srGlowOptionsBtn, srMacroText, srMacroEB)
    Cell:SetEnabled(CellDB["glows"]["spellRequest"]["enabled"] and CellDB["glows"]["spellRequest"]["knownSpellsOnly"], srFreeCDOnlyCB)
    Cell:SetEnabled(CellDB["glows"]["spellRequest"]["enabled"] and CellDB["glows"]["spellRequest"]["knownSpellsOnly"] and CellDB["glows"]["spellRequest"]["responseType"] ~= "all", srReplyCDCB, srReplyCastEB)
end

local function CreateSRPane()
    if not Cell.frames.glowsTab.mask then
        Cell:CreateMask(Cell.frames.glowsTab, nil, {1, -1, -1, 1})
        Cell.frames.glowsTab.mask:Hide()
    end

    local srPane = Cell:CreateTitledPane(glowsTab, L["Spell Request"], 422, 250)
    srPane:SetPoint("TOPLEFT", 5, -5)
    srPane:SetScript("OnHide", function()
        whichGlowOption = nil
        HideSpellOptions()
    end)

    waTips = Cell:CreateButton(srPane, "WA", "accent", {37, 17})
    waTips:SetPoint("TOPRIGHT")
    waTips:HookScript("OnEnter", function()
        CellTooltip:SetOwner(waTips, "ANCHOR_NONE")
        CellTooltip:SetPoint("TOPLEFT", waTips, "TOPRIGHT", 6, 0)
        CellTooltip:AddLine("WeakAuras Custom Events")
        CellTooltip:AddLine("|cffffffff"..[[eventName: "CELL_NOTIFY"]])
        CellTooltip:AddLine("|cffffffff".."arg1:\n    \"SPELL_REQ_RECEIVED\"\n    \"SPELL_REQ_CAST\"\n    \"SPELL_REQ_APPLIED\"")
        CellTooltip:AddLine("|cffffffff".."arg2: unitId")
        CellTooltip:AddLine("|cffffffff".."arg3: spellId")
        CellTooltip:AddLine("|cffffffff".."arg4: buffId")
        CellTooltip:AddLine("|cffffffff".."arg5: timeout")
        CellTooltip:Show()
    end)
    waTips:HookScript("OnLeave", function()
        CellTooltip:Hide()
    end)


    local pirTips = srPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    pirTips:SetPoint("TOPLEFT", 5, -25)
    pirTips:SetJustifyH("LEFT")
    pirTips:SetSpacing(5)
    pirTips:SetText(L["Glow unit button when a group member sends a %s request"]:format(Cell:GetAccentColorString()..L["SPELL"].."|r").."\n"..L["Shows only one spell glow on a unit button at a time"])

    -- enabled ----------------------------------------------------------------------
    srEnabledCB = Cell:CreateCheckButton(srPane, L["Enabled"], function(checked, self)
        CellDB["glows"]["spellRequest"]["enabled"] = checked
        UpdateSRWidgets()
        HideSpellOptions()
        Cell:Fire("UpdateGlows", "spellRequest")
    end)
    srEnabledCB:SetPoint("TOPLEFT", srPane, "TOPLEFT", 5, -65)
    ---------------------------------------------------------------------------------
    
    -- check exists -----------------------------------------------------------------
    srExistsCB = Cell:CreateCheckButton(srPane, L["Check If Exists"], function(checked, self)
        CellDB["glows"]["spellRequest"]["checkIfExists"] = checked
        Cell:Fire("UpdateGlows", "spellRequest")
    end, L["Do nothing if requested spell/buff already exists on requester"])
    srExistsCB:SetPoint("TOPLEFT", srEnabledCB, "TOPLEFT", 200, 0)
    ---------------------------------------------------------------------------------

    -- known only -------------------------------------------------------------------
    srKnownOnlyCB = Cell:CreateCheckButton(srPane, L["Known Spells Only"], function(checked, self)
        CellDB["glows"]["spellRequest"]["knownSpellsOnly"] = checked
        UpdateSRWidgets()
        HideSpellOptions()
        Cell:Fire("UpdateGlows", "spellRequest")
    end, L["If disabled, no check, no reply, just glow"])
    srKnownOnlyCB:SetPoint("TOPLEFT", srEnabledCB, "BOTTOMLEFT", 0, -8)
    ---------------------------------------------------------------------------------
    
    -- free cooldown ----------------------------------------------------------------
    srFreeCDOnlyCB = Cell:CreateCheckButton(srPane, L["Free Cooldown Only"], function(checked, self)
        CellDB["glows"]["spellRequest"]["freeCooldownOnly"] = checked
        Cell:Fire("UpdateGlows", "spellRequest")
    end)
    srFreeCDOnlyCB:SetPoint("TOPLEFT", srKnownOnlyCB, "TOPLEFT", 200, 0)
    ---------------------------------------------------------------------------------

    -- reply cd ---------------------------------------------------------------------
    srReplyCDCB = Cell:CreateCheckButton(srPane, L["Reply With Cooldown"], function(checked, self)
        CellDB["glows"]["spellRequest"]["replyCooldown"] = checked
        Cell:Fire("UpdateGlows", "spellRequest")
    end)
    srReplyCDCB:SetPoint("TOPLEFT", srKnownOnlyCB, "BOTTOMLEFT", 0, -8)
    ---------------------------------------------------------------------------------

    -- reply after cast -------------------------------------------------------------
    srReplyCastEB = Cell:CreateEditBox(srPane, 20, 20)
    srReplyCastEB:SetPoint("TOPLEFT", srFreeCDOnlyCB, "BOTTOMLEFT", 0, -5)
    srReplyCastEB:SetPoint("RIGHT", -5, 0)
    srReplyCastEB:SetScript("OnTextChanged", function(self, userChanged)
        if userChanged then
            local text = strtrim(self:GetText())
            if text ~= "" then
                CellDB["glows"]["spellRequest"]["replyAfterCast"] = text
                srReplyCastEB.tip:Hide()
            else
                CellDB["glows"]["spellRequest"]["replyAfterCast"] = nil
                srReplyCastEB.tip:Show()
            end
            Cell:Fire("UpdateGlows", "spellRequest")
        end
    end)

    srReplyCastEB.tip = srReplyCastEB:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    srReplyCastEB.tip:SetPoint("LEFT", 5, 0)
    srReplyCastEB.tip:SetTextColor(0.4, 0.4, 0.4, 1)
    srReplyCastEB.tip:SetText(L["Reply After Cast"])
    srReplyCastEB.tip:Hide()
    ---------------------------------------------------------------------------------

    -- response ----------------------------------------------------------------------
    srResponseDD = Cell:CreateDropdown(srPane, 345)
    srResponseDD:SetPoint("TOPLEFT", srReplyCDCB, "BOTTOMLEFT", 0, -27)
    srResponseDD:SetItems({
        {
            ["text"] = L["Respond to all requests from group members"],
            ["value"] = "all",
            ["onClick"] = function()
                HideSpellOptions()
                CellDB["glows"]["spellRequest"]["responseType"] = "all"
                Cell:Fire("UpdateGlows", "spellRequest")
                UpdateSRWidgets()
            end
        },
        {
            ["text"] = L["Respond to requests that are only sent to me"],
            ["value"] = "me",
            ["onClick"] = function()
                HideSpellOptions()
                CellDB["glows"]["spellRequest"]["responseType"] = "me"
                Cell:Fire("UpdateGlows", "spellRequest")
                UpdateSRWidgets()
            end
        },
        {
            ["text"] = L["Respond to whispers"],
            ["value"] = "whisper",
            ["onClick"] = function()
                HideSpellOptions()
                CellDB["glows"]["spellRequest"]["responseType"] = "whisper"
                Cell:Fire("UpdateGlows", "spellRequest")
                UpdateSRWidgets()
            end
        },
    })

    srResponseText = srPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    srResponseText:SetPoint("BOTTOMLEFT", srResponseDD, "TOPLEFT", 0, 1)
    srResponseText:SetText(L["Response Type"])
    ---------------------------------------------------------------------------------

    -- timeout ----------------------------------------------------------------------
    srTimeoutDD = Cell:CreateDropdown(srPane, 60)
    srTimeoutDD:SetPoint("TOPLEFT", srResponseDD, "TOPRIGHT", 7, 0)

    local items = {}
    local secs = {1, 2, 3, 4, 5, 10, 15, 20, 25, 30}
    for _, s in ipairs(secs) do
        tinsert(items, {
            ["text"] = s,
            ["value"] = s,
            ["onClick"] = function()
                CellDB["glows"]["spellRequest"]["timeout"] = s
                Cell:Fire("UpdateGlows", "spellRequest")
            end
        })
    end
    srTimeoutDD:SetItems(items)

    srTimeoutText = srPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    srTimeoutText:SetPoint("BOTTOMLEFT", srTimeoutDD, "TOPLEFT", 0, 1)
    srTimeoutText:SetText(L["Timeout"])
    ---------------------------------------------------------------------------------
    
    -- spells -----------------------------------------------------------------------
    srSpellsDD = Cell:CreateDropdown(srPane, 182)
    srSpellsDD:SetPoint("TOPLEFT", srResponseDD, "BOTTOMLEFT", 0, -27)

    srSpellsText = srPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    srSpellsText:SetPoint("BOTTOMLEFT", srSpellsDD, "TOPLEFT", 0, 1)
    srSpellsText:SetText(L["Spells"])
    ---------------------------------------------------------------------------------

    -- create -----------------------------------------------------------------------
    srAddBtn = Cell:CreateButton(srPane, L["Add"], "green-hover", {60, 20}, nil, nil, nil, nil, nil,
        L["Add new spell"], L["[Alt+LeftClick] to edit"], L["The spell is required to apply a buff on the target"], L["SpellId and BuffId are the same in most cases"])
    srAddBtn:SetPoint("TOPLEFT", srSpellsDD, "TOPRIGHT", 7, 0)
    srAddBtn:SetScript("OnUpdate", function(self, elapsed)
        srAddBtn.elapsed = (srAddBtn.elapsed or 0) + elapsed
        if srAddBtn.elapsed >= 0.25 then
            if IsAltKeyDown() and canEdit then
                srAddBtn:SetText(L["Edit"])
            else
                srAddBtn:SetText(L["Add"])
            end
        end
    end)
    srAddBtn:SetScript("OnClick", function()
        if IsAltKeyDown() and canEdit then
            ShowSpellEditFrame(srSelectedSpell)
        else
            ShowSpellEditFrame()
        end
    end)
    Cell:RegisterForCloseDropdown(srAddBtn)
    ---------------------------------------------------------------------------------
    
    -- delete -----------------------------------------------------------------------
    srDeleteBtn = Cell:CreateButton(srPane, L["Delete"], "red-hover", {60, 20})
    srDeleteBtn:SetPoint("TOPLEFT", srAddBtn, "TOPRIGHT", P:Scale(-1), 0)
    srDeleteBtn:SetScript("OnClick", function()
        local name, _, icon = GetSpellInfo(CellDB["glows"]["spellRequest"]["spells"][srSelectedSpell]["spellId"])
        local spellEditFrame = Cell:CreateConfirmPopup(glowsTab, 200, L["Delete spell?"].."\n".."|T"..icon..":0::0:0:16:16:1:15:1:15|t "..name, function(self)
            tremove(CellDB["glows"]["spellRequest"]["spells"], srSelectedSpell)
            srSpellsDD:RemoveCurrentItem()
            HideSpellOptions()
            Cell:Fire("UpdateGlows", "spellRequest")
        end, nil, true)
        spellEditFrame:SetPoint("LEFT", 117, 0)
        spellEditFrame:SetPoint("BOTTOM", srDeleteBtn, 0, 0)
    end)
    Cell:RegisterForCloseDropdown(srDeleteBtn)
    ---------------------------------------------------------------------------------
    
    -- glow -------------------------------------------------------------------------
    srGlowOptionsBtn = Cell:CreateButton(srPane, L["Glow Options"], "accent", {105, 20})
    srGlowOptionsBtn:SetPoint("TOPLEFT", srDeleteBtn, "TOPRIGHT", P:Scale(-1), 0)
    srGlowOptionsBtn:SetScript("OnClick", function()
        whichGlowOption = "spellRequest"
        Cell:StopRainbowText(drGlowOptionsBtn:GetFontString())
        local fs = srGlowOptionsBtn:GetFontString()
        if fs.rainbow then
            Cell:StopRainbowText(fs)
        else
            Cell:StartRainbowText(fs)
        end
        F:ShowGlowOptions(glowsTab, "spellRequest", CellDB["glows"]["spellRequest"]["spells"][srSelectedSpell]["glowOptions"])
    end)
    srGlowOptionsBtn:SetScript("OnHide", function()
        Cell:StopRainbowText(srGlowOptionsBtn:GetFontString())
    end)
    Cell:RegisterForCloseDropdown(srGlowOptionsBtn)
    ---------------------------------------------------------------------------------

    -- macro ------------------------------------------------------------------------
    srMacroText = srPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    srMacroText:SetPoint("TOPLEFT", srSpellsDD, "BOTTOMLEFT", 0, -10)
    srMacroText:SetText(L["Macro"])

    srMacroEB = Cell:CreateEditBox(srPane, 357, 20)
    srMacroEB:SetPoint("TOP", srSpellsDD, "BOTTOM", 0, -7)
    srMacroEB:SetPoint("LEFT", srMacroText, "RIGHT", 5, 0)
    srMacroEB:SetPoint("RIGHT", -5, 0)

    srMacroEB.gauge = srMacroEB:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    srMacroEB:SetScript("OnEditFocusGained", function()
        local requiredWidth = srMacroEB.gauge:GetStringWidth()
        if requiredWidth > srMacroEB:GetWidth() then
            srMacroEB:ClearAllPoints()
            srMacroEB:SetPoint("TOP", srSpellsDD, "BOTTOM", 0, -7)
            srMacroEB:SetPoint("LEFT", srMacroText, "RIGHT", 5, 0)
            srMacroEB:SetWidth(requiredWidth + 20)
        end
        srMacroEB:HighlightText()
    end)
    srMacroEB:SetScript("OnEditFocusLost", function()
        srMacroEB:ClearAllPoints()
        srMacroEB:SetPoint("TOP", srSpellsDD, "BOTTOM", 0, -7)
        srMacroEB:SetPoint("LEFT", srMacroText, "RIGHT", 5, 0)
        srMacroEB:SetPoint("RIGHT", -5, 0)
        srMacroEB:SetCursorPosition(0)
        srMacroEB:HighlightText(0, 0)
    end)
    ---------------------------------------------------------------------------------
end

-------------------------------------------------
-- spell edit frame
-------------------------------------------------
local spellId, buffId, spellName, spellIcon
local spellEditFrame, title, spellIdEB, buffIdEB, addBtn, cancelBtn

local function CreateSpellEditFrame()
    spellEditFrame = CreateFrame("Frame", nil, glowsTab, "BackdropTemplate")
    spellEditFrame:Hide()
    Cell:StylizeFrame(spellEditFrame, {0.1, 0.1, 0.1, 0.95}, Cell:GetAccentColorTable())
    spellEditFrame:SetFrameStrata("DIALOG")
    spellEditFrame:SetSize(200, 100)
    spellEditFrame:SetPoint("LEFT", 117, 0)
    spellEditFrame:SetPoint("BOTTOM", srAddBtn, 0, 0)
    spellEditFrame:SetScript("OnHide", function()
        CellSpellTooltip:Hide()
        glowsTab.mask:Hide()
        spellEditFrame:Hide()
        spellIdEB:SetText("")
        buffIdEB:SetText("")
        spellId, buffId, spellName, spellIcon = nil, nil, nil, nil
    end)

    -- title
    title = spellEditFrame:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET_TITLE")
    title:SetWordWrap(true)
    title:SetJustifyH("CENTER")
    title:SetPoint("TOPLEFT", 5, -8)
    title:SetPoint("TOPRIGHT", -5, -8)
    title:SetText(L["Add new spell"])

    -- spllId editbox
    spellIdEB = Cell:CreateEditBox(spellEditFrame, 20, 20)
    spellIdEB:SetPoint("TOPLEFT", spellEditFrame, 10, -30)
    spellIdEB:SetPoint("TOPRIGHT", spellEditFrame, -10, -30)
    spellIdEB:SetNumeric(true)
    spellIdEB:SetScript("OnTabPressed", function()
        buffIdEB:SetFocus()
    end)
    spellIdEB:SetScript("OnTextChanged", function()
        local id = tonumber(spellIdEB:GetText())
        if not id then
            CellSpellTooltip:Hide()
            spellId = nil
            addBtn:SetEnabled(false)
            spellIdEB.tip:SetTextColor(1, 0, 0, 0.777)
            return
        end

        local name, _, icon = GetSpellInfo(id)
        if not name then
            CellSpellTooltip:Hide()
            spellId = nil
            addBtn:SetEnabled(false)
            spellIdEB.tip:SetTextColor(1, 0, 0, 0.777)
            return
        end

        C_Timer.After(0.1, function()
            CellSpellTooltip:SetOwner(spellEditFrame, "ANCHOR_NONE")
            CellSpellTooltip:SetPoint("TOPLEFT", spellEditFrame, "BOTTOMLEFT", 0, -1)
            CellSpellTooltip:SetSpellByID(id)
            CellSpellTooltip:Show()
        end)

        spellId = id
        spellName = name
        spellIcon = icon
        addBtn:SetEnabled(spellId and buffId)
        spellIdEB.tip:SetTextColor(0, 1, 0, 0.777)
    end)

    spellIdEB.tip = spellIdEB:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    spellIdEB.tip:SetTextColor(0.4, 0.4, 0.4, 1)
    spellIdEB.tip:SetText(L["Spell"].." ID")
    spellIdEB.tip:SetPoint("RIGHT", -5, 0)

    -- buffId editbox
    buffIdEB = Cell:CreateEditBox(spellEditFrame, 20, 20)
    buffIdEB:SetPoint("TOPLEFT", spellIdEB, "BOTTOMLEFT", 0, -5)
    buffIdEB:SetPoint("TOPRIGHT", spellIdEB, "BOTTOMRIGHT", 0, -5)
    buffIdEB:SetNumeric(true)
    buffIdEB:SetScript("OnTabPressed", function()
        if spellIdEB:IsEnabled() then
            spellIdEB:SetFocus()
        end
    end)
    buffIdEB:SetScript("OnTextChanged", function()
        local id = tonumber(buffIdEB:GetText())
        if not id then
            buffId = nil
            addBtn:SetEnabled(false)
            buffIdEB.tip:SetTextColor(1, 0, 0, 0.777)
            return
        end

        local name = GetSpellInfo(id)
        if not name then
            buffId = nil
            addBtn:SetEnabled(false)
            buffIdEB.tip:SetTextColor(1, 0, 0, 0.777)
            return
        end

        buffId = id
        addBtn:SetEnabled(spellId and buffId)
        buffIdEB.tip:SetTextColor(0, 1, 0, 0.777)
    end)

    buffIdEB.tip = buffIdEB:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    buffIdEB.tip:SetTextColor(0.4, 0.4, 0.4, 1)
    buffIdEB.tip:SetText(L["Buff"].." ID")
    buffIdEB.tip:SetPoint("RIGHT", -5, 0)

    -- cancel
    cancelBtn = Cell:CreateButton(spellEditFrame, L["Cancel"], "red", {50, 15})
    cancelBtn:SetPoint("BOTTOMRIGHT")
    cancelBtn:SetBackdropBorderColor(unpack(Cell:GetAccentColorTable()))
    cancelBtn:SetScript("OnClick", function()
        spellEditFrame:Hide()
    end)

    -- add
    addBtn = Cell:CreateButton(spellEditFrame, L["Add"], "green", {50, 15})
    addBtn:SetPoint("BOTTOMRIGHT", cancelBtn, "BOTTOMLEFT", P:Scale(1), 0)
    addBtn:SetBackdropBorderColor(unpack(Cell:GetAccentColorTable()))
    addBtn:SetScript("OnClick", function()
        spellEditFrame:Hide()
    end)
end

ShowSpellEditFrame = function(index)
    glowsTab.mask:Show()
    spellEditFrame:Show()

    if not index then -- add
        spellIdEB:SetEnabled(true)
        spellIdEB:SetFocus()

        title:SetText(L["Add new spell"])
        addBtn:SetText(L["Add"])

        addBtn:SetScript("OnClick", function()
            if spellId and buffId then
                -- check if exists
                for _, t in pairs(CellDB["glows"]["spellRequest"]["spells"]) do
                    if t["spellId"] == spellId then
                        F:Print(L["Spell already exists."])
                        return
                    end
                end

                -- update db
                tinsert(CellDB["glows"]["spellRequest"]["spells"], {
                    ["spellId"] = spellId,
                    ["buffId"] = buffId,
                    ["keywords"] = spellName,
                    ["glowOptions"] = {
                        "pixel", -- [1] glow type
                        {
                            {0,1,0.5,1}, -- [1] color
                            0, -- [2] x
                            0, -- [3] y
                            9, -- [4] N
                            0.25, -- [5] frequency
                            8, -- [6] length
                            2 -- [7] thickness
                        } -- [2] glowOptions
                    }
                })
                Cell:Fire("UpdateGlows", "spellRequest")

                local index = #CellDB["glows"]["spellRequest"]["spells"]

                -- update dropdown
                srSpellsDD:AddItem({
                    ["text"] = "|T"..spellIcon..":0::0:0:16:16:1:15:1:15|t "..spellName,
                    ["value"] = spellId,
                    ["onClick"] = function()
                        ShowSpellOptions(index)
                    end
                })
                srSpellsDD:SetSelectedValue(spellId)
                ShowSpellOptions(index)
            else
                F:Print(L["Invalid spell id."])
            end
            spellEditFrame:Hide()
        end)
    else
        spellIdEB:SetEnabled(false)
        buffIdEB:SetFocus()

        spellIdEB:SetText(CellDB["glows"]["spellRequest"]["spells"][index]["spellId"])
        buffIdEB:SetText(CellDB["glows"]["spellRequest"]["spells"][index]["buffId"])

        title:SetText(L["Edit spell"])
        addBtn:SetText(L["Save"])

        addBtn:SetScript("OnClick", function()
            if spellId and buffId then
                -- update db
                CellDB["glows"]["spellRequest"]["spells"][index]["buffId"] = buffId
                Cell:Fire("UpdateGlows", "spellRequest")

                -- update dropdown
                srSpellsDD:SetCurrentItem({
                    ["text"] = "|T"..spellIcon..":0::0:0:16:16:1:15:1:15|t "..spellName,
                    ["value"] = spellId,
                    ["onClick"] = function()
                        ShowSpellOptions(index)
                    end
                })
                srSpellsDD:SetSelectedValue(spellId)
                ShowSpellOptions(index)
            else
                F:Print(L["Invalid spell id."])
            end
            spellEditFrame:Hide()
        end)
    end
end

-------------------------------------------------
-- dispel request
-------------------------------------------------
local drEnabledCB, drDispellableCB, drResponseDD, drResponseText, drTimeoutDD, drTimeoutText, drMacroText, drMacroEB, drDebuffsText, drDebuffsEB

local function UpdateDRWidgets()
    Cell:SetEnabled(CellDB["glows"]["dispelRequest"]["enabled"], drDispellableCB, drResponseDD, drResponseText, drTimeoutDD, drTimeoutText, drMacroText, drMacroEB, drGlowOptionsBtn)
    Cell:SetEnabled(CellDB["glows"]["dispelRequest"]["enabled"] and CellDB["glows"]["dispelRequest"]["responseType"] == "specific", drDebuffsText, drDebuffsEB)
end

local function CreateDRPane()
    local drPane = Cell:CreateTitledPane(glowsTab, L["Dispel Request"], 422, 183)
    drPane:SetPoint("TOPLEFT", 5, -275)

    drGlowOptionsBtn = Cell:CreateButton(drPane, L["Glow Options"], "accent", {105, 17})
    drGlowOptionsBtn:SetPoint("TOPRIGHT", drPane)
    drGlowOptionsBtn:SetScript("OnClick", function()
        whichGlowOption = "dispelRequest"
        Cell:StopRainbowText(srGlowOptionsBtn:GetFontString())
        local fs = drGlowOptionsBtn:GetFontString()
        if fs.rainbow then
            Cell:StopRainbowText(fs)
        else
            Cell:StartRainbowText(fs)
        end
        F:ShowGlowOptions(glowsTab, "dispelRequest", CellDB["glows"]["dispelRequest"]["glowOptions"])
    end)
    drGlowOptionsBtn:SetScript("OnHide", function()
        Cell:StopRainbowText(drGlowOptionsBtn:GetFontString())
    end)
    Cell:RegisterForCloseDropdown(drGlowOptionsBtn)

    local drTips = drPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    drTips:SetPoint("TOPLEFT", 5, -25)
    drTips:SetText(L["Glow unit button when a group member sends a %s request"]:format(Cell:GetAccentColorString()..L["DISPEL"].."|r"))

    -- enabled ----------------------------------------------------------------------
    drEnabledCB = Cell:CreateCheckButton(drPane, L["Enabled"], function(checked, self)
        CellDB["glows"]["dispelRequest"]["enabled"] = checked
        UpdateDRWidgets()
        Cell:Fire("UpdateGlows", "dispelRequest")
        CellDropdownList:Hide()
        
        if whichGlowOption == "dispelRequest" then
            F:HideGlowOptions()
            Cell:StopRainbowText(drGlowOptionsBtn:GetFontString())
        end
    end)
    drEnabledCB:SetPoint("TOPLEFT", drPane, "TOPLEFT", 5, -45)
    ---------------------------------------------------------------------------------

    -- dispellable ------------------------------------------------------------------
    drDispellableCB = Cell:CreateCheckButton(drPane, L["Dispellable By Me"], function(checked, self)
        CellDB["glows"]["dispelRequest"]["dispellableByMe"] = checked
        Cell:Fire("UpdateGlows", "dispelRequest")
    end)
    drDispellableCB:SetPoint("TOPLEFT", drEnabledCB, "TOPLEFT", 200, 0)
    ---------------------------------------------------------------------------------

    -- response ---------------------------------------------------------------------
    drResponseDD = Cell:CreateDropdown(drPane, 345)
    drResponseDD:SetPoint("TOPLEFT", drEnabledCB, "BOTTOMLEFT", 0, -27)
    drResponseDD:SetItems({
        {
            ["text"] = L["Respond to all dispellable debuffs"],
            ["value"] = "all",
            ["onClick"] = function()
                CellDB["glows"]["dispelRequest"]["responseType"] = "all"
                UpdateDRWidgets()
                Cell:Fire("UpdateGlows", "dispelRequest")
            end
        },
        {
            ["text"] = L["Respond to specific dispellable debuffs"],
            ["value"] = "specific",
            ["onClick"] = function()
                CellDB["glows"]["dispelRequest"]["responseType"] = "specific"
                UpdateDRWidgets()
                Cell:Fire("UpdateGlows", "dispelRequest")
            end
        },
    })

    drResponseText = drPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    drResponseText:SetPoint("BOTTOMLEFT", drResponseDD, "TOPLEFT", 0, 1)
    drResponseText:SetText(L["Response Type"])
    ---------------------------------------------------------------------------------

    -- timeout ----------------------------------------------------------------------
    drTimeoutDD = Cell:CreateDropdown(drPane, 60)
    drTimeoutDD:SetPoint("TOPLEFT", drResponseDD, "TOPRIGHT", 7, 0)

    local items = {}
    local secs = {1, 2, 3, 4, 5, 10, 15, 20, 25, 30}
    for _, s in ipairs(secs) do
        tinsert(items, {
            ["text"] = s,
            ["value"] = s,
            ["onClick"] = function()
                CellDB["glows"]["dispelRequest"]["timeout"] = s
                Cell:Fire("UpdateGlows", "dispelRequest")
            end
        })
    end
    drTimeoutDD:SetItems(items)

    drTimeoutText = drPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    drTimeoutText:SetPoint("BOTTOMLEFT", drTimeoutDD, "TOPLEFT", 0, 1)
    drTimeoutText:SetText(L["Timeout"])
    ---------------------------------------------------------------------------------

    -- macro ------------------------------------------------------------------------
    drMacroText = drPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    drMacroText:SetPoint("TOPLEFT", drResponseDD, "BOTTOMLEFT", 0, -10)
    drMacroText:SetText(L["Macro"])

    drMacroEB = Cell:CreateEditBox(drPane, 357, 20)
    drMacroEB:SetPoint("TOP", drResponseDD, "BOTTOM", 0, -7)
    drMacroEB:SetPoint("LEFT", drMacroText, "RIGHT", 5, 0)
    drMacroEB:SetPoint("RIGHT", -5, 0)
    drMacroEB:SetText("/run C_ChatInfo.SendAddonMessage(\"CELL_REQ_D\",\"D\",\"RAID\")")
    drMacroEB:SetCursorPosition(0)
    drMacroEB:SetScript("OnTextChanged", function(self, userChanged)
        if userChanged then
            drMacroEB:SetText("/run C_ChatInfo.SendAddonMessage(\"CELL_REQ_D\",\"D\",\"RAID\")")
            drMacroEB:SetCursorPosition(0)
            drMacroEB:HighlightText()
        end
    end)
    drMacroEB.gauge = srMacroEB:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    drMacroEB.gauge:SetText(drMacroEB:GetText())
    drMacroEB:SetScript("OnEditFocusGained", function()
        local requiredWidth = drMacroEB.gauge:GetStringWidth()
        if requiredWidth > drMacroEB:GetWidth() then
            drMacroEB:ClearAllPoints()
            drMacroEB:SetPoint("TOP", drResponseDD, "BOTTOM", 0, -7)
            drMacroEB:SetPoint("LEFT", drMacroText, "RIGHT", 5, 0)
            drMacroEB:SetWidth(requiredWidth + 20)
            drMacroEB:HighlightText()
        end
    end)
    drMacroEB:SetScript("OnEditFocusLost", function()
        drMacroEB:ClearAllPoints()
        drMacroEB:SetPoint("TOP", drResponseDD, "BOTTOM", 0, -7)
        drMacroEB:SetPoint("LEFT", drMacroText, "RIGHT", 5, 0)
        drMacroEB:SetPoint("RIGHT", -5, 0)
        drMacroEB:SetCursorPosition(0)
        drMacroEB:HighlightText(0, 0)
    end)
    ---------------------------------------------------------------------------------

    -- debuffs ----------------------------------------------------------------------
    drDebuffsEB = Cell:CreateEditBox(drPane, 357, 20)
    drDebuffsEB:SetPoint("TOP", drMacroEB, "BOTTOM", 0, -25)
    drDebuffsEB:SetPoint("LEFT", 5, 0)
    drDebuffsEB:SetPoint("RIGHT", -5, 0)
    drDebuffsEB:SetScript("OnTextChanged", function(self, userChanged)
        if userChanged then
            CellDB["glows"]["dispelRequest"]["debuffs"] = F:StringToTable(drDebuffsEB:GetText(), " ", true)
            drDebuffsEB.gauge:SetText(drDebuffsEB:GetText())
            Cell:Fire("UpdateGlows", "dispelRequest")
        end
    end)
    drDebuffsEB.gauge = srMacroEB:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    drDebuffsEB:SetScript("OnEditFocusGained", function()
        local requiredWidth = drDebuffsEB.gauge:GetStringWidth()
        if requiredWidth > drDebuffsEB:GetWidth() then
            drDebuffsEB:ClearAllPoints()
            drDebuffsEB:SetPoint("TOP", drMacroEB, "BOTTOM", 0, -25)
            drDebuffsEB:SetPoint("LEFT", 5, 0)
            drDebuffsEB:SetWidth(requiredWidth + 20)
            drDebuffsEB:HighlightText()
        end
    end)
    drDebuffsEB:SetScript("OnEditFocusLost", function()
        drDebuffsEB:ClearAllPoints()
        drDebuffsEB:SetPoint("TOP", drMacroEB, "BOTTOM", 0, -25)
        drDebuffsEB:SetPoint("LEFT", 5, 0)
        drDebuffsEB:SetPoint("RIGHT", -5, 0)
        drDebuffsEB:SetCursorPosition(0)
        drDebuffsEB:HighlightText(0, 0)
    end)

    drDebuffsText = drPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    drDebuffsText:SetPoint("BOTTOMLEFT", drDebuffsEB, "TOPLEFT", 0, 1)
    drDebuffsText:SetText(L["Debuffs"].." ("..L["IDs separated by whitespaces"]..")")
    ---------------------------------------------------------------------------------
end

-------------------------------------------------
-- show
-------------------------------------------------
local init
local function ShowTab(tab)
    if tab == "glows" then
        if not init then
            CreateSRPane()
            CreateSpellEditFrame()
            CreateDRPane()
        end
        
        glowsTab:Show()

        if init then return end
        init = true

        -- spell request
        srEnabledCB:SetChecked(CellDB["glows"]["spellRequest"]["enabled"])
        srExistsCB:SetChecked(CellDB["glows"]["spellRequest"]["checkIfExists"])
        srKnownOnlyCB:SetChecked(CellDB["glows"]["spellRequest"]["knownSpellsOnly"])
        srFreeCDOnlyCB:SetChecked(CellDB["glows"]["spellRequest"]["freeCooldownOnly"])
        srReplyCDCB:SetChecked(CellDB["glows"]["spellRequest"]["replyCooldown"])
        srReplyCastEB:SetText(CellDB["glows"]["spellRequest"]["replyAfterCast"] or "")
        if not CellDB["glows"]["spellRequest"]["replyAfterCast"] then
            srReplyCastEB.tip:Show()
        end
        srResponseDD:SetSelectedValue(CellDB["glows"]["spellRequest"]["responseType"])
        srTimeoutDD:SetSelected(CellDB["glows"]["spellRequest"]["timeout"])
        UpdateSRWidgets()
        HideSpellOptions()
        LoadSpellsDropdown()
        
        -- dispel request
        drEnabledCB:SetChecked(CellDB["glows"]["dispelRequest"]["enabled"])
        drDispellableCB:SetChecked(CellDB["glows"]["dispelRequest"]["dispellableByMe"])
        drResponseDD:SetSelectedValue(CellDB["glows"]["dispelRequest"]["responseType"])
        drTimeoutDD:SetSelected(CellDB["glows"]["dispelRequest"]["timeout"])
        drDebuffsEB:SetText(F:TableToString(CellDB["glows"]["dispelRequest"]["debuffs"], " "))
        drDebuffsEB.gauge:SetText(drDebuffsEB:GetText())
        drDebuffsEB:SetCursorPosition(0)
        UpdateDRWidgets()
    else
        glowsTab:Hide()
    end
end
Cell:RegisterCallback("ShowOptionsTab", "GlowsTab_ShowTab", ShowTab)