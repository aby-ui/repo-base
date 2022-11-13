local _, core = ...
local L = core.L
local floor,ceil,format,tostring=floor,ceil,format,tostring
local pairs,ipairs,next,wipe,assert,type,tinsert,select,tremove,GetTime,setmeta,rawg = pairs,ipairs,next,wipe,assert,type,tinsert,select,tremove,GetTime,setmetatable, rawget
local n2s_small,n2s_big,n2s_float,n2s_format,n2s_pad_cache={},{},{},{"%.1f","%.2f","%.3f","%.4f","%.5f",[0]="%d"},{"0","00","000","0000","00000"}
for i=0, 100 do n2s_small[i] = tostring(i) end
for i=0, 9 do for j=0, 9 do n2s_float[i+j/10] = format("%.1f", i+j/10) end end

_empty_table = {};
_temp_table = {};

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

--- table1 has all table2 keys and values are same
function tcovers(table1, table2)
    for k,v in pairs(table2) do
        if v ~= table1[k] then
            return false
        end
    end
    return true
end

--将一个字符串中的正则特殊字符换掉
function escape_pattern(str)
    return str:gsub("%%", "%%%%"):gsub("%-","%%-"):gsub("%+","%%+"):gsub("%.","%%."):gsub("%[", "%%["):gsub("%]", "%%]"):gsub("%(", "%%("):gsub("%)", "%%)");
end
--忽略大小写的gsub
function nocase(s)
    return string.gsub(escape_pattern(s), "%a", function (c)
        return string.format("[%s%s]", string.lower(c),
            string.upper(c))
    end)
end
function uncolor(s)
    return s and s:gsub("|c%x%x%x%x%x%x%x%x(.-)|r", "%1") or nil
end
local function ExtractColorValueFromHex(str, index)
	return tonumber(str:sub(index, index + 1), 16) / 255;
end
function hex2rgba(hexColor)
    if #hexColor == 8 then
        local a, r, g, b = ExtractColorValueFromHex(hexColor, 1), ExtractColorValueFromHex(hexColor, 3), ExtractColorValueFromHex(hexColor, 5), ExtractColorValueFromHex(hexColor, 7);
        return r, g, b, a;
    else
        error("format should be AARRGGBB")
    end
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

---固定位数,相当于%02d里的02,基本不需要调用,通过n2s即可
function n2s_pad(str, length)
    length = length - #str
    if length > 0 then return n2s_pad_cache[length]..str else return str end
end
local n2s_02d = {} for i=0, 100 do n2s_02d[i]=format("%02d", i) end
---快速转换数字到字符串的
function n2s(n, pad, useceil)
    if n >= 0 then
        if n <= 100 then
            if pad then
                if pad==2 then return n2s_02d[n] end
                local str = n2s_small[n] or n2s_small[(useceil and ceil or floor)(n)]
                pad = pad - #str if pad > 0 then return n2s_pad_cache[pad]..str else return str end
            else
                return n2s_small[n] or n2s_small[(useceil and ceil or floor)(n)]
            end
        elseif n <=10000 then
            local n2s_res = n2s_big[n]
            if not n2s_res then
                n = (useceil and ceil or floor)(n)
                n2s_res = n2s_big[n]
                if not n2s_res then
                    n2s_res = format("%d", n)
                    n2s_big[(useceil and ceil or floor)(n)] = n2s_res
                end
            end
            if pad then
                pad = pad - #n2s_res if pad > 0 then return n2s_pad_cache[pad]..n2s_res else return n2s_res end
            else
                return n2s_res
            end
        else
            return format("%d", n)
        end
    else
        return ""..n --overflow
    end
end

---小数转换，与n2s区别是为了少一次判断，另外只节省1/4的效率, 100以下的一位小数会很快
function f2s(n, radius)
    radius = radius or 0
    if n>=0 and n<=100 and radius<=1 then
        if radius == 0 then
            return n2s_small[floor(n+0.5)]
        else
            local n2s_res = n2s_float[floor(n*10+.5)/10]
            if not n2s_res then
                n2s_res = format("%.1f", n)
                n2s_float[n] = n2s_res
            end
            return n2s_res
        end
    else
        return format(n2s_format[radius] or n2s_format[0], n)
    end
end

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

local petBattleHideFrames = {}
CoreOnEvent("PET_BATTLE_OPENING_START", function()
    for frame, _ in pairs(petBattleHideFrames) do
        frame._previous_state = frame:IsShown()
        if not issecurevariable(frame, "Show") and not frame._163show then
            frame._163show = frame.Show
            frame.Show = noop
        end
        frame:Hide()
    end
end)

CoreOnEvent("PET_BATTLE_CLOSE", function()
    for frame, _ in pairs(petBattleHideFrames) do
        if frame._163show then
            frame.Show = frame._163show
            frame._163show = nil
        end
        if frame._previous_state then
            frame:Show()
            frame._previous_state = nil
        end
    end
end)

function CoreHideOnPetBattle(frame)
    if not frame or not frame.Show then return end
    petBattleHideFrames[frame] = true
end

---转换为浏览器地址
function EncodeURL(obj)
    local currentIndex = 1;
    local charArray = {}
    while currentIndex <= #obj do
        local char = string.byte(obj, currentIndex);
        charArray[currentIndex] = char
        currentIndex = currentIndex + 1
    end
    local converchar = "";
    for _, char in ipairs(charArray) do
        converchar = converchar..string.format("%%%X", char)
    end
    return converchar;
end

--不需要恢复的非安全Hook
function CoreRawHook(obj, name, func, isscript)
    if type(obj) == "string" then name, func, isscript, obj = obj, name, func, _G end
    if DEBUG_MODE and not isscript and name:find("^On") then print(L["忘记设置isscript了？"], name) end
    if isscript then
        local origin = obj:GetScript(name)
        if not origin then
            obj:SetScript(name, func)
        else
            obj:SetScript(name, function(...) origin(...) return func(...) end)
        end
    else
        local origin = obj[name]
        if not origin then
            obj[name] = func
        else
            obj[name] = function(...) local a1,a2,a3,a4,a5,a6,a7,a8,a9 = origin(...) func(...) return a1,a2,a3,a4,a5,a6,a7,a8,a9 end
        end
    end
end
CoreGlobalHooks = {}
--注意，如果在Cfg里执行togglehook那么会导致cpu占用被算到!!!163UI!!!上
--可以重复hook和togglehook, self是一个用来保存hook指针的对象
--当需要把一个操作屏蔽时, disable里调用hook(nil, name, noop);
--然后enable里调用unhook(nil, name), 保证重复hook不会丢失origin
--存在store._copies[name]说明unhook了, 可以rehook
function hook(store, name, func)
    assert(type(_G[name])=="function", "Bad arg1, string function name expected")
    assert(type(func)=="function", "Bad arg2, function expected")

    store = store or CoreGlobalHooks;

    store._origins = store._origins or {}
    store._hooks = store._hooks or {}
    store._copies = store._copies or {} --hook的备份

    if not store._origins[name] then
        store._origins[name] = _G[name]
        _G[name] = function(...) return store._hooks[name](...) end
    end

    store._hooks[name] = func
end
function unhook(store, name)
    store = store or CoreGlobalHooks;
    if not store._origins or not store._origins[name] then return end --尚未hook过
    if store._copies and store._copies[name] then return end --不能重复的unhook, 会导致hook丢失
    store._copies[name] = store._hooks[name];
    store._hooks[name] = store._origins[name];
end
function rehook(store, name, func)
    store = store or CoreGlobalHooks;
    if not store._origins or not store._origins[name] then
        --尚未hook过
        if(func)then hook(store, name, func) end
        return
    end
    if not store._copies or not store._copies[name] then return end --尚未unhook过
    store._hooks[name] = store._copies[name]
    store._copies[name] = nil;
end
function togglehook(store, name, func, tohook)
    if tohook then rehook(store, name, func) else unhook(store, name) end
end
---secure和script共用的hook方法
--@param hooktype hooksecurefunc/HookScript
--@param store 用来保存hook的信息以便unhook
--@param object hooksecure(object) or object:HookScript里的object
--@param name 全局函数名或ScriptHandler名
--@param func 要hook的函数
--@param tohook 是否hook
function toggleposthook(hooktype, store, object, name, func, tohook)
    assert(type(store)=="table", "para #1 store must be a table.")
    if object == nil then object = "NIL" end
    store[object] = store[object] or {}
    if not store[object][name] then
        --只在第一次进行具体的hook操作
        store[object][name] = {func, tohook }
        --所有的都是
        local func = function(...) if(store[object][name][2]) then store[object][name][1](...) end end
        if hooktype =="hooksecurefunc" then
            if object == "NIL" then
                hooksecurefunc(name, func)
            else
                hooksecurefunc(object, name, func)
            end
        else
            object:HookScript(name, func)
        end
    else
        store[object][name][1] = func
        store[object][name][2] = tohook
    end
end
function togglesecurehook(store, object, name, func, tohook) return toggleposthook("hooksecurefunc", store, object, name, func, tohook) end
function togglescripthook(store, object, name, func, tohook) return toggleposthook("HookScript", store, object, name, func, tohook) end

function CoreCall(funcName, ...)
    local func = _G[funcName]
    return func and func(...);
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

local function createEnumAndHookClosure(creationFuncHook)
    local flag = "_aby_hooked"
    return function (pool, includeInactive)
        RunNextFrame(function()
            for one in pool:EnumerateActive() do
                if not one[flag] then
                    creationFuncHook(one, pool.frameType, pool.frameTemplate)
                    one[flag] = true
                end
            end
            if includeInactive ~= "includeInactive" then return end
            for _, one in pool:EnumerateInactive() do
                if not one[flag] then
                    creationFuncHook(one, pool.frameType, pool.frameTemplate)
                    one[flag] = true
                end
            end
        end)
    end
end
--- @param creationFuncHook function(obj, frameType, template) 新创建对象时会调用此方法
function CoreUIHookPoolCollection(poolCollection, creationFuncHook)
    local enumAndHook = createEnumAndHookClosure(creationFuncHook)
    for poolKey, pool in pairs(poolCollection.pools) do
        hooksecurefunc(pool, "creationFunc", enumAndHook)
        enumAndHook(pool, "includeInactive")
    end
    hooksecurefunc(poolCollection, "CreatePool", function(self, frameType, parent, template, resetterFunc, forbidden, specialization)
        local pool = self:GetPool(template, specialization)
        if pool then
            hooksecurefunc(pool, "creationFunc", enumAndHook)
        end
    end)
end

function CoreUIHookPool(pool, creationFuncHook)
    local enumAndHook = createEnumAndHookClosure(creationFuncHook)
    hooksecurefunc(pool, "creationFunc", enumAndHook)
    enumAndHook(pool, "includeInactive")
end

--[[------------------------------------------------------------
 TimeCache
---------------------------------------------------------------]]
do
    local tcache = {}
    local tcache_expires = {}
    function CoreCacheSet(key, value, duration)
        tcache[key] = value
        if value == nil then
            tcache_expires[key] = nil
        else
            tcache_expires[key] = GetTime() + duration
        end
    end
    function CoreCacheGet(key)
        local et = tcache_expires[key]
        if et then
            if type(et) == "table" then error("Cached value is a list") end
            if et >= GetTime() then
                return tcache[key]
            else
                tcache[key] = nil
                tcache_expires[key] = nil
            end
        end
    end
    function CoreCacheListSet(key, value, duration)
        tcache[key] = tcache[key] or {}
        tcache[key][#tcache[key]+1] = value
        tcache_expires[key] = tcache_expires[key] or {}
        tcache_expires[key][#tcache_expires[key]+1] = GetTime() + duration
    end
    function CoreCacheListRemove(key, index)
        local et = tcache_expires[key]
        if et then
            if type(et) ~= "table" then error("Cached value is not a list") end
            table.remove(et, index)
            table.remove(tcache[key], index)
        end
    end
    function CoreCacheListGet(key)
        local et = tcache_expires[key]
        if et then
            if type(et) ~= "table" then error("Cached value is not a list") end
            local i = 1
            while( i <= #et ) do
                if et[i] < GetTime() then
                    table.remove(et, i)
                    table.remove(tcache[key], i)
                else
                    i = i + 1
                end
            end
        end
        return tcache[key]
    end
    CoreScheduleTimer(true, 10, function()
        for k,v in pairs(tcache_expires) do
            if type(v) == "table" then
                CoreCacheListGet(k)
            else
                CoreCacheGet(k)
            end
        end
    end)
end

--[[
hooksecurefunc(Minimap, "SetBlipTexture", function(self, ...) self._blipTexture = ... end)
function CoreIsTextureExists(name)
    local old = Minimap._blipTexture or "interface\\minimap\\objecticons"
    local status = pcall(Minimap.SetBlipTexture, Minimap, name)
    Minimap:SetBlipTexture(old)
    return status
end
--]]

core.frame.tex = core.frame:CreateTexture()
function CoreIsTextureExists(picAddOn, name)
    return false --select(5, GetAddOnInfo(picAddOn))~="MISSING" and U1IsAddonRegistered(name) and not U1GetAddonInfo(name).nopic;
end

function CoreEncodeHTML(s, keepColor)
    if not keepColor then
        s = s:gsub("|c%x%x%x%x%x%x%x%x%[(.-)%]|r", "%1"):gsub("|c%x%x%x%x%x%x%x%x(.-)|r", "%1")
    end
    s = s:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
    return s;
end

function CoreIsFrameIntersects(frame1, frame2)
    --左下角为0, bottom > top 不向交
    if frame1:GetLeft() == nil or frame1:GetTop() == nil then return false end
    if frame2:GetLeft() == nil or frame2:GetTop() == nil then return false end

    return not (
        frame1:GetLeft() > frame2:GetRight() or
        frame1:GetRight() < frame2:GetLeft() or
        frame1:GetTop() < frame2:GetBottom() or
        frame1:GetBottom() > frame2:GetTop()
    );
end

--[[------------------------------------------------------------
protection area
---------------------------------------------------------------]]
U1STAFF={["心耀-冰风岗"]="爱不易开发者",
    ["大狸花猫-冰风岗"]="爱不易开发者",
    ["篠崎-影之哀伤"]="Cell插件开发者", ["秋静葉-影之哀伤"]="Cell插件开发者", ["蜜柑-影之哀伤"]="Cell插件开发者", ["凛香-影之哀伤"]="Cell插件开发者",
    ["心钥-凤凰之神"]="爱不易开发者",
    ["三月十二-冰风岗"]="爱不易开发者",
    ["白白的大白兔-艾露恩"]="爱不易图标制造者",
    ["十三强盗-艾露恩"]="爱不易图标制造者",
    ["Zod-冰风岗"]="爱不易开发者的会长",
    ["利爪-冰风岗"]="爱不易小狼狗",
    ["尬疗者-冰风岗"]="熊猫人爱好者",
    ["小倍倍猪-冰风岗"]="爱不易老板娘",
    ["猪天天乖-冰风岗"]="爱不易赚钱养家的",
    ["咬住彼岸幻象-冰风岗"]="爱不易御用猎人",
    --["咬住不撒嘴-冰风岗"]="爱不易御用瞎子",
    ["Minevaô-冰风岗"]="爱不易打杂的",
    ["Funnel-冰风岗"]="爱不易幽灵虎饲养员",
    ["Foreigners-冰风岗"]="爱不易的小吉安娜",
    ["水之记忆-冰风岗"]="爱不易虚空大师姐",
    ["灼灼星光-冰风岗"]="爱不易咕咕大师姐",
    ["地狱王子归来-冰风岗"]="爱不易凡图斯制造者",
    ["无敌幸运牛-冰风岗"]="爱不易大股东",
    ["冰镇小龙虾-冰风岗"]="爱不易大股东",
    ["糖喵不是猫-冰风岗"]="爱不易大股东",
    ["厄莫莫-冰风岗"]="爱不易劳模",
    ["波波祖先-冰风岗"]="爱不易劳模",
    ["微笑的科科呀-冰风岗"]="爱不易大股东",
    ["我从梦中醒来-冰风岗"]="爱不易指导员",
    ["爱笑的贝贝丶-冰风岗"]="爱不易大股东",
    ["莜面鱼鱼-冰风岗"]="爱不易大股东",
    ["蔚蓝的珊瑚海-冰风岗"]="爱不易大股东",
    ["入海斩蛟龙-冰风岗"]="爱不易大股东",
    ["Morganr-冰风岗"]="爱不易大股东",
    ["非常小牛-黑暗魅影"]="爱不易单体巨兽",
    ["做家务才能玩-布兰卡德"]="爱不易世界第一猫德信就信不信拉倒",
    ["做家务才能玩-冰风岗"]="爱不易世界第一猫德信就信不信拉倒",
    ["野牛大改造-冰风岗"]="爱不易凶猛大白熊",
    ["Caltria-冰风岗"]="爱不易董事·纸片人老婆的现任·薛定谔的欧皇·咕哒子",
    ["Pardofelis-冰风岗"]="爱不易董事·纸片人老婆的现任·薛定谔的欧皇·咕哒子",
    ["Aponia-冰风岗"]="爱不易董事·纸片人老婆的现任·薛定谔的欧皇·咕哒子",
    ["糖门欧洲人-冰风岗"]="爱不易龙虾供应商",
    ["部落炮艇火炮-凤凰之神"]="爱不易大股东",
    ["明天就减肥-冰风岗"]="爱不易大股东",
    ["月色丶秋风-冰风岗"]="爱不易大股东",
    ["Pigeonmonk-冰风岗"]="爱不易大股东",
    ["Stayreal-冰风岗"]="爱不易大股东",
    ["Halcyon-冰风岗"]="爱不易大股东",
    ["亻空白-冰风岗"]="爱不易大股东",
    ["波波解我衣-冰风岗"]="爱不易大股东",
    ["魔法刨冰机-冰风岗"]="爱不易工具人",
    ["我叫法師-冰风岗"]="爱不易大股东",
    ["执业医师-冰风岗"]="爱不易大股东",
    ["红雷无限连-冰风岗"]="爱不易大股东",
    ["小聪明大条-冰风岗"]="爱不易大股东",
    ["的鵝德-冰风岗"]="爱不易大股东",

    ["Insomniazz-影之哀伤"]="爱不易小蟊贼",
    ["小短腿柯柯-白银之手"]="爱不易妇女之友",
    ["菜逼检验师-冰风岗"]="爱不易妇女之友",

    ["闪电滚滚-冰风岗"]="提瑞斯法议会会长",
    ["闪电糖糖-冰风岗"]="提瑞斯法议会会长",
    ["点点薇蓝-死亡之翼"]="爱不易大祭司",
    ["水凝非冰-死亡之翼"]="爱不易小甜心",
    ["画圈灬诅咒你-冰风岗"]="爱不易大股东",

    ["我开嗜血了-冰风岗"]="爱不易全能王",
    ["菜逼分割线-冰风岗"]="爱不易妇女之友",
    ["旋转华丽-冰风岗"]="爱不易神级辅助",
    ["Vitamilk-冰风岗"]="爱不易首席戒律",
    ["巅峰传说-冰风岗"]="爱不易王牌车头",
    ["白发黑魔女-冰风岗"]="爱不易王牌车头",
    ["欧丶皇丶族-冰风岗"]="爱不易首席替补",
    --["糖门不缺德-冰风岗"]="爱不易龙虾供应商", --"爱不易钟离先生的现任",
    --["无尘大师-冰风岗"]="爱不易熊猫人领导",
    --["依然贝斯-冰风岗"]="爱不易欧皇贝斯",
    --["绯流琥-冰风岗"]="爱不易大股东",
    --["恩然-冰风岗"] = "爱不易大股东",
    --["浮云丶天际-冰风岗"]="爱不易大学僧",
    --["Supercell-冰风岗"]="爱不易首席暗牧",
    ["欧灬若拉-冰风岗"]="爱不易部落老兵典范",
    ["丶晞-死亡之翼"]="爱不易永远的晞女神",
    --["丶煙-冰风岗"]="爱不易永远的煙战神",
    ["Sylviaxxlu-燃烧之刃"]="爱不易大股东",
    ["流刃偌火丶-燃烧之刃"]="爱不易大股东",
    ["萬惡之靈-凤凰之神"]="爱不易的星光小尾巴",
    ["吾命即是天道-凤凰之神"]="爱不易的星光小尾巴",
    ["罪恶小蚊子-凤凰之神"]="爱不易最强小蚊子",
    ["昊天九剑-凤凰之神"]="爱不易一哥脑残粉",
    ["欧剃大魔王-死亡之翼"]="爱不易黑峰第一智障",
    ["卡姆九十六-布兰卡德"]="爱不易零零后天才技师",
}

function U1AddDonatorTitle(self, partOrFullName)
    if self._ChangingByAbyUI then return end
    if partOrFullName then
        if not partOrFullName:find("%-") then
            partOrFullName = partOrFullName .. "-" .. GetRealmName()
        end
        local staff = U1STAFF[partOrFullName]
        if staff then
            self:AddLine(staff, 1, 0, 1)
            if not self.fadeOut then self._ChangingByAbyUI = 1 self:Show() self._ChangingByAbyUI = nil end
        else
            local donate = U1Donators and U1Donators.players[partOrFullName]
            if donate then
                self:AddLine("爱不易" .. (donate > 0 and "" or "") .. "捐助者", 1, 0, 1)
                if not self.fadeOut then self._ChangingByAbyUI = 1 self:Show() self._ChangingByAbyUI = nil end
            end
        end
    end
end

RunOnNextFrame(function()
    CoreRegisterEvent("INIT_COMPLETED", { INIT_COMPLETED = function()
        CoreScheduleTimer(false, 1, function()
            GameTooltip:HookScript("OnTooltipSetUnit", function(self)
                local _, unit = self:GetUnit();
                if not unit or not UnitIsPlayer(unit) then return end --or not self:IsVisible()
                U1AddDonatorTitle(self, U1UnitFullName(unit))
            end)
            hooksecurefunc(GameTooltip, "Show", function(self)
                if CommunitiesFrameScrollChild and self:GetOwner() and self:GetOwner().GetMemberInfo and self:GetOwner():GetParent() == CommunitiesFrameScrollChild then
                    local memberInfo = self:GetOwner():GetMemberInfo()
                    if memberInfo then
                        U1AddDonatorTitle(self, memberInfo.name)
                    end
                end
            end)
        end)
    end })
end)

local debugFrame = CreateFrame("Frame")
local fpsStartTime, fpsCount, fpsTotalCount, fpsTotalTime = nil, 0, 0, 0 --战斗帧数统计
debugFrame:SetScript("OnUpdate", function(self)
    if fpsStartTime then fpsCount = fpsCount + 1 end
end)

debugFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
debugFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
debugFrame:SetScript("OnEvent", function(self, event, ...)
    if event=="PLAYER_REGEN_ENABLED" then
        if fpsStartTime and DEBUG_MODE then
            local time = GetTime() - fpsStartTime;
            local fps = fpsCount / time
            fpsTotalCount = fpsTotalCount + fpsCount
            fpsTotalTime = fpsTotalTime + time
            fpsStartTime = nil
            if time>10 then
                U1Message(format("本次战斗帧数: %.1f，平均: %.1f", fpsCount/time, fpsTotalCount/fpsTotalTime))
            end
            fpsCount = 0
        end
    elseif event=="PLAYER_REGEN_DISABLED" then
        fpsStartTime = GetTime()
    end
end)

--将一个数字保存进cvar里.只支持整数
function CoreSetParaParam(cvar, data, start, len)
    local c = GetCVar(cvar)
    local p = c:find("%.")
    local frac = strsub(c, p + 1);
    --如果前面位数不够则补零，比如从第3位开始，但是只有1位，则补一个0
    if frac:len() < start - 1 then
        frac = frac..strrep("0", start - 1 - frac:len());
    end
    frac = strsub(frac, 1, start-1)..format("%0"..len.."d", data)..strsub(frac, start + len)
    SetCVar(cvar, c:sub(1, p)..frac);
end
function CoreGetParaParam(cvar, start, len)
    local c = GetCVar(cvar)
    local p = c:find("%.")
    if not p then return 0 end
    local frac = strsub(c, p + 1);
    --如果前面位数不够则补零，比如从第3位开始，但是只有1位，则补一个0
    if frac:len() < start + len - 1 then
        frac = frac..strrep("0", start + len - 1 - frac:len());
    end
    return tonumber(strsub(frac, start, start + len - 1));
end

--- 此方法是为了防止战斗中初次调用时，会无法设置
function CoreUIGetUIPanelWindowInfo(frame, name)
	if ( not frame:GetAttribute("UIPanelLayout-defined") ) then
	    local info = UIPanelWindows[frame:GetName()];
	    if ( not info ) then
			return;
	    end
		frame:SetAttribute("UIPanelLayout-defined", true);
	    for name,value in pairs(info) do
			frame:SetAttribute("UIPanelLayout-"..name, value);
		end
	end
	return frame:GetAttribute("UIPanelLayout-"..name);
end

------------ from RunSecond --------------
--防止战斗中初次调用时，会无法设置
if CoreUIGetUIPanelWindowInfo then
    for k, v in pairs(UIPanelWindows) do
        if _G[k] then CoreUIGetUIPanelWindowInfo(_G[k], "area"); end
    end
end


-- 避免误操作关闭taint的插件
if(StaticPopupDialogs) then
    StaticPopupDialogs["ADDON_ACTION_FORBIDDEN"].OnAccept = function() end
end

hooksecurefunc("AddonTooltip_Update", function(owner)
	local name, title, notes, _, _, security = GetAddOnInfo(owner:GetID());
	if title then AddonTooltip:AddLine(L["目录"] .. ": " .. name) end
end)

--[[------------------------------------------------------------
Addon Support
---------------------------------------------------------------]]
--用来检查数据的版本
function U1CheckVersionedData(data, version)
    if data and data._build and data._version then
        local c1, c2 = strsplit(".", (GetBuildInfo()))
        local d1, d2 = strsplit(".", data._build)
        if c1==d1 and c2==d2 and data._version==version then
            return true
        end
    end
end

function U1SaveVersionedData(data, version)
    data._build = GetBuildInfo()
    data._version = version
end

function U1UnitFullName(unit)
    local name, realm = UnitName(unit)
    return name and name .. "-" .. (realm and realm~="" and realm or GetRealmName())
end

--[[------------------------------------------------------------
TESTING
---------------------------------------------------------------]]
--[[
hook(nil, "ChatFrame_MessageEventHandler", function(this, event, ...)
    if ( strsub(event, 1, 8) == "CHAT_MSG" and (event=="CHAT_MSG_CHANNEL_JOIN" or event=="CHAT_MSG_CHANNEL_LEAVE") and select(9, ...)=="大脚世界频道" ) then return true end --屏蔽大脚的显示提示
    CoreGlobalHooks._origins["ChatFrame_MessageEventHandler"](this, event, ...);
end)
--]]

--[[
CoreOnEvent("PLAYER_ENTERING_WORLD", function()
    local f = WW:Frame("TEST", UIParent):Size(100,100):TOP():CreateTexture():SetColorTexture(1,1,1,0.5):ALL():up():un();
    CoreUIMakeMovable(f);
    U1FramePosReg("TEST");
    U1FramePosRestore("TEST");
end)
]]