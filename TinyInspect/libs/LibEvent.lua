
---------------------------------
-- 事件 Author: M
---------------------------------

local MAJOR, MINOR = "LibEvent.7000", 1
local lib = LibStub:NewLibrary(MAJOR, MINOR)

if not lib then return end

lib.events, lib.triggers = {}, {}

local frame = CreateFrame("Frame", nil, UIParent)

frame:SetScript("OnEvent", function(self, event, ...)
    if (not lib.events[event]) then return end
    for k, v in pairs(lib.events[event]) do
        v(v, ...)
    end
end)

--模擬觸發bliz事件
function lib:event(event, ...)
    if (not lib.events[event]) then return end
    for k, v in pairs(lib.events[event]) do
        v(v, ...)
    end
end

--添加bliz事件回調
function lib:addEventListener(event, func)
    for e in string.gmatch(event, "([^,%s]+)") do
        if (not self.events[e]) then
            self.events[e] = {}
            frame:RegisterEvent(e)
        end
        table.insert(self.events[e], func)
    end
    return self
end

--刪除bliz事件回調
function lib:removeEventListener(event, func)
    if (type(event) == "function") then
        for _, funcs in pairs(self.events) do
            for k, v in pairs(funcs) do
                if (v == event) then
                    funcs[k] = nil
                end
            end
        end
    elseif (self.events[event]) then
        for k, v in pairs(self.events[event]) do
            if (v == func) then
                self.events[event][k] = nil
            end
        end
    end
    return self
end

--一次性bliz事件回調
function lib:addEventListenerOnce(event, func)
    return self:addEventListener(event, function(this, ...)
        func(this, ...)
        lib:removeEventListener(event, this)
    end)
end



--添加觸發事件 多個用逗號分隔
function lib:addTriggerListener(event, func)
    for e in string.gmatch(event, "([^,%s]+)") do
        if (not self.triggers[e]) then
            self.triggers[e] = {}
        end
        table.insert(self.triggers[e], func)
    end
    return self
end

--刪除事件回調
function lib:removeTriggerListener(event, func)
    if (type(event) == "function") then
        for _, funcs in pairs(self.triggers) do
            for k, v in pairs(funcs) do
                if (v == event) then
                    funcs[k] = nil
                end
            end
        end
    elseif (self.triggers[event]) then
        for k, v in pairs(self.triggers[event]) do
            if (v == func) then
                self.triggers[event][k] = nil
            end
        end
    end
    return self
end

--刪除事件回調
function lib:removeAllTriggers(event)
    self.triggers[event] = nil
    return self
end

--一次性觸發事件
function lib:addTriggerListenerOnce(event, func)
    return self:addTriggerListener(event, function(this, ...)
        func(this, ...)
        lib:removeTriggerListener(event, this)
    end)
end

--觸發事件
function lib:trigger(event, ...)
    if (not self.triggers[event]) then return end
    for k, v in pairs(self.triggers[event]) do
        v(v, ...)
    end
end

--函數別名
lib.attachEvent = lib.addEventListener
lib.attachEventOnce = lib.addEventListenerOnce
lib.detachEvent = lib.removeEventListener
lib.attachTrigger = lib.addTriggerListener
lib.attachTriggerOnce = lib.addTriggerListenerOnce
lib.detachTrigger = lib.removeTriggerListener
lib.detachAllTriggers = lib.removeAllTriggers
