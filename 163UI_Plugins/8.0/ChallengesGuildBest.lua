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
end)
