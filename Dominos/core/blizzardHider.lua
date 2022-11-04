local _, Addon = ...

if not Addon:IsBuild('retail') then
    return
end

-- move a frame to the hidden shadow UI parent
local function banishFrames(...)
    for i = 1, select('#', ...) do
        local name = select(i, ...)
        local frame = _G[name]

        if frame then
            frame:Hide()
            frame:SetParent(Addon.ShadowUIParent)
        else
            Addon:Printf('Could not find frame %q', name)
        end
    end
end

local function unregisterEventsForFrames(...)
    for i = 1, select('#', ...) do
        local name = select(i, ...)
        local frame = _G[name]

        if frame then
            frame:UnregisterAllEvents()
        else
            Addon:Printf('Could not find frame %q', name)
        end
    end
end

local function disableActionButton(name)
    local button = _G[name]
    if button then
        button:UnregisterAllEvents()
        button:SetAttribute('statehidden', true)
        button:Hide()
    else
        Addon:Printf('Action Button %q could not be found', name)
    end
end

banishFrames(
    "MainMenuBar",
    "MicroButtonAndBagsBar",
    "MultiBarBottomLeft",
    "MultiBarBottomRight",
    "MultiBarLeft",
    "MultiBarRight"
)

unregisterEventsForFrames(
    "MultiBarBottomLeft",
    "MultiBarBottomRight",
    "MultiBarLeft",
    "MultiBarRight"
)

-- disable the stock action buttons
for i = 1, NUM_ACTIONBAR_BUTTONS do
    disableActionButton(('ActionButton%d'):format(i))
    disableActionButton(('MultiBarRightButton%d'):format(i))
    disableActionButton(('MultiBarLeftButton%d'):format(i))
    disableActionButton(('MultiBarBottomRightButton%d'):format(i))
    disableActionButton(('MultiBarBottomLeftButton%d'):format(i))
end

-- disable some action bar controller updates that we probably don't need
-- ActionBarController:UnregisterEvent('UPDATE_POSSESS_BAR')