function Party_Spellbar_OnLoad(self)
    self:SetID(self:GetParent():GetID())
    self:SetFrameStrata("MEDIUM")
    RaiseFrameLevel(self)

    self.unit = "party"..self:GetID()
    CastingBarFrame_OnLoad(self, self.unit, false)

    local barIcon = self.Icon
    barIcon:Show()

    SetPartySpellbarAspect(self)
end

function SetPartySpellbarAspect(self)
    self:SetScale(0.9)
    local frameText = getglobal(self:GetName().."Text")
    if (frameText) then
        --frameText:SetTextHeight(15)
        --frameText:ClearAllPoints()
        --frameText:SetPoint("TOP", self, "TOP", 0, 4)
    end

    local frameBorder = getglobal(self:GetName().."Border")
    if (frameBorder) then
        --frameBorder:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border-Small")
        --frameBorder:SetWidth(156)
        --frameBorder:SetHeight(49)
        --frameBorder:ClearAllPoints()
        --frameBorder:SetPoint("TOP", self, "TOP", 0, 20)
    end

    local frameFlash = getglobal(self:GetName().."Flash")
    if (frameFlash) then
        --frameFlash:SetTexture("Interface\\CastingBar\\UI-CastingBar-Flash-Small")
        --frameFlash:SetWidth(156)
        --frameFlash:SetHeight(49)
        --frameFlash:ClearAllPoints()
        --frameFlash:SetPoint("TOP", self, "TOP", 0, 20)
    end
end

-- 施法条的位置
function Party_Spellbar_OnShow(self)
    self:ClearAllPoints()
    if (UnitIsConnected(self.unit) and UnitExists("partypet"..self:GetID()) and SHOW_PARTY_PETS == "1") then
        self:SetPoint("BOTTOM", self:GetParent(), "BOTTOM", 2, -21);
    else
        self:SetPoint("BOTTOM", self:GetParent(), "BOTTOM", 2, -7);
    end
end

function Party_Spellbar_OnEvent(self, event, arg1, ...)
    local newevent = event
    local newarg1 = arg1

    if (event == "CVAR_UPDATE") then
        if (self.casting or self.channeling) then
            self:Show()
        else
            self:Hide()
        end
        return
    elseif (event == "GROUP_ROSTER_UPDATE" and not IsInRaid()) or (event == "PARTY_MEMBER_ENABLE") or (event == "PARTY_MEMBER_DISABLE") or (event == "PARTY_LEADER_CHANGED") then
        -- check if the new target is casting a spell
        local nameChannel = UnitChannelInfo(self.unit)
        local nameSpell = UnitCastingInfo(self.unit)

        if (nameChannel) then
            newevent = "UNIT_SPELLCAST_CHANNEL_START"
            newarg1 = "party"..self:GetID()
        elseif (nameSpell) then
            newevent = "UNIT_SPELLCAST_START"
            newarg1 = "party"..self:GetID()
        else
            self.casting = nil
            self.channeling = nil
            self:SetMinMaxValues(0, 0)
            self:SetValue(0)
            self:Hide()
            return
        end

    end
    CastingBarFrame_OnEvent(self, newevent, newarg1, ...)
end

function PartyCast_Toggle(switch)
    local self;
    if (switch) then
        for i=1, 4 do
            self = getglobal("PartyFrame" .. i .. "SpellBar");
            self:RegisterEvent("GROUP_ROSTER_UPDATE");
            self:RegisterEvent("PARTY_MEMBER_ENABLE");
            self:RegisterEvent("PARTY_MEMBER_DISABLE");
            self:RegisterEvent("PARTY_LEADER_CHANGED");
            self:RegisterEvent("UNIT_SPELLCAST_START");
            self:RegisterEvent("UNIT_SPELLCAST_STOP");
            self:RegisterEvent("UNIT_SPELLCAST_FAILED");
            self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED");
            self:RegisterEvent("UNIT_SPELLCAST_DELAYED");
            self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START");
            self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE");
            self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
            self:RegisterEvent("PLAYER_ENTERING_WORLD");
            self:RegisterEvent("CVAR_UPDATE");
        end
    else
        for i=1, 4 do
            self = getglobal("PartyFrame" .. i .. "SpellBar");
            self:UnregisterEvent("GROUP_ROSTER_UPDATE");
            self:UnregisterEvent("PARTY_MEMBER_ENABLE");
            self:UnregisterEvent("PARTY_MEMBER_DISABLE");
            self:UnregisterEvent("PARTY_LEADER_CHANGED");
            self:UnregisterEvent("UNIT_SPELLCAST_START");
            self:UnregisterEvent("UNIT_SPELLCAST_STOP");
            self:UnregisterEvent("UNIT_SPELLCAST_FAILED");
            self:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED");
            self:UnregisterEvent("UNIT_SPELLCAST_DELAYED");
            self:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START");
            self:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE");
            self:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
            self:UnregisterEvent("PLAYER_ENTERING_WORLD");
            self:Hide();
        end
    end
end