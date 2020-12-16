local _, Addon = ...

local function apply(func, arg, ...)
    if select('#', ...) > 0 then
        return func(arg), apply(func, ...)
    end

    return func(arg)
end

local function hide(frame)
    if not frame then
        return
    end

    frame:Hide()
    frame:SetParent(Addon.ShadowUIParent)
    frame.ignoreFramePositionManager = true

    -- with 8.2, there's more restrictions on frame anchoring if something
    -- happens to be attached to a restricted frame. This causes issues with
    -- moving the action bars around, so we perform a clear all points to avoid
    -- some frame dependency issues
    -- we then follow it up with a SetPoint to handle the cases of bits of the
    -- UI code assuming that this element has a position
    frame:ClearAllPoints()
    frame:SetPoint('CENTER')
end

-- disables override bar transition animations
local function disableSlideOutAnimations(frame)
    if not (frame and frame.slideOut) then
        return
    end

    local animation = (frame.slideOut:GetAnimations())
    if animation then
        animation:SetOffset(0, 0)
    end
end

apply(
    hide,
    ActionBarDownButton,
    ActionBarUpButton,
    MainMenuBarPerformanceBarFrame,
    MicroButtonAndBagsBar,
    MultiBarBottomLeft,
    MultiBarBottomRight,
    MultiBarLeft,
    MultiBarRight,
    MultiCastActionBarFrame,
    PetActionBarFrame,
    StanceBarFrame
)

apply(disableSlideOutAnimations, MainMenuBar, MultiBarLeft, MultiBarRight, OverrideActionBar)

-- we don't completely disable the main menu bar, as there's some logic
-- dependent on it being visible
if MainMenuBar then
    MainMenuBar:EnableMouse(false)

    -- the main menu bar is responsible for updating the micro buttons
    -- so we don't disable all events for it
    MainMenuBar:UnregisterEvent('ACTIONBAR_PAGE_CHANGED')
    MainMenuBar:UnregisterEvent('PLAYER_ENTERING_WORLD')
    MainMenuBar:UnregisterEvent('DISPLAY_SIZE_CHANGED')
    MainMenuBar:UnregisterEvent('UI_SCALE_CHANGED')
end

-- don't hide the art frame, as the multi action bars are dependent on GetLeft
-- or similar calls returning a value
if MainMenuBarArtFrame then
    MainMenuBarArtFrame:SetAlpha(0)
end

-- don't reparent the tracking manager, as it assumes its parent has a callback
if StatusTrackingBarManager then
    StatusTrackingBarManager:UnregisterAllEvents()
    StatusTrackingBarManager:Hide()
end

if MainMenuExpBar then
    MainMenuExpBar:UnregisterAllEvents()
    hide(MainMenuExpBar)
end

if ReputationWatchBar then
    ReputationWatchBar:UnregisterAllEvents()
    hide(ReputationWatchBar)

    hooksecurefunc(
        'MainMenuBar_UpdateExperienceBars',
        function()
            ReputationWatchBar:Hide()
        end
    )
end

if VerticalMultiBarsContainer then
    VerticalMultiBarsContainer:UnregisterAllEvents()
    hide(VerticalMultiBarsContainer)

    -- a hack to preserve the multi action bar spacing behavior for the quest log
    hooksecurefunc(
        'MultiActionBar_Update',
        function()
            local width = 0
            local showLeft = SHOW_MULTI_ACTIONBAR_3
            local showRight = SHOW_MULTI_ACTIONBAR_4
            local stack = GetCVarBool('multiBarRightVerticalLayout')

            if showLeft then
                width = width + VERTICAL_MULTI_BAR_WIDTH
            end

            if showRight and not stack then
                width = width + VERTICAL_MULTI_BAR_WIDTH
            end

            VerticalMultiBarsContainer:SetWidth(width)
        end
    )
end

-- set the stock action buttons to hidden by default
local function disableActionButton(name)
    local button = _G[name]
    if button then
        button:SetAttribute('statehidden', true)
        button:Hide()
    else
        Addon:Printf('Action Button %q could not be found', name)
    end
end

for id = 1, NUM_ACTIONBAR_BUTTONS do
    disableActionButton(('ActionButton%d'):format(id))
    disableActionButton(('MultiBarRightButton%d'):format(id))
    disableActionButton(('MultiBarLeftButton%d'):format(id))
    disableActionButton(('MultiBarBottomRightButton%d'):format(id))
    disableActionButton(('MultiBarBottomLeftButton%d'):format(id))
end
