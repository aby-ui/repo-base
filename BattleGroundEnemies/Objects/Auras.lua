-- shared functions for buffs and debuffs (similar behaviour)
local BattleGroundEnemies = BattleGroundEnemies
local addonName, Data = ...
BattleGroundEnemies.Objects.Auras = {}


function BattleGroundEnemies.Objects.Auras.NewAuraContainer(playerButton)

	local AuraContainer = CreateFrame("Frame", nil, playerButton)
	AuraContainer.Active = {}
	AuraContainer.Inactive = {}

	AuraContainer:SetScript("OnHide", function(self) 
		self:SetWidth(0.001)
		self:SetHeight(0.001)
	end)
	
	AuraContainer:Hide()
	-- AuraContainer:Show()
	-- AuraContainer:SetBackdrop({
		-- bgFile = "Interface/Buttons/WHITE8X8", --drawlayer "BACKGROUND"
		-- edgeFile = 'Interface/Buttons/WHITE8X8', --drawlayer "BORDER"
		-- edgeSize = 1
	-- })
	-- AuraContainer:SetBackdropColor(1, 1, 1, 1)
	--AuraContainer:SetSize(50,50)
	
	AuraContainer.NewAuraFrame = function(self)
		local auraFrame = CreateFrame('Frame', nil, self, BackdropTemplateMixin and "BackdropTemplate")
		auraFrame:SetFrameLevel(self:GetFrameLevel() + 5)
		
		
		auraFrame:SetScript("OnEnter", function(self)
			if playerButton.bgSizeConfig.Auras_ShowTooltips then
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 0)
				GameTooltip:SetSpellByID(self.SpellID)
			end
		end)
		
		auraFrame:SetScript("OnLeave", function(self)
			if GameTooltip:IsOwned(self) then
				GameTooltip:Hide()
			end
		end)
			
		auraFrame.Icon = auraFrame:CreateTexture(nil, "BACKGROUND")
		auraFrame.Icon:SetAllPoints()

		auraFrame.Stacks = BattleGroundEnemies.MyCreateFontString(auraFrame)
		auraFrame.Stacks:SetAllPoints()
		auraFrame.Stacks:SetJustifyH("RIGHT")
		auraFrame.Stacks:SetJustifyV("BOTTOM")

		auraFrame.Cooldown = BattleGroundEnemies.MyCreateCooldown(auraFrame)
		auraFrame.Cooldown:SetScript("OnHide", function() 
			auraFrame.Stacks:SetText("")
			auraFrame:Hide()
			auraFrame.Active[auraFrame.Identifier] = nil
			auraFrame.Container:AuraPositioning()
			auraFrame.Inactive[#auraFrame.Inactive + 1] = auraFrame
		end)
		

		auraFrame.Container = self
		auraFrame.Active = self.Active
		auraFrame.Inactive = self.Inactive
		
		auraFrame.Icon:SetDrawLayer("BORDER", -1) -- 1 to make it behind the SetBackdrop bg

		auraFrame:SetBackdrop({
			bgFile = "Interface/Buttons/WHITE8X8", --drawlayer "BACKGROUND"
			edgeFile = 'Interface/Buttons/WHITE8X8', --drawlayer "BORDER"
			edgeSize = 1
		})
		
		auraFrame:SetBackdropColor(0, 0, 0, 0)
		auraFrame:SetBackdropBorderColor(0, 0, 0, 0)
		return auraFrame
	end
	
	AuraContainer.SetPosition = function(self, point, relativeTo, relativePoint, offsetX, offsetY)
		self:ClearAllPoints()
		if relativeTo == "Button" then 
			relativeTo = playerButton
		else
			relativeTo = playerButton[relativeTo]
		end
		self:SetPoint(point, relativeTo, relativePoint, offsetX, offsetY)
	end
	
	AuraContainer.SetIconSize = function(self, size)	
		for identifier, auraFrame in pairs(self.Active) do
			auraFrame:SetSize(size, size)
		end
		for identifier, auraFrame in pairs(self.Inactive) do
			auraFrame:SetSize(size, size)
		end
		self:AuraPositioning()
	end
	
	AuraContainer.Reset = function(self)
		for identifier, auraFrame in pairs(self.Active) do
			auraFrame.Cooldown:Clear()
		end
	end
	
	AuraContainer.Positioning = function(self, iconSize, verticalGrowdirection, horizontalGrowdirection, framesPerRow, horizontalSpacing, verticalSpacing)
		local growLeft = horizontalGrowdirection == "leftwards"
		local growUp = verticalGrowdirection == "upwards"
		local previousFrame = self
		self:Show()
		local framesInRow = 0
		local count = 0
		local firstFrameInRow
		local lastFrameInRow
		local width = 0
		local height = 0
		if growLeft then
			if growUp then
				for Identifier, auraFrame in pairs(self.Active) do
					auraFrame:ClearAllPoints()
					if framesInRow <= framesPerRow then
						if count == 0 then
							auraFrame:SetPoint("BOTTOMRIGHT", previousFrame, "BOTTOMRIGHT", 0, 0)
							firstFrameInRow = auraFrame
						else
							auraFrame:SetPoint("RIGHT", previousFrame, "LEFT", -horizontalSpacing, 0)
						end
						framesInRow = framesInRow + 1
						width = width + iconSize + horizontalSpacing
					else
						auraFrame:SetPoint("BOTTOM", firstFrameInRow, "TOP", 0, verticalSpacing)
						framesInRow = 1
						firstFrameInRow = auraFrame
						lastFrameInRow = previousFrame
						height = height + iconSize + verticalSpacing
					end
					previousFrame = auraFrame
					count = count + 1
				end
			else
				for Identifier, auraFrame in pairs(self.Active) do
					auraFrame:ClearAllPoints()
					if framesInRow < framesPerRow then
						if framesInRow == 0 then
							if count == 0 then
								auraFrame:SetPoint("TOPRIGHT", previousFrame, "TOPRIGHT", 0, 0)
								firstFrameInRow = auraFrame
							end
						else
							auraFrame:SetPoint("RIGHT", previousFrame, "LEFT", -horizontalSpacing, 0)
						end
						framesInRow = framesInRow + 1
					else
						auraFrame:SetPoint("TOP", firstFrameInRow, "BOTTOM", 0, -verticalSpacing)
						framesInRow = 1
						firstFrameInRow = auraFrame
						lastFrameInRow = previousFrame
					end
					previousFrame = auraFrame
					count = count + 1
				end
			end
		else
			if growUp then
				for Identifier, auraFrame in pairs(self.Active) do
					auraFrame:ClearAllPoints()
					if framesInRow < framesPerRow then
						if framesInRow == 0 then
							if count == 0 then
								auraFrame:SetPoint("BOTTOMLEFT", previousFrame, "BOTTOMLEFT", 0, 0)
								firstFrameInRow = auraFrame
							end
						else
							auraFrame:SetPoint("LEFT", previousFrame, "RIGHT", horizontalSpacing, 0)
						end
						framesInRow = framesInRow + 1
					else
						auraFrame:SetPoint("BOTTOM", firstFrameInRow, "TOP", 0, verticalSpacing)
						framesInRow = 1
						firstFrameInRow = auraFrame
						lastFrameInRow = previousFrame
					end
					previousFrame = auraFrame
					count = count + 1
				end
			else
				for Identifier, auraFrame in pairs(self.Active) do
					auraFrame:ClearAllPoints()
					if framesInRow < framesPerRow then
						if framesInRow == 0 then
							if count == 0 then
								auraFrame:SetPoint("TOPLEFT", previousFrame, "TOPLEFT", 0, 0)
								firstFrameInRow = auraFrame
							end
						else
							auraFrame:SetPoint("LEFT", previousFrame, "RIGHT", horizontalSpacing, 0)
						end
						framesInRow = framesInRow + 1
					else
						auraFrame:SetPoint("TOP", firstFrameInRow, "BOTTOM", 0, -verticalSpacing)
						framesInRow = 1
						firstFrameInRow = auraFrame
						lastFrameInRow = previousFrame
					end
					previousFrame = auraFrame
					count = count + 1
				end
			end
		end
		if width == 0 then 
			self:Hide()
		else
			self:SetWidth(width - horizontalSpacing)
			self:SetHeight(height + iconSize)
		end
	end
	
	return AuraContainer
end
