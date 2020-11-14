-- functions I call at least three(ish) times
local AddonName, Addon = ...

-- create a frame, and then hide it
function Addon:CreateHiddenFrame(...)
    local frame = CreateFrame(...)

    frame:Hide()

    return frame
end

-- A utility function for extending blizzard widget types (Frames, Buttons, etc)
do
    -- extend basically just does a post hook of an existing object method
    -- its here so that I can not forget to do class.proto.thing when hooking
    -- thing
    local function class_Extend(class, method, func)
        if not (type(method) == 'string' and type(func) == 'function') then
            error('Usage: Class:Extend("method", func)', 2)
        end

        if type(class.proto[method]) ~= 'function' then
            error(('Parent has no method named %q'):format(method), 2)
        end

        class[method] = function(self, ...)
            class.proto[method](self, ...)

            return func(self, ...)
        end
    end

    function Addon:CreateClass(frameType, prototype)
        local class = self:CreateHiddenFrame(frameType)

        local class_mt = {__index = class}

        class.Bind = function(_, object)
            return setmetatable(object, class_mt)
        end

        if type(prototype) == 'table' then
            class.proto = prototype
            class.Extend = class_Extend

            setmetatable(class, {__index = prototype})
        end

        return class
    end
end
-- returns a function that generates unique names for frames
-- in the format <AddonName>_<Prefix>[1, 2, ...]
function Addon:CreateNameGenerator(prefix)
    local id = 0
    return function()
        id = id + 1
        return ('%s_%s_%d'):format(AddonName, prefix, id)
    end
end

-- A functional way to fade a frame from one opacity to another without constantly
-- creating new animation groups for the frame
do

    local function clouseEnough(value1, value2)
        return _G.Round(value1 * 100) == _G.Round(value2 * 100)
    end

    -- track the time the animation started playing
    -- this is so that we can figure out how long we've been delaying for
    local function animation_OnPlay(self)
        self.start = _G.GetTime()
    end

    local function sequence_OnFinished(self)
        if self.alpha then
            self:GetParent():SetAlpha(self.alpha)
            self.alpha = nil
        end
    end

    local function sequence_Create(frame)
        local sequence = frame:CreateAnimationGroup()
        sequence:SetLooping('NONE')
        sequence:SetScript('OnFinished', sequence_OnFinished)
        sequence.alpha = nil

        local animation = sequence:CreateAnimation('Alpha')
        animation:SetSmoothing('IN_OUT')
        animation:SetOrder(0)
        animation:SetScript('OnPlay', animation_OnPlay)

        return sequence, animation
    end

    Addon.Fade =
        setmetatable(
        {},
        {
            __call = function(self, addon, frame, toAlpha, delay, duration)
                return self[frame](toAlpha, delay, duration)
            end,

            __index = function(self, frame)
                local sequence, animation

                -- handle animation requests
                local function func(toAlpha, delay, duration)
                    -- we're already at target alpha, stop
                    if clouseEnough(frame:GetAlpha(), toAlpha) then
                        if sequence and sequence:IsPlaying() then
                            sequence:Stop()
                            return
                        end
                    end

                    -- create the animation if we've not yet done so
                    if not sequence then
                        sequence, animation = sequence_Create(frame)
                    end

                    local fromAlpha = frame:GetAlpha()

                    -- animation already started, but is in the delay phase
                    -- so shorten the delay by however much time has gone by
                    if animation:IsDelaying() then
                        delay = math.max(delay - (_G.GetTime() - animation.start), 0)
                    -- we're already in the middle of a fade animation
                    elseif animation:IsPlaying() then
                        -- set delay to zero, as we don't want to pause in the
                        -- middle of an animation
                        delay = 0

                        -- figure out what opacity we're currently at
                        -- by using the animation progress
                        local delta = animation:GetFromAlpha() - animation:GetToAlpha()
                        fromAlpha = animation:GetFromAlpha() + (delta * animation:GetSmoothProgress())
                    end

                    -- check that value against our current one
                    -- if so, quit early
                    if clouseEnough(fromAlpha, toAlpha) then
                        frame:SetAlpha(toAlpha)

                        if sequence:IsPlaying() then
                            sequence:Stop()
                            return
                        end
                    end

                    sequence.alpha = toAlpha
                    animation:SetFromAlpha(frame:GetAlpha())
                    animation:SetToAlpha(toAlpha)
                    animation:SetStartDelay(delay)
                    animation:SetDuration(duration)

                    sequence:Restart()
                end

                self[frame] = func
                return func
            end
        }
    )
end

-- somewhere between a debounce and a throttle
function Addon:Defer(func, delay, arg1)
    delay = delay or 0

    local waiting = false

    local function callback()
        func(arg1)

        waiting = false
    end

    return function()
        if not waiting then
            waiting = true

            C_Timer.After(delay or 0, callback)
        end
    end
end
