if CoreOnEvent then return end
local eventFuncs = {}
local core = { frame = CreateFrame("Frame") }
local pairs,ipairs,next,wipe,assert,type,tinsert,select,tremove,GetTime,setmeta,rawg = pairs,ipairs,next,wipe,assert,type,tinsert,select,tremove,GetTime,setmetatable, rawget
local CoreDispatchEventFunc;
function CoreDispatchEvent(frame, addon)
    frame.addon = addon or frame;
    CoreDispatchEventFunc = CoreDispatchEventFunc or function(self, event, ...)
        local func = self.addon[event];
        if(type(func)=="function")then
            func(self.addon, event, ...);
        else
            func = self.addon.DEFAULT_EVENT;
            --assert(type(func)=="function", "没有事件["..event.."]的处理函数.");
            if(type(func)~="function") then
                print("No function for ["..event.."]");
                return
            end
            func(self.addon, event, ...);
        end
    end
    frame:SetScript("OnEvent", CoreDispatchEventFunc);
end

function CoreOnEvent(event, func, frame)
    if frame then
        if type(frame)=="table" then
            frame:RegisterEvent(event);
            frame[event] = func;
        else
            local f = CreateFrame("Frame");
            CoreDispatchEvent(f)
            f:RegisterEvent(event);
            f[event] = func;
            return f;
        end
    end

    if(not core.frame:IsEventRegistered(event)) then
        core.frame:RegisterEvent(event);
    end
    local eventTable = eventFuncs[event];
    if(eventTable==nil)then eventTable={} eventFuncs[event]=eventTable end
    tinsert(eventTable, func);
end

function CoreBuildLocale(debug)
    return setmeta({ _DEBUG = debug and {} or nil }, {
        __index = function(self, key)
            if(debug) then tinsert(self._DEBUG, key) end
            return key
        end,
        __call = function(self, key) return self[key]  end
    })
end

function SetOrHookScript(target,eventName,func)
	if target:GetScript(eventName) then
		return target:HookScript(eventName,func)
	else
		return target:SetScript(eventName,func)
	end
end