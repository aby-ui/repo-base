--------------------------------------------------------------------------------
-- Handles fading out frames when not moused over
--------------------------------------------------------------------------------

local _, Addon = ...

local FadeManager = Addon:NewModule('FadeManager', 'AceEvent-3.0')
local watched = {}

function FadeManager:Load()
    self:RequestUpdate()
    self:RegisterEvent('PLAYER_ENTERING_WORLD', 'Update')
end

function FadeManager:Unload()
    self:UnregisterEvent('PLAYER_ENTERING_WORLD')
end

function FadeManager:Update()
    for frame in pairs(watched) do
        if frame:IsFocus() then
            if not frame.focused then
                frame.focused = true
                frame:FadeIn()
            end
        else
            if frame.focused then
                frame.focused = nil
                frame:FadeOut()
            end
        end
    end

    if next(watched) then
        self:RequestUpdate()
    end
end

function FadeManager:RequestUpdate()
    if not self._update then
        self._update = function()
            self._waiting = false
            self:Update()
        end
    end

    if not self._waiting then
        self._waiting = true
        C_Timer.After(0.15, self._update)
    end
end

function FadeManager:Add(frame)
    if not watched[frame] then
        watched[frame] = true

        frame.focused = frame:IsFocus() and true or nil
        frame:UpdateAlpha()

        self:RequestUpdate()
    end
end

function FadeManager:Remove(frame)
    if watched[frame] then
        watched[frame] = nil

        frame.focused = nil
        frame:UpdateAlpha()
    end
end

-- exports
Addon.FadeManager = FadeManager
