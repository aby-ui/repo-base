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
            print("clean", k, issecurevariable(k))
            _G[k] = nil
        end
    end
end

hooksecurefunc(EditModeManagerFrame, "ClearActiveChangesFlags", function(self)
    for _, systemFrame in ipairs(self.registeredSystemFrames) do
        systemFrame:SetHasActiveChanges(nil);
    end
    self:SetHasActiveChanges(nil);
end)

GameMenuButtonEditMode:HookScript("PreClick", function()
    NoTaint2_CleanDropDownList()
    NoTaint2_CleanStaticPopups()
    NoTaint2_CleanGlobal()
end)

hooksecurefunc(EditModeManagerFrame, "IsEditModeLocked", function()
    NoTaint2_CleanGlobal()
end)