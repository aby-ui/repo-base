-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

local LibStub = _G.LibStub

local RareScanner = LibStub("AceAddon-3.0"):GetAddon("RareScanner")
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner", false)

-----------------------------------------------------------------------
-- Config option functions.
-----------------------------------------------------------------------

private.SOUNDS = {
	["Achievement Sound"] = 12891,
	["Alarm Clock"] = 12867,
	["Boat Docking"] = 5495,
	["Siege Engineer Weapon"] = 38324,
	["PVP Alliance"] = 8332,
	["PVP Horde"] = 8333,
	["Ready Check"] = 8960,
	["Horn"] = 15880,
	["Event Wardrum Ogre"] = 11773,
	["Level Up"] = 124,
}

private.MARKERS = {
	["Star"] = "Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_1",
	["Circle"] = "Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_2",
	["Diamond"] = "Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_3",
	["Triangle"] = "Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_4",
	["Moon"] = "Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_5",
	["Square"] = "Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_6",
	["Cross"] = "Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_7",
	["Skull"] = "Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_8",
}

private.TOOLTIP_POSITIONS = {
	["ANCHOR_LEFT"] = AL["TOOLTIP_LEFT"],
	["ANCHOR_RIGHT"] = AL["TOOLTIP_RIGHT"],
	["ANCHOR_CURSOR"] = AL["TOOLTIP_CURSOR"],
	["ANCHOR_TOPLEFT"] = AL["TOOLTIP_TOP"],
	["ANCHOR_BOTTOMLEFT"] = AL["TOOLTIP_BOTTOM"],
}

private.ITEM_QUALITY = {
	[0] = ITEM_QUALITY0_DESC,
	[1] = ITEM_QUALITY1_DESC,
	[2] = ITEM_QUALITY2_DESC,
	[3] = ITEM_QUALITY3_DESC,
	[4] = ITEM_QUALITY4_DESC,
	[5] = ITEM_QUALITY5_DESC,
	[6] = ITEM_QUALITY6_DESC,
	[7] = ITEM_QUALITY7_DESC,
}

local WEAPONS_ID = 2
local ONEH_AXES_ID = 0
local TWOH_AXES_ID = 1
local BOW_ID = 2
local GUNS_ID = 3
local ONEH_MACE_ID = 4
local TWOH_MACE_ID = 5
local POLEARMS_ID = 6
local ONEH_SWORD_ID = 7
local TWOH_SWORD_ID = 8
local WAR_GLAIVES_ID = 9
local STAVES_ID = 10
local BEAR_PAWS_ID = 11 --CHECK (druid?)
local TWOH_EXOTIC_ID = 12 --CHECK (none uses it)
local FIST_ID = 13
local MISC_ID = 14
local DAGGER_ID = 15
local THROW_WEAPON_ID = 16 --CHECK (none uses it)
local SPEAR_ID = 17 --CHECK (none uses it)
local CROSSBOW_ID = 18
local WANDS_ID = 19
local FISHPOLE_ID = 20

local ARMOR_ID = 4
local ARMOR_MISC_ID = 0
local CLOTH_ID = 1
local LEATHER_ID = 2
local MAIL_ID = 3
local PLATE_ID = 4
local COSMETIC_ID = 5
local SHIELD_ID = 6
local LIBRAM_ID = 7 --CHECK (none uses it)
local IDOL_ID = 8 --CHECK (none uses it)
local TOTEM_ID = 9 --CHECK (none uses it)
local SIGIL_ID = 10 --CHECK (none uses it)
local ARTIFACT_ID = 11

private.ITEM_CLASSES = {
	[0] = { 0, 1, 2, 3, 5, 7, 8, 9 }, --consumables
	[1] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, --bags
	[WEAPONS_ID] = { ONEH_AXES_ID, TWOH_AXES_ID, BOW_ID, GUNS_ID, ONEH_MACE_ID, TWOH_MACE_ID, POLEARMS_ID, ONEH_SWORD_ID, TWOH_SWORD_ID, WAR_GLAIVES_ID, STAVES_ID, BEAR_PAWS_ID, TWOH_EXOTIC_ID, FIST_ID, MISC_ID, DAGGER_ID, THROW_WEAPON_ID, SPEAR_ID, CROSSBOW_ID, WANDS_ID, FISHPOLE_ID }, --weapons
	[3] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 }, --gemes
	[ARMOR_ID] = { ARMOR_MISC_ID, CLOTH_ID, LEATHER_ID, MAIL_ID, PLATE_ID, COSMETIC_ID, SHIELD_ID, LIBRAM_ID, IDOL_ID, TOTEM_ID, SIGIL_ID, ARTIFACT_ID }, --armor
	[5] = { 0, 1 }, --consumable
	[6] = { 2, 3 }, --projectile
	[7] = { 1, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 16 }, --tradeables
	[8] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 }, --object improvements
	[9] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 }, --recipes
	-- [10] = { }, --money (obsolete)
	-- [11] = { 0 }, --quiver  (obsolete)
	[12] = { 0 }, --quests
	[13] = { 0, 1 }, --keys
	-- [14] = { }, --permanent (obsolete)
	[15] = { 0, 1, 2, 3, 4, 5 }, --miscellaneous
	--[16] = { 0 }, --glyphs
	[17] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 }, --battle pets
}

private.CLASS_PROFICIENCIES = {
	[1] = { --Warrior
		[WEAPONS_ID] = { BOW_ID, POLEARMS_ID, GUNS_ID, FIST_ID, CROSSBOW_ID, STAVES_ID, FISHPOLE_ID, DAGGER_ID, TWOH_SWORD_ID, ONEH_SWORD_ID, TWOH_AXES_ID, ONEH_AXES_ID, TWOH_MACE_ID, ONEH_MACE_ID, MISC_ID },
		[ARMOR_ID] = { CLOTH_ID, PLATE_ID, SHIELD_ID, COSMETIC_ID, ARMOR_MISC_ID, ARTIFACT_ID }
	};
	[2] = { --Paladin
		[WEAPONS_ID] = { POLEARMS_ID, FISHPOLE_ID, TWOH_SWORD_ID, ONEH_SWORD_ID, TWOH_AXES_ID, ONEH_AXES_ID, TWOH_MACE_ID, ONEH_MACE_ID, MISC_ID },
		[ARMOR_ID] = { CLOTH_ID, PLATE_ID, SHIELD_ID, COSMETIC_ID, ARMOR_MISC_ID, ARTIFACT_ID } 
	};
	[3] = { --Hunter
		[WEAPONS_ID] = { BOW_ID, POLEARMS_ID, GUNS_ID, FIST_ID, CROSSBOW_ID, STAVES_ID, FISHPOLE_ID, DAGGER_ID, TWOH_SWORD_ID, ONEH_SWORD_ID, TWOH_AXES_ID, ONEH_AXES_ID, MISC_ID },
		[ARMOR_ID] = { CLOTH_ID, MAIL_ID, COSMETIC_ID, ARMOR_MISC_ID, ARTIFACT_ID }
	};
	[4] = { --Rogue
		[WEAPONS_ID] = { BOW_ID, GUNS_ID, FIST_ID, CROSSBOW_ID, FISHPOLE_ID, DAGGER_ID, ONEH_SWORD_ID, ONEH_AXES_ID, ONEH_MACE_ID, MISC_ID },
		[ARMOR_ID] = { CLOTH_ID, LEATHER_ID, COSMETIC_ID, ARMOR_MISC_ID, ARTIFACT_ID }
	};
	[5] = { --Priest
		[WEAPONS_ID] = { STAVES_ID, FISHPOLE_ID, DAGGER_ID, ONEH_MACE_ID, MISC_ID, WANDS_ID },
		[ARMOR_ID] = { CLOTH_ID, COSMETIC_ID, ARMOR_MISC_ID, ARTIFACT_ID }
	};
	[6] = { --DeathKnight
		[WEAPONS_ID] = { POLEARMS_ID, FISHPOLE_ID, TWOH_SWORD_ID, ONEH_SWORD_ID, TWOH_AXES_ID, ONEH_AXES_ID, TWOH_MACE_ID, ONEH_MACE_ID, MISC_ID },
		[ARMOR_ID] = { CLOTH_ID, PLATE_ID, COSMETIC_ID, ARMOR_MISC_ID, ARTIFACT_ID }
	};
	[7] = { --Shaman
		[WEAPONS_ID] = { FIST_ID, STAVES_ID, FISHPOLE_ID, DAGGER_ID, TWOH_AXES_ID, ONEH_AXES_ID, TWOH_MACE_ID, ONEH_MACE_ID, MISC_ID },
		[ARMOR_ID] = { CLOTH_ID, MAIL_ID, SHIELD_ID, COSMETIC_ID, ARMOR_MISC_ID, ARTIFACT_ID }
	};
	[8] = { --Mage
		[WEAPONS_ID] = { STAVES_ID, FISHPOLE_ID, DAGGER_ID, ONEH_SWORD_ID, MISC_ID, WANDS_ID },
		[ARMOR_ID] = { CLOTH_ID, COSMETIC_ID, ARMOR_MISC_ID, ARTIFACT_ID }
	};
	[9] = { --Warlock	
		[WEAPONS_ID] = { STAVES_ID, FISHPOLE_ID, DAGGER_ID, ONEH_SWORD_ID, MISC_ID, WANDS_ID },
		[ARMOR_ID] = { CLOTH_ID, COSMETIC_ID, ARMOR_MISC_ID, ARTIFACT_ID }
	};
	[10] = { --Monk
		[WEAPONS_ID] = { POLEARMS_ID, FIST_ID, STAVES_ID, FISHPOLE_ID, ONEH_SWORD_ID, ONEH_AXES_ID, ONEH_MACE_ID, MISC_ID },
		[ARMOR_ID] = { CLOTH_ID, LEATHER_ID, COSMETIC_ID, ARMOR_MISC_ID, ARTIFACT_ID }
	};
	[11] = { --Druid
		[WEAPONS_ID] = { POLEARMS_ID, FIST_ID, STAVES_ID, FISHPOLE_ID, DAGGER_ID, BEAR_PAWS_ID, TWOH_MACE_ID, ONEH_MACE_ID, MISC_ID },
		[ARMOR_ID] = { CLOTH_ID, LEATHER_ID, COSMETIC_ID, ARMOR_MISC_ID, ARTIFACT_ID }
	};		
	[12] = { --Demon Hunter
		[WEAPONS_ID] = { FIST_ID, FISHPOLE_ID, DAGGER_ID, ONEH_SWORD_ID, WAR_GLAIVES_ID, ONEH_AXES_ID, MISC_ID },
		[ARMOR_ID] = { CLOTH_ID, LEATHER_ID, COSMETIC_ID, ARMOR_MISC_ID, ARTIFACT_ID }
	};	
}

private.CLOTH_CHARACTERES = { 4, 8, 9 }

local DEFAULT_CONTINENT_MAP_ID = 875
local DEFAULT_MAIN_CATEGORY = 0

local general_options

local function GetGeneralOptions()
	local orderedMarkers = {}
	for k, v in pairs(private.MARKERS) do
		orderedMarkers[#orderedMarkers+1] = v
	end
			
	table.sort(orderedMarkers, function(a,b) return string.upper(a) < string.upper(b) end)
	local setMarker = function(value)
		if (value) then
			for k, m in pairs (private.MARKERS) do
				if (k == value) then
					for i, v in ipairs(orderedMarkers) do
						if (m == v) then
							private.db.general.marker = i
						end
					end
				end
			end
		end
	end
	
	local getMarker = function()
		for i, v in ipairs(orderedMarkers) do
			if (i == private.db.general.marker) then
				for k, m in pairs (private.MARKERS) do
					if (m == v) then
						return k
					end
				end
			end
		end
	end	
	
	if not general_options then
		general_options = {
			type = "group",
			order = 1,
			name = _G.GENERAL_LABEL,
			handler = RareScanner,
			desc = AL["GENERAL_OPTIONS"],
			args = {
				scanRares = {
					order = 0,
					name = AL["ENABLE_SCAN_RARES"],
					desc = AL["ENABLE_SCAN_RARES_DESC"],
					type = "toggle",
					get = function() return private.db.general.scanRares end,
					set = function(_, value)
						private.db.general.scanRares = value
					end,
					width = "full",
				},
				scanContainers = {
					order = 1,
					name = AL["ENABLE_SCAN_CONTAINERS"],
					desc = AL["ENABLE_SCAN_CONTAINERS_DESC"],
					type = "toggle",
					get = function() return private.db.general.scanContainers end,
					set = function(_, value)
						private.db.general.scanContainers = value
					end,
					width = "full",
				},
				scanEvents = {
					order = 2,
					name = AL["ENABLE_SCAN_EVENTS"],
					desc = AL["ENABLE_SCAN_EVENTS_DESC"],
					type = "toggle",
					get = function() return private.db.general.scanEvents end,
					set = function(_, value)
						private.db.general.scanEvents = value
					end,
					width = "full",
				},
				scanChatAlerts = {
					order = 3,
					name = AL["ENABLE_SCAN_CHAT"],
					desc = AL["ENABLE_SCAN_CHAT_DESC"],
					type = "toggle",
					get = function() return private.db.general.scanChatAlerts end,
					set = function(_, value)
						private.db.general.scanChatAlerts = value
					end,
					width = "full",
				},
				scanGarrison = {
					order = 4,
					name = AL["ENABLE_SCAN_GARRISON_CHEST"],
					desc = AL["ENABLE_SCAN_GARRISON_CHEST_DESC"],
					type = "toggle",
					get = function() return private.db.general.scanGarrison end,
					set = function(_, value)
						private.db.general.scanGarrison = value
					end,
					width = "full",
				},
				scanInstances = {
					order = 5,
					name = AL["ENABLE_SCAN_IN_INSTANCE"],
					desc = AL["ENABLE_SCAN_IN_INSTANCE_DESC"],
					type = "toggle",
					get = function() return private.db.general.scanInstances end,
					set = function(_, value)
						private.db.general.scanInstances = value
					end,
					width = "full",
				},
				scanOnTaxi = {
					order = 6,
					name = AL["ENABLE_SCAN_ON_TAXI"],
					desc = AL["ENABLE_SCAN_ON_TAXI_DESC"],
					type = "toggle",
					get = function() return private.db.general.scanOnTaxi end,
					set = function(_, value)
						private.db.general.scanOnTaxi = value
					end,
					width = "full",
				},
				showMaker = {
					order = 7,
					name = AL["ENABLE_MARKER"],
					desc = AL["ENABLE_MARKER_DESC"],
					type = "toggle",
					get = function() return private.db.general.showMaker end,
					set = function(_, value)
						private.db.general.showMaker = value
					end,
					width = "full",
				},
				marker = {
					order = 8,
					type = "select",
					dialogControl = 'RS_Markers',
					name = AL["MARKER"],
					desc = AL["MARKER_DESC"],
					values = private.MARKERS,
					get = function() return getMarker() end,
					set = function(_, value)
						setMarker(value)
					end,
					width = "normal",
					disabled = function() return not private.db.general.showMaker end,
				},
				separatorTomtom = {
					order = 9,
					type = "header",
					name = "",
				},
				enableTomtomSupport = {
					order = 10,
					name = AL["ENABLE_TOMTOM_SUPPORT"],
					desc = AL["ENABLE_TOMTOM_SUPPORT_DESC"],
					type = "toggle",
					get = function() return private.db.general.enableTomtomSupport end,
					set = function(_, value)
						private.db.general.enableTomtomSupport = value
					end,
					width = "full",
				},
				separatorMessages = {
					order = 11,
					type = "header",
					name = "",
				},
				sync = {
					order = 12,
					name = AL["SYNCRONIZE"],
					desc = AL["SYNCRONIZE_DESC"],
					type = "execute",
					func = function() RareScanner:MarkCompletedAchievements() end,
					width = "double",
				}
			},
		}
	end
	
	return general_options
end

local sound_options

local function GetSoundOptions()
	if not sound_options then
		sound_options = {
			type = "group",
			order = 2,
			name = AL["SOUND"],
			handler = RareScanner,
			desc = AL["SOUND_OPTIONS"],
			args = {
				soundDisabled = {
					order = 0,
					name = AL["DISABLE_SOUND"],
					desc = AL["DISABLE_SOUND_DESC"],
					type = "toggle",
					get = function() return private.db.sound.soundDisabled end,
					set = function(_, value)
						private.db.sound.soundDisabled = value
					end,
					width = "full",
				},
				soundPlayed = {
					order = 1,
					type = "select",
					dialogControl = 'LSM30_Sound',
					name = AL["ALARM_SOUND"],
					desc = AL["ALARM_SOUND_DESC"],
					values = private.SOUNDS,
					get = function() return private.db.sound.soundPlayed end,
					set = function(_, value)
						private.db.sound.soundPlayed = value
					end,
					width = "double",
					disabled = function() return private.db.sound.soundDisabled end,
				},
				soundObjectPlayed = {
					order = 2,
					type = "select",
					dialogControl = 'LSM30_Sound',
					name = AL["ALARM_TREASURES_SOUND"],
					desc = AL["ALARM_TREASURES_SOUND_DESC"],
					values = private.SOUNDS,
					get = function() return private.db.sound.soundObjectPlayed end,
					set = function(_, value)
						private.db.sound.soundObjectPlayed = value
					end,
					width = "double",
					disabled = function() return private.db.sound.soundDisabled end,
				},
				soundVolume = {
					order = 3,
					type = "range",
					name = AL["SOUND_VOLUME"],
					desc = AL["SOUND_VOLUME_DESC"],
					min	= 1,
					max	= 4,
					step = 1,
					bigStep = 1,
					get = function() return private.db.sound.soundVolume end,
					set = function(_, value)
						private.db.sound.soundVolume = value
					end,
					width = "full",
					disabled = function() return true or private.db.sound.soundDisabled end,
				}
			},
		}
	end
	
	return sound_options
end

local display_options

local function GetDisplayOptions()
	if not display_options then
		display_options = {
			type = "group",
			order = 3,
			name = AL["DISPLAY"],
			handler = RareScanner,
			desc = AL["DISPLAY_OPTIONS"],
			args = {
				separatorMainButton = {
					order = 0,
					type = "header",
					name = AL["MAIN_BUTTON_OPTIONS"],
				},
				displayButton = {
					order = 1,
					type = "toggle",
					name = AL["DISPLAY_BUTTON"],
					desc = AL["DISPLAY_BUTTON_DESC"],
					get = function() return private.db.display.displayButton end,
					set = function(_, value)
						private.db.display.displayButton = value
					end,
					width = "full",
				},
				displayMiniature = {
					order = 2,
					type = "toggle",
					name = AL["DISPLAY_MINIATURE"],
					desc = AL["DISPLAY_MINIATURE_DESC"],
					get = function() return private.db.display.displayMiniature end,
					set = function(_, value)
						private.db.display.displayMiniature = value
					end,
					width = "full",
					disabled = function() return not private.db.display.displayButton end,
				},
				displayButtonContainers = {
					order = 3,
					type = "toggle",
					name = AL["DISPLAY_BUTTON_CONTAINERS"],
					desc = AL["DISPLAY_BUTTON_CONTAINERS_DESC"],
					get = function() return private.db.display.displayButtonContainers end,
					set = function(_, value)
						private.db.display.displayButtonContainers = value
					end,
					width = "full",
					disabled = function() return not private.db.display.displayButton end,
				},
				autoHideButton = {
					order = 4,
					type = "range",
					name = AL["AUTO_HIDE_BUTTON"],
					desc = AL["AUTO_HIDE_BUTTON_DESC"],
					min	= 0,
					max	= 60,
					step	= 5,
					bigStep = 5,
					get = function() return private.db.display.autoHideButton end,
					set = function(_, value)
						private.db.display.autoHideButton = value
					end,
					width = "full",
					disabled = function() return not private.db.display.displayButton end,
				},
				scale = {
					order = 5.1,
					type = "range",
					name = AL["DISPLAY_BUTTON_SCALE"],
					desc = AL["DISPLAY_BUTTON_SCALE_DESC"],
					min	= 0.4,
					max	= 1,
					step = 0.01,
					bigStep = 0.05,
					get = function() return private.db.display.scale end,
					set = function(_, value)
						private.db.display.scale = value
					end,
					width = "double",
					disabled = function() return not private.db.display.displayButton end,	
				},
				test = {
					order = 5.2,
					name = AL["TEST"],
					desc = AL["TEST_DESC"],
					type = "execute",
					func = function() RareScanner:Test() end,
					width = "normal",
				},
				separatorMessages = {
					order = 6,
					type = "header",
					name = AL["MESSAGE_OPTIONS"],
				},
				displayRaidWarning = {
					order = 7,
					type = "toggle",
					name = AL["SHOW_RAID_WARNING"],
					desc = AL["SHOW_RAID_WARNING_DESC"],
					get = function() return private.db.display.displayRaidWarning end,
					set = function(_, value)
						private.db.display.displayRaidWarning = value
					end,
					width = "full",
				},
				displayChatMessage = {
					order = 8,
					type = "toggle",
					name = AL["SHOW_CHAT_ALERT"],
					desc = AL["SHOW_CHAT_ALERT_DESC"],
					get = function() return private.db.display.displayChatMessage end,
					set = function(_, value)
						private.db.display.displayChatMessage = value
					end,
					width = "full",
				},
				separatorNavigation = {
					order = 9,
					type = "header",
					name = AL["NAVIGATION_OPTIONS"],
				},
				enableNavigation = {
					order = 10,
					type = "toggle",
					name = AL["NAVIGATION_ENABLE"],
					desc = AL["NAVIGATION_ENABLE_DESC"],
					get = function() return private.db.display.enableNavigation end,
					set = function(_, value)
						private.db.display.enableNavigation = value
					end,
					width = "full",
				},
				navigationLockEntity = {
					order = 11,
					type = "toggle",
					name = AL["NAVIGATION_LOCK_ENTITY"],
					desc = AL["NAVIGATION_LOCK_ENTITY_DESC"],
					get = function() return private.db.display.navigationLockEntity end,
					set = function(_, value)
						private.db.display.navigationLockEntity = value
					end,
					width = "full",
					disabled = function() return not private.db.display.enableNavigation end,
				},
				separatorLog = {
					order = 12,
					type = "header",
					name = AL["LOG_WINDOW_OPTIONS"],
				},
				displayLogWindow = {
					order = 13,
					type = "toggle",
					name = AL["DISPLAY_LOG_WINDOW"],
					desc = AL["DISPLAY_LOG_WINDOW_DESC"],
					get = function() return private.db.display.displayLogWindow end,
					set = function(_, value)
						private.db.display.displayLogWindow = value
					end,
					width = "full",
				},
				autoHideLogWindow = {
					order = 14,
					type = "range",
					name = AL["LOG_WINDOW_AUTOHIDE"],
					desc = AL["LOG_WINDOW_AUTOHIDE_DESC"],
					min	= 0,
					max	= 60,
					step	= 5,
					bigStep = 5,
					get = function() return private.db.display.autoHideLogWindow end,
					set = function(_, value)
						private.db.display.autoHideLogWindow = value
					end,
					width = "full",
					disabled = function() return not private.db.display.displayLogWindow end,
				},
			},
		}
	end
	
	return display_options
end

local filter_options

local function GetFilterOptions()
	if not filter_options then
		-- load continent combo
		local CONTINENT_MAP_IDS = {} 
		for k, v in pairs(private.CONTINENT_ZONE_IDS) do
			if (v.id) then
				local continentInfo = C_Map.GetMapInfo(k)
				CONTINENT_MAP_IDS[k] = continentInfo.name
			else
				CONTINENT_MAP_IDS[k] = AL["ZONES_CONTINENT_LIST"][k]
			end
		end
	
		local searchNpcByZoneID = function(zoneID, npcName)
			if (zoneID) then
				for k, v in pairs(private.dbglobal.rare_names[GetLocale()]) do 
					if (private.ZONE_IDS[k]) then
						local tempName = v
						if (npcName) then
							if ((private.ZONE_IDS[k].zoneID == zoneID or (type(private.ZONE_IDS[k].zoneID) == "table" and RS_Set(private.ZONE_IDS[k].zoneID)[zoneID])) and RS_tContains(v,npcName)) then
								local i = 2
								while (filter_options.args.rareFilters.values[tempName]) do
									tempName = v..' ('..i..')'
									i = i+1
								end
								filter_options.args.rareFilters.values[tempName] = k
							end
						else
							if (private.ZONE_IDS[k].zoneID == zoneID or (type(private.ZONE_IDS[k].zoneID) == "table" and RS_Set(private.ZONE_IDS[k].zoneID)[zoneID])) then
								local i = 2
								while (filter_options.args.rareFilters.values[tempName]) do
									tempName = v..' ('..i..')'
									i = i+1
								end
								filter_options.args.rareFilters.values[tempName] = k
							end
						end
					else
						--Ignore it, its a rare that we selected but it doesn't have a zone
					end
				end
			end
		end
			
		local searchNpcByContinentID = function(continentID, npcName)
			if (continentID) then
				table.foreach(private.CONTINENT_ZONE_IDS[continentID].zones, function(index, zoneID)							
					-- filter checkboxes
					searchNpcByZoneID(zoneID, npcName)
				end)
			end
		end
		
		local loadSubmapsCombo = function(continentID)
			if (continentID) then
				filter_options.args.subzones.values = {}
				private.filter_options_subzones = nil
				table.foreach(private.CONTINENT_ZONE_IDS[continentID].zones, function(index, zoneID)	
					local continentInfo = C_Map.GetMapInfo(zoneID)
					if (continentInfo) then
						filter_options.args.subzones.values[zoneID] = continentInfo.name
					end
				end)
			end
		end
			
		filter_options = {
			type = "group",
			order = 1,
			name = AL["FILTER"],
			handler = RareScanner,
			desc = AL["FILTER"],
			args = {
				filterOnlyMap = {
					order = 1,
					type = "toggle",
					name = AL["FILTER_NPCS_ONLY_MAP"],
					desc = AL["FILTER_NPCS_ONLY_MAP_DESC"],
					get = function() return private.db.rareFilters.filterOnlyMap end,
					set = function(_, value)
						private.db.rareFilters.filterOnlyMap = value
					end,
					width = "full",
				},
				rareFiltersSearch = {
					order = 2,
					type = "input",
					name = AL["FILTERS_SEARCH"],
					desc = AL["FILTERS_SEARCH_DESC"],
					get = function(_, value) return private.filter_options_input end,
					set = function(_, value)
						private.filter_options_input = value
						-- search
						filter_options.args.rareFilters.values = {}
						if (private.filter_options_subzones) then
							searchNpcByZoneID(private.filter_options_subzones, value)
						else
							searchNpcByContinentID(private.filter_options_continents, value)
						end
					end,
					width = "full",
				},
				continents = {
					order = 3.1,
					type = "select",
					name = AL["FILTER_CONTINENT"],
					desc = AL["FILTER_CONTINENT_DESC"],
					values = CONTINENT_MAP_IDS,
					get = function(_, key) 
						-- initialize
						if (not private.filter_options_continents) then
							private.filter_options_continents = DEFAULT_CONTINENT_MAP_ID
							
							-- load submaps combo
							loadSubmapsCombo(private.filter_options_continents)
							
							-- launch first search zone filters
							searchNpcByContinentID(private.filter_options_continents)
						end
						
						return private.filter_options_continents
					end,
					set = function(_, key, value)
						private.filter_options_continents = key
						
						-- load subzones combo
						loadSubmapsCombo(key)
				
						-- search
						filter_options.args.rareFilters.values = {}
						searchNpcByContinentID(key, private.filter_options_input)					
					end,
					width = "normal",
				},
				subzones = {
					order = 3.2,
					type = "select",
					name = AL["FILTER_ZONE"],
					desc = AL["FILTER_ZONE_DESC"],
					values = {},
					get = function(_, key) return private.filter_options_subzones end,
					set = function(_, key, value)
						private.filter_options_subzones = key
						
						-- search
						filter_options.args.rareFilters.values = {}
						searchNpcByZoneID(key, private.filter_options_input)
					end,
					width = "normal",
					disabled = function() return (next(filter_options.args.subzones.values) == nil) end,
				},
				rareFiltersClear = {
					order = 3.3,
					name = AL["CLEAR_FILTERS_SEARCH"],
					desc = AL["CLEAR_FILTERS_SEARCH_DESC"],
					type = "execute",
					func = function() 
						private.filter_options_input = nil
						filter_options.args.subzones.values = {}
						private.filter_options_subzones = nil
						private.filter_options_continents = DEFAULT_CONTINENT_MAP_ID
						-- load subzones combo
						loadSubmapsCombo(DEFAULT_CONTINENT_MAP_ID)
						-- search
						filter_options.args.rareFilters.values = {}
						searchNpcByContinentID(DEFAULT_CONTINENT_MAP_ID)	
					end,
					width = "normal",
				},
				separator = {
					order = 4,
					type = "header",
					name = AL["FILTERS"],
				},
				rareFiltersToogleAll = {
					order = 5,
					name = AL["TOGGLE_FILTERS"],
					desc = AL["TOGGLE_FILTERS_DESC"],
					type = "execute",
					func = function() 
						if (next(filter_options.args.rareFilters.values) ~= nil) then
							if (private.db.rareFilters.filtersToggled) then
								private.db.rareFilters.filtersToggled = false
							else
								private.db.rareFilters.filtersToggled = true
							end
							
							for k, v in pairs(filter_options.args.rareFilters.values) do
								private.db.general.filteredRares[v] = private.db.rareFilters.filtersToggled
							end
						end
					end,
					width = "full",
				},
				rareFilters = {
					order = 6,
					type = "multiselect",
					name = AL["FILTER_RARE_LIST"],
					desc = AL["FILTER_RARE_LIST_DESC"],
					values = {},
					get = function(_, key) return private.db.general.filteredRares[key] end,
					set = function(_, key, value)
						private.db.general.filteredRares[key] = value;
					end,
				}
			},
		}
	end
	
	return filter_options
end

function RS_Set(list)
	local set = {}
	for _, l in ipairs(list) do set[l] = true end
	return set
end

local zones_filter_options

local function GetZonesFilterOptions()
	if not zones_filter_options then
		-- load continent combo
		local CONTINENT_MAP_IDS = {} 
		for k, v in pairs(private.CONTINENT_ZONE_IDS) do
			if (v.zonefilter) then
				if (v.id) then
					local continentInfo = C_Map.GetMapInfo(k)
					CONTINENT_MAP_IDS[k] = continentInfo.name
				else
					CONTINENT_MAP_IDS[k] = AL["ZONES_CONTINENT_LIST"][k]
				end
			end
		end
		
		local searchZoneByContinentID = function(continentID, zoneName)
			if (continentID) then
				table.foreach(private.CONTINENT_ZONE_IDS[continentID].zones, function(index, zoneID)
					local tempName = nil
					if (zoneName) then
						local continentInfo = C_Map.GetMapInfo(zoneID)
						local name = continentInfo.name
						if (string.find(string.upper(name), string.upper(zoneName))) then
							tempName = name
						end
					else
						local continentInfo = C_Map.GetMapInfo(zoneID)
						tempName = continentInfo.name
					end
					
					if (tempName) then
						local i = 2
						while (zones_filter_options.args.zoneFilters.values[tempName]) do
							tempName = tempName..' ('..i..')'
							i = i+1
						end
						
						zones_filter_options.args.zoneFilters.values[tempName] = zoneID
					end
				end)
				if (private.CONTINENT_ZONE_IDS[continentID].extrazones) then
					table.foreach(private.CONTINENT_ZONE_IDS[continentID].extrazones, function(index, zoneID)
						local tempName = nil
						if (zoneName) then
							local continentInfo = C_Map.GetMapInfo(zoneID)
							local name = continentInfo.name
							if (string.find(string.upper(name), string.upper(zoneName))) then
								tempName = name
							end
						else
							local continentInfo = C_Map.GetMapInfo(zoneID)
							tempName = continentInfo.name
						end
					
						if (tempName) then
							local i = 2
							while (zones_filter_options.args.zoneFilters.values[tempName]) do
								tempName = tempName..' ('..i..')'
								i = i+1
							end
							
							zones_filter_options.args.zoneFilters.values[tempName] = zoneID
						end
					end)
				end
			end
		end
		
		zones_filter_options = {
			type = "group",
			order = 1,
			name = AL["ZONES_FILTER"],
			handler = RareScanner,
			desc = AL["ZONES_FILTER"],
			args = {
				filterOnlyMap = {
					order = 1,
					type = "toggle",
					name = AL["FILTER_ZONES_ONLY_MAP"],
					desc = AL["FILTER_ZONES_ONLY_MAP_DESC"],
					get = function() return private.db.zoneFilters.filterOnlyMap end,
					set = function(_, value)
						private.db.zoneFilters.filterOnlyMap = value
					end,
					width = "full",
				},
				zoneFiltersSearch = {
					order = 2,
					type = "input",
					name = AL["FILTERS_SEARCH"],
					desc = AL["ZONES_FILTERS_SEARCH_DESC"],
					get = function(_, value) return private.zones_filter_input end,
					set = function(_, value)
						private.zones_filter_input = value
						-- search
						zones_filter_options.args.zoneFilters.values = {}
						searchZoneByContinentID(private.zones_filter_options_continents, value)
					end,
					width = "full",
				},
				continents = {
					order = 3.1,
					type = "select",
					name = AL["FILTER_CONTINENT"],
					desc = AL["FILTER_CONTINENT_DESC"],
					values = CONTINENT_MAP_IDS,
					get = function(_, key) 
						-- initialize
						if (not private.zones_filter_options_continents) then
							private.zones_filter_options_continents = DEFAULT_CONTINENT_MAP_ID
							
							-- launch first search zone filters
							searchZoneByContinentID(private.zones_filter_options_continents)
						end
						
						return private.zones_filter_options_continents
					end,
					set = function(_, key, value)
						private.zones_filter_options_continents = key
				
						-- search
						zones_filter_options.args.zoneFilters.values = {}
						searchZoneByContinentID(key, private.zones_filter_input)					
					end,
					width = "normal",
				},
				zoneFiltersClear = {
					order = 3.2,
					name = AL["CLEAR_FILTERS_SEARCH"],
					desc = AL["CLEAR_FILTERS_SEARCH_DESC"],
					type = "execute",
					func = function() 
						private.zones_filter_input = nil
						private.zones_filter_options_continents = DEFAULT_CONTINENT_MAP_ID
						-- search
						zones_filter_options.args.zoneFilters.values = {}
						searchZoneByContinentID(DEFAULT_CONTINENT_MAP_ID)
					end,
					width = "normal",
				},
				separator = {
					order = 4,
					type = "header",
					name = AL["ZONES_FILTER"],
				},
				zoneFiltersToogleAll = {
					order = 5,
					name = AL["TOGGLE_FILTERS"],
					desc = AL["TOGGLE_FILTERS_DESC"],
					type = "execute",
					func = function() 
						if (next(zones_filter_options.args.zoneFilters.values) ~= nil) then
							if (private.db.zoneFilters.filtersToggled) then
								private.db.zoneFilters.filtersToggled = false
							else
								private.db.zoneFilters.filtersToggled = true
							end
							
							for k, v in pairs(zones_filter_options.args.zoneFilters.values) do
								private.db.general.filteredZones[v] = private.db.zoneFilters.filtersToggled
							end
						end
					end,
					width = "full",
				},
				zoneFilters = {
					order = 6,
					type = "multiselect",
					name = AL["FILTER_ZONES_LIST"],
					desc = AL["FILTER_ZONES_LIST_DESC"],
					values = {},
					get = function(_, key) return private.db.general.filteredZones[key] end,
					set = function(_, key, value)
						RareScanner:PrintDebugMessage("DEBUG: Cambiando el valor de "..key)
						if (private.SUBZONES_IDS[key]) then
							for i, k in ipairs(private.SUBZONES_IDS[key]) do
								RareScanner:PrintDebugMessage("DEBUG: Cambiando el valor de "..k)
								private.db.general.filteredZones[k] = value;
							end
						end
						private.db.general.filteredZones[key] = value;
					end,
				}
			},
		}
	end
	
	return zones_filter_options
end

local loot_filter_options

local function GetLootFilterOptions()
	local MAIN_CATEGORIES = {}
	for k, v in pairs(private.ITEM_CLASSES) do
		MAIN_CATEGORIES[k] = GetItemClassInfo(k)
	end
	local filter_loot_category
	local toggleAll = true
	
	local loadSubCategory = function(mainClassID)
		if (loot_filter_options) then
			loot_filter_options.args.category_filters.args.lootFilters.values = {}
			for i, subcategoryID in ipairs(private.ITEM_CLASSES[mainClassID]) do
				loot_filter_options.args.category_filters.args.lootFilters.values[GetItemSubClassInfo(mainClassID, subcategoryID)] = subcategoryID
			end
		end
	end
	
	if not loot_filter_options then	
		loot_filter_options = {
			type = "group",
			order = 1,
			name = AL["LOOT_OPTIONS"],
			handler = RareScanner,
			desc = AL["LOOT_OPTIONS"],
			args = {
				displayLoot = {
					order = 1,
					type = "toggle",
					name = AL["DISPLAY_LOOT_PANEL"],
					desc = AL["DISPLAY_LOOT_PANEL_DESC"],
					get = function() return private.db.loot.displayLoot end,
					set = function(_, value)
						private.db.loot.displayLoot = value
					end,
					width = "full",
				},
				displayLootOnMap = {
					order = 2,
					type = "toggle",
					name = AL["DISPLAY_LOOT_ON_MAP"],
					desc = AL["DISPLAY_LOOT_ON_MAP_DESC"],
					get = function() return private.db.loot.displayLootOnMap end,
					set = function(_, value)
						private.db.loot.displayLootOnMap = value
					end,
					width = "full",
				},
				display_options = {
					type = "group",
					order = 3,
					name = AL["LOOT_DISPLAY_OPTIONS"],
					handler = RareScanner,
					desc = AL["LOOT_DISPLAY_OPTIONS_DESC"],
					args = {
						lootTooltipPosition = {
							order = 1,
							type = "select",
							name = AL["LOOT_TOOLTIP_POSITION"],
							desc = AL["LOOT_TOOLTIP_POSITION_DESC"],
							values = private.TOOLTIP_POSITIONS,
							get = function() return private.db.loot.lootTooltipPosition end,
							set = function(_, value)
								private.db.loot.lootTooltipPosition = value
							end,
							width = "double",
							disabled = function() return (not private.db.loot.displayLoot and not private.db.loot.displayLootOnMap) end,
						},
						itemsToShow = {
							order = 2,
							type = "range",
							name = AL["LOOT_MAX_ITEMS"],
							desc = AL["LOOT_MAX_ITEMS_DESC"],
							min	= 1,
							max	= 30,
							step	= 1,
							bigStep = 1,
							get = function() return private.db.loot.numItems end,
							set = function(_, value)
								private.db.loot.numItems = value
							end,
							width = "full",
							disabled = function() return (not private.db.loot.displayLoot and not private.db.loot.displayLootOnMap) end,
						},
						itemsPerRow = {
							order = 3,
							type = "range",
							name = AL["LOOT_ITEMS_PER_ROW"],
							desc = AL["LOOT_ITEMS_PER_ROW_DESC"],
							min	= 1,
							max	= 30,
							step	= 1,
							bigStep = 1,
							get = function() return private.db.loot.numItemsPerRow end,
							set = function(_, value)
								private.db.loot.numItemsPerRow = value
							end,
							width = "full",
							disabled = function() return (not private.db.loot.displayLoot and not private.db.loot.displayLootOnMap) end,
						}
					},
					disabled = function() return (not private.db.loot.displayLoot and not private.db.loot.displayLootOnMap) end,
				},
				category_filters = {
					type = "group",
					order = 4,
					name = AL["LOOT_CATEGORY_FILTERS"],
					handler = RareScanner,
					desc = AL["LOOT_CATEGORY_FILTERS_DESC"],
					args = {
						categories = {
							order = 1,
							type = "select",
							name = AL["LOOT_MAIN_CATEGORY"],
							desc = AL["LOOT_MAIN_CATEGORY"],
							values = MAIN_CATEGORIES,
							get = function(_, key) 
								-- initialize
								if (not filter_loot_category) then
									filter_loot_category = DEFAULT_MAIN_CATEGORY
									
									-- load subcategory combo
									loadSubCategory(filter_loot_category)
								end
								
								return filter_loot_category
							end,
							set = function(_, key, value)
								filter_loot_category = key
								
								-- load subcategory combo
								loadSubCategory(key)					
							end,
							width = "normal",
							disabled = function() return (not private.db.loot.displayLoot and not private.db.loot.displayLootOnMap) end,
						},
						separator = {
							order = 2,
							type = "header",
							name = AL["LOOT_SUBCATEGORY_FILTERS"],
						},
						lootFiltersToogleAll = {
							order = 3,
							name = AL["TOGGLE_FILTERS"],
							desc = AL["TOGGLE_FILTERS_DESC"],
							type = "execute",
							func = function() 
								if (toggleAll) then
									toggleAll = false
								else
									toggleAll = true
								end
							
								for k, v in pairs(loot_filter_options.args.category_filters.args.lootFilters.values) do
									private.db.loot.filteredLootCategories[filter_loot_category][v] = toggleAll
								end
							end,
							width = "full",
							disabled = function() return (not private.db.loot.displayLoot and not private.db.loot.displayLootOnMap) end,
						},
						lootFilters = {
							order = 4,
							type = "multiselect",
							name = AL["LOOT_FILTER_SUBCATEGORY_LIST"],
							desc = AL["LOOT_FILTER_SUBCATEGORY_DESC"],
							values = {},
							get = function(_, key) return private.db.loot.filteredLootCategories[filter_loot_category][key] end,
							set = function(_, key, value)
								RareScanner:PrintDebugMessage("DEBUG: Cambiando el valor de ClassID "..filter_loot_category..", SubClassID "..key)
								private.db.loot.filteredLootCategories[filter_loot_category][key] = value;
							end,
							disabled = function() return (not private.db.loot.displayLoot and not private.db.loot.displayLootOnMap) end,
						}
					},
					disabled = function() return (not private.db.loot.displayLoot and not private.db.loot.displayLootOnMap) end,
				},
				other_filters = {
					type = "group",
					order = 5,
					name = AL["LOOT_OTHER_FILTERS"],
					handler = RareScanner,
					desc = AL["LOOT_OTHER_FILTERS_DESC"],
					args = {
						lootMinQuality = {
							order = 1,
							type = "select",
							name = AL["LOOT_MIN_QUALITY"],
							desc = AL["LOOT_MIN_QUALITY_DESC"],
							values = private.ITEM_QUALITY,
							get = function() return private.db.loot.lootMinQuality end,
							set = function(_, value)
								private.db.loot.lootMinQuality = value
							end,
							width = "double",
							disabled = function() return (not private.db.loot.displayLoot and not private.db.loot.displayLootOnMap) end,
						},
						filterNotEquipableItems = {
							order = 2,
							type = "toggle",
							name = AL["LOOT_FILTER_NOT_EQUIPABLE"],
							desc = AL["LOOT_FILTER_NOT_EQUIPABLE_DESC"],
							get = function() return private.db.loot.filterNotEquipableItems end,
							set = function(_, value)
								private.db.loot.filterNotEquipableItems = value
							end,
							width = "full",
							disabled = function() return (not private.db.loot.displayLoot and not private.db.loot.displayLootOnMap) end,
						},
						showOnlyTransmogItems = {
							order = 3,
							type = "toggle",
							name = AL["LOOT_FILTER_NOT_TRANSMOG"],
							desc = AL["LOOT_FILTER_NOT_TRANSMOG_DESC"],
							get = function() return private.db.loot.showOnlyTransmogItems end,
							set = function(_, value)
								private.db.loot.showOnlyTransmogItems = value
							end,
							width = "full",
							disabled = function() return (not private.db.loot.displayLoot and not private.db.loot.displayLootOnMap) end,
						},
						filterCollectedItems = {
							order = 4,
							type = "toggle",
							name = AL["LOOT_FILTER_COLLECTED"],
							desc = AL["LOOT_FILTER_COLLECTED_DESC"],
							get = function() return private.db.loot.filterCollectedItems end,
							set = function(_, value)
								private.db.loot.filterCollectedItems = value
							end,
							width = "full",
							disabled = function() return (not private.db.loot.displayLoot and not private.db.loot.displayLootOnMap) end,
						},
						filterItemsCompletedQuest = {
							order = 5,
							type = "toggle",
							name = AL["LOOT_FILTER_COMPLETED_QUEST"],
							desc = AL["LOOT_FILTER_COMPLETED_QUEST_DESC"],
							get = function() return private.db.loot.filterItemsCompletedQuest end,
							set = function(_, value)
								private.db.loot.filterItemsCompletedQuest = value
							end,
							width = "full",
							disabled = function() return (not private.db.loot.displayLoot and not private.db.loot.displayLootOnMap) end,
						},
						filterNotMatchingClass = {
							order = 6,
							type = "toggle",
							name = AL["LOOT_FILTER_NOT_MATCHING_CLASS"],
							desc = AL["LOOT_FILTER_NOT_MATCHING_CLASS_DESC"],
							get = function() return private.db.loot.filterNotMatchingClass end,
							set = function(_, value)
								private.db.loot.filterNotMatchingClass = value
							end,
							width = "full",
							disabled = function() return (not private.db.loot.displayLoot and not private.db.loot.displayLootOnMap) end,
						},
					},
					disabled = function() return (not private.db.loot.displayLoot and not private.db.loot.displayLootOnMap) end,
				}
			},
		}
	end
	
	return loot_filter_options
end

local map_options

local function GetMapOptions()
	if not map_options then
		map_options = {
			type = "group",
			order = 1,
			name = AL["MAP_OPTIONS"],
			handler = RareScanner,
			desc = AL["MAP_OPTIONS"],
			args = {
				scale = {
					order = 1,
					type = "range",
					name = AL["MAP_SCALE_ICONS"],
					desc = AL["MAP_SCALE_ICONS_DESC"],
					min	= 0.3,
					max	= 1.4,
					step = 0.01,
					bigStep = 0.05,
					get = function() return private.db.map.scale end,
					set = function(_, value)
						private.db.map.scale = value
					end,
					width = "full",
					disabled = function() return (not private.db.map.displayNpcIcons and not private.db.map.displayContainerIcons and not private.db.map.displayEventIcons) end,	
				},
				displayNpcIcons = {
					order = 2,
					type = "toggle",
					name = AL["DISPLAY_NPC_ICONS"],
					desc = AL["DISPLAY_NPC_ICONS_DESC"],
					get = function() return private.db.map.displayNpcIcons end,
					set = function(_, value)
						private.db.map.displayNpcIcons = value
					end,
					width = "full",
				},
				displayContainerIcons = {
					order = 3,
					type = "toggle",
					name = AL["DISPLAY_CONTAINER_ICONS"],
					desc = AL["DISPLAY_CONTAINER_ICONS_DESC"],
					get = function() return private.db.map.displayContainerIcons end,
					set = function(_, value)
						private.db.map.displayContainerIcons = value
					end,
					width = "full",
				},
				displayEventIcons = {
					order = 4,
					type = "toggle",
					name = AL["DISPLAY_EVENT_ICONS"],
					desc = AL["DISPLAY_EVENT_ICONS_DESC"],
					get = function() return private.db.map.displayEventIcons end,
					set = function(_, value)
						private.db.map.displayEventIcons = value
					end,
					width = "full",
				},
				separatorMainButton = {
					order = 5,
					type = "header",
					name = AL["MAP_OPTIONS"],
				},
				displayNotDiscoveredMapIcons = {
					order = 6,
					type = "toggle",
					name = AL["DISPLAY_MAP_NOT_DISCOVERED_ICONS"],
					desc = AL["DISPLAY_MAP_NOT_DISCOVERED_ICONS_DESC"],
					get = function() return private.db.map.displayNotDiscoveredMapIcons end,
					set = function(_, value)
						private.db.map.displayNotDiscoveredMapIcons = value
					end,
					width = "full",
					disabled = function() return (not private.db.map.displayNpcIcons and not private.db.map.displayContainerIcons and not private.db.map.displayEventIcons) end,
				},
				displayOldNotDiscoveredMapIcons = {
					order = 7,
					type = "toggle",
					name = AL["DISPLAY_MAP_OLD_NOT_DISCOVERED_ICONS"],
					desc = AL["DISPLAY_MAP_OLD_NOT_DISCOVERED_ICONS_DESC"],
					get = function() return private.db.map.displayOldNotDiscoveredMapIcons end,
					set = function(_, value)
						private.db.map.displayOldNotDiscoveredMapIcons = value
					end,
					width = "full",
					disabled = function() return ((not private.db.map.displayNpcIcons and not private.db.map.displayContainerIcons and not private.db.map.displayEventIcons) or not private.db.map.displayNotDiscoveredMapIcons) end,
				},
				keepShowingAfterDead = {
					order = 8,
					type = "toggle",
					name = AL["MAP_SHOW_ICON_AFTER_DEAD"],
					desc = AL["MAP_SHOW_ICON_AFTER_DEAD_DESC"],
					get = function() return private.db.map.keepShowingAfterDead end,
					set = function(_, value)
						private.db.map.keepShowingAfterDead = value
						private.db.map.keepShowingAfterDeadReseteable = false
					end,
					width = "full",
					disabled = function() return (not private.db.map.displayNpcIcons and not private.db.map.displayContainerIcons and not private.db.map.displayEventIcons) end,
				},
				keepShowingAfterDeadReseteable = {
					order = 9,
					type = "toggle",
					name = AL["MAP_SHOW_ICON_AFTER_DEAD_RESETEABLE"],
					desc = AL["MAP_SHOW_ICON_AFTER_DEAD_RESETEABLE_DESC"],
					get = function() return private.db.map.keepShowingAfterDeadReseteable end,
					set = function(_, value)
						private.db.map.keepShowingAfterDeadReseteable = value
					end,
					width = "full",
					disabled = function() return (not private.db.map.displayNpcIcons and not private.db.map.displayContainerIcons and not private.db.map.displayEventIcons) or private.db.map.keepShowingAfterDead end,
				},
				keepShowingAfterCollected = {
					order = 10,
					type = "toggle",
					name = AL["MAP_SHOW_ICON_AFTER_COLLECTED"],
					desc = AL["MAP_SHOW_ICON_AFTER_COLLECTED_DESC"],
					get = function() return private.db.map.keepShowingAfterCollected end,
					set = function(_, value)
						private.db.map.keepShowingAfterCollected = value
					end,
					width = "full",
					disabled = function() return (not private.db.map.displayNpcIcons and not private.db.map.displayContainerIcons and not private.db.map.displayEventIcons) end,
				},
				keepShowingAfterCompleted = {
					order = 11,
					type = "toggle",
					name = AL["MAP_SHOW_ICON_AFTER_COMPLETED"],
					desc = AL["MAP_SHOW_ICON_AFTER_COMPLETED_DESC"],
					get = function() return private.db.map.keepShowingAfterCompleted end,
					set = function(_, value)
						private.db.map.keepShowingAfterCompleted = value
					end,
					width = "full",
					disabled = function() return (not private.db.map.displayNpcIcons and not private.db.map.displayContainerIcons and not private.db.map.displayEventIcons) end,
				},
				maxSeenTime = {
					order = 12,
					type = "range",
					name = AL["MAP_SHOW_ICON_MAX_SEEN_TIME"],
					desc = AL["MAP_SHOW_ICON_MAX_SEEN_TIME_DESC"],
					min	= 0,
					max	= 24,
					step = 1,
					bigStep = 1,
					get = function() return private.db.map.maxSeenTime end,
					set = function(_, value)
						private.db.map.maxSeenTime = value
						private.db.map.maxSeenTimeBak = value
					end,
					width = "full",
					disabled = function() return ((not private.db.map.displayNpcIcons and not private.db.map.displayContainerIcons and not private.db.map.displayEventIcons) or private.db.map.disableLastSeenFilter) end,	
				},
				maxSeenTimeContainer = {
					order = 13,
					type = "range",
					name = AL["MAP_SHOW_ICON_CONTAINER_MAX_SEEN_TIME"],
					desc = AL["MAP_SHOW_ICON_CONTAINER_MAX_SEEN_TIME_DESC"],
					min	= 0,
					max	= 15,
					step = 1,
					bigStep = 1,
					get = function() return private.db.map.maxSeenTimeContainer end,
					set = function(_, value)
						private.db.map.maxSeenTimeContainer = value
					end,
					width = "full",
					disabled = function() return (not private.db.map.displayNpcIcons and not private.db.map.displayContainerIcons and not private.db.map.displayEventIcons) end,	
				},
				maxSeenTimeEvent = {
					order = 14,
					type = "range",
					name = AL["MAP_SHOW_ICON_EVENT_MAX_SEEN_TIME"],
					desc = AL["MAP_SHOW_ICON_EVENT_MAX_SEEN_TIME_DESC"],
					min	= 0,
					max	= 15,
					step = 1,
					bigStep = 1,
					get = function() return private.db.map.maxSeenTimeEvent end,
					set = function(_, value)
						private.db.map.maxSeenTimeEvent = value
					end,
					width = "full",
					disabled = function() return (not private.db.map.displayNpcIcons and not private.db.map.displayContainerIcons and not private.db.map.displayEventIcons) end,	
				},
			},
		}
	end
	
	return map_options
end

function RareScanner:RefreshOptions(event, database, newProfileKey)
	private.db = database.profile
end

function RareScanner:SetupOptions()
	local RSAC = LibStub("AceConfig-3.0")
	RSAC:RegisterOptionsTable("RareScanner General", GetGeneralOptions)
	RSAC:RegisterOptionsTable("RareScanner Sound", GetSoundOptions)
	RSAC:RegisterOptionsTable("RareScanner Display", GetDisplayOptions)
	RSAC:RegisterOptionsTable("RareScanner Filter", GetFilterOptions)
	RSAC:RegisterOptionsTable("RareScanner Zone Filter", GetZonesFilterOptions)
	RSAC:RegisterOptionsTable("RareScanner Loot Options", GetLootFilterOptions)
	RSAC:RegisterOptionsTable("RareScanner Map", GetMapOptions)
	RSAC:RegisterOptionsTable("RareScanner Profiles", RareScanner:GetOptionsTable())

	local RSACD = LibStub("AceConfigDialog-3.0-RSmod")
	RSACD:AddToBlizOptions("RareScanner General", _G.GENERAL_LABEL, "RareScanner")
	RSACD:AddToBlizOptions("RareScanner Sound", AL["SOUND"], "RareScanner")
	RSACD:AddToBlizOptions("RareScanner Display", AL["DISPLAY"], "RareScanner")
	RSACD:AddToBlizOptions("RareScanner Filter", AL["FILTER"], "RareScanner")
	RSACD:AddToBlizOptions("RareScanner Zone Filter", AL["ZONES_FILTER"], "RareScanner")
	RSACD:AddToBlizOptions("RareScanner Loot Options", AL["LOOT_OPTIONS"], "RareScanner")
	RSACD:AddToBlizOptions("RareScanner Map", AL["MAP_OPTIONS"], "RareScanner")
	RSACD:AddToBlizOptions("RareScanner Profiles", AL["PROFILES"], "RareScanner")
end
