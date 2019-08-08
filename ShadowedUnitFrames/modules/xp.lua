local XP = {}
local L = ShadowUF.L
ShadowUF:RegisterModule(XP, "xpBar", L["XP/Rep bar"], true)

local function OnEnter(self)
	if( self.tooltip ) then
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
		GameTooltip:SetText(self.tooltip)
	end
end

local function OnLeave(self)
	GameTooltip:Hide()
end

function XP:OnEnable(frame)
	if( not frame.xpBar ) then
		frame.xpBar = CreateFrame("Frame", nil, frame)
		frame.xpBar:SetScript("OnEnter", OnEnter)
		frame.xpBar:SetScript("OnLeave", OnLeave)
		frame.xpBar:EnableMouse(true)

		frame.xpBar.xp = ShadowUF.Units:CreateBar(frame.xpBar)
		frame.xpBar.xp:SetPoint("BOTTOMLEFT", frame.xpBar)
		frame.xpBar.xp:SetPoint("BOTTOMRIGHT", frame.xpBar)

		if( frame.unitType == "player" ) then
			frame.xpBar.rep = ShadowUF.Units:CreateBar(frame.xpBar)
			frame.xpBar.rep:SetPoint("TOPLEFT", frame.xpBar)
			frame.xpBar.rep:SetPoint("TOPRIGHT", frame.xpBar)
		end

		frame.xpBar.rested = CreateFrame("StatusBar", nil, frame.xpBar.xp)
		frame.xpBar.rested:SetFrameLevel(frame.xpBar.xp:GetFrameLevel() - 1)
		frame.xpBar.rested:SetAllPoints(frame.xpBar.xp)
	end

	frame:RegisterNormalEvent("ENABLE_XP_GAIN", self, "Update")
	frame:RegisterNormalEvent("DISABLE_XP_GAIN", self, "Update")

	if( frame.unitType == "player" ) then
		frame:RegisterNormalEvent("PLAYER_XP_UPDATE", self, "Update")
		frame:RegisterNormalEvent("UPDATE_EXHAUSTION", self, "Update")
		frame:RegisterNormalEvent("PLAYER_LEVEL_UP", self, "Update")
		frame:RegisterNormalEvent("UPDATE_FACTION", self, "Update")
	else
		frame:RegisterNormalEvent("UNIT_PET_EXPERIENCE", self, "Update")
		frame:RegisterUnitEvent("UNIT_LEVEL", self, "Update")
	end

	frame:RegisterUpdateFunc(self, "Update")
end

function XP:OnDisable(frame)
	frame:UnregisterAll(self)
end

function XP:OnLayoutApplied(frame)
	if( frame.visibility.xpBar ) then
		frame.xpBar.xp:SetStatusBarTexture(ShadowUF.Layout.mediaPath.statusbar)
		frame.xpBar.xp:SetStatusBarColor(ShadowUF.db.profile.xpColors.normal.r, ShadowUF.db.profile.xpColors.normal.g, ShadowUF.db.profile.xpColors.normal.b, ShadowUF.db.profile.bars.alpha)

		frame.xpBar.xp.background:SetVertexColor(ShadowUF.db.profile.xpColors.normal.r, ShadowUF.db.profile.xpColors.normal.g, ShadowUF.db.profile.xpColors.normal.b, ShadowUF.db.profile.bars.backgroundAlpha)
		frame.xpBar.xp.background:SetTexture(ShadowUF.Layout.mediaPath.statusbar)

		frame.xpBar.rested:SetStatusBarTexture(ShadowUF.Layout.mediaPath.statusbar)
		frame.xpBar.rested:SetStatusBarColor(ShadowUF.db.profile.xpColors.rested.r, ShadowUF.db.profile.xpColors.rested.g, ShadowUF.db.profile.xpColors.rested.b, ShadowUF.db.profile.bars.alpha)

		if( frame.xpBar.rep ) then
			frame.xpBar.rep:SetStatusBarTexture(ShadowUF.Layout.mediaPath.statusbar)
			frame.xpBar.rep.background:SetTexture(ShadowUF.Layout.mediaPath.statusbar)
		end
	end
end

-- Format 5000 into 5,000
local function formatNumber(number)
	local found
	while( true ) do
		number, found = string.gsub(number, "^(-?%d+)(%d%d%d)", "%1,%2")
		if( found == 0 ) then break end
	end

	return number
end

function XP:UpdateRep(frame)
	if( not frame.xpBar.rep ) then return end
	local name, reaction, min, max, current = GetWatchedFactionInfo()
	if( not name ) then
		frame.xpBar.rep:Hide()
		return
	end

	-- Blizzard stores faction info related to Exalted, not your current level, so get more mathier to find the current reputation using the current standing tier
	current = math.abs(min - current)
	max = math.abs(min - max)

	local color = FACTION_BAR_COLORS[reaction]
	frame.xpBar.rep:SetMinMaxValues(0, max)
	frame.xpBar.rep:SetValue(current)
	frame.xpBar.rep.tooltip = string.format(L["%s (%s): %s/%s (%.2f%% done)"], name, GetText("FACTION_STANDING_LABEL" .. reaction, UnitSex("player")), formatNumber(current), formatNumber(max), (max > 0 and current / max or 0) * 100)
	frame.xpBar.rep:SetStatusBarColor(color.r, color.g, color.b, ShadowUF.db.profile.bars.alpha)
	frame.xpBar.rep.background:SetVertexColor(color.r, color.g, color.b, ShadowUF.db.profile.bars.backgroundAlpha)
	frame.xpBar.rep:Show()
end

function XP:UpdateXP(frame)
	-- At the level cap or XP is disabled, or the pet is actually a vehicle right now, swap to reputation bar (or hide it)
	if( UnitLevel(frame.unitOwner) == MAX_PLAYER_LEVEL or IsXPUserDisabled() or ( frame.unitOwner == "pet" and UnitExists("vehicle") ) ) then
		frame.xpBar.xp:Hide()
		return
	end

	local current, max
	if( frame.unitOwner == "player" ) then
		current, max = UnitXP(frame.unitOwner), UnitXPMax(frame.unitOwner)
	else
		current, max = GetPetExperience()
	end

	local min = math.min(0, current)
	frame.xpBar.xp:SetMinMaxValues(min, max)
	frame.xpBar.xp:SetValue(current)
	frame.xpBar.xp:Show()

	if( frame.unitOwner == "player" and GetXPExhaustion() ) then
		frame.xpBar.rested:SetMinMaxValues(min, max)
		frame.xpBar.rested:SetValue(math.min(current + GetXPExhaustion(), max))
		frame.xpBar.rested:Show()
		frame.xpBar.xp.tooltip = string.format(L["Level %s - %s: %s/%s (%.2f%% done), %s rested."], UnitLevel(frame.unitOwner), UnitLevel(frame.unitOwner) + 1, formatNumber(current), formatNumber(max), (max > 0 and current / max or 0) * 100, formatNumber(GetXPExhaustion()))
	else
		frame.xpBar.rested:Hide()
		frame.xpBar.xp.tooltip = string.format(L["Level %s - %s: %s/%s (%.2f%% done)"], UnitLevel(frame.unitOwner), UnitLevel(frame.unitOwner) + 1, formatNumber(current), formatNumber(max), (max > 0 and current / max or 0) * 100)
	end
end

function XP:Update(frame)
	self:UpdateRep(frame)
	self:UpdateXP(frame)

	if( ( not frame.xpBar.rep or not frame.xpBar.rep:IsShown() ) and not frame.xpBar.xp:IsShown() ) then
		ShadowUF.Layout:SetBarVisibility(frame, "xpBar", false)
		return
	end

	ShadowUF.Layout:SetBarVisibility(frame, "xpBar", true)
	if( frame.xpBar.rep and frame.xpBar.rep:IsVisible() and frame.xpBar.xp:IsVisible() ) then
		frame.xpBar.rep:SetHeight(frame.xpBar:GetHeight() * 0.48)
		frame.xpBar.xp:SetHeight(frame.xpBar:GetHeight() * 0.48)
		frame.xpBar.tooltip = frame.xpBar.rep.tooltip .. "\n" .. frame.xpBar.xp.tooltip

	elseif( frame.xpBar.rep and frame.xpBar.rep:IsVisible() ) then
		frame.xpBar.rep:SetHeight(frame.xpBar:GetHeight())
		frame.xpBar.tooltip = frame.xpBar.rep.tooltip

	elseif( frame.xpBar.xp:IsVisible() ) then
		frame.xpBar.xp:SetHeight(frame.xpBar:GetHeight())
		frame.xpBar.tooltip = frame.xpBar.xp.tooltip
	end
end
