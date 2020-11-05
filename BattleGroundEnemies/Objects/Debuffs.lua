local BattleGroundEnemies = BattleGroundEnemies
local addonName, Data = ...
BattleGroundEnemies.Objects.Debuffs = {}

local DebuffTypeColor = DebuffTypeColor

local function debuffFrameUpdateStatusBorder(debuffFrame)
	local color = DebuffTypeColor[debuffFrame.Type or "none"]
	debuffFrame:SetBackdropBorderColor(color.r, color.g, color.b)
end

local function debuffFrameUpdateStatusText(debuffFrame)
	local color = DebuffTypeColor[debuffFrame.Type or "none"]
	debuffFrame.Cooldown.Text:SetTextColor(color.r, color.g, color.b)
end


function BattleGroundEnemies.Objects.Debuffs.New(playerButton)

	local DebuffContainer = BattleGroundEnemies.Objects.Auras.NewAuraContainer(playerButton)

	DebuffContainer.ApplySettings = function(self)
		local conf = playerButton.bgSizeConfig
		
		--self:ApplyBackdrop(conf.Auras_Debuffs_Container_BorderThickness)

		for identifier, debuffFrame in pairs(self.Active) do
			debuffFrame:ApplyDebuffFrameSettings(debuffFrame)
			debuffFrame:ChangeDisplayType()
		end
	
		for identifier, debuffFrame in pairs(self.Inactive) do
			debuffFrame:ApplyDebuffFrameSettings(debuffFrame)
			debuffFrame:ChangeDisplayType()
		end
		
		self:SetContainerPosition()
	end
	
	DebuffContainer.AuraPositioning = function(self)
		local conf = playerButton.bgSizeConfig
		self:Positioning(conf.Auras_Debuffs_Size, conf.Auras_Debuffs_VerticalGrowdirection, conf.Auras_Debuffs_HorizontalGrowDirection, conf.Auras_Debuffs_IconsPerRow, conf.Auras_Debuffs_HorizontalSpacing, conf.Auras_Debuffs_VerticalSpacing)
	end
	
	DebuffContainer.SetContainerPosition = function(self)
		local conf = playerButton.bgSizeConfig
		self:SetPosition(conf.Auras_Debuffs_Container_Point, conf.Auras_Debuffs_Container_RelativeTo, conf.Auras_Debuffs_Container_RelativePoint, conf.Auras_Debuffs_Container_OffsetX, conf.Auras_Debuffs_Container_OffsetY)
	end
	
	DebuffContainer.DisplayAura = function(self, spellID, srcName, amount, duration, endTime, debuffType)
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
			
			auraFrame.ApplyDebuffFrameSettings = function(self)
				local conf = playerButton.bgSizeConfig
				self.Stacks:SetTextColor(unpack(conf.Auras_Debuffs_Textcolor))
				self.Stacks:ApplyFontStringSettings(conf.Auras_Debuffs_Fontsize, conf.Auras_Debuffs_Outline, conf.Auras_Debuffs_EnableTextshadow, conf.Auras_Debuffs_TextShadowcolor)
				self.Cooldown:ApplyCooldownSettings(conf.Auras_Debuffs_ShowNumbers, true, false)
				self.Cooldown.Text:ApplyFontStringSettings(conf.Auras_Debuffs_Cooldown_Fontsize, conf.Auras_Debuffs_Cooldown_Outline, conf.Auras_Debuffs_Cooldown_EnableTextshadow, conf.Auras_Debuffs_Cooldown_TextShadowcolor)
				self:SetSize(conf.Auras_Debuffs_Size, conf.Auras_Debuffs_Size)
			end

			auraFrame.ChangeDisplayType = function(self)
				self:SetDisplayType()
				
				--reset settings
				self.Cooldown.Text:SetTextColor(1, 1, 1, 1)
				self:SetBackdropBorderColor(0, 0, 0, 0)
				if playerButton.bgSizeConfig.Auras_Debuffs_Coloring_Enabled then self:SetType() end
			end

			auraFrame.SetDisplayType = function(self)
				if playerButton.bgSizeConfig.Auras_Debuffs_DisplayType == "Frame" then
					self.SetType = debuffFrameUpdateStatusBorder
				else
					self.SetType = debuffFrameUpdateStatusText
				end
			end
			
			auraFrame:SetDisplayType()
			auraFrame:ApplyDebuffFrameSettings()
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
		if playerButton.bgSizeConfig.Auras_Debuffs_Coloring_Enabled then auraFrame:SetType() end
		auraFrame.Cooldown:SetCooldown(endTime - duration, duration)
		--BattleGroundEnemies:Debug("SetCooldown", endTime - duration, duration)
		auraFrame:Show()
		self.Active[identifier] = auraFrame
		self:AuraPositioning()
	end

	return DebuffContainer
end


