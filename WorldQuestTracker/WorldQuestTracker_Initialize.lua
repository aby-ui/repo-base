


do
	--> update quest type max when a new type of world quest is added to the filtering
	WQT_QUESTTYPE_MAX = 		10			--[[global]]

	--> all quest types current available
	WQT_QUESTTYPE_GOLD = 		"gold"			--[[global]]
	WQT_QUESTTYPE_RESOURCE = 	"resource"		--[[global]]
	WQT_QUESTTYPE_APOWER = 	"apower"		--[[global]]
	WQT_QUESTTYPE_EQUIPMENT = 	"equipment"	--[[global]]
	WQT_QUESTTYPE_TRADE = 		"trade"		--[[global]]
	WQT_QUESTTYPE_DUNGEON = 	"dungeon"		--[[global]]
	WQT_QUESTTYPE_PROFESSION =	 "profession"	--[[global]]
	WQT_QUESTTYPE_PVP = 		"pvp"			--[[global]]
	WQT_QUESTTYPE_PETBATTLE = 	"petbattle"		--[[global]]
	WQT_QUESTTYPE_REPUTATION = 	"reputation"	--[[global]]

	WQT_QUERYTYPE_REWARD = 	"reward"		--[[global]]
	WQT_QUERYTYPE_QUEST = 		"quest"		--[[global]]
	WQT_QUERYTYPE_PERIOD = 		"period"		--[[global]]
	WQT_QUERYDB_ACCOUNT = 		"global"		--[[global]]
	WQT_QUERYDB_LOCAL = 		"character"		--[[global]]
	WQT_REWARD_RESOURCE = 		"resource"		--[[global]]
	WQT_REWARD_GOLD = 			"gold"			--[[global]]
	WQT_REWARD_APOWER = 		"artifact"		--[[global]]
	WQT_QUESTS_TOTAL = 		"total"		--[[global]]
	WQT_QUESTS_PERIOD = 		"quest"		--[[global]]
	WQT_DATE_TODAY = 			1			--[[global]]
	WQT_DATE_YESTERDAY = 		2			--[[global]]
	WQT_DATE_1WEEK = 			3			--[[global]]
	WQT_DATE_2WEEK = 			4			--[[global]]
	WQT_DATE_MONTH = 			5			--[[global]]
	
	--helps blend the icons within the map texture
	WQT_ZONEWIDGET_ALPHA =		0.83
	WQT_WORLDWIDGET_ALPHA =	0.845
	WQT_WORLDWIDGET_BLENDED =	ALPHA_BLEND_AMOUNT - 0.16
	
	WQT_ANIMATION_SPEED = 0.05
	
	--where these came from
	QUESTTYPE_GOLD = 0x1
	QUESTTYPE_RESOURCE = 0x2
	QUESTTYPE_ITEM = 0x4
	QUESTTYPE_ARTIFACTPOWER = 0x8
	
	--todo: rename or put these into a table
	FILTER_TYPE_PET_BATTLES = "pet_battles"
	FILTER_TYPE_PVP = "pvp"
	FILTER_TYPE_PROFESSION = "profession"
	FILTER_TYPE_DUNGEON = "dungeon"
	FILTER_TYPE_GOLD = "gold"
	FILTER_TYPE_ARTIFACT_POWER = "artifact_power"
	FILTER_TYPE_GARRISON_RESOURCE = "garrison_resource"
	FILTER_TYPE_REPUTATION_TOKEN = "reputation_token"
	FILTER_TYPE_EQUIPMENT = "equipment"
	FILTER_TYPE_TRADESKILL = "trade_skill"

	local default_config = {
		profile = {
			filters = {
				pet_battles = true,
				pvp = true,
				profession = true,
				dungeon = true,
				gold = true,
				artifact_power = true,
				garrison_resource = true,
				equipment = true,
				trade_skill = true,
				reputation_token = true,
			},
			
			sort_order = {
				[WQT_QUESTTYPE_REPUTATION] = 10,
				[WQT_QUESTTYPE_TRADE] = 9,
				[WQT_QUESTTYPE_APOWER] = 8,
				[WQT_QUESTTYPE_GOLD] = 6,
				[WQT_QUESTTYPE_RESOURCE] = 7,
				[WQT_QUESTTYPE_EQUIPMENT] = 5,
				[WQT_QUESTTYPE_DUNGEON] = 4,
				[WQT_QUESTTYPE_PROFESSION] = 3,
				[WQT_QUESTTYPE_PVP] = 2,
				[WQT_QUESTTYPE_PETBATTLE] = 1,
			},
			
			groupfinder = {
				enabled = true,
				invasion_points = false, --deprecated
				tracker_buttons = false,
				autoleave = false,
				autoleave_delayed = false,
				askleave_delayed = true,
				noleave = false,
				leavetimer = 30,
				noafk = true, --deprecated
				noafk_ticks = 5, --deprecated
				noafk_distance = 500, --deprecated
				nopvp = false, --deprecated
				frame = {},
				tutorial = 0,
				argus_min_itemlevel = 830, --deprecated
				ignored_quests = {},
				send_whispers = false,
				dont_open_in_group = true,
			},

			rarescan = {
				show_icons = true,
				alerts_anywhere = false,
				join_channel = false,
				search_group = true,
				recently_spotted = {},
				recently_killed = {},
				name_cache = {},
				playsound = false,
				playsound_volume = 2,
				playsound_warnings = 0,
				use_master = true,
				always_use_english = false,
				add_from_premade = false,
				autosearch = true,
				autosearch_cooldown = 600,
				autosearch_share = false,
			},

			world_map_config = {
				onmap_show = true,
				onmap_scale_offset = 0,
				summary_show = true,
				summary_scale = 1,
				summary_showbyzone = true,
				summary_anchor = "left",
				summary_widgets_per_row = 7,
			},
			
			disable_world_map_widgets = false,
			
			worldmap_widgets = {
				textsize = 9,
				scale = 1,
				quest_icons_scale_offset = 0,
			},
			
			accessibility = {
				extra_tracking_indicator = false,
				use_bounty_ring = false,
			},
			
			last_news_time = 0,

			hoverover_animations = true, --hover and shown slider animations
			anchor_options = {}, --store the anchor options of each anchor
			
			filter_always_show_faction_objectives = true,
			filter_force_show_brokenshore = false, --deprecated at this point, but won't be removed since further expantion might need this back
			sort_time_priority = 0,
			force_sort_by_timeleft = false,
			alpha_time_priority = false,
			show_timeleft = false,
			quests_tracked = {},
			quests_all_characters = {},
			banned_quests = {},
			syntheticMapIdList = {
				[1015] = 1, --azsuna
				[1018] = 2, --valsharah
				[1024] = 3, --highmountain
				[1017] = 4, --stormheim
				[1033] = 5, --suramar
				[1096] = 6, --eye of azshara
			},
			taxy_showquests = true,
			taxy_trackedonly = false,
			taxy_tracked_scale = 3,
			arrow_update_frequence = 0.016,
			map_lock = false,
			sound_enabled = true,
			use_tracker = true,
			tracker_is_movable = false,
			tracker_is_locked = false,
			tracker_only_currentmap = false,
			tracker_scale = 1,
			tracker_show_time = false,
			tracker_textsize = 12,
			
			show_faction_frame = true,
			
			map_frame_anchor = "center",
			
			map_frame_scale_enabled = false,
			map_frame_scale_mod = 1,
			
			use_quest_summary = true,
			quest_summary_minimized = false,
			show_summary_minimize_button = true,
			
			zone_map_config = {
				quest_summary_scale = 1,
				show_widgets = true,
				scale = 1,
			},
			
			is_BFA_version = false, --if is false, reset the tutorial
			
			zone_only_tracked = false,
			low_level_tutorial = false, --
			bar_anchor = "bottom",
			bar_visible = true,
			use_old_icons = false,
			history = {
				reward = {
					global = {},
					character = {},
				},
				quest = {
					global = {},
					character = {},
				},
				period = {
					global = {},
					character = {},
				},
			},
			show_yards_distance = true,
			player_names = {},
			tomtom = {
				enabled = false,
				uids = {},
				persistent = true,
			},
		},
	}
	

	--details! framework
	local DF = _G ["DetailsFramework"]
	if (not DF) then
		print ("|cFFFFAA00World Quest Tracker: framework not found, if you just installed or updated the addon, please restart your client.|r")
		return
	end
	
	--create the addon object
	local WorldQuestTracker = DF:CreateAddOn ("WorldQuestTrackerAddon", "WQTrackerDB", default_config)

	--create the group finder and rare finder frames
	CreateFrame ("frame", "WorldQuestTrackerFinderFrame", UIParent)
	CreateFrame ("frame", "WorldQuestTrackerRareFrame", UIParent)

	--create world quest tracker pin
	WorldQuestTrackerPinMixin = CreateFromMixins (MapCanvasPinMixin)
	
	--data providers are stored inside .dataProviders folder
	--catch the blizzard quest provider
	function WorldQuestTrackerAddon.CatchMapProvider (fromMapOpened)
		if (not WorldQuestTrackerAddon.DataProvider) then
			if (WorldMapFrame and WorldMapFrame.dataProviders) then
				for dataProvider, state in pairs (WorldMapFrame.dataProviders) do
					if (dataProvider.IsQuestSuppressed) then
						WorldQuestTrackerAddon.DataProvider = dataProvider
						break
					end
				end
			end
			
			if (not WorldQuestTrackerAddon.DataProvider and fromMapOpened) then
				WorldQuestTracker:Msg ("Failed to initialize or get Data Provider.")
			end
		end
	end
	
	WorldQuestTrackerAddon.CatchMapProvider()

	--store zone widgets
	WorldQuestTracker.ZoneWidgetPool = {} 
	--default world quest pins
	WorldQuestTracker.DefaultWorldQuestPin = {} 
	WorldQuestTracker.ShowDefaultWorldQuestPin = {} 
	--frame where things will be parented to
	WorldQuestTracker.AnchoringFrame = WorldMapFrame.BorderFrame
	--frame level for things attached to the world map
	WorldQuestTracker.DefaultFrameLevel = 5000
	--the client has all the data for the quest
	WorldQuestTracker.HasQuestData = {}
	
	--color pallete
	WorldQuestTracker.ColorPalette = {
		orange = {1, .8, .22},
		yellow = {.8, .8, .22},
		red = {.9, .22, .22},
		green = {.22, .9, .22},
		blue = {.22, .22, .9},
	}
	
	--store the available resources from each quest and map
	WorldQuestTracker.ResourceData = {}
	
	--comms
	WorldQuestTracker.CommFunctions = {}
	function WorldQuestTracker.HandleComm (validData)
		local prefix = validData [1]
		if (WorldQuestTracker.CommFunctions [prefix]) then
			WorldQuestTracker.CommFunctions [prefix] (validData)
		end
	end
	
	--register things we'll use
	local color = OBJECTIVE_TRACKER_COLOR ["Header"]
	DF:NewColor ("WQT_QUESTTITLE_INMAP", color.r, color.g, color.b, .8)
	DF:NewColor ("WQT_QUESTTITLE_OUTMAP", 1, .8, .2, .7)
	DF:NewColor ("WQT_QUESTZONE_INMAP", 1, 1, 1, 1)
	DF:NewColor ("WQT_QUESTZONE_OUTMAP", 1, 1, 1, .7)
	DF:NewColor ("WQT_ORANGE_ON_ENTER", 1, 0.847059, 0, 1)
	DF:NewColor ("WQT_ORANGE_RESOURCES_AVAILABLE", 1, .7, .2, .85)
	DF:NewColor ("WQT_ORANGE_YELLOW_RARE_TITTLE", 1, 0.677059, 0.05, 1)
	
	DF:InstallTemplate ("font", "WQT_SUMMARY_TITLE", {color = "orange", size = 12, font = ChatFontNormal:GetFont()})
	DF:InstallTemplate ("font", "WQT_RESOURCES_AVAILABLE", {color = {1, .7, .2, .85}, size = 10, font = ChatFontNormal:GetFont()})
	DF:InstallTemplate ("font", "WQT_GROUPFINDER_BIG", {color = {1, .7, .2, .85}, size = 11, font = ChatFontNormal:GetFont()})
	DF:InstallTemplate ("font", "WQT_GROUPFINDER_SMALL", {color = {1, .9, .1, .85}, size = 10, font = ChatFontNormal:GetFont()})
	DF:InstallTemplate ("font", "WQT_GROUPFINDER_TRANSPARENT", {color = {1, 1, 1, .2}, size = 10, font = ChatFontNormal:GetFont()})
	DF:InstallTemplate ("font", "WQT_TOGGLEQUEST_TEXT", {color = {0.811, 0.626, .109}, size = 10, font = ChatFontNormal:GetFont()})
	
	DF:InstallTemplate ("button", "WQT_GROUPFINDER_BUTTON", {
		backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
		backdropcolor = {.2, .2, .2, 1},
		backdropbordercolor = {0, 0, 0, 1},
		width = 20,
		height = 20,
		enabled_backdropcolor = {.2, .2, .2, 1},
		disabled_backdropcolor = {.2, .2, .2, 1},
		onenterbordercolor = {0, 0, 0, 1},
	})
	
	DF:InstallTemplate ("button", "WQT_NEWS_BUTTON", {
		backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
		backdropcolor = {.2, .2, .2, .8},
		backdropbordercolor = {0, 0, 0, .8},
		width = 120,
		height = 20,
		onenterbordercolor = {0, 0, 0, 1},
		onentercolor = {.4, .4, .4, 1},
	}, "WQT_GROUPFINDER_BUTTON")
	
	--settings
	--WorldQuestTracker.Constants.
	WorldQuestTrackerAddon.Constants = {
		WorldMapSquareSize = 24,
		TimeBlipSize = 14,
	}
	
	WorldQuestTrackerAddon.WorldWidgetAlpha = .75
	WorldQuestTrackerAddon.WorldWidgetSmallAlpha = .75
	
	local L = LibStub ("AceLocale-3.0"):GetLocale ("WorldQuestTrackerAddon", true)
	WorldQuestTracker.ChangeLogTable = {
		{1544645786, "Anchor Changes", "December 13, 2018", "Hover over the zone name in the quest summary for a zone to show options for that anchor."},
		{1544477110, "World Map Changes", "December 13, 2018", "World map is now aligned in the center of the screen. " .. L["S_MAPBAR_OPTIONS"] .. " > '" .. L["S_OPTIONS_MAPFRAME_ALIGN"] .. "' to disable this."},
		{1544477110, "World Map Changes", "December 13, 2018", "Quest list is now default to quest type, click '" .. L["S_WORLDBUTTONS_SHOW_ZONE"] .. "' to swap."},
		{1544477110, "World Map Changes", "December 13, 2018", "Added quest locations to world map, click '" .. L["S_WORLDBUTTONS_TOGGLE_QUESTS"] .. "' to hide."},
		{1544477110, "World Map Changes", "December 13, 2018", "Added an arrow button in the quest list to start tracking all quests in that list."},
		{1544477110, "World Map Changes", "December 13, 2018", "Added faction indicators, SHIFT + Left Click to track all quests for that faction."},
		{1544477110, "Zone Map Changes", "December 13, 2018", "The fullscreen quest summary is now available in windowed mode."},
		{1544477110, "General Settings", "December 13, 2018", "Added quest blacklist, access it throught the options menu."},
		{1544477110, "General Settings", "December 13, 2018", "Added Map Window Scale settings in the options menu."},
		{1544477110, "General Settings", "December 13, 2018", "Several options added to World Map and Zone Map at the options menu."},
		--{1544477110, "", "December 13, 2018", ""},
	}	
	
end




