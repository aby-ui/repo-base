-- hooks for watching cooldown events
local Addon = _G[...]

local GCD_SPELL_ID = 61304
local COOLDOWN_TYPE_LOSS_OF_CONTROL = _G.COOLDOWN_TYPE_LOSS_OF_CONTROL
local GetSpellCooldown = _G.GetSpellCooldown
local GetTime = _G.GetTime
local cooldowns = {}

local Cooldown = {}

-- queries
function Cooldown:CanShow()
    local start, duration = self._occ_start, self._occ_duration

    -- no active cooldown
    if start <= 0 or duration <= 0 then
        return false
    end

    -- over min duration
    local sets = self._occ_settings
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

function Cooldown:GetKind()
    if self.currentCooldownType == COOLDOWN_TYPE_LOSS_OF_CONTROL then
        return "loc"
    end

    local parent = self:GetParent()
    if parent and parent.chargeCooldown == self then
        return "charge"
    end

    return "default"
end

function Cooldown:GetPriority()
    if self._occ_kind ==  "charge" then
        return 1
    end

    return 2
end

-- actions
function Cooldown:Initialize()
    if cooldowns[self] then return end
    cooldowns[self] = true

    self._occ_start = 0
    self._occ_duration = 0
    self._occ_settings = Addon:GetCooldownSettings(self)

    self:HookScript("OnShow", Cooldown.OnVisibilityUpdated)
    self:HookScript("OnHide", Cooldown.OnVisibilityUpdated)
end

function Cooldown:ShowText()
    local newDisplay = Addon.Display:GetOrCreate(self:GetParent() or self)
    local oldDisplay = self._occ_display

    if oldDisplay and oldDisplay ~= newDisplay then
        oldDisplay:RemoveCooldown(self)
    end

    if newDisplay then
        newDisplay:AddCooldown(self)
    end

    self._occ_display = newDisplay
end

function Cooldown:HideText()
    local display = self._occ_display

    if display then
        display:RemoveCooldown(self)
        self._occ_display  = nil
    end
end

function Cooldown:UpdateText()
    if self._occ_show and self:IsVisible() then
        Cooldown.ShowText(self)
    else
        Cooldown.HideText(self)
    end
end

function Cooldown:Refresh()
    local start, duration = self:GetCooldownTimes()

    start = (start or 0) / 1000
    duration = (duration or 0) / 1000

    Cooldown.Initialize(self)
    Cooldown.SetTimer(self, start, duration)
end

function Cooldown:SetTimer(start, duration)
    if self._occ_start == start and self._occ_duration == duration then
        return
    end

    self._occ_start = start
    self._occ_duration = duration
    self._occ_kind = Cooldown.GetKind(self)
    self._occ_show = Cooldown.CanShow(self)
    self._occ_priority = Cooldown.GetPriority(self)

    Cooldown.UpdateText(self)
end

function Cooldown:SetNoCooldownCount(disable, owner)
    owner = owner or true

    if disable then
        if not self.noCooldownCount then
            self.noCooldownCount = owner
            Cooldown.HideText(self)
        end
    elseif self.noCooldownCount == owner then
        self.noCooldownCount = nil
        Cooldown.Refresh(self)
    end
end

-- events
function Cooldown:OnSetCooldown(start, duration)
    if self.noCooldownCount or self:IsForbidden() then return end

    start = start or 0
    duration = duration or 0

    Cooldown.Initialize(self)
    Cooldown.SetTimer(self, start, duration)
end

function Cooldown:OnSetCooldownDuration()
    if self.noCooldownCount or self:IsForbidden() then return end

    Cooldown.Refresh(self)
end

function Cooldown:SetDisplayAsPercentage()
    if self.noCooldownCount or self:IsForbidden() then return end

    Cooldown.SetNoCooldownCount(self, true)
end

function Cooldown:OnVisibilityUpdated()
    if self.noCooldownCount or self:IsForbidden() then return end

    Cooldown.UpdateText(self)
end

-- misc
function Cooldown:SetupHooks()
    local hooksecurefunc = _G.hooksecurefunc
    local Cooldown_MT = getmetatable(_G.ActionButton1Cooldown).__index

    hooksecurefunc(Cooldown_MT, "SetCooldown", Cooldown.OnSetCooldown)
    hooksecurefunc(Cooldown_MT, "SetCooldownDuration", Cooldown.OnSetCooldownDuration)
    hooksecurefunc("CooldownFrame_SetDisplayAsPercentage", Cooldown.SetDisplayAsPercentage)
end

function Cooldown:UpdateSettings()
    for cd in pairs(cooldowns) do
        local newSettings = Addon:GetCooldownSettings(cd)

        if cd._occ_settings ~= newSettings then
            cd._occ_settings = newSettings
            cd._occ_start = 0
            cd._occ_duration = 0

            Cooldown.Refresh(cd)
        end
    end
end

-- exports
Addon.Cooldown = Cooldown