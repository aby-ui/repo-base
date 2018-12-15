-- A cooldown text display
local Addon = _G[...]

local ICON_SIZE = 36 -- the expected size of an icon

local After = _G.C_Timer.After
local GetTickTime = _G.GetTickTime
local min = math.min
local round = _G.Round
local UIParent = _G.UIParent

local displays = {}

local Display = Addon:CreateHiddenFrame("Frame")

Display.__index = Display

function Display:Get(owner)
    return displays[owner]
end

function Display:GetOrCreate(owner)
    if not owner then return end

    return displays[owner] or self:Create(owner)
end

function Display:Create(owner)
    local display = setmetatable(Addon:CreateHiddenFrame("Frame", nil, owner), Display)

    display:SetScript("OnSizeChanged", self.OnSizeChanged)
    display.text = display:CreateFontString(nil, "OVERLAY")
    display.text:SetFont(STANDARD_TEXT_FONT, 8, "THIN")

    display.cooldowns = {}
    display.updateScaleCallback = function() display:OnScaleChanged() end

    displays[owner] = display
    return display
end

-- adjust font size whenever the timer's size changes
-- and hide if it gets too tiny
function Display:OnSizeChanged()
    local oldSize = self.sizeRatio

    if oldSize ~= self:CalculateSizeRatio() then
        self:UpdateCooldownTextStyle()
        self:UpdateCooldownTextShown()
    end
end

-- adjust font size whenever the timer's size changes
-- and hide if it gets too tiny
function Display:OnScaleChanged()
    local oldScale = self.scaleRatio

    if oldScale ~= self:CalculateScaleRatio() then
        self:UpdateCooldownTextStyle()
        self:UpdateCooldownTextShown()
    end
end
-- update text when the timer notifies us of a change
function Display:OnTimerTextUpdated(timer)
    if self.timer == timer then
        self.text:SetText(self.timer and self.timer.text or "")
    end
end

function Display:OnTimerStateUpdated(timer, state)
    if self.timer == timer then
        self:UpdateCooldownTextStyle()
    end
end

function Display:OnTimerFinished(timer)
    if self.timer == timer then
        local cooldown = self.activeCooldown

        local settings = cooldown._occ_settings
        if settings and (settings.minEffectDuration or 0) <= cooldown._occ_duration then
            Addon.FX:Run(self.activeCooldown, settings.effect or "none")
        end
    end
end

function Display:OnTimerDestroyed(timer)
    if self.timer == timer then
        self:RemoveCooldown(self.activeCooldown)
    end
end

function Display:CalculateSizeRatio()
    local sizeRatio = round(min(self:GetSize())) / ICON_SIZE

    self.sizeRatio = sizeRatio

    return sizeRatio
end

function Display:CalculateScaleRatio()
    local scaleRatio = self:GetEffectiveScale() / UIParent:GetEffectiveScale()

    self.scaleRatio = scaleRatio

    return scaleRatio
end

function Display:AddCooldown(cooldown)
    local cooldowns = self.cooldowns
    if not cooldowns[cooldown] then
        cooldowns[cooldown] = true
    end

    self:UpdatePrimaryCooldown()
    self:UpdateTimer()
end

function Display:RemoveCooldown(cooldown)
    local cooldowns = self.cooldowns
    if cooldowns[cooldown] then
        cooldowns[cooldown] = nil

        self:UpdatePrimaryCooldown()
        self:UpdateTimer()
    end
end

function Display:UpdatePrimaryCooldown()
    local oldCooldown = self.activeCooldown
    local newCooldown = self:GetCooldownWithHighestPriority()

    if oldCooldown ~= newCooldown then
        self.activeCooldown = newCooldown

        if newCooldown then
            self:SetAllPoints(newCooldown)
            self:SetFrameLevel(newCooldown:GetFrameLevel() + 7)
        end
    end
end

function Display:UpdateTimer()
    local oldTimer = self.timer and self.timer
    local oldTimerKey = oldTimer and oldTimer.key

    local newTimer = self.activeCooldown and Addon.Timer:GetOrCreate(self.activeCooldown)
    local newTimerKey = newTimer and newTimer.key

    -- update subscription if we're watching a different timer
    if oldTimer ~= newTimer then
        self.timer = newTimer

        if oldTimer then
            oldTimer:Unsubscribe(self)
        end
    end

    -- only show display if we have a timer to watch
    if newTimer then
        newTimer:Subscribe(self)

        -- only update text if the timer we're watching has changed
        if newTimerKey ~= oldTimerKey then
            self:UpdateCooldownText()
            self.text:SetText(newTimer.text or "")
            self:Show()
        end

        -- SUF hack to update scale of frames after cooldowns are set
        After(GetTickTime(), self.updateScaleCallback)
    else
        self:Hide()
    end
end

do
    -- given two cooldown cooldowns, returns the more important one
    local function cooldown_Compare(lhs, rhs)
        if lhs == rhs then
            return lhs
        end

        -- prefer the one that isn't nil
        if rhs == nil then
            return lhs
        end

        if lhs == nil then
            return rhs
        end

        -- prefer cooldownProxies ending first
        local lEnd = lhs._occ_start + lhs._occ_duration
        local rEnd = rhs._occ_start + rhs._occ_duration

        if lEnd < rEnd then
            return lhs
        end

        if lEnd > rEnd then
            return rhs
        end

        -- then check priority
        if lhs._occ_priority < rhs._occ_priority then
            return lhs
        end

        return rhs
    end

    function Display:GetCooldownWithHighestPriority()
        local result

        for cooldown in pairs(self.cooldowns) do
            result = cooldown_Compare(cooldown, result)
        end

        return result
    end
end

function Display:UpdateCooldownText()
    self:UpdateCooldownTextPosition()
    self:UpdateCooldownTextStyle()
    self:UpdateCooldownTextShown()
end

function Display:UpdateCooldownTextShown()
    local sets = self:GetSettings()
    if not sets then return end

    -- compare as ints to avoid floating point math errors
    local sizeRatio = self.sizeRatio or self:CalculateSizeRatio()
    local scaleRatio = self.scaleRatio or self:CalculateScaleRatio()

    if (sizeRatio * scaleRatio) >= (sets.minSize or 0) then
        self.text:Show()
    else
        self.text:Hide()
    end
end

function Display:UpdateCooldownTextStyle()
    local sets = self:GetSettings()
    if not sets then return end

    local text = self.text
    local face = sets.fontFace
    local outline = sets.fontOutline
    local style = sets.styles[self.timer and self.timer.state or "seconds"]

    local size = sets.fontSize * style.scale
    if sets.scaleText then
        size = size * (self.sizeRatio or self:CalculateSizeRatio())
    end

    if size > 0 then
        if not text:SetFont(face, size, outline) then
            text:SetFont(STANDARD_TEXT_FONT, size, outline)
        end

        text:SetTextColor(style.r, style.g, style.b, style.a)
    end
end

function Display:UpdateCooldownTextPosition()
    local sets = self:GetSettings()
    if not sets then return end

    local sizeRatio = self.sizeRatio or self:CalculateSizeRatio()

    self.text:ClearAllPoints()
    self.text:SetPoint(sets.anchor, sets.xOff * sizeRatio, sets.yOff * sizeRatio)
end

function Display:GetSettings()
    return self.activeCooldown and self.activeCooldown._occ_settings
end

function Display:ForAll(method, ...)
    for _, display in pairs(displays) do
        local func = display[method]
        if type(func) == "function" then
            func(display, ...)
        end
    end
end

function Display:ForActive(method, ...)
    for _, display in pairs(displays) do
        if display.timer ~= nil then
            local func = display[method]
            if type(func) == "function" then
                func(display, ...)
            end
        end
    end
end

-- exports
Addon.Display = Display
