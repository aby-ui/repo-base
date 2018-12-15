--[[
    This module is responsible for hiding the main menu bar and other components that we don't
    want visible when running Dominos
--]]

local _, Addon =...
local HiddenFrame = CreateFrame('Frame', nil, UIParent); HiddenFrame:Hide()

local function hideFrames(...)
    for i = 1, select("#", ...) do
        local frameName = select(i, ...)
        local frame = _G[frameName]

        if frame then
            frame:SetParent(HiddenFrame)
            frame.ignoreFramePositionManager = true
        else
            Addon:Print('Unknown Frame', frameName)
        end
    end
end

-- disable override bar transition animations
local function disableSlideOutAnimations(...)
    for i = 1, select("#", ...) do
        local frameName = select(i, ...)
        local frame = _G[frameName]

        if frame then
            local animation = (frame.slideOut:GetAnimations())
            if animation then
                animation:SetOffset(0, 0)
            else
                Addon:Print('No slideout animation is present on ', frameName)
            end
        else
            Addon:Print('Unknown Frame', frameName)
        end
    end
end

-- disable but don't reparent and hide the
MainMenuBar:EnableMouse(false)
MainMenuBar.ignoreFramePositionManager = true
MainMenuBar:UnregisterEvent("ACTIONBAR_PAGE_CHANGED")
MainMenuBar:UnregisterEvent("PLAYER_ENTERING_WORLD")
MainMenuBar:UnregisterEvent("DISPLAY_SIZE_CHANGED")
MainMenuBar:UnregisterEvent("UI_SCALE_CHANGED")

-- don't reparent the tracking manager, as it assumes its parent has a callback
StatusTrackingBarManager:UnregisterAllEvents()
StatusTrackingBarManager:Hide()

disableSlideOutAnimations(
    'MainMenuBar',
    'OverrideActionBar'
)

hideFrames(
    'MultiBarBottomLeft',
    'MultiBarBottomRight',
    'MultiBarLeft',
    'MultiBarRight',
    'MainMenuBarArtFrame',
    'StanceBarFrame',
    'PossessBarFrame',
    'PetActionBarFrame',
    'MultiCastActionBarFrame',
    'MicroButtonAndBagsBar'
    --,'MainMenuBarPerformanceBar'
)

-- disable multiactionbar_update to prevent some taint issues
MultiActionBar_Update = Multibar_EmptyFunc
