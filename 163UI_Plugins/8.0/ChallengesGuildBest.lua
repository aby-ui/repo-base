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

    local levels = { nil, 380, 385, 390, 390, 395, 400, 400, 405, 410, 410, 410, 410, 410, 410, 410, 410, 410, 410, 410, 410, 410, 410, 410, 410 }
    local titans = { nil, 15, 20, 60, 70, 80, 195, 205, 215, 625, 667, 709, 751, 793, 835, 866, 897, 928, 959, 990, 1010,1030,1050,1070,1090}
    ChallengesFrame.WeeklyInfo.Child.WeeklyChest:HookScript("OnEnter", function(self)
        if GameTooltip:IsVisible() then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("钥石层数  奖励装等  奖励精华")
            local start = 2
            if self.level and self.level > 0 then
                start = self.level - 4
            elseif self.ownedKeystoneLevel and self.ownedKeystoneLevel > 0 then
                --start = self.ownedKeystoneLevel - 5
            end
            for i = start, start + 10 do
                if levels[i] or titans[i] then
                    local line = "    %2d层 |T130758:10:35:0:0:32:32:10:22:10:22|t %s |T130758:10:25:0:0:32:32:10:22:10:22|t %s"
                    local level = levels[i] and format("%d", levels[i]) or " ? "
                    local titan = titans[i] and format("%4d", titans[i]) or "  ? "
                    if i == self.level then line = "|cff00ff00"..line.."|r" end
                    GameTooltip:AddLine(format(line, i, level, titan))
                else
                    break
                end
            end

            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("385随机 需要165  分解返35")
            GameTooltip:AddLine("400随机 需要675  分解返115")
            GameTooltip:AddLine("415随机 需要1725 分解返365")
            GameTooltip:AddLine("415指定 需要7150")
            GameTooltip:AddLine("370分解 返12")
            GameTooltip:AddLine("仅|cffff00008.1|r之后获得的|cffff0000同甲|r特质装才返")
            GameTooltip:Show()
        end
    end)
end)
