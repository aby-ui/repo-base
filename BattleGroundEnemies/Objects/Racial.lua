local BattleGroundEnemies = BattleGroundEnemies
local addonName, Data = ...
BattleGroundEnemies.Objects.Racial = {}

function BattleGroundEnemies.Objects.Racial.New(playerButton)
				-- trinket
	local Racial = CreateFrame("Frame", nil, playerButton)

	
	Racial.Icon = Racial:CreateTexture()
	Racial.Icon:SetAllPoints()
	Racial:SetScript("OnSizeChanged", function(self, width, height)
		BattleGroundEnemies.CropImage(self.Icon, width, height)
	end)
	
	Racial.Cooldown = BattleGroundEnemies.MyCreateCooldown(Racial)
	
	Racial.ApplySettings = function(self)
		local conf = playerButton.bgSizeConfig
		-- trinket
		self:Enable()
		self:SetPosition()
		self.Cooldown:ApplyCooldownSettings(conf.Racial_ShowNumbers, false, true, {0, 0, 0, 0.75})
		self.Cooldown.Text:ApplyFontStringSettings(conf.Racial_Cooldown_Fontsize, conf.Racial_Cooldown_Outline, conf.Racial_Cooldown_EnableTextshadow, conf.Racial_Cooldown_TextShadowcolor)
	end
	
	Racial.Enable = function(self)
		if playerButton.bgSizeConfig.Racial_Enabled then
			self:Show()
			self:SetWidth(playerButton.bgSizeConfig.Racial_Width)
		else
			--dont SetWidth before Hide() otherwise it won't work as aimed
			self:Hide()
			self:SetWidth(0.01)
		end
	end
	
	Racial.RacialUsed = function(self, spellID)
		local config = playerButton.bgSizeConfig
		
		if not config.Racial_Enabled then return end
		local insi = playerButton.Trinket
		
		if Data.RacialSpellIDtoCooldownTrigger[spellID] and not insi.HasTrinket == 4 and insi.Cooldown:GetCooldownDuration() < Data.RacialSpellIDtoCooldownTrigger[spellID] * 1000 then
			insi.Cooldown:SetCooldown(GetTime(), Data.RacialSpellIDtoCooldownTrigger[spellID])
		end
		
		if config.RacialFiltering_Enabled and not config.RacialFiltering_Filterlist[spellID] then return end
		
		self.Icon:SetTexture(Data.TriggerSpellIDToDisplayFileId[spellID])
		self.Cooldown:SetCooldown(GetTime(), Data.RacialSpellIDtoCooldown[spellID])
	end
	
	Racial.Reset = function(self)
		self.Icon:SetTexture(nil)
		self.Cooldown:Clear()	--reset Racial Cooldown
	end

	Racial.SetPosition = function(self)
		BattleGroundEnemies.SetBasicPosition(self, playerButton.bgSizeConfig.Racial_BasicPoint, playerButton.bgSizeConfig.Racial_RelativeTo, playerButton.bgSizeConfig.Racial_RelativePoint, playerButton.bgSizeConfig.Racial_OffsetX)
	end
	return Racial
end
