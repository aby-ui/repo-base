--------------------------------------------------------------------------------------------------------
--                                             Localized global                                       --
--------------------------------------------------------------------------------------------------------
local _G = getfenv(0)

--------------------------------------------------------------------------------------------------------
--                                         AceAddon init                                              --
--------------------------------------------------------------------------------------------------------
local MODNAME = "失败消息屏蔽"
local addon = LibStub("AceAddon-3.0"):NewAddon(MODNAME, "AceEvent-3.0", "LibSink-2.0")
_G.ErrorFilter = addon

local L = LibStub("AceLocale-3.0"):GetLocale('ErrorFilter')
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceDB = LibStub("AceDB-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")

--------------------------------------------------------------------------------------------------------
--                                        ErrorFilter variables                                       --
--------------------------------------------------------------------------------------------------------
local profileDB
local DATABASE_DEFAULTS = {
	profile = {
		removeFrame = false,
		mode = 1,
		updateOnlyInCombat = false,
		throttle = true,
		q_mode = 0,
		q_updateOnlyInCombat = false,
		filters = {
			-- Errors
			[INTERRUPTED] = false,
			[ERR_ABILITY_COOLDOWN] = true,
			[ERR_ATTACK_CHANNEL] = false,
			[ERR_ATTACK_CHARMED] = false,
			[ERR_ATTACK_CONFUSED] = false,
			[ERR_ATTACK_DEAD] = false,
			[ERR_ATTACK_FLEEING] = false,
			[ERR_ATTACK_MOUNTED] = true,
			[ERR_ATTACK_PACIFIED] = false,
			[ERR_ATTACK_STUNNED] = false,
			[ERR_AUTOFOLLOW_TOO_FAR] = false,
			[ERR_BADATTACKFACING] = false,
			[ERR_BADATTACKPOS] = false,
			[ERR_CLIENT_LOCKED_OUT] = false,
			[ERR_GENERIC_NO_TARGET] = true,
			[ERR_GENERIC_NO_VALID_TARGETS] = true,
			[ERR_GENERIC_STUNNED] = false,
			[ERR_INVALID_ATTACK_TARGET] = true,
			[ERR_ITEM_COOLDOWN] = true,
			[ERR_NOEMOTEWHILERUNNING] = false,
			[ERR_NOT_IN_COMBAT] = false,
			[ERR_NOT_WHILE_DISARMED] = false,
			[ERR_NOT_WHILE_FALLING] = false,
			[ERR_NOT_WHILE_FATIGUED] = true,
			[ERR_NOT_WHILE_MOUNTED] = false,
			[ERR_NOT_WHILE_SHAPESHIFTED] = false,
			[ERR_NO_ATTACK_TARGET] = true,
			[ERR_NO_PET] = false,
			[ERR_OBJECT_IS_BUSY] = false,

			-- Out of...
			[ERR_OUT_OF_ARCANE_CHARGES] = true,
			[ERR_OUT_OF_BALANCE_NEGATIVE] = true,
			[ERR_OUT_OF_BALANCE_POSITIVE] = true,
			[ERR_OUT_OF_BURNING_EMBERS] = true,
			[ERR_OUT_OF_CHI] = true,
			[ERR_OUT_OF_COMBO_POINTS] = true,
			[ERR_OUT_OF_DARK_FORCE] = false,
			[ERR_OUT_OF_DEMONIC_FURY] = true,
			[ERR_OUT_OF_ENERGY] = true,
			[ERR_OUT_OF_FOCUS] = true,
			[ERR_OUT_OF_HEALTH] = true,
			[ERR_OUT_OF_HOLY_POWER] = true,
			[ERR_OUT_OF_LIGHT_FORCE] = false,
			[ERR_OUT_OF_MANA] = true,
			[ERR_OUT_OF_POWER_DISPLAY] = false,
			[ERR_OUT_OF_RAGE] = true,
			[ERR_OUT_OF_RANGE] = true,
			[ERR_OUT_OF_RUNES] = true,
			[ERR_OUT_OF_RUNIC_POWER] = true,
			[ERR_OUT_OF_SHADOW_ORBS] = true,
			[ERR_OUT_OF_SOUL_SHARDS] = true,
			[ERR_SPELL_COOLDOWN] = true,
			[ERR_SPELL_OUT_OF_RANGE] = false,
			[ERR_TOO_FAR_TO_INTERACT] = false,
			[ERR_USE_BAD_ANGLE] = false,
			[ERR_USE_CANT_IMMUNE] = false,
			[ERR_USE_TOO_FAR] = false,
			[SPELL_FAILED_BAD_IMPLICIT_TARGETS] = true,

			-- Spell failed...
			[SPELL_FAILED_ABOVE_MAXIMUM_SKILL_RANK] = false,
			[SPELL_FAILED_AFFECTING_COMBAT] = false,
			[SPELL_FAILED_AURA_BOUNCED] = false,
			[SPELL_FAILED_BAD_IMPLICIT_TARGETS] = false,
			[SPELL_FAILED_BAD_TARGETS] = true,
			[SPELL_FAILED_CANT_BE_CHARMED] = false,
			[SPELL_FAILED_CANT_DO_THAT_RIGHT_NOW] = true,
			[SPELL_FAILED_CANT_STEALTH] = false,
			[SPELL_FAILED_CASTER_AURASTATE] = true,
			[SPELL_FAILED_CASTER_DEAD] = true,
			[SPELL_FAILED_CASTER_DEAD_FEMALE] = true,
			[SPELL_FAILED_CAST_NOT_HERE] = false,
			[SPELL_FAILED_CHARMED] = true,
			[SPELL_FAILED_CHEST_IN_USE] = false,
			[SPELL_FAILED_CONFUSED] = true,
			[SPELL_FAILED_DAMAGE_IMMUNE] = false,
			[SPELL_FAILED_FALLING] = true,
			[SPELL_FAILED_FLEEING] = true,
			[SPELL_FAILED_IMMUNE] = true,
			[SPELL_FAILED_INCORRECT_AREA] = false,
			[SPELL_FAILED_INTERRUPTED] = false,
			[SPELL_FAILED_INTERRUPTED_COMBAT] = false,
			[SPELL_FAILED_IN_COMBAT_RES_LIMIT_REACHED] = false,
			[SPELL_FAILED_LINE_OF_SIGHT] = false,
			[SPELL_FAILED_LOWLEVEL] = false,
			[SPELL_FAILED_LOW_CASTLEVEL] = false,
			[SPELL_FAILED_MOVING] = true,
			[SPELL_FAILED_NOPATH] = true,
			[SPELL_FAILED_NOTHING_TO_DISPEL] = false,
			[SPELL_FAILED_NOTHING_TO_STEAL] = false,
			[SPELL_FAILED_NOT_BEHIND] = false,
			[SPELL_FAILED_NOT_FISHABLE] = false,
			[SPELL_FAILED_NOT_FLYING] = false,
			[SPELL_FAILED_NOT_INFRONT] = false,
			[SPELL_FAILED_NOT_IN_CONTROL] = false,
			[SPELL_FAILED_NOT_KNOWN] = false,
			[SPELL_FAILED_NOT_MOUNTED] = false,
			[SPELL_FAILED_NOT_ON_DAMAGE_IMMUNE] = false,
			[SPELL_FAILED_NOT_ON_GROUND] = false,
			[SPELL_FAILED_NOT_ON_MOUNTED] = false,
			[SPELL_FAILED_NOT_ON_SHAPESHIFT] = false,
			[SPELL_FAILED_NOT_ON_STEALTHED] = false,
			[SPELL_FAILED_NOT_ON_TAXI] = false,
			[SPELL_FAILED_NOT_ON_TRANSPORT] = false,
			[SPELL_FAILED_NOT_READY] = false,
			[SPELL_FAILED_NOT_SHAPESHIFT] = false,
			[SPELL_FAILED_NOT_STANDING] = false,
			[SPELL_FAILED_NOT_WHILE_FATIGUED] = false,
			[SPELL_FAILED_NOT_WHILE_GHOST] = true,
			[SPELL_FAILED_NOT_WHILE_LOOTING] = false,
			[SPELL_FAILED_NO_ACTIONS] = false,
			[SPELL_FAILED_NO_CHARGES_REMAIN] = false,
			[SPELL_FAILED_NO_COMBO_POINTS] = true,
			[SPELL_FAILED_NO_ITEMS_WHILE_SHAPESHIFTED] = false,
			[SPELL_FAILED_NO_PET] = false,
			[SPELL_FAILED_ONLY_STEALTHED] = false,
			[SPELL_FAILED_OUT_OF_RANGE] = true,
			[SPELL_FAILED_PACIFIED] = true,
			[SPELL_FAILED_POSSESSED] = true,
			[SPELL_FAILED_PREVENTED_BY_MECHANIC] = false,
			[SPELL_FAILED_ROOTED] = true,
			[SPELL_FAILED_SILENCED] = true,
			[SPELL_FAILED_SPELL_IN_PROGRESS] = true,
			[SPELL_FAILED_SPELL_LEARNED] = false,
			[SPELL_FAILED_STUNNED] = true,
			[SPELL_FAILED_SUMMON_PENDING] = false,
			[SPELL_FAILED_TARGETS_DEAD] = true,
			[SPELL_FAILED_TARGET_AFFECTING_COMBAT] = false,
			[SPELL_FAILED_TARGET_AURASTATE] = true,
			[SPELL_FAILED_TARGET_ENRAGED] = false,
			[SPELL_FAILED_TARGET_FRIENDLY] = false,
			[SPELL_FAILED_TOO_CLOSE] = false,
			[SPELL_FAILED_UNIT_NOT_BEHIND] = false,
			[SPELL_FAILED_UNIT_NOT_INFRONT] = false,
			[SPELL_FAILED_VISION_OBSCURED] = false,
		},
		allows = {
			-- Errors
			[INTERRUPTED] = true,
			[ERR_ABILITY_COOLDOWN] = true,
			[ERR_ATTACK_CHANNEL] = true,
			[ERR_ATTACK_CHARMED] = true,
			[ERR_ATTACK_CONFUSED] = true,
			[ERR_ATTACK_DEAD] = true,
			[ERR_ATTACK_FLEEING] = true,
			[ERR_ATTACK_MOUNTED] = true,
			[ERR_ATTACK_PACIFIED] = true,
			[ERR_ATTACK_STUNNED] = true,
			[ERR_AUTOFOLLOW_TOO_FAR] = false,
			[ERR_BADATTACKFACING] = true,
			[ERR_BADATTACKPOS] = true,
			[ERR_CLIENT_LOCKED_OUT] = true,
			[ERR_GENERIC_NO_TARGET] = true,
			[ERR_GENERIC_NO_VALID_TARGETS] = true,
			[ERR_GENERIC_STUNNED] = false,
			[ERR_INVALID_ATTACK_TARGET] = true,
			[ERR_ITEM_COOLDOWN] = true,
			[ERR_NOEMOTEWHILERUNNING] = false,
			[ERR_NOT_IN_COMBAT] = true,
			[ERR_NOT_WHILE_DISARMED] = true,
			[ERR_NOT_WHILE_FALLING] = true,
			[ERR_NOT_WHILE_FATIGUED] = true,
			[ERR_NOT_WHILE_MOUNTED] = true,
			[ERR_NOT_WHILE_SHAPESHIFTED] = false,
			[ERR_NO_ATTACK_TARGET] = true,
			[ERR_NO_PET] = false,
			[ERR_OBJECT_IS_BUSY] = false,

			-- Out of...
			[ERR_OUT_OF_ARCANE_CHARGES] = true,
			[ERR_OUT_OF_BALANCE_NEGATIVE] = true,
			[ERR_OUT_OF_BALANCE_POSITIVE] = true,
			[ERR_OUT_OF_BURNING_EMBERS] = true,
			[ERR_OUT_OF_CHI] = true,
			[ERR_OUT_OF_COMBO_POINTS] = true,
			[ERR_OUT_OF_DARK_FORCE] = false,
			[ERR_OUT_OF_DEMONIC_FURY] = true,
			[ERR_OUT_OF_ENERGY] = true,
			[ERR_OUT_OF_FOCUS] = true,
			[ERR_OUT_OF_HEALTH] = true,
			[ERR_OUT_OF_HOLY_POWER] = true,
			[ERR_OUT_OF_LIGHT_FORCE] = false,
			[ERR_OUT_OF_MANA] = true,
			[ERR_OUT_OF_POWER_DISPLAY] = false,
			[ERR_OUT_OF_RAGE] = true,
			[ERR_OUT_OF_RANGE] = true,
			[ERR_OUT_OF_RUNES] = true,
			[ERR_OUT_OF_RUNIC_POWER] = true,
			[ERR_OUT_OF_SHADOW_ORBS] = true,
			[ERR_OUT_OF_SOUL_SHARDS] = true,
			[ERR_SPELL_COOLDOWN] = true,
			[ERR_SPELL_OUT_OF_RANGE] = true,
			[ERR_TOO_FAR_TO_INTERACT] = true,
			[ERR_USE_BAD_ANGLE] = true,
			[ERR_USE_CANT_IMMUNE] = false,
			[ERR_USE_TOO_FAR] = true,

			-- Spell failed...
			[SPELL_FAILED_ABOVE_MAXIMUM_SKILL_RANK] = false,
			[SPELL_FAILED_AFFECTING_COMBAT] = false,
			[SPELL_FAILED_AURA_BOUNCED] = false,
			[SPELL_FAILED_BAD_IMPLICIT_TARGETS] = false,
			[SPELL_FAILED_BAD_TARGETS] = true,
			[SPELL_FAILED_CANT_BE_CHARMED] = false,
			[SPELL_FAILED_CANT_DO_THAT_RIGHT_NOW] = true,
			[SPELL_FAILED_CANT_STEALTH] = false,
			[SPELL_FAILED_CASTER_AURASTATE] = true,
			[SPELL_FAILED_CASTER_DEAD] = true,
			[SPELL_FAILED_CASTER_DEAD_FEMALE] = true,
			[SPELL_FAILED_CAST_NOT_HERE] = false,
			[SPELL_FAILED_CHARMED] = true,
			[SPELL_FAILED_CHEST_IN_USE] = false,
			[SPELL_FAILED_CONFUSED] = true,
			[SPELL_FAILED_DAMAGE_IMMUNE] = false,
			[SPELL_FAILED_FALLING] = true,
			[SPELL_FAILED_FLEEING] = true,
			[SPELL_FAILED_IMMUNE] = true,
			[SPELL_FAILED_INCORRECT_AREA] = false,
			[SPELL_FAILED_INTERRUPTED] = false,
			[SPELL_FAILED_INTERRUPTED_COMBAT] = false,
			[SPELL_FAILED_IN_COMBAT_RES_LIMIT_REACHED] = false,
			[SPELL_FAILED_LINE_OF_SIGHT] = false,
			[SPELL_FAILED_LOWLEVEL] = false,
			[SPELL_FAILED_LOW_CASTLEVEL] = false,
			[SPELL_FAILED_MOVING] = true,
			[SPELL_FAILED_NOPATH] = true,
			[SPELL_FAILED_NOTHING_TO_DISPEL] = false,
			[SPELL_FAILED_NOTHING_TO_STEAL] = false,
			[SPELL_FAILED_NOT_BEHIND] = false,
			[SPELL_FAILED_NOT_FISHABLE] = false,
			[SPELL_FAILED_NOT_FLYING] = false,
			[SPELL_FAILED_NOT_INFRONT] = false,
			[SPELL_FAILED_NOT_IN_CONTROL] = false,
			[SPELL_FAILED_NOT_KNOWN] = false,
			[SPELL_FAILED_NOT_MOUNTED] = false,
			[SPELL_FAILED_NOT_ON_DAMAGE_IMMUNE] = false,
			[SPELL_FAILED_NOT_ON_GROUND] = false,
			[SPELL_FAILED_NOT_ON_MOUNTED] = false,
			[SPELL_FAILED_NOT_ON_SHAPESHIFT] = false,
			[SPELL_FAILED_NOT_ON_STEALTHED] = false,
			[SPELL_FAILED_NOT_ON_TAXI] = false,
			[SPELL_FAILED_NOT_ON_TRANSPORT] = false,
			[SPELL_FAILED_NOT_READY] = false,
			[SPELL_FAILED_NOT_SHAPESHIFT] = false,
			[SPELL_FAILED_NOT_STANDING] = false,
			[SPELL_FAILED_NOT_WHILE_FATIGUED] = false,
			[SPELL_FAILED_NOT_WHILE_GHOST] = true,
			[SPELL_FAILED_NOT_WHILE_LOOTING] = false,
			[SPELL_FAILED_NO_ACTIONS] = false,
			[SPELL_FAILED_NO_CHARGES_REMAIN] = false,
			[SPELL_FAILED_NO_COMBO_POINTS] = true,
			[SPELL_FAILED_NO_ITEMS_WHILE_SHAPESHIFTED] = false,
			[SPELL_FAILED_NO_PET] = false,
			[SPELL_FAILED_ONLY_STEALTHED] = false,
			[SPELL_FAILED_OUT_OF_RANGE] = true,
			[SPELL_FAILED_PACIFIED] = true,
			[SPELL_FAILED_POSSESSED] = true,
			[SPELL_FAILED_PREVENTED_BY_MECHANIC] = false,
			[SPELL_FAILED_ROOTED] = true,
			[SPELL_FAILED_SILENCED] = true,
			[SPELL_FAILED_SPELL_IN_PROGRESS] = false,
			[SPELL_FAILED_SPELL_LEARNED] = false,
			[SPELL_FAILED_STUNNED] = true,
			[SPELL_FAILED_SUMMON_PENDING] = false,
			[SPELL_FAILED_TARGETS_DEAD] = true,
			[SPELL_FAILED_TARGET_AFFECTING_COMBAT] = false,
			[SPELL_FAILED_TARGET_AURASTATE] = false,
			[SPELL_FAILED_TARGET_ENRAGED] = false,
			[SPELL_FAILED_TARGET_FRIENDLY] = false,
			[SPELL_FAILED_TOO_CLOSE] = false,
			[SPELL_FAILED_UNIT_NOT_BEHIND] = false,
			[SPELL_FAILED_UNIT_NOT_INFRONT] = false,
			[SPELL_FAILED_VISION_OBSCURED] = false,
		},
		custom_filters = {},
		custom_allows = {},
		sink20OutputSink = "UIErrorsFrame",
	},
}
-- sort by key
local a = {}
local filters_order = {}
for n in pairs(DATABASE_DEFAULTS.profile.filters) do table.insert(a, n) end
table.sort(a)
for i, n in ipairs(a) do filters_order[n] = i end

a = {}
local allows_order = {}
for n in pairs(DATABASE_DEFAULTS.profile.allows) do table.insert(a, n) end
table.sort(a)
for i, n in ipairs(a) do allows_order[n] = i end

local DO_NOTHING = 0
local FILTER_ONLY = 1
local ALLOW_ONLY = 2
local FILTER_ALL = 3
local ALLOW_ALL = 4

local IN_COMBAT = 0
local OUT_OF_COMBAT = 1
local state = OUT_OF_COMBAT

local lastDisplay = {}

--------------------------------------------------------------------------------------------------------
--                                   ErrorFilter options panel                                        --
--------------------------------------------------------------------------------------------------------
local function GetCvarToggle(info)
	local value = GetCVar(info.arg)
	if value == "1" then
		return true
	else
		return false
	end
end

local function SetCvarToggle(info, value)
	if InCombatLockdown() then
		print("We're unable to change this while in combat")
	else
		SetCVar(info.arg,value)
	end
end

addon.options = {
	type = "group",
	name = MODNAME,
	args = {
		general = {
			order = 1,
			type = "group",
			name = L["General Settings"],
			cmdInline = true,
			args = {
				removeFrame = {
					order = 1,
					type = "toggle",
					name = L["Remove UIErrorFrame."],
					desc = L["Toggle to hide the game's message box."],
					get = function()
						return profileDB.removeFrame
					end,
					set = function(key, value)
						profileDB.removeFrame = value
						addon:UpdateEvents()
					end,
				},
				warning1 = {
					order = 2,
					type = "description",
					name = "|cFFFF0202"..L["Warning! This will prevent any message from appearing in the UI Error Frame, including quest updates text."].."|r",
					hidden = function()
						return not profileDB.removeFrame
					end,
				},
				errorMessages = {
					order = 10,
					type = "group",
					name = L["Error messages"],
					inline = true,
					disabled = function()
						return profileDB.removeFrame
					end,
					args = {
						mode = {
							order = 1,
							type = "select",
							style = "dropdown",
							name = L["Operation mode:"],
							desc = L["Choose how do you want ErrorFilter to work."],
							get = function()
								return profileDB.mode
							end,
							set = function(key, value)
								profileDB.mode = value
								addon:UpdateEvents()
							end,
							values = function()
								return {
									[DO_NOTHING] = L["Do nothing"],
									[FILTER_ONLY] = L["Filter only ..."],
									[ALLOW_ONLY] = L["Allow only ..."],
									[FILTER_ALL] = L["Filter all errors"],
									[ALLOW_ALL] = L["Allow all errors"],
								}
							end,
						},
						warning1 = {
							order = 2,
							type = "execute",
							name = L["Set filters"],
							desc = L["Open the menu to set custom filters."],
							func = function()
								InterfaceOptionsFrame_OpenToCategory(addon.optionsFrames.filters)
							end,
							hidden = function()
								return profileDB.mode ~= FILTER_ONLY
							end,
						},
						warning2 = {
							order = 3,
							type = "execute",
							name = L["Set filters"],
							desc = L["Open the menu to set custom filters."],
							func = function()
								InterfaceOptionsFrame_OpenToCategory(addon.optionsFrames.allows)
							end,
							hidden = function()
								return profileDB.mode ~= ALLOW_ONLY
							end,
						},
						separator1 = {
							order = 4,
							type = "description",
							name = "",
						},
						warning3 = {
							order = 5,
							type = "description",
							name = "|cFFFF0202"..L["Warning! This will prevent all error messages from appearing."].."|r",
							hidden = function()
								return profileDB.mode ~= FILTER_ALL
							end,
						},
						warning4 = {
							order = 6,
							type = "description",
							name = "|cFFFF0202"..L["Warning! This will allow all error messages to the selected output."].."|r",
							hidden = function()
								return profileDB.mode ~= ALLOW_ALL
							end,
						},
						combat = {
							order = 7,
							type = "toggle",
							name = L["Filter only in combat."],
							desc = L["Toggle to stop filtering while out of combat."],
							get = function()
								return profileDB.updateOnlyInCombat
							end,
							set = function(key, value)
								profileDB.updateOnlyInCombat = value
							end,
							hidden = function()
								return profileDB.mode == DO_NOTHING or profileDB.mode == ALLOW_ALL
							end,
						},
						throttle = {
							order = 8,
							type = "toggle",
							name = L["Throttle messages."],
							desc = L["Toggle to allow each message only once every 5 seconds."],
							get = function()
								return profileDB.throttle
							end,
							set = function(key, value)
								profileDB.throttle = value
							end,
							hidden = function()
								return profileDB.mode == DO_NOTHING
							end,
						},
					},
				},
				questMessages = {
					order = 20,
					type = "group",
					name = L["Quest messages"],
					inline = true,
					disabled = function()
						return profileDB.removeFrame
					end,
					args = {
						mode = {
							order = 1,
							type = "select",
							style = "dropdown",
							name = L["Operation mode:"],
							desc = L["Choose how do you want ErrorFilter to work."],
							get = function()
								return profileDB.q_mode
							end,
							set = function(key, value)
								profileDB.q_mode = value
								addon:UpdateEvents()
							end,
							values = function()
								return {
									[DO_NOTHING] = L["Do nothing"],
									[FILTER_ALL] = L["Filter all messages"],
									[ALLOW_ALL] = L["Allow all messages"],
								}
							end,
						},
						separator = {
							order = 2,
							type = "description",
							name = "",
						},
						warning1 = {
							order = 3,
							type = "description",
							name = "|cFFFF0202"..L["Warning! This will prevent all quest messages from appearing."].."|r",
							hidden = function()
								return profileDB.q_mode ~= FILTER_ALL
							end,
						},
						warning2 = {
							order = 4,
							type = "description",
							name = "|cFFFF0202"..L["Warning! This will allow all quest messages to the selected output."].."|r",
							hidden = function()
								return profileDB.q_mode ~= ALLOW_ALL
							end,
						},
						combat = {
							order = 5,
							type = "toggle",
							name = L["Filter only in combat."],
							desc = L["Toggle to stop filtering while out of combat."],
							get = function()
								return profileDB.q_updateOnlyInCombat
							end,
							set = function(key, value)
								profileDB.q_updateOnlyInCombat = value
							end,
							hidden = function()
								return profileDB.q_mode == DO_NOTHING or profileDB.q_mode == ALLOW_ALL
							end,
						},
					},
				},
				sound = {
					order = 30,
					type = "group",
					name = L["Sound Settings"],
					inline = true,
					args = {
						enableErrorSpeech = {
							order = 1,
							type = "toggle",
							name = L["Enable Error Speech."],
							desc = L["Toggle to enable the game's sound option error speech."],
							get = GetCvarToggle,
							set = SetCvarToggle,
							arg = "Sound_EnableErrorSpeech",
						},
					},
				},
			},
		},
		filters = {
			order = 1,
			type = "group",
			name = L["Filtered errors"],
			args = {
				separator1 = {
					order = 1,
					type = "header",
					name = "|cFF02FF02"..L["Manage custom filters:"].."|r",
				},
				new = {
					order = 2,
					type = "input",
					width = "full",
					name = L["New"],
					desc = L["Add a new string."],
					get = false,
					set = function(key, value)
						tinsert(profileDB.custom_filters, string.lower(value))
					end,
					disabled = function()
						return profileDB.mode ~= FILTER_ONLY or profileDB.removeFrame
					end,
				},
				delete = {
					order = 3,
					type = "select",
					width = "full",
					name = L["Delete"],
					desc = L["Delete a string from the list"],
					get = false,
					set = function(key, value)
						tremove(profileDB.custom_filters, value)
					end,
					values = function()
						return profileDB.custom_filters
					end,
					disabled = function()
						return not (#profileDB.custom_filters > 0) or profileDB.mode ~= FILTER_ONLY or profileDB.removeFrame
					end,
				},
				separator2 = {
					order = 9,
					type = "description",
					name = "\n",
				},
				separator3 = {
					order = 10,
					type = "header",
					name = "|cFF02FF02"..L["Choose the errors you do not want to see:"].."|r",
				},
			},
		},
		allows = {
			order = 1,
			type = "group",
			name = L["Allowed errors"],
			args = {
				separator1 = {
					order = 1,
					type = "header",
					name = "|cFF02FF02"..L["Manage custom allows:"].."|r",
				},
				new = {
					order = 2,
					type = "input",
					width = "full",
					name = L["New"],
					desc = L["Add a new string."],
					get = false,
					set = function(key, value)
						tinsert(profileDB.custom_allows, string.lower(value))
					end,
					disabled = function()
						return profileDB.mode ~= ALLOW_ONLY or profileDB.removeFrame
					end,
				},
				delete = {
					order = 3,
					type = "select",
					width = "full",
					name = L["Delete"],
					desc = L["Delete a string from the list"],
					get = false,
					set = function(key, value)
						tremove(profileDB.custom_allows, value)
					end,
					values = function()
						return profileDB.custom_allows
					end,
					disabled = function()
						return not (#profileDB.custom_allows > 0) or profileDB.mode ~= ALLOW_ONLY or profileDB.removeFrame
					end,
				},
				separator2 = {
					order = 9,
					type = "description",
					name = "\n",
				},
				separator3 = {
					order = 10,
					type = "header",
					name = "|cFF02FF02"..L["Choose the errors you want to see:"].."|r",
				},
			},
		},
	},
}

-- generate filters submenu
for k, v in pairs(DATABASE_DEFAULTS.profile.filters) do
	addon.options.args.filters.args[string.format("error"..filters_order[k])] = {
		order = 10 + filters_order[k],
		width = "full",
		type = "toggle",
		name = k,
		desc = L["Toggle to filter this error."],
		get = function()
			return profileDB.filters[k]
		end,
		set = function(key, value)
			profileDB.filters[k] = value
		end,
		disabled = function()
			return profileDB.mode ~= FILTER_ONLY or profileDB.removeFrame
		end,
	}
end

-- generate allows submenu
for k, v in pairs(DATABASE_DEFAULTS.profile.allows) do
	addon.options.args.allows.args[string.format("allow"..allows_order[k])] = {
		order = 10 + allows_order[k],
		width = "full",
		type = "toggle",
		name = k,
		desc = L["Toggle to allow this error."],
		get = function()
			return profileDB.allows[k]
		end,
		set = function(key, value)
			profileDB.allows[k] = value
		end,
		disabled = function()
			return profileDB.mode ~= ALLOW_ONLY or profileDB.removeFrame
		end,
	}
end

function addon:SetupOptions()
	-- LibSink options
	addon.options.args.output = self:GetSinkAce3OptionsDataTable()

	-- profile options
	addon.options.args.profile = AceDBOptions:GetOptionsTable(self.db)
	addon.options.args.profile.order = -2

	AceConfig:RegisterOptionsTable(MODNAME, addon.options, nil)

	self.optionsFrames = {}
	self.optionsFrames.general = AceConfigDialog:AddToBlizOptions(MODNAME, nil, nil, "general")
	self.optionsFrames.filters = AceConfigDialog:AddToBlizOptions(MODNAME, L["Filter only ..."], MODNAME, "filters")
	self.optionsFrames.allows = AceConfigDialog:AddToBlizOptions(MODNAME, L["Allow only ..."], MODNAME, "allows")
	self.optionsFrames.output = AceConfigDialog:AddToBlizOptions(MODNAME, L["Output"], MODNAME, "output")
	self.optionsFrames.profile = AceConfigDialog:AddToBlizOptions(MODNAME, L["Profiles"], MODNAME, "profile")
end

--------------------------------------------------------------------------------------------------------
--                                            ErrorFilter Init                                        --
--------------------------------------------------------------------------------------------------------
function addon:OnInitialize()
	self.db = AceDB:New("ErrorFilterDB", DATABASE_DEFAULTS, true)
	if not self.db then
		Print("Error: Database not loaded correctly. Please exit out of WoW and delete ErrorFilter.lua found in: \\World of Warcraft\\WTF\\Account\\<Account Name>>\\SavedVariables\\")
	end

	-- LibSink options storage
	self:SetSinkStorage(self.db.profile)

	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")

	profileDB = self.db.profile
	self:SetupOptions()

	-- Create slash commands
	SLASH_ErrorFilter1 = "/erf"
	SLASH_ErrorFilter2 = "/errorfilter"
	SlashCmdList["ErrorFilter"] = addon.ShowConfig

	-- Register events
	self:UpdateEvents()

	self:RegisterEvent("PLAYER_REGEN_ENABLED","OnRegenEnable")
	self:RegisterEvent("PLAYER_REGEN_DISABLED","OnRegenDisable")
end

--------------------------------------------------------------------------------------------------------
--                                       ErrorFilter event handlers                                   --
--------------------------------------------------------------------------------------------------------
function addon:OnInfoMessage(self, event, messageType, message)
	if (profileDB.q_mode == FILTER_ALL) and ((state == IN_COMBAT) or not profileDB.q_updateOnlyInCombat) then
		return
	end
	addon:OutputMessage(messageType, message, 1.0, 1.0, 0.0)
end

function addon:OnErrorMessage(self, event, messageType, message)
	if profileDB.throttle then
		if lastDisplay[message] and (lastDisplay[message] + 5 > GetTime()) then return end
		lastDisplay[message] = GetTime()
	end
	if ((state == OUT_OF_COMBAT) and profileDB.updateOnlyInCombat) or (profileDB.mode == ALLOW_ALL) then
		addon:OutputMessage(messageType, message, 1.0, 0.1, 0.1)
		return
	end
	if profileDB.mode == FILTER_ONLY then
		-- check default filters
		if profileDB.filters[message] then
			return
		end
		-- check custom filters
		for k, v in next, profileDB.custom_filters do
			if string.find(string.lower(message), v) then
				return
			end
		end
		addon:OutputMessage(messageType, message, 1.0, 0.1, 0.1)
	elseif profileDB.mode == ALLOW_ONLY then
		-- check default allows
		if profileDB.allows[message] then
			addon:OutputMessage(messageType, message, 1.0, 0.1, 0.1)
			return
		end
		-- check custom allows
		for k, v in next, profileDB.custom_allows do
			if string.find(string.lower(message), v) then
				addon:OutputMessage(messageType, message, 1.0, 0.1, 0.1)
				return
			end
		end
	end
end

function addon:OnRegenEnable()
	state = OUT_OF_COMBAT
end

function addon:OnRegenDisable()
	state = IN_COMBAT
end

--------------------------------------------------------------------------------------------------------
--                                        ErrorFilter functions                                       --
--------------------------------------------------------------------------------------------------------
-- Called after profile changed
function addon:OnProfileChanged(event, database, newProfileKey)
	profileDB = database.profile
end

-- Open config window
function addon:ShowConfig()
	-- call twice to workaround a bug in Blizzard's function
	InterfaceOptionsFrame_OpenToCategory(addon.optionsFrames.profile)
	InterfaceOptionsFrame_OpenToCategory(addon.optionsFrames.profile)
	InterfaceOptionsFrame_OpenToCategory(addon.optionsFrames.general)
end

-- Check options and set events
function addon:UpdateEvents()
	if profileDB.removeFrame then
		UIErrorsFrame:Hide()
		self:UnregisterEvent("UI_INFO_MESSAGE")
		self:UnregisterEvent("UI_ERROR_MESSAGE")
	else
		UIErrorsFrame:Show()
		-- INFO
		if profileDB.q_mode == DO_NOTHING then
			UIErrorsFrame:RegisterEvent("UI_INFO_MESSAGE")
			self:UnregisterEvent("UI_INFO_MESSAGE")
		else
			UIErrorsFrame:UnregisterEvent("UI_INFO_MESSAGE")
			self:RegisterEvent("UI_INFO_MESSAGE","OnInfoMessage", self)
		end
		-- ERROR
		if profileDB.mode == DO_NOTHING then
			UIErrorsFrame:RegisterEvent("UI_ERROR_MESSAGE")
			self:UnregisterEvent("UI_ERROR_MESSAGE")
		else
			UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
			self:RegisterEvent("UI_ERROR_MESSAGE","OnErrorMessage", self)
		end
	end
end

function addon:OutputMessage(messageType, message, r, g, b)
	addon:Pour(message, r, g, b)

	local errorName, soundKitID, voiceID = GetGameMessageInfo(messageType);
	if voiceID then
		PlayVocalErrorSoundID(voiceID);
	elseif soundKitID then
		PlaySound(soundKitID);
	end
end
