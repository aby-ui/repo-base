local AddonName, Data = ...
local BattleGroundEnemies = BattleGroundEnemies
local L = Data.L

local CreateFrame = CreateFrame
local GetTime = GetTime
local GameTooltip = GameTooltip
local GetSpellTexture = GetSpellTexture



local defaultSettings = {
	Enabled = true,
	Parent = "Button",
	UseButtonHeightAsHeight = true,
	UseButtonHeightAsWidth = true,
	Cooldown = {
		ShowNumber = true,
		FontSize = 12,
		FontOutline = "OUTLINE",
		EnableShadow = false,
		ShadowColor = {0, 0, 0, 1},
	},
	Filtering_Enabled = false,
	Filtering_Filterlist = {}, --key = spellId, value = spellName or false
}

local options = function(location)
	return {
		CooldownTextSettings = {
			type = "group",
			name = L.Countdowntext,
			inline = true,
			get = function(option)
				return Data.GetOption(location.Cooldown, option)
			end,
			set = function(option, ...)
				return Data.SetOption(location.Cooldown, option, ...)
			end,
			order = 1,
			args = Data.AddCooldownSettings(location.Cooldown)
		},
		RacialFilteringSettings = {
			type = "group",
			name = FILTER,
			desc = L.RacialFilteringSettings_Desc,
			--inline = true,
			order = 2,
			args = {
				Filtering_Enabled = {
					type = "toggle",
					name = L.Filtering_Enabled,
					desc = L.RacialFiltering_Enabled_Desc,
					width = 'normal',
					order = 1
				},
				Fake = Data.AddHorizontalSpacing(2),
				Filtering_Filterlist = {
					type = "multiselect",
					name = L.Filtering_Filterlist,
					desc = L.RacialFiltering_Filterlist_Desc,
					disabled = function() return not location.Filtering_Enabled end,
					get = function(option, key)
						for spellId in pairs(Data.RacialNameToSpellIDs[key]) do
							return location.Filtering_Filterlist[spellId]
						end
					end,
					set = function(option, key, state) -- value = spellname
						for spellId in pairs(Data.RacialNameToSpellIDs[key]) do
							location.Filtering_Filterlist[spellId] = state or nil
						end
					end,
					values = Data.Racialnames,
					order = 3
				}
			}
		}
	}
end

local racial = BattleGroundEnemies:NewButtonModule({
	moduleName = "Racial",
	localizedModuleName = L.Racial,
	defaultSettings = defaultSettings,
	options = options,
	events = {"SPELL_CAST_SUCCESS"},
	enabledInThisExpansion = true
})

function racial:AttachToPlayerButton(playerButton)

	local frame = CreateFrame("frame", nil, playerButton)
	-- trinket
	frame:HookScript("OnEnter", function(self)
		if self.spellId then
			BattleGroundEnemies:ShowTooltip(self, function()
				GameTooltip:SetSpellByID(self.spellId)
			end)
		end
	end)

	frame:HookScript("OnLeave", function(self)
		if GameTooltip:IsOwned(self) then
			GameTooltip:Hide()
		end
	end)

	function frame:Reset()
		self.spellId = false
		self.Icon:SetTexture(nil)
		self.Cooldown:Clear()	--reset Trinket Cooldown
	end

	function frame:ApplyAllSettings()
		local moduleSettings = self.config
		self.Cooldown:ApplyCooldownSettings(moduleSettings.Cooldown, false, true, {0, 0, 0, 0.5})
	end


	frame.Icon = frame:CreateTexture()
	frame.Icon:SetAllPoints()
	frame:SetScript("OnSizeChanged", function(self, width, height)
		BattleGroundEnemies.CropImage(self.Icon, width, height)
	end)

	frame.Cooldown = BattleGroundEnemies.MyCreateCooldown(frame)

	function frame:RacialCheck(spellId)
		if not Data.RacialSpellIDtoCooldown[spellId] then return end
		local config = frame.config
		local insi = playerButton.Trinket


		if Data.RacialSpellIDtoCooldown[spellId].trinketCD and not (insi.spellId == 336128) and insi.spellId and insi.Cooldown:GetCooldownDuration() < Data.RacialSpellIDtoCooldown[spellId].trinketCD * 1000 then
			insi.Cooldown:SetCooldown(GetTime(), Data.RacialSpellIDtoCooldown[spellId].trinketCD)
		end

		if config.RacialFiltering_Enabled and not config.RacialFiltering_Filterlist[spellId] then return end

		self.spellId = spellId
		self.Icon:SetTexture(GetSpellTexture(spellId))
		self.Cooldown:SetCooldown(GetTime(), Data.RacialSpellIDtoCooldown[spellId].cd)
	end

	function frame:SPELL_CAST_SUCCESS(srcName, destName, spellId)
		self:RacialCheck(spellId)
	end
	playerButton.Racial = frame
end