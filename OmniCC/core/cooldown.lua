-- hooks for watching cooldown events
local Addon = _G[...]

local GCD_SPELL_ID = 61304
local COOLDOWN_TYPE_LOSS_OF_CONTROL = _G.COOLDOWN_TYPE_LOSS_OF_CONTROL
local GetSpellCooldown = _G.GetSpellCooldown
local GetTime = _G.GetTime
local cooldowns = {}

local function cooldown_CanShow(cooldown)
    local start, duration = cooldown._occ_start, cooldown._occ_duration

    -- no active cooldown
    if start <= 0 or duration <= 0 then
        return false
    end

    -- over min duration
    local sets = cooldown._occ_settings
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

    -- filter GCD
    local gcdStart, gcdDuration = GetSpellCooldown(GCD_SPELL_ID)
    if start == gcdStart and duration == gcdDuration then
        return false
    end

    return true
end

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

local function cooldown_GetPriority(cooldown)
    if cooldown._occ_kind ==  "charge" then
        return 2
    end

    return 1
end

local function cooldown_ShowText(cooldown)
    local newDisplay = Addon.Display:GetOrCreate(cooldown:GetParent() or cooldown)
    local oldDisplay = cooldown._occ_display

    if oldDisplay and oldDisplay ~= newDisplay then
        oldDisplay:RemoveCooldown(cooldown)
    end

    if newDisplay then
        newDisplay:AddCooldown(cooldown)
    end

    cooldown._occ_display = newDisplay
end

local function cooldown_HideText(cooldown)
    local display = cooldown._occ_display

    if display then
        display:RemoveCooldown(cooldown)

        cooldown._occ_display  = nil
    end
end

local function cooldown_UpdateText(cooldown)
    if cooldown._occ_show and cooldown:IsVisible() then
        cooldown_ShowText(cooldown)
    else
        cooldown_HideText(cooldown)
    end
end

local function cooldown_SetTimer(cooldown, start, duration)
    if cooldown._occ_start == start and cooldown._occ_duration == duration then
        return
    end

    cooldown._occ_start = start
    cooldown._occ_duration = duration
    cooldown._occ_kind = cooldown_GetKind(cooldown)
    cooldown._occ_show = cooldown_CanShow(cooldown)
    cooldown._occ_priority = cooldown_GetPriority(cooldown)

    cooldown_UpdateText(cooldown)
end

local function cooldown_OnVisibilityUpdated(cooldown)
    if cooldown.noCooldownCount or cooldown:IsForbidden() then return end

    cooldown_UpdateText(cooldown)
end

local function cooldown_Initialize(cooldown)
    if cooldowns[cooldown] then return end

    cooldowns[cooldown] = true
    cooldown._occ_start = 0
    cooldown._occ_duration = 0
    cooldown._occ_settings = Addon:GetCooldownSettings(cooldown)

    cooldown:HookScript("OnShow", cooldown_OnVisibilityUpdated)
    cooldown:HookScript("OnHide", cooldown_OnVisibilityUpdated)
end

local function cooldown_OnSetCooldown(cooldown, start, duration)
    if cooldown.noCooldownCount or cooldown:IsForbidden() then return end

    start = start or 0
    duration = duration or 0

    cooldown_Initialize(cooldown)
    cooldown_SetTimer(cooldown, start, duration)
end

local function cooldown_OnSetCooldownDuration(cooldown)
    if cooldown.noCooldownCount or cooldown:IsForbidden() then return end

    local start, duration = cooldown:GetCooldownTimes()

    start = (start or 0) / 1000
    duration = (duration or 0) / 1000

    cooldown_Initialize(cooldown)
    cooldown_SetTimer(cooldown, start, duration)
end

local function cooldown_OnSetDisplayAsPercentage(cooldown)
    if cooldown.noCooldownCount or cooldown:IsForbidden() then return end

    cooldown.noCooldownCount = true

    cooldown_HideText(cooldown)
end

-- exports
function Addon:WatchCooldowns()
    local Cooldown_MT = getmetatable(_G.ActionButton1Cooldown).__index

    hooksecurefunc(Cooldown_MT, "SetCooldown", cooldown_OnSetCooldown)
    hooksecurefunc(Cooldown_MT, "SetCooldownDuration", cooldown_OnSetCooldownDuration)
    hooksecurefunc("CooldownFrame_SetDisplayAsPercentage", cooldown_OnSetDisplayAsPercentage)
end

function Addon:UpdateCooldownSettings()
    for cooldown in pairs(cooldowns) do
        local newSettings = self:GetCooldownSettings(cooldown)

        if cooldown._occ_settings ~= newSettings then
            cooldown._occ_settings = newSettings
            cooldown._occ_start = 0
            cooldown._occ_duration = 0

            cooldown_OnSetCooldownDuration(cooldown)
        end
    end
end
