--
--	Grail
--	Written by scott@mithrandir.com
--
--	Version History
--		001	Initial version.
--		002	Converted to using a hooked function to register completed quests.
--			Made it so quests that never appear in the quest log can be marked completed assuming the quest data is up to date.
--			Condensed the debug statements.
--			Changed the architecture so extra information can be returned for failure conditions.
--			Switched ProfessionExceeds to be able to use localized names of professions.
--		003	Made it so Darkmoon Faire NPCs return the location based on where the Darkmoon Faire currently is.
--			Removed the QUEST_AUTOCOMPLETE event handling since it seems to be unneeded.
--			Added specialZones which allow mapping of GetZoneText() to things we prefer.
--			Removed the check for IsDaily() and IsWeekly() from the Status routine since they are marked as non-complete when reset happens.
--			Added IsYearly() because there are holiday quests that can be completed only once.
--			Resettable quests (daily/weekly/yearly) are now recorded specially so quests can be queried as to whether they have ever been completed using HasQuestEverBeenCompleted().
--			Added a notification system for accepting and completing quests.
--			Added API to get quests that are available during an event (holiday).
--		004	Corrected a problem where resettable quests could not be saved for initial use.
--			Augmented level checking to maximum level is checked as well.
--			Added a targetLevel parameter to filtering quests.
--			Made it so "Near" NPCs can have a specific zone associated with them which makes their return location table entry have the zone name and the word "Near".
--			Removed the need for specialZones since GetRealZoneText() does what we need.  Switched the use of GetZoneText() to GetRealZoneText().
--			ProfessionExceeds() now returns success and skill level, where skill level can be Grail.NO_SKILL if the player does not have that skill at all.
--			LocationNPC() now has more parameters to refine the locations returned.
--			LocationQuest() now makes use of LocationNPC() changes and can return the NPC name as well.
--		005	Quest titles that do not match our internal database are recorded, which helpfully gives us localizations as well.
--			Made it so repeatable quests are also recorded in the resettable quests list.
--			Did a little optimization by declaring some LUA functions local.
--			Made some quest traversal routines take an optional argument to force garbage collection, which greatly increases the time to return the desired data, but brings the footprint back down.
--			Added a routine to get the riding skill level.
--			Made it so QueryQuestsCompleted() is called at startup because the earlier assumption did not take into account that there was still another add-on that did it.
--			Made it so we call QueryQuestsCompleted() if GetQuestResetTime() indicates that quests have been reset.  LIMITATION: The check that triggers this only happens upon accepting or completing a quest.
--			Corrected a problem in ProfessionExceeds() where the comparison was incorrect.  Also made sure the skill exists before API is called.  Changed the value of Grail.NO_SKILL.
--			IsNPCAvailable() now can work with heroic NPCs in their instances.
--		006	Corrected a problem where the questResetTime variable was misspelled.
--			Made it so the SpecialQuests are cleaned out of the GrailDatabase properly.
--			Switched City of Ironforge to Ironforge to match GetRealZoneText() return value.
--			Added a table that contains the quests per zone to allow QuestsInZone() to return the cached information immediately.
--			Made it so a callback can be registered for quest abandoning.
--		007	Corrected a problem where a mismatch in title would cause a LUA error when attempting to record bad quest data.
--			Made it so the GrailDatabase gets its NewQuests and NewNPCs cleaned out properly.
--			Added a QuestName function so the name can be gotten without need for internal data structure knowledge.
--			Added Quest and NPC localizations for French, German, Russian and Spanish.
--		008	Changed hooking quest completing to actually get the current script associated instead of the global name for the script.
--			Corrected some problems where LUA errors would occur if the internal database did not know about a quest.
--			Added support for a quest to have a prerequisite quest in the quest log and not complete.
--			Added support for automatic quests to indicate the NPC that needs to be killed to initiate quest acceptance.
--			Added support for automatic quests that are obtained from entering a zone.
--			Added a zoneMapping table that maps zone IDs returned by GetCurrentMapAreaID() to those used internally.
--			Made it so Status can ignore prerequisite requirements of a quest.
--			Made LocationQuest also return the NPC ID as well as the other information it returns.
--			Restructured the posting of the abandon notification to be about 0.75 seconds after the button click because it seems the quest log does not actually remove it immediately.
--			Added capability to handle indirect items where another NPC drops the one that starts the quest.  The NPC name returned is an NPC that drops the item followed by the item name in parentheses.
--		009	Added more mappings from GetCurrentMapAreaID().
--			Corrected a problem where some parameter names in Status() were not the same as in the implementation, thereby ignoring their values.
--			Added a QuestLevel() function.
--			MeetsRequirementLevel() now returns the levels used to determine success.
--			Added some quest interrogation routines IsEscort(), IsDungeon(), IsRaid(), IsPVP(), IsGroup() and IsHeroic().
--			Added a QuestsInMap() function that uses a map ID.
--			Added a convenience function SingleMapLocationQuest().
--		010	Added an NPCName() function.
--			Added an IsTooltipNPC() which indicates what type of NPC we are dealing with for those that modify tooltips.
--			Added an AvailableBreadcrumbs() which returns breadcrumb quests available to be gotten for the specified quest.
--		011	Corrected an issue where ensuring all prerequisite quests were confirmed could have been inaccurate.
--			Added AncestorStatus() and made Status() call it so prerequisite quests are checked to ensure they can be completed otherwise the Status will be false.  For example, this makes
--			an entire quest chain unavailable if the race does not permit the first quest to be accepted.
--			Debugging has now been turned off by default.
--			A new feature called tracking has been provided to keep a little history of basic quest activity, but is off by default.
--			Changed the posting of abandon notifications to be about 1.0 seconds after the button click since there were times when 0.75 seconds was not enough, and made it a variable.
--			Added some clearing out of BadQuestData that has been added to the database.
--			Made clearing out of NewQuest data more robust.
--			Changed to have NPC locations use map area IDs.
--			Removed the zoneMapping and zones tables as part of the move to using map area IDs for all locations.
--			Made the quest index per map area computed at runtime for the latest most accurate data.
--		012	Made it so marking a quest complete only does so if the quest is not already complete.  This is just a precaution to handle an edge case.
--			Added the "/grail backup" and "/grail compare" commands to help find quest IDs for quests that do not enter the quest log.
--			Made it so special quests that never appear in the quest log can be recorded as complete when there is more than one quest with the same name as long as the NPC ID is different.
--			Made it so NPC locations return the dungeon level and the alias map ID.
--			Added a lot of quest/NPC information for the Midsummer Fire Festival.
--		013	Updated quests and NPCs for Firelands.
--			Did a bunch of localization.
--		014	Corrected some localization issues.
--			Updates quests and NPCs for Mount Hyjal and Firelands.
--			Corrected quest prerequisite information to remove cycles to make a DAG.
--			Added AncestorQuests() which returns a complicated table structure of prerequisite quests.
--		015	Made low level comparisons use Blizzard's own routine so grey quests appear properly.
--			Added more quest level information.
--			Updates to quests/NPCs for Firelands, Alliance Grizzly Hills, and Kezan.
--			Added processing to have holiday quests stored in their own map areas (besides where the quest givers are) so they can be viewed as a group.
--			Added the ability to handle PH: prerequisites that require a quest to have been completed sometime in the past (used with dailies that are triggers).
--			Added the ability to handle Xc codes which exclude classes (basically the opposite of Cc codes).
--		016	Updates to quests/NPCs for Gilneas, and Durotar.
--			Corrected a problem in MultipleUniqueMapLocationQuest() where the accept or turn in parameter was not being passed along properly.
--		017	Updated quest and NPC data to minimize problems with stack overflows, etc.
--			Made it so questgiver locations with NearXXX codes are ignored like Near.
--			Made it so AncestorStatus is now passed the same ignore flags as Status so any subsequent calls to Status will get passed them as well.
--			Added tables for the five continents' dungeons.
--		018	Set up basic structures to start support for ptBR localization when Brazilian version comes on line.
--			Updated a large number of localizations for quest names.
--			Updates to some Firelands quest/NPC information, as well as Zul'Drak, Tirisfal Glades, Redridge Mountains, Duskwood and Northern Stranglethorn.
--			Implemented support for Sx quest codes which are the logical opposite of Rx codes.
--			Corrected the implementation of Xx codes.
--			Made it so a nil value we sometimes get will no longer crash, but output something helpful.
--		019	Added support for PC: quest codes.
--			Updated some Alliance quest information for Northern Stranglethorn, Cape of Stranglethorn, Dustwallow Marsh, Dun Morogh, Loch Modan, Wetlands, Arathi Highlands, The Hinterlands, Western Plaguelands, Badlands, Searing Gorge, Burning Steppes, Swamp of Sorrows, Darkshore, Teldrassil, Hillsbrad Foothills, Azuremyst, Bloodmyst Isle, Zul'Drak and the capital cities.
--			Updated some quest information for Mulgore, Tirisfal Glades and Silverpine Forest.
--			Made it so AvailableBreadcrumbs() will return breadcrumbs that have prerequisites that can be fulfilled as well as ones that are currently available.
--			K codes for cooking, fishing, and Brewfest quests have been changed to level 0 to indicate the actual level is the same as the player accepting the quest.
--			The zone-specific Self NPCs are now automatically generated for each zone.
--			Changed Status() to return a "Level" failure last of all the checks.
--			Corrected a probem where DEATHKNIGHT was not properly used as the class type.
--			Made it so there is a "map area" that contains all the daily quests.
--			Made "map areas" to contain each of the quests only available to specific classes.
--			Made "map areas" to contain each of the quests only available to specific professions.
--			Made "map areas" to contain each of the quests only available to those with specific reputations with factions.
--			Added support for OAC: quest codes.
--			Added a StatusCode() routine that returns a bitmask of quest status.
--		020	Updates some quest/NPC information for Durotar, Desolace, Southern Barrens, Ironforge, Stonetalon Mountains, Eversong Woods, Eastern Plaguelands, Badlands, Zul'Drak and Ashenvale.
--			Added more support for StatusCode() to support some more bit values plus values from prerequisites.
--			When using StatusCode() quest status values are cached to avoid recomputing values.  The cached values are invalidated as appropriate based on environment and the values of the status.
--			Made IsLowLevel() never consider quests whose level is 0 as low-level since those quests' levels change to match the player level.
--			Removed the Ahn'Qiraj War Effort from the list of world events.
--			Marked Status() as deprecated API which will be removed in the future.
--			Changed the method by which abandoned quests have their notifications posted so the variable abandonedQuestId no longer exists.
--			Added support for LoremasterMapArea() API which provides the map area of the Loremaster achievement for which the quest qualifies.  Also added Grail.loremasterQuests[mapAreaId] tables which list the quests that are used for each Loremaster achievement.
--		021	Updates some quest/NPC information for Feralas, Northern Stranglethorn, Un'Goro Crater, Stormwind City, Ghostlands, Silvermoon City and Cape of Stranglethorn.
--			Updates quest/NPC information for Hallow's End and Day of the Dead.
--			Created caching structure for accessing some quest information to help reduce runtime footprint and increase speed.
--			Added support for OCC:, PLT: and PCT: quest codes.
--			Made QuestsInMap() able to return only quests that qualify for Loremaster.
--			Removed a number of debug slash commands and the functions that were supporting them.
--			Added the CreateRaceNameLocalizedGenderized() routine so race names can be displayed nicely.
--			Removed AncestorStatus(), QuestsWithCode() and Status() and some support routines.
--		022	Updates some quest/NPC information for Mugore, Thunder Bluff, Silverpine Forest, Durotar, Bloodmyst Isle and Azshara.
--			Updates quest/NPC information for Pilgrim's Bounty.
--			Corrected the Gnomeregan reputation name to not include Exiles.
--			Started recording found defects in a new format.
--			Created a system to record when reputation changes do not match what the internal database has.
--			Added the achievement information where quests are associated with specific achievements.
--			Updated the TOC to support Interface 40300.
--		023	Corrects the detection of the Mr Popularity guild perks.
--			Updates some quest/NPC information for Darkmoon Faire, Azshara, Elwynn Forest, class-specific ones and the Bwemba's Spirit line.
--			Adds the missing reputation names to the non-English clients (whose lack was causing addons that use reputation to fail).
--			Updates a lot of Portuguese data.
--			Fixes a problem where unknown quests were not being recorded correctly, causing a LUA error.
--			Fixes a problem where event handlers were not installed properly because Blizzard events cannot arrive in a guaranteed order.
--			Fixes a problem where AZ codes were not being processed properly, thereby resulting in quests with those codes to appear in the current map area instead of their proper one.
--			Fixes a problem where the new Darkmoon Faire quests would not be available on Darkmoon Island unless the UI was reloaded.
--		024	Updates some quest/NPC information for Azshara, Ashenvale, Stonetalon Mountains, Southern Barrens, Dalaran, Shattrath City and some dungeons.
--			Updates some Portuguese localizations.
--			Updates the CleanDatabase() routine to do more cleaning.
--			Makes it so slash commands are not forced to lower case.
--			Changes the way StatusCode() works to not mark a quest complete if it does not meet race, class, gender and/or faction requirements.  This is to work around Blizzard behavior where the server marks quests complete that could not possibly be done by a player.
--			Changes the way StatusCode() works to not mark level problems or invalidation problems with quests that are marked complete.
--			Fixes a problem where CleanDatabase() could attempt to access data that does not exist.
--			Fixes an infinite loop that is sometimes encountered using Blizzard's GetFactionInfo(), found by ArcaneTourist.
--		025	Updates some quest/NPC information for Southern Barrens, Durotar, Northern Barrens, Desolace and Dustwallow Marsh.
--			Adds a Christmas Week holiday that handles the quests in Winter Veil that only start appearing on Christmas Day.
--			Adds a feature to record NPC names that do not match those in the database.
--			Updates some Portuguese localizations.
--			Updates some other localizations, for Winter Veil.
--		026	Updates some quest/NPC information for Desolace, Azuremyst Isle, The Exodar, Azshara, Hillsbrad Foothills and Feralas.
--			Cleans up some Blizzard event handling, and moved some event handling Wholly was doing into here because it is the right place for them.
--			Updates some Portuguese localizations.
--			Fixes a problem where a LUA error was being thrown when invalidating part of the status cache when evaluating a quest status.
--			Adds support for world events achievements.
--		027	Updates some quest/NPC information for Feralas, Northern Barrens, Thousand Needles, Tanaris, Zul'Drak, Sholazar Basin, Storm Peaks, some dungeons and Uldum.
--			Updates some quest/NPC information for the Lunar Festival.
--			Updates some Portuguese localizations.
--		028	*** Will not work with Wholly 15 or older ***
--			Corrects the mapAreaMaximumReputationChange constant.
--			Revamps the location providing routines so only the new QuestLocations() and NPCLocations() are needed, REMOVING the older ones. 
--			Updates some quest/NPC information for Un'Goro Crater, Silithus, Burning Steppes, Kezan, The Lost Isles, Northern Barrens, Ashenvale, some dungeons and Winterspring.
--			Fixes detection of European servers to remove non-existent quests.
--			Updates some Portuguese localizations.
--			Makes _CleanDatabase() a little more intense with its cleaning.
--			Makes the system than checks for reputation gains a little more accurate.
--			Records actual quest completion for those quests that Blizzard marks complete with others in the server, so clients can know really which quest was done.
--			Implements a way to know when Blizzard uses internal marking mechanics (which differ from flag quests) to specify when quests are available.
--			Adds an architecture to support information about quests that are bugged.
--		029 *** Will not work with Wholly 16 or older ***
--			Splits out two load on demand addons to handle achievements and reputation gains.
--			Updates some quest/NPC information for the Lost Isles, Feralas and some dungeons.
--			Updates some localizations, primarily Portuguese, Korean and Simplified Chinese.
--			Corrects the problem where some daily quests that also have another aspect (e.g., PVP or dungeon) were not being shown as daily quests.
--			Updates the automatic quest level verification system to ensure quests that are considered to have a dynamic level actually do.
--          Adds basic structural support for the Italian localization.
--			Consolidates the internal use of prerequisite quest types into a unified technique, causing all QuestPrerequisite* API to be REMOVED other than QuestPrerequisites.
--			Fixes the problem where quests with AZ codes were not being added to the proper zone.
--			Fixes the problem where the status of quests that require other quests being in the quest log was not being displayed properly.
--			Adds the Kalu'ak Fishing Derby holiday.
--			Updates some quest/NPC information for the fishing contests.
--		030	Corrects a problem that manifests itself when running the ElvUI addon.
--		031	Corrects the internal checking of reputation gains to not include modifications when the reputation is lost.
--			Adds the verifynpcs slash command option.
--			Updates some localizations, primarily Portuguese and Korean.
--			Updates some quest/NPC information for Dun Morogh, Loch Modan, Wetlands, Vash'jir and Kelp'thar Forest.
--			Corrects the problem where quests with breadcrumbs were being marked as not complete after a reload.
--			Adds processing to startup to ensure Grail attempts to get the server quest status automatically.
--			Corrects AncestorStatusCode() to ignore non-quest prerequisites.
--			Adds the ability to have quests have items or lack of items as prerequisites.
--			Adds support for ODC: quest codes, which are used to mark other quests complete when a quest is turned in.
--			Adds the ability to have quests use the abandoned state of quests as prerequisites.
--		032	Adds some German translation from polzi.
--			Augments CanAcceptQuest() to include a parameter to ignore holiday requirements.
--			Updates some quest/NPC information for some dungeons, Oracles/Frenzyheart, Worgen starting areas, Tol Barad and others.
--			Changes the comparisons to completed quests to be more mathematically robust.
--			Corrects a problem where cleaning the database can cause a LUA error.
--		033	Updates some quest/NPC information for Blasted Lands, Eastern Plaguelands, Tirisfal Glades, Undercity, Winterspring, Zul'Aman and professions.
--			Adds some Spanish translation from Trisquite.
--			Changes the implementation of _ReputationExceeds() to use GetFactionInfoByID() instead of GetFactionInfo() since it seems there are times when the latter does not return proper values at startup.
--		034	Updates some quest/NPC information for Wandering Isle.
--			Creates new Grail.reputationExpansionMapping table to replace the original four tables which are deprecated and will be removed in version 035.
--			Updates Midsummer Fire Festival quest/NPC data, primarily the Portuguese localization.
--		035	Updates Midsummer Fire Festival localization for Korean, Spanish and German.
--			Updates more NPC/quest localizations.
--			Updates the quest recording subsystem to generate basic K codes.
--			Changes the reputation system to no longer use indirection, but Blizzard faction IDs.
--			Updates the quest recording subsystem to record faction rewards on quest acceptance, and turns off recording faction rewards when quests are turned in.
--			Corrects the problem where quests that start automatically when entering a zone can appear improperly in the current zone (based on the current zone name).
--			Changes the technique by which the server is queried for completed quests since API has been changed for MoP.
--			Updates some quest/NPC information for Valley of the Four Winds and Krasarang Wilds.
--			Makes it so B codes are automatically generated from the quests with O codes, so the vast majority of B codes need not be present in the data file.
--			Adds the ability to create profession prerequisite codes (vice the normally supported profession requirements).
--		036	Fixes the problem where accepting and abandoning a quest with a breadcrumb was not setting the breadcrumb status properly.
--			Fixes the problem where quests could be considered to fail prerequisites if the only prerequisites were quests requiring presence in the quest log.
--			Updates some quest/NPC information for MoP beta, including Night Elf and Draenei starter zones.
--			Updates quest information to allow marking quests Scenario and Legendary.
--			Removes Grail.bitMaskQuestNonLevel as the internal data structures have changed, no longer requiring this.
--			Adds HasQuestEverBeenAccepted() to be able to handle O type prerequisites.
--			Removes Grail.reputationBlizzardMapping since it is no longer needed because of the use of Blizzard faction IDs.
--		037	Updates some quest/NPC information for Twilight Highlands, Deepholm, Uldum, Sholazar Basin and Mount Hyjal.
--			Adds DisplayableQuestPrerequisites() so flag quests can be bypassed, showing their requirements instead.
--			Adds some Italian localization.
--			Adds support for account-wide quests.
--		038	Adds some Italian localization and quest localization updates for release 16030.
--			Updates some quest/NPC information for Jade Forest, Northern Stranglethorn, Vale of Eternal Blossoms and Echo Isles.
--			Adds ability for a quest to have prerequisites of a general skill, used by battle pets for example.
--			Refines meeting prerequisites when part of the requirements includes possessing an item.
--		039	Updates some quest/NPC information for Vale of Eternal Blossoms, Kun-Lai Summit, Borean Tundra, Dread Wastes and Valley of the Four Winds.
--			Adds support for prerequisites to be able to have OR requirements within an AND requirement, instead of just outside them.
--			Adds support for CanAcceptQuest() to not allow bugged quests to be acceptable.
--			Replaces the raceMapping, raceNameFemaleMapping, raceNameMapping and raceToBitMapping tables with races.  These older ones will be removed in version 40.
--		040	Updates some quest/NPC information for Howling Fjord, Jade Forest, Krasarang Wilds, Townlong Steppes, Valley of the Four Winds, Kun-Lai Summit and Vale of Eternal Blossoms.
--			Removes the raceMapping, raceNameFemaleMapping, raceNameMapping and raceToBitMapping tables.
--			Changes the format for reputation change logging.
--			Adds reputationLevelMapping table that Wholly was using because it will be changed as more information is known, and there should be no need for Wholly to need to change.
--		041	Adds support for quests having prerequisites of having ever experienced a buff.
--			Changes the internal representation of NPC information to separate the NPC names to make the data more "normal".
--			Augments the way the reputationLevelMapping table provides information so it can provide specific numeric values over the minimum reputation.
--			Adds the ability to have quests grouped so able to invalidate groups based on daily counts, or make prerequisites of a number of quests from a group.
--			Updates some quest/NPC information for Tillers, Golden Lotus, Order of the Cloud Serpent, Shado-Pan, August Celestials, Anglers and Klaxxi dailies.
--			Adds very basic quest information for 5.1 PTR quests from 2012-10-25.
--			Adds the ability to invalidate a quest by accepting a quest from a quest group.
--			Adds the ability for quests to have a prerequisite of a maximum reputation.
--			Adds code that abandons processing the server completed quests if the return results do not represent the total number of quests completed as compared to the locally stored count.
--		042	Corrects an initialization problem that would cause a Lua error if dailyQuests were not gotten before evaluated.
--		043	Corrects the prerequisites for the Chi-Ji champion dailies.
--			Updates the Shado-Pan dailies' NPCs.
--			Updates some quest/NPC information for Jade Forest, Kun-Lai Summit, Durotar and the dailies available in 5.1.
--			Updates the TOC to support interface 50100.
--		044	Removes the Grail-Zones.lua file since the names are now gotten from the runtime.
--			Puts in support for "/grail events" allowing control over processing of some Blizzard events received while in combat until after combat.
--			Updates some quest/NPC information for Operation: Shieldwall.
--			Removes the Grail.xml and rewrites the startup to account for its lack.
--			Adds very basic quest information for 5.2 PTR quests from 2013-01-02.
--			Removes the quests on Yojamba Isle since there are no NPCs there.
--			Updates some Netherstorm quests for Aldor/Scryers information.
--			Updates some quest localizations for Simplified Chinese.
--		045	Updates to Isle of Thunder King/Isle of Giants quests from 5.2 PTR.
--			Updates some Traditional Chinese localizations.
--			Updates some quest/NPC information.
--			Updates the technique where a quest is invalidated to properly include not being able to fulfill all prerequisites that include groups.
--			Puts quests whose start location does not map directly to a specific zone into their own "Other" map area.
--			Augments the API that returns NPC locations to include created and mailbox flags.
--		046	Updates some quest/NPC information.
--			Speeds up the CodesWithPrefix() routine provided by rowaasr13.  This reduces the chance of running into an issue when teleporting into combat.
--			Adds F code prerequisites which indicate a faction requirement.  Demonstrate this with two Work Order: quests, but will be used primarily for "phased" NPC prerequisites, whose architecture is starting to be implemented.
--			Updates some Traditional Chinese localizations.
--		047	Updates some quest/NPC information, primarily with the Isle of Thunder.
--			Adds the basics for the quests added in the 5.3.0 PTR release 16758.
--			Events in combat are forced to be delayed, but the user can still override.
--			Changes the internal design of the NPCs to save about 0.6 MB of space.
--		048	Makes it so choosing PvE or PvP for the day on Isle of Thunder is handled well.
--			Adds IsQuestObsolete() and IsQuestPending() which use the new Z and E quests codes that can be present.  If either returns true, the quest is not available in the current Blizzard client.
--			Adds support for the new way reputation information is being stored.
--			Converts prerequisite information storage to no longer use tables, saving about 1.0 MB of space.
--		049	Changes the Interface to 50300 for the 5.3.0 Blizzard release.
--			Updates some quest/NPC information, primarily with the Isle of Thunder.
--			Adds a new loadable addon, Grail-When, that records when quests are completed.
--			Adds a flag to QuestPrerequisites(), allowing the lack of flag to cause the behavior to return to what it was previously, and with the flag the newer behavior.
--		050	Corrects a problem with QuestPrerequisites() and nil data.
--		051 Adds Midsummer quests for Pandaria.
--			Updates some quest/NPC information not associated with Midsummer.
--			Changes _CleanDatabase() to better handle NPCs that have prerequisites.
--			Corrects a problem where questReputations was not initialized when reputation data was not loaded.
--			Adds the ability to have an equipped iLvl be used as a prerequisite.
--		052	Updates some quest/NPC information.
--			Adds some Wrathion achievements.
--			Moves some achievements into continents that are a little more logical.
--			Separates some achievements to give a little finer-grain control.
--			Updates some zhCN localizations.
--		053	Updates some quest/NPC information.
--			Corrects an error that would cause an infinite loop in evaluating data in Ashenvale for quest 31815, Zonya the Sadist.
--		054	Updates some quest/NPC information.
--			Incorporates prereqisite population API originally written in Wholly.
--			Fills out the Pandaria "loremaster" achievements to include all the prerequisite quests for each sub achievement quest.
--		055	Updates some quest/NPC information.
--			Fixes an infinite loop issue when evaluating data in the Valley of the Four Winds.
--			Fixes a Lua issue that manifests when Dugi guides are loaded, because Grail was incorrectly using a variable that Dugi guides leaks into the global namespace.
--			Caches the results obtained from _QuestsInLog() to make quest status updates faster, invalidating the cache as appropriate.
--			Fixes a rare error caused when cleaning the database of reputation data evident by an "unfinished capture" error message.
--			Adds the ability to treat the chests on the Timeless Isle as quests.
--			Adds the slash command "/grail loot" to control whether the LOOT_CLOSED event is monitored as that is used to handle Timeless Isle chests.
--			Makes persistent the settings for the slash commands "/grail tracking" and "/grail debug".
--			Makes CanAcceptQuest() not return true if the quest is obsolete or pending.
--		056	Updates some quest/NPC information.
--			Fixes a variable leak that causes problems determining prerequisite information.
--		057	Corrects some issues stemming from new repuation information.
--			Adds some localizations of quest/NPC names.
--		058	Augments ClassificationOfQuestCode() to return 'K' for weekly quests.
--			Updates some quest/NPC information.
--			Makes handling LOOT_CLOSED not be so noisy with chat spam.
--			Makes processing the UNIT_QUEST_LOG_CHANGED event delayed by 0.5 seconds to allow walking through the Blizzard quest log using GetQuestLogTitle() to work better.
--		059	Caches the results obtained from ItemPresent() to make quest status updates faster, invalidating the cache as appropriate.
--			Updates some quest/NPC information.
--			Changes the NPC IDs used to represent spells that summon pets to remove a conflict with actual items.
--			Changes some of the internal structures used to save some memory.
--			Corrects an issue where the Loremaster quest data for Pandaria was not populating an internal structure properly (causing Loremaster not to display map pins).
--			Updates _QuestsInLog() to work better when various headings are closed in the Blizzard quest log.
--		060	Updates some quest/NPC information.
--			Updates the issue recording system to provide a little more accurate information to make processing saved variables files easier.
--		061 Updates some quest/NPC information.
--			Added the ability for prerequisite evaluation to only check profession requirements.
--			Corrected the evaluation of ancestor failures to properly propagate past the first level of quest failure.
--		062	Corrected a problem where quests with First Aid prerequisites would cause a Lua error.
--		063	Updates some quest/NPC information.
--			Unified the reputation requirements into the prerequisite codes.
--			Allows A: and T: codes to work in conjuction (additive) with the faction-specific versions.
--			Allows AZ: codes to have more than one map area.
--		064 Updates some quest/NPC information.
--			Corrects prerequisite evaluation when analyzing more than one path that have different results (like Alliance vs Horde both leading to the same quest).
--			Speeds up prerequisite tree analysis.
--		065	Updates some quest/NPC information.
--			Corrects a problem where First Aid quests were not being put into their own "zone" properly.
--			Adds the ability to complete quests when gossiping with an NPC.
--			Changes internal processing of qualified NPCs to stop evaluating at the first match (allows Fiona's Caravan locations to be accurate).
--			Changes use of GetQuestLogTitle(), and a lot more Blizzard API to handle WoD changes.
--			Corrects the problem where tracking quest acceptance, abandoning and completion was not set up properly based on saved preferences.
--			Splits out NPC names into separate localized files because Blizzard can no longer handle them in one.
--			Changes the Interface to 60000.
--		066 Updates some quest/NPC information.
--			Adds function FactionAvailable() to allow users to determine whether the faction is available for the player.
--		067	Updates some quest/NPC information.
--			Adds ability to indicate a quest rewards a follower.
--		068	Updates some quest/NPC information.
--			Adds ability to handle garrison building requirements for quests.
--			Adds ability to have level requirement for quest that differs from what Blizzard marks as their quest minimum level.
--		069	Updates some quest/NPC information.
--			Adds the ability to mark quests as bonus objective, rare mob and treasure.
--			Changes the Interface to 60200.
--		070	Updates some quest/NPC information.
--		071	Updates some quest/NPC information.
--			Adds new prerequisite code 'w' for group complete/turn in.
--			Adds the ability to record quest reward information.
--		072	Updates some quest/NPC information.
--		073	Updates some quest/NPC information.
--			Fixes the issue where the wrong API MeetsRequirementControl was being used.
--		074	Updates some quest/NPC information.
--			Adds IsPetBattle() API.
--			Adds the ability to have more than one X code requirement.
--			Corrects the implementation of AchievementComplete().
--			Implements some variations on some prerequisite codes.
--		075	Updates some quest/NPC information.
--			Adds support for bodyguard levels.
--			Adds support for Adventure Guide quests using the fake NPC ID 1, also using the fake map ID 1.
--			Corrects the implementation of _PhaseMatches() to properly note Frostwall level.
--			Adds support for events and more accurate holiday starts/stops.
--		076	Updates some quest/NPC information.
--			Corrects the problem where the map location is lost on UI reload.
--		077	Updates some quest/NPC information.
--			Adds the ability to support required NPCs working in garrison buildings.
--		078	Updates some quest/NPC information, especially for Legion.
--			Corrects Legion detection since release version is inadequate with the latest update Blizzard made to WoD live.
--		079	Updates some quest/NPC information, especially for Legion.
--			Corrects use of C_Garrison.GetGarrisonInfo() for Legion as it has changed.
--			Provides for prerequisites to require a specific player class.
--			Fixes an issue where Blizzard changed the C_Garrison.GetBuildings() API not in Legion beta, but in the live release based on it.
--			Changes the Interface to 70000.
--		080	Corrects a problem where learning a quest causes an error if nothing else already learned.
--			Updates some quest/NPC information for Legion.
--		081	Updates some quest/NPC information for Legion.
--			Adds factions for Legion.
--			Fixes the problem with strsplit error that can happen when first looting.
--		082	Updates some quest/NPC information for Legion.
--			Turns reputation recording system back on as Blizzard API seems to be working properly again.
--			Splits localized quest names into loadable addons.
--		083	Updates some quest/NPC information for Legion.
--		084	Adds the ability to know when world quests are available.
--			Updates some quest/NPC information for Legion, especially world quests.
--		085	Corrects problem where map was reseting to Eye of Azshara.
--			Updates some quest/NPC information for Legion.
--		086	Updates some quest/NPC information for Legion.
--			Adds capability to know when withering is happening with NPCs.
--		087	Updates some quest/NPC information for Legion.
--			Corrects problem where GrailDatabase.learned was not being initialized before accessed.
--			Uses Blizzard's new calendar API present in 7.2.
--		088	Changes the Interface to 70200
--			Updates some quest/NPC information for Legion.
--			Adds the ability to handle artifact levels which are required for some newer quests.
--		089	Corrects problem where garrison NPC building prerequisites was causing a Lua error.
--			Updates some quest/NPC information.
--		090	Updates some quest/NPC information.
--			Supports quests requiring paragon reputations.
--			Supports the Argus continent being introduced in 7.3.
--		091	Updates some quest/NPC information.
--			Updates the Interface to 70300.
--			Adds Argus zones to treasure looting.
--		092	Updates some quest/NPC information.
--			Corrects a problem where Loremaster quests were not listed correctly when there is more than one achievement in the same zone.
--			Corrects the problem where paragon faction levels were not reported properly after more than one reward achieved.
--		093	Updates some quest/NPC information.
--			Adds the ability to have class hall missions available as prerequisites.
--			Adds support for Allied races.
--			Changes CodeObtainers() to no longer return race information, which is now returned in a similar manner with CodeObtainersRace().
--		094	Corrects the problem where BloodElf was being overritten by Nightborne.
--		095 Update some quest/NPC information, but primarily the required level of thousands of quests due to Blizzard changing them.
--		096	Updates some quest/NPC information.
--			Handles Blizzard removing GetCurrentMapDungeonLevel() and GetCurrentMapAreaID().
--			Achievements are now indexed by the continent mapID instead of a one-up number.
--			The "continent" constants are removed from Grail as they were not used internally and serve no scalable purpose.
--			Continent information now uses Blizzard's new API for maps.
--			Updates use of UnitAura() to support Blizzard's changes for Battle for Azeroth.
--			Reimplements GetMapNameByID() because Blizzard removed it for Battle for Azeroth.
--			Starts reimplementing GetPlayerMapPosition() because Blizzard removes it for Battle for Azeroth.
--			Handles Blizzard's change of calendar APIs.
--		097	Updates some quest/NPC information.
--			Removes map setting code as it is not needed.
--			Checks whether locations have x and y coordinates before comparing.
--			Checks whether Blizzard map returns are rational before asking for player coordinates.
--			Ignores checking Thunder Isle for phasing for the moment.
--
--	Known Issues
--
--			The use of GetQuestResetTime() is not adequate, nor is the API good enough to provide us accurate information for weeklies (and possibly yearlies depending on when they actually reset compared to dailies).
--				The check is only made when a quest is accepted or completed, and this means the reset could happen during play and the Blizzard-provided data would be out of date until a restart or one of our
--				monitored events occurs.  This is the price one pays for not using something like OnUpdate.
--			Support for Neutral faction for starting Pandarens does not exist as it need not.  Quests are marked with a racial requirement, and the system
--				should handle the situation when the Pandaren chooses the desired faction.
--
--			Update the "BadQuestData" data recording/cleaning to handle the rest of the failure possibilities.
--			Need to make it so special quests with the same name AND same NPC ID can be handled.  For the Consortium gem quests I believe we will have to check the levels of the Consortium rep to know how to distinguish.
--			Need a time detection system because we need to know when we cross boundaries for things like the fishing holidays so we can turn the quests on or off appropriately.  This will also allow us to handle other time-based quests.  It means we will most likely use OnUpdate and the above comment will go away and we can actually put in a timer for the next quest reset time so we know when dailies reset.  Of course this means we may want to study the calendar to know when an upcoming event boundary will be crossed as well other than fishing (like Darkmoon Faire, etc.).
--			Need to be able to set Grail.playerFactionBitMask for a Pandaren if they start out playing before they select a faction, and then select a faction during play.  Otherwise they will be defaulted to Alliance which could prove problematic.
--
--			Determine if it is possible to notice when a faction is marked "at war" by the user so reputation checks against it take that into account because when one is "at war" the NPCs will not give the quests as expected.  If we can note whether at war then we need to mark NPCs as being associated with a specific faction.  If the NPC has a faction then we can check whether at war (or a low enough reputation with the faction).  Added _NPCFaction() to handle getting the data assuming we have it.
--
--			Finish the transition to supporting | with the last known routine for skipping over J codes properly.
--
--	UTF-8 file
--

--	Make local references to things in the global namespace to speed things up
local tinsert, tContains, tremove = tinsert, tContains, tremove
local strsplit, strfind, strformat, strsub, strlen, strgsub, strtrim, strgmatch = strsplit, string.find, string.format, string.sub, strlen, string.gsub, strtrim, string.gmatch
local strchar, strbyte = string.char, string.byte
local pairs, next = pairs, next
local tonumber, tostring = tonumber, tostring
local type = type
local print = print
local bitband, bitbnot, bitrshift, bitbxor, bitbor = bit.band, bit.bnot, bit.rshift, bit.bxor, bit.bor
local assert, wipe = assert, wipe
local floor, mod = math.floor, mod

--	The Blizzard API is separated out so it is easier to see what API is being used

-- AbandonQuest																	-- we rewrite this to our own function
local C_MapBar							= C_MapBar
local C_PetJournal						= C_PetJournal
local CreateFrame						= CreateFrame
local debugprofilestop					= debugprofilestop
local GetAchievementCriteriaInfoByID	= GetAchievementCriteriaInfoByID
local GetAchievementInfo				= GetAchievementInfo
local GetAddOnMetadata					= GetAddOnMetadata
local GetAverageItemLevel				= GetAverageItemLevel
local GetBuildInfo						= GetBuildInfo
local GetContainerItemID				= GetContainerItemID
local GetContainerNumSlots				= GetContainerNumSlots
local GetCurrentMapDungeonLevel			= GetCurrentMapDungeonLevel
local GetCVar							= GetCVar
local GetFactionInfoByID				= GetFactionInfoByID
local GetGameTime						= GetGameTime
local GetGuildLevel						= GetGuildLevel
local GetInstanceInfo					= GetInstanceInfo
local GetLocale							= GetLocale
local GetMapContinents					= GetMapContinents
local GetMapNameByID					= GetMapNameByID
local GetMapZones						= GetMapZones
local GetNumQuestLogEntries				= GetNumQuestLogEntries
local GetNumQuestLogRewardFactions		= GetNumQuestLogRewardFactions
local GetProfessionInfo					= GetProfessionInfo
local GetProfessions					= GetProfessions
local GetRealmName						= GetRealmName
local GetQuestGreenRange				= GetQuestGreenRange
local GetQuestLogRewardFactionInfo		= GetQuestLogRewardFactionInfo
local GetQuestLogSelection				= GetQuestLogSelection
local GetQuestResetTime					= GetQuestResetTime
local GetQuestsCompleted				= GetQuestsCompleted					-- GetQuestsCompleted is special because in modern environments we define it ourselves
local GetSpellBookItemInfo				= GetSpellBookItemInfo
local GetSpellBookItemName				= GetSpellBookItemName
local GetSpellLink						= GetSpellLink
local GetSpellTabInfo					= GetSpellTabInfo
local GetText							= GetText
local GetTime							= GetTime
local GetTitleText						= GetTitleText
--local InCombatLockdown					= InCombatLockdown
local IsQuestFlaggedCompleted			= IsQuestFlaggedCompleted
local QueryQuestsCompleted				= QueryQuestsCompleted					-- QueryQuestsCompleted is special because in modern environments we define it ourselves
local SelectQuestLogEntry				= SelectQuestLogEntry
-- SendQuestChoiceResponse														-- we rewrite this to our own function
-- SetAbandonQuest																-- we rewrite this to our own function
local UnitAura							= UnitAura
local UnitClass							= UnitClass
local UnitFactionGroup					= UnitFactionGroup
local UnitGUID							= UnitGUID
local UnitLevel							= UnitLevel
local UnitName							= UnitName
local UnitRace							= UnitRace
local UnitSex							= UnitSex

local BOOKTYPE_SPELL					= BOOKTYPE_SPELL
local DAILY								= DAILY
local LOCALIZED_CLASS_NAMES_FEMALE		= LOCALIZED_CLASS_NAMES_FEMALE
local LOCALIZED_CLASS_NAMES_MALE		= LOCALIZED_CLASS_NAMES_MALE
local QuestFrameCompleteQuestButton		= QuestFrameCompleteQuestButton
local REPUTATION						= REPUTATION
local UIParent							= UIParent

local directoryName, _ = ...
local versionFromToc = GetAddOnMetadata(directoryName, "Version")
local _, _, versionValueFromToc = strfind(versionFromToc, "(%d+)")
local Grail_File_Version = tonumber(versionValueFromToc)

if nil == Grail or Grail.versionNumber < Grail_File_Version then

	-- Blizzard is removing GetMapNameByID in the 8.x release
	-- so instead of rewriting all the code that makes use of
	-- it, I am reimplemting it here.  It is done here before
	-- the setup of Grail because it is used in setting up of
	-- some faux quest names.
	if nil == GetMapNameByID then
		GetMapNameByID = function(mapId)
			local mapInfo = mapId and C_Map.GetMapInfo(mapId) or nil
			return mapInfo and mapInfo.name or nil
		end
	end

	if nil == CalendarGetDate then
		CalendarGetDate = function()
			local date = C_Calendar.GetDate();
			return date.weekday, date.month, date.monthDay, date.year
		end
	end

	--	Grail uses self.inCombat to determine whether the player is in combat.  This
	--	is set true when PLAYER_REGEN_DISABLED is received, and cleared when
	--	PLAYER_REGEN_ENABLED is received.  This seems to be a better measure than
	--	calling InCombatLockdown().

	--
	--	Even though it is documented that UNIT_QUEST_LOG_CHANGED is preferable to QUEST_LOG_UPDATE, in practice UNIT_QUEST_LOG_CHANGED fails
	--	to do what it is supposed to do.  In fact, processing cannot properly happen using it and not QUEST_LOG_UPDATE, even with proper
	--	priming of the data structures.  Therefore, this addon makes use of QUEST_LOG_UPDATE instead.  Actually, this has proven to be a
	--	little unreliable as well, so a hooked function is now used instead.

	--	It would be really convenient to be able not to store the localized names of the quests and the NPCs.  However, the only real way
	--	to get any arbitrary one (that is not in the quest log) is to populate the tooltip with a hyperlink.  However, that will not normally
	--	return results immediately from a server query, so another attempt at tooltip population is needed.  In the case of quests, this
	--	works pretty well.  However, with NPCs the results are less than satisfactory.  In reality, we want the information to be readily
	--	available for when someone needs it, so polling the server is not convenient.  Therefore, we will continue to store the localized
	--	names of these objects so they are available immediately to the caller.  This means the size of the add-on in memory is going to
	--	be constant and not growing overtime if we were to attempt to populate the information in the background (which we would want to do
	--	to make the information available).

	--	Instead of trying to deal with the concept of having NPCs who have unique IDs to be associated with each other but only be available
	--	in specific "phases", the availability of an NPC should probably be checked through the use of determining whether a quest can be
	--	obtained.  Normally, the prerequisite structure of the quests will indicate specific quests cannot yet be obtained, and those are
	--	likely to be associated with the NPCs that will be in new "phases".  Therefore, nothing special needs be done in this library, but
	--	the onus can be put on the user of this library to ensure only quest givers for available quests are listed/shown.

	--	The Blizzard quest log list cannot reliably be queried upon startup until after the PLAYER_ALIVE event has been received.  However,
	--	setting a flag during that event processing will not work since reloading the UI will not cause PLAYER_ALIVE to be sent again, but
	--	will cause the flag to be reset.  It appears under brief testing that QUEST_LOG_UPDATE fires after PLAYER_ALIVE on normal login, and
	--	fires sometime after PLAYER_LOGIN after a UI reload.  Therefore, the flag will be set in QUEST_LOG_UPDATE event processing.

	--	Another issue is the fact that the calendar API cannot be properly used to get real data until OpenCalendar() has returned something
	--	useful, which cannot occur until later in the login sequence.  And trying to call OpenCalendar() without calling CalendarSetAbsMonth()
	--	beforehand makes it so the call does nothing and the CALENDAR_UPDATE_EVENT_LIST event is never sent.

	--
	--	Caching of the quest status.
	--
	--	If the status of a quest is requested, and that status already exists in the cache, then the cache results
	--	should be returned.  When the status of a quest is computed it is added to the quest status cache.  The
	--	cache of a quest status can be invalidated based on what happens in the environment and the status of the
	--	quest.  For example, if a quest was marked as being too high for the player to obtain, but the player gains
	--	a level, that quest status in the cache needs to be removed so it can be recomputed when needed.
	--

	--	For some quests Blizzard marks others complete when you complete one.  For example, Firelands dailies are in groups and when you
	--	finish one, the others are marked complete on the server.  This tends not to be a problem.  However, Blizzard also does this with
	--	quests the player would never be able to acquire, like the starting zone class-specific quests.  So, when a mage completes its
	--	class quest the server marks the class quests for hunter, warrior, etc. also complete.  This seems idiotic as Blizzard already has
	--	other mechanisms to limit a mage from getting a hunter quest, for example.  This causes a problem with the way Grail evaluates the
	--	status of a quest, since it is done "live" because quests have so many relationships.  In general, the quests that one could never
	--	aquire are evaluated such during play, and in the future when they are marked complete on the server they will be both marked
	--	complete since we must believe what the server reports, and will be marked unobtainable for whatever reasons are appropriate.
	--	This works well except for when we attempt to evaluate prerequisites because part of prerequisites is to see if the required quest
	--	is complete.  However, we also check to see whether the quest can be obtained.  The flaw that we currently have is that we are
	--	evaluating whether the quest can be obtained currently, which is technically incorrect because it should be can the quest be
	--	obtained at the time the quest is marked complete.  Of course we can only know this if we keep track of which specific quests are
	--	marked complete when any other is done.  This is yet another level of annoyance that Blizzard causes that it need not.  So, Grail
	--	is going to approximate this for the time being with evaluating the current ability to accept a quest that was complete.

	--	Blizzard seems to have some internal method of determining state with regard to quests that is not flagged using another quest.
	--	They do use other quests sometimes, but not all the time.  Therefore, to ensure we keep a similar state bogus quests are used within
	--	the database, but these are not going to be present from the server query.  Therefore, this state is kept in controlCompletedQuests
	--	which will be checked every time the results from the server query are processed to ensure the internally kept master completed
	--	quests include them.

	--	Database of stored information per character.
	GrailDatabasePlayer = {}
	GrailDatabase = { silent = true }
	--	The completedQuests is a table of 32-bit integers.  The index in the table indicates which set of 32 bits are being used and the value at that index
	--	is a bit representation of completed quests in that 32 quest range.  For example, quest 7 being the only one completed in the quests from 1 to 32
	--	would mean table entry 0 would have a value of 64.  Quest 33 being done would mean [1] = 1, while quests 33 and 35 would mean [1] = 5.  The user need
	--	not know any of this since the API to access this information takes care of the dirty work.
	--	The completedResettableQuests is just like completedQuests except it records only those quests that Blizzard resets like dailies and weeklies.  This
	--	is used for API that can determine if a quest has ever been completed (since a daily could have been completed in the past, but Blizzard's API would
	--	indicate that it is currently not completed (because it has been reset)).
	--	There are four possible tables of interest:  NewNPCs, NewQuests, SpecialQuests and BadQuestData.
	--	These tables could be used to provide feedback which can be used to update the internal database to provide more accurate quest information.

	Grail = {
experimental = false,	-- currently this implementation does not reduce memory significantly [this is used to make the map area hold quests in bit form]
		versionNumber = Grail_File_Version,
		questsVersionNumber = 0,
		npcsVersionNumber = 0,
		npcNamesVersionNumber = 0,
		zonesVersionNumber = 0,
		zonesIndexedVersionNumber = 0,
		achievementsVersionNumber = 0,
		reputationsVersionNumber = 0,
		buggedQuestsVersionNumber = 0,
		INFINITE_LEVEL = 100000,
		NO_SKILL = -1,
		NPC_TYPE_BY = 'BY',
		NPC_TYPE_DROP = 'DROP',
		NPC_TYPE_KILL = 'KILL',
		abandonPostNotificationDelay = 1.0,
		abandoningQuestIndex = nil,
		artifactLevels = {},	-- key is itemID, value is level
		availableWorldQuests = {},

		-- Bit mask system for quest status
		-- First bits are "good" bits
		bitMaskNothing							= 0x00000000,
		bitMaskCompleted						= 0x00000001,
		bitMaskRepeatable						= 0x00000002,
		bitMaskResettable						= 0x00000004,
		bitMaskEverCompleted					= 0x00000008,
		bitMaskInLog							= 0x00000010,
		bitMaskLevelTooLow						= 0x00000020,		-- the player's level is too low for the quest currently
		bitMaskLowLevel							= 0x00000040,		-- the quest is a low-level quest compared to the player's level
		-- These are really failure bits
		bitMaskClass							= 0x00000080,
		bitMaskRace								= 0x00000100,
		bitMaskGender							= 0x00000200,
		bitMaskFaction							= 0x00000400,
		bitMaskInvalidated						= 0x00000800,
		bitMaskProfession						= 0x00001000,
		bitMaskReputation						= 0x00002000,
		bitMaskHoliday							= 0x00004000,
		bitMaskLevelTooHigh						= 0x00008000,		-- the player's level is too high for the quest
		-- This next one indicates no prerequisites have been fulfilled
		bitMaskPrerequisites					= 0x00010000,
		-- These are failure bits for ancestor quests if bitMaskPrerequisites is set.  They are the same
		-- as the previous set of failure bits * 1024
		bitMaskAncestorClass					= 0x00020000,
		bitMaskAncestorRace						= 0x00040000,
		bitMaskAncestorGender					= 0x00080000,
		bitMaskAncestorFaction					= 0x00100000,
		bitMaskAncestorInvalidated				= 0x00200000,
		bitMaskAncestorProfession				= 0x00400000,
		bitMaskAncestorReputation				= 0x00800000,
		bitMaskAncestorHoliday					= 0x01000000,
		bitMaskAncestorLevelTooHigh				= 0x02000000,
		-- Informational bits
		bitMaskInLogComplete					= 0x04000000,
		bitMaskInLogFailed						= 0x08000000,
		bitMaskResettableRepeatableCompleted	= 0x10000000,
		bitMaskBugged							= 0x20000000,
		-- These basically represent internal errors within the database
		bitMaskNonexistent						= 0x40000000,
		bitMaskError							= 0x80000000,
		-- Some convenience values precomputed
		bitMaskQuestFailure = 0xff80,	-- from bitMaskClass to bitMaskLevelTooHigh
		bitMaskQuestFailureWithAncestor = 0x03feff80,	-- bitMaskQuestFailure + (bitMaskAncestorClass to bitMaskAncestorLevelTooHigh)
		bitMaskAcceptableMask = 0xcfffffb1,	-- all bits except bitMaskRepeatable, bitMaskResettable, bitMaskEverCompleted, bitMaskResettableRepeatableCompleted and bitMaskLowLevel and now bitMaskBugged
		-- End of Bit mask values


		-- Bit mask system for other quest information indicating who can get a quest
		-- Faction
		bitMaskFactionAlliance	=	0x00000001,
		bitMaskFactionHorde		=	0x00000002,
		-- Class
		bitMaskClassDeathKnight	=	0x00000004,
		bitMaskClassDruid		=	0x00000008,
		bitMaskClassHunter		=	0x00000010,
		bitMaskClassMage		=	0x00000020,
		bitMaskClassMonk		=	0x00000040,
		bitMaskClassPaladin		=	0x00000080,
		bitMaskClassPriest		=	0x00000100,
		bitMaskClassRogue		=	0x00000200,
		bitMaskClassShaman		=	0x00000400,
		bitMaskClassWarlock		=	0x00000800,
		bitMaskClassWarrior		=	0x00001000,
		-- Gender
		bitMaskGenderMale		=	0x00002000,
		bitMaskGenderFemale		=	0x00004000,
		-- Unused
		bitMaskCanGetUnused1	=	0x00008000,
		bitMaskCanGetUnused2	=	0x00010000,
		bitMaskCanGetUnused3	=	0x00020000,
		bitMaskCanGetUnused4	=	0x00040000,
		bitMaskCanGetUnused5	=	0x00080000,
		bitMaskCanGetUnused6	=	0x00100000,
		bitMaskCanGetUnused7	=	0x00200000,
		bitMaskCanGetUnused8	=	0x00400000,
		bitMaskCanGetUnused9	=	0x00800000,
		bitMaskCanGetUnused10	=	0x01000000,
		bitMaskCanGetUnused11	=	0x02000000,
		bitMaskCanGetUnused12	=	0x04000000,
		bitMaskCanGetUnused13	=	0x08000000,
		bitMaskClassDemonHunter =	0x10000000,	-- *** CLASS ***, kept in bit order
		bitMaskCanGetUnused14	=	0x20000000,
		bitMaskCanGetUnused15	=	0x40000000,
		bitMaskCanGetUnused16	=	0x80000000,
		-- Some convenience values
		bitMaskFactionAll		=	0x00000003,
		bitMaskClassAll			=	0x10001ffc,
		bitMaskGenderAll		=	0x00006000,
		-- End of bit mask values

		-- Bit mask system for which race can get a quest
		bitMaskRaceHighmountainTauren	=	0x00000001,
		bitMaskRaceNightborne			=	0x00000002,
		bitMaskRaceDarkIronDwarf		=	0x00000004,
		bitMaskRaceMagharOrc			=	0x00000008,
			bitMaskRaceUnused1			=	0x00000010,
			bitMaskRaceUnused2			=	0x00000020,
			bitMaskRaceUnused3			=	0x00000040,
			bitMaskRaceUnused4			=	0x00000080,
			bitMaskRaceUnused5			=	0x00000100,
			bitMaskRaceUnused6			=	0x00000200,
			bitMaskRaceUnused7			=	0x00000400,
			bitMaskRaceUnused8			=	0x00000800,
			bitMaskRaceUnused9			=	0x00001000,
			bitMaskRaceUnused10			=	0x00002000,
			bitMaskRaceUnused11			=	0x00004000,
		bitMaskRaceHuman				=	0x00008000,
		bitMaskRaceDwarf				=	0x00010000,
		bitMaskRaceNightElf				=	0x00020000,
		bitMaskRaceGnome				=	0x00040000,
		bitMaskRaceDraenei				=	0x00080000,
		bitMaskRaceWorgen				=	0x00100000,
		bitMaskRaceOrc					=	0x00200000,
		bitMaskRaceScourge				=	0x00400000,
		bitMaskRaceTauren				=	0x00800000,
		bitMaskRaceTroll				=	0x01000000,
		bitMaskRaceBloodElf				=	0x02000000,
		bitMaskRaceGoblin				=	0x04000000,
		bitMaskRacePandaren				=	0x08000000,
		bitMaskZandalariTroll			=	0x10000000,
		bitMaskRaceVoidElf				=	0x20000000,
		bitMaskRaceLightforgedDraenei	=	0x40000000,
		bitMaskKulTiran					=	0x80000000,
		-- Convenience values
		bitMaskRaceAll			=	0x6fff8003,
		-- Enf of bit mask values


		-- Bit mask system for information about type of quest
		bitMaskQuestRepeatable	=	0x00000001,
		bitMaskQuestDaily		=	0x00000002,
		bitMaskQuestWeekly		=	0x00000004,
		bitMaskQuestMonthly		=	0x00000008,
		bitMaskQuestYearly		=	0x00000010,
		bitMaskQuestEscort		=	0x00000020,
		bitMaskQuestDungeon		=	0x00000040,
		bitMaskQuestRaid		=	0x00000080,
		bitMaskQuestPVP			=	0x00000100,
		bitMaskQuestGroup		=	0x00000200,
		bitMaskQuestHeroic		=	0x00000400,
		bitMaskQuestScenario	=	0x00000800,
		bitMaskQuestLegendary	=	0x00001000,
		bitMaskQuestAccountWide	=	0x00002000,
		bitMaskQuestPetBattle	=	0x00004000,
		bitMaskQuestBonus		=	0x00008000,		-- bonus objective
		bitMaskQuestRareMob		=	0x00010000,		-- rare mob
		bitMaskQuestTreasure	=	0x00020000,
		bitMaskQuestWorldQuest	=	0x00040000,
		bitMaskQuestBiweekly	=	0x00080000,
-- 		lots of unused bits we can still abuse :-)
		bitMaskQuestSpecial		=	0x80000000,		-- quest is "special" and never appears in the quest log
		-- End of bit mask values


		-- Bit mask system for information about level of quest
		-- Eight bits are used to be able to represent a level value from 0 - 255.
		-- Three sets of those eight bits are used to represent the actual level
		-- of the quest, the minimum level required for the quest, and the maximum
		-- level allowed to accept the quest.  Some quests have a variable level
		-- and this is now supported in the bit structure as well.
		bitMaskQuestLevel				=	0x000000ff,
		bitMaskQuestMinLevel			=	0x0000ff00,
		bitMaskQuestMaxLevel			=	0x00ff0000,
		bitMaskQuestVariableLevel		=	0xff000000,
		bitMaskQuestLevelOffset			=	0x00000001,
		bitMaskQuestMinLevelOffset		=	0x00000100,
		bitMaskQuestMaxLevelOffset		=	0x00010000,
		bitMaskQuestVariableLevelOffset	=	0x01000000,
		-- End of bit mask values


		-- Bit mask system for holidays
		bitMaskHolidayLove		=	0x00000001,
		bitMaskHolidayBrewfest	=	0x00000002,
		bitMaskHolidayChildren	=	0x00000004,
		bitMaskHolidayDead		=	0x00000008,
		bitMaskHolidayDarkmoon	=	0x00000010,
		bitMaskHolidayHarvest	=	0x00000020,
		bitMaskHolidayLunar		=	0x00000040,
		bitMaskHolidayMidsummer	=	0x00000080,
		bitMaskHolidayNoble		=	0x00000100,
		bitMaskHolidayPirate	=	0x00000200,
		bitMaskHolidayNewYear	=	0x00000400,
		bitMaskHolidayWinter	=	0x00000800,
		bitMaskHolidayHallow	=	0x00001000,
		bitMaskHolidayPilgrim	=	0x00002000,
		bitMaskHolidayChristmas	=	0x00004000,
		bitMaskHolidayFishing	=	0x00008000,
		bitMaskHolidayKaluak    =   0x00010000,
		-- End of bit mask values

		bodyGuardLevel = { 'Bodyguard', 'Trusted Bodyguard', 'Personal Wingman' },
		buggedQuests = {},	-- index is the questId, value is a string describing issue/solution

		cachedBagItems = nil,
		--	This is used to speed up getting the status of each quest because there is a routine that needs to find whether
		--	any specific quest is already in the quest log.  When evaluating many quests this check of quests in the quest
		--	log would be made at least once for each quest, so caching makes things a little quicker.
		cachedQuestsInLog = nil,
		checksReputationRewardsOnAcceptance = true,
		classMapping = { ['K'] = 'DEATHKNIGHT', ['D'] = 'DRUID', ['H'] = 'HUNTER', ['M'] = 'MAGE', ['O'] = 'MONK', ['P'] = 'PALADIN', ['T'] = 'PRIEST', ['R'] = 'ROGUE', ['S'] = 'SHAMAN', ['L'] = 'WARLOCK', ['W'] = 'WARRIOR', },
		classToBitMapping = { ['K'] = 0x00000004, ['D'] = 0x00000008, ['H'] = 0x00000010, ['M'] = 0x00000020, ['O'] = 0x00000040, ['P'] = 0x00000080, ['T'] = 0x00000100, ['R'] = 0x00000200, ['S'] = 0x00000400, ['L'] = 0x00000800, ['W'] = 0x00001000, },
		classToMapAreaMapping = { ['CK'] = 200011, ['CD'] = 200004, ['CH'] = 200008, ['CM'] = 200013, ['CO'] = 200015, ['CP'] = 200016, ['CT'] = 200020, ['CR'] = 200018, ['CS'] = 200019, ['CL'] = 200012, ['CW'] = 200023, },
		completedQuestThreshold = 0.5,
		completingQuest = nil,
		completingQuestTitle = nil,
		continents = {},	-- key is mapId for the continent, value is { name = string, zones = {}, mapID = int, dungeons = {} }
							-- and zones and dungeons are just arrays of { name = string, mapID = int }
		currentlyProcessingStatus = {},
		currentlyVerifying = false,
		currentMortalIssues = {},
		currentQuestIndex = nil,
		debug = false,
		defaultUnfoundLootingName = "No name gotten",
		delayBagUpdate = 0.5,
		delayedEvents = {},
		delayedEventsCount = 0,
		delayQuestRemoved = 4.5,
		eventDispatch = {			-- table of functions whose keys are the events

			['ACHIEVEMENT_EARNED'] = function(self, frame, arg1)
				local achievementNumber = tonumber(arg1)
				if nil ~= achievementNumber and nil ~= self.questStatusCache['A'][achievementNumber] then
					if not self.inCombat or not GrailDatabase.delayEvents then
						self:_HandleEventAchievementEarned(achievementNumber)
					else
						self:_RegisterDelayedEvent(frame, { 'ACHIEVEMENT_EARNED', achievementNumber } )
					end
				end
			end,

			['ADDON_LOADED'] = function(self, frame, arg1)
				if "Grail" == arg1 then

                    GrailDatabase = GrailDatabase or {}
                    GrailDatabase.learned = GrailDatabase.learned or {}

					local debugStartTime = debugprofilestop()
					--
					--	First pull some information about the player and environment so it can be recorded for easier access
					--
					local _
					self.playerRealm = GetRealmName()
					self.playerName = UnitName('player')
					_, self.playerClass = UnitClass('player')
					_, self.playerRace = UnitRace('player')
					self.playerFaction = UnitFactionGroup('player')		-- for Pandaren who has not chosen results is "Neutral"
					self.playerGender = UnitSex('player')
					self.playerLocale = GetLocale()
					self.levelingLevel = UnitLevel('player')
					local version, release, date, tocVersion = GetBuildInfo()
					self.blizzardRelease = tonumber(release)
					self.blizzardVersion = version
					self.blizzardVersionAsNumber = self:_MakeNumberFromVersion(self.blizzardVersion)
					self.portal = GetCVar("portal")

                    -- These values are no longer used, but kept for posterity.
					self.existsPandaria = (self.blizzardRelease >= 15640)
					self.existsWoD = (self.blizzardRelease >= 18505)
					self.existsLegion = (self.blizzardRelease >= 21531 and self.blizzardVersionAsNumber >= 7000000)
					self.exists72 = (self.blizzardRelease >= 23578)
					self.exists73 = (self.blizzardRelease >= 24563 and self.blizzardVersionAsNumber >= 7003000)
					self.battleForAzeroth = (self.blizzardRelease >= 26175 and self.blizzardVersionAsNumber >= 8000000)

					-- We have loaded GrailDatabase at this point, but we need to ensure the structure is set up for first-time players as we rely on at least an empty structure existing
					GrailDatabasePlayer = GrailDatabasePlayer or {}

					if self.battleForAzeroth then
						self.zonesForLootingTreasure = {
							[525] = true,
							[534] = true,
							[535] = true,
							[539] = true,
							[542] = true,
							[543] = true,
							[550] = true,
							[554] = true,
							[625] = true,
							[630] = true,
							[634] = true,
							[641] = true,
							[646] = true,
							[649] = true,
							[650] = true,
							[672] = true,
							[677] = true,
							[680] = true,
							[750] = true,
							[790] = true,
							[830] = true,
							[882] = true,
							[885] = true,
							-- the following are the BfA maps (the three in Zandalar and three in Kul Tiras)
							[862] = true, -- Zuldazar (primarily horde)
							[863] = true, -- Nazmir (primarily horde)
							[864] = true, -- Vol'dun (primarily horde)
							[895] = true, -- Tiragarde Sound (primarily alliance)
							[896] = true, -- Drustvar (primarily alliance)
							[942] = true, -- Stormsong Valley (primarily alliance)
							[1165] = true, -- Dazar'Alor (primarily horde)
							}
						self.quest.name = {
							[51570]=GetMapNameByID(862),	-- Zuldazar
							[51571]=GetMapNameByID(863),	-- Nazmir
							[51572]=GetMapNameByID(864),	-- Vol'dun
							[600000]=GetMapNameByID(17)..' '..REQUIREMENTS,
							[600001]=GetMapNameByID(17)..' '..FACTION_ALLIANCE..' '..REQUIREMENTS,
							[600002]=GetMapNameByID(17)..' '..FACTION_HORDE..' '..REQUIREMENTS,
							}
					end

					--	For users prior to the release version 028, the GrailDatabase held personal quest information.  Now we move that information into the
					--	new structure GrailDatabasePlayer so it can be separated from the information that would be reported.
					if GrailDatabase[self.playerRealm] then
						if GrailDatabase[self.playerRealm][self.playerName] then
							GrailDatabasePlayer["completedQuests"] = GrailDatabase[self.playerRealm][self.playerName]["completedQuests"]
							GrailDatabasePlayer["completedResettableQuests"] = GrailDatabase[self.playerRealm][self.playerName]["completedResettableQuests"]
							GrailDatabasePlayer["actuallyCompletedQuests"] = GrailDatabase[self.playerRealm][self.playerName]["actuallyCompletedQuests"]
							GrailDatabasePlayer["controlCompletedQuests"] = GrailDatabase[self.playerRealm][self.playerName]["controlCompletedQuests"]
							GrailDatabase[self.playerRealm][self.playerName] = nil
						end
						local realmCount = 0
						for n, v in pairs(GrailDatabase[self.playerRealm]) do
							if nil ~= v then realmCount = realmCount + 1 end
						end
						if 0 == realmCount then GrailDatabase[self.playerRealm] = nil end
					end

					GrailDatabasePlayer.completedQuests = GrailDatabasePlayer.completedQuests or {}
					GrailDatabasePlayer.completedResettableQuests = GrailDatabasePlayer.completedResettableQuests or {}
					GrailDatabasePlayer.actuallyCompletedQuests = GrailDatabasePlayer.actuallyCompletedQuests or {}
					GrailDatabasePlayer.controlCompletedQuests = GrailDatabasePlayer.controlCompletedQuests or {}
					GrailDatabasePlayer.abandonedQuests = GrailDatabasePlayer.abandonedQuests or {}
					GrailDatabasePlayer.spellsCast = GrailDatabasePlayer.spellsCast or {}
					GrailDatabasePlayer.buffsExperienced = GrailDatabasePlayer.buffsExperienced or {}
					GrailDatabasePlayer.dailyGroups = GrailDatabasePlayer.dailyGroups or {}

					-- See if we can load LibArtifactData
--					local LibStub = _G["LibStub"]
--					if LibStub then
--						self.LAD = LibStub("LibArtifactData-1.0", true)
--						if nil ~= self.LAD then
--							--	Note that reading the scroll to raise the artifact knowledge level does not trigger this event
--							self.LAD.RegisterCallback(self, "ARTIFACT_KNOWLEDGE_CHANGED", "ArtifactChange")
--						end
--					end

					for i = 1, self.invalidateGroupHighestValue do
						self.invalidateControl[i] = {}
					end

					if self.forceLocalizedQuestNameLoad then
						self:LoadAddOn("Grail-Quests-" .. self.playerLocale)
					end
					self:LoadAddOn("Blizzard_ArtifactUI")

					--
					--	Create the tooltip that we use for getting information like NPC name
					--
					self.tooltip = CreateFrame("GameTooltip", "com_mithrandir_grailTooltip", UIParent, "GameTooltipTemplate")
					self.tooltip:SetFrameStrata("TOOLTIP")
					self.tooltip:Hide()

					self.tooltipNPC = CreateFrame("GameTooltip", "com_mithrandir_grailTooltipNPC", UIParent, "GameTooltipTemplate")
					self.tooltipNPC:SetFrameStrata("TOOLTIP")
					self.tooltipNPC:Hide()

					--
					--	Set up the slash command
					--
					SlashCmdList["GRAIL"] = function(msg)
						self:_SlashCommand(frame, msg)
					end
					SLASH_GRAIL1 = "/grail"

					--
					--	For verification of NPC information the tooltips can return a string
					--	that indicates the server is being queried.  Therefore, we record the
					--	localized version of it here so it can be used in comparisons.
					--
					if self.playerLocale == "enUS" or self.playerLocale == "enGB" then
						self.retrievingString = "Retrieving item information"
					elseif self.playerLocale == "deDE" then
						self.retrievingString = "Frage Gegenstandsinformationen ab"
					elseif self.playerLocale == "esES" or self.playerLocale == "esMX" then
						self.retrievingString = "Obteniendo información de objeto"
					elseif self.playerLocale == "frFR" then
						self.retrievingString = "Récupération des informations de l'objet"
					elseif self.playerLocale == "itIT" then
    				   self.retrievingString = "Recupero dati oggetto"
					elseif self.playerLocale == "koKR" then
						self.retrievingString = "아이템 정보 검색"
					elseif self.playerLocale == "ptBR" then
						self.retrievingString = "Recuperando informações do item"
					elseif self.playerLocale == "ruRU" then
						self.retrievingString = "Получение сведений о предмете"
					elseif self.playerLocale == "zhTW" then
						self.retrievingString = "讀取物品資訊"
					elseif self.playerLocale == "zhCN" then
						self.retrievingString = "正在获取物品信息"
					else
						self.retrievingString = "Unknown"
					end

					--
					--	Blizzard has changed the way one queries to determine what quests are complete.
					--	Prior to Mists of Pandaria the architecture required a call to be made to the
					--	server, and when the server was ready it would post an event.  Processing based
					--	on that event allowed the server's view of completed quests to be known.  With
					--	Mists of Pandaria, the architecture changed on Blizzard's side.  However, this
					--	addon needed to operate in both the prerelease of MoP and the live version with
					--	the two different server query architectures.  So instead of changing the way
					--	Grail works, Grail detects the API changes in the Blizzard environment and does
					--	the right things, allowing the same addon to work in both environments.
					--
					if nil == QueryQuestsCompleted then
						QueryQuestsCompleted = function() Grail:_ProcessServerQuests() end
					end
					if nil == GetQuestsCompleted then
						GetQuestsCompleted = function(t)
							for questId in pairs(Grail.questCodes) do
								if IsQuestFlaggedCompleted(questId) then
									t[questId] = true
								end
							end
						end
					end

					--	Unfortunately Blizzard event system is not robust enough to provide us the data
					--	we need to function properly.  Therefore, we override some of the API that the
					--	Blizzard UI uses regarding quests.
					--
					-- Now to hook the QuestRewardCompleteButton_OnClick function
					if not self.existsWoD then
						self.origHookFunction = QuestFrameCompleteQuestButton:GetScript("OnClick")
						QuestFrameCompleteQuestButton:SetScript("OnClick", function() self:_QuestRewardCompleteButton_OnClick() end);
					end

					self.origAbandonQuestFunction = SetAbandonQuest
					SetAbandonQuest = function() self:_QuestAbandonStart() end

					self.origConfirmAbandonQuestFunction = AbandonQuest
					AbandonQuest = function() self:_QuestAbandonStop() end

					--	For the choice of types of quest on Isle of Thunder the following function is eventually
					--	called with anId which is associated with the button in the UI.
					self.origSendQuestChoiceResponseFunction = SendQuestChoiceResponse
					SendQuestChoiceResponse = function(anId) self:_SendQuestChoiceResponse(anId) end

					--	Specific quests become available when certain interactions are done with specific NPCs so
					--	we use this routine in conjunction with the GOSSIP_SHOW and GOSSIP_CLOSED events to determine
					--	if we are to do anything.  GOSSIP_SHOW will record the NPC and GOSSIP_CLOSED will reset it.
					hooksecurefunc("SelectGossipOption", function(index, text, confirm)
--						print("Gossip index selected:", index, text, confirm)
						local questToComplete = nil
						local gossipTable = self.currentGossipNPCId and self.gossipNPCs[self.currentGossipNPCId] or nil
						if gossipTable then
							if gossipTable[index] then
								-- gossipTable[index] should have two items: [1] the questId, [2] any prerequisites required
								-- if the prerequisites are empty or evaluate to true then questToComplete gets set to the questId
								local prereqs = gossipTable[index][2]
								if nil == prereqs or ("table" == type(prereqs) and 0 == #prereqs) or self:_AnyEvaluateTrueF(prereqs, nil, Grail._EvaluateCodeAsPrerequisite) then
									questToComplete = gossipTable[index][1]
								end
							end
						end
						if nil ~= questToComplete then
							self:_MarkQuestComplete(questToComplete, true)
						end
					end)

					--
					--	The basic quest information is loaded from a file.  However, we need to create internal structures
					--	that are used as caches to ensure processing of information is done as quickly as possible.  Here
					--	we set up the basic structures that hold information outside of the quests themselves.
					--
					if nil == self.questStatusCache then
						-- quests is a table whose indexes are questIds and values are the actual bit mask status
						-- A is a table whose key is an achievement ID and whose value is a table of quests assocaited with it
						-- B is a table whose key is a buff ID and whose value is a table of quests associated with it
						-- C is a table whose key is an item ID whose presence is needed and whose value is a table of quests associated with it
						-- D is a table whose indexes are questIds and values are tables of questIds that need to be invalidated when the index is no longer in the quest log
						-- E is a table whose key is an item ID whose presence is NOT wanted and whose value is a table of quests associated with it
						-- F is a table whose key is a questId that when abandoned needs to have the table of associated quests invalidated
						-- G is a table whose key is a group number and whose value is a table of quests associated with it
						-- H is a table whose key is a questId and whose value is a table of groups associated with it
						-- I is a table whose indexes are questIds and values are tables of questIds that suffer bitMaskInvalidated from the quest that is the index
						-- L is a table of questIds who fail because of bitMaskLevelTooLow
						-- M is a table of questIds that require garrison buildings
						-- P is a table of questIds who fail because of bitMaskProfession
						-- Q is a table whose indexes are questIds and values are tables of questIds that suffer bitMaskPrerequisites from the quest that is the index
						-- R is a table of questIds who fail because of bitMaskReputation
						-- S is a table whose key is a spellId whose presence is needed and whose value is a table of quests associated with it
						-- V is a table of questIds for quests that are NOT marked bitMaskLowLevel because gaining levels can change that value
						-- W is a table whose key is a group number and whose value is a table of quests interested in that group.  this differs from G because that is a list of all quests in the group
						-- X is a table whose key is a group number and whose value is a table of quests interested in that group for accepting.
						-- Y is a table whose key is a spellId that has ever been experienced and whose value is a table of quests associated with it
						-- Z is a table whose key is a spellId that has ever been cast and whose value is a table of quests associated with it
						self.questStatusCache = { ["L"] = {}, ["P"] = {}, ["R"] = {}, ["I"] = {}, ["Q"] = {}, ["V"] = {}, ["A"] = {}, ["B"] = {}, ["D"] = {}, ["C"] = {}, ["E"] = {}, ["F"] = {}, ["S"] = {}, ["Y"] = {}, ["Z"] = {}, ["G"] = {}, ["H"] = {}, ["W"] = {}, ["X"] = {}, }
						self.npcStatusCache = { ["L"] = {}, ["P"] = {}, ["R"] = {}, ["I"] = {}, ["Q"] = {}, ["V"] = {}, ["A"] = {}, ["B"] = {}, ["D"] = {}, ["C"] = {}, ["E"] = {}, ["F"] = {}, ["S"] = {}, ["Y"] = {}, ["Z"] = {}, ["G"] = {}, ["H"] = {}, ["W"] = {}, ["X"] = {}, }
					end

-- TODO: Move this to the place where the rest of the classes are done
					-- Deal with the Demon Hunter introduced in Legion
					self.classMapping['E'] = 'DEMONHUNTER'
					self.classToBitMapping['E'] = 0x10000000
					self.classToMapAreaMapping['CE'] = 200005

					-- Create some convenience tables
					self.raceNameToBitMapping = {}
					for code, raceTable in pairs(self.races) do
						local raceName = raceTable[1]
						self.raceNameToBitMapping[raceName] = self.races[code][4]
					end
					self.classNameToBitMapping = {}
					self.classBitToCodeMapping = {}
					self.classNameToCodeMapping = {}
					for code,className in pairs(self.classMapping) do
						self.classNameToBitMapping[className] = self.classToBitMapping[code]
						self.classBitToCodeMapping[self.classToBitMapping[code]] = code
						self.classNameToCodeMapping[className] = code
					end
					self.holidayBitToCodeMapping = {}
					for code,bitValue in pairs(self.holidayToBitMapping) do
						self.holidayBitToCodeMapping[bitValue] = code
					end
					--	Set up some copies of holidays that will be altered based on release names
					self.holidayMapping['g'] = self.holidayMapping['f'] .. ' - ' .. EXPANSION_NAME1
					self.holidayMapping['h'] = self.holidayMapping['f'] .. ' - ' .. EXPANSION_NAME2
					self.holidayMapping['i'] = self.holidayMapping['f'] .. ' - ' .. EXPANSION_NAME3
					self.reverseHolidayMapping = {}
					for index, holidayName in pairs(self.holidayMapping) do
						self.reverseHolidayMapping[holidayName] = index
					end
					self.reverseProfessionMapping = {}
					for index, professionName in pairs(self.professionMapping) do
						self.reverseProfessionMapping[professionName] = index
					end

					-- Set up some reputation processing code
					-- We use the Blizzard API to get the names of the factions instead of maintaining them internally ourselves which we used to do
					local reputationIndex
					for hexIndex, _ in pairs(self.reputationMapping) do
						reputationIndex = tonumber(hexIndex, 16)
						local name = GetFactionInfoByID(reputationIndex)
						if nil == name then
							local id, rep, maxRep, friendName, text, texture, reaction, threshold, nextThreshold = GetFriendshipReputation(reputationIndex)
							if friendName == nil then
								name = "*** UNKNOWN " .. reputationIndex .. " ***"
								if self.reputationMapping[hexIndex] then
									name = name .. " (" .. self.reputationMapping[hexIndex] .. ")"
								end
							else
								name = friendName
							end
						end
						self.reputationMapping[hexIndex] = name
					end
					self.reverseReputationMapping = {}
					for index, repName in pairs(self.reputationMapping) do
						self.reverseReputationMapping[repName] = index
					end

					self:_LoadContinentData()

					-- Now we need to update some information based on the server to which we are connected
					if self.portal == "eu" or self.portal == "EU" then
						-- The following quests are not available on European servers
						local bannedQuests = {11117, 11118, 11120, 11431}
						for _, questId in pairs(bannedQuests) do
--							self.questNames[questId] = nil
							self.questCodes[questId] = nil
							self.quests[questId] = nil	--	Don't really need to do this since self.quests is not populated until after this (currently at least)
						end
					end

					-- Precompute the bit masks associated with things that cannot change so future access will be faster
					self.playerClassBitMask = self.classNameToBitMapping[self.playerClass]
					self.playerRaceBitMask = self.raceNameToBitMapping[self.playerRace]
					self.playerFactionBitMask = ('Horde' == self.playerFaction) and self.bitMaskFactionHorde or self.bitMaskFactionAlliance
					self.playerGenderBitMask = (3 == self.playerGender) and self.bitMaskGenderFemale or self.bitMaskGenderMale

					-- Create the indexed quest list up front so future requests are much faster
					self:CreateIndexedQuestList()

					-- Now take all the unnamed zones we determined from NPCs and add them to Grail.otherMapping
					-- and find their names
					self.otherMapping = {}
					local otherCount = 0
					local mapName
					for mapId in pairs(self.unnamedZones) do
						mapName = self:_GetMapNameByID(mapId)
						if nil ~= mapName then
							nameToUse = mapName
							while nil ~= self.zoneNameMapping[nameToUse] do
								nameToUse = nameToUse .. ' '
							end
							self.zoneNameMapping[nameToUse] = mapId
							otherCount = otherCount + 1
							self.otherMapping[otherCount] = mapId
						else
							if GrailDatabase.debug then print("Grail found no name for mapId", mapId) end
						end
					end

					-- Now we need to make a reverse mapping table that maps map area IDs into localized zone names.
					for zoneName, mapId in pairs(self.zoneNameMapping) do
						if nil == self.mapAreaMapping[mapId] then self.mapAreaMapping[mapId] = zoneName end
						-- Also create the "self" NPCs that are specific to each zone
						if nil == self.npc.nameIndex[0 - mapId] then
							self.npc.nameIndex[0 - mapId] = 0
							local t = {}
							t.mapArea = mapId
							self.npc.locations[0 - mapId] = { t }
						end
					end

					-- We need to be notified when any of these happen so we can update the quest status caches properly
					self:RegisterObserverQuestAbandon(Grail._StatusCodeCallback)
					self:RegisterObserverQuestAccept(Grail._StatusCodeCallback)
					self:RegisterObserverQuestComplete(Grail._StatusCodeCallback)

					-- We are defaulting to making events in combat delayed, and only doing it once in case the user decides to override.
					if nil == GrailDatabase.delayEventsHandled then
						GrailDatabase.delayEvents = true
						GrailDatabase.delayEventsHandled = true
					end

					--	Ensure the tooltip is not messed up
					if not self.tooltip:IsOwned(UIParent) then self.tooltip:SetOwner(UIParent, "ANCHOR_NONE") end

					self:RegisterSlashOption("events", "|cFF00FF00events|r => toggles delaying events in combat on and off, printing new value", function()
						GrailDatabase.delayEvents = not GrailDatabase.delayEvents
						print(strformat("Grail delays events in combat now %s", GrailDatabase.delayEvents and "ON" or "OFF"))
					end)
					self:RegisterSlashOption("silent", "|cFF00FF00silent|r => toggles silent startup on and off, printing new value", function()
						GrailDatabase.silent = not GrailDatabase.silent
						print(strformat("Grail silent startup for this player now %s", GrailDatabase.silent and "ON" or "OFF"))
					end)
					self:RegisterSlashOption("debug", "|cFF00FF00debug|r => toggles debug on and off, printing new value", function()
						GrailDatabase.debug = not GrailDatabase.debug
						print(strformat("Grail Debug now %s", GrailDatabase.debug and "ON" or "OFF"))
					end)
					self:RegisterSlashOption("target", "|cFF00FF00target|r => gets target information (NPC ID and your current location)", function()
						local targetName, npcId, coordinates = self:TargetInformation()
						local message = strformat("%s (%d) %s", targetName and targetName or 'nil target', npcId and npcId or -1, coordinates and coordinates or 'no coords')
						print(message)
						self:_AddTrackingMessage(message)
					end)
					self:RegisterSlashOption("c ", "|cFF00FF00c|r |cFFFF8C00msg|r => adds the |cFFFF8C00msg|r to the tracking data", function(msg)
						self:_AddTrackingMessage(strsub(msg, 3))
					end)
					self:RegisterSlashOption("comment ", "|cFF00FF00comment|r |cFFFF8C00msg|r => adds the |cFFFF8C00msg|r to the tracking data", function(msg)
						self:_AddTrackingMessage(strsub(msg, 9))
					end)
					self:RegisterSlashOption("tracking", "|cFF00FF00tracking|r => toggles tracking on and off, printing new value", function()
						GrailDatabase.tracking = not GrailDatabase.tracking
						print(strformat("Grail Tracking now %s", GrailDatabase.tracking and "ON" or "OFF"))
						self:_UpdateTrackingObserver()
					end)
					self:RegisterSlashOption("loot", "|cFF00FF00loot|r => toggles loot event processing on and off, printing new value", function()
						GrailDatabase.notLoot = not GrailDatabase.notLoot
						print(strformat("Grail Loot Event Processing now %s", GrailDatabase.notLoot and "OFF" or "ON"))
						if GrailDatabase.notLoot then
							Grail.notificationFrame:UnregisterEvent("LOOT_CLOSED")
						else
							Grail.notificationFrame:RegisterEvent("LOOT_CLOSED")
						end
					end)
					self:RegisterSlashOption("help", "|cFF00FF00help|r => print out this list of commands", function()
						print("|cFFFF0000Grail|r slash commands:")
						for option, value in pairs(self.slashCommandOptions) do
							print("|cFFFF0000/grail|r",value['help'])
						end
						print("|cFFFF0000/grail|r => initiates a database query to get completed quests [this happens at startup normally]")
					end)
					self:RegisterSlashOption("backup", "|cFF00FF00backup|r => creates a backup copy of the completed quests used for comparison", function()
						self:_ProcessServerBackup()
					end)
					self:RegisterSlashOption("compare", "|cFF00FF00compare|r => compares the current completed quest list to the backup copy", function()
						self:_ProcessServerCompare()
					end)
					--	Add a command for MoP that makes comparison of completed quests a little easier.  Only for MoP since before that the server
					--	needs to be queried and that means the return result will not happen before we compare.
                    self:RegisterSlashOption("cb", "|cFF00FF00cb|r => compares the latest server status quest list to the backup copy, and makes the backup become current", function()
						if not self.inCombat then
							print("|cFFFFFF00Grail|r initiating server database query")
							QueryQuestsCompleted()
							self:_ProcessServerCompare()
							self:_ProcessServerBackup()
						else
							print("|cFFFFFF00Grail cb|r not available in combat")
						end
					end)
					self:RegisterSlashOption("clearstatuses", "|cFF00FF00clearstatuses|r => clears the status of all quests allowing them to be recomputed", function()
						wipe(self.questStatuses)
						self.questStatuses = {}
						self:_CoalesceDelayedNotification("Status", 0)
					end)

					frame:RegisterEvent("ACHIEVEMENT_EARNED")		-- e.g., quest 29452 can be gotten if certain achievements are complete
					frame:RegisterEvent("CRITERIA_EARNED")		-- for debugging to see when criteria are earned in MoP
					frame:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE")	-- needed for quest status caching
					frame:RegisterEvent("CHAT_MSG_SKILL")	-- needed for quest status caching
					frame:RegisterEvent("GARRISON_BUILDING_ACTIVATED")
					frame:RegisterEvent("GARRISON_BUILDING_REMOVED")
					frame:RegisterEvent("GARRISON_BUILDING_UPDATE")
					frame:RegisterEvent("GOSSIP_CLOSED")
					frame:RegisterEvent("GOSSIP_SHOW")		-- needed to learn about gossips to be able to know when specific events have happened so quest availability can be updated
					if not GrailDatabase.notLoot then
						frame:RegisterEvent("LOOT_CLOSED")		-- Timeless Isle chests
					end
					frame:RegisterEvent("LOOT_OPENED")		-- support for Timeless Isle chests
					frame:RegisterEvent("PLAYER_ENTERING_WORLD")
-- Normal startup BfA beta 26585
--	ADDON_LOADED
--	SPELLS_CHANGED
--	PLAYER_LOGIN
--	PLAYER_ENTERING_WORLD
--	QUEST_LOG_UPDATE
-- ReloadUI BfA beta 26585
--	ADDON_LOADED
--	PLAYER_LOGIN
--	PLAYER_ENTERING_WORLD
--	QUEST_LOG_UPDATE
--	SPELLS_CHANGED

					frame:RegisterEvent("PLAYER_LEVEL_UP")	-- needed for quest status caching
					frame:RegisterEvent("PLAYER_REGEN_ENABLED")
					frame:RegisterEvent("PLAYER_REGEN_DISABLED")
					frame:RegisterEvent("QUEST_ACCEPTED")
					frame:RegisterEvent("QUEST_COMPLETE")
					frame:RegisterEvent("QUEST_DETAIL")
					frame:RegisterEvent("QUEST_LOG_UPDATE")	-- just to indicate we are now available to read the Blizzard quest log without issues
					frame:RegisterEvent("QUEST_REMOVED")
					frame:RegisterEvent("QUEST_TURNED_IN")
					frame:RegisterEvent("SKILL_LINES_CHANGED")
					if frame.RegisterUnitEvent then
						frame:RegisterUnitEvent("UNIT_AURA", "player")
						frame:RegisterUnitEvent("UNIT_QUEST_LOG_CHANGED", "player")
						frame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
					else
						frame:RegisterEvent("UNIT_AURA")				-- it seems we need to know when a specific buff happens for quest 28656 at a minimum
						frame:RegisterEvent("UNIT_QUEST_LOG_CHANGED")	-- so we can know when a quest is complete or failed
						frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
					end
--					frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")	-- only to get the first time logging in so the GetQuestResetTime() actually returns a real value
					self:_CleanDatabase()
					self:_CleanDatabaseLearnedQuestName()

					self:RegisterObserver("Bags", self._BagUpdates)
					self:RegisterObserver("QuestLogChange", self._QuestLogUpdate)
					self:_UpdateTrackingObserver()

					self.timings.AddonLoaded = 	debugprofilestop() - debugStartTime
				end

			end,

			['BAG_UPDATE'] = function(self, frame, bagId)
				if bagId ~= -2 and bagId < 5 then		-- a normal bag that is not the special (-2) backpack
					if not self.inCombat or not GrailDatabase.delayEvents then
						self:_CoalesceDelayedNotification("Bags", self.delayBagUpdate)
					else
						self:_RegisterDelayedEvent(frame, { 'BAG_UPDATE' } )
					end
				end
			end,

			['ARTIFACT_XP_UPDATE'] = function(self, frame)
				local Dynamic = C_ArtifactUI.IsAtForge() and C_ArtifactUI.GetArtifactInfo or C_ArtifactUI.GetEquippedArtifactInfo
				local itemID, _, _, _, _, ranksPurchased = Dynamic()
				if nil ~= itemID and nil ~= ranksPurchased then
					local olderValue = self.artifactLevels[itemID]
					if olderValue ~= ranksPurchased then
						self.artifactLevels[itemID] = ranksPurchased
						self:_StatusCodeInvalidate(self.invalidateControl[self.invalidateGroupArtifactLevel])
					end
				end
			end,

			['CALENDAR_UPDATE_EVENT_LIST'] = function(self, frame)
				self.receivedCalendarUpdateEventList = true
				frame:UnregisterEvent("CALENDAR_UPDATE_EVENT_LIST")
				self:_UpdateQuestResetTime()	-- moved here from ADDON_LOADED in the hopes that here GetQuestResetTime() will always return a real value
			end,

			['CHAT_MSG_COMBAT_FACTION_CHANGE'] = function(self, frame, message)
				if not self.inCombat or not GrailDatabase.delayEvents then
					self:_HandleEventChatMsgCombatFactionChange(message)
				else
					self:_RegisterDelayedEvent(frame, { 'CHAT_MSG_COMBAT_FACTION_CHANGE' } )
				end
			end,

			['CHAT_MSG_SKILL'] = function(self, frame)
				if not self.inCombat or not GrailDatabase.delayEvents then
					self:_HandleEventChatMsgSkill()
				else
					self:_RegisterDelayedEvent(frame, { 'CHAT_MSG_SKILL' } )
				end
			end,

			['CRITERIA_EARNED'] = function(self, frame, ...)
				if GrailDatabase.debug or GrailDatabase.tracking then
--					local achievementId, criterionId = ...
					local achievementId, criterionName = ...
					local _, achievementName = GetAchievementInfo(achievementId)
--					local criterionName = GetAchievementCriteriaInfoByID(achievementId, criterionId)
--					self:_AddTrackingMessage("Criterion earned: "..criterionName.." ("..criterionId..") for achievement "..achievementName.." ("..achievementId..")")
					self:_AddTrackingMessage("Criterion earned: "..criterionName.." for achievement "..achievementName.." ("..achievementId..")")
				end
			end,

			['GARRISON_BUILDING_ACTIVATED'] = function(self, frame, plotId, buildingId)
if GrailDatabase.debug then print("GARRISON_BUILDING_ACTIVATED "..plotId.." "..buildingId) end
				if not self.inCombat or not GrailDatabase.delayEvents then
					self:_HandleEventGarrisonBuildingActivated(buildingId)
				else
					self:_RegisterDelayedEvent(frame, { 'GARRISON_BUILDING_ACTIVATED', buildingId })
				end
			end,

			['GARRISON_BUILDING_REMOVED'] = function(self, frame, plotId, buildingId)
if GrailDatabase.debug then print("GARRISON_BUILDING_REMOVED "..plotId.." "..buildingId) end
				if not self.inCombat or not GrailDatabase.delayEvents then
					self:_HandleEventGarrisonBuildingActivated(buildingId)
				else
					self:_RegisterDelayedEvent(frame, { 'GARRISON_BUILDING_REMOVED', buildingId })
				end
			end,

			['GARRISON_BUILDING_UPDATE'] = function(self, frame, buildingId)
if GrailDatabase.debug then print("GARRISON_BUILDING_UPDATE ", buildingId) end
				if not self.inCombat or not GrailDatabase.delayEvents then
					self:_HandleEventGarrisonBuildingUpdate(buildingId)
				else
					self:_RegisterDelayedEvent(frame, { 'GARRISON_BUILDING_UPDATE', buildingId })
				end
			end,

			['GOSSIP_CLOSED'] = function(self, frame, ...)
--				print("GOSSIP_CLOSED:", ...)
				self.currentGossipNPCId = nil
			end,

			['GOSSIP_SHOW'] = function(self, frame, ...)
				local targetName, npcId, coordinates = self:TargetInformation()
				self.currentGossipNPCId = npcId
--				print("GOSSIP_SHOW:",targetName, npcId, coordinates,GetNumGossipAvailableQuests(),GetNumGossipActiveQuests(),GetNumGossipOptions(),GetGossipOptions())
			end,

			--	We want to be able to handle the chests on the Timeless Isle.  To do so we need to be able to determine
			--	what quest was just completed and we need to have a current backup of quests before we ask to see what
			--	has changed.  Therefore, we will ensure one is made if we need to here.
			['LOOT_OPENED'] = function(self, frame, ...)
				local currentMapAreaId = Grail.GetCurrentMapAreaID()
				if self.zonesForLootingTreasure[currentMapAreaId] then
					self.lootingGUID = GetLootSourceInfo(1)
					local text = GameTooltipTextLeft1
					self.lootingName = text and text:GetText() or self.defaultUnfoundLootingName
					if not self.doneProcessingBackup then
						self:_ProcessServerBackup(true)
						self.doneProcessingBackup = true
--						frame:UnregisterEvent("LOOT_OPENED")
					end
				end
			end,

			['LOOT_CLOSED'] = function(self, frame, ...)
				local currentMapAreaId = Grail.GetCurrentMapAreaID()
				if self.zonesForLootingTreasure[currentMapAreaId] then
					if not self.inCombat or not GrailDatabase.delayEvents then
						self:_HandleEventLootClosed()
					else
						self:_RegisterDelayedEvent(frame, { 'LOOT_CLOSED' } )
					end
				end
			end,

			['PLAYER_REGEN_DISABLED'] = function(self, frame, ...)
				self.inCombat = true
			end,

			-- When the player is in combat and an event is processed that would normally
			-- take some time, that processing is deferred, and the PLAYER_REGEN_ENABLED
			-- event is registered so the addon is informed when the player is no longer
			-- in combat and can have the deferred work done.  When all the deferred work
			-- is done, PLAYER_REGEN_ENABLED is unregistered.
			-- Actually in more modern times PLAYER_REGEN_ENABLED remains registered.
			['PLAYER_REGEN_ENABLED'] = function(self, frame)
				self.inCombat = nil
				local t, type
				while (0 < self.delayedEventsCount) do
					t = self.delayedEvents[1]
					type = t[1]
					if 'UNIT_SPELLCAST_SUCCEEDED' == type then
						self:_StatusCodeInvalidate(self.questStatusCache['Z'][t[2]])
						self:_NPCLocationInvalidate(self.npcStatusCache['Z'][t[2]])
					elseif 'UNIT_QUEST_LOG_CHANGED' == type then
						self:_HandleEventUnitQuestLogChanged()
					elseif 'UNIT_AURA' == type then
						local spellsToNuke = t[2]
						for i = 1, #spellsToNuke do
							self:_StatusCodeInvalidate(self.questStatusCache['B'][spellsToNuke[i]])
							self:_StatusCodeInvalidate(self.questStatusCache['Y'][spellsToNuke[i]])
							self:_NPCLocationInvalidate(self.npcStatusCache['B'][spellsToNuke[i]])
							self:_NPCLocationInvalidate(self.npcStatusCache['Y'][spellsToNuke[i]])
						end
					elseif 'SKILL_LINES_CHANGED' == type then
						self:_HandleEventSkillLinesChanged()
					elseif 'PLAYER_LEVEL_UP' == type then
						self:_HandleEventPlayerLevelUp()
					elseif 'CHAT_MSG_SKILL' == type then
						self:_HandleEventChatMsgSkill()
					elseif 'LOOT_CLOSED' == type then
						self:_HandleEventLootClosed()
					elseif 'CHAT_MSG_COMBAT_FACTION_CHANGE' == type then
						self:_HandleEventChatMsgCombatFactionChange(t[2])
					elseif 'BAG_UPDATE' == type then
						self:_CoalesceDelayedNotification("Bags", self.delayBagUpdate)
					elseif 'ACHIEVEMENT_EARNED' == type then
						self:_HandleEventAchievementEarned(t[2])
					elseif 'GARRISON_BUILDING_ACTIVATED' == type then
						self:_HandleEventGarrisonBuildingActivated(t[2])
					elseif 'GARRISON_BUILDING_REMOVED' == type then
						self:_HandleEventGarrisonBuildingActivated(t[2])
					elseif 'GARRISON_BUILDING_UPDATE' == type then
						self:_HandleEventGarrisonBuildingUpdate(t[2])
					end
					tremove(self.delayedEvents, 1)
					self.delayedEventsCount = self.delayedEventsCount - 1
					if InCombatLockdown() then			-- we have entered combat since we started processing, so abandon ship for now
						break
					end
				end
--				if 0 == self.delayedEventsCount then
--					frame:UnregisterEvent("PLAYER_REGEN_ENABLED")
--				end
			end,

			['PLAYER_ENTERING_WORLD'] = function(self, frame)
				frame:RegisterEvent("ARTIFACT_XP_UPDATE")
			end,

			-- Note that the new level is recorded here, because during processing of this event calls to UnitLevel('player')
			-- will not return the new level.
			['PLAYER_LEVEL_UP'] = function(self, frame, newLevel)
				self.levelingLevel = tonumber(newLevel)
				if not self.inCombat or not GrailDatabase.delayEvents then
					self:_HandleEventPlayerLevelUp()
				else
					self:_RegisterDelayedEvent(frame, { 'PLAYER_LEVEL_UP' } )
				end
			end,

			-- When a Bounty Board only has one quest to give, by the time QUEST_ACCEPTED
			-- happens in WoD asking for TargetInformation() will not yield good results.
			-- Therefore, we record that information here and use it in QUEST_ACCEPTED.
			-- This is not perfect and there is no way to properly clear this unless I start
			-- overriding buttons on Blizzard's quest panel because, for example, the
			-- QUEST_FINISH event happens for both accepting and rejecting a quest.
			['QUEST_DETAIL'] = function(self, frame)
				local targetName, npcId, coordinates = self:TargetInformation()
				self.questAcceptingTargetName = targetName
				self.questAcceptingNpcId = npcId
				self.questAcceptingCoordinates = coordinates
				self.questAcceptingQuestId = GetQuestID()	-- this is new API and we never use this value currently
			end,

			['QUEST_ACCEPTED'] = function(self, frame, questIndex, theQuestId)
-- TODO: Figure out how to transform to delayed if needed
				local debugStartTime = debugprofilestop()
				local questTitle, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questId, startEvent, displayQuestId, isWeekly, isTask, isBounty, isStory, isHidden, isScaling = self:GetQuestLogTitle(questIndex)
				local npcId = nil
				local version = self.versionNumber.."/"..self.questsVersionNumber.."/"..self.npcsVersionNumber.."/"..self.zonesVersionNumber

				if nil == questTitle then questTitle = "NO TITLE PROVIDED BY BLIZZARD" end
				if theQuestId ~= questId then print("Grail: QuestId mismatch", theQuestId, "accepted but log has", questId) end

				-- Get the target information to ensure the target exists in the database of NPCs
				local targetName, npcId, coordinates
				if not self.existsWoD then
					targetName, npcId, coordinates = self:TargetInformation()
				else
					targetName = self.questAcceptingTargetName
					npcId = self.questAcceptingNpcId
					coordinates = self.questAcceptingCoordinates
				end
				npcId = self:_UpdateTargetDatabase(targetName, npcId, coordinates, version)

				--	If this quest is not in our internal database attempt to record some information about it so we have a chance the
				--	user can provide this to us to update the database.
				if not isHeader then
					local baseValue = 0
					if isDaily then baseValue = baseValue + 2 end
					if isWeekly then baseValue = baseValue + 4 end
					if suggestedGroup and suggestedGroup > 1 then baseValue = baseValue + 512 end
					if isTask then baseValue = baseValue + 32768 end	-- bonus objective
					if C_CampaignInfo.IsCampaignQuest(theQuestId) then baseValue = baseValue + 4096 end -- war campaign (recorded as legendary)
					-- at the moment we ignore questTag since it is localized
					-- With Legion there are issues because the level of the quests
					-- match the level of the player.  So, we force the level to 0.
					if self.existsWoD and level > 100 then
						level = 0
					end
					local kCode = strformat("K%03d%d", level, baseValue)
					self:_UpdateQuestDatabase(questId, questTitle, npcId, isDaily, 'A', version, kCode)

					-- Ask Blizzard API to provide us with the reputation rewards for this quest
-- As of July 2015 it has been reported that GetNumQuestLogRewardFactions() and GetQuestLogRewardFactionInfo() are not
-- honoring the call to SelectQuestLogEntry() but seem to be using the "last selected quest with the mouse in the interface"
--	However, with live Legion it seems we have the ability back in place properly.
--	But it also seems not to work with world quests, so we ignore those.
					if self.checksReputationRewardsOnAcceptance and not self:IsWorldQuest(questId) then
						SelectQuestLogEntry(questIndex)
						local reputationRewardsCount = GetNumQuestLogRewardFactions()
						local factionId, reputationAmount, repChangeString
						local blizzardReps = {}
						for i = 1, reputationRewardsCount do
							factionId, reputationAmount = GetQuestLogRewardFactionInfo(i)
							repChangeString = strformat("%s%d", self:_HexValue(factionId, 3), floor(reputationAmount / 100))
							tinsert(blizzardReps, repChangeString)
						end

						if not self:_ReputationChangesMatch(questId, blizzardReps) then
							local allReps = ""
							for i = 1, #blizzardReps do
								if i > 1 then allReps = allReps .. ',' end
								allReps = allReps .. "'" .. blizzardReps[i] .. "'"
							end
							self:_RecordBadQuestData('G' .. self.versionNumber .. '|' .. self.portal .. '|' .. self.blizzardRelease .. "|G[" .. questId .. "][6]={" .. allReps .. '}')
						end
					end

					-- Ask Blizzard API to get all the other reward information we record
--	local currentSpec = GetSpecialization()		-- nil if no spec chosen, otherwise 1 or more depending on spec
--	select(2, GetSpecializationInfo(currentSpec))	-- is the name of the current spec
--	specID = GetLootSpecialization()
					if self.questRewards then
						SelectQuestLogEntry(questIndex)
						local rewardString = ""
						local xp = GetQuestLogRewardXP()
						if nil ~= xp and 0 ~= xp then
							rewardString = rewardString .. ":X" .. xp
						end
						local copper = GetQuestLogRewardMoney()
						if nil ~= copper and 0 ~= copper then
							rewardString = rewardString .. ":M" .. copper
						end
						local link
						for counter = 1, GetNumQuestLogRewards() do
							itemId = string.match(GetQuestLogItemLink("reward", counter) or '', 'item:(%d+):')
							if itemId then
								local _, _, numberItems = GetQuestLogRewardInfo(counter)
								rewardString = rewardString .. ":R" .. itemId .. "-" .. numberItems
							end
						end
-- TODO: Figure out how to handle current rewards (like Apexis Crystals)
--						for counter = 1, GetNumQuestLogRewardCurrencies() do
--							itemId = string.match(GetQuestLogItemLink("reward", counter) or '', 'item:(%d+):')
--							if itemId then
--								rewardString = rewardString .. ":O" .. itemId
--							end
--						end
						for counter = 1, GetNumQuestLogChoices() do
							itemId = string.match(GetQuestLogItemLink("choice", counter) or '', 'item:(%d+):')
							if itemId then
								rewardString = rewardString .. ":C" .. itemId
							end
						end
						if nil == self.questRewards[questId] or self.questRewards[questId] ~= rewardString then
							self:_RecordBadQuestData('G' .. self.versionNumber .. '|' .. self.portal .. '|' .. self.blizzardRelease .. "|G[" .. questId .. "][reward]=" .. rewardString)
						end
					end

				end

				--	If we think we should not have been able to accept this quest we should record some information that may help us update our faulty database.
				local statusCode = self:StatusCode(questId)
				local errorString = 'G' .. self.versionNumber .. '|' .. questId .. '|' .. statusCode
				if not self:CanAcceptQuest(questId, false, false, true) then
					-- look at the reason and record the reason and contrary information for that reason
					if bitband(statusCode, self.bitMaskLevelTooLow + self.bitMaskLevelTooHigh) > 0 then errorString = errorString .. "|L:" .. UnitLevel('player') end
					if bitband(statusCode, self.bitMaskClass + self.bitMaskAncestorClass) > 0 then errorString = errorString .. "|C:" .. self.playerClass end
-- TODO: Correct the fact that |R results in the loss of the R because it is a code used in their strings
					if bitband(statusCode, self.bitMaskRace + self.bitMaskAncestorRace) > 0 then errorString = errorString .. "|R:" .. self.playerRace end
					if bitband(statusCode, self.bitMaskGender + self.bitMaskAncestorGender) > 0 then errorString = errorString .. "|G:" .. self.playerGender end
					if bitband(statusCode, self.bitMaskFaction + self.bitMaskAncestorFaction) > 0 then errorString = errorString .. "|F:" .. self.playerFaction end
					if bitband(statusCode, self.bitMaskInvalidated) > 0 then

					end
					if bitband(statusCode, self.bitMaskProfession) > 0 then
-- TODO: Need to look at all the professions associated with the quest and record the actual profession values the user currently has for them

					end
					if bitband(statusCode, self.bitMaskReputation) > 0 then
-- TODO: Same as professions, but with reputations instead

					end
					if bitband(statusCode, self.bitMaskHoliday) > 0 then
-- TODO: Determine if we actually need to mark which holiday caused the problem because when CleanDatabase comes across this without the specific one, it can only remove this if there is NO holiday associated with the quest.
						errorString = errorString .. "HOL"
					end
					if bitband(statusCode, self.bitMaskPrerequisites) > 0 then

					end
					self:_RecordBadQuestData(errorString)
				end

				--	If the questTitle is different from what we have recorded, note that as BadQuestData (even though it could just be a localization issue)
				if self:DoesQuestExist(questId) and questTitle ~= self:QuestName(questId) then
					errorString = errorString .. "|Title:" .. questTitle .. "|Locale:" .. self.playerLocale
					self:_RecordBadQuestData(errorString)
				end

				--	If the level as reported by Blizzard API does not match our internal database we should note that fact
				if self:DoesQuestExist(questId) and not isScaling then
					local internalQuestLevel = self:QuestLevel(questId)
--					if (0 ~= internalQuestLevel and (internalQuestLevel or 1) ~= level) or (0 == internalQuestLevel and level ~= 0 and level ~= UnitLevel('player')) then
					if nil ~= level and internalQuestLevel ~= level then
						errorString = errorString .. "|Level:" .. level
						self:_RecordBadQuestData(errorString)
					end
				end

				-- Check to see whether the database faction agrees with the Blizzard API and note discrepancies
				if self:DoesQuestExist(questId) then
					local blizzardFactionGroup = GetQuestFactionGroup(questId)	-- nil means no specific faction, otherwise LE_QUEST_FACTION_HORDE (2) or LE_QUEST_FACTION_ALLIANCE (1)
					-- need to check our database for specific faction association
					local obtainers = self:CodeObtainers(questId)
					local bitMaskToCheckAgainst = 0
					local errorCode = "Unknown"
					if nil == blizzardFactionGroup then
						bitMaskToCheckAgainst = self.bitMaskFactionAll
						errorCode = "Both"
					elseif LE_QUEST_FACTION_ALLIANCE == blizzardFactionGroup then
						bitMaskToCheckAgainst = self.bitMaskFactionAlliance
						errorCode = "Alliance"
					elseif LE_QUEST_FACTION_HORDE == blizzardFactionGroup then
						bitMaskToCheckAgainst = self.bitMaskFactionHorde
						errorCode = "Horde"
					else
						print("Unknown faction association returned "..blizzardFactionGroup.." for quest "..questId)
					end
					if bitband(obtainers, self.bitMaskFactionAll) ~= bitMaskToCheckAgainst then
						errorString = errorString .. "|Faction:" .. errorCode
						self:_RecordBadQuestData(errorString)
					end
				end

				-- Check to see whether this quest belongs to a group and handle group counts properly
				if self.questStatusCache.H[questId] then
					for _, group in pairs(self.questStatusCache.H[questId]) do
						if self:_RecordGroupValueChange(group, true, false, questId) >= self.dailyMaximums[group] then
							self:_StatusCodeInvalidate(self.questStatusCache['G'][group])
							self:_NPCLocationInvalidate(self.npcStatusCache['G'][group])
						end
						self:_StatusCodeInvalidate(self.questStatusCache['X'][group])
						self:_NPCLocationInvalidate(self.npcStatusCache['X'][group])
					end
				end

				self:_PostNotification("Accept", questId)

				-- If there is an OAC: code associated with the quest we need to complete all the quests listed there.
				local oacCodes = self:QuestOnAcceptCompletes(questId)
				if nil ~= oacCodes then
					for i = 1, #oacCodes do
						self:_MarkQuestComplete(oacCodes[i], true, false, false)
					end
				end

				if GrailDatabase.debug then
					local debugMessage = "Grail Debug: Accepted quest: ".. questTitle .. " (" .. questId .. ") from "
					if nil ~= targetName then debugMessage = debugMessage .. targetName .. " (" .. (npcId or -1) .. ") " .. (coordinates or 'no coords') else debugMessage = debugMessage .. "no target" end
					if not self:CanAcceptQuest(questId, false, false, true) then
						debugMessage = debugMessage .. " but should not accept because of: " .. "an error"
					else
						debugMessage = debugMessage .. " without problems"
					end
					print(debugMessage)
				end
				self:_UpdateQuestResetTime()
				self.timings.QuestAccepted = debugprofilestop() - debugStartTime
			end,

			['QUEST_COMPLETE'] = function(self, frame)
				local titleText = GetTitleText()
				self.completingQuest = self:QuestInQuestLogMatchingTitle(titleText)
				self.completingQuestTitle = titleText
				if nil == self.completingQuest then	-- if we still do not have it, mark it in the saved variables for possible future inclusion
					if nil == GrailDatabase["SpecialQuests"] then GrailDatabase["SpecialQuests"] = { } end
					if nil == GrailDatabase["SpecialQuests"][titleText] then GrailDatabase["SpecialQuests"][titleText] = self.blizzardRelease end
				end
				self:_UpdateQuestResetTime()
			end,

			-- This is used solely to indicate to the system that the Blizzard quest log is available to be read properly.  Early in the startup
			-- this is not the case prior to receiving PLAYER_ALIVE, but since that event is never received in a UI reload this event is used as
			-- a replacement which seems to work properly.
			['QUEST_LOG_UPDATE'] = function(self, frame)
				frame:UnregisterEvent("QUEST_LOG_UPDATE")
				self.receivedQuestLogUpdate = true
				frame:RegisterEvent("CALENDAR_UPDATE_EVENT_LIST")		-- to indicate the calendar is primed and can be accurately read
				frame:RegisterEvent("BAG_UPDATE")						-- we need to know when certain items are present or not (for quest 28607 e.g.)
				-- The intention is to receive the CALENDAR_UPDATE_EVENT_LIST event
				-- and to do so, one calls OpenCalendar(), but it seems if one does
				-- not call the other calendar functions beforehand, the call to
				-- OpenCalendar() will do nothing useful.
				local weekday, month, day, year = CalendarGetDate();
				C_Calendar.SetAbsMonth(month, year)
				C_Calendar.OpenCalendar()
				self:_AddWorldQuests()
			end,

			['QUEST_QUERY_COMPLETE'] = function(self, frame, arg1)
				self:_ProcessServerQuests()
			end,

			['QUEST_REMOVED'] = function(self, frame, questId)
				-- this happens for both abandon and turn-in
				-- and turn-in is first, so we can know we are abandoning or not
				if nil == self.questTurningIn then
					self:_StatusCodeInvalidate({ tonumber(questId) }, self.delayQuestRemoved)
				end
				self.questTurningIn = nil
			end,

			['QUEST_TURNED_IN'] = function(self, frame, questId, xp, money)
				self.questTurningIn = questId
				self:_QuestCompleteProcess(questId)
			end,

			['SKILL_LINES_CHANGED'] = function(self, frame)
				if not self.inCombat or not GrailDatabase.delayEvents then
					self:_HandleEventSkillLinesChanged()
				else
					self:_RegisterDelayedEvent(frame, { 'SKILL_LINES_CHANGED' } )
				end
			end,

			['UNIT_AURA'] = function(self, frame, arg1)
				if arg1 == "player" then
					local spellsToNuke = {}
					if nil == self.spellsToHandle then self.spellsToHandle = {} end
					self.spellsJustHandled = {}
					local i = 1
					while (true) do
						local name,_,_,_,_,_,_,_,_,boaSpellId,spellId = UnitAura(arg1, i)
						spellId = boaSpellId
						if name then
							spellId = tonumber(spellId)
							self:_MarkQuestInDatabase(spellId, GrailDatabasePlayer["buffsExperienced"])
							if nil ~= spellId and (nil ~= self.questStatusCache['B'][spellId] or nil ~= self.questStatusCache['Y'][spellId]) then
								if not tContains(spellsToNuke, spellId) then tinsert(spellsToNuke, spellId) end
								self.spellsToHandle[spellId] = true
								self.spellsJustHandled[spellId] = true
							end
							i = i + 1
						else
							break
						end
					end
					for spellId, _ in pairs(self.spellsToHandle) do
						if not self.spellsJustHandled[spellId] then
							if not tContains(spellsToNuke, spellId) then tinsert(spellsToNuke, spellId) end
							self.spellsToHandle[spellId] = nil
						end
					end
					if not self.inCombat or not GrailDatabase.delayEvents then
						for i = 1, #spellsToNuke do
							self:_StatusCodeInvalidate(self.questStatusCache['B'][spellsToNuke[i]])
							self:_StatusCodeInvalidate(self.questStatusCache['Y'][spellsToNuke[i]])
							self:_NPCLocationInvalidate(self.npcStatusCache['B'][spellsToNuke[i]])
							self:_NPCLocationInvalidate(self.npcStatusCache['Y'][spellsToNuke[i]])
						end
					else
						self:_RegisterDelayedEvent(frame, { 'UNIT_AURA', spellsToNuke } )
					end
				end
			end,

			['UNIT_QUEST_LOG_CHANGED'] = function(self, frame, arg1)
				if arg1 == "player" then
					if not self.inCombat or not GrailDatabase.delayEvents then
						self:_PostDelayedNotification("QuestLogChange", 0, 0.5)
					else
						self:_RegisterDelayedEvent(frame, { 'UNIT_QUEST_LOG_CHANGED' } )
					end
				end
			end,

			['UNIT_SPELLCAST_SUCCEEDED'] = function(self, frame, unit, spellName, noLongerValidRank, lineId, spellId)
				if unit == "player" then
					if self.battleForAzeroth then
						-- Blizzard now returns a lineId and spellId instead of its normal parameters
						-- and the lineId has an extra item at the start "Cast".
						lineId = spellName	-- even though we need not use it now
						spellId = noLongerValidRank
					elseif self.existsLegion then
						--	Blizzard no longers returns a spellId, but a lineId that needs to be parsed
						local numberThree, serverId, instanceId, zoneUID, realSpellId, castUID = strsplit("-", lineId)
						spellId = realSpellId
						--	Reading Artifact Research Notes raises the knowledge level, so we need to handle this
						if tonumber(spellId) == 219978 then
							local _, level = GetCurrencyInfo(1171)
							self:ArtifactChange(level)
						end
					end
					self:_MarkQuestInDatabase(spellId, GrailDatabasePlayer["spellsCast"])
					if nil ~= self.questStatusCache and nil ~= self.questStatusCache['Z'] then
						if not self.inCombat or not GrailDatabase.delayEvents then
							self:_StatusCodeInvalidate(self.questStatusCache['Z'][spellId])
							self:_NPCLocationInvalidate(self.npcStatusCache['Z'][spellId])
						else
							self:_RegisterDelayedEvent(frame, { 'UNIT_SPELLCAST_SUCCEEDED', spellId } )
						end
					end
				end
			end,

--			['ZONE_CHANGED_NEW_AREA'] = function(self, frame)
--				self:_UpdateQuestResetTime()	-- moved here from ADDON_LOADED in the hopes that here GetQuestResetTime() will always return a real value
--				frame:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
--			end,

			},
		factionMapping = { ['A'] = 'Alliance', ['H'] = 'Horde', },
		followerMapping = {},
		forceLocalizedQuestNameLoad = true,
		friendshipLevel = { 'Stranger', 'Acquaintance', 'Buddy', 'Friend', 'Good Friend', 'Best Friend' },
		garrisonBuildingLevelMapping = {
			[-8] = "1+", [-9] = "2+", [-24] = "1+", [-25] = "2+", [-26] = "1+", [-27] = "2+",
			[-29] = "1+", [-34] = "1+", [-35] = "2+", [-37] = "1+", [-38] = "2+", [-40] = "1+",
			[-41] = "2+", [-42] = "1+", [-51] = "1+", [-52] = "1+", [-60] = "1+", [-61] = "1+",
			[-62] = "2+", [-64] = "1+", [-65] = "1+", [-66] = "2+", [-76] = "1+", [-90] = "1+",
			[-91] = "1+", [-93] = "1+", [-94] = "1+", [-95] = "1+", [-96] = "1+", [-111] = "1+",
			[-117] = "2+", [-119] = "2+", [-121] = "2+", [-123] = "2+", [-125] = "2+", [-127] = "2+",
			[-129] = "2+", [-131] = "2+", [-134] = "2+", [-136] = "2+", [-140] = "2+", [-142] = "2+",
			[-144] = "2+", [-159] = "1+", [-160] = "2+", [-162] = "1+", [-163] = "2+", [-167] = "2+",
			[8] = "1", [9] = "2", [10] = "3",
			[24] = "1", [25] = "2", [133] = "3",
			[26] = "1", [27] = "2", [28] = "3",
			[29] = "1", [136] = "2", [137] = "3",
			[34] = "1", [35] = "2", [36] = "3",
			[37] = "1", [38] = "2", [39] = "3",
			[40] = "1", [41] = "2", [138] = "3",
			[42] = "1", [167] = "2", [168] = "3",
			[51] = "1", [142] = "2", [143] = "3",
			[52] = "1", [140] = "2", [141] = "3",
			[60] = "1", [117] = "2", [118] = "3",
			[61] = "1", [62] = "2", [63] = "3",
			[64] = "1", [134] = "2", [135] = "3",
			[65] = "1", [66] = "2", [67] = "3",
			[76] = "1", [119] = "2", [120] = "3",
			[90] = "1", [121] = "2", [122] = "3",
			[91] = "1", [123] = "2", [124] = "3",
			[93] = "1", [125] = "2", [126] = "3",
			[94] = "1", [127] = "2", [128] = "3",
			[95] = "1", [129] = "2", [130] = "3",
			[96] = "1", [131] = "2", [132] = "3",
			[111] = "1", [144] = "2", [145] = "3",
			[159] = "1", [160] = "2", [161] = "3",
			[162] = "1", [163] = "2", [164] = "3",
		},
		garrisonBuildingMapping = {
			[-8] = { 8, 9, 10 },		-- Armory
			[-9] = { 9, 10 },
			[-24] = { 24, 25, 133 },	-- Barn
			[-25] = { 25, 133 },
			[-26] = { 26, 27, 28 },		-- Barracks
			[-27] = { 27, 28 },
			[-29] = { 29, 136, 137 },	-- Farm
			[-34] = { 34, 35, 36 },		-- Inn
			[-35] = { 35, 36 },
			[-37] = { 37, 38, 39 },		-- Mage Tower
			[-38] = { 38, 39 },
			[-40] = { 40, 41, 138 },	-- Lumber Mill
			[-41] = { 41, 138 },
			[-42] = { 42, 167, 168 },	-- Pet Menagerie
			[-51] = { 51, 142, 143 },	-- Storehouse
			[-52] = { 52, 140, 141 },	-- Salvage Yard
			[-60] = { 60, 117, 118 },	-- Forge
			[-61] = { 61, 62, 63 },		-- Mine
			[-62] = { 62, 63 },
			[-64] = { 64, 134, 135 },	-- Fishing
			[-65] = { 65, 66, 67 },		-- Stables
			[-66] = { 66, 67 },
			[-76] = { 76, 119, 120 },	-- Alchemy
			[-90] = { 90, 121, 122 },	-- Leatherworking
			[-91] = { 91, 123, 124 },	-- Engineering
			[-93] = { 93, 125, 126 },	-- Enchanting
			[-94] = { 94, 127, 128 },	-- Tailoring
			[-95] = { 95, 129, 130 },	-- Inscription
			[-96] = { 96, 131, 132 },	-- Jewelcrafting
			[-111] = { 111, 144, 145 },	-- Trading Post
			[-117] = { 117, 118 },
			[-119] = { 119, 120 },
			[-121] = { 121, 122 },
			[-123] = { 123, 124 },
			[-125] = { 125, 126 },
			[-127] = { 127, 128 },
			[-129] = { 129, 130 },
			[-131] = { 131, 132 },
			[-134] = { 134, 135 },
			[-136] = { 136, 137 },
			[-140] = { 140, 141 },
			[-142] = { 142, 143 },
			[-144] = { 144, 145 },
			[-159] = { 159, 160, 161 },	-- Gladiator's Sanctum
			[-160] = { 160, 161 },
			[-162] = { 162, 163, 164 },	-- Gnomish Gearworks
			[-163] = { 163, 164 },
			[-167] = { 167, 168 },
		},
		genderMapping = { ['M'] = 2, ['F'] = 3, },
		gossipNPCs = {},
		holidayMapping = { ['A'] = 'Love is in the Air', ['B'] = 'Brewfest', ['C'] = "Children's Week", ['D'] = 'Day of the Dead', ['F'] = 'Darkmoon Faire',
				['H'] = 'Harvest Festival', ['K'] = "Kalu'ak Fishing Derby", ['L'] = 'Lunar Festival', ['M'] = 'Midsummer Fire Festival', ['N'] = 'Noblegarden', ['P'] = "Pirates' Day",
				['U'] = 'New Year', ['V'] = 'Feast of Winter Veil', ['W'] = "Hallow's End", ['X'] = 'Stranglethorn Fishing Extravaganza', ['Y'] = "Pilgrim's Bounty", ['Z'] = "Christmas Week", ['a'] = 'Apexis Bonus Event', ['b'] ='Arena Skirmish Bonus Event', ['c'] = 'Battleground Bonus Event', ['d'] = 'Draenor Dungeon Event', ['e'] = 'Pet Battle Bonus Event', ['f'] = 'Timewalking Dungeon Event', ['g'] = 'Legion Dungeon Event', },
		holidayToBitMapping = { ['A'] = 0x00000001, ['B'] = 0x00000002, ['C'] = 0x00000004, ['D'] = 0x00000008, ['F'] = 0x00000010,
				['H'] = 0x00000020, ['K'] = 0x00010000, ['L'] = 0x00000040, ['M'] = 0x00000080, ['N'] = 0x00000100, ['P'] = 0x00000200,
				['U'] = 0x00000400, ['V'] = 0x00000800, ['W'] = 0x00001000, ['X'] = 0x00008000, ['Y'] = 0x00002000, ['Z'] = 0x00004000, ['a'] = 0x00020000, ['b'] = 0x00040000, ['c'] = 0x00080000, ['d'] = 0x00100000, ['e'] = 0x00200000, ['f'] = 0x00400000, ['g'] = 0x00800000, ['h'] = 0x01000000, ['i'] = 0x02000000, },
		holidayToMapAreaMapping = { ['HA'] = 100001, ['HB'] = 100002, ['HC'] = 100003, ['HD'] = 100004, ['HF'] = 100006, ['HH'] = 100008, ['HK'] = 100011, ['HL'] = 100012, ['HM'] = 100013,
				['HN'] = 100014, ['HP'] = 100016, ['HQ'] = 100017, ['HU'] = 100021, ['HV'] = 100022, ['HW'] = 100023, ['HX'] = 100024, ['HY'] = 100025, ['HZ'] = 100026, ['Ha'] = 100027, ['Hb'] = 100028, ['Hc'] = 100029, ['Hd'] = 100030, ['He'] = 100031, ['Hf'] = 100032, ['Hg'] = 100033, ['Hh'] = 100034, ['Hi'] = 100035, },
		indexedQuests = {},
		indexedQuestsExtra = {},
		levelingLevel = nil,	-- this is set during the PLAYER_LEVEL_UP event because UnitLevel() does not work during it
		locationCloseness = 1.55,
		mapAreaBaseAchievement = 500000,
		mapAreaBaseClass = 200000,
		mapAreaBaseDaily = 400000,
		mapAreaBaseHoliday = 100000,
		mapAreaBaseOther = 700000,
		mapAreaBaseProfession = 300000,
		mapAreaBaseReputation = 400000,	-- note that 400000 is used for Daily
		mapAreaBaseReputationChange = 600000,
		mapAreaMapping = {},
--		mapAreaMapping = setmetatable({}, {
--			__index = function(t, id_num)
--				if nil == id_num then id_num = "nil" end
--				return "Error "..id_num
--				end,
--				}),
		mapAreaMaximumAchievement = 599999,
		mapAreaMaximumClass = 299999,
		mapAreaMaximumDaily = 400000,	-- not used since Daily really is only every one area
		mapAreaMaximumHoliday = 199999,
		mapAreaMaximumProfession = 399999,
		mapAreaMaximumReputation = 499999,
		mapAreaMaximumReputationChange = 699999,
		memoryUsage = {},	-- see timings
		nonPatternExperiment = true,

		--	The NPC database contains all we need to know about NPCs with data in specifc tables based on need.
		--	The index into each table is a numeric value of our internal representation of NPC ID.  For the most
		--	part this matches the Blizzard NPC ID, but we have alias NPCs, as well as mapping game objects and
		--	items into our NPC IDs as well.  The convenience APIs allow using Blizzard IDs for game object and
		--	items which will access the internal data structure using our modified NPC IDs.
		npc = {

			-- Possible list of NPCs that are aliases of the key.
			aliases = {},

			-- The localized comment for the NPC.
			-- This is sparsely populated, as most NPCs will not have a comment.
			comment = {},

			-- Possible list of NPCs that can drop this item.
			droppedBy = {},

			-- Possible faction affiliation for the NPC.
			-- This is sparsely populated, and the values are the internal representations of factions.
			faction = {},

			-- Possible list of items that the NPC has (basically the reverse of the droppedBy in other NPCs).
			has = {},

			-- Possible indication that NPC is only available in heroic mode.
			heroic = {},

			-- Possible indication that NPC is only available on holidays.  Value
			-- is a string of characters representing holidays, usually only 1 long.
			holiday = {},

			-- Possible indication that the NPC is to be killed.
			kill = {},

			-- Each value contains a table of locations for the NPC.
			locations = {},

			-- The localized name of the NPC.
			-- The only names that get prepopulated from loading files are those of game objects because there is
			-- no Blizzard API that we seem to be able to use to get the localized name of the game object at any
			-- time we want, unlike normal NPCs and items whose name we scrape from a game tooltip.
			name = {},

			-- The actual index value to use when accessing the name table if non-nil is returned.
			-- Normally the actual NPC ID is used because a lookup of most NPC IDs in this table will return nil.
			-- However, there are some alias NPCs, and others that use names of other NPCs which return a non-nil
			-- value which is used by the internal routines to get the proper localized name.
			nameIndex = {},

			-- This is a special table for items that are associated with quests for use with tooltips.
			-- This is sparsely populated.  It does not reflect the quests most NPCs are associated with.  Each
			-- value contains a table of quest IDs.
			questAssociations = {},

			},

		quest = {

			-- Note that Grail.questCodes is where we put all the codes associated with quests.  This could be used
			-- to control access to what quests are available since we want a code for each quest, even if it were
			-- an empty code.

			-- The localized name of the quest.
			-- This is dynamically populated as requests are made to show the quest name.  However, if someone were
			-- to load one of the loadable addons of quest names, they would replace the contents of this table with
			-- entries from the loadable addon.
			-- The initial population of a few quests that are actually artifically
			-- created to support some complicated prerequisites.
			name = {
			--	[600000]='Blasted Lands Phase Requirements'
			--	[600001]='Blasted Lands Alliance Phase Requirements'
			--	[600002]='Blasted Lands Horde Phase Requirements'
				[600000]=GetMapNameByID(19)..' '..REQUIREMENTS,
				[600001]=GetMapNameByID(19)..' '..FACTION_ALLIANCE..' '..REQUIREMENTS,
				[600002]=GetMapNameByID(19)..' '..FACTION_HORDE..' '..REQUIREMENTS,
				},

			},

		-- A table whose keys represent situations where quests need to be invalidated, and whose values are
		-- the quest IDs to invalidate.
		-- The contents of this table is populated primarily from processing the quest codes associated with each
		-- quest.  During play, specific events happen that may need to have the status of specific quests re-evaluated
		-- and this is accomplished by invalidating the current status only.  When a client needs the current status
		-- it will automatically be re-evaluated.  The keys are numbers with arbitrary values, except for those that
		-- are associated with Blizzard groups (like factions), which are noted.
		invalidateControl = {},

		invalidateGroupHighestValue = 5,

		invalidateGroupWithering = 1,
		invalidateGroupGarrisonBuildings = 2,
		invalidateGroupCurrentWorldQuests = 3,
		invalidateGroupArtifactKnowledge = 4,
		invalidateGroupArtifactLevel = 5,
		invalidateGroupBaseAchievement = 1000000,	-- the actual achievement ID is added to this
		invalidateGroupBaseBuff = 2000000,	-- the actual buff ID is added to this
		invalidateGroupBaseItem = 3000000,	-- the actual item ID is added to this

						-- quests is a table whose indexes are questIds and values are the actual bit mask status
						-- A is a table whose key is an achievement ID and whose value is a table of quests assocaited with it
						-- B is a table whose key is a buff ID and whose value is a table of quests associated with it
						-- C is a table whose key is an item ID whose presence is needed and whose value is a table of quests associated with it
						-- D is a table whose indexes are questIds and values are tables of questIds that need to be invalidated when the index is no longer in the quest log
						-- E is a table whose key is an item ID whose presence is NOT wanted and whose value is a table of quests associated with it
						-- F is a table whose key is a questId that when abandoned needs to have the table of associated quests invalidated
						-- G is a table whose key is a group number and whose value is a table of quests associated with it
						-- H is a table whose key is a questId and whose value is a table of groups associated with it
						-- I is a table whose indexes are questIds and values are tables of questIds that suffer bitMaskInvalidated from the quest that is the index
						-- L is a table of questIds who fail because of bitMaskLevelTooLow
						-- M is a table of questIds that require garrison buildings
						-- P is a table of questIds who fail because of bitMaskProfession
						-- Q is a table whose indexes are questIds and values are tables of questIds that suffer bitMaskPrerequisites from the quest that is the index
						-- R is a table of questIds who fail because of bitMaskReputation
						-- S is a table whose key is a spellId whose presence is needed and whose value is a table of quests associated with it
						-- V is a table of questIds for quests that are NOT marked bitMaskLowLevel because gaining levels can change that value
						-- W is a table whose key is a group number and whose value is a table of quests interested in that group.  this differs from G because that is a list of all quests in the group
						-- X is a table whose key is a group number and whose value is a table of quests interested in that group for accepting.
						-- Y is a table whose key is a spellId that has ever been experienced and whose value is a table of quests associated with it
						-- Z is a table whose key is a spellId that has ever been cast and whose value is a table of quests associated with it

		npcNames = {},
		observers = { },
		origAbandonQuestFunction = nil,
		origConfirmAbandonQuestFunction = nil,
		origHookFunction = nil,
		playerClass = nil,
		playerFaction = nil,
		playerGender = nil,
		playerLocale = nil,
		playerName = nil,
		playerRace = nil,
		playerRealm = nil,
		professionMapping = {
			A = 'Alchemy',
			B = 'Blacksmithing',
			C = PROFESSIONS_COOKING,	-- "Cooking"
			E = 'Enchanting',
			F = PROFESSIONS_FISHING,	-- "Fishing"
			H = 'Herbalism',
			I = 'Inscription',		-- probably could use INSCRIPTION
			J = 'Jewelcrafting',
			L = 'Leatherworking',
			M = 'Mining',
			N = 'Engineering',
			R = 'Riding',
			S = 'Skinning',
			T = 'Tailoring',
			X = PROFESSIONS_ARCHAEOLOGY,	-- "Archaeology"
			Z = PROFESSIONS_FIRST_AID,	-- "First Aid"
			},
		professionToMapAreaMapping = { ['PA'] = 300001, ['PB'] = 300002, ['PC'] = 300003, ['PE'] = 300005, ['PF'] = 300006, ['PH'] = 300008, ['PI'] = 300009, ['PJ'] = 300010, ['PL'] = 300012, ['PM'] = 300013, ['PN'] = 300014, ['PP'] = 300016, ['PR'] = 300018, ['PS'] = 300019, ['PT'] = 300020, ['PU'] = 300021, ['PX'] = 300024, ['PZ'] = 300043, },
		questBits = {},					-- key is the questId, and value is a string that represents integers of bits
		questCodes = {},
--		questNames = {},
		questNPCId = nil,
		questPrerequisites = {},
		questReputationRequirements = {},	-- key is questId, value is a string of 4-character codes appended to each other, ignoring specific aspects of the P: code positions
		questReputations = {},			-- the table after the initial load is processed
		questResetTime = 0,
		quests = {},
		questsNoLongerAvailable = {},	-- quests with a Z code that has passed
		questsNotYetAvailable = {},		-- quests with an E code that has not yet happened
		questStatuses = {},				-- computed on demand
		races = {
			-- [1] is Blizzard API return (non-localized)
			-- [2] is localized male
			-- [3] is localized female
			-- [4] is bitmap value
			['A'] = { 'Pandaren', 'Pandaren',  'Pandaren',  0x08000000 },
			['B'] = { 'BloodElf', 'Blood Elf', 'Blood Elf', 0x02000000 },
			['C'] = { 'DarkIronDwarf', 'Dark Iron Dwarf', 'Dark Iron Dwarf', 0x00000004 },
			['D'] = { 'Draenei',  'Draenei',   'Draenei',   0x00080000 },
			['E'] = { 'NightElf', 'Night Elf', 'Night Elf', 0x00020000 },
			['F'] = { 'Dwarf',    'Dwarf',     'Dwarf',     0x00010000 },
			['G'] = { 'Goblin',   'Goblin',    'Goblin',    0x04000000 },
			['H'] = { 'Human',    'Human',     'Human',     0x00008000 },
			['I'] = { 'LightforgedDraenei', 'Lightforged Draenei', 'Lightforged Draenei', 0x40000000 },
			['J'] = { 'MagharOrc', "Mag'har Orc", "Mag'har Orc", 0x00000008 },
			['K'] = { 'KulTiran', "Kul'Tiran", "Kul'Tiran", 0x80000000 },
			['L'] = { 'Troll',    'Troll',     'Troll',     0x01000000 },
			['M'] = { 'HighmountainTauren', 'Highmountain Tauren', 'Highmountain Tauren', 0x00000001 },
			['N'] = { 'Gnome',    'Gnome',     'Gnome',     0x00040000 },
			['O'] = { 'Orc',      'Orc',       'Orc',       0x00200000 },
-- Do not ever use P because it will interfere with SP quest code
			['R'] = { 'Nightborne', 'Nightborne', 'Nightborne', 0x00000002 },
			['T'] = { 'Tauren',   'Tauren',    'Tauren',    0x00800000 },
			['U'] = { 'Scourge',  'Undead',    'Undead',    0x00400000 },
			['V'] = { 'VoidElf',  'Void Elf',  'Void Elf',	0x20000000 },
			['W'] = { 'Worgen',   'Worgen',    'Worgen',    0x00100000 },
			['Z'] = { 'ZandalariTroll', 'Zandalari Troll', 'Zandalari Troll', 0x10000000 },
			},
		receivedCalendarUpdateEventList = false,
		receivedQuestLogUpdate = false,

		reputationBodyGuards = {
			["6C5"] = 'Delvar Ironfist',
			["6C8"] = 'Tormmok',
			["6C9"] = 'Talonpriest Ishaal',
			["6CA"] = 'Defender Illona',
			["6CB"] = 'Vivianne',
			["6CC"] = 'Aeda Brightdawn',
			["6CD"] = 'Leorajh',
			},

		reputationBodyGuardLevelMapping = { [41999] = 1, [51999] = 2, [61999] = 3 },

		--	The reputation values are the actual faction values used by Blizzard.
		reputationExpansionMapping = {
			[1] = { 69, 54, 47, 72, 930, 1134, 530, 76, 81, 68, 911, 1133, 509, 890, 730, 510, 729, 889, 21, 577, 369, 470, 910, 609, 749, 990, 270, 529, 87, 909, 92, 989, 93, 349, 809, 70, 59, 576, 922, 967, 589, 469, 67, },
			[2] = { 942, 946, 978, 941, 1038, 1015, 970, 933, 947, 1011, 1031, 1077, 932, 934, 935, 1156, 1012, 936, },
			[3] = { 1037, 1106, 1068, 1104, 1126, 1067, 1052, 1073, 1097, 1098, 1105, 1117, 1119, 1064, 1050, 1085, 1091, 1090, 1094, 1124, },
			[4] = { 1158, 1173, 1135, 1171, 1174, 1178, 1172, 1177, 1204, },
			[5] = { 1216, 1351, 1270, 1277, 1275, 1283, 1282, 1228, 1281, 1269, 1279, 1243, 1273, 1358, 1276, 1271, 1242, 1278, 1302, 1341, 1337, 1345, 1272, 1280, 1352, 1357, 1353, 1359, 1375, 1376, 1387, 1388, 1435, 1492, },
			[6] = { 1445, 1515, 1520, 1679, 1681, 1682, 1708, 1710, 1711, 1731, 1732, 1733, 1735, 1736, 1737, 1738, 1739, 1740, 1741, 1847, 1848, 1849, 1850, },
			[7] = { 1815, 1828, 1833, 1859, 1860, 1862, 1883, 1888, 1894, 1899, 1900, 1919, 1947, 1948, 1975, 1984, 1989, 2018, 2045, 2097, 2098, 2099, 2100, 2101, 2102, 2135, 2165, 2170, },
			[8] = { 2103, 2111, 2120, 2156, 2157, 2158, 2159, 2160, 2161, 2162, 2163, 2164, 2233, 2264, 2265, },
			},

		-- These reputations use the friendship names instead of normal reputation names
		reputationFriends = {
			["4F9"] = 'Jogu the Drunk',
			["4FB"] = 'Ella',
			["4FC"] = 'Old Hillpaw',
			["4FD"] = 'Chee Chee',
			["4FE"] = 'Sho',
			["4FF"] = 'Haohan Mudclaw',
			["500"] = 'Tina Mudclaw',
			["501"] = 'Gina Mudclaw',
			["502"] = 'Fish Fellreed',
			["503"] = 'Farmer Fung',
			["54D"] = 'Nomi',
			["54E"] = 'Nat Pagle',
			},

		reputationFriendshipLevelMapping = { [41999] = 1, [50399] = 2, [58799] = 3, [67199] = 4, [75599] = 5, [83999] = 6,
											[55439] = 2005040, [71430] = 4004231, [79925] = 5004326,
											},

		--	The keys are the boundary values for specific reputation names.  Up to 8 indicates the names used for reputations.
		--	For values > 100 the reputation level is the value / 1000000 and the value mod 1000000 is how much over is
		--	required.
		reputationLevelMapping = { [0] = 1, [35999] = 2, [38999] = 3, [41999] = 4, [44999] = 5, [50999] = 6, [62999] = 7, [83999] = 8, [84998] = 8,
									-- And now for those funky values for the Tillers reputation requirements...
									[56599] = 6005600, [67250] = 7004251, [71498] = 7008499, [75599] = 7012600, [79799] = 7016800, [82999] = 7020000,
									-- And now for assume Klaxxi reputation requirements...
									[55999] = 6005000,
									-- And now for Operation: Shieldwall
									[45949] = 5000950, [49899] = 5004900, [53849] = 6002850, [57799] = 6006800, [61749] = 6010750, [65699] = 7002700,
									[69649] = 7006650, [71661] = 7008662, [77549] = 7014550, [81499] = 7018500,
									--	And now for Nightfallen
									[46749] = 5001750, [58999] = 6008000, [69999] = 7007000,
									--	And now for Paragon reputations
									[93999] = 8010000,
									},

		--	The keys are the actual faction values used by Blizzard converted into a 3-character hexidecimal value.
		--	The values will be localized at runtime.
		reputationMapping = {
			["015"] = 'Booty Bay',
			["02F"] = 'Ironforge',
			["036"] = 'Gnomeregan',
			["03B"] = 'Thorium Brotherhood',
			["043"] = 'Horde',
			["044"] = 'Undercity',
			["045"] = 'Darnassus',
			["046"] = 'Syndicate',
			["048"] = 'Stormwind',
			["04C"] = 'Orgrimmar',
			["051"] = 'Thunder Bluff',
			["057"] = 'Bloodsail Buccaneers',
			["05C"] = 'Gelkis Clan Centaur',
			["05D"] = 'Magram Clan Centaur',
			["0A9"] = 'Steamwheedle Cartel',
			["10E"] = 'Zandalar Tribe',
			["15D"] = 'Ravenholdt',
			["171"] = 'Gadgetzan',
			["1D5"] = 'Alliance',
			["1D6"] = 'Ratchet',
			["1FD"] = 'The League of Arathor',
			["1FE"] = 'The Defilers',
			["211"] = 'Argent Dawn',
			["212"] = 'Darkspear Trolls',
			["240"] = 'Timbermaw Hold',
			["241"] = 'Everlook',
			["24D"] = 'Wintersaber Trainers',
			["261"] = 'Cenarion Circle',
			["2D9"] = 'Frostwolf Clan',
			["2DA"] = 'Stormpike Guard',
			["2ED"] = 'Hydraxian Waterlords',
			["329"] = "Shen'dralar",
			["379"] = 'Warsong Outriders',
			["37A"] = 'Silverwing Sentinels',
			["38D"] = 'Darkmoon Faire',
			["38E"] = 'Brood of Nozdormu',
			["38F"] = 'Silvermoon City',
			["39A"] = 'Tranquillien',
			["3A2"] = 'Exodar',
			["3A4"] = 'The Aldor',
			["3A5"] = 'The Consortium',
			["3A6"] = 'The Scryers',
			["3A7"] = "The Sha'tar",
			["3A8"] = "Shattrath City",
			["3AD"] = "The Mag'har",
			["3AE"] = 'Cenarion Expedition',
			["3B2"] = 'Honor Hold',
			["3B3"] = 'Thrallmar',
			["3C7"] = 'The Violet Eye',
			["3CA"] = 'Sporeggar',
			["3D2"] = 'Kurenai',
			["3DD"] = 'Keepers of Time',
			["3DE"] = 'The Scale of the Sands',
			["3F3"] = 'Lower City',
			["3F4"] = 'Ashtongue Deathsworn',
			["3F7"] = 'Netherwing',
			["407"] = "Sha'tari Skyguard",
			["40D"] = 'Alliance Vanguard',
			["40E"] = "Ogri'la",
			["41A"] = 'Valiance Expedition',
			["41C"] = 'Horde Expedition',
			["428"] = 'The Taunka',
			["42B"] = 'The Hand of Vengeance',
			["42C"] = "Explorers' League",
			["431"] = "The Kalu'ak",
			["435"] = 'Shattered Sun Offensive',
			["43D"] = 'Warsong Offensive',
			["442"] = 'Kirin Tor',
			["443"] = 'The Wyrmrest Accord',
			["446"] = 'The Silver Covenant',
			["449"] = 'Wrath of the Lich King',
			["44A"] = 'Knights of the Ebon Blade',
			["450"] = 'Frenzyheart Tribe',
			["451"] = 'The Oracles',
			["452"] = 'Argent Crusade',
			["45D"] = 'Sholazar Basin',
			["45F"] = 'The Sons of Hodir',
			["464"] = 'The Sunreavers',
			["466"] = 'The Frostborn',
			["46D"] = 'Bilgewater Cartel',
			["46E"] = 'Gilneas',
			["46F"] = 'The Earthen Ring',
			["470"] = 'Tranquilien Conversion',
			["484"] = 'The Ashen Verdict',
			["486"] = 'Guardians of Hyjal',
			["490"] = 'Guild',
			["493"] = 'Therazane',
			["494"] = "Dragonmaw Clan",
			["495"] = 'Ramkahen',
			["496"] = 'Wildhammer Clan',
			["499"] = "Baradin's Wardens",
			["49A"] = "Hellscream's Reach",
			["4B4"] = "Avengers of Hyjal",
			["4C0"] = "Shang Xi's Academy",
			["4CC"] = 'Forest Hozen',
			["4DA"] = 'Pearlfin Jinyu',
			["4DB"] = 'Hozen',
			["4F5"] = 'Golden Lotus',
			["4F6"] = 'Shado-Pan',
			["4F7"] = 'Order of the Cloud Serpent',
			["4F8"] = 'The Tillers',
			["4F9"] = 'Jogu the Drunk',
			["4FB"] = 'Ella',
			["4FC"] = 'Old Hillpaw',
			["4FD"] = 'Chee Chee',
			["4FE"] = 'Sho',
			["4FF"] = 'Haohan Mudclaw',
			["500"] = 'Tina Mudclaw',
			["501"] = 'Gina Mudclaw',
			["502"] = 'Fish Fellreed',
			["503"] = 'Farmer Fung',
			["516"] = 'The Anglers',
			["539"] = 'The Klaxxi',
			["53D"] = 'The August Celestials',
			["541"] = 'The Lorewalkers',
			["547"] = 'The Brewmasters',
			["548"] = 'Huojin Pandaren',
			["549"] = 'Tushui Pandaren',
			["54D"] = 'Nomi',
			["54E"] = 'Nat Pagle',
			["54F"] = 'The Black Prince',
			["55F"] = "Dominance Offensive",
			["560"] = "Operation: Shieldwall",
			["56B"] = "Kirin Tor Offensive",
			["56C"] = "Sunreaver Onslaught",
			["59B"] = "Shado-Pan Assault",
			["5A5"] = "Frostwolf Orcs",
			["5D4"] = "Emperor Shaohao",
			["5EB"] = "Arakkoa Outcasts",
			["5F0"] = "Shadowmoon Exiles",
			["68F"] = "Operation: Aardvark",
			["691"] = "Vol'jin's Spear",
			["692"] = "Wrynn's Vanguard",
			["6AC"] = "Laughing Skull Orcs",
			["6AE"] = "Sha'tari Defense",
			["6AF"] = "Steamwheedle Preservation Society",
			["6B0"] = "GarInvasion_IronHorde",
			["6B1"] = "GarInvasion_ShadowCouncil",
			["6B2"] = "GarInvasion_IronHorde",
			["6B3"] = "GarInvasion_Ogres",
			["6B4"] = "GarInvasion_Primals",
			["6B5"] = "GarInvasion_Breakers",
			["6B6"] = "GarInvasion_ThunderLord",
			["6B7"] = "GarInvasion_Shadowmoon",
			["6C3"] = "Council of Exarchs",
			["6C4"] = "Steamwheedle Draenor Expedition",
			["6C5"] = "Delvar Ironfist",
			["6C7"] = "Barracks Bodyguards",
			["6C8"] = "Tormmok",
			["6C9"] = "Talonpriest Ishaal",
			["6CA"] = "Defender Illona",
			["6CB"] = "Vivianne",
			["6CC"] = "Aeda Brightdawn",
			["6CD"] = "Leorajh",
			["717"] = "Gilnean Survivors",
			["724"] = "Highmountain Tribe",
			["729"]	= "Uncrowned",
			["737"] = "Hand of the Prophet",
			["738"] = "Vol'jin's Headhunters",
			["739"] = "Order of the Awakened",	-- 1849
			["73A"] = "The Saberstalkers",
			["743"] = "The Nightfallen",
			["744"] = "Arcane Thirst (Thalyssra)",
			["746"] = "Arcane Thirst (Oculeth)",
			["75B"] = "Dreamweavers",
			["760"] = "Jandvik Vrykul",
			["766"] = "The Wardens",
			["76B"] = "Moonguard",
			["76C"] = "Court of Farondis",
			["77F"] = "Arcane Thirst (Valtrois)",
			["79B"] = "Illidari",
			["79C"] = "Valarjar",
			["7B7"] = "Conjurer Margoss",
			["7C0"] = "The First Responders",
			["7C5"] = "Moon Guard",
			["7E2"] = "Talon's Vengeance",
			["7FD"] = "Armies of Legionfall",
			["831"] = "Ilyssia of the Waters",
			["832"] = "Keeper Raynae",
			["833"] = "Akule Riverhorn",
			["834"] = "Corbyn",
			["835"] = "Sha'leth",
			["836"] = "Impus",
			["837"] = "Zandalari Empire",
			["83F"] = "Zandalari Dinosaurs",
["848"] = "Unknown",
			["857"] = "Chromie",
			["86C"] = "Talanji's Expedition",	-- 2156
			["86D"] = "The Honorbound",	-- 2157
			["86E"] = "Voldunai",	-- 2158
			["86F"] = "7th Legion",	-- 2159
			["870"] = "Proudmoore Admiralty",	-- 2160
			["871"] = "Order of Embers",	-- 2161
			["872"] = "Storm's Wake",	-- 2162
			["873"] = "Tortollan Seekers",	-- 2163
			["874"] = "Champions of Azeroth",	-- 2164
			["875"] = "Army of the Light",
			["87A"] = "Argussian Reach",
			["8B9"] = "Dino Training - Pterrodax",	-- 2233
			["8D8"] = "Kul Tiras - Drustvar",	-- 2264
			["8D9"] = "Kul Tiras - Stormsong",	-- 2265
			},


		reputationMappingFaction = {
			["015"] = 'Neutral',
			["02F"] = 'Alliance',
			["036"] = 'Alliance',
			["03B"] = 'Neutral',
			["043"] = 'Horde',
			["044"] = 'Horde',
			["045"] = 'Alliance',
			["046"] = 'Neutral',
			["048"] = 'Alliance',
			["04C"] = 'Horde',
			["051"] = 'Horde',
			["057"] = 'Neutral',
			["05C"] = 'Neutral',
			["05D"] = 'Neutral',
			["0A9"] = 'Neutral',
			["10E"] = 'Neutral',
			["15D"] = 'Neutral',
			["171"] = 'Alliance',
			["1D5"] = 'Alliance',
			["1D6"] = 'Neutral',
			["1FD"] = 'Alliance',
			["1FE"] = 'Horde',
			["211"] = 'Neutral',
			["212"] = 'Horde',
			["240"] = 'Neutral',
			["241"] = 'Neutral',
			["24D"] = 'Alliance',
			["261"] = 'Neutral',
			["2D9"] = 'Horde',
			["2DA"] = 'Alliance',
			["2ED"] = 'Neutral',
			["329"] = 'Neutral',
			["379"] = 'Horde',
			["37A"] = 'Alliance',
			["38D"] = 'Neutral',
			["38E"] = 'Neutral',
			["38F"] = 'Horde',
			["39A"] = 'Horde',
			["3A2"] = 'Alliance',
			["3A4"] = 'Neutral',
			["3A5"] = 'Neutral',
			["3A6"] = 'Neutral',
			["3A7"] = 'Neutral',
			["3A8"] = 'Neutral',
			["3AD"] = 'Horde',
			["3AE"] = 'Neutral',
			["3B2"] = 'Alliance',
			["3B3"] = 'Horde',
			["3C7"] = 'Neutral',
			["3CA"] = 'Neutral',
			["3D2"] = 'Alliance',
			["3DD"] = 'Neutral',
			["3DE"] = 'Neutral',
			["3F3"] = 'Neutral',
			["3F4"] = 'Neutral',
			["3F7"] = 'Neutral',
			["407"] = 'Neutral',
			["40D"] = 'Alliance',
			["40E"] = 'Neutral',
			["41A"] = 'Alliance',
			["41C"] = 'Horde',
			["428"] = 'Horde',
			["42B"] = 'Horde',
			["42C"] = 'Alliance',
			["431"] = 'Neutral',
			["435"] = 'Neutral',
			["43D"] = 'Horde',
			["442"] = 'Neutral',
			["443"] = 'Neutral',
			["446"] = 'Alliance',
			["449"] = 'Neutral',
			["44A"] = 'Neutral',
			["450"] = 'Neutral',
			["451"] = 'Neutral',
			["452"] = 'Neutral',
			["45D"] = 'Neutral',
			["45F"] = 'Neutral',
			["464"] = 'Horde',
			["466"] = 'Alliance',
			["46D"] = 'Horde',
			["46E"] = 'Alliance',
			["46F"] = 'Neutral',
			["470"] = 'Horde',
			["484"] = 'Neutral',
			["486"] = 'Neutral',
			["490"] = 'Neutral',
			["493"] = 'Neutral',
			["494"] = 'Horde',
			["495"] = 'Neutral',
			["496"] = 'Alliance',
			["499"] = 'Alliance',
			["49A"] = 'Horde',
			["4B4"] = 'Neutral',
			["4C0"] = 'Neutral',
			["4CC"] = 'Horde',
			["4DA"] = 'Alliance',
			["4DB"] = 'Horde',
			["4F5"] = 'Neutral',
			["4F6"] = 'Neutral',
			["4F7"] = 'Neutral',
			["4F8"] = 'Neutral',
			["4F9"] = 'Neutral',
			["4FB"] = 'Neutral',
			["4FC"] = 'Neutral',
			["4FD"] = 'Neutral',
			["4FE"] = 'Neutral',
			["4FF"] = 'Neutral',
			["500"] = 'Neutral',
			["501"] = 'Neutral',
			["502"] = 'Neutral',
			["503"] = 'Neutral',
			["516"] = 'Neutral',
			["539"] = 'Neutral',
			["53D"] = 'Neutral',
			["541"] = 'Neutral',
			["547"] = 'Neutral',
			["548"] = 'Horde',
			["549"] = 'Alliance',
			["54D"] = 'Neutral',
			["54E"] = 'Neutral',
			["54F"] = 'Neutral',
			["55F"] = 'Horde',
			["560"] = 'Alliance',
			["56B"] = 'Alliance',
			["56C"] = 'Horde',
			["59B"] = 'Neutral',
			["5A5"] = 'Horde',
			["5D4"] = 'Neutral',
			["5EB"] = 'Neutral',
			["5F0"] = 'Neutral',
			["68F"] = 'Neutral',
			["691"] = 'Horde',
			["692"] = 'Alliance',
			["6AC"] = 'Horde',
			["6AE"] = 'Alliance',
			["6AF"] = 'Neutral',
			["6B0"] = "Neutral",
			["6B1"] = "Neutral",
			["6B2"] = "Neutral",
			["6B3"] = "Neutral",
			["6B4"] = "Neutral",
			["6B5"] = "Neutral",
			["6B6"] = "Neutral",
			["6B7"] = "Neutral",
			["6C3"] = 'Alliance',
			["6C4"] = 'Neutral',
			["6C5"] = 'Alliance',
			["6C7"] = 'Neutral',
			["6C8"] = 'Neutral',
			["6C9"] = 'Neutral',
			["6CA"] = 'Alliance',
			["6CB"] = 'Horde',
			["6CC"] = 'Horde',
			["6CD"] = 'Neutral',
			["717"] = "Neutral",
			["724"] = "Neutral",
			["729"]	= "Neutral",
			["737"] = "Alliance",
			["738"] = "Horde",
			["739"] = "Neutral",
			["73A"] = "Neutral",
			["743"] = "Neutral",
			["744"] = "Neutral",
			["746"] = "Neutral",
			["75B"] = "Neutral",
			["760"] = "Neutral",
			["766"] = "Neutral",
			["76B"] = "Neutral",
			["76C"] = "Neutral",
			["77F"] = "Neutral",
			["79B"] = "Neutral",
			["79C"] = "Neutral",
			["7B7"] = "Neutral",
			["7C0"] = "Neutral",
			["7C5"] = "Neutral",
			["7E2"] = "Neutral",
			["7FD"] = "Neutral",
			["831"] = "Neutral",
			["832"] = "Neutral",
			["833"] = "Neutral",
			["834"] = "Neutral",
			["835"] = "Neutral",
			["836"] = "Neutral",
			["837"] = "Neutral",	-- TODO: Determine faction
			["83F"] = "Neutral",	-- TODO: Determine faction
["848"] = "Neutral",	-- TODO: Determine faction
			["857"] = "Neutral",
			["86C"] = "Neutral",	-- TODO: Determine faction
			["86D"] = "Neutral",	-- TODO: Determine faction
			["86E"] = "Neutral",	-- TODO: Determine faction
			["86F"] = "Neutral",	-- TODO: Determine faction
			["870"] = "Neutral",	-- TODO: Determine faction
			["871"] = "Neutral",	-- TODO: Determine faction
			["872"] = "Neutral",	-- TODO: Determine faction
			["873"] = "Neutral",	-- TODO: Determine faction
			["874"] = "Neutral",	-- TODO: Determine faction
			["875"] = "Neutral",
			["87A"] = "Neutral",
			["8B9"] = "Neutral",	-- TODO: Determine faction
			["8D8"] = "Neutral",	-- TODO: Determine faction
			["8D9"] = "Neutral",	-- TODO: Determine faction
			},

		slashCommandOptions = {},
		specialQuests = { },
		statusMapping = { ['C'] = "Completed", ['F'] = 'Faction', ['G'] = 'Gender', ['H'] = 'Holiday', ['I'] = 'Invalidated', ['L'] = "InLog",
			['P'] = 'Profession', ['Q'] = 'Prerequisites', ['R'] = 'Race', ['S'] = 'Class', ['T'] = 'Reputation', ['V'] = "Level", },
		timeSinceLastUpdate = 0,
		timings = {},	-- a table of debug timings whose keys are areas of interest, and values are elapsed times in milliseconds
		tooltip = nil,
		tracking = false,
		trackingStarted = false,
		useAncestor = true,
		verifyTable = {},
		verifyTableCount = 0,
--		warnedClientQuestLocationsAccept = nil,
--		warnedClientQuestLocationsTurnin = nil,
		zoneNameMapping = {},	-- maps zone names into map IDs
		zonesForLootingTreasure = {
			[941] = true, -- Frostfire Ridge
			[945] = true,
			[946] = true, -- Talador
			[947] = true, -- Shadowmoon Valley
			[948] = true,
			[949] = true, -- Gorgrond
			[950] = true,
			[951] = true,
			[1014] = true, -- Dalaran
			[1015] = true, -- Azsuna
			[1017] = true, -- Sturmheim
			[1018] = true, -- Val'sharah
			[1021] = true, -- Broken Shore
			[1022] = true, -- Felheim
			[1024] = true, -- Highmountain
			[1028] = true,
			[1032] = true,
			[1033] = true, -- Suramar
			[1080] = true, -- Thunder Totem village in HighMountain
			[1096] = true, -- Eye of Azshara
			[1135] = true, -- Krokuun
			[1170] = true, -- Mac'Aree
			[1171] = true, -- Antoran Wastes
			},

		---
		--	Returns the mapID where the player currently is.
		GetCurrentMapAreaID = function()
-- C_Map.GetBestMapForUnit will return nil if it can't find a map for that unit, MapUtil.GetDisplayableMapForPlayer will uses a fallback map if so
--				return C_Map.GetBestMapForUnit('player')
			return MapUtil.GetDisplayableMapForPlayer()
		end,

		---
		--	Returns the mapID of where the map is showing.
		GetCurrentDisplayedMapAreaID = function()
--	Prior to 26567 there was C_Map API to use, but now we have to ask the map itself, which only
--	works if we have shown the map.
--			return Grail.battleForAzeroth and C_Map.GetCurrentMapID() or Grail.GetCurrentMapAreaID()
			return WorldMapFrame:GetMapID() or Grail.GetCurrentMapAreaID()
		end,

		---
		--	Returns whether the specified achievement is complete.
		--	@param soughtAchievementId The standard numeric achievement ID representing an achievement.
		--	@param onlyPlayerCompleted If true, the return value indicates whether the player completed the achievement, otherwise it represents whether the achievement is completed on the account.
		--	@return true is the achievement is complete, false otherwise.
		AchievementComplete = function(self, soughtAchievementId, onlyPlayerCompleted)
			local _, _, _, achievementComplete, _, _, _, _, _, _, _, _, playerCompletedIt = GetAchievementInfo(soughtAchievementId)
			local retval = achievementComplete
			if onlyPlayerCompleted then
				retval = playerCompletedIt
			end
			return retval
		end,

		_LoadContinentData = function(self)
			--	Attempt to get all the Continents by starting wherever you are and getting the Cosmic
			--	map and then asking it for all the Continents that are children of it, hoping the API
			--	will bypass the intervening World maps.
			local currentMapId, TOP_MOST, ALL_DESCENDANTS = Grail.GetCurrentMapAreaID(), true, true
			local cosmicMapInfo = MapUtil.GetMapParentInfo(currentMapId or 946, Enum.UIMapType.Cosmic, TOP_MOST)
			local continents = C_Map.GetMapChildrenInfo(cosmicMapInfo.mapID, Enum.UIMapType.Continent, ALL_DESCENDANTS)
			self.continentMapIds = {}
			self.mapToContinentMapping = {}		-- key is mapId, value is continent mapId
			for i, continentInfo in ipairs(continents) do
				local L = { name = continentInfo.name, zones = {}, mapID = continentInfo.mapID, dungeons = {} }
				local zones = C_Map.GetMapChildrenInfo(continentInfo.mapID, Enum.UIMapType.Zone, ALL_DESCENDANTS)
				for j, zoneInfo in ipairs(zones) do
					self:_AddMapId(L.zones, zoneInfo.name, zoneInfo.mapID, L.mapID)
				end
				local dungeons = C_Map.GetMapChildrenInfo(continentInfo.mapID, Enum.UIMapType.Dungeon, ALL_DESCENDANTS)
				for j, dungeonInfo in ipairs(dungeons) do
					self:_AddMapId(L.dungeons, dungeonInfo.name, dungeonInfo.mapID, L.mapID)
				end
-- TODO: Do we need to handle Micro map types?
				-- Stormsong Valley is an Orphan and not a Zone in beta at least
				local orphans = C_Map.GetMapChildrenInfo(continentInfo.mapID, Enum.UIMapType.Orphan, ALL_DESCENDANTS)
				for j, orphanInfo in ipairs(orphans) do
					self:_AddMapId(L.zones, orphanInfo.name, orphanInfo.mapID, L.mapID)
				end
				self.continents[L.mapID] = L
				tinsert(self.continentMapIds, L.mapID)
			end
			table.sort(self.continentMapIds)
		end,

		_AddMapId = function(self, zoneTable, zoneName, mapId, continentMapId)
			zoneTable[#zoneTable + 1] = { name = zoneName, mapID = mapId }
			while nil ~= self.zoneNameMapping[zoneName] do
				zoneName = zoneName .. ' '
			end
			self.zoneNameMapping[zoneName] = mapId
			self.mapToContinentMapping[mapId] = continentMapId
		end,

		---
		--	Internal Use.
		--	Updates the internal database to associate the specified quest with the specified map area,
		--	optionally setting the title for the map area.
		--	@param questId The standard numeric questId representing a quest.
		--	@param mapAreaId The standard numeric map are ID representing the map area.
		--	@param title The localized name of the map area.
		AddQuestToMapArea = function(self, questId, mapAreaId, title)
			if nil ~= questId and nil ~= mapAreaId then
				if not self.experimental then
					self:_InsertSet(self.indexedQuests, mapAreaId, questId)
				else
					self:_MarkQuestInDatabase(questId, self.indexedQuests[mapAreaId])
				end
				if nil == self.mapAreaMapping[mapAreaId] then self.mapAreaMapping[mapAreaId] = title end
			end
		end,

		--	This routine is registered to be called when any of the notifications this addon can post are posted.
		--	It formats a message that is stored in the tracking system.
		--	@param callbackType The string representing the type of callback as posted by the notification system.
		--	@param questId The standard questId posted by the notification system.
		_AddTrackingCallback = function(callbackType, questId)
			local message = strformat("%s %s(%d)", callbackType, Grail:QuestName(questId) or "NO NAME", questId)
			if "Accept" == callbackType or "Complete" == callbackType then
				local targetName, npcId, coordinates = Grail:TargetInformation()
				if nil ~= targetName then
					if nil == npcId then npcId = -123 end
					if nil == coordinates then coordinates = "NO COORDS" end
					message = strformat("%s %s %s(%d) %s", message, ("Accept" == callbackType) and "from" or "to", targetName, npcId, coordinates)
				else
					message = strformat("%s, self coords: %s", message, Grail:Coordinates())
				end
			end
			Grail:_AddTrackingMessage(message)
		end,

		--	This adds the provided message to the tracking system.  The first time this is called, a timestamp with some player
		--	information is logged into the tracking system as well.
		--	@param msg The string that will be added to the tracking system.
		_AddTrackingMessage = function(self, msg)
			if nil == GrailDatabase["Tracking"] then GrailDatabase["Tracking"] = {} end
			if not self.trackingStarted then
				local hour, minute = GetGameTime()
				local weekday, month, day, year = CalendarGetDate()
				tinsert(GrailDatabase["Tracking"], strformat("%4d-%02d-%02d %02d:%02d %s/%s/%s/%s/%s/%s/%s/%s/%d", year, month, day, hour, minute, self.playerRealm, self.playerName, self.playerFaction, self.playerClass, self.playerRace, self.playerGender, self.playerLocale, self.portal, self.blizzardRelease))
				self.trackingStarted = true
			end
			tinsert(GrailDatabase["Tracking"], msg)
		end,

		_RemoveWorldQuest = function(self, soughtQuestId)
			local index, foundIndex = 1, nil
			for _, questId in pairs(self.invalidateControl[self.invalidateGroupCurrentWorldQuests]) do
				if questId == soughtQuestId then
					foundIndex = index
				end
				index = index + 1
			end
			if foundIndex then
				tremove(self.invalidateControl[self.invalidateGroupCurrentWorldQuests], foundIndex)
			end
--			self.availableWorldQuests[questId] = nil
			--	There is no need to deal with the timer that goes off to reset the quests because
			--	if we are removing the first one to trigger, all the others remaining would cause
			--	the trigger to be later.  And if we remove any other, the current trigger will be
			--	called properly anyway.
		end,

		_ResetWorldQuests = function(self)
--			self.questsToInvalidate = self.availableWorldQuests
			self.questsToInvalidate = self.invalidateControl[self.invalidateGroupCurrentWorldQuests]
			self:_AddWorldQuests()
			C_Timer.After(3, function()
--				local q = {}
--				for questId, _ in pairs(self.questsToInvalidate) do
--					tinsert(q, questId)
--				end
--				self:_StatusCodeInvalidate(q)
				self:_StatusCodeInvalidate(self.questsToInvalidate)
				end)
		end,

		_AddWorldQuestsUpdateTimes = function(self)
			local hour, minute = GetGameTime()
--			local newTable = {}
			--	We set the smallestMinutes to the top of the hour with the intention to check every top of the hour at a minimum
			--	because we do not know exactly when Blizzard will refresh the list of available world quests (meaning add new ones)
			--	because this will change with each server.
			local smallestMinutes = 60 - minute
--			for questId, _ in pairs(self.availableWorldQuests) do
			for _, questId in pairs(self.invalidateControl[self.invalidateGroupCurrentWorldQuests]) do
				local minutesLeft = C_TaskQuest.GetQuestTimeLeftMinutes(questId)
				if 0 < minutesLeft then
----					newTable[questId] = minutesLeft .. ' => ' .. C_TaskQuest.GetQuestInfoByQuestID(questId)
--					newTable[questId] = minutesLeft
					if minutesLeft < smallestMinutes then
						smallestMinutes = minutesLeft
					end
				else
					if self.debug and self.levelingLevel >= 110 then
						local weekday, month, day, year = CalendarGetDate()
						local stringValue = strformat("%4d-%02d-%02d %02d:%02d %s/%s", year, month, day, hour, minute, self.playerRealm, self.playerName)
						GrailDatabase.learned = GrailDatabase.learned or {}
						GrailDatabase.learned.WORLD_QUEST_UNAVAILABLE = GrailDatabase.learned.WORLD_QUEST_UNAVAILABLE or {}
						GrailDatabase.learned.WORLD_QUEST_UNAVAILABLE[questId] = stringValue
					end
				end
			end
--			self.availableWorldQuests = newTable
			C_Timer.After((smallestMinutes + 1) * 60, function() self:_ResetWorldQuests() end)
		end,

		--	This adds to our internal data structure the world quests found available
		_AddWorldQuests = function(self)
			self.invalidateControl[self.invalidateGroupCurrentWorldQuests] = {}
--			self.availableWorldQuests = {}

			local mapIdsForWorldQuests = { 62, 625, 630, 634, 641, 646, 650, 680, 790, 830, 882, 885, 862, 863, 864, 895, 896, 942, }
			for _, mapId in pairs(mapIdsForWorldQuests) do
				local tasks = C_TaskQuest.GetQuestsForPlayerByMapID(mapId)
				if nil ~= tasks and 0 < #tasks then
					for k,v in ipairs(tasks) do
						if GrailDatabase.debug then
							local tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex = GetQuestTagInfo(v.questId)
							GrailDatabase.eek = GrailDatabase.eek or {}
							if tagID and ((nil == self._LearnedWorldQuestProfessionMapping[tagID] and nil == self._LearnedWorldQuestTypeMapping[tagID]) or GrailDatabase.worldquestforcing) then
								GrailDatabase.eek[v.questId] = 'A:'..(tagID and tagID or 'NoTagID')..' B:'..(tagName and tagName or 'NoTagName')..' C:'..(worldQuestType and worldQuestType or 'NotWorld') ..' D:'..(rarity and rarity or 'NO')..' E:'..(isElite and 'YES' or 'NO')..' F:'..(tradeskillLineIndex or 'nil')
							end
						end
--	41672 123	"Enchanting World Quest" 1 1 false 9

--	1	Group
--	21	Class
--	41	PvP
--	62	Raid
--	81	Dungeon
--	82	World Event
--	83	Legendary
--	84	Escort
--	85	Heroic
--	88	Raid (10)
--	89	Raid (25)
--	98	Scenario
--	102	Account
--	104	Side Quest
--	107	Artifact
--	109 normal world quest
--	110 epic
--	111	elite
--	112	epic elite
--	113	PVP
--	114	First Aid
--	115	battle pet
--	116 Blacksmithing
--	117	Leatherworking
--	118	Alchemy
--	119	Herbalism
--	120	Mining
--	121	Tailoring
--	122 Engineering
--	123	Enchanting	tradeskillLineIndex: 9
--	124	Skinning
--	125	Jewelcrafting
--	126	Inscription

--	128	Emissary
--	129	Archaeology
--	130	Fishing		tradeskillLineIndex: 10
--	131 Cooking		tradeskillLineIndex: 7

--	135	rare
--	136	rare elite
--	137	Dungeon

--	139 Legion Invasion World Quest
--	140	Rated Reward
--	141	Raid World Quest
--	142	Legion Invasion Elite World Quest
--	143	Legionfall Contribution
--	144	Legionfall World Quest
--	145	Legionfall Dungeon World Quest
--	146	Legionfall Invasion World Quest
--	147	Warfront - Barrens
--	148	Pickpocketing

						self:_LearnWorldQuest(v.questId, mapId, v.x, v.y)
--						self.availableWorldQuests[v.questId] = true
						tinsert(self.invalidateControl[self.invalidateGroupCurrentWorldQuests], v.questId)
						C_TaskQuest.GetQuestTimeLeftMinutes(v.questId)	-- attempting to prime the system, because first calls do not work
					end
				end
			end
			C_Timer.After(2, function() Grail:_AddWorldQuestsUpdateTimes() end)
		end,

		_LearnedWorldQuestProfessionMapping = { [116] = 'B', [117] = 'L', [118] = 'A', [119] = 'H', [120]= 'M', [121] = 'T', [122] = 'N', [123] = 'E', [124] = 'S', [125] = 'J', [126] = 'I', [130] = 'F', [131] = 'C', },

		_LearnedWorldQuestTypeMapping = { [109] = 0, [111] = 0, [112] = 0, [113] = 0x00000100, [115] = 0x00004000, [135] = 0, [136] = 0, [137] = 0x00000040, [139] = 0, [141] = 0x00000080, [142] = 0, [144] = 0, [145] = 0x00000040, },

		_LearnWorldQuest = function(self, questId, mapId, x, y)
-- TODO: Figure out how to use the x, y to create appropriate alias NPCs for 0, that have the pattern -xmapId, where x is not already used starting from -10 and moving more negative. the turnin would be -mapId
			questId = tonumber(questId)
			if nil == questId then return end
			GrailDatabase.learned = GrailDatabase.learned or {}
			GrailDatabase.learned.QUEST = GrailDatabase.learned.QUEST or {}
			local currentLine = GrailDatabase.learned.QUEST[questId]
			local needToAddKCode, needToAddLCode, needToAddPCode = false, false, false
			local kCodeToAdd, lCodeToAdd, pCodeToAdd = 'K110', 'L110', 'P:a'..questId
			local tagId, tagName = GetQuestTagInfo(questId)
			local professionRequirement = self._LearnedWorldQuestProfessionMapping[tagId]
			local typeModifier = self._LearnedWorldQuestTypeMapping[tagId]
			local typeValue = 262144

			if nil ~= professionRequirement then
				pCodeToAdd = pCodeToAdd .. '+P' .. professionRequirement .. '001'
			end
			if (not self.battleForAzeroth and 1021 == mapId) or (self.battleForAzeroth and 646 == mapId) then
				pCodeToAdd = pCodeToAdd .. '+46734'
			end
			if (not self.battleForAzeroth and 1135 == mapId) or (self.battleForAzeroth and 830 == mapId) then
				pCodeToAdd = pCodeToAdd .. '+48199'	-- PTR was 47743, but live seems to be 48199
			end
			if (not self.battleForAzeroth and 1170 == mapId) or (self.battleForAzeroth and 882 == mapId) then
				pCodeToAdd = pCodeToAdd .. '+48107'
			end
			if (not self.battleForAzeroth and 1171 == mapId) or (self.battleForAzeroth and 885 == mapId) then
				pCodeToAdd = pCodeToAdd .. '+48199'
			end
			if nil ~= typeModifier then
				typeValue = typeValue + typeModifier
			end
			kCodeToAdd = kCodeToAdd .. typeValue

			--	We do not check whether the codes are present in currentLine because we assume when
			--	currentLine was processed during the cleaning process anything already in the database
			--	was removed from currentLine, and anything that was not removed updated the internal
			--	structures properly so the following checks against the internal structures will work
			--	as they should.

			--	Check the internal structure to ensure we have the knowledge that we want.
			if 110 ~= Grail:QuestLevel(questId) or not Grail:IsWorldQuest(questId) then
				needToAddKCode = true
			end
			local meetsReqs, levelToCompare, levelRequired, levelNotToExceed = Grail:MeetsRequirementLevel(questId, 110)
			if 110 ~= levelRequired then
				needToAddLCode = true
			end
			if nil == strfind(self.questPrerequisites[questId] or '', strsub(pCodeToAdd, 3), 1, true) then
				needToAddPCode = true
			end

			local newLine = currentLine or ''
			local spacer = (strlen(newLine) > 0) and ' ' or ''
			if needToAddKCode then
				local possibleQuestLevel = tonumber(strsub(kCodeToAdd, 2, 4))
				local possibleQuestType = tonumber(strsub(kCodeToAdd, 5))
				if nil ~= possibleQuestLevel then
					self:_SetQuestLevel(questId, possibleQuestLevel)
				end
				if nil ~= possibleQuestType then
					self:_MarkQuestType(questId, possibleQuestType)
				end
				newLine = newLine .. spacer .. kCodeToAdd
				spacer = ' '
			end
			if needToAddLCode then
				self:_SetQuestRequiredLevel(questId, tonumber(strsub(lCodeToAdd, 2)))
				newLine = newLine .. spacer .. lCodeToAdd
				spacer = ' '
			end
			if needToAddPCode then
				local codeToAdd = strsub(pCodeToAdd, 3)
				if nil == self.questPrerequisites[questId] then
					self.questPrerequisites[questId] = codeToAdd
				else
					self.questPrerequisites[questId] = self.questPrerequisites[questId] .. "+" .. codeToAdd
				end
				newLine = newLine .. spacer .. pCodeToAdd
				spacer = ' '
			end
			if 0 < strlen(newLine) then
				GrailDatabase.learned.QUEST[questId] = newLine
			end
		end,

		AliasQuestId = function(self, questId)
			return self:_QuestGenericAccess(questId, 'Y')
		end,

		_AllEvaluateTrueF = function(self, codesTable, p, f, forceSpecificChecksOnly)
			local stillGood, failures = true, {}

			if nil ~= codesTable then
				for key, value in pairs(codesTable) do
					if "table" == type(value) then
						local anyEvaluateTrue, requirementPresent, allFailures = self:_AnyEvaluateTrueF(value, p, f, forceSpecificChecksOnly)
						if requirementPresent then
							stillGood = stillGood and anyEvaluateTrue
						end
						if nil ~= allFailures then self:_TableAppend(failures, allFailures) end
					else
						local good, allFailures = f(value, p, forceSpecificChecksOnly)
						stillGood = stillGood and good
						if nil ~= allFailures then self:_TableAppend(failures, allFailures) end
					end
				end
			end

			if 0 == #failures then failures = nil end
			return stillGood, failures
		end,

		_AllEvaluateTrueS = function(self, codeString, p, f, forceSpecificChecksOnly)
			local stillGood, failures = true, nil
			if nil ~= codeString then
				local start, length = 1, strlen(codeString)
				local stop = length
				local good, allFailures
				local anyEvaluateTrue, requirementPresent
				while start <= length do
					local found = strfind(codeString, "+", start, true)
					if nil == found then
						if 1 < start then
							stop = strlen(codeString)
						end
					else
						stop = found - 1
					end
					local substring = strsub(codeString, start, stop)
					if nil ~= strfind(substring, "|", 1, true) then
						anyEvaluateTrue, requirementPresent, allFailures = self:_AnyEvaluateTrueS(substring, p, f, "|", forceSpecificChecksOnly)
						if requirementPresent then
							stillGood = stillGood and anyEvaluateTrue
						end
					else
						good, allFailures = f(substring, p, forceSpecificChecksOnly)
						stillGood = stillGood and good
					end
					start = stop + 2
					if nil ~= allFailures then
						failures = failures or {}
						self:_TableAppend(failures, allFailures)
					end
				end
			end
			return stillGood, failures
		end,

		AncestorStatusCode = function(self, questId, baseStatusCode)
			local prerequisites = self:QuestPrerequisites(questId, true)

			if nil ~= prerequisites then
				local anyEvaluateTrue, requirementPresent, allFailures = self:_AnyEvaluateTrueF(prerequisites, { q = questId }, Grail._EvaluateCodeDoesNotFailQuestStatus)
				if requirementPresent and not anyEvaluateTrue and nil ~= allFailures then
--					baseStatusCode = baseStatusCode + (1024 * allFailures[1])
					for _, failure in pairs(allFailures) do
						baseStatusCode = bitbor(baseStatusCode, bitband(failure, Grail.bitMaskQuestFailure) * 1024)		-- puts them up into ancestor failure range
						baseStatusCode = bitbor(baseStatusCode, bitband(failure, Grail.bitMaskQuestFailureWithAncestor - Grail.bitMaskQuestFailure))
					end
				end
				
			end

			return baseStatusCode
		end,

		--	This looks at the code with appropriate prefix from the specified log and analyzes it to determine if any of the quests
		--	the code contains have been completed, or if checkLog is true, are in the quest log.  The format for the code is a comma
		--	separated list of single questIds that match or if more than one is required to match, they are separated by a plus.  So:
		--	<br>123,456,789+1122,3344<br>means and of the following quests would match:<br>123<br>456<br>789 and 1122<br>3344<br>
		--	@param questId The standard numeric questId representing a quest.
		--	@param codePrefix An prefix used to determine which type of internal code to process.
		--	@return True if any of the codes quests are completed (or appropriately in the quest log), false otherwise.
		--	@return True is there actually is a code that needed checking, false otherwise.
		_AnyEvaluateTrue = function(self, questId, codePrefix, forceSpecificChecksOnly)
			questId = tonumber(questId)
--			if nil == questId or nil == self.quests[questId] then return false end
			if nil == questId or nil == self.questCodes[questId] then return false end
--			local codeValues = self.quests[questId][codePrefix]
			local codeValues
			if 'P' == codePrefix then
				codeValues = self.questPrerequisites[questId]
			else
-- TODO: SMH: Check the following because there was an error reported.  Note that the code above checks questCodes and not quests...investigate
				codeValues = self.quests[questId][codePrefix]
			end
			local dangerous = (codePrefix == 'I' or codePrefix == 'B')
			return self:_AnyEvaluateTrueF(codeValues, { q = questId, d = dangerous}, Grail._EvaluateCodeAsPrerequisite, forceSpecificChecksOnly)
		end,

		-- This is part of evaluating a "pattern" set of requirements specified in the codesTable, using
		-- the function f to evaluate whether individual codes meet requirements. The table p contains
		-- parameters to be used by any function.
		_AnyEvaluateTrueF = function(self, codesTable, p, f, forceSpecificChecksOnly)
			if "table" ~= type(codesTable) then return self:_AnyEvaluateTrueS(codesTable, p, f, ',', forceSpecificChecksOnly) end
			local anyEvaluateTrue, requirementPresent, allFailures = false, false, {}

			if nil ~= codesTable then
				local currentFailures, valueToUse
				local noBreak = p and p.noBreak
				requirementPresent = true
				for key, value in pairs(codesTable) do
					valueToUse = ("table" == type(value)) and value or {value}
					anyEvaluateTrue, currentFailures = self:_AllEvaluateTrueF(valueToUse, p, f, forceSpecificChecksOnly)
					if nil ~= currentFailures then
						self:_TableAppend(allFailures, currentFailures)
					end
					if anyEvaluateTrue and not noBreak then break end
				end
			end

			if 0 == #allFailures then allFailures = nil end
			return anyEvaluateTrue, requirementPresent, allFailures
		end,

		_AnyEvaluateTrueS = function(self, codeString, p, f, splitCode, forceSpecificChecksOnly)
			local anyEvaluateTrue, requirementPresent, allFailures = false, false, nil

			splitCode = splitCode or ","
			if nil ~= codeString then
				local currentFailures
				local noBreak = p and p.noBreak
				requirementPresent = true
				local start, length = 1, strlen(codeString)
				local stop = length
				while start <= length do
					local found = strfind(codeString, splitCode, start, true)
					if nil == found then
						if 1 < start then
							stop = strlen(codeString)
						end
					else
						stop = found - 1
					end
					anyEvaluateTrue, currentFailures = self:_AllEvaluateTrueS(strsub(codeString, start, stop), p, f, forceSpecificChecksOnly)
					start = stop + 2
					if nil ~= currentFailures then
						allFailures = allFailures or {}
						self:_TableAppend(allFailures, currentFailures)
					end
-- TODO: Technically we do not use noBreak at the moment, do we are fine, but we should really check to see if anyEvaluateTrue has ever been correct and record that to be used in return
					if anyEvaluateTrue and not noBreak then break end
				end
			end
			return anyEvaluateTrue, requirementPresent, allFailures
		end,

		ArtifactChange = function(self, knowledgeLevel, knowledgeMultiplier)
			self.artifactKnowledgeLevel = knowledgeLevel or 0
			self:_StatusCodeInvalidate(self.invalidateControl[self.invalidateGroupArtifactKnowledge])
		end,

		ArtifactKnowledgeLevel = function(self)
--	In 7.1 the following API does not work unless the artifact UI is already open.
--			return C_ArtifactUI.GetArtifactKnowledgeLevel()
--	Using the LibArtifactData allows access to the artifact knowledge level, but we need
--	not use this since we can get this information from the hidden currency
--			if self.LAD then
--				self.artifactKnowledgeLevel = self.LAD:GetArtifactKnowledge()
--			end
			local _, artifactKnowledgeCurrency = GetCurrencyInfo(1171)
			self.artifactKnowledgeLevel = artifactKnowledgeCurrency or 0
			return self.artifactKnowledgeLevel
		end,

		ArtifactLevelMeetsOrExceeds = function(self, itemId, soughtLevel)
			local retval = false
			local currentLevel = self.artifactLevels[itemId]
			if nil ~= currentLevel and currentLevel >= soughtLevel then
				retval = true
			end
			return retval
		end,

		---
		--	Returns a table of questIds that are available breadcrumb quests for the specified quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@return A table of questIds for available breadcrumb quests for this quest, or nil if there are none.
		AvailableBreadcrumbs = function(self, questId)
			local retval = {}
			local possible = self:QuestBreadcrumbs(questId)
			if nil ~= possible then
				for _, qid in pairs(possible) do
					if self:CanAcceptQuest(qid, false, true) then
						tinsert(retval, qid)
					end
				end
			end
			if 0 == #retval then retval = nil end
			return retval
		end,

		--	Not used, as the name of the mission will be showin instead...
		_AvailableMissionsRewardItem = function(self, itemId, missionType)
			if itemId > 100000000 then itemId = itemId - 100000000 end
			local retval = false
			local missionTypeToUse = missionType or 4	-- default to those from the class hall map
			local availableMissions = C_Garrison.GetAvailableMissions(missionTypeToUse)
			if nil ~= availableMissions then
				for _, mission in pairs(availableMissions) do
					local rewards = mission.rewards
					if nil ~= rewards then
						for _, reward in pairs(rewards) do
							local possibleItemId = reward.itemID
							if nil ~= possibleItemId then
								if itemId == tonumber(possibleItemId) then
									retval = true
								end
							end
						end
					end
				end
			end
			return retval
		end,

		IsMissionAvailable = function(self, missionId, missionType)
			local retval = false
			if nil ~= missionId then
				local missionTypeToUse = missionType or 4	-- default to those from the class hall map
				local availableMissions = C_Garrison.GetAvailableMissions(missionTypeToUse)
				if nil ~= availableMissions then
					for _, mission in pairs(availableMissions) do
						if missionId == mission.missionID then
							retval = true
						end
					end
				end
			end
			return retval
		end,

		-- It seems Blizzard's API C_Garrison.GetBasicMissionInfo() returns an empty result
		-- when the mission is not currently available.  This means when we want to display
		-- the name we will need to display the mission ID instead.
		MissionName = function(self, missionId)
			local retval = nil
			if nil ~= missionId then
				local mission = C_Garrison.GetBasicMissionInfo(missionId)
				if nil ~= mission then
					retval = mission.name
				end
			end
			return retval
		end,

		_BagUpdates = function(type, ignored)
			if nil == Grail.processedBagUpdates then
				Grail:_RecordArtifactLevels()
				Grail.processedBagUpdates = true
			end
			local self = Grail
			self.cachedBagItems = nil
			-- we cheat and instead of doing any work here we just invalidate all the quests associated with
			-- items that need to be present or need not be present because the evaluation of status will
			-- check whether items are present
			local t = {}
			for itemId in pairs(self.questStatusCache['C']) do
--				self:_StatusCodeInvalidate(self.questStatusCache['C'][itemId])
				self:_TableAppend(t, self.questStatusCache['C'][itemId])
			end
			for itemId in pairs(self.npcStatusCache['C']) do
				self:_NPCLocationInvalidate(self.npcStatusCache['C'][itemId])
			end
			for itemId in pairs(self.questStatusCache['E']) do
--				self:_StatusCodeInvalidate(self.questStatusCache['E'][itemId])
				self:_TableAppend(t, self.questStatusCache['E'][itemId])
			end
			for itemId in pairs(self.npcStatusCache['E']) do
				self:_NPCLocationInvalidate(self.npcStatusCache['E'][itemId])
			end
			self:_StatusCodeInvalidate(t)
			wipe(t)
		end,

		---
		--	Returns true is the specified quest can be accepted based on the other parameters.  Otherwise returns false.
		--	@param questId The standard numeric questId representing a quest.
		--	@param ignoreCompleted	Ignores the status of the quest being completed.
		--	@param ignorePrerequisites	Ignores whether the quest has met all its prerequisites.
		--	@param ignoreInLog	Ignores whether the quest is already in the Blizzard quest log.
		--	@param ignoreLevelTooLow	Ignores whether the quest is too high for the player to obtain currently.
		--	@param ignoreHolidayRequirement	Ignores whether the quest is only available during specific holidays.
		--	@param buggedQuestsUnacceptable Specifies whether bugged quests are considered unacceptable.
		CanAcceptQuest = function(self, questId, ignoreCompleted, ignorePrerequisites, ignoreInLog, ignoreLevelTooLow, ignoreHolidayRequirement, buggedQuestsUnacceptable)
			local bitValue = self.bitMaskAcceptableMask
			if ignoreCompleted then bitValue = bitValue - self.bitMaskCompleted end
			if ignorePrerequisites then bitValue = bitValue - self.bitMaskPrerequisites end
			if ignoreInLog then bitValue = bitValue - self.bitMaskInLog - self.bitMaskInLogComplete end
			if ignoreLevelTooLow then bitValue = bitValue - self.bitMaskLevelTooLow end
			if ignoreHolidayRequirement then bitValue = bitValue - self.bitMaskHoliday end
			if buggedQuestsUnacceptable then bitValue = bitValue + self.bitMaskBugged end
			return (0 == bitband(self:StatusCode(questId), bitValue) and not self:IsQuestObsolete(questId) and not self:IsQuestPending(questId))
		end,

		---
		--	Determines whether the soughtHolidayName is currently being celebrated.
		--	@param soughtHolidayName The localized name of a holiday, like Brewfest or Darkmoon Faire.
		--	@return true if the holiday is being celebrated currently, or false otherwise
		CelebratingHoliday = function(self, soughtHolidayName)
			local retval = false
			local weekday, month, day, year = CalendarGetDate()
			local hour, minute = GetGameTime()
			local elapsedMinutes = hour * 60 + minute
			local i = 1
			local needsChristmasOrLater = false
			local holidayCode = self.reverseHolidayMapping[soughtHolidayName]
			if holidayCode == 'Z' then
				needsChristmasOrLater = true
				soughtHolidayName = self.holidayMapping['V']
			end
			if holidayCode == 'g' or holidayCode == 'h' or holidayCode == 'i' then
				soughtHolidayName = self.holidayMapping['f']
			end
			-- sometime between release 23478 and 23578 CalendarGetDayEvent was removed, replaced with C_Calendar.GetDayEvent which returns a table
			local CalendarGetNumDayEvents = self.battleForAzeroth and C_Calendar.GetNumDayEvents or CalendarGetNumDayEvents
			local numEvents = CalendarGetNumDayEvents(0, day)
			local title, calHour, calMinute, calendarType, sequenceType, eventType, texture, modStatus, inviteStatus, invitedBy, difficulty, inviteType
			for i = 1, numEvents do
                local event = C_Calendar.GetDayEvent(0, day, i)
				calendarType = event.calendarType
				eventType = event.eventType
				title = event.title
				texture = event.texture
				sequenceType = event.sequenceType
				local date = (event.sequenceType == "END") and event.endTime or event.startTime
				calHour = date.hour
				calMinute = date.minute
				--	hour and minute indicate time when event starts for START
				--	or ONGOING, and ends for END
				--	sequenceType is START, ONGOING, END
				--	texture can allow us to know which Timewalking Dungeon Event is
				--	happening:  calendar_weekendcataclysm,
				--				calendar_weekendwrathofthelichking,
				--				calendar_weekendburningcrusade
				local foundMatch = false
				if eventType == 0 and calendarType == 'HOLIDAY' and title == soughtHolidayName then
					foundMatch = true
				end
				if holidayCode == 'g' or holidayCode == 'h' or holidayCode == 'i' then
					if holidayCode == 'g' and texture ~= 'calendar_weekendburningcrusade' then
						foundMatch = false
					end
					if holidayCode == 'h' and texture ~= 'calendar_weekendwrathofthelichking' then
						foundMatch = false
					end
					if holidayCode == 'i' and texture ~= 'calendar_weekendcataclysm' then
						foundMatch = false
					end
				end
				if foundMatch then
					if sequenceType == 'ONGOING' then
						retval = true
					else
						-- Need to check time based on START/END
						local eventMinutes = calHour * 60 + calMinute
						if sequenceType == 'START' and elapsedMinutes >= eventMinutes then
							retval = true
						end
						if sequenceType == 'END' and elapsedMinutes < eventMinutes then
							retval = true
						end
					end
				end
				i = i + 1
			end
			if retval and needsChristmasOrLater then
				if 12 == month and 25 > day then
					retval = false
				end
			end
			if self.holidayMapping['U'] == soughtHolidayName then
				if (12 == month and 31 == day) then
					retval = true
				end
			end

			-- Stranglethorn Fishing Extravaganza quest givers appear on Saturday and Sunday
			if self.holidayMapping['X'] == soughtHolidayName then
				if weekday == 1 or weekday == 7 then
					retval = true
				end
			end

			-- Kalu'ak Fishing Derby quest giver appears on Sunday between 14h00 and 16h00 server
			if self.holidayMapping['K'] == soughtHolidayName then
				if weekday == 7 then
					if elapsedMinutes >= (14 * 60) and elapsedMinutes <= (16 * 60) then
						retval = true
					end
				end
			end

			return retval
		end,

		--	This returns a character based on how the quest is "classified".
		--		B	unobtainable
		--		C	completed
		--		D	daily
		--		G	can accept
		--		H	daily that is too high
		--		I	in log
		--		K	weekly
		--		L	too high
		--		O	world quest
		--		P	fails (prerequisites)
		--		R	repeatable
		--		U	unknown
		--		W	low-level	
		--		Y	legendary
		ClassificationOfQuestCode = function(self, questCode, shouldDisplayHolidays, buggedQuestsUnobtainable)
			local retval = 'U'
			local code, subcode, numeric = self:CodeParts(questCode)

			if nil ~= numeric then
				if code == 'BOGUS' then
					--	Nothing here, this is just to put all the rest in elseif
				elseif 'F' == code then
					if ('A' == subcode and 'Alliance' == self.playerFaction) or ('H' == subcode and 'Horde' == self.playerFaction) then
						retval = 'C'
					else
						retval = 'B'
					end
				elseif 'G' == code then
					if '' == subcode then
						retval = self:HasGarrisonBuilding(numeric) and 'C' or 'P'
					else
						retval = self:HasGarrisonBuildingInPlot(numeric, subcode) and 'C' or 'P'
					end
				elseif 'z' == code then
					retval = self:HasGarrisonBuildingNPCWorking(numeric) and 'C' or 'P'
				elseif 'I' == code then
					retval = self:SpellPresent(numeric) and 'C' or 'P'
				elseif 'i' == code then
					retval = self:SpellPresent(numeric) and 'P' or 'C'
				elseif 'J' == code then
					retval = self:AchievementComplete(numeric) and 'C' or 'G'
				elseif 'j' == code then
					retval = self:AchievementComplete(numeric) and 'B' or 'C'
				elseif 'K' == code then
					retval = self:ItemPresent(numeric) and 'C' or 'P'
				elseif 'k' == code then
					retval = self:ItemPresent(numeric) and 'P' or 'C'
				elseif 'L' == code then
					retval = (self.levelingLevel >= numeric) and 'C' or 'P'
				elseif 'l' == code then
					retval = (self.levelingLevel < numeric) and 'C' or 'P'
				elseif 'M' == code then
					retval = self:HasQuestEverBeenAbandoned(numeric) and 'C' or 'P'
				elseif 'm' == code then
					retval = self:HasQuestEverBeenAbandoned(numeric) and 'P' or 'C'
				elseif 'N' == code then
					retval = (self.classNameToCodeMapping[self.playerClass] == subcode) and 'C' or 'P'
				elseif 'P' == code then
					retval = self:ProfessionExceeds(subcode, numeric) and 'C' or 'P'
				elseif 'R' == code then
					retval = self:EverExperiencedSpell(numeric) and 'C' or 'P'
				elseif 'S' == code then
					retval = self:_HasSkill(numeric) and 'C' or 'P'
				elseif 's' == code then
					retval = self:_HasSkill(numeric) and 'P' or 'C'
				elseif 'T' == code or 't' == code then
					local exceeds, earnedValue = Grail:_ReputationExceeds(Grail.reputationMapping[subcode], numeric)
					retval = 'P'
					if (not exceeds and code == 't') or (exceeds and code == 'T') then
						retval = 'C'
					end
				elseif 'U' == code or 'u' == code then
					local exceeds, earnedValue = Grail:_FriendshipReputationExceeds(Grail.reputationMapping[subcode], numeric)
					retval = 'P'
					if (not exceeds and code == 'u') or (exceeds and code == 'U') then
						retval = 'C'
					end
				elseif 'V' == code then
--					retval = self:MeetsRequirementGroupAccepted(subcode, numeric) and 'C' or 'P'
					retval = self:MeetsRequirementGroupControl({groupNumber = subcode, minimum = numeric, accepted = true}) and 'C' or 'P'
				elseif 'W' == code then
--					retval = self:MeetsRequirementGroup(subcode, numeric) and 'C' or 'P'
					retval = self:MeetsRequirementGroupControl({groupNumber = subcode, minimum = numeric, turnedIn = true}) and 'C' or 'P'
				elseif 'w' == code then
					retval = self:MeetsRequirementGroupControl({ groupNumber = subcode, minimum = numeric, turnedIn = true, completeInLog = true}) and 'C' or 'P'
				elseif 'x' == code then
					retval = (Grail:ArtifactKnowledgeLevel() >= numeric) and 'C' or 'P'
				elseif 'Y' == code then
					retval = self:AchievementComplete(numeric, true) and 'C' or 'G'
				elseif 'y' == code then
					retval = self:AchievementComplete(numeric, true) and 'G' or 'C'
				elseif 'Z' == code then
					retval = self:_EverCastSpell(numeric) and 'C' or 'P'
				elseif '=' == code or '<' == code or '>' == code then
					retval = self:_PhaseMatches(code, subcode, numeric) and 'C' or 'P'
				elseif 'Q' == code or 'q' == code then
					retval = self:_iLvlMatches(code, numeric) and 'C' or 'P'
				elseif 'a' == code then
					retval = self:IsAvailable(numeric) and 'C' or 'P'
				elseif '@' == code then
					retval = self:ArtifactLevelMeetsOrExceeds(subcode, numeric) and 'C' or 'P'
				elseif '#' == code then
					retval = self:IsMissionAvailable(numeric) and 'C' or 'P'
				else	-- A, B, C, D, E, H, O, X
					local questBitMask = self:StatusCode(numeric)
					local questTypeMask = self:CodeType(numeric)
					if shouldDisplayHolidays then
						if bitband(questBitMask, self.bitMaskHoliday) > 0 then
							questBitMask = questBitMask - self.bitMaskHoliday
						end
						if bitband(questBitMask, self.bitMaskAncestorHoliday) > 0 then
							questBitMask = questBitMask - self.bitMaskAncestorHoliday
						end
					end
					if code == 'H' and bitband(questBitMask, self.bitMaskEverCompleted) > 0 then		-- special case where we want the fact that the quest was ever completed to take priority
						retval = 'C'
					elseif bitband(questBitMask, self.bitMaskNonexistent + self.bitMaskError) > 0 then
						retval = 'U'
					elseif bitband(questBitMask, self.bitMaskInLog) > 0 then
						retval = 'I'
					elseif bitband(questBitMask, self.bitMaskQuestFailureWithAncestor
													+ (buggedQuestsUnobtainable and self.bitMaskBugged or 0)
													) > 0 or self:IsQuestObsolete(numeric) or self:IsQuestPending(numeric) then
						retval = 'B'
					elseif bitband(questBitMask, self.bitMaskCompleted + self.bitMaskRepeatable) == self.bitMaskCompleted then
						if 'X' == code then
							retval = 'B'
						else
							retval = 'C'
						end
					elseif bitband(questBitMask, self.bitMaskPrerequisites) > 0 then
						retval = 'P'
					elseif self:IsDaily(numeric) then	-- self.bitMaskResettable contains IsWeekly, IsMonthly and IsYearly, so we do not use because 	Blizzard shows yellow
						if bitband(questBitMask, self.bitMaskLevelTooLow) > 0 then
							retval = 'H'
						elseif self:IsWeekly(numeric) then
							retval = 'K'
						else
							retval = 'D'
						end
					elseif bitband(questBitMask, self.bitMaskRepeatable) > 0 then
						retval = 'R'
					elseif bitband(questBitMask, self.bitMaskLevelTooLow) > 0 then
						retval = 'L'
					elseif bitband(questBitMask, self.bitMaskLowLevel) > 0 then
						retval = 'W'
					elseif bitband(questTypeMask, self.bitMaskQuestLegendary) > 0 then
						retval = 'Y'
					elseif bitband(questTypeMask, self.bitMaskQuestWorldQuest) > 0 then
						retval = 'O'
					elseif self:IsWeekly(numeric) then
						retval = 'K'
					else
						retval = 'G'
					end
				end
			end
			return retval, code, subcode, numeric
		end,

		_CleanCheckNPC = function(self, code, npcId, questId)
			local allCodesGood = true
			if 0 == npcId then
				local foundAny = false
				if nil ~= self.quests[questId][code] then
					for _, n in pairs(self.quests[questId][code]) do
						local n1 = tonumber(n)
						if n1 ~= nil and n1 <= 0 then foundAny = true end
					end
				end
				if not foundAny then allCodesGood = false end
			elseif (nil == self.quests[questId][code] or (not tContains(self.quests[questId][code], npcId) and not self:_ContainsAliasNPC(self.quests[questId][code], npcId))) and (nil == self.quests[questId][code..'P'] and not self:_ContainsPrerequisiteNPC(self.quests[questId][code..'P'], npcId)) then
				allCodesGood = false
			end
			return allCodesGood
		end,

		_NPCsMatch = function(self, npcId1, npcId2)
			local retval = false
			npcId1 = tonumber(npcId1)
			npcId2 = tonumber(npcId2)
			if npcId1 == npcId2 then
				retval = true
			elseif npcId1 == 0 and npcId2 < 0 then
				retval = true
			elseif npcId2 == 0 and npcId1 < 0 then
				retval = true
			elseif Grail.npc.aliases[npcId1] and tContains(Grail.npc.aliases[npcId1], npcId2) then
				retval = true
			end
			return retval
		end,

		--	The preqTable is from AP: or TP:, and the nonPreqTable is from A: or T:
		_GoodNPC = function(self, npcId, preqTable, nonPreqTable)
			local retval = false
			npcId = tonumber(npcId)
			if nil ~= npcId then
				if nil ~= preqTable then
					for anNPCId, _ in pairs(preqTable) do
						retval = self:_NPCsMatch(anNPCId, npcId)
						if retval then break end
					end
				end
				if not retval and nil ~= nonPreqTable then
					for _, anNPCId in pairs(nonPreqTable) do
						retval = self:_NPCsMatch(anNPCId, npcId)
						if retval then break end
					end
				end
			end
			return retval
		end,

		_GoodNPCAccept = function(self, questId, npcId)
			return self:_GoodNPC(npcId, self:QuestNPCPrerequisiteAccepts(questId), self:QuestNPCAccepts(questId))
		end,

		_GoodNPCTurnin = function(self, questId, npcId)
			return self:_GoodNPC(npcId, self:QuestNPCPrerequisiteTurnins(questId), self:QuestNPCTurnins(questId))
		end,

		_CleanDatabaseLearnedQuestName = function(self)
			GrailDatabase.learned = GrailDatabase.learned or {}
			if nil ~= GrailDatabase.learned.QUEST_NAME then
				local newQuestNames = {}
				for _, questNameLine in pairs(GrailDatabase.learned.QUEST_NAME) do
					local shouldAdd = true
					local locale, release, questId, questName = strsplit('|', questNameLine)
					questId = tonumber(questId)
					if locale == self.playerLocale and nil ~= questId then
						local storedQuestName = self.quest.name[questId]
						if nil == storedQuestName or storedQuestName ~= questName then
							self.quest.name[questId] = questName
						else
							shouldAdd = false
						end
					end
					if shouldAdd then
						tinsert(newQuestNames, questNameLine)
					end
				end
				GrailDatabase.learned.QUEST_NAME = newQuestNames
			end
		end,

		--	This routine attempts to remove items from the special tables that are stored in the GrailDatabase table
		--	when they have been added to the internal database.  These special tables are populated when Grail discovers
		--	something lacking in its internal database as game play proceeds.  This routine is called upon startup.
		_CleanDatabase = function(self)

			local locale = GetLocale()

			if nil ~= GrailDatabase.learned and not self.processedLearned then

				--	If the object name is for our locale we process it.  If it is the
				--	same that we have, we remove it from the saved variables, else we
				--	update our internal database so it need not be recorded again.
				if nil ~= GrailDatabase.learned.OBJECT_NAME then
					local newObjectNames = {}
					for _, objectLine in pairs(GrailDatabase.learned.OBJECT_NAME) do
						local shouldAdd = true
						local ver, loc, objId, objName = strsplit('|', objectLine)
						if loc == locale then
							if self:ObjectName(objId) == objName then
								shouldAdd = false
							else
								self.npc.name[1000000 + tonumber(objId)] = objName
							end
						end
						if shouldAdd then
							tinsert(newObjectNames, objectLine)
						end
					end
					GrailDatabase.learned.OBJECT_NAME = newObjectNames
				end

				if nil ~= GrailDatabase.learned.NPC_LOCATION then
					local newNPCLocations = {}
					for _, npcLine in pairs(GrailDatabase.learned.NPC_LOCATION) do
						local shouldAdd = true
						local ver, loc, npcId, npcLoc, aliasId = strsplit('|', npcLine)
						if self:_LocationKnown(npcId, npcLoc, aliasId) then
							shouldAdd = false
						else
							self:_AddNPCLocation(npcId, npcLoc, aliasId)
						end
						if shouldAdd then
							tinsert(newNPCLocations, npcLine)
						end
					end
					GrailDatabase.learned.NPC_LOCATION = newNPCLocations
				end

				if nil ~= GrailDatabase.learned.QUEST then
					local newQuest = {}
					for questId, questLine in pairs(GrailDatabase.learned.QUEST) do
						local questBits = { strsplit('|', questLine) }
						-- The questBits should have the first item being the list
						-- of codes, K, A: and T:.  Any other bits will be the locale
						-- a colon and the localized name of the quest that did not
						-- match the internal database value.  Those latter bits are
						-- optional.
						local internalQuestLevel = self:QuestLevel(questId)
						local newQuestLine = ''
						local questSpacer = ''
						for i = 1, #questBits do
							if 1 == i then
								-- process codes
								local codes = { strsplit(' ', questBits[i]) }
								local formatError = false
								local newCodes = ''
								local codeSpacer = ''
								for c = 1, #codes do
									if '' ~= codes[c] then
										if 1 < strlen(codes[c]) then
											local code = strsub(codes[c], 1, 1)
											local subcode = strsub(codes[c], 2, 2)
											if 'K' == code then
												local possibleQuestLevel = tonumber(strsub(codes[c], 2, 4))
												local possibleQuestType = tonumber(strsub(codes[c], 5))
												if (nil ~= possibleQuestLevel and possibleQuestLevel ~= self:QuestLevel(questId)) or (nil ~= possibleQuestType and possibleQuestType ~= bitband(self:CodeType(questId), possibleQuestType)) then
													newCodes = newCodes .. codeSpacer .. codes[c]
													codeSpacer = ' '
													self.questCodes[questId] = self.questCodes[questId] or ''
													self.questCodes[questId] = self.questCodes[questId] .. ' ' .. codes[c]
													if nil ~= possibleQuestLevel then
														self:_SetQuestLevel(questId, possibleQuestLevel)
													end
													if nil ~= possibleQuestType then
														self:_MarkQuestType(questId, possibleQuestType)
													end
												end
											elseif 'A' == code and ':' == subcode then
												if not self:_GoodNPCAccept(questId, strsub(codes[c], 3)) then
													newCodes = newCodes .. codeSpacer .. codes[c]
													codeSpacer = ' '
													self.questCodes[questId] = self.questCodes[questId] or ''
													self.questCodes[questId] = self.questCodes[questId] .. ' ' .. codes[c]
												end
											elseif 'T' == code and ':' == subcode then
												if not self:_GoodNPCTurnin(questId, strsub(codes[c], 3)) then
													newCodes = newCodes .. codeSpacer .. codes[c]
													codeSpacer = ' '
													self.questCodes[questId] = self.questCodes[questId] or ''
													self.questCodes[questId] = self.questCodes[questId] .. ' ' .. codes[c]
												end
											elseif 'L' == code then
												if internalQuestLevel ~= tonumber(strsub(codes[c], 2)) then
													newCodes = newCodes .. codeSpacer .. codes[c]
													codeSpacer = ' '
													self.questCodes[questId] = self.questCodes[questId] or ''
													self.questCodes[questId] = self.questCodes[questId] .. ' ' .. codes[c]
													self:_SetQuestRequiredLevel(questId, tonumber(strsub(codes[c], 2)))
												end
											elseif 'P' == code and ':' == subcode then
												local codeToSeek = strsub(codes[c], 3)
												if nil == strfind(self.questPrerequisites[questId] or '', codeToSeek, 1, true) then
													newCodes = newCodes .. codeSpacer .. codes[c]
													codeSpacer = ' '
													self.questCodes[questId] = self.questCodes[questId] or ''
													self.questCodes[questId] = self.questCodes[questId] .. ' ' .. codes[c]
													if nil == self.questPrerequisites[questId] then
														self.questPrerequisites[questId] = codeToSeek
													else
														self.questPrerequisites[questId] = self.questPrerequisites[questId] .. "+" .. codeToSeek
													end
												end
											else
												formatError = true
											end
										end
									end
								end
								if formatError then
									print("Malformed code in saved variables for quest", questId, questLine)
								end
								if 0 < strlen(newCodes) then
									newQuestLine = newQuestLine .. questSpacer .. newCodes
									questSpacer = '|'
								end
							else
-- With dynamic determination of quest names we no longer need to worry about mismatches.
--								local addLocalizedName = true
--								local loc, localizedName = strsplit(':', questBits[i])
--								if loc == locale then
--									if self:QuestName(questId) == localizedName then
--										addLocalizedName = false
--									else
--										self.questNames[questId] = localizedName
--									end
--								end
--								if addLocalizedName then
--									newQuestLine = newQuestLine .. questSpacer .. questBits[i]
--									questSpacer = '|'
--								end
							end
						end
						if 0 < strlen(newQuestLine) then
							newQuest[questId] = newQuestLine
						end
						self.quests[questId] = self.quests[questId] or {}
					end
					GrailDatabase.learned.QUEST = newQuest
				end

				self.processedLearned = true

			end

			-- Remove quests from SpecialQuests that have been marked as special in our internal database.
			if nil ~= GrailDatabase["SpecialQuests"] then
				for questName, _ in pairs(GrailDatabase["SpecialQuests"]) do
					local questId = self:QuestWithName(questName)
--					if self.quests[questId] and  self.quests[questId]['SP'] then
					if self.quests[questId] and bitband(self:CodeType(questId), self.bitMaskQuestSpecial) > 0 then
						GrailDatabase["SpecialQuests"][questName] = nil
					end
				end
			end

			-- Remove quests from NewQuests that have been added to our internal database.
			-- If the name matches and all the codes are in our internal datbase we remove.
			if nil ~= GrailDatabase["NewQuests"] then
				local originalQuestIdThatBlizzardHasBrokenInBeta
				for questId, q in pairs(GrailDatabase["NewQuests"]) do
					originalQuestIdThatBlizzardHasBrokenInBeta = questId
					questId = floor(tonumber(questId))
					if self:DoesQuestExist(questId) then
						if q[self.playerLocale] == self:QuestName(questId) or q[self.playerLocale] == "No Title Stored" then
							local allCodesGood = true
							if nil ~= q[1] then
								local codeArray = { strsplit(" ", q[1]) }
								for _, code in pairs(codeArray) do
									if code ~= "" then
										if "A:" == strsub(code, 1, 2) then
											if allCodesGood then
												allCodesGood = self:_CleanCheckNPC('A', tonumber(strsub(code, 3)), questId)
											end
										elseif "T:" == strsub(code, 1, 2) then
											if allCodesGood then
												allCodesGood = self:_CleanCheckNPC('T', tonumber(strsub(code, 3)), questId)
											end
										elseif "+D" == code then
											if not self:IsDaily(questId) then
												allCodesGood = false
											end
										elseif "K0" == strsub(code, 1, 2) or "K1" == strsub(code, 1, 2) then
-- At the moment we ignore this code instead of verifying it exists in the current database.
										else
											print("|cffff0000Grail|r found NewQuests quest ID", questId, "with unknown code", code)
										end
									end
								end
							end
							if allCodesGood then GrailDatabase["NewQuests"][originalQuestIdThatBlizzardHasBrokenInBeta] = nil end
						end
					end
				end
			end

			-- Remove NPCs from NewNPCs that have been added to our internal database
			-- Basically, if the name matches and we have a location in our internal database we remove
			if nil ~= GrailDatabase["NewNPCs"] then
				local originalNPCIdThatBlizzardHasBrokenInBeta
				for npcId, n in pairs(GrailDatabase["NewNPCs"]) do
					originalNPCIdThatBlizzardHasBrokenInBeta = npcId
					npcId = floor(tonumber(npcId))
					local locations = self:_RawNPCLocations(npcId)
					if nil ~= locations then
						for _, npc in pairs(locations) do
							if nil ~= npc.name and n[self.playerLocale] == npc.name and ((nil ~= npc.x and nil ~= npc.y) or npc.near) then
								GrailDatabase["NewNPCs"][originalNPCIdThatBlizzardHasBrokenInBeta] = nil
							end
						end
					else	-- it seems we do not have the NPC or we have no information about it
						-- if the version of this entry is so old we will just nuke it
						local startPos, endPos, grailVersion, restOfString = strfind(n[2], "(%d+)/(.*)")
						if nil ~= startPos then
							grailVersion = tonumber(grailVersion)
							if nil ~= grailVersion and grailVersion < self.versionNumber - 4 then
								GrailDatabase["NewNPCs"][originalNPCIdThatBlizzardHasBrokenInBeta] = nil
							end
						end
					end
				end
				GrailDatabase.NewNPCs = nil
			end

			-- BadNPCData is processed like BadQuestData (which follows)
			if nil ~= GrailDatabase["BadNPCData"] then
				local newBadNPCData = {}
				for k, v in pairs(GrailDatabase["BadNPCData"]) do
					local startPos, endPos, grailVersion, npcId, restOfString = strfind(v, "G(%d+)|(%d+)(.*)")
					local writables = {}
					if nil ~= startPos then
						npcId = tonumber(npcId)
						if nil ~= restOfString then
							local codes = { strsplit('|', restOfString) }
							if nil ~= codes then
								local nameValue = nil	-- used in conjunction with localeValue
								local localeValue = nil	-- used in conjunction with nameValue
								for _, v in pairs(codes) do
									if nil == v or "" == v then
										-- skip it
									elseif "Locale:" == strsub(v, 1, 7) then
										localeValue = strsub(v, 8)
										if nil ~= nameValue then
											if localeValue ~= self.playerLocale or nameValue ~= self:NPCName(npcId) then
												tinsert(writables, "Name:" .. nameValue)
												tinsert(writables, "Locale:" .. localeValue)
											end
										end
									elseif "Name:" == strsub(v, 1, 5) then
										nameValue = strsub(v, 6)
										if nil ~= localeValue then
											if localeValue ~= self.playerLocale or nameValue ~= self:NPCName(npcId) then
												tinsert(writables, "Name:" .. nameValue)
												tinsert(writables, "Locale:" .. localeValue)
											end
										end
									else
										tinsert(writables, v)
									end
								end
							end
						end
					end
					if 0 < #writables then
						local whatToWrite = 'G' .. grailVersion .. '|' .. npcId
						for _, w in pairs(writables) do
							whatToWrite = whatToWrite .. '|' .. w
						end
						tinsert(newBadNPCData, whatToWrite)
					end
				end
				GrailDatabase["BadNPCData"] = newBadNPCData
				GrailDatabase.BadNPCData = nil
			end

			-- The BadQuestData will be analyzed against the current database and things that have been fixed
			-- in the current database will be removed from BadQuestData.  This is done by creating a new table
			-- and only putting things that are not fixed into it.
			if nil ~= GrailDatabase["BadQuestData"] then
				local newBadQuestData = {}
				for k, v in pairs(GrailDatabase["BadQuestData"]) do
					if "table" ~= type(v) then
						local startPos, endPos, grailVersion, questId, statusCode, restOfString = strfind(v, "G(%d+)|(%d+)|(%d+)(.*)")
						local writables = {}

						if nil ~= startPos then
							questId = tonumber(questId)
							statusCode = tonumber(statusCode)
							if nil ~= restOfString then
								local codes = { strsplit('|', restOfString) }
								if nil ~= codes then
									local titleValue = nil	-- used in conjunction with localeValue
									local localeValue = nil	-- used in conjunction with titleValue
									for _, v in pairs(codes) do
										if nil == v or "" == v then
											-- skip it
										elseif "Rep:" == strsub(v, 1, 4) and 4 < strlen(v) then
--											if nil == self.quests[questId] or nil == self.quests[questId][6] or not tContains(self.quests[questId][6], strsub(v, 5)) then
											if nil == self.questReputations[questId] or nil == strfind(self.questReputations[questId], self:_ReputationCode(strsub(v, 5))) then
												tinsert(writables, v)
											end
										elseif "UnknownRep:" == strsub(v, 1, 11) then
											local startPos2, endPos2, reputationName, changeAmount = strfind(strsub(v, 12), "(.*) (-?%d+)")
											local shouldWrite = true
											local whatToWrite = v
											if nil ~= startPos2 then
												local reputationIndex = self.reverseReputationMapping[reputationName]
												if nil ~= reputationIndex then
													if "490" == reputationIndex then	-- remove the Guild reputation indexes that beta testers may have since we do not want them
														shouldWrite = false
													else
														local repChangeString = strformat("%s%d", reputationIndex, changeAmount)
--														if nil ~= self.quests[questId][6] and tContains(self.quests[questId][6], repChangeString) then
														if nil ~= self.questReputations[questId] and nil ~= strfind(self.questReputations[questId], self:_ReputationCode(repChangeString)) then
															shouldWrite = false
														else
															whatToWrite = strformat("Rep:%s", repChangeString)
														end
													end
												end
											end
											if shouldWrite then tinsert(writables, whatToWrite) end
										elseif "C:" == strsub(v, 1, 2) then
											if not self:MeetsRequirementClass(questId, strsub(v, 3)) then tinsert(writables, v) end
										elseif "F:" == strsub(v, 1, 2) then
											if not self:MeetsRequirementFaction(questId, strsub(v, 3)) then tinsert(writables, v) end
										elseif "G:" == strsub(v, 1, 2) then
											if not self:MeetsRequirementGender(questId, strsub(v, 3)) then tinsert(writables, v) end
										elseif "L:" == strsub(v, 1, 2) then
											if not self:MeetsRequirementLevel(questId, tonumber(strsub(v, 3))) then tinsert(writables, v) end
										elseif "R:" == strsub(v, 1, 2) then
											if not self:MeetsRequirementRace(questId, strsub(v, 3)) then tinsert(writables, v) end
										elseif "Level:" == strsub(v, 1, 6) then
											local internalLevel = self:QuestLevel(questId)
											local actualLevel = tonumber(strsub(v, 7))
											if 0 ~= actualLevel and 0 ~= internalLevel and (internalLevel or 1) ~= actualLevel then
												tinsert(writables, v)
											end
										elseif "Locale:" == strsub(v, 1, 7) then
											localeValue = strsub(v, 8)
											if nil ~= titleValue then
												if localeValue ~= self.playerLocale or titleValue ~= self:QuestName(questId) then
													tinsert(writables, "Title:" .. titleValue)
													tinsert(writables, "Locale:" .. localeValue)
												end
											end
										elseif "Title:" == strsub(v, 1, 6) then
											titleValue = strsub(v, 7)
											if nil ~= localeValue then
												if localeValue ~= self.playerLocale or titleValue ~= self:QuestName(questId) then
													tinsert(writables, "Title:" .. titleValue)
													tinsert(writables, "Locale:" .. localeValue)
												end
											end
										elseif "Faction:" == strsub(v, 1, 8) then
											local factionValue = strsub(v, 9)
											if nil ~= factionValue then
												local shouldWrite = true
												local bitMaskToCheckAgainst
												if "Alliance" == factionValue then
													bitMaskToCheckAgainst = self.bitMaskFactionAlliance
												elseif "Horde" == factionValue then
													bitMaskToCheckAgainst = self.bitMaskFactionHorde
												elseif "Both" == factionValue then
													bitMaskToCheckAgainst = self.bitMaskFactionAll
												end
												if bitband(self:CodeObtainers(questId), self.bitMaskFactionAll) == bitMaskToCheckAgainst then
													shouldWrite = false
												end
												if shouldWrite then tinsert(writables, v) end
											end
										else
											tinsert(writables, v)
										end
									end
								end
							end
						else
							local shouldReinsert = true
							local startPos, endPos, grailVersion, portal, blizzardVersion, restOfString = strfind(v, "G(%d+)|(.+)|(%d+)(.*)")
							if nil ~= startPos then
								local startPosition, endPosition, questId, reputations = strfind(restOfString, "|G.(%d+)..6.=.(.*).")
								if nil ~= startPosition then
									local blizzardReps
									reputations = strgsub(reputations, "\'", "")
									if reputations == "" then
										blizzardReps = {}
									else
										blizzardReps = { strsplit(",", reputations) }
									end
									if self:_ReputationChangesMatch(questId, blizzardReps) then
										shouldReinsert = false
									end
								else
									local rewardString
									startPosition, endPosition, questId, rewardString = strfind(restOfString, "|G.(%d+)..reward.=(.*)")
									if nil ~= startPosition then
										if nil ~= self.questRewards and rewardString == self.questRewards[tonumber(questId)] then
											shouldReinsert = false
										end
									end
								end
							else
								print("Grail cannot understand format of:", v)
							end
							if shouldReinsert then
								tinsert(newBadQuestData, v)
							end
						end
						if 0 < #writables and tonumber(grailVersion) + 4 >= self.versionNumber then
							local whatToWrite = 'G' .. grailVersion .. '|' .. questId .. '|' .. statusCode
							for _, w in pairs(writables) do
								whatToWrite = whatToWrite .. '|' .. w
							end
							tinsert(newBadQuestData, whatToWrite)
						end
					end
				end
				GrailDatabase["BadQuestData"] = newBadQuestData
			end
		end,

		--	This routine adds a notification to the delayed notification system if a notification
		--	of that type does not already exist in the system.  Using this allows the code to effectively
		--	post as many of a type of notification as it wants, but when the delayed notifications are
		--	processed only one type of notification will be sent to observers.
		_CoalesceDelayedNotification = function(self, notificationName, delay)
			local needToPost = true
			if nil ~= self.delayedNotifications then
				for i = 1, #(self.delayedNotifications) do
					if notificationName == self.delayedNotifications[i]["n"] then
						needToPost = false
					end
				end
			end
			if needToPost then
				self:_PostDelayedNotification(notificationName, nil, delay)
			end
		end,

		_RemoveDelayedNotification = function(self, notificationName)
			if nil ~= self.delayedNotifications then
				local newTable = {}
				for i = 1, #(self.delayedNotifications) do
					if notificationName ~= self.delayedNotifications[i].n then
						newTable[#newTable + 1] = self.delayedNotifications[i]
					end
				end
				self.delayedNotifications = newTable
			end
		end,

		--	Populates the internal caches for all the fixed codes that are derived from quest data.
		--	@param questId The standard numeric questId representing a quest.
		_CodeAllFixed = function(self, questId)
			questId = tonumber(questId)

			if nil ~= questId then

				--	We just need to use one of the caches as the signal to compute them since they are all done together
				if nil ~= self.quests[questId] and nil == self.questBits[questId] then
					local typeValue = 0
					local holidayValue = 0
					local obtainersValue = self.bitMaskClassAll		-- we will start out assuming all classes are allowed
					local obtainersRaceValue = 0;
					local levelValue = 0

					local codeString = self.questCodes[questId] or nil
					if nil ~= codeString then
						local start, length = 1, strlen(codeString)
						local stop = length
---						local codeArray = { strsplit(" ", codeString) }
						local c
						local code
						local codeValue
						local bitValue
						local hasError
						--	X and C are mutually exclusive so only allow one type to be processed
						local foundCCode = false
						local foundXCode = false
---						for i = 1, #codeArray do
						while start < length do
							local foundSpace = strfind(codeString, " ", start, true)
							if nil == foundSpace then
								if 1 < start then
									stop = strlen(codeString)
								end
							else
								stop = foundSpace - 1
							end
							c = strsub(codeString, start, stop)
---							c = codeArray[i]
							if '' == c then
								code = '!'
							else
								code = strsub(c, 1, 1)
								codeValue = strsub(c, 2, 2)
							end
							hasError = false

							if '!' == code then
								-- Do nothing...this is an empty string...extra space in the input file

							elseif 'U' == code then
								local followerId = tonumber(strsub(c, 2))
								self.followerMapping[questId] = followerId

							elseif 'C' == code then
								bitValue = self.classToBitMapping[codeValue]
								if nil ~= bitValue and not foundXCode then
									-- The first time through we will remove the assumption that all the classes are allowed
									if not foundCCode then
										obtainersValue = obtainersValue - self.bitMaskClassAll
									end
									foundCCode = true
									obtainersValue = obtainersValue + bitValue
								else
									hasError = true
								end

							elseif 'E' == code or 'Z' == code then
								local releaseNumber = tonumber(strsub(c, 2))
								if nil ~= releaseNumber then
									if 'E' == code and self.blizzardRelease < releaseNumber then
										self.questsNotYetAvailable[questId] = releaseNumber
									end
									if 'Z' == code and self.blizzardRelease > releaseNumber then
										self.questsNoLongerAvailable[questId] = releaseNumber
									end
								else
									hasError = true
								end

							elseif 'D' == code then
								local group = tonumber(strsub(c, 2))
								if nil ~= group then
									self:_InsertSet(self.questStatusCache.G, group, questId)
									self:_InsertSet(self.questStatusCache.H, questId, group)
								else
									hasError = true
								end

							elseif 'B' == code then
								if ':' == codeValue then
									--	we call _FromList with the current value of the 'B' table because processing 'O:' codes before
									--	may have created a 'B' table, so we would want to add to it instead of overwriting it
									self.quests[questId]['B'] = self:_FromList(strsub(c, 3), nil, self.quests[questId]['B'])
								else
									hasError = true
								end

							elseif 'J' == code then
								if ':' == codeValue then
									self.quests[questId]['J'] = strsub(c, 3)
								else
									hasError = true
								end

							elseif 'X' == code then
								--	The inherent nature of an X code makes is such that only one has meaning, and C codes should not be combined
								bitValue = self.classToBitMapping[codeValue]
								if nil ~= bitValue and not founcCCode then
--									obtainersValue = bitband(obtainersValue, bitbnot(self.bitMaskClassAll))
--									obtainersValue = obtainersValue + self.bitMaskClassAll - bitValue
									foundXCode = true
									obtainersValue = obtainersValue - bitValue
								else
									hasError = true
								end

							elseif 'F' == code or 'f' == code then
								if 'A' == codeValue then
									obtainersValue = obtainersValue + self.bitMaskFactionAlliance
								elseif 'H' == codeValue then
									obtainersValue = obtainersValue + self.bitMaskFactionHorde
								else
									hasError = true
								end

							elseif 'G' == code then
								if 'M' == codeValue then
									obtainersValue = obtainersValue + self.bitMaskGenderMale
								elseif 'F' == codeValue then
									obtainersValue = obtainersValue + self.bitMaskGenderFemale
								else
									hasError = true
								end

							elseif 'Q' == code then
								if ':' == strsub(c, 3, 3) then
									local gossipIndex = tonumber(codeValue)
									local npcCodes = self:_FromQualified(strsub(c, 4))
									local npcValue, npcCode, pattern
									for _, preqTable in pairs(npcCodes) do
										npcCode, pattern = preqTable[1], preqTable[2]
										npcValue = tonumber(npcCode)
										self.gossipNPCs[npcValue] = self.gossipNPCs[npcValue] or {}
										self.gossipNPCs[npcValue][gossipIndex] = { questId, pattern }
									end
								else
									hasError = true
								end

							elseif 'R' == code then
								bitValue = self.races[codeValue][4]
								if nil ~= bitValue then
									obtainersRaceValue = obtainersRaceValue + bitValue
								else
									hasError = true
								end

							elseif 'S' == code then
								if 'P' ~= codeValue then
									--	The inherent nature of an S code makes is such that only one has meaning, and R codes should not be combined
									bitValue = self.races[codeValue][4]
									if nil ~= bitValue then
										obtainersRaceValue = bitband(obtainersRaceValue, bitbnot(self.bitMaskRaceAll))
										obtainersRaceValue = obtainersRaceValue + self.bitMaskRaceAll - bitValue
									else
										hasError = true
									end
								else
									if 0 == bitband(typeValue, self.bitMaskQuestSpecial) then typeValue = typeValue + self.bitMaskQuestSpecial end
								end

							elseif 'K' == code then
								levelValue = levelValue + (tonumber(strsub(c, 2, 4)) * self.bitMaskQuestLevelOffset)
								if strlen(c) > 4 then
									local possibleTypeValue = tonumber(strsub(c, 5))
									if possibleTypeValue then typeValue = typeValue + possibleTypeValue end
								end

							elseif 'L' == code then
								levelValue = levelValue + ((tonumber(strsub(c, 2)) or 1) * self.bitMaskQuestMinLevelOffset)

							elseif 'M' == code then
								levelValue = levelValue + ((tonumber(strsub(c, 2)) or 127) * self.bitMaskQuestMaxLevelOffset)

							elseif 'H' == code then
								bitValue = self.holidayToBitMapping[codeValue]
								if nil ~= bitValue then
									holidayValue = holidayValue + bitValue
								else
									hasError = true
								end

							elseif 'V' == code or 'W' == code then
								local reputationIndex = strsub(c, 2, 4)
								local reputationValue = tonumber(strsub(c, 5))
								if nil == self.quests[questId]['rep'] then self.quests[questId]['rep'] = {} end
								if nil == self.quests[questId]['rep'][reputationIndex] then self.quests[questId]['rep'][reputationIndex] = {} end
								self.quests[questId]['rep'][reputationIndex][('V' == code) and 'min' or 'max'] = reputationValue

							elseif 'O' == code then
								if ':' == codeValue then
									self.quests[questId]['O'] = self:_FromPattern(strsub(c, 3))
									self:_FromStructure(self.quests[questId]['O'], questId, 'B')
								elseif 'A' == codeValue and strlen(c) > 4 and 'OAC:' == strsub(c, 1, 4) then
									self.quests[questId]['OAC'] = self:_FromList(strsub(c, 5))
								elseif 'B' == codeValue and strlen(c) > 4 and 'OBC:' == strsub(c, 1, 4) then
									self.quests[questId]['OBC'] = self:_FromList(strsub(c, 5))
								elseif 'C' == codeValue and strlen(c) > 4 and 'OCC:' == strsub(c, 1, 4) then
									self.quests[questId]['OCC'] = self:_FromList(strsub(c, 5))
								elseif 'D' == codeValue and strlen(c) > 4 and 'ODC:' == strsub(c, 1, 4) then
									self.quests[questId]['ODC'] = self:_FromList(strsub(c, 5))
								elseif 'E' == codeValue and strlen(c) > 4 and 'OEC:' == strsub(c, 1, 4) then
									self.quests[questId]['OEC'] = self:_FromList(strsub(c, 5))
								elseif 'P' == codeValue and strlen(c) > 4 and 'OPC:' == strsub(c, 1, 4) then
									self.quests[questId]['OPC'] = self:_FromPattern(strsub(c, 5))
									self:_ProcessQuestsForHandlers(questId, self.quests[questId]['OPC'])
								elseif 'T' == codeValue and strlen(c) > 4 and 'OTC:' == strsub(c, 1, 4) then
									self.quests[questId]['OTC'] = self:_FromPattern(strsub(c, 5))
								else
									hasError = true
								end

							elseif 'Y' == code then
								if ':' == codeValue then
									self.quests[questId]['Y'] = tonumber(strsub(c, 3))
								else
									hasError = true
								end

							elseif 'T' == code then
								if ':' == codeValue then
									self.quests[questId]['T'] = self:_TableAppendCodes(self:_FromList(strsub(c, 3)), self.quests[questId], { 'T' })
								elseif 'A' == codeValue or 'H' == codeValue then
									if (('Horde' == self.playerFaction) and 'H' or 'A') == codeValue then
										self.quests[questId]['T'] = self:_TableAppendCodes(self:_FromList(strsub(c, 4)), self.quests[questId], { 'T' })
									end
								elseif 'P' == codeValue then
									self.quests[questId]['TP'] = self:_FromQualified(strsub(c, 4), questId)
								else
									hasError = true
								end

							elseif 'I' == code then
								if ':' == codeValue then
									self.quests[questId]['I'] = self:_FromPattern(strsub(c, 3))
									local iQuests = self.quests[questId]['I']
									if nil ~= iQuests then
										for _, iQuestId in pairs(iQuests) do
											local t = self.questStatusCache["I"][iQuestId] or {}
											if not tContains(t, questId) then tinsert(t, questId) end
											self.questStatusCache["I"][iQuestId] = t
										end
									end
									self:_ProcessQuestsForHandlers(questId, self.quests[questId]['I'])
								else
									hasError = true
								end

							elseif 'A' == code then
								if ':' == codeValue then
									self.quests[questId]['A'] = self:_TableAppendCodes(self:_FromList(strsub(c, 3)), self.quests[questId], { 'A' })
								elseif 'A' == codeValue or 'H' == codeValue then
									if (('Horde' == self.playerFaction) and 'H' or 'A') == codeValue then
										self.quests[questId]['A'] = self:_TableAppendCodes(self:_FromList(strsub(c, 4)), self.quests[questId], { 'A' })
									end
								elseif 'K' == codeValue then
									self.quests[questId]['AK'] = self:_FromList(strsub(c, 4))
								elseif 'P' == codeValue then
									self.quests[questId]['AP'] = self:_FromQualified(strsub(c, 4), questId)
								elseif 'Z' == codeValue then
									self.quests[questId]['AZ'] = self:_FromList(strsub(c, 4))
								else
									hasError = true
								end

							elseif 'P' == code then
								if ':' == codeValue then
									if self.nonPatternExperiment then
										self.questPrerequisites[questId] = strsub(c, 3)
									else
										self.questPrerequisites[questId] = self:_FromPattern(strsub(c, 3))
									end
									self:_ProcessQuestsForHandlers(questId, self.questPrerequisites[questId])
								else
									hasError = true
								end
							end

							if hasError then
								print("|cFFFF0000Grail Error|r: Quest",questId,"has unknown code:", c)
							end

							start = stop + 2
						end

						--	Since the assumption is if there is a lack of code present to limit those permitted to
						--	obtain quests, checks must be done to see whether any limitations are present, and if
						--	none, the values need to be altered to permit all of those subset.
						if 0 == bitband(obtainersValue, self.bitMaskFactionAll) then obtainersValue = obtainersValue + self.bitMaskFactionAll end
--						if 0 == bitband(obtainersValue, self.bitMaskClassAll) then obtainersValue = obtainersValue + self.bitMaskClassAll end
						if 0 == bitband(obtainersValue, self.bitMaskGenderAll) then obtainersValue = obtainersValue + self.bitMaskGenderAll end
						if 0 == bitband(obtainersRaceValue, self.bitMaskRaceAll) then obtainersRaceValue = self.bitMaskRaceAll end

						--	And the levels are assumed to have minimum and maximum values that are reasonable if none present
						if 0 == bitband(levelValue, self.bitMaskQuestMinLevel) then levelValue = levelValue + self.bitMaskQuestMinLevelOffset end
						if 0 == bitband(levelValue, self.bitMaskQuestMaxLevel) then levelValue = levelValue + self.bitMaskQuestMaxLevel end

					end

local start2Time = debugprofilestop()
					self:_SetQuestBits(questId, typeValue, obtainersRaceValue, levelValue, obtainersValue, holidayValue)
--					self.questBits[questId] = strchar(
--												bitband(bitrshift(typeValue, 24), 255),
--												bitband(bitrshift(typeValue, 16), 255),
--												bitband(bitrshift(typeValue, 8), 255),
--												bitband(typeValue, 255),
--												0, 0, 0, 0,		-- placeholder for status
--												bitband(bitrshift(levelValue, 24), 255),
--												bitband(bitrshift(levelValue, 16), 255),
--												bitband(bitrshift(levelValue, 8), 255),
--												bitband(levelValue, 255),
--												bitband(bitrshift(obtainersValue, 24), 255),
--												bitband(bitrshift(obtainersValue, 16), 255),
--												bitband(bitrshift(obtainersValue, 8), 255),
--												bitband(obtainersValue, 255),
--												bitband(bitrshift(holidayValue, 24), 255),
--												bitband(bitrshift(holidayValue, 16), 255),
--												bitband(bitrshift(holidayValue, 8), 255),
--												bitband(holidayValue, 255)
--												)
self.totalFixedTime = self.totalFixedTime + (debugprofilestop() - start2Time)

--					self.quests[questId][2] = typeValue
--					self.quests[questId][3] = holidayValue
--					self.quests[questId][4] = obtainersValue
--					self.quests[questId][13] = levelValue

				end

			end

		end,

		_MarkQuestType = function(self, questId, bitValue)
			local codeType = self:CodeType(questId)
			codeType = bitbor(codeType, bitValue)
			self:_SetQuestBits(questId, codeType)
		end,

		_SetQuestLevel = function(self, questId, level)
			local codeLevel = self:CodeLevel(questId)
			codeLevel = codeLevel - bitband(codeLevel, self.bitMaskQuestLevel)
			codeLevel = codeLevel + (level * self.bitMaskQuestLevelOffset)
			self:_SetQuestBitLevel(questId, codeLevel)
		end,

		_SetQuestRequiredLevel = function(self, questId, requiredLevel)
			local codeLevel = self:CodeLevel(questId)
			codeLevel = codeLevel - bitband(codeLevel, self.bitMaskQuestMinLevel)
			codeLevel = codeLevel + (requiredLevel * self.bitMaskQuestMinLevelOffset)
			self:_SetQuestBitLevel(questId, codeLevel)
		end,

		_SetQuestBitLevel = function(self, questId, levelValue)
			self:_SetQuestBits(questId, nil, nil, levelValue)
		end,

		_SetQuestBits = function(self, questId, typeValue, obtainersRaceValue, levelValue, obtainersValue, holidayValue)
			local currentValue = self.questBits[questId]
			typeValue = typeValue or self:_IntegerFromStringPosition(currentValue, 1)
			obtainersRaceValue = obtainersRaceValue or self:_IntegerFromStringPosition(currentValue, 2)
			levelValue = levelValue or self:_IntegerFromStringPosition(currentValue, 3)
			obtainersValue = obtainersValue or self:_IntegerFromStringPosition(currentValue, 4)
			holidayValue = holidayValue or self:_IntegerFromStringPosition(currentValue, 5)
					self.questBits[questId] = strchar(
												bitband(bitrshift(typeValue, 24), 255),
												bitband(bitrshift(typeValue, 16), 255),
												bitband(bitrshift(typeValue, 8), 255),
												bitband(typeValue, 255),
												bitband(bitrshift(obtainersRaceValue, 24), 255),
												bitband(bitrshift(obtainersRaceValue, 16), 255),
												bitband(bitrshift(obtainersRaceValue, 8), 255),
												bitband(obtainersRaceValue, 255),
												bitband(bitrshift(levelValue, 24), 255),
												bitband(bitrshift(levelValue, 16), 255),
												bitband(bitrshift(levelValue, 8), 255),
												bitband(levelValue, 255),
												bitband(bitrshift(obtainersValue, 24), 255),
												bitband(bitrshift(obtainersValue, 16), 255),
												bitband(bitrshift(obtainersValue, 8), 255),
												bitband(obtainersValue, 255),
												bitband(bitrshift(holidayValue, 24), 255),
												bitband(bitrshift(holidayValue, 16), 255),
												bitband(bitrshift(holidayValue, 8), 255),
												bitband(holidayValue, 255)
												)
		end,

		_IntegerFromStringPosition = function(self, theString, thePosition)
			if nil == theString then return 0 end
			local a, b, c, d = strbyte(strsub(theString, thePosition * 4 - 3, thePosition * 4), 1, 4)
			return a * 256 * 256 * 256 + b * 256 * 256 + c * 256 + d
		end,

--		_StatusValid = function(self, questId)
--			return 0 == bitband(strbyte(self.questBits[questId]), 0x80)
--		end,
--
--		_MarkStatusValid = function(self, questId, notValid)
--			local modifier = 0
--			if notValid and self:_StatusValid(questId) then
--				modifier = 1
--			elseif not notValid and not self:_StatusValid(questId) then
--				modifier = -1
--			end
--			if 0 ~= modifier then
--				self.questBits[questId] = self.questBits[questId]:gsub("^.", function(w) return strchar(strbyte(w) + (modifier * 0x80)) end)
--			end
--		end,

		---
		--	Returns a bit mask indicating the type of the holidays that limit who can get the quest.
		--	@return An integer that should be interpreted as a bit mask containing information about what holiday .
		CodeHoliday = function(self, questId)
			questId = tonumber(questId)
			self:_CodeAllFixed(questId)
			return nil ~= questId and self.questBits[questId] and self:_IntegerFromStringPosition(self.questBits[questId], 5) or 0
		end,

		---
		--	Returns a bit mask indicating the levels of who can get the quest.
		--	@return An integer that should be interpreted as a bit mask containing information about levels of the quest.
		CodeLevel = function(self, questId)
			questId = tonumber(questId)
			self:_CodeAllFixed(questId)
			return nil ~= questId and self.questBits[questId] and self:_IntegerFromStringPosition(self.questBits[questId], 3) or 0
		end,

		---
		--	Returns a bit mask indicating the type of the obtainers who can get the quest.
		--	@return An integer that should be interpreted as a bit mask containing information about who can get the quest.
		CodeObtainers = function(self, questId)
			questId = tonumber(questId)
			self:_CodeAllFixed(questId)
			return nil ~= questId and self.questBits[questId] and self:_IntegerFromStringPosition(self.questBits[questId], 4) or 0
		end,

		---
		--	Returns a bit mask indicating the race of the obtainers who can get the quest.
		--	@return An integer that should be interpreted as a bit mask containing information about who can get the quest.
		CodeObtainersRace = function(self, questId)
			questId = tonumber(questId)
			self:_CodeAllFixed(questId)
			return nil ~= questId and self.questBits[questId] and self:_IntegerFromStringPosition(self.questBits[questId], 2) or 0
		end,

		--	This routine breaks apart a "prerequisite" code into its component
		--	parts.  The code and subcode can both be empty strings, while the
		--	numeric would be nil if there is an error in questCode.
		CodeParts = function(self, questCode)
			local code, subcode, numeric = '', '', tonumber(questCode)
			if nil == numeric and nil ~= questCode then
				-- Cn+ (c can be a letter)
				code = strsub(questCode, 1, 1)
				numeric = tonumber(strsub(questCode, 2))

				-- CSSSn+ (sss can have letters)
				if 'T' == code or 't' == code or 'U' == code or 'u' == code then
					subcode = strsub(questCode, 2, 4)
					numeric = tonumber(strsub(questCode, 5))

				-- Csssn+ (sss must be numbers)
				elseif 'V' == code or 'W' == code or 'w' == code then
					subcode = tonumber(strsub(questCode, 2, 4))
					numeric = tonumber(strsub(questCode, 5))

				-- CS
				elseif 'F' == code or 'N' == code then
					subcode = strsub(questCode, 2, 2)
					numeric = ''

				-- Cnnnns+
				elseif 'G' == code then
					-- Note numeric and subcode are reverse from traditional codes
					numeric = tonumber(strsub(questCode, 2, 5))
					if 5 < strlen(questCode) then
						subcode = tonumber(strsub(questCode, 6))
					end

				-- Cnnnnn
				elseif 'z' == code then
					numeric = tonumber(strsub(questCode, 2, 5))

				-- Cssssn+ (ssss must be numbers)
				elseif '=' == code or '<' == code or '>' == code then
					subcode = tonumber(strsub(questCode, 2, 5))
					numeric = tonumber(strsub(questCode, 6))

				-- Cnnns+
				elseif '@' == code then
					-- Note numeric and subcode are reverse from traditional codes
					numeric = tonumber(strsub(questCode, 2, 4))
					subcode = tonumber(strsub(questCode, 5))
				end

				-- CSn+ (s can be a letter)
				if nil == numeric then
					subcode = strsub(questCode, 2, 2)
					numeric = tonumber(strsub(questCode, 3))
				end
			end
			return code, subcode, numeric
		end,

		---
		--	Internal Use.
		--	Returns a table of codes from the victim string that match the sought prefix.
		--	@param victim The string that contains codes separated by spaces.
		--	@param soughtPrefix The prefix of the desired matching codes.
		--	@return A table of the matching codes or nil if there are none.
		CodesWithPrefix = function(self, victim, soughtPrefix)
			local start = strfind(victim, soughtPrefix, 1, true)
			if not start then return end

			local finish
			local retval

			soughtPrefix = " " .. soughtPrefix
			if not (start == 1 or strbyte(victim, start - 1) == 32) then
				start = strfind(victim, soughtPrefix, 1, true) + 1
			end

			while start do
				finish = strfind(victim, " ", start, true)
				if not retval then retval = {} end
				if finish then
					retval[#retval + 1] = strsub(victim, start, finish - 1)
					start = strfind(victim, soughtPrefix, finish, true)
					if start then start = start + 1 end
				else
					retval[#retval + 1] = strsub(victim, start)
					start = nil
				end
			end

			return retval
		end,

		AssociatedQuestsForNPC = function(self, npcId)
			local retval = nil
			npcId = tonumber(npcId)
			return npcId and self.npc.questAssociations[npcId] or nil
		end,

		---
		--	Returns a bit mask indicating the type of the quest.
		--	@return An integer that should be interpreted as a bit mask containing information about the type of quest.
		CodeType = function(self, questId)
			questId = tonumber(questId)
			self:_CodeAllFixed(questId)
			return nil ~= questId and self.questBits[questId] and self:_IntegerFromStringPosition(self.questBits[questId], 1) or 0
		end,

		-- This checks to see if the npcList contains an NPC that is an alias for the soughtNPC
		_ContainsAliasNPC = function(self, npcList, soughtNPC)
			local retval = false
			if nil ~= npcList and nil ~= soughtNPC then
				for _, npcId in pairs(npcList) do
					local locations = self:_RawNPCLocations(npcId)
					if nil ~= locations then
						for _, npc in pairs(locations) do
							if npc.alias == soughtNPC then
								retval = true
							end
						end
					end
				end
			end
			return retval
		end,

		_ContainsPrerequisiteNPC = function(self, npcList, soughtNPC)
			local retval = false
			if nil ~= npcList and nil ~= soughtNPC then
				if nil ~= npcList[soughtNPC] then
					retval = true
				else
					-- Check to see whether there is an alias NPC id present
					for npcId in pairs(npcList) do
						local locations = self:_RawNPCLocations(npcId)
						if nil ~= locations then
							for _, npc in pairs(locations) do
								if npc.alias == soughtNPC then
									retval = true
								end
							end
						end
					end
				end
			end
			return retval
		end,

		_CountCompleteInDatabase = function(self, db)
			local retval = 0
			db = db or GrailDatabasePlayer["completedQuests"]
			for key, value in pairs(db) do
				for i = 0, 31 do
					if bitband(value, 2^i) > 0 then
						retval = retval + 1
					end
				end
			end
			return retval
		end,

		---
		--	Returns the localized and gender specific name of the player's class.
		--	@param englishName The Blizzard internal name of the class.  If nil, the player's class will be used.
		--	@param desiredGender The numeric value for the desired gender (2 is male and 3 is female).  If nil, the player's gender will be used.
		--	@return A string whose value is the localized name of the class using the appropriate gender where applicable.
		CreateClassNameLocalizedGenderized = function(self, englishName, desiredGender)
			local nameToUse = englishName or self.playerClass
			local genderToUse = desiredGender or self.playerGender
			return (genderToUse == 3) and LOCALIZED_CLASS_NAMES_FEMALE[nameToUse] or LOCALIZED_CLASS_NAMES_MALE[nameToUse]
		end,

		---
		--	Internal Use.
		--	Populates internal quest lists based on location of NPCs that can start
		--	the quests.  In normal mode, the API will use this indexed list instead
		--	of accessing the NPC information, thereby speeding up queries.
		CreateIndexedQuestList = function(self)
			local debugStartTime = debugprofilestop()
			self.indexedQuests = {}
			self.indexedQuestsExtra = {}
			self.loremasterQuests = {}
			self.specialQuests = {}
			self.unnamedZones = {}

			local locations
			local mapId
			local bitMask
			local questName
			local mapIdsWithNames = {}
			local mapName
self.totalFixedTime = 0
local totalLocationsTime = 0

--			for questId in pairs(self.quests) do
			for questId in pairs(self.questCodes) do

				self.quests[questId] = self.quests[questId] or {}
--	Conceptually it would be nice for those that access the self.quests[questId]['SP'] structure
--	directly to be able to get access to the data they desire without needing to change their code
--	with something like this.  However, this will not work because we need to know the questId in
--	the __index function but we do not have that informtion in the table.
--				self.quests[questId] = self.quests[questId] or setmetatable({}, {
--					__index = function(table, anIndex)
--						if 'SP' == anIndex then
--							return bitband(Grail:CodeType(questId), Grail.bitMaskQuestSpecial) > 0
--						end
--						return nil
--					end,
--					})
				self:_CodeAllFixed(questId)

local start2Time = debugprofilestop()
				--	Add the quests to the map areas based on the locations of the starting NPCs
--				locations = self:QuestLocations(questId, 'A')
				locations = self:QuestLocationsAccept(questId, nil, nil, nil, nil, nil, nil, true)
				if nil ~= locations then
					for _, npc in pairs(locations) do
						if nil ~= npc.mapArea then
							local mapId = npc.mapArea
							if npc.realArea then
								if not self.experimental then
									self:_InsertSet(self.indexedQuestsExtra, mapId, questId)
								else
									self:_MarkQuestInDatabase(questId, self.indexedQuestsExtra[mapId])
								end
							else
								if not self.experimental then
									self:_InsertSet(self.indexedQuests, mapId, questId)
								else
									self:_MarkQuestInDatabase(questId, self.indexedQuests[mapId])
								end
							end
							if nil == mapIdsWithNames[mapId] then
								mapName = self:_GetMapNameByID(mapId)
								if nil ~= mapName then
									if nil == self.zoneNameMapping[mapName] or self.zoneNameMapping[mapName] ~= mapId then self.unnamedZones[mapId] = true end
									mapIdsWithNames[mapId] = mapName
								end
							end
						else
-- *** --							if GrailDatabase.debug then print("Quest", questId, "has nil mapId for NPC", npc.name, npc.id) end
							self:_InsertSet(self.indexedQuests, self.mapAreaBaseOther, questId)
						end
					end
				end
totalLocationsTime = totalLocationsTime + (debugprofilestop() - start2Time)

				-- Add this quest if it automatically starts entering a map area
				if nil ~= self.quests[questId]['AZ'] then
--					self:AddQuestToMapArea(questId, self.quests[questId]['AZ'], self.mapAreaMapping[self.quests[questId]['AZ']])
					for _, mapAreaId in pairs(self.quests[questId]['AZ']) do
						self:AddQuestToMapArea(questId, mapAreaId, self.mapAreaMapping[mapAreaId])
					end
				end

				--	Add this quest to holiday quests
				bitMask = self:CodeHoliday(questId)
				if 0 ~= bitMask then
					for bitValue,code in pairs(self.holidayBitToCodeMapping) do
						if bitband(bitMask, bitValue) > 0 then
							self:AddQuestToMapArea(questId, tonumber(self.holidayToMapAreaMapping['H'..code]), self.holidayMapping[code])
						end
					end
				end

				--	Add this quest to class quests
				bitMask = bitband(self:CodeObtainers(questId), self.bitMaskClassAll)
				if bitMask ~= self.bitMaskClassAll then
					for bitValue,code in pairs(self.classBitToCodeMapping) do
						if bitband(bitMask, bitValue) > 0 then
							self:AddQuestToMapArea(questId, tonumber(self.classToMapAreaMapping['C'..code]), self:CreateClassNameLocalizedGenderized(self.classMapping[code]))
						end
					end
				end

				--	Add this quest to daily quests
				if bitband(self:CodeType(questId), self.bitMaskQuestDaily) > 0 then
					self:AddQuestToMapArea(questId, self.mapAreaBaseDaily, DAILY)
				end
				
				--	Add this quest to reputation quests
				if nil ~= self.questReputationRequirements[questId] then
					local reputationCodes = self.questReputationRequirements[questId]
					local reputationCount = strlen(reputationCodes) / 4
					local index, value
					for i = 1, reputationCount do
						index, value = self:ReputationDecode(strsub(reputationCodes, i * 4 - 3, i * 4))
						self:AddQuestToMapArea(questId, self.mapAreaBaseReputation + tonumber(index, 16), REPUTATION .. " - " .. self.reputationMapping[index])
					end
				end

				--	Deal with SPecial and repeatable quests to allow them to be accepted even when they do not appear in the quest log
				if bitband(self:CodeType(questId), self.bitMaskQuestRepeatable + self.bitMaskQuestSpecial) > 0 then
					questName = self:QuestName(questId, 3)
-- TODO: Need to rethink how we deal with specialQuests because name getting is going to be delayed...perhaps store by questId
if nil ~= questName then
					if nil == self.specialQuests[questName] then self.specialQuests[questName] = {} end
					-- Now we go through and get the NPCs that give this quest and add them to the name table matching this quest
					local npcs = self:_TableAppendCodes(nil, self.quests[questId], { 'A', 'AK' })
					if nil ~= npcs then
						for _, questGiverId in pairs(npcs) do
							tinsert(self.specialQuests[questName], { questGiverId, questId })
						end
					end
end
				end

			end
			mapIdsWithNames = nil
			self.timings.CreateIndexedQuestList = debugprofilestop() - debugStartTime
			if GrailDatabase.debug then print("Done creating indexed quest list with elapsed milliseconds:", self.timings.CreateIndexedQuestList) end
		end,

		---
		--	Returns the localized and gender specific name of the player's race.
		--	@param englishName The Blizzard internal name of the class.  If nil, the player's class will be used.
		--	@param desiredGender The numeric value for the desired gender (2 is male and 3 is female).  If nil, the player's gender will be used.
		--	@return A string whose value is the localized name of the race using the appropriate gender where applicable.
		CreateRaceNameLocalizedGenderized = function(self, englishName, desiredGender)
			local retval = nil
			local nameToUse = englishName or self.playerClass
			local genderToUse = desiredGender or self.playerGender
			local codeToUse = nil
			for code, raceTable in pairs(self.races) do
				local raceName = raceTable[1]
				if raceName == nameToUse then
					codeToUse = code
				end
			end
			if nil ~= codeToUse then
				retval = self.races[codeToUse][genderToUse]
			end
			return retval
		end,

		---
		--	Returns a table of questIds that are simple prerequisites for the specified quest
		--	after they have been processed using any juxtaposed values.  The assumption is of
		--	course completion (turned in) of the juxtaposed quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@return A table of questIds that are simple prerequisites for this quest, or nil if there are none.
-- TODO: Fix the code this calls.  This name changed so Wholly does not use it until we fix the next routine.
		FIX_DisplayableQuestPrerequisites = function(self, questId, forceRawData)
			local retval = self:_ProcessForFlagQuests(self:QuestPrerequisites(questId, true))	-- we process using raw data no matter what
			if retval and not forceRawData then
				retval = self:_FromPattern(retval)
			end
			return retval
		end,

		---
		--	Determines whether the internal database contains the NPC specified by npcId.
		--	@param npcId The standard numeric npcId representing an NPC.
		--	@return true if the NPC is known to the internal database, false otherwise
		DoesNPCExist = function(self, npcId)
			npcId = tonumber(npcId)
			return nil ~= npcId and nil ~= self.npc.locations[npcId] and true or false
		end,

		---
		--	Determines whether the internal database contains the quest specified by questId.
		--	@param questId The standard numeric questId representing a quest.
		--	@return true if the quest is known to the internal database, false otherwise
		DoesQuestExist = function(self, questId)
			questId = tonumber(questId)
			return nil ~= questId and nil ~= self.questCodes[questId] and true or false
		end,

		-- This is a "f" function that evaluates the codeString to see whether it is a quest that requires presence in the
		-- quest log and fails if such a quest is already complete or cannot be obtained.
		_EvaluateCodeAsNotInLogImpossible = function(codeString, p)
			local good, failures = true, {}

			if nil ~= codeString then
				local code = strsub(codeString, 1, 1)
				if 'B' == code or 'D' == code then
					local questId = tonumber(strsub(codeString, 2))
					local status = Grail:StatusCode(questId)
					if bitband(status, Grail.bitMaskQuestFailureWithAncestor + Grail.bitMaskCompleted) > 0 or Grail:IsQuestObsolete(questId) or Grail:IsQuestPending(questId) then
						good = false
					end
				end
			end

			if 0 == #failures then failures = nil end
			return good, failures
		end,

		-- This is a "f" function that evaluates the codeString to see whether it is met when considered a prerequisite.
		_EvaluateCodeAsPrerequisite = function(codeString, p, forceSpecificChecksOnly)
			local good, failures = true, {}

			if nil ~= codeString then
				local questId = p and p.q or nil
				local dangerous = p and p.d or false
				local questCompleted, questInLog, questStatus, questEverCompleted, canAcceptQuest, spellPresent, achievementComplete, itemPresent, questEverAbandoned, professionGood, questEverAccepted, hasSkill, spellEverCast, spellEverExperienced, groupDone, groupAccepted, reputationUnder, reputationExceeds, factionMatches, phaseMatches, iLvlMatches, garrisonBuildingMatches, needsMatchBoth, levelMeetsOrExceeds, groupDoneOrComplete, achievementNotComplete, levelLessThan, playerAchievementComplete, playerAchievementNotComplete, garrisonBuildingNPCMatches, classMatches, artifactKnowledgeLevelMatches, worldQuestAvailable, friendshipReputationUnder, friendshipReputationExceeds, artifactLevelMatches, missionMatches = false, false, false, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false
				local checkLog, checkEver, checkStatusComplete, shouldCheckTurnin, checkSpell, checkAchievement, checkItem, checkItemLack, checkEverAbandoned, checkNeverAbandoned, checkProfession, checkEverAccepted, checkHasSkill, checkNotCompleted, checkNotSpell, checkEverCastSpell, checkEverExperiencedSpell, checkGroupDone, checkGroupAccepted, checkReputationUnder, checkReputationExceeds, checkSkillLack, checkFaction, checkPhase, checkILvl, checkGarrisonBuilding, checkStatusNotComplete, checkLevelMeetsOrExceeds, checkGroupDoneOrComplete, checkAchievementLack, checkLevelLessThan, checkPlayerAchievement, checkPlayerAchievementLack, checkGarrisonBuildingNPC, checkNotTurnin, checkNotLog, checkClass, checkArtifactKnowledgeLevel, checkWorldQuestAvailable, checkFriendshipReputationExceeds, checkFriendshipReputationUnder, checkArtifactLevel, checkMission = false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false
				local code, value, position, subcode
				local forcingProfessionOnly, forcingReputationOnly = false, false

				if forceSpecificChecksOnly then
					if bitband(forceSpecificChecksOnly, Grail.bitMaskProfession) > 0 then
						forcingProfessionOnly = true
					end
					if bitband(forceSpecificChecksOnly, Grail.bitMaskReputation) > 0 then
						forcingReputationOnly = true
					end
				end

				code, subcode, value = Grail:CodeParts(codeString)

				if code == '' then
					if dangerous then	-- we are checking I:
						code = 'C'
					else				-- we are checking P:
						code = 'A'
					end
				end

-----				position = 1
-----				code = strsub(codeString, 1, 1)
-----				if nil == tonumber(code) then
-----					-- code is already a letter, so leave it alone
-----				position = 2
-----				elseif dangerous then	-- we are checking I:
-----					code = 'C'
-----				else					-- we are checking P:
-----					code = 'A'
-----				end

				--	We do not care about any prerequisite except profession ones when forcingProfessionOnly
				if forcingProfessionOnly and 'P' ~= code then
					code = ' '
				end
				if forcingReputationOnly and ('T' ~= code and 't' ~= code and 'U' ~= code and 'u' ~= code) then
					code = ' '
				end

--				if 'P' == code then
--					subcode = strsub(codeString, 2, 2)
--					position = 3
--				elseif 't' == code or 'T' == code or 'u' == code or 'U' == code then
--					subcode = strsub(codeString, 2, 4)
--					position = 5
--				elseif 'W' == code or 'V' == code or 'w' == code then
--					subcode = tonumber(strsub(codeString, 2, 4))
--					position = 5
--				elseif 'F' == code then
--					subcode = strsub(codeString, 2, 2)
--				elseif '=' == code or '<' == code or '>' == code then
--					subcode = tonumber(strsub(codeString, 2, 5))
--					position = 6
--				elseif 'G' == code then
--					subcode = tonumber(strsub(codeString, 2, 5))
--					position = 6
--				elseif 'z' == code then
--					subcode = tonumber(strsub(codeString, 2, 5))
--				else
--					subcode = nil
--				end
--				value = tonumber(strsub(codeString, position))

--				code, subcode, value = Grail:CodeParts(codeString)
--	TODO:	See when we can convert to use CodeParts()

				-- Now to figure out what needs to be checked based on the code
				if code == ' ' then
					-- We do nothing since we are using this to indicate 
				elseif code == 'A' then	shouldCheckTurnin = true
				elseif code == 'a' then checkWorldQuestAvailable = true
				elseif code == 'B' then checkLog = true
				elseif code == 'C' then	shouldCheckTurnin = true
										checkLog = true
				elseif code == 'c' then checkNotTurnin = true
										checkNotLog = true
				elseif code == 'D' then	checkStatusComplete = true
				elseif code == 'E' then	shouldCheckTurnin = true
										checkStatusComplete = true
				elseif code == 'e' then checkStatusNotComplete = true
										checkNotCompleted = true
				elseif code == 'F' then checkFaction = true
				elseif code == 'G' then checkGarrisonBuilding = true
				elseif code == 'H' then	checkEver = true
				elseif code == 'I' then	checkSpell = true
				elseif code == 'i' then	checkNotSpell = true
				elseif code == 'J' then	checkAchievement = true
				elseif code == 'j' then	checkAchievementLack = true
				elseif code == 'K' then	checkItem = true
				elseif code == 'k' then	checkItemLack = true
				elseif code == 'L' then checkLevelMeetsOrExceeds = true
				elseif code == 'L' then checkLevelLessThan = true
				elseif code == 'M' then	checkEverAbandoned = true
				elseif code == 'm' then	checkNeverAbandoned = true
				elseif code == 'N' then checkClass = true
				elseif code == 'O' then	checkEverAccepted = true
				elseif code == 'P' then	checkProfession = true
				elseif code == 'Q' or
					   code == 'q' then checkILvl = true
				elseif code == 'R' then checkEverExperiencedSpell = true
				elseif code == 'S' then	checkHasSkill = true
				elseif code == 's' then checkSkillLack = true
				elseif code == 'T' then checkReputationExceeds = true
				elseif code == 't' then checkReputationUnder = true
				elseif code == 'U' then checkFriendshipReputationExceeds = true
				elseif code == 'u' then checkFriendshipReputationUnder = true
				elseif code == 'V' then checkGroupAccepted = true
				elseif code == 'W' then checkGroupDone = true
				elseif code == 'w' then checkGroupDoneOrComplete = true
				elseif code == 'X' then	checkNotCompleted = true
				elseif code == 'x' then checkArtifactKnowledgeLevel = true
				elseif code == 'Y' then	checkPlayerAchievement = true
				elseif code == 'y' then	checkPlayerAchievementLack = true
				elseif code == 'Z' then checkEverCastSpell = true
				elseif code == 'z' then checkGarrisonBuildingNPC = true
				elseif code == '=' or
					   code == '<' or
					   code == '>' then checkPhase = true
				elseif code == '@' then checkArtifactLevel = true
				elseif code == '#' then checkMission = true
				else print("|cffff0000Grail|r _EvaluateCodeAsPrerequisite cannot process code", codeString)
				end

				if shouldCheckTurnin or checkNotCompleted or checkNotTurnin then questCompleted = Grail:IsQuestCompleted(value) end
				if checkLog or checkStatusComplete or checkStatusNotComplete or checkNotLog then questInLog, questStatus = Grail:IsQuestInQuestLog(value) end
				if checkEver then questEverCompleted = Grail:HasQuestEverBeenCompleted(value) end
				if (shouldCheckTurnin and questCompleted) or (checkEver and questEverCompleted) then
--	TODO:	Solve this issue:
--		We have quest 30727 that has I:H30727 that seems to be causing the quest to be marked as invalidated.  This I assume is because the previous quest
--		30726 is no longer obtainable (since it is likewise marked I:H30726 which resolves as unobtainable since 30726 has already been completed) and we
--		get the inherited prerequisite failure.
					if dangerous then
						local t = Grail.currentMortalIssues[value] or {}
						if value ~= questId and not tContains(t, questId) then tinsert(t, questId) end
						Grail.currentMortalIssues[value] = t
					else
--						canAcceptQuest = Grail:CanAcceptQuest(value, true)
						canAcceptQuest = Grail:CanAcceptQuest(value, true, true, true, true, true)
					end
				end
				if checkSpell or checkNotSpell then spellPresent = Grail:SpellPresent(value) end
				if checkAchievement then achievementComplete = Grail:AchievementComplete(value) end
				if checkAchievementLack then achievementNotComplete = not Grail:AchievementComplete(value) end
				if checkPlayerAchievement then playerAchievementComplete = Grail:AchievementComplete(value, true) end
				if checkPlayerAchievementLack then playerAchievementNotComplete = not Grail:AchievementComplete(value, true) end
				if checkItem or checkItemLack then itemPresent = Grail:ItemPresent(value) end
				if checkEverAbandoned or checkNeverAbandoned then questEverAbandoned = Grail:HasQuestEverBeenAbandoned(value) end
				if checkProfession then professionGood = Grail:ProfessionExceeds(subcode, value) end
				if checkEverAccepted then questEverAccepted = Grail:HasQuestEverBeenAccepted(value) end
				if checkHasSkill or checkSkillLack then hasSkill = Grail:_HasSkill(value) end
				if checkEverCastSpell then spellEverCast = Grail:_EverCastSpell(value) end
				if checkEverExperiencedSpell then spellEverExperienced = Grail:EverExperiencedSpell(value) end
--				if checkGroupDone then groupDone = Grail:MeetsRequirementGroup(subcode, value) end
				if checkGroupDone then groupDone = Grail:MeetsRequirementGroupControl({groupNumber = subcode, minimum = value, turnedIn = true}) end
				if checkGroupDoneOrComplete then groupDoneOrComplete = Grail:MeetsRequirementGroupControl({ groupNumber = subcode, minimum = value, turnedIn = true, completeInLog = true}) end
--				if checkGroupAccepted then groupAccepted = Grail:MeetsRequirementGroupAccepted(subcode, value) end
				if checkGroupAccepted then groupAccepted = Grail:MeetsRequirementGroupControl({groupNumber = subcode, minimum = value, accepted = true}) end
				if checkReputationUnder or checkReputationExceeds then
					local exceeds, earnedValue = Grail:_ReputationExceeds(Grail.reputationMapping[subcode], value)
					if not exceeds then reputationUnder = true end
					if exceeds then reputationExceeds = true end
				end
				if checkFriendshipReputationExceeds or checkFriendshipReputationUnder then
					local exceeds, earnedValue = Grail:_FriendshipReputationExceeds(Grail.reputationMapping[subcode], value)
					if not exceeds then friendshipReputationUnder = true end
					if exceeds then friendshipReputationExceeds = true end
				end
				if checkFaction then
					if ('A' == subcode and 'Alliance' == Grail.playerFaction) or ('H' == subcode and 'Horde' == Grail.playerFaction) then
						factionMatches = true
					end
				end
				if checkPhase then phaseMatches = Grail:_PhaseMatches(code, subcode, value) end
				if checkILvl then iLvlMatches = Grail:_iLvlMatches(code, value) end
				if checkGarrisonBuilding then
					if nil == subcode or '' == subcode then
						garrisonBuildingMatches = Grail:HasGarrisonBuilding(value)
					else
						garrisonBuildingMatches = Grail:HasGarrisonBuildingInPlot(value, subcode)
					end
				end
				if checkGarrisonBuildingNPC then
					garrisonBuildingNPCMatches = Grail:HasGarrisonBuildingNPCWorking(value)
				end
				if checkStatusNotComplete and checkNotCompleted then
					-- TODO: this is a situation where we need an AND between the two, where each individually will not succeed
					--			which means we need to know the difference between this case and those that are individual
					needsMatchBoth = true
				end
				if checkLevelMeetsOrExceeds then
					levelMeetsOrExceeds = (Grail.levelingLevel >= value)
				end
				if checkLevelLessThan then
					levelLessThan = (Grail.levelingLevel < value)
				end
				if checkClass then
					classMatches = (Grail.classNameToCodeMapping[Grail.playerClass] == subcode)
				end
				if checkArtifactKnowledgeLevel then
					artifactKnowledgeLevelMatches = (Grail:ArtifactKnowledgeLevel() >= value)
				end
				if checkWorldQuestAvailable then
					worldQuestAvailable = Grail:IsAvailable(value)
				end
				if checkArtifactLevel then
					artifactLevelMatches = Grail:ArtifactLevelMeetsOrExceeds(subcode, value)
				end
				if checkMission then
					missionMatches = Grail:IsMissionAvailable(value)
				end

				good =
					(code == ' ') or
					(shouldCheckTurnin and questCompleted and canAcceptQuest) or
					(not needsMatchBoth and checkNotCompleted and not questCompleted) or
					(checkLog and questInLog) or
					(checkEver and questEverCompleted and canAcceptQuest) or
					(checkStatusComplete and questInLog and questStatus ~= nil and questStatus > 0) or
					(not needsMatchBoth and checkStatusNotComplete and questInLog and (questStatus == nil or questStatus == 0)) or
					(needsMatchBoth and checkStatusNotComplete and questInLog and (questStatus == nil or questStatus == 0) and checkNotCompleted and not questCompleted) or
					(checkSpell and spellPresent) or
					(checkNotSpell and not spellPresent) or
					(checkAchievement and achievementComplete) or
					(checkAchievementLack and achievementNotComplete) or
					(checkPlayerAchievement and playerAchievementComplete) or
					(checkPlayerAchievementLack and playerAchievementNotComplete) or
					(checkItem and itemPresent) or
					(checkItemLack and not itemPresent) or
					(checkEverAbandoned and questEverAbandoned) or
					(checkNeverAbandoned and not questEverAbandoned) or
					(checkProfession and professionGood) or
					(checkEverAccepted and questEverAccepted) or
					(checkHasSkill and hasSkill) or
					(checkEverCastSpell and spellEverCast) or
					(checkEverExperiencedSpell and spellEverExperienced) or
					(checkGroupDone and groupDone) or
					(checkGroupAccepted and groupAccepted) or
					(checkReputationUnder and reputationUnder) or
					(checkReputationExceeds and reputationExceeds) or
					(checkFriendshipReputationUnder and friendshipReputationUnder) or
					(checkFriendshipReputationExceeds and friendshipReputationExceeds) or
					(checkSkillLack and not hasSkill) or
					(checkFaction and factionMatches) or
					(checkPhase and phaseMatches) or
					(checkILvl and iLvlMatches) or
					(checkGarrisonBuilding and garrisonBuildingMatches) or
					(checkGarrisonBuildingNPC and garrisonBuildingNPCMatches) or
					(checkLevelMeetsOrExceeds and levelMeetsOrExceeds) or
					(checkLevelLessThan and levelLessThan) or
					(checkGroupDoneOrComplete and groupDoneOrComplete) or
					(checkNotLog and checkNotTurnin and not questCompleted and not questInLog) or
					(checkClass and classMatches) or
					(checkArtifactKnowledgeLevel and artifactKnowledgeLevelMatches) or
					(checkWorldQuestAvailable and worldQuestAvailable) or
					(checkArtifactLevel and artifactLevelMatches) or
					(checkMission and missionMatches)
				if not good then tinsert(failures, codeString) end
			end

			if 0 == #failures then failures = nil end
			return good, failures
		end,

-- TODO: See why we are playing with a table for the failures here since we are just returning an integer in its first element
		_EvaluateCodeDoesNotFailQuestStatus = function(codeString, p)
			local good, failures = true, {}

			if nil ~= codeString then
				local questId = p and p.q or nil
--				local code = strsub(codeString, 1, 1)
				local code, subcode, numeric = Grail:CodeParts(codeString)
				local anyFailure = nil
				if 'V' == code then
--					if not Grail:MeetsRequirementGroupAccepted(subcode, numeric) then
					if not Grail:MeetsRequirementGroupControl({groupNumber = subcode, minimum = numeric, accepted = true}) then
						anyFailure = Grail.bitMaskInvalidated
					end
				elseif 'W' == code then
--					if not Grail:MeetsRequirementGroupPossibleToComplete(subcode, numeric) then
					if not Grail:MeetsRequirementGroupControl({ groupNumber = subcode, minimum = numeric, possible = true}) then
						anyFailure = Grail.bitMaskInvalidated
					end
				elseif 'w' == code then
					if not Grail:MeetsRequirementGroupControl({ groupNumber = subcode, minimum = numeric, turnedIn = true, completeInLog = true}) then
						anyFailure = Grail.bitMaskInvalidated
					end
				elseif 'T' == code or 't' == code then
					local exceeds, earnedValue = Grail:_ReputationExceeds(Grail.reputationMapping[subcode], numeric)
					if 'T' == code and not exceeds then
						anyFailure = Grail.bitMaskInvalidated
					elseif 't' == code and exceeds then
						anyFailure = Grail.bitMaskInvalidated
					end
				elseif 'U' == code or 'u' == code then
					local exceeds, earnedValue = Grail:_FriendshipReputationExceeds(Grail.reputationMapping[subcode], numeric)
					if 'U' == code and not exceeds then
						anyFailure = Grail.bitMaskInvalidated
					elseif 'u' == code and exceeds then
						anyFailure = Grail.bitMaskInvalidated
					end

				-- s means a lack of skill.  if the skill is present this means we fail because we assume you cannot unlearn a skill (or at least reasonably)
				elseif 's' == code then
					if Grail:_HasSkill(numeric) then
						anyFailure = Grail.bitMaskInvalidated
					end

				elseif	'F' ~= code
					and 'I' ~= code
					and 'J' ~= code
					and 'j' ~= code
					and 'Y' ~= code
					and 'y' ~= code
					and 'K' ~= code
					and 'k' ~= code
					and 'M' ~= code
					and 'm' ~= code
					and 'N' ~= code
					and 'P' ~= code
					and 'R' ~= code
					and 'S' ~= code
					and 'i' ~= code
					and 'Z' ~= code
					and '=' ~= code
					and '<' ~= code
					and '>' ~= code
					and 'L' ~= code
					and 'l' ~= code
					and 'a' ~= code
					and 'c' ~= code
					then

--					local currentQuestId = tonumber(codeString)
--					if nil == currentQuestId then currentQuestId = tonumber(strsub(codeString, 2)) end
					local currentQuestId = numeric

					local t = Grail.questStatusCache.Q[currentQuestId] or {}
					if not tContains(t, questId) then tinsert(t, questId) end
					Grail.questStatusCache.Q[currentQuestId] = t
					local subCode = Grail:StatusCode(currentQuestId)
					--	SMH 2014-02-09
					--	The behavior of failing for ancestors is changing such that we will return both the current status hard failure and the ancestor one together and let
					--	the caller determine what needs to be done with this information.
					local failureBits = bitband(subCode, Grail.bitMaskQuestFailureWithAncestor)
					if failureBits > 0 then
						anyFailure = failureBits
--					local failureBits = bitband(subCode, Grail.bitMaskQuestFailure)
--					if failureBits > 0 then
--						-- this means this specific quest has bits in it that would cause failure (need not check prerequisites for it at all since it fails by itself)
--						anyFailure = failureBits
--					elseif bitband(subCode, Grail.bitMaskPrerequisites) > 0 then
--						-- this means the quest itself does not immediately fail, but it fails because of prerequisites, so that reason needs to be checked in
--						-- case it is one of the hard reasons for failure
--						failureBits = bitband(subCode, Grail.bitMaskQuestFailureWithAncestor)
--						if failureBits > 0 then
--							-- this means the quest has a prerequisite quest that fails in one of the hard ways
--							anyFailure = failureBits / 1024
--						end
					elseif Grail:IsQuestObsolete(currentQuestId) or Grail:IsQuestPending(currentQuestId) then
						anyFailure = Grail.bitMaskInvalidated
					end
				end
				if nil ~= anyFailure then
					good = false
					tinsert(failures, anyFailure)
				end
			end

			if 0 == #failures then failures = nil end
			return good, failures
		end,

		_EverCastSpell = function(self, spellId)
			return self:_IsQuestMarkedInDatabase(spellId, GrailDatabasePlayer["spellsCast"])
		end,

		EverExperiencedSpell = function(self, spellId)
			return self:_IsQuestMarkedInDatabase(spellId, GrailDatabasePlayer["buffsExperienced"])
		end,

		FactionAvailable = function(self, reputationIndex, playerFaction)
			local retval = false
			playerFaction = playerFaction or self.playerFaction
			local permittedFaction = self.reputationMappingFaction[reputationIndex]
			if permittedFaction == 'Neutral' or permittedFaction == playerFaction then
				retval = true
			end
			return retval
		end,

		--	This takes a string of items representing an OR structure and returns a list where
		--	each element in the list is one of the OR items.
		--	@param list The string representing a list of OR items
		--	@param splitter An optional splitter string, with comma being the default
		--	@param oldTable An optional table to use to populate, otherwise a new one is created
		--	@return A table where each OR item is an entry in the table
		_FromList = function(self, list, splitter, oldTable)
			local retval = oldTable or {}
			local splitterToUse = splitter or ','
			local items = { strsplit(splitterToUse, list) }
			local itemToInsert
			for i = 1, #items do
				itemToInsert = tonumber(items[i])
				if nil == itemToInsert then itemToInsert = items[i] end
				tinsert(retval, itemToInsert)
			end
			return retval
		end,

		--		A,B,C	{ A, B, C }		(A or B or C)
		--		A+B		{ {A, B } }		(A and B)
		--		A+B,C	{ {A, B}, C }	((A and B) or C)
		--		A+B,C+D	{ {A,B}, {C,D} }((A and B) or (C and D))
		--		A+B|C+D	{ {A,{B,C},D} }	(A and (B or C) and D)		-- the | is to be used for OR within an AND block
		--		A,B+C|D		{A, {B, {C, D}}} 	-- this should evaluate the same as the one that follows
		--		A,B+C,B+D	{A, {B, C}, {B, D}}

		--	This takes a string of items representing an AND/OR structure and returns a list where
		--	each element in the list is one of the OR items, and tables within the list elements
		--	are the AND items.
		--	@param list The string representing a list of OR items
		--	@param orSplitter An optional splitter string, with comma being the default
		--	@param andSplitter An optional splitter string, with plus being the default
		--	@param oldTable An optional table to use to populate, otherwise a new one is created
		--	@return A table where each OR item is an entry in the table
		_FromPattern = function(self, pattern, orSplitter, andSplitter, oldTable)
			local retval = oldTable or {}
			local orSplitterToUse = orSplitter or ','
			local andSplitterToUse = andSplitter or '+'
			local items = { strsplit(orSplitterToUse, pattern) }
			local andItems
			local subOrItems
			for i = 1, #items do
				andItems = self:_FromList(items[i], andSplitterToUse)
				if 1 == #andItems then				-- technically since there is only one item it should never contain the | because that is only used between more than one AND item
					tinsert(retval, andItems[1])
				else
					local newAndItems = {}
					for j = 1, #andItems do
						subOrItems = self:_FromList(andItems[j], '|')
						if 1 == #subOrItems then
							tinsert(newAndItems, subOrItems[1])
						else
							tinsert(newAndItems, subOrItems)
						end
					end
					tinsert(retval, newAndItems)
				end
			end
			return retval
		end,

		--	This takes the qualifiedList which should have the pattern
		--		item:prerequisitePattern
		--	and these can be separated by a semi-colon.  The return value
		--	is a table whose keys are the item and whose values are the
		--	prerequisitePattern.
		_FromQualified = function(self, qualifiedList, questId)
			local retval = {}
			local items = { strsplit(';', qualifiedList) }
			local colon, key, value
			for i = 1, #items do
				colon = strfind(items[i], ':', 1, true)
				if colon then
					key = tonumber(strsub(items[i], 1, colon - 1))
					value = self:_FromPattern(strsub(items[i], colon + 1))
					if questId then
						self:_ProcessQuestsForHandlers(questId, value, self.npcStatusCache);
					end
				else
					key = tonumber(items[i])
					value = {}
				end
--				retval[key] = value
				tinsert(retval, { key, value })
			end
			return retval
		end,

		--	This takes the structure which represents OR/AND combinations and for
		--	each quest value contained, will associate that quest's code with the
		--	provided questId.
		_FromStructure = function(self, structure, questId, code)
			for _, value in pairs(structure) do
				if "table" == type(value) then
					self:_FromStructure(value, questId, code)
				else
					local qId = tonumber(value)
					self.quests[qId] = self.quests[qId] or {}
					self.quests[qId][code] = self.quests[qId][code] or {}
					tinsert(self.quests[qId][code], questId)
				end
			end
		end,

		GarrisonBuildingLevelString = function(self, garrisonBuildingId)
			return self.garrisonBuildingLevelMapping[garrisonBuildingId]
		end,

		--	This routine returns the current "daily" day which is the start time date for
		--	daily quests in the format YYYY-MM-DD.
		_GetDailyDay = function(self)
			local secondsUntilReset = GetQuestResetTime()
			local hour, minute = GetGameTime()	-- can return odd results if in an instance on a different machine with a different time zone that the actual server being used
			local weekday, month, day, year = CalendarGetDate()
			local seconds = hour * 3600 + minute
			if seconds + secondsUntilReset >= 86400 then
				-- do nothing since the next period starts tomorrow, which means the current period started today
			else
				-- Must move the clock back one day since today is actually on the day of the next reset
				if day > 1 then
					day = day - 1
				else
					if month > 1 then
						month = month - 1
						if 2 == month then
							day = 28
							if 0 == year % 4 then	-- we can ignore the real definition of a leap year since it will not be important for decades
								day = 29
							end
						elseif 4 == month or 6 == month or 9 == month or 11 == month then
							day = 30
						else
							day = 31
						end
					else
						month = 12
						day = 31
						year = year - 1
					end
				end
			end
			return strformat("%4d-%02d-%02d", year, month, day)
		end,

		--	This is just a front for the Blizzard routine except with our special processing for our fake zones
		_GetMapNameByID = function(self, mapId)
			return 1 == mapId and ADVENTURE_JOURNAL or GetMapNameByID(mapId)
		end,

		---
		--	Gets the NPC ID and name of an NPC indicated using the supplied parameters.  If
		--	useMouseoverOnly is true, the only NPC checked is mouseover.  If useTargetFirst
		--	is true, the list of NPCs to check uses target first.  Normally, the list of NPCs
		--	to check just contains npc and questnpc in that order.  The first NPC in the list
		--	that returns a name is used.  The NPC ID that is returned will be modified to
		--	meet the Grail requirements, which means if the NPC is really a world object the
		--	number one million will be added to Blizzard's NPC ID.
		--	@param useTargetFirst If non-nil target is first checked in the normal list
		--	@param useMouseoverOnly If non-nil only mouseover is checked
		--	@return The NPC ID (Grail modified for world objects)
		--	@return The name of the NPC
		GetNPCId = function(self, useTargetFirst, useMouseoverOnly)
			local used
			local targetName = nil
			local npcId = nil
			local searchTable = {}
			if useMouseoverOnly then
				tinsert(searchTable, "mouseover")
			else
				if useTargetFirst then tinsert(searchTable, "target") end
				tinsert(searchTable, "npc")
				tinsert(searchTable, "questnpc")
			end
			for k, v in pairs(searchTable) do
				used = v
				targetName = UnitName(used)
				if nil ~= targetName then break end
			end
			if nil ~= targetName then
				local gid = UnitGUID(used)
				if nil ~= gid then
					local targetType = nil
					--	Blizzard has changed the separator from : to - but we will try both if needed
					local npcBits = { strsplit("-", gid) }
					if #npcBits == 1 then
						npcBits = { strsplit(":", gid) }
					end
					if #npcBits == 3 and npcBits[1] == "Player" then
						npcId = Grail.GetCurrentMapAreaID() * -1
						targetName = "Player: " .. targetName
					end
					if #npcBits > 5 then
						npcId = npcBits[6]
						targetType = (npcBits[1] == "GameObject") and 1 or nil
					end
					if 1 == targetType then npcId = npcId + 1000000 end		-- our representation of a world object
				end
			end
			return npcId, targetName
		end,

		_GetOTCQuest = function(self, questId, npcId)
			questId = tonumber(questId)
			npcId = tonumber(npcId)
			local retval = questId
			if nil ~= questId and nil ~= self.quests[questId] and nil ~= self.quests[questId]['OTC'] then
				local sets = self.quests[questId]['OTC']
				for i = 1, #sets do
					if npcId == sets[i][1] then retval = sets[i][2] end
				end
			end
			return retval
		end,

		-- Code derived from elcius post in http://www.wowinterface.com/forums/showthread.php?t=56290
		GetPlayerMapPositionMapRects = {},
		GetPlayerMapPositionTempVec2D = CreateVector2D(0,0),
		GetPlayerMapPosition = function(unitName)
			local MapID = C_Map.GetBestMapForUnit(unitName)
			if not MapID or MapID < 1 then return 0, 0 end
			local R,P,_ = Grail.GetPlayerMapPositionMapRects[MapID], Grail.GetPlayerMapPositionTempVec2D
			if not R then
				R = {}
				_, R[1] = C_Map.GetWorldPosFromMapPos(MapID, CreateVector2D(0,0))
				_, R[2] = C_Map.GetWorldPosFromMapPos(MapID, CreateVector2D(1,1))
				R[2]:Subtract(R[1])
				Grail.GetPlayerMapPositionMapRects[MapID] = R
			end
			P.x, P.y = UnitPosition(unitName)
			P:Subtract(R[1])
			return (1/R[2].y)*P.y, (1/R[2].x)*P.x
--	It turns out that using this code results in a memory increase because of the table returned
--	which means we cannot really use this to update a position of the player every second.  This
--	is why the code from elcius above is used instead, as there is really no memory increase.
--			local results = C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit(unitName), unitName)
--			return results.x, results.y
		end,

		--	This is used to mask the real Blizzard API since it changes in WoD and I would prefer to have only
		--	one location where I need to mess with it.
		GetQuestLogTitle = function(self, questIndex)
			local questTitle, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questId, startEvent, displayQuestID
			local isOnMap, hasLocalPOI, isTask, isBounty, isStory, isHidden, isScaling
			local isWeekly = nil
            local frequency
			questTitle, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questId, startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isBounty, isStory, isHidden, isScaling = GetQuestLogTitle(questIndex)
			questTag = nil
			isDaily = (LE_QUEST_FREQUENCY_DAILY == frequency)
			isWeekly = (LE_QUEST_FREQUENCY_WEEKLY == frequency)
			return questTitle, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questId, startEvent, displayQuestID, isWeekly, isTask, isBounty, isStory, isHidden, isScaling
		end,

		_HandleEventAchievementEarned = function(self, achievementId)
			self:_StatusCodeInvalidate(self.questStatusCache['A'][achievementId])
			self:_NPCLocationInvalidate(self.npcStatusCache['A'][achievementId])
		end,

		_HandleEventGarrisonBuildingActivated = function(self, buildingId)
			if nil ~= self.questStatusCache then
				self:_StatusCodeInvalidate(self.questStatusCache.M[buildingId])
			end
		end,

		_HandleEventGarrisonBuildingUpdate = function(self, buildingId)
			if nil ~= self.questStatusCache then
				self:_StatusCodeInvalidate(self.questStatusCache.M[buildingId])
			end
		end,

		_HandleEventChatMsgCombatFactionChange = function(self, message)
			if nil ~= self.questStatusCache then
				self:_StatusCodeInvalidate(self.questStatusCache["R"])
				self.questStatusCache["R"] = {}
				self:_NPCLocationInvalidate(self.npcStatusCache["R"])
			end
		end,

		_HandleEventChatMsgSkill = function(self)
			if nil ~= self.questStatusCache then
				self:_StatusCodeInvalidate(self.questStatusCache["P"])
				self.questStatusCache["P"] = {}
				self:_NPCLocationInvalidate(self.npcStatusCache["P"])
			end
		end,

		_HandleEventLootClosed = function(self)
            do return end --TODO aby8
			-- Since querying the server is a little noisy we force it to be less so, reseting values later
			local silentValue, manualValue = GrailDatabase.silent, self.manuallyExecutingServerQuery
			GrailDatabase.silent, self.manuallyExecutingServerQuery = true, false
			QueryQuestsCompleted()
			local newlyCompleted = {}
			self:_ProcessServerCompare(newlyCompleted)
			if #newlyCompleted > 0 then
				local lootingNameToUse = self.lootingName or "NO LOOTING OBJECT"
				local guidParts = { strsplit('-', self.lootingGUID or "") }
				if nil ~= guidParts and guidParts[1] == "GameObject" and self.lootingName ~= self.defaultUnfoundLootingName then
					local internalName = self:ObjectName(guidParts[6])
					if self.lootingName ~= internalName then
						self:LearnObjectName(guidParts[6], lootingNameToUse)
					end
				end
				if GrailDatabase.debug then
					local message = "Looting from " .. (self.lootingGUID or "NO LOOTING GUID") .. " locale: " .. self.playerLocale .. " name: " .. lootingNameToUse
					print(message)
					self:_AddTrackingMessage(message)
				end
			end
			for _, questId in pairs(newlyCompleted) do
				self:_MarkQuestComplete(questId, true)
			end
			self:_ProcessServerBackup(true)
			GrailDatabase.silent, self.manuallyExecutingServerQuery = silentValue, manualValue
		end,

		_HandleEventPlayerLevelUp = function(self)
			if nil ~= self.questStatusCache then
				self:_StatusCodeInvalidate(self.questStatusCache["L"])
				self.questStatusCache["L"] = {}
				self:_StatusCodeInvalidate(self.questStatusCache["V"])
				self.questStatusCache["V"] = {}
			end
		end,

		_HandleEventSkillLinesChanged = function(self)
			for spellId in pairs(self.questStatusCache['S']) do
				self:_StatusCodeInvalidate(self.questStatusCache['S'][spellId])
			end
		end,

		_HandleEventUnitQuestLogChanged = function(self)
			-- Get all the quests in the Blizzard quest log and invalidate their status cache values if they have changed with regard to completed/failed
			self.cachedQuestsInLog = nil	-- First clear the cache of our quests in the log
			local questsToInvalidate = {}
			local quests = self:_QuestsInLog()
			local bitsToCheckAgainst = self.bitMaskInLog + self.bitMaskInLogComplete + self.bitMaskInLogFailed
			for questId, t in pairs(quests) do
				local cachedStatus = self.questStatuses[questId]
--				local cachedStatus = self.quests[questId] and self.quests[questId][7] or nil
--				local cachedStatus = self.questBits[questId] and self:_IntegerFromStringPosition(self.questBits[questId], 2) or nil
				if nil ~= cachedStatus then
					local soughtBitMask = self.bitMaskInLog
					local foundComplete = false
					if t[2] then
						if t[2] > 0 then soughtBitMask = soughtBitMask + self.bitMaskInLogComplete foundComplete = true end
						if t[2] < 0 then soughtBitMask = soughtBitMask + self.bitMaskInLogFailed end
					end
					if bitband(cachedStatus, bitsToCheckAgainst) ~= soughtBitMask then
						tinsert(questsToInvalidate, questId)
						if foundComplete then
							local occCodes = self.quests[questId]['OCC']
							if nil ~= occCodes then
								for i = 1, #occCodes do
									self:_MarkQuestComplete(occCodes[i], true, false, false)
									tinsert(questsToInvalidate, occCodes[i])
								end
							end
						end
					end
				end
			end
			self:_StatusCodeInvalidate(questsToInvalidate)
		end,

		---
		--	Checks whether the garrison has the specific buildingId, where a negative buildingId will mean
		--	check whether any building of that type exists.
		HasGarrisonBuilding = function(self, buildingId, ignoreIsBuildingRequirement)
			local desiredBuildingTable = nil
			local retval = false
			local buildings = (self.blizzardRelease >= 22248) and C_Garrison.GetBuildings(LE_GARRISON_TYPE_6_0) or C_Garrison.GetBuildings()
			local building
			local id, name, texPrefix, icon, rank, isBuilding, timeStart, buildTime, canActivate, canUpgrade, planExists
			local foundPlot, foundBuildingId

			--	Because the return value of C_Garrison.GetBuildingInfo() seems to change based on whether the
			--	character has been to the garrison already during the playing session, we cannot guarantee
			--	the 14th return value will be present, so we use our own mapping of negative numbers to the
			--	possible buildings.  This also allows us to specify the negative number of the level two
			--	building which means level two or three is acceptable.
			if buildingId < 0 then
				desiredBuildingTable = self.garrisonBuildingMapping[buildingId]
--				desiredBuildingTable = select(14, C_Garrison.GetBuildingInfo(-1 * buildingId))
			end
			if nil == desiredBuildingTable then
				desiredBuildingTable = { buildingId }
			end
			for i = 1, #buildings do
				building = buildings[i]
				if tContains(desiredBuildingTable, building.buildingID) then
					id, name, texPrefix, icon, rank, isBuilding, timeStart, buildTime, canActivate, canUpgrade, planExists = C_Garrison.GetOwnedBuildingInfoAbbrev(building.plotID)
					foundPlot = building.plotID
					foundBuildingId = building.buildingID
					if not isBuilding then retval = true break end
				end
			end
			return retval, name, rank, foundPlot, foundBuildingId
		end,

		HasGarrisonBuildingInPlot = function(self, buildingId, plotId)
			local retval, name, rank, foundPlot, foundBuildingId = self:HasGarrisonBuilding(buildingId)
			if retval then
				if foundPlot ~= plotId then
					retval = false
				end
			end
			return retval, name, rank, foundPlot, foundBuildingId
		end,

		HasGarrisonBuildingNPCWorking = function(self, buildingId)
			local npcName = nil
			local retval, name, rank, foundPlot, foundBuildingId = self:HasGarrisonBuilding(buildingId)
			if retval then
				npcName = C_Garrison.GetFollowerInfoForBuilding(foundPlot)
				if nil == npcName then
					retval = false
				end
			end
			return retval, npcName
		end,

		---
		--	Indicates whether the character has ever abandoned the specified quest.  This information is only valid
		--	as long as Grail has been used to record this information.  This information cannot be known prior to
		--	Grail being used.
		--	@param questId The standard numeric questId representing a quest.
		--	@return true if the quest has been marked abandoned at any time, otherwise false
		HasQuestEverBeenAbandoned = function(self, questId)
			return self:_IsQuestMarkedInDatabase(questId, GrailDatabasePlayer["abandonedQuests"])
		end,

		---
		--	Indicates whether the character has ever accepted the specified quest.  This information is only valid
		--	as long as Grail has been used to record this information.  This information cannot be known perfectly
		--	prior to Grail being used.
		--	@param questId The standard numeric questId representing a quest.
		--	@return true if the quest has been accepted at any time, otherwise false
		HasQuestEverBeenAccepted = function(self, questId)
			return self:HasQuestEverBeenAbandoned(questId) or self:HasQuestEverBeenCompleted(questId) or self:IsQuestInQuestLog(questId)
		end,

		---
		--	Indicates whether the character has ever completed the specified quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@return true if the quest has been marked complete, or if the quest has been completed and is one that Blizzard resets daily/weekly/yearly, otherwise false
		HasQuestEverBeenCompleted = function(self, questId)
			return self:IsQuestCompleted(questId) or self:IsResettableQuestCompleted(questId)
		end,

		_HasSkill = function(self, desiredSkillId)
			local retval = nil
			if nil ~= desiredSkillId then
				if desiredSkillId > 200000000 then		-- dealing with a pet that is summoned
					local numPets, numOwned = C_PetJournal.GetNumPets()
					for i = 1, numOwned do
						local _, speciesId, owned, _, _, _, _, speciesName, _, _, companionId = C_PetJournal.GetPetInfoByIndex(i)
						if owned and desiredSkillId == 200000000 + companionId then
							retval = true
						end
					end
				else
					local _, _, _, numberSpells1 = GetSpellTabInfo(1)
					local _, _, _, numberSpells2 = GetSpellTabInfo(2)
					for i = 1, numberSpells1 + numberSpells2, 1 do
						local _, spellId = GetSpellBookItemInfo(i, BOOKTYPE_SPELL)
						if spellId and desiredSkillId == spellId then
							retval = true
						end
--					local name = GetSpellBookItemName(i, BOOKTYPE_SPELL)
--					local link = GetSpellLink(name)
--					if link then
--						local spellId = tonumber(link:match("^|c%x+|H(.+)|h%[.+%]"):match("(%d+)"))
--						if spellId and desiredSkillId == spellId then
--							retval = true
--						end
--					end
					end
				end
			end
			return retval
		end,

		--	This turns a number into its hexidecimal equivalent.
		--	@param aNumber The integer to convert to hexidecimal
		--	@param minDigits An optional minimum number of hexidecimal digits to return, 0 padding at front
		--	@return A hexidecimal string representing the provided integer
		_HexValue = function(self, aNumber, minDigits)
			local codes = "0123456789ABCDEF"
			local retval = ""
			local position
			while aNumber > 0 do
				aNumber, position = floor(aNumber / 16), mod(aNumber, 16) + 1
				retval = strsub(codes, position, position) .. retval
			end
			if nil ~= minDigits then
				while (strlen(retval) < minDigits) do
					retval = '0' .. retval
				end
			end
			return retval
		end,

		--	Checks to see whether the player's current equipped iLvl matches
		_iLvlMatches = function(self, typeOfMatch, soughtNumber)
			local retval = false
			local iLvl, equippedILvl = GetAverageItemLevel()
			if 'Q' == typeOfMatch and equippedILvl >= soughtNumber then retval = true end
			if 'q' == typeOfMatch and equippedILvl < soughtNumber then retval = true end
			return retval
		end,

		_InsertSet = function(self, table, index, value)
			local t = table[index] or {}
			if not tContains(t, value) then
				t[#t + 1] = value
			end
			table[index] = t
		end,

--		InsertSet = function(self, table, value)
--			if not tContains(table, value) then
--				tinsert(table, value)
--			end
--		end,

		---
		--	Indicates whether the character is in a heroic instance with the specified NPC.
		--	@param npcId The standard numeric npcId representing an NPC.
		--	@return true if the character is in a heroic instance where the NPC is located, otherwise false
		InWithHeroicNPC = function(self, npcId)
			local retval = false
			local isHeroic, instanceName = self:IsInHeroicInstance()
			if isHeroic then
				local locations = self:NPCLocations(npcId, false, false, true)	-- only return things that match the current map area
				if nil ~= locations and 0 < #(locations) then
					retval = true
				end
			end
			return retval
		end,

		---
		--	Indicates whether the quest is an account-wide quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@return true if the quest is an account-wide quest, otherwise false
		IsAccountWide = function(self, questId)
			return (bitband(self:CodeType(questId), self.bitMaskQuestAccountWide) > 0)
		end,

		---
		--	Indicates whether the world quest is currently available.
		--	@param questId The standard numeric questId representing a quest.
		--	@return true if the world quest is currently available, otherwise false
		IsAvailable = function(self, questId)
--			return (nil ~= self.availableWorldQuests[questId])
			return tContains(self.invalidateControl[self.invalidateGroupCurrentWorldQuests], questId)
		end,

		---
		--	Indicates whether the quest is a bonus objective quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@return true if the quest is a bonus objective quest, otherwise false
		IsBonusObjective = function(self, questId)
			return (bitband(self:CodeType(questId), self.bitMaskQuestBonus) > 0)
		end,

		---
		--	Indicated whether Grail thinks the quest is bugged, meaning it cannot be completed
		--	because of a Blizzard server problem.
		--	@param questId The standard numeric questId representing a quest.
		--	@return nil if the quest is not bugged, otherwise a string describing the problem.
		IsBugged = function(self, questId)
--			return self:_QuestGenericAccess(questId, 'bugged')
			questId = tonumber(questId)
			return questId and self.buggedQuests[questId] or nil
		end,

		---
		--	Indicates whether the quest is a daily quest as indicated by the internal database.
		--	@param questId The standard numeric questId representing a quest.
		--	@return true if the quest is a daily quest, otherwise false
		IsDaily = function(self, questId)
			return (bitband(self:CodeType(questId), self.bitMaskQuestDaily) > 0)
		end,

		---
		--	Indicates whether the quest is a dungeon quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@return true if the quest is a dungeon quest, otherwise false
		IsDungeon = function(self, questId)
			return (bitband(self:CodeType(questId), self.bitMaskQuestDungeon) > 0)
		end,

		---
		--	Indicates whether the quest is an escort quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@return true if the quest is an escort quest, otherwise false
		IsEscort = function(self, questId)
			return (bitband(self:CodeType(questId), self.bitMaskQuestEscort) > 0)
		end,

		---
		--	Indicates whether the quest is a group quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@return true if the quest is a group quest, otherwise false
		IsGroup = function(self, questId)
			return (bitband(self:CodeType(questId), self.bitMaskQuestGroup) > 0)
		end,

		---
		--	Indicates whether the quest is a heroic quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@return true if the quest is a heroic quest, otherwise false
		IsHeroic = function(self, questId)
			return (bitband(self:CodeType(questId), self.bitMaskQuestHeroic) > 0)
		end,

		---
		--	Indicates whether the NPC is only to be found in heroic instances.
		--	@param npcId The standard numeric npcId representing an NPC.
		--	@return True if the NPC is only found in heroic instances, false otherwise.
		IsHeroicNPC = function(self, npcId)
			local retval = false
			npcId = tonumber(npcId)
			if nil ~= npcId then
				retval = self.npc.heroic[npcId]
			end
			return retval
		end,

		---
		--	Indicates whether the character is in a heroic instance.
		--	@return true if the character is in a heroic instance, otherwise false
		--	@return the name of the instance the character is in
		--	@usage isHeroic, instanceName = Grail:IsInHeroicInstance()
		IsInHeroicInstance = function(self)
			local retval = false
			local name, type, difficultyIndex, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, mapID, instanceGroupSize = GetInstanceInfo()
			if "none" ~= type then
				if 3 == difficultyIndex or 4 == difficultyIndex or (2 == difficultyIndex and "raid" ~= type) then
					retval = true
				end
			end
			return retval, name, mapID
		end,

		IsInInstance = function(self)
			local retval = false
			local name, type, difficultyIndex, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, mapID, instanceGroupSize = GetInstanceInfo()
			if "none" ~= type then
				retval = true
			end
			return retval, name, mapID
		end,

		---
		--	Indicates whether the quest is invalidated (meaning it cannot be accepted based on other completed quests or those in the quest log).
		--	@param questId The standard numeric questId representing a quest.
		--	@return True if the quest cannot be accepted because of a quest in the log or one already completed, false otherwise.
		--	@return A table of failure reasons, or nil if there are none.
		IsInvalidated = function(self, questId, ignoreBreadcrumb)
			local retval = false
			local any, present, failures = self:_AnyEvaluateTrue(questId, "I")
			if present then
				retval = any
			end

			if not retval and not ignoreBreadcrumb then

				-- Check to see whether this quest is a breadcrumb quest for something that is already completed or in the quest log.

				any, present, failures = self:_AnyEvaluateTrue(questId, "B")
				if present then retval = any end

			end

			if not retval then

				-- Examine the P codes to determine if any of them require the presence in the log.  If there is a code that does
				-- not, then we are ok.  If the only P codes require in the log presence check the status of those quests.  If they
				-- are unobtainable or already completed (turned in) then this quest is invalidated.

				local prerequisites = self:QuestPrerequisites(questId, true)

				if nil ~= prerequisites then
					any, present, failures = self:_AnyEvaluateTrueF(prerequisites, nil, Grail._EvaluateCodeAsNotInLogImpossible)
					if present and not any then retval = true end
				end
			end

			--	If the quest does not meet prerequisites check to see whether the quest has prerequisites that cannot be met and
			--	so the quest should be marked as invalidated because of this.
			if not retval and not self:MeetsPrerequisites(questId) then
				local prerequisites = self:QuestPrerequisites(questId, true)
				local anyEvaluateTrue, requirementPresent, allFailures = self:_AnyEvaluateTrueF(prerequisites, { q = questId }, Grail._EvaluateCodeDoesNotFailQuestStatus)
				if requirementPresent then retval = not anyEvaluateTrue end
			end

			-- Check to see if this quest is part of a group and whether that group has reached its maximum quest and whether the
			-- quest is not already part of the accepted from that group for today.
			if not retval then
				if self.questStatusCache.H[questId] then
					local dailyDay = self:_GetDailyDay()
					for _, group in pairs(self.questStatusCache.H[questId]) do
						if self:_RecordGroupValueChange(group, false, false, questId) >= self.dailyMaximums[group] then
							if not tContains(GrailDatabasePlayer["dailyGroups"][dailyDay][group], questId) then
								retval = true
							end
						end
					end
				end

			end

			return retval, failures
		end,

		---
		--	Indicates whether the quest is a legendary quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@return true if the quest is a legendary quest, otherwise false
		IsLegendary = function(self, questId)
			return (bitband(self:CodeType(questId), self.bitMaskQuestLegendary) > 0)
		end,

		---
		--	Returns whether the quest is a low level quest in comparison to the specified level
		--	or that of the player if none specified.
		--	@param questId The standard numeric questId representing a quest.
		--	@param comparisonLevel The level used to make a comparison against the quest level.
		--	@return True if the comparisonLevel (or player level) is more than the quest's level plus Blizzard's green range comparison
		IsLowLevel = function(self, questId, comparisonLevel)
			local retval = false
			comparisonLevel = tonumber(comparisonLevel) or UnitLevel("player")
			local questLevel = self:QuestLevel(questId) or 1
			if 0 ~= questLevel then		-- 0 is the special marker indicating the quest is actually the same level as the player
				retval = (comparisonLevel > (questLevel + (GetQuestGreenRange() or 8)))	-- 8 is the return value from GetQuestGreenRange() for anyone level 60 or higher (at least)
			end
			return retval
		end,

		---
		--	Indicates whether the quest is a monthly quest as indicated by the internal database.
		--	@param questId The standard numeric questId representing a quest.
		--	@return true if the quest is a monthly quest, otherwise false
		IsMonthly = function(self, questId)
			return (bitband(self:CodeType(questId), self.bitMaskQuestMonthly) > 0)
		end,

		---
		--	Returns whether the NPC should be available to the character.
		--	@param npcId The standard numeric npcId representing an NPC.
		--	@return True if the NPC is available based on holidays currently celebrated and presence in a heroic instance, false otherwise.
		IsNPCAvailable = function(self, npcId)
			local retval = false
			npcId = tonumber(npcId)
			if nil ~= npcId then
				retval = true
				local codes = self.npc.holiday
				if nil ~= codes then
					retval = false	-- Assume we fail all holidays unless proven otherwise
					for i = 1, strlen(codes) do
						if not retval then
							retval = self:CelebratingHoliday(self.holidayMapping[strsub(codes, i, i)])
						end
					end
				end
				if retval and self:IsHeroicNPC(npcId) then
					retval = self:InWithHeroicNPC(npcId)
				end
			end
			return retval
		end,

		---
		--	Indicates whether the quest is a pet battle quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@return true if the quest is a pet battle quest, otherwise false
		IsPetBattle = function(self, questId)
			return (bitband(self:CodeType(questId), self.bitMaskQuestPetBattle) > 0)
		end,

		---
		--	Returns whether Grail is ready to properly respond to status information about quests.
		IsPrimed = function(self)
			return self.receivedCalendarUpdateEventList and self.receivedQuestLogUpdate
		end,

		---
		--	Indicates whether the quest is a PVP quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@return true if the quest is a PVP quest, otherwise false
		IsPVP = function(self, questId)
			return (bitband(self:CodeType(questId), self.bitMaskQuestPVP) > 0)
		end,

		---
		--	Returns whether the quest is considered completed.
		--	Note that certain types of quests can be reset (e.g., dailies) and when they are, this routine will return false.  These types of
		--	quests can be completed and this routine will return true until they are once again reset.
		--	@param questId The standard numeric questId representing a quest.
		--	@return True if the quest is completed, false otherwise.
		--	@see HasQuestEverBeenCompleted
		--	@see IsResettableQuestCompleted
		IsQuestCompleted = function(self, questId)
			return self:_IsQuestMarkedInDatabase(questId)
		end,

		---
		--	Returns whether the quest is in the quest log.
		--	@param questId The standard numeric questId representing a quest.
		--	@return True if the quest is in the quest log, false otherwise.
		--	@return True if the quest is marked as complete in the quest log, false otherwise.
		--	@use inLog, isComplete = Grail:IsQuestInQuestLog(11)
		IsQuestInQuestLog = function(self, questId)
			local retval, retvalComplete = false, nil
			local quests = self:_QuestsInLog()
			questId = tonumber(questId)
			if nil ~= questId and nil ~= quests[questId] then
				retval, retvalComplete = true, quests[questId][2]
			end
			return retval, retvalComplete
		end,

		_IsQuestMarkedInDatabase = function(self, questId, db)
			questId = tonumber(questId)
			if nil == questId then return false end
			db = db or GrailDatabasePlayer["completedQuests"]
			local retval = false
			local index = floor((questId - 1) / 32)
			local offset = questId - (index * 32) - 1
			if nil ~= db[index] then
				if bitband(db[index], 2^offset) > 0 then
					retval = true
				end
			end
			return retval
		end,

		---
		--	Indicates whether the quest has been marked obsolete and thus not available.
		IsQuestObsolete = function(self, questId)
			return questId and self.questsNoLongerAvailable[questId] or nil
		end,

		---
		--	Indicates whether the quest is not yet available in the current version of the game.
		IsQuestPending = function(self, questId)
			return questId and self.questsNotYetAvailable[questId] or nil
		end,

		---
		--	Indicates whether the quest is a raid quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@return true if the quest is a raid quest, otherwise false
		IsRaid = function(self, questId)
			return (bitband(self:CodeType(questId), self.bitMaskQuestRaid) > 0)
		end,

		---
		--	Indicates whether the quest is a rare mob quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@return true if the quest is a rare mob quest, otherwise false
		IsRareMob = function(self, questId)
			return (bitband(self:CodeType(questId), self.bitMaskQuestRareMob) > 0)
		end,

		---
		--	Returns whether the quest is a repeatable quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@return True if the quest is a repeatable quest, false otherwise.
		IsRepeatable = function(self, questId)
			return (bitband(self:CodeType(questId), self.bitMaskQuestRepeatable) > 0)
		end,

		---
		--	Returns whether the quest is a resettable quest and has been completed in the past.
		--	This routine can return true and IsQuestCompleted() can return false as the quest can be reset.
		--	@param questId The standard numeric questId representing a quest.
		--	@return True if the quest is resettable and has ever been completed, false otherwise.
		--	@see HasQuestEverBeenCompleted
		--	@see IsQuestCompleted
		IsResettableQuestCompleted = function(self, questId)
			return self:_IsQuestMarkedInDatabase(questId, GrailDatabasePlayer["completedResettableQuests"])
		end,

		---
		--	Indicates whether the quest is a scenario quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@return true if the quest is a scenario quest, otherwise false
		IsScenario = function(self, questId)
			return (bitband(self:CodeType(questId), self.bitMaskQuestScenario) > 0)
		end,

		---
		--	Returns whether this is a special type of NPC that has information useful for tooltips and a table of that information
		--	where each item in the table is a table with the type of NPC and the associated NPC/quest/item ID.
		--	@param npcId The standard numeric npcId representing an NPC.
		--	@return True if there is any table data being returned, false otherwise
		--	@return Table data containing tables of NPC type and associated ID.
		IsTooltipNPC = function(self, npcId)
			local retval = {}
			npcId = tonumber(npcId)
			if nil ~= npcId then
				local droppedBy = self.npc.droppedBy[npcId]
				if nil ~= droppedBy then
					for _, anotherNPCId in pairs(droppedBy) do
						tinsert(retval, { self.NPC_TYPE_BY, anotherNPCId } )
					end
				end
				local killQuests = self.npc.kill[npcId]
				if nil ~= killQuests then
					for _, questId in pairs(killQuests) do
						tinsert(retval, { self.NPC_TYPE_KILL, questId } )
					end
				end
				local has = self.npc.has[npcid]
				if nil ~= has then
					for _, anotherNPCId in pairs(has) do
						tinsert(retval, { self.NPC_TYPE_DROP, anotherNPCId } )
					end
				end
			end
			return (0 < #(retval)), retval
		end,

		---
		--	Indicates whether the quest is a treasure quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@return true if the quest is a treasure quest, otherwise false
		IsTreasure = function(self, questId)
			return (bitband(self:CodeType(questId), self.bitMaskQuestTreasure) > 0)
		end,

		---
		--	Returns whether the quest is a weekly quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@return True if the quest is a weekly quest, false otherwise.
		IsWeekly = function(self, questId)
			return (bitband(self:CodeType(questId), self.bitMaskQuestWeekly) > 0)
		end,

		---
		--	Returns whether the quest is a biweekly quest (meaning once every two weeks).
		--	@param questId The standard numeric questId representing a quest.
		--	@return True if the quest is a biweekly quest, false otherwise.
		IsBiweekly = function(self, questId)
			return (bitband(self:CodeType(questId), self.bitMaskQuestBiweekly) > 0)
		end,

		---
		--	Returns whether the quest is a world quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@return True if the quest is a weekly quest, false otherwise.
		IsWorldQuest = function(self, questId)
			return (bitband(self:CodeType(questId), self.bitMaskQuestWorldQuest) > 0)
		end,

		---
		--	Returns whether the quest is a yearly quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@return True if the quest is a yearly quest, false otherwise.
		IsYearly = function(self, questId)
			return (bitband(self:CodeType(questId), self.bitMaskQuestYearly) > 0)
		end,

		---
		--	Returns whether the specifid item is present in the player's bags.
		--	Normally the itemId passed in is a Grail representation of a Blizzard
		--	item ID, but this routine should be able to handle a pure Blizzard ID
		--	as well.
		--	@param itemId Either the Grail representation of an item or a Blizzard one.
		--	@return True if an item with the same ID is in the player's bags, or false otherwise.
		ItemPresent = function(self, itemId)
			local retval = false
			itemId = tonumber(itemId)
			if nil == itemId then return false end

			--	The itemId is really our NPC representation of the item so its value
			--	needs to be adjusted back to Blizzard values.
			if itemId > 100000000 then
				itemId = itemId - 100000000
			end

			if nil == self.cachedBagItems then
				self.cachedBagItems = {}
				local c = self.cachedBagItems
				--	Now check the bags for an item with this ID
				local id, count = nil, 0
				for bag = 0, 4 do
					local numSlots = GetContainerNumSlots(bag)
					for slot = 1, numSlots do
						id = GetContainerItemID(bag, slot)
--						if nil ~= id and itemId == id then
--							retval = true
--						end
						if nil ~= id then
							count = count + 1
							c[count] = id		-- should be faster than tinsert
						end
					end
				end
			end

			retval = tContains(self.cachedBagItems, itemId)
			return retval
		end,

		_AddNPCLocation = function(self, npcId, npcLocation, aliasNPCId)
			npcId = tonumber(npcId)
			self.npc.locations[npcId] = self.npc.locations[npcId] or {}
			tinsert(self.npc.locations[npcId], Grail:_LocationStructure(npcLocation))
			aliasNPCId = tonumber(aliasNPCId)
			if nil ~= aliasNPCId then
				self.npc.aliases[aliasNPCId] = self.npc.aliases[aliasNPCId] or {}
				tinsert(self.npc.aliases[aliasNPCId], npcId)
			end
		end,

		LearnNPCLocation = function(self, npcId, npcLocation, aliasNPCId)
			GrailDatabase.learned = GrailDatabase.learned or {}
			GrailDatabase.learned.NPC_LOCATION = GrailDatabase.learned.NPC_LOCATION or {}
			local aliasString = aliasNPCId and ('|' .. aliasNPCId) or ''
			tinsert(GrailDatabase.learned.NPC_LOCATION, self.blizzardRelease .. '|' .. self.playerLocale .. '|' .. npcId .. '|' .. npcLocation .. aliasString)
			self:_AddNPCLocation(npcId, npcLocation, aliasNPCId)
		end,

		LearnObjectName = function(self, objectId, objectName)
			GrailDatabase.learned = GrailDatabase.learned or {}
			GrailDatabase.learned.OBJECT_NAME = GrailDatabase.learned.OBJECT_NAME or {}
			tinsert(GrailDatabase.learned.OBJECT_NAME, self.blizzardRelease .. '|' .. self.playerLocale .. '|' .. objectId .. '|' .. objectName)
			self.npc.name[1000000 + tonumber(objectId)] = objectName
		end,

		---
		--	Attempts to load the addon with the name addonName.  If reportFailureInBlizzardUI
		--	is true, a failure will display a message in the Blizzard UI.  Otherwise, a failure
		--	will display in the chat window.
		--	@param addonName The name of the addon to be loaded.
		--	@param reportFailureInBlizzardUI Indicates whether errors are dislpayed in the Blizzard UI or the chat window.
		--	@return True if the addon is loaded, or false otherwise.
		LoadAddOn = function(self, addonName, reportFailureInBlizzardUI)
			local success, failureReason
			if reportFailureInBlizzardUI then
				success = UIParentLoadAddOn(addonName)
			else
				success, failureReason = LoadAddOn(addonName)
				if not success then
					print(format("|cFFFF0000Grail|r "..ADDON_LOAD_FAILED, addonName, _G["ADDON_"..failureReason]))
				end
			end
			return success
		end,

		--	Check the internal npc.locations structure for a location close to
		--	the one derived from the locationString provided.
		_LocationKnown = function(self, npcId, locationString, possibleAliasId)
			local retval = false
			npcId = tonumber(npcId)
			local t = self.npc.locations[npcId]
			if npcId >= 3000000 and npcId < 4000000 and nil ~= possibleAliasId then
				possibleAliasId = tonumber(possibleAliasId)
				local possibleAliases = self.npc.aliases[possibleAliasId]
				if nil ~= possibleAliases then
					for _, aliasId in pairs(possibleAliases) do
						if self:_LocationKnown(aliasId, locationString) then
							retval = true
						end
					end
				end
			end
			if nil ~= t then
				local locations = { strsplit(' ', locationString) }
				for _, loc in pairs(locations) do
					local locationStructure = self:_LocationStructure(loc)
					for _, t1 in pairs(t) do
						if self:_LocationsCloseStructures(t1, locationStructure) then
							retval = true
						end
					end
				end
			end
			return retval
		end,

		_LocationStructure = function(self, locationString)
			locationString = strsplit(' ', locationString)	-- we are taking the first one only for the time being
			local mapId, rest = strsplit(':', locationString)
			local mapLevel = 0
			local mapLevelString
			mapId, mapLevelString = strsplit('[', mapId)
			local t1 = { ["mapArea"] = tonumber(mapId) }
			if nil ~= mapLevelString then
				mapLevel = tonumber(strsub(mapLevelString, 1, strlen(mapLevelString) - 1))
			end
			t1.mapLevel = mapLevel
			local coord, realArea = nil, nil
			if nil ~= rest then
				coord, realArea = strsplit('>', rest)
				local coordinates = { strsplit(',', coord) }
				t1.x = tonumber(coordinates[1])
				t1.y = tonumber(coordinates[2])
				if nil ~= realArea then
					t1.realArea = tonumber(realArea)
				end
			end
			return t1
		end,

		_LocationsClose = function(self, locationString1, locationString2)
			local l1 = self:_LocationStructure(locationString1)
			local l2 = self:_LocationStructure(locationString2)
			return self:_LocationsCloseStructures(l1, l2)
		end,

		_LocationsCloseStructures = function(self, locationStructure1, locationStructure2)
			local retval = false
			local l1 = locationStructure1 or {}
			local l2 = locationStructure2 or {}
			if (l1.near or l2.near) and l1.mapArea == l2.mapArea then
				retval = true
			elseif l1.mapArea == l2.mapArea and l1.mapLevel == l2.mapLevel then
				if l1.x and l2.x and l1.y and l2.y then
					if sqrt((l1.x - l2.x)^2 + (l1.y - l2.y)^2) < self.locationCloseness then
						retval = true
					end
				end
			end
			return retval
		end,

		_LogNameIssue = function(self, npcOrQuest, id, properTitle)
			if GrailDatabase[npcOrQuest] == nil then GrailDatabase[npcOrQuest] = {} end
			if GrailDatabase[npcOrQuest][self.playerLocale] == nil then GrailDatabase[npcOrQuest][self.playerLocale] = {} end
			GrailDatabase[npcOrQuest][self.playerLocale][id] = properTitle
		end,

		---
		--	This returns the map area to which the specified quest belongs for Loremaster purposes.  If the quest does not
		--	belong to any Loremaster, or the achievements addon is not loaded nil is returned.
		--	@param questId The standard numeric questId representing a quest.
		--	@return The map area for Loremaster or nil if not a Loremaster quest.
		LoremasterMapArea = function(self, questId)
			local retval = nil
			questId = tonumber(questId)
			if nil ~= questId and nil ~= self.questsLoremaster then
				retval = self.questsLoremaster[questId]
			end
--			if nil ~= questId and nil ~= self.quests[questId] and nil ~= self.quests[questId][5] then
--				for _, achievementId in pairs(self.quests[questId][5]) do
--					if achievementId < self.mapAreaBaseAchievement then
--						retval = achievementId
--					end
--				end
--			end
			return retval
		end,

		-- Takes a versionString with syntax like a.b.c and converts
		-- this to a number of a million, b thousand, c
		_MakeNumberFromVersion = function(self, versionString)
			local retval = 0
			local millions, thousands, ones = string.match(versionString, "(%d+).(%d+).(%d+)")
			retval = tonumber(millions) * 1000000 + tonumber(thousands) * 1000 + tonumber(ones)
			return retval
		end,

		MapAreaName = function(self, mapAreaId)
			return self.mapAreaMapping[mapAreaId]
		end,

		--	This marks the specified quest as complete in the internal database.  Optionally it will attempt to update the NewNPCs and NewQuests.
		--	@param questId The standard numeric questId representing a quest.
		--	@param updateDatabase If true the NewNPCs and NewQuests will be updated as well as posting the Complete notification.
		_MarkQuestComplete = function(self, questId, updateDatabase, updateActual, updateControl)
			local v = tonumber(questId)
			local index = floor((v - 1) / 32)
			local offset = v - (index * 32) - 1
			local db = GrailDatabasePlayer["completedQuests"]
			local db2 = GrailDatabasePlayer["actuallyCompletedQuests"]
			local db3 = GrailDatabasePlayer["controlCompletedQuests"]

			if not self:IsRepeatable(questId) then
				if (nil == db[index]) then
					db[index] = 0
				end
				if bitband(db[index], 2^offset) == 0 then
					db[index] = db[index] + (2^offset)
				else
					if GrailDatabase.debug then print(strformat("Quest %d is already marked completed", v)) end
				end
			end

			if updateControl then
				if nil == db3[index] then db3[index] = 0 end
				if bitband(db3[index], 2^offset) == 0 then
					db3[index] = db3[index] + (2^offset)
				else
					if GrailDatabase.debug then print(strformat("Quest %d is already marked control completed", v)) end
				end
			end

			if updateActual then
				if nil == db2[index] then db2[index] = 0 end
				if bitband(db2[index], 2^offset) == 0 then
					db2[index] = db2[index] + (2^offset)
				else
					if GrailDatabase.debug then print(strformat("Quest %d is already marked actually completed", v)) end
				end
				-- Make sure any I: quests are marked as incomplete
				local iQuests = self:QuestInvalidates(v)
				if nil ~= iQuests then
					for _, qId in pairs(iQuests) do
						self:_MarkQuestNotComplete(qId, db2)
					end
				end
			end

			if updateDatabase then
				local status = self:StatusCode(questId)
				if not self:IsResettableQuestCompleted(questId) and bitband(status, self.bitMaskRepeatable + self.bitMaskResettable) > 0 then
					local rdb = GrailDatabasePlayer["completedResettableQuests"]
					if (nil == rdb[index]) then
						rdb[index] = 0
					end
					rdb[index] = rdb[index] + (2^offset)
				end

				-- Get the target information to ensure the target exists in the database of NPCs
				local version = self.versionNumber.."/"..self.questsVersionNumber.."/"..self.npcsVersionNumber.."/"..self.zonesVersionNumber
				local targetName, npcId, coordinates = self:TargetInformation()
				npcId = self:_UpdateTargetDatabase(targetName, npcId, coordinates, version)
				if GrailDatabase.debug then
					if nil ~= targetName then
						npcId = npcId or -1
						coordinates = coordinates or "no coords"
						print("Grail Debug: Marked questId "..questId.." complete, turned in to: "..targetName.."("..npcId..") "..coordinates)
					else
						print("Grail Debug: Turned in quest "..questId.." with no target")
					end
				end
				self:_UpdateQuestDatabase(questId, 'No Title Stored', npcId, false, 'T', version)
				self:_RemoveWorldQuest(questId)
				self:_PostNotification("Complete", questId)
			end

		end,

		--	This marks the specified quest as complete in the specified database.
		--	@param questId The standard numeric questId representing a quest.
		--	@param db The database to use for marking the quest complete.  If none provided, the completed quests database is used.
		--	@param notComplete If true, the quest is marked not complete, otherwise the quest is marked complete.
		--	@return	True if the database is updated, otherwise false is returned if the quest is already marked the desired value.
		_MarkQuestInDatabase = function(self, questId, db, notComplete)
			local v = tonumber(questId)
			if nil == v then return false end
			db = db or GrailDatabasePlayer["completedQuests"]
			local retval = true
			local index = floor((v - 1) / 32)
			local offset = v - (index * 32) - 1
			if nil == db[index] then
				db[index] = 0
			end
			if notComplete then
				if bitband(db[index], 2^offset) > 0 then
					db[index] = db[index] - (2^offset)
				else
					retval = false
				end
			else
				if bitband(db[index], 2^offset) == 0 then
					db[index] = db[index] + (2^offset)
				else
					retval = false
				end
			end
			return retval
		end,

		_MarkQuestNotComplete = function(self, questId, db)
			self:_MarkQuestInDatabase(questId, db, true)
		end,

		---
		--	Returns whether the character meets prerequisites for the specified quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@return True if the character meets the prerequisites for the specified quest or false otherwise.
		--	@return A table of failures if any, nil otherwise.
		MeetsPrerequisites = function(self, questId, code, forceSpecificChecksOnly)
			local retval = true
			code = code or 'P'
			local any, present, failures = self:_AnyEvaluateTrue(questId, code, forceSpecificChecksOnly)
			if present then
				retval = any
			end
			return retval, failures
		end,

		_MeetsRequirement = function(self, questId, requirementCode, soughtParameter)
			if nil == questId or not tonumber(questId) then return false end
			local retval = true
			questId = tonumber(questId)
			self:_CodeAllFixed(questId)
			local bitMaskToUse
			local obtainers = self:CodeObtainers(questId)

			if 'G' == requirementCode then
				if nil == soughtParameter then
					bitMaskToUse = self.playerGenderBitMask
				elseif 3 == tonumber(soughtParameter) then
					bitMaskToUse = self.bitMaskGenderFemale
				else
					bitMaskToUse = self.bitMaskGenderMale
				end
--				retval = (bitband(self.quests[questId][4], bitMaskToUse) > 0)
				retval = (bitband(obtainers, bitMaskToUse) > 0)

			elseif 'F' == requirementCode or 'f' == requirementCode then
				if nil == soughtParameter then
					bitMaskToUse = self.playerFactionBitMask
				elseif 'Horde' == soughtParameter then
					bitMaskToUse = self.bitMaskFactionHorde
				else
					bitMaskToUse = self.bitMaskFactionAlliance
				end
--				retval = (bitband(self.quests[questId][4], bitMaskToUse) > 0)
				retval = (bitband(obtainers, bitMaskToUse) > 0)

			elseif 'C' == requirementCode or 'X' == requirementCode then
				bitMaskToUse = (nil == soughtParameter) and self.playerClassBitMask or self.classNameToBitMapping[soughtParameter]
--				retval = (bitband(self.quests[questId][4], bitMaskToUse) > 0)
				retval = (bitband(obtainers, bitMaskToUse) > 0)

			elseif 'H' == requirementCode then
				local comparisonValue = self:CodeHoliday(questId)
				if 0 ~= comparisonValue then
					local found = false
					for bitMask,code in pairs(self.holidayBitToCodeMapping) do
						if bitband(comparisonValue, bitMask) > 0 then		-- this bitValue is one that is required by the quest
							if self:CelebratingHoliday(self.holidayMapping[code]) then
								found = true
							end
						end
					end
					retval = found
				end
			elseif 'R' == requirementCode or 'S' == requirementCode then
				bitMaskToUse = (nil == soughtParameter) and self.playerRaceBitMask or self.raceNameToBitMapping[soughtParameter]
				if nil == bitMaskToUse then
					print("Grail problem: Quest "..questId.." cannot use race ".. soughtParameter)
					self:_AddTrackingMessage("Grail problem: Quest "..questId.." cannot use race ".. soughtParameter)
					bitMaskToUse = 0
				end
--				retval = (bitband(self.quests[questId][4], bitMaskToUse) > 0)
				retval = (bitband(self:CodeObtainersRace(questId), bitMaskToUse) > 0)

-- TODO: Should convert these over to the new way of doing things
--			elseif 'V' == requirementCode or 'W' == requirementCode or 'P' == requirementCode then
			elseif 'P' == requirementCode then
--				local codeArray = { strsplit(" ", self.quests[questId][1]) }
				local codeArray = { strsplit(" ", self.questCodes[questId]) }
				local controlCode
				local controlValue
				for i = 1, #codeArray do
					controlCode = strsub(codeArray[i], 1, 1)
					controlValue = strsub(codeArray[i], 2, 2)
					if controlCode == requirementCode then
--						if 'V' == requirementCode or 'W' == requirementCode then
--							local repIndex = strsub(codeArray[i], 2, 4)
--							local repValue = tonumber(strsub(codeArray[i], 5))
--							local exceeds, earnedValue = self:_ReputationExceeds(self.reputationMapping[repIndex], repValue)
--							local success = exceeds
--							if ('V' == requirementCode) then success = not success end
--							if success then
--								retval = false
----								if nil ~= earnedValue then
----									tinsert(failures, codeArray[i].." actual: "..earnedValue)
----								end
--							end
--						elseif 'P' == requirementCode then
						if 'P' == requirementCode then
							local colonCheck = strsub(codeArray[i], 3, 3)
							if ':' == controlValue or
							('L' == controlValue and ':' == colonCheck) or
							('H' == controlValue and ':' == colonCheck) or
							('C' == controlValue and ':' == colonCheck) or
							('C' == controlValue and 'T' == colonCheck and ':' == strsub(codeArray[i], 4, 4)) or
							('L' == controlValue and 'T' == colonCheck and ':' == strsub(codeArray[i], 4, 4))
							then
								-- we ignore these because they are not profession requirements.
							else
								local profValue = tonumber(strsub(codeArray[i], 3, 5))
								local exceeds, skillLevel = self:ProfessionExceeds(controlValue, profValue)
								if not exceeds then
									retval = false
--									tinsert(failures, codeArray[i].." actual: "..skillLevel)
								end
							end

						end
					end
				end
			end
			return retval
		end,

		---
		--	Returns whether the character meets class requirements for the specified quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@soughtClass The desired class to be matched, or if nil the player's class will be used
		--	@return True if the character meets the class requirements for the specified quest or false otherwise.
		--	@return A table of failures if any, nil otherwise.
		--	@see StatusCode
		MeetsRequirementClass = function(self, questId, soughtClass)
			return self:_MeetsRequirement(questId, 'C', soughtClass)
		end,

		---
		--	Returns whether the character meets faction requirements for the specified quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@soughtFaction The desired faction to be matched, or if nil the player's faction will be used
		--	@return True if the character meets the faction requirements for the specified quest or false otherwise.
		--	@return A table of failures if any, nil otherwise.
		--	@see StatusCode
		MeetsRequirementFaction = function(self, questId, soughtFaction)
			return self:_MeetsRequirement(questId, 'F', soughtFaction)
		end,

		---
		--	Returns whether the character meets gender requirements for the specified quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@param soughtGender The desired gender to be matched, or if nil the player's gender will be used
		--	@return True if the character meets the gender requirements for the specified quest or false otherwise.
		--	@return A table of failures if any, nil otherwise.
		--	@see StatusCode
		MeetsRequirementGender = function(self, questId, soughtGender)
			return self:_MeetsRequirement(questId, 'G', soughtGender)
		end,

		---
		--	Returns whether the character meets group quest requirements based on the contents
		--	of the controlTable, which can have in it:
		--		groupNumber		integer		number of group for quests	(required)
		--		minimum			integer		number needing to match		(required)
		--		turnedIn		boolean		indicating a match succeeds when quest completed and turned in
		--		completeInLog	boolean		indicating a match succeeds when quest complete in log
		--		accepted		boolean		indicating a match succeeds when quest has been accepted
		--		possible		boolean		indicating a match succeeds when quest is not invalidated
		MeetsRequirementGroupControl = function(self, controlTable)
			controlTable = controlTable or {}
			local numberMatching = 0
			local questTable = self.questStatusCache['G'][controlTable.groupNumber] or {}
			local dailyGroup = nil
			if controlTable.accepted then
				local dailyDay = self:_GetDailyDay()
				dailyGroup = GrailDatabasePlayer["dailyGroups"][dailyDay] and GrailDatabasePlayer["dailyGroups"][dailyDay][controlTable.groupNumber] or {}
			end
			if #questTable >= controlTable.minimum then
				for _, questId in pairs(questTable) do
					local foundMatch = false
					if not foundMatch and controlTable.turnedIn then
						if self:IsQuestCompleted(questId) then foundMatch = true end
					end
					if not foundMatch and controlTable.completeInLog then
						local questInLog, questStatus = Grail:IsQuestInQuestLog(questId)
						if questInLog and questStatus ~= nil and questStatus > 0 then foundMatch = true end
					end
					if not foundMatch and controlTable.accepted then
						if tContains(dailyGroup, questId) then foundMatch = true end
					end
					if not foundMatch and controlTable.possible then
						if not self:IsInvalidated(questId) then foundMatch = true end
					end
					if foundMatch then numberMatching = numberMatching + 1 end
				end
			end
			return (numberMatching >= controlTable.minimum)
		end,

		MeetsRequirementGroup = function(self, groupNumber, minimumDone)
			if not Grail.warnedAboutMeetsRequirementGroup then
				print("Grail:MeetsRequirementGroup(g, m) is obsolete (071).  Please replace with Grail:MeetsRequirementGroupControl({groupNumber = g, minimum = m, turnedIn = true}) instead.")
				Grail.warnedAboutMeetsRequirementGroup = true
			end
			return self:MeetsRequirementGroupControl({groupNumber = groupNumber, minimum = minimumDone, turnedIn = true})
		end,

		MeetsRequirementGroupAccepted = function(self, groupNumber, minimumAccepted)
			if not Grail.warnedAboutMeetsRequirementGroupAccepted then
				print("Grail:MeetsRequirementGroupAccepted(g, m) is obsolete (071).  Please replace with Grail:MeetsRequirementGroupControl({groupNumber = g, minimum = m, accepted = true}) instead.")
				Grail.warnedAboutMeetsRequirementGroupAccepted = true
			end
			return self:MeetsRequirementGroupControl({groupNumber = groupNumber, minimum = minimumAccepted, accepted = true})
--			local numberAccepted = 0
--			local questTable = self.questStatusCache['G'][groupNumber] or {}
--			if #questTable >= minimumAccepted then
--				local dailyDay = self:_GetDailyDay()
--				local dailyGroup = GrailDatabasePlayer["dailyGroups"][dailyDay] and GrailDatabasePlayer["dailyGroups"][dailyDay][groupNumber] or {}
--				for _, questId in pairs(questTable) do
--					if tContains(dailyGroup, questId) then
--						numberAccepted = numberAccepted + 1
--					end
--				end
--			end
--			return (numberAccepted >= minimumAccepted)
		end,

		MeetsRequirementGroupPossibleToComplete = function(self, groupNumber, minimumDone)
			if not Grail.warnedAboutMeetsRequirementGroupPossibleToComplete  then
				print("Grail:MeetsRequirementGroupPossibleToComplete(g, m) is obsolete (071).  Please replace with Grail:MeetsRequirementGroupControl({groupNumber = g, minimum = m, possible = true}) instead.")
				Grail.warnedAboutMeetsRequirementGroupPossibleToComplete  = true
			end
			return self:MeetsRequirementGroupControl({groupNumber = groupNumber, minimum = minimumDone, possible = true})
--			local numberAvailableToDo = 0
--			local questTable = self.questStatusCache['G'][groupNumber] or {}
--			if #questTable >= numberAvailableToDo then
--				for _, questId in pairs(questTable) do
--					if not self:IsInvalidated(questId) then
--						numberAvailableToDo = numberAvailableToDo + 1
--					end
--				end
--			end
--			return (numberAvailableToDo >= minimumDone)
		end,

		---
		--	Returns whether the character meets holiday requirements for the specified quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@return True if the character meets the holiday requirements for the specified quest or false otherwise.
		--	@return A table of failures if any, nil otherwise.
		--	@see StatusCode
		MeetsRequirementHoliday = function(self, questId)
			return self:_MeetsRequirement(questId, 'H')
		end,

		---
		--	Returns whether the level requirements are met for the specified quest.  This handles both minimum and maximum level requirements.
		--	@param questId The standard numeric questId representing a quest.
		--	@param optionalComparisonLevel A comparison level to use.  If nil the character's level is used.
		--	@return True if the level requirements for the specified quest are met or false otherwise.
		--	@return The level used in making comparisons to the requirements of the quest.
		--	@return The minimum level required for the quest.
		--	@return The maximum level permitted for the quest or Grail.INFINITE_LEVEL if there is none.
		--	@see StatusCode
		MeetsRequirementLevel = function(self, questId, optionalComparisonLevel)
			questId = tonumber(questId)
			if nil == questId then return false end
			local bitMask = self:CodeLevel(questId)
			local retval = true
			local levelToCompare = optionalComparisonLevel or UnitLevel('player')
			local levelRequired = bitband(bitMask, self.bitMaskQuestMinLevel) / self.bitMaskQuestMinLevelOffset
			local levelNotToExceed = bitband(bitMask, self.bitMaskQuestMaxLevel) / self.bitMaskQuestMaxLevelOffset
			if levelToCompare < levelRequired or levelToCompare > levelNotToExceed then
				retval = false
			end
			return retval, levelToCompare, levelRequired, levelNotToExceed
		end,

		---
		--	Returns whether the character meets profession requirements for the specified quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@return True if the character meets the profession requirements for the specified quest or false otherwise.
		--	@return A table of failures if any, nil otherwise.
		--	@see StatusCode
		MeetsRequirementProfession = function(self, questId)
			return self:MeetsPrerequisites(questId, 'P', self.bitMaskProfession)
		end,

		---
		--	Returns whether the character meets race requirements for the specified quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@soughtRace The desired race to be matched, or if nil the player's race will be used
		--	@return True if the character meets the race requirements for the specified quest or false otherwise.
		--	@return A table of failures if any, nil otherwise.
		--	@see StatusCode
		MeetsRequirementRace = function(self, questId, soughtRace)
			return self:_MeetsRequirement(questId, 'R', soughtRace)
		end,

		---
		--	Returns whether the character meets reputation requirements for the specified quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@return True if the character meets the reputation requirements for the specified quest or false otherwise.
		--	@return A table of failures if any, nil otherwise.
		--	@see StatusCode
--		MeetsRequirementReputation = function(self, questId)
--			local first, failures = self:_MeetsRequirement(questId, 'V')
--			local second, failures2 = self:_MeetsRequirement(questId, 'W')
--			local retval = first and second
--			if nil == failures then
--				failures = failures2
--			else
--				failures = self:_TableAppend(failures, failures2)
--			end
--			return retval, failures
--		end,

		MeetsRequirementReputation = function(self, questId)
			return self:MeetsPrerequisites(questId, 'P', self.bitMaskReputation)
		end,

--		MeetsRequirementReputation = function(self, questId)
--			local retval, failures = true, nil
--			local reputationCodes = self.questReputationRequirements[questId]
--			if reputationCodes then
--				local repuationCount = strlen(reputationCodes) / 4
--				local index, value, notExceeds
--				local exceeds, earnedValue
--				for i = 1, reputationCount do
--					index, value = self:ReputationDecode(strsub(reputationCodes, i * 4 - 3, i * 4))	-- when value is negative this means reputation cannot exceed the -value
--					notExceeds = false
--					if value < 0 then
--						value = value * -1
--						notExceeds = true
--					end
--					exceeds, earnedValue = self:_ReputationExceeds(self.repuationMapping[index], value)
--					if notExceeds then exceeds = not exceeds end
--					if not exceeds then
--						retval = false
--						failures = (failures or "") .. "|Rep:" .. index .. value .. " Actual:" .. earnedValue .. " "
--					end
--				end
--			end
--			if nil ~= failures then failures = {failures} end
--			return retval, failures
--		end,

		_NPCFaction = function(self, npcId)
			npcId = tonumber(npcId)
			return nil ~= npcId and self.npc.faction[npcId] or nil
		end,

		-- Provided our internal npcId (handling game objects and items) return
		-- the value to use in looking up the name of the NPC.  This allows our
		-- varieties of indirection.  Without a value, return the requested.
		_NPCIndex = function(self, npcId)
			local retval = tonumber(npcId)
			if nil ~= retval and nil ~= self.npc.nameIndex[retval] then
				retval = self.npc.nameIndex[retval]
			end
			return retval
		end,

		---
		--	Returns a table of NPC records filtered by the provided parameters where each record contains
		--	informaion about the NPC's location containing values whose keys are described in this table:
		--		name		the localized name of the NPC
		--		id			the npcId (passed in to the function)
		--		mapArea		the map area ID where the NPC is located
		--		mapLevel	if present the dungeon level within the mapArea
		--		near		true if the NPC is considered nearby
		--		x			the x coordinate of the NPC location
		--		y			the y coordinate of the NPC location
		--		realArea	the map area ID of the real area where the NPC is located
		--		heroic		true if the NPC needs to be in a heroic dungeon
		--		kill		true if the NPC needs to be killed to start a quest
		--		notes		non-nil if there are notes associated with the NPC
		--		alias		if exists is the actual NPC ID of the Blizzard NPC
		--		dropName	if exists is the name of the item dropped
		--		dropId		if exists is the NPC ID of the item dropped
		--		questId		if exists is the quest associated with the dropped item
		--	@param npcId The standard numeric npcId representing an NPC.
		--	@param requiresNPCAvailable If true, the NPC must be available.
		--	@param onlySingleReturn If true, only one location will be in the returned table, otherwise all matching locations will be there.
		--	@param onlyMapReturn If true, only locations matching the appropriate map area will be returned.
		--	@param preferredMapAreaId The map area ID to be used, and if nil the character's current map area is used.
		--	@param dungeonLevel The dungeon level to be used
		--	@return A table of locations where the NPC can be found or nil if there are none.
		--	@see IsNPCAvailable
		NPCLocations = function(self, npcId, requiresNPCAvailable, onlySingleReturn, onlyMapReturn, preferredMapAreaId, dungeonLevel)
			local retval = {}
			local npcs = self:_RawNPCLocations(npcId)
			if nil ~= npcs then
				local mapIdToUse = tonumber(preferredMapAreaId) or Grail.GetCurrentDisplayedMapAreaID()
				for _, npc in pairs(npcs) do
					if not requiresNPCAvailable or self:IsNPCAvailable(npc.id) then
						if not onlyMapReturn or (onlyMapReturn and mapIdToUse == npc.mapArea) then
							if not dungeonLevel or (dungeonLevel == npc.mapLevel) then
								tinsert(retval, npc)
							end
						end
					end
				end
				if onlySingleReturn and 1 < #retval then
					retval = { retval[1] }		-- pick the first item for no better algorithm to use to decide
				end
			end
			if 0 == #retval then
				retval = nil
			end
			return retval
		end,

		---
		--	Returns the localized name of the NPC represented by the specified NPC ID.
		--	@param npcId The standard numeric npcId representing an NPC.
		--	@return The localized string for the specific NPC, or nil if the NPC is not found in the database.
		NPCName = function(self, npcId)
			local retval = nil
			npcId = tonumber(npcId)
			if nil ~= npcId then
				local indexToUse = self:_NPCIndex(npcId)
				retval = self.npc.name[indexToUse]
				if nil == retval then
					local hyperlinkFormat
					if indexToUse > 100000000 then
						hyperlinkFormat = strformat("item:%d:0:0:0:0:0:0:0", indexToUse - 100000000)
					elseif indexToUse > 1000000 then
						hyperlinkFormat = strformat("unit:0xF51%05X00000000", indexToUse - 1000000)	-- does not work
--						hyperlinkFormat = 'item:GameObject-0-0-0-0-' .. indexToUse - 1000000 .. '-0'	-- did not work
--						hyperlinkFormat = 'unit:GameObject-0-0-0-0-' .. indexToUse - 1000000 .. '-0'	-- did not work
--						hyperlinkFormat = 'unit:Creature-0-0-0-0-' .. indexToUse - 1000000 .. '-0'	-- did not work
					else
						hyperlinkFormat = 'unit:Creature-0-0-0-0-' .. indexToUse .. '-0'
					end
					local frame = self.tooltipNPC
					if not frame:IsOwned(UIParent) then frame:SetOwner(UIParent, "ANCHOR_NONE") end
					frame:ClearLines()
					frame:SetHyperlink(hyperlinkFormat)
					local numLines = frame:NumLines()
					if nil ~= numLines and 0 ~= numLines then
						local text = _G["com_mithrandir_grailTooltipNPCTextLeft1"]
						if text then
							retval = text:GetText()
							if retval ~= self.retrievingString then
								self.npc.name[indexToUse] = retval
							end
						end
					end
				end
			end
			return retval
		end,

		---
		--	Returns the npcId to use for the NPC found at the specified location
		--	with the specified npcId.  This can return an alias npcId, and it can
		--	create either the real one or an alias, updating the databases based
		--	on what it has done.
		--	@param npcId The standard numeric Blizzard ID representing an NPC.
		--	@param npcLocationString The standard Grail string representing the location of the NPC.
		--	@return The npcId one should use for this NPC.
		_NPCToUse = function(self, npcId, npcLocationString)
			npcId = tonumber(npcId)
			local retval = npcId
			if nil ~= npcId and npcId > 0 then
				if not self:_LocationKnown(npcId, npcLocationString) then
					local aliasFound = false
					local possibleAliases = self.npc.aliases[npcId]
					if nil ~= possibleAliases then
						for _, aliasId in pairs(possibleAliases) do
							if self:_LocationKnown(aliasId, npcLocationString) then
								retval = aliasId
								aliasFound = true
							end
						end
					end
					if not aliasFound then
						if nil ~= self.npc.locations[npcId] and 0 < #(self.npc.locations[npcId]) then
							retval = self:_CreateAliasNPC(npcId, npcLocationString)
						else
							self:LearnNPCLocation(npcId, npcLocationString)
						end
					end
				end
			end
			return retval
		end,

		_CreateAliasNPC = function(self, npcId, npcLocationString)
			local aliasBase = 2999999
			while nil ~= self.npc.locations[aliasBase + 1] do
				aliasBase = aliasBase + 1
			end
			local newAliasId = aliasBase + 1
			self:LearnNPCLocation(newAliasId, npcLocationString, npcId)
			return newAliasId
		end,

		---
		--	Returns the localized name of the GameObject represented by the specified Object ID, if Grail knows it.
		--	@param objectId The standard numeric Blizzard ID representing a game object.
		--	@return The localized string for the specific game object, or nil if it is not in the database.
		ObjectName = function(self, objectId)
			local retval = nil
			objectId = tonumber(objectId)
			if nil ~= objectId then
				local indexToUse = self:_NPCIndex(objectId + 1000000)
				retval = self:NPCName(indexToUse)
			end
			return retval
		end,

		---
		--	Returns the localized name of the item represented by the specified Item ID.
		--	@param itemId The standard numeric Blizzard ID representing an item.
		--	@return The localized string for the specific item.
		ItemName = function(self, itemId)
			local retval = nil
			itemId = tonumber(itemId)
			if nil ~= itemId then
				local indexToUse = self:_NPCIndex(itemId + 100000000)
				retval = self:NPCName(indexToUse)
			end
			return retval
		end,

		-- Checks to ensure the only prerequisites that fail are ones that possess the specified questCode
		_OnlyFailsPrerequisites = function(self, questId, questCode)
			local retval = true
			local success, failures = self:MeetsPrerequisites(questId)
			if not success and nil ~= failures then
				for _, codeString in pairs(failures) do
					if questCode ~= strsub(codeString, 1, 1) then
						retval = false
					end
				end
			end
			return retval
		end,

		--	Internal Use.
		--	This routine ensures that all the codes present in tableOrString are ones that match the codeLetter.
		_OnlyHasCodes = function(self, tableOrString, codeLetter)
			local controlTable = { retval = true, codeLetter = codeLetter, func = self._OnlyHasCodesSupport }
			self._ProcessCodeTable(tableOrString, controlTable)
			return controlTable.retval
		end,

		_OnlyHasCodesSupport = function(controlTable)
			local code, subcode, numeric = Grail:CodeParts(controlTable.innorItem)
			if controlTable.codeLetter ~= code then controlTable.retval = false end
		end,

		--	Checks to ensure the invalidations present are those that have the specified questCode
		_OnlyHasInvalidates = function(self, questId, questCode)
			return self:_OnlyHasCodes(self:QuestInvalidates(questId), questCode)
		end,

		--	Checks to ensure the prerequisites present are those that have the specified questCode
		_OnlyHasPrerequisites = function(self, questId, questCode)
			return self:_OnlyHasCodes(self:QuestPrerequisites(questId, true), questCode)
		end,

		--	Checks to make sure the phase matches the type for the specified code and number.
		--	For 971, this is the player's Garrison and we can use the same code structure for
		--	phases to handle Garrison level.
		_PhaseMatches = function(self, typeOfMatch, phaseCode, phaseNumber)
			local retval = false
			local currentPhase = nil
-- SMH: This is commented out for the time being until we can investigate how to handle
-- phasing on Thunder Isle.
--			if (not self.battleForAzeroth and 928 == phaseCode) or (self.battleForAzeroth and 504 == phaseCode) then
---- TODO: Determine if we will need to change the map to that of Thunder Isle to make use of this...I believe it will be the only way
--				if "THUNDER_ISLE" == C_MapBar.GetTag() then
--					currentPhase = C_MapBar.GetPhaseIndex() + 1	-- it starts with 0 for phase 1 (just like C)
--				end
--			else
			if (not self.battleForAzeroth and (971 == phaseCode or 976 == phaseCode)) or (self.battleForAzeroth and (581 == phaseCode or 587 == phaseCode)) then
				currentPhase = C_Garrison.GetGarrisonInfo(LE_GARRISON_TYPE_6_0) or 0	-- the API returns nil when there is no garrison
			end
			if nil ~= currentPhase then
				if ('=' == typeOfMatch and currentPhase == phaseNumber) or
					('<' == typeOfMatch and currentPhase < phaseNumber) or
					('>' == typeOfMatch and currentPhase > phaseNumber) then
					retval = true
				end
			end
			return retval
		end,

		--	Routine used to put notifications into the system that will be posted in a routine called by OnUpdate after
		--	the spcified delay.  If there were no notifications in the queue prior to this call the notificationFrame
		--	will have an OnUpdate script set.
		--	@param notificationName The name of the notification that will eventually be posted.  E.g., Abandon, Accept, etc.
		--	@param questId The questId associated with the notification.
		--	@param delay The delay time in seconds which will probably be a floating point number less than one.
		_PostDelayedNotification = function(self, notificationName, questId, delay)
			if nil == self.delayedNotifications then self.delayedNotifications = {} end
			if 0 == #(self.delayedNotifications) then	-- the assumption is when the table has 0 notifications we pull the handler off
				self.notificationFrame:SetScript("OnUpdate", function(myself, elapsed) self:_ProcessDelayedNotifications(elapsed) end)
			end
			tinsert(self.delayedNotifications, { ["n"] = notificationName, ["q"] = questId, ["f"] = GetTime() + delay })
		end,

		--	This routine is used to post notifications to observers.
		--	@param eventName The name of the notification.
		--	@param questId The questId associated with the notification.
		_PostNotification = function(self, eventName, questId)
			if nil ~= self.observers[eventName] then
				for _,f in pairs(self.observers[eventName]) do
					f(eventName, questId)
				end
			end
		end,

		_GetPrerequisiteInfo = function(controlTable)
			controlTable = controlTable or {}
			local questId, preqTable, result, index = controlTable.questId, controlTable.preq, controlTable.result, controlTable.index
			if nil == questId then return end
			local code, subcode, numeric = Grail:CodeParts(questId)
			if nil == numeric then return end
			if nil ~= preqTable and not tContains(preqTable, numeric) then
				tinsert(preqTable, numeric)
				local preqs = Grail:QuestPrerequisites(numeric, true)
				if nil ~= preqs then
					local doMath = controlTable.doMath
					controlTable.doMath = nil
					Grail._PreparePrerequisiteInfo(preqs, controlTable)
					controlTable.doMath = doMath
				end
				return
			end
			local statusLetter = Grail:ClassificationOfQuestCode(questId, nil, controlTable.buggedObtainable)
			if 'P' == statusLetter then
				local doMath = controlTable.doMath
				controlTable.doMath = nil
				Grail._PreparePrerequisiteInfo(Grail:QuestPrerequisites(numeric, true), controlTable)
				controlTable.doMath = doMath
			elseif 'U' == statusLetter or 'B' == statusLetter or 'C' == statusLetter then -- or 'L' == statusLetter
				-- do nothing since this is a failure
			else	-- I, D, R, G, W
				result[numeric] = result[numeric] or {}
				if not tContains(result[numeric], index) then tinsert(result[numeric], index) end
			end
		end,

		--	Internal Use.
		--	This routine allows gathering a list of all the prerequisites starting with the ones in the provided tableOrString
		--	following the prerequsites recursively as appropriate.  The controlTable contains information about how the levels
		--	of prerequisites are to be processed.
		--		result			table		keys will be questIds for the first prerequisites in chains, and values will be tables of indexes (based on the indexes in the first prerequisites)
		--		preq			table
		--		lastIndexUsed	integer
		--		doMath			boolean
		--		index			integer		internal - current index being processed
		--		questId			integer		internal - current questId being processed
		--		buggedObtainable boolean
		--		func			function	function to be called for each innorItem processed from tableOrString
		--		codeString		string		internal - current codeString (where tableOrString is string) being processed, nil for table
		--		orItem			string		internal - current orItem from codeString being processed
		--		andItem			string		internal - current andItem from orItem being processed
		--		innorItem		string		internal - current innorItem from andItem being processed
		--	@param tableOrString The prerequisite information provided as a table or a string.
		--	@param controlTable The table that provides control information for processing the prerequisites.
		_PreparePrerequisiteInfo = function(tableOrString, controlTable)
			controlTable.func = controlTable.func or Grail._PreparePrerequisiteInfoSupport
			Grail._ProcessCodeTable(tableOrString, controlTable)
		end,

		_PreparePrerequisiteInfoSupport = function(controlTable)
			local code, subcode, numeric = Grail:CodeParts(controlTable.innorItem)
			if nil == controlTable.preq or not tContains(controlTable.preq, numeric) then
				if '' == code or 'A' == code or 'B' == code or 'C' == code or 'D' == code or 'E' == code or 'H' == code or 'O' == code or 'X' == code then
					controlTable.questId = numeric
					Grail._GetPrerequisiteInfo(controlTable)
				elseif 'V' == code or 'W' == code or 'w' == code then
					local questTable = Grail.questStatusCache.G[subcode] or {}
					for _, questId in pairs(questTable) do
						controlTable.questId = questId
						Grail._GetPrerequisiteInfo(controlTable)
					end
				else
					-- do nothing since we do not care about this code
				end
			end
		end,

		--	Internal Use.
		--	This routine will process the provided codeString using the internal structure
		--	convention of , indicating logical OR, + indicating logical AND, and | indicating
		--	logical OR within an AND.  In other words we do not use parentheses, but instead
		--	change the symbol used for OR based on whether it is governed by an AND.
		--	The controlTable is used to pass in some more parameters:
		--		lastIndexUsed
		--		doMath
		--		func		=> the actual function that will do the real work
		_ProcessCodeString = function(codeString, controlTable)
			codeString, controlTable = (codeString or ""), (controlTable or {})
			local index, doMath, func = (controlTable.lastIndexUsed or 0), controlTable.doMath, (controlTable.func or Grail._ProcessCodeStringPrintFunction)
			local start, length = 1, strlen(codeString)
			local stop = length
			local orIndex = 0
			local commaCount = 0
			for i in strgmatch(codeString, ",") do commaCount = commaCount + 1 end
			while start <= length do
				local foundComma = strfind(codeString, ",", start, true)
				stop = foundComma and (foundComma - 1) or length
				local orItem = strsub(codeString, start, stop)
				local orStart, orLength = 1, strlen(orItem)
				local orStop = orLength
				orIndex = orIndex + 1
				local plusCount = 0
				for i in strgmatch(orItem, "+") do plusCount = plusCount + 1 end
				if doMath then index = index + 1 end
				local andIndex = 0
				while orStart <= orLength do
					local foundPlus = strfind(orItem, "+", orStart, true)
					orStop = foundPlus and (foundPlus - 1) or orLength
					local andItem = strsub(orItem, orStart, orStop)
					local andStart, andLength = 1, strlen(andItem)
					local andStop = andLength
					andIndex = andIndex + 1
					local pipeCount = 0
					for i in strgmatch(andItem, "|") do pipeCount = pipeCount + 1 end
					local useIndex2 = (0 < pipeCount)
					local pipeIndex = 0
					while andStart <= andLength do
						local foundPipe = strfind(andItem, "|", andStart, true)
						andStop = foundPipe and (foundPipe - 1) or andLength
						local innorItem = strsub(andItem, andStart, andStop)
						pipeIndex = pipeIndex + 1
						if func then
							controlTable.codeString, controlTable.orItem, controlTable.andItem, controlTable.innorItem = codeString, orItem, andItem, innorItem
							controlTable.index, controlTable.useIndex2, controlTable.pipeIndex, controlTable.orIndex, controlTable.andIndex = index, useIndex2, pipeIndex, orIndex, andIndex
							controlTable.commaCount, controlTable.plusCount, controlTable.pipeCount = commaCount, plusCount, pipeCount
							func(controlTable)
						end
						andStart = andStop + 2
					end
					orStart = orStop + 2
				end
				start = stop + 2
			end
			return index
		end,

		--	Internal Use.
		--	This routine is the default function that is used to print a codeString's structure
		--	from _ProcessCodeString() if no function is provided by the caller.
		_ProcessCodeStringPrintFunction = function(controlTable)
			local codeString = controlTable.codeString or "<NIL>"
			print(strgsub(codeString, "|", "*"), "=>", strgsub(controlTable.orItem, "|", "*"), strgsub(controlTable.andItem, "|", "*"), controlTable.innorItem)
		end,

		--	Internal Use.
		--	This routine is the same as _ProcessCodeString() except it uses the original table structure
		--	instead of the codeString.  If it is passed a codeString it will call _ProcessCodeString()
		--	to do the work instead.
		_ProcessCodeTable = function(table, controlTable)
			controlTable = controlTable or {}
			local index, doMath, func = (controlTable.lastIndexUsed or 0), controlTable.doMath, (controlTable.func or Grail._ProcessCodeStringPrintFunction)
			if nil == table then return index end
			if "table" ~= type(table) then return Grail._ProcessCodeString(table, controlTable) end
			local commaCount = #table
			local orIndex = 0
			for key, value in pairs(table) do
				orIndex = orIndex + 1
				if doMath then index = index + 1 end
				local valueToUse = ("table" == type(value)) and value or {value}
				local plusCount = #valueToUse
				local andIndex = 0
				for key2, value2 in pairs(valueToUse) do
					andIndex = andIndex + 1
					local valueToUse2 = ("table" == type(value2)) and value2 or {value2}
					local pipeCount = #valueToUse2
					local useIndex2 = (1 < #valueToUse2)
					local pipeIndex = 0
					for key3, value3 in pairs(valueToUse2) do
						pipeIndex = pipeIndex + 1
						if func then
							controlTable.codeString, controlTable.orItem, controlTable.andItem, controlTable.innorItem = nil, value, value2, value3
							controlTable.index, controlTable.useIndex2, controlTable.pipeIndex, controlTable.orIndex, controlTable.andIndex = index, useIndex2, pipeIndex, orIndex, andIndex
							controlTable.commaCount, controlTable.plusCount, controlTable.pipeCount = commaCount, plusCount, pipeCount
							func(controlTable)
						end
					end
				end
			end
			return index
		end,

		--	Internal Use.
		--	Routine used by the OnUpdate system to process notifications that have been put into a queue for delayed
		--	processing.  When the last notification is removed from the queue, the notificationFrame will have its
		--	OnUpdate script removed.
		_ProcessDelayedNotifications = function(self, ignoredElapsed)
			local now = GetTime()	-- if now > "fire trigger" we post the associated notification
			local newNotificationTable = {}
			for _, t in pairs(self.delayedNotifications) do
				if now > t["f"] then
					self:_PostNotification(t["n"], t["q"])
				else
					tinsert(newNotificationTable, t)
				end
			end
			self.delayedNotifications = newNotificationTable
			if 0 == #(self.delayedNotifications) then
				self.notificationFrame:SetScript("OnUpdate", nil)
			end
		end,

		--	This routine takes a structure of prerequisites in their raw string form and processes them
		--	so any quests in the prerequisites that are in fact flag quests marked with J: codes will
		--	have them processed so no quests with J: codes will appear in the list of prerequisites.
-- TODO: This routine has to deal with a string structure. Basically any quest
--	can have a J code associated with them.  So, quest 777777 could have J:111111,222222 which would mean that any
--	quest having a prerequisite with 777777 in it would need to logically change that 7777777 into 111111,222222
--	which can get quite interesting.
		_ProcessForFlagQuests = function(self, preqsString, controlTable)
			local controlTable = controlTable or { preq = {}, something = "", func = self._ProcessForFlagQuestsSupport }
print("Processing for flags:", strgsub(preqsString, "|", "*"))
			self._ProcessCodeTable(preqsString, controlTable)
print("end:", strgsub(controlTable.something, "|", "*"))
			return controlTable.something
		end,

		_ProcessForFlagQuestsSupport = function(controlTable)
			local code, subcode, numeric = Grail:CodeParts(controlTable.innorItem)
			local stringToAdd = controlTable.innorItem
			if '' == code or 'A' == code or 'B' == code or 'C' == code or 'D' == code or 'E' == code or 'H' == code or 'O' == code or 'X' == code then
				local flags = Grail:QuestFlags(numeric, true)
				if nil ~= flags then
					local innerControlTable = { preq = controlTable.preq, something = "", func = controlTable.func }
					stringToAdd = Grail:_ProcessForFlagQuests(flags, innerControlTable)
				end
			end
			local controlToAdd = ""
			if 1 < controlTable.pipeIndex then
				controlToAdd = "|"
			elseif 1 < controlTable.andIndex then
				controlToAdd = "+"
			elseif 1 < controlTable.orIndex then
				controlToAdd = ","
			end
			controlTable.something = controlTable.something .. controlToAdd .. stringToAdd
		end,

		--	Internal Use.
		--	This looks at the quest codes in the table to determine whether any of them require entries to be made in the
		--	questStatusCache structure which is used to invalidate quests based on how quests interrelate and happenings
		--	in the environment.  It calls a support routine to do the dirty work as this just iterates through the table
		--	contents.  The support routine uses a mapping to take quest codes and assign them to the proper internal table
		--	entries.
		_ProcessQuestsForHandlers = function(self, questId, tableOrString, destinationTable)
			local controlTable = { questId = questId, output1 = desinationTable, func = self._ProcessQuestsForHandlersSupport }
			self._ProcessCodeTable(tableOrString, controlTable)
		end,

		_ProcessQuestsForHandlersMapping = { ["B"] = 'D', ["D"] = 'D', ["e"] = 'D', ["I"] = 'B', ["J"] = 'A', ["K"] = 'C', ["L"] = 'E', ["M"] = 'F', ['m'] = 'F', ["R"] = 'R', ["S"] = 'Y', ["V"] = 'X', ["W"] = 'W', ["w"] = 'W', ["Y"] = 'B', ["Z"] = 'Z' },

		-- This gets called when prerequisite codes are processed to determine what caches should contain the quests in question.
		_ProcessQuestsForHandlersSupport = function(controlTable)
			local self = Grail
			local destinationTable, questId = (controlTable.output1 or self.questStatusCache), controlTable.questId
			local code, subcode, numeric = self:CodeParts(controlTable.innorItem)
			if 't' == code or 'u' == code then numeric = numeric * -1 end
			local mappedCode = self._ProcessQuestsForHandlersMapping[code]
			if nil ~= mappedCode then
				destinationTable[mappedCode] = destinationTable[mappedCode] or {}
				destinationTable[mappedCode][numeric] = destinationTable[mappedCode][numeric] or {}
				tinsert(destinationTable[mappedCode][numeric], questId)
			elseif 'L' == code then
				if Grail.levelingLevel < numeric then
					tinsert(destinationTable.L, questId)
				end
			elseif 'P' == code then
				self:AddQuestToMapArea(questId, tonumber(self.professionToMapAreaMapping['P'..subcode]), self.professionMapping[subcode])
			elseif 'T' == code or 't' == code or 'U' == code or 'u' == code then
				self.questReputationRequirements[questId] = (self.questReputationRequirements[questId] or "") .. self:_ReputationCode(subcode..numeric)
			elseif 'G' == code or 'z' == code then
				destinationTable.M = destinationTable.M or {}
				local buildingIds, t
				if numeric < 0 then
					buildingIds = Grail.garrisonBuildingMapping[numeric]
				else
					buildingIds = { numeric }
				end
				for _, buildingId in pairs(buildingIds) do
					t = destinationTable.M[buildingId] or {}
					if not tContains(t, questId) then
						tinsert(t, questId)
					end
					destinationTable.M[buildingId] = t
				end
			elseif 'x' ==  code then
				self.invalidateControl[self.invalidateGroupArtifactKnowledge] = self.invalidateControl[self.invalidateGroupArtifactKnowledge] or {}
				tinsert(self.invalidateControl[self.invalidateGroupArtifactKnowledge], questId)
			elseif '@' == code then
				-- This is implemented quite simply to say that any quest that has an artifact level requirement will be invalidated
				-- if there is a change in any artifact level, not examining the actual artifact involved in the change.
				local t = self.invalidateControl[self.invalidateGroupArtifactLevel] or {}
				if not tContains(t, questId) then
					tinsert(t, questId)
				end
				self.invalidateControl[self.invalidateGroupArtifactLevel] = t
			end
		end,

		_ProcessServerBackup = function(self, quiet)
			GrailDatabasePlayer["backupCompletedQuests"] = {}
			for i, v in pairs(GrailDatabasePlayer["completedQuests"]) do
				GrailDatabasePlayer["backupCompletedQuests"][i] = v
			end
			if not quiet then
				print("|cFFFFFF00Grail|r: A backup of the completed quests has been made")
			end
		end,

		--	This will figure out what quests are marked complete on the server and how that
		--	differs from what is recorded in the backup.  Assuming a recent backup of completed
		--	quests is recorded this can be used to determine what quests have just had their
		--	completed state change.  The two tables passed in can be used to return those
		--	changes.
		_ProcessServerCompare = function(self, newlyCompletedTable, newlyLostTable)
			local quiet = (newlyCompletedTable ~= nil or newlyLostTable ~= nil)
			local db = GrailDatabasePlayer
			if nil == db["backupCompletedQuests"] then print("|cFFFF0000Grail|r: Please do |cFF00FF00/grail backup|r first") return
			else if not quiet then print("|cFF00FF00Grail|r: Starting quest comparison between completed quests and backup") end end
			local indexesToCheck = {}
			for index, value in pairs(db["completedQuests"]) do
				if not tContains(indexesToCheck, index) then tinsert(indexesToCheck, index) end
			end
			for index in pairs(db["backupCompletedQuests"]) do
				if not tContains(indexesToCheck, index) then tinsert(indexesToCheck, index) end
			end
			local backup, current, diff, base, message
			for _, index in pairs(indexesToCheck) do
				backup = db["backupCompletedQuests"][index] or 0
				current = db["completedQuests"][index] or 0
				if current ~= backup then
					diff = bitbxor(current, backup)
					-- index 0 covers 1 - 32
					-- index 1 covers 33 - 64
					-- index 2 covers 65 - 96
					base = index * 32
					for i = 0, 31 do
						if bitband(diff, 2^i) > 0 then		-- this means there is a bit difference between backup and current
							if bitband(current, 2^i) > 0 then	-- this means current is marked complete
								message = strformat("New quest completed %d", base + i + 1)
								if newlyCompletedTable then tinsert(newlyCompletedTable, base + i + 1) end
							else
								message = strformat("New quest LOST %d", base + i + 1)
								if newlyLostTable then tinsert(newlyLostTable, base + i + 1) end
							end
							if not quiet then
								print(message)
							end
							self:_AddTrackingMessage(message)
						end
					end
				end
			end
			if not quiet then
				print("|cFFFF0000Grail|r: End quest comparison")
			end
		end,

		_ProcessServerQuests = function(self)
			local debugStartTime = debugprofilestop()
			if not GrailDatabase.silent or self.manuallyExecutingServerQuery then
				print("|cFF00FF00Grail|r: starting to process completed query results")
			end

			local db = GrailDatabasePlayer

			--	First make a temporary backup of what we think is completed
			local temporaryBackupQuests = {}
			for i, v in pairs(db["completedQuests"]) do
				temporaryBackupQuests[i] = v
			end
			local completedQuestCount = self:_CountCompleteInDatabase(temporaryBackupQuests)

			--	Now process the completed quests from the server query results
			local completedQuests = { }
			GetQuestsCompleted(completedQuests)
			local serverCompletedCount = 0
			for k,v in pairs(completedQuests) do
				serverCompletedCount = serverCompletedCount + 1
			end
			if serverCompletedCount < completedQuestCount * self.completedQuestThreshold then
				print("|cFFFF0000Grail|r: abandoned processing completed query results because currently complete", completedQuestCount, "but server only thinks", serverCompletedCount)
				return
			end
			local hour, minute = GetGameTime()
			local weekday, month, day, year = CalendarGetDate()
			db["serverUpdated"] = strformat("%4d-%02d-%02d %02d:%02d", year, month, day, hour, minute)
			db["completedQuests"] = { }
			if nil ~= completedQuests then		-- normally should always be non-nil, but just to make sure
				for v,_ in pairs(completedQuests) do
					self:_MarkQuestComplete(v)
				end
			end

			-- Blizzard makes their "champion" Red Crane dailies remain dailies instead of having them be
			-- normal quests.  This even gives them issue because they need to keep track of which ones have
			-- been done since the server does not keep track of this for them because of the behavior of
			-- daily quests.  They keep track with four quests that are used as bits to create a number from
			-- one to fifteen.  We can make use of these bits to record which of the dailes have been done
			-- even if one only starts to use Grail in the middle of the set of champions.
			local totalChampionsCompleted = 0
			for i = 0, 3 do
				if self:IsQuestCompleted(30719 + i) then
					totalChampionsCompleted = totalChampionsCompleted + 2^i
				end
			end
			for i = 1, totalChampionsCompleted do
				self:_MarkQuestInDatabase(30724 + i, GrailDatabasePlayer["completedResettableQuests"])
			end

			--	Now make sure each of the quests marked complete in controlCompletedQuests are also set
			local backup, current, diff, base
			for index, value in pairs(db["controlCompletedQuests"]) do
				if value ~= nil then
					base = index * 32
					for i = 0, 31 do
						if bitband(value, 2^i) > 0 then
							self:_MarkQuestComplete(base + i + 1)
						end
					end
				end
			end

			--	Now process the actuallyCompletedQuests to ensure we have a good concept of what was actually done
			local actualToNuke = {}
			for index, value in pairs(db["actuallyCompletedQuests"]) do
				if value ~= nil then
					base = index * 32
					for i = 0, 31 do
						if bitband(value, 2^i) > 0 then
							current = base + i + 1		-- this is a questId that is considered "actually" complete
							if self:IsQuestCompleted(current) then
							-- ensure all the I: quests are not considered complete from the server
								local iQuests = self:QuestInvalidates(current)
								if nil ~= iQuests then
									local shouldNuke
									for _, questId in pairs(iQuests) do
--										if questId contains an O: code with the value current we do not need to mark it NOT complete
										shouldNuke = true
										local oQuests = self:QuestBreadcrumbs(questId)
										if nil ~= oQuests then
											for _, oQuestId in pairs(oQuests) do
												if oQuestId == current then shouldNuke = false end
											end
										end
										if shouldNuke then self:_MarkQuestNotComplete(questId, db["completedQuests"]) end
									end
								end
							else
								-- remove the quest from the list of "actually" completed quests
								tinsert(actualToNuke, current)
--								self:_MarkQuestNotComplete(current, db["actuallyCompletedQuests"])
							end
						end
					end
				end
			end
			for _, questToNuke in pairs(actualToNuke) do
				self:_MarkQuestNotComplete(questToNuke, db["actuallyCompletedQuests"])
			end

-- TODO: Should contemplate performing a sanity check here to make sure that all the quests from completedQuests
--			actually can be completed by the player.  This means the gender, class, race and faction checks can
--			be used to mark incomplete those that should not be marked complete.

			--	Now invalidate any quests whose completed status from the backup does not match the server
			local indexesToCheck = {}
			for index in pairs(db["completedQuests"]) do
				if not tContains(indexesToCheck, index) then tinsert(indexesToCheck, index) end
			end
			for index in pairs(temporaryBackupQuests) do
				if not tContains(indexesToCheck, index) then tinsert(indexesToCheck, index) end
			end
			if 0 < #indexesToCheck then
				local questsToInvalidate = {}
				for _, index in pairs(indexesToCheck) do
					backup = temporaryBackupQuests[index] or 0
					current = db["completedQuests"][index] or 0
					if current ~= backup then
						diff = bitbxor(current, backup)
						base = index * 32
						for i = 0, 31 do
							if bitband(diff, 2^i) > 0 then
								tinsert(questsToInvalidate, base + i + 1)
							end
						end
					end
				end
				if 0 < #questsToInvalidate then self:_StatusCodeInvalidate(questsToInvalidate) end
			end

			--	Remove the temporary backup
			wipe(temporaryBackupQuests)

			if not GrailDatabase.silent or self.manuallyExecutingServerQuery then
				print("|cFFFF0000Grail|r: finished processing completed query results")
			end
			self.manuallyExecutingServerQuery = false
			self.timings.ProcessServerQuests = debugprofilestop() - debugStartTime
		end,

		--	Internal Use.
		--	Returns whether the character has the profession specified by the code exceeding the specified level.
		--	@param professionCode The code representing the profession as used in Grail.professionMapping
		--	@param professionValue The skill level to use in comparison.
		--	@return True when the character possesses the skill in excess of the indicated value, false otherwise.
		--	@return The actual skill level the character posseses or Grail.NO_SKILL if the character does not have the specified skill.
		--	@use hasSkill, skillLevel = Grail:ProfessionExceeds('Z', 125)
		ProfessionExceeds = function(self, professionCode, professionValue)
			local retval = false
			local skillLevel, ignore1, ignore2 = self.NO_SKILL, nil, nil
			local skillName = nil
			local prof1, prof2, archaeology, fishing, cooking, firstAid = GetProfessions();

			if "X" == professionCode and nil ~= archaeology then
				ignore1, ignore2, skillLevel = GetProfessionInfo(archaeology)
			elseif "F" == professionCode and nil ~= fishing then
				ignore1, ignore2, skillLevel = GetProfessionInfo(fishing)
			elseif "C" == professionCode and nil ~= cooking then
				ignore1, ignore2, skillLevel = GetProfessionInfo(cooking)
			elseif "Z" == professionCode and nil ~= firstAid then
				ignore1, ignore2, skillLevel = GetProfessionInfo(firstAid)
			elseif "R" == professionCode then
				skillLevel = self:_RidingSkillLevel()
			else
				local professionName = self.professionMapping[professionCode]
				if nil ~= prof1 then
					skillName, ignore1, skillLevel = GetProfessionInfo(prof1)
				end
				if skillName ~= professionName then
					if nil ~= prof2 then
						skillName, ignore1, skillLevel = GetProfessionInfo(prof2)
					end
					if skillName ~= professionName then
						skillLevel = self.NO_SKILL
					end
				end
			end
			if skillLevel >= professionValue then
				retval = true
			end
			return retval, skillLevel
		end,

		--	Internal Use.
		--	Routine used to hook the function for abandoning a quest.  This is needed because the events that Blizzard issues
		--	are not adequate for our desired tasks.  One of three needed for abandoning.
		_QuestAbandonStart = function(self)
			self.abandoningQuestIndex = GetQuestLogSelection()
			self.origAbandonQuestFunction()
		end,

		--	Internal Use.
		--	Routine used to hook the function for abandoning a quest.  This is needed because the events that Blizzard issues
		--	are not adequate for our desired tasks.  One of three needed for abandoning.
		_QuestAbandonStop = function(self)
			local questTitle, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questId = self:GetQuestLogTitle(self.abandoningQuestIndex)
			self.origConfirmAbandonQuestFunction()
			if nil ~= self.quests[questId] then
				self:_MarkQuestInDatabase(questId, GrailDatabasePlayer["abandonedQuests"])
			end

			-- Check to see whether this quest belongs to a group and handle group counts properly
			if self.questStatusCache.H[questId] then
				for _, group in pairs(self.questStatusCache.H[questId]) do
					if self:_RecordGroupValueChange(group, false, true, questId) >= self.dailyMaximums[group] - 1 then
						self:_StatusCodeInvalidate(self.questStatusCache['G'][group])
					end
				end
			end

			if nil ~= self.quests[questId] and nil ~= self.quests[questId]['OBC'] then
				local questsToInvalidate = {}
				for _,clearQuestId in pairs(self.quests[questId]['OBC']) do
					self:_MarkQuestComplete(clearQuestId, true, false, true)
					tinsert(questsToInvalidate, clearQuestId)
				end
				self:_StatusCodeInvalidate(questsToInvalidate)
			end
			self:_PostDelayedNotification("Abandon", questId, self.abandonPostNotificationDelay)
		end,

		---
		--	Returns a table of questIds that are possible breadcrumbs for the specified quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@return A table of questIds for possible breadcrumb quests for this quest, or nil if there are none.
		QuestBreadcrumbs = function(self, questId)
			return self:_QuestGenericAccess(questId, 'O')
		end,

		---
		--	Returns a tables of questIds for which this quest is a breadcrumb quest.
		QuestBreadcrumbsFor = function(self, questId)
			return self:_QuestGenericAccess(questId, 'B')
		end,

		_QuestCompleteProcess = function(self, questId)
			self.questNPCId = self:GetNPCId(false)
			if nil == questId then
				questId = self:QuestIdFromNPCOrName(self.completingQuestTitle, self.questNPCId)
			end

			if questId then
				self.completingQuest = self:_GetOTCQuest(questId, self.questNPCId)
				local shouldUpdateActual = (nil ~= self:QuestInvalidates(questId))
				self:_MarkQuestComplete(questId, true, shouldUpdateActual, false)

				if nil ~= self.quests[questId] then
					local odcCodes = self.quests[questId]['ODC']
					if nil ~= odcCodes then
						for i = 1, #odcCodes do
							self:_MarkQuestComplete(odcCodes[i], true, false, false)
						end
					end
					local oecCodes = self.quests[questId]['OEC']
if GrailDatabase.debug and nil ~= oecCodes then print("For quest", questId, "we have OEC codes") end
if GrailDatabase.debug and nil ~= oecCodes and not self:MeetsPrerequisites(questId, "OPC") then print("For quest", questId, "we do not meet prerequisites for OPC") end
					if nil ~= oecCodes and self:MeetsPrerequisites(questId, "OPC") then
						for i = 1, #oecCodes do
if GrailDatabase.debug then print("Marking OEC quest complete", oecCodes[i]) end
							self:_MarkQuestComplete(oecCodes[i], true, false, false)
						end
					end

					-- Check whether this quest belongs to a group and invalidate those quests that want to know that group status
					if self.questStatusCache.H[questId] then
						for _, group in pairs(self.questStatusCache.H[questId]) do
							if self:_RecordGroupValueChange(group, false, false, questId) >= self.dailyMaximums[group] then
								self:_StatusCodeInvalidate(self.questStatusCache['W'][group])
							end
						end
					end

				else
					print("|cffff0000Grail problem|r because completing quest which seems not to exist", questId)
				end

				self.completingQuest = nil
			end
		end,

		---
		--	Returns a table of quests that are the causes for this quest to be a flag quest.
		QuestFlags = function(self, questId, forceRawData)
			local retval = self:_QuestGenericAccess(questId, 'J')
			if retval and not forceRawData then
				retval = self:_FromPattern(retval)
			end
			return retval
		end,

		_QuestGenericAccess = function(self, questId, internalCode)
			questId = tonumber(questId)
			return nil ~= questId and nil ~= self.quests[questId] and self.quests[questId][internalCode] or nil
		end,

		---
		--	Returns the questId based on the parameters passed in by looking in the specialQuests
		--	for one that matches the either the specified NPC or the one that currently is the "npc"
		--	or "questnpc".  If a questId is not found using the specialQuests, one is returned that
		--	matches the provided name.
		--	@param questName The localized name of the quest whose questId is sought.
		--	@param optionalNPCIdToUse The npcId to use.  If nil, the defaul is looked up.
		--	@param shouldUseNameFallback If not nil, the questId is looked up by name as a fallback if none found using specialQuests.
		--	@return The sought questId.
		QuestIdFromNPCOrName = function(self, questName, optionalNPCIdToUse, shouldUseNameFallback)
			local retval = nil
			local npcId = optionalNPCIdToUse or self:GetNPCId(false)
			local questGivers = self.specialQuests[questName]
			if nil ~= questGivers then
				for i = 1, #questGivers do
					if tonumber(questGivers[i][1]) == npcId then
						retval = questGivers[i][2]
					end
				end
			end
			if nil == retval and shouldUseNameFallback then
				retval = self:QuestWithName(questName)
			end
			return retval
		end,

		---
		--	Returns the questId of the quest in the quest log with the sought title.
		--	@param soughtTitle The localized name of the quest sought in the quest log.
		--	@return The questId of the quest in the quest log matching the sought name or nil if none match.
		QuestInQuestLogMatchingTitle = function(self, soughtTitle)
			local retval = nil
			local cleanedTitle = strtrim(soughtTitle)
			local quests = self:_QuestsInLog()
			for questId, t in pairs(quests) do
				if cleanedTitle == t[1] then
					retval = questId
				end
			end
			return retval
		end,

		---
		--	Returns a table of questIds that invalidate the specified quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@return A table of questIds that invalidate this quest, or nil if there are none.
		QuestInvalidates = function(self, questId)
			return self:_QuestGenericAccess(questId, 'I')
		end,

		---
		--	Returns the level of the quest with the specified questId.
		--	@param questId The standard numeric questId representing a quest.
		--	@return The level of the quest matching the questId or nil if none found.
		QuestLevel = function(self, questId)
			return bitband(self:CodeLevel(questId), self.bitMaskQuestLevel) / self.bitMaskQuestLevelOffset
		end,

--		--	Historically this function was publicly available, but we want to hide the internal
--		--	use of codes for accept and turnin, so we will still provide this, but we will warn
--		--	clients to use new API instead.
--		QuestLocations = function(self, questId, acceptOrTurnin, requiresNPCAvailable, onlySingleReturn, onlyMapAreaReturn, preferredMapId, acceptsMultipleUniques, dungeonLevel, isStartup)
--			if 'A' == acceptOrTurnin and nil == self.warnedClientQuestLocationsAccept and not isStartup then
--				print("Grail:QuestLocations(questId, 'A', ...) is obsolete.  Please replace with Grail:QuestLocationsAccept(questId, ...) instead.")
--				self.warnedClientQuestLocationsAccept = true
--			elseif 'T' == acceptOrTurnin and nil == self.warnedClientQuestLocationsTurnin and not isStartup then
--				print("Grail:QuestLocations(questId, 'T', ...) is obsolete.  Please replace with Grail:QuestLocationsTurnin(questId, ...) instead.")
--				self.warnedClientQuestLocationsTurnin = true
--			end
--			return self:_QuestLocations(questId, acceptOrTurnin, requiresNPCAvailable, onlySingleReturn, onlyMapAreaReturn, preferredMapId, acceptsMultipleUniques, dungeonLevel, isStartup)
--		end,

		QuestLocationsAccept = function(self, questId, requiresNPCAvailable, onlySingleReturn, onlyMapAreaReturn, preferredMapId, acceptsMultipleUniques, dungeonLevel, isStartup)
			return self:_QuestLocations(questId, 'A', requiresNPCAvailable, onlySingleReturn, onlyMapAreaReturn, preferredMapId, acceptsMultipleUniques, dungeonLevel, isStartup)
		end,

		QuestLocationsTurnin = function(self, questId, requiresNPCAvailable, onlySingleReturn, onlyMapAreaReturn, preferredMapId, acceptsMultipleUniques, dungeonLevel, isStartup)
			return self:_QuestLocations(questId, 'T', requiresNPCAvailable, onlySingleReturn, onlyMapAreaReturn, preferredMapId, acceptsMultipleUniques, dungeonLevel, isStartup)
		end,

		_QuestLocations = function(self, questId, acceptOrTurnin, requiresNPCAvailable, onlySingleReturn, onlyMapAreaReturn, preferredMapId, acceptsMultipleUniques, dungeonLevel, isStartup)
			local retval = {}
			questId = tonumber(questId)
			if nil ~= questId and nil ~= self.quests[questId] then
				local npcCodes = self.quests[questId][acceptOrTurnin..'P']
				if nil == npcCodes then
					npcCodes = self.quests[questId][acceptOrTurnin]
					if nil == npcCodes then
						npcCodes = self.quests[questId][acceptOrTurnin..'K']
					end
					if nil ~= npcCodes then
						for _, npcId in pairs(npcCodes) do
							local locations = self:NPCLocations(npcId, requiresNPCAvailable, onlySingleReturn, onlyMapAreaReturn, preferredMapId, dungeonLevel)
							if nil ~= locations then
								for _, npc in pairs(locations) do
									tinsert(retval, npc)
								end
							end
						end
					else
						local zoneId = self.quests[questId][acceptOrTurnin..'Z']
						if nil ~= zoneId and not isStartup then
							local mapId = tonumber(preferredMapId) or Grail.GetCurrentDisplayedMapAreaID()
							if not onlyMapAreaReturn or (onlyMapAreaReturn and zoneId == mapId) then
								tinsert(retval, { ["id"] = 0, ["name"] = self:NPCName(0), ["mapArea"] = mapId, })
							end
						end
					end
				else
					local npcId, prereqs
					for _, npcPreqTable in pairs(npcCodes) do
						npcId, prereqs = npcPreqTable[1], npcPreqTable[2]
--					for npcId, prereqs in pairs(npcCodes) do
						if isStartup or self:_AnyEvaluateTrueF(prereqs, nil, Grail._EvaluateCodeAsPrerequisite) then
							local locations = self:NPCLocations(npcId, requiresNPCAvailable, onlySingleReturn, onlyMapAreaReturn, preferredMapId, dungeonLevel)
							if nil ~= locations and 0 == #retval then
								for _, npc in pairs(locations) do
									tinsert(retval, npc)
								end
							end
						end
					end
				end
			end
			-- Since the return values from NPCLocations will process things like onlySingleReturn properly, that means the retval should only have
			-- one location value per unique NPC and that means we can make use of acceptsMultipleUniques to ignore the onlySingleReturn value here.
			if onlySingleReturn and not acceptsMultipleUniques and 1 < #retval then retval = { retval[1] } end		-- pick the first item since no better algorithm
			if 0 == #retval then
				retval = nil
			end
			return retval
		end,

		_QuestLogUpdate = function(type, questId)
			Grail:_HandleEventUnitQuestLogChanged()
		end,


		_RealQuestIdToUse = function(self, questId)
			questId = tonumber(questId)
			local retval = questId
			if nil ~= retval and questId > 500000 and questId < 600000 then
				local alias = self:AliasQuestId(questId)
				if nil ~= alias then
					retval = alias
				end
			end
			return retval
		end,

		---
		--	Returns the name of the quest with the specified questId.
		--	@param questId The standard numeric questId representing a quest.
		--	@return The localized name of the quest matching the questId or nil if none found.
		QuestName = function(self, questId, waitForResponse)
			local retval = nil
			questId = self:_RealQuestIdToUse(questId)
			if nil ~= questId then
				local attempts = 0
				local maxAttempts = waitForResponse or 1
				while (nil == retval and attempts < maxAttempts) do
					retval = self.quest.name[questId]
					if nil == retval then
						local frame = self.tooltip
						if not frame:IsOwned(UIParent) then frame:SetOwner(UIParent, "ANCHOR_NONE") end
						frame:ClearLines()
						frame:SetHyperlink(strformat("quest:%d", questId))
						local numLines = frame:NumLines()
						if nil ~= numLines or 0 ~= numLines then
							local text = _G["com_mithrandir_grailTooltipTextLeft1"]
							if text then
								retval = text:GetText()
								if nil ~= retval and retval ~= self.retrievingString then
									self.quest.name[questId] = retval
									if self.forceLocalizedQuestNameLoad then
										GrailDatabase.learned = GrailDatabase.learned or {}
										GrailDatabase.learned.QUEST_NAME = GrailDatabase.learned.QUEST_NAME or {}
										tinsert(GrailDatabase.learned.QUEST_NAME, self.playerLocale .. '|' .. self.blizzardRelease .. '|' .. questId .. '|' .. retval)
									end
								end
							end
						end
					end
					attempts = attempts + 1
				end
			end
			return retval
		end,

		---
		--	Returns a table of NPC IDs from which one can accept the specified quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@return A table of NPC ids, or nil if there are none.
		QuestNPCAccepts = function(self, questId)
			return self:_QuestGenericAccess(questId, 'A')
		end,

		---
		--	Returns a table of NPC IDs that can be killed to accept the specified quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@return A table of NPC ids, or nil if there are none.
		QuestNPCKills = function(self, questId)
			return self:_QuestGenericAccess(questId, 'AK')
		end,

		QuestNPCPrerequisiteAccepts = function(self, questId, forceRawData)
			return self:_QuestNPCPrerequisiteGeneric(questId, 'AP', forceRawData)
		end,

		---
		--	Returns a table in the expected format.  Historically the returned table has
		--	the key of the information and the value the prerequisites.  However, the internal
		--	structure has changed to preserve the order defined in the codes to allow first
		--	prerequisites met to define which information is used.
		_QuestNPCPrerequisiteGeneric = function(self, questId, code, forceRawData)
			local retval = self:_QuestGenericAccess(questId, code)
			if retval and not forceRawData then
				local newRetval = {}
				for _, innerTable in pairs(retval) do
					newRetval[innerTable[1]] = innerTable[2]
				end
				retval = newRetval
			end
			return retval
		end,

		QuestNPCPrerequisiteTurnins = function(self, questId, forceRawData)
			return self:_QuestNPCPrerequisiteGeneric(questId, 'TP', forceRawData)
		end,

		---
		--	Returns a table of NPC IDs to which one can turn in the specified quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@return A table of NPC ids, or nil if there are none.
		QuestNPCTurnins = function(self, questId)
			return self:_QuestGenericAccess(questId, 'T')
		end,

		QuestOnAcceptCompletes = function(self, questId)
			return self:_QuestGenericAccess(questId, 'OAC')
		end,

		QuestOnCompletionCompletes = function(self, questId)
			return self:_QuestGenericAccess(questId, 'OCC')
		end,

		QuestOnDoneCompletes = function(self, questId)
			return self:_QuestGenericAccess(questId, 'ODC')
		end,

		QuestOnTurninCompletes = function(self, questId)
			return self:_QuestGenericAccess(questId, 'OTC')
		end,

		---
		--	Returns a table of questIds that are simple prerequisites for the specified quest.
		--	@param questId The standard numeric questId representing a quest.
		--	@param forceRawData True indicates the internal format of the prerequisite codes is returned, otherwise the table form is returned.
		--	@return A table of questIds that are simple prerequisites for this quest, or nil if there are none.
		QuestPrerequisites = function(self, questId, forceRawData)
			local retval = self.questPrerequisites[questId]
			if retval and not forceRawData then
				retval = self:_FromPattern(retval)
			end
			return retval
		end,

		--	Routine used to hook the function for completing a quest.  This is needed because the events that Blizzard issues
		--	are not adequate for our desired tasks.
		_QuestRewardCompleteButton_OnClick = function(self)
			self:_QuestCompleteProcess(self.completingQuest)
			self.origHookFunction()
		end,

		--	Returns a table whose key is the questId and whose value is a table made of the quest title and the completedness
		--	of the quest for each quest in the Blizzard quest log.  If there is nothing in the log, an empty table is returned.
		_QuestsInLog = function(self)
			if nil == self.cachedQuestsInLog then
				local retval = {}
				--	It tuns out that numQuests will be correct, but numEntries will not reflect the total number of values that
				--	will be returned from GetQuestLogTitle() if any of the headers are closed.  With closed headers, the quests
				--	that would normally be in them are going to be at the end of the list, but not necessarily in any specific
				--	order that is helpful.
--				local numEntries, numQuests = GetNumQuestLogEntries()
--				for i = 1, numEntries do
				local i = 1
				while (true) do
					local questTitle, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questId, startEvent, displayQuestId, isWeekly, isTask = self:GetQuestLogTitle(i)
					if not questTitle then
						break
					else
						i = i + 1
					end
					if not isHeader then
						retval[questId] = { questTitle, isComplete }
					end
				end
				self.cachedQuestsInLog = retval
			end
			return self.cachedQuestsInLog
		end,

		---
		--	Returns a table of quest IDs for quests that can start in the specified map area.
		--	@param mapId The map area to use, or if nil, the map area the character is currently in will be used.
		--	@param useDungeonAlso If true, dungeon quests inside the map area will also be included.
		--	@param useLoremasterOnly If true, only Loremaster quests will be used for the area, ignoring the normal entire quest list and ignoring the useDungeonAlso parameter.
		--	@return A table of questIds for quests that start in the map area or nil if none.
		QuestsInMap = function(self, mapId, useDungeonAlso, useLoremasterOnly)
			local retval = {}
			local mapIdToUse = mapId or Grail.GetCurrentDisplayedMapAreaID()

			if nil ~= mapIdToUse then
				if not self.experimental then
					if useLoremasterOnly then
						retval = self.loremasterQuests[mapIdToUse]
					elseif useDungeonAlso then
						if nil == self.indexedQuestsExtra[mapIdToUse] then
							retval = self.indexedQuests[mapIdToUse]
						elseif nil == self.indexedQuests[mapIdToUse] then
							retval = self.indexedQuestsExtra[mapIdToUse]
						else
							for k,v in pairs(self.indexedQuests[mapIdToUse]) do
								tinsert(retval, v)
							end
							for k, v in pairs(self.indexedQuestsExtra[mapIdToUse]) do
								if not tContains(retval, v) then
									tinsert(retval, v)
								end
							end
						end
					else
						retval = self.indexedQuests[mapIdToUse]
					end
				else
					local tableToUse = useLoremasterOnly and self.loremasterQuests[mapIdToUse] or self.indexedQuests[mapIdToUse]
					local questId
					if nil ~= tableToUse then
						for k, v in pairs(tableToUse) do
							for i = 0, 31 do
								if bitband(v, 2^i) > 0 then
									questId = k * 32 + i + 1
									if not tContains(retval, questId) then tinsert(retval, questId) end
								end
							end
						end
					end
					if useDungeonAlso and not useLoremasterOnly and nil ~= self.indexedQuestsExtra[mapIdToUse] then
						for k, v in pairs(self.indexedQuestsExtra[mapIdToUse]) do
							for i = 0, 31 do
								if bitband(v, 2^i) > 0 then
									questId = k * 32 + i + 1
									if not tContains(retval, questId) then tinsert(retval, questId) end
								end
							end
						end
					end
				end
			end

			if nil ~= retval and 0 == #retval then retval = nil end
			return retval
		end,

		---
		--	Returns the questId for the quest with the specified name.
		--	@param soughtName The localized name of the quest.  If nil this will raise.
		--	@return The questId of the quest or nil if no quest with that name found.
		QuestWithName = function(self, soughtName)
			assert((nil ~= soughtName), "Grail Error: sought name cannot be nil")
			local retval = nil
-- With the change to have dynamic quest name lookups, this API is only going to give names that
-- have already been seen (unless a loadable addon of names has been loaded).
			for questId, questName in pairs(self.quest.name) do
				if questName == soughtName then
					retval = questId
-- TODO: Think about breaking out of the loop when retval is set...basically return the first match instead of the last match
				end
			end
			return retval
		end,

		--	Returns a table of NPC records where each record indicates the location
		--	of the NPC.  Each record can contain information as described in the
		--	documentation for NPCLocations.
		--	@param npcId The standard numeric npcId representing an NPC.
		--	@return A table of NPC records
		--	@see NPCLocations
		_RawNPCLocations = function(self, npcId)
			local retval = {}
			npcId = tonumber(npcId)
			if nil ~= npcId and npcId < 0 and nil == self.npc.nameIndex[npcId] then
				self.npc.nameIndex[npcId] = 0
				self.npc.locations[npcId] = {{["mapArea"]= -1 * npcId}}
			end
			if nil ~= npcId and nil ~= self.npc.locations[npcId] then
				local t = {}
				t.name = self:NPCName(npcId)
				t.id = npcId
				t.notes = self.npc.comment[npcId]
				t.locations = self.npc.locations[npcId]
				t.kill = (nil ~= self.npc.kill[npcId])
				t.alias = self.npc.nameIndex[npcId]
				if nil ~= t.alias then
					if nil == self.npc.aliases[t.alias] then
						t.alias = nil
					end
				end
				t.heroic = self.npc.heroic[npcId]
				t.droppers = {}
				local droppedBy = self.npc.droppedBy[npcId]
				if nil ~= droppedBy then
					for _, anNPCId in pairs(droppedBy) do
						local droppers = self:_RawNPCLocations(anNPCId)
						if nil ~= droppers then
							for _, dropper in pairs(droppers) do
								tinsert(t.droppers, dropper)
							end
						end
					end
				end
				t.questId = self.npc.questAssociations[npcId] and self.npc.questAssociations[npcId][1] or nil
				for _, t1 in pairs(t.locations) do
					local t2 = {}
					t2.name = t.name
					t2.id = t.id
					t2.notes = t.notes
					t2.kill = t.kill
					t2.alias = t.alias
					t2.heroic = t.heroic
					t2.mapArea = t1.mapArea
					t2.mapLevel = t1.mapLevel
					t2.near = t1.near
					t2.mailbox = t1.mailbox
					t2.created = t1.created
					t2.x = t1.x
					t2.y = t1.y
					t2.realArea = t1.realArea
					t2.questId = t.questId
					tinsert(retval, t2)
				end
				for _, t1 in pairs(t.droppers) do
					local t2 = {}
					t2.name = t1.name
					t2.id = t1.id
					t2.notes = t1.notes
					t2.kill = t.kill
					t2.alias = t.alias
					t2.heroic = t.heroic
					t2.mapArea = t1.mapArea
					t2.mapLevel = t1.mapLevel
					t2.near = t1.near
					t2.mailbox = t1.mailbox
					t2.created = t1.created
					t2.x = t1.x
					t2.y = t1.y
					t2.realArea = t1.realArea
					t2.dropName = t.name
					t2.dropId = t.id
					t2.questId = t.questId
					tinsert(retval, t2)
				end
			end
			if 0 == #retval then
				retval = nil
			end
			return retval
		end,

		--	This goes through all the bags to look for artifacts and attempts to record their
		--	levels by pretending to socket each of them which should open the UI that allows
		--	queries to be made against the "current artifact".
		_RecordArtifactLevels = function(self)
			for bag = 0, 4 do
				local numSlots = GetContainerNumSlots(bag)
				for slot = 1, numSlots do
					local _, _, _, quality, _, _, _, _, _, itemID = GetContainerItemInfo(bag, slot)
					if LE_ITEM_QUALITY_ARTIFACT == quality then
						local classID = select(12, GetItemInfo(itemID))
						if LE_ITEM_CLASS_WEAPON == classID or LE_ITEM_CLASS_ARMOR == classID then
							SocketContainerItem(bag, slot)
							local duplicateItemId, _, _, _, _, ranksPurchased = C_ArtifactUI.GetArtifactInfo()
							if itemID == duplicateItemId then
								self.artifactLevels[itemID] = ranksPurchased
							end
						end
					end
				end
			end
			if HasArtifactEquipped() then
				SocketInventoryItem(INVSLOT_MAINHAND)
				local duplicateItemId, _, _, _, _, ranksPurchased = C_ArtifactUI.GetArtifactInfo()
				if nil ~= duplicateItemId then
					self.artifactLevels[duplicateItemId] = ranksPurchased
				end
			end
			C_ArtifactUI.Clear()
		end,

		_RecordBadData = function(self, whichData, errorString)
			if nil == GrailDatabase[whichData] then GrailDatabase[whichData] = {} end
			if nil ~= errorString then tinsert(GrailDatabase[whichData], errorString) end
		end,

		_RecordBadNPCData = function(self, errorString)
			self:_RecordBadData("BadNPCData", errorString)
		end,

		_RecordBadQuestData = function(self, errorString)
			self:_RecordBadData("BadQuestData", errorString)
		end,

		--	This routine will update the per-player saved information about group quests
		--	that are currently considered accepted on a specific "daily" day.  It erases
		--	any previous information if the "daily" day changes.  It returns the count 
		_RecordGroupValueChange = function(self, group, isAdding, isRemoving, questId)
			local dailyDay = self:_GetDailyDay()
			GrailDatabasePlayer["dailyGroups"] = GrailDatabasePlayer["dailyGroups"] or {}
			GrailDatabasePlayer["dailyGroups"][dailyDay] = GrailDatabasePlayer["dailyGroups"][dailyDay] or {}
			local t = GrailDatabasePlayer["dailyGroups"][dailyDay][group] or {}
			if isAdding then
				if not tContains(t, questId) then tinsert(t, questId) end
			elseif isRemoving then
				if tContains(t, questId) then
					local index, foundIndex = 1, nil
					while t[index] do
						if t[index] == questId then
							foundIndex = index
						end
						index = index + 1
					end
					if foundIndex then
						tremove(t, foundIndex)
					end
				else
					if GrailDatabase.debug then print("|cFFFFFF00Grail|r _RecordGroupValueChange could not remove a non-existent quest", questId) end
				end
			end
			GrailDatabasePlayer["dailyGroups"][dailyDay][group] = t
			return #(t)
		end,

		_RegisterDelayedEvent = function(self, frame, delayTable)
			if nil ~= delayTable then
				local originalCount = self.delayedEventsCount
				self.delayedEventsCount = self.delayedEventsCount + 1
				self.delayedEvents[self.delayedEventsCount] = delayTable
--				if 0 == originalCount and 1 == self.delayedEventsCount then		-- what we added is the first in the list...therefore, register for the event to take things out of the table
--					frame:RegisterEvent("PLAYER_REGEN_ENABLED")
--				end
			end
		end,

-- TODO: Continue analyzing from here down...
		---
		--	Adds the callback to the observer queue for eventName.  Should use convenience API when possible.
		--	@see RegisterObserverQuestAbandon
		--	@see RegisterObserverQuestAccept
		--	@see RegisterObserverQuestComplete
		--	@see RegisterObserverQuestStatus
		--	@param eventName The name of the event to which the callback should be added.
		--	@param callback The callback that is to be added.
		RegisterObserver = function(self, eventName, callback)
			assert((nil ~= callback), "Grail Error: cannot register a nil callback")
			if nil == self.observers[eventName] then self.observers[eventName] = { } end
			tinsert(self.observers[eventName], callback)
		end,

		---
		--	Add the callback to receive quest Abandon notifications.
		--	When the notification is posted the callback will be called with two parameters, "Abandon" and the questId.
		--	@param callback The callback that is to be added.
		RegisterObserverQuestAbandon = function(self, callback)
			self:RegisterObserver("Abandon", callback)
		end,

		---
		--	Add the callback to receive quest Accept notifications.
		--	When the notification is posted the callback will be called with two parameters, "Accept" and the questId.
		--	@param callback The callback that is to be added.
		RegisterObserverQuestAccept = function(self, callback)
			self:RegisterObserver("Accept", callback)
		end,

		---
		--	Add the callback to receive quest Completion notifications.
		--	When the notification is posted the callback will be called with two parameters, "Complete" and the questId.
		--	@param callback The callback that is to be added.
		RegisterObserverQuestComplete = function(self, callback)
			self:RegisterObserver("Complete", callback)
		end,

		---
		--	Add the callback to receive quest Status notifications.
		--	When the notification is posted the callback will be called with two parameters, "Status" and the questId.
		--	@param callback The callback that is to be added.
		RegisterObserverQuestStatus = function(self, callback)
			self:RegisterObserver("Status", callback)
		end,

		RegisterSlashOption = function(self, option, helpDescription, theFunction)
			self.slashCommandOptions[option] = { ['help'] = helpDescription, ['func'] = theFunction }
		end,

		-- This checks to make sure Grail has the exact same list of blizzardReputations for the specified quest
		_ReputationChangesMatch = function(self, questId, blizzardReputations)
			if not self.questReputations then return (#blizzardReputations == 0) end
			local retval = true
			questId = tonumber(questId)
			local grailReps = questId and self.questReputations[questId] or ""
			local grailRepsCount = strlen(grailReps) / 4
			local start, stop
			local factionId, value

			if #blizzardReputations ~= grailRepsCount then
				retval = false
			else
				for i = 1, #blizzardReputations do
					start, stop = strfind(grailReps, self:_ReputationCode(blizzardReputations[i]), 1, true)
					if nil == start or 0 ~= stop % 4 then retval = false
					end
				end
				for i = 1, grailRepsCount do
					factionId, value = self:ReputationDecode(strsub(grailReps, i * 4 - 3, i * 4))
					if not tContains(blizzardReputations, factionId..tostring(value)) then retval = false
					end
				end
			end
			return retval
		end,

		--	This returns a four-character representation of a reputation string
		_ReputationCode = function(self, reputationString)
			local factionId = tonumber(strsub(reputationString, 1, 3), 16)
			local value = tonumber(strsub(reputationString, 4))
			if value < 0 then
				value = (value * -1) + 0x00080000
			end
			value = value + factionId * 0x00100000
			return strchar(bitband(bitrshift(value, 24), 255), bitband(bitrshift(value, 16), 255), bitband(bitrshift(value, 8), 255), bitband(value, 255))
		end,

		--	This takes the four-character code and returns the index and value
		ReputationDecode = function(self, code)
			local a, b, c, d = strbyte(code, 1, 4)
			local i = a * 256 * 256 * 256 + b * 256 * 256 + c * 256 + d
			local factionId = bitrshift(i, 20)
			local value = i - factionId * 0x00100000
			if bitband(value, 0x00080000) > 0 then
				value = (value - 0x00080000) * -1
			end
			return self:_HexValue(factionId, 3), value
		end,

		--	Returns whether the character has a reputation that exceeds the value specified for the reputation specified.
		--	@param reputationName The localized name of the sought reputation.
		--	@param reputationValue The reputation value that needs to be exceeded.  Note that internally all reputation values are the earned reputation value + 42000.
		--	@return True if the character has more reputation than was sought, or false otherwise.
		--	@return The reputation value the character actually has (earned value + 42000).
		--	@usage doesExceed, reputationValue = Grail:_ReputationExceeds("Lower City", 41999)
		_ReputationExceeds = function(self, reputationName, reputationValue)
			local retval = false
			local actualEarnedValue = nil
			reputationValue = tonumber(reputationValue)
			local reputationId = self.reverseReputationMapping[reputationName]
			local factionId = reputationId and tonumber(reputationId, 16) or nil
if factionId == nil then print("Rep nil issue:", reputationName, reputationId, reputationValue) end
			if nil ~= factionId and nil ~= reputationValue then
				local name, description, standingId, barMin, barMax, barValue = GetFactionInfoByID(factionId)
				if name then
					actualEarnedValue = barValue + 42000	-- the reputationValue is stored with 42000 added to it so we do not have to deal with negative numbers, so we normalize here
                    if C_Reputation.IsFactionParagon(factionId) then
						local paraValue, paraThreshold, paraQuestId, paraRewardPending = C_Reputation.GetFactionParagonInfo(factionId)
						if paraValue and paraThreshold then
							actualEarnedValue = actualEarnedValue + (paraValue % paraThreshold)
							if paraRewardPending then
								actualEarnedValue = actualEarnedValue + paraThreshold
							end
						end
					end
					retval = (actualEarnedValue > reputationValue)
				end
			end
			return retval, actualEarnedValue
		end,

		_FriendshipReputationExceeds = function(self, reputationName, reputationValue)
			local retval = false
			local actualEarnedValue = nil
			reputationValue = tonumber(reputationValue)
			local reputationId = self.reverseReputationMapping[reputationName]
			local factionId = reputationId and tonumber(reputationId, 16) or nil
if factionId == nil then print("Rep nil issue:", reputationName, reputationId, reputationValue) end
			if nil ~= factionId and nil ~= reputationValue then
				local id, rep, maxRep, name, text, texture, reaction, threshold, nextThreshold = GetFriendshipReputation(factionId)
				--	when withering, threshold is 0, but when stable threshold is 100
				--	when withering, rep is 1, but when stable threshold is 101 - 199
				--	maxRep seems to be 42999 in any case
				if id and id > 0 then
					if nil == nextThreshold then
						nextThreshold = threshold
					end
					local base = maxRep - nextThreshold + threshold
					local amount = 0
					if 0 ~= threshold then
						amount = rep - threshold
					end
					actualEarnedValue = base + amount
					retval = (actualEarnedValue > reputationValue)
				end
			end
			return retval, actualEarnedValue
		end,

		--	Returns the localized values for the reputation name and the reputation level (including any modifications)
		--	If no reputationValue exists, it is assumed it will be in the reputationCode.  If it does exist, then the
		--	reputationCode cannot contain it.
		ReputationNameAndLevelName = function(self, reputationCode, reputationValue)
			local retval = nil
			local factionStandingFormat = "FACTION_STANDING_LABEL%d"
			if self.playerGender == 3 then factionStandingFormat = factionStandingFormat.."_FEMALE" end
			reputationValue = tonumber(reputationValue)
			if nil == reputationValue then
				reputationValue = tonumber(reputationCode, 4)
				reputationCode = strsub(reputationCode, 1, 3)
			end
			local usingFriends = self.reputationFriends[reputationCode] and true or false
			local usingBodyGuards = self.reputationBodyGuards[reputationCode] and true or false
			if nil ~= reputationValue then
				local repExtra = ""
				local repNumber
				if usingFriends then
					repNumber = self.reputationFriendshipLevelMapping[reputationValue]
				elseif usingBodyGuards then
					repNumber = self.reputationBodyGuardLevelMapping[reputationValue]
				else
					repNumber = self.reputationLevelMapping[reputationValue]
				end
				if nil == repNumber then
					print("*** Grail.ReputationNameAndLevelName problem:",factionStandingFormat,reputationCode,reputationValue,usingFriends,usingBodyGuards)
					repNumber = 0
				end
				if repNumber > 100 then
					repExtra = " +" .. mod(repNumber, 1000000)
					repNumber = floor(repNumber / 1000000)
				end
				local reputationValue
				if usingFriends then
					reputationValue = self.friendshipLevel[repNumber]
				elseif usingBodyGuards then
					reputationValue = self.bodyGuardLevel[repNumber]
				else
					reputationValue = GetText(strformat(factionStandingFormat, repNumber))
				end
				retval = strformat("%s%s", reputationValue, repExtra)
			end
			return self.reputationMapping[reputationCode], retval
		end,

		FriendshipReputationNameAndLevelName = function(self, reputationCode, reputationValue)
			return self.reputationMapping[reputationCode], "Stable"
		end,

		--	Returns the riding skill level of the character.
		--	@return The riding skill level of the character or Grail.NO_SKILL if no skill exists.
		_RidingSkillLevel = function(self)
			-- Need to search the spell book for the Riding skill
			local retval = self.NO_SKILL
			local spellIdMapping = { [33388] = 75, [33391] = 150, [34090] = 225, [34091] = 300, [90265] = 375 }
			local _, _, _, numberSpells = GetSpellTabInfo(1)
			for i = 1, numberSpells, 1 do
				local spellType, spellId = GetSpellBookItemInfo(i, BOOKTYPE_SPELL)
				if spellType == "SPELL" then	-- because FUTURESPELL means you do not have it yet
					local newLevel = spellIdMapping[spellId]
					if newLevel and newLevel > retval then
						retval = newLevel
					end
				end
--				local name = GetSpellBookItemName(i, BOOKTYPE_SPELL)
--				local link = GetSpellLink(name)
--				if link then
--					local spellId = tonumber(link:match("^|c%x+|H(.+)|h%[.+%]"):match("(%d+)"))
--					if spellId then
--						local newLevel = spellIdMapping[spellId]
--						if newLevel and newLevel > retval then
--							retval = newLevel
--						end
--					end
--				end
			end
			return retval
		end,

		_SendQuestChoiceList = {
			[54] = 32259,	-- Isle of Thunder Horde PvE
			[55] = 32258,	-- Isle of Thunder Horde PvP
			[64] = 32260,	-- Isle of Thunder Alliance PvE
			[65] = 32261,	-- Isle of Thunder Alliance PvP
			[119] = 34560,	-- Artillery Tower Alliance Fort Wrynn -- 37301 37304
			[120] = 34561,	-- Mage Tower Alliance Fort Wrynn -- Also, 34574 as well
			[121] = 34568,	-- Artillery Tower Horde Talador
			[122] = 34567,	-- Mage Tower Horde Talador	-- 37302 37303
			[123] = 34679,	-- Alliance Stables Nagrand
			[124] = 34680,	-- Alliance Tank Works Nagrand
			[125] = 34812,	-- Horde Stables Nagrand
			[126] = 34813,	-- Horde Tank Works Nagrand
			[127] = 35049,	-- Alliance Lumber Mill Gorgrond -- Also 36249,36250,36619
			[128] = 35064,	-- Alliance Fight Club Gorgrond -- Also 36251 36252
			[129] = 34992,	-- Horde Lumber Mill Gorgrond	-- Also, 36249 and 36250 as well
			[130] = 35149,	-- Horde Fight Club Gorgrond	-- Also, 36251 and 36252 as well
			[133] = 35283,	-- Alliance Arak Brewery	-- 35290 37313 37315
--	The planning maps actually accept the quests properly so we
--	should not set them explicitly and just use this for reference.
--			[135] = 36648,	-- Stronghold Alliance Stonefury Cliffs	-- ??Also, 36549 as well	(36527 was turned in automatically - 2015-07-15)
--			[136] = 36649,	-- Stronghold Alliance Shattrath	-- Also, ??36561 was set as well	(36560 was turned in automatically - 2015-07-15)
			-- 2015-07-15 available on Alleria were 135 136
--			[145] = 36648,	-- Stonefury Cliffs Alliance 36527 36549 36664
--			[149] = 36676,	-- Everbloom Wilds Alliance 36533 36552
--			[153] = 36678,	-- Mok'gol Watchpost Alliance
--			[154] = 36686,	-- The Pit Alliance
			-- 2015-07-30 Alleria 153 154
--			[157] = 36556,	-- Socrethar's Rise Alliance 36351 36664
--			[157] = 36680,	-- Socrethar's Rise Alliance 2015-07-28
--			[158] = 36686,	-- The Pit Alliance
			-- 2015-07-28 Alleria 157 158
--			[163] = 36682,	-- Shadowmoon Enclave Alliance
--			[164] = 36686,	-- The Pit Alliance
--			[193] = 36676,	-- Everbloom Wilds Alliance
--			[194] = 36685,	-- Shattrath City Alliance (Group)
			-- 2015-07-25 Alleria 193 194
--			[197] = 36675,	-- Magnarok Alliance
--			[198] = 36685,	-- Heart of Shattrath Alliance (Group)
			-- 2015-07-31 Alleria 197 198
--			[203] = 36648,	-- Stonefury Cliffs Alliance
--			[204] = 36685,	-- Shattrath Heart Alliance (Group)
			-- 2015-07-21 available on Alleria were 203 204
--			[215] = 36680,	-- Socrethar's Rise Alliance
--			[216] = 36649,	-- Shattrath Harbor Alliance
			-- 2015-07-29 Alleria 215 216
--			[220] = 36649,	-- Shattrath Harbor Alliance
--			[225] = 36678,	-- Mok'gol Watchpost Alliance
--			[226] = 36674,	-- Iron Siegeworks Alliance
			-- 2015-07-22 Alleria 225 226
--			[239] = 36677,	-- Broken Precipice Alliance
--			[240] = 36674,	-- Iron Siegeworks Alliance
			--	2015-07-18 available on Alleria were 239 240
--			[243] = 36648,	-- Stonefury Cliffs
--			[244] = 36684,	-- Ashran
			-- 2015-07-27 Alleria 243 244
--			[245] = 36683,	-- Skettis Alliance
--			[246] = 36684,	-- Ashran Alliance
			--	2015-07-20 available on Alleria were 245 246
			--	2015-08-01 Alleria -> 245 246
--			[247] = 36678,	-- Mok'gol Watchpost Alliance
--			[248] = 36684,	-- Ashran Alliance
			-- 2015-07-23 Alleria 247 248
--			[251] = 36680,	-- Socrethar's Rise Alliance
--			[252] = 36684,	-- Ashran Alliance
			-- 2015-07-17 available on Alleria were 251 252
--			[257] = 36675,	-- Magnarok Alliance
--			[258] = 36684,	-- Ashran Alliance
			--	2015-07-19 available on Alleria were 257 258
--			[259] = 36679,	-- Darktide Roost Alliance
--			[260] = 36684,	-- Ashran Alliance
			-- 2015-07-16 available on Alleria were 259 260
--			[395] = 37891,	-- Ironhold Harbor Alliance
--			[396] = 38045,	-- Zeth'Gol Alliance
			--	2015-07-18 available on Alleria were 395 396
			--	2015-07-29 Alleria -> 395 396
			--	2015-07-30 Alleria -> 395 396
--			[397] = 37891,	-- Ironhold Harbor (Tanaan) Alliance 37886 37887
--			[401] = 37891,	-- Ironhold Harbor (Tanaan) Alliance
--			[402] = 38440,	-- Fel Forge (Tanaan) Alliance
			-- 2015-08-01 Alleria 401 402
--			[413] = 37968,	--Temple of Sha'naar (Tanaan) Alliance
--			[414] = 38045,	-- Zeth'Gol (Tanaan) Alliance
			-- 2015-07-22 Alleria 413 414
--			[415] = 37968,	-- Temple of Sha'naar (Tanaan) Alliance 37887 37967 38021
--			[423] = 38045,	-- Assault on Zeth'Gol (Tanaan) Alliance 36799 38042
--			[424] = 38250,	-- Kra'nak (Tanaan) Alliance 37887 38010 37939	-- 2015-07-05
--			[429] = 38045,	-- Zeth'Gol Alliance	-- 2015-07-16
--			[430] = 38585,	-- Kil'jaeden Alliance	-- 2015-07-16
			--	2015-07-16 available on Alleria were 429 430
			--	2015-07-25 Alleria -> 429 430
--			[432] = 38440,	-- Fel Forge (Tanaan) Alliance 37887 38438	-- 2015-07-06
--			[433] = 38250,	-- Ruins of Kra'nak (Tanaan) Alliance
--			[434] = 38046,	-- Iron Front (Tanaan) Alliance
			-- 2015-07-28 Alleria 433 434
--			[437] = 38440,	-- Fel Forge (Tanaan) Alliance 37887 38438 -- also 2015-07-17
--			[438] = 38046,	-- Iron Front (Tanaan) Alliance	-- 2015-07-17
			-- 2015-07-17 available on Alleria were 437 438
			-- 2015-07-23 Alleria -> 437 438
--			[439] = 38440,	-- Fel Forge (Tanaan) Alliance 37887 38438
--			[440] = 38585,	-- Throne of Kil'jaeden (Tanaan) Alliance
			-- 2015-07-26 Alleria 439 440
--			[441] = 38046,	-- Iron Front (Tanaan) Alliance
--			[442] = 38585,	-- Throne of Kil'jaeden (Tanaan) Alliance 37887 38583
			-- 2015-07-19 available on Alleria were 441 442
			-- 2015-07-21 Alleria -> 441 442
			[478] = 39517,	-- Demon Hunter choosing Havoc
			[479] = 39518,	-- Demon Hunter choosing Vengeance
			[486] = 40374,	-- Demon Hunter choosing Kayn Sunfury
			[487] = 40375,	-- Demon Hunter choosing Atruis
			[490] = 40409,	-- Paladin choosing Retribution artifact ... also 42495
			[491] = 40582,	-- Warrior choosing Arms artifact
			[493] = 40581,	-- Warrior choosing Fury artifact
			[504] = 40621,	-- Night Elf Hunter choosing beast master artifact
			[523] = 40686,	-- Warlock choosing Affliction artifact
			[531] = 40702,	-- Druid choosing guardian artifact
			[533] = 40707,	-- Priest choosing Shadow artifact
			[546] = 40817,	-- Demon Hunter choosing Havoc artifact (Kayn, Night Elf)
			[547] = 40818,	-- Demon Hunter choosing Vengeance artifact
			[568] = 40842,	-- Rogue choosing Assassination artifact
			[569] = 40843,	-- Rogue choosing Outlaw artifact
			[570] = 40844,	-- Rogue choosing Subtelty artifact
			[585] = 41080,	-- Mage choosing Fire artifact
			[588] = 41329,	-- Shaman choosing Elemental artifact
			[629] = 43979,	-- Druid choosing Restoration artifact
			[645] = 44380,	-- Demon Hunter chossing Havoc artifact
			[667] = 44433,	-- Druid choosing Feral artifact
			[670] = 44444,	-- Druid choosing Balance artifact
			[783] = 48602,	-- Choosing Void Elf
			[784] = 48603,	-- Choosing Lightforged Draenei
--			[956] = xxxxx,	-- Choosing Duskwood from Hero's Call Board in Stormwind -- causes acceptance of 28564
			[1195] = 51570,	-- Choosing Zuldazar from Zandalar Mission Board on ship in Boralus
			[1196] = 51572,	-- Choosing Vol'dun from Zandalar Mission Board on ship in Boralus
			[1197] = 51571,	-- Choosing Nazmir from Zandalar Mission Board on ship in Boralus
			[1210] = 51802,	-- Choosing Stormsong Valley from Kul Tiras Mission Board on ship in Zuldazar
			},

		--	Internal Use.
		--	Routine used to hook the function for selecting the type of daily quests because we need to signal the
		--	system that the choice has been made without requiring the user to reload the UI.
		_SendQuestChoiceResponse = function(self, anId)
			local numericOption = tonumber(anId)
			if GrailDatabase.debug then
				local message = strformat("_SendQuestChoiceResponse chooses: %d coords: %s", numericOption, self:Coordinates())
				print(message)
				self:_AddTrackingMessage(message)
			end
			local questToComplete = self._SendQuestChoiceList[numericOption]
			if nil ~= questToComplete then
				self:_MarkQuestComplete(questToComplete, true)
			end
			self.origSendQuestChoiceResponseFunction(anId)
		end,

		SetMapAreaQuests = function(self, mapAreaId, title, questTable, useKey)
			self.indexedQuests[mapAreaId] = {}
			self.mapAreaMapping[mapAreaId] = title
			for key, value in pairs(questTable) do
				self:AddQuestToMapArea(useKey and key or value, mapAreaId)
			end
		end,

		--	The routine called when the /grail slash command is used.  For the most part the currently implemented commands are for testing only.
		--	@param frame The tooltip frame.
		--	@param msg The rest of the command line used with the /grail slash command.
		_SlashCommand = function(self, frame, msg)
			local executed = false
--			msg = strlower(msg)
			for option, value in pairs(self.slashCommandOptions) do
				if option == strsub(msg, 1, strlen(option)) then
					value['func'](msg, frame)
					executed = true
				end
			end
			if not executed then
				self.manuallyExecutingServerQuery = true
				print("|cFFFFFF00Grail|r initiating server database query")
				QueryQuestsCompleted()
			end			
		end,

		SpellPresent = function(self, soughtSpellId)
			soughtSpellId = tonumber(soughtSpellId)
			if nil == soughtSpellId then return false end
			local retval = false
			local i = 1
			while (false == retval) do
				local name,_,_,_,_,_,_,_,_,boaSpellId,spellId = UnitAura('player', i)
				if self.battleForAzeroth then
					spellId = boaSpellId
				end
				if name then
					if soughtSpellId == tonumber(spellId) then
						retval = true
					end
					i = i + 1
				else
					break
				end
			end
			return retval
		end,

		---
		--	Returns a bit mask indicating the status of the quest.
		--	@param questId The standard numeric questId representing the quest.
		--	@return An integer that should be interpreted as a bit mask containing information why the quest cannot be accepted (or 0 (or 2) if it can).
		StatusCode = function(self, questId)
			local retval = 0
			questId = tonumber(questId)

			--	Normally I would structure the code so there is only one return statement and the checks would
			--	result in an if/else structure that would make the code slightly less readable.  However, this
			--	code makes simple checks first and returns results immediately for ease of readability.

--self.statusCodeCalled = (self.statusCodeCalled or 0) + 1
--GrailDatabase["DEBUG"] = GrailDatabase["DEBUG"] or {}
--local stackString = debugstack()
--GrailDatabase["DEBUG"][stackString] = (GrailDatabase["DEBUG"][stackString] or 0) + 1
			if nil == questId then return self.bitMaskError end
			if nil ~= self.questStatuses[questId] then return self.questStatuses[questId] end

			if tContains(self.currentlyProcessingStatus, questId) then return 0 end
			-- We put this questId onto the stack to control infinite loops during processing.
			tinsert(self.currentlyProcessingStatus, questId)

			if self:DoesQuestExist(questId) then
--self.statusCodeComputed = (self.statusCodeComputed or 0) + 1
				if not self:MeetsRequirementClass(questId) then retval = retval + self.bitMaskClass end
				if not self:MeetsRequirementRace(questId) then retval = retval + self.bitMaskRace end
				if not self:MeetsRequirementGender(questId) then retval = retval + self.bitMaskGender end
				if not self:MeetsRequirementFaction(questId) then retval = retval + self.bitMaskFaction end
				-- Only set the completed if it actually could have been done based on class, race, gender and faction
				if 0 == retval and self:IsQuestCompleted(questId) then retval = retval + self.bitMaskCompleted end
				if self:IsRepeatable(questId) then retval = retval + self.bitMaskRepeatable end
				if self:IsDaily(questId) or self:IsWeekly(questId) or self:IsMonthly(questId) or self:IsYearly(questId) then retval = retval + self.bitMaskResettable end
				if self:HasQuestEverBeenCompleted(questId) then retval = retval + self.bitMaskEverCompleted end
				if self:IsResettableQuestCompleted(questId) then retval = retval + self.bitMaskResettableRepeatableCompleted end
				if nil ~= self:IsBugged(questId) then retval = retval + self.bitMaskBugged end
				if self:IsLowLevel(questId) then retval = retval + self.bitMaskLowLevel else tinsert(self.questStatusCache["V"], questId) end
				local inLog, inLogStatus = self:IsQuestInQuestLog(questId)
				if inLog and 0 == bitband(retval, self.bitMaskCompleted) then retval = retval + self.bitMaskInLog end
				if inLogStatus then
					if inLogStatus > 0 then retval = retval + self.bitMaskInLogComplete end
					if inLogStatus < 0 then retval = retval + self.bitMaskInLogFailed end
				end
-- TODO: Determine if there is an issue evaluating a prerequisite quest whose only prerequisites are P:D codes.  Quest 9622 has a requirement including 9570 which shows issues.
				if not self:MeetsPrerequisites(questId) and not (self:IsQuestCompleted(questId) and (self:_OnlyHasPrerequisites(questId, 'B') or self:_OnlyFailsPrerequisites(questId, 'K'))) then
					retval = retval + self.bitMaskPrerequisites
					retval = self:AncestorStatusCode(questId, retval)		-- !!!!! here is RAM usage !!!!!
				end
				-- Only set an invalidation if the quest is not already completed
				if 0 == bitband(retval, self.bitMaskCompleted) and self:IsInvalidated(questId) then retval = retval + self.bitMaskInvalidated end		-- !!!!! here is RAM usage !!!!!
				if not self:MeetsRequirementProfession(questId) then retval = retval + self.bitMaskProfession tinsert(self.questStatusCache["P"], questId) end
				if not self:MeetsRequirementReputation(questId) then retval = retval + self.bitMaskReputation end
				if self.questReputationRequirements[questId] then tinsert(self.questStatusCache["R"], questId) end
				if not self:MeetsRequirementHoliday(questId) then retval = retval + self.bitMaskHoliday end
				local success, levelToCompare, levelRequired, levelNotToExceed = self:MeetsRequirementLevel(questId, self.levelingLevel)
				-- Only set a level problem if the quest is not already completed
				if not success and 0 == bitband(retval, self.bitMaskCompleted) then
					if levelToCompare < levelRequired then retval = retval + self.bitMaskLevelTooLow tinsert(self.questStatusCache["L"], questId) end
					if levelToCompare > levelNotToExceed then retval = retval + self.bitMaskLevelTooHigh end
				end

			else
				retval = self.bitMaskNonexistent
			end

			self.questStatuses[questId] = retval

			-- First we invalidate the cache for all the quests whose status is suspect
			if nil ~= self.currentMortalIssues[questId] then
				for _,victimQuestId in pairs(self.currentMortalIssues[questId]) do
					self.questStatuses[victimQuestId] = nil
				end
				self.currentMortalIssues[questId] = nil
			end

			-- Now we remove ourselves from the stack of processing
			tremove(self.currentlyProcessingStatus)

			return retval
		end,

		_StatusCodeCallback = function(callbackType, questId, delay)
			questId = tonumber(questId)
			if nil ~= questId then
				if nil ~= Grail.questStatusCache then
					Grail.questStatuses[questId] = nil
--					if Grail.quests[questId] then Grail.quests[questId][7] = nil end
--					if Grail.quests[questId] then self:_MarkStatusValid(questId, true) end
					Grail:_CoalesceDelayedNotification("Status", delay or 0)
					Grail:_StatusCodeInvalidate(Grail.questStatusCache['D'][questId])
					Grail:_StatusCodeInvalidate(Grail.questStatusCache["I"][questId])
					Grail:_StatusCodeInvalidate(Grail.questStatusCache.Q[questId])
					Grail:_StatusCodeInvalidate(Grail.questStatusCache["F"][questId]) -- technically this should only be done for abandon, but the size will be so small it matters not
					Grail.questStatusCache.Q[questId] = {}	-- the list we nuked should be regenerated when descendants get their new StatusCode values

					-- Check to see whether this quest belongs to a group and deal with quests that rely on that group
					if Grail.questStatusCache.H[questId] then
						for _, group in pairs(Grail.questStatusCache.H[questId]) do
							Grail:_StatusCodeInvalidate(Grail.questStatusCache['W'][group])
						end
					end
				end
				if nil ~= Grail.quests[questId] then
					Grail:_StatusCodeInvalidate(Grail.quests[questId]['O'])
				end
			end
		end,

		_NPCLocationInvalidate = function(self, tableOfQuestIds)
			
		end,

		---
		--	
		_StatusCodeInvalidate = function(self, tableOfQuestIds, delay)
			if nil ~= tableOfQuestIds then
				for _, questId in pairs(tableOfQuestIds) do
					if nil ~= self.questStatuses[questId] then
						self.questStatuses[questId] = nil
--					if nil ~= self.quests[questId] and nil ~= self.quests[questId][7] then
--						self.quests[questId][7] = nil
--					if nil ~= self.quests[questId] and self:_StatusValid(questId) then
--						self:_MarkStatusValid(questId, true)
						self._StatusCodeCallback("bogus", questId, delay)	-- we want to invalidate the cache for descendants
						self:_CoalesceDelayedNotification("Status", delay or 0)
					end
				end
			end
		end,

		_SetAppend = function(self, t1, t2)
			if nil ~= t1 and nil ~= t2 then
				if type(t2) == "table" then
					for _, value in pairs(t2) do
						if not tContains(t1, value) then
							tinsert(t1, value)
						end
					end
				else
					if not tContains(t1, t2) then
						tinsert(t1, t2)
					end
				end
			end
			return t1
		end,

		_TableAppend = function(self, t1, t2)
			if nil ~= t1 and nil ~= t2 then
				if type(t2) == "table" then
					for _, value in pairs(t2) do
						tinsert(t1, value)
					end
				else
					tinsert(t1, t2)
				end
			end
			return t1
		end,

		_TableAppendCodes = function(self, t, master, codes)
			local tableToUse = t or {}
			if nil ~= codes and nil ~= master then
				for _, code in pairs(codes) do
					tableToUse = self:_TableAppend(tableToUse, master[code])
				end
			end
			return tableToUse
		end,

		_TableCopy = function(self, t)
			if nil == t then return nil end
			local retval = {}
			for k, v in pairs(t) do
				retval[k] = v
			end
			return retval
		end,

		_TableRemove = function(self, t, item)
			if nil == t or nil == item then return end
			if tContains(t, item) then
				local index, foundIndex = 1, nil
				while t[index] do
					if t[index] == item then
						foundIndex = index
					end
					index = index + 1
				end
				if foundIndex then
					tremove(t, foundIndex)
				end
			end
		end,

		-- Returns the map coordinates for the specified victim, defaulting to player
		-- if nothing else provided.  The coordinates are structured as
		-- 				mapId*:xx.xx,yy.yy
		-- where * is either nothing or the dungeon level in [] before BfA.  In BfA
		-- there will be multiple coordinates separated by a space if the current map
		-- is within others more than one step from a continent map.
		Coordinates = function(self, victim)
			victim = victim or "player"
			local retval = ""
			local spacer = ""
			if self.battleForAzeroth then
				local currentMapInfo = C_Map.GetMapInfo(Grail.GetCurrentMapAreaID())
				while currentMapInfo do
					local currentMapId = currentMapInfo.mapID
					local results = C_Map.GetPlayerMapPosition(currentMapId, victim)
					if results and results.x and results.y then
						retval = retval .. spacer .. strformat("%d:%.2f,%.2f", currentMapId, results.x * 100 , results.y * 100)
						spacer = " "
						currentMapInfo = C_Map.GetMapInfo(currentMapInfo.parentMapID)
						if nil ~= currentMapInfo and currentMapInfo.mapType == Enum.UIMapType.Continent then
							currentMapInfo = nil
						end
					else
						currentMapInfo = nil
					end
				end
				return retval
			else
				local x, y = self.GetPlayerMapPosition(victim)	-- cannot get target x,y since Blizzard disabled that and returns 0,0 all the time for it
				if nil == x then x, y = 0, 0 end
				local dungeonLevel = GetCurrentMapDungeonLevel and GetCurrentMapDungeonLevel() or 0
				local dungeonIndicator = (dungeonLevel > 0) and "["..dungeonLevel.."]" or ""
				return strformat("%d%s:%.2f,%.2f", Grail.GetCurrentMapAreaID(), dungeonIndicator, x*100, y*100)
			end
		end,

		---
		--	Returns information about the currently selected target.
		--	@return The localized name of the target or nil if no target.
		--	@return The npcId of the target unless the target is a world object in which one million is added to its value.
		--	@return The coordinates of the player (since the target coordinates cannot be determined) in the format mapId*:xx.xx,yy.yy, where * is nothing or the dungeon level in []
		--	@usage targetName, npcId, coordinates = Grail:TargetInformation()
		TargetInformation = function(self)
			local coordinates = nil
			local npcId, targetName = self:GetNPCId(true)
			if nil ~= npcId then
				coordinates = self:Coordinates()
			end
			return targetName, npcId, coordinates
		end,

		--	The routine called for event processing associated with the hidden tooltip.
		--	@param frame The tooltip frame.
		--	@param event The name of the event.
		--	@param ... Various parameters depending on the event.
		_Tooltip_OnEvent = function(self, frame, event, ...)
			if self.eventDispatch[event] then
				self.eventDispatch[event](self, frame, ...)
			end
		end,

		---
		--	Internal Use.
		--	Removes the callback from the observer queue for eventName.  Should not be called directly, but through the use of convenience API.
		--	@see UnregisterObserverQuestAbandon
		--	@see UnregisterObserverQuestAccept
		--	@see UnregisterObserverQuestComplete
		--	@see UnregisterObserverQuestStatus
		--	@param eventName The name of the event from which the callback should be removed.
		--	@param callback The callback that is to be removed.
		UnregisterObserver = function(self, eventName, callback)
			if nil ~= callback and nil ~= self.observers[eventName] then
				for i = 1, #(self.observers[eventName]), 1 do
					if callback == self.observers[eventName][i] then
						tremove(self.observers[eventName], i)
						break
					end
				end
			end
		end,

		---
		--	Remove the callback from receiving quest Abandon notifications.
		--	@param callback The callback that is to be removed.
		UnregisterObserverQuestAbandon = function(self, callback)
			self:UnregisterObserver("Abandon", callback)
		end,

		---
		--	Remove the callback from receiving quest Accept notifications.
		--	@param callback The callback that is to be removed.
		UnregisterObserverQuestAccept = function(self, callback)
			self:UnregisterObserver("Accept", callback)
		end,

		---
		--	Remove the callback from receiving quest Completion notifications.
		--	@param callback The callback that is to be removed.
		UnregisterObserverQuestComplete = function(self, callback)
			self:UnregisterObserver("Complete", callback)
		end,

		---
		--	Remove the callback from receiving quest Status notifications.
		--	@param callback The callback that is to be removed.
		UnregisterObserverQuestStatus = function(self, callback)
			self:UnregisterObserver("Status", callback)
		end,

		--	Updates the NewQuests with data if the quest does not already exist in the internal database or adds the npcCode to the NewQuests data if it does not already exist.
		--	@param questId The standard numeric questId representing a quest.
		--	@param questTitle The localized name of the quest.
		--	@param npcId The standard numeric npcId representing an NPC.
		--	@param isDaily Indicates whether the quest is a daily quest.
		--	@param npcCode A string value 'A:' or 'T:' indicating whether the NPC is for accepting a quest or turning one in.
		--	@param version A version string based on the current internal database versions.
		_UpdateQuestDatabase = function(self, questId, questTitle, npcId, isDaily, npcCode, version, kCode)
			questId = tonumber(questId)
			npcId = tonumber(npcId)
			if nil == questId or nil == npcId then return end
			local needToWork = false
			if not self:DoesQuestExist(questId) then
				needToWork = true
			else
				if 'A' == npcCode then
					needToWork = not self:_GoodNPCAccept(questId, npcId)
				end
				if 'T' == npcCode then
					needToWork = not self:_GoodNPCTurnin(questId, npcId)
				end
			end
			if needToWork then
				GrailDatabase.learned = GrailDatabase.learned or {}
				GrailDatabase.learned.QUEST = GrailDatabase.learned.QUEST or {}
				local currentLine = GrailDatabase.learned.QUEST[questId]
--				local needToAddQuestName = (questTitle ~= "No Title Stored" and self:QuestName(questId) ~= questTitle)
				local completeNPCCode = npcCode .. ':' .. npcId
				local newLine = ''
				local possibleLevel = nil ~= kCode and tonumber(strsub(kCode, 2, 4)) or nil
				if nil == currentLine then
					local spacer = ''
					if nil ~= kCode and nil ~= possibleLevel and possibleLevel < 100 then
						newLine = kCode
						spacer = ' '
					end
					if nil ~= completeNPCCode then
						newLine = newLine .. spacer .. completeNPCCode
					end
					self.questCodes[questId] = newLine
				else
					local questBits = { strsplit('|', currentLine) }
					self.questCodes[questId] = self.questCodes[questId] or ''
					for i = 1, #questBits do
						if 1 == i then
							local codeSpacer = ''
							local codes = { strsplit(' ', questBits[i]) }
							local foundK, foundNPC = false, false
							for j = 1, #codes do
								local matchFound = false
								if not foundK then
									foundK = (codes[j] == kCode)
									if foundK then
										matchFound = true
									end
								end
								if not foundNPC then
									foundNPC = (codes[j] == completeNPCCode)
									if foundNPC then
										matchFound = true
									end
								end
								if not matchFound then
									newLine = newLine .. codeSpacer .. codes[j]
									codeSpacer = ' '
								end
							end
							if not foundK and nil ~= kCode and nil ~= possibleLevel and possibleLevel < 100 then
								newLine = newLine .. codeSpacer .. kCode
								codeSpacer = ' '
								self.questCodes[questId] = self.questCodes[questId] .. ' ' .. kCode
							end
							if not foundNPC and nil ~= completeNPCCode then
								newLine = newLine .. codeSpacer .. completeNPCCode
								codeSpacer = ' '
								self.questCodes[questId] = self.questCodes[questId] .. ' ' .. completeNPCCode
							end
						else
--							local loc, localizedName = strsplit(':', questBits[i])
--							if loc ~= self.playerLocale then
--								newLine = newLine .. '|' .. questBits[i]
--							else
--								if localizedName == questTitle then
--									needToAddQuestName = false
--								end
--							end
						end
					end
				end
--				if needToAddQuestName then
--					newLine = newLine .. '|' .. self.playerLocale .. ':' .. questTitle
--					self.questNames[questId] = questTitle
--				end
				self.quests[questId] = self.quests[questId] or {}
				GrailDatabase.learned.QUEST[questId] = newLine
			end
		end,

		--	Updates the time until quests reset based on the GetQuestResetTime() API.  A side-effect is that if the reset time is past QueryQuestsCompleted() will be called.
		_UpdateQuestResetTime = function(self)
			local seconds = GetQuestResetTime()
			if seconds > self.questResetTime then
				if not GrailDatabase.silent then
					print("|cFFFF0000Grail|r automatically initializing a server query for completed quests")
				end
				QueryQuestsCompleted()
			end
			self.questResetTime = seconds
		end,

		--	Updates the NewNPCs with data if the NPC does not already exist in the internal database.
		--	@param targetName The localized name of the NPC.
		--	@param npcId The standard numeric npcId representing an NPC.
		--	@param coordinates The zone coordinates of the player.
		--	@param version A version string based on the current internal database versions.
		_UpdateTargetDatabase = function(self, targetName, npcId, coordinates, version)
			return self:_NPCToUse(npcId, coordinates)
		end,

		_UpdateTrackingObserver = function(self)
			if GrailDatabase.tracking then
				self:RegisterObserverQuestAbandon(Grail._AddTrackingCallback)
				self:RegisterObserverQuestAccept(Grail._AddTrackingCallback)
				self:RegisterObserverQuestComplete(Grail._AddTrackingCallback)
			else
				self:UnregisterObserverQuestAbandon(Grail._AddTrackingCallback)
				self:UnregisterObserverQuestAccept(Grail._AddTrackingCallback)
				self:UnregisterObserverQuestComplete(Grail._AddTrackingCallback)
			end
		end,

		}

local locale = GetLocale()
local me = Grail

if locale == "deDE" then
	me.bodyGuardLevel = { 'Leibwächter', 'Treuer Leibwächter', 'Persönlicher Flügelmann' }
	me.friendshipLevel = { 'Fremder', 'Bekannter', 'Kumpel', 'Freund', 'guter Freund', 'bester Freund' }

	me.holidayMapping = { ['A'] = 'Liebe liegt in der Luft', ['B'] = 'Braufest', ['C'] = "Kinderwoche", ['D'] = 'Tag der Toten', ['F'] = 'Dunkelmond-Jahrmarkt', ['H'] = 'Erntedankfest', ['K'] = "Angelwettstreit der Kalu'ak", ['L'] = 'Mondfest', ['M'] = 'Sonnenwendfest', ['N'] = 'Nobelgarten', ['P'] = "Piratentag", ['U'] = 'Neujahr', ['V'] = 'Winterhauch', ['W'] = "Schlotternächte", ['X'] = 'Anglerwettbewerb im Schlingendorntal', ['Y'] = "Die Pilgerfreuden", ['Z'] = "Weihnachtswoche", ['a'] = 'Bonusereignis: Apexis', ['b'] = 'Bonusereignis: Arenascharmützel', ['c'] = 'Bonusereignis: Schlachtfelder', ['d'] = 'Bonusereignis: Draenordungeons', ['e'] = 'Bonusereignis: Haustierkämpfe', ['f'] = 'Bonusereignis: Zeitwanderungsdungeons', }

	me.professionMapping = { ['A'] = 'Alchemie', ['B'] = 'Schmiedekunst', ['C'] = 'Kochkunst', ['E'] = 'Verzauberkunst', ['F'] = 'Angeln', ['H'] = 'Kräuterkunde', ['I'] = 'Inschriftenkunde', ['J'] = 'Juwelenschleifen', ['L'] = 'Lederverarbeitung', ['M'] = 'Bergbau', ['N'] = 'Ingenieurskunst', ['R'] = 'Reiten', ['S'] = 'Kürschnerei', ['T'] = 'Schneiderei', ['X'] = 'Archäologie', ['Z'] = 'Erste Hilfe', }

	local G = me.races
	G['H'][2] = 'Mensch'
	G['H'][3] = 'Mensch'
	G['F'][2] = 'Zwerg'
	G['F'][3] = 'Zwerg'
	G['E'][2] = 'Nachtelf'
	G['E'][3] = 'Nachtelfe'
	G['N'][2] = 'Gnom'
	G['N'][3] = 'Gnom'
		G['D'][2] = 'Draenei'
		G['D'][3] = 'Draenei'
		G['W'][2] = 'Worgen'
		G['W'][3] = 'Worgen'
		G['O'][2] = 'Orc'
		G['O'][3] = 'Orc'
	G['U'][2] = 'Untoter'
	G['U'][3] = 'Untote'
		G['T'][2] = 'Tauren'
		G['T'][3] = 'Tauren'
		G['L'][2] = 'Troll'
		G['L'][3] = 'Troll'
	G['B'][2] = 'Blutelf'
	G['B'][3] = 'Blutelfe'
		G['G'][2] = 'Goblin'
		G['G'][3] = 'Goblin'
		G['A'][2] = 'Pandaren'
		G['A'][3] = 'Pandaren'
elseif locale == "esES" then
	me.bodyGuardLevel = { 'Guardaespaldas', 'Escolta leal', 'Compañero del alma' }
	me.friendshipLevel = { 'Extraño', 'Conocido', 'Colega', 'Amigo', 'Buen amigo', 'Mejor amigo' }

	me.holidayMapping = { ['A'] = 'Amor en el aire', ['B'] = 'Fiesta de la cerveza', ['C'] = "Semana de los Niños", ['D'] = 'Festividad de los Muertos', ['F'] = 'Feria de la Luna Negra', ['H'] = 'Festival de la Cosecha', ['K'] = "Competición de pesca Kalu'ak", ['L'] = 'Festival Lunar', ['M'] = 'Festival de Fuego del Solsticio de Verano', ['N'] = 'Jardín Noble', ['P'] = "Día de los Piratas", ['U'] = 'Nochevieja', ['V'] = 'El festín del Festival del Invierno', ['W'] = "Halloween", ['X'] = 'Concurso de Pesca', ['Y'] = "Generosidad del Peregrino", ['Z'] = "Semana navideña", ['a'] = 'Evento de bonificación apexis', ['b'] ='Evento de bonificación de escaramuza de arena', ['c'] = 'Evento de bonificación de campo de batalla', ['d'] = 'Evento de mazmorra de Draenor', ['e'] = 'Evento de bonificación de duelo de mascotas', ['f'] = 'Evento de mazmorra de Paseo en el tiempo', }

	me.professionMapping = { ['A'] = 'Alquimia', ['B'] = 'Herrería', ['C'] = 'Cocina', ['E'] = 'Encantamiento', ['F'] = 'Pesca', ['H'] = 'Hebalismo', ['I'] = 'Inscripción', ['J'] = 'Joyería', ['L'] = 'Peletería', ['M'] = 'Minería', ['N'] = 'Ingeniería', ['R'] = 'Equitación', ['S'] = 'Desuello', ['T'] = 'Sastrería', ['X'] = 'Arqueología', ['Z'] = 'Primeros auxilios', }

	local G = me.races
	G['H'][2] = 'Humano'
	G['H'][3] = 'Humana'
	G['F'][2] = 'Enano'
	G['F'][3] = 'Enana'
	G['E'][2] = 'Elfo de la noche'
	G['E'][3] = 'Elfa de la noche'
	G['N'][2] = 'Gnomo'
	G['N'][3] = 'Gnoma'
	G['W'][2] = 'Huargen'
	G['W'][3] = 'Huargen'
	G['O'][2] = 'Orco'
	G['O'][3] = 'Orco'
	G['U'][2] = 'No-muerto'
	G['U'][3] = 'No-muerta'
	G['L'][2] = 'Trol'
	G['L'][3] = 'Trol'
	G['B'][2] = 'Elfo de sangre'
	G['B'][3] = 'Elfa de sangre'
elseif locale == "esMX" then
	me.bodyGuardLevel = { 'Guardaespaldas', 'De confianza', 'Copiloto personal' }
	me.friendshipLevel = { 'Extraño', 'Conocido', 'Colega', 'Amigo', 'Buen amigo', 'Mejor amigo' }

 	me.holidayMapping = { ['A'] = 'Amor en el Aire', ['B'] = 'Fiesta de la Cerveza', ['C'] = "Semana de los Niños", ['D'] = 'Día de los Muertos', ['F'] = 'Feria de la Luna Negra', ['H'] = 'Festival de la Cosecha', ['K'] = "Competición de pesca Kalu'ak", ['L'] = 'Festival Lunar', ['M'] = 'Festival de Fuego del Solsticio de Verano', ['N'] = 'Jardín Noble', ['P'] = "Día de los Piratas", ['U'] = 'Nochevieja', ['V'] = 'Festival del Invierno', ['W'] = "Halloween", ['X'] = 'Concurso de Pesca', ['Y'] = "Generosidad del Peregrino", ['Z'] = "Semana navideña", ['a'] = 'Evento de ápices con bonificación', ['b'] ='Evento de refriegas de arena con bonificación', ['c'] = 'Evento de campos de batalla con bonificación', ['d'] = 'Evento de calabozo de Draenor', ['e'] = 'Evento de duelo de mascotas con bonificación', ['f'] = 'Evento de calabozo de cronoviaje', }

	me.professionMapping = { ['A'] = 'Alquimia', ['B'] = 'Herrería', ['C'] = 'Cocina', ['E'] = 'Encantamiento', ['F'] = 'Pesca', ['H'] = 'Hebalismo', ['I'] = 'Inscripción', ['J'] = 'Joyería', ['L'] = 'Peletería', ['M'] = 'Minería', ['N'] = 'Ingeniería', ['R'] = 'Equitación', ['S'] = 'Desuello', ['T'] = 'Sastrería', ['X'] = 'Arqueología', ['Z'] = 'Primeros auxilios', }

	local G = me.races
	G['H'][2] = 'Humano'
	G['H'][3] = 'Humana'
	G['F'][2] = 'Enano'
	G['F'][3] = 'Enana'
	G['E'][2] = 'Elfo de la noche'
	G['E'][3] = 'Elfa de la noche'
	G['N'][2] = 'Gnomo'
	G['N'][3] = 'Gnoma'
	G['W'][2] = 'Huargen'
	G['W'][3] = 'Huargen'
	G['O'][2] = 'Orco'
	G['O'][3] = 'Orco'
	G['U'][2] = 'No-muerto'
	G['U'][3] = 'No-muerta'
	G['L'][2] = 'Trol'
	G['L'][3] = 'Trol'
	G['B'][2] = 'Elfo de sangre'
	G['B'][3] = 'Elfa de sangre'
elseif locale == "frFR" then
	me.bodyGuardLevel = { 'Garde du corps', 'Garde personnel', 'Bras droit' }
	me.friendshipLevel = { 'Étranger', 'Connaissance', 'Camarade', 'Ami', 'Bon ami', 'Meilleur ami' }

	me.holidayMapping = { ['A'] = "De l'amour dans l'air", ['B'] = 'Fête des Brasseurs', ['C'] = "Semaine des enfants", ['D'] = 'Jour des morts', ['F'] = 'Foire de Sombrelune', ['H'] = 'Fête des moissons', ['K'] = "Tournoi de pêche kalu'ak", ['L'] = 'Fête lunaire', ['M'] = "Fête du Feu du solstice d'été", ['N'] = 'Le Jardin des nobles', ['P'] = "Jour des pirates", ['U'] = 'Nouvel an', ['V'] = "Voile d'hiver", ['W'] = "Sanssaint", ['X'] = 'Concours de pêche de Strangleronce', ['Y'] = "Bienfaits du pèlerin", ['Z'] = "Vacances de Noël", ['a'] = 'Évènement bonus Apogides', ['b'] ='Évènement bonus Escarmouches en arène', ['c'] = 'Évènement bonus Champs de bataille', ['d'] = 'Évènement Donjon de Draenor', ['e'] = 'Évènement bonus Combats de mascottes', ['f'] = 'Évènement Donjon des Marcheurs du temps', }

	me.professionMapping = { ['A'] = 'Alchimie', ['B'] = 'Forge', ['C'] = 'Cuisine', ['E'] = 'Enchantement', ['F'] = 'Pêche', ['H'] = 'Herboristerie', ['I'] = 'Calligraphie', ['J'] = 'Joaillerie', ['L'] = 'Travail du cuir', ['M'] = 'Minage', ['N'] = 'Ingénierie', ['R'] = 'Monte', ['S'] = 'Dépeçage', ['T'] = 'Couture', ['X'] = 'Archéologie', ['Z'] = 'Secourisme', }

	local G = me.races
	G['H'][2] = 'Humain'
	G['H'][3] = 'Humaine'
	G['F'][2] = 'Nain'
	G['F'][3] = 'Naine'
	G['E'][2] = 'Elfe de la nuit'
	G['E'][3] = 'Elfe de la nuit'
	G['D'][2] = 'Draeneï'
	G['D'][3] = 'Draeneï'
	G['O'][3] = 'Orque'
	G['U'][2] = 'Mort-vivant'
	G['U'][3] = 'Morte-vivante'
	G['T'][3] = 'Taurène'
	G['L'][3] = 'Trollesse'
	G['B'][2] = 'Elfe de sang'
	G['B'][3] = 'Elfe de sang'
	G['G'][2] = 'Gobelin'
	G['G'][3] = 'Gobeline'

elseif locale == "itIT" then
	me.bodyGuardLevel = { 'Guardia del Corpo', 'Guardia Fidata', 'Scorta Personale' }
	me.friendshipLevel = { 'Estraneo', 'Conoscente', 'Compagno', 'Amico', 'Amico Intimo', 'Miglior Amico' }

me.holidayMapping = {
    ['A'] = "Amore nell'Aria",
    ['B'] = 'Festa della Birra',
    ['C'] = "Settimana dei Bambini",
    ['D'] = 'Giorno dei Morti',
    ['F'] = 'Fiera di Lunacupa',
    ['H'] = 'Sagra del Raccolto',
	['K'] = "Gara di pesca dei Kalu'ak",
    ['L'] = 'Celebrazione della Luna',
    ['M'] = 'Fuochi di Mezza Estate',
    ['N'] = 'Festa di Nobiluova',
    ['P'] = "Giorno dei Pirati",
    ['U'] = 'New Year', -- LOCALIZE
    ['V'] = 'Vigilia di Grande Inverno',
    ['W'] = "Veglia delle Ombre",
    ['X'] = 'Gara di Pesca a Rovotorto',
    ['Y'] = "Ringraziamento del Pellegrino",
    ['Z'] = "Settimana di Natale",
['a'] = 'Evento bonus: Cristalli Apexis', ['b'] ='Evento bonus: schermaglie in arena', ['c'] = 'Evento bonus: campi di battaglia', ['d'] = 'Evento bonus: spedizioni di Draenor', ['e'] = 'Evento bonus: scontri tra mascotte', ['f'] = 'Evento bonus: Viaggi nel Tempo',     }

me.professionMapping = {
    ['A'] = 'Alchimia',
    ['B'] = 'Forgiatura',
    ['C'] = 'Cucina',
    ['E'] = 'Incantamento',
    ['F'] = 'Pesca',
    ['H'] = 'Erbalismo',
    ['I'] = 'Runografia',
    ['J'] = 'Oreficeria',
    ['L'] = 'Conciatura',
    ['M'] = 'Estrazione',
    ['N'] = 'Ingegneria',
    ['R'] = 'Riding', -- LOCALIZE
    ['S'] = 'Scuoiatura',
    ['T'] = 'Sartoria',
    ['X'] = 'Archeologia',
    ['Z'] = 'Primo Soccorso',
    }

	local G = me.races
	G['H'][2] = 'Umano'
	G['H'][3] = 'Umana'
	G['F'][2] = 'Nano'
	G['F'][3] = 'Nana'
	G['E'][2] = 'Elfo della Notte'
	G['E'][3] = 'Elfa della Notte'
	G['N'][2] = 'Gnomo'
	G['N'][3] = 'Gnoma'
	G['O'][2] = 'Orco'
	G['O'][3] = 'Orchessa'
	G['U'][2] = 'Non Morto'
	G['U'][3] = 'Non Morta'
	G['B'][2] = 'Elfo del Sangue'
	G['B'][3] = 'Elfa del Sangue'

elseif locale == "koKR" then
	me.bodyGuardLevel = { '경호원', '믿음직스러운 경호원', '개인 호위무사' }
	me.friendshipLevel = { '이방인', '지인', '동료', '친구', '좋은 친구', '가장 친한 친구' }

	me.holidayMapping = { ['A'] = '온누리에 사랑을', ['B'] = '가을 축제', ['C'] = "어린이 주간", ['D'] = '망자의 날', ['F'] = '다크문 축제', ['H'] = '추수절', ['K'] = '칼루아크 낚시 대회', ['L'] = '달의 축제', ['M'] = '한여름 불꽃축제', ['N'] = '귀족의 정원', ['P'] = "해적의 날", ['U'] = '새해맞이 전야제', ['V'] = '겨울맞이 축제', ['W'] = "할로윈 축제", ['X'] = '가시덤불 골짜기 낚시왕 선발대회', ['Y'] = "순례자의 감사절", ['Z'] = "한겨울 축제 주간", ['a'] = '에펙시스 보너스 이벤트', ['b'] ='투기장 연습 전투 보너스 이벤트', ['c'] = '전장 보너스 이벤트', ['d'] = '드레노어 던전 이벤트', ['e'] = '애완동물 대전 보너스 이벤트', ['f'] = '시간여행 던전 이벤트', }

	me.professionMapping = { ['A'] = '연금술', ['B'] = '대장기술', ['C'] = '요리', ['E'] = '마법부여', ['F'] = '낚시', ['H'] = '약초채집', ['I'] = '주문각인', ['J'] = '보석세공', ['L'] = '가죽세공', ['M'] = '채광', ['N'] = '기계공학', ['R'] = '탈것 숙련', ['S'] = '무두질', ['T'] = '재봉술', ['X'] = '고고학', ['Z'] = '응급치료', }

	local G = me.races
	G['H'][2] = '인간'
	G['H'][3] = '인간'
	G['F'][2] = '드워프'
	G['F'][3] = '드워프'
	G['E'][2] = '나이트 엘프'
	G['E'][3] = '나이트 엘프'
	G['N'][2] = '노움'
	G['N'][3] = '노움'
		G['D'][2] = '드레나이'
		G['D'][3] = '드레나이'
		G['W'][2] = '늑대인간'
		G['W'][3] = '늑대인간'
		G['O'][2] = '오크'
		G['O'][3] = '오크'
	G['U'][2] = '언데드'
	G['U'][3] = '언데드'
		G['T'][2] = '타우렌'
		G['T'][3] = '타우렌'
		G['L'][2] = '트롤'
		G['L'][3] = '트롤'
	G['B'][2] = '블러드 엘프'
	G['B'][3] = '블러드 엘프'
		G['G'][2] = '고블린'
		G['G'][3] = '고블린'
		G['A'][2] = '판다렌'
		G['A'][3] = '판다렌'

elseif locale == "ptBR" then
	me.bodyGuardLevel = { 'Guarda-costas', 'Guarda-costas de Confiança', 'Copiloto Pessoal' }
	me.friendshipLevel = { 'Estranho', 'Conhecido', 'Camarada', 'Amigo', 'Bom Amigo', 'Grande Amigo' }

me.holidayMapping = { ['A'] = "O Amor Está No Ar", ['B'] = 'CervaFest', ['C'] = "Semana das Crianças", ['D'] = 'Dia dos Mortos', ['F'] = 'Feira de Negraluna', ['H'] = 'Festival da Colheita', ['K'] = "Campeonato de Pesca dos Kalu'ak", ['L'] = 'Festival da Lua', ['M'] = "Festival do Fogo do Solsticio", ['N'] = 'Jardinova', ['P'] = "Dia dos Piratas", ['U'] = 'New Year', ['V'] = "Festa do Véu de Inverno", ['W'] = "Noturnália", ['X'] = 'Stranglethorn Fishing Extravaganza', ['Y'] = "Festa da Fartura", ['Z'] = "Semana Natalina", ['a'] = 'Evento Bônus de Apexis', ['b'] ='Evento Bônus de Escaramuças da Arena', ['c'] = 'Evento Bônus de Campos de Batalha', ['d'] = 'Evento das Masmorras de Draenor', ['e'] = 'Evento Bônus de Batalha de Mascotes', ['f'] = 'Evento das Masmorras de Caminhada Temporal', }

me.professionMapping = {
	['A'] = 'Alquimia',
	['B'] = 'Ferraria',
	['C'] = 'Culinária',
	['E'] = 'Encantamento',
	['F'] = 'Paseca',
	['H'] = 'Herborismo',
	['I'] = 'Escrivania',
	['J'] = 'Joalheria',
	['L'] = 'Couraria',
	['M'] = 'Mineração',
	['N'] = 'Engenharia',
	['R'] = 'Montaria',
	['S'] = 'Esfolamentoa',
	['T'] = 'Alfaiataria',
	['X'] = 'Arqueologia',
	['Z'] = 'Primeiros Socorros',
	}

	local G = me.races
	G['H'][2] = 'Humano'
	G['H'][3] = 'Humana'
	G['F'][2] = 'Anão'
	G['F'][3] = 'Anã'
	G['E'][2] = 'Elfo Noturno'
	G['E'][3] = 'Elfa Noturna'
	G['N'][2] = 'Gnomo'
	G['N'][3] = 'Gnomida'
	G['D'][3] = 'Draenaia'
	G['W'][3] = 'Worgenin'
	G['O'][3] = 'Orquisa'
	G['U'][2] = 'Morto-vivo'
	G['U'][3] = 'Morta-viva'
	G['T'][3] = 'Taurena'
	G['L'][3] = 'Trolesa'
	G['B'][2] = 'Elfo Sangrento'
	G['B'][3] = 'Elfa Sangrenta'
	G['G'][3] = 'Goblina'

elseif locale == "ruRU" then
	me.bodyGuardLevel = { 'Телохранитель', 'Доверенный боец', 'Боевой товарищ' }
	me.friendshipLevel = { 'Незнакомец', 'Знакомый', 'Приятель', 'Друг', 'Хороший друг', 'Лучший друг' }

	me.holidayMapping = { ['A'] = 'Любовная лихорадка', ['B'] = 'Хмельной фестиваль', ['C'] = "Детская неделя", ['D'] = 'День мертвых', ['F'] = 'Ярмарка Новолуния', ['H'] = 'Неделя урожая', ['K'] = "Калуакское рыбоборье", ['L'] = 'Лунный фестиваль', ['M'] = 'Огненный солнцеворот', ['N'] = 'Сад чудес', ['P'] = "День пирата", ['U'] = 'Канун Нового Года', ['V'] = 'Зимний Покров', ['W'] = "Тыквовин", ['X'] = 'Рыбная феерия Тернистой долины', ['Y'] = "Пиршество странников", ['Z'] = "Рождественская неделя", ['a'] = 'Событие: бонус к апекситовым кристаллам', ['b'] ='Событие: бонус за стычки на арене', ['c'] = 'Событие: бонус на полях боя', ['d'] = 'Событие: подземелья Дренора', ['e'] = 'Событие: бонус за битвы питомцев', ['f'] = 'Событие: путешествие во времени по подземельям', }

	me.professionMapping = { ['A'] = 'Алхимия', ['B'] = 'Кузнечное дело', ['C'] = 'Кулинария', ['E'] = 'Наложение чар', ['F'] = 'Рыбная ловля', ['H'] = 'Травничество', ['I'] = 'Начертание', ['J'] = 'Ювелирное дело', ['L'] = 'Кожевничество', ['M'] = 'Горное дело', ['N'] = 'Механика', ['R'] = 'Верховая езда', ['S'] = 'Снятие шкур', ['T'] = 'Портняжное дело', ['X'] = 'Археология', ['Z'] = 'Первая помощь', }

	local G = me.races
	G['H'][2] = 'Человек'
	G['H'][3] = 'Человек'
	G['F'][2] = 'Дворф'
	G['F'][3] = 'Дворф'
	G['E'][2] = 'Ночной эльф'
	G['E'][3] = 'Ночная эльфийка'
	G['N'][2] = 'Гном'
	G['N'][3] = 'Гном'
	G['D'][2] = 'Дреней'
	G['D'][3] = 'Дреней'
	G['W'][2] = 'Ворген'
	G['W'][3] = 'Ворген'
	G['O'][2] = 'Орк'
	G['O'][3] = 'Орк'
	G['U'][2] = 'Нежить'
	G['U'][3] = 'Нежить'
	G['T'][2] = 'Таурен'
	G['T'][3] = 'Таурен'
	G['L'][2] = 'Тролль'
	G['L'][3] = 'Тролль'
	G['B'][2] = 'Эльф крови'
	G['B'][3] = 'Эльфийка крови'
	G['G'][2] = 'Гоблин'
	G['G'][3] = 'Гоблин'
	G['A'][2] = 'Пандарен'
	G['A'][3] = 'Пандарен'

elseif locale == "zhCN" then
	me.bodyGuardLevel = { '保镖', '贴身保镖', '亲密搭档' }
	me.friendshipLevel = { 'Stranger', 'Acquaintance', 'Buddy', 'Friend', 'Good Friend', '挚友' }
	me.holidayMapping = { ['A'] = '情人节', ['B'] = '美酒节', ['C'] = "儿童周", ['D'] = '死人节', ['F'] = '暗月马戏团', ['H'] = '收获节', ['K'] = "Tournoi de pêche kalu'ak", ['L'] = '春节', ['M'] = '仲夏火焰节', ['N'] = '复活节', ['P'] = "海盗日", ['U'] = '除夕夜', ['V'] = '冬幕节', ['W'] = "万圣节", ['X'] = '荆棘谷钓鱼大赛', ['Y'] = "感恩节", ['Z'] = "圣诞周", ['a'] = '埃匹希斯假日活动', ['b'] ='竞技场练习赛假日活动', ['c'] = '战场假日活动', ['d'] = '德拉诺地下城活动', ['e'] = '宠物对战假日活动', ['f'] = '时空漫游地下城活动', }

	me.professionMapping = { ['A'] = '炼金术', ['B'] = '锻造', ['C'] = '烹饪', ['E'] = '附魔', ['F'] = '钓鱼', ['H'] = '草药学', ['I'] = '铭文', ['J'] = '珠宝加工', ['L'] = '制皮', ['M'] = '采矿', ['N'] = '工程学', ['R'] = '骑术', ['S'] = '剥皮', ['T'] = '裁缝', ['X'] = '考古学', ['Z'] = '急救', }

	local G = me.races
	G['H'][2] = '人类'
	G['H'][3] = '人类'
	G['F'][2] = '矮人'
	G['F'][3] = '矮人'
	G['E'][2] = '暗夜精灵'
	G['E'][3] = '暗夜精灵'
	G['N'][2] = '侏儒'
	G['N'][3] = '侏儒'
	G['D'][2] = '德莱尼'
	G['D'][3] = '德莱尼'
	G['W'][2] = '狼人'
	G['W'][3] = '狼人'
	G['O'][2] = '兽人'
	G['O'][3] = '兽人'
	G['U'][2] = '亡灵'
	G['U'][3] = '亡灵'
	G['T'][2] = '牛头人'
	G['T'][3] = '牛头人'
	G['L'][2] = '巨魔'
	G['L'][3] = '巨魔'
	G['B'][2] = '血精灵'
	G['B'][3] = '血精灵'
	G['G'][2] = '地精'
	G['G'][3] = '地精'
	G['A'][2] = '熊猫人'
	G['A'][3] = '熊猫人'

elseif locale == "zhTW" then
	me.bodyGuardLevel = { '保鏢', '信任的保鑣', '個人的搭檔' }
	me.friendshipLevel = { '陌生人', '熟識', '夥伴', '朋友', '好朋友', '最好的朋友' }

	me.holidayMapping = { ['A'] = '愛就在身邊', ['B'] = '啤酒節', ['C'] = "兒童週", ['D'] = '亡者節', ['F'] = '暗月馬戲團', ['H'] = '收穫節', ['K'] = "卡魯耶克釣魚大賽", ['L'] = '新年慶典', ['M'] = '仲夏火焰節慶', ['N'] = '貴族花園', ['P'] = "海賊日", ['U'] = '除夕夜', ['V'] = '冬幕節', ['W'] = "萬鬼節", ['X'] = '荊棘谷釣魚大賽', ['Y'] = "旅人豐年祭", ['Z'] = "聖誕週", ['a'] = '頂尖獎勵事件', ['b'] ='競技場練習戰獎勵事件', ['c'] = '戰場獎勵事件', ['d'] = '德拉諾地城事件', ['e'] = '寵物對戰獎勵事件', ['f'] = '時光漫遊地城事件', }

	me.professionMapping = { ['A'] = '鍊金術', ['B'] = '鍛造', ['C'] = '烹飪', ['E'] = '附魔', ['F'] = '釣魚', ['H'] = '草藥學', ['I'] = '銘文學', ['J'] = '珠寶設計', ['L'] = '製皮', ['M'] = '採礦', ['N'] = '工程學', ['R'] = '騎術', ['S'] = '剝皮', ['T'] = '裁縫', ['X'] = '考古學', ['Z'] = '急救', }

	local G = me.races
	G['H'][2] = '人類'
	G['H'][3] = '人類'
	G['F'][2] = '矮人'
	G['F'][3] = '矮人'
	G['E'][2] = '夜精靈'
	G['E'][3] = '夜精靈'
	G['N'][2] = '地精'
	G['N'][3] = '地精'
	G['D'][2] = '德萊尼'
	G['D'][3] = '德萊尼'
	G['W'][2] = '狼人'
	G['W'][3] = '狼人'
	G['O'][2] = '獸人'
	G['O'][3] = '獸人'
	G['U'][2] = '不死族'
	G['U'][3] = '不死族'
	G['T'][2] = '牛頭人'
	G['T'][3] = '牛頭人'
	G['L'][2] = '食人妖'
	G['L'][3] = '食人妖'
	G['B'][2] = '血精靈'
	G['B'][3] = '血精靈'
	G['G'][2] = '哥布林'
	G['G'][3] = '哥布林'
	G['A'][2] = '熊貓人'
	G['A'][3] = '熊貓人'

elseif locale == "enUS" or locale == "enGB" then
	-- do nothing as the default values are already in English
else
	print("Grail does not have any knowledge of the localization", locale)
end

--	Grail.notificationFrame is a hidden frame with the sole function of receiving
--	notifications from the Blizzard system
me.notificationFrame = CreateFrame("Frame")
me.notificationFrame:SetScript("OnEvent", function(frame, event, ...) Grail:_Tooltip_OnEvent(frame, event, ...) end)
me.notificationFrame:RegisterEvent("ADDON_LOADED")

end

--[[
		*** Design ***

		Blizzard provides API that details all the quests that their servers record a player as having completed.  However,
		this information does not show the entire picture, and could be misleading.  Therefore, Grail attempts to provide the
		user with a better picture of reality by adjusting and accounting for the Blizzard results.
		
			* Blizzard can record multiple quests as turned in, when one is turned in.  Sometimes this includes quests
				the player could never have completed (because they are class-specific, or from a different faction).
			* There are a class of quests that Blizzard never records as being completed (like truly repeatable ones).
			* Blizzard sometimes uses a FLAG quest to mark a phase change or completion of an event.
			* There are quests that once abandoned are not able to be gotten again, but an associated quest becomes
				available to take its place.  Sometimes there is no FLAG quest for this, and Grail attempts to handle
				this by using false FLAG quests.

		There are many aspects of the games that influence what quests are available to a player.  Some of these aspects are
		reasonably static, like race and faction, while others are more dynamic like level, and reputation levels.  Therefore,
		Grail monitors events to ensure it is aware of changes that influence the availability of quests.

			* Player class
			* Player race
			* Player faction
			* Player level (both level too low and level too high)
			* Player gender
			* Player profession level
			* Player reputation level (both too low and too high)
			* Player having completed achievements
			* Player having a specific buff
			* Player having or not having a specific item
			* Player having turned in or not turned in specific quests
			* Player having completed the requirements for specific quests
			* Player having abandoned specific quests
			* Player having specific quests in the quest log
			* Quests only available during specific holidays (or other events)

		Quests usually have only one NPC that gives the quest and one to which the quest is turned in.  However, there are
		quests that have more than one, including quests that are accepted or turned in without a direct NPC (meaning an
		automatic quest the player handles).  Most NPCs have a fixed position in the world, but some move in small paths.
		There are also NPCs that change positions depending on the phase the player is in.  Sometimes Blizzard changes the
		NPC ID of the NPC when they phase, and other times the NPC ID remains the same.

		Grail has its quest data configured using strings that are reasonably human-readable.  This fixed information is
		converted to numbers that are interpreted as bitfields upon loading.  This is the fixed data.  Each quest also has
		a status that is computed upon request based on the player-specific information in combination with the fixed data.
		This status is also a number to be interpreted as a bitfield where multiple aspects can be set.  Each of these
		numbers only uses 32 bits, even though the numbers may be able to hold more bits.

		Since the status of a quest may be somewhat expensive in computing because a quest's prerequisites may need to be
		computed, the status of each quest is only computed upon demand.  And once the status of a quest is computed it is
		cached so future requests do not recompute it.  This means Grail needs to understand what influences the status of
		a quest and therefore monitors those influences for changes.  When changes occurs, it invalidates the cached status
		of the quests and posts a notification to its observers indicating a quest status change.  Clients can then update
		their UIs to reflect the changes in quest statuses.

		The Blizzard API that is used to determine quest status varies and covers quite a few different types of API.  Each
		of these API does not return valid results until certain parts of the Blizzard system have been initialized, so
		Grail needs to ensure it does not rely on results from any of these API until certain events have occurred.  In fact,
		some of the information Blizzard returns needs to be queried after delays because Blizzard systems do not update
		immediately after events or expected UI interactions like pressing buttons.  Grail attempts to handle these by
		setting up a delayed system where it processed things after a time period has passed.

		The internal method that is used to indicate that quests are incompatible with each others works only when there is
		one quest from the group allowed at the same time.  However, there are cases where there are more than one allowed
		from a specific set, like the Anglers dailes for example.  For the Anglers, three of 14 quests are made available
		each day.  A player can still hold a quest from a previous day and if it is not one of the random quests for the
		day, three will be acceptable.  If a held quest is the same as one offered today, the total number of quests on the
		day will be reduced.  Therefore, Grail groups quests together that can have more and one from that set available at
		a time.  The group specifies how many are allowed from the set.  There are very few groups of quests, and so far
		they have all been dailies.

]]--
