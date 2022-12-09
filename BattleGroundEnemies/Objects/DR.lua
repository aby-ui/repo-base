local AddonName, Data = ...
local BattleGroundEnemies = BattleGroundEnemies
local L = Data.L

local LSM = LibStub("LibSharedMedia-3.0")


local GetSpellTexture = GetSpellTexture
local CreateFrame = CreateFrame
local BackdropTemplateMixin = BackdropTemplateMixin
local GameTooltip = GameTooltip

local IsClassic = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC



local DRList = LibStub("DRList-1.0")

local defaultSettings = {
	Enabled = true,
	Parent = "Button",
	ActivePoints = 1,
	DisplayType = "Frame",
	IconSize = 20,
	Cooldown = {
		ShowNumber = true,
		FontSize = 12,
		FontOutline = "OUTLINE",
		EnableShadow = false,
		ShadowColor = {0, 0, 0, 1},
	},
	Container = {
		UseButtonHeightAsSize = true,
		IconSize = 15,
		IconsPerRow = 10,
		HorizontalGrowDirection = "rightwards",
		HorizontalSpacing = 2,
		VerticalGrowdirection = "downwards",
		VerticalSpacing = 1,
	},
	Filtering_Enabled = false,
	Filtering_Filterlist = {},
}

local options = function(location)
	return {
		ContainerSettings = {
			type = "group",
			name = L.ContainerSettings,
			order = 1,
			get = function(option)
				return Data.GetOption(location.Container, option)
			end,
			set = function(option, ...)
				return Data.SetOption(location.Container, option, ...)
			end,
			args = Data.AddContainerSettings(location.Container),
		},
		DisplayType = {
			type = "select",
			name = L.DisplayType,
			desc = L.DrTracking_DisplayType_Desc,
			values = Data.DisplayType,
			order = 2
		},
		CooldownTextSettings = {
			type = "group",
			name = L.Countdowntext,
			get = function(option)
				return Data.GetOption(location.Cooldown, option)
			end,
			set = function(option, ...)
				return Data.SetOption(location.Cooldown, option, ...)
			end,
			order = 3,
			args = Data.AddCooldownSettings(location.Cooldown)
		},
		Fake1 = Data.AddVerticalSpacing(6),
		FilteringSettings = {
			type = "group",
			name = FILTER,
			--desc = L.DrTrackingFilteringSettings_Desc,
			--inline = true,
			order = 4,
			args = {
				Filtering_Enabled = {
					type = "toggle",
					name = L.Filtering_Enabled,
					desc = L.DrTrackingFiltering_Enabled_Desc,
					width = 'normal',
					order = 1
				},
				Filtering_Filterlist = {
					type = "multiselect",
					name = L.Filtering_Filterlist,
					desc = L.DrTrackingFiltering_Filterlist_Desc,
					disabled = function() return not location.Filtering_Enabled end,
					get = function(option, key)
						return location.Filtering_Filterlist[key]
					end,
					set = function(option, key, state) -- key = category name
						location.Filtering_Filterlist[key] = state or nil
					end,
					values = Data.DrCategorys,
					order = 2
				}
			}
		}
	}
end

local dRstates = {
	[1] = { 0, 1, 0, 1}, --green (next cc in DR time will be only half duration)
	[2] = { 1, 1, 0, 1}, --yellow (next cc in DR time will be only 1/4 duration)
	[3] = { 1, 0, 0, 1}, --red (next cc in DR time will not apply, player is immune)
}

local function drFrameUpdateStatusBorder(drFrame)
	drFrame:SetBackdropBorderColor(unpack(dRstates[drFrame:GetStatus()]))
end

local function drFrameUpdateStatusText(drFrame)
	drFrame.Cooldown.Text:SetTextColor(unpack(dRstates[drFrame:GetStatus()]))
end

local flags = {
	HasDynamicSize = true
}

local dRTracking = BattleGroundEnemies:NewButtonModule({
	moduleName = "DRTracking",
	localizedModuleName = L.DRTracking,
	flags = flags,
	defaultSettings = defaultSettings,
	options = options,
	events = {"AuraRemoved"},
	enabledInThisExpansion = true
})

local function createNewDrFrame(playerButton, container)
	local drFrame = CreateFrame("Frame", nil, container, BackdropTemplateMixin and "BackdropTemplate")
	drFrame.Cooldown = BattleGroundEnemies.MyCreateCooldown(drFrame)

	drFrame.Cooldown:SetScript("OnCooldownDone", function()
		drFrame:Remove()
	end)
	drFrame:HookScript("OnEnter", function(self)
		BattleGroundEnemies:ShowTooltip(self, function()
			if IsClassic then return end
			GameTooltip:SetSpellByID(self.spellId)
		end)
	end)

	drFrame:HookScript("OnLeave", function(self)
		if GameTooltip:IsOwned(self) then
			GameTooltip:Hide()
		end
	end)

	drFrame.Container = container

	drFrame.ApplyChildFrameSettings = function(self)
		self.Cooldown:ApplyCooldownSettings(container.config.Cooldown, false, false)
		self:SetDisplayType()
	end

	drFrame.GetStatus = function(self)
		local status = self.input.status
		status = (math.min(status, 3))
		return status
	end

	drFrame.SetDisplayType = function(self)
		if container.config.DisplayType == "Frame" then
			self.SetStatus = drFrameUpdateStatusBorder
		else
			self.SetStatus = drFrameUpdateStatusText
		end

		self.Cooldown.Text:SetTextColor(1, 1, 1, 1)
		self:SetBackdropBorderColor(0, 0, 0, 0)
		if self.input and self.input.status ~= 0 then self:SetStatus() end
	end

	drFrame:SetBackdrop({
		bgFile = "Interface/Buttons/WHITE8X8", --drawlayer "BACKGROUND"
		edgeFile = 'Interface/Buttons/WHITE8X8', --drawlayer "BORDER"
		edgeSize = 1
	})

	drFrame:SetBackdropColor(0, 0, 0, 0)
	drFrame:SetBackdropBorderColor(0, 0, 0, 0)

	drFrame.Icon = drFrame:CreateTexture(nil, "BORDER", nil, -1) -- -1 to make it behind the SetBackdrop bg
	drFrame.Icon:SetAllPoints()

	drFrame:ApplyChildFrameSettings()

	drFrame:Hide()
	return drFrame
end

local function setupDrFrame(container, drFrame, drDetails)
	drFrame:SetStatus()

	drFrame.spellId = drDetails.spellId
	drFrame.Icon:SetTexture(IsClassic and GetSpellTexture(DRList.spells[drDetails.spellName].spellId) or GetSpellTexture(drDetails.spellId))
	local duration = DRList:GetResetTime(drDetails.drCat)
	drFrame.Cooldown:SetCooldown(drDetails.startTime, duration)
end

function dRTracking:AttachToPlayerButton(playerButton)
	local container = BattleGroundEnemies:NewContainer(playerButton, createNewDrFrame, setupDrFrame)
	--frame:SetBackdropColor(0, 0, 0, 0)

	function container:AuraRemoved(spellId, spellName)
		local config = self.config
		--BattleGroundEnemies:Debug(operation, spellId)

		local drCat = DRList:GetCategoryBySpellID(IsClassic and spellName or spellId)

		if not drCat then return end

		local drTrackingEnabled = not config.Filtering_Enabled or config.Filtering_Filterlist[drCat]

		if drTrackingEnabled then
			local input = self:FindInputByAttribute("drCat", drCat)
			if input then
				input = self:UpdateInput(input, {spellId = spellId})
			else
				input = self:NewInput({
					drCat = drCat,
					spellId = spellId
				})
			end

			input.status = (input.status or 0) + 1
			
			input.startTime = GetTime()
			self:Display()
		end
	end

	playerButton.DRTracking = container
end
