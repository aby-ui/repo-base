--------------------------------------------------------------------------------
-- A centralized handler for global state that we need to handle securely.
-- Or, a one stop shop for all of the hacks I need to work around the stock
-- ui not doing things in a secure manner
--------------------------------------------------------------------------------

local _, Addon = ...
if not Addon:IsBuild("retail") then return end

local Env = CreateFrame('Frame', nil, nil, 'SecureHandlerAttributeTemplate')
Env:Execute([[ WATCHERS = table.new() ]])
Env:Hide()

--------------------------------------------------------------------------------
-- detection
--------------------------------------------------------------------------------

-- detect ACTION_BUTTON_SHOW_GRID_REASON_EVENT changes
-- requirements: MainActionBar needs to have its events registered
do
    -- initialize
    Env:SetAttribute("showgrid", 0)

    local target = MainMenuBar.actionButtons[1]

    -- initialize state
    target:SetAttribute("showgrid", 0)

    -- watch for changes
    local target_OnAttributeChanged = ([[
        if name ~= "showgrid" then return end

        local reason = %d

        local result
        if value %% (2 * reason) >= reason then
            result = reason
        else
            result = 0
        end

        if control:GetAttribute(name) ~= result then
            control:SetAttribute(name, result)
            control:SetAttribute("saving-" .. name, 1)
        end
    ]]):format(ACTION_BUTTON_SHOW_GRID_REASON_EVENT)

    Env:WrapScript(target, "OnAttributeChanged", target_OnAttributeChanged)

    -- delay updates until the next frame to avoid issues around saving the
    -- state of buttons we've just added actions to
    RegisterAttributeDriver(Env, "saving-showgrid", 0)
end

--------------------------------------------------------------------------------
-- event handling
--------------------------------------------------------------------------------

Env:SetAttribute("Notify", [[
    local key = ...
    local value = self:GetAttribute(key)

    local watchers = WATCHERS[key]
    if watchers then
        for frame in pairs(watchers) do
            frame:SetAttribute("state-" .. key, value)
        end
    end
]])

Env:SetAttribute("saving-showgrid-changed", [[
    local _, saving = ...
    if saving == 0 then
        self:RunAttribute("Notify", "showgrid")
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
        local attribute = %q
        local frame = self:GetFrameRef("watcher")

        local watchers = WATCHERS[attribute]
        if not watchers then
            watchers = table.new()
            WATCHERS[attribute] = watchers
        end

        watchers[frame] = true
        frame:SetAttribute("state-" .. attribute, self:GetAttribute(attribute))
    ]]):format(attribute)

    Env:Execute(method)
end

function Addon:RegisterShowGridEvents(frame)
    watch(frame, "showgrid")
end
