local AddonName, Data = ...
local BattleGroundEnemies = BattleGroundEnemies
local L = Data.L
local MaxLevel = GetMaxPlayerLevel()


local defaultSettings = {
	Enabled = false,
	Parent = "healthBar",
	UseButtonHeightAsHeight = true,
	ActivePoints = 1,
	Points = {
		{
			Point = "TOPLEFT",
			RelativeFrame = "Covenant",
			RelativePoint = "TOPRIGHT",
			OffsetX = 2,
			OffsetY = 2
		}
	},
	OnlyShowIfNotMaxLevel = true,
	Text = {
		FontSize = 18,
		FontOutline = "",
		FontColor = {1, 1, 1, 1},
		EnableShadow = false,
		ShadowColor = {0, 0, 0, 1},
		JustifyH = "LEFT"
	}
}

local options = function(location)
	return {
		OnlyShowIfNotMaxLevel = {
			type = "toggle",
			name = L.LevelText_OnlyShowIfNotMaxLevel,
			order = 2
		},
		LevelTextTextSettings = {
			type = "group",
			name = L.TextSettings,
			get = function(option)
				return Data.GetOption(location.Text, option)
			end,
			set = function(option, ...)
				return Data.SetOption(location.Text, option, ...)
			end,
			inline = true,
			order = 3,
			args = Data.AddNormalTextSettings(location.Text)
		}
	}
end

local level = BattleGroundEnemies:NewButtonModule({
	moduleName = "Level",
	localizedModuleName = LEVEL,
	defaultSettings = defaultSettings,
	options = options,
	events = {"UnitIdUpdate"},
	enabledInThisExpansion = true
})

function level:AttachToPlayerButton(playerButton)
	local fs = BattleGroundEnemies.MyCreateFontString(playerButton)

	function fs:DisplayLevel()
		if (not self.config.OnlyShowIfNotMaxLevel or (playerButton.PlayerLevel and playerButton.PlayerLevel < MaxLevel)) then
			self:SetText(MaxLevel - 1) -- to set the width of the frame (the name shoudl have the same space from the role icon/spec icon regardless of level shown)
			self:SetWidth(0)
			self:SetText(playerButton.PlayerLevel)
		else
			self:SetText("")
		end
	end

	-- Level

	function fs:PlayerDetailsChanged(playerDetails)
		if not playerDetails then return end
		if playerDetails.PlayerLevel then self:SetLevel(playerDetails.PlayerLevel) end --for testmode
	end

	function fs:UnitIdUpdate(unitID)
		if unitID then
			self:SetLevel(UnitLevel(unitID))
		end
	end


	function fs:SetLevel(level)
		if not playerButton.PlayerLevel or level ~= playerButton.PlayerLevel then
			playerButton.PlayerLevel = level
			
		end
		self:DisplayLevel()
	end

	function fs:ApplyAllSettings()
		self:ApplyFontStringSettings(self.config.Text)
		self:DisplayLevel()
	end
	playerButton.Level = fs
end