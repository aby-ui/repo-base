--------------------------------------------------------------------------------
-- A centralized handler for global state that we need to handle securely.
-- Or, a one stop shop for all of the hacks I need to work around the stock
-- ui not doing things in a secure manner
--------------------------------------------------------------------------------

local _, Addon = ...
if not Addon:IsBuild("retail") then return end

local Env = CreateFrame('Frame', nil, nil, 'SecureHandlerAttributeTemplate')
Env:Execute([[ WATCHERS = table.new() ]])
Env:Execute(([[ ACTION_BUTTON_SHOW_GRID_REASON_EVENT = %d ]]):format(ACTION_BUTTON_SHOW_GRID_REASON_EVENT))
Env:Hide()

--------------------------------------------------------------------------------
-- detection
--------------------------------------------------------------------------------

-- detect ACTION_BUTTON_SHOW_GRID_REASON_EVENT changes
-- requirements: MainActionBar needs to have its events registered
do
    -- initialize
    Env:SetAttribute("showgrid-event", false)

    -- initialize state
    ActionButton1:SetAttribute("showgrid", 0)

    -- watch for changes
    Env:WrapScript(ActionButton1, "OnAttributeChanged", [[
        if name ~= "showgrid" then return end

        local reason = ACTION_BUTTON_SHOW_GRID_REASON_EVENT
        local show = value % (2 * reason) >= reason

        if control:GetAttribute("showgrid-event") ~= show then
            control:SetAttribute("showgrid-event", show)
            control:SetAttribute("showgrid-event-ready", 0)
        end
    ]])

    -- delay updates until the next frame to avoid issues around saving the
    -- state of buttons we've just added actions to
    RegisterAttributeDriver(Env, "showgrid-event-ready", 1)
end

--------------------------------------------------------------------------------
-- event handling
--------------------------------------------------------------------------------

Env:SetAttribute("SetShowGrid", [[
    local reason, show, force = ...

    local watchers = WATCHERS["showgrid"]

    if watchers then
        for frame in pairs(watchers) do
            frame:RunAttribute("SetShowGrid", reason, show, force)
        end
    end
]])

Env:SetAttribute("showgrid-event-ready-changed", [[
    local _, ready = ...
    if ready == 1 then
        self:RunAttribute("SetShowGrid", ACTION_BUTTON_SHOW_GRID_REASON_EVENT, self:GetAttribute("showgrid-event") and true)
    end
]])

-- watch for attribute changes, run an associated attribute-changed handler
Env:SetAttribute("_onattributechanged", [[
    local body = self:GetAttribute(name .. "-changed")
    if body then
        self:Run(body, name, value)
    end
]])

--------------------------------------------------------------------------------
-- subscriptions
--------------------------------------------------------------------------------

-- like and subscribe
local function watch(frame, attribute)
    Env:SetFrameRef("watcher", frame)

    local method = ([[
        local key = %q
        local frame = self:GetFrameRef("watcher")

        local watchers = WATCHERS[key]
        if not watchers then
            watchers = table.new()
            WATCHERS[key] = watchers
        end

        watchers[frame] = true
    ]]):format(attribute)

    Env:Execute(method)
end

function Addon:RegisterShowGridEvents(frame)
    frame:SetAttribute("SetShowGrid", [[
        local reason, show, force = ...
        local value = self:GetAttribute("showgrid") or 0
        local updated = force and true

        if show then
            if value % (2 * reason) < reason then
                value = value + reason
                updated = true
            end
        elseif value % (2 * reason) >= reason then
            value = value - reason
            updated = true
        end

        if updated then
            self:SetAttribute("showgrid", value)
            self:RunAttribute("OnShowGridChanged", value)
        end
    ]])

    frame:SetShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_EVENT, Env:GetAttribute("showgrid-event") and true)

    watch(frame, "showgrid")
end
