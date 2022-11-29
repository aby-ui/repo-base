local _, U1 = ...
U1.start_timestamp = debugprofilestop()
U1.get_timestamp = function() return DEBUG_MODE and format(" (+%.3f)", (debugprofilestop() - U1.start_timestamp)/1000) or "" end

U1_WOW10 = select(4, GetBuildInfo()) >= 100000

U1PlayerName = UnitName("player")
U1PlayerClass = select(2, UnitClass("player"))

DisableAddOn("VEM-Core")
DisableAddOn("DBM-Profiles")
DisableAddOn("DBM-SpellTimers")
DisableAddOn("DBM-RaidLeadTools")
DisableAddOn("DPMCore")
DisableAddOn("DBM-VictorySound")
DisableAddOn("163UI_EncounterLootPlus")

-- 一些常用的变量会被莫名其妙重置的, 必须在VARIABLES_LOADED里设置
local f01 = CreateFrame("Frame")
f01:RegisterEvent("VARIABLES_LOADED")
f01:SetScript("OnEvent", function(self)
    if U1DBG and not U1DBG.bossGuide9 then
        U1DBG.bossGuide9 = true
        if not U1IsAddonEnabled("AbyBossGuide") then
            CoreScheduleTimer(false, 3, U1LoadAddOn, "AbyBossGuide")
        end
    end

    u1debug = DEBUG_MODE and CoreDebug or noop
    if U1DB and U1DB.configs then
        local c = U1DB.configs["163ui_moreoptions/cvar_nameplateMaxDistance"]
        if c == "0" or c == "nil" then
            U1DB.configs["163ui_moreoptions/cvar_nameplateMaxDistance"] = "60"
        end
    end
    local dist = GetCVar("nameplateMaxDistance")
    if not dist or dist == "0" or dist == "nil" or dist == 0 then
        SetCVar("nameplateMaxDistance", 60)
    end
    SetCVar("scriptErrors", DEBUG_MODE and 1 or 0)
    --SetCVar("showQuestTrackingTooltips", 1) --9.0貌似没有这个了
    self:UnregisterAllEvents()
end)
SetCVar("predictedHealth", "1") --9.2 影响团队框架更新速度

--- 全关插件然后再单独启用控制台时, 恢复之前的状态, 方便全关测试是否插件问题然后恢复
local sum = 0 for i = 1, GetNumAddOns() do sum = sum + GetAddOnEnableState(U1PlayerName,i) end
U1.restoreFromDisableAll = sum == 2

---创建一个locale表, 对于["text"]=true的值会返回"text", 同时L["zhCN"]会有值
local localeMetaTable = {__newindex = function(t, k, v) rawset(t, k, v==true and k or v) end}
function NewLocale()
    local loc = GetLocale();
    return setmetatable({[loc]=true}, localeMetaTable);
end

U1.L = NewLocale()
local L = U1.L
U1.CN = GetLocale():sub(1, 2) == "zh"

local f = CreateFrame("Frame") --最先注册
f:RegisterEvent("ADDON_LOADED") --ADDON_LOADED已经可以获取db了
f:RegisterEvent("VARIABLES_LOADED")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_LOGOUT")
--f:RegisterEvent("FIRST_FRAME_RENDERED")
U1.eventframe = f
--f:SetScript("OnEvent", function(...) print(...) end) -- will be placed in 163UI.lua


--这里是所有要第一时间运行的函数
function normalize(num, min, max)
    return (num < min and min) or (num > max and max) or num;
end

function U1Message(text, r, g, b, chatFrame)
    (chatFrame or DEFAULT_CHAT_FRAME):AddMessage(L["|cffcd1a1c【爱不易】|r- "]..text, r, g, b);
end

local allChatFrameFuncs = {}
local function runAllFuncs()
    local frames = {}
    local min_pos = 999999999999
    for _, chatFrameName in pairs(CHAT_FRAMES) do
        local frame = _G[chatFrameName];
        if frame then
            tinsert(frames, frame)
            frame._aby_cf_func_pos = frame._aby_cf_func_pos or 1
            min_pos = min(min_pos, frame._aby_cf_func_pos)
        end
    end
    for i = min_pos, #allChatFrameFuncs do
        local func = allChatFrameFuncs[i]
        local a1,a2,a3,a4,a5,a6,a7,a8 = unpack(func[3], 1, func[2])
        for _, frame in ipairs(frames) do
            if frame._aby_cf_func_pos <= i then
                (func[1])(frame, a1,a2,a3,a4,a5,a6,a7,a8)
                frame._aby_cf_func_pos = i + 1
            end
        end
    end
end
function WithAllAndFutureChatFrames(func, ...)
    if not func then return end
    local args = {}
    local args_len = select("#", ...)
    for i = 1, args_len do
        args[i] = select(i, ...)
    end
    local num = #allChatFrameFuncs + 1
    allChatFrameFuncs[#allChatFrameFuncs + 1] = { func, args_len, args}
    runAllFuncs()
end
hooksecurefunc("FCF_OpenTemporaryWindow", function()
    runAllFuncs()
end)

function WithAllChatFrameOnce(func, ...)
    for _, chatFrameName in pairs(CHAT_FRAMES) do
        local frame = _G[chatFrameName];
        if frame then func(frame, ...) end
    end
end

function WithAllChatFrameCheckLoading(loading, func, ...)
    if loading then
        return WithAllAndFutureChatFrames(func, ...)
    else
        return WithAllChatFrameOnce(func, ...)
    end
end

-- old addons's sound config is changed to number, but still use PlaySoundFile API
local playSoundFileOrigin = PlaySoundFile
PlaySoundFile = function(file, channel, ...)
    if not file then return end
    if type(file) == "number" and file < 500000 then --bigwigs 569200 只能用 PlaySoundFile
        return PlaySound(file, channel, false) --soundKitID [, channel, forceNoDuplicates, runFinishCallback]
    else
        return playSoundFileOrigin(file, channel, ...)
    end
end

--U1.removedAddOns = {"Fizzle", }

--UI163_USER_MODE = 1 --- alwaysRegister=1 and not checkVendor
--UI163_USE_X_CATEGORIES = 1 --- use X-Categories tag

--WithAllAndFutureChatFrames(function(frame) frame:SetMaxLines(5000) end)

if not oisv then return end

--hooksecurefunc("ActionBarActionEventsFrame_RegisterFrame", function(frame)
--    if frame == hslot12dftdst15 then print(debugstack()) end
--end)
--
--hooksecurefunc("ActionButton_Update", function(self)
--    if not issecurevariable(self, "feedback_action") then
--        print("ActionButtonUpdate Taint", self:GetName())
--        oisv(self)
--    end
--end)

local function checkActionBarButtonEventsFrame(test)
    for k, frame in pairs(ActionBarButtonEventsFrame.frames) do
        if frame == test then break end
        print("----- oisv", frame:GetName(), "----")
        oisv(frame)
    end
end

local happened = false
hooksecurefunc("StartChargeCooldown", function(self)
    if happened then return end
    if self:GetName() and issecurevariable(self:GetName()) and not issecurevariable(self, "chargeCooldown") then
        happened = true
        print("StartChargeCooldown Taint", self:GetName(), debugstack())
        print("============ oisv =============")
        oisv(self)
        print("============ events =============")
        dump(events[self])
        checkActionBarButtonEventsFrame(self)
    end
end)

--CreateFrame(.., "ActionBarButtonTemplate") -> ActionButton_OnLoad -> SetAttribute -> ActionButton_UpdateAction -> ActionButton_Update -> ActionBarActionEventsFrame_RegisterFrame
--