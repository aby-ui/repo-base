if CoreDispatchEvent and CoreOnEventBucket then return end
local pairs,ipairs,next,wipe,assert,type,tinsert,select,tremove,GetTime,setmeta,rawg = pairs,ipairs,next,wipe,assert,type,tinsert,select,tremove,GetTime,setmetatable, rawget

function SetOrHookScript(target,eventName,func)
	if target:GetScript(eventName) then
		return target:HookScript(eventName,func)
	else
		return target:SetScript(eventName,func)
	end
end

function CoreGetTooltipForScan()
    local tipname = "CoreScanTooltip"
    local tip = _G[tipname] or CreateFrame("GameTooltip", tipname, nil, "GameTooltipTemplate")
    return tip, tipname
end

--[[
	 xpcall safecall implementation
]]
local xpcall = xpcall

local function errorhandler(err)
    return geterrorhandler()(err)
end

local function CreateDispatcher(argCount)
    local code = [[
		local xpcall, eh = ...
		local method, ARGS
		local function call() return method(ARGS) end

		local function dispatch(func, ...)
			method = func
			if not method then return end
			ARGS = ...
			return xpcall(call, eh)
		end

		return dispatch
	]]

    local ARGS = {}
    for i = 1, argCount do ARGS[i] = "arg"..i end
    code = code:gsub("ARGS", table.concat(ARGS, ", "))
    return assert(loadstring(code, "safecall Dispatcher["..argCount.."]"))(xpcall, errorhandler)
end

local Dispatchers = setmetatable({}, {__index=function(self, argCount)
    local dispatcher = CreateDispatcher(argCount)
    rawset(self, argCount, dispatcher)
    return dispatcher
end})
Dispatchers[0] = function(func)
    return xpcall(func, errorhandler)
end

function safecall(func, ...)
    return Dispatchers[select("#", ...)](func, ...)
end

---复制数据,如果不提供toTable则新建一个
function u1copy(fromTable, toTable)
    toTable = toTable or {}
    if not fromTable then return end
    for k,v in pairs(fromTable) do
        toTable[k] = v;
    end
    return toTable;
end
copy = copy or u1copy

function deepmix(targetTable, dataTable)
    for k, v in pairs(dataTable) do
        if type(v) == "table" and type(targetTable[k]) == "table" then
            deepmix(targetTable[k], v)
        else
            targetTable[k] = v
        end
    end
end

---删除数组里的元素
function tremovedata(t, data)
    for i=#t,1,-1 do
        if t[i]==data then
            tremove(t, i)
        end
    end
end

---增加数据保证不重复, 如果插入了返回true
function tinsertdata(array, data)
    for i=1,#array do
        if(array[i]==data) then return end
    end
    tinsert(array, data);
    return true;
end

local core = {}

LibStub("AceTimer-3.0"):Embed(core)
function CoreScheduleTimer(repeating, delay, callback, arg)
    if(repeating)then
        return core:ScheduleRepeatingTimer(callback, delay, arg)
    else
        return core:ScheduleTimer(callback, delay, arg)
    end
end
function CoreCancelTimer(handle, silent)
    return core:CancelTimer(handle, silent);
end
local allTimers = {}
function CoreScheduleBucket(timerName, delay, callback, arg)
    if allTimers[timerName] then
        CoreCancelTimer(allTimers[timerName])
    end
    local timer = CoreScheduleTimer(false, delay, function(...) allTimers[timerName] = nil callback(...) end, arg)
    allTimers[timerName] = timer
    return timer
end

function CoreCancelBucket(timerName)
    if allTimers[timerName] then
        CoreCancelTimer(allTimers[timerName])
    end
end

core.frame = CreateFrame("Frame")
local runOnNextCount = 0
local runOnNextFrame = {}
local runOnNextKeyCount = 0
local runOnNextKey = setmetatable({}, {__newindex = function(t, k, v) rawset(t, k, v) runOnNextKeyCount=runOnNextKeyCount+1 end})
core.frame:SetScript("OnUpdate", function(self)
    if runOnNextKeyCount > 0 then
        for k,v in next, runOnNextKey do
            safecall(v, k);
            runOnNextKey[k] = nil
        end
        runOnNextKeyCount = 0;
    end
    if runOnNextCount > 0 then
        --通过oldCount可以解决func里继续runOnNextFrame的
        local oldCount = runOnNextCount
        for i=1, oldCount do
            local v = runOnNextFrame[i];
            if v[1] then
                safecall(v[1], select(2, unpack(v)));
            end
            wipe(v);
        end
        runOnNextCount = runOnNextCount - oldCount;
        --将后面新加的复制到列表前面
        for i=1, runOnNextCount do
            u1copy(runOnNextFrame[i+runOnNextCount], runOnNextFrame[i]);
            wipe(runOnNextFrame[i+runOnNextCount]);
        end
    end
end)

---下一帧调用的功能, 用于某些hook的时候要保证在过程之后运行的情况
function RunOnNextFrame(func, ...)
    --assert(type(func)=="function", "Parameter must be function.")
    runOnNextCount = runOnNextCount+1;
    local data=runOnNextFrame[runOnNextCount];
    if(not data)then
        data={};
        runOnNextFrame[runOnNextCount]=data;
    end
    data[1]=func;
    for i=1,select("#", ...) do
        data[i+1]=select(i, ...);
    end
end

function RunOnNextFrameKey(key, func)
    runOnNextKey[key] = func;
end

function RunOnNextFrameKeyCancel(key)
    runOnNextKey[key] = nil;
end

---简单的时间分发机制
--@param addon 具有addon:EVENT的对象.
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

local eventRegistration = {}
function CoreAddEvent(event)
    eventRegistration[event] = eventRegistration[event] or {};
end
function CoreRegisterEvent(event, obj)
    local reg = eventRegistration[event];
    assert(reg, "No event '"..event.."' is defined.");
    tinsert(reg, (WW and WW.un) and WW:un(obj) or obj._F or obj);
    if event == "INIT_COMPLETED" and U1IsInitComplete() then
        local obj = reg[#reg]
        safecall(obj[event], obj);
    end
end
function CoreUnregisterEvent(event, obj)
    local reg = eventRegistration[event];
    assert(reg, "No event '"..event.."' is defined.");
    tremovedata(reg, WW and WW:un(obj) or obj._F or obj);
end
function CoreUnregisterAllEvents(obj)
    for k, v in pairs(eventRegistration) do
        CoreUnregisterEvent(k, obj);
    end
end
function CoreFireEvent(event, ...)
    --debug("event fired", event);
    local reg = eventRegistration[event];
    if(reg)then
        for i=1, #reg do
            local obj = reg[i]
            safecall(obj[event], obj, ...);
        end
    end
end

--在某个插件存在时调用，如果不存在，则等其加载
function CoreDependCall(addon, func, ...)
    local func = type(func) == "function" and func or _G[func];
    local func = type(func) == "function" and func or _G[func];
    if(IsAddOnLoaded(addon) and type(func)=="function") then
        func(...)
    else
        local params = {...}
        CoreOnEvent("ADDON_LOADED", function(event, name)
            if(name:lower() == addon:lower())then
                func(unpack(params));
                return true;
            end
        end)
    end
end

--离开战斗后调用的函数，不支持参数
local leaveCombatCalls = {}
function CoreLeaveCombatCall(key, message, func)
    local func = type(func) == "function" and func or _G[func];
    assert(type(func)=="function", "param #2 should be function or function name.")
    if not InCombatLockdown() then
        safecall(func, key)
    else
        if message then U1Message(message) end
        leaveCombatCalls[key] = func;
    end
end

---CoreOnEvent("VARIABLE_LOADED", func(event, ...) return "REMOVE!" end);
---callback return true to remove.
local eventFuncs = {}
local eventBucket, checkBucket = {}, false --eventBucket[event] = { {[1]=func, [2]=interval, [3]=timeLeft, [4]=needEndCall,}, ...}
core.frame:RegisterEvent("PLAYER_REGEN_ENABLED")
core.frame:SetScript("OnEvent", function(self, event, ...)
    if event=="PLAYER_REGEN_ENABLED" then
        for key, func in next, leaveCombatCalls do safecall(func, key) end
        wipe(leaveCombatCalls);
    end
    local eventTable = eventFuncs[event];
    if eventTable then
        local i = 1;
        while i<=#eventTable do
            local status, result = safecall(eventTable[i], event, ...);
            if status and result then
                tremove(eventTable, i);
            else
                i = i + 1;
            end
        end
    end
    local eventTable = eventBucket[event]
    if eventTable then
        for i=1,#eventTable do
            local v=eventTable[i]
            local timer = v[3]
            if timer == nil then
                safecall(v[1], event)
                v[3] = v[2] --重置timer为interval
                --v[4] = nil 这个不需要运行，必然是nil
            else
                v[4] = 1 --表示有未调用的，将在时间到后执行
            end
        end
    end
end)
CoreScheduleTimer(true, 0.2, function()
    if not checkBucket then return end
    for event, eventTable in pairs(eventBucket) do
        for i = 1, #eventTable do
            local v = eventTable[i]
            local timer = v[3];
            if timer then
                timer = timer - 0.1
                if timer<=0 then
                    if v[4] then
                        safecall(v[1], event);
                        v[4] = nil;
                        timer = v[2]; --继续保护
                    else
                        timer = nil
                    end
                end
                v[3] = timer
            end
        end
    end
end)

--第三个参数是为了利用模拟事件机制，在!!!163UI!!!以外调用时需添加
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

---注册一个最大调用间隔为interval的事件，暂时没有反注册机制
--而且，注意func只能接受一个参数event,不能接受其他的
function CoreOnEventBucket(event, interval, func)
    if(not core.frame:IsEventRegistered(event)) then
        core.frame:RegisterEvent(event);
    end
    local eventTable = eventBucket[event];
    if(eventTable==nil) then eventTable={} eventBucket[event]=eventTable end
    tinsert(eventTable, {func, interval, 0})
    checkBucket = next(eventBucket) and true
end

--- 自动判断是SetScript还是HookScript，如果提供keep参数，则会防止SetScript冲掉原来的Hook
function CoreHookScript(frame, scriptName, func, keep)
    if( frame:GetScript(scriptName) ) then
        frame:HookScript(scriptName, func);
    else
        frame:SetScript(scriptName, func);
    end
    if keep then
        hooksecurefunc(frame, "SetScript", function(self, name)
            if name==scriptName then
                self:HookScript(scriptName, func)
            end
        end)
    end
end

--[[------------------------------------------------------------
CoreUI
---------------------------------------------------------------]]
---页面框架增加鼠标提示
--@param frame 要增加支持的框架
--@param title 提示的标题, 可以省略, 颜色自动为白色
--@param content 提示的信息, 如果是字符串则直接显示, 或者是function(frame, tip)
local EnableTooltip_OnLeave
function CoreUIEnableTooltip(frame, title, content, update)
    frame:EnableMouse(true);
    frame.tooltipTitle=title;
    frame.tooltipText=content;
    if(type(content)=="function") then frame.tooltipText=" "; frame._tooltipText=content; end
    CoreHookScript(frame, "OnEnter",CoreUIShowTooltip);
    if update then frame.UpdateTooltip = CoreUIShowTooltip end

    EnableTooltip_OnLeave = EnableTooltip_OnLeave or function(self) GameTooltip:Hide(); end
    CoreHookScript(frame, "OnLeave", EnableTooltip_OnLeave);
end

function CoreUIAddNewbieTooltip(self, newbieText, r, g, b)
    if ( SHOW_NEWBIE_TIPS == "1" ) then
        self:AddLine(" ");
        self:AddLine(newbieText, r or 0, g or 0.82, b or 0, 1);
    end
end

--tooltipTitle,tooltipText,tooltipLines,tooltipAnchorPoint
function CoreUIShowTooltip(self, anchor, tip)
    if(self.tooltipTitle or self.tooltipText or self.tooltipLines) then
        tip = tip or GameTooltip
        tip:SetOwner(self, (anchor and anchor ~= true) or self.tooltipAnchorPoint);
        tip:ClearLines();
        if(self.tooltipLines)then
            if(type(self.tooltipLines)=="string")then
                self.tooltipLines = {strsplit("`", self.tooltipLines) }
            end
            if(type(self.tooltipLines)=="table" and #self.tooltipLines > 0)then
                tip:AddLine(self.tooltipLines[1],1,1,1)
                for i=2, #self.tooltipLines do
                    tip:AddLine(self.tooltipLines[i],nil,nil,nil,true); --最后一个参数是换行
                end
            end
        else
            if(self.tooltipTitle)then tip:AddLine(self.tooltipTitle,1,1,1); end
        end

        if(type(self._tooltipText)=="function") then
            self._tooltipText(self, tip);
        else
            tip:AddLine(self.tooltipText,nil,nil,nil,true); --最后一个参数是换行
        end

        tip:Show();
    end
end

--[[------------------------------------------------------------
InventoryLevel
---------------------------------------------------------------]]
local pattern = "^%+([0-9,]+) ([^ ]+)$"
local patternMore = "%+([0-9,]+) ([^ ]-)\124?r?$" --"附魔：+200 急速" "|cffffffff+150 急速|r"

local ATTRS = {
    [STAT_CRITICAL_STRIKE]  = 1, --CR_CRIT_MELEE,
    [STAT_HASTE]            = 2, --CR_HASTE_MELEE,
    [STAT_VERSATILITY]      = 3, --CR_VERSATILITY_DAMAGE_DONE,
    [STAT_MASTERY]          = 4, --CR_MASTERY,
    [ITEM_MOD_STRENGTH_SHORT] = 5, --LE_UNIT_STAT_STRENGTH
    [ITEM_MOD_AGILITY_SHORT] = 6, --LE_UNIT_STAT_AGILITY
    [ITEM_MOD_INTELLECT_SHORT] = 8, --LE_UNIT_STAT_INTELLECT
    [STAT_AVOIDANCE] = 11, --ITEM_MOD_CR_AVOIDANCE_SHORT 闪避
    [STAT_LIFESTEAL] = 12, --ITEM_MOD_CR_LIFESTEAL_SHORT 吸血
    [STAT_SPEED] = 13, --ITEM_MOD_CR_SPEED_SHORT 加速

    CONDUIT_TYPE = 9, --1-效能导灵器, 2-耐久导灵器, 3-灵巧导灵器, 橙装记忆和小宠物是其他
}
local CONDUIT_TYPES = {
    [CONDUIT_TYPE_POTENCY] = 1,
    [CONDUIT_TYPE_FINESSE] = 2,
    [CONDUIT_TYPE_ENDURANCE] = 3,
}

local cache, primary_stats = {}, {}
--如果提供tbl，则总是返回tbl，否则返回新的table或者数字1
--如果 includeGemEnchant, 那么当装备只有附魔和宝石时，对应属性是负值
function U1GetItemStats(link, slot, tbl, includeGemEnchant, classID, specID)
    local stats
    if tbl then wipe(tbl) stats = tbl end

    --缓存获取，装备搜索时includeGem是false, 不需要走缓存, 已经被db.ITEMS缓存了
    if slot == nil and includeGemEnchant and cache[link] and (not specID or primary_stats[specID]) then
        tbl = u1copy(cache[link], tbl)
        --移除非主属性
        if specID and primary_stats[specID] then
            for i=5, 8 do if i~=primary_stats[specID]+4 then tbl[i] = nil end end
        end
        return tbl
    end

    local tip, tipname = CoreGetTooltipForScan()
    tip:SetOwner(WorldFrame, "ANCHOR_NONE")
    if slot == nil then
        tip:SetHyperlink(link, classID, specID)
    else
        tip:SetInventoryItem(link, slot)
    end
    local line2 = _G[tipname .. "TextLeft2"]:GetText()
    if CONDUIT_TYPES[line2] then
        stats = stats or {}
        stats[ATTRS.CONDUIT_TYPE] = CONDUIT_TYPES[line2]
    end
    for i = 5, tip:NumLines(), 1 do
        local txt = _G[tipname .. "TextLeft"..i]:GetText()
        if txt then
            local _, _, value, attr = txt:find(pattern)
            if attr and ATTRS[attr] then
                local value = tonumber((value:gsub(",", "")))
                stats = stats or {}
                stats[ATTRS[attr]] = math.abs(stats[ATTRS[attr]] or 0) + value
                --通过文字颜色获取天赋主属性
                if specID and specID > 0 and ATTRS[attr] > 4 then
                    local r,g,b = _G[tipname .. "TextLeft"..i]:GetTextColor()
                    if r > 0.99 then
                        primary_stats[specID] = ATTRS[attr] - 4
                    end
                end
            elseif not attr and includeGemEnchant then
                txt = txt:gsub("，%+2%% (.*)$", "") --", +2%速度"
                _, _, value, attr = txt:find(patternMore)
                if attr and ATTRS[attr] then
                    local value = tonumber((value:gsub(",", "")))
                    stats = stats or {}
                    local old = stats[ATTRS[attr]] or 0
                    if old > 0 then stats[ATTRS[attr]] = old + value else stats[ATTRS[attr]] = old - value end
                end
            end
        end
    end
    if slot == nil and includeGemEnchant and stats then
        cache[link] = copy(stats, cache[link])
        if specID and primary_stats[specID] then
            for i=5, 8 do if i~=primary_stats[specID]+4 then stats[i] = nil end end
        end
    end
    return stats or 1
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