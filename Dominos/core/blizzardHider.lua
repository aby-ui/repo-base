local _, Addon = ...

if not Addon:IsBuild('retail') then
    return
end

-- move a frame to the hidden shadow UI parent
local function apply(func, ...)
    for i = 1, select('#', ...) do
        local name = (select(i, ...))
        local frame = _G[name]

        if frame then
            func(frame)
        else
            Addon:Printf('Could not find frame %q', name)
        end
    end
end

local function banishFrames(...)
    local function hide(frame)
        frame:Hide()
        frame:SetParent(Addon.ShadowUIParent)
    end

    return apply(hide, ...)
end

local function unregisterEventsForFrames(...)
    local function unregisterEvents(frame)
        frame:UnregisterAllEvents()
    end

    apply(unregisterEvents, ...)
end

local function disableActionButtonsForFrames(...)
    local function disableActionButtons(frame)
        local buttons = frame.actionButtons
        if type(buttons) ~= "table" then
            return
        end

        for _, button in pairs(buttons) do
            button:UnregisterAllEvents()
            button:SetAttribute('statehidden', true)
            button:Hide()
        end
    end

    apply(disableActionButtons, ...)
end

banishFrames(
    "MainMenuBar",
    "MicroButtonAndBagsBar",
    "MultiBarBottomLeft",
    "MultiBarBottomRight",
    "MultiBarLeft",
    "MultiBarRight",
    "MultiBar5",
    "MultiBar6",
    "MultiBar7",
    "PossessActionBar",
    "StanceBar",
    "MainMenuBarVehicleLeaveButton"
)

unregisterEventsForFrames(
-- "MainMenuBar",
    "MultiBarBottomLeft",
    "MultiBarBottomRight",
    "MultiBarLeft",
    "MultiBarRight",
    "MultiBar5",
    "MultiBar6",
    "MultiBar7",
    "PossessActionBar",
    "StanceBar",
    "MainMenuBarVehicleLeaveButton"
)

disableActionButtonsForFrames(
    "MainMenuBar",
    "MicroButtonAndBagsBar",
    "MultiBarBottomLeft",
    "MultiBarBottomRight",
    "MultiBarLeft",
    "MultiBarRight",
    "MultiBar5",
    "MultiBar6",
    "MultiBar7",
    "PossessActionBar",
    "StanceBar"
-- "MainMenuBarVehicleLeaveButton"
)

-- disable some action bar controller updates that we probably don't need
ActionBarController:UnregisterEvent("UPDATE_SHAPESHIFT_FORM")
ActionBarController:UnregisterEvent("UPDATE_SHAPESHIFT_FORMS")
ActionBarController:UnregisterEvent("UPDATE_SHAPESHIFT_USABLE")
ActionBarController:UnregisterEvent('UPDATE_POSSESS_BAR')
