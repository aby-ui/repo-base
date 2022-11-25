
local addonName, details222 = ...

details222.Scheduler = {
    Names = {},
    Debug = false,
}

local printDebug = function(...)
    if (details222.Scheduler.Debug) then
        print("ISE:", ...)
    end
end

function details222.Scheduler.NewTicker(seconds, callback, name)
    local tickerHandler = C_Timer.NewTicker(seconds, callback)
    if (name) then
        details222.Scheduler.Names[name] = tickerHandler
    end
    return tickerHandler
end

function details222.Scheduler.Cancel(name)
    local ticker = details222.Scheduler.Names[name]
    if (ticker) then
        ticker:Cancel()
        details222.Scheduler.Names[name] = nil
        printDebug("Ticker", name, "Cancelled")
    else
        printDebug("Ticker", name, " Not Found")
    end
end
