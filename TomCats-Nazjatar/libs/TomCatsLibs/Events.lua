--noinspection UnusedDef
local addon = select(2,...)
local eventFrame = CreateFrame("Frame")
local onUpdate, eventHandler
local eventListeners = { }

local function validateRegisterUnregisterInput(event, listener)
    if ((not event) or (type(event) ~= "string")) then error("Event must be specified", 3) end
    if ((not listener) or (type(listener) ~= "table" and type(listener) ~= "function")) then error("Listener must be specified", 3) end
end

function addon.TomCatsLibs.Events.RegisterEvent(event, listener)
    validateRegisterUnregisterInput(event, listener)
    eventListeners[event] = eventListeners[event] or {}
    for i = 1, #eventListeners[event] do
        if (eventListeners[event][i] == listener) then error(tostring(listener) .. " already associated with " .. event, 2) end
    end
    table.insert(eventListeners[event], listener)
    if (#eventListeners[event] == 1) then
        if (event == "ON_UPDATE") then
            eventFrame:SetScript("OnUpdate", onUpdate)
        else
            eventFrame:RegisterEvent(event)
        end
    end
end

function addon.TomCatsLibs.Events.UnregisterEvent(event, listener)
    validateRegisterUnregisterInput(event, listener)
    if (eventListeners[event]) then
        for i = 1, #eventListeners[event] do
            if (eventListeners[event][i] == listener) then
                table.remove(eventListeners[event],i)
                if (#eventListeners[event] == 0) then
                    if (event == "ON_UPDATE") then
                        eventFrame:SetScript("OnUpdate", nil)
                    else
                        eventFrame:UnregisterEvent(event);
                    end
                end
                break;
            end
        end
    end
end

function onUpdate()
    eventHandler(nil, "ON_UPDATE")
end

function eventHandler(_, event, ...)
    local eventListenersQueue = Mixin({}, eventListeners[event])
    if (eventListenersQueue) then
        for i = 1, #eventListenersQueue do
            if (type(eventListenersQueue[i]) == "table") then
                if (eventListenersQueue[i][event] and (type(eventListenersQueue[i][event]) == "function")) then
                    eventListenersQueue[i][event](eventListenersQueue[i], event, ...)
                else
                    error("cannot find a function named " .. event .. " in table " .. tostring(eventListenersQueue[i]))
                end
            elseif (type(eventListenersQueue[i]) == "function") then
                eventListenersQueue[i](eventListenersQueue[i], event, ...)
            else
                error("cannot relay the event for " .. event)
            end
        end
    end
end

eventFrame:SetScript("OnEvent", eventHandler)
