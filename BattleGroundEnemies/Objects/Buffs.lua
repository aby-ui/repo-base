local BattleGroundEnemies = BattleGroundEnemies
local addonName, Data = ...
BattleGroundEnemies.Objects.Buffs = {}




function BattleGroundEnemies.Objects.Buffs.New(playerButton)

	
	local BuffContainer = BattleGroundEnemies.Objects.Auras.NewAuraContainer(playerButton)

	BuffContainer.ApplySettings = function(self)
		local conf = playerButton.bgSizeConfig
		
		--self:ApplyBackdrop(conf.Auras_Buffs_Container_BorderThickness)

		for identifier, buffFrame in pairs(self.Active) do
			buffFrame:ApplyBuffFrameSettings(buffFrame)
		end
	
		for identifier, buffFrame in pairs(self.Inactive) do
			buffFrame:ApplyBuffFrameSettings(buffFrame)
		end
		
		self:SetContainerPosition()
	end
	
	BuffContainer.AuraPositioning = function(self)
		local conf = playerButton.bgSizeConfig
		self:Positioning(conf.Auras_Buffs_Size, conf.Auras_Buffs_VerticalGrowdirection, conf.Auras_Buffs_HorizontalGrowDirection, conf.Auras_Buffs_IconsPerRow, conf.Auras_Buffs_HorizontalSpacing, conf.Auras_Buffs_VerticalSpacing)
	end
	
	BuffContainer.SetContainerPosition = function(self)
		local conf = playerButton.bgSizeConfig
		self:SetPosition(conf.Auras_Buffs_Container_Point, conf.Auras_Buffs_Container_RelativeTo, conf.Auras_Buffs_Container_RelativePoint, conf.Auras_Buffs_Container_OffsetX, conf.Auras_Buffs_Container_OffsetY)
	end
	
	BuffContainer.DisplayAura = function (self, spellID, srcName, amount, duration, endTime, debuffType)
		local identifier = spellID..srcName
		local conf = playerButton.bgSizeConfig
		
		local auraFrame = self.Active[identifier]
		if not auraFrame then 
			auraFrame = self.Inactive[#self.Inactive] 
			if auraFrame then --recycle a previous used Frame
				tremove(self.Inactive, #self.Inactive)
				auraFrame:Show()
			end
		end
		if not auraFrame then 		
			auraFrame = self:NewAuraFrame()

			auraFrame.ApplyBuffFrameSettings = function(self)
				
				self.Stacks:SetTextColor(unpack(conf.Auras_Buffs_Textcolor))
				self.Stacks:ApplyFontStringSettings(conf.Auras_Buffs_Fontsize, conf.Auras_Buffs_Outline, conf.Auras_Buffs_EnableTextshadow, conf.Auras_Buffs_TextShadowcolor)
				self.Cooldown:ApplyCooldownSettings(conf.Auras_Buffs_ShowNumbers, true, false)
				self.Cooldown.Text:ApplyFontStringSettings(conf.Auras_Buffs_Cooldown_Fontsize, conf.Auras_Buffs_Cooldown_Outline, conf.Auras_Buffs_Cooldown_EnableTextshadow, conf.Auras_Buffs_Cooldown_TextShadowcolor)
				self:SetSize(conf.Auras_Buffs_Size, conf.Auras_Buffs_Size)
			end
			auraFrame:ApplyBuffFrameSettings()
		end
		auraFrame.Identifier = identifier
		auraFrame.SpellID = spellID
		auraFrame.Type = debuffType
		auraFrame.Icon:SetTexture(GetSpellTexture(spellID))
		if amount > 1 then
			auraFrame.Stacks:SetText(amount)
		else
			auraFrame.Stacks:SetText()
		end
		auraFrame.Cooldown:SetCooldown(endTime - duration, duration)
		--BattleGroundEnemies:Debug("SetCooldown", endTime - duration, duration)
		auraFrame:Show()
		self.Active[identifier] = auraFrame
		self:AuraPositioning()
	end
	

	return BuffContainer
end


