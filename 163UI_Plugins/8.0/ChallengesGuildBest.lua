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

    --levels           1    2    3    4    5    6    7    8    9   10   11   12   13   14   15   16   17   18   19   20
    local drops  = { nil, 435, 435, 440, 445, 445, 450, 455, 455, 455, 460, 460, 460, 465, 465, 465, 465, 465, 465, 465, 465, 465, 465, 465, 465 }
    local levels = { nil, 440, 445, 450, 450, 455, 460, 460, 460, 465, 465, 470, 470, 470, 475, 475, 475, 475, 475, 475, 475, 475, 475, 475, 475 }
    local titans = { nil, nil, nil, nil, nil,  75, 330, 365, 400, 1700, 1790, 1880, 1970, 2060, 2150, 2240, 2330, 2420, 2510, 2600, 2665,2730,2795,2860,2915}
    ChallengesFrame.WeeklyInfo.Child.WeeklyChest:HookScript("OnEnter", function(self)
        if GameTooltip:IsVisible() then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("钥石层数  掉落  周箱  奖励精华")
            local start = 2
            if self.level and self.level > 0 then
                start = self.level - 8
            elseif self.ownedKeystoneLevel and self.ownedKeystoneLevel > 0 then
                --start = self.ownedKeystoneLevel - 5
            end
            for i = start, start + 12 do
                if levels[i] or titans[i] then
                    local line = "    %2d层 |T130758:10:15:0:0:32:32:10:22:10:22|t %s |T130758:10:10:0:0:32:32:10:22:10:22|t %s |T130758:10:15:0:0:32:32:10:22:10:22|t %s"
                    local drop = drops[i] and format("%d", drops[i]) or " ? "
                    local level = levels[i] and format("%d", levels[i]) or " ? "
                    local titan = titans[i] and format("%4d", titans[i]) or "  ? "
                    if i == self.level then line = "|cff00ff00"..line.."|r" end
                    GameTooltip:AddLine(format(line, i, drop, level, titan))
                else
                    break
                end
            end

            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("445随机 需要175  分解返40")
            GameTooltip:AddLine("460随机 需要900  分解返200")
            GameTooltip:AddLine("475随机 需要4750 分解返1000 指定需要2万")
            GameTooltip:AddLine("仅分解8.3获得|cffff0000同甲|r特质装才返")
            GameTooltip:Show()
        end
    end)
end)

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
                    --https://wow.tools/dbc/?dbc=uitextureatlasmember&build=8.3.0.33237#search=VignetteKillElite&page=1
                    --https://wow.tools/dbc/?dbc=manifestinterfacedata&build=8.3.0.33237#search=1121272&page=1
                    local atlas = C_Texture.GetAtlasInfo("VignetteKill")
                    local texCoord = format("%d:%d:%d:%d", atlas.leftTexCoord*1024,atlas.rightTexCoord*1024,atlas.topTexCoord*512,atlas.bottomTexCoord*512)
                    GameTooltip:AddLine("\124TInterface/Minimap/ObjectIconsAtlas:16:16:0:0:1024:512:"..texCoord.."\124t 已限时10层")
                    local atlas = C_Texture.GetAtlasInfo("VignetteKillElite")
                    local texCoord = format("%d:%d:%d:%d", atlas.leftTexCoord*1024,atlas.rightTexCoord*1024,atlas.topTexCoord*512,atlas.bottomTexCoord*512)
                    GameTooltip:AddLine("\124TInterface/Minimap/ObjectIconsAtlas:16:16:0:0:1024:512:"..texCoord.."\124t 已限时15层")
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