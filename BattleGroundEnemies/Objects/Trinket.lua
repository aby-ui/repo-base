local BattleGroundEnemies = BattleGroundEnemies
local AddonName, Data = ...
local GetTime = GetTime

BattleGroundEnemies.Objects.Trinket = {}

function BattleGroundEnemies.Objects.Trinket.New(playerButton)
				-- trinket
	local Trinket = CreateFrame("Frame", nil, playerButton)

	Trinket:HookScript("OnEnter", function(self)
		if self.SpellID then
			BattleGroundEnemies:ShowTooltip(self, function() 
				GameTooltip:SetSpellByID(self.SpellID)
			end)
		end
	end)
	
	Trinket:HookScript("OnLeave", function(self)
		if GameTooltip:IsOwned(self) then
			GameTooltip:Hide()
		end
	end)

	
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
		self:DisplayTrinket(spellID, Data.TriggerSpellIDToDisplayFileId[spellID])
		if setCooldown then
			self:SetTrinketCooldown(GetTime(), Data.TrinketTriggerSpellIDtoCooldown[spellID] or 0)
		end
	end
	
	Trinket.DisplayTrinket = function(self, spellID, texture)
		self.SpellID = spellID
		self.HasTrinket = Data.TriggerSpellIDToTrinketnumber[spellID]
		self.Icon:SetTexture(texture)
	end

	Trinket.SetTrinketCooldown = function(self, startTime, duration)
		if (startTime ~= 0 and duration ~= 0) then
			self.Cooldown:SetCooldown(startTime, duration)
		else
			self.Cooldown:Clear()
		end
	end
	
	Trinket.Reset = function(self)
		self.HasTrinket = nil
		self.SpellID = false
		self.Icon:SetTexture(nil)
		self.Cooldown:Clear()	--reset Trinket Cooldown
	end

	Trinket.SetPosition = function(self)
		BattleGroundEnemies.SetBasicPosition(self, playerButton.bgSizeConfig.Trinket_BasicPoint, playerButton.bgSizeConfig.Trinket_RelativeTo, playerButton.bgSizeConfig.Trinket_RelativePoint, playerButton.bgSizeConfig.Trinket_OffsetX)
	end
	return Trinket
end
