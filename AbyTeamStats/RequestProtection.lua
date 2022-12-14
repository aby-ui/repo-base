--todo: callingFunc能够带回unitId
--可以注册事件，利用其它插件发起请求的结果
--[[
观察保护框架
API:Schedule(“RequestFunction”, CallingFunc or CallingArgs, CallbackFunc)
-	CallingFunc(protected) 参数protected用来表示被保护的API。
-	CallingArgs可以是table或者一个简单的参数
-	CallbackFunc的回调函数是function(success, cause/event, …)，其中success是boolean，cause是”timeout”、”interrupted”、”blocked”用来表示是规定时间内没有响应还是被玩家手工的请求给中断了。
举例：
    Schedule(“NotifyInspect”, unit, function(…) end )
    Schedule(“NotifyInspect”, function(protected) if ... then protected() end end, function(…) end )

另外有Call(…)参数一样，此时CallbackFunc的原因可能是blocked

注意：本API只负责保护一个请求对应一个响应，但不能保证响应时的unit仍然是请求时的
调用者应该自己保存unit和guid，防止mouseover这种脱离
--]]


RequestProtection = {}
local RP = RequestProtection
local debug = function() end
local submitRequest, doneRequest --private declaration
local stats = {} --各个函数调用状态
local mirror = {} --事件映射回API
local enteredWorld = IsLoggedIn()

--要保护的函数和对应的事件
local PROTECT_LIST = {

    SetAchievementComparisonUnit = {
        event = "INSPECT_ACHIEVEMENT_READY",
        pattern = "UIParent%.lua:%d-: in function `InspectAchievements'",
        guid_getter = function(...) return UnitGUID(...) end,
        timeout = 120,
        interval = 5,
        clear = "ClearAchievementComparisonUnit"
    },
}

local function scheduleOrBlock(schedule, name, reqFuncOrArgs, callback)
    assert(PROTECT_LIST[name], "This function is not protected.")
    local stat = stats[name]
    if stat.timeout or stat.interval then
        --如果已有调用信息，则入根据是否schedule决定入队列还是返回blocked
        if shedule then
            table.insert(stat.queue, {reqFuncOrArgs, callback})
        else
            --如果不这样处理, 会导致callback在API返回之前调用,
            --就像是这样：NotifyInspect { ... callback ... return }
            --这会导致一些callback无法获取一些在NotifyInspect返回之后才设置的信息
            --debug(name, " blocked")
            RunOnNextFrame(callback, false, "blocked")
        end
    else
        submitRequest(name, reqFuncOrArgs, callback, true)
    end
end

--@param reqFuncOrArgs, 请求Command或者直接调用原始时的参数
--@param callback 回调函数, 参数是(success, cause/event, …)
function RP:Schedule(name, reqFuncOrArgs, callback)
    scheduleOrBlock(true, name, reqFuncOrArgs, callback)
end

function RP:Call(name, reqFuncOrArgs, callback)
    scheduleOrBlock(false, name, reqFuncOrArgs, callback)
end

--直接替换全局函数的hook, 相当于local origin = NotifyInspect; NotifyInspect = function(...) origin(...) end
--差别是一个库的不同版本可以多次hook而不会出错, 上面这种会同时保存两个版本的hook
--(错误) 目的是可以强制把两行写在一起，另外主要是用同一段代码来封装类似的过程.
--用这个hook能unhook
--@param name 要被取代的全局函数名
--@param func 新的函数体
function RP:hook(name, func)
	assert(type(_G[name])=="function", "Bad arg1, string function name expected")
	assert(type(func)=="function", "Bad arg2, function expected")

	self.origins = self.origins or {}
	self.hooks = self.hooks or {}

	if not self.origins[name] then
		self.origins[name] = _G[name]
		_G[name] = function(...) return self.hooks[name](...) end
	end
	self.hooks[name] = func
end

local frame = WW:Frame():RegisterEvent("ADDON_LOADED") --处理InspectFrame报错的问题
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_LEAVING_WORLD")
for _name, define in pairs(PROTECT_LIST) do
    --注册对应的事件
    frame:RegisterEvent(define.event)
    --初始化队列
    stats[_name] = {
        callback = nil, --当前请求的回调函数
        timeout = nil, --距离超时的时间
        interval = nil, --距离下次调用的时间
        queue = {},
        guid, --当前呼叫的名字
    }
    mirror[define.event] = _name

    local o = _G[define.clear]
    _G[define.clear] = function(...) --[[debug(define.clear.." called", ...)]] o(...) end
    --空置清理的API, 下次请求时才清除.
    RP:hook(define.clear, function()
        debug(define.clear, " blocked")
    end)
    --保护各个函数
    RP:hook(_name, function(...)
        debug(_name, "called", ...)
        local stat, define = stats[_name], PROTECT_LIST[_name]
        local manual = debugstack():find(define.pattern)
        --debug(manual and "manual" or "not manual");
        if manual or ( stat.timeout==nil and stat.interval==nil and enteredWorld) then
            local newguid = define.guid_getter(...)
            if stat.guid == newguid then
                --如果两次guid相同，则共用一个，不再发起请求
                return
            end

            if manual then
                doneRequest(_name, false, "interrupted")
            end
            stat.timeout = GetTime() + define.timeout
            stat.interval = nil
            stat.guid = guid
            pcall(RP.origins[define.clear]) --请求之前才调用清理API
            return RP.origins[_name](...)
        end
        --else: blocked
        debug(_name, ", but blocked");
    end)
end

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        if ...=="Blizzard_InspectUI" then
            if InspectGuildFrame_Update then
                RP:hook("InspectGuildFrame_Update", function()
                    if InspectFrame.unit and GetGuildInfo(InspectFrame.unit) then
                        RP.origins["InspectGuildFrame_Update"]()
                    end
                end);
            end
        elseif ...=="Blizzard_AchievementUI" then
            if AchievementFrameComparison_UpdateStatusBars then
                RP:hook("AchievementFrameComparison_UpdateStatusBars", function(id)
                    if id and id~="summary" then
                        RP.origins["AchievementFrameComparison_UpdateStatusBars"](id)
                    end
                end)
            end
        end
    elseif event=="PLAYER_ENTERING_WORLD" then
        enteredWorld = true
    elseif event=="PLAYER_LEAVING_WORLD" then
        enteredWorld = false
    elseif mirror[event] then
        --debug(mirror[event], "success", stats[mirror[event]].guid)
        doneRequest(mirror[event], true, event, ...)
    end
end)

--minimum interval of 0.05 second
local span,next = 0.05, 0
frame:SetScript("OnUpdate", function(self, elapsed)
    if next > span then
        next = 0
        local now = GetTime()
        --循环判断所有保护的函数
        for _name, stat in pairs(stats) do
            if stat.timeout and now >= stat.timeout then
                debug(_name, "timeout")
                --回调timeout
                doneRequest(_name, false, "timeout")
            end
            --可以设置interval为0
            if stat.interval and now >= stat.interval then
                --debug(_name, "interval")
                stat.interval = nil
                --检查队列里的下一个
                --如果队列里的请求可能是会skip的, 所以要循环
                while stat.timeout == nil and #stat.queue  > 0 do
                    submitRequest(_name, unpack(table.remove(stat.queue, 1)))
                end
            end
        end
    else
        next = next + elapsed
    end
end)

--===================================================
-- private functions
--===================================================

--执行请求，但是注意，如果是reqFunc的话，可能并没有实际调用API
--如果实际上没有调用保护函数(在reqFunc里被条件阻止了), 则直接调用回调函数success=false, cause='skip'
--改函数在两处使用：
--1. OnUpdate时提交队列里的请求
--2. 用Schedule或者Call运行时不需要排队，直接提交
--@param nextFrame 是用来判断是否要在下一帧调用callback, 上面2的情况是
submitRequest = function(name, reqFuncOrArgs, callback, nextFrame)
    local stat, type = stats[name], type(reqFuncOrArgs)
    if type ~= "function" then
        if type == "table" then
            _G[name](unpack(reqFuncOrArgs))
        else
            _G[name](reqFuncOrArgs)
        end
    else
        reqFuncOrArgs(_G[name])
        if not stat.timeout then
            --表示没有实际调用保护函数, 这时回调, 从而保证所有的调用都有回调
            if nextFrame then
                RunOnNextFrame(callback, false, "skip")
            else
                xpcall(function () callback(false, "skip") end, geterrorhandler())
            end
        end
    end
    if stat.timeout then stat.callback = callback end
end

--一个请求已经完成, 调用回调并准备进入interval周期
--该函数在三个地方执行
--1. timeout
--2. mirror event
--3. manual interrupted
--这三个都是异步的, 所以不需要RunOnNextFrame
doneRequest = function(_name, success, cause, ...)
    local stat = stats[_name]
    if stat.callback then
        xpcall(function () stat.callback(success, cause) end, geterrorhandler())
        stat.callback = nil
    end
    stat.timeout = nil
    stat.interval = GetTime() + PROTECT_LIST[_name].interval
end

--/run RequestProtection:Schedule("SetAchievementComparisonUnit", "target", function(success, cause, ...) print(success, cause, ...) end)
--/run RequestProtection:Schedule("SetAchievementComparisonUnit", function(f) if UnitIsVisible("target") then f("target") end end, function(success, cause, ...) print(success, cause, ...) end)
