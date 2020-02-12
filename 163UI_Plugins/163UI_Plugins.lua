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
丰灵头
---------------------------------------------------------------]]
do
    local items = {166796, 166798, 166797, 166799, 166800, 166801 } for i, v in ipairs(items) do items[v] = true end
    local pattern = "^" .. string.format(LOOT_ITEM_PUSHED_SELF, "(.+)") .. "$" --"你获得了物品：%s。"
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
end

--[[------------------------------------------------------------
拾取材料
---------------------------------------------------------------]]
do
    local items = { [168217]=30, [168216]=10, [168215]=5 }
    local pattern = "^" .. string.format(LOOT_ITEM_PUSHED_SELF, "(.+)") .. "$" --"你获得了物品：%s。"
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