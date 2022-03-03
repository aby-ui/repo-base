-- *********************************************************
-- **               Deadly Boss Mods - Core               **
-- **              https://deadlybossmods.com             **
-- **          https://patreon.com/deadlybossmods         **
-- *********************************************************
--
-- This addon is written and copyrighted by:
--    * Paul Emmerich (Tandanu @ EU-Aegwynn) (DBM-Core)
--    * Martin Verges (Nitram @ EU-Azshara) (DBM-GUI)
--    * Adam Williams (Omegal @ US-Whisperwind) (Primary boss mod author & DBM maintainer)
--
-- The localizations are written by:
--    * enGB/enUS: Omegal				Twitter @MysticalOS
--    * deDE: Ebmor
--    * ruRU: TOM_RUS					https://curseforge.com/profiles/TOM_RUS/
--    * zhTW: Whyv						ultrashining@gmail.com
--    * koKR: Elnarfim					---
--    * zhCN: Mini Dragon				projecteurs@gmail.com
--
--
-- Special thanks to:
--    * Arta
--    * Tennberg (a lot of fixes in the enGB/enUS localization)
--    * nBlueWiz (a lot of previous fixes in the koKR localization as well as boss mod work) Contact: everfinale@gmail.com
--
local _, private = ...

local isRetail = WOW_PROJECT_ID == (WOW_PROJECT_MAINLINE or 1)
local isClassic = WOW_PROJECT_ID == (WOW_PROJECT_CLASSIC or 2)
local isBCC = WOW_PROJECT_ID == (WOW_PROJECT_BURNING_CRUSADE_CLASSIC or 5)

local DBMPrefix = isRetail and "D4" or isClassic and "D4C" or isBCC and "D4BC"
private.DBMPrefix = DBMPrefix

local L = DBM_CORE_L
local CL = DBM_COMMON_L

-------------------------------
--  Globals/Default Options  --
-------------------------------
local function releaseDate(year, month, day, hour, minute, second)
	hour = hour or 0
	minute = minute or 0
	second = second or 0
	return second + minute * 10^2 + hour * 10^4 + day * 10^6 + month * 10^8 + year * 10^10
end

local function parseCurseDate(date)
	date = tostring(date)
	if #date == 13 then
		-- support for broken curse timestamps: leading 0 in hours is missing...
		date = date:sub(1, 8) .. "0" .. date:sub(9, #date)
	end
	local year, month, day, hour, minute, second = tonumber(date:sub(1, 4)), tonumber(date:sub(5, 6)), tonumber(date:sub(7, 8)), tonumber(date:sub(9, 10)), tonumber(date:sub(11, 12)), tonumber(date:sub(13, 14))
	if year and month and day and hour and minute and second then
		return releaseDate(year, month, day, hour, minute, second)
	end
end

local function showRealDate(curseDate)
	curseDate = tostring(curseDate)
	local year, month, day, hour, minute, second = curseDate:sub(1, 4), curseDate:sub(5, 6), curseDate:sub(7, 8), curseDate:sub(9, 10), curseDate:sub(11, 12), curseDate:sub(13, 14)
	if year and month and day and hour and minute and second then
		return year.."/"..month.."/"..day.." "..hour..":"..minute..":"..second
	end
end

DBM = {
	Revision = parseCurseDate("20220302230004"),
}
-- The string that is shown as version
if isRetail then
	DBM.DisplayVersion = "9.2.3 alpha"
	DBM.ReleaseRevision = releaseDate(2022, 3, 2, 5) -- the date of the latest stable version that is available, optionally pass hours, minutes, and seconds for multiple releases in one day
elseif isClassic then
	DBM.DisplayVersion = "1.14.17 alpha"
	DBM.ReleaseRevision = releaseDate(2022, 2, 22) -- the date of the latest stable version that is available, optionally pass hours, minutes, and seconds for multiple releases in one day
elseif isBCC then
	DBM.DisplayVersion = "2.5.30 alpha"
	DBM.ReleaseRevision = releaseDate(2022, 2, 22) -- the date of the latest stable version that is available, optionally pass hours, minutes, and seconds for multiple releases in one day
end
DBM.HighestRelease = DBM.ReleaseRevision --Updated if newer version is detected, used by update nags to reflect critical fixes user is missing on boss pulls

-- support for github downloads, which doesn't support curse keyword expansion
-- just use the latest release revision
if not DBM.Revision then
	DBM.Revision = DBM.ReleaseRevision
end

function DBM:ShowRealDate(curseDate)
	return showRealDate(curseDate)
end

function DBM:ReleaseDate(year, month, day, hour, minute, second)
	return releaseDate(year, month, day, hour, minute, second)
end

local wowVersionString, wowBuild, _, wowTOC = GetBuildInfo()
local testBuild = IsTestBuild()

function DBM:GetTOC()
	return wowTOC, testBuild, wowVersionString, wowBuild
end

-- dual profile setup
local _, playerClass = UnitClass("player")
DBM_UseDualProfile = true
if playerClass == "MAGE" or playerClass == "WARLOCK" or playerClass == "ROGUE" or (not isRetail and playerClass == "HUNTER") then
	DBM_UseDualProfile = false
end
DBM_CharSavedRevision = 2

--Hard code STANDARD_TEXT_FONT since skinning mods like to taint it (or worse, set it to nil, wtf?)
local standardFont
if LOCALE_koKR then
	standardFont = "Fonts\\2002.TTF"
elseif LOCALE_zhCN then
	standardFont = "Fonts\\ARKai_T.ttf"
elseif LOCALE_zhTW then
	standardFont = "Fonts\\blei00d.TTF"
elseif LOCALE_ruRU then
	standardFont = "Fonts\\FRIZQT___CYR.TTF"
else
	standardFont = "Fonts\\FRIZQT__.TTF"
end

DBM.DefaultOptions = {
	WarningColors = {
		{r = 0.41, g = 0.80, b = 0.94}, -- Color 1 - #69CCF0 - Turqoise
		{r = 0.95, g = 0.95, b = 0.00}, -- Color 2 - #F2F200 - Yellow
		{r = 1.00, g = 0.50, b = 0.00}, -- Color 3 - #FF8000 - Orange
		{r = 1.00, g = 0.10, b = 0.10}, -- Color 4 - #FF1A1A - Red
	},
	RaidWarningSound = isRetail and 11742 or 6674,--"Sound\\Doodad\\BellTollNightElf.ogg"
	SpecialWarningSound = 8174,--"Sound\\Spells\\PVPFlagTaken.ogg"
	SpecialWarningSound2 = isRetail and 15391 or "Interface\\AddOns\\DBM-Core\\sounds\\ClassicSupport\\UR_Algalon_BHole01.ogg",--"Sound\\Creature\\AlgalonTheObserver\\UR_Algalon_BHole01.ogg"
	SpecialWarningSound3 = "Interface\\AddOns\\DBM-Core\\sounds\\AirHorn.ogg",
	SpecialWarningSound4 = not isClassic and 9278 or "Interface\\AddOns\\DBM-Core\\sounds\\ClassicSupport\\HoodWolfTransformPlayer01.ogg",--"Sound\\Creature\\HoodWolf\\HoodWolfTransformPlayer01.ogg"
	SpecialWarningSound5 = isRetail and 128466 or 8826,--"Sound\\Creature\\Loathstare\\Loa_Naxx_Aggro02.ogg"
	ModelSoundValue = "Short",
	CountdownVoice = "VP:Yike",
	CountdownVoice2 = "Meicn",
	CountdownVoice3 = "Reaper",
	ChosenVoicePack2 = (GetLocale() == "zhCN" or GetLocale() == "zhTW") and "Yike" or (GetLocale() == "enUS" or GetLocale() == "enGB") and "VEM" or "None",
	VPReplacesAnnounce = true,
	VPReplacesSA1 = true,
	VPReplacesSA2 = true,
	VPReplacesSA3 = true,
	VPReplacesSA4 = true,
	VPReplacesCustom = false,
	AlwaysPlayVoice = false,
	VPDontMuteSounds = false,
	EventSoundVictory2 = "Interface\\AddOns\\DBM-Core\\sounds\\Victory\\SmoothMcGroove_Fanfare.ogg",
	EventSoundWipe = "None",
	EventSoundPullTimer = "None",
	EventSoundEngage2 = "None",
	EventSoundMusic = "None",
	EventSoundDungeonBGM = "None",
	EventSoundMusicCombined = false,
	EventDungMusicMythicFilter = true,
	EventMusicMythicFilter = true,
	Enabled = true,
	ShowWarningsInChat = true,
	ShowSWarningsInChat = true,
	WarningIconLeft = true,
	WarningIconRight = true,
	WarningIconChat = true,
	WarningAlphabetical = true,
	WarningShortText = true,
	StripServerName = true,
	ShowAllVersions = true,
	ShowReminders = true,
	ShowPizzaMessage = true,
	ShowEngageMessage = true,
	ShowDefeatMessage = true,
	ShowGuildMessages = true,
	ShowGuildMessagesPlus = false,
	AutoRespond = true,
	EnableWBSharing = true,
	WhisperStats = false,
	DisableStatusWhisper = false,
	DisableGuildStatus = false,
	HideBossEmoteFrame2 = true,
	SWarningAlphabetical = true,
	SWarnNameInNote = true,
	CustomSounds = 0,
	FilterTankSpec = true,
	FilterInterrupt2 = "TandFandBossCooldown",
	FilterInterruptNoteName = false,
	FilterDispel = true,
	FilterTrashWarnings2 = true,
	FilterVoidFormSay = true,
	--FilterSelfHud = true,
	AutologBosses = false,
	AdvancedAutologBosses = false,
	RecordOnlyBosses = false,
	LogOnlyNonTrivial = true,
	UseSoundChannel = "Master",
	LFDEnhance = true,
	WorldBossNearAlert = false,
	RLReadyCheckSound = true,
	AFKHealthWarning = false,
	AutoReplySound = true,
	HideObjectivesFrame = true,
	HideGarrisonToasts = true,
	HideGuildChallengeUpdates = true,
	HideTooltips = false,
	DisableSFX = false,
	EnableModels = true,
	GUIWidth = 800,
	GUIHeight = 600,
	GroupOptionsBySpell = true,
	GroupOptionsExcludeIcon = false,
	AutoExpandSpellGroups = not isRetail,
	--ShowSpellDescWhenExpanded = false,
	RangeFrameFrames = "radar",
	RangeFrameUpdates = "Average",
	RangeFramePoint = "CENTER",
	RangeFrameX = 50,
	RangeFrameY = -50,
	RangeFrameSound1 = "none",
	RangeFrameSound2 = "none",
	RangeFrameLocked = false,
	RangeFrameRadarPoint = "CENTER",
	RangeFrameRadarX = 100,
	RangeFrameRadarY = -100,
	InfoFramePoint = "CENTER",
	InfoFrameX = 75,
	InfoFrameY = -75,
	InfoFrameShowSelf = false,
	InfoFrameLines = 0,
	InfoFrameCols = 0,
	InfoFrameFont = "standardFont",
	InfoFrameFontSize = 12,
	InfoFrameFontStyle = "None",
	WarningDuration2 = 1.5,
	WarningPoint = "CENTER",
	WarningX = 0,
	WarningY = 260,
	WarningFont = "standardFont",
	WarningFontSize = 20,
	WarningFontStyle = "None",
	WarningFontShadow = true,
	SpecialWarningDuration2 = 1.5,
	SpecialWarningPoint = "CENTER",
	SpecialWarningX = 0,
	SpecialWarningY = 75,
	SpecialWarningFont = "standardFont",
	SpecialWarningFontSize2 = 35,
	SpecialWarningFontStyle = "THICKOUTLINE",
	SpecialWarningFontShadow = false,
	SpecialWarningIcon = true,
	SpecialWarningShortText = true,
	SpecialWarningFontCol = {1.0, 0.7, 0.0},--Yellow, with a tint of orange
	SpecialWarningFlashCol1 = {1.0, 1.0, 0.0},--Yellow
	SpecialWarningFlashCol2 = {1.0, 0.5, 0.0},--Orange
	SpecialWarningFlashCol3 = {1.0, 0.0, 0.0},--Red
	SpecialWarningFlashCol4 = {1.0, 0.0, 1.0},--Purple
	SpecialWarningFlashCol5 = {0.2, 1.0, 1.0},--Tealish
	SpecialWarningFlashDura1 = 0.3,
	SpecialWarningFlashDura2 = 0.4,
	SpecialWarningFlashDura3 = 1,
	SpecialWarningFlashDura4 = 0.7,
	SpecialWarningFlashDura5 = 1,
	SpecialWarningFlashAlph1 = 0.3,
	SpecialWarningFlashAlph2 = 0.3,
	SpecialWarningFlashAlph3 = 0.4,
	SpecialWarningFlashAlph4 = 0.4,
	SpecialWarningFlashAlph5 = 0.5,
	SpecialWarningFlash1 = true,
	SpecialWarningFlash2 = true,
	SpecialWarningFlash3 = true,
	SpecialWarningFlash4 = true,
	SpecialWarningFlash5 = true,
	SpecialWarningFlashCount1 = 1,
	SpecialWarningFlashCount2 = 1,
	SpecialWarningFlashCount3 = 3,
	SpecialWarningFlashCount4 = 2,
	SpecialWarningFlashCount5 = 3,
	SpecialWarningVibrate1 = false,
	SpecialWarningVibrate2 = false,
	SpecialWarningVibrate3 = true,
	SpecialWarningVibrate4 = true,
	SpecialWarningVibrate5 = true,
	SWarnClassColor = true,
	ArrowPosX = 0,
	ArrowPosY = -150,
	ArrowPoint = "TOP",
	-- global boss mod settings (overrides mod-specific settings for some options)
	DontShowBossAnnounces = false,
	DontShowTargetAnnouncements = true,
	DontShowSpecialWarningText = false,
	DontShowSpecialWarningFlash = false,
	DontDoSpecialWarningVibrate = false,
	DontPlaySpecialWarningSound = false,
	DontPlayTrivialSpecialWarningSound = true,
	SpamSpecRoledispel = false,
	SpamSpecRoleinterrupt = false,
	SpamSpecRoledefensive = false,
	SpamSpecRoletaunt = false,
	SpamSpecRolesoak = false,
	SpamSpecRolestack = false,
	SpamSpecRoleswitch = false,
	SpamSpecRolegtfo = false,
	DontShowBossTimers = false,
	DontShowUserTimers = false,
	DontShowFarWarnings = true,
	DontSetIcons = false,
	DontRestoreIcons = false,
	DontShowRangeFrame = false,
	DontRestoreRange = false,
	DontShowInfoFrame = false,
	DontShowHudMap2 = false,
	DontShowNameplateIcons = false,
	UseNameplateHandoff = true,
	NPAuraSize = 40,
	DontPlayCountdowns = false,
	DontSendYells = false,
	BlockNoteShare = false,
	DontShowPT2 = false,
	DontShowPTCountdownText = false,
	DontPlayPTCountdown = false,
	DontShowPTText = false,
	DontShowPTNoID = false,
	PTCountThreshold2 = 5,
	LatencyThreshold = 250,
	oRA3AnnounceConsumables = false,
	SettingsMessageShown = false,
	NewsMessageShown2 = 1,--Apparently varaible without 2 can still exist in some configs (config cleanup of no longer existing variables not working?)
	AlwaysShowSpeedKillTimer2 = false,
	ShowRespawn = true,
	ShowQueuePop = true,
	HelpMessageVersion = 3,
	MoviesSeen = {},
	MovieFilter2 = "Never",
	LastRevision = 0,
	DebugMode = false,
	DebugLevel = 1,
	RoleSpecAlert = true,
	CheckGear = true,
	WorldBossAlert = not isRetail,
	WorldBuffAlert = not isRetail,
	BadTimerAlert = false,
	BadIDAlert = false,
	AutoAcceptFriendInvite = false,
	AutoAcceptGuildInvite = false,
	FakeBWVersion = false,
	AITimer = true,
	ShortTimerText = true,
	ChatFrame = "DEFAULT_CHAT_FRAME",
	CoreSavedRevision = 1,
	SilentMode = false,
}

DBM.Mods = {}
DBM.ModLists = {}

------------------------
-- Global Identifiers --
------------------------
DBM_DISABLE_ZONE_DETECTION = newproxy(false)
DBM_OPTION_SPACER = newproxy(false)

--------------
--  Privates  --
--------------
private.modSyncSpam = {}
private.updateFunctions = {}

--------------
--  Locals  --
--------------
local bossModPrototype = {}
local mainFrame = CreateFrame("Frame", "DBMMainFrame")
local playerName = UnitName("player")
local playerLevel = UnitLevel("player")
local playerRealm = GetRealmName()
local lastCombatStarted = GetTime()
local chatPrefixShort = "<" .. L.DBM .. "> "
local usedProfile = "Default"
local dbmIsEnabled = true
-- Table variables
local newerVersionPerson, cSyncSender, eeSyncSender, iconSetRevision, iconSetPerson, loadcIds, inCombat, oocBWComms, combatInfo, bossIds, raid, autoRespondSpam, queuedBattlefield, bossHealth, bossHealthuIdCache, lastBossEngage, lastBossDefeat = {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}
-- False variables
local voiceSessionDisabled, statusGuildDisabled, statusWhisperDisabled, targetEventsRegistered, combatInitialized, healthCombatInitialized, watchFrameRestore, questieWatchRestore, bossuIdFound, timerRequestInProgress = false, false, false, false, false, false, false, false, false, false
-- Nil variables
local currentSpecID, currentSpecName, currentSpecGroup, pformat, loadOptions, checkWipe, checkBossHealth, checkCustomBossHealth, fireEvent, LastInstanceType, breakTimerStart, AddMsg, delayedFunction, handleSync, savedDifficulty, difficultyText, difficultyIndex
-- 0 variables
local dbmToc, eeSyncReceived, cSyncReceived, showConstantReminder, updateNotificationDisplayed, difficultyModifier, LastGroupSize = 0, 0, 0, 0, 0, 0, 0
local LastInstanceMapID = -1
local SWFilterDisabled = 12

local fakeBWVersion, fakeBWHash
if isRetail then
	fakeBWVersion, fakeBWHash = 235, "0ee9581"
else
	fakeBWVersion, fakeBWHash = 34, "c88d415"
end
local bwVersionResponseString = "V^%d^%s"

local bannedMods = { -- a list of "banned" (meaning they are replaced by another mod or discontinued). These mods will not be loaded by DBM (and they wont show up in the GUI)
	"DBM-Battlegrounds", --replaced by DBM-PvP
	"DBM-SiegeOfOrgrimmar",--Block legacy version. New version is "DBM-SiegeOfOrgrimmarV2"
	"DBM-HighMail",
	"DBM-ProvingGrounds-MoP",--Renamed to DBM-ProvingGrounds in 6.0 version since blizzard updated content for WoD
	"DBM-ProvingGrounds",--Renamed to DBM-Challenges going forward to include proving grounds and any new single player challendges of similar design such as mage tower artifact quests
	"DBM-VPKiwiBeta",--Renamed to DBM-VPKiwi in final version.
	"DBM-Suramar",--Renamed to DBM-Nighthold
	"DBM-KulTiras",--Merged to DBM-BfA
	"DBM-Zandalar",--Merged to DBM-BfA
	"DBM-Argus",--Merged into DBM-BrokenIsles mod
	"DBM-GarrisonInvasions",--Merged into DBM-Draenor mod
	"DBM-Azeroth-BfA",--renamed to DBM-BfA
	"DBM-BattlefieldBarrens",--Apparently people are still running this
	"DBM-RaidLeadTools", -- Killed plugin
}
if isRetail then
	table.insert(bannedMods, "DBM-ZulAman") -- Part of Cataclysm party mods
	table.insert(bannedMods, "DBM-ZG") -- Part of Cataclysm party mods
	table.insert(bannedMods, "DBM-Azeroth")--Merged into DBM-Core events mod.
end

--[InstanceID]={level,zoneType}
--zoneType: 1 = outdoor, 2 = dungeon, 3 = raid
local instanceDifficultyBylevel
-- TODO: BCC support
if isRetail then
	instanceDifficultyBylevel = {
		--World
		[0]={50,1},[1]={50, 1},--Eastern Kingdoms and Azeroth world events. These would be warfront and aniversery world bosses, so they'd be set to 50 for now. Likely 60 next year
		[530]={30, 1},--Outlands World Bosses
		[870]={30, 1},[1064]={30, 1},--MoP World Bosses
		[1116]={40, 1},[1159]={40, 1},[1331]={40, 1},[1158]={40, 1},[1153]={40, 1},[1152]={40, 1},[1330]={40, 1},[1160]={40, 1},[1154]={40, 1},[1464]={40, 1},--Wod World and Garrison Bosses
		[1220]={45, 1},[1779]={45, 1},--Legion World bosses
		[1643]={50, 1},[1642]={50, 1},[1718]={50, 1},[1943]={50, 1},[1876]={50, 1},[2105]={50, 1},[2111]={50, 1},[2275]={50, 1},--Bfa World bosses and warfronts
		[2222]={60, 1},[2374]={60, 1},--Shadowlands World Bosses
		--Raids
		[509]={30, 3},[531]={30, 3},[469]={30, 3},[409]={30, 3},--Classic Raids
		[564]={30, 3},[534]={30, 3},[532]={30, 3},[565]={30, 3},[544]={30, 3},[548]={30, 3},[580]={30, 3},[550]={30, 3},--BC Raids
		[615]={30, 3},[724]={30, 3},[649]={30, 3},[616]={30, 3},[631]={30, 3},[533]={30, 3},[249]={30, 3},[603]={30, 3},[624]={30, 3},--Wrath Raids
		[757]={35, 3},[671]={35, 3},[669]={35, 3},[967]={35, 3},[720]={35, 3},[951]={35, 3},[754]={35, 3},--Cata Raids
		[1009]={35, 3},[1008]={35, 3},[1136]={35, 3},[996]={35, 3},[1098]={35, 3},--MoP Raids
		[1205]={40, 3},[1448]={40, 3},[1228]={40, 3},--WoD Raids (yes, only 3 kekw)
		[1712]={50, 3},[1520]={50, 3},[1530]={50, 3},[1676]={50, 3},[1648]={50, 3},--Legion Raids (Set to 50 because 45 tuning makes them difficult even at 50)
		[1861]={50, 3},[2070]={50, 3},[2096]={50, 3},[2164]={50, 3},[2217]={50, 3},--BfA Raids
		[2296]={60, 3},[2450]={60, 3},[2481]={60, 3},--Shadowlands Raids (yes, only 3 kekw, seconded)
		--Dungeons
		[48]={30, 2},[230]={30, 2},[429]={30, 2},[389]={30, 2},[34]={30, 2},--Classic Dungeons
		[540]={30, 2},[558]={30, 2},[556]={30, 2},[555]={30, 2},[542]={30, 2},[546]={30, 2},[545]={30, 2},[547]={30, 2},[553]={30, 2},[554]={30, 2},[552]={30, 2},[557]={30, 2},[269]={30, 2},[560]={30, 2},[543]={30, 2},[585]={30, 2},--BC Dungeons
		[619]={30, 2},[601]={30, 2},[595]={30, 2},[600]={30, 2},[604]={30, 2},[602]={30, 2},[599]={30, 2},[576]={30, 2},[578]={30, 2},[574]={30, 2},[575]={30, 2},[608]={30, 2},[658]={30, 2},[632]={30, 2},[668]={30, 2},[650]={30, 2},--Wrath Dungeons
		[755]={35, 2},[645]={35, 2},[36]={35, 2},[670]={35, 2},[644]={35, 2},[33]={35, 2},[643]={35, 2},[725]={35, 2},[657]={35, 2},[309]={35, 2},[859]={35, 2},[568]={35, 2},[938]={35, 2},[940]={35, 2},[939]={35, 2},[646]={35, 2},--Cata Dungeons
		[960]={35, 2},[961]={35, 2},[959]={35, 2},[962]={35, 2},[994]={35, 2},[1011]={35, 2},[1007]={35, 2},[1001]={35, 2},[1004]={35, 2},--MoP Dungeons
		[1182]={40, 2},[1175]={40, 2},[1208]={40, 2},[1195]={40, 2},[1279]={40, 2},[1176]={40, 2},[1209]={40, 2},[1358]={40, 2},--WoD Dungeons
		[1501]={45, 2},[1466]={45, 2},[1456]={45, 2},[1477]={45, 2},[1458]={45, 2},[1516]={45, 2},[1571]={45, 2},[1492]={45, 2},[1544]={45, 2},[1493]={45, 2},[1651]={45, 2},[1677]={45, 2},[1753]={45, 2},--Legion Dungeons
		[1763]={50, 2},[1754]={50, 2},[1762]={50, 2},[1864]={50, 2},[1822]={50, 2},[1877]={50, 2},[1594]={50, 2},[1841]={50, 2},[1771]={50, 2},[1862]={50, 2},[2097]={50, 2},--Bfa Dungeons
		[2286]={60, 2},[2289]={60, 2},[2290]={60, 2},[2287]={60, 2},[2285]={60, 2},[2293]={60, 2},[2291]={60, 2},[2284]={60, 2},[2441]={60, 2},--Shadowlands Dungeons
	}
else
	instanceDifficultyBylevel = {
		--World
		[0]={60,1},[1]={60, 1},--Eastern Kingdoms and Azeroth world bosses. These would be warfront and aniversery world bosses, so they'd be set to 50 for now. Likely 60 next year
		[530]={70, 1},--Outlands World Bosses
		--Raids
		[509]={60, 3},[531]={60, 3},[469]={60, 3},[409]={60, 3},[533]={60, 3},[309]={60, 3},[249]={60, 3},--Classic Raids (309 is legacy ZG)
		[564]={70, 3},[534]={70, 3},[532]={70, 3},[565]={70, 3},[544]={70, 3},[548]={70, 3},[580]={70, 3},[550]={70, 3},[568]={70, 3},--BC Raids (568 is legacy ZA)
		--Dungeons
		[429]={45, 2},[389]={18, 2},[349]={52, 2},[329]={60, 2},[289]={60, 2},[230]={60, 2},[229]={60, 2},[209]={54, 2},[189]={45, 2},[129]={47, 2},[109]={60, 2},[90]={34, 2},[70]={52, 2},[48]={32, 2},[47]={42, 2},[43]={27, 2},[36]={25, 2},[34]={32, 2},[33]={30, 2},--Classic Dungeons
		[540]={70, 2},[558]={70, 2},[556]={70, 2},[555]={70, 2},[542]={70, 2},[546]={70, 2},[545]={70, 2},[547]={70, 2},[553]={70, 2},[554]={70, 2},[552]={70, 2},[557]={70, 2},[269]={70, 2},[560]={70, 2},[543]={70, 2},[585]={70, 2},--BC Dungeons
	}
end

-----------------
--  Libraries  --
-----------------
local LibStub = _G["LibStub"]

--------------------------------------------------------
--  Cache frequently used global variables in locals  --
--------------------------------------------------------
local DBM = DBM
-- these global functions are accessed all the time by the event handler
-- so caching them is worth the effort
local ipairs, pairs, next = ipairs, pairs, next
local tonumber, tostring = tonumber, tostring
local tinsert, tremove, twipe, tsort, tconcat = table.insert, table.remove, table.wipe, table.sort, table.concat
local type, select = type, select
local GetTime = GetTime
local bband = bit.band
local floor, mhuge, mmin, mmax, mrandom = math.floor, math.huge, math.min, math.max, math.random
local GetNumGroupMembers, GetRaidRosterInfo = GetNumGroupMembers, GetRaidRosterInfo
local UnitName, GetUnitName = UnitName, GetUnitName
local IsInRaid, IsInGroup, IsInInstance = IsInRaid, IsInGroup, IsInInstance
local UnitAffectingCombat, InCombatLockdown, IsFalling, IsEncounterInProgress, UnitPlayerOrPetInRaid, UnitPlayerOrPetInParty = UnitAffectingCombat, InCombatLockdown, IsFalling, IsEncounterInProgress, UnitPlayerOrPetInRaid, UnitPlayerOrPetInParty
local UnitGUID, UnitHealth, UnitHealthMax, UnitBuff, UnitDebuff, UnitAura = UnitGUID, UnitHealth, UnitHealthMax, UnitBuff, UnitDebuff, UnitAura
local UnitExists, UnitIsDead, UnitIsFriend, UnitIsUnit = UnitExists, UnitIsDead, UnitIsFriend, UnitIsUnit
local GetSpellInfo, GetDungeonInfo, GetSpellTexture, GetSpellCooldown = GetSpellInfo, C_LFGInfo and C_LFGInfo.GetDungeonInfo or GetDungeonInfo, GetSpellTexture, GetSpellCooldown
local EJ_GetEncounterInfo, EJ_GetCreatureInfo = EJ_GetEncounterInfo, EJ_GetCreatureInfo
local EJ_GetSectionInfo, GetSectionIconFlags
if C_EncounterJournal then
	EJ_GetSectionInfo, GetSectionIconFlags = C_EncounterJournal.GetSectionInfo, C_EncounterJournal.GetSectionIconFlags
end
local GetInstanceInfo = GetInstanceInfo
local GetSpecialization, GetSpecializationInfo, GetSpecializationInfoByID = GetSpecialization, GetSpecializationInfo, GetSpecializationInfoByID
local UnitDetailedThreatSituation = UnitDetailedThreatSituation
local UnitIsGroupLeader, UnitIsGroupAssistant = UnitIsGroupLeader, UnitIsGroupAssistant
local PlaySoundFile, PlaySound = PlaySoundFile, PlaySound
local Ambiguate = Ambiguate
local C_TimerNewTicker, C_TimerAfter = C_Timer.NewTicker, C_Timer.After
local IsQuestFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted

local SendAddonMessage = C_ChatInfo.SendAddonMessage

local RAID_CLASS_COLORS = _G["CUSTOM_CLASS_COLORS"] or RAID_CLASS_COLORS-- for Phanx' Class Colors

---------------------------------
--  General (local) functions  --
---------------------------------
-- checks if a given value is in an array
-- returns true if it finds the value, false otherwise
local function checkEntry(t, val)
	for _, v in ipairs(t) do
		if v == val then
			return true
		end
	end
	return false
end

local function removeEntry(t, val)
	local existed = false
	for i = #t, 1, -1 do
		if t[i] == val then
			tremove(t, i)
			existed = true
		end
	end
	return existed
end

local function OrderedTable()
	local nextkey, firstkey = {}, {}
	nextkey[nextkey] = firstkey

	local function onext(self, key)
		while key ~= nil do
			key = nextkey[key]
			local val = self[key]
			if val ~= nil then
				return key, val
			end
		end
	end

	local selfmeta = firstkey
	selfmeta.__nextkey = nextkey

	function selfmeta:__newindex(key, val)
		rawset(self, key, val)
		if nextkey[key] == nil then
			nextkey[nextkey[nextkey]] = key
			nextkey[nextkey] = key
		end
	end

	function selfmeta:__pairs() return
		onext, self, firstkey
	end

	return setmetatable({}, selfmeta)
end

--Whisper/Whisper Sync filter function
local function checkForSafeSender(sender, checkFriends, checkGuild, filterRaid, isRealIdMessage)
	if checkFriends then
		if isRetail then
			--Check Battle.net friends
			if isRealIdMessage then
				if filterRaid then
					--Since filterRaid is true, we need to get tooninfo to see if they are in raid
					local accountInfo = C_BattleNet.GetAccountInfoByID(sender)
					if accountInfo and accountInfo.gameAccountInfo then--game account info means they are logged into a bnet game
						local toonName, client = accountInfo.gameAccountInfo.characterName, accountInfo.gameAccountInfo.clientProgram or ""
						if toonName and client == BNET_CLIENT_WOW and DBM:GetRaidUnitId(toonName) then--Check if toon name exists and if client is wow and if toonName is in raid.
							return false--just set sender as unsafe
						end
					end
				end
				return true--Basically, if not trying to filter someone who's in raid with us, always return true. Non friends can't send realid/battle.net messages
			else--Non battle.net message
				--We still need to see if it's a bnet friend, even if it's not a realID message, just have to iterate over entire friendslist to find matching toonname
				local _, numBNetOnline = BNGetNumFriends()
				for i = 1, numBNetOnline do
					local accountInfo = C_BattleNet.GetFriendAccountInfo(i)
					if accountInfo and accountInfo.gameAccountInfo then
						local toonName, client = accountInfo.gameAccountInfo.characterName, accountInfo.gameAccountInfo.clientProgram or ""
						--Check if it's a bnet friend sending a non bnet whisper
						if toonName and client == BNET_CLIENT_WOW then--Check if toon name exists and if client is wow. If yes to both, we found right client
							if toonName == sender then--Now simply see if this is sender
								return not (filterRaid and DBM:GetRaidUnitId(toonName)) -- Person is in raid group and filter raid enabled
							end
						end
					end
				end
			end
		else
			--Check Battle.net friends
			local _, numBNetOnline = BNGetNumFriends()
			for i = 1, numBNetOnline do
				local presenceID = BNGetFriendInfo(i)
				if presenceID then
					local friendIndex = BNGetFriendIndex(presenceID)--Check if they are on more than one client at once (very likely with bnet launcher or mobile)
					for j = 1, BNGetNumFriendGameAccounts(friendIndex) do
						local _, toonName, client = BNGetFriendGameAccountInfo(friendIndex, j)
						if toonName and client == BNET_CLIENT_WOW then--Check if toon name exists and if client is wow. If yes to both, we found right client
							if toonName == sender then--Now simply see if this is sender
								return not (filterRaid and DBM:GetRaidUnitId(toonName)) -- Person is in raid group and filter raid enabled
							end
						else
							--Check if it's a bnet friend sending a bnet whisper who's not in game
							if presenceID == sender then
								return true
							end
						end
					end
				end
			end
		end
		--Check if it's a non bnet friend
		local friendInfo = C_FriendList.GetFriendInfo(sender)
		if friendInfo then
			return not (filterRaid and DBM:GetRaidUnitId(friendInfo.name)) -- Person is in raid group and filter raid enabled
		end
	end
	--Check Guildies (not used by whisper syncs, but used by status whispers)
	if checkGuild then
		local totalMembers, _, numOnlineAndMobileMembers = GetNumGuildMembers()
		local scanTotal = GetGuildRosterShowOffline() and totalMembers or numOnlineAndMobileMembers--Attempt CPU saving, if "show offline" is unchecked, we can reliably scan only online members instead of whole roster
		for i=1, scanTotal do
			local name = GetGuildRosterInfo(i)
			if not name then break end
			name = Ambiguate(name, "none")
			if name == sender then
				return not (filterRaid and DBM:GetRaidUnitId(name))
			end
		end
	end
	return false
end

-- automatically sends an addon message to the appropriate channel (INSTANCE_CHAT, RAID or PARTY)
local function sendSync(prefix, msg)
	msg = msg or ""
	if IsInGroup(2) and IsInInstance() then--For BGs, LFR and LFG (we also check IsInInstance() so if you're in queue but fighting something outside like a world boss, it'll sync in "RAID" instead)
		SendAddonMessage(DBMPrefix, prefix .. "\t" .. msg, "INSTANCE_CHAT")
	else
		if IsInRaid() then
			SendAddonMessage(DBMPrefix, prefix .. "\t" .. msg, "RAID")
		elseif IsInGroup(1) then
			SendAddonMessage(DBMPrefix, prefix .. "\t" .. msg, "PARTY")
		else--for solo raid
			handleSync("SOLO", playerName, prefix, strsplit("\t", msg))
		end
	end
end
private.sendSync = sendSync

--Custom sync function that should only be used for user generated sync messages
local function sendLoggedSync(prefix, msg)
	msg = msg or ""
	if IsInGroup(2) and IsInInstance() then--For BGs, LFR and LFG (we also check IsInInstance() so if you're in queue but fighting something outside like a world boss, it'll sync in "RAID" instead)
		C_ChatInfo.SendAddonMessageLogged(DBMPrefix, prefix .. "\t" .. msg, "INSTANCE_CHAT")
	else
		if IsInRaid() then
			C_ChatInfo.SendAddonMessageLogged(DBMPrefix, prefix .. "\t" .. msg, "RAID")
		elseif IsInGroup(1) then
			C_ChatInfo.SendAddonMessageLogged(DBMPrefix, prefix .. "\t" .. msg, "PARTY")
		else--for solo raid
			handleSync("SOLO", playerName, prefix, strsplit("\t", msg))
		end
	end
end

--Sync Object specifically for out in the world sync messages that have different rules than standard syncs
local function SendWorldSync(self, prefix, msg, noBNet)
	DBM:Debug("SendWorldSync running for "..prefix)
	if IsInRaid() then
		SendAddonMessage(DBMPrefix, prefix.."\t"..msg, "RAID")
	elseif IsInGroup(1) then
		SendAddonMessage(DBMPrefix, prefix.."\t"..msg, "PARTY")
	else--for solo raid
		handleSync("SOLO", playerName, prefix, strsplit("\t", msg))
	end
	if IsInGuild() then
		SendAddonMessage(DBMPrefix, prefix.."\t"..msg, "GUILD")--Even guild syncs send realm so we can keep antispam the same across realid as well.
	end
	if self.Options.EnableWBSharing and not noBNet then
		local _, numBNetOnline = BNGetNumFriends()
		local connectedServers = GetAutoCompleteRealms()
		for i = 1, numBNetOnline do
			local gameAccountID, isOnline, realmName
			if isRetail then
				local accountInfo = C_BattleNet.GetFriendAccountInfo(i)
				if accountInfo then
					gameAccountID, isOnline, realmName = accountInfo.gameAccountInfo.gameAccountID, accountInfo.gameAccountInfo.isOnline, accountInfo.gameAccountInfo.realmName
				end
			else
				local presenceID, _, _, _, _, _, _, isFriendOnline = BNGetFriendInfo(i)
				local _, _, _, _, userRealm = BNGetGameAccountInfo(presenceID)
				gameAccountID, isOnline, realmName = presenceID, isFriendOnline, userRealm
			end
			if gameAccountID and isOnline and realmName then
				local sameRealm = false
				if connectedServers then
					for j = 1, #connectedServers do
						if realmName == connectedServers[j] then
							sameRealm = true
							break
						end
					end
				else
					if realmName == playerRealm then
						sameRealm = true
					end
				end
				if sameRealm then
					BNSendGameData(gameAccountID, DBMPrefix, prefix.."\t"..msg)--Just send users realm for pull, so we can eliminate connectedServers checks on sync handler
				end
			end
		end
	end
end

local function strFromTime(time)
	if type(time) ~= "number" then time = 0 end
	time = floor(time*100)/100
	if time < 60 then
		return L.TIMER_FORMAT_SECS:format(time)
	elseif time % 60 == 0 then
		return L.TIMER_FORMAT_MINS:format(time/60)
	else
		return L.TIMER_FORMAT:format(time/60, time % 60)
	end
end

function DBM:strFromTime(time)
	return strFromTime(time)
end

do
	-- fail-safe format, replaces missing arguments with unknown
	-- note: doesn't handle cases like %%%s correctly at the moment (should become %unknown, but becomes %%s)
	-- also, the end of the format directive is not detected in all cases, but handles everything that occurs in our boss mods ;)
	--> not suitable for general-purpose use, just for our warnings and timers (where an argument like a spell-target might be nil due to missing target information from unreliable detection methods)
	local function replace(cap1)
		return cap1 == "%" and CL.UNKNOWN
	end

	function pformat(fstr, ...)
		local ok, str = pcall(format, fstr, ...)
		return ok and str or fstr:gsub("(%%+)([^%%%s<]+)", replace):gsub("%%%%", "%%")
	end
end

-- sends a whisper to a player by his or her character name or BNet presence id
-- returns true if the message was sent, nil otherwise
local function sendWhisper(target, msg)
	if type(target) == "number" then
		if not BNIsSelf(target) then -- Never send BNet whispers to ourselves
			BNSendWhisper(target, msg)
		end
	elseif type(target) == "string" then
		SendChatMessage(msg, "WHISPER", nil, target) -- Whispering to ourselves here is okay and somewhat useful for whisper-warnings
	end
end

--Another custom server name strip function that first strips out the "><" DBM wraps around playernames
local function stripServerName(cap)
	return DBM:GetShortServerName(cap:sub(2, -2))
end

--------------
--  Events  --
--------------
do
	local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
	local registeredEvents = {}
	local registeredSpellIds = {}
	local unfilteredCLEUEvents = {}
	local registeredUnitEventIds = {}
	local argsMT = {__index = {}}
	local args = setmetatable({}, argsMT)

	function argsMT.__index:IsSpellID(...)
		return tIndexOf({...}, args.spellId) ~= nil
	end

	function argsMT.__index:IsPlayer()
		-- If blizzard ever removes sourceFlags, this will automatically switch to fallback
		if args.destFlags and COMBATLOG_OBJECT_AFFILIATION_MINE then
			return bband(args.destFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0 and bband(args.destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0
		else
			return raid[args.destName] ~= nil--Unit in group, friendly
		end
	end

	function argsMT.__index:IsPlayerSource()
		-- If blizzard ever removes sourceFlags, this will automatically switch to fallback
		if args.sourceFlags and COMBATLOG_OBJECT_AFFILIATION_MINE then
			return bband(args.sourceFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0 and bband(args.sourceFlags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0
		else
			return raid[args.sourceName] ~= nil -- Unit in group, friendly
		end
	end

	function argsMT.__index:IsNPC()
		return bband(args.destFlags, COMBATLOG_OBJECT_TYPE_NPC) ~= 0
	end

	function argsMT.__index:IsPet()
		return bband(args.destFlags, COMBATLOG_OBJECT_TYPE_PET) ~= 0
	end

	function argsMT.__index:IsPetSource()
		return bband(args.sourceFlags, COMBATLOG_OBJECT_TYPE_PET) ~= 0
	end

	function argsMT.__index:IsSrcTypePlayer()
		-- If blizzard ever removes sourceFlags, this will automatically switch to fallback
		if args.sourceFlags and COMBATLOG_OBJECT_TYPE_PLAYER then
			return bband(args.sourceFlags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0
		else
			return raid[args.sourceName] ~= nil -- Unit in group, friendly
		end
	end

	function argsMT.__index:IsDestTypePlayer()
		-- If blizzard ever removes destFlags, this will automatically switch to fallback
		if args.destFlags and COMBATLOG_OBJECT_TYPE_PLAYER then
			return bband(args.destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0
		else
			return raid[args.destName] ~= nil -- Unit in group, friendly
		end
	end

	function argsMT.__index:IsSrcTypeHostile()
		-- If blizzard ever removes sourceFlags, this will automatically switch to fallback
		if args.sourceFlags and COMBATLOG_OBJECT_REACTION_HOSTILE then
			return bband(args.sourceFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0
		else
			return raid[args.sourceName] ~= nil -- Unit in group, friendly
		end
	end

	function argsMT.__index:IsDestTypeHostile()
		-- If blizzard ever removes destFlags, this will automatically switch to fallback
		if args.destFlags and COMBATLOG_OBJECT_REACTION_HOSTILE then
			return bband(args.destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0
		else
			return raid[args.destName] ~= nil -- Unit in group, friendly
		end
	end

	function argsMT.__index:GetSrcCreatureID()
		return DBM:GetCIDFromGUID(self.sourceGUID)
	end

	function argsMT.__index:GetDestCreatureID()
		return DBM:GetCIDFromGUID(self.destGUID)
	end

	local function handleEvent(self, event, ...)
		local isUnitEvent = event:sub(0, 5) == "UNIT_" and event ~= "UNIT_DIED" and event ~= "UNIT_DESTROYED"
		if self == mainFrame and isUnitEvent then
			-- UNIT_* events that come from mainFrame are _UNFILTERED variants and need their suffix
			event = event .. "_UNFILTERED"
			isUnitEvent = false -- not actually a real unit id for this function...
		end
		if not registeredEvents[event] or not dbmIsEnabled then return end
		for _, v in ipairs(registeredEvents[event]) do
			local zones = v.zones
			local handler = v[event]
			local modEvents = v.registeredUnitEvents
			if handler and (not isUnitEvent or not modEvents or modEvents[event .. ...]) and (not zones or zones[LastInstanceMapID]) and not (not v.isTrashModBossFightAllowed and v.isTrashMod and #inCombat > 0) then
				handler(v, ...)
			end
		end
	end

	local registerUnitEvent, unregisterUnitEvent, registerSpellId, unregisterSpellId, registerCLEUEvent, unregisterCLEUEvent
	do
		local frames = {} -- frames that are being used for unit events, one frame per unit id (this could be optimized, as it currently creates a new frame even for a different event, but that's not worth the effort as 90% of all calls are just boss1 anyways)

		function registerUnitEvent(mod, event, ...)
			mod.registeredUnitEvents = mod.registeredUnitEvents or {}
			for i = 1, select("#", ...) do
				local uId = select(i, ...)
				if not uId then break end
				local frame = frames[uId]
				if not frame then
					frame = CreateFrame("Frame")
					if uId == "mouseover" then
						-- work-around for mouse-over events (broken!)
						frame:SetScript("OnEvent", function(self, event, _, ...)
							-- we registered mouseover events, so we only want mouseover events, thanks.
							handleEvent(self, event, "mouseover", ...)
						end)
					else
						frame:SetScript("OnEvent", handleEvent)
					end
					frames[uId] = frame
				end
				registeredUnitEventIds[event .. uId] = (registeredUnitEventIds[event .. uId] or 0) + 1
				mod.registeredUnitEvents[event .. uId] = true
				frame:RegisterUnitEvent(event, uId)
			end
		end

		function unregisterUnitEvent(mod, event, ...)
			for i = 1, select("#", ...) do
				local uId = select(i, ...)
				if not uId then break end
				local frame = frames[uId]
				local refs = (registeredUnitEventIds[event .. uId] or 1) - 1
				registeredUnitEventIds[event .. uId] = refs
				if refs <= 0 then
					registeredUnitEventIds[event .. uId] = nil
					if frame then
						frame:UnregisterEvent(event)
					end
				end
				if mod.registeredUnitEvents and mod.registeredUnitEvents[event .. uId] then
					mod.registeredUnitEvents[event .. uId] = nil
				end
			end
			for i = #registeredEvents[event], 1, -1 do
				if registeredEvents[event][i] == mod then
					tremove(registeredEvents[event], i)
				end
			end
			if #registeredEvents[event] == 0 then
				registeredEvents[event] = nil
			end
		end

		function registerSpellId(event, spellId)
			if type(spellId) == "string" then--Something is screwed up, like SPELL_AURA_APPLIED DOSE
				DBM:AddMsg("DBM RegisterEvents Error: "..spellId.." is not a number!")
				return
			end
			local spellName = DBM:GetSpellInfo(spellId)
			if spellId and not spellName then
				DBM:AddMsg("DBM RegisterEvents Error: "..spellId.." spell id does not exist!")
				return
			end
			if not registeredSpellIds[event] then
				registeredSpellIds[event] = {}
			end
			if isClassic then
				if not registeredSpellIds[event][spellName] then--Don't register duplicate spell Names
					registeredSpellIds[event][spellName] = (registeredSpellIds[event][spellName] or 0) + 1--But classic needs spellNames
				end
			else
				registeredSpellIds[event][spellId] = (registeredSpellIds[event][spellId] or 0) + 1
			end
		end

		function unregisterSpellId(event, spellId)
			if not registeredSpellIds[event] then return end
			local spellName = DBM:GetSpellInfo(spellId)
			if spellId and not spellName then
				DBM:AddMsg("DBM unregisterSpellId Error: "..spellId.." spell id does not exist!")
				return
			end
			local regName = isClassic and spellName or spellId
			local refs = (registeredSpellIds[event][regName] or 1) - 1
			registeredSpellIds[event][regName] = refs
			if refs <= 0 then
				registeredSpellIds[event][regName] = nil
			end
		end

		--There are 2 tables. unfilteredCLEUEvents and registeredSpellIds table.
		--unfilteredCLEUEvents saves UNFILTERED cleu event count. this is count table to prevent bad unregister.
		--registeredSpellIds tables filtered table. this saves event and spell ids. works smiliar with unfilteredCLEUEvents table.
		function registerCLEUEvent(mod, event)
			local argTable = {strsplit(" ", event)}
			-- filtered cleu event. save information in registeredSpellIds table.
			if #argTable > 1 then
				event = argTable[1]
				for i = 2, #argTable do
					registerSpellId(event, tonumber(argTable[i]))
				end
			-- no args. works as unfiltered. save information in unfilteredCLEUEvents table.
			else
				unfilteredCLEUEvents[event] = (unfilteredCLEUEvents[event] or 0) + 1
			end
			registeredEvents[event] = registeredEvents[event] or {}
			tinsert(registeredEvents[event], mod)
		end

		function unregisterCLEUEvent(mod, event)
			local argTable = {strsplit(" ", event)}
			local eventCleared = false
			-- filtered cleu event. save information in registeredSpellIds table.
			if #argTable > 1 then
				event = argTable[1]
				for i = 2, #argTable do
					unregisterSpellId(event, tonumber(argTable[i]))
				end
				local remainingSpellIdCount = 0
				if registeredSpellIds[event] then
					for _, _ in pairs(registeredSpellIds[event]) do
						remainingSpellIdCount = remainingSpellIdCount + 1
					end
				end
				if remainingSpellIdCount == 0 then
					registeredSpellIds[event] = nil
					-- if unfilteredCLEUEvents and registeredSpellIds do not exists, clear registeredEvents.
					if not unfilteredCLEUEvents[event] then
						eventCleared = true
					end
				end
			-- no args. works as unfiltered. save information in unfilteredCLEUEvents table.
			else
				local refs = (unfilteredCLEUEvents[event] or 1) - 1
				unfilteredCLEUEvents[event] = refs
				if refs <= 0 then
					unfilteredCLEUEvents[event] = nil
					-- if unfilteredCLEUEvents and registeredSpellIds do not exists, clear registeredEvents.
					if not registeredSpellIds[event] then
						eventCleared = true
					end
				end
			end
			for i = #registeredEvents[event], 1, -1 do
				if registeredEvents[event][i] == mod then
					registeredEvents[event][i] = {}
					break
				end
			end
			if eventCleared then
				registeredEvents[event] = nil
			end
		end
	end

	-- UNIT_* events are special: they can take 'parameters' like this: "UNIT_HEALTH boss1 boss2" which only trigger the event for the given unit ids
	function DBM:RegisterEvents(...)
		for i = 1, select("#", ...) do
			local event = select(i, ...)
			-- spell events with special care.
			if event:sub(0, 6) == "SPELL_" and event ~= "SPELL_NAME_UPDATE" or event:sub(0, 6) == "RANGE_" or event:sub(0, 6) == "SWING_" or event == "UNIT_DIED" or event == "UNIT_DESTROYED" or event == "PARTY_KILL" then
				registerCLEUEvent(self, event)
			else
				local eventWithArgs = event
				-- unit events need special care
				if event:sub(0, 5) == "UNIT_" then
					-- unit events are limited to 8 "parameters", as there is no good reason to ever use more than 5 (it's just that the code old code supported 8 (boss1-5, target, focus))
					local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8
					event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8 = strsplit(" ", event)
					if not arg1 and event:sub(-11) ~= "_UNFILTERED" then -- no arguments given, support for legacy mods
						eventWithArgs = event .. " boss1 boss2 boss3 boss4 boss5 target"
						if isRetail then
							eventWithArgs = eventWithArgs .. " focus"
						end
						event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8 = strsplit(" ", eventWithArgs)
					end
					if event:sub(-11) == "_UNFILTERED" then
						-- we really want *all* unit ids
						mainFrame:RegisterEvent(event:sub(0, -12))
					else
						registerUnitEvent(self, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
					end
				-- spell events with filter
				else
					-- normal events
					mainFrame:RegisterEvent(event)
				end
				registeredEvents[eventWithArgs] = registeredEvents[eventWithArgs] or {}
				tinsert(registeredEvents[eventWithArgs], self)
				if event ~= eventWithArgs then
					registeredEvents[event] = registeredEvents[event] or {}
					tinsert(registeredEvents[event], self)
				end
			end
		end
	end

	local function unregisterUEvent(mod, event)
		if event:sub(0, 5) == "UNIT_" and event ~= "UNIT_DIED" and event ~= "UNIT_DESTROYED" then
			local eventName, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8 = strsplit(" ", event)
			if eventName:sub(-11) == "_UNFILTERED" then
				mainFrame:UnregisterEvent(eventName:sub(0, -12))
			else
				unregisterUnitEvent(mod, eventName, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
			end
		end
	end

	local function findRealEvent(t, val)
		for _, v in ipairs(t) do
			local event = strsplit(" ", v)
			if event == val then
				return v
			end
		end
	end

	function DBM:UnregisterInCombatEvents(srmOnly, srmIncluded)
		for event, mods in pairs(registeredEvents) do
			if srmOnly then
				local i = 1
				while mods[i] do
					if mods[i] == self and event == "SPELL_AURA_REMOVED" then
						local findEvent = findRealEvent(self.inCombatOnlyEvents, "SPELL_AURA_REMOVED")
						if findEvent then
							unregisterCLEUEvent(self, findEvent)
							break
						end
					end
					i = i +1
				end
			elseif (event:sub(0, 6) == "SPELL_"and event ~= "SPELL_NAME_UPDATE" or event:sub(0, 6) == "RANGE_") then
				local i = 1
				while mods[i] do
					if mods[i] == self and (srmIncluded or event ~= "SPELL_AURA_REMOVED") then
						local findEvent = findRealEvent(self.inCombatOnlyEvents, event)
						if findEvent then
							unregisterCLEUEvent(self, findEvent)
							break
						end
					end
					i = i +1
				end
			else
				local match = false
				for i = #mods, 1, -1 do
					if mods[i] == self and checkEntry(self.inCombatOnlyEvents, event) then
						tremove(mods, i)
						match = true
					end
				end
				if #mods == 0 or (match and event:sub(0, 5) == "UNIT_" and event:sub(-11) ~= "_UNFILTERED" and event ~= "UNIT_DIED" and event ~= "UNIT_DESTROYED") then -- unit events have their own reference count
					unregisterUEvent(self, event)
				end
				if #mods == 0 then
					registeredEvents[event] = nil
				end
			end
		end
	end

	function DBM:RegisterShortTermEvents(...)
		local _shortTermRegisterEvents = {...}
		for k, v in pairs(_shortTermRegisterEvents) do
			if v:sub(0, 5) == "UNIT_" and v:sub(-11) ~= "_UNFILTERED" and not v:find(" ") and v ~= "UNIT_DIED" and v ~= "UNIT_DESTROYED" then
				-- legacy event, oh noes
				_shortTermRegisterEvents[k] = v .. " boss1 boss2 boss3 boss4 boss5 target focus"
			end
		end
		self.shortTermEventsRegistered = 1
		self:RegisterEvents(unpack(_shortTermRegisterEvents))
		-- Fix so we can register multiple short term events. Use at your own risk, as unsucribing will cause
		-- all short term events to unregister.
		if not self.shortTermRegisterEvents then
			self.shortTermRegisterEvents = {}
		end
		for k, v in pairs(_shortTermRegisterEvents) do
			self.shortTermRegisterEvents[k] = v
		end
		-- End fix
	end

	function DBM:UnregisterShortTermEvents()
		if self.shortTermRegisterEvents then
			for event, mods in pairs(registeredEvents) do
				if event:sub(0, 6) == "SPELL_" or event:sub(0, 6) == "RANGE_" then
					local i = 1
					while mods[i] do
						if mods[i] == self then
							local findEvent = findRealEvent(self.shortTermRegisterEvents, event)
							if findEvent then
								unregisterCLEUEvent(self, findEvent)
								break
							end
						end
						i = i +1
					end
				else
					local match = false
					for i = #mods, 1, -1 do
						if mods[i] == self and checkEntry(self.shortTermRegisterEvents, event) then
							tremove(mods, i)
							match = true
						end
					end
					if #mods == 0 or (match and event:sub(0, 5) == "UNIT_" and event:sub(-11) ~= "_UNFILTERED" and event ~= "UNIT_DIED" and event ~= "UNIT_DESTROYED") then
						unregisterUEvent(self, event)
					end
					if #mods == 0 then
						registeredEvents[event] = nil
					end
				end
			end
			self.shortTermEventsRegistered = nil
			self.shortTermRegisterEvents = nil
		end
	end

	DBM:RegisterEvents("ADDON_LOADED")

	function DBM:FilterRaidBossEmote(msg, ...)
		return handleEvent(nil, "CHAT_MSG_RAID_BOSS_EMOTE_FILTERED", msg:gsub("\124c%x+(.-)\124r", "%1"), ...)
	end

	local noArgTableEvents = {
		SWING_DAMAGE = true,
		SWING_MISSED = true,
		RANGE_DAMAGE = true,
		RANGE_MISSED = true,
		SPELL_DAMAGE = true,
		SPELL_BUILDING_DAMAGE = true,
		SPELL_MISSED = true,
		SPELL_ABSORBED = true,
		SPELL_HEAL = true,
		SPELL_ENERGIZE = true,
		SPELL_PERIODIC_ENERGIZE = true,
		SPELL_PERIODIC_MISSED = true,
		SPELL_PERIODIC_DAMAGE = true,
		SPELL_PERIODIC_DRAIN = true,
		SPELL_PERIODIC_LEECH = true,
		SPELL_DRAIN = true,
		SPELL_LEECH = true,
		SPELL_CAST_FAILED = true
	}
	function DBM:COMBAT_LOG_EVENT_UNFILTERED()
		local timestamp, event, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, extraArg1, extraArg2, extraArg3, extraArg4, extraArg5, extraArg6, extraArg7, extraArg8, extraArg9, extraArg10 = CombatLogGetCurrentEventInfo()
		if not registeredEvents[event] then return end
		local eventSub6 = event:sub(0, 6)
		if (eventSub6 == "SPELL_" or eventSub6 == "RANGE_") and not unfilteredCLEUEvents[event] and registeredSpellIds[event] then
			if not registeredSpellIds[event][isClassic and extraArg2 or extraArg1] then return end -- SpellName filter for Classic
		end
		-- process some high volume events without building the whole table which is somewhat faster
		-- this prevents work-around with mods that used to have their own event handler to prevent this overhead
		if noArgTableEvents[event] then
			return handleEvent(nil, event, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, extraArg1, extraArg2, extraArg3, extraArg4, extraArg5, extraArg6, extraArg7, extraArg8, extraArg9, extraArg10)
		else
			twipe(args)
			args.timestamp = timestamp
			args.event = event
			args.sourceGUID = sourceGUID
			args.sourceName = sourceName
			args.sourceFlags = sourceFlags
			args.sourceRaidFlags = sourceRaidFlags
			args.destGUID = destGUID
			args.destName = destName
			args.destFlags = destFlags
			args.destRaidFlags = destRaidFlags
			if eventSub6 == "SPELL_" then
				args.spellId, args.spellName = extraArg1, extraArg2
				if event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_REFRESH" or event == "SPELL_AURA_REMOVED" then
					args.amount = extraArg5
					if not args.sourceName then
						args.sourceName = args.destName
						args.sourceGUID = args.destGUID
						args.sourceFlags = args.destFlags
					end
				elseif event == "SPELL_AURA_APPLIED_DOSE" or event == "SPELL_AURA_REMOVED_DOSE" then
					args.amount = extraArg5
					if not args.sourceName then
						args.sourceName = args.destName
						args.sourceGUID = args.destGUID
						args.sourceFlags = args.destFlags
					end
				elseif event == "SPELL_INTERRUPT" or event == "SPELL_DISPEL" or event == "SPELL_DISPEL_FAILED" or event == "SPELL_AURA_STOLEN" then
					args.extraSpellId, args.extraSpellName = extraArg4, extraArg5
				end
			elseif event == "UNIT_DIED" or event == "UNIT_DESTROYED" then
				args.sourceName = args.destName
				args.sourceGUID = args.destGUID
				args.sourceFlags = args.destFlags
			elseif event == "ENVIRONMENTAL_DAMAGE" then
				args.environmentalType, args.amount, args.overkill, args.school, args.resisted, args.blocked, args.absorbed, args.critical, args.glancing, args.crushing = extraArg1, extraArg2, extraArg3, extraArg4, extraArg5, extraArg6, extraArg7, extraArg8, extraArg9, extraArg10
			end
			return handleEvent(nil, event, args)
		end
	end
	mainFrame:SetScript("OnEvent", handleEvent)
end

--------------
--  OnLoad  --
--------------
do
	local isLoaded = false
	local onLoadCallbacks, disabledMods = {}, {}

	local function infniteLoopNotice(self, message)
		AddMsg(self, message)
		self:Schedule(30, infniteLoopNotice, self, message)
	end

	local function runDelayedFunctions(self)
		--Check if voice pack missing
		local activeVP = self.Options.ChosenVoicePack2
		if activeVP ~= "None" then
			if not self.VoiceVersions[activeVP] or (self.VoiceVersions[activeVP] and self.VoiceVersions[activeVP] == 0) then--A voice pack is selected that does not belong
				voiceSessionDisabled = true
				--Since VEM is now bundled, users may elect to disable it by simiply disabling the module
				--let's not nag them, only remind for 3rd party because then we know user installed it themselves
				if activeVP ~= "VEM" then
					AddMsg(self, L.VOICE_MISSING)
				end
			end
		end
		--Check if any of countdown sounds are using missing voice pack
		local found1, found2, found3 = false, false, false
		for _, count in pairs(DBM:GetCountSounds()) do
			local voice = count.value
			if voice == self.Options.CountdownVoice then
				found1 = true
			end
			if voice == self.Options.CountdownVoice2 then
				found2 = true
			end
			if voice == self.Options.CountdownVoice3 then
				found3 = true
			end
		end
		if not found1 then
			AddMsg(self, L.VOICE_COUNT_MISSING:format(1, self.DefaultOptions.CountdownVoice))
			self.Options.CountdownVoice = self.DefaultOptions.CountdownVoice
		end
		if not found2 then
			AddMsg(self, L.VOICE_COUNT_MISSING:format(2, self.DefaultOptions.CountdownVoice2))
			self.Options.CountdownVoice2 = self.DefaultOptions.CountdownVoice2
		end
		if not found3 then
			AddMsg(self, L.VOICE_COUNT_MISSING:format(3, self.DefaultOptions.CountdownVoice3))
			self.Options.CountdownVoice3 = self.DefaultOptions.CountdownVoice3
		end
		self:BuildVoiceCountdownCache()
		--Break timer recovery
		--Try local settings
		if self.Options.RestoreSettingBreakTimer then
			local timer, startTime = string.split("/", self.Options.RestoreSettingBreakTimer)
			local elapsed = time() - tonumber(startTime)
			local remaining = timer - elapsed
			if remaining > 0 then
				breakTimerStart(DBM, remaining, playerName)
			else--It must have ended while we were offline, kill variable.
				self.Options.RestoreSettingBreakTimer = nil
			end
		end
		if IsInGuild() then
			SendAddonMessage(DBMPrefix, "GH", "GUILD")
		end
		if not savedDifficulty or not difficultyText or not difficultyIndex then--prevent error if savedDifficulty or difficultyText is nil
			savedDifficulty, difficultyText, difficultyIndex, LastGroupSize, difficultyModifier = self:GetCurrentInstanceDifficulty()
		end
	end

	-- register a callback that will be executed once the addon is fully loaded (ADDON_LOADED fired, saved vars are available)
	function DBM:RegisterOnLoadCallback(cb)
		if isLoaded then
			cb()
		else
			onLoadCallbacks[#onLoadCallbacks + 1] = cb
		end
	end

	function DBM:ADDON_LOADED(modname)
		if modname == "DBM-Core" and not isLoaded then
			dbmToc = tonumber(GetAddOnMetadata("DBM-Core", "X-Min-Interface" .. (isClassic and "-Classic" or isBCC and "-BCC" or "")))
			isLoaded = true
			for _, v in ipairs(onLoadCallbacks) do
				xpcall(v, geterrorhandler())
			end
			onLoadCallbacks = nil
			loadOptions(self)
			DBT:LoadOptions("DBM")
			self.AddOns = {}
			private:OnModuleLoad()
			if GetAddOnEnableState(playerName, "VEM-Core") >= 1 then
				self:Disable(true)
				self:Schedule(15, infniteLoopNotice, self, L.VEM)
				return
			end
			if GetAddOnEnableState(playerName, "DBM-Profiles") >= 1 then
				self:Disable(true)
				self:Schedule(15, infniteLoopNotice, self, L.OUTDATEDPROFILES)
				return
			end
			if GetAddOnEnableState(playerName, "DBM-SpellTimers") >= 1 then
				local version = GetAddOnMetadata("DBM-SpellTimers", "Version") or "r0"
				version = tonumber(string.sub(version, 2, 4)) or 0
				if version < 122 and not self.Options.DebugMode then
					self:Disable(true)
					self:Schedule(15, infniteLoopNotice, self, L.OUTDATEDSPELLTIMERS)
					return
				end
			end
			if GetAddOnEnableState(playerName, "DPMCore") >= 1 then
				self:Disable(true)
				self:Schedule(15, infniteLoopNotice, self, L.DPMCORE)
				return
			end
			if GetAddOnEnableState(playerName, "DBM-VictorySound") >= 1 then
				self:Disable(true)
				C_TimerAfter(15, function() AddMsg(self, L.VICTORYSOUND) end)
				return
			end
			if GetAddOnEnableState(playerName, "DBM-LDB") >= 1 then
				C_TimerAfter(15, function() AddMsg(self, L.DBMLDB) end)
			end
			if GetAddOnEnableState(playerName, "DBM-LootReminder") >= 1 then
				C_TimerAfter(15, function() AddMsg(self, L.DBMLOOTREMINDER) end)
			end
			self.Arrow:LoadPosition()
			-- LibDBIcon setup
			if type(DBM_MinimapIcon) ~= "table" then
				DBM_MinimapIcon = {}
			end
			if LibStub("LibDBIcon-1.0", true) then
				LibStub("LibDBIcon-1.0"):Register("DBM", private.dataBroker, DBM_MinimapIcon)
			end
			local soundChannels = tonumber(GetCVar("Sound_NumChannels")) or 24--if set to 24, may return nil, Defaults usually do
			--If this messes with your fps, stop raiding with a toaster. It's only fix for addon sound ducking.
			if soundChannels < 64 then
				SetCVar("Sound_NumChannels", 64)
			end
			self.Voices = { {text = "None",value = "None"}, }--Create voice table, with default "None" value
			self.VoiceVersions = {}
			for i = 1, GetNumAddOns() do
				local addonName = GetAddOnInfo(i)
				local enabled = GetAddOnEnableState(playerName, i)
				if GetAddOnMetadata(i, "X-DBM-Mod") then
					if enabled ~= 0 then
						if checkEntry(bannedMods, addonName) then
							AddMsg(self, "The mod " .. addonName .. " is deprecated and will not be available. Please remove the folder " .. addonName .. " from your Interface" .. (IsWindowsClient() and "\\" or "/") .. "AddOns folder to get rid of this message. Check for an updated version of " .. addonName .. " that is compatible with your game version.")
						else
							local mapIdTable = {strsplit(",", GetAddOnMetadata(i, "X-DBM-Mod-MapID") or "")}
							tinsert(self.AddOns, {
								sort			= tonumber(GetAddOnMetadata(i, "X-DBM-Mod-Sort") or mhuge) or mhuge,
								type			= GetAddOnMetadata(i, "X-DBM-Mod-Type") or "OTHER",
								category		= GetAddOnMetadata(i, "X-DBM-Mod-Category") or "Other",
								statTypes		= GetAddOnMetadata(i, "X-DBM-StatTypes") or "",
								oldOptions		= tonumber(GetAddOnMetadata(i, "X-DBM-OldOptions") or 0) == 1,
								name			= GetAddOnMetadata(i, "X-DBM-Mod-Name") or GetRealZoneText(tonumber(mapIdTable[1])) or CL.UNKNOWN,
								mapId			= mapIdTable,
								subTabs			= GetAddOnMetadata(i, "X-DBM-Mod-SubCategoriesID") and {strsplit(",", GetAddOnMetadata(i, "X-DBM-Mod-SubCategoriesID"))} or GetAddOnMetadata(i, "X-DBM-Mod-SubCategories") and {strsplit(",", GetAddOnMetadata(i, "X-DBM-Mod-SubCategories"))},
								oneFormat		= tonumber(GetAddOnMetadata(i, "X-DBM-Mod-Has-Single-Format") or 0) == 1, -- Deprecated
								hasLFR			= tonumber(GetAddOnMetadata(i, "X-DBM-Mod-Has-LFR") or 0) == 1, -- Deprecated
								hasChallenge	= tonumber(GetAddOnMetadata(i, "X-DBM-Mod-Has-Challenge") or 0) == 1, -- Deprecated
								noHeroic		= tonumber(GetAddOnMetadata(i, "X-DBM-Mod-No-Heroic") or 0) == 1, -- Deprecated
								hasMythic		= tonumber(GetAddOnMetadata(i, "X-DBM-Mod-Has-Mythic") or 0) == 1, -- Deprecated
								hasTimeWalker	= tonumber(GetAddOnMetadata(i, "X-DBM-Mod-Has-TimeWalker") or 0) == 1, -- Deprecated
								noStatistics	= tonumber(GetAddOnMetadata(i, "X-DBM-Mod-No-Statistics") or 0) == 1,
								isWorldBoss		= tonumber(GetAddOnMetadata(i, "X-DBM-Mod-World-Boss") or 0) == 1,
								isExpedition	= tonumber(GetAddOnMetadata(i, "X-DBM-Mod-Expedition") or 0) == 1,
								minRevision		= tonumber(GetAddOnMetadata(i, "X-DBM-Mod-MinCoreRevision") or 0),
								minExpansion	= tonumber(GetAddOnMetadata(i, "X-DBM-Mod-MinExpansion") or 0),
								minToc			= tonumber(GetAddOnMetadata(i, "X-Min-Interface") or 0),
								modId			= addonName,
							})
							for j = #self.AddOns[#self.AddOns].mapId, 1, -1 do
								local id = tonumber(self.AddOns[#self.AddOns].mapId[j])
								if id then
									self.AddOns[#self.AddOns].mapId[j] = id
								else
									tremove(self.AddOns[#self.AddOns].mapId, j)
								end
							end
							if self.AddOns[#self.AddOns].subTabs then
								local subTabs = self.AddOns[#self.AddOns].subTabs
								for k, _ in ipairs(subTabs) do
									--Ugly hack to inject custom string text into auto localized zone name sub cats
									if subTabs[k]:find("|") then
										local id, nameModifier = strsplit("|", subTabs[k])
										if id and nameModifier then
											id = tonumber(id)
											self.AddOns[#self.AddOns].subTabs[k] = (GetRealZoneText(id):trim() or id).." ("..nameModifier..")"
										else
											self.AddOns[#self.AddOns].subTabs[k] = (subTabs[k]):trim()
										end
									else
										local id = tonumber(subTabs[k])
										if id then
											self.AddOns[#self.AddOns].subTabs[k] = strsplit("-", GetRealZoneText(id):trim() or id)--For handling zones like Warfront: Arathi - Alliance
										else
											self.AddOns[#self.AddOns].subTabs[k] = (subTabs[k]):trim()
										end
									end
								end
							end
							if GetAddOnMetadata(i, "X-DBM-Mod-LoadCID") then
								local idTable = {strsplit(",", GetAddOnMetadata(i, "X-DBM-Mod-LoadCID"))}
								for j = 1, #idTable do
									loadcIds[tonumber(idTable[j]) or ""] = addonName
								end
							end
						end
					else
						disabledMods[#disabledMods+1] = addonName
					end
				end
				if GetAddOnMetadata(i, "X-DBM-Voice") and enabled ~= 0 then
					if checkEntry(bannedMods, addonName) then
						AddMsg(self, "The mod " .. addonName .. " is deprecated and will not be available. Please remove the folder " .. addonName .. " from your Interface" .. (IsWindowsClient() and "\\" or "/") .. "AddOns folder to get rid of this message. Check for an updated version of " .. addonName .. " that is compatible with your game version.")
					else
						C_TimerAfter(0.01, function()
							local voiceValue = GetAddOnMetadata(i, "X-DBM-Voice-ShortName")
							local voiceVersion = tonumber(GetAddOnMetadata(i, "X-DBM-Voice-Version") or 0)
							if voiceVersion > 0 then--Do not insert voice version 0 into THIS table. 0 should be used by voice packs that insert only countdown
								tinsert(self.Voices, { text = GetAddOnMetadata(i, "X-DBM-Voice-Name"), value = voiceValue })
							end
							self.VoiceVersions[voiceValue] = voiceVersion
							self:Schedule(10, self.CheckVoicePackVersion, self, voiceValue)--Still at 1 since the count sounds won't break any mods or affect filter. V2 if support countsound path
							if GetAddOnMetadata(i, "X-DBM-Voice-HasCount") then--Supports adding countdown options, insert new countdown into table
								DBM:AddCountSound(GetAddOnMetadata(i, "X-DBM-Voice-Name"), "VP:"..voiceValue, "Interface\\AddOns\\DBM-VP"..voiceValue.."\\count\\")
							end
						end)
					end
				end
				if GetAddOnMetadata(i, "X-DBM-CountPack") and enabled ~= 0 then
					if checkEntry(bannedMods, addonName) then
						AddMsg(self, "The mod " .. addonName .. " is deprecated and will not be available. Please remove the folder " .. addonName .. " from your Interface" .. (IsWindowsClient() and "\\" or "/") .. "AddOns folder to get rid of this message. Check for an updated version of " .. addonName .. " that is compatible with your game version.")
					else
						local loaded = LoadAddOn(addonName)
						C_TimerAfter(0.01, function()
							local voiceGlobal = GetAddOnMetadata(i, "X-DBM-CountPack-GlobalName")
							local insertFunction = _G[voiceGlobal]
							if loaded and insertFunction then
								insertFunction()
							else
								self:Debug(addonName.." failed to load at time CountPack function "..voiceGlobal.."ran", 2)
							end
						end)
					end
				end
				if GetAddOnMetadata(i, "X-DBM-VictoryPack") and enabled ~= 0 then
					if checkEntry(bannedMods, addonName) then
						AddMsg(self, "The mod " .. addonName .. " is deprecated and will not be available. Please remove the folder " .. addonName .. " from your Interface" .. (IsWindowsClient() and "\\" or "/") .. "AddOns folder to get rid of this message. Check for an updated version of " .. addonName .. " that is compatible with your game version.")
					else
						local loaded = LoadAddOn(addonName)
						C_TimerAfter(0.01, function()
							local victoryGlobal = GetAddOnMetadata(i, "X-DBM-VictoryPack-GlobalName")
							local insertFunction = _G[victoryGlobal]
							if loaded and insertFunction then
								insertFunction()
							else
								self:Debug(addonName.." failed to load at time VictoryPack function "..victoryGlobal.." ran", 2)
							end
						end)
					end
				end
				if GetAddOnMetadata(i, "X-DBM-DefeatPack") and enabled ~= 0 then
					if checkEntry(bannedMods, addonName) then
						AddMsg(self, "The mod " .. addonName .. " is deprecated and will not be available. Please remove the folder " .. addonName .. " from your Interface" .. (IsWindowsClient() and "\\" or "/") .. "AddOns folder to get rid of this message. Check for an updated version of " .. addonName .. " that is compatible with your game version.")
					else
						local loaded = LoadAddOn(addonName)
						C_TimerAfter(0.01, function()
							local defeatGlobal = GetAddOnMetadata(i, "X-DBM-DefeatPack-GlobalName")
							local insertFunction = _G[defeatGlobal]
							if loaded and insertFunction then
								insertFunction()
							else
								self:Debug(addonName.." failed to load at time DefeatPack function "..defeatGlobal.." ran", 2)
							end
						end)
					end
				end
				if GetAddOnMetadata(i, "X-DBM-MusicPack") and enabled ~= 0 then
					if checkEntry(bannedMods, addonName) then
						AddMsg(self, "The mod " .. addonName .. " is deprecated and will not be available. Please remove the folder " .. addonName .. " from your Interface" .. (IsWindowsClient() and "\\" or "/") .. "AddOns folder to get rid of this message. Check for an updated version of " .. addonName .. " that is compatible with your game version.")
					else
						local loaded = LoadAddOn(addonName)
						C_TimerAfter(0.01, function()
							local musicGlobal = GetAddOnMetadata(i, "X-DBM-MusicPack-GlobalName")
							local insertFunction = _G[musicGlobal]
							if loaded and insertFunction then
								insertFunction()
							else
								self:Debug(addonName.." failed to load at time MusicPack function "..musicGlobal.." ran", 2)
							end
						end)
					end
				end
			end
			tsort(self.AddOns, function(v1, v2) return v1.sort < v2.sort end)
			self:RegisterEvents(
				"COMBAT_LOG_EVENT_UNFILTERED",
				"GROUP_ROSTER_UPDATE",
				"INSTANCE_GROUP_SIZE_CHANGED",
				"CHAT_MSG_ADDON",
				"CHAT_MSG_ADDON_LOGGED",
				"BN_CHAT_MSG_ADDON",
				"PLAYER_REGEN_DISABLED",
				"PLAYER_REGEN_ENABLED",
				"INSTANCE_ENCOUNTER_ENGAGE_UNIT",
				"ENCOUNTER_START",
				"ENCOUNTER_END",
				"BOSS_KILL",
				"UNIT_DIED",
				"UNIT_DESTROYED",
				"UNIT_HEALTH mouseover target focus player",
				"CHAT_MSG_WHISPER",
				"CHAT_MSG_BN_WHISPER",
				"CHAT_MSG_MONSTER_YELL",
				"CHAT_MSG_MONSTER_EMOTE",
				"CHAT_MSG_MONSTER_SAY",
				"CHAT_MSG_RAID_BOSS_EMOTE",
				"RAID_BOSS_EMOTE",
				"RAID_BOSS_WHISPER",
				"PLAYER_ENTERING_WORLD",
				"READY_CHECK",
				"UPDATE_BATTLEFIELD_STATUS",
				"PLAY_MOVIE",
				"CINEMATIC_START",
				"CINEMATIC_STOP",
				"PLAYER_LEVEL_CHANGED",
				"PARTY_INVITE_REQUEST",
				"LOADING_SCREEN_DISABLED",
				"LOADING_SCREEN_ENABLED"
			)
			if not isClassic then -- Retail and BCC
				self:RegisterEvents(
					"LFG_PROPOSAL_FAILED",
					"LFG_PROPOSAL_SHOW",
					"LFG_PROPOSAL_SUCCEEDED",
					"LFG_ROLE_CHECK_SHOW"
				)
			end
			if isRetail then
				self:RegisterEvents(
					"CHALLENGE_MODE_RESET",
					"PLAYER_SPECIALIZATION_CHANGED",
					"SCENARIO_COMPLETED"
				)
			else -- BCC and Classic
				self:RegisterEvents(
					"CHARACTER_POINTS_CHANGED"
				)
			end
			if RolePollPopup and RolePollPopup:IsEventRegistered("ROLE_POLL_BEGIN") then
				RolePollPopup:UnregisterEvent("ROLE_POLL_BEGIN")
			end
			self:GROUP_ROSTER_UPDATE()
			C_TimerAfter(1.5, function()
				combatInitialized = true
			end)
			C_TimerAfter(20, function()--Delay UNIT_HEALTH combat start for 20 sec. (not to break Timer Recovery stuff)
				healthCombatInitialized = true
			end)
			self:Schedule(10, runDelayedFunctions, self)
		end
	end
end

-----------------
--  Callbacks  --
-----------------
do
	local callbacks = {}

	function fireEvent(event, ...)
		if not callbacks[event] then return end
		for _, v in ipairs(callbacks[event]) do
			local ok, err = pcall(v, event, ...)
			if not ok then DBM:AddMsg(("Error while executing callback %s for event %s: %s"):format(tostring(v), tostring(event), err)) end
		end
	end

	function DBM:FireEvent(event, ...)
		fireEvent(event, ...)
	end

	function DBM:IsCallbackRegistered(event, f)
		if not event or type(f) ~= "function" then
			error("Usage: IsCallbackRegistered(event, callbackFunc)", 2)
		end
		if not callbacks[event] then return end
		for i = 1, #callbacks[event] do
			if callbacks[event][i] == f then return true end
		end
		return false
	end

	function DBM:RegisterCallback(event, f)
		if not event or type(f) ~= "function" then
			error("Usage: DBM:RegisterCallback(event, callbackFunc)", 2)
		end
		callbacks[event] = callbacks[event] or {}
		tinsert(callbacks[event], f)
		return #callbacks[event]
	end

	function DBM:UnregisterCallback(event, f)
		if not event or not callbacks[event] then return end
		if f then
			if type(f) ~= "function" then
				error("Usage: UnregisterCallback(event, callbackFunc)", 2)
			end
			--> checking from the end to start and not stoping after found one result in case of a func being twice registered.
			for i = #callbacks[event], 1, -1 do
				if callbacks[event][i] == f then tremove (callbacks[event], i) end
			end
		else
			callbacks[event] = nil
		end
	end
end

--------------------------
--  OnUpdate/Scheduler  --
--------------------------
local DBMScheduler = private:GetModule("DBMScheduler")

function DBM:Schedule(t, f, ...)
	return DBMScheduler:Schedule(t, f, nil, ...)
end

function DBM:Unschedule(f, ...)
	return DBMScheduler:Unschedule(f, nil, ...)
end

---------------
--  Profile  --
---------------
function DBM:CreateProfile(name)
	if not name or name == "" or name:find(" ") then
		self:AddMsg(L.PROFILE_CREATE_ERROR)
		return
	end
	if DBM_AllSavedOptions[name] then
		self:AddMsg(L.PROFILE_CREATE_ERROR_D:format(name))
		return
	end
	-- create profile
	usedProfile = name
	DBM_UsedProfile = usedProfile
	DBM_AllSavedOptions[usedProfile] = DBM_AllSavedOptions[usedProfile] or {}
	self:AddDefaultOptions(DBM_AllSavedOptions[usedProfile], self.DefaultOptions)
	self.Options = DBM_AllSavedOptions[usedProfile]
	-- rearrange position
	DBT:CreateProfile("DBM")
	self:RepositionFrames()
	self:AddMsg(L.PROFILE_CREATED:format(name))
end

function DBM:ApplyProfile(name)
	if not name or not DBM_AllSavedOptions[name] then
		self:AddMsg(L.PROFILE_APPLY_ERROR:format(name or CL.UNKNOWN))
		return
	end
	usedProfile = name
	DBM_UsedProfile = usedProfile
	self:AddDefaultOptions(DBM_AllSavedOptions[usedProfile], self.DefaultOptions)
	self.Options = DBM_AllSavedOptions[usedProfile]
	-- rearrange position
	DBT:ApplyProfile("DBM")
	self:RepositionFrames()
	self:AddMsg(L.PROFILE_APPLIED:format(name))
end

function DBM:CopyProfile(name)
	if not name or not DBM_AllSavedOptions[name] then
		self:AddMsg(L.PROFILE_COPY_ERROR:format(name or CL.UNKNOWN))
		return
	elseif name == usedProfile then
		self:AddMsg(L.PROFILE_COPY_ERROR_SELF)
		return
	end
	DBM_AllSavedOptions[usedProfile] = DBM_AllSavedOptions[name]
	self:AddDefaultOptions(DBM_AllSavedOptions[usedProfile], self.DefaultOptions)
	self.Options = DBM_AllSavedOptions[usedProfile]
	-- rearrange position
	DBT:CopyProfile(name, "DBM", true)
	self:RepositionFrames()
	self:AddMsg(L.PROFILE_COPIED:format(name))
end

function DBM:DeleteProfile(name)
	if not name or not DBM_AllSavedOptions[name] then
		self:AddMsg(L.PROFILE_DELETE_ERROR:format(name or CL.UNKNOWN))
		return
	elseif name == "Default" then-- Default profile cannot be deleted.
		self:AddMsg(L.PROFILE_CANNOT_DELETE)
		return
	end
	--Delete
	DBM_AllSavedOptions[name] = nil
	usedProfile = "Default"--Restore to default
	DBM_UsedProfile = usedProfile
	self.Options = DBM_AllSavedOptions[usedProfile]
	if not self.Options then
		-- the default profile got lost somehow (maybe WoW crashed and the saved variables file got corrupted)
		self:CreateProfile("Default")
	end
	-- rearrange position
	DBT:DeleteProfile(name, "DBM")
	self:RepositionFrames()
	self:AddMsg(L.PROFILE_DELETED:format(name))
end

function DBM:RepositionFrames()
	-- rearrange position
	self:UpdateWarningOptions()
	self:UpdateSpecialWarningOptions()
	self.Arrow:LoadPosition()
	local rangeCheck = _G["DBMRangeCheck"]
	if rangeCheck then
		rangeCheck:ClearAllPoints()
		rangeCheck:SetPoint(self.Options.RangeFramePoint, UIParent, self.Options.RangeFramePoint, self.Options.RangeFrameX, self.Options.RangeFrameY)
	end
	local rangeCheckRadar = _G["DBMRangeCheckRadar"]
	if rangeCheckRadar then
		rangeCheckRadar:ClearAllPoints()
		rangeCheckRadar:SetPoint(self.Options.RangeFrameRadarPoint, UIParent, self.Options.RangeFrameRadarPoint, self.Options.RangeFrameRadarX, self.Options.RangeFrameRadarY)
	end
	local infoFrame = _G["DBMInfoFrame"]
	if infoFrame then
		infoFrame:ClearAllPoints()
		infoFrame:SetPoint(self.Options.InfoFramePoint, UIParent, self.Options.InfoFramePoint, self.Options.InfoFrameX, self.Options.InfoFrameY)
	end
end

----------------------
--  Slash Commands  --
----------------------

do
	local function Sort(v1, v2)
		if v1.revision and not v2.revision then
			return true
		elseif v2.revision and not v1.revision then
			return false
		elseif v1.revision and v2.revision then
			return v1.revision > v2.revision
		else
			return (v1.bwversion or 0) > (v2.bwversion or 0)
		end
	end

	function DBM:ShowVersions(notify)
		local sortMe, outdatedUsers = {}, {}
		for _, v in pairs(raid) do
			tinsert(sortMe, v)
		end
		tsort(sortMe, Sort)
		self:AddMsg(L.VERSIONCHECK_HEADER)
		for _, v in ipairs(sortMe) do
			local name = v.name
			local playerColor = RAID_CLASS_COLORS[DBM:GetRaidClass(name)]
			if playerColor then
				name = ("|r|cff%.2x%.2x%.2x%s|r|cff%.2x%.2x%.2x"):format(playerColor.r * 255, playerColor.g * 255, playerColor.b * 255, name, 0.41 * 255, 0.8 * 255, 0.94 * 255)
			end
			if v.displayVersion and not v.bwversion then--DBM, no BigWigs
				if self.Options.ShowAllVersions then
					self:AddMsg(L.VERSIONCHECK_ENTRY:format(name, L.DBM.." "..v.displayVersion, showRealDate(v.revision), v.VPVersion or ""), false)--Only display VP version if not running two mods
				end
				if notify and v.revision < self.ReleaseRevision then
					SendChatMessage(chatPrefixShort..L.YOUR_VERSION_OUTDATED, "WHISPER", nil, v.name)
				end
			elseif self.Options.ShowAllVersions and v.displayVersion and v.bwversion then--DBM & BigWigs
				self:AddMsg(L.VERSIONCHECK_ENTRY_TWO:format(name, L.DBM.." "..v.displayVersion, showRealDate(v.revision), L.BIG_WIGS, bwVersionResponseString:format(v.bwversion, v.bwhash)), false)
			elseif self.Options.ShowAllVersions and not v.displayVersion and v.bwversion then--BigWigs, No DBM
				self:AddMsg(L.VERSIONCHECK_ENTRY:format(name, L.BIG_WIGS, bwVersionResponseString:format(v.bwversion, v.bwhash), ""), false)
			else
				if self.Options.ShowAllVersions then
					self:AddMsg(L.VERSIONCHECK_ENTRY_NO_DBM:format(name), false)
				end
			end
		end
		local NoDBM = 0
		local NoBigwigs = 0
		local OldMod = 0
		for i = #sortMe, 1, -1 do
			if not sortMe[i].revision then
				NoDBM = NoDBM + 1
			end
			if not (sortMe[i].bwversion) then
				NoBigwigs = NoBigwigs + 1
			end
			--Table sorting sorts dbm to top, bigwigs underneath. Highest version dbm always at top. so sortMe[1]
			--This check compares all dbm version to highest RELEASE version in raid.
			if sortMe[i].revision and (sortMe[i].revision < sortMe[1].version) or sortMe[i].bwversion and (sortMe[i].bwversion < fakeBWVersion) then
				OldMod = OldMod + 1
				local name = sortMe[i].name
				local playerColor = RAID_CLASS_COLORS[DBM:GetRaidClass(name)]
				if playerColor then
					name = ("|r|cff%.2x%.2x%.2x%s|r|cff%.2x%.2x%.2x"):format(playerColor.r * 255, playerColor.g * 255, playerColor.b * 255, name, 0.41 * 255, 0.8 * 255, 0.94 * 255)
				end
				tinsert(outdatedUsers, name)
			end
		end
		local TotalUsers = #sortMe
		self:AddMsg("---", false)
		self:AddMsg(L.VERSIONCHECK_FOOTER:format(TotalUsers - NoDBM, TotalUsers - NoBigwigs), false)
		self:AddMsg(L.VERSIONCHECK_OUTDATED:format(OldMod, #outdatedUsers > 0 and tconcat(outdatedUsers, ", ") or NONE), false)
	end
end

-------------------
--  Pizza Timer  --
-------------------
do

	local function loopTimer(time, text, broadcast, sender)
		DBM:CreatePizzaTimer(time, text, broadcast, sender, true)
	end

	local ignore = {}
	--Standard Pizza Timer
	function DBM:CreatePizzaTimer(time, text, broadcast, sender, loop, terminate, whisperTarget)
		if terminate or time == 0 then
			self:Unschedule(loopTimer)
			DBT:CancelBar(text)
			fireEvent("DBM_TimerStop", "DBMPizzaTimer")
			-- Fire cancelation of pizza timer
			if broadcast then
				text = text:sub(1, 16)
				text = text:gsub("%%t", UnitName("target") or "<no target>")
				if whisperTarget then
					C_ChatInfo.SendAddonMessageLogged(DBMPrefix, ("UW\t0\t%s"):format(text), "WHISPER", whisperTarget)
				else
					sendLoggedSync("U", ("0\t%s"):format(text))
				end
			end
			return
		end
		if sender and ignore[sender] then return end
		text = text:sub(1, 16)
		text = text:gsub("%%t", UnitName("target") or "<no target>")
		if time < 3 then
			self:AddMsg(L.PIZZA_ERROR_USAGE)
			return
		end
		DBT:CreateBar(time, text, isRetail and 237538 or 134376)
		fireEvent("DBM_TimerStart", "DBMPizzaTimer", text, time, isRetail and "237538" or "134376", "pizzatimer", nil, 0)
		if broadcast then
			if whisperTarget then
				--no dbm function uses whisper for pizza timers
				--this allows weak aura creators or other modders to use the pizza timer object unicast via whisper instead of spamming group sync channels
				C_ChatInfo.SendAddonMessageLogged(DBMPrefix, ("UW\t%s\t%s"):format(time, text), "WHISPER", whisperTarget)
			else
				sendLoggedSync("U", ("%s\t%s"):format(time, text))
			end
		end
		if sender then self:ShowPizzaInfo(text, sender) end
		if loop then
			self:Unschedule(loopTimer)--Only one loop timer supported at once doing this, but much cleaner this way
			self:Schedule(time, loopTimer, time, text, broadcast, sender)
		end
	end

	function DBM:AddToPizzaIgnore(name)
		ignore[name] = true
	end
end

function DBM:ShowPizzaInfo(id, sender)
	if self.Options.ShowPizzaMessage then
		self:AddMsg(L.PIZZA_SYNC_INFO:format(sender, id))
	end
end

-----------------
--  GUI Stuff  --
-----------------
do
	local callOnLoad = {}
	function DBM:LoadGUI()
		if GetAddOnEnableState(playerName, "VEM-Core") >= 1 then
			self:AddMsg(L.VEM)
			return
		end
		if GetAddOnEnableState(playerName, "DBM-Profiles") >= 1 then
			self:AddMsg(L.OUTDATEDPROFILES)
			return
		end
		if GetAddOnEnableState(playerName, "DBM-SpellTimers") >= 1 then
			local version = GetAddOnMetadata("DBM-SpellTimers", "Version") or "r0"
			version = tonumber(string.sub(version, 2, 4)) or 0
			if version < 122 and not self.Options.DebugMode then
				self:AddMsg(L.OUTDATEDSPELLTIMERS)
				return
			end
		end
		if GetAddOnEnableState(playerName, "DPMCore") >= 1 then
			self:AddMsg(L.DPMCORE)
			return
		end
		if GetAddOnEnableState(playerName, "DBM-VictorySound") >= 1 then
			self:AddMsg(L.VICTORYSOUND)
			return
		end
		if not dbmIsEnabled then
			self:AddMsg(L.UPDATEREMINDER_DISABLE)
			return
		end
		if self.NewerVersion and showConstantReminder >= 1 then
			AddMsg(self, L.UPDATEREMINDER_HEADER:format(self.NewerVersion, showRealDate(self.HighestRelease)))
		end
		local firstLoad = false
		if not IsAddOnLoaded("DBM-GUI") then
			local enabled = GetAddOnEnableState(playerName, "DBM-GUI")
			if enabled == 0 then
				EnableAddOn("DBM-GUI")
			end
			local loaded, reason = LoadAddOn("DBM-GUI")
			if not loaded then
				if reason then
					self:AddMsg(L.LOAD_GUI_ERROR:format(tostring(_G["ADDON_"..reason or ""])))
				else
					self:AddMsg(L.LOAD_GUI_ERROR:format(CL.UNKNOWN))
				end
				return false
			end
			if not InCombatLockdown() and not UnitAffectingCombat("player") and not IsFalling() then--We loaded in combat but still need to avoid garbage collect in combat
				collectgarbage("collect")
			end
			firstLoad = true
		end
		DBM_GUI:ShowHide()
		if firstLoad then
			tsort(callOnLoad, function(v1, v2) return v1[2] < v2[2] end)
			for _, v in ipairs(callOnLoad) do v[1]() end
		end
	end

	function DBM:RegisterOnGuiLoadCallback(f, sort)
		tinsert(callOnLoad, {f, sort or mhuge})
	end
end

-------------------------------------------------
--  Raid/Party Handling and Unit ID Utilities  --
-------------------------------------------------
do
	local bwVersionQueryString = "Q^%d^%s"--Only used here
	local inRaid = false

	local raidGuids = {}
	local iconSeter = {}

	--	save playerinfo into raid table on load. (for solo raid)
	DBM:RegisterOnLoadCallback(function()
		C_TimerAfter(6, function()
			if not raid[playerName] then
				raid[playerName] = {}
				raid[playerName].name = playerName
				raid[playerName].shortname = playerName
				raid[playerName].guid = UnitGUID("player")
				raid[playerName].rank = 0
				raid[playerName].class = playerClass
				raid[playerName].id = "player"
				raid[playerName].groupId = 0
				raid[playerName].revision = DBM.Revision
				raid[playerName].version = DBM.ReleaseRevision
				raid[playerName].displayVersion = DBM.DisplayVersion
				raid[playerName].locale = GetLocale()
				raid[playerName].enabledIcons = tostring(not DBM.Options.DontSetIcons)
				raidGuids[UnitGUID("player") or ""] = playerName
			end
		end)
	end)

	local function updateAllRoster(self)
		if IsInRaid() then
			if not inRaid then
				inRaid = true
				sendSync("H")
				SendAddonMessage("BigWigs", bwVersionQueryString:format(0, fakeBWHash), IsInGroup(2) and "INSTANCE_CHAT" or "RAID")
				if isRetail then
					self:Schedule(2, self.RoleCheck, false, self)
				end
				fireEvent("DBM_raidJoin", playerName)
				local bigWigs = _G["BigWigs"]
				if bigWigs and bigWigs.db.profile.raidicon and not self.Options.DontSetIcons and self:GetRaidRank() > 0 then--Both DBM and bigwigs have raid icon marking turned on.
					self:AddMsg(L.BIGWIGS_ICON_CONFLICT)--Warn that one of them should be turned off to prevent conflict (which they turn off is obviously up to raid leaders preference, dbm accepts either or turned off to stop this alert)
				end
			end
			for i = 1, GetNumGroupMembers() do
				local name, rank, subgroup, _, _, className = GetRaidRosterInfo(i)
				-- Maybe GetNumGroupMembers() bug? Seems that GetNumGroupMembers() rarely returns bad value, causing GetRaidRosterInfo() returns to nil.
				-- Filter name = nil to prevent nil table error.
				if name then
					local id = "raid" .. i
					local shortname = UnitName(id)
					if (not raid[name]) and inRaid then
						fireEvent("DBM_raidJoin", name)
					end
					raid[name] = raid[name] or {}
					raid[name].name = name
					raid[name].shortname = shortname
					raid[name].rank = rank
					raid[name].subgroup = subgroup
					raid[name].class = className
					raid[name].id = id
					raid[name].groupId = i
					raid[name].guid = UnitGUID(id) or ""
					raid[name].updated = true
					raidGuids[UnitGUID(id) or ""] = name
				end
			end
			private.enableIcons = false
			twipe(iconSeter)
			for i, v in pairs(raid) do
				if not v.updated then
					raidGuids[v.guid] = nil
					raid[i] = nil
					removeEntry(newerVersionPerson, i)
					fireEvent("DBM_raidLeave", i)
				else
					v.updated = nil
					if v.revision and v.rank > 0 and (v.enabledIcons or "") == "true" then
						iconSeter[#iconSeter + 1] = v.revision.." "..v.name
					end
				end
			end
			if #iconSeter > 0 then
				tsort(iconSeter, function(a, b) return a > b end)
				local elected = iconSeter[1]
				if playerName == elected:sub(elected:find(" ") + 1) then--Highest revision in raid, auto allow, period, even if out of date, you're revision in raid that has assist
					private.enableIcons = true
					DBM:Debug("You have been elected as primary icon setter for raid for having newest revision in raid that has assist/lead", 2)
				end
				--Initiate backups that at least have latest version, in case the main elect doesn't have icons enabled
				for i = 2, 3 do--Allow top 3 revisions in raid to set icons, instead of just top one
					local electedBackup = iconSeter[i]
					if updateNotificationDisplayed == 0 and electedBackup and playerName == electedBackup:sub(elected:find(" ") + 1) then
						private.enableIcons = true
						DBM:Debug("You have been elected as one of 2 backup icon setters in raid that have assist/lead", 2)
					end
				end
			end
		elseif IsInGroup() then
			if not inRaid then
				-- joined a new party
				inRaid = true
				sendSync("H")
				SendAddonMessage("BigWigs", bwVersionQueryString:format(0, fakeBWHash), IsInGroup(2) and "INSTANCE_CHAT" or "PARTY")
				if isRetail then
					self:Schedule(2, self.RoleCheck, false, self)
				end
				fireEvent("DBM_partyJoin", playerName)
			end
			for i = 0, GetNumSubgroupMembers() do
				local id
				if (i == 0) then
					id = "player"
				else
					id = "party"..i
				end
				local name = GetUnitName(id, true)
				local shortname = UnitName(id)
				local rank = UnitIsGroupLeader(id) and 2 or 0
				local _, className = UnitClass(id)
				if (not raid[name]) and inRaid then
					fireEvent("DBM_partyJoin", name)
				end
				raid[name] = raid[name] or {}
				raid[name].name = name
				raid[name].shortname = shortname
				raid[name].guid = UnitGUID(id) or ""
				raid[name].rank = rank
				raid[name].class = className
				raid[name].id = id
				raid[name].groupId = i
				raid[name].updated = true
				raidGuids[UnitGUID(id) or ""] = name
			end
			private.enableIcons = false
			twipe(iconSeter)
			for k, v in pairs(raid) do
				if not v.updated then
					raidGuids[v.guid] = nil
					raid[k] = nil
					removeEntry(newerVersionPerson, k)
					fireEvent("DBM_partyLeave", k)
				else
					v.updated = nil
					if v.revision and v.rank > 0 and (v.enabledIcons or "") == "true" then
						iconSeter[#iconSeter + 1] = v.revision.." "..v.name
					end
				end
			end
			if #iconSeter > 0 then
				tsort(iconSeter, function(a, b) return a > b end)
				local elected = iconSeter[1]
				if playerName == elected:sub(elected:find(" ") + 1) then
					private.enableIcons = true
				end
			end
		else
			-- left the current group/raid
			inRaid = false
			private.enableIcons = true
			fireEvent("DBM_raidLeave", playerName)
			twipe(raid)
			twipe(newerVersionPerson)
			-- restore playerinfo into raid table on raidleave. (for solo raid)
			raid[playerName] = {}
			raid[playerName].name = playerName
			raid[playerName].shortname = playerName
			raid[playerName].guid = UnitGUID("player")
			raid[playerName].rank = 0
			raid[playerName].class = playerClass
			raid[playerName].id = "player"
			raid[playerName].groupId = 0
			raid[playerName].revision = DBM.Revision
			raid[playerName].version = DBM.ReleaseRevision
			raid[playerName].displayVersion = DBM.DisplayVersion
			raid[playerName].locale = GetLocale()
			raidGuids[UnitGUID("player")] = playerName
		end
	end

	function DBM:GROUP_ROSTER_UPDATE(force)
		self:Unschedule(updateAllRoster)
		if force then
			updateAllRoster(self)
		else
			self:Schedule(1.5, updateAllRoster, self)
		end
	end

	function DBM:INSTANCE_GROUP_SIZE_CHANGED()
		local _, _, _, _, _, _, _, _, instanceGroupSize = GetInstanceInfo()
		LastGroupSize = instanceGroupSize
	end

	--C_Map.GetMapGroupMembersInfo
	function DBM:GetNumRealPlayersInZone()
		if not IsInGroup() then return 1 end
		local total = 0
		local _, _, _, currentMapId = UnitPosition("player")
		if IsInRaid() then
			for i = 1, GetNumGroupMembers() do
				local _, _, _, targetMapId = UnitPosition("raid"..i)
				if targetMapId == currentMapId then
					total = total + 1
				end
			end
		else
			total = 1--add player/self for "party" count
			for i = 1, GetNumSubgroupMembers() do
				local _, _, _, targetMapId = UnitPosition("party"..i)
				if targetMapId == currentMapId then
					total = total + 1
				end
			end
		end
		return total
	end

	function DBM:GetNumGuildPlayersInZone() -- Classic/BCC only
		if not IsInGroup() then return 1 end
		local total = 0
		local myGuild = GetGuildInfo("player")
		if IsInRaid() then
			for i = 1, GetNumGroupMembers() do
				local unitGuild = GetGuildInfo("raid"..i)--This api only works if unit is nearby, so don't even need to check location
				if unitGuild and unitGuild == myGuild then
					total = total + 1
				end
			end
		else
			total = 1--add player/self for "party" count
			for i = 1, GetNumSubgroupMembers() do
				local unitGuild = GetGuildInfo("party"..i)--This api only works if unit is nearby, so don't even need to check location
				if unitGuild and unitGuild == myGuild then
					total = total + 1
				end
			end
		end
		return total
	end

	function DBM:GetRaidRank(name)
		name = name or playerName
		if name == playerName then--If name is player, try to get actual rank. Because raid[name].rank sometimes seems returning 0 even player is promoted.
			return UnitIsGroupLeader("player") and 2 or UnitIsGroupAssistant("player") and 1 or 0
		else
			return (raid[name] and raid[name].rank) or 0
		end
	end

	function DBM:GetRaidSubgroup(name)
		return (raid[name] and raid[name].subgroup) or 0
	end

	function DBM:GetRaidRoster(name)
		if name then
			return raid[name] ~= nil
		end
		return raid
	end

	function DBM:GetRaidClass(name)
		if raid[name] then
			return raid[name].class or "UNKNOWN", raid[name].id and GetRaidTargetIndex(raid[name].id) or 0
		else
			return "UNKNOWN", 0
		end
	end

	function DBM:GetRaidUnitId(name)
		for i = 1, 5 do
			local unitId = "boss"..i
			local bossName = UnitName(unitId)
			if bossName and bossName == name then
				return unitId
			end
		end
		return raid[name] and raid[name].id
	end

	function DBM:GetEnemyUnitIdByGUID(guid)
		for i = 1, 5 do
			local unitId = "boss"..i
			local guid2 = UnitGUID(unitId)
			if guid == guid2 then
				return unitId
			end
		end
		local idType = (IsInRaid() and "raid") or "party"
		for i = 0, GetNumGroupMembers() do
			local unitId = ((i == 0) and "target") or idType..i.."target"
			local guid2 = UnitGUID(unitId)
			if guid == guid2 then
				return unitId
			end
		end
		return CL.UNKNOWN
	end

	function DBM:GetPlayerGUIDByName(name)
		return raid[name] and raid[name].guid
	end

	function DBM:GetMyPlayerInfo()
		return playerName, playerLevel, playerRealm
	end

	--Intentionally grabs server name at all times, usually to make sure warning/infoframe target info can name match the combat log in the table
	function DBM:GetUnitFullName(uId)
		if not uId then return end
		return GetUnitName(uId, true)
	end

	--Shortens name but custom so we add * to off realmers instead of stripping it entirely like Ambiguate does
	--Technically GetUnitName without "true" can be used to shorten name to "name (*)" but "name*" is even shorter which is why we do this
	function DBM:GetShortServerName(name)
		if not self.Options.StripServerName then return name end--If strip is disabled, just return name
		local shortName, serverName = string.split("-", name)
		if serverName and serverName ~= playerRealm then
			return shortName.."*"
		else
			return name
		end
	end

	function DBM:GetFullPlayerNameByGUID(guid)
		return raidGuids[guid]
	end

	function DBM:GetPlayerNameByGUID(guid)
		return raidGuids[guid] and raidGuids[guid]:gsub("%-.*$", "")
	end

	function DBM:GetGroupId(name)
		local raidMember = raid[name] or raid[GetUnitName(name, true) or ""]
		return raidMember and raidMember.groupId or 0
	end
end

do
	-- yes, we still do avoid memory allocations during fights; so we don't use a closure around a counter here
	-- this seems to be the easiest way to write an iterator that returns the unit id *string* as first argument without a memory allocation
	local function raidIterator(groupMembers, uId)
		local a, b = uId:byte(-2, -1)
		local i = (a >= 0x30 and a <= 0x39 and (a - 0x30) * 10 or 0) + b - 0x30
		if i < groupMembers then
			return "raid" .. i + 1, i + 1
		end
	end

	local function partyIterator(groupMembers, uId)
		if not uId then
			return "player", 0
		elseif uId == "player" then
			if groupMembers > 0 then
				return "party1", 1
			end
		else
			local i = uId:byte(-1) - 0x30
			if i < groupMembers then
				return "party" .. i + 1, i + 1
			end
		end
	end

	local function soloIterator(_, state)
		if not state then -- no state == first call
			return "player", 0
		end
	end

	-- returns the unit ids of all raid or party members, including the player's own id
	-- limitations: will break if there are ever raids with more than 99 players or partys with more than 10
	function DBM:GetGroupMembers()
		if IsInRaid() then
			return raidIterator, GetNumGroupMembers(), "raid0"
		elseif IsInGroup() then
			return partyIterator, GetNumSubgroupMembers(), nil
		else
			-- solo!
			return soloIterator, nil, nil
		end
	end
end

function DBM:GetNumGroupMembers()
	return IsInGroup() and GetNumGroupMembers() or 1
end

--For returning the number of players actually in zone with us for status functions
--This is very touchy though and will fail if everyone isn't in same SUB zone (ie same room/area)
--It should work for pretty much any case but outdoor
function DBM:GetNumRealGroupMembers()
	if not IsInInstance() then--Not accurate outside of instances (such as world bosses)
		return IsInGroup() and GetNumGroupMembers() or 1--So just return regular group members.
	end
	local _, _, _, currentMapId = UnitPosition("player")
	local realGroupMembers = 0
	if IsInGroup() then
		for uId in self:GetGroupMembers() do
			local _, _, _, targetMapId = UnitPosition(uId)
			if targetMapId == currentMapId then
				realGroupMembers = realGroupMembers + 1
			end
		end
	else
		return 1
	end
	return realGroupMembers
end

function DBM:GetUnitCreatureId(uId)
	return self:GetCIDFromGUID(UnitGUID(uId))
end

--Creature/Vehicle/Pet
----<type>:<subtype>:<realmID>:<mapID>:<serverID>:<dbID>:<creationbits>
--Player/Item
----<type>:<realmID>:<dbID>
function DBM:GetCIDFromGUID(guid)
	local guidType, _, playerdbID, _, _, cid, _ = strsplit("-", guid or "")
	if guidType and (guidType == "Creature" or guidType == "Vehicle" or guidType == "Pet") then
		return tonumber(cid)
	elseif type and (guidType == "Player" or guidType == "Item") then
		return tonumber(playerdbID)
	end
	return 0
end

function DBM:IsNonPlayableGUID(guid)
	if type(guid) == "number" then return false end
	local guidType = strsplit("-", guid or "")
	return guidType and (guidType == "Creature" or guidType == "Vehicle" or guidType == "NPC")--To determine, add pet or not?
end

function DBM:IsCreatureGUID(guid)
	local guidType = strsplit("-", guid or "")
	return guidType and (guidType == "Creature" or guidType == "Vehicle")--To determine, add pet or not?
end

function DBM:GetBossUnitId(name, bossOnly)--Deprecated, only old mods use this
	local returnUnitID
	for i = 1, 5 do
		if UnitName("boss" .. i) == name then
			returnUnitID = "boss"..i
		end
	end
	if not returnUnitID and not bossOnly then
		for uId in self:GetGroupMembers() do
			if UnitName(uId .. "target") == name and not UnitIsPlayer(uId .. "target") then
				returnUnitID = uId.."target"
			end
		end
	end
	return returnUnitID
end

function DBM:GetUnitIdFromGUID(cidOrGuid, bossOnly)
	local returnUnitID
	for i = 1, 5 do
		local unitId = "boss"..i
		local bossGUID = UnitGUID(unitId)
		if type(cidOrGuid) == "number" then--CID passed
			local cid = self:GetCIDFromGUID(bossGUID)
			if cid == cidOrGuid then
				returnUnitID = unitId
			end
		else--GUID passed
			if bossGUID == cidOrGuid then
				returnUnitID = unitId
			end
		end
	end
	--Didn't find valid unitID from boss units, scan raid targets
	if not returnUnitID and not bossOnly then
		for uId in DBM:GetGroupMembers() do--Do not use self on this function, because self might be bossModPrototype
			local unitId = uId .. "target"
			local bossGUID = UnitGUID(unitId)
			local cid = self:GetCIDFromGUID(cidOrGuid)
			if bossGUID == cidOrGuid or cid == cidOrGuid then
				returnUnitID = unitId
			end
		end
	end
	return returnUnitID
end

function DBM:CheckNearby(range, targetname)
	if not targetname and DBM.RangeCheck:GetDistanceAll(range) then--Do not use self on this function, because self might be bossModPrototype
		return true--No target name means check if anyone is near self, period
	else
		local uId = DBM:GetRaidUnitId(targetname)--Do not use self on this function, because self might be bossModPrototype
		if uId and not UnitIsUnit("player", uId) then
			local inRange = DBM.RangeCheck:GetDistance(uId)--Do not use self on this function, because self might be bossModPrototype
			if inRange and inRange < range+0.5 then
				return true
			end
		end
	end
	return false
end

function DBM:IsTrivial(customLevel)
	--if timewalking or chromie time or challenge modes. it's always non trivial content
	if C_PlayerInfo.IsPlayerInChromieTime and C_PlayerInfo.IsPlayerInChromieTime() or difficultyIndex == 24 or difficultyIndex == 33 or difficultyIndex == 8 then
		return false
	end
	--if custom level passed, we always hard check that level for trivial vs non trivial
	if customLevel then--Custom level parameter
		if playerLevel >= customLevel then
			return true
		end
	else
		--First, auto bail and return non trivial if it's an instancce not in table to prevent nil error
		if not instanceDifficultyBylevel[LastInstanceMapID] then return false end
		--Content is trivial if player level is 10 higher than content involved
		local levelDiff = isRetail and 10 or 15
		if playerLevel >= (instanceDifficultyBylevel[LastInstanceMapID][1]+levelDiff) then
			return true
		end
	end
	return false
end

---------------
--  Options  --
---------------
function DBM:AddDefaultOptions(t1, t2)
	for i, v in pairs(t2) do
		if t1[i] == nil then
			t1[i] = v
		elseif type(v) == "table" and type(t1[i]) == "table" then
			self:AddDefaultOptions(t1[i], v)
		end
	end
end

function DBM:LoadModOptions(modId, inCombat, first)
	local oldSavedVarsName = modId:gsub("-", "").."_SavedVars"
	local savedVarsName = modId:gsub("-", "").."_AllSavedVars"
	local savedStatsName = modId:gsub("-", "").."_SavedStats"
	local fullname = playerName.."-"..playerRealm
	if not currentSpecID or not currentSpecGroup then
		self:SetCurrentSpecInfo()
	end
	local profileNum = playerLevel > 9 and DBM_UseDualProfile and currentSpecGroup or 0
	if not _G[savedVarsName] then _G[savedVarsName] = {} end
	local savedOptions = _G[savedVarsName][fullname] or {}
	local savedStats = _G[savedStatsName] or {}
	local existId = {}
	for _, id in ipairs(self.ModLists[modId]) do
		existId[id] = true
		-- init
		if not savedOptions[id] then savedOptions[id] = {} end
		local mod = self:GetModByName(id)
		-- migrate old option
		if _G[oldSavedVarsName] and _G[oldSavedVarsName][id] then
			self:Debug("LoadModOptions: Found old options, importing", 2)
			local oldTable = _G[oldSavedVarsName][id]
			_G[oldSavedVarsName][id] = nil
			savedOptions[id][profileNum] = oldTable
		end
		if not savedOptions[id][profileNum] and not first then--previous profile not found. load defaults
			self:Debug("LoadModOptions: No saved options, creating defaults for profile "..profileNum, 2)
			local defaultOptions = {}
			for option, optionValue in pairs(mod.DefaultOptions) do
				if type(optionValue) == "table" then
					optionValue = optionValue.value
				elseif type(optionValue) == "string" then
					optionValue = mod:GetRoleFlagValue(optionValue)
				end
				defaultOptions[option] = optionValue
			end
			savedOptions[id][profileNum] = defaultOptions
		else
			savedOptions[id][profileNum] = savedOptions[id][profileNum] or mod.Options
			--check new option
			for option, optionValue in pairs(mod.DefaultOptions) do
				if savedOptions[id][profileNum][option] == nil then
					if type(optionValue) == "table" then
						optionValue = optionValue.value
					elseif type(optionValue) == "string" then
						optionValue = mod:GetRoleFlagValue(optionValue)
					end
					savedOptions[id][profileNum][option] = optionValue
				end
			end
			--clean unused saved variables (do not work on combat load)
			--Why are saved options cleaned twice?
			if not inCombat then
				for option, _ in pairs(savedOptions[id][profileNum]) do
					if type(option) == "number" then
						self:Debug("|cffff0000Option type invalid: |r"..option)
					end
					if (mod.DefaultOptions[option] == nil) and not (option:find("talent") or option:find("FastestClear") or option:find("CVAR") or option:find("RestoreSetting")) then
						savedOptions[id][profileNum][option] = nil
					elseif mod.DefaultOptions[option] and (type(mod.DefaultOptions[option]) == "table") then--recover broken dropdown option
						if savedOptions[id][profileNum][option] and (type(savedOptions[id][profileNum][option]) == "boolean") then
							savedOptions[id][profileNum][option] = mod.DefaultOptions[option].value
						end
					--Fix default options for colored bar by type that were set to 0 because no defaults existed at time they were created, but do now.
					elseif option:find("TColor") then
						if savedOptions[id][profileNum][option] and savedOptions[id][profileNum][option] == 0 and mod.DefaultOptions[option] and mod.DefaultOptions[option] ~= 0 then
							savedOptions[id][profileNum][option] = mod.DefaultOptions[option]
							self:Debug("Migrated "..option.." to option defaults")
						end
					--Fix options for custom special warning sounds not in addons folder that are not using soundkit IDs
					elseif option:find("SWSound") then
						if savedOptions[id][profileNum][option] and (type(savedOptions[id][profileNum][option]) == "string") and (savedOptions[id][profileNum][option] ~= "") and (savedOptions[id][profileNum][option] ~= "None") then
							local searchMsg = (savedOptions[id][profileNum][option]):lower()
							if not searchMsg:find("addons") then
								savedOptions[id][profileNum][option] = mod.DefaultOptions[option]
								self:Debug("Migrated "..option.." to option defaults")
							end
						end
					end
				end
			end
		end
		--apply saved option to actual option table
		mod.Options = savedOptions[id][profileNum]
		--stats init (only first load)
		if first then
			savedStats[id] = savedStats[id] or {}
			local stats = savedStats[id]
			stats.normalKills = stats.normalKills or 0
			stats.normalPulls = stats.normalPulls or 0
			stats.heroicKills = stats.heroicKills or 0
			stats.heroicPulls = stats.heroicPulls or 0
			stats.challengeKills = stats.challengeKills or 0
			stats.challengePulls = stats.challengePulls or 0
			stats.challengeBestRank = stats.challengeBestRank or 0
			stats.mythicKills = stats.mythicKills or 0
			stats.mythicPulls = stats.mythicPulls or 0
			stats.normal25Kills = stats.normal25Kills or 0
			stats.normal25Kills = stats.normal25Kills or 0
			stats.normal25Pulls = stats.normal25Pulls or 0
			stats.heroic25Kills = stats.heroic25Kills or 0
			stats.heroic25Pulls = stats.heroic25Pulls or 0
			stats.lfr25Kills = stats.lfr25Kills or 0
			stats.lfr25Pulls = stats.lfr25Pulls or 0
			stats.timewalkerKills = stats.timewalkerKills or 0
			stats.timewalkerPulls = stats.timewalkerPulls or 0
			mod.stats = stats
			--run OnInitialize function
			if mod.OnInitialize then mod:OnInitialize(mod) end
		end
	end
	--clean unused saved variables (do not work on combat load)
	--Why are saved options cleaned twice?
	if not inCombat then
		for id, _ in pairs(savedOptions) do
			if not existId[id] and not (id:find("talent") or id:find("FastestClear") or id:find("CVAR") or id:find("RestoreSetting")) then
				savedOptions[id] = nil
			end
		end
		for id, _ in pairs(savedStats) do
			if not existId[id] then
				savedStats[id] = nil
			end
		end
	end
	_G[savedVarsName][fullname] = savedOptions
	if profileNum > 0 then
		_G[savedVarsName][fullname]["talent"..profileNum] = currentSpecName
		self:Debug("LoadModOptions: Finished loading "..(_G[savedVarsName][fullname]["talent"..profileNum] or CL.UNKNOWN))
	end
	_G[savedStatsName] = savedStats
	local optionsFrame = _G["DBM_GUI_OptionsFrame"]
	if not first and DBM_GUI and DBM_GUI.currentViewing and optionsFrame:IsShown() then
		optionsFrame:DisplayFrame(DBM_GUI.currentViewing)
	end
end

function DBM:SpecChanged(force)
	if not force and not DBM_UseDualProfile then return end
	--Load Options again.
	self:Debug("SpecChanged fired", 2)
	for modId, _ in pairs(self.ModLists) do
		self:LoadModOptions(modId)
	end
end

function DBM:PLAYER_LEVEL_CHANGED()
	playerLevel = UnitLevel("player")
	if playerLevel < 15 and playerLevel > 9 then
		self:PLAYER_SPECIALIZATION_CHANGED() -- Classic this is "CHARACTER_POINTS_CHANGED", but we just use this function anyway
	end
end

function DBM:LoadAllModDefaultOption(modId)
	-- modId is string like "DBM-Highmaul"
	if not modId or not self.ModLists[modId] then return end
	-- prevent error
	if not currentSpecID or not currentSpecGroup then
		self:SetCurrentSpecInfo()
	end
	-- variable init
	local savedVarsName = modId:gsub("-", "").."_AllSavedVars"
	local fullname = playerName.."-"..playerRealm
	local profileNum = playerLevel > 9 and DBM_UseDualProfile and currentSpecGroup or 0
	-- prevent nil table error
	if not _G[savedVarsName] then _G[savedVarsName] = {} end
	for _, id in ipairs(self.ModLists[modId]) do
		-- prevent nil table error
		if not _G[savedVarsName][fullname][id] then _G[savedVarsName][fullname][id] = {} end
		-- actual do load default option
		local mod = self:GetModByName(id)
		local defaultOptions = {}
		for option, optionValue in pairs(mod.DefaultOptions) do
			if type(optionValue) == "table" then
				optionValue = optionValue.value
			elseif type(optionValue) == "string" then
				optionValue = mod:GetRoleFlagValue(optionValue)
			end
			defaultOptions[option] = optionValue
		end
		mod.Options = {}
		mod.Options = defaultOptions
		_G[savedVarsName][fullname][id][profileNum] = {}
		_G[savedVarsName][fullname][id][profileNum] = mod.Options
	end
	self:AddMsg(L.ALLMOD_DEFAULT_LOADED)
	-- update gui if showing
	local optionsFrame = _G["DBM_GUI_OptionsFrame"]
	if DBM_GUI and DBM_GUI.currentViewing and optionsFrame:IsShown() then
		optionsFrame:DisplayFrame(DBM_GUI.currentViewing)
	end
end

function DBM:LoadModDefaultOption(mod)
	-- mod must be table
	if not mod then return end
	-- prevent error
	if not currentSpecID or not currentSpecGroup then
		self:SetCurrentSpecInfo()
	end
	-- variable init
	local savedVarsName = (mod.modId):gsub("-", "").."_AllSavedVars"
	local fullname = playerName.."-"..playerRealm
	local profileNum = playerLevel > 9 and DBM_UseDualProfile and currentSpecGroup or 0
	-- prevent nil table error
	if not _G[savedVarsName] then _G[savedVarsName] = {} end
	if not _G[savedVarsName][fullname] then _G[savedVarsName][fullname] = {} end
	if not _G[savedVarsName][fullname][mod.id] then _G[savedVarsName][fullname][mod.id] = {} end
	-- do load default
	local defaultOptions = {}
	for option, optionValue in pairs(mod.DefaultOptions) do
		if type(optionValue) == "table" then
			optionValue = optionValue.value
		elseif type(optionValue) == "string" then
			optionValue = mod:GetRoleFlagValue(optionValue)
		end
		defaultOptions[option] = optionValue
	end
	mod.Options = {}
	mod.Options = defaultOptions
	_G[savedVarsName][fullname][mod.id][profileNum] = {}
	_G[savedVarsName][fullname][mod.id][profileNum] = mod.Options
	self:AddMsg(L.MOD_DEFAULT_LOADED)
	-- update gui if showing
	local optionsFrame = _G["DBM_GUI_OptionsFrame"]
	if DBM_GUI and DBM_GUI.currentViewing and optionsFrame:IsShown() then
		optionsFrame:DisplayFrame(DBM_GUI.currentViewing)
	end
end

function DBM:CopyAllModOption(modId, sourceName, sourceProfile)
	-- modId is string like "DBM-Highmaul"
	if not modId or not sourceName or not sourceProfile or not DBM.ModLists[modId] then return end
	-- prevent error
	if not currentSpecID or not currentSpecGroup then
		self:SetCurrentSpecInfo()
	end
	-- variable init
	local savedVarsName = modId:gsub("-", "").."_AllSavedVars"
	local targetName = playerName.."-"..playerRealm
	local targetProfile = playerLevel > 9 and DBM_UseDualProfile and currentSpecGroup or 0
	-- do not copy setting itself
	if targetName == sourceName and targetProfile == sourceProfile then
		self:AddMsg(L.MPROFILE_COPY_SELF_ERROR)
		return
	end
	-- prevent nil table error
	if not _G[savedVarsName] then _G[savedVarsName] = {} end
	-- check source is exist
	if not _G[savedVarsName][sourceName] then
		self:AddMsg(L.MPROFILE_COPY_S_ERROR)
		return
	end
	for _, id in ipairs(self.ModLists[modId]) do
		-- check source is exist
		if not _G[savedVarsName][sourceName][id] then
			self:AddMsg(L.MPROFILE_COPY_S_ERROR)
			return
		end
		if not _G[savedVarsName][sourceName][id][sourceProfile] then
			self:AddMsg(L.MPROFILE_COPY_S_ERROR)
			return
		end
		-- prevent nil table error
		if not _G[savedVarsName][targetName][id] then _G[savedVarsName][targetName][id] = {} end
		-- copy table
		_G[savedVarsName][targetName][id][targetProfile] = {}--clear before copy
		_G[savedVarsName][targetName][id][targetProfile] = _G[savedVarsName][sourceName][id][sourceProfile]
		--check new option
		local mod = self:GetModByName(id)
		for option, optionValue in pairs(mod.Options) do
			if _G[savedVarsName][targetName][id][targetProfile][option] == nil then
				_G[savedVarsName][targetName][id][targetProfile][option] = optionValue
			end
		end
		-- apply to options table
		mod.Options = {}
		mod.Options = _G[savedVarsName][targetName][id][targetProfile]
	end
	if targetProfile > 0 then
		_G[savedVarsName][targetName]["talent"..targetProfile] = currentSpecName
	end
	self:AddMsg(L.MPROFILE_COPY_SUCCESS:format(sourceName, sourceProfile))
	-- update gui if showing
	local optionsFrame = _G["DBM_GUI_OptionsFrame"]
	if DBM_GUI and DBM_GUI.currentViewing and optionsFrame:IsShown() then
		optionsFrame:DisplayFrame(DBM_GUI.currentViewing)
	end
end

function DBM:CopyAllModTypeOption(modId, sourceName, sourceProfile, Type)
	-- modId is string like "DBM-Highmaul"
	if not modId or not sourceName or not sourceProfile or not self.ModLists[modId] or not Type then return end
	-- prevent error
	if not currentSpecID or not currentSpecGroup then
		self:SetCurrentSpecInfo()
	end
	-- variable init
	local savedVarsName = modId:gsub("-", "").."_AllSavedVars"
	local targetName = playerName.."-"..playerRealm
	local targetProfile = playerLevel > 9 and DBM_UseDualProfile and currentSpecGroup or 0
	-- do not copy setting itself
	if targetName == sourceName and targetProfile == sourceProfile then
		self:AddMsg(L.MPROFILE_COPYS_SELF_ERROR)
		return
	end
	-- prevent nil table error
	if not _G[savedVarsName] then _G[savedVarsName] = {} end
	-- check source is exist
	if not _G[savedVarsName][sourceName] then
		self:AddMsg(L.MPROFILE_COPYS_S_ERROR)
		return
	end
	for _, id in ipairs(self.ModLists[modId]) do
		-- check source is exist
		if not _G[savedVarsName][sourceName][id] then
			self:AddMsg(L.MPROFILE_COPYS_S_ERROR)
			return
		end
		if not _G[savedVarsName][sourceName][id][sourceProfile] then
			self:AddMsg(L.MPROFILE_COPYS_S_ERROR)
			return
		end
		-- prevent nil table error
		if not _G[savedVarsName][targetName][id] then _G[savedVarsName][targetName][id] = {} end
		-- copy table
		for option, optionValue in pairs(_G[savedVarsName][sourceName][id][sourceProfile]) do
			if option:find(Type) then
				_G[savedVarsName][targetName][id][targetProfile][option] = optionValue
			end
		end
		-- apply to options table
		local mod = self:GetModByName(id)
		mod.Options = {}
		mod.Options = _G[savedVarsName][targetName][id][targetProfile]
	end
	if targetProfile > 0 then
		_G[savedVarsName][targetName]["talent"..targetProfile] = currentSpecName
	end
	self:AddMsg(L.MPROFILE_COPYS_SUCCESS:format(sourceName, sourceProfile))
	-- update gui if showing
	local optionsFrame = _G["DBM_GUI_OptionsFrame"]
	if DBM_GUI and DBM_GUI.currentViewing and optionsFrame:IsShown() then
		optionsFrame:DisplayFrame(DBM_GUI.currentViewing)
	end
end

function DBM:DeleteAllModOption(modId, name, profile)
	-- modId is string like "DBM-Highmaul"
	if not modId or not name or not profile or not self.ModLists[modId] then return end
	-- prevent error
	if not currentSpecID or not currentSpecGroup then
		self:SetCurrentSpecInfo()
	end
	-- variable init
	local savedVarsName = modId:gsub("-", "").."_AllSavedVars"
	local fullname = playerName.."-"..playerRealm
	local profileNum = playerLevel > 9 and DBM_UseDualProfile and currentSpecGroup or 0
	-- cannot delete current profile.
	if fullname == name and profileNum == profile then
		self:AddMsg(L.MPROFILE_DELETE_SELF_ERROR)
		return
	end
	-- prevent nil table error
	if not _G[savedVarsName] then _G[savedVarsName] = {} end
	if not _G[savedVarsName][name] then
		self:AddMsg(L.MPROFILE_DELETE_S_ERROR)
		return
	end
	for _, id in ipairs(self.ModLists[modId]) do
		-- prevent nil table error
		if not _G[savedVarsName][name][id] then
			self:AddMsg(L.MPROFILE_DELETE_S_ERROR)
			return
		end
		-- delete
		_G[savedVarsName][name][id][profile] = nil
	end
	_G[savedVarsName][name]["talent"..profile] = nil
	self:AddMsg(L.MPROFILE_DELETE_SUCCESS:format(name, profile))
end

function DBM:ClearAllStats(modId)
	-- modId is string like "DBM-Highmaul"
	if not modId or not self.ModLists[modId] then return end
	-- variable init
	local savedStatsName = modId:gsub("-", "").."_SavedStats"
	-- prevent nil table error
	if not _G[savedStatsName] then _G[savedStatsName] = {} end
	for _, id in ipairs(self.ModLists[modId]) do
		local mod = self:GetModByName(id)
		-- prevent nil table error
		local defaultStats = {}
		defaultStats.normalKills = 0
		defaultStats.normalPulls = 0
		defaultStats.heroicKills = 0
		defaultStats.heroicPulls = 0
		defaultStats.challengeKills = 0
		defaultStats.challengePulls = 0
		defaultStats.challengeBestRank = 0
		defaultStats.mythicKills = 0
		defaultStats.mythicPulls = 0
		defaultStats.normal25Kills = 0
		defaultStats.normal25Kills = 0
		defaultStats.normal25Pulls = 0
		defaultStats.heroic25Kills = 0
		defaultStats.heroic25Pulls = 0
		defaultStats.lfr25Kills = 0
		defaultStats.lfr25Pulls = 0
		defaultStats.timewalkerKills = 0
		defaultStats.timewalkerPulls = 0
		mod.stats = {}
		mod.stats = defaultStats
		_G[savedStatsName][id] = {}
		_G[savedStatsName][id] = defaultStats
	end
	self:AddMsg(L.ALLMOD_STATS_RESETED)
	DBM_GUI:UpdateModList()
end

do
	local gsub = string.gsub

	local function FixElv(optionName)
		if DBM.Options[optionName]:lower():find("interface\\addons\\elvui\\media\\") then
			DBM.Options[optionName] = gsub(DBM.Options[optionName], gsub("Interface\\AddOns\\ElvUI\\Media\\", "(%a)", function(v)
				return "[" .. v:upper() .. v:lower() .. "]"
			end), "Interface\\AddOns\\ElvUI\\Core\\Media\\")
		end
	end

	function loadOptions(self)
		--init
		if not DBM_AllSavedOptions then DBM_AllSavedOptions = {} end
		usedProfile = DBM_UsedProfile or usedProfile
		if not usedProfile or (usedProfile ~= "Default" and not DBM_AllSavedOptions[usedProfile]) then
			-- DBM.Option is not loaded. so use print function
			print(L.PROFILE_NOT_FOUND)
			usedProfile = "Default"
		end
		DBM_UsedProfile = usedProfile
		self.Options = DBM_AllSavedOptions[usedProfile] or {}
		dbmIsEnabled = true
		self:AddDefaultOptions(self.Options, self.DefaultOptions)
		DBM_AllSavedOptions[usedProfile] = self.Options

		-- force enable dual profile (change default)
		if DBM_CharSavedRevision < 12976 then
			if playerClass ~= "MAGE" and playerClass ~= "WARLOCK" and playerClass ~= "ROGUE" then
				DBM_UseDualProfile = true
			end
		end
		DBM_CharSavedRevision = self.Revision
		-- load special warning options
		self:UpdateWarningOptions()
		self:UpdateSpecialWarningOptions()
		self.Options.CoreSavedRevision = self.Revision
		--Fix fonts if they are nil or set to any of standard font values
		if not self.Options.WarningFont or (self.Options.WarningFont == "Fonts\\2002.TTF" or self.Options.WarningFont == "Fonts\\ARKai_T.ttf" or self.Options.WarningFont == "Fonts\\blei00d.TTF" or self.Options.WarningFont == "Fonts\\FRIZQT___CYR.TTF" or self.Options.WarningFont == "Fonts\\FRIZQT__.TTF") then
			self.Options.WarningFont = "standardFont"
		end
		if not self.Options.SpecialWarningFont or (self.Options.SpecialWarningFont == "Fonts\\2002.TTF" or self.Options.SpecialWarningFont == "Fonts\\ARKai_T.ttf" or self.Options.SpecialWarningFont == "Fonts\\blei00d.TTF" or self.Options.SpecialWarningFont == "Fonts\\FRIZQT___CYR.TTF" or self.Options.SpecialWarningFont == "Fonts\\FRIZQT__.TTF") then
			self.Options.SpecialWarningFont = "standardFont"
		end
		--Migrate interupt always filter to new interrupt disable option
		if self.Options.FilterInterrupt2 == "Always" then
			self.Options.FilterInterrupt2 = "TandFandBossCooldown"
			self.Options.SpamSpecRoleinterrupt = true
		end
		--If users previous voice pack was not set to none, don't force change it to VEM, honor whatever it was set to before
		if self.Options.ChosenVoicePack and self.Options.ChosenVoicePack ~= "None" then
			self.Options.ChosenVoicePack2 = self.Options.ChosenVoicePack
			self.Options.ChosenVoicePack = nil
		end
		-- Migrate ElvUI changes
		for _, setting in ipairs({
			-- Sounds
			"RaidWarningSound", "SpecialWarningSound", "SpecialWarningSound2", "SpecialWarningSound3", "SpecialWarningSound4", "SpecialWarningSound5", "EventSoundVictory2",
			"EventSoundWipe", "EventSoundEngage2", "EventSoundMusic", "EventSoundDungeonBGM", "RangeFrameSound1", "RangeFrameSound2",
			-- Fonts
			"InfoFrameFont", "WarningFont", "SpecialWarningFont"
		}) do
			if type(self.Options[setting]) == "string" and self.Options[setting]:lower() ~= "none" then
				FixElv(setting)
			end
		end
	end
end

do
	local lastLFGAlert = 0
	function DBM:LFG_ROLE_CHECK_SHOW()
		if not UnitIsGroupLeader("player") and self.Options.LFDEnhance and GetTime() - lastLFGAlert > 5 then
			self:FlashClientIcon()
			self:PlaySound(8960, true)--Because regular sound uses SFX channel which is too low of volume most of time
			lastLFGAlert = GetTime()
		end
	end
end

function DBM:LFG_PROPOSAL_SHOW()
	if self.Options.ShowQueuePop and not self.Options.DontShowBossTimers then
		DBT:CreateBar(40, L.LFG_INVITE, 237538)
		fireEvent("DBM_TimerStart", "DBMLFGTimer", L.LFG_INVITE, 40, "237538", "extratimer", nil, 0)
	end
	if self.Options.LFDEnhance then
		self:FlashClientIcon()
		self:PlaySound(8960, true)--Because regular sound uses SFX channel which is too low of volume most of time
	end
end

function DBM:LFG_PROPOSAL_FAILED()
	DBT:CancelBar(L.LFG_INVITE)
	fireEvent("DBM_TimerStop", "DBMLFGTimer")
end

function DBM:LFG_PROPOSAL_SUCCEEDED()
	DBT:CancelBar(L.LFG_INVITE)
	fireEvent("DBM_TimerStop", "DBMLFGTimer")
end

function DBM:READY_CHECK()
	if self.Options.RLReadyCheckSound then--readycheck sound, if ora3 not installed (bad to have 2 mods do it)
		self:FlashClientIcon()
		if not BINDING_HEADER_oRA3 then
			DBM:PlaySound(8960, true)--Because regular sound uses SFX channel which is too low of volume most of time
		end
	end
	self:TransitionToDungeonBGM(false, true)
	self:Schedule(4, self.TransitionToDungeonBGM, self)
end

function DBM:PLAYER_SPECIALIZATION_CHANGED()
	local lastSpecID = currentSpecID
	self:SetCurrentSpecInfo()
	if currentSpecID ~= lastSpecID then--Don't fire specchanged unless spec actually has changed.
		self:SpecChanged()
		if isRetail and IsInGroup() then
			self:RoleCheck(false)
		end
	end
end

DBM.CHARACTER_POINTS_CHANGED = DBM.PLAYER_SPECIALIZATION_CHANGED -- Classic/BCC support

do
	local function AcceptPartyInvite()
		AcceptGroup()
		for i=1, STATICPOPUP_NUMDIALOGS do
			local whichDialog = _G["StaticPopup"..i].which
			if whichDialog == "PARTY_INVITE" or whichDialog == "PARTY_INVITE_XREALM" then
				_G["StaticPopup"..i].inviteAccepted = 1
				StaticPopup_Hide(whichDialog)
				break
			end
		end
	end

	function DBM:PARTY_INVITE_REQUEST(sender)
		--First off, if you are in queue for something, lets not allow guildies or friends boot you from it.
		if IsInInstance() or GetLFGMode(1) or GetLFGMode(2) or GetLFGMode(3) or GetLFGMode(4) or GetLFGMode(5) then return end
		--Checks friends and guildies
		if self.Options.AutoAcceptFriendInvite then
			if checkForSafeSender(sender, self.Options.AutoAcceptFriendInvite, self.Options.AutoAcceptGuildInvite, nil, type(sender) == "number") then
				AcceptPartyInvite()
			end
		end
	end
end

function DBM:UPDATE_BATTLEFIELD_STATUS(queueID)
	for i = 1, 2 do
		if GetBattlefieldStatus(i) == "confirm" then
			if self.Options.ShowQueuePop and not self.Options.DontShowBossTimers then
				queuedBattlefield[i] = select(2, GetBattlefieldStatus(i))
				local expiration = GetBattlefieldPortExpiration(queueID)
				local timerIcon = (isRetail and GetPlayerFactionGroup("player") or UnitFactionGroup("player")) == "Alliance" and 132486 or 132485
				DBT:CreateBar(expiration or 85, queuedBattlefield[i], timerIcon)
				self:FlashClientIcon()
				fireEvent("DBM_TimerStart", "DBMBFSTimer", queuedBattlefield[i], expiration or 85, tostring(timerIcon), "extratimer", nil, 0)
			end
			if self.Options.LFDEnhance then
				self:PlaySound(8960, true)--Because regular sound uses SFX channel which is too low of volume most of time
			end
		elseif queuedBattlefield[i] then
			DBT:CancelBar(queuedBattlefield[i])
			fireEvent("DBM_TimerStop", "DBMBFSTimer")
			tremove(queuedBattlefield, i)
		end
	end
end

function DBM:SCENARIO_COMPLETED()
	if #inCombat > 0 and C_Scenario.IsInScenario() then
		for i = #inCombat, 1, -1 do
			local v = inCombat[i]
			if v.inScenario then
				self:EndCombat(v)
			end
		end
	end
end

--------------------------------
--  Load Boss Mods on Demand  --
--------------------------------
do
	local modAdvertisementShown = false
	local classicZones = {[509]=true,[531]=true,[469]=true,[409]=true}
	local bcZones = {[564]=true,[534]=true,[532]=true,[565]=true,[544]=true,[548]=true,[580]=true,[550]=true}
	local wrathZones = {[615]=true,[724]=true,[649]=true,[616]=true,[631]=true,[533]=true,[249]=true,[603]=true,[624]=true}
	local cataZones = {[757]=true,[671]=true,[669]=true,[967]=true,[720]=true,[951]=true,[754]=true}
	local mopZones = {[1009]=true,[1008]=true,[1136]=true,[996]=true,[1098]=true}
	local wodZones = {[1205]=true,[1448]=true,[1228]=true}
	local legionZones = {[1712]=true,[1520]=true,[1530]=true,[1676]=true,[1648]=true}
	local bfaZones = {[1861]=true,[2070]=true,[2096]=true,[2164]=true,[2217]=true}
	local challengeScenarios = {[1148]=true,[1698]=true,[1710]=true,[1703]=true,[1702]=true,[1684]=true,[1673]=true,[1616]=true,[2215]=true}
	local pvpZones = {[30]=true,[489]=true,[529]=true,[559]=true,[562]=true,[566]=true,[572]=true,[617]=true,[618]=true,[628]=true,[726]=true,[727]=true,[761]=true,[968]=true,[980]=true,[998]=true,[1105]=true,[1134]=true,[1681]=true,[1803]=true,[2107]=true,[2118]=true,[2177]=true,[2197]=true}
	local oldDungeons = {
		[48]=true,[230]=true,[429]=true,[389]=true,[34]=true,--Classic
		[540]=true,[558]=true,[556]=true,[555]=true,[542]=true,[546]=true,[545]=true,[547]=true,[553]=true,[554]=true,[552]=true,[557]=true,[269]=true,[560]=true,[543]=true,[585]=true,--BC
		[619]=true,[601]=true,[595]=true,[600]=true,[604]=true,[602]=true,[599]=true,[576]=true,[578]=true,[574]=true,[575]=true,[608]=true,[658]=true,[632]=true,[668]=true,[650]=true,--Wrath
		[755]=true,[645]=true,[36]=true,[670]=true,[644]=true,[33]=true,[643]=true,[725]=true,[657]=true,[309]=true,[859]=true,[568]=true,[938]=true,[940]=true,[939]=true,[646]=true,--Cata
		[960]=true,[961]=true,[959]=true,[962]=true,[994]=true,[1011]=true,[1007]=true,[1001]=true,[1004]=true,--MoP
		[1182]=true,[1175]=true,[1208]=true,[1195]=true,[1279]=true,[1176]=true,[1209]=true,[1358]=true,--WoD
		[1501]=true,[1466]=true,[1456]=true,[1477]=true,[1458]=true,[1516]=true,[1571]=true,[1492]=true,[1544]=true,[1493]=true,[1651]=true,[1677]=true,[1753]=true--Legion
		--[1763]=true,[1754]=true,[1762]=true,[1864]=true,[1822]=true,[1877]=true,[1594]=true,[1841]=true,[1771]=true,[1862]=true,[2097]=true--BfA Dungeons
	}
	--This never wants to spam you to use mods for trivial content you don't need mods for.
	--It's intended to suggest mods for content that's relevant to your level (TW, leveling up in dungeons, or even older raids you can't just roll over)
	function DBM:CheckAvailableMods()
		if _G["BigWigs"] or modAdvertisementShown then return end--If they are running two boss mods at once, lets assume they are only using DBM for a specific feature (such as brawlers) and not nag
		if isRetail then
			local timeWalking = C_PlayerInfo.IsPlayerInChromieTime() or difficultyIndex == 24 or difficultyIndex == 33
			if oldDungeons[LastInstanceMapID] and (timeWalking or playerLevel < 50) and not GetAddOnInfo("DBM-Party-BC") then
				AddMsg(self, L.MOD_AVAILABLE:format("DBM Old Dungeon mods"))
				modAdvertisementShown = true
			elseif (classicZones[LastInstanceMapID] or bcZones[LastInstanceMapID]) and (timeWalking or playerLevel < 31) and not GetAddOnInfo("DBM-BlackTemple") then
				AddMsg(self, L.MOD_AVAILABLE:format("DBM BC/Vanilla mods"))
				modAdvertisementShown = true
			elseif wrathZones[LastInstanceMapID] and (timeWalking or playerLevel < 31) and not GetAddOnInfo("DBM-Ulduar") then
				AddMsg(self, L.MOD_AVAILABLE:format("DBM Wrath of the Lich King mods"))
				modAdvertisementShown = true
			elseif cataZones[LastInstanceMapID] and (timeWalking or playerLevel < 36) and not GetAddOnInfo("DBM-Firelands") then
				AddMsg(self, L.MOD_AVAILABLE:format("DBM Cataclysm mods"))
				modAdvertisementShown = true
			elseif mopZones[LastInstanceMapID] and (timeWalking or playerLevel < 36) and not GetAddOnInfo("DBM-SiegeOfOrgrimmarV2") then
				AddMsg(self, L.MOD_AVAILABLE:format("DBM Mists of Pandaria mods"))
				modAdvertisementShown = true
			elseif wodZones[LastInstanceMapID] and (timeWalking or playerLevel < 41) and not GetAddOnInfo("DBM-HellfireCitadel") then
				AddMsg(self, L.MOD_AVAILABLE:format("DBM Warlords of Draenor mods"))
				modAdvertisementShown = true
			elseif legionZones[LastInstanceMapID] and (timeWalking or playerLevel < 51) and not GetAddOnInfo("DBM-AntorusBurningThrone") then--Technically 45 level with quish, but because of tuning you need need mods even at 50
				AddMsg(self, L.MOD_AVAILABLE:format("DBM Legion mods"))
				modAdvertisementShown = true
			elseif bfaZones[LastInstanceMapID] and (timeWalking or playerLevel < 61) and not GetAddOnInfo("DBM-Nyalotha") then--Technically 50, but tuning and huge loss of player power, zones are even HARDER at 60
				AddMsg(self, L.MOD_AVAILABLE:format("DBM Battle for Azeroth mods"))
				modAdvertisementShown = true
			elseif challengeScenarios[LastInstanceMapID] and not GetAddOnInfo("DBM-Challenges") then
				AddMsg(self, L.MOD_AVAILABLE:format("DBM-Challenges"))
				modAdvertisementShown = true
			end
		end
		if pvpZones[LastInstanceMapID] and not GetAddOnInfo("DBM-PvP") then
			AddMsg(self, L.MOD_AVAILABLE:format("DBM-PvP"))
			modAdvertisementShown = true
		end
	end
	function DBM:TransitionToDungeonBGM(force, cleanup)
		if cleanup then--Runs on zone change/cinematic Start (first load delay) and combat end
			self:Unschedule(self.TransitionToDungeonBGM)
			if self.Options.RestoreSettingMusic then
				SetCVar("Sound_EnableMusic", self.Options.RestoreSettingMusic)
				self.Options.RestoreSettingMusic = nil
				self:Debug("Restoring Sound_EnableMusic CVAR")
			end
			if self.Options.musicPlaying then--Primarily so DBM doesn't call StopMusic unless DBM is one that started it. We don't want to screw with other addons
				StopMusic()
				self.Options.musicPlaying = nil
				self:Debug("Stopping music")
			end
			fireEvent("DBM_MusicStop", "ZoneOrCombatEndTransition")
			return
		end
		if LastInstanceType ~= "raid" and LastInstanceType ~= "party" and not force then return end
		fireEvent("DBM_MusicStart", "RaidOrDungeon")
		if self.Options.EventSoundDungeonBGM and self.Options.EventSoundDungeonBGM ~= "None" and self.Options.EventSoundDungeonBGM ~= "" and not (self.Options.EventDungMusicMythicFilter and (savedDifficulty == "mythic" or savedDifficulty == "challenge")) then
			if not self.Options.RestoreSettingMusic then
				self.Options.RestoreSettingMusic = tonumber(GetCVar("Sound_EnableMusic")) or 1
				if self.Options.RestoreSettingMusic == 0 then
					SetCVar("Sound_EnableMusic", 1)
				else
					self.Options.RestoreSettingMusic = nil--Don't actually need it
				end
			end
			local path = "MISSING"
			if self.Options.EventSoundDungeonBGM == "Random" then
				local usedTable = self.Options.EventSoundMusicCombined and DBM:GetMusic() or DBM:GetDungeonMusic()
				if #usedTable >= 3 then
					local random = fastrandom(3, #usedTable)
					path = usedTable[random].value
				end
			else
				path = self.Options.EventSoundDungeonBGM
			end
			if path ~= "MISSING" then
				PlayMusic(path)
				self.Options.musicPlaying = true
				self:Debug("Starting Dungeon music with file: "..path)
			end
		end
	end
	local function SecondaryLoadCheck(self)
		local _, instanceType, difficulty, _, _, _, _, mapID, instanceGroupSize = GetInstanceInfo()
		local currentDifficulty, currentDifficultyText, _, _, keystoneLevel = self:GetCurrentInstanceDifficulty()
		if currentDifficulty ~= savedDifficulty then
			savedDifficulty, difficultyText, difficultyModifier = currentDifficulty, currentDifficultyText, keystoneLevel
		end
		self:Debug("Instance Check fired with mapID "..mapID.." and difficulty "..difficulty, 2)
		-- Auto Logging for entire zone if record only bosses is off
		-- This Bypasses Same ID check because we still need to recheck this on keystone difficulty check
		if not self.Options.RecordOnlyBosses then
			if LastInstanceType == "raid" or LastInstanceType == "party" then
				self:StartLogging(0, nil)
			else
				self:StopLogging()
			end
		end
		--These can still change even if mapID doesn't
		difficultyIndex = difficulty
		LastGroupSize = instanceGroupSize
		if LastInstanceMapID == mapID then
			self:TransitionToDungeonBGM()
			self:Debug("No action taken because mapID hasn't changed since last check", 2)
			return
		end--ID hasn't changed, don't waste cpu doing anything else (example situation, porting into garrosh stage 4 is a loading screen)
		LastInstanceMapID = mapID
		DBMScheduler:UpdateZone()--Also update zone in scheduler
		if instanceType == "none" or (C_Garrison and C_Garrison:IsOnGarrisonMap()) then
			LastInstanceType = "none"
			if not targetEventsRegistered then
				self:RegisterShortTermEvents("UPDATE_MOUSEOVER_UNIT", "NAME_PLATE_UNIT_ADDED", "UNIT_TARGET_UNFILTERED")
				targetEventsRegistered = true
			end
		else
			LastInstanceType = instanceType
			if targetEventsRegistered then
				self:UnregisterShortTermEvents()
				targetEventsRegistered = false
			end
			if savedDifficulty == "worldboss" then
				for i = #inCombat, 1, -1 do
					self:EndCombat(inCombat[i], true)
				end
			end
		end
		-- LoadMod
		self:LoadModsOnDemand("mapId", mapID)
		if self.Options.ShowReminders then
			self:CheckAvailableMods()
		end
		if self:HasMapRestrictions() then
			self.Arrow:Hide()
			self.HudMap:Disable()
			if self.RangeCheck:IsRadarShown() then
				self.RangeCheck:Hide(true)
			end
		end
	end
	--Faster and more accurate loading for instances, but useless outside of them
	function DBM:LOADING_SCREEN_DISABLED()
		if isRetail then
			DBT:CancelBar(L.LFG_INVITE)--Disable bar here since LFG_PROPOSAL_SUCCEEDED seems broken right now
		end
		fireEvent("DBM_TimerStop", "DBMLFGTimer")
		timerRequestInProgress = false
		self:Debug("LOADING_SCREEN_DISABLED fired")
		self:Unschedule(SecondaryLoadCheck)
		--SecondaryLoadCheck(self)
		self:Schedule(1, SecondaryLoadCheck, self)--Now delayed by one second to work around an issue on 8.x where spec info isn't available yet on reloadui
		self:TransitionToDungeonBGM(false, true)
		self:Schedule(5, SecondaryLoadCheck, self)
		if self:HasMapRestrictions() then
			self.Arrow:Hide()
			self.HudMap:Disable()
			if self.RangeCheck:IsRadarShown() then
				self.RangeCheck:Hide(true)
			end
		end
	end

	function DBM:CHALLENGE_MODE_RESET()
		if not self.Options.RecordOnlyBosses then
			self:StartLogging(0, nil, true)
		end
	end

	function DBM:LOADING_SCREEN_ENABLED()
		--TimerTracker Cleanup, required to work around logic code blizzard put into TimerTracker for /countdown timers
		--TimerTracker is hard coded that if a type 3 timer exists, to give it prio over type 1 and type 2. This causes the M+ timer not to show, even if only like 0.01 sec was left on the /countdown
		--We want to avoid situations where players start a 10 second timer, but click keystone with fractions of a second left, preventing them from seeing the M+ timer
		if not DBM.Options.DontShowPTCountdownText and TimerTracker then -- Doesn't exist in classic
			for _, tttimer in pairs(TimerTracker.timerList) do
				if tttimer.type == 3 and not tttimer.isFree then
					FreeTimerTrackerTimer(tttimer)
					break
				end
			end
		end
	end

	function DBM:LoadModsOnDemand(checkTable, checkValue)
		self:Debug("LoadModsOnDemand fired")
		for _, v in ipairs(self.AddOns) do
			local modTable = v[checkTable]
			local enabled = GetAddOnEnableState(playerName, v.modId)
			--self:Debug(v.modId.." is "..enabled, 2)
			if not IsAddOnLoaded(v.modId) and modTable and checkEntry(modTable, checkValue) then
				if enabled ~= 0 then
					self:LoadMod(v)
				else
					if self.Options.ShowReminders then
						self:AddMsg(L.LOAD_MOD_DISABLED:format(v.name))
					end
				end
			end
		end
		if isRetail then
			self:ScenarioCheck()--Do not filter. Because ScenarioCheck function includes filter.
		end
	end
end

--Scenario mods
function DBM:ScenarioCheck()
	if dbmIsEnabled and combatInfo[LastInstanceMapID] then
		for _, v in ipairs(combatInfo[LastInstanceMapID]) do
			if (v.type == "scenario") and checkEntry(v.msgs, LastInstanceMapID) then
				self:StartCombat(v.mod, 0, "LOADING_SCREEN_DISABLED")
			end
		end
	end
end

function DBM:LoadMod(mod, force)
	if type(mod) ~= "table" then
		self:Debug("LoadMod failed because mod table not valid")
		return false
	end
	--Block loading world boss mods by zoneID, except if it's a heroic warfront
	if mod.isWorldBoss and not IsInInstance() and not force and (not isRetail or difficultyIndex ~= 149) then
		return
	end
	if mod.minRevision > self.Revision then
		if self:AntiSpam(60, "VER_MISMATCH") then--Throttle message in case person keeps trying to load mod (or it's a world boss player keeps targeting
			self:AddMsg(L.LOAD_MOD_VER_MISMATCH:format(mod.name))
		end
		return
	end
	if mod.minExpansion > GetExpansionLevel() then
		self:AddMsg(L.LOAD_MOD_EXP_MISMATCH:format(mod.name))
		return
	elseif not testBuild and mod.minToc > wowTOC then
		self:AddMsg(L.LOAD_MOD_TOC_MISMATCH:format(mod.name, mod.minToc))
		return
	end
	if not currentSpecID then
		self:SetCurrentSpecInfo()
	end
	if not difficultyIndex then -- prevent error in EJ_SetDifficulty if not yet set
		savedDifficulty, difficultyText, difficultyIndex, LastGroupSize, difficultyModifier = self:GetCurrentInstanceDifficulty()
	end
	if isRetail then
		EJ_SetDifficulty(difficultyIndex)--Work around blizzard crash bug where other mods (like Boss) screw with Ej difficulty value, which makes EJ_GetSectionInfo crash the game when called with invalid difficulty index set.
	end
	self:Debug("LoadAddOn should have fired for "..mod.name, 2)
	local loaded, reason = LoadAddOn(mod.modId)
	if not loaded then
		if reason then
			self:AddMsg(L.LOAD_MOD_ERROR:format(tostring(mod.name), tostring(_G["ADDON_"..reason or ""])))
		else
			self:Debug("LoadAddOn failed and did not give reason")
		end
		return false
	else
		self:Debug("LoadAddOn should have succeeded for "..mod.name, 2)
		self:AddMsg(L.LOAD_MOD_SUCCESS:format(tostring(mod.name)))
		if self.NewerVersion and showConstantReminder >= 1 then
			AddMsg(self, L.UPDATEREMINDER_HEADER:format(self.NewerVersion, showRealDate(self.HighestRelease)))
		end
		self:LoadModOptions(mod.modId, InCombatLockdown(), true)
		if DBM_GUI then
			DBM_GUI:UpdateModList()
		end
		if LastInstanceType ~= "pvp" and #inCombat == 0 and IsInGroup() then--do timer recovery only mod load
			if not timerRequestInProgress then
				timerRequestInProgress = true
				-- Request timer to 3 person to prevent failure.
				self:Unschedule(self.RequestTimers)
				self:Schedule(7, self.RequestTimers, self, 1)
				self:Schedule(10, self.RequestTimers, self, 2)
				self:Schedule(13, self.RequestTimers, self, 3)
				C_TimerAfter(15, function() timerRequestInProgress = false end)
				self:GROUP_ROSTER_UPDATE(true)
			end
		end
		if not InCombatLockdown() and not UnitAffectingCombat("player") and not IsFalling() then--We loaded in combat but still need to avoid garbage collect in combat
			collectgarbage("collect")
		end
		return true
	end
end

do
	local function loadModByUnit(uId)
		if IsInInstance() or not UnitIsFriend("player", uId) and UnitIsDead("player") or UnitIsDead(uId) then return end--If you're in an instance no reason to waste cpu. If THE BOSS dead, no reason to load a mod for it. To prevent rare lua error, needed to filter on player dead.
		local guid = UnitGUID(uId)
		if guid and DBM:IsCreatureGUID(guid) then
			local cId = DBM:GetCIDFromGUID(guid)
			for bosscId, addon in pairs(loadcIds) do
				local enabled = GetAddOnEnableState(playerName, addon)
				if cId and bosscId and cId == bosscId and not IsAddOnLoaded(addon) and enabled ~= 0 then
					for _, v in ipairs(DBM.AddOns) do
						if v.modId == addon then
							DBM:LoadMod(v, true)
							break
						end
					end
				end
			end
		end
	end

	--Loading routeens checks for world bosses based on target or mouseover or nameplate.
	function DBM:UPDATE_MOUSEOVER_UNIT()
		loadModByUnit("mouseover")
	end

	function DBM:NAME_PLATE_UNIT_ADDED(uId)
		loadModByUnit(uId)
	end

	function DBM:UNIT_TARGET_UNFILTERED(uId)
		loadModByUnit(uId.."target")
	end
end

-----------------------------
--  Handle Incoming Syncs  --
-----------------------------

do
	local function checkForActualPull()
		if (DBM.Options.RecordOnlyBosses and #inCombat == 0) or (not isRetail and difficultyIndex ~= 8) then
			DBM:StopLogging()
		end
	end

	local syncHandlers, whisperSyncHandlers, guildSyncHandlers = {}, {}, {}

	-- DBM uses the following prefixes since 4.1 as pre-4.1 sync code is going to be incompatible anways, so this is the perfect opportunity to throw away the old and long names
	-- M = Mod
	-- C = Combat start
	-- GC = Guild Combat Start
	-- IS = Icon set info
	-- K = Kill
	-- H = Hi!
	-- V = Incoming version information
	-- U = User Timer
	-- PT = Pull Timer (for sound effects, the timer itself is still sent as a normal timer)
	-- RT = Request Timers
	-- CI = Combat Info
	-- TR = Timer Recovery
	-- IR = Instance Info Request
	-- IRE = Instance Info Requested Ended/Canceled
	-- II = Instance Info
	-- WBE = World Boss engage info
	-- WBD = World Boss defeat info
	-- WBA = World Buff Activation
	-- DSW = Disable Send Whisper
	-- NS = Note Share

	syncHandlers["M"] = function(sender, mod, revision, event, ...)
		mod = DBM:GetModByName(mod or "")
		if mod and event and revision then
			revision = tonumber(revision) or 0
			mod:ReceiveSync(event, sender, revision, ...)
		end
	end

	syncHandlers["NS"] = function(sender, modid, modvar, text, abilityName)
		if sender == playerName then return end
		if DBM.Options.BlockNoteShare or InCombatLockdown() or UnitAffectingCombat("player") or IsFalling() then return end--or DBM:GetRaidRank(sender) == 0
		if IsInGroup(2) and IsInInstance() then return end
		--^^You are in LFR, BG, or LFG. Block note syncs. They shouldn't be sendable, but in case someone edits DBM^^
		local mod = DBM:GetModByName(modid or "")
		local ability = abilityName or CL.UNKNOWN
		if mod and modvar and text and text ~= "" then
			if DBM:AntiSpam(5, modvar) then--Don't allow calling same note more than once per 5 seconds
				DBM:AddMsg(L.NOTE_SHARE_SUCCESS:format(sender, ability))
				DBM:AddMsg(("|Hgarrmission:DBM:noteshare:%s:%s:%s:%s:%s|h|cff3588ff[%s]|r|h"):format(modid, modvar, ability, text, sender, L.NOTE_SHARE_LINK))
				--DBM:ShowNoteEditor(mod, modvar, ability, text, sender)
			else
				DBM:Debug(sender.." is attempting to send too many notes so notes are being throttled")
			end
		else
			DBM:AddMsg(L.NOTE_SHARE_FAIL:format(sender, ability))
		end
	end

	syncHandlers["C"] = function(sender, delay, mod, modRevision, startHp, dbmRevision, modHFRevision, event)
		if not dbmIsEnabled or sender == playerName then return end
		if LastInstanceType == "pvp" then return end
		if LastInstanceType == "none" and (not UnitAffectingCombat("player") or #inCombat > 0) then--world boss
			local senderuId = DBM:GetRaidUnitId(sender)
			if not senderuId then return end--Should never happen, but just in case. If happens, MANY "C" syncs are sent. losing 1 no big deal.
			local _, _, _, playerZone = UnitPosition("player")
			local _, _, _, senderZone = UnitPosition(senderuId)
			if playerZone ~= senderZone then return end--not same zone
			local range = DBM.RangeCheck:GetDistance("player", senderuId)--Same zone, so check range
			if not range or range > 120 then return end
		end
		if not cSyncSender[sender] then
			cSyncSender[sender] = true
			cSyncReceived = cSyncReceived + 1
			if cSyncReceived > 2 then -- need at least 3 sync to combat start. (for security)
				local lag = select(4, GetNetStats()) / 1000
				delay = tonumber(delay or 0) or 0
				mod = DBM:GetModByName(mod or "")
				modRevision = tonumber(modRevision or 0) or 0
				dbmRevision = tonumber(dbmRevision or 0) or 0
				modHFRevision = tonumber(modHFRevision or 0) or 0
				startHp = tonumber(startHp or -1) or -1
				if dbmRevision < 10481 then return end
				if mod and delay and (not mod.zones or mod.zones[LastInstanceMapID]) and (not mod.minSyncRevision or modRevision >= mod.minSyncRevision) then
					DBM:StartCombat(mod, delay + lag, "SYNC from - "..sender, true, startHp, event)
					if mod.revision < modHFRevision then--mod.revision because we want to compare to OUR revision not senders
						--There is a newer RELEASE version of DBM out that has this mods fixes that we do not possess
						if DBM.HighestRelease >= modHFRevision and DBM.ReleaseRevision < modHFRevision then
							showConstantReminder = 2
							if DBM:AntiSpam(3, "HOTFIX") then
								AddMsg(DBM, L.UPDATEREMINDER_HOTFIX)
							end
						else--This mods fixes are in an alpha version
							if DBM:AntiSpam(3, "HOTFIX") then
								AddMsg(DBM, L.UPDATEREMINDER_HOTFIX_ALPHA)
							end
						end
					end
				end
			end
		end
	end

	syncHandlers["DSW"] = function(sender)
		if (DBM:GetRaidRank(sender) ~= 2 or not IsInGroup()) then return end--If not on group, we're probably sender, don't disable status. IF not leader, someone is trying to spoof this, block that too
		statusWhisperDisabled = true
		DBM:Debug("Raid leader has disabled status whispers")
	end

	syncHandlers["DGP"] = function(sender)
		if (DBM:GetRaidRank(sender) ~= 2 or not IsInGroup()) then return end--If not on group, we're probably sender, don't disable status. IF not leader, someone is trying to spoof this, block that too
		statusGuildDisabled = true
		DBM:Debug("Raid leader has disabled guild progress messages")
	end

	syncHandlers["IS"] = function(_, guid, ver, optionName)
		ver = tonumber(ver) or 0
		if ver > (iconSetRevision[optionName] or 0) then--Save first synced version and person, ignore same version. refresh occurs only above version (fastest person)
			iconSetRevision[optionName] = ver
			iconSetPerson[optionName] = guid
		end
		if iconSetPerson[optionName] == UnitGUID("player") then--Check if that highest version was from ourself
			private.canSetIcons[optionName] = true
		else--Not from self, it means someone with a higher version than us probably sent it
			private.canSetIcons[optionName] = false
		end
		local name = DBM:GetFullPlayerNameByGUID(iconSetPerson[optionName]) or CL.UNKNOWN
		DBM:Debug(name.." was elected icon setter for "..optionName, 2)
	end

	syncHandlers["K"] = function(_, cId)
		if select(2, IsInInstance()) == "pvp" or select(2, IsInInstance()) == "none" then return end
		cId = tonumber(cId or "")
		if cId then DBM:OnMobKill(cId, true) end
	end

	syncHandlers["EE"] = function(sender, eId, success, mod, modRevision)
		if select(2, IsInInstance()) == "pvp" then return end
		eId = tonumber(eId or "")
		success = tonumber(success)
		mod = DBM:GetModByName(mod or "")
		modRevision = tonumber(modRevision or 0) or 0
		if mod and eId and success and (not mod.minSyncRevision or modRevision >= mod.minSyncRevision) and not eeSyncSender[sender] then
			eeSyncSender[sender] = true
			eeSyncReceived = eeSyncReceived + 1
			if eeSyncReceived > 2 then -- need at least 3 person to combat end. (for security)
				DBM:EndCombat(mod, success == 0)
			end
		end
	end

	local dummyMod -- dummy mod for the pull timer
	syncHandlers["PT"] = function(sender, timer, senderMapID, target)
		if DBM.Options.DontShowUserTimers then return end
		local LFGTankException = isRetail and IsPartyLFG() and UnitGroupRolesAssigned(sender) == "TANK"
		if (DBM:GetRaidRank(sender) == 0 and IsInGroup() and not LFGTankException) or select(2, IsInInstance()) == "pvp" or IsEncounterInProgress() then
			return
		end
		--Abort if mapID filter is enabled and sender actually sent a mapID. if no mapID is sent, it's always passed through (IE BW pull timers)
		if DBM.Options.DontShowPTNoID and senderMapID and tonumber(senderMapID) ~= LastInstanceMapID then return end
		timer = tonumber(timer or 0)
		--We want to permit 0 itself, but block anything negative number or anything between 0 and 3 or anything longer than minute
		if timer > 60 or (timer > 0 and timer < 3) or timer < 0 then
			return
		end
		if not dummyMod then
			local threshold = DBM.Options.PTCountThreshold2
			threshold = floor(threshold)
			dummyMod = DBM:NewMod("PullTimerCountdownDummy")
			DBM:GetModLocalization("PullTimerCountdownDummy"):SetGeneralLocalization{ name = L.MINIMAP_TOOLTIP_HEADER }
			dummyMod.text = dummyMod:NewAnnounce("%s", 1, "132349")
			dummyMod.geartext = dummyMod:NewSpecialWarning("  %s  ", nil, nil, nil, 3)
			dummyMod.timer = dummyMod:NewTimer(20, "%s", "132349", nil, nil, 0, nil, nil, DBM.Options.DontPlayPTCountdown and 0 or 1, threshold)
		end
		--Cancel any existing pull timers before creating new ones, we don't want double countdowns or mismatching blizz countdown text (cause you can't call another one if one is in progress)
		if not DBM.Options.DontShowPT2 then--and DBT:GetBar(L.TIMER_PULL)
			dummyMod.timer:Stop()
		end
		local timerTrackerRunning = false
		if not DBM.Options.DontShowPTCountdownText and TimerTracker then
			for _, tttimer in pairs(TimerTracker.timerList) do
				if not tttimer.isFree then--Timer event running
					if tttimer.type == 3 then--Its a pull timer event, this is one we cancel before starting a new pull timer
						FreeTimerTrackerTimer(tttimer)
					else--Verify that a TimerTracker event NOT started by DBM isn't running, if it is, prevent executing new TimerTracker events below
						timerTrackerRunning = true
					end
				end
			end
		end
		dummyMod.text:Cancel()
		if timer == 0 then return end--"/dbm pull 0" will strictly be used to cancel the pull timer (which is why we let above part of code run but not below)
		DBM:FlashClientIcon()
		if not DBM.Options.DontShowPT2 then
			dummyMod.timer:Start(timer, L.TIMER_PULL)
		end
		if not DBM.Options.DontShowPTCountdownText and TimerTracker then
			if not timerTrackerRunning then--if a TimerTracker event is running not started by DBM, block creating one of our own (object gets buggy if it has 2+ events running)
				--Start A TimerTracker timer using the new countdown type 3 type (ie what C_PartyInfo.DoCountdown triggers, but without sending it to entire group)
				TimerTracker_OnEvent(TimerTracker, "START_TIMER", 3, timer, timer)
				--Find the timer object DBM just created and hack our own changes into it.
				for _, tttimer in pairs(TimerTracker.timerList) do
					if tttimer.type == 3 and not tttimer.isFree then
						--We don't want the PVP bar, we only want timer text
						if timer > 10 then
							--b.startNumbers:Play()
							tttimer.bar:Hide()
						end
						break
					end
				end
			end
		end
		if not DBM.Options.DontShowPTText then
			if target then
				dummyMod.text:Show(L.ANNOUNCE_PULL_TARGET:format(target, timer, sender))
				dummyMod.text:Schedule(timer, L.ANNOUNCE_PULL_NOW_TARGET:format(target))
			else
				dummyMod.text:Show(L.ANNOUNCE_PULL:format(timer, sender))
				dummyMod.text:Schedule(timer, L.ANNOUNCE_PULL_NOW)
			end
		end
		if DBM.Options.EventSoundPullTimer and DBM.Options.EventSoundPullTimer ~= "" and DBM.Options.EventSoundPullTimer ~= "None" then
			DBM:PlaySoundFile(DBM.Options.EventSoundPullTimer, nil, true)
		end
		if DBM.Options.RecordOnlyBosses then
			DBM:StartLogging(timer, checkForActualPull)--Start logging here to catch pre pots.
		end
		if isRetail and DBM.Options.CheckGear and not testBuild then
			local bagilvl, equippedilvl = GetAverageItemLevel()
			local difference = bagilvl - equippedilvl
			local weapon = GetInventoryItemLink("player", 16)
			local fishingPole = false
			if weapon then
				local _, _, _, _, _, _, type = GetItemInfo(weapon)
				if type and type == L.GEAR_FISHING_POLE then
					fishingPole = true
				end
			end
			if IsInRaid() and difference >= 30 then
				dummyMod.geartext:Show(L.GEAR_WARNING:format(floor(difference)))
			elseif IsInRaid() and (not weapon or fishingPole) then
				dummyMod.geartext:Show(L.GEAR_WARNING_WEAPON)
			end
		end
	end

	do
		local dummyMod2 -- dummy mod for the break timer
		function breakTimerStart(self, timer, sender)
			if not dummyMod2 then
				local threshold = DBM.Options.PTCountThreshold2
				threshold = floor(threshold)
				dummyMod2 = DBM:NewMod("BreakTimerCountdownDummy")
				DBM:GetModLocalization("BreakTimerCountdownDummy"):SetGeneralLocalization{ name = L.MINIMAP_TOOLTIP_HEADER }
				dummyMod2.text = dummyMod2:NewAnnounce("%s", 1, isRetail and "237538" or "136106")
				dummyMod2.timer = dummyMod2:NewTimer(20, L.TIMER_BREAK, isRetail and "237538" or "136106", nil, nil, 0, nil, nil, DBM.Options.DontPlayPTCountdown and 0 or 1, threshold)
			end
			--Cancel any existing break timers before creating new ones, we don't want double countdowns or mismatching blizz countdown text (cause you can't call another one if one is in progress)
			if not DBM.Options.DontShowPT2 then--and DBT:GetBar(L.TIMER_BREAK)
				dummyMod2.timer:Stop()
			end
			dummyMod2.text:Cancel()
			DBM.Options.RestoreSettingBreakTimer = nil
			if timer == 0 then return end--"/dbm break 0" will strictly be used to cancel the break timer (which is why we let above part of code run but not below)
			self.Options.RestoreSettingBreakTimer = timer.."/"..time()
			if not self.Options.DontShowPT2 then
				dummyMod2.timer:Start(timer)
			end
			if not self.Options.DontShowPTText then
				local hour, minute = GetGameTime()
				minute = minute+(timer/60)
				if minute >= 60 then
					hour = hour + 1
					minute = minute - 60
				end
				minute = floor(minute)
				if minute < 10 then
					minute = tostring(0 .. minute)
				end
				dummyMod2.text:Show(L.BREAK_START:format(strFromTime(timer).." ("..hour..":"..minute..")", sender))
				if timer/60 > 10 then dummyMod2.text:Schedule(timer - 10*60, L.BREAK_MIN:format(10)) end
				if timer/60 > 5 then dummyMod2.text:Schedule(timer - 5*60, L.BREAK_MIN:format(5)) end
				if timer/60 > 2 then dummyMod2.text:Schedule(timer - 2*60, L.BREAK_MIN:format(2)) end
				if timer/60 > 1 then dummyMod2.text:Schedule(timer - 1*60, L.BREAK_MIN:format(1)) end
				dummyMod2.text:Schedule(timer, L.ANNOUNCE_BREAK_OVER:format(hour..":"..minute))
			end
			C_TimerAfter(timer, function() self.Options.RestoreSettingBreakTimer = nil end)
		end
	end

	syncHandlers["BT"] = function(sender, timer)
		if DBM.Options.DontShowUserTimers then return end
		timer = tonumber(timer or 0)
		if timer > 3600 then return end
		if (DBM:GetRaidRank(sender) == 0 and IsInGroup()) or select(2, IsInInstance()) == "pvp" or IsEncounterInProgress() then
			return
		end
		breakTimerStart(DBM, timer, sender)
	end

	whisperSyncHandlers["BTR3"] = function(sender, timer)
		if DBM.Options.DontShowUserTimers then return end
		timer = tonumber(timer or 0)
		if timer > 3600 then return end
		DBM:Unschedule(DBM.RequestTimers)--IF we got BTR3 sync, then we know immediately RequestTimers was successful, so abort others
		if #inCombat >= 1 then return end
		if DBT:GetBar(L.TIMER_BREAK) then return end--Already recovered. Prevent duplicate recovery
		breakTimerStart(DBM, timer, sender)
	end

	local function SendVersion(guild)
		if guild then
			local message = ("%s\t%s\t%s"):format(tostring(DBM.Revision), tostring(DBM.ReleaseRevision), DBM.DisplayVersion)
			SendAddonMessage(DBMPrefix, "GV\t" .. message, "GUILD")
			return
		end
		if DBM.Options.FakeBWVersion then
			SendAddonMessage("BigWigs", bwVersionResponseString:format(fakeBWVersion, fakeBWHash), IsInGroup(2) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or "PARTY")
			return
		end
		--(Note, faker isn't to screw with bigwigs nor is theirs to screw with dbm, but rathor raid leaders who don't let people run WTF they want to run)
		local VPVersion
		local VoicePack = DBM.Options.ChosenVoicePack2
		if not voiceSessionDisabled and VoicePack ~= "None" and DBM.VoiceVersions[VoicePack] then
			VPVersion = "/ VP"..VoicePack..": v"..DBM.VoiceVersions[VoicePack]
		end
		if VPVersion then
			sendSync("V", ("%s\t%s\t%s\t%s\t%s\t%s"):format(tostring(DBM.Revision), tostring(DBM.ReleaseRevision), DBM.DisplayVersion, GetLocale(), tostring(not DBM.Options.DontSetIcons), VPVersion))
		else
			sendSync("V", ("%s\t%s\t%s\t%s\t%s"):format(tostring(DBM.Revision), tostring(DBM.ReleaseRevision), DBM.DisplayVersion, GetLocale(), tostring(not DBM.Options.DontSetIcons)))
		end
	end

	local function HandleVersion(revision, version, displayVersion, sender)
		if version > DBM.Revision then -- Update reminder
			if false and #newerVersionPerson < 4 then
				if not checkEntry(newerVersionPerson, sender) then
					newerVersionPerson[#newerVersionPerson + 1] = sender
					DBM:Debug("Newer version detected from "..sender.." : Rev - "..revision..", Ver - "..version..", Rev Diff - "..(revision - DBM.Revision), 3)
				end
				if #newerVersionPerson == 2 and updateNotificationDisplayed < 2 then--Only requires 2 for update notification.
					if DBM.HighestRelease < version then
						DBM.HighestRelease = version--Increase HighestRelease
						DBM.NewerVersion = displayVersion--Apply NewerVersion
						--UGLY hack to get release version number instead of alpha one
						if DBM.NewerVersion:find("alpha") then
							local temp1, _ = string.split(" ", DBM.NewerVersion)--Strip down to just version, no alpha
							if temp1 then
								local temp3, temp4, temp5 = string.split(".", temp1)--Strip version down to 3 numbers
								if temp3 and temp4 and temp5 and tonumber(temp5) then
									temp5 = tonumber(temp5)
									temp5 = temp5 - 1
									temp5 = tostring(temp5)
									DBM.NewerVersion = temp3.."."..temp4.."."..temp5
								end
							end
						end
					end
					--Find min revision.
					updateNotificationDisplayed = 2
					AddMsg(DBM, L.UPDATEREMINDER_HEADER:match("([^\n]*)"))
					AddMsg(DBM, L.UPDATEREMINDER_HEADER:match("\n(.*)"):format(displayVersion, showRealDate(version)))
					showConstantReminder = 1
				elseif #newerVersionPerson == 3 and raid[newerVersionPerson[1]] and raid[newerVersionPerson[2]] and raid[newerVersionPerson[3]] and updateNotificationDisplayed < 3 then--The following code requires at least THREE people to send that higher revision. That should be more than adaquate
					--Disable if out of date and it's a major patch.
					if not testBuild and dbmToc < wowTOC then
						updateNotificationDisplayed = 3
						AddMsg(DBM, L.UPDATEREMINDER_MAJORPATCH)
						DBM:Disable(true)
					--Disallow out of date to run during beta/ptr what so ever.
					elseif testBuild then
						updateNotificationDisplayed = 3
						AddMsg(DBM, L.UPDATEREMINDER_DISABLE)
						DBM:Disable(true)
					end
				end
			end
		end
	end

	-- TODO: is there a good reason that version information is broadcasted and not unicasted?
	syncHandlers["H"] = function()
		DBM:Unschedule(SendVersion)--Throttle so we don't needlessly send tons of comms during initial raid invites
		DBM:Schedule(3, SendVersion)--Send version if 3 seconds have past since last "Hi" sync
	end

	guildSyncHandlers["GH"] = function()
		if DBM.ReleaseRevision >= DBM.HighestRelease then--Do not send version to guild if it's not up to date, since this is only used for update notifcation
			DBM:Unschedule(SendVersion, true)
			--Throttle so we don't needlessly send tons of comms
			--For every 50 players online, DBM has an increasingly lower chance of replying to a version check request. This is because only 3 people actually need to reply
			--50 people or less, 100% chance anyone who saw request will reply
			--100 people on, only 50% chance DBM users replies to request
			--150 people on, only 33% chance a DBM user replies to request
			--1000 people online, only 5% chance a DBM user replies to request
			local _, online = GetNumGuildMembers()
			local chances = (online or 1) / 50
			if chances < 1 then chances = 1 end
			if mrandom(1, chances) == 1 then
				DBM:Schedule(5, SendVersion, true)--Send version if 5 seconds have past since last "Hi" sync
			end
		end
	end

	syncHandlers["BV"] = function(sender, version, hash)--Parsed from bigwigs V7+
		if version and raid[sender] then
			raid[sender].bwversion = version
			raid[sender].bwhash = hash or ""
		end
	end

	syncHandlers["V"] = function(sender, revision, version, displayVersion, locale, iconEnabled, VPVersion)
		revision, version = tonumber(revision), tonumber(version)
		if revision and version and displayVersion and raid[sender] then
			raid[sender].revision = revision
			raid[sender].version = version
			raid[sender].displayVersion = displayVersion
			raid[sender].VPVersion = VPVersion
			raid[sender].locale = locale
			raid[sender].enabledIcons = iconEnabled or "false"
			DBM:Debug("Received version info from "..sender.." : Rev - "..revision..", Ver - "..version..", Rev Diff - "..(revision - DBM.Revision), 3)
			HandleVersion(revision, version, displayVersion, sender)
		end
		DBM:GROUP_ROSTER_UPDATE()
	end

	guildSyncHandlers["GV"] = function(sender, revision, version, displayVersion)
		revision, version = tonumber(revision), tonumber(version)
		if revision and version and displayVersion then
			DBM:Debug("Received G version info from "..sender.." : Rev - "..revision..", Ver - "..version..", Rev Diff - "..(revision - DBM.Revision), 3)
			HandleVersion(revision, version, displayVersion, sender)
		end
	end

	syncHandlers["U"] = function(sender, time, text)
		if select(2, IsInInstance()) == "pvp" then return end -- no pizza timers in battlegrounds
		if DBM.Options.DontShowUserTimers then return end
		if DBM:GetRaidRank(sender) == 0 or difficultyIndex == 7 or difficultyIndex == 17 then return end
		if sender == playerName then return end
		time = tonumber(time or 0)
		text = tostring(text)
		if time and text then
			DBM:CreatePizzaTimer(time, text, nil, sender)
		end
	end

	whisperSyncHandlers["UW"] = function(sender, time, text)
		if select(2, IsInInstance()) == "pvp" then return end -- no pizza timers in battlegrounds
		if DBM.Options.DontShowUserTimers then return end
		if DBM:GetRaidRank(sender) == 0 or difficultyIndex == 7 or difficultyIndex == 17 then return end--Block in LFR, or if not an assistant
		if sender == playerName then return end
		time = tonumber(time or 0)
		text = tostring(text)
		if time and text then
			DBM:CreatePizzaTimer(time, text, nil, sender)
		end
	end

	guildSyncHandlers["GCB"] = function(_, modId, ver, difficulty, difficultyModifier, name)
		if not DBM.Options.ShowGuildMessages or not difficulty then return end
		if not ver or not (ver == "3") then return end--Ignore old versions
		if DBM:AntiSpam(10, "GCB") then
			if IsInInstance() then return end--Simple filter, if you are inside an instance, just filter it, if not in instance, good to go.
			difficulty = tonumber(difficulty)
			if not DBM.Options.ShowGuildMessagesPlus and difficulty == 8 then return end
			modId = tonumber(modId)
			local bossName = modId and (EJ_GetEncounterInfo and EJ_GetEncounterInfo(modId) or DBM:GetModLocalization(modId).general.name) or name or CL.UNKNOWN
			if isRetail then
				local difficultyName
				if difficulty == 8 then
					if difficultyModifier and difficultyModifier ~= 0 then
						difficultyName = PLAYER_DIFFICULTY6.."+ ("..difficultyModifier..")"
					else
						difficultyName = PLAYER_DIFFICULTY6.."+"
					end
				elseif difficulty == 16 then
					difficultyName = PLAYER_DIFFICULTY6
				elseif difficulty == 15 then
					difficultyName = PLAYER_DIFFICULTY2
				else
					difficultyName = PLAYER_DIFFICULTY1
				end
				DBM:AddMsg(L.GUILD_COMBAT_STARTED:format(difficultyName.."-"..bossName))
			else
				DBM:AddMsg(L.GUILD_COMBAT_STARTED:format(bossName))
			end
		end
	end

	guildSyncHandlers["GCE"] = function(_, modId, ver, wipe, time, difficulty, difficultyModifier, name, wipeHP)
		if not DBM.Options.ShowGuildMessages or not difficulty then return end
		if not ver or not (ver == "6") then return end--Ignore old versions
		if DBM:AntiSpam(5, "GCE") then
			if IsInInstance() then return end--Simple filter, if you are inside an instance, just filter it, if not in instance, good to go.
			difficulty = tonumber(difficulty)
			if not DBM.Options.ShowGuildMessagesPlus and difficulty == 8 then return end
			modId = tonumber(modId)
			local bossName = modId and (EJ_GetEncounterInfo and EJ_GetEncounterInfo(modId) or DBM:GetModLocalization(modId).general.name) or name or CL.UNKNOWN
			if isRetail then
				local difficultyName
				if difficulty == 8 then
					if difficultyModifier and difficultyModifier ~= 0 then
						difficultyName = PLAYER_DIFFICULTY6.."+ ("..difficultyModifier..")"
					else
						difficultyName = PLAYER_DIFFICULTY6.."+"
					end
				elseif difficulty == 16 then
					difficultyName = PLAYER_DIFFICULTY6
				elseif difficulty == 15 then
					difficultyName = PLAYER_DIFFICULTY2
				else
					difficultyName = PLAYER_DIFFICULTY1
				end
				if wipe == "1" then
					DBM:AddMsg(L.GUILD_COMBAT_ENDED_AT:format(difficultyName.."-"..bossName, wipeHP, time))
				else
					DBM:AddMsg(L.GUILD_BOSS_DOWN:format(difficultyName.."-"..bossName, time))
				end
			else
				if wipe == "1" then
					DBM:AddMsg(L.GUILD_COMBAT_ENDED_AT:format(bossName, wipeHP, time))
				else
					DBM:AddMsg(L.GUILD_BOSS_DOWN:format(bossName, time))
				end
			end
		end
	end

	guildSyncHandlers["WBE"] = function(sender, modId, realm, health, ver, name)
		if not ver or not (ver == "8") then return end--Ignore old versions
		if lastBossEngage[modId..realm] and (GetTime() - lastBossEngage[modId..realm] < 30) then return end--We recently got a sync about this boss on this realm, so do nothing.
		lastBossEngage[modId..realm] = GetTime()
		if realm == playerRealm and DBM.Options.WorldBossAlert and not IsEncounterInProgress() then
			modId = tonumber(modId)--If it fails to convert into number, this makes it nil
			local bossName = modId and (EJ_GetEncounterInfo and EJ_GetEncounterInfo(modId) or DBM:GetModLocalization(modId).general.name) or name or CL.UNKNOWN
			DBM:AddMsg(L.WORLDBOSS_ENGAGED:format(bossName, floor(health), sender))
		end
	end

	guildSyncHandlers["WBD"] = function(sender, modId, realm, ver, name)
		if not ver or not (ver == "8") then return end--Ignore old versions
		if lastBossDefeat[modId..realm] and (GetTime() - lastBossDefeat[modId..realm] < 30) then return end
		lastBossDefeat[modId..realm] = GetTime()
		if realm == playerRealm and DBM.Options.WorldBossAlert and not IsEncounterInProgress() then
			modId = tonumber(modId)--If it fails to convert into number, this makes it nil
			local bossName = modId and (EJ_GetEncounterInfo and EJ_GetEncounterInfo(modId) or DBM:GetModLocalization(modId).general.name) or name or CL.UNKNOWN
			DBM:AddMsg(L.WORLDBOSS_DEFEATED:format(bossName, sender))
		end
	end

	guildSyncHandlers["WBA"] = function(sender, bossName, faction, spellId, time, ver) -- Classic only
		DBM:Debug("WBA sync recieved")
		if not ver or not (ver == "4") or isRetail then return end--Ignore old versions
		if lastBossEngage[bossName..faction] and (GetTime() - lastBossEngage[bossName..faction] < 30) then return end--We recently got a sync about this buff on this realm, so do nothing.
		lastBossEngage[bossName..faction] = GetTime()
		if DBM.Options.WorldBuffAlert and #inCombat == 0 then
			DBM:Debug("WBA sync processing")
			local factionText = faction == "Alliance" and FACTION_ALLIANCE or faction == "Horde" and FACTION_HORDE or CL.BOTH
			local buffName, _, buffIcon = DBM:GetSpellInfo(tonumber(spellId) or 0)
			DBM:AddMsg(L.WORLDBUFF_STARTED:format(buffName or CL.UNKNOWN, factionText, sender))
			DBM:PlaySound(DBM.Options.RaidWarningSound, true)
			time = tonumber(time)
			if time then
				DBT:CreateBar(time, buffName or CL.UNKNOWN, buffIcon or 136106)
			end
		end
	end

	whisperSyncHandlers["WBE"] = function(sender, modId, realm, health, ver, name)
		if not ver or not (ver == "8") then return end--Ignore old versions
		if lastBossEngage[modId..realm] and (GetTime() - lastBossEngage[modId..realm] < 30) then return end
		lastBossEngage[modId..realm] = GetTime()
		if realm == playerRealm and DBM.Options.WorldBossAlert and (isRetail and not IsEncounterInProgress() or #inCombat == 0) then
			local toonName
			if isRetail then
				local gameAccountInfo = C_BattleNet.GetGameAccountInfoByID(sender)
				toonName = gameAccountInfo and gameAccountInfo.characterName or CL.UNKNOWN
			else
				local _, _toonName = BNGetGameAccountInfo(sender)
				toonName = _toonName
			end
			modId = tonumber(modId)--If it fails to convert into number, this makes it nil
			local bossName = modId and (EJ_GetEncounterInfo and EJ_GetEncounterInfo(modId) or DBM:GetModLocalization(modId).general.name) or name or CL.UNKNOWN
			DBM:AddMsg(L.WORLDBOSS_ENGAGED:format(bossName, floor(health), toonName))
		end
	end

	whisperSyncHandlers["WBD"] = function(sender, modId, realm, ver, name)
		if not ver or not (ver == "8") then return end--Ignore old versions
		if lastBossDefeat[modId..realm] and (GetTime() - lastBossDefeat[modId..realm] < 30) then return end
		lastBossDefeat[modId..realm] = GetTime()
		if realm == playerRealm and DBM.Options.WorldBossAlert and not IsEncounterInProgress() then
			local toonName
			if isRetail then
				local gameAccountInfo = C_BattleNet.GetGameAccountInfoByID(sender)
				toonName = gameAccountInfo and gameAccountInfo.characterName or CL.UNKNOWN
			else
				local _, _toonName = BNGetGameAccountInfo(sender)
				toonName = _toonName
			end
			modId = tonumber(modId)--If it fails to convert into number, this makes it nil
			local bossName = modId and (EJ_GetEncounterInfo and EJ_GetEncounterInfo(modId) or DBM:GetModLocalization(modId).general.name) or name or CL.UNKNOWN
			DBM:AddMsg(L.WORLDBOSS_DEFEATED:format(bossName, toonName))
		end
	end

	whisperSyncHandlers["WBA"] = function(sender, bossName, faction, spellId, time, ver) -- Classic only
		DBM:Debug("WBA sync recieved")
		if not ver or not (ver == "4") or isRetail then return end--Ignore old versions
		if lastBossEngage[bossName..faction] and (GetTime() - lastBossEngage[bossName..faction] < 30) then return end--We recently got a sync about this buff on this realm, so do nothing.
		lastBossEngage[bossName..faction] = GetTime()
		if DBM.Options.WorldBuffAlert and #inCombat == 0 then
			DBM:Debug("WBA sync processing")
			local factionText = faction == "Alliance" and FACTION_ALLIANCE or faction == "Horde" and FACTION_HORDE or L.BOTH
			local buffName, _, buffIcon = DBM:GetSpellInfo(tonumber(spellId) or 0)
			DBM:AddMsg(L.WORLDBUFF_STARTED:format(buffName or CL.UNKNOWN, factionText, sender))
			DBM:PlaySound(DBM.Options.RaidWarningSound, true)
			time = tonumber(time)
			if time then
				DBT:CreateBar(time, buffName or CL.UNKNOWN, buffIcon or 136106)
			end
		end
	end

	whisperSyncHandlers["RT"] = function(sender)
		if UnitInBattleground("player") then
			DBM:SendPVPTimers(sender)
		else
			DBM:SendTimers(sender)
		end
	end

	whisperSyncHandlers["CI"] = function(sender, mod, time)
		mod = DBM:GetModByName(mod or "")
		time = tonumber(time or 0)
		if mod and time then
			DBM:ReceiveCombatInfo(sender, mod, time)
		end
	end

	whisperSyncHandlers["TR"] = function(sender, mod, timeLeft, totalTime, id, paused, ...)
		mod = DBM:GetModByName(mod or "")
		timeLeft = tonumber(timeLeft or 0)
		totalTime = tonumber(totalTime or 0)
		if mod and timeLeft and timeLeft > 0 and totalTime and totalTime > 0 and id then
			DBM:ReceiveTimerInfo(sender, mod, timeLeft, totalTime, id, paused and paused == "1" and true or false, ...)
		end
	end

	whisperSyncHandlers["VI"] = function(sender, mod, name, value)
		mod = DBM:GetModByName(mod or "")
		value = tonumber(value) or value
		if mod and name and value then
			DBM:ReceiveVariableInfo(sender, mod, name, value)
		end
	end

	handleSync = function(channel, sender, prefix, ...)
		if not prefix then
			return
		end
		local handler
		--Can only be from a friend
		if channel == "BN_WHISPER" then
			handler = whisperSyncHandlers[prefix]
		--Whisper syncs sent from non friends are automatically rejected if not from a friend or someone in your group
		elseif channel == "WHISPER" and sender ~= playerName then -- separate between broadcast and unicast, broadcast must not be sent as unicast or vice-versa
			if (checkForSafeSender(sender, true) or DBM:GetRaidUnitId(sender)) then--Sender passes safety check, or is in group
				handler = whisperSyncHandlers[prefix]
			end
		elseif channel == "GUILD" then
			handler = guildSyncHandlers[prefix]
		else
			handler = syncHandlers[prefix]
		end
		if handler then
			return handler(sender, ...)
		end
	end

	function DBM:CHAT_MSG_ADDON(prefix, msg, channel, sender)
		if prefix == DBMPrefix and msg and (channel == "PARTY" or channel == "RAID" or channel == "INSTANCE_CHAT" or channel == "WHISPER" or channel == "GUILD") then
			sender = Ambiguate(sender, "none")
			handleSync(channel, sender, strsplit("\t", msg))
		elseif prefix == "BigWigs" and msg and (channel == "PARTY" or channel == "RAID" or channel == "INSTANCE_CHAT") then
			local bwPrefix, bwMsg, extra = strsplit("^", msg)
			if bwPrefix and bwMsg then
				if bwPrefix == "V" and extra then--Nil check "extra" to avoid error from older version
					local verString, hash = bwMsg, extra
					local version = tonumber(verString) or 0
					if version == 0 then return end--Just a query
					sender = Ambiguate(sender, "none")
					handleSync(channel, sender, "BV", version, hash)--Prefix changed, so it's not handled by DBMs "V" handler
					if version > fakeBWVersion then--Newer revision found, upgrade!
						fakeBWVersion = version
						fakeBWHash = hash
					end
				elseif bwPrefix == "Q" then--Version request prefix
					self:Unschedule(SendVersion)
					self:Schedule(3, SendVersion)
				elseif bwPrefix == "B" then--Boss Mod Sync
					for i = 1, #inCombat do
						local mod = inCombat[i]
						if mod and mod.OnBWSync then
							mod:OnBWSync(bwMsg, extra, sender)
						end
					end
					for i = 1, #oocBWComms do
						local mod = oocBWComms[i]
						if mod and mod.OnBWSync then
							mod:OnBWSync(bwMsg, extra, sender)
						end
					end
				end
			end
		elseif prefix == "Transcriptor" and msg then
			for i = 1, #inCombat do
				local mod = inCombat[i]
				if mod and mod.OnTranscriptorSync then
					mod:OnTranscriptorSync(msg, sender)
				end
			end
			local transcriptor = _G["Transcriptor"]
			if msg:find("spell:") and (DBM.Options.DebugLevel > 2 or (transcriptor and transcriptor:IsLogging())) then
				local spellId = string.match(msg, "spell:(%d+)") or CL.UNKNOWN
				local spellName = string.match(msg, "h%[(.-)%]|h") or CL.UNKNOWN
				local message = "RAID_BOSS_WHISPER on "..sender.." with spell of "..spellName.." ("..spellId..")"
				self:Debug(message)
			end
		end
	end
	DBM.CHAT_MSG_ADDON_LOGGED = DBM.CHAT_MSG_ADDON

	function DBM:BN_CHAT_MSG_ADDON(prefix, msg, _, sender)
		if prefix == DBMPrefix and msg then
			handleSync("BN_WHISPER", sender, strsplit("\t", msg))
		end
	end
end

----------------------
--  Pull Detection  --
----------------------
do
	local targetList = {}
	local function buildTargetList()
		local uId = (IsInRaid() and "raid") or "party"
		for i = 0, GetNumGroupMembers() do
			local id = (i == 0 and "target") or uId..i.."target"
			local guid = UnitGUID(id)
			if guid and DBM:IsCreatureGUID(guid) then
				targetList[DBM:GetCIDFromGUID(guid)] = id
			end
		end
	end

	local function clearTargetList()
		twipe(targetList)
	end

	local function scanForCombat(mod, mob, delay)
		if not checkEntry(inCombat, mob) then
			buildTargetList()
			if targetList[mob] then
				if mod.noFriendlyEngagement and UnitIsFriend("player", targetList[mob]) then return end
				if delay > 0 and UnitAffectingCombat(targetList[mob]) and not (UnitPlayerOrPetInRaid(targetList[mob]) or UnitPlayerOrPetInParty(targetList[mob])) then
					DBM:StartCombat(mod, delay, "PLAYER_REGEN_DISABLED")
				elseif (delay == 0) then
					DBM:StartCombat(mod, 0, "PLAYER_REGEN_DISABLED_AND_MESSAGE")
				end
			end
			clearTargetList()
		end
	end

	local function checkForPull(mob, combatInfo)
		healthCombatInitialized = false
		--This just can't be avoided, tryig to save cpu by using C_TimerAfter broke this
		--This needs the redundancy and ability to pass args.
		DBM:Schedule(0.5, scanForCombat, combatInfo.mod, mob, 0.5)
		if not isRetail then
			DBM:Schedule(1.25, scanForCombat, combatInfo.mod, mob, 1.25)
		end
		DBM:Schedule(2, scanForCombat, combatInfo.mod, mob, 2)
		C_TimerAfter(2.1, function()
			healthCombatInitialized = true
		end)
	end

	-- TODO: fix the duplicate code that was added for quick & dirty support of zone IDs

	-- detects a boss pull based on combat state, this is required for pre-ICC bosses that do not fire INSTANCE_ENCOUNTER_ENGAGE_UNIT events on engage
	function DBM:PLAYER_REGEN_DISABLED()
		lastCombatStarted = GetTime()
		if not combatInitialized then return end
		if dbmIsEnabled and combatInfo[LastInstanceMapID] then
			for _, v in ipairs(combatInfo[LastInstanceMapID]) do
				if v.type:find("combat") and not v.noRegenDetection then
					if v.multiMobPullDetection then
						for _, mob in ipairs(v.multiMobPullDetection) do
							if checkForPull(mob, v) then
								break
							end
						end
					else
						checkForPull(v.mob, v)
					end
				end
			end
		end
		if self.Options.AFKHealthWarning and not IsEncounterInProgress() and UnitIsAFK("player") and self:AntiSpam(5, "AFK") then--You are afk and losing health, some griever is trying to kill you while you are afk/tabbed out.
			self:FlashClientIcon()
			local voice = DBM.Options.ChosenVoicePack2
			local path = 8585--"Sound\\Creature\\CThun\\CThunYouWillDIe.ogg"
			if not voiceSessionDisabled and voice ~= "None" then
				path = "Interface\\AddOns\\DBM-VP"..voice.."\\checkhp.ogg"
			end
			self:PlaySound(path)
			if UnitHealthMax("player") ~= 0 then
				local health = UnitHealth("player") / UnitHealthMax("player") * 100
				self:AddMsg(L.AFK_WARNING:format(health))
			end
		end
	end

	function DBM:PLAYER_REGEN_ENABLED()
		if delayedFunction then--Will throw error if not a function, purposely not doing and type(delayedFunction) == "function" for now to make sure code works though because it always should be function
			delayedFunction()
			delayedFunction = nil
		end
		if watchFrameRestore then
			if isRetail then
				ObjectiveTracker_Expand()
			else
				QuestWatchFrame:Show()
			end
			watchFrameRestore = false
		end
		local QuestieLoader = _G["QuestieLoader"]
		if QuestieLoader then
			local QuestieTracker = _G["QuestieTracker"] or QuestieLoader:ImportModule("QuestieTracker")--Might be a global in some versions, but not a global in others
			if QuestieTracker and questieWatchRestore and QuestieTracker.Enable then
				QuestieTracker:Enable()
				questieWatchRestore = false
			end
		end
	end

	local function isBossEngaged(cId)
		-- note that this is designed to work with any number of bosses, but it might be sufficient to check the first 5 unit ids
		local i = 1
		repeat
			local bossUnitId = "boss"..i
			local bossGUID = not UnitIsDead(bossUnitId) and UnitGUID(bossUnitId) -- check for UnitIsVisible maybe?
			local bossCId = bossGUID and DBM:GetCIDFromGUID(bossGUID)
			if bossCId and (type(cId) == "number" and cId == bossCId or type(cId) == "table" and checkEntry(cId, bossCId)) then
				return true
			end
			i = i + 1
		until not bossGUID
	end

	function DBM:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
		if timerRequestInProgress then return end--do not start ieeu combat if timer request is progressing. (not to break Timer Recovery stuff)
		if dbmIsEnabled and combatInfo[LastInstanceMapID] then
			self:Debug("INSTANCE_ENCOUNTER_ENGAGE_UNIT event fired for zoneId"..LastInstanceMapID, 3)
			for _, v in ipairs(combatInfo[LastInstanceMapID]) do
				if not v.noIEEUDetection then
					if v.type:find("combat") and isBossEngaged(v.multiMobPullDetection or v.mob) then
						self:StartCombat(v.mod, 0, "IEEU")
					end
				end
			end
		end
	end

	function DBM:ENCOUNTER_START(encounterID, name, difficulty, size)
		self:Debug("ENCOUNTER_START event fired: "..encounterID.." "..name.." "..difficulty.." "..size)
		if dbmIsEnabled then
			if self.Options.ShowReminders then
				self:CheckAvailableMods()
			end
			if combatInfo[LastInstanceMapID] then
				for _, v in ipairs(combatInfo[LastInstanceMapID]) do
					if not v.noESDetection then
						if v.multiEncounterPullDetection then
							for _, eId in ipairs(v.multiEncounterPullDetection) do
								if encounterID == eId then
									self:StartCombat(v.mod, 0, "ENCOUNTER_START")
									return
								end
							end
						elseif encounterID == v.eId then
							self:StartCombat(v.mod, 0, "ENCOUNTER_START")
							return
						end
					end
				end
			end
		end
	end

	function DBM:ENCOUNTER_END(encounterID, name, difficulty, size, success)
		self:Debug("ENCOUNTER_END event fired: "..encounterID.." "..name.." "..difficulty.." "..size.." "..success)
		for i = #inCombat, 1, -1 do
			local v = inCombat[i]
			if not v.combatInfo then return end
			if v.noEEDetection then return end
			if v.respawnTime and success == 0 and self.Options.ShowRespawn and not self.Options.DontShowBossTimers then--No special hacks needed for bad wrath ENCOUNTER_END. Only mods that define respawnTime have a timer, since variable per boss.
				name = string.split(",", name)
				DBT:CreateBar(v.respawnTime, L.TIMER_RESPAWN:format(name), isRetail and 237538 or 136106)--Interface\\Icons\\Spell_Holy_BorrowedTime, Spell_nature_timestop
				fireEvent("DBM_TimerStart", "DBMRespawnTimer", L.TIMER_RESPAWN:format(name), v.respawnTime, isRetail and "237538" or "136106", "extratimer", nil, 0, v.id)
			end
			if v.multiEncounterPullDetection then
				for _, eId in ipairs(v.multiEncounterPullDetection) do
					if encounterID == eId then
						self:EndCombat(v, success == 0)
						sendSync("EE", encounterID.."\t"..success.."\t"..v.id.."\t"..(v.revision or 0))
						return
					end
				end
			elseif encounterID == v.combatInfo.eId then
				self:EndCombat(v, success == 0)
				sendSync("EE", encounterID.."\t"..success.."\t"..v.id.."\t"..(v.revision or 0))
				return
			end
		end
	end

	function DBM:BOSS_KILL(encounterID, name)
		self:Debug("BOSS_KILL event fired: "..encounterID.." "..name)
		for i = #inCombat, 1, -1 do
			local v = inCombat[i]
			if not v.combatInfo then return end
			if v.noBKDetection then return end
			if v.multiEncounterPullDetection then
				for _, eId in ipairs(v.multiEncounterPullDetection) do
					if encounterID == eId then
						self:EndCombat(v)
						sendSync("EE", encounterID.."\t1\t"..v.id.."\t"..(v.revision or 0))
						return
					end
				end
			elseif encounterID == v.combatInfo.eId then
				self:EndCombat(v)
				sendSync("EE", encounterID.."\t1\t"..v.id.."\t"..(v.revision or 0))
				return
			end
		end
	end

	local function checkExpressionList(exp, str)
		for _, v in ipairs(exp) do
			if str:match(v) then
				return true
			end
		end
		return false
	end

	-- called for all mob chat events
	local function onMonsterMessage(self, type, msg)
		-- pull detection
		if dbmIsEnabled and combatInfo[LastInstanceMapID] then
			for _, v in ipairs(combatInfo[LastInstanceMapID]) do
				if v.type == type and checkEntry(v.msgs, msg) or v.type == type .. "_regex" and checkExpressionList(v.msgs, msg) then
					self:StartCombat(v.mod, 0, "MONSTER_MESSAGE")
				elseif v.type == "combat_" .. type .. "find" and tContains(v.msgs, msg) or v.type == "combat_" .. type and checkEntry(v.msgs, msg) then
					if IsInInstance() then--Indoor boss that uses both combat and message for combat, so in other words (such as hodir), don't require "target" of boss for yell like scanForCombat does for World Bosses
						self:StartCombat(v.mod, 0, "MONSTER_MESSAGE")
					else--World Boss
						scanForCombat(v.mod, v.mob, 0)
						if v.mod.readyCheckQuestId and (self.Options.WorldBossNearAlert or v.mod.Options.ReadyCheck) and not IsQuestFlaggedCompleted(v.mod.readyCheckQuestId) and v.mod.readyCheckMaxLevel >= playerLevel then
							self:FlashClientIcon()
							self:PlaySound(8960, true)
						end
					end
				end
			end
		end
		-- kill detection (wipe detection would also be nice to have)
		-- todo: add sync
		for i = #inCombat, 1, -1 do
			local v = inCombat[i]
			if not v.combatInfo then return end
			if v.combatInfo.killType == type and v.combatInfo.killMsgs[msg] then
				self:EndCombat(v)
			end
		end
	end

	function DBM:CHAT_MSG_MONSTER_YELL(msg, npc, _, _, target)
		if IsEncounterInProgress() or (IsInInstance() and InCombatLockdown()) then--Too many 5 mans/old raids don't properly return encounterinprogress
			local targetName = target or "nil"
			self:Debug("CHAT_MSG_MONSTER_YELL from "..npc.." while looking at "..targetName, 2)
		end
		if not isRetail and not IsInInstance() then
			if msg:find(L.WORLD_BUFFS.hordeOny) then
				SendWorldSync(self, "WBA", "Onyxia\tHorde\t22888\t15\t4")
				DBM:Debug("L.WORLD_BUFFS.hordeOny detected")
			elseif msg:find(L.WORLD_BUFFS.allianceOny) then
				SendWorldSync(self, "WBA", "Onyxia\tAlliance\t22888\t15\t4")
				DBM:Debug("L.WORLD_BUFFS.allianceOny detected")
			elseif msg:find(L.WORLD_BUFFS.hordeNef) then
				SendWorldSync(self, "WBA", "Nefarian\tHorde\t22888\t16\t4")
				DBM:Debug("L.WORLD_BUFFS.hordeNef detected")
			elseif msg:find(L.WORLD_BUFFS.allianceNef) then
				SendWorldSync(self, "WBA", "Nefarian\tAlliance\t22888\t16\t4")
				DBM:Debug("L.WORLD_BUFFS.allianceNef detected")
			elseif msg:find(L.WORLD_BUFFS.rendHead) then
				SendWorldSync(self, "WBA", "rendBlackhand\tHorde\t16609\t7\t4")
				DBM:Debug("L.WORLD_BUFFS.rendHead detected")
			elseif msg:find(L.WORLD_BUFFS.zgHeartYojamba) then
				-- zg buff transcripts https://gist.github.com/venuatu/18174f0e98759f83b9834574371b8d20
				-- 28.58, 28.67, 27.77, 29.39, 28.67, 29.03, 28.12, 28.19, 29.61
				SendWorldSync(self, "WBA", "Zandalar\tBoth\t24425\t28\t4")
				DBM:Debug("L.WORLD_BUFFS.zgHeartYojamba detected")
			elseif msg:find(L.WORLD_BUFFS.zgHeartBooty) then
				-- 48.7, 49.76, 50.64, 49.42, 49.8, 50.67, 50.94, 51.06
				SendWorldSync(self, "WBA", "Zandalar\tBoth\t24425\t49\t4")
				DBM:Debug("L.WORLD_BUFFS.zgHeartBooty detected")
			end
		end
		return onMonsterMessage(self, "yell", msg)
	end

	function DBM:CHAT_MSG_MONSTER_EMOTE(msg)
		return onMonsterMessage(self, "emote", msg)
	end

	function DBM:CHAT_MSG_RAID_BOSS_EMOTE(msg, sender, ...)
		onMonsterMessage(self, "emote", msg)
		local id = msg:match("|Hspell:([^|]+)|h")
		if id then
			local spellId = tonumber(id)
			if spellId then
				local spellName = DBM:GetSpellInfo(spellId) or CL.UNKNOWN
				self:Debug("CHAT_MSG_RAID_BOSS_EMOTE fired: "..sender.."'s "..spellName.."("..spellId..")", 2)
			end
		end
		return self:FilterRaidBossEmote(msg, sender, ...)
	end

	function DBM:RAID_BOSS_EMOTE(msg, ...)--This is a mirror of above prototype only it has less args, both still exist for some reason.
		onMonsterMessage(self, "emote", msg)
		return self:FilterRaidBossEmote(msg, ...)
	end

	function DBM:RAID_BOSS_WHISPER(msg)
		--Make it easier for devs to detect whispers they are unable to see
		--TINTERFACE\\ICONS\\ability_socererking_arcanewrath.blp:20|t You have been branded by |cFFF00000|Hspell:156238|h[Arcane Wrath]|h|r!"
		if IsInGroup() and not _G["BigWigs"] then
			SendAddonMessage("Transcriptor", msg, IsInGroup(2) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or "PARTY")--Send any emote to transcriptor, even if no spellid
		end
	end

	function DBM:CHAT_MSG_MONSTER_SAY(msg)
		if not isRetail and not IsInInstance() then
			if msg:find(L.WORLD_BUFFS.zgHeart) then
				-- 51.01 51.82 51.85 51.53
				SendWorldSync(self, "WBA", "Zandalar\tBoth\t24425\t51\t4")
			end
		end
		return onMonsterMessage(self, "say", msg)
	end
end

---------------------------
--  Kill/Wipe Detection  --
---------------------------

function checkWipe(self, confirm)
	if #inCombat > 0 then
		if not savedDifficulty or not difficultyText or not difficultyIndex then--prevent error if savedDifficulty or difficultyText is nil
			savedDifficulty, difficultyText, difficultyIndex, LastGroupSize, difficultyModifier = self:GetCurrentInstanceDifficulty()
		end
		--hack for no iEEU information is provided.
		if not bossuIdFound then
			for i = 1, 5 do
				if UnitExists("boss"..i) then
					bossuIdFound = true
					break
				end
			end
		end
		local wipe -- 0: no wipe, 1: normal wipe, 2: wipe by UnitExists check.
		if (isRetail and IsInScenarioGroup()) or (difficultyIndex == 11) or (difficultyIndex == 12) then -- Scenario mod uses special combat start and must be enabled before sceniro end. So do not wipe.
			wipe = 0
		elseif IsEncounterInProgress() then -- Encounter Progress marked, you obviously in combat with boss. So do not Wipe
			wipe = 0
		elseif savedDifficulty == "worldboss" and UnitIsDeadOrGhost("player") then -- On dead or ghost, unit combat status detection would be fail. If you ghost in instance, that means wipe. But in worldboss, ghost means not wipe. So do not wipe.
			wipe = 0
		elseif bossuIdFound and LastInstanceType == "raid" then -- Combat started by IEEU and no boss exist and no EncounterProgress marked, that means wipe
			wipe = 2
			for i = 1, 5 do
				if UnitExists("boss"..i) then
					wipe = 0 -- Boss found. No wipe
					break
				end
			end
		else -- Unit combat status detection. No combat unit in your party and no EncounterProgress marked, that means wipe
			wipe = 1
			local uId = (IsInRaid() and "raid") or "party"
			for i = 0, GetNumGroupMembers() do
				local id = (i == 0 and "player") or uId..i
				if UnitAffectingCombat(id) and not UnitIsDeadOrGhost(id) then
					wipe = 0 -- Someone still in combat. No wipe
					break
				end
			end
		end
		if wipe == 0 then
			self:Schedule(3, checkWipe, self)
		elseif confirm then
			for i = #inCombat, 1, -1 do
				local mod = inCombat[i]
				if not mod.noStatistics then
					self:Debug("You wiped. Reason : " .. (wipe == 1 and "No combat unit found in your party." or "No boss found : "..(wipe or "nil")))
				end
				self:EndCombat(mod, true)
			end
		else
			local maxDelayTime = (savedDifficulty == "worldboss" and 15) or 5 --wait 10s more on worldboss do actual wipe.
			for _, v in ipairs(inCombat) do
				maxDelayTime = v.combatInfo and v.combatInfo.wipeTimer and v.combatInfo.wipeTimer > maxDelayTime and v.combatInfo.wipeTimer or maxDelayTime
			end
			self:Schedule(maxDelayTime, checkWipe, self, true)
		end
	end
end

function checkBossHealth(self, onlyHighest)
	if #inCombat > 0 then
		for _, v in ipairs(inCombat) do
			if not v.multiMobPullDetection or v.mainBoss then
				self:GetBossHP(v.mainBoss or v.combatInfo.mob or -1, onlyHighest)
			else
				for _, mob in ipairs(v.multiMobPullDetection) do
					self:GetBossHP(mob, onlyHighest)
				end
			end
		end
		self:Schedule(1, checkBossHealth, self, onlyHighest)
	end
end

function checkCustomBossHealth(self, mod)
	mod:CustomHealthUpdate()
	self:Schedule(1, checkCustomBossHealth, self, mod)
end

do
	local tooltipsHidden = false
	--Delayed Guild Combat sync object so we allow time for RL to disable them
	local function delayedGCSync(modId, difficultyIndex, difficultyModifier, name, thisTime, wipeHP)
		if not statusGuildDisabled and updateNotificationDisplayed == 0 then
			if thisTime then--Wipe event
				SendAddonMessage(DBMPrefix, "GCE\t"..modId.."\t6\t1\t"..thisTime.."\t"..difficultyIndex.."\t"..difficultyModifier.."\t"..name.."\t"..wipeHP, "GUILD")
			else
				SendAddonMessage(DBMPrefix, "GCB\t"..modId.."\t3\t"..difficultyIndex.."\t"..difficultyModifier.."\t"..name, "GUILD")
			end
		end
	end

	local statVarTable = {
		--Current
		["event5"] = "normal",
		["event20"] = "lfr25",
		["event40"] = "lfr25",
		["normal5"] = "normal",
		["heroic5"] = "heroic",
		["challenge5"] = "challenge",
		["lfr"] = "lfr25",
		["normal"] = "normal",
		["heroic"] = "heroic",
		["mythic"] = "mythic",
		["worldboss"] = "normal",
		["timewalker"] = "timewalker",
		["progressivechallenges"] = "normal",
		--BFA
		["normalwarfront"] = "normal",
		["heroicwarfront"] = "heroic",
		["normalisland"] = "normal",
		["heroicisland"] = "heroic",
		["mythicisland"] = "mythic",
		["teamingisland"] = "mythic",--Blizz uses mythic as fallback, so I will too
		--Legacy
		["lfr25"] = "lfr25",
		["normal10"] = "normal",
		["normal20"] = "normal",
		["normal25"] = "normal25",--Legacy raids that have two normal difficulties still (10/25)
		["normal40"] = "normal",
		["heroic10"] = "heroic",
		["heroic25"] = "heroic25",--Legacy raids that have two heroic difficulties still (10/25)
		["normalscenario"] = "normal",
		["heroicscenario"] = "heroic",
	}

	function DBM:StartCombat(mod, delay, event, synced, syncedStartHp, syncedEvent)
		cSyncSender = {}
		cSyncReceived = 0
		if not checkEntry(inCombat, mod) then
			if not mod.Options.Enabled then return end
			if not mod.combatInfo then return end
			if mod.combatInfo.noCombatInVehicle and UnitInVehicle("player") then -- HACK
				return
			end
			--HACK: makes sure that we don't detect a false pull if the event fires again when the boss dies...
			if mod.lastKillTime and GetTime() - mod.lastKillTime < (mod.reCombatTime or 120) and event ~= "LOADING_SCREEN_DISABLED" then return end
			if mod.lastWipeTime and GetTime() - mod.lastWipeTime < (event == "ENCOUNTER_START" and 3 or mod.reCombatTime2 or 20) and event ~= "LOADING_SCREEN_DISABLED" then return end
			if event then
				self:Debug("StartCombat called by : "..event..". LastInstanceMapID is "..LastInstanceMapID)
				if event ~= "ENCOUNTER_START" then
					self:Debug("This event is started by"..event..". Review ENCOUNTER_START event to ensure if this is still needed", 2)
				end
			else
				self:Debug("StartCombat called by individual mod or unknown reason. LastInstanceMapID is "..LastInstanceMapID)
				event = ""
			end
			--check completed. starting combat
			tinsert(inCombat, mod)
			if mod.inCombatOnlyEvents and not mod.inCombatOnlyEventsRegistered then
				mod.inCombatOnlyEventsRegistered = 1
				mod:RegisterEvents(unpack(mod.inCombatOnlyEvents))
			end
			--Fix for "attempt to perform arithmetic on field 'stats' (a nil value)"
			if not mod.stats and not mod.noStatistics then
				self:AddMsg(L.BAD_LOAD)--Warn user that they should reload ui soon as they leave combat to get their mod to load correctly as soon as possible
				mod.ignoreBestkill = true--Force this to true so we don't check any more occurances of "stats"
			elseif event == "TIMER_RECOVERY" then --add a lag time to delay when TIMER_RECOVERY
				delay = delay + select(4, GetNetStats()) / 1000
			end
			--set mod default info
			savedDifficulty, difficultyText, difficultyIndex, LastGroupSize, difficultyModifier = self:GetCurrentInstanceDifficulty()
			local name = mod.combatInfo.name
			local modId = mod.id
			if isRetail and mod.addon.type == "SCENARIO" and C_Scenario.IsInScenario() and not mod.soloChallenge then
				mod.inScenario = true
			end
			mod.engagedDiff = savedDifficulty
			mod.engagedDiffText = difficultyText
			mod.engagedDiffIndex = difficultyIndex
			mod.inCombat = true
			mod.blockSyncs = nil
			mod.combatInfo.pull = GetTime() - (delay or 0)
			bossuIdFound = event == "IEEU"
			if mod.minCombatTime then
				self:Schedule(mmax((mod.minCombatTime - delay), 3), checkWipe, self)
			else
				self:Schedule(3, checkWipe, self)
			end
			--get boss hp at pull
			if syncedStartHp and syncedStartHp < 1 then
				syncedStartHp = syncedStartHp * 100
			end
			local startHp = syncedStartHp or mod:GetBossHP(mod.mainBoss or mod.combatInfo.mob or -1) or 100
			--check boss engaged first?
			if (savedDifficulty == "worldboss" and startHp < 98) or (event == "UNIT_HEALTH" and delay > 4) or event == "TIMER_RECOVERY" then--Boss was not full health when engaged, disable combat start timer and kill record
				mod.ignoreBestkill = true
			elseif mod.inScenario then
				local _, currentStage, numStages = C_Scenario.GetInfo()
				if currentStage > 1 and numStages > 1 then
					mod.ignoreBestkill = true
				end
			else--Reset ignoreBestkill after wipe
				mod.ignoreBestkill = false
				--It was a clean pull, so cancel any RequestTimers which might fire after boss was pulled if boss was pulled right after mod load
				--Only want timer recovery on in progress bosses, not clean pulls
				if startHp > 98 and (savedDifficulty == "worldboss" or event == "IEEU") or event == "ENCOUNTER_START" then
					self:Unschedule(self.RequestTimers)
				end
			end
			if not mod.inScenario then
				if self.Options.HideTooltips then
					--Better or cleaner way?
					tooltipsHidden = true
					GameTooltip.Temphide = function() GameTooltip:Hide() end; GameTooltip:SetScript("OnShow", GameTooltip.Temphide)
				end
				if self.Options.DisableSFX and GetCVar("Sound_EnableSFX") == "1" then
					SetCVar("Sound_EnableSFX", 0)
					self.Options.RestoreSettingSFX = true
				end
				--boss health info scheduler
				if mod.CustomHealthUpdate then
					self:Schedule(1, checkCustomBossHealth, self, mod)
				else
					self:Schedule(1, checkBossHealth, self, mod.onlyHighest)
				end
			end
			--process global options
			self:HideBlizzardEvents(1)
			if self.Options.RecordOnlyBosses then
				self:StartLogging(0, nil)
			end
			if self.Options.HideObjectivesFrame and mod.addon.type ~= "SCENARIO" and (not isRetail or GetNumTrackedAchievements() == 0) and difficultyIndex ~= 8 and not InCombatLockdown() then
				if isRetail then
					if ObjectiveTrackerFrame:IsVisible() then
						ObjectiveTracker_Collapse()
						watchFrameRestore = true
					end
				else
					if QuestWatchFrame:IsVisible() then
						QuestWatchFrame:Hide()
						watchFrameRestore = true
					end
					local QuestieLoader = _G["QuestieLoader"]
					if QuestieLoader then
						local QuestieTracker = _G["QuestieTracker"] or QuestieLoader:ImportModule("QuestieTracker")--Might be a global in some versions, but not a global in others
						local Questie = _G["Questie"] or QuestieLoader:ImportModule("Questie")
						if QuestieTracker and Questie and Questie.db.global.trackerEnabled and QuestieTracker.Disable then
							--Will only hide questie tracker if it's not already hidden.
							QuestieTracker:Disable()
							questieWatchRestore = true
						end
					end
				end
			end
			fireEvent("DBM_Pull", mod, delay, synced, startHp)
			self:FlashClientIcon()
			--serperate timer recovery and normal start.
			if event ~= "TIMER_RECOVERY" then
				--add pull count
				if mod.stats and not mod.noStatistics then
					if not mod.stats[statVarTable[savedDifficulty].."Pulls"] then mod.stats[statVarTable[savedDifficulty].."Pulls"] = 0 end
					mod.stats[statVarTable[savedDifficulty].."Pulls"] = mod.stats[statVarTable[savedDifficulty].."Pulls"] + 1
				end
				--show speed timer
				if self.Options.AlwaysShowSpeedKillTimer2 and mod.stats and not mod.ignoreBestkill and not mod.noStatistics then
					local bestTime
					if difficultyIndex == 8 then--Mythic+/Challenge Mode
						local bestMPRank = mod.stats.challengeBestRank or 0
						if bestMPRank == difficultyModifier then
							--Don't show speed kill timer if not our highest rank. DBM only stores highest rank
							bestTime = mod.stats[statVarTable[savedDifficulty].."BestTime"]
						end
					else
						bestTime = mod.stats[statVarTable[savedDifficulty].."BestTime"]
					end
					if bestTime and bestTime > 0 then
						local speedTimer = mod:NewTimer(bestTime, L.SPEED_KILL_TIMER_TEXT, isRetail and "237538" or "136106", nil, false)
						speedTimer:Start()
					end
				end
				--update boss left
				if mod.numBoss then
					mod.vb.bossLeft = mod.numBoss
				end
				--elect icon person
				if mod.findFastestComputer and not self.Options.DontSetIcons then
					if self:GetRaidRank() > 0 then
						for i = 1, #mod.findFastestComputer do
							local option = mod.findFastestComputer[i]
							if mod.Options[option] then
								sendSync("IS", UnitGUID("player").."\t"..tostring(self.Revision).."\t"..option)
							end
						end
					elseif not IsInGroup() then
						for i = 1, #mod.findFastestComputer do
							local option = mod.findFastestComputer[i]
							if mod.Options[option] then
								private.canSetIcons[option] = true
							end
						end
					end
				end
				--call OnCombatStart
				if mod.OnCombatStart then
					local startEvent = syncedEvent or event
					mod:OnCombatStart(delay or 0, startEvent == "PLAYER_REGEN_DISABLED_AND_MESSAGE" or startEvent == "SPELL_CAST_SUCCESS" or startEvent == "MONSTER_MESSAGE", startEvent == "ENCOUNTER_START")
				end
				--send "C" sync
				if not synced then
					sendSync("C", (delay or 0).."\t"..modId.."\t"..(mod.revision or 0).."\t"..startHp.."\t"..tostring(self.Revision).."\t"..(mod.hotfixNoticeRev or 0).."\t"..event)
				end
				if UnitIsGroupLeader("player") then
					if self.Options.DisableGuildStatus then
						sendSync("DGP")
					end
					if self.Options.DisableStatusWhisper and (difficultyIndex == 8 or difficultyIndex == 14 or difficultyIndex == 15 or difficultyIndex == 16) then
						sendSync("DSW")
					end
				end
				if self.Options.oRA3AnnounceConsumables and _G["oRA3Frame"] then
					local oRA3 = LibStub("AceAddon-3.0"):GetAddon("oRA3", true)
					if oRA3 then
						local consumables = oRA3:GetModule("Consumables", true)
						if consumables then
							consumables:OutputResults()
						end
					end
				end
				--show engage message
				if self.Options.ShowEngageMessage and not mod.noStatistics then
					if mod.ignoreBestkill and (savedDifficulty == "worldboss") then--Should only be true on in progress field bosses, not in progress raid bosses we did timer recovery on.
						self:AddMsg(L.COMBAT_STARTED_IN_PROGRESS:format(difficultyText..name))
					elseif mod.ignoreBestkill and mod.inScenario then
						self:AddMsg(L.SCENARIO_STARTED_IN_PROGRESS:format(difficultyText..name))
					else
						if mod.addon.type == "SCENARIO" then
							self:AddMsg(L.SCENARIO_STARTED:format(difficultyText..name))
						else
							self:AddMsg(L.COMBAT_STARTED:format(difficultyText..name))
							local check = not statusGuildDisabled and (isRetail and ((difficultyIndex == 8 or difficultyIndex == 14 or difficultyIndex == 15 or difficultyIndex == 16) and InGuildParty()) or difficultyIndex ~= 1 and DBM:GetNumGuildPlayersInZone() >= 10) -- Classic
							if check and not self.Options.DisableGuildStatus then--Only send relevant content, not guild beating down lich king or LFR.
								self:Schedule(1.5, delayedGCSync, modId, difficultyIndex, difficultyModifier, name)
							end
						end
					end
				end
				--stop pull count
				local dummyMod = self:GetModByName("PullTimerCountdownDummy")
				if dummyMod then--stop pull timer
					dummyMod.text:Cancel()
					dummyMod.timer:Stop()
					if not self.Options.DontShowPTCountdownText and TimerTracker then
						for _, tttimer in pairs(TimerTracker.timerList) do
							if tttimer.type == 3 and not tttimer.isFree then
								FreeTimerTrackerTimer(tttimer)
								break
							end
						end
					end
				end
				local bigWigs = _G["BigWigs"]
				if bigWigs and bigWigs.db.profile.raidicon and not self.Options.DontSetIcons and self:GetRaidRank() > 0 then--Both DBM and bigwigs have raid icon marking turned on.
					self:AddMsg(L.BIGWIGS_ICON_CONFLICT)--Warn that one of them should be turned off to prevent conflict (which they turn off is obviously up to raid leaders preference, dbm accepts either or turned off to stop this alert)
				end
				if self.Options.EventSoundEngage2 and self.Options.EventSoundEngage2 ~= "" and self.Options.EventSoundEngage2 ~= "None" then
					self:PlaySoundFile(self.Options.EventSoundEngage2, nil, true)
				end
				if self.Options.EventSoundMusic and self.Options.EventSoundMusic ~= "None" and self.Options.EventSoundMusic ~= "" and not (self.Options.EventMusicMythicFilter and (savedDifficulty == "mythic" or savedDifficulty == "challenge")) and not mod.noStatistics then
					fireEvent("DBM_MusicStart", "BossEncounter")
					if not self.Options.RestoreSettingMusic then
						self.Options.RestoreSettingMusic = tonumber(GetCVar("Sound_EnableMusic")) or 1
						if self.Options.RestoreSettingMusic == 0 then
							SetCVar("Sound_EnableMusic", 1)
						else
							self.Options.RestoreSettingMusic = nil--Don't actually need it
						end
					end
					local path = "MISSING"
					if self.Options.EventSoundMusic == "Random" then
						local usedTable = self.Options.EventSoundMusicCombined and self.Music or mod.inScenario and self.DungeonMusic or self.BattleMusic
						if #usedTable >= 3 then
							local random = fastrandom(3, #usedTable)
							path = usedTable[random].value
						end
					else
						path = self.Options.EventSoundMusic
					end
					if path ~= "MISSING" then
						PlayMusic(path)
						self.Options.musicPlaying = true
						self:Debug("Starting combat music with file: "..path)
					end
				end
			else
				self:AddMsg(L.COMBAT_STATE_RECOVERED:format(difficultyText..name, strFromTime(delay)))
				if mod.OnTimerRecovery then
					mod:OnTimerRecovery()
				end
			end
			if savedDifficulty == "worldboss" and mod.WBEsync then
				if lastBossEngage[modId..playerRealm] and (GetTime() - lastBossEngage[modId..playerRealm] < 30) then return end--Someone else synced in last 10 seconds so don't send out another sync to avoid needless sync spam.
				lastBossEngage[modId..playerRealm] = GetTime()--Update last engage time, that way we ignore our own sync
				SendWorldSync(self, "WBE", modId.."\t"..playerRealm.."\t"..startHp.."\t8\t"..name)
			end
		end
	end

	function DBM:UNIT_HEALTH(uId)
		local cId = self:GetCIDFromGUID(UnitGUID(uId))
		local health
		if UnitHealthMax(uId) ~= 0 then
			health = UnitHealth(uId) / UnitHealthMax(uId) * 100
		end
		if not health or health < 2 then return end -- no worthy of combat start if health is below 2%
		if dbmIsEnabled and InCombatLockdown() then
			if cId ~= 0 and not bossHealth[cId] and bossIds[cId] and UnitAffectingCombat(uId) and not (UnitPlayerOrPetInRaid(uId) or UnitPlayerOrPetInParty(uId)) and healthCombatInitialized then -- StartCombat by UNIT_HEALTH.
				if combatInfo[LastInstanceMapID] then
					for _, v in ipairs(combatInfo[LastInstanceMapID]) do
						if v.mod.Options.Enabled and not v.mod.disableHealthCombat and v.type:find("combat") and (v.multiMobPullDetection and checkEntry(v.multiMobPullDetection, cId) or v.mob == cId) then
							if v.mod.noFriendlyEngagement and UnitIsFriend("player", uId) then return end
							-- Delay set, > 97% = 0.5 (consider as normal pulling), max dealy limited to 20s.
							self:StartCombat(v.mod, health > 97 and 0.5 or mmin(GetTime() - lastCombatStarted, 20), "UNIT_HEALTH", nil, health)
						end
					end
				end
			end
			if self.Options.AFKHealthWarning and UnitIsUnit(uId, "player") and (health < 85) and not IsEncounterInProgress() and UnitIsAFK("player") and self:AntiSpam(5, "AFK") then--You are afk and losing health, some griever is trying to kill you while you are afk/tabbed out.
				self:PlaySound(8585)--So fire an alert sound to save yourself from this person's behavior.
				self:AddMsg(L.AFK_WARNING:format(health))
			end
		end
	end

	function DBM:EndCombat(mod, wipe, srmIncluded)
		if removeEntry(inCombat, mod) then
			local scenario = mod.addon.type == "SCENARIO" and not mod.soloChallenge
			if mod.inCombatOnlyEvents and mod.inCombatOnlyEventsRegistered then
				if srmIncluded then-- unregister all events including SPELL_AURA_REMOVED events
					mod:UnregisterInCombatEvents(false, true)
				else-- unregister all events except for SPELL_AURA_REMOVED events (might still be needed to remove icons etc...)
					mod:UnregisterInCombatEvents()
					self:Schedule(2, mod.UnregisterInCombatEvents, mod, true) -- 2 seconds should be enough for all auras to fade
				end
				self:Schedule(3, mod.Stop, mod) -- Remove accident started timers.
				mod.inCombatOnlyEventsRegistered = nil
				if mod.OnCombatEnd then
					self:Schedule(3, mod.OnCombatEnd, mod, wipe, true) -- Remove accidentally shown frames
				end
			end
			if mod.updateInterval then
				mod:UnregisterOnUpdateHandler()
			end
			mod:Stop()
			if private.enableIcons and not self.Options.DontSetIcons and not self.Options.DontRestoreIcons then
				-- restore saved previous icon
				for uId, icon in pairs(mod.iconRestore) do
					SetRaidTarget(uId, icon)
				end
				twipe(mod.iconRestore)
			end
			mod.inCombat = false
			mod.blockSyncs = true
			if mod.combatInfo.killMobs then
				for i, _ in pairs(mod.combatInfo.killMobs) do
					mod.combatInfo.killMobs[i] = true
				end
			end
			if not savedDifficulty or not difficultyText or not difficultyIndex then--prevent error if savedDifficulty or difficultyText is nil
				savedDifficulty, difficultyText, difficultyIndex, LastGroupSize, difficultyModifier = DBM:GetCurrentInstanceDifficulty()
			end
			--Fix stupid classic behavior where wipes only happen after release which causes all the instance difficulty info to be wrong
			--This uses stored values from engage first, and only current values as fallback
			local usedDifficulty = mod.engagedDiff or savedDifficulty
			local usedDifficultyText = mod.engagedDiffText or difficultyText
			local usedDifficultyIndex = mod.engagedDiffIndex or difficultyIndex
			local name = mod.combatInfo.name
			local modId = mod.id
			if wipe and mod.stats and not mod.noStatistics then
				mod.lastWipeTime = GetTime()
				--Fix for "attempt to perform arithmetic on field 'pull' (a nil value)" (which was actually caused by stats being nil, so we never did getTime on pull, fixing one SHOULD fix the other)
				local thisTime = GetTime() - mod.combatInfo.pull
				local hp = mod.highesthealth and mod:GetHighestBossHealth() or mod:GetLowestBossHealth()
				local wipeHP = mod.CustomHealthUpdate and mod:CustomHealthUpdate() or hp and ("%d%%"):format(hp) or CL.UNKNOWN
				if mod.vb.phase then
					wipeHP = wipeHP.." ("..SCENARIO_STAGE:format(mod.vb.phase)..")"
				end
				if mod.numBoss and mod.vb.bossLeft and mod.numBoss > 1 then
					local bossesKilled = mod.numBoss - mod.vb.bossLeft
					wipeHP = wipeHP.." ("..BOSSES_KILLED:format(bossesKilled, mod.numBoss)..")"
				end
				local totalPulls = mod.stats[statVarTable[usedDifficulty].."Pulls"]
				local totalKills = mod.stats[statVarTable[usedDifficulty].."Kills"]
				if thisTime < 30 then -- Normally, one attempt will last at least 30 sec.
					totalPulls = totalPulls - 1
					mod.stats[statVarTable[usedDifficulty].."Pulls"] = totalPulls
					if self.Options.ShowDefeatMessage then
						if scenario then
							self:AddMsg(L.SCENARIO_ENDED_AT:format(usedDifficultyText..name, strFromTime(thisTime)))
						else
							self:AddMsg(L.COMBAT_ENDED_AT:format(usedDifficultyText..name, wipeHP, strFromTime(thisTime)))
							--No reason to GCE it here, so omited on purpose.
						end
					end
				else
					if self.Options.ShowDefeatMessage then
						if scenario then
							self:AddMsg(L.SCENARIO_ENDED_AT_LONG:format(usedDifficultyText..name, strFromTime(thisTime), totalPulls - totalKills))
						else
							self:AddMsg(L.COMBAT_ENDED_AT_LONG:format(usedDifficultyText..name, wipeHP, strFromTime(thisTime), totalPulls - totalKills))
							local check = isRetail and
								((usedDifficultyIndex == 8 or usedDifficultyIndex == 14 or usedDifficultyIndex == 15 or usedDifficultyIndex == 16) and InGuildParty()) or
								usedDifficultyIndex ~= 1 and DBM:GetNumGuildPlayersInZone() >= 10 -- Classic
							if check and not self.Options.DisableGuildStatus then
								self:Schedule(1.5, delayedGCSync, modId, usedDifficultyIndex, difficultyModifier, name, strFromTime(thisTime), wipeHP)
							end
						end
					end
					if self.Options.EventSoundWipe and self.Options.EventSoundWipe ~= "None" and self.Options.EventSoundWipe ~= "" then
						if self.Options.EventSoundWipe == "Random" then
							local defeatSounds = DBM:GetDefeatSounds()
							if #defeatSounds >= 3 then
								self:PlaySoundFile(defeatSounds[fastrandom(3, #defeatSounds)].value)
							end
						else
							self:PlaySoundFile(self.Options.EventSoundWipe, nil, true)
						end
					end
				end
				if showConstantReminder == 2 and IsInGroup() then
					showConstantReminder = 1
					--Show message any time this is a mod that has a newer hotfix revision and it's a wipe
					--These people need to know the wipe could very well be their fault.
					--self:AddMsg(L.OUT_OF_DATE_NAG)
				end
				local msg
				for k, _ in pairs(autoRespondSpam) do
					if self.Options.WhisperStats then
						if scenario then
							msg = msg or chatPrefixShort..L.WHISPER_SCENARIO_END_WIPE_STATS:format(playerName, usedDifficultyText..(name or ""), totalPulls - totalKills)
						else
							msg = msg or chatPrefixShort..L.WHISPER_COMBAT_END_WIPE_STATS_AT:format(playerName, usedDifficultyText..(name or ""), wipeHP, totalPulls - totalKills)
						end
					else
						if scenario then
							msg = msg or chatPrefixShort..L.WHISPER_SCENARIO_END_WIPE:format(playerName, usedDifficultyText..(name or ""))
						else
							msg = msg or chatPrefixShort..L.WHISPER_COMBAT_END_WIPE_AT:format(playerName, usedDifficultyText..(name or ""), wipeHP)
						end
					end
					sendWhisper(k, msg)
				end
				fireEvent("DBM_Wipe", mod)
			elseif not wipe and mod.stats and not mod.noStatistics then
				mod.lastKillTime = GetTime()
				local thisTime = GetTime() - (mod.combatInfo.pull or 0)
				local lastTime = mod.stats[statVarTable[usedDifficulty].."LastTime"]
				local bestTime = mod.stats[statVarTable[usedDifficulty].."BestTime"]
				if not mod.stats[statVarTable[usedDifficulty].."Kills"] or mod.stats[statVarTable[usedDifficulty].."Kills"] < 0 then mod.stats[statVarTable[usedDifficulty].."Kills"] = 0 end
				--Fix logical error i've seen where for some reason we have more kills then pulls for boss as seen by - stats for wipe messages.
				mod.stats[statVarTable[usedDifficulty].."Kills"] = mod.stats[statVarTable[usedDifficulty].."Kills"] + 1
				if mod.stats[statVarTable[usedDifficulty].."Kills"] > mod.stats[statVarTable[usedDifficulty].."Pulls"] then mod.stats[statVarTable[usedDifficulty].."Kills"] = mod.stats[statVarTable[usedDifficulty].."Pulls"] end
				if not mod.ignoreBestkill and mod.combatInfo.pull then
					mod.stats[statVarTable[usedDifficulty].."LastTime"] = thisTime
					--Just to prevent pre mature end combat calls from broken mods from saving bad time stats.
					if bestTime and bestTime > 0 and bestTime < 1.5 then
						mod.stats[statVarTable[usedDifficulty].."BestTime"] = thisTime
					else
						if usedDifficultyIndex == 8 then--Mythic+/Challenge Mode
							if mod.stats.challengeBestRank > difficultyModifier then--Don't save time stats at all
								--DO nothing
							elseif mod.stats.challengeBestRank < difficultyModifier then--Update best time and best rank, even if best time is lower (for a lower rank)
								mod.stats.challengeBestRank = difficultyModifier--Update best rank
								mod.stats[statVarTable[usedDifficulty].."BestTime"] = thisTime--Write this time no matter what.
							else--Best rank must match current rank, so update time normally
								mod.stats[statVarTable[usedDifficulty].."BestTime"] = mmin(bestTime or mhuge, thisTime)
							end
						else
							mod.stats[statVarTable[usedDifficulty].."BestTime"] = mmin(bestTime or mhuge, thisTime)
						end
					end
				end
				local totalKills = mod.stats[statVarTable[usedDifficulty].."Kills"]
				if self.Options.ShowDefeatMessage then
					local msg
					local thisTimeString = thisTime and strFromTime(thisTime)
					if not mod.combatInfo.pull then--was a bad pull so we ignored thisTime, should never happen
						if scenario then
							msg = L.SCENARIO_COMPLETE:format(usedDifficultyText..name, CL.UNKNOWN)
						else
							msg = L.BOSS_DOWN:format(usedDifficultyText..name, CL.UNKNOWN)
						end
					elseif mod.ignoreBestkill then--Should never happen in a scenario so no need for scenario check.
						if scenario then
							msg = L.SCENARIO_COMPLETE_I:format(usedDifficultyText..name, totalKills)
						else
							msg = L.BOSS_DOWN_I:format(usedDifficultyText..name, totalKills)
						end
					elseif not lastTime then
						if scenario then
							msg = L.SCENARIO_COMPLETE:format(usedDifficultyText..name, thisTimeString)
						else
							msg = L.BOSS_DOWN:format(usedDifficultyText..name, thisTimeString)
						end
					elseif thisTime < (bestTime or mhuge) then
						if scenario then
							msg = L.SCENARIO_COMPLETE_NR:format(usedDifficultyText..name, thisTimeString, strFromTime(bestTime), totalKills)
						else
							msg = L.BOSS_DOWN_NR:format(usedDifficultyText..name, thisTimeString, strFromTime(bestTime), totalKills)
						end
					else
						if scenario then
							msg = L.SCENARIO_COMPLETE_L:format(usedDifficultyText..name, thisTimeString, strFromTime(lastTime), strFromTime(bestTime), totalKills)
						else
							msg = L.BOSS_DOWN_L:format(usedDifficultyText..name, thisTimeString, strFromTime(lastTime), strFromTime(bestTime), totalKills)
						end
					end
					local check = not statusGuildDisabled and (isRetail and ((usedDifficultyIndex == 8 or usedDifficultyIndex == 14 or usedDifficultyIndex == 15 or usedDifficultyIndex == 16) and InGuildParty()) or usedDifficultyIndex ~= 1 and DBM:GetNumGuildPlayersInZone() >= 10) -- Classic
					if not scenario and thisTimeString and check and not self.Options.DisableGuildStatus and updateNotificationDisplayed == 0 then
						SendAddonMessage(DBMPrefix, "GCE\t"..modId.."\t6\t0\t"..thisTimeString.."\t"..usedDifficultyIndex.."\t"..difficultyModifier.."\t"..name, "GUILD")
					end
					self:Schedule(1, self.AddMsg, self, msg)
				end
				local msg
				for k, _ in pairs(autoRespondSpam) do
					if self.Options.WhisperStats then
						if scenario then
							msg = msg or chatPrefixShort..L.WHISPER_SCENARIO_END_KILL_STATS:format(playerName, usedDifficultyText..(name or ""), totalKills)
						else
							msg = msg or chatPrefixShort..L.WHISPER_COMBAT_END_KILL_STATS:format(playerName, usedDifficultyText..(name or ""), totalKills)
						end
					else
						if scenario then
							msg = msg or chatPrefixShort..L.WHISPER_SCENARIO_END_KILL:format(playerName, usedDifficultyText..(name or ""))
						else
							msg = msg or chatPrefixShort..L.WHISPER_COMBAT_END_KILL:format(playerName, usedDifficultyText..(name or ""))
						end
					end
					sendWhisper(k, msg)
				end
				fireEvent("DBM_Kill", mod)
				if usedDifficulty == "worldboss" and mod.WBEsync then
					if lastBossDefeat[modId..playerRealm] and (GetTime() - lastBossDefeat[modId..playerRealm] < 30) then return end--Someone else synced in last 10 seconds so don't send out another sync to avoid needless sync spam.
					lastBossDefeat[modId..playerRealm] = GetTime()--Update last defeat time before we send it, so we don't handle our own sync
					SendWorldSync(self, "WBD", modId.."\t"..playerRealm.."\t8\t"..name)
				end
				if self.Options.EventSoundVictory2 and self.Options.EventSoundVictory2 ~= "None" and self.Options.EventSoundVictory2 ~= "" then
					if self.Options.EventSoundVictory2 == "Random" then
						local victorySounds = DBM:GetVictorySounds()
						if #victorySounds >= 3 then
							self:PlaySoundFile(victorySounds[fastrandom(3, #victorySounds)].value)
						end
					else
						self:PlaySoundFile(self.Options.EventSoundVictory2, nil, true)
					end
				end
			end
			if mod.OnCombatEnd then mod:OnCombatEnd(wipe) end
			if mod.OnLeavingCombat then delayedFunction = mod.OnLeavingCombat end
			mod.engagedDiff = nil
			mod.engagedDiffText = nil
			mod.engagedDiffIndex = nil
			mod.vb.stageTotality = nil
			if #inCombat == 0 then--prevent error if you pulled multiple boss. (Earth, Wind and Fire)
				statusWhisperDisabled = false
				statusGuildDisabled = false
				if self.Options.RecordOnlyBosses then
					self:Schedule(10, self.StopLogging, self)--small delay to catch kill/died combatlog events
				end
				self:HideBlizzardEvents(0)
				self:Unschedule(checkBossHealth)
				self:Unschedule(checkCustomBossHealth)
				self.Arrow:Hide(true)
				if not InCombatLockdown() then
					if watchFrameRestore then
						if isRetail then
							ObjectiveTracker_Expand()
						else
							QuestWatchFrame:Show()
						end
						watchFrameRestore = false
					end
					local QuestieLoader = _G["QuestieLoader"]
					if QuestieLoader then
						local QuestieTracker = _G["QuestieTracker"] or QuestieLoader:ImportModule("QuestieTracker")--Might be a global in some versions, but not a global in others
						if QuestieTracker and questieWatchRestore and QuestieTracker.Enable then
							QuestieTracker:Enable()
							questieWatchRestore = false
						end
					end
				end
				if tooltipsHidden then
					--Better or cleaner way?
					tooltipsHidden = false
					GameTooltip:SetScript("OnShow", GameTooltip.Show)
				end
				if self.Options.RestoreSettingSFX then
					SetCVar("Sound_EnableSFX", 1)
					self.Options.RestoreSettingSFX = nil
				end
				--cache table
				twipe(autoRespondSpam)
				twipe(bossHealth)
				twipe(bossHealthuIdCache)
				--sync table
				twipe(private.canSetIcons)
				twipe(iconSetRevision)
				twipe(iconSetPerson)
				bossuIdFound = false
				eeSyncSender = {}
				eeSyncReceived = 0
				self:CreatePizzaTimer(time, "", nil, nil, nil, true)--Auto Terminate infinite loop timers on combat end
				self:TransitionToDungeonBGM(false, true)
				self:Schedule(22, self.TransitionToDungeonBGM, self)
				--module cleanup
				private:ClearModuleTasks()
			end
		end
	end
end

function DBM:OnMobKill(cId, synced)
	for i = #inCombat, 1, -1 do
		local v = inCombat[i]
		if not v.combatInfo then
			return
		end
		if v.combatInfo.noBossDeathKill then return end
		if v.combatInfo.killMobs and v.combatInfo.killMobs[cId] then
			if not synced then
				sendSync("K", cId)
			end
			v.combatInfo.killMobs[cId] = false
			if v.numBoss then
				v.vb.bossLeft = (v.vb.bossLeft or v.numBoss) - 1
				self:Debug("Boss left - "..v.vb.bossLeft.."/"..v.numBoss, 2)
			end
			local allMobsDown = true
			for _, k in pairs(v.combatInfo.killMobs) do
				if k then
					allMobsDown = false
					break
				end
			end
			if allMobsDown then
				self:EndCombat(v)
			end
		elseif cId == v.combatInfo.mob and not v.combatInfo.killMobs and not v.combatInfo.multiMobPullDetection then
			if not synced then
				sendSync("K", cId)
			end
			self:EndCombat(v)
		end
	end
end

do
	local autoLog = false
	local autoTLog = false

	local function isCurrentContent()
		return instanceDifficultyBylevel[LastInstanceMapID] and (instanceDifficultyBylevel[LastInstanceMapID][1] >= playerLevel) and (instanceDifficultyBylevel[LastInstanceMapID][2] == 3) or (difficultyIndex or 0) == 8--current player level raid or any M+ dungeon
	end

	function DBM:StartLogging(timer, checkFunc, force)
		self:Unschedule(DBM.StopLogging)
		if not force and self.Options.LogOnlyNonTrivial and ((LastInstanceType ~= "raid" and difficultyIndex ~= 8) or (isRetail and IsPartyLFG()) or not isCurrentContent()) then return end
		if self.Options.AutologBosses then
			if not LoggingCombat() then
				autoLog = true
				self:AddMsg("|cffffff00"..COMBATLOGENABLED.."|r")
				LoggingCombat(true)
			end
		end
		local transcriptor = _G["Transcriptor"]
		if self.Options.AdvancedAutologBosses and transcriptor then
			if not transcriptor:IsLogging() then
				autoTLog = true
				self:AddMsg("|cffffff00"..L.TRANSCRIPTOR_LOG_START.."|r")
				transcriptor:StartLog(1)
			end
		end
		if checkFunc and (autoLog or autoTLog) then
			self:Unschedule(checkFunc)
			self:Schedule(timer+10, checkFunc)--But if pull was canceled and we don't have a boss engaged within 10 seconds of pull timer ending, abort log
		end
	end

	function DBM:StopLogging()
		if self.Options.AutologBosses and LoggingCombat() and autoLog then
			autoLog = false
			self:AddMsg("|cffffff00"..COMBATLOGDISABLED.."|r")
			LoggingCombat(false)
		end
		local transcriptor = _G["Transcriptor"]
		if self.Options.AdvancedAutologBosses and transcriptor and autoTLog then
			if transcriptor:IsLogging() then
				autoTLog = false
				self:AddMsg("|cffffff00"..L.TRANSCRIPTOR_LOG_END.."|r")
				transcriptor:StopLog(1)
			end
		end
	end
end

do
	--In event api fails to pull any data at all, just assign classes to their initial template roles from exiles reach
	local fallbackClassToRole = {
		["MAGE"] = 1449,
		["PALADIN"] = 1451,
		["WARRIOR"] = 1446,
		["DRUID"] = 1447,
		["DEATHKNIGHT"] = 1455,
		["HUNTER"] = 1448,
		["PRIEST"] = 1452,
		["ROGUE"] = 1453,
		["SHAMAN"] = 1444,
		["WARLOCK"] = 1454,
		["MONK"] = 1450,
		["DEMONHUNTER"] = 1456,
	}

	function DBM:SetCurrentSpecInfo()
		if isRetail then
			currentSpecGroup = GetSpecialization() or 1
			if GetSpecializationInfo(currentSpecGroup) then
				currentSpecID, currentSpecName = GetSpecializationInfo(currentSpecGroup)--give temp first spec id for non-specialization char. no one should use dbm with no specialization, below level 10, should not need dbm.
				currentSpecID = tonumber(currentSpecID)
			else
				currentSpecID, currentSpecName = fallbackClassToRole[playerClass], playerClass
			end
		else
			local numTabs = GetNumTalentTabs()
			local highestPointsSpent = 0
			if MAX_TALENT_TABS then
				for i=1, MAX_TALENT_TABS do
					if ( i <= numTabs ) then
						local _, _, pointsSpent = GetTalentTabInfo(i)
						if pointsSpent > highestPointsSpent then
							highestPointsSpent = pointsSpent
							currentSpecGroup = i
							currentSpecID = playerClass..tostring(i)--Associate specID with class name and tabnumber (class is used because spec name is shared in some spots like "holy")
							currentSpecName = currentSpecID
						end
					end
				end
			end
			--If 0 talents are spent, then just set them to first spec to prevent nil errors
			--This should only happen for a level 1 player or someone who's in middle of respecing
			if not currentSpecID then currentSpecID = playerClass..tostring(1) end
		end
	end
end

--TODO C_IslandsQueue.GetIslandDifficultyInfo(), if 38-40 don't work
function DBM:GetCurrentInstanceDifficulty()
	local _, instanceType, difficulty, difficultyName, _, _, _, _, instanceGroupSize = GetInstanceInfo()
	if difficulty == 0 or difficulty == 172 or (difficulty == 1 and instanceType == "none") or (C_Garrison and C_Garrison:IsOnGarrisonMap()) then--draenor field returns 1, causing world boss mod bug.
		return "worldboss", RAID_INFO_WORLD_BOSS.." - ", difficulty, instanceGroupSize, 0
	elseif difficulty == 1 or difficulty == 173 or difficulty == 184 then--5 man Normal Dungeon
		return "normal5", difficultyName.." - ", difficulty, instanceGroupSize, 0
	elseif difficulty == 2 or difficulty == 174 then--5 man Heroic Dungeon
		return "heroic5", difficultyName.." - ", difficulty, instanceGroupSize, 0
	elseif difficulty == 3 or difficulty == 175 then--Legacy 10 man Normal Raid
		return "normal10", difficultyName.." - ", difficulty, instanceGroupSize, 0
	elseif difficulty == 4 or difficulty == 176 then--Legacy 25 man Normal Raid
		return "normal25", difficultyName.." - ", difficulty, instanceGroupSize, 0
	elseif difficulty == 5 then--Legacy 10 man Heroic Raid
		return "heroic10", difficultyName.." - ", difficulty, instanceGroupSize, 0
	elseif difficulty == 6 then--Legacy 25 man Heroic Raid
		return "heroic25", difficultyName.." - ", difficulty, instanceGroupSize, 0
	elseif difficulty == 7 then--Legacy 25 man LFR (ie pre WoD zones)
		return "lfr25", difficultyName.." - ", difficulty, instanceGroupSize, 0
	elseif difficulty == 8 then--Dungeon, Mythic+ (Challenge modes in mists and wod)
		local keystoneLevel = C_ChallengeMode and C_ChallengeMode.GetActiveKeystoneInfo() or 0
		return "challenge5", PLAYER_DIFFICULTY6.."+ ("..keystoneLevel..") - ", difficulty, instanceGroupSize, keystoneLevel
	elseif difficulty == 9 or difficulty == 186 then--Legacy 40 man raids, no longer returned as index 3 (normal 10man raids)
		return "normal40", difficultyName.." - ",difficulty, instanceGroupSize, 0
	elseif difficulty == 11 then--Heroic Scenario (mostly Mists of pandaria)
		return "heroicscenario", difficultyName.." - ",difficulty, instanceGroupSize, 0
	elseif difficulty == 12 then--Normal Scenario (mostly Mists of pandaria)
		return "normalscenario", difficultyName.." - ",difficulty, instanceGroupSize, 0
	elseif difficulty == 14 then--Flexible Normal Raid
		return "normal", difficultyName.." - ", difficulty, instanceGroupSize, 0
	elseif difficulty == 15 then--Flexible Heroic Raid
		return "heroic", difficultyName.." - ", difficulty, instanceGroupSize, 0
	elseif difficulty == 16 then--Mythic 20 man Raid
		return "mythic", difficultyName.." - ", difficulty, instanceGroupSize, 0
	elseif difficulty == 17 or difficulty == 151 then--Flexible LFR (ie post WoD zones)/8.3+ LFR
		return "lfr", difficultyName.." - ", difficulty, instanceGroupSize, 0
	elseif difficulty == 18 then--Special event 40 player LFR Queue (used by molten core aniversery event)
		return "event40", difficultyName.." - ", difficulty, instanceGroupSize, 0
	elseif difficulty == 19 then--Special event 5 player queue (used by wod pre expansion event that had miniturized version of UBRS remake)
		return "event5", difficultyName.." - ", difficulty, instanceGroupSize, 0
	elseif difficulty == 20 then--Special event 20 player LFR Queue (never used yet)
		return "event20", difficultyName.." - ", difficulty, instanceGroupSize, 0
	elseif difficulty == 23 then--Mythic 5 man Dungeon
		return "mythic", difficultyName.." - ", difficulty, instanceGroupSize, 0
	elseif difficulty == 24 or difficulty == 33 then--Timewalking Dungeon, Timewalking Raid
		return "timewalker", difficultyName.." - ", difficulty, instanceGroupSize, 0
	elseif difficulty == 38 then--Normal BfA Island expedition
		return "normalisland", difficultyName.." - ", difficulty, instanceGroupSize, 0
	elseif difficulty == 39 then--Heroic BfA Island expedition
		return "heroicisland", difficultyName.." - ", difficulty, instanceGroupSize, 0
	elseif difficulty == 40 then--Mythic BfA Island expedition
		return "mythicisland", difficultyName.." - ", difficulty, instanceGroupSize, 0
	elseif difficulty == 147 then--Normal BfA Warfront
		return "normalwarfront", difficultyName.." - ",difficulty, instanceGroupSize, 0
	elseif difficulty == 148 or difficulty == 185 then--20 man classic raid
		return "normal20", difficultyName.." - ",difficulty, instanceGroupSize, 0
	elseif difficulty == 149 then--Heroic BfA Warfront
		return "heroicwarfront", difficultyName.." - ",difficulty, instanceGroupSize, 0
	elseif difficulty == 152 or difficulty == 167 then--Visions of Nzoth (bfa), Torghast (shadowlands)
		return "progressivechallenges", difficultyName.." - ",difficulty, instanceGroupSize, 0
	elseif difficulty == 153 then---Teaming BfA? Island expedition
		return "teamingisland", difficultyName.." - ",difficulty, instanceGroupSize, 0
	else--failsafe
		return "normal", "", difficulty, instanceGroupSize, 0
	end
end

function DBM:GetCurrentArea()
	return LastInstanceMapID
end

function DBM:GetCurrentDifficulty()
	return difficultyIndex
end

function DBM:GetGroupSize()
	return LastGroupSize
end

--Public api for requesting what phase a boss is in, in case they missed the DBM_SetStage callback
--ModId would be journal Id or mod string of mod.
--If not mod is not provided, it'll simply return stage for first boss in combat table if a boss is engaged
function DBM:GetStage(modId)
	if modId then
		local mod = self:GetModByName(modId)
		if mod and mod.inCombat then
			return mod.vb.phase or 0, mod.vb.stageTotality or 0
		end
	else
		if #inCombat > 0 then--At least one boss is engaged
			local mod = inCombat[1]--Get first mod in table
			if mod then
				return mod.vb.phase or 0, mod.vb.stageTotality or 0
			end
		end
	end
end

function DBM:GetKeyStoneLevel()
	return difficultyModifier
end

function DBM:HasMapRestrictions()
	--Check playerX and playerY. if they are nil restrictions are active
	--Restrictions active in all party, raid, pvp, arena maps. No restrictions in "none" or "scenario"
	local playerX, playerY = UnitPosition("player")
	return not playerX or not playerY
end

do
	local LSMMediaCacheBuilt, sharedMediaFileCache, validateCache = false, {}, {}

	local function buildLSMFileCache()
		local hashtable = LibStub("LibSharedMedia-3.0", true):HashTable("sound")
		local keytable = {}
		for k in next, hashtable do
			tinsert(keytable, k)
		end
		for i = 1, #keytable do
			sharedMediaFileCache[hashtable[keytable[i]]] = true
		end
		LSMMediaCacheBuilt = true
	end

	function DBM:ValidateSound(path, log, ignoreCustom)
		-- Ignore build in sounds
		if type(path) == "number" or string.find(path:lower(), "^sound[\\/]+") then
			return true
		end
		-- Validate LibSharedMedia
		if not LSMMediaCacheBuilt then
			buildLSMFileCache()
		end
		if not sharedMediaFileCache[path] and not path:find("DBM") then
			if log then
				if ignoreCustom then
					-- This uses debug print because it has potential to cause mid fight spam
					self:Debug("PlaySoundFile failed do to missing media at " .. path .. ". To fix this, re-add missing sound or change setting using this sound to a different sound.")
				else
					AddMsg(self, "PlaySoundFile failed do to missing media at " .. path .. ". To fix this, re-add missing sound or change setting using this sound to a different sound.")
				end
			end
			return false
		end
		-- Validate audio packs
		if not validateCache[path] then
			local splitTable = {}
			for split in string.gmatch(path, "[^\\/]+") do -- Matches \ and / as path delimiters (incl. more than one)
				tinsert(splitTable, split)
			end
			if #splitTable >= 3 and splitTable[3]:lower() == "dbm-customsounds" then
				validateCache[path] = {
					exists = ignoreCustom or false
				}
			elseif #splitTable >= 3 and splitTable[1]:lower() == "interface" and splitTable[2]:lower() == "addons" then -- We're an addon sound
				validateCache[path] = {
					exists = IsAddOnLoaded(splitTable[3]),
					AddOn = splitTable[3]
				}
			else
				validateCache[path] = {
					exists = true
				}
			end
		end
		if validateCache[path] and not validateCache[path].exists then
			if log then
				-- This uses actual user print because these events only occure at start or end of instance or fight.
				AddMsg(self, "PlaySoundFile failed do to missing media at " .. path .. ". To fix this, re-add/enable " .. validateCache[path].AddOn .. " or change setting using this sound to a different sound.")
			end
			return false
		end
		return true
	end

	local function playSound(self, path, ignoreSFX, validate)
		if self.Options.SilentMode or path == "" or path == "None" then
			return
		end
		local soundSetting = self.Options.UseSoundChannel
		if type(path) == "number" then
			self:Debug("PlaySound playing with media " .. path, 3)
			if soundSetting == "Dialog" then
				PlaySound(path, "Dialog", false)
			elseif ignoreSFX or soundSetting == "Master" then
				PlaySound(path, "Master", false)
			else
				PlaySound(path) -- Using SFX channel, leave forceNoDuplicates on.
			end
			fireEvent("DBM_PlaySound", path)
		else
			if validate and not self:ValidateSound(path, true, true) then
				return
			end
			self:Debug("PlaySoundFile playing with media " .. path, 3)
			if soundSetting == "Dialog" then
				PlaySoundFile(path, "Dialog")
			elseif ignoreSFX or soundSetting == "Master" then
				PlaySoundFile(path, "Master")
			else
				PlaySoundFile(path)
			end
			fireEvent("DBM_PlaySound", path)
		end
	end

	function DBM:PlaySoundFile(path, ignoreSFX, validate)
		playSound(self, path, ignoreSFX, validate)
	end

	function DBM:PlaySound(path, ignoreSFX, validate)
		playSound(self, path, ignoreSFX, validate)
	end
end

--Future proofing EJ_GetSectionInfo compat layer to make it easier updatable.
function DBM:EJ_GetSectionInfo(sectionID)
	if not isRetail then
		return "EJ_GetSectionInfo"
	end
	local info = EJ_GetSectionInfo(sectionID)
	if not info then
		if self.Options.BadIDAlert then
			self:AddMsg("|cffff0000Invalid call to EJ_GetSectionInfo for sectionID: |r"..sectionID..". Please report this bug")
		else
			self:Debug("|cffff0000Invalid call to EJ_GetSectionInfo for sectionID: |r"..sectionID)
		end
		return
	end
	local flag1, flag2, flag3, flag4
	local flags = GetSectionIconFlags(sectionID)
	if flags then
		flag1, flag2, flag3, flag4 = unpack(flags)
	end
	return info.title, info.description, info.headerType, info.abilityIcon, info.creatureDisplayID, info.siblingSectionID, info.firstChildSectionID, info.filteredByDifficulty, info.link, info.startsOpen, flag1, flag2, flag3, flag4
end

function DBM:GetDungeonInfo(id)
	local temp = GetDungeonInfo(id)
	return type(temp) == "table" and temp.name or temp
end

--Handle new spell name requesting with wrapper, to make api changes easier to handle
--Keep an eye on C_SpellBook.GetSpellInfo, but don't use it YET as direction of existing GetSpellInfo isn't finalized yet
function DBM:GetSpellInfo(spellId)
	--I want this to fail, and fail loudly (ie get reported when mods are completely missing the spellId)
	if not spellId or spellId == "" then
		error("|cffff0000Invalid call to GetSpellInfo for spellId. spellId is missing! |r")
	end
	local name, rank, icon, castingTime, minRange, maxRange, returnedSpellId = GetSpellInfo(spellId)
	--I want this for debug purposes to catch spellids that are removed from game/changed, but quietly to end user
	if not returnedSpellId then--Bad request all together
		if type(spellId) == "string" then
			self:Debug("|cffff0000Invalid call to GetSpellInfo for spellId: |r"..spellId.." as a string!")
		else
			if spellId > 4 then
				if self.Options.BadIDAlert then
					self:AddMsg("|cffff0000Invalid call to GetSpellInfo for spellId: |r"..spellId..". Please report this bug")
				else
					self:Debug("|cffff0000Invalid call to GetSpellInfo for spellId: |r"..spellId)
				end
			end
		end
		return
	end--Good request, return now
	return name, rank, icon, castingTime, minRange, maxRange, returnedSpellId
end

function DBM:UnitAura(uId, spellInput, spellInput2, spellInput3, spellInput4, spellInput5)
	if not uId then return end
	for i = 1, 60 do
		local spellName, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod, value1, value2, value3 = UnitAura(uId, i)
		if not spellName then return end
		if spellInput == spellName or spellInput == spellId or spellInput2 == spellName or spellInput2 == spellId or spellInput3 == spellName or spellInput3 == spellId or spellInput4 == spellName or spellInput4 == spellId or spellInput5 == spellName or spellInput5 == spellId then
			return spellName, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod, value1, value2, value3
		end
	end
end

--In classic, instead of adding rank back in at beginning where it was pre 8.0, it's 15th arg return at end (value 1)
function DBM:UnitDebuff(uId, spellInput, spellInput2, spellInput3, spellInput4, spellInput5)
	if not uId then return end
	for i = 1, 60 do
		local spellName, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod, value1, value2, value3 = UnitDebuff(uId, i)
		if not spellName then return end
		if spellInput == spellName or spellInput == spellId or spellInput2 == spellName or spellInput2 == spellId or spellInput3 == spellName or spellInput3 == spellId or spellInput4 == spellName or spellInput4 == spellId or spellInput5 == spellName or spellInput5 == spellId then
			return spellName, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod, value1, value2, value3
		end
	end
end

--In classic, instead of adding rank back in at beginning where it was pre 8.0, it's 15th arg return at end (value 1)
function DBM:UnitBuff(uId, spellInput, spellInput2, spellInput3, spellInput4, spellInput5)
	if not uId then return end
	for i = 1, 60 do
		local spellName, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod, value1, value2, value3 = UnitBuff(uId, i)
		if not spellName then return end
		if spellInput == spellName or spellInput == spellId or spellInput2 == spellName or spellInput2 == spellId or spellInput3 == spellName or spellInput3 == spellId or spellInput4 == spellName or spellInput4 == spellId or spellInput5 == spellName or spellInput5 == spellId then
			return spellName, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod, value1, value2, value3
		end
	end
end

function DBM:UNIT_DIED(args)
	local GUID = args.destGUID
	if self:IsCreatureGUID(GUID) then
		self:OnMobKill(self:GetCIDFromGUID(GUID))
	end
	----GUIDIsPlayer
	if self.Options.AFKHealthWarning and GUID == UnitGUID("player") and not IsEncounterInProgress() and UnitIsAFK("player") and self:AntiSpam(5, "AFK") then--You are afk and losing health, some griever is trying to kill you while you are afk/tabbed out.
		self:FlashClientIcon()
		self:PlaySound(8585)--So fire an alert sound to save yourself from this person's behavior.
		self:AddMsg(L.AFK_WARNING:format(0))
	end
end
DBM.UNIT_DESTROYED = DBM.UNIT_DIED

----------------------
--  Timer recovery  --
----------------------
do
	local requestedFrom = {}
	local requestTime = 0

	local function sort(v1, v2)
		if v1.revision and not v2.revision then
			return true
		elseif v2.revision and not v1.revision then
			return false
		elseif v1.revision and v2.revision then
			return v1.revision > v2.revision
		end
		return (v1.bwversion or 0) > (v2.bwversion or 0)
	end

	function DBM:RequestTimers(requestNum)
		local sortMe, clientUsed = {}, {}
		for _, v in pairs(raid) do
			tinsert(sortMe, v)
		end
		tsort(sortMe, sort)
		self:Debug("RequestTimers Running", 2)
		local selectedClient
		local listNum = 0
		for _, v in ipairs(sortMe) do
			-- If selectedClient player's realm is not same with your's, timer recovery by selectedClient not works at all.
			-- SendAddonMessage target channel is "WHISPER" and target player is other realm, no msg sends at all. At same realm, message sending works fine. (Maybe bliz bug or SendAddonMessage function restriction?)
			if v.name ~= playerName and UnitIsConnected(v.id) and (not UnitIsGhost(v.id)) and UnitRealmRelationship(v.id) ~= 2 and (GetTime() - (clientUsed[v.name] or 0)) > 10 then
				listNum = listNum + 1
				if listNum == requestNum then
					selectedClient = v
					clientUsed[v.name] = GetTime()
					break
				end
			end
		end
		if not selectedClient then return end
		self:Debug("Requesting timer recovery to "..selectedClient.name)
		requestedFrom[selectedClient.name] = true
		requestTime = GetTime()
		SendAddonMessage(DBMPrefix, "RT", "WHISPER", selectedClient.name)
	end

	function DBM:ReceiveCombatInfo(sender, mod, time)
		if dbmIsEnabled and requestedFrom[sender] and (GetTime() - requestTime) < 5 and #inCombat == 0 then
			self:StartCombat(mod, time, "TIMER_RECOVERY")
			--Recovery successful, someone sent info, abort other recovery requests
			self:Unschedule(self.RequestTimers)
			twipe(requestedFrom)
		end
	end

	function DBM:ReceiveTimerInfo(sender, mod, timeLeft, totalTime, id, paused, ...)
		if requestedFrom[sender] and (GetTime() - requestTime) < 5 then
			local lag = paused and 0 or select(4, GetNetStats()) / 1000
			for _, v in ipairs(mod.timers) do
				if v.id == id then
					v:Start(totalTime, ...)
					if paused then
						v.paused = true
					end
					v:Update(totalTime - timeLeft + lag, totalTime, ...)
				end
			end
		end
	end

	function DBM:ReceiveVariableInfo(sender, mod, name, value)
		if requestedFrom[sender] and (GetTime() - requestTime) < 5 then
			if value == "true" then
				mod.vb[name] = true
			elseif value == "false" then
				mod.vb[name] = false
			else
				mod.vb[name] = value
				if name == "phase" then
					mod:SetStage(value)--Fire stage callback for 3rd party mods when stage is recovered
				end
			end
		end
	end
end

do
	local spamProtection = {}
	function DBM:SendTimers(target)
		self:Debug("SendTimers requested by "..target, 2)
		local spamForTarget = spamProtection[target] or 0
		-- just try to clean up the table, that should keep the hash table at max. 4 entries or something :)
		for k, v in pairs(spamProtection) do
			if GetTime() - v >= 1 then
				spamProtection[k] = nil
			end
		end
		if GetTime() - spamForTarget < 1 then -- just to prevent players from flooding this on purpose
			return
		end
		spamProtection[target] = GetTime()
		if #inCombat < 1 then
			--Break timer is up, so send that
			--But only if we are not in combat with a boss
			if DBT:GetBar(L.TIMER_BREAK) then
				local remaining = DBT:GetBar(L.TIMER_BREAK).timer
				SendAddonMessage(DBMPrefix, "BTR3\t"..remaining, "WHISPER", target)
			end
			return
		end
		local mod
		for _, v in ipairs(inCombat) do
			mod = not v.isCustomMod and v
		end
		mod = mod or inCombat[1]
		self:SendCombatInfo(mod, target)
		self:SendVariableInfo(mod, target)
		self:SendTimerInfo(mod, target)
	end
	function DBM:SendPVPTimers(target)
		self:Debug("SendPVPTimers requested by "..target, 2)
		local spamForTarget = spamProtection[target] or 0
		local time = GetTime()
		-- just try to clean up the table, that should keep the hash table at max. 4 entries or something :)
		for k, v in pairs(spamProtection) do
			if time - v >= 1 then
				spamProtection[k] = nil
			end
		end
		if time - spamForTarget < 1 then -- just to prevent players from flooding this on purpose
			return
		end
		spamProtection[target] = time
		local mod = self:GetModByName("PvPGeneral")
		if mod then
			self:SendTimerInfo(mod, target)
		end
	end
end

function DBM:SendCombatInfo(mod, target)
	return SendAddonMessage(DBMPrefix, ("CI\t%s\t%s"):format(mod.id, GetTime() - mod.combatInfo.pull), "WHISPER", target)
end

function DBM:SendTimerInfo(mod, target)
	for _, v in ipairs(mod.timers) do
		--Pass on any timer that has no type, or has one that isn't an ai timer
		if not v.type or v.type and v.type ~= "ai" then
			for _, uId in ipairs(v.startedTimers) do
				local elapsed, totalTime, timeLeft
				if select("#", string.split("\t", uId)) > 1 then
					elapsed, totalTime = v:GetTime(select(2, string.split("\t", uId)))
				else
					elapsed, totalTime = v:GetTime()
				end
				timeLeft = totalTime - elapsed
				if timeLeft > 0 and totalTime > 0 then
					SendAddonMessage(DBMPrefix, ("TR\t%s\t%s\t%s\t%s\t%s"):format(mod.id, timeLeft, totalTime, uId, v.paused and "1" or "0"), "WHISPER", target)
				end
			end
		end
	end
end

function DBM:SendVariableInfo(mod, target)
	for vname, v in pairs(mod.vb) do
		local v2 = tostring(v)
		if v2 then
			SendAddonMessage(DBMPrefix, ("VI\t%s\t%s\t%s"):format(mod.id, vname, v2), "WHISPER", target)
		end
	end
end

do
	function DBM:PLAYER_ENTERING_WORLD()
		if self.Options.ShowReminders then
			C_TimerAfter(25, function() if self.Options.SilentMode then self:AddMsg(L.SILENT_REMINDER) end end)
			--C_TimerAfter(30, function() if not self.Options.SettingsMessageShown then self.Options.SettingsMessageShown = true self:AddMsg(L.HOW_TO_USE_MOD) end end)
--			C_TimerAfter(35, function() if self.Options.NewsMessageShown2 < 2 then self.Options.NewsMessageShown2 = 2 self:AddMsg(L.NEWS_UPDATE) end end)
		end
		if type(C_ChatInfo.RegisterAddonMessagePrefix) == "function" then
			if not C_ChatInfo.RegisterAddonMessagePrefix(DBMPrefix) then -- main prefix for DBM4
				self:AddMsg("Error: unable to register DBM addon message prefix (reached client side addon message filter limit), synchronization will be unavailable") -- TODO: confirm that this actually means that the syncs won't show up
			end
			if not C_ChatInfo.IsAddonMessagePrefixRegistered("BigWigs") then
				if not C_ChatInfo.RegisterAddonMessagePrefix("BigWigs") then
					self:AddMsg("Error: unable to register BigWigs addon message prefix (reached client side addon message filter limit), BigWigs version checks will be unavailable")
				end
			end
			if not C_ChatInfo.IsAddonMessagePrefixRegistered("Transcriptor") then
				if not C_ChatInfo.RegisterAddonMessagePrefix("Transcriptor") then
					self:AddMsg("Error: unable to register Transcriptor addon message prefix (reached client side addon message filter limit)")
				end
			end
		end
		--Check if any previous changed cvars were not restored and restore them
		if self.Options.RestoreSettingSFX then
			SetCVar("Sound_EnableSFX", 1)
			self.Options.RestoreSettingSFX = nil
			self:Debug("Restoring Sound_EnableSFX CVAR")
		end
		if self.Options.RestoreSettingQuestTooltips then
			SetCVar("showQuestTrackingTooltips", self.Options.RestoreSettingQuestTooltips)
			self.Options.RestoreSettingQuestTooltips = nil
			self:Debug("Restoring showQuestTrackingTooltips CVAR")
		end
		--RestoreSettingMusic doens't need restoring here, since zone change transition will handle it
	end
end

------------------------------------
--  Auto-respond/Status whispers  --
------------------------------------
do
	local function getNumAlivePlayers()
		local alive = 0
		if IsInRaid() then
			for i = 1, GetNumGroupMembers() do
				alive = alive + ((UnitIsDeadOrGhost("raid"..i) and 0) or 1)
			end
		else
			alive = (UnitIsDeadOrGhost("player") and 0) or 1
			for i = 1, GetNumSubgroupMembers() do
				alive = alive + ((UnitIsDeadOrGhost("party"..i) and 0) or 1)
			end
		end
		return alive
	end

	--Cleanup in 8.x with C_Map.GetMapGroupMembersInfo
	local function getNumRealAlivePlayers()
		local alive = 0
		local isInInstance = IsInInstance()
		local currentMapId = isInInstance and select(4, UnitPosition("player")) or C_Map.GetBestMapForUnit("player") or 0
		local currentMapName = C_Map.GetMapInfo(currentMapId) or CL.UNKNOWN
		if IsInRaid() then
			for i = 1, GetNumGroupMembers() do
				if isInInstance and select(4, UnitPosition("raid"..i)) == currentMapId or select(7, GetRaidRosterInfo(i)) == currentMapName then
					alive = alive + ((UnitIsDeadOrGhost("raid"..i) and 0) or 1)
				end
			end
		else
			alive = (UnitIsDeadOrGhost("player") and 0) or 1
			for i = 1, GetNumSubgroupMembers() do
				if isInInstance and select(4, UnitPosition("party"..i)) == currentMapId or select(7, GetRaidRosterInfo(i)) == currentMapName then
					alive = alive + ((UnitIsDeadOrGhost("party"..i) and 0) or 1)
				end
			end
		end
		return alive
	end
	function DBM:NumRealAlivePlayers()
		return getNumRealAlivePlayers()
	end

	-- sender is a presenceId for real id messages, a character name otherwise
	local function onWhisper(msg, sender, isRealIdMessage)
		if statusWhisperDisabled then return end--RL has disabled status whispers for entire raid.
		if not checkForSafeSender(sender, true, true, true, isRealIdMessage) then return end--Automatically reject all whisper functions from non friends, non guildies, or people in group with us
		if msg:find(chatPrefixShort) and not InCombatLockdown() and DBM:AntiSpam(60, "Ogron") and DBM.Options.AutoReplySound then
			--Might need more validation if people figure out they can just whisper people with chatPrefix to trigger it.
			--However if I have to add more validation it probably won't work in most languages :\ So lets hope antispam and combat check is enough
			DBM:PlaySound(41928)--"sound\\creature\\aggron1\\VO_60_HIGHMAUL_AGGRON_1_AGGRO_1.ogg"
		elseif msg == "status" and #inCombat > 0 and DBM.Options.AutoRespond then
			if not difficultyText then -- prevent error when timer recovery function worked and etc (StartCombat not called)
				savedDifficulty, difficultyText, difficultyIndex, LastGroupSize, difficultyModifier = DBM:GetCurrentInstanceDifficulty()
			end
			local mod
			for _, v in ipairs(inCombat) do
				mod = not v.isCustomMod and v
			end
			mod = mod or inCombat[1]
			if mod.noStatistics then return end
			if isRetail and not mod.soloChallenge and IsInScenarioGroup() then return end--status not really useful on scenario mods since there is no way to report progress as a percent. We just ignore it.
			local hp = mod.highesthealth and mod:GetHighestBossHealth() or mod:GetLowestBossHealth()
			local hpText = mod.CustomHealthUpdate and mod:CustomHealthUpdate() or hp and ("%d%%"):format(hp) or CL.UNKNOWN
			if mod.vb.phase then
				hpText = hpText.." ("..SCENARIO_STAGE:format(mod.vb.phase)..")"
			end
			if mod.numBoss and mod.vb.bossLeft and mod.numBoss > 1 then
				local bossesKilled = mod.numBoss - mod.vb.bossLeft
				hpText = hpText.." ("..BOSSES_KILLED:format(bossesKilled, mod.numBoss)..")"
			end
			sendWhisper(sender, chatPrefixShort..L.STATUS_WHISPER:format(difficultyText..(mod.combatInfo.name or ""), hpText, IsInInstance() and getNumRealAlivePlayers() or getNumAlivePlayers(), DBM:GetNumRealGroupMembers()))
		elseif #inCombat > 0 and DBM.Options.AutoRespond then
			if not difficultyText then -- prevent error when timer recovery function worked and etc (StartCombat not called)
				savedDifficulty, difficultyText, difficultyIndex, LastGroupSize, difficultyModifier = DBM:GetCurrentInstanceDifficulty()
			end
			local mod
			for _, v in ipairs(inCombat) do
				mod = not v.isCustomMod and v
			end
			mod = mod or inCombat[1]
			if mod.noStatistics then return end
			local hp = mod.highesthealth and mod:GetHighestBossHealth() or mod:GetLowestBossHealth()
			local hpText = mod.CustomHealthUpdate and mod:CustomHealthUpdate() or hp and ("%d%%"):format(hp) or CL.UNKNOWN
			if mod.vb.phase then
				hpText = hpText.." ("..SCENARIO_STAGE:format(mod.vb.phase)..")"
			end
			if mod.numBoss and mod.vb.bossLeft and mod.numBoss > 1 then
				local bossesKilled = mod.numBoss - mod.vb.bossLeft
				hpText = hpText.." ("..BOSSES_KILLED:format(bossesKilled, mod.numBoss)..")"
			end
			if not autoRespondSpam[sender] then
				if isRetail and not mod.soloChallenge and IsInScenarioGroup() then
					sendWhisper(sender, chatPrefixShort..L.AUTO_RESPOND_WHISPER_SCENARIO:format(playerName, difficultyText..(mod.combatInfo.name or ""), getNumAlivePlayers(), DBM:GetNumGroupMembers()))
				else
					sendWhisper(sender, chatPrefixShort..L.AUTO_RESPOND_WHISPER:format(playerName, difficultyText..(mod.combatInfo.name or ""), hpText, IsInInstance() and getNumRealAlivePlayers() or getNumAlivePlayers(), DBM:GetNumRealGroupMembers()))
				end
				DBM:AddMsg(L.AUTO_RESPONDED)
			end
			autoRespondSpam[sender] = true
		end
	end

	function DBM:CHAT_MSG_WHISPER(msg, name, _, _, _, status)
		if status ~= "GM" then
			name = Ambiguate(name, "none")
			return onWhisper(msg, name, false)
		end
	end

	function DBM:CHAT_MSG_BN_WHISPER(msg, ...)
		local presenceId = select(12, ...) -- srsly?
		return onWhisper(msg, presenceId, true)
	end
end

--This completely unregisteres or registers distruptive events so they don't obstruct combat
--Toggle is for if we are turning off or on.
--Custom is for external mods to call function without duplication and allowing pvp mods custom toggle.
do
	local unregisteredEvents = {}
	local function DisableEvent(frameName, eventName)
		if frameName:IsEventRegistered(eventName) then
			frameName:UnregisterEvent(eventName)
			unregisteredEvents[eventName] = true
		end
	end
	local function EnableEvent(frameName, eventName)
		if unregisteredEvents[eventName] then
			frameName:RegisterEvent(eventName)
			unregisteredEvents[eventName] = nil
		end
	end
	function DBM:HideBlizzardEvents(toggle, custom)
		if toggle == 1 then
			if (self.Options.HideBossEmoteFrame2 or custom) and not testBuild then
				DisableEvent(RaidBossEmoteFrame, "RAID_BOSS_EMOTE")
				DisableEvent(RaidBossEmoteFrame, "RAID_BOSS_WHISPER")
				DisableEvent(RaidBossEmoteFrame, "CLEAR_BOSS_EMOTES")
				SOUNDKIT.UI_RAID_BOSS_WHISPER_WARNING = 999999--Since blizzard can still play the sound via RaidBossEmoteFrame_OnEvent (line 148) via encounter scripts in certain cases despite the frame having no registered events
			end
			if self.Options.HideGarrisonToasts or custom then
				DisableEvent(AlertFrame, "GARRISON_MISSION_FINISHED")
				DisableEvent(AlertFrame, "GARRISON_BUILDING_ACTIVATABLE")
			end
			if self.Options.HideGuildChallengeUpdates or custom then
				DisableEvent(AlertFrame, "GUILD_CHALLENGE_COMPLETED")
			end
		elseif toggle == 0 then
			if self.Options.RestoreSettingQuestTooltips then
				SetCVar("showQuestTrackingTooltips", self.Options.RestoreSettingQuestTooltips)
				self.Options.RestoreSettingQuestTooltips = nil
				self:Debug("Restoring Quest Tooltip CVAR")
			end
			if (self.Options.HideBossEmoteFrame2 or custom) and not testBuild then
				EnableEvent(RaidBossEmoteFrame, "RAID_BOSS_EMOTE")
				EnableEvent(RaidBossEmoteFrame, "RAID_BOSS_WHISPER")
				EnableEvent(RaidBossEmoteFrame, "CLEAR_BOSS_EMOTES")
				SOUNDKIT.UI_RAID_BOSS_WHISPER_WARNING = 37666--restore it
			end
			if self.Options.HideGarrisonToasts then
				EnableEvent(AlertFrame, "GARRISON_MISSION_FINISHED")
				EnableEvent(AlertFrame, "GARRISON_BUILDING_ACTIVATABLE")
			end
			if self.Options.HideGuildChallengeUpdates then
				EnableEvent(AlertFrame, "GUILD_CHALLENGE_COMPLETED")
			end
		end
	end
end

--------------------------
--  Enable/Disable DBM  --
--------------------------
do
	local forceDisabled = false
	function DBM:Disable(forceDisable)
		DBMScheduler:Unschedule()
		dbmIsEnabled = false
		forceDisabled = forceDisable
	end

	function DBM:Enable()
		if not forceDisabled then
			dbmIsEnabled = true
		end
	end

	function DBM:IsEnabled()
		return dbmIsEnabled
	end
end

-----------------------
--  Misc. Functions  --
-----------------------
function DBM:AddMsg(text, prefix)
	local tag = prefix or (self.localization and self.localization.general.name) or L.DBM
	local frame = DBM.Options.ChatFrame and _G[tostring(DBM.Options.ChatFrame)] or DEFAULT_CHAT_FRAME
	if not frame or not frame:IsShown() then
		frame = DEFAULT_CHAT_FRAME
	end
	if prefix ~= false then
		frame:AddMessage(("|cffff7d0a<|r|cffffd200%s|r|cffff7d0a>|r %s"):format(tostring(tag), tostring(text)), 0.41, 0.8, 0.94)
	else
		frame:AddMessage(text, 0.41, 0.8, 0.94)
	end
end
AddMsg = DBM.AddMsg

do
	local testMod
	local testWarning1, testWarning2, testWarning3
	local testTimer1, testTimer2, testTimer3, testTimer4, testTimer5, testTimer6, testTimer7, testTimer8
	local testSpecialWarning1, testSpecialWarning2, testSpecialWarning3
	function DBM:DemoMode()
		if not testMod then
			testMod = self:NewMod("TestMod")
			self:GetModLocalization("TestMod"):SetGeneralLocalization{ name = "Test Mod" }
			testWarning1 = testMod:NewAnnounce("%s", 1, "136116")--Interface\\Icons\\Spell_Nature_WispSplode
			testWarning2 = testMod:NewAnnounce("%s", 2, isRetail and "136194" or "136221")
			testWarning3 = testMod:NewAnnounce("%s", 3, "135826")
			testTimer1 = testMod:NewTimer(20, "%s", "136116", nil, nil)
			testTimer2 = testMod:NewTimer(20, "%s ", "134170", nil, nil, 1)
			testTimer3 = testMod:NewTimer(20, "%s  ", isRetail and "136194" or "136221", nil, nil, 3, L.MAGIC_ICON, nil, 1, 4)--inlineIcon, keep, countdown, countdownMax
			testTimer4 = testMod:NewTimer(20, "%s   ", "136116", nil, nil, 4, L.INTERRUPT_ICON)
			testTimer5 = testMod:NewTimer(20, "%s    ", "135826", nil, nil, 2, L.HEALER_ICON, nil, 3, 4)--inlineIcon, keep, countdown, countdownMax
			testTimer6 = testMod:NewTimer(20, "%s     ", "136116", nil, nil, 5, L.TANK_ICON, nil, 2, 4)--inlineIcon, keep, countdown, countdownMax
			testTimer7 = testMod:NewTimer(20, "%s      ", "136116", nil, nil, 6)
			testTimer8 = testMod:NewTimer(20, "%s       ", "136116", nil, nil, 7)
			testSpecialWarning1 = testMod:NewSpecialWarning("%s", nil, nil, nil, 1, 2)
			testSpecialWarning2 = testMod:NewSpecialWarning(" %s ", nil, nil, nil, 2, 2)
			testSpecialWarning3 = testMod:NewSpecialWarning("  %s  ", nil, nil, nil, 3, 2) -- hack: non auto-generated special warnings need distinct names (we could go ahead and give them proper names with proper localization entries, but this is much easier)
		end
		testTimer1:Stop("Test Bar")
		testTimer2:Stop("Adds")
		testTimer3:Stop("Evil Debuff")
		testTimer4:Stop("Important Interrupt")
		testTimer5:Stop("Boom!")
		testTimer6:Stop("Handle your Role")
		testTimer7:Stop("Next Stage")
		testTimer8:Stop("Custom User Bar")
		testTimer1:Start(10, "Test Bar")
		testTimer2:Start(30, "Adds")
		testTimer3:Start(43, "Evil Debuff")
		testTimer4:Start(20, "Important Interrupt")
		testTimer5:Start(60, "Boom!")
		testTimer6:Start(35, "Handle your Role")
		testTimer7:Start(50, "Next Stage")
		testTimer8:Start(55, "Custom User Bar")
		testWarning1:Cancel()
		testWarning2:Cancel()
		testWarning3:Cancel()
		testSpecialWarning1:Cancel()
		testSpecialWarning1:CancelVoice()
		testSpecialWarning2:Cancel()
		testSpecialWarning2:CancelVoice()
		testSpecialWarning3:Cancel()
		testSpecialWarning3:CancelVoice()
		testWarning1:Show("Test-mode started...")
		testWarning1:Schedule(62, "Test-mode finished!")
		testWarning3:Schedule(50, "Boom in 10 sec!")
		testWarning3:Schedule(20, "Pew Pew Laser Owl!")
		testWarning2:Schedule(38, "Evil Spell in 5 sec!")
		testWarning2:Schedule(43, "Evil Spell!")
		testWarning1:Schedule(10, "Test bar expired!")
		testSpecialWarning1:Schedule(20, "Pew Pew Laser Owl")
		testSpecialWarning1:ScheduleVoice(20, "runaway")
		testSpecialWarning2:Schedule(43, "Fear!")
		testSpecialWarning2:ScheduleVoice(43, "fearsoon")
		testSpecialWarning3:Schedule(60, "Boom!")
		testSpecialWarning3:ScheduleVoice(60, "defensive")
	end
end

DBT:SetAnnounceHook(function(bar)
	local prefix
	if bar.color and bar.color.r == 1 and bar.color.g == 0 and bar.color.b == 0 then
		prefix = L.HORDE or FACTION_HORDE
	elseif bar.color and bar.color.r == 0 and bar.color.g == 0 and bar.color.b == 1 then
		prefix = L.ALLIANCE or FACTION_ALLIANCE
	end
	if prefix then
		return ("%s: %s  %d:%02d"):format(prefix, _G[bar.frame:GetName().."BarName"]:GetText(), floor(bar.timer / 60), bar.timer % 60)
	end
end)

--copied from big wigs with permission from funkydude. Modified by MysticalOS
function DBM:RoleCheck(ignoreLoot)
	local spec = GetSpecialization()
	if not spec then return end
	local role = GetSpecializationRole(spec)
	if not role then return end
	local specID = GetLootSpecialization()
	local _, _, _, _, lootrole = GetSpecializationInfoByID(specID)
	if not InCombatLockdown() and not IsFalling() and ((IsPartyLFG() and (difficultyIndex == 14 or difficultyIndex == 15)) or not IsPartyLFG()) then
		if UnitGroupRolesAssigned("player") ~= role then
			UnitSetRole("player", role)
		end
	end
	--Loot reminder even if spec isn't known or we are in LFR where we have a valid for role without us being ones that set us.
	if not ignoreLoot and lootrole and (role ~= lootrole) and self.Options.RoleSpecAlert then
		self:AddMsg(L.LOOT_SPEC_REMINDER:format(_G[role] or CL.UNKNOWN, _G[lootrole]))
	end
end

-- An anti spam function to throttle spammy events (e.g. SPELL_AURA_APPLIED on all group members)
-- @param time the time to wait between two events (optional, default 2.5 seconds)
-- @param id the id to distinguish different events (optional, only necessary if your mod keeps track of two different spam events at the same time)
function DBM:AntiSpam(time, id)
	if GetTime() - (id and (self["lastAntiSpam" .. tostring(id)] or 0) or self.lastAntiSpam or 0) > (time or 2.5) then
		if id then
			self["lastAntiSpam" .. tostring(id)] = GetTime()
		else
			self.lastAntiSpam = GetTime()
		end
		return true
	end
	return false
end

function DBM:InCombat()
	return #inCombat > 0
end

function DBM:FlashClientIcon()
	if self:AntiSpam(5, "FLASH") then
		FlashClientIcon()
	end
end

function DBM:VibrateController()
	if self:AntiSpam(2, "VIBRATE") then
		if C_GamePad and C_GamePad.SetVibration then
			C_GamePad.SetVibration("High", 1)
		end
	end
end


do
	--Search Tags: iconto, toicon, raid icon, diamond, star, triangle
	local iconStrings = {[1] = RAID_TARGET_1, [2] = RAID_TARGET_2, [3] = RAID_TARGET_3, [4] = RAID_TARGET_4, [5] = RAID_TARGET_5, [6] = RAID_TARGET_6, [7] = RAID_TARGET_7, [8] = RAID_TARGET_8,}
	function DBM:IconNumToString(number)
		return iconStrings[number] or number
	end
	function DBM:IconNumToTexture(number)
		return "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_"..number..".blp:12:12|t" or number
	end
end

do
	local DevTools = private:GetModule("DevTools")
	function DBM:Debug(...)
		return DevTools:Debug(...)
	end

	function DBM:FindDungeonMapIDs(...)
		return DevTools:FindDungeonMapIDs(...)
	end

	function DBM:FindInstanceIDs(...)
		return DevTools:FindInstanceIDs(...)
	end

	function DBM:FindScenarioIDs(...)
		return DevTools:FindScenarioIDs(...)
	end

	function DBM:FindEncounterIDs(...)
		return DevTools:FindEncounterIDs(...)
	end
end

--------------------
--  Movie Filter  --
--------------------
do
	local neverFilter = {
		[486] = true, -- Tomb of Sarg Intro
		[487] = true, -- Alliance Broken Shore cut-scene
		[488] = true, -- Horde Broken Shore cut-scene
		[489] = true, -- Unknown, currently encrypted
		[490] = true, -- Unknown, currently encrypted
	}
	function DBM:PLAY_MOVIE(id)
		if id and not neverFilter[id] then
			self:Debug("PLAY_MOVIE fired for ID: "..id, 2)
			local isInstance, instanceType = IsInInstance()
			if not isInstance or (C_Garrison and C_Garrison:IsOnGarrisonMap()) or instanceType == "scenario" or self.Options.MovieFilter2 == "Never" or self.Options.MovieFilter2 == "OnlyFight" and not IsEncounterInProgress() then return end
			if self.Options.MovieFilter2 == "Block" or (self.Options.MovieFilter2 == "AfterFirst" or self.Options.MovieFilter2 == "OnlyFight") and self.Options.MoviesSeen[id] then
				MovieFrame:Hide()--can only just hide movie frame safely now, which means can't stop audio anymore :\
				self:AddMsg(L.MOVIE_SKIPPED)
			else
				self.Options.MoviesSeen[id] = true
			end
		end
		self:TransitionToDungeonBGM(false, true)
	end

	function DBM:CINEMATIC_START()
		self:Debug("CINEMATIC_START fired", 2)
		self.HudMap:SupressCanvas()
		local isInstance, instanceType = IsInInstance()
		if not isInstance or (C_Garrison and C_Garrison:IsOnGarrisonMap()) or instanceType == "scenario" or self.Options.MovieFilter2 == "Never" or DBM.Options.MovieFilter2 == "OnlyFight" and not IsEncounterInProgress() then return end
		local currentMapID = C_Map.GetBestMapForUnit("player")
		local currentSubZone = GetSubZoneText() or ""
		if not currentMapID then return end--Protection from map failures in zones that have no maps yet
		if self.Options.MovieFilter2 == "Block" or (self.Options.MovieFilter2 == "AfterFirst" or self.Options.MovieFilter2 == "OnlyFight") and self.Options.MoviesSeen[currentMapID..currentSubZone] then
			CinematicFrame_CancelCinematic()
			self:AddMsg(L.MOVIE_SKIPPED)
		else
			self.Options.MoviesSeen[currentMapID..currentSubZone] = true
		end
		self:TransitionToDungeonBGM(false, true)
	end
	function DBM:CINEMATIC_STOP()
		self:Debug("CINEMATIC_STOP fired", 2)
		self.HudMap:UnSupressCanvas()
	end
end

----------------------------
--  Boss Mod Constructor  --
----------------------------
do
	local modsById = setmetatable({}, {__mode = "v"})
	local mt = {__index = bossModPrototype}

	function DBM:NewMod(name, modId, modSubTab, instanceId, nameModifier)
		name = tostring(name) -- the name should never be a number of something as it confuses sync handlers that just receive some string and try to get the mod from it
		if name == "DBM-ProfilesDummy" then return end
		if modsById[name] then error("DBM:NewMod(): Mod names are used as IDs and must therefore be unique.", 2) end
		local obj = setmetatable(
			{
				Options = {
					Enabled = true,
				},
				DefaultOptions = {
					Enabled = true,
				},
				subTab = modSubTab,
				optionCategories = {
				},
				categorySort = {"announce", "announceother", "announcepersonal", "announcerole", "specialannounce", "timer", "sound", "yell", "nameplate", "icon", "misc"},
				id = name,
				announces = {},
				specwarns = {},
				timers = {},
				vb = {},
				iconRestore = {},
				modId = modId,
				instanceId = instanceId,
				revision = 0,
				SyncThreshold = 8,
				localization = self:GetModLocalization(name),
				groupSpells = {},
				groupOptions = OrderedTable(),
			},
			mt
		)
		for _, v in ipairs(self.AddOns) do
			if v.modId == modId then
				obj.addon = v
				break
			end
		end

		if tonumber(name) and EJ_GetEncounterInfo then
			local t = EJ_GetEncounterInfo(tonumber(name))
			if type(nameModifier) == "number" then--Get name form EJ_GetCreatureInfo
				t = select(2, EJ_GetCreatureInfo(nameModifier, tonumber(name)))
			elseif type(nameModifier) == "function" then--custom name modify function
				t = nameModifier(t or name)
			else--default name modify
				t = tostring(t)
				t = string.split(",", t or name)
			end
			obj.localization.general.name = t or name
			obj.modelId = select(4, EJ_GetCreatureInfo(1, tonumber(name)))
		elseif name:match("z%d+") then
			local t = GetRealZoneText(string.sub(name, 2))
			if type(nameModifier) == "number" then--do nothing
			elseif type(nameModifier) == "function" then--custom name modify function
				t = nameModifier(t or name)
			else--default name modify
				t = string.split(",", t or name)
			end
			obj.localization.general.name = t or name
		elseif name:match("d%d+") then
			local t = self:GetDungeonInfo(string.sub(name, 2))
			if type(nameModifier) == "number" then--do nothing
			elseif type(nameModifier) == "function" then--custom name modify function
				t = nameModifier(t or name)
			else--default name modify
				t = string.split(",", t or obj.localization.general.name or name)
			end
			obj.localization.general.name = t or name
		else
			obj.localization.general.name = obj.localization.general.name or name
		end
		tinsert(self.Mods, obj)
		if modId then
			self.ModLists[modId] = self.ModLists[modId] or {}
			tinsert(self.ModLists[modId], name)
		end
		modsById[name] = obj
		obj:SetZone()
		return obj
	end

	function DBM:GetModByName(name)
		return modsById[tostring(name)]
	end
end

-----------------------
--  General Methods  --
-----------------------
bossModPrototype.RegisterEvents = DBM.RegisterEvents
bossModPrototype.UnregisterInCombatEvents = DBM.UnregisterInCombatEvents
bossModPrototype.AddMsg = DBM.AddMsg
bossModPrototype.RegisterShortTermEvents = DBM.RegisterShortTermEvents
bossModPrototype.UnregisterShortTermEvents = DBM.UnregisterShortTermEvents

function bossModPrototype:SetZone(...)
	if select("#", ...) == 0 then
		self.zones = {}
		if self.addon and self.addon.mapId then
			for _, v in ipairs(self.addon.mapId) do
				self.zones[v] = true
			end
		end
	elseif select(1, ...) ~= DBM_DISABLE_ZONE_DETECTION then
		self.zones = {}
		for i = 1, select("#", ...) do
			self.zones[select(i, ...)] = true
		end
	else -- disable zone detection
		self.zones = nil
	end
end

function bossModPrototype:Toggle()
	if self.Options.Enabled then
		self:DisableMod()
	else
		self:EnableMod()
	end
end

function bossModPrototype:EnableMod()
	self.Options.Enabled = true
end

function bossModPrototype:DisableMod()
	self:Stop()
	self.Options.Enabled = false
end

function bossModPrototype:Stop()
	for _, v in ipairs(self.timers) do
		v:Stop()
	end
	self:Unschedule()
end

function bossModPrototype:SetUsedIcons(...)
	self.usedIcons = {}
	for i = 1, select("#", ...) do
		self.usedIcons[select(i, ...)] = true
	end
end

function bossModPrototype:RegisterOnUpdateHandler(func, interval)
	if type(func) ~= "function" then return end
	DBM:Debug("Registering RegisterOnUpdateHandler")
	DBMScheduler:StartScheduler()
	self.elapsed = 0
	self.updateInterval = interval or 0
	private.updateFunctions[self] = func
end

function bossModPrototype:UnregisterOnUpdateHandler()
	self.elapsed = nil
	self.updateInterval = nil
	twipe(private.updateFunctions)
end

function bossModPrototype:SetStage(stage)
	if stage == 0 then--Increment request instead of hard value
		self.vb.phase = self.vb.phase + 1
	else
		self.vb.phase = stage
	end
	--Separate variable to use SetStage totality for very niche weak aura practices
	if not self.vb.stageTotality then
		self.vb.stageTotality = 0
	end
	self.vb.stageTotality = self.vb.stageTotality + 1
	if self.inCombat then--Safety, in event mod manages to run any phase change calls out of combat/during a wipe we'll just safely ignore it
		fireEvent("DBM_SetStage", self, self.id, self.vb.phase, self.multiEncounterPullDetection and self.multiEncounterPullDetection[1] or self.encounterId, self.vb.stageTotality)--Mod, modId, Stage, Encounter Id (if available), total number of times SetStage has been called since combat start
		--Note, some encounters have more than one encounter Id, for these encounters, the first ID from mod is always returned regardless of actual engage ID triggered fight
		DBM:Debug("DBM_SetStage: " .. self.vb.phase .. "/" .. self.vb.stageTotality)
	end
end

--------------
--  Events  --
--------------
function bossModPrototype:RegisterEventsInCombat(...)
	if self.inCombatOnlyEvents then
		geterrorhandler()("combat events already set")
	end
	self.inCombatOnlyEvents = {...}
	for k, v in pairs(self.inCombatOnlyEvents) do
		if v:sub(0, 5) == "UNIT_" and v:sub(-11) ~= "_UNFILTERED" and not v:find(" ") and v ~= "UNIT_DIED" and v ~= "UNIT_DESTROYED" then
			-- legacy event, oh noes
			self.inCombatOnlyEvents[k] = v .. " boss1 boss2 boss3 boss4 boss5 target focus"
		end
	end
end

-----------------------
--  Utility Methods  --
-----------------------

function bossModPrototype:IsDifficulty(...)
	local diff = savedDifficulty or DBM:GetCurrentInstanceDifficulty()
	for i = 1, select("#", ...) do
		if diff == select(i, ...) then
			return true
		end
	end
	return false
end

function bossModPrototype:IsLFR()
	local diff = savedDifficulty or DBM:GetCurrentInstanceDifficulty()
	return diff == "lfr" or diff == "lfr25"
end

--Dungeons: normal, heroic. (Raids excluded)
function bossModPrototype:IsEasyDungeon()
	local diff = savedDifficulty or DBM:GetCurrentInstanceDifficulty()
	return diff == "heroic5" or diff == "normal5"
end

--Dungeons: normal, heroic. Raids: LFR, normal
function bossModPrototype:IsEasy()
	local diff = savedDifficulty or DBM:GetCurrentInstanceDifficulty()
	return diff == "normal" or diff == "lfr" or diff == "lfr25" or diff == "heroic5" or diff == "normal5"
end

--Dungeons: mythic, mythic+. Raids: heroic, mythic
function bossModPrototype:IsHard()
	local diff = savedDifficulty or DBM:GetCurrentInstanceDifficulty()
	return diff == "mythic" or diff == "challenge5" or diff == "heroic"
end

--Pretty much ANYTHING that has a normal mode
function bossModPrototype:IsNormal()
	local diff = savedDifficulty or DBM:GetCurrentInstanceDifficulty()
	return diff == "normal" or diff == "normal5" or diff == "normal10" or diff == "normal20" or diff == "normal25" or diff == "normal40" or diff == "normalisland" or diff == "normalwarfront"
end

do
	local isSeasonal
	function DBM:IsSeasonal()
		--Once set to true, we stop checking api an return cache
		--But if not set true we keep checking api because the api (or buff) will return false if called too early and we don't want to cache that
		if not isSeasonal then
			local IsClassicSeason = C_Seasons and C_Seasons.HasActiveSeason()
			if IsClassicSeason then
				isSeasonal = true
				DBM:Debug("Setting Classic seasonal to true")
			else
				isSeasonal = false
				DBM:Debug("Setting Classic seasonal to false")
			end
		end
		return isSeasonal
	end
	bossModPrototype.IsSeasonal = DBM.IsSeasonal
end

--Pretty much ANYTHING that has a heroic mode
function bossModPrototype:IsHeroic()
	local diff = savedDifficulty or DBM:GetCurrentInstanceDifficulty()
	return diff == "heroic" or diff == "heroic5" or diff == "heroic10" or diff == "heroic25" or diff == "heroicisland" or diff == "heroicwarfront"
end

--Pretty much ANYTHING that has mythic mode, with mythic+ included
function bossModPrototype:IsMythic()
	local diff = savedDifficulty or DBM:GetCurrentInstanceDifficulty()
	return diff == "mythic" or diff == "challenge5" or diff == "mythicisland"
end

function bossModPrototype:IsEvent()
	local diff = savedDifficulty or DBM:GetCurrentInstanceDifficulty()
	return diff == "event5" or diff == "event20" or diff == "event40"
end

function bossModPrototype:IsWarfront()
	local diff = savedDifficulty or DBM:GetCurrentInstanceDifficulty()
	return diff == "normalwarfront" or diff == "heroicwarfront"
end

function bossModPrototype:IsIsland()
	local diff = savedDifficulty or DBM:GetCurrentInstanceDifficulty()
	return diff == "normalisland" or diff == "heroicisland" or diff == "mythicisland"
end

function bossModPrototype:IsScenario()
	local diff = savedDifficulty or DBM:GetCurrentInstanceDifficulty()
	return diff == "normalscenario" or diff == "heroicscenario"
end

function bossModPrototype:IsValidWarning(sourceGUID, customunitID, loose)
	if loose and InCombatLockdown() and GetNumGroupMembers() < 2 then return true end--In a loose check, this basically just checks if we're in combat, important for solo runs of torghast to not gimp mod too much
	if customunitID then
		if UnitExists(customunitID) and UnitGUID(customunitID) == sourceGUID and UnitAffectingCombat(customunitID) then return true end
	else
		for uId in DBM:GetGroupMembers() do
			local target = uId.."target"
			if UnitExists(target) and UnitGUID(target) == sourceGUID and UnitAffectingCombat(target) then return true end
			local targettwo = uId.."targettarget"
			if UnitExists(targettwo) and UnitGUID(targettwo) == sourceGUID and UnitAffectingCombat(targettwo) then return true end
		end
	end
	return false
end

--force param is used when CheckInterruptFilter is actually being used for a simpe target/focus check and nothing more.
--checkCooldown should never be passed with skip or COUNT interrupt warnings. It should be passed with any other interrupt filter
function bossModPrototype:CheckInterruptFilter(sourceGUID, force, checkCooldown, ignoreTandF)
	if DBM.Options.FilterInterrupt2 == "None" and not force then return true end--user doesn't want to use interrupt filter, always return true
	--Pummel, Mind Freeze, Counterspell, Kick, Skull Bash, Rebuke, Silence, Wind Shear, Disrupt, Solar Beam, Spear Hand Strike
	local InterruptAvailable = true
	local requireCooldown = checkCooldown
	if (DBM.Options.FilterInterrupt2 == "onlyTandF") or self.isTrashMod and (DBM.Options.FilterInterrupt2 == "TandFandBossCooldown") then
		requireCooldown = false
	end
	local check = isRetail and
		((GetSpellCooldown(6552)) ~= 0 or (GetSpellCooldown(47528)) ~= 0 or (GetSpellCooldown(282151)) ~= 0 or (GetSpellCooldown(2139)) ~= 0 or (GetSpellCooldown(1766)) ~= 0 or (GetSpellCooldown(106839)) ~= 0 or (GetSpellCooldown(96231)) ~= 0 or (GetSpellCooldown(15487)) ~= 0 or (GetSpellCooldown(57994)) ~= 0 or (GetSpellCooldown(183752)) ~= 0 or (GetSpellCooldown(78675)) ~= 0 or (GetSpellCooldown(116705)) ~= 0) or
		(GetSpellCooldown(6552)) ~= 0 or (GetSpellCooldown(72)) ~= 0 or (GetSpellCooldown(2139)) ~= 0 or (GetSpellCooldown(1766)) ~= 0 or (GetSpellCooldown(15487)) ~= 0 or (GetSpellCooldown(8042)) ~= 0 or (GetSpellCooldown(8044)) ~= 0 or (GetSpellCooldown(8045)) ~= 0 or (GetSpellCooldown(8046)) ~= 0 or (GetSpellCooldown(10412)) ~= 0 or (GetSpellCooldown(10413)) ~= 0 or (GetSpellCooldown(10414)) ~= 0
	if requireCooldown and (UnitIsDeadOrGhost("player") or check) then
		InterruptAvailable = false--checkCooldown check requested and player has no spell that can interrupt available (or is dead)
	end
	local unitID = (UnitGUID("target") == sourceGUID) and "target" or isRetail and (UnitGUID("focus") == sourceGUID) and "focus"
	if InterruptAvailable and (ignoreTandF or unitID) then
		--Check if it's casting something that's not interruptable at the moment
		--needed for torghast since many mobs can have interrupt immunity with same spellIds as other mobs that can be interrupted
		if unitID then
			if UnitCastingInfo(unitID) then
				local _, _, _, _, _, _, _, notInterruptible = UnitCastingInfo(unitID)
				if notInterruptible then return false end
			elseif UnitChannelInfo(unitID) then
				local _, _, _, _, _, _, notInterruptible = UnitChannelInfo(unitID)
				if notInterruptible then return false end
			end
		end
		return true
	end
	return false
end

do
	local lastCheck, lastReturn = 0, true
	function bossModPrototype:CheckDispelFilter()
		if not DBM.Options.FilterDispel then return true end
		-- Retail - Druid: Nature's Cure (88423), Remove Corruption (2782), Monk: Detox (115450) Monk: Detox (218164), Priest: Purify (527) Priest: Purify Disease (213634), Paladin: Cleanse (4987), Shaman: Cleanse Spirit (51886), Purify Spirit (77130), Mage: Remove Curse (475), Warlock: Singe Magic (89808)
		-- Classic - Druid: Remove Curse (2782), Priest: Purify (527), Paladin: Cleanse (4987), Mage: Remove Curse (475)
		--start, duration, enable = GetSpellCooldown
		--start & duration == 0 if spell not on cd
		if UnitIsDeadOrGhost("player") then return false end--if dead, can't dispel
		if GetTime() - lastCheck < 0.1 then--Recently returned status, return same status to save cpu from aggressive api checks caused by CheckDispelFilter running on multiple raid members getting debuffed at once
			return lastReturn
		end
		local check = isRetail and
			((GetSpellCooldown(88423)) ~= 0 or (GetSpellCooldown(2782)) ~= 0 or (GetSpellCooldown(115450)) ~= 0 or (GetSpellCooldown(218164)) ~= 0 or (GetSpellCooldown(527)) ~= 0 or (GetSpellCooldown(213634)) ~= 0 or (GetSpellCooldown(4987)) ~= 0 or (GetSpellCooldown(51886)) ~= 0 or (GetSpellCooldown(77130)) ~= 0 or (GetSpellCooldown(475)) ~= 0 or (GetSpellCooldown(89808)) ~= 0) or
			(GetSpellCooldown(2782)) ~= 0 or (GetSpellCooldown(527)) ~= 0 or (GetSpellCooldown(4987)) ~= 0 or (GetSpellCooldown(475)) ~= 0
		if check then
			lastCheck = GetTime()
			lastReturn = false
			return false
		end
		lastCheck = GetTime()
		lastReturn = true
		return true
	end
end

function bossModPrototype:IsCriteriaCompleted(criteriaIDToCheck)
	if not isRetail then
		print("bossModPrototype:IsCriteriaCompleted should not be called in classic, report this message")
		return false
	end
	if not criteriaIDToCheck then
		error("usage: mod:IsCriteriaComplected(criteriaId)")
		return false
	end
	local _, _, numCriteria = C_Scenario.GetStepInfo()
	for i = 1, numCriteria do
		local _, _, criteriaCompleted, _, _, _, _, _, criteriaID = C_Scenario.GetCriteriaInfo(i)
		if criteriaID == criteriaIDToCheck and criteriaCompleted then
			return true
		end
	end
	return false
end

function bossModPrototype:LatencyCheck(custom)
	return select(4, GetNetStats()) < (custom or DBM.Options.LatencyThreshold)
end

function bossModPrototype:CheckBigWigs(name)
	if raid[name] and raid[name].bwversion then
		return raid[name].bwversion
	else
		return false
	end
end

bossModPrototype.IconNumToString = DBM.IconNumToString
bossModPrototype.IconNumToTexture = DBM.IconNumToTexture
bossModPrototype.AntiSpam = DBM.AntiSpam
bossModPrototype.HasMapRestrictions = DBM.HasMapRestrictions
bossModPrototype.GetUnitCreatureId = DBM.GetUnitCreatureId
bossModPrototype.GetCIDFromGUID = DBM.GetCIDFromGUID
bossModPrototype.IsCreatureGUID = DBM.IsCreatureGUID
bossModPrototype.GetUnitIdFromGUID = DBM.GetUnitIdFromGUID
bossModPrototype.CheckNearby = DBM.CheckNearby
bossModPrototype.IsTrivial = DBM.IsTrivial

do
	local TargetScanning = private:GetModule("TargetScanning")

	function bossModPrototype:GetBossTarget(...)
		return TargetScanning:GetBossTarget(self, ...)
	end

	function bossModPrototype:BossTargetScannerAbort(...)
		return TargetScanning:BossTargetScannerAbort(self, ...)
	end

	function bossModPrototype:BossUnitTargetScannerAbort(...)
		return TargetScanning:BossUnitTargetScannerAbort(self, ...)
	end

	function bossModPrototype:BossUnitTargetScanner(...)
		return TargetScanning:BossUnitTargetScanner(self, ...)
	end

	function bossModPrototype:BossTargetScanner(...)
		return TargetScanning:BossTargetScanner(self, ...)
	end

	function bossModPrototype:StartRepeatedScan(...)
		return TargetScanning:StartRepeatedScan(self, ...)
	end

	function bossModPrototype:StopRepeatedScan(...)
		return TargetScanning:StopRepeatedScan(...)--self/bossModPrototype missing not a bug, function doesn't need it
	end
end

do
	local bossCache = {}
	local lastTank

	function bossModPrototype:GetCurrentTank(cidOrGuid)
		if lastTank and GetTime() - (bossCache[cidOrGuid] or 0) < 2 then -- return last tank within 2 seconds of call
			return lastTank
		else
			cidOrGuid = cidOrGuid or self.creatureId--GetBossTarget supports GUID or CID and it will automatically return correct values with EITHER ONE
			local uId
			local _, fallbackuId, mobuId = self:GetBossTarget(cidOrGuid)
			if mobuId then--Have a valid mob unit ID
				--First, use trust threat more than fallbackuId and see what we pull from it first.
				--This is because for GetCurrentTank we want to know who is tanking it, not who it's targeting.
				local unitId = (IsInRaid() and "raid") or "party"
				for i = 0, GetNumGroupMembers() do
					local id = (i == 0 and "target") or unitId..i
					local tanking, status = UnitDetailedThreatSituation(id, mobuId)--Tanking may return 0 if npc is temporarily looking at an NPC (IE fracture) but status will still be 3 on true tank
					if tanking or (status == 3) then uId = id end--Found highest threat target, make them uId
					if uId then break end
				end
				--Did not get anything useful from threat, so use who the boss was looking at, at time of cast (ie fallbackuId)
				if fallbackuId and not uId then
					uId = fallbackuId
				end
			end
			if uId then--Now we have a valid uId
				bossCache[cidOrGuid] = GetTime()
				lastTank = UnitName(uId)
				return UnitName(lastTank), uId
			end
			return false
		end
	end
end

--Now this function works perfectly. But have some limitation due to DBM.RangeCheck:GetDistance() function.
--Unfortunely, DBM.RangeCheck:GetDistance() function cannot reflects altitude difference. This makes range unreliable.
--So, we need to cafefully check range in difference altitude (Especially, tower top and bottom)
do
	local rangeCache = {}
	local rangeUpdated = {}

	function bossModPrototype:CheckBossDistance(cidOrGuid, onlyBoss, itemId, distance, defaultReturn)
		if not DBM.Options.DontShowFarWarnings then return true end--Global disable.
		cidOrGuid = cidOrGuid or self.creatureId
		local uId = DBM:GetUnitIdFromGUID(cidOrGuid, onlyBoss)
		if uId then
			itemId = itemId or 32698
			local inRange = IsItemInRange(itemId, uId)
			if inRange then--IsItemInRange was a success
				return inRange
			else--IsItemInRange doesn't work on all bosses/npcs, but tank checks do
				DBM:Debug("CheckBossDistance failed on IsItemInRange for: "..cidOrGuid, 2)
				return self:CheckTankDistance(cidOrGuid, distance, onlyBoss, defaultReturn)--Return tank distance check fallback
			end
		end
		DBM:Debug("CheckBossDistance failed on uId for: "..cidOrGuid, 2)
		return (defaultReturn == nil) or defaultReturn--When we simply can't figure anything out, return true and allow warnings using this filter to fire
	end

	function bossModPrototype:CheckTankDistance(cidOrGuid, distance, onlyBoss, defaultReturn)
		if not DBM.Options.DontShowFarWarnings then return true end--Global disable.
		distance = distance or 43
		if rangeCache[cidOrGuid] and (GetTime() - (rangeUpdated[cidOrGuid] or 0)) < 2 then -- return same range within 2 sec call
			return rangeCache[cidOrGuid] < distance
		else
			cidOrGuid = cidOrGuid or self.creatureId--GetBossTarget supports GUID or CID and it will automatically return correct values with EITHER ONE
			local uId
			local _, fallbackuId, mobuId = self:GetBossTarget(cidOrGuid, onlyBoss)
			if mobuId then--Have a valid mob unit ID
				--First, use trust threat more than fallbackuId and see what we pull from it first.
				--This is because for CheckTankDistance we want to know who is tanking it, not who it's targeting.
				local unitId = (IsInRaid() and "raid") or "party"
				for i = 0, GetNumGroupMembers() do
					local id = (i == 0 and "target") or unitId..i
					local tanking, status = UnitDetailedThreatSituation(id, mobuId)--Tanking may return 0 if npc is temporarily looking at an NPC (IE fracture) but status will still be 3 on true tank
					if tanking or (status == 3) then uId = id end--Found highest threat target, make them uId
					if uId then break end
				end
				--Did not get anything useful from threat, so use who the boss was looking at, at time of cast (ie fallbackuId)
				if fallbackuId and not uId then
					uId = fallbackuId
				end
			end
			if uId then--Now we have a valid uId
				if UnitIsUnit(uId, "player") then return true end--If "player" is target, avoid doing any complicated stuff
				if not UnitIsPlayer(uId) then
					local inRange2, checkedRange = UnitInRange(uId)--43
					if checkedRange then--checkedRange only returns true if api worked, so if we get false, true then we are not near npc
						return inRange2
					else--Its probably a totem or just something we can't assess. Fall back to no filtering
						return true
					end
				end
				local inRange = DBM.RangeCheck:GetDistance("player", uId)--We check how far we are from the tank who has that boss
				rangeCache[cidOrGuid] = inRange
				rangeUpdated[cidOrGuid] = GetTime()
				if inRange and (inRange > distance) then--You are not near the person tanking boss
					return false
				end
				--Tank in range, return true.
				return true
			end
			DBM:Debug("CheckTankDistance failed on uId for: "..cidOrGuid, 2)
			return (defaultReturn == nil) or defaultReturn--When we simply can't figure anything out, return true and allow warnings using this filter to fire. But some spells will prefer not to fire(i.e : Galakras tower spell), we can define it on this function calling.
		end
	end
end

---------------------
--  Class Methods  --
---------------------
do
	--[[function bossModPrototype:GetRoleFlagValue(flag)
		if not flag then return false end
		local flags = {strsplit("|", flag)}
		for i = 1, #flags do
			local flagText = flags[i]
			flagText = flagText:gsub("-", "")
			if not specFlags[flagText] then
				print("bad flag found : "..flagText)
			end
		end
		self:GetRoleFlagValue2(flag)
	end]]

	--to check flag is correct, remove comment block specFlags table and GetRoleFlagValue function, change this to GetRoleFlagValue2
	--disable flag check normally because double flag check comsumes more cpu on mod load.
	function bossModPrototype:GetRoleFlagValue(flag)
		if not flag then return false end
		if not currentSpecID then
			DBM:SetCurrentSpecInfo()
		end
		local flags = {strsplit("|", flag)}
		for i = 1, #flags do
			local flagText = flags[i]
			if flagText:match("^-") then
				flagText = flagText:gsub("-", "")
				if not private.specRoleTable[currentSpecID][flagText] then
					return true
				end
			elseif private.specRoleTable[currentSpecID][flagText] then
				return true
			end
		end
		return false
	end

	function bossModPrototype:IsMeleeDps(uId)
		if uId then--This version includes ONLY melee dps
			local role = UnitGroupRolesAssigned(uId)
			if isRetail and (role == "HEALER" or role == "TANK") or GetPartyAssignment("MAINTANK", uId, 1) then--Auto filter healer/tank from dps check, can't filter healers in classic
				return false
			end
			local _, class = UnitClass(uId)
			if class == "WARRIOR" or class == "ROGUE" or class == "DEATHKNIGHT" or class == "DEMONHUNTER" then
				return true
			end
			--Inspect throttle exists, so have to do it this way
			if class == "DRUID" or class == "SHAMAN" or class == "PALADIN" or class == "MONK" then
				local unitMaxPower = UnitPowerMax(uId)
				if not isRetail and unitMaxPower < 7500 then
					return true
				end
				local powerType = UnitPowerType(uId)
				local altPowerType = UnitPower(uId, 8)--Additional check for balance druids shapeshifted into bear/cat but may still have > 0 lunar power
				--Healers all have 50k mana at 60, dps have 10k mana, plus healers still filtered by role check too
				--Tanks are already filtered out by role check
				--Maelstrom and Lunar power filtered out because they'd also return less than 11000 power (they'd both be 100)
				--feral druids, enhance shamans, windwalker monks, ret paladins should all be caught by less than 11000 power checks after filters
				if powerType ~= 11 and powerType ~= 8 and altPowerType == 0 and unitMaxPower < 11000 then--Maelstrom and Lunar power filters
					return true
				end
			end
			return false
		end
		if not currentSpecID then
			DBM:SetCurrentSpecInfo()
		end
		return private.specRoleTable[currentSpecID]["MeleeDps"]
	end

	function bossModPrototype:IsMelee(uId, mechanical)--mechanical arg means the check is asking if boss mechanics consider them melee (even if they aren't, such as holy paladin/mistweaver monks)
		if uId then--This version includes monk healers as melee and tanks as melee
			local _, class = UnitClass(uId)
			--In mechanical check, ALL paladins are melee so don't need anything fancy, as for rest of classes here, same deal
			if class == "WARRIOR" or class == "ROGUE" or class == "DEATHKNIGHT" or class == "MONK" or class == "DEMONHUNTER" or (mechanical and class == "PALADIN") then
				return true
			end
			--Inspect throttle exists, so have to do it this way
			if (class == "DRUID" or class == "SHAMAN" or class == "PALADIN") then
				local unitMaxPower = UnitPowerMax(uId)
				if not isRetail and unitMaxPower < 7500 then
					return true
				end
				local powerType = UnitPowerType(uId)
				local altPowerType = UnitPower(uId, 8)--Additional check for balance druids shapeshifted into bear/cat but may still have > 0 lunar power
				--Hunters are now all flagged ranged because it's no longer possible to tell a survival hunter from marksman. neither will be using a pet and both have 100 focus.
				--Druids without lunar poewr or 50k mana are either feral or guardian
				--Shamans without maelstrom and 50k mana can only be enhancement
				--Paladins without 50k mana can only be prot or ret
				if powerType ~= 11 and powerType ~= 8 and altPowerType == 0 and unitMaxPower < 11000 then--Maelstrom and Lunar power filters
					return true
				end
			end
			return false
		end
		if not currentSpecID then
			DBM:SetCurrentSpecInfo()
		end
		return private.specRoleTable[currentSpecID]["Melee"]
	end

	function bossModPrototype:IsRanged()
		if not currentSpecID then
			DBM:SetCurrentSpecInfo()
		end
		return private.specRoleTable[currentSpecID]["Ranged"]
	end

	function bossModPrototype:IsSpellCaster()
		if not currentSpecID then
			DBM:SetCurrentSpecInfo()
		end
		return private.specRoleTable[currentSpecID]["SpellCaster"]
	end

	function bossModPrototype:IsMagicDispeller()
		if not currentSpecID then
			DBM:SetCurrentSpecInfo()
		end
		return private.specRoleTable[currentSpecID]["MagicDispeller"]
	end
end

function bossModPrototype:UnitClass(uId)
	if uId then--Return unit requested
		local _, class = UnitClass(uId)
		return class
	end
	return playerClass--else return "player"
end

-- if we catch someone in a tank stance keep sending them warnings, classic only
local playerIsTank = false

function bossModPrototype:IsTank()
	--IsTanking already handles external calls, no need here.
	if not currentSpecID then
		DBM:SetCurrentSpecInfo()
	end
	if not isRetail then
		if private.specRoleTable[currentSpecID]["Tank"] then
			-- 17 defensive stance, 5487 bear form, 9634 dire bear, 25780 righteous fury
			if playerIsTank or GetShapeshiftFormID() == 18 or DBM:UnitBuff('player', 5487, 9634) then
				playerIsTank = true
				return true
			end
		end
		return false
	end
	local _, _, _, _, role = GetSpecializationInfoByID(currentSpecID)
	return role == "TANK"
end

function bossModPrototype:IsDps(uId)
	if uId then--External unit call.
		return isRetail and UnitGroupRolesAssigned(uId) == "DAMAGER" or not GetPartyAssignment("MAINTANK", uId, 1)
	end
	if not currentSpecID then
		DBM:SetCurrentSpecInfo()
	end
	if not isRetail then
		return private.specRoleTable[currentSpecID]["Dps"]
	end
	local _, _, _, _, role = GetSpecializationInfoByID(currentSpecID)
	return role == "DAMAGER"
end

function bossModPrototype:IsHealer(uId)
	if uId then--External unit call.
		if not isRetail then
			print("bossModPrototype:IsHealer should not be called in classic, report this message")
			return false
		end
		return UnitGroupRolesAssigned(uId) == "HEALER"
	end
	if not currentSpecID then
		DBM:SetCurrentSpecInfo()
	end
	if not isRetail then
		if private.specRoleTable[currentSpecID]["Healer"] then
			if playerClass == "DRUID" then
				-- not in form (moonkin for balance, cat/bear for ferals)
				return GetShapeshiftFormID() == nil
			end
			return true
		end
		return false
	end
	local _, _, _, _, role = GetSpecializationInfoByID(currentSpecID)
	return role == "HEALER"
end

function bossModPrototype:IsTanking(unit, boss, isName, onlyRequested, bossGUID, includeTarget)
	if isName then--Passed combat log name, so pull unit ID
		unit = DBM:GetRaidUnitId(unit)
	end
	if not unit then
		DBM:Debug("IsTanking passed with invalid unit", 2)
		return false
	end
	--Prefer threat target first
	if boss then--Only checking one bossID as requested
		--Check threat first
		local tanking, status = UnitDetailedThreatSituation(unit, boss)
		if tanking or (status == 3) then
			return true
		end
		--Non threat fallback
		if includeTarget and UnitExists(boss) then
			local guid = UnitGUID(boss)
			local _, targetuid = self:GetBossTarget(guid, true)
			if UnitIsUnit(unit, targetuid) then
				return true
			end
		end
	else--Check all of them if one isn't defined
		for i = 1, 5 do
			local unitID = "boss"..i
			local guid = UnitGUID(unitID)
			--No GUID, any unit having threat returns true, GUID, only specific unit matching guid
			if not bossGUID or (guid and guid == bossGUID) then
				--Check threat first
				local tanking, status = UnitDetailedThreatSituation(unit, unitID)
				if tanking or (status == 3) then
					return true
				end
				--Non threat fallback
				if includeTarget and UnitExists(unitID) then
					local _, targetuid = self:GetBossTarget(guid, true)
					if UnitIsUnit(unit, targetuid) then
						return true
					end
				end
			end
		end
		--Check group targets if no boss unitIDs found and bossGUID passed.
		--This allows IsTanking to be used in situations boss UnitIds don't exist
		if bossGUID then
			local groupType = (IsInRaid() and "raid") or "party"
			for i = 0, GetNumGroupMembers() do
				local unitID = (i == 0 and "target") or groupType..i.."target"
				local guid = UnitGUID(unitID)
				if guid and guid == bossGUID then
					--Check threat first
					local tanking, status = UnitDetailedThreatSituation(unit, unitID)
					if tanking or (status == 3) then
						return true
					end
					--Non threat fallback
					if includeTarget and UnitExists(unitID) then
						local _, targetuid = self:GetBossTarget(guid, true)
						if UnitIsUnit(unit, targetuid) then
							return true
						end
					end
				end
			end
		end
	end
	if not onlyRequested then
		--Use these as fallback if threat target not found
		if GetPartyAssignment("MAINTANK", unit, 1) then
			return true
		end
		if isRetail and UnitGroupRolesAssigned(unit) == "TANK" then
			return true
		end
	end
	return false
end

function bossModPrototype:GetNumAliveTanks()
	if not IsInGroup() then return 1 end--Solo raid, you're the "tank"
	local count = 0
	local uId = (IsInRaid() and "raid") or "party"
	for i = 1, DBM:GetNumRealGroupMembers() do
		if (isRetail and UnitGroupRolesAssigned(uId..i) == "TANK" or GetPartyAssignment("MAINTANK", uId..i, 1)) and not UnitIsDeadOrGhost(uId..i) then
			count = count + 1
		end
	end
	return count
end

----------------------------
--  Boss Health Function  --
----------------------------
function DBM:GetBossHP(cIdOrGUID, onlyHighest)
	local uId = bossHealthuIdCache[cIdOrGUID] or "target"
	local guid = UnitGUID(uId)
	--Target or Cached (if already called with this cid or GUID before)
	if (self:GetCIDFromGUID(guid) == cIdOrGUID or guid == cIdOrGUID) and UnitHealthMax(uId) ~= 0 then
		if bossHealth[cIdOrGUID] and (UnitHealth(uId) == 0 and not UnitIsDead(uId)) then return bossHealth[cIdOrGUID], uId, UnitName(uId) end--Return last non 0 value if value is 0, since it's last valid value we had.
		local hp = UnitHealth(uId) / UnitHealthMax(uId) * 100
		if not onlyHighest or onlyHighest and hp > (bossHealth[cIdOrGUID] or 0) then
			bossHealth[cIdOrGUID] = hp
		end
		return hp, uId, UnitName(uId)
	--Focus, does not exist in classic
	elseif isRetail and ((self:GetCIDFromGUID(UnitGUID("focus")) == cIdOrGUID or UnitGUID("focus") == cIdOrGUID) and UnitHealthMax("focus") ~= 0) then
		if bossHealth[cIdOrGUID] and (UnitHealth("focus") == 0 and not UnitIsDead("focus")) then return bossHealth[cIdOrGUID], "focus", UnitName("focus") end--Return last non 0 value if value is 0, since it's last valid value we had.
		local hp = UnitHealth("focus") / UnitHealthMax("focus") * 100
		if not onlyHighest or onlyHighest and hp > (bossHealth[cIdOrGUID] or 0) then
			bossHealth[cIdOrGUID] = hp
		end
		return hp, "focus", UnitName("focus")
	else
		--Boss UnitIds
		if isRetail then
			for i = 1, 5 do
				local unitID = "boss"..i
				local bossguid = UnitGUID(unitID)
				if (self:GetCIDFromGUID(bossguid) == cIdOrGUID or bossguid == cIdOrGUID) and UnitHealthMax(unitID) ~= 0 then
					if bossHealth[cIdOrGUID] and (UnitHealth(unitID) == 0 and not UnitIsDead(unitID)) then return bossHealth[cIdOrGUID], unitID, UnitName(unitID) end--Return last non 0 value if value is 0, since it's last valid value we had.
					local hp = UnitHealth(unitID) / UnitHealthMax(unitID) * 100
					if not onlyHighest or onlyHighest and hp > (bossHealth[cIdOrGUID] or 0) then
						bossHealth[cIdOrGUID] = hp
					end
					bossHealthuIdCache[cIdOrGUID] = unitID
					return hp, unitID, UnitName(unitID)
				end
			end
		end
		--Scan raid/party target frames
		local idType = (IsInRaid() and "raid") or "party"
		for i = 0, GetNumGroupMembers() do
			local unitId = ((i == 0) and "target") or idType..i.."target"
			local bossguid = UnitGUID(unitId)
			if (self:GetCIDFromGUID(bossguid) == cIdOrGUID or bossguid == cIdOrGUID) and UnitHealthMax(unitId) ~= 0 then
				if bossHealth[cIdOrGUID] and (UnitHealth(unitId) == 0 and not UnitIsDead(unitId)) then return bossHealth[cIdOrGUID], unitId, UnitName(unitId) end--Return last non 0 value if value is 0, since it's last valid value we had.
				local hp = UnitHealth(unitId) / UnitHealthMax(unitId) * 100
				if not onlyHighest or onlyHighest and hp > (bossHealth[cIdOrGUID] or 0) then
					bossHealth[cIdOrGUID] = hp
				end
				bossHealthuIdCache[cIdOrGUID] = unitId
				return hp, unitId, UnitName(unitId)
			end
		end
	end
end

function DBM:GetBossHPByUnitID(uId)
	if UnitHealthMax(uId) ~= 0 then
		local hp = UnitHealth(uId) / UnitHealthMax(uId) * 100
		bossHealth[uId] = hp
		return hp, uId, UnitName(uId)
	end
end

function bossModPrototype:SetMainBossID(cid)
	self.mainBoss = cid
end

function bossModPrototype:SetBossHPInfoToHighest(numBoss)
	if numBoss ~= false then
		self.numBoss = numBoss or (self.multiMobPullDetection and #self.multiMobPullDetection)
	end
	self.highesthealth = true
end

function bossModPrototype:GetHighestBossHealth()
	local hp
	if not self.multiMobPullDetection or self.mainBoss then
		hp = bossHealth[self.mainBoss or self.combatInfo.mob or -1]
		if hp and (hp > 100 or hp <= 0) then
			hp = nil
		end
	else
		for _, mob in ipairs(self.multiMobPullDetection) do
			if (bossHealth[mob] or 0) > (hp or 0) and (bossHealth[mob] or 0) < 100 then-- ignore full health.
				hp = bossHealth[mob]
			end
		end
	end
	return hp
end

function bossModPrototype:GetLowestBossHealth()
	local hp
	if not self.multiMobPullDetection or self.mainBoss then
		hp = bossHealth[self.mainBoss or self.combatInfo.mob or -1]
		if hp and (hp > 100 or hp <= 0) then
			hp = nil
		end
	else
		for _, mob in ipairs(self.multiMobPullDetection) do
			if (bossHealth[mob] or 100) < (hp or 100) and (bossHealth[mob] or 100) > 0 then-- ignore zero health.
				hp = bossHealth[mob]
			end
		end
	end
	return hp
end

bossModPrototype.GetBossHP = DBM.GetBossHP

-----------------------
--  Announce Object  --
-----------------------
do
	local frame = CreateFrame("Frame", "DBMWarning", UIParent)
	local font1u = CreateFrame("Frame", "DBMWarning1Updater", UIParent)
	local font2u = CreateFrame("Frame", "DBMWarning2Updater", UIParent)
	local font3u = CreateFrame("Frame", "DBMWarning3Updater", UIParent)
	local font1 = frame:CreateFontString("DBMWarning1", "OVERLAY", "GameFontNormal")
	font1:SetWidth(1024)
	font1:SetHeight(0)
	font1:SetPoint("TOP", 0, 0)
	local font2 = frame:CreateFontString("DBMWarning2", "OVERLAY", "GameFontNormal")
	font2:SetWidth(1024)
	font2:SetHeight(0)
	font2:SetPoint("TOP", font1, "BOTTOM", 0, 0)
	local font3 = frame:CreateFontString("DBMWarning3", "OVERLAY", "GameFontNormal")
	font3:SetWidth(1024)
	font3:SetHeight(0)
	font3:SetPoint("TOP", font2, "BOTTOM", 0, 0)
	frame:SetMovable(1)
	frame:SetWidth(1)
	frame:SetHeight(1)
	frame:SetFrameStrata("HIGH")
	frame:SetClampedToScreen()
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 300)
	font1u:Hide()
	font2u:Hide()
	font3u:Hide()

	local font1elapsed, font2elapsed, font3elapsed

	local function fontHide1()
		local duration = DBM.Options.WarningDuration2
		if font1elapsed > duration * 1.3 then
			font1u:Hide()
			font1:Hide()
			if frame.font1ticker then
				frame.font1ticker:Cancel()
				frame.font1ticker = nil
			end
		elseif font1elapsed > duration then
			font1elapsed = font1elapsed + 0.05
			local alpha = 1 - (font1elapsed - duration) / (duration * 0.3)
			font1:SetAlpha(alpha > 0 and alpha or 0)
		else
			font1elapsed = font1elapsed + 0.05
			font1:SetAlpha(1)
		end
	end

	local function fontHide2()
		local duration = DBM.Options.WarningDuration2
		if font2elapsed > duration * 1.3 then
			font2u:Hide()
			font2:Hide()
			if frame.font2ticker then
				frame.font2ticker:Cancel()
				frame.font2ticker = nil
			end
		elseif font2elapsed > duration then
			font2elapsed = font2elapsed + 0.05
			local alpha = 1 - (font2elapsed - duration) / (duration * 0.3)
			font2:SetAlpha(alpha > 0 and alpha or 0)
		else
			font2elapsed = font2elapsed + 0.05
			font2:SetAlpha(1)
		end
	end

	local function fontHide3()
		local duration = DBM.Options.WarningDuration2
		if font3elapsed > duration * 1.3 then
			font3u:Hide()
			font3:Hide()
			if frame.font3ticker then
				frame.font3ticker:Cancel()
				frame.font3ticker = nil
			end
		elseif font3elapsed > duration then
			font3elapsed = font3elapsed + 0.05
			local alpha = 1 - (font3elapsed - duration) / (duration * 0.3)
			font3:SetAlpha(alpha > 0 and alpha or 0)
		else
			font3elapsed = font3elapsed + 0.05
			font3:SetAlpha(1)
		end
	end

	font1u:SetScript("OnUpdate", function(self)
		local diff = GetTime() - font1.lastUpdate
		local origSize = DBM.Options.WarningFontSize
		if diff > 0.4 then
			font1:SetTextHeight(origSize)
			self:Hide()
		elseif diff > 0.2 then
			font1:SetTextHeight(origSize * (1.5 - (diff-0.2) * 2.5))
		else
			font1:SetTextHeight(origSize * (1 + diff * 2.5))
		end
	end)

	font2u:SetScript("OnUpdate", function(self)
		local diff = GetTime() - font2.lastUpdate
		local origSize = DBM.Options.WarningFontSize
		if diff > 0.4 then
			font2:SetTextHeight(origSize)
			self:Hide()
		elseif diff > 0.2 then
			font2:SetTextHeight(origSize * (1.5 - (diff-0.2) * 2.5))
		else
			font2:SetTextHeight(origSize * (1 + diff * 2.5))
		end
	end)

	font3u:SetScript("OnUpdate", function(self)
		local diff = GetTime() - font3.lastUpdate
		local origSize = DBM.Options.WarningFontSize
		if diff > 0.4 then
			font3:SetTextHeight(origSize)
			self:Hide()
		elseif diff > 0.2 then
			font3:SetTextHeight(origSize * (1.5 - (diff-0.2) * 2.5))
		else
			font3:SetTextHeight(origSize * (1 + diff * 2.5))
		end
	end)

	function DBM:UpdateWarningOptions()
		frame:ClearAllPoints()
		frame:SetPoint(self.Options.WarningPoint, UIParent, self.Options.WarningPoint, self.Options.WarningX, self.Options.WarningY)
		local font = self.Options.WarningFont == "standardFont" and standardFont or self.Options.WarningFont
		font1:SetFont(font, self.Options.WarningFontSize, self.Options.WarningFontStyle == "None" and nil or self.Options.WarningFontStyle)
		font2:SetFont(font, self.Options.WarningFontSize, self.Options.WarningFontStyle == "None" and nil or self.Options.WarningFontStyle)
		font3:SetFont(font, self.Options.WarningFontSize, self.Options.WarningFontStyle == "None" and nil or self.Options.WarningFontStyle)
		if self.Options.WarningFontShadow then
			font1:SetShadowOffset(1, -1)
			font2:SetShadowOffset(1, -1)
			font3:SetShadowOffset(1, -1)
		else
			font1:SetShadowOffset(0, 0)
			font2:SetShadowOffset(0, 0)
			font3:SetShadowOffset(0, 0)
		end
	end

	function DBM:AddWarning(text, force)
		local added = false
		if not frame.font1ticker then
			font1elapsed = 0
			font1.lastUpdate = GetTime()
			font1:SetText(text)
			font1:Show()
			font1u:Show()
			added = true
			frame.font1ticker = frame.font1ticker or C_TimerNewTicker(0.05, fontHide1)
		elseif not frame.font2ticker then
			font2elapsed = 0
			font2.lastUpdate = GetTime()
			font2:SetText(text)
			font2:Show()
			font2u:Show()
			added = true
			frame.font2ticker = frame.font2ticker or C_TimerNewTicker(0.05, fontHide2)
		elseif not frame.font3ticker or force then
			font3elapsed = 0
			font3.lastUpdate = GetTime()
			font3:SetText(text)
			font3:Show()
			font3u:Show()
			fontHide3()
			added = true
			frame.font3ticker = frame.font3ticker or C_TimerNewTicker(0.05, fontHide3)
		end
		if not added then
			local prevText1 = font2:GetText()
			local prevText2 = font3:GetText()
			font1:SetText(prevText1)
			font1elapsed = font2elapsed
			font2:SetText(prevText2)
			font2elapsed = font3elapsed
			self:AddWarning(text, true)
		end
	end

	do
		local anchorFrame
		local function moveEnd(self)
			anchorFrame:Hide()
			if anchorFrame.ticker then
				anchorFrame.ticker:Cancel()
				anchorFrame.ticker = nil
			end
			font1elapsed = self.Options.WarningDuration2
			font2elapsed = self.Options.WarningDuration2
			font3elapsed = self.Options.WarningDuration2
			frame:SetFrameStrata("HIGH")
			self:Unschedule(moveEnd)
			DBT:CancelBar(L.MOVE_WARNING_BAR)
		end

		function DBM:MoveWarning()
			if not anchorFrame then
				anchorFrame = CreateFrame("Frame", nil, frame)
				anchorFrame:SetWidth(32)
				anchorFrame:SetHeight(32)
				anchorFrame:EnableMouse(true)
				anchorFrame:SetPoint("TOP", frame, "TOP", 0, 32)
				anchorFrame:RegisterForDrag("LeftButton")
				anchorFrame:SetClampedToScreen()
				anchorFrame:Hide()
				local texture = anchorFrame:CreateTexture()
				texture:SetTexture("Interface\\Addons\\DBM-Core\\textures\\dot.blp")
				texture:SetPoint("CENTER", anchorFrame, "CENTER", 0, 0)
				texture:SetWidth(32)
				texture:SetHeight(32)
				anchorFrame:SetScript("OnDragStart", function()
					frame:StartMoving()
					self:Unschedule(moveEnd)
					DBT:CancelBar(L.MOVE_WARNING_BAR)
				end)
				anchorFrame:SetScript("OnDragStop", function()
					frame:StopMovingOrSizing()
					local point, _, _, xOfs, yOfs = frame:GetPoint(1)
					self.Options.WarningPoint = point
					self.Options.WarningX = xOfs
					self.Options.WarningY = yOfs
					self:Schedule(15, moveEnd, self)
					DBT:CreateBar(15, L.MOVE_WARNING_BAR, isRetail and 237538 or 136106)
				end)
			end
			if anchorFrame:IsShown() then
				moveEnd(self)
			else
				anchorFrame:Show()
				anchorFrame.ticker = anchorFrame.ticker or C_TimerNewTicker(5, function() self:AddWarning(L.MOVE_WARNING_MESSAGE) end)
				self:AddWarning(L.MOVE_WARNING_MESSAGE)
				self:Schedule(15, moveEnd, self)
				DBT:CreateBar(15, L.MOVE_WARNING_BAR, isRetail and 237538 or 136106)
				frame:Show()
				frame:SetFrameStrata("TOOLTIP")
				frame:SetAlpha(1)
			end
		end
	end

	local textureCode = " |T%s:12:12|t "
	local textureExp = " |T(%S+......%S+):12:12|t "--Fix texture file including blank not strips(example: Interface\\Icons\\Spell_Frost_Ring of Frost). But this have limitations. Since I'm poor at regular expressions, this is not good fix. Do you have another good regular expression, tandanu?
	local announcePrototype = {}
	local mt = {__index = announcePrototype}

	-- TODO: is there a good reason that this is a weak table?
	local cachedColorFunctions = setmetatable({}, {__mode = "kv"})

	local function setText(announceType, spellId, castTime, preWarnTime)
		local spellName
		if type(spellId) == "string" and spellId:match("ej%d+") then
			spellId = string.sub(spellId, 3)
			spellName = DBM:EJ_GetSectionInfo(spellId) or CL.UNKNOWN
		else
			spellName = (spellId or 0) >= 6 and DBM:GetSpellInfo(spellId) or CL.UNKNOWN
		end
		local text
		if announceType == "cast" then
			local spellHaste = select(4, DBM:GetSpellInfo(10059)) / 10000 -- 10059 = Stormwind Portal, should have 10000 ms cast time
			local timer = (select(4, DBM:GetSpellInfo(spellId)) or 1000) / spellHaste
			text = L.AUTO_ANNOUNCE_TEXTS[announceType]:format(spellName, castTime or (timer / 1000))
		elseif announceType == "prewarn" then
			if type(preWarnTime) == "string" then
				text = L.AUTO_ANNOUNCE_TEXTS[announceType]:format(spellName, preWarnTime)
			else
				text = L.AUTO_ANNOUNCE_TEXTS[announceType]:format(spellName, L.SEC_FMT:format(tostring(preWarnTime or 5)))
			end
		elseif announceType == "stage" or announceType == "prestage" then
			text = L.AUTO_ANNOUNCE_TEXTS[announceType]:format(tostring(spellId))
		elseif announceType == "stagechange" then
			text = L.AUTO_ANNOUNCE_TEXTS.spell
		else
			text = L.AUTO_ANNOUNCE_TEXTS[announceType]:format(spellName)
		end
		return text, spellName
	end

	-- TODO: this function is an abomination, it needs to be rewritten. Also: check if these work-arounds are still necessary
	function announcePrototype:Show(...) -- todo: reduce amount of unneeded strings
		if not self.option or self.mod.Options[self.option] then
			if DBM.Options.DontShowBossAnnounces then return end	-- don't show the announces if the spam filter option is set
			if DBM.Options.DontShowTargetAnnouncements and (self.announceType == "target" or self.announceType == "targetcount") and not self.noFilter then return end--don't show announces that are generic target announces
			local argTable = {...}
			local colorCode = ("|cff%.2x%.2x%.2x"):format(self.color.r * 255, self.color.g * 255, self.color.b * 255)
			if #self.combinedtext > 0 then
				--Throttle spam.
				if DBM.Options.WarningAlphabetical then
					tsort(self.combinedtext)
				end
				local combinedText = tconcat(self.combinedtext, "<, >")
				if self.combinedcount == 1 then
					combinedText = combinedText.." "..L.GENERIC_WARNING_OTHERS
				elseif self.combinedcount > 1 then
					combinedText = combinedText.." "..L.GENERIC_WARNING_OTHERS2:format(self.combinedcount)
				end
				--Process
				for i = 1, #argTable do
					if type(argTable[i]) == "string" then
						argTable[i] = combinedText
					end
				end
			end
			local message = pformat(self.text, unpack(argTable))
			local text = ("%s%s%s|r%s"):format(
				(DBM.Options.WarningIconLeft and self.icon and textureCode:format(self.icon)) or "",
				colorCode,
				message,
				(DBM.Options.WarningIconRight and self.icon and textureCode:format(self.icon)) or ""
			)
			self.combinedcount = 0
			self.combinedtext = {}
			if not cachedColorFunctions[self.color] then
				local color = self.color -- upvalue for the function to colorize names, accessing self in the colorize closure is not safe as the color of the announce object might change (it would also prevent the announce from being garbage-collected but announce objects are never destroyed)
				cachedColorFunctions[color] = function(cap)
					cap = cap:sub(2, -2)
					local noStrip = cap:match("noStrip ")
					if not noStrip then
						local name = cap
						local playerClass, playerIcon = DBM:GetRaidClass(name)
						if playerClass ~= "UNKNOWN" then
							cap = DBM:GetShortServerName(cap)--Only run realm strip function if class color was valid (IE it's an actual playername)
						end
						local playerColor = RAID_CLASS_COLORS[playerClass] or color
						if playerColor then
							if playerIcon > 0 and playerIcon <= 8 then
								cap = ("|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_%d:0|t"):format(playerIcon) .. ("|r|cff%.2x%.2x%.2x%s|r|cff%.2x%.2x%.2x"):format(playerColor.r * 255, playerColor.g * 255, playerColor.b * 255, cap, color.r * 255, color.g * 255, color.b * 255)
							else
								cap = ("|r|cff%.2x%.2x%.2x%s|r|cff%.2x%.2x%.2x"):format(playerColor.r * 255, playerColor.g * 255, playerColor.b * 255, cap, color.r * 255, color.g * 255, color.b * 255)
							end
						end
					else
						cap = cap:sub(9)
					end
					return cap
				end
			end
			text = text:gsub(">.-<", cachedColorFunctions[self.color])
			DBM:AddWarning(text)
			if DBM.Options.ShowWarningsInChat then
				if not DBM.Options.WarningIconChat then
					text = text:gsub(textureExp, "") -- textures @ chat frame can (and will) distort the font if using certain combinations of UI scale, resolution and font size TODO: is this still true as of cataclysm?
				end
				self.mod:AddMsg(text, nil)
			end
			if self.sound > 0 then
				if self.sound > 1 and DBM.Options.ChosenVoicePack2 ~= "None" and DBM.Options.VPReplacesAnnounce and not voiceSessionDisabled and not DBM.Options.VPDontMuteSounds and self.sound <= SWFilterDisabled then return end
				if not self.option or self.mod.Options[self.option.."SWSound"] ~= "None" then
					DBM:PlaySoundFile(DBM.Options.RaidWarningSound, nil, true)--Validate true
				end
			end
			--Message: Full message text
			--Icon: Texture path/id for icon
			--Type: Announce type
			----Types: you, target, targetsource, spell, ends, endtarget, fades, adds, count, stack, cast, soon, sooncount, prewarn, bait, stage, stagechange, prestage, moveto
			------Personal/Role (Applies to you, or your job): you, stack, bait, moveto, fades
			------General Target Messages (informative, doesn't usually apply to you): target, targetsource
			------Fight Changes (Stages, adds, boss buff/debuff, etc): stage, stagechange, prestage, adds, ends, endtarget
			------General (can really apply to anything): spell, count, soon, sooncount, prewarn
			--SpellId: Raw spell or encounter journal Id if available.
			--Mod ID: Encounter ID as string, or a generic string for mods that don't have encounter ID (such as trash, dummy/test mods)
			--boolean: Whether or not this warning is a special warning (higher priority).
			fireEvent("DBM_Announce", message, self.icon, self.type, self.spellId, self.mod.id, false)
		else
			self.combinedcount = 0
			self.combinedtext = {}
		end
	end

	function announcePrototype:CombinedShow(delay, ...)
		if self.option and not self.mod.Options[self.option] then return end
		if DBM.Options.DontShowBossAnnounces then return end	-- don't show the announces if the spam filter option is set
		if DBM.Options.DontShowTargetAnnouncements and (self.announceType == "target" or self.announceType == "targetcount") and not self.noFilter then return end--don't show announces that are generic target announces
		local argTable = {...}
		for i = 1, #argTable do
			if type(argTable[i]) == "string" then
				if #self.combinedtext < 7 then--Throttle spam. We may not need more than 6 targets..
					if not checkEntry(self.combinedtext, argTable[i]) then
						self.combinedtext[#self.combinedtext + 1] = argTable[i]
					end
				else
					self.combinedcount = self.combinedcount + 1
				end
			end
		end
		DBMScheduler:Unschedule(self.Show, self.mod, self)
		DBMScheduler:Schedule(delay or 0.5, self.Show, self.mod, self, ...)
	end

	function announcePrototype:Schedule(t, ...)
		return DBMScheduler:Schedule(t, self.Show, self.mod, self, ...)
	end

	function announcePrototype:Countdown(time, numAnnounces, ...)
		DBMScheduler:ScheduleCountdown(time, numAnnounces, self.Show, self.mod, self, ...)
	end

	function announcePrototype:Cancel(...)
		return DBMScheduler:Unschedule(self.Show, self.mod, self, ...)
	end

	function announcePrototype:Play(name, customPath)
		local voice = DBM.Options.ChosenVoicePack2
		if voiceSessionDisabled or voice == "None" or not DBM.Options.VPReplacesAnnounce then return end
		local always = DBM.Options.AlwaysPlayVoice
		if DBM.Options.DontShowTargetAnnouncements and (self.announceType == "target" or self.announceType == "targetcount") and not self.noFilter and not always then return end--don't show announces that are generic target announces
		if (not DBM.Options.DontShowBossAnnounces and (not self.option or self.mod.Options[self.option]) or always) and self.sound <= SWFilterDisabled then
			--Filter tank specific voice alerts for non tanks if tank filter enabled
			--But still allow AlwaysPlayVoice to play as well.
			if (name == "changemt" or name == "tauntboss") and DBM.Options.FilterTankSpec and not self.mod:IsTank() and not always then return end
			local path = customPath or "Interface\\AddOns\\DBM-VP"..voice.."\\"..name..".ogg"
			DBM:PlaySoundFile(path)
		end
	end

	function announcePrototype:ScheduleVoice(t, ...)
		if voiceSessionDisabled or DBM.Options.ChosenVoicePack2 == "None" or not DBM.Options.VPReplacesAnnounce then return end
		DBMScheduler:Unschedule(self.Play, self.mod, self)--Allow ScheduleVoice to be used in same way as CombinedShow
		return DBMScheduler:Schedule(t, self.Play, self.mod, self, ...)
	end

	--Object Permits scheduling voice multiple times for same object
	function announcePrototype:ScheduleVoiceOverLap(t, ...)
		if voiceSessionDisabled or DBM.Options.ChosenVoicePack2 == "None" or not DBM.Options.VPReplacesAnnounce then return end
		return DBMScheduler:Schedule(t, self.Play, self.mod, self, ...)
	end

	function announcePrototype:CancelVoice(...)
		if voiceSessionDisabled or DBM.Options.ChosenVoicePack2 == "None" or not DBM.Options.VPReplacesAnnounce then return end
		return DBMScheduler:Unschedule(self.Play, self.mod, self, ...)
	end

	-- old constructor (no auto-localize)
	function bossModPrototype:NewAnnounce(text, color, icon, optionDefault, optionName, soundOption, spellID)
		if not text then
			error("NewAnnounce: you must provide announce text", 2)
			return
		end
		if type(text) == "number" then
			DBM:Debug("|cffff0000NewAnnounce: Non auto localized text cannot be numbers, fix this for |r"..text)
		end
		if type(optionName) == "number" then
			DBM:Debug("|cffff0000NewAnnounce: Non auto localized optionNames cannot be numbers, fix this for |r"..text)
			optionName = nil
		end
		if soundOption and type(soundOption) == "boolean" then
			soundOption = 0--No Sound
		end
		local obj = setmetatable(
			{
				text = self.localization.warnings[text],
				combinedtext = {},
				combinedcount = 0,
				color = DBM.Options.WarningColors[color or 1] or DBM.Options.WarningColors[1],
				sound = soundOption or 1,
				mod = self,
				icon = (type(icon) == "string" and icon:match("ej%d+") and select(4, DBM:EJ_GetSectionInfo(string.sub(icon, 3))) ~= "" and select(4, DBM:EJ_GetSectionInfo(string.sub(icon, 3)))) or (type(icon) == "number" and GetSpellTexture(icon)) or tonumber(icon) or 136116,
			},
			mt
		)
		if optionName then
			obj.option = optionName
			self:AddBoolOption(obj.option, optionDefault, "announce", nil, nil, nil, spellID)
		elseif not (optionName == false) then
			obj.option = text
			self:AddBoolOption(obj.option, optionDefault, "announce", nil, nil, nil, spellID)
		end
		tinsert(self.announces, obj)
		return obj
	end

	-- new constructor (partially auto-localized warnings and options, yay!)
	local function newAnnounce(self, announceType, spellId, color, icon, optionDefault, optionName, castTime, preWarnTime, soundOption, noFilter)
		if not spellId then
			error("newAnnounce: you must provide spellId", 2)
			return
		end
		local optionVersion, alternateSpellId
		if type(optionName) == "number" then
			if optionName > 1000 then--Being used as spell name shortening
				if DBM.Options.WarningShortText then
					alternateSpellId = optionName
				end
			else--Being used as option version
				optionVersion = optionName
			end
			optionName = nil
		end
		if soundOption and type(soundOption) == "boolean" then
			soundOption = 0--No Sound
		end
		if type(spellId) == "string" and spellId:match("OptionVersion") then
			print("newAnnounce for "..color.." is using OptionVersion hack. this is depricated")
			return
		end
		local text, spellName = setText(announceType, alternateSpellId or spellId, castTime, preWarnTime)
		icon = icon or spellId
		local obj = setmetatable( -- todo: fix duplicate code
			{
				text = text,
				combinedtext = {},
				combinedcount = 0,
				announceType = announceType,
				color = DBM.Options.WarningColors[color or 1] or DBM.Options.WarningColors[1],
				mod = self,
				icon = (type(icon) == "string" and icon:match("ej%d+") and select(4, DBM:EJ_GetSectionInfo(string.sub(icon, 3))) ~= "" and select(4, DBM:EJ_GetSectionInfo(string.sub(icon, 3)))) or (type(icon) == "number" and GetSpellTexture(icon)) or tonumber(icon) or 136116,
				sound = soundOption or 1,
				type = announceType,
				spellId = spellId,
				spellName = spellName,
				noFilter = noFilter,
				castTime = castTime,
				preWarnTime = preWarnTime,
			},
			mt
		)
		local catType = "announce"--Default to General announce
		if not self.NoSortAnnounce then--ALL announce objects will be assigned "announce", usually for mods that sort by phase instead
			--Change if Personal or Other
			if announceType == "target" or announceType == "targetcount" or announceType == "stack" then
				catType = "announceother"
			end
		end
		if optionName then
			obj.option = optionName
			self:AddBoolOption(obj.option, optionDefault, catType, nil, nil, nil, spellId, announceType)
		elseif not (optionName == false) then
			obj.option = catType..spellId..announceType..(optionVersion or "")
			self:AddBoolOption(obj.option, optionDefault, catType, nil, nil, nil, spellId, announceType)
			if noFilter and announceType == "target" then
				self.localization.options[obj.option] = L.AUTO_ANNOUNCE_OPTIONS["targetNF"]:format(spellId)
			else
				self.localization.options[obj.option] = L.AUTO_ANNOUNCE_OPTIONS[announceType]:format(spellId)
			end
		end
		tinsert(self.announces, obj)
		return obj
	end

	function bossModPrototype:NewYouAnnounce(spellId, color, ...)
		return newAnnounce(self, "you", spellId, color or 1, ...)
	end

	function bossModPrototype:NewTargetNoFilterAnnounce(spellId, color, icon, optionDefault, optionName, castTime, preWarnTime, soundOption) -- spellId, color, icon, optionDefault, optionName, castTime, preWarnTime, soundOption, noFilter
		return newAnnounce(self, "target", spellId, color or 3, icon, optionDefault, optionName, castTime, preWarnTime, soundOption, true)
	end

	function bossModPrototype:NewTargetAnnounce(spellId, color, ...)
		return newAnnounce(self, "target", spellId, color or 3, ...)
	end

	function bossModPrototype:NewTargetSourceAnnounce(spellId, color, ...)
		return newAnnounce(self, "targetsource", spellId, color or 3, ...)
	end

	function bossModPrototype:NewTargetCountAnnounce(spellId, color, ...)
		return newAnnounce(self, "targetcount", spellId, color or 3, ...)
	end

	function bossModPrototype:NewSpellAnnounce(spellId, color, ...)
		return newAnnounce(self, "spell", spellId, color or 2, ...)
	end

	function bossModPrototype:NewEndAnnounce(spellId, color, ...)
		return newAnnounce(self, "ends", spellId, color or 2, ...)
	end

	function bossModPrototype:NewEndTargetAnnounce(spellId, color, ...)
		return newAnnounce(self, "endtarget", spellId, color or 2, ...)
	end

	function bossModPrototype:NewFadesAnnounce(spellId, color, ...)
		return newAnnounce(self, "fades", spellId, color or 2, ...)
	end

	function bossModPrototype:NewAddsLeftAnnounce(spellId, color, ...)
		return newAnnounce(self, "addsleft", spellId, color or 3, ...)
	end

	function bossModPrototype:NewCountAnnounce(spellId, color, ...)
		return newAnnounce(self, "count", spellId, color or 2, ...)
	end

	function bossModPrototype:NewStackAnnounce(spellId, color, ...)
		return newAnnounce(self, "stack", spellId, color or 2, ...)
	end

	function bossModPrototype:NewCastAnnounce(spellId, color, castTime, icon, optionDefault, optionName, _, soundOption) -- spellId, color, castTime, icon, optionDefault, optionName, noArg, soundOption
		return newAnnounce(self, "cast", spellId, color or 3, icon, optionDefault, optionName, castTime, nil, soundOption)
	end

	function bossModPrototype:NewSoonAnnounce(spellId, color, ...)
		return newAnnounce(self, "soon", spellId, color or 2, ...)
	end

	function bossModPrototype:NewSoonCountAnnounce(spellId, color, ...)
		return newAnnounce(self, "sooncount", spellId, color or 2, ...)
	end

	--This object disables sounds, it's almost always used in combation with a countdown timer. Even if not a countdown, its a text only spam not a sound spam
	function bossModPrototype:NewCountdownAnnounce(spellId, color, icon, optionDefault, optionName, castTime, preWarnTime, _, noFilter) -- spellId, color, icon, optionDefault, optionName, castTime, preWarnTime, soundOption, noFilter
		return newAnnounce(self, "countdown", spellId, color or 4, icon, optionDefault, optionName, castTime, preWarnTime, 0, noFilter)
	end

	function bossModPrototype:NewPreWarnAnnounce(spellId, time, color, icon, optionDefault, optionName, _, soundOption) -- spellId, time, color, icon, optionDefault, optionName, noArg, soundOption
		return newAnnounce(self, "prewarn", spellId, color or 2, icon, optionDefault, optionName, nil, time, soundOption)
	end

	function bossModPrototype:NewBaitAnnounce(spellId, color, ...)
		return newAnnounce(self, "bait", spellId, color or 3, ...)
	end

	function bossModPrototype:NewPhaseAnnounce(stage, color, icon, ...)
		return newAnnounce(self, "stage", stage, color or 2, icon or "136116", ...)
	end

	function bossModPrototype:NewPhaseChangeAnnounce(color, icon, ...)
		return newAnnounce(self, "stagechange", 0, color or 2, icon or "136116", ...)
	end

	function bossModPrototype:NewPrePhaseAnnounce(stage, color, icon, ...)
		return newAnnounce(self, "prestage", stage, color or 2, icon or "136116", ...)
	end

	function bossModPrototype:NewMoveToAnnounce(spellId, color, ...)
		return newAnnounce(self, "moveto", spellId, color or 3, ...)
	end
end

--------------------
--  Yell Object  --
--------------------
do
	local voidForm = GetSpellInfo(194249)
	local yellPrototype = {}
	local mt = { __index = yellPrototype }
	local function newYell(self, yellType, spellId, yellText, optionDefault, optionName, chatType)
		if not spellId and not yellText then
			error("NewYell: you must provide either spellId or yellText", 2)
			return
		end
		if type(spellId) == "string" and spellId:match("OptionVersion") then
			print("newYell for: "..yellText.." is using OptionVersion hack. This is depricated")
			return
		end
		local optionVersion
		if type(optionName) == "number" then
			optionVersion = optionName
			optionName = nil
		end
		local displayText
		if not yellText then
			if type(spellId) == "string" and spellId:match("ej%d+") then
				displayText = L.AUTO_YELL_ANNOUNCE_TEXT[yellType]:format(DBM:EJ_GetSectionInfo(string.sub(spellId, 3)) or CL.UNKNOWN)
			else
				displayText = L.AUTO_YELL_ANNOUNCE_TEXT[yellType]:format(DBM:GetSpellInfo(spellId) or CL.UNKNOWN)
			end
		end
		--Passed spellid as yellText.
		--Auto localize spelltext using yellText instead
		if yellText and type(yellText) == "number" then
			displayText = L.AUTO_YELL_ANNOUNCE_TEXT[yellType]:format(DBM:GetSpellInfo(yellText) or CL.UNKNOWN)
		end
		local obj = setmetatable(
			{
				spellId = spellId,
				text = displayText or yellText,
				mod = self,
				chatType = chatType,
				yellType = yellType
			},
			mt
		)
		if optionName then
			obj.option = optionName
			self:AddBoolOption(obj.option, optionDefault, "yell", nil, nil, nil, spellId, yellType)
		elseif not (optionName == false) then
			obj.option = "Yell"..(spellId or yellText)..(yellType ~= "yell" and yellType or "")..(optionVersion or "")
			self:AddBoolOption(obj.option, optionDefault, "yell", nil, nil, nil, spellId, yellType)
			self.localization.options[obj.option] = L.AUTO_YELL_OPTION_TEXT[yellType]:format(spellId)
		end
		return obj
	end

	--Standard "Yell" object that will use SAY/YELL based on what's defined in the object (Defaulting to SAY if nil)
	--I realize object being :Yell is counter intuitive to default being "SAY" but for many years the default was YELL and it's too many years of mods to change now
	function yellPrototype:Yell(...)
		if not IsInInstance() then--as of 8.2.5, forbidden in outdoor world
			DBM:Debug("WARNING: A mod is still trying to call chat SAY/YELL messages outdoors, FIXME")
			return
		end
		if DBM.Options.DontSendYells or self.yellType and self.yellType == "position" and (not isRetail or DBM:UnitBuff("player", voidForm) and DBM.Options.FilterVoidFormSay) then return end
		if not self.option or self.mod.Options[self.option] then
			if self.yellType == "combo" then
				SendChatMessage(pformat(self.text, ...), self.chatType or "YELL")
			else
				SendChatMessage(pformat(self.text, ...), self.chatType or "SAY")
			end
		end
	end
	yellPrototype.Show = yellPrototype.Yell

	--Force override to use say message, even when object defines "YELL"
	function yellPrototype:Say(...)
		if not IsInInstance() then--as of 8.2.5, forbidden in outdoor world
			DBM:Debug("WARNING: A mod is still trying to call chat SAY/YELL messages outdoors, FIXME")
			return
		end
		if DBM.Options.DontSendYells or self.yellType and self.yellType == "position" and (not isRetail or DBM:UnitBuff("player", voidForm) and DBM.Options.FilterVoidFormSay) then return end
		if not self.option or self.mod.Options[self.option] then
			SendChatMessage(pformat(self.text, ...), "SAY")
		end
	end

	function yellPrototype:Schedule(t, ...)
		return DBMScheduler:Schedule(t, self.Yell, self.mod, self, ...)
	end

	--Standard schedule object to schedule a say/yell based on what's defined in object
	function yellPrototype:Countdown(time, numAnnounces, ...)
		if time > 60 then--It's a spellID not a time
			local _, _, _, _, _, expireTime = DBM:UnitDebuff("player", time)
			if expireTime then
				local remaining = expireTime-GetTime()
				DBMScheduler:ScheduleCountdown(remaining, numAnnounces, self.Yell, self.mod, self, ...)
			end
		else
			DBMScheduler:ScheduleCountdown(time, numAnnounces, self.Yell, self.mod, self, ...)
		end
	end

	--Scheduled Force override to use SAY message, even when object defines "YELL"
	function yellPrototype:CountdownSay(time, numAnnounces, ...)
		if time > 60 then--It's a spellID not a time
			local _, _, _, _, _, expireTime = DBM:UnitDebuff("player", time)
			if expireTime then
				local remaining = expireTime-GetTime()
				DBMScheduler:ScheduleCountdown(remaining, numAnnounces, self.Yell, self.mod, self, ...)
			end
		else
			DBMScheduler:ScheduleCountdown(time, numAnnounces, self.Say, self.mod, self, ...)
		end
	end

	function yellPrototype:Cancel(...)
		return DBMScheduler:Unschedule(self.Yell, self.mod, self, ...)
	end

	function bossModPrototype:NewYell(...)
		return newYell(self, "yell", ...)
	end

	function bossModPrototype:NewShortYell(...)
		return newYell(self, "shortyell", ...)
	end

	function bossModPrototype:NewCountYell(...)
		return newYell(self, "count", ...)
	end

	function bossModPrototype:NewFadesYell(...)
		return newYell(self, "fade", ...)
	end

	function bossModPrototype:NewShortFadesYell(...)
		return newYell(self, "shortfade", ...)
	end

	function bossModPrototype:NewIconFadesYell(...)
		return newYell(self, "iconfade", ...)
	end

	function bossModPrototype:NewPosYell(...)
		return newYell(self, "position", ...)
	end

	function bossModPrototype:NewShortPosYell(...)
		return newYell(self, "shortposition", ...)
	end

	function bossModPrototype:NewComboYell(...)
		return newYell(self, "combo", ...)
	end

	function bossModPrototype:NewPlayerRepeatYell(...)
		return newYell(self, "repeatplayer", ...)
	end

	function bossModPrototype:NewIconRepeatYell(...)
		return newYell(self, "repeaticon", ...)
	end
end

------------------------------
--  Special Warning Object  --
------------------------------
do
	local frame = CreateFrame("Frame", "DBMSpecialWarning", UIParent)
	local font1 = frame:CreateFontString("DBMSpecialWarning1", "OVERLAY", "ZoneTextFont")
	font1:SetWidth(1024)
	font1:SetHeight(0)
	font1:SetPoint("TOP", 0, 0)
	local font2 = frame:CreateFontString("DBMSpecialWarning2", "OVERLAY", "ZoneTextFont")
	font2:SetWidth(1024)
	font2:SetHeight(0)
	font2:SetPoint("TOP", font1, "BOTTOM", 0, 0)
	frame:SetMovable(1)
	frame:SetWidth(1)
	frame:SetHeight(1)
	frame:SetFrameStrata("HIGH")
	frame:SetClampedToScreen()
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)

	local font1elapsed, font2elapsed, moving

	local function fontHide1()
		local duration = DBM.Options.SpecialWarningDuration2
		if font1elapsed > duration * 1.3 then
			font1:Hide()
			if frame.font1ticker then
				frame.font1ticker:Cancel()
				frame.font1ticker = nil
			end
		elseif font1elapsed > duration then
			font1elapsed = font1elapsed + 0.05
			local alpha = 1 - (font1elapsed - duration) / (duration * 0.3)
			font1:SetAlpha(alpha > 0 and alpha or 0)
		else
			font1elapsed = font1elapsed + 0.05
			font1:SetAlpha(1)
		end
	end

	local function fontHide2()
		local duration = DBM.Options.SpecialWarningDuration2
		if font2elapsed > duration * 1.3 then
			font2:Hide()
			if frame.font2ticker then
				frame.font2ticker:Cancel()
				frame.font2ticker = nil
			end
		elseif font2elapsed > duration then
			font2elapsed = font2elapsed + 0.05
			local alpha = 1 - (font2elapsed - duration) / (duration * 0.3)
			font2:SetAlpha(alpha > 0 and alpha or 0)
		else
			font2elapsed = font2elapsed + 0.05
			font2:SetAlpha(1)
		end
	end

	function DBM:UpdateSpecialWarningOptions()
		frame:ClearAllPoints()
		local font = self.Options.SpecialWarningFont == "standardFont" and standardFont or self.Options.SpecialWarningFont
		frame:SetPoint(self.Options.SpecialWarningPoint, UIParent, self.Options.SpecialWarningPoint, self.Options.SpecialWarningX, self.Options.SpecialWarningY)
		font1:SetFont(font, self.Options.SpecialWarningFontSize2, self.Options.SpecialWarningFontStyle == "None" and nil or self.Options.SpecialWarningFontStyle)
		font2:SetFont(font, self.Options.SpecialWarningFontSize2, self.Options.SpecialWarningFontStyle == "None" and nil or self.Options.SpecialWarningFontStyle)
		font1:SetTextColor(unpack(self.Options.SpecialWarningFontCol))
		font2:SetTextColor(unpack(self.Options.SpecialWarningFontCol))
		if self.Options.SpecialWarningFontShadow then
			font1:SetShadowOffset(1, -1)
			font2:SetShadowOffset(1, -1)
		else
			font1:SetShadowOffset(0, 0)
			font2:SetShadowOffset(0, 0)
		end
	end

	function DBM:AddSpecialWarning(text, force)
		local added = false
		if not frame.font1ticker then
			font1elapsed = 0
			font1.lastUpdate = GetTime()
			font1:SetText(text)
			font1:Show()
			added = true
			frame.font1ticker = frame.font1ticker or C_TimerNewTicker(0.05, fontHide1)
		elseif not frame.font2ticker or force then
			font2elapsed = 0
			font2.lastUpdate = GetTime()
			font2:SetText(text)
			font2:Show()
			added = true
			frame.font2ticker = frame.font2ticker or C_TimerNewTicker(0.05, fontHide2)
		end
		if not added then
			local prevText1 = font2:GetText()
			font1:SetText(prevText1)
			font1elapsed = font2elapsed
			self:AddSpecialWarning(text, true)
		end
	end

	do
		local anchorFrame
		local function moveEnd(self)
			moving = false
			anchorFrame:Hide()
			font1elapsed = self.Options.SpecialWarningDuration2
			font2elapsed = self.Options.SpecialWarningDuration2
			frame:SetFrameStrata("HIGH")
			self:Unschedule(moveEnd)
			DBT:CancelBar(L.MOVE_SPECIAL_WARNING_BAR)
		end

		function DBM:MoveSpecialWarning()
			if not anchorFrame then
				anchorFrame = CreateFrame("Frame", nil, frame)
				anchorFrame:SetWidth(32)
				anchorFrame:SetHeight(32)
				anchorFrame:EnableMouse(true)
				anchorFrame:SetPoint("TOP", frame, "TOP", 0, 32)
				anchorFrame:RegisterForDrag("LeftButton")
				anchorFrame:SetClampedToScreen()
				anchorFrame:Hide()
				local texture = anchorFrame:CreateTexture()
				texture:SetTexture("Interface\\Addons\\DBM-Core\\textures\\dot.blp")
				texture:SetPoint("CENTER", anchorFrame, "CENTER", 0, 0)
				texture:SetWidth(32)
				texture:SetHeight(32)
				anchorFrame:SetScript("OnDragStart", function()
					frame:StartMoving()
					self:Unschedule(moveEnd)
					DBT:CancelBar(L.MOVE_SPECIAL_WARNING_BAR)
				end)
				anchorFrame:SetScript("OnDragStop", function()
					frame:StopMovingOrSizing()
					local point, _, _, xOfs, yOfs = frame:GetPoint(1)
					self.Options.SpecialWarningPoint = point
					self.Options.SpecialWarningX = xOfs
					self.Options.SpecialWarningY = yOfs
					self:Schedule(15, moveEnd, self)
					DBT:CreateBar(15, L.MOVE_SPECIAL_WARNING_BAR, isRetail and 237538 or 136106)
				end)
			end
			if anchorFrame:IsShown() then
				moveEnd(self)
			else
				moving = true
				anchorFrame:Show()
				self:AddSpecialWarning(L.MOVE_SPECIAL_WARNING_TEXT)
				self:AddSpecialWarning(L.MOVE_SPECIAL_WARNING_TEXT)
				self:Schedule(15, moveEnd, self)
				DBT:CreateBar(15, L.MOVE_SPECIAL_WARNING_BAR, isRetail and 237538 or 136106)
				frame:Show()
				frame:SetFrameStrata("TOOLTIP")
				frame:SetAlpha(1)
			end
		end
	end

	local specialWarningPrototype = {}
	local mt = {__index = specialWarningPrototype}

	local function classColoringFunction(cap)
		cap = cap:sub(2, -2)
		local noStrip = cap:match("noStrip ")
		if not noStrip then
			local name = cap
			local playerClass, playerIcon = DBM:GetRaidClass(name)
			if playerClass ~= "UNKNOWN" then
				cap = DBM:GetShortServerName(cap)--Only run strip code on valid player classes
				if DBM.Options.SWarnClassColor then
					local playerColor = RAID_CLASS_COLORS[playerClass]
					if playerColor then
						if playerIcon > 0 and playerIcon <= 8 then
							cap = ("|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_%d:0|t"):format(playerIcon) .. ("|r|cff%.2x%.2x%.2x%s|r|cff%.2x%.2x%.2x"):format(playerColor.r * 255, playerColor.g * 255, playerColor.b * 255, cap, DBM.Options.SpecialWarningFontCol[1] * 255, DBM.Options.SpecialWarningFontCol[2] * 255, DBM.Options.SpecialWarningFontCol[3] * 255)
						else
							cap = ("|r|cff%.2x%.2x%.2x%s|r|cff%.2x%.2x%.2x"):format(playerColor.r * 255, playerColor.g * 255, playerColor.b * 255, cap, DBM.Options.SpecialWarningFontCol[1] * 255, DBM.Options.SpecialWarningFontCol[2] * 255, DBM.Options.SpecialWarningFontCol[3] * 255)
						end
					end
				end
			end
		else
			cap = cap:sub(9)
		end
		return cap
	end

	local textureCode = " |T%s:12:12|t "

	local function setText(announceType, spellId, stacks)
		local text, spellName
		if type(spellId) == "string" and spellId:match("ej%d+") then
			spellName = DBM:EJ_GetSectionInfo(string.sub(spellId, 3)) or CL.UNKNOWN
		else
			spellName = (spellId or 0) >= 6 and DBM:GetSpellInfo(spellId) or CL.UNKNOWN
		end
		if announceType == "prewarn" then
			if type(stacks) == "string" then
				text = L.AUTO_SPEC_WARN_TEXTS[announceType]:format(spellName, stacks)
			else
				text = L.AUTO_SPEC_WARN_TEXTS[announceType]:format(spellName, L.SEC_FMT:format(tostring(stacks or 5)))
			end
		else
			text = L.AUTO_SPEC_WARN_TEXTS[announceType]:format(spellName)
		end
		return text, spellName
	end

	local function canVoiceReplace(self, soundId)
		soundId = soundId or self.option and self.mod.Options[self.option .. "SWSound"] or self.flash
		local isVoicePackUsed
		if type(soundId) == "number" then
			isVoicePackUsed = DBM.Options["VPReplacesSA"..soundId]
		else
			isVoicePackUsed = DBM.Options.VPReplacesCustom
		end
		return isVoicePackUsed
	end

	local specTypeTable = {
		["dispel"] = "dispel",
		["interrupt"] = "interrupt",
		["interruptcount"] = "interrupt",
		["defensive"] = "defensive",
		["taunt"] = "taunt",
		["soak"] = "soak",
		["soakcount"] = "soak",
		["stack"] = "stack",
		["switch"] = "switch",
		["switchcount"] = "switch",
		["adds"] = "switch",
		["addscustom"] = "switch",
		["targetchange"] = "switch",
		["gtfo"] = "gtfo",
	}

	function specialWarningPrototype:Show(...)
		--Check if option for this warning is even enabled
		if (not self.option or self.mod.Options[self.option]) and not moving and frame then
			--Now, check if all special warning filters are enabled to save cpu and abort immediately if true.
			if DBM.Options.DontPlaySpecialWarningSound and DBM.Options.DontShowSpecialWarningFlash and DBM.Options.DontShowSpecialWarningText then return end
			--Next, we check if trash mod warning and if so check the filter trash warning filter for trivial difficulties
			if self.mod:IsEasyDungeon() and self.mod.isTrashMod and DBM.Options.FilterTrashWarnings2 then return end
			--We also check if person has the role filter turned on (typical for highest end raiders who don't want as much handholding from DBM)
			if specTypeTable[self.announceType] then
				if DBM.Options["SpamSpecRole"..specTypeTable[self.announceType]] then return end
			end
			--Lastly, we check if it's a tank warning and filter if not in tank spec. This is done because tank warnings on by default and handled fluidly by spec, not option setting
			if self.announceType == "taunt" and DBM.Options.FilterTankSpec and not self.mod:IsTank() then return end--Don't tell non tanks to taunt, ever.
			local argTable = {...}
			-- add a default parameter for move away warnings
			if self.announceType == "gtfo" then
				if DBM:UnitBuff("player", 27827) then return end--Don't tell a priest in spirit of redemption form to GTFO, they can't, and they don't take damage from it anyhow
				if #argTable == 0 then
					argTable[1] = L.BAD
				end
			end
			if #self.combinedtext > 0 then
				--Throttle spam.
				if DBM.Options.SWarningAlphabetical then
					tsort(self.combinedtext)
				end
				local combinedText = tconcat(self.combinedtext, "<, >")
				if self.combinedcount == 1 then
					combinedText = combinedText.." "..L.GENERIC_WARNING_OTHERS
				elseif self.combinedcount > 1 then
					combinedText = combinedText.." "..L.GENERIC_WARNING_OTHERS2:format(self.combinedcount)
				end
				--Process
				for i = 1, #argTable do
					if type(argTable[i]) == "string" then
						argTable[i] = combinedText
					end
				end
			end
			local message = pformat(self.text, unpack(argTable))
			local text = ("%s%s%s"):format(
				(DBM.Options.SpecialWarningIcon and self.icon and textureCode:format(self.icon)) or "",
				message,
				(DBM.Options.SpecialWarningIcon and self.icon and textureCode:format(self.icon)) or ""
			)
			local noteHasName = false
			if self.option then
				local noteText = self.mod.Options[self.option .. "SWNote"]
				if noteText and type(noteText) == "string" and noteText ~= "" then--Filter false bool and empty strings
					local count1 = self.announceType == "count" or self.announceType == "switchcount" or self.announceType == "targetcount"
					local count2 = self.announceType == "interruptcount"
					if count1 or count2 then--Counts support different note for EACH count
						local noteCount
						local notesTable = {string.split("/", noteText)}
						if count1 then
							noteCount = argTable[1]--Count should be first arg in table
						elseif count2 then
							noteCount = argTable[2]--Count should be second arg in table
						end
						if type(noteCount) == "string" then
							--Probably a hypehnated double count like inferno slice or marked for death
							local mainCount = string.split("-", noteCount)
							noteCount = tonumber(mainCount)
						end
						noteText = notesTable[noteCount]
						if noteText and type(noteText) == "string" and noteText ~= "" then--Refilter after string split to make sure a note for this count exists
							local hasPlayerName = noteText:find(playerName)
							if DBM.Options.SWarnNameInNote and hasPlayerName then
								noteHasName = 5
							end
							--Terminate special warning, it's an interrupt count warning without player name and filter enabled
							if count2 and DBM.Options.FilterInterruptNoteName and not hasPlayerName then return end
							noteText = " ("..noteText..")"
							text = text..noteText
						end
					else--Non count warnings will have one note, period
						if DBM.Options.SWarnNameInNote and noteText:find(playerName) then
							noteHasName = 5
						end
						if self.announceType and not self.announceType:find("switch") then
							noteText = noteText:gsub(">.-<", classColoringFunction)--Class color note text before combining with warning text.
						end
						noteText = " ("..noteText..")"
						text = text..noteText
					end
				end
			end
			--Text is disabled, suresss text from screen and chat frame
			if not DBM.Options.DontShowSpecialWarningText then
				--No stripping on switch warnings, ever. They will NEVER have player name, but often have adds with "-" in name
				if self.announceType and not self.announceType:find("switch") then
					text = text:gsub(">.-<", classColoringFunction)
				end
				DBM:AddSpecialWarning(text)
				if DBM.Options.ShowSWarningsInChat then
					local colorCode = ("|cff%.2x%.2x%.2x"):format(DBM.Options.SpecialWarningFontCol[1] * 255, DBM.Options.SpecialWarningFontCol[2] * 255, DBM.Options.SpecialWarningFontCol[3] * 255)
					self.mod:AddMsg(colorCode.."["..L.MOVE_SPECIAL_WARNING_TEXT.."] "..text.."|r", nil)
				end
			end
			self.combinedcount = 0
			self.combinedtext = {}
			if not UnitIsDeadOrGhost("player") then
				if noteHasName then
					if not DBM.Options.DontShowSpecialWarningFlash and DBM.Options.SpecialWarningFlash5 then--Not included in above if statement on purpose. we don't want to trigger else rule if noteHasName is true but SpecialWarningFlash5 is false
						local repeatCount = DBM.Options.SpecialWarningFlashCount5 or 1
						DBM.Flash:Show(DBM.Options.SpecialWarningFlashCol5[1],DBM.Options.SpecialWarningFlashCol5[2], DBM.Options.SpecialWarningFlashCol5[3], DBM.Options.SpecialWarningFlashDura5, DBM.Options.SpecialWarningFlashAlph5, repeatCount-1)
					end
					if not DBM.Options.DontDoSpecialWarningVibrate and DBM.Options.SpecialWarningVibrate5 then
						DBM:VibrateController()
					end
				else
					local number = self.flash
					if not DBM.Options.DontShowSpecialWarningFlash and DBM.Options["SpecialWarningFlash"..number] then
						local repeatCount = DBM.Options["SpecialWarningFlashCount"..number] or 1
						local flashcolor = DBM.Options["SpecialWarningFlashCol"..number]
						DBM.Flash:Show(flashcolor[1], flashcolor[2], flashcolor[3], DBM.Options["SpecialWarningFlashDura"..number], DBM.Options["SpecialWarningFlashAlph"..number], repeatCount-1)
					end
					if not DBM.Options.DontDoSpecialWarningVibrate and DBM.Options["SpecialWarningVibrate"..number] then
						DBM:VibrateController()
					end
				end
			end
			--Text: Full message text
			--Icon: Texture path/id for icon
			--Type: Announce type
			----Types: spell, ends, fades, soon, bait, dispel, interrupt, interruptcount, you, youcount, youpos, soakpos, target, targetcount, defensive, taunt, close, move, keepmove, stopmove,
			----gtfo, dodge, dodgecount, dodgeloc, moveaway, moveawaycount, moveto, soak, jump, run, cast, lookaway, reflect, count, sooncount, stack, switch, switchcount, adds, addscustom, targetchange, prewarn
			------General Target Messages (but since it's a special warning, it applies to you in some way): target, targetcount
			------Fight Changes (Stages, adds, boss buff/debuff, etc): adds, addscustom, targetchange, switch, switchcount, ends
			------General (can really apply to anything): spell, count, soon, sooncount, prewarn
			------Personal/Role (Applies to you, or your job): Everything Else
			--SpellId: Raw spell or encounter journal Id if available.
			--Mod ID: Encounter ID as string, or a generic string for mods that don't have encounter ID (such as trash, dummy/test mods)
			--boolean: Whether or not this warning is a special warning (higher priority).
			fireEvent("DBM_Announce", text, self.icon, self.type, self.spellId, self.mod.id, true)
			if self.sound and not DBM.Options.DontPlaySpecialWarningSound and (not self.option or self.mod.Options[self.option.."SWSound"] ~= "None") then
				local soundId = self.option and self.mod.Options[self.option .. "SWSound"] or self.flash
				if noteHasName and type(soundId) == "number" then soundId = noteHasName end--Change number to 5 if it's not a custom sound, else, do nothing with it
				if self.hasVoice and DBM.Options.ChosenVoicePack2 ~= "None" and not voiceSessionDisabled and not DBM.Options.VPDontMuteSounds and canVoiceReplace(self, soundId) and self.hasVoice <= SWFilterDisabled then return end
				DBM:PlaySpecialWarningSound(soundId or 1)
			end
		else
			self.combinedcount = 0
			self.combinedtext = {}
		end
	end

	function specialWarningPrototype:CombinedShow(delay, ...)
		--Check if option for this warning is even enabled
		if self.option and not self.mod.Options[self.option] then return end
		--Now, check if all special warning filters are enabled to save cpu and abort immediately if true.
		if DBM.Options.DontPlaySpecialWarningSound and DBM.Options.DontShowSpecialWarningFlash and DBM.Options.DontShowSpecialWarningText then return end
		--Next, we check if trash mod warning and if so check the filter trash warning filter for trivial difficulties
		if self.mod:IsEasyDungeon() and self.mod.isTrashMod and DBM.Options.FilterTrashWarnings2 then return end
		local argTable = {...}
		for i = 1, #argTable do
			if type(argTable[i]) == "string" then
				if #self.combinedtext < 6 then--Throttle spam. We may not need more than 5 targets..
					if not checkEntry(self.combinedtext, argTable[i]) then
						self.combinedtext[#self.combinedtext + 1] = argTable[i]
					end
				else
					self.combinedcount = self.combinedcount + 1
				end
			end
		end
		DBMScheduler:Unschedule(self.Show, self.mod, self)
		DBMScheduler:Schedule(delay or 0.5, self.Show, self.mod, self, ...)
	end

	function specialWarningPrototype:DelayedShow(delay, ...)
		DBMScheduler:Unschedule(self.Show, self.mod, self, ...)
		DBMScheduler:Schedule(delay or 0.5, self.Show, self.mod, self, ...)
	end

	function specialWarningPrototype:Schedule(t, ...)
		return DBMScheduler:Schedule(t, self.Show, self.mod, self, ...)
	end

	function specialWarningPrototype:Countdown(time, numAnnounces, ...)
		DBMScheduler:ScheduleCountdown(time, numAnnounces, self.Show, self.mod, self, ...)
	end

	function specialWarningPrototype:Cancel(_, ...) -- t, ...
		return DBMScheduler:Unschedule(self.Show, self.mod, self, ...)
	end

	function specialWarningPrototype:Play(name, customPath)
		local always = DBM.Options.AlwaysPlayVoice
		local voice = DBM.Options.ChosenVoicePack2
		local soundId = self.option and self.mod.Options[self.option .. "SWSound"] or self.flash
		if voiceSessionDisabled or voice == "None" or not canVoiceReplace(self, soundId) then return end
		if self.mod:IsEasyDungeon() and self.mod.isTrashMod and DBM.Options.FilterTrashWarnings2 then return end
		if ((not self.option or self.mod.Options[self.option]) or always) and self.hasVoice <= SWFilterDisabled then
			--Filter tank specific voice alerts for non tanks if tank filter enabled
			--But still allow AlwaysPlayVoice to play as well.
			if (name == "changemt" or name == "tauntboss") and DBM.Options.FilterTankSpec and not self.mod:IsTank() and not always then return end
			--Mute VP if SW sound is set to None in the boss mod.
			if soundId == "None" then return end
			local path = customPath or "Interface\\AddOns\\DBM-VP"..voice.."\\"..name..".ogg"
			DBM:PlaySoundFile(path)
		end
	end

	function specialWarningPrototype:ScheduleVoice(t, ...)
		if voiceSessionDisabled or DBM.Options.ChosenVoicePack2 == "None" or not canVoiceReplace(self) then return end
		DBMScheduler:Unschedule(self.Play, self.mod, self)--Allow ScheduleVoice to be used in same way as CombinedShow
		return DBMScheduler:Schedule(t, self.Play, self.mod, self, ...)
	end

	--Object Permits scheduling voice multiple times for same object
	function specialWarningPrototype:ScheduleVoiceOverLap(t, ...)
		if voiceSessionDisabled or DBM.Options.ChosenVoicePack2 == "None" or not canVoiceReplace(self) then return end
		return DBMScheduler:Schedule(t, self.Play, self.mod, self, ...)
	end

	function specialWarningPrototype:CancelVoice(...)
		if voiceSessionDisabled or DBM.Options.ChosenVoicePack2 == "None" or not canVoiceReplace(self) then return end
		return DBMScheduler:Unschedule(self.Play, self.mod, self, ...)
	end

	function bossModPrototype:NewSpecialWarning(text, optionDefault, optionName, optionVersion, runSound, hasVoice, difficulty, texture, spellID)
		if not text then
			error("NewSpecialWarning: you must provide special warning text", 2)
			return
		end
		if type(text) == "string" and text:match("OptionVersion") then
			print("NewSpecialWarning: you must provide remove optionversion hack for "..optionDefault)
			return
		end
		if runSound == true then
			runSound = 2
		elseif not runSound then
			runSound = 1
		end
		if hasVoice == true then--if not a number, set it to 2, old mods that don't use new numbered system
			hasVoice = 2
		end
		local seticon
		if texture then
			seticon = (type(texture) == "string" and texture:match("ej%d+") and select(4, DBM:EJ_GetSectionInfo(string.sub(texture, 3))) ~= "" and select(4, DBM:EJ_GetSectionInfo(string.sub(texture, 3)))) or (type(texture) == "number" and GetSpellTexture(texture)) or nil
		end
		local obj = setmetatable(
			{
				text = self.localization.warnings[text],
				combinedtext = {},
				combinedcount = 0,
				mod = self,
				sound = runSound>0,
				flash = runSound,--Set flash color to hard coded runsound (even if user sets custom sounds)
				hasVoice = hasVoice,
				difficulty = difficulty,
				icon = seticon,
			},
			mt
		)
		local optionId = optionName or optionName ~= false and text
		if optionId then
			obj.voiceOptionId = hasVoice and "Voice"..optionId or nil
			obj.option = optionId..(optionVersion or "")
			self:AddSpecialWarningOption(optionId, optionDefault, runSound, self.NoSortAnnounce and "specialannounce" or "announce", spellID)
		end
		tinsert(self.specwarns, obj)
		return obj
	end

	local function newSpecialWarning(self, announceType, spellId, stacks, optionDefault, optionName, optionVersion, runSound, hasVoice, difficulty)
		if not spellId then
			error("newSpecialWarning: you must provide spellId", 2)
			return
		end
		if runSound == true then
			runSound = 2
		elseif not runSound then
			runSound = 1
		end
		if hasVoice == true then--if not a number, set it to 2, old mods that don't use new numbered system
			hasVoice = 2
		end
		local alternateSpellId
		if type(optionName) == "number" then
			if DBM.Options.SpecialWarningShortText then
				alternateSpellId = optionName
			end
			optionName = nil
		end
		local text, spellName = setText(announceType, alternateSpellId or spellId, stacks)
		local obj = setmetatable( -- todo: fix duplicate code
			{
				text = text,
				combinedtext = {},
				combinedcount = 0,
				announceType = announceType,
				mod = self,
				sound = runSound>0,
				flash = runSound,--Set flash color to hard coded runsound (even if user sets custom sounds)
				hasVoice = hasVoice,
				difficulty = difficulty,
				type = announceType,
				spellId = spellId,
				spellName = spellName,
				stacks = stacks,
				icon = (type(spellId) == "string" and spellId:match("ej%d+") and select(4, DBM:EJ_GetSectionInfo(string.sub(spellId, 3))) ~= "" and select(4, DBM:EJ_GetSectionInfo(string.sub(spellId, 3)))) or (type(spellId) == "number" and GetSpellTexture(spellId)) or nil
			},
			mt
		)
		if optionName then
			obj.option = optionName
		elseif not (optionName == false) then
			local difficultyIcon = ""
			if difficulty then
				--1 LFR, 2 Normal, 3 Heroic, 4 Mythic
				--Likely 1 and 2 will never be used, but being prototyped just in case
				local path = isRetail and "EncounterJournal" or "AddOns\\DBM-Core\\textures"
				if difficulty == 3 then
					difficultyIcon = "|TInterface\\" .. path .. "\\UI-EJ-Icons.blp:18:18:0:0:255:66:102:118:7:27|t"
				elseif difficulty == 4 then
					difficultyIcon = "|TInterface\\" .. path .. "\\UI-EJ-Icons.blp:18:18:0:0:255:66:133:153:40:58|t"
				end
			end
			obj.option = "SpecWarn"..spellId..announceType..(optionVersion or "")
			if announceType == "stack" then
				self.localization.options[obj.option] = difficultyIcon..L.AUTO_SPEC_WARN_OPTIONS[announceType]:format(stacks or 3, spellId)
			elseif announceType == "prewarn" then
				self.localization.options[obj.option] = difficultyIcon..L.AUTO_SPEC_WARN_OPTIONS[announceType]:format(tostring(stacks or 5), spellId)
			else
				self.localization.options[obj.option] = difficultyIcon..L.AUTO_SPEC_WARN_OPTIONS[announceType]:format(spellId)
			end
		end
		if obj.option then
			local catType = "announce"--Default to General announce
			if self.NoSortAnnounce then--ALL special announce objects will be assigned "specialannounce", usually for mods that sort by phase instead
				catType = "specialannounce"
			else
				--Directly affects another target (boss or player) that you need to know about
				if announceType == "target" or announceType == "targetcount" or announceType == "close" or announceType == "reflect" then
					catType = "announceother"
				--Directly affects you
				elseif announceType == "you" or announceType == "youcount" or announceType == "youpos" or announceType == "move" or announceType == "dodge" or announceType == "dodgecount" or announceType == "moveaway" or announceType == "moveawaycount" or announceType == "keepmove" or announceType == "stopmove" or announceType == "run" or announceType == "stack" or announceType == "moveto" or announceType == "soak" or announceType == "soakcount" or announceType == "soakpos" then
					catType = "announcepersonal"
				--Things you have to do to fulfil your role
				elseif announceType == "taunt" or announceType == "dispel" or announceType == "interrupt" or announceType == "interruptcount" or announceType == "switch" or announceType == "switchcount" then
					catType = "announcerole"
				end
			end
			self:AddSpecialWarningOption(obj.option, optionDefault, runSound, catType, spellId, announceType)
		end
		obj.voiceOptionId = hasVoice and "Voice"..spellId or nil
		tinsert(self.specwarns, obj)
		return obj
	end

	function bossModPrototype:NewSpecialWarningSpell(text, optionDefault, ...)
		return newSpecialWarning(self, "spell", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningEnd(text, optionDefault, ...)
		return newSpecialWarning(self, "ends", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningFades(text, optionDefault, ...)
		return newSpecialWarning(self, "fades", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningSoon(text, optionDefault, ...)
		return newSpecialWarning(self, "soon", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningBait(text, optionDefault, ...)
		return newSpecialWarning(self, "bait", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningDispel(text, optionDefault, ...)
		return newSpecialWarning(self, "dispel", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningInterrupt(text, optionDefault, ...)
		return newSpecialWarning(self, "interrupt", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningInterruptCount(text, optionDefault, ...)
		return newSpecialWarning(self, "interruptcount", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningYou(text, optionDefault, ...)
		return newSpecialWarning(self, "you", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningYouCount(text, optionDefault, ...)
		return newSpecialWarning(self, "youcount", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningYouPos(text, optionDefault, ...)
		return newSpecialWarning(self, "youpos", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningSoakPos(text, optionDefault, ...)
		return newSpecialWarning(self, "soakpos", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningTarget(text, optionDefault, ...)
		return newSpecialWarning(self, "target", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningTargetCount(text, optionDefault, ...)
		return newSpecialWarning(self, "targetcount", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningDefensive(text, optionDefault, ...)
		return newSpecialWarning(self, "defensive", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningTaunt(text, optionDefault, ...)
		return newSpecialWarning(self, "taunt", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningClose(text, optionDefault, ...)
		return newSpecialWarning(self, "close", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningMove(text, optionDefault, ...)
		return newSpecialWarning(self, "move", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningKeepMove(text, optionDefault, ...)
		return newSpecialWarning(self, "keepmove", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningStopMove(text, optionDefault, ...)
		return newSpecialWarning(self, "stopmove", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningGTFO(text, optionDefault, ...)
		return newSpecialWarning(self, "gtfo", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningDodge(text, optionDefault, ...)
		return newSpecialWarning(self, "dodge", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningDodgeCount(text, optionDefault, ...)
		return newSpecialWarning(self, "dodgecount", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningDodgeLoc(text, optionDefault, ...)
		return newSpecialWarning(self, "dodgeloc", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningMoveAway(text, optionDefault, ...)
		return newSpecialWarning(self, "moveaway", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningMoveAwayCount(text, optionDefault, ...)
		return newSpecialWarning(self, "moveawaycount", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningMoveTo(text, optionDefault, ...)
		return newSpecialWarning(self, "moveto", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningSoak(text, optionDefault, ...)
		return newSpecialWarning(self, "soak", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningSoakCount(text, optionDefault, ...)
		return newSpecialWarning(self, "soakcount", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningJump(text, optionDefault, ...)
		return newSpecialWarning(self, "jump", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningRun(text, optionDefault, optionName, optionVersion, runSound, ...)
		return newSpecialWarning(self, "run", text, nil, optionDefault, optionName, optionVersion, runSound or 4, ...)
	end

	function bossModPrototype:NewSpecialWarningCast(text, optionDefault, ...)
		return newSpecialWarning(self, "cast", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningLookAway(text, optionDefault, ...)
		return newSpecialWarning(self, "lookaway", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningReflect(text, optionDefault, ...)
		return newSpecialWarning(self, "reflect", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningCount(text, optionDefault, ...)
		return newSpecialWarning(self, "count", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningSoonCount(text, optionDefault, ...)
		return newSpecialWarning(self, "sooncount", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningStack(text, optionDefault, stacks, ...)
		return newSpecialWarning(self, "stack", text, stacks, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningSwitch(text, optionDefault, ...)
		return newSpecialWarning(self, "switch", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningSwitchCount(text, optionDefault, ...)
		return newSpecialWarning(self, "switchcount", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningAdds(text, optionDefault, ...)
		return newSpecialWarning(self, "adds", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningAddsCustom(text, optionDefault, ...)
		return newSpecialWarning(self, "addscustom", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningTargetChange(text, optionDefault, ...)
		return newSpecialWarning(self, "targetchange", text, nil, optionDefault, ...)
	end

	function bossModPrototype:NewSpecialWarningPreWarn(text, optionDefault, time, ...)
		return newSpecialWarning(self, "prewarn", text, time, optionDefault, ...)
	end

	function DBM:PlayCountSound(number, forceVoice, forcePath)
		if number > 10 then return end
		local voice
		if forceVoice then--For options example
			voice = forceVoice
		else
			voice = self.Options.CountdownVoice
		end
		local path
		local maxCount = 5
		if forcePath then
			path = forcePath
		else
			for _, count in pairs(DBM:GetCountSounds()) do
				if count.value == voice then
					path = count.path
					maxCount = count.max
					break
				end
			end
		end
		if not path or (number > maxCount) then return end
		self:PlaySoundFile(path..number..".ogg")
	end

	do
		local minVoicePackVersion = isRetail and 12 or 10

		function DBM:CheckVoicePackVersion(value)
			local activeVP = self.Options.ChosenVoicePack2
			--Check if voice pack out of date
			if activeVP ~= "None" and activeVP == value then
				if self.VoiceVersions[value] < minVoicePackVersion then--Version will be bumped when new voice packs released that contain new voices.
					if self.Options.ShowReminders then
						self:AddMsg(L.VOICE_PACK_OUTDATED)
					end
					SWFilterDisabled = self.VoiceVersions[value]--Set disable to version on current voice pack
				else
					SWFilterDisabled = minVoicePackVersion
				end
			end
		end
	end

	function DBM:PlaySpecialWarningSound(soundId, force)
		local sound
		if not force and self:IsTrivial() and self.Options.DontPlayTrivialSpecialWarningSound then
			sound = self.Options.RaidWarningSound
		else
			sound = type(soundId) == "number" and self.Options["SpecialWarningSound" .. (soundId == 1 and "" or soundId)] or soundId or self.Options.SpecialWarningSound
		end
		self:PlaySoundFile(sound, nil, true)
	end

	local function testWarningEnd()
		frame:SetFrameStrata("HIGH")
	end

	function DBM:ShowTestSpecialWarning(_, number, noSound, force) -- text, number, noSound, force
		if moving then
			return
		end
		self:AddSpecialWarning(L.MOVE_SPECIAL_WARNING_TEXT)
		frame:SetFrameStrata("TOOLTIP")
		self:Unschedule(testWarningEnd)
		self:Schedule(self.Options.SpecialWarningDuration2 * 1.3, testWarningEnd)
		if number and not noSound then
			self:PlaySpecialWarningSound(number, force)
		end
		if number then
			if self.Options["SpecialWarningFlash"..number] then
				if not force and self:IsTrivial() and self.Options.DontPlayTrivialSpecialWarningSound then return end--No flash if trivial
				local flashColor = self.Options["SpecialWarningFlashCol"..number]
				local repeatCount = self.Options["SpecialWarningFlashCount"..number] or 1
				self.Flash:Show(flashColor[1], flashColor[2], flashColor[3], self.Options["SpecialWarningFlashDura"..number], self.Options["SpecialWarningFlashAlph"..number], repeatCount-1)
			end
			if not self.Options.DontDoSpecialWarningVibrate and self.Options["SpecialWarningVibrate"..number] then
				self:VibrateController()
			end
		end
	end
end

--------------------
--  Timer Object  --
--------------------
do
	local timerPrototype = {}
	local mt = {__index = timerPrototype}
	local countvoice1, countvoice2, countvoice3
	local countvoice1max, countvoice2max, countvoice3max = 5, 5, 5
	local countpath1, countpath2, countpath3

	--Merged countdown object for timers with build-in countdown
	function DBM:BuildVoiceCountdownCache()
		countvoice1 = self.Options.CountdownVoice
		countvoice2 = self.Options.CountdownVoice2
		countvoice3 = self.Options.CountdownVoice3
		for _, count in pairs(DBM:GetCountSounds()) do
			if count.value == countvoice1 then
				countpath1 = count.path
				countvoice1max = count.max
			end
			if count.value == countvoice2 then
				countpath2 = count.path
				countvoice2max = count.max
			end
			if count.value == countvoice3 then
				countpath3 = count.path
				countvoice3max = count.max
			end
		end
	end

	local function playCountSound(_, path) -- timerId, path
		DBM:PlaySoundFile(path)
	end

	local function playCountdown(timerId, timer, voice, count)
		if DBM.Options.DontPlayCountdowns then return end
		timer = timer or 10
		count = count or 5
		voice = voice or 1
		if timer <= count then count = floor(timer) end
		if not countpath1 or not countpath2 or not countpath3 then
			DBM:Debug("Voice cache not built at time of playCountdown. On fly caching.", 3)
			DBM:BuildVoiceCountdownCache()
		end
		local maxCount, path
		if type(voice) == "string" then
			maxCount = 5--Safe to assume if it's not one of the built ins, it's likely heroes/OW, which has a max of 5
			path = voice
		elseif voice == 2 then
			maxCount = countvoice2max or 10
			path = countpath2 or "Interface\\AddOns\\DBM-Core\\Sounds\\Overwatch\\Mei\\cn\\"
		elseif voice == 3 then
			maxCount = countvoice3max or 5
			path = countpath3 or "Interface\\AddOns\\DBM-Core\\Sounds\\Overwatch\\Reaper\\"
		else
			maxCount = countvoice1max or 10
			path = countpath1 or "Interface\\AddOns\\DBM-Core\\Sounds\\Corsica\\"
		end
		if not path then--Should not happen but apparently it does somehow
			DBM:Debug("Voice path failed in countdownProtoType:Start.")
			return
		end
		if count == 0 then--If a count of 0 is passed,then it's a "Countout" timer, not "Countdown"
			for i = 1, timer do
				if i < maxCount then
					DBM:Schedule(i, playCountSound, timerId, path..i..".ogg")
				end
			end
		else
			for i = count, 1, -1 do
				if i <= maxCount then
					DBM:Schedule(timer-i, playCountSound, timerId, path..i..".ogg")
				end
			end
		end
	end

	function timerPrototype:Start(timer, ...)
		if DBM.Options.DontShowBossTimers then return end
		if timer and type(timer) ~= "number" then
			return self:Start(nil, timer, ...) -- first argument is optional!
		end
		if not self.option or self.mod.Options[self.option] then
			if self.type and (self.type == "cdcount" or self.type == "nextcount") and not self.allowdouble then--remove previous timer.
				for i = #self.startedTimers, 1, -1 do
					if DBM.Options.BadTimerAlert or DBM.Options.DebugMode and DBM.Options.DebugLevel > 1 then
						local bar = DBT:GetBar(self.startedTimers[i])
						if bar then
							local remaining = ("%.1f"):format(bar.timer)
							local ttext = _G[bar.frame:GetName().."BarName"]:GetText() or ""
							ttext = ttext.."("..self.id..")"
							if bar.timer > 0.2 then
								local phaseText = self.mod.vb.phase and " ("..SCENARIO_STAGE:format(self.mod.vb.phase)..")" or ""
								if DBM.Options.BadTimerAlert and bar.timer > 1 then--If greater than 1 seconds off, report this out of debug mode to all users
									DBM:AddMsg("Timer "..ttext..phaseText.. " refreshed before expired. Remaining time is : "..remaining..". Please report this bug")
									fireEvent("DBM_Debug", "Timer "..ttext..phaseText.. " refreshed before expired. Remaining time is : "..remaining..". Please report this bug", 2)
								else
									DBM:Debug("Timer "..ttext..phaseText.. " refreshed before expired. Remaining time is : "..remaining, 2)
								end
							end
						end
					end
					DBT:CancelBar(self.startedTimers[i])
					fireEvent("DBM_TimerStop", self.startedTimers[i])
					tremove(self.startedTimers, i)
				end
			end
			timer = timer and ((timer > 0 and timer) or self.timer + timer) or self.timer
			local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
			--AI timer api:
			--Starting ai timer with (1) indicates it's a first timer after pull
			--Starting timer with (2) or (3) indicates it's a stage 2 or stage 3 first timer
			--Starting AI timer with anything above 3 indicarets it's a regular timer and to use shortest time in between two regular casts
			if self.type == "ai" then--A learning timer
				if not DBM.Options.AITimer then return end
				if timer > 5 then--Normal behavior.
					local newPhase = false
					for i = 1, 5 do
						--Check for any phase timers that are strings, if a string it means last cast of this ability was first case of a given stage
						if self["phase"..i.."CastTimer"] and type(self["phase"..i.."CastTimer"]) == "string" then--This is first cast of spell, we need to generate self.firstPullTimer
							self["phase"..i.."CastTimer"] = tonumber(self["phase"..i.."CastTimer"])
							self["phase"..i.."CastTimer"] = GetTime() - self["phase"..i.."CastTimer"]--We have generated a self.phase1CastTimer! Next pull, DBM should know timer for first cast next pull. FANCY!
							DBM:Debug("AI timer learned a first timer for current phase of "..self["phase"..i.."CastTimer"], 2)
							newPhase = true
						end
					end
					if self.lastCast and not newPhase then--We have a GetTime() on last cast and it's not affected by a phase change
						local timeLastCast = GetTime() - self.lastCast--Get time between current cast and last cast
						if timeLastCast > 5 then--Prevent infinite loop cpu hang. Plus anything shorter than 5 seconds doesn't need a timer
							if not self.lowestSeenCast or (self.lowestSeenCast and self.lowestSeenCast > timeLastCast) then--Always use lowest seen cast for a timer
								self.lowestSeenCast = timeLastCast
								DBM:Debug("AI timer learned a new lowest timer of "..self.lowestSeenCast, 2)
							end
						end
					end
					self.lastCast = GetTime()
					if self.lowestSeenCast then--Always use lowest seen cast for timer
						timer = self.lowestSeenCast
					else
						return--Don't start the bogus timer shoved into timer field in the mod
					end
				else--AI timer passed with 5 or less is indicating phase change, with timer as phase number
					if not isRetail then
						timer = floor(timer)--Floor inprecise timers in classic because combat is mostly caused by PLAYER_REGEN in dungeons
					end
					if self["phase"..timer.."CastTimer"] and type(self["phase"..timer.."CastTimer"]) == "number" then
						--Check if timer is shorter than previous learned first timer by scanning remaining time on existing bar
						local bar = DBT:GetBar(id)
						if bar then
							local remaining = ("%.1f"):format(bar.timer)
							if bar.timer > 0.2 then
								self["phase"..timer.."CastTimer"] = self["phase"..timer.."CastTimer"] - remaining
								DBM:Debug("AI timer learned a lower first timer for current phase of "..self["phase"..timer.."CastTimer"], 2)
							end
						end
						timer = self["phase"..timer.."CastTimer"]
					else--No first pull timer generated yet, set it to GetTime, as a string
						self["phase"..timer.."CastTimer"] = tostring(GetTime())
						return--Don't start the x second timer
					end
				end
			end
			if DBM.Options.BadTimerAlert or DBM.Options.DebugMode and DBM.Options.DebugLevel > 1 then
				if not self.type or (self.type ~= "target" and self.type ~= "active" and self.type ~= "fades" and self.type ~= "ai") and not self.allowdouble then
					local bar = DBT:GetBar(id)
					if bar then
						local remaining = ("%.1f"):format(bar.timer)
						local ttext = _G[bar.frame:GetName().."BarName"]:GetText() or ""
						ttext = ttext.."("..self.id..")"
						if bar.timer > 0.2 then
							local phaseText = self.mod.vb.phase and " ("..SCENARIO_STAGE:format(self.mod.vb.phase)..")" or ""
							if DBM.Options.BadTimerAlert and bar.timer > 1 then--If greater than 1 seconds off, report this out of debug mode to all users
								DBM:AddMsg("Timer "..ttext..phaseText.. " refreshed before expired. Remaining time is : "..remaining..". Please report this bug")
								fireEvent("DBM_Debug", "Timer "..ttext..phaseText.. " refreshed before expired. Remaining time is : "..remaining..". Please report this bug", 2)
							else
								DBM:Debug("Timer "..ttext..phaseText.. " refreshed before expired. Remaining time is : "..remaining, 2)
							end
						end
					end
				end
			end
			local colorId = 0
			if self.option then
				colorId = self.mod.Options[self.option .. "TColor"]
			elseif self.colorType and type(self.colorType) == "string" then--No option for specific timer, but another bool option given that tells us where to look for TColor
				colorId = self.mod.Options[self.colorType .. "TColor"] or 0
			end
			local countVoice, countVoiceMax = 0, self.countdownMax or 4
			if self.option then
				countVoice = self.mod.Options[self.option .. "CVoice"]
				if not self.fade and (type(countVoice) == "string" or countVoice > 0) then--Started without faded and has count voice assigned
					playCountdown(id, timer, countVoice, countVoiceMax)--timerId, timer, voice, count
				end
			end
			local bar = DBT:CreateBar(timer, id, self.icon, nil, nil, nil, nil, colorId, nil, self.keep, self.fade, countVoice, countVoiceMax)
			if not bar then
				return false, "error" -- creating the timer failed somehow, maybe hit the hard-coded timer limit of 15
			end
			local msg
			if self.type and not self.text then
				msg = pformat(self.mod:GetLocalizedTimerText(self.type, self.spellId, self.name), ...)
			else
				if type(self.text) == "number" then--spellId passed in timer text, it's a timer with short text
					msg = pformat(self.mod:GetLocalizedTimerText(self.type, self.text, self.name), ...)
				else
					msg = pformat(self.text, ...)
				end
			end
			msg = msg:gsub(">.-<", stripServerName)
			bar:SetText(msg, self.inlineIcon)
			--ID: Internal DBM timer ID
			--msg: Timer Text (Do not use msg has an event trigger, it varies language to language or based on user timer options. Use this to DISPLAY only (such as timer replacement UI). use spellId field 99% of time
			--timer: Raw timer value (number).
			--Icon: Texture Path for Icon
			--type: Timer type (Cooldowns: cd, cdcount, nextcount, nextsource, cdspecial, nextspecial, stage, ai. Durations: target, active, fades, roleplay. Casting: cast)
			--spellId: Raw spellid if available (most timers will have spellId or EJ ID unless it's a specific timer not tied to ability such as pull or combat start or rez timers. EJ id will be in format ej%d
			--colorID: Type classification (1-Add, 2-Aoe, 3-targeted ability, 4-Interrupt, 5-Role, 6-Stage, 7-User(custom))
			--Mod ID: Encounter ID as string, or a generic string for mods that don't have encounter ID (such as trash, dummy/test mods)
			--Keep: true or nil, whether or not to keep bar on screen when it expires (if true, timer should be retained until an actual TimerStop occurs or a new TimerStart with same barId happens (in which case you replace bar with new one)
			--fade: true or nil, whether or not to fade a bar (set alpha to usersetting/2)
			--spellName: Sent so users can use a spell name instead of spellId, if they choose. Mostly to be more classic wow friendly, spellID is still preferred method (even for classic)
			--MobGUID if it could be parsed out of args
			local guid
			if select("#", ...) > 0 then--If timer has args
				for i = 1, select("#", ...) do
					local v = select(i, ...)
					if DBM:IsNonPlayableGUID(v) then--Then scan them for a mob guid
						guid = v--If found, guid will be passed in DBM_TimerStart callback
					end
				end
			end
			fireEvent("DBM_TimerStart", id, msg, timer, self.icon, self.type, self.spellId, colorId, self.mod.id, self.keep, self.fade, self.name, guid)
			if not tContains(self.startedTimers, id) then--Make sure timer doesn't exist already before adding it
				tinsert(self.startedTimers, id)
			end
			if not self.keep then--Don't ever remove startedTimers on a schedule, if it's a keep timer
				self.mod:Unschedule(removeEntry, self.startedTimers, id)
				self.mod:Schedule(timer, removeEntry, self.startedTimers, id)
			end
			return bar
		else
			return false, "disabled"
		end
	end
	timerPrototype.Show = timerPrototype.Start

	--A way to set the fade to yes or no, overriding hardcoded value in NewTimer object with temporary one
	--If this method is used, it WILL persist until reload or changing it back
	function timerPrototype:SetFade(fadeOn, ...)
		--Done this way so SetFade can be used with :Start without needless performance cost (ie, ApplyStyle won't run unless it needs to)
		if fadeOn and not self.fade then
			self.fade = true--set timer object metatable, which will make sure next bar started uses fade
			--Find and Update an existing bar that's already started
			local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
			local bar = DBT:GetBar(id)
			if bar and not bar.fade then
				fireEvent("DBM_TimerFadeUpdate", id, self.spellId, self.mod.id, true, self.name)--Timer ID, spellId, modId, true/nil, spellName (new callback only needed if we update an existing timers fade, self.fade is passed in timer start object for new timers)
				bar.fade = true--Set bar object metatable, which is copied from timer metatable at bar start only
				bar:ApplyStyle()
				DBM:Unschedule(playCountSound, id)--Don't even need to check option, it's faster cpu wise to just unschedule countdown either way
			end
		elseif not fadeOn and self.fade then
			self.fade = nil--set timer object metatable, which will make sure next bar started does NOT use fade
			--Find and Update an existing bar that's already started
			local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
			local bar = DBT:GetBar(id)
			if bar and bar.fade then
				fireEvent("DBM_TimerFadeUpdate", id, self.spellId, self.mod.id, nil, self.name)--Timer ID, spellId, modId, true/nil, spellName (new callback only needed if we update an existing timers fade, self.fade is passed in timer start object for new timers)
				bar.fade = nil--Set bar object metatable, which is copied from timer metatable at bar start only
				bar:ApplyStyle()
				if self.option then
					local countVoice = self.mod.Options[self.option .. "CVoice"] or 0
					if (type(countVoice) == "string" or countVoice > 0) then--Unfading bar, start countdown
						DBM:Unschedule(playCountSound, id)
						playCountdown(id, bar.timer, countVoice, bar.countdownMax)--timerId, timer, voice, count
						DBM:Debug("Re-enabling a countdown on bar ID: "..id.." after a SetFade disable call")
					end
				end
			end
		end
	end

	--This version does NOT set timer object meta, only started bar meta
	--Use this if you only want to alter an already STARTED temporarily
	--As such it also only needs fadeOn. fadeoff isn't needed since this temp alter never affects newly started bars
	function timerPrototype:SetSTFade(fadeOn, ...)
		local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
		local bar = DBT:GetBar(id)
		if bar then
			if fadeOn and not bar.fade then
				fireEvent("DBM_TimerFadeUpdate", id, self.spellId, self.mod.id, true, self.name)--Timer ID, spellId, modId, true/nil, spellName (new callback only needed if we update an existing timers fade, self.fade is passed in timer start object for new timers)
				bar.fade = true--Set bar object metatable, which is copied from timer metatable at bar start only
				bar:ApplyStyle()
				DBM:Unschedule(playCountSound, id)
			elseif not fadeOn and bar.fade then
				fireEvent("DBM_TimerFadeUpdate", id, self.spellId, self.mod.id, nil, self.name)
				bar.fade = false
				bar:ApplyStyle()
				if self.option then
					local countVoice = self.mod.Options[self.option .. "CVoice"] or 0
					if (type(countVoice) == "string" or countVoice > 0) then--Unfading bar, start countdown
						DBM:Unschedule(playCountSound, id)
						playCountdown(id, bar.timer, countVoice, bar.countdownMax)--timerId, timer, voice, count
						DBM:Debug("Re-enabling a countdown on bar ID: "..id.." after a SetSTFade disable call")
					end
				end
			end
		end
	end

	function timerPrototype:SetSTKeep(keepOn, ...)
		local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
		local bar = DBT:GetBar(id)
		if bar then
			if keepOn and not bar.keep then
				bar.keep = true--Set bar object metatable, which is copied from timer metatable at bar start only
				bar:ApplyStyle()
			elseif not keepOn and bar.keep then
				fireEvent("DBM_TimerFadeUpdate", id, self.spellId, self.mod.id, nil)
				bar.keep = false
				bar:ApplyStyle()
			end
		end
	end

	function timerPrototype:DelayedStart(delay, ...)
		DBMScheduler:Unschedule(self.Start, self.mod, self, ...)
		DBMScheduler:Schedule(delay or 0.5, self.Start, self.mod, self, ...)
	end
	timerPrototype.DelayedShow = timerPrototype.DelayedStart

	function timerPrototype:Schedule(t, ...)
		return DBMScheduler:Schedule(t, self.Start, self.mod, self, ...)
	end

	function timerPrototype:Unschedule(...)
		return DBMScheduler:Unschedule(self.Start, self.mod, self, ...)
	end

	--TODO, figure out why this function doesn't properly stop count timers when calling stop without count on count timers
	function timerPrototype:Stop(...)
		if select("#", ...) == 0 then
			for i = #self.startedTimers, 1, -1 do
				fireEvent("DBM_TimerStop", self.startedTimers[i])
				DBT:CancelBar(self.startedTimers[i])
				DBM:Unschedule(playCountSound, self.startedTimers[i])--Unschedule countdown by timerId
				tremove(self.startedTimers, i)
			end
		else
			local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
			for i = #self.startedTimers, 1, -1 do
				if self.startedTimers[i] == id then
					local guid
					for j = 1, select("#", ...) do
						local v = select(j, ...)
						if DBM:IsNonPlayableGUID(v) then--Then scan them for a mob guid
							guid = v--If found, guid will be passed in DBM_TimerStart callback
						end
					end
					fireEvent("DBM_TimerStop", id, guid)
					DBT:CancelBar(id)
					DBM:Unschedule(playCountSound, id)--Unschedule countdown by timerId
					tremove(self.startedTimers, i)
				end
			end
		end
		if self.type == "ai" then--A learning timer
			if not DBM.Options.AITimer then return end
			self.lastCast = nil
			for i = 1, 4 do
				--Check for any phase timers that are strings and never got a chance to become AI timers, then wipe them
				if self["phase"..i.."CastTimer"] and type(self["phase"..i.."CastTimer"]) == "string" then
					self["phase"..i.."CastTimer"] = nil
					DBM:Debug("Wiping incomplete new timer of stage "..i, 2)
				end
			end
		end
	end

	function timerPrototype:Cancel(...)
		self:Stop(...)
		self:Unschedule(...)
	end

	function timerPrototype:GetTime(...)
		local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
		local bar = DBT:GetBar(id)
		return bar and (bar.totalTime - bar.timer) or 0, (bar and bar.totalTime) or 0
	end

	function timerPrototype:GetRemaining(...)
		local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
		local bar = DBT:GetBar(id)
		return bar and bar.timer or 0
	end

	function timerPrototype:IsStarted(...)
		local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
		local bar = DBT:GetBar(id)
		return bar and true
	end

	function timerPrototype:SetTimer(timer)
		self.timer = timer
	end

	function timerPrototype:Update(elapsed, totalTime, ...)
		if DBM.Options.DontShowBossTimers then return end
		if self:GetTime(...) == 0 then
			self:Start(totalTime, ...)
		end
		local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
		local bar = DBT:GetBar(id)
		fireEvent("DBM_TimerUpdate", id, elapsed, totalTime)
		if bar and self.option then
			local countVoice = self.mod.Options[self.option .. "CVoice"] or 0
			if (type(countVoice) == "string" or countVoice > 0) then
				DBM:Unschedule(playCountSound, id)
				if not bar.fade then--Don't start countdown voice if it's faded bar
					local newRemaining = totalTime-elapsed
					if newRemaining > 2 then
						playCountdown(id, newRemaining, countVoice, bar.countdownMax)--timerId, timer, voice, count
						DBM:Debug("Updating a countdown after a timer Update call for timer ID:"..id)
					end
				end
			end
		end
		return DBT:UpdateBar(id, elapsed, totalTime)
	end

	function timerPrototype:AddTime(extendAmount, ...)
		if DBM.Options.DontShowBossTimers then return end
		if self:GetTime(...) == 0 then
			return self:Start(extendAmount, ...)
		else
			local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
			local bar = DBT:GetBar(id)
			if bar then
				local elapsed, total = (bar.totalTime - bar.timer), bar.totalTime
				if elapsed and total then
					if self.option then
						local countVoice = self.mod.Options[self.option .. "CVoice"] or 0
						if (type(countVoice) == "string" or countVoice > 0) then
							DBM:Unschedule(playCountSound, id)
							if not bar.fade then--Don't start countdown voice if it's faded bar
								local newRemaining = (total+extendAmount) - elapsed
								playCountdown(id, newRemaining, countVoice, bar.countdownMax)--timerId, timer, voice, count
								DBM:Debug("Updating a countdown after a timer AddTime call for timer ID:"..id)
							end
						end
					end
					fireEvent("DBM_TimerUpdate", id, elapsed, total+extendAmount)
					return DBT:UpdateBar(id, elapsed, total+extendAmount)
				end
			end
		end
	end

	function timerPrototype:RemoveTime(reduceAmount, ...)
		if DBM.Options.DontShowBossTimers then return end
		if self:GetTime(...) == 0 then
			return--Do nothing
		else
			local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
			local bar = DBT:GetBar(id)
			if bar then
				local elapsed, total = (bar.totalTime - bar.timer), bar.totalTime
				if elapsed and total then
					local newRemaining = (total-reduceAmount) - elapsed
					if newRemaining > 0 then
						if self.option and newRemaining > 2 then
							local countVoice = self.mod.Options[self.option .. "CVoice"] or 0
							if (type(countVoice) == "string" or countVoice > 0) then
								DBM:Unschedule(playCountSound, id)
								if not bar.fade then--Don't start countdown voice if it's faded bar
									if newRemaining > 2 then
										playCountdown(id, newRemaining, countVoice, bar.countdownMax)--timerId, timer, voice, count
										DBM:Debug("Updating a countdown after a timer RemoveTime call for timer ID:"..id)
									end
								end
							end
						end
						fireEvent("DBM_TimerUpdate", id, elapsed, total-reduceAmount)
						return DBT:UpdateBar(id, elapsed, total-reduceAmount)
					else--New remaining less than 0
						DBM:Unschedule(playCountSound, id)
						fireEvent("DBM_TimerStop", id)
						return DBT:CancelBar(id)
					end
				end
			end
		end
	end

	function timerPrototype:Pause(...)
		local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
		local bar = DBT:GetBar(id)
		if bar then
			fireEvent("DBM_TimerPause", id)
			return bar:Pause()
		end
	end

	function timerPrototype:Resume(...)
		local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
		local bar = DBT:GetBar(id)
		if bar then
			fireEvent("DBM_TimerResume", id)
			return bar:Resume()
		end
	end

	function timerPrototype:UpdateIcon(icon, ...)
		local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
		local bar = DBT:GetBar(id)
		if bar then
			return bar:SetIcon((type(icon) == "string" and icon:match("ej%d+") and select(4, DBM:EJ_GetSectionInfo(string.sub(icon, 3))) ~= "" and select(4, DBM:EJ_GetSectionInfo(string.sub(icon, 3)))) or (type(icon) == "number" and GetSpellTexture(icon)) or tonumber(icon) or 136116)
		end
	end

	function timerPrototype:UpdateInline(newInline, ...)
		local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
		local bar = DBT:GetBar(id)
		if bar then
			local ttext = _G[bar.frame:GetName().."BarName"]:GetText() or ""
			return bar:SetText(ttext, newInline or self.inlineIcon)
		end
	end

	function timerPrototype:UpdateName(name, ...)
		local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
		local bar = DBT:GetBar(id)
		if bar then
			return bar:SetText(name, self.inlineIcon)
		end
	end

	function timerPrototype:SetColor(c, ...)
		local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
		local bar = DBT:GetBar(id)
		if bar then
			return bar:SetColor(c)
		end
	end

	function timerPrototype:DisableEnlarge(...)
		local id = self.id..pformat((("\t%s"):rep(select("#", ...))), ...)
		local bar = DBT:GetBar(id)
		if bar then
			bar.small = true
		end
	end

	function timerPrototype:AddOption(optionDefault, optionName, colorType, countdown, spellId, optionType)
		if optionName ~= false then
			self.option = optionName or self.id
			self.mod:AddBoolOption(self.option, optionDefault, "timer", nil, colorType, countdown, spellId, optionType)
		end
	end

	--If a new countdown default is added to a NewTimer object, change optionName of timer to reset a new default
	function bossModPrototype:NewTimer(timer, name, texture, optionDefault, optionName, colorType, inlineIcon, keep, countdown, countdownMax, r, g, b)
		if r and type(r) == "string" then
			DBM:Debug("|cffff0000r probably has inline icon in it and needs to be fixed for |r"..name..r)
			r = nil--Fix it for users
		end
		if inlineIcon and type(inlineIcon) == "number" then
			DBM:Debug("|cffff0000spellID texture path or colorType is in inlineIcon field and needs to be fixed for |r"..name..inlineIcon)
			inlineIcon = nil--Fix it for users
		end
		local icon = (type(texture) == "string" and texture:match("ej%d+") and select(4, DBM:EJ_GetSectionInfo(string.sub(texture, 3))) ~= "" and select(4, DBM:EJ_GetSectionInfo(string.sub(texture, 3)))) or (type(texture) == "number" and GetSpellTexture(texture)) or tonumber(texture) or "136116"
		local obj = setmetatable(
			{
				text = self.localization.timers[name],
				timer = timer,
				id = name,
				icon = icon,
				colorType = colorType,
				inlineIcon = inlineIcon,
				keep = keep,
				countdown = countdown,
				countdownMax = countdownMax,
				r = r,
				g = g,
				b = b,
				startedTimers = {},
				mod = self,
			},
			mt
		)
		obj:AddOption(optionDefault, optionName, colorType, countdown)
		tinsert(self.timers, obj)
		return obj
	end

	-- new constructor for the new auto-localized timer types
	-- note that the function might look unclear because it needs to handle different timer types, especially achievement timers need special treatment
	-- If a new countdown is added to an existing timer that didn't have one before, use optionName (number) to force timer to reset defaults by assigning it a new variable
	local function newTimer(self, timerType, timer, spellId, timerText, optionDefault, optionName, colorType, texture, inlineIcon, keep, countdown, countdownMax, r, g, b)
		if type(timer) == "string" and timer:match("OptionVersion") then
			DBM:Debug("|cffff0000OptionVersion hack depricated, remove it from: |r"..spellId)
			return
		end
		if type(colorType) == "number" and colorType > 7 then
			DBM:Debug("|cffff0000texture is in the colorType arg for: |r"..spellId)
		end
		--Use option optionName for optionVersion as well, no reason to split.
		--This ensures that remaining arg positions match for auto generated and regular NewTimer
		local optionVersion
		if type(optionName) == "number" then
			optionVersion = optionName
			optionName = nil
		end
		local allowdouble
		if type(timer) == "string" and timer:match("d%d+") then
			allowdouble = true
			timer = tonumber(string.sub(timer, 2))
		end
		local spellName, icon
		local unparsedId = spellId
		if timerType == "achievement" then
			spellName = select(2, GetAchievementInfo(spellId))
			icon = type(texture) == "number" and select(10, GetAchievementInfo(texture)) or tonumber(texture) or spellId and select(10, GetAchievementInfo(spellId))
		elseif timerType == "cdspecial" or timerType == "nextspecial" or timerType == "stage" then
			icon = type(texture) == "number" and GetSpellTexture(texture) or tonumber(texture) or type(spellId) == "string" and select(4, DBM:EJ_GetSectionInfo(string.sub(spellId, 3))) ~= "" and select(4, DBM:EJ_GetSectionInfo(string.sub(spellId, 3))) or (type(spellId) == "number" and GetSpellTexture(spellId)) or 136116
			if timerType == "stage" then
				colorType = 6
			end
		elseif timerType == "roleplay" then
			icon = type(texture) == "number" and GetSpellTexture(texture) or tonumber(texture) or type(spellId) == "string" and select(4, DBM:EJ_GetSectionInfo(string.sub(spellId, 3))) ~= "" and select(4, DBM:EJ_GetSectionInfo(string.sub(spellId, 3))) or (type(spellId) == "number" and GetSpellTexture(spellId)) or isRetail and 237538 or 136106
			colorType = 6
		elseif timerType == "adds" or timerType == "addscustom" then
			icon = type(texture) == "number" and GetSpellTexture(texture) or tonumber(texture) or type(spellId) == "string" and select(4, DBM:EJ_GetSectionInfo(string.sub(spellId, 3))) ~= "" and select(4, DBM:EJ_GetSectionInfo(string.sub(spellId, 3))) or (type(spellId) == "number" and GetSpellTexture(spellId)) or 136116
			colorType = 1
		else
			if type(spellId) == "string" and spellId:match("ej%d+") then
				spellName = DBM:EJ_GetSectionInfo(string.sub(spellId, 3)) or ""
			else
				spellName = DBM:GetSpellInfo(spellId or 0)
			end
			if spellName then
				icon = type(texture) == "number" and GetSpellTexture(texture) or tonumber(texture) or type(spellId) == "string" and select(4, DBM:EJ_GetSectionInfo(string.sub(spellId, 3))) ~= "" and select(4, DBM:EJ_GetSectionInfo(string.sub(spellId, 3))) or (type(spellId) == "number" and GetSpellTexture(spellId))
			else
				icon = nil
			end
		end
		--spellName = spellName or tostring(spellId)--this actually breaks stuff in 9.0 when spell info fails to return on first try
		local timerTextValue
		if timerText then
			--If timertext is a number, accept it as a secondary auto translate spellid
			if DBM.Options.ShortTimerText and type(timerText) == "number" then
				timerTextValue = timerText
				spellName = DBM:GetSpellInfo(timerText or 0)--Override Cached spell Name
			else
				timerTextValue = self.localization.timers[timerText] or timerText--Check timers table first, otherwise accept it as literal timer text
			end
		end
		local id = "Timer"..(spellId or 0)..timerType..(optionVersion or "")
		local obj = setmetatable(
			{
				text = timerTextValue,
				type = timerType,
				spellId = spellId,
				name = spellName,--If name gets stored as nil, it'll be corrected later in Timer start, if spell name returns in a later attempt
				timer = timer,
				id = id,
				icon = icon,
				colorType = colorType,
				inlineIcon = inlineIcon,
				keep = keep,
				countdown = countdown,
				countdownMax = countdownMax,
				r = r,
				g = g,
				b = b,
				allowdouble = allowdouble,
				startedTimers = {},
				mod = self,
			},
			mt
		)
		obj:AddOption(optionDefault, optionName, colorType, countdown, spellId, timerType)
		tinsert(self.timers, obj)
		-- todo: move the string creation to the GUI with SetFormattedString...
		if timerType == "achievement" then
			self.localization.options[id] = L.AUTO_TIMER_OPTIONS[timerType]:format(GetAchievementLink(spellId):gsub("%[(.+)%]", "%1"))
		elseif timerType == "cdspecial" or timerType == "nextspecial" or timerType == "stage" or timerType == "roleplay" then--Timers without spellid, generic
			self.localization.options[id] = L.AUTO_TIMER_OPTIONS[timerType]--Using more than 1 stage timer or more than 1 special timer will break this, fortunately you should NEVER use more than 1 of either in a mod
		else
			self.localization.options[id] = L.AUTO_TIMER_OPTIONS[timerType]:format(unparsedId)
		end
		return obj
	end

	function bossModPrototype:NewTargetTimer(...)
		return newTimer(self, "target", ...)
	end

	function bossModPrototype:NewTargetCountTimer(...)
		return newTimer(self, "targetcount", ...)
	end

	--Buff/Debuff/event on boss
	function bossModPrototype:NewBuffActiveTimer(...)
		return newTimer(self, "active", ...)
	end

	----Buff/Debuff on players
	function bossModPrototype:NewBuffFadesTimer(...)
		return newTimer(self, "fades", ...)
	end

	function bossModPrototype:NewCastTimer(timer, ...)
		if tonumber(timer) and timer > 1000 then -- hehe :) best hack in DBM. This makes the first argument optional, so we can omit it to use the cast time from the spell id ;)
			local spellId = timer
			timer = select(4, DBM:GetSpellInfo(spellId)) or 1000 -- GetSpellInfo takes YOUR spell haste into account...WTF?
			local spellHaste = select(4, DBM:GetSpellInfo(10059)) / 10000 -- 10059 = Stormwind Portal, should have 10000 ms cast time
			timer = timer / spellHaste -- calculate the real cast time of the spell...
			return self:NewCastTimer(timer / 1000, spellId, ...)
		end
		return newTimer(self, "cast", timer, ...)
	end

	function bossModPrototype:NewCastCountTimer(timer, ...)
		if tonumber(timer) and timer > 1000 then -- hehe :) best hack in DBM. This makes the first argument optional, so we can omit it to use the cast time from the spell id ;)
			local spellId = timer
			timer = select(4, DBM:GetSpellInfo(spellId)) or 1000 -- GetSpellInfo takes YOUR spell haste into account...WTF?
			local spellHaste = select(4, DBM:GetSpellInfo(10059)) / 10000 -- 10059 = Stormwind Portal, should have 10000 ms cast time
			timer = timer / spellHaste -- calculate the real cast time of the spell...
			return self:NewCastTimer(timer / 1000, spellId, ...)
		end
		return newTimer(self, "castcount", timer, ...)
	end

	function bossModPrototype:NewCastSourceTimer(timer, ...)
		if tonumber(timer) and timer > 1000 then -- hehe :) best hack in DBM. This makes the first argument optional, so we can omit it to use the cast time from the spell id ;)
			local spellId = timer
			timer = select(4, DBM:GetSpellInfo(spellId)) or 1000 -- GetSpellInfo takes YOUR spell haste into account...WTF?
			local spellHaste = select(4, DBM:GetSpellInfo(10059)) / 10000 -- 10059 = Stormwind Portal, should have 10000 ms cast time
			timer = timer / spellHaste -- calculate the real cast time of the spell...
			return self:NewCastSourceTimer(timer / 1000, spellId, ...)
		end
		return newTimer(self, "castsource", timer, ...)
	end

	function bossModPrototype:NewCDTimer(...)
		return newTimer(self, "cd", ...)
	end

	function bossModPrototype:NewCDCountTimer(...)
		return newTimer(self, "cdcount", ...)
	end

	function bossModPrototype:NewCDSourceTimer(...)
		return newTimer(self, "cdsource", ...)
	end

	function bossModPrototype:NewNextTimer(...)
		return newTimer(self, "next", ...)
	end

	function bossModPrototype:NewNextCountTimer(...)
		return newTimer(self, "nextcount", ...)
	end

	function bossModPrototype:NewNextSourceTimer(...)
		return newTimer(self, "nextsource", ...)
	end

	function bossModPrototype:NewAchievementTimer(...)
		return newTimer(self, "achievement", ...)
	end

	function bossModPrototype:NewCDSpecialTimer(...)
		return newTimer(self, "cdspecial", ...)
	end

	function bossModPrototype:NewNextSpecialTimer(...)
		return newTimer(self, "nextspecial", ...)
	end

	function bossModPrototype:NewPhaseTimer(...)
		return newTimer(self, "stage", ...)
	end

	function bossModPrototype:NewRPTimer(...)
		return newTimer(self, "roleplay", ...)
	end

	function bossModPrototype:NewAddsTimer(...)
		return newTimer(self, "adds", ...)
	end

	function bossModPrototype:NewAddsCustomTimer(...)
		return newTimer(self, "addscustom", ...)
	end

	function bossModPrototype:NewAITimer(...)
		return newTimer(self, "ai", ...)
	end

	function bossModPrototype:GetLocalizedTimerText(timerType, spellId, Name)
		local spellName
		if Name then
			spellName = Name--Pull from name stored in object
		elseif spellId then
			DBM:Debug("|cffff0000GetLocalizedTimerText fallback, this should not happen and is a bug. this fallback should be deleted if this message is never seen after async code is live|r")
			if timerType == "achievement" then
				spellName = select(2, GetAchievementInfo(spellId))
			elseif type(spellId) == "string" and spellId:match("ej%d+") then
				spellName = DBM:EJ_GetSectionInfo(string.sub(spellId, 3))
			else
				spellName = DBM:GetSpellInfo(spellId)
			end
			--Name wasn't provided, but we succeeded in getting a name, generate one into object now for caching purposes
			--This would really only happen if GetSpellInfo failed to return spell name on first attempt (which now happens in 9.0)
			if spellName then
				self.name = spellName
			end
		end
		return pformat(L.AUTO_TIMER_TEXTS[timerType], spellName)
	end
end

------------------------------
--  Berserk/Combat Objects  --
------------------------------
do
	local enragePrototype = {}
	local mt = {__index = enragePrototype}

	function enragePrototype:Start(timer)
		timer = timer or self.timer or 600
		timer = timer <= 0 and self.timer - timer or timer
		self.bar:SetTimer(timer)
		self.bar:Start()
		if self.warning1 then
			if timer > 660 then self.warning1:Schedule(timer - 600, 10, L.MIN) end
			if timer > 300 then self.warning1:Schedule(timer - 300, 5, L.MIN) end
			if timer > 180 then self.warning2:Schedule(timer - 180, 3, L.MIN) end
		end
		if self.warning2 then
			if timer > 60 then self.warning2:Schedule(timer - 60, 1, L.MIN) end
			if timer > 30 then self.warning2:Schedule(timer - 30, 30, L.SEC) end
			if timer > 10 then self.warning2:Schedule(timer - 10, 10, L.SEC) end
		end
	end

	function enragePrototype:Schedule(t)
		return self.owner:Schedule(t, self.Start, self)
	end

	function enragePrototype:Cancel()
		self.owner:Unschedule(self.Start, self)
		if self.warning1 then
			self.warning1:Cancel()
		end
		if self.warning2 then
			self.warning2:Cancel()
		end
		self.bar:Stop()
	end
	enragePrototype.Stop = enragePrototype.Cancel

	function bossModPrototype:NewBerserkTimer(timer, text, barText, barIcon)
		timer = timer or 600
		local warning1 = self:NewAnnounce(text or L.GENERIC_WARNING_BERSERK, 1, nil, "warning_berserk", false)
		local warning2 = self:NewAnnounce(text or L.GENERIC_WARNING_BERSERK, 4, nil, "warning_berserk", false)
		local bar = self:NewTimer(timer, barText or L.GENERIC_TIMER_BERSERK, barIcon or 28131, nil, "timer_berserk")
		local obj = setmetatable(
			{
				warning1 = warning1,
				warning2 = warning2,
				bar = bar,
				timer = timer,
				owner = self
			},
			mt
		)
		return obj
	end

	function bossModPrototype:NewCombatTimer(timer, _, barText, barIcon) -- timer, text, barText, barIcon
		timer = timer or 10
		--NewTimer(timer, name, texture, optionDefault, optionName, colorType, inlineIcon, keep, countdown, countdownMax, r, g, b)
		local bar = self:NewTimer(timer, barText or L.GENERIC_TIMER_COMBAT, barIcon or "132349", nil, "timer_combat", nil, nil, nil, 1, 5)
		local obj = setmetatable(
			{
				bar = bar,
				timer = timer,
				owner = self
			},
			mt
		)
		return obj
	end
end

---------------
--  Options  --
---------------
function bossModPrototype:AddBoolOption(name, default, cat, func, extraOption, extraOptionTwo, spellId, optionType)
	cat = cat or "misc"
	self.DefaultOptions[name] = (default == nil) or default
	if cat == "timer" then
		self.DefaultOptions[name.."TColor"] = extraOption or 0
		self.DefaultOptions[name.."CVoice"] = extraOptionTwo or 0
	end
	if default and type(default) == "string" then
		default = self:GetRoleFlagValue(default)
	end
	self.Options[name] = (default == nil) or default
	if cat == "timer" then
		self.Options[name.."TColor"] = extraOption or 0
		self.Options[name.."CVoice"] = extraOptionTwo or 0
	end
	if spellId then
		if optionType and optionType == "achievement" then
			spellId = "at"..spellId--"at" for achievement timer
		end
		self:GroupSpells(spellId, name)
	end
	self:SetOptionCategory(name, cat, optionType)
	if func then
		self.optionFuncs = self.optionFuncs or {}
		self.optionFuncs[name] = func
	end
end

function bossModPrototype:AddSpecialWarningOption(name, default, defaultSound, cat, spellId, optionType)
	cat = cat or "misc"
	self.DefaultOptions[name] = (default == nil) or default
	self.DefaultOptions[name.."SWSound"] = defaultSound or 1
	self.DefaultOptions[name.."SWNote"] = true
	if default and type(default) == "string" then
		default = self:GetRoleFlagValue(default)
	end
	self.Options[name] = (default == nil) or default
	self.Options[name.."SWSound"] = defaultSound or 1
	self.Options[name.."SWNote"] = true
	if spellId then
		self:GroupSpells(spellId, name)
	end
	self:SetOptionCategory(name, cat, optionType)
end

--Extended Icon Usage Notes
--Any time extended icons is used, option must be OFF by default
--Option must be hidden from GUI if extended icoins not enabled
--If extended icons are disabled, then on mod load, users option is reset to default (off) to prevent their mod from still executing SetIcon functions (this is because even if it's hidden from GUI, if option was created and enabled, it'd still run)
function bossModPrototype:AddSetIconOption(name, spellId, default, isHostile, iconsUsed, conflictWarning)
	self.DefaultOptions[name] = (default == nil) or default
	if default and type(default) == "string" then
		default = self:GetRoleFlagValue(default)
	end
	self.Options[name] = (default == nil) or default
	if not DBM.Options.GroupOptionsExcludeIcon then
		self:GroupSpells(spellId, name)
	end
	self:SetOptionCategory(name, "icon")
	if isHostile then
		if not self.findFastestComputer then
			self.findFastestComputer = {}
		end
		self.findFastestComputer[#self.findFastestComputer + 1] = name
		self.localization.options[name] = L.AUTO_ICONS_OPTION_TEXT2:format(spellId)
	else
		self.localization.options[name] = L.AUTO_ICONS_OPTION_TEXT:format(spellId)
	end
	--A table defining used icons by number, insert icon textures to end of option
	if iconsUsed then
		self.localization.options[name] = self.localization.options[name].." ("
		for i=1, #iconsUsed do
			--Texture ID 137009 if direct calling RaidTargetingIcons stops working one day
			if 		iconsUsed[i] == 1 then		self.localization.options[name] = self.localization.options[name].."|TInterface\\TargetingFrame\\UI-RaidTargetingIcons.blp:13:13:0:0:64:64:0:16:0:16|t"
			elseif	iconsUsed[i] == 2 then		self.localization.options[name] = self.localization.options[name].."|TInterface\\TargetingFrame\\UI-RaidTargetingIcons.blp:13:13:0:0:64:64:16:32:0:16|t"
			elseif	iconsUsed[i] == 3 then		self.localization.options[name] = self.localization.options[name].."|TInterface\\TargetingFrame\\UI-RaidTargetingIcons.blp:13:13:0:0:64:64:32:48:0:16|t"
			elseif	iconsUsed[i] == 4 then		self.localization.options[name] = self.localization.options[name].."|TInterface\\TargetingFrame\\UI-RaidTargetingIcons.blp:13:13:0:0:64:64:48:64:0:16|t"
			elseif	iconsUsed[i] == 5 then		self.localization.options[name] = self.localization.options[name].."|TInterface\\TargetingFrame\\UI-RaidTargetingIcons.blp:13:13:0:0:64:64:0:16:16:32|t"
			elseif	iconsUsed[i] == 6 then		self.localization.options[name] = self.localization.options[name].."|TInterface\\TargetingFrame\\UI-RaidTargetingIcons.blp:13:13:0:0:64:64:16:32:16:32|t"
			elseif	iconsUsed[i] == 7 then		self.localization.options[name] = self.localization.options[name].."|TInterface\\TargetingFrame\\UI-RaidTargetingIcons.blp:13:13:0:0:64:64:32:48:16:32|t"
			elseif	iconsUsed[i] == 8 then		self.localization.options[name] = self.localization.options[name].."|TInterface\\TargetingFrame\\UI-RaidTargetingIcons.blp:13:13:0:0:64:64:48:64:16:32|t"
--			elseif	iconsUsed[i] == 9 then		self.localization.options[name] = self.localization.options[name].."|TInterface\\TargetingFrame\\UI-RaidTargetingIcons.blp:13:13:0:0:64:64:0:16:32:48|t"
--			elseif	iconsUsed[i] == 10 then		self.localization.options[name] = self.localization.options[name].."|TInterface\\TargetingFrame\\UI-RaidTargetingIcons.blp:13:13:0:0:64:64:16:32:32:48|t"
--			elseif	iconsUsed[i] == 11 then		self.localization.options[name] = self.localization.options[name].."|TInterface\\TargetingFrame\\UI-RaidTargetingIcons.blp:13:13:0:0:64:64:32:48:32:48|t"
--			elseif	iconsUsed[i] == 12 then		self.localization.options[name] = self.localization.options[name].."|TInterface\\TargetingFrame\\UI-RaidTargetingIcons.blp:13:13:0:0:64:64:48:64:32:48|t"
--			elseif	iconsUsed[i] == 13 then		self.localization.options[name] = self.localization.options[name].."|TInterface\\TargetingFrame\\UI-RaidTargetingIcons.blp:13:13:0:0:64:64:0:16:48:64|t"
--			elseif	iconsUsed[i] == 14 then		self.localization.options[name] = self.localization.options[name].."|TInterface\\TargetingFrame\\UI-RaidTargetingIcons.blp:13:13:0:0:64:64:16:32:48:64|t"
--			elseif	iconsUsed[i] == 15 then		self.localization.options[name] = self.localization.options[name].."|TInterface\\TargetingFrame\\UI-RaidTargetingIcons.blp:13:13:0:0:64:64:32:48:48:64|t"
--			elseif	iconsUsed[i] == 16 then		self.localization.options[name] = self.localization.options[name].."|TInterface\\TargetingFrame\\UI-RaidTargetingIcons.blp:13:13:0:0:64:64:48:64:48:64|t"
			end
		end
		self.localization.options[name] = self.localization.options[name]..")"
		if conflictWarning then
			self.localization.options[name] = self.localization.options[name] .. L.AUTO_ICONS_OPTION_CONFLICT
		end
	end
end

function bossModPrototype:AddArrowOption(name, spellId, default, isRunTo)
	if isRunTo == true then isRunTo = 2 end--Support legacy
	self.DefaultOptions[name] = (default == nil) or default
	if default and type(default) == "string" then
		default = self:GetRoleFlagValue(default)
	end
	self.Options[name] = (default == nil) or default
	self:GroupSpells(spellId, name)
	self:SetOptionCategory(name, "misc")
	if isRunTo == 2 then
		self.localization.options[name] = L.AUTO_ARROW_OPTION_TEXT:format(spellId)
	elseif isRunTo == 3 then
		self.localization.options[name] = L.AUTO_ARROW_OPTION_TEXT3:format(spellId)
	else
		self.localization.options[name] = L.AUTO_ARROW_OPTION_TEXT2:format(spellId)
	end
end

function bossModPrototype:AddRangeFrameOption(range, spellId, default)
	self.DefaultOptions["RangeFrame"] = (default == nil) or default
	if default and type(default) == "string" then
		default = self:GetRoleFlagValue(default)
	end
	self.Options["RangeFrame"] = (default == nil) or default
	if spellId then
		self:GroupSpells(spellId, "RangeFrame")
		self.localization.options["RangeFrame"] = L.AUTO_RANGE_OPTION_TEXT:format(range, spellId)
	else
		self.localization.options["RangeFrame"] = L.AUTO_RANGE_OPTION_TEXT_SHORT:format(range)
	end
	self:SetOptionCategory("RangeFrame", "misc")
end

function bossModPrototype:AddHudMapOption(name, spellId, default)
	self.DefaultOptions[name] = (default == nil) or default
	if default and type(default) == "string" then
		default = self:GetRoleFlagValue(default)
	end
	self.Options[name] = (default == nil) or default
	if spellId then
		self:GroupSpells(spellId, name)
		self.localization.options[name] = L.AUTO_HUD_OPTION_TEXT:format(spellId)
	else
		self.localization.options[name] = L.AUTO_HUD_OPTION_TEXT_MULTI
	end
	self:SetOptionCategory(name, "misc")
end

function bossModPrototype:AddNamePlateOption(name, spellId, default)
	if not spellId then
		error("AddNamePlateOption must provide valid spellId", 2)
	end
	self.DefaultOptions[name] = (default == nil) or default
	if default and type(default) == "string" then
		default = self:GetRoleFlagValue(default)
	end
	self.Options[name] = (default == nil) or default
	self:GroupSpells(spellId, name)
	self:SetOptionCategory(name, "nameplate")
	self.localization.options[name] = L.AUTO_NAMEPLATE_OPTION_TEXT:format(spellId)
end

function bossModPrototype:AddInfoFrameOption(spellId, default, optionVersion, optionalThreshold)
	local oVersion = ""
	if optionVersion then
		oVersion = tostring(optionVersion)
	end
	self.DefaultOptions["InfoFrame"..oVersion] = (default == nil) or default
	if default and type(default) == "string" then
		default = self:GetRoleFlagValue(default)
	end
	self.Options["InfoFrame"..oVersion] = (default == nil) or default
	if spellId then
		self:GroupSpells(spellId, "InfoFrame" .. oVersion)
		if optionalThreshold then
			self.localization.options["InfoFrame"..oVersion] = L.AUTO_INFO_FRAME_OPTION_TEXT3:format(spellId, optionalThreshold)
		else
			self.localization.options["InfoFrame"..oVersion] = L.AUTO_INFO_FRAME_OPTION_TEXT:format(spellId)
		end
	else
		self.localization.options["InfoFrame"..oVersion] = L.AUTO_INFO_FRAME_OPTION_TEXT2
	end
	self:SetOptionCategory("InfoFrame"..oVersion, "misc")
end

function bossModPrototype:AddReadyCheckOption(questId, default, maxLevel)
	self.readyCheckQuestId = questId
	self.readyCheckMaxLevel = maxLevel or 999
	self.DefaultOptions["ReadyCheck"] = (default == nil) or default
	if default and type(default) == "string" then
		default = self:GetRoleFlagValue(default)
	end
	self.Options["ReadyCheck"] = (default == nil) or default
	self.localization.options["ReadyCheck"] = L.AUTO_READY_CHECK_OPTION_TEXT
	self:SetOptionCategory("ReadyCheck", "misc")
end

function bossModPrototype:AddSpeedClearOption(name, default)
	self.DefaultOptions["SpeedClearTimer"] = (default == nil) or default
	if default and type(default) == "string" then
		default = self:GetRoleFlagValue(default)
	end
	self.Options["SpeedClearTimer"] = (default == nil) or default
	self:SetOptionCategory("SpeedClearTimer", "timer")
	self.localization.options["SpeedClearTimer"] = L.AUTO_SPEEDCLEAR_OPTION_TEXT:format(name)
end

-- FIXME: this function does not reset any settings to default if you remove an option in a later revision and a user has selected this option in an earlier revision were it still was available
-- this will be fixed as soon as it is necessary due to removed options ;-)
function bossModPrototype:AddDropdownOption(name, options, default, cat, func, spellId)
	cat = cat or "misc"
	self.DefaultOptions[name] = {type = "dropdown", value = default}
	self.Options[name] = default
	if spellId then
		self:GroupSpells(spellId, name)
	end
	self:SetOptionCategory(name, cat)
	self.dropdowns = self.dropdowns or {}
	self.dropdowns[name] = options
	if func then
		self.optionFuncs = self.optionFuncs or {}
		self.optionFuncs[name] = func
	end
end

function bossModPrototype:AddOptionSpacer(cat)
	cat = cat or "misc"
	if self.optionCategories[cat] then
		tinsert(self.optionCategories[cat], DBM_OPTION_SPACER)
	end
end

do
	local lineCount = 1

	function bossModPrototype:AddOptionLine(text, cat, forceIgnore)
		if self.addon and not self.addon.oldOptions and DBM.Options.GroupOptionsBySpell and not forceIgnore then
			self.groupOptions["line" .. lineCount] = text
			lineCount = lineCount + 1
		else
			cat = cat or "misc"
			if not self.optionCategories[cat] then
				self.optionCategories[cat] = {}
			end
			if self.optionCategories[cat] then
				tinsert(self.optionCategories[cat], {line = true, text = text})
			end
		end
	end
end

function bossModPrototype:AddAnnounceSpacer()
	return self:AddOptionSpacer("announce")
end

function bossModPrototype:AddTimerSpacer()
	return self:AddOptionSpacer("timer")
end

function bossModPrototype:AddAnnounceLine(text)
	return self:AddOptionLine(text, "announce")
end

function bossModPrototype:AddTimerLine(text)
	return self:AddOptionLine(text, "timer")
end

function bossModPrototype:AddNamePlateLine(text)
	return self:AddOptionLine(text, "nameplate")
end

function bossModPrototype:AddIconLine(text)
	return self:AddOptionLine(text, "icon")
end

function bossModPrototype:AddMiscLine(text)
	return self:AddOptionLine(text, "misc", true)
end

function bossModPrototype:RemoveOption(name)
	self.Options[name] = nil
	for k, options in pairs(self.optionCategories) do
		removeEntry(options, name)
		if #options == 0 then
			self.optionCategories[k] = nil
		end
	end
	if self.optionFuncs then
		self.optionFuncs[name] = nil
	end
end

function bossModPrototype:GroupSpells(...)
	local spells = {...}
	local catSpell = tostring(tremove(spells, 1))
	if not self.groupSpells[catSpell] then
		self.groupSpells[catSpell] = {}
	end
	for _, spell in ipairs(spells) do
		local sSpell = tostring(spell)
		self.groupSpells[sSpell] = catSpell
		if sSpell ~= catSpell and self.groupOptions[sSpell] then
			if not self.groupOptions[catSpell] then
				self.groupOptions[catSpell] = {}
			end
			for _, spell2 in ipairs(self.groupOptions[sSpell]) do
				tinsert(self.groupOptions[catSpell], spell2)
			end
			self.groupOptions[sSpell] = nil
		end
	end
end

function bossModPrototype:SetOptionCategory(name, cat, optionType)
	optionType = optionType or ""
	for _, options in pairs(self.optionCategories) do
		removeEntry(options, name)
	end
	if self.addon and not self.addon.oldOptions and DBM.Options.GroupOptionsBySpell and self.groupSpells[name] and not (optionType == "gtfo" or optionType == "adds" or optionType == "addscustom" or optionType:find("stage") or cat == "icon" and DBM.Options.GroupOptionsExcludeIcon) then
		local sSpell = self.groupSpells[name]
		if not self.groupOptions[sSpell] then
			self.groupOptions[sSpell] = {}
		end
		tinsert(self.groupOptions[sSpell], name)
	else
		if not self.optionCategories[cat] then
			self.optionCategories[cat] = {}
		end
		tinsert(self.optionCategories[cat], name)
		tinsert(self.categorySort, cat)
	end
end

--------------
--  Combat  --
--------------
function bossModPrototype:RegisterCombat(cType, ...)
	if cType then
		cType = cType:lower()
	end
	local info = {
		type = cType,
		mob = self.creatureId,
		eId = self.encounterId,
		name = self.localization.general.name or self.id,
		msgs = (cType ~= "combat") and {...},
		mod = self
	}
	if self.multiMobPullDetection then
		info.multiMobPullDetection = self.multiMobPullDetection
	end
	if self.multiEncounterPullDetection then
		info.multiEncounterPullDetection = self.multiEncounterPullDetection
	end
	if self.noESDetection then
		info.noESDetection = self.noESDetection
	end
	if self.noEEDetection then
		info.noEEDetection = self.noEEDetection
	end
	if self.noBKDetection then
		info.noBKDetection = self.noBKDetection
	end
	if self.noIEEUDetection then
		info.noIEEUDetection = self.noIEEUDetection
	end
	if self.noFriendlyEngagement then
		info.noFriendlyEngagement = self.noFriendlyEngagement
	end
	if self.noRegenDetection then
		info.noRegenDetection = self.noRegenDetection
	end
	if self.WBEsync then
		info.WBEsync = self.WBEsync
	end
	if self.noBossDeathKill then
		info.noBossDeathKill = self.noBossDeathKill
	end
	-- use pull-mobs as kill mobs by default, can be overriden by RegisterKill
	if self.multiMobPullDetection then
		for _, v in ipairs(self.multiMobPullDetection) do
			info.killMobs = info.killMobs or {}
			info.killMobs[v] = true
		end
	end
	self.combatInfo = info
	if not self.zones then return end
	for v in pairs(self.zones) do
		combatInfo[v] = combatInfo[v] or {}
		tinsert(combatInfo[v], info)
	end
end

-- needs to be called _AFTER_ RegisterCombat
function bossModPrototype:RegisterKill(msgType, ...)
	if not self.combatInfo then
		error("mod.combatInfo not yet initialized, use mod:RegisterCombat before using this method", 2)
	end
	if msgType == "kill" then
		if select("#", ...) > 0 then -- calling this method with 0 IDs means "use the values from SetCreatureID", this is already done by RegisterCombat as calling RegisterKill should be optional --> mod:RegisterKill("kill") with no IDs is never necessary
			self.combatInfo.killMobs = {}
			for i = 1, select("#", ...) do
				local v = select(i, ...)
				if type(v) == "number" then
					self.combatInfo.killMobs[v] = true
				end
			end
		end
	else
		self.combatInfo.killType = msgType
		self.combatInfo.killMsgs = {}
		for i = 1, select("#", ...) do
			local v = select(i, ...)
			self.combatInfo.killMsgs[v] = true
		end
	end
end

function bossModPrototype:SetDetectCombatInVehicle(flag)
	if not self.combatInfo then
		error("mod.combatInfo not yet initialized, use mod:RegisterCombat before using this method", 2)
	end
	self.combatInfo.noCombatInVehicle = not flag
end

function bossModPrototype:SetCreatureID(...)
	self.creatureId = ...
	if select("#", ...) > 1 then
		self.multiMobPullDetection = {...}
		if self.combatInfo then
			self.combatInfo.multiMobPullDetection = self.multiMobPullDetection
			self.numBoss = #self.multiMobPullDetection
			if self.inCombat then
				--Called mid combat, fix some variables
				self.vb.bossLeft = self.numBoss
			end
		end
		for i = 1, select("#", ...) do
			local cId = select(i, ...)
			bossIds[cId] = true
		end
	else
		local cId = ...
		bossIds[cId] = true
		self.numBoss = 1
	end
end

function bossModPrototype:SetEncounterID(...)
	self.encounterId = ...
	if select("#", ...) > 1 then
		self.multiEncounterPullDetection = {...}
		if self.combatInfo then
			self.combatInfo.multiEncounterPullDetection = self.multiEncounterPullDetection
		end
	end
end

function bossModPrototype:DisableESCombatDetection()
	self.noESDetection = true
	if self.combatInfo then
		self.combatInfo.noESDetection = true
	end
end

function bossModPrototype:DisableEEKillDetection()
	self.noEEDetection = true
	if self.combatInfo then
		self.combatInfo.noEEDetection = true
	end
end

function bossModPrototype:DisableBKKillDetection()
	self.noBKDetection = true
	if self.combatInfo then
		self.combatInfo.noBKDetection = true
	end
end

function bossModPrototype:DisableIEEUCombatDetection()
	self.noIEEUDetection = true
	if self.combatInfo then
		self.combatInfo.noIEEUDetection = true
	end
end

function bossModPrototype:DisableFriendlyDetection()
	self.noFriendlyEngagement = true
	if self.combatInfo then
		self.combatInfo.noFriendlyEngagement = true
	end
end

function bossModPrototype:DisableRegenDetection()
	self.noRegenDetection = true
	if self.combatInfo then
		self.combatInfo.noRegenDetection = true
	end
end

function bossModPrototype:EnableWBEngageSync()
	self.WBEsync = true
	if self.combatInfo then
		self.combatInfo.WBEsync = true
	end
end

function bossModPrototype:IsInCombat()
	return self.inCombat
end

function bossModPrototype:IsAlive()
	return not UnitIsDeadOrGhost("player")
end

function bossModPrototype:SetMinCombatTime(t)
	self.minCombatTime = t
end

-- needs to be called after RegisterCombat
function bossModPrototype:SetWipeTime(t)
	if not self.combatInfo then
		error("mod.combatInfo not yet initialized, use mod:RegisterCombat before using this method", 2)
	end
	self.combatInfo.wipeTimer = t
end

-- fix for LFR ToES Tsulong combat detection bug after killed.
function bossModPrototype:SetReCombatTime(t, t2)--T1, after kill. T2 after wipe
	self.reCombatTime = t
	self.reCombatTime2 = t2
end

function bossModPrototype:SetOOCBWComms()
	tinsert(oocBWComms, self)
end

-----------------------
--  Synchronization  --
-----------------------
function bossModPrototype:SendSync(event, ...)
	event = event or ""
	local arg = select("#", ...) > 0 and strjoin("\t", tostringall(...)) or ""
	local str = ("%s\t%s\t%s\t%s"):format(self.id, self.revision or 0, event, arg)
	local spamId = self.id .. event .. arg -- *not* the same as the sync string, as it doesn't use the revision information
	local time = GetTime()
	--Mod syncs are more strict and enforce latency threshold always.
	--Do not put latency check in main sendSync local function (line 313) though as we still want to get version information, etc from these users.
	if not private.modSyncSpam[spamId] or (time - private.modSyncSpam[spamId]) > 8 then
		self:ReceiveSync(event, nil, self.revision or 0, tostringall(...))
		sendSync("M", str)
	end
end

function bossModPrototype:SendBigWigsSync(msg, extra)
	msg = "B^".. msg
	if extra then
		msg = msg .."^".. extra
	end
	if IsInGroup() then
		SendAddonMessage("BigWigs", msg, IsInGroup(2) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or "PARTY")
	end
end

function bossModPrototype:ReceiveSync(event, sender, revision, ...)
	local spamId = self.id .. event .. strjoin("\t", ...)
	local time = GetTime()
	if (not private.modSyncSpam[spamId] or (time - private.modSyncSpam[spamId]) > self.SyncThreshold) and self.OnSync and (not (self.blockSyncs and sender)) and (not sender or (not self.minSyncRevision or revision >= self.minSyncRevision)) then
		private.modSyncSpam[spamId] = time
		-- we have to use the sender as last argument for compatibility reasons (stupid old API...)
		-- avoid table allocations for frequently used number of arguments
		if select("#", ...) <= 1 then
			-- syncs with no arguments have an empty argument (also for compatibility reasons)
			self:OnSync(event, ... or "", sender)
		elseif select("#", ...) == 2 then
			self:OnSync(event, ..., select(2, ...), sender)
		else
			local tmp = { ... }
			tmp[#tmp + 1] = sender
			self:OnSync(event, unpack(tmp))
		end
	end
end

function bossModPrototype:SetRevision(revision)
	revision = parseCurseDate(revision or "")
	if not revision or type(revision) == "string" then
		-- bad revision: either forgot the svn keyword or using github
		revision = DBM.Revision
	end
	self.revision = revision
end

--Either treat it as a valid number, or a curse string that needs to be made into a valid number
function bossModPrototype:SetMinSyncRevision(revision)
	self.minSyncRevision = (type(revision or "") == "number") and revision or parseCurseDate(revision)
end

function bossModPrototype:SetHotfixNoticeRev(revision)
	self.hotfixNoticeRev = (type(revision or "") == "number") and revision or parseCurseDate(revision)
end

-----------------
--  Scheduler  --
-----------------
function bossModPrototype:Schedule(t, f, ...)
	return DBMScheduler:Schedule(t, f, self, ...)
end

function bossModPrototype:Unschedule(f, ...)
	return DBMScheduler:Unschedule(f, self, ...)
end

function bossModPrototype:ScheduleMethod(t, method, ...)
	if not self[method] then
		error(("Method %s does not exist"):format(tostring(method)), 2)
	end
	return self:Schedule(t, self[method], self, ...)
end
bossModPrototype.ScheduleEvent = bossModPrototype.ScheduleMethod

function bossModPrototype:UnscheduleMethod(method, ...)
	if not self[method] then
		error(("Method %s does not exist"):format(tostring(method)), 2)
	end
	return self:Unschedule(self[method], self, ...)
end
bossModPrototype.UnscheduleEvent = bossModPrototype.UnscheduleMethod

-------------
--  Icons  --
-------------
do
	local iconsModule = private:GetModule("Icons")

	function bossModPrototype:SetIcon(...)
		return iconsModule:SetIcon(self, ...)
	end

	function bossModPrototype:SetIconByAlphaTable(...)
		return iconsModule:SetIconByAlphaTable(self, ...)
	end

	function bossModPrototype:SetAlphaIcon(...)
		return iconsModule:SetAlphaIcon(self, ...)
	end

	function bossModPrototype:SetIconBySortedTable(...)
		return iconsModule:SetIconBySortedTable(self, ...)
	end

	function bossModPrototype:SetSortedIcon(...)
		return iconsModule:SetSortedIcon(self, ...)
	end

	function bossModPrototype:ScanForMobs(...)
		return iconsModule:ScanForMobs(self, ...)
	end

	function bossModPrototype:RemoveIcon(...)
		return iconsModule:RemoveIcon(self, ...)
	end

	bossModPrototype.GetIcon = iconsModule.GetIcon
	bossModPrototype.ClearIcons = iconsModule.ClearIcons
	bossModPrototype.CanSetIcon = iconsModule.CanSetIcon
end

-----------------------
--  Model Functions  --
-----------------------
function bossModPrototype:SetModelScale(scale)
	self.modelScale = scale
end

function bossModPrototype:SetModelOffset(x, y, z)
	self.modelOffsetX = x
	self.modelOffsetY = y
	self.modelOffsetZ = z
end

function bossModPrototype:SetModelRotation(r)
	self.modelRotation = r
end

function bossModPrototype:SetModelSequence(v)
	self.modelSequence = v
end

function bossModPrototype:SetModelID(id)
	self.modelId = id
end

function bossModPrototype:SetModelSound(long, short)--PlaySoundFile prototype for model viewer, long is long sound, short is a short clip, configurable in UI, both sound paths defined in boss mods.
	self.modelSoundLong = long
	self.modelSoundShort = short
end

function bossModPrototype:GetLocalizedStrings()
	self.localization.miscStrings.name = self.localization.general.name
	return self.localization.miscStrings
end
