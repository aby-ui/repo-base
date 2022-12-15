--[[------------------------------------------------------------
公会大秘排名
---------------------------------------------------------------]]
local addonName = ...

--[[------------- copied from 7.3.0 --------------]]
ChallengesGuildBestMixin = {};

function ChallengesGuildBestMixin:SetUp(leaderInfo)
    self.leaderInfo = leaderInfo;

    local str = CHALLENGE_MODE_GUILD_BEST_LINE;
    if (leaderInfo.isYou) then
        --too long str = CHALLENGE_MODE_GUILD_BEST_LINE_YOU;
    end

    local classColorStr = RAID_CLASS_COLORS[leaderInfo.classFileName].colorStr;

    self.CharacterName:SetText(str:format(classColorStr, leaderInfo.name));
    self.Level:SetText(leaderInfo.keystoneLevel);
end

function ChallengesGuildBestMixin:OnEnter()
    local leaderInfo = self.leaderInfo;

    GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
    local name = C_ChallengeMode.GetMapUIInfo(leaderInfo.mapChallengeModeID);
    GameTooltip:SetText(name, 1, 1, 1);
    GameTooltip:AddLine(CHALLENGE_MODE_POWER_LEVEL:format(leaderInfo.keystoneLevel));
    for i = 1, #leaderInfo.members do
        local classColorStr = RAID_CLASS_COLORS[leaderInfo.members[i].classFileName].colorStr;
        GameTooltip:AddLine(CHALLENGE_MODE_GUILD_BEST_LINE:format(classColorStr,leaderInfo.members[i].name));
    end
    GameTooltip:Show();
end

ChallengesFrameGuildBestMixin = {};

function ChallengesFrameGuildBestMixin:SetUp(leaders)
    for i = 1, #leaders do
        local frame = self.GuildBests[i];
        if (not frame) then
            frame = CreateFrame("Frame", nil, self, "ChallengesGuildBestTemplate");
            frame:SetPoint("TOP", self.GuildBests[i-1], "BOTTOM");
        end
        frame:SetUp(leaders[i]);
        frame:Show();
    end
    for i = #leaders + 1, #self.GuildBests do
        self.GuildBests[i]:Hide();
    end
end
--[[------------- end copied from 7.3.0 --------------]]

CoreDependCall("Blizzard_ChallengesUI", function()
    if U1DBG.hideAbyGuildBest then return end

    local function update()
        local best = AbyChallengesFrameGuildBest
        best:SetParent(ChallengesFrame)
        --best:SetPoint("TOPRIGHT", ChallengesFrame.WeeklyInfo.Child.WeeklyChest, "TOPLEFT", -15, -15)
        best:SetPoint("TOPRIGHT", -5, -20)
        local leaders = C_ChallengeMode.GetGuildLeaders()
        if leaders and #leaders > 0 then
            best:Show()
        else
            best:Hide()
        end
        best:SetUp(leaders)
        --ChallengesFrame.WeeklyInfo.Child:SetPoint("TOPLEFT", -200, 0)
    end

    ChallengesFrame:HookScript("OnShow", update)
    CoreOnEvent("CHALLENGE_MODE_LEADERS_UPDATE", update)
    -- hooksecurefunc("ChallengesFrame_Update", update)

    local scoreInfo = ChallengesFrame.WeeklyInfo.Child.DungeonScoreInfo
    SetOrHookScript(scoreInfo, "OnEnter", function()
        if GameTooltip:IsVisible() then
            local best = C_MythicPlus.GetSeasonBestMythicRatingFromThisExpansion()
            local curr = C_ChallengeMode.GetOverallDungeonScore()
            if best > curr then
                local color = C_ChallengeMode.GetDungeonScoreRarityColor(best);
                if color then
                    best = color:WrapTextInColorCode(best)
                end
                GameTooltip_AddNormalLine(GameTooltip, "版本最高评分：" .. best);
                GameTooltip:Show();
            end
        end
    end)

    --levels          1    2    3    4    5    6    7    8    9   10   11   12   13   14   15   16   17   18   19   20 --abyuiPW
    local drops  = { nil, 376, 376, 379, 379, 382, 385, 385, 389, 392, 392, 392, 392, 395, 398, 398, 402, 402, 405, 405, 405,  }
    local levels = { nil, 382, 385, 385, 389, 389, 392, 395, 395, 398, 402, 405, 408, 408, 411, 415, 415, 418, 418, 421, 421,  }
    local function getline(i, curr)
        if not levels[i] then return "" end
        local line = "% 2d层 |T130758:10:10:0:0:32:32:10:22:10:22|t %s |T130758:10:10:0:0:32:32:10:22:10:22|t %s"
        local drop = drops[i] and format("%d", drops[i]) or " ? "
        local level = levels[i] and format("%d", levels[i]) or " ? "
        if i == curr then line = "|cff00ff00"..line.."|r" end
        return format(line, i, drop, level)
    end
    local chest = ChallengesFrame.WeeklyInfo.Child.WeeklyChest
    --chest:HookScript("OnMouseUp", ShowWeeklyRewards)
    chest:HookScript("OnEnter", function(self)
        if GameTooltip:IsVisible() then
            --GameTooltip:AddLine(" ") GameTooltip:AddLine("温馨提示：3月3日第3赛季第1周，大秘掉落最高255。3月10日开的低保，是根据该周打的层数按以下表格计算：", nil, nil, nil, 1)
            GameTooltip:AddLine(" ")
            local header = "层数   掉落  周箱"
            GameTooltip:AddDoubleLine(header, header, 1, 1, 1, 1, 1, 1)
            local start = 2
            --[[
            if self.level and self.level > 0 then
                --start = self.level - 8
            elseif self.ownedKeystoneLevel and self.ownedKeystoneLevel > 0 then
                --start = self.ownedKeystoneLevel - 5
            end
            ]]
            for i = start, start + 9 do
                if levels[i] then
                    GameTooltip:AddDoubleLine(getline(i, self.level), getline(i+10, self.level), 1, 1, 1, 1, 1, 1)
                else
                    break
                end
            end

            --GameTooltip:AddLine(" ")
            --GameTooltip:AddLine("点击查看宏伟宝库（爱不易提供）", 0, 1, 0)
            --[[
            GameTooltip:AddLine("9.0低保机制改为最多从9个箱子里选择1个", 1, 1, 1)
            GameTooltip:AddLine("其中通过打大秘境最多可以得到3个箱子：", 1, 1, 1)
            GameTooltip:AddLine("第1个箱子的装等对应本周打过|cff00ff00最高|r层数", 1, 1, 1)
            GameTooltip:AddLine("第2个箱子的装等对应本周打过第|cff00ff004|r高的层数", 1, 1, 1)
            GameTooltip:AddLine("第3个箱子的装等对应本周打过第|cff00ff0010|r高的层数", 1, 1, 1)
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("例如你本周打了5个大秘，层数分别是2 5 7 9 8，那么你下周低保第一个箱子对应9层，第二个箱子对应5层，没有第三个箱子。本周进度可以查看|cff00ff00奥利波斯银行旁边的宏伟宝库|r（那个大台阶就是）", 1, 1, 1, true)
            --]]
            GameTooltip:Show()
        end
    end)
end)

--[[------------------------------------------------------------
PVP每周奖励
---------------------------------------------------------------]]
CoreDependCall("Blizzard_PVPUI", function()
    do return end
    local ratings  = { "0000+", "1000+", "1200+", "1400+", "1600+", "1800+", "1950+", "2100+", "2400+"}
    local upgrade  = {  275,    278,     281,     285,     288,     291,     294,     298,     301, }
    local upgradep = {  288,    291,     294,     298,     301,     304,     307,     311,     311, }
    local title    = { "休闲者","争斗者I","争斗者II","挑战者I","挑战者II","竞争者I","竞争者II","决斗者","精锐" }

    for _, chest in ipairs({ PVPQueueFrame.HonorInset.RatedPanel.WeeklyChest, PVPQueueFrame.HonorInset.CasualPanel.WeeklyChest}) do
        --chest:HookScript("OnMouseUp", ShowWeeklyRewards)
        chest:HookScript("OnEnter", function(self)
            if GameTooltip:IsVisible() then
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine("（以下为第3赛季信息, 如有错误以游戏内为准）", nil, nil, nil, true)
                GameTooltip:AddLine("PVP等级  装等  PVP时装等  头衔", 1, 1, 1)
                for i, v in ipairs(ratings) do
                    local line = " %s |T130758:10:15:0:0:32:32:10:22:10:22|t %s |T130758:10:20:0:0:32:32:10:22:10:22|t %s |T130758:10:30:0:0:32:32:10:22:10:22|t %s"
                    GameTooltip:AddLine(format(line, ratings[i], tostring(upgrade[i]), tostring(upgradep[i]), title[i]), 1, 1, 1)
                end
                --GameTooltip:AddLine(" ")
                --GameTooltip:AddLine("爱不易提示：PVP低保现在和团本、大秘低保一起只能选择一个，点击查看宏伟宝库", 1, 1, 1, true)
                GameTooltip:Show()
            end
        end)
    end
end)

--[[------------------------------------------------------------
托加斯特
---------------------------------------------------------------]]
EventRegistry:RegisterCallback("AreaPOIPin.MouseOver", function(self, obj, tooltipShown, areaPoiID, name)
    if areaPoiID == 6640 then
        -- https://www.wowhead.com/guides/torghast-updates-patch-9-1-new-scoring-rewards-torments-shadowlands#farmable-soul-ash
        local levels    = {  "08", "09",   10,    11,    12,     13,     14,     15,     16}
        local firstNew  = {   170,  230,  270,   310,   350,    380,    410,    440,    470}
        local firstOld  = {   860,  915,  960,  1000,  1030,   1060,   1090,   1120,   1150}
        if GameTooltip:IsVisible() then
            GameTooltip:AddLine("难度   薪尘    灰烬", 1, 1, 1)
            local line = " %2s |T130758:10:10:0:0:32:32:10:22:10:22|t %5s |T130758:10:10:0:0:32:32:10:22:10:22|t %4s"
            for i, v in ipairs(levels) do
                GameTooltip:AddLine(format(line, tostring(levels[i]), tostring(firstNew[i]), tostring(firstOld[i])), 1, 1, 1)
            end

            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("橙装装等  190/ 210/ 225/ 235")
            GameTooltip:AddLine("需要灰烬 1250/2000/3200/5150")
            GameTooltip:AddLine("249橙装需要 灰烬5150 薪尘1100")
            GameTooltip:AddLine("262橙装需要 灰烬5150 薪尘1650")
            GameTooltip:AddLine("291橙装需要 262材料及2000宇宙助溶剂")
--            GameTooltip:AddLine(" ")
--            GameTooltip:AddLine("统御插槽位置：头、肩、胸")
--            GameTooltip:AddLine("布甲：护腕、腰带")
--            GameTooltip:AddLine("皮甲：手套、鞋子")
--            GameTooltip:AddLine("锁甲：腰带、鞋子")
--            GameTooltip:AddLine("板甲：护腕、手套")

            GameTooltip:Show()
        end
    end
end, {})

--[[------------------------------------------------------------
点击打开宝库奖励，暴雪已自带
---------------------------------------------------------------]]
local ShowWeeklyRewards = function()
    if not IsAddOnLoaded("Blizzard_WeeklyRewards") then
        LoadAddOn("Blizzard_WeeklyRewards");
    end
    CoreUIToggleFrame(WeeklyRewardsFrame)
end

--[[------------------------------------------------------------
始终显示本周史诗地下城记录
---------------------------------------------------------------]]
CoreDependCall("Blizzard_WeeklyRewards", function()
    local function showAllMythicHistory()
        local runHistory = C_MythicPlus.GetRunHistory(false, true);
        if #runHistory > 0 then
            local ccount = 0; for _, v in ipairs(runHistory) do ccount = ccount + (v.completed and 1 or 0) end
            GameTooltip_AddHighlightLine(GameTooltip, string.format("本周共完成|cffffff00%d|r次, 其中限时|cff00ff00%d|r次", #runHistory, ccount), true);
            --决定不排序，因为需要凑次数的时候用的是系统自带的排序的
            local half = #runHistory > 16 and math.ceil(#runHistory / 2) or #runHistory
            for i = 1, half do
                local runInfo = runHistory[i];
                local name = C_ChallengeMode.GetMapUIInfo(runInfo.mapChallengeModeID);
                name = name:gsub("^.-：", "")
                local runInfo2 = runHistory[i + half];
                local name2 = runInfo2 and C_ChallengeMode.GetMapUIInfo(runInfo2.mapChallengeModeID)
                local text2, color2 = "", GREEN_FONT_COLOR
                if runInfo2 then
                    text2 = name2:gsub("^.-：", "") .. " - " .. runInfo2.level
                    color2 = runInfo2.completed and GREEN_FONT_COLOR or RED_FONT_COLOR
                end
                GameTooltip_AddColoredDoubleLine(GameTooltip, runInfo.level .. " - " .. name, text2, runInfo.completed and GREEN_FONT_COLOR or RED_FONT_COLOR, color2, false)
            end
            GameTooltip_AddBlankLineToTooltip(GameTooltip);
        end
    end

    SetOrHookScript(WeeklyRewardsFrame, "OnShow", function()
        C_Timer.After(1, function()
            if WeeklyRewardsFrame.Overlay then WeeklyRewardsFrame.Overlay:Hide() end
            if WeeklyRewardsFrame.Blackout then WeeklyRewardsFrame.Blackout:Hide() end
        end)
    end)
    for i=1, 3 do
        local act = WeeklyRewardsFrame:GetActivityFrame(Enum.WeeklyRewardChestThresholdType.MythicPlus, i)
        act.OriginHandlePreviewMythicRewardTooltip = act.HandlePreviewMythicRewardTooltip
        act.HandlePreviewMythicRewardTooltip = function(self, itemLevel, upgradeItemLevel, nextLevel)
            self:OriginHandlePreviewMythicRewardTooltip(itemLevel, upgradeItemLevel, nextLevel)
            if not upgradeItemLevel then
                showAllMythicHistory()
            end
        end

        act:HookScript("OnEnter", function(self)
            if not self.unlocked and not C_WeeklyRewards.CanClaimRewards() then
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -7, -11);
                GameTooltip_SetTitle(GameTooltip, "尚未解锁");
                self.UpdateTooltip = nil;
                GameTooltip_AddBlankLineToTooltip(GameTooltip);
                showAllMythicHistory()
                GameTooltip_AddNormalLine(GameTooltip, "请继续努力，爱不易祝你开心")
                GameTooltip:Show();
            end
        end)
    end
end)

--[[------------------------------------------------------------
大米分数显示 --abyuiPW
---------------------------------------------------------------]]
CoreDependCall("Blizzard_ChallengesUI", function()
    local SHORT_NAMES = {
        [402] = "学院",
        [399] = "红玉",
        [401] = "碧蓝",
        [400] = "诺库德",
        [165] = "影月",
        [210] = "群星",
        [200] = "英灵殿",
        [002] = "青龙寺",
    }
    local PORTAL_SPELLS = {
        [375] = 354464, --"仙林",
        [376] = 354462, --"通灵",
        [377] = 354468, --"彼界",
        [378] = 354465, --"赎罪",
        [379] = 354463, --"凋魂",
        [380] = 354469, --"赤红",
        [381] = 354466, --"高塔",
        [382] = 354467, --"剧场",
        [391] = 367416, --"天街",
        [392] = 367416, --"宏图",
        [370] = 373274, --"车间",
        [369] = 373274, --"垃圾场"
        [227] = 373262, --"卡拉赞",
        [234] = 373262, --"卡拉赞",
        [169] = 159896, --"码头",
        [166] = 159900, --"恐轨",
    }
    local LEVEL_COLORS = { --系统 C_ChallengeMode.GetKeystoneLevelRarityColor 15以上就是橙色了
        [0] = "ffffff", --白 0-4
        [1] = "1eff00", --绿 5-9
        [2] = "0070dd", --蓝 10-14
        [3] = "a335ee", --紫 15-19
        [4] = "ff8000", --橙 20-24
        [5] = "e6cc80", --红 25+
    }
    local AFFIX_T = C_ChallengeMode.GetAffixInfo(9) --残暴
    local AFFIX_F = C_ChallengeMode.GetAffixInfo(10) --强韧

    local function GetWeekAffixName()
        local curr = C_MythicPlus.GetCurrentAffixes()
        return curr and curr[1] and curr[1].id and C_ChallengeMode.GetAffixInfo(curr[1].id) or nil
    end

    local function updateIconLevelText(self)
        if not U1GetCfgValue(addonName, 'MythicScore') then
            self._abyName:SetText("")
            self._abyAffix:SetText("")
            return
        end

        local mapName = C_ChallengeMode.GetMapUIInfo(self.mapID)
        mapName = SHORT_NAMES[self.mapID] or string.sub(mapName, 1, 6)
        self._abyName:SetText(mapName)

        local affix, score = C_MythicPlus.GetSeasonBestAffixScoreInfoForMap(self.mapID)
        if not affix then self._abyAffix:SetText("") return end
        local left, left_c = "0", "ffffff"
        local right, right_c = "0", "ffffff"
        local curr = ChallengesFrame._abySort:GetChecked() and GetWeekAffixName()
        if curr then score = 0 end
        for i, v in ipairs(affix) do
            local color = v.overTime and "7f7f7f" or LEVEL_COLORS[min(floor(v.level/5),5)]
            if curr then
                if GetWeekAffixName() == v.name then
                    score = v.score
                    left, left_c = v.level, color
                end
            elseif v.name == AFFIX_T then
                left, left_c = v.level, color
            elseif v.name == AFFIX_F then
                right, right_c = v.level, color
            end
        end

        local fontName, _, fontFlag = self._abyAffix:GetFont()
        if curr then
            local color = C_ChallengeMode.GetSpecificDungeonOverallScoreRarityColor(score * 2)
            if color then score = color:WrapTextInColorCode(score) end
            self._abyAffix:SetFont(fontName, 20, fontFlag)
            self._abyAffix:SetText(format("|cff%s%s|r", left_c, left))
        else
            self._abyAffix:SetFont(fontName, 15, fontFlag)
            self._abyAffix:SetText(format("|cff%s%s|r|cff7f7f7f / |r|cff%s%s|r", left_c, left, right_c, right))
        end
        self.HighestLevel:SetText(score)
    end

    local function showPortalSecureButton()
        if not ChallengesFrame:IsVisible() then return end
        for i, icon in pairs(ChallengesFrame.DungeonIcons) do
            local btn = _G["AbyDungeonPortal"..i]
            if not btn then
                btn = WW:Button("AbyDungeonPortal"..i, nil, "SecureActionButtonTemplate")
                :SetAttribute("type1", "macro")
                :SetScript("PreClick", function(self, button)
                    if button == "RightButton" then
                        if ELP_CHALLENGE_MAPID_FILTER_INDEX and ELP_CHALLENGE_MAPID_FILTER_INDEX[icon.mapID] then
                            if not EncounterJournal or not EncounterJournal:IsShown() then
                                if not InCombatLockdown() then
                                    ToggleEncounterJournal();
                                else
                                    CoreUIToggleFrame(EncounterJournal)
                                end
                            end
                            ELP_MenuOnClick(self, "range", ELP_CHALLENGE_MAPID_FILTER_INDEX[icon.mapID])
                        end
                    end
                end)
                :SetScript("OnEnter", function(self)
                    local s = self.hook:GetScript("OnEnter")
                    if s then
                        s(icon)
                        local spell = icon.mapID and PORTAL_SPELLS[icon.mapID]
                        if spell then
                            GameTooltip:AddLine(" ")
                            if ELP_CHALLENGE_MAPID_FILTER_INDEX and ELP_CHALLENGE_MAPID_FILTER_INDEX[icon.mapID] then
                                GameTooltip:AddLine("右键点击查询掉落")
                                GameTooltip:Show()
                            end
                            if IsSpellKnown(spell) then
                                local start,duration = GetSpellCooldown(spell)
                                if start and duration and duration > 1.5 then --1.5 is GCD
                                    GameTooltip:AddLine("传送冷却：" .. MinutesToTime((start+duration-GetTime())/60))
                                else
                                    GameTooltip:AddLine("左键点击施法：" .. (GetSpellInfo(spell) or spell))
                                end
                                GameTooltip:Show()
                            end
                        end
                    end
                end)
                :SetScript("OnLeave", function(self) local s = self.hook:GetScript("OnLeave") if s then s(icon) end end)
                :un()
                btn.hook = icon
            end
            WW(btn):SetParent(icon):ClearAllPoints():SetAllPoints(icon):Show()
            :RegisterForClicks("AnyUp", "AnyDown")
            :SetFrameStrata(icon:GetFrameStrata()):AddFrameLevel(1, icon)
            :un()
            if icon and icon.mapID and GetSpellInfo(PORTAL_SPELLS[icon.mapID]) then
                btn:SetAttribute("macrotext1", format("/stopcasting\n/cast %s", (GetSpellInfo(PORTAL_SPELLS[icon.mapID]))))
            else
                btn:SetAttribute("macrotext1", nil)
            end
        end
    end

    CoreOnEvent("PLAYER_REGEN_DISABLED", function()
        for i=1, 20 do
            local btn = _G["AbyDungeonPortal"..i]
            if not btn then break end
            btn:SetParent(nil)
            btn:ClearAllPoints()
            btn:Hide()
        end
        C_Timer.After(0.1, function()
            CoreLeaveCombatCall("ChallengesGuildBest", nil, showPortalSecureButton)
        end)
    end)

    hooksecurefunc(ChallengesFrame, "Update", function(self)
        pcall(function() ChallengesFrame.WeeklyInfo.Child.SeasonBest:SetText("") end)

        CoreLeaveCombatCall("ChallengesGuildBest", nil, showPortalSecureButton)

        if not ChallengesFrame._abySort then
            local chk = WW(ChallengesFrame):CheckButton(nil, "UICheckButtonTemplate"):Key("_abySort")
            :SetPoint("BOTTOMLEFT", ChallengesFrame.DungeonIcons[1], "TOPLEFT", 0, 15)
            :SetSize(24,24):un()
            chk:SetScript("OnClick", function(self)
                for i, icon in pairs(ChallengesFrame.DungeonIcons) do
                    updateIconLevelText(icon)
                end
            end)
            CoreUIEnableTooltip(chk, "显示本周词缀分数", "副本分数计算方法为强韧残暴两种词缀下的分数，高的分数乘以3，加上低的分数，然后再除以2。\n\n选中此项方便查看本周词缀的分数\n\n可以在小功能集合里关闭此功能。")
        end
        ChallengesFrame._abySort.text:SetText((GetWeekAffixName() or "本周").."分数")
        CoreUIShowOrHide(ChallengesFrame._abySort, U1GetCfgValue(addonName, 'MythicScore'))

        for i, icon in pairs(ChallengesFrame.DungeonIcons) do
            if not icon._abyName then
                WW(icon):CreateFontString():Key("_abyName")
                :SetFont(GameFontNormal:GetFont(), 16, "OUTLINE"):TOP(0, 14)
                :SetText(""):up():un()

                WW(icon):CreateFontString():Key("_abyAffix")
                :SetFont(GameFontNormal:GetFont(), 15, "OUTLINE"):BOTTOM(1, 5)
                :SetShadowColor(0,0,0):SetShadowOffset(1,-1)
                :SetText(""):up():un()

                SetOrHookScript(icon, "OnEnter", function(self)
                    local affix, overall = C_MythicPlus.GetSeasonBestAffixScoreInfoForMap(self.mapID)
                    if not affix then return end
                    for _, v in ipairs(affix) do
                        for i = 2, 10 do
                            local txt = _G["GameTooltipTextLeft"..i]
                            if (txt and txt:GetText() or ""):find(v.name) then
                                txt:SetText(txt:GetText() .. "：" .. v.score .. "分")
                            end
                        end
                    end
                    GameTooltip:Show()
                end)

                hooksecurefunc(icon, "SetUp", updateIconLevelText)
                updateIconLevelText(icon)
            end
        end
    end)

    --ChallengesFrame_Update(ChallengesFrame)
end)

--第一次打开PVE界面跳到大米窗口
local first = true
hooksecurefunc("PVEFrame_ToggleFrame", function()
    if first and not InCombatLockdown() and PVEFrameTab3 and PVEFrameTab3:IsEnabled() then
        local info = C_PlayerInfo.GetPlayerMythicPlusRatingSummary("player")
        if info and (info.currentSeasonScore or 0) >= 1500 then
            PVEFrameTab3:Click()
        end
    end
    first = false
end)