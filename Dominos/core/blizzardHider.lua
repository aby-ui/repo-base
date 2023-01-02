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

local function banish(frame)
    (frame.HideBase or frame.Hide)(frame)
    frame:SetParent(Addon.ShadowUIParent)
end

local function unregisterEvents(frame)
    frame:UnregisterAllEvents()
end

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

apply(banish,
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
    "MainMenuBarVehicleLeaveButton"
)

apply(unregisterEvents,
    "MultiBarBottomLeft",
    "MultiBarBottomRight",
    "MultiBarLeft",
    "MultiBarRight",
    "MultiBar5",
    "MultiBar6",
    "MultiBar7",
    "PossessActionBar",
    "MainMenuBarVehicleLeaveButton"
)

apply(disableActionButtons,
    "MainMenuBar",
    "MultiBarBottomLeft",
    "MultiBarBottomRight",
    "MultiBarLeft",
    "MultiBarRight",
    "MultiBar5",
    "MultiBar6",
    "MultiBar7",
    "PossessActionBar"
)
