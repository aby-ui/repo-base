-- ----------------------------------------------------------------------------
-- Localized Lua globals.
-- ----------------------------------------------------------------------------
-- Libraries
local table = _G.table

-- Functions
local pairs = _G.pairs

-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local AddOnFolderName, private = ...

local LibStub = _G.LibStub
local NPCScan = LibStub("AceAddon-3.0"):GetAddon(AddOnFolderName)
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnFolderName)

local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
local LibSharedMedia = LibStub("LibSharedMedia-3.0")

-- ----------------------------------------------------------------------------
-- Constants.
-- ----------------------------------------------------------------------------
local SOUND_CHANNELS = {
	"Ambience",
	"Master",
	"Music",
	"SFX",
}

local LOCALIZED_SOUND_CHANNELS = {
	_G.AMBIENCE_VOLUME,
	_G.MASTER,
	_G.MUSIC_VOLUME,
	_G.SOUND_VOLUME,
}

local SOUND_CHANNEL_INDICES = {}

for index = 1, #SOUND_CHANNELS do
	SOUND_CHANNEL_INDICES[SOUND_CHANNELS[index]] = index
end

-- ----------------------------------------------------------------------------
-- Variables.
-- ----------------------------------------------------------------------------
local profile
local AlertNamesOptions = {}

-- ----------------------------------------------------------------------------
-- Helpers.
-- ----------------------------------------------------------------------------
local function UpdateAlertNamesOptions()
	local sharedMediaNames = profile.alert.sound.sharedMediaNames
	local sortedSoundNames = {}

	for soundName in pairs(sharedMediaNames) do
		if sharedMediaNames[soundName] ~= false then
			sortedSoundNames[#sortedSoundNames + 1] = soundName
		end
	end

	table.sort(sortedSoundNames)
	table.wipe(AlertNamesOptions)

	for index = 1, #sortedSoundNames do
		local soundName = sortedSoundNames[index]

		AlertNamesOptions[soundName .. index] = {
			order = index,
			name = soundName,
			descStyle = "inline",
			type = "toggle",
			width = "full",
			get = function()
				return true
			end,
			set = function()
				if private.DefaultPreferences.profile.alert.sound.sharedMediaNames[soundName] then
					sharedMediaNames[soundName] = false
				else
					sharedMediaNames[soundName] = nil
				end

				UpdateAlertNamesOptions()
			end,
		}
	end

	AceConfigRegistry:NotifyChange(AddOnFolderName)
end

-- ----------------------------------------------------------------------------
-- Initialization.
-- ----------------------------------------------------------------------------
local AlertOptions
local firstRun = true

local function GetAlertOptions()
	profile = private.db.profile

	local function IsSoundDisabled()
		return not profile.alert.sound.isEnabled
	end

	if not AlertOptions then
		LibSharedMedia:Register("sound", "NPCScan Killed", [[Sound\Interface\RaidBossWarning.ogg]])
		LibSharedMedia:Register("sound", "NPCScan Chimes", [[Sound\Interface\UI_Legendary_Item_Toast.ogg]])
		LibSharedMedia:Register("sound", "NPCScan Gruntling Horn", [[Sound\Events\gruntling_horn_bb.ogg]])
		LibSharedMedia:Register("sound", "NPCScan Ogre War Drums", [[Sound\Event Sounds\Event_wardrum_ogre.ogg]])
		LibSharedMedia:Register("sound", "NPCScan Scourge Horn", [[Sound\Events\scourge_horn.ogg]])
	end

	AlertOptions = AlertOptions or {
		order = 4,
		name = L["Alerts"],
		descStyle = "inline",
		type = "group",
		childGroups = "tree",
		args = {
			screenFlash = {
				order = 2,
				name = L["Screen Flash"],
				type = "group",
				args = {
					isEnabled = {
						order = 1,
						name = _G.ENABLE,
						descStyle = "inline",
						type = "toggle",
						width = "full",
						get = function()
							return profile.alert.screenFlash.isEnabled
						end,
						set = function(_, value)
							profile.alert.screenFlash.isEnabled = value
						end,
					},
					texture = {
						order = 2,
						name = _G.TEXTURES_SUBHEADER,
						descStyle = "inline",
						type = "select",
						dialogControl = 'LSM30_Background',
						values = _G.AceGUIWidgetLSMlists.background,
						disabled = function()
							return not profile.alert.screenFlash.isEnabled
						end,
						get = function()
							return profile.alert.screenFlash.texture
						end,
						set = function(_, value)
							profile.alert.screenFlash.texture = value
						end,
					},
					color = {
						order = 3,
						name = _G.COLOR,
						descStyle = "inline",
						hasAlpha = true,
						type = "color",
						disabled = function()
							return not profile.alert.screenFlash.isEnabled
						end,
						get = function()
							local color = profile.alert.screenFlash.color

							if color then
								return color.r, color.g, color.b, color.a else return 0, 0, 0, 1
							end
						end,
						set = function(_, r, g, b, a)
							local color = profile.alert.screenFlash.color

							if not color then
								profile.alert.screenFlash.color = {
									r = r,
									g = g,
									b = b,
									a = a
								}
							else
								color.r = r
								color.g = g
								color.b = b
								color.a = a
							end
						end,
					},
					preview = {
						order = 4,
						name = _G.PREVIEW,
						descStyle = "inline",
						type = "execute",
						width = "normal",
						disabled = function()
							return not profile.alert.screenFlash.isEnabled
						end,
						func = function()
							local alert = profile.alert
							NPCScan:PlayFlashAnimation(alert.screenFlash.texture, alert.screenFlash.color)
						end,
					},
				},
			},
			sound = {
				order = 3,
				name = _G.SOUND,
				descStyle = "inline",
				type = "group",
				args = {
					isEnabled = {
						order = 10,
						name = _G.ENABLE,
						descStyle = "inline",
						type = "toggle",
						get = function()
							return profile.alert.sound.isEnabled
						end,
						set = function(_, value)
							profile.alert.sound.isEnabled = value
						end,
					},
					ignoreMute = {
						order = 20,
						name = L["Ignore Mute"],
						desc = L["Play alert sounds when sound is muted."],
						type = "toggle",
						width = "double",
						disabled = IsSoundDisabled,
						get = function()
							return profile.alert.sound.ignoreMute
						end,
						set = function(_, value)
							profile.alert.sound.ignoreMute = value
						end,
					},
					channel = {
						order = 30,
						name = _G.SOUND_CHANNELS,
						descStyle = "inline",
						type = "select",
						values = LOCALIZED_SOUND_CHANNELS,
						disabled = IsSoundDisabled,
						get = function()
							return SOUND_CHANNEL_INDICES[profile.alert.sound.channel]
						end,
						set = function(_, value)
							profile.alert.sound.channel = SOUND_CHANNELS[value]
						end,
					},
					addAlertSound = {
						order = 40,
						name = _G.ADD,
						descStyle = "inline",
						type = "select",
						dialogControl = "LSM30_Sound",
						values = _G.AceGUIWidgetLSMlists.sound,
						disabled = IsSoundDisabled,
						get = function()
							-- Intentionally empty, since there can be multiple sounds.
						end,
						set = function(_, value)
							profile.alert.sound.sharedMediaNames[value] = true
							UpdateAlertNamesOptions()
						end,
					},
					sharedMediaNames = {
						order = 50,
						name = _G.ASSIGNED_COLON,
						type = "group",
						inline = true,
						disabled = IsSoundDisabled,
						args = AlertNamesOptions,
					},
					preview = {
						order = 60,
						name = _G.PREVIEW,
						descStyle = "inline",
						type = "execute",
						width = "normal",
						disabled = IsSoundDisabled,
						func = function()
							private.PlayAlertSounds(true)
						end,
					},
				},
			},
		},
	}

	UpdateAlertNamesOptions()

	if firstRun then
		firstRun = nil

		local output = NPCScan:GetSinkAce3OptionsDataTable()
		output.order = 1

		AlertOptions.args.output = output
	end

	return AlertOptions
end

private.GetAlertOptions = GetAlertOptions
