local _, Cell = ...
local L = Cell.L
local F = Cell.funcs
local P = Cell.pixelPerfectFuncs

local readyBtn, pullBtn

local buttonsFrame = CreateFrame("Frame", "CellReadyAndPullFrame", Cell.frames.mainFrame, "BackdropTemplate")
Cell.frames.readyAndPullFrame = buttonsFrame
P:Size(buttonsFrame, 60, 55)
buttonsFrame:SetPoint("TOPRIGHT", UIParent, "CENTER")
buttonsFrame:SetClampedToScreen(true)
buttonsFrame:SetMovable(true)
buttonsFrame:RegisterForDrag("LeftButton")
buttonsFrame:SetScript("OnDragStart", function()
    buttonsFrame:StartMoving()
    buttonsFrame:SetUserPlaced(false)
end)
buttonsFrame:SetScript("OnDragStop", function()
    buttonsFrame:StopMovingOrSizing()
    P:SavePosition(buttonsFrame, CellDB["tools"]["readyAndPull"][3])
end)

-------------------------------------------------
-- mover
-------------------------------------------------
buttonsFrame.moverText = buttonsFrame:CreateFontString(nil, "OVERLAY", "CELL_FONT_WIDGET")
buttonsFrame.moverText:SetPoint("TOP", 0, -3)
buttonsFrame.moverText:SetText(L["Mover"])
buttonsFrame.moverText:Hide()

local function ShowMover(show)
    if show then
        if not CellDB["tools"]["readyAndPull"][1] then return end
        buttonsFrame:EnableMouse(true)
        buttonsFrame.moverText:Show()
        Cell:StylizeFrame(buttonsFrame, {0, 1, 0, 0.4}, {0, 0, 0, 0})
        if not F:HasPermission() then -- button not shown
            readyBtn:Show()
            pullBtn:Show()
        end
    else
        buttonsFrame:EnableMouse(false)
        buttonsFrame.moverText:Hide()
        Cell:StylizeFrame(buttonsFrame, {0, 0, 0, 0}, {0, 0, 0, 0})
        if not F:HasPermission() then -- button should not shown
            readyBtn:Hide()
            pullBtn:Hide()
        end
    end
end
Cell:RegisterCallback("ShowMover", "RaidButtons_ShowMover", ShowMover)

-------------------------------------------------
-- pull
-------------------------------------------------
pullBtn = Cell:CreateStatusBarButton(buttonsFrame, L["Pull"], {60, 17}, 7, "SecureActionButtonTemplate")
pullBtn:SetPoint("BOTTOMLEFT")
if Cell.isRetail then
    -- NOTE: ActionButtonUseKeyDown will affect this
    pullBtn:RegisterForClicks("LeftButtonUp", "RightButtonUp", "LeftButtonDown", "RightButtonDown")
else
    pullBtn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
end
pullBtn:Hide()

-------------------------------------------------
-- pull bar
-------------------------------------------------
pullBtn:SetScript("OnEvent", function(self, event, ...)
    self[event](self, ...)
end)

local pullTicker, isPullTickerRunning
local function Start(sec, sendToChat)
    isPullTickerRunning = true
    pullBtn:SetMaxValue(sec)
    pullBtn:Start()
    
    -- update button text
    pullBtn:SetText(sec)
    if pullTicker then
        pullTicker:Cancel()
        pullTicker = nil
    end
    pullBtn.sec = sec
    pullTicker = C_Timer.NewTicker(1, function()
        pullBtn.sec = pullBtn.sec - 1
        if pullBtn.sec == 0 then
            isPullTickerRunning = false
            pullBtn:SetText(L["Go!"])
            if sendToChat then
                SendChatMessage(L["Go!"], IsInRaid() and "RAID_WARNING" or "PARTY")
            end
        elseif pullBtn.sec == -1 then
            pullBtn:SetText(L["Pull"])
        else
            pullBtn:SetText(pullBtn.sec)
            if sendToChat then
                if pullBtn.sec > 3 then
                    SendChatMessage(pullBtn.sec, IsInRaid() and "RAID" or "PARTY")
                else
                    SendChatMessage(pullBtn.sec, IsInRaid() and "RAID_WARNING" or "PARTY")
                end
            end
        end
    end, sec+1)
end

local function Stop()
    isPullTickerRunning = false
    pullBtn:Stop()
           
    -- update button text
    pullBtn:SetText(L["Pull"])
    if pullTicker then
        pullTicker:Cancel()
        pullTicker = nil
    end
end

function pullBtn:CHAT_MSG_ADDON(prefix, text)
    if prefix == "D4" then -- DBM
        local pre, sec = strsplit("\t", text)
        sec = tonumber(sec)
        if pre == "PT" and sec > 0 then -- start
            Start(sec)
        elseif pre == "PT" and sec  == 0 then -- cancel
            Stop()
        end

    -- elseif prefix == "BigWigs" then
    --     local _, pre, sec = strsplit("^", text)
    --     sec = tonumber(sec)
    --     if pre == "Pull" and sec > 0 then -- start
    --     elseif pre == "Pull" and sec  == 0 then -- cancel
    --     end
    end
end

function pullBtn:START_TIMER(timerType, timeRemaining, totalTime)
    if totalTime > 0 then
        Start(totalTime)
    else
        Stop()
    end
end

-------------------------------------------------
-- ready
-------------------------------------------------
readyBtn = Cell:CreateStatusBarButton(buttonsFrame, L["Ready"], {60, 17}, 35)
P:Point(readyBtn, "BOTTOMLEFT", pullBtn, "TOPLEFT", 0, 3)
-- P:Point(readyBtn, "BOTTOMRIGHT", pullBtn, "TOPRIGHT", 0, 3)
readyBtn:Hide()

readyBtn:RegisterForClicks("LeftButtonDown", "RightButtonDown")
readyBtn:SetScript("OnClick", function(self, button)
    if button == "LeftButton" then
        DoReadyCheck()
    else
        InitiateRolePoll()
    end
end)
readyBtn:RegisterEvent("READY_CHECK")
readyBtn:RegisterEvent("READY_CHECK_FINISHED")
readyBtn:RegisterEvent("READY_CHECK_CONFIRM")

local ready = {}
readyBtn:SetScript("OnEvent", function(self, event, arg1, arg2)
    if event == "READY_CHECK" then
        readyBtn:SetMaxValue(arg2)
        readyBtn:Start()
        wipe(ready)
        tinsert(ready, "player")
        readyBtn:SetText("1 / "..GetNumGroupMembers())
    elseif event == "READY_CHECK_FINISHED" then
        readyBtn:Stop()
        readyBtn:SetText(L["Ready"])
    else
        if arg2 then -- isReady
            if IsInRaid() then
                if string.find(arg1, "raid") then tinsert(ready, arg1) end
            else
                tinsert(ready, arg1)
            end
            readyBtn:SetText(#ready.." / "..GetNumGroupMembers())
        end
    end
end)

-------------------------------------------------
-- functions
-------------------------------------------------
local function CheckPermission()
    if InCombatLockdown() then
        buttonsFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
    else
        buttonsFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
        if F:HasPermission() and CellDB["tools"]["readyAndPull"][1] then
            readyBtn:Show()
            readyBtn:SetEnabled(true)
            pullBtn:Show()
            pullBtn:SetEnabled(true)
        else
            readyBtn:Hide()
            readyBtn:SetEnabled(false)
            pullBtn:Hide()
            pullBtn:SetEnabled(false)
        end
    end
end

buttonsFrame:SetScript("OnEvent", function()
    CheckPermission()
end)

Cell:RegisterCallback("PermissionChanged", "RaidButtons_PermissionChanged", CheckPermission)

local function UpdateTools(which)
    if not which or which == "buttons" then
        CheckPermission()
        ShowMover(Cell.vars.showMover and CellDB["tools"]["readyAndPull"][1])
    end

    if not which or which == "pullTimer" then
        pullBtn:UnregisterAllEvents()
        pullBtn:SetScript("OnMouseUp", nil)
        pullBtn:SetAttribute("type1", "macro")
        pullBtn:SetAttribute("type2", "macro")

        if CellDB["tools"]["readyAndPull"][2][1] == "mrt" then
            pullBtn:RegisterEvent("CHAT_MSG_ADDON")
            pullBtn:SetAttribute("macrotext1", "/ert pull "..CellDB["tools"]["readyAndPull"][2][2])
            pullBtn:SetAttribute("macrotext2", "/ert pull 0")
        elseif CellDB["tools"]["readyAndPull"][2][1] == "dbm" then
            pullBtn:RegisterEvent("CHAT_MSG_ADDON")
            pullBtn:SetAttribute("macrotext1", "/dbm pull "..CellDB["tools"]["readyAndPull"][2][2])
            pullBtn:SetAttribute("macrotext2", "/dbm pull 0")
        elseif CellDB["tools"]["readyAndPull"][2][1] == "bw" then
            pullBtn:RegisterEvent("CHAT_MSG_ADDON")
            pullBtn:SetAttribute("macrotext1", "/pull "..CellDB["tools"]["readyAndPull"][2][2])
            pullBtn:SetAttribute("macrotext2", "/pull 0")
        else -- default
            if Cell.isRetail then
                -- C_PartyInfo.DoCountdown(CellDB["tools"]["readyAndPull"][2][2])
                pullBtn:RegisterEvent("START_TIMER")
                pullBtn:SetAttribute("macrotext1", "/cd "..CellDB["tools"]["readyAndPull"][2][2])
                pullBtn:SetAttribute("macrotext2", "/cd 0")
            else
                pullBtn:SetAttribute("type1", nil)
                pullBtn:SetAttribute("type2", nil)
                pullBtn:SetScript("OnMouseUp", function(self, button)
                    if button == "LeftButton" then
                        SendChatMessage(L["Pull in %d sec"]:format(CellDB["tools"]["readyAndPull"][2][2]), IsInRaid() and "RAID_WARNING" or "PARTY")
                        Start(CellDB["tools"]["readyAndPull"][2][2], true)
                    else
                        if isPullTickerRunning then
                            SendChatMessage(L["Pull timer cancelled"], IsInRaid() and "RAID_WARNING" or "PARTY")
                            Stop()
                        end
                    end
                end)
            end
        end
    end

    if not which then -- position
        P:LoadPosition(buttonsFrame, CellDB["tools"]["readyAndPull"][3])
    end
end
Cell:RegisterCallback("UpdateTools", "RaidButtons_UpdateTools", UpdateTools)

local function UpdatePixelPerfect()
    P:Resize(buttonsFrame)
    readyBtn:UpdatePixelPerfect()
    pullBtn:UpdatePixelPerfect()
end
Cell:RegisterCallback("UpdatePixelPerfect", "RaidButtons_UpdatePixelPerfect", UpdatePixelPerfect)