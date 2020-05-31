-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> global name declaration
		
		_ = nil
		_detalhes = LibStub("AceAddon-3.0"):NewAddon("_detalhes", "AceTimer-3.0", "AceComm-3.0", "AceSerializer-3.0", "NickTag-1.0")
		
		_detalhes.build_counter = 7334
		_detalhes.alpha_build_counter = 7334 --if this is higher than the regular counter, use it instead
		_detalhes.game_version = "v8.3.0"
		_detalhes.userversion = "v8.3.0." .. _detalhes.build_counter
		_detalhes.realversion = 140 --core version, this is used to check API version for scripts and plugins (see alias below)
		_detalhes.APIVersion = _detalhes.realversion --core version
		_detalhes.version = _detalhes.userversion .. " (core " .. _detalhes.realversion .. ")" --simple stirng to show to players
		
		_detalhes.BFACORE = 131 --core version on BFA launch
		
		Details = _detalhes
		
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> initialization stuff

do 

	--local f = CreateFrame("frame")
	--f:SetSize(300, 300)
	--f:SetPoint("center", UIParent, 0, 0)
	--f.texture = f:CreateTexture(nil, "overlay")
	--f.texture:SetAllPoints()
	--f.texture:SetTexture(131817)

	local _detalhes = _G._detalhes

	_detalhes.resize_debug = {}

	local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )
	
--[[
|cFFFFFF00v8.3.0.7334.140 (|cFFFFCC00May 30th, 2020|r|cFFFFFF00)|r:\n\n
|cFFFFFF00-|r Spells can now be ignored at /details options > Spell List > All Spells, or just /de spells.\n\n
--]]

	Loc ["STRING_VERSION_LOG"] = "|cFFFFFF00v8.3.0.7334.140 (|cFFFFCC00May 30th, 2020|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Spells can now be ignored at /details options > Spell List > All Spells, or just /de spells.\n\n|cFFFFFF00v8.3.0.7329.140 (|cFFFFCC00May 23rd, 2020|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Added the option to Hide on Battlegrounds at Window: Automation > Auto Hide.\n\n|cFFFFFF00v8.3.0.7325.140 (|cFFFFCC00May 10th, 2020|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Added spell reflection damage (by athei@github).\n\n|cFFFFFF00v8.3.0.7303.140 (|cFFFFCC00April 21th, 2020|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Added npcId ignore list, atm it is accessed by Details.npcid_ignored[npcid] = true.\n\n|cFFFFFF00v8.3.0.7281.140 (|cFFFFCC00February 27th, 2020|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Fixed an issue on Player Details Window where sometimes Death Strike healing done would blink the Rune Weapon healing done.\n\n|cFFFFFF00-|r Segments Locked featured won't work for Overall Data.\n\n|cFFFFFF00-|r Fixed an error while retriving data from the guild (statistics sync).\n\n|cFFFFFF00-|r Added Ny'alotha raid information (by jjholleman@github).\n\n|cFFFFFF00-|r Added Vanish to the list of defensive cooldowns for Rogues (by DylanMeador@github).\n\n|cFFFFFF00-|r Fixed a bug for healing done from unit to unit (by rubenvrolijk@github).\n\n|cFFFFFF00-|r Updated the ToC files for bundled plugins.\n\n|cFFFFFF00-|r Regular Details Framework updates.\n\n|cFFFFFF00v8.3.0.7255.140 (|cFFFFCC00January 20th, 2020|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Fixed Eye of Corruption and Grand Delusions.\n\n|cFFFFFF00v8.3.0.7239.140 (|cFFFFCC00January 06th, 2020|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Healers can now heal training dummies inside cities without being in combat.\n\n|cFFFFFF00-|r Added Shaman's Stormstrike ability to auto merge (consolidate skills feature).\n\n|cFFFFFF00v8.2.5.7224.140 (|cFFFFCC00October 20th, 2019|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Total revamp on '/details users'.\n\n|cFFFFFF00-|r Rewrite on the 'Potion Used' script, it should get all potions from the framework now.\n\n|cFFFFFF00-|r Done a workaround on a rare bug where pet ability isn't found in the game database.\n\n|cFFFFFF00v8.2.0.7172.140 (|cFFFFCC00August 3rd, 2019|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Fixed player detail window showing a blank page after selecting another player when in the comparison tab.\n\n|cFFFFFF00-|r Added information about the Eternal Palace raid, this brings better boss icons, background textures and other things (by GyroJoe).\n\n|cFFFFFF00v8.2.0.7167.140 (|cFFFFCC00July 24th, 2019|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Fixed overkill amount (by nullKomplex).\n\n|cFFFFFF00v8.2.0.7166.140 (|cFFFFCC00July 18th, 2019|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Added new potions, food and flasks. (by nullKomplex).\n\n|cFFFFFF00v8.2.0.7165.140 (|cFFFFCC00July 14th, 2019|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r More 8.2 bug fixes.\n\n|cFFFFFF00v8.2.0.7152.140 (|cFFFFCC00July 7th, 2019|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Fixed some issues with classes showing some wrong icons (by nullKomplex).\n\n|cFFFFFF00v8.2.0.7150.140 (|cFFFFCC00July 2nd, 2019|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Added click through options.\n\n|cFFFFFF00-|r More 8.2 fixes.\n\n|cFFFFFF00v8.1.5.7129.140 (|cFFFFCC00May 2nd, 2019|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Energy redesign: track only the energy generated below the maximum energy amount.\nEnergy generated above the maximum energy now counts as energy 'overflow', this info is in the tooltip.\n\n|cFFFFFF00v8.1.5.7102.139 (|cFFFFCC00April 23rd, 2019|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Added API Details.SegmentPhases() and Details.UnitDamageByPhase() see '/details api' for the full API.\n\n|cFFFFFF00-|r Minor fixes for the mythic version of 'The Restless Cabal' encounter.\n\n|cFFFFFF00v8.1.5.7099.139 (|cFFFFCC00April 16rd, 2019|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Damage and Healing API is ready to be used by scripters, use '/details api' for more information.\n\n|cFFFFFF00v8.1.5.7084.138 (|cFFFFCC00April 9rd, 2019|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Replacing the old API with the new, see /details api.\n\n|cFFFFFF00v8.1.5.7053.138 (|cFFFFCC00April 3rd, 2019|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Fixed the 'Event Tracker' not showing all cooldowns and crowdcontrol.\n\n|cFFFFFF00-|r Added new gradient wallpapers.\n\n|cFFFFFF00v8.1.5.7042.138 (|cFFFFCC00March 23th, 2019|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Added the first batch of functions call for Details API 2.0.\n\n|cFFFFFF00v8.1.0.6923.136 (|cFFFFCC00March 06th, 2019|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Fixed Vamguard plugin not showing debuffs on tanks.\n\n|cFFFFFF00-|r Attempt to fix some plugins loading after details! start and failing to install.\n\n|cFFFFFF00-|r Fixed a bug within Atal'Dazar dungeon where in some cases adds damage where considered friendly fire.\n\n|cFFFFFF00v8.1.0.6902.135 (|cFFFFCC00February 19th, 2019|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Fixed some window gliches with lock, snap and resize buttons.\n\n|cFFFFFF00-|r Fixed issue with the window unlocking after a /reload.\n\n|cFFFFFF00v8.1.0.6861.135 (|cFFFFCC00January 20th, 2019|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Fixed rogue spec icons.\n\n|cFFFFFF00-|r Some visuals improvements.\n\n|cFFFFFF00-|r Added some buttons below the release death recap window, only show in raid after a boss.\n\n|cFFFFFF00v8.1.0.6702.135 (|cFFFFCC00December 31th, 2018|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Streamers/Youtubers the Event Tracker tool has been fixed for 8.1, enjoy!\n\n|cFFFFFF00v8.0.1.6692.135 (|cFFFFCC00December 11th, 2018|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Fixed East Asian myriads showing a giganting non formated number in the total bar DPS.\n\n|cFFFFFF00-|r Added a reset nickname button in the right side of the nickname field.\n\n|cFFFFFF00-|r Framework and NickTag library updates.\n\n|cFFFFFF00v8.0.1.6691.135 (|cFFFFCC00November 23th, 2018|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Experimental: added deaths to overall data during a mythic dungeon run.\n\n|cFFFFFF00-|r Report window revamp: removed report history.\n\n|cFFFFFF00-|r Fixed report tooltip not closing on report button click.\n\n|cFFFFFF00-|r Fixed copy/paste report window.\n\n|cFFFFFF00-|r Time Line (plugin) added enemy cast time line.\n\n|cFFFFFF00v8.0.1.6678.135 (|cFFFFCC00November 07th, 2018|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r New Feature: import and export profiles.\n\n|cFFFFFF00-|r Major improvements on bar text scripts.\n\n|cFFFFFF00-|r Improved import and export custom skins.\n\n|cFFFFFF00-|r Fixed shaman's sundering spell not showing in crowd control.\n\n|cFFFFFF00-|r Fixed sharing guild statistics.\n\n|cFFFFFF00-|r More spells added to spell consolidation: Whirlwind, Fracture, Mutilate.\n\n|cFFFFFF00-|r Monk Mistweaver Blackout Kick now has a indicator when it comes from passive 'Teachings of the Monastery'.\n\n|cFFFFFF00-|r Added slash command '/details debugwindow' for cases when the window isn't shown or are anchored in the wrong place.\n\n|cFFFFFF00-|r Exposed spell ignore table, you can now add spells to be ignored using Details.SpellsToIgnore [spellID] = true.\n\n|cFFFFFF00v8.0.1.6599.135 (|cFFFFCC00October 19th, 2018|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Fixed damage on low level training dummies where it was showing 1 damage for each ability.\n\n|cFFFFFF00-|r Added a line in the tooltip shown when hovering over the spec icon to show non-formated DPS, example: '12.0K' DPS shows '11,985.8'.\n\n|cFFFFFF00-|r Developers: command /run Details:DumpTable() should now show the correct table names with quotation marks if string.\n\n|cFFFFFF00v8.0.1.6553.135 (|cFFFFCC00October 06th, 2018|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Added a 'Macros' section in the options panel.\n\n|cFFFFFF00-|r Updated to BFA 'Potion Used' and 'Health Potion and Stone' custom displays.\n\n|cFFFFFF00-|r Backfire damage from Light of the Martyr now shows on death logs as friendly fire.\n\n|cFFFFFF00-|r Deprecated rules for friendly fire has been removed, this might fix some random issues with mind controlled players in the Lord Stormsong encounter in the Shrine of the Storm dungeon.\n\n|cFFFFFF00-|r Fixed DBM/BigWigs aura creation from the Spell List panel.\n\n|cFFFFFF00-|r Chart scripts now receives the envTable, use local envTable = ... .\n\n|cFFFFFF00-|r Polymorth (Black Cat) and Between the Eyes got added to Crowd Control list.\n\n|cFFFFFF00-|r Fixed Timeline plugin not showing the cooldown panel.\n\n|cFFFFFF00-|r Overall data setting won't reset on every logout.\n\n|cFFFFFF00-|r Slash command '/details merge' won't flag the merged combat as a trash segment anymore.\n\n|cFFFFFF00-|r Added function to use on macros to open the Player Details Window: /script Details:OpenPlayerDetails(1).\n\n|cFFFFFF00-|r Done more improvements on the Death Recap window.\n\n|cFFFFFF00v8.0.1.6449.134 (|cFFFFCC00September 11th, 2018|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Details! is ready for Uldir mythic raiding!.\n\n|cFFFFFF00-|r Several improvements on Encounter Details plugin.\n\n|cFFFFFF00-|r Details! Scroll Damage for training in dummies is now ready for more tests, access it |cFFFFFF00/details scrolldamage|r.\n\n|cFFFFFF00-|r Damage and Healing tooltips now show a statusbar indicating the percent done by the ability.\n\n|cFFFFFF00-|r Added a scale slider  to the options panel.\n\n|cFFFFFF00-|r Added monk's Quaking Palm to crowd control spells.\n\n|cFFFFFF00-|r Fixed an issue with Plater integration.\n\n|cFFFFFF00-|r Fixed tooltips not hiding when the cursor leaves the spell icon in the Damage Taken by Spell.\n\n|cFFFFFF00-|r Framework: fixed an issue with tooltips and menus where the division line wasn't hiding properly.\n\n|cFFFFFF00-|r Framework: fixed some buttons not showing its text in the options panel.\n\n|cFFFFFF00v8.0.1.6272.134 (|cFFFFCC00August 28th, 2018|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Fixed Dynamic Overall Data custom display.\n\n|cFFFFFF00-|r Fixed friendly fire on some dungeon fights with mind control.\n\n|cFFFFFF00-|r Raid Check plugin fully revamped, now shows talents, spec and role.\n\n|cFFFFFF00-|r Updated flask and food list for BFA.\n\n|cFFFFFF00-|r Added NpcID listing at the Spell List window.\n\n|cFFFFFF00-|r Fixed an issue with Alliance or Horde icons showing at random in player bars.\n\n|cFFFFFF00-|r Small revamp in the Death Recap window.\n\n|cFFFFFF00-|r Fixed new segment creation when the option to use only one segment while in a battleground is disabled.\n\n|cFFFFFF00-|r Fixed east asian number format on several strings.\n\n|cFFFFFF00-|r 'Smart Score' option renamed to 'Unique Segment' under the PvP options for battlegrounds.\n\n|cFFFFFF00v8.0.1.6120.132 (|cFFFFCC00August 07th, 2018|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Death Knight: Epidemic, Scourge Strike and Howling Blast now has a better description on the spell name.\n\n|cFFFFFF00-|r Fixed snap button showing when 'Hide Resize Buttons' are enabled.\n\n|cFFFFFF00-|r Fixed title bar icons not hiding when 'Auto Hide Buttons' is enabled.\n\n|cFFFFFF00-|r Several improvements to overall data, it should be more consistent now.\n\n|cFFFFFF00-|r Details! now passes to identify the tank role of the player even when out of a party or raid.\n\n|cFFFFFF00-|r Debug helper /run Details:DumpTable(table) now correctly shows the key name when it isn't a string.\n\n|cFFFFFF00-|r Improvements done on the Bookmark config frame accessed by the options panel > display section.\n\n|cFFFFFF00-|r New slash command: '/details spells'.\n\n|cFFFFFF00-|r Statistics for Legion has been closed! You can access statistics from the orange gear > statistics.\n\n|cFFFFFF00v8.0.1.6027.132 (|cFFFFCC00July 28th, 2018|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Added size offset options for the chat tab embed feature.\n\n|cFFFFFF00-|r Revamp on the editor for the custom line text.\n\n|cFFFFFF00v8.0.1.5985.131 (|cFFFFCC00July 17th, 2018|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Added 'Auto Run Code' module.\n\n|cFFFFFF00-|r Added 'Plater Nameplates' integration.\n\n|cFFFFFF00-|r Weakauras integration with the Create Aura panel got great improvements.\n\n|cFFFFFF00-|r Many options has been renamed or moved from groups for better organization .\n\n|cFFFFFF00-|r Several skins got some revamp for 2018.\n\n|cFFFFFF00-|r Default settings for Arenas and Battlegrounds got changes and the experience should be more smooth now.\n\n|cFFFFFF00v7.3.5.5559.130 (|cFFFFCC00April 13th, 2018|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Added slash commands: /details 'softtoggle' 'softshow' 'softhide'. Use them to manipulate the window visibility while using auto hide.\n\n|cFFFFFF00-|r Mythic dungeon graphic window won't show up if the user leaves the dungeon before completing it.\n\n|cFFFFFF00v7.3.5.5529.130 (|cFFFFCC00April 06th, 2018|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Added minimize button on the mythic dungeon run chart.\n\n|cFFFFFF00-|r Added API calls: Details:ResetSegmentOverallData() and Details:ResetSegmentData().\n\n|cFFFFFF00v7.3.5.5499.130 (|cFFFFCC00Mar 30th, 2018|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Added outline option for the right text.\n\n|cFFFFFF00v7.3.5.5469.130 (|cFFFFCC00Mar 23th, 2018|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Fixed a few things on the mythic dungeon chart.\n\n|cFFFFFF00v7.3.5.5424.129 (|cFFFFCC00Mar 10th, 2018|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Added macro support to open plugins. Example:\n /run Details:OpenPlugin ('Time Line')\n\n|cFFFFFF00v7.3.5.5351.129 (|cFFFFCC00Feb 26rd, 2018|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Added a damage chart for mythic dungeon runs, it shows at the of the run. You may disable it at the Streamer Settings.\n\n|cFFFFFF00v7.3.5.5231.128 (|cFFFFCC00Feb 02nd, 2018|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Fixed an issue with wasted shield absorbs where the wasted amount was subtracting the total healing done.\n\n|cFFFFFF00v7.3.5.5221.128 (|cFFFFCC00Jan 26th, 2018|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Warlock mana from Life Tap won't show up any more under mana regen, this makes easy to see Soul Shard gain.\n\n|cFFFFFF00v7.3.2.5183.128 (|cFFFFCC00Jan 12th, 2018|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r The new bar animation is now applied to all users by default.\n\n|cFFFFFF00-|r Fixed an issue with the threat plugin where sometimes it was triggering errors.\n\n|cFFFFFF00v7.3.2.5175.128 (|cFFFFCC00Jan 03rd, 2018|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r ElvUI skins should have now a more good looking scrollbar.\n\n|cFFFFFF00-|r When starting to edit a custom display, the code window now clear the code from the previous display.\n\n|cFFFFFF00v7.3.2.5154.128 (|cFFFFCC00Dec 22th, 2017|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r API and Create Aura windows are now attached to the new plugin window.\n\n|cFFFFFF00v7.3.2.5101.128 (|cFFFFCC00Dec 15th, 2017|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Moving the custom display window to the new plugins window.\n\n|cFFFFFF00-|r Major layout changes on the Encounter Details plugin window.\n\n|cFFFFFF00v7.3.2.4919.128 (|cFFFFCC00Dec 08th, 2017|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Fixed an issue with the statistics sharing among guild members.\n\n|cFFFFFF00-|r Fixed an issue with Argus encounter where two segments were created.\n\n|cFFFFFF00-|r Fixed aura type images on the Create Aura Panel.\n\n|cFFFFFF00-|r Create Aura Panel can now be closed with Right Click.\n\n|cFFFFFF00-|r Framework updated to r60, plugins should be more stable now.\n\n|cFFFFFF00v7.3.0.4830.126 (|cFFFFFF00v7.3.2.4836.126 (|cFFFFCC00Nov 21th, 2017|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Removed some tutorial windows popups.\n\n|cFFFFCC00Oct 21th, 2017|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Fixed opening windows when streamer settings > no alerts is enabled.\n\n|cFFFFFF00v7.3.0.4823.126 (|cFFFFCC00Oct 09th, 2017|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Added new options section: Streamer Settings, focused on adjustments for streamers and youtubers.\n\n|cFFFFFF00-|r Animations now always run at the same speed regardless the framerate.\n\n|cFFFFFF00-|r Click-To-Open menus now close the menu if the menu is already open.\n\n|cFFFFFF00v7.3.0.4723.126 (|cFFFFCC00Set 22th, 2017|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Fixed overall dungeon segments being added to overall data.\n\n|cFFFFFF00v7.3.0.4705.126 (|cFFFFCC00Set 19th, 2017|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Fixed damage taken tooltip for Brewmaster Monk where sometimes the tooltip didn't open.\n\n|cFFFFFF00-|r Fixed overall data on mythic dungeon not adding trash segments even with the option enabled on the options panel.\n\n|cFFFFFF00-|r Fixed the guild selection dropdown reseting everytime the Guild Rank window is opened.\n\n|cFFFFFF00v7.3.0.4677.126 (|cFFFFCC00Set 10th, 2017|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r During mythic dungeons, the trash segments will be merged into a new segment at the end of the boss encounter (instead of merging on the fly while cleaning up).\n\n|cFFFFFF00v7.3.0.4615.125 (|cFFFFCC00Set 09th, 2017|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Setting up the dungeon stuff as opt-in for early adopters while we continue to make improvements on the system.\n\n|cFFFFFF00v7.3.0.4586.125 (|cFFFFCC00Set 08th, 2017|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Formating mythic+ dungeon segments, each segment should count the boss trash + boss fight.\n\n|cFFFFFF00-|r At the end of the mythic+ dungeon, it should create a new segment adding up all segments described above.\n\n|cFFFFFF00v7.3.0.4499.124 (|cFFFFCC00Set 05th, 2017|r|cFFFFFF00)|r:\n\n|cFFFFFF00-|r Added an option to always show all players when using the standard mode. Option under PvP/PvE bracket on the options panel.\n\n|cFFFFFF00-|r Added a setting to exclude healing done lines from the death log below a certain healing amount. This options is also under PvP/PvE bracket.\n\n|cFFFFFF00-|r Fixed the guild selection on the ranking panel."
	Loc ["STRING_DETAILS1"] = "|cffffaeaeDetails!:|r "

	--> startup
		_detalhes.initializing = true
		_detalhes.enabled = true
		_detalhes.__index = _detalhes
		_detalhes._tempo = time()
		_detalhes.debug = false
		_detalhes.debug_chr = false
		_detalhes.opened_windows = 0
		_detalhes.last_combat_time = 0
		
	--> containers
		--> armazenas as fun��es do parser - All parse functions 
			_detalhes.parser = {}
			_detalhes.parser_functions = {}
			_detalhes.parser_frame = CreateFrame ("Frame")
			_detalhes.pvp_parser_frame = CreateFrame ("Frame")
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
			
		--> quais raides devem ser guardadas no hist�rico
			_detalhes.InstancesToStoreData = { --> mapIDs
				[2070] = true, --Battle for Dazaralor (BFA) GetInstanceInfo
				[1148] = true, --Uldir (BFA) uiMapID
				[1861] = true, --Uldir (BFA) from GetInstanceInfo
				[2164] = true, --Eternal Palace

				[2217] = true, --8.3
			}
			
			--must fail in map and encounter id to not store data
			_detalhes.EncountersToStoreData = { --> encounterIDs
				--CLEU
				[2144] = 1, --Taloc - Taloc
				[2141] = 2, --MOTHER - MOTHER
				[2128] = 3, --Fetid Devourer - Fetid Devourer
				[2136] = 4, --Zek'voz - Zek'voz, Herald of N'zoth
				[2134] = 5, --Vectis - Vectis
				[2145] = 6, --Zul - Zul, Reborn
				[2135] = 7, --Mythrax the Unraveler - Mythrax the Unraveler
				[2122] = 8, --G'huun - G'huun
				
				[2265] = 1, --Champion of the Light
				[2263] = 2, --Grong, the Jungle Lord
				[2266] = 3, --Jadefire Masters
				[2271] = 4, --Opulence
				[2268] = 5, --Conclave of the Chosen
				[2272] = 6, --King Rastakhan
				[2276] = 7, --High Tinker Mekkatorque
				[2280] = 8, --Stormwall Blockade
				[2281] = 9, --Lady Jaina Proudmoore
				
				[2269] = 1, --The Restless Cabal
				[2273] = 2, --Uu'nat, Harbinger of the Void
				
				[2298] = 1, --Abyssal Commander Sivara
				[2289] = 2, --Blackwater Behemoth
				[2305] = 3, --Radiance of Azshara
				[2304] = 4, --Lady Ashvane
				[2303] = 5, --Orgozoa
				[2311] = 6, --The Queen's Court
				[2293] = 7, --Za'qul, Harbinger of Ny'alotha
				[2299] = 8, --Queen Azshara
				
				--EJID
				[2168] = 1, --Taloc
				[2167] = 2, --MOTHER
				[2146] = 3, --Fetid Devourer
				[2169] = 4, --Zek'voz, Herald of N'zoth
				[2166] = 5, --Vectis
				[2195] = 6, --Zul, Reborn
				[2194] = 7, --Mythrax the Unraveler
				[2147] = 8, --G'huun
				
				[2333] = 1, --Champion of the Light
				[2325] = 2, --Grong, the Jungle Lord
				[2341] = 3, --Jadefire Masters
				[2342] = 4, --Opulence
				[2330] = 5, --Conclave of the Chosen
				[2335] = 6, --King Rastakhan
				[2334] = 7, --High Tinker Mekkatorque
				[2337] = 8, --Stormwall Blockade
				[2343] = 9, --Lady Jaina Proudmoore
				
				[2328] = 1, --The Restless Cabal
				[2332] = 2, --Uu'nat, Harbinger of the Void
				
				[2352] = 1, --Abyssal Commander Sivara
				[2347] = 2, --Blackwater Behemoth
				[2353] = 3, --Radiance of Azshara
				[2354] = 4, --Lady Ashvane
				[2351] = 5, --Orgozoa
				[2359] = 6, --The Queen's Court
				[2349] = 7, --Za'qul, Harbinger of Ny'alotha
				[2361] = 8, --Queen Azshara
				
			
			}
			
		--> armazena os escudos - Shields information for absorbs
			_detalhes.escudos = {}
		--> armazena as fun��es dos frames - Frames functions
			_detalhes.gump = _G ["DetailsFramework"]
			function _detalhes:GetFramework()
				return self.gump
			end
			GameCooltip = GameCooltip2
		--> anima��es dos icones
			_detalhes.icon_animations = {
				load = {
					in_use = {},
					available = {},
				},
			}
		--> armazena as fun��es para inicializa��o dos dados - Metatable functions
			_detalhes.refresh = {}
		--> armazena as fun��es para limpar e guardas os dados - Metatable functions
			_detalhes.clear = {}
		--> armazena a config do painel de fast switch
			_detalhes.switch = {}
		--> armazena os estilos salvos
			_detalhes.savedStyles = {}
		--> armazena quais atributos possue janela de atributos - contain attributes and sub attributos wich have a detailed window (left click on a row)
			_detalhes.row_singleclick_overwrite = {} 
		--> report
			_detalhes.ReportOptions = {}
		--> armazena os buffs registrados - store buffs ids and functions
			_detalhes.Buffs = {} --> initialize buff table
		-->  cache de grupo
			_detalhes.cache_damage_group = {}
			_detalhes.cache_healing_group = {}
			_detalhes.cache_npc_ids = {}
		--> cache de specs
			_detalhes.cached_specs = {}
			_detalhes.cached_talents = {}
		--> ignored pets
			_detalhes.pets_ignored = {}
			_detalhes.pets_no_owner = {}
			_detalhes.pets_players = {}
		--> dual candidates
			_detalhes.duel_candidates = {}
		--> armazena as skins dispon�veis para as janelas
			_detalhes.skins = {}
		--> armazena os hooks das fun��es do parser
			_detalhes.hooks = {}
		--> informa��es sobre a luta do boss atual
			_detalhes.encounter_end_table = {}
			_detalhes.encounter_table = {}
			_detalhes.encounter_counter = {}
			_detalhes.encounter_dungeons = {}
		--> reliable char data sources
		--> actors that are using details! and sent character data, we don't need query inspect on these actors
			_detalhes.trusted_characters = {}
		--> informa��es sobre a arena atual
			_detalhes.arena_table = {}
			_detalhes.arena_info = {
				--> need to get the new mapID for 8.0.1
				[562] = {file = "LoadScreenBladesEdgeArena", coords = {0, 1, 0.29296875, 0.9375}}, -- Circle of Blood Arena
				[617] = {file = "LoadScreenDalaranSewersArena", coords = {0, 1, 0.29296875, 0.857421875}}, --Dalaran Arena
				[559] = {file = "LoadScreenNagrandArenaBattlegrounds", coords = {0, 1, 0.341796875, 1}}, --Ring of Trials
				[980] = {file = "LoadScreenTolvirArena", coords = {0, 1, 0.29296875, 0.857421875}}, --Tol'Viron Arena
				[572] = {file = "LoadScreenRuinsofLordaeronBattlegrounds", coords = {0, 1, 0.341796875, 1}}, --Ruins of Lordaeron
				[1134] = {file = "LoadingScreen_Shadowpan_bg", coords = {0, 1, 0.29296875, 0.857421875}}, -- Tiger's Peak
				--> legion, thanks @pas06 on curse forge for the mapIds
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
				--> need to get the nwee mapID for 8.0.1
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
			function _detalhes:GetBattlegroundInfo (mapid)
				local t = _detalhes.battleground_info [mapid]
				if (t) then
					return t.file, t.coords
				end
			end
			
		--> tokenid
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
			
		--> armazena instancias inativas
			_detalhes.unused_instances = {}
			--_detalhes.default_skin_to_use = "Minimalistic"
			_detalhes.default_skin_to_use = "Minimalistic"
			_detalhes.instance_title_text_timer = {}
		--> player detail skin
			_detalhes.playerdetailwindow_skins = {}

		_detalhes.BitfieldSwapDebuffsIDs = {265646, 272407, 269691, 273401, 269131, 260900, 260926, 284995, 292826, 311367, 310567, 308996, 307832}
		
		--> auto run code
		_detalhes.RunCodeTypes = {
			{Name = "On Initialization", Desc = "Run code when Details! initialize or when a profile is changed.", Value = 1, ProfileKey = "on_init"},
			{Name = "On Zone Changed", Desc = "Run code when the zone where the player is in has changed (e.g. entered in a raid).", Value = 2, ProfileKey = "on_zonechanged"},
			{Name = "On Enter Combat", Desc = "Run code when the player enters in combat.", Value = 3, ProfileKey = "on_entercombat"},
			{Name = "On Leave Combat", Desc = "Run code when the player left combat.", Value = 4, ProfileKey = "on_leavecombat"},
			{Name = "On Spec Change", Desc = "Run code when the player has changed its specialization.", Value = 5, ProfileKey = "on_specchanged"},
			{Name = "On Enter/Leave Group", Desc = "Run code when the player has entered or left a party or raid group.", Value = 6, ProfileKey = "on_groupchange"},
		}
		
		--> tooltip
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

		--> icons
			_detalhes.attribute_icons = [[Interface\AddOns\Details\images\atributos_icones]]
			function _detalhes:GetAttributeIcon (attribute)
				return _detalhes.attribute_icons, 0.125 * (attribute - 1), 0.125 * attribute, 0, 1
			end
			
		--> colors
			_detalhes.default_backdropcolor = {.094117, .094117, .094117, .8}
			_detalhes.default_backdropbordercolor = {0, 0, 0, 1}
			
	--> Plugins
	
		--> plugin templates
		
		_detalhes.gump:NewColor ("DETAILS_PLUGIN_BUTTONTEXT_COLOR", 0.9999, 0.8196, 0, 1)
		
		_detalhes.gump:InstallTemplate ("button", "DETAILS_PLUGINPANEL_BUTTON_TEMPLATE", 
			{
				backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
				backdropcolor = {0, 0, 0, .5},
				backdropbordercolor = {0, 0, 0, .5},
				onentercolor = {0.3, 0.3, 0.3, .5},
			}
		)
		_detalhes.gump:InstallTemplate ("button", "DETAILS_PLUGINPANEL_BUTTONSELECTED_TEMPLATE", 
			{
				backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
				backdropcolor = {0, 0, 0, .5},
				backdropbordercolor = {1, 1, 0, 1},
				onentercolor = {0.3, 0.3, 0.3, .5},
			}
		)
		
		_detalhes.gump:InstallTemplate ("button", "DETAILS_PLUGIN_BUTTON_TEMPLATE", 
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
		_detalhes.gump:InstallTemplate ("button", "DETAILS_PLUGIN_BUTTONSELECTED_TEMPLATE", 
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
		
		_detalhes.gump:InstallTemplate ("button", "DETAILS_TAB_BUTTON_TEMPLATE", 
			{
				width = 100,
				height = 20,
			},
			"DETAILS_PLUGIN_BUTTON_TEMPLATE"
		)
		_detalhes.gump:InstallTemplate ("button","DETAILS_TAB_BUTTONSELECTED_TEMPLATE", 
			{
				width = 100,
				height = 20,
			},
			"DETAILS_PLUGIN_BUTTONSELECTED_TEMPLATE"
		)
	
		_detalhes.PluginsGlobalNames = {}
		_detalhes.PluginsLocalizedNames = {}
		
		--> raid -------------------------------------------------------------------
			--> general function for raid mode plugins
				_detalhes.RaidTables = {} 
			--> menu for raid modes
				_detalhes.RaidTables.Menu = {} 
			--> plugin objects for raid mode
				_detalhes.RaidTables.Plugins = {} 
			--> name to plugin object
				_detalhes.RaidTables.NameTable = {} 
			--> using by
				_detalhes.RaidTables.InstancesInUse = {} 
				_detalhes.RaidTables.PluginsInUse = {} 

		--> solo -------------------------------------------------------------------
			--> general functions for solo mode plugins
				_detalhes.SoloTables = {} 
			--> maintain plugin menu
				_detalhes.SoloTables.Menu = {} 
			--> plugins objects for solo mode
				_detalhes.SoloTables.Plugins = {} 
			--> name to plugin object
				_detalhes.SoloTables.NameTable = {} 
		
		--> toolbar -------------------------------------------------------------------
			--> plugins container
				_detalhes.ToolBar = {}
			--> current showing icons
				_detalhes.ToolBar.Shown = {}
				_detalhes.ToolBar.AllButtons = {}
			--> plugin objects
				_detalhes.ToolBar.Plugins = {}
			--> name to plugin object
				_detalhes.ToolBar.NameTable = {}
				_detalhes.ToolBar.Menu = {}
		
		--> statusbar -------------------------------------------------------------------
			--> plugins container
				_detalhes.StatusBar = {}
			--> maintain plugin menu
				_detalhes.StatusBar.Menu = {} 
			--> plugins object
				_detalhes.StatusBar.Plugins = {} 
			--> name to plugin object
				_detalhes.StatusBar.NameTable = {} 

	--> constants
		--[[global]] DETAILS_HEALTH_POTION_LIST = {
			[250870] = true, --Coastal Healing Potion
			[250872] = true, --Coastal Rejuvenation Potion
			[6262] = true, --Warlock's Healthstone
		}
		--[[global]] DETAILS_HEALTH_POTION_ID = 250870
		--[[global]] DETAILS_REJU_POTION_ID = 250872
		--[[global]] DETAILS_MANA_POTION_ID = 250871
		--[[global]] DETAILS_FOCUS_POTION_ID = 252753
		
		--[[global]] DETAILS_INT_POTION_ID = 279151
		--[[global]] DETAILS_AGI_POTION_ID = 279152
		--[[global]] DETAILS_STR_POTION_ID = 279153
		--[[global]] DETAILS_STAMINA_POTION_ID = 279154
	
		_detalhes._detalhes_props = {
			DATA_TYPE_START = 1,	--> Something on start
			DATA_TYPE_END = 2,	--> Something on end

			MODO_ALONE = 1,	--> Solo
			MODO_GROUP = 2,	--> Group
			MODO_ALL = 3,		--> Everything
			MODO_RAID = 4,	--> Raid
		}
		_detalhes.modos = {
			alone = 1, --> Solo
			group = 2,	--> Group
			all = 3,	--> Everything
			raid = 4	--> Raid
		}

		_detalhes.divisores = {
			abre = "(",	--> open
			fecha = ")",	--> close
			colocacao = ". " --> dot
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
		
		local Loc = LibStub ("AceLocale-3.0"):GetLocale ("Details")
		
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
			--> report window
			report = { 
					up = "Interface\\FriendsFrame\\UI-Toast-FriendOnlineIcon",
					down = "Interface\\ItemAnimations\\MINIMAP\\TRACKING\\Profession",
					disabled = "Interface\\ItemAnimations\\MINIMAP\\TRACKING\\Profession",
					highlight = nil
				}
		}
	
		_detalhes.missTypes = {"ABSORB", "BLOCK", "DEFLECT", "DODGE", "EVADE", "IMMUNE", "MISS", "PARRY", "REFLECT", "RESIST"} --> do not localize-me

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> frames
	
	local _CreateFrame = CreateFrame --api locals
	local _UIParent = UIParent --api locals
	
	--> Info Window
		_detalhes.janela_info = _CreateFrame ("Frame", "DetailsPlayerDetailsWindow", _UIParent)
		_detalhes.PlayerDetailsWindow = _detalhes.janela_info
		
	--> Event Frame
		_detalhes.listener = _CreateFrame ("Frame", nil, _UIParent)
		_detalhes.listener:RegisterEvent ("ADDON_LOADED")
		_detalhes.listener:SetFrameStrata ("LOW")
		_detalhes.listener:SetFrameLevel (9)
		_detalhes.listener.FrameTime = 0
	
		_detalhes.overlay_frame = _CreateFrame ("Frame", nil, _UIParent)
		_detalhes.overlay_frame:SetFrameStrata ("TOOLTIP")
	
	--> Pet Owner Finder
		_CreateFrame ("GameTooltip", "DetailsPetOwnerFinder", nil, "GameTooltipTemplate")
		
		
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> plugin defaults
	--> backdrop
	_detalhes.PluginDefaults = {}
	
	_detalhes.PluginDefaults.Backdrop = {bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
	edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1,
	insets = {left = 1, right = 1, top = 1, bottom = 1}}
	_detalhes.PluginDefaults.BackdropColor = {0, 0, 0, .6}
	_detalhes.PluginDefaults.BackdropBorderColor = {0, 0, 0, 1}
	
	function _detalhes.GetPluginDefaultBackdrop()
		return _detalhes.PluginDefaults.Backdrop, _detalhes.PluginDefaults.BackdropColor, _detalhes.PluginDefaults.BackdropBorderColor
	end


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> functions
	
	_detalhes.empty_function = function() end
	_detalhes.empty_table = {}
	
	--> register textures and fonts for shared media
		local SharedMedia = LibStub:GetLibrary ("LibSharedMedia-3.0")
		--default bars
		SharedMedia:Register ("statusbar", "Details D'ictum", [[Interface\AddOns\Details\images\bar4]])
		SharedMedia:Register ("statusbar", "Details Vidro", [[Interface\AddOns\Details\images\bar4_vidro]])
		SharedMedia:Register ("statusbar", "Details D'ictum (reverse)", [[Interface\AddOns\Details\images\bar4_reverse]])
		--flat bars
		SharedMedia:Register ("statusbar", "Details Serenity", [[Interface\AddOns\Details\images\bar_serenity]])
		SharedMedia:Register ("statusbar", "BantoBar", [[Interface\AddOns\Details\images\BantoBar]])
		SharedMedia:Register ("statusbar", "Skyline", [[Interface\AddOns\Details\images\bar_skyline]])
		SharedMedia:Register ("statusbar", "WorldState Score", [[Interface\WorldStateFrame\WORLDSTATEFINALSCORE-HIGHLIGHT]])
		SharedMedia:Register ("statusbar", "DGround", [[Interface\AddOns\Details\images\bar_background]])
		SharedMedia:Register ("statusbar", "Details Flat", [[Interface\AddOns\Details\images\bar_background]])
		
		--window bg and bar border
		SharedMedia:Register ("background", "Details Ground", [[Interface\AddOns\Details\images\background]])
		SharedMedia:Register ("border", "Details BarBorder 1", [[Interface\AddOns\Details\images\border_1]])
		SharedMedia:Register ("border", "Details BarBorder 2", [[Interface\AddOns\Details\images\border_2]])
		SharedMedia:Register ("border", "Details BarBorder 3", [[Interface\AddOns\Details\images\border_3]])
		SharedMedia:Register ("border", "1 Pixel", [[Interface\Buttons\WHITE8X8]])
		--misc fonts
		SharedMedia:Register ("font", "Oswald", [[Interface\Addons\Details\fonts\Oswald-Regular.otf]])
		SharedMedia:Register ("font", "Nueva Std Cond", [[Interface\Addons\Details\fonts\NuevaStd-Cond.otf]])
		SharedMedia:Register ("font", "Accidental Presidency", [[Interface\Addons\Details\fonts\Accidental Presidency.ttf]])
		SharedMedia:Register ("font", "TrashHand", [[Interface\Addons\Details\fonts\TrashHand.TTF]])
		SharedMedia:Register ("font", "Harry P", [[Interface\Addons\Details\fonts\HARRYP__.TTF]])
		SharedMedia:Register ("font", "FORCED SQUARE", [[Interface\Addons\Details\fonts\FORCED SQUARE.ttf]])
		
		SharedMedia:Register ("sound", "d_gun1", [[Interface\Addons\Details\sounds\sound_gun2.ogg]])
		SharedMedia:Register ("sound", "d_gun2", [[Interface\Addons\Details\sounds\sound_gun3.ogg]])
		SharedMedia:Register ("sound", "d_jedi1", [[Interface\Addons\Details\sounds\sound_jedi1.ogg]])
		SharedMedia:Register ("sound", "d_whip1", [[Interface\Addons\Details\sounds\sound_whip1.ogg]])
	
	--> global 'vardump' for dump table contents over chat panel
		function vardump (t)
			if (type (t) ~= "table") then
				return
			end
			for a,b in pairs (t) do 
				print (a,b)
			end
		end
		
	--> global 'table_deepcopy' copies a full table	
		function table_deepcopy (orig)
			local orig_type = type(orig)
			local copy
			if orig_type == 'table' then
				copy = {}
				for orig_key, orig_value in next, orig, nil do
					copy [table_deepcopy (orig_key)] = table_deepcopy (orig_value)
				end
			else
				copy = orig
			end
			return copy
		end
	
	--> delay messages
		function _detalhes:DelayMsg (msg)
			_detalhes.delaymsgs = _detalhes.delaymsgs or {}
			_detalhes.delaymsgs [#_detalhes.delaymsgs+1] = msg
		end
		function _detalhes:ShowDelayMsg()
			if (_detalhes.delaymsgs and #_detalhes.delaymsgs > 0) then
				for _, msg in ipairs (_detalhes.delaymsgs) do 
					print (msg)
				end
			end
			_detalhes.delaymsgs = {}
		end
	
	--> print messages
		function _detalhes:Msg (_string, arg1, arg2, arg3, arg4)
			if (self.__name) then
				--> yes, we have a name!
				print ("|cffffaeae" .. self.__name .. "|r |cffcc7c7c(plugin)|r: " .. (_string or ""), arg1 or "", arg2 or "", arg3 or "", arg4 or "")
			else
				print (Loc ["STRING_DETAILS1"] .. (_string or ""), arg1 or "", arg2 or "", arg3 or "", arg4 or "")
			end
		end
		
	--> welcome
		function _detalhes:WelcomeMsgLogon()
		
			_detalhes:Msg ("you can always reset the addon running the command |cFFFFFF00'/details reinstall'|r if it does fail to load after being updated.")
			
			function _detalhes:wipe_combat_after_failed_load()
				_detalhes.tabela_historico = _detalhes.historico:NovoHistorico()
				_detalhes.tabela_overall = _detalhes.combate:NovaTabela()
				_detalhes.tabela_vigente = _detalhes.combate:NovaTabela (_, _detalhes.tabela_overall)
				_detalhes.tabela_pets = _detalhes.container_pets:NovoContainer()
				_detalhes:UpdateContainerCombatentes()
				
				_detalhes_database.tabela_overall = nil
				_detalhes_database.tabela_historico = nil
				
				_detalhes:Msg ("seems failed to load, please type /reload to try again.")
			end
			_detalhes:ScheduleTimer ("wipe_combat_after_failed_load", 5)
			
		end
		_detalhes.failed_to_load = _detalhes:ScheduleTimer ("WelcomeMsgLogon", 20)
	
	--> key binds
		--> header
			_G ["BINDING_HEADER_Details"] = "Details!"
			_G ["BINDING_HEADER_DETAILS_KEYBIND_SEGMENTCONTROL"] = Loc ["STRING_KEYBIND_SEGMENTCONTROL"]
			_G ["BINDING_HEADER_DETAILS_KEYBIND_SCROLLING"] = Loc ["STRING_KEYBIND_SCROLLING"]
			_G ["BINDING_HEADER_DETAILS_KEYBIND_WINDOW_CONTROL"] = Loc ["STRING_KEYBIND_WINDOW_CONTROL"]
			_G ["BINDING_HEADER_DETAILS_KEYBIND_BOOKMARK"] = Loc ["STRING_KEYBIND_BOOKMARK"]
			_G ["BINDING_HEADER_DETAILS_KEYBIND_REPORT"] = Loc ["STRING_KEYBIND_WINDOW_REPORT_HEADER"]

		--> keys
		
			_G ["BINDING_NAME_DETAILS_TOGGLE_ALL"] = Loc ["STRING_KEYBIND_TOGGLE_WINDOWS"]
			
			_G ["BINDING_NAME_DETAILS_RESET_SEGMENTS"] = Loc ["STRING_KEYBIND_RESET_SEGMENTS"]
			_G ["BINDING_NAME_DETAILS_SCROLL_UP"] = Loc ["STRING_KEYBIND_SCROLL_UP"]
			_G ["BINDING_NAME_DETAILS_SCROLL_DOWN"] = Loc ["STRING_KEYBIND_SCROLL_DOWN"]
	
			_G ["BINDING_NAME_DETAILS_REPORT_WINDOW1"] = format (Loc ["STRING_KEYBIND_WINDOW_REPORT"], 1)
			_G ["BINDING_NAME_DETAILS_REPORT_WINDOW2"] = format (Loc ["STRING_KEYBIND_WINDOW_REPORT"], 2)
	
			_G ["BINDING_NAME_DETAILS_TOOGGLE_WINDOW1"] = format (Loc ["STRING_KEYBIND_TOGGLE_WINDOW"], 1)
			_G ["BINDING_NAME_DETAILS_TOOGGLE_WINDOW2"] = format (Loc ["STRING_KEYBIND_TOGGLE_WINDOW"], 2)
			_G ["BINDING_NAME_DETAILS_TOOGGLE_WINDOW3"] = format (Loc ["STRING_KEYBIND_TOGGLE_WINDOW"], 3)
			_G ["BINDING_NAME_DETAILS_TOOGGLE_WINDOW4"] = format (Loc ["STRING_KEYBIND_TOGGLE_WINDOW"], 4)
			_G ["BINDING_NAME_DETAILS_TOOGGLE_WINDOW5"] = format (Loc ["STRING_KEYBIND_TOGGLE_WINDOW"], 5)
			
			_G ["BINDING_NAME_DETAILS_BOOKMARK1"] = format (Loc ["STRING_KEYBIND_BOOKMARK_NUMBER"], 1)
			_G ["BINDING_NAME_DETAILS_BOOKMARK2"] = format (Loc ["STRING_KEYBIND_BOOKMARK_NUMBER"], 2)
			_G ["BINDING_NAME_DETAILS_BOOKMARK3"] = format (Loc ["STRING_KEYBIND_BOOKMARK_NUMBER"], 3)
			_G ["BINDING_NAME_DETAILS_BOOKMARK4"] = format (Loc ["STRING_KEYBIND_BOOKMARK_NUMBER"], 4)
			_G ["BINDING_NAME_DETAILS_BOOKMARK5"] = format (Loc ["STRING_KEYBIND_BOOKMARK_NUMBER"], 5)
			_G ["BINDING_NAME_DETAILS_BOOKMARK6"] = format (Loc ["STRING_KEYBIND_BOOKMARK_NUMBER"], 6)
			_G ["BINDING_NAME_DETAILS_BOOKMARK7"] = format (Loc ["STRING_KEYBIND_BOOKMARK_NUMBER"], 7)
			_G ["BINDING_NAME_DETAILS_BOOKMARK8"] = format (Loc ["STRING_KEYBIND_BOOKMARK_NUMBER"], 8)
			_G ["BINDING_NAME_DETAILS_BOOKMARK9"] = format (Loc ["STRING_KEYBIND_BOOKMARK_NUMBER"], 9)
			_G ["BINDING_NAME_DETAILS_BOOKMARK10"] = format (Loc ["STRING_KEYBIND_BOOKMARK_NUMBER"], 10)
			
end
