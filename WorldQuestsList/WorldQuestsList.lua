local VERSION = 79

--[[
Special icons for rares, pvp or pet battle quests in list
Better sorting for all reward types
Quest position on general Broken Isles map
Number of artifact power on item in list
New quests will be marked as "new" for another 3 min
Minor localization fixes

Added Eye Of Azshara zone
Note for BOE gear rewards
Fix for 1k+ AP items
Minor fixes

Added helper for Kirin Tor enigma world quest
Added minor functionality for leveling

Blood of Sargeras filter
Icon on map for hidden quests (that expires in 15min)
Icon in list for profession quests
Fix for Kirin-Tor helper (quest is 7x7 now instead 8x8)

Added button "Show all quests"
QOL improvements (mouseovering + shift, click on quest)
Fixed changing order for quests with same timer while sorting by time
Click on quest now send you to zone map
Added ElvUI support
Bugfixes

Added icon on the flight map for recently chosen quest

Added filters for pvp, pet battles & professions quests
Added checkbox above map to disable WQL

Artifact weapon color for all artifact power items
Minor notification for artifact power items that can be earned after reaching next artifact knowledge level
Dungeon icon for dungeons world quests
Added options for scale, anchor and arrow

Added tooltip with date for timeleft
Enigma helper disabled ("/enigmahelper" still works)
Added "Total AP" text
Minor fixes

Fixed highlighting faction for emissary quests (You can do Watchers or Kirin-tor quests for zone emissary)
Added "Total gold & total order resources" text
Minor fixes

Fixed summary while filtered
Added "Time to Complete" for marked ("**") quests
Added 7.1 support
Different color for elite quests
Some pvp quests shows honor as reward if reward is only gold [filter for them gold as before]
Minor fixes

7.1 Update

New option "Ignore filter for bounty quests"
Minor fixes

Last client update (not addon) broke something with world quests (updating info too frequently). I added 5 second limit for updating (so may need time for update rewards after login), dropdowns will closing every 5 sec too. Sorry for the inconvenience, it'll not be too long until I write real solution

Added "Barrels o' Fun" helper
Minor fixes

Rewards updates must be faster
Added options for enable/disabe Enigma Helper/Barrels Helper
Added option "Ignore filter for PvP quests"

Added scroll (use mouse wheel or buttons for navigate) [still in testing]
AP numbers divided by 1000 for artifact knowledge 26 or higher
7.2 PTR Update (Note: this version works on both clients: live 7.1.5 and ptr 7.2.0)

More "Ignore filter" options
7.2 Updates (Note: this version works on both clients: live 7.1.5 and ptr 7.2.0)

7.2 toc update
Added dalaran quests to general map
Added option for AP number formatting
Added header line for quick sorting (and option for disabling it)
Added switcher to regular quests (not WQ) for max level chars
Tooltip with icons for all factions if quest can be done for any emissary
Added option for disabling highlight for new quests

Added quests without timer to list (unlimited quests; expired quests)
Added sorting by distance to quest
Sorting by reward: Gear rewards had low priority for high ilvl chars
Minor fixes

Bugfixes

Added invasions quests to list for low level chars
Added faction icons for emissary quests (can be disabled in options)
Threshold for lower priority on gear rewards was lowered to 880 ilvl

7.2.5 Update

7.3.0 PTR Update
Added TomTom support

Fixed debug numbers in chat
TomTom now have higher prior if both addons for arrow enabled

Added autoremoving arrow for TomTom if you completed or leaved quest area [in testing]
Added ignoring quests [right click on quest name]

Added option for changing arrow style (TomTom or ExRT)
Minor 7.3.0 Updates

7.3.0 Update
Graphical updates
New anchor position: inside map [experimental]
Frame now movable if you run it via "/wql" [Use "/wql reset" if you somehow lost frame out of the screen]

Added "Ignore filter" oprions for factions "Army of the Light" & "Argussian Reach"
Added new anchor position: free outside [Use "/wql resetanchor" or "/wql reset" if you somehow lost frame out of the screen]
Minor fixes

Added Invasion Points

Fixes

General Argus Map were replaced with zones map [in testing, you can disable this in options]
Readded info for AP quests that can be done with next Aknowledge level [only for EU and US servers]

Fixes for ADDON_ACTION_BLOCKED errors
Added "/wql argus" command

Fixes

Added option for percentage of the current level's max AP number (by Corveroth)
Update for korean translation (by yuk6196)
Fixes (Frame strata for free position)

Minor fixes
Update for chinese translation (by dxlmike)

Added Veiled Argunite filter

BfA update (8.0.1)
added button for quick navigate between Zandalar and Kul-Tiras
quest icons on general (continents) maps
quick link to wowhead (right click on quest name)
shell game helper
new filters (azerite, reputations)
new factions filters
tooltip with reputation rewards for quests
options for manipulations with list on azeroth/Broken Isles maps (i.e. include/exclude agrus/legion quests, etc)
second icon for profession quests
standalone arrow, no addons required
text color for zone names
added treasure/rares mode [beta]

Added LFG (group finder) option [in testing]

LFG: Less clicks to find group
LFG: Click with shift button will try to find group by quest name
Added tooltip for eye buttons
LFG: Right click on map icons will start search groups for this quest
LFG: Added popup window when you enter quest area (and option to disable it)
LFG: Added submit with enter key
Moved agrus rep token revards to reputation category
Minor fixes

Options dropdown menu now available all time in wq mode
Major fixes

Find party popup now uses default search for rare quests
Added option for disabling search on rightclick on map icons
Minor fixes

Blacklisted some quests for auto popup (pet battles, supplies, work orders)
Added "/wql options" command
Minor fixes

Added reward type on icons on map [in testmode, you can enable it in options]
Added "Start a group" button after success search
Bigger icons on general map in fullscreen map mode
More blacklisted quests (kirin tor & tortollan puzzles)

LFG: "Convert to raid" popup must not be displayed for non-elite quests
Minor fixes

Added "Map icons scale" option
Hovered world quest icon will be on top
Added reward-on-icons for the flightmap
Autotoggle all languages for LFG fliter search

Fix for wq icons scale for non-general maps in fullscreen mode
LFG: Blizzard's group finder is broken again for elite quests, so added button "Try with Quest ID" on group creation page
Added world quest type mini icon (pvp, profession, pet battle)
Added option "Hide ribbon graphic"
Added option for arrow for regular quests (via right click on map)
LFG: added support for regular quests (via list or right click on map)
LFG: groups for non-elite quests with 5 players will be marked as red
Minor fixes

Added option "Disable all, except LFG" ("/wql options" > "Enable LFG search"  > "Disable all, except LFG")
TomTom arrow is back as option
Fixed WQ icons random shifting
WQ icons on world map will stay if list is hidden
Minor fixes

Fixed free mode anchor
Some tweaks for fullscreen map mode
Added option "Disable eye for quest tracker on right"
Minor fixes

LFG Hotfixes, must work as before [Report any bugs/errors]

More fixes for fullscreen map mode
Added "max lines" option
Minor LFG updates

LFG Hotfixes

LFG fixes

Added option to highlight quest for selected factions reputations
Minor fixes

LFG: no more 'wwwwwww' in searchbox if player is moving
LFG: leave party popup only for quest groups
Added shift+right click to expand azerite gear rewards
Localizations updates by sprider00
Minor fixes

Added requeue button for current quest (replace eye in quest tracker)
Fix for "addon blocked" error
Minor updates

Added option "Disable popup after quest completion (leave party)"
Added "/wql way X Y" command for manual arrow
Right click on LFG popup will hide it
Minor fixes
]]

local GlobalAddonName, WQLdb = ...

--[[
do
	local version, buildVersion, buildDate, uiVersion = GetBuildInfo()
	
	local expansion,majorPatch,minorPatch = (version or "1.0.0"):match("^(%d+)%.(%d+)%.(%d+)")
	
	if ((expansion or 0) * 10000 + (majorPatch or 0) * 100 + (minorPatch or 0)) < 80000 then
		return
	end
end
]]

local VWQL = nil

local GetCurrentMapAreaID, tonumber, C_TaskQuest, tinsert, abs, time, GetCurrencyInfo, HaveQuestData, QuestUtils_IsQuestWorldQuest, GetQuestTagInfo, bit, format, floor, pairs = 
      function() return WorldMapFrame:GetMapID() or 0 end, tonumber, C_TaskQuest, tinsert, abs, time, GetCurrencyInfo, HaveQuestData, QuestUtils_IsQuestWorldQuest, GetQuestTagInfo, bit, format, floor, pairs
local LE = {
	LE_QUEST_TAG_TYPE_INVASION = LE_QUEST_TAG_TYPE_INVASION,
	LE_QUEST_TAG_TYPE_DUNGEON = LE_QUEST_TAG_TYPE_DUNGEON,
	LE_QUEST_TAG_TYPE_RAID = LE_QUEST_TAG_TYPE_RAID,
	LE_WORLD_QUEST_QUALITY_RARE = LE_WORLD_QUEST_QUALITY_RARE,
	LE_WORLD_QUEST_QUALITY_EPIC = LE_WORLD_QUEST_QUALITY_EPIC,
	LE_QUEST_TAG_TYPE_PVP = LE_QUEST_TAG_TYPE_PVP,
	LE_QUEST_TAG_TYPE_PET_BATTLE = LE_QUEST_TAG_TYPE_PET_BATTLE,
	LE_QUEST_TAG_TYPE_PROFESSION = LE_QUEST_TAG_TYPE_PROFESSION,
	LE_ITEM_QUALITY_COMMON = LE_ITEM_QUALITY_COMMON,
	
	BAG_ITEM_QUALITY_COLORS = BAG_ITEM_QUALITY_COLORS,
	ITEM_SPELL_TRIGGER_ONUSE = ITEM_SPELL_TRIGGER_ONUSE,
	ITEM_BIND_ON_EQUIP = ITEM_BIND_ON_EQUIP,
	ARTIFACT_POWER = ARTIFACT_POWER,
	AZERITE = GetCurrencyInfo(1553),
	ORDER_RESOURCES_NAME_LEGION = GetCurrencyInfo(1220),
	ORDER_RESOURCES_NAME_BFA = GetCurrencyInfo(1560),
}
      
local charKey = (UnitName'player' or "").."-"..(GetRealmName() or ""):gsub(" ","")

local locale = GetLocale()
local LOCALE = 
	locale == "ruRU" and {
		gear = "Экипировка",
		gold = "Золото",
		blood = "Кровь Саргераса",
		knowledgeTooltip = "** Можно выполнить после повышения уровня знаний вашего артефакта",
		disableArrow = "Отключить стрелку",
		anchor = "Привязка",
		totalap = "Всего силы артефакта: ",
		totalapdisable = 'Отключить сумму силы артефакта',
		timeToComplete = "Времени на выполнение: ",
		bountyIgnoreFilter = "Задания посланника",
		enigmaHelper = "Включить Enigma Helper",
		barrelsHelper = "Включить Barrels Helper",
		honorIgnoreFilter = "PvP задания",
		ignoreFilter = "Игнорировать фильтр для",
		epicIgnoreFilter = '"Золотые" задания',	
		wantedIgnoreFilter = 'Задания "Разыскиваются"',	
		apFormatSetup = "Формат силы артефакта",
		headerEnable = "Включить полосу-заголовок",
		disabeHighlightNewQuests = "Отключить подсветку новых заданий",
		distance = "Расстояние",
		disableBountyIcon = "Отключить иконку фракций для заданий посланника",
		arrow = "Стрелка",
		invasionPoints = "Точки вторжения",
		argusMap = "Включить карту Аргуса",
		ignoreList = "Список игнорирования",
		addQuestsOpposite = "Добавить задания другого континента",
		hideLegion = "Скрыть задания из Легиона",
		disableArrowMove = "Отключить перемещение",
		shellGameHelper = "Включить Shell Game Helper",
		iconsOnMinimap = "Включить иконки на общих картах",
		addQuestsArgus = "Добавить задания Аргуса",
		lfgSearchOption = "Включить поиск в LFG",
		lfgAutoinvite = "Включите опцию автоприглашения",
		lfgTypeText = "Введите цифры (ID квеста) в поле для ввода",
		lfgLeftButtonClick = "ЛКМ - найти группу",
		lfgLeftButtonClick2 = "ЛКМ + shift - найти группу по названию",
		lfgRightButtonClick = "ПКМ - создать группу",
		lfgDisablePopup = "Отключить всплывающее окно",
		lfgDisableRightClickIcons = "Отключить правый клик по иконкам на карте",
		disableRewardIcons = "Включить награду на иконках на карте",
		mapIconsScale = "Масштаб иконок на карте",
		disableRibbon = "Отключить графику ленты",
		enableRibbonGeneralMap = "Включить ленту на картах континентов",
		enableArrowQuests = "Включить стрелку для обычных заданий",
		tryWithQuestID = "Поиск по quest ID",
		lfgDisableAll = "Отключить все, кроме LFG",
		lfgDisableAll2 = "Все настройки аддона будут сброшены. Отключить все функции, кроме LFG?",
		lfgDisableEyeRight = "Отключить кнопку глаза в меню заданий справа",
		lfgDisableEyeList = "Скрыть кнопку глаза в списке",
		listSize = "Размер списка",
		topLine = "Верхняя строка",
		bottomLine = "Нижняя строка",
		unlimited = "Неограниченно",
		maxLines = "Лимит строк",
		lfgDisablePopupLeave = "Отключить всплывающее окно после завершения задания (покинуть группу)",
	} or
	locale == "deDE" and {    --by Sunflow72
		gear = "Ausrüstung",
		gold = "Gold",
		blood = "Blut von Sargeras",
		knowledgeTooltip = "** Kann nach dem Erreichen des nächsten Artefaktwissens abgeschlossen werden",
		disableArrow = "Deaktiviert den Pfeil",
		anchor = "Anker",
		totalap = "Artefaktmacht insgesamt: ",
		totalapdisable = 'Deaktiviert "Gesamt-Artefaktmacht"',
		timeToComplete = "Zeit zum Abschließen: ",
		bountyIgnoreFilter = "Abgesandten Quests",
		enigmaHelper = "Aktiviert Rätsel Helfer",
		barrelsHelper = "Aktiviert Fässer Helfer",
		honorIgnoreFilter = "PVP Quests",
		ignoreFilter = "Filter ignorieren für",
		epicIgnoreFilter = '"ELITE" Quests',
		wantedIgnoreFilter = "GESUCHT:... Quests",    
		apFormatSetup = "Artefaktmacht Format",
		headerEnable = "Aktiviert die Kopfzeile",
		disabeHighlightNewQuests = "Deaktiviert die Markierung für neue Quests",
		distance = "Entfernung",
		disableBountyIcon = "Deaktiviert die Fraktionssymbole für Abgesandten Quests",
		arrow = "Pfeil",
		invasionPoints = "Invasions-Punkte",
		argusMap = "Aktiviert Argus Karte",
		ignoreList = "Ignorier-Liste",
		addQuestsOpposite = "Fügt Quests von anderen Kontinent hinzu",
		hideLegion = "Verbergt Quests von Legion",
		disableArrowMove = "Deaktiviert das Verschieben",
		shellGameHelper = "Aktiviert Panzer-Spiel Helfer",
		iconsOnMinimap = "Aktiviert Symbole auf Kontinentkarten",
		addQuestsArgus = "Fügt Quests von Argus hinzu",
		lfgSearchOption = "Aktiviert die LFG-Suche",
		lfgAutoinvite = "Aktiviert die automatische Einladungsoption",
		lfgTypeText = "Gib die Quest-ID in das Eingabefeld ein",
		lfgLeftButtonClick = "Linksklick - Gruppe finden",
		lfgLeftButtonClick2 = "Linksklick + Shift - Gruppe finden nach Namen",
		lfgRightButtonClick = "Rechtsklick - Gruppe erstellen",
		lfgDisablePopup = "Deaktiviert Popup im Questbereich",
		lfgDisableRightClickIcons = "Deaktiviert die rechte Maustaste auf Symbole der Karte",
		disableRewardIcons = "Aktiviert die Belohnungssymbole auf Karten",
		mapIconsScale = "Kartensymbole skalieren",
		disableRibbon = "Deaktiviert die Bandgrafiken",
		enableRibbonGeneralMap = "Aktiviert die Bandgrafik auf Kontinentkarten",
		enableArrowQuests = "Aktiviert den Pfeil für normale Quests",
		tryWithQuestID = "Suche nach Quest-ID",
		lfgDisableAll = "Deaktiviert alle, außer LFG",
		lfgDisableAll2 = "Alle Add-In Einstellungen werden zurückgesetzt. Deaktiviert alle Optionen, außer LFG?",
		lfgDisableEyeRight = "Deaktiviert Augenknopf bei Quest-Ziele auf der rechten Seite",
		lfgDisableEyeList = "Augenknopf in Liste ausblenden",
		listSize = "Listengröße",
		topLine = "Obere Zeile",
		bottomLine = "Untere Zeile",
		unlimited = "Unbegrenzt",
		maxLines = "maximale Anzahl an Zeilen",
		lfgDisablePopupLeave = "Disable popup after quest completion (leave party)",
	} or
	locale == "frFR" and {
		gear = "Équipement",
		gold = "Or",
		blood = "Sang de Sargeras",
		knowledgeTooltip = "** Can be completed after reaching next artifact knowledge level",
		disableArrow = "Disable arrow",
		anchor = "Anchor",
		totalap = "Total Artifact Power: ",
		totalapdisable = 'Disable "Total AP"',
		timeToComplete = "Time to complete: ",
		bountyIgnoreFilter = "Emissary quests",
		enigmaHelper = "Enable Enigma Helper",
		barrelsHelper = "Enable Barrels Helper",
		honorIgnoreFilter = "PvP quests",
		ignoreFilter = "Ignore filter for",
		epicIgnoreFilter = '"Golden" quests',
		wantedIgnoreFilter = "WANTED quests",	
		apFormatSetup = "Artifact Power format",
		headerEnable = "Enable header line",
		disabeHighlightNewQuests = "Disable highlight for new quests",
		distance = "Distance",
		disableBountyIcon = "Disable Emissary icons for faction names",
		arrow = "Arrow",
		invasionPoints = "Invasion Points",
		argusMap = "Enable Argus map",
		ignoreList = "Ignore list",
		addQuestsOpposite = "Add quests from the opposite continent",
		hideLegion = "Hide quests from Legion",
		disableArrowMove = "Disable moving",
		shellGameHelper = "Enable Shell Game Helper",
		iconsOnMinimap = "Enable icons on General maps",
		addQuestsArgus = "Add quests from Argus",
		lfgSearchOption = "Enable LFG search",
		lfgAutoinvite = "Set autoinvite option on",
		lfgTypeText = "Type numbers (QuestID) to edit box",
		lfgLeftButtonClick = "Left Click - find group",
		lfgLeftButtonClick2 = "Left Click + shift - find group by name",
		lfgRightButtonClick = "Right Click - create group",
		lfgDisablePopup = "Disable popup in questarea",
		lfgDisableRightClickIcons = "Disable right click on map icons",
		disableRewardIcons = "Enable reward on map icons",
		mapIconsScale = "Map icons scale",
		disableRibbon = "Disable ribbon graphic",
		enableRibbonGeneralMap = "Enable ribbon on general maps",
		enableArrowQuests = "Enable arrow for regular quests",
		tryWithQuestID = "Try by quest ID",
		lfgDisableAll = "Disable all, except LFG",
		lfgDisableAll2 = "All addon settings will be lost. Disable all options, except LFG?",
		lfgDisableEyeRight = "Disable eye for quest tracker on right",
		lfgDisableEyeList = "Hide eye in list",
		listSize = "List size",
		topLine = "Top line",
		bottomLine = "Bottom line",
		unlimited = "Unlimited",
		maxLines = "Max lines",
		lfgDisablePopupLeave = "Disable popup after quest completion (leave party)",
	} or
	(locale == "esES" or locale == "esMX") and {
		gear = "Equipo",
		gold = "Oro",
		blood = "Sangre de Sargeras",
		knowledgeTooltip = "** Can be completed after reaching next artifact knowledge level",
		disableArrow = "Disable arrow",
		anchor = "Anchor",
		totalap = "Total Artifact Power: ",
		totalapdisable = 'Disable "Total AP"',
		timeToComplete = "Time to complete: ",
		bountyIgnoreFilter = "Emissary quests",
		enigmaHelper = "Enable Enigma Helper",
		barrelsHelper = "Enable Barrels Helper",
		honorIgnoreFilter = "PvP quests",
		ignoreFilter = "Ignore filter for",
		epicIgnoreFilter = '"Golden" quests',
		wantedIgnoreFilter = "WANTED quests",	
		apFormatSetup = "Artifact Power format",
		headerEnable = "Enable header line",
		disabeHighlightNewQuests = "Disable highlight for new quests",
		distance = "Distance",
		disableBountyIcon = "Disable Emissary icons for faction names",
		arrow = "Arrow",
		invasionPoints = "Invasion Points",
		argusMap = "Enable Argus map",
		ignoreList = "Ignore list",
		addQuestsOpposite = "Add quests from the opposite continent",
		hideLegion = "Hide quests from Legion",
		disableArrowMove = "Disable moving",
		shellGameHelper = "Enable Shell Game Helper",
		iconsOnMinimap = "Enable icons on General maps",
		addQuestsArgus = "Add quests from Argus",
		lfgSearchOption = "Enable LFG search",
		lfgAutoinvite = "Set autoinvite option on",
		lfgTypeText = "Type numbers (QuestID) to edit box",
		lfgLeftButtonClick = "Left Click - find group",
		lfgLeftButtonClick2 = "Left Click + shift - find group by name",
		lfgRightButtonClick = "Right Click - create group",
		lfgDisablePopup = "Disable popup in questarea",
		lfgDisableRightClickIcons = "Disable right click on map icons",
		disableRewardIcons = "Enable reward on map icons",
		mapIconsScale = "Map icons scale",
		disableRibbon = "Disable ribbon graphic",
		enableRibbonGeneralMap = "Enable ribbon on general maps",
		enableArrowQuests = "Enable arrow for regular quests",
		tryWithQuestID = "Try by quest ID",
		lfgDisableAll = "Disable all, except LFG",
		lfgDisableAll2 = "All addon settings will be lost. Disable all options, except LFG?",
		lfgDisableEyeRight = "Disable eye for quest tracker on right",
		lfgDisableEyeList = "Hide eye in list",
		listSize = "List size",
		topLine = "Top line",
		bottomLine = "Bottom line",
		unlimited = "Unlimited",
		maxLines = "Max lines",
		lfgDisablePopupLeave = "Disable popup after quest completion (leave party)",
	} or	
	locale == "itIT" and {
		gear = "Equipaggiamento",
		gold = "Oro",
		blood = "Sangue di Sargeras",
		knowledgeTooltip = "** Can be completed after reaching next artifact knowledge level",
		disableArrow = "Disable arrow",
		anchor = "Anchor",
		totalap = "Total Artifact Power: ",
		totalapdisable = 'Disable "Total AP"',
		timeToComplete = "Time to complete: ",
		bountyIgnoreFilter = "Emissary quests",
		enigmaHelper = "Enable Enigma Helper",
		barrelsHelper = "Enable Barrels Helper",
		honorIgnoreFilter = "PvP quests",
		ignoreFilter = "Ignore filter for",
		epicIgnoreFilter = '"Golden" quests',
		wantedIgnoreFilter = "WANTED quests",	
		apFormatSetup = "Artifact Power format",
		headerEnable = "Enable header line",
		disabeHighlightNewQuests = "Disable highlight for new quests",
		distance = "Distance",
		disableBountyIcon = "Disable Emissary icons for faction names",
		arrow = "Arrow",
		invasionPoints = "Invasion Points",
		argusMap = "Enable Argus map",
		ignoreList = "Ignore list",
		addQuestsOpposite = "Add quests from the opposite continent",
		hideLegion = "Hide quests from Legion",
		disableArrowMove = "Disable moving",
		shellGameHelper = "Enable Shell Game Helper",
		iconsOnMinimap = "Enable icons on General maps",
		addQuestsArgus = "Add quests from Argus",
		lfgSearchOption = "Enable LFG search",
		lfgAutoinvite = "Set autoinvite option on",
		lfgTypeText = "Type numbers (QuestID) to edit box",
		lfgLeftButtonClick = "Left Click - find group",
		lfgLeftButtonClick2 = "Left Click + shift - find group by name",
		lfgRightButtonClick = "Right Click - create group",
		lfgDisablePopup = "Disable popup in questarea",
		lfgDisableRightClickIcons = "Disable right click on map icons",
		disableRewardIcons = "Enable reward on map icons",
		mapIconsScale = "Map icons scale",
		disableRibbon = "Disable ribbon graphic",
		enableRibbonGeneralMap = "Enable ribbon on general maps",
		enableArrowQuests = "Enable arrow for regular quests",
		tryWithQuestID = "Try by quest ID",
		lfgDisableAll = "Disable all, except LFG",
		lfgDisableAll2 = "All addon settings will be lost. Disable all options, except LFG?",
		lfgDisableEyeRight = "Disable eye for quest tracker on right",
		lfgDisableEyeList = "Hide eye in list",
		listSize = "List size",
		topLine = "Top line",
		bottomLine = "Bottom line",
		unlimited = "Unlimited",
		maxLines = "Max lines",
		lfgDisablePopupLeave = "Disable popup after quest completion (leave party)",
	} or
	locale == "ptBR" and {
		gear = "Equipamento",
		gold = "Ouro",
		blood = "Sangue de Sargeras",
		knowledgeTooltip = "** Can be completed after reaching next artifact knowledge level",
		disableArrow = "Disable arrow",
		anchor = "Anchor",
		totalap = "Total Artifact Power: ",
		totalapdisable = 'Disable "Total AP"',
		timeToComplete = "Time to complete: ",
		bountyIgnoreFilter = "Emissary quests",
		enigmaHelper = "Enable Enigma Helper",
		barrelsHelper = "Enable Barrels Helper",
		honorIgnoreFilter = "PvP quests",
		ignoreFilter = "Ignore filter for",
		epicIgnoreFilter = '"Golden" quests',
		wantedIgnoreFilter = "WANTED quests",		
		apFormatSetup = "Artifact Power format",
		headerEnable = "Enable header line",
		disabeHighlightNewQuests = "Disable highlight for new quests",
		distance = "Distance",
		disableBountyIcon = "Disable Emissary icons for faction names",
		arrow = "Arrow",
		invasionPoints = "Invasion Points",
		argusMap = "Enable Argus map",
		ignoreList = "Ignore list",
		addQuestsOpposite = "Add quests from the opposite continent",
		hideLegion = "Hide quests from Legion",
		disableArrowMove = "Disable moving",
		shellGameHelper = "Enable Shell Game Helper",
		iconsOnMinimap = "Enable icons on General maps",
		addQuestsArgus = "Add quests from Argus",
		lfgSearchOption = "Enable LFG search",
		lfgAutoinvite = "Set autoinvite option on",
		lfgTypeText = "Type numbers (QuestID) to edit box",
		lfgLeftButtonClick = "Left Click - find group",
		lfgLeftButtonClick2 = "Left Click + shift - find group by name",
		lfgRightButtonClick = "Right Click - create group",
		lfgDisablePopup = "Disable popup in questarea",
		lfgDisableRightClickIcons = "Disable right click on map icons",
		disableRewardIcons = "Enable reward on map icons",
		mapIconsScale = "Map icons scale",
		disableRibbon = "Disable ribbon graphic",
		enableRibbonGeneralMap = "Enable ribbon on general maps",
		enableArrowQuests = "Enable arrow for regular quests",
		tryWithQuestID = "Try by quest ID",
		lfgDisableAll = "Disable all, except LFG",
		lfgDisableAll2 = "All addon settings will be lost. Disable all options, except LFG?",
		lfgDisableEyeRight = "Disable eye for quest tracker on right",
		lfgDisableEyeList = "Hide eye in list",
		listSize = "List size",
		topLine = "Top line",
		bottomLine = "Bottom line",
		unlimited = "Unlimited",
		maxLines = "Max lines",
		lfgDisablePopupLeave = "Disable popup after quest completion (leave party)",
	} or
	locale == "koKR" and {
		gear = "장비",
		gold = "골드",
		blood = "살게라스의 피",
		knowledgeTooltip = "** 다음 유물 지식 레벨에 도달한 후 완료할 수 있습니다",
		disableArrow = "화살표 비활성화",
		anchor = "고정기",
		totalap = "총 유물력: ",
		totalapdisable = '"총 유물력" 비활성화',
		timeToComplete = "완료까지 시간: ",
		bountyIgnoreFilter = "사절 퀘스트",
		enigmaHelper = "수수께끼 도우미 활성화",
		barrelsHelper = "통 토우미 활성화",
		honorIgnoreFilter = "PvP 퀘스트",
		ignoreFilter = "다음에 필터 무시",
		epicIgnoreFilter = '"금테" 퀘스트',
		wantedIgnoreFilter = "현상수배 퀘스트", 
		apFormatSetup = "유물력 형식",
		headerEnable = "제목 줄 활성화",
		disabeHighlightNewQuests = "새로운 퀘스트 강조 비활성화",
		distance = "거리",
		disableBountyIcon = "평판 이름에 사절 아이콘 비활성화",
		arrow = "화살표",
		invasionPoints = "침공 거점",
		argusMap = "아르거스 지도 활성화",
		ignoreList = "Ignore list",
		addQuestsOpposite = "Add quests from the opposite continent",
		hideLegion = "Hide quests from Legion",
		disableArrowMove = "Disable moving",
		shellGameHelper = "Enable Shell Game Helper",
		iconsOnMinimap = "Enable icons on General maps",
		addQuestsArgus = "Add quests from Argus",
		lfgSearchOption = "Enable LFG search",
		lfgAutoinvite = "Set autoinvite option on",
		lfgTypeText = "Type numbers (QuestID) to edit box",
		lfgLeftButtonClick = "Left Click - find group",
		lfgLeftButtonClick2 = "Left Click + shift - find group by name",
		lfgRightButtonClick = "Right Click - create group",
		lfgDisablePopup = "Disable popup in questarea",
		lfgDisableRightClickIcons = "Disable right click on map icons",
		disableRewardIcons = "Enable reward on map icons",
		mapIconsScale = "Map icons scale",
		disableRibbon = "Disable ribbon graphic",
		enableRibbonGeneralMap = "Enable ribbon on general maps",
		enableArrowQuests = "Enable arrow for regular quests",
		tryWithQuestID = "Try by quest ID",
		lfgDisableAll = "Disable all, except LFG",
		lfgDisableAll2 = "All addon settings will be lost. Disable all options, except LFG?",
		lfgDisableEyeRight = "Disable eye for quest tracker on right",
		lfgDisableEyeList = "Hide eye in list",
		listSize = "List size",
		topLine = "Top line",
		bottomLine = "Bottom line",
		unlimited = "Unlimited",
		maxLines = "Max lines",
		lfgDisablePopupLeave = "Disable popup after quest completion (leave party)",
	} or
	locale == "zhCN" and {	--by sprider00
		gear = "装备",
		gold = "金币合计",
		blood = "萨格拉斯之血",
		knowledgeTooltip = "** 在达到下个神器知识等级后完成",
		disableArrow = "关闭箭头",
		anchor = "列表显示位置",
		totalap = "神器点数: ",
		totalapdisable = '不显示奖励合计',
		timeToComplete = "将在此时间后完成: ",
		bountyIgnoreFilter = "宝箱任务",
		enigmaHelper = "启用'破解秘密'助手",
		barrelsHelper = "启用'欢乐桶'助手",
		honorIgnoreFilter = "PvP 任务",
		ignoreFilter = "不过滤：",
		epicIgnoreFilter = '精英任务',
		wantedIgnoreFilter = "通缉任务", 
		apFormatSetup = "神器点显示格式",
		headerEnable = "显示标题栏",
		disabeHighlightNewQuests = "关闭新任务高亮",
		distance = "距离",
		disableBountyIcon = "关闭列表中大使任务的阵营图标",
		arrow = "箭头",
		invasionPoints = "入侵点",
		argusMap = "启用阿古斯地图",
		ignoreList = "查看屏蔽列表",
		addQuestsOpposite = "添加对立阵营地图的任务",
		hideLegion = "隐藏军团版本的任务",
		disableArrowMove = "禁止移动",
		shellGameHelper = "启用龟壳游戏助手",
		iconsOnMinimap = "在大地图上显示任务图标",
		addQuestsArgus = "添加阿古斯任务",
		lfgSearchOption = "启用预创建队伍查找按钮",
		lfgAutoinvite = "开启自动邀请选项",
		lfgTypeText = "在输入框中输入数字(任务ID)",
		lfgLeftButtonClick = "左键点击 - 查找队伍",
		lfgLeftButtonClick2 = "SHIFT+左键 - 按名称查找队伍",
		lfgRightButtonClick = "右键点击 - 创建队伍",
		lfgDisablePopup = "禁止自动弹出组队框",
		lfgDisableRightClickIcons = "禁用任务图标右键互动",
		disableRewardIcons = "图标上显示奖励",
		mapIconsScale = "任务图标缩放",
		disableRibbon = "隐藏奖励图标下方的装饰",
		enableRibbonGeneralMap = "显示大地图的图标装饰",
		enableArrowQuests = "一般任务也启用箭头",
		tryWithQuestID = "用任务ID尝试",
		lfgDisableAll = "禁用除了寻求组队的其他全部",
		lfgDisableAll2 = "设置将丢失，是否禁用除了寻求组队的其他全部选项?",
		lfgDisableEyeRight = "追踪的任务禁用眼睛",
		lfgDisableEyeList = "任务列表中禁用眼睛",
		listSize = "列表大小",
		topLine = "名称列",
		bottomLine = "总数列",
		unlimited = "无限制",
		maxLines = "列数上限",
		lfgDisablePopupLeave = "任务结束后不自动弹出离队提示",
	} or
	locale == "zhTW" and {	--by sprider00
		gear = "裝備",
		gold = "金幣",
		blood = "薩格拉斯之血",
		knowledgeTooltip = "** 可在達到下一個神器知識等級後完成",
		disableArrow = "禁用 箭頭",
		anchor = "外掛程式位置",
		totalap = "神兵之力總數：",
		totalapdisable = '禁用 "神兵之力總數"',
		timeToComplete = "剩餘時間：",
		bountyIgnoreFilter = "寶箱任務",
		enigmaHelper = "開啟迷宮助手",
		barrelsHelper = "開啟桶樂會助手",
		honorIgnoreFilter = "PvP 任務",
		ignoreFilter = "不過濾：",
		epicIgnoreFilter = '精英任務',
		wantedIgnoreFilter = "通緝任務", 
		apFormatSetup = "神兵之力數位格式",
		headerEnable = "開啟 標題行",
		disabeHighlightNewQuests = "禁用新任務高亮",
		distance = "距離",
		disableBountyIcon = "大使任務不在清單中顯示派系圖示",
		arrow = "箭頭",
		invasionPoints = "入侵點",
		argusMap = "啟用阿古斯地圖",
		ignoreList = "忽略列表",
		addQuestsOpposite = "顯示對面地圖的任務",
		hideLegion = "隱藏軍團入侵的任務",
		disableArrowMove = "鎖定箭頭位置",
		shellGameHelper = "開啟龜殼遊戲助手",
		iconsOnMinimap = "大地圖上顯示任務圖示",
		addQuestsArgus = "顯示阿古斯的任務",
		lfgSearchOption = "啟用預組搜索",
		lfgAutoinvite = "自動邀請設定",
		lfgTypeText = "輸入任務ID",
		lfgLeftButtonClick = "左鍵 - 尋找隊伍（任務ID）",
		lfgLeftButtonClick2 = "SHIFT + 左鍵 - 尋找隊伍（任務名稱）",
		lfgRightButtonClick = "右鍵 - 編組隊伍",
		lfgDisablePopup = "禁止自動彈出組隊框架",
		lfgDisableRightClickIcons = "禁用任務圖示右鍵互動",
		disableRewardIcons = "地圖圖標顯示獎勵",
		mapIconsScale = "地圖圖標大小",
		disableRibbon = "禁用背景條",
		enableRibbonGeneralMap = "大地圖圖標上顯示背景條",
		enableArrowQuests = "一般任務啟用箭頭",
		tryWithQuestID = "刷新任務ID",
		lfgDisableAll = "禁用所有設定，除了預組",
		lfgDisableAll2 = "所有設定將會丟失。確定禁用所有設定，除了預組？",
		lfgDisableEyeRight = "追蹤任務禁用眼睛",
		lfgDisableEyeList = "任務列表禁用眼睛",
		listSize = "列表大小",
		topLine = "名稱列",
		bottomLine = "總數列",
		unlimited = "無限制",
		maxLines = "列數上限",
		lfgDisablePopupLeave = "任務結束后不自動彈出離隊提示",
	} or 
	{
		gear = "Gear",
		gold = "Gold",
		blood = "Blood of Sargeras",
		knowledgeTooltip = "** Can be completed after reaching next artifact knowledge level",
		disableArrow = "Disable arrow",
		anchor = "Anchor",
		totalap = "Total Artifact Power: ",
		totalapdisable = 'Disable "Total AP"',
		timeToComplete = "Time to complete: ",
		bountyIgnoreFilter = "Emissary quests",
		enigmaHelper = "Enable Enigma Helper",
		barrelsHelper = "Enable Barrels Helper",
		honorIgnoreFilter = "PvP quests",
		ignoreFilter = "Ignore filter for",
		epicIgnoreFilter = '"Golden" quests',
		wantedIgnoreFilter = "WANTED quests",
		apFormatSetup = "Artifact Power format",
		headerEnable = "Enable header line",
		disabeHighlightNewQuests = "Disable highlight for new quests",
		distance = "Distance",
		disableBountyIcon = "Disable Emissary icons for faction names",
		arrow = "Arrow",
		invasionPoints = "Invasion Points",
		argusMap = "Enable Argus map",
		ignoreList = "Ignore list",
		addQuestsOpposite = "Add quests from the opposite continent",
		hideLegion = "Hide quests from Legion",
		disableArrowMove = "Disable moving",
		shellGameHelper = "Enable Shell Game Helper",
		iconsOnMinimap = "Enable icons on General maps",
		addQuestsArgus = "Add quests from Argus",
		lfgSearchOption = "Enable LFG search",
		lfgAutoinvite = "Set autoinvite option on",
		lfgTypeText = "Type numbers (QuestID) to edit box",
		lfgLeftButtonClick = "Left Click - find group",
		lfgLeftButtonClick2 = "Left Click + shift - find group by name",
		lfgRightButtonClick = "Right Click - create group",
		lfgDisablePopup = "Disable popup in questarea",
		lfgDisableRightClickIcons = "Disable right click on map icons",
		disableRewardIcons = "Enable reward on map icons",
		mapIconsScale = "Map icons scale",
		disableRibbon = "Disable ribbon graphic",
		enableRibbonGeneralMap = "Enable ribbon on general maps",
		enableArrowQuests = "Enable arrow for regular quests",
		tryWithQuestID = "Try by quest ID",
		lfgDisableAll = "Disable all, except LFG",
		lfgDisableAll2 = "All addon settings will be lost. Disable all options, except LFG?",
		lfgDisableEyeRight = "Disable eye for quest tracker on right",
		lfgDisableEyeList = "Hide eye in list",
		listSize = "List size",
		topLine = "Top line",
		bottomLine = "Bottom line",
		unlimited = "Unlimited",
		maxLines = "Max lines",
		lfgDisablePopupLeave = "Disable popup after quest completion (leave party)",
	}

local filters = {
	{LOCALE.gear,2^0},
	{LE.ARTIFACT_POWER,2^1},
	{LE.ORDER_RESOURCES_NAME_LEGION,2^2},
	{LOCALE.blood,2^5},
	{LOCALE.gold,2^3},
	{OTHER,2^4},
}
local ActiveFilter = 2 ^ #filters - 1
local ActiveFilterType

local ActiveSort = 5

local WorldMapHideWQLCheck
local UpdateScale
local UpdateAnchor

local FIRST_NUMBER, SECOND_NUMBER, THIRD_NUMBER, FOURTH_NUMBER = FIRST_NUMBER, SECOND_NUMBER, THIRD_NUMBER, FOURTH_NUMBER

if SECOND_NUMBER then
	if locale == "deDE" or locale == "frFR" then
		SECOND_NUMBER = SECOND_NUMBER:match("|7([^:]+):")
		THIRD_NUMBER = THIRD_NUMBER:match("|7([^:]+):")
		FOURTH_NUMBER = FOURTH_NUMBER:match("|7([^:]+):")
	elseif locale == "ptBR" then
		SECOND_NUMBER = SECOND_NUMBER:match("|7([^h]+h)")
		THIRD_NUMBER = THIRD_NUMBER:match("|7([^h]+h)")
		FOURTH_NUMBER = FOURTH_NUMBER:match("|7([^h]+h)")
	elseif locale == "esES" or locale == "esMX" then
		SECOND_NUMBER = SECOND_NUMBER:match("|7([^l]+ll)")
		FOURTH_NUMBER = FOURTH_NUMBER:match("|7([^l]+ll)")
	elseif locale == "itIT" then
		SECOND_NUMBER = SECOND_NUMBER:match("|7([^:]+).:")
		THIRD_NUMBER = THIRD_NUMBER:match("|7([^:]+).:")
		FOURTH_NUMBER = FOURTH_NUMBER:match("|7([^:]+).:")
	end
end

local ELib = WQLdb.ELib

local WorldQuestList_Update

local UpdateTicker = nil

local function AddArrow(x,y,questID,name,hideRange)
	if VWQL.DisableArrow or VWQL.ArrowStyle == 2 then
		return
	end
	WQLdb.Arrow:ShowRunTo(x,y,hideRange or 40,nil,true)
end

local TomTomCache = {}
local function AddArrowNWC(x,y,mapID,questID,name,hideRange)
	if VWQL.DisableArrow or VWQL.ArrowStyle ~= 2 then
		return
	end
	if type(TomTom)=='table' and type(TomTom.AddWaypoint)=='function' then
		local uid = TomTom:AddWaypoint(mapID, x, y, {title = name})
		TomTomCache[questID or 0] = uid
	end
end

local WorldQuestList

local WorldQuestList_Width = 330+6+4 --163ui 450+70
local WorldQuestList_ZoneWidth = 75
local TOTAL_WIDTH = WorldQuestList_Width + WorldQuestList_ZoneWidth

--local WorldMapFrame = TestWorldMapFrame
local WorldMapButton = WorldMapFrame.ScrollContainer.Child

WorldQuestList = CreateFrame("Frame","WorldQuestsListFrame",WorldMapFrame)
WorldQuestList:SetPoint("TOPLEFT",WorldMapFrame,"TOPRIGHT",10,-4)
WorldQuestList:SetSize(550,300)

_G.WorldQuestList = WorldQuestList

if WQLdb.ToMain then
	for k,v in pairs(WQLdb.ToMain) do
		if not WorldQuestList[k] then
			WorldQuestList[k] = v
		end
	end
end

WorldQuestList:SetScript("OnHide",function(self)
	WorldQuestList.IsSoloRun = false
	if not (VWQL.Anchor == 3) then
		WorldQuestList.moveHeader:Hide()
	end
	if self:GetParent() ~= WorldMapFrame then
		self:SetParent(WorldMapFrame)
		UpdateAnchor()
	end
	WorldQuestList.Cheader:SetVerticalScroll(0)
	WorldQuestList.Close:Hide()
end)
WorldQuestList:SetScript("OnShow",function(self)
	if not WorldQuestList.IsSoloRun then
		--UpdateAnchor(true)
	end
	C_Timer.After(2.5,function()
		UpdateTicker = true
	end)
end)

WorldQuestList.Cheader = CreateFrame("ScrollFrame", nil, WorldQuestList) 
WorldQuestList.Cheader:SetPoint("LEFT")
WorldQuestList.Cheader:SetPoint("RIGHT")
WorldQuestList.Cheader:SetPoint("BOTTOM")
WorldQuestList.Cheader:SetPoint("TOP")

WorldQuestList.Cheader.lines = {}
for i=1,100 do
	local line = CreateFrame("Frame",nil,WorldQuestList.Cheader)
	line:SetPoint("TOPLEFT",0,-(i-1)*16)
	line:SetSize(1,16)
	WorldQuestList.Cheader.lines[i] = line
end

WorldQuestList.C = CreateFrame("Frame", nil, WorldQuestList.Cheader) 
WorldQuestList.Cheader:SetScrollChild(WorldQuestList.C)
WorldQuestList.Cheader:SetScript("OnMouseWheel", function (self,delta)
	delta = delta * 16
	local max = max(0 , WorldQuestList.C:GetHeight() - self:GetHeight() )
	local val = self:GetVerticalScroll()
	if (val - delta) < 0 then
		self:SetVerticalScroll(0)
	elseif (val - delta) > max then
		self:SetVerticalScroll(max)
	else
		self:SetVerticalScroll(val - delta)
	end
end)
WorldQuestList.C:SetWidth(WorldQuestList_Width)

local function UpdateScrollButtonsState()
	local val = WorldQuestList.Cheader:GetVerticalScroll()

	if val > 3.5 then
		WorldQuestList.ScrollUpLine:Show()
	else
		WorldQuestList.ScrollUpLine:Hide()
	end
	
	local maxScroll = WorldQuestList.Cheader:GetVerticalScrollRange()
	if maxScroll > 4.5 and not ((maxScroll - val) < 5) then
		WorldQuestList.ScrollDownLine:Show()
	else
		WorldQuestList.ScrollDownLine:Hide()
	end
	
	if WorldQuestList.currentResult and #WorldQuestList.currentResult == 0 then
		WorldQuestList.ScrollUpLine:Hide()
		WorldQuestList.ScrollDownLine:Hide()
	end
end

WorldQuestList.Cheader:SetScript("OnVerticalScroll",function(self,val)
	UpdateScrollButtonsState()
end)

WorldQuestList.SCROLL_FIX_BOTTOM = 0
WorldQuestList.SCROLL_FIX_TOP = 0

WorldQuestList.ScrollDownLine = CreateFrame("Button", nil, WorldQuestList)
WorldQuestList.ScrollDownLine:SetPoint("LEFT",0,0)
WorldQuestList.ScrollDownLine:SetPoint("RIGHT",0,0)
WorldQuestList.ScrollDownLine:SetPoint("BOTTOM",WorldQuestList.Cheader,0,-1)
WorldQuestList.ScrollDownLine:SetHeight(16)
WorldQuestList.ScrollDownLine:SetFrameLevel(120)
WorldQuestList.ScrollDownLine:Hide()
WorldQuestList.ScrollDownLine:SetScript("OnEnter",function(self)
	self.entered = true
	self.timer = C_Timer.NewTicker(.05,function(timer)
		if not self.entered then
			timer:Cancel()
			self.timer = nil
			return
		end
		local limit = WorldQuestList.C:GetHeight()
		local curr = WorldQuestList.Cheader:GetVerticalScroll()
		WorldQuestList.Cheader:SetVerticalScroll(min(curr + 4,limit - WorldQuestList.Cheader:GetHeight() + 14))
	end)
end)
WorldQuestList.ScrollDownLine:SetScript("OnLeave",function(self)
	self.entered = nil
end)
WorldQuestList.ScrollDownLine:SetScript("OnHide",function(self)
	if self.timer then
		self.timer:Cancel()
	end
	self.timer = nil
	self.entered = nil
end)
WorldQuestList.ScrollDownLine:SetScript("OnClick",function(self)
	local limit = WorldQuestList.C:GetHeight()
	WorldQuestList.Cheader:SetVerticalScroll(limit - WorldQuestList.Cheader:GetHeight())
end)

WorldQuestList.ScrollDownLine.b = WorldQuestList.ScrollDownLine:CreateTexture(nil,"BACKGROUND")
WorldQuestList.ScrollDownLine.b:SetAllPoints()
WorldQuestList.ScrollDownLine.b:SetColorTexture(.3,.3,.3,.9)

WorldQuestList.ScrollDownLine.i = WorldQuestList.ScrollDownLine:CreateTexture(nil,"ARTWORK")
WorldQuestList.ScrollDownLine.i:SetTexture("Interface\\AddOns\\WorldQuestsList\\navButtons")
WorldQuestList.ScrollDownLine.i:SetPoint("CENTER")
WorldQuestList.ScrollDownLine.i:SetTexCoord(0,.25,0,1)
WorldQuestList.ScrollDownLine.i:SetSize(14,14)


local _BonusObjectiveTracker_TrackWorldQuest, _BonusObjectiveTracker_UntrackWorldQuest = BonusObjectiveTracker_TrackWorldQuest, BonusObjectiveTracker_UntrackWorldQuest
local lastTrackedQuestID = nil
local BonusObjectiveTracker_TrackWorldQuest = function(questID, hardWatch)
	if InCombatLockdown() then
		if AddWorldQuestWatch(questID, hardWatch) then
			if lastTrackedQuestID and lastTrackedQuestID ~= questID then
				if not IsWorldQuestHardWatched(lastTrackedQuestID) and hardWatch then
					AddWorldQuestWatch(lastTrackedQuestID, true) -- Promote to a hard watch
				end
			end
			lastTrackedQuestID = questID
		end
	
		if not hardWatch or GetSuperTrackedQuestID() == 0 then
			SetSuperTrackedQuestID(questID)
		end
	else
		return _BonusObjectiveTracker_TrackWorldQuest(questID, hardWatch)
	end
end

local BonusObjectiveTracker_UntrackWorldQuest = function(questID)
	if InCombatLockdown() then
		if RemoveWorldQuestWatch(questID) then
			if lastTrackedQuestID == questID then
				lastTrackedQuestID = nil
			end
			if questID == GetSuperTrackedQuestID() then
				QuestSuperTracking_ChooseClosestQuest()
			end
		end
	else
		return _BonusObjectiveTracker_UntrackWorldQuest(questID)
	end
end

WorldQuestList.ScrollUpLine = CreateFrame("Button", nil, WorldQuestList)
WorldQuestList.ScrollUpLine:SetPoint("LEFT",0,0)
WorldQuestList.ScrollUpLine:SetPoint("RIGHT",0,0)
WorldQuestList.ScrollUpLine:SetPoint("TOP",WorldQuestList.Cheader,0,0)
WorldQuestList.ScrollUpLine:SetHeight(16)
WorldQuestList.ScrollUpLine:SetFrameLevel(120)
WorldQuestList.ScrollUpLine:Hide()
WorldQuestList.ScrollUpLine:SetScript("OnEnter",function(self)
	self.entered = true
	self.timer = C_Timer.NewTicker(.05,function(timer)
		if not self.entered then
			timer:Cancel()
			self.timer = nil
			return
		end
		local limit = WorldQuestList.C:GetHeight()
		local curr = WorldQuestList.Cheader:GetVerticalScroll()
		WorldQuestList.Cheader:SetVerticalScroll(max(curr - 4,0))
	end)
end)
WorldQuestList.ScrollUpLine:SetScript("OnLeave",function(self)
	self.entered = nil
end)
WorldQuestList.ScrollUpLine:SetScript("OnHide",function(self)
	if self.timer then
		self.timer:Cancel()
	end
	self.timer = nil
	self.entered = nil
end)
WorldQuestList.ScrollUpLine:SetScript("OnClick",function(self)
	WorldQuestList.Cheader:SetVerticalScroll(0)
end)

WorldQuestList.ScrollUpLine.b = WorldQuestList.ScrollUpLine:CreateTexture(nil,"BACKGROUND")
WorldQuestList.ScrollUpLine.b:SetAllPoints()
WorldQuestList.ScrollUpLine.b:SetColorTexture(.3,.3,.3,.9)

WorldQuestList.ScrollUpLine.i = WorldQuestList.ScrollUpLine:CreateTexture(nil,"ARTWORK")
WorldQuestList.ScrollUpLine.i:SetTexture("Interface\\AddOns\\WorldQuestsList\\navButtons")
WorldQuestList.ScrollUpLine.i:SetPoint("CENTER")
WorldQuestList.ScrollUpLine.i:SetTexCoord(.25,.5,0,1)
WorldQuestList.ScrollUpLine.i:SetSize(14,14)

WorldQuestList.b = WorldQuestList:CreateTexture(nil,"BACKGROUND")
WorldQuestList.b:SetAllPoints()
WorldQuestList.b:SetColorTexture(0.04,0.04,0.04,.97)
WorldQuestList.b.A = .97

WorldQuestList.backdrop = CreateFrame("Frame",nil,WorldQuestList)
WorldQuestList.backdrop:SetAllPoints()

ELib.Templates:Border(WorldQuestList.backdrop,.3,.3,.3,1,1)
WorldQuestList.shadow = ELib:Shadow(WorldQuestList.backdrop,20,28)

WorldQuestList.mapC = WorldMapButton:CreateTexture(nil,"OVERLAY")
WorldQuestList.mapC:SetSize(50,50)
WorldQuestList.mapC:SetTexture("Interface\\AddOns\\WorldQuestsList\\Button-Pushed")
WorldQuestList.mapC:Hide()

WorldQuestList.mapC = CreateFrame("Frame", nil, WorldMapButton)
WorldQuestList.mapC:SetFrameStrata("TOOLTIP")
WorldQuestList.mapC:SetSize(3,3)
WorldQuestList.mapC:Hide()

WorldQuestList.mapCs = WorldQuestList.mapC:CreateTexture(nil,"OVERLAY",nil,7)
WorldQuestList.mapCs:SetSize(50*3,50*3)
WorldQuestList.mapCs:SetTexture("Interface\\AddOns\\WorldQuestsList\\Button-Pushed")
WorldQuestList.mapCs:SetPoint("CENTER")
WorldQuestList.mapC:Hide()

WorldQuestList.mapD = WorldQuestList.mapC:CreateTexture(nil,"OVERLAY",nil,7)
WorldQuestList.mapD:SetSize(24*3,24*3)
WorldQuestList.mapD:SetAtlas("XMarksTheSpot")
WorldQuestList.mapD:SetPoint("CENTER",WorldQuestList.mapC)
WorldQuestList.mapD:Hide()

WorldQuestList.Close = CreateFrame("Button",nil,WorldQuestList)
WorldQuestList.Close:SetPoint("BOTTOMLEFT",WorldQuestList,"TOPRIGHT",1,1)
WorldQuestList.Close:SetSize(22,22)
WorldQuestList.Close:SetScript("OnClick",function()
	WorldQuestList:Hide()
	if not (WorldMapFrame:IsVisible() and WorldMapFrame:IsMaximized() and (VWQL.Anchor == 1 or not VWQL.Anchor)) then
		WorldQuestList:Show()
	end
end)
WorldQuestList.Close:Hide()

ELib.Templates:Border(WorldQuestList.Close,.22,.22,.3,1,1)
WorldQuestList.Close.shadow = ELib:Shadow2(WorldQuestList.Close,16)

WorldQuestList.Close.X = WorldQuestList.Close:CreateFontString(nil,"ARTWORK","GameFontWhite")
WorldQuestList.Close.X:SetPoint("CENTER",WorldQuestList.Close)
WorldQuestList.Close.X:SetText("X")
do
	local a1,a2 = WorldQuestList.Close.X:GetFont()
	WorldQuestList.Close.X:SetFont(a1,14)
end
WorldQuestList.Close.b = WorldQuestList.Close:CreateTexture(nil,"BACKGROUND")
WorldQuestList.Close.b:SetAllPoints()
WorldQuestList.Close.b:SetColorTexture(0.14,0.04,0.04,.97)

WorldQuestList.Close.hl = WorldQuestList.Close:CreateTexture(nil, "BACKGROUND",nil,1)
WorldQuestList.Close.hl:SetPoint("TOPLEFT", 0, 0)
WorldQuestList.Close.hl:SetPoint("BOTTOMRIGHT", 0, 0)
WorldQuestList.Close.hl:SetTexture("Interface\\Buttons\\WHITE8X8")
WorldQuestList.Close.hl:SetVertexColor(1,.7,.7,.25)
WorldQuestList.Close.hl:Hide()

WorldQuestList.Close:SetScript("OnEnter",function(self) self.hl:Show() end)
WorldQuestList.Close:SetScript("OnLeave",function(self) self.hl:Hide() end)


local ArrowsHelpFrame = CreateFrame("Frame",nil,WorldMapButton) 
ArrowsHelpFrame:SetFrameStrata("TOOLTIP")
ArrowsHelpFrame:SetSize(40,40)
ArrowsHelpFrame:SetPoint("CENTER")
ArrowsHelpFrame:Hide()
ArrowsHelpFrame.t = -1
ArrowsHelpFrame:SetScript("OnShow",function(self)
	self.t = 3
	self.map = GetCurrentMapAreaID()
end)
ArrowsHelpFrame:SetScript("OnUpdate",function(self,tmr)
	self.t = self.t - tmr
	if self.t <= 0 or self.map ~= GetCurrentMapAreaID() then
		self:Hide()
		return
	end
end)
WorldQuestList.ArrowsHelpFrame = ArrowsHelpFrame

ArrowsHelpFrame.top = CreateFrame("PlayerModel",nil,ArrowsHelpFrame)
ArrowsHelpFrame.top:SetPoint("BOTTOM",ArrowsHelpFrame,"TOP",0,0)
ArrowsHelpFrame.top:SetSize(48,48)
ArrowsHelpFrame.top:SetMouseClickEnabled(false)
ArrowsHelpFrame.top:SetMouseMotionEnabled(false)
ArrowsHelpFrame.top:SetDisplayInfo(63509)
ArrowsHelpFrame.top:SetRoll(0)

ArrowsHelpFrame.bottom = CreateFrame("PlayerModel",nil,ArrowsHelpFrame)
ArrowsHelpFrame.bottom:SetPoint("TOP",ArrowsHelpFrame,"BOTTOM",0,0)
ArrowsHelpFrame.bottom:SetSize(48,48)
ArrowsHelpFrame.bottom:SetMouseClickEnabled(false)
ArrowsHelpFrame.bottom:SetMouseMotionEnabled(false)
ArrowsHelpFrame.bottom:SetDisplayInfo(63509)
ArrowsHelpFrame.bottom:SetRoll(-math.pi)

ArrowsHelpFrame.left = CreateFrame("PlayerModel",nil,ArrowsHelpFrame)
ArrowsHelpFrame.left:SetPoint("RIGHT",ArrowsHelpFrame,"LEFT",0,0)
ArrowsHelpFrame.left:SetSize(48,48)
ArrowsHelpFrame.left:SetMouseClickEnabled(false)
ArrowsHelpFrame.left:SetMouseMotionEnabled(false)
ArrowsHelpFrame.left:SetDisplayInfo(63509)
ArrowsHelpFrame.left:SetRoll(math.pi / 2)

ArrowsHelpFrame.right = CreateFrame("PlayerModel",nil,ArrowsHelpFrame)
ArrowsHelpFrame.right:SetPoint("LEFT",ArrowsHelpFrame,"RIGHT",0,0)
ArrowsHelpFrame.right:SetSize(48,48)
ArrowsHelpFrame.right:SetMouseClickEnabled(false)
ArrowsHelpFrame.right:SetMouseMotionEnabled(false)
ArrowsHelpFrame.right:SetDisplayInfo(63509)
ArrowsHelpFrame.right:SetRoll(-math.pi / 2)



WorldQuestList:RegisterEvent('ADDON_LOADED')
if UnitLevel'player' < 120 then
	WorldQuestList:RegisterEvent('PLAYER_LEVEL_UP')
end
WorldQuestList:RegisterEvent('QUEST_REMOVED')
WorldQuestList:SetScript("OnEvent",function(self,event,...)
	if event == 'ADDON_LOADED' then
		self:UnregisterEvent('ADDON_LOADED')

		if type(_G.VWQL)~='table' then
			_G.VWQL = {
				VERSION = VERSION,
				Scale = 0.8,
				DisableIconsGeneralMap947 = true,
                DisableLFG_Popup = true,
				AzeriteFormat = 20,
				--DisableRewardIcons = true,
                DisableLFG_PopupLeave = true,
				HideLegion = true,
            }
		end
		VWQL = _G.VWQL
        if VWQL.DisableLFG_PopupLeave == nil then VWQL.DisableLFG_PopupLeave = true end
        if VWQL.DisableLFG_Popup == nil then VWQL.DisableLFG_Popup = true end
				
		VWQL[charKey] = VWQL[charKey] or {}
		
		VWQL[charKey].Quests = VWQL[charKey].Quests or {}
		
		VWQL[charKey].Filter = VWQL[charKey].Filter and tonumber(VWQL[charKey].Filter) or ActiveFilter
		ActiveFilter = VWQL[charKey].Filter
		
		VWQL[charKey].FilterType = VWQL[charKey].FilterType or {}
		ActiveFilterType = VWQL[charKey].FilterType
		
		VWQL.Sort = VWQL.Sort and tonumber(VWQL.Sort) or ActiveSort
		ActiveSort = VWQL.Sort
		
		VWQL.Ignore = VWQL.Ignore or {}
        if VWQL.ArgusMap == nil then VWQL.ArgusMap = true end

		WorldMapHideWQLCheck:SetChecked(not VWQL[charKey].HideMap)
		
		if not (type(VWQL[charKey].VERSION)=='number') or VWQL[charKey].VERSION < 51 then
			WorldQuestList:ForceModeCheck()
		end
		if not (type(VWQL.VERSION)=='number') or VWQL.VERSION < 51 then
			VWQL.AzeriteFormat = 20
			VWQL.DisableIconsGeneralMap947 = true
		end
		if not (type(VWQL.VERSION)=='number') or VWQL.VERSION < 66 then
			--VWQL.DisableRewardIcons = true
		end
		if not (type(VWQL.VERSION)=='number') or VWQL.VERSION < 69 then
			if type(VWQL.MapIconsScale)=='number' and VWQL.MapIconsScale < 1 then
				VWQL.MapIconsScale = 1
			end
		end
		if not (type(VWQL.VERSION)=='number') or VWQL.VERSION < 71 then
			VWQL.Anchor3PosLeft = nil
			VWQL.Anchor3PosTop = nil
		end
		
		WorldQuestList.modeSwitcherCheck:AutoSetValue()

		UpdateScale()
		UpdateAnchor()
		WorldQuestList.header:Update()
		
		WorldQuestList.ViewAllButton:Update()
		
		if WQLdb.Arrow then
			if VWQL.Arrow_PointX and VWQL.Arrow_PointY and VWQL.Arrow_Point1 and VWQL.Arrow_Point2 then
				WQLdb.Arrow:LoadPosition(VWQL.Arrow_Point1,UIParent,VWQL.Arrow_Point2,VWQL.Arrow_PointX,VWQL.Arrow_PointY)
			else
				WQLdb.Arrow:LoadPosition("TOP",UIParent,"TOP",0,-100)
			end
			
			if VWQL.Arrow_Scale then
				WQLdb.Arrow:Scale(tonumber(VWQL.Arrow_Scale) or 1)
			end
			
			if VWQL.DisableArrowMove then
				WQLdb.Arrow.frame:SetMovable(false)
			end
		end
		
		if WorldQuestList.QuestCreationBox and VWQL.AnchorQCBLeft and VWQL.AnchorQCBTop then
			WorldQuestList.QuestCreationBox:ClearAllPoints()
			WorldQuestList.QuestCreationBox:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VWQL.AnchorQCBLeft,VWQL.AnchorQCBTop)
		end
		
		VWQL.VERSION = VERSION
		VWQL[charKey].VERSION = VERSION	
	elseif event == 'QUEST_REMOVED' then
		local questID = ...
		if questID and TomTomCache[questID] then
			local qKey = TomTomCache[questID]
			if type(qKey) == 'table' and type(TomTom) == 'table' then
				TomTom:RemoveWaypoint(qKey)
			end
		end
	elseif event == "PLAYER_LEVEL_UP" then
		C_Timer.After(1,function()
			WorldQuestList:ForceModeCheck()
		end)
	end
end)


local HookWQbuttons
do
	local hooked = {}
	local hookFunc = function(self,button)
		if self.clickData then
			local x,y = WorldQuestList:GetQuestWorldCoord2(-1,self.clickData.mapID,self.clickData.x,self.clickData.y,true)
			if x and y then
				AddArrow(x,y,nil,nil,5)
			end			
		elseif self.questID then
			local x,y = WorldQuestList:GetQuestWorldCoord(self.questID)
			if x and y then
				local name = C_TaskQuest.GetQuestInfoByQuestID(self.questID) or ""
				AddArrow(x,y,self.questID,name)
			end
			
			local x,y,mapID = WorldQuestList:GetQuestCoord(self.questID)
			if x and y then
				local name = C_TaskQuest.GetQuestInfoByQuestID(self.questID) or ""
				AddArrowNWC(x,y,mapID,self.questID,name)
			end
			
			if (VWQL and not VWQL.DisableLFG and not VWQL.DisableLFG_RightClickIcon) and button == "RightButton" then
				if WorldMapFrame:IsMaximized() and WorldMapFrame:IsVisible() then
					ToggleWorldMap()
				end
				if C_LFGList.CanCreateQuestGroup(self.questID) then
					LFGListUtil_FindQuestGroup(self.questID)
				else
					WorldQuestList.LFG_Search(self.questID)
				end
			end			
			
		end
	end
	local hookQuestFunc = function(self,button)
		if self.questID then
			local x,y = self:GetPosition()
			if x and y then
				x,y = WorldQuestList:GetQuestWorldCoord2(self.questID,GetCurrentMapAreaID(),x,y,true)
				if x and y and VWQL and VWQL.EnableArrowQuest then
					local questIndex = GetQuestLogIndexByID(self.questID)
					local name = GetQuestLogTitle(questIndex) or ""
					AddArrow(x,y,self.questID,name)
				end
			end
			if (VWQL and not VWQL.DisableLFG and not VWQL.DisableLFG_RightClickIcon) and button == "RightButton" and not IsQuestComplete(self.questID) then
				if WorldMapFrame:IsMaximized() and WorldMapFrame:IsVisible() then
					ToggleWorldMap()
				end
				if C_LFGList.CanCreateQuestGroup(self.questID) then
					LFGListUtil_FindQuestGroup(self.questID)
				else
					WorldQuestList.LFG_Search(self.questID)
				end
			end			
		end
	end
	WorldQuestList.hookClickFunc = hookFunc
	WorldQuestList.hookQuestClickFunc = hookQuestFunc
	function HookWQbuttons()
		if WorldMapFrame.pinPools then
			if WorldMapFrame.pinPools.WorldMap_WorldQuestPinTemplate and WorldMapFrame.pinPools.WorldMap_WorldQuestPinTemplate.activeObjects then
				for button,_ in pairs(WorldMapFrame.pinPools.WorldMap_WorldQuestPinTemplate.activeObjects) do
					if not hooked[button] then
						button:HookScript("OnMouseUp",hookFunc)
						hooked[button] = true
					end
				end
			end
			if WorldMapFrame.pinPools.QuestPinTemplate and WorldMapFrame.pinPools.QuestPinTemplate.activeObjects then
				for button,_ in pairs(WorldMapFrame.pinPools.QuestPinTemplate.activeObjects) do
					if not hooked[button] then
						button:HookScript("OnMouseUp",hookQuestFunc)
						hooked[button] = true
					end
				end
			end
		end
	
	end
end


do
	local realmsDB = WQLdb.RealmRegion or {}
	function WorldQuestList:GetCurrentRegion()
		if WorldQuestList.currentRegion then
			return WorldQuestList.currentRegion
		end
		local guid = UnitGUID("player")
		local _,serverID = strsplit("-",guid)
		local regionID = 0
		if serverID then
			regionID = realmsDB[tonumber(serverID) or -1] or 0
		end
		WorldQuestList.currentRegion = regionID
		return regionID
	end
	
end

do
	local resetTimes = {
		[1] = 1505228400,	--us
		[2] = 1505286000,	--eu
	}
	function WorldQuestList:GetNextResetTime(region)
		if region and resetTimes[region] then
			local t = resetTimes[region]
			local c = GetServerTime()
			while t < c do
				t = t + 604800
			end
			return (t - c) / 60
		end
	end

end

do
	local LegionZones = {
		[619] = true,
		[790] = true,
		[630] = true,
		[627] = true,
		[641] = true,
		[680] = true,
		[650] = true,
		[634] = true,
		[646] = true,
		[905] = true,
		[885] = true,
		[882] = true,
		[830] = true,
	}
	function WorldQuestList:IsLegionZone(mapID)
		mapID = mapID or GetCurrentMapAreaID()
		if LegionZones[mapID] then
			return true
		else
			return false
		end
	end
end

do
	local cache = {}
	function WorldQuestList:GetMapName(mapID)
		if not cache[mapID] then
			cache[mapID] = (C_Map.GetMapInfo(mapID or 0) or {}).name or ("Map ID "..mapID)
		end
		return cache[mapID]
	end
end

do
	local mapIcons = {
		[619] = "|T1339312:16:16:0:0:512:128:246:262:111:126|t",
		[790] = "|T1339312:16:16:0:0:512:128:246:262:111:126|t",
		[630] = "|T1339312:16:16:0:0:512:128:246:262:111:126|t",
		[627] = "|T1339312:16:16:0:0:512:128:246:262:111:126|t",
		[641] = "|T1339312:16:16:0:0:512:128:246:262:111:126|t",
		[680] = "|T1339312:16:16:0:0:512:128:246:262:111:126|t",
		[650] = "|T1339312:16:16:0:0:512:128:246:262:111:126|t",
		[634] = "|T1339312:16:16:0:0:512:128:246:262:111:126|t",
		[646] = "|T1339312:16:16:0:0:512:128:246:262:111:126|t",
		[905] = "|T1339312:16:16:0:0:512:128:246:262:111:126|t",
		[885] = "|T1339312:16:16:0:0:512:128:246:262:111:126|t",
		[882] = "|T1339312:16:16:0:0:512:128:246:262:111:126|t",
		[830] = "|T1339312:16:16:0:0:512:128:246:262:111:126|t",
		[864] = "|TInterface\\FriendsFrame\\PlusManz-Horde:16|t",
		[863] = "|TInterface\\FriendsFrame\\PlusManz-Horde:16|t",
		[862] = "|TInterface\\FriendsFrame\\PlusManz-Horde:16|t",
		[1165] = "|TInterface\\FriendsFrame\\PlusManz-Horde:16|t",
		[875] = "|TInterface\\FriendsFrame\\PlusManz-Horde:16|t",
		[942] = "|TInterface\\FriendsFrame\\PlusManz-Alliance:16|t",
		[896] = "|TInterface\\FriendsFrame\\PlusManz-Alliance:16|t",
		[895] = "|TInterface\\FriendsFrame\\PlusManz-Alliance:16|t",
		[876] = "|TInterface\\FriendsFrame\\PlusManz-Alliance:16|t",	
		[1161] = "|TInterface\\FriendsFrame\\PlusManz-Alliance:16|t",	
		[1169] = "|TInterface\\FriendsFrame\\PlusManz-Alliance:16|t",	
	}
	function WorldQuestList:GetMapIcon(mapID)
		return mapIcons[mapID] or ""
	end
end
do
	local mapColorsOld = {
		[864] = format("%02x%02x%02x",255,149,126),
		[863] = format("%02x%02x%02x",255,220,59),
		[862] = format("%02x%02x%02x",206,225,24),
		[942] = format("%02x%02x%02x",206,225,24),
		[895] = format("%02x%02x%02x",255,220,59),
		[896] = format("%02x%02x%02x",191,160,125),
	}	
	local mapColors = {
		[864] = format("%02x%02x%02x",255,169,186),
		[863] = format("%02x%02x%02x",255,200,100),
		[862] = format("%02x%02x%02x",206,225,84),
		[942] = format("%02x%02x%02x",206,225,84),
		[895] = format("%02x%02x%02x",255,200,100),
		[896] = format("%02x%02x%02x",220,180,165),
	}
	WorldQuestList.mapTextColorData = mapColors
	function WorldQuestList:GetMapTextColor(mapID)
		return mapColors[mapID] and "|cff"..mapColors[mapID] or ""
	end
end


do
	local subZonesList = {
		[630] = true,
		[641] = true,
		[650] = true,
		[634] = true,
		[680] = true,
		[630] = true,
		[646] = true,

		[864] = true,
		[863] = true,
		[862] = true,
		[896] = true,
		[895] = true,
		[942] = true,
	}
	function WorldQuestList:FilterCurrentZone(mapID)
		if subZonesList[mapID] then
			return true
		else
			return false
		end
	end
end

do
	local cache = {}
	WorldQuestList.IsMapParentCache = cache		--debug
	function WorldQuestList:IsMapParent(childMapID,parentMapID)
		if childMapID == parentMapID then
			return true
		elseif not childMapID or not parentMapID then
			return
		end
		
		if cache[childMapID] and cache[childMapID][parentMapID] then
			return cache[childMapID][parentMapID] == 1 and true or false
		end
		cache[childMapID] = cache[childMapID] or {}
		
		local mapInfo = C_Map.GetMapInfo(childMapID)
		while mapInfo do
			if not mapInfo.parentMapID then
				cache[childMapID][parentMapID] = 0
				return
			elseif mapInfo.parentMapID == parentMapID then
				cache[childMapID][parentMapID] = 1
				return true
			end
			mapInfo = C_Map.GetMapInfo(mapInfo.parentMapID)
		end
		cache[childMapID][parentMapID] = 0
	end
end

do
	local cache = {}
	local mapCoords = {	--leftX,topY,rightX,bottomY
		[875] = {8715.9,4520.2,-4914.1,-4569.8},
		[876] = {7546.1,5475.74,-5613.9,-3264.26},
		[619] = {13100.1,7262.13,-5738.08,-5296.69},	--BrokenIsles
		[12] = {17066.6,12799.9,-19733.2,-11733.3},	--Kalimdor
		[13] = {18171.97,11176.34,-22569.21,-15973.34},	--East King
		[113] = {9217.152,10593.38,-8534.246,-1240.89},	--Northrend
		[424] = {8752.86,6679.16,-6762.44,-3664.38},	--Pandaria
		
		[882] = {11545.8,6622.92,8287.5,4450},		--macari
		[830] = {3772.92,2654.17,58.334,177.084},	--krokun
		[885] = {11279.2,-1789.58,7879.17,-4056.25},	--antorus
	}
	function WorldQuestList:GetQuestWorldCoord(questID)
		if cache[questID] then
			return unpack(cache[questID])
		end
		for mapID,mapCoord in pairs(mapCoords) do
			local taskInfo = C_TaskQuest.GetQuestsForPlayerByMapID(mapID)
			for _,info in pairs(taskInfo) do
				if info.questId == questID then
					cache[questID] = {
						mapCoord[1] + (info.x or -1) * (mapCoord[3]-mapCoord[1]),
						mapCoord[2] + (info.y or -1) * (mapCoord[4]-mapCoord[2]),
					}
					return unpack(cache[questID])
				end
			end
		end
	end
	function WorldQuestList:GetQuestCoord(questID)
		for mapID,mapCoord in pairs(mapCoords) do
			local taskInfo = C_TaskQuest.GetQuestsForPlayerByMapID(mapID)
			for _,info in pairs(taskInfo) do
				if info.questId == questID then
					if info.mapID then
						local taskInfo = C_TaskQuest.GetQuestsForPlayerByMapID(info.mapID)
						for _,info in pairs(taskInfo) do
							if info.questId == questID then
								return info.x, info.y, info.mapID
							end
						end
					end
					return nil
				end
			end
		end
	end
	function WorldQuestList:GetQuestWorldCoord2(questID,questMapID,x,y,ignoreCache)
		if cache[questID] and not ignoreCache then
			return unpack(cache[questID])
		end
		for mapID,mapCoord in pairs(mapCoords) do
			local xMin,xMax,yMin,yMax = C_Map.GetMapRectOnMap(questMapID,mapID)
			if xMin ~= xMax and yMin ~= yMax then
				x = xMin + x * (xMax - xMin)
				y = yMin + y * (yMax - yMin)
				
				cache[questID] = {
					mapCoord[1] + (x or -1) * (mapCoord[3]-mapCoord[1]),
					mapCoord[2] + (y or -1) * (mapCoord[4]-mapCoord[2]),
				}
				return unpack(cache[questID])				
			end
		end	
	end
	
	function WorldQuestList:GetQuestCoord_NonWQ(questID,questMapID,currMapID)
		local data = C_QuestLog.GetQuestsOnMap(questMapID)
		if data then
			for i=1,#data do
				if data[i].questID == questID then
					local xMin,xMax,yMin,yMax = C_Map.GetMapRectOnMap(questMapID,currMapID)
					if xMin ~= xMax and yMin ~= yMax then
						return xMin + data[i].x * (xMax - xMin), yMin + data[i].y * (yMax - yMin)
					end
				end
			end
		end
	end	
	
end

do
	local list = {
		[1579] = 2164,
		[1598] = 2163,
		
		[1600] = 2157,
		[1595] = 2156,
		[1597] = 2103,
		[1596] = 2158,
		
		[1599] = 2159,
		[1593] = 2160,
		[1594] = 2162,
		[1592] = 2161,
	}
	local fg_list = {
		[2164] = "Both",
		[2163] = "Both",
		[2157] = "Horde",
		[2156] = "Horde",
		[2103] = "Horde",
		[2158] = "Horde",
		[2159] = "Alliance",
		[2160] = "Alliance",
		[2162] = "Alliance",
		[2161] = "Alliance",
	}
	function WorldQuestList:IsFactionCurrency(currencyID)
		if list[currencyID or 0] then
			return true
		else
			return false
		end
	end

	function WorldQuestList:IsFactionAvailable(factionID)
		factionID = factionID or 0
		if not fg_list[factionID] or fg_list[factionID] == "Both" or UnitFactionGroup("player") == fg_list[factionID] then
			return true
		else
			return false
		end
	end
	
	function WorldQuestList:FactionCurrencyToID(currencyID)
		if list[currencyID or 0] then
			return list[currencyID]
		end
	end
	function WorldQuestList:FactionIDToCurrency(factionID)
		for currencyID,fID in pairs(list) do
			if fID == factionID then
				return currencyID
			end
		end
	end
end

function WorldQuestList:SetMapDot(x,y)
	if not x then
		WorldQuestList.mapC:Hide()
		WorldQuestList.mapD:Hide()
		return
	end
	local size = 46 * WorldMapButton:GetWidth() / 1002
	WorldQuestList.mapCs:SetSize(size,size)
	WorldQuestList.mapD:SetSize(size*0.48,size*0.48)

	WorldQuestList.mapC:ClearAllPoints()
	WorldQuestList.mapC:SetPoint("CENTER",WorldMapButton,"BOTTOMRIGHT",-WorldMapButton:GetWidth() * (1 - x),WorldMapButton:GetHeight() * (1 - y))
	WorldQuestList.mapC:Show()
	WorldQuestList.mapD:Show()
end
function WorldQuestList:SetMapArrowsHelp(x,y)
	local size = 48 * WorldMapButton:GetWidth() / 1002
	ArrowsHelpFrame.top:SetSize(size,size)
	ArrowsHelpFrame.bottom:SetSize(size,size)
	ArrowsHelpFrame.left:SetSize(size,size)
	ArrowsHelpFrame.right:SetSize(size,size)
	ArrowsHelpFrame:SetSize(size*0.6,size*0.6)

	ArrowsHelpFrame:ClearAllPoints()
	ArrowsHelpFrame:SetPoint("CENTER",WorldMapButton,"BOTTOMRIGHT",-WorldMapButton:GetWidth() * (1 - x),WorldMapButton:GetHeight() * (1 - y))
	ArrowsHelpFrame:Show()
end

local function WorldQuestList_Line_OnEnter(self)
	self.hl:Show()

	local data = self.data
	if data.x and data.y and data.mapID then
		WorldQuestList:SetMapDot(data.x,data.y)	
	end
end

local function WorldQuestList_Line_OnLeave(self)
	WorldQuestList:SetMapDot()
	self.hl:Hide()
end

local WorldQuestList_LineName_OnClick
local function WorldQuestList_Line_OnClick(self,button)
	if button == "RightButton" then
		local mapID = GetCurrentMapAreaID()
		local mapInfo = C_Map.GetMapInfo(mapID)
		if mapInfo and mapInfo.parentMapID then
			WorldMapFrame:SetMapID(mapInfo.parentMapID)
		end
    else
        WorldQuestList_LineName_OnClick(self.name,button)
	end
end

local additionalTooltips = {}

local function GetAdditionalTooltip(i,isBottom)
	if not additionalTooltips[i] then
		additionalTooltips[i] = CreateFrame("GameTooltip", "WorldQuestsListAdditionalTooltip"..i, UIParent, "GameTooltipTemplate")
	end
	local tooltip = additionalTooltips[i]
	local owner = nil
	if i == 2 then
		owner = GameTooltip
	else
		owner = additionalTooltips[i - 1]
	end
	tooltip:SetOwner(owner, "ANCHOR_NONE")
	tooltip:ClearAllPoints()
	if isBottom then
		tooltip:SetPoint("TOPLEFT",owner,"BOTTOMLEFT",0,0)
	else
		tooltip:SetPoint("TOPRIGHT",owner,"TOPLEFT",0,0)
	end
	
	return tooltip
end

local function WorldQuestList_LineReward_OnEnter(self)
	local line = self:GetParent()
	if line.reward.ID and GetNumQuestLogRewards(line.reward.ID) > 0 and not line.isRewardLink then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetQuestLogItem("reward", 1, line.reward.ID)
		GameTooltip:Show()
		
		local additional = 2
		if line.reward.IDs then
			for i=2,line.reward.IDs do
				local tooltip = GetAdditionalTooltip(additional)
				tooltip:SetQuestLogItem("reward", i, line.reward.ID)
				tooltip:Show()
				additional = additional + 1
			end
		end
		if line.reward.artifactKnowlege then
			local tooltip = GetAdditionalTooltip(additional,true)
			tooltip:AddLine(LOCALE.knowledgeTooltip)
			if line.reward.timeToComplete then
				local timeLeftMinutes, timeString = line.reward.timeToComplete
				if timeLeftMinutes >= 14400 then
					timeString = ""		--A lot, 10+ days
				elseif timeLeftMinutes >= 1440 then
					timeString = format("%d.%02d:%02d",floor(timeLeftMinutes / 1440),floor(timeLeftMinutes / 60) % 24, timeLeftMinutes % 60)
				else
					timeString = (timeLeftMinutes >= 60 and (floor(timeLeftMinutes / 60) % 24) or "0")..":"..format("%02d",timeLeftMinutes % 60)
				end
			
				tooltip:AddLine(LOCALE.timeToComplete..timeString)
			end
			tooltip:Show()
			additional = additional + 1
		end
		if line.reward:IsTruncated() then
			local text = line.reward:GetText()
			if text and text ~= "" then
				local tooltip = GetAdditionalTooltip(additional,true)
				tooltip:AddLine(text)
				tooltip:Show()
				additional = additional + 1
			end
		end
		
		self:RegisterEvent('MODIFIER_STATE_CHANGED')
	elseif line.reward.ID and line.isRewardLink then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetHyperlink(line.reward.ID)
		GameTooltip:Show()	
		
		if line.reward:IsTruncated() then
			local text = line.reward:GetText()
			if text and text ~= "" then
				local tooltip = GetAdditionalTooltip(2,true)
				tooltip:AddLine(text)
				tooltip:Show()
			end
		end	
	elseif line.reward:IsTruncated() then
		local text = line.reward:GetText()
		if text and text ~= "" then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:AddLine(text)
			GameTooltip:Show()
		end
	end
	if not line.reward.ID and line.reward.artifactKnowlege and line.reward.timeToComplete then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine(LOCALE.knowledgeTooltip)
		local timeLeftMinutes, timeString = line.reward.timeToComplete
		if timeLeftMinutes >= 14400 then
			timeString = ""		--A lot, 10+ days
		elseif timeLeftMinutes >= 1440 then
			timeString = format("%d.%02d:%02d",floor(timeLeftMinutes / 1440),floor(timeLeftMinutes / 60) % 24, timeLeftMinutes % 60)
		else
			timeString = (timeLeftMinutes >= 60 and (floor(timeLeftMinutes / 60) % 24) or "0")..":"..format("%02d",timeLeftMinutes % 60)
		end
		GameTooltip:AddLine(LOCALE.timeToComplete..timeString)
		GameTooltip:Show()	
	end

	WorldQuestList_Line_OnEnter(line)
end
local function WorldQuestList_LineReward_OnLeave(self)
	self:UnregisterEvent('MODIFIER_STATE_CHANGED')
	GameTooltip_Hide()
	GameTooltip:ClearLines()
	WorldQuestList_Line_OnLeave(self:GetParent())
	for _,tip in pairs(additionalTooltips) do
		tip:Hide()
	end
end
local function WorldQuestList_LineReward_OnClick(self,button)
	if button == "LeftButton" then
		local itemLink = self:GetParent().rewardLink
		if not itemLink then
			return
		elseif IsModifiedClick("DRESSUP") then
			return DressUpItemLink(itemLink)
		elseif IsModifiedClick("CHATLINK") then
			if ChatEdit_GetActiveWindow() then
				ChatEdit_InsertLink(itemLink)
			else
				ChatFrame_OpenChat(itemLink)
			end
        else
            WorldQuestList_LineName_OnClick(self,button)
        end
	elseif button == "RightButton" then
		if ( IsModifiedClick("EXPANDITEM") ) then
			local link = self:GetParent().rewardLink
			if link and C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(link) then
				OpenAzeriteEmpoweredItemUIFromLink(link)
				return
			end
		end


		WorldQuestList_Line_OnClick(self:GetParent(),"RightButton")
	end
end
local function WorldQuestList_LineReward_OnEvent(self)
	if self:IsMouseOver() then
		WorldQuestList_LineReward_OnLeave(self)
		WorldQuestList_LineReward_OnEnter(self)
	end
end

local function WorldQuestList_LineFaction_OnEnter(self)
	local tipAdded = nil
	if self.tooltip then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine(self.tooltip)
		GameTooltip:Show()
		tipAdded = true
	end
	if self.reputationList then
		if not tipAdded then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")	
		end
		GameTooltip:AddLine(REPUTATION..":")
		local list = {strsplit(",",self.reputationList)}
		for i=1,#list do
			local factionID = tonumber(list[i])
			if WorldQuestList:IsFactionAvailable(factionID) then
				local name = GetFactionInfoByID(factionID)
				if name then
					local currencyID = WorldQuestList:FactionIDToCurrency(factionID)
					local icon
					if currencyID then
						local _,_,c_icon = GetCurrencyInfo(currencyID)
						if c_icon then
							icon = " (|T"..c_icon..":24|t)"
						end
					end
					GameTooltip:AddLine("- "..name..(icon or ""))
				end
			end
		end
		GameTooltip:Show()
		tipAdded = true
	end
	if self:GetParent().faction:IsTruncated() and self:GetParent().isLeveling then
		local text = self:GetParent().faction:GetText()
		if text and text ~= "" then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:AddLine(text)
			GameTooltip:Show()
		end
	end	
	WorldQuestList_Line_OnEnter(self:GetParent())
end
local function WorldQuestList_LineFaction_OnLeave(self)
	GameTooltip_Hide()
	WorldQuestList_Line_OnLeave(self:GetParent())
end


local function WorldQuestList_LineName_OnEnter(self)
	local line = self:GetParent()
	local questID = line.questID
	if questID and not line.isLeveling then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		local title, factionID = C_TaskQuest.GetQuestInfoByQuestID(questID)
		local tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex = GetQuestTagInfo(questID)
		
		local color = WORLD_QUEST_QUALITY_COLORS[rarity]
		GameTooltip:SetText(title, color.r, color.g, color.b)
		
		if ( factionID ) then
			local factionName = GetFactionInfoByID(factionID)
			if ( factionName ) then
				GameTooltip:AddLine(factionName)
			end
		end
		
		for objectiveIndex = 1, line.numObjectives do
			local objectiveText, objectiveType, finished = GetQuestObjectiveInfo(questID, objectiveIndex, false)
			if ( objectiveText and #objectiveText > 0 ) then
				local color = finished and GRAY_FONT_COLOR or HIGHLIGHT_FONT_COLOR;
				GameTooltip:AddLine(QUEST_DASH .. objectiveText, color.r, color.g, color.b, true)
			end
		end
		
		GameTooltip:AddLine(format("QuestID: %d",questID),.5,.5,1)
	
		GameTooltip:Show()
	elseif line.isLeveling and questID and not line.isTreasure then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetHyperlink("quest:"..questID)
		GameTooltip:AddLine("Quest ID: "..questID)
		GameTooltip:Show()
	end
	WorldQuestList_Line_OnEnter(line)
end
local function WorldQuestList_LineName_OnLeave(self)
	GameTooltip_Hide()
	WorldQuestList_Line_OnLeave(self:GetParent())
end

function WorldQuestList_LineName_OnClick(self,button)
	local line = self:GetParent()
	if button == "LeftButton" then
		local questID = line.questID

		if not line.isLeveling and questID then
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		
			if IsShiftKeyDown() then
				if IsWorldQuestHardWatched(questID) or (IsWorldQuestWatched(questID) and GetSuperTrackedQuestID() == questID) then
					BonusObjectiveTracker_UntrackWorldQuest(questID)
				else
					BonusObjectiveTracker_TrackWorldQuest(questID, true)
				end
			else
				if IsWorldQuestHardWatched(questID) then
					SetSuperTrackedQuestID(questID)
				else
					BonusObjectiveTracker_TrackWorldQuest(questID)
				end
			end
		end
		
		if not IsShiftKeyDown() then
			local x,y
			if line.isLeveling and line.data.mapID and line.data.x then
				x,y = WorldQuestList:GetQuestWorldCoord2(questID,line.data.defMapID or line.data.mapID,line.data.x,line.data.y,true)
			else
				x,y = WorldQuestList:GetQuestWorldCoord(questID)
			end
			if x and y then
				local name = questID and C_TaskQuest.GetQuestInfoByQuestID(line.questID) or line.data.name or "unk"
				AddArrow(x,y,questID,name)
			end
			
			local x,y,mapID = WorldQuestList:GetQuestCoord(questID)
			if x and y then
				local name = C_TaskQuest.GetQuestInfoByQuestID(questID) or ""
				AddArrowNWC(x,y,mapID,questID,name)
			end
			
			local mapAreaID = GetCurrentMapAreaID()
			if WorldQuestList.GeneralMaps[mapAreaID] then
				local data = line.data
				if data and data.mapID and WorldMapFrame:IsVisible() then
					WorldMapFrame:SetMapID(data.mapID)

					local xMin,xMax,yMin,yMax = C_Map.GetMapRectOnMap(data.mapID,data.dMap or mapAreaID)
					if xMin ~= xMax and yMin ~= yMax and (data.x or data.dX) then
						local x,y = data.dX or data.x,data.dY or data.y

						x = (x - xMin) / (xMax - xMin)
						y = (y - yMin) / (yMax - yMin)
						
						WorldQuestList:SetMapDot()
						WorldQuestList:SetMapArrowsHelp(x,y)
					else
						WorldQuestList:SetMapDot()
					end
				end
			end
		end
	elseif button == "RightButton" then
		if not line.questID or line.isTreasure then
			return
		end
		ELib.ScrollDropDown.ClickButton(self)
	end
end

local function WorldQuestList_LineZone_OnEnter(self)
	WorldQuestList_Line_OnEnter(self:GetParent())
end
local function WorldQuestList_LineZone_OnLeave(self)
	WorldQuestList_Line_OnLeave(self:GetParent())
end

local function WorldQuestList_LineZone_OnClick(self,button)
	if button == "LeftButton" then
		local info = self:GetParent().data
		if info and info.mapID then
			WorldMapFrame:SetMapID(info.mapID)
		end
	elseif button == "RightButton" then
		WorldQuestList_Line_OnClick(self:GetParent(),"RightButton")
	end
end

local function WorldQuestList_Timeleft_OnEnter(self)
	WorldQuestList_Line_OnEnter(self:GetParent())
	if self._t then
		local t = time() + self._t * 60
		t = floor(t / 60) * 60
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		local format = "%x %X"
		if date("%x",t) == date("%x") then
			format = "%X"
		end
		GameTooltip:AddLine(date(format,t))
		GameTooltip:Show()
	end
end
local function WorldQuestList_Timeleft_OnLeave(self)
	WorldQuestList_Line_OnLeave(self:GetParent())
	GameTooltip_Hide()
end

local function WorldQuestList_LFGButton_OnClick(self,button)
	local questID = self.questID
	if not questID then
		return
	elseif C_LFGList.CanCreateQuestGroup(questID) then
		LFGListUtil_FindQuestGroup(questID)
	elseif button == "RightButton" then
		WorldQuestList.LFG_StartQuest(questID)
	else
		WorldQuestList.LFG_Search(questID)
	end
end
local function WorldQuestList_LFGButton_OnEnter(self)
	WorldQuestList_Line_OnEnter(self:GetParent())
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:AddLine(LOOK_FOR_GROUP)
	GameTooltip:AddLine(LOCALE.lfgLeftButtonClick,1,1,1)
	GameTooltip:AddLine(LOCALE.lfgLeftButtonClick2,1,1,1)	
	GameTooltip:AddLine(LOCALE.lfgRightButtonClick,1,1,1)
	GameTooltip:Show()	
end
local function WorldQuestList_LFGButton_OnLeave(self)
	WorldQuestList_Line_OnLeave(self:GetParent())
	GameTooltip_Hide()
end
local function WorldQuestList_LFGButton_OnShow(self)
	if not self.questID then
		self:SetEnabled(false)
		self.texture:Hide()
	else
		self:SetEnabled(true)
		self.texture:Show()
	end
	self:SetWidth(18)
end
local function WorldQuestList_LFGButton_OnHide(self)
	self:SetWidth(1)
end
local function WorldQuestList_LFGButton_OnUpdate(self,el)
	if self.t > 1 then
		self.t = 0
		local questID = self.questID
		if questID then
			local n = WorldQuestList.LFG_LastResult[questID]
			if n then
				self.text:SetText(n)
			else
				self.text:SetText("")
			end
		else
			self.text:SetText("")
		end
	end
	self.t = self.t + el
end


local IgnoreListDropDown = {
	{
		text = IGNORE_QUEST,
		func = function()
			ELib.ScrollDropDown.Close()
			local questID = ELib.ScrollDropDown.DropDownList[1].parent:GetParent().questID
			if questID then
				VWQL.Ignore[questID] = time()
				WorldQuestList_Update()
				if WorldQuestList.BlackListWindow:IsShown() then
					WorldQuestList.BlackListWindow:Hide()
					WorldQuestList.BlackListWindow:Show()
				end
			end
		end,
	},
	{
		text = COMMUNITIES_INVITE_MANAGER_COLUMN_TITLE_LINK..": Wowhead",
		func = function()
			ELib.ScrollDropDown.Close()
			local questID = ELib.ScrollDropDown.DropDownList[1].parent:GetParent().questID
			if questID then
				GExRT.F.ShowInput(COMMUNITIES_INVITE_MANAGER_COLUMN_TITLE_LINK..": Wowhead",function()end,nil,false,	(
					locale == "deDE" and "https://de." or
					locale == "esES" and "https://es." or
					locale == "esMX" and "https://es." or
					locale == "frFR" and "https://fr." or
					locale == "itIT" and "https://it." or
					locale == "koKR" and "https://ko." or
					locale == "ptBR" and "https://pt." or
					locale == "ruRU" and "https://ru." or
					locale == "zhCN" and "https://cn." or
					locale == "zhTW" and "https://cn." or
						"https://www." ) ..
				"wowhead.com/quest="..questID)
			end
		end,
		shownFunc = function() return GExRT and GExRT.F and GExRT.F.ShowInput end,
	},	
	{
		text = CLOSE,
		func = function()
			ELib.ScrollDropDown.Close()
		end,
	},	
}

WorldQuestList.NAME_WIDTH = 90
WorldQuestList.REWARD_WIDTH = 73+5
WorldQuestList.FACTION_WIDTH = 61+5+5
WorldQuestList.TIME_WIDTH = 50-5
WorldQuestList.ZONE_WIDTH = 70-5

WorldQuestList.l = {}
local function WorldQuestList_CreateLine(i)
	if WorldQuestList.l[i] then
		return
	end
	WorldQuestList.l[i] = CreateFrame("Button",nil,WorldQuestList.C)
	local line = WorldQuestList.l[i]
	line:SetPoint("TOPLEFT",0,-(i-1)*16)
	line:SetPoint("BOTTOMRIGHT",WorldQuestList.C,"TOPRIGHT",0,-i*16)
	
	line:SetScript("OnEnter",WorldQuestList_Line_OnEnter)
	line:SetScript("OnLeave",WorldQuestList_Line_OnLeave)
	line:SetScript("OnClick",WorldQuestList_Line_OnClick)
	line:RegisterForClicks("RightButtonUp", "LeftButtonUp")
	
	line.nameicon = line:CreateTexture(nil, "BACKGROUND")
	line.nameicon:SetPoint("LEFT",4,0)
	line.nameicon:SetSize(1,16)
	
	line.secondicon = line:CreateTexture(nil, "BACKGROUND")
	line.secondicon:SetPoint("LEFT",line.nameicon,"RIGHT",0,0)
	line.secondicon:SetSize(1,16)	

	line.name = line:CreateFontString(nil,"ARTWORK","ChatFontSmall")
	line.name:SetPoint("LEFT",line.secondicon,"RIGHT",0,0)
	line.name:SetSize(WorldQuestList.NAME_WIDTH,20)
	line.name:SetJustifyH("LEFT")
	
	line.LFGButton = CreateFrame("Button",nil,line)
	line.LFGButton:SetPoint("LEFT",line.name,"RIGHT")
	line.LFGButton:SetSize(18,18)
	line.LFGButton:SetScript("OnClick",WorldQuestList_LFGButton_OnClick)
	line.LFGButton:SetScript("OnEnter",WorldQuestList_LFGButton_OnEnter)
	line.LFGButton:SetScript("OnLeave",WorldQuestList_LFGButton_OnLeave)
	line.LFGButton:SetScript("OnShow",WorldQuestList_LFGButton_OnShow)
	line.LFGButton:SetScript("OnHide",WorldQuestList_LFGButton_OnHide)
	line.LFGButton.t = 0
	--line.LFGButton:SetScript("OnUpdate",WorldQuestList_LFGButton_OnUpdate)
	line.LFGButton:RegisterForClicks("LeftButtonDown","RightButtonUp")
	line.LFGButton.texture = line.LFGButton:CreateTexture(nil, "BACKGROUND")
	line.LFGButton.texture:SetPoint("CENTER")
	line.LFGButton.texture:SetSize(16,16)
	line.LFGButton.texture:SetAtlas("socialqueuing-icon-eye")

	line.LFGButton.HighlightTexture = line.LFGButton:CreateTexture()
	line.LFGButton.HighlightTexture:SetTexture("Interface\\Buttons\\UI-Common-MouseHilight")
	line.LFGButton.HighlightTexture:SetSize(16,16)
	line.LFGButton.HighlightTexture:SetPoint("CENTER")
	line.LFGButton:SetHighlightTexture(line.LFGButton.HighlightTexture,"ADD")

	line.LFGButton.text = line.LFGButton:CreateFontString(nil,"OVERLAY")
	line.LFGButton.text:SetPoint("BOTTOMLEFT",2,0)
	line.LFGButton.text:SetFont("Interface\\AddOns\\WorldQuestsList\\ariblk.ttf", 14, "OUTLINE")
	
	line.LFGButton:Hide()

	line.reward = line:CreateFontString(nil,"ARTWORK","GameFontWhite")
	line.reward:SetPoint("LEFT",line.LFGButton,"RIGHT",3,0)
	line.reward:SetSize(WorldQuestList.REWARD_WIDTH,20)
	line.reward:SetJustifyH("LEFT")
	
	line.faction = line:CreateFontString(nil,"ARTWORK","GameFontWhite")
	line.faction:SetPoint("LEFT",line.reward,"RIGHT",5,0)
	line.faction:SetSize(WorldQuestList.FACTION_WIDTH,20)
	line.faction:SetJustifyH("LEFT")
	
	line.faction.f = CreateFrame("Frame",nil,line)
	line.faction.f:SetAllPoints(line.faction)
	line.faction.f:SetScript("OnEnter",WorldQuestList_LineFaction_OnEnter)
	line.faction.f:SetScript("OnLeave",WorldQuestList_LineFaction_OnLeave)

	line.timeleft = line:CreateFontString(nil,"ARTWORK","GameFontWhite")
	line.timeleft:SetPoint("LEFT",line.faction,"RIGHT",3,0)
	line.timeleft:SetSize(WorldQuestList.TIME_WIDTH,20)
	line.timeleft:SetJustifyH("RIGHT")

	line.zone = line:CreateFontString(nil,"ARTWORK","GameFontWhite")
	line.zone:SetPoint("LEFT",line.timeleft,"RIGHT",8,0)
	line.zone:SetPoint("RIGHT",-5,0)
	line.zone:SetHeight(20)
	line.zone:SetJustifyH("LEFT")
	
	line.zone.f = CreateFrame("Button",nil,line)
	line.zone.f:SetAllPoints(line.zone)
	line.zone.f:SetScript("OnEnter",WorldQuestList_LineZone_OnEnter)
	line.zone.f:SetScript("OnLeave",WorldQuestList_LineZone_OnLeave)
	line.zone.f:SetScript("OnClick",WorldQuestList_LineZone_OnClick)
	line.zone.f:RegisterForClicks("LeftButtonDown","RightButtonUp")
	
	line.reward.f = CreateFrame("Button",nil,line)
	line.reward.f:SetAllPoints(line.reward)
	line.reward.f:SetScript("OnEnter",WorldQuestList_LineReward_OnEnter)
	line.reward.f:SetScript("OnLeave",WorldQuestList_LineReward_OnLeave)
	line.reward.f:SetScript("OnClick",WorldQuestList_LineReward_OnClick)
	line.reward.f:SetScript("OnEvent",WorldQuestList_LineReward_OnEvent)
	line.reward.f:RegisterForClicks("LeftButtonDown","RightButtonUp")
	
	--line.reward.f.icon = line.reward.f:CreateTexture(nil, "BACKGROUND")

	line.name.f = CreateFrame("Button",nil,line)
	line.name.f:SetAllPoints(line.name)
	line.name.f:SetScript("OnEnter",WorldQuestList_LineName_OnEnter)
	line.name.f:SetScript("OnLeave",WorldQuestList_LineName_OnLeave)
	line.name.f:SetScript("OnClick",WorldQuestList_LineName_OnClick)
	line.name.f:RegisterForClicks("LeftButtonDown","RightButtonUp")
	
	line.name.f.Width = 120
	line.name.f.isButton = true
	line.name.f.List = IgnoreListDropDown
	
	line.timeleft.f = CreateFrame("Button",nil,line)
	line.timeleft.f:SetAllPoints(line.timeleft)
	line.timeleft.f:SetScript("OnEnter",WorldQuestList_Timeleft_OnEnter)
	line.timeleft.f:SetScript("OnLeave",WorldQuestList_Timeleft_OnLeave)
    line.timeleft.f:SetScript("OnClick",WorldQuestList_LineName_OnClick)
    line.timeleft.f:RegisterForClicks("LeftButtonDown","RightButtonUp")
	
	line.hl = line:CreateTexture(nil, "BACKGROUND")
	line.hl:SetPoint("TOPLEFT", 0, 0)
	line.hl:SetPoint("BOTTOMRIGHT", 0, 0)
	line.hl:SetTexture("Interface\\Buttons\\WHITE8X8")
	line.hl:SetVertexColor(.7,.7,1,.25)
	line.hl:Hide()
	
	line.nqhl = line:CreateTexture(nil, "BACKGROUND",nil,-1)
	line.nqhl:SetPoint("TOPLEFT", 0, 0)
	line.nqhl:SetPoint("BOTTOMRIGHT", 0, 0)
	line.nqhl:SetTexture("Interface\\Buttons\\WHITE8X8")
	line.nqhl:SetBlendMode("ADD")
	line.nqhl:SetVertexColor(.7,.7,1,.1)
	line.nqhl:Hide()
end

do
	local function WorldQuestList_HeaderLine_OnClick(self)
		if ActiveSort == self.sort then
			VWQL.ReverseSort = not VWQL.ReverseSort
		end
		ActiveSort = self.sort
		VWQL.Sort = ActiveSort
		ELib.ScrollDropDown.Close()
		WorldQuestList_Update()
	end
	local function WorldQuestList_HeaderLine_OnEnter(self)
		local _,parent = self:GetPoint()
		parent:SetTextColor(1,1,0)
	end	
	local function WorldQuestList_HeaderLine_OnLeave(self)
		local _,parent = self:GetPoint()
		parent:SetTextColor(1,1,1)
	end	
	
	WorldQuestList.HEADER_HEIGHT = 18

	WorldQuestList.header = CreateFrame("Button",nil,WorldQuestList)
	local line = WorldQuestList.header
	line:SetPoint("TOPLEFT",0,0)
	line:SetPoint("BOTTOMRIGHT",WorldQuestList,"TOPRIGHT",0,-WorldQuestList.HEADER_HEIGHT)
	
	line.b = line:CreateTexture(nil,"BACKGROUND")
	line.b:SetAllPoints()
	line.b:SetColorTexture(.25,.25,.25,1)
	
	line.name = line:CreateFontString(nil,"ARTWORK","GameFontWhite")
	line.name:SetPoint("LEFT",4,0)
	line.name:SetSize(WorldQuestList.NAME_WIDTH,WorldQuestList.HEADER_HEIGHT)
	line.name:SetJustifyH("LEFT")
	line.name:SetJustifyV("MIDDLE")
	line.name.text = CALENDAR_EVENT_NAME
	
	line.name.f = CreateFrame("Button",nil,line)
	line.name.f:SetAllPoints(line.name)
	line.name.f:SetScript("OnClick",WorldQuestList_HeaderLine_OnClick)
	line.name.f:SetScript("OnEnter",WorldQuestList_HeaderLine_OnEnter)
	line.name.f:SetScript("OnLeave",WorldQuestList_HeaderLine_OnLeave)
	line.name.f:RegisterForClicks("LeftButtonDown")
	line.name.f.sort = 3

	line.LFGButton = CreateFrame("Button",nil,line)
	line.LFGButton:SetPoint("LEFT",line.name,"RIGHT")
	line.LFGButton:SetSize(18,18)

	line.reward = line:CreateFontString(nil,"ARTWORK","GameFontWhite")
	line.reward:SetPoint("LEFT",line.LFGButton,"RIGHT",2,0)
	line.reward:SetSize(WorldQuestList.REWARD_WIDTH,WorldQuestList.HEADER_HEIGHT)
	line.reward:SetJustifyH("LEFT")
	line.reward:SetJustifyV("MIDDLE")
	line.reward.text = REWARDS

	line.reward.f = CreateFrame("Button",nil,line)
	line.reward.f:SetAllPoints(line.reward)
	line.reward.f:SetScript("OnClick",WorldQuestList_HeaderLine_OnClick)
	line.reward.f:SetScript("OnEnter",WorldQuestList_HeaderLine_OnEnter)
	line.reward.f:SetScript("OnLeave",WorldQuestList_HeaderLine_OnLeave)
	line.reward.f:RegisterForClicks("LeftButtonDown")
	line.reward.f.sort = 5

	line.faction = line:CreateFontString(nil,"ARTWORK","GameFontWhite")
	line.faction:SetPoint("LEFT",line.reward,"RIGHT",5,0)
	line.faction:SetSize(WorldQuestList.FACTION_WIDTH,WorldQuestList.HEADER_HEIGHT)
	line.faction:SetJustifyH("LEFT")
	line.faction:SetJustifyV("MIDDLE")
	line.faction.text = FACTION
	
	line.faction.f = CreateFrame("Button",nil,line)
	line.faction.f:SetAllPoints(line.faction)
	line.faction.f:SetScript("OnClick",WorldQuestList_HeaderLine_OnClick)
	line.faction.f:SetScript("OnEnter",WorldQuestList_HeaderLine_OnEnter)
	line.faction.f:SetScript("OnLeave",WorldQuestList_HeaderLine_OnLeave)
	line.faction.f:RegisterForClicks("LeftButtonDown")
	line.faction.f.sort = 4

	line.timeleft = line:CreateFontString(nil,"ARTWORK","GameFontWhite")
	line.timeleft:SetPoint("LEFT",line.faction,"RIGHT",5,0)
	line.timeleft:SetSize(WorldQuestList.TIME_WIDTH,WorldQuestList.HEADER_HEIGHT)
	line.timeleft:SetJustifyH("LEFT")
	line.timeleft:SetJustifyV("MIDDLE")
	line.timeleft.text = TIME_LABEL:match("^[^:]+")
	
	line.timeleft.f = CreateFrame("Button",nil,line)
	line.timeleft.f:SetAllPoints(line.timeleft)
	line.timeleft.f:SetScript("OnClick",WorldQuestList_HeaderLine_OnClick)
	line.timeleft.f:SetScript("OnEnter",WorldQuestList_HeaderLine_OnEnter)
	line.timeleft.f:SetScript("OnLeave",WorldQuestList_HeaderLine_OnLeave)
	line.timeleft.f:RegisterForClicks("LeftButtonDown")
	line.timeleft.f.sort = 1

	line.zone = line:CreateFontString(nil,"ARTWORK","GameFontWhite")
	line.zone:SetPoint("LEFT",line.timeleft,"RIGHT",5,0)
	line.zone:SetSize(WorldQuestList.ZONE_WIDTH,WorldQuestList.HEADER_HEIGHT)
	line.zone:SetJustifyH("LEFT")
	line.zone:SetJustifyV("MIDDLE")
	line.zone.text = ZONE
	
	line.zone.f = CreateFrame("Button",nil,line)
	line.zone.f:SetAllPoints(line.zone)
	line.zone.f:SetScript("OnClick",WorldQuestList_HeaderLine_OnClick)
	line.zone.f:SetScript("OnEnter",WorldQuestList_HeaderLine_OnEnter)
	line.zone.f:SetScript("OnLeave",WorldQuestList_HeaderLine_OnLeave)
	line.zone.f:RegisterForClicks("LeftButtonDown")
	line.zone.f.sort = 2

	local str = {'name','reward','faction','timeleft','zone'}
	
	line.Update = function(self,disable,disabeZone,lfgIconEnabled)
		if VWQL.DisableHeader or disable then
			self:Hide()
			WorldQuestList.Cheader:SetPoint("TOP",0,-1)
			WorldQuestList.SCROLL_FIX_TOP = 1
			return
		else
			self:Show()
			WorldQuestList.Cheader:SetPoint("TOP",0,-WorldQuestList.HEADER_HEIGHT)
			WorldQuestList.SCROLL_FIX_TOP = 0
		end
		
		line.zone:SetShown(disabeZone)
		line.zone.f:SetShown(disabeZone)
		
		line.LFGButton:SetWidth(lfgIconEnabled and 18 or 1)
		
		for _,n in pairs(str) do
			line[n]:SetText("  "..line[n].text)
		end

		local currSort = nil
		if ActiveSort == 1 then
			currSort = line.timeleft
		elseif ActiveSort == 2 then
			currSort = line.zone
		elseif ActiveSort == 3 then
			currSort = line.name
		elseif ActiveSort == 4 then
			currSort = line.faction
		elseif ActiveSort == 5 then
			currSort = line.reward
		end
		
		if currSort and VWQL.ReverseSort then
			currSort:SetText("|TInterface\\AddOns\\WorldQuestsList\\navButtons:16:16:0:0:64:16:17:32:0:16|t "..currSort:GetText():gsub("^ *",""))
		elseif currSort and not VWQL.ReverseSort then
			currSort:SetText("|TInterface\\AddOns\\WorldQuestsList\\navButtons:16:16:0:0:64:16:0:16:0:16|t "..currSort:GetText():gsub("^ *",""))
		end
	end
end


do
	WorldQuestList.FOOTER_HEIGHT = 18

	WorldQuestList.footer = CreateFrame("Button",nil,WorldQuestList)
	local line = WorldQuestList.footer
	line:SetPoint("BOTTOMLEFT",0,0)
	line:SetPoint("TOPRIGHT",WorldQuestList,"BOTTOMRIGHT",0,WorldQuestList.FOOTER_HEIGHT)
	
	line.BorderTop = line:CreateTexture(nil,"BACKGROUND")
	line.BorderTop:SetColorTexture(unpack(WorldQuestList.backdrop.BorderColor))
	line.BorderTop:SetPoint("TOPLEFT",0,-1)
	line.BorderTop:SetPoint("BOTTOMRIGHT",line,"TOPRIGHT",0,0)
	
	line.ap = line:CreateFontString(nil,"ARTWORK","GameFontWhite")
	line.ap:SetPoint("LEFT",5,0)
	line.ap:SetHeight(WorldQuestList.FOOTER_HEIGHT)
	line.ap:SetJustifyH("LEFT")
	line.ap:SetJustifyV("MIDDLE")
	
	line.OR = line:CreateFontString(nil,"ARTWORK","GameFontWhite")
	line.OR:SetPoint("CENTER",0,0)
	line.OR:SetHeight(WorldQuestList.FOOTER_HEIGHT)
	line.OR:SetJustifyH("CENTER")
	line.OR:SetJustifyV("MIDDLE")

	line.gold = line:CreateFontString(nil,"ARTWORK","GameFontWhite")
	line.gold:SetPoint("RIGHT",-5,0)
	line.gold:SetHeight(WorldQuestList.FOOTER_HEIGHT)
	line.gold:SetJustifyH("RIGHT")
	line.gold:SetJustifyV("MIDDLE")
	
	line.Update = function(self,disable)
		if VWQL.DisableTotalAP or disable then
			self:Hide()
			WorldQuestList.Cheader:SetPoint("BOTTOM",0,2)
			WorldQuestList.SCROLL_FIX_BOTTOM = 2
		else
			self:Show()
			WorldQuestList.Cheader:SetPoint("BOTTOM",0,WorldQuestList.FOOTER_HEIGHT+1)
			WorldQuestList.SCROLL_FIX_BOTTOM = 1
		end
	end
end


local ViewAllButton = CreateFrame("Button", nil, WorldQuestList)
ViewAllButton:SetPoint("TOPLEFT",0,-5)
ViewAllButton:SetSize(150,25)
ViewAllButton:Hide()

WorldQuestList.ViewAllButton = ViewAllButton

ViewAllButton.b = ViewAllButton:CreateTexture(nil,"BACKGROUND",nil,1)
ViewAllButton.b:SetAllPoints()
ViewAllButton.b:SetColorTexture(0.28,0.08,0.08,1)

ViewAllButton.t = ViewAllButton:CreateFontString(nil,"ARTWORK","GameFontWhite")
ViewAllButton.t:SetPoint("CENTER",0,0)

ELib.Templates:Border(ViewAllButton,.3,.12,.12,1,1)
ViewAllButton.shadow = ELib:Shadow2(ViewAllButton,16)

ViewAllButton:SetScript("OnEnter",function(self) self.b:SetColorTexture(0.42,0.12,0.12,1) end)
ViewAllButton:SetScript("OnLeave",function(self) self.b:SetColorTexture(0.28,0.08,0.08,1) end)


ViewAllButton.Argus = CreateFrame("Button", nil, ViewAllButton)
ViewAllButton.Argus:SetPoint("TOP",ViewAllButton,"BOTTOM",0,-5)
ViewAllButton.Argus:SetSize(150,25)

ViewAllButton.Argus.b = ViewAllButton.Argus:CreateTexture(nil,"BACKGROUND",nil,1)
ViewAllButton.Argus.b:SetAllPoints()
ViewAllButton.Argus.b:SetColorTexture(0.28,0.08,0.08,1)

ViewAllButton.Argus.t = ViewAllButton.Argus:CreateFontString(nil,"ARTWORK","GameFontWhite")
ViewAllButton.Argus.t:SetPoint("CENTER",0,0)

ELib.Templates:Border(ViewAllButton.Argus,.3,.12,.12,1,1)
ViewAllButton.Argus.shadow = ELib:Shadow2(ViewAllButton.Argus,16)

ViewAllButton.Argus:SetScript("OnEnter",function(self) self.b:SetColorTexture(0.42,0.12,0.12,1) end)
ViewAllButton.Argus:SetScript("OnLeave",function(self) self.b:SetColorTexture(0.28,0.08,0.08,1) end)

ViewAllButton.Update = function()
	if UnitLevel'player' < 111 then
		ViewAllButton:SetScript("OnClick",function()
			WorldMapFrame:SetMapID(619)
		end)
		ViewAllButton.t:SetText("世界任务：查看全部") --..(QUEST_MAP_VIEW_ALL_FORMAT:gsub("|c.+$","")))
	
		ViewAllButton.Argus:SetScript("OnClick",function()
			WorldMapFrame:SetMapID(905)
		end)
		ViewAllButton.Argus.t:SetText("世界任务："..WorldQuestList:GetMapName(905))
	else
		local button1, button2
		if UnitFactionGroup("player") == "Alliance" then
			button1, button2 = ViewAllButton, ViewAllButton.Argus
		else
			button1, button2 = ViewAllButton.Argus, ViewAllButton
		end
		button1:SetScript("OnClick",function()
			WorldMapFrame:SetMapID(876)
		end)
		button1.t:SetText("世界任务："..WorldQuestList:GetMapName(876).." |TInterface\\FriendsFrame\\PlusManz-Alliance:16|t")
	
		button2:SetScript("OnClick",function()
			WorldMapFrame:SetMapID(875)
		end)
		button2.t:SetText("世界任务："..WorldQuestList:GetMapName(875).." |TInterface\\FriendsFrame\\PlusManz-Horde:16|t")
	
	end
end


WorldQuestList.sortDropDown = ELib:DropDown(WorldQuestList,RAID_FRAME_SORT_LABEL:gsub(" ([^ ]+)$",""), nil)
WorldQuestList.sortDropDown:SetWidth(70)
WorldQuestList.sortDropDown.Button.Width = 90


local function SetSort(_, arg1)
	ActiveSort = arg1
	VWQL.Sort = ActiveSort
	VWQL.ReverseSort = false
	ELib.ScrollDropDown.Close()
	WorldQuestList_Update()
end

local TableSortNames = {
	TIME_LABEL:match("^[^:]+"),
	ZONE,
	NAME,
	FACTION,
	REWARDS,
	LOCALE.distance,
}

do
	local list = {}
	WorldQuestList.sortDropDown.Button.List = list
	for i=1,#TableSortNames do
		list[i] = {
			text = TableSortNames[i],
			radio = true,
			arg1 = i,
			func = SetSort,
		}
	end
	function WorldQuestList.sortDropDown.Button:additionalToggle()
		for i=1,#self.List do
			self.List[i].checkState = ActiveSort == i
		end
	end
end


WorldQuestList.filterDropDown = ELib:DropDown(WorldQuestList,FILTERS)
WorldQuestList.filterDropDown:SetWidth(90)
WorldQuestList.filterDropDown.Button.Width = 170

do
	local list = {}
	WorldQuestList.filterDropDown.Button.List = list
	
	local LEGION = function() return WorldQuestList:IsLegionZone() end
	local NOT_LEGION = function() return not WorldQuestList:IsLegionZone() end
	local GetFaction = function(id,non_translated) 
		return FACTION.." "..(GetFactionInfoByID(id) or non_translated or ("ID "..tostring(id)))
	end
	
	
	local function SetFilter(_, arg1)
		if bit.band(filters[arg1][2],ActiveFilter) > 0 then
			ActiveFilter = bit.bxor(ActiveFilter,filters[arg1][2])
		else
			ActiveFilter = bit.bor(ActiveFilter,filters[arg1][2])
		end
		VWQL[charKey].Filter = ActiveFilter
		ELib.ScrollDropDown.UpdateChecks()
		WorldQuestList_Update()
	end
	
	local function SetFilterType(_, arg1)
		ActiveFilterType[arg1] = not ActiveFilterType[arg1]
		ELib.ScrollDropDown.UpdateChecks()
		WorldQuestList_Update()
	end
	
	local function SetIgnoreFilter(_, arg1)
		VWQL[charKey][arg1] = not VWQL[charKey][arg1]
		ELib.ScrollDropDown.UpdateChecks()
		WorldQuestList_Update()
	end


	list[#list+1] = {
		text = CHECK_ALL,
		func = function()
			ActiveFilter = 2 ^ #filters - 1
			VWQL[charKey].Filter = ActiveFilter
			ActiveFilterType.azerite = nil
			ActiveFilterType.bfa_orderres = nil
			ActiveFilterType.rep = nil
			VWQL[charKey].arguniteFilter = nil
			VWQL[charKey].wakeningessenceFilter = nil
			VWQL[charKey].invasionPointsFilter = nil
			ELib.ScrollDropDown.Close()
			WorldQuestList_Update()
		end,
	}
	list[#list+1] = {
		text = UNCHECK_ALL,
		func = function()
			ActiveFilter = 0
			VWQL[charKey].Filter = ActiveFilter
			ActiveFilterType.azerite = true
			ActiveFilterType.bfa_orderres = true
			ActiveFilterType.rep = true
			VWQL[charKey].arguniteFilter = true
			VWQL[charKey].wakeningessenceFilter = true
			VWQL[charKey].invasionPointsFilter = true
			ELib.ScrollDropDown.Close()
			WorldQuestList_Update()
		end,
	}
	
	list[#list+1] = {text = LOCALE.gear,			func = SetFilter,	arg1 = 1,					checkable = true,				}
	list[#list+1] = {text = LE.ARTIFACT_POWER,		func = SetFilter,	arg1 = 2,					checkable = true,	shownFunc = LEGION	}
	list[#list+1] = {text = LE.AZERITE,			func = SetFilterType,	arg1 = "azerite",				checkable = true,	shownFunc = NOT_LEGION	}
	list[#list+1] = {text = LE.ORDER_RESOURCES_NAME_LEGION,	func = SetFilter,	arg1 = 3,					checkable = true,	shownFunc = LEGION	}
	list[#list+1] = {text = LE.ORDER_RESOURCES_NAME_BFA,	func = SetFilterType,	arg1 = "bfa_orderres",				checkable = true,	shownFunc = NOT_LEGION	}
	list[#list+1] = {text = LOCALE.blood,			func = SetFilter,	arg1 = 4,					checkable = true,	shownFunc = LEGION	}
	list[#list+1] = {text = GetCurrencyInfo(1508),		func = SetIgnoreFilter,	arg1 = "arguniteFilter",	arg2 = true,	checkable = true,	shownFunc = LEGION	}
	list[#list+1] = {text = GetCurrencyInfo(1533),		func = SetIgnoreFilter,	arg1 = "wakeningessenceFilter",	arg2 = true,	checkable = true,	shownFunc = LEGION	}
	list[#list+1] = {text = LOCALE.gold,			func = SetFilter,	arg1 = 5,					checkable = true,				}
	list[#list+1] = {text = LOCALE.invasionPoints,		func = SetIgnoreFilter,	arg1 = "invasionPointsFilter",	arg2 = true,	checkable = true,	shownFunc = LEGION	}
	list[#list+1] = {text = REPUTATION,			func = SetFilterType,	arg1 = "rep",					checkable = true,				}
	list[#list+1] = {text = OTHER,				func = SetFilter,	arg1 = 6,					checkable = true,				}

	list[#list+1] = {
		text = TYPE,
		isTitle = true,
	}
	list[#list+1] = {text = PVP,			func = SetFilterType,	arg1 = "pvp",	checkable = true,	}
	list[#list+1] = {text = DUNGEONS,		func = SetFilterType,	arg1 = "dung",	checkable = true,	}
	list[#list+1] = {text = TRADE_SKILLS,		func = SetFilterType,	arg1 = "prof",	checkable = true,	}
	list[#list+1] = {text = PET_BATTLE_PVP_QUEUE,	func = SetFilterType,	arg1 = "pet",	checkable = true,	}
	
	list[#list+1] = {
		text = LOCALE.ignoreFilter,
		isTitle = true,
	}
	list[#list+1] = {text = LOCALE.bountyIgnoreFilter,		func = SetIgnoreFilter,	arg1 = "bountyIgnoreFilter",		checkable = true,				}
	list[#list+1] = {text = LE.ARTIFACT_POWER,			func = SetIgnoreFilter,	arg1 = "apIgnoreFilter",		checkable = true,	shownFunc = LEGION	}	
	list[#list+1] = {text = LE.AZERITE,				func = SetIgnoreFilter,	arg1 = "azeriteIgnoreFilter",		checkable = true,	shownFunc = NOT_LEGION	}	
	list[#list+1] = {text = LOCALE.honorIgnoreFilter,		func = SetIgnoreFilter,	arg1 = "honorIgnoreFilter",		checkable = true,				}
	list[#list+1] = {text = SHOW_PET_BATTLES_ON_MAP_TEXT,		func = SetIgnoreFilter,	arg1 = "petIgnoreFilter",		checkable = true,				}
	list[#list+1] = {text = LOCALE.wantedIgnoreFilter,		func = SetIgnoreFilter,	arg1 = "wantedIgnoreFilter",		checkable = true,				}
	list[#list+1] = {text = LOCALE.epicIgnoreFilter,		func = SetIgnoreFilter,	arg1 = "epicIgnoreFilter",		checkable = true,				}
	list[#list+1] = {text = LOCALE.ignoreList,			func = SetIgnoreFilter,	arg1 = "ignoreIgnore",			checkable = true,				}
	list[#list+1] = {text = GetFaction(2045,"Legionfall"),		func = SetIgnoreFilter,	arg1 = "legionfallIgnoreFilter",	checkable = true,	shownFunc = LEGION	}
	list[#list+1] = {text = GetFaction(2165,"Army of the Light"),	func = SetIgnoreFilter,	arg1 = "aotlIgnoreFilter",		checkable = true,	shownFunc = LEGION	}
	list[#list+1] = {text = GetFaction(2170,"Argussian Reach"),	func = SetIgnoreFilter,	arg1 = "argusReachIgnoreFilter",	checkable = true,	shownFunc = LEGION	}
	
	list[#list+1] = {text = GetFaction(2164),	func = SetIgnoreFilter,	arg1 = "faction2164IgnoreFilter",	checkable = true,	shownFunc = function() return WorldQuestList:IsFactionAvailable(2164) and not WorldQuestList:IsLegionZone() end	}
	list[#list+1] = {text = GetFaction(2163),	func = SetIgnoreFilter,	arg1 = "faction2163IgnoreFilter",	checkable = true,	shownFunc = function() return WorldQuestList:IsFactionAvailable(2163) and not WorldQuestList:IsLegionZone() end	}
	list[#list+1] = {text = GetFaction(2157),	func = SetIgnoreFilter,	arg1 = "faction2157IgnoreFilter",	checkable = true,	shownFunc = function() return WorldQuestList:IsFactionAvailable(2157) and not WorldQuestList:IsLegionZone() end	}
	list[#list+1] = {text = GetFaction(2156),	func = SetIgnoreFilter,	arg1 = "faction2156IgnoreFilter",	checkable = true,	shownFunc = function() return WorldQuestList:IsFactionAvailable(2156) and not WorldQuestList:IsLegionZone() end	}
	list[#list+1] = {text = GetFaction(2103),	func = SetIgnoreFilter,	arg1 = "faction2103IgnoreFilter",	checkable = true,	shownFunc = function() return WorldQuestList:IsFactionAvailable(2103) and not WorldQuestList:IsLegionZone() end	}
	list[#list+1] = {text = GetFaction(2158),	func = SetIgnoreFilter,	arg1 = "faction2158IgnoreFilter",	checkable = true,	shownFunc = function() return WorldQuestList:IsFactionAvailable(2158) and not WorldQuestList:IsLegionZone() end	}
	list[#list+1] = {text = GetFaction(2159),	func = SetIgnoreFilter,	arg1 = "faction2159IgnoreFilter",	checkable = true,	shownFunc = function() return WorldQuestList:IsFactionAvailable(2159) and not WorldQuestList:IsLegionZone() end	}
	list[#list+1] = {text = GetFaction(2160),	func = SetIgnoreFilter,	arg1 = "faction2160IgnoreFilter",	checkable = true,	shownFunc = function() return WorldQuestList:IsFactionAvailable(2160) and not WorldQuestList:IsLegionZone() end	}
	list[#list+1] = {text = GetFaction(2162),	func = SetIgnoreFilter,	arg1 = "faction2162IgnoreFilter",	checkable = true,	shownFunc = function() return WorldQuestList:IsFactionAvailable(2162) and not WorldQuestList:IsLegionZone() end	}
	list[#list+1] = {text = GetFaction(2161),	func = SetIgnoreFilter,	arg1 = "faction2161IgnoreFilter",	checkable = true,	shownFunc = function() return WorldQuestList:IsFactionAvailable(2161) and not WorldQuestList:IsLegionZone() end	}
	
	function WorldQuestList.filterDropDown.Button:additionalToggle()
		for i=1,#self.List do
			if self.List[i].func == SetFilter then
				self.List[i].checkState = bit.band(filters[ self.List[i].arg1 ][2],ActiveFilter) > 0
			elseif self.List[i].func == SetFilterType then
				self.List[i].checkState = not ActiveFilterType[ self.List[i].arg1 ]
			elseif self.List[i].func == SetIgnoreFilter and not self.List[i].arg2 then 
				self.List[i].checkState = VWQL[charKey][self.List[i].arg1]
			elseif self.List[i].func == SetIgnoreFilter and self.List[i].arg2 then 
				self.List[i].checkState = not VWQL[charKey][self.List[i].arg1]
			end		
		end
	end	
end

function UpdateScale()
	local scale = tonumber(VWQL.Scale) or 1
	if VWQL.Anchor == 2 and WorldMapFrame:IsVisible() then
		scale = scale * WorldMapButton:GetWidth() / 1002 * 0.8
	end
	WorldQuestList:SetScale(scale)
end
function UpdateAnchor(forceFreeMode)
	WorldQuestList:ClearAllPoints()
	
	local mode = 
		VWQL.Anchor == 1 and 1 or	--bottom
		VWQL.Anchor == 2 and 2 or	--inside
		(VWQL.Anchor == 3 or forceFreeMode) and 3 or	--free
		4				--default
	
	if mode == 1 then
		WorldQuestList.filterDropDown:ClearAllPoints()
		WorldQuestList.filterDropDown:SetPoint("TOPLEFT",WorldQuestList,"TOPRIGHT",1,0)

		WorldQuestList.sortDropDown:ClearAllPoints()
		WorldQuestList.sortDropDown:SetPoint("TOPLEFT",WorldQuestList.filterDropDown,"BOTTOMLEFT",0,-3)

		WorldQuestList.optionsDropDown:ClearAllPoints()
		WorldQuestList.optionsDropDown:SetPoint("TOPLEFT",WorldQuestList.sortDropDown,"BOTTOMLEFT",0,-3)
		
		WorldQuestList.modeSwitcherCheck:ClearAllPoints()
		WorldQuestList.modeSwitcherCheck:SetPoint("TOPLEFT",WorldQuestList.optionsDropDown,"BOTTOMLEFT",0,-3)
			
		WorldQuestList.oppositeContinentButton:ClearAllPoints()
		WorldQuestList.oppositeContinentButton:SetPoint("TOPLEFT",WorldQuestList.modeSwitcherCheck,"BOTTOMLEFT",0,-3)

		WorldQuestList:SetParent(WorldMapFrame)
		WorldQuestList:SetPoint("TOPLEFT",WorldMapFrame,"BOTTOMLEFT",3,-7)
		
		WorldQuestList.moveHeader:Hide()
		
		ELib.ScrollDropDown.DropDownList[1]:SetParent(UIParent)	
		ELib.ScrollDropDown.DropDownList[2]:SetParent(UIParent)	
	elseif mode == 2 then
		WorldQuestList.filterDropDown:ClearAllPoints()
		WorldQuestList.filterDropDown:SetPoint("BOTTOMRIGHT",WorldQuestList,"TOPRIGHT",0,1)

		WorldQuestList.sortDropDown:ClearAllPoints()
		WorldQuestList.sortDropDown:SetPoint("RIGHT",WorldQuestList.filterDropDown,"LEFT",-5,0)

		WorldQuestList.optionsDropDown:ClearAllPoints()
		WorldQuestList.optionsDropDown:SetPoint("RIGHT",WorldQuestList.sortDropDown,"LEFT",-5,0)
		
		WorldQuestList.modeSwitcherCheck:ClearAllPoints()
		WorldQuestList.modeSwitcherCheck:SetPoint("RIGHT",WorldQuestList.optionsDropDown,"LEFT",-5,0)
	
		WorldQuestList.oppositeContinentButton:ClearAllPoints()
		WorldQuestList.oppositeContinentButton:SetPoint("RIGHT",WorldQuestList.modeSwitcherCheck,"LEFT",-5,0)

		WorldQuestList:SetParent(WorldMapButton)
		WorldQuestList:SetPoint("TOPRIGHT",WorldMapButton,"TOPRIGHT",-10,-70)
		
		WorldQuestList.moveHeader:Show()
		
		WorldQuestList:SetFrameStrata("TOOLTIP")
		
		ELib.ScrollDropDown.DropDownList[1]:SetParent(WorldMapFrame)	
		ELib.ScrollDropDown.DropDownList[2]:SetParent(WorldMapFrame)
	elseif mode == 3 then
		WorldQuestList.filterDropDown:ClearAllPoints()
		WorldQuestList.filterDropDown:SetPoint("BOTTOMRIGHT",WorldQuestList,"TOPRIGHT",0,1)

		WorldQuestList.sortDropDown:ClearAllPoints()
		WorldQuestList.sortDropDown:SetPoint("RIGHT",WorldQuestList.filterDropDown,"LEFT",-5,0)

		WorldQuestList.optionsDropDown:ClearAllPoints()
		WorldQuestList.optionsDropDown:SetPoint("RIGHT",WorldQuestList.sortDropDown,"LEFT",-5,0)
		
		WorldQuestList.modeSwitcherCheck:ClearAllPoints()
		WorldQuestList.modeSwitcherCheck:SetPoint("RIGHT",WorldQuestList.optionsDropDown,"LEFT",-5,0)
	
		WorldQuestList.oppositeContinentButton:ClearAllPoints()
		WorldQuestList.oppositeContinentButton:SetPoint("RIGHT",WorldQuestList.modeSwitcherCheck,"LEFT",-5,0)

		if not forceFreeMode then
			WorldQuestList:SetParent(WorldMapFrame)
		end
		if VWQL.Anchor3PosLeft and VWQL.Anchor3PosTop and not forceFreeMode then
			WorldQuestList:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VWQL.Anchor3PosLeft,VWQL.Anchor3PosTop)
		else
			if WorldMapFrame:IsMaximized() then
				WorldQuestList:SetPoint("TOPLEFT",WorldMapFrame,"TOPRIGHT",-500,-30)
			else
				WorldQuestList:SetPoint("TOPLEFT",WorldMapFrame,"TOPRIGHT",10,-4)
			end
		end
		
		WorldQuestList.moveHeader:Show()
		
		WorldQuestList:SetFrameStrata("DIALOG")
		
		ELib.ScrollDropDown.DropDownList[1]:SetParent(UIParent)	
		ELib.ScrollDropDown.DropDownList[2]:SetParent(UIParent)	
	else
		WorldQuestList:SetParent(WorldMapFrame)
		WorldQuestList:SetPoint("TOPLEFT",WorldMapFrame,"TOPRIGHT",10,-4)

		WorldQuestList.filterDropDown:ClearAllPoints()
		WorldQuestList.filterDropDown:SetPoint("BOTTOMRIGHT",WorldQuestList,"TOPLEFT",TOTAL_WIDTH,3)

		WorldQuestList.sortDropDown:ClearAllPoints()
		WorldQuestList.sortDropDown:SetPoint("RIGHT",WorldQuestList.filterDropDown,"LEFT",-5,0)

		WorldQuestList.optionsDropDown:ClearAllPoints()
		WorldQuestList.optionsDropDown:SetPoint("RIGHT",WorldQuestList.sortDropDown,"LEFT",-5,0)
		
		WorldQuestList.modeSwitcherCheck:ClearAllPoints()
		WorldQuestList.modeSwitcherCheck:SetPoint("RIGHT",WorldQuestList.optionsDropDown,"LEFT",-5,0)
	
		WorldQuestList.oppositeContinentButton:ClearAllPoints()
		WorldQuestList.oppositeContinentButton:SetPoint("RIGHT",WorldQuestList.modeSwitcherCheck,"LEFT",-5,0)
		
		WorldQuestList.moveHeader:Hide()

		ELib.ScrollDropDown.DropDownList[1]:SetParent(UIParent)	
		ELib.ScrollDropDown.DropDownList[2]:SetParent(UIParent)	
	end
end

WorldQuestList.optionsDropDown = ELib:DropDown(WorldQuestList,GAMEOPTIONS_MENU)
WorldQuestList.optionsDropDown:SetWidth(70)
WorldQuestList.optionsDropDown.Button.Width = 220
WorldQuestList.optionsDropDown:SetClampedToScreen(true)

do
	local list = {}
	WorldQuestList.optionsDropDown.Button.List = list
	

	local lfgSubMenu = {
		{
			text = LOCALE.lfgDisablePopup,
			func = function()
				VWQL.DisableLFG_Popup = not VWQL.DisableLFG_Popup
			end,
			checkable = true,
		},
		{
			text = LOCALE.lfgDisablePopupLeave,
			func = function()
				VWQL.DisableLFG_PopupLeave = not VWQL.DisableLFG_PopupLeave
			end,
			checkable = true,
		},
		{
			text = LOCALE.lfgDisableRightClickIcons,
			func = function()
				VWQL.DisableLFG_RightClickIcon = not VWQL.DisableLFG_RightClickIcon
				WorldQuestList_Update()
			end,
			checkable = true,
		},
		{
			text = LOCALE.lfgDisableEyeRight,
			func = function()
				VWQL.DisableLFG_EyeRight = not VWQL.DisableLFG_EyeRight
				if WorldQuestList.ObjectiveTracker_Update_hook then
					WorldQuestList.ObjectiveTracker_Update_hook(2)
				end
			end,
			checkable = true,
		},
		{
			text = LOCALE.lfgDisableEyeList,
			func = function()
				VWQL.LFG_HideEyeInList = not VWQL.LFG_HideEyeInList
				WorldQuestList_Update()
			end,
			checkable = true,
		},		
		
		
		{
			text = LOCALE.lfgDisableAll,
			func = function()
				StaticPopupDialogs["WQL_LFG_DISABLE_ALL"] = {
					text = LOCALE.lfgDisableAll2,
					button1 = YES,
					button2 = NO,
					OnAccept = function()
						VWQL.DisableLFG_Popup = nil
						VWQL.DisableLFG = nil
						VWQL.DisableIconsGeneral = true
						VWQL.DisableRewardIcons = true
						VWQL.MapIconsScale = nil
						VWQL.EnableEnigma = nil
						VWQL.DisableShellGame = true
						VWQL.DisableArrow = true
						
						VWQL[charKey].HideMap = true
						
						WorldQuestList.IconsGeneralLastMap = -1
						WorldQuestList_Update()
						WorldQuestList:Hide()
						
						WorldQuestList:WQIcons_RemoveIcons()
						WorldQuestList:WQIcons_RemoveScale()
					end,
					timeout = 0,
					whileDead = true,
					hideOnEscape = true,
					preferredIndex = 3,
				}
				ELib.ScrollDropDown.Close()
				StaticPopup_Show("WQL_LFG_DISABLE_ALL")
			end,
			checkable = false,
			padding = 16,
		},
	}	
	
	list[#list+1] = {
		text = LOCALE.lfgSearchOption,
		func = function()
			VWQL.DisableLFG = not VWQL.DisableLFG
			WorldQuestList_Update()
		end,
		checkable = true,
		subMenu = lfgSubMenu,
	}
	
	local function SetScaleArrow(_, arg1)
		VWQL.Arrow_Scale = arg1
		WQLdb.Arrow:Scale(arg1 or 1)
	end
	
	local arrowMenu = {
		{
			text = LOCALE.disableArrow,
			func = function()
				VWQL.DisableArrow = not VWQL.DisableArrow
				WorldQuestList_Update()
			end,
			checkable = true,
		},
		
		{text = TYPE,			isTitle = true,		padding = 16,			},
		{text = DEFAULT,	func = function() VWQL.ArrowStyle = nil ELib.ScrollDropDown.Close()	end,	radio = true,	},
		{text = "TomTom",	func = function() VWQL.ArrowStyle = 2	ELib.ScrollDropDown.Close()	end,	radio = true,	},
			
		{text = GetLocale() == "zhCN" and "列表窗口缩放" or UI_SCALE,		isTitle = true,		padding = 16,			},
		{text = "300%",			func = SetScaleArrow,	arg1 = 3,	radio = true	},
		{text = "250%",			func = SetScaleArrow,	arg1 = 2.5,	radio = true	},
		{text = "200%",			func = SetScaleArrow,	arg1 = 2,	radio = true	},
		{text = "175%",			func = SetScaleArrow,	arg1 = 1.75,	radio = true	},
		{text = "150%",			func = SetScaleArrow,	arg1 = 1.5,	radio = true	},
		{text = "140%",			func = SetScaleArrow,	arg1 = 1.4,	radio = true	},
		{text = "125%",			func = SetScaleArrow,	arg1 = 1.25,	radio = true	},
		{text = "110%",			func = SetScaleArrow,	arg1 = 1.1,	radio = true	},
		{text = "|cff00ff00100%",	func = SetScaleArrow,	arg1 = nil,	radio = true	},
		{text = "90%",			func = SetScaleArrow,	arg1 = 0.9,	radio = true	},
		{text = "80%",			func = SetScaleArrow,	arg1 = 0.8,	radio = true	},
		{text = "70%",			func = SetScaleArrow,	arg1 = 0.7,	radio = true	},
		{text = "60%",			func = SetScaleArrow,	arg1 = 0.6,	radio = true	},
		{text = "50%",			func = SetScaleArrow,	arg1 = 0.5,	radio = true	},
		{text = "40%",			func = SetScaleArrow,	arg1 = 0.4,	radio = true	},
		{
			text = LOCALE.disableArrowMove,
			func = function()
				VWQL.DisableArrowMove = not VWQL.DisableArrowMove
				WQLdb.Arrow.frame:SetMovable(not VWQL.DisableArrowMove)
				WorldQuestList_Update()				
			end,
			checkable = true,
		},
		{
			text = LOCALE.enableArrowQuests,
			func = function()
				VWQL.EnableArrowQuest = not VWQL.EnableArrowQuest
			end,
			checkable = true,
		},
	}
	
	list[#list+1] = {
		text = LOCALE.arrow,
		subMenu = arrowMenu,
		padding = 16,	
	}
	
	local function SetScaleOption(_, arg1)
		VWQL.Scale = arg1
		ELib.ScrollDropDown.Close()
		UpdateScale()
		WorldQuestList_Update()
	end
	
	local scaleSubMenu = {
		{text = "200%",			func = SetScaleOption,	arg1 = 2,	radio = true	},
		{text = "175%",			func = SetScaleOption,	arg1 = 1.75,	radio = true	},
		{text = "150%",			func = SetScaleOption,	arg1 = 1.5,	radio = true	},
		{text = "140%",			func = SetScaleOption,	arg1 = 1.4,	radio = true	},
		{text = "125%",			func = SetScaleOption,	arg1 = 1.25,	radio = true	},
		{text = "110%",			func = SetScaleOption,	arg1 = 1.1,	radio = true	},
		{text = "|cff00ff00100%",	func = SetScaleOption,	arg1 = nil,	radio = true	},
		{text = "90%",			func = SetScaleOption,	arg1 = 0.9,	radio = true	},
		{text = "85%",			func = SetScaleOption,	arg1 = 0.85,	radio = true	},
		{text = "80%",			func = SetScaleOption,	arg1 = 0.8,	radio = true	},
		{text = "75%",			func = SetScaleOption,	arg1 = 0.75,	radio = true	},
		{text = "70%",			func = SetScaleOption,	arg1 = 0.7,	radio = true	},
		{text = "65%",			func = SetScaleOption,	arg1 = 0.65,	radio = true	},
		{text = "60%",			func = SetScaleOption,	arg1 = 0.6,	radio = true	},
		{text = "50%",			func = SetScaleOption,	arg1 = 0.5,	radio = true	},
		{text = "40%",			func = SetScaleOption,	arg1 = 0.4,	radio = true	},
	}
	
	list[#list+1] = {
		text = GetLocale() == "zhCN" and "列表窗口缩放" or UI_SCALE,
		subMenu = scaleSubMenu,
		padding = 16,
	}

	local function SetAnchorOption(_, arg1)
		VWQL.Anchor = arg1
		UpdateAnchor()
		UpdateScale()
		ELib.ScrollDropDown.Close()
		WorldQuestList_Update()
	end

	local anchorSubMenu = {
		{text = "1 Right",		func = SetAnchorOption,	arg1 = nil,	radio = true	},
		{text = "2 Bottom",		func = SetAnchorOption,	arg1 = 1,	radio = true	},
		{text = "3 Inside",		func = SetAnchorOption,	arg1 = 2,	radio = true	},
		{text = "4 Free (Outside)",	func = SetAnchorOption,	arg1 = 3,	radio = true	},
	}

	list[#list+1] = {
		text = LOCALE.anchor,
		subMenu = anchorSubMenu,
		padding = 16,
	}	
		
	local azeriteFormatSubMenu = {
		{
			text = "2100",
			func = function()
				VWQL.AzeriteFormat = nil
				ELib.ScrollDropDown.Close()
				WorldQuestList_Update()
			end,
			radio = true,
		},
		{
			text = "1.1%",
			func = function()
				VWQL.AzeriteFormat = 10
				ELib.ScrollDropDown.Close()
				WorldQuestList_Update()
			end,
			radio = true,
		},
		{
			text = "2100 (1.1%)",
			func = function()
				VWQL.AzeriteFormat = 20
				ELib.ScrollDropDown.Close()
				WorldQuestList_Update()
			end,
			radio = true,
		},	
	}
	
	list[#list+1] = {
		text = LOCALE.apFormatSetup,
		subMenu = azeriteFormatSubMenu,
		padding = 16,
		shownFunc = function() return not WorldQuestList:IsLegionZone() or not WorldQuestList.optionsDropDown:IsVisible() end,
	}
	
	local function SetIconGeneral(_, arg1)
		VWQL["DisableIconsGeneralMap"..arg1] = not VWQL["DisableIconsGeneralMap"..arg1]
		WorldQuestList.IconsGeneralLastMap = -1
		WorldQuestList_Update()	  
	end
	
	local iconsGeneralSubmenu = {
		{text = WorldQuestList:GetMapName(947),	func = SetIconGeneral,	checkable = true,	arg1=947	},	
		{text = WorldQuestList:GetMapName(875),	func = SetIconGeneral,	checkable = true,	arg1=875	},	
		{text = WorldQuestList:GetMapName(876),	func = SetIconGeneral,	checkable = true,	arg1=876	},	
		{text = WorldQuestList:GetMapName(619),	func = SetIconGeneral,	checkable = true,	arg1=619	},	
		{text = WorldQuestList:GetMapName(905),	func = SetIconGeneral,	checkable = true,	arg1=905	},	
	}
	list[#list+1] = {
		text = LOCALE.iconsOnMinimap,
		func = function()
			VWQL.DisableIconsGeneral = not VWQL.DisableIconsGeneral
			WorldQuestList.IconsGeneralLastMap = -1
			WorldQuestList_Update()
		end,
		checkable = true,
		subMenu = iconsGeneralSubmenu,
	}
	
	local rewardsIconsSubMenu = {
		{
			text = LOCALE.disableRibbon,
			func = function()
				VWQL.DisableRibbon = not VWQL.DisableRibbon
				WorldMapFrame:TriggerEvent("WorldQuestsUpdate", WorldMapFrame:GetNumActivePinsByTemplate("WorldMap_WorldQuestPinTemplate"))
			end,
			checkable = true,
		},
		{
			text = LOCALE.enableRibbonGeneralMap,
			func = function()
				VWQL.EnableRibbonGeneralMaps = not VWQL.EnableRibbonGeneralMaps
				WorldMapFrame:TriggerEvent("WorldQuestsUpdate", WorldMapFrame:GetNumActivePinsByTemplate("WorldMap_WorldQuestPinTemplate"))
			end,
			checkable = true,
		},
	}	
	list[#list+1] = {
		text = LOCALE.disableRewardIcons,
		colorCode = "|cff00ff00",
		func = function()
			VWQL.DisableRewardIcons = not VWQL.DisableRewardIcons
			if VWQL.DisableRewardIcons then
				WorldQuestList:WQIcons_RemoveIcons()
			else
				WorldQuestList:WQIcons_AddIcons()
			end
		end,
		checkable = true,
		subMenu = rewardsIconsSubMenu,
	}
	
	local mapIconsScaleSubmenu = {
		{text = "",	isTitle = true,	slider = {min = 80, max = 300, val = 100, afterText = "%", func = nil}	},	
	}
	mapIconsScaleSubmenu[1].slider.func = function(self,val)
		mapIconsScaleSubmenu[1].slider.val = val
		VWQL.MapIconsScale = val / 100
		WorldMapFrame:TriggerEvent("WorldQuestsUpdate", WorldMapFrame:GetNumActivePinsByTemplate("WorldMap_WorldQuestPinTemplate"))
	end
	list[#list+1] = {
		text = LOCALE.mapIconsScale,
		padding = 16,
		subMenu = mapIconsScaleSubmenu,
	}
		
	local listSizeSubmenu = {
		{
			text = LOCALE.topLine,
			func = function()
				VWQL.DisableHeader = not VWQL.DisableHeader
				ELib.ScrollDropDown.Close()
				WorldQuestList_Update()
			end,
			checkable = true,
		},
		{
			text = LOCALE.bottomLine,
			func = function()
				VWQL.DisableTotalAP = not VWQL.DisableTotalAP
				ELib.ScrollDropDown.Close()
				WorldQuestList_Update()
			end,
			checkable = true,
		},
		{
			text = LOCALE.maxLines,
			isTitle = true,
		},
		{text = "",	isTitle = true,	slider = {min = 9, max = 101, val = 9, func = nil}	},	
	}
	listSizeSubmenu[4].slider.func = function(self,val)
		listSizeSubmenu[4].slider.val = val
		if val < 10 or val > 100 then
			val = nil
		end
		VWQL.MaxLinesShow = val
		self.text:SetText(val or LOCALE.unlimited)
		WorldQuestList_Update()
	end
	listSizeSubmenu[4].slider.show = function(self)
		if not VWQL.MaxLinesShow then
			self.text:SetText(LOCALE.unlimited)
		end
	end	
	
	list[#list+1] = {
		text = LOCALE.listSize,
		padding = 16,
		subMenu = listSizeSubmenu,
	}
	
	list[#list+1] = {
		text = LOCALE.disabeHighlightNewQuests,
		func = function()
			VWQL.DisableHighlightNewQuest = not VWQL.DisableHighlightNewQuest
			WorldQuestList_Update()
		end,
		checkable = true,
	}
	
	local GetFaction = function(id,non_translated) 
		return FACTION.." "..(GetFactionInfoByID(id) or non_translated or ("ID "..tostring(id)))
	end
	local function SetHighlighFaction(_, arg1)
		VWQL[charKey][arg1] = not VWQL[charKey][arg1]
		ELib.ScrollDropDown.UpdateChecks()
		WorldQuestList_Update()
	end
	local highlightingSubmenu = {
		{text = GetFaction(2164),	func = SetHighlighFaction,	arg1 = "faction2164Highlight",	checkable = true,	shownFunc = function() return WorldQuestList:IsFactionAvailable(2164) end	},
		{text = GetFaction(2163),	func = SetHighlighFaction,	arg1 = "faction2163Highlight",	checkable = true,	shownFunc = function() return WorldQuestList:IsFactionAvailable(2163) end	},
		{text = GetFaction(2157),	func = SetHighlighFaction,	arg1 = "faction2157Highlight",	checkable = true,	shownFunc = function() return WorldQuestList:IsFactionAvailable(2157) end	},
		{text = GetFaction(2156),	func = SetHighlighFaction,	arg1 = "faction2156Highlight",	checkable = true,	shownFunc = function() return WorldQuestList:IsFactionAvailable(2156) end	},
		{text = GetFaction(2103),	func = SetHighlighFaction,	arg1 = "faction2103Highlight",	checkable = true,	shownFunc = function() return WorldQuestList:IsFactionAvailable(2103) end	},
		{text = GetFaction(2158),	func = SetHighlighFaction,	arg1 = "faction2158Highlight",	checkable = true,	shownFunc = function() return WorldQuestList:IsFactionAvailable(2158) end	},
		{text = GetFaction(2159),	func = SetHighlighFaction,	arg1 = "faction2159Highlight",	checkable = true,	shownFunc = function() return WorldQuestList:IsFactionAvailable(2159) end	},
		{text = GetFaction(2160),	func = SetHighlighFaction,	arg1 = "faction2160Highlight",	checkable = true,	shownFunc = function() return WorldQuestList:IsFactionAvailable(2160) end	},
		{text = GetFaction(2162),	func = SetHighlighFaction,	arg1 = "faction2162Highlight",	checkable = true,	shownFunc = function() return WorldQuestList:IsFactionAvailable(2162) end	},
		{text = GetFaction(2161),	func = SetHighlighFaction,	arg1 = "faction2161Highlight",	checkable = true,	shownFunc = function() return WorldQuestList:IsFactionAvailable(2161) end	},
	}
	
	list[#list+1] = {
		text = HIGHLIGHTING.." "..REPUTATION,
		padding = 16,
		subMenu = highlightingSubmenu,
		shownFunc = function() return not WorldQuestList:IsLegionZone() or not WorldQuestList.optionsDropDown:IsVisible() end,
	}	
	
	list[#list+1] = {
		text = (UnitFactionGroup("player") == "Alliance" and "|TInterface\\FriendsFrame\\PlusManz-Alliance:16|t " or "|TInterface\\FriendsFrame\\PlusManz-Horde:16|t ")..LOCALE.addQuestsOpposite,
		func = function()
			VWQL.OppositeContinent = not VWQL.OppositeContinent
			WorldQuestList_Update()
		end,
		checkable = true,
		shownFunc = function() return not WorldQuestList:IsLegionZone() or not WorldQuestList.optionsDropDown:IsVisible() end,
		mark = "OppositeContinent",
	}
	list[#list+1] = {
		text = LOCALE.addQuestsArgus,
		func = function()
			VWQL.OppositeContinentArgus = not VWQL.OppositeContinentArgus
			WorldQuestList_Update()
		end,
		checkable = true,
		shownFunc = function() return WorldQuestList:IsLegionZone() or not WorldQuestList.optionsDropDown:IsVisible() end,
	}
	list[#list+1] = {
		text = "|T1339312:16:16:0:0:512:128:246:262:111:126|t "..LOCALE.hideLegion,
		func = function()
			VWQL.HideLegion = not VWQL.HideLegion
			WorldQuestList_Update()
		end,
		checkable = true,
		mark = "HideLegion",
	}
	list[#list+1] = {
		text = LOCALE.argusMap,
		func = function()
			VWQL.ArgusMap = not VWQL.ArgusMap
			ELib.ScrollDropDown.Close()
			if GetCurrentMapAreaID() == 905 then
				WorldMapFrame:SetMapID(885)
				WorldMapFrame:SetMapID(905)
			end
			WorldQuestList_Update()
		end,
		checkable = true,
		shownFunc = function() return WorldQuestList:IsLegionZone() or not WorldQuestList.optionsDropDown:IsVisible() end,
	}
	
	list[#list+1] = {
		text = LOCALE.enigmaHelper,
		func = function()
			VWQL.EnableEnigma = not VWQL.EnableEnigma
		end,
		checkable = true,
		shownFunc = function() return WorldQuestList:IsLegionZone() or not WorldQuestList.optionsDropDown:IsVisible() end,
	}
	list[#list+1] = {
		text = LOCALE.barrelsHelper,
		func = function()
			VWQL.DisableBarrels = not VWQL.DisableBarrels
		end,
		checkable = true,
		shownFunc = function() return WorldQuestList:IsLegionZone() or not WorldQuestList.optionsDropDown:IsVisible() end,
	}
	list[#list+1] = {
		text = LOCALE.shellGameHelper,
		func = function()
			VWQL.DisableShellGame = not VWQL.DisableShellGame
		end,
		checkable = true,
		shownFunc = function() return not WorldQuestList:IsLegionZone() or not WorldQuestList.optionsDropDown:IsVisible() end,
	}
	
	list[#list+1] = {
		text = LOCALE.ignoreList,
		func = function()
			ELib.ScrollDropDown.Close()
			WorldQuestList.BlackListWindow:Show()
		end,
		padding = 16,
	}
	
	list[#list+1] = {
		text = CLOSE,
		func = function() ELib.ScrollDropDown.Close() end,
		padding = 16,
	}
	
	function WorldQuestList.optionsDropDown.Button:additionalToggle()
		for i=1,#self.List do
			if self.List[i].text == LOCALE.barrelsHelper then
				self.List[i].checkState = not VWQL.DisableBarrels
			elseif self.List[i].text == LOCALE.enigmaHelper then
				self.List[i].checkState = VWQL.EnableEnigma
			elseif self.List[i].text == LOCALE.disabeHighlightNewQuests then
				self.List[i].checkState = VWQL.DisableHighlightNewQuest
			elseif self.List[i].text == LOCALE.disableBountyIcon then
				self.List[i].checkState = VWQL.DisableBountyIcon
			elseif self.List[i].mark == "OppositeContinent" then
				self.List[i].checkState = VWQL.OppositeContinent
			elseif self.List[i].mark == "HideLegion" then
				self.List[i].checkState = VWQL.HideLegion
			elseif self.List[i].text == LOCALE.shellGameHelper then
				self.List[i].checkState = not VWQL.DisableShellGame
			elseif self.List[i].text == LOCALE.iconsOnMinimap then
				self.List[i].checkState = not VWQL.DisableIconsGeneral
			elseif self.List[i].text == LOCALE.addQuestsArgus then
				self.List[i].checkState = not VWQL.OppositeContinentArgus
			elseif self.List[i].text == LOCALE.argusMap then
				self.List[i].checkState = not VWQL.ArgusMap
			elseif self.List[i].text == LOCALE.lfgSearchOption then
				self.List[i].checkState = not VWQL.DisableLFG
			elseif self.List[i].text == LOCALE.disableRewardIcons then
				self.List[i].checkState = not VWQL.DisableRewardIcons
			end
		end		
		anchorSubMenu[1].checkState = not VWQL.Anchor
		anchorSubMenu[2].checkState = VWQL.Anchor == 1
		anchorSubMenu[3].checkState = VWQL.Anchor == 2
		anchorSubMenu[4].checkState = VWQL.Anchor == 3
		for i=1,#scaleSubMenu do
			scaleSubMenu[i].checkState = VWQL.Scale == scaleSubMenu[i].arg1
		end
		azeriteFormatSubMenu[1].checkState = not VWQL.AzeriteFormat
		azeriteFormatSubMenu[2].checkState = VWQL.AzeriteFormat == 10
		azeriteFormatSubMenu[3].checkState = VWQL.AzeriteFormat == 20
		arrowMenu[1].checkState = VWQL.DisableArrow
		arrowMenu[3].checkState = VWQL.ArrowStyle ~= 2
		arrowMenu[4].checkState = VWQL.ArrowStyle == 2		
		for i=6,#arrowMenu-2 do
			arrowMenu[i].checkState = VWQL.Arrow_Scale == arrowMenu[i].arg1
		end
		arrowMenu[#arrowMenu - 1].checkState = VWQL.DisableArrowMove
		arrowMenu[#arrowMenu].checkState = VWQL.EnableArrowQuest
		for i=1,#iconsGeneralSubmenu do
			iconsGeneralSubmenu[i].checkState = not VWQL["DisableIconsGeneralMap"..iconsGeneralSubmenu[i].arg1]
		end
		lfgSubMenu[1].checkState = VWQL.DisableLFG_Popup
		lfgSubMenu[2].checkState = VWQL.DisableLFG_PopupLeave
		lfgSubMenu[3].checkState = VWQL.DisableLFG_RightClickIcon
		lfgSubMenu[4].checkState = VWQL.DisableLFG_EyeRight
		lfgSubMenu[5].checkState = VWQL.LFG_HideEyeInList
		mapIconsScaleSubmenu[1].slider.val = (VWQL.MapIconsScale or 1) * 100
		rewardsIconsSubMenu[1].checkState = VWQL.DisableRibbon
		rewardsIconsSubMenu[2].checkState = VWQL.EnableRibbonGeneralMaps
		listSizeSubmenu[1].checkState = not VWQL.DisableHeader
		listSizeSubmenu[2].checkState = not VWQL.DisableTotalAP
		listSizeSubmenu[4].slider.val = (VWQL.MaxLinesShow or 9)
		for i=1,#highlightingSubmenu do
			highlightingSubmenu[i].checkState = VWQL[charKey][highlightingSubmenu[i].arg1]
		end
	end	
end

WorldQuestList.modeSwitcherCheck = CreateFrame("Frame", nil, WorldQuestList)
WorldQuestList.modeSwitcherCheck:SetSize(130,22)

WorldQuestList.modeSwitcherCheck.b = WorldQuestList.modeSwitcherCheck:CreateTexture(nil,"BACKGROUND",nil,1)
WorldQuestList.modeSwitcherCheck.b:SetAllPoints()
WorldQuestList.modeSwitcherCheck.b:SetColorTexture(0.04,0.04,0.14,.97)

ELib.Templates:Border(WorldQuestList.modeSwitcherCheck,.22,.22,.3,1,1)
WorldQuestList.modeSwitcherCheck.shadow = ELib:Shadow2(WorldQuestList.modeSwitcherCheck,16)

WorldQuestList.modeSwitcherCheck.ShadowLeftBottom:Hide()
WorldQuestList.modeSwitcherCheck.ShadowBottom:Hide()
WorldQuestList.modeSwitcherCheck.ShadowBottomLeftInside:Hide()
WorldQuestList.modeSwitcherCheck.ShadowBottomRightInside:Hide()
WorldQuestList.modeSwitcherCheck.ShadowBottomRight:Hide()

WorldQuestList.modeSwitcherCheck.s = CreateFrame("Slider", nil, WorldQuestList.modeSwitcherCheck)
WorldQuestList.modeSwitcherCheck.s:SetPoint("CENTER")
WorldQuestList.modeSwitcherCheck.s:SetSize(96,16)
ELib.Templates:Border(WorldQuestList.modeSwitcherCheck.s,.22,.22,.3,1,1,2)

WorldQuestList.modeSwitcherCheck.s.thumb = WorldQuestList.modeSwitcherCheck.s:CreateTexture(nil, "ARTWORK")
WorldQuestList.modeSwitcherCheck.s.thumb:SetColorTexture(.32,.32,.4,1)
WorldQuestList.modeSwitcherCheck.s.thumb:SetSize(28,12)

WorldQuestList.modeSwitcherCheck.s:SetThumbTexture(WorldQuestList.modeSwitcherCheck.s.thumb)
WorldQuestList.modeSwitcherCheck.s:SetOrientation("HORIZONTAL")
WorldQuestList.modeSwitcherCheck.s:SetMinMaxValues(0,2)
WorldQuestList.modeSwitcherCheck.s:SetValue(0)
WorldQuestList.modeSwitcherCheck.s:SetValueStep(1)
WorldQuestList.modeSwitcherCheck.s:SetObeyStepOnDrag(true)

WorldQuestList.modeSwitcherCheck.s:SetScript("OnValueChanged",function(self)
	if self.isSetup then
		return
	end
	if self.middleOn then
		if self:GetValue() > 1.33 then
			VWQL[charKey].RegularQuestMode = true
			VWQL[charKey].TreasureMode = nil
		elseif self:GetValue() < 0.66 then
			VWQL[charKey].RegularQuestMode = nil
			VWQL[charKey].TreasureMode = nil
		else
			VWQL[charKey].RegularQuestMode = nil
			VWQL[charKey].TreasureMode = true
		end
	else
		if self:GetValue() > .5 then
			VWQL[charKey].RegularQuestMode = true
			VWQL[charKey].TreasureMode = nil
		else
			VWQL[charKey].RegularQuestMode = nil
			VWQL[charKey].TreasureMode = nil
		end	
	end
	WQL_AreaPOIDataProviderMixin:RefreshAllData()
	WorldQuestList_Update()			
end)

WorldQuestList.modeSwitcherCheck.s.tl = WorldQuestList.modeSwitcherCheck.s:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall")
WorldQuestList.modeSwitcherCheck.s.tl:SetPoint("LEFT",4,0)
WorldQuestList.modeSwitcherCheck.s.tl:SetText("世界")

WorldQuestList.modeSwitcherCheck.s.tr = WorldQuestList.modeSwitcherCheck.s:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall")
WorldQuestList.modeSwitcherCheck.s.tr:SetPoint("RIGHT",-4,0)
WorldQuestList.modeSwitcherCheck.s.tr:SetText("普通")

WorldQuestList.modeSwitcherCheck.s.tc = WorldQuestList.modeSwitcherCheck.s:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall")
WorldQuestList.modeSwitcherCheck.s.tc:SetPoint("CENTER",0,0)
WorldQuestList.modeSwitcherCheck.s.tc:SetText("T")

WorldQuestList.modeSwitcherCheck.s.hl = WorldQuestList.modeSwitcherCheck.s:CreateTexture(nil, "BACKGROUND")
WorldQuestList.modeSwitcherCheck.s.hl:SetPoint("TOPLEFT", -2, 0)
WorldQuestList.modeSwitcherCheck.s.hl:SetPoint("BOTTOMRIGHT", 2, 0)
WorldQuestList.modeSwitcherCheck.s.hl:SetTexture("Interface\\Buttons\\WHITE8X8")
WorldQuestList.modeSwitcherCheck.s.hl:SetVertexColor(.7,.7,1,.15)
WorldQuestList.modeSwitcherCheck.s.hl:Hide()

WorldQuestList.modeSwitcherCheck.s:SetScript("OnEnter",function(self) self.hl:Show() end)
WorldQuestList.modeSwitcherCheck.s:SetScript("OnLeave",function(self) self.hl:Hide() end)

WorldQuestList.modeSwitcherCheck.Update = function(self,showMiddle)
	self.s.isSetup = true
	if showMiddle then
		self.s.middleOn = true
		self.s:SetMinMaxValues(0,2)
		self.s.tc:Show()
		self.s.thumb:SetWidth(30)
		if VWQL[charKey].TreasureMode then
			self.s:SetValue(1)
		elseif VWQL[charKey].RegularQuestMode then
			self.s:SetValue(2)
		else
			self.s:SetValue(0)
		end
	else
		self.s.middleOn = false
		self.s:SetMinMaxValues(0,1)
		self.s.tc:Hide()
		self.s.thumb:SetWidth(44)
		if VWQL[charKey].RegularQuestMode then
			self.s:SetValue(1)
		else
			self.s:SetValue(0)
		end
	end
	self.s.isSetup = nil
end

WorldQuestList.modeSwitcherCheck.AutoSetValue = function(self)
	if self.s.middleOn then
		if VWQL[charKey].TreasureMode then
			self.s:SetValue(1)
		elseif VWQL[charKey].RegularQuestMode then
			self.s:SetValue(2)
		else
			self.s:SetValue(0)
		end	
	else
		if VWQL[charKey].RegularQuestMode then
			self.s:SetValue(1)
		else
			self.s:SetValue(0)
		end	
	end
end


WorldQuestList.oppositeContinentButton = ELib:DropDown(WorldQuestList,"|TInterface\\FriendsFrame\\PlusManz-Alliance:16|t")
WorldQuestList.oppositeContinentButton.t:ClearAllPoints()
WorldQuestList.oppositeContinentButton.t:SetPoint("CENTER")
WorldQuestList.oppositeContinentButton:SetWidth(24)
WorldQuestList.oppositeContinentButton.l:Hide()
WorldQuestList.oppositeContinentButton.Button.i:Hide()
WorldQuestList.oppositeContinentButton.Button:SetAllPoints()
WorldQuestList.oppositeContinentButton.Button:SetScript("OnClick",function(self)
	WorldMapFrame:SetMapID(self.mapID or 875)
	WorldQuestList.SoloMapID = self.mapID or 875
	if WorldQuestList.IsSoloRun then
		WorldQuestList_Update()	
	end
end)
WorldQuestList.oppositeContinentButton.Update = function(self)
	local faction
	
	local mapID = GetCurrentMapAreaID()
	if WorldQuestList.IsSoloRun then
		mapID = WorldQuestList.SoloMapID
	end
	
	if WorldQuestList:IsMapParent(mapID,875) then
		faction = 1
	elseif WorldQuestList:IsMapParent(mapID,876) then
		faction = 2
	elseif UnitFactionGroup("player") == "Alliance" then
		faction = 1
	else
		faction = 2
	end

	if faction == 1 then
		self.t:SetText("|TInterface\\FriendsFrame\\PlusManz-Alliance:16|t")
		self.Button.mapID = 876
	else
		self.t:SetText("|TInterface\\FriendsFrame\\PlusManz-Horde:16|t")
		self.Button.mapID = 875
	end
end
if UnitLevel'player' < 120 then
	--WorldQuestList.oppositeContinentButton:Hide()
end

WorldQuestList.moveHeader = ELib:DropDown(WorldQuestList,"")
WorldQuestList.moveHeader:SetPoint("BOTTOMLEFT",WorldQuestList.oppositeContinentButton,"BOTTOMLEFT",0,0)
WorldQuestList.moveHeader:SetPoint("TOPRIGHT",WorldQuestList.oppositeContinentButton,"TOPLEFT",30,0)
--WorldQuestList.moveHeader:SetWidth(50)
WorldQuestList.moveHeader.l:Hide()
WorldQuestList.moveHeader.t:ClearAllPoints()
WorldQuestList.moveHeader.t:SetPoint("CENTER",0,0)
WorldQuestList.moveHeader.Button.i:Hide()
WorldQuestList.moveHeader.Button:SetAllPoints()
WorldQuestList.moveHeader.Button:SetScript("OnClick",nil)
WorldQuestList.moveHeader.Button:RegisterForDrag("LeftButton")

WorldQuestList.moveHeader.Button:SetScript("OnDragStart", function(self)
	WorldQuestList:SetMovable(true)
	--WorldQuestList:SetClampedToScreen(true)
	WorldQuestList:StartMoving()
	WorldQuestList.IsOnMove = true
	self.ticker = C_Timer.NewTicker(0.5,function()
		WorldQuestList_Update()
	end)
end)
WorldQuestList.moveHeader.Button:SetScript("OnDragStop", function(self)
	WorldQuestList:StopMovingOrSizing()
	WorldQuestList:SetMovable(false)
	WorldQuestList:SetClampedToScreen(false)
	WorldQuestList.IsOnMove = nil
	if WorldQuestList.IsSoloRun then
		VWQL.PosLeft = WorldQuestList:GetLeft()
		VWQL.PosTop = WorldQuestList:GetTop()
		
		WorldQuestList:ClearAllPoints()
		WorldQuestList:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VWQL.PosLeft,VWQL.PosTop)
	end
	if VWQL.Anchor == 3 and WorldMapFrame:IsVisible() then
		VWQL.Anchor3PosLeft = WorldQuestList:GetLeft()
		VWQL.Anchor3PosTop = WorldQuestList:GetTop()

		WorldQuestList:ClearAllPoints()
		WorldQuestList:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VWQL.Anchor3PosLeft,VWQL.Anchor3PosTop)
	end
	if self.ticker then
		self.ticker:Cancel()
		self.ticker = nil
	end
end)
WorldQuestList.moveHeader:Hide()

WorldQuestList.moveHeader:SetClampedToScreen(true)


local SortFuncs = {
	function(a,b) if a and b and a.time and b.time then 
			if abs(a.time - b.time) <= 2 then 
				return a.faction < b.faction 
			else 
				return a.time < b.time 
			end 
		end 
	end,
	function(a,b) if a and b then 
			if a.zoneID == b.zoneID then
				if abs(a.time - b.time) <= 2 then 
					return a.name < b.name 
				else
					return a.time < b.time 
				end
			else
				return a.zoneID < b.zoneID
			end
		end
	end,
	function(a,b) return a.name < b.name end,
	function(a,b) if a.faction == b.faction then 
			if a.time and b.time then 
				if abs(a.time - b.time) <= 2 then 
					return a.name < b.name 
				else 
					return a.time < b.time 
				end 
			else 
				return a.name < b.name 
			end
		else 
			return a.faction < b.faction 
		end
	end,
	function(a,b) if a and b then 
			if a.rewardType ~= b.rewardType then 
				return a.rewardType < b.rewardType 
			elseif a.rewardSort == b.rewardSort then
				return (a.questID or 0) > (b.questID or 0)
			else
				return a.rewardSort > b.rewardSort 
			end 
		end 
	end,
	function(a,b) if a and b then return a.distance < b.distance end end,
}



WorldQuestList.WMF_activePins = {}
local WQ_provider
for provider,status in pairs(WorldMapFrame.dataProviders) do
	if status and provider.AddWorldQuest and provider:GetPinTemplate() == "WorldMap_WorldQuestPinTemplate" then	--Any way to do this not so ugly?
		WQ_provider = provider
		break
	end
end
WorldQuestList.WMF_WQ_provider = WQ_provider
if WQ_provider then
	WQ_provider:GetMap():RegisterCallback("WorldQuestsUpdate", function()
		if WorldQuestList.IconsGeneralLastMap and WorldMapFrame:GetMapID() ~= WorldQuestList.IconsGeneralLastMap then
			for questId in pairs(WorldQuestList.WMF_activePins) do
				if WQ_provider.pingPin and WQ_provider.pingPin:IsAttachedToQuest(questId) then
					WQ_provider.pingPin:Stop()
				end
				local pin = WorldQuestList.WMF_activePins[questId]
		
				WQ_provider:GetMap():RemovePin(pin)
			end
			wipe(WorldQuestList.WMF_activePins)			
			WorldQuestList.IconsGeneralLastMap = nil
		else
			for questId,pin in pairs(WorldQuestList.WMF_activePins) do
				pin:RefreshVisuals()
			end
			WorldQuestList:WQIcons_AddIcons()
		end
		
		local mapID = WQ_provider:GetMap():GetMapID()
		if VWQL[charKey].TreasureMode and WorldQuestList.TreasureData[mapID or 0] then		
			WQ_provider:RemoveAllData()
		end
	end)
end

WQL_AreaPOIDataProviderMixin = CreateFromMixins(AreaPOIDataProviderMixin)

function WQL_AreaPOIDataProviderMixin:OnShow()
end

function WQL_AreaPOIDataProviderMixin:GetPinTemplate()
	return "WQL_AreaPOIPinTemplate";
end
function WQL_AreaPOIDataProviderMixin:RemoveAllData()
	self:GetMap():RemoveAllPinsByTemplate(self:GetPinTemplate())
end
function WQL_AreaPOIDataProviderMixin:RefreshAllData()
	if not self:GetMap() then	--fix error on load
		return
	end
	self:RemoveAllData()
	
	if not VWQL[charKey].TreasureMode then
		return
	end
	
	local mapID = self:GetMap():GetMapID()
	
	local treasureData = WorldQuestList.TreasureData[mapID]
	if treasureData then
		for i=1,#treasureData do		
			local x,y,name,tType,reward,note,questID,specialFunc = 
				treasureData[i][1],treasureData[i][2],treasureData[i][3],treasureData[i][4],treasureData[i][5],treasureData[i][6],treasureData[i][7],treasureData[i][8]
			
			if (not questID or not IsQuestFlaggedCompleted(questID)) and (not specialFunc or specialFunc()) then
				local pin = self:GetMap():AcquirePin(self:GetPinTemplate(), {
					areaPoiID = 0,
					name = name,
					description = note,
					position = CreateVector2D(x, y),
					atlasName = tType == 3 and "VignetteLoot" or 
						tType == 2 and "worldquest-questmarker-epic" or
						"worldquest-questmarker-rare",
					itemID = reward,
					clickData = {
						x = x,
						y = y,
						mapID = mapID,
					}
				})
				
				if not pin.Background then
					pin.Background = pin:CreateTexture()
					pin.Background:SetPoint("CENTER",1,-1)
				end
				if not pin.Overlay then
					pin.Overlay = pin:CreateTexture()
					pin.Overlay:SetPoint("CENTER",0,0)
				end
								
				if tType == 2 then
					pin.Background:SetAtlas("worldquest-questmarker-dragon")
					pin.Background:SetSize(22,22)
				else
					pin.Background:SetTexture()
				end
	
				if tType == 2 or tType == 1 then
					pin.Overlay:SetAtlas("worldquest-questmarker-questbang")
					pin.Overlay:SetSize(3,8)
				else
					pin.Overlay:SetTexture()
				end
				
				if tType == 3 then
					pin:SetSize(17,17)
					pin.Texture:SetSize(20,20)
				else
					pin:SetSize(15,15)
					pin.Texture:SetSize(13,13)
				end
			end
		end		
	end	
end
WQL_AreaPOIDataProviderMixin.WQL_Signature = true


local inspectScantip = CreateFrame("GameTooltip", GlobalAddonName.."WorldQuestListInspectScanningTooltip", nil, "GameTooltipTemplate")
inspectScantip:SetOwner(UIParent, "ANCHOR_NONE")

local ITEM_LEVEL = (ITEM_LEVEL or "NO DATA FOR ITEM_LEVEL"):gsub("%%d","(%%d+%+*)")

local NUM_WORLDMAP_TASK_POIS = 0

local function WorldQuestList_Leveling_Update()
	local quests = {}
	local prevHeader = nil
	for i=1,GetNumQuestLogEntries() do
		local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID = GetQuestLogTitle(i)
		if isHeader then
			prevHeader = title
		elseif questID and questID ~= 0 then
			quests[#quests+1] = {
				title = title,
				header = prevHeader,
				questID = questID,
				isCompleted = IsQuestComplete(questID),
				id = i,
			}
		end
	end
	
	local currMapID = GetCurrentMapAreaID()
	if UnitLevel'player' < 110 then
		local taskInfo = C_TaskQuest.GetQuestsForPlayerByMapID(currMapID)
		
		for _,info in pairs(taskInfo or {}) do
			if HaveQuestData(info.questId) and QuestUtils_IsQuestWorldQuest(info.questId) then
				local _,_,worldQuestType,rarity, isElite, tradeskillLineIndex, allowDisplayPastCritical = GetQuestTagInfo(info.questId)
				
				quests[#quests+1] = {
					title = C_TaskQuest.GetQuestInfoByQuestID(info.questId),
					header = MAP_UNDER_INVASION,
					questID = info.questId,
					isCompleted = false,
					isInvasion = worldQuestType == LE.LE_QUEST_TAG_TYPE_INVASION,
					isElite = isElite,
					isWQ = true,
				}				
			end
		end
	end
		
	local numTaskPOIs = #quests
	
	if ( NUM_WORLDMAP_TASK_POIS < numTaskPOIs ) then
		for i=NUM_WORLDMAP_TASK_POIS+1, numTaskPOIs do
			WorldQuestList_CreateLine(i)
		end
		NUM_WORLDMAP_TASK_POIS = numTaskPOIs
	end
	
	local result = {}
	local taskIconIndex = 1
	
	
	if ( numTaskPOIs > 0 ) then
		for i, questData in ipairs(quests) do
			local title = questData.title
			local header = questData.header
			local questID = questData.questID

			local _,x,y = QuestPOIGetIconInfo(questID)
			if questData.isWQ then
				x,y = C_TaskQuest.GetQuestLocation(questID,currMapID)
			end
			
			local overrideMap = nil
			if not x then
				local questMapID = GetQuestUiMapID(questID)
				if questMapID then
					x,y = WorldQuestList:GetQuestCoord_NonWQ(questID,questMapID,currMapID)
					if x then
						overrideMap = questMapID
					end
				end
			end
			
			if x and y and x ~= 0 and y ~= 0 then
				local rewardXP = GetQuestLogRewardXP(questID)
				if rewardXP == 0 then
					rewardXP = nil
				end
				
				local reward, rewardColor
				
				local numRewards = GetNumQuestLogRewards(questID)
				if numRewards > 0 then
					local name,icon,numItems,quality,_,itemID = GetQuestLogRewardInfo(1,questID)
					if name then
						reward = "|T"..icon..":0|t "..name..(numItems and numItems > 1 and " x"..numItems or "")
					end
					
					if quality and quality >= LE.LE_ITEM_QUALITY_COMMON and LE.BAG_ITEM_QUALITY_COLORS[quality] then
						rewardColor = LE.BAG_ITEM_QUALITY_COLORS[quality]
					end
					
				end
				
				if not reward then
					local numQuestCurrencies = GetNumQuestLogRewardCurrencies(questID)
					for i = 1, numQuestCurrencies do
						local name, texture, numItems = GetQuestLogRewardCurrencyInfo(i, questID)
						local text = BONUS_OBJECTIVE_REWARD_WITH_COUNT_FORMAT:format(texture, numItems, name)
						
						reward = text
					end
				end
					
				tinsert(result,{
					questID = questID,
					name = (questData.isCompleted and "|cff00ff00" or "")..title,
					info = {
						x = x,
						y = y,
						mapID = overrideMap or currMapID,
						defMapID = currMapID,
					},
					rewardXP = rewardXP,
					reward = reward,
					rewardColor = rewardColor,
					header = header,
					numRewards = numRewards,
					isInvasion = questData.isInvasion,
					isElite = questData.isElite,
					isCompleted = questData.isCompleted,
					disableLFG = WorldQuestList:IsQuestDisabledForLFG(questID),
				})
			end
		end
	end
	
	local lfgEyeStatus = true
	if C_LFGList.GetActiveEntryInfo() or VWQL.DisableLFG or VWQL.LFG_HideEyeInList then
		lfgEyeStatus = false
	end
	
	for i=1,#result do
		local data = result[i]
		local line = WorldQuestList.l[taskIconIndex]
		
		line.name:SetText(data.name)
		line.name:SetTextColor(1,1,1)
		
		line.nameicon:SetTexture("")
		line.nameicon:SetWidth(1)
		line.secondicon:SetTexture("")
		line.secondicon:SetWidth(1)		
		
		line.reward:SetText(data.reward or "")
		if data.rewardColor then
			line.reward:SetTextColor(data.rewardColor.r, data.rewardColor.g, data.rewardColor.b)
		else
			line.reward:SetTextColor(1,1,1)
		end
		if data.reward then
			line.reward.ID = data.questID
		else
			line.reward.ID = nil
		end
		if data.numRewards and data.numRewards > 1 then
			line.reward.IDs = data.numRewards
		else
			line.reward.IDs = nil
		end
		line.isRewardLink = nil
		
		local questNameWidth = WorldQuestList.NAME_WIDTH
		if data.isInvasion then
			line.secondicon:SetAtlas("worldquest-icon-burninglegion")
			line.secondicon:SetWidth(16)
			
			line.name:SetTextColor(0.78, 1, 0)
			
			if data.isElite then
				line.nameicon:SetAtlas("nameplates-icon-elite-silver")
				line.nameicon:SetWidth(16)
				questNameWidth = questNameWidth - 15
			end
			
			questNameWidth = questNameWidth - 15
		end

		line.name:SetWidth(questNameWidth)
		
		line.faction:SetText(data.header or "")
		line.faction:SetTextColor(1,1,1)
		
		line.zone:SetText("")
		line.timeleft:SetText(data.rewardXP or "")

		line.zone:Hide()
		line.zone.f:Hide()
		
		line.questID = data.questID
		line.numObjectives = 0
		
		line.nqhl:Hide()
		
		if lfgEyeStatus then
			if data.isCompleted or data.disableLFG then
				line.LFGButton.questID = nil
			else
				line.LFGButton.questID = data.questID
			end
			line.LFGButton:Hide()
			line.LFGButton:Show()
		else
			line.LFGButton:Hide()
		end

		
		line.rewardLink = nil
		line.data = data.info
		line.faction.f.tooltip = nil
		line.faction.f.reputationList = nil
		line.isInvasionPoint = nil
		line.timeleft.f._t = nil
		
		line.isLeveling = true
		line.isTreasure = nil
		
		line:Show()
	
		taskIconIndex = taskIconIndex + 1
	end

	WorldQuestList.currentResult = result

	WorldQuestList:SetWidth(WorldQuestList_Width)

	WorldQuestList:SetHeight(max(16*(taskIconIndex-1)+WorldQuestList.SCROLL_FIX_BOTTOM+WorldQuestList.SCROLL_FIX_TOP,1))
	WorldQuestList.C:SetHeight(max(16*(taskIconIndex-1),1))
	
	local lowestLine = #WorldQuestList.Cheader.lines
	for i=1,#WorldQuestList.Cheader.lines do
		local bottomPos = WorldQuestList.Cheader.lines[i]:GetBottom() or 0
		if bottomPos and bottomPos < 40 then
			lowestLine = i - 1
			break
		end
	end
	
	if VWQL.MaxLinesShow then
		lowestLine = min(VWQL.MaxLinesShow,lowestLine)
	end
	
	if lowestLine >= taskIconIndex then
		WorldQuestList.Cheader:SetVerticalScroll(0)
	else
		WorldQuestList:SetHeight((lowestLine+1)*16)
		WorldQuestList.Cheader:SetVerticalScroll( max(min(WorldQuestList.C:GetHeight() - WorldQuestList.Cheader:GetHeight(),WorldQuestList.Cheader:GetVerticalScroll()),0) )
	end
	UpdateScrollButtonsState()
	C_Timer.After(0,UpdateScrollButtonsState)
	
	WorldQuestList.header:Update(true)
	WorldQuestList.footer:Update(true)
	ViewAllButton:Hide()
	
	for i = taskIconIndex, NUM_WORLDMAP_TASK_POIS do
		WorldQuestList.l[i]:Hide()
	end
	
	if taskIconIndex == 1 then
		WorldQuestList.b:SetAlpha(0)
		WorldQuestList.backdrop:Hide()
	else
		WorldQuestList.b:SetAlpha(WorldQuestList.b.A or 1)
		WorldQuestList.backdrop:Show()
	end
	
	WorldQuestList.oppositeContinentButton:Update()
	WorldQuestList.modeSwitcherCheck:Update(WorldQuestList.TreasureData[currMapID])
	
	HookWQbuttons()
	
	if VWQL.Anchor == 2 then	--Inside
		UpdateScale()
	end
end


local function WorldQuestList_Treasure_Update()	
	local currMapID = GetCurrentMapAreaID()
	
	local result = {}
	
	local treasureData = WorldQuestList.TreasureData[currMapID]
	if treasureData then
		for i=1,#treasureData do
			local rewardText, rewardColor, rewardLink
		
			local x,y,name,tType,reward,note,questID,specialFunc = 
				treasureData[i][1],treasureData[i][2],treasureData[i][3],treasureData[i][4],treasureData[i][5],treasureData[i][6],treasureData[i][7],treasureData[i][8]
			
			if (not questID or not IsQuestFlaggedCompleted(questID)) and (not specialFunc or specialFunc()) then
			
				if reward then
					local name,link,quality,itemLevel,_,_,_,_,_,icon = GetItemInfo(reward)
					if name then
						rewardText = "|T"..icon..":0|t "..name
					end
					
					rewardLink = link
		
					if quality and quality >= LE.LE_ITEM_QUALITY_COMMON and LE.BAG_ITEM_QUALITY_COLORS[quality] then
						rewardColor = LE.BAG_ITEM_QUALITY_COLORS[quality]
						
						if quality == 1 then
							rewardColor = nil
						end							
					elseif quality and quality == 0 then
						rewardColor = LE.BAG_ITEM_QUALITY_COLORS[1]
					end
				end
			
				tinsert(result,{
					uid = i,
					questID = questID or -100000-i,
					name = name,
					info = {
						x = x,
						y = y,
						mapID = currMapID,
						questId = -i,
					},
					reward = rewardText,
					rewardColor = rewardColor,
					rewardID = rewardLink,
					note = note,
					isElite = tType == 2,
					isTreasure = tType == 3,
					rarity = 1,
				})
			end
		end		
	end
	
	if not WQL_AreaPOIDataProviderMixin.isAdded then
		WorldMapFrame:AddDataProvider(WQL_AreaPOIDataProviderMixin)
		
		WQL_AreaPOIDataProviderMixin:RefreshAllData()
	end
	if WQ_provider then
		WorldQuestList.IconsGeneralLastMap = nil
		WQ_provider:GetMap():TriggerEvent("WorldQuestsUpdate", WQ_provider:GetMap():GetNumActivePinsByTemplate(WQ_provider:GetPinTemplate()))
		--WQ_provider:RemoveAllData()
	end
			
	local numTaskPOIs = #result
	
	if ( NUM_WORLDMAP_TASK_POIS < numTaskPOIs ) then
		for i=NUM_WORLDMAP_TASK_POIS+1, numTaskPOIs do
			WorldQuestList_CreateLine(i)
		end
		NUM_WORLDMAP_TASK_POIS = numTaskPOIs
	end
	
	local taskIconIndex = 1
		
	for i=1,#result do
		local data = result[i]
		local line = WorldQuestList.l[taskIconIndex]
		
		line.name:SetText(data.name)
		line.name:SetTextColor(1,1,1)
		
		line.nameicon:SetTexture("")
		line.nameicon:SetWidth(1)
		line.secondicon:SetTexture("")
		line.secondicon:SetWidth(1)		
		
		line.reward:SetText(data.reward or "")
		if data.rewardColor then
			line.reward:SetTextColor(data.rewardColor.r, data.rewardColor.g, data.rewardColor.b)
		else
			line.reward:SetTextColor(1,1,1)
		end
		if data.rewardID then
			line.reward.ID = data.rewardID
			line.isRewardLink = true
			line.rewardLink = data.rewardID
		else
			line.reward.ID = nil
			line.isRewardLink = nil
			line.rewardLink = nil
		end
		line.reward.IDs = nil
		
		local questNameWidth = WorldQuestList.NAME_WIDTH
		if data.isElite then
			line.nameicon:SetAtlas("nameplates-icon-elite-silver")
			line.nameicon:SetWidth(16)
			questNameWidth = questNameWidth - 15
		end
		
		if data.isTreasure then
			line.nameicon:SetAtlas("VignetteLoot")
			line.nameicon:SetWidth(16)
			questNameWidth = questNameWidth - 15
		end

		line.name:SetWidth(questNameWidth)
		
		line.faction:SetText(data.note or "")
		line.faction:SetTextColor(1,1,1)
		
		line.zone:SetText("")
		line.timeleft:SetText("")
		
		if data.questID < 0 then
			line.timeleft:SetText("no tracking")
		end

		line.zone:Hide()
		line.zone.f:Hide()
		
		line.questID = data.questID
		line.numObjectives = 0
		
		line.nqhl:Hide()
		
		line.LFGButton:Hide()
		
		line.rewardLink = nil
		line.data = data.info
		line.faction.f.tooltip = nil
		line.faction.f.reputationList = nil
		line.isInvasionPoint = nil
		line.timeleft.f._t = nil
		
		line.isLeveling = true
		line.isTreasure = true
		
		line:Show()
	
		taskIconIndex = taskIconIndex + 1
	end

	WorldQuestList.currentResult = result

	WorldQuestList:SetWidth(WorldQuestList_Width)

	WorldQuestList:SetHeight(max(16*(taskIconIndex-1)+WorldQuestList.SCROLL_FIX_BOTTOM+WorldQuestList.SCROLL_FIX_TOP,1))
	WorldQuestList.C:SetHeight(max(16*(taskIconIndex-1),1))
	
	local lowestLine = #WorldQuestList.Cheader.lines
	for i=1,#WorldQuestList.Cheader.lines do
		local bottomPos = WorldQuestList.Cheader.lines[i]:GetBottom() or 0
		if bottomPos and bottomPos < 40 then
			lowestLine = i - 1
			break
		end
	end
	
	if VWQL.MaxLinesShow then
		lowestLine = min(VWQL.MaxLinesShow,lowestLine)
	end
	
	if lowestLine >= taskIconIndex then
		WorldQuestList.Cheader:SetVerticalScroll(0)
	else
		WorldQuestList:SetHeight((lowestLine+1)*16)
		WorldQuestList.Cheader:SetVerticalScroll( max(min(WorldQuestList.C:GetHeight() - WorldQuestList.Cheader:GetHeight(),WorldQuestList.Cheader:GetVerticalScroll()),0) )
	end
	UpdateScrollButtonsState()
	C_Timer.After(0,UpdateScrollButtonsState)
	
	WorldQuestList.header:Update(true)
	WorldQuestList.footer:Update(true)
	ViewAllButton:Hide()
	
	for i = taskIconIndex, NUM_WORLDMAP_TASK_POIS do
		WorldQuestList.l[i]:Hide()
	end
	
	if taskIconIndex == 1 then
		WorldQuestList.b:SetAlpha(0)
		WorldQuestList.backdrop:Hide()
	else
		WorldQuestList.b:SetAlpha(WorldQuestList.b.A or 1)
		WorldQuestList.backdrop:Show()
	end
	
	WorldQuestList.oppositeContinentButton:Update()
	WorldQuestList.modeSwitcherCheck:Update(WorldQuestList.TreasureData[currMapID])
	
	HookWQbuttons()
	
	if VWQL.Anchor == 2 then	--Inside
		UpdateScale()
	end
end


do
	local lastCheck = 0
	local azeriteItemLocation
	function WorldQuestList:FormatAzeriteNumber(azerite,ignorePercentForm)
		if (VWQL.AzeriteFormat == 10 or VWQL.AzeriteFormat == 20) and not ignorePercentForm then
			local currTime = GetTime()
			if currTime - lastCheck > 5 then
				azeriteItemLocation = C_AzeriteItem.FindActiveAzeriteItem()
				lastCheck = currTime
			end
			
			if azeriteItemLocation then		
				local xp, totalLevelXP = C_AzeriteItem.GetAzeriteItemXPInfo(azeriteItemLocation)
				--local currentLevel = C_AzeriteItem.GetPowerLevel(azeriteItemLocation)
				--local xpToNextLevel = totalLevelXP - xp
				
				if totalLevelXP and totalLevelXP ~= 0 then
					if VWQL.AzeriteFormat == 20 then
						return format("%d (%.1f%%)", azerite,azerite / totalLevelXP * 100)
					else
						return format("%.1f%%", azerite / totalLevelXP * 100)
					end
				end
			end
			
			return WorldQuestList:FormatAzeriteNumber(azerite,true)
		else
			return tostring(azerite)
		end
	end
end

function WorldQuestList:FormatTime(timeLeftMinutes)
	if not timeLeftMinutes then
		return ""
	end
	local color
	local timeString
	if ( timeLeftMinutes <= WORLD_QUESTS_TIME_CRITICAL_MINUTES ) then
		color = "|cffff3333"
		timeString = SecondsToTime(timeLeftMinutes * 60)
	else
		if timeLeftMinutes <= 30 then
			color = "|cffff3333"
		elseif timeLeftMinutes <= 180 then
			color = "|cffffff00"
		end
	
		if timeLeftMinutes >= 14400 then	--A lot, 10+ days
			timeString = format("%dd",floor(timeLeftMinutes / 1440))
		elseif timeLeftMinutes >= 1440 then
			timeString = format("%d.%02d:%02d",floor(timeLeftMinutes / 1440),floor(timeLeftMinutes / 60) % 24, timeLeftMinutes % 60)
		else
			timeString = (timeLeftMinutes >= 60 and (floor(timeLeftMinutes / 60) % 24) or "0")..":"..format("%02d",timeLeftMinutes % 60)
		end
	end
	return (color or "")..(timeString or "")
end

function WorldQuestList:CalculateSqDistanceTo(x2, y2)
	local mapPos = C_Map.GetPlayerMapPosition(GetCurrentMapAreaID(), "player")
	if mapPos and x2 then
	        local x,y = mapPos:GetXY()
	        if x and y then
			local dX = (x - x2)
			local dY = (y - y2)
			return dX * dX + dY * dY
		end
	end
	return math.huge
end

function WorldQuestList:GetRadiantWQPosition(info,result)
	local count,self_pos = 0
	for i=1,#result do
		if result[i].info and result[i].info.x == info.x and result[i].info.y == info.y and result[i].info.questId then
			count = count + 1
		end
		if info == result[i].info then
			self_pos = count
		end
	end
	if count <= 1 or not self_pos then
		return info
	end
	local newInfo = {}
	for q,w in pairs(info) do newInfo[q]=w end
	local radius = 0.05 + count * 0.003
	newInfo.x = newInfo.x + radius * math.cos(math.pi * 2 / count * (self_pos - 1) - math.pi / 2) / 1.5
	newInfo.y = newInfo.y + radius * math.sin(math.pi * 2 / count * (self_pos - 1) - math.pi / 2)
	return newInfo
end

local TableQuestsViewed = {}
local TableQuestsViewed_Time = {}

local WANTED_TEXT,DANGER_TEXT,DANGER_TEXT_2,DANGER_TEXT_3

function WorldQuestList:ForceModeCheck()
	local level = UnitLevel'player' 
	local xp = UnitXP'player'

	if level < 110 then
		VWQL[charKey].RegularQuestMode = true
	elseif level == 110 and xp <= 150000 then
		VWQL[charKey].RegularQuestMode = nil
	elseif level == 110 and xp > 150000 then
		VWQL[charKey].RegularQuestMode = true
	elseif level < 120 then
		VWQL[charKey].RegularQuestMode = true
	else
		VWQL[charKey].RegularQuestMode = nil
	end
	VWQL[charKey].TreasureMode = nil
	
	WorldQuestList.modeSwitcherCheck:AutoSetValue()
end

WorldQuestList.ColorYellow = {r=1,g=1,b=.6}
WorldQuestList.ColorBlueLight = {r=.5,g=.65,b=1}

local WAR_MODE_BONUS = 1.1

local BOUNTY_QUEST_TO_FACTION = {
	[50562] = 2164,
	[50604] = 2163,
	[50606] = 2157,
	[50602] = 2156,
	[50598] = 2103,
	[50603] = 2158,
	[50605] = 2159,
	[50599] = 2160,
	[50601] = 2162,
	[50600] = 2161,
	
	[42422] = 1894,
	[42234] = 1948,
	[42421] = 1859,
	[43179] = 1090,
	[42170] = 1883,
	[46777] = 2045,
	[42233] = 1828,
	[42420] = 1900,
	[48639] = 2165,
	[48641] = 2045,
	[48642] = 2170,
}

local GENERAL_MAPS = {	--1: continent A, 2: azeroth, 3: argus, 4: continent B
	[947] = 2,
	[875] = 1,
	[876] = 1,
	[619] = 4,
	[905] = 3,
	[994] = 3,
	[572] = 4,
	[113] = 4,
	[424] = 4,
	[12] = 4,
	[13] = 4,
	[101] = 4,
}
WorldQuestList.GeneralMaps = GENERAL_MAPS

local ArgusZonesList = {830,885,882}

function WorldQuestList_Update(preMapID,forceUpdate)
	if not WorldQuestList:IsVisible() and not VWQL[charKey].HideMap and not forceUpdate then
	--if not WorldQuestList:IsVisible() then
		return
	end

	local mapAreaID = GetCurrentMapAreaID()
	if type(preMapID)=='number' then
		mapAreaID = preMapID
	end
	if WorldQuestList.IsSoloRun then
		mapAreaID = WorldQuestList.SoloMapID or mapAreaID
	end

	if VWQL[charKey].TreasureMode and WorldQuestList.TreasureData[mapAreaID] then
		WorldQuestList.sortDropDown:Hide()
		WorldQuestList.filterDropDown:Hide()
		WorldQuestList.optionsDropDown:Hide()
		WorldQuestList_Treasure_Update()
		return
	elseif VWQL[charKey].RegularQuestMode then
		WorldQuestList.IconsGeneralLastMap = -1
		WorldQuestList.sortDropDown:Hide()
		WorldQuestList.filterDropDown:Hide()
		WorldQuestList.optionsDropDown:Hide()
		WorldQuestList_Leveling_Update()
		return
	else
		WorldQuestList.sortDropDown:Show()
		WorldQuestList.filterDropDown:Show()
		WorldQuestList.optionsDropDown:Show()	
	end

	local currTime = GetTime()
	
	local O = {
		isGeneralMap = false,
		isGearLessRelevant = false,
		nextResearch = nil,
	}

	local taskInfo = C_TaskQuest.GetQuestsForPlayerByMapID(mapAreaID)
		
	if GENERAL_MAPS[mapAreaID] then
		O.isGeneralMap = true
		O.generalMapType = GENERAL_MAPS[mapAreaID]
		
		if VWQL.OppositeContinent and (mapAreaID == 875 or mapAreaID == 876) then
			local oppositeMapQuests = C_TaskQuest.GetQuestsForPlayerByMapID(mapAreaID == 875 and 876 or 875)
			for _,info in pairs(oppositeMapQuests) do
				taskInfo[#taskInfo+1] = info
				info.dX,info.dY,info.dMap = info.x,info.y,mapAreaID == 875 and 876 or 875
				info.x,info.y = nil
			end
		elseif not VWQL.OppositeContinentArgus and (mapAreaID == 619 or mapAreaID == 947) then
			for _,mapID in pairs(ArgusZonesList) do
				local oppositeMapQuests = C_TaskQuest.GetQuestsForPlayerByMapID(mapID)
				for _,info in pairs(oppositeMapQuests) do
					taskInfo[#taskInfo+1] = info
					info.dX,info.dY,info.dMap = info.x,info.y,mapID
					info.x,info.y = mapAreaID == 619 and 0.87,mapAreaID == 619 and 0.165
				end
			end
		end
	end

	if mapAreaID == 905 then	--Argus
		WorldQuestList:RegisterArgusMap()
	
		local moddedMap
		if not VWQL.ArgusMap then
			moddedMap = C_TaskQuest.GetQuestsForPlayerByMapID(994)
		end		
		for _,mapID in pairs(ArgusZonesList) do
			local mapQuests = C_TaskQuest.GetQuestsForPlayerByMapID(mapID)
			for _,info in pairs(mapQuests) do
				taskInfo[#taskInfo+1] = info
				info.dX,info.dY,info.dMap = info.x,info.y,mapID
				if moddedMap then
					info.x,info.y = nil
					for i=1,#moddedMap do
						if info.questId == moddedMap[i].questId then
							info.x,info.y = moddedMap[i].x,moddedMap[i].y
							break
						end
					end
				elseif mapID == 830 then
					info.x,info.y = 0.60,0.65
				elseif mapID == 885 then
					info.x,info.y = 0.30,0.48
				elseif mapID == 882 then
					info.x,info.y = 0.63,0.28
				end
			end
		end
	end
	
	if mapAreaID == 1163 then
		--[[
		taskInfo = C_TaskQuest.GetQuestsForPlayerByMapID(875)
		for _,info in pairs(taskInfo) do
			info.dX,info.dY,info.dMap = info.x,info.y,875
			info.x,info.y = nil
		end
		]]
		WorldMapFrame:SetMapID(875)
		return
	end

	if mapAreaID == 905 or mapAreaID == 830 or mapAreaID == 885 or mapAreaID == 882 or (not VWQL.OppositeContinentArgus and (mapAreaID == 619 or (mapAreaID == 947 and not VWQL.HideLegion))) then
		for _,mapID in pairs((mapAreaID == 905 or mapAreaID == 619 or mapAreaID == 947) and ArgusZonesList or {mapAreaID}) do
			local pois = C_AreaPoiInfo.GetAreaPOIForMap(mapID)
			for i=1,#pois do
				local poiData = C_AreaPoiInfo.GetAreaPOIInfo(mapID,pois[i])
				if poiData and type(poiData.atlasName) == 'string' and poiData.atlasName:find("^poi%-rift%d+$") then
					taskInfo.poi = taskInfo.poi or {}
					if mapAreaID == 905 and VWQL.ArgusMap then
						poiData.position.dX, poiData.position.dY, poiData.position.dMap = poiData.position.x,poiData.position.y,mapID
						if mapID == 830 then
							poiData.position.x,poiData.position.y = 0.60,0.65
						elseif mapID == 885 then
							poiData.position.x,poiData.position.y = 0.30,0.48
						elseif mapID == 882 then
							poiData.position.x,poiData.position.y = 0.63,0.28
						end
					elseif mapAreaID == 905 and not VWQL.ArgusMap then
						poiData.position.dX, poiData.position.dY, poiData.position.dMap = poiData.position.x,poiData.position.y,mapID
						local poiModdedData = C_AreaPoiInfo.GetAreaPOIInfo(994,pois[i])
						if poiModdedData then
							poiData.position.x,poiData.position.y = poiModdedData.position.x,poiModdedData.position.y
						else
							poiData.position.x,poiData.position.y = nil
						end
					elseif mapAreaID == 619 or mapAreaID == 947 then
						poiData.position.dX, poiData.position.dY = poiData.position.x,poiData.position.y
						poiData.position.x,poiData.position.y = mapAreaID == 619 and 0.87,mapAreaID == 619 and 0.165
					end
					tinsert(taskInfo.poi, {poiData.name, poiData.description, poiData.position.x, poiData.position.y, pois[i], poiData.atlasName, 1, mapID, poiData.position.dX, poiData.position.dY})
				end
			end
		end	
	end
	
	if WorldQuestList:FilterCurrentZone(mapAreaID) then
		for i=#taskInfo,1,-1 do
			--if taskInfo[i].mapID ~= mapAreaID and not WorldQuestList:IsMapParent(taskInfo[i].mapID,mapAreaID) then
			if taskInfo[i].mapID ~= mapAreaID and not (mapAreaID == 862 and taskInfo[i].mapID == 1165) then
				tremove(taskInfo,i)
			end
		end
	end
	
	if mapAreaID == 947 and VWQL.HideLegion then
		for i=#taskInfo,1,-1 do
			if taskInfo[i].mapID and (WorldQuestList:IsLegionZone(taskInfo[i].mapID) or taskInfo[i].mapID == 62) then
				tremove(taskInfo,i)
			end
		end	
	end
		
	WorldQuestList.currentMapID = mapAreaID
	
	if time() > 1534550400 and time() < 1543622400 then	--beetween 18.08.18 (second week, same AK as first) and 01.12.18 (AK level 17, max for now,30.07.2018)
		O.nextResearch = WorldQuestList:GetNextResetTime(WorldQuestList:GetCurrentRegion())
	end
	
	O.isGearLessRelevant = (select(2,GetAverageItemLevel()) or 0) >= 345
		
	local bounties = GetQuestBountyInfoForMapID(WorldQuestList:IsLegionZone(mapAreaID) and 619 or 875)
	local bountiesInProgress = {}
	for _,bountyData in pairs(bounties or {}) do
		local questID = bountyData.questID
		if questID and not IsQuestComplete(questID) then
			bountiesInProgress[ questID ] = bountyData.icon or 0
		end
	end
	
	local numTaskPOIs = 0
	if(taskInfo ~= nil) then
		numTaskPOIs = #taskInfo
	end
	
	local result = {}
	local totalAP,totalOR,totalG,totalAzerite,totalORbfa,totalWE = 0,0,0,0,0,0
	
	if not WANTED_TEXT then
		local qName = C_TaskQuest.GetQuestInfoByQuestID(43612)
		if qName and qName:find(":") then
			WANTED_TEXT = qName:match("^([^:]+):")
			if WANTED_TEXT then
				WANTED_TEXT = WANTED_TEXT:lower()
			end
		end
	end
	if not DANGER_TEXT then
		local qName = C_TaskQuest.GetQuestInfoByQuestID(43798)
		if qName and qName:find(":") then
			DANGER_TEXT = qName:match("^([^:]+):")
			if DANGER_TEXT then
				DANGER_TEXT = DANGER_TEXT:lower()
			end
		end
	end
	if not DANGER_TEXT_2 then
		local qName = C_TaskQuest.GetQuestInfoByQuestID(41697)
		if qName and qName:find(":") then
			DANGER_TEXT_2 = qName:match("^([^:]+):")
			if DANGER_TEXT_2 then
				DANGER_TEXT_2 = DANGER_TEXT_2:lower()
			end
		end
	end
	if not DANGER_TEXT_3 then
		local qName = C_TaskQuest.GetQuestInfoByQuestID(44114)
		if qName and qName:find(":") then
			DANGER_TEXT_3 = qName:match("^([^:]+):")
			if DANGER_TEXT_3 then
				DANGER_TEXT_3 = DANGER_TEXT_3:lower()
			end
		end
	end
	
	local isWarModeOn = C_PvP.IsWarModeDesired()
	
	local taskIconIndex = 1
	local totalQuestsNumber = 0
	if ( numTaskPOIs > 0 ) then
		for i, info  in pairs(taskInfo) do if type(i)=='number' then
			local questID = info.questId
			if HaveQuestData(questID) and QuestUtils_IsQuestWorldQuest(questID) and (VWQL[charKey].ignoreIgnore or not VWQL.Ignore[questID]) then
				local isNewQuest = not VWQL[charKey].Quests[ questID ] or (TableQuestsViewed_Time[ questID ] and TableQuestsViewed_Time[ questID ] > currTime)
				
				local reward = ""
				local rewardItem
				local rewardColor
				local faction = ""
				local factionInProgress
				local timeleft = ""
				local name = ""
				local rewardType = 0
				local rewardSort = 0
				local rewardItemLink
				local nameicon = nil
				local artifactKnowlege
				local isEliteQuest
				local timeToComplete
				local isInvasion
				local WarSupplies
				local ShardsNothing
				local bountyTooltip
				local isUnlimited
				local questColor	--nil - white, 1 - blue, 2 - epic, 3 - invasion
				local reputationList
				local highlightFaction
				
				local professionFix
				local IsPvPQuest
				local IsWantedQuest
				
				local isValidLine = 1
				
				local title, factionID = C_TaskQuest.GetQuestInfoByQuestID(questID)
				name = title
				
				local _,_,worldQuestType,rarity, isElite, tradeskillLineIndex, allowDisplayPastCritical = GetQuestTagInfo(questID)
				
				local tradeskillLineID = nil
				if tradeskillLineIndex then
					tradeskillLineID = select(7, GetProfessionInfo(tradeskillLineIndex))
				else
					tradeskillLineID = 0
				end
				
				if isElite then
					isEliteQuest = true
					nameicon = -1
				end

				if worldQuestType == LE.LE_QUEST_TAG_TYPE_INVASION then
					isInvasion = true
					questColor = 3
				end
				
				if worldQuestType == LE.LE_QUEST_TAG_TYPE_DUNGEON then
					questColor = 1
					nameicon = -6
					if ActiveFilterType.dung then 
						isValidLine = 0 
					end
				elseif worldQuestType == LE.LE_QUEST_TAG_TYPE_RAID then
					nameicon = -7
					if ActiveFilterType.dung then 
						isValidLine = 0 
					end
					questColor = 2				
				elseif rarity == LE.LE_WORLD_QUEST_QUALITY_RARE then
					questColor = 1
				elseif rarity == LE.LE_WORLD_QUEST_QUALITY_EPIC then
					nameicon = -2
					questColor = 2
				elseif worldQuestType == LE.LE_QUEST_TAG_TYPE_PVP then
					nameicon = -3
					if ActiveFilterType.pvp then 
						isValidLine = 0 
					end
				elseif worldQuestType == LE.LE_QUEST_TAG_TYPE_PET_BATTLE then
					nameicon = -4
					if ActiveFilterType.pet then 
						isValidLine = 0 
					end
				elseif worldQuestType == LE.LE_QUEST_TAG_TYPE_PROFESSION then
					nameicon = -5
					if ActiveFilterType.prof or not tradeskillLineID then 
						isValidLine = 0 
						if not tradeskillLineID then
							professionFix = true
						end
					end
				end
				
				if (WANTED_TEXT and name:lower():find("^"..WANTED_TEXT)) or (DANGER_TEXT and name:lower():find("^"..DANGER_TEXT)) or (DANGER_TEXT_2 and name:lower():find("^"..DANGER_TEXT_2)) or (DANGER_TEXT_3 and name:lower():find("^"..DANGER_TEXT_3)) then
					IsWantedQuest = true
				end
				
				if ( factionID ) then
					local factionName = GetFactionInfoByID(factionID)
					if ( factionName ) then
						faction = factionName
					end
					
					if VWQL[charKey]["faction"..factionID.."Highlight"] then
						highlightFaction = true
					end
				end
				
				for bountyQuestID,bountyIcon in pairs(bountiesInProgress) do
					if IsQuestCriteriaForBounty(questID, bountyQuestID) then
						faction = "|T" .. bountyIcon .. ":0|t " .. (faction or "")
						
						factionInProgress = true
						
						if bountyIcon and bountyIcon ~= 0 then
							bountyTooltip = bountyTooltip or ""
							bountyTooltip = bountyTooltip .. (bountyTooltip ~= "" and " " or "") .. "|T" .. bountyIcon .. ":32|t"
						end
					end
				end
				
				for bountyQuestID,bountyFactionID in pairs(BOUNTY_QUEST_TO_FACTION) do
					if IsQuestCriteriaForBounty(questID, bountyQuestID) then
						reputationList = reputationList and (reputationList..","..bountyFactionID) or bountyFactionID
						
						if VWQL[charKey]["faction"..bountyFactionID.."Highlight"] then
							highlightFaction = true
						end
					end
				end
				
				
				if GetQuestLogRewardXP(questID) > 0 or GetNumQuestLogRewardCurrencies(questID) > 0 or GetNumQuestLogRewards(questID) > 0 or GetQuestLogRewardMoney(questID) > 0 or GetQuestLogRewardArtifactXP(questID) > 0 or GetQuestLogRewardHonor(questID) > 0 then
					local hasRewardFiltered = false
					-- xp
					local xp = GetQuestLogRewardXP(questID)
					if ( xp > 0 ) then
						reward = BONUS_OBJECTIVE_EXPERIENCE_FORMAT:format(xp)
						rewardSort = xp
						rewardType = 50
					end
					-- money
					local money = GetQuestLogRewardMoney(questID)
					if ( money > 0 ) then
						if isWarModeOn and C_QuestLog.QuestHasWarModeBonus(questID) then
							money = money * WAR_MODE_BONUS
							money = money - money % 100
						end
						reward = GetCoinTextureString(money):gsub("(UI%-GoldIcon:14:14:2:0|t) .+", "%1") --163ui
						rewardType = 40
						if money > 300000 then
							hasRewardFiltered = true
							rewardSort = money
							
							if bit.band(filters[5][2],ActiveFilter) == 0 then 
								isValidLine = 0 
							end
							if isValidLine ~= 0 then
								totalG = totalG + money
							end
						end
					end					
					
					-- currency		
					local numQuestCurrencies = GetNumQuestLogRewardCurrencies(questID)
					for i = 1, numQuestCurrencies do
						local name, texture, numItems, currencyID = GetQuestLogRewardCurrencyInfo(i, questID)
						if isWarModeOn and (currencyID == 1553 or currencyID == 1560 or currencyID == 1220 or currencyID == 1342 or currencyID == 1226 or currencyID == 1533) and C_QuestLog.QuestHasWarModeBonus(questID) then
							numItems = floor(numItems * WAR_MODE_BONUS + .5)
						end
						local text = BONUS_OBJECTIVE_REWARD_WITH_COUNT_FORMAT:format(texture, numItems, name)
						if not WorldQuestList:IsFactionCurrency(currencyID) or WorldQuestList:IsFactionAvailable(WorldQuestList:FactionCurrencyToID(currencyID)) then
							if i == 1 or not hasRewardFiltered then
								if currencyID == 1342 then	--War Supplies
									WarSupplies = numItems
								elseif currencyID == 1226 and isInvasion then	--Shard of nothing
									ShardsNothing = numItems
								else
									if i > 1 and reward ~= "" then
										reward = reward .. ", " .. text:gsub("(|cffffffff[0-9]+|r) .*$", "%1") --163ui
									else
										reward = text:gsub("(|cffffffff[0-9]+|r) .*$", "%1") --163ui
									end
									rewardType = 30
								end
								
								if currencyID == 1508 then	--Veiled Argunite
									hasRewardFiltered = true
									rewardType = 30.1508
									rewardSort = numItems or 0
									if VWQL[charKey].arguniteFilter then
										isValidLine = 0 
									end
								elseif currencyID == 1506 then	
									hasRewardFiltered = true
									rewardType = 30.15085
									rewardSort = numItems or 0
								elseif currencyID == 1553 then	-- azerite
									hasRewardFiltered = true
									rewardType = 21
									if ActiveFilterType.azerite then 
										isValidLine = 0  
									end
									if LE.BAG_ITEM_QUALITY_COLORS[6] then
										rewardColor = LE.BAG_ITEM_QUALITY_COLORS[6]
									end
									rewardSort = numItems or 0
									if isValidLine ~= 0 then
										totalAzerite = totalAzerite + (numItems or 0)
									end
															
									local entry = C_CurrencyInfo.GetCurrencyContainerInfo(currencyID, numItems)
									if entry then 
										texture = entry.icon
									end
									
									reward = BONUS_OBJECTIVE_REWARD_WITH_COUNT_FORMAT:format(texture, WorldQuestList:FormatAzeriteNumber(numItems), name)
								elseif currencyID == 1533 then	--Wakening Essence
									hasRewardFiltered = true
									rewardType = 30.1533
									rewardSort = numItems or 0
									if VWQL[charKey].wakeningessenceFilter then
										isValidLine = 0 
									end
									if isValidLine ~= 0 then
										totalWE = totalWE + (numItems or 0)
									end
								end
								
								if currencyID == 1220 then
									hasRewardFiltered = true
									rewardSort = numItems or 0
									if bit.band(filters[3][2],ActiveFilter) == 0 then 
										isValidLine = 0 
									end
									if isValidLine ~= 0 then
										totalOR = totalOR + (numItems or 0)
									end
								elseif currencyID == 1560 then
									hasRewardFiltered = true
									rewardSort = numItems or 0
									if ActiveFilterType.bfa_orderres then 
										isValidLine = 0 
									end
									if isValidLine ~= 0 then
										totalORbfa = totalORbfa + (numItems or 0)
									end							
								end
								
								if WorldQuestList:IsFactionCurrency(currencyID) then
									hasRewardFiltered = true
									rewardSort = numItems or 0
									if ActiveFilterType.rep then 
										isValidLine = 0 
									end
									rewardType = 33	+ currencyID / 10000
									rewardColor = WorldQuestList.ColorYellow	
									
									if VWQL[charKey]["faction"..WorldQuestList:FactionCurrencyToID(currencyID).."Highlight"] then
										highlightFaction = true
									end
								end
							elseif i > 1 and reward ~= "" then
								if currencyID == 1342 then	--War Supplies
									WarSupplies = numItems
								else
									reward = reward .. ", " .. text
								end
							end
						end
					end
					
					local artifactXP = GetQuestLogRewardArtifactXP(questID)
					local totalAPadded = 0
					if ( artifactXP > 0 ) then
						hasRewardFiltered = true
						rewardType = 20
						if bit.band(filters[2][2],ActiveFilter) == 0 then 
							isValidLine = 0  
						end
						if LE.BAG_ITEM_QUALITY_COLORS[6] then
							rewardColor = LE.BAG_ITEM_QUALITY_COLORS[6]
						end
					
						reward = "["..artifactXP.."] "..BONUS_OBJECTIVE_ARTIFACT_XP_FORMAT:gsub("^%%s ","")
						rewardSort = artifactXP
						if isValidLine ~= 0 then
							totalAP = totalAP + artifactXP
							totalAPadded = totalAPadded + artifactXP
						end
					end
			
					-- items
					local numQuestRewards = GetNumQuestLogRewards(questID)
					if numQuestRewards > 0 then
						local name,icon,numItems,quality,_,itemID = GetQuestLogRewardInfo(1,questID)
						if name then
							rewardType = 50
							rewardItem = true
							reward = "|T"..icon..":0|t "..(numItems and numItems > 1 and numItems.."x " or "")..name
						end
						

						if quality and quality >= LE.LE_ITEM_QUALITY_COMMON and LE.BAG_ITEM_QUALITY_COLORS[quality] then
							rewardColor = LE.BAG_ITEM_QUALITY_COLORS[quality]
							
							if quality == 1 or nameicon == -4 then
								rewardColor = nil
								
								if bit.band(filters[6][2],ActiveFilter) == 0 then 
									isValidLine = 0 
								end
							end							
							hasRewardFiltered = true
						elseif quality and quality == 0 then
							rewardColor = LE.BAG_ITEM_QUALITY_COLORS[1]
							rewardType = 61
							hasRewardFiltered = true
							if bit.band(filters[6][2],ActiveFilter) == 0 then 
								isValidLine = 0 
							end
						end
						
						if icon == 1387622 then		--Rank 3 recipe
							rewardColor = WorldQuestList.ColorBlueLight
						elseif icon == 1387621 then		--Rank 2 recipe
							rewardColor = WorldQuestList.ColorBlueLight
						elseif icon == 1392955 then		--no-rank recipe
							rewardColor = WorldQuestList.ColorBlueLight
						end
						
						local isBoeItem = nil
						
						inspectScantip:SetQuestLogItem("reward", 1, questID)
						rewardItemLink = select(2,inspectScantip:GetItem())
						for j=2, inspectScantip:NumLines() do
							local tooltipLine = _G[GlobalAddonName.."WorldQuestListInspectScanningTooltipTextLeft"..j]
							local text = tooltipLine:GetText()
							if text and text:find(ITEM_LEVEL) then
								local ilvl = text:match(ITEM_LEVEL)
								reward = "|T"..icon..":0|t "..ilvl --163ui .." "..name
								ilvl = tonumber( ilvl:gsub("%+",""),nil )
								if ilvl then
									rewardType = O.isGearLessRelevant and 37 or 0
									rewardSort = ilvl
									hasRewardFiltered = true
								end
							elseif text and text:find(LE.ITEM_BIND_ON_EQUIP) and j<=4 then
								isBoeItem = true
							end 
						end
						inspectScantip:ClearLines()
						
						if itemID == 124124 then
							rewardType = 35
							rewardSort = numItems or 0
							hasRewardFiltered = true
							if bit.band(filters[4][2],ActiveFilter) == 0 then 
								isValidLine = 0 
							end
						elseif itemID == 151568 then
							rewardType = 35.1
							rewardSort = numItems or 0
							hasRewardFiltered = true
							if bit.band(filters[4][2],ActiveFilter) == 0 then 
								isValidLine = 0 
							end
						elseif itemID == 152960 or itemID == 152957 then
							hasRewardFiltered = true
							rewardSort = numItems or 0
							if ActiveFilterType.rep then 
								isValidLine = 0 
							end
							rewardType = 33	+ (itemID == 152960 and 0.2170 or 0.2165)
							rewardColor = WorldQuestList.ColorYellow
						end
						
						if itemID and (rewardType == 0 or rewardType == 37) then
							hasRewardFiltered = true
							if bit.band(filters[1][2],ActiveFilter) == 0 then 
								isValidLine = 0 
							end
						end
						
						if (rewardType == 0 or rewardType == 5 or rewardType == 37) and isBoeItem then
							reward = reward:gsub("(|t %d+) ","%1 BOE ")
						end
						
						if itemID and rewardType == 50 then
							rewardSort = (quality or 1) * 1000000 + itemID + min(numItems,999) / 1000
							
							if bit.band(filters[6][2],ActiveFilter) == 0 then 
								isValidLine = 0 
							end
						end
					end
					
					-- honor
					local honorAmount = GetQuestLogRewardHonor(questID)
					if ( honorAmount and honorAmount > 0 ) then
						if reward ~= "" and rewardType ~= 61 then
							reward = reward .. ", "
						else
							rewardSort = honorAmount
							rewardType = 32
							hasRewardFiltered = true
							if bit.band(filters[6][2],ActiveFilter) == 0 then 
								isValidLine = 0 
							end
						end
						reward = reward .. BONUS_OBJECTIVE_REWARD_WITH_COUNT_FORMAT:format("Interface\\ICONS\\Achievement_LegionPVPTier4", honorAmount, HONOR)
						
						IsPvPQuest = true
					end
					
					if WarSupplies and WarSupplies > 0 then
						local name, amount, texturePath, earnedThisWeek, weeklyMax, totalMax, isDiscovered, quality = GetCurrencyInfo(1342)
						if mapAreaID == 646 and factionID == 2045 then
							local prevFaction
							if faction and faction:find(":0|t") then
								prevFaction = faction:match("^(.-:0|t )[^|]*$")
							end
							faction = (prevFaction or "").."|T" .. (texturePath or "") .. ":0|t " .. WarSupplies .. " " .. name
						else
							if reward ~= "" then
								reward = reward .. ", "
							else
								rewardSort = WarSupplies
								rewardType = 31
							end
							reward = reward .. "|T" .. texturePath .. ":0|t " .. WarSupplies .. " " .. name
						end
					end
					if ShardsNothing and ShardsNothing > 0 then
						local name, amount, texturePath, earnedThisWeek, weeklyMax, totalMax, isDiscovered, quality = GetCurrencyInfo(1226)

						if reward ~= "" then
							reward = reward .. ", "
						else
							rewardSort = ShardsNothing
							rewardType = 31
						end
						reward = reward .. BONUS_OBJECTIVE_REWARD_WITH_COUNT_FORMAT:format(texturePath or "", ShardsNothing, name)

					end
					
					if not hasRewardFiltered then
						rewardType = 60
						if bit.band(filters[6][2],ActiveFilter) == 0 then 
							isValidLine = 0 
						end
					end
				else
					rewardType = 110
					if bit.band(filters[6][2],ActiveFilter) == 0 then 
						isValidLine = 0 
					end				
				end
							
				local timeLeftMinutes = C_TaskQuest.GetQuestTimeLeftMinutes(questID)
				if ( timeLeftMinutes ) then
					timeleft = WorldQuestList:FormatTime(timeLeftMinutes)
					
					if (rewardType == 20 or rewardType == 21) and O.nextResearch and (timeLeftMinutes - 5) > O.nextResearch and reward then
						timeToComplete = timeLeftMinutes - O.nextResearch
						if rewardType == 20 then
							reward = reward:gsub("] ","]** ")
						elseif rewardType == 21 then
							reward = reward:gsub("( [^ ]+)$","**%1")
						end
						artifactKnowlege = true
					end
					
					if timeLeftMinutes == 0 and not C_TaskQuest.IsActive(questID) then
						isValidLine = 0
					end
					if not allowDisplayPastCritical then
						timeLeftMinutes = timeLeftMinutes + 1440 * 15
						isUnlimited = true
					end
				end
				
				if not professionFix then
					if VWQL[charKey].bountyIgnoreFilter and factionInProgress then 
						isValidLine = 1
					end
					if VWQL[charKey].honorIgnoreFilter and IsPvPQuest then
						isValidLine = 1
					end
					if VWQL[charKey].petIgnoreFilter and worldQuestType == LE.LE_QUEST_TAG_TYPE_PET_BATTLE then
						isValidLine = 1
					end
					if VWQL[charKey].apIgnoreFilter and rewardType == 20 then
						isValidLine = 1
					end
					if VWQL[charKey].azeriteIgnoreFilter and rewardType == 21 then
						isValidLine = 1
					end						
					if VWQL[charKey].epicIgnoreFilter and rarity == LE.LE_WORLD_QUEST_QUALITY_EPIC then
						isValidLine = 1
					end	
					if VWQL[charKey].wantedIgnoreFilter and IsWantedQuest then
						isValidLine = 1
					end
					if VWQL[charKey].legionfallIgnoreFilter and factionID == 2045 then
						isValidLine = 1
					elseif VWQL[charKey].aotlIgnoreFilter and factionID == 2165 then
						isValidLine = 1
					elseif VWQL[charKey].argusReachIgnoreFilter and factionID == 2170 then
						isValidLine = 1
					elseif factionID and VWQL[charKey]["faction"..factionID.."IgnoreFilter"] and WorldQuestList:IsFactionAvailable(factionID) then
						isValidLine = 1
					end
				end
									
				
				if isValidLine == 1 then
					TableQuestsViewed[ questID ] = true
					if not VWQL[charKey].Quests[ questID ] then
						TableQuestsViewed_Time[ questID ] = currTime + 180
					end
					tinsert(result,{
						info = info,
						reward = reward,
						rewardItem = rewardItem,
						rewardItemLink = rewardItemLink,
						rewardColor = rewardColor,
						faction = faction,
						factionInProgress = factionInProgress,
						zone = (((VWQL.OppositeContinent and (mapAreaID == 875 or mapAreaID == 876)) or mapAreaID == 947) and WorldQuestList:GetMapIcon(info.mapID) or "")..
							(((mapAreaID == 875 or mapAreaID == 876)) and WorldQuestList:GetMapTextColor(info.mapID) or "")..WorldQuestList:GetMapName(info.mapID),
						zoneID = info.mapID or 0,
						timeleft = timeleft,
						time = timeLeftMinutes or 0,
						numObjectives = info.numObjectives,
						questID = questID,
						isNewQuest = isNewQuest,
						name = name,
						rewardType = rewardType,
						rewardSort = rewardSort,
						nameicon = nameicon,
						artifactKnowlege = artifactKnowlege,
						isEliteQuest = isEliteQuest,
						timeToComplete = timeToComplete,
						isInvasion = isInvasion,
						bountyTooltip = bountyTooltip,
						isUnlimited = isUnlimited,
						distance = C_TaskQuest.GetDistanceSqToQuest(questID) or math.huge,
						questColor = questColor,
						reputationList = reputationList,
						professionIndex = tradeskillLineIndex and tradeskillLineID,
						disableLFG = WorldQuestList:IsQuestDisabledForLFG(questID) or worldQuestType == LE.LE_QUEST_TAG_TYPE_PET_BATTLE,
						highlightFaction = highlightFaction,
					})
				end
				
				totalQuestsNumber = totalQuestsNumber + 1
			end
		end end
	end
	
	if taskInfo.poi then
		for i=1,#taskInfo.poi do
			local name, description, x, y, poiID, atlasIcon, poiWQLType, zoneID, dX, dY = unpack(taskInfo.poi[i])
			if poiWQLType == 1 and not VWQL[charKey].invasionPointsFilter then	--invasion points
				local timeLeftMinutes = C_AreaPoiInfo.GetAreaPOITimeLeft(poiID) or 0
				local isGreat = atlasIcon:match("%d+$") == "2"
				if x == -1 then
					x = nil
					y = nil
				end
				tinsert(result,{
					info = {
						x = x,
						y = y,
						mapID = zoneID,
						name = description,
						dX = dX,
						dY = dY,
						dMap = zoneID,
					},
					reward = description and description:gsub("^.-: ","") or "",
					faction = "",
					zone = (mapAreaID == 947 and WorldQuestList:GetMapIcon(zoneID) or "")..WorldQuestList:GetMapName(zoneID),
					zoneID = zoneID or 0,
					timeleft = WorldQuestList:FormatTime(timeLeftMinutes),
					time = timeLeftMinutes,
					numObjectives = 0,
					name = name,
					rewardType = 70,
					rewardSort = poiID,
					nameicon = isGreat and -9 or -8,
					distance = WorldQuestList:CalculateSqDistanceTo(x, y),
					questColor = 3,
					isInvasionPoint = true,
				})				
				numTaskPOIs = numTaskPOIs + 1
			end
			totalQuestsNumber = totalQuestsNumber + 1
		end
	end

	sort(result,SortFuncs[ActiveSort])
	
	if VWQL.ReverseSort then
		local newResult = {}
		for i=#result,1,-1 do
			newResult[#newResult+1] = result[i]
		end
		result = newResult
	end
	
	if WQ_provider and WorldMapFrame:IsVisible() then
		local pinsToRemove = {}
		for questId in pairs(WorldQuestList.WMF_activePins) do
			pinsToRemove[questId] = true
		end
		local isUpdateReq = nil
	
		if O.isGeneralMap and not VWQL.DisableIconsGeneral and not VWQL["DisableIconsGeneralMap"..mapAreaID] then
			WorldQuestList.IconsGeneralLastMap = mapAreaID
			for i=1,#result do
				local info = result[i].info
				if info and info.questId and info.x then
					if (O.generalMapType == 3 and VWQL.ArgusMap) or (mapAreaID == 619 and info.x == 0.87 and info.y == 0.165) then
						info = WorldQuestList:GetRadiantWQPosition(info,result)
					end
					pinsToRemove[info.questId] = nil
					local pin = WorldQuestList.WMF_activePins[info.questId]
					if pin then
						pin:RefreshVisuals()
						pin:SetPosition(info.x, info.y)
		
						if WQ_provider.pingPin and WQ_provider.pingPin:IsAttachedToQuest(info.questId) then
							WQ_provider.pingPin:SetPosition(info.x, info.y)
						end
					else
						WorldQuestList.WMF_activePins[info.questId] = WQ_provider:AddWorldQuest(info)
					end
				end
			end
			isUpdateReq = true
		end
		
		for questId in pairs(pinsToRemove) do
			if WQ_provider.pingPin and WQ_provider.pingPin:IsAttachedToQuest(questId) then
				WQ_provider.pingPin:Stop()
			end
			local pin = WorldQuestList.WMF_activePins[questId]
	
			WQ_provider:GetMap():RemovePin(pin)
			WorldQuestList.WMF_activePins[questId] = nil
		end
		
		if isUpdateReq then
			WorldMapFrame:TriggerEvent("WorldQuestsUpdate", WorldMapFrame:GetNumActivePinsByTemplate("WorldMap_WorldQuestPinTemplate"))
		end	
	end
	
	if ( NUM_WORLDMAP_TASK_POIS < numTaskPOIs ) then
		for i=NUM_WORLDMAP_TASK_POIS+1, numTaskPOIs do
			WorldQuestList_CreateLine(i)
		end
		NUM_WORLDMAP_TASK_POIS = numTaskPOIs
	end
	
	local lfgEyeStatus = true
	if C_LFGList.GetActiveEntryInfo() or VWQL.DisableLFG or VWQL.LFG_HideEyeInList then
		lfgEyeStatus = false
	end
	
	for i=1,#result do
		local data = result[i]
		local line = WorldQuestList.l[taskIconIndex]
		
		line.name:SetText(data.name)
		if data.questColor == 3 then
			line.name:SetTextColor(0.78, 1, 0)
		elseif data.questColor == 1 then
			line.name:SetTextColor(.2,.5,1)
		elseif data.questColor == 2 then
			line.name:SetTextColor(.63,.2,.9)
		else
			line.name:SetTextColor(1,1,1)
		end
		
		local questNameWidth = WorldQuestList.NAME_WIDTH
		if data.nameicon then
			line.nameicon:SetWidth(16)
			if data.nameicon == -1 then
				line.nameicon:SetAtlas("nameplates-icon-elite-silver")
			elseif data.nameicon == -2 then
				line.nameicon:SetAtlas("nameplates-icon-elite-gold")
			elseif data.nameicon == -3 then
				line.nameicon:SetAtlas("worldquest-icon-pvp-ffa")
			elseif data.nameicon == -4 then
				line.nameicon:SetAtlas("worldquest-icon-petbattle")
			elseif data.nameicon == -5 then
				line.nameicon:SetAtlas("worldquest-icon-engineering")
			elseif data.nameicon == -6 then
				line.nameicon:SetAtlas("Dungeon")
			elseif data.nameicon == -7 then
				line.nameicon:SetAtlas("Raid")
			elseif data.nameicon == -8 then
				line.nameicon:SetAtlas("poi-rift1")
			elseif data.nameicon == -9 then
				line.nameicon:SetAtlas("poi-rift2")
			end
			questNameWidth = questNameWidth - 15
		else
			line.nameicon:SetTexture("")
			line.nameicon:SetWidth(16)
            questNameWidth = questNameWidth - 15
		end
		
		if data.isInvasion then
			line.secondicon:SetAtlas("worldquest-icon-burninglegion")
			line.secondicon:SetWidth(16)
			
			questNameWidth = questNameWidth - 15
		elseif data.professionIndex and WORLD_QUEST_ICONS_BY_PROFESSION[data.professionIndex] and data.nameicon then
			line.secondicon:SetAtlas(WORLD_QUEST_ICONS_BY_PROFESSION[data.professionIndex])
			line.secondicon:SetWidth(16)
			
			questNameWidth = questNameWidth - 15
		else
			line.secondicon:SetTexture("")
			line.secondicon:SetWidth(1)	
		end
		
		if data.isInvasionPoint and (not O.isGeneralMap or not VWQL.ArgusMap) then
			line.isInvasionPoint = true
		else
			line.isInvasionPoint = nil
		end
		
		if lfgEyeStatus then
			if data.disableLFG then
				line.LFGButton.questID = nil
			else
				line.LFGButton.questID = data.questID
			end
			line.LFGButton:Hide()
			line.LFGButton:Show()
		else
			line.LFGButton:Hide()
		end
		
		line.name:SetWidth(questNameWidth)
		
		line.reward:SetText(data.reward)
		if data.rewardColor then
			line.reward:SetTextColor(data.rewardColor.r, data.rewardColor.g, data.rewardColor.b)
		else
			line.reward:SetTextColor(1,1,1)
		end
		if data.rewardItem then
			line.reward.ID = data.questID
		else
			line.reward.ID = nil
		end
		line.isRewardLink = nil
		
		line.faction:SetText(data.faction)
		if data.highlightFaction then
			line.faction:SetTextColor(.8,.35,1)
		elseif data.factionInProgress then
			line.faction:SetTextColor(.5,1,.5)
		else
			line.faction:SetTextColor(1,1,1)
		end
		
		line.zone:SetText(data.zone)
		line.zone:SetWordWrap(false)	--icon-in-text v-spacing fix

		line.timeleft:SetText(data.timeleft or "")
		if data.isUnlimited then
			line.timeleft.f._t = nil
		else
			line.timeleft.f._t = data.time
		end
		
		if O.isGeneralMap then
			line.zone:Show()
			line.zone.f:Show()
		else
			line.zone:Hide()
			line.zone.f:Hide()
		end
		
		line.questID = data.questID
		line.numObjectives = data.numObjectives
		line.data = data.info
		
		if data.isNewQuest and not VWQL.DisableHighlightNewQuest then
			line.nqhl:Show()
		else
			line.nqhl:Hide()
		end
		
		if data.artifactKnowlege then
			line.reward.artifactKnowlege = true
			line.reward.timeToComplete = data.timeToComplete
		else
			line.reward.artifactKnowlege = nil
			line.reward.timeToComplete = nil
		end
		
		line.rewardLink = data.rewardItemLink
		
		line.faction.f.tooltip = data.bountyTooltip
		line.faction.f.reputationList = data.reputationList
		
		line.isLeveling = nil
		line.isTreasure = nil
		line.reward.IDs = nil
		
		line:Show()
	
		taskIconIndex = taskIconIndex + 1
	end
	
	WorldQuestList.currentResult = result
	WorldQuestList.currentO = O
	
	if O.isGeneralMap then
		WorldQuestList:SetWidth(WorldQuestList_Width+WorldQuestList_ZoneWidth)
		WorldQuestList.C:SetWidth(WorldQuestList_Width+WorldQuestList_ZoneWidth)	
	else
		WorldQuestList:SetWidth(WorldQuestList_Width)
		WorldQuestList.C:SetWidth(WorldQuestList_Width)	
	end
	
	WorldQuestList:SetHeight(max(16*(taskIconIndex-1)+(VWQL.DisableHeader and 0 or WorldQuestList.HEADER_HEIGHT)+(VWQL.DisableTotalAP and 0 or WorldQuestList.FOOTER_HEIGHT)+WorldQuestList.SCROLL_FIX_BOTTOM+WorldQuestList.SCROLL_FIX_TOP,1))
	WorldQuestList.C:SetHeight(max(16*(taskIconIndex-1),1))
	
	local lowestLine = #WorldQuestList.Cheader.lines
	local lowestPosConst = 30
	local lowestFixAnchorInside = VWQL.Anchor == 2 and WorldMapButton:GetBottom() or 0
	for i=1,#WorldQuestList.Cheader.lines do
		local bottomPos = (WorldQuestList.Cheader.lines[i]:GetBottom() or 0) - lowestFixAnchorInside
		if bottomPos and bottomPos < lowestPosConst then
			lowestLine = i - 1
			break
		end
	end
	
	if VWQL.MaxLinesShow then
		lowestLine = min(VWQL.MaxLinesShow,lowestLine)
	end
	
	if lowestLine >= taskIconIndex then
		WorldQuestList.Cheader:SetVerticalScroll(0)
	else
		WorldQuestList:SetHeight((lowestLine+1)*16+WorldQuestList.SCROLL_FIX_BOTTOM+WorldQuestList.SCROLL_FIX_TOP+(VWQL.DisableTotalAP and 0 or WorldQuestList.FOOTER_HEIGHT)+(VWQL.DisableHeader and 0 or WorldQuestList.HEADER_HEIGHT-16))
		WorldQuestList.Cheader:SetVerticalScroll( min(WorldQuestList.Cheader:GetVerticalScrollRange(),WorldQuestList.Cheader:GetVerticalScroll()) )
	end
	UpdateScrollButtonsState()
	C_Timer.After(0,UpdateScrollButtonsState)
	
	for i = taskIconIndex, NUM_WORLDMAP_TASK_POIS do
		WorldQuestList.l[i]:Hide()
	end
	
	if taskIconIndex == 1 then
		WorldQuestList.b:SetAlpha(0)
		WorldQuestList.backdrop:Hide()
		if mapAreaID == 619 or mapAreaID == 875 or mapAreaID == 876 or mapAreaID == 905 then
			ViewAllButton:Hide()
		else
			ViewAllButton:Show()
		end
		WorldQuestList.header:Update(true,nil,lfgEyeStatus)
		WorldQuestList.footer:Update(true)
	else
		WorldQuestList.b:SetAlpha(WorldQuestList.b.A or 1)
		WorldQuestList.backdrop:Show()
		ViewAllButton:Hide()
		WorldQuestList.header:Update(false,O.isGeneralMap,lfgEyeStatus)
		WorldQuestList.footer:Update(false,O.isGeneralMap)
	end
	
	if WorldQuestList:IsLegionZone(mapAreaID) then
		local name,_,icon = GetCurrencyInfo(1533)
		WorldQuestList.footer.ap:SetText((icon and "|T"..icon..":0|t " or "")..name..": "..totalWE)
		WorldQuestList.footer.OR:SetText(format("|T%d:0|t %d",1397630,totalOR))
	else
		local az_name,_,icon = GetCurrencyInfo(1553)
								
		WorldQuestList.footer.ap:SetText((icon and "|T"..icon..":0|t " or "")..az_name..": "..WorldQuestList:FormatAzeriteNumber(totalAzerite))
		WorldQuestList.footer.OR:SetText(format("|T%d:0|t %d",2032600,totalORbfa))
	end
	WorldQuestList.footer.gold:SetText(totalG > 0 and GetCoinTextureString(totalG) or "")
	
	WorldQuestList.oppositeContinentButton:Update()
	WorldQuestList.modeSwitcherCheck:Update(WorldQuestList.TreasureData[mapAreaID])
	
	if totalQuestsNumber == 0 then
		WorldQuestList.sortDropDown:Hide()
		WorldQuestList.filterDropDown:Hide()
		WorldQuestList.optionsDropDown:Show()
	else
		WorldQuestList.sortDropDown:Show()
		WorldQuestList.filterDropDown:Show()
		WorldQuestList.optionsDropDown:Show()		
	end
	
	HookWQbuttons()
	
	if VWQL.Anchor == 2 then	--Inside
		UpdateScale()
	end
end

WorldQuestList.UpdateList = WorldQuestList_Update

C_Timer.NewTicker(.8,function()
	if UpdateTicker then
		UpdateTicker = nil
		WorldQuestList_Update()
	end
end)

local UpdateDB_Sch = nil

local listZonesToUpdateDB = {947,830,885,882}
local function UpdateDB()
	UpdateDB_Sch = nil
	for questID,_ in pairs(TableQuestsViewed) do
		VWQL[charKey].Quests[ questID ] = true
	end
	local questsList = {}
	
	for _,mapID in pairs(listZonesToUpdateDB) do
		local z = C_TaskQuest.GetQuestsForPlayerByMapID(mapID)
		for i, info  in pairs(z) do
			local questID = info.questId
			if HaveQuestData(questID) and QuestUtils_IsQuestWorldQuest(questID) then
				questsList[ questID ] = true
			end
		end
	end
		
	local toRemove = {}
	for questID,_ in pairs(VWQL[charKey].Quests) do
		if not questsList[ questID ] then
			toRemove[ questID ] = true
		end
	end
	for questID,_ in pairs(toRemove) do
		VWQL[charKey].Quests[ questID ] = nil
	end
	
	wipe(TableQuestsViewed)
	
end

local WorldMapButton_HookShowHide = CreateFrame("Frame",nil,WorldMapButton)
WorldMapButton_HookShowHide:SetPoint("TOPLEFT")
WorldMapButton_HookShowHide:SetSize(1,1)

WorldMapButton_HookShowHide:SetScript('OnHide',function()
	if UpdateDB_Sch then
		UpdateDB_Sch:Cancel()
	end
	UpdateDB_Sch = C_Timer.NewTimer(.2,UpdateDB)
end)
WorldMapButton_HookShowHide:SetScript('OnShow',function()
	if UpdateDB_Sch then
		UpdateDB_Sch:Cancel()
	end
	if VWQL[charKey].HideMap then
		WorldQuestList:Hide()
		return
	end
	if WorldMapFrame:IsMaximized() and (VWQL.Anchor == 1 or not VWQL.Anchor) and (WorldMapFrame:GetWidth() / GetScreenWidth()) > 0.75 then
		if not WorldQuestList.IsSoloRun then
			WorldQuestList:Hide()
		end
		return
	elseif not WorldQuestList:IsVisible() then
		WorldQuestList:Show()
	end
	if (VWQL.Anchor == 3) then
		UpdateAnchor()
	end
	if WorldQuestList:IsVisible() then
		WorldQuestList:Hide()
		WorldQuestList:Show()
	end
end)

local prevZone, prevMapMode
WorldMapButton_HookShowHide:SetScript('OnUpdate',function(self)
	local mapMode = WorldMapFrame:IsMaximized()
	if prevMapMode ~= mapMode then
		prevMapMode = mapMode
		self:GetScript("OnShow")(self)
	end
	local currZone = GetCurrentMapAreaID()
	if currZone ~= prevZone then
		WorldQuestList_Update()
		if not VWQL.DisableIconsGeneral and WorldMapFrame:IsMaximized() and not WorldQuestList:IsVisible() then
			WorldQuestList_Update(nil,true)
		end
	end
	prevZone = currZone
	UpdateTicker = true
end)
WorldMapButton_HookShowHide:RegisterEvent("QUEST_LOG_UPDATE")
WorldMapButton_HookShowHide:SetScript("OnEvent",function()
	if WorldMapFrame:IsVisible() 
		--or (WorldQuestList:IsVisible() and WorldQuestList.IsSoloRun) 
		then
		UpdateTicker = true
	end
end)

SlashCmdList["WQLSlash"] = function(arg)
	local argL = strlower(arg)
	if (arg == "" and WorldMapFrame:IsVisible() and not WorldMapFrame:IsMaximized()) or argL == "help" then
		print("World Quests List v."..VERSION)
		print("|cffffff00/wql options|r - force options dropdown")		
		print("|cffffff00/wql reset|r - reset position")
		print("|cffffff00/wql resetanchor|r - reset anchor to default")
		print("|cffffff00/wql resetscale|r - reset scale to default (100%)")
		print("|cffffff00/wql scale 80|r - set custom scale (example, 80%)")
		return
	elseif argL == "reset" then
		VWQL.PosLeft = nil
		VWQL.PosTop = nil
		VWQL.Anchor3PosLeft = nil
		VWQL.Anchor3PosTop = nil
		ReloadUI()
		print("Position Reseted")
		return
	elseif argL == "resetanchor" then 
		VWQL.Anchor = nil
		UpdateAnchor()
		print("Anchor Reseted")
		return
	elseif argL == "resetscale" then 
		VWQL.Scale = nil
		UpdateScale()
		print("Scale Reseted")
		return
	elseif argL:find("^scale %d+") then 
		VWQL.Scale = tonumber( argL:match("%d+"),nil ) / 100
		UpdateScale()
		print("Scale set to "..(VWQL.Scale * 100).."%")
		return
	elseif argL:find("^iconscale %d+") then 
		VWQL.MapIconsScale = tonumber( argL:match("%d+"),nil ) / 100
		print("Icons scale set to "..(VWQL.MapIconsScale * 100).."%")
		return		
	elseif argL:find("^way ") then 
		local x,y = argL:match("([%d%.,]+) ([%d%.,]+)")
		if x and y then
			x = tonumber( x:gsub(",$",""),nil )
			y = tonumber( y:gsub(",$",""),nil )
			if x and y then
				local mapID = C_Map.GetBestMapForUnit("player")
				if WorldMapFrame:IsVisible() then
					mapID = GetCurrentMapAreaID()
				end
				if mapID then
					local wX,wY = WorldQuestList:GetQuestWorldCoord2(-10,mapID,x / 100,y / 100,true)
					if wX and wY then
						WQLdb.Arrow:ShowRunTo(wX,wY,5,nil,true)
					end
				end
			end
		end
		return		
	elseif argL == "options" then 
		WorldQuestList.optionsDropDown.Button:Click()
		return
	elseif WorldQuestList:IsVisible() then
		WorldQuestList:Hide()
		WorldQuestList:Show()
		return
	end
	WorldQuestList:ClearAllPoints()
	WorldQuestList:SetParent(UIParent)
	if type(VWQL)=='table' and type(VWQL.PosLeft)=='number' and type(VWQL.PosTop) == 'number' then
		WorldQuestList:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VWQL.PosLeft,VWQL.PosTop)
	else
		WorldQuestList:SetPoint("TOPLEFT",WorldMapFrame,20,0)
	end
	WorldQuestList.IsSoloRun = true
	local currZone = C_Map.GetBestMapForUnit("player")--GetCurrentMapAreaID()
	if argL == "argus" then
		currZone = 905
	elseif argL == "all" then
		currZone = 947
	elseif currZone == 905 or currZone == 885 or currZone == 882 or currZone == 830 then
		currZone = 905
	elseif WorldQuestList:IsLegionZone(currZone) then
		currZone = 619
	elseif WorldQuestList:IsMapParent(currZone,875) then
		currZone = 875
	elseif WorldQuestList:IsMapParent(currZone,876) then
		currZone = 876
	else
		currZone = 947
	end
	
	WorldQuestList.SoloMapID = currZone
	
	UpdateScale()
	WorldQuestList.Close:Show()
	WorldQuestList.moveHeader:Show()
	WorldQuestList:Show()
	WorldQuestList_Update()
	
	WorldQuestList:SetFrameStrata("DIALOG")

	C_Timer.After(.5,WorldQuestList_Update)
	C_Timer.After(1.5,WorldQuestList_Update)
	if currZone == 947 then
		C_Timer.After(2.5,WorldQuestList_Update)
	end
end
SLASH_WQLSlash1 = "/wql"
SLASH_WQLSlash2 = "/worldquestslist"

WorldMapHideWQLCheck = CreateFrame("CheckButton",nil,WorldMapFrame,"UICheckButtonTemplate")  
WorldMapHideWQLCheck:SetPoint("TOPLEFT", WorldMapFrame, "TOPRIGHT", -130, 25)
WorldMapHideWQLCheck.text:SetText("世界任务列表")
WorldMapHideWQLCheck:SetScript("OnClick", function(self,event) 
	if not self:GetChecked() then
		VWQL[charKey].HideMap = true
		WorldQuestList:Hide()
	else
		VWQL[charKey].HideMap = nil
		WorldQuestList:Show()
		WorldQuestList_Update()
	end
end)




WorldQuestList.BlackListWindow = CreateFrame("Frame",nil,UIParent)
WorldQuestList.BlackListWindow:SetBackdrop({bgFile="Interface/Buttons/WHITE8X8"})
WorldQuestList.BlackListWindow:SetBackdropColor(0.05,0.05,0.07,0.98)
WorldQuestList.BlackListWindow.title = WorldQuestList.BlackListWindow:CreateFontString(nil,"OVERLAY","GameFontNormal")
WorldQuestList.BlackListWindow.title:SetPoint("TOP",0,-3)
WorldQuestList.BlackListWindow.title:SetTextColor(1,0.66,0,1)
WorldQuestList.BlackListWindow.title:SetText(IGNORE)
WorldQuestList.BlackListWindow:SetPoint("CENTER")
WorldQuestList.BlackListWindow:Hide()
WorldQuestList.BlackListWindow:SetFrameStrata("DIALOG")
WorldQuestList.BlackListWindow:SetClampedToScreen(true)
WorldQuestList.BlackListWindow:EnableMouse(true)
WorldQuestList.BlackListWindow:SetMovable(true)
WorldQuestList.BlackListWindow:RegisterForDrag("LeftButton")
WorldQuestList.BlackListWindow:SetDontSavePosition(true)
WorldQuestList.BlackListWindow:SetScript("OnDragStart", function(self) 
	self:StartMoving() 
end)
WorldQuestList.BlackListWindow:SetScript("OnDragStop", function(self) 
	self:StopMovingOrSizing() 
end)
WorldQuestList.BlackListWindow:SetSize(500,300)

WorldQuestList.BlackListWindow:SetScript("OnShow", function(self) 
	if not self.created then
		self.created = true
		
		self.close = ELib:Button(self,CLOSE)
		self.close:SetSize(100,20)
		self.close:SetPoint("BOTTOM",0,5)
		self.close:SetScript("OnClick",function() self:Hide() end)
		
		--lazy solution
		self.S = CreateFrame("ScrollFrame", nil, self)
		self.C = CreateFrame("Frame", nil, self.S) 
		self.S:SetScrollChild(self.C)
		self.S:SetSize(470,250)
		self.C:SetSize(470,250)
		self.S:SetPoint("TOP",-7,-20)
		
		self.S:SetScript("OnMouseWheel",function (self,delta)
			delta = delta * 5
			local min,max = self.ScrollBar:GetMinMaxValues()
			local val = self.ScrollBar:GetValue()
			if (val - delta) < min then
				self.ScrollBar:SetValue(min)
			elseif (val - delta) > max then
				self.ScrollBar:SetValue(max)
			else
				self.ScrollBar:SetValue(val - delta)
			end  
		end)
		
		self.S.ScrollBar = CreateFrame("Slider", nil, self.S)
		self.S.ScrollBar:SetPoint("TOPLEFT",self.S,"TOPRIGHT",1,0)
		self.S.ScrollBar:SetPoint("BOTTOMLEFT",self.S,"BOTTOMRIGHT",1,0)
		self.S.ScrollBar:SetWidth(14)
		ELib.Templates:Border(self.S.ScrollBar,.24,.25,.30,1,1)

		self.S.ScrollBar.thumb = self.S.ScrollBar:CreateTexture(nil, "OVERLAY")
		self.S.ScrollBar.thumb:SetColorTexture(0.44,0.45,0.50,.7)
		self.S.ScrollBar.thumb:SetSize(10,20)
		
		self.S.ScrollBar:SetThumbTexture(self.S.ScrollBar.thumb)
		self.S.ScrollBar:SetOrientation("VERTICAL")
		self.S.ScrollBar:SetMinMaxValues(0,0)
		self.S.ScrollBar:SetValue(0)
		self.S:SetVerticalScroll(0) 
		
		self.S.ScrollBar:SetScript("OnValueChanged",function(_,value)
			self.S:SetVerticalScroll(value) 
		end)
		
		ELib.Templates:Border(self.S,.24,.25,.30,1,1)
		
		self.L = {}
		
		local function UnignoreQuest(self)
			local questID = self:GetParent().d
			if not questID then
				return
			end
			questID = questID[1]
			VWQL.Ignore[questID] = nil
			WorldQuestList_Update()
			WorldQuestList.BlackListWindow:Hide()
			WorldQuestList.BlackListWindow:Show()
		end
		
		self.GetLine = function(i)
			if self.L[i] then
				return self.L[i]
			end
			local line = CreateFrame("Frame",nil,self.C)
			self.L[i] = line
			line:SetPoint("TOPLEFT",0,-(i-1)*18)
			line:SetSize(470,18)
			
			line.n = line:CreateFontString(nil,"ARTWORK","GameFontNormal")
			line.n:SetPoint("LEFT",5,0)
			line.n:SetSize(140,18)
			line.n:SetJustifyH("LEFT")
			line.n:SetFont(line.n:GetFont(),10)
			
			line.z = line:CreateFontString(nil,"ARTWORK","GameFontWhite")
			line.z:SetPoint("LEFT",line.n,"RIGHT",5,0)
			line.z:SetSize(100,18)
			line.z:SetJustifyH("LEFT")
			line.z:SetFont(line.z:GetFont(),10)
			
			line.t = line:CreateFontString(nil,"ARTWORK","GameFontWhite")
			line.t:SetPoint("LEFT",line.z,"RIGHT",5,0)
			line.t:SetSize(120,18)
			line.t:SetJustifyH("LEFT")
			line.t:SetFont(line.t:GetFont(),10)
			
			line.d = ELib:Button(line,DELETE)
			line.d:SetSize(80,16)
			line.d:SetPoint("RIGHT",-5,0)
			line.d:SetScript("OnClick",UnignoreQuest)
						
			return line
		end
	end
	
	local list = {}
	for questID,timeAdded in pairs(VWQL.Ignore) do
		local name,factionID = C_TaskQuest.GetQuestInfoByQuestID(questID)
		
		local factionName
		if ( factionID ) then
			factionName = GetFactionInfoByID(factionID)
		end
		
		list[#list+1] = {questID,timeAdded,name or "Quest "..questID,factionName,date("%x %X",timeAdded)}
	end
	sort(list,function(a,b) return a[2]>b[2] end)
	
	for i=1,#list do
		local line = self.GetLine(i)
		line.n:SetText(list[i][3])
		line.z:SetText(list[i][4] or "")
		line.t:SetText(list[i][5])
		
		line.d = list[i]
		line:Show()
	end
	for i=#list+1,#self.L do
		self.L[i]:Hide()
	end
	
	self.C:SetHeight(1+#list*18)
	--self.S:SetVerticalScroll(0) 
	
	local maxHeight = max(0,#list*18 - 250)
	self.S.ScrollBar:SetMinMaxValues(0,maxHeight)
	
	local oldVal = self.S.ScrollBar:GetValue()
	self.S.ScrollBar:SetValue(min(oldVal,maxHeight))
end)


--Flight Map X

local FlightMap = CreateFrame("Frame")
FlightMap:RegisterEvent("ADDON_LOADED")
FlightMap:SetScript("OnEvent",function (self, event, arg)
	if arg == "Blizzard_FlightMap" then
		local X_icons = {}
		local f = CreateFrame("Frame",nil,FlightMapFrame.ScrollContainer.Child)
		f:SetPoint("TOPLEFT")
		f:SetSize(1,1)
		f:SetFrameStrata("TOOLTIP")
		f:SetScript("OnShow",function()
			f:RegisterEvent("QUEST_WATCH_LIST_CHANGED")
			local mapID = GetTaxiMapID()
			local x_count = 0
			if mapID and (not VWQL or not VWQL.DisableTaxiX) then
				local mapQuests = C_TaskQuest.GetQuestsForPlayerByMapID(mapID)
				local questsWatched = GetNumWorldQuestWatches()
				for _,questData in pairs(mapQuests) do
					for i=1,questsWatched do
						local questID = GetWorldQuestWatchInfo(i)
						if questID == questData.questId then
							x_count = x_count + 1
							local X_icon = X_icons[x_count]
							if not X_icon then
								X_icon = f:CreateTexture(nil,"OVERLAY")
								X_icons[x_count] = X_icon
								X_icon:SetAtlas("XMarksTheSpot")
							end
							local func = function()
								local width = FlightMapFrame.ScrollContainer.Child:GetWidth()
								local size = 24 * width / 1002
								X_icon:SetSize(size,size)
								X_icon:SetPoint("CENTER",FlightMapFrame.ScrollContainer.Child,"TOPLEFT",width * questData.x,-FlightMapFrame.ScrollContainer.Child:GetHeight() * questData.y)
								X_icon:Show()
							end
							C_Timer.After(.1,func)
							break
						end
					end
				end
			end
			for i=x_count+1,#X_icons do
				X_icons[i]:Hide()
			end
		end)
		f:SetScript("OnHide",function()
			f:UnregisterEvent("QUEST_WATCH_LIST_CHANGED")
		end)
		local prevScale = 0
		f:SetScript("OnEvent",function(self,event)
			if event == "QUEST_WATCH_LIST_CHANGED" then
				self:GetScript("OnShow")(self)
				prevScale = 0
			end
		end)
		f:SetScript("OnUpdate",function()
			local scale = FlightMapFrame.ScrollContainer.Child:GetScale()
			if scale ~= prevScale then
				prevScale = scale
				if scale < .4 then
					for i=1,#X_icons do
						X_icons[i]:SetAlpha(1)
					end
				else
					local alpha = 1 - min(max(0,scale - .4) / .4, 1)
					for i=1,#X_icons do
						X_icons[i]:SetAlpha(alpha)
					end
				end
			end
		end)

		self:UnregisterAllEvents()
	end
end)


-- Argus map
do
	local WQL_Argus_Map = CreateFromMixins(MapCanvasDataProviderMixin)
	
	local texturesList = {}
	local textureState = nil
	
	local bountyOverlayFrame
	
	local function CreateArgusMap()
		local size = 70
		for i=1,10 do
			for j=1,15 do
				local t = WorldMapButton:CreateTexture(nil,"BACKGROUND")
				texturesList[#texturesList + 1] = t
				t:SetSize(size,size)
				t:SetPoint("TOPLEFT",size*(j-1),-size*(i-1))
				t:SetTexture("Interface\\AdventureMap\\Argus\\AM_"..((i-1)*15 + j - 1))
				t:SetAlpha(0)
			end
		end
		CreateArgusMap = nil
	end
	
	local function UpdateBountyOverlayPos()
		if bountyOverlayFrame then
			WorldMapFrame:SetOverlayFrameLocation(bountyOverlayFrame, 3)
		end
	end
	local function UpdatePOIs()
		local areaPOIs = C_AreaPoiInfo.GetAreaPOIForMap(994)
		for _, areaPoiID in pairs(areaPOIs) do
			local poiInfo = C_AreaPoiInfo.GetAreaPOIInfo(994, areaPoiID)
			if poiInfo and (type(poiInfo.atlasName)~='string' or not poiInfo.atlasName:find("Vindicaar")) then
				WorldMapFrame:AcquirePin(AreaPOIDataProviderMixin:GetPinTemplate(), poiInfo)
			end
		end	  
	end
	local function UpdateTaxiNodes()
		local taxiNodes = C_TaxiMap.GetTaxiNodesForMap(994)
		local factionGroup = UnitFactionGroup("player")
		for _, taxiNodeInfo in pairs(taxiNodes) do
			if FlightPointDataProviderMixin:ShouldShowTaxiNode(factionGroup, taxiNodeInfo) and (type(taxiNodeInfo.textureKitPrefix)~='string' or not taxiNodeInfo.textureKitPrefix:find("Vindicaar")) then
				WorldMapFrame:AcquirePin("FlightPointPinTemplate", taxiNodeInfo)
			end
		end
	end
		
	function WQL_Argus_Map:RefreshAllData()
		if not VWQL or VWQL.ArgusMap then
			if textureState then
				for i=1,#texturesList do
					texturesList[i]:SetAlpha(0)
				end
				self:UnregisterEvent("QUEST_LOG_UPDATE")
				self:UnregisterEvent("AREA_POIS_UPDATED")
				textureState = nil
			end
			return
		end
		local mapID = self:GetMap():GetMapID()
		if mapID == 905 then
			if CreateArgusMap then 
				CreateArgusMap()
			end
			if not textureState then
				for i=1,#texturesList do
					texturesList[i]:SetAlpha(1)
				end
				self:RegisterEvent("QUEST_LOG_UPDATE")
				self:RegisterEvent("AREA_POIS_UPDATED")
				textureState = true
			end
			if not bountyOverlayFrame then
				for _,frame in pairs(WorldMapFrame.overlayFrames) do
					if frame.ShowBountyTooltip then
						bountyOverlayFrame = frame
						break
					end
				end
			end
			
			--Some ugly code here
			UpdateBountyOverlayPos()
			C_Timer.After(0,UpdateBountyOverlayPos)
			
			UpdatePOIs()
			C_Timer.After(0,UpdatePOIs)
			
			UpdateTaxiNodes()
			C_Timer.After(0,UpdateTaxiNodes)
		elseif textureState then
			for i=1,#texturesList do
				texturesList[i]:SetAlpha(0)
			end
			self:UnregisterEvent("QUEST_LOG_UPDATE")
			self:UnregisterEvent("AREA_POIS_UPDATED")
			textureState = nil
		end
	end
	
	function WQL_Argus_Map:OnEvent(event, ...)
		if event == "QUEST_LOG_UPDATE" and WorldMapFrame:IsVisible() and WorldMapFrame:GetMapID() == 905 then
			UpdateBountyOverlayPos()
			C_Timer.After(0,UpdateBountyOverlayPos)
		elseif event == "AREA_POIS_UPDATED" and WorldMapFrame:IsVisible() and WorldMapFrame:GetMapID() == 905 then
			UpdatePOIs()
			C_Timer.After(0,UpdatePOIs)
		end
	end
	
	WQL_Argus_Map.WQL_Signature = true
	
	local isRegistered = false
	function WorldQuestList:RegisterArgusMap()
		if isRegistered then
			return
		end
		WorldMapFrame:AddDataProvider(WQL_Argus_Map)
		isRegistered = true
		WQL_Argus_Map:RefreshAllData()
	end
end

-- TreasureData

WorldQuestList.TreasureData = WQLdb.TreasureData or {}

--- LFG features

local QuestCreationBox = CreateFrame("Button","WQL_QuestCreationBox",UIParent)
QuestCreationBox:SetSize(350,120)
QuestCreationBox:SetPoint("CENTER",0,250)
QuestCreationBox:SetMovable(false)
QuestCreationBox:EnableMouse(true)
QuestCreationBox:SetClampedToScreen(true)
QuestCreationBox:RegisterForDrag("LeftButton")
QuestCreationBox:RegisterForClicks("RightButtonUp")
QuestCreationBox:Hide()

QuestCreationBox:SetScript("OnClick",function(self)
	self:Hide()
end)

--tinsert(UISpecialFrames, "WQL_QuestCreationBox")

WorldQuestList.QuestCreationBox = QuestCreationBox

QuestCreationBox.b = QuestCreationBox:CreateTexture(nil,"BACKGROUND")
QuestCreationBox.b:SetAllPoints()
QuestCreationBox.b:SetColorTexture(0.04,0.04,0.04,.97)
QuestCreationBox.b.A = .97

QuestCreationBox.Text1 = QuestCreationBox:CreateFontString(nil,"ARTWORK","GameFontWhite")
QuestCreationBox.Text1:SetPoint("TOP",0,-5)
do
	local a1,a2 = QuestCreationBox.Text1:GetFont()
	QuestCreationBox.Text1:SetFont(a1,12)
end

QuestCreationBox.Text2 = QuestCreationBox:CreateFontString(nil,"ARTWORK","GameFontWhite")
QuestCreationBox.Text2:SetPoint("TOP",0,-25)
QuestCreationBox.Text2:SetTextColor(0,1,0)
do
	local a1,a2 = QuestCreationBox.Text2:GetFont()
	QuestCreationBox.Text2:SetFont(a1,20)
end

QuestCreationBox.Close = CreateFrame("Button",nil,QuestCreationBox)
QuestCreationBox.Close:SetPoint("TOPRIGHT")
QuestCreationBox.Close:SetSize(22,22)
QuestCreationBox.Close:SetScript("OnClick",function()
	QuestCreationBox:Hide()
end)

ELib.Templates:Border(QuestCreationBox.Close,.22,.22,.3,1,1)

QuestCreationBox.Close.X = QuestCreationBox.Close:CreateFontString(nil,"ARTWORK","GameFontWhite")
QuestCreationBox.Close.X:SetPoint("CENTER",QuestCreationBox.Close)
QuestCreationBox.Close.X:SetText("X")
do
	local a1,a2 = QuestCreationBox.Close.X:GetFont()
	QuestCreationBox.Close.X:SetFont(a1,14)
end

QuestCreationBox.PartyLeave = ELib:Button(QuestCreationBox,PARTY_LEAVE)
QuestCreationBox.PartyLeave:SetSize(220,25)
QuestCreationBox.PartyLeave:SetPoint("BOTTOM",0,5)
QuestCreationBox.PartyLeave:SetScript("OnClick",function()
	local n = GetNumGroupMembers() or 0
	if n == 0 then
		if C_LFGList.GetActiveEntryInfo() then
			C_LFGList.RemoveListing()
		end
	else
		LeaveParty()
	end
	QuestCreationBox:Hide()
end)
QuestCreationBox.PartyLeave:Hide()


QuestCreationBox.PartyFind = ELib:Button(QuestCreationBox,FIND_A_GROUP)
QuestCreationBox.PartyFind:SetSize(220,22)
QuestCreationBox.PartyFind:SetPoint("BOTTOM",0,5)
QuestCreationBox.PartyFind:SetScript("OnClick",function(self,button)
	QuestCreationBox:Hide()
	if C_LFGList.CanCreateQuestGroup(self.questID) then
		LFGListUtil_FindQuestGroup(self.questID)
	elseif button == "RightButton" then
		WorldQuestList.LFG_StartQuest(self.questID)
	else
		WorldQuestList.LFG_Search(self.questID)
	end
end)
QuestCreationBox.PartyFind:Hide()

QuestCreationBox.ListGroup = ELib:Button(QuestCreationBox,FIND_A_GROUP)
QuestCreationBox.ListGroup:SetSize(220,25)
QuestCreationBox.ListGroup:SetPoint("BOTTOM",0,5)
QuestCreationBox.ListGroup:Hide()
QuestCreationBox.ListGroup:SetText(LIST_GROUP)

QuestCreationBox.FindGroup = ELib:Button(QuestCreationBox,SEARCH)
QuestCreationBox.FindGroup:SetSize(220,25)
QuestCreationBox.FindGroup:SetPoint("BOTTOM",0,5)
QuestCreationBox.FindGroup:Hide()
QuestCreationBox.FindGroup:SetText(SEARCH)

QuestCreationBox:SetScript("OnDragStart", function(self)
	self:SetMovable(true)
	self:StartMoving()
end)
QuestCreationBox:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing()
	self:SetMovable(false)

	if VWQL then
		VWQL.AnchorQCBLeft = self:GetLeft()
		VWQL.AnchorQCBTop = self:GetTop() 
	end
end)
QuestCreationBox:SetScript("OnUpdate",function(self)
	if QuestCreationBox.type == 4 and LFGListFrame.SearchPanel.SearchBox:GetText():lower() == QuestCreationBox.Text2:GetText():lower() then
		QuestCreationBox.Text2:SetTextColor(0,1,0)
	elseif QuestCreationBox.type ~= 4 and LFGListFrame.EntryCreation.Name:GetText() == QuestCreationBox.Text2:GetText() then
		QuestCreationBox.Text2:SetTextColor(0,1,0)
	else
		QuestCreationBox.Text2:SetTextColor(1,1,0)
	end
end)

ELib.Templates:Border(QuestCreationBox,.22,.22,.3,1,1)
QuestCreationBox.shadow = ELib:Shadow2(QuestCreationBox,16)

local defPoints
local defPointsSearch

local minIlvlReq = UnitLevel'player' >= 120 and 240 or 160

function WQL_LFG_StartQuest(questID)
	if GroupFinderFrame:IsVisible() or C_LFGList.GetActiveEntryInfo() then
		return
	end

	local edit = LFGListFrame.EntryCreation.Name
	local button = QuestCreationBox.ListGroup
	local check = LFGListFrame.ApplicationViewer.AutoAcceptButton
	
	QuestCreationBox:Show()
	QuestCreationBox:SetSize(350,120)
	QuestCreationBox.PartyLeave:Hide()
	QuestCreationBox.PartyFind:Hide()
	QuestCreationBox.FindGroup:Hide()
	QuestCreationBox.ListGroup:Show()

	LFGListUtil_OpenBestWindow()
	
	PVEFrame:ClearAllPoints() 
	PVEFrame:SetPoint("TOP",UIParent,"BOTTOM",0,-100)
	
	local autoCreate = nil
	if tostring(questID) == edit:GetText() then
		LFGListEntryCreation_SetEditMode(LFGListFrame.EntryCreation, false)
		LFGListEntryCreation_UpdateValidState(LFGListFrame.EntryCreation)
		LFGListFrame_SetActivePanel(LFGListFrame.EntryCreation:GetParent(), LFGListFrame.EntryCreation)
		autoCreate = true
	else
		LFGListEntryCreation_Show(LFGListFrame.EntryCreation, LFGListFrame.baseFilters, 1, 0)
	end	

	local activityID, categoryID, filters, questName = LFGListUtil_GetQuestCategoryData(questID)
	if activityID then
		LFGListEntryCreation_Select(LFGListFrame.EntryCreation, filters, categoryID, nil, activityID)
	end
	
	if not defPoints then
		defPoints = {
			[edit] = {edit:GetPoint()},
		}
		button:SetScript("OnClick",function()
			if not QuestCreationBox:IsShown() or edit:GetText() == "" then
				return
			end
			
			local playerIlvl = GetAverageItemLevel()
			local itemLevel = minIlvlReq > playerIlvl and floor(playerIlvl) or minIlvlReq
			local honorLevel = 0
			local autoAccept = true
			local privateGroup = false
		
			LFGListEntryCreation_ListGroupInternal(LFGListFrame.EntryCreation, LFGListFrame.EntryCreation.selectedActivity, itemLevel, honorLevel, autoAccept, privateGroup)
			
			edit:ClearAllPoints()
			edit:SetPoint(unpack(defPoints[edit]))
			edit.Instructions:SetText(LFG_LIST_ENTER_NAME)

			PVEFrame_ToggleFrame()
			QuestCreationBox:Hide()		

			if LFGListFrame:IsVisible() then
				PVEFrame_ToggleFrame()
			end				
		end)
		edit:HookScript("OnEnterPressed",function()
			if not QuestCreationBox:IsShown() then
				return
			end
			
			button:Click()
		end)
	end
	
	QuestCreationBox.Text1:SetText("WQL: "..LOCALE.lfgTypeText)
	QuestCreationBox.Text2:SetText(questID)
	QuestCreationBox.questID = questID
	QuestCreationBox.type = 1
	
	edit:ClearAllPoints()
	edit:SetPoint("TOP",QuestCreationBox,"TOP",0,-50)
	edit.Instructions:SetText(questID)
	if IsPlayerMoving() then
		edit:ClearFocus()
	end

	local apps = C_LFGList.GetApplications()
	for i=1, #apps do
		C_LFGList.CancelApplication(apps[i])
	end

	if autoCreate then
		button:Click()
	end
end
WorldQuestList.LFG_StartQuest = WQL_LFG_StartQuest

LFGListFrame.EntryCreation:HookScript("OnShow",function()
	if not defPoints then
		return
	end
	local edit = LFGListFrame.EntryCreation.Name

	edit:ClearAllPoints()
	edit:SetPoint(unpack(defPoints[edit]))
	edit.Instructions:SetText(LFG_LIST_ENTER_NAME)
end)

QuestCreationBox:SetScript("OnHide",function()
	if defPoints then
		local edit = LFGListFrame.EntryCreation.Name
	
		edit:ClearAllPoints()
		edit:SetPoint(unpack(defPoints[edit]))
		edit.Instructions:SetText(LFG_LIST_ENTER_NAME)
	
		edit:ClearFocus()
	end

	if defPointsSearch then
		local edit = LFGListFrame.SearchPanel.SearchBox
	
		edit:ClearAllPoints()
		edit:SetPoint(unpack(defPointsSearch[edit]))
		edit.Instructions:SetText(FILTER)
	
		edit:ClearFocus()
		
		local fb = LFGListFrame.SearchPanel.FilterButton
	
		fb:ClearAllPoints()
		fb:SetPoint(unpack(defPointsSearch[fb]))
	end
	
	if QuestCreationBox.type == 1 or QuestCreationBox.type == 4 then
		if GroupFinderFrame:IsVisible() then
			PVEFrame_ToggleFrame()
		end
	end
end)

local searchQuestID = nil
local isAfterSearch = nil
local autoCreateQuestID = nil

function WQL_LFG_Search(questID)
	searchQuestID = nil

	if C_LFGList.GetActiveEntryInfo() then
		return
	end
	
	if not GroupFinderFrame:IsVisible() then
		LFGListUtil_OpenBestWindow()
	end
		
	PVEFrame:ClearAllPoints() 
	PVEFrame:SetPoint("TOP",UIParent,"BOTTOM",0,-100)
	
	local edit = LFGListFrame.SearchPanel.SearchBox
	local fb = LFGListFrame.SearchPanel.FilterButton
	local button = QuestCreationBox.FindGroup

	if not defPointsSearch then
		defPointsSearch = {
			[edit] = {edit:GetPoint()},
			[fb] = {fb:GetPoint()},
		}
		button:SetScript("OnClick",function()
			QuestCreationBox:Hide()
			PVEFrame_ToggleFrame()
			
			edit:GetScript("OnEnterPressed")(edit)
			
			searchQuestID = edit.WQL_questID
		end)
		edit:HookScript("OnEnterPressed",function(self)
			if not QuestCreationBox:IsShown() then
				return
			end
			
			QuestCreationBox:Hide()
			PVEFrame_ToggleFrame()
			
			searchQuestID = self.WQL_questID
		end)
	end

	
	local languagesOn = C_LFGList.GetLanguageSearchFilter()
	local languagesAll = C_LFGList.GetAvailableLanguageSearchFilter()
	local languagesCount = 0
	for _ in pairs(languagesOn) do languagesCount = languagesCount + 1 end
	if languagesCount ~= #languagesAll then
	        local languages = {}
	        for _,lang in pairs(languagesAll) do 
	        	languages[lang]=true 
	        end
		C_LFGList.SaveLanguageSearchFilter(languages)
	end
	
	local panel = LFGListFrame.CategorySelection
	LFGListFrame_SetActivePanel(LFGListFrame, panel)
	LFGListCategorySelection_SelectCategory(panel, 1, 0)

	local autoSearch = nil
	if tostring(questID) == edit:GetText() then
		--copy of LFGListCategorySelection_StartFindGroup
		local baseFilters = panel:GetParent().baseFilters
	
		local searchPanel = panel:GetParent().SearchPanel
		C_LFGList.ClearSearchResults()
		searchPanel.selectedResult = nil
		LFGListSearchPanel_UpdateResultList(searchPanel)
		LFGListSearchPanel_UpdateResults(searchPanel)
		LFGListSearchPanel_SetCategory(searchPanel, panel.selectedCategory, panel.selectedFilters, baseFilters)
		LFGListSearchPanel_DoSearch(searchPanel)
		LFGListFrame_SetActivePanel(panel:GetParent(), searchPanel)
		autoSearch = true
	else
		LFGListCategorySelection_StartFindGroup(panel)
	end

	QuestCreationBox:Show()
	QuestCreationBox:SetSize(350,120)
	QuestCreationBox.PartyLeave:Hide()
	QuestCreationBox.PartyFind:Hide()
	QuestCreationBox.ListGroup:Hide()
	QuestCreationBox.FindGroup:Show()
	
	QuestCreationBox.Text1:SetText(SEARCH..": "..LOCALE.lfgTypeText)
	QuestCreationBox.Text2:SetText(questID)
	QuestCreationBox.questID = questID
	QuestCreationBox.type = 4
	
	edit:ClearAllPoints()
	edit:SetPoint("TOP",QuestCreationBox,"TOP",0,-50)
	edit.Instructions:SetText(questID)
	edit:SetFocus()
	if IsPlayerMoving() then
		edit:ClearFocus()
	end
	
	edit.WQL_questID = questID
	
	fb:ClearAllPoints()
	fb:SetPoint("TOP",UIParent,"BOTTOM",0,-100)
	
	searchQuestID = questID
	
	if type(questID)=='number' then
		local questName = C_TaskQuest.GetQuestInfoByQuestID(questID)
		if not questName then
			questName = GetQuestLogTitle(GetQuestLogIndexByID(questID))
		end
		
		if questName and IsShiftKeyDown() then
			QuestCreationBox.Text2:SetText(questName)
		end
		if questName then
			edit.Instructions:SetText(questID..", "..questName)
		end
	end	

	if autoSearch then
		button:Click()
	end
	
end
WorldQuestList.LFG_Search = WQL_LFG_Search

LFGListFrame.SearchPanel:HookScript("OnShow",function()
	if not defPointsSearch then
		return
	end
	local edit = LFGListFrame.SearchPanel.SearchBox
	local fb = LFGListFrame.SearchPanel.FilterButton

	edit:ClearAllPoints()
	edit:SetPoint(unpack(defPointsSearch[edit]))
	edit.Instructions:SetText(FILTER)
	
	fb:ClearAllPoints()
	fb:SetPoint(unpack(defPointsSearch[fb]))
end)

local function IsTeoreticalWQ(name)
	if name and name:find("k00000|") then
		return true
	end
end

hooksecurefunc("LFGListSearchPanel_SelectResult", function(self, resultID)
	if not VWQL or VWQL.DisableLFG then
		return
	end
	local id, activityID, name = C_LFGList.GetSearchResultInfo(resultID)
	if name and LFGListFrame.SearchPanel.categoryID == 1 and IsTeoreticalWQ(name) then
		LFGListFrame.SearchPanel.SignUpButton:Click()
		LFGListApplicationDialog.SignUpButton:Click()
	end
end)

hooksecurefunc("LFGListGroupDataDisplayPlayerCount_Update", function(self, displayData, disabled)
	local line = self:GetParent():GetParent()
	local numPlayers = displayData.TANK + displayData.HEALER + displayData.DAMAGER + displayData.NOROLE
	if disabled or not line or not line.resultID or numPlayers ~= 5 then
		return
	end	
	local id, activityID, name = C_LFGList.GetSearchResultInfo(line.resultID)
	if name and LFGListFrame.SearchPanel.categoryID == 1 then
		self.Count:SetText("|cffff0000"..numPlayers)
	end
end)


WorldQuestList.LFG_LastResult = {}

QuestCreationBox.PopupBlacklist = WQLdb.WorldQuestPopupBlacklist or {}

local function CheckQuestPassPopup(questID)
	local _,_,worldQuestType = GetQuestTagInfo(questID)
	if (worldQuestType == LE_QUEST_TAG_TYPE_DUNGEON) or
		(worldQuestType == LE_QUEST_TAG_TYPE_RAID) or
		(worldQuestType == LE_QUEST_TAG_TYPE_PET_BATTLE) 
	then
		return false
	end
	
	local _, zoneType = IsInInstance()
	if zoneType == "arena" or zoneType == "raid" or zoneType == "party" then
		return false
	end
	
	if QuestCreationBox.PopupBlacklist[questID] then
		return false
	end
	
	return true
end

function WorldQuestList:IsQuestDisabledForLFG(questID)
	if QuestCreationBox.PopupBlacklist[questID or 0] then
		return true
	else
		return false
	end
end

local LFGListFrameSearchPanelStartGroup = CreateFrame("Button",nil,LFGListFrame.SearchPanel,"UIPanelButtonTemplate")
LFGListFrameSearchPanelStartGroup:SetPoint("LEFT",LFGListFrame.SearchPanel.BackButton,"RIGHT")
LFGListFrameSearchPanelStartGroup:SetPoint("RIGHT",LFGListFrame.SearchPanel.SignUpButton,"LEFT")
LFGListFrameSearchPanelStartGroup:SetHeight(22)
LFGListFrameSearchPanelStartGroup:SetText(START_A_GROUP)
LFGListFrameSearchPanelStartGroup:SetScript("OnClick",function(self)
	if self.questID then
		PVEFrame_ToggleFrame()
		WQL_LFG_StartQuest(self.questID)	
	end
end)

local LFGListFrameSearchPanelBackButtonSavedSize,LFGListFrameSearchPanelSignUpButtonSavedSize
C_Timer.After(1,function()
	LFGListFrameSearchPanelBackButtonSavedSize,LFGListFrameSearchPanelSignUpButtonSavedSize = LFGListFrame.SearchPanel.BackButton:GetWidth(),LFGListFrame.SearchPanel.SignUpButton:GetWidth()
end)

LFGListFrameSearchPanelStartGroup:SetScript("OnShow",function(self)
	LFGListFrame.SearchPanel.BackButton:SetWidth(110)
	LFGListFrame.SearchPanel.SignUpButton:SetWidth(110)
	if not self.isSkinned then
		self.isSkinned = true
		if ElvUI and ElvUI[1] and ElvUI[1].GetModule then
			local S = ElvUI[1]:GetModule('Skins')
			if S then
				S:HandleButton(self, true)
			end
		end
	end
end)
LFGListFrameSearchPanelStartGroup:SetScript("OnHide",function()
	LFGListFrame.SearchPanel.BackButton:SetWidth(LFGListFrameSearchPanelBackButtonSavedSize or 135)
	LFGListFrame.SearchPanel.SignUpButton:SetWidth(LFGListFrameSearchPanelSignUpButtonSavedSize or 135)
end)

local LFGListFrameSearchPanelShowerFrame = CreateFrame("Frame",nil,LFGListFrame.SearchPanel)
LFGListFrameSearchPanelShowerFrame:SetPoint("TOPLEFT")
LFGListFrameSearchPanelShowerFrame:SetSize(1,1)
LFGListFrameSearchPanelShowerFrame:SetScript("OnShow",function()
	LFGListFrameSearchPanelStartGroup:Hide()
end)
LFGListFrameSearchPanelShowerFrame:SetScript("OnHide",function()
	LFGListFrameSearchPanelStartGroup:Hide()
end)


local LFGListFrameSearchPanelTryWithQuestID = CreateFrame("Button",nil,LFGListFrame.EntryCreation,"UIPanelButtonTemplate")
LFGListFrameSearchPanelTryWithQuestID:SetPoint("LEFT",LFGListFrame.EntryCreation.CancelButton,"RIGHT")
LFGListFrameSearchPanelTryWithQuestID:SetPoint("RIGHT",LFGListFrame.EntryCreation.ListGroupButton,"LEFT")
LFGListFrameSearchPanelTryWithQuestID:SetHeight(22)
LFGListFrameSearchPanelTryWithQuestID:SetText(LOCALE.tryWithQuestID)
LFGListFrameSearchPanelTryWithQuestID:SetScript("OnClick",function(self)
	if self.questID then
		WorldQuestList.LFG_Search(self.questID)	
	end
end)

local LFGListFrameEntryCreationCancelButtonSavedSize,LFGListFrameEntryCreationListGroupButtonSavedSize
C_Timer.After(1,function()
	LFGListFrameEntryCreationCancelButtonSavedSize,LFGListFrameEntryCreationListGroupButtonSavedSize = LFGListFrame.EntryCreation.CancelButton:GetWidth(),LFGListFrame.EntryCreation.ListGroupButton:GetWidth()
end)

LFGListFrameSearchPanelTryWithQuestID:SetScript("OnShow",function(self)
	LFGListFrame.EntryCreation.CancelButton:SetWidth(110)
	LFGListFrame.EntryCreation.ListGroupButton:SetWidth(110)
	if not self.isSkinned then
		self.isSkinned = true
		if ElvUI and ElvUI[1] and ElvUI[1].GetModule then
			local S = ElvUI[1]:GetModule('Skins')
			if S then
				S:HandleButton(self, true)
			end
		end
	end
end)
LFGListFrameSearchPanelTryWithQuestID:SetScript("OnHide",function()
	LFGListFrame.EntryCreation.CancelButton:SetWidth(LFGListFrameEntryCreationCancelButtonSavedSize or 135)
	LFGListFrame.EntryCreation.ListGroupButton:SetWidth(LFGListFrameEntryCreationListGroupButtonSavedSize or 135)
end)

local LFGListFrameEntryCreationShowerFrame = CreateFrame("Frame",nil,LFGListFrame.EntryCreation)
LFGListFrameEntryCreationShowerFrame:SetPoint("TOPLEFT")
LFGListFrameEntryCreationShowerFrame:SetSize(1,1)
LFGListFrameEntryCreationShowerFrame:SetScript("OnShow",function()
	LFGListFrameSearchPanelTryWithQuestID:Hide()
end)
LFGListFrameEntryCreationShowerFrame:SetScript("OnHide",function()
	LFGListFrameSearchPanelTryWithQuestID:Hide()
end)


QuestCreationBox:RegisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED")
QuestCreationBox:RegisterEvent("LFG_LIST_APPLICANT_LIST_UPDATED")
QuestCreationBox:RegisterEvent("PARTY_INVITE_REQUEST")
QuestCreationBox:RegisterEvent("QUEST_TURNED_IN")
QuestCreationBox:RegisterEvent("QUEST_ACCEPTED")
QuestCreationBox:RegisterEvent("QUEST_REMOVED")
QuestCreationBox:RegisterEvent("PARTY_LEADER_CHANGED")
QuestCreationBox:RegisterEvent("GROUP_ROSTER_UPDATE")
QuestCreationBox:SetScript("OnEvent",function (self,event,arg1,arg2)
	if event == "LFG_LIST_SEARCH_RESULTS_RECEIVED" then
		if LFGListFrameSearchPanelStartGroup:IsShown() then
			LFGListFrameSearchPanelStartGroup:Hide()
		end
		local total,results = C_LFGList.GetSearchResults()
		if total == 0 and searchQuestID and (VWQL and not VWQL.DisableLFG) then
			isAfterSearch = true
		else
			isAfterSearch = nil
			searchQuestID = nil
		end
		
		if LFGListFrame.SearchPanel.SearchBox:IsVisible() and LFGListFrame.SearchPanel.categoryID == 1 then
			local searchQ = LFGListFrame.SearchPanel.SearchBox:GetText()
			searchQ = tonumber(searchQ)
			if searchQ and searchQ > 10000 and searchQ < 1000000 then
				LFGListFrameSearchPanelStartGroup.questID = searchQ
				LFGListFrameSearchPanelStartGroup:Show()
			end
		end
		
		autoCreateQuestID = nil
		if LFGListFrame.EntryCreation.autoCreateActivityType == "quest" and LFGListFrame.SearchPanel.categoryID == 1 then
			local questID = LFGListFrame.EntryCreation.autoCreateContextID
			if type(questID) == 'number' and questID > 10000 and questID < 1000000 then
				local name = C_TaskQuest.GetQuestInfoByQuestID(questID)
				if name == LFGListFrame.SearchPanel.SearchBox:GetText() then
					autoCreateQuestID = questID
				end
			end
		end
	elseif event == "LFG_LIST_APPLICANT_LIST_UPDATED" then
		if not VWQL or VWQL.DisableLFG or not UnitIsGroupLeader("player", LE_PARTY_CATEGORY_HOME) then
			return
		end
		local active, activityID, ilvl, honorLevel, name, comment, voiceChat, duration, autoAccept, privateGroup, lfg_questID = C_LFGList.GetActiveEntryInfo()
		if IsTeoreticalWQ(name) then
			StaticPopup_Hide("LFG_LIST_AUTO_ACCEPT_CONVERT_TO_RAID")
			
			if not autoAccept and
				(  GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) + C_LFGList.GetNumInvitedApplicantMembers() + C_LFGList.GetNumPendingApplicantMembers() <= 5  )
			then
				local applicants = C_LFGList.GetApplicants()
				for _,applicantID in pairs(applicants) do
					local id, status, pendingStatus, numMembers, isNew = C_LFGList.GetApplicantInfo(applicantID)
					if status == "applied" and numMembers == 1 then
						for memberIdx=1,numMembers do
							local name, class, localizedClass, level, itemLevel, honorLevel, tank, healer, damage, assignedRole = C_LFGList.GetApplicantMemberInfo(applicantID, memberIdx)
							if name then
								InviteUnit(name)
							end
						end
					end
				end
			end
		end	
	elseif event == "PARTY_LEADER_CHANGED" then
		if not VWQL or VWQL.DisableLFG or not UnitIsGroupLeader("player", LE_PARTY_CATEGORY_HOME) or not C_LFGList.GetActiveEntryInfo() then
			return
		end
		self:GetScript("OnEvent")(self,"LFG_LIST_APPLICANT_LIST_UPDATED")
	elseif event == "PARTY_INVITE_REQUEST" then
		local name = arg1
		if name then
			local app = C_LFGList.GetApplications()
			for _,id in pairs(app) do
				local _, _, _, _, _, _, _, _, _, _, _, _, groupLeader = C_LFGList.GetSearchResultInfo(id)
				if name == groupLeader then
					AcceptGroup()
					StaticPopupSpecial_Hide(LFGInvitePopup)
					for i = 1, 4 do
						local frame = _G["StaticPopup"..i]
						if frame:IsVisible() and frame.which=="PARTY_INVITE" then
							frame.inviteAccepted = true
							StaticPopup_Hide("PARTY_INVITE")
							return
						elseif frame:IsVisible() and frame.which=="PARTY_INVITE_XREALM" then
							frame.inviteAccepted = true
							StaticPopup_Hide("PARTY_INVITE_XREALM")
							return
						end
					end
				end
			end
		end		
	elseif event == "QUEST_TURNED_IN" then
		if not VWQL or VWQL.DisableLFG or not arg1 or VWQL.DisableLFG_PopupLeave then
			return
		end
		if (C_LFGList.GetActiveEntryInfo() or LFGListFrame.SearchPanel.SearchBox:GetText()==tostring(arg1)) and QuestUtils_IsQuestWorldQuest(arg1) and CheckQuestPassPopup(arg1) and (not QuestCreationBox:IsVisible() or (QuestCreationBox.type ~= 1 and QuestCreationBox.type ~= 4) or (QuestCreationBox.type == 1 and QuestCreationBox.questID == arg1) or (QuestCreationBox.type == 4 and QuestCreationBox.questID == arg1)) then
			local _, activityID = C_LFGList.GetActiveEntryInfo()
			if activityID then
				local _, _, categoryID = C_LFGList.GetActivityInfo(activityID)
				if categoryID ~= 1 then
					return
				end
			end
			
			QuestCreationBox.Text1:SetText("WQL")
			QuestCreationBox.Text2:SetText("")
			QuestCreationBox.PartyLeave:Show()

			QuestCreationBox.PartyFind:Hide()
			QuestCreationBox.ListGroup:Hide()
			QuestCreationBox.FindGroup:Hide()
			
			QuestCreationBox.type = 2
			
			QuestCreationBox:Show()
			QuestCreationBox:SetSize(350,60)
		end
	elseif event == "QUEST_ACCEPTED" then
		if WorldQuestList.ObjectiveTracker_Update_hook then
			WorldQuestList.ObjectiveTracker_Update_hook(2)
		end
		if not VWQL or VWQL.DisableLFG or not arg2 or C_LFGList.GetActiveEntryInfo() or VWQL.DisableLFG_Popup or (GetNumGroupMembers() or 0) > 1 then
			return
		end
		if QuestUtils_IsQuestWorldQuest(arg2) and 					--is WQ
			(not QuestCreationBox:IsVisible() or (QuestCreationBox.type ~= 1 and QuestCreationBox.type ~= 4)) and	--popup if not busy
			 CheckQuestPassPopup(arg2) 						--wq pass filters
		 then
			QuestCreationBox.Text1:SetText("WQL|n"..(C_TaskQuest.GetQuestInfoByQuestID(arg2) or ""))
			QuestCreationBox.Text2:SetText("")
			QuestCreationBox.PartyFind.questID = arg2
			QuestCreationBox.PartyFind:Show()

			QuestCreationBox.PartyLeave:Hide()
			QuestCreationBox.ListGroup:Hide()
			QuestCreationBox.FindGroup:Hide()

			QuestCreationBox.questID = arg2
			QuestCreationBox.type = 3

			QuestCreationBox:Show()
			QuestCreationBox:SetSize(350,60)
		end		
	elseif event == "QUEST_REMOVED" then
		if WorldQuestList.ObjectiveTracker_Update_hook then
			WorldQuestList.ObjectiveTracker_Update_hook(2)
		end
		if QuestCreationBox:IsVisible() and QuestCreationBox.type == 3 and QuestCreationBox.questID == arg1 then
			QuestCreationBox:Hide()
		end
	elseif event == "GROUP_ROSTER_UPDATE" then
		if GetNumGroupMembers() == 0 and QuestCreationBox:IsVisible() and QuestCreationBox.type == 2 and not C_LFGList.GetActiveEntryInfo() then
			QuestCreationBox:Hide()
		end
	end
end)

LFGListSearchPanelScrollFrame.StartGroupButton:HookScript("OnClick",function()
	if isAfterSearch then
		PVEFrame_ToggleFrame()
		WQL_LFG_StartQuest(searchQuestID)
	elseif autoCreateQuestID then
		C_Timer.After(.5,function()
			if not C_LFGList.GetActiveEntryInfo() and GroupFinderFrame:IsVisible() and LFGListFrame.EntryCreation:IsVisible() then
				if autoCreateQuestID then
					LFGListFrameSearchPanelTryWithQuestID.questID = autoCreateQuestID
					LFGListFrameSearchPanelTryWithQuestID:Show()
				end
				autoCreateQuestID = nil
			end
		end)
	end
	isAfterSearch = nil
	searchQuestID = nil
end)
LFGListSearchPanelScrollFrame.StartGroupButton:HookScript("OnHide",function()
	if isAfterSearch then
		C_Timer.After(0.1,function()
			isAfterSearch = nil
			searchQuestID = nil
		end)
	end
end)

local objectiveTrackerButtons = {}
WorldQuestList.LFG_objectiveTrackerButtons = objectiveTrackerButtons
local objectiveTrackerMainFrame = CreateFrame("Frame",nil,UIParent)
objectiveTrackerMainFrame:SetPoint("TOPRIGHT")
objectiveTrackerMainFrame:SetSize(1,1)

local function objectiveTrackerButtons_OnClick(self,button)
	if C_LFGList.GetActiveEntryInfo() and tostring(self.questID) == LFGListFrame.EntryCreation.Name:GetText() then
		return
	elseif tostring(self.questID) == LFGListFrame.EntryCreation.Name:GetText() then
		WorldQuestList.LFG_StartQuest(self.questID)
		return
	end
	if C_LFGList.GetActiveEntryInfo() or ((GetNumGroupMembers() or 0) > 1 and not UnitIsGroupLeader("player")) then
		StaticPopupDialogs["WQL_LFG_LEAVE"] = {
			text = PARTY_LEAVE,
			button1 = YES,
			button2 = NO,
			OnAccept = function()
				LeaveParty()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3,
		}
		StaticPopup_Show("WQL_LFG_LEAVE")
		return
	end
	if button == "RightButton" then
		WorldQuestList.LFG_StartQuest(self.questID)
	else
		WorldQuestList.LFG_Search(self.questID)
	end
end

local function objectiveTrackerButtons_OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:AddLine("WQL: "..LOOK_FOR_GROUP)
	GameTooltip:AddLine(LOCALE.lfgLeftButtonClick,1,1,1)
	GameTooltip:AddLine(LOCALE.lfgLeftButtonClick2,1,1,1)	
	GameTooltip:AddLine(LOCALE.lfgRightButtonClick,1,1,1)
	GameTooltip:Show()	
end
local function objectiveTrackerButtons_OnLeave(self)
	GameTooltip_Hide()
end
local function objectiveTrackerButtons_OnUpdate(self)
	if not self.parent:IsVisible() then
		self:Hide()
	end
end

local function ObjectiveTracker_Update_hook(reason, questID)
	for _,b in pairs(objectiveTrackerButtons) do
		if b:IsShown() and ((b.questID ~= b.parent.id or not VWQL or VWQL.DisableLFG or VWQL.DisableLFG_EyeRight) or (b.parent.hasGroupFinderButton)) then
			b:Hide()
		end
	end
	if not VWQL or VWQL.DisableLFG or VWQL.DisableLFG_EyeRight then
		return
	end
	if reason and reason ~= 1 then
		if not ObjectiveTrackerFrame or not ObjectiveTrackerFrame.MODULES then
			return
		end
		local createdID = LFGListFrame.EntryCreation.Name:GetText()
		for _,module in pairs(ObjectiveTrackerFrame.MODULES) do
			if module.usedBlocks then
				for _,block in pairs(module.usedBlocks) do
					local questID = block.id
					if questID and QuestUtils_IsQuestWorldQuest(questID) and not block.hasGroupFinderButton and not WorldQuestList:IsQuestDisabledForLFG(questID) then
						local b = objectiveTrackerButtons[block]
						if not b then
							b = CreateFrame("Button",nil,objectiveTrackerMainFrame)
							objectiveTrackerButtons[block] = b
							b.parent = block
							b:SetSize(26,26)
							b:SetPoint("TOPLEFT",block,"TOPRIGHT",-18,0)
							b:SetScript("OnClick",objectiveTrackerButtons_OnClick)
							b:SetScript("OnEnter",objectiveTrackerButtons_OnEnter)
							b:SetScript("OnLeave",objectiveTrackerButtons_OnLeave)
							b:SetScript("OnUpdate",objectiveTrackerButtons_OnUpdate)
							b:RegisterForClicks("LeftButtonDown","RightButtonUp")
							
							b.HighlightTexture = b:CreateTexture()
							b.HighlightTexture:SetTexture("Interface\\Buttons\\UI-Common-MouseHilight")
							b.HighlightTexture:SetSize(26,26)
							b.HighlightTexture:SetPoint("CENTER")
							b:SetHighlightTexture(b.HighlightTexture,"ADD")
							
							b.texture = b:CreateTexture(nil, "BACKGROUND")
							b.texture:SetPoint("CENTER")
							b.texture:SetSize(26,26)
							b.texture:SetAtlas("hud-microbutton-LFG-Up")

							b.texture2 = b:CreateTexture(nil, "ARTWORK")
							b.texture2:SetPoint("CENTER")
							b.texture2:SetSize(14,14)
						end
						if block.itemButton and block.itemButton:IsVisible() and not b.icon_pos then
							b:SetPoint("TOPLEFT",block,"TOPRIGHT",-44,0)
							b.icon_pos = true
						elseif (not block.itemButton or not block.itemButton:IsVisible()) and b.icon_pos then
							b:SetPoint("TOPLEFT",block,"TOPRIGHT",-18,0)
							b.icon_pos = false
						end
						b:SetFrameStrata(block:GetFrameStrata())
						b:SetFrameLevel(block:GetFrameLevel()+1)
						b.questID = questID
						b:Show()
						if createdID == tostring(questID) then
							if C_LFGList.GetActiveEntryInfo() or (GetNumGroupMembers() >= 5) then
								b:Hide()
							end
							if not b.texture.refresh then
								b.texture:SetTexture("Interface\\Buttons\\UI-SquareButton-Up")
								b.texture2:SetTexture("Interface\\Buttons\\UI-RefreshButton")
								b.texture.refresh = true
							end
						else
							if b.texture.refresh then
								b.texture:SetAtlas("hud-microbutton-LFG-Up")
								b.texture2:SetTexture()
								b.texture.refresh = nil
							end
						end
					end
				end
			end
		end
	end
end

WorldQuestList.ObjectiveTracker_Update_hook = ObjectiveTracker_Update_hook
C_Timer.NewTicker(1,function()
	WorldQuestList.ObjectiveTracker_Update_hook(2)
end)


--Add Map Icons

do
	local CacheQuestItemReward = {}
	
	local SlotToIcon = {
		["INVTYPE_HEAD"]="transmog-nav-slot-head",
		["INVTYPE_NECK"]="Warlock-ReadyShard",
		["INVTYPE_SHOULDER"]="transmog-nav-slot-shoulder",
		["INVTYPE_CHEST"]="transmog-nav-slot-chest",
		["INVTYPE_WAIST"]="transmog-nav-slot-waist",
		["INVTYPE_LEGS"]="transmog-nav-slot-legs",
		["INVTYPE_FEET"]="transmog-nav-slot-feet",
		["INVTYPE_WRIST"]="transmog-nav-slot-wrist",
		["INVTYPE_HAND"]="transmog-nav-slot-hands", 
		["INVTYPE_FINGER"]="Warlock-ReadyShard", 
		["INVTYPE_TRINKET"]="Warlock-ReadyShard",
		["INVTYPE_CLOAK"]="transmog-nav-slot-back",
		
		["INVTYPE_WEAPON"]="transmog-nav-slot-mainhand",
		["INVTYPE_2HWEAPON"]="transmog-nav-slot-mainhand",
		["INVTYPE_RANGED"]="transmog-nav-slot-mainhand",
		["INVTYPE_RANGEDRIGHT"]="transmog-nav-slot-mainhand",
		["INVTYPE_WEAPONMAINHAND"]="transmog-nav-slot-mainhand", 
		["INVTYPE_SHIELD"]="transmog-nav-slot-secondaryhand",
		["INVTYPE_WEAPONOFFHAND"]="transmog-nav-slot-secondaryhand",
		
		[select(3,GetItemInfoInstant(141265))] = "Warlock-ReadyShard",
	}
	
	local function HookOnEnter(self)
		self.pinFrameLevelType = "PIN_FRAME_LEVEL_TOPMOST"
		self:ApplyFrameLevel()
	end
	local function HookOnLeave(self)
		self.pinFrameLevelType = "PIN_FRAME_LEVEL_WORLD_QUEST"
		self:ApplyFrameLevel()
	end
	
	local function CreateMapTextOverlay(mapFrame,pinName)
		local mapCanvas = mapFrame:GetCanvas()
		local textsFrame = CreateFrame("Frame",nil,mapCanvas)
		textsFrame:SetPoint("TOPLEFT")
		textsFrame:SetSize(1,1)
		textsFrame:SetFrameLevel(10000)
		local textsTable = {}
		
		textsTable.s = 1
	
		local prevScale = nil
		textsFrame:SetScript("OnUpdate",function(self)
			local nowScale = mapCanvas:GetScale()
			if nowScale ~= prevScale then
				local pins = mapFrame.pinPools[pinName]
				if pins then
					local scaleFactor,startScale,endScale
					for obj,_ in pairs(pins.activeObjects) do
						scaleFactor = obj.scaleFactor
						startScale = obj.startScale
						endScale = obj.endScale
						break
					end
					local scale
					if startScale and startScale and endScale then
						local parentScaleFactor = 1.0 / mapFrame:GetCanvasScale()
						scale = parentScaleFactor * Lerp(startScale, endScale, Saturate(scaleFactor * mapFrame:GetCanvasZoomPercent()))
					else
						scale = 1
					end
					if scale then
						scale = scale * mapFrame:GetGlobalPinScale()
						
						for i=1,#textsTable do
							textsTable[i]:SetScale(scale)
						end
					end
					textsTable.s = scale or 1
				end
			end
		end)
		
		textsTable.f = textsFrame
		textsTable.c = mapCanvas
		
		return textsTable
	end
	
	local WorldMapFrame_TextTable = CreateMapTextOverlay(WorldMapFrame,"WorldMap_WorldQuestPinTemplate")
	
	local UpdateFrameLevelFunc = function(self) 
		if self.obj then 
			local lvl = self.obj:GetFrameLevel()
			if self.frLvl ~= lvl then
				self:SetFrameLevel(lvl)
				self.frLvl = lvl
			end
		end 
	end
	
	local function AddText(table,obj,num,text)
		num = num + 1
		local t = table[num]
		if not t then
			t = CreateFrame("Frame",nil,table.c)
			t:SetSize(1,1)
			t.t = t:CreateFontString(nil,"OVERLAY","GameFontWhite")
			t.t:SetPoint("CENTER")
			t:SetScale(table.s)
			t:SetScript("OnUpdate",UpdateFrameLevelFunc)
			table[num] = t
		end
		t.obj = obj:GetParent()
		if VWQL.DisableRibbon and t.type ~= 2 then
			t.type = 2
			t.t:SetFont("Interface\\AddOns\\WorldQuestsList\\ariblk.ttf",18,"OUTLINE")
			t.t:SetTextColor(1,1,1,1)
		elseif not VWQL.DisableRibbon and t.type ~= 1 then
			t.type = 1
			t.t:SetFont("Interface\\AddOns\\WorldQuestsList\\ariblk.ttf",18)
			t.t:SetTextColor(.1,.1,.1,1)
		end		
		
		t:SetPoint("CENTER",obj,0,0)
		t.t:SetText(text)
		if not t:IsShown() then
			t:Show()
		end	
		return num
	end
	
	function WorldQuestList:WQIcons_AddIcons(frame,pinName)
		frame = frame or WorldMapFrame
		local pins = frame.pinPools[pinName or "WorldMap_WorldQuestPinTemplate"]
		if pins and VWQL and not VWQL.DisableRewardIcons then
			local isWorldMapFrame = frame == WorldMapFrame
			local isRibbonDisabled = isWorldMapFrame and GENERAL_MAPS[GetCurrentMapAreaID()] and not VWQL.EnableRibbonGeneralMaps
			local tCount = 0
			if isWorldMapFrame then
				if not WorldMapFrame_TextTable.f:IsShown() then
					WorldMapFrame_TextTable.f:Show()
				end
			end
			for obj,_ in pairs(pins.activeObjects) do
				local icon = obj.WQL_rewardIcon
				if obj.questID then
					if not icon then
						icon = obj:CreateTexture(nil,"ARTWORK")
						obj.WQL_rewardIcon = icon
						icon:SetPoint("CENTER",0,0)
						icon:SetSize(26,26)
						
						local iconWMask = obj:CreateTexture(nil,"ARTWORK")
						obj.WQL_rewardIconWMask = iconWMask
						iconWMask:SetPoint("CENTER",0,0)
						iconWMask:SetSize(26,26)
						iconWMask:SetMask("Interface\\CharacterFrame\\TempPortraitAlphaMask")
						
						local ribbon = obj:CreateTexture(nil,"BACKGROUND")
						obj.WQL_rewardRibbon = ribbon
						ribbon:SetPoint("TOP",obj,"BOTTOM",0,16)
						ribbon:SetSize(100,40)
						ribbon:SetAtlas("UI-Frame-Neutral-Ribbon")
						
						if not isWorldMapFrame then
							local ribbonText = obj:CreateFontString(nil,"BORDER","GameFontWhite")
							obj.WQL_rewardRibbonText = ribbonText
							local a1,a2 = ribbonText:GetFont()
							ribbonText:SetFont(a1,18)
							ribbonText:SetPoint("CENTER",ribbon,0,-1)
							ribbonText:SetTextColor(0,0,0,1)
						end
						
						local iconTopRight = obj:CreateTexture(nil,"OVERLAY")
						obj.WQL_iconTopRight = iconTopRight
						iconTopRight:SetPoint("TOPRIGHT",obj,"TOPRIGHT",0,0)
						iconTopRight:SetSize(20,20)
						
						obj:HookScript("OnEnter",HookOnEnter)
						obj:HookScript("OnLeave",HookOnLeave)
					end
					
					local tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex, displayTimeLeft = GetQuestTagInfo(obj.questID)
					
					local iconAtlas,iconTexture,iconVirtual = nil
					local ajustSize,ajustMask = 0
					local amount,amountIcon,amountColor = 0
					
					-- money
					local money = GetQuestLogRewardMoney(obj.questID)
					if money > 0 then
						iconAtlas = "Auctioneer"
						amount = floor(money / 10000 * (C_PvP.IsWarModeDesired() and C_QuestLog.QuestHasWarModeBonus(obj.questID) and 1.1 or 1))
					end
					
					-- currency
					for i = 1, GetNumQuestLogRewardCurrencies(obj.questID) do
						local name, texture, numItems, currencyID = GetQuestLogRewardCurrencyInfo(i, obj.questID)
						if currencyID == 1508 or currencyID == 1533 then	--Veiled Argunite, Wakening Essence
							iconTexture = texture
							ajustMask = true
							ajustSize = 8
							amount = floor(numItems * (C_PvP.IsWarModeDesired() and C_QuestLog.QuestHasWarModeBonus(obj.questID) and 1.1 or 1))
							break
						elseif currencyID == 1553 then	--azerite
							--iconAtlas = "Islands-AzeriteChest"
							iconAtlas = "AzeriteReady"
							amount = floor(numItems * (C_PvP.IsWarModeDesired() and C_QuestLog.QuestHasWarModeBonus(obj.questID) and 1.1 or 1))
							ajustSize = 5
							break
						elseif currencyID == 1220 or currencyID == 1560 then	--OR
							iconAtlas = "legionmission-icon-currency"
							ajustSize = 5
							amount = floor(numItems * (C_PvP.IsWarModeDesired() and C_QuestLog.QuestHasWarModeBonus(obj.questID) and 1.1 or 1))
							break
						elseif WorldQuestList:IsFactionCurrency(currencyID or 0) then
							iconAtlas = "poi-workorders"
							amount = numItems
							amountIcon = texture
							break
						end
					end
					
					-- item
					if GetNumQuestLogRewards(obj.questID) > 0 then
						local name,icon,numItems,quality,_,itemID = GetQuestLogRewardInfo(1,obj.questID)
						if itemID then
							local itemLevel = select(4,GetItemInfo(itemID))
							if itemLevel > 130 then
								iconAtlas = "Banker"
								amount = 0
								--iconAtlas = "ChallengeMode-icon-chest"
								
								local itemLink = CacheQuestItemReward[obj.questID]
								if not itemLink then
									inspectScantip:SetQuestLogItem("reward", 1, obj.questID)
									itemLink = select(2,inspectScantip:GetItem())
									inspectScantip:ClearLines()
									
									CacheQuestItemReward[obj.questID] = itemLink
								end
								if itemLink then
									itemLevel = select(4,GetItemInfo(itemLink))
									if itemLevel then
										amount = itemLevel
										if quality and quality > 1 then
											--local colorTable = BAG_ITEM_QUALITY_COLORS[quality]
											--amountColor = format("|cff%02x%02x%02x",colorTable.r * 255,colorTable.g * 255,colorTable.b * 255)
										end
									end
								end
								local itemSubType,inventorySlot = select(3,GetItemInfoInstant(itemID))
								if inventorySlot and SlotToIcon[inventorySlot] then
									iconAtlas = SlotToIcon[inventorySlot]
									ajustSize = iconAtlas == "Warlock-ReadyShard" and 0 or 10
								elseif itemSubType and SlotToIcon[itemSubType] then
									iconAtlas = SlotToIcon[itemSubType]
									ajustSize = iconAtlas == "Warlock-ReadyShard" and 0 or 10								
								end
							end
							if itemID == 124124 or itemID == 151568 then
								iconTexture = icon
								ajustMask = true
								ajustSize = 4
								if numItems then
									amount = numItems
								end
							elseif itemID == 152960 or itemID == 152957 then
								iconAtlas = "poi-workorders"
							elseif itemID == 163857 or itemID == 143559 or itemID == 141920 then
								iconTexture = icon
								ajustMask = true
								ajustSize = 4
							end
							if worldQuestType == LE.LE_QUEST_TAG_TYPE_PET_BATTLE then
								iconVirtual = true
								amountIcon = icon
								amount = numItems
							elseif worldQuestType == LE.LE_QUEST_TAG_TYPE_DUNGEON or worldQuestType == LE.LE_QUEST_TAG_TYPE_RAID then
								iconVirtual = true
								amountIcon = icon
								amount = itemLevel or numItems								
							end
						end
					end
					
					if worldQuestType == LE.LE_QUEST_TAG_TYPE_DUNGEON then
						iconAtlas,iconTexture = nil
					elseif worldQuestType == LE.LE_QUEST_TAG_TYPE_RAID then
						iconAtlas,iconTexture = nil
					end
					
					if worldQuestType == LE.LE_QUEST_TAG_TYPE_PVP then
						if obj.WQL_iconTopRight.curr ~= "worldquest-icon-pvp-ffa" then
							obj.WQL_iconTopRight:SetAtlas("worldquest-icon-pvp-ffa")
							obj.WQL_iconTopRight.curr = "worldquest-icon-pvp-ffa"
						end
					elseif worldQuestType == LE.LE_QUEST_TAG_TYPE_PET_BATTLE and (iconTexture or iconAtlas) then
						if obj.WQL_iconTopRight.curr ~= "worldquest-icon-petbattle" then
							obj.WQL_iconTopRight:SetAtlas("worldquest-icon-petbattle")
							obj.WQL_iconTopRight.curr = "worldquest-icon-petbattle"
						end
					elseif worldQuestType == LE.LE_QUEST_TAG_TYPE_PROFESSION then
						if obj.WQL_iconTopRight.curr ~= "worldquest-icon-engineering" then
							obj.WQL_iconTopRight:SetAtlas("worldquest-icon-engineering")
							obj.WQL_iconTopRight.curr = "worldquest-icon-engineering"
						end
					elseif worldQuestType == LE.LE_QUEST_TAG_TYPE_INVASION then
						if obj.WQL_iconTopRight.curr ~= "worldquest-icon-burninglegion" then
							obj.WQL_iconTopRight:SetAtlas("worldquest-icon-burninglegion")
							obj.WQL_iconTopRight.curr = "worldquest-icon-burninglegion"
						end
					else
						if obj.WQL_iconTopRight.curr then
							obj.WQL_iconTopRight:SetTexture()
							obj.WQL_iconTopRight.curr = nil
						end						
					end
										
					if iconTexture or iconAtlas or iconVirtual then
						if not iconVirtual then
							icon:SetSize(26+ajustSize,26+ajustSize)
							obj.WQL_rewardIconWMask:SetSize(26+ajustSize,26+ajustSize)
							if iconTexture then
								if ajustMask then
									if obj.WQL_rewardIconWMask.curr ~= iconTexture then
										obj.WQL_rewardIconWMask:SetTexture(iconTexture)
										obj.WQL_rewardIconWMask.curr = iconTexture
									end
									if icon.curr then
										icon:SetTexture()
										icon.curr = nil
									end
								else
									if obj.WQL_rewardIconWMask.curr then
										obj.WQL_rewardIconWMask:SetTexture()
										obj.WQL_rewardIconWMask.curr = nil
									end
									if icon.curr ~= iconTexture then
										icon:SetTexture(iconTexture)
										icon.curr = iconTexture
									end
								end
							else
								if obj.WQL_rewardIconWMask.curr then
									obj.WQL_rewardIconWMask:SetTexture()
									obj.WQL_rewardIconWMask.curr = nil
								end
								if icon.curr ~= iconAtlas then
									icon:SetAtlas(iconAtlas)
									icon.curr = iconAtlas
								end
							end
							obj.Texture:SetTexture()
						end
						
						if amount > 0 and not isRibbonDisabled then
							if not obj.WQL_rewardRibbon:IsShown() then
								obj.WQL_rewardRibbon:Show()
							end
							if VWQL.DisableRibbon and obj.WQL_rewardRibbon.type ~= 2 then
								obj.WQL_rewardRibbon.type = 2
								if not isWorldMapFrame then
									obj.WQL_rewardRibbonText:SetFont("Interface\\AddOns\\WorldQuestsList\\ariblk.ttf",18,"OUTLINE")
									obj.WQL_rewardRibbonText:SetTextColor(1,1,1,1)
								end
								obj.WQL_rewardRibbon:SetAlpha(0)
							elseif not VWQL.DisableRibbon and obj.WQL_rewardRibbon.type ~= 1 then
								obj.WQL_rewardRibbon.type = 1
								if not isWorldMapFrame then
									obj.WQL_rewardRibbonText:SetFont("Interface\\AddOns\\WorldQuestsList\\ariblk.ttf",18)
									obj.WQL_rewardRibbonText:SetTextColor(.1,.1,.1,1)
								end
								obj.WQL_rewardRibbon:SetAlpha(1)
							end
							if not isWorldMapFrame then
								obj.WQL_rewardRibbonText:SetText((amountIcon and "|T"..amountIcon..":0|t" or "")..(amountColor or "")..amount)
							end
							obj.WQL_rewardRibbon:SetWidth( (#tostring(amount) + (amountIcon and 1.5 or 0)) * 16 + 40 )
							
							obj.TimeLowFrame:SetPoint("CENTER",-22,-8)
							
							if isWorldMapFrame then
								tCount = AddText(WorldMapFrame_TextTable,obj.WQL_rewardRibbon,tCount,(amountIcon and "|T"..amountIcon..":0|t" or "")..(amountColor or "")..amount)							
							end
						elseif obj.WQL_rewardRibbon:IsShown() then
							obj.WQL_rewardRibbon:Hide()
							if not isWorldMapFrame then
								obj.WQL_rewardRibbonText:SetText("")
							end
							obj.TimeLowFrame:SetPoint("CENTER",-17,-17)				
						end				
					else
						if obj.WQL_rewardIconWMask.curr then
							obj.WQL_rewardIconWMask:SetTexture()
							obj.WQL_rewardIconWMask.curr = nil
						end
						if icon.curr then
							icon:SetTexture()
							icon.curr = nil
						end
						if obj.WQL_rewardRibbon:IsShown() then
							obj.WQL_rewardRibbon:Hide()
							if not isWorldMapFrame then
								obj.WQL_rewardRibbonText:SetText("")
							end
							obj.TimeLowFrame:SetPoint("CENTER",-17,-17)
						end
					end
					obj.WQL_questID = obj.questID
				end
			end
			if isWorldMapFrame then
				for i=tCount+1,#WorldMapFrame_TextTable do
					WorldMapFrame_TextTable[i]:Hide()
				end
			end
			
			for _,obj in pairs(pins.inactiveObjects) do
				if obj.WQL_rewardIcon then
					if obj.WQL_rewardIconWMask.curr then
						obj.WQL_rewardIconWMask:SetTexture()
						obj.WQL_rewardIconWMask.curr = nil
					end
					if obj.WQL_rewardIcon.curr then
						obj.WQL_rewardIcon:SetTexture()
						obj.WQL_rewardIcon.curr = nil
					end
					if obj.WQL_iconTopRight.curr then
						obj.WQL_iconTopRight:SetTexture()
						obj.WQL_iconTopRight.curr = nil
					end
					obj.WQL_rewardRibbon:Hide()
					if not isWorldMapFrame then
						obj.WQL_rewardRibbonText:SetText("")
					end
					obj.TimeLowFrame:SetPoint("CENTER",-17,-17)
				end
				obj.WQL_questID = nil
			end
		elseif frame == WorldMapFrame then
			for i=1,#WorldMapFrame_TextTable do
				WorldMapFrame_TextTable[i]:Hide()
			end
		end
	end
	
	function WorldQuestList:WQIcons_RemoveIcons()
		for _,frames in pairs({{WorldMapFrame,"WorldMap_WorldQuestPinTemplate"},{FlightMapFrame,"FlightMap_WorldQuestPinTemplate"}}) do
			local frame = frames[1]
			if frame then
				local pins = frame.pinPools[ frames[2] ]
				if pins then
					for i,pinsPool in pairs({pins.activeObjects,pins.inactiveObjects}) do
						for k,v in pairs(pinsPool) do
							local obj = i == 1 and k or v
							if obj.WQL_rewardIcon then
								obj.WQL_rewardIconWMask:SetTexture()
								obj.WQL_rewardIconWMask.curr = nil
								obj.WQL_rewardIcon:SetTexture()
								obj.WQL_rewardIcon.curr = nil
								obj.WQL_iconTopRight:SetTexture()
								obj.WQL_iconTopRight.curr = nil
								obj.WQL_rewardRibbon:Hide()
								if obj.WQL_rewardRibbonText then
									obj.WQL_rewardRibbonText:SetText("")
								end
								obj.TimeLowFrame:SetPoint("CENTER",-17,-17)
							end
						end
					end
					frame:RefreshAllDataProviders()
				end
			end
		end
		for i=1,#WorldMapFrame_TextTable do
			WorldMapFrame_TextTable[i]:Hide()
		end
	end
	
end

WorldMapFrame:RegisterCallback("WorldQuestsUpdate", function()
	WorldQuestList:WQIcons_AddIcons()
end)

local WQIcons_FlightMapLoad = CreateFrame("Frame")
WQIcons_FlightMapLoad:RegisterEvent("ADDON_LOADED")
WQIcons_FlightMapLoad:SetScript("OnEvent",function (self, event, arg)
	if arg == "Blizzard_FlightMap" then
		self:UnregisterAllEvents()
		FlightMapFrame:RegisterCallback("WorldQuestsUpdate", function()
			WorldQuestList:WQIcons_AddIcons(FlightMapFrame,"FlightMap_WorldQuestPinTemplate")
		end)
	end
end)


--- Icons size on map

local defScaleFactor, defStartScale, defEndScale = 1, 0.425, 0.425
if WorldMap_WorldQuestPinMixin then
	local f = CreateFrame("Frame")
	f.SetScalingLimits = function(_,scaleFactor, startScale, endScale) 
		defScaleFactor = scaleFactor or defScaleFactor
		defStartScale = startScale or defStartScale
		defEndScale = endScale or defEndScale
	end
	pcall(function() WorldMap_WorldQuestPinMixin.OnLoad(f) end)
end

function WorldQuestList:WQIcons_RemoveScale()
	local pins = WorldMapFrame.pinPools["WorldMap_WorldQuestPinTemplate"]
	if pins then
		for obj,_ in pairs(pins.activeObjects) do
			pcall(function() 
				obj:SetScalingLimits(defScaleFactor, defStartScale, defEndScale)
				obj:ApplyCurrentScale()
			end)
		end
		for _,obj in pairs(pins.inactiveObjects) do
			pcall(function() 
				obj:SetScalingLimits(defScaleFactor, defStartScale, defEndScale)
				obj:ApplyCurrentScale()
			end)
		end
	end
end

function WorldQuestList:WQIcons_UpdateScale()
	local pins = WorldMapFrame.pinPools["WorldMap_WorldQuestPinTemplate"]
	if pins and VWQL and not VWQL.DisableWQScale_Hidden then
		local startScale, endScale = defStartScale, defEndScale
		local generalMap = GENERAL_MAPS[GetCurrentMapAreaID()]
		local scaleFactor = (VWQL.MapIconsScale or 1)
		if not generalMap then
			startScale, endScale = defStartScale, defEndScale
		elseif generalMap == 2 then
			startScale, endScale = 0.15, 0.2
			scaleFactor = scaleFactor * (WorldMapFrame:IsMaximized() and 1.25 or 1)
		elseif generalMap == 4 then
			startScale, endScale = 0.3, 0.425
			scaleFactor = scaleFactor * (WorldMapFrame:IsMaximized() and 1.25 or 1)
		else
			startScale, endScale = 0.35, 0.425
			scaleFactor = scaleFactor * (WorldMapFrame:IsMaximized() and 1.25 or 1)
		end
		startScale, endScale = startScale * scaleFactor, endScale * scaleFactor
	
		for obj,_ in pairs(pins.activeObjects) do
			--scaleFactor, startScale, endScale
			if obj.startScale ~= startScale or obj.endScale ~= endScale then
				obj:SetScalingLimits(1, startScale, endScale)
				obj:ApplyCurrentScale()
			end
		end
	end
end

WorldMapFrame:RegisterCallback("WorldQuestsUpdate", function()
	WorldQuestList:WQIcons_UpdateScale()
end)
