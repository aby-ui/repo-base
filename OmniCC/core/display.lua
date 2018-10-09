--[[ A cooldown text display ]] --

local ICON_SIZE = 36 -- the expected size of an icon

local Addon = _G[...]
local UIParent = _G.UIParent
local After = C_Timer.After
local GetTickTime = _G.GetTickTime
local round = _G.Round
local min = math.min
local displays = {}

-- given two cdInfos returns the more important one
local function cdInfo_Compare(lhs, rhs)
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

    -- prefer cdInfos ending first
    local lEnd = lhs.start + lhs.duration
    local rEnd = rhs.start + rhs.duration

    if lEnd < rEnd then
        return lhs
    end

    if lEnd > rEnd then
        return rhs
    end

    -- then check priority
    if lhs.priority < rhs.priority then
        return lhs
    end

    return rhs
end

local Display = Addon:CreateHiddenFrame("Frame")
local Display_MT = {__index = Display}

function Display:Get(parent)
    return displays[parent]
end

function Display:GetOrCreate(parent)
    if not parent then return end

    return displays[parent] or self:Create(parent)
end

function Display:Create(parent)
    local display = setmetatable(Addon:CreateHiddenFrame("Frame", nil, parent), Display_MT)

    display:SetScript("OnSizeChanged", self.OnSizeChanged)
    display.text = display:CreateFontString(nil, "OVERLAY")
    display.text:SetFont(STANDARD_TEXT_FONT, 8, "THIN")

    display.cdInfos = {}
    display.updateScaleCallback = function() display:OnScaleChanged() end

    displays[parent] = display
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
        local settings = self.cdInfo.settings

        if settings and (settings.minEffectDuration or 0) <= self.cdInfo.duration then
            Addon.FX:Run(self.cdInfo.cooldown, settings.effect or "none")
        end
    end
end

function Display:OnTimerDestroyed(timer)
    if self.timer == timer then
        self:HideCooldownText(self.cdInfo)
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

function Display:ShowCooldownText(info)
    if not self.cdInfos[info] then
        self.cdInfos[info] = true
    end

    self:UpdatePrimaryCooldown()
    self:UpdateTimer()
end

function Display:HideCooldownText(info)
    if self.cdInfos[info] then
        self.cdInfos[info] = nil

        self:UpdatePrimaryCooldown()
        self:UpdateTimer()
    end
end

function Display:UpdatePrimaryCooldown()
    local oldInfo = self.cdInfo
    local newInfo = self:GetCooldownWithHighestPriority()

    if oldInfo ~= newInfo then
        self.cdInfo = newInfo

        if newInfo then
            self:SetAllPoints(newInfo.cooldown)
            self:SetFrameLevel(newInfo.cooldown:GetFrameLevel() + 7)
        end
    end
end

function Display:UpdateTimer()
    local oldTimer = self.timer and self.timer
    local oldTimerKey = oldTimer and oldTimer.key

    local newTimer = self.cdInfo and Addon.Timer:GetOrCreate(self.cdInfo)
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

function Display:GetCooldownWithHighestPriority()
    local result

    for info in pairs(self.cdInfos) do
        result = cdInfo_Compare(info, result)
    end

    return result
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
    return self.cdInfo and self.cdInfo.settings
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

Addon.Display = Display
