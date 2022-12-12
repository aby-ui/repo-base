--------------------------------------------------------------------------------
-- ActionButtonMixin
-- Additional methods we define on action buttons
--------------------------------------------------------------------------------

local AddonName, Addon = ...
local ActionButtonMixin = {}

function ActionButtonMixin:SetActionOffsetInsecure(offset)
    if InCombatLockdown() then
        return
    end

    local oldActionId = self:GetAttribute('action')
    local newActionId = self:GetAttribute('index') + (offset or 0)

    if oldActionId ~= newActionId then
        self:SetAttribute('action', newActionId)
        self:UpdateState()
    end
end

function ActionButtonMixin:SetShowGridInsecure(showgrid, force)
    if InCombatLockdown() then
        return
    end

    showgrid = tonumber(showgrid) or 0

    if (self:GetAttribute("showgrid") ~= showgrid) or force then
        self:SetAttribute("showgrid", showgrid)
        self:UpdateShownInsecure()
    end
end

function ActionButtonMixin:UpdateShownInsecure()
    if InCombatLockdown() then
        return
    end

    local show = (self:GetAttribute("showgrid") > 0 or HasAction(self:GetAttribute("action")))
        and not self:GetAttribute("statehidden")

    self:SetShown(show)
end

-- configuration commands
function ActionButtonMixin:SetFlyoutDirection(direction)
    if InCombatLockdown() then
        return
    end

    self:SetAttribute("flyoutDirection", direction)
    self:UpdateFlyout()
end

function ActionButtonMixin:SetShowCountText(show)
    if show then
        self.Count:Show()
    else
        self.Count:Hide()
    end
end

function ActionButtonMixin:SetShowMacroText(show)
    if show then
        self.Name:Show()
    else
        self.Name:Hide()
    end
end

function ActionButtonMixin:SetShowEquippedItemBorders(show)
    if show then
        self.Border:SetParent(self)
    else
        self.Border:SetParent(Addon.ShadowUIParent)
    end
end

-- we hide cooldowns when action buttons are transparent
-- so that the sparks don't appear
function ActionButtonMixin:SetShowCooldowns(show)
    if show then
        if self.cooldown:GetParent() ~= self then
            self.cooldown:SetParent(self)
            ActionButton_UpdateCooldown(self)
        end
    else
        self.cooldown:SetParent(Addon.ShadowUIParent)
    end
end

-- in classic, blizzard action buttons don't use a mixin
-- so define some methods that we'd expect
if not Addon:IsBuild('retail') then
    -- ActionButtonMixin.HideGrid = ActionButton_HideGrid
    -- ActionButtonMixin.ShowGrid = ActionButton_ShowGrid
    ActionButtonMixin.Update = ActionButton_Update
    ActionButtonMixin.UpdateFlyout = ActionButton_UpdateFlyout
    ActionButtonMixin.UpdateState = ActionButton_UpdateState

    hooksecurefunc("ActionButton_UpdateHotkeys", Addon.BindableButton.UpdateHotkeys)
end

Addon.ActionButtonMixin = ActionButtonMixin

--------------------------------------------------------------------------------
-- ActionButtons - A pool of action buttons
--------------------------------------------------------------------------------

local createActionButton
if Addon:IsBuild("retail") then
    local SecureHandler = Addon:CreateHiddenFrame('Frame', nil, nil, "SecureHandlerBaseTemplate")

    -- dragonflight hack: whenever a Dominos action button's action changes
    -- set the action of the corresponding blizzard action button
    -- this ensures that pressing a blizzard keybinding does the same thing as
    -- clicking a Dominos button would
    --
    -- We want to not remap blizzard keybindings in dragonflight, so that we can
    -- use some behaviors only available to blizzard action buttons, mainly cast on
    -- key down and press and hold casting
    local function proxyActionButton(owner, target)
        if not target then return end

        -- disable paging on the target by giving the target an ID of zero
        target:SetID(0)

        -- display the target's binding action
        owner.commandName = target.commandName

        -- mirror the owner's action on target whenever it changes
        SecureHandlerSetFrameRef(owner, "ProxyTarget", target)

        SecureHandler:WrapScript(owner, "OnAttributeChanged", [[
            if name ~= "action" then return end

            local target = self:GetFrameRef("ProxyTarget")

            if target and target:GetAttribute(name) ~= value then
                target:SetAttribute(name, value)
            end
        ]])

        -- mirror the pushed state of the target button
        hooksecurefunc(target, "SetButtonStateBase", function(_, state)
            owner:SetButtonStateBase(state)
        end)
    end

    createActionButton = function(id)
        local buttonName = ('%sActionButton%d'):format(AddonName, id)

        local button = CreateFrame('CheckButton', buttonName, nil, 'ActionBarButtonTemplate')

        -- inject custom flyout handling
        Addon.SpellFlyout:WrapScript(button, "OnClick", [[
            if button == "LeftButton" and not down then
                local actionType, actionID = GetActionInfo(self:GetAttribute("action"))

                if actionType == "flyout" then
                    control:SetAttribute("caller", self)
                    control:RunAttribute("Toggle", actionID)

                    return false
                end
            end
        ]])

        proxyActionButton(button, Addon.BlizzardActionButtons[id])

        return button
    end
else
    -- ignore pickup action clicks except on key down
    -- and ignore clicks that do not match our down state
    local actionButton_OnClick = [[
        if button == 'HOTKEY' then
            if down == control:GetAttribute("CastOnKeyPress") then
                return 'LeftButton'
            end
            return false
        end

        if down then
            return false
        end
    ]]

    local keyPressHandler = CreateFrame('Frame', nil, nil, 'SecureHandlerBaseTemplate')

    keyPressHandler:Hide()

    keyPressHandler:SetAttribute("CastOnKeyPress", GetCVarBool("ActionButtonUseKeyDown"))

    keyPressHandler:SetScript("OnEvent", function(self)
        self:SetAttribute("CastOnKeyPress", GetCVarBool("ActionButtonUseKeyDown"))
    end)

    keyPressHandler:RegisterEvent("PLAYER_ENTERING_WORLD")

    local function addCastOnKeyPressSupport(button)
        button:RegisterForClicks('AnyUp', 'AnyDown')
        keyPressHandler:WrapScript(button, 'OnClick', actionButton_OnClick)
    end

    local function getBlizzardActionButtonCommandName(button)
        if button.buttonType then
            return button.buttonType .. button:GetID()
        end

        return button:GetName():upper()
    end

    createActionButton = function(id)
        local button = Addon.BlizzardActionButtons[id]

        if button then
            button.commandName = getBlizzardActionButtonCommandName(button)

            -- disable paging on the existing button by giving the target an ID of zero
            button:SetID(0)
        else
            local name = ('%sActionButton%d'):format(AddonName, id)

            button = CreateFrame('CheckButton', name, nil, 'ActionBarButtonTemplate')
        end

        addCastOnKeyPressSupport(button)

        return button
    end
end

-- handle notifications from our parent bar about whate the action button
-- ID offset should be
local actionButton_OnUpdateOffset = [[
    local offset = message or 0
    local id = self:GetAttribute('index') + offset

    if self:GetAttribute('action') ~= id then
        self:SetAttribute('action', id)
        self:RunAttribute("UpdateShown")
        self:CallMethod('UpdateState')
    end
]]

local actionButton_OnUpdateShowGrid = [[
    local new = message or 0
    local old = self:GetAttribute("showgrid") or 0

    if old ~= new then
        self:SetAttribute("showgrid", new)
        self:RunAttribute("UpdateShown")
    end
]]

local actionButton_UpdateShown = [[
    local show = (self:GetAttribute("showgrid") > 0 or HasAction(self:GetAttribute("action")))
                 and not self:GetAttribute("statehidden")

    if show then
        self:Show(true)
    else
        self:Hide(true)
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
        if id < 1 then
            error(('Usage: %s.ActionButtons[>0]'):format(AddonName), 2)
        end

        local button = createActionButton(id)

        -- apply our extra action button methods
        Mixin(button, Addon.ActionButtonMixin)

        -- apply hooks for quick binding
        -- this must be done before we reset the button ID, as we use it
        -- to figure out the binding action for the button
        Addon.BindableButton:AddQuickBindingSupport(button)

        -- set a handler for updating the action from a parent frame
        button:SetAttribute('_childupdate-offset', actionButton_OnUpdateOffset)

        -- set a handler for updating showgrid status
        button:SetAttribute('_childupdate-showgrid', actionButton_OnUpdateShowGrid)

        button:SetAttribute("UpdateShown", actionButton_UpdateShown)

        -- reset the showgrid setting to default
        button:SetAttribute('showgrid', 0)

        button:Hide()

        -- enable binding to mousewheel
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
