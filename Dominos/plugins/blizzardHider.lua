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
            frame:ClearAllPoints()
            frame.ignoreFramePositionManager = true
        else
            Addon:Print('Unknown Frame', frameName)
        end
    end
end

local function disableEvents(...)
    for i = 1, select("#", ...) do
        local frameName = select(i, ...)
        local frame = _G[frameName]

        if frame then
            frame:UnregisterAllEvents()
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
local mainBar = MainMenuBar
if mainBar then
    mainBar:EnableMouse(false)
    mainBar.ignoreFramePositionManager = true
    mainBar:UnregisterEvent("ACTIONBAR_PAGE_CHANGED")
    mainBar:UnregisterEvent("PLAYER_ENTERING_WORLD")
    mainBar:UnregisterEvent("DISPLAY_SIZE_CHANGED")
    mainBar:UnregisterEvent("UI_SCALE_CHANGED")
end

if Addon:IsBuild("classic") then
    hideFrames(
        'MainMenuExpBar',
        'ReputationWatchBar',
        'MultiBarBottomLeft',
        'MultiBarBottomRight',
        'MultiBarLeft',
        'MultiBarRight',
        'MainMenuBarArtFrame',
        'StanceBarFrame',
        -- 'PossessBarFrame',
        'PetActionBarFrame',
        -- 'MultiCastActionBarFrame',
        -- 'MicroButtonAndBagsBar',
        'MainMenuBarPerformanceBar'
    )

    disableEvents(
        'MainMenuExpBar',
        'ReputationWatchBar'
    )
else
    hideFrames(
        -- 'MainMenuExpBar',
        -- 'ReputationWatchBar',
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

    disableSlideOutAnimations(
        'MainMenuBar',
        'OverrideActionBar'
    )

    -- don't reparent the tracking manager, as it assumes its parent has a callback
    StatusTrackingBarManager:UnregisterAllEvents()
    StatusTrackingBarManager:Hide()
end
