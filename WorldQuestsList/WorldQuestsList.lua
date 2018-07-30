local VERSION = 68

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
]]

local GlobalAddonName, WQLdb = ...

do
	local version, buildVersion, buildDate, uiVersion = GetBuildInfo()
	
	local expansion,majorPatch,minorPatch = (version or "1.0.0"):match("^(%d+)%.(%d+)%.(%d+)")
	
	if ((expansion or 0) * 10000 + (majorPatch or 0) * 100 + (minorPatch or 0)) < 80000 then
		return
	end
end

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
	        disableBountyIcon = "Deaktiviert die Abgesandtensymbole für Fraktionsnamen",
	        arrow = "Pfeil",
	        invasionPoints = "Invasions-Punkte",
	        argusMap = "Aktiviert Argus Karte",
	        ignoreList = "Ignorier-Liste",
	        addQuestsOpposite = "Fügt Quests vom anderen Kontinent hinzu",
	        hideLegion = "Verbergt Quests von Legion",
	        disableArrowMove = "Deaktiviert das Bewegen",
	        shellGameHelper = "Aktiviert Schalen-Spiel Helfer",
	        iconsOnMinimap = "Aktiviert die Symbole auf allgemeinen Karten",
	        addQuestsArgus = "Fügt Quests von Argus hinzu",
	        lfgSearchOption = "Aktiviert die LFG-Suche",
	        lfgAutoinvite = "Aktiviert die automatische Einladungsoption",
	        lfgTypeText = "Gib die zu bearbeitenden Nummern (QuestID) ein ",
	        lfgLeftButtonClick = "Linksklick - Gruppe finden",
	        lfgLeftButtonClick2 = "Linksklick + Shift - Gruppe finden nach Namen",
	        lfgRightButtonClick = "Rechtsklick - Gruppe erstellen",
	        lfgDisablePopup = "Deaktiviert Popup im Questbereich",
	        lfgDisableRightClickIcons = "Deaktiviert die rechte Maustaste auf Kartensymbolen",
	        disableRewardIcons = "Aktiviert die Belohnungssymbole auf Karten",
		mapIconsScale = "Map icons scale",
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
	} or
	(locale == "zhCN" or locale == "zhTW") and {	--by dxlmike, cuihuanyu1986
		gear = "装备",
		gold = "金币合计",
		blood = "萨格拉斯之血",
		knowledgeTooltip = "** 可在达到下一个神器知识等级后完成",
		disableArrow = "不使用ExRT箭头指示",
		anchor = "列表显示位置",
		totalap = "神器能量: ",
		totalapdisable = '不显示奖励合计',
		timeToComplete = "将在此时间后完成: ",
		bountyIgnoreFilter = "赏金任务",
		enigmaHelper = "启用'破解秘密'助手",
		barrelsHelper = "启用'欢乐桶'助手",
		honorIgnoreFilter = "PvP任务",
		ignoreFilter = "总是显示以下类型任务",
		epicIgnoreFilter = '精英（金龙）任务',
		wantedIgnoreFilter = "通缉任务",
		apFormatSetup = "神器能量数字格式",
		headerEnable = "显示列表表头",
		disabeHighlightNewQuests = "禁用新任务高亮",
		distance = "距离",
		disableBountyIcon = "大使任务不在列表中显示派系图标",
		arrow = "箭头",
		invasionPoints = "入侵点",
		argusMap = "启用阿古斯地图",
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
	if VWQL.DisableArrow then
		return
	end
	WQLdb.Arrow:ShowRunTo(x,y,hideRange or 40,nil,true)
end

local WorldQuestList

local WorldQuestList_Width = 300+6+4 --163ui 450+70
local WorldQuestList_ZoneWidth = 75
local TOTAL_WIDTH = WorldQuestList_Width + WorldQuestList_ZoneWidth

--local WorldMapFrame = TestWorldMapFrame
local WorldMapButton = WorldMapFrame.ScrollContainer.Child

WorldQuestList = CreateFrame("Frame","WorldQuestsListFrame",WorldMapFrame)
WorldQuestList:SetPoint("TOPLEFT",WorldMapFrame,"TOPRIGHT",10,-4)
WorldQuestList:SetSize(550,300)

_G.WorldQuestList = WorldQuestList

WorldQuestList:SetScript("OnHide",function(self)
	WorldQuestList.IsSoloRun = false
	WorldQuestList.moveHeader:Hide()
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
	WorldQuestList:Show()
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
WorldQuestList:SetScript("OnEvent",function(self,event,...)
	if event == 'ADDON_LOADED' then
		self:UnregisterEvent('ADDON_LOADED')

		if type(_G.VWQL)~='table' then
			_G.VWQL = {
				VERSION = VERSION,
				Scale = 0.8,
				DisableIconsGeneralMap947 = true,
				AzeriteFormat = 20,
			}
		end
		VWQL = _G.VWQL
		
		if not VWQL.VERSION then
			VWQL.VERSION = VERSION
			for q,w in pairs(VWQL) do
				if type(w)=='table' and w.Filter then
					--Blood of Sargeras Fix
					w.Filter = bit.bor(w.Filter,filters[4][2])
				end
			end
		end
		
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
			VWQL.DisableRewardIcons = true
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
			
			if (VWQL and not VWQL.DisableLFG and not VWQL.DisableLFG_RightClickIcon) and button == "RightButton" then
				if C_LFGList.CanCreateQuestGroup(self.questID) then
					LFGListUtil_FindQuestGroup(self.questID)
				else
					WorldQuestList.LFG_Search(self.questID)
				end
			end			
			
		end
	end
	WorldQuestList.hookClickFunc = hookFunc
	function HookWQbuttons()
		if WorldMapFrame.pinPools and WorldMapFrame.pinPools.WorldMap_WorldQuestPinTemplate and WorldMapFrame.pinPools.WorldMap_WorldQuestPinTemplate.activeObjects then
			for button,_ in pairs(WorldMapFrame.pinPools.WorldMap_WorldQuestPinTemplate.activeObjects) do
				if not hooked[button] then
					button:HookScript("OnMouseUp",hookFunc)
					hooked[button] = true
				end
			end
		end
	
	end
end


do
	local realmsDB = {	--1:US 2:EU 0:Other
		[500]=2,	[501]=2,	[502]=2,	[503]=2,	[504]=2,	[505]=2,
		[506]=2,	[507]=2,	[508]=2,	[509]=2,	[510]=2,	[511]=2,
		[512]=2,	[513]=2,	[515]=2,	[516]=2,	[517]=2,	[518]=2,
		[519]=2,	[521]=2,	[522]=2,	[523]=2,	[524]=2,	[525]=2,
		[526]=2,	[527]=2,	[528]=2,	[529]=2,	[531]=2,	[533]=2,
		[535]=2,	[536]=2,	[537]=2,	[538]=2,	[539]=2,	[540]=2,
		[541]=2,	[542]=2,	[543]=2,	[544]=2,	[545]=2,	[546]=2,
		[547]=2,	[548]=2,	[549]=2,	[550]=2,	[551]=2,	[552]=2,
		[553]=2,	[554]=2,	[556]=2,	[557]=2,	[558]=2,	[559]=2,
		[560]=2,	[561]=2,	[562]=2,	[563]=2,	[564]=2,	[565]=2,
		[566]=2,	[567]=2,	[568]=2,	[569]=2,	[570]=2,	[571]=2,
		[572]=2,	[573]=2,	[574]=2,	[575]=2,	[576]=2,	[577]=2,
		[578]=2,	[579]=2,	[580]=2,	[581]=2,	[582]=2,	[583]=2,
		[584]=2,	[585]=2,	[586]=2,	[587]=2,	[588]=2,	[589]=2,
		[590]=2,	[591]=2,	[592]=2,	[593]=2,	[594]=2,	[600]=2,
		[601]=2,	[602]=2,	[604]=2,	[605]=2,	[606]=2,	[607]=2,
		[608]=2,	[609]=2,	[610]=2,	[611]=2,	[612]=2,	[613]=2,
		[614]=2,	[615]=2,	[616]=2,	[617]=2,	[618]=2,	[619]=2,
		[621]=2,	[622]=2,	[623]=2,	[624]=2,	[625]=2,	[626]=2,
		[627]=2,	[628]=2,	[629]=2,	[630]=2,	[631]=2,	[632]=2,
		[633]=2,	[635]=2,	[636]=2,	[637]=2,	[638]=2,	[639]=2,
		[640]=2,	[641]=2,	[642]=2,	[643]=2,	[644]=2,	[645]=2,
		[646]=2,	[647]=2,	[1080]=2,	[1081]=2,	[1082]=2,	[1083]=2,
		[1084]=2,	[1085]=2,	[1086]=2,	[1087]=2,	[1088]=2,	[1089]=2,
		[1090]=2,	[1091]=2,	[1092]=2,	[1093]=2,	[1096]=2,	[1097]=2,
		[1098]=2,	[1099]=2,	[1104]=2,	[1105]=2,	[1106]=2,	[1117]=2,
		[1118]=2,	[1119]=2,	[1121]=2,	[1122]=2,	[1123]=2,	[1127]=2,
		[1298]=2,	[1299]=2,	[1300]=2,	[1301]=2,	[1303]=2,	[1304]=2,
		[1305]=2,	[1306]=2,	[1307]=2,	[1308]=2,	[1309]=2,	[1310]=2,
		[1311]=2,	[1312]=2,	[1313]=2,	[1314]=2,	[1316]=2,	[1317]=2,
		[1318]=2,	[1319]=2,	[1320]=2,	[1321]=2,	[1322]=2,	[1323]=2,
		[1324]=2,	[1326]=2,	[1327]=2,	[1328]=2,	[1330]=2,	[1331]=2,
		[1332]=2,	[1333]=2,	[1334]=2,	[1335]=2,	[1336]=2,	[1337]=2,
		[1378]=2,	[1379]=2,	[1380]=2,	[1381]=2,	[1382]=2,	[1383]=2,
		[1384]=2,	[1385]=2,	[1386]=2,	[1387]=2,	[1388]=2,	[1389]=2,
		[1391]=2,	[1392]=2,	[1393]=2,	[1394]=2,	[1395]=2,	[1400]=2,
		[1401]=2,	[1404]=2,	[1405]=2,	[1406]=2,	[1407]=2,	[1408]=2,
		[1409]=2,	[1413]=2,	[1415]=2,	[1416]=2,	[1417]=2,	[1587]=2,
		[1588]=2,	[1589]=2,	[1595]=2,	[1596]=2,	[1597]=2,	[1598]=2,
		[1602]=2,	[1603]=2,	[1604]=2,	[1605]=2,	[1606]=2,	[1607]=2,
		[1608]=2,	[1609]=2,	[1610]=2,	[1611]=2,	[1612]=2,	[1613]=2,
		[1614]=2,	[1615]=2,	[1616]=2,	[1617]=2,	[1618]=2,	[1619]=2,
		[1620]=2,	[1621]=2,	[1622]=2,	[1623]=2,	[1624]=2,	[1625]=2,
		[1626]=2,	[1922]=2,	[1923]=2,	[1924]=2,	[1925]=2,	[1926]=2,
		[1927]=2,	[1928]=2,	[1929]=2,
		[1]=1,	[2]=1,	[3]=1,	[4]=1,	[5]=1,	[6]=1,
		[7]=1,	[8]=1,	[9]=1,	[10]=1,	[11]=1,	[12]=1,
		[13]=1,	[14]=1,	[15]=1,	[16]=1,	[47]=1,	[51]=1,
		[52]=1,	[53]=1,	[54]=1,	[55]=1,	[56]=1,	[57]=1,
		[58]=1,	[59]=1,	[60]=1,	[61]=1,	[62]=1,	[63]=1,
		[64]=1,	[65]=1,	[66]=1,	[67]=1,	[68]=1,	[69]=1,
		[70]=1,	[71]=1,	[72]=1,	[73]=1,	[74]=1,	[75]=1,
		[76]=1,	[77]=1,	[78]=1,	[79]=1,	[80]=1,	[81]=1,
		[82]=1,	[83]=1,	[84]=1,	[85]=1,	[86]=1,	[87]=1,
		[88]=1,	[89]=1,	[90]=1,	[91]=1,	[92]=1,	[93]=1,
		[94]=1,	[95]=1,	[96]=1,	[97]=1,	[98]=1,	[99]=1,
		[100]=1,	[101]=1,	[102]=1,	[103]=1,	[104]=1,	[105]=1,
		[106]=1,	[107]=1,	[108]=1,	[109]=1,	[110]=1,	[111]=1,
		[112]=1,	[113]=1,	[114]=1,	[115]=1,	[116]=1,	[117]=1,
		[118]=1,	[119]=1,	[120]=1,	[121]=1,	[122]=1,	[123]=1,
		[124]=1,	[125]=1,	[126]=1,	[127]=1,	[128]=1,	[129]=1,
		[130]=1,	[131]=1,	[151]=1,	[153]=1,	[154]=1,	[155]=1,
		[156]=1,	[157]=1,	[158]=1,	[159]=1,	[160]=1,	[162]=1,
		[163]=1,	[164]=1,	[1067]=1,	[1068]=1,	[1069]=1,	[1070]=1,
		[1071]=1,	[1072]=1,	[1075]=1,	[1128]=1,	[1129]=1,	[1130]=1,
		[1131]=1,	[1132]=1,	[1136]=1,	[1137]=1,	[1138]=1,	[1139]=1,
		[1140]=1,	[1141]=1,	[1142]=1,	[1143]=1,	[1145]=1,	[1146]=1,
		[1147]=1,	[1148]=1,	[1151]=1,	[1154]=1,	[1165]=1,	[1173]=1,
		[1175]=1,	[1182]=1,	[1184]=1,	[1185]=1,	[1190]=1,	[1258]=1,
		[1259]=1,	[1260]=1,	[1262]=1,	[1263]=1,	[1264]=1,	[1265]=1,
		[1266]=1,	[1267]=1,	[1268]=1,	[1270]=1,	[1271]=1,	[1276]=1,
		[1277]=1,	[1278]=1,	[1280]=1,	[1282]=1,	[1283]=1,	[1284]=1,
		[1285]=1,	[1286]=1,	[1287]=1,	[1288]=1,	[1289]=1,	[1290]=1,
		[1291]=1,	[1292]=1,	[1293]=1,	[1294]=1,	[1295]=1,	[1296]=1,
		[1297]=1,	[1342]=1,	[1344]=1,	[1345]=1,	[1346]=1,	[1347]=1,
		[1348]=1,	[1349]=1,	[1350]=1,	[1351]=1,	[1352]=1,	[1353]=1,
		[1354]=1,	[1355]=1,	[1356]=1,	[1357]=1,	[1358]=1,	[1359]=1,
		[1360]=1,	[1361]=1,	[1362]=1,	[1363]=1,	[1364]=1,	[1365]=1,
		[1367]=1,	[1368]=1,	[1369]=1,	[1370]=1,	[1371]=1,	[1372]=1,
		[1373]=1,	[1374]=1,	[1375]=1,	[1377]=1,	[1425]=1,	[1427]=1,
		[1428]=1,	[1549]=1,	[1555]=1,	[1556]=1,	[1557]=1,	[1558]=1,
		[1559]=1,	[1563]=1,	[1564]=1,	[1565]=1,	[1566]=1,	[1567]=1,
		[1570]=1,	[1572]=1,	[1576]=1,	[1578]=1,	[1579]=1,	[1581]=1,
		[1582]=1,	[3207]=1,	[3208]=1,	[3209]=1,	[3210]=1,	[3234]=1,
		[3721]=1,	[3722]=1,	[3723]=1,	[3724]=1,	[3725]=1,	[3726]=1,
		[3733]=1,	[3734]=1,	[3735]=1,	[3736]=1,	[3737]=1,	[3738]=1,
	}
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
	list[#list+1] = {text = GetFaction(2045,"Legionfall"),		func = SetIgnoreFilter,	arg1 = "legionfallIgnoreFilter",	checkable = true,	shownFunc = LEGION	}
	list[#list+1] = {text = LOCALE.ignoreList,			func = SetIgnoreFilter,	arg1 = "ignoreIgnore",			checkable = true,				}
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
			WorldQuestList:SetPoint("TOPLEFT",WorldMapFrame,"BOTTOMRIGHT",VWQL.Anchor3PosLeft,VWQL.Anchor3PosTop)
		else
			WorldQuestList:SetPoint("TOPLEFT",WorldMapFrame,"TOPRIGHT",10,-4)
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
				--ELib.ScrollDropDown.Close()
				WorldQuestList_Update()
			end,
			checkable = true,
		},
		{
			text = LOCALE.lfgDisableRightClickIcons,
			func = function()
				VWQL.DisableLFG_RightClickIcon = not VWQL.DisableLFG_RightClickIcon
				--ELib.ScrollDropDown.Close()
				WorldQuestList_Update()
			end,
			checkable = true,
		},
	}	
	
	list[#list+1] = {
		text = LOCALE.lfgSearchOption,
		func = function()
			VWQL.DisableLFG = not VWQL.DisableLFG
			--ELib.ScrollDropDown.Close()
			WorldQuestList_Update()
		end,
		checkable = true,
		subMenu = lfgSubMenu,
	}
	
	local function SetScaleArrow(_, arg1)
		VWQL.Arrow_Scale = arg1
		--ELib.ScrollDropDown.Close()
		WQLdb.Arrow:Scale(arg1 or 1)
	end
	
	local arrowMenu = {
		{
			text = LOCALE.disableArrow,
			func = function()
				VWQL.DisableArrow = not VWQL.DisableArrow
				--ELib.ScrollDropDown.Close()
				WorldQuestList_Update()				
			end,
			checkable = true,
		},	
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
				--ELib.ScrollDropDown.Close()
				WorldQuestList_Update()				
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
	
	local function SetAPFormat(_, arg1)
		VWQL.APFormat = arg1
		ELib.ScrollDropDown.Close()
		WorldQuestList_Update()
	end
	
	local apFormatSubMenu = {
		{text = "2100000",	func = SetAPFormat,	arg1 = 1,	radio = true	},	
		{text = "110万",	func = SetAPFormat,	arg1 = 2,	radio = true	},
		{text = "1.1M",		func = SetAPFormat,	arg1 = 3,	radio = true	},
		{text = "1M",		func = SetAPFormat,	arg1 = 4,	radio = true	},
		{text = "1.1亿",		func = SetAPFormat,	arg1 = 5,	radio = true	},
		{text = "13亿",		func = SetAPFormat,	arg1 = 6,	radio = true	},
		{text = "自动",		func = SetAPFormat,	arg1 = nil,	radio = true	},
		{text = "1.1%",		func = SetAPFormat,	arg1 = 10,	radio = true	},	
	}	
	
	list[#list+1] = {
		text = LOCALE.apFormatSetup,
		subMenu = apFormatSubMenu,
		padding = 16,
		shownFunc = function() return WorldQuestList:IsLegionZone() end,
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
		shownFunc = function() return not WorldQuestList:IsLegionZone() end,
	}
	
	local function SetIconGeneral(_, arg1)
		VWQL["DisableIconsGeneralMap"..arg1] = not VWQL["DisableIconsGeneralMap"..arg1]
		--ELib.ScrollDropDown.Close()
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
			--ELib.ScrollDropDown.Close()
			WorldQuestList.IconsGeneralLastMap = -1
			WorldQuestList_Update()
		end,
		checkable = true,
		subMenu = iconsGeneralSubmenu,
	}
	
	
	list[#list+1] = {
		text = LOCALE.disableRewardIcons,
		colorCode = "|cff00ff00",
		func = function()
			VWQL.DisableRewardIcons = not VWQL.DisableRewardIcons
			ELib.ScrollDropDown.Close()
			if VWQL.DisableRewardIcons then
				WorldQuestList:WQIcons_RemoveIcons()
			else
				WorldQuestList:WQIcons_AddIcons()
			end
		end,
		checkable = true,
	}
	
	local mapIconsScaleSubmenu = {
		{text = "",	isTitle = true,	slider = {min = 100, max = 300, val = 100, afterText = "%", func = nil}	},	
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
	
	list[#list+1] = {
		text = LOCALE.headerEnable,
		func = function()
			VWQL.DisableHeader = not VWQL.DisableHeader
			ELib.ScrollDropDown.Close()
			WorldQuestList_Update()
		end,
		checkable = true,
	}
		
	list[#list+1] = {
		text = LOCALE.totalapdisable,
		func = function()
			VWQL.DisableTotalAP = not VWQL.DisableTotalAP
			ELib.ScrollDropDown.Close()
			WorldQuestList_Update()
		end,
		checkable = true,
	}
	
	list[#list+1] = {
		text = LOCALE.disabeHighlightNewQuests,
		func = function()
			VWQL.DisableHighlightNewQuest = not VWQL.DisableHighlightNewQuest
			ELib.ScrollDropDown.Close()
			WorldQuestList_Update()
		end,
		checkable = true,
	}
	
	list[#list+1] = {
		text = LOCALE.addQuestsOpposite,
		func = function()
			VWQL.OppositeContinent = not VWQL.OppositeContinent
			ELib.ScrollDropDown.Close()
			WorldQuestList_Update()
		end,
		checkable = true,
		shownFunc = function() return not WorldQuestList:IsLegionZone() end,
	}
	list[#list+1] = {
		text = LOCALE.addQuestsArgus,
		func = function()
			VWQL.OppositeContinentArgus = not VWQL.OppositeContinentArgus
			ELib.ScrollDropDown.Close()
			WorldQuestList_Update()
		end,
		checkable = true,
		shownFunc = function() return WorldQuestList:IsLegionZone() end,
	}
	list[#list+1] = {
		text = LOCALE.hideLegion,
		func = function()
			VWQL.HideLegion = not VWQL.HideLegion
			ELib.ScrollDropDown.Close()
			WorldQuestList_Update()
		end,
		checkable = true,
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
		shownFunc = function() return WorldQuestList:IsLegionZone() end,
	}
	
	list[#list+1] = {
		text = LOCALE.enigmaHelper,
		func = function()
			VWQL.EnableEnigma = not VWQL.EnableEnigma
			ELib.ScrollDropDown.Close()
		end,
		checkable = true,
		shownFunc = function() return WorldQuestList:IsLegionZone() end,
	}
	list[#list+1] = {
		text = LOCALE.barrelsHelper,
		func = function()
			VWQL.DisableBarrels = not VWQL.DisableBarrels
			ELib.ScrollDropDown.Close()
		end,
		checkable = true,
		shownFunc = function() return WorldQuestList:IsLegionZone() end,
	}
	list[#list+1] = {
		text = LOCALE.shellGameHelper,
		func = function()
			VWQL.DisableShellGame = not VWQL.DisableShellGame
			ELib.ScrollDropDown.Close()
		end,
		checkable = true,
		shownFunc = function() return not WorldQuestList:IsLegionZone() end,
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
		shownFunc = function() return not WorldQuestList.optionsDropDown:IsVisible() end,
	}
	
	function WorldQuestList.optionsDropDown.Button:additionalToggle()
		for i=1,#self.List do
			if self.List[i].text == LOCALE.totalapdisable then	
				self.List[i].checkState = VWQL.DisableTotalAP
			elseif self.List[i].text == LOCALE.barrelsHelper then
				self.List[i].checkState = not VWQL.DisableBarrels
			elseif self.List[i].text == LOCALE.enigmaHelper then
				self.List[i].checkState = VWQL.EnableEnigma
			elseif self.List[i].text == LOCALE.headerEnable then
				self.List[i].checkState = not VWQL.DisableHeader
			elseif self.List[i].text == LOCALE.disabeHighlightNewQuests then
				self.List[i].checkState = VWQL.DisableHighlightNewQuest
			elseif self.List[i].text == LOCALE.disableBountyIcon then
				self.List[i].checkState = VWQL.DisableBountyIcon
			elseif self.List[i].text == LOCALE.addQuestsOpposite then
				self.List[i].checkState = VWQL.OppositeContinent
			elseif self.List[i].text == LOCALE.hideLegion then
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
		apFormatSubMenu[1].checkState = VWQL.APFormat == 1
		apFormatSubMenu[2].checkState = VWQL.APFormat == 2
		apFormatSubMenu[3].checkState = VWQL.APFormat == 3
		apFormatSubMenu[4].checkState = VWQL.APFormat == 4
		apFormatSubMenu[5].checkState = VWQL.APFormat == 5
		apFormatSubMenu[6].checkState = VWQL.APFormat == 6
		apFormatSubMenu[7].checkState = not VWQL.APFormat
		apFormatSubMenu[8].checkState = VWQL.APFormat == 10
		azeriteFormatSubMenu[1].checkState = not VWQL.AzeriteFormat
		azeriteFormatSubMenu[2].checkState = VWQL.AzeriteFormat == 10
		azeriteFormatSubMenu[3].checkState = VWQL.AzeriteFormat == 20
		arrowMenu[1].checkState = VWQL.DisableArrow
		for i=3,#arrowMenu-1 do
			arrowMenu[i].checkState = VWQL.Arrow_Scale == arrowMenu[i].arg1
		end
		arrowMenu[#arrowMenu].checkState = VWQL.DisableArrowMove
		for i=1,#iconsGeneralSubmenu do
			iconsGeneralSubmenu[i].checkState = not VWQL["DisableIconsGeneralMap"..iconsGeneralSubmenu[i].arg1]
		end
		lfgSubMenu[1].checkState = VWQL.DisableLFG_Popup
		lfgSubMenu[2].checkState = VWQL.DisableLFG_RightClickIcon
		mapIconsScaleSubmenu[1].slider.val = (VWQL.MapIconsScale or 1) * 100
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
WorldQuestList.moveHeader.Button.i:Hide()
WorldQuestList.moveHeader.Button:SetAllPoints()
WorldQuestList.moveHeader.Button:SetScript("OnClick",nil)
WorldQuestList.moveHeader.Button:RegisterForDrag("LeftButton")

WorldQuestList.moveHeader.Button:SetScript("OnDragStart", function(self)
	WorldQuestList:SetMovable(true)
	--WorldQuestList:SetClampedToScreen(true)
	WorldQuestList:StartMoving()
	self.ticker = C_Timer.NewTicker(0.5,function()
		WorldQuestList_Update()
	end)
end)
WorldQuestList.moveHeader.Button:SetScript("OnDragStop", function(self)
	WorldQuestList:StopMovingOrSizing()
	WorldQuestList:SetMovable(false)
	WorldQuestList:SetClampedToScreen(false)
	if WorldQuestList.IsSoloRun then
		VWQL.PosLeft = WorldQuestList:GetLeft()
		VWQL.PosTop = WorldQuestList:GetTop()
	end
	if VWQL.Anchor == 3 and WorldMapFrame:IsVisible() then
		VWQL.Anchor3PosLeft = WorldQuestList:GetLeft() - WorldMapFrame:GetRight()
		VWQL.Anchor3PosTop = WorldQuestList:GetTop() - WorldMapFrame:GetBottom()
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
		
				--pin:SetScalingLimits(1, 0.425, 0.425)
				--pin:ApplyCurrentScale()
		
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
				})
			end
		end
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
		
		line.LFGButton:Hide()
		
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



local function FormatAPnumber(ap,artifactKnowlegeLevel,ignorePercentForm)
	if VWQL.APFormat == 1 then
		return tostring(ap)
	elseif VWQL.APFormat == 2 then
		return format("%d万",ap / 10000)
	elseif VWQL.APFormat == 3 then
		return format("%.1fM",ap / 1000000)
	elseif VWQL.APFormat == 4 then
		return format("%dM",ap / 1000000)
	elseif VWQL.APFormat == 5 then
		return format("%.1f亿",ap / 100000000)
	elseif VWQL.APFormat == 6 then
		return format("%d亿",ap / 100000000)
	elseif VWQL.APFormat == 10 and not ignorePercentForm then
		return FormatAPnumber(ap,artifactKnowlegeLevel,true)
	else
		if ap > 1e9 then
			return format("%d亿", ap / 1e8)
		elseif ap > 1e7 then
			return format("%.2f亿", ap / 1e8)
		elseif ap > 1e4 then			
			return format("%d万", ap / 1e4)
		else
			return tostring(ap)
		end
		artifactKnowlegeLevel = artifactKnowlegeLevel or 0
		if artifactKnowlegeLevel >= 53 then
			return format("%.1fB",ap / 1000000000)
		elseif artifactKnowlegeLevel >= 40 then
			return format("%dM",ap / 1000000)
		elseif artifactKnowlegeLevel >= 35 then
			return format("%.1fM",ap / 1000000)
		elseif artifactKnowlegeLevel > 25 then
			return format("%dk",ap / 1000)
		else
			return tostring(ap)
		end	
	end
end

function WorldQuestList:DetectCurrentAK()
	return 55
end

do
	local azeriteItemLocation
	function WorldQuestList:FormatAzeriteNumber(azerite,ignorePercentForm)
		if (VWQL.AzeriteFormat == 10 or VWQL.AzeriteFormat == 20) and not ignorePercentForm then
			azeriteItemLocation = azeriteItemLocation or C_AzeriteItem.FindActiveAzeriteItem()
			if azeriteItemLocation and not C_AzeriteItem.IsAzeriteItem(azeriteItemLocation) then
				azeriteItemLocation = C_AzeriteItem.FindActiveAzeriteItem()
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

function WorldQuestList_Update(preMapID)
	if not WorldQuestList:IsVisible() then
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
		artifactKnowlegeLevel = 0,
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
			if taskInfo[i].mapID and WorldQuestList:IsLegionZone(taskInfo[i].mapID) then
				tremove(taskInfo,i)
			end
		end	
	end
		
	WorldQuestList.currentMapID = mapAreaID
	
	O.artifactKnowlegeLevel = WorldQuestList:DetectCurrentAK()

	O.nextResearch = WorldQuestList:GetNextResetTime(WorldQuestList:GetCurrentRegion())
	
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
							if text and ( text:find(LE.ARTIFACT_POWER.."|r$") or text:find("Artifact Power|r$") ) then
								hasRewardFiltered = true
								rewardType = 20
								if bit.band(filters[2][2],ActiveFilter) == 0 then 
									isValidLine = 0  
								end
								if LE.BAG_ITEM_QUALITY_COLORS[6] then
									rewardColor = LE.BAG_ITEM_QUALITY_COLORS[6]
								end
							elseif text and text:find(ITEM_LEVEL) then
								local ilvl = text:match(ITEM_LEVEL)
								reward = "|T"..icon..":0|t "..ilvl --163ui .." "..name
								ilvl = tonumber( ilvl:gsub("%+",""),nil )
								if ilvl then
									rewardType = O.isGearLessRelevant and 37 or 0
									rewardSort = ilvl
									hasRewardFiltered = true
								end
							elseif text and rewardType == 20 and text:find("^"..LE.ITEM_SPELL_TRIGGER_ONUSE) then
								local ap = tonumber((text:gsub("(%d)[ %.,]+(%d)","%1%2"):match("%d+[,%d%.]*") or "?"):gsub(",",""):gsub("%.",""),nil)
								if ap then
									if SECOND_NUMBER then	--Check 7.2
										local isLarge = nil
										if text:find("%d+ *"..SECOND_NUMBER:gsub("%.","%%.")) then
											isLarge = 10 ^ 6
											if locale == "zhCN" or locale == "koKR" or locale == "zhTW" then
												isLarge = 10 ^ 4
											end
										elseif text:find("%d+ *"..THIRD_NUMBER:gsub("%.","%%.")) then
											isLarge = 10 ^ 9
											if locale == "zhCN" or locale == "koKR" or locale == "zhTW" then
												isLarge = 10 ^ 8
											end											
										elseif text:find("%d+ *"..FOURTH_NUMBER:gsub("%.","%%.")) then
											isLarge = 10 ^ 12
										end
										if isLarge then
											if text:find("%d+[%.,]*%d*") then
												ap = tonumber( text:gsub("(%d+)[%.,](%d+)","%1.%2"):match("%d+%.*%d*") or "0",nil )
											end
											ap = ap * isLarge
										end
									end
									
									if artifactXP then
										ap = ap + artifactXP
										totalAP = totalAP - totalAPadded
									end
									
									local apString = FormatAPnumber(ap,O.artifactKnowlegeLevel)
									
									reward = reward:gsub(":0|t .+",":0|t ["..apString.."] ") --163ui
									rewardSort = ap
									if isValidLine ~= 0 then
										totalAP = totalAP + ap
									end
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
					
					local pin = WorldQuestList.WMF_activePins[info.questId]
					
					local minScale = O.generalMapType == 2 and 0.15 or O.generalMapType == 4 and 0.3 or 0.35
					local maxScale = O.generalMapType == 2 and 0.2 or 0.425
					
					if WorldMapFrame:IsMaximized() then
						minScale = minScale * 1.5
						maxScale = maxScale * 1.5
					end
					
					--pin:SetScalingLimits(1, minScale, maxScale)
					--pin:ApplyCurrentScale()
				end
			end
			isUpdateReq = true
		end
		
		for questId in pairs(pinsToRemove) do
			if WQ_provider.pingPin and WQ_provider.pingPin:IsAttachedToQuest(questId) then
				WQ_provider.pingPin:Stop()
			end
			local pin = WorldQuestList.WMF_activePins[questId]
	
			--pin:SetScalingLimits(1, 0.425, 0.425)
			--pin:ApplyCurrentScale()
	
			WQ_provider:GetMap():RemovePin(pin)
			WorldQuestList.WMF_activePins[questId] = nil
		end
		
		if isUpdateReq then
			--WorldQuestList:WQIcons_AddIcons()
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
		if data.factionInProgress then
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
		if totalAP == 0 and totalWE > 0 then
			local name,_,icon = GetCurrencyInfo(1533)
			WorldQuestList.footer.ap:SetText((icon and "|T"..icon..":0|t " or "")..name..": "..totalWE)
		else
			WorldQuestList.footer.ap:SetText(LOCALE.totalap .. FormatAPnumber(totalAP,O.artifactKnowlegeLevel):gsub("%%%%","%%"))
		end
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
	if WorldQuestList:IsVisible() then
		WorldQuestList:Hide()
		WorldQuestList:Show()
	end
end)
local prevZone
WorldMapButton_HookShowHide:SetScript('OnUpdate',function()
	local currZone = GetCurrentMapAreaID()
	if currZone ~= prevZone then
		WorldQuestList_Update()
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
	if (arg == "" and WorldMapFrame:IsVisible()) or argL == "help" then
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


-- Enigma helper

local KirinTorQuests = {
	[43756]=true,	--VS
	[43772]=true,	--SH
	[43767]=true,	--HM
	[43328]=true,	--A
	[43778]=true,	--SU
}

local KirinTorPatt = {		--Patterns created by flow0284
	[1] = { [9]=1,[10]=1,[11]=1,[12]=1,[13]=1,[20]=1,[23]=1,[24]=1,[25]=1,[26]=1,[27]=1,[30]=1,[37]=1,[38]=1,[39]=1,[40]=1,[41]=2,},
	[2] = { [9]=1,[11]=1,[12]=1,[13]=1,[16]=1,[18]=1,[20]=1,[23]=1,[24]=1,[25]=1,[27]=1,[34]=1,[41]=2,},
	[3] = { [9]=1,[10]=1,[11]=1,[12]=1,[19]=1,[25]=1,[26]=1,[32]=1,[39]=1,[40]=1,[41]=2,},
	[4] = { [9]=1,[10]=1,[11]=1,[18]=1,[23]=1,[24]=1,[25]=1,[30]=1,[37]=1,[38]=1,[39]=1,[40]=1,[41]=2,},
	[5] = { [9]=1,[10]=1,[11]=1,[12]=1,[13]=1,[16]=1,[23]=1,[25]=1,[26]=1,[27]=1,[30]=1,[32]=1,[34]=1,[37]=1,[38]=1,[39]=1,[41]=2,},
	[6] = { [12]=1,[13]=1,[18]=1,[19]=1,[25]=1,[32]=1,[33]=1,[40]=1,[41]=2,},
	[7] = { [9]=1,[11]=1,[12]=1,[13]=1,[16]=1,[18]=1,[20]=1,[23]=1,[25]=1,[27]=1,[30]=1,[31]=1,[32]=1,[34]=1,[41]=2,},
	[8] = { [9]=1,[10]=1,[17]=1,[24]=1,[25]=1,[32]=1,[33]=1,[40]=1,[41]=2,},
	[9] = { [9]=1,[16]=1,[17]=1,[18]=1,[19]=1,[20]=1,[27]=1,[34]=1,[41]=2,},
	[10] = { [9]=1,[10]=1,[11]=1,[12]=1,[13]=1,[16]=1,[23]=1,[24]=1,[25]=1,[26]=1,[33]=1,[40]=1,[41]=2,},
	[11] = { [9]=1,[10]=1,[11]=1,[12]=1,[13]=1,[16]=1,[23]=1,[30]=1,[37]=1,[38]=1,[39]=1,[40]=1,[41]=2,},
	[12] = { [11]=1,[12]=1,[13]=1,[18]=1,[23]=1,[24]=1,[25]=1,[30]=1,[37]=1,[38]=1,[39]=1,[40]=1,[41]=2,},
	[13] = { [13]=1,[20]=1,[23]=1,[24]=1,[25]=1,[26]=1,[27]=1,[30]=1,[37]=1,[38]=1,[39]=1,[40]=1,[41]=2,},
}

local KIRIN_TOR_SIZE = 7
local KirinTorSelecter_Big_BSize = 30
local KirinTorSelecter_Big_Size = KIRIN_TOR_SIZE * KirinTorSelecter_Big_BSize + 10

local KirinTorSelecter_BSize = 12
local KirinTorSelecter_Size = KIRIN_TOR_SIZE * KirinTorSelecter_BSize + 10

local KirinTorSelecter_Big = CreateFrame('Button',nil,UIParent)
KirinTorSelecter_Big:SetPoint("LEFT",30,0)
KirinTorSelecter_Big:SetSize(KirinTorSelecter_Big_Size,KirinTorSelecter_Big_Size)
KirinTorSelecter_Big:SetAlpha(.8)
ELib:CreateBorder(KirinTorSelecter_Big)
KirinTorSelecter_Big:SetBorderColor(0,0,0,0)

KirinTorSelecter_Big.back = KirinTorSelecter_Big:CreateTexture(nil,"BACKGROUND")
KirinTorSelecter_Big.back:SetAllPoints()
KirinTorSelecter_Big.back:SetColorTexture(0,0,0,1)
KirinTorSelecter_Big.T = {}
KirinTorSelecter_Big:Hide()
do
	local L = (KirinTorSelecter_Big_Size - KirinTorSelecter_Big_BSize * KIRIN_TOR_SIZE) / 2
	for j=0,KIRIN_TOR_SIZE-1 do
		for k=0,KIRIN_TOR_SIZE-1 do
			local t = KirinTorSelecter_Big:CreateTexture(nil,"ARTWORK")
			t:SetSize(KirinTorSelecter_Big_BSize,KirinTorSelecter_Big_BSize)
			t:SetPoint("TOPLEFT",L + k*KirinTorSelecter_Big_BSize,-L-j*KirinTorSelecter_Big_BSize)
			
			KirinTorSelecter_Big.T[ j*KIRIN_TOR_SIZE+k+1 ] = t
		end
		

		local l = KirinTorSelecter_Big:CreateTexture(nil,"OVERLAY")
		l:SetPoint("TOPLEFT",L+j*KirinTorSelecter_Big_BSize,-L)
		l:SetSize(1,KirinTorSelecter_Big_BSize*KIRIN_TOR_SIZE)
		l:SetColorTexture(0,0,0,.3)
	end
	for j=0,7 do
		local l = KirinTorSelecter_Big:CreateTexture(nil,"OVERLAY")
		l:SetPoint("TOPLEFT",L,-L-j*KirinTorSelecter_Big_BSize)
		l:SetSize(KirinTorSelecter_Big_BSize*KIRIN_TOR_SIZE,1)
		l:SetColorTexture(0,0,0,.3)	
	end
end



local KirinTorSelecter = CreateFrame('Frame',nil,UIParent)
KirinTorSelecter:SetPoint("LEFT",30,0)
KirinTorSelecter:SetSize(KirinTorSelecter_Size * 4,KirinTorSelecter_Size * 3)
KirinTorSelecter:SetAlpha(.7)
KirinTorSelecter:Hide()

KirinTorSelecter.back = KirinTorSelecter:CreateTexture(nil,"BACKGROUND")
KirinTorSelecter.back:SetAllPoints()
KirinTorSelecter.back:SetColorTexture(0,0,0,1)

for i=1,#KirinTorPatt do
	local b = CreateFrame('Button',nil,KirinTorSelecter)
	b:SetSize(KirinTorSelecter_Size,KirinTorSelecter_Size)
	b:SetPoint("TOPLEFT",((i-1)%4)*KirinTorSelecter_Size,-floor((i-1)/4)*KirinTorSelecter_Size)
	
	ELib:CreateBorder(b)
	b:SetBorderColor(0,0,0,1)
	b:SetScript("OnEnter",function(self)
		self:SetBorderColor(1,1,1,1)
	end)
	b:SetScript("OnLeave",function(self)
		self:SetBorderColor(0,0,0,1)
	end)
	b:SetScript("OnClick",function(self)
		for j=0,KIRIN_TOR_SIZE-1 do
			for k=0,KIRIN_TOR_SIZE-1 do
				local n = j*KIRIN_TOR_SIZE+k+1
				local c = KirinTorPatt[i][n]
				if c == 2 then
					KirinTorSelecter_Big.T[n]:SetColorTexture(0,1,0,1)
				elseif c then
					KirinTorSelecter_Big.T[n]:SetColorTexture(1,0,0,1)
				else
					KirinTorSelecter_Big.T[n]:SetColorTexture(1,.7,.4,1)
				end
			end
		end	
		KirinTorSelecter:Hide()
		KirinTorSelecter_Big:Show()
	end)
	
	local L = (KirinTorSelecter_Size - KirinTorSelecter_BSize * KIRIN_TOR_SIZE) / 2
	for j=0,KIRIN_TOR_SIZE-1 do
		for k=0,KIRIN_TOR_SIZE-1 do
			local t = b:CreateTexture(nil,"ARTWORK")
			t:SetSize(KirinTorSelecter_BSize,KirinTorSelecter_BSize)
			t:SetPoint("TOPLEFT",L + k*KirinTorSelecter_BSize,-L-j*KirinTorSelecter_BSize)
			
			local c = KirinTorPatt[i][ j*KIRIN_TOR_SIZE+k+1 ]
			if c == 2 then
				t:SetColorTexture(0,1,0,1)
			elseif c then
				t:SetColorTexture(1,0,0,1)
			else
				t:SetColorTexture(1,.7,.4,1)
			end
			
		end
	end
end

KirinTorSelecter.Close = CreateFrame('Button',nil,KirinTorSelecter)
KirinTorSelecter.Close:SetSize(10,10)
KirinTorSelecter.Close:SetPoint("BOTTOMRIGHT",KirinTorSelecter,"TOPRIGHT")
KirinTorSelecter.Close.Text = KirinTorSelecter.Close:CreateFontString(nil,"ARTWORK","GameFontWhite")
KirinTorSelecter.Close.Text:SetPoint("CENTER")
KirinTorSelecter.Close.Text:SetText("X")

KirinTorSelecter_Big:SetScript("OnClick",function (self)
	self:Hide()
  	KirinTorSelecter:Show()
end)


local KirinTorHelper = CreateFrame'Frame'
KirinTorHelper:RegisterEvent('QUEST_ACCEPTED')
KirinTorHelper:RegisterEvent('QUEST_REMOVED')
KirinTorHelper:SetScript("OnEvent",function(self,event,arg1,arg2)
	if event == 'QUEST_ACCEPTED' then
		if arg2 and KirinTorQuests[arg2] then
			if not VWQL.EnableEnigma then
				print('"|cff00ff00/enigmahelper|r" - to see all patterns')
				return
			end
			print("世界任务列表：神秘莫测助手已加载")
			self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		end
	elseif event == 'QUEST_REMOVED' then
		if arg1 and KirinTorQuests[arg1] then
			self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		end
	elseif event == 'COMBAT_LOG_EVENT_UNFILTERED' then
		local timestamp,arg2,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId = CombatLogGetCurrentEventInfo()

		if arg2 == "SPELL_AURA_APPLIED" and spellId == 219247 and destGUID == UnitGUID'player' then
			KirinTorSelecter:Show()
		elseif arg2 == "SPELL_AURA_REMOVED" and spellId == 219247 and destGUID == UnitGUID'player' then
			KirinTorSelecter:Hide()
			KirinTorSelecter_Big:Hide()
		end
	end
end)

KirinTorSelecter.Close:SetScript("OnClick",function ()
	KirinTorSelecter:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	KirinTorSelecter:Hide()
end)

SlashCmdList["WQLEnigmaSlash"] = function() 
	KirinTorHelper:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	KirinTorSelecter:Show()
end
SLASH_WQLEnigmaSlash1 = "/enigmahelper"


-- Barrels o' Fun

local BarrelsHelperQuests = {
	[45070]=true,	--Valsh
	[45068]=true,	--Suramar
	[45069]=true,	--Azuna
	[45071]=true,	--Highm
	[45072]=true,	--Stormh
}
local BarrelsHelper_guid = {}
local BarrelsHelper_count = 8

local BarrelsHelper = CreateFrame'Frame'
BarrelsHelper:RegisterEvent('QUEST_ACCEPTED')
BarrelsHelper:RegisterEvent('QUEST_REMOVED')
BarrelsHelper:RegisterEvent('PLAYER_ENTERING_WORLD')
BarrelsHelper:SetScript("OnEvent",function(self,event,arg1,arg2, hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellId)
	if event == 'QUEST_ACCEPTED' then
		if arg2 and BarrelsHelperQuests[arg2] then
			if VWQL.DisableBarrels then
				return
			end
			print("世界任务列表：欢乐桶助手已加载")
			BarrelsHelper_count = 8
			self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
		end
	elseif event == 'QUEST_REMOVED' then
		if arg1 and BarrelsHelperQuests[arg1] then
			self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
			BarrelsHelper_count = 8
		end
	elseif event == 'UPDATE_MOUSEOVER_UNIT' then
		local guid = UnitGUID'mouseover'
		if guid then
			local type,_,serverID,instanceID,zoneUID,id,spawnID = strsplit("-", guid)
			if id == "115947" then
				if not BarrelsHelper_guid[guid] then
					BarrelsHelper_guid[guid] = BarrelsHelper_count
					BarrelsHelper_count = BarrelsHelper_count - 1
					if BarrelsHelper_count < 1 then
						BarrelsHelper_count = 8
					end
				end
				if GetRaidTargetIndex("mouseover") ~= BarrelsHelper_guid[guid] then
					SetRaidTarget("mouseover", BarrelsHelper_guid[guid])
				end
			end
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		if VWQL.DisableBarrels then
			return
		end
		for i=1,GetNumQuestLogEntries() do
			local title, _, _, _, _, _, _, questID = GetQuestLogTitle(i)
			if questID and BarrelsHelperQuests[questID] then
				BarrelsHelper_count = 8
				self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
				break
			end
		end
	end
end)

SlashCmdList["WQLBarrelsSlash"] = function(arg) 
	arg = (arg or ""):lower()
	if arg == "off" or arg == "on" then
		VWQL.DisableBarrels = not VWQL.DisableBarrels
		if VWQL.DisableBarrels then
			print("Barrels helper disabled")
			BarrelsHelper:UnregisterEvent('UPDATE_MOUSEOVER_UNIT')
		else
			print("Barrels helper enabled")
		end
	elseif arg == "load" then
		BarrelsHelper:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
		print("Barrels helper loaded")
	else
		print("Commands:")
		print("/barrelshelper on")
		print("/barrelshelper off")
		print("/barrelshelper load")
	end
end
SLASH_WQLBarrelsSlash1 = "/barrelshelper"


-- Shell Game
do
	local ShellGameQuests = {
		[51625]=true,
		[51626]=true,
		[51627]=true,
		[51628]=true,
		[51629]=true,
		[51630]=true,
	}
	
--[[
фиол пилон	71324
валькирия	73430	73591
краб-пират	87999	75367
шар		71960	72772
капля		81077	81388
черепаха	81098
робот		72873	31549
челюсти		67537	76371	81664

63509	- arrow
75066   - quest
46201	- bomb
47270 	- kirintor
]]
	
	local size,center = 200,30
	
	local modelIDs = {71324,73430,87999,71960,81077,81098,72873,67537}
	
	local ShellGameDisable
	local ShellGameIsCreated
	
	local UpdatePos,ResizeFrame,CenterFrame,OkButton,pointsFrames,CloseButton
	
	local function CreateShellGame()
		if ShellGameIsCreated then
			return
		end
		ShellGameIsCreated = true
		local function SmallModelOnMouseDown(self)
			self:GetParent().M:SetDisplayInfo(self.modelID)
		end
		local function SmallModelOnEnter(self)
			self.b:SetColorTexture(0.74,0.74,0.74,.2)
		end
		local function SmallModelOnLeave(self)
			self.b:SetColorTexture(0.04,0.04,0.04,0)
		end
		local function PuzzleFrameOnUpdate(self)
			if MouseIsOver(self) and not self.Mstatus then
				self.Mstatus = true
				for j=1,8 do
					self.m[j]:Show()
				end
			elseif not MouseIsOver(self) and self.Mstatus then
				self.Mstatus = false
				for j=1,8 do
					self.m[j]:Hide()
				end
			end
		end	
		
		pointsFrames = {}
		for i=1,16 do
			local frame = CreateFrame("Frame",nil,UIParent)
			pointsFrames[i] = frame
			
			frame.M = CreateFrame("PlayerModel",nil,frame)
			frame.M:SetPoint("TOP")
			frame.M:SetMouseClickEnabled(false)
			frame.M:SetMouseMotionEnabled(false)
			
			frame.m = {}
			for j=1,8 do
				local m=CreateFrame("PlayerModel",nil,frame)
				frame.m[j] = m
				m:SetDisplayInfo(modelIDs[j])
				m.modelID = modelIDs[j]
				if j==1 then
					m:SetPoint("TOPLEFT")
				elseif j == 5 then
					m:SetPoint("TOPRIGHT")
				else
					m:SetPoint("TOP",frame.m[j-1],"BOTTOM")
				end
				m:Hide()
				m:SetScript("OnMouseDown",SmallModelOnMouseDown)
				m:SetScript("OnEnter",SmallModelOnEnter)
				m:SetScript("OnLeave",SmallModelOnLeave)
				
				m.b = m:CreateTexture(nil,"BACKGROUND")
				m.b:SetAllPoints()
			end
			
			frame:SetScript("OnUpdate",PuzzleFrameOnUpdate)	
			
			frame:Hide()
		end
		
		OkButton = CreateFrame("Button",nil,UIParent,"UIPanelButtonTemplate")
		OkButton:SetSize(120,20)
		OkButton:SetText("世界任务列表：锁定")
		OkButton:Hide()
		
		CloseButton = CreateFrame("Button",nil,UIParent,"UIPanelButtonTemplate")
		CloseButton:SetSize(120,20)
		CloseButton:SetPoint("TOP",OkButton,"BOTTOM")
		CloseButton:SetText(CLOSE)
		CloseButton:SetScript("OnClick",function()
			ShellGameDisable()
		end)
		CloseButton:Hide()
		
		ResizeFrame = CreateFrame("Frame",nil,UIParent)
		ResizeFrame:SetPoint("TOP",200,0)
		ResizeFrame:SetPoint("BOTTOM",200,0)
		ResizeFrame:SetWidth(8)
		ResizeFrame:Hide()
		
		ResizeFrame.b = ResizeFrame:CreateTexture(nil,"BACKGROUND")
		ResizeFrame.b:SetAllPoints()
		ResizeFrame.b:SetColorTexture(0.04,0.04,0.04,.9)
		
		ResizeFrame.lv,ResizeFrame.lh = {},{}
		for i=1,5 do
			ResizeFrame.lv[i] = ResizeFrame:CreateTexture(nil,"BACKGROUND")
			ResizeFrame.lv[i]:SetColorTexture(0.04,0.04,0.04,.9)
			ResizeFrame.lv[i]:SetWidth(3)
		
			ResizeFrame.lh[i] = ResizeFrame:CreateTexture(nil,"BACKGROUND")
			ResizeFrame.lh[i]:SetColorTexture(0.04,0.04,0.04,.9)
			ResizeFrame.lh[i]:SetHeight(3)
		end
		
		function UpdatePos(updateResizers)
			if updateResizers then
				ResizeFrame:SetPoint("TOP",size,0)
				ResizeFrame:SetPoint("BOTTOM",size,0)
				CenterFrame:SetPoint("LEFT",0,center)
				CenterFrame:SetPoint("RIGHT",0,center)
			end
			for i=1,5 do
				ResizeFrame.lh[i]:ClearAllPoints()
				ResizeFrame.lh[i]:SetPoint("CENTER",UIParent,0,(i == 1 and size or i==2 and size / 2 or i==3 and 0 or i==4 and -size / 2 or i==5 and -size)+center)
				ResizeFrame.lh[i]:SetWidth(size*2)
		
				ResizeFrame.lv[i]:ClearAllPoints()
				ResizeFrame.lv[i]:SetPoint("CENTER",UIParent,i == 1 and -size or i==2 and -size / 2 or i==3 and 0 or i==4 and size / 2 or i==5 and size,center)
				ResizeFrame.lv[i]:SetHeight(size*2)
			end
			for i=1,4 do
				for j=1,4 do
					local frame = pointsFrames[(i-1)*4+j]
					frame:ClearAllPoints()
					frame:SetPoint("TOPLEFT",UIParent,"CENTER",j==1 and -size or j==2 and -size/2 or j==3 and 0 or j==4 and size/2,(i==1 and size or i==2 and size/2 or i==3 and 0 or i==4 and -size/2)+center)
					frame:SetSize(size/2,size/2)
					for k=1,8 do
						frame.m[k]:SetSize(size/4/2,size/4/2)
					end
					frame.M:SetSize(size/4,size/4)
				end
			end
			OkButton:SetPoint("TOPRIGHT",UIParent,"CENTER",size,center-size)
		end
		
		local function ResizeFrameOnUpdate(self)
			size = self:GetLeft() - GetScreenWidth() / 2
			VWQL.ShellGameSize = size
			UpdatePos()
		end
		
		ResizeFrame:EnableMouse(true)
		ResizeFrame:SetMovable(true)
		ResizeFrame:RegisterForDrag("LeftButton")
		ResizeFrame:SetScript("OnDragStart", function(self)
			if self:IsMovable() then
				self:StartMoving()
				self:SetScript("OnUpdate", ResizeFrameOnUpdate)
			end
		end)
		ResizeFrame:SetScript("OnDragStop", function(self)
			self:StopMovingOrSizing()
			self:SetScript("OnUpdate", nil)
		end)
		
		ResizeFrame:SetClampedToScreen(true)
		ResizeFrame:SetClampRectInsets(-GetScreenWidth() / 2 - 1, 0, 0, 0)
		
		ResizeFrame.ArrowHelp1 = CreateFrame("PlayerModel",nil,ResizeFrame)
		ResizeFrame.ArrowHelp1:SetPoint("TOPRIGHT",-5,-10)
		ResizeFrame.ArrowHelp1:SetSize(48,48)
		ResizeFrame.ArrowHelp1:SetMouseClickEnabled(false)
		ResizeFrame.ArrowHelp1:SetMouseMotionEnabled(false)
		ResizeFrame.ArrowHelp1:SetDisplayInfo(63509)
		ResizeFrame.ArrowHelp1:SetRoll(-math.pi / 2)
	
		ResizeFrame.ArrowHelp2 = CreateFrame("PlayerModel",nil,ResizeFrame)
		ResizeFrame.ArrowHelp2:SetPoint("TOPLEFT",5,-10)
		ResizeFrame.ArrowHelp2:SetSize(48,48)
		ResizeFrame.ArrowHelp2:SetMouseClickEnabled(false)
		ResizeFrame.ArrowHelp2:SetMouseMotionEnabled(false)
		ResizeFrame.ArrowHelp2:SetDisplayInfo(63509)
		ResizeFrame.ArrowHelp2:SetRoll(math.pi / 2)
		
		ResizeFrame:SetFrameStrata("DIALOG")
		
		CenterFrame = CreateFrame("Frame",nil,UIParent)
		CenterFrame:SetPoint("LEFT",0,0)
		CenterFrame:SetPoint("RIGHT",0,0)
		CenterFrame:SetHeight(6)
		CenterFrame:Hide()
		
		CenterFrame.b = CenterFrame:CreateTexture(nil,"BACKGROUND")
		CenterFrame.b:SetAllPoints()
		CenterFrame.b:SetColorTexture(0.04,0.04,0.04,.9)
		
		local function OnUpdateCenter(self)
			center = self:GetTop() - GetScreenHeight() / 2
			VWQL.ShellGameCenter = center
			UpdatePos()
		end
		
		CenterFrame:EnableMouse(true)
		CenterFrame:SetMovable(true)
		CenterFrame:RegisterForDrag("LeftButton")
		CenterFrame:SetScript("OnDragStart", function(self)
			if self:IsMovable() then
				self:StartMoving()
				self:SetScript("OnUpdate", OnUpdateCenter)
			end
		end)
		CenterFrame:SetScript("OnDragStop", function(self)
			self:StopMovingOrSizing()
			self:SetScript("OnUpdate", nil)
		end)
		
		CenterFrame:SetClampedToScreen(true)
		CenterFrame:SetClampRectInsets(0, 0, 0, 0)
		
		CenterFrame.ArrowHelp1 = CreateFrame("PlayerModel",nil,CenterFrame)
		CenterFrame.ArrowHelp1:SetPoint("BOTTOMLEFT",CenterFrame,"TOPLEFT",10,5)
		CenterFrame.ArrowHelp1:SetSize(48,48)
		CenterFrame.ArrowHelp1:SetMouseClickEnabled(false)
		CenterFrame.ArrowHelp1:SetMouseMotionEnabled(false)
		CenterFrame.ArrowHelp1:SetDisplayInfo(63509)
		CenterFrame.ArrowHelp1:SetRoll(-math.pi)
	
		CenterFrame.ArrowHelp2 = CreateFrame("PlayerModel",nil,CenterFrame)
		CenterFrame.ArrowHelp2:SetPoint("TOPLEFT",CenterFrame,"BOTTOMLEFT",10,-5)
		CenterFrame.ArrowHelp2:SetSize(48,48)
		CenterFrame.ArrowHelp2:SetMouseClickEnabled(false)
		CenterFrame.ArrowHelp2:SetMouseMotionEnabled(false)
		CenterFrame.ArrowHelp2:SetDisplayInfo(63509)
		--CenterFrame.ArrowHelp2:SetRoll(math.pi)
		
		OkButton:SetScript("OnClick",function(self)
			if ResizeFrame:IsShown() then
				ResizeFrame:Hide()
				CenterFrame:Hide()
				VWQL.ShellGameLocked = true
				self:SetText("WQL: Resize")
			else
				ResizeFrame:Show()
				CenterFrame:Show()
				self:SetText("WQL: Lock")
			end
		end)
	end
		
	local function ShellGameEnable()
		CreateShellGame()
		print("世界任务列表：小助手已加载")
		size,center = VWQL.ShellGameSize or size,VWQL.ShellGameCenter or center
		UpdatePos(true)
		if not VWQL.ShellGameLocked then
			ResizeFrame:Show()
			CenterFrame:Show()
			OkButton:SetText("WQL: Lock")
		else
			OkButton:SetText("WQL: Resize")	
		end
		for i=1,16 do
			pointsFrames[i]:Show()
			pointsFrames[i].M:ClearModel()
		end
		OkButton:Show()
		CloseButton:Show()
	end
	function ShellGameDisable()
		CreateShellGame()
		ResizeFrame:Hide()
		CenterFrame:Hide()
		for i=1,16 do
			pointsFrames[i]:Hide()
		end
		OkButton:Hide()
		CloseButton:Hide()
	end
	
	WorldQuestList.ShellGameEnable = ShellGameEnable
	WorldQuestList.ShellGameDisable = ShellGameDisable
	
	local ShellGameHelper = CreateFrame'Frame'
	ShellGameHelper:RegisterEvent('QUEST_ACCEPTED')
	ShellGameHelper:RegisterEvent('QUEST_REMOVED')
	ShellGameHelper:RegisterEvent('PLAYER_ENTERING_WORLD')
	ShellGameHelper:SetScript("OnEvent",function(self,event,arg1,arg2)
		if event == 'QUEST_ACCEPTED' then
			if arg2 and ShellGameQuests[arg2] then
				if VWQL.DisableShellGame then
					return
				end
				self:RegisterEvent('UNIT_ENTERED_VEHICLE')
				self:RegisterEvent('UNIT_EXITED_VEHICLE')
			end
		elseif event == 'QUEST_REMOVED' then
			if arg1 and ShellGameQuests[arg1] then
				ShellGameDisable()
				self:UnregisterEvent('UNIT_ENTERED_VEHICLE')
				self:UnregisterEvent('UNIT_EXITED_VEHICLE')
			end
		elseif event == 'UNIT_ENTERED_VEHICLE' then
			if arg1 ~= "player" then
				return
			end
			ShellGameEnable()			
		elseif event == 'UNIT_EXITED_VEHICLE' then
			if arg1 ~= "player" then
				return
			end
			ShellGameDisable()
		elseif event == "PLAYER_ENTERING_WORLD" then
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")
			if VWQL.DisableShellGame then
				return
			end
			for i=1,GetNumQuestLogEntries() do
				local title, _, _, _, _, _, _, questID = GetQuestLogTitle(i)
				if questID and ShellGameQuests[questID] then
					return self:GetScript("OnEvent")(self,'QUEST_ACCEPTED',i,questID)
				end
			end
		end
	end)
end


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
			local mapID = GetTaxiMapID()
			local x_count = 0
			if mapID then
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
		local prevScale = 0
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
		--local textures = C_Map.GetMapArtLayerTextures(994,1)
		for i=1,10 do
			for j=1,15 do
				local t = WorldMapButton:CreateTexture(nil,"BACKGROUND")
				texturesList[#texturesList + 1] = t
				t:SetSize(size,size)
				t:SetPoint("TOPLEFT",size*(j-1),-size*(i-1))
				t:SetTexture("Interface\\AdventureMap\\Argus\\AM_"..((i-1)*15 + j - 1))
				--t:SetTexture(textures[(i-1)*15+j])
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

WorldQuestList.TreasureData = {		--x,y,name,type,reward,note,questID if done,special checks func
	[14] = {	--Arati
--by varenne, wowhead
{0.2593,0.3532,"Horrific Apparition",1,163736,"19.4 61.2 if Horde zone control",nil},
{0.1841,0.2794,"Ragebeak",2,nil,nil,nil},
{0.2175,0.2217,"Branchlord Aldrus",2,nil,nil,nil},
{0.1327,0.3534,"Yogursa",2,nil,nil,nil},
{0.2989,0.4495,"Burning Goliath",2,163691,nil,nil},
{0.2529,0.4856,"Kovork",1,163750,"Cave at 28.83 45.47",nil},
{0.2295,0.4961,"Foulbelly",1,163735,"Cave at 28.83 45.47",nil},
{0.2940,0.5834,"Rumbling Goliath",2,163701,nil,nil},
{0.3782,0.6135,"Plaguefeather",2,nil,nil,nil},
{0.4292,0.5660,"Ruul Onestone",1,163741,nil,nil},
{0.4618,0.5209,"Thundering Goliath",2,163698,nil,nil},
{0.5080,0.4085,"Singer",1,163738,nil,53525},
{0.5084,0.3652,"Darbel Montrose",1,nil,nil,nil},
{0.5707,0.3506,"Echo of Myzrael",2,nil,nil,nil},
{0.6251,0.3084,"Cresting Goliath",2,163700,nil,nil},
{0.5694,0.5330,"Venomarus",2,nil,nil,nil},
{0.6748,0.6058,"Nimar the Slayer",1,163706,nil,nil},
{0.7953,0.2945,"Geomancer Flintdagger",1,163713,"Cave visible on map",nil},
{0.6706,0.6589,"Beastrider Kama",1,163644,nil,53504},
{0.6285,0.8120,"Zalas Witherbark",1,163745,"Cave visible on map",nil},
{0.5182,0.7562,"Man-Hunter Rog",1,nil,nil,nil},
{0.4603,0.7672,"Boulderfist Brute",1,nil,nil,nil},
{0.4931,0.8426,"Kor'gresh Coldrage",1,163744,"West Cave",nil},
{0.3304,0.3749,"Overseer Krix",2,163646,"Inside a cave",nil},
{0.5715,0.4575,"Skullripper",2,163645,nil,nil},
{0.4689,0.7872,"Molok the Crusher",1,163775,nil,nil},
{0.5104,0.5319,"Fozruk",2,163711,"Patrolling the road",nil},
{0.4927,0.4005,"Knight-Captain Aldrin",1,163578,"Alliance Friendly",nil,function() return UnitFactionGroup("player") ~= "Alliance" end},
{0.5397,0.5696,"Doomrider Helgrim",1,163579,"Horde Friendly",nil,function() return UnitFactionGroup("player") == "Alliance" end},
{0.3709,0.3921,"Doom's Howl",2,163828,"World Boss Horde Friendly",nil,function() return UnitFactionGroup("player") == "Alliance" end},
{0.3709,0.3921,"The Lion's Roar",2,163829,"World Boss Alliance Friendly",nil,function() return UnitFactionGroup("player") ~= "Alliance" end},
	},
	[864] = { -- Vol'dun
{0.4659,0.8801,"Ashvane Spoils",3,nil,"Use mine cart",50237},
{0.4978,0.7940,"Lost Explorer's Bounty",3,nil,"Climb the rock arch",51132},
{0.4451,0.2615,"Stranded Cache",3,nil,"Climb fallen tree",51135},
{0.2938,0.8747,"Zem'lan's Buried Treasure",3,nil,"Under sand pile",51137},
{0.4057,0.8574,"Deadwood Chest",3,nil,nil,52994},
{0.4820,0.6469,"Grayal's Last Offering",3,nil,"Door on East side",51093},
{0.4719,0.5846,"Sandfury Reserve",3,nil,"Path from South side",51133},
{0.5774,0.6464,"Excavator's Greed",3,nil,nil,51136},
{0.5706,0.1120,"Lost Offerings of Kimbul",3,nil,"Enter at top of temple",52992},
{0.2649,0.4536,"Sandsunken Treasure",3,nil,"Use Abandoned Bobber",53004},
{0.5053,0.8865,"Treasure Chest 1",3,nil,"",nil},
{0.4661,0.8662,"Treasure Chest 2",3,nil,"",50920},
{0.4161,0.8158,"Treasure Chest 3",3,nil,"",nil},
{0.3333,0.5159,"Treasure Chest 4",3,nil,"",50919},
{0.5242,0.1433,"Treasure Chest 5",3,nil,"",nil},
{0.6020,0.1584,"Treasure Chest 6",3,nil,"",nil},
{0.6125,0.3087,"Treasure Chest 7",3,nil,"",nil},
{0.5124,0.3519,"Treasure Chest 8",3,nil,"",nil},
{0.3844,0.4773,"Treasure Chest 9",3,nil,"",nil},
{0.5403,0.5471,"Treasure Chest 10",3,nil,"",nil},
{0.5653,0.6990,"Treasure Chest 11",3,nil,"",nil},
{0.5241,0.7938,"Treasure Chest 12",3,nil,"",nil},
{0.5051,0.7215,"Treasure Chest 13",3,nil,"",nil},
{0.5750,0.5505,"Treasure Chest 14",3,nil,"Road up the hill: 58.32, 53.15",50928},
{0.5458,0.7542,"Treasure Chest 15",3,nil,"",nil},
{0.5222,0.8338,"Treasure Chest 16",3,nil,"",nil},
{0.4557,0.8809,"Treasure Chest 17",3,nil,"",nil},
{0.3248,0.8183,"Treasure Chest 18",3,nil,"",50924},
{0.2777,0.6991,"Treasure Chest 19",3,nil,"",nil},
{0.3652,0.4194,"Treasure Chest 20",3,nil,"",nil},
{0.4747,0.4492,"Treasure Chest 21",3,nil,"",nil},
{0.4715,0.5032,"Treasure Chest 22",3,nil,"",nil},

{0.5037,0.8160,"Ak'tar",1,nil,"On a hill, enter from north-east",nil},
{0.4904,0.8904,"Azer'tor",1,nil,"Cave entrance at 47.81 87.94",49252},
{0.4906,0.4989,"Bloated Krolusk",1,nil,"",nil},
{0.4141,0.2392,'Captain Stef "Marrow" Quin',1,nil,"",nil},
{0.6143,0.3843,"Enraged Krolusk",1,nil,"",nil},
{0.5375,0.5340,"Hivemother Kraxi",1,nil,"Cave at 53.81 51.21 from north",nil},
{0.6056,0.1756,"Jungleweb Hunter",1,nil,"",nil},
{0.3796,0.4068,"King Clickyclack",1,nil,"Cave at 37.37 40.50",nil},
{0.4906,0.7187,"Relic Hunter Hazaak",1,nil,"",nil},
{0.3271,0.6522,"Scorpox",1,nil,"",nil},
{0.4706,0.2556,"Skycaller Teskris",1,nil,"Cave at 46.15 27.15",nil},
{0.6684,0.2511,"Songstress Nahjeen",1,nil,"",nil},
{0.3709,0.4611,"Warbringer Hozzik",1,nil,"",nil},
{0.5070,0.3077,"Warmother Captive",1,nil,"",nil},
{0.5466,0.1534,"Ashmane",1,nil,"On the rock in the middle",nil},
{0.3107,0.8111,"Bajiani the Slick",1,nil,"",nil},
{0.5600,0.5346,"Bloodwing Bonepicker",1,nil,"Road up the hill: 58.32 53.15",nil},
{0.4254,0.9216,"Commodore Calhoun",1,nil,"",nil},
{0.6398,0.4784,"Gut-Gut the Glutton",1,nil,"Road up 62.46 48.11",nil},
{0.3768,0.8447,"Jumbo Sandsnapper",1,nil,"",nil},
{0.3520,0.5164,"Kamid the Trapper",1,nil,"Road up 36.48 50.29",nil},
{0.4376,0.8623,"Nez'ara",1,nil,"In the cave",nil},
{0.4440,0.8053,"Scaleclaw Broodmother",1,nil,"",nil},
{0.2456,0.6843,"Sirokar",1,nil,"Road up 24.95 69.73",nil},
{0.5143,0.3620,"Skycarver Krakit",1,nil,"",nil},
{0.5721,0.7347,"Vathikur",1,nil,"Road up 55.48 71.21",nil},
{0.3006,0.5261,"Warlord Zothix",1,nil,"",nil},
{0.4390,0.5396,"Zunashi the Exile",1,nil,"Underground cave 44.01 52.41",nil},
{0.5580,0.3610,"Fangcaller Xorreth",2,nil,"123 lvl",nil},
{0.5677,0.0648,"Golanar",2,nil,"123 lvl",nil},
{0.3018,0.4617,"Brgl-Lrgl the Basher",2,nil,"123 lvl",nil},
	},
	[863] = { -- Nazmir
{0.7790,0.3634,"Lucky Horace's Lucky Chest",3,nil,"North of the ship",49867},
{0.4306,0.5078,"Cursed Nazmani Chest",3,nil,"Cave 42.27 50.56",49979},
{0.6210,0.3487,"Lost Nazmani Treasure",3,nil,"Underwater cave",49891},
{0.6679,0.1735,"Shipwrecked Chest",3,nil,"Climb the tree",49483},
{0.7682,0.6220,"Swallowed Naga Chest",3,nil,"Underwater Cave",50045},
{0.7788,0.4635,"Partially-Digested Treasure",3,nil,"In dead hippo mouth",50061},
{0.3566,0.8560,'"Cleverly" Disguised Chest',3,nil,"small cave with eggs",49885},
{0.4277,0.2620,"Offering to Bwonsamdi",3,160053,"Climbe the tree",49484},
{0.4623,0.8292,"Venomous Seal",3,nil,"In ruins",49889},
{0.3545,0.5498,"Wunja's Trove",3,nil,"In small cave",49313},
{0.5942,0.5608,"Treasure Chest 1",3,nil,"",49899},
{0.7649,0.4861,"Treasure Chest 2",3,nil,"",50893},
{0.7187,0.3400,"Treasure Chest 3",3,nil,"",49924},
{0.5435,0.2157,"Treasure Chest 4",3,nil,"",49925},
{0.4944,0.2916,"Treasure Chest 5",3,nil,"",nil},
{0.4108,0.5097,"Treasure Chest 6",3,nil,"",49916},
{0.3839,0.2675,"Treasure Chest 7",3,nil,"",nil},
{0.5189,0.3165,"Treasure Chest 8",3,nil,"",nil},
{0.6145,0.5762,"Treasure Chest 9",3,nil,"",nil},
{0.3316,0.4366,"Treasure Chest 10",3,nil,"",50894},
{0.4011,0.5709,"Treasure Chest 11",3,nil,"",nil},

{0.6781,0.2972,"Ancient Jawbreaker",1,nil,"",48063},
{0.3280,0.2690,"Azerite-Infused Slag",1,nil,"",50563},
{0.4422,0.4873,"Uroku the Bound",1,nil,"",49305},
{0.6810,0.2023,"Chag's Challenge",1,nil,"Speak with Chag and kill Lucille",50567},
{0.8181,0.3057,"Cursed Chest",1,nil,"Summons Captain Mu'kala",48057},
{0.6895,0.5747,"Glompmaw",1,nil,"",50361},
{0.5666,0.6932,"Queen Tzxi'kik",1,nil,"",49312},
{0.4537,0.5197,"Jax'teb the Reanimated",1,nil,"Road starts at 44.61 53.97, turn left",50307},
{0.5293,0.1340,"Kal'draxa",1,nil,"Beware of Noxious Breath",47843},
{0.8169,0.6105,"Lost Scroll",1,nil,"Summons Enraged Water Elemental",50565},
{0.5896,0.3893,"Scout Skrasniss",1,nil,"",48972},
{0.3144,0.3815,"Tainted Guardian",1,nil,"",48508},
{0.3809,0.5768,"Urn of Agussu",1,nil,"",50888},
{0.4898,0.5082,"Wardrummer Zurula",1,nil,"Top of the tower",48623},
{0.3872,0.2674,"Za'amar the Queen's Blade",1,nil,"Entrance at 38.77 29.08",49469},
{0.7808,0.4451,"Lo'kuno",1,nil,"",50355},
{0.5413,0.8091,"Azerite-Infused Elemental",1,nil,"On a small island",50569},
{0.4306,0.9033,"Blood Priest Xak'lar",1,nil,"Cave 43.17 90.46",48541},
{0.5369,0.4287,"King Kooba",1,nil,"",49317},
{0.4166,0.5344,"Corpse Bringer Yal'kar",1,nil,"",48462},
{0.3353,0.8708,"Gwugnug the Cursed",1,nil,"",48638},
{0.3234,0.4332,"Gutrip",1,nil,"In a cave, road from 33.57 84.56",49231},
{0.2496,0.7778,"Infected Direhorn",1,nil,"Cave behind the waterfall at 25.44 77.68",47877},
{0.2800,0.3408,"Juba the Scarred",1,nil,"",50342},
{0.7603,0.3654,"Krubbs",1,nil,"",48052},
{0.4280,0.5949,"Bajiatha",1,nil,"",48439},
{0.5843,0.1014,"Scrounger Patriarch",1,nil,"",48980},
{0.4945,0.3714,"Totem Maker Jash'ga",1,nil,"In a small hut",48406},
{0.2970,0.5107,"Venomjaw",1,nil,"",48626},
{0.3655,0.5053,"Xu'ba",1,nil,"",50348},
{0.3888,0.7148,"Zanxib",1,nil,"",50423},
{0.5260,0.5489,"Mala'kili & Rohnkor",1,nil,"Road down from 57.84 51.01",50040},
{0.5299,0.7206,"Aiji the Accursed",2,nil,"",nil},
{0.5102,0.6628,"Maw of Shul-Nagruth",2,nil,"",nil},
{0.6220,0.6473,"Overstuffed Saurolisk",1,160987,"Blizkrik Snuckster says: Tell ya what, take whatever ya find in that thing. My way of sayin' thanks!",47827},
{0.2915,0.5586,"Abandoned Treasure",1,nil,"Shambling Ambusher",nil},
{0.4677,0.3382,"Vugthuth",2,nil,"",nil},
	},
	[862] = { -- Zuldazar
{0.5409,0.3150,"Offerings of the Chosen",3,nil,"To the right, on 2-nd floor",48938},
{0.5171,0.8690,"Spoils of Pandaria",3,nil,"Bottom floor of the ship",49936},
{0.4948,0.6526,"Warlord's Cache",3,nil,"Top of the ship",49257},
{0.6106,0.5863,"Da White Shark's Bounty",3,nil,"Event, stay close and kill npc",50947},
{0.5612,0.3806,"Cache of Secrets",3,nil,"Cave behind the waterfall",51338},
{0.6473,0.2170,"Witch Doctor's Hoard",3,nil,"Path starts from eas side of the hill",50259},
{0.5143,0.2661,"Gift of the Brokenhearted",3,nil,"Not visible on map",50582},
{0.3879,0.3443,"Dazar's Forgotten Chest",3,nil,"Road behind waterfall, right side",50707},
{0.7184,0.1676,"The Exile's Lament",3,nil,"Cave 71.16 17.67",50949},
{0.5297,0.4722,"Riches of Tor'nowa",3,nil,"Jump down from the road",51624},
{0.6582,0.2754,"Treasure Chest 1",3,nil,"",nil},
{0.5636,0.3549,"Treasure Chest 2",3,nil,"Barrow of Bwonsamdi Entrance",nil},
{0.4619,0.6058,"Treasure Chest 3",3,nil,"",nil},
{0.7958,0.1573,"Treasure Chest 4",3,nil,"",nil},
{0.5023,0.3256,"Treasure Chest 5",3,nil,"",nil},
{0.5347,0.8714,"Treasure Chest 6",3,nil,"",nil},
{0.4620,0.2365,"Treasure Chest 7",3,nil,"",nil},
{0.7071,0.3951,"Treasure Chest 8",3,nil,"",nil},
{0.4112,0.7485,"Treasure Chest 9",3,nil,"",nil},
{0.6213,0.3682,"Treasure Chest 10",3,nil,"",nil},
{0.7002,0.2013,"Treasure Chest 11",3,nil,"",nil},
{0.5777,0.1825,"Treasure Chest 12",3,nil,"",nil},
{0.4620,0.2364,"Treasure Chest 13",3,nil,"",nil},
{0.4834,0.6522,"Treasure Chest 14",3,nil,"",nil},
{0.4274,0.7363,"Treasure Chest 15",3,nil,"",nil},
{0.7716,0.5117,"Treasure Chest 16",3,nil,"",nil},
{0.6808,0.3212,"Treasure Chest 17",3,nil,"",nil},
{0.4141,0.4215,"Treasure Chest 18",3,nil,"",nil},
{0.3864,0.3773,"Treasure Chest 19",3,nil,"",nil},
{0.7506,0.1987,"Treasure Chest 20",3,nil,"",nil},
{0.8168,0.3953,"Treasure Chest 21",3,nil,"",nil},
{0.7417,0.2892,"Treasure Chest 22",3,nil,"",nil},

{0.8088,0.2131,"Atal'zul Gotaka",1,nil,"",50280},
{0.4323,0.7637,"Dark Chronicler",1,nil,"",51083},
{0.4797,0.5425,"Zayoos",1,nil,"",49972},
{0.4978,0.5733,"Avatar of Xolotal",1,nil,"Small cave, same coords",49410},
{0.4669,0.6534,"Torraske the Eternal",1,nil,"",49004},
{0.5964,0.5656,"Kul'krazahn",1,nil,"",48333},
{0.7033,0.3302,"Umbra'jin",1,nil,"Cave 70.33 33.02",nil},
{0.4211,0.3614,"Hakbi the Risen",1,nil,"Small road starts near Atal'Dazar entrance, right side",50677},
{0.4425,0.2521,"Warcrawler Karkithiss",1,nil,"Small cave near the road",50438},
{0.7433,0.3896,"Daggerjaw",1,nil,"Fish in the water",50269},
{0.7562,0.3625,"Kiboku",1,nil,"",50159},
{0.7770,0.1081,"Tambano",1,nil,"",50013},
{0.6428,0.3267,"Gahz'ralka",1,nil,"Near the waterfall",50439},
{0.5380,0.4484,"Syrawon the Dominus",1,nil,"vs Tehd & Marius",51080},
{0.5880,0.7421,"Lei-zhi",1,nil,"",49911},
{0.5968,0.1822,"Bloodbulge",1,nil,"",49267},
{0.6874,0.4841,"Kandak",1,nil,"Cave from dynos camp side 68.77 46.80",48543},
{0.7412,0.2849,"Golrakahn",1,nil,"",47792},
{0.6536,0.1020,"Darkspeaker Jo'la",1,nil,"",50693},
{0.6216,0.4620,"Vukuba",1,nil,"Use Strange Egg",50508},
{0.6072,0.6611,"Murderbeak",1,nil,"Use Chum Bucket",50281},
{0.8002,0.3598,"G'Naat",1,nil,"",50260},
{0.6663,0.3240,"Bramblewing",1,157782,"Can drop  Pterrordax Egg",50034},
{0.7664,0.2743,"Twisted Child of Rezan",2,nil,"123 ilvl",nil},
{0.6454,0.2347,"Tia'Kawan",2,nil,"123 ilvl",nil},
{0.4885,0.2920,"Umbra'rix",2,nil,"123 ilvl",nil},
{0.6279,0.1381,"Headhunter Lee'za",2,nil,"123 ilvl",nil},
	},
	[896] = { -- Drustvar
{0.3371,0.3008,"Web-Covered Chest",3,nil,"",53356},
{0.6330,0.6585,"Runebound Cache",3,nil,"Left Down Up Right",53385},
{0.3368,0.7173,"Runebound Coffer",3,nil,"Right Up Left Down",53387},
{0.5560,0.5181,"Bespelled Chest",3,nil,"Click on Witch Torch",53472},
{0.2547,0.2416,"Enchanted Chest",3,nil,"Click on Witch Torch",53474},
{0.2575,0.1995,"Merchant's Chest",3,nil,"Gorging Raven drops keys",53357},
{0.4422,0.2770,"Runebound Chest",3,nil,"Left Right Down Up",53386},
{0.1851,0.5133,"Hexed Chest",3,nil,"Click on Witch Torch",53471},
{0.6776,0.7367,"Ensorcelled Chest",3,nil,"Click on Witch Torch",53473},

{0.5993,0.3466,"Betsy",1,nil,"",47884},
{0.5890,0.1790,"Barbthorn Queen",1,nil,"",48842},
{0.6295,0.6938,"Gluttonous Yeti",1,nil,"Talk to Lost Goat",48979},
{0.4346,0.3611,"Ancient Sarcophagus",1,nil,"Inside the cave",49137},
{0.6500,0.2266,"Whargarble the Ill-Tempered",1,nil,"",49311},
{0.5084,0.2040,"Grozgore",1,nil,"",49388},
{0.5135,0.2957,"Beshol",1,nil,"",49481},
{0.6341,0.4020,"Emily Mayville",1,nil,"",49530},
{0.5657,0.2924,"Balethorn",1,nil,"",49602},
{0.3101,0.1831,"Executioner Blackwell",1,nil,"",50546},
{0.2805,0.1425,"Captain Leadfist",1,nil,"",50939},
{0.2905,0.6863,"Arclight",1,nil,"",51470},
{0.2342,0.2975,"Haywire Golem",1,nil,"",51698},
{0.3324,0.5765,"Sister Martha",1,nil,"",51748},
{0.2693,0.5962,"Braedan Whitewall",1,nil,"",51922},
{0.6657,0.4259,"Quillrat Matriarch",1,nil,"",48178},
{0.7278,0.6036,"Vicemaul",1,nil,"",48928},
{0.6658,0.5068,"Bonesquall",1,nil,"",48978},
{0.5924,0.5526,"Longfang & Henry Breakwater",1,nil,"",48981},
{0.5207,0.4697,"Cottontail Matron",1,nil,"Inside the cave",49216},
{0.5955,0.7181,"Rimestone",1,nil,"Inside the cave",49269},
{0.6793,0.6683,"Seething Cache",1,nil,"",49341},
{0.5742,0.4380,"Gorehorn",1,nil,"",49480},
{0.3220,0.4036,"Talon",1,nil,"",49528},
{0.5987,0.4478,"Nevermore",1,nil,"",49601},
{0.3548,0.3290,"Bilefang Mother",1,nil,"/way Drustvar 35.93 31.52 Cave entrance",50163},
{0.2293,0.4796,"Hyo'gi",1,nil,"",50688},
{0.3496,0.6921,"Arvon the Betrayed",1,nil,"",51383},
{0.4380,0.8828,"Avalanche",1,nil,"Patrolling",51471},
{0.2920,0.2488,"Gorged Boar",1,nil,"",51700},
{0.2424,0.2193,"Fungi Trio",1,nil,"Ernie Mick Mack",51749},
{0.3047,0.6344,'Whitney "Steelclaw" Ramsay',1,nil,"",51923},
{0.1874,0.6057,"Deathcap",1,nil,"Cave /way Drustvar 18.65 59.21",50669},
{0.2029,0.5731,"Soul Goliath",1,nil,"",nil},
{0.3571,0.1177,"Blighted Monstrosity",1,nil,"",nil},
{0.2515,0.1616,"The Caterer",1,nil,"",nil},
{0.3472,0.2062,"Matron Morana",1,nil,"",nil},
	},
	[942] = { -- Stormsong Valley
{0.5352,0.4173,"Weathered Treasure Chest",3,nil,"On the right Clearcut mountain",51449},
{0.5011,0.8623,"Frosty Treasure Chest",3,nil,"Mountain with kites",50526},
{0.5991,0.3907,"Hidden Scholar's Chest",3,nil,"On the roof",50937},
{0.5821,0.6368,"Discarded Lunchbox",3,nil,"On the highest shelf in the shed",52326},
{0.3669,0.2323,"Venture Co. Supply Chest",3,nil,"Use ladder to get on the ship",52976},
{0.4285,0.4723,"Old Ironbound Chest",3,nil,"Inside the cave with bears",50089},
{0.6722,0.4321,"Sunken Strongbox",3,nil,"Under the ship",50734},
{0.5860,0.8388,"Smuggler's Stash",3,nil,"Under the wooden platform",49811},
{0.4444,0.7353,"Carved Wooden Chest",3,nil,"On the Thornheart platform",52429},
{0.4600,0.3069,"Forgotten Chest",3,nil,"Behind the pillar",52980},

{0.7070,0.3328,"Song Mistress Dadalea",1,nil,"",52448},
{0.3413,0.3844,"Seabreaker Skoloth",1,nil,"Walking near the small island",51757},
{0.5179,0.7892,"The Lichen King",1,nil,"Inside the cave",50974},
{0.4153,0.2850,"Slickspill",1,nil,"In the puddle of oil",51958},
{0.7077,0.5464,"Galestorm",1,nil,"",50075},
{0.3148,0.6099,"Kickers",1,nil,"",52318},
{0.3475,0.6798,"Poacher Zane",1,nil,"",52469},
{0.6221,0.7357,"Grimscowl the Harebrained",1,nil,"",52329},
{0.6267,0.3407,"Croaker",1,nil,"Near the waterfall",52303},
{0.5144,0.5675,"Crushtacean",1,nil,"Underground cave",50731},
{0.4965,0.7005,"Vinespeaker Ratha",1,nil,"Underground cave",50037},
{0.3533,0.7826,"Haegol the Hammer",1,nil,"",52460},
{0.6288,0.8399,"Ice Sickle",1,nil,"Up the mountains near the waterfall",52327},
{0.4731,0.6589,"Whiplash",1,nil,"Underground",52296},
{0.4241,0.7507,"Wagga Snarltusk",1,nil,"Underground",50819},
{0.4193,0.6239,"Osca the Bloodied",1,nil,"",52461},
{0.6032,0.4644,"Taja the Tidehowler",1,nil,"Up the hill near the lake",52123},
{0.2215,0.7283,"Severus the Outcast",1,nil,"Up in the mountains",50938},
{0.3430,0.3220,"Sabertron",1,nil,"Inside the cave",51956},
{0.4111,0.7493,"Ragna",1,nil,"",50725},
{0.2925,0.6945,"Broodmother",1,nil,"In the house basement",51298},
{0.4680,0.4198,"Whirlwing",1,nil,"",52457},
{0.6450,0.6580,"Foreman Scripps",1,nil,"",49951},
{0.3848,0.5233,"Pinku'shon",1,nil,"",51959},
{0.5307,0.5063,"Deepfang",1,nil,"",50692},
{0.6648,0.4862,"Corrupted Tideskipper",1,nil,"Swimming in the river",52121},
{0.6830,0.3958,"Dagrus the Scorned",1,nil,"",50731},
{0.5307,0.6909,"Strange Mushroom Ring",1,nil,"Inside the underground cave",50024},
{0.5755,0.7432,"Squall",1,nil,"",52433},
{0.4727,0.6582,"Captain Razorspine",1,nil,"Underground",50170},
{0.6224,0.5678,"Sister Absinthe",1,nil,"",52441},
{0.4335,0.4526,"Nestmother Acada",1,nil,"Up in the mountains",51762},
{0.7270,0.6054,"Sandfang",1,nil,"",52125},
{0.5335,0.6441,"Jakala the Cruel",1,nil,"Speak with Doc Marrtens in the basement",52324},
{0.7254,0.5052,"Sandscour",1,nil,"",nil},
{0.6874,0.5147,"Reinforced Hullbreaker",1,nil,"",nil},
{0.4014,0.3732,"Pest Remover Mk. II",1,nil,"Patrolling the area",nil},
{0.6721,0.7525,"Beehemoth",1,nil,"Flying around the area",nil},
	},
	[895] = { -- Tiragarde Sound
{0.6151,0.5233,"Hay Covered Chest",3,nil,"Ride the Guardian",49963},
{0.5603,0.3319,"Precarious Noble Cache",3,nil,"",52866},
{0.7248,0.2169,"Scrimshaw Cache",3,nil,"Bolarus north cave",52870},
{0.5499,0.4608,"Soggy Treasure Map",3,nil,"From Freehold pirates, coords are for chest*",52807},
{0.9050,0.7551,"Yellowed Treasure Map",3,nil,"From Freehold pirates, coords are for chest*",52836},
{0.7249,0.5814,"Cutwater Treasure Chest",3,nil,"",50442},
{0.6178,0.6275,"Forgotten Smuggler's Stash",3,nil,"Inside the cave",52867},
{0.4898,0.3759,"Singed Treasure Map",3,nil,"From Freehold pirates, coords are for chest*",52845},

{0.7514,0.7848,"Auditor Dolp",1,nil,"",nil},
{0.3401,0.3029,"Bashmu",1,nil,"",nil},
{0.8470,0.7385,"Blackthorne",1,nil,"",nil},
{0.3842,0.2066,"Captain Wintersail",1,nil,"",nil},
{0.8978,0.7815,"Fowlmouth",1,nil,"",nil},
{0.5781,0.5705,"Gulliver",1,nil,"",nil},
{0.6835,0.2088,"Lumbergrasp Sentinel",1,nil,"",nil},
{0.6517,0.6460,"P4-N73R4",1,nil,"",nil},
{0.6480,0.5925,"Raging Swell",1,nil,"",nil},
{0.5854,0.1513,"Saurolisk Tamer Mugg",1,nil,"",nil},
{0.5570,0.3318,"Shiverscale the Toxic",1,nil,"",nil},
{0.4935,0.3613,"Squirgle of the Depths",1,nil,"",nil},
{0.6080,0.1727,"Tempestria",1,nil,"Suspicious Pile of Meat",nil},
{0.6383,0.4915,"Teres",1,nil,"",nil},
{0.4639,0.1997,"Totes",1,nil,"[Goat's Tote]",nil},
{0.7621,0.8305,"Barman Bill",1,nil,"",nil},
{0.5667,0.6994,"Black-Eyed Bart",1,nil,"",nil},
{0.8336,0.4413,"Broodmother Razora",1,nil,"",nil},
{0.7283,0.8146,"Carla Smirk",1,nil,"",nil},
{0.5998,0.2275,"Foxhollow Skyterror",1,nil,"",nil},
{0.4807,0.2334,"Kulett the Ornery",1,nil,"",nil},
{0.5809,0.4870,"Maison the Portable",1,nil,"",nil},
{0.4380,0.1771,"Merianae",1,nil,"Cave under the waterfall",nil},
{0.3946,0.1517,"Pack Leader Asenya",1,nil,"Inside the cave",nil},
{0.6909,0.6273,"Ranja",1,nil,"",nil},
{0.7602,0.2887,"Sawtooth",1,nil,"",nil},
{0.8100,0.8166,"Squacks",1,nil,"",nil},
{0.6670,0.1427,"Sythian the Swift",1,nil,"",nil},
{0.5509,0.5056,"Tentulos the Drifter",1,nil,"",nil},
{0.7003,0.5567,"Tort Jaw",1,nil,"",nil},
{0.7027,0.1283,"Twin-hearted Construct",1,nil,"Ritual Effigy",nil},
{0.5225,0.3215,"Vol'Jim",1,nil,"",nil},
{0.6151,0.5233,"Guardian of the Spring",1,nil,"Ride him to southwind station",nil},
	},
}


--- LFG features

local QuestCreationBox = CreateFrame("Frame","WQL_QuestCreationBox",UIParent)
QuestCreationBox:SetSize(350,120)
QuestCreationBox:SetPoint("CENTER",0,250)
QuestCreationBox:SetMovable(false)
QuestCreationBox:EnableMouse(true)
QuestCreationBox:SetClampedToScreen(true)
QuestCreationBox:RegisterForDrag("LeftButton")
QuestCreationBox:Hide()

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
	if LFGListFrame.EntryCreation.Name:GetText() == QuestCreationBox.Text2:GetText() then
		QuestCreationBox.Text2:SetTextColor(0,1,0)
	else
		QuestCreationBox.Text2:SetTextColor(1,1,0)
	end
end)

ELib.Templates:Border(QuestCreationBox,.22,.22,.3,1,1)
QuestCreationBox.shadow = ELib:Shadow2(QuestCreationBox,16)

local defPoints

local minIlvlReq = UnitLevel'player' >= 120 and 240 or 160

function WQL_LFG_StartQuest(questID)
	if GroupFinderFrame:IsVisible() or C_LFGList.GetActiveEntryInfo() then
		return
	end
	
	QuestCreationBox:Show()
	QuestCreationBox:SetSize(350,120)
	QuestCreationBox.PartyLeave:Hide()
	QuestCreationBox.PartyFind:Hide()
	QuestCreationBox.ListGroup:Show()

	LFGListUtil_OpenBestWindow()
	
	PVEFrame:ClearAllPoints() 
	PVEFrame:SetPoint("TOP",UIParent,"BOTTOM",0,-100)
	
	LFGListEntryCreation_Show(LFGListFrame.EntryCreation, LFGListFrame.baseFilters, 1, 0)
	
	local activityID, categoryID, filters, questName = LFGListUtil_GetQuestCategoryData(questID)
	if activityID then
		LFGListEntryCreation_Select(LFGListFrame.EntryCreation, filters, categoryID, nil, activityID)
	end

	local edit = LFGListFrame.EntryCreation.Name
	local button = QuestCreationBox.ListGroup
	local check = LFGListFrame.ApplicationViewer.AutoAcceptButton
	
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
	if not defPoints then
		return
	end
	local edit = LFGListFrame.EntryCreation.Name

	edit:ClearAllPoints()
	edit:SetPoint(unpack(defPoints[edit]))
	edit.Instructions:SetText(LFG_LIST_ENTER_NAME)

	edit:ClearFocus()
	
	if GroupFinderFrame:IsVisible() then
		PVEFrame_ToggleFrame()
	end
end)

local searchQuestID = nil
local isAfterSearch = nil

function WQL_LFG_Search(questID)
	if C_LFGList.GetActiveEntryInfo() then
		return
	end
	
	if not GroupFinderFrame:IsVisible() then
		LFGListUtil_OpenBestWindow()
	end
	
	local questName
	if type(questID)=='number' and IsShiftKeyDown() then
		questName = C_TaskQuest.GetQuestInfoByQuestID(questID)	
		questName = questName or tostring(questID)
	else
		questName = tostring(questID)
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
	LFGListCategorySelection_SelectCategory(panel, 1, 0)
	LFGListCategorySelection_StartFindGroup(panel, questName)
	
	searchQuestID = questID
end
WorldQuestList.LFG_Search = WQL_LFG_Search

hooksecurefunc("LFGListSearchPanel_SelectResult", function(self, resultID)
	if not VWQL or VWQL.DisableLFG then
		return
	end
	local id, activityID, name = C_LFGList.GetSearchResultInfo(resultID)
	if name and LFGListFrame.SearchPanel.categoryID == 1 then
		local qID = tonumber(name)
		if qID and qID > 10000 and qID < 1000000 then
			LFGListFrame.SearchPanel.SignUpButton:Click()
			LFGListApplicationDialog.SignUpButton:Click()
		end
	end
end)

hooksecurefunc("LFGListSearchEntry_Update", function(self)
	if not VWQL or VWQL.DisableLFG then
		return
	end
	local resultID = self.resultID
	local id, activityID, name = C_LFGList.GetSearchResultInfo(resultID)
	if name and LFGListFrame.SearchPanel.categoryID == 1 then
		local qID = tonumber(name)
		if qID and qID > 10000 and qID < 1000000 then
			local questName = C_TaskQuest.GetQuestInfoByQuestID(qID)
			if questName then
				self.Name:SetText(name.." |cff88ff00("..questName..")")
			end
		end
	end
end)

WorldQuestList.LFG_LastResult = {}

QuestCreationBox.PopupBlacklist = {
	[43943]=true,	[45379]=true,	[45070]=true,	[45068]=true,	[45069]=true,	[45071]=true,	[45072]=true,	[43756]=true,	[43772]=true,	[43767]=true,	[43328]=true,	[43778]=true,	[43764]=true,	[43769]=true,	[43753]=true,	[43774]=true,	[45046]=true,	[45047]=true,	[45048]=true,	[51637]=true,	[51641]=true,	[51642]=true,	[51640]=true,	[51639]=true,	[51633]=true,	[51636]=true,	[51626]=true,	[51627]=true,	[51630]=true,	[51625]=true,	[51628]=true,
	[50981]=true,[50982]=true,[50983]=true,[50984]=true,[50989]=true,[50994]=true,[50995]=true,[50996]=true,[50998]=true,[50999]=true,[51003]=true,[51005]=true,[51006]=true,[51007]=true,[51010]=true,[51011]=true,[51012]=true,[51013]=true,[51014]=true,[52331]=true,[52332]=true,[52333]=true,[52335]=true,[52336]=true,[52338]=true,[52339]=true,[52340]=true,[52341]=true,[52344]=true,[52346]=true,[52348]=true,[52349]=true,[52350]=true,[52353]=true,[52355]=true,[52356]=true,[52358]=true,[52359]=true,[52361]=true,[52362]=true,[52363]=true,[52364]=true,[52367]=true,[52368]=true,[52369]=true,[52371]=true,[52372]=true,[52373]=true,[52374]=true,[52389]=true,[52392]=true,[52393]=true,[52394]=true,[52398]=true,[52404]=true,[52405]=true,[52406]=true,[52408]=true,[52410]=true,[52416]=true,[52417]=true,[52421]=true,[52424]=true,[52425]=true,[52426]=true,[50987]=true,[52345]=true,[41206]=true,[41223]=true,[41235]=true,[41240]=true,[41267]=true,[41272]=true,[41277]=true,[41282]=true,[41287]=true,[41292]=true,[41297]=true,[41302]=true,[41311]=true,[41312]=true,[41313]=true,[41314]=true,[41326]=true,[41338]=true,[41344]=true,[41350]=true,[41633]=true,[41634]=true,[41635]=true,[41636]=true,[41637]=true,[41638]=true,[41639]=true,[41640]=true,[41641]=true,[41642]=true,[41643]=true,[41644]=true,[41645]=true,[41646]=true,[41647]=true,[41648]=true,[41649]=true,[41650]=true,[41651]=true,[41652]=true,[41653]=true,[41654]=true,[41655]=true,[41656]=true,[41657]=true,[41658]=true,[41659]=true,[41660]=true,[41661]=true,[41662]=true,[41663]=true,[41664]=true,[41665]=true,[41666]=true,[41667]=true,[41668]=true,[41669]=true,[41670]=true,[41671]=true,[41672]=true,[41673]=true,[41674]=true,[41675]=true,[41676]=true,[41677]=true,[41678]=true,[41679]=true,[41680]=true,[48318]=true,[48323]=true,[48337]=true,[48349]=true,[48359]=true,[48363]=true,[48364]=true,[48373]=true,[50985]=true,[50991]=true,[50992]=true,[50993]=true,[51000]=true,[51002]=true,[51004]=true,[51008]=true,[51015]=true,[52334]=true,[52337]=true,[52342]=true,[52347]=true,[52357]=true,[52360]=true,[52395]=true,[52396]=true,[52407]=true,[52411]=true,[52414]=true,[52418]=true,[52419]=true,[52420]=true,[52423]=true,[52427]=true,
	[51017]=true,[51021]=true,[51022]=true,[51023]=true,[51024]=true,[51025]=true,[51026]=true,[51027]=true,[51028]=true,[51029]=true,[51030]=true,[51031]=true,[51032]=true,[51033]=true,[51034]=true,[51035]=true,[51036]=true,[51037]=true,[51038]=true,[51039]=true,[51040]=true,[51041]=true,[51042]=true,[51043]=true,[51044]=true,[51045]=true,[51046]=true,[51047]=true,[51048]=true,[51049]=true,[51050]=true,[51051]=true,[52375]=true,[52376]=true,[52377]=true,[52378]=true,[52379]=true,[52380]=true,[52381]=true,[52382]=true,[52383]=true,[52385]=true,[52386]=true,[52387]=true,[52388]=true,[48358]=true,[41207]=true,[41224]=true,[41237]=true,[41288]=true,[41293]=true,[41298]=true,[41303]=true,[41315]=true,[41316]=true,[41317]=true,[41318]=true,[41327]=true,[41339]=true,[41345]=true,[41351]=true,[48338]=true,[48360]=true,[48374]=true,[52384]=true,
}

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

QuestCreationBox:RegisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED")
QuestCreationBox:RegisterEvent("LFG_LIST_APPLICANT_LIST_UPDATED")
QuestCreationBox:RegisterEvent("QUEST_TURNED_IN")
QuestCreationBox:RegisterEvent("QUEST_ACCEPTED")
QuestCreationBox:RegisterEvent("QUEST_REMOVED")
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
			if total > 0 and LFGListFrame.SearchPanel.SearchBox:IsVisible() and LFGListFrame.SearchPanel.categoryID == 1 then
				local searchQ = LFGListFrame.SearchPanel.SearchBox:GetText()
				searchQ = tonumber(searchQ)
				if searchQ and searchQ > 10000 and searchQ < 1000000 then
					LFGListFrameSearchPanelStartGroup.questID = searchQ
					LFGListFrameSearchPanelStartGroup:Show()
				end
			end
		end
	elseif event == "LFG_LIST_APPLICANT_LIST_UPDATED" then
		if not VWQL or VWQL.DisableLFG or not UnitIsGroupLeader("player", LE_PARTY_CATEGORY_HOME) or not select(9, C_LFGList.GetActiveEntryInfo()) then
			return
		end
		local active, activityID, ilvl, honorLevel, name, comment, voiceChat, duration, autoAccept, privateGroup, lfg_questID = C_LFGList.GetActiveEntryInfo()
		local questID = tonumber(name or "?")
		if not questID then
			questID = lfg_questID
		end
		if questID and questID > 10000 and questID < 1000000 then
			local tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex, displayTimeLeft = GetQuestTagInfo(questID)
			if rarity and not isElite then
				StaticPopup_Hide("LFG_LIST_AUTO_ACCEPT_CONVERT_TO_RAID")
			end
		end		
	elseif event == "QUEST_TURNED_IN" then
		if not VWQL or VWQL.DisableLFG or not arg1 then
			return
		end
		local name = select(5,C_LFGList.GetActiveEntryInfo())
		if name and name == tostring(arg1) and (not QuestCreationBox:IsVisible() or (QuestCreationBox.type ~= 1)) then
			QuestCreationBox.Text1:SetText("WQL")
			QuestCreationBox.Text2:SetText("")
			QuestCreationBox.PartyLeave:Show()

			QuestCreationBox.PartyFind:Hide()
			QuestCreationBox.ListGroup:Hide()
			
			QuestCreationBox.type = 2
			
			QuestCreationBox:Show()
			QuestCreationBox:SetSize(350,60)
		end
	elseif event == "QUEST_ACCEPTED" then
		if not VWQL or VWQL.DisableLFG or not arg2 or C_LFGList.GetActiveEntryInfo() or VWQL.DisableLFG_Popup or (GetNumGroupMembers() or 0) > 1 then
			return
		end
		if QuestUtils_IsQuestWorldQuest(arg2) and 					--is WQ
			(not QuestCreationBox:IsVisible() or (QuestCreationBox.type ~= 1)) and	--popup if not busy
			 CheckQuestPassPopup(arg2) 						--wq pass filters
		 then
			QuestCreationBox.Text1:SetText("WQL|n"..(C_TaskQuest.GetQuestInfoByQuestID(arg2) or ""))
			QuestCreationBox.Text2:SetText("")
			QuestCreationBox.PartyFind.questID = arg2
			QuestCreationBox.PartyFind:Show()

			QuestCreationBox.PartyLeave:Hide()
			QuestCreationBox.ListGroup:Hide()

			QuestCreationBox.questID = arg2
			QuestCreationBox.type = 3

			QuestCreationBox:Show()
			QuestCreationBox:SetSize(350,60)
		end		
	elseif event == "QUEST_REMOVED" then
		if QuestCreationBox:IsVisible() and QuestCreationBox.type == 3 and QuestCreationBox.questID == arg1 then
			QuestCreationBox:Hide()
		end
	end
end)

LFGListSearchPanelScrollFrame.StartGroupButton:HookScript("OnClick",function()
	if isAfterSearch then
		PVEFrame_ToggleFrame()
		WQL_LFG_StartQuest(searchQuestID)
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

local function objectiveTrackerButtons_OnClick(self,button)
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

local function ObjectiveTracker_Update_hook(reason, questID)
	for _,b in pairs(objectiveTrackerButtons) do
		if b:IsShown() and ((b.questID ~= b.parent.id or not VWQL or VWQL.DisableLFG) or (b.parent.hasGroupFinderButton)) then
			b:Hide()
		end
	end
	if not VWQL or VWQL.DisableLFG then
		return
	end
	if reason and reason ~= 1 then
		for _,module in pairs(ObjectiveTrackerFrame.MODULES) do
			if module.usedBlocks then
				for _,block in pairs(module.usedBlocks) do
					local questID = block.id
					if questID and QuestUtils_IsQuestWorldQuest(questID) and not block.hasGroupFinderButton and not WorldQuestList:IsQuestDisabledForLFG(questID) then
						local b = objectiveTrackerButtons[block]
						if not b then
							b = CreateFrame("Button",nil,block)
							objectiveTrackerButtons[block] = b
							b:SetSize(24,24)
							b:SetPoint("TOPRIGHT",-16,0)
							b:SetScript("OnClick",objectiveTrackerButtons_OnClick)
							b:SetScript("OnEnter",objectiveTrackerButtons_OnEnter)
							b:SetScript("OnLeave",objectiveTrackerButtons_OnLeave)							
							b:RegisterForClicks("LeftButtonDown","RightButtonUp")
							b.parent = block
							
							b.HighlightTexture = b:CreateTexture()
							b.HighlightTexture:SetTexture("Interface\\Buttons\\UI-Common-MouseHilight")
							b.HighlightTexture:SetSize(24,24)
							b.HighlightTexture:SetPoint("CENTER")
							b:SetHighlightTexture(b.HighlightTexture,"ADD")
							
							b.texture = b:CreateTexture(nil, "BACKGROUND")
							b.texture:SetPoint("CENTER")
							b.texture:SetSize(24,24)
							b.texture:SetAtlas("hud-microbutton-LFG-Up")
						end
						b.questID = questID
						b:Show()
					end
				end
			end
		end
	end
end

hooksecurefunc("ObjectiveTracker_Update", ObjectiveTracker_Update_hook)
C_Timer.After(5,function() ObjectiveTracker_Update_hook(2) end)


--Add Map Icons

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
							obj.WQL_rewardRibbon:Hide()
							obj.WQL_rewardRibbonText:SetText("")
							obj.TimeLowFrame:SetPoint("CENTER",-17,-17)
						end
					end
				end
				frame:RefreshAllDataProviders()
			end
		end
	end
end

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
	
	local function RibbonSetPos(self,onTop)
		self:ClearAllPoints()
		if onTop then
			self:SetPoint("BOTTOM",self:GetParent(),"TOP",0,-16)
			self:SetTexCoord(0,1,1,0)
		else
			self:SetPoint("TOP",self:GetParent(),"BOTTOM",0,16)
			self:SetTexCoord(0,1,0,1)
		end
	end
	
	local function HookOnEnter(self)
		self.pinFrameLevelType = "PIN_FRAME_LEVEL_TOPMOST"
		self:ApplyFrameLevel()
	end
	local function HookOnLeave(self)
		self.pinFrameLevelType = "PIN_FRAME_LEVEL_WORLD_QUEST"
		self:ApplyFrameLevel()
	end	
	
	function WorldQuestList:WQIcons_AddIcons(frame,pinName)
		frame = frame or WorldMapFrame
		local pins = frame.pinPools[pinName or "WorldMap_WorldQuestPinTemplate"]
		if pins and VWQL and not VWQL.DisableRewardIcons then
			for obj,_ in pairs(pins.activeObjects) do
				local icon = obj.WQL_rewardIcon
				if obj.questID then
					if not icon then
						icon = obj:CreateTexture(nil,"OVERLAY")
						obj.WQL_rewardIcon = icon
						icon:SetPoint("CENTER",0,0)
						icon:SetSize(26,26)
						
						local iconWMask = obj:CreateTexture(nil,"OVERLAY")
						obj.WQL_rewardIconWMask = iconWMask
						iconWMask:SetPoint("CENTER",0,0)
						iconWMask:SetSize(26,26)
						iconWMask:SetMask("Interface\\CharacterFrame\\TempPortraitAlphaMask")
						
						local ribbon = obj:CreateTexture(nil,"BACKGROUND")
						obj.WQL_rewardRibbon = ribbon
						ribbon:SetPoint("TOP",obj,"BOTTOM",0,16)
						ribbon:SetSize(100,40)
						ribbon:SetAtlas("UI-Frame-Neutral-Ribbon")
						--ribbon.SetPos = RibbonSetPos
						--ribbon:SetPos()
						
						local ribbonText = obj:CreateFontString(nil,"ARTWORK","GameFontWhite")
						obj.WQL_rewardRibbonText = ribbonText
						local a1,a2 = ribbonText:GetFont()
						ribbonText:SetFont(a1,18)
						ribbonText:SetPoint("CENTER",ribbon,0,-1)
						ribbonText:SetTextColor(0,0,0,1)
						
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
					local numQuestCurrencies = GetNumQuestLogRewardCurrencies(obj.questID)
					for i = 1, numQuestCurrencies do
						local name, texture, numItems, currencyID = GetQuestLogRewardCurrencyInfo(i, obj.questID)
						if currencyID == 1508 or	--Veiled Argunite
							currencyID == 1533	--Wakening Essence
						then
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
						--"poi-workorders
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
							elseif itemID == 163857 then
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
						
						if GENERAL_MAPS[GetCurrentMapAreaID()] then
							amount = 0
						end
						
						if amount > 0 then
							if not obj.WQL_rewardRibbon:IsShown() then
								obj.WQL_rewardRibbon:Show()
							end
							obj.WQL_rewardRibbonText:SetText((amountIcon and "|T"..amountIcon..":0|t" or "")..(amountColor or "")..amount)
							obj.WQL_rewardRibbon:SetWidth( (#tostring(amount) + (amountIcon and 1.5 or 0)) * 16 + 40 )
							
							obj.TimeLowFrame:SetPoint("CENTER",-22,-8)							
						elseif obj.WQL_rewardRibbon:IsShown() then
							obj.WQL_rewardRibbon:Hide()
							obj.WQL_rewardRibbonText:SetText("")	
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
							obj.WQL_rewardRibbonText:SetText("")
							obj.TimeLowFrame:SetPoint("CENTER",-17,-17)
						end
					end
					obj.WQL_questID = obj.questID
				else
					if icon then
						obj.WQL_rewardIconWMask:SetTexture()
						icon:SetTexture()
						obj.TimeLowFrame:SetPoint("CENTER",-17,-17)
					end
					obj.WQL_questID = nil
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
					obj.WQL_rewardRibbon:Hide()
					obj.WQL_rewardRibbonText:SetText("")
					obj.TimeLowFrame:SetPoint("CENTER",-17,-17)
				end
				obj.WQL_questID = nil
			end
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
			obj:SetScalingLimits(defScaleFactor, defStartScale, defEndScale)
			obj:ApplyCurrentScale()
		end
		for _,obj in pairs(pins.inactiveObjects) do
			obj:SetScalingLimits(defScaleFactor, defStartScale, defEndScale)
			obj:ApplyCurrentScale()
		end
	end
end

function WorldQuestList:WQIcons_UpdateScale()
	local pins = WorldMapFrame.pinPools["WorldMap_WorldQuestPinTemplate"]
	--if pins and VWQL and charKey and VWQL[charKey] and not VWQL[charKey].HideMap then
	if pins and VWQL then
		local startScale, endScale = defStartScale, defEndScale
		local generalMap = GENERAL_MAPS[GetCurrentMapAreaID()]
		local scaleFactor = (WorldMapFrame:IsMaximized() and 1.5 or 1) * (VWQL.MapIconsScale or 1)
		if not generalMap then
			startScale, endScale = defStartScale, defEndScale
		elseif generalMap == 2 then
			startScale, endScale = 0.15, 0.2
		elseif generalMap == 4 then
			startScale, endScale = 0.3, 0.425
		else
			startScale, endScale = 0.35, 0.425
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
