local _, core = ...
local L = core.L
local floor,ceil,format,tostring=floor,ceil,format,tostring
local pairs,ipairs,next,wipe,assert,type,tinsert,select,tremove,GetTime,setmeta,rawg = pairs,ipairs,next,wipe,assert,type,tinsert,select,tremove,GetTime,setmetatable, rawget
local n2s_small,n2s_big,n2s_float,n2s_format,n2s_pad_cache={},{},{},{"%.1f","%.2f","%.3f","%.4f","%.5f",[0]="%d"},{"0","00","000","0000","00000"}
for i=0, 100 do n2s_small[i] = tostring(i) end
for i=0, 9 do for j=0, 9 do n2s_float[i+j/10] = format("%.1f", i+j/10) end end

function noop() end
function pdebug(...) print("params", ...); print(debugstack(2)) end

_empty_table = {};
_temp_table = {};

---复制数据,如果不提供toTable则新建一个
function copy(fromTable, toTable)
    toTable = toTable or {}
    if not fromTable then return end
    for k,v in pairs(fromTable) do
        toTable[k] = v;
    end
    return toTable;
end

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

function CoreBuildLocale()
    return setmeta({},{
        __index = function(self, key) return key end,
        __call = function(self, key) return rawg(self, key) or key  end
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

local n2s,safecall,copy,tinsertdata,tremovedata,f2s = n2s,safecall,copy,tinsertdata,tremovedata,f2s
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
            copy(runOnNextFrame[i+runOnNextCount], runOnNextFrame[i]);
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
    eventRegistration[event] = {};
end
function CoreRegisterEvent(event, obj)
    local reg = eventRegistration[event];
    assert(reg, "No event '"..event.."' is defined.");
    tinsert(reg, (WW and WW.un) and WW:un(obj) or obj._F or obj);
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

---直接调用Blizzard的dump
function dump(...)
    if not IsAddOnLoaded("Blizzard_DebugTools") then LoadAddOn("Blizzard_DebugTools") end
    DevTools_Dump(...);
end

function dumpt(tbl, curr_depth, expect_depth)
    if(type(tbl)~="table") then return print(tostring(tbl)) end
    curr_depth = curr_depth or 1
    expect_depth = max(expect_depth or 1, curr_depth)
    if(expect_depth == curr_depth) then print(tostring(tbl)) end
    for k,v in pairs(tbl) do
        print(strrep(" │", expect_depth - curr_depth) .. " ├" .. tostring(k) .. " = " .. tostring(v))
        if curr_depth > 1 and type(v)=="table" then dumpt(v, curr_depth -1, expect_depth) end
    end
end
SlashCmdList["DUMPT"] = function(cmd)
    local var, depth = cmd:match("^(.*)[ ]+([0-9]+)$")
    dumpt(loadstring("return "..(var or cmd))(), tonumber(depth or 1))
end
SLASH_DUMPT1 = "/dumpt"

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

function GetClassName(engClass)
    return _G["U1"..engClass];
end
function GetClassTalentName(engClass, tab)
    return _G["U1TALENT_"..engClass..tab];
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

--[[------------------------------------------------------------
protection area
---------------------------------------------------------------]]

U1STAFF={["Time-奥杜尔"]=1,["天灾軍团-奥杜尔"]=1,["Timeà-霜之哀伤"]=1,["心耀-冰风岗"]=1,
    ["Majere-冰风岗"]="爱不易开发者的会长",
    ["乄阿蛮乄-冰风岗"]="Banshee元素领主",
    ["北风丶烈-冰风岗"]="Banshee部落老兵楷模",
    ["橙光大师-冰风岗"]="Banshee熊猫人领导",
    ["绯流琥-冰风岗"]="Banshee黑骑士",
    ["欧灬若拉-冰风岗"]="Banshee部落老兵典范",
    ["丶咕哒子-冰风岗"]="Banshee十八岁的咕哒子",
    ["水之记忆-冰风岗"]="Banshee小仙女",
    ["小倍倍猪-冰风岗"]="Banshee小仙女" }
RunOnNextFrame(function()
    CoreRegisterEvent("INIT_COMPLETED", { INIT_COMPLETED = function()
        CoreScheduleTimer(false, 1, function()
            GameTooltip:HookScript("OnTooltipSetUnit", function(self)
                local _, unit = self:GetUnit();
                if not unit or not UnitIsPlayer(unit) then return end --or not self:IsVisible()
                local fullName = U1UnitFullName(unit)
                if fullName then
                    local staff = U1STAFF[fullName]
                    if staff then
                        self:AddLine(staff == 1 and "爱不易开发者" or staff, 1, 0, 1)
                        if not self.fadeOut then self:Show() end
                    else
                        local donate = U1Donators and U1Donators.players[fullName]
                        if donate then
                            self:AddLine("爱不易" .. (donate > 0 and "" or "") .. "捐助者", 1, 0, 1)
                            if not self.fadeOut then self:Show() end
                        end
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

---Raid中屏蔽小队框架的事件
local unregisteredByUs
local function unregisterPartyMemberFrames()
    if not PartyMemberFrame1:IsEventRegistered("UNIT_AURA") then return end
    if GetNumSubgroupMembers()>0 and not PartyMemberFrame1:IsShown() then
        unregisteredByUs = true
        for i=1, MAX_PARTY_MEMBERS, 1 do
            local frame = _G["PartyMemberFrame"..i]
            frame:UnregisterAllEvents()
            frame:RegisterEvent("GROUP_ROSTER_UPDATE");
            frame:RegisterEvent("PLAYER_ENTERING_WORLD");
        end
    end
end

local function registerPartyMemberFrames()
    if not unregisteredByUs or PartyMemberFrame1:IsEventRegistered("UNIT_AURA") then return end
    unregisteredByUs = nil
    for i=1, MAX_PARTY_MEMBERS, 1 do
        local frame = _G["PartyMemberFrame"..i]
        frame:RegisterEvent("PLAYER_ENTERING_WORLD");
        frame:RegisterEvent("GROUP_ROSTER_UPDATE");
        frame:RegisterEvent("UPDATE_ACTIVE_BATTLEFIELD");
        frame:RegisterEvent("PARTY_LEADER_CHANGED");
        frame:RegisterEvent("PARTY_LOOT_METHOD_CHANGED");
        frame:RegisterEvent("MUTELIST_UPDATE");
        frame:RegisterEvent("IGNORELIST_UPDATE");
        frame:RegisterEvent("UNIT_FACTION");
        frame:RegisterEvent("VARIABLES_LOADED");
        frame:RegisterEvent("READY_CHECK");
        frame:RegisterEvent("READY_CHECK_CONFIRM");
        frame:RegisterEvent("READY_CHECK_FINISHED");
        frame:RegisterEvent("UNIT_ENTERED_VEHICLE");
        frame:RegisterEvent("UNIT_EXITED_VEHICLE");
        frame:RegisterEvent("UNIT_CONNECTION");
        frame:RegisterEvent("PARTY_MEMBER_ENABLE");
        frame:RegisterEvent("PARTY_MEMBER_DISABLE");
        frame:RegisterEvent("UNIT_PHASE");
        frame:RegisterEvent("UNIT_OTHER_PARTY_CHANGED");
    end
end
debugFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
debugFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
debugFrame:SetScript("OnEvent", function(self, event, ...)
    if event=="PLAYER_REGEN_ENABLED" then
        registerPartyMemberFrames()
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
        unregisterPartyMemberFrames()
        fpsStartTime = GetTime()
    end
end)

--- 屏蔽鼠标提示不停刷新的点
do
    local function setUpdateTooltip(self)
        if(not self.UpdateTooltip) then
            self.UpdateTooltip = self:GetScript("OnUpdate");
            self:SetScript("OnUpdate", nil)
        end
    end
    local function changeTooltipUpdateHook(self)
        local owner = self:GetOwner()
        if owner then
            setUpdateTooltip(owner)
        end
    end
    hooksecurefunc("LootItem_OnEnter", setUpdateTooltip)
    hooksecurefunc("InboxFrameItem_OnEnter", setUpdateTooltip)
    --CoreDependCall("Blizzard_TradeSkillUI", function() hooksecurefunc("TradeSkillItem_OnEnter", setUpdateTooltip) end)
    CoreDependCall("Blizzard_InspectUI", function() hooksecurefunc("InspectPaperDollItemSlotButton_OnEnter", setUpdateTooltip) end)
    CoreDependCall("Blizzard_AuctionUI", function() hooksecurefunc("AuctionFrameItem_OnEnter", setUpdateTooltip) end)
    hooksecurefunc(GameTooltip, "SetLootRollItem", changeTooltipUpdateHook)
    --hooksecurefunc(GameTooltip, "SetMissingLootItem", changeTooltipUpdateHook)
    hooksecurefunc(GameTooltip, "SetTradeTargetItem", changeTooltipUpdateHook)
    hooksecurefunc(GameTooltip, "SetTradePlayerItem", changeTooltipUpdateHook)
    hooksecurefunc(GameTooltip, "SetSendMailItem", changeTooltipUpdateHook)
    --MiniMapBattlefieldFrame:HookScript("OnEnter", function(self) self:SetScript("OnUpdate", nil) self.UpdateTooltip = MiniMapBattlefieldFrame_OnUpdate end)
    CoreDependCall("Blizzard_TimeManager", function()
        TimeManagerClockButton:HookScript("OnEnter", TimeManagerClockButton_UpdateTooltip);
        TimeManagerClockButton.UpdateTooltip = TimeManagerClockButton_UpdateTooltip;
        TimeManagerClockButton_OnUpdateWithTooltip = TimeManagerClockButton_OnUpdate;
    end)
    hooksecurefunc("TempEnchantButton_OnEnter", function(self)
        self.UpdateTooltip = self.UpdateTooltip or TempEnchantButton_OnEnter
    end)
    TempEnchant1:SetScript("OnUpdate", nil)
    TempEnchant2:SetScript("OnUpdate", nil)
    TempEnchant3:SetScript("OnUpdate", nil)
end

--[==[-替换WorldFrame_OnUpdate，其中大量运算只是为了UIParent隐藏时, level>=60 是为了其中的Tutorial
CoreOnEvent("PLAYER_LOGIN", function()
    if UnitLevel("player")>=60 then
        local timeLeft = 0
        local function onupdate(self, elapsed)
            timeLeft = timeLeft - elapsed
            if ( timeLeft <= 0 ) then
                timeLeft = 0.5;
                if ( FramerateText:IsShown() ) then
                    local framerate = GetFramerate();
                    if framerate >= 100 then
                        framerate = n2s(floor(framerate+0.5))
                    else
                        framerate = f2s(framerate, 1)
                    end
                    FramerateText:SetText(framerate);
                    MapFramerateText:SetText(framerate);
                end
            end
        end
        --hooksecurefunc(UIParent, "Show", function() WorldFrame:SetScript("OnUpdate", onupdate) end)
        --hooksecurefunc(UIParent, "Hide", function() WorldFrame:SetScript("OnUpdate", WorldFrame_OnUpdate) end) --TODO: 可能会导致各种污染
        WorldFrame:SetScript("OnUpdate", onupdate)
    end
end)
--]==]

--[=[-ChatFrame_OnUpdate只是为了显示滚动到最下面的那个按钮闪烁
do
    local function onupdate(self, elapsed)
        self._flashTimer163 = self._flashTimer163 + elapsed
        if self._flashTimer163 >= 0.5 then
            self._flashTimer163 = 0
            local flash = self._flash163
            if ( self:AtBottom() ) then
                flash:Hide();
            else
                if ( flash:IsShown() ) then
                    flash:Hide();
                else
                    flash:Show();
                end
            end
        end
    end
    function ChatFrame_OnUpdate(self)
        self._flash163 = _G[self:GetName().."ButtonFrameBottomButtonFlash"];
        self._flashTimer163 = 0
        self:SetScript("OnUpdate", self._flash163 and onupdate or nil)
    end
end
--]=]

--[[
do
    local militaryTime = GetCVarBool("timeMgrUseMilitaryTime")
    CoreDependCall("Blizzard_TimeManager", function()
        hooksecurefunc("TimeManager_ToggleTimeFormat", function()
            militaryTime = GetCVarBool("timeMgrUseMilitaryTime")
        end)
    end)
    function GameTime_GetFormattedTime(hour, minute, wantAMPM)
        if ( militaryTime ) then
            return n2s(hour, 2)..":"..n2s(minute, 2); --TIMEMANAGER_TICKER_24HOUR
        else
            if ( wantAMPM ) then
                local suffix = " AM";
                if ( hour == 0 ) then
                    hour = 12;
                elseif ( hour == 12 ) then
                    suffix = " PM";
                elseif ( hour > 12 ) then
                    suffix = " PM";
                    hour = hour - 12;
                end
                return n2s(hour)..":"..n2s(minute,2)..suffix; --TIME_TWELVEHOURAM
            else
                if ( hour == 0 ) then
                    hour = 12;
                elseif ( hour > 12 ) then
                    hour = hour - 12;
                end
                return n2s(hour)..":"..n2s(minute, 2); --TIMEMANAGER_TICKER_12HOUR
            end
        end
    end
end
--]]

CoreDependCall("Blizzard_TimeManager", function()
    do return end--暂时屏蔽,这个会导致在 TimeManagerClockButton_OnUpdate 里之后调用 TimeManager_CheckAlarm 然后使 TimeManagerClockButton.currentMinuteCounter 被污染
    function TimeManagerClockButton_Update(self)
        local hour, minute = GetGameTime();
        local _lastTime = hour * 60 + minute
        if _lastTime ~=TimeManagerClockTicker._lastTime then
            TimeManagerClockTicker:SetText(GameTime_GetTime(false));
            TimeManagerClockTicker._lastTime = _lastTime
        end
    end
end)

--- ---------------- 污染问题 ------------
local deal_taint_dropdown = true
local deal_taint_options = false
local deal_taint_other = false
--[[
/run for _, control in next, AudioOptionsSoundPanel.controls do print(control:GetName(), isv(control, "oldValue")) end

local function AudioOptionsPanel_Refresh (self)
	for _, control in next, self.controls do
		BlizzardOptionsPanel_RefreshControl(control);
		-- record values so we can cancel back to this state
		control.oldValue = control.value;
	end
end
在这里面，遇到一个dropdown的，就会开始污染
/dump isv(AudioOptionsSoundPanelHardwareDropDown, "newValue") -> 1证明了是在下面两句里污染的

			UIDropDownMenu_SetSelectedValue(self, selectedDriverIndex);
			UIDropDownMenu_Initialize(self, AudioOptionsSoundPanelHardwareDropDown_Initialize);

/dump isv(AudioOptionsSoundPanelSoundChannelsDropDown, "value") -> GearManagerEx
进一步证明
/dump isv(DropDownList1, "numButtons")
--]]

--[[------------------------------------------------------------
处理4.3 OnEvent循环调用 ActionButton_Update()时因为读取OverlayGlow导致的污染
ActionButton_UpdateAction -> if ( event == "ACTIONBAR_PAGE_CHANGED" or event == "UPDATE_BONUS_ACTIONBAR" or event == "UPDATE_EXTRA_ACTIONBAR" ) then
ACTIONBAR_PAGE_CHANGED - ActionBarButtonEventsFrame
ACTIONBAR_SLOT_CHANGED - ActionBarButtonEventsFrame
PLAYER_ENTERING_WORLD - ActionBarButtonEventsFrame
UPDATE_SHAPESHIFT_FORM - ActionBarButtonEventsFrame
PET_STABLE_UPDATE, PET_STABLE_SHOW - ActionBarActionEventsFrame
/run hooksecurefunc("ActionButton_Update", function(f) if f==ActionButton1 then print(debugstack()) end end)
---------------------------------------------------------------]]
if deal_taint_other then
    local buttonEvents = {"ACTIONBAR_PAGE_CHANGED","ACTIONBAR_SLOT_CHANGED","PLAYER_ENTERING_WORLD","UPDATE_SHAPESHIFT_FORM"}
    local actionEvents = {"PET_STABLE_UPDATE", "PET_STABLE_SHOW" }
    for _, evt in ipairs(buttonEvents) do
        ActionBarButtonEventsFrame:UnregisterEvent(evt)
        for _, frm in pairs(ActionBarButtonEventsFrame.frames) do
            frm:RegisterEvent(evt)
        end
    end
    hooksecurefunc("ActionBarButtonEventsFrame_RegisterFrame", function(frame)
        for _, evt in ipairs(buttonEvents) do frame:RegisterEvent(evt) end
    end)
    for _, evt in ipairs(actionEvents) do
        ActionBarActionEventsFrame:UnregisterEvent(evt)
        for _, frm in pairs(ActionBarActionEventsFrame.frames) do
            frm:RegisterEvent(evt)
        end
    end
    hooksecurefunc("ActionBarActionEventsFrame_RegisterFrame", function(frame)
        for _, evt in ipairs(actionEvents) do frame:RegisterEvent(evt) end
    end)
end

--[[------------------------------------------------------------
清理DropDown的污染（3层的可以在专业附魔里测试）
---------------------------------------------------------------]]
local isv = issecurevariable
CoreOnEvent("PLAYER_LEAVING_WORLD", function() core.leavingWorld = 1 end)
CoreOnEvent("PLAYER_ENTERING_WORLD", function() core.leavingWorld = nil end)
local U1NoTaintCleanAll, tracingInfo
if(deal_taint_dropdown)then
    hooksecurefunc(CompactUnitFrameProfiles, "UnregisterEvent", function(self, event)
        if(event=="COMPACT_UNIT_FRAME_PROFILES_LOADED" or event=="VARIABLES_LOADED") then
            U1NoTaintCleanAll(); --清除了numButtons
        end
    end)

    local dropDownList1 = DropDownList1

    --捕获 UIDropDownMenuDelegate，因为测试发现，如果有 UIDROPDOWNMENU_OPEN_MENU 会造成污染
    hooksecurefunc(getmetatable(UIParent).__index, "SetAttribute", function(self, attr)
        if attr=="initmenu" and not core.t then core.t = self end
    end)
    --捕获 UIDropDownMenu_SecureInfo 因为如果里面有非安全的值，也会引起污染
    hooksecurefunc("UIDropDownMenu_AddButton", function(info)
            if core.s then return end
            for k,v in pairs(info) do
                if isv(info, k) then core.s = info return end
            end
        end)

    --numButtons如果清理掉则一些没经过IntializeHelper就直接AddButton的插件会报错
    --而如果不清理掉，则暴雪的插件一旦未经过Initialize直接调用UIDropDownMenu_SetSelectedValue就会污染
    local function cleanObject(obj)
        for k,v in pairs(obj) do
            if k~="__hooked" and k~="numButtons" and k~="maxWidth" and not isv(obj, k) then obj[k] = nil end
        end
    end

    ---清理drop及buttons的属性，(现在不清理openmenu和initmenu了，防止 RaidFrameDropDown_Initialize 之后报错)
    --注意不清理dropDownList1.numButtons, 只在LoadAddOn之后和CleanAll的时候清理
    local function cleanDrop(drop)
        if drop:IsVisible() then return end
        cleanObject(drop)
        --if not isv(drop, "numButtons") then drop.numButtons = nil end
        for j=1, UIDROPDOWNMENU_MAXBUTTONS, 1 do
            local button = _G["DropDownList"..drop:GetID().."Button"..j];
            cleanObject(button);
        end
        --if core.t and drop:GetID()==1 then
        --    core.t:SetAttribute("openmenu", nil)
        --    core.t:SetAttribute("initmenu", nil)
        --end
    end

    ---通过开启一次寻求组队来重置 UIDROPDOWNMENU_MENU_LEVEL，注意 UIDROPDOWNMENU_MENU_LEVEL 会被重置到 1，所以当有Drop显示时不能处理
    --因为LFDParentFrame:Show()会触发 LFG_LOCK_INFO_RECEIVED 和 LFG_UPDATE_RANDOM_INFO 所以会清掉
    --2012.9.14 实际生效的是 ScenarioQueueFrameTypeDropDown 的 OnShow
    local function cleanDropMenuLevel()
        local proxyFrame = ScenarioQueueFrameTypeDropDown
        if proxyFrame and not dropDownList1:IsVisible() and not isv("UIDROPDOWNMENU_MENU_LEVEL") then --这里一旦去掉 isv("UIDROPDOWNMENU_MENU_LEVEL") 这个条件, 立刻污染groupMode
            --print("cleanDropMenuLevel from "..tracingInfo)
            --ScenarioQueueFrameTypeDropDown 显示时会设置 UIDROPDOWNMENU_INIT_MENU, 从而导致可能的错误
            local lastInitMenu = UIDROPDOWNMENU_INIT_MENU
            local oldpar = proxyFrame:GetParent()
            proxyFrame:SetParent(nil)
            --proxyFrame:Hide() proxyFrame:Show()
            proxyFrame:SetParent(oldpar)
            if core.t then core.t:SetAttribute("initmenu", lastInitMenu); end
             --如果安全则不设置,否则要把这次LFD增加的按钮去掉
            --print(dropDownList1.numButtons, "isv = ", isv(dropDownList1, "numButtons")) --有时是不污染的
            if dropDownList1.numButtons then --and not isv(dropDownList1, "numButtons") then
                --去掉判断，是因为UIDropDownMenu_InitializeHelper在安全代码里设置numButtons为常量肯定是安全的
                --而且，如果运行到这里，说明UIDROPDOWN_MENU_LEVEL已经被污染了，之后只要AddButton就会污染numButtons，所以逻辑正确。
                --但是，存在一种情况，第三方插件调用时 UIDROPDOWN_MENU_LEVEL 未污染，则 cleanDropMenuLevel 就会导致 numButton 为 nil
                for j=1, dropDownList1.numButtons, 1 do
                    local button = _G["DropDownList1Button"..n2s(j)];
                    button:Hide();
                end
                --如果在加载期间设置，会导致污染
                if (HasLoadedCUFProfiles() and CompactUnitFrameProfiles.variablesLoaded) or U1IsAddonEnabled("CompactRaid") then
                    dropDownList1.numButtons = 0
                    dropDownList1.maxWidth = 0 --清理宽度
                end
                --numButtons 在 InitializeHelper 和 UIDropDownMenu_Refresh 会被安全的设置为 0
                --如果这里设置为0, 则初始化时，暴雪的插件直接调用 UIDropDownMenu_SetSelectedValue, 然后在 UIDropDownMenu_Refresh 中 就会污染
                --如果在 UIDropDownMenu_Initialize 把 numButtons 清理掉，则会报 nil 的错误
                --目前是在LoadAddOn之后立刻清理
            end
            --print("UIDROPDOWNMENU_MENU_LEVEL cleaned", "level=", (isv("UIDROPDOWNMENU_MENU_LEVEL")), "tot=", (isv("SHOW_TARGET_OF_TARGET_STATE")), "groupMode=",(isv(CompactRaidFrameContainer, "groupMode")))
        end
        --if not doNotCleanNumButtons then --InitializeHelper里绝对不能清理numButtons
            --print(isv(dropDownList1, "numButtons"), isv(DropDownList1, "numButtons"))
            --if not isv(dropDownList1, "numButtons") then dropDownList1.numButtons = nil end
            --if not isv(dropDownList1, "maxWidth") then dropDownList1.maxWidth = nil end
        --end
    end

    --第一时间清理掉 UIDROPDOWNMENU_MENU_LEVEL, 否则战场初次加载插件的时候就会有问题
    local cycle
    hooksecurefunc("UIDropDownMenu_InitializeHelper", function()
        if(cycle or core.leavingWorld or dropDownList1:IsVisible()) then return end --or UIDROPDOWNMENU_MENU_LEVEL ~= 1
        cycle = true
        --if not core.variableLoaded or not core.playerLogin then U1NoTaintCleanAll() else cleanDropMenuLevel() end --暂时不调用cleanAll，因为会清掉maxWidth导致报错
        tracingInfo = "helper"
        cleanDropMenuLevel();
        if not core.variableLoaded or not core.playerLogin then
            --这里如果不处理，那么就会导致4.3的CompactRaid被污染
            for i = 1, UIDROPDOWNMENU_MAXLEVELS, 1 do
                local dropDownList = _G["DropDownList"..n2s(i)];
                cleanDrop(dropDownList);
            end
        end
        cycle = nil
        if core.s then cleanObject(core.s) end
        --if core.t and not dropDownList1:IsVisible() then core.t:SetAttribute("openmenu", nil) end --这里肯定不能调用，因为ToggleDropDown先设置openmenu，再调用Initialize
        --print("UIDropDownMenu_InitializeHelper", isv("UIDROPDOWNMENU_MENU_LEVEL"))
        --RunOnNextFrameKey("U1Core_cleanNumButtons", cleanNumButtons)
    end)

    --Intialize之后意味着AddButton都执行完了，第一时间清理掉 secureInfo
    hooksecurefunc("UIDropDownMenu_Initialize", function()
        if core.leavingWorld then return end
        if core.s then cleanObject(core.s) end
        local stack = debugstack(3, 1, 0)
        if stack and (stack:find("`ToggleDropDownMenu'") or stack:find("\\ScenarioFinder%.lua"))then
            --之后会调用listFrame:Show(), 不进行处理
            RunOnNextFrameKey("U1NoTaintCleanAll", U1NoTaintCleanAll)
        else
            --print("UIDropDownMenu_Initialize", debugstack(3, 1, 0))
            --U1NoTaintCleanAll() --如果Initialize接着执行SetSelected就会出问题，因为UIDropDownMenu_Refresh，尝试Hook Refresh没成功
            RunOnNextFrameKey("U1NoTaintCleanAll", U1NoTaintCleanAll)
        end
    end)

    ---------------------- 当菜单隐藏时的清理 ------------------------
    -- 如果没有这个处理，则先打开界面，然后再打开其他插件的菜单就会出问题
    do
        -- 菜单隐藏分为两种情况，一个是在 UIDropDownMenuButton_OnClick 里，先隐藏后执行func，另一个是普通隐藏
        -- 新的实现是通过按钮的PreClick来判断，之前的实现是通过debugstack，都很2

        -- 在 OnHide 的时候调用，需要清理level和openmenu，基本上相当于CleanAll
        local function cleanDropAndLevel(drop)
            cleanDrop(drop) --代码顺序为什么要把cleanDrop放在上面? 不然会报numButtons==nil的错误
            --drop.numButtons = nil
            cleanDropMenuLevel()
        end

        --和 clearOnHide 配合的
        hooksecurefunc("UIDropDownMenuButton_OnClick", function(self)
            if(not self:GetParent():IsVisible()) then
                --print(self:GetParent():GetName(), "clear UIDropDownMenuButton_OnClick")
                tracingInfo = "click"
                cleanDropAndLevel(self:GetParent())
            end
        end)

        local __anyButtonClicked; --这个是一个全局性的，一但点击一个DropDownButton

        local function clearOnHide(self)
            --print("clearOnHide", __anyButtonClicked)
            if core.leavingWorld then return end
            --因为UIDropDownMenuButton_OnClick里是先Hide然后才运行button的func，所以清理要放到UIDropDownMenuButton_OnClick里
            --由于一次点击可能引起多个list的隐藏，所以只要有 __anyButtonClicked 就只清非当前list的data，click按钮的父list会在OnClick里清
            if(__anyButtonClicked) then
                --被点击的会在 UIDropDownMenuButton_OnClick 里清掉，所以这里是 ~=self
                if __anyButtonClicked ~= self then
                    --print(self:GetName(), "cleanDrop OnHide");
                    cleanDrop(self)
                end
            else
                --print(self:GetName(), "cleanDropAndLevel OnHide");
                tracingInfo = "hide"
                cleanDropAndLevel(self) --不是点击引发的隐藏 --似乎不需要RunOnNext了
            end
        end

        local function buttonOnPreClick(self)
            --print(self:GetName(), self:GetParent():GetName(), "OnPreClick");
            __anyButtonClicked = self:GetParent() --设置当前可能是点击按钮导致的隐藏
        end
        local function buttonHookClick(self)
            __anyButtonClicked = nil --清理掉标记
        end

        --添加隐藏事件
        hooksecurefunc("UIDropDownMenu_CreateFrames", function(level, index)
            for i=1, UIDROPDOWNMENU_MAXLEVELS do
                local dropDownList = _G["DropDownList"..n2s(i)];
                if not dropDownList.__hooked then
                    dropDownList.__hooked = 1
                    dropDownList:HookScript("OnHide", clearOnHide)
                end
                for j=1, UIDROPDOWNMENU_MAXBUTTONS do
                    local button = _G["DropDownList"..n2s(i).."Button"..n2s(j)]
                    if not button.__hooked then
                        button.__hooked = 1
                        button:SetScript("PreClick", buttonOnPreClick)
                        button:HookScript("OnClick", buttonHookClick)
                    end
                end
            end
        end)
    end
    -----------------------------------------------------------------------

    ---清理全部
    function U1NoTaintCleanAll()

        --先清理 UIDROPDOWNMENU_MENU_LEVEL，应该在前面执行
        tracingInfo = "all"
        cleanDropMenuLevel()

        if not dropDownList1:IsVisible() then
            --清理所有对象，其中会清理掉 openmenu
            for i = 1, UIDROPDOWNMENU_MAXLEVELS, 1 do
                local dropDownList = _G["DropDownList"..n2s(i)];
                cleanDrop(dropDownList);
                --dropDownList.numButtons = nil; --这里不清除也可以的
                --dropDownList.maxWidth = nil; --这里清除了会导致LoseControl报错
            end

            if core.t then
                core.t:SetAttribute("openmenu", nil)
                core.t:SetAttribute("initmenu", nil)
            end
        end

        --清理secureInfo, 这里其实不需要执行，保险起见吧.
        if core.s then cleanObject(core.s) end
        --print("all cleaned", isv("UIDROPDOWNMENU_MENU_LEVEL"), isv("SHOW_TARGET_OF_TARGET_STATE"), isv(CompactRaidFrameContainer, "groupMode"))
    end

    --在加载完插件之后全部清除一次，其实用处不大
    local NT_EVENTS, NT_OBJ = { "LOGIN_ADDONS_LOADED", "SOME_ADDONS_LOADED", }, {}
    for _, v in ipairs(NT_EVENTS) do
        NT_OBJ[v] = U1NoTaintCleanAll;
        CoreAddEvent(v); CoreRegisterEvent(v, NT_OBJ)
    end

    --一些特殊操作需要保证安全的地方
    local needPreClicks = {InterfaceOptionsFrameCancel, InterfaceOptionsFrameOkay, GameMenuButtonOptions, GameMenuButtonUIOptions, GameMenuButtonKeybindings, GameMenuButtonMacros, CompactRaidFrameManagerDisplayFrameOptionsButton }
    for _, v in ipairs(needPreClicks) do v:SetScript("PreClick", U1NoTaintCleanAll) end
    --OpenToCategory之间调用的
    hooksecurefunc("InterfaceOptionsFrame_TabOnClick", U1NoTaintCleanAll)

--[[
    --如果没有此处，则初始化时，暴雪的插件直接调用 UIDropDownMenu_SetSelectedValue, 然后在 UIDropDownMenu_Refresh 中读取 numButtons 就会污染
    --是由于Blizzard_CUFProfiles中的事件COMPACT_UNIT_FRAME_PROFILES_LOADED读取MENU_LEVEL导致的，因为这个事件是在PLAYER_LOGIN之后，
    --而我们在PLAYER_LOGIN后会触发LOGIN_ADDONS_LOADED把所有单体插件的污染清除，所以现在注释掉了
    hooksecurefunc("LoadAddOn", function(name)
        if name and not name:find("^Blizzard_") then --每次输入命令ChatFrame都会调用UIParentLoadAddOn()
            U1NoTaintCleanAll()
            dropDownList1.numButtons = nil;
        end
    end)
]]

end

if deal_taint_options then
    --- ---------------- 界面选项污染问题 ------------
    -- 需要搜索所有的 InterfaceOptionsFrameAddOns 改成 InterfaceOptionsFrameAddOns2
    local SecureNext = next
    local INTERFACEOPTIONS_ADDONCATEGORIES = {}

    local ButtonOnMouseWheel = function(self, delta)
        local bar = _G[self:GetParent():GetName() .. "ListScrollBar"]
        bar:SetValue(bar:GetValue() - (delta * self:GetHeight() * (IsModifierKeyDown() and 10 or 1)))
    end
        
    local displayedElements = {}
    function InterfaceAddOnsList_Update2 ()
        -- Might want to merge this into InterfaceCategoryList_Update depending on whether or not things get differentiated.
        local offset = FauxScrollFrame_GetOffset(InterfaceOptionsFrameAddOns2List);
        local buttons = InterfaceOptionsFrameAddOns2.buttons;
        local element;

        for i, element in SecureNext, displayedElements do
            displayedElements[i] = nil;
        end

        for i, element in SecureNext, INTERFACEOPTIONS_ADDONCATEGORIES do
            if ( not element.hidden ) then
                tinsert(displayedElements, element);
            end
        end

        local numAddOnCategories = #displayedElements;
        local numButtons = #buttons;

        -- Show the AddOns tab if it's not empty.
        if ( ( InterfaceOptionsFrameTab2 and not InterfaceOptionsFrameTab2:IsShown() ) and numAddOnCategories > 0 ) then
            InterfaceOptionsFrameCategoriesTop:Hide();
            InterfaceOptionsFrameAddOnsTop:Hide();
            InterfaceOptionsFrameTab1:Show();
            InterfaceOptionsFrameTab2:Show();
        end

        if ( numAddOnCategories > numButtons and ( not InterfaceOptionsFrameAddOns2List:IsShown() ) ) then
            -- We need to show the scroll bar, we have more elements than buttons.
            OptionsList_DisplayScrollBar(InterfaceOptionsFrameAddOns2);
        elseif ( numAddOnCategories <= numButtons and ( InterfaceOptionsFrameAddOns2List:IsShown() ) ) then
            -- Hide the scrollbar, there's nothing to scroll.
            OptionsList_HideScrollBar(InterfaceOptionsFrameAddOns2);
        end

        FauxScrollFrame_Update(InterfaceOptionsFrameAddOns2List, numAddOnCategories, numButtons, buttons[1]:GetHeight());

        local selection = InterfaceOptionsFrameAddOns2.selection;
        if ( selection ) then
            OptionsList_ClearSelection(InterfaceOptionsFrameAddOns2, InterfaceOptionsFrameAddOns2.buttons);
        end

        for i = 1, #buttons do
            element = displayedElements[i + offset]
            if not buttons[i]:IsMouseWheelEnabled() then
                buttons[i]:EnableMouseWheel()
                buttons[i]:SetScript("OnMouseWheel", ButtonOnMouseWheel)
            end
            if ( not element ) then
                OptionsList_HideButton(buttons[i]);
            else
                OptionsList_DisplayButton(buttons[i], element);

                if ( selection ) and ( selection == element ) and ( not InterfaceOptionsFrameAddOns2.selection ) then
                    OptionsList_SelectButton(InterfaceOptionsFrameAddOns2, buttons[i]);
                end
            end
        end

        if ( selection ) then
            InterfaceOptionsFrameAddOns2.selection = selection;
        end
    end

    function InterfaceOptionsListButton_ToggleSubCategories2 (self)
        local element = self.element;

        element.collapsed = not element.collapsed;
        local collapsed = element.collapsed;

        for _, category in SecureNext, INTERFACEOPTIONS_ADDONCATEGORIES do
            if ( category.parent == element.name ) then
                if ( collapsed ) then
                    category.hidden = true;
                else
                    category.hidden = false;
                end
            end
        end

        InterfaceAddOnsList_Update2();
    end

    function InterfaceOptionsListButton_OnClick2 (self, mouseButton)
        if ( mouseButton == "RightButton" ) then
            if ( self.element.hasChildren ) then
                OptionsListButtonToggle_OnClick(self.toggle);
            end
            return;
        end

        local parent = self:GetParent();
        local buttons = parent.buttons;

        OptionsList_ClearSelection(InterfaceOptionsFrameCategories, InterfaceOptionsFrameCategories.buttons);
        OptionsList_ClearSelection(InterfaceOptionsFrameAddOns2, InterfaceOptionsFrameAddOns2.buttons);
        OptionsList_SelectButton(parent, self);

        InterfaceOptionsList_DisplayPanel2(self.element);
    end

    function InterfaceOptionsList_DisplayPanel2(frame)
        if ( InterfaceOptionsFramePanelContainer.displayedPanel ) then
            InterfaceOptionsFramePanelContainer.displayedPanel:Hide();
            InterfaceOptionsFramePanelContainer.displayedPanel = nil;
        end
        if ( InterfaceOptionsFramePanelContainer.displayedPanel2 ) then
            InterfaceOptionsFramePanelContainer.displayedPanel2:Hide();
        end

        InterfaceOptionsFramePanelContainer.displayedPanel2 = frame;

        frame:SetParent(InterfaceOptionsFramePanelContainer);
        frame:ClearAllPoints();
        frame:SetPoint("TOPLEFT", InterfaceOptionsFramePanelContainer, "TOPLEFT");
        frame:SetPoint("BOTTOMRIGHT", InterfaceOptionsFramePanelContainer, "BOTTOMRIGHT");
        frame:Show();
    end

    --暴雪在初始化之后就不会再调用 InterfaceOptions_AddCategory 了
    setfenv(InterfaceOptions_AddCategory, setmetatable({
        INTERFACEOPTIONS_ADDONCATEGORIES = INTERFACEOPTIONS_ADDONCATEGORIES,
        InterfaceAddOnsList_Update = InterfaceAddOnsList_Update2
    }, {__index=_G}))

    _G["InterfaceOptionsFrameAddOns"]:HookScript("OnShow", function() InterfaceOptionsFrameAddOns2:Show() end)
    _G["InterfaceOptionsFrameAddOns"]:HookScript("OnHide", function() InterfaceOptionsFrameAddOns2:Hide() end)

    hooksecurefunc("InterfaceOptionsList_DisplayPanel", function(frame)
    --外围的判断条件是原函数所没有的
    --如果是从 InterfaceOptionsFrame_OnShow 里调用过来的，则如果之前的面板是 displayedPanel2 则再次调用 InterfaceOptionsFrame_OpenToCategory
    --参见 hooksecurefunc("InterfaceOptionsFrame_OpenToCategory", 的说明
    --不能写到 InterfaceOptionsFrame_OpenToCategory 的posthook中，因为会清掉displayPanel2
    --CONTROLS_LABEL 是没有上次打开选项页时候的默认选项页
        local ct = InterfaceOptionsFramePanelContainer
        if(frame and frame.name==CONTROLS_LABEL and debugstack():find("InterfaceOptionsFrame_OpenToCategory")) then
            if ( ct.displayedPanel2 ) then
                if ( ct.displayedPanel ) then
                    ct.displayedPanel:Hide();
                    ct.displayedPanel = nil;
                end
                InterfaceOptionsFrame_OpenToCategory(ct.displayedPanel2)
            end
        else
            --这里是兼容IOF_OTC方法的，如果上次打开的是系统面板，则再次打开就不隐藏
            if ( ct.displayedPanel2 and ct.displayedPanel2 ~= ct.displayedPanel) then
                ct.displayedPanel2:Hide();
                ct.displayedPanel2 = nil;
            end
        end
    end)

    hooksecurefunc("InterfaceOptionsFrame_OpenToCategory", function(panel)
    --主要问题是, InterfaceOptionsFrame_Show 会调用 InterfaceOptionsFrame_OnShow
    --而对于我们的hack面板，InterfaceOptionsFramePanelContainer.displayedPanel 始终是nil，所以会再次调用InterfaceOptionsFrame_OpenToCategory(CONTROLS_LABEL)
    --我的处理方法是在 InterfaceOptionsFrame_OpenToCategory 调用 InterfaceOptionsList_DisplayPanel 的时候，再次选择一次，而此时不会触发 InterfaceOptionsFrame_OnShow
    --参见 hooksecurefunc("InterfaceOptionsList_DisplayPanel", function(frame)

        local panelName;
        if ( type(panel) == "string" ) then
            panelName = panel;
            panel = nil;
        end

        assert(panelName or panel, 'Usage: InterfaceOptionsFrame_OpenToCategory("categoryName" or panel)');

        local blizzardElement, elementToDisplay

        if ( not elementToDisplay ) then
            for i, element in SecureNext, INTERFACEOPTIONS_ADDONCATEGORIES do
                if ( element == panel or (panelName and element.name and element.name == panelName) ) then
                    elementToDisplay = element;
                    break;
                end
            end
        end

        if ( not elementToDisplay ) then
            return;
        end

        --if ( blizzardElement ) then
        InterfaceOptionsFrameTab2:Click();
        local buttons = InterfaceOptionsFrameAddOns2.buttons;
        for i, button in SecureNext, buttons do
            if ( button.element == elementToDisplay ) then
                InterfaceOptionsListButton_OnClick2(button);
            elseif ( elementToDisplay.parent and button.element and (button.element.name == elementToDisplay.parent and button.element.collapsed) ) then
                OptionsListButtonToggle_OnClick(button.toggle);
            end
        end

        if ( not InterfaceOptionsFrame:IsShown() ) then
            InterfaceOptionsFrame_Show();
        end

        U1NoTaintCleanAll();
    --end
    end)

    InterfaceOptionsFrame:HookScript("OnShow", function(self)
    --刷新hack的插件选项列表
    --参见 InterfaceOptionsFrame_OnShow
    --打开上次面板InterfaceOptionsFrame_OpenToCategory(CONTROLS_LABEL)是通过 InterfaceOptionsList_DisplayPanel 的Hook处理的
        InterfaceAddOnsList_Update2();
        InterfaceOptionsOptionsFrame_RefreshAddOns2();
    end)

    local function InterfaceOptionsFrame_RunOkayForCategory (category)
        pcall(category.okay, category);
    end

    local function InterfaceOptionsFrame_RunDefaultForCategory (category)
        pcall(category.default, category);
    end

    local function InterfaceOptionsFrame_RunCancelForCategory (category)
        pcall(category.cancel, category);
    end

    local function InterfaceOptionsFrame_RunRefreshForCategory (category)
        pcall(category.refresh, category);
    end

    InterfaceOptionsFrameOkay:HookScript("OnClick", function (self, button, apply)
        for _, category in SecureNext, INTERFACEOPTIONS_ADDONCATEGORIES do
            securecall(InterfaceOptionsFrame_RunOkayForCategory, category);
        end
        U1NoTaintCleanAll();
    end)

    InterfaceOptionsFrameCancel:HookScript("OnClick", function (self, button)
        for _, category in SecureNext, INTERFACEOPTIONS_ADDONCATEGORIES do
            securecall(InterfaceOptionsFrame_RunCancelForCategory, category);
        end
        U1NoTaintCleanAll();
    end)

    hooksecurefunc("InterfaceOptionsFrame_SetAllToDefaults", function()
        for _, category in SecureNext, INTERFACEOPTIONS_ADDONCATEGORIES do
            securecall(InterfaceOptionsFrame_RunDefaultForCategory, category);
        end
        InterfaceOptionsOptionsFrame_RefreshAddOns2();
    end)

    hooksecurefunc("InterfaceOptionsFrame_SetCurrentToDefaults", function()
        local displayedPanel = InterfaceOptionsFramePanelContainer.displayedPanel2;
        if ( not displayedPanel or not displayedPanel.default ) then
            return;
        end

        displayedPanel.default(displayedPanel);
        --Run the refresh method to refresh any values that were changed.
        displayedPanel.refresh(displayedPanel);
        U1NoTaintCleanAll();
    end)

    function InterfaceOptionsOptionsFrame_RefreshAddOns2()
        for _, category in SecureNext, INTERFACEOPTIONS_ADDONCATEGORIES do
            securecall(InterfaceOptionsFrame_RunRefreshForCategory, category);
        end
        U1NoTaintCleanAll();
    end

    --InterfaceOptionsFrame_OpenToCategory
    --/run CoreIOF_OTC(InterfaceOptionsCombatPanel)
    function CoreIOF_OTC(panel)
        U1NoTaintCleanAll();
        InterfaceOptionsFrame:Show();
        if type(panel)=="string" then
            for i, element in SecureNext, INTERFACEOPTIONS_ADDONCATEGORIES do
                if ( panel and element.name and element.name == panel ) then
                    InterfaceOptionsList_DisplayPanel2(element)
                    return
                end
            end
        else
            InterfaceOptionsList_DisplayPanel2(panel)
        end
    end
    --hooksecurefunc("InterfaceOptionsOptionsFrame_RefreshAddOns", InterfaceOptionsOptionsFrame_RefreshAddOns2) --测试过，不用这句，只有OnShow和InterfaceOptionsFrame_SetAllToDefaults的时候用
else
    CoreIOF_OTC = InterfaceOptionsFrame_OpenToCategory
end


--[[--------------------------------------------
Deal with StaticPopup_Show()
/run StaticPopup_Show('PARTY_INVITE',"test")
----------------------------------------------]]
if deal_taint_other then
    local function hook()
        PlayerTalentFrame_Toggle = function()
            if ( not PlayerTalentFrame:IsShown() ) then
                ShowUIPanel(PlayerTalentFrame);
                TalentMicroButtonAlert:Hide();
            else
                PlayerTalentFrame_Close();
            end
        end

        for i=1, 10 do
            local tab = _G["PlayerTalentFrameTab"..i];
            if not tab then break end
            tab:SetScript("PreClick", function()
                --print("PreClicked")
                for index = 1, STATICPOPUP_NUMDIALOGS, 1 do
                    local frame = _G["StaticPopup"..index];
                    if(not issecurevariable(frame, "which")) then
                        local info = StaticPopupDialogs[frame.which];
                        if frame:IsShown() and info and not issecurevariable(info, "OnCancel") then
                            info.OnCancel()
                        end
                        frame:Hide()
                        frame.which = nil
                    end
                end
            end)
        end
    end

    if(IsAddOnLoaded("Blizzard_TalentUI")) then
        hook()
    else
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, addon)
            if(addon=="Blizzard_TalentUI")then
                self:UnregisterEvent("ADDON_LOADED")
                hook()
            end
        end)
    end
end

--[[--------------------------------------------
Deal with UIFrameFlash & UIFrameFade
/run UIFrameFlash(PlayerFrame, 1,1, -1,true,0,0,"test")
----------------------------------------------]]
if deal_taint_other then
    local L
    if GetLocale()=="zhTW" or GetLocale()=="zhCN" then
        L = {
            FADE_PREVENT = "!NoTaint阻止了对UIFrameFade的调用.",
            FLASH_FAILED = "你的插件调用了UIFrameFlash，导致你可能无法切换天赋，请修改对应代码。",
        }
    else
        L = {
            FADE_PREVENT = "Call of UIFrameFade is prevented by !NoTaint.",
            FLASH_FAILED = "AddOn calls UIFrameFlash, you may not be able to switch talent.",
        }
    end

    hooksecurefunc("UIFrameFlash", function (frame, fadeInTime, fadeOutTime, flashDuration, showWhenDone, flashInHoldTime, flashOutHoldTime, syncId)
        if ( frame ) then
            if not issecurevariable(frame, "syncId") or not issecurevariable(frame, "fadeInTime") or not issecurevariable(frame, "flashTimer") then
                error(L.FLASH_FAILED)
                --UIFrameFlashStop(frame)
                --frameFlashManager:SetScript("OnUpdate", nil)
            end
        end
    end)
end

--[[----------------------------------------------------
-- Deal with FCF_StartAlertFlash
-- which is called only in ChatFrame_MessageEventHandler
-------------------------------------------------------]]
if deal_taint_other then
    local function FCFTab_UpdateAlpha(chatFrame, alerting)
        local chatTab = _G[chatFrame:GetName().."Tab"];
        local mouseOverAlpha, noMouseAlpha
        if ( not chatFrame.isDocked or chatFrame == FCFDock_GetSelectedWindow(GENERAL_CHAT_DOCK) ) then
            mouseOverAlpha = CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA;
            noMouseAlpha = CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA;
        else
            if ( alerting ) then
                mouseOverAlpha = CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA;
                noMouseAlpha = CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA;
            else
                mouseOverAlpha = CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA;
                noMouseAlpha = CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA;
            end
        end

        -- If this is in the middle of fading, stop it, since we're about to set the alpha
        UIFrameFadeRemoveFrame(chatTab);

        if ( chatFrame.hasBeenFaded ) then
            chatTab:SetAlpha(mouseOverAlpha);
        else
            chatTab:SetAlpha(noMouseAlpha);
        end
    end

    function FCF_StartAlertFlash(chatFrame)
        if ( chatFrame.minFrame ) then
            UICoreFrameFlash(chatFrame.minFrame.glow, 1.0, 1.0, -1, false, 0, 0, nil);

            --chatFrame.minFrame.alerting = true;
        end

        local chatTab = _G[chatFrame:GetName().."Tab"];
        UICoreFrameFlash(chatTab.glow, 1.0, 1.0, -1, false, 0, 0, nil);

        --chatTab.alerting = true;

        FCFTab_UpdateAlpha(chatFrame, true);

        --FCFDockOverflowButton_UpdatePulseState(GENERAL_CHAT_DOCK.overflowButton);
    end

    hooksecurefunc("FCF_StopAlertFlash", function(chatFrame)
        if ( chatFrame.minFrame ) then
            UICoreFrameFlashStop(chatFrame.minFrame.glow);

            --chatFrame.minFrame.alerting = false;
        end

        local chatTab = _G[chatFrame:GetName().."Tab"];
        UICoreFrameFlashStop(chatTab.glow);

        --chatTab.alerting = false;

        FCFTab_UpdateAlpha(chatFrame, false);

        --FCFDockOverflowButton_UpdatePulseState(GENERAL_CHAT_DOCK.overflowButton);
    end)
end
-- ======================= 污染问题 end ==========================

---可以输出代码位置的调试方法
function CoreDebug(...)
    local stack = debugstack(1);
    local pos = stack:find("\n");
    stack = pos and stack:sub(pos+1) or stack;
    pos = stack:find("\n")
    stack = pos and stack:sub(1, pos-1) or stack;
    --Interface\AddOns\163SettingPack\Main.lua:37: in function <Interface\AddOns\163SettingPack\Main.lua:30>
    local parts = {strsplit(":", stack)};
    local params = {...}
    for i=1,#params do params[i] = tostring(params[i]) end
    if #parts >= 3 then
        local _,_,addon = strfind(parts[1], "^Interface\\AddOns\\(.-)\\.*");
        local _,_,file = strfind(parts[1], ".*\\(.-%.[%a]-)$");
        local line = tonumber(parts[2]);
        local _,_,func = strfind(parts[3], " in function `(.-)'");
        if not func then func = "?" end
        print(format("|cff3f3f3f[%s]|r %s |cff3f3f3f@%s:%s():%d|r", addon or "macro", table.concat(params, ", "), file or "string", func, line));
    else
        print(stack);
        print(format("|cff3f3f3f[%s]|r %s", core:GetName(), table.concat(params, ", ")));
    end
end

u1debug = DEBUG_MODE and CoreDebug or noop

local CTAF = {}
---用来返回CreateFrame, hooksecurefunc, getreplacehook, togglefunc的工厂方法
---@param replaces 是要替换的全局函数, 要保证执行本函数时尚未被替换，而执行getreplacehook()时已经被替换
---@param preCall 是togglefunc通用部分之前调用的, postCall则是之后调用的
function CoreToggleAddonFactory(name, replaces, preCall, postCall)
    local _allframes, _allhooks, _CreateFrame, _hooksecurefunc, _getreplacehook, _togglefunc = {}, {}
    local store = { status = true, _allframes, _allhooks, replaces, }
    CTAF[name] = store

    _CreateFrame = function(...)
        local frame = CreateFrame(...)
        _allframes[frame] = true
        return frame
    end

    _hooksecurefunc = function(funcname, hookfunc, arg3)
        local obj = nil
        if arg3 then
            obj = funcname
            funcname = hookfunc
            hookfunc = arg3
        end
        tinsert(_allhooks, hookfunc)
        local id = #_allhooks
        local newhook = function(...) if store.status then _allhooks[id](...) end end
        if obj then
            hooksecurefunc(obj, funcname, newhook)
        else
            hooksecurefunc(funcname, newhook)
        end
    end

    for i=1, #replaces do
        replaces[replaces[i]] = _G[replaces[i]]
    end

    _getreplacehook = function()
        for i=1, #replaces do
            replaces["HOOK."..replaces[i]] = _G[replaces[i]]
        end
    end

    _togglefunc = function(force)
        if force~=nil and force==store.status then return end
        store.status = not store.status

        if preCall then preCall(store) end

        local _allframes, replaces = store[1], store[3]
        if store.status then
            for i=1, #replaces do
                _G[replaces[i]] = replaces["HOOK."..replaces[i]]
            end
            for f, _ in pairs(_allframes) do
                if f.___onevent then
                    f:SetScript("OnEvent", f.___onevent)
                    f.___onevent = nil
                end
                if f.___update then
                    f:SetScript("OnUpdate", f.___update)
                    f.___update = nil
                end

                if f.___shown then f:Show() end
                f.___shown = nil
            end
        else
            for i=1, #replaces do
                _G[replaces[i]] = replaces[replaces[i]]
            end
            for f, _ in pairs(_allframes) do
                f.___onevent = f:GetScript("OnEvent")
                f:SetScript("OnEvent", nil)
                f.___update = f:GetScript("OnUpdate")
                f:SetScript("OnUpdate", nil)

                f.___shown = f:IsShown()
                f:Hide()
            end
        end

        if postCall then postCall(store) end
    end

    return _CreateFrame, _hooksecurefunc, _getreplacehook, _togglefunc
end

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

--[[------------------------------------------------------------
        5.2 API rename
---------------------------------------------------------------]]

_G.SetRaidDifficulty = SetRaidDifficultyID
_G.GetRaidDifficulty = GetRaidDifficultyID

------------ from RunSecond --------------
--防止战斗中初次调用时，会无法设置
if CoreUIGetUIPanelWindowInfo then
    for k, v in pairs(UIPanelWindows) do
        if _G[k] then CoreUIGetUIPanelWindowInfo(_G[k], "area"); end
    end
end

WithAllChatFrame(function(frame)
    frame:SetClampRectInsets(5, -40, 0, 0)
    for i=1, 2 do
        local p1, rel, p2, x, y = frame.editBox:GetPoint(2)
        if p1 == "RIGHT" then
            frame.editBox:SetPoint(p1, rel, p2, x - 20, y) --把中英按钮切换空出来
            break
        end
    end
end)

if QuestLogFrame then
    CoreHookScript(QuestLogFrame, "OnShow", function() QuestInfoDescriptionText:SetAlphaGradient(1024, QUEST_DESCRIPTION_GRADIENT_LENGTH); end, true)
end

-- 避免误操作关闭taint的插件
if(StaticPopupDialogs) then
    StaticPopupDialogs["ADDON_ACTION_FORBIDDEN"].OnAccept = function() end
end

--用命令打开界面设置时，会强制到"控制页", 参见 InterfaceOptionsFrame_OnShow 及 InterfaceOptionsFrame_OpenToCategory
local InterfaceOptionsFrameTab2ClickMine = false
hooksecurefunc(InterfaceOptionsFrameTab2, "Click", function(self)
    if not InterfaceOptionsFrameTab2ClickMine then
        if not InterfaceOptionsFrame:IsShown() then InterfaceOptionsFrame_Show() end
        InterfaceOptionsFrameTab2ClickMine = true
        InterfaceOptionsFrameTab2:Click()
        InterfaceOptionsFrameTab2ClickMine = false
    end
end)

--去掉面板选项里的前缀, 这样替换是安全的，因为暴雪的选项都是提前加载完了
local InterfaceOptions_AddCategory_ORIGIN = InterfaceOptions_AddCategory
function InterfaceOptions_AddCategory (frame, addOn, position)
    if ( not type(frame) == "table" or not frame.name ) then return end
    frame.name = frame.name:gsub("%|cff880303%[网易有爱%]%|r ", ""):gsub("%|cff880303%[有爱%]%|r ", ""):gsub("%|cff880303%[爱不易%]%|r ", "")
    frame.parent = frame.parent and frame.parent:gsub("%|cff880303%[网易有爱%]%|r ", ""):gsub("%|cff880303%[有爱%]%|r ", ""):gsub("%|cff880303%[爱不易%]%|r ", "")
    InterfaceOptions_AddCategory_ORIGIN(frame, addOn, position)
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

--[[ tdCooldown用的
if SetActionUIButton then
    U1Hook_SetActionUIButton = {}
    local shown = U1Hook_SetActionUIButton
    local onShow = function(self) shown[self] = true end
    local onHide = function(self) shown[self] = nil end

    local add = function(btn, action, cd)
        if(not cd.tcdAction) then
            cd.type = 'ACTION'
            cd:HookScript('OnShow', onShow)
            cd:HookScript('OnHide', onHide)
            if(cd:IsShown()) then
                shown[cd] = true
            end
        end
        cd.tcdAction = action
    end

    hooksecurefunc('SetActionUIButton', function(...)
        return add(...)
    end)

    for _, btn in next, ActionBarButtonEventsFrame.frames do
        add(btn, btn.action, btn.cooldown)
    end
end
--]]

--[[
./AddOns/Blizzard_GlyphUI/Blizzard_GlyphUI.lua
        130     [174]   GETGLOBAL       7 -36   ; _
        131     [174]   GETGLOBAL       8 -36   ; _
--]]
-- hooksecurefunc('GetGlyphClearInfo', function() _G._ = nil end)


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


--[[
hook(nil, "GetGuildNewsInfo", function(index)
    local isSticky, isHeader, newsType, text1, text2, id, data, data2, weekday, day, month, year = CoreGlobalHooks._origins.GetGuildNewsInfo(index);
    if not newsType and index<=GetNumGuildNews() then
        return isSticky, 1, newsType, text1, text2, id, data, data2, 1, 0, 6, 1984
    else
        return isSticky, isHeader, newsType, text1, text2, id, data, data2, weekday, day, month, year
    end
end)
]]

--hooksecurefunc("print", function() ChatFrame1:AddMessage(debugstack()) end)

if DEBUG_MODE and EclipseBarFrame then
    local function hookEclipseBarMarker() EclipseBarFrame.marker:SetSize(60,60) EclipseBarFrame.powerText:SetAlpha(.5) end
    if EclipseBarFrame:IsShown() then hookEclipseBarMarker() end
    EclipseBarFrame:HookScript("OnShow", hookEclipseBarMarker)
end
--[[------------------------------------------------------------
--protection area end
---------------------------------------------------------------]]
