--------------------------------------------------------------------------------
-- work around the [cursor] conditional not detecting certain frames by force
-- showing grid when those frames are loaded
--------------------------------------------------------------------------------
local _, Addon = ...

if not Addon:IsBuild("retail") then return end

local ACTION_BUTTON_SHOW_GRID_REASON_UNSUPPORTED_THING = 512

local BROKEN_CURSOR_TYPES = {
    battlepet = true,
    mount = true,
    petaction = true,
}

local function cursorHasUnsupportedThing()
    local type, index = GetCursorInfo()

    if type and BROKEN_CURSOR_TYPES[type] then
        return not (index == nil or index == 0)
    end

    return false
end

local function requestHideGrid()
    if cursorHasUnsupportedThing() or InCombatLockdown() or SecureCmdOptionParse("[cursor]1;0") == "1" then
        return
    end

    Addon.Frame:ForEach("HideGrid", ACTION_BUTTON_SHOW_GRID_REASON_UNSUPPORTED_THING)
end

local Module = Addon:NewModule("ShowGridFixer", "AceEvent-3.0")

function Module:OnEnable()
    self:RegisterEvent("ACTIONBAR_SHOWGRID", "OnCursorChanged")
    self:RegisterEvent("ACTIONBAR_HIDEGRID", "OnCursorChanged")
    self:RegisterEvent("BATTLE_PET_CURSOR_CLEAR", "OnCursorChanged")
    self:RegisterEvent("MOUNT_CURSOR_CLEAR", "OnCursorChanged")
    self:RegisterEvent("PLAYER_REGEN_ENABLED", "OnCursorChanged")
end

function Module:OnCursorChanged()
    if InCombatLockdown() then return end

    if cursorHasUnsupportedThing() then
        Addon.Frame:ForEach("ShowGrid", ACTION_BUTTON_SHOW_GRID_REASON_UNSUPPORTED_THING)
    else
        C_Timer.After(0.01, requestHideGrid)
    end
end
