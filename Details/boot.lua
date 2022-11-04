-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--global name declaration

		_ = nil
		_G._detalhes = LibStub("AceAddon-3.0"):NewAddon("_detalhes", "AceTimer-3.0", "AceComm-3.0", "AceSerializer-3.0", "NickTag-1.0")

		local version, build, date, tocversion = GetBuildInfo()

		_detalhes.build_counter = 10259
		_detalhes.alpha_build_counter = 10259 --if this is higher than the regular counter, use it instead
		_detalhes.dont_open_news = true
		_detalhes.game_version = version
		_detalhes.userversion = version .. " " .. _detalhes.build_counter
		_detalhes.realversion = 146 --core version, this is used to check API version for scripts and plugins (see alias below)
		_detalhes.APIVersion = _detalhes.realversion --core version
		_detalhes.version = _detalhes.userversion .. " (core " .. _detalhes.realversion .. ")" --simple stirng to show to players

		_detalhes.acounter = 1 --in case of a second release with the same .build_counter
		_detalhes.curseforgeVersion = GetAddOnMetadata("Details", "Version")

		function _detalhes:GetCoreVersion()
			return _detalhes.realversion
		end

		_detalhes.BFACORE = 131 --core version on BFA launch
		_detalhes.SHADOWLANDSCORE = 143 --core version on Shadowlands launch

		Details = _detalhes

		local gameVersionPrefix = "Unknown Game Version - You're probably using a Details! not compatible with this version of the Game"
		--these are the game versions currently compatible with this Details! versions
		if (DetailsFramework.IsWotLKWow() or DetailsFramework.IsShadowlandsWow() or DetailsFramework.IsDragonflight()) then
			gameVersionPrefix = "WD"
		end

		Details.gameVersionPrefix = gameVersionPrefix

		function Details.GetVersionString()
			local curseforgeVersion = _detalhes.curseforgeVersion or ""
			local alphaId = curseforgeVersion:match("%-(%d+)%-")

			if (not alphaId) then
				--this is a release version
				alphaId = "R1"
			else
				alphaId = "A" .. alphaId
			end
			
			return Details.gameVersionPrefix .. Details.build_counter .. "." .. Details.acounter .. "." .. alphaId .. "(" .. Details.game_version .. ")"
		end

		--namespace for the player breakdown window
		Details.PlayerBreakdown = {}


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--initialization stuff
local _

do
	local _detalhes = _G._detalhes

	_detalhes.resize_debug = {}

	local Loc = _G.LibStub("AceLocale-3.0"):GetLocale( "Details" )

	--[=[
	- 
	- 
	- this is an empty comment section
	- 
	- 
	--]=]

	local news = {
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

		{"v9.2.0.9814.146", "May 15th, 2022"},
		"Added slash command /keystone, this command show keystones of other users with addons using Open Raid library.",
		"Added a second Title Bar (disabled by default), is recomended to make the Skin Color (under Window Body) full transparent while using it.",
		"Added Overlay Texture and Color options under Bars: General.",
		"Added Wallpaper Alignment 'Full Body', this alignment make the wallpaper fill over the title bar.",
		"Added Auto Alignment for 'Aligned Text Columns', this option is enabled by default.",
		"Added 'Window Area Border' and 'Row Area Border' under 'Window Body' section in the options panel.",
		"Added an option to color the Row Border by player class.",
		"Added new automation auto hide option: Arena.",
		"Blizzard Death Recap kill ability only shows on Dungeons and Raids now.",
		"Fixed an issue where player names was overlapping damage numbers with enbaled 'Aligned Text Columns'.",
		"Fixed a bug on 'DeathLog Min Healing' option where it was reseting to 1 on each logon.",
		"Fixed several bugs with 'Bar Orientation: Right to Left' (fix by Flamanis).",
		"Fixed an error on Vanguard plugin.",
		"Fixed Spec Icons 'Specialization Alpha' offseted by 2 pixels to the right.",

		{"v9.2.0.9778.146", "April 26th, 2022"},
		--"A cooldown tracker experiment has been added, its options is visible at the Options Panel.",
		"Added a search box in the '/details scroll' feature.",
		"When using Details! Death Recap, a message is now printed to chat showing what killed you accordingly to Blizzard Death Recap.",
		"Fixed some errors while using Mind Control on an arena match.",
		"Fixed encounter phase detection while using voice packs for boss mods addons.",
		"Fixed an error after killing a boss encounter on heroic dificulty for the first time.",
		"Fixed the issue of skins installed after the window has been loaded and the skin was not found at that time.",
		"API: added 'UNIT_SPEC' and 'UNIT_TALENTS' event to details! event listener.",
		"API: added Details:GetUnitId(unitName) which return the unitId for a given player name.",

		{"v9.2.0.9735.146", "April 8th, 2022"},
		"Arena Enemy Player deaths has been greatly improved on this version.",
		"Added M+ Score into the player info tooltip (hover over the spec icon).",
		"Fixed windows ungrouping after a /reload (fix by Flamanis).",
		"Opening a tooltip from a bar or a menu in the title bar will close the All Displays Panel (from right clicking the title bar).",
		"[TBC] fixed an error given by users using old versions of Details! in the raid.",

		{"v9.2.0.9715.146", "March 6th, 2022"},
		"More Tiny Threat fixes and implementations (by Treeston)",
		"Fixed Chinese and Taiwan 'Thousand' abbreviation letter (fix by github user Maioro).",

		{"v9.2.0.9699.146", "March 4th, 2022"},
		"Align Text Columns now have a warning at the bracket and separators option",
		"Silence from interrupts shall be counted as a crowd control.",
		"More phrases in the options panel has been added to translation.",
		"A revamp has beed started on the erase data prompt.",

		{"v9.2.0.9696.146", "February 24th, 2022"},
		"Fixed DPS display when using Aligned Text Columns.",
		"Fixed percent showing even it's disabled when using Aligned Text Columns.",

		{"v9.2.0.9255.146", "February 22th, 2022"},
		"Added Cosmic Healing Potion to script 'Health Potion & Stone'.",

		{"v9.1.5.9213.146", "February 15th, 2022"},
		"Added an option to change your own bar color.",
		"Added 'Ignore this Npc' into the Npc list under the spell list section.",
		"Bookmark window now uses the same scale than the options panel.",
		"Class Color window now uses the same scale than the options panel.",
		"If not casted on the player itself Power Infusion now shows in the buff list of the target.",
		"Allowed nicknames on custom displays (by Flamanis).",
		"Aligned Text Columns enabled is now default for new installs.",
		"Fodder to the flames DH ability won't count damage done by the player on the add summoned.",
		"Fixed the load time for the Npc Ids panel on the spell list section.",
		"Fixed all issues with the options panel scale.",
		"Fixed tooltips overlap when the window is positioned at the top of the screen (fix by Flamanis).",
		"Fixed auto hide windows which wasn't saving its group when unhiding (fix by Flamanis).",
		"Fixed some XML Headers which was giving errors on loading (fix by github user h0tw1r3).",
		"Fixed '/details me' on TBC, which wasn't working correctly (fix by github user Baugstein).",
		"Fixed a typo on Vanguard plugin (fix by github user cruzerthebruzer).",
		"Fixed font 'NuevaStd' where something the font didn't work at all.",
		"Fixed an issue where for some characters the options panel won't open showing an error in the chat instead.",
		"New API: combat:GetPlayerDeaths(deadPlayerName).",
		"New API: Details:ShowDeathTooltip(combatObject, deathTable) for Cooltip tooltips.",

		{"v9.1.5.9213.145", "December 9th, 2021"},
		"Fixed an issue where after reloading, overall data won't show the players nickname.",
		"Fixed overkill damage on death log tooltip.",
		"Fixed the percent bars for the healing done target on the player breakdown window.",
		"Fixed an issue with resource tooltips.",

		{"v9.1.5.9108.145", "November 02th, 2021"},
		"Necrotic Wake: weapons damage does not count anymore for the player which uses it.",
		"Necrotic Wake: a new 'fake player' is shown showing the damage done of all weapons during combat.",
		"Necrotic Wake: these npcs now does not award damage done to players anymore: Brittlebone Mage, Brittlebone Warrior, Brittlebone Crossbowman",
		"The Other Side: the npc Volatile Memory does not award anymore damage to players.",
		"Plaguefall: the npcs Fungret Shroomtender and Plaguebound Fallen does not award anymore damage to players.",
		"Sanguine Affix: the amount of healing done by sanguine pools now shows on all segments (was shown only in the overall).",
		"Tiny Threat (plugin): fixed an issue when hidding the pull aggro bar makes the first line be invisible.",
		"Statistics: fixed several small bugs with guild statistics (/details stats).",
		"Scale slider (top left slider shown on panels) are now more responsible.",

		{"v9.1.0.8888.145", "October 7th, 2021"},
		"Search has been added into the options panel",
		"Improvements on overkill amount of damage",
		"Fonts 'Oswald' and 'NuevaStd' enabled again.",
		"Added critical hits to Death Log (by C. Raethke)",
		"Added settings to change the color on death log, they are within the class colors panel.",
		"Don't show TaintWarning frame if MiniMapBattlefieldFrame is hidden (by Flamanis).",

		{"v9.1.0.8812.145", "September 5th, 2021"},
		"Fonts 'Oswald' and 'NuevaStd' disabled due to some erros on the client side.",
		"Death Knight adds now include the icon of the spell whose summoned them.",
		"Fixes and improvements on the backend of the addon.",

		{"v9.1.0.8782.145", "August 11th, 2021"},
		"Clicking on the minimap while the options panel is open will close it.",
		"Fixed Raid Check plugin position when the window is anchored at the top of the monitor.",
		"Shadow priest Void Erruption spells got merged into only one.",
		"Added settings to adjust the scale or font size of the title bar menu (right click): /run Details.all_switch_config.font_size = 12; /run Details.all_switch_config.scale = 1.0;",
		"Added transliteration to healing done.",
		"Tiny Threat (plugin): added options to Hide the Pull Bar and Use Focus Target.",

		{"v9.0.5.8637.144", "June 22nd, 2021"},
		"Major update on Vanguard plugin.",
		"Added utility module to Coach, this module will send interrupt, dispel, cc breaks, cooldown usege and battle resses to the Coach.",
		"Added plugins into the title bar display menu.",

		{"v9.0.5.8502.144", "May 21th, 2021"},
		"Added options to change the color of each team during an arena match.",
		"Fixed One Segment Battleground.",
		"Fixed an error with Howl of Terror on Demo Warlocks.",

		{"v9.0.5.8501.144", "May 17th, 2021"},
		"Complete overhaul and rerritten on Fade In and Out animations, this should fix all bugs related to animations not being consistent.",
		"Complete overhaul on the broadcaster tool for arenas 'Current DPS'. It shows now a bar indicating the dps of both teams.",
		"Yellow arena team now has purple color.",
		"Several updates on the combat log engine and bug fixes.",

		{"v9.0.5.8357.144", "March 15th, 2021"},
		"Max amount of segments raised to 40, was 30.",
		"Added a 'Sanguine Heal' actor to show how much the void zone healed enemies, shown on Everything mode.",
		"Death events are now ignore after the necrolord triggers Forgeborne Reveries.",
		"Mythic dungeon settings are reset after importing a profile.",
		"Scripts now support Inline text feature.",
		"Fixed a rare bug when exporting a profile would result into a bug.",
		"Fixed an issue with Spirit Shell overhealing.",
		"Fixed a rare bug on dispel toooltips giving errors.",
		"Fixed a bug on exporting scripts.",
		"Fixed an error given when an a battleground opponent die.",
		"Fixed an issue where sometimes entering an arena cause errors.",
		"Fixed some issues with pet detection.",

		{"v9.0.2.8246.144", "February 17th, 2021"},
		"Added healing done to Coach feature (in testing).",
		"Ignore Forgeborne Reveries healing done (Necrolords ability).",
		"Arena enemy deaths now are shown in the Deaths display.",
		"Guild statistics data has been wiped, this system had a major improvement overall.",
		"Fixed 'Clear Overall Data' on Logout which wasn't clearing.",

		{"v9.0.2.8192.144", "January 27th, 2021"},
		"If you get issues with nicknames, disable any weakaura which modifies this feature.",
		"Advanced Death Logs plugin got some fixes and should work properly.",
		"Added the word 'Overall' at the end of the title bar text when the segment is overall.",
		"Added covenant and durability into the Raid Check plugin.",
		"Added API Window:SetTitleBarText(text) and Window:GetTitleBarText().",
		"Fixed some issues where Details! printed 'combat start time not found.'",
		"Fixed damage per Phase.",
		"Fixed resizing window with no background error.",
		"Fixed 'Always Show player' on ascending sort direction.",
		"Added more foods into the Ready Check plugin.",
		"Fixed some issues with the coach fearure.",

		{"v9.0.2.8154.144", "January 14th, 2021"},
		"Added total damage bars into the player list in the Breakdown window.",
		"Added 'Square' or 'Roll' mode to Details! Streamer plugin, to change the statusbar mode to Squares, visit the options panel for the plugin.",
		"Added Binding Shot to crowd control (Hunter)",
		"Merged all whirlwind damage (Warrior).",
		"Fixed errors on the 1-10 tutorial levels while playing Demon Hunters.",
		"Fixed some cases of DeathLog not showing healing",
		"Fixed windows making a group after '/details toggle', while the option to not make groups enabled.",
		"Fixed some issues with the custom display 'Potion Used' and 'Health Potion & Stone'.",
		"Fixed the breakdown window where using the comparisson tab sometimes made the frame to overlap with the aura tab.",

		{"v9.0.2.8001.144", "December 19th, 2020"},
		"Added Details! Coach as a new experimental feature, you may want to test using /details coach",
		"Coach feature allows the raid leader to stay outside the raid while seeing in real time player deaths and damage information.",
		"Fixed issues with some raid encounters in Castle Nathria.",
		"Druid Kyrian Spirits ability now has some rules to credit the druid for damage and heal.",
		"Several small bug fixes has been done.",

		{"v9.0.1.8001.144", "November 30rd, 2020"},
		"Added back the report to bnet friend.",
		"@Flamanis: fixed issues on custom displays.",

		{"v9.0.1.7950.144", "November 3rd, 2020"},
		"Added the baseline for the Coach feature, for testing use '/details coach', all users in the raid must have details! up to date.",
		"Added container_spells:GetOrCreateSpell(id, shouldCreate, token).",
		"Added Details:GetRaidLeader(), return the RL name.",
		"Fixed Tiny Threat not showing threat.",
		"Fixed annoucement interrupt enable toggle checkbox was reseting on logon.",

		{"v9.0.1.7938.142", "October 29th, 2020"},
		"Added option to select the icon buttons in the title bar.",

		{"v9.0.1.7739.142", "August 18th, 2020"},
		"More development on the new plugin Cast Timeline.",
		"More development on Details! Scroll Damage.",
		"Added options to opt-out show pets on solo play.",
		"Added back Profiles and Plugins into the options panel.",
		"Many framework fixes from retail ported to shadowlands.",
		{"v9.0.1.7721.142", "August 14th, 2020"},
		"Encounter time in the title bar got new code and might work now for some people that had issues with it.",
		"Fixed an error with the Welcome Window showing errors.",
		"Statusbar got fixed, it should now show it's widgets normally.",
		"Alignment for the title bar text also got fixed.",
		{"v9.0.1.7707.142", "August 11th, 2020"},
		"While in The Concil of Blood, Details! now deletes the damage done to alive bosses when one of them dies. This condition can be turned off with /run Details.exp90temp.delete_damage_TCOB = false",
		"Many Important Npcs like Jaina and Thrall shows as group members of your group.",
		"More progress on the options panel overhaul.",
		"General bug fixes.",
		{"v9.0.1.7590.142", "July 31th, 2020"},
		"New options panel in progress",
		"Added options for the 'Inline' right texts in the window",
		"General round of fixes",
		{"v9.0.1.7544.142", "July 25th, 2020"},
		"Changed texts alignment to be parallel.",
		"Changed icons to white color.",
		"Added player list on the Player Breakdown Window.",
		"Added a new plugin: 'Cast Timeline' available at the Player Breakdown Window.",
		"Added macro '/Details me' to open your Breakdown Window.",
	}

	local newsString = "|cFFF1F1F1"

	for i = 1, #news do
		local line = news[i]
		if (type(line) == "table")  then
			local version = line[1]
			local date = line[2]
			newsString = newsString .. "|cFFFFFF00" .. version .. " (|cFFFF8800" .. date .. "|r):|r\n\n"
		else
			newsString = newsString .. "|cFFFFFF00-|r " .. line .. "\n\n"
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

		SharedMedia:Register("sound", "d_gun1", [[Interface\Addons\Details\sounds\sound_gun2.ogg]])
		SharedMedia:Register("sound", "d_gun2", [[Interface\Addons\Details\sounds\sound_gun3.ogg]])
		SharedMedia:Register("sound", "d_jedi1", [[Interface\Addons\Details\sounds\sound_jedi1.ogg]])
		SharedMedia:Register("sound", "d_whip1", [[Interface\Addons\Details\sounds\sound_whip1.ogg]])

		SharedMedia:Register("sound", "Details Threat Warning Volume 1", [[Interface\Addons\Details\sounds\threat_warning_1.ogg]])
		SharedMedia:Register("sound", "Details Threat Warning Volume 2", [[Interface\Addons\Details\sounds\threat_warning_2.ogg]])
		SharedMedia:Register("sound", "Details Threat Warning Volume 3", [[Interface\Addons\Details\sounds\threat_warning_3.ogg]])
		SharedMedia:Register("sound", "Details Threat Warning Volume 4", [[Interface\Addons\Details\sounds\threat_warning_4.ogg]])




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
			return Details:Dump(value)
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
