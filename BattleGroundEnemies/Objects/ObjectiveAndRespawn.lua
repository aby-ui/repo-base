local BattleGroundEnemies = BattleGroundEnemies
local addonName, Data = ...
BattleGroundEnemies.Objects.ObjectiveAndRespawn = {}


function BattleGroundEnemies.Objects.ObjectiveAndRespawn.New(playerButton)
	local ObjectiveAndRespawn = CreateFrame("Frame", nil, playerButton)
	ObjectiveAndRespawn = CreateFrame("Frame", nil, playerButton)
	ObjectiveAndRespawn:SetFrameLevel(playerButton:GetFrameLevel()+5)
	
	ObjectiveAndRespawn.Icon = ObjectiveAndRespawn:CreateTexture(nil, "BORDER")
	ObjectiveAndRespawn.Icon:SetAllPoints()
	
	ObjectiveAndRespawn:SetScript("OnSizeChanged", function(self, width, height)
		BattleGroundEnemies.CropImage(self.Icon, width, height)
	end)
	ObjectiveAndRespawn:Hide()
	
	ObjectiveAndRespawn.AuraText = BattleGroundEnemies.MyCreateFontString(ObjectiveAndRespawn)
	ObjectiveAndRespawn.AuraText:SetAllPoints()
	ObjectiveAndRespawn.AuraText:SetJustifyH("CENTER")
	
	ObjectiveAndRespawn.Cooldown = BattleGroundEnemies.MyCreateCooldown(ObjectiveAndRespawn)	
	ObjectiveAndRespawn.Cooldown:Hide()
	

	ObjectiveAndRespawn.Cooldown:SetScript("OnHide", function() 
		ObjectiveAndRespawn:Reset()
	end)
	ObjectiveAndRespawn:SetScript("OnHide", function(self) 
		--BattleGroundEnemies:Debug("ObjectiveAndRespawn hidden")
		self:SetWidth(0.01)
	end)
	
	ObjectiveAndRespawn:SetScript("OnShow", function(self) 
		--BattleGroundEnemies:Debug("ObjectiveAndRespawn shown")
		self:SetWidth(playerButton.bgSizeConfig.ObjectiveAndRespawn_Width)
	end)
	
	ObjectiveAndRespawn.SetPosition = function(self)
		BattleGroundEnemies.SetBasicPosition(self, playerButton.bgSizeConfig.ObjectiveAndRespawn_BasicPoint, playerButton.bgSizeConfig.ObjectiveAndRespawn_RelativeTo, playerButton.bgSizeConfig.ObjectiveAndRespawn_RelativePoint, playerButton.bgSizeConfig.ObjectiveAndRespawn_OffsetX)
	end
	
	ObjectiveAndRespawn.Reset = function(self)	
		self:Hide()
		self.Icon:SetTexture()
		self.AuraText:SetText("")
		self.ActiveRespawnTimer = false
	end
	
	ObjectiveAndRespawn.ApplySettings = function(self)
		if BattleGroundEnemies.BGSize == 15 then
			local conf = playerButton.bgSizeConfig
		
			self:SetWidth(conf.ObjectiveAndRespawn_Width)		
			
			self.AuraText:SetTextColor(unpack(conf.ObjectiveAndRespawn_Textcolor))
			self.AuraText:ApplyFontStringSettings(conf.ObjectiveAndRespawn_Fontsize, conf.ObjectiveAndRespawn_Outline, conf.ObjectiveAndRespawn_EnableTextshadow, conf.ObjectiveAndRespawn_TextShadowcolor)
			
			self.Cooldown:ApplyCooldownSettings(conf.ObjectiveAndRespawn_ShowNumbers, true, true, {0, 0, 0, 0.75})
			self.Cooldown.Text:ApplyFontStringSettings(conf.ObjectiveAndRespawn_Cooldown_Fontsize, conf.ObjectiveAndRespawn_Cooldown_Outline, conf.ObjectiveAndRespawn_Cooldown_EnableTextshadow, conf.ObjectiveAndRespawn_Cooldown_TextShadowcolor)
			
			self:SetPosition()
		
		
			self:SetWidth(conf.ObjectiveAndRespawn_Width)			
			
			self.AuraText:SetTextColor(unpack(conf.ObjectiveAndRespawn_Textcolor))
			self.AuraText:ApplyFontStringSettings(conf.ObjectiveAndRespawn_Fontsize, conf.ObjectiveAndRespawn_Outline, conf.ObjectiveAndRespawn_EnableTextshadow, conf.ObjectiveAndRespawn_TextShadowcolor)
			
			self.Cooldown:ApplyCooldownSettings(conf.ObjectiveAndRespawn_ShowNumbers, true, true, {0, 0, 0, 0.75})
			self.Cooldown.Text:ApplyFontStringSettings(conf.ObjectiveAndRespawn_Cooldown_Fontsize, conf.ObjectiveAndRespawn_Cooldown_Outline, conf.ObjectiveAndRespawn_Cooldown_EnableTextshadow, conf.ObjectiveAndRespawn_Cooldown_TextShadowcolor)
		end
	end

	ObjectiveAndRespawn.ShowObjective = function(self)
		if BattleGroundEnemies.BattlegroundBuff then
			--BattleGroundEnemies:Debug(self:GetParent().PlayerName, "has buff")
			self.Icon:SetTexture(GetSpellTexture(BattleGroundEnemies.BattlegroundBuff[playerButton.PlayerIsEnemy and BattleGroundEnemies.EnemyFaction or BattleGroundEnemies.AllyFaction]))
			self:Show()
		end
		
		self.AuraText:SetText("")
		self.Value = false
	end
		
	ObjectiveAndRespawn.PlayerDied = function(self)	
		--dead
		if (BattleGroundEnemies.IsRatedBG or BattleGroundEnemies.TestmodeActive) and playerButton.bgSizeConfig.ObjectiveAndRespawn_RespawnEnabled  then
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
	return ObjectiveAndRespawn
end
