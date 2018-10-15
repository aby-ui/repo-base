
------------------------------------------------------------------------------------
-- Tidy Plates Hub
------------------------------------------------------------------------------------
local AddonName, HubData = ...;
local LocalVars = TidyPlatesHubDefaults
------------------------------------------------------------------------------------
HubData.Functions = {}
HubData.Colors = {}
TidyPlatesHubFunctions = {}
------------------------------------------------------------------------------------
local CallbackList = {}
function HubData.RegisterCallback(func) CallbackList[func] = true end
function HubData.UnRegisterCallback(func) CallbackList[func] = nil end

local CurrentProfileName = nil

local InCombatLockdown = InCombatLockdown

local CopyTable = TidyPlatesUtility.copyTable

local WidgetLib = TidyPlatesWidgets
local valueToString = TidyPlatesUtility.abbrevNumber

local MergeProfileValues = TidyPlatesHubHelpers.MergeProfileValues

local EnableTankWatch = TidyPlatesWidgets.EnableTankWatch
local DisableTankWatch = TidyPlatesWidgets.DisableTankWatch
local EnableAggroWatch = TidyPlatesWidgets.EnableAggroWatch
local DisableAggroWatch = TidyPlatesWidgets.DisableAggroWatch

local GetFriendlyThreat = TidyPlatesUtility.GetFriendlyThreat
local IsTotem = TidyPlatesUtility.IsTotem
local IsAuraShown = TidyPlatesWidgets.IsAuraShown
local IsHealer = TidyPlatesUtility.IsHealer
local InstanceStatus = TidyPlatesUtility.InstanceStatus


-- Combat
local IsEnemyTanked = TidyPlatesWidgets.IsEnemyTanked

local function IsOffTanked(unit)

	local unitid = unit.unitid
	if unitid then
		local targetOf = unitid.."target"
		local targetIsTank = UnitIsUnit(targetOf, "pet") or ("TANK" ==  UnitGroupRolesAssigned(targetOf))

		--if LocalVars.EnableOffTankHighlight and IsEnemyTanked(unit) then
		if LocalVars.EnableOffTankHighlight and targetIsTank then
			return true
		end
	end
end


-- General
local function DummyFunction() return end

-- Define the Menu for Threat Modes
TidyPlatesHubDefaults.ThreatWarningMode = "Auto"
TidyPlatesHubMenus.ThreatWarningModes = {
					{ text = "自动 (切换颜色)", value = "Auto",} ,
					{ text = "坦克", value = "Tank",} ,
					{ text = "输出或治疗", value = "DPS",} ,
					}

local NormalGrey = {r = .65, g = .65, b = .65, a = .4}
local EliteGrey = {r = .9, g = .7, b = .3, a = .5}
local BossGrey = {r = 1, g = .85, b = .1, a = .8}

-- Colors
local BlueColor = {r = 60/255, g =  168/255, b = 255/255, }
local GreenColor = { r = 96/255, g = 224/255, b = 37/255, }
local RedColor = { r = 255/255, g = 51/255, b = 32/255, }
local YellowColor = { r = 252/255, g = 220/255, b = 27/255, }
local GoldColor = { r = 252/255, g = 140/255, b = 0, }
local OrangeColor = { r = 255/255, g = 64/255, b = 0, }
local WhiteColor = { r = 250/255, g = 250/255, b = 250/255, }

local White = {r = 1, g = 1, b = 1}
local Black = {r = 0, g = 0, b = 0}
local BrightBlue =  {r = 0, g = 70/255, b = 240/255,} -- {r = 0, g = 75/255, b = 240/255,}
local BrightBlueText = {r = 112/255, g = 219/255, b = 255/255,}
local PaleBlue = {r = 0, g = 130/255, b = 225/255,}
local PaleBlueText = {r = 194/255, g = 253/255, b = 1,}
local DarkRed = {r = .9, g = 0.08, b = .08,}

local RaidClassColors = RAID_CLASS_COLORS

------------------------------------------------------------------------------------

local ReactionColors = {
	["FRIENDLY"] = {
		["PLAYER"] = {r = 0, g = 0, b = 1,},
		["NPC"] = {r = 0, g = 1, b = 0,},
	},
	["HOSTILE"] = {
		["PLAYER"] = {r = 1, g = 0, b = 0,},
		["NPC"] = {r = 1, g = 0, b = 0,},
	},
	["NEUTRAL"] = {
		["NPC"] = {r = 1, g = 1, b = 0,},
	},
	["TAPPED"] = {
		["NPC"] = {r = .45, g = .45, b = .45,},
	},
}



local NameReactionColors = {
	["FRIENDLY"] = {
		["PLAYER"] = {r = 60/255, g = 168/255, b = 255/255,},
		["NPC"] = {r = 96/255, g = 224/255, b = 37/255,},
	},
	["HOSTILE"] = {
		["PLAYER"] = {r = 255/255, g = 51/255, b = 32/255,},
		["NPC"] = {r = 255/255, g = 51/255, b = 32/255,},
	},
	["NEUTRAL"] = {
		["NPC"] = {r = 252/255, g = 180/255, b = 27/255,},
	},
	["TAPPED"] = {
		--["NPC"] = {r = .8, g = .8, b = 1,},
		["NPC"] = {r = .7, g = .7, b = .7,},
	},
}

HubData.Colors.ReactionColors = ReactionColors
HubData.Colors.NameReactionColors = NameReactionColors

------------------------------------------------------------------------------------
-- Helper Functions
------------------------------------------------------------------------------------

local function CallbackUpdate()
			for func in pairs(CallbackList) do
				func(LocalVars)
			end
end

local function EnableWatchers()
	if LocalVars.WidgetsDebuffStyle == 2 then TidyPlatesWidgets.UseSquareDebuffIcon() else TidyPlatesWidgets.UseWideDebuffIcon()end
	--TidyPlatesUtility:EnableGroupWatcher()
	TidyPlatesUtility:EnableHealerTrack()
	--TidyPlatesWidgets:EnableTankWatch()

	CallbackUpdate()
end

local CreateVariableSet = TidyPlatesHubRapidPanel.CreateVariableSet


local function UseVariables(profileName)

	local suffix = profileName or "Damage"
	if suffix then

		if CurrentProfileName ~= suffix then 	-- Stop repeat loading

			local objectName = "HubPanelSettings"..suffix

			LocalVars = TidyPlatesHubSettings[objectName] or CreateVariableSet(objectName)

            --163ui use default highlight
            if LocalVars.UnitSpotlightVersion ~= TidyPlatesHubDefaults.UnitSpotlightVersion then
                for k,v in pairs(LocalVars) do if type(k) == "string" and k:find("^UnitSpotlight") then LocalVars[k] = nil end end
            end

			MergeProfileValues(LocalVars, TidyPlatesHubDefaults)		-- If the value doesn't exist in the settings, create it.
            TidyPlatesHubHelpers.ConvertStringToTable(LocalVars.UnitSpotlightList, LocalVars.UnitSpotlightLookup)

			CurrentProfileName = suffix

			CallbackUpdate()
		end

        _G.TidyLocalVars = LocalVars
		return LocalVars
	end
end

---------------
-- Apply customization
---------------
local function ApplyFontCustomization(style, defaults)
	if not style then return end
	style.frame.y = ((LocalVars.FrameVerticalPosition-.5)*50)-16

	if LocalVars.TextUseBlizzardFont then
		style.name.typeface = STANDARD_TEXT_FONT
		style.level.typeface = STANDARD_TEXT_FONT
		style.spelltext.typeface = STANDARD_TEXT_FONT
		style.customtext.typeface = STANDARD_TEXT_FONT
	else
		style.name.typeface = defaults.name.typeface
		style.level.typeface = defaults.level.typeface
		style.spelltext.typeface = defaults.spelltext.typeface
		style.customtext.typeface = defaults.customtext.typeface
	end


end

local function ApplyCustomBarSize(style, defaults)

	if defaults then
		-- Alter Widths
		style.threatborder.width = defaults.threatborder.width * (LocalVars.FrameBarWidth or 1)
		style.healthborder.width = defaults.healthborder.width * (LocalVars.FrameBarWidth or 1)
		style.target.width = defaults.target.width * (LocalVars.FrameBarWidth or 1)
		style.healthbar.width = defaults.healthbar.width * (LocalVars.FrameBarWidth or 1)
		style.frame.width = defaults.frame.width * (LocalVars.FrameBarWidth or 1)
		style.eliteicon.x = defaults.eliteicon.x * (LocalVars.FrameBarWidth or 1)
	end
end

local function ApplyStyleCustomization(style, defaults)
	if not style then return end
	style.level.show = (LocalVars.TextShowLevel == true)
	style.target.show = (LocalVars.WidgetTargetHighlight == true)
	style.eliteicon.show = (LocalVars.WidgetEliteIndicator == true)

 	ApplyCustomBarSize(style, defaults)
	ApplyFontCustomization(style, defaults)
end


local function ApplyProfileSettings(theme, ...)
	-- When nil is passed, the theme is being deactivated
	if not theme then return end

	ReactionColors.FRIENDLY.NPC = LocalVars.ColorFriendlyNPC
	ReactionColors.FRIENDLY.PLAYER = LocalVars.ColorFriendlyPlayer
	ReactionColors.HOSTILE.NPC = LocalVars.ColorHostileNPC
	ReactionColors.HOSTILE.PLAYER = LocalVars.ColorHostilePlayer
	ReactionColors.NEUTRAL.NPC = LocalVars.ColorNeutral

	NameReactionColors.FRIENDLY.NPC = LocalVars.TextColorFriendlyNPC
	NameReactionColors.FRIENDLY.PLAYER = LocalVars.TextColorFriendlyPlayer
	NameReactionColors.HOSTILE.NPC = LocalVars.TextColorHostileNPC
	NameReactionColors.HOSTILE.PLAYER = LocalVars.TextColorHostilePlayer
	NameReactionColors.NEUTRAL.NPC = LocalVars.TextColorNeutral

	EnableWatchers()
	ApplyStyleCustomization(theme["Default"], theme["DefaultBackup"])
	ApplyFontCustomization(theme["NameOnly"], theme["NameOnlyBackup"])

	TidyPlates:ForceUpdate()
	RaidClassColors = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
end


-- From Neon.lua...
local LocalVars = TidyPlatesHubDamageVariables

local function OnInitialize(plate, theme)
	if theme and theme.WidgetConfig then
		TidyPlatesHubFunctions.OnInitializeWidgets(plate, theme.WidgetConfig)
	end
end

local function OnActivateTheme(theme)

	if not theme then
		TidyPlatesWidgets.DisableAuraWatcher()
	end
	-- This gets called when switching themes.
	-- Ideally, it should clear out old widget data when nil is reported.
end

local function OnChangeProfile(theme, profile)
	if profile then

		UseVariables(profile)

		local theme = TidyPlates:GetTheme()

		if theme then
			if theme.ApplyProfileSettings then
				ApplyProfileSettings(theme, "From OnChangeProfile")
				TidyPlates:ForceUpdate()
			end
		end
	end
end

-- Quickly add functions to a Theme
local function ApplyHubFunctions(theme)
	theme.SetNameColor = TidyPlatesHubFunctions.SetNameColor
	theme.SetScale = TidyPlatesHubFunctions.SetScale
	theme.SetAlpha = TidyPlatesHubFunctions.SetAlpha
	theme.SetHealthbarColor = TidyPlatesHubFunctions.SetHealthbarColor
	theme.SetThreatColor = TidyPlatesHubFunctions.SetThreatColor
	theme.SetCastbarColor = TidyPlatesHubFunctions.SetCastbarColor
	theme.OnUpdate = TidyPlatesHubFunctions.OnUpdate
	theme.OnContextUpdate = TidyPlatesHubFunctions.OnContextUpdate
	theme.ShowConfigPanel = ShowTidyPlatesHubDamagePanel
	theme.SetStyle = TidyPlatesHubFunctions.SetStyleBinary
	theme.SetCustomText = TidyPlatesHubFunctions.SetCustomTextBinary
	theme.OnInitialize = OnInitialize		-- Need to provide widget positions
	theme.OnActivateTheme = OnActivateTheme -- called by Tidy Plates Core, Theme Loader
	theme.ApplyProfileSettings = ApplyProfileSettings
	theme.OnChangeProfile = OnChangeProfile

	-- Make Backup Copies of the default settings of the theme styles
	theme["DefaultBackup"] = CopyTable(theme["Default"])
	theme["NameOnlyBackup"] = CopyTable(theme["NameOnly"])

	if barStyle then
		backupStyle.threatborder.default_width = barStyle.threatborder.width
		backupStyle.healthborder.default_width = barStyle.healthborder.width
		backupStyle.target.default_width = barStyle.target.width
		backupStyle.healthbar.default_width = barStyle.healthbar.width
		backupStyle.eliteicon.default_x = barStyle.eliteicon.x
	end

	return theme
end

---------------------------------------------
-- Function List
---------------------------------------------
TidyPlatesHubFunctions.IsOffTanked = IsOffTanked
TidyPlatesHubFunctions.UseDamageVariables = UseDamageVariables
TidyPlatesHubFunctions.UseTankVariables = UseTankVariables
TidyPlatesHubFunctions.UseVariables = UseVariables
TidyPlatesHubFunctions.EnableWatchers = EnableWatchers
TidyPlatesHubFunctions.ApplyHubFunctions = ApplyHubFunctions



---------------------------------------------
-- Old, will be removed
---------------------------------------------
--[[
local function UseDamageVariables()
	local objectName = "HubPanelSettingsDamage"
	LocalVars = TidyPlatesHubSettings[objectName] or CreateVariableSet(objectName)

	CallbackUpdate()

	--EnableWatchers()
	return LocalVars
end

local function UseTankVariables()
	local objectName = "HubPanelSettingsTank"
	LocalVars = TidyPlatesHubSettings[objectName] or CreateVariableSet(objectName)

	CallbackUpdate()

	--EnableWatchers()
	return LocalVars
end



TidyPlatesHubFunctions.UseDamageVariables = UseDamageVariables
TidyPlatesHubFunctions.UseTankVariables = UseTankVariables

--]]













