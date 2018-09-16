--[[ A cooldown text display ]] --

local Addon = _G[...]

local ICON_SIZE = math.ceil(_G.ActionButton1:GetWidth()) -- the expected size of an icon

local round = _G.Round
local min = math.min
local displays = {}

local function cooldown_GetEndTime(cooldown)
    local start, duration = cooldown:GetCooldownTimes()

    return start + duration
end

-- gets the priority associated with a cooldown relative to its parent
-- lower numbers == more important
local function cooldown_GetPriority(cooldown)
    local parent = cooldown:GetParent()
    if parent and parent.chargeCooldown == cooldown then
        return 2
    end

    return 1
end

-- given two cooldowns returns the more important one
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

    -- prefer cooldowns ending first
    local lEnd = cooldown_GetEndTime(lhs)
    local rEnd = cooldown_GetEndTime(rhs)

    if lEnd < rEnd then
        return lhs
    end

    if lEnd > rEnd then
        return rhs
    end

    -- then check priority
    if cooldown_GetPriority(lhs) < cooldown_GetPriority(rhs) then
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
    display.cooldowns = {}

    displays[parent] = display
    return display
end


-- adjust font size whenever the timer's size changes
-- and hide if it gets too tiny
function Display:OnSizeChanged(width, height)
    local scale = round(min(width, height)) / ICON_SIZE

    if scale ~= self.scale then
        self.scale = scale

        self:UpdateCooldownTextShown()
        self:UpdateCooldownTextStyle()
    end
end

-- update text when the timer notifies us of a change
function Display:OnTimerTextUpdated(timer, text)
    if self.timer == timer then
        self.text:SetText(text)
    end
end

function Display:OnTimerStateUpdated(timer, state)
    if self.timer == timer then
        self:UpdateCooldownTextStyle()
    end
end

function Display:OnTimerFinished(timer)
    if self.timer == timer then
        local settings = self:GetCooldownSettings()

        if settings and timer.duration >= (settings.minEffectDuration or 0) then
            Addon.FX:Run(self.cooldown, settings.effect or "none")
        end
    end
end

function Display:OnTimerDestroyed(timer)
    if self.timer == timer then
        self:HideCooldownText(self.cooldown)
    end
end

function Display:ShowCooldownText(cooldown)
    if not self.cooldowns[cooldown] then
        self.cooldowns[cooldown] = true
    end

    self:UpdatePrimaryCooldown()
    self:UpdateTimer()
end

function Display:HideCooldownText(cooldown)
    if self.cooldowns[cooldown] then
        self.cooldowns[cooldown] = nil

        self:UpdatePrimaryCooldown()
        self:UpdateTimer()
    end
end

function Display:UpdatePrimaryCooldown()
    local old = self.cooldown
    local new = self:GetCooldownWithHighestPriority()

    if old ~= new then
        self.cooldown = new

        if new then
            self:SetAllPoints(new)
        end
    end
end

function Display:UpdateTimer()
    local oldTimer = self.timer
    local newTimer = self.cooldown and Addon.Timer:GetOrCreate(self.cooldown)

    if oldTimer ~= newTimer then
        self.timer = newTimer

        if oldTimer then
            oldTimer:Unsubscribe(self)
        end

        if newTimer then
            newTimer:Subscribe(self)

            self:UpdateCooldownText()
            self:Show()
        else
            self:Hide()
        end
    end
end

function Display:GetCooldownWithHighestPriority()
    local cooldown

    for cd in pairs(self.cooldowns) do
        cooldown = cooldown_Compare(cd, cooldown)
    end

    return cooldown
end

function Display:SetCooldownText(text)
    self.text:SetText(text or "")
end

function Display:UpdateCooldownText()
    self:UpdateCooldownTextShown()
    self:UpdateCooldownTextStyle()
    self:UpdateCooldownTextPosition()

    self.text:SetText(self.timer and self.timer.text or "")
end

function Display:UpdateCooldownTextShown()
    local sets = self:GetCooldownSettings()
    if not sets then return end

    local scale = self.scale or 1
    local frameScale = self:GetEffectiveScale() / _G.UIParent:GetScale()

    if (scale * frameScale) >= (sets and sets.minSize or 0) then
        self.text:Show()
    else
        self.text:Hide()
    end
end

function Display:UpdateCooldownTextStyle()
    local sets = self:GetCooldownSettings()
    if not sets then return end

    local face = sets.fontFace
    local outline = sets.fontOutline
    local style = sets.styles[self.timer and self.timer.state or "seconds"]
    local size = sets.fontSize * style.scale * (sets.scaleText and self.scale or 1)
    local text = self.text

    if size > 0 then
        if not text:SetFont(face, size, outline) then
            text:SetFont(STANDARD_TEXT_FONT, size, outline)
        end

        text:SetTextColor(style.r, style.g, style.b, style.a)
    end
end

function Display:UpdateCooldownTextPosition()
    local sets = self:GetCooldownSettings()
    if not sets then return end

    local scale = self.scale or 1

    self.text:ClearAllPoints()
    self.text:SetPoint(sets.anchor, sets.xOff * scale, sets.yOff * scale)
end

function Display:GetCooldownSettings()
    return self.cooldown and Addon:GetGroupSettingsFor(self.cooldown)
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
