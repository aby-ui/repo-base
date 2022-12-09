local AddonName, Data = ...
local L = Data.L

local table_insert = table.insert

local GetSpellInfo = GetSpellInfo
local SpellGetVisibilityInfo = SpellGetVisibilityInfo
local SpellIsPriorityAura = SpellIsPriorityAura
local SpellIsSelfBuff = SpellIsSelfBuff
local UnitAffectingCombat = UnitAffectingCombat
local UnitName = UnitName

local defaults = {
	Parent = "Button",
	ActivePoints = 1,
	Container = {
		IconSize = 22,
		IconsPerRow = 8,
		HorizontalGrowDirection = "leftwards",
		HorizontalSpacing = 2,
		VerticalGrowdirection = "upwards",
		VerticalSpacing = 1,
	},
	Coloring_Enabled = true,
	Cooldown = {
		ShowNumber = true,
		FontSize = 8,
		FontOutline = "OUTLINE",
		EnableShadow = false,
		ShadowColor = {0, 0, 0, 1},
	},
	Filtering = {
		Enabled = true,
		Mode = "Custom",
		CustomFiltering = {
			ConditionsMode = "Any",
			SourceFilter_Enabled = true,
			ShowMine = true,
			DispelFilter_Enabled = true,
			CanStealorPurge = true,
			DebuffTypeFiltering_Enabled = false,
			DebuffTypeFiltering_Filterlist = {},
			SpellIDFiltering_Enabled = false,
			SpellIDFiltering_Filterlist = {},
			DurationFilter_Enabled = false,
			DurationFilter_CustomMaxDuration = 20
		}
	}
}


-- CompactUnitFrame_Util_IsPriorityDebuff
local function IsPriorityDebuff(spellId)
	if BattleGroundEnemies.PlayerDetails.PlayerClass == "PALADIN" then
		local isForbearance = (spellId == 25771)
		return isForbearance or SpellIsPriorityAura(spellId);
	else
		return SpellIsPriorityAura(spellId)
	end
end

--Utility Functions copy from CompactUnitFrame_UtilShouldDisplayBuff and mofified
local function ShouldDisplayBuffBlizzLike(unitCaster, spellId, canApplyAura)

	local hasCustom, alwaysShowMine, showForMySpec = SpellGetVisibilityInfo(spellId, UnitAffectingCombat("player") and "RAID_INCOMBAT" or "RAID_OUTOFCOMBAT");

	if ( hasCustom ) then
		return showForMySpec or (alwaysShowMine and (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle"));
	else
		return (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle") and canApplyAura and not SpellIsSelfBuff(spellId);
	end
end

-- CompactUnitFrame_Util_ShouldDisplayDebuff
local function ShouldDisplayDebuffBlizzLike(unitCaster, spellId, canApplyAura)

	if IsPriorityDebuff(spellId) then return true end

	local hasCustom, alwaysShowMine, showForMySpec = SpellGetVisibilityInfo(spellId, UnitAffectingCombat("player") and "RAID_INCOMBAT" or "RAID_OUTOFCOMBAT");
	if ( hasCustom ) then
		return showForMySpec or (alwaysShowMine and (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle") );	--Would only be "mine" in the case of something like forbearance.
	else
		return true;
	end
end

local conditionFuncs = {
	All = function (conditions) --all conditions must evaluate to true to return true
		for k, v in pairs(conditions) do
			if not v then return false end
		end
		return true
	end,
	Any =  function (conditions) --only one of the conditions must evaluate to true to return true
		for k, v in pairs(conditions) do
			if v then return true end
		end
	end
}

local function AddFilteringSettings(location, filter)
	return {
		Enabled = {
			type = "toggle",
			name = L.Filtering_Enabled,
			width = 'normal',
			order = 1
		},
		FilterSettings = {
			type = "group",
			name = L.FilterSettings,
			desc = L.AurasFilteringSettings_Desc,
			get = function(option)
				return Data.GetOption(location, option)
			end,
			set = function(option, ...)
				return Data.SetOption(location, option, ...)
			end,
			disabled = function() return not location.Enabled end,
			order = 2,
			args = {
				Mode = {
					type = "select",
					name = L.Auras_Filtering_Mode,
					desc = L.Auras_Filtering_Mode_Desc,
					values = {
						Custom = L.AurasCustomConditions,
						Blizzlike = L.BlizzlikeAuraFiltering
					},
					width = "full",
					order = 1
				},
				CustomFilteringSettings = {
					type = "group",
					name = L.AurasCustomConditions,
					hidden = function()
						return not (location.Mode == "Custom")
					end,
					get = function(option)
						return Data.GetOption(location.CustomFiltering, option)
					end,
					set = function(option, ...)
						return Data.SetOption(location.CustomFiltering, option, ...)
					end,
					inline = true,
					order = 2,
					args = {
						ConditionsMode = {
							type = "select",
							name = L.Auras_CustomFiltering_ConditionsMode,
							desc = L.Auras_CustomFiltering_ConditionsMode_Desc,
							values = {
								All = L.Auras_CustomFiltering_Conditions_All,
								Any = L.Auras_CustomFiltering_Conditions_Any
							},
							width = "full",
							order = 1
						},

						Fake = Data.AddVerticalSpacing(2),
						SourceFilter_Enabled = {
							type = "toggle",
							name = L.SourceFilter,
							order = 3,
						},
						ShowMine = {
							type = "toggle",
							name = L.ShowMine,
							desc = L.ShowMine_Desc:format(L.Debuffs),
							hidden = function() return not location.CustomFiltering.SourceFilter_Enabled end,
							order = 4,
						},
						Fake1 = Data.AddVerticalSpacing(5),
						DispelFilter_Enabled = {
							type = "toggle",
							name = L.DispellFilter,
							order = 6,
						},
						CanStealorPurge = {
							type = "toggle",
							name = L.ShowDispellable,
							desc = L.ShowMine_Desc:format(L.Buffs),
							hidden = function() return not location.CustomFiltering.DispelFilter_Enabled end,
							order = 7,
						},
						Fake2 = Data.AddVerticalSpacing(8),
						DebuffTypeFiltering_Enabled = {
							type = "toggle",
							name = L.DebuffType_Filtering,
							desc = L.DebuffType_Filtering_Desc,
							width = 'normal',
							order = 9
						},
						DebuffTypeFiltering_Filterlist = {
							type = "multiselect",
							name = "",
							desc = "",
							hidden = function() return not location.CustomFiltering.DebuffTypeFiltering_Enabled end,
							get = function(option, key)
								return location.CustomFiltering.DebuffTypeFiltering_Filterlist[key]
							end,
							set = function(option, key, state) -- value = spellname
								location.CustomFiltering.DebuffTypeFiltering_Filterlist[key] = state
							end,
							width = 'normal',
							values = Data.DebuffTypes[filter],
							order = 10
						},
						SpellIDFiltering_Enabled = {
							type = "toggle",
							name = L.SpellID_Filtering,
							order = 11
						},
						SpellIDFiltering_AddSpellID = {
							type = "input",
							name = L.AurasFiltering_AddSpellID,
							desc = L.AurasFiltering_AddSpellID_Desc,
							hidden = function() return not location.CustomFiltering.SpellIDFiltering_Enabled end,
							get = function() return "" end,
							set = function(option, value, state)
								local spellIDs = {strsplit(",", value)}
								for i = 1, #spellIDs do
									local spellId = tonumber(spellIDs[i])
									location.CustomFiltering.SpellIDFiltering_Filterlist[spellId] = true
								end
							end,
							width = 'double',
							order = 12
						},
						Fake3 = Data.AddVerticalSpacing(13),
						SpellIDFiltering_Filterlist = {
							type = "multiselect",
							name = L.Filtering_Filterlist,
							desc = L.AurasFiltering_Filterlist_Desc:format(L.debuff),
							hidden = function() return not location.CustomFiltering.SpellIDFiltering_Enabled end,
							get = function()
								return true --to make it checked
							end,
							set = function(option, value)
								location.CustomFiltering.SpellIDFiltering_Filterlist[value] = nil
							end,
							values = function()
								local valueTable = {}
								for spellId in pairs(location.CustomFiltering.SpellIDFiltering_Filterlist) do
									valueTable[spellId] = spellId..": "..(GetSpellInfo(spellId) or "")
								end
								return valueTable
							end,
							order = 14
						},
						DurationFilter_Enabled = {
							type = "toggle",
							name = L.DurationFilter,
							order = 15
						},
						DurationFilter_CustomMaxDuration = {
							type = "range",
							name = L.DurationFilter_OnlyShowWhenDuration,
							desc = L.DurationFilter_OnlyShowWhenDuration_Desc,
							hidden = function() return not location.CustomFiltering.DurationFilter_Enabled end,
							min = 1,
							max = 600,
							step = 1,
							order = 16
						}
					}
				}
			}
		}
	}
end

local function AddAuraSettings(location, filter, isPriorityContainer)
	return {
		ContainerSettings = {
			type = "group",
			name = L.ContainerSettings,
			order = 5,
			get = function(option)
				return Data.GetOption(location.Container, option)
			end,
			set = function(option, ...)
				return Data.SetOption(location.Container, option, ...)
			end,
			args = Data.AddContainerSettings(location.Container),
		},
		CooldownSettings = {
			type = "group",
			name = L.Countdowntext,
			--desc = L.MyAuraSettings_Desc,
			get = function(option)
				return Data.GetOption(location.Cooldown, option)
			end,
			set = function(option, ...)
				return Data.SetOption(location.Cooldown, option, ...)
			end,
			order = 8,
			args = Data.AddCooldownSettings(location.Cooldown),
		},
		FilteringSettings = {
			type = "group",
			name = L.FilterSettings,
			desc = L.AurasFilteringSettings_Desc,
			get = function(option)
				return Data.GetOption(location.Filtering, option)
			end,
			set = function(option, ...)
				return Data.SetOption(location.Filtering, option, ...)
			end,
			hidden = isPriorityContainer,
			order = 9,
			args = AddFilteringSettings(location.Filtering, filter)
		}
	}
end

local nonPriorityBuffOptions = function(location)
	return AddAuraSettings(location, "HELPFUL", false)
end

local nonPriorityDebuffOptions = function(location)
	return AddAuraSettings(location, "HARMFUL", false)
end

local priorityBuffOptions = function(location)
	return AddAuraSettings(location, "HELPFUL", true)
end

local priorityDebuffOptions = function(location)
	return AddAuraSettings(location, "HARMFUL", true)
end

local flags = {
	HasDynamicSize = true
}

local events = {"ShouldQueryAuras", "CareAboutThisAura", "BeforeFullAuraUpdate", "NewAura", "AfterFullAuraUpdate", "UnitDied"}

local nonPriorityBuffs = BattleGroundEnemies:NewButtonModule({
	moduleName = "NonPriorityBuffs",
	localizedModuleName = L.NonPriorityBuffs,
	flags = flags,
	defaultSettings = defaults,
	options = nonPriorityBuffOptions,
	events = events,
	enabledInThisExpansion = true
})
local nonPriorityDebuffs = BattleGroundEnemies:NewButtonModule({
	moduleName = "NonPriorityDebuffs",
	localizedModuleName = L.NonPriorityDebuffs,
	flags = flags,
	defaultSettings = defaults,
	options = nonPriorityDebuffOptions,
	events = events,
	enabledInThisExpansion = true
})

local priorityBuffs = BattleGroundEnemies:NewButtonModule({
	moduleName = "PriorityBuffs",
	localizedModuleName = L.PriorityBuffs,
	flags = flags,
	defaultSettings = defaults,
	options = priorityBuffOptions,
	events = events,
	enabledInThisExpansion = true
})
local priorityDebuffs = BattleGroundEnemies:NewButtonModule({
	moduleName = "PriorityDebuffs",
	localizedModuleName = L.PriorityDebuffs,
	flags = flags,
	defaultSettings = defaults,
	options = priorityDebuffOptions,
	events = events,
	enabledInThisExpansion = true
})

local function createNewAuraFrame(playerButton, container)
	local childFrame = CreateFrame('Button', nil, container, "CompactAuraTemplate")
	BattleGroundEnemies.AttachCooldownSettings(childFrame.cooldown)
	if container.filter == "HARMFUL" then
		--add debufftype border
		childFrame.border = childFrame:CreateTexture(nil, "OVERLAY")
		childFrame.border:SetTexture("Interface\\Buttons\\UI-Debuff-Overlays")
		childFrame.border:SetPoint("TOPLEFT", -1, 1)
		childFrame.border:SetPoint("BOTTOMRIGHT", 1, -1)
		childFrame.border:SetTexCoord(0.296875, 0.5703125, 0, 0.515625)

	elseif container.filter == "HELPFUL" then
		-- add dispellable border from targetframe.xml
	-- 	<Layer level="OVERLAY">
	-- 	<Texture name="$parentStealable" parentKey="Stealable" file="Interface\TargetingFrame\UI-TargetingFrame-Stealable" hidden="true" alphaMode="ADD">
	-- 		<Size x="24" y="24"/>
	-- 		<Anchors>
	-- 			<Anchor point="CENTER" x="0" y="0"/>
	-- 		</Anchors>
	-- 	</Texture>
	-- </Layer>
		childFrame.Stealable = childFrame:CreateTexture(nil, "OVERLAY")
		childFrame.Stealable:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Stealable")
		childFrame.Stealable:SetBlendMode("ADD")
		childFrame.Stealable:SetPoint("CENTER")
	end
	-- childFrame:SetBackdrop({
	-- 	bgFile = "Interface/Buttons/WHITE8X8", --drawlayer "BACKGROUND"
	-- 	edgeFile = 'Interface/Buttons/WHITE8X8', --drawlayer "BORDER"
	-- 	edgeSize = 1
	-- })

	-- childFrame:SetBackdropColor(0, 0, 0, 0)
	-- childFrame:SetBackdropBorderColor(0, 0, 0, 0)

	childFrame:SetScript("OnClick", nil)
	childFrame:SetFrameLevel(container:GetFrameLevel() + 5)


	childFrame:SetScript("OnEnter", function(self)
		BattleGroundEnemies:ShowTooltip(self, function()
			BattleGroundEnemies:ShowAuraTooltip(playerButton, childFrame.AuraDetails)
		end)
	end)

	childFrame:SetScript("OnLeave", function(self)
		if GameTooltip:IsOwned(self) then
			GameTooltip:Hide()
		end
	end)





	--childFrame.Icon = childFrame:CreateTexture(nil, "BACKGROUND")
	--childFrame.icon:SetAllPoints()

	-- childFrame.count = BattleGroundEnemies.MyCreateFontString(childFrame)
	-- childFrame.count:SetAllPoints()
	-- childFrame.count:SetJustifyH("RIGHT")
	-- childFrame.count:SetJustifyV("BOTTOM")

	--childFrame.Cooldown = BattleGroundEnemies.MyCreateCooldown(childFrame)
	childFrame.cooldown:SetScript("OnCooldownDone", function(self) -- only do this for the case that we dont get a UNIT_AURA for an ending aura, if we dont do this the aura is stuck even tho its expired
		childFrame:Remove()
	end)

	childFrame.Container = container
	childFrame.icon:SetDrawLayer("BORDER", -1) -- 1 to make it behind the SetBackdrop bg


	childFrame.ApplyChildFrameSettings = function(self)
		local conf = container.config

		--self.count:ApplyFontStringSettings(conf.StackText)
		local cooldownConfig = conf.Cooldown
		self.cooldown:ApplyCooldownSettings(cooldownConfig, true, false)
		if container.filter == "HELPFUL" then
			self.Stealable:SetSize(conf.Container.IconSize + 3, conf.Container.IconSize + 3)
		end
	end
	childFrame:ApplyChildFrameSettings()
	return childFrame
end

local function setupAuraFrame(container, auraFrame, auraDetails)
	auraFrame.AuraDetails = auraDetails
	if container.filter == "HELPFUL" then
		auraFrame.Stealable:SetShown(auraDetails.isStealable)
	else
		--HARMFUL
		local debuffType = auraDetails.dispelName
		local color
		if debuffType then
			color = DebuffTypeColor[debuffType] or DebuffTypeColor["none"]
		else
			color = DebuffTypeColor["none"]
		end
		auraFrame.border:SetVertexColor(color.r, color.g, color.b)

	end

	if auraDetails.applications and auraDetails.applications > 1 then
		auraFrame.count:SetText(auraDetails.applications)
	else
		auraFrame.count:SetText("")
	end


	auraFrame.icon:SetTexture(auraDetails.icon)
	auraFrame.cooldown:SetCooldown(auraDetails.expirationTime - auraDetails.duration, auraDetails.duration)
	--BattleGroundEnemies:Debug("SetCooldown", expirationTime - duration, duration)

end



local function AttachToPlayerButton(playerButton, filterr, isPriorityContainer)
	local auraContainer = BattleGroundEnemies:NewContainer(playerButton, createNewAuraFrame, setupAuraFrame)

	auraContainer.isPriorityContainer = isPriorityContainer
	auraContainer.filter = filterr


	function auraContainer:ShouldQueryAuras(unitID, filter)
		if filter == self.filter then return true end
	end

	function auraContainer:BeforeFullAuraUpdate(filter)
		if not (filter == self.filter) then return end
		self:ResetInputs()
	end

	function auraContainer:CareAboutThisAura(unitID, filter, aura)
		if not (filter == self.filter) then return end

		local spellId = aura.spellId
		local canApplyAura = aura.canApplyAura
		local debuffType = aura.dispelName
		local unitCaster = aura.sourceUnit
		

		if aura.Priority then
			return self.isPriorityContainer -- its an important aura, we dont do any special filtering, we only care about if the container is for important auras
		elseif self.isPriorityContainer then -- this aura is not important but we are the priority container > we dont care
			return false
		end

		--we only do the rest of the filtering if the aura doesnt have a priority and the container is for non priority Auras

		local config = self.config
		local blizzlikeFunc

		if filter == "HARMFUL" then
			blizzlikeFunc = ShouldDisplayDebuffBlizzLike
		else
			blizzlikeFunc = ShouldDisplayBuffBlizzLike
		end

		local filteringConfig = config.Filtering
		if not filteringConfig.Enabled then
			return true
		end
		if filteringConfig.Mode == "Blizzlike" then
			if blizzlikeFunc(unitCaster, spellId, canApplyAura) then
				return true
			end
		else --custom filtering
			local conditions = {}
			local customFilterConfig = filteringConfig.CustomFiltering

			if customFilterConfig.SourceFilter_Enabled then
				local isMine = unitCaster == "player"
				table_insert(conditions, customFilterConfig.ShowMine == isMine)
			end

			if customFilterConfig.SpellIDFiltering_Enabled then
				table_insert(conditions, not not customFilterConfig.SpellIDFiltering_Filterlist[spellId])  -- the not not is necessary to cast nil to false the loop in conditionFuncs, otherwise the for loop does not loop thorugh the item since its nil
			end
			if customFilterConfig.DebuffTypeFiltering_Enabled then
				table_insert(conditions, customFilterConfig.DebuffTypeFiltering_Filterlist[debuffType])
			end

			if aura.isStealable ~= nil then
				if customFilterConfig.DispelFilter_Enabled then
					table_insert(conditions, customFilterConfig.CanStealOrPurge == aura.isStealable)
				end
			end
			if aura.duration ~= nil then
				if customFilterConfig.DurationFilter_Enabled then
					table_insert(conditions, aura.duration > 0 and aura.duration <= customFilterConfig.DurationFilter_CustomMaxDuration)
				end
			end

			if conditionFuncs[customFilterConfig.ConditionsMode] and conditionFuncs[customFilterConfig.ConditionsMode](conditions) then
				return true
			end
		end
	end

	function auraContainer:NewAura(unitID, filter, aura)
		if not (filter == self.filter) then return end
		-- only used to gather new auras for the testmode and for testing :)
		-- if true then
		-- 	BattleGroundEnemies.db.profile.Auras = BattleGroundEnemies.db.profile.Auras or {}
		-- 	BattleGroundEnemies.db.profile.Auras[filter] = BattleGroundEnemies.db.profile.Auras[filter] or {}
		-- 	BattleGroundEnemies.db.profile.Auras[filter][spellId] = BattleGroundEnemies.db.profile.Auras[filter][spellId] or {
		-- 		name = name,
		-- 		icon = icon,
		-- 		count = count,
		-- 		debuffType = debuffType,
		-- 		duration = duration,
		-- 		expirationTime = expirationTime,
		-- 		unitCaster = unitCaster,
		-- 		canStealOrPurge = canStealOrPurge,
		-- 		nameplateShowPersonal = nameplateShowPersonal,
		-- 		spellId = spellId,
		-- 		canApplyAura = canApplyAura,
		-- 		isBossAura = isBossAura,
		-- 		castByPlayer = castByPlayer,
		-- 		nameplateShowAll = nameplateShowAll,
		-- 		timeMod = timeMod
		-- 	}
		-- end

		if not auraContainer:CareAboutThisAura(unitID, filter, aura) then
			return
		end
	
		self:NewInput(aura)
	end

	function auraContainer:AfterFullAuraUpdate(filter)
		if not (filter == self.filter) then return end
		self:Display()
	end

	function auraContainer:UnitDied()
		self:Reset()
	end

	return auraContainer
end


function nonPriorityBuffs:AttachToPlayerButton(playerButton)
	playerButton.NonPriorityBuffs = AttachToPlayerButton(playerButton, "HELPFUL", false)
end

function nonPriorityDebuffs:AttachToPlayerButton(playerButton)
	playerButton.NonPriorityDebuffs = AttachToPlayerButton(playerButton, "HARMFUL", false)
end

function priorityBuffs:AttachToPlayerButton(playerButton)
	playerButton.PriorityBuffs = AttachToPlayerButton(playerButton, "HELPFUL", true)
end

function priorityDebuffs:AttachToPlayerButton(playerButton)
	playerButton.PriorityDebuffs = AttachToPlayerButton(playerButton, "HARMFUL", true)
end

