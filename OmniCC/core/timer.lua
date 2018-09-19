-- A pool of objects for determining what text to display for a given cooldown
-- and notify subscribers when the text change

-- local bindings!
local Addon = _G[...]
local L = _G.OMNICC_LOCALS
local After = _G.C_Timer.After
local GetTime = _G.GetTime
local max = math.max
local min = math.min
local next = next
local strjoin = _G.strjoin
local round = _G.Round

local function roundTo(v, places)
    local exp = 10 ^ places
    return floor(v * exp + 0.5) / exp
end

-- sexy constants!
-- the minimum timer increment
local TICK = 0.01

-- time units in seconds
local DAY = 86400
local HOUR = 3600
local MINUTE = 60

local HALF_DAY = 43200
local HALF_HOUR = 5400
local HALF_MINUTE = 30
local HALF_SECOND = 0.5

-- transition points
local HOURS_THRESHOLD = 84600 --23.5 hours in seconds
local MINUTES_THRESHOLD = 3570 --59.5 minutes in seconds
local SECONDS_THRESHOLD = 59.5
local SOON_THRESHOLD = 5.5

-- internal state!
-- all active timers
local active = {}
-- inactive timers
-- here we use a weak table so that inactive timers are cleaned up on garbage
-- collection
local inactive = setmetatable({}, {__mode = "k" })

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

local Timer = {}
local Timer_MT = { __index = Timer }

function Timer:GetOrCreate(cooldown)
    local start, duration = cooldown:GetCooldownTimes()
    if not (start and start > 0) then
        return
    end

    local kind = cooldown_GetKind(cooldown)
    local settings = Addon:GetGroupSettingsFor(cooldown)
    local key = strjoin("-", start, duration, kind, settings and settings.id or "base")

    local timer = active[key]

    if not timer then
        timer = self:Restore() or self:Create()

        timer.duration = duration / 1000
        timer.key = key
        timer.kind = kind
        timer.settings = settings
        timer.start = start / 1000
        timer.subscribers = {}

        active[key] = timer
        timer:Update()
    end

    return timer
end

function Timer:Restore()
    local timer = next(inactive)

    if timer then
        inactive[timer] = nil
    end

    return timer
end

function Timer:Create()
    local timer = setmetatable({}, Timer_MT)

    timer.callback = function() timer:Update() end

    return timer
end

function Timer:Destroy()
    if not self.key then return end

    active[self.key] = nil

    -- clear subscribers
    for subscriber in pairs(self.subscribers) do
        subscriber:OnTimerDestroyed(self)
    end

    -- reset fields
    self.duration = nil
    self.finished = nil
    self.key = nil
    self.kind = nil
    self.settings = nil
    self.start = nil
    self.state = nil
    self.subscribers = nil
    self.text = nil

    inactive[self] = true
end

function Timer:Update()
    if not self.key then return end

    local remain = self.duration - (GetTime() - self.start)
    if remain > 0 then
        local text, textSleep = self:GetTimerText(remain)
        if self.text ~= text then
            self.text = text
            for subscriber in pairs(self.subscribers) do
                subscriber:OnTimerTextUpdated(self, text)
            end
        end

        local state, stateSleep = self:GetTimerState(remain)
        if self.state ~= state then
            self.state = state
            for subscriber in pairs(self.subscribers) do
                subscriber:OnTimerStateUpdated(self, state)
            end
        end

        local sleep = max(min(textSleep, stateSleep), TICK)
        if sleep < math.huge then
            After(sleep, self.callback)
        end
    elseif not self.finished then
        self.finished = true

        for subscriber in pairs(self.subscribers) do
            subscriber:OnTimerFinished(self)
        end

        self:Destroy()
    end
end

function Timer:Subscribe(subscriber)
    if not self.key then return end

    if not self.subscribers[subscriber] then
        self.subscribers[subscriber] = true
    end
end

function Timer:Unsubscribe(subscriber)
    if not self.key then return end

    if self.subscribers[subscriber] then
        self.subscribers[subscriber] = nil

        if not next(self.subscribers) then
            self:Destroy()
        end
    end
end

function Timer:GetTimerText(remain)
    local tenthsThreshold, mmSSThreshold

    local sets = self.settings
    if sets then
        tenthsThreshold = sets.tenthsDuration or 0
        mmSSThreshold = sets.mmSSDuration or 0
    else
        tenthsThreshold = 0
        mmSSThreshold = 0
    end

    if remain < tenthsThreshold then
        -- tenths of seconds
        local tenths = roundTo(remain, 1)
        local sleep = TICK + (remain - (tenths - 0.05))

        if tenths > 0 then
            return L.TenthsFormat:format(tenths), sleep
        end

        return "", sleep
    elseif remain < SECONDS_THRESHOLD then
        -- seconds
        local seconds = round(remain)

        local sleep = TICK + (remain - max(
            seconds - HALF_SECOND,
            tenthsThreshold
        ))

        if seconds > 0 then
            return seconds, sleep
        end

        return "", sleep
    elseif remain < mmSSThreshold then
        -- MM:SS
        local seconds = round(remain)

        local sleep = TICK + (remain - max(
            seconds - HALF_SECOND,
            SECONDS_THRESHOLD
        ))

        return L.MMSSFormat:format(seconds / MINUTE, seconds % MINUTE), sleep
    elseif remain < MINUTES_THRESHOLD then
        -- minutes
        local minutes = round(remain / MINUTE)

        local sleep = TICK + (remain - max(
            -- transition point of showing one minute versus another (29.5s, 89.5s, 149.5s, ...)
            minutes * MINUTE - HALF_MINUTE,
            -- transition point of displaying minutes to displaying seconds (59.5s)
            SECONDS_THRESHOLD,
            -- transition point of displaying MM:SS (user set)
            mmSSThreshold
        ))

        return L.MinuteFormat:format(minutes), sleep
    elseif remain < HOURS_THRESHOLD then
        -- hours
        local hours = round(remain / HOUR)

        local sleep = TICK + (remain - max(
            hours * HOUR - HALF_HOUR,
            MINUTES_THRESHOLD
        ))

        return L.HourFormat:format(hours), sleep
    else
        -- days
        local days = round(remain / DAY)

        local sleep = TICK + (remain - max(
            days * DAY - HALF_DAY,
            HOURS_THRESHOLD
        ))

        return L.DayFormat:format(days), sleep
    end
end

function Timer:GetTimerState(remain)
    if remain <= 0 then
        return "finished", math.huge
    elseif self.kind == "loc" then
        return "controlled", math.huge
    elseif self.kind == "charge" then
        return "charging", math.huge
    elseif remain < SOON_THRESHOLD then
        return "soon", remain
    elseif remain < SECONDS_THRESHOLD then
        return "seconds", TICK + (remain - SOON_THRESHOLD)
    elseif remain < MINUTES_THRESHOLD then
        return "minutes", TICK + (remain - SECONDS_THRESHOLD)
    else
        return "hours", TICK + (remain - MINUTES_THRESHOLD)
    end
end

function Timer:ForActive(method, ...)
    for _, timer in pairs(active) do
        local func = timer[method]
        if type(func) == "function" then
            func(timer, ...)
        end
    end
end

Addon.Timer = Timer
