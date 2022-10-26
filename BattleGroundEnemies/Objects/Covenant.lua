local AddonName, Data = ...
local BattleGroundEnemies = BattleGroundEnemies
local L = Data.L
local C_Covenants = C_Covenants

local CreateFrame = CreateFrame
local GameTooltip = GameTooltip

local defaultSettings = {
	Enabled = true,
	Parent = "healthBar",
	ActivePoints = 1,
	Points = {
		{
			Point = "TOPLEFT",
			RelativeFrame = "Role",
			RelativePoint = "TOPRIGHT",
		},
	},
	Width = 20,
	Height = 20
}

local covenant = BattleGroundEnemies:NewButtonModule({
	moduleName = "Covenant",
	localizedModuleName = L.Covenant,
	defaultSettings = defaultSettings,
	options = nil,
	events = nil,
	expansions = {WOW_PROJECT_MAINLINE}
})

function covenant:AttachToPlayerButton(playerButton)
-- Covenant Icon
	playerButton.Covenant = CreateFrame("Frame", nil, playerButton)

	playerButton.Covenant:HookScript("OnEnter", function(self)
		BattleGroundEnemies:ShowTooltip(self, function() 
			if self.covenantID then
				GameTooltip:SetText(C_Covenants.GetCovenantData(self.covenantID).name)
			end
		end)
	end)

	playerButton.Covenant:HookScript("OnLeave", function(self)
		if GameTooltip:IsOwned(self) then
			GameTooltip:Hide()
		end
	end)
	playerButton.Covenant.covenantID = false
	playerButton.Covenant.Icon = playerButton.Covenant:CreateTexture(nil, 'OVERLAY')
	playerButton.Covenant.Icon:SetAllPoints()

	playerButton.Covenant.DisplayCovenant = function(self, covenantID)
		self.covenantID = covenantID
		self.Icon:SetTexture(Data.CovenantIcons[covenantID])
		self:ApplyAllSettings()
	end

	playerButton.Covenant.Reset = function(self)
		self.covenantID = false
		self:Hide()
		self:SetSize(0.01, 0.01)
	end

	playerButton.Covenant.ApplyAllSettings = function(self)
		self:Show()
	end
end
