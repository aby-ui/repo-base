--[[ hooks for watching cooldown events ]]--

local Addon = _G[...]
local GetSpellCooldown = _G.GetSpellCooldown
local GCD_SPELL_ID = 61304
local Display

-- used to keep track of active cooldowns,
-- and the displays associated with them
local active = {}

-- used to keep track of cooldowns that we've hooked
local hooked = {}

-- local functions we're declaring
local cooldown_OnSetCooldown
local cooldown_OnSetCooldownDuration
local cooldown_OnSetDisplayAsPercentage
local cooldown_OnShow
local cooldown_HideText
local cooldown_ShouldShowText
local cooldown_ShowText

-- cooldown "events"
function cooldown_OnSetCooldown(cooldown, start, duration)
    if cooldown.noCooldownCount or cooldown:IsForbidden() then
        return
    end

    if cooldown_ShouldShowText(cooldown, start, duration) then
        cooldown_ShowText(cooldown)
    else
        cooldown_HideText(cooldown)
    end
end

-- called when a cooldown is refreshed
function cooldown_OnSetCooldownDuration(cooldown)
    if cooldown.noCooldownCount or cooldown:IsForbidden() then
        return
    end

    local start, duration = cooldown:GetCooldownTimes()
    if cooldown_ShouldShowText(cooldown, start and start/1000, duration and duration/1000) then
        cooldown_ShowText(cooldown)
    else
        cooldown_HideText(cooldown)
    end
end

function cooldown_OnSetDisplayAsPercentage(cooldown)
    if cooldown.noCooldownCount or cooldown:IsForbidden() then
        return
    end

    cooldown_HideText(cooldown)
end

function cooldown_OnShow(cooldown)
    -- ignore cooldowns with already active displays
    -- to avoid calls of cooldown:SetCooldown(...); cooldown:Show()
    if active[cooldown] then
        return
    end

    if cooldown.noCooldownCount or cooldown:IsForbidden() then
        return
    end

    local start, duration = cooldown:GetCooldownTimes()
    if cooldown_ShouldShowText(cooldown, start and start/1000, duration and duration/1000) then
        cooldown_ShowText(cooldown)
    end
end


function cooldown_ShouldShowText(cooldown, start, duration)
    start = start or 0
    if (start or 0) <= 0 then
        return false
    end

    if (duration or 0) <= 0 then
        return false
    end

    -- filter min duration
    local sets = Addon:GetCooldownSettings(cooldown)
    if not (sets and sets.enabled and duration > (sets.minDuration or 0)) then
        return false
    end

    -- filter GCD
    local gcdStart, gcdDuration = GetSpellCooldown(GCD_SPELL_ID)
    if start == gcdStart and duration == gcdDuration then
        return false
    end

    return true
end

function cooldown_ShowText(cooldown)
    if not hooked[cooldown] then
        hooked[cooldown] = true
        cooldown:HookScript("OnShow", cooldown_OnShow)
        cooldown:HookScript("OnHide", cooldown_HideText)
    end

    -- handle a fun edge case of a cooldown with an already active
    -- display that now belongs to a different parent object
    local oldDisplay = active[cooldown]
    local newDisplay = Display:GetOrCreate(cooldown:GetParent() or cooldown)

    if oldDisplay and oldDisplay ~= newDisplay then
        oldDisplay:HideCooldownText(cooldown)
    end

    if newDisplay then
        newDisplay:ShowCooldownText(cooldown)
    end

    active[cooldown] = newDisplay
end

function cooldown_HideText(cooldown)
    local display = active[cooldown]
    if display then
        display:HideCooldownText(cooldown)
        active[cooldown] = nil
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
