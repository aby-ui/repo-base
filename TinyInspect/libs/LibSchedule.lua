
---------------------------------
-- 計劃任務庫 Author: M
---------------------------------

local MAJOR, MINOR = "LibSchedule.7000", 1
local lib = LibStub:NewLibrary(MAJOR, MINOR)

if not lib then return end

local frame = CreateFrame("Frame", nil, UIParent)

frame.schedules, frame.timer = {}, 0

frame:SetScript("OnUpdate", function(self, elasped)
    if (self.paused) then return end
    local t = GetTime()
    local item
    for i = #self.schedules, 1, -1 do
        item = self.schedules[i]
        if (item.stopped) then
            tremove(self.schedules, i)
        elseif (t >= item.begined) then
            item.timer = item.timer + elasped
            if (item.timer >= item.elasped) then
                item.timer = 0
                if (t > item.expired) then
                    tremove(self.schedules, i)
                    item.onTimeout(item)
                elseif (item.onExecute(item)) then
                    tremove(self.schedules, i)
                end
            end
        end
    end
    if (#self.schedules == 0) then
        self.paused = true
    end
end)

--Task的字段
local metatable = {
    identity  = '', --唯一签名(必须)
    timer     = 0,  --初始计时点
    elasped   = 1,  --执行的周期
    begined   = 0,  --开始时间点
    expired   = 0,  --过期时间点
    override  = false, --是否覆蓋
    onStart   = function(self) end, --添加后执行
    onTimeout = function(self) end, --超时后执行
    onExecute = function(self) return true end, --定時執行,直到返回true才停止
}

--添加Task
function lib:AddTask(item, override)
    if (override or item.override) then
        for i, v in ipairs(frame.schedules) do
            if (v.identity == item.identity) then
                v.stopped = true
            end
        end
    else
        for i, v in ipairs(frame.schedules) do
            if (v.identity == item.identity) then
                return self
            end
        end
    end
    setmetatable(item, {__index = metatable})
    item.onStart(item)
    tinsert(frame.schedules, item)
    frame.paused = false
    return self
end

--刪除Task
function lib:RemoveTask(identity, useLike)
    for i, v in ipairs(frame.schedules) do
        if (useLike) then
            if (string.find(v.identity,identity)) then
                v.stopped = true
            end
        elseif (v.identity == identity) then
            v.stopped = true
        end
    end
    return self
end

--執行Task
function lib:AwakeTask(identity, useLike)
    for i, v in ipairs(frame.schedules) do
        if (useLike) then
            if (string.find(v.identity,identity) and not v.stopped and v.onExecute(v)) then
                v.stopped = true
            end
        elseif (v.identity == identity and not v.stopped and v.onExecute(v)) then
            v.stopped = true
        end
    end
    return self
end

--查找Task
function lib:SearchTask(identity, useLike)
    local identities = {}
    for i, v in ipairs(frame.schedules) do
        if (useLike) then
            if (string.find(v.identity,identity) and not v.stopped) then
                tinsert(identities, v.identity)
            end
        elseif (v.identity == identity and not v.stopped) then
            tinsert(identities, v.identity)
        end
    end
    return #identities==0 and nil or identities
end
