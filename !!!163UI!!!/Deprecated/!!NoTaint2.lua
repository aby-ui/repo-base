------------------------------------------------------------------------
-- !!NoTaint2, first-aid addon for Dragon Flight action bars taint.
-- Code by warbaby 2022-11 http://abyui.top https://github.com/aby-ui
-------------------------------------------------------------------------

if not NoTaint2_Proc_ResetActionButtonAction then
    NoTaint2_Proc_ResetActionButtonAction = 1

    local msg_short = "Action Bars are tainted\n/reload is RECOMMENDED"
    local msg_long = "!!NoTaint2：Your action bars are tainted by [|cffffff00%s|r], reload UI to prevent further damage."
    if LOCALE_zhCN then
        msg_short = "爱不易提醒：动作条被污染\n建议尽快/RELOAD"
        msg_long = "爱不易NoTaint2提醒您：动作条被[|cffffff00%s|r]|cffff0000污染|r，已紧急处理，建议|cffffff00尽快重载界面|r"
    end

    local last = 0
    function NoTaint2_ShowWarning(tainted_by)
        if GetTime() - last > 10 then
            if last == 0 then
                InvasionAlertSystem:AddAlert(nil, msg_short, false, 0, 0)
            end
            last = GetTime()
            DEFAULT_CHAT_FRAME:AddMessage(format(msg_long, tainted_by))
        end
    end

    function NoTaint2_ResetActionButtonAction(self)
        local ok, tainted_by = issecurevariable(self, "action")
        if not ok and not InCombatLockdown() then
            self.action=nil
            self:SetAttribute("_aby", "action")
            NoTaint2_ShowWarning(tainted_by)
        end
    end

    for _, v in ipairs(ActionBarButtonEventsFrame.frames) do
        hooksecurefunc(v, "UpdateAction", NoTaint2_ResetActionButtonAction)
    end

    local f1 = CreateFrame("Frame")
    f1:RegisterEvent("PLAYER_REGEN_ENABLED")
    f1:SetScript("OnEvent", function(self, event, ...)
        for _, v in ipairs(ActionBarButtonEventsFrame.frames) do
            NoTaint2_ResetActionButtonAction(v)
        end
    end)
end

if not NoTaint2_CleanStaticPopups then
    --code since !NoTaint, test: /run StaticPopup_Show('PARTY_INVITE',"a") /dump issecurevariable(StaticPopup1, "which")
    function NoTaint2_CleanStaticPopups()
        for index = 1, STATICPOPUP_NUMDIALOGS, 1 do
            local frame = _G["StaticPopup"..index];
            if not issecurevariable(frame, "which") then
                if frame:IsShown() then
                    local info = StaticPopupDialogs[frame.which];
                    if info and not issecurevariable(info, "OnCancel") then
                        info.OnCancel()
                    end
                    frame:Hide()
                end
                frame.which = nil
            end
        end
    end

    function NoTaint2_CleanDropDownList()
        local frameToShow = LFDQueueFrameTypeDropDown
        local parent = frameToShow:GetParent()
        frameToShow:SetParent(nil) --to show
        --RequestLFDPlayerLockInfo() --to trigger LFG_LOCK_INFO_RECEIVED
        frameToShow:SetParent(parent)
    end

    local global_obj_name = {
        UIDROPDOWNMENU_MAXBUTTONS = 1,
        UIDROPDOWNMENU_MAXLEVELS = 1,
        UIDROPDOWNMENU_OPEN_MENU = 1,
        UIDROPDOWNMENU_INIT_MENU = 1,
        OBJECTIVE_TRACKER_UPDATE_REASON = 1,
    }

    function NoTaint2_CleanGlobal(self)
        for k, _ in pairs(global_obj_name) do
            if not issecurevariable(k) then
                --print("clean", k, issecurevariable(k))
                _G[k] = nil
            end
        end
        --ObjectiveTrackerFrame.lastMapID = nil
    end

    hooksecurefunc(EditModeManagerFrame, "ClearActiveChangesFlags", function(self)
        for _, systemFrame in ipairs(self.registeredSystemFrames) do
            systemFrame:SetHasActiveChanges(nil);
        end
        self:SetHasActiveChanges(nil);
    end)

    -- not sure if this is of any use. PetFrame and ActionBar call it.
    hooksecurefunc(EditModeManagerFrame, "HideSystemSelections", function(self)
        if self.editModeActive == false then
            self.editModeActive = nil
        end
    end)

    hooksecurefunc(EditModeManagerFrame, "IsEditModeLocked", function()
        NoTaint2_CleanGlobal()
    end)

    local function cleanAll()
        NoTaint2_CleanDropDownList()
        NoTaint2_CleanStaticPopups()
        NoTaint2_CleanGlobal()
    end

    local Origin_IsShown = EditModeManagerFrame.IsShown
    hooksecurefunc(EditModeManagerFrame, "IsShown", function(self)
        if Origin_IsShown(self) then return end
        local stack = debugstack(4)
        --call from UIParent.lua if ( not frame or frame:IsShown() ) then
        --different when hooked
        if stack:find('[string "=[C]"]: in function `ShowUIPanel\'\n', 1, true) then
            cleanAll()
        end
    end)

    -- In case the stack check is failed, assure the game menu entrance.
    -- Running cleanAll() multi times has no side effects.
    GameMenuButtonEditMode:HookScript("PreClick", cleanAll)
end

if not NoTaint2_Proc_StopEnterWorldLayout then
    NoTaint2_Proc_StopEnterWorldLayout = 1
    local f2 = CreateFrame("Frame")
    f2:RegisterEvent("PLAYER_LEAVING_WORLD")
    f2:RegisterEvent("PLAYER_ENTERING_WORLD")
    f2:SetScript("OnEvent", function(self, event, ...)
        if event == "PLAYER_ENTERING_WORLD" then
            local login, reload = ...
            if not login and not reload then
                NoTaint2_CleanDropDownList()
                NoTaint2_CleanStaticPopups()
                NoTaint2_CleanGlobal()
            end
            EditModeManagerFrame:RegisterEvent("EDIT_MODE_LAYOUTS_UPDATED")
        elseif event == "PLAYER_LEAVING_WORLD" then
            EditModeManagerFrame:UnregisterEvent("EDIT_MODE_LAYOUTS_UPDATED")
        end
    end)
end

if not NoTaint2_Proc_CleanActionButtonFlyout then
    NoTaint2_Proc_CleanActionButtonFlyout = 1
    --[[------------------------------------------------------------
    this is totally magic, thanks god ObjectiveTrackerFrame is after the ActionBars
    ---------------------------------------------------------------]]
    local barsToUpdate = { MainMenuBar, MultiBarBottomLeft, MultiBarBottomRight, StanceBar, PetActionBar, PossessActionBar, MultiBarRight, MultiBarLeft, MultiBar5, MultiBar6, MultiBar7 }
    for _, bar in ipairs(barsToUpdate) do
        hooksecurefunc(bar, "UpdateSpellFlyoutDirection", function(self)
            if not issecurevariable(self, "flyoutDirection") then
                self.flyoutDirection = nil
            end
            if not issecurevariable(self, "snappedToFrame") then
                self.snappedToFrame = nil
            end
        end)
    end

    hooksecurefunc("SetClampedTextureRotation", function(texture)
        local parent = texture and texture:GetParent()
        if parent and parent.FlyoutArrowPushed and parent.FlyoutArrowHighlight then
            if not issecurevariable(texture, "rotationDegrees") then
                texture.rotationDegrees = nil
            end
        end
    end)
end