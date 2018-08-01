--[[
    This module is responsible for hiding the main menu bar and other components that we don't
    want visible when running Dominos
--]]

local AddonName, Addon =...

local hiddenFrame = CreateFrame('Frame', nil, _G['UIParent'], 'SecureFrameTemplate');
hiddenFrame:Hide()

local function disableFrame(frameName, unregisterEvents)
    local frame = _G[frameName]

    if not frame then
        Addon:Print('Unknown Frame', frameName)
        return
    end

    frame:SetParent(hiddenFrame)
    frame.ignoreFramePositionManager = true

    if unregisterEvents then
        frame:UnregisterAllEvents()
    end
end

local function disableFrameSlidingAnimation(frameName)
    local animation = (_G[frameName].slideOut:GetAnimations())

    animation:SetOffset(0, 0)
end

do
    -- disable, but don't hide the menu bar to work around Blizzard assumptions
    _G['MainMenuBar']:EnableMouse(false)
    _G['MainMenuBar'].ignoreFramePositionManager = true

    -- disable override bar transition animations
    disableFrameSlidingAnimation('MainMenuBar')
    disableFrameSlidingAnimation('OverrideActionBar')

    disableFrame('MultiBarBottomLeft')
    disableFrame('MultiBarBottomRight')
    disableFrame('MultiBarLeft')
    disableFrame('MultiBarRight')
    disableFrame('MainMenuBarArtFrame')
    disableFrame('StanceBarFrame')
    disableFrame('PossessBarFrame')
    disableFrame('PetActionBarFrame')
    disableFrame('MultiCastActionBarFrame')
    disableFrame('MicroButtonAndBagsBar')
    --disableFrame('MainMenuBarPerformanceBar')

    _G.StatusTrackingBarManager:UnregisterAllEvents()
    _G.StatusTrackingBarManager:Hide()
end
