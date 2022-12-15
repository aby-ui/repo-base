-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

local RSConstants = private.NewLib("RareScannerConstants")

---============================================================================
-- DEBUG MODE
---============================================================================

RSConstants.DEBUG_MODE = false

-- Use this constant to logger information about an specific entity while
-- displaying on the map. This is handy to find bugs in the POI filters
RSConstants.MAP_ENTITY_ID = nil

-- Use this constant to logger information about an specific item whie
-- displaying on the loot bar under the main button or the map. This is handy to find bugs
-- with the loot filters
RSConstants.LOOT_ITEM_ID = nil

---============================================================================
-- Current versions
---============================================================================

RSConstants.CURRENT_DB_VERSION = 76
RSConstants.CURRENT_LOOT_DB_VERSION = 86

---============================================================================
-- Current maps (newer)
---============================================================================

RSConstants.CURRENT_MAP_ID = 1978 --Dragon Isles
RSConstants.CURRENT_SUBMAP_ID = 2022 --The Waking Shores

---============================================================================
-- Default filtered entities by version
---============================================================================

RSConstants.DEFAULT_FILTERED_ENTITIES = {
	version = 67,
	containers = {382029, 383733, 383734, 383735, 376386, 376587}
}

---============================================================================
-- Special events
---============================================================================

RSConstants.SHADOWLANDS_PRE_PATCH_EVENT = 1

RSConstants.EVENTS = {
	[RSConstants.SHADOWLANDS_PRE_PATCH_EVENT] = false
}

---============================================================================
-- Timers
---============================================================================

RSConstants.CHECK_RESET_RECENTLY_SEEN_TMER = 5 --5 seconds
RSConstants.RECENTLY_SEEN_RESET_TIMER = 120 --2 minutes
RSConstants.CACHE_ALL_COMPLETED_QUEST_IDS_TIMER = 60 --1 minute
RSConstants.FIND_HIDDEN_QUESTS_TIMER = 5 --5 seconds after killing a NPC or opening a container
RSConstants.CHECK_RESPAWN_BY_QUEST_TIMER = 150 --2.5 minutes
RSConstants.CHECK_RESPAWNING_BY_LASTSEEN_TIMER = 60 --1 minute
RSConstants.CHECK_RESET_NOTIFICATIONS_TIMER = 10 --10 seconds

---============================================================================
-- Collections enumerators
---============================================================================

RSConstants.ITEM_SOURCE = {
	NPC = 1,
	CONTAINER = 2
}

RSConstants.ITEM_TYPE = {
	APPEARANCE = 1,
	TOY = 2,
	PET = 3,
	MOUNT = 4,
	ANYTHING = 0
}

---============================================================================
-- Addons default settings
---============================================================================

RSConstants.PROFILE_DEFAULTS = {
	profile = {
		general = {
			scanRares = true,
			scanContainers = true,
			scanEvents = true,
			scanChatAlerts = true,
			scanGarrison = false,
			scanInstances = false,
			scanOnTaxi = true,
			scanOnPetBattle = true,
			scanWorldmapVignette = false,
			ignoreCompletedEntities = true,
			filteredRares = {},
			filteredContainers = {},
			filteredEvents = {},
			filteredZones = {},
			enableTomtomSupport = false,
			autoTomtomWaypoints = false,
			enableWaypointsSupport = false,
			autoWaypoints = false,
			showMaker = true,
			marker = 8,
			rescanTimer = 5
		},
		sound = {
			soundDisabled = false,
			soundPlayed = "Horn",
			soundObjectDisabled = false,
			soundObjectPlayed = "PVP Horde",
			soundVolume = 4,
			soundChannel = "Master",
			soundCustomFolder = "RareScannerSounds"
		},
		display = {
			displayButton = true,
			displayMiniature = true,
			displayButtonContainers = true,
			scale = 0.8,
			autoHideButton = 0,
			displayRaidWarning = true,
			displayChatMessage = true,
			enableNavigation = true,
			navigationLockEntity = false,
			lockPosition = false,
			minimapButton = {
				hide = false
			},
			worldmapButton = true
		},
		rareFilters = {
			filtersToggled = true,
			filterOnlyMap = false
		},
		containerFilters = {
			filtersToggled = true,
			filterOnlyMap = false,
			filterOnlyAlerts = true,
		},
		eventFilters = {
			filtersToggled = true,
			filterOnlyMap = false
		},
		zoneFilters = {
			filtersToggled = true,
			filterOnlyMap = false
		},
		collections = {
			filteredOnlyOnWorldMap = false,
			autoFilteringOnCollect = false,
			createProfileBackup = true,
			searchingPets = true,
			searchingMounts = true,
			searchingToys = true,
			searchingAppearances = true,
			showFiltered = true,
			showDead = true,
			showWithoutCollectibles = false
		},
		map = {
			displayNpcIcons = false,
			displayContainerIcons = false,
			displayEventIcons = true,
			disableLastSeenFilter = false,
			displayFriendlyNpcIcons = false,
			displayNotDiscoveredMapIcons = true,
			displayOldNotDiscoveredMapIcons = true,
			displayDragonGlyphsIcons = true,
			keepShowingAfterDead = false,
			keepShowingAfterDeadReseteable = false,
			keepShowingAfterCollected = false,
			keepShowingAfterCompleted = false,
			maxSeenTime = 0,
			maxSeenTimeContainer = 0,
			maxSeenTimeEvent = 5,
			scale = 0.8,
			minimapscale = 0.7,
			showingWorldMapSearcher = true,
			cleanWorldMapSearcherOnChange = true,
			displayMinimapIcons = true,
			waypointTomtom = false,
			waypointIngame = true,
			tooltipsScale = 1.0,
			tooltipsOnIngameIcons = true,
			tooltipsAchievements = true,
			tooltipsNotes = true,
			tooltipsState = true,
			tooltipsSeen = true,
			tooltipsCommands = true,
			lootAchievTooltipsScale = 0.7,
			lootAchievementsPosition = "ANCHOR_LEFT",
			overlayMaxColours = 10,
			overlayColour1 = { 1, 0.2, 1 },
			overlayColour2 = { 0.23, 0.943, 1 },
			overlayColour3 = { 0.98, 0.99, 0.19 },
			overlayColour4 = { 0, 0.12, 1 },
			overlayColour5 = { 0.317, 1, 0.1 },
			overlayColour6 = { 1, 0.35, 0.11 },
			overlayColour7 = { 0.08, 0.55, 1 },
			overlayColour8 = { 0.18, 1, 0.42 },
			overlayColour9 = { 1, 0.04, 0.4 },
			overlayColour10 = { 0.4, 0.007, 1 },
		},
		loot = {
			filteredLootCategories = {},
			filteredItems = {},
			displayLoot = true,
			displayLootOnMap = true,
			lootTooltipPosition = "ANCHOR_LEFT",
			lootMinQuality = 0,
			filterItemsCompletedQuest = true,
			filterNotMatchingClass = false,
			filterNotMatchingFaction = true,
			filterAnimaItems = true,
			filterConduitItems = true,
			filterByExplorerResults = false,
			showingMissingMounts = true,
			showingMissingPets = true,
			showingMissingToys = true,
			showingMissingAppearances = true,
			numItems = 10,
			numItemsPerRow = 10,
			tooltipsCommands = true,
			tooltipsCanImogit = false,
			covenantRequirement = true
		}
	}
}

---============================================================================
-- Sounds
---============================================================================

RSConstants.DEFAULT_SOUNDS_ABY = {
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

RSConstants.DEFAULT_SOUNDS = {
	["Achievement Sound"] = "Interface\\AddOns\\RareScanner\\Media\\achievmentsound1-4.ogg",
	["Alarm Clock"] = "Interface\\AddOns\\RareScanner\\Media\\alarmclockwarning2-4.ogg",
	["Boat Docking"] = "Interface\\AddOns\\RareScanner\\Media\\boatdockedwarning-4.ogg",
	["Siege Engineer Weapon"] = "Interface\\AddOns\\RareScanner\\Media\\fx_ograid_siege_weaponmachine_warning-4.ogg",
	["PVP Alliance"] = "Interface\\AddOns\\RareScanner\\Media\\pvpwarningalliance-4.ogg",
	["PVP Horde"] = "Interface\\AddOns\\RareScanner\\Media\\pvpwarninghorde-4.ogg",
	["Ready Check"] = "Interface\\AddOns\\RareScanner\\Media\\readycheck-4.ogg",
	["Horn"] = "Interface\\AddOns\\RareScanner\\Media\\gruntling_horn_bb-4.ogg",
	["Event Wardrum Ogre"] = "Interface\\AddOns\\RareScanner\\Media\\Event_wardrum_ogre-4.ogg",
	["Level Up"] = "Interface\\AddOns\\RareScanner\\Media\\levelup2-4.ogg",
}

RSConstants.EXTERNAL_SOUND_FOLDER = "Interface\\AddOns\\%s\\%s"

---============================================================================
-- CMD commands
---============================================================================

RSConstants.CMD_HELP = "help"
RSConstants.CMD_TOGGLE_MAP_ICONS = "tmi"
RSConstants.CMD_TOGGLE_ALERTS = "ta"
RSConstants.CMD_TOGGLE_RARES = "tr"
RSConstants.CMD_TOGGLE_RARES_ALERTS = "tra"
RSConstants.CMD_TOGGLE_EVENTS = "te"
RSConstants.CMD_TOGGLE_EVENTS_ALERTS = "tea"
RSConstants.CMD_TOGGLE_TREASURES = "tt"
RSConstants.CMD_TOGGLE_TREASURES_ALERTS = "tta"
RSConstants.CMD_TOGGLE_SCANNING_WORLD_MAP_VIGNETTES = "swmv"
RSConstants.CMD_TOMTOM_WAYPOINT = "waypoint"
RSConstants.CMD_TOGGLE_DRAGON_GLYPHS = "tdg"
RSConstants.CMD_OPEN_EXPLORER = "explorer"

---============================================================================
-- AtlasNames
---============================================================================

RSConstants.NPC_VIGNETTE = "VignetteKill"
RSConstants.NPC_VIGNETTE_ELITE = "VignetteKillElite"
RSConstants.NPC_LEGION_VIGNETTE = "DemonInvasion5"
RSConstants.NPC_NAZJATAR_VIGNETTE = "nazjatar-nagaevent"
RSConstants.NPC_WARFRONT_NEUTRAL_HERO_VIGNETTE = "Warfront-NeutralHero"
RSConstants.NPC_TORMENTORS_VIGNETTE = "Tormentors-Boss"

RSConstants.CONTAINER_VIGNETTE = "VignetteLoot"
RSConstants.CONTAINER_ELITE_VIGNETTE = "VignetteLootElite"

RSConstants.EVENT_VIGNETTE = "VignetteEvent"
RSConstants.EVENT_ELITE_VIGNETTE = "VignetteEventElite"
RSConstants.EVENT_TORMENTORS_VIGNETTE = "Tormentors-Event"

---============================================================================
-- MapIDS
---============================================================================

RSConstants.ALL_ZONES_CUSTOM_NPC = 0
RSConstants.ALL_ZONES = "all"
RSConstants.UNKNOWN_ZONE_ID = 0
RSConstants.TANAAN_JUNGLE_MAPID = 534
RSConstants.MECHAGON_MAPID = 1462
RSConstants.VALLEY_OF_ETERNAL_BLOSSOMS_MAPID = 1530
RSConstants.ULDUM_MAPID = 1527
RSConstants.THE_MAW_MAPID = 1543
RSConstants.ZERETH_MORTIS_MAPID = 1970
RSConstants.DRAGON_ISLES = 1978

---============================================================================
-- NpcIDS
---============================================================================

RSConstants.CATACOMBS_CACHE = 358040
RSConstants.DOOMROLLER_ID = 95056
RSConstants.DEATHTALON = 95053
RSConstants.TERRORFIST = 95044
RSConstants.VENGEANCE = 95054
RSConstants.WINGFLAYER_CRUEL = 167078
RSConstants.GIEGER = 162741
RSConstants.FORGEMASTER_MADALAV = 159496
RSConstants.HARIKA_HORRID = 165290
RSConstants.VALFIR_UNRELENTING = 168647
RSConstants.ORATOR_KLOE_NPCS = { 161527, 161528, 161529, 161530 }
RSConstants.CRAFTING_NPCS = { 157294, 157308, 157307, 157312, 157309, 157310, 157311 }
RSConstants.DAFFODIL_NPCS = { 171690, 167724 }
RSConstants.ABUSE_POWER_GI_NPCS = { 159156, 159157 }
RSConstants.ABUSE_POWER_I_NPCS = { 159151, 156919, 156916, 156918 }
RSConstants.ABUSE_POWER_HI_NPCS = { 159153, 159152, 159155, 159154 }
RSConstants.RUNE_CONSTRUCTS_CONTAINERS = { 355036, 355037, 355038, 364531 }
RSConstants.GRAPPLING_GROWTH_CONTAINERS = { 352596, 354852, 354853 }
RSConstants.GREEDSTONE_CONTAINERS = { 354211, 354206 }
RSConstants.LUNARLIGHT_CONTAINERS = { 353771, 353770, 353772, 353773, 353769 }
RSConstants.CITADEL_LOYALTY_NPCS = { 156339, 156340 }
RSConstants.SWELLING_TEAR_NPCS = { 171040, 171013, 171041 }
RSConstants.VESPER_REPAIR_NPCS = { 160882, 160985 }
RSConstants.THEATER_PAIN_NPCS = { 168147, 168148 }
RSConstants.DAPPERDEW_NPCS = { 168135, 164415, 166135, 166138, 166139, 166140, 166142, 166145, 166146 }
RSConstants.ASCENDED_COUNCIL_NPCS = { 170832, 170833, 170834, 170835, 170836 }
RSConstants.FOUR_PEOPLE_NPCS = { 170301, 169827, 170301, 170302 }
RSConstants.STORM_EVENTS_NPCS = { 193648, 193644, 193686, 193680, 193652, 193675, 193678, 193653, 193650, 193645, 193647, 193682, 193684, 193674, 193677, 193679, 193654, 193655 }
RSConstants.BOUNDING_SHRROM_CONTAINERS = { 349793, 349797, 353330 }
RSConstants.RIPE_PURIAN_CONTAINERS = { 353643, 353503, 353205, 353500, 352754, 353516, 353325, 353019, 353252, 353314, 352998 }
RSConstants.RIFT_HIDDEN_ENTITIES = { 179883, 368645, 368646, 368647, 368648, 368649, 368650 }
RSConstants.RIFT_NPCS = { 179608, 179911, 179913, 179914, 369437, 369438, 369439, 369440 }
RSConstants.RIFT_NPCS_MAW = { 179735, 179853, 179851 }
RSConstants.RELIC_CACHE = { 369292, 369294, 369310 }
RSConstants.PILE_BONES = { 369297, 369295 }
RSConstants.SHARDHIDE_STASH = { 369296 }
RSConstants.CACHES_SWAGSNOUT_GROMIT = { 369292, 369294, 369310, 369297, 369295, 369296 }
RSConstants.STOLEN_ANIMA_VESSEL = { 368946, 368947, 368948, 368949, 368950, 368951, 368952, 368953 }
RSConstants.STOLEN_ANIMA_VESSEL_RIFT = { 369227, 369235, 369236 }
RSConstants.DISTURBED_DIRT = { 382029, 376386, 383733, 383734, 383735 }
RSConstants.HUNTING_PARTY_NPCS = { 195093, 194760, 194251, 191103, 194409, 194601, 191450, 194438, 194458, 195417, 195101, 195283, 195300, 195430, 195132 }
RSConstants.OMINOUS_CONCHS_NPCS = { 193735, 193634, 193710, 197371, 193708, 193706 } --197411
RSConstants.CONTAINERS_WITHOUT_VIGNETTE = { 376582, 376583, 376585, 376579, 376584, 377587, 378010 }
RSConstants.MAGIC_BOUND_CHEST = { 376426, 385075, 385074 }

-- NPCs that spawn after completing an event
RSConstants.NPCS_WITH_PRE_EVENT = {
-- EVENTID = NPCID
	-- Korthia
	[179759] = 179760;
	[180145] = 179859;
	[369247] = 179859;
	[180144] = 179802;
	[369130] = 179802;
	[179464] = 179472;
	[369444] = 180162;
	[180064] = 180042;
	[179969] = 179985;
	[180028] = 180032;
	[180013] = 180014;
	-- Zereth Mortis
	[183505] = 183516;
	[183781] = 183764;
	[182156] = 182155;
	[185612] = 181249;
	[182120] = 182114;
	[182161] = 182158;
	[182156] = 182155;
	[185836] = 180924;
	-- Bation
	[176543] = 171008;
	[171012] = 171040;
	[356756] = 167078;
	-- Revendredth
	[165230] = 165206;
	[166483] = 166521;
	[176347] = 160675;
	-- Ardenweald
	[164102] = 164093;
	[167874] = 167851;
	[168053] = 167721;
	-- Talador
	[84037] = 88494; 
	[77764] = 77750;
	-- Tanaan Jungle
	[90524] = 90519; 
	[243386] = 91227;
	-- Shadowlands (Draenor)
	[82426] = 75434; 
	-- Spires of Arak
	[82084] = 82050;
	[84918] = 84912;
	[84821] = 84833;
	[85758] = 85037;
	-- Nagrand (Draenor)
	[84275] = 84263;
	-- Frostfire Ridge
	[75235] = 72156;
	[74970] = 74971;
	-- Timeless Isle
	[71944] = 71919;
	[55421] = 72048;
	[220815] = 71864;
	-- The Maw
	[170315] = 170302;
	[169828] = 169827;
	[170305] = 170301;
	-- The Azure Span
	[379234] = 194270;
	-- Ohn'ahran Plains
	[193166] = 187559;
	-- The Azure Span
	[192747] = 192749;
	[190971] = 189822;
}

-- Contains that spawn after completing an event
RSConstants.CONTAINERS_WITH_PRE_EVENT = {
-- EVENTID = CONTAINERID
	-- Ardenweald
	[171475] = 354662;
	-- Zereth Mortis
	[185265] = 375403;
	[185502] = 375403;
	[185285] = 375413;
	[180507] = 369757;
	[185416] = 375493;
	-- Talador
	[77664] = 227793;
	-- Shadowlands (Draenor)
	[79805] = 230664;
	-- Frostfire Ridge
	[229366] = 229367;
}

-- NPCs that spawn after killing another NPC
RSConstants.NPCS_WITH_PRE_NPCS = {
	[165175] = 165152;
	[165206] = 165230;
	[166521] = 166483;
	[160675] = 176347;
}
	
-- 156480 Next door entity inside Torghast
-- 155660 Summons from the Depths
RSConstants.IGNORED_VIGNETTES = { 156480, 155660, 163373, 370467, 370466, 182160, 182668, 182667, 185261, 376210, 200002, 190034 }
RSConstants.NPCS_WITH_EVENT_VIGNETTE = { 72156, 154154, 154330, 164547, 164477, 160629, 175012, 157833, 166398, 164064, 162829, 157964, 162844, 171317, 170774, 162849, 170301, 170302, 170711, 170634, 170731, 172862, 172577, 158025, 158278, 170303, 179684, 179791, 179805, 177444, 180246, 179108, 179853, 179755, 179768, 179779, 179460, 179851, 179735, 169827 }
RSConstants.NPCS_WITH_CONTAINER_VIGNETTE = { 179883 }
RSConstants.CONTAINERS_WITH_NPC_VIGNETTE = { 369435 }
RSConstants.NPCS_WITH_MULTIPLE_SPAWNS = { 69768, 69769, 69841, 69842, 70323 }
RSConstants.CONTAINERS_WITH_MULTIPLE_SPAWNS = { 375366, 375530, 375362, 375363, 375373, 375290, 376587, 382029, 376386, 383733, 383734, 383735 }
RSConstants.FIRIM_EXILE_OBJECTS = { 375973, 375982, 375983, 375984, 375985, 375986, 375987 }

---============================================================================
-- ItemIDs
---============================================================================

RSConstants.ITEMS_REQUIRE_NECROLORD = { 181815, 182080, 186489 }
RSConstants.ITEMS_REQUIRE_NIGHT_FAE = { 180730, 186492 }
RSConstants.ITEMS_REQUIRE_VENTHYR = { 180581, 180461, 186479 }
RSConstants.ITEMS_REQUIRE_KYRIAN = { 186483 }

---============================================================================
-- Achievements
---============================================================================

RSConstants.TALES_OF_EXILE_ACHIEVEMENT_ID = 15509;

---============================================================================
-- Garrison cache
---============================================================================

RSConstants.GARRISON_CACHE_IDS = { 236916, 237191, 237724, 237722, 237723, 237720 }

---============================================================================
-- Eternal states
---============================================================================

RSConstants.ETERNAL_DEATH = -1
RSConstants.ETERNAL_OPENED = -1
RSConstants.ETERNAL_COMPLETED = -1
RSConstants.ETERNAL_COLLECTED = -1

---============================================================================
-- Textures
---============================================================================

RSConstants.TEXTURE_PATH = "Interface\\AddOns\\RareScanner\\Media\\Icons\\%s.blp"
RSConstants.GROUP_TOP_TEXTURE_FILE = "GroupT"
RSConstants.GROUP_RIGHT_TEXTURE_FILE = "GroupR"
RSConstants.GROUP_LEFT_TEXTURE_FILE = "GroupL"
RSConstants.NORMAL_NPC_TEXTURE_FILE = "OriginalSkull"
RSConstants.GREEN_NPC_TEXTURE_FILE = "GreenSkullDark"
RSConstants.YELLOW_NPC_TEXTURE_FILE = "YellowSkullDark"
RSConstants.RED_NPC_TEXTURE_FILE = "RedSkullDark"
RSConstants.PINK_NPC_TEXTURE_FILE = "PinkSkullDark"
RSConstants.BLUE_NPC_TEXTURE_FILE = "BlueSkullDark"
RSConstants.LIGHT_BLUE_NPC_TEXTURE_FILE = "BlueSkullLight"
RSConstants.NORMAL_CONTAINER_TEXTURE_FILE = "OriginalChest"
RSConstants.GREEN_CONTAINER_TEXTURE_FILE = "GreenChest"
RSConstants.YELLOW_CONTAINER_TEXTURE_FILE = "YellowChest"
RSConstants.RED_CONTAINER_TEXTURE_FILE = "RedChest"
RSConstants.PINK_CONTAINER_TEXTURE_FILE = "PinkChest"
RSConstants.BLUE_CONTAINER_TEXTURE_FILE = "BlueChest"
RSConstants.NORMAL_EVENT_TEXTURE_FILE = "OriginalStar"
RSConstants.GREEN_EVENT_TEXTURE_FILE = "GreenStar"
RSConstants.YELLOW_EVENT_TEXTURE_FILE = "YellowStar"
RSConstants.RED_EVENT_TEXTURE_FILE = "RedStar"
RSConstants.PINK_EVENT_TEXTURE_FILE = "PinkStar"
RSConstants.BLUE_EVENT_TEXTURE_FILE = "BlueStar"
RSConstants.OVERLAY_SPOT_TEXTURE_FILE = "Overlay"
RSConstants.GUIDE_TRANSPORT_FILE = "Transport"
RSConstants.GUIDE_ENTRANCE_FILE = "Entrance"
RSConstants.GUIDE_FLAG_FILE = "Flag"
RSConstants.GUIDE_DOT_FILE = "Dot"
RSConstants.GUIDE_STEP1_FILE = "Number1"
RSConstants.GUIDE_STEP2_FILE = "Number2"
RSConstants.GUIDE_STEP3_FILE = "Number3"
RSConstants.GUIDE_STEP4_FILE = "Number4"
RSConstants.GUIDE_STEP5_FILE = "Number5"
RSConstants.GUIDE_STEP6_FILE = "Number6"
RSConstants.GUIDE_STEP7_FILE = "Number7"
RSConstants.GUIDE_STEP8_FILE = "Number8"
RSConstants.GUIDE_STEP9_FILE = "Number9"
RSConstants.DRAGON_GLYFH_FILE = "DragonGlyphSmall"

RSConstants.NORMAL_NPC_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.NORMAL_NPC_TEXTURE_FILE);
RSConstants.GROUP_NORMAL_NPC_T_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.NORMAL_NPC_TEXTURE_FILE, RSConstants.GROUP_TOP_TEXTURE_FILE));
RSConstants.GROUP_NORMAL_NPC_L_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.NORMAL_NPC_TEXTURE_FILE, RSConstants.GROUP_LEFT_TEXTURE_FILE));
RSConstants.GROUP_NORMAL_NPC_R_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.NORMAL_NPC_TEXTURE_FILE, RSConstants.GROUP_RIGHT_TEXTURE_FILE));
RSConstants.GREEN_NPC_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.GREEN_NPC_TEXTURE_FILE);
RSConstants.GROUP_GREEN_NPC_T_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.GREEN_NPC_TEXTURE_FILE, RSConstants.GROUP_TOP_TEXTURE_FILE));
RSConstants.GROUP_GREEN_NPC_L_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.GREEN_NPC_TEXTURE_FILE, RSConstants.GROUP_LEFT_TEXTURE_FILE));
RSConstants.GROUP_GREEN_NPC_R_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.GREEN_NPC_TEXTURE_FILE, RSConstants.GROUP_RIGHT_TEXTURE_FILE));
RSConstants.YELLOW_NPC_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.YELLOW_NPC_TEXTURE_FILE);
RSConstants.GROUP_YELLOW_NPC_T_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.YELLOW_NPC_TEXTURE_FILE, RSConstants.GROUP_TOP_TEXTURE_FILE));
RSConstants.GROUP_YELLOW_NPC_L_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.YELLOW_NPC_TEXTURE_FILE, RSConstants.GROUP_LEFT_TEXTURE_FILE));
RSConstants.GROUP_YELLOW_NPC_R_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.YELLOW_NPC_TEXTURE_FILE, RSConstants.GROUP_RIGHT_TEXTURE_FILE));
RSConstants.RED_NPC_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.RED_NPC_TEXTURE_FILE);
RSConstants.GROUP_RED_NPC_T_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.RED_NPC_TEXTURE_FILE, RSConstants.GROUP_TOP_TEXTURE_FILE));
RSConstants.GROUP_RED_NPC_L_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.RED_NPC_TEXTURE_FILE, RSConstants.GROUP_LEFT_TEXTURE_FILE));
RSConstants.GROUP_RED_NPC_R_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.RED_NPC_TEXTURE_FILE, RSConstants.GROUP_RIGHT_TEXTURE_FILE));
RSConstants.PINK_NPC_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.PINK_NPC_TEXTURE_FILE);
RSConstants.GROUP_PINK_NPC_T_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.PINK_NPC_TEXTURE_FILE, RSConstants.GROUP_TOP_TEXTURE_FILE));
RSConstants.GROUP_PINK_NPC_L_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.PINK_NPC_TEXTURE_FILE, RSConstants.GROUP_LEFT_TEXTURE_FILE));
RSConstants.GROUP_PINK_NPC_R_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.PINK_NPC_TEXTURE_FILE, RSConstants.GROUP_RIGHT_TEXTURE_FILE));
RSConstants.BLUE_NPC_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.BLUE_NPC_TEXTURE_FILE);
RSConstants.GROUP_BLUE_NPC_T_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.BLUE_NPC_TEXTURE_FILE, RSConstants.GROUP_TOP_TEXTURE_FILE));
RSConstants.GROUP_BLUE_NPC_L_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.BLUE_NPC_TEXTURE_FILE, RSConstants.GROUP_LEFT_TEXTURE_FILE));
RSConstants.GROUP_BLUE_NPC_R_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.BLUE_NPC_TEXTURE_FILE, RSConstants.GROUP_RIGHT_TEXTURE_FILE));
RSConstants.LIGHT_BLUE_NPC_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.LIGHT_BLUE_NPC_TEXTURE_FILE);
RSConstants.GROUP_LIGHT_BLUE_NPC_T_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.LIGHT_BLUE_NPC_TEXTURE_FILE, RSConstants.GROUP_TOP_TEXTURE_FILE));
RSConstants.GROUP_LIGHT_BLUE_NPC_L_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.LIGHT_BLUE_NPC_TEXTURE_FILE, RSConstants.GROUP_LEFT_TEXTURE_FILE));
RSConstants.GROUP_LIGHT_BLUE_NPC_R_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.LIGHT_BLUE_NPC_TEXTURE_FILE, RSConstants.GROUP_RIGHT_TEXTURE_FILE));
RSConstants.NORMAL_CONTAINER_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.NORMAL_CONTAINER_TEXTURE_FILE);
RSConstants.GROUP_NORMAL_CONTAINER_T_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.NORMAL_CONTAINER_TEXTURE_FILE, RSConstants.GROUP_TOP_TEXTURE_FILE));
RSConstants.GROUP_NORMAL_CONTAINER_L_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.NORMAL_CONTAINER_TEXTURE_FILE, RSConstants.GROUP_LEFT_TEXTURE_FILE));
RSConstants.GROUP_NORMAL_CONTAINER_R_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.NORMAL_CONTAINER_TEXTURE_FILE, RSConstants.GROUP_RIGHT_TEXTURE_FILE));
RSConstants.GREEN_CONTAINER_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.GREEN_CONTAINER_TEXTURE_FILE);
RSConstants.GROUP_GREEN_CONTAINER_T_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.GREEN_CONTAINER_TEXTURE_FILE, RSConstants.GROUP_TOP_TEXTURE_FILE));
RSConstants.GROUP_GREEN_CONTAINER_L_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.GREEN_CONTAINER_TEXTURE_FILE, RSConstants.GROUP_LEFT_TEXTURE_FILE));
RSConstants.GROUP_GREEN_CONTAINER_R_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.GREEN_CONTAINER_TEXTURE_FILE, RSConstants.GROUP_RIGHT_TEXTURE_FILE));
RSConstants.YELLOW_CONTAINER_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.YELLOW_CONTAINER_TEXTURE_FILE);
RSConstants.GROUP_YELLOW_CONTAINER_T_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.YELLOW_CONTAINER_TEXTURE_FILE, RSConstants.GROUP_TOP_TEXTURE_FILE));
RSConstants.GROUP_YELLOW_CONTAINER_L_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.YELLOW_CONTAINER_TEXTURE_FILE, RSConstants.GROUP_LEFT_TEXTURE_FILE));
RSConstants.GROUP_YELLOW_CONTAINER_R_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.YELLOW_CONTAINER_TEXTURE_FILE, RSConstants.GROUP_RIGHT_TEXTURE_FILE));
RSConstants.RED_CONTAINER_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.RED_CONTAINER_TEXTURE_FILE);
RSConstants.GROUP_RED_CONTAINER_T_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.RED_CONTAINER_TEXTURE_FILE, RSConstants.GROUP_TOP_TEXTURE_FILE));
RSConstants.GROUP_RED_CONTAINER_L_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.RED_CONTAINER_TEXTURE_FILE, RSConstants.GROUP_LEFT_TEXTURE_FILE));
RSConstants.GROUP_RED_CONTAINER_R_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.RED_CONTAINER_TEXTURE_FILE, RSConstants.GROUP_RIGHT_TEXTURE_FILE));
RSConstants.PINK_CONTAINER_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.PINK_CONTAINER_TEXTURE_FILE);
RSConstants.GROUP_PINK_CONTAINER_T_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.PINK_CONTAINER_TEXTURE_FILE, RSConstants.GROUP_TOP_TEXTURE_FILE));
RSConstants.GROUP_PINK_CONTAINER_L_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.PINK_CONTAINER_TEXTURE_FILE, RSConstants.GROUP_LEFT_TEXTURE_FILE));
RSConstants.GROUP_PINK_CONTAINER_R_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.PINK_CONTAINER_TEXTURE_FILE, RSConstants.GROUP_RIGHT_TEXTURE_FILE));
RSConstants.BLUE_CONTAINER_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.BLUE_CONTAINER_TEXTURE_FILE);
RSConstants.GROUP_BLUE_CONTAINER_T_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.BLUE_CONTAINER_TEXTURE_FILE, RSConstants.GROUP_TOP_TEXTURE_FILE));
RSConstants.GROUP_BLUE_CONTAINER_L_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.BLUE_CONTAINER_TEXTURE_FILE, RSConstants.GROUP_LEFT_TEXTURE_FILE));
RSConstants.GROUP_BLUE_CONTAINER_R_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.BLUE_CONTAINER_TEXTURE_FILE, RSConstants.GROUP_RIGHT_TEXTURE_FILE));
RSConstants.NORMAL_EVENT_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.NORMAL_EVENT_TEXTURE_FILE);
RSConstants.GROUP_NORMAL_EVENT_T_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.NORMAL_EVENT_TEXTURE_FILE, RSConstants.GROUP_TOP_TEXTURE_FILE));
RSConstants.GROUP_NORMAL_EVENT_L_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.NORMAL_EVENT_TEXTURE_FILE, RSConstants.GROUP_LEFT_TEXTURE_FILE));
RSConstants.GROUP_NORMAL_EVENT_R_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.NORMAL_EVENT_TEXTURE_FILE, RSConstants.GROUP_RIGHT_TEXTURE_FILE));
RSConstants.GREEN_EVENT_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.GREEN_EVENT_TEXTURE_FILE);
RSConstants.GROUP_GREEN_EVENT_T_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.GREEN_EVENT_TEXTURE_FILE, RSConstants.GROUP_TOP_TEXTURE_FILE));
RSConstants.GROUP_GREEN_EVENT_L_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.GREEN_EVENT_TEXTURE_FILE, RSConstants.GROUP_LEFT_TEXTURE_FILE));
RSConstants.GROUP_GREEN_EVENT_R_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.GREEN_EVENT_TEXTURE_FILE, RSConstants.GROUP_RIGHT_TEXTURE_FILE));
RSConstants.YELLOW_EVENT_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.YELLOW_EVENT_TEXTURE_FILE);
RSConstants.GROUP_YELLOW_EVENT_T_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.YELLOW_EVENT_TEXTURE_FILE, RSConstants.GROUP_TOP_TEXTURE_FILE));
RSConstants.GROUP_YELLOW_EVENT_L_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.YELLOW_EVENT_TEXTURE_FILE, RSConstants.GROUP_LEFT_TEXTURE_FILE));
RSConstants.GROUP_YELLOW_EVENT_R_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.YELLOW_EVENT_TEXTURE_FILE, RSConstants.GROUP_RIGHT_TEXTURE_FILE));
RSConstants.RED_EVENT_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.RED_EVENT_TEXTURE_FILE);
RSConstants.GROUP_RED_EVENT_T_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.RED_EVENT_TEXTURE_FILE, RSConstants.GROUP_TOP_TEXTURE_FILE));
RSConstants.GROUP_RED_EVENT_L_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.RED_EVENT_TEXTURE_FILE, RSConstants.GROUP_LEFT_TEXTURE_FILE));
RSConstants.GROUP_RED_EVENT_R_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.RED_EVENT_TEXTURE_FILE, RSConstants.GROUP_RIGHT_TEXTURE_FILE));
RSConstants.PINK_EVENT_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.PINK_EVENT_TEXTURE_FILE);
RSConstants.GROUP_PINK_EVENT_T_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.PINK_EVENT_TEXTURE_FILE, RSConstants.GROUP_TOP_TEXTURE_FILE));
RSConstants.GROUP_PINK_EVENT_L_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.PINK_EVENT_TEXTURE_FILE, RSConstants.GROUP_LEFT_TEXTURE_FILE));
RSConstants.GROUP_PINK_EVENT_R_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.PINK_EVENT_TEXTURE_FILE, RSConstants.GROUP_RIGHT_TEXTURE_FILE));
RSConstants.BLUE_EVENT_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.BLUE_EVENT_TEXTURE_FILE);
RSConstants.GROUP_BLUE_EVENT_T_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.BLUE_EVENT_TEXTURE_FILE, RSConstants.GROUP_TOP_TEXTURE_FILE));
RSConstants.GROUP_BLUE_EVENT_L_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.BLUE_EVENT_TEXTURE_FILE, RSConstants.GROUP_LEFT_TEXTURE_FILE));
RSConstants.GROUP_BLUE_EVENT_R_TEXTURE = string.format(RSConstants.TEXTURE_PATH, string.format("%s%s", RSConstants.BLUE_EVENT_TEXTURE_FILE, RSConstants.GROUP_RIGHT_TEXTURE_FILE));
RSConstants.OVERLAY_SPOT_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.OVERLAY_SPOT_TEXTURE_FILE);
RSConstants.GUIDE_TRANSPORT_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.GUIDE_TRANSPORT_FILE);
RSConstants.GUIDE_ENTRANCE_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.GUIDE_ENTRANCE_FILE);
RSConstants.GUIDE_FLAG_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.GUIDE_FLAG_FILE);
RSConstants.GUIDE_DOT_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.GUIDE_DOT_FILE);
RSConstants.GUIDE_STEP1_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.GUIDE_STEP1_FILE);
RSConstants.GUIDE_STEP2_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.GUIDE_STEP2_FILE);
RSConstants.GUIDE_STEP3_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.GUIDE_STEP3_FILE);
RSConstants.GUIDE_STEP4_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.GUIDE_STEP4_FILE);
RSConstants.GUIDE_STEP5_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.GUIDE_STEP5_FILE);
RSConstants.GUIDE_STEP6_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.GUIDE_STEP6_FILE);
RSConstants.GUIDE_STEP7_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.GUIDE_STEP7_FILE);
RSConstants.GUIDE_STEP8_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.GUIDE_STEP8_FILE);
RSConstants.GUIDE_STEP9_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.GUIDE_STEP9_FILE);
RSConstants.DRAGON_GLYPH_TEXTURE = string.format(RSConstants.TEXTURE_PATH, RSConstants.DRAGON_GLYFH_FILE);

---============================================================================
-- Guide constants
---============================================================================

RSConstants.TRANSPORT = "T"
RSConstants.ENTRANCE = "E"
RSConstants.PATH_START = "P"
RSConstants.FLAG = "F"
RSConstants.DOT = "D"
RSConstants.STEP1 = "1"
RSConstants.STEP2 = "2"
RSConstants.STEP3 = "3"
RSConstants.STEP4 = "4"
RSConstants.STEP5 = "5"
RSConstants.STEP6 = "6"
RSConstants.STEP7 = "7"

---============================================================================
-- Dialogs
---============================================================================

RSConstants.APPLY_COLLECTIONS_LOOT_FILTERS = "RARESCANNER_APPLY_COLLECTIONS_LOOT_FILTERS"
RSConstants.EXPLORER_FILTERING_DIALOG = "RARESCANNER_EXPLORER_FILTERING_DIALOG"
RSConstants.EXPLORER_SCAN_NOT_DONE = "RARESCANNER_EXPLORER_SCAN_NOT_DONE"

---============================================================================
-- Explorer filters
---============================================================================

RSConstants.EXPLORER_FILTER_DROP_MOUNTS = 1
RSConstants.EXPLORER_FILTER_DROP_PETS = 2
RSConstants.EXPLORER_FILTER_DROP_TOYS = 3
RSConstants.EXPLORER_FILTER_DROP_APPEARANCES = 4
RSConstants.EXPLORER_FILTER_PART_ACHIEVEMENT = 5
RSConstants.EXPLORER_FILTER_DEAD = 6
RSConstants.EXPLORER_FILTER_FILTERED = 7
RSConstants.EXPLORER_FILTER_WITHOUT_COLLECTIBLES = 8

---============================================================================
-- Others
---============================================================================

RSConstants.RAID_WARNING_SHOWING_TIME = 3
RSConstants.MINIMUM_DISTANCE_PINS_WORLD_MAP = 0.005
RSConstants.TOOLTIP_MAX_WIDTH = 300

---============================================================================
-- Auxiliar functions
---============================================================================

function RSConstants.IsScanneableAtlas(atlasName)
	return RSConstants.IsEventAtlas(atlasName) or RSConstants.IsNpcAtlas(atlasName) or RSConstants.IsContainerAtlas(atlasName)
end

function RSConstants.IsEventAtlas(atlasName)
	return atlasName == RSConstants.EVENT_VIGNETTE or atlasName == RSConstants.EVENT_ELITE_VIGNETTE or atlasName == RSConstants.EVENT_TORMENTORS_VIGNETTE
end

function RSConstants.IsNpcAtlas(atlasName)
	return atlasName == RSConstants.NPC_VIGNETTE or atlasName == RSConstants.NPC_LEGION_VIGNETTE or atlasName == RSConstants.NPC_VIGNETTE_ELITE or atlasName == RSConstants.NPC_NAZJATAR_VIGNETTE or atlasName == RSConstants.NPC_WARFRONT_NEUTRAL_HERO_VIGNETTE or atlasName == RSConstants.NPC_TORMENTORS_VIGNETTE
end

function RSConstants.IsContainerAtlas(atlasName)
	return atlasName == RSConstants.CONTAINER_VIGNETTE or atlasName == RSConstants.CONTAINER_ELITE_VIGNETTE
end
