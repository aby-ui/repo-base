local BattleGroundEnemies = BattleGroundEnemies
local addonName, Data = ...
BattleGroundEnemies.Objects.Trinket = {}

function BattleGroundEnemies.Objects.Trinket.New(playerButton)
				-- trinket
	local Trinket = CreateFrame("Frame", nil, playerButton)

	
	Trinket.Icon = Trinket:CreateTexture()
	Trinket.Icon:SetAllPoints()
	Trinket:SetScript("OnSizeChanged", function(self, width, height)
		BattleGroundEnemies.CropImage(self.Icon, width, height)
	end)
	
	Trinket.Cooldown = BattleGroundEnemies.MyCreateCooldown(Trinket)

	Trinket.ApplySettings = function(self)
		local conf = playerButton.bgSizeConfig
		-- trinket
		self:Enable()
		self:SetPosition()
		self.Cooldown:ApplyCooldownSettings(conf.Trinket_ShowNumbers, false, true, {0, 0, 0, 0.75})
		self.Cooldown.Text:ApplyFontStringSettings(conf.Trinket_Cooldown_Fontsize, conf.Trinket_Cooldown_Outline, conf.Trinket_Cooldown_EnableTextshadow, conf.Trinket_Cooldown_TextShadowcolor)
	end
	
	Trinket.Enable = function(self)
		if playerButton.bgSizeConfig.Trinket_Enabled then
			self:Show()
			self:SetWidth(playerButton.bgSizeConfig.Trinket_Width)
		else
			--dont SetWidth before Hide() otherwise it won't work as aimed
			self:Hide()
			self:SetWidth(0.01)
		end
	end
	
	Trinket.TrinketCheck = function(self, spellID, setCooldown)
		if not playerButton.bgSizeConfig.Trinket_Enabled then return end
		if not Data.TriggerSpellIDToTrinketnumber[spellID] then return end
		self:DisplayTrinket(spellID, setCooldown and Data.TrinketTriggerSpellIDtoCooldown[spellID] or false)
	end
	
	Trinket.DisplayTrinket = function(self, spellID, cooldown)
		self.HasTrinket = Data.TriggerSpellIDToTrinketnumber[spellID]
		self.Icon:SetTexture(Data.TriggerSpellIDToDisplayFileId[spellID])
		if cooldown then
			self.Cooldown:SetCooldown(GetTime(), cooldown)
		end
	end
	
	Trinket.Reset = function(self)
		self.HasTrinket = nil
		self.Icon:SetTexture(nil)
		self.Cooldown:Clear()	--reset Trinket Cooldown
	end

	Trinket.SetPosition = function(self)
		BattleGroundEnemies.SetBasicPosition(self, playerButton.bgSizeConfig.Trinket_BasicPoint, playerButton.bgSizeConfig.Trinket_RelativeTo, playerButton.bgSizeConfig.Trinket_RelativePoint, playerButton.bgSizeConfig.Trinket_OffsetX)
	end
	return Trinket
end
