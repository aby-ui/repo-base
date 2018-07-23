
local onevent = function()
    for a,timer in pairs(TimerTracker.timerList) do
        timer.time = nil
        timer.type = nil
        timer.isFree = true
        timer:SetScript("OnUpdate", nil)
        timer.fadeBarOut:Stop()
        timer.fadeBarIn:Stop()
        timer.startNumbers:Stop()
        --timer.factionAnim:Stop()
        timer.bar:SetAlpha(0)
    end   
end

CoreOnEvent('PLAYER_ENTERING_WORLD', onevent)
TimerTracker:UnregisterEvent'PLAYER_ENTERING_WORLD'


