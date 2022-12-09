local AddonName, Data = ...
local BattleGroundEnemies = BattleGroundEnemies
local LSM = LibStub("LibSharedMedia-3.0")
local L = Data.L

local CompactUnitFrame_UpdateHealPrediction = CompactUnitFrame_UpdateHealPrediction

local HealthTextTypes = {
	health = COMPACT_UNIT_FRAME_PROFILE_HEALTHTEXT_HEALTH,
	losthealth = COMPACT_UNIT_FRAME_PROFILE_HEALTHTEXT_LOSTHEALTH,
	perc = COMPACT_UNIT_FRAME_PROFILE_HEALTHTEXT_PERC
}

local defaultSettings = {
	Parent = "Button",
	Enabled = true,
	Texture = 'Blizzard Raid Bar',
	Background = {0, 0, 0, 0.66},
	HealthPrediction_Enabled = true,
	HealthTextEnabled = false,
	HealthTextType = "health",
	HealthText = {
		FontSize = 17,
		FontOutline = "",
		FontColor = {1, 1, 1, 1},
		EnableShadow = false,
		ShadowColor = {0, 0, 0, 1},
		JustifyH = "CENTER",
		JustifyV = "TOP",
	},
	ActivePoints = 2,
	Points = {
		{
			Point = "BOTTOMLEFT",
			RelativeFrame = "Power",
			RelativePoint = "TOPLEFT",
		},
		{
			Point = "TOPRIGHT",
			RelativeFrame = "Button",
			RelativePoint = "TOPRIGHT",
		}
	}
}

local options = function(location)
	return {
		Texture = {
			type = "select",
			name = L.BarTexture,
			desc = L.HealthBar_Texture_Desc,
			dialogControl = 'LSM30_Statusbar',
			values = AceGUIWidgetLSMlists.statusbar,
			width = "normal",
			order = 1
		},
		Fake = Data.AddHorizontalSpacing(2),
		Background = {
			type = "color",
			name = L.BarBackground,
			desc = L.HealthBar_Background_Desc,
			hasAlpha = true,
			width = "normal",
			order = 3
		},
		Fake1 = Data.AddVerticalSpacing(4),
		HealthPrediction_Enabled = {
			type = "toggle",
			name = COMPACT_UNIT_FRAME_PROFILE_DISPLAYHEALPREDICTION,
			width = "normal",
			order = 5,
		},
		HealthTextEnabled = {
			type = "toggle",
			name = L.HealthTextEnabled,
			width = "normal",
			order = 6,
		},
		HealthTextType = {
			type = "select",
			name = L.HealthTextType,
			width = "normal",
			values = HealthTextTypes,
			disabled = function() return not location.HealthTextEnabled end,
			order = 7,
		},
		HealthText = {
			type = "group",
			name = L.HealthTextSettings,
			get = function(option)
				return Data.GetOption(location.HealthText, option)
			end,
			set = function(option, ...)
				return Data.SetOption(location.HealthText, option, ...)
			end,
			disabled = function() return not location.HealthTextEnabled end,
			inline = true,
			order = 8,
			args = Data.AddNormalTextSettings(location.HealthText)
		}
	}
end

local healthBar = BattleGroundEnemies:NewButtonModule({
	moduleName = "healthBar",
	localizedModuleName = L.HealthBar,
	defaultSettings = defaultSettings,
	options = options,
	events = {"UpdateHealth", "PlayerDetailsChanged"},
	enabledInThisExpansion = true
})


function healthBar:AttachToPlayerButton(playerButton)
	playerButton.healthBar = CreateFrame('StatusBar', nil, playerButton)
	playerButton.healthBar:SetMinMaxValues(0, 1)

	playerButton.healthBar.HealthText = BattleGroundEnemies.MyCreateFontString(playerButton.healthBar)
	playerButton.healthBar.HealthText:SetPoint("BOTTOMLEFT", playerButton.healthBar, "BOTTOMLEFT", 3, 3)
	playerButton.healthBar.HealthText:SetPoint("TOPRIGHT", playerButton.healthBar, "TOPRIGHT", -3, -3)

	playerButton.myHealPrediction = playerButton.healthBar:CreateTexture(nil, "BORDER", nil, 5)
	playerButton.myHealPrediction:ClearAllPoints();
	playerButton.myHealPrediction:SetColorTexture(1,1,1);
	if playerButton.myHealPrediction.SetGradientAlpha then --this only exists until Dragonflight. 10.0 In dragonflight this :SetGradientAlpha got merged into SetGradient and CreateColor is required
		playerButton.myHealPrediction:SetGradient("VERTICAL", 8/255, 93/255, 72/255, 11/255, 136/255, 105/255);
	else
		playerButton.myHealPrediction:SetGradient("VERTICAL", CreateColor(8/255, 93/255, 72/255, 1), CreateColor(11/255, 136/255, 105/255, 1));
	end
	playerButton.myHealPrediction:SetVertexColor(0.0, 0.659, 0.608);


	playerButton.myHealAbsorb = playerButton.healthBar:CreateTexture(nil, "ARTWORK", nil, 1)
	playerButton.myHealAbsorb:ClearAllPoints();
	playerButton.myHealAbsorb:SetTexture("Interface\\RaidFrame\\Absorb-Fill", true, true);

	playerButton.myHealAbsorbLeftShadow = playerButton.healthBar:CreateTexture(nil, "ARTWORK", nil, 1)
	playerButton.myHealAbsorbLeftShadow:ClearAllPoints();

	playerButton.myHealAbsorbRightShadow = playerButton.healthBar:CreateTexture(nil, "ARTWORK", nil, 1)
	playerButton.myHealAbsorbRightShadow:ClearAllPoints();

	playerButton.otherHealPrediction = playerButton.healthBar:CreateTexture(nil, "BORDER", nil, 5)
	playerButton.otherHealPrediction:SetColorTexture(1,1,1);
	if playerButton.otherHealPrediction.SetGradientAlpha then
		playerButton.otherHealPrediction:SetGradient("VERTICAL", 11/255, 53/255, 43/255, 21/255, 89/255, 72/255);
	else
		playerButton.otherHealPrediction:SetGradient("VERTICAL", CreateColor(11/255, 53/255, 43/255, 1), CreateColor(21/255, 89/255, 72/255, 1));
	end
	


	playerButton.totalAbsorbOverlay = playerButton.healthBar:CreateTexture(nil, "BORDER", nil, 6)
	playerButton.totalAbsorbOverlay:SetTexture("Interface\\RaidFrame\\Shield-Overlay", true, true);	--Tile both vertically and horizontally
	playerButton.totalAbsorbOverlay.tileSize = 20;

	playerButton.totalAbsorb = playerButton.healthBar:CreateTexture(nil, "BORDER", nil, 5)
	playerButton.totalAbsorb:SetTexture("Interface\\RaidFrame\\Shield-Fill");
	playerButton.totalAbsorb.overlay = playerButton.totalAbsorbOverlay
	playerButton.totalAbsorbOverlay:SetAllPoints(playerButton.totalAbsorb);

	playerButton.overAbsorbGlow = playerButton.healthBar:CreateTexture(nil, "ARTWORK", nil, 2)
	playerButton.overAbsorbGlow:SetTexture("Interface\\RaidFrame\\Shield-Overshield");
	playerButton.overAbsorbGlow:SetBlendMode("ADD");
	playerButton.overAbsorbGlow:SetPoint("BOTTOMLEFT", playerButton.healthBar, "BOTTOMRIGHT", -7, 0);
	playerButton.overAbsorbGlow:SetPoint("TOPLEFT", playerButton.healthBar, "TOPRIGHT", -7, 0);
	playerButton.overAbsorbGlow:SetWidth(16);
	playerButton.overAbsorbGlow:Hide()

	playerButton.overHealAbsorbGlow = playerButton.healthBar:CreateTexture(nil, "ARTWORK", nil, 2)
	playerButton.overHealAbsorbGlow:SetTexture("Interface\\RaidFrame\\Absorb-Overabsorb");
	playerButton.overHealAbsorbGlow:SetBlendMode("ADD");
	playerButton.overHealAbsorbGlow:SetPoint("BOTTOMRIGHT", playerButton.healthBar, "BOTTOMLEFT", 7, 0);
	playerButton.overHealAbsorbGlow:SetPoint("TOPRIGHT", playerButton.healthBar, "TOPLEFT", 7, 0);
	playerButton.overHealAbsorbGlow:SetWidth(16);
	playerButton.overHealAbsorbGlow:Hide()


	playerButton.healthBar.Background = playerButton.healthBar:CreateTexture(nil, 'BACKGROUND', nil, 2)
	playerButton.healthBar.Background:SetAllPoints()
	playerButton.healthBar.Background:SetTexture("Interface/Buttons/WHITE8X8")



	playerButton.healthBar.UpdateHealthText = function(self, health, maxHealth)
		if health and maxHealth then
			local config = self.config
			if not config.HealthTextEnabled then return end
			if config.HealthTextType == "health" then
				health = AbbreviateLargeNumbers(health)
				self.HealthText:SetText(health);
				self.HealthText:Show()
			elseif config.HealthTextType == "losthealth" then
				local healthLost = maxHealth - health
				if ( healthLost > 0 ) then
					healthLost = AbbreviateLargeNumbers(healthLost)
					self.HealthText:SetText("-"..healthLost)
					self.HealthText:Show()
				else
					self.HealthText:Hide()
				end
			elseif (config.HealthTextType == "perc") and (maxHealth > 0) then
				local perc = math.ceil(100 * (health/maxHealth))
				self.HealthText:SetFormattedText("%d%%", perc);
				self.HealthText:Show()
			else
				self.HealthText:Hide()
			end
		else
			self.HealthText:Hide()
		end
	end
	--
	function playerButton.healthBar:UpdateHealth(unitID, health, maxHealth)
		self:SetMinMaxValues(0, maxHealth)
		self:SetValue(health)


		--next wo lines are needed for CompactUnitFrame_UpdateHealPrediction()

		self:UpdateHealthText(health, maxHealth)
		if unitID and CompactUnitFrame_UpdateHealPrediction then
			local config = self.config
			playerButton.displayedUnit = unitID
			playerButton.optionTable = {displayHealPrediction = config.HealthPrediction_Enabled}
			CompactUnitFrame_UpdateHealPrediction(playerButton)
		end
	end

	function playerButton.healthBar:PlayerDetailsChanged()
		local playerDetails = playerButton.PlayerDetails
		if not playerDetails then return end
		local color = playerDetails.PlayerClassColor
		self:SetStatusBarColor(color.r,color.g,color.b)
		self:SetMinMaxValues(0, 1)
		self:SetValue(1)
		self:UpdateHealthText(false, false)

		playerButton.totalAbsorbOverlay:Hide()
		playerButton.totalAbsorb:Hide()
	end

	function playerButton.healthBar:ApplyAllSettings()
		local config = self.config
		self:SetStatusBarTexture(LSM:Fetch("statusbar", config.Texture))--self.healthBar:SetStatusBarTexture(137012)
		self.Background:SetVertexColor(unpack(config.Background))
		if config.HealthTextEnabled then
			self.HealthText:Show()
		else
			self.HealthText:Hide()
		end

		self.HealthText:ApplyFontStringSettings(config.HealthText)
	end
end

