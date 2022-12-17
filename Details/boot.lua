-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--global name declaration

		_ = nil
		_G._detalhes = LibStub("AceAddon-3.0"):NewAddon("_detalhes", "AceTimer-3.0", "AceComm-3.0", "AceSerializer-3.0", "NickTag-1.0")
		local addonName, Details222 = ...
		local version, build, date, tocversion = GetBuildInfo()

		_detalhes.build_counter = 10337
		_detalhes.alpha_build_counter = 10337 --if this is higher than the regular counter, use it instead
		_detalhes.dont_open_news = true
		_detalhes.game_version = version
		_detalhes.userversion = version .. " " .. _detalhes.build_counter
		_detalhes.realversion = 148 --core version, this is used to check API version for scripts and plugins (see alias below)
		_detalhes.APIVersion = _detalhes.realversion --core version
		_detalhes.version = _detalhes.userversion .. " (core " .. _detalhes.realversion .. ")" --simple stirng to show to players

		_detalhes.acounter = 1 --in case of a second release with the same .build_counter
		_detalhes.curseforgeVersion = GetAddOnMetadata("Details", "Version")

		function _detalhes:GetCoreVersion()
			return _detalhes.realversion
		end

		_detalhes.BFACORE = 131 --core version on BFA launch
		_detalhes.SHADOWLANDSCORE = 143 --core version on Shadowlands launch
		_detalhes.DRAGONFLIGHT = 147 --core version on Dragonflight launch

		Details = _detalhes

		local gameVersionPrefix = "Unknown Game Version - You're probably using a Details! not compatible with this version of the Game"
		--these are the game versions currently compatible with this Details! versions
		if (DetailsFramework.IsWotLKWow() or DetailsFramework.IsShadowlandsWow() or DetailsFramework.IsDragonflight()) then
			gameVersionPrefix = "WD"
		end

		Details.gameVersionPrefix = gameVersionPrefix

		--WD 10288 RELEASE 10.0.2
		--WD 10288 ALPHA 21 10.0.2
		function Details.GetVersionString()
			local curseforgeVersion = _detalhes.curseforgeVersion or ""
			local alphaId = curseforgeVersion:match("%-(%d+)%-")

			if (not alphaId) then
				--this is a release version
				alphaId = "RELEASE"
			else
				alphaId = "ALPHA " .. alphaId
			end

			return Details.gameVersionPrefix .. " " .. Details.build_counter .. " " .. alphaId .. " " .. Details.game_version .. ""
		end

		--namespace for the player breakdown window
		Details.PlayerBreakdown = {}
		Details222.PlayerBreakdown = {
			DamageSpellsCache = {}
		}

		--namespace color
		Details222.ColorScheme = {
			["gradient-background"] = {0.1215, 0.1176, 0.1294, 0.8},
		}

		function Details222.ColorScheme.GetColorFor(colorScheme)
			return Details222.ColorScheme[colorScheme]
		end

		--namespace for damage spells (spellTable)
		Details222.DamageSpells = {}


		--namespace for texture
		Details222.Textures = {}

		--namespace for pet
		Details222.Pets = {}

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--initialization stuff
local _

do
	local _detalhes = _G._detalhes

	_detalhes.resize_debug = {}

	local Loc = _G.LibStub("AceLocale-3.0"):GetLocale( "Details" )

	local news = {
		{"v10.0.2.10333.147", "Nov 18th, 2022"},
		"Added two checkboxes for Merge Pet and Player spell on the Breakdown window.",
		"Added uptime for Hunter's Pet Frenzy Buff, it now show in the 'Auras' tab in the Breakdown Window.",
		"/played is showing something new!",
		"Options panel now closes by pressing Escape (Flamanis).",

		{"v10.0.2.10277.146", "Nov 18th, 2022"},
		"REMINDER: '/details coach' to get damage/healing/deaths in real time as the 21st person (coach) for the next raid tier in dragonflight.",
		"New Compare tab: recreated from scratch, this new Compare has no player limitation, pets merged, bigger lines.",
		"New <Plugin: Cast Log> show a time line of spells used by players in the group, Raid Leader: show all attack and defense cooldowns used by the raid (download it now on wago or curseforge).",
		"Wago: Details! Standalone version is now hosted on addons.wago.io and WowUp.com.",
		"",

		"Added a little damage chart for your spells in the Player Breakdown Window.",
		"Details! will count class play time, everyone using Details! from day 1 in Dragonflight should have an accurate play time in the class.",
		"Visual updates on default skin.",
		"All panels from options to plugins received visual updates.",
		"Profiles won't export Auto Hide automations to stop issues with players not knowing why the window is hidding.",
		"Details! should decrease the amount of chat spam errors and instead show them in the bug report window like al the other addons.",
		"Player Details! Breakdown window: player selection now uses the same font as the regular window.",
		"Death log tooltip revamp for more clarity to see the ability name and the damage done.",
		"Dragonflight Trinkets damage will show the trinket name after the spell name.",
		"'/details scroll' feature: spell name and spell id can now be copied, the frame got a scale bar.",
		"Added option: 'Use Dynamic Overall Damage', if enabled swap to Dynamic Overall Damage when combat start while showing Overall Damage.",
		"Fixed for most of the user having the problem of the encounter time not showing.",
		"Fixed most of the issues with the melee spell name being called 'Word of Recall'.",
		"Details! Damage Meter, Deatails! Framework, LibOpenRaid has been successfully updated to Dragonflight.",
		"New class Evoker are now fully supported by Details!.",
		"",
		"Fixed an issue where warlocks was entering in combat from a debug doing damage (Flamanis).",
		"Fixed 'Auto of Range' problem in Wrath of the Lich King (Flamanis).",
		"Fixed a bug with custom displays when showing players outside the player group (Flamanis).",
		"Fixed an issue where specs wheren't sent on Wrath (Flamanis).",
		"Fixed Buff Uptime Tooltip where the buff had zero uptime (Flamanis)",
		"Fixed shield damage preventing rare error when the absorption was zero (Flamanis).",
		"Fixed chat embed system built in Details! from the Skins section (Flamanis).",
		"Fixed an issue where damage in battlegrounds was not being sync with battleground score board in Wrath (Flamanis).",
		"",
		"New Slash Commands:",
		"/playedclass: show how much time you have played this class on this expansion.",
		"/dumpt <anything>: show the value of any table, global, spellId, etc.",
		"/details auras: show a panel with your current auras, spell ids and spell payload.",
		"/details perf: show performance issues when you get a warning about freezes due to UpdateAddOnMemoryUsage().",
		"/details npcid: get the npc id of your target (a box is shown with the number ready to be copied).",

		{"v9.2.0.10001.146", "Aug 10th, 2022"},
		"New feature: Arena DPS Bar, can be enabled at the Broadcaster Tools section, shows a bar in 'kamehameha' style showing which team is doing more damage in the latest 3 seconds.",
		"/keystone now has more space for the dungeon name.",
		"Revamp on the options section for Broadcaster tools.",
		"Added 'Icon Size Offset' under Options > Bars: General, this new option allow to adjust the size of the class/spec icon shown on each bar.",
		"Added 'Show Faction Icon' under Options > Bars: General, with this new option, you can choose to not show the faction icon, this icon is usually shown during battlegrounds.",
		"Added 'Faction Icon Size Offset' under Options > Bars: General, new option to adjust the size of the faction icon.",
		"Added 'Show Arena Role Icon' under Options > Bars: General, new option to hide or show the role icon of players during an arena match.",
		"Added 'Clear On Start PVP' overall data option (Flamanis).",
		"Added 'Arena Role Icon Size Offset' under Options > Bars: General, new option which allow to control the size of the arena role icon.",
		"Added 'Level' option to Wallpapers, the wallpaper can now be placed on different levels which solves issues where the wallpaper is too low of certain configuration.",
		"Streamer! plugin got updates, now it is more clear to pick which mode to use.",
		"WotLK classic compatibility (Flamanis, Daniel Henry).",
		"Fixed Grimrail Depot cannon and granades damage be added to players (dios-david).",
		"Fixed the title bar text not showing when using the Custom Title Bar feature.",
		"Fixed an issue with Dynamic Overall Damage printing errors into the chat window (Flamanis).",
		"Role detection in classic versions got improvements.",
		"New API: Details:GetTop5Actors(attributeId), return the top 5 actors from the selected attribute.",
		"New API: Details:GetActorByRank(attributeId, rankIndex), return an actor from the selected attribute and rankIndex.",
		"Major cleanup and code improvements on dropdowns for library Details! Framework.",
		"Cleanup on NickTag library.",
		"Removed LibGroupInSpecT, LibItemUpgradeInfo and LibCompress. These libraries got replaced by OpenRaidLib and LibDeflate.",
	}

	local newsString = "|cFFF1F1F1"

	for i = 1, #news do
		local line = news[i]
		if (type(line) == "table")  then
			local version = line[1]
			local date = line[2]
			newsString = newsString .. "|cFFFFFF00" .. version .. " (|cFFFF8800" .. date .. "|r):|r\n\n"
		else
			if (line ~= "") then
				newsString = newsString .. "|cFFFFFF00-|r " .. line .. "\n\n"
			else
				newsString = newsString .. " \n"
			end
		end
	end

	Loc["STRING_VERSION_LOG"] = newsString

	Loc ["STRING_DETAILS1"] = "|cffffaeaeDetails!:|r "

	--startup
		_detalhes.max_windowline_columns = 11
		_detalhes.initializing = true
		_detalhes.enabled = true
		_detalhes.__index = _detalhes
		_detalhes._tempo = time()
		_detalhes.debug = false
		_detalhes.debug_chr = false
		_detalhes.opened_windows = 0
		_detalhes.last_combat_time = 0

		--store functions to create options frame
		Details.optionsSection = {}

	--containers
		--armazenas as fun��es do parser - All parse functions
			_detalhes.parser = {}
			_detalhes.parser_functions = {}
			_detalhes.parser_frame = CreateFrame("Frame")
			_detalhes.pvp_parser_frame = CreateFrame("Frame")
			_detalhes.parser_frame:Hide()

			_detalhes.MacroList = {
				{Name = "Click on Your Own Bar", Desc = "To open the player details window on your character, like if you click on your bar in the damage window. The number '1' is the window number where it'll click.", MacroText = "/script Details:OpenPlayerDetails(1)"},
				{Name = "Open Encounter Breakdown", Desc = "Open the encounter breakdown plugin. Details! Encounter Breakdown (plugin) must be enabled.", MacroText = "/script Details:OpenPlugin ('Encounter Breakdown')"},
				{Name = "Open Damage per Phase", Desc = "Open the encounter breakdown plugin in the phase tab. Details! Encounter Breakdown (plugin) must be enabled.", MacroText = "/script Details:OpenPlugin ('Encounter Breakdown'); local a=Details_EncounterDetails and Details_EncounterDetails.buttonSwitchPhases:Click()"},
				{Name = "Reset Data", Desc = "Reset the overall and regular segments data. Use 'ResetSegmentOverallData' to reset only the overall.", MacroText = "/script Details:ResetSegmentData()"},
				{Name = "Change What the Window Shows", Desc = "Make a window show different data. SetDisplay uses (segment, displayGroup, displayID), the menu from the sword icon is in order (damage = group 1, overheal is: displayGroup 2 displayID 3.", MacroText = "/script Details:GetWindow(1):SetDisplay( DETAILS_SEGMENTID_CURRENT, 4, 5 )"},
				{Name = "Toggle Window Height to Max Size", Desc = "Make a window be 450 pixel height, pressing the macro again toggle back to the original size. The number '1' if the window number. Hold a click in any window to show their number.", MacroText = "/script Details:GetWindow(1):ToggleMaxSize()"},
			--	/script Details:OpenPlugin ('Advanced Death Logs'); local a = Details_DeathGraphsModeEnduranceButton and Details_DeathGraphsModeEnduranceButton.MyObject:Click()
				{Name = "Report What is Shown In the Window", Desc = "Report the current data shown in the window, the number 1 is the window number, replace it to report another window.", MacroText = "/script Details:FastReportWindow(1)"},
			}

		--current instances of the exp (need to maintain)
			_detalhes.InstancesToStoreData = { --mapId
				[2522] = true, --sepulcher of the first ones
			}

		--armazena os escudos - Shields information for absorbs
			_detalhes.escudos = {}
		--armazena as fun��es dos frames - Frames functions
			_detalhes.gump = _G ["DetailsFramework"]
			function _detalhes:GetFramework()
				return self.gump
			end
			GameCooltip = GameCooltip2
		--anima��es dos icones
			_detalhes.icon_animations = {
				load = {
					in_use = {},
					available = {},
				},
			}

		--make a color namespace
		Details.Colors = {}
		function Details.Colors.GetMenuTextColor()
			return "orange"
		end

		--armazena as fun��es para inicializa��o dos dados - Metatable functions
			_detalhes.refresh = {}
		--armazena as fun��es para limpar e guardas os dados - Metatable functions
			_detalhes.clear = {}
		--armazena a config do painel de fast switch
			_detalhes.switch = {}
		--armazena os estilos salvos
			_detalhes.savedStyles = {}
		--armazena quais atributos possue janela de atributos - contain attributes and sub attributos wich have a detailed window (left click on a row)
			_detalhes.row_singleclick_overwrite = {}
		--report
			_detalhes.ReportOptions = {}
		--armazena os buffs registrados - store buffs ids and functions
			_detalhes.Buffs = {} --initialize buff table
		-- cache de grupo
			_detalhes.cache_damage_group = {}
			_detalhes.cache_healing_group = {}
			_detalhes.cache_npc_ids = {}
		--cache de specs
			_detalhes.cached_specs = {}
			_detalhes.cached_talents = {}
		--ignored pets
			_detalhes.pets_ignored = {}
			_detalhes.pets_no_owner = {}
			_detalhes.pets_players = {}
		--dual candidates
			_detalhes.duel_candidates = {}
		--armazena as skins dispon�veis para as janelas
			_detalhes.skins = {}
		--armazena os hooks das fun��es do parser
			_detalhes.hooks = {}
		--informa��es sobre a luta do boss atual
			_detalhes.encounter_end_table = {}
			_detalhes.encounter_table = {}
			_detalhes.encounter_counter = {}
			_detalhes.encounter_dungeons = {}
		--unitId dos inimigos dentro de uma arena
			_detalhes.arena_enemies = {}
		--reliable char data sources
		--actors that are using details! and sent character data, we don't need query inspect on these actors
			_detalhes.trusted_characters = {}
		--informa��es sobre a arena atual
			_detalhes.arena_table = {}
			_detalhes.arena_info = {
				--need to get the new mapID for 8.0.1
				[562] = {file = "LoadScreenBladesEdgeArena", coords = {0, 1, 0.29296875, 0.9375}}, -- Circle of Blood Arena
				[617] = {file = "LoadScreenDalaranSewersArena", coords = {0, 1, 0.29296875, 0.857421875}}, --Dalaran Arena
				[559] = {file = "LoadScreenNagrandArenaBattlegrounds", coords = {0, 1, 0.341796875, 1}}, --Ring of Trials
				[980] = {file = "LoadScreenTolvirArena", coords = {0, 1, 0.29296875, 0.857421875}}, --Tol'Viron Arena
				[572] = {file = "LoadScreenRuinsofLordaeronBattlegrounds", coords = {0, 1, 0.341796875, 1}}, --Ruins of Lordaeron
				[1134] = {file = "LoadingScreen_Shadowpan_bg", coords = {0, 1, 0.29296875, 0.857421875}}, -- Tiger's Peak
				--legion, thanks @pas06 on curse forge for the mapIds
				[1552] = {file = "LoadingScreen_ArenaValSharah_wide", coords = {0, 1, 0.29296875, 0.857421875}}, -- Ashmane's Fall
				[1504] = {file = "LoadingScreen_BlackrookHoldArena_wide", coords = {0, 1, 0.29296875, 0.857421875}}, --Black Rook Hold

				--"LoadScreenOrgrimmarArena", --Ring of Valor
			}

			function _detalhes:GetArenaInfo (mapid)
				local t = _detalhes.arena_info [mapid]
				if (t) then
					return t.file, t.coords
				end
			end
			_detalhes.battleground_info = {
				--need to get the nwee mapID for 8.0.1
				[489] = {file = "LoadScreenWarsongGulch", coords = {0, 1, 121/512, 484/512}}, --warsong gulch
				[727] = {file = "LoadScreenSilvershardMines", coords = {0, 1, 251/1024, 840/1024}}, --silvershard mines
				[529] = {file = "LoadscreenArathiBasin", coords = {0, 1, 126/512, 430/512}}, --arathi basin
				[566] = {file = "LoadScreenNetherBattlegrounds", coords = {0, 1, 142/512, 466/512}}, --eye of the storm
				[30] = {file = "LoadScreenPvpBattleground", coords = {0, 1, 127/512, 500/512}}, --alterac valley
				[761] = {file = "LoadScreenGilneasBG2", coords = {0, 1, 281/1024, 878/1024}}, --the battle for gilneas
				[726] = {file = "LoadScreenTwinPeaksBG", coords = {0, 1, 294/1024, 876/1024}}, --twin peaks
				[998] = {file = "LoadScreenValleyofPower", coords = {0, 1, 257/1024, 839/1024}}, --temple of kotmogu
				[1105] = {file = "LoadScreen_GoldRush", coords = {0, 1, 264/1024, 840/1024}}, --deepwind gorge
				[607] = {file = "LoadScreenNorthrendBG", coords = {0, 1, 302/1024, 879/1024}}, --strand of the ancients
				[628] = {file = "LOADSCREENISLEOFCONQUEST", coords = {0, 1, 297/1024, 878/1024}}, --isle of conquest
				--[] = {file = "", coords = {0, 1, 0, 0}}, --
			}
			function _detalhes:GetBattlegroundInfo(mapid)
				local battlegroundInfo = _detalhes.battleground_info[mapid]
				if (battlegroundInfo) then
					return battlegroundInfo.file, battlegroundInfo.coords
				end
			end

		--tokenid
			_detalhes.TokenID = {
				["SPELL_PERIODIC_DAMAGE"] = 1,
				["SPELL_EXTRA_ATTACKS"] = 2,
				["SPELL_DAMAGE"] = 3,
				["SPELL_BUILDING_DAMAGE"] = 4,
				["SWING_DAMAGE"] = 5,
				["RANGE_DAMAGE"] = 6,
				["DAMAGE_SHIELD"] = 7,
				["DAMAGE_SPLIT"] = 8,
				["RANGE_MISSED"] = 9,
				["SWING_MISSED"] = 10,
				["SPELL_MISSED"] = 11,
				["SPELL_PERIODIC_MISSED"] = 12,
				["SPELL_BUILDING_MISSED"] = 13,
				["DAMAGE_SHIELD_MISSED"] = 14,
				["ENVIRONMENTAL_DAMAGE"] = 15,
				["SPELL_HEAL"] = 16,
				["SPELL_PERIODIC_HEAL"] = 17,
				["SPELL_HEAL_ABSORBED"] = 18,
				["SPELL_ABSORBED"] = 19,
				["SPELL_AURA_APPLIED"] = 20,
				["SPELL_AURA_REMOVED"] = 21,
				["SPELL_AURA_REFRESH"] = 22,
				["SPELL_AURA_APPLIED_DOSE"] = 23,
				["SPELL_ENERGIZE"] = 24,
				["SPELL_PERIODIC_ENERGIZE"] = 25,
				["SPELL_CAST_SUCCESS"] = 26,
				["SPELL_DISPEL"] = 27,
				["SPELL_STOLEN"] = 28,
				["SPELL_AURA_BROKEN"] = 29,
				["SPELL_AURA_BROKEN_SPELL"] = 30,
				["SPELL_RESURRECT"] = 31,
				["SPELL_INTERRUPT"] = 32,
				["UNIT_DIED"] = 33,
				["UNIT_DESTROYED"] = 34,
			}

		--armazena instancias inativas
			_detalhes.unused_instances = {}
			_detalhes.default_skin_to_use = "Minimalistic"
			_detalhes.instance_title_text_timer = {}
		--player detail skin
			_detalhes.playerdetailwindow_skins = {}

		_detalhes.BitfieldSwapDebuffsIDs = {265646, 272407, 269691, 273401, 269131, 260900, 260926, 284995, 292826, 311367, 310567, 308996, 307832, 327414, 337253,
											36797, 37122, 362397}
		_detalhes.BitfieldSwapDebuffsSpellIDs = {
			[360418] = true
		}

		--auto run code
		_detalhes.RunCodeTypes = {
			{Name = "On Initialization", Desc = "Run code when Details! initialize or when a profile is changed.", Value = 1, ProfileKey = "on_init"},
			{Name = "On Zone Changed", Desc = "Run code when the zone where the player is in has changed (e.g. entered in a raid).", Value = 2, ProfileKey = "on_zonechanged"},
			{Name = "On Enter Combat", Desc = "Run code when the player enters in combat.", Value = 3, ProfileKey = "on_entercombat"},
			{Name = "On Leave Combat", Desc = "Run code when the player left combat.", Value = 4, ProfileKey = "on_leavecombat"},
			{Name = "On Spec Change", Desc = "Run code when the player has changed its specialization.", Value = 5, ProfileKey = "on_specchanged"},
			{Name = "On Enter/Leave Group", Desc = "Run code when the player has entered or left a party or raid group.", Value = 6, ProfileKey = "on_groupchange"},
		}

		--run a function without stopping the execution in case of an error
		function Details.SafeRun(func, executionName, ...)
			local runToCompletion, errorText = pcall(func, ...)
			if (not runToCompletion) then
				if (Details.debug) then
					Details:Msg("Safe run failed:", executionName, errorText)
				end
				return false
			end
			return true
		end

		--tooltip
			_detalhes.tooltip_backdrop = {
				bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]],
				edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
				tile = true,
				edgeSize = 16,
				tileSize = 16,
				insets = {left = 3, right = 3, top = 4, bottom = 4}
			}
			_detalhes.tooltip_border_color = {1, 1, 1, 1}
			_detalhes.tooltip_spell_icon = {file = [[Interface\CHARACTERFRAME\UI-StateIcon]], coords = {36/64, 58/64, 7/64, 26/64}}
			_detalhes.tooltip_target_icon = {file = [[Interface\Addons\Details\images\icons]], coords = {0, 0.03125, 0.126953125, 0.15625}}

		--icons
			_detalhes.attribute_icons = [[Interface\AddOns\Details\images\atributos_icones]]
			function _detalhes:GetAttributeIcon (attribute)
				return _detalhes.attribute_icons, 0.125 * (attribute - 1), 0.125 * attribute, 0, 1
			end

		--colors
			_detalhes.default_backdropcolor = {.094117, .094117, .094117, .8}
			_detalhes.default_backdropbordercolor = {0, 0, 0, 1}

	--Plugins

		--plugin templates

		_detalhes.gump:NewColor("DETAILS_PLUGIN_BUTTONTEXT_COLOR", 0.9999, 0.8196, 0, 1)

		_detalhes.gump:InstallTemplate("button", "DETAILS_PLUGINPANEL_BUTTON_TEMPLATE",
			{
				backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
				backdropcolor = {0, 0, 0, .5},
				backdropbordercolor = {0, 0, 0, .5},
				onentercolor = {0.3, 0.3, 0.3, .5},
			}
		)
		_detalhes.gump:InstallTemplate("button", "DETAILS_PLUGINPANEL_BUTTONSELECTED_TEMPLATE",
			{
				backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
				backdropcolor = {0, 0, 0, .5},
				backdropbordercolor = {1, 1, 0, 1},
				onentercolor = {0.3, 0.3, 0.3, .5},
			}
		)

		_detalhes.gump:InstallTemplate("button", "DETAILS_PLUGIN_BUTTON_TEMPLATE",
			{
				backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
				backdropcolor = {1, 1, 1, .5},
				backdropbordercolor = {0, 0, 0, 1},
				onentercolor = {1, 1, 1, .9},
				textcolor = "DETAILS_PLUGIN_BUTTONTEXT_COLOR",
				textsize = 10,
				width = 120,
				height = 20,
			}
		)
		_detalhes.gump:InstallTemplate("button", "DETAILS_PLUGIN_BUTTONSELECTED_TEMPLATE",
			{
				backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
				backdropcolor = {1, 1, 1, .5},
				backdropbordercolor = {1, .7, 0, 1},
				onentercolor = {1, 1, 1, .9},
				textcolor = "DETAILS_PLUGIN_BUTTONTEXT_COLOR",
				textsize = 10,
				width = 120,
				height = 20,
			}
		)

		_detalhes.gump:InstallTemplate("button", "DETAILS_TAB_BUTTON_TEMPLATE",
			{
				width = 100,
				height = 20,
			},
			"DETAILS_PLUGIN_BUTTON_TEMPLATE"
		)
		_detalhes.gump:InstallTemplate("button","DETAILS_TAB_BUTTONSELECTED_TEMPLATE",
			{
				width = 100,
				height = 20,
			},
			"DETAILS_PLUGIN_BUTTONSELECTED_TEMPLATE"
		)

		_detalhes.PluginsGlobalNames = {}
		_detalhes.PluginsLocalizedNames = {}

		--raid -------------------------------------------------------------------
			--general function for raid mode plugins
				_detalhes.RaidTables = {}
			--menu for raid modes
				_detalhes.RaidTables.Menu = {}
			--plugin objects for raid mode
				_detalhes.RaidTables.Plugins = {}
			--name to plugin object
				_detalhes.RaidTables.NameTable = {}
			--using by
				_detalhes.RaidTables.InstancesInUse = {}
				_detalhes.RaidTables.PluginsInUse = {}

		--solo -------------------------------------------------------------------
			--general functions for solo mode plugins
				_detalhes.SoloTables = {}
			--maintain plugin menu
				_detalhes.SoloTables.Menu = {}
			--plugins objects for solo mode
				_detalhes.SoloTables.Plugins = {}
			--name to plugin object
				_detalhes.SoloTables.NameTable = {}

		--toolbar -------------------------------------------------------------------
			--plugins container
				_detalhes.ToolBar = {}
			--current showing icons
				_detalhes.ToolBar.Shown = {}
				_detalhes.ToolBar.AllButtons = {}
			--plugin objects
				_detalhes.ToolBar.Plugins = {}
			--name to plugin object
				_detalhes.ToolBar.NameTable = {}
				_detalhes.ToolBar.Menu = {}

		--statusbar -------------------------------------------------------------------
			--plugins container
				_detalhes.StatusBar = {}
			--maintain plugin menu
				_detalhes.StatusBar.Menu = {}
			--plugins object
				_detalhes.StatusBar.Plugins = {}
			--name to plugin object
				_detalhes.StatusBar.NameTable = {}

		--constants
		if(DetailsFramework.IsWotLKWow()) then
			--[[global]] DETAILS_HEALTH_POTION_ID = 33447 -- Runic Healing Potion
			--[[global]] DETAILS_HEALTH_POTION2_ID = 41166 -- Runic Healing Injector
			--[[global]] DETAILS_REJU_POTION_ID = 40087 -- Powerful Rejuvenation Potion
			--[[global]] DETAILS_REJU_POTION2_ID = 40077 -- Crazy Alchemist's Potion
			--[[global]] DETAILS_MANA_POTION_ID = 33448 -- Runic Mana Potion
			--[[global]] DETAILS_MANA_POTION2_ID = 42545 -- Runic Mana Injector
			--[[global]] DETAILS_FOCUS_POTION_ID = 307161
			--[[global]] DETAILS_HEALTHSTONE_ID = 47875 --Warlock's Healthstone
			--[[global]] DETAILS_HEALTHSTONE2_ID = 47876 --Warlock's Healthstone (1/2 Talent)
			--[[global]] DETAILS_HEALTHSTONE3_ID = 47877 --Warlock's Healthstone (2/2 Talent)

			--[[global]] DETAILS_INT_POTION_ID = 40212 --Potion of Wild Magic
			--[[global]] DETAILS_AGI_POTION_ID = 40211 --Potion of Speed
			--[[global]] DETAILS_STR_POTION_ID = 307164
			--[[global]] DETAILS_STAMINA_POTION_ID = 40093 --Indestructible Potion
			--[[global]] DETAILS_HEALTH_POTION_LIST = {
					[DETAILS_HEALTH_POTION_ID] = true, -- Runic Healing Potion
					[DETAILS_HEALTH_POTION2_ID] = true, -- Runic Healing Injector
					[DETAILS_HEALTHSTONE_ID] = true, --Warlock's Healthstone
					[DETAILS_HEALTHSTONE2_ID] = true, --Warlock's Healthstone (1/2 Talent)
					[DETAILS_HEALTHSTONE3_ID] = true, --Warlock's Healthstone (2/2 Talent)
					[DETAILS_REJU_POTION_ID] = true, -- Powerful Rejuvenation Potion
					[DETAILS_REJU_POTION2_ID] = true, -- Crazy Alchemist's Potion
					[DETAILS_MANA_POTION_ID] = true, -- Runic Mana Potion
					[DETAILS_MANA_POTION2_ID] = true, -- Runic Mana Injector
				}

		else
			--[[global]] DETAILS_HEALTH_POTION_ID = 307192 -- spiritual healing potion
			--[[global]] DETAILS_HEALTH_POTION2_ID = 359867 --cosmic healing potion
			--[[global]] DETAILS_REJU_POTION_ID = 307194
			--[[global]] DETAILS_MANA_POTION_ID = 307193
			--[[global]] DETAILS_FOCUS_POTION_ID = 307161
			--[[global]] DETAILS_HEALTHSTONE_ID = 6262

			--[[global]] DETAILS_INT_POTION_ID = 307162
			--[[global]] DETAILS_AGI_POTION_ID = 307159
			--[[global]] DETAILS_STR_POTION_ID = 307164
			--[[global]] DETAILS_STAMINA_POTION_ID = 307163
			--[[global]] DETAILS_HEALTH_POTION_LIST = {
					[DETAILS_HEALTH_POTION_ID] = true, --Healing Potion
					[DETAILS_HEALTHSTONE_ID] = true, --Warlock's Healthstone
					[DETAILS_REJU_POTION_ID] = true, --Rejuvenation Potion
					[DETAILS_MANA_POTION_ID] = true, --Mana Potion
					[323436] = true, --Phial of Serenity (from Kyrians)
					[DETAILS_HEALTH_POTION2_ID] = true,
				}
		end

		--[[global]] DETAILS_MODE_GROUP = 2
		--[[global]] DETAILS_MODE_ALL = 3

		_detalhes._detalhes_props = {
			DATA_TYPE_START = 1,	--Something on start
			DATA_TYPE_END = 2,	--Something on end

			MODO_ALONE = 1,	--Solo
			MODO_GROUP = 2,	--Group
			MODO_ALL = 3,		--Everything
			MODO_RAID = 4,	--Raid
		}
		_detalhes.modos = {
			alone = 1, --Solo
			group = 2,	--Group
			all = 3,	--Everything
			raid = 4	--Raid
		}

		_detalhes.divisores = {
			abre = "(",	--open
			fecha = ")",	--close
			colocacao = ". " --dot
		}

		_detalhes.role_texcoord = {
			DAMAGER = "72:130:69:127",
			HEALER = "72:130:2:60",
			TANK = "5:63:69:127",
			NONE = "139:196:69:127",
		}

		_detalhes.role_texcoord_normalized = {
			DAMAGER = {72/256, 130/256, 69/256, 127/256},
			HEALER = {72/256, 130/256, 2/256, 60/256},
			TANK = {5/256, 63/256, 69/256, 127/256},
			NONE = {139/256, 196/256, 69/256, 127/256},
		}

		_detalhes.player_class = {
			["HUNTER"] = true,
			["WARRIOR"] = true,
			["PALADIN"] = true,
			["SHAMAN"] = true,
			["MAGE"] = true,
			["ROGUE"] = true,
			["PRIEST"] = true,
			["WARLOCK"] = true,
			["DRUID"] = true,
			["MONK"] = true,
			["DEATHKNIGHT"] = true,
			["DEMONHUNTER"] = true,
		}
		_detalhes.classstring_to_classid = {
			["WARRIOR"] = 1,
			["PALADIN"] = 2,
			["HUNTER"] = 3,
			["ROGUE"] = 4,
			["PRIEST"] = 5,
			["DEATHKNIGHT"] = 6,
			["SHAMAN"] = 7,
			["MAGE"] = 8,
			["WARLOCK"] = 9,
			["MONK"] = 10,
			["DRUID"] = 11,
			["DEMONHUNTER"] = 12,
		}
		_detalhes.classid_to_classstring = {
			[1] = "WARRIOR",
			[2] = "PALADIN",
			[3] = "HUNTER",
			[4] = "ROGUE",
			[5] = "PRIEST",
			[6] = "DEATHKNIGHT",
			[7] = "SHAMAN",
			[8] = "MAGE",
			[9] = "WARLOCK",
			[10] = "MONK",
			[11] = "DRUID",
			[12] = "DEMONHUNTER",
		}

		local Loc = LibStub("AceLocale-3.0"):GetLocale ("Details")

		_detalhes.segmentos = {
			label = Loc ["STRING_SEGMENT"]..": ",
			overall = Loc ["STRING_TOTAL"],
			overall_standard = Loc ["STRING_OVERALL"],
			current = Loc ["STRING_CURRENT"],
			current_standard = Loc ["STRING_CURRENTFIGHT"],
			past = Loc ["STRING_FIGHTNUMBER"]
		}

		_detalhes._detalhes_props["modo_nome"] = {
				[_detalhes._detalhes_props["MODO_ALONE"]] = Loc ["STRING_MODE_SELF"],
				[_detalhes._detalhes_props["MODO_GROUP"]] = Loc ["STRING_MODE_GROUP"],
				[_detalhes._detalhes_props["MODO_ALL"]] = Loc ["STRING_MODE_ALL"],
				[_detalhes._detalhes_props["MODO_RAID"]] = Loc ["STRING_MODE_RAID"]
		}

		--[[global]] DETAILS_MODE_SOLO = 1
		--[[global]] DETAILS_MODE_RAID = 4
		--[[global]] DETAILS_MODE_GROUP = 2
		--[[global]] DETAILS_MODE_ALL = 3

		_detalhes.icones = {
			--report window
			report = {
					up = "Interface\\FriendsFrame\\UI-Toast-FriendOnlineIcon",
					down = "Interface\\ItemAnimations\\MINIMAP\\TRACKING\\Profession",
					disabled = "Interface\\ItemAnimations\\MINIMAP\\TRACKING\\Profession",
					highlight = nil
				}
		}

		_detalhes.missTypes = {"ABSORB", "BLOCK", "DEFLECT", "DODGE", "EVADE", "IMMUNE", "MISS", "PARRY", "REFLECT", "RESIST"} --do not localize-me


	function Details.SendHighFive()
		Details.users = {{UnitName("player"), GetRealmName(), (Details.userversion or "") .. " (" .. Details.APIVersion .. ")"}}
		Details.sent_highfive = GetTime()
		if (IsInRaid()) then
			Details:SendRaidData(Details.network.ids.HIGHFIVE_REQUEST)
		else
			Details:SendPartyData(Details.network.ids.HIGHFIVE_REQUEST)
		end
	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--frames

	local CreateFrame = CreateFrame --api locals
	local UIParent = UIParent --api locals

	--Info Window
		_detalhes.playerDetailWindow = CreateFrame("Frame", "DetailsPlayerDetailsWindow", UIParent, "BackdropTemplate")
		_detalhes.PlayerDetailsWindow = _detalhes.playerDetailWindow

	--Event Frame
		_detalhes.listener = CreateFrame("Frame", nil, UIParent)
		_detalhes.listener:RegisterEvent("ADDON_LOADED")
		_detalhes.listener:SetFrameStrata("LOW")
		_detalhes.listener:SetFrameLevel(9)
		_detalhes.listener.FrameTime = 0

		_detalhes.overlay_frame = CreateFrame("Frame", nil, UIParent)
		_detalhes.overlay_frame:SetFrameStrata("TOOLTIP")

	--Pet Owner Finder
		CreateFrame("GameTooltip", "DetailsPetOwnerFinder", nil, "GameTooltipTemplate")


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--plugin defaults
	--backdrop
	_detalhes.PluginDefaults = {}

	_detalhes.PluginDefaults.Backdrop = {bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
	edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1,
	insets = {left = 1, right = 1, top = 1, bottom = 1}}
	_detalhes.PluginDefaults.BackdropColor = {0, 0, 0, .6}
	_detalhes.PluginDefaults.BackdropBorderColor = {0, 0, 0, 1}

	function _detalhes.GetPluginDefaultBackdrop()
		return _detalhes.PluginDefaults.Backdrop, _detalhes.PluginDefaults.BackdropColor, _detalhes.PluginDefaults.BackdropBorderColor
	end


------------------------------------------------------------------------------------------
-- welcome panel
	function _detalhes:CreateWelcomePanel(name, parent, width, height, makeMovable)
		local newWelcomePanel = CreateFrame("frame", name, parent or UIParent, "BackdropTemplate")

		DetailsFramework:ApplyStandardBackdrop(newWelcomePanel)
		newWelcomePanel:SetSize(width or 1, height or 1)

		if (makeMovable) then
			newWelcomePanel:SetScript("OnMouseDown", function(self, button)
				if (self.isMoving) then
					return
				end
				if (button == "RightButton") then
					self:Hide()
				else
					self:StartMoving()
					self.isMoving = true
				end
			end)

			newWelcomePanel:SetScript("OnMouseUp", function(self, button)
				if (self.isMoving and button == "LeftButton") then
					self:StopMovingOrSizing()
					self.isMoving = nil
				end
			end)
			newWelcomePanel:SetToplevel(true)
			newWelcomePanel:SetMovable(true)
		end

		return newWelcomePanel
	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--functions

	_detalhes.empty_function = function() end
	_detalhes.empty_table = {}

	--register textures and fonts for shared media
		local SharedMedia = LibStub:GetLibrary ("LibSharedMedia-3.0")
		--default bars
		SharedMedia:Register("statusbar", "Details Hyanda", [[Interface\AddOns\Details\images\bar_hyanda]])

		SharedMedia:Register("statusbar", "Details D'ictum", [[Interface\AddOns\Details\images\bar4]])
		SharedMedia:Register("statusbar", "Details Vidro", [[Interface\AddOns\Details\images\bar4_vidro]])
		SharedMedia:Register("statusbar", "Details D'ictum (reverse)", [[Interface\AddOns\Details\images\bar4_reverse]])

		--flat bars
		SharedMedia:Register("statusbar", "Details Serenity", [[Interface\AddOns\Details\images\bar_serenity]])
		SharedMedia:Register("statusbar", "BantoBar", [[Interface\AddOns\Details\images\BantoBar]])
		SharedMedia:Register("statusbar", "Skyline", [[Interface\AddOns\Details\images\bar_skyline]])
		SharedMedia:Register("statusbar", "WorldState Score", [[Interface\WorldStateFrame\WORLDSTATEFINALSCORE-HIGHLIGHT]])
		SharedMedia:Register("statusbar", "DGround", [[Interface\AddOns\Details\images\bar_background]])
		SharedMedia:Register("statusbar", "Details Flat", [[Interface\AddOns\Details\images\bar_background]])
		SharedMedia:Register("statusbar", "Splitbar", [[Interface\AddOns\Details\images\bar_textures\split_bar]])
		SharedMedia:Register("statusbar", "Details2020", [[Interface\AddOns\Details\images\bar_textures\texture2020]])
		SharedMedia:Register("statusbar", "Left White Gradient", [[Interface\AddOns\Details\images\bar_textures\gradient_white_10percent_left]])

		--window bg and bar order
		SharedMedia:Register("background", "Details Ground", [[Interface\AddOns\Details\images\background]])
		SharedMedia:Register("border", "Details BarBorder 1", [[Interface\AddOns\Details\images\border_1]])
		SharedMedia:Register("border", "Details BarBorder 2", [[Interface\AddOns\Details\images\border_2]])
		SharedMedia:Register("border", "Details BarBorder 3", [[Interface\AddOns\Details\images\border_3]])
		SharedMedia:Register("border", "1 Pixel", [[Interface\Buttons\WHITE8X8]])

		--misc fonts
		SharedMedia:Register("font", "Oswald", [[Interface\Addons\Details\fonts\Oswald-Regular.ttf]])
		SharedMedia:Register("font", "Nueva Std Cond", [[Interface\Addons\Details\fonts\Nueva Std Cond.ttf]])
		SharedMedia:Register("font", "Accidental Presidency", [[Interface\Addons\Details\fonts\Accidental Presidency.ttf]])
		SharedMedia:Register("font", "TrashHand", [[Interface\Addons\Details\fonts\TrashHand.TTF]])
		SharedMedia:Register("font", "Harry P", [[Interface\Addons\Details\fonts\HARRYP__.TTF]])
		SharedMedia:Register("font", "FORCED SQUARE", [[Interface\Addons\Details\fonts\FORCED SQUARE.ttf]])

		SharedMedia:Register("sound", "Details Gun1", [[Interface\Addons\Details\sounds\sound_gun2.ogg]])
		SharedMedia:Register("sound", "Details Gun2", [[Interface\Addons\Details\sounds\sound_gun3.ogg]])
		SharedMedia:Register("sound", "Details Jedi1", [[Interface\Addons\Details\sounds\sound_jedi1.ogg]])
		SharedMedia:Register("sound", "Details Whip1", [[Interface\Addons\Details\sounds\sound_whip1.ogg]])
		SharedMedia:Register("sound", "Details Horn", [[Interface\Addons\Details\sounds\Details Horn.ogg]])

		SharedMedia:Register("sound", "Details Warning", [[Interface\Addons\Details\sounds\Details Warning 100.ogg]])
		--SharedMedia:Register("sound", "Details Warning (Volume 75%)", [[Interface\Addons\Details\sounds\Details Warning 75.ogg]])
		--SharedMedia:Register("sound", "Details Warning Volume 50%", [[Interface\Addons\Details\sounds\Details Warning 50.ogg]])
		--SharedMedia:Register("sound", "Details Warning Volume 25%", [[Interface\Addons\Details\sounds\Details Warning 25.ogg]])




	--dump table contents over chat panel
		function Details.VarDump(t)
			if (type(t) ~= "table") then
				return
			end
			for a,b in pairs(t) do
				print(a,b)
			end
		end

		function dumpt(value) --[[GLOBAL]]
			--check if this is a spellId
			local spellId = tonumber(value)
			if (spellId) then
				local spellInfo = {GetSpellInfo(spellId)}
				if (type(spellInfo[1]) == "string") then
					return Details:Dump(spellInfo)
				end
			end
			return Details:Dump(value)
		end

		function FindSpellByName(spellName) --[[GLOBAL]]
			if (spellName and type(spellName) == "string") then
				local GSI = GetSpellInfo
				local foundSpells = {}
				spellName = spellName:lower()
				for i = 1, 450000 do
					local thisSpellName = GSI(i)
					if (thisSpellName) then
						thisSpellName = thisSpellName:lower()
						if (spellName == thisSpellName) then
							foundSpells[#foundSpells+1] = {GSI(i)}
						end
					end
				end

				if (#foundSpells > 0) then
					dumpt(foundSpells)
				else
					Details:Msg("spell", spellName, "not found.")
				end
			end
		end

	--copies a full table
		function Details.CopyTable(orig)
			local orig_type = type(orig)
			local copy
			if orig_type == 'table' then
				copy = {}
				for orig_key, orig_value in next, orig, nil do
					--print(orig_key, orig_value)
					copy[Details.CopyTable(orig_key)] = Details.CopyTable(orig_value)
				end
			else
				copy = orig
			end
			return copy
		end

	--delay messages
		function _detalhes:DelayMsg(msg)
			_detalhes.delaymsgs = _detalhes.delaymsgs or {}
			_detalhes.delaymsgs[#_detalhes.delaymsgs+1] = msg
		end
		function _detalhes:ShowDelayMsg()
			if (_detalhes.delaymsgs and #_detalhes.delaymsgs > 0) then
				for _, msg in ipairs(_detalhes.delaymsgs) do
					print(msg)
				end
			end
			_detalhes.delaymsgs = {}
		end

	--print messages
		function _detalhes:Msg(str, arg1, arg2, arg3, arg4)
			if (self.__name) then
				print("|cffffaeae" .. self.__name .. "|r |cffcc7c7c(plugin)|r: " .. (str or ""), arg1 or "", arg2 or "", arg3 or "", arg4 or "")
			else
				print(Loc ["STRING_DETAILS1"] .. (str or ""), arg1 or "", arg2 or "", arg3 or "", arg4 or "")
			end
		end

	--welcome
		function _detalhes:WelcomeMsgLogon()
			_detalhes:Msg("you can always reset the addon running the command |cFFFFFF00'/details reinstall'|r if it does fail to load after being updated.")

			function _detalhes:wipe_combat_after_failed_load()
				_detalhes.tabela_historico = _detalhes.historico:NovoHistorico()
				_detalhes.tabela_overall = _detalhes.combate:NovaTabela()
				_detalhes.tabela_vigente = _detalhes.combate:NovaTabela (_, _detalhes.tabela_overall)
				_detalhes.tabela_pets = _detalhes.container_pets:NovoContainer()
				_detalhes:UpdateContainerCombatentes()

				_detalhes_database.tabela_overall = nil
				_detalhes_database.tabela_historico = nil

				_detalhes:Msg("seems failed to load, please type /reload to try again.")
			end

			Details.Schedules.After(5, _detalhes.wipe_combat_after_failed_load)
		end

		Details.failed_to_load = C_Timer.NewTimer(1, function() Details.Schedules.NewTimer(20, _detalhes.WelcomeMsgLogon) end)

	--key binds
	--[=
		--header
			_G ["BINDING_HEADER_Details"] = "Details!"
			_G ["BINDING_HEADER_DETAILS_KEYBIND_SEGMENTCONTROL"] = Loc ["STRING_KEYBIND_SEGMENTCONTROL"]
			_G ["BINDING_HEADER_DETAILS_KEYBIND_SCROLLING"] = Loc ["STRING_KEYBIND_SCROLLING"]
			_G ["BINDING_HEADER_DETAILS_KEYBIND_WINDOW_CONTROL"] = Loc ["STRING_KEYBIND_WINDOW_CONTROL"]
			_G ["BINDING_HEADER_DETAILS_KEYBIND_BOOKMARK"] = Loc ["STRING_KEYBIND_BOOKMARK"]
			_G ["BINDING_HEADER_DETAILS_KEYBIND_REPORT"] = Loc ["STRING_KEYBIND_WINDOW_REPORT_HEADER"]

		--keys

			_G ["BINDING_NAME_DETAILS_TOGGLE_ALL"] = Loc ["STRING_KEYBIND_TOGGLE_WINDOWS"]

			_G ["BINDING_NAME_DETAILS_RESET_SEGMENTS"] = Loc ["STRING_KEYBIND_RESET_SEGMENTS"]
			_G ["BINDING_NAME_DETAILS_SCROLL_UP"] = Loc ["STRING_KEYBIND_SCROLL_UP"]
			_G ["BINDING_NAME_DETAILS_SCROLL_DOWN"] = Loc ["STRING_KEYBIND_SCROLL_DOWN"]

			_G ["BINDING_NAME_DETAILS_REPORT_WINDOW1"] = format(Loc ["STRING_KEYBIND_WINDOW_REPORT"], 1)
			_G ["BINDING_NAME_DETAILS_REPORT_WINDOW2"] = format(Loc ["STRING_KEYBIND_WINDOW_REPORT"], 2)

			_G ["BINDING_NAME_DETAILS_TOOGGLE_WINDOW1"] = format(Loc ["STRING_KEYBIND_TOGGLE_WINDOW"], 1)
			_G ["BINDING_NAME_DETAILS_TOOGGLE_WINDOW2"] = format(Loc ["STRING_KEYBIND_TOGGLE_WINDOW"], 2)
			_G ["BINDING_NAME_DETAILS_TOOGGLE_WINDOW3"] = format(Loc ["STRING_KEYBIND_TOGGLE_WINDOW"], 3)
			_G ["BINDING_NAME_DETAILS_TOOGGLE_WINDOW4"] = format(Loc ["STRING_KEYBIND_TOGGLE_WINDOW"], 4)
			_G ["BINDING_NAME_DETAILS_TOOGGLE_WINDOW5"] = format(Loc ["STRING_KEYBIND_TOGGLE_WINDOW"], 5)

			_G ["BINDING_NAME_DETAILS_BOOKMARK1"] = format(Loc ["STRING_KEYBIND_BOOKMARK_NUMBER"], 1)
			_G ["BINDING_NAME_DETAILS_BOOKMARK2"] = format(Loc ["STRING_KEYBIND_BOOKMARK_NUMBER"], 2)
			_G ["BINDING_NAME_DETAILS_BOOKMARK3"] = format(Loc ["STRING_KEYBIND_BOOKMARK_NUMBER"], 3)
			_G ["BINDING_NAME_DETAILS_BOOKMARK4"] = format(Loc ["STRING_KEYBIND_BOOKMARK_NUMBER"], 4)
			_G ["BINDING_NAME_DETAILS_BOOKMARK5"] = format(Loc ["STRING_KEYBIND_BOOKMARK_NUMBER"], 5)
			_G ["BINDING_NAME_DETAILS_BOOKMARK6"] = format(Loc ["STRING_KEYBIND_BOOKMARK_NUMBER"], 6)
			_G ["BINDING_NAME_DETAILS_BOOKMARK7"] = format(Loc ["STRING_KEYBIND_BOOKMARK_NUMBER"], 7)
			_G ["BINDING_NAME_DETAILS_BOOKMARK8"] = format(Loc ["STRING_KEYBIND_BOOKMARK_NUMBER"], 8)
			_G ["BINDING_NAME_DETAILS_BOOKMARK9"] = format(Loc ["STRING_KEYBIND_BOOKMARK_NUMBER"], 9)
			_G ["BINDING_NAME_DETAILS_BOOKMARK10"] = format(Loc ["STRING_KEYBIND_BOOKMARK_NUMBER"], 10)
	--]=]

end

if (select(4, GetBuildInfo()) >= 100000) then
	local f = CreateFrame("frame")
	f:RegisterEvent("ADDON_ACTION_FORBIDDEN")
	f:SetScript("OnEvent", function()
		local text = StaticPopup1 and StaticPopup1.text and StaticPopup1.text:GetText()
		if (text and text:find("Details")) then
			--fix false-positive taints that are being attributed to random addons
			StaticPopup1.button2:Click()
		end
	end)
end
