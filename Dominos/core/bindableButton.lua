-- Binding code that's shared between the various flavors of action buttons
local AddonName, Addon = ...
local KeyBound = LibStub('LibKeyBound-1.0')

-- binding method definitions
-- returns the binding action associated with the button
local function getButtonBindingAction(button)
    local bindingAction = button:GetAttribute('bindingAction')
    if bindingAction then
        return bindingAction
    end

    local id = button:GetID() or 0
    if id > 0 and button.buttonType then
        return (button.buttonType .. id)
    end

    -- use a virtual button for clicks
    -- this allows us to separate hotkey presses from mouse clicks on actions
    return ('CLICK %s:HOTKEY'):format(button:GetName())
end

local function getButtonActionName(button)
    local commandName = button.commandName
    if commandName then
        return GetBindingName(commandName)
    end

    local action = getButtonBindingAction(button)
    local bindingName = GetBindingName(action)

    if bindingName and bindingName ~= action then
        return bindingName
    end

    return button:GetName()
end

local function getButtonBindings(button)
    return GetBindingKey(getButtonBindingAction(button))
end

-- returns what hotkey to display for the button
local function getButtonHotkey(button)
    local key = (getButtonBindings(button))

    if key then
        return KeyBound:ToShortKey(key)
    end

    return ''
end

-- returns a space separated list of all bindings for the given button
local function getButtonBindingsList(button)
    return strjoin(' ', getButtonBindings(button))
end

-- set bindings
local function setButtonBinding(button, key)
    return SetBinding(key, getButtonBindingAction(button))
end

-- clears all bindings from the button
local function clearButtonBindings(button)
    local key = (getButtonBindings(button))

    while key do
        SetBinding(key, nil)
        key = (getButtonBindings(button))
    end
end

-- used to implement keybinding support without applying all of the LibKeyBound
-- interface methods via a mixin
local BindableButtonProxy = Addon:CreateHiddenFrame('Frame', AddonName .. 'BindableButtonProxy')

-- call a thing if the thing exists
local function whenExists(obj, func, ...)
    if obj then
        return func(obj, ...)
    end
end

function BindableButtonProxy:GetHotkey()
    return whenExists(self:GetParent(), getButtonHotkey)
end

function BindableButtonProxy:SetKey(key)
    return whenExists(self:GetParent(), setButtonBinding, key)
end

function BindableButtonProxy:GetBindings()
    return whenExists(self:GetParent(), getButtonBindingsList)
end

function BindableButtonProxy:ClearBindings()
    return whenExists(self:GetParent(), clearButtonBindings)
end

function BindableButtonProxy:GetActionName()
    return whenExists(self:GetParent(), getButtonActionName) or UNKNOWN
end

BindableButtonProxy:SetScript('OnLeave', function(self)
    self:ClearAllPoints()
    self:SetParent(nil)
end)

-- methods to inject onto a bar to add in common binding functionality
-- previously, this was a mixin
local BindableButton = Addon:NewModule('Bindings', 'AceEvent-3.0')

BindableButton.keyPressHandler = Addon:CreateHiddenFrame('Frame', nil, nil, 'SecureHandlerBaseTemplate')

function BindableButton:OnEnable()
    self:RegisterEvent('CVAR_UPDATE')
    self:SetCastOnKeyPress(GetCVarBool('ActionButtonUseKeyDown'))

    -- migrate any old click bindings to the new format
    local updatedBindings = false

    for id = 1, 60 do
        local action = ('CLICK %sActionButton%d:LeftButton'):format(AddonName, id)
        local newAction = ('CLICK %sActionButton%d:HOTKEY'):format(AddonName, id)

        local key = GetBindingKey(action)
        while key do
            SetBinding(key, newAction)
            key = GetBindingKey(action)
            updatedBindings = true
        end
    end

    if updatedBindings then
        (SaveBindings or AttemptToSaveBindings)(GetCurrentBindingSet())
    end
end

function BindableButton:CVAR_UPDATE(event, cvarName, cvarValue)
    if cvarName == ACTION_BUTTON_USE_KEY_DOWN then
        self:SetCastOnKeyPress(cvarValue == '1')
    end
end

function BindableButton:PLAYER_REGEN_ENABLED(event)
    self:SetCastOnKeyPress(GetCVarBool('ActionButtonUseKeyDown'))
    self:UnregisterEvent(event)
    self.needsUpdate = nil
end

-- adds cast on keypress support to custom actions
function BindableButton:AddCastOnKeyPressSupport(button)
    -- watch down clicks in addition to up clicks
    -- we can't stop here, however, as it would cause pressing the mouse button
    -- down on a button to trigger an action, which isn't something we want
    button:RegisterForClicks('AnyUp', 'AnyDown')

    -- ...so the solution is to wrap the click handler for buttons
    -- and filter clicks of the HOTKEY "button" appropiately
    -- those are then transformed into LeftButton clicks if they pass through
    -- the filter so we preserve existing action bar behavior
    self.keyPressHandler:WrapScript(button, 'OnClick', [[
        if button == 'HOTKEY' then
            if down == control:GetAttribute("CastOnKeyPress") then
                return 'LeftButton'
            else
                return false
            end
        elseif down then
            return false
        end
    ]])
end

-- adds quickbinding support to buttons
function BindableButton:AddQuickBindingSupport(button, bindingAction)
    button:HookScript('OnEnter', BindableButton.OnEnter)

    if bindingAction then
        button:SetAttribute('bindingAction', bindingAction)
    end

    if button.UpdateHotkeys then
        hooksecurefunc(button, 'UpdateHotkeys', BindableButton.UpdateHotkeys)
    else
        button.UpdateHotkeys = BindableButton.UpdateHotkeys
    end
end

function BindableButton:SetCastOnKeyPress(enable)
    if InCombatLockdown() and not self.needsUpdate then
        self.needsUpdate = true
        self:RegisterEvent('PLAYER_REGEN_ENABLED')
        return
    end

    self.keyPressHandler:SetAttribute('CastOnKeyPress', enable)
end

function BindableButton:UpdateHotkeys()
    local key = getButtonHotkey(self)

    if key ~= '' and Addon:ShowBindingText() then
        self.HotKey:SetText(key)
        self.HotKey:Show()
    else
        -- blank out non blank text, such as RANGE_INDICATOR
        self.HotKey:SetText('')
        self.HotKey:Hide()
    end
end

function BindableButton:OnEnter()
    if not KeyBound:IsShown() then
        return
    end

    BindableButtonProxy:ClearAllPoints()
    BindableButtonProxy:SetAllPoints(self)
    BindableButtonProxy:SetParent(self)

    KeyBound:Set(BindableButtonProxy)
end

-- inject binding names
do
    local L = LibStub('AceLocale-3.0'):GetLocale(AddonName)

    _G[('BINDING_CATEGORY_%s'):format(AddonName)] = AddonName

    local addonActionBarName = AddonName .. ' ' .. L.ActionBarDisplayName
    for id = 1, 12 do
        _G[('BINDING_HEADER_%sActionBar%d'):format(AddonName, id)] = addonActionBarName:format(id)
    end

    local addonActionButtonName = AddonName .. ' ' .. L.ActionButtonDisplayName
    for id = 1, 60 do
        _G[('BINDING_NAME_CLICK %sActionButton%d:HOTKEY'):format(AddonName, id)] = addonActionButtonName:format(id)
    end
end

-- exports
Addon.BindableButton = BindableButton
