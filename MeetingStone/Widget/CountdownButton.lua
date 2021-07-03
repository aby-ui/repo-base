BuildEnv(...)

---@class CountdownButton: Button
CountdownButton = Addon:NewClass('UI.CountdownButton', 'Button')

function CountdownButton:Constructor()
    self._enabled = self:IsEnabled()
end

function CountdownButton:Enable()
    return self:SetEnabled(true)
end

function CountdownButton:Disable()
    return self:SetEnabled(false)
end

function CountdownButton:SetEnabled(flag)
    self._enabled = flag
    self:Update()
end

local function Update(obj)
    if obj._countdownWidgets then
        for i, widget in ipairs(obj._countdownWidgets) do
            widget:Update()
        end
    else
        obj:Update()
    end
end

function CountdownButton:SetCountdown(duration)
    local obj = self:GetCountdownObject()
    if obj._timer then
        obj._timer:Cancel()
    end

    obj._timer = C_Timer.NewTimer(duration, function()
        obj._timer = nil
        Update(obj)
    end)
    C_Timer.After(0, function()
        Update(obj)
    end)
end

function CountdownButton:SetCountdownObject(obj)
    self._countdownObj = obj
    obj._countdownWidgets = obj._countdownWidgets or {}
    tinsert(obj._countdownWidgets, self)
end

function CountdownButton:GetCountdownObject()
    return self._countdownObj or self
end

function CountdownButton:Update()
    local obj = self:GetCountdownObject()
    self:SuperCall('SetEnabled', not obj._timer and self._enabled)
end
