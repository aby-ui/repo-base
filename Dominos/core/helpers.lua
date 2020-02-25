-- functions I call at least three(ish) times

local AddonName, Addon = ...

-- create a frame, and then hide it
function Addon:CreateHiddenFrame(...)
    local frame = CreateFrame(...)

    frame:Hide()

    return frame
end

-- A utility function for extending blizzard widget types (Frames, Buttons, etc)
function Addon:CreateClass(frameType, prototype)
    local class = self:CreateHiddenFrame(frameType)
    local class_mt = { __index = class }

    class.Bind = function(_, obj)
        return setmetatable(obj, class_mt)
    end

    if prototype then
        class.proto = prototype

        return setmetatable(class, {__index = prototype})
    end

    return class
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
    local function fader_OnFinished(self)
        self:GetParent():SetAlpha(self.toAlpha)
    end

    local faders = setmetatable({}, {
        __index = function(t, k)
            local animation = k:CreateAnimationGroup()
            animation:SetLooping('NONE')
            animation:SetScript('OnFinished', fader_OnFinished)

            local fade = animation:CreateAnimation('Alpha')
            fade:SetSmoothing('IN_OUT')

            local v = function(toAlpha, delay, duration)
                if animation:IsPlaying() then
                    animation:Pause()
                end

                fade:SetFromAlpha(k:GetAlpha())
                fade:SetToAlpha(toAlpha)
                fade:SetStartDelay(delay)
                fade:SetDuration(duration)

                animation.toAlpha = toAlpha
                animation:Play()
            end
            t[k] = v
            return v
        end
    })

    function Addon:Fade(frame, toAlpha, delay, duration)
        faders[frame](toAlpha, delay, duration)
    end
end
