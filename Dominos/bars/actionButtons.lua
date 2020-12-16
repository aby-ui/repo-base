--------------------------------------------------------------------------------
-- ActionButtons - A pool of action buttons
--------------------------------------------------------------------------------
local AddonName, Addon = ...
local ACTION_BUTTON_COUNT = Addon.ACTION_BUTTON_COUNT

local function createActionButton(id)
    local name = ('%sActionButton%d'):format(AddonName, id)

    local button = CreateFrame('CheckButton', name, nil, 'ActionBarButtonTemplate')

    button.commandName = ('CLICK %s:HOTKEY'):format(name)

    Addon.BindableButton:AddCastOnKeyPressSupport(button)

    return button
end

local function acquireActionButton(id)
    if id <= 12 then
        return _G[('ActionButton%d'):format(id)]
    elseif id <= 24 then
        return createActionButton(id - 12)
    elseif id <= 36 then
        return _G[('MultiBarRightButton%d'):format(id - 24)]
    elseif id <= 48 then
        return _G[('MultiBarLeftButton%d'):format(id - 36)]
    elseif id <= 60 then
        return _G[('MultiBarBottomRightButton%d'):format(id - 48)]
    elseif id <= 72 then
        return _G[('MultiBarBottomLeftButton%d'):format(id - 60)]
    else
        return createActionButton(id - 60)
    end
end

local function getBindingAction(button)
    local id = button:GetID()

    if id > 0 then
        return (button.buttonType or 'ACTIONBUTTON') .. id
    end
end

-- handle notifications from our parent bar about whate the action button
-- ID offset should be
local actionButton_OnUpdateOffset = [[
    local offset = message or 0
    local id = self:GetAttribute('index') + offset

    if self:GetAttribute('action') ~= id then
        self:SetAttribute('action', id)
        self:CallMethod('UpdateState')
    end
]]

-- action button creation is deferred so that we can avoid creating buttons for
-- bars set to show less than the maximum
local ActionButtons = setmetatable({}, {
    -- index creates & initializes buttons as we need them
    __index = function(self, id)
        -- validate the ID of the button we're getting is within an
        -- our expected range
        id = tonumber(id) or 0
        if id < 1 or id > ACTION_BUTTON_COUNT then
            error(('Usage: %s.ActionButtons[1-%d]'):format(AddonName, ACTION_BUTTON_COUNT), 2)
        end

        local button = acquireActionButton(id)

        -- apply our extra action button methods
        Mixin(button, Addon.ActionButtonMixin)

        -- apply hooks for quick binding
        -- this must be done before we reset the button ID, as we use it
        -- to figure out the binding action for the button
        Addon.BindableButton:AddQuickBindingSupport(button, getBindingAction(button))

        -- set a handler for updating the action from a parent frame
        button:SetAttribute('_childupdate-offset', actionButton_OnUpdateOffset)

        -- reset the ID to zero, as that prevents the default paging code
        -- from being used
        button:SetID(0)

        -- clear current position to avoid forbidden frame issues
        button:ClearAllPoints()

        -- reset the showgrid setting to default
        button:SetAttribute('showgrid', 0)

        -- enable mousewheel clicks
        button:EnableMouseWheel(true)

        rawset(self, id, button)
        return button
    end,
    -- newindex is set to block writes to prevent errors
    __newindex = function()
        error(('%s.ActionButtons does not support writes'):format(AddonName), 2)
    end
})

-- exports
Addon.ActionButtons = ActionButtons
