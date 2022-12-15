local addonName = ...
--[[------------------------------------------------------------
默认银行界面打开全部银行背包
---------------------------------------------------------------]]
U1PLUG["OpenBags"] = function()
    CoreOnEvent("BANKFRAME_OPENED", function()
        if BankFrame:IsVisible() then
            for i = NUM_TOTAL_EQUIPPED_BAG_SLOTS+1, (NUM_TOTAL_EQUIPPED_BAG_SLOTS + NUM_BANKBAGSLOTS) do
                OpenBag(i)
            end
        end
    end)
end

--[[------------------------------------------------------------
reload之后记住上次打开的天赋面板, 引起污染，所以算了
CoreDependCall("Blizzard_TalentUI", function()
    hooksecurefunc("PlayerTalentTab_OnClick", function(self, button)
        if U1DB and button == "LeftButton" then U1DB.lastTalentTab = self:GetID() end
    end)
    local first = true
    hooksecurefunc("PlayerTalentFrame_Toggle", function()
        if not first then return end
        first = false
        if U1DB and U1DB.lastTalentTab then
            local tab = _G["PlayerTalentFrameTab" .. U1DB.lastTalentTab]
            return tab and tab:Click()
        end
    end)
end)
---------------------------------------------------------------]]

--[[------------------------------------------------------------
双击空格跳过动画
---------------------------------------------------------------]]
do
    local _f = CreateFrame("Frame")
    _f:SetFrameStrata("LOW")
    _f:Show()
    _f:EnableKeyboard(true)
    _f:SetPropagateKeyboardInput(true);
    _f:SetScript("OnKeyDown", function(self, event, ...)
        if event == "SPACE" then
            if self._lastSpace and GetTime() - self._lastSpace < 0.25 then
                self._lastSpace = nil
            else
                self._lastSpace = GetTime()
                return
            end
            -- 处理双击空格情况
            if TalkingHeadFrame and TalkingHeadFrame.MainFrame and TalkingHeadFrame.MainFrame.CloseButton then
                if TalkingHeadFrame.MainFrame.CloseButton:IsVisible() then
                    TalkingHeadFrame.MainFrame.CloseButton:Click()
                end
            end
            if GossipFrame:IsShown() then
                -- Stop if NPC has quests or quest turn-ins
                if C_GossipInfo.GetNumAvailableQuests() > 0 or C_GossipInfo.GetNumActiveQuests() > 0 then return end
                local options = C_GossipInfo.GetOptions()
                if #options == 1 then
                    self._count = (self._count or 0) + 1
                    if self._count <= 2 then U1Message("你通过双击空格选择了唯一对话选项,这个小功能暂时没有开关") end
                    C_GossipInfo.SelectOption(options[1].gossipOptionID)
                end
            end
            -- RareScanner
            if scanner_button and scanner_button:IsShown() and not InCombatLockdown() then
                scanner_button:Hide()
            end
        end
    end)

    _G["U1Toggle_SkipTalkingHead"] = function(enable)
        if enable then
            _f:Show() --为了双击空格的其他功能, 始终显示
            UIParent:UnregisterEvent("TALKINGHEAD_REQUESTED");
            if TalkingHeadFrame then TalkingHeadFrame:UnregisterEvent("TALKINGHEAD_REQUESTED"); end
        else
            _f:Show();
            if TalkingHeadFrame then TalkingHeadFrame:RegisterEvent("TALKINGHEAD_REQUESTED"); else UIParent:RegisterEvent("TALKINGHEAD_REQUESTED"); end
        end
    end
end

--[[------------------------------------------------------------
ctrl点击游戏菜单按钮回收内存，无选项
---------------------------------------------------------------]]
U1PLUG["GameMenuGC"] = function()
    local gc = function()
        UpdateAddOnMemoryUsage();
        local beforeMem = 0;
        for i = 1, GetNumAddOns(), 1 do
            local mem = GetAddOnMemoryUsage(i);
            beforeMem = beforeMem + mem;
        end
        local beforeLua = collectgarbage("count")
        collectgarbage("collect")
        UpdateAddOnMemoryUsage();
        local afterMem = 0;
        for i = 1, GetNumAddOns(), 1 do
            local mem = GetAddOnMemoryUsage(i);
            afterMem = afterMem + mem;
        end
        local afterLua = collectgarbage("count")
        U1Message(format("内存已回收，插件占用：%.1fM -> %.1fM, LUA占用：%.1fM -> %.1fM", beforeMem / 1024, afterMem / 1024, beforeLua / 1024, afterLua / 1024))
    end
    MainMenuMicroButton:HookScript("OnClick", function()
        if IsControlKeyDown() then
            if GameMenuFrame:IsVisible() then HideUIPanel(GameMenuFrame) end
            CoreScheduleBucket("gc", 0.2, gc)
        end
    end)
end
U1PLUG["GameMenuGC"]() U1PLUG["GameMenuGC"] = nil

--[[------------------------------------------------------------
/align 显示网格
---------------------------------------------------------------]]
do
    SLASH_EALIGN_UPDATED1 = "/align"
    SLASH_EALIGN_UPDATED2 = "/wangge"
    local DEFAULT_SQUARE = 30
    local f, square
    SlashCmdList["EALIGN_UPDATED"] = function(msg)
        square = tonumber(msg) or DEFAULT_SQUARE
        if f and f:IsVisible() then
            f:Hide()
        else
            if not f then
              f = CreateFrame('Frame', "ALIGN163FRAME", UIParent)
              f:SetAllPoints(UIParent)
              f.verticals = {}
              f.horizons = {}
            end
            f:Show()

            for i=1, GetScreenHeight()/square do
              local t = f.verticals[i]
              if not t then
                t = f:CreateTexture(nil, 'BACKGROUND', nil, -8)
                f.verticals[i] = t
              end
              t:Show()
              t:SetColorTexture(i == 1 and 1 or 0, 0, 0, 0.5)
              t:SetPoint('TOPLEFT', f, 'LEFT', 0, math.floor(i/2)*(1-i%2*2)*square-1)
              t:SetPoint('BOTTOMRIGHT', f, 'RIGHT', 0, math.floor(i/2)*(1-i%2*2)*square)
            end
            for i=math.floor(GetScreenHeight()/square)+1, #f.verticals do f.verticals[i]:Hide() end

            for i=1, GetScreenWidth()/square do
              local t = f.horizons[i]
              if not t then
                t = f:CreateTexture(nil, 'BACKGROUND', nil, -8)
                f.horizons[i] = t
              end
              t:Show()
              t:SetColorTexture(i == 1 and 1 or 0, 0, 0, 0.5)
              t:SetPoint('TOPLEFT', f, 'TOP', math.floor(i/2)*(1-i%2*2)*square-1, 0)
              t:SetPoint('BOTTOMRIGHT', f, 'BOTTOM', math.floor(i/2)*(1-i%2*2)*square, 0)
            end
            for i=math.floor(GetScreenWidth()/square)+1, #f.horizons do f.horizons[i]:Hide() end
        end
    end

    --[[
    hooksecurefunc(getmetatable(CreateFrame("Frame")).__index, "StopMovingOrSizing", function(self)
        if Align163StopMovingOrSizing then Align163StopMovingOrSizing(self) end
    end)
    Align163StopMovingOrSizing = function(self)
        --print(self:GetNumPoints(), select(2, self:GetPoint()))
        if self:GetNumPoints() ~= 1 then return end
        local p1, rel, p2, x, y = self:GetPoint()
        if rel ~= nil and rel ~= UIParent then return end
        print(p1, p2, x, y, self:GetLeft())
        if
    end
    --]]
end

--[[------------------------------------------------------------
公会新闻手工加载
---------------------------------------------------------------]]
U1PLUG["FixBlizGuild"] = function()
    U1QueryGuildNews = QueryGuildNews
    QueryGuildNews = function() end
    local createLoadButton = function(parent)
        local btn = WW:Button("$parentGetNewsButton", parent, "UIMenuButtonStretchTemplate"):SetTextFont(ChatFontNormal, 13, ""):SetAlpha(0.8):SetText("加载新闻"):Size(100, 30):CENTER(0, 0):AddFrameLevel(3, parent):SetScript("OnClick", function(self)
            U1QueryGuildNews()
            QueryGuildNews = U1QueryGuildNews
            --self:Hide()
            self:ClearAllPoints() self:SetPoint("TOPRIGHT", -1, 33) self:SetSize(80, 30) self:SetText("加载新闻")
        end):un()
        CoreUIEnableTooltip(btn, '爱不易', '手工加载公会新闻，减少卡顿，可以在"爱不易设置-小功能集合"里关闭此功能')
    end
    CoreDependCall("Blizzard_GuildUI", function() createLoadButton(GuildNewsFrame) end)
    CoreDependCall("Blizzard_Communities", function() createLoadButton(CommunitiesFrameGuildDetailsFrameNews) end)
end

--[[------------------------------------------------------------
点击打开成就面板
---------------------------------------------------------------]]
local newSetItemRef = function(link, text, button, ...)
    local _, _, id = link:find("achievement:([0-9]+):")
    if id and button == "RightButton" then
        if ( not AchievementFrame ) then
            AchievementFrame_LoadUI();
        end
        if ( not AchievementFrame:IsShown() ) then
            AchievementFrame_ToggleAchievementFrame();
        end
        AchievementFrame_SelectAchievement(tonumber(id));
    end
end
hooksecurefunc("SetItemRef", newSetItemRef);

--[[------------------------------------------------------------
始终显示特殊能量条的文字
---------------------------------------------------------------]]
do
    local function forceShowStatusFrame(self, barID)
        if self ~= PlayerPowerBarAlt then return end
        if not U1GetCfgValue(addonName, 'AlwaysShowAltBarText') then return end
        --barID = barID or UnitPowerBarID(self.unit)
        --print("barID", barID)
        PlayerPowerBarAltStatusFrameText:GetParent():Show()
    end
    hooksecurefunc("UnitPowerBarAlt_SetUp", forceShowStatusFrame)
    hooksecurefunc("UnitPowerBarAlt_OnLeave", function(self) forceShowStatusFrame(self) end)
end

--[[------------------------------------------------------------
9.0导航无限距离
---------------------------------------------------------------]]
U1PLUG["UnlimitedMapPinDistance"] = function()
CoreDependCall("Blizzard_QuestNavigation", function()
    --from UnlimitedMapPinDistance
    if SuperTrackedFrame and SuperTrackedFrame.GetTargetAlphaBaseValue then
        SuperTrackedFrame.abyGetTargetAlphaBaseValue = SuperTrackedFrame.GetTargetAlphaBaseValue
        SuperTrackedFrame.GetTargetAlphaBaseValue = function(self, ...)
            if not U1GetCfgValue(addonName, "UnlimitedMapPinDistance") then
                return SuperTrackedFrame.abyGetTargetAlphaBaseValue(self, ...)
            end

            if C_SuperTrack.IsSuperTrackingUserWaypoint() then
                local distance = C_Navigation.GetDistance()
                local FAR,NEAR=80,20
                if distance > 1000 then
                    return self.isClamped and 0.6 or 0.6

                elseif distance > 140 then
                    return self.isClamped and 1 or 0.6

                else
                    if self.isClamped then return 1 end
                    if distance <= NEAR then
                        return 0.4
                    else
                        return distance>FAR and 1 or (distance-NEAR)*0.6/(FAR-NEAR)+0.4
                    end
                end
            else
                return SuperTrackedFrame:abyGetTargetAlphaBaseValue()
            end
        end

        hooksecurefunc(SuperTrackedFrame, "UpdateDistanceText", function(self)
            if self.DistanceText:IsShown() then
                local distance = C_Navigation.GetDistance();
                if distance >= 1000 then
                    self.DistanceText:SetText(IN_GAME_NAVIGATION_RANGE:format(AbbreviateNumbers163(Round(distance))))
                end
            end
        end)
    end

    --[[ --from AutoTrackMapPin
    CoreOnEvent("USER_WAYPOINT_UPDATED", function()
        if C_Map.HasUserWaypoint() == true then
           C_Timer.After(0, function()
               C_SuperTrack.SetSuperTrackedUserWaypoint(true)
           end)
        end
    end)
    --]]
end)
end


--[[------------------------------------------------------------
9.1 临时处理地图卡顿
U1PLUG["FixMapGlitch"] = function()
    if C_TaskQuest.GetQuestsForPlayerByMapID then
        U1Message("暴雪9.1界面问题导致地图卡顿，已临时处理，如果遇到问题可以在小功能集合中关闭。详情参见 https://bbs.nga.cn/read.php?tid=27466594")
        GetQuestsForPlayerByMapID_Origin = GetQuestsForPlayerByMapID_Origin or C_TaskQuest.GetQuestsForPlayerByMapID
        local lastTime = {}
        local lastResult = {}
        C_TaskQuest.GetQuestsForPlayerByMapID = function(mapId)
            if GetTime() - (lastTime[mapId] or 0) <= 1.5 then
                return lastResult[mapId]
            else
                local r = GetQuestsForPlayerByMapID_Origin(mapId)
                lastResult[mapId] = r
                lastTime[mapId] = GetTime()
                return r
            end
        end
    end
end
    {
        var = "FixMapGlitch", text = U1_NEW_ICON.."临时解决9.1刻希亚地图卡顿", default = true, callback = load, tip = "说明`暴雪9.1客户端问题导致开启世界地图卡顿，已临时通过技术手段改善，但是可能会带来插件被阻止等其他问题，如果不需要此功能请关闭。``详情参见 https://bbs.nga.cn/read.php?tid=27466594``感谢oyg123的研究"
    },
---------------------------------------------------------------]]

-- 元尊精粹拾取
CoreOnEvent("CHAT_MSG_LOOT", function(event, msg)
    if msg and LegendaryItemAlertSystem then
        local pattern = "^" .. string.format(LOOT_ITEM_SELF, "(.+)") .. "$" --"你获得了物品：%s。"
        local _, _, link = msg:find(pattern)
        local itemId = link and select(3, link:find("\124Hitem:(%d+):"))
        itemId = itemId and tonumber(itemId)
        if itemId == 187707 then
            LegendaryItemAlertSystem:AddAlert(link)
        end
    end
end)

do
    local picked, hooking
    hooksecurefunc("PickupAction", function(action, ignoreActionRemoval)
        if hooking then return end
        if not ignoreActionRemoval then
            picked = action
        end
    end)
    hooksecurefunc("PlaceAction", function(action)
        if hooking then return end
        local last = picked
        picked = nil
        if InCombatLockdown() then return end
        local keys = (IsControlKeyDown() and 1 or 0) + (IsAltKeyDown() and 1 or 0) + (IsShiftKeyDown() and 1 or 0)
        if keys >= 2 then
            if last and GetActionInfo(last) == nil then
                if GetCursorInfo() then
                    for i = 180, 145, -1 do
                        if GetActionInfo(i) == nil then
                            hooking = 1
                            PlaceAction(i)
                            PickupAction(action, true)
                            PlaceAction(last)
                            PickupAction(i)
                            hooking = nil
                            U1Message("放下技能时按住多个功能键可保留原来的技能栏")
                            return
                        end
                    end
                else
                    PickupAction(action, true)
                    PlaceAction(last)
                    U1Message("放下技能时按住多个功能键可保留原来的技能栏")
                    return
                end
            end
        end
    end)
end


--[[------------------------------------------------------------
10.0忠诚之钥
---------------------------------------------------------------]]
do
    local items = { [191251]=30, [193201]=3, }
    local pattern = "^" .. string.format(LOOT_ITEM_SELF, "(.+)") .. "$" --"你获得了战利品：%s。"
    CoreOnEvent("CHAT_MSG_LOOT", function(event, msg)
        local _, _, link = msg:find(pattern)
        local itemId = link and select(3, link:find("\124Hitem:(%d+):"))
        itemId = itemId and tonumber(itemId)
        if itemId and items[itemId] then
            CoreScheduleBucket("AbyUI_10.0_LOYALKEY", 0.5, function()
                local found = {}
                for container=BACKPACK_CONTAINER, NUM_BAG_SLOTS do
                    local slots = C_Container.GetContainerNumSlots(container)
                    for slot=1, slots do
                        local info = C_Container.GetContainerItemInfo(container, slot)
                        if info and items[info.itemID] then
                            found[info.itemID] = (found[info.itemID] or 0) + (info.stackCount or 1)
                        end
                    end
                end
                local s = "包内碎片:"
                for k, v in pairs(items) do
                    local _, link = GetItemInfo(k)
                    if link then s = s .. format(" %s:|cff%s%d|r/%d", link, found[k] and found[k] >= v and "00ff00" or "ff0000", found[k] or 0, v) end
                end
                U1Message(s)
            end)
        end
    end)
end

--[[------------------------------------------------------------
在声望里显示一些特殊的名称，没找到API获取只能写死
---------------------------------------------------------------]]
do
    --https://www.wowhead.com/cn/faction=2544
    local reactionNames = {
        [2517] = {"熟人","同好","盟友","龙牙","朋友","挚友"},
        [2518] = {"熟人","同好","盟友","龙牙","朋友","挚友"},
        [2544] = {"中立","偏爱","尊重","重视","崇尚"},
        [2550] = {"空","低","中","高","最大"},
    }
    CoreUIHookPoolCollection(ReputationFrame.ScrollBox.view.poolCollection, function(frame, frameType, template)
        if template == "ReputationBarTemplate" then
            frame:HookScript("OnEnter", function(self)
                if GameTooltip:IsVisible() then
                    GameTooltip_AddBlankLineToTooltip(GameTooltip)
                    local names = reactionNames[self.factionID]
                    if names then
                        local r = C_GossipInfo.GetFriendshipReputationRanks(self.factionID)
                        if r and r.currentLevel and names[r.currentLevel] then
                            local old = names[r.currentLevel]
                            names[r.currentLevel] = GREEN_FONT_COLOR:WrapTextInColorCode(old)
                            GameTooltip:AddLine(table.concat(names, "/"), .5, .5, .5, 1)
                            names[r.currentLevel] = old
                        end
                    end
                end
                GameTooltip:AddLine("声望ID：" .. self.factionID)
                GameTooltip:Show()
            end)
        end
    end)
end

U1PLUG["CosHelper"] = function()
    --[[------------------------------------------------------------
    群星庭院助手
    作者 bitingsock https://mods.curse.com/addons/wow/256918-court-of-stars-helper
    ---------------------------------------------------------------]]
    local npccheck = {}
    local NoMore = false
    local tarIndex = 1
    local function CoShelper(tooltip)
        if NoMore then
            if IsShiftKeyDown() ~= true then
                NoMore = false
            end
            return
        end
        local _,unit = tooltip:GetUnit()
        if unit == nil then return; end;
        local mapid,_ = C_Map.GetBestMapForUnit("player")
        if mapid == 761 and UnitGUID(unit) then
            local npcid = string.sub(UnitGUID(unit),-17,-12)
            local line = ""
            if npcid == "105117" then line = "炼金,潜行者 [下毒]" --Flask of the Solemn Night
            elseif npcid == "105157" then line = "工程,地精,侏儒 [关闭构造体]" --Arcane Power Conduit
            elseif npcid == "106110" then line = "萨满,剥皮,铭文 [移动速度]" --Waterlogged Scroll
            elseif npcid == "105160" then line = "恶魔猎手,术士,牧师 [暴击]" --Fel Orb
            elseif npcid == "105340" then line = "德鲁伊,采药 [急速]" --Umbral Bloom
            elseif npcid == "106018" then line = "盗贼,战士,制皮 [引小BOSS]" --Bazaar Goods
            elseif npcid == "106112" then line = "治疗,裁缝,急救 [引小BOSS]" --Wounded Nightborne Civilian
            elseif npcid == "106113" then line = "珠宝,采矿 [引小BOSS]" --Lifesized Nightborne Statue
            elseif npcid == "105831" then line = "圣骑,牧师 [减伤]" --Infernal Tome
            elseif npcid == "105249" then line = "烹饪800,熊猫人 [提升血量]" --Nightshade Refreshments
            elseif npcid == "105215" then line = "猎人,锻造 [引小BOSS并直接杀死]" --Discarded Junk
            elseif npcid == "106024" then line = "法师,附魔,精灵 [增加伤害]" --Magical Lantern
            elseif npcid == "106108" then line = "死骑,武僧 [回复能力]" -- Starlight Rose Brew
            else return
            end
            tooltip:AddLine("爱不易: "..line, 255/255, 106/255, 0/255, true)
            if npccheck[npcid] == nil then
                npccheck[npcid] = true
            end
            if npccheck[npcid] or IsShiftKeyDown() then
                SendChatMessage("【爱不易】"..GetUnitName(unit)..": "..line ,"PARTY" ,nil ,"1");
                SetRaidTarget(unit, tarIndex)
                tarIndex=tarIndex+1
                if tarIndex == 9 then tarIndex = 1 end;
                npccheck[npcid] = false
                NoMore = true
            end
        end
    end
    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, CoShelper)
    CoreOnEvent("CHALLENGE_MODE_START", function() table.wipe(npccheck) NoMore = false end)
end