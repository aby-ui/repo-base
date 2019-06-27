--TODO: 应该是InspectReady之后进行间隔保护，在InspectReady之前都可以发起请求
--InspectReady返回unit,guid,应判断unit, 只要unit存在，就肯定能调用
--lib.events:Fire("InspectLess_Next", false, true) 第一个false是观察请求是否ready，第二个true=超时
--lib:IsNotBlocking

local MAJOR, MINOR = "LibInspectLess-1.0", tonumber(("$Rev: 99915 $"):match("(%d+)"))
local after40300 = select(4, GetBuildInfo())>40200 --if DEBUG_MODE then after40300 = nil end

local lib = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end

local AceTimer = LibStub:GetLibrary("AceTimer-3.0")


lib.events = lib.events or  LibStub("CallbackHandler-1.0"):New(lib)
lib.frame = lib.frame or CreateFrame("Frame", MAJOR.."_Frame")

--==========================================================================================
LibInspectLessInterval = 0.8		--use '/run LibInspectLessInterval=3' etc to change.
LibInspectLessTimeout = 1.5 --观察超时的间隔
LibInspectLessDebug = false

SlashCmdList["INSPECTLESS"] = function(msg)
    if not msg or msg=="" then
        DEFAULT_CHAT_FRAME:AddMessage("InspectLess: Interval = "..LibInspectLessInterval, 1, 1, 0)
    elseif strlower(msg)=="debug" then
        LibInspectLessDebug = not LibInspectLessDebug
        DEFAULT_CHAT_FRAME:AddMessage("InspectLess: Debug = "..tostring(LibInspectLessDebug), 1, 1, 0)
    elseif tonumber(msg) and tonumber(msg)>0.1 then
        LibInspectLessInterval = tonumber(msg)
        DEFAULT_CHAT_FRAME:AddMessage("InspectLess: Interval = "..tonumber(msg), 1, 1, 0)
    end
end
SLASH_INSPECTLESS1 = "/inspectless";
SLASH_INSPECTLESS2 = "/lil";
SLASH_INSPECTLESS3 = "/libinspectless";

local waiting = 0 --两次观察之间间隔
local timeout = 0 --观察无返回结果
local BlockingAllForNextManual = false
local ManualCalling = false
local ShowResumeMessage = false
local InspectLessLastGUID = nil  --上次的观察人员，如果上次的观察和目前的不一样，间隔到了将自动观察, 如果一样，应该判断是否READY，如果已经READY了，最好再发一次READY消息
local InspectOtherRealmWarned = false

function lib:debug(msg, r, g, b)
    if LibInspectLessDebug then DEFAULT_CHAT_FRAME:AddMessage(tostring(msg), r or 0.5, g or 0.5, b or 0.5) end
end

--==========================================================================================
local f = lib.frame
f:UnregisterAllEvents()
f:RegisterEvent("ADDON_LOADED");
f:RegisterEvent("INSPECT_READY");
f:SetScript("OnEvent", function(self, event, ...)
    return lib[event](lib, ...)
end)

--用来触发 InspectLess_Next 的Updater, 用来控制观察间隔
f:SetScript("OnUpdate", function(self,elapsed)
    if timeout > 0 then
        timeout = timeout - elapsed
        if timeout <=0 then
            InspectLessLastGUID = nil
            lib.unit = nil
            lib.guid = nil
            if elapsed < LibInspectLessTimeout then --登录的第一个时间很长
                lib:debug("timeout, fire InspectLess_Next");
                lib.events:Fire("InspectLess_Next", false, true)
            end
        end
        --waiting和timeout都是在真正触发NotifyInspect之后设置的，由于timeout比waiting大，所以timeout的时候waiting肯定是0
    end

    if waiting > 0 then
        waiting = waiting - elapsed
        if waiting<=0 and (BlockingAllForNextManual or ShowResumeMessage) then
            --DEFAULT_CHAT_FRAME:AddMessage("InspectLess: "..L["You can now inspect others."], 0.8, 1, 0)
            ShowResumeMessage = false
        end

        if waiting<=0 then
            lib:debug("end waiting")
            local locked = (lib.unit or lib.guid) and not lib.ready
            if locked then
                --DEFAULT_CHAT_FRAME:AddMessage("InspectLess: "..string.format(L["Request receive no response, player '%s' might just logged off. And because the buggy BLIZZARD, you are probably forbidden to inspect until you restart your client."], lib.name), 0.8, 1, 0)
            end
            InspectLessLastGUID = nil
            lib:debug("fire InspectLess_Next");
            lib.events:Fire("InspectLess_Next", lib.ready, false)
        end
    end
end)

function lib:hook(name, func)
    assert(type(_G[name])=="function", "Bad arg1, string function name expected")
    assert(type(func)=="function", "Bad arg2, function expected")

    lib.origins = lib.origins or {}
    lib.hooks = lib.hooks or {}

    if not lib.origins[name] then
        lib.origins[name] = _G[name]
        _G[name] = function(...) return lib.hooks[name](...) end
    end
    lib.hooks[name] = func
end

--Hook and protect the ClearInspectPlayer function
lib:hook("ClearInspectPlayer", function(unit)
--do nothing
end)

--Hook and protect the NotifyInspect function
lib:hook("NotifyInspect", function(unit)
    local pass = false
    if ManualCalling then
        if waiting > 0 then
            BlockingAllForNextManual = true
            lib:debug("manual inspecting blocked.");
        else
            pass = true
        end
    else
        if waiting > 0 then
            --lib:debug("addon inspecting blocked.");
        else
            if not BlockingAllForNextManual then
                InspectLessLastGUID = UnitGUID(unit)
                pass = true
            end
        end
    end

    if pass then
        waiting = LibInspectLessInterval
        lib.fail = false
        lib.ready = false
        lib.done = false
        lib.origins["ClearInspectPlayer"]()
        lib.unit = unit
        lib.name = UnitName(unit)
        lib.guid = UnitGUID(unit) --一直不清
        lib.manual = ManualCalling

        timeout = LibInspectLessTimeout --超时时间
        --print("actual inspect", unit, UnitName(unit))
        lib.origins["NotifyInspect"](unit)	--origin call
        if not after40300 then lib.CheckInspectItems(lib.guid) end --4.2发起请求就可以获取 而4.3会获取到幻化后的

        if ManualCalling then BlockingAllForNextManual = false end

        local unitName = 'not exists'
        if(UnitExists(unit)) then
            local name = UnitName(unit)
            if(name) then unitName = name end
        end
        lib:debug( (ManualCalling and "manual" or "addon").." inspecting done.    "..unitName);
    end
end)

function lib:IsNotBlocking()
    return waiting <=0 and not BlockingAllForNextManual
end
local r={}
local CoreScheduleBucket = CoreScheduleBucket or function(t,o,a,i)
    if not AceTimer then return end
    if r[t]then AceTimer:CancelTimer(r[t])end
    local tt=AceTimer:ScheduleTimer(function(...)r[t]=nil a(...)end, o, i)
    r[t]=tt
    return tt
end
--循环检查玩家的装备是否已经获取到
function lib.CheckInspectItems(guid)
    local unit = lib:FindUnit(guid)
    if unit then
        local done = lib:GetInspectItemLinks(unit)
        if done then
            lib.done = true
            lib:debug("fired ItemReady, "..unit);
            lib.events:Fire("InspectLess_InspectItemReady", unit, lib.guid, lib.ready)
        else
            CoreScheduleBucket("LibInspectLessChecker", 0.1, lib.CheckInspectItems, guid)
        end
    else
        lib.fail = true
        if lib.unit then
            lib:debug("fired ItemFail, "..lib.unit);
            lib.events:Fire("InspectLess_InspectItemFail", lib.unit, lib.guid, lib.ready)
        end
    end
end

function lib:INSPECT_READY(guid)
    timeout = 0
    self.ready = true
    self:debug("fired InspectReady "..guid);
    self.events:Fire("InspectLess_InspectReady", lib:FindUnit(guid), guid, lib.done);
    if after40300 then lib.CheckInspectItems(guid) end --4.3幻化的问题
end

function lib:ADDON_LOADED(addon)
    if addon=="Blizzard_InspectUI" then
        f:UnregisterEvent("ADDON_LOADED");
        lib:hook("InspectPaperDollFrame_SetLevel", function()
            if InspectFrame.unit then
                local _, class = UnitClass(InspectFrame.unit);
                if class and RAID_CLASS_COLORS[class] then
                    lib.origins["InspectPaperDollFrame_SetLevel"]()
                end
            end
        end)

    --[[
        local BlizzardInspectHook = function(name, unit_or_self)
            ManualCalling = true

            local unit = name=="InspectFrame_Show" and unit_or_self or unit_or_self.unit
            lib:debug(name..": "..unit.." last: "..tostring(InspectLessLastGUID));

            if waiting > 0 then
                --block InspectFrame from showing
                if unit and InspectLessLastGUID == UnitGUID(unit) then
                    lib:debug("use last, fail="..tostring(lib.fail), 1, 1, 1)

                    if lib.fail then --last inspect not get all item.
                        if not after40300 or lib.ready then
                            lib.CheckInspectItems(InspectLessLastGUID)
                        end
                    end

                    if name=="InspectFrame_Show" then
                        InspectFrame.unit = unit;
                        InspectSwitchTabs(1);
                        ShowUIPanel(InspectFrame);
                        InspectFrame_UpdateTabs();
                    elseif name=="InspectFrame_UnitChanged" then
                        InspectPaperDollFrame_OnShow(unit_or_self);
                        SetPortraitTexture(InspectFramePortrait, unit);
                        InspectFrameTitleText:SetText(UnitName(unit));
                        InspectFrame_UpdateTabs();
                        if ( InspectPVPFrame:IsShown() ) then
                            InspectPVPFrame_OnShow();
                        end
                    end

                    BlockingAllForNextManual = false
                    InspectLessLastGUID = nil
                else
                    BlockingAllForNextManual = true
                    ShowResumeMessage = true
                    --DEFAULT_CHAT_FRAME:AddMessage("InspectLess: "..L["Too frequently!!"], 1, 0.8, 0)
                end
            else
                lib.origins[name](unit_or_self)
            end
            ManualCalling = false

        end

        lib:hook("InspectFrame_Show", function(unit)
            return BlizzardInspectHook("InspectFrame_Show", unit)
        end)

        lib:hook("InspectFrame_UnitChanged", function(self)
            return BlizzardInspectHook("InspectFrame_UnitChanged", self)
        end)
    --]]
    end
end

function lib:FindUnit(guid)
    --assert(guid, "Here guid should not be nil.")
    if lib.unit and UnitGUID(lib.unit)==guid then
        return lib.unit
    elseif InspectFrame and InspectFrame:IsVisible() and InspectFrame.unit and UnitGUID(InspectFrame.unit)==guid then
        return InspectFrame.unit
    else
        --experimental
        if IsInRaid() then
            for i=1, GetNumGroupMembers() do
                if UnitGUID("raid"..i)==guid then
                    return "raid"..i
                end
            end
        elseif IsInGroup() and not IsInRaid() then
            for i=1, GetNumSubgroupMembers() do
                if UnitGUID("party"..i)==guid then
                    return "party"..i
                end
            end
        else
            if UnitGUID("player")==guid then return "player" end
            if UnitGUID("target")==guid then return "target" end
            if UnitGUID("focus")==guid then return "focus" end
        end
    end
end

function lib:GetInspectItemLinks(unit)
    --GetTexture always return stuff but GetLink is not.
    local done = true
    for i=1, 17 ,1 do
        if GetInventoryItemTexture(unit, i) then
            local link = GetInventoryItemLink(unit, i)
            if not link then
                done = false --do not break, we need to retrieve all links
            else
                local found, _, gem1,gem2,gem3,gem4 = link:find("item:%d+:%d*:(%d*):(%d*):(%d*):(%d*):")
                if found then
                    if gem1~="0" and gem1~="" and not GetItemGem(link, 1) then done = false end
                    if gem2~="0" and gem2~="" and not GetItemGem(link, 2) then done = false end
                    if gem3~="0" and gem3~="" and not GetItemGem(link, 3) then done = false end
                    if gem4~="0" and gem4~="" and not GetItemGem(link, 4) then done = false end
                end
            end
        end
    end
    return done
end

function lib:GetUnit()
    local u = lib.unit
    if u and lib.guid==UnitGUID(u) and UnitIsVisible(u) and UnitIsConnected(u) and CanInspect(u) and UnitClass(u) then
        return u
    end
end

function lib:GetGUID()
    return lib.guid
end

function lib:IsReady()
    return lib.ready
end

function lib:IsDone()
    return lib.done
end

function lib:IsFail()
    return lib.done
end
