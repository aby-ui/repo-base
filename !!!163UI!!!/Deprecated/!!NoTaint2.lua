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
    if DEBUG_MODE then
        if not issecurevariable(DropDownList1, "numButtons") or not issecurevariable("UIDROPDOWNMENU_MAXLEVELS") then
            print("!!NoTaint2 works!")
        end
    end
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

local eventframe = CreateFrame("Frame")
eventframe:RegisterEvent("PLAYER_LEAVING_WORLD")
eventframe:SetScript("OnEvent", cleanAll)