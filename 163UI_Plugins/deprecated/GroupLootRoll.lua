--[[------------------------------------------------------------
Roll点增强, 9K
---------------------------------------------------------------]]
function U1GroupLootRoll()
    local rolls = {}
    local f = CreateFrame("Frame")
    CoreDispatchEvent(f)
    f:RegisterEvent("START_LOOT_ROLL")
    f:RegisterEvent("CHAT_MSG_LOOT")
    f:RegisterEvent("CANCEL_LOOT_ROLL")
    --f:RegisterEvent("PLAYER_LOGIN")
    --f:RegisterEvent("PLAYER_LOGOUT")

    local rollpairs = {
        [LOOT_ROLL_PASSED_AUTO:gsub("%%s", "(.+)")]  = "pass",
        [LOOT_ROLL_PASSED_AUTO_FEMALE:gsub("%%s", "(.+)")]  = "pass",
        [LOOT_ROLL_PASSED:gsub("%%s", "(.+)")] = "pass",
        [LOOT_ROLL_GREED:gsub("%%s", "(.+)")] = "greed",
        [LOOT_ROLL_NEED:gsub("%%s", "(.+)")] = "need",
        [LOOT_ROLL_DISENCHANT:gsub("%%s", "(.+)")] = "disenchant",
    }

    local function ParseRollChoice(msg)
        for i,v in pairs(rollpairs) do
            local _, _, playername, itemname = string.find(msg, i)
            if playername and itemname and playername ~= "所有人" then return playername, itemname, v end
        end
    end

    local function UpdateRollNum()
        for i=1, NUM_GROUP_LOOT_FRAMES do
            local lf = _G["GroupLootFrame"..i];
            if lf:IsVisible() then
                for k, rolltype in pairs(rollpairs) do
                    local typeTable = lf.rollID and rolls[lf.rollID] and rolls[lf.rollID][rolltype]
                    lf["num_"..rolltype]:SetText(typeTable and #typeTable or "")
                end
            end
        end
    end

--[[ --no use since 5.0
    function f:PLAYER_LOGIN()
        f.showLootSpam = GetCVar("showLootSpam")
        SetCVar("showLootSpam", "1")
        if InterfaceOptionsDisplayPanelDetailedLootInfo then
            InterfaceOptionsDisplayPanelDetailedLootInfo:Disable()
            InterfaceOptionsDisplayPanelDetailedLootInfo:SetMotionScriptsWhileDisabled(true)
            InterfaceOptionsDisplayPanelDetailedLootInfo:SetScript("OnEnter", function(self)
                self.tooltipText = "\"ROLL点界面增强\"功能需要您始终开启此选项。\n如果您一定要关闭此设置，请先关闭\"有爱控制台-爱不易设置-启用ROLL点界面增强\"功能。"
                CoreUIShowTooltip(self);
            end)
        end
        hooksecurefunc("SetCVar", function(name, value) if name=="showLootSpam" then f.showLootSpam = value end end)
    end
    function f:PLAYER_LOGOUT()
        if f.showLootSpam then
            SetCVar("showLootSpam", f.showLootSpam)
        end
    end
]]

    function f:CHAT_MSG_LOOT(event, msg)
        print(event, msg)
        local playername, itemname, rolltype = ParseRollChoice(msg)
        if playername and itemname and rolltype then
            for i=1, NUM_GROUP_LOOT_FRAMES do
                local lf = _G["GroupLootFrame"..i];
                if lf.rollID and rolls[lf.rollID] and lf:IsVisible() and GetLootRollItemLink(lf.rollID)==itemname then
                    local _rolls = rolls[lf.rollID]
                    _rolls[playername] = rolltype
                    _rolls[rolltype] = _rolls[rolltype] or {}
                    tinsertdata(_rolls[rolltype], playername)
                    lf["num_"..rolltype]:SetText(#_rolls[rolltype])
                end
            end
        end
    end
    function f:START_LOOT_ROLL(event, rollID)
        rolls[rollID] = {}
        UpdateRollNum()
    end
    function f:CANCEL_LOOT_ROLL(event, rollID)
        rolls[rollID] = nil
        UpdateRollNum()
    end

    local function createRollNumText(lootFrame, rollType, button, x, y)
        lootFrame["num_"..rollType] = WW(button):CreateFontString(nil, "OVERLAY", "ChatFontNormal"):SetJustifyH("RIGHT"):TR(button,"TOPLEFT",x,y):SetTextColor(0,1,0):un()
        button:HookScript("OnEnter", function(self)
            if lootFrame.rollID then
                local _rolls = rolls[lootFrame.rollID] and rolls[lootFrame.rollID][rollType]
                if _rolls and #_rolls > 0 then
                    GameTooltip:AddLine("已选择此项的玩家：")
                    for _, v in ipairs(_rolls) do
                        local _, class = UnitClass(v)
                        class = class and RAID_CLASS_COLORS[class]
                        GameTooltip:AddLine(v, class and class.r, class and class.g, class and class.b)
                    end
                else
                    GameTooltip:AddLine("尚无选择此项的玩家")
                end
                GameTooltip:Show()
            end
        end)
    end
    for i=1, NUM_GROUP_LOOT_FRAMES do
        local frame = _G["GroupLootFrame"..i];
        createRollNumText(frame, "need", frame.NeedButton, 6, 2);
        createRollNumText(frame, "pass", frame.PassButton, 2, -10);
        createRollNumText(frame, "greed", frame.GreedButton, 8, 4.5);
        createRollNumText(frame, "disenchant", frame.DisenchantButton, 8, 1);
    end
end
