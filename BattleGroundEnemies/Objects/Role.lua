local AddonName, Data = ...
local BattleGroundEnemies = BattleGroundEnemies
local L = Data.L
local GetTexCoordsForRoleSmallCircle = GetTexCoordsForRoleSmallCircle

local defaultSettings = {
	Enabled = true,
	Parent = "healthBar",
	Width = 12,
	Height = 12,
	ActivePoints = 1,
	Points = {
		{
			Point = "TOPLEFT",
			RelativeFrame = "healthBar",
			RelativePoint = "TOPLEFT",
			OffsetX = 2,
			OffsetY = -2,
		},
	},
}

local role = BattleGroundEnemies:NewButtonModule({
	moduleName = "Role",
	localizedModuleName = ROLE,
	defaultSettings = defaultSettings,
	options = nil,
	events = {"PlayerDetailsChanged"},
	expansions = {WOW_PROJECT_MAINLINE}
})

function role:AttachToPlayerButton(playerButton)
	playerButton.Role = CreateFrame("Frame", nil, playerButton)
	playerButton.Role.Icon = playerButton.Role:CreateTexture(nil, 'OVERLAY')
	playerButton.Role.Icon:SetAllPoints()

	playerButton.Role.ApplyAllSettings = function(self)
		self:PlayerDetailsChanged()
	end

	playerButton.Role.PlayerDetailsChanged = function(self)
		if playerButton.PlayerSpecName then
			self.Icon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES")
			self.Icon:SetTexCoord(GetTexCoordsForRoleSmallCircle(playerButton.PlayerRoleID))
		end
	end
end