local _,L = ...
local rematch = Rematch
local panel = RematchOptionPanel

local newIcon = " \124TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:12:12\124t"

--[[ Option format:

	[1] = type of option: "check" "radio" "header" "widget" or "spacer"

	"check"
	[2] = the settings[var] of the optn ("FastPetCard", "ClickPetCard", etc)
	[3] = the name of the option as displayed ("Faster pet cards", "Click for pet cards", etc)
	[4] = the tooltip text of the option
	[5] = the settings[var] that the option is dependant upon ("AutoLoadTargetOnly" would have "AutoLoad" here)
	[6] = boolean whether this setting has a panel.funcs to run when clicked
	[7] = boolean whether this setting's function should run on login

	"radio"
	[2] = the shared settings[var] of the option
	[3] = the name of the option as displayed ("Minimized Standalone" "Maximized Standalone")
	[4] = the tooltip text of the option
	[5] = the value (number) to assign to the shared settings[var]

	"header"
	[2] = text to display in header
	[3] = header index (number, see below)

	"widget"
	[2] = name of widget (parentKey of childframe to RematchOptionPanel)

	Header indexes: These numbers are "keys" to the header (collapsed in settings.CollapsedOptHeaders).
	If changing headers, make sure not to reuse an index. It's ok if they're missing or if
	they're out of order. The index is merely for a permanent collapsed handle.
		0 = All Options
		1 = Targeting Options
		2 = Standalone Window Options
		3 = Appearance Options
		4 = Pet Card & Notes Options
		5 = Leveling Queue Options
		6 = Miscellaneous Options
		7 = Preferred Window Mode
		8 = Pet Filters
		9 = Toolbar Options
		10 = Team Options
		11 = Confirmation Options
		12 = Debugging Options
		13 = Team Win Record Options
]]

panel.opts = {
	{ "header", L["All Options"], 0 },
	{ "header", L["Targeting Options"], 1 },
	{ "check", "PromptToLoad", L["Prompt To Load"], L["When your new target has a saved team not already loaded, and the target panel isn't on screen, display a popup asking if you want to load the team.\n\nThis is only for the first interaction with a target. You can always load a target's team from the target panel."], nil, true },
	{ "check", "PromptWithMinimized", L["With Rematch Window"], L["Prompt to load with the Rematch window instead of a separate popup dialog."], "PromptToLoad" },
	{ "check", "PromptAlways", L["Always Prompt"], L["Prompt every time you interact with a target with a saved team not already loaded, instead of only the first time."], "PromptToLoad" },
	{ "check", "AutoLoad", L["Auto Load"], L["When you mouseover a new target that has a saved team not already loaded, immediately load it.\n\nThis is only for the first interaction with a target. You can always load a target's team from the target panel."], nil, true },
	{ "check", "AutoLoadShow", L["Show After Loading"], L["After a team auto loads, show the Rematch window."], "AutoLoad" },
	{ "check", "ShowOnInjured", L["Show On Injured"], L["When a team auto loads, show the Rematch window if any pets in the team are injured."], "AutoLoad" },
	{ "check", "AutoLoadTargetOnly", L["On Target Only"], L["Auto load upon targeting only, not mouseover.\n\n\124cffff4040WARNING!\124r This is not recommended! It can be too late to load pets if you target with right click!"], "AutoLoad", true },
	{ "check", "ShowOnTarget", L["Always Show When Targeting"], L["Regardless whether a target's team is already loaded, show the Rematch window when you target something with a saved team."] },
	{ "header", L["Preferred Window Mode"], 7 },
	{ "radio", "PreferredMode", L["Minimized Standalone"], L["When automatically showing the Rematch window, show the minimized standalone window."], 1 },
	{ "radio", "PreferredMode", L["Maximized Standalone"], L["When automatically showing the Rematch window, show the maximized standalone window."], 2 },
	{ "radio", "PreferredMode", L["Pet Journal"], L["When automatically showing the Rematch window, show the pet journal."], 3 },
	{ "header", L["Standalone Window Options"], 2 },
	{ "widget", "Growth" },
	{ "spacer" }, -- Growth widget takes up two rows
	{ "check", "CustomScale", L["Use Custom Scale"], L["Change the relative size of the standalone window to anywhere between 50% and 200% of its standard size.\n\n\124cffffffffNote:\124r This setting (like the other Standalone Window Options) \124cffffffffdoes not\124r affect the pet journal window."], nil, true },
	{ "check", "SinglePanel", L["Single Panel Mode"], L["Collapse the maximized standalone window to one panel instead of two side by side.\n\nUsers of earlier versions of Rematch may find this mode more familiar."], nil, true },
	{ "check", "UseMiniQueue", L["Combine Pets And Queue"], L["In single panel mode, combine the Pets and Queue tabs together. A narrow queue will display to the right of the pet list instead of in a separate tab."], "SinglePanel", true },
	{ "check", "LockWindow", L["Keep Window On Screen"], L["Don't hide the standalone window when the ESCape key is pressed or most other times it would hide, such as going to the game menu."], nil, true },
	{ "check", "StayForBattle", L["Even For Pet Battles"], L["Keep the standalone window on the screen even when you enter pet battles."], "LockWindow" },
	{ "check", "StayOnLogout", L["Even Across Sessions"], L["If the standalone window was on screen when logging out, automatically summon it on next login."], "LockWindow" },
	{ "check", "LockDrawer", L["Don't Minimize With ESC Key"], L["Don't minimize the standalone window when the ESCape key is pressed."], nil, true, true },
	{ "check", "DontMinTabToggle", L["Or With Panel Tabs"], L["Don't let the Pets, Teams, Queue or Options tabs minimize the standalone window."], "LockDrawer" },
	{ "check", "LowerStrata", L["Lower Window Behind UI"], L["Push the standalone window back behind other parts of the UI so other parts of the UI can appear ontop."], nil, true, true },
	{ "check", "PanelTabsToRight", L["Move Panel Tabs To Right"], L["Align the Pets, Teams, Queue and Options tabs to the right side of the standalone window."], nil, true, true },
	{ "check", "MiniMinimized", L["Minimal Minimized Window"], L["Remove the titlebar and tabs when the standalone window is minimized."] },
	{ "header", L["Appearance Options"], 3 },
	{ "check", "SlimListButtons", L["Compact List Format"], L["Use an alternate style of lists for Pets, Teams and Queue to display more on the screen at once.\n\n\124cffff4040This option requires a Reload."], nil, true },
	{ "check", "SlimListSmallText", L["Use Smaller Text Too"], L["Also use smaller text in the Compact List Format so more text displays on each button."], "SlimListButtons", true },
	{ "check", "ColorPetNames", L["Color Pet Names By Rarity"], L["Make the names of pets you own the same color as its rarity. Blue for rare, green for uncommon, etc."], nil, true },
	{ "check", "HideRarityBorders", L["Hide Rarity Borders"], L["Don't color the icon border for pets you own in the same color as its rarity."], nil, true },
	{ "check", "HideLevelBubbles", L["Hide Level At Max Level"], L["If a pet is level 25, don't show its level on the pet icon."], nil, true },
	{ "check", "ShowAbilityNumbers", L["Show Ability Numbers"], L["In the ability flyout, show the numbers 1 and 2 to help with the common notation such as \"Pet Name 122\" to know which abilities to use."], nil, true },
	{ "check", "ShowAbilityNumbersLoaded", L["On Loaded Abilities Too"], L["In addition to the flyouts, show the numbers 1 and 2 on loaded abilities."], "ShowAbilityNumbers", true },
	{ "header", L["Toolbar Options"], 9 },
	{ "check", "BottomToolbar", L["Move Toolbar To Bottom"], L["Move the toolbar buttons (Revive Battle Pets, Battle Pet Bandages, Safari Hat, etc) to the bottom of the standalone window.\n\nAlso convert the red panel buttons (Save, Save As, Find Battle) to toolbar buttons."], nil, true },
	{ "check", "ReverseToolbar", L["Reverse Toolbar Buttons"], L["Reverse the order of the toolbar buttons (Revive Battle Pets, Battle Pet Bandages, Safari Hat, etc)."], nil, true },
	{ "check", "ToolbarDismiss", L["Hide On Toolbar Right Click"], L["When a toolbar button is used with a right click, dismiss the Rematch window after performing its action."] },
	{ "check", "SafariHatShine", L["Safari Hat Reminder"], L["Draw attention to the safari hat button while a pet below max level is loaded.\n\nAlso show the Rematch window when a low level pet loads and the safari hat is not equipped."], nil, true },
	{ "check", "ShowImportButton", L["Show Import Button"], L["Add a button to the toolar to import a single team or many teams exported from Rematch."], nil, true, true },
	{ "header", L["Pet Card & Notes Options"], 4 },
	{ "check", "FixedPetCard", L["Allow Pet Cards To Be Pinned"], L["When dragging a pet card to another part of the screen, pin the card so all future pet cards display in the same spot, until the pet card is moved again or the unpin button is clicked."], nil, true },
	{ "check", "ClickPetCard", L["Click For Pet Cards & Notes"], L["Instead of automatically showing pet cards and notes when you mouseover them, require clicking the pet or notes button to display them."] },
	{ "check", "FastPetCard", L["Faster Pet Cards & Notes"], L["Instead of a small delay before showing pet cards and notes, immediately show them as you mouseover pets and notes buttons."] },
	{ "check", "PetCardInBattle", L["Use Pet Cards In Battle"], L["Use the pet card on the unit frames during a pet battle instead of the default tooltip."] },
	{ "check", "PetCardForLinks", L["Use Pet Cards For Links"], L["Use the pet card when viewing a link of a pet someone else sent you instead of the default link."] },
	{ "check", "NotesNoESC", L["Keep Notes On Screen"], L["Don't hide notes when the ESCape key is pressed or other times it would hide, such as changing tabs or closing Rematch."], nil, true, true },
	{ "check", "ShowNotesOnTarget", L["Show Notes Upon Targeting"], L["When your target has a saved team with notes, automatically display and lock the notes."] },
	{ "check", "ShowNotesInBattle", L["Show Notes In Battle"], L["If the loaded team has notes, display and lock the notes when you enter a pet battle."] },
	{ "check", "ShowNotesOnce", L["Only Once Per Team"], L["Only display notes automatically the first time entering battle, until another team is loaded."], "ShowNotesInBattle" },
	{ "check", "BoringLoreFont", L["Alternate Lore Font"], L["Use a more normal-looking font for lore text on the back of the pet card."], nil, true, true },
	{ "check", "ShowSpeciesID", L["Show Species ID & Ability ID"], L["Display the numerical species ID of a pet as a stat on their pet card and the numerical ability ID on ability tooltips."] },
	{ "header", L["Team Options"]..newIcon, 10 },
	{ "check", "LoadHealthiest", L["Load Healthiest Pets"], L["When a team loads, if any pet is injured or dead and there's another version with more health \124cffffffffand identical stats\124r, load the healthier version.\n\nPets in the leveling queue are exempt from this option.\n\n\124cffffffffNote:\124r This is only when a team loads. It will not automatically swap in healthier pets when you leave battle."] },
	{ "check", "LoadHealthiestAny", L["Allow Any Version"], L["Instead of choosing only the healthiest pet with identical stats, choose the healthiest version of the pet regardless of stats."], "LoadHealthiest" },
	{ "check", "LoadHealthiestAfterBattle", L["After Pet Battles Too"], L["Also load healthiest pets after leaving a pet battle or using a Revive or Bandage within Rematch.\n\n\124cffffffffNote:\124r Use of Revive or Bandages outside Rematch will not be noticed.\n\nThis is an experimental option. If you experience problems and want to report them, \124cffffffffPLEASE\124cffffffff mention that this option is enabled!\124r"], "LoadHealthiest"},
	{ "check", "ShowInTeamsFootnotes", L["Show Icon For Pets In Teams"], L["When a pet belongs to a team, show an icon beside their name in the pet list and queue."], nil, true},
	{ "check", "HideTargetNames", L["Hide Targets Below Teams"], L["Hide the target name that appears beneath a team that is not named the same as its target."] },
	{ "check", "AlwaysTeamTabs", L["Always Show Team Tabs"], L["Show team tabs along the right side of the window even if you're not on the team panel."], nil, true },
	{ "check", "TeamTabsToLeft", L["Move Team Tabs To Left"], L["Move the team tabs along the right side of the standalone window to the left side."], "AlwaysTeamTabs", true },
	{ "check", "ImportTeamTabsToo", L["Import Team Tabs Too"]..newIcon, L["When importing teams created from a 'Backup All Teams' export, teams will import into tabs they were in when backed up.\n\nIf new tabs need to be created, they will have the default icon and options. \n\nAlso, the max number of team tabs is 32. Teams in any tabs that exceed this limit will go to the originally chosen tab.\n\n\124cffffffffNote:\124r This is an \124cffffffffexperimental\124r feature. Your teams won't get deleted from this, but in the event they disappear into random tabs, backup your WTF folder to do a complete restore."] },
	{ "check", "UseLegacyExport", L["Share In Legacy Format"], L["When exporting teams or sending to another Rematch user, use the old format.\n\nUse this option when sharing teams with someone on an older Rematch that's unable to import or receive newer teams."] },
	{ "check", "PrioritizeBreedOnImport", L["Prioritize Breed On Import"], L["When importing or receiving teams, fill the team with the best matched breed as the first priority instead of the highest level."] },
	{ "check", "RandomAbilitiesToo", L["Randomize Abilities Too"], L["For random pets, randomize the pets' abilities also."]},
	{ "check", "AllowRandomPetsFromTeams", L["Allow Random Pets From Teams"], L["The default behavior for a random pet slot is to not choose a random pet saved in another team, unless all three pet slots are random.\n\nEnable this option to always allow pets from other teams to be included in the random pool."] },
	{ "header", L["Team Win Record Options"], 13 },
	{ "check", "AutoWinRecord", L["Auto Track Win Record"], L["At the end of each battle, automatically record whether the loaded team won or lost.\n\nForfeits always count as a loss.\n\nYou can still manually update a team's win record at any time."] },
	{ "check", "AutoWinRecordPVPOnly", L["For PVP Battles Only"], L["Automatically track whether the loaded team won or lost only in a PVP battle and never for a PVE battle."], "AutoWinRecord" },
	{ "check", "AlternateWinRecord", L["Display Total Wins Instead"], L["Instead of displaying the win percentage of a team on the win record button, display the total number of wins.\n\nTeam tabs that are sorted by win record will sort by total wins also."], nil, true },
	{ "check", "HideWinRecord", L["Hide Win Record Buttons"], L["Hide the win record button displayed to the right of each team.\n\nYou can still manually edit a team's win record from its right-click menu and automatic tracking will continue if enabled."], nil, true },
	{ "header", L["Leveling Queue Options"], 5 },
	{ "check", "QueueSkipDead", L["Prefer Living Pets"], L["When loading pets from the queue, skip dead pets and load living ones first."], nil, true },
	{ "check", "QueuePreferFullHP", L["And At Full Health"], L["Also prefer uninjured pets when loading pets from the queue."], "QueueSkipDead", true },
	{ "check", "QueueDoubleClick", L["Double Click To Send To Top"], L["When a pet in the queue panel is double clicked, send it to the top of the queue instead of summoning it."] },
	{ "check", "HidePetToast", L["Hide Leveling Pet Toast"], L["Don't display the popup 'toast' when a new pet is automatically loaded from the leveling queue."] },
	{ "check", "QueueAutoLearn", L["Automatically Level New Pets"], L["When you capture or learn a pet, automatically add it to the leveling queue."] },
	{ "check", "QueueAutoLearnOnly", L["Only Pets Without A 25"], L["Only automatically level pets which don't have a version already at 25 or in the queue."], "QueueAutoLearn" },
	{ "check", "QueueAutoLearnRare", L["Only Rare Pets"], L["Only automatically level rare quality pets."], "QueueAutoLearn" },
	{ "check", "QueueRandomWhenEmpty", L["Use Random If Queue Empty"], L["When the queue is empty, use a random high level pet instead of ignoring the slot when a team loads."] },
	{ "header", L["Pet Filter Options"], 8 },
	{ "check", "StrongVsLevel", L["Use Level In Strong Vs Filter"], L["When doing a Strong Vs filter, take the level of the pet into account. If a pet is not high enough level to use a Strong Vs ability, do not list the pet.\n\n\124cffffffffNote:\124r A Strong Vs filter is sometimes useful for identifying pets you want to level or capture. This option will hide those pets while the Strong Vs filter is active."], nil, true },
	{ "check", "ResetFilters", L["Reset Filters On Login"], L["When logging in, start with all pets listed and no filters active."] },
	{ "check", "ResetSortWithFilters", L["Reset Sort With Filters"], L["When clearing filters, also reset the sort back to the default: Sort by Name, Favorites First."], nil, true },
	{ "check", "ResetExceptSearch", L["Don't Reset Search With Filters"], L["When manually clearing filters, don't clear the search box too.\n\nSome actions, such as logging in or Find Similar, will always clear search regardless of this setting."] },
	{ "check", "SortByNickname", L["Sort By Chosen Name"], L["When pets are sorted by name, sort them by the name given with the Rename option instead of their original name."], nil, true },
	{ "check", "DontSortByRelevance", L["Don't Sort By Relevance"], L["When searching for something by name in the search box, do not sort the results by relevance.\n\nWhen sorted by relevance, pets with the search term in their name are listed first, followed by terms in notes, then abilities and then source text last."], nil, true },
	{ "check", "HideNonBattlePets", L["Hide Non-Battle Pets"], L["Only list pets that can battle. Do not list pets like balloons, squires and other companion pets that cannot battle."], nil, true },
	{ "check", "AllowHiddenPets", L["Allow Hidden Pets"], L["Allow the ability to hide specific pet species in the pet list with a 'Hide Pet' in the list's right-click menu.\n\nYou can view pets you've hidden from the Other -> Hidden Pets filter."], nil, true },
	{ "header", L["Confirmation Options"], 11 },
	{ "check", "DontWarnMissing", L["Don't Warn About Missing Pets"], L["Don't display a popup when a team loads and a pet within the team can't be found."] },
	{ "check", "DontConfirmHidePets", L["Don't Ask When Hiding Pets"], L["Don't ask for confirmation when hiding a pet.\n\nYou can view hidden pets in the 'Other' pet filter."] },
	{ "check", "NoBackupReminder", L["Don't Remind About Backups"], L["Don't show a popup offering to backup teams every once in a while. Generally, the popup appears sometime after the number of teams increases by 50."] },
	{ "header", L["Miscellaneous Options"], 6 },
	{ "check", "SlowMousewheelScroll", L["Slow Mousewheel Scroll"], L["In the Pets, Teams, Queue and Options lists, mousewheel over the list will scroll one line at a time instead of a whole page at a time.\n\nYou can still scroll by pages by clicking above or below the scroll thumb."] },
	{ "check", "ShowAfterBattle", L["Show After Pet Battle"], L["Show the Rematch window after leaving a pet battle."] },
	{ "check", "ShowAfterPVEOnly", L["But Not After PVP Battle"], L["Since pets don't remain injured in PVP battles, don't show the window when leaving a PVP battle."], "ShowAfterBattle" },
	{ "check", "DisableShare", L["Disable Sharing"], L["Disable the Send button and also block any incoming pets sent by others. Import and Export still work."] },
	{ "check", "UseMinimapButton", L["Use Minimap Button"], L["Place a button on the minimap to toggle Rematch and load favorite teams."], nil, true, true },
	{ "check", "KeepSummoned", L["Keep Companion"], L["After a team is loaded, summon back the companion that was at your side before the load; or dismiss the pet if you had none summoned."] },
	{ "check", "NoSummonOnDblClick", L["No Summon On Double Click"], L["Do nothing when pets within Rematch are double-clicked. The normal behavior of double click throughout Rematch is to summon or dismiss the pet."] },
	{ "check", "HideTooltips", L["Hide Tooltips"], L["Hide the more common tooltips in Rematch."] },
	{ "check", "HideMenuHelp", L["Hide Extra Help"], L["Hide the informational \"Help\" items found in many menus and on the pet card."] },
	{ "check", "UseDefaultJournal", L["Use Default Pet Journal"], L["Turn off Rematch integration with the default pet journal.\n\nYou can still use Rematch in its standalone window, accessed via key binding, /rematch command or from the Minimap button if enabled in options."], nil, true },
	{ "header", L["Debugging Options"], 12 },
	{ "check", "DebugJournalFrameLevel", L["Debug: Journal FrameLevel"], L["Check this to less aggressively try to take over the default pet journal. Specifically, it will give up sooner if it can't raise frame level above all other addons' frames in the journal."] },
	{ "check", "DebugNoCache", L["Debug: No Cache"], L["Check this to disable the automatic caching of NPC names when the addon launches.\n\n\124cffffffffNote:\124r If a target's name appears as something like 'NPC 1234' while this option is enabled, it's probably because of this option. It should correct itself on its own over time."] },
	{ "check", "DebugNoSanctuary", L["Debug: No Sanctuary"], L["Check this to disable the 'Sanctuary' system that acts as a safety net for server petID reassignments.\n\n\124cffffffffNote:\124r While this option is enabled, any pets in teams will become greyed out if their petID changes. When the team loads, an arbitrary one of the same species will be loaded in its place.\n\n\124cffff4040WARNING!\124r While this option is enabled, make frequent backups of your teams with the 'Backup All Teams' options in the Teams button at the top of the Teams Tab."] },
	{ "check", "DebugDelayMacs", L["Debug: Delay Journal"], L["Delay Rematch taking over the journal on the first launch by a full second."] },
	{ "check", "DebugDelayMacsOneFrame", L["Delay Just One Frame"], L["Change the delay from half a second to one frame, or nearly instant."], "DebugDelayMacs" },
	{ "check", "DebugNoModels", L["Debug: No Models"], L["Prevent the creation or rendering of any models within Rematch. This includes the target panel, loadout slots and pet card.\n\n\124cffff4040This option requires a Reload."], nil, true },
	{ "text", format(L["Rematch version %s"],GetAddOnMetadata("Rematch","Version")) },
	{ "text", format(L["The%s icon indicates new options."],newIcon) },
}
