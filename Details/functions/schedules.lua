


local Details = _G.Details
local DF = _G.DetailsFramework
local C_Timer = _G.C_Timer
local unpack = _G.unpack
local addonName, Details222 = ...

--make a namespace for schedules
Details.Schedules = {}

local errorHandler = function(str)
    return str
end

--run a scheduled function with its payload
local triggerScheduledTick = function(tickerObject)
    local payload = tickerObject.payload
    local callback = tickerObject.callback

    local result, errortext = xpcall(callback, geterrorhandler(), unpack(payload))
    if (not result) then
        --Details:Msg("Error:", errortext, tickerObject.name or "")
    end
    return result
end

--schedule to repeat a task with an interval of @time
function Details.Schedules.NewTicker(time, callback, ...)
    local payload = {...}
    local newTicker = C_Timer.NewTicker(time, triggerScheduledTick)
    newTicker.payload = payload
    newTicker.callback = callback

    --debug
    newTicker.path = debugstack()
    --
    return newTicker
end

--cancel an ongoing ticker
function Details.Schedules.Cancel(tickerObject)
    --ignore if there's no ticker object
    if (tickerObject) then
        return tickerObject:Cancel()
    end
end

--schedule a task with an interval of @time
function Details.Schedules.NewTimer(time, callback, ...)
    local payload = {...}
    local newTimer = C_Timer.NewTimer(time, triggerScheduledTick)
    newTimer.payload = payload
    newTimer.callback = callback

    --debug
    newTimer.path = debugstack()
    --

    return newTimer
end

--schedule a task with an interval of @time without payload
function Details.Schedules.After(time, callback)
    C_Timer.After(time, callback)
end

function Details.Schedules.SetName(object, name)
    object.name = name
end
