U1PLUG["GuildRosterButtons"] = function()

--[[------------------------------------------------------------
把工会玩家状态的下拉列表变成按钮，方便选择
GuildRosterViewDropdown_Initialize()
---------------------------------------------------------------]]

local VIEWS = {
	"playerStatus",
	"guildStatus",
	"achievement",
	"tradeskill",
    "reputation",
    "roles",
}

CoreDependCall("Blizzard_GuildUI", function()

    GuildRosterViewDropdown:Hide()

    -- 6.0 前夕开始已经取消公会等级
    --[[
         local function OnUpdate(self, elapsed)
             if GetGuildLevel() > 0 then
                 GuildFrame_UpdateLevel()
                 self:SetScript("OnUpdate", nil)
             end
         end

         local g = CreateFrame("Frame")
         g:SetScript("OnUpdate", OnUpdate)
         ]]

    if not tContains(VIEWS, GetCVar("guildRosterView")) then
        SetCVar("guildRosterView", "playerStatus")
    end

    local recent

    local b1 = CreateFrame("Button", "GRB_tradeskill", GuildRosterFrame, "UIMenuButtonStretchTemplate")
    b1:SetSize(80,18)
    b1.value = "tradeskill"
    b1:SetText(TRADE_SKILLS)
    b1:SetPoint("TOPRIGHT",-25,-26)

    local b2 = CreateFrame("Button", "GRB_guildStatus", GuildRosterFrame, "UIMenuButtonStretchTemplate")
    b2:SetSize(80,18)
    b2.value = "guildStatus"
    b2:SetText(GUILD_STATUS)
    b2:SetPoint("TOPRIGHT", b1, "TOPLEFT", -2, 0)

    local b3 = CreateFrame("Button", "GDB_playerStatus", GuildRosterFrame, "UIMenuButtonStretchTemplate")
    b3:SetSize(80,18)
    b3.value = "playerStatus"
    b3:SetText(PLAYER_STATUS)
    b3:SetPoint("TOPRIGHT", b2, "TOPLEFT", -2, 0)

    --		local b4 = CreateFrame("Button", "GRB_totalxp", GuildRosterFrame, "UIMenuButtonStretchTemplate")
    --		b4:SetSize(80,20)
    --		b4.value = "totalxp"
    --		b4:SetText("全部活跃值")
    --		b4:SetPoint("TOPRIGHT", b1, "BOTTOMRIGHT", 0, -2)
    --
    --		local b5 = CreateFrame("Button", "GRB_weeklyxp", GuildRosterFrame, "UIMenuButtonStretchTemplate")
    --		b5:SetSize(80,20)
    --		b5.value = "weeklyxp"
    --		b5:SetText("周活跃值")
    --		b5:SetPoint("TOPRIGHT", b2, "BOTTOMRIGHT", 0, -2)

    local b4 = CreateFrame("Button", "GRB_reputation", GuildRosterFrame, "UIMenuButtonStretchTemplate")
    b4:SetSize(80,20)
    b4.value = "reputation"
    b4:SetText(GUILD_REPUTATION)
    b4:SetPoint("TOPRIGHT", b3, "BOTTOMRIGHT", 0, -2)

    local b5 = CreateFrame("Button", "GRB_achievement", GuildRosterFrame, "UIMenuButtonStretchTemplate")
    b5:SetSize(80,20)
    b5.value = "achievement"
    b5:SetText(ACHIEVEMENTS)
    b5:SetPoint("TOPRIGHT", b2, "BOTTOMRIGHT", 0, -2)

    if IsAddOnLoaded("GuildRoles") then
        local b6 = CreateFrame("Button", "GRB_roles", GuildRosterFrame, "UIMenuButtonStretchTemplate")
        b6:SetSize(80,20)
        b6.value = "roles"
        b6:SetText("职责")
        b6:SetPoint("TOPRIGHT", b1, "BOTTOMRIGHT", 0, -2)
    end

    local function OnLoad()
        if not tContains(VIEWS, GetCVar("guildRosterView")) then
            SetCVar("guildRosterView", "playerStatus")
        end
        recent = _G["GRB_"..GetCVar("guildRosterView")]
        if recent then
            recent:LockHighlight()
        end
    end

    local function Update(self)
        if not recent then
            OnLoad()
        end

        GuildRosterViewDropdown_OnClick(self)

        if recent then
            recent:UnlockHighlight()
            self:LockHighlight()
        end

        recent = self
    end

    b1:SetScript("OnClick", Update)
    b2:SetScript("OnClick", Update)
    b3:SetScript("OnClick", Update)
    b4:SetScript("OnClick", Update)
    b5:SetScript("OnClick", Update)
    if GRB_roles then
        GRB_roles:SetScript("OnClick", Update)
    end
    OnLoad()
end)

end