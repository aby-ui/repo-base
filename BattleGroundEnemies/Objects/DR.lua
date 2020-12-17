local BattleGroundEnemies = BattleGroundEnemies
local addonName, Data = ...
BattleGroundEnemies.Objects.DR = {}
local DRList = LibStub("DRList-1.0")

local dRstates = {
	[1] = { 0, 1, 0, 1}, --green (next cc in DR time will be only half duration)
	[2] = { 1, 1, 0, 1}, --yellow (next cc in DR time will be only 1/4 duration)
	[3] = { 1, 0, 0, 1}, --red (next cc in DR time will not apply, player is immune)
}

local function drFrameUpdateStatusBorder(drFrame)
	drFrame:SetBackdropBorderColor(unpack(dRstates[drFrame.status] or dRstates[3]))
end

local function drFrameUpdateStatusText(drFrame)
	drFrame.Cooldown.Text:SetTextColor(unpack(dRstates[drFrame.status] or dRstates[3]))
end	

function BattleGroundEnemies.Objects.DR.New(playerButton)


	local DRContainer = CreateFrame("Frame", nil, playerButton, BackdropTemplateMixin and "BackdropTemplate")
	DRContainer:SetPoint("TOPRIGHT", playerButton, "TOPLEFT", -1, 0)
	DRContainer:SetPoint("BOTTOMRIGHT", playerButton, "BOTTOMLEFT", -1, 0)
	DRContainer:SetBackdrop({
		bgFile = "Interface/Buttons/WHITE8X8", --drawlayer "BACKGROUND"
		edgeFile = 'Interface/Buttons/WHITE8X8', --drawlayer "BORDER"
		edgeSize = 1
	})
	DRContainer:SetBackdropColor(0, 0, 0, 0)
	DRContainer.DR = {}

	DRContainer.ApplySettings = function(self)
		self:ApplyBackdrop(playerButton.bgSizeConfig.DrTracking_Container_BorderThickness)
		self:SetPosition()
		
		for drCategory, drFrame in pairs(self.DR) do
			drFrame:ApplyDrFrameSettings()
			drFrame:ChangeDisplayType()
		end	
	end
	
	DRContainer.Reset = function(self)
		for drCategory, drFrame in pairs(self.DR) do
			drFrame.Cooldown:Clear()
		end	
	end
	
	DRContainer.SetPosition = function(self)
		BattleGroundEnemies.SetBasicPosition(self, playerButton.bgSizeConfig.DrTracking_Container_BasicPoint, playerButton.bgSizeConfig.DrTracking_Container_RelativeTo, playerButton.bgSizeConfig.DrTracking_Container_RelativePoint, playerButton.bgSizeConfig.DrTracking_Container_OffsetX)
	end


	DRContainer.SetWidthOfAuraFrames = function(self, height)
		local borderThickness = playerButton.bgSizeConfig.DrTracking_Container_BorderThickness
		for drCategorie, drFrame in pairs(self.DR) do
			drFrame:SetWidth(height - borderThickness * 2)
		end
	end
	


	DRContainer.DisplayDR = function(self, drCat, spellID, additionalDuration)
		local drFrame = self.DR[drCat]
		if not drFrame then  --create a new frame for this categorie
			
			drFrame = CreateFrame("Frame", nil, self, BackdropTemplateMixin and "BackdropTemplate")
			
			drFrame.Container = self
			
			drFrame.ApplyDrFrameSettings = function(self)
				local conf = playerButton.bgSizeConfig
				
				self.Cooldown:ApplyCooldownSettings(conf.DrTracking_ShowNumbers, false, false)
				self.Cooldown.Text:ApplyFontStringSettings(conf.DrTracking_Cooldown_Fontsize, conf.DrTracking_Cooldown_Outline, conf.DrTracking_Cooldown_EnableTextshadow, conf.DrTracking_Cooldown_TextShadowcolor)
			
			end



			drFrame.ChangeDisplayType = function(self)
				self:SetDisplayType()
				
				--reset settings
				self.Cooldown.Text:SetTextColor(1, 1, 1, 1)
				self:SetBackdropBorderColor(0, 0, 0, 0)
				if self.status ~= 0 then self:SetStatus() end
			end

			drFrame.IncreaseDRState = function(self)
				self.status = self.status + 1
				self:SetStatus()
			end

			drFrame.SetDisplayType = function(self)
				if playerButton.bgSizeConfig.DrTracking_DisplayType == "Frame" then
					self.SetStatus = drFrameUpdateStatusBorder
				else
					self.SetStatus = drFrameUpdateStatusText
				end
			end
			
			drFrame:SetWidth(playerButton.bgSizeConfig.BarHeight - playerButton.bgSizeConfig.DrTracking_Container_BorderThickness * 2)

			drFrame:SetBackdropColor(0, 0, 0, 0)
			drFrame:SetBackdropBorderColor(0, 0, 0, 0)

			drFrame.Icon = drFrame:CreateTexture(nil, "BORDER", nil, -1) -- -1 to make it behind the SetBackdrop bg
			drFrame.Icon:SetAllPoints()
			
			drFrame.Cooldown = BattleGroundEnemies.MyCreateCooldown(drFrame)
			drFrame.Cooldown:SetScript("OnHide", function()
				drFrame:Hide()
				drFrame.status = 0
				self:DrPositioning() --self = DRContainer
			end)
			
			drFrame.status = 0
			
			drFrame:SetDisplayType()
			drFrame:ApplyDrFrameSettings()
			
			drFrame:Hide()
			
			self.DR[drCat] = drFrame
		end						
		
		if not drFrame:IsShown() then
			drFrame:Show()
			self:DrPositioning()
		end
		drFrame.Icon:SetTexture(GetSpellTexture(spellID))
		drFrame.Cooldown:SetCooldown(GetTime(), DRList:GetResetTime(drCat) + additionalDuration)
	end

	DRContainer.DrPositioning = function(self)
		local config = playerButton.bgSizeConfig
		local spacing = config.DrTracking_HorizontalSpacing
		local borderThickness = config.DrTracking_Container_BorderThickness
		local growLeft = config.DrTracking_GrowDirection == "leftwards"
		local barHeight = config.BarHeight
		local anchor = self
		local totalWidth = 0
		self:Show()
		if growLeft then
			for categorie, drFrame in pairs(self.DR) do
				if drFrame:IsShown() then
					if totalWidth == 0 then
						drFrame:SetPoint("TOPRIGHT", anchor, "TOPRIGHT", -borderThickness, -borderThickness)
						drFrame:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", -borderThickness, borderThickness)
					else
						drFrame:SetPoint("TOPRIGHT", anchor, "TOPLEFT", -spacing, 0)
						drFrame:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMLEFT", -spacing, 0)
					end
					anchor = drFrame
					totalWidth = totalWidth + spacing + barHeight - 2 * borderThickness
				end
			end
		else
			for categorie, drFrame in pairs(self.DR) do
				if drFrame:IsShown() then
					if totalWidth == 0 then
						drFrame:SetPoint("TOPLEFT", anchor, "TOPLEFT", borderThickness, -borderThickness)
						drFrame:SetPoint("BOTTOMLEFT", anchor, "BOTTOMLEFT", borderThickness, borderThickness)
					else
						drFrame:SetPoint("TOPLEFT", anchor, "TOPRIGHT", spacing, 0)
						drFrame:SetPoint("BOTTOMLEFT", anchor, "BOTTOMRIGHT", spacing, 0)
					end
					anchor = drFrame
					totalWidth = totalWidth + spacing + barHeight - 2 * borderThickness
				end
			end
		end
		if totalWidth == 0 then
			self:Hide()
			self:SetWidth(0.001)
		else
			totalWidth = totalWidth + 2 * borderThickness - spacing
			self:SetWidth(totalWidth)
		end
	end

	DRContainer.ApplyBackdrop = function(self, borderThickness)
		self:SetBackdropColor(0, 0, 0, 0)
		self:SetBackdropBorderColor(unpack(playerButton.bgSizeConfig.DrTracking_Container_Color))
		self:SetWidthOfAuraFrames(playerButton.bgSizeConfig.BarHeight)
		self:DrPositioning()
	end
	return DRContainer
end
