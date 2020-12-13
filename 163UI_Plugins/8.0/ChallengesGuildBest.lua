--[[------------------------------------------------------------
公会大米排名
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
    local drops  = { nil, 187, 190, 194, 194, 197, 200, 200, 200, 207, 207, 207, 207, 207, 210, 210, 210, 210, 210, 210, 210, 210, 210, 210, 210 }
    local levels = { nil, 200, 203, 207, 210, 210, 213, 216, 216, 220, 220, 223, 223, 226, 226, 226, 226, 226, 226, 226, 226, 226, 226, 226, 226 }
    local function getline(i, curr)
        if not levels[i] then return "" end
        local line = "% 2d层 |T130758:10:10:0:0:32:32:10:22:10:22|t %s |T130758:10:10:0:0:32:32:10:22:10:22|t %s"
        local drop = drops[i] and format("%d", drops[i]) or " ? "
        local level = levels[i] and format("%d", levels[i]) or " ? "
        if i == curr then line = "|cff00ff00"..line.."|r" end
        return format(line, i, drop, level)
    end
    local chest = ChallengesFrame.WeeklyInfo.Child.WeeklyChest
    chest:HookScript("OnMouseUp", ShowWeeklyRewards)
    chest:HookScript("OnEnter", function(self)
        if GameTooltip:IsVisible() then
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

            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("点击查看宏伟宝库（爱不易提供）", 0, 1, 0)
            --[[
            GameTooltip:AddLine("9.0低保机制改为最多从9个箱子里选择1个", 1, 1, 1)
            GameTooltip:AddLine("其中通过打大秘境最多可以得到3个箱子：", 1, 1, 1)
            GameTooltip:AddLine("第1个箱子的装等对应本周打过|cff00ff00最高|r层数", 1, 1, 1)
            GameTooltip:AddLine("第2个箱子的装等对应本周打过第|cff00ff004|r高的层数", 1, 1, 1)
            GameTooltip:AddLine("第3个箱子的装等对应本周打过第|cff00ff0010|r高的层数", 1, 1, 1)
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("例如你本周打了5个大米，层数分别是2 5 7 9 8，那么你下周低保第一个箱子对应9层，第二个箱子对应5层，没有第三个箱子。本周进度可以查看|cff00ff00奥利波斯银行旁边的宏伟宝库|r（那个大台阶就是）", 1, 1, 1, true)
            --]]
            GameTooltip:Show()
        end
    end)
end)

--[[------------------------------------------------------------
大米赛季光辉事迹
---------------------------------------------------------------]]
CoreDependCall("Blizzard_ChallengesUI", function()
    local aID10, aID15 = 14531, 14532 --s4: 14144, 14145 --s3: 13780, 13781 --s2: 13448, 13449 --s1: 13079, 13080
    --/run for i, icon in pairs(ChallengesFrame.DungeonIcons) do print(C_ChallengeMode.GetMapUIInfo(icon.mapID), icon.mapID) end
    --/run for i=1,12 do print(GetAchievementCriteriaInfo(14144,i),GetAchievementCriteriaInfo(14145,i)) end
    local crits_to_mapid = { 375, 380, 381, 376, 382, 378, 379, 377 }
    local crits_name_to_map_name = {}
    local debug_unmapped = {
        ["麦卡贡车间"] = true,
        ["麦卡贡垃圾场"] = true,
    }
    local crits, numCrits = {}, GetAchievementNumCriteria(aID15)
    hooksecurefunc("ChallengesFrame_Update", function(self)
        table.wipe(crits)
        local ar10 = select(4, GetAchievementInfo(aID10))
        local ar15 = select(4, GetAchievementInfo(aID15))
        for i=1, numCrits do
            local name, _, _, complete = GetAchievementCriteriaInfo(aID15, i)
            if crits_to_mapid[i] then
                crits_name_to_map_name[name] = C_ChallengeMode.GetMapUIInfo(crits_to_mapid[i])
            end
            if complete == 1 then
                crits[name] = 15
            else
                crits[name] = 0
                name, _, _, complete = GetAchievementCriteriaInfo(aID10, i)
                if complete == 1 then crits[name] = 10 else crits[name] = 0 end
            end
        end
        -- 没匹配上的会映射名称
        for crit_name, map_name in pairs(crits_name_to_map_name) do
            if crits[map_name] == nil then
                if not debug_unmapped[crit_name] then u1debug("映射成就名", crit_name, "到地图名", map_name) end
                crits[map_name] = crits[crit_name]
                debug_unmapped[crit_name] = true
            end
        end

        for i, icon in pairs(ChallengesFrame.DungeonIcons) do
            local mapName = C_ChallengeMode.GetMapUIInfo(icon.mapID)
            if DEBUG_MODE and crits[mapName] == nil and not debug_unmapped[mapName] then
                debug_unmapped[mapName] = true
                local names for nn in pairs(crits) do names = (names and names .. "," or "") ..  nn end
                u1log("无法对应地图名称", mapName, names)
            end
            if not icon.tex then
                WW(icon):CreateTexture():SetSize(24,24):BOTTOM(0, -3):Key("tex"):up():un()
                SetOrHookScript(icon, "OnEnter", function()
                    GameTooltip_AddBlankLineToTooltip(GameTooltip);
                    GameTooltip:AddLine("爱不易提供：")
                    --https://wow.tools/dbc/?dbc=uitextureatlasmember&build=8.3.0.33237#search=VignetteKillElite&page=1
                    --https://wow.tools/dbc/?dbc=manifestinterfacedata&build=8.3.0.33237#search=1121272&page=1
                    local atlas = C_Texture.GetAtlasInfo("VignetteKill")
                    local texCoord = format("%d:%d:%d:%d", atlas.leftTexCoord*1024,atlas.rightTexCoord*1024,atlas.topTexCoord*512,atlas.bottomTexCoord*512)
                    GameTooltip:AddLine("\124TInterface/Minimap/ObjectIconsAtlas:16:16:0:0:1024:512:"..texCoord.."\124t 表示已限时10层")
                    local atlas = C_Texture.GetAtlasInfo("VignetteKillElite")
                    local texCoord = format("%d:%d:%d:%d", atlas.leftTexCoord*1024,atlas.rightTexCoord*1024,atlas.topTexCoord*512,atlas.bottomTexCoord*512)
                    GameTooltip:AddLine("\124TInterface/Minimap/ObjectIconsAtlas:16:16:0:0:1024:512:"..texCoord.."\124t 表示已限时15层")
                    GameTooltip:Show()
                end)
            end
            local inTimeInfo, overtimeInfo = C_MythicPlus.GetSeasonBestForMap(icon.mapID);
            if inTimeInfo then
                crits[mapName] = math.max(crits[mapName] or 0, inTimeInfo.level or 0)
            end
            icon.tex:Show()
            if ar15 or (crits[mapName] or 0) >= 15 then
                icon.tex:SetAtlas("VignetteKillElite")
            elseif ar10 or (crits[mapName] or 0) >= 10 then
                icon.tex:SetAtlas("VignetteKill")
            else
                icon.tex:Hide()
            end
        end
    end)
    --ChallengesFrame_Update(ChallengesFrame)
end)

--[[------------------------------------------------------------
PVP每周奖励
---------------------------------------------------------------]]
CoreDependCall("Blizzard_PVPUI", function()
    local ratings  = { "0000~1399", "1400~1599", "1600~1799", "1800~2099", "2100~2399", "2400~9999" }
    local match =    { 430,       440,        450,         455,         460,         465 }
    local weekly =   { 445,       455,        460,         465,         470,         475 }
    local weekly2 =  { 445,       460,        460,         475,         475,         475 }

    local chest = PVPQueueFrame.HonorInset.RatedPanel.WeeklyChest
    chest:HookScript("OnMouseUp", ShowWeeklyRewards)
    chest:HookScript("OnEnter", function(self)
        if GameTooltip:IsVisible() then
            GameTooltip:AddLine(" ")
            --[[
            GameTooltip:AddLine("PVP等级  比赛结束  低保散件  低保特质")
            for i, v in ipairs(ratings) do
            local line = " %9s |T130758:10:20:0:0:32:32:10:22:10:22|t %d |T130758:10:28:0:0:32:32:10:22:10:22|t %d |T130758:10:35:0:0:32:32:10:22:10:22|t %d"
                GameTooltip:AddLine(format(line, ratings[i], match[i], weekly[i], weekly2[i]))
            end

            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("500征服 首周440，2~9周445，10~25周460")
            ]]
            GameTooltip:AddLine("爱不易提示：PVP低保现在和团本、大秘低保一起只能选择一个，点击查看宏伟宝库", 1, 1, 1, true)
            GameTooltip:Show()
        end
    end)
end)
