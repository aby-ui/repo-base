-- hooks for watching cooldown events
local Addon = _G[...]
local GCD_SPELL_ID = 61304
local Display

local GetSpellCooldown = _G.GetSpellCooldown
local GetTime = _G.GetTime

-- local functions we're declaring
local cooldown_OnSetCooldown
local cooldown_OnSetCooldownDuration
local cooldown_OnSetDisplayAsPercentage
local cooldown_OnShow
local cooldown_OnHide
local cooldown_HideText
local cooldown_ShowText
local cooldown_CanShowText

local states = setmetatable({}, {
    __index = function(t, cooldown)
        cooldown:HookScript("OnShow", cooldown_OnShow)
        cooldown:HookScript("OnHide", cooldown_OnHide)

        local cdState = {
            cooldown = cooldown,
            start = 0,
            duration = 0,
            visible = cooldown:IsVisible(),
            settings = Addon:GetCooldownSettings(cooldown)
        }

        t[cooldown] = cdState

        return cdState
    end
})

local KIND_PRIORITIES = {
    loc = 1,
    charge = 2,
    default = 1
}

local function cooldown_GetKind(cooldown)
    if cooldown.currentCooldownType == COOLDOWN_TYPE_LOSS_OF_CONTROL then
        return "loc"
    end

    local parent = cooldown:GetParent()
    if parent and parent.chargeCooldown == cooldown then
        return "charge"
    end

    return "default"
end

-- cooldown "events"
function cooldown_OnSetCooldown(cooldown, start, duration)
    if cooldown.noCooldownCount or cooldown:IsForbidden() then
        return
    end

    start = start or 0
    duration = duration or 0

    local state = states[cooldown]
    if state.start == start and state.duration == duration then
        return
    end

    state.start = start
    state.duration = duration
    state.show = cooldown_CanShowText(state)
    state.kind = cooldown_GetKind(cooldown)
    state.priority = KIND_PRIORITIES[state.kind]

    if state.visible and state.show then
        cooldown_ShowText(state)
    else
        cooldown_HideText(state)
    end
end

-- called when a cooldown is refreshed
function cooldown_OnSetCooldownDuration(cooldown)
    if cooldown.noCooldownCount or cooldown:IsForbidden() then
        return
    end

    local start, duration = cooldown:GetCooldownTimes()

    start = (start or 0) / 1000
    duration = (duration or 0) / 1000

    local state = states[cooldown]
    if state.start == start and state.duration == duration then
        return
    end

    state.start = start
    state.duration = duration
    state.show = cooldown_CanShowText(state)
    state.kind = cooldown_GetKind(cooldown)
    state.priority = KIND_PRIORITIES[state.kind]

    if state.visible and state.show then
        cooldown_ShowText(state)
    else
        cooldown_HideText(state)
    end
end

function cooldown_OnSetDisplayAsPercentage(cooldown)
    if cooldown.noCooldownCount or cooldown:IsForbidden() then
        return
    end

    cooldown.noCooldownCount = true
    cooldown_HideText(states[cooldown])
end

function cooldown_OnShow(cooldown)
    if cooldown.noCooldownCount or cooldown:IsForbidden() then
        return
    end

    local state = states[cooldown]

    state.visible = true

    if state.show and not state.display then
        cooldown_ShowText(state)
    end
end

function cooldown_OnHide(cooldown)
    if cooldown.noCooldownCount or cooldown:IsForbidden() then
        return
    end

    local state = states[cooldown]

    state.visible = nil

    cooldown_HideText(state)
end

function cooldown_CanShowText(state)
    local start, duration = state.start, state.duration

    -- no active cooldown
    if start == 0 or duration == 0 then
        return false
    end

    -- over min duration
    local sets = state.settings
    if not (sets and sets.enabled and duration > (sets.minDuration or 0)) then
        return false
    end

    local t = GetTime()

    -- expired cooldowns
    if (start + duration) <= t then
        return false
    end

    -- future cooldowns that don't start for at least a day
    -- these are probably buggy ones
    if (start - t) > 86400 then
        return false
    end

    -- GCD
    local gcdStart, gcdDuration = GetSpellCooldown(GCD_SPELL_ID)
    if start == gcdStart and duration == gcdDuration then
        return false
    end

    return true
end

function cooldown_ShowText(state)
    -- handle a fun edge case of a cooldown with an already active
    -- display that now belongs to a different parent object
    local oldDisplay = state.display
    local newDisplay = Display:GetOrCreate(state.cooldown:GetParent() or state.cooldown)

    if oldDisplay and oldDisplay ~= newDisplay then
        oldDisplay:HideCooldownText(state)
    end

    if newDisplay then
        newDisplay:ShowCooldownText(state)
    end

    state.display = newDisplay
end

function cooldown_HideText(state)
    local display = state.display
    if display then
        display:HideCooldownText(state)
        state.display  = nil
    end
end

-- exports
function Addon:WatchCooldowns()
    -- grab a copy of display at this point
    -- we do this so that we don't have to worry about file loading order
    Display = self.Display

    local Cooldown_MT = getmetatable(_G.ActionButton1Cooldown).__index

    hooksecurefunc(Cooldown_MT, "SetCooldown", cooldown_OnSetCooldown)
    hooksecurefunc(Cooldown_MT, "SetCooldownDuration", cooldown_OnSetCooldownDuration)
    hooksecurefunc("CooldownFrame_SetDisplayAsPercentage", cooldown_OnSetDisplayAsPercentage)
end

function Addon:UpdateCooldownSettings()
    for cooldown, state in pairs(states) do
        local newSettings = self:GetCooldownSettings(cooldown)

        if state.settings ~= newSettings then
            state.settings = self:GetCooldownSettings(cooldown)
            state.start = 0
            state.duration = 0

            cooldown_OnSetCooldownDuration(cooldown)
        end
    end
end
