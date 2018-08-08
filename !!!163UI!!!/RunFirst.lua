local _, U1 = ...

U1PlayerName = UnitName("player")
U1PlayerClass = select(2, UnitClass("player"))

--- 全关插件然后再单独启用控制台时, 恢复之前的状态, 方便全关测试是否插件问题然后恢复
local sum = 0 for i = 1, GetNumAddOns() do sum = sum + GetAddOnEnableState(U1PlayerName,i) end
U1.returnFromDisableAll = sum == 2

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
U1.eventframe = f
--f:SetScript("OnEvent", function(...) print(...) end) -- will be placed in 163UI.lua


--这里是所有要第一时间运行的函数
function normalize(num, min, max)
    return (num < min and min) or (num > max and max) or num;
end

function U1Message(text, r, g, b, chatFrame)
    (chatFrame or DEFAULT_CHAT_FRAME):AddMessage(L["|cffcd1a1c【爱不易】|r- "]..text, r, g, b);
end

local cfNames = {} for i=1, NUM_CHAT_WINDOWS do cfNames[i] = "ChatFrame"..i end
function WithAllChatFrame(func, ...)
    for i=1, NUM_CHAT_WINDOWS do
        local chatFrame = _G[cfNames[i]]
        if chatFrame then func(chatFrame, ...); end
    end
end

--U1.removedAddOns = {"Fizzle", }

--UI163_USER_MODE = 1 --- alwaysRegister=1 and not checkVendor
--UI163_USE_X_CATEGORIES = 1 --- use X-Categories tag


UnitIsTapped = function() end
CLASS_BUTTONS = CLASS_ICON_TCOORDS
CooldownFrame_SetTimer = CooldownFrame_Set

--WithAllChatFrame(function(frame) frame:SetMaxLines(5000) end)

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

local events = {}
_G.DBG_events1 = events
hooksecurefunc("ActionButton_OnEvent", function(self, event)
    events[self] = events[self] or {}
    table.insert(events[self], event)
    if #events[self] > 10 then
        table.remove(events[self], 11)
    end
end)

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