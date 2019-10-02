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
    local faders = {}

    local function fader_OnFinished(self)
        self:GetParent():SetAlpha(self.toAlpha)
    end

    local function fader_Create(parent)
        local animation = parent:CreateAnimationGroup()
        animation:SetLooping('NONE')
        animation:SetScript('OnFinished', fader_OnFinished)

        local fade = animation:CreateAnimation('Alpha')
        fade:SetSmoothing('IN_OUT')

        return function(toAlpha, duration)
            if animation:IsPlaying() then
                animation:Pause()
            end

            fade:SetFromAlpha(parent:GetAlpha())
            fade:SetToAlpha(toAlpha)
            fade:SetDuration(duration)

            animation.toAlpha = toAlpha
            animation:Play()
        end
    end

    function Addon:Fade(frame, toAlpha, duration)
        local fade = faders[frame]

        if not fade then
            fade = fader_Create(frame)
            faders[frame] = fade
        end

        fade(toAlpha, duration)
    end
end
