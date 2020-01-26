local addonName = ...
--[[------------------------------------------------------------
默认银行界面打开全部银行背包
---------------------------------------------------------------]]
U1PLUG["OpenBags"] = function()
    CoreOnEvent("BANKFRAME_OPENED", function()
        if BankFrame:IsVisible() then
            for i = NUM_BAG_SLOTS+1, (NUM_BAG_SLOTS + NUM_BANKBAGSLOTS) do
                OpenBag(i)
            end
        end
    end)
end

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
            if TalkingHeadFrame and TalkingHeadFrame.MainFrame and TalkingHeadFrame.MainFrame.CloseButton then
                if TalkingHeadFrame.MainFrame.CloseButton:IsVisible() then
                    if self._lastSpace and GetTime() - self._lastSpace < 0.33 then
                        TalkingHeadFrame.MainFrame.CloseButton:Click()
                    else
                        self._lastSpace = GetTime()
                        return
                    end
                end
            end
        end
        self._lastSpace = nil
    end)
    _G["U1Toggle_SkipTalkingHead"] = function(enable)
        if enable then
            _f:Hide()
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
	local mapid,_ = C_Map.GetBestMapForUnit("player")
	local _,unit = tooltip:GetUnit()
	if unit == nil then return; end;
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
GameTooltip:HookScript("OnTooltipSetUnit", CoShelper)

--[[------------------------------------------------------------
转团提醒
---------------------------------------------------------------]]
function U1IsDoingWorldQuest()
    if not WORLD_QUEST_TRACKER_MODULE or not WORLD_QUEST_TRACKER_MODULE.usedBlocks then return end
    local count = 0
    for k,v in pairs(WORLD_QUEST_TRACKER_MODULE.usedBlocks) do
        count = count + 1
    end
    if count > GetNumWorldQuestWatches() then
        return true
    end
end

--[[
CoreOnEvent("CHAT_MSG_SYSTEM", function(event, msg)
    if msg == ERR_PARTY_CONVERTED_TO_RAID and not IsInInstance() and U1IsDoingWorldQuest() then
        if DBM and not U1DBMAlert then
            U1DBMAlert = DBM:NewMod("U1DBMAlert")
            DBM:GetModLocalization("U1DBMAlert"):SetGeneralLocalization{ name = "爱不易" }
            U1DBMAlert.warn = U1DBMAlert:NewSpecialWarning("%s") --:NewAnnounce("%s", 1, "Interface\\Icons\\Spell_Nature_WispSplode")
        end
        local leader
        for i=1, 40 do
            local unit = "raid" .. i
            if UnitIsGroupLeader(unit) then
                if UnitIsUnit(unit, "player") then
                    leader = 0
                else
                    local name, server = UnitName(unit)
                    server = server ~= "" and server or GetRealmName()
                    leader = name .. "-" .. server
                end
            end
        end
        if leader and leader ~= 0 then
            if U1DBMAlert then
                U1DBMAlert.warn:Show(ERR_PARTY_CONVERTED_TO_RAID)
                if leader then U1DBMAlert.warn:Show("团长：" .. leader) end
            else
                UIErrorsFrame:AddMessage("团长：" .. leader, 1, 0.5, 0)
                UIErrorsFrame:AddMessage(ERR_PARTY_CONVERTED_TO_RAID, 1, 0.5, 0)
            end
            SendChatMessage("【爱不易】转团提醒，团长：" .. leader, "RAID")
        end
    end
end)
--]]

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
大米赛季光辉事迹
---------------------------------------------------------------]]
CoreDependCall("Blizzard_ChallengesUI", function()
    -- local aID10, aID15 = 13780, 13781 --s2: 13448, 13449 --s1: 13079, 13080
    -- local crits, numCrits = {}, GetAchievementNumCriteria(aID10)
    hooksecurefunc("ChallengesFrame_Update", function(self)
        --[[
        table.wipe(crits)
        local ar10 = select(4, GetAchievementInfo(aID10))
        local ar15 = select(4, GetAchievementInfo(aID15))
        for i=1, numCrits do
            local name, _, _, complete = GetAchievementCriteriaInfo(aID15, i)
            if complete == 1 then
                crits[name] = 15
            else
                name, _, _, complete = GetAchievementCriteriaInfo(aID10, i)
                if complete == 1 then crits[name] = 10 end
            end
        end
        --]]

        for i, icon in pairs(ChallengesFrame.DungeonIcons) do
            --local name = C_ChallengeMode.GetMapUIInfo(icon.mapID)
            if not icon.tex then
                WW(icon):CreateTexture():SetSize(24,24):BOTTOM(0, 3):Key("tex"):up():un()
                SetOrHookScript(icon, "OnEnter", function()
                    GameTooltip_AddBlankLineToTooltip(GameTooltip);
                    GameTooltip:AddLine("爱不易提供：")
                    GameTooltip:AddLine("\124TInterface/Minimap/ObjectIconsAtlas:16:16:0:0:1024:512:577:609:443:475\124t 已限时10层")
                    GameTooltip:AddLine("\124TInterface/Minimap/ObjectIconsAtlas:16:16:0:0:1024:512:577:609:477:509\124t 已限时15层")
                    GameTooltip:Show()
                end)
            end
            icon.tex:Show()
            local inTimeInfo, overtimeInfo = C_MythicPlus.GetSeasonBestForMap(icon.mapID);
            if inTimeInfo then
                if inTimeInfo.level >= 15 then
                    icon.tex:SetAtlas("VignetteKillElite")
                elseif inTimeInfo.level >= 10 then
                    icon.tex:SetAtlas("VignetteKill")
                else
                    icon.tex:Hide()
                end
            else
                icon.tex:Hide()
            end
        end
    end)
    --ChallengesFrame_Update(ChallengesFrame)
end)

--[[------------------------------------------------------------
丰灵头
---------------------------------------------------------------]]
do
    local items = {166796, 166798, 166797, 166799, 166800, 166801 } for i, v in ipairs(items) do items[v] = true end
    local pattern = "^" .. string.format(LOOT_ITEM_SELF, "(.+)") .. "$" --"你获得了物品：%s。"
    CoreOnEvent("CHAT_MSG_LOOT", function(event, msg)
        local _, _, link = msg:find(pattern)
        local itemId = link and select(3, link:find("\124Hitem:(%d+):"))
        itemId = itemId and tonumber(itemId)
        if itemId and items[itemId] then
            for i=1, 120 do
                local type, id = GetActionInfo(i)
                if type == "item" and items[id] then
                    PickupItem(itemId)
                    PlaceAction(i)
                    ClearCursor()
                    U1Message("已自动将动作条上的"..(select(2, GetItemInfo(id))).."替换为"..link)
                    break
                end
            end
        end
    end)

    --GetSpellSubtext(7744)
    local racial = {
        7744, --亡灵意志
        69179, --奥术洪流
        26297, --巨魔
        33697, --兽人
        20549, --牛头人
        69070, --火箭跳 --69041, --火箭腰带
        274738, --先祖召唤 玛格汉兽人
        255654, --至高岭 蛮牛冲撞
        260364, --夜之子

        20594, --矮人石像
        58984, --暗夜精灵
        28880, --德莱尼
        265221, --黑铁矮人
        59752, --自利
        20589, --侏儒逃脱
        256948, --虚空精灵
        255647, --光铸
        68992, --狼人
    }
    for _, id in ipairs(racial) do racial[GetSpellInfo(id)] = true end --racial["炽天使"] = true
    local pattern = "^" .. string.format(ERR_LEARN_SPELL_S, "(.+)") .. "$" --"你学会新的法术：%s"
    CoreOnEvent("CHAT_MSG_SYSTEM", function(event, msg)
        if not U1GetCfgValue(addonName, 'AutoSwapRacial') then return end
        local _, _, link = msg:find(pattern)
        if link then
            local _, _, id, name = link:find("\124Hspell:(%d+).-\124h%[(.-)%]\124h")
            if id and name and racial[name] then
                for i=1, 120 do
                    local type, oldid = GetActionInfo(i)
                    if type == "spell" then
                        local oldname = GetSpellInfo(oldid)
                        if racial[oldname] and name ~= oldname then
                            local replace
                            replace = function()
                                id = tonumber(id)
                                PickupSpell(id)
                                PlaceAction(i)
                                if select(4, GetCursorInfo()) == id then
                                    return C_Timer.After(0.3, replace)
                                end
                                ClearCursor()
                                U1Message("已自动将动作条上的"..(GetSpellLink(oldid)).."替换为"..link)
                            end
                            C_Timer.After(0.3, replace)
                            break
                        end
                    end
                end
            end
        end
    end)
end

--[[------------------------------------------------------------
拾取材料
---------------------------------------------------------------]]
do
    local items = { [168217]=30, [168216]=10, [168215]=5 }
    local pattern = "^" .. string.format(LOOT_ITEM_SELF, "(.+)") .. "$" --"你获得了物品：%s。"
    CoreOnEvent("CHAT_MSG_LOOT", function(event, msg)
        local _, _, link = msg:find(pattern)
        local itemId = link and select(3, link:find("\124Hitem:(%d+):"))
        itemId = itemId and tonumber(itemId)
        if itemId and items[itemId] then
            CoreScheduleBucket("AbyUI_8.2_RECYLE", 0.5, function()
                local found = {}
                for container=BACKPACK_CONTAINER, NUM_BAG_SLOTS do
                    local slots = GetContainerNumSlots(container)
                    for slot=1, slots do
                        local _, count, _, _, _, _, slotLink, _, _, slotItemID = GetContainerItemInfo(container, slot)
                        if items[slotItemID] then
                            found[slotItemID] = found[slotItemID] or 0 + count
                        end
                    end
                end
                local s = "包内零件:"
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
项链特质鼠标中键点击查看
---------------------------------------------------------------]]
CoreDependCall("Blizzard_AzeriteEssenceUI", function()
    if AzeriteEssenceUI and AzeriteEssenceUI.EssenceList and AzeriteEssenceUI.EssenceList.buttons then
        for _, btn in ipairs(AzeriteEssenceUI.EssenceList.buttons) do
            btn:HookScript("OnEnter", function(self)
                self._abyuiNext = 0
                GameTooltip:AddLine("中键点击查看下一级(爱不易提供)", 0, 1, 0)
                GameTooltip:Show()
            end)
            btn:HookScript("OnClick", function(self, button)
                if button == "MiddleButton" then
                    btn._abyuiNext = (btn._abyuiNext or 0) + 1
                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
                    GameTooltip:SetAzeriteEssence(self.essenceID, (self.rank + btn._abyuiNext) % 4 );
                    GameTooltip:AddLine("中键点击查看下一级(爱不易提供)", 0, 1, 0)
                    GameTooltip:Show();
                end
            end)
            btn:RegisterForClicks("AnyUp")
        end
    end
end)

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