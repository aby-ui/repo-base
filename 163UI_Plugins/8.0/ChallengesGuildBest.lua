--[[------------------------------------------------------------
公会大秘排名
---------------------------------------------------------------]]

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

--[[------------------------------------------------------------
点击打开宝库奖励，暴雪已自带
---------------------------------------------------------------]]
local ShowWeeklyRewards = function()
    if not IsAddOnLoaded("Blizzard_WeeklyRewards") then
        LoadAddOn("Blizzard_WeeklyRewards");
    end
    CoreUIToggleFrame(WeeklyRewardsFrame)
end

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

    --levels          1    2    3    4    5    6    7    8    9   10   11   12   13   14   15   16   17   18   19   20
    local drops  = { nil, 210, 213, 216, 220, 223, 223, 226, 226, 229, 229, 233, 233, 236, 236, 236, 236, 236, 236, 236, 236,  }
    local levels = { nil, 226, 226, 226, 229, 229, 233, 236, 236, 239, 242, 246, 246, 249, 252, 252, 252, 252, 252, 252, 252,  }
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
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("温馨提示：7月8日第2赛季第1周，大秘掉落最高229。7月15日开的低保，是根据该周打的层数按以下表格计算：", nil, nil, nil, 1)
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
            for i = start, start + 6 do
                if levels[i] then
                    GameTooltip:AddDoubleLine(getline(i, self.level), getline(i+7, self.level), 1, 1, 1, 1, 1, 1)
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
    local ratings  = { "0000+",    "1400+", "1600+", "1800+", "2100+", }
    local upgrade  = {  220,    226,     233,     240,     246,  }
    local upgradep = {  233,    239,     246,     253,     259,  }
    local title    = { "休闲者", "争斗者", "挑战者", "竞争者", "决斗者" }

    for _, chest in ipairs({ PVPQueueFrame.HonorInset.RatedPanel.WeeklyChest, PVPQueueFrame.HonorInset.CasualPanel.WeeklyChest}) do
        --chest:HookScript("OnMouseUp", ShowWeeklyRewards)
        chest:HookScript("OnEnter", function(self)
            if GameTooltip:IsVisible() then
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine("（以下为第2赛季推测信息, 如有错误以游戏内为准）", nil, nil, nil, true)
                GameTooltip:AddLine("PVP等级  头衔  可升级到   PVP时装等", 1, 1, 1)
                for i, v in ipairs(ratings) do
                    local line = " %s |T130758:10:10:0:0:32:32:10:22:10:22|t %s |T130758:10:10:0:0:32:32:10:22:10:22|t %s |T130758:10:30:0:0:32:32:10:22:10:22|t %s"
                    GameTooltip:AddLine(format(line, ratings[i], title[i], tostring(upgrade[i]), tostring(upgradep[i])), 1, 1, 1)
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
        local levels    = {  "08", "09",   10,    11,    12, }
        local firstNew  = {    50,   90,  120,   150,   180, }
        local firstOld  = {   860,  915,  960,  1000,  1030, }
        local repeatOld = {   172,  183,  192,   200,   206, }
        if GameTooltip:IsVisible() then
            GameTooltip:AddLine("难度   薪尘    灰烬  灰烬(重复打)", 1, 1, 1)
            local line = " %2s |T130758:10:10:0:0:32:32:10:22:10:22|t %5s |T130758:10:10:0:0:32:32:10:22:10:22|t %4s |T130758:10:10:0:0:32:32:10:22:10:22|t %4s"
            for i, v in ipairs(levels) do
                GameTooltip:AddLine(format(line, tostring(levels[i]), tostring(firstNew[i]), tostring(firstOld[i]), tostring(repeatOld[i])), 1, 1, 1)
            end

            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("橙装装等  190/ 210/ 225/ 235")
            GameTooltip:AddLine("需要灰烬 1250/2000/3200/5150")
            GameTooltip:AddLine("249橙装需要 灰烬5150 薪尘1100")
            GameTooltip:AddLine("262橙装需要 灰烬5150 薪尘1650")
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("统御插槽位置：头、肩、胸")
            GameTooltip:AddLine("布甲：护腕、腰带")
            GameTooltip:AddLine("皮甲：手套、鞋子")
            GameTooltip:AddLine("锁甲：腰带、鞋子")
            GameTooltip:AddLine("板甲：护腕、手套")

            GameTooltip:Show()
        end
    end
end, {})