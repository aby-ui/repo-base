--[[
Throttle.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

BuildEnv(...)

local Throttle = Addon:NewClass('Throttle')

function Throttle:Constructor(interval, total)
    self.interval = interval * 1000
    self.total    = total
    self.count    = 0
    self.tick     = 0
end

local function now()
    return floor((time() + GetTime() % 1) * 1000)
end

function Throttle:Mark()
    local now = now()
    if now - self.tick > self.interval then
        self.tick  = now
        self.count = 1
    else
        self.count = self.count + 1
    end
end

function Throttle:IsThrottled()
    return not (now() - self.tick > self.interval or self.count < self.total)
end
