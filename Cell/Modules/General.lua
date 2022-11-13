local _, Cell = ...
local L = Cell.L
local F = Cell.funcs
local P = Cell.pixelPerfectFuncs
local LCG = LibStub("LibCustomGlow-1.0")

local generalTab = Cell:CreateFrame("CellOptionsFrame_GeneralTab", Cell.frames.optionsFrame, nil, nil, true)
Cell.frames.generalTab = generalTab
generalTab:SetAllPoints(Cell.frames.optionsFrame)
generalTab:Hide()

-------------------------------------------------
-- visibility
-------------------------------------------------
local showSoloCB, showPartyCB, hideBlizzardPartyCB, hideBlizzardRaidCB

local function CreateVisibilityPane()
    local visibilityPane = Cell:CreateTitledPane(generalTab, L["Visibility"], 205, 110)
    visibilityPane:SetPoint("TOPLEFT", generalTab, "TOPLEFT", 5, -5)
    
    showSoloCB = Cell:CreateCheckButton(visibilityPane, L["Show Solo"], function(checked, self)
        CellDB["general"]["showSolo"] = checked
        Cell:Fire("UpdateVisibility", "solo")
    end, L["Show Solo"], L["Show while not in a group"], L["To open options frame, use /cell options"])
    showSoloCB:SetPoint("TOPLEFT", visibilityPane, "TOPLEFT", 5, -27)
    
    showPartyCB = Cell:CreateCheckButton(visibilityPane, L["Show Party"], function(checked, self)
        CellDB["general"]["showParty"] = checked
        Cell:Fire("UpdateVisibility", "party")
    end, L["Show Party"], L["Show while in a party"], L["To open options frame, use /cell options"])
    showPartyCB:SetPoint("TOPLEFT", showSoloCB, "BOTTOMLEFT", 0, -7)
    
    hideBlizzardPartyCB = Cell:CreateCheckButton(visibilityPane, L["Hide Blizzard Party"], function(checked, self)
        CellDB["general"]["hideBlizzardParty"] = checked
    
        local popup = Cell:CreateConfirmPopup(generalTab, 200, L["A UI reload is required.\nDo it now?"], function()
            ReloadUI()
        end, nil, true)
        popup:SetPoint("TOPLEFT", generalTab, 117, -77)
    end, L["Hide Blizzard Frames"], L["Require reload of the UI"])
    hideBlizzardPartyCB:SetPoint("TOPLEFT", showPartyCB, "BOTTOMLEFT", 0, -7)
   
    hideBlizzardRaidCB = Cell:CreateCheckButton(visibilityPane, L["Hide Blizzard Raid"], function(checked, self)
        CellDB["general"]["hideBlizzardRaid"] = checked
    
        local popup = Cell:CreateConfirmPopup(generalTab, 200, L["A UI reload is required.\nDo it now?"], function()
            ReloadUI()
        end, nil, true)
        popup:SetPoint("TOPLEFT", generalTab, 117, -77)
    end, L["Hide Blizzard Frames"], L["Require reload of the UI"])
    hideBlizzardRaidCB:SetPoint("TOPLEFT", hideBlizzardPartyCB, "BOTTOMLEFT", 0, -7)
end

-------------------------------------------------
-- tooltip
-------------------------------------------------
local enableTooltipsCB, hideTooltipsInCombatCB, tooltipsAnchor, tooltipsAnchorText, tooltipsAnchoredTo, tooltipsAnchoredToText, tooltipsX, tooltipsY

local function UpdateTooltipsOptions()
    if strfind(CellDB["general"]["tooltipsPosition"][2], "Cursor") or CellDB["general"]["tooltipsPosition"][2] == "Default" then
        tooltipsAnchor:SetEnabled(false)
        tooltipsAnchorText:SetTextColor(0.4, 0.4, 0.4)
    else
        tooltipsAnchor:SetEnabled(true)
        tooltipsAnchorText:SetTextColor(1, 1, 1)
    end

    if CellDB["general"]["tooltipsPosition"][2] == "Cursor" or CellDB["general"]["tooltipsPosition"][2] == "Default" then
        tooltipsX:SetEnabled(false)
        tooltipsY:SetEnabled(false)
    else
        tooltipsX:SetEnabled(true)
        tooltipsY:SetEnabled(true)
    end
end

local function CreateTooltipsPane()
    local tooltipsPane = Cell:CreateTitledPane(generalTab, L["Tooltips"], 205, 280)
    tooltipsPane:SetPoint("TOPLEFT", generalTab, "TOPLEFT", 222, -5)

    enableTooltipsCB = Cell:CreateCheckButton(tooltipsPane, L["Enabled"], function(checked, self)
        CellDB["general"]["enableTooltips"] = checked
        hideTooltipsInCombatCB:SetEnabled(checked)
        -- enableAuraTooltipsCB:SetEnabled(checked)
        tooltipsAnchor:SetEnabled(checked)
        tooltipsAnchoredTo:SetEnabled(checked)
        tooltipsX:SetEnabled(checked)
        tooltipsY:SetEnabled(checked)
        if checked then
            tooltipsAnchorText:SetTextColor(1, 1, 1)
            tooltipsAnchoredToText:SetTextColor(1, 1, 1)
            UpdateTooltipsOptions()
        else
            tooltipsAnchorText:SetTextColor(0.4, 0.4, 0.4)
            tooltipsAnchoredToText:SetTextColor(0.4, 0.4, 0.4)
        end
    end)
    enableTooltipsCB:SetPoint("TOPLEFT", tooltipsPane, "TOPLEFT", 5, -27)

    hideTooltipsInCombatCB = Cell:CreateCheckButton(tooltipsPane, L["Hide in Combat"], function(checked, self)
        CellDB["general"]["hideTooltipsInCombat"] = checked
    end)
    hideTooltipsInCombatCB:SetPoint("TOPLEFT", enableTooltipsCB, "BOTTOMLEFT", 0, -7)

    -- auras tooltips
    -- enableAuraTooltipsCB = Cell:CreateCheckButton(tooltipsPane, L["Enable Auras Tooltips"].." (pending)", function(checked, self)
    -- end)
    -- enableAuraTooltipsCB:SetPoint("TOPLEFT", hideTooltipsInCombatCB, "BOTTOMLEFT", 0, -7)
    -- enableAuraTooltipsCB:SetEnabled(false)

    -- position
    tooltipsAnchor = Cell:CreateDropdown(tooltipsPane, 137)
    tooltipsAnchor:SetPoint("TOPLEFT", hideTooltipsInCombatCB, "BOTTOMLEFT", 0, -25)
    local points = {"BOTTOM", "BOTTOMLEFT", "BOTTOMRIGHT", "LEFT", "RIGHT", "TOP", "TOPLEFT", "TOPRIGHT"}
    local relativePoints = {"TOP", "TOPLEFT", "TOPRIGHT", "RIGHT", "LEFT", "BOTTOM", "BOTTOMLEFT", "BOTTOMRIGHT"}
    local anchorItems = {}
    for i, point in pairs(points) do
        tinsert(anchorItems, {
            ["text"] = L[point],
            ["value"] = point,
            ["onClick"] = function()
                CellDB["general"]["tooltipsPosition"][1] = point
                CellDB["general"]["tooltipsPosition"][3] = relativePoints[i]
            end,
        })
    end
    tooltipsAnchor:SetItems(anchorItems)

    tooltipsAnchorText = tooltipsPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    tooltipsAnchorText:SetText(L["Anchor Point"])
    tooltipsAnchorText:SetPoint("BOTTOMLEFT", tooltipsAnchor, "TOPLEFT", 0, 1)

    tooltipsAnchoredTo = Cell:CreateDropdown(tooltipsPane, 137)
    tooltipsAnchoredTo:SetPoint("TOPLEFT", tooltipsAnchor, "BOTTOMLEFT", 0, -25)
    local relatives = {"Default", "Cell", "Unit Button", "Cursor", "Cursor Left", "Cursor Right"}
    local relativeToItems = {}
    for _, relative in pairs(relatives) do
        tinsert(relativeToItems, {
            ["text"] = L[relative],
            ["value"] = relative,
            ["onClick"] = function()
                CellDB["general"]["tooltipsPosition"][2] = relative
                UpdateTooltipsOptions()
            end,
        })
    end
    tooltipsAnchoredTo:SetItems(relativeToItems)

    tooltipsAnchoredToText = tooltipsPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    tooltipsAnchoredToText:SetText(L["Anchored To"])
    tooltipsAnchoredToText:SetPoint("BOTTOMLEFT", tooltipsAnchoredTo, "TOPLEFT", 0, 1)

    tooltipsX = Cell:CreateSlider(L["X Offset"], tooltipsPane, -100, 100, 137, 1)
    tooltipsX:SetPoint("TOPLEFT", tooltipsAnchoredTo, "BOTTOMLEFT", 0, -25)
    tooltipsX.afterValueChangedFn = function(value)
        CellDB["general"]["tooltipsPosition"][4] = value
    end

    tooltipsY = Cell:CreateSlider(L["Y Offset"], tooltipsPane, -100, 100, 137, 1)
    tooltipsY:SetPoint("TOPLEFT", tooltipsX, "BOTTOMLEFT", 0, -40)
    tooltipsY.afterValueChangedFn = function(value)
        CellDB["general"]["tooltipsPosition"][5] = value
    end
end

-------------------------------------------------
-- misc
-------------------------------------------------
local useCleuCB, sortByRoleCB, lockCB, fadeoutCB, menuPositionDD

local function CreateMiscPane()
    local miscPane = Cell:CreateTitledPane(generalTab, L["Misc"], 205, 185)
    miscPane:SetPoint("TOPLEFT", generalTab, 5, -134)
    
    useCleuCB = Cell:CreateCheckButton(miscPane, L["Increase Health Update Rate"], function(checked, self)
        CellDB["general"]["useCleuHealthUpdater"] = checked
        Cell:Fire("UpdateCLEU")
    end, "|cffff2727"..L["HIGH CPU USAGE"], L["Use CLEU events to increase health update rate"])
    useCleuCB:SetPoint("TOPLEFT", 5, -27)

    sortByRoleCB = Cell:CreateCheckButton(miscPane, L["Sort Party By Role"], function(checked, self)
        CellDB["general"]["sortPartyByRole"] = checked
        Cell:Fire("UpdateSortMethod")
    end)
    sortByRoleCB:SetPoint("TOPLEFT", useCleuCB, "BOTTOMLEFT", 0, -7)

    lockCB = Cell:CreateCheckButton(miscPane, L["Lock Cell Frame"], function(checked, self)
        CellDB["general"]["locked"] = checked
        Cell:Fire("UpdateMenu", "lock")
    end)
    lockCB:SetPoint("TOPLEFT", sortByRoleCB, "BOTTOMLEFT", 0, -7)
    
    fadeoutCB = Cell:CreateCheckButton(miscPane, L["Fade Out Menu"], function(checked, self)
        CellDB["general"]["fadeOut"] = checked
        Cell:Fire("UpdateMenu", "fadeOut")
    end, L["Fade Out Menu"], L["Fade out menu buttons on mouseout"])
    fadeoutCB:SetPoint("TOPLEFT", lockCB, "BOTTOMLEFT", 0, -7)

    menuPositionDD = Cell:CreateDropdown(miscPane, 137)
    menuPositionDD:SetPoint("TOPLEFT", fadeoutCB, "BOTTOMLEFT", 0, -25)
    menuPositionDD:SetItems({
        {
            ["text"] = L["TOP"].." / "..L["BOTTOM"],
            ["value"] = "top_bottom",
            ["onClick"] = function()
                CellDB["general"]["menuPosition"] = "top_bottom"
                Cell:Fire("UpdateMenu", "position")
            end,
        },
        {
            ["text"] = L["LEFT"].." / "..L["RIGHT"],
            ["value"] = "left_right",
            ["onClick"] = function()
                CellDB["general"]["menuPosition"] = "left_right"
                Cell:Fire("UpdateMenu", "position")
            end,
        },
    })

    local menuPositionText = miscPane:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
    menuPositionText:SetText(L["Menu Position"])
    menuPositionText:SetPoint("BOTTOMLEFT", menuPositionDD, "TOPLEFT", 0, 1)

    -- nickname options
    local nicknameOptionsBtn = Cell:CreateButton(miscPane, L["Nickname Options"], "accent-hover", {137, 20})
    nicknameOptionsBtn:SetPoint("TOPLEFT", menuPositionDD, "BOTTOMLEFT", 0, -13)
    Cell.frames.generalTab.nicknameOptionsBtn = nicknameOptionsBtn
    nicknameOptionsBtn:SetScript("OnClick", function()
        F:ShowNicknameOptions()
    end)
end

-------------------------------------------------
-- raid tools
-------------------------------------------------
local resCB, reportCB, buffCB, readyPullCB, pullDropdown, secEditBox, marksBarCB, marksDropdown

local function CreateToolsPane()
    local toolsPane = Cell:CreateTitledPane(generalTab, L["Raid Tools"].." |cFF777777"..L["only in group"], 422, 107)
    toolsPane:SetPoint("TOPLEFT", 5, -340)

    local unlockBtn = Cell:CreateButton(toolsPane, L["Unlock"], "accent", {70, 17})
    unlockBtn:SetPoint("TOPRIGHT", toolsPane)
    unlockBtn.locked = true
    unlockBtn:SetScript("OnClick", function(self)
        if self.locked then
            unlockBtn:SetText(L["Lock"])
            self.locked = false
            Cell.vars.showMover = true
            LCG.PixelGlow_Start(unlockBtn, {0,1,0,1}, 9, 0.25, 8, 1)
        else
            unlockBtn:SetText(L["Unlock"])
            self.locked = true
            Cell.vars.showMover = false
            LCG.PixelGlow_Stop(unlockBtn)
        end
        Cell:Fire("ShowMover", Cell.vars.showMover)
    end)

    -- battle res
    resCB = Cell:CreateCheckButton(toolsPane, L["Battle Res Timer"], function(checked, self)
        CellDB["tools"]["showBattleRes"] = checked
        Cell:Fire("UpdateTools", "battleRes")
    end, L["Battle Res Timer"], L["Only show during encounter or in mythic+"])
    resCB:SetPoint("TOPLEFT", toolsPane, "TOPLEFT", 5, -27)
    resCB:SetEnabled(Cell.isRetail)

    -- death report
    reportCB = Cell:CreateCheckButton(toolsPane, L["Death Report"], function(checked, self)
        CellDB["tools"]["deathReport"][1] = checked
        Cell:Fire("UpdateTools", "deathReport")
    end)
    reportCB:SetPoint("TOPLEFT", resCB, "TOPLEFT", 139, 0)
    reportCB:HookScript("OnEnter", function()
        CellTooltip:SetOwner(reportCB, "ANCHOR_TOPLEFT", 0, 2)
        CellTooltip:AddLine(L["Death Report"].." |cffff2727"..L["HIGH CPU USAGE"])
        CellTooltip:AddLine("|cffff2727" .. L["Disabled in battlegrounds and arenas"])
        CellTooltip:AddLine("|cffffffff" .. L["Report deaths to group"])
        CellTooltip:AddLine("|cffffffff" .. L["Use |cFFFFB5C5/cell report X|r to set the number of reports during a raid encounter"])
        CellTooltip:AddLine("|cffffffff" .. L["Current"]..": |cFFFFB5C5"..(CellDB["tools"]["deathReport"][2]==0 and L["all"] or string.format(L["first %d"], CellDB["tools"]["deathReport"][2])))
        CellTooltip:Show()
    end)
    reportCB:HookScript("OnLeave", function()
        CellTooltip:Hide()
    end)

    -- buff tracker
    buffCB = Cell:CreateCheckButton(toolsPane, L["Buff Tracker"], function(checked, self)
        CellDB["tools"]["buffTracker"][1] = checked
        Cell:Fire("UpdateTools", "buffTracker")
    end, L["Buff Tracker"].." |cffff7727"..L["MODERATE CPU USAGE"], L["Check if your group members need some raid buffs"], 
    Cell.isRetail and L["|cffffb5c5Left-Click:|r cast the spell"] or "|cffffb5c5(Shift)|r "..L["|cffffb5c5Left-Click:|r cast the spell"], 
    L["|cffffb5c5Right-Click:|r report unaffected"], 
    L["Use |cFFFFB5C5/cell buff X|r to set icon size"], 
    "|cffffffff" .. L["Current"]..": |cFFFFB5C5"..CellDB["tools"]["buffTracker"][3])
    buffCB:SetPoint("TOPLEFT", reportCB, "TOPLEFT", 139, 0)

    -- ready & pull
    readyPullCB = Cell:CreateCheckButton(toolsPane, L["ReadyCheck and PullTimer buttons"], function(checked, self)
        CellDB["tools"]["readyAndPull"][1] = checked
        pullDropdown:SetEnabled(checked)
        secEditBox:SetEnabled(checked)
        Cell:Fire("UpdateTools", "buttons")
    end, L["ReadyCheck and PullTimer buttons"], L["Only show when you have permission to do this"], L["readyCheckTips"], L["pullTimerTips"])
    readyPullCB:SetPoint("TOPLEFT", resCB, "BOTTOMLEFT", 0, -15)
    Cell:RegisterForCloseDropdown(readyPullCB)

    pullDropdown = Cell:CreateDropdown(toolsPane, 90)
    pullDropdown:SetPoint("TOP", readyPullCB, 0, 3)
    pullDropdown:SetPoint("LEFT", readyPullCB.label, "RIGHT", 5, 0)
    pullDropdown:SetItems({
        {
            ["text"] = L["Default"],
            ["value"] = "default",
            ["onClick"] = function()
                CellDB["tools"]["readyAndPull"][2][1] = "default"
                Cell:Fire("UpdateTools", "pullTimer")
            end,
        },
        {
            ["text"] = "MRT",
            ["value"] = "mrt",
            ["onClick"] = function()
                CellDB["tools"]["readyAndPull"][2][1] = "mrt"
                Cell:Fire("UpdateTools", "pullTimer")
            end,
        },
        {
            ["text"] = "DBM",
            ["value"] = "dbm",
            ["onClick"] = function()
                CellDB["tools"]["readyAndPull"][2][1] = "dbm"
                Cell:Fire("UpdateTools", "pullTimer")
            end,
        },
        {
            ["text"] = "BigWigs",
            ["value"] = "bw",
            ["onClick"] = function()
                CellDB["tools"]["readyAndPull"][2][1] = "bw"
                Cell:Fire("UpdateTools", "pullTimer")
            end,
        },
    })

    secEditBox = Cell:CreateEditBox(toolsPane, 38, 20, false, false, true)
    secEditBox:SetPoint("TOPLEFT", pullDropdown, "TOPRIGHT", 5, 0)
    secEditBox:SetMaxLetters(3)

    secEditBox.confirmBtn = Cell:CreateButton(toolsPane, "OK", "accent", {27, 20})
    secEditBox.confirmBtn:SetPoint("TOPLEFT", secEditBox, "TOPRIGHT", P:Scale(-1), 0)
    secEditBox.confirmBtn:Hide()
    secEditBox.confirmBtn:SetScript("OnHide", function()
        secEditBox.confirmBtn:Hide()
    end)
    secEditBox.confirmBtn:SetScript("OnClick", function()
        CellDB["tools"]["readyAndPull"][2][2] = tonumber(secEditBox:GetText())
        Cell:Fire("UpdateTools", "pullTimer")
        secEditBox.confirmBtn:Hide()
    end)

    secEditBox:SetScript("OnTextChanged", function(self, userChanged)
        if userChanged then
            local newSec = tonumber(self:GetText())
            if newSec and newSec > 0 and newSec ~= CellDB["tools"]["readyAndPull"][2][2] then
                secEditBox.confirmBtn:Show()
            else
                secEditBox.confirmBtn:Hide()
            end
        end
    end)

    -- marks bar
    marksBarCB = Cell:CreateCheckButton(toolsPane, L["Marks Bar"], function(checked, self)
        CellDB["tools"]["marks"][1] = checked
        marksDropdown:SetEnabled(checked)
        Cell:Fire("UpdateTools", "marks")
    end, L["Marks Bar"], L["Only show when you have permission to do this"], L["marksTips"])
    marksBarCB:SetPoint("TOPLEFT", readyPullCB, "BOTTOMLEFT", 0, -15)
    Cell:RegisterForCloseDropdown(marksBarCB)

    marksDropdown = Cell:CreateDropdown(toolsPane, 200)
    -- marksDropdown:SetPoint("TOPLEFT", marksBarCB, "BOTTOMRIGHT", 5, -5)
    marksDropdown:SetPoint("TOP", marksBarCB, 0, 3)
    marksDropdown:SetPoint("LEFT", marksBarCB.label, "RIGHT", 5, 0)
    marksDropdown:SetItems({
        {
            ["text"] = L["Target Marks"].." ("..L["Horizontal"]..")",
            ["value"] = "target_h",
            ["onClick"] = function()
                CellDB["tools"]["marks"][2] = "target_h"
                Cell:Fire("UpdateTools", "marks")
            end,
        },
        {
            ["text"] = L["Target Marks"].." ("..L["Vertical"]..")",
            ["value"] = "target_v",
            ["onClick"] = function()
                CellDB["tools"]["marks"][2] = "target_v"
                Cell:Fire("UpdateTools", "marks")
            end,
        },
        {
            ["text"] = L["World Marks"].." ("..L["Horizontal"]..")",
            ["value"] = "world_h",
            ["disabled"] = Cell.isWrath,
            ["onClick"] = function()
                CellDB["tools"]["marks"][2] = "world_h"
                Cell:Fire("UpdateTools", "marks")
            end,
        },
        {
            ["text"] = L["World Marks"].." ("..L["Vertical"]..")",
            ["value"] = "world_v",
            ["disabled"] = Cell.isWrath,
            ["onClick"] = function()
                CellDB["tools"]["marks"][2] = "world_v"
                Cell:Fire("UpdateTools", "marks")
            end,
        },
        {
            ["text"] = L["Both"].." ("..L["Horizontal"]..")",
            ["value"] = "both_h",
            ["disabled"] = Cell.isWrath,
            ["onClick"] = function()
                CellDB["tools"]["marks"][2] = "both_h"
                Cell:Fire("UpdateTools", "marks")
            end,
        },
        {
            ["text"] = L["Both"].." ("..L["Vertical"]..")",
            ["value"] = "both_v",
            ["disabled"] = Cell.isWrath,
            ["onClick"] = function()
                CellDB["tools"]["marks"][2] = "both_v"
                Cell:Fire("UpdateTools", "marks")
            end,
        }
    })
end

-------------------------------------------------
-- functions
-------------------------------------------------
local init
local function ShowTab(tab)
    if tab == "general" then
        if not init then
            CreateVisibilityPane()
            CreateTooltipsPane()
            CreateMiscPane()
            CreateToolsPane()

            -- mask
            Cell:CreateMask(generalTab, nil, {1, -1, -1, 1})
            generalTab.mask:Hide()
        end 

        generalTab:Show()

        if init then return end
        init = true

        -- tooltips
        enableTooltipsCB:SetChecked(CellDB["general"]["enableTooltips"])
        hideTooltipsInCombatCB:SetEnabled(CellDB["general"]["enableTooltips"])
        hideTooltipsInCombatCB:SetChecked(CellDB["general"]["hideTooltipsInCombat"])
        -- enableAuraTooltipsCB:SetEnabled(CellDB["general"]["enableTooltips"])
        -- enableAuraTooltipsCB:SetChecked(CellDB["general"]["enableAurasTooltips"])
        tooltipsAnchor:SetEnabled(CellDB["general"]["enableTooltips"])
        tooltipsAnchor:SetSelectedValue(CellDB["general"]["tooltipsPosition"][1])
        tooltipsAnchoredTo:SetEnabled(CellDB["general"]["enableTooltips"])
        tooltipsAnchoredTo:SetSelectedValue(CellDB["general"]["tooltipsPosition"][2])
        tooltipsX:SetEnabled(CellDB["general"]["enableTooltips"])
        tooltipsX:SetValue(CellDB["general"]["tooltipsPosition"][4])
        tooltipsY:SetEnabled(CellDB["general"]["enableTooltips"])
        tooltipsY:SetValue(CellDB["general"]["tooltipsPosition"][5])
        if CellDB["general"]["enableTooltips"] then
            tooltipsAnchorText:SetTextColor(1, 1, 1)
            tooltipsAnchoredToText:SetTextColor(1, 1, 1)
            UpdateTooltipsOptions()
        else
            tooltipsAnchorText:SetTextColor(0.4, 0.4, 0.4)
            tooltipsAnchoredToText:SetTextColor(0.4, 0.4, 0.4)
        end

        -- visibility
        showSoloCB:SetChecked(CellDB["general"]["showSolo"])
        showPartyCB:SetChecked(CellDB["general"]["showParty"])
        hideBlizzardPartyCB:SetChecked(CellDB["general"]["hideBlizzardParty"])
        hideBlizzardRaidCB:SetChecked(CellDB["general"]["hideBlizzardRaid"])

        -- misc
        useCleuCB:SetChecked(CellDB["general"]["useCleuHealthUpdater"])
        sortByRoleCB:SetChecked(CellDB["general"]["sortPartyByRole"])
        lockCB:SetChecked(CellDB["general"]["locked"])
        fadeoutCB:SetChecked(CellDB["general"]["fadeOut"])
        menuPositionDD:SetSelectedValue(CellDB["general"]["menuPosition"])

        -- raid tools
        resCB:SetChecked(CellDB["tools"]["showBattleRes"])
        reportCB:SetChecked(CellDB["tools"]["deathReport"][1])
        buffCB:SetChecked(CellDB["tools"]["buffTracker"][1])

        readyPullCB:SetChecked(CellDB["tools"]["readyAndPull"][1])
        pullDropdown:SetSelectedValue(CellDB["tools"]["readyAndPull"][2][1])
        secEditBox:SetText(CellDB["tools"]["readyAndPull"][2][2])
        pullDropdown:SetEnabled(CellDB["tools"]["readyAndPull"][1])
        secEditBox:SetEnabled(CellDB["tools"]["readyAndPull"][1])

        marksDropdown:SetEnabled(CellDB["tools"]["marks"][1])
        marksBarCB:SetChecked(CellDB["tools"]["marks"][1])
        marksDropdown:SetSelectedValue(CellDB["tools"]["marks"][2])
    else
        generalTab:Hide()
    end
end
Cell:RegisterCallback("ShowOptionsTab", "GeneralTab_ShowTab", ShowTab)