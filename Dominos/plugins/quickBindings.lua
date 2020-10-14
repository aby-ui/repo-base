--------------------------------------------------------------------------------
-- Adds support for showing custom Dominos action buttons via the builtin quick
-- binding mode
--------------------------------------------------------------------------------

local ActionButtonUtil = _G.ActionButtonUtil
if not ActionButtonUtil then
    return
end

local _, Addon = ...

hooksecurefunc(
    ActionButtonUtil,
    'ShowAllActionButtonGrids',
    function()
        for _, button in pairs(Addon.ActionButtons) do
            button:ShowGridInsecure(ACTION_BUTTON_SHOW_GRID_REASON_EVENT)
        end
    end
)

hooksecurefunc(
    ActionButtonUtil,
    'HideAllActionButtonGrids',
    function()
        for _, button in pairs(Addon.ActionButtons) do
            button:HideGridInsecure(ACTION_BUTTON_SHOW_GRID_REASON_EVENT)
        end
    end
)

hooksecurefunc(
    ActionButtonUtil,
    'SetAllQuickKeybindButtonHighlights',
    function(show)
        for _, button in pairs(Addon.ActionButtons) do
            button.QuickKeybindHighlightTexture:SetShown(show)
        end
    end
)
