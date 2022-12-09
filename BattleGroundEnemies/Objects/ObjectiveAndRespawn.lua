local BattleGroundEnemies = BattleGroundEnemies
local AddonName, Data = ...
local GetTime = GetTime
local GetSpellTexture = GetSpellTexture

local L = Data.L

local defaultSettings = {
	Enabled = true,
	Parent = "Button",
	Width = 36,
	ActivePoints = 2,
	Points = {
		{
			Point = "TOPRIGHT",
			RelativeFrame = "TargetIndicatorNumeric",
			RelativePoint = "TOPLEFT",
			OffsetX = -2
		},
		{
			Point = "BOTTOMRIGHT",
			RelativeFrame = "TargetIndicatorNumeric",
			RelativePoint = "BOTTOMLEFT",
			OffsetX = -2
		}
	},
	Cooldown = {
		ShowNumber = true,
		FontSize = 12,
		FontOutline = "OUTLINE",
		EnableShadow = false,
		ShadowColor = {0, 0, 0, 1},
	},
	Text = {
		FontSize = 17,
		FontOutline = "THICKOUTLINE",
		FontColor = {1, 1, 1, 1},
		EnableShadow = false,
		ShadowColor = {0, 0, 0, 1}
	}
}

local options = function(location)
	return {
		TextSettings = {
			type = "group",
			name = L.TextSettings,
			inline = true,
			order = 4,
			get = function(option)
				return Data.GetOption(location.Text, option)
			end,
			set = function(option, ...)
				return Data.SetOption(location.Text, option, ...)
			end,
			args = Data.AddNormalTextSettings(location.Text)
		},
		CooldownTextSettings = {
			type = "group",
			name = L.Countdowntext,
			inline = true,
			get = function(option)
				return Data.GetOption(location.Cooldown, option)
			end,
			set = function(option, ...)
				return Data.SetOption(location.Cooldown, option, ...)
			end,
			order = 2,
			args = Data.AddCooldownSettings(location.Cooldown)
		}
	}
end

local objectiveAndRespawn = BattleGroundEnemies:NewButtonModule({
	moduleName = "ObjectiveAndRespawn",
	localizedModuleName = L.ObjectiveAndRespawnTimer,
	defaultSettings = defaultSettings,
	options = options,
	events = {"ShouldQueryAuras", "CareAboutThisAura", "BeforeFullAuraUpdate", "NewAura", "UnitDied", "ArenaOpponentShown", "ArenaOpponentHidden"},
	enabledInThisExpansion = true
})

function objectiveAndRespawn:AttachToPlayerButton(playerButton)
	local frame = CreateFrame("frame", nil, playerButton)
	frame:SetFrameLevel(playerButton:GetFrameLevel()+5)

	frame.Icon = frame:CreateTexture(nil, "BORDER")
	frame.Icon:SetAllPoints()

	frame:SetScript("OnSizeChanged", function(self, width, height)
		BattleGroundEnemies.CropImage(self.Icon, width, height)
	end)
	frame:Hide()

	frame.AuraText = BattleGroundEnemies.MyCreateFontString(frame)
	frame.AuraText:SetAllPoints()
	frame.AuraText:SetJustifyH("CENTER")

	frame.Cooldown = BattleGroundEnemies.MyCreateCooldown(frame)
	frame.Cooldown:Hide()


	frame.Cooldown:SetScript("OnCooldownDone", function()
		frame:Reset()
	end)
	-- ObjectiveAndRespawn.Cooldown:SetScript("OnCooldownDone", function()
	-- 	ObjectiveAndRespawn:Reset()
	-- end)

	function frame:Reset()
		self:Hide()
		self.Icon:SetTexture()
		if self.AuraText:GetFont() then self.AuraText:SetText("") end
		self.ActiveRespawnTimer = false
	end


	function frame:ApplyAllSettings()
		local conf = self.config
		self.AuraText:ApplyFontStringSettings(conf.Text)
		self.Cooldown:ApplyCooldownSettings(conf.Cooldown, true, true, {0, 0, 0, 0.75})
	end
	function frame:SearchForDebuffs(aura)
		--BattleGroundEnemies:Debug("Läüft")
		local battleGroundDebuffs = BattleGroundEnemies.BattleGroundDebuffs
		local value
		if battleGroundDebuffs then
			for i = 1, #battleGroundDebuffs do
				if aura.spellId == battleGroundDebuffs[i] then
					if BattleGroundEnemies.CurrentMapID == 417 then -- 417 is Kotmogu, we scan for orb debuffs
	
						if aura.points and type(aura.points) == "table" then
							if aura.points[2] then
								if not self.Value then
									--BattleGroundEnemies:Debug("hier")
									--player just got the debuff
									self.Icon:SetTexture(GetSpellTexture(aura.spellId))
									self:Show()
									--BattleGroundEnemies:Debug("Texture set")
								end
								value = aura.points[2]
									--values for orb debuff:
									--BattleGroundEnemies:Debug(value1, value2, value3, value4)
									-- value1 = Reduces healing received by value1
									-- value2 = Increases damage taken by value2
									-- value3 = Increases damage done by value3
							end
						end
						--kotmogu
						
						--end of kotmogu
	
					else
						-- not kotmogu
						value = aura.applications
					end
					if value ~= self.Value then
						self.AuraText:SetText(value)
						self.Value = value
					end
					self.continue = false
					return
				end
			end
		end
	end

	function frame:ShouldQueryAuras(unitID, filter)
		if BattleGroundEnemies.ArenaIDToPlayerButton[unitID] then
			return filter == "HARMFUL"
		else
			return false
		end
	end


	function frame:CareAboutThisAura(unitID, filter, aura)
		if BattleGroundEnemies.ArenaIDToPlayerButton[unitID] then -- this player is shown on the arena frame and is carrying a flag, orb, etc..
			local bgDebuffs = BattleGroundEnemies.BattleGroundDebuffs
			if bgDebuffs then

				for i = 1, #bgDebuffs do
					if aura.spellId == bgDebuffs[i] then
						return true
					end
				end
			end
		end
	end

	function frame:BeforeFullAuraUpdate(filter)
		if filter == "HARMFUL" then
			self.continue = true
		end
	end

	function frame:NewAura(unitID, filter, aura)
		if filter ~= "HARMFUL" then return end
		if not self.continue then return end

		if not BattleGroundEnemies.ArenaIDToPlayerButton[unitID] then return end -- This player is not shown on arena enemy so we dont care
		if BattleGroundEnemies.BattleGroundDebuffs then self:SearchForDebuffs(aura) end
	end

	function frame:UnitDied()
		if (BattleGroundEnemies.IsRatedBG or (BattleGroundEnemies.Testmode.Active and BattleGroundEnemies.BGSize == 15)) then
		--BattleGroundEnemies:Debug("UnitIsDead SetCooldown")
			if not self.ActiveRespawnTimer then
				self:Show()
				self.Icon:SetTexture(GetSpellTexture(8326))
				self.AuraText:SetText("")
				self.ActiveRespawnTimer = true
			end
			self.Cooldown:SetCooldown(GetTime(), 26) --overwrite an already active timer
		end
	end

	function frame:ArenaOpponentShown()
		if BattleGroundEnemies.BattlegroundBuff then
			--BattleGroundEnemies:Debug(self:Getframe().PlayerDetails.PlayerName, "has buff")
			self.Icon:SetTexture(GetSpellTexture(BattleGroundEnemies.BattlegroundBuff[playerButton.PlayerIsEnemy and BattleGroundEnemies.EnemyFaction or BattleGroundEnemies.AllyFaction]))
			self:Show()
		end

		self.AuraText:SetText("")
		self.Value = false
	end

	function frame:ArenaOpponentHidden()
		self:Reset()
	end
	playerButton.ObjectiveAndRespawn = frame
end