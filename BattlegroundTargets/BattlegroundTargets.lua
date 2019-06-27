-- -------------------------------------------------------------------------- --
-- BattlegroundTargets by kunda
-- modified & reuploaded by petergripihn
-- -------------------------------------------------------------------------- --
--                                                                            --
-- Features:                                                                  --
-- # Shows all battleground players with role, spec and class                 --
--   - Left-click : set target                                                --
--   - Right-click: set focus                                                 --
-- # Independent settings for '10v10', '15v15' and '40v40'                    --
-- # Independent settings for 'Friend' and 'Enemy'                            --
-- # Target                                                                   --
-- # Target of Target                                                         --
-- # Main Assist Target                                                       --
-- # Focus                                                                    --
-- # Flag/Orb/Cart Carrier                                                    --
-- # Target Count                                                             --
-- # Health                                                                   --
-- # Range Check                                                              --
-- # PvP Trinket Timer                                                        --
--                                                                            --
-- -------------------------------------------------------------------------- --
--                                                                            --
-- These events are always registered:                                        --
-- - PLAYER_REGEN_DISABLED                                                    --
-- - PLAYER_REGEN_ENABLED                                                     --
-- - ZONE_CHANGED_NEW_AREA (to determine if current zone is a battleground)   --
-- - PLAYER_LEVEL_UP (only registered if playerLevel < maxLevel)              --
--                                                                            --
-- Registered events in battleground:                                         --
-- # If enabled: ------------------------------------------------------------ --
--   - UPDATE_BATTLEFIELD_SCORE                                               --
--   - GROUP_ROSTER_UPDATE                                                    --
--   - PLAYER_DEAD                                                            --
--   - PLAYER_UNGHOST                                                         --
--   - PLAYER_ALIVE                                                           --
--                                                                            --
-- # Range Check: ----------------------------------------------------------- --
--   - Events:             - COMBAT_LOG_EVENT_UNFILTERED (Enemy only)         --
--                         - PLAYER_TARGET_CHANGED                            --
--                         - UNIT_HEALTH_FREQUENT                             --
--                         - UPDATE_MOUSEOVER_UNIT                            --
--                         - UNIT_TARGET                                      --
--   - The data to determine the distance to an enemy is not always available.--
--     This is restricted by the WoW API.                                     --
--   - This feature is a compromise between CPU usage (FPS), lag/network      --
--     bandwidth (no SendAdd0nMessage), fast and easy visual recognition and  --
--     suitable data.                                                         --
--                                                                            --
-- # Health: ---------------------------------------------------------------- --
--   - Events:             - UNIT_TARGET                                      --
--                         - UNIT_HEALTH_FREQUENT                             --
--                         - UPDATE_MOUSEOVER_UNIT                            --
--   - The health from an enemy is not always available.                      --
--     This is restricted by the WoW API.                                     --
--   - A raidmember/raidpet MUST target(focus/mouseover) an enemy OR          --
--     you/yourpet MUST target/focus/mouseover an enemy to get the health.    --
--                                                                            --
-- # Target: ---------------------------------------------------------------- --
--   - Event:              - PLAYER_TARGET_CHANGED                            --
--                                                                            --
-- # Target of Target: ------------------------------------------------------ --
--   - Events:             - UNIT_TARGET                                      --
--                         - PLAYER_TARGET_CHANGED                            --
--                                                                            --
-- # Target Count: ---------------------------------------------------------- --
--   - Event:              - UNIT_TARGET                                      --
--                                                                            --
-- # Main Assist Target: ---------------------------------------------------- --
--   - Event:              - UNIT_TARGET                                      --
--                                                                            --
-- # Leader: ---------------------------------------------------------------- --
--   - Event:              - UNIT_TARGET                                      --
--                         - PARTY_LEADER_CHANGED (Friend only)               --
--                                                                            --
-- # Level: (only registered if playerLevel < maxLevel) --------------------- --
--   - Event:              - UNIT_TARGET                                      --
--                                                                            --
-- # Focus: ----------------------------------------------------------------- --
--   - Event:              - PLAYER_FOCUS_CHANGED                             --
--                                                                            --
-- # Enemy Carrier: --------------------------------------------------------- --
--   - Events:             - CHAT_MSG_BG_SYSTEM_HORDE                         --
--                         - CHAT_MSG_BG_SYSTEM_ALLIANCE                      --
--                         - CHAT_MSG_RAID_BOSS_EMOTE                         --
--                         - UNIT_TARGET                                      --
--   Carrier detection in case of ReloadUI or mid-battle-joins: (temporarily  --
--   registered until each enemy is scanned)                                  --
--                         - UNIT_TARGET                                      --
--                         - UPDATE_MOUSEOVER_UNIT                            --
--                         - PLAYER_TARGET_CHANGED                            --
--                                                                            --
-- # PvP Trinket: ----------------------------------------------------------- --
--   - Event:              - COMBAT_LOG_EVENT_UNFILTERED                      --
--   - Without SendAdd0nMessage(). Limited to your CombatLog range.           --
--                                                                            --
-- # No SendAdd0nMessage(): ------------------------------------------------- --
--   This AddOn does not use/need SendAdd0nMessage(). SendAdd0nMessage()      --
--   increases the available data by transmitting information to other        --
--   players. This has certain pros and cons. I may include (opt-in) such     --
--   functionality in some future release. maybe. dontknow.                   --
--                                                                            --
-- -------------------------------------------------------------------------- --
--                                                                            --
-- slash commands: /bgt - /bgtargets - /battlegroundtargets                   --
--                                                                            --
-- -------------------------------------------------------------------------- --
--                                                                            --
-- Thanks to all who helped with the localization.                            --
--                                                                            --
-- -------------------------------------------------------------------------- --

local _G = _G
local pairs = pairs
local print = print
local type = type
local unpack = unpack
local band = bit.band
local math_min = math.min
local math_max = math.max
local floor = math.floor
local random = math.random
local strfind = string.find
local strmatch = string.match
local tostring = tostring
local format = string.format
local tinsert = table.insert
local table_sort = table.sort
local wipe = table.wipe
local CheckInteractDistance = CheckInteractDistance
local CreateFrame = CreateFrame
local GetBattlefieldArenaFaction = GetBattlefieldArenaFaction
local GetBattlefieldScore = GetBattlefieldScore
local GetBattlefieldStatus = GetBattlefieldStatus
local GetBattlegroundInfo = GetBattlegroundInfo
local GetClassInfoByID = GetClassInfoByID
local GetCurrentMapAreaID = GetCurrentMapAreaID
local GetLocale = GetLocale
local GetMaxPlayerLevel = GetMaxPlayerLevel
local GetNumBattlefieldScores = GetNumBattlefieldScores
local GetNumBattlegroundTypes = GetNumBattlegroundTypes
local GetNumGroupMembers = GetNumGroupMembers
local GetNumSpecializationsForClassID = GetNumSpecializationsForClassID
local GetMaxBattlefieldID = GetMaxBattlefieldID
local GetRaidRosterInfo = GetRaidRosterInfo
local GetRealZoneText = GetRealZoneText
local GetSpecializationInfoForClassID = GetSpecializationInfoForClassID
local GetSpellInfo = GetSpellInfo
local GetTime = GetTime
local InCombatLockdown = InCombatLockdown
local IsActiveBattlefieldArena = IsActiveBattlefieldArena
local IsInInstance = IsInInstance
local IsRatedBattleground = IsRatedBattleground
local IsSpellInRange = IsSpellInRange
local IsSpellKnown = IsSpellKnown
local RequestBattlefieldScoreData = RequestBattlefieldScoreData
local SetBattlefieldScoreFaction = SetBattlefieldScoreFaction
local SetMapToCurrentZone = SetMapToCurrentZone
local UnitBuff = UnitBuff
local UnitClass = UnitClass
local UnitDebuff = UnitDebuff
local UnitExists = UnitExists
local UnitFactionGroup = UnitFactionGroup
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitInRange = UnitInRange
local UnitIsGhost = UnitIsGhost
local UnitIsGroupLeader = UnitIsGroupLeader
local UnitLevel = UnitLevel
local UnitName = UnitName

-- -------------------------------------------------------------------------- --

local function GetUnitFullName(unit)
	local name, server = UnitName(unit)
	if server and server ~= "" then
		--print("INPUT_NAME_CHECK: _UN1_", unit, name.."-"..server)
		return name.."-"..server
	else
		--print("INPUT_NAME_CHECK: _UN2_", unit, name)
		return name
	end
end

local function UnitInCheckedRange(unit)
	local inRange, checkedRange = UnitInRange(unit)
	--print("RANGE_CHK UnitInRange:", inRange, checkedRange, "#", unit, "#", UnitInRange(unit))
	if inRange and checkedRange then
		return true
	end
end

--[[ TEST
local XCheckInteractDistance = CheckInteractDistance
local function CheckInteractDistance(unit, interaction)
	local inRange = XCheckInteractDistance(unit, interaction)
	print("RANGE_CHK CheckInteractDistance:", inRange, "#", unit, interaction)
	return inRange
end
local XIsSpellInRange = IsSpellInRange
local function IsSpellInRange(spell, unit)
	local inRange = XIsSpellInRange(spell, unit)
	print("RANGE_CHK IsSpellInRange:", inRange, "#", spell, unit)
	return inRange
end
--]]

-- -------------------------------------------------------------------------- --

BattlegroundTargets_Options = {
	["ButtonRangeDisplay"] = {
		[40] = 7,
		[10] = 1,
		[15] = 1,
	},
	["ButtonSortBy"] = {
		[40] = 1,
		[10] = 1,
		[15] = 1,
	},
	["ButtonFocusPosition"] = {
		[40] = 55,
		[10] = 70,
		[15] = 70,
	},
	["ButtonShowHealthBar"] = {
		[40] = false,
		[10] = false,
		[15] = false,
	},
	["ButtonShowRealm"] = {
		[40] = false,
		[10] = true,
		[15] = true,
	},
	["LayoutTH"] = {
		[40] = 24,
		[10] = 18,
		[15] = 18,
	},
	["ButtonFlagPosition"] = {
		[40] = 100,
		[10] = 60,
		[15] = 60,
	},
	["ButtonAssistPosition"] = {
		[40] = 70,
		[10] = 100,
		[15] = 100,
	},
	["ButtonTargetPosition"] = {
		[40] = 85,
		[10] = 100,
		[15] = 100,
	},
	["LayoutSpace"] = {
		[40] = 0,
		[10] = 0,
		[15] = 0,
	},
	["ButtonFocusScale"] = {
		[40] = 1,
		[10] = 1,
		[15] = 1,
	},
	["version"] = 21,
	["ButtonShowAssist"] = {
		[40] = false,
		[10] = false,
		[15] = false,
	},
	["pos"] = {
		["BattlegroundTargets_MainFrame"] = {
			["y"] = 248.2100434730843,
			["x"] = 41.00002113165699,
			["point"] = "LEFT",
			["s"] = 1,
		},
	},
	["ButtonRangeCheck"] = {
		[40] = false,
		[10] = false,
		[15] = false,
	},
	["ButtonAssistScale"] = {
		[40] = 1,
		[10] = 1.2,
		[15] = 1.2,
	},
	["EnableBracket"] = {
		[40] = true,
		[10] = true,
		[15] = true,
	},
	["LayoutButtonSpace"] = {
		[40] = 0,
		[10] = 0,
		[15] = 0,
	},
	["ButtonShowRole"] = {
		[40] = true,
		[10] = true,
		[15] = true,
	},
	["IndependentPositioning"] = {
		[40] = false,
		[10] = false,
		[15] = false,
	},
	["ButtonScale"] = {
		[40] = 1,
		[10] = 1,
		[15] = 1,
	},
	["ButtonHeight"] = {
		[40] = 16,
		[10] = 20,
		[15] = 20,
	},
	["ButtonWidth"] = {
		[40] = 100,
		[10] = 175,
		[15] = 175,
	},
	["ButtonShowHealthText"] = {
		[40] = false,
		[10] = false,
		[15] = false,
	},
	["ButtonFontNumberSize"] = {
		[40] = 10,
		[10] = 10,
		[15] = 10,
	},
	["ButtonFontNameSize"] = {
		[40] = 10,
		[10] = 12,
		[15] = 12,
	},
	["ButtonFontNameStyle"] = {
		[40] = 10,
		[10] = 10,
		[15] = 10,
	},
	["ButtonSortDetail"] = {
		[40] = 3,
		[10] = 3,
		[15] = 3,
	},
	["ButtonTypeRangeCheck"] = {
		[40] = 2,
		[10] = 2,
		[15] = 2,
	},
	["ButtonShowTarget"] = {
		[40] = true,
		[10] = true,
		[15] = true,
	},
	["ButtonFontNumberStyle"] = {
		[40] = 1,
		[10] = 1,
		[15] = 1,
	},
	["ButtonShowTargetCount"] = {
		[40] = false,
		[10] = false,
		[15] = false,
	},
	["ButtonClassIcon"] = {
		[40] = false,
		[10] = false,
		[15] = false,
	},
	["SummaryScaleRole"] = {
		[40] = 0.5,
		[10] = 0.6,
		[15] = 0.6,
	},
	["ButtonTargetScale"] = {
		[40] = 1,
		[10] = 1.5,
		[15] = 1.5,
	},
	["ButtonShowSpec"] = {
		[40] = false,
		[10] = false,
		[15] = false,
	},
	["ButtonShowFlag"] = {
		[40] = false,
		[10] = true,
		[15] = true,
	},
	["ButtonShowFocus"] = {
		[40] = false,
		[10] = false,
		[15] = false,
	},
	["Summary"] = {
		[40] = false,
		[10] = false,
		[15] = false,
	},
	["ButtonFlagScale"] = {
		[40] = 1,
		[10] = 1.2,
		[15] = 1.2,
	},
	["MinimapButtonPos"] = -90,
	["ButtonShowLeader"] = {
		[40] = false,
		[10] = false,
		[15] = false,
	},
	["MinimapButton"] = false,
	["FirstRun"] = true,
} -- SavedVariable options table
local BattlegroundTargets = CreateFrame("Frame")

-- external resources BEGIN ------------------------------------------------- --
local _, prg = ...
if type(prg) ~= "table" then print("|cffffff7fBattlegroundTargets:|r ERROR: Restart WoW.") return end

-- FLG | flag carrier
if type(prg.FLG) ~= "table" then print("|cffffff7fBattlegroundTargets:|r ERROR: Restart WoW.") return end
local FLG = prg.FLG

-- L | localization L[
if type(prg.L) ~= "table" then print("|cffffff7fBattlegroundTargets:|r ERROR: Restart WoW.") return end
for k, v in pairs(prg.L) do if type(v) ~= "string" then prg.L[k] = tostring(k) end end
local L = prg.L

-- RNA | bg race names
if type(prg.RNA) ~= "table" then print("|cffffff7fBattlegroundTargets:|r ERROR: Restart WoW.") return end
local RNA = prg.RNA

-- TEMPLATE | templates
if type(prg.TEMPLATE) ~= "table" then print("|cffffff7fBattlegroundTargets:|r ERROR: Restart WoW.") return end
local TEMPLATE = prg.TEMPLATE

-- TLT | unspecified talents
if type(prg.TLT) ~= "table" then print("|cffffff7fBattlegroundTargets:|r ERROR: Restart WoW.") return end
local TLT = prg.TLT

-- TSL | transliteration table
if type(prg.TSL) ~= "table" then print("|cffffff7fBattlegroundTargets:|r ERROR: Restart WoW.") return end
local TSL = prg.TSL

-- utf8replace | utf8.lua (for transliteration)
if type(prg.utf8replace) ~= "function" then print("|cffffff7fBattlegroundTargets:|r ERROR: Restart WoW.") return end
local utf8replace = prg.utf8replace
-- external resources END --------------------------------------------------- --

local GVAR = {} -- UI Widgets

local locale = GetLocale()

local inWorld = nil
local inBattleground = nil
local inCombat = nil
local isConfig = nil
local fraction = "Enemy" -- for config

local reCheckBG = nil
local reCheckScore = nil
local reSizeCheck = 0
local reSetLayout = nil
local rePosMain = nil

local isDeadUpdateStop

local flagDebuff = 0 -- flag debuff -- FLGRST
local flags = 0      -- number of current flags (friend and enemy)
local isFlagBG = 0   -- flagBG from bgMaps
local flagCHK = nil  -- is flag check active
local flagflag = nil -- check value to do one flag check after bg entry

local range_CL_Throttle = 0        -- THROTTLE | rangecheck: [combatlog]
local range_CL_Frequency = 3       -- THROTTLE | rangecheck: [combatlog] 50/50 or 66/33 or 75/25 (%Yes/%No) => 64/36 = 36% filter

local rangeFrequency = 0.125       -- THROTTLE/FORCE_UPDATE | class_range_    : max/forced update frequency in seconds per button
local healthFrequency = 0.2        -- THROTTLE              | health_         : max        update frequency in seconds per button
local focusFrequency = 0.25        -- FORCE_UPDATE          | focus_          :     forced update frequency in seconds per button
local targetFrequency = 0.2        -- FORCE_UPDATE          | targeet         :     forced update frequency in seconds per button
local carrierDebuffFrequency = 2   -- THROTTLE/FORCE_UPDATE | carrier_debuff_ : max/forced update frequency in seconds per button
local leaderFrequency = 5          -- THROTTLE              | leader_         : max        update frequency in seconds per button
local assistFrequency = 1          -- FORCE_UPDATE          | assist_         :     forced update frequency in seconds per button - immediate assist target check
local targetCountFrequency = 10    -- FORCE_UPDATE          | targetcount_    :     forced update frequency in seconds            - complete raid check
local pvptrinketFrequency = 0.95   -- FORCE_UPDATE          | pvp_trinket_    :     forced update frequency in seconds

local scoreLastUpdate = GetTime()  -- WARNING  | scoreupdate: BattlefieldScoreUpdate()
local scoreWarning = 60            -- WARNING  | scoreupdate: inCombat-score-warning-icon
local scoreFrequency = 1           -- THROTTLE | scoreupdate:               1 second |                2 seconds |              5 seconds
local scoreCount = 0               -- THROTTLE | scoreupdate: 0-30 updates: 1 second | 31-60 updates: 2 seconds | 61+ updates: 5 seconds

local playerName = GetUnitFullName("player")
local _, playerClassEN = UnitClass("player")
local playerLevel = UnitLevel("player") -- LVLCHK
local maxLevel = GetMaxPlayerLevel()
local isLowLevel = nil

local playerTargetName
local playerFocusName
local isAssistName, isAssistUnitId, playerAssistTargetName
local isTargetButton

local playerFactionDEF = 0   -- player faction (DEFAULT)
local oppositeFactionDEF = 0 -- opposite faction (DEFAULT)
local playerFactionBG = 0    -- player faction (in battleground)
local oppositeFactionBG = 0  -- opposite faction (in battleground)
local oppositeFactionREAL    -- real opposite faction

--local eventTest = {} -- TEST event order

local FRAMES = {
	"Friend", -- FriendMainFrame / FriendButton
	"Enemy",  -- EnemyMainFrame  / EnemyButton
}

local DATA = {}
DATA.TargetCountNames = {}    -- key = unitName | value (string) = targetName
DATA.TargetCountTargetID = {} -- key = unitName | value (string) = targetID
DATA.TargetFCountNum = {}     -- key = unitName | value (number) = target count friend
DATA.TargetECountNum = {}     -- key = unitName | value (number) = target count enemy

DATA.PvPTrinketEndTime = {}   -- key = unitName | value (number) = endtime: when the trinket is ready for use again
DATA.PvPTrinketId = {}        -- key = unitName | value (number) = spellId of trinket

local pvptrinketIDs = {
   [7744] =  30, -- Will of the Forsaken (Undead)
  [42292] = 120, --trinket
  [59752] =  30,  -- human
  
  [195710] = 180,  -- 180 PvP talent Trinket
  [208683] = 120  -- 120 PvP talent Trinket
}

DATA.TransName = {}           -- key = unitName | value (string) = transliteration name
DATA.FirstFlagCheck = {}      -- key = unitName | value (number) = 1

for frc = 1, #FRAMES do
	local side = FRAMES[frc]
	DATA[side] = {}

	DATA[side].MainMoverModeValue = false

	DATA[side].rangeSpellName = nil -- value (string) | for class-spell based range check
	DATA[side].rangeMin = nil       -- value (number) | for class-spell based range check
	DATA[side].rangeMax = nil       -- value (number) | for class-spell based range check

	DATA[side].hasFlag = nil            -- value (string) = player name
	DATA[side].isLeader = nil           -- value (string) = player name
	DATA[side].healthBarWidth = 0.01    -- value (number) = health bar width
	DATA[side].totHealthBarWidth = 0.01 -- value (number) = target of target health bar width

	DATA[side].MainData = {}     -- key = numerical              | value          = all player data
	DATA[side].Name4Flag = {}    -- key = unitName without realm | value (number) = button number
	DATA[side].Name2Button = {}  -- key = unitName               | value (number) = button number
	DATA[side].Name2UnitID = {}  -- key = unitName               | value (string) = unitID
	DATA[side].UnitID2Name = {}  -- key = unitID                 | value (string) = unitName
	DATA[side].Name2Level = {}   -- key = unitName               | value (number) = level
	DATA[side].Name2Percent = {} -- key = unitName               | value (number) = health in percent
	DATA[side].Name2Range = {}   -- key = unitName               | value (number) = distance in ym

	DATA[side].Roles = {0,0,0,0}
end

local SPELL_Range = {} -- key = spellId | value = maxRange

local currentSize = 10
local currentBGMap = nil
local testSize = 10
local testData = {
	Loaded = nil,            -- testData.Loaded
	CarrierDisplay = "flag", -- testData.CarrierDisplay
	Friend = {},             -- testData.Friend
	Enemy = {}               -- testData.Enemy
}
for frc = 1, #FRAMES do
	local side = FRAMES[frc]
	testData[side] = {
		IconTarget     = 2,                           -- testData[side].IconTarget       | testData.Friend.IconTarget     | testData.Enemy.IconTarget
		IconFocus      = 5,                           -- testData[side].IconFocus        | testData.Friend.IconFocus      | testData.Enemy.IconFocus
		IconFlag       = {button = 3, txt = 1},       -- testData[side].IconFlag         | testData.Friend.IconFlag       | testData.Enemy.IconFlag
		IconOrb        = {[121164] = {button = 2},    -- testData[side].IconOrb (Blue)   | testData.Friend.IconOrb        | testData.Enemy.IconOrb
		                  [121175] = {button = 4},    -- testData[side].IconOrb (Puprle) | testData.Friend.IconOrb        | testData.Enemy.IconOrb
		                  [121176] = {button = 7},    -- testData[side].IconOrb (Green)  | testData.Friend.IconOrb        | testData.Enemy.IconOrb
		                  [121177] = {button = nil}}, -- testData[side].IconOrb (Orange) | testData.Friend.IconOrb        | testData.Enemy.IconOrb
		IconTargetAssi = 4,                           -- testData[side].IconTargetAssi   | testData.Friend.IconTargetAssi | testData.Enemy.IconTargetAssi
		IconSourceAssi = 4,                           -- testData[side].IconSourceAssi   | testData.Friend.IconSourceAssi | testData.Enemy.IconSourceAssi
		targetFCount   = {},                          -- testData[side].targetFCount     | testData.Friend.targetFCount   | testData.Enemy.targetFCount
		targetECount   = {},                          -- testData[side].targetECount     | testData.Friend.targetECount   | testData.Enemy.targetECount
		Health         = {},                          -- testData[side].Health           | testData.Friend.Health         | testData.Enemy.Health
		Range          = {},                          -- testData[side].Range            | testData.Friend.Range          | testData.Enemy.Range
		TargetofTarget = {},                          -- testData[side].TargetofTarget   | testData.Friend.TargetofTarget | testData.Enemy.TargetofTarget
		Leader         = 4,                           -- testData[side].Leader           | testData.Friend.Leader         | testData.Enemy.Leader
		PVPTrinket     = {},                          -- testData[side].PVPTrinket       | testData.Friend.PVPTrinket     | testData.Enemy.PVPTrinket
	}
end

local mapID = {}
local bgMaps = {}
local function BuildBattlegroundMapTable()
	for i = 1, GetNumBattlegroundTypes() do
		local localizedName, _, _, _, bgID, _, _, _, gameType, icon = GetBattlegroundInfo(i)
		--print(localizedName, bgID, gameType, icon, i, "#", GetBattlegroundInfo(i))
		    if bgID ==   1 then mapID[401] = localizedName bgMaps[localizedName] = {bgSize = 40, flagBG = 0} -- Alterac Valley
		elseif bgID ==   2 then mapID[443] = localizedName bgMaps[localizedName] = {bgSize = 10, flagBG = 1} -- Warsong Gulch
		elseif bgID ==   3 then mapID[461] = localizedName bgMaps[localizedName] = {bgSize = 15, flagBG = 0} -- Arathi Basin
		elseif bgID ==   7 then mapID[482] = localizedName bgMaps[localizedName] = {bgSize = 15, flagBG = 2} -- Eye of the Storm
		elseif bgID ==   9 then mapID[512] = localizedName bgMaps[localizedName] = {bgSize = 15, flagBG = 0} -- Strand of the Ancients
		elseif bgID ==  30 then mapID[540] = localizedName bgMaps[localizedName] = {bgSize = 40, flagBG = 0} -- Isle of Conquest
		elseif bgID == 108 then mapID[626] = localizedName bgMaps[localizedName] = {bgSize = 10, flagBG = 3} -- Twin Peaks
		elseif bgID == 120 then mapID[736] = localizedName bgMaps[localizedName] = {bgSize = 10, flagBG = 0} -- The Battle for Gilneas
		elseif bgID == 699 then mapID[856] = localizedName bgMaps[localizedName] = {bgSize = 10, flagBG = 5} -- Temple of Kotmogu
		elseif bgID == 708 then mapID[860] = localizedName bgMaps[localizedName] = {bgSize = 10, flagBG = 0} -- Silvershard Mines
		elseif bgID == 754 then mapID[935] = localizedName bgMaps[localizedName] = {bgSize = 15, flagBG = 4} -- Deepwind Gorge
		elseif bgID == 789 then                            bgMaps[localizedName] = {bgSize = 40, flagBG = 0} -- Southshore vs Tarren Mill
		end
	end
end

local totalFlags = {
	2, -- flagBG = 1 Warsong Gulch
	1, -- flagBG = 2 Eye of the Storm
	2, -- flagBG = 3 Twin Peaks
	4, -- flagBG = 4 Temple of Kotmogu
	2, -- flagBG = 5 Deepwind Gorge
}

local flagIDs = {
	 [34976] = 1, -- Netherstorm Flag   Eye of the Storm
	[140876] = 1, -- Alliance Mine Cart Deepwind Gorge
	[141210] = 1, -- Horde Mine Cart    Deepwind Gorge
	[156618] = 1, -- Horde Flag         Warsong Gulch & Twin Peaks
	[156621] = 1, -- Alliance Flag      Warsong Gulch & Twin Peaks
}

local debuffIDs = {
	[46392] = 1, -- Focused Assault
	[46393] = 1, -- Brutal Assault
}

local hasOrb = {Green={name=nil,orbval=nil},Blue={name=nil,orbval=nil},Purple={name=nil,orbval=nil},Orange={name=nil,orbval=nil}}

local orbIDs = {
	[121164] = {color = "Blue",   texture = "Interface\\MiniMap\\TempleofKotmogu_ball_cyan"},   -- |cFF01DFD__7__Blue|r   |cFF01DFD7Blue|r
	[121175] = {color = "Purple", texture = "Interface\\MiniMap\\TempleofKotmogu_ball_purple"}, -- |cFFBF00F__F__Purple|r |cFFBF00FFPurple|r
	[121176] = {color = "Green",  texture = "Interface\\MiniMap\\TempleofKotmogu_ball_green"},  -- |cFF01DF0__1__Green|r  |cFF01DF01Green|r
	[121177] = {color = "Orange", texture = "Interface\\MiniMap\\TempleofKotmogu_ball_orange"}, -- |cFFFF800__0__Orange|r |cFFFF8000Orange|r
}

local orbColIDs = {
	["Blue"]   = 121164,-- code = {0.0039, 0.8745, 0.8431}
	["Purple"] = 121175,-- code = {0.7490, 0     , 1     }
	["Green"]  = 121176,-- code = {0.0039, 0.8745, 0.0039}
	["Orange"] = 121177,-- code = {1     , 0.5019, 0     }
}

local function orbData(str)
	local colorCode = strmatch(str, "^|cFF%x%x%x%x%x(%x).*|r$")
	--print("colorCode:", colorCode)
	    if colorCode == "7" then return "Blue",   "Interface\\MiniMap\\TempleofKotmogu_ball_cyan"   -- |cFF01DFD__7__Blue|r   |cFF01DFD7Blue|r
	elseif colorCode == "F" then return "Purple", "Interface\\MiniMap\\TempleofKotmogu_ball_purple" -- |cFFBF00F__F__Purple|r |cFFBF00FFPurple|r
	elseif colorCode == "1" then return "Green",  "Interface\\MiniMap\\TempleofKotmogu_ball_green"  -- |cFF01DF0__1__Green|r  |cFF01DF01Green|r
	elseif colorCode == "0" then return "Orange", "Interface\\MiniMap\\TempleofKotmogu_ball_orange" -- |cFFFF800__0__Orange|r |cFFFF8000Orange|r
	end
	return nil, nil
end

local sortBy = {
	L["Role"].." / "..L["Class"].."* / "..L["Name"], -- 1
	L["Role"].." / "..L["Name"], -- 2
	L["Class"].."* / "..L["Role"].." / "..L["Name"], -- 3
	L["Class"].."* / "..L["Name"], -- 4
	L["Name"], -- 5
}

local sortDetail = {
	"*"..L["Class"].." ("..locale..")", -- 1
	"*"..L["Class"].." (english)", -- 2
	"*"..L["Class"].." (Blizzard)", -- 3
}

local fontStyles = {
	{font = "Fonts\\2002.ttf",         name = "2002 - |cffa070ddLatin-1|r  |cff68ccefkoKR|r  |cffff7c0aruRU|r"}, -- 1
	{font = "Fonts\\2002B.ttf",        name = "2002 Bold - |cffa070ddLatin-1|r  |cff68ccefkoKR|r  |cffff7c0aruRU|r"}, -- 2
	{font = "Fonts\\ARIALN.TTF",       name = "Arial Narrow - |cffa070ddLatin|r  |cffff7c0aruRU|r"}, -- 3
	{font = "Fonts\\ARHei.ttf",        name = "AR CrystalzcuheiGBK Demibold - |cffff7c0aruRU|r  |cffc69b6dzhCN|r  |cffc41e3azhTW|r"}, -- 4
	{font = "Fonts\\bHEI00M.ttf",      name = "AR Heiti2 Medium B5 - |cffff7c0aruRU|r  |cffc41e3azhTW|r"}, -- 5
	{font = "Fonts\\bHEI01B.ttf",      name = "AR Heiti2 Bold B5 - |cffff7c0aruRU|r  |cffc41e3azhTW|r"}, -- 6
	{font = "Fonts\\bKAI00M.ttf",      name = "AR Kaiti Medium B5 - |cffff7c0aruRU|r  |cffc41e3azhTW|r"}, -- 7
	{font = "Fonts\\bLEI00D.ttf",      name = "AR Leisu Demi B5 - |cffff7c0aruRU|r  |cffc41e3azhTW|r"}, -- 8
	{font = "Fonts\\ARKai_C.ttf",      name = "AR ZhongkaiGBK Medium C - |cffff7c0aruRU|r  |cffc69b6dzhCN|r  |cffc41e3azhTW|r"}, -- 9
	{font = "Fonts\\ARKai_T.ttf",      name = "AR ZhongkaiGBK Medium T - |cffff7c0aruRU|r  |cffc69b6dzhCN|r  |cffc41e3azhTW|r"}, -- 10
	{font = "Fonts\\FRIZQT__.TTF",     name = "Friz Quadrata TT - |cffa070ddLatin-1|r"}, -- 11
	{font = "Fonts\\FRIZQT___CYR.TTF", name = "Friz Quadrata TT Cyr - |cffff7c0aruRU|r"}, -- 12
	{font = "Fonts\\MORPHEUS.TTF",     name = "Morpheus - |cffa070ddLatin-1|r"}, -- 13
	{font = "Fonts\\MORPHEUS_CYR.TTF", name = "Morpheus Cyr - |cffa070ddLatin-1|r  |cffff7c0aruRU|r"}, -- 14
	{font = "Fonts\\NIM_____.ttf",     name = "Nimrod MT - |cffa070ddLatin|r  |cffff7c0aruRU|r"}, -- 15
	{font = "Fonts\\SKURRI.TTF",       name = "Skurri - |cffa070ddLatin-1|r"}, -- 16
	{font = "Fonts\\SKURRI_CYR.TTF",   name = "Skurri Cyr - |cffa070ddLatin-1|r  |cffff7c0aruRU|r"}, -- 17
	{font = "Fonts\\K_Pagetext.TTF",   name = "YDIMokM - |cffa070ddLatin-1|r  |cff68ccefkoKR|r  |cffff7c0aruRU|r"}, -- 18
	{font = "Fonts\\K_Damage.TTF",     name = "YDIWingsM - |cff68ccefkoKR|r  |cffff7c0aruRU|r"}, -- 19
}

  local defaultFont = 1
--    if locale == "deDE" then defaultFont =  1
--elseif locale == "enGB" then defaultFont =  1 -> enUS
--elseif locale == "enUS" then defaultFont =  1
--elseif locale == "esES" then defaultFont =  1
--elseif locale == "esMX" then defaultFont =  1
--elseif locale == "frFR" then defaultFont =  1
--elseif locale == "itIT" then defaultFont =  1
--elseif locale == "koKR" then defaultFont =  1 -- 2002.ttf (same as defined in Fonts.xml)
--elseif locale == "ptBR" then defaultFont =  1
--elseif locale == "ptPT" then defaultFont =  1 -> ptBR
      if locale == "ruRU" then defaultFont = 12 -- FRIZQT___CYR.TTF (same as defined in Fonts.xml)
  elseif locale == "zhCN" then defaultFont = 10 -- ARKai_T.ttf (same as defined in Fonts.xml)
  elseif locale == "zhTW" then defaultFont = 10 -- ARKai_T.ttf (same as defined in Fonts.xml)
--elseif locale == "enCN" then defaultFont = 10 -> zhCN
--elseif locale == "enTW" then defaultFont = 10 -> zhTW
  end

local fontPath = fontStyles[defaultFont].font

local classcolors = {}
for class, color in pairs(RAID_CLASS_COLORS) do -- Constants.lua
	classcolors[class] = {r = color.r, g = color.g, b = color.b, colorStr = format("%.2x%.2x%.2x", color.r*255, color.g*255, color.b*255)}
end
classcolors["ZZZFAILURE"] = {r = 0.6, g = 0.6, b = 0.6, colorStr = "999999"}
--for k, v in pairs(classcolors) do print(k, v.r, v.g, v.b, v.colorStr) end

-- texture: Interface\\WorldStateFrame\\Icons-Classes
local classes = {
	DEATHKNIGHT = {coords = {0.2578125,  0.4921875,  0.5078125,  0.7421875 }}, -- ( 66/256, 126/256, 130/256, 190/256)
	DRUID       = {coords = {0.74609375, 0.98046875, 0.0078125,  0.2421875 }}, -- (191/256, 251/256,   2/256,  62/256)
	HUNTER      = {coords = {0.0078125,  0.2421875,  0.26171875, 0.49609375}}, -- (  2/256,  62/256,  67/256, 127/256)
	MAGE        = {coords = {0.25,       0.484375,   0.01171875, 0.24609375}}, -- ( 64/256, 124/256,   3/256,  63/256)
	MONK        = {coords = {0.5,        0.734375,   0.51171875, 0.74609375}}, -- (128/256, 188/256, 131/256, 191/256)
	PALADIN     = {coords = {0.0078125,  0.2421875,  0.51171875, 0.74609375}}, -- (  2/256,  62/256, 131/256, 191/256)
	PRIEST      = {coords = {0.5,        0.734375,   0.265625,   0.5       }}, -- (128/256, 188/256,  68/256, 128/256)
	ROGUE       = {coords = {0.50390625, 0.73828125, 0.01171875, 0.24609375}}, -- (129/256, 189/256,   3/256,  63/256)
	SHAMAN      = {coords = {0.25390625, 0.48828125, 0.2578125,  0.4921875 }}, -- ( 65/256, 125/256,  66/256, 126/256)
	WARLOCK     = {coords = {0.75,       0.984375,   0.2578125,  0.4921875 }}, -- (192/256, 252/256,  66/256, 126/256)
	WARRIOR     = {coords = {0.0078125,  0.2421875,  0.0078125,  0.2421875 }}, -- (  2/256,  62/256,   2/256,  62/256)
	DEMONHUNTER = {coords = {0.74609375, 0.98046875, 0.5078125,  0.7421875 }}, -- (191/256, 251/256,  131/256, 191/256)
	ZZZFAILURE  = {coords = {0, 0, 0, 0}},
}

-- roles: 1 = HEALER | 2 = TANK | 3 = DAMAGER
local classROLES = {HEALER = {}, TANK = {}, DAMAGER = {}}
for classID = 1, MAX_CLASSES do
	local classTag = C_CreatureInfo.GetClassInfo(classID).classFile
	local numTabs = GetNumSpecializationsForClassID(classID)
	--print(numTabs, classID, "#", GetNumSpecializationsForClassID(classID))
	classes[classTag].spec = {}
	classes[classTag].fixname = {}
	classes[classTag].fix = false
	for i = 1, numTabs do
		local id, name, _, icon, role = GetSpecializationInfoForClassID(classID, i)
		--print(role, id, classID, i, name, icon, "#", GetSpecializationInfoForClassID(classID, i))
		if     role == "DAMAGER" then classes[classTag].spec[i] = {role = 3, specID = id, specName = name, icon = icon} tinsert(classROLES.DAMAGER, {classTag = classTag, specIndex = i}) -- DAMAGER: total = 23
		elseif role == "HEALER"  then classes[classTag].spec[i] = {role = 1, specID = id, specName = name, icon = icon} tinsert(classROLES.HEALER,  {classTag = classTag, specIndex = i}) -- HEALER : total =  6
		elseif role == "TANK"    then classes[classTag].spec[i] = {role = 2, specID = id, specName = name, icon = icon} tinsert(classROLES.TANK,    {classTag = classTag, specIndex = i}) -- TANK   : total =  5
		end
		--locale fix
		local _ , fname = GetSpecializationInfoForClassID(classID, i, 3)
		if name ~= fname then
			classes[classTag].fixname[fname] = name
			classes[classTag].fix = true
		end		
	end
end

for classTag in pairs(TLT) do
	if not classes[classTag].spec then classes[classTag].spec = {} end
	for i = 1, #TLT[classTag].spec do
		tinsert(classes[classTag].spec, TLT[classTag].spec[i])
	end
end

--[[
for k, v in pairs(classes) do
	if classes[k] and classes[k].spec then
		for i = 1, #classes[k].spec do
			local str = ""
			for k2, v2 in pairs(classes[k].spec[i]) do
				str = str .. k2 .. ": " .. v2 .. " - "
			end
			print(k, str)
		end
	end
end
--]]

-- 10 HEALER   1- 3 | 15 HEALER   2- 4 | 40 HEALER   3- 6
-- 10 TANK     1- 2 | 15 TANK     2- 4 | 40 TANK     2- 4
-- 10 DAMAGER  5- 8 | 15 DAMAGER  7-11 | 40 DAMAGER 30-35
testData.Friend.MainTestDATA = {[10] = {}, [15] = {}, [40] = {}}
testData.Enemy.MainTestDATA  = {[10] = {}, [15] = {}, [40] = {}}
local function newTestData()
	local classDATA = {}
	for frc = 1, #FRAMES do
		local side = FRAMES[frc]
		local healerRND10, tankRND10 = random(1,3), random(1,2)
		local healerRND15, tankRND15 = random(2,4), random(1,3)
		local healerRND40, tankRND40 = random(3,6), random(2,4)
		local damagerRND10 = 10-healerRND10-tankRND10
		local damagerRND15 = 15-healerRND15-tankRND15
		local damagerRND40 = 40-healerRND40-tankRND40
		classDATA[side] = {
			HEALER  = {[10] = healerRND10,  [15] = healerRND15,  [40] = healerRND40},
			TANK    = {[10] = tankRND10,    [15] = tankRND15,    [40] = tankRND40},
			DAMAGER = {[10] = damagerRND10, [15] = damagerRND15, [40] = damagerRND40}
		}
	end

	for frc = 1, #FRAMES do
		local side = FRAMES[frc]
		----------
		for bracket = 1, 3 do
			local bracketSize
			if bracket == 1 then bracketSize = 10
			elseif bracket == 2 then bracketSize = 15
			elseif bracket == 3 then bracketSize = 40
			end
			local charnum1 = random(65, 90) -- 65 = A |  90 = Z
			local charnum2 = random(97,111) -- 97 = a | 111 = o
			wipe(testData[side].MainTestDATA[bracketSize])
			for role in pairs(classROLES) do
				local index = 0
				while index < classDATA[side][role][bracketSize] do
					local rndNum     = random(1, #classROLES[role])
					local classToken = classROLES[role][rndNum].classTag
					local specIndex  = classROLES[role][rndNum].specIndex
					tinsert(testData[side].MainTestDATA[bracketSize], {
						name = L["Target"].."_"..strchar(charnum1)..strchar(charnum2).."-servername",
						classToken = classToken,
						talentSpec = classes[classToken].spec[specIndex].role,
						specIcon   = classes[classToken].spec[specIndex].icon
					})
					if charnum1 ==  90 then charnum1 = 65 else charnum1 = charnum1 + 1 end
					if charnum2 == 111 then charnum2 = 97 else charnum2 = charnum2 + 1 end
					index = index + 1
				end
			end
		end
		----------
	end
end

local class_LocaSort = {}
FillLocalizedClassList(class_LocaSort, false) -- Constants.lua

local class_BlizzSort = {}
for i = 1, #CLASS_SORT_ORDER do -- Constants.lua
	class_BlizzSort[ CLASS_SORT_ORDER[i] ] = i
end

local class_IntegerSort = { -- .cid .blizz .eng .loc
	{cid = "DEATHKNIGHT", blizz = class_BlizzSort.DEATHKNIGHT or  2, eng = "Death Knight", loc = class_LocaSort.DEATHKNIGHT or "Death Knight"}, -- 1
	{cid = "DRUID",       blizz = class_BlizzSort.DRUID       or  7, eng = "Druid",        loc = class_LocaSort.DRUID       or "Druid"},        -- 2
	{cid = "HUNTER",      blizz = class_BlizzSort.HUNTER      or 11, eng = "Hunter",       loc = class_LocaSort.HUNTER      or "Hunter"},       -- 3
	{cid = "MAGE",        blizz = class_BlizzSort.MAGE        or  9, eng = "Mage",         loc = class_LocaSort.MAGE        or "Mage"},         -- 4
	{cid = "MONK",        blizz = class_BlizzSort.MONK        or  4, eng = "Monk",         loc = class_LocaSort.MONK        or "Monk"},         -- 5
	{cid = "PALADIN",     blizz = class_BlizzSort.PALADIN     or  3, eng = "Paladin",      loc = class_LocaSort.PALADIN     or "Paladin"},      -- 6
	{cid = "PRIEST",      blizz = class_BlizzSort.PRIEST      or  5, eng = "Priest",       loc = class_LocaSort.PRIEST      or "Priest"},       -- 7
	{cid = "ROGUE",       blizz = class_BlizzSort.ROGUE       or  8, eng = "Rogue",        loc = class_LocaSort.ROGUE       or "Rogue"},        -- 8
	{cid = "SHAMAN",      blizz = class_BlizzSort.SHAMAN      or  6, eng = "Shaman",       loc = class_LocaSort.SHAMAN      or "Shaman"},       -- 9
	{cid = "WARLOCK",     blizz = class_BlizzSort.WARLOCK     or 10, eng = "Warlock",      loc = class_LocaSort.WARLOCK     or "Warlock"},      -- 10
	{cid = "WARRIOR",     blizz = class_BlizzSort.WARRIOR     or  1, eng = "Warrior",      loc = class_LocaSort.WARRIOR     or "Warrior"},      -- 11
	{cid = "DEMONHUNTER", blizz = class_BlizzSort.DEMONHUNTER or 12, eng = "Demon Hunter", loc = class_LocaSort.DEMONHUNTER or "Demon Hunter"}, -- 12
}

local ranges = {
	Friend = {
		DEATHKNIGHT = {id =  61999, lvl =  72}, -- Raise Ally          (  0 - 40yd/m) - Lvl 72 DKN72
		DRUID       = {id =  50769, lvl =  14}, -- Revive	           (  0 - 40yd/m) - Lvl  4
		HUNTER      = {id =    136, lvl = 111}, --none Misdirection    (  0 -100yd/m) - Lvl 42 HUN42 -- no_def_range
		MAGE        = {id =    130, lvl =  32}, -- Slow Fall	       (  0 - 40yd/m) - Lvl 29 MAG32
		MONK        = {id = 115178, lvl =  14}, -- Resuscitate         (  0 - 40yd/m) - Lvl 18 MON18
		PALADIN     = {id =    633, lvl =  22}, -- LoH			       (  0 - 40yd/m) - Lvl  9
		PRIEST      = {id =   2006, lvl =  14}, -- Resurection         (  0 - 40yd/m) - Lvl  7
		ROGUE       = {id =  57934, lvl =  64}, -- Tricks of the Trade (  0 -100yd/m) - Lvl 78 ROG78 -- no_def_range
		SHAMAN      = {id =   2008, lvl =  14}, -- Ancestral Spirit    (  0 - 40yd/m) - Lvl  7
		WARLOCK     = {id =  20707, lvl =  18}, -- Soulstone           (  0 - 40yd/m) - Lvl 18 WLK18
		WARRIOR     = {id = 198304, lvl =  72}, -- Intercept           (  0 -100yd/m) - Lvl 72 WRR72 -- no_def_range
		DEMONHUNTER = {id =   6603, lvl =  98}, -- Intercept           (  0 -100yd/m) - Lvl 72 WRR72 -- no_def_range
	},
	Enemy = {
		DEATHKNIGHT = {id =  49576, lvl =  55}, -- Death Grip          (  0 - 40yd/m) - Lvl 55
		DRUID       = {id =    339, lvl =  22}, -- Entangling Roots              (  0 - 40yd/m) - Lvl  1
		HUNTER      = {id =     75, lvl =   1}, -- Auto Shot           (  0 - 40yd/m) - Lvl  1
		MAGE        = {id =   2139, lvl =  34}, -- Counterspell        (  0 - 40yd/m) - Lvl  1
		MONK        = {id = 117952, lvl =  36}, -- Crackling Jade L    (  0 - 40yd/m) - Lvl 14 MON14
		PALADIN     = {id =  20271, lvl =   3}, -- Judgment            (  0 - 30yd/m) - Lvl  3
		PRIEST      = {id =    585, lvl =   1}, -- smite               (  0 - 40yd/m) - Lvl  4
		ROGUE       = {id =   6770, lvl =  12}, -- Sap                 (  0 - 10yd/m) - Lvl 12 ROG12
		SHAMAN      = {id =    403, lvl =   1}, -- Lightning Bolt      (  0 - 30yd/m) - Lvl  1
		WARLOCK     = {id =    689, lvl =   1}, -- Drain Life          (  0 - 40yd/m) - Lvl  1
		WARRIOR     = {id =    100, lvl =   3}, -- Charge              (  8 - 25yd/m) - Lvl  3
		DEMONHUNTER = {id = 162794, lvl = 100}, -- Chaos Strike        (  8 - 25yd/m) - Lvl  3 ]]
	}
}
--[[
for k1, v1 in pairs(ranges) do
	for k2, v2 in pairs(v1) do
		local name, _, _, _, min, max = GetSpellInfo(v2.id)
		print(k1, k2, "#", "id:", v2.id, "lvl:", v2.lvl, "#", name, min, max, "#", IsSpellKnown(v2.id), "#", GetSpellInfo(v2.id))
	end
end
--]]

local rangeDisplay = { -- RANGE_DISP_LAY
	"STD 100",      --  1 STD Standard (with 'block')
	"STD 50",       --  2
	"STD 10",       --  3
	"STD 100 mono", --  4
	"STD 50 mono",  --  5
	"STD 10 mono",  --  6
	"X 10",         --  7 X (without 'block')
	"X 100 mono",   --  8
	"X 50 mono",    --  9
	"X 10 mono",    -- 10
}

local Textures = {}
Textures.AddonIcon     = "Interface\\AddOns\\BattlegroundTargets\\BattlegroundTargets-texture-button"
Textures.Path          = "Interface\\AddOns\\BattlegroundTargets\\BattlegroundTargets-texture-icons"
Textures.RoleIcon      ={{0.75, 1, 0,    0.25}, -- {48/64, 64/64,  0/64, 16/64} -- 1 HEALER
                         {0.75, 1, 0.25, 0.5},  -- {48/64, 64/64, 16/64, 32/64} -- 2 TANK
                         {0.75, 1, 0.5,  0.75}, -- {48/64, 64/64, 32/64, 48/64} -- 3 DAMAGER
                         {0.75, 1, 0.75, 1}}    -- {48/64, 64/64, 48/64, 64/64} -- 4 UNKNOWN
Textures.UpdateWarning = {0,        0.546875, 0.734375, 0.984375} -- { 0/64, 35/64, 47/64, 63/64},
Textures.CombatIcon    = {0.015625, 0.265625, 0.734375, 0.984375} -- { 1/64, 17/64, 47/64, 63/64},
Textures.FriendIcon    = {path = "Interface\\Common\\friendship-heart", coords = {6/32, 26/32, 3/32, 23/32}}
Textures.EnemyIcon     = {path = "Interface\\PVPFrame\\Icon-Combat", coords = {0, 1, 0, 1}}
Textures.FriendIconStr = "|TInterface\\Common\\friendship-heart:16:16:0:0:32:32:6:26:3:23|t"
Textures.EnemyIconStr  = "|TInterface\\PVPFrame\\Icon-Combat:16:16:0:0:16:16:0:16:0:16|t"
Textures.MoverModeStr  = "|TInterface\\Common\\UI-ModelControlPanel:14:14:0:0:64:128:20:34:38:52|t"

local raidUnitID = {}
for i = 1, 40 do
	raidUnitID["raid"..i] = 1
	raidUnitID["raidpet"..i] = 1
end
local playerUnitID = {
	target = 1,
	pettarget = 1,
	focus = 1,
	mouseover = 1,
}
local sumPos = {0, 45, 90, 135, 180, 225, 270, 315, 360} -- SUMPOSi
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
local function Print(...) print("|cffffff7fBattlegroundTargets:|r", ...) end

local function NOOP() end

local function Desaturation(texture, desaturation)
	local shaderSupported = texture:SetDesaturated(desaturation)
	if not shaderSupported then
		if desaturation then
			texture:SetVertexColor(0.5, 0.5, 0.5)
		else
			texture:SetVertexColor(1.0, 1.0, 1.0)
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:InitOptions()
	SlashCmdList["BATTLEGROUNDTARGETS"] = function()
		BattlegroundTargets:Frame_Toggle(GVAR.OptionsFrame)
	end
	SLASH_BATTLEGROUNDTARGETS1 = "/bgt"
	SLASH_BATTLEGROUNDTARGETS2 = "/bgtargets"
	SLASH_BATTLEGROUNDTARGETS3 = "/battlegroundtargets"

	if type(BattlegroundTargets_Options.version) ~= "number" then
		BattlegroundTargets_Options.version = 27
	end

	if BattlegroundTargets_Options.version < 22 then
		wipe(BattlegroundTargets_Options)
		Print("Option reset.")
		BattlegroundTargets_Options.version = 27
	end

	if BattlegroundTargets_Options.version == 22 then -- targetoftarget position reset
		if type(BattlegroundTargets_Options.ButtonToTPosition) == "table" then
			local v10 = BattlegroundTargets_Options.ButtonToTPosition[10]
			if v10 <= 4 then
				BattlegroundTargets_Options.ButtonToTPosition[10] = v10 + 4
			elseif v10 < 9 then
				BattlegroundTargets_Options.ButtonToTPosition[10] = v10 - 4
			end
			local v15 = BattlegroundTargets_Options.ButtonToTPosition[15]
			if v15 <= 4 then
				BattlegroundTargets_Options.ButtonToTPosition[15] = v15 + 4
			elseif v15 < 9 then
				BattlegroundTargets_Options.ButtonToTPosition[15] = v15 - 4
			end
			local v40 = BattlegroundTargets_Options.ButtonToTPosition[40]
			if v40 <= 4 then
				BattlegroundTargets_Options.ButtonToTPosition[40] = v40 + 4
			elseif v40 < 9 then
				BattlegroundTargets_Options.ButtonToTPosition[40] = v40 - 4
			end
		end
		BattlegroundTargets_Options.version = 23
	end

	if BattlegroundTargets_Options.version == 23 then
		if type(BattlegroundTargets_Options.pos) == "table" then
			local pos = {}
			for k, v in pairs(BattlegroundTargets_Options.pos) do
				if strfind(k, "BattlegroundTargets_MainFrame", 1, true) then
					local size = strmatch(k, "^BattlegroundTargets_MainFrame(.*)$")
					if size and size ~= "" then
						pos["BattlegroundTargets_EnemyMainFrame"..size] = v
					else
						pos["BattlegroundTargets_EnemyMainFrame"] = v
					end
				elseif strfind(k, "BattlegroundTargets_OptionsFrame", 1, true) then
					pos["BattlegroundTargets_OptionsFrame"] = v
				end
			end
			BattlegroundTargets_Options.pos = nil
			BattlegroundTargets_Options.pos = pos
		end
		BattlegroundTargets_Options.version = 24
	end

	if BattlegroundTargets_Options.version == 24 then
		BattlegroundTargets_Options.Enemy = {}
		BattlegroundTargets_Options.Enemy.EnableBracket          = BattlegroundTargets_Options.EnableBracket          BattlegroundTargets_Options.EnableBracket          = nil
		BattlegroundTargets_Options.Enemy.IndependentPositioning = BattlegroundTargets_Options.IndependentPositioning BattlegroundTargets_Options.IndependentPositioning = nil
		BattlegroundTargets_Options.Enemy.LayoutTH               = BattlegroundTargets_Options.LayoutTH               BattlegroundTargets_Options.LayoutTH               = nil
		BattlegroundTargets_Options.Enemy.LayoutSpace            = BattlegroundTargets_Options.LayoutSpace            BattlegroundTargets_Options.LayoutSpace            = nil
		BattlegroundTargets_Options.Enemy.SummaryToggle          = BattlegroundTargets_Options.SummaryToggle          BattlegroundTargets_Options.SummaryToggle          = nil
		BattlegroundTargets_Options.Enemy.SummaryScale           = BattlegroundTargets_Options.SummaryScale           BattlegroundTargets_Options.SummaryScale           = nil
		BattlegroundTargets_Options.Enemy.SummaryPos             = BattlegroundTargets_Options.SummaryPos             BattlegroundTargets_Options.SummaryPos             = nil
		BattlegroundTargets_Options.Enemy.ButtonShowRole         = BattlegroundTargets_Options.ButtonShowRole         BattlegroundTargets_Options.ButtonShowRole         = nil
		BattlegroundTargets_Options.Enemy.ButtonShowSpec         = BattlegroundTargets_Options.ButtonShowSpec         BattlegroundTargets_Options.ButtonShowSpec         = nil
		BattlegroundTargets_Options.Enemy.ButtonClassIcon        = BattlegroundTargets_Options.ButtonClassIcon        BattlegroundTargets_Options.ButtonClassIcon        = nil
		BattlegroundTargets_Options.Enemy.ButtonShowRealm        = BattlegroundTargets_Options.ButtonShowRealm        BattlegroundTargets_Options.ButtonShowRealm        = nil
		BattlegroundTargets_Options.Enemy.ButtonShowLeader       = BattlegroundTargets_Options.ButtonShowLeader       BattlegroundTargets_Options.ButtonShowLeader       = nil
		BattlegroundTargets_Options.Enemy.ButtonShowTarget       = BattlegroundTargets_Options.ButtonShowTarget       BattlegroundTargets_Options.ButtonShowTarget       = nil
		BattlegroundTargets_Options.Enemy.ButtonTargetScale      = BattlegroundTargets_Options.ButtonTargetScale      BattlegroundTargets_Options.ButtonTargetScale      = nil
		BattlegroundTargets_Options.Enemy.ButtonTargetPosition   = BattlegroundTargets_Options.ButtonTargetPosition   BattlegroundTargets_Options.ButtonTargetPosition   = nil
		BattlegroundTargets_Options.Enemy.ButtonShowAssist       = BattlegroundTargets_Options.ButtonShowAssist       BattlegroundTargets_Options.ButtonShowAssist       = nil
		BattlegroundTargets_Options.Enemy.ButtonAssistScale      = BattlegroundTargets_Options.ButtonAssistScale      BattlegroundTargets_Options.ButtonAssistScale      = nil
		BattlegroundTargets_Options.Enemy.ButtonAssistPosition   = BattlegroundTargets_Options.ButtonAssistPosition   BattlegroundTargets_Options.ButtonAssistPosition   = nil
		BattlegroundTargets_Options.Enemy.ButtonShowFocus        = BattlegroundTargets_Options.ButtonShowFocus        BattlegroundTargets_Options.ButtonShowFocus        = nil
		BattlegroundTargets_Options.Enemy.ButtonFocusScale       = BattlegroundTargets_Options.ButtonFocusScale       BattlegroundTargets_Options.ButtonFocusScale       = nil
		BattlegroundTargets_Options.Enemy.ButtonFocusPosition    = BattlegroundTargets_Options.ButtonFocusPosition    BattlegroundTargets_Options.ButtonFocusPosition    = nil
		BattlegroundTargets_Options.Enemy.ButtonShowFlag         = BattlegroundTargets_Options.ButtonShowFlag         BattlegroundTargets_Options.ButtonShowFlag         = nil
		BattlegroundTargets_Options.Enemy.ButtonFlagScale        = BattlegroundTargets_Options.ButtonFlagScale        BattlegroundTargets_Options.ButtonFlagScale        = nil
		BattlegroundTargets_Options.Enemy.ButtonFlagPosition     = BattlegroundTargets_Options.ButtonFlagPosition     BattlegroundTargets_Options.ButtonFlagPosition     = nil
		BattlegroundTargets_Options.Enemy.ButtonShowFTargetCount = false
		BattlegroundTargets_Options.Enemy.ButtonShowETargetCount = BattlegroundTargets_Options.ButtonShowTargetCount  BattlegroundTargets_Options.ButtonShowTargetCount  = nil
		BattlegroundTargets_Options.Enemy.ButtonTargetofTarget   = BattlegroundTargets_Options.ButtonTargetofTarget   BattlegroundTargets_Options.ButtonTargetofTarget   = nil
		BattlegroundTargets_Options.Enemy.ButtonToTScale         = BattlegroundTargets_Options.ButtonToTScale         BattlegroundTargets_Options.ButtonToTScale         = nil
		BattlegroundTargets_Options.Enemy.ButtonToTPosition      = BattlegroundTargets_Options.ButtonToTPosition      BattlegroundTargets_Options.ButtonToTPosition      = nil
		BattlegroundTargets_Options.Enemy.ButtonShowHealthBar    = BattlegroundTargets_Options.ButtonShowHealthBar    BattlegroundTargets_Options.ButtonShowHealthBar    = nil
		BattlegroundTargets_Options.Enemy.ButtonShowHealthText   = BattlegroundTargets_Options.ButtonShowHealthText   BattlegroundTargets_Options.ButtonShowHealthText   = nil
		BattlegroundTargets_Options.Enemy.ButtonRangeCheck       = BattlegroundTargets_Options.ButtonRangeCheck       BattlegroundTargets_Options.ButtonRangeCheck       = nil
		                                                                                                              BattlegroundTargets_Options.ButtonTypeRangeCheck   = nil
		BattlegroundTargets_Options.Enemy.ButtonRangeDisplay     = BattlegroundTargets_Options.ButtonRangeDisplay     BattlegroundTargets_Options.ButtonRangeDisplay     = nil
		BattlegroundTargets_Options.Enemy.ButtonSortBy           = BattlegroundTargets_Options.ButtonSortBy           BattlegroundTargets_Options.ButtonSortBy           = nil
		BattlegroundTargets_Options.Enemy.ButtonSortDetail       = BattlegroundTargets_Options.ButtonSortDetail       BattlegroundTargets_Options.ButtonSortDetail       = nil
		BattlegroundTargets_Options.Enemy.ButtonFontNameSize     = BattlegroundTargets_Options.ButtonFontNameSize     BattlegroundTargets_Options.ButtonFontNameSize     = nil
		BattlegroundTargets_Options.Enemy.ButtonFontNameStyle    = BattlegroundTargets_Options.ButtonFontNameStyle    BattlegroundTargets_Options.ButtonFontNameStyle    = nil
		BattlegroundTargets_Options.Enemy.ButtonFontNumberSize   = BattlegroundTargets_Options.ButtonFontNumberSize   BattlegroundTargets_Options.ButtonFontNumberSize   = nil
		BattlegroundTargets_Options.Enemy.ButtonFontNumberStyle  = BattlegroundTargets_Options.ButtonFontNumberStyle  BattlegroundTargets_Options.ButtonFontNumberStyle  = nil
		BattlegroundTargets_Options.Enemy.ButtonScale            = BattlegroundTargets_Options.ButtonScale            BattlegroundTargets_Options.ButtonScale            = nil
		BattlegroundTargets_Options.Enemy.ButtonWidth            = BattlegroundTargets_Options.ButtonWidth            BattlegroundTargets_Options.ButtonWidth            = nil
		BattlegroundTargets_Options.Enemy.ButtonHeight           = BattlegroundTargets_Options.ButtonHeight           BattlegroundTargets_Options.ButtonHeight           = nil
		BattlegroundTargets_Options.version = 25
	end

	if BattlegroundTargets_Options.version == 25 then
		if type(BattlegroundTargets_Options.pos) == "table" then
			BattlegroundTargets_Options.FramePosition = {}
			-- friend
			local posFdef = BattlegroundTargets_Options.pos.BattlegroundTargets_FriendMainFrame
			if posFdef then
				BattlegroundTargets_Options.FramePosition.FriendMainFrame10 = posFdef
				BattlegroundTargets_Options.FramePosition.FriendMainFrame15 = posFdef
				BattlegroundTargets_Options.FramePosition.FriendMainFrame40 = posFdef
			end
			local posF10 = BattlegroundTargets_Options.pos.BattlegroundTargets_FriendMainFrame10 if posF10 then BattlegroundTargets_Options.FramePosition.FriendMainFrame10 = posF10 end
			local posF15 = BattlegroundTargets_Options.pos.BattlegroundTargets_FriendMainFrame15 if posF15 then BattlegroundTargets_Options.FramePosition.FriendMainFrame15 = posF15 end
			local posF40 = BattlegroundTargets_Options.pos.BattlegroundTargets_FriendMainFrame40 if posF40 then BattlegroundTargets_Options.FramePosition.FriendMainFrame40 = posF40 end
			-- enemy
			local posEdef = BattlegroundTargets_Options.pos.BattlegroundTargets_EnemyMainFrame
			if posEdef then
				BattlegroundTargets_Options.FramePosition.EnemyMainFrame10 = posEdef
				BattlegroundTargets_Options.FramePosition.EnemyMainFrame15 = posEdef
				BattlegroundTargets_Options.FramePosition.EnemyMainFrame40 = posEdef
			end
			local posE10 = BattlegroundTargets_Options.pos.BattlegroundTargets_EnemyMainFrame10 if posE10 then BattlegroundTargets_Options.FramePosition.EnemyMainFrame10 = posE10 end
			local posE15 = BattlegroundTargets_Options.pos.BattlegroundTargets_EnemyMainFrame15 if posE15 then BattlegroundTargets_Options.FramePosition.EnemyMainFrame15 = posE15 end
			local posE40 = BattlegroundTargets_Options.pos.BattlegroundTargets_EnemyMainFrame40 if posE40 then BattlegroundTargets_Options.FramePosition.EnemyMainFrame40 = posE40 end
			-- options
			local posOpt = BattlegroundTargets_Options.pos.BattlegroundTargets_OptionsFrame
			if posOpt then
				BattlegroundTargets_Options.FramePosition.OptionsFrame = posOpt
			end
		end
		BattlegroundTargets_Options.pos = nil
		if BattlegroundTargets_Options.Friend then BattlegroundTargets_Options.Friend.IndependentPositioning = nil end
		if BattlegroundTargets_Options.Enemy then BattlegroundTargets_Options.Enemy.IndependentPositioning = nil end
		BattlegroundTargets_Options.version = 26
	end

	if BattlegroundTargets_Options.version == 26 then
		for frc = 1, #FRAMES do
			local side = FRAMES[frc]
			if type(BattlegroundTargets_Options[side]) == "table" then
				if type(BattlegroundTargets_Options[side].ButtonShowRole)         == "table" then BattlegroundTargets_Options[side].ButtonRoleToggle         = BattlegroundTargets_Options[side].ButtonShowRole         BattlegroundTargets_Options[side].ButtonShowRole = nil end
				if type(BattlegroundTargets_Options[side].ButtonShowSpec)         == "table" then BattlegroundTargets_Options[side].ButtonSpecToggle         = BattlegroundTargets_Options[side].ButtonShowSpec         BattlegroundTargets_Options[side].ButtonShowSpec = nil end
				if type(BattlegroundTargets_Options[side].ButtonClassIcon)        == "table" then BattlegroundTargets_Options[side].ButtonClassToggle        = BattlegroundTargets_Options[side].ButtonClassIcon        BattlegroundTargets_Options[side].ButtonClassIcon = nil end
				if type(BattlegroundTargets_Options[side].ButtonShowRealm)        == "table" then BattlegroundTargets_Options[side].ButtonRealmToggle        = BattlegroundTargets_Options[side].ButtonShowRealm        BattlegroundTargets_Options[side].ButtonShowRealm = nil end
				if type(BattlegroundTargets_Options[side].ButtonShowLeader)       == "table" then BattlegroundTargets_Options[side].ButtonLeaderToggle       = BattlegroundTargets_Options[side].ButtonShowLeader       BattlegroundTargets_Options[side].ButtonShowLeader = nil end
				if type(BattlegroundTargets_Options[side].ButtonShowTarget)       == "table" then BattlegroundTargets_Options[side].ButtonTargetToggle       = BattlegroundTargets_Options[side].ButtonShowTarget       BattlegroundTargets_Options[side].ButtonShowTarget = nil end
				--if type(BattlegroundTargets_Options[side].ButtonTargetScale)      == "table" then BattlegroundTargets_Options[side].ButtonTargetScale        = BattlegroundTargets_Options[side].ButtonTargetScale      end
				--if type(BattlegroundTargets_Options[side].ButtonTargetPosition)   == "table" then BattlegroundTargets_Options[side].ButtonTargetPosition     = BattlegroundTargets_Options[side].ButtonTargetPosition   end
				if type(BattlegroundTargets_Options[side].ButtonShowAssist)       == "table" then BattlegroundTargets_Options[side].ButtonAssistToggle       = BattlegroundTargets_Options[side].ButtonShowAssist       BattlegroundTargets_Options[side].ButtonShowAssist = nil end
				--if type(BattlegroundTargets_Options[side].ButtonAssistScale)      == "table" then BattlegroundTargets_Options[side].ButtonAssistScale        = BattlegroundTargets_Options[side].ButtonAssistScale      end
				--if type(BattlegroundTargets_Options[side].ButtonAssistPosition)   == "table" then BattlegroundTargets_Options[side].ButtonAssistPosition     = BattlegroundTargets_Options[side].ButtonAssistPosition   end
				if type(BattlegroundTargets_Options[side].ButtonShowFocus)        == "table" then BattlegroundTargets_Options[side].ButtonFocusToggle        = BattlegroundTargets_Options[side].ButtonShowFocus        BattlegroundTargets_Options[side].ButtonShowFocus = nil end
				--if type(BattlegroundTargets_Options[side].ButtonFocusScale)       == "table" then BattlegroundTargets_Options[side].ButtonFocusScale         = BattlegroundTargets_Options[side].ButtonFocusScale       end
				--if type(BattlegroundTargets_Options[side].ButtonFocusPosition)    == "table" then BattlegroundTargets_Options[side].ButtonFocusPosition      = BattlegroundTargets_Options[side].ButtonFocusPosition    end
				if type(BattlegroundTargets_Options[side].ButtonShowFlag)         == "table" then BattlegroundTargets_Options[side].ButtonFlagToggle         = BattlegroundTargets_Options[side].ButtonShowFlag         BattlegroundTargets_Options[side].ButtonShowFlag = nil end
				--if type(BattlegroundTargets_Options[side].ButtonFlagScale)        == "table" then BattlegroundTargets_Options[side].ButtonFlagScale          = BattlegroundTargets_Options[side].ButtonFlagScale        end
				--if type(BattlegroundTargets_Options[side].ButtonFlagPosition)     == "table" then BattlegroundTargets_Options[side].ButtonFlagPosition       = BattlegroundTargets_Options[side].ButtonFlagPosition     end
				if type(BattlegroundTargets_Options[side].ButtonShowFTargetCount) == "table" then BattlegroundTargets_Options[side].ButtonFTargetCountToggle = BattlegroundTargets_Options[side].ButtonShowFTargetCount BattlegroundTargets_Options[side].ButtonShowFTargetCount = nil end
				if type(BattlegroundTargets_Options[side].ButtonShowETargetCount) == "table" then BattlegroundTargets_Options[side].ButtonETargetCountToggle = BattlegroundTargets_Options[side].ButtonShowETargetCount BattlegroundTargets_Options[side].ButtonShowETargetCount = nil end
				--if type(BattlegroundTargets_Options[side].ButtonPvPTrinketToggle) == "table" then BattlegroundTargets_Options[side].ButtonPvPTrinketToggle   = BattlegroundTargets_Options[side].ButtonPvPTrinketToggle end
				if type(BattlegroundTargets_Options[side].ButtonTargetofTarget)   == "table" then BattlegroundTargets_Options[side].ButtonToTToggle          = BattlegroundTargets_Options[side].ButtonTargetofTarget   BattlegroundTargets_Options[side].ButtonTargetofTarget = nil end
				--if type(BattlegroundTargets_Options[side].ButtonToTScale)         == "table" then BattlegroundTargets_Options[side].ButtonToTScale           = BattlegroundTargets_Options[side].ButtonToTScale         end
				--if type(BattlegroundTargets_Options[side].ButtonToTPosition)      == "table" then BattlegroundTargets_Options[side].ButtonToTPosition        = BattlegroundTargets_Options[side].ButtonToTPosition      end
				if type(BattlegroundTargets_Options[side].ButtonShowHealthBar)    == "table" then BattlegroundTargets_Options[side].ButtonHealthBarToggle    = BattlegroundTargets_Options[side].ButtonShowHealthBar    BattlegroundTargets_Options[side].ButtonShowHealthBar = nil end
				if type(BattlegroundTargets_Options[side].ButtonShowHealthText)   == "table" then BattlegroundTargets_Options[side].ButtonHealthTextToggle   = BattlegroundTargets_Options[side].ButtonShowHealthText   BattlegroundTargets_Options[side].ButtonShowHealthText = nil end
				if type(BattlegroundTargets_Options[side].ButtonRangeCheck)       == "table" then BattlegroundTargets_Options[side].ButtonRangeToggle        = BattlegroundTargets_Options[side].ButtonRangeCheck       BattlegroundTargets_Options[side].ButtonRangeCheck = nil end
				--if type(BattlegroundTargets_Options[side].ButtonRangeDisplay)     == "table" then BattlegroundTargets_Options[side].ButtonRangeDisplay       = BattlegroundTargets_Options[side].ButtonRangeDisplay     end
				--if type(BattlegroundTargets_Options[side].ButtonSortBy)           == "table" then BattlegroundTargets_Options[side].ButtonSortBy             = BattlegroundTargets_Options[side].ButtonSortBy           end
				--if type(BattlegroundTargets_Options[side].ButtonSortDetail)       == "table" then BattlegroundTargets_Options[side].ButtonSortDetail         = BattlegroundTargets_Options[side].ButtonSortDetail       end
				--if type(BattlegroundTargets_Options[side].ButtonFontNameSize)     == "table" then BattlegroundTargets_Options[side].ButtonFontNameSize       = BattlegroundTargets_Options[side].ButtonFontNameSize     end
				--if type(BattlegroundTargets_Options[side].ButtonFontNameStyle)    == "table" then BattlegroundTargets_Options[side].ButtonFontNameStyle      = BattlegroundTargets_Options[side].ButtonFontNameStyle    end
				--if type(BattlegroundTargets_Options[side].ButtonFontNumberSize)   == "table" then BattlegroundTargets_Options[side].ButtonFontNumberSize     = BattlegroundTargets_Options[side].ButtonFontNumberSize   end
				--if type(BattlegroundTargets_Options[side].ButtonFontNumberStyle)  == "table" then BattlegroundTargets_Options[side].ButtonFontNumberStyle    = BattlegroundTargets_Options[side].ButtonFontNumberStyle  end
				--if type(BattlegroundTargets_Options[side].ButtonScale)            == "table" then BattlegroundTargets_Options[side].ButtonScale              = BattlegroundTargets_Options[side].ButtonScale            end
				--if type(BattlegroundTargets_Options[side].ButtonWidth)            == "table" then BattlegroundTargets_Options[side].ButtonWidth              = BattlegroundTargets_Options[side].ButtonWidth            end
				--if type(BattlegroundTargets_Options[side].ButtonHeight)           == "table" then BattlegroundTargets_Options[side].ButtonHeight             = BattlegroundTargets_Options[side].ButtonHeight           end
			end
		end
		BattlegroundTargets_Options.version = 27
	end

	--BattlegroundTargets_Options = {} -- TEST

	if type(BattlegroundTargets_Options.FramePosition)         ~= "table"   then BattlegroundTargets_Options.FramePosition         = {}    end
	if type(BattlegroundTargets_Options.MinimapButton)         ~= "boolean" then BattlegroundTargets_Options.MinimapButton         = false end
	if type(BattlegroundTargets_Options.MinimapButtonPos)      ~= "number"  then BattlegroundTargets_Options.MinimapButtonPos      = -90   end
	if type(BattlegroundTargets_Options.TransliterationToggle) ~= "boolean" then BattlegroundTargets_Options.TransliterationToggle = false end

	for frc = 1, #FRAMES do
		local side = FRAMES[frc]
		if type(BattlegroundTargets_Options[side])                              ~= "table"   then BattlegroundTargets_Options[side]                              = {}    end

		if type(BattlegroundTargets_Options[side].EnableBracket)                ~= "table"   then BattlegroundTargets_Options[side].EnableBracket                = {}    end
		if type(BattlegroundTargets_Options[side].EnableBracket[10])            ~= "boolean" then BattlegroundTargets_Options[side].EnableBracket[10]            = false end
		if type(BattlegroundTargets_Options[side].EnableBracket[15])            ~= "boolean" then BattlegroundTargets_Options[side].EnableBracket[15]            = false end
		if type(BattlegroundTargets_Options[side].EnableBracket[40])            ~= "boolean" then BattlegroundTargets_Options[side].EnableBracket[40]            = false end

		if type(BattlegroundTargets_Options[side].LayoutTH)                     ~= "table"   then BattlegroundTargets_Options[side].LayoutTH                     = {}    end
		if type(BattlegroundTargets_Options[side].LayoutTH[10])                 ~= "number"  then BattlegroundTargets_Options[side].LayoutTH[10]                 = 18    end
		if type(BattlegroundTargets_Options[side].LayoutTH[15])                 ~= "number"  then BattlegroundTargets_Options[side].LayoutTH[15]                 = 18    end
		if type(BattlegroundTargets_Options[side].LayoutTH[40])                 ~= "number"  then BattlegroundTargets_Options[side].LayoutTH[40]                 = 24    end
		if type(BattlegroundTargets_Options[side].LayoutSpace)                  ~= "table"   then BattlegroundTargets_Options[side].LayoutSpace                  = {}    end
		if type(BattlegroundTargets_Options[side].LayoutSpace[10])              ~= "number"  then BattlegroundTargets_Options[side].LayoutSpace[10]              = 0     end
		if type(BattlegroundTargets_Options[side].LayoutSpace[15])              ~= "number"  then BattlegroundTargets_Options[side].LayoutSpace[15]              = 0     end
		if type(BattlegroundTargets_Options[side].LayoutSpace[40])              ~= "number"  then BattlegroundTargets_Options[side].LayoutSpace[40]              = 0     end

		if type(BattlegroundTargets_Options[side].SummaryToggle)                ~= "table"   then BattlegroundTargets_Options[side].SummaryToggle                = {}    end
		if type(BattlegroundTargets_Options[side].SummaryToggle[10])            ~= "boolean" then BattlegroundTargets_Options[side].SummaryToggle[10]            = false end
		if type(BattlegroundTargets_Options[side].SummaryToggle[15])            ~= "boolean" then BattlegroundTargets_Options[side].SummaryToggle[15]            = false end
		if type(BattlegroundTargets_Options[side].SummaryToggle[40])            ~= "boolean" then BattlegroundTargets_Options[side].SummaryToggle[40]            = false end
		if type(BattlegroundTargets_Options[side].SummaryScale)                 ~= "table"   then BattlegroundTargets_Options[side].SummaryScale                 = {}    end
		if type(BattlegroundTargets_Options[side].SummaryScale[10])             ~= "number"  then BattlegroundTargets_Options[side].SummaryScale[10]             = 0.6   end
		if type(BattlegroundTargets_Options[side].SummaryScale[15])             ~= "number"  then BattlegroundTargets_Options[side].SummaryScale[15]             = 0.6   end
		if type(BattlegroundTargets_Options[side].SummaryScale[40])             ~= "number"  then BattlegroundTargets_Options[side].SummaryScale[40]             = 0.5   end
		if type(BattlegroundTargets_Options[side].SummaryPos)                   ~= "table"   then BattlegroundTargets_Options[side].SummaryPos                   = {}    end
		if type(BattlegroundTargets_Options[side].SummaryPos[10])               ~= "number"  then BattlegroundTargets_Options[side].SummaryPos[10]               = 1     end
		if type(BattlegroundTargets_Options[side].SummaryPos[15])               ~= "number"  then BattlegroundTargets_Options[side].SummaryPos[15]               = 1     end
		if type(BattlegroundTargets_Options[side].SummaryPos[40])               ~= "number"  then BattlegroundTargets_Options[side].SummaryPos[40]               = 1     end

		if type(BattlegroundTargets_Options[side].ButtonRoleToggle)             ~= "table"   then BattlegroundTargets_Options[side].ButtonRoleToggle             = {}    end
		if type(BattlegroundTargets_Options[side].ButtonSpecToggle)             ~= "table"   then BattlegroundTargets_Options[side].ButtonSpecToggle             = {}    end
		if type(BattlegroundTargets_Options[side].ButtonClassToggle)            ~= "table"   then BattlegroundTargets_Options[side].ButtonClassToggle            = {}    end
		if type(BattlegroundTargets_Options[side].ButtonRealmToggle)            ~= "table"   then BattlegroundTargets_Options[side].ButtonRealmToggle            = {}    end
		if type(BattlegroundTargets_Options[side].ButtonLeaderToggle)           ~= "table"   then BattlegroundTargets_Options[side].ButtonLeaderToggle           = {}    end
		if type(BattlegroundTargets_Options[side].ButtonTargetToggle)           ~= "table"   then BattlegroundTargets_Options[side].ButtonTargetToggle           = {}    end
		if type(BattlegroundTargets_Options[side].ButtonTargetScale)            ~= "table"   then BattlegroundTargets_Options[side].ButtonTargetScale            = {}    end
		if type(BattlegroundTargets_Options[side].ButtonTargetPosition)         ~= "table"   then BattlegroundTargets_Options[side].ButtonTargetPosition         = {}    end
		if type(BattlegroundTargets_Options[side].ButtonAssistToggle)           ~= "table"   then BattlegroundTargets_Options[side].ButtonAssistToggle           = {}    end
		if type(BattlegroundTargets_Options[side].ButtonAssistScale)            ~= "table"   then BattlegroundTargets_Options[side].ButtonAssistScale            = {}    end
		if type(BattlegroundTargets_Options[side].ButtonAssistPosition)         ~= "table"   then BattlegroundTargets_Options[side].ButtonAssistPosition         = {}    end
		if type(BattlegroundTargets_Options[side].ButtonFocusToggle)            ~= "table"   then BattlegroundTargets_Options[side].ButtonFocusToggle            = {}    end
		if type(BattlegroundTargets_Options[side].ButtonFocusScale)             ~= "table"   then BattlegroundTargets_Options[side].ButtonFocusScale             = {}    end
		if type(BattlegroundTargets_Options[side].ButtonFocusPosition)          ~= "table"   then BattlegroundTargets_Options[side].ButtonFocusPosition          = {}    end
		if type(BattlegroundTargets_Options[side].ButtonFlagToggle)             ~= "table"   then BattlegroundTargets_Options[side].ButtonFlagToggle             = {}    end
		if type(BattlegroundTargets_Options[side].ButtonFlagScale)              ~= "table"   then BattlegroundTargets_Options[side].ButtonFlagScale              = {}    end
		if type(BattlegroundTargets_Options[side].ButtonFlagPosition)           ~= "table"   then BattlegroundTargets_Options[side].ButtonFlagPosition           = {}    end
		if type(BattlegroundTargets_Options[side].ButtonFTargetCountToggle)     ~= "table"   then BattlegroundTargets_Options[side].ButtonFTargetCountToggle     = {}    end
		if type(BattlegroundTargets_Options[side].ButtonETargetCountToggle)     ~= "table"   then BattlegroundTargets_Options[side].ButtonETargetCountToggle     = {}    end
		if type(BattlegroundTargets_Options[side].ButtonPvPTrinketToggle)       ~= "table"   then BattlegroundTargets_Options[side].ButtonPvPTrinketToggle       = {}    end
		if type(BattlegroundTargets_Options[side].ButtonToTToggle)              ~= "table"   then BattlegroundTargets_Options[side].ButtonToTToggle              = {}    end
		if type(BattlegroundTargets_Options[side].ButtonToTScale)               ~= "table"   then BattlegroundTargets_Options[side].ButtonToTScale               = {}    end
		if type(BattlegroundTargets_Options[side].ButtonToTPosition)            ~= "table"   then BattlegroundTargets_Options[side].ButtonToTPosition            = {}    end
		if type(BattlegroundTargets_Options[side].ButtonHealthBarToggle)        ~= "table"   then BattlegroundTargets_Options[side].ButtonHealthBarToggle        = {}    end
		if type(BattlegroundTargets_Options[side].ButtonHealthTextToggle)       ~= "table"   then BattlegroundTargets_Options[side].ButtonHealthTextToggle       = {}    end
		if type(BattlegroundTargets_Options[side].ButtonRangeToggle)            ~= "table"   then BattlegroundTargets_Options[side].ButtonRangeToggle            = {}    end
		if type(BattlegroundTargets_Options[side].ButtonRangeDisplay)           ~= "table"   then BattlegroundTargets_Options[side].ButtonRangeDisplay           = {}    end
		if type(BattlegroundTargets_Options[side].ButtonSortBy)                 ~= "table"   then BattlegroundTargets_Options[side].ButtonSortBy                 = {}    end
		if type(BattlegroundTargets_Options[side].ButtonSortDetail)             ~= "table"   then BattlegroundTargets_Options[side].ButtonSortDetail             = {}    end
		if type(BattlegroundTargets_Options[side].ButtonFontNameSize)           ~= "table"   then BattlegroundTargets_Options[side].ButtonFontNameSize           = {}    end
		if type(BattlegroundTargets_Options[side].ButtonFontNameStyle)          ~= "table"   then BattlegroundTargets_Options[side].ButtonFontNameStyle          = {}    end
		if type(BattlegroundTargets_Options[side].ButtonFontNumberSize)         ~= "table"   then BattlegroundTargets_Options[side].ButtonFontNumberSize         = {}    end
		if type(BattlegroundTargets_Options[side].ButtonFontNumberStyle)        ~= "table"   then BattlegroundTargets_Options[side].ButtonFontNumberStyle        = {}    end
		if type(BattlegroundTargets_Options[side].ButtonScale)                  ~= "table"   then BattlegroundTargets_Options[side].ButtonScale                  = {}    end
		if type(BattlegroundTargets_Options[side].ButtonWidth)                  ~= "table"   then BattlegroundTargets_Options[side].ButtonWidth                  = {}    end
		if type(BattlegroundTargets_Options[side].ButtonHeight)                 ~= "table"   then BattlegroundTargets_Options[side].ButtonHeight                 = {}    end

		if type(BattlegroundTargets_Options[side].ButtonRoleToggle[10])         ~= "boolean" then BattlegroundTargets_Options[side].ButtonRoleToggle[10]         = true  end
		if type(BattlegroundTargets_Options[side].ButtonSpecToggle[10])         ~= "boolean" then BattlegroundTargets_Options[side].ButtonSpecToggle[10]         = false end
		if type(BattlegroundTargets_Options[side].ButtonClassToggle[10])        ~= "boolean" then BattlegroundTargets_Options[side].ButtonClassToggle[10]        = false end
		if type(BattlegroundTargets_Options[side].ButtonRealmToggle[10])        ~= "boolean" then BattlegroundTargets_Options[side].ButtonRealmToggle[10]        = true  end
		if type(BattlegroundTargets_Options[side].ButtonLeaderToggle[10])       ~= "boolean" then BattlegroundTargets_Options[side].ButtonLeaderToggle[10]       = true  end
		if type(BattlegroundTargets_Options[side].ButtonTargetToggle[10])       ~= "boolean" then BattlegroundTargets_Options[side].ButtonTargetToggle[10]       = true  end
		if type(BattlegroundTargets_Options[side].ButtonTargetScale[10])        ~= "number"  then BattlegroundTargets_Options[side].ButtonTargetScale[10]        = 1.5   end
		if type(BattlegroundTargets_Options[side].ButtonTargetPosition[10])     ~= "number"  then BattlegroundTargets_Options[side].ButtonTargetPosition[10]     = 100   end
		if type(BattlegroundTargets_Options[side].ButtonAssistToggle[10])       ~= "boolean" then BattlegroundTargets_Options[side].ButtonAssistToggle[10]       = false end
		if type(BattlegroundTargets_Options[side].ButtonAssistScale[10])        ~= "number"  then BattlegroundTargets_Options[side].ButtonAssistScale[10]        = 1.2   end
		if type(BattlegroundTargets_Options[side].ButtonAssistPosition[10])     ~= "number"  then BattlegroundTargets_Options[side].ButtonAssistPosition[10]     = 100   end
		if type(BattlegroundTargets_Options[side].ButtonFocusToggle[10])        ~= "boolean" then BattlegroundTargets_Options[side].ButtonFocusToggle[10]        = false end
		if type(BattlegroundTargets_Options[side].ButtonFocusScale[10])         ~= "number"  then BattlegroundTargets_Options[side].ButtonFocusScale[10]         = 1     end
		if type(BattlegroundTargets_Options[side].ButtonFocusPosition[10])      ~= "number"  then BattlegroundTargets_Options[side].ButtonFocusPosition[10]      = 70    end
		if type(BattlegroundTargets_Options[side].ButtonFlagToggle[10])         ~= "boolean" then BattlegroundTargets_Options[side].ButtonFlagToggle[10]         = true  end
		if type(BattlegroundTargets_Options[side].ButtonFlagScale[10])          ~= "number"  then BattlegroundTargets_Options[side].ButtonFlagScale[10]          = 1.2   end
		if type(BattlegroundTargets_Options[side].ButtonFlagPosition[10])       ~= "number"  then BattlegroundTargets_Options[side].ButtonFlagPosition[10]       = 60    end
		if type(BattlegroundTargets_Options[side].ButtonFTargetCountToggle[10]) ~= "boolean" then BattlegroundTargets_Options[side].ButtonFTargetCountToggle[10] = false end
		if type(BattlegroundTargets_Options[side].ButtonETargetCountToggle[10]) ~= "boolean" then BattlegroundTargets_Options[side].ButtonETargetCountToggle[10] = false end
		if type(BattlegroundTargets_Options[side].ButtonPvPTrinketToggle[10])   ~= "boolean" then BattlegroundTargets_Options[side].ButtonPvPTrinketToggle[10]   = false end
		if type(BattlegroundTargets_Options[side].ButtonToTToggle[10])          ~= "boolean" then BattlegroundTargets_Options[side].ButtonToTToggle[10]          = false end
		if type(BattlegroundTargets_Options[side].ButtonToTScale[10])           ~= "number"  then BattlegroundTargets_Options[side].ButtonToTScale[10]           = 0.8   end
		if type(BattlegroundTargets_Options[side].ButtonToTPosition[10])        ~= "number"  then BattlegroundTargets_Options[side].ButtonToTPosition[10]        = 8     end
		if type(BattlegroundTargets_Options[side].ButtonHealthBarToggle[10])    ~= "boolean" then BattlegroundTargets_Options[side].ButtonHealthBarToggle[10]    = false end
		if type(BattlegroundTargets_Options[side].ButtonHealthTextToggle[10])   ~= "boolean" then BattlegroundTargets_Options[side].ButtonHealthTextToggle[10]   = false end
		if type(BattlegroundTargets_Options[side].ButtonRangeToggle[10])        ~= "boolean" then BattlegroundTargets_Options[side].ButtonRangeToggle[10]        = false end
		if type(BattlegroundTargets_Options[side].ButtonRangeDisplay[10])       ~= "number"  then BattlegroundTargets_Options[side].ButtonRangeDisplay[10]       = 1     end
		if type(BattlegroundTargets_Options[side].ButtonSortBy[10])             ~= "number"  then BattlegroundTargets_Options[side].ButtonSortBy[10]             = 1     end
		if type(BattlegroundTargets_Options[side].ButtonSortDetail[10])         ~= "number"  then BattlegroundTargets_Options[side].ButtonSortDetail[10]         = 3     end
		if type(BattlegroundTargets_Options[side].ButtonFontNameSize[10])       ~= "number"  then BattlegroundTargets_Options[side].ButtonFontNameSize[10]       = 12    end
		if type(BattlegroundTargets_Options[side].ButtonFontNameStyle[10])      ~= "number"  then BattlegroundTargets_Options[side].ButtonFontNameStyle[10]      = defaultFont end
		if type(BattlegroundTargets_Options[side].ButtonFontNumberSize[10])     ~= "number"  then BattlegroundTargets_Options[side].ButtonFontNumberSize[10]     = 10    end
		if type(BattlegroundTargets_Options[side].ButtonFontNumberStyle[10])    ~= "number"  then BattlegroundTargets_Options[side].ButtonFontNumberStyle[10]    = 1     end
		if type(BattlegroundTargets_Options[side].ButtonScale[10])              ~= "number"  then BattlegroundTargets_Options[side].ButtonScale[10]              = 1     end
		if type(BattlegroundTargets_Options[side].ButtonWidth[10])              ~= "number"  then BattlegroundTargets_Options[side].ButtonWidth[10]              = 175   end
		if type(BattlegroundTargets_Options[side].ButtonHeight[10])             ~= "number"  then BattlegroundTargets_Options[side].ButtonHeight[10]             = 20    end

		if type(BattlegroundTargets_Options[side].ButtonRoleToggle[15])         ~= "boolean" then BattlegroundTargets_Options[side].ButtonRoleToggle[15]         = true  end
		if type(BattlegroundTargets_Options[side].ButtonSpecToggle[15])         ~= "boolean" then BattlegroundTargets_Options[side].ButtonSpecToggle[15]         = false end
		if type(BattlegroundTargets_Options[side].ButtonClassToggle[15])        ~= "boolean" then BattlegroundTargets_Options[side].ButtonClassToggle[15]        = false end
		if type(BattlegroundTargets_Options[side].ButtonRealmToggle[15])        ~= "boolean" then BattlegroundTargets_Options[side].ButtonRealmToggle[15]        = true  end
		if type(BattlegroundTargets_Options[side].ButtonLeaderToggle[15])       ~= "boolean" then BattlegroundTargets_Options[side].ButtonLeaderToggle[15]       = true  end
		if type(BattlegroundTargets_Options[side].ButtonTargetToggle[15])       ~= "boolean" then BattlegroundTargets_Options[side].ButtonTargetToggle[15]       = true  end
		if type(BattlegroundTargets_Options[side].ButtonTargetScale[15])        ~= "number"  then BattlegroundTargets_Options[side].ButtonTargetScale[15]        = 1.5   end
		if type(BattlegroundTargets_Options[side].ButtonTargetPosition[15])     ~= "number"  then BattlegroundTargets_Options[side].ButtonTargetPosition[15]     = 100   end
		if type(BattlegroundTargets_Options[side].ButtonAssistToggle[15])       ~= "boolean" then BattlegroundTargets_Options[side].ButtonAssistToggle[15]       = false end
		if type(BattlegroundTargets_Options[side].ButtonAssistScale[15])        ~= "number"  then BattlegroundTargets_Options[side].ButtonAssistScale[15]        = 1.2   end
		if type(BattlegroundTargets_Options[side].ButtonAssistPosition[15])     ~= "number"  then BattlegroundTargets_Options[side].ButtonAssistPosition[15]     = 100   end
		if type(BattlegroundTargets_Options[side].ButtonFocusToggle[15])        ~= "boolean" then BattlegroundTargets_Options[side].ButtonFocusToggle[15]        = false end
		if type(BattlegroundTargets_Options[side].ButtonFocusScale[15])         ~= "number"  then BattlegroundTargets_Options[side].ButtonFocusScale[15]         = 1     end
		if type(BattlegroundTargets_Options[side].ButtonFocusPosition[15])      ~= "number"  then BattlegroundTargets_Options[side].ButtonFocusPosition[15]      = 70    end
		if type(BattlegroundTargets_Options[side].ButtonFlagToggle[15])         ~= "boolean" then BattlegroundTargets_Options[side].ButtonFlagToggle[15]         = true  end
		if type(BattlegroundTargets_Options[side].ButtonFlagScale[15])          ~= "number"  then BattlegroundTargets_Options[side].ButtonFlagScale[15]          = 1.2   end
		if type(BattlegroundTargets_Options[side].ButtonFlagPosition[15])       ~= "number"  then BattlegroundTargets_Options[side].ButtonFlagPosition[15]       = 60    end
		if type(BattlegroundTargets_Options[side].ButtonFTargetCountToggle[15]) ~= "boolean" then BattlegroundTargets_Options[side].ButtonFTargetCountToggle[15] = false end
		if type(BattlegroundTargets_Options[side].ButtonETargetCountToggle[15]) ~= "boolean" then BattlegroundTargets_Options[side].ButtonETargetCountToggle[15] = false end
		if type(BattlegroundTargets_Options[side].ButtonPvPTrinketToggle[15])   ~= "boolean" then BattlegroundTargets_Options[side].ButtonPvPTrinketToggle[15]   = false end
		if type(BattlegroundTargets_Options[side].ButtonToTToggle[15])          ~= "boolean" then BattlegroundTargets_Options[side].ButtonToTToggle[15]          = false end
		if type(BattlegroundTargets_Options[side].ButtonToTScale[15])           ~= "number"  then BattlegroundTargets_Options[side].ButtonToTScale[15]           = 0.8   end
		if type(BattlegroundTargets_Options[side].ButtonToTPosition[15])        ~= "number"  then BattlegroundTargets_Options[side].ButtonToTPosition[15]        = 8     end
		if type(BattlegroundTargets_Options[side].ButtonHealthBarToggle[15])    ~= "boolean" then BattlegroundTargets_Options[side].ButtonHealthBarToggle[15]    = false end
		if type(BattlegroundTargets_Options[side].ButtonHealthTextToggle[15])   ~= "boolean" then BattlegroundTargets_Options[side].ButtonHealthTextToggle[15]   = false end
		if type(BattlegroundTargets_Options[side].ButtonRangeToggle[15])        ~= "boolean" then BattlegroundTargets_Options[side].ButtonRangeToggle[15]        = false end
		if type(BattlegroundTargets_Options[side].ButtonRangeDisplay[15])       ~= "number"  then BattlegroundTargets_Options[side].ButtonRangeDisplay[15]       = 1     end
		if type(BattlegroundTargets_Options[side].ButtonSortBy[15])             ~= "number"  then BattlegroundTargets_Options[side].ButtonSortBy[15]             = 1     end
		if type(BattlegroundTargets_Options[side].ButtonSortDetail[15])         ~= "number"  then BattlegroundTargets_Options[side].ButtonSortDetail[15]         = 3     end
		if type(BattlegroundTargets_Options[side].ButtonFontNameSize[15])       ~= "number"  then BattlegroundTargets_Options[side].ButtonFontNameSize[15]       = 12    end
		if type(BattlegroundTargets_Options[side].ButtonFontNameStyle[15])      ~= "number"  then BattlegroundTargets_Options[side].ButtonFontNameStyle[15]      = defaultFont end
		if type(BattlegroundTargets_Options[side].ButtonFontNumberSize[15])     ~= "number"  then BattlegroundTargets_Options[side].ButtonFontNumberSize[15]     = 10    end
		if type(BattlegroundTargets_Options[side].ButtonFontNumberStyle[15])    ~= "number"  then BattlegroundTargets_Options[side].ButtonFontNumberStyle[15]    = 1     end
		if type(BattlegroundTargets_Options[side].ButtonScale[15])              ~= "number"  then BattlegroundTargets_Options[side].ButtonScale[15]              = 1     end
		if type(BattlegroundTargets_Options[side].ButtonWidth[15])              ~= "number"  then BattlegroundTargets_Options[side].ButtonWidth[15]              = 175   end
		if type(BattlegroundTargets_Options[side].ButtonHeight[15])             ~= "number"  then BattlegroundTargets_Options[side].ButtonHeight[15]             = 20    end

		if type(BattlegroundTargets_Options[side].ButtonRoleToggle[40])         ~= "boolean" then BattlegroundTargets_Options[side].ButtonRoleToggle[40]         = true  end
		if type(BattlegroundTargets_Options[side].ButtonSpecToggle[40])         ~= "boolean" then BattlegroundTargets_Options[side].ButtonSpecToggle[40]         = false end
		if type(BattlegroundTargets_Options[side].ButtonClassToggle[40])        ~= "boolean" then BattlegroundTargets_Options[side].ButtonClassToggle[40]        = false end
		if type(BattlegroundTargets_Options[side].ButtonRealmToggle[40])        ~= "boolean" then BattlegroundTargets_Options[side].ButtonRealmToggle[40]        = false end
		if type(BattlegroundTargets_Options[side].ButtonLeaderToggle[40])       ~= "boolean" then BattlegroundTargets_Options[side].ButtonLeaderToggle[40]       = true  end
		if type(BattlegroundTargets_Options[side].ButtonTargetToggle[40])       ~= "boolean" then BattlegroundTargets_Options[side].ButtonTargetToggle[40]       = true  end
		if type(BattlegroundTargets_Options[side].ButtonTargetScale[40])        ~= "number"  then BattlegroundTargets_Options[side].ButtonTargetScale[40]        = 1     end
		if type(BattlegroundTargets_Options[side].ButtonTargetPosition[40])     ~= "number"  then BattlegroundTargets_Options[side].ButtonTargetPosition[40]     = 85    end
		if type(BattlegroundTargets_Options[side].ButtonAssistToggle[40])       ~= "boolean" then BattlegroundTargets_Options[side].ButtonAssistToggle[40]       = false end
		if type(BattlegroundTargets_Options[side].ButtonAssistScale[40])        ~= "number"  then BattlegroundTargets_Options[side].ButtonAssistScale[40]        = 1     end
		if type(BattlegroundTargets_Options[side].ButtonAssistPosition[40])     ~= "number"  then BattlegroundTargets_Options[side].ButtonAssistPosition[40]     = 70    end
		if type(BattlegroundTargets_Options[side].ButtonFocusToggle[40])        ~= "boolean" then BattlegroundTargets_Options[side].ButtonFocusToggle[40]        = false end
		if type(BattlegroundTargets_Options[side].ButtonFocusScale[40])         ~= "number"  then BattlegroundTargets_Options[side].ButtonFocusScale[40]         = 1     end
		if type(BattlegroundTargets_Options[side].ButtonFocusPosition[40])      ~= "number"  then BattlegroundTargets_Options[side].ButtonFocusPosition[40]      = 55    end
		if type(BattlegroundTargets_Options[side].ButtonFlagToggle[40])         ~= "boolean" then BattlegroundTargets_Options[side].ButtonFlagToggle[40]         = false end
		if type(BattlegroundTargets_Options[side].ButtonFlagScale[40])          ~= "number"  then BattlegroundTargets_Options[side].ButtonFlagScale[40]          = 1     end
		if type(BattlegroundTargets_Options[side].ButtonFlagPosition[40])       ~= "number"  then BattlegroundTargets_Options[side].ButtonFlagPosition[40]       = 100   end
		if type(BattlegroundTargets_Options[side].ButtonFTargetCountToggle[40]) ~= "boolean" then BattlegroundTargets_Options[side].ButtonFTargetCountToggle[40] = false end
		if type(BattlegroundTargets_Options[side].ButtonETargetCountToggle[40]) ~= "boolean" then BattlegroundTargets_Options[side].ButtonETargetCountToggle[40] = false end
		if type(BattlegroundTargets_Options[side].ButtonPvPTrinketToggle[40])   ~= "boolean" then BattlegroundTargets_Options[side].ButtonPvPTrinketToggle[40]   = false end
		if type(BattlegroundTargets_Options[side].ButtonToTToggle[40])          ~= "boolean" then BattlegroundTargets_Options[side].ButtonToTToggle[40]          = false end
		if type(BattlegroundTargets_Options[side].ButtonToTScale[40])           ~= "number"  then BattlegroundTargets_Options[side].ButtonToTScale[40]           = 0.6   end
		if type(BattlegroundTargets_Options[side].ButtonToTPosition[40])        ~= "number"  then BattlegroundTargets_Options[side].ButtonToTPosition[40]        = 9     end
		if type(BattlegroundTargets_Options[side].ButtonHealthBarToggle[40])    ~= "boolean" then BattlegroundTargets_Options[side].ButtonHealthBarToggle[40]    = false end
		if type(BattlegroundTargets_Options[side].ButtonHealthTextToggle[40])   ~= "boolean" then BattlegroundTargets_Options[side].ButtonHealthTextToggle[40]   = false end
		if type(BattlegroundTargets_Options[side].ButtonRangeToggle[40])        ~= "boolean" then BattlegroundTargets_Options[side].ButtonRangeToggle[40]        = false end
		if type(BattlegroundTargets_Options[side].ButtonRangeDisplay[40])       ~= "number"  then BattlegroundTargets_Options[side].ButtonRangeDisplay[40]       = 7     end
		if type(BattlegroundTargets_Options[side].ButtonSortBy[40])             ~= "number"  then BattlegroundTargets_Options[side].ButtonSortBy[40]             = 1     end
		if type(BattlegroundTargets_Options[side].ButtonSortDetail[40])         ~= "number"  then BattlegroundTargets_Options[side].ButtonSortDetail[40]         = 3     end
		if type(BattlegroundTargets_Options[side].ButtonFontNameSize[40])       ~= "number"  then BattlegroundTargets_Options[side].ButtonFontNameSize[40]       = 10    end
		if type(BattlegroundTargets_Options[side].ButtonFontNameStyle[40])      ~= "number"  then BattlegroundTargets_Options[side].ButtonFontNameStyle[40]      = defaultFont end
		if type(BattlegroundTargets_Options[side].ButtonFontNumberSize[40])     ~= "number"  then BattlegroundTargets_Options[side].ButtonFontNumberSize[40]     = 10    end
		if type(BattlegroundTargets_Options[side].ButtonFontNumberStyle[40])    ~= "number"  then BattlegroundTargets_Options[side].ButtonFontNumberStyle[40]    = 1     end
		if type(BattlegroundTargets_Options[side].ButtonScale[40])              ~= "number"  then BattlegroundTargets_Options[side].ButtonScale[40]              = 1     end
		if type(BattlegroundTargets_Options[side].ButtonWidth[40])              ~= "number"  then BattlegroundTargets_Options[side].ButtonWidth[40]              = 100   end
		if type(BattlegroundTargets_Options[side].ButtonHeight[40])             ~= "number"  then BattlegroundTargets_Options[side].ButtonHeight[40]             = 16    end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:LDBcheck()
	if LibStub and LibStub:GetLibrary("CallbackHandler-1.0", true) and LibStub:GetLibrary("LibDataBroker-1.1", true) then
		LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("BattlegroundTargets", {
			type = "launcher",
			icon = Textures.AddonIcon,
			OnClick = function(self, button)
				BattlegroundTargets:Frame_Toggle(GVAR.OptionsFrame)
			end,
		})
	end
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CreateInterfaceOptions()
	GVAR.InterfaceOptions = CreateFrame("Frame", nil)
	GVAR.InterfaceOptions.name = "BattlegroundTargets"

	GVAR.InterfaceOptions.Title = GVAR.InterfaceOptions:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	GVAR.InterfaceOptions.Title:SetText("BattlegroundTargets")
	GVAR.InterfaceOptions.Title:SetJustifyH("LEFT")
	GVAR.InterfaceOptions.Title:SetJustifyV("TOP")
	GVAR.InterfaceOptions.Title:SetPoint("TOPLEFT", 16, -16)

	GVAR.InterfaceOptions.CONFIG = CreateFrame("Button", nil, GVAR.InterfaceOptions)
	TEMPLATE.TextButton(GVAR.InterfaceOptions.CONFIG, L["Open Configuration"], 1)
	GVAR.InterfaceOptions.CONFIG:SetWidth(180)
	GVAR.InterfaceOptions.CONFIG:SetHeight(22)
	GVAR.InterfaceOptions.CONFIG:SetPoint("TOPLEFT", GVAR.InterfaceOptions.Title, "BOTTOMLEFT", 0, -10)
	GVAR.InterfaceOptions.CONFIG:SetScript("OnClick", function()
		InterfaceOptionsFrame_Show()
		HideUIPanel(GameMenuFrame)
		BattlegroundTargets:Frame_Toggle(GVAR.OptionsFrame)
	end)

	GVAR.InterfaceOptions.SlashCommandText = GVAR.InterfaceOptions:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.InterfaceOptions.SlashCommandText:SetText("/bgt - /bgtargets - /battlegroundtargets")
	GVAR.InterfaceOptions.SlashCommandText:SetNonSpaceWrap(true)
	GVAR.InterfaceOptions.SlashCommandText:SetPoint("LEFT", GVAR.InterfaceOptions.CONFIG, "RIGHT", 10, 0)
	GVAR.InterfaceOptions.SlashCommandText:SetTextColor(1, 1, 0.49, 1)

	InterfaceOptions_AddCategory(GVAR.InterfaceOptions)
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CreateFrames()
	for frc = 1, #FRAMES do
		local side = FRAMES[frc]
		local framename  = side.."MainFrame" -- FriendMainFrame / EnemyMainFrame
		local buttonname = side.."Button"    -- FriendButton    / EnemyButton

		-- main frame
		GVAR[framename] = CreateFrame("Frame", "BattlegroundTargets_"..framename, UIParent)
		GVAR[framename]:EnableMouse(true)
		GVAR[framename]:SetMovable(true)
		GVAR[framename]:SetResizable(true)
		GVAR[framename]:SetToplevel(true)
		GVAR[framename]:SetClampedToScreen(true) -- TODO bug? -- CLAMP_FIX_MAIN TODO
		GVAR[framename]:SetWidth(0.001)
		GVAR[framename]:SetHeight(0.001)
		GVAR[framename]:Hide()
		-- main frame

		-- create global_OnUpdate
		GVAR[side.."ScreenShot_Timer_Button"] = CreateFrame("Button", nil, GVAR[framename])
		GVAR[side.."Target_Timer_Button"] = CreateFrame("Button", nil, GVAR[framename])
		GVAR[side.."PVPTrinket_Timer_Button"] = CreateFrame("Button", nil, GVAR[framename])
		GVAR[side.."RangeCheck_Timer_Button"] = CreateFrame("Button", nil, GVAR[framename])
		-- create global_OnUpdate

		-- create button
		GVAR[buttonname] = {}
		for i = 1, 40 do
			GVAR[buttonname][i] = CreateFrame("Button", nil, UIParent, "SecureActionButtonTemplate") -- button_name
			local button = GVAR[buttonname][i]
			button:SetPoint("TOPLEFT", GVAR[framename], "BOTTOMLEFT", 0, 0)
			button:Hide()
			button:RegisterForClicks("AnyUp")
			button:SetAttribute("type1", "macro")
			button:SetAttribute("type2", "macro")
			button:SetAttribute("macrotext1", "")
			button:SetAttribute("macrotext2", "")
			button:SetScript("OnEnter", function(self)
				self.HighlightT:SetColorTexture(1, 1, 0.49, 1)
				self.HighlightR:SetColorTexture(1, 1, 0.49, 1)
				self.HighlightB:SetColorTexture(1, 1, 0.49, 1)
				self.HighlightL:SetColorTexture(1, 1, 0.49, 1)
			end)
			button:SetScript("OnLeave", function(self)
				if isTargetButton == self then
					self.HighlightT:SetColorTexture(0.5, 0.5, 0.5, 1)
					self.HighlightR:SetColorTexture(0.5, 0.5, 0.5, 1)
					self.HighlightB:SetColorTexture(0.5, 0.5, 0.5, 1)
					self.HighlightL:SetColorTexture(0.5, 0.5, 0.5, 1)
				else
					self.HighlightT:SetColorTexture(0, 0, 0, 1)
					self.HighlightR:SetColorTexture(0, 0, 0, 1)
					self.HighlightB:SetColorTexture(0, 0, 0, 1)
					self.HighlightL:SetColorTexture(0, 0, 0, 1)
				end
			end)

			button.ToTButton = CreateFrame("Button", nil, button) -- target_of_target -- xBUT -- button_name
			button.ToTButton:EnableMouse(false)
			button.ToTButton:SetAlpha(0)
		end
		-- create button

		-- MonoblockAnchor
		GVAR[framename].MonoblockAnchor = CreateFrame("Frame", nil, GVAR[buttonname][1]) -- SUMPOSi
		GVAR[framename].MonoblockAnchor:SetPoint("TOPLEFT", GVAR[buttonname][1], "TOPLEFT", 0, 0)
		-- MonoblockAnchor
	end

	-- main mover
	local function OnMouseDown(side, framename)
		if inCombat or InCombatLockdown() then return end
		GVAR[framename].isMoving = true
		BattlegroundTargets:ClickOnFractionTab(side)
		GVAR[framename]:StartMoving()
	end
	local function OnMouseUp(side, framename)
		if not GVAR[framename].isMoving then return end
		GVAR[framename].isMoving = nil
		GVAR[framename]:StopMovingOrSizing()
		if inCombat or InCombatLockdown() then
			rePosMain = true
			return
		end
		rePosMain = nil
		BattlegroundTargets:Frame_SavePosition("BattlegroundTargets_"..framename, side)
	end

	for frc = 1, #FRAMES do
		local side = FRAMES[frc]
		local framename  = side.."MainFrame" -- FriendMainFrame / EnemyMainFrame
		local buttonname = side.."Button"    -- FriendButton    / EnemyButton

		--------------------
		GVAR[framename].MainMoverFrame = CreateFrame("Frame", nil, GVAR[buttonname][1])
		GVAR[framename].MainMoverFrame:SetPoint("TOPLEFT", GVAR[buttonname][1], "TOPLEFT", 0, 0)
		GVAR[framename].MainMoverFrame:Hide()

		GVAR[framename].MainMoverTexture = GVAR[framename].MainMoverFrame:CreateTexture(nil, "BORDER")
		GVAR[framename].MainMoverTexture:SetColorTexture(0, 0, 0, 0)
		GVAR[framename].MainMoverTexture:SetAllPoints()

		-- mover mode frame
		GVAR[framename].MainMoverBGTexture = GVAR[framename].MainMoverFrame:CreateTexture(nil, "ARTWORK")
		GVAR[framename].MainMoverBGTexture:SetColorTexture(0, 0, 0, 1)
		GVAR[framename].MainMoverBGTexture:SetPoint("CENTER", GVAR[framename].MainMoverFrame, "CENTER", 0, 0)

		GVAR[framename].MainMoverFracTxt = GVAR[framename].MainMoverFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
		GVAR[framename].MainMoverFracTxt:SetPoint("TOP", GVAR[framename].MainMoverBGTexture, "TOP", 0, 0)
		if side == "Friend" then
			GVAR[framename].MainMoverFracTxt:SetText(Textures.FriendIconStr.." "..L["Friendly Players"])
		elseif side == "Enemy" then
			GVAR[framename].MainMoverFracTxt:SetText(Textures.EnemyIconStr.." "..L["Enemy Players"])
		end
		GVAR[framename].MainMoverFracTxt:SetTextColor(1, 1, 1, 1)

		GVAR[framename].MainMoverTxt = GVAR[framename].MainMoverFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		GVAR[framename].MainMoverTxt:SetPoint("TOP", GVAR[framename].MainMoverFracTxt, "BOTTOM", 0, -10)
		GVAR[framename].MainMoverTxt:SetText(L["click & move"])
		GVAR[framename].MainMoverTxt:SetWidth( GVAR[framename].MainMoverTxt:GetStringWidth() )
		GVAR[framename].MainMoverTxt:SetHeight( GVAR[framename].MainMoverTxt:GetStringHeight() )
		GVAR[framename].MainMoverTxt:SetTextColor(0.5, 0.5, 0.5, 1)

		GVAR[framename].MainMoverModeButton = CreateFrame("CheckButton", nil, GVAR[framename].MainMoverFrame)
		TEMPLATE.CheckButton(GVAR[framename].MainMoverModeButton, 16, 4, Textures.MoverModeStr.." "..L["Mode"])
		GVAR[framename].MainMoverModeButton:SetPoint("TOP", GVAR[framename].MainMoverTxt, "BOTTOM", 0, -10)
		GVAR[framename].MainMoverModeButton:SetChecked(DATA[side].MainMoverModeValue)
		GVAR[framename].MainMoverModeButton:SetScript("OnClick", function()
			--if inCombat or InCombatLockdown() then return end
			GVAR[framename].MainMoverTexture:SetColorTexture(0, 0, 1, 0.4)
			BattlegroundTargets:ClickOnFractionTab(side)
			if DATA[side].MainMoverModeValue then
				DATA[side].MainMoverModeValue = false
			else
				DATA[side].MainMoverModeValue = true
			end
		end)

		local maxW = GVAR[framename].MainMoverFracTxt:GetWidth()
		local maxW2 = GVAR[framename].MainMoverTxt:GetWidth()
		if maxW2 > maxW then maxW = maxW2 end
		local maxW3 = GVAR[framename].MainMoverModeButton:GetWidth()
		if maxW3 > maxW then maxW = maxW3 end
		local maxH = GVAR[framename].MainMoverFracTxt:GetHeight() + 10 + GVAR[framename].MainMoverTxt:GetHeight() + 10 + GVAR[framename].MainMoverModeButton:GetHeight()
		GVAR[framename].MainMoverBGTexture:SetWidth(maxW+5)
		GVAR[framename].MainMoverBGTexture:SetHeight(maxH+5)
		-- mover mode frame

		GVAR[framename].MainMoverFrame:SetScript("OnLeave", function()
			if GVAR[framename].MainMoverModeButton:IsMouseOver() then return end
			GVAR[framename].MainMoverTxt:SetTextColor(0.5, 0.5, 0.5, 1)
			if DATA[side].MainMoverModeValue then return end
			GVAR[framename].MainMoverTexture:SetColorTexture(0, 0, 0, 0)
			GVAR[framename].MainMoverFrame:Hide()
			GVAR[framename].MainMoverButton[1]:Show()
			GVAR[framename].MainMoverButton[2]:Show()
		end)
		GVAR[framename].MainMoverFrame:SetScript("OnEnter", function()
			GVAR[framename].MainMoverTexture:SetColorTexture(0, 0, 1, 0.4)
			GVAR[framename].MainMoverTxt:SetTextColor(1, 1, 1, 1)
			GVAR[framename].MainMoverButton[1]:Hide()
			GVAR[framename].MainMoverButton[2]:Hide()
		end)
		GVAR[framename].MainMoverFrame:SetScript("OnMouseDown", function() OnMouseDown(side, framename) end)
		GVAR[framename].MainMoverFrame:SetScript("OnMouseUp", function() OnMouseUp(side, framename) end)
		--------------------

		--------------------
		GVAR[framename].MainMoverButton = CreateFrame("Frame", nil, GVAR[framename])
		GVAR[framename].MainMoverButton:SetPoint("CENTER", GVAR[framename].MonoblockAnchor, "CENTER", 0, 0)
		for topORbottom = 1, 2 do
			GVAR[framename].MainMoverButton[topORbottom] = CreateFrame("Button", nil, GVAR[framename].MainMoverButton)
			GVAR[framename].MainMoverButton[topORbottom]:SetWidth(200)
			GVAR[framename].MainMoverButton[topORbottom]:SetHeight(25)
			if topORbottom == 1 then
				GVAR[framename].MainMoverButton[topORbottom]:SetPoint("BOTTOM", GVAR[framename].MonoblockAnchor, "TOP", 0, 0) -- TOP
			else
				GVAR[framename].MainMoverButton[topORbottom]:SetPoint("TOP", GVAR[framename].MonoblockAnchor, "BOTTOM", 0, 0) -- BOTTOM
			end
			GVAR[framename].MainMoverButton[topORbottom].Texture = GVAR[framename].MainMoverButton[topORbottom]:CreateTexture(nil, "BACKGROUND")
			GVAR[framename].MainMoverButton[topORbottom].Texture:SetAllPoints()
			GVAR[framename].MainMoverButton[topORbottom].Texture:SetColorTexture(1, 1, 1, 0.2)
			GVAR[framename].MainMoverButton[topORbottom].Txt = GVAR[framename].MainMoverButton[topORbottom]:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
			GVAR[framename].MainMoverButton[topORbottom].Txt:SetAllPoints()
			if side == "Friend" then
				GVAR[framename].MainMoverButton[topORbottom].Txt:SetText(Textures.FriendIconStr.." "..L["Friendly Players"])
			elseif side == "Enemy" then
				GVAR[framename].MainMoverButton[topORbottom].Txt:SetText(Textures.EnemyIconStr.." "..L["Enemy Players"])
			end
			GVAR[framename].MainMoverButton[topORbottom].Txt:SetTextColor(1, 1, 1, 1)

			GVAR[framename].MainMoverButton[topORbottom]:SetScript("OnEnter", function(self)
				if inCombat or InCombatLockdown() then return end
				GVAR[framename].MainMoverTxt:SetTextColor(1, 1, 1, 1)
				GVAR[framename].MainMoverFrame:SetFrameLevel( GVAR[side.."Button"][1]:GetFrameLevel() + 10 )
				GVAR[framename].MainMoverFrame:Show()
			end)
			GVAR[framename].MainMoverButton[topORbottom]:SetScript("OnLeave", function(self)
				if not GVAR[framename].MainMoverFrame:IsMouseOver() then
					GVAR[framename].MainMoverFrame:Hide()
				end
			end)
			GVAR[framename].MainMoverButton[topORbottom]:SetScript("OnMouseDown", function() OnMouseDown(side, framename) end)
			GVAR[framename].MainMoverButton[topORbottom]:SetScript("OnMouseUp", function() OnMouseUp(side, framename) end)
		end
		--------------------
	end
	-- main mover

	-- button
	BattlegroundTargets.targetCountTimer = 0 -- _TIMER_
	BattlegroundTargets.pvptrinketTimer = 0 -- _TIMER_ -- pvp_trinket_
	for frc = 1, #FRAMES do
		local side = FRAMES[frc]
		local buttonname = GVAR[side.."Button"]
		for buttontype = 1, 2 do
			for i = 1, 40 do
				local button

				if buttontype == 1 then
					button = buttonname[i]
					button.carrierDebuffTimer = 0 -- _TIMER_ -- carrier_debuff_
					button.healthTimer = 0 -- _TIMER_ -- health_
					button.rangeTimer = 0 -- _TIMER_ -- class_range_
					button.leaderTimer = 0 -- _TIMER_ -- leader_
					button.assistTimer = 0 -- _TIMER_ -- assist_
				else--if buttontype == 2 then
					button = buttonname[i].ToTButton
				end

				button.colR  = 0
				button.colG  = 0
				button.colB  = 0
				button.colR5 = 0
				button.colG5 = 0
				button.colB5 = 0

				button.HighlightT = button:CreateTexture(nil, "BACKGROUND")
				button.HighlightT:SetHeight(1)
				button.HighlightT:SetPoint("TOP", 0, 0)
				button.HighlightT:SetColorTexture(0, 0, 0, 1)
				button.HighlightR = button:CreateTexture(nil, "BACKGROUND")
				button.HighlightR:SetWidth(1)
				button.HighlightR:SetPoint("RIGHT", 0, 0)
				button.HighlightR:SetColorTexture(0, 0, 0, 1)
				button.HighlightB = button:CreateTexture(nil, "BACKGROUND")
				button.HighlightB:SetHeight(1)
				button.HighlightB:SetPoint("BOTTOM", 0, 0)
				button.HighlightB:SetColorTexture(0, 0, 0, 1)
				button.HighlightL = button:CreateTexture(nil, "BACKGROUND")
				button.HighlightL:SetWidth(1)
				button.HighlightL:SetPoint("LEFT", 0, 0)
				button.HighlightL:SetColorTexture(0, 0, 0, 1)

				button.BackgroundX = button:CreateTexture(nil, "BACKGROUND")
				button.BackgroundX:SetPoint("TOPLEFT", 1, -1)
				button.BackgroundX:SetColorTexture(0, 0, 0, 1)

				button.RangeTexture = button:CreateTexture(nil, "BORDER")
				button.RangeTexture:SetPoint("LEFT", button, "LEFT", 1, 0)
				button.RangeTexture:SetColorTexture(0, 0, 0, 0)

				button.RangeTxt = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
				button.RangeTxt:SetWidth(50)
				button.RangeTxt:SetPoint("RIGHT", button.RangeTexture, "RIGHT", 0, 0)
				button.RangeTxt:SetJustifyH("RIGHT")
				button.RangeTxt:SetShadowOffset(0, 0)
				button.RangeTxt:SetShadowColor(0, 0, 0, 0)
				button.RangeTxt:SetTextColor(1, 1, 1, 1)
				--button.RangeTxt:SetAlpha(0.6)

				button.PVPTrinketTexture = button:CreateTexture(nil, "BORDER")
				button.PVPTrinketTexture:SetPoint("RIGHT", button, "LEFT", -2, 0)
				button.PVPTrinketTexture:SetTexture( 1322720)				--old   ("Interface\\Icons\\INV_Jewelry_TrinketPVP_01")
				--button.PVPTrinketTexture:SetTexCoord(0.07812501, 0.92187499, 0.07812501, 0.92187499)--(5/64, 59/64, 5/64, 59/64)
				button.PVPTrinketTxt = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
				button.PVPTrinketTxt:SetWidth(50)
				button.PVPTrinketTxt:SetPoint("CENTER", button.PVPTrinketTexture, "CENTER", 0, 0)
				button.PVPTrinketTxt:SetJustifyH("CENTER")
				button.PVPTrinketTxt:SetShadowOffset(0, 0)
				button.PVPTrinketTxt:SetShadowColor(0, 0, 0, 0)
				button.PVPTrinketTxt:SetTextColor(1, 1, 1, 1)

				button.FactionTexture = button:CreateTexture(nil, "BORDER")
				button.FactionTexture:SetPoint("LEFT", button.BackgroundX, "LEFT", 1, 0)

				button.RoleTexture = button:CreateTexture(nil, "BORDER")
				button.RoleTexture:SetPoint("LEFT", button.RangeTexture, "RIGHT", 0, 0)
				button.RoleTexture:SetTexture(Textures.Path)
				button.RoleTexture:SetTexCoord(0, 0, 0, 0)

				button.SpecTexture = button:CreateTexture(nil, "BORDER")
				button.SpecTexture:SetPoint("LEFT", button.RoleTexture, "RIGHT", 0, 0)
				button.SpecTexture:SetTexture(nil)
				button.SpecTexture:SetTexCoord(0.07812501, 0.92187499, 0.07812501, 0.92187499)--(5/64, 59/64, 5/64, 59/64)

				button.ClassTexture = button:CreateTexture(nil, "BORDER")
				button.ClassTexture:SetPoint("LEFT", button.SpecTexture, "RIGHT", 0, 0)
				button.ClassTexture:SetTexture("Interface\\WorldStateFrame\\Icons-Classes")
				button.ClassTexture:SetTexCoord(0, 0, 0, 0)

				button.LeaderTexture = button:CreateTexture(nil, "ARTWORK")
				button.LeaderTexture:SetTexture("Interface\\GroupFrame\\UI-Group-LeaderIcon")
				button.LeaderTexture:SetAlpha(0)

				button.ClassColorBackground = button:CreateTexture(nil, "BORDER")
				button.ClassColorBackground:SetColorTexture(0, 0, 0, 0)

				button.HealthBar = button:CreateTexture(nil, "ARTWORK")
				button.HealthBar:SetPoint("LEFT", button.ClassColorBackground, "LEFT", 0, 0)
				button.HealthBar:SetColorTexture(0, 0, 0, 0)

				button.HealthTextButton = CreateFrame("Button", nil, button) -- xBUT
				button.HealthText = button.HealthTextButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
				button.HealthText:SetWidth(100)
				button.HealthText:SetPoint("RIGHT", button.ClassColorBackground, "RIGHT", 0, 0)
				button.HealthText:SetJustifyH("RIGHT")
				button.HealthText:SetShadowOffset(0, 0)
				button.HealthText:SetShadowColor(0, 0, 0, 0)
				button.HealthText:SetTextColor(1, 1, 1, 1)
				--button.HealthText:SetAlpha(0.6)

				button.Name = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
				button.Name:SetPoint("LEFT", button.ClassColorBackground, "LEFT", 2, 0)
				button.Name:SetJustifyH("LEFT")
				button.Name:SetShadowOffset(0, 0)
				button.Name:SetShadowColor(0, 0, 0, 1)
				button.Name:SetTextColor(0, 0, 0, 1)

				-- target count
				button.TargetCountBackground = button:CreateTexture(nil, "ARTWORK")
				button.TargetCountBackground:SetPoint("RIGHT", button, "RIGHT", -1, 0)
				button.TargetCountBackground:SetColorTexture(0, 0, 0, 1)

				button.ETargetCount = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
				button.ETargetCount:SetPoint("RIGHT", button.TargetCountBackground, "RIGHT", 0, 0)
				button.ETargetCount:SetJustifyH("CENTER")
				button.ETargetCount:SetShadowOffset(0, 0)
				button.ETargetCount:SetShadowColor(0, 0, 0, 1)
				button.ETargetCount:SetTextColor(1, 1, 1, 1)

				button.FTargetCount = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
				button.FTargetCount:SetPoint("LEFT", button.TargetCountBackground, "LEFT", 0, 0)
				button.FTargetCount:SetJustifyH("CENTER")
				button.FTargetCount:SetShadowOffset(0, 0)
				button.FTargetCount:SetShadowColor(0, 0, 0, 0)
				button.FTargetCount:SetTextColor(0, 1, 0, 1)
				-- target count

				button.TargetTextureButton = CreateFrame("Button", nil, button) -- xBUT
				button.TargetTexture = button.TargetTextureButton:CreateTexture(nil, "OVERLAY")
				button.TargetTexture:SetTexture("Interface\\Minimap\\Tracking\\Target")
				button.TargetTexture:SetAlpha(0)

				button.FocusTextureButton = CreateFrame("Button", nil, button) -- xBUT
				button.FocusTexture = button.FocusTextureButton:CreateTexture(nil, "OVERLAY")
				button.FocusTexture:SetTexture("Interface\\Minimap\\Tracking\\Focus")
				button.FocusTexture:SetAlpha(0)

				-- carrier
				button.FlagTextureButton = CreateFrame("Button", nil, button) -- xBUT
				button.FlagTexture = button.FlagTextureButton:CreateTexture(nil, "OVERLAY")
				button.FlagTexture:SetTexture(Textures.flagTexture)
				button.FlagTexture:SetAlpha(0)

				button.FlagDebuffButton = CreateFrame("Button", nil, button) -- xBUT
				button.FlagDebuff = button.FlagDebuffButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
				button.FlagDebuff:SetWidth(50)
				button.FlagDebuff:SetPoint("CENTER", button.FlagTexture, "CENTER", 0, 0)
				--button.FlagDebuff:SetPoint("TOP", button, "TOP", 0, 0)
				button.FlagDebuff:SetJustifyH("CENTER")
				button.FlagDebuff:SetJustifyV("TOP")
				button.FlagDebuff:SetShadowOffset(0, 0)
				button.FlagDebuff:SetShadowColor(0, 0, 0, 0)
				button.FlagDebuff:SetTextColor(1, 1, 1, 1)

				button.OrbCornerTL = button.FlagDebuffButton:CreateTexture(nil, "OVERLAY")
				button.OrbCornerTL:SetPoint("LEFT", button.FlagTexture, "LEFT", 0, 0)
				button.OrbCornerTL:SetPoint("TOP", button, "TOP", 0, -2)
				button.OrbCornerTL:SetColorTexture(0, 0, 0, 1)
				button.OrbCornerTR = button.FlagDebuffButton:CreateTexture(nil, "OVERLAY")
				button.OrbCornerTR:SetPoint("RIGHT", button.FlagTexture, "RIGHT", 0, 0)
				button.OrbCornerTR:SetPoint("TOP", button, "TOP", 0, -2)
				button.OrbCornerTR:SetColorTexture(0, 0, 0, 1)
				button.OrbCornerBL = button.FlagDebuffButton:CreateTexture(nil, "OVERLAY")
				button.OrbCornerBL:SetPoint("LEFT", button.FlagTexture, "LEFT", 0, 0)
				button.OrbCornerBL:SetPoint("BOTTOM", button, "BOTTOM", 0, 2)
				button.OrbCornerBL:SetColorTexture(0, 0, 0, 1)
				button.OrbCornerBR = button.FlagDebuffButton:CreateTexture(nil, "OVERLAY")
				button.OrbCornerBR:SetPoint("RIGHT", button.FlagTexture, "RIGHT", 0, 0)
				button.OrbCornerBR:SetPoint("BOTTOM", button, "BOTTOM", 0, 2)
				button.OrbCornerBR:SetColorTexture(0, 0, 0, 1)
				-- carrier

				button.AssistTextureButton = CreateFrame("Button", nil, button) -- xBUT
				button.AssistTargetTexture = button.AssistTextureButton:CreateTexture(nil, "OVERLAY")
				button.AssistTargetTexture:SetTexture("Interface\\RaidFrame\\UI-RaidFrame-MainAssist")
				button.AssistTargetTexture:SetTexCoord(0.07812501, 0.92187499, 0.07812501, 0.92187499)--(5/64, 59/64, 5/64, 59/64)
				button.AssistTargetTexture:SetAlpha(0)

				button.AssistSourceTexture = button.AssistTextureButton:CreateTexture(nil, "ARTWORK")
				button.AssistSourceTexture:SetTexture("Interface\\GroupFrame\\UI-Group-AssistantIcon")
				button.AssistSourceTexture:SetAlpha(0)
			end
		end
	end
	-- button

	local function FontTemplate(button)
		button:SetSize(60, 20)
		button:SetJustifyH("CENTER")
		button:SetFont(fontPath, 20, "OUTLINE")
		button:SetShadowOffset(0, 0)
		button:SetShadowColor(0, 0, 0, 0)
		button:SetTextColor(1, 1, 1, 1)
	end

	for frc = 1, #FRAMES do
		local side = FRAMES[frc]

		GVAR[side.."ScoreUpdateTexture"] = GVAR[side.."Button"][1]:CreateTexture(nil, "OVERLAY")
		local ScoreUpdateTexture = GVAR[side.."ScoreUpdateTexture"]
		ScoreUpdateTexture:SetSize(30.45, 13.92) -- (26.25*1.16, 12*1.16)
		ScoreUpdateTexture:SetPoint("BOTTOMLEFT", GVAR[side.."Button"][1], "TOPLEFT", 1, 1)
		ScoreUpdateTexture:SetTexture(Textures.Path)
		ScoreUpdateTexture:SetTexCoord(unpack(Textures.UpdateWarning))

		GVAR[side.."IsGhostTexture"] = GVAR[side.."Button"][1]:CreateTexture(nil, "OVERLAY")
		local IsGhostTexture = GVAR[side.."IsGhostTexture"]
		IsGhostTexture:SetSize(24, 24)
		IsGhostTexture:SetPoint("LEFT", ScoreUpdateTexture, "RIGHT", 0, 0)
		IsGhostTexture:SetTexture("Interface\\WorldStateFrame\\SkullBones")
		IsGhostTexture:SetTexCoord(0, 0.5, 0, 0.5)
		IsGhostTexture:Hide()

		GVAR[side.."Summary"] = CreateFrame("Frame", nil, GVAR[side.."Button"][1]) -- SUMMARY
		local Summary = GVAR[side.."Summary"]
		Summary:SetToplevel(true)
		Summary:SetSize(140, 60)

		Summary.Healer = Summary:CreateTexture(nil, "ARTWORK")
		Summary.Healer:SetSize(20, 20)
		Summary.Healer:SetPoint("TOPLEFT", Summary, "TOPLEFT", 60, 0)
		Summary.Healer:SetTexture(Textures.Path)
		Summary.Healer:SetTexCoord(unpack(Textures.RoleIcon[1]))
		Summary.Tank = Summary:CreateTexture(nil, "ARTWORK")
		Summary.Tank:SetSize(20, 20)
		Summary.Tank:SetPoint("TOP", Summary.Healer, "BOTTOM", 0, 0)
		Summary.Tank:SetTexture(Textures.Path)
		Summary.Tank:SetTexCoord(unpack(Textures.RoleIcon[2]))
		Summary.Damage = Summary:CreateTexture(nil, "ARTWORK")
		Summary.Damage:SetSize(20, 20)
		Summary.Damage:SetPoint("TOP", Summary.Tank, "BOTTOM", 0, 0)
		Summary.Damage:SetTexture(Textures.Path)
		Summary.Damage:SetTexCoord(unpack(Textures.RoleIcon[3]))

		             Summary.HealerFriend = Summary:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		             Summary.HealerFriend:SetPoint("RIGHT", Summary.Healer, "LEFT", 15, 0)
		FontTemplate(Summary.HealerFriend)
		             Summary.HealerEnemy = Summary:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		             Summary.HealerEnemy:SetPoint("LEFT", Summary.Healer, "RIGHT", -15, 0)
		FontTemplate(Summary.HealerEnemy)
		             Summary.TankFriend = Summary:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		             Summary.TankFriend:SetPoint("RIGHT", Summary.Tank, "LEFT", 15, 0)
		FontTemplate(Summary.TankFriend)
		             Summary.TankEnemy = Summary:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		             Summary.TankEnemy:SetPoint("LEFT", Summary.Tank, "RIGHT", -15, 0)
		FontTemplate(Summary.TankEnemy)
		             Summary.DamageFriend = Summary:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		             Summary.DamageFriend:SetPoint("RIGHT", Summary.Damage, "LEFT", 15, 0)
		FontTemplate(Summary.DamageFriend)
		             Summary.DamageEnemy = Summary:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		             Summary.DamageEnemy:SetPoint("LEFT", Summary.Damage, "RIGHT", -15, 0)
		FontTemplate(Summary.DamageEnemy)

		Summary.Logo1 = Summary:CreateTexture(nil, "BACKGROUND")
		Summary.Logo1:SetSize(60, 60)
		Summary.Logo1:SetPoint("RIGHT", Summary.Tank, "LEFT", 0, 0)
		Summary.Logo2 = Summary:CreateTexture(nil, "BACKGROUND")
		Summary.Logo2:SetSize(60, 60)
		Summary.Logo2:SetPoint("LEFT", Summary.Tank, "RIGHT", 0, 0)

		if playerFactionDEF == 0 then -- summary_flag_texture - 12 - initial
			Summary.Logo1:SetTexture("Interface\\FriendsFrame\\PlusManz-Horde")
			Summary.Logo2:SetTexture("Interface\\FriendsFrame\\PlusManz-Alliance")
		elseif playerFactionDEF == 1 then
			Summary.Logo1:SetTexture("Interface\\FriendsFrame\\PlusManz-Alliance")
			Summary.Logo2:SetTexture("Interface\\FriendsFrame\\PlusManz-Horde")
		else
			Summary.Logo1:SetTexture("Interface\\Timer\\Panda-Logo")
			Summary.Logo2:SetTexture("Interface\\Timer\\Panda-Logo")
		end
	end

	BattlegroundTargets:SetupMonoblockPosition("Enemy")
	BattlegroundTargets:SetupMonoblockPosition("Friend")
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CreateOptionsFrame()
	local BattlegroundTargets_Options = BattlegroundTargets_Options

	BattlegroundTargets:DefaultShuffle()

	local heightBase = 58
	local heightBracket = 585

	-- 10+16+10+22                                          58 -- heightBase

	-- 10+22                                                32 -- fraction
	-- 10+16                                                26 -- top enable
	-- 8+1+8 + 16+10 + 16+10 + 16 + 10                      95 -- scale -> height
	-- 8+1+8 + 16 +                                         33 -- sort
	-- 8+1+8 + 16+10 + 16 +                                 59 -- layout -> summary
	-- 8+1+8 + 16+10 + 16+10 + 16 +                         85 -- row role -> targetcount
	-- 8+1+8 + 16+10 + 16+10 + 16+10 + 16+10 + 16          137 -- target -> targetassist
	-- 8+1+8 + 16+10 + 16 +                                 59 -- health -> range
	-- 8+1+8 + 16+10 + 16 +                                 59 -- fonts
	--                                                    =====
	--                                                     585
	local heightTotal = heightBase + heightBracket + 30 + 10



	-- ####################################################################################################
	-- xMx local func
	local function HighlightOnEnter(what)
		GVAR.OptionsFrame.LayoutTHText.Background:SetColorTexture(1, 1, 1, 0.15) -- COPYHL
		GVAR.OptionsFrame.LayoutTHx18.Highlight:Show()
		GVAR.OptionsFrame.LayoutTHx24.Highlight:Show()
		GVAR.OptionsFrame.LayoutTHx42.Highlight:Show()
		GVAR.OptionsFrame.LayoutTHx81.Highlight:Show()
		GVAR.OptionsFrame.LayoutSpace.Background:SetColorTexture(1, 1, 1, 0.15) -- COPYHL
		GVAR.OptionsFrame.SummaryText.Background:SetColorTexture(1, 1, 1, 0.15) -- COPYHL
		GVAR.OptionsFrame.SummaryToggle.Highlight:Show()
		GVAR.OptionsFrame.SummaryScale.Background:SetColorTexture(1, 1, 1, 0.15) -- COPYHL
		GVAR.OptionsFrame.SummaryPosition.Background:SetColorTexture(1, 1, 1, 0.15) -- COPYHL
		----------
		GVAR.OptionsFrame.ShowRole.Highlight:Show()
		GVAR.OptionsFrame.ShowSpec.Highlight:Show()
		GVAR.OptionsFrame.ClassIcon.Highlight:Show()
		GVAR.OptionsFrame.ShowLeader.Highlight:Show()
		GVAR.OptionsFrame.ShowRealm.Highlight:Show()
		GVAR.OptionsFrame.ShowPVPTrinket.Highlight:Show()
		GVAR.OptionsFrame.ShowFTargetCount.Highlight:Show()
		GVAR.OptionsFrame.ShowETargetCount.Highlight:Show()
		----------
		GVAR.OptionsFrame.ShowTargetIndicator.Highlight:Show()
		GVAR.OptionsFrame.TargetScaleSlider.Background:SetColorTexture(1, 1, 1, 0.15) -- COPYHL
		GVAR.OptionsFrame.TargetPositionSlider.Background:SetColorTexture(1, 1, 1, 0.15) -- COPYHL
		GVAR.OptionsFrame.TargetofTarget.Highlight:Show()
		GVAR.OptionsFrame.ToTScaleSlider.Background:SetColorTexture(1, 1, 1, 0.15) -- COPYHL
		GVAR.OptionsFrame.ToTPositionSlider.Background:SetColorTexture(1, 1, 1, 0.15) -- COPYHL
		GVAR.OptionsFrame.ShowFocusIndicator.Highlight:Show()
		GVAR.OptionsFrame.FocusScaleSlider.Background:SetColorTexture(1, 1, 1, 0.15) -- COPYHL
		GVAR.OptionsFrame.FocusPositionSlider.Background:SetColorTexture(1, 1, 1, 0.15) -- COPYHL
		GVAR.OptionsFrame.ShowFlag.Highlight:Show()
		GVAR.OptionsFrame.FlagScaleSlider.Background:SetColorTexture(1, 1, 1, 0.15) -- COPYHL
		GVAR.OptionsFrame.FlagPositionSlider.Background:SetColorTexture(1, 1, 1, 0.15) -- COPYHL
		GVAR.OptionsFrame.ShowAssist.Highlight:Show()
		GVAR.OptionsFrame.AssistScaleSlider.Background:SetColorTexture(1, 1, 1, 0.15) -- COPYHL
		GVAR.OptionsFrame.AssistPositionSlider.Background:SetColorTexture(1, 1, 1, 0.15) -- COPYHL
		----------
		GVAR.OptionsFrame.ShowHealthBar.Highlight:Show()
		GVAR.OptionsFrame.ShowHealthText.Highlight:Show()
		GVAR.OptionsFrame.RangeCheck.Highlight:Show()
		GVAR.OptionsFrame.RangeDisplayPullDown:LockHighlight()
		GVAR.OptionsFrame.SortByTitle.Background:SetColorTexture(1, 1, 1, 0.15) -- COPYHL
		GVAR.OptionsFrame.SortByPullDown:LockHighlight()
		GVAR.OptionsFrame.SortDetailPullDown:LockHighlight()
		----------
		GVAR.OptionsFrame.FontNameTitle.Background:SetColorTexture(1, 1, 1, 0.15) -- COPYHL
		GVAR.OptionsFrame.FontNamePullDown:LockHighlight()
		GVAR.OptionsFrame.FontNameSlider.Background:SetColorTexture(1, 1, 1, 0.15) -- COPYHL
		GVAR.OptionsFrame.FontNumberTitle.Background:SetColorTexture(1, 1, 1, 0.15) -- COPYHL
		GVAR.OptionsFrame.FontNumberPullDown:LockHighlight()
		GVAR.OptionsFrame.FontNumberSlider.Background:SetColorTexture(1, 1, 1, 0.15) -- COPYHL
		GVAR.OptionsFrame.ScaleTitle.Background:SetColorTexture(1, 1, 1, 0.15) -- COPYHL
		GVAR.OptionsFrame.ScaleSlider.Background:SetColorTexture(1, 1, 1, 0.15) -- COPYHL
		GVAR.OptionsFrame.WidthTitle.Background:SetColorTexture(1, 1, 1, 0.15) -- COPYHL
		GVAR.OptionsFrame.WidthSlider.Background:SetColorTexture(1, 1, 1, 0.15) -- COPYHL
		GVAR.OptionsFrame.HeightTitle.Background:SetColorTexture(1, 1, 1, 0.15) -- COPYHL
		GVAR.OptionsFrame.HeightSlider.Background:SetColorTexture(1, 1, 1, 0.15) -- COPYHL
		if what == "sameSize" then
			if currentSize == 10 then
				GVAR.OptionsFrame.TabRaidSize10:LockHighlight()
			elseif currentSize == 15 then
				GVAR.OptionsFrame.TabRaidSize15:LockHighlight()
			end
			if fraction == "Enemy" then
				GVAR.OptionsFrame.EnableFriendBracket:LockHighlight()
			else
				GVAR.OptionsFrame.EnableEnemyBracket:LockHighlight()
			end
		else--if what == "diffSize" then
			if currentSize == 10 then
				GVAR.OptionsFrame.TabRaidSize15:LockHighlight()
			elseif currentSize == 15 then
				GVAR.OptionsFrame.TabRaidSize10:LockHighlight()
			end
			if fraction == "Enemy" then
				GVAR.OptionsFrame.EnableEnemyBracket:LockHighlight()
			else
				GVAR.OptionsFrame.EnableFriendBracket:LockHighlight()
			end
		end
	end
	local function HighlightOnLeave()
		GVAR.OptionsFrame.TabRaidSize15:UnlockHighlight()
		GVAR.OptionsFrame.TabRaidSize10:UnlockHighlight()
		GVAR.OptionsFrame.EnableFriendBracket:UnlockHighlight()
		GVAR.OptionsFrame.EnableEnemyBracket:UnlockHighlight()
		----------
		GVAR.OptionsFrame.LayoutTHText.Background:SetColorTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.LayoutTHx18.Highlight:Hide()
		GVAR.OptionsFrame.LayoutTHx24.Highlight:Hide()
		GVAR.OptionsFrame.LayoutTHx42.Highlight:Hide()
		GVAR.OptionsFrame.LayoutTHx81.Highlight:Hide()
		GVAR.OptionsFrame.LayoutSpace.Background:SetColorTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.SummaryText.Background:SetColorTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.SummaryToggle.Highlight:Hide()
		GVAR.OptionsFrame.SummaryScale.Background:SetColorTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.SummaryPosition.Background:SetColorTexture(0, 0, 0, 0)
		----------
		GVAR.OptionsFrame.ShowRole.Highlight:Hide()
		GVAR.OptionsFrame.ShowSpec.Highlight:Hide()
		GVAR.OptionsFrame.ClassIcon.Highlight:Hide()
		GVAR.OptionsFrame.ShowLeader.Highlight:Hide()
		GVAR.OptionsFrame.ShowRealm.Highlight:Hide()
		GVAR.OptionsFrame.ShowPVPTrinket.Highlight:Hide()
		GVAR.OptionsFrame.ShowFTargetCount.Highlight:Hide()
		GVAR.OptionsFrame.ShowETargetCount.Highlight:Hide()
		----------
		GVAR.OptionsFrame.ShowTargetIndicator.Highlight:Hide()
		GVAR.OptionsFrame.TargetScaleSlider.Background:SetColorTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.TargetPositionSlider.Background:SetColorTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.TargetofTarget.Highlight:Hide()
		GVAR.OptionsFrame.ToTScaleSlider.Background:SetColorTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.ToTPositionSlider.Background:SetColorTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.ShowFocusIndicator.Highlight:Hide()
		GVAR.OptionsFrame.FocusScaleSlider.Background:SetColorTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.FocusPositionSlider.Background:SetColorTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.ShowFlag.Highlight:Hide()
		GVAR.OptionsFrame.FlagScaleSlider.Background:SetColorTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.FlagPositionSlider.Background:SetColorTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.ShowAssist.Highlight:Hide()
		GVAR.OptionsFrame.AssistScaleSlider.Background:SetColorTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.AssistPositionSlider.Background:SetColorTexture(0, 0, 0, 0)
		----------
		GVAR.OptionsFrame.ShowHealthBar.Highlight:Hide()
		GVAR.OptionsFrame.ShowHealthText.Highlight:Hide()
		GVAR.OptionsFrame.RangeCheck.Highlight:Hide()
		GVAR.OptionsFrame.RangeDisplayPullDown:UnlockHighlight()
		GVAR.OptionsFrame.SortByTitle.Background:SetColorTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.SortByPullDown:UnlockHighlight()
		GVAR.OptionsFrame.SortDetailPullDown:UnlockHighlight()
		----------
		GVAR.OptionsFrame.FontNameTitle.Background:SetColorTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.FontNamePullDown:UnlockHighlight()
		GVAR.OptionsFrame.FontNameSlider.Background:SetColorTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.FontNumberTitle.Background:SetColorTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.FontNumberPullDown:UnlockHighlight()
		GVAR.OptionsFrame.FontNumberSlider.Background:SetColorTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.ScaleTitle.Background:SetColorTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.ScaleSlider.Background:SetColorTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.WidthTitle.Background:SetColorTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.WidthSlider.Background:SetColorTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.HeightTitle.Background:SetColorTexture(0, 0, 0, 0)
		GVAR.OptionsFrame.HeightSlider.Background:SetColorTexture(0, 0, 0, 0)
	end

	local function ConfigFontNumberOptionCheck(size)
		if BattlegroundTargets_Options[fraction].SummaryToggle[size] or
		   BattlegroundTargets_Options[fraction].ButtonFlagToggle[size] or
		   BattlegroundTargets_Options[fraction].ButtonHealthTextToggle[size] or
		   BattlegroundTargets_Options[fraction].ButtonFTargetCountToggle[size] or
		   BattlegroundTargets_Options[fraction].ButtonETargetCountToggle[size] or
		   BattlegroundTargets_Options[fraction].ButtonPvPTrinketToggle[size]
		then
			TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.FontNumberPullDown)
			GVAR.OptionsFrame.FontNumberTitle:SetTextColor(1, 1, 1, 1)
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.FontNumberSlider)
		else
			TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.FontNumberPullDown)
			GVAR.OptionsFrame.FontNumberTitle:SetTextColor(0.5, 0.5, 0.5, 1)
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.FontNumberSlider)
		end
	end
	-- ###
	-- ####################################################################################################



	-- ####################################################################################################
	-- xMx OptionsFrame
	GVAR.OptionsFrame = CreateFrame("Frame", "BattlegroundTargets_OptionsFrame", UIParent)
	TEMPLATE.BorderTRBL(GVAR.OptionsFrame)
	GVAR.OptionsFrame:EnableMouse(true)
	GVAR.OptionsFrame:SetMovable(true)
	GVAR.OptionsFrame:SetToplevel(true)
	GVAR.OptionsFrame:SetClampedToScreen(false) -- TODO bug? (true) -- CLAMP_FIX_OPTIONS
	-- BOOM GVAR.OptionsFrame:SetClampRectInsets()
	-- BOOM GVAR.OptionsFrame:SetWidth()
	GVAR.OptionsFrame:SetHeight(heightTotal)
	GVAR.OptionsFrame:Hide()
	GVAR.OptionsFrame:SetScript("OnShow", function() BattlegroundTargets:OptionsFrameShow() end)
	GVAR.OptionsFrame:SetScript("OnHide", function() BattlegroundTargets:OptionsFrameHide() end)
	GVAR.OptionsFrame:SetScript("OnMouseWheel", NOOP)

	-- CLAMP_FIX_OPTIONS BEGIN
	GVAR.OptionsFrame.ClampDummy1 = GVAR.OptionsFrame:CreateTexture(nil, "BACKGROUND") -- horizontal top
	-- BOOM GVAR.OptionsFrame.ClampDummy1:SetSize(w, 1)
	GVAR.OptionsFrame.ClampDummy1:SetPoint("TOP", GVAR.OptionsFrame, "TOP", 0, -40)
	GVAR.OptionsFrame.ClampDummy1:SetColorTexture(0, 0.5, 2, 0.5)
	GVAR.OptionsFrame.ClampDummy1:Hide()
	GVAR.OptionsFrame.ClampDummy2 = GVAR.OptionsFrame:CreateTexture(nil, "BACKGROUND") -- horizontal bottom
	-- BOOM GVAR.OptionsFrame.ClampDummy2:SetSize(w, 1)
	GVAR.OptionsFrame.ClampDummy2:SetPoint("BOTTOM", GVAR.OptionsFrame, "BOTTOM", 0, 40)
	GVAR.OptionsFrame.ClampDummy2:SetColorTexture(0, 0.5, 2, 0.5)
	GVAR.OptionsFrame.ClampDummy2:Hide()
	GVAR.OptionsFrame.ClampDummy3 = GVAR.OptionsFrame:CreateTexture(nil, "BACKGROUND") -- vertical left
	-- BOOM GVAR.OptionsFrame.ClampDummy3:SetSize(1, h)
	GVAR.OptionsFrame.ClampDummy3:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 40, 0)
	GVAR.OptionsFrame.ClampDummy3:SetColorTexture(0, 0.5, 2, 0.5)
	GVAR.OptionsFrame.ClampDummy3:Hide()
	GVAR.OptionsFrame.ClampDummy4 = GVAR.OptionsFrame:CreateTexture(nil, "BACKGROUND") -- horizontal right
	-- BOOM GVAR.OptionsFrame.ClampDummy4:SetSize(1, h)
	GVAR.OptionsFrame.ClampDummy4:SetPoint("RIGHT", GVAR.OptionsFrame, "RIGHT", -40, 0)
	GVAR.OptionsFrame.ClampDummy4:SetColorTexture(0, 0.5, 2, 0.5)
	GVAR.OptionsFrame.ClampDummy4:Hide()
	-- CLAMP_FIX_OPTIONS END

	-- close
	GVAR.OptionsFrame.CloseConfig = CreateFrame("Button", nil, GVAR.OptionsFrame)
	TEMPLATE.TextButton(GVAR.OptionsFrame.CloseConfig, L["Close Configuration"], 1)
	GVAR.OptionsFrame.CloseConfig:SetPoint("BOTTOM", GVAR.OptionsFrame, "BOTTOM", 0, 10)
	GVAR.OptionsFrame.CloseConfig:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	-- BOOM GVAR.OptionsFrame.CloseConfig:SetWidth()
	GVAR.OptionsFrame.CloseConfig:SetHeight(30)
	GVAR.OptionsFrame.CloseConfig:SetScript("OnClick", function() GVAR.OptionsFrame:Hide() end)
	-- ###
	-- ####################################################################################################



	-- ####################################################################################################
	-- xMx Base
	GVAR.OptionsFrame.Base = CreateFrame("Frame", nil, GVAR.OptionsFrame)
	TEMPLATE.BorderTRBL(GVAR.OptionsFrame.Base)
	-- BOOM GVAR.OptionsFrame.Base:SetWidth()
	GVAR.OptionsFrame.Base:SetHeight(heightBase)
	GVAR.OptionsFrame.Base:SetPoint("TOPLEFT", GVAR.OptionsFrame, "TOPLEFT", 0, 0)
	GVAR.OptionsFrame.Base:EnableMouse(true)

	GVAR.OptionsFrame.Title = GVAR.OptionsFrame.Base:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	-- BOOM GVAR.OptionsFrame.Title:SetWidth()
	GVAR.OptionsFrame.Title:SetHeight(16)
	GVAR.OptionsFrame.Title:SetPoint("TOPLEFT", GVAR.OptionsFrame.Base, "TOPLEFT", 0, -10)
	GVAR.OptionsFrame.Title:SetJustifyH("CENTER")
	GVAR.OptionsFrame.Title:SetText("BattlegroundTargets")

	-- tabs
	GVAR.OptionsFrame.TabGeneral = CreateFrame("Button", nil, GVAR.OptionsFrame.Base)
	TEMPLATE.TabButton(GVAR.OptionsFrame.TabGeneral, L["Options"], nil, "monotext")
	-- BOOM GVAR.OptionsFrame.TabGeneral:SetWidth()
	GVAR.OptionsFrame.TabGeneral:SetHeight(22)
	-- BOOM GVAR.OptionsFrame.TabGeneral:SetPoint()
	GVAR.OptionsFrame.TabGeneral:SetScript("OnClick", function()
		if GVAR.OptionsFrame.ConfigGeneral:IsShown() then
			TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabGeneral, nil)
			GVAR.OptionsFrame.ConfigGeneral:Hide()
			GVAR.OptionsFrame.ConfigBrackets:Show()
			GVAR.OptionsFrame["TabRaidSize"..testSize].TextureBottom:SetColorTexture(0, 0, 0, 1)
		else
			TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabGeneral, true)
			GVAR.OptionsFrame.ConfigGeneral:Show()
			GVAR.OptionsFrame.ConfigBrackets:Hide()
			GVAR.OptionsFrame["TabRaidSize"..testSize].TextureBottom:SetColorTexture(0.8, 0.2, 0.2, 1)
		end
	end)

	GVAR.OptionsFrame.TabRaidSize10 = CreateFrame("Button", nil, GVAR.OptionsFrame.Base)
	TEMPLATE.TabButton(GVAR.OptionsFrame.TabRaidSize10, L["10v10"], BattlegroundTargets_Options.Friend.EnableBracket[10] or BattlegroundTargets_Options.Enemy.EnableBracket[10])
	-- BOOM GVAR.OptionsFrame.TabRaidSize10:SetWidth()
	GVAR.OptionsFrame.TabRaidSize10:SetHeight(22)
	-- BOOM GVAR.OptionsFrame.TabRaidSize10:SetPoint()
	GVAR.OptionsFrame.TabRaidSize10:SetPoint("LEFT", GVAR.OptionsFrame.TabGeneral, "RIGHT", 10, 0)
	GVAR.OptionsFrame.TabRaidSize10:SetScript("OnClick", function()
		BattlegroundTargets:ClickOnBracketTab(10, fraction)
	end)

	-- copy settings1
	GVAR.OptionsFrame.CopySettings1 = CreateFrame("Button", nil, GVAR.OptionsFrame.Base)
	TEMPLATE.IconButton(GVAR.OptionsFrame.CopySettings1, 1)
	GVAR.OptionsFrame.CopySettings1:SetPoint("LEFT", GVAR.OptionsFrame.TabRaidSize10, "RIGHT", 10, 5)
	GVAR.OptionsFrame.CopySettings1:SetHeight(20.4) -- 17 * 1.2 -- COPY_HW
	GVAR.OptionsFrame.CopySettings1:SetWidth(30) -- 25 * 1.2
	GVAR.OptionsFrame.CopySettings1:SetScript("OnClick", function() BattlegroundTargets:CopyAllSettings(currentSize) end)
	GVAR.OptionsFrame.CopySettings1:SetScript("OnEnter", function() HighlightOnEnter("diffSize") end)
	GVAR.OptionsFrame.CopySettings1:SetScript("OnLeave", HighlightOnLeave)

	GVAR.OptionsFrame.TabRaidSize15 = CreateFrame("Button", nil, GVAR.OptionsFrame.Base)
	TEMPLATE.TabButton(GVAR.OptionsFrame.TabRaidSize15, L["15v15"], BattlegroundTargets_Options.Friend.EnableBracket[15] or BattlegroundTargets_Options.Enemy.EnableBracket[15])
	-- BOOM GVAR.OptionsFrame.TabRaidSize15:SetWidth()
	GVAR.OptionsFrame.TabRaidSize15:SetHeight(22)
	-- BOOM GVAR.OptionsFrame.TabRaidSize15:SetPoint()
	GVAR.OptionsFrame.TabRaidSize15:SetPoint("LEFT", GVAR.OptionsFrame.CopySettings1, "RIGHT", 10, -5)
	GVAR.OptionsFrame.TabRaidSize15:SetScript("OnClick", function()
		BattlegroundTargets:ClickOnBracketTab(15, fraction)
	end)

	GVAR.OptionsFrame.TabRaidSize40 = CreateFrame("Button", nil, GVAR.OptionsFrame.Base)
	TEMPLATE.TabButton(GVAR.OptionsFrame.TabRaidSize40, L["40v40"], BattlegroundTargets_Options.Friend.EnableBracket[40] or BattlegroundTargets_Options.Enemy.EnableBracket[40])
	-- BOOM GVAR.OptionsFrame.TabRaidSize40:SetWidth()
	GVAR.OptionsFrame.TabRaidSize40:SetHeight(22)
	-- BOOM GVAR.OptionsFrame.TabRaidSize40:SetPoint()
	GVAR.OptionsFrame.TabRaidSize40:SetPoint("LEFT", GVAR.OptionsFrame.TabRaidSize15, "RIGHT", 10, 0)
	GVAR.OptionsFrame.TabRaidSize40:SetScript("OnClick", function()
		BattlegroundTargets:ClickOnBracketTab(40, fraction)
	end)

	if testSize == 10 then
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabGeneral, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize10, true)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize15, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize40, nil)
	elseif testSize == 15 then
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabGeneral, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize10, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize15, true)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize40, nil)
	elseif testSize == 40 then
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabGeneral, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize10, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize15, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize40, true)
	end
	-- ###
	-- ####################################################################################################



	-- ####################################################################################################
	-- xMx ConfigBrackets
	GVAR.OptionsFrame.ConfigBrackets = CreateFrame("Frame", nil, GVAR.OptionsFrame)
	-- BOOM GVAR.OptionsFrame.ConfigBrackets:SetWidth()
	GVAR.OptionsFrame.ConfigBrackets:SetHeight(heightBracket)
	GVAR.OptionsFrame.ConfigBrackets:SetPoint("TOPLEFT", GVAR.OptionsFrame.Base, "BOTTOMLEFT", 0, -1)
	GVAR.OptionsFrame.ConfigBrackets:Hide()

	-- EnableBracket
	GVAR.OptionsFrame.EnableFriendBracket = CreateFrame("Button", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.TabButton(
		GVAR.OptionsFrame.EnableFriendBracket,
		Textures.FriendIconStr.." "..L["Friendly Players"],--L["Friend"],--
		BattlegroundTargets_Options.Friend.EnableBracket[currentSize])
	-- BOOM GVAR.OptionsFrame.EnableFriendBracket:SetWidth()
	GVAR.OptionsFrame.EnableFriendBracket:SetHeight(22)
	-- BOOM GVAR.OptionsFrame.EnableFriendBracket:SetPoint()
	GVAR.OptionsFrame.EnableFriendBracket:SetScript("OnClick", function()
		BattlegroundTargets:ClickOnFractionTab("Friend")
	end)

	-- copy settings2
	GVAR.OptionsFrame.CopySettings2 = CreateFrame("Button", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.IconButton(GVAR.OptionsFrame.CopySettings2, 2)
	GVAR.OptionsFrame.CopySettings2:SetPoint("LEFT", GVAR.OptionsFrame.EnableFriendBracket, "RIGHT", 10, 5)
	GVAR.OptionsFrame.CopySettings2:SetHeight(20.4) -- 17 * 1.2 -- COPY_HW
	GVAR.OptionsFrame.CopySettings2:SetWidth(30) -- 25 * 1.2
	GVAR.OptionsFrame.CopySettings2:SetScript("OnClick", function() BattlegroundTargets:CopyAllSettings(currentSize, "sameSize") end)
	GVAR.OptionsFrame.CopySettings2:SetScript("OnEnter", function() HighlightOnEnter("sameSize") end)
	GVAR.OptionsFrame.CopySettings2:SetScript("OnLeave", HighlightOnLeave)

	GVAR.OptionsFrame.EnableEnemyBracket = CreateFrame("Button", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.TabButton(
		GVAR.OptionsFrame.EnableEnemyBracket,
		Textures.EnemyIconStr.." "..L["Enemy Players"],--L["Enemy"],--
		BattlegroundTargets_Options.Enemy.EnableBracket[currentSize])
	-- BOOM GVAR.OptionsFrame.EnableEnemyBracket:SetWidth()
	GVAR.OptionsFrame.EnableEnemyBracket:SetHeight(22)
	GVAR.OptionsFrame.EnableEnemyBracket:SetPoint("LEFT", GVAR.OptionsFrame.CopySettings2, "RIGHT", 10, -5)
	GVAR.OptionsFrame.EnableEnemyBracket:SetScript("OnClick", function()
		BattlegroundTargets:ClickOnFractionTab("Enemy")
	end)

	if fraction == "Friend" then
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.EnableFriendBracket, true)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.EnableEnemyBracket, nil)
	else
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.EnableFriendBracket, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.EnableEnemyBracket, true)
	end



	-- DUMMY
	GVAR.OptionsFrame.Dummy0 = GVAR.OptionsFrame.ConfigBrackets:CreateTexture(nil, "ARTWORK")
	-- BOOM GVAR.OptionsFrame.Dummy0:SetWidth()
	GVAR.OptionsFrame.Dummy0:SetHeight(1)
	GVAR.OptionsFrame.Dummy0:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 0, 0)
	GVAR.OptionsFrame.Dummy0:SetPoint("TOP", GVAR.OptionsFrame.EnableFriendBracket, "BOTTOM", 0, 2)
	GVAR.OptionsFrame.Dummy0:SetColorTexture(0.8, 0.2, 0.2, 1)



	-- enable fraction
	GVAR.OptionsFrame.EnableFraction = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.EnableFraction, 16, 4, L["Enable"])
	GVAR.OptionsFrame.EnableFraction:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.EnableFraction:SetPoint("TOP", GVAR.OptionsFrame.Dummy0, "BOTTOM", 0, -8)
	GVAR.OptionsFrame.EnableFraction:SetChecked(BattlegroundTargets_Options[fraction].EnableBracket[currentSize])
	GVAR.OptionsFrame.EnableFraction:SetScript("OnClick", function()
		BattlegroundTargets_Options[fraction].EnableBracket[currentSize] = not BattlegroundTargets_Options[fraction].EnableBracket[currentSize]
		GVAR.OptionsFrame.EnableFraction:SetChecked(BattlegroundTargets_Options[fraction].EnableBracket[currentSize])
		BattlegroundTargets:CheckForEnabledBracket(currentSize, fraction)
		if BattlegroundTargets_Options.Friend.EnableBracket[currentSize] or BattlegroundTargets_Options.Enemy.EnableBracket[currentSize] then
			BattlegroundTargets:EnableConfigMode()
		else
			BattlegroundTargets:DisableConfigMode()
		end
	end)



	-- DUMMY
	GVAR.OptionsFrame.Dummy1 = GVAR.OptionsFrame.ConfigBrackets:CreateTexture(nil, "ARTWORK")
	-- BOOM GVAR.OptionsFrame.Dummy1:SetWidth()
	GVAR.OptionsFrame.Dummy1:SetHeight(1)
	GVAR.OptionsFrame.Dummy1:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.Dummy1:SetPoint("TOP", GVAR.OptionsFrame.EnableFraction, "BOTTOM", 0, -8)
	GVAR.OptionsFrame.Dummy1:SetColorTexture(0.8, 0.2, 0.2, 1)



	-- scale
	GVAR.OptionsFrame.ScaleTitle = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.ScaleSlider = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.ScaleValue = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.ScaleTitle:SetHeight(16)
	GVAR.OptionsFrame.ScaleTitle:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.ScaleTitle:SetPoint("TOP", GVAR.OptionsFrame.Dummy1, "BOTTOM", 0, -8)
	GVAR.OptionsFrame.ScaleTitle:SetJustifyH("LEFT")
	GVAR.OptionsFrame.ScaleTitle:SetText(L["Scale"]..":")
	GVAR.OptionsFrame.ScaleTitle:SetTextColor(1, 1, 1, 1)
	GVAR.OptionsFrame.ScaleTitle.Background = GVAR.OptionsFrame.ConfigBrackets:CreateTexture(nil, "BACKGROUND")
	GVAR.OptionsFrame.ScaleTitle.Background:SetPoint("TOPLEFT", GVAR.OptionsFrame.ScaleTitle, "TOPLEFT", 0, 0)
	GVAR.OptionsFrame.ScaleTitle.Background:SetPoint("BOTTOMRIGHT", GVAR.OptionsFrame.ScaleTitle, "BOTTOMRIGHT", 0, 0)
	GVAR.OptionsFrame.ScaleTitle.Background:SetColorTexture(0, 0, 0, 0)
	TEMPLATE.Slider(GVAR.OptionsFrame.ScaleSlider, 180, 5, 50, 250, BattlegroundTargets_Options[fraction].ButtonScale[currentSize]*100,
	function(self, value)
		local nvalue = value/100
		if nvalue == BattlegroundTargets_Options[fraction].ButtonScale[currentSize] then return end
		BattlegroundTargets_Options[fraction].ButtonScale[currentSize] = nvalue
		GVAR.OptionsFrame.ScaleValue:SetText(value.."%")
		BattlegroundTargets:EnableConfigMode()
	end,
	"blank")
	GVAR.OptionsFrame.ScaleSlider:SetPoint("LEFT", GVAR.OptionsFrame.ScaleTitle, "RIGHT", 20, 0)
	GVAR.OptionsFrame.ScaleValue:SetHeight(20)
	GVAR.OptionsFrame.ScaleValue:SetPoint("LEFT", GVAR.OptionsFrame.ScaleSlider, "RIGHT", 5, 0)
	GVAR.OptionsFrame.ScaleValue:SetJustifyH("LEFT")
	GVAR.OptionsFrame.ScaleValue:SetText((BattlegroundTargets_Options[fraction].ButtonScale[currentSize]*100).."%")
	GVAR.OptionsFrame.ScaleValue:SetTextColor(1, 1, 0.49, 1)

	-- width
	GVAR.OptionsFrame.WidthTitle = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.WidthSlider = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.WidthValue = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.WidthTitle:SetHeight(16)
	GVAR.OptionsFrame.WidthTitle:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.WidthTitle:SetPoint("TOP", GVAR.OptionsFrame.ScaleSlider, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.WidthTitle:SetJustifyH("LEFT")
	GVAR.OptionsFrame.WidthTitle:SetText(L["Width"]..":")
	GVAR.OptionsFrame.WidthTitle:SetTextColor(1, 1, 1, 1)
	GVAR.OptionsFrame.WidthTitle.Background = GVAR.OptionsFrame.ConfigBrackets:CreateTexture(nil, "BACKGROUND")
	GVAR.OptionsFrame.WidthTitle.Background:SetPoint("TOPLEFT", GVAR.OptionsFrame.WidthTitle, "TOPLEFT", 0, 0)
	GVAR.OptionsFrame.WidthTitle.Background:SetPoint("BOTTOMRIGHT", GVAR.OptionsFrame.WidthTitle, "BOTTOMRIGHT", 0, 0)
	GVAR.OptionsFrame.WidthTitle.Background:SetColorTexture(0, 0, 0, 0)
	TEMPLATE.Slider(GVAR.OptionsFrame.WidthSlider, 180, 5, 50, 300, BattlegroundTargets_Options[fraction].ButtonWidth[currentSize],
	function(self, value)
		if value == BattlegroundTargets_Options[fraction].ButtonWidth[currentSize] then return end
		BattlegroundTargets_Options[fraction].ButtonWidth[currentSize] = value
		GVAR.OptionsFrame.WidthValue:SetText(value)
		BattlegroundTargets:EnableConfigMode()
	end,
	"blank")
	GVAR.OptionsFrame.WidthSlider:SetPoint("LEFT", GVAR.OptionsFrame.WidthTitle, "RIGHT", 20, 0)
	GVAR.OptionsFrame.WidthValue:SetHeight(20)
	GVAR.OptionsFrame.WidthValue:SetPoint("LEFT", GVAR.OptionsFrame.WidthSlider, "RIGHT", 5, 0)
	GVAR.OptionsFrame.WidthValue:SetJustifyH("LEFT")
	GVAR.OptionsFrame.WidthValue:SetText(BattlegroundTargets_Options[fraction].ButtonWidth[currentSize])
	GVAR.OptionsFrame.WidthValue:SetTextColor(1, 1, 0.49, 1)

	-- height
	GVAR.OptionsFrame.HeightTitle = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.HeightSlider = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.HeightValue = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.HeightTitle:SetHeight(16)
	GVAR.OptionsFrame.HeightTitle:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.HeightTitle:SetPoint("TOP", GVAR.OptionsFrame.WidthTitle, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.HeightTitle:SetJustifyH("LEFT")
	GVAR.OptionsFrame.HeightTitle:SetText(L["Height"]..":")
	GVAR.OptionsFrame.HeightTitle:SetTextColor(1, 1, 1, 1)
	GVAR.OptionsFrame.HeightTitle.Background = GVAR.OptionsFrame.ConfigBrackets:CreateTexture(nil, "BACKGROUND")
	GVAR.OptionsFrame.HeightTitle.Background:SetPoint("TOPLEFT", GVAR.OptionsFrame.HeightTitle, "TOPLEFT", 0, 0)
	GVAR.OptionsFrame.HeightTitle.Background:SetPoint("BOTTOMRIGHT", GVAR.OptionsFrame.HeightTitle, "BOTTOMRIGHT", 0, 0)
	GVAR.OptionsFrame.HeightTitle.Background:SetColorTexture(0, 0, 0, 0)
	TEMPLATE.Slider(GVAR.OptionsFrame.HeightSlider, 180, 1, 10, 50, BattlegroundTargets_Options[fraction].ButtonHeight[currentSize],
	function(self, value)
		if value == BattlegroundTargets_Options[fraction].ButtonHeight[currentSize] then return end
		BattlegroundTargets_Options[fraction].ButtonHeight[currentSize] = value
		GVAR.OptionsFrame.HeightValue:SetText(value)
		BattlegroundTargets:EnableConfigMode()
	end,
	"blank")
	GVAR.OptionsFrame.HeightSlider:SetPoint("LEFT", GVAR.OptionsFrame.HeightTitle, "RIGHT", 20, 0)
	GVAR.OptionsFrame.HeightValue:SetHeight(20)
	GVAR.OptionsFrame.HeightValue:SetPoint("LEFT", GVAR.OptionsFrame.HeightSlider, "RIGHT", 5, 0)
	GVAR.OptionsFrame.HeightValue:SetJustifyH("LEFT")
	GVAR.OptionsFrame.HeightValue:SetText(BattlegroundTargets_Options[fraction].ButtonHeight[currentSize])
	GVAR.OptionsFrame.HeightValue:SetTextColor(1, 1, 0.49, 1)

	local equalTextWidthSliders, sw = 0, 0
	sw = GVAR.OptionsFrame.ScaleTitle:GetStringWidth() if sw > equalTextWidthSliders then equalTextWidthSliders = sw end
	sw = GVAR.OptionsFrame.WidthTitle:GetStringWidth() if sw > equalTextWidthSliders then equalTextWidthSliders = sw end
	sw = GVAR.OptionsFrame.HeightTitle:GetStringWidth() if sw > equalTextWidthSliders then equalTextWidthSliders = sw end
	GVAR.OptionsFrame.ScaleSlider:SetPoint("LEFT", GVAR.OptionsFrame.ScaleTitle, "LEFT", equalTextWidthSliders+10, 0)
	GVAR.OptionsFrame.WidthSlider:SetPoint("LEFT", GVAR.OptionsFrame.WidthTitle, "LEFT", equalTextWidthSliders+10, 0)
	GVAR.OptionsFrame.HeightSlider:SetPoint("LEFT", GVAR.OptionsFrame.HeightTitle, "LEFT", equalTextWidthSliders+10, 0)



	-- DUMMY
	GVAR.OptionsFrame.Dummy2 = GVAR.OptionsFrame.ConfigBrackets:CreateTexture(nil, "ARTWORK")
	-- BOOM GVAR.OptionsFrame.Dummy2:SetWidth()
	GVAR.OptionsFrame.Dummy2:SetHeight(1)
	GVAR.OptionsFrame.Dummy2:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.Dummy2:SetPoint("TOP", GVAR.OptionsFrame.HeightTitle, "BOTTOM", 0, -8)
	GVAR.OptionsFrame.Dummy2:SetColorTexture(0.73, 0.26, 0.21, 0.5)



	-- sort by
	local sortW = 0
	GVAR.OptionsFrame.SortByTitle = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.SortByTitle:SetHeight(16)
	GVAR.OptionsFrame.SortByTitle:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.SortByTitle:SetPoint("TOP", GVAR.OptionsFrame.Dummy2, "BOTTOM", 0, -8)
	GVAR.OptionsFrame.SortByTitle:SetJustifyH("LEFT")
	GVAR.OptionsFrame.SortByTitle:SetText(L["Sort By"]..":")
	GVAR.OptionsFrame.SortByTitle:SetTextColor(1, 1, 1, 1)
	GVAR.OptionsFrame.SortByTitle.Background = GVAR.OptionsFrame.ConfigBrackets:CreateTexture(nil, "BACKGROUND")
	GVAR.OptionsFrame.SortByTitle.Background:SetPoint("TOPLEFT", GVAR.OptionsFrame.SortByTitle, "TOPLEFT", 0, 0)
	GVAR.OptionsFrame.SortByTitle.Background:SetPoint("BOTTOMRIGHT", GVAR.OptionsFrame.SortByTitle, "BOTTOMRIGHT", 0, 0)
	GVAR.OptionsFrame.SortByTitle.Background:SetColorTexture(0, 0, 0, 0)
	sortW = sortW + 10 + GVAR.OptionsFrame.SortByTitle:GetStringWidth()

	GVAR.OptionsFrame.SortByPullDown = CreateFrame("Button", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.PullDownMenu(
		GVAR.OptionsFrame.SortByPullDown,
		sortBy,
		sortBy[ BattlegroundTargets_Options[fraction].ButtonSortBy[currentSize] ],
		0,
		function(value) -- PDFUNC
			BattlegroundTargets_Options[fraction].ButtonSortBy[currentSize] = value
			BattlegroundTargets:EnableConfigMode()
		end,
		function(self, button) -- TODO check - potential bug port
			GVAR.OptionsFrame.SortByPullDown.spookval = BattlegroundTargets_Options[fraction].ButtonSortBy[currentSize]
			BattlegroundTargets_Options[fraction].ButtonSortBy[currentSize] = self.value1
			BattlegroundTargets:EnableConfigMode()
		end,
		function(self, button) -- TODO check - potential bug port
			BattlegroundTargets_Options[fraction].ButtonSortBy[currentSize] = GVAR.OptionsFrame.SortByPullDown.spookval or self.value1
			BattlegroundTargets:EnableConfigMode()
		end
	)
	GVAR.OptionsFrame.SortByPullDown:SetPoint("LEFT", GVAR.OptionsFrame.SortByTitle, "RIGHT", 10, 0)
	GVAR.OptionsFrame.SortByPullDown:SetHeight(18)
	TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.SortByPullDown)
	sortW = sortW + 10 + GVAR.OptionsFrame.SortByPullDown:GetWidth()

	-- sort detail
	GVAR.OptionsFrame.SortDetailPullDown = CreateFrame("Button", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.PullDownMenu(
		GVAR.OptionsFrame.SortDetailPullDown,
		sortDetail,
		sortBy[ BattlegroundTargets_Options[fraction].ButtonSortDetail[currentSize] ],
		0,
		function(value) -- PDFUNC
			BattlegroundTargets_Options[fraction].ButtonSortDetail[currentSize] = value
			BattlegroundTargets:EnableConfigMode()
		end,
		function(self, button) -- TODO check - potential bug port
			GVAR.OptionsFrame.SortDetailPullDown.spookval = BattlegroundTargets_Options[fraction].ButtonSortDetail[currentSize]
			BattlegroundTargets_Options[fraction].ButtonSortDetail[currentSize] = self.value1
			BattlegroundTargets:EnableConfigMode()
		end,
		function(self, button) -- TODO check - potential bug port
			BattlegroundTargets_Options[fraction].ButtonSortDetail[currentSize] = GVAR.OptionsFrame.SortDetailPullDown.spookval or self.value1
			BattlegroundTargets:EnableConfigMode()
		end
	)
	GVAR.OptionsFrame.SortDetailPullDown:SetPoint("LEFT", GVAR.OptionsFrame.SortByPullDown, "RIGHT", 10, 0)
	GVAR.OptionsFrame.SortDetailPullDown:SetHeight(18)
	TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.SortDetailPullDown)
	sortW = sortW + 10 + GVAR.OptionsFrame.SortDetailPullDown:GetWidth()

	-- sort info
		----- text
		local infoTxt1 = sortDetail[1]..":\n"
		table_sort(class_IntegerSort, function(a, b) return a.loc < b.loc end)
		for i = 1, #class_IntegerSort do
			infoTxt1 = infoTxt1.." |cff"..classcolors[class_IntegerSort[i].cid].colorStr..class_IntegerSort[i].loc.."|r"
			if i <= #class_IntegerSort then
				infoTxt1 = infoTxt1.."\n"
			end
		end
		local infoTxt2 = sortDetail[2]..":\n"
		table_sort(class_IntegerSort, function(a, b) return a.eng < b.eng end)
		for i = 1, #class_IntegerSort do
			infoTxt2 = infoTxt2.." |cff"..classcolors[class_IntegerSort[i].cid].colorStr..class_IntegerSort[i].eng.." ("..class_IntegerSort[i].loc..")|r"
			if i <= #class_IntegerSort then
				infoTxt2 = infoTxt2.."\n"
			end
		end
		local infoTxt3 = sortDetail[3]..":\n"
		table_sort(class_IntegerSort, function(a, b) return a.blizz < b.blizz end)
		for i = 1, #class_IntegerSort do
			infoTxt3 = infoTxt3.." |cff"..classcolors[class_IntegerSort[i].cid].colorStr..class_IntegerSort[i].loc.."|r"
			if i <= #class_IntegerSort then
				infoTxt3 = infoTxt3.."\n"
			end
		end
		----- text
	GVAR.OptionsFrame.SortInfo = CreateFrame("Button", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.SortInfo:SetWidth(16)
	GVAR.OptionsFrame.SortInfo:SetHeight(16)
	GVAR.OptionsFrame.SortInfo:SetPoint("LEFT", GVAR.OptionsFrame.SortDetailPullDown, "RIGHT", 10, 0)
	GVAR.OptionsFrame.SortInfo.Texture = GVAR.OptionsFrame.SortInfo:CreateTexture(nil, "ARTWORK")
	GVAR.OptionsFrame.SortInfo.Texture:SetWidth(16)
	GVAR.OptionsFrame.SortInfo.Texture:SetHeight(16)
	GVAR.OptionsFrame.SortInfo.Texture:SetPoint("LEFT", 0, 0)
	GVAR.OptionsFrame.SortInfo.Texture:SetTexture("Interface\\FriendsFrame\\InformationIcon")
	GVAR.OptionsFrame.SortInfo.TextFrame = CreateFrame("Frame", nil, GVAR.OptionsFrame.SortInfo)
	TEMPLATE.BorderTRBL(GVAR.OptionsFrame.SortInfo.TextFrame)
	GVAR.OptionsFrame.SortInfo.TextFrame:SetToplevel(true)
	GVAR.OptionsFrame.SortInfo.TextFrame:SetPoint("BOTTOM", GVAR.OptionsFrame.SortInfo.Texture, "TOP", 0, 0)
	GVAR.OptionsFrame.SortInfo.TextFrame:Hide()
	GVAR.OptionsFrame.SortInfo.Text1 = GVAR.OptionsFrame.SortInfo.TextFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.SortInfo.Text1:SetPoint("TOPLEFT", GVAR.OptionsFrame.SortInfo.TextFrame, "TOPLEFT", 10, -10)
	GVAR.OptionsFrame.SortInfo.Text1:SetJustifyH("LEFT")
	GVAR.OptionsFrame.SortInfo.Text1:SetText(infoTxt1)
	GVAR.OptionsFrame.SortInfo.Text1:SetTextColor(1, 1, 0.49, 1)
	GVAR.OptionsFrame.SortInfo.Text2 = GVAR.OptionsFrame.SortInfo.TextFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.SortInfo.Text2:SetPoint("LEFT", GVAR.OptionsFrame.SortInfo.Text1, "RIGHT", 0, 0)
	GVAR.OptionsFrame.SortInfo.Text2:SetJustifyH("LEFT")
	GVAR.OptionsFrame.SortInfo.Text2:SetText(infoTxt2)
	GVAR.OptionsFrame.SortInfo.Text2:SetTextColor(1, 1, 0.49, 1)
	GVAR.OptionsFrame.SortInfo.Text3 = GVAR.OptionsFrame.SortInfo.TextFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.SortInfo.Text3:SetPoint("LEFT", GVAR.OptionsFrame.SortInfo.Text2, "RIGHT", 0, 0)
	GVAR.OptionsFrame.SortInfo.Text3:SetJustifyH("LEFT")
	GVAR.OptionsFrame.SortInfo.Text3:SetText(infoTxt3)
	GVAR.OptionsFrame.SortInfo.Text3:SetTextColor(1, 1, 0.49, 1)
	GVAR.OptionsFrame.SortInfo:SetScript("OnEnter", function() GVAR.OptionsFrame.SortInfo.TextFrame:Show() end)
	GVAR.OptionsFrame.SortInfo:SetScript("OnLeave", function() GVAR.OptionsFrame.SortInfo.TextFrame:Hide() end)
		-----
		local txtWidth1 = GVAR.OptionsFrame.SortInfo.Text1:GetStringWidth()
		local txtWidth2 = GVAR.OptionsFrame.SortInfo.Text2:GetStringWidth()
		local txtWidth3 = GVAR.OptionsFrame.SortInfo.Text3:GetStringWidth()
		GVAR.OptionsFrame.SortInfo.Text1:SetWidth(txtWidth1+10)
		GVAR.OptionsFrame.SortInfo.Text2:SetWidth(txtWidth2+10)
		GVAR.OptionsFrame.SortInfo.Text3:SetWidth(txtWidth3+10)
		GVAR.OptionsFrame.SortInfo.TextFrame:SetWidth(10+ txtWidth1+10 + txtWidth2+10 + txtWidth3+10 +10)
		local txtHeight = GVAR.OptionsFrame.SortInfo.Text1:GetStringHeight()
		GVAR.OptionsFrame.SortInfo.Text1:SetHeight(txtHeight+10)
		GVAR.OptionsFrame.SortInfo.Text2:SetHeight(txtHeight+10)
		GVAR.OptionsFrame.SortInfo.Text3:SetHeight(txtHeight+10)
		GVAR.OptionsFrame.SortInfo.TextFrame:SetHeight(10+ txtHeight+10 +10)
		-----
	sortW = sortW + 10 + 16 +10



	-- DUMMY
	GVAR.OptionsFrame.Dummy3 = GVAR.OptionsFrame.ConfigBrackets:CreateTexture(nil, "ARTWORK")
	-- BOOM GVAR.OptionsFrame.Dummy3:SetWidth()
	GVAR.OptionsFrame.Dummy3:SetHeight(1)
	GVAR.OptionsFrame.Dummy3:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.Dummy3:SetPoint("TOP", GVAR.OptionsFrame.SortByTitle, "BOTTOM", 0, -8)
	GVAR.OptionsFrame.Dummy3:SetColorTexture(0.8, 0.2, 0.2, 1)



	-- layout
	GVAR.OptionsFrame.LayoutTHText = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.LayoutTHText:SetHeight(16)
	GVAR.OptionsFrame.LayoutTHText:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 26, 0)
	GVAR.OptionsFrame.LayoutTHText:SetPoint("TOP", GVAR.OptionsFrame.Dummy3, "BOTTOM", 0, -8)
	GVAR.OptionsFrame.LayoutTHText:SetJustifyH("LEFT")
	GVAR.OptionsFrame.LayoutTHText:SetText(L["Layout"]..":")
	GVAR.OptionsFrame.LayoutTHText:SetTextColor(1, 1, 1, 1)
	GVAR.OptionsFrame.LayoutTHText.Background = GVAR.OptionsFrame.ConfigBrackets:CreateTexture(nil, "BACKGROUND")
	GVAR.OptionsFrame.LayoutTHText.Background:SetPoint("TOPLEFT", GVAR.OptionsFrame.LayoutTHText, "TOPLEFT", 0, 0)
	GVAR.OptionsFrame.LayoutTHText.Background:SetPoint("BOTTOMRIGHT", GVAR.OptionsFrame.LayoutTHText, "BOTTOMRIGHT", 0, 0)
	GVAR.OptionsFrame.LayoutTHText.Background:SetColorTexture(0, 0, 0, 0)

	GVAR.OptionsFrame.LayoutTHx18 = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.LayoutTHx18, 16, 4, nil)
	GVAR.OptionsFrame.LayoutTHx18:SetPoint("LEFT", GVAR.OptionsFrame.LayoutTHText, "RIGHT", 10, 0)
	GVAR.OptionsFrame.LayoutTHx18:SetScript("OnClick", function()
		BattlegroundTargets_Options[fraction].LayoutTH[currentSize] = 18
		GVAR.OptionsFrame.LayoutTHx18:SetChecked(true)
		GVAR.OptionsFrame.LayoutTHx24:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx42:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx81:SetChecked(false)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.LayoutSpace)
		BattlegroundTargets:SetupMainFrameLayout(fraction)
	end)
	GVAR.OptionsFrame.LayoutTHx24 = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.LayoutTHx24, 16, 4, nil)
	GVAR.OptionsFrame.LayoutTHx24:SetPoint("LEFT", GVAR.OptionsFrame.LayoutTHx18, "RIGHT", 0, 0)
	GVAR.OptionsFrame.LayoutTHx24:SetScript("OnClick", function()
		BattlegroundTargets_Options[fraction].LayoutTH[currentSize] = 24
		GVAR.OptionsFrame.LayoutTHx18:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx24:SetChecked(true)
		GVAR.OptionsFrame.LayoutTHx42:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx81:SetChecked(false)
		TEMPLATE.EnableSlider(GVAR.OptionsFrame.LayoutSpace)
		BattlegroundTargets:SetupMainFrameLayout(fraction)
	end)
	GVAR.OptionsFrame.LayoutTHx42 = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.LayoutTHx42, 16, 4, nil)
	GVAR.OptionsFrame.LayoutTHx42:SetPoint("LEFT", GVAR.OptionsFrame.LayoutTHx24, "RIGHT", 0, 0)
	GVAR.OptionsFrame.LayoutTHx42:SetScript("OnClick", function()
		BattlegroundTargets_Options[fraction].LayoutTH[currentSize] = 42
		GVAR.OptionsFrame.LayoutTHx18:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx24:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx42:SetChecked(true)
		GVAR.OptionsFrame.LayoutTHx81:SetChecked(false)
		TEMPLATE.EnableSlider(GVAR.OptionsFrame.LayoutSpace)
		BattlegroundTargets:SetupMainFrameLayout(fraction)
	end)
	GVAR.OptionsFrame.LayoutTHx81 = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.LayoutTHx81, 16, 4, nil)
	GVAR.OptionsFrame.LayoutTHx81:SetPoint("LEFT", GVAR.OptionsFrame.LayoutTHx42, "RIGHT", 0, 0)
	GVAR.OptionsFrame.LayoutTHx81:SetScript("OnClick", function()
		BattlegroundTargets_Options[fraction].LayoutTH[currentSize] = 81
		GVAR.OptionsFrame.LayoutTHx18:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx24:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx42:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx81:SetChecked(true)
		TEMPLATE.EnableSlider(GVAR.OptionsFrame.LayoutSpace)
		BattlegroundTargets:SetupMainFrameLayout(fraction)
	end)
	GVAR.OptionsFrame.LayoutSpace = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.LayoutSpaceText = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	TEMPLATE.Slider(GVAR.OptionsFrame.LayoutSpace, 100, 5, 0, 300, BattlegroundTargets_Options[fraction].LayoutSpace[currentSize],
	function(self, value)
		if value == BattlegroundTargets_Options[fraction].LayoutSpace[currentSize] then return end
		BattlegroundTargets_Options[fraction].LayoutSpace[currentSize] = value
		GVAR.OptionsFrame.LayoutSpaceText:SetText(value)
		BattlegroundTargets:EnableConfigMode()
	end,
	"blank")
	GVAR.OptionsFrame.LayoutSpace:SetPoint("LEFT", GVAR.OptionsFrame.LayoutTHx81, "RIGHT", 0, 0)
	GVAR.OptionsFrame.LayoutSpaceText:SetHeight(20)
	GVAR.OptionsFrame.LayoutSpaceText:SetPoint("LEFT", GVAR.OptionsFrame.LayoutSpace, "RIGHT", 5, 0)
	GVAR.OptionsFrame.LayoutSpaceText:SetJustifyH("LEFT")
	GVAR.OptionsFrame.LayoutSpaceText:SetText(BattlegroundTargets_Options[fraction].LayoutSpace[currentSize])
	GVAR.OptionsFrame.LayoutSpaceText:SetTextColor(1, 1, 0.49, 1)
	local layoutW = GVAR.OptionsFrame.LayoutTHText:GetStringWidth() + 10 +
	                GVAR.OptionsFrame.LayoutTHx18:GetWidth() + 0 +
	                GVAR.OptionsFrame.LayoutTHx24:GetWidth() + 0 +
	                GVAR.OptionsFrame.LayoutTHx42:GetWidth() + 0 +
	                GVAR.OptionsFrame.LayoutTHx81:GetWidth() + 0 +
	                GVAR.OptionsFrame.LayoutSpace:GetWidth() + 50



	-- summary
	GVAR.OptionsFrame.SummaryText = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.SummaryText:SetHeight(16)
	GVAR.OptionsFrame.SummaryText:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 26, 0)
	GVAR.OptionsFrame.SummaryText:SetPoint("TOP", GVAR.OptionsFrame.LayoutTHText, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.SummaryText:SetJustifyH("LEFT")
	GVAR.OptionsFrame.SummaryText:SetText(L["Summary"]..":")
	GVAR.OptionsFrame.SummaryText:SetTextColor(1, 1, 1, 1)
	GVAR.OptionsFrame.SummaryText.Background = GVAR.OptionsFrame.ConfigBrackets:CreateTexture(nil, "BACKGROUND")
	GVAR.OptionsFrame.SummaryText.Background:SetPoint("TOPLEFT", GVAR.OptionsFrame.SummaryText, "TOPLEFT", 0, 0)
	GVAR.OptionsFrame.SummaryText.Background:SetPoint("BOTTOMRIGHT", GVAR.OptionsFrame.SummaryText, "BOTTOMRIGHT", 0, 0)
	GVAR.OptionsFrame.SummaryText.Background:SetColorTexture(0, 0, 0, 0)

	GVAR.OptionsFrame.SummaryToggle = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets) -- SUMMARY
	TEMPLATE.CheckButton(GVAR.OptionsFrame.SummaryToggle, 16, 0, "")
	GVAR.OptionsFrame.SummaryToggle:SetPoint("LEFT", GVAR.OptionsFrame.SummaryText, "RIGHT", 10, 0)
	GVAR.OptionsFrame.SummaryToggle:SetChecked(BattlegroundTargets_Options[fraction].SummaryToggle[currentSize])
	TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.SummaryToggle)
	GVAR.OptionsFrame.SummaryToggle:SetScript("OnClick", function()
		BattlegroundTargets_Options[fraction].SummaryToggle[currentSize] = not BattlegroundTargets_Options[fraction].SummaryToggle[currentSize]
		if BattlegroundTargets_Options[fraction].SummaryToggle[currentSize] then
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.SummaryScale)
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.SummaryPosition)
		else
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.SummaryScale)
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.SummaryPosition)
		end
		ConfigFontNumberOptionCheck(currentSize)
		BattlegroundTargets:EnableConfigMode()
	end)

	GVAR.OptionsFrame.SummaryScale = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.SummaryScaleText = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	TEMPLATE.Slider(GVAR.OptionsFrame.SummaryScale, 85, 5, 40, 150, BattlegroundTargets_Options[fraction].SummaryScale[currentSize],
	function(self, value)
		local nvalue = value/100
		if nvalue == BattlegroundTargets_Options[fraction].SummaryScale[currentSize] then return end
		BattlegroundTargets_Options[fraction].SummaryScale[currentSize] = nvalue
		GVAR.OptionsFrame.SummaryScaleText:SetText(value.."%")
		BattlegroundTargets:EnableConfigMode()
	end,
	"blank")
	GVAR.OptionsFrame.SummaryScale:SetPoint("LEFT", GVAR.OptionsFrame.SummaryToggle, "RIGHT", 10, 0)
	GVAR.OptionsFrame.SummaryScaleText:SetHeight(16)
	GVAR.OptionsFrame.SummaryScaleText:SetPoint("LEFT", GVAR.OptionsFrame.SummaryScale, "RIGHT", 5, 0)
	GVAR.OptionsFrame.SummaryScaleText:SetJustifyH("LEFT")
	GVAR.OptionsFrame.SummaryScaleText:SetText((BattlegroundTargets_Options[fraction].SummaryScale[currentSize]*100).."%")
	GVAR.OptionsFrame.SummaryScaleText:SetTextColor(1, 1, 0.49, 1)

	GVAR.OptionsFrame.SummaryPosition = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets) -- SUMPOSi
	GVAR.OptionsFrame.SummaryPositionText = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	TEMPLATE.Slider(GVAR.OptionsFrame.SummaryPosition, 85, 1, 1, 9, BattlegroundTargets_Options[fraction].SummaryPos[currentSize],
	function(self, value)
		if value == BattlegroundTargets_Options[fraction].SummaryPos[currentSize] then return end
		BattlegroundTargets_Options[fraction].SummaryPos[currentSize] = value
		GVAR.OptionsFrame.SummaryPositionText:SetText(sumPos[ value ])
		BattlegroundTargets:EnableConfigMode()
	end,
	"blank")
	GVAR.OptionsFrame.SummaryPosition:SetPoint("LEFT", GVAR.OptionsFrame.SummaryScale, "RIGHT", 50, 0)
	GVAR.OptionsFrame.SummaryPositionText:SetHeight(20)
	GVAR.OptionsFrame.SummaryPositionText:SetWidth(50)
	GVAR.OptionsFrame.SummaryPositionText:SetPoint("LEFT", GVAR.OptionsFrame.SummaryPosition, "RIGHT", 5, 0)
	GVAR.OptionsFrame.SummaryPositionText:SetJustifyH("LEFT")
	GVAR.OptionsFrame.SummaryPositionText:SetText(sumPos[ BattlegroundTargets_Options[fraction].SummaryPos[currentSize] ])
	GVAR.OptionsFrame.SummaryPositionText:SetTextColor(1, 1, 0.49, 1)

	if BattlegroundTargets_Options[fraction].SummaryToggle[currentSize] then
		TEMPLATE.EnableSlider(GVAR.OptionsFrame.SummaryScale)
		TEMPLATE.EnableSlider(GVAR.OptionsFrame.SummaryPosition)
	else
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.SummaryScale)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.SummaryPosition)
	end
	local summaryW = GVAR.OptionsFrame.SummaryText:GetStringWidth() + 10 +
	                 GVAR.OptionsFrame.SummaryToggle:GetWidth() + 10 +
	                 GVAR.OptionsFrame.SummaryScale:GetWidth() + 10 +
	                 GVAR.OptionsFrame.SummaryPosition:GetWidth() + 50



	-- DUMMY
	GVAR.OptionsFrame.Dummy4 = GVAR.OptionsFrame.ConfigBrackets:CreateTexture(nil, "ARTWORK")
	-- BOOM GVAR.OptionsFrame.Dummy4:SetWidth()
	GVAR.OptionsFrame.Dummy4:SetHeight(1)
	GVAR.OptionsFrame.Dummy4:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.Dummy4:SetPoint("TOP", GVAR.OptionsFrame.SummaryToggle, "BOTTOM", 0, -8)
	GVAR.OptionsFrame.Dummy4:SetColorTexture(0.8, 0.2, 0.2, 1)



	-- show role
	GVAR.OptionsFrame.ShowRole = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.ShowRole, 16, 4, L["Role"])
	GVAR.OptionsFrame.ShowRole:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.ShowRole:SetPoint("TOP", GVAR.OptionsFrame.Dummy4, "BOTTOM", 0, -8)
	GVAR.OptionsFrame.ShowRole:SetChecked(BattlegroundTargets_Options[fraction].ButtonRoleToggle[currentSize])
	GVAR.OptionsFrame.ShowRole:SetScript("OnClick", function()
		BattlegroundTargets_Options[fraction].ButtonRoleToggle[currentSize] = not BattlegroundTargets_Options[fraction].ButtonRoleToggle[currentSize]
		GVAR.OptionsFrame.ShowRole:SetChecked(BattlegroundTargets_Options[fraction].ButtonRoleToggle[currentSize])
		BattlegroundTargets:EnableConfigMode()
	end)

	-- show spec
	GVAR.OptionsFrame.ShowSpec = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.ShowSpec, 16, 4, L["Specialization"])
	--GVAR.OptionsFrame.ShowSpec:SetPoint()
	GVAR.OptionsFrame.ShowSpec:SetChecked(BattlegroundTargets_Options[fraction].ButtonSpecToggle[currentSize])
	GVAR.OptionsFrame.ShowSpec:SetScript("OnClick", function()
		BattlegroundTargets_Options[fraction].ButtonSpecToggle[currentSize] = not BattlegroundTargets_Options[fraction].ButtonSpecToggle[currentSize]
		GVAR.OptionsFrame.ShowSpec:SetChecked(BattlegroundTargets_Options[fraction].ButtonSpecToggle[currentSize])
		BattlegroundTargets:EnableConfigMode()
	end)

	-- class icon
	GVAR.OptionsFrame.ClassIcon = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.ClassIcon, 16, 4, L["Class Icon"])
	--GVAR.OptionsFrame.ClassIcon:SetPoint()
	GVAR.OptionsFrame.ClassIcon:SetChecked(BattlegroundTargets_Options[fraction].ButtonClassToggle[currentSize])
	GVAR.OptionsFrame.ClassIcon:SetScript("OnClick", function()
		BattlegroundTargets_Options[fraction].ButtonClassToggle[currentSize] = not BattlegroundTargets_Options[fraction].ButtonClassToggle[currentSize]
		GVAR.OptionsFrame.ClassIcon:SetChecked(BattlegroundTargets_Options[fraction].ButtonClassToggle[currentSize])
		BattlegroundTargets:EnableConfigMode()
	end)

	-- show realm
	GVAR.OptionsFrame.ShowRealm = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.ShowRealm, 16, 4, L["Realm"])
	GVAR.OptionsFrame.ShowRealm:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.ShowRealm:SetPoint("TOP", GVAR.OptionsFrame.ShowRole, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.ShowRealm:SetChecked(BattlegroundTargets_Options[fraction].ButtonRealmToggle[currentSize])
	GVAR.OptionsFrame.ShowRealm:SetScript("OnClick", function()
		BattlegroundTargets_Options[fraction].ButtonRealmToggle[currentSize] = not BattlegroundTargets_Options[fraction].ButtonRealmToggle[currentSize]
		GVAR.OptionsFrame.ShowRealm:SetChecked(BattlegroundTargets_Options[fraction].ButtonRealmToggle[currentSize])
		BattlegroundTargets:EnableConfigMode()
	end)

	-- show leader
	GVAR.OptionsFrame.ShowLeader = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.ShowLeader, 16, 4, L["Leader"])
	--GVAR.OptionsFrame.ShowLeader:SetPoint()
	GVAR.OptionsFrame.ShowLeader:SetChecked(BattlegroundTargets_Options[fraction].ButtonLeaderToggle[currentSize])
	GVAR.OptionsFrame.ShowLeader:SetScript("OnClick", function()
		BattlegroundTargets_Options[fraction].ButtonLeaderToggle[currentSize] = not BattlegroundTargets_Options[fraction].ButtonLeaderToggle[currentSize]
		GVAR.OptionsFrame.ShowLeader:SetChecked(BattlegroundTargets_Options[fraction].ButtonLeaderToggle[currentSize])
		BattlegroundTargets:EnableConfigMode()
	end)

	-- pvp trinket
	GVAR.OptionsFrame.ShowPVPTrinket = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.ShowPVPTrinket, 16, 4, L["PvP Trinket"])
	GVAR.OptionsFrame.ShowPVPTrinket:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.ShowPVPTrinket:SetPoint("TOP", GVAR.OptionsFrame.ShowRealm, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.ShowPVPTrinket:SetChecked(BattlegroundTargets_Options[fraction].ButtonPvPTrinketToggle[currentSize])
	GVAR.OptionsFrame.ShowPVPTrinket:SetScript("OnClick", function()
		BattlegroundTargets_Options[fraction].ButtonPvPTrinketToggle[currentSize] = not BattlegroundTargets_Options[fraction].ButtonPvPTrinketToggle[currentSize]
		GVAR.OptionsFrame.ShowPVPTrinket:SetChecked(BattlegroundTargets_Options[fraction].ButtonPvPTrinketToggle[currentSize])
		ConfigFontNumberOptionCheck(currentSize)
		BattlegroundTargets:EnableConfigMode()
	end)

	-- targetcount friend
	GVAR.OptionsFrame.ShowFTargetCount = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.ShowFTargetCount, 16, 4, L["Target Count"].." " ..L["Friend"])
	--GVAR.OptionsFrame.ShowFTargetCount:SetPoint()
	GVAR.OptionsFrame.ShowFTargetCount:SetChecked(BattlegroundTargets_Options[fraction].ButtonFTargetCountToggle[currentSize])
	GVAR.OptionsFrame.ShowFTargetCount:SetScript("OnClick", function()
		BattlegroundTargets_Options[fraction].ButtonFTargetCountToggle[currentSize] = not BattlegroundTargets_Options[fraction].ButtonFTargetCountToggle[currentSize]
		GVAR.OptionsFrame.ShowFTargetCount:SetChecked(BattlegroundTargets_Options[fraction].ButtonFTargetCountToggle[currentSize])
		ConfigFontNumberOptionCheck(currentSize)
		BattlegroundTargets:EnableConfigMode()
	end)

	-- targetcount enemy
	GVAR.OptionsFrame.ShowETargetCount = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.ShowETargetCount, 16, 4, L["Target Count"].." "..L["Enemy"])
	--GVAR.OptionsFrame.ShowETargetCount:SetPoint()
	GVAR.OptionsFrame.ShowETargetCount:SetChecked(BattlegroundTargets_Options[fraction].ButtonETargetCountToggle[currentSize])
	GVAR.OptionsFrame.ShowETargetCount:SetScript("OnClick", function()
		BattlegroundTargets_Options[fraction].ButtonETargetCountToggle[currentSize] = not BattlegroundTargets_Options[fraction].ButtonETargetCountToggle[currentSize]
		GVAR.OptionsFrame.ShowETargetCount:SetChecked(BattlegroundTargets_Options[fraction].ButtonETargetCountToggle[currentSize])
		ConfigFontNumberOptionCheck(currentSize)
		BattlegroundTargets:EnableConfigMode()
	end)

	local eq1, sw = 0, 0
	sw = GVAR.OptionsFrame.ShowRole:GetWidth() if sw > eq1 then eq1 = sw end
	sw = GVAR.OptionsFrame.ShowRealm:GetWidth() if sw > eq1 then eq1 = sw end
	sw = GVAR.OptionsFrame.ShowPVPTrinket:GetWidth() if sw > eq1 then eq1 = sw end
	GVAR.OptionsFrame.ShowSpec:SetPoint("LEFT", GVAR.OptionsFrame.ShowRole, "LEFT", eq1+50, 0)
	GVAR.OptionsFrame.ShowLeader:SetPoint("LEFT", GVAR.OptionsFrame.ShowRealm, "LEFT", eq1+50, 0)
	GVAR.OptionsFrame.ShowFTargetCount:SetPoint("LEFT", GVAR.OptionsFrame.ShowPVPTrinket, "LEFT", eq1+50, 0)

	local eq2, sw = 0, 0
	sw = GVAR.OptionsFrame.ShowSpec:GetWidth() if sw > eq2 then eq2 = sw end
	sw = GVAR.OptionsFrame.ShowLeader:GetWidth() if sw > eq2 then eq2 = sw end
	sw = GVAR.OptionsFrame.ShowFTargetCount:GetWidth() if sw > eq2 then eq2 = sw end
	GVAR.OptionsFrame.ClassIcon:SetPoint("LEFT", GVAR.OptionsFrame.ShowSpec, "LEFT", eq2+50, 0)
	GVAR.OptionsFrame.ShowETargetCount:SetPoint("LEFT", GVAR.OptionsFrame.ShowFTargetCount, "LEFT", eq2+50, 0)

	local eq3, sw = 0, 0
	sw = GVAR.OptionsFrame.ClassIcon:GetWidth() if sw > eq3 then eq3 = sw end
	sw = GVAR.OptionsFrame.ShowETargetCount:GetWidth() if sw > eq3 then eq3 = sw end

	local generalIconW = 10 + eq1 + 50 + eq2 + 50 + eq3 + 10



	-- DUMMY
	GVAR.OptionsFrame.Dummy5 = GVAR.OptionsFrame.ConfigBrackets:CreateTexture(nil, "ARTWORK")
	-- BOOM GVAR.OptionsFrame.Dummy5:SetWidth()
	GVAR.OptionsFrame.Dummy5:SetHeight(1)
	GVAR.OptionsFrame.Dummy5:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.Dummy5:SetPoint("TOP", GVAR.OptionsFrame.ShowFTargetCount, "BOTTOM", 0, -8)
	GVAR.OptionsFrame.Dummy5:SetColorTexture(0.73, 0.26, 0.21, 0.5)



	-- ----- icons ----------------------------------------
	local equalTextWidthIcons = 0
	-- show target indicator
	GVAR.OptionsFrame.ShowTargetIndicator = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.ShowTargetIndicator, 16, 4, L["Target"])
	GVAR.OptionsFrame.ShowTargetIndicator:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.ShowTargetIndicator:SetPoint("TOP", GVAR.OptionsFrame.Dummy5, "BOTTOM", 0, -8)
	GVAR.OptionsFrame.ShowTargetIndicator:SetChecked(BattlegroundTargets_Options[fraction].ButtonTargetToggle[currentSize])
	GVAR.OptionsFrame.ShowTargetIndicator:SetScript("OnClick", function()
		BattlegroundTargets_Options[fraction].ButtonTargetToggle[currentSize] = not BattlegroundTargets_Options[fraction].ButtonTargetToggle[currentSize]
		GVAR.OptionsFrame.ShowTargetIndicator:SetChecked(BattlegroundTargets_Options[fraction].ButtonTargetToggle[currentSize])
		if BattlegroundTargets_Options[fraction].ButtonTargetToggle[currentSize] then
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.TargetScaleSlider)
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.TargetPositionSlider)
		else
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.TargetScaleSlider)
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.TargetPositionSlider)
		end
		BattlegroundTargets:EnableConfigMode()
	end)
	local iw = GVAR.OptionsFrame.ShowTargetIndicator:GetWidth()
	if iw > equalTextWidthIcons then
		equalTextWidthIcons = iw
	end

	-- target indicator scale
	GVAR.OptionsFrame.TargetScaleSlider = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.TargetScaleSliderText = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	TEMPLATE.Slider(GVAR.OptionsFrame.TargetScaleSlider, 85, 10, 100, 200, BattlegroundTargets_Options[fraction].ButtonTargetScale[currentSize]*100,
	function(self, value)
		local nvalue = value/100
		if nvalue == BattlegroundTargets_Options[fraction].ButtonTargetScale[currentSize] then return end
		BattlegroundTargets_Options[fraction].ButtonTargetScale[currentSize] = nvalue
		GVAR.OptionsFrame.TargetScaleSliderText:SetText(value.."%")
		BattlegroundTargets:EnableConfigMode()
	end,
	"blank")
	GVAR.OptionsFrame.TargetScaleSlider:SetPoint("LEFT", GVAR.OptionsFrame.ShowTargetIndicator, "RIGHT", 10, 0)
	GVAR.OptionsFrame.TargetScaleSliderText:SetHeight(20)
	GVAR.OptionsFrame.TargetScaleSliderText:SetPoint("LEFT", GVAR.OptionsFrame.TargetScaleSlider, "RIGHT", 5, 0)
	GVAR.OptionsFrame.TargetScaleSliderText:SetJustifyH("LEFT")
	GVAR.OptionsFrame.TargetScaleSliderText:SetText((BattlegroundTargets_Options[fraction].ButtonTargetScale[currentSize]*100).."%")
	GVAR.OptionsFrame.TargetScaleSliderText:SetTextColor(1, 1, 0.49, 1)

	-- target indicator position
	GVAR.OptionsFrame.TargetPositionSlider = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.TargetPositionSliderText = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	TEMPLATE.Slider(GVAR.OptionsFrame.TargetPositionSlider, 85, 5, 0, 100, BattlegroundTargets_Options[fraction].ButtonTargetPosition[currentSize],
	function(self, value)
		if value == BattlegroundTargets_Options[fraction].ButtonTargetPosition[currentSize] then return end
		BattlegroundTargets_Options[fraction].ButtonTargetPosition[currentSize] = value
		GVAR.OptionsFrame.TargetPositionSliderText:SetText(value)
		BattlegroundTargets:EnableConfigMode()
	end,
	"blank")
	GVAR.OptionsFrame.TargetPositionSlider:SetPoint("LEFT", GVAR.OptionsFrame.TargetScaleSlider, "RIGHT", 50, 0)
	GVAR.OptionsFrame.TargetPositionSliderText:SetHeight(20)
	GVAR.OptionsFrame.TargetPositionSliderText:SetPoint("LEFT", GVAR.OptionsFrame.TargetPositionSlider, "RIGHT", 5, 0)
	GVAR.OptionsFrame.TargetPositionSliderText:SetJustifyH("LEFT")
	GVAR.OptionsFrame.TargetPositionSliderText:SetText(BattlegroundTargets_Options[fraction].ButtonTargetPosition[currentSize])
	GVAR.OptionsFrame.TargetPositionSliderText:SetTextColor(1, 1, 0.49, 1)

	-- show targetoftarget
	GVAR.OptionsFrame.TargetofTarget = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.TargetofTarget, 16, 4, L["Target of Target"])
	GVAR.OptionsFrame.TargetofTarget:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.TargetofTarget:SetPoint("TOP", GVAR.OptionsFrame.ShowTargetIndicator, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.TargetofTarget:SetChecked(BattlegroundTargets_Options[fraction].ButtonToTToggle[currentSize])
	GVAR.OptionsFrame.TargetofTarget:SetScript("OnClick", function()
		BattlegroundTargets_Options[fraction].ButtonToTToggle[currentSize] = not BattlegroundTargets_Options[fraction].ButtonToTToggle[currentSize]
		GVAR.OptionsFrame.TargetofTarget:SetChecked(BattlegroundTargets_Options[fraction].ButtonToTToggle[currentSize])
		ConfigFontNumberOptionCheck(currentSize)
		if BattlegroundTargets_Options[fraction].ButtonToTToggle[currentSize] then
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.ToTScaleSlider)
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.ToTPositionSlider)
		else
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.ToTScaleSlider)
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.ToTPositionSlider)
		end
		BattlegroundTargets:EnableConfigMode()
	end)
	local iw = GVAR.OptionsFrame.TargetofTarget:GetWidth()
	if iw > equalTextWidthIcons then
		equalTextWidthIcons = iw
	end

	-- targetoftarget scale
	GVAR.OptionsFrame.ToTScaleSlider = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.ToTScaleSliderText = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	TEMPLATE.Slider(GVAR.OptionsFrame.ToTScaleSlider, 85, 10, 50, 100, BattlegroundTargets_Options[fraction].ButtonToTScale[currentSize]*100,
	function(self, value)
		local nvalue = value/100
		if nvalue == BattlegroundTargets_Options[fraction].ButtonToTScale[currentSize] then return end
		BattlegroundTargets_Options[fraction].ButtonToTScale[currentSize] = nvalue
		GVAR.OptionsFrame.ToTScaleSliderText:SetText(value.."%")
		BattlegroundTargets:EnableConfigMode()
	end,
	"blank")
	GVAR.OptionsFrame.ToTScaleSlider:SetPoint("LEFT", GVAR.OptionsFrame.TargetofTarget, "RIGHT", 10, 0)
	GVAR.OptionsFrame.ToTScaleSliderText:SetHeight(20)
	GVAR.OptionsFrame.ToTScaleSliderText:SetPoint("LEFT", GVAR.OptionsFrame.ToTScaleSlider, "RIGHT", 5, 0)
	GVAR.OptionsFrame.ToTScaleSliderText:SetJustifyH("LEFT")
	GVAR.OptionsFrame.ToTScaleSliderText:SetText((BattlegroundTargets_Options[fraction].ButtonToTScale[currentSize]*100).."%")
	GVAR.OptionsFrame.ToTScaleSliderText:SetTextColor(1, 1, 0.49, 1)

	-- targetoftarget position
	GVAR.OptionsFrame.ToTPositionSlider = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.ToTPositionSliderText = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	TEMPLATE.Slider(GVAR.OptionsFrame.ToTPositionSlider, 85, 1, 1, 9, BattlegroundTargets_Options[fraction].ButtonToTPosition[currentSize],
	function(self, value)
		if value == BattlegroundTargets_Options[fraction].ButtonToTPosition[currentSize] then return end
		BattlegroundTargets_Options[fraction].ButtonToTPosition[currentSize] = value
		GVAR.OptionsFrame.ToTPositionSliderText:SetText(value)
		BattlegroundTargets:EnableConfigMode()
	end,
	"blank")
	GVAR.OptionsFrame.ToTPositionSlider:SetPoint("LEFT", GVAR.OptionsFrame.ToTScaleSlider, "RIGHT", 50, 0)
	GVAR.OptionsFrame.ToTPositionSliderText:SetHeight(20)
	GVAR.OptionsFrame.ToTPositionSliderText:SetPoint("LEFT", GVAR.OptionsFrame.ToTPositionSlider, "RIGHT", 5, 0)
	GVAR.OptionsFrame.ToTPositionSliderText:SetJustifyH("LEFT")
	GVAR.OptionsFrame.ToTPositionSliderText:SetText(BattlegroundTargets_Options[fraction].ButtonToTPosition[currentSize])
	GVAR.OptionsFrame.ToTPositionSliderText:SetTextColor(1, 1, 0.49, 1)

	-- show focus indicator
	GVAR.OptionsFrame.ShowFocusIndicator = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.ShowFocusIndicator, 16, 4, L["Focus"])
	GVAR.OptionsFrame.ShowFocusIndicator:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.ShowFocusIndicator:SetPoint("TOP", GVAR.OptionsFrame.TargetofTarget, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.ShowFocusIndicator:SetChecked(BattlegroundTargets_Options[fraction].ButtonFocusToggle[currentSize])
	GVAR.OptionsFrame.ShowFocusIndicator:SetScript("OnClick", function()
		BattlegroundTargets_Options[fraction].ButtonFocusToggle[currentSize] = not BattlegroundTargets_Options[fraction].ButtonFocusToggle[currentSize]
		GVAR.OptionsFrame.ShowFocusIndicator:SetChecked(BattlegroundTargets_Options[fraction].ButtonFocusToggle[currentSize])
		if BattlegroundTargets_Options[fraction].ButtonFocusToggle[currentSize] then
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.FocusScaleSlider)
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.FocusPositionSlider)
		else
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.FocusScaleSlider)
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.FocusPositionSlider)
		end
		BattlegroundTargets:EnableConfigMode()
	end)
	local iw = GVAR.OptionsFrame.ShowFocusIndicator:GetWidth()
	if iw > equalTextWidthIcons then
		equalTextWidthIcons = iw
	end

	-- focus indicator scale
	GVAR.OptionsFrame.FocusScaleSlider = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.FocusScaleSliderText = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	TEMPLATE.Slider(GVAR.OptionsFrame.FocusScaleSlider, 85, 10, 100, 200, BattlegroundTargets_Options[fraction].ButtonFocusScale[currentSize]*100,
	function(self, value)
		local nvalue = value/100
		if nvalue == BattlegroundTargets_Options[fraction].ButtonFocusScale[currentSize] then return end
		BattlegroundTargets_Options[fraction].ButtonFocusScale[currentSize] = nvalue
		GVAR.OptionsFrame.FocusScaleSliderText:SetText(value.."%")
		BattlegroundTargets:EnableConfigMode()
	end,
	"blank")
	GVAR.OptionsFrame.FocusScaleSlider:SetPoint("LEFT", GVAR.OptionsFrame.ShowFocusIndicator, "RIGHT", 10, 0)
	GVAR.OptionsFrame.FocusScaleSliderText:SetHeight(20)
	GVAR.OptionsFrame.FocusScaleSliderText:SetPoint("LEFT", GVAR.OptionsFrame.FocusScaleSlider, "RIGHT", 5, 0)
	GVAR.OptionsFrame.FocusScaleSliderText:SetJustifyH("LEFT")
	GVAR.OptionsFrame.FocusScaleSliderText:SetText((BattlegroundTargets_Options[fraction].ButtonFocusScale[currentSize]*100).."%")
	GVAR.OptionsFrame.FocusScaleSliderText:SetTextColor(1, 1, 0.49, 1)

	-- focus indicator position
	GVAR.OptionsFrame.FocusPositionSlider = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.FocusPositionSliderText = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	TEMPLATE.Slider(GVAR.OptionsFrame.FocusPositionSlider, 85, 5, 0, 100, BattlegroundTargets_Options[fraction].ButtonFocusPosition[currentSize],
	function(self, value)
		if value == BattlegroundTargets_Options[fraction].ButtonFocusPosition[currentSize] then return end
		BattlegroundTargets_Options[fraction].ButtonFocusPosition[currentSize] = value
		GVAR.OptionsFrame.FocusPositionSliderText:SetText(value)
		BattlegroundTargets:EnableConfigMode()
	end,
	"blank")
	GVAR.OptionsFrame.FocusPositionSlider:SetPoint("LEFT", GVAR.OptionsFrame.FocusScaleSlider, "RIGHT", 50, 0)
	GVAR.OptionsFrame.FocusPositionSliderText:SetHeight(20)
	GVAR.OptionsFrame.FocusPositionSliderText:SetPoint("LEFT", GVAR.OptionsFrame.FocusPositionSlider, "RIGHT", 5, 0)
	GVAR.OptionsFrame.FocusPositionSliderText:SetJustifyH("LEFT")
	GVAR.OptionsFrame.FocusPositionSliderText:SetText(BattlegroundTargets_Options[fraction].ButtonFocusPosition[currentSize])
	GVAR.OptionsFrame.FocusPositionSliderText:SetTextColor(1, 1, 0.49, 1)

	-- flag/orb
	GVAR.OptionsFrame.ShowFlag = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.ShowFlag, 16, 4, L["Flag"])
	GVAR.OptionsFrame.ShowFlag:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.ShowFlag:SetPoint("TOP", GVAR.OptionsFrame.ShowFocusIndicator, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.ShowFlag:SetChecked(BattlegroundTargets_Options[fraction].ButtonFlagToggle[currentSize])
	TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.ShowFlag)
	GVAR.OptionsFrame.ShowFlag:SetScript("OnClick", function()
		BattlegroundTargets_Options[fraction].ButtonFlagToggle[currentSize] = not BattlegroundTargets_Options[fraction].ButtonFlagToggle[currentSize]
		if BattlegroundTargets_Options[fraction].ButtonFlagToggle[currentSize] then
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.FlagScaleSlider)
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.FlagPositionSlider)
			GVAR.OptionsFrame.CarrierSwitchEnableFunc()
		else
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.FlagScaleSlider)
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.FlagPositionSlider)
			GVAR.OptionsFrame.CarrierSwitchDisableFunc()
		end
		ConfigFontNumberOptionCheck(currentSize)
		BattlegroundTargets:EnableConfigMode()
	end)

	-- flag
	GVAR.OptionsFrame.CarrierSwitchFlag = CreateFrame("Button", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.CarrierSwitchFlag:SetWidth(32)
	GVAR.OptionsFrame.CarrierSwitchFlag:SetHeight(32)
	GVAR.OptionsFrame.CarrierSwitchFlag:SetPoint("LEFT", GVAR.OptionsFrame.ShowFlag, "RIGHT", 0, 0)
	GVAR.OptionsFrame.CarrierSwitchFlag.BG = GVAR.OptionsFrame.CarrierSwitchFlag:CreateTexture(nil, "BORDER")
	GVAR.OptionsFrame.CarrierSwitchFlag.BG:SetWidth(27)
	GVAR.OptionsFrame.CarrierSwitchFlag.BG:SetHeight(27)
	GVAR.OptionsFrame.CarrierSwitchFlag.BG:SetPoint("CENTER", 0, 0)
	GVAR.OptionsFrame.CarrierSwitchFlag.BG:SetColorTexture(0, 0, 0, 1)
	GVAR.OptionsFrame.CarrierSwitchFlag.Texture = GVAR.OptionsFrame.CarrierSwitchFlag:CreateTexture(nil, "OVERLAY")
	GVAR.OptionsFrame.CarrierSwitchFlag.Texture:SetWidth(30)
	GVAR.OptionsFrame.CarrierSwitchFlag.Texture:SetHeight(30)
	GVAR.OptionsFrame.CarrierSwitchFlag.Texture:SetPoint("CENTER", 0, 0)
	GVAR.OptionsFrame.CarrierSwitchFlag.Texture:SetTexture(Textures.flagTexture)
	GVAR.OptionsFrame.CarrierSwitchFlag:SetScript("OnEnter", function(self)
		if testData.CarrierDisplay == "flag" then return end
		GVAR.OptionsFrame.CarrierSwitchFlag.isDisplay = testData.CarrierDisplay
		testData.CarrierDisplay = "flag"
		BattlegroundTargets:EnableConfigMode()
		GVAR.OptionsFrame.CarrierSwitchFlag.BG:SetColorTexture(0.12, 0.12, 0.12, 1)
	end)
	GVAR.OptionsFrame.CarrierSwitchFlag:SetScript("OnLeave", function(self)
		if GVAR.OptionsFrame.CarrierSwitchFlag.isDisplay ~= testData.CarrierDisplay then
			testData.CarrierDisplay = GVAR.OptionsFrame.CarrierSwitchFlag.isDisplay
			BattlegroundTargets:EnableConfigMode()
		end
		if testData.CarrierDisplay == "flag" then return end
		GVAR.OptionsFrame.CarrierSwitchFlag.BG:SetColorTexture(0, 0, 0, 1)
	end)
	GVAR.OptionsFrame.CarrierSwitchFlag:SetScript("OnMouseDown", function()
		if GVAR.OptionsFrame.CarrierSwitchFlag.isDisplay == "flag" then return end
		GVAR.OptionsFrame.CarrierSwitchFlag.BG:SetSize(25,25)
		GVAR.OptionsFrame.CarrierSwitchFlag.Texture:SetSize(28,28)
	end)
	GVAR.OptionsFrame.CarrierSwitchFlag:SetScript("OnMouseUp", function()
		if GVAR.OptionsFrame.CarrierSwitchFlag.isDisplay == "flag" then return end
		GVAR.OptionsFrame.CarrierSwitchFlag.BG:SetSize(27,27)
		GVAR.OptionsFrame.CarrierSwitchFlag.Texture:SetSize(30,30)
	end)
	GVAR.OptionsFrame.CarrierSwitchFlag:SetScript("OnClick", function()
		if GVAR.OptionsFrame.CarrierSwitchFlag.isDisplay == "flag" then return end
		testData.CarrierDisplay = "flag"
		GVAR.OptionsFrame.CarrierSwitchFlag.isDisplay = "flag"
		GVAR.OptionsFrame.CarrierSwitchFlag.BG:SetColorTexture(0.12, 0.12, 0.12, 1)
		GVAR.OptionsFrame.CarrierSwitchOrb.BG:SetColorTexture(0, 0, 0, 1)
		GVAR.OptionsFrame.CarrierSwitchCart.BG:SetColorTexture(0, 0, 0, 1)
		BattlegroundTargets:EnableConfigMode()
	end)
	-- flag

	-- orb
	GVAR.OptionsFrame.CarrierSwitchOrb = CreateFrame("Button", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.CarrierSwitchOrb:SetWidth(32)
	GVAR.OptionsFrame.CarrierSwitchOrb:SetHeight(32)
	GVAR.OptionsFrame.CarrierSwitchOrb:SetPoint("LEFT", GVAR.OptionsFrame.CarrierSwitchFlag, "RIGHT", 0, 0)
	GVAR.OptionsFrame.CarrierSwitchOrb.BG = GVAR.OptionsFrame.CarrierSwitchOrb:CreateTexture(nil, "BORDER")
	GVAR.OptionsFrame.CarrierSwitchOrb.BG:SetWidth(27)
	GVAR.OptionsFrame.CarrierSwitchOrb.BG:SetHeight(27)
	GVAR.OptionsFrame.CarrierSwitchOrb.BG:SetPoint("CENTER", 0, 0)
	GVAR.OptionsFrame.CarrierSwitchOrb.BG:SetColorTexture(0, 0, 0, 1)
	GVAR.OptionsFrame.CarrierSwitchOrb.Texture = GVAR.OptionsFrame.CarrierSwitchOrb:CreateTexture(nil, "OVERLAY")
	GVAR.OptionsFrame.CarrierSwitchOrb.Texture:SetWidth(30)
	GVAR.OptionsFrame.CarrierSwitchOrb.Texture:SetHeight(30)
	GVAR.OptionsFrame.CarrierSwitchOrb.Texture:SetPoint("CENTER", 0, 0)
	GVAR.OptionsFrame.CarrierSwitchOrb.Texture:SetTexture("Interface\\MiniMap\\TempleofKotmogu_ball_orange")
	GVAR.OptionsFrame.CarrierSwitchOrb:SetScript("OnEnter", function(self)
		if testData.CarrierDisplay == "orb" then return end
		GVAR.OptionsFrame.CarrierSwitchFlag.isDisplay = testData.CarrierDisplay
		testData.CarrierDisplay = "orb"
		BattlegroundTargets:EnableConfigMode()
		GVAR.OptionsFrame.CarrierSwitchOrb.BG:SetColorTexture(0.12, 0.12, 0.12, 1)
	end)
	GVAR.OptionsFrame.CarrierSwitchOrb:SetScript("OnLeave", function(self)
		if GVAR.OptionsFrame.CarrierSwitchFlag.isDisplay ~= testData.CarrierDisplay then
			testData.CarrierDisplay = GVAR.OptionsFrame.CarrierSwitchFlag.isDisplay
			BattlegroundTargets:EnableConfigMode()
		end
		if testData.CarrierDisplay == "orb" then return end
		GVAR.OptionsFrame.CarrierSwitchOrb.BG:SetColorTexture(0, 0, 0, 1)
	end)
	GVAR.OptionsFrame.CarrierSwitchOrb:SetScript("OnMouseDown", function()
		if GVAR.OptionsFrame.CarrierSwitchFlag.isDisplay == "orb" then return end
		GVAR.OptionsFrame.CarrierSwitchOrb.BG:SetSize(25,25)
		GVAR.OptionsFrame.CarrierSwitchOrb.Texture:SetSize(28,28)
	end)
	GVAR.OptionsFrame.CarrierSwitchOrb:SetScript("OnMouseUp", function()
		if GVAR.OptionsFrame.CarrierSwitchFlag.isDisplay == "orb" then return end
		GVAR.OptionsFrame.CarrierSwitchOrb.BG:SetSize(27,27)
		GVAR.OptionsFrame.CarrierSwitchOrb.Texture:SetSize(30,30)
	end)
	GVAR.OptionsFrame.CarrierSwitchOrb:SetScript("OnClick", function()
		if GVAR.OptionsFrame.CarrierSwitchFlag.isDisplay == "orb" then return end
		testData.CarrierDisplay = "orb"
		GVAR.OptionsFrame.CarrierSwitchFlag.isDisplay = "orb"
		GVAR.OptionsFrame.CarrierSwitchFlag.BG:SetColorTexture(0, 0, 0, 1)
		GVAR.OptionsFrame.CarrierSwitchOrb.BG:SetColorTexture(0.12, 0.12, 0.12, 1)
		GVAR.OptionsFrame.CarrierSwitchCart.BG:SetColorTexture(0, 0, 0, 1)
		BattlegroundTargets:EnableConfigMode()
	end)
	-- orb

	-- cart
	GVAR.OptionsFrame.CarrierSwitchCart = CreateFrame("Button", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.CarrierSwitchCart:SetWidth(32)
	GVAR.OptionsFrame.CarrierSwitchCart:SetHeight(32)
	GVAR.OptionsFrame.CarrierSwitchCart:SetPoint("LEFT", GVAR.OptionsFrame.CarrierSwitchOrb, "RIGHT", 0, 0)
	GVAR.OptionsFrame.CarrierSwitchCart.BG = GVAR.OptionsFrame.CarrierSwitchCart:CreateTexture(nil, "BORDER")
	GVAR.OptionsFrame.CarrierSwitchCart.BG:SetWidth(27)
	GVAR.OptionsFrame.CarrierSwitchCart.BG:SetHeight(27)
	GVAR.OptionsFrame.CarrierSwitchCart.BG:SetPoint("CENTER", 0, 0)
	GVAR.OptionsFrame.CarrierSwitchCart.BG:SetColorTexture(0, 0, 0, 1)
	GVAR.OptionsFrame.CarrierSwitchCart.Texture = GVAR.OptionsFrame.CarrierSwitchCart:CreateTexture(nil, "OVERLAY")
	GVAR.OptionsFrame.CarrierSwitchCart.Texture:SetWidth(30)
	GVAR.OptionsFrame.CarrierSwitchCart.Texture:SetHeight(30)
	GVAR.OptionsFrame.CarrierSwitchCart.Texture:SetPoint("CENTER", 0, 0)
	GVAR.OptionsFrame.CarrierSwitchCart.Texture:SetTexture(Textures.cartTexture)
	GVAR.OptionsFrame.CarrierSwitchCart:SetScript("OnEnter", function(self)
		if testData.CarrierDisplay == "cart" then return end
		GVAR.OptionsFrame.CarrierSwitchFlag.isDisplay = testData.CarrierDisplay
		testData.CarrierDisplay = "cart"
		BattlegroundTargets:EnableConfigMode()
		GVAR.OptionsFrame.CarrierSwitchCart.BG:SetColorTexture(0.12, 0.12, 0.12, 1)
	end)
	GVAR.OptionsFrame.CarrierSwitchCart:SetScript("OnLeave", function(self)
		if GVAR.OptionsFrame.CarrierSwitchFlag.isDisplay ~= testData.CarrierDisplay then
			testData.CarrierDisplay = GVAR.OptionsFrame.CarrierSwitchFlag.isDisplay
			BattlegroundTargets:EnableConfigMode()
		end
		if testData.CarrierDisplay == "cart" then return end
		GVAR.OptionsFrame.CarrierSwitchCart.BG:SetColorTexture(0, 0, 0, 1)
	end)
	GVAR.OptionsFrame.CarrierSwitchCart:SetScript("OnMouseDown", function()
		if GVAR.OptionsFrame.CarrierSwitchFlag.isDisplay == "cart" then return end
		GVAR.OptionsFrame.CarrierSwitchCart.BG:SetSize(25,25)
		GVAR.OptionsFrame.CarrierSwitchCart.Texture:SetSize(28,28)
	end)
	GVAR.OptionsFrame.CarrierSwitchCart:SetScript("OnMouseUp", function()
		if GVAR.OptionsFrame.CarrierSwitchFlag.isDisplay == "cart" then return end
		GVAR.OptionsFrame.CarrierSwitchCart.BG:SetSize(27,27)
		GVAR.OptionsFrame.CarrierSwitchCart.Texture:SetSize(30,30)
	end)
	GVAR.OptionsFrame.CarrierSwitchCart:SetScript("OnClick", function()
		if GVAR.OptionsFrame.CarrierSwitchFlag.isDisplay == "cart" then return end
		testData.CarrierDisplay = "cart"
		GVAR.OptionsFrame.CarrierSwitchFlag.isDisplay = "cart"
		GVAR.OptionsFrame.CarrierSwitchFlag.BG:SetColorTexture(0, 0, 0, 1)
		GVAR.OptionsFrame.CarrierSwitchOrb.BG:SetColorTexture(0, 0, 0, 1)
		GVAR.OptionsFrame.CarrierSwitchCart.BG:SetColorTexture(0.12, 0.12, 0.12, 1)
		BattlegroundTargets:EnableConfigMode()
	end)
	-- cart

	if testData.CarrierDisplay == "flag" then
		GVAR.OptionsFrame.CarrierSwitchFlag.isDisplay = "flag"
		GVAR.OptionsFrame.CarrierSwitchFlag.BG:SetColorTexture(0.12, 0.12, 0.12, 1)
		GVAR.OptionsFrame.CarrierSwitchOrb.BG:SetColorTexture(0, 0, 0, 1)
		GVAR.OptionsFrame.CarrierSwitchCart.BG:SetColorTexture(0, 0, 0, 1)
	elseif testData.CarrierDisplay == "orb" then
		GVAR.OptionsFrame.CarrierSwitchFlag.isDisplay = "orb"
		GVAR.OptionsFrame.CarrierSwitchFlag.BG:SetColorTexture(0, 0, 0, 1)
		GVAR.OptionsFrame.CarrierSwitchOrb.BG:SetColorTexture(0.12, 0.12, 0.12, 1)
		GVAR.OptionsFrame.CarrierSwitchCart.BG:SetColorTexture(0, 0, 0, 1)
	elseif testData.CarrierDisplay == "cart" then
		GVAR.OptionsFrame.CarrierSwitchFlag.isDisplay = "cart"
		GVAR.OptionsFrame.CarrierSwitchFlag.BG:SetColorTexture(0, 0, 0, 1)
		GVAR.OptionsFrame.CarrierSwitchOrb.BG:SetColorTexture(0, 0, 0, 1)
		GVAR.OptionsFrame.CarrierSwitchCart.BG:SetColorTexture(0.12, 0.12, 0.12, 1)
	end

	GVAR.OptionsFrame.CarrierSwitchEnableFunc = function()
		GVAR.OptionsFrame.CarrierSwitchFlag:EnableMouse(true)
		GVAR.OptionsFrame.CarrierSwitchOrb:EnableMouse(true)
		GVAR.OptionsFrame.CarrierSwitchCart:EnableMouse(true)
		GVAR.OptionsFrame.CarrierSwitchFlag:Enable()
		GVAR.OptionsFrame.CarrierSwitchOrb:Enable()
		GVAR.OptionsFrame.CarrierSwitchCart:Enable()
		Desaturation(GVAR.OptionsFrame.CarrierSwitchFlag.Texture, false)
		Desaturation(GVAR.OptionsFrame.CarrierSwitchOrb.Texture, false)
		Desaturation(GVAR.OptionsFrame.CarrierSwitchCart.Texture, false)
		if testData.CarrierDisplay == "flag" then
			GVAR.OptionsFrame.CarrierSwitchFlag.BG:SetColorTexture(0.12, 0.12, 0.12, 1)
			GVAR.OptionsFrame.CarrierSwitchOrb.BG:SetColorTexture(0, 0, 0, 1)
			GVAR.OptionsFrame.CarrierSwitchCart.BG:SetColorTexture(0, 0, 0, 1)
		elseif testData.CarrierDisplay == "orb" then
			GVAR.OptionsFrame.CarrierSwitchFlag.BG:SetColorTexture(0, 0, 0, 1)
			GVAR.OptionsFrame.CarrierSwitchOrb.BG:SetColorTexture(0.12, 0.12, 0.12, 1)
			GVAR.OptionsFrame.CarrierSwitchCart.BG:SetColorTexture(0, 0, 0, 1)
		elseif testData.CarrierDisplay == "cart" then
			GVAR.OptionsFrame.CarrierSwitchFlag.BG:SetColorTexture(0, 0, 0, 1)
			GVAR.OptionsFrame.CarrierSwitchOrb.BG:SetColorTexture(0, 0, 0, 1)
			GVAR.OptionsFrame.CarrierSwitchCart.BG:SetColorTexture(0.12, 0.12, 0.12, 1)
		end
	end

	GVAR.OptionsFrame.CarrierSwitchDisableFunc = function()
		GVAR.OptionsFrame.CarrierSwitchFlag:EnableMouse(false)
		GVAR.OptionsFrame.CarrierSwitchOrb:EnableMouse(false)
		GVAR.OptionsFrame.CarrierSwitchCart:EnableMouse(false)
		GVAR.OptionsFrame.CarrierSwitchFlag:Disable()
		GVAR.OptionsFrame.CarrierSwitchOrb:Disable()
		GVAR.OptionsFrame.CarrierSwitchCart:Disable()
		Desaturation(GVAR.OptionsFrame.CarrierSwitchFlag.Texture, true)
		Desaturation(GVAR.OptionsFrame.CarrierSwitchOrb.Texture, true)
		Desaturation(GVAR.OptionsFrame.CarrierSwitchCart.Texture, true)
		GVAR.OptionsFrame.CarrierSwitchFlag.BG:SetColorTexture(0, 0, 0, 1)
		GVAR.OptionsFrame.CarrierSwitchOrb.BG:SetColorTexture(0, 0, 0, 1)
		GVAR.OptionsFrame.CarrierSwitchCart.BG:SetColorTexture(0, 0, 0, 1)
	end

	local iw = GVAR.OptionsFrame.ShowFlag:GetWidth() + 32 + 32 + 32
	if iw > equalTextWidthIcons then
		equalTextWidthIcons = iw
	end

	-- flag scale
	GVAR.OptionsFrame.FlagScaleSlider = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.FlagScaleSliderText = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	TEMPLATE.Slider(GVAR.OptionsFrame.FlagScaleSlider, 85, 10, 100, 200, BattlegroundTargets_Options[fraction].ButtonFlagScale[currentSize]*100,
	function(self, value)
		local nvalue = value/100
		if nvalue == BattlegroundTargets_Options[fraction].ButtonFlagScale[currentSize] then return end
		BattlegroundTargets_Options[fraction].ButtonFlagScale[currentSize] = nvalue
		GVAR.OptionsFrame.FlagScaleSliderText:SetText(value.."%")
		BattlegroundTargets:EnableConfigMode()
	end,
	"blank")
	GVAR.OptionsFrame.FlagScaleSlider:SetPoint("LEFT", GVAR.OptionsFrame.ShowFlag, "RIGHT", 10, 0)
	GVAR.OptionsFrame.FlagScaleSliderText:SetHeight(20)
	GVAR.OptionsFrame.FlagScaleSliderText:SetPoint("LEFT", GVAR.OptionsFrame.FlagScaleSlider, "RIGHT", 5, 0)
	GVAR.OptionsFrame.FlagScaleSliderText:SetJustifyH("LEFT")
	GVAR.OptionsFrame.FlagScaleSliderText:SetText((BattlegroundTargets_Options[fraction].ButtonFlagScale[currentSize]*100).."%")
	GVAR.OptionsFrame.FlagScaleSliderText:SetTextColor(1, 1, 0.49, 1)

	-- flag position
	GVAR.OptionsFrame.FlagPositionSlider = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.FlagPositionSliderText = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	TEMPLATE.Slider(GVAR.OptionsFrame.FlagPositionSlider, 85, 5, 0, 100, BattlegroundTargets_Options[fraction].ButtonFlagPosition[currentSize],
	function(self, value)
		if value == BattlegroundTargets_Options[fraction].ButtonFlagPosition[currentSize] then return end
		BattlegroundTargets_Options[fraction].ButtonFlagPosition[currentSize] = value
		GVAR.OptionsFrame.FlagPositionSliderText:SetText(value)
		BattlegroundTargets:EnableConfigMode()
	end,
	"blank")
	GVAR.OptionsFrame.FlagPositionSlider:SetPoint("LEFT", GVAR.OptionsFrame.FlagScaleSlider, "RIGHT", 50, 0)
	GVAR.OptionsFrame.FlagPositionSliderText:SetHeight(20)
	GVAR.OptionsFrame.FlagPositionSliderText:SetPoint("LEFT", GVAR.OptionsFrame.FlagPositionSlider, "RIGHT", 5, 0)
	GVAR.OptionsFrame.FlagPositionSliderText:SetJustifyH("LEFT")
	GVAR.OptionsFrame.FlagPositionSliderText:SetText(BattlegroundTargets_Options[fraction].ButtonFlagPosition[currentSize])
	GVAR.OptionsFrame.FlagPositionSliderText:SetTextColor(1, 1, 0.49, 1)

	-- show assist
	GVAR.OptionsFrame.ShowAssist = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.ShowAssist, 16, 4, L["Main Assist Target"])
	GVAR.OptionsFrame.ShowAssist:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.ShowAssist:SetPoint("TOP", GVAR.OptionsFrame.ShowFlag, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.ShowAssist:SetChecked(BattlegroundTargets_Options[fraction].ButtonAssistToggle[currentSize])
	TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.ShowAssist)
	GVAR.OptionsFrame.ShowAssist:SetScript("OnClick", function()
		BattlegroundTargets_Options[fraction].ButtonAssistToggle[currentSize] = not BattlegroundTargets_Options[fraction].ButtonAssistToggle[currentSize]
		if BattlegroundTargets_Options[fraction].ButtonAssistToggle[currentSize] then
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.AssistScaleSlider)
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.AssistPositionSlider)
		else
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.AssistScaleSlider)
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.AssistPositionSlider)
		end
		BattlegroundTargets:EnableConfigMode()
	end)
	local iw = GVAR.OptionsFrame.ShowAssist:GetWidth()
	if iw > equalTextWidthIcons then
		equalTextWidthIcons = iw
	end

	-- assist scale
	GVAR.OptionsFrame.AssistScaleSlider = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.AssistScaleSliderText = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	TEMPLATE.Slider(GVAR.OptionsFrame.AssistScaleSlider, 85, 10, 100, 200, BattlegroundTargets_Options[fraction].ButtonAssistScale[currentSize]*100,
	function(self, value)
		local nvalue = value/100
		if nvalue == BattlegroundTargets_Options[fraction].ButtonAssistScale[currentSize] then return end
		BattlegroundTargets_Options[fraction].ButtonAssistScale[currentSize] = nvalue
		GVAR.OptionsFrame.AssistScaleSliderText:SetText(value.."%")
		BattlegroundTargets:EnableConfigMode()
	end,
	"blank")
	GVAR.OptionsFrame.AssistScaleSlider:SetPoint("LEFT", GVAR.OptionsFrame.ShowAssist, "RIGHT", 10, 0)
	GVAR.OptionsFrame.AssistScaleSliderText:SetHeight(20)
	GVAR.OptionsFrame.AssistScaleSliderText:SetPoint("LEFT", GVAR.OptionsFrame.AssistScaleSlider, "RIGHT", 5, 0)
	GVAR.OptionsFrame.AssistScaleSliderText:SetJustifyH("LEFT")
	GVAR.OptionsFrame.AssistScaleSliderText:SetText((BattlegroundTargets_Options[fraction].ButtonAssistScale[currentSize]*100).."%")
	GVAR.OptionsFrame.AssistScaleSliderText:SetTextColor(1, 1, 0.49, 1)

	-- assist position
	GVAR.OptionsFrame.AssistPositionSlider = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.AssistPositionSliderText = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	TEMPLATE.Slider(GVAR.OptionsFrame.AssistPositionSlider, 85, 5, 0, 100, BattlegroundTargets_Options[fraction].ButtonAssistPosition[currentSize],
	function(self, value)
		if value == BattlegroundTargets_Options[fraction].ButtonAssistPosition[currentSize] then return end
		BattlegroundTargets_Options[fraction].ButtonAssistPosition[currentSize] = value
		GVAR.OptionsFrame.AssistPositionSliderText:SetText(value)
		BattlegroundTargets:EnableConfigMode()
	end,
	"blank")
	GVAR.OptionsFrame.AssistPositionSlider:SetPoint("LEFT", GVAR.OptionsFrame.AssistScaleSlider, "RIGHT", 50, 0)
	GVAR.OptionsFrame.AssistPositionSliderText:SetHeight(20)
	GVAR.OptionsFrame.AssistPositionSliderText:SetPoint("LEFT", GVAR.OptionsFrame.AssistPositionSlider, "RIGHT", 5, 0)
	GVAR.OptionsFrame.AssistPositionSliderText:SetJustifyH("LEFT")
	GVAR.OptionsFrame.AssistPositionSliderText:SetText(BattlegroundTargets_Options[fraction].ButtonAssistPosition[currentSize])
	GVAR.OptionsFrame.AssistPositionSliderText:SetTextColor(1, 1, 0.49, 1)


	GVAR.OptionsFrame.TargetScaleSlider:SetPoint("LEFT", GVAR.OptionsFrame.ShowTargetIndicator, "LEFT", equalTextWidthIcons+10, 0)
	GVAR.OptionsFrame.ToTScaleSlider:SetPoint("LEFT", GVAR.OptionsFrame.TargetofTarget, "LEFT", equalTextWidthIcons+10, 0)
	GVAR.OptionsFrame.FocusScaleSlider:SetPoint("LEFT", GVAR.OptionsFrame.ShowFocusIndicator, "LEFT", equalTextWidthIcons+10, 0)
	GVAR.OptionsFrame.FlagScaleSlider:SetPoint("LEFT", GVAR.OptionsFrame.ShowFlag, "LEFT", equalTextWidthIcons+10, 0)
	GVAR.OptionsFrame.AssistScaleSlider:SetPoint("LEFT", GVAR.OptionsFrame.ShowAssist, "LEFT", equalTextWidthIcons+10, 0)
	local iconW = 10 + equalTextWidthIcons + 10 + GVAR.OptionsFrame.TargetScaleSlider:GetWidth() + 50 + GVAR.OptionsFrame.TargetPositionSlider:GetWidth() + 50
	-- ----- icons ----------------------------------------



	-- DUMMY
	GVAR.OptionsFrame.Dummy6 = GVAR.OptionsFrame.ConfigBrackets:CreateTexture(nil, "ARTWORK")
	-- BOOM GVAR.OptionsFrame.Dummy6:SetWidth()
	GVAR.OptionsFrame.Dummy6:SetHeight(1)
	GVAR.OptionsFrame.Dummy6:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.Dummy6:SetPoint("TOP", GVAR.OptionsFrame.ShowAssist, "BOTTOM", 0, -8)
	GVAR.OptionsFrame.Dummy6:SetColorTexture(0.73, 0.26, 0.21, 0.5)



	-- health bar
	GVAR.OptionsFrame.ShowHealthBar = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.ShowHealthBar, 16, 4, L["Health Bar"])
	GVAR.OptionsFrame.ShowHealthBar:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.ShowHealthBar:SetPoint("TOP", GVAR.OptionsFrame.Dummy6, "BOTTOM", 0, -8)
	GVAR.OptionsFrame.ShowHealthBar:SetChecked(BattlegroundTargets_Options[fraction].ButtonHealthBarToggle[currentSize])
	GVAR.OptionsFrame.ShowHealthBar:SetScript("OnClick", function()
		BattlegroundTargets_Options[fraction].ButtonHealthBarToggle[currentSize] = not BattlegroundTargets_Options[fraction].ButtonHealthBarToggle[currentSize]
		GVAR.OptionsFrame.ShowHealthBar:SetChecked(BattlegroundTargets_Options[fraction].ButtonHealthBarToggle[currentSize])
		BattlegroundTargets:EnableConfigMode()
	end)

	-- health percent
	GVAR.OptionsFrame.ShowHealthText = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.ShowHealthText, 16, 4, L["Percent"])
	GVAR.OptionsFrame.ShowHealthText:SetPoint("LEFT", GVAR.OptionsFrame.ShowHealthBar.Text, "RIGHT", 20, 0)
	GVAR.OptionsFrame.ShowHealthText:SetChecked(BattlegroundTargets_Options[fraction].ButtonHealthTextToggle[currentSize])
	GVAR.OptionsFrame.ShowHealthText:SetScript("OnClick", function()
		BattlegroundTargets_Options[fraction].ButtonHealthTextToggle[currentSize] = not BattlegroundTargets_Options[fraction].ButtonHealthTextToggle[currentSize]
		GVAR.OptionsFrame.ShowHealthText:SetChecked(BattlegroundTargets_Options[fraction].ButtonHealthTextToggle[currentSize])
		ConfigFontNumberOptionCheck(currentSize)
		BattlegroundTargets:EnableConfigMode()
	end)



	-- ----- range check ----------------------------------------
	local rangeW = 0
	-- range check
	GVAR.OptionsFrame.RangeCheck = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.RangeCheck, 16, 4, L["Range"])
	GVAR.OptionsFrame.RangeCheck:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.RangeCheck:SetPoint("TOP", GVAR.OptionsFrame.ShowHealthBar, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.RangeCheck:SetChecked(BattlegroundTargets_Options[fraction].ButtonRangeToggle[currentSize])
	GVAR.OptionsFrame.RangeCheck:SetScript("OnClick", function()
		BattlegroundTargets_Options[fraction].ButtonRangeToggle[currentSize] = not BattlegroundTargets_Options[fraction].ButtonRangeToggle[currentSize]
		GVAR.OptionsFrame.RangeCheck:SetChecked(BattlegroundTargets_Options[fraction].ButtonRangeToggle[currentSize])
		if BattlegroundTargets_Options[fraction].ButtonRangeToggle[currentSize] then
			GVAR.OptionsFrame.RangeCheckInfo:Enable() Desaturation(GVAR.OptionsFrame.RangeCheckInfo.Texture, false)
			TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.RangeDisplayPullDown)
		else
			GVAR.OptionsFrame.RangeCheckInfo:Disable() Desaturation(GVAR.OptionsFrame.RangeCheckInfo.Texture, true)
			TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.RangeDisplayPullDown)
		end
		BattlegroundTargets:EnableConfigMode()
	end)
	rangeW = rangeW + 10 + GVAR.OptionsFrame.RangeCheck:GetWidth()

	-- range check info
	GVAR.OptionsFrame.RangeCheckInfo = CreateFrame("Button", nil, GVAR.OptionsFrame.ConfigBrackets)
	GVAR.OptionsFrame.RangeCheckInfo:SetWidth(16)
	GVAR.OptionsFrame.RangeCheckInfo:SetHeight(16)
	GVAR.OptionsFrame.RangeCheckInfo:SetPoint("LEFT", GVAR.OptionsFrame.RangeCheck, "RIGHT", 10, 0)
	GVAR.OptionsFrame.RangeCheckInfo.Texture = GVAR.OptionsFrame.RangeCheckInfo:CreateTexture(nil, "ARTWORK")
	GVAR.OptionsFrame.RangeCheckInfo.Texture:SetWidth(16)
	GVAR.OptionsFrame.RangeCheckInfo.Texture:SetHeight(16)
	GVAR.OptionsFrame.RangeCheckInfo.Texture:SetPoint("LEFT", 0, 0)
	GVAR.OptionsFrame.RangeCheckInfo.Texture:SetTexture("Interface\\FriendsFrame\\InformationIcon")
	GVAR.OptionsFrame.RangeCheckInfo.TextFrame = CreateFrame("Frame", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.BorderTRBL(GVAR.OptionsFrame.RangeCheckInfo.TextFrame)
	GVAR.OptionsFrame.RangeCheckInfo.TextFrame:SetToplevel(true)
	GVAR.OptionsFrame.RangeCheckInfo.TextFrame:SetPoint("BOTTOM", GVAR.OptionsFrame.RangeCheckInfo.Texture, "TOP", 0, 0)
	GVAR.OptionsFrame.RangeCheckInfo.TextFrame:Hide()
	GVAR.OptionsFrame.RangeCheckInfo.Text = GVAR.OptionsFrame.RangeCheckInfo.TextFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.RangeCheckInfo.Text:SetPoint("CENTER", 0, 0)
	GVAR.OptionsFrame.RangeCheckInfo.Text:SetJustifyH("LEFT")
	BattlegroundTargets:RangeInfoText( GVAR.OptionsFrame.RangeCheckInfo.Text ) --GVAR.OptionsFrame.RangeCheckInfo.Text:SetText()
	GVAR.OptionsFrame.RangeCheckInfo.Text:SetTextColor(1, 1, 0.49, 1)
	GVAR.OptionsFrame.RangeCheckInfo:SetScript("OnEnter", function()
		local txtWidth = GVAR.OptionsFrame.RangeCheckInfo.Text:GetStringWidth()
		local txtHeight = GVAR.OptionsFrame.RangeCheckInfo.Text:GetStringHeight()
		GVAR.OptionsFrame.RangeCheckInfo.Text:SetWidth(txtWidth+10)
		GVAR.OptionsFrame.RangeCheckInfo.Text:SetHeight(txtHeight+10)
		GVAR.OptionsFrame.RangeCheckInfo.TextFrame:SetWidth(txtWidth+30)
		GVAR.OptionsFrame.RangeCheckInfo.TextFrame:SetHeight(txtHeight+30)
		GVAR.OptionsFrame.RangeCheckInfo.TextFrame:Show()
	end)
	GVAR.OptionsFrame.RangeCheckInfo:SetScript("OnLeave", function()
		GVAR.OptionsFrame.RangeCheckInfo.TextFrame:Hide()
	end)
	rangeW = rangeW + 10 + 16

	-- range alpha
	GVAR.OptionsFrame.RangeDisplayPullDown = CreateFrame("Button", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.PullDownMenu(
		GVAR.OptionsFrame.RangeDisplayPullDown,
		rangeDisplay,
		rangeDisplay[ BattlegroundTargets_Options[fraction].ButtonRangeDisplay[currentSize] ],
		0,
		function(value) -- PDFUNC
			BattlegroundTargets_Options[fraction].ButtonRangeDisplay[currentSize] = value
			BattlegroundTargets:EnableConfigMode()
		end,
		function(self, button) -- TODO check - potential bug port
			GVAR.OptionsFrame.RangeDisplayPullDown.spookval = BattlegroundTargets_Options[fraction].ButtonRangeDisplay[currentSize]
			BattlegroundTargets_Options[fraction].ButtonRangeDisplay[currentSize] = self.value1
			BattlegroundTargets:EnableConfigMode()
		end,
		function(self, button) -- TODO check - potential bug port
			BattlegroundTargets_Options[fraction].ButtonRangeDisplay[currentSize] = GVAR.OptionsFrame.RangeDisplayPullDown.spookval or self.value1
			BattlegroundTargets:EnableConfigMode()
		end
	)
	GVAR.OptionsFrame.RangeDisplayPullDown:SetPoint("LEFT", GVAR.OptionsFrame.RangeCheckInfo, "RIGHT", 10, 0)
	GVAR.OptionsFrame.RangeDisplayPullDown:SetHeight(18)
	TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.RangeDisplayPullDown)
	rangeW = rangeW + 10 + GVAR.OptionsFrame.RangeDisplayPullDown:GetWidth() + 10
	-- ----- range check ----------------------------------------



	-- DUMMY
	GVAR.OptionsFrame.Dummy7 = GVAR.OptionsFrame.ConfigBrackets:CreateTexture(nil, "ARTWORK")
	-- BOOM GVAR.OptionsFrame.Dummy7:SetWidth()
	GVAR.OptionsFrame.Dummy7:SetHeight(1)
	GVAR.OptionsFrame.Dummy7:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.Dummy7:SetPoint("TOP", GVAR.OptionsFrame.RangeCheck, "BOTTOM", 0, -8)
	GVAR.OptionsFrame.Dummy7:SetColorTexture(0.73, 0.26, 0.21, 0.5)



	-- font name
	GVAR.OptionsFrame.FontNameTitle = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.FontNameTitle:SetHeight(16)
	GVAR.OptionsFrame.FontNameTitle:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.FontNameTitle:SetPoint("TOP", GVAR.OptionsFrame.Dummy7, "BOTTOM", 0, -8)
	GVAR.OptionsFrame.FontNameTitle:SetJustifyH("LEFT")
	GVAR.OptionsFrame.FontNameTitle:SetText(L["Text"]..": "..L["Name"])
	GVAR.OptionsFrame.FontNameTitle:SetTextColor(1, 1, 1, 1)
	GVAR.OptionsFrame.FontNameTitle.Background = GVAR.OptionsFrame.ConfigBrackets:CreateTexture(nil, "BACKGROUND")
	GVAR.OptionsFrame.FontNameTitle.Background:SetPoint("TOPLEFT", GVAR.OptionsFrame.FontNameTitle, "TOPLEFT", 0, 0)
	GVAR.OptionsFrame.FontNameTitle.Background:SetPoint("BOTTOMRIGHT", GVAR.OptionsFrame.FontNameTitle, "BOTTOMRIGHT", 0, 0)
	GVAR.OptionsFrame.FontNameTitle.Background:SetColorTexture(0, 0, 0, 0)

	-- font name size
	GVAR.OptionsFrame.FontNameSlider = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.Slider(GVAR.OptionsFrame.FontNameSlider, 80, 1, 5, 20, BattlegroundTargets_Options[fraction].ButtonFontNameSize[currentSize],
	function(self, value)
		if value == BattlegroundTargets_Options[fraction].ButtonFontNameSize[currentSize] then return end
		BattlegroundTargets_Options[fraction].ButtonFontNameSize[currentSize] = value
		GVAR.OptionsFrame.FontNameValue:SetText(value)
		BattlegroundTargets:EnableConfigMode()
	end,
	"blank")
	GVAR.OptionsFrame.FontNameSlider:SetPoint("LEFT", GVAR.OptionsFrame.FontNameTitle, "RIGHT", 10, 0)

	GVAR.OptionsFrame.FontNameValue = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.FontNameValue:SetHeight(20)
	GVAR.OptionsFrame.FontNameValue:SetPoint("LEFT", GVAR.OptionsFrame.FontNameSlider, "RIGHT", 5, 0)
	GVAR.OptionsFrame.FontNameValue:SetJustifyH("LEFT")
	GVAR.OptionsFrame.FontNameValue:SetText(BattlegroundTargets_Options[fraction].ButtonFontNameSize[currentSize])
	GVAR.OptionsFrame.FontNameValue:SetTextColor(1, 1, 0.49, 1)

	-- font name style
	GVAR.OptionsFrame.FontNamePullDown = CreateFrame("Button", nil, GVAR.OptionsFrame.ConfigBrackets)
	local fontStylesDB = {}
	for i = 1, #fontStyles do tinsert(fontStylesDB, fontStyles[i].name) end
	TEMPLATE.PullDownMenu(
		GVAR.OptionsFrame.FontNamePullDown,
		fontStylesDB,
		fontStyles[ BattlegroundTargets_Options[fraction].ButtonFontNameStyle[currentSize] ].name,
		0,
		function(value) -- PDFUNC
			BattlegroundTargets_Options[fraction].ButtonFontNameStyle[currentSize] = value
			BattlegroundTargets:EnableConfigMode()
		end,
		function(self, button)
			BattlegroundTargets:LocalizedFontNameTest(true, self.value1)
		end,
		function(self, button)
			BattlegroundTargets:LocalizedFontNameTest(false, true)
		end
	)
	GVAR.OptionsFrame.FontNamePullDown:SetPoint("LEFT", GVAR.OptionsFrame.FontNameSlider, "RIGHT", 30, 0)
	GVAR.OptionsFrame.FontNamePullDown:SetHeight(18)
	TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.FontNamePullDown)

	GVAR.OptionsFrame.FontNameInfo = GVAR.OptionsFrame.FontNamePullDown.PullDownMenu:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.FontNameInfo:SetHeight(16)
	GVAR.OptionsFrame.FontNameInfo:SetPoint("TOP", GVAR.OptionsFrame.FontNamePullDown.PullDownMenu, "BOTTOM", 0, -2)
	GVAR.OptionsFrame.FontNameInfo:SetJustifyH("CENTER")
	GVAR.OptionsFrame.FontNameInfo:SetText(CTRL_KEY_TEXT.." "..SHIFT_KEY_TEXT.." "..ALT_KEY)
	GVAR.OptionsFrame.FontNameInfo:SetTextColor(0.5, 0.5, 0.5, 1)

	GVAR.OptionsFrame.FontNamePullDown.PullDownMenu:SetPropagateKeyboardInput(true)
	GVAR.OptionsFrame.FontNamePullDown.PullDownMenu:SetScript("OnKeyDown", function(self, key)
		if key == "LSHIFT" or key == "RSHIFT" or key == "LCTRL" or key == "RCTRL" or key == "LALT" or key == "RALT" then
			GVAR.OptionsFrame.FontNamePullDown.PullDownMenu:SetPropagateKeyboardInput(false)
			BattlegroundTargets:LocalizedFontNameTest(false, false)
		end
	end)
	GVAR.OptionsFrame.FontNamePullDown.PullDownMenu:SetScript("OnKeyUp", function(self, key)
		GVAR.OptionsFrame.FontNamePullDown.PullDownMenu:SetPropagateKeyboardInput(true)
		BattlegroundTargets:LocalizedFontNameTest(true, false)
	end)

	local oldOnEnter = GVAR.OptionsFrame.FontNamePullDown:GetScript("OnEnter")
	local oldOnLeave = GVAR.OptionsFrame.FontNamePullDown:GetScript("OnLeave")
	GVAR.OptionsFrame.FontNamePullDown:SetScript("OnEnter", function(self)
		BattlegroundTargets:LocalizedFontNameTest(true)
		if oldOnEnter then oldOnEnter() end
	end)
	GVAR.OptionsFrame.FontNamePullDown:SetScript("OnLeave", function(self)
		BattlegroundTargets:LocalizedFontNameTest(false, true)
		if oldOnLeave then oldOnLeave() end
	end)
	local oldOnEnter = GVAR.OptionsFrame.FontNamePullDown.PullDownMenu:GetScript("OnEnter")
	local oldOnLeave = GVAR.OptionsFrame.FontNamePullDown.PullDownMenu:GetScript("OnLeave")
	GVAR.OptionsFrame.FontNamePullDown.PullDownMenu:SetScript("OnEnter", function(self)
		BattlegroundTargets:LocalizedFontNameTest(true)
		if oldOnEnter then oldOnEnter() end
	end)
	GVAR.OptionsFrame.FontNamePullDown.PullDownMenu:SetScript("OnLeave", function(self)
		BattlegroundTargets:LocalizedFontNameTest(false, true)
		if oldOnLeave then oldOnLeave() end
	end)

	-- font number
	GVAR.OptionsFrame.FontNumberTitle = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.FontNumberTitle:SetHeight(16)
	GVAR.OptionsFrame.FontNumberTitle:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.FontNumberTitle:SetPoint("TOP", GVAR.OptionsFrame.FontNameSlider, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.FontNumberTitle:SetJustifyH("LEFT")
	GVAR.OptionsFrame.FontNumberTitle:SetText(L["Text"]..": "..L["Number"])
	GVAR.OptionsFrame.FontNumberTitle:SetTextColor(1, 1, 1, 1)
	GVAR.OptionsFrame.FontNumberTitle.Background = GVAR.OptionsFrame.ConfigBrackets:CreateTexture(nil, "BACKGROUND")
	GVAR.OptionsFrame.FontNumberTitle.Background:SetPoint("TOPLEFT", GVAR.OptionsFrame.FontNumberTitle, "TOPLEFT", 0, 0)
	GVAR.OptionsFrame.FontNumberTitle.Background:SetPoint("BOTTOMRIGHT", GVAR.OptionsFrame.FontNumberTitle, "BOTTOMRIGHT", 0, 0)
	GVAR.OptionsFrame.FontNumberTitle.Background:SetColorTexture(0, 0, 0, 0)

	-- font number size
	GVAR.OptionsFrame.FontNumberSlider = CreateFrame("Slider", nil, GVAR.OptionsFrame.ConfigBrackets)
	TEMPLATE.Slider(GVAR.OptionsFrame.FontNumberSlider, 80, 1, 5, 20, BattlegroundTargets_Options[fraction].ButtonFontNumberSize[currentSize],
	function(self, value)
		if value == BattlegroundTargets_Options[fraction].ButtonFontNumberSize[currentSize] then return end
		BattlegroundTargets_Options[fraction].ButtonFontNumberSize[currentSize] = value
		GVAR.OptionsFrame.FontNumberValue:SetText(value)
		BattlegroundTargets:EnableConfigMode()
	end,
	"blank")
	GVAR.OptionsFrame.FontNumberSlider:SetPoint("LEFT", GVAR.OptionsFrame.FontNumberTitle, "RIGHT", 10, 0)

	GVAR.OptionsFrame.FontNumberValue = GVAR.OptionsFrame.ConfigBrackets:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.FontNumberValue:SetHeight(20)
	GVAR.OptionsFrame.FontNumberValue:SetPoint("LEFT", GVAR.OptionsFrame.FontNumberSlider, "RIGHT", 5, 0)
	GVAR.OptionsFrame.FontNumberValue:SetJustifyH("LEFT")
	GVAR.OptionsFrame.FontNumberValue:SetText(BattlegroundTargets_Options[fraction].ButtonFontNumberSize[currentSize])
	GVAR.OptionsFrame.FontNumberValue:SetTextColor(1, 1, 0.49, 1)

	-- font number style
	GVAR.OptionsFrame.FontNumberPullDown = CreateFrame("Button", nil, GVAR.OptionsFrame.ConfigBrackets)
	local fontStylesNumberDB = {}
	for i = 1, #fontStyles do tinsert(fontStylesNumberDB, strmatch(fontStyles[i].name, "(.*) %- .*")) end
	TEMPLATE.PullDownMenu(
		GVAR.OptionsFrame.FontNumberPullDown,
		fontStylesNumberDB,
		strmatch(fontStyles[ BattlegroundTargets_Options[fraction].ButtonFontNumberStyle[currentSize] ].name, "(.*) %- .*"),
		0,
		function(value) -- PDFUNC
			BattlegroundTargets_Options[fraction].ButtonFontNumberStyle[currentSize] = value
			BattlegroundTargets:EnableConfigMode()
		end,
		function(self, button)
			BattlegroundTargets:LocalizedFontNumberTest(true, self.value1)
		end,
		function(self, button)
			BattlegroundTargets:LocalizedFontNumberTest(false)
		end
	)
	GVAR.OptionsFrame.FontNumberPullDown:SetPoint("LEFT", GVAR.OptionsFrame.FontNumberSlider, "RIGHT", 30, 0)
	GVAR.OptionsFrame.FontNumberPullDown:SetHeight(18)
	TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.FontNumberPullDown)

	local oldOnLeave = GVAR.OptionsFrame.FontNumberPullDown:GetScript("OnLeave")
	GVAR.OptionsFrame.FontNumberPullDown:SetScript("OnLeave", function(self)
		BattlegroundTargets:LocalizedFontNumberTest(false)
		if oldOnLeave then oldOnLeave() end
	end)
	local oldOnLeave = GVAR.OptionsFrame.FontNumberPullDown.PullDownMenu:GetScript("OnLeave")
	GVAR.OptionsFrame.FontNumberPullDown.PullDownMenu:SetScript("OnLeave", function(self)
		BattlegroundTargets:LocalizedFontNumberTest(false)
		if oldOnLeave then oldOnLeave() end
	end)

	local eq, sw = 0, 0
	sw = GVAR.OptionsFrame.FontNameTitle:GetStringWidth() if sw > eq then eq = sw end
	sw = GVAR.OptionsFrame.FontNumberTitle:GetStringWidth() if sw > eq then eq = sw end
	GVAR.OptionsFrame.FontNameSlider:SetPoint("LEFT", GVAR.OptionsFrame.FontNameTitle, "LEFT", eq+10, 0)
	GVAR.OptionsFrame.FontNumberSlider:SetPoint("LEFT", GVAR.OptionsFrame.FontNumberTitle, "LEFT", eq+10, 0)

	local fontstyleW = 10+ eq+10 + GVAR.OptionsFrame.FontNameSlider:GetWidth() + 30 + GVAR.OptionsFrame.FontNamePullDown:GetWidth() + 10

	-- testshuffler
	GVAR.OptionsFrame.TestShuffler = CreateFrame("Button", nil, GVAR.OptionsFrame.ConfigBrackets)
	BattlegroundTargets.shuffleStyle = true
	GVAR.OptionsFrame.TestShuffler:SetPoint("BOTTOM", GVAR.OptionsFrame.Base, "BOTTOM", 0, 13)
	GVAR.OptionsFrame.TestShuffler:SetPoint("RIGHT", GVAR.OptionsFrame, "RIGHT", -10, 0)
	GVAR.OptionsFrame.TestShuffler:SetWidth(32)
	GVAR.OptionsFrame.TestShuffler:SetHeight(32)
	GVAR.OptionsFrame.TestShuffler:Hide()
	GVAR.OptionsFrame.TestShuffler:SetScript("OnClick", function() BattlegroundTargets:ShufflerFunc("OnClick") end)
	GVAR.OptionsFrame.TestShuffler:SetScript("OnEnter", function() BattlegroundTargets:ShufflerFunc("OnEnter") end)
	GVAR.OptionsFrame.TestShuffler:SetScript("OnLeave", function() BattlegroundTargets:ShufflerFunc("OnLeave") end)
	GVAR.OptionsFrame.TestShuffler:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" then BattlegroundTargets:ShufflerFunc("OnMouseDown") end
	end)
	GVAR.OptionsFrame.TestShuffler.Texture = GVAR.OptionsFrame.TestShuffler:CreateTexture(nil, "ARTWORK")
	GVAR.OptionsFrame.TestShuffler.Texture:SetWidth(32)
	GVAR.OptionsFrame.TestShuffler.Texture:SetHeight(32)
	GVAR.OptionsFrame.TestShuffler.Texture:SetPoint("CENTER", 0, 0)
	GVAR.OptionsFrame.TestShuffler.Texture:SetTexture("Interface\\Icons\\INV_Sigil_Thorim")
	GVAR.OptionsFrame.TestShuffler:SetNormalTexture(GVAR.OptionsFrame.TestShuffler.Texture)
	GVAR.OptionsFrame.TestShuffler.TextureHighlight = GVAR.OptionsFrame.TestShuffler:CreateTexture(nil, "OVERLAY")
	GVAR.OptionsFrame.TestShuffler.TextureHighlight:SetWidth(32)
	GVAR.OptionsFrame.TestShuffler.TextureHighlight:SetHeight(32)
	GVAR.OptionsFrame.TestShuffler.TextureHighlight:SetPoint("CENTER", 0, 0)
	GVAR.OptionsFrame.TestShuffler.TextureHighlight:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
	GVAR.OptionsFrame.TestShuffler:SetHighlightTexture(GVAR.OptionsFrame.TestShuffler.TextureHighlight)
	-- ###
	-- ####################################################################################################



	-- ####################################################################################################
	-- xMx ConfigGeneral
	GVAR.OptionsFrame.ConfigGeneral = CreateFrame("Frame", nil, GVAR.OptionsFrame)
	-- BOOM GVAR.OptionsFrame.ConfigGeneral:SetWidth()
	GVAR.OptionsFrame.ConfigGeneral:SetHeight(heightBracket)
	GVAR.OptionsFrame.ConfigGeneral:SetPoint("TOPLEFT", GVAR.OptionsFrame.Base, "BOTTOMLEFT", 0, 1)
	GVAR.OptionsFrame.ConfigGeneral:Hide()

	GVAR.OptionsFrame.GeneralTitle = GVAR.OptionsFrame.ConfigGeneral:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	GVAR.OptionsFrame.GeneralTitle:SetHeight(20)
	GVAR.OptionsFrame.GeneralTitle:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.GeneralTitle:SetPoint("TOPLEFT", GVAR.OptionsFrame.ConfigGeneral, "TOPLEFT", 10, -10)
	GVAR.OptionsFrame.GeneralTitle:SetJustifyH("LEFT")
	GVAR.OptionsFrame.GeneralTitle:SetText(L["General Settings"]..":")

	-- minimap button
	GVAR.OptionsFrame.Minimap = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigGeneral)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.Minimap, 16, 4, L["Show Minimap-Button"])
	GVAR.OptionsFrame.Minimap:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.Minimap:SetPoint("TOP", GVAR.OptionsFrame.GeneralTitle, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.Minimap:SetChecked(BattlegroundTargets_Options.MinimapButton)
	TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.Minimap)
	GVAR.OptionsFrame.Minimap:SetScript("OnClick", function()
		BattlegroundTargets_Options.MinimapButton = not BattlegroundTargets_Options.MinimapButton
		BattlegroundTargets:CreateMinimapButton()
	end)

	-- transliteration
	local tsarrow = "  |TInterface\\Tooltips\\ReforgeGreenArrow:8:0|t  "
	GVAR.OptionsFrame.TransLitOption = CreateFrame("CheckButton", nil, GVAR.OptionsFrame.ConfigGeneral)
	TEMPLATE.CheckButton(GVAR.OptionsFrame.TransLitOption, 16, 4, "Cyrillic" .. tsarrow .. "Latin - Transliteration")
	GVAR.OptionsFrame.TransLitOption:SetPoint("LEFT", GVAR.OptionsFrame, "LEFT", 10, 0)
	GVAR.OptionsFrame.TransLitOption:SetPoint("TOP", GVAR.OptionsFrame.Minimap, "BOTTOM", 0, -10)
	GVAR.OptionsFrame.TransLitOption:SetChecked(BattlegroundTargets_Options.TransliterationToggle)
	TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.TransLitOption)
	GVAR.OptionsFrame.TransLitOption:SetScript("OnClick", function()
		BattlegroundTargets_Options.TransliterationToggle = not BattlegroundTargets_Options.TransliterationToggle
		if BattlegroundTargets_Options.TransliterationToggle then
			GVAR.OptionsFrame.TransLitOptionInfoText:SetTextColor(1, 1, 1, 1)
		else
			GVAR.OptionsFrame.TransLitOptionInfoText:SetTextColor(0.5, 0.5, 0.5, 1)
		end
	end)
	GVAR.OptionsFrame.TransLitOptionInfoText = GVAR.OptionsFrame.ConfigGeneral:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	GVAR.OptionsFrame.TransLitOptionInfoText:SetPoint("TOPLEFT", GVAR.OptionsFrame.TransLitOption, "BOTTOMLEFT", 30, -10)
	GVAR.OptionsFrame.TransLitOptionInfoText:SetJustifyH("LEFT")
	GVAR.OptionsFrame.TransLitOptionInfoText:SetFont(fontStyles[12].font, 12, "")
	GVAR.OptionsFrame.TransLitOptionInfoText:SetShadowOffset(0, 0)
	GVAR.OptionsFrame.TransLitOptionInfoText:SetShadowColor(0, 0, 0, 0)
	if BattlegroundTargets_Options.TransliterationToggle then
		GVAR.OptionsFrame.TransLitOptionInfoText:SetTextColor(1, 1, 1, 1)
	else
		GVAR.OptionsFrame.TransLitOptionInfoText:SetTextColor(0.5, 0.5, 0.5, 1)
	end
	GVAR.OptionsFrame.TransLitOptionInfoText:SetText(
		L["ruRU_transliteration_test1"] .. tsarrow .. utf8replace(L["ruRU_transliteration_test1"], TSL) .. "\n" ..
		L["ruRU_transliteration_test2"] .. tsarrow .. utf8replace(L["ruRU_transliteration_test2"], TSL) .. "\n" ..
		L["ruRU_transliteration_test3"] .. tsarrow .. utf8replace(L["ruRU_transliteration_test3"], TSL) .. "\n" ..
		L["ruRU_transliteration_test4"] .. tsarrow .. utf8replace(L["ruRU_transliteration_test4"], TSL) .. "\n" ..
		L["ruRU_transliteration_test5"] .. tsarrow .. utf8replace(L["ruRU_transliteration_test5"], TSL))
	-- ###
	-- ####################################################################################################



	-- ####################################################################################################
	-- xMx Mover
	GVAR.OptionsFrame.MoverTop = CreateFrame("Frame", nil, GVAR.OptionsFrame)
	TEMPLATE.BorderTRBL(GVAR.OptionsFrame.MoverTop)
	-- BOOM GVAR.OptionsFrame.MoverTop:SetWidth()
	GVAR.OptionsFrame.MoverTop:SetHeight(20)
	GVAR.OptionsFrame.MoverTop:SetPoint("BOTTOM", GVAR.OptionsFrame, "TOP", 0, -1)
	GVAR.OptionsFrame.MoverTop:EnableMouse(true)
	GVAR.OptionsFrame.MoverTop:EnableMouseWheel(true)
	GVAR.OptionsFrame.MoverTop:SetScript("OnMouseWheel", NOOP)
	GVAR.OptionsFrame.MoverTopText = GVAR.OptionsFrame.MoverTop:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.MoverTopText:SetPoint("CENTER", GVAR.OptionsFrame.MoverTop, "CENTER", 0, 0)
	GVAR.OptionsFrame.MoverTopText:SetJustifyH("CENTER")
	GVAR.OptionsFrame.MoverTopText:SetTextColor(0.5, 0.5, 0.5, 1)
	GVAR.OptionsFrame.MoverTopText:SetText(L["click & move"])

	GVAR.OptionsFrame.Close = CreateFrame("Button", nil, GVAR.OptionsFrame.MoverTop)
	TEMPLATE.IconButton(GVAR.OptionsFrame.Close, 0)
	GVAR.OptionsFrame.Close:SetWidth(20)
	GVAR.OptionsFrame.Close:SetHeight(20)
	GVAR.OptionsFrame.Close:SetPoint("RIGHT", GVAR.OptionsFrame.MoverTop, "RIGHT", 0, 0)
	GVAR.OptionsFrame.Close:SetScript("OnClick", function() GVAR.OptionsFrame:Hide() end)

	GVAR.OptionsFrame.MoverBottom = CreateFrame("Frame", nil, GVAR.OptionsFrame)
	TEMPLATE.BorderTRBL(GVAR.OptionsFrame.MoverBottom)
	-- BOOM GVAR.OptionsFrame.MoverBottom:SetWidth()
	GVAR.OptionsFrame.MoverBottom:SetHeight(20)
	GVAR.OptionsFrame.MoverBottom:SetPoint("TOP", GVAR.OptionsFrame, "BOTTOM", 0, 1)
	GVAR.OptionsFrame.MoverBottom:EnableMouse(true)
	GVAR.OptionsFrame.MoverBottom:EnableMouseWheel(true)
	GVAR.OptionsFrame.MoverBottom:SetScript("OnMouseWheel", NOOP)
	GVAR.OptionsFrame.MoverBottomText = GVAR.OptionsFrame.MoverBottom:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	GVAR.OptionsFrame.MoverBottomText:SetPoint("CENTER", GVAR.OptionsFrame.MoverBottom, "CENTER", 0, 0)
	GVAR.OptionsFrame.MoverBottomText:SetJustifyH("CENTER")
	GVAR.OptionsFrame.MoverBottomText:SetTextColor(0.5, 0.5, 0.5, 1)
	GVAR.OptionsFrame.MoverBottomText:SetText(L["click & move"])

	local function OnEnter()
		GVAR.OptionsFrame.MoverTopText:SetTextColor(1, 1, 1, 1)
		GVAR.OptionsFrame.MoverBottomText:SetTextColor(1, 1, 1, 1)
		GVAR.OptionsFrame.ClampDummy1:Show()
		GVAR.OptionsFrame.ClampDummy2:Show()
		GVAR.OptionsFrame.ClampDummy3:Show()
		GVAR.OptionsFrame.ClampDummy4:Show()
	end
	local function OnLeave()
		GVAR.OptionsFrame.MoverTopText:SetTextColor(0.5, 0.5, 0.5, 1)
		GVAR.OptionsFrame.MoverBottomText:SetTextColor(0.5, 0.5, 0.5, 1)
		GVAR.OptionsFrame.ClampDummy1:Hide()
		GVAR.OptionsFrame.ClampDummy2:Hide()
		GVAR.OptionsFrame.ClampDummy3:Hide()
		GVAR.OptionsFrame.ClampDummy4:Hide()
	end
	local function OnMouseDown()
		GVAR.OptionsFrame:StartMoving()
	end
	local function OnMouseUp()
		GVAR.OptionsFrame:StopMovingOrSizing()
		BattlegroundTargets:Frame_SavePosition("BattlegroundTargets_OptionsFrame")
	end

	GVAR.OptionsFrame.MoverTop:SetScript("OnEnter", OnEnter)
	GVAR.OptionsFrame.MoverTop:SetScript("OnLeave", OnLeave)
	GVAR.OptionsFrame.MoverTop:SetScript("OnMouseDown", OnMouseDown)
	GVAR.OptionsFrame.MoverTop:SetScript("OnMouseUp", OnMouseUp)

	GVAR.OptionsFrame.MoverBottom:SetScript("OnEnter", OnEnter)
	GVAR.OptionsFrame.MoverBottom:SetScript("OnLeave", OnLeave)
	GVAR.OptionsFrame.MoverBottom:SetScript("OnMouseDown", OnMouseDown)
	GVAR.OptionsFrame.MoverBottom:SetScript("OnMouseUp", OnMouseUp)
	-- ###
	-- ####################################################################################################



	-- ####################################################################################################
	-- xMx width BOOM
	local frameWidth = 400
	if layoutW > frameWidth then frameWidth = layoutW end
	if summaryW > frameWidth then frameWidth = summaryW end
	if generalIconW > frameWidth then frameWidth = generalIconW end
	if iconW > frameWidth then frameWidth = iconW end
	if rangeW > frameWidth then frameWidth = rangeW end
	if sortW > frameWidth then frameWidth = sortW end
	if fontstyleW > frameWidth then frameWidth = fontstyleW end
	if frameWidth < 400 then frameWidth = 400 end
	if frameWidth > 650 then frameWidth = 650 end
	-- OptionsFrame
	GVAR.OptionsFrame:SetClampRectInsets((frameWidth-50)/2, -((frameWidth-50)/2), -(heightTotal-35), heightTotal-35)
	GVAR.OptionsFrame:SetWidth(frameWidth)
	GVAR.OptionsFrame.CloseConfig:SetWidth(frameWidth-20)
	-- CLAMP_FIX_OPTIONS BEGIN
	GVAR.OptionsFrame.ClampDummy1:SetSize(frameWidth+50, 2)
	GVAR.OptionsFrame.ClampDummy2:SetSize(frameWidth+50, 2)
	GVAR.OptionsFrame.ClampDummy3:SetSize(2, heightTotal+90) -- 50 + 40 (2xMover height)
	GVAR.OptionsFrame.ClampDummy4:SetSize(2, heightTotal+90) -- 50 + 40 (2xMover height)
	-- CLAMP_FIX_OPTIONS END
	-- Base
	GVAR.OptionsFrame.Base:SetWidth(frameWidth)
	GVAR.OptionsFrame.Title:SetWidth(frameWidth)
	local spacer = 10
	local copyButtonWidth = GVAR.OptionsFrame.CopySettings1:GetWidth() + 20
	local tabWidth1 = GVAR.OptionsFrame.TabGeneral.TabText:GetStringWidth() + 20
	local tabWidth2 = floor( (frameWidth-tabWidth1-tabWidth1-copyButtonWidth-(6*spacer)) / 3 )
	GVAR.OptionsFrame.TabGeneral:SetWidth(tabWidth1)
	GVAR.OptionsFrame.TabRaidSize10:SetWidth(tabWidth2)
	GVAR.OptionsFrame.TabRaidSize15:SetWidth(tabWidth2)
	GVAR.OptionsFrame.TabRaidSize40:SetWidth(tabWidth2)
	GVAR.OptionsFrame.TabGeneral:SetPoint("BOTTOMLEFT", GVAR.OptionsFrame.Base, "BOTTOMLEFT", spacer, -1)

	local copyButtonWidth = GVAR.OptionsFrame.CopySettings2:GetWidth() + 20
	local tabWidth1 = GVAR.OptionsFrame.EnableFriendBracket.TabText:GetStringWidth() + 20
	local tabWidth2 = GVAR.OptionsFrame.EnableEnemyBracket.TabText:GetStringWidth() + 20
	if tabWidth2 > tabWidth1 then tabWidth1 = tabWidth2 end
	local tabWidth2 = floor( (frameWidth-tabWidth1-tabWidth1-copyButtonWidth-spacer) /2 )
	GVAR.OptionsFrame.EnableFriendBracket:SetWidth(tabWidth1)
	GVAR.OptionsFrame.EnableEnemyBracket:SetWidth(tabWidth1)
	GVAR.OptionsFrame.EnableFriendBracket:SetPoint("TOPLEFT", GVAR.OptionsFrame.ConfigBrackets, "TOPLEFT", tabWidth2, -10)

	GVAR.OptionsFrame.Dummy0:SetWidth(frameWidth) -- DUMMY
	GVAR.OptionsFrame.Dummy1:SetWidth(frameWidth-20)
	GVAR.OptionsFrame.Dummy2:SetWidth(frameWidth-20)
	GVAR.OptionsFrame.Dummy3:SetWidth(frameWidth-20)
	GVAR.OptionsFrame.Dummy4:SetWidth(frameWidth-20)
	GVAR.OptionsFrame.Dummy5:SetWidth(frameWidth-20)
	GVAR.OptionsFrame.Dummy6:SetWidth(frameWidth-20)
	GVAR.OptionsFrame.Dummy7:SetWidth(frameWidth-20)
	-- ConfigBrackets
	GVAR.OptionsFrame.ConfigBrackets:SetWidth(frameWidth)
	-- ConfigGeneral
	GVAR.OptionsFrame.ConfigGeneral:SetWidth(frameWidth)
	-- Mover
	GVAR.OptionsFrame.MoverTop:SetWidth(frameWidth)
	GVAR.OptionsFrame.MoverBottom:SetWidth(frameWidth)
	-- ###
	-- ####################################################################################################
end

function BattlegroundTargets:ClickOnBracketTab(bracketSize, fraction, force)
	if not force and testSize == bracketSize then return end
	testSize = bracketSize
	local size10, size15, size40
	if testSize == 10 then
		size10 = true
	elseif testSize == 15 then
		size15 = true
	elseif testSize == 40 then
		size40 = true
	end
	GVAR.OptionsFrame.ConfigGeneral:Hide()
	GVAR.OptionsFrame.ConfigBrackets:Show()
	TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabGeneral, nil)
	TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize10, size10)
	TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize15, size15)
	TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize40, size40)
	BattlegroundTargets:CheckForEnabledBracket(testSize, fraction)
	local BattlegroundTargets_Options = BattlegroundTargets_Options
	if BattlegroundTargets_Options.Friend.EnableBracket[testSize] or BattlegroundTargets_Options.Enemy.EnableBracket[testSize] then
		BattlegroundTargets:EnableConfigMode()
	else
		BattlegroundTargets:DisableConfigMode()
	end
end

function BattlegroundTargets:ClickOnFractionTab(side)
	if fraction == side then return end
	local fracF, fracE
	if side == "Friend" then
		fracF = true
	elseif side == "Enemy" then
		fracE = true
	end
	TEMPLATE.SetTabButton(GVAR.OptionsFrame.EnableFriendBracket, fracF)
	TEMPLATE.SetTabButton(GVAR.OptionsFrame.EnableEnemyBracket, fracE)
	BattlegroundTargets:CheckForEnabledBracket(currentSize, side)
	fraction = side
	local BattlegroundTargets_Options = BattlegroundTargets_Options
	if BattlegroundTargets_Options.Friend.EnableBracket[currentSize] or BattlegroundTargets_Options.Enemy.EnableBracket[currentSize] then
		BattlegroundTargets:EnableConfigMode()
	else
		BattlegroundTargets:DisableConfigMode()
	end
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CreateMinimapButton()
	if not BattlegroundTargets_Options.MinimapButton then
		if BattlegroundTargets_MinimapButton then
			BattlegroundTargets_MinimapButton:Hide()
		end
		return
	else
		if BattlegroundTargets_MinimapButton then
			BattlegroundTargets_MinimapButton:Show()
			return
		end
	end

	local function MoveMinimapButton()
		local xpos
		local ypos
		local minimapShape = GetMinimapShape and GetMinimapShape() or "ROUND"
		if minimapShape == "SQUARE" then
			xpos = 110 * cos(BattlegroundTargets_Options.MinimapButtonPos or 0)
			ypos = 110 * sin(BattlegroundTargets_Options.MinimapButtonPos or 0)
			xpos = math.max(-82, math.min(xpos, 84))
			ypos = math.max(-86, math.min(ypos, 82))
		else
			xpos = 80 * cos(BattlegroundTargets_Options.MinimapButtonPos or 0)
			ypos = 80 * sin(BattlegroundTargets_Options.MinimapButtonPos or 0)
		end
		BattlegroundTargets_MinimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 54-xpos, ypos-54)
	end

	local function DragMinimapButton()
		local xpos, ypos = GetCursorPosition()
		local xmin, ymin = Minimap:GetLeft() or 400, Minimap:GetBottom() or 400
		local scale = Minimap:GetEffectiveScale()
		xpos = xmin-xpos/scale+70
		ypos = ypos/scale-ymin-70
		BattlegroundTargets_Options.MinimapButtonPos = math.deg(math.atan2(ypos, xpos))
		MoveMinimapButton()
	end

	local MinimapButton = CreateFrame("Button", "BattlegroundTargets_MinimapButton", Minimap)
	MinimapButton:EnableMouse(true)
	MinimapButton:SetMovable(true)
	MinimapButton:SetToplevel(true)
	MinimapButton:SetWidth(32)
	MinimapButton:SetHeight(32)
	MinimapButton:SetPoint("TOPLEFT")
	MinimapButton:SetFrameStrata("MEDIUM")
	MinimapButton:RegisterForClicks("AnyUp")
	MinimapButton:RegisterForDrag("LeftButton")

	local texture = MinimapButton:CreateTexture(nil, "ARTWORK")
	texture:SetWidth(54)
	texture:SetHeight(54)
	texture:SetPoint("TOPLEFT")
	texture:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

	local texture = MinimapButton:CreateTexture(nil, "BACKGROUND")
	texture:SetWidth(24)
	texture:SetHeight(24)
	texture:SetPoint("TOPLEFT", 2, -4)
	texture:SetTexture("Interface\\Minimap\\UI-Minimap-Background")

	local NormalTexture = MinimapButton:CreateTexture(nil, "ARTWORK")
	NormalTexture:SetWidth(12)
	NormalTexture:SetHeight(14)
	NormalTexture:SetPoint("TOPLEFT", 10.5, -8.5)
	NormalTexture:SetTexture(Textures.AddonIcon)
	NormalTexture:SetTexCoord(2/16, 14/16, 1/16, 15/16)
	MinimapButton:SetNormalTexture(NormalTexture)

	local PushedTexture = MinimapButton:CreateTexture(nil, "ARTWORK")
	PushedTexture:SetWidth(10)
	PushedTexture:SetHeight(12)
	PushedTexture:SetPoint("TOPLEFT", 11.5, -9.5)
	PushedTexture:SetTexture(Textures.AddonIcon)
	PushedTexture:SetTexCoord(2/16, 14/16, 1/16, 15/16)
	MinimapButton:SetPushedTexture(PushedTexture)

	local HighlightTexture = MinimapButton:CreateTexture(nil, "ARTWORK")
	HighlightTexture:SetPoint("TOPLEFT", 0, 0)
	HighlightTexture:SetPoint("BOTTOMRIGHT", 0, 0)
	HighlightTexture:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
	MinimapButton:SetHighlightTexture(HighlightTexture)

	MinimapButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine("BattlegroundTargets", 1, 0.82, 0, 1)
		GameTooltip:Show()
	end)
	MinimapButton:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	MinimapButton:SetScript("OnClick", function(self, button) BattlegroundTargets:Frame_Toggle(GVAR.OptionsFrame) end)
	MinimapButton:SetScript("OnDragStart", function(self) self:LockHighlight() self:SetScript("OnUpdate", DragMinimapButton) end)
	MinimapButton:SetScript("OnDragStop", function(self) self:SetScript("OnUpdate", nil) self:UnlockHighlight() end)

	MoveMinimapButton()
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:SetOptions(side)
	local BattlegroundTargets_Options = BattlegroundTargets_Options

	if currentSize == 10 then
		TEMPLATE.SetIconButton(GVAR.OptionsFrame.CopySettings1, 1)
	elseif currentSize == 15 then
		TEMPLATE.SetIconButton(GVAR.OptionsFrame.CopySettings1, 2)
	end
	if side == "Enemy" then
		TEMPLATE.SetIconButton(GVAR.OptionsFrame.CopySettings2, 2)
	else
		TEMPLATE.SetIconButton(GVAR.OptionsFrame.CopySettings2, 1)
	end

	local LayoutTH = BattlegroundTargets_Options[side].LayoutTH[currentSize]
	if LayoutTH == 18 then
		GVAR.OptionsFrame.LayoutTHx18:SetChecked(true)
		GVAR.OptionsFrame.LayoutTHx24:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx42:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx81:SetChecked(false)
	elseif LayoutTH == 24 then
		GVAR.OptionsFrame.LayoutTHx18:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx24:SetChecked(true)
		GVAR.OptionsFrame.LayoutTHx42:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx81:SetChecked(false)
	elseif LayoutTH == 42 then
		GVAR.OptionsFrame.LayoutTHx18:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx24:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx42:SetChecked(true)
		GVAR.OptionsFrame.LayoutTHx81:SetChecked(false)
	elseif LayoutTH == 81 then
		GVAR.OptionsFrame.LayoutTHx18:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx24:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx42:SetChecked(false)
		GVAR.OptionsFrame.LayoutTHx81:SetChecked(true)
	end
	GVAR.OptionsFrame.LayoutSpace:SetValue(BattlegroundTargets_Options[side].LayoutSpace[currentSize])
	GVAR.OptionsFrame.LayoutSpaceText:SetText(BattlegroundTargets_Options[side].LayoutSpace[currentSize])

	GVAR.OptionsFrame.SummaryToggle:SetChecked(BattlegroundTargets_Options[side].SummaryToggle[currentSize])
	GVAR.OptionsFrame.SummaryScale:SetValue(BattlegroundTargets_Options[side].SummaryScale[currentSize]*100)
	GVAR.OptionsFrame.SummaryScaleText:SetText((BattlegroundTargets_Options[side].SummaryScale[currentSize]*100).."%")
	GVAR.OptionsFrame.SummaryPosition:SetValue(BattlegroundTargets_Options[side].SummaryPos[currentSize])
	GVAR.OptionsFrame.SummaryPositionText:SetText(sumPos[ BattlegroundTargets_Options[side].SummaryPos[currentSize] ])

	GVAR.OptionsFrame.ShowRole:SetChecked(BattlegroundTargets_Options[side].ButtonRoleToggle[currentSize])
	GVAR.OptionsFrame.ShowSpec:SetChecked(BattlegroundTargets_Options[side].ButtonSpecToggle[currentSize])
	GVAR.OptionsFrame.ClassIcon:SetChecked(BattlegroundTargets_Options[side].ButtonClassToggle[currentSize])
	GVAR.OptionsFrame.ShowLeader:SetChecked(BattlegroundTargets_Options[side].ButtonLeaderToggle[currentSize])
	GVAR.OptionsFrame.ShowRealm:SetChecked(BattlegroundTargets_Options[side].ButtonRealmToggle[currentSize])
	GVAR.OptionsFrame.ShowPVPTrinket:SetChecked(BattlegroundTargets_Options[side].ButtonPvPTrinketToggle[currentSize])

	GVAR.OptionsFrame.ShowTargetIndicator:SetChecked(BattlegroundTargets_Options[side].ButtonTargetToggle[currentSize])
	GVAR.OptionsFrame.TargetScaleSlider:SetValue(BattlegroundTargets_Options[side].ButtonTargetScale[currentSize]*100)
	GVAR.OptionsFrame.TargetScaleSliderText:SetText((BattlegroundTargets_Options[side].ButtonTargetScale[currentSize]*100).."%")
	GVAR.OptionsFrame.TargetPositionSlider:SetValue(BattlegroundTargets_Options[side].ButtonTargetPosition[currentSize])
	GVAR.OptionsFrame.TargetPositionSliderText:SetText(BattlegroundTargets_Options[side].ButtonTargetPosition[currentSize])

	GVAR.OptionsFrame.ShowFocusIndicator:SetChecked(BattlegroundTargets_Options[side].ButtonFocusToggle[currentSize])
	GVAR.OptionsFrame.FocusScaleSlider:SetValue(BattlegroundTargets_Options[side].ButtonFocusScale[currentSize]*100)
	GVAR.OptionsFrame.FocusScaleSliderText:SetText((BattlegroundTargets_Options[side].ButtonFocusScale[currentSize]*100).."%")
	GVAR.OptionsFrame.FocusPositionSlider:SetValue(BattlegroundTargets_Options[side].ButtonFocusPosition[currentSize])
	GVAR.OptionsFrame.FocusPositionSliderText:SetText(BattlegroundTargets_Options[side].ButtonFocusPosition[currentSize])

	GVAR.OptionsFrame.ShowFlag:SetChecked(BattlegroundTargets_Options[side].ButtonFlagToggle[currentSize])
	GVAR.OptionsFrame.FlagScaleSlider:SetValue(BattlegroundTargets_Options[side].ButtonFlagScale[currentSize]*100)
	GVAR.OptionsFrame.FlagScaleSliderText:SetText((BattlegroundTargets_Options[side].ButtonFlagScale[currentSize]*100).."%")
	GVAR.OptionsFrame.FlagPositionSlider:SetValue(BattlegroundTargets_Options[side].ButtonFlagPosition[currentSize])
	GVAR.OptionsFrame.FlagPositionSliderText:SetText(BattlegroundTargets_Options[side].ButtonFlagPosition[currentSize])

	GVAR.OptionsFrame.ShowAssist:SetChecked(BattlegroundTargets_Options[side].ButtonAssistToggle[currentSize])
	GVAR.OptionsFrame.AssistScaleSlider:SetValue(BattlegroundTargets_Options[side].ButtonAssistScale[currentSize]*100)
	GVAR.OptionsFrame.AssistScaleSliderText:SetText((BattlegroundTargets_Options[side].ButtonAssistScale[currentSize]*100).."%")
	GVAR.OptionsFrame.AssistPositionSlider:SetValue(BattlegroundTargets_Options[side].ButtonAssistPosition[currentSize])
	GVAR.OptionsFrame.AssistPositionSliderText:SetText(BattlegroundTargets_Options[side].ButtonAssistPosition[currentSize])

	GVAR.OptionsFrame.ShowFTargetCount:SetChecked(BattlegroundTargets_Options[side].ButtonFTargetCountToggle[currentSize])
	GVAR.OptionsFrame.ShowETargetCount:SetChecked(BattlegroundTargets_Options[side].ButtonETargetCountToggle[currentSize])
	GVAR.OptionsFrame.TargetofTarget:SetChecked(BattlegroundTargets_Options[side].ButtonToTToggle[currentSize])
	GVAR.OptionsFrame.ToTScaleSlider:SetValue(BattlegroundTargets_Options[side].ButtonToTScale[currentSize]*100)
	GVAR.OptionsFrame.ToTScaleSliderText:SetText((BattlegroundTargets_Options[side].ButtonToTScale[currentSize]*100).."%")
	GVAR.OptionsFrame.ToTPositionSlider:SetValue(BattlegroundTargets_Options[side].ButtonToTPosition[currentSize])
	GVAR.OptionsFrame.ToTPositionSliderText:SetText(BattlegroundTargets_Options[side].ButtonToTPosition[currentSize])

	GVAR.OptionsFrame.ShowHealthBar:SetChecked(BattlegroundTargets_Options[side].ButtonHealthBarToggle[currentSize])
	GVAR.OptionsFrame.ShowHealthText:SetChecked(BattlegroundTargets_Options[side].ButtonHealthTextToggle[currentSize])

	GVAR.OptionsFrame.RangeCheck:SetChecked(BattlegroundTargets_Options[side].ButtonRangeToggle[currentSize])
	GVAR.OptionsFrame.RangeDisplayPullDown.PullDownButtonText:SetText(rangeDisplay[ BattlegroundTargets_Options[side].ButtonRangeDisplay[currentSize] ])

	GVAR.OptionsFrame.SortByPullDown.PullDownButtonText:SetText(sortBy[ BattlegroundTargets_Options[side].ButtonSortBy[currentSize] ])
	GVAR.OptionsFrame.SortDetailPullDown.PullDownButtonText:SetText(sortDetail[ BattlegroundTargets_Options[side].ButtonSortDetail[currentSize] ])
	local ButtonSortBy = BattlegroundTargets_Options[side].ButtonSortBy[currentSize]
	if ButtonSortBy == 1 or ButtonSortBy == 3 or ButtonSortBy == 4 then
		GVAR.OptionsFrame.SortDetailPullDown:Show()
		GVAR.OptionsFrame.SortInfo:Show()
	else
		GVAR.OptionsFrame.SortDetailPullDown:Hide()
		GVAR.OptionsFrame.SortInfo:Hide()
	end

	GVAR.OptionsFrame.FontNamePullDown.PullDownButtonText:SetText(fontStyles[ BattlegroundTargets_Options[side].ButtonFontNameStyle[currentSize] ].name)
	GVAR.OptionsFrame.FontNameSlider:SetValue(BattlegroundTargets_Options[side].ButtonFontNameSize[currentSize])
	GVAR.OptionsFrame.FontNameValue:SetText(BattlegroundTargets_Options[side].ButtonFontNameSize[currentSize])
	GVAR.OptionsFrame.FontNumberPullDown.PullDownButtonText:SetText(strmatch(fontStyles[ BattlegroundTargets_Options[side].ButtonFontNumberStyle[currentSize] ].name, "(.*) %- .*"))
	GVAR.OptionsFrame.FontNumberSlider:SetValue(BattlegroundTargets_Options[side].ButtonFontNumberSize[currentSize])
	GVAR.OptionsFrame.FontNumberValue:SetText(BattlegroundTargets_Options[side].ButtonFontNumberSize[currentSize])

	GVAR.OptionsFrame.ScaleSlider:SetValue(BattlegroundTargets_Options[side].ButtonScale[currentSize]*100)
	GVAR.OptionsFrame.ScaleValue:SetText((BattlegroundTargets_Options[side].ButtonScale[currentSize]*100).."%")

	GVAR.OptionsFrame.WidthSlider:SetValue(BattlegroundTargets_Options[side].ButtonWidth[currentSize])
	GVAR.OptionsFrame.WidthValue:SetText(BattlegroundTargets_Options[side].ButtonWidth[currentSize])

	GVAR.OptionsFrame.HeightSlider:SetValue(BattlegroundTargets_Options[side].ButtonHeight[currentSize])
	GVAR.OptionsFrame.HeightValue:SetText(BattlegroundTargets_Options[side].ButtonHeight[currentSize])
end



function BattlegroundTargets:CheckForEnabledBracket(bracketSize, side)
	local BattlegroundTargets_Options = BattlegroundTargets_Options

	if BattlegroundTargets_Options.Friend.EnableBracket[bracketSize] or BattlegroundTargets_Options.Enemy.EnableBracket[bracketSize] then
		GVAR.OptionsFrame["TabRaidSize"..bracketSize].TabText:SetTextColor(0, 0.75, 0, 1)
	else
		GVAR.OptionsFrame["TabRaidSize"..bracketSize].TabText:SetTextColor(1, 0, 0, 1)
	end

	if BattlegroundTargets_Options.Friend.EnableBracket[bracketSize] and BattlegroundTargets_Options.Enemy.EnableBracket[bracketSize] then
		GVAR.OptionsFrame.EnableFriendBracket.TabText:SetTextColor(0, 0.75, 0, 1)
		GVAR.OptionsFrame.EnableEnemyBracket.TabText:SetTextColor(0, 0.75, 0, 1)
	elseif BattlegroundTargets_Options.Friend.EnableBracket[bracketSize] then
		GVAR.OptionsFrame.EnableFriendBracket.TabText:SetTextColor(0, 0.75, 0, 1)
		GVAR.OptionsFrame.EnableEnemyBracket.TabText:SetTextColor(1, 0, 0, 1)
	elseif BattlegroundTargets_Options.Enemy.EnableBracket[bracketSize] then
		GVAR.OptionsFrame.EnableFriendBracket.TabText:SetTextColor(1, 0, 0, 1)
		GVAR.OptionsFrame.EnableEnemyBracket.TabText:SetTextColor(0, 0.75, 0, 1)
	else
		GVAR.OptionsFrame.EnableFriendBracket.TabText:SetTextColor(1, 0, 0, 1)
		GVAR.OptionsFrame.EnableEnemyBracket.TabText:SetTextColor(1, 0, 0, 1)
	end

	if side == "Friend" then
		GVAR.FriendMainFrame.MainMoverButton[1].Texture:SetColorTexture(0, 0, 0, 1)
		GVAR.FriendMainFrame.MainMoverButton[2].Texture:SetColorTexture(0, 0, 0, 1)
		GVAR.EnemyMainFrame.MainMoverButton[1].Texture:SetColorTexture(1, 1, 1, 0.2)
		GVAR.EnemyMainFrame.MainMoverButton[2].Texture:SetColorTexture(1, 1, 1, 0.2)
		GVAR.FriendMainFrame.MainMoverFracTxt:SetTextColor(1, 1, 1, 1)
		GVAR.EnemyMainFrame.MainMoverFracTxt:SetTextColor(0.5, 0.5, 0.5, 1)
	else
		GVAR.FriendMainFrame.MainMoverButton[1].Texture:SetColorTexture(1, 1, 1, 0.2)
		GVAR.FriendMainFrame.MainMoverButton[2].Texture:SetColorTexture(1, 1, 1, 0.2)
		GVAR.EnemyMainFrame.MainMoverButton[1].Texture:SetColorTexture(0, 0, 0, 1)
		GVAR.EnemyMainFrame.MainMoverButton[2].Texture:SetColorTexture(0, 0, 0, 1)
		GVAR.FriendMainFrame.MainMoverFracTxt:SetTextColor(0.5, 0.5, 0.5, 1)
		GVAR.EnemyMainFrame.MainMoverFracTxt:SetTextColor(1, 1, 1, 1)
	end

	GVAR.OptionsFrame.EnableFraction:SetChecked(BattlegroundTargets_Options[side].EnableBracket[bracketSize])

	if BattlegroundTargets_Options[side].EnableBracket[bracketSize] then
		-- ----------------------------------------
		GVAR.OptionsFrame.LayoutTHText:SetTextColor(1, 1, 1, 1)
		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.LayoutTHx18)
		if bracketSize == 10 or bracketSize == 15 then
			TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.LayoutTHx24)
			TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.LayoutTHx42)
		else
			TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.LayoutTHx24)
			TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.LayoutTHx42)
		end
		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.LayoutTHx81)
		if BattlegroundTargets_Options[side].LayoutTH[bracketSize] == 18 then
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.LayoutSpace)
		else
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.LayoutSpace)
		end

		GVAR.OptionsFrame.SummaryText:SetTextColor(1, 1, 1, 1)
		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.SummaryToggle)
		if BattlegroundTargets_Options[side].SummaryToggle[bracketSize] then
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.SummaryScale)
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.SummaryPosition)
		else
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.SummaryScale)
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.SummaryPosition)
		end

		if bracketSize == 40 then
			GVAR.OptionsFrame.CopySettings1:Hide()
			TEMPLATE.EnableIconButton(GVAR.OptionsFrame.CopySettings2)
		else
			GVAR.OptionsFrame.CopySettings1:Show()
			GVAR.OptionsFrame.CopySettings2:Show()
			TEMPLATE.EnableIconButton(GVAR.OptionsFrame.CopySettings1)
			TEMPLATE.EnableIconButton(GVAR.OptionsFrame.CopySettings2)
		end

		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.ShowRole)
		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.ShowSpec)
		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.ClassIcon)
		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.ShowLeader)
		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.ShowRealm)
		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.ShowPVPTrinket)

		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.ShowTargetIndicator)
		if BattlegroundTargets_Options[side].ButtonTargetToggle[bracketSize] then
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.TargetScaleSlider)
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.TargetPositionSlider)
		else
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.TargetScaleSlider)
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.TargetPositionSlider)
		end
		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.ShowFocusIndicator)
		if BattlegroundTargets_Options[side].ButtonFocusToggle[bracketSize] then
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.FocusScaleSlider)
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.FocusPositionSlider)
		else
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.FocusScaleSlider)
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.FocusPositionSlider)
		end
		if bracketSize == 40 then
			TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowFlag)
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.FlagScaleSlider)
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.FlagPositionSlider)
			GVAR.OptionsFrame.CarrierSwitchDisableFunc()
		else
			TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.ShowFlag)
			if BattlegroundTargets_Options[side].ButtonFlagToggle[bracketSize] then
				TEMPLATE.EnableSlider(GVAR.OptionsFrame.FlagScaleSlider)
				TEMPLATE.EnableSlider(GVAR.OptionsFrame.FlagPositionSlider)
				GVAR.OptionsFrame.CarrierSwitchEnableFunc()
			else
				TEMPLATE.DisableSlider(GVAR.OptionsFrame.FlagScaleSlider)
				TEMPLATE.DisableSlider(GVAR.OptionsFrame.FlagPositionSlider)
				GVAR.OptionsFrame.CarrierSwitchDisableFunc()
			end
		end
		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.ShowAssist)
		if BattlegroundTargets_Options[side].ButtonAssistToggle[bracketSize] then
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.AssistScaleSlider)
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.AssistPositionSlider)
		else
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.AssistScaleSlider)
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.AssistPositionSlider)
		end

		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.ShowFTargetCount)
		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.ShowETargetCount)
		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.TargetofTarget)
		if BattlegroundTargets_Options[side].ButtonToTToggle[bracketSize] then
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.ToTScaleSlider)
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.ToTPositionSlider)
		else
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.ToTScaleSlider)
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.ToTPositionSlider)
		end

		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.ShowHealthBar)
		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.ShowHealthText)

		TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.RangeCheck)
		if BattlegroundTargets_Options[side].ButtonRangeToggle[bracketSize] then
			GVAR.OptionsFrame.RangeCheckInfo:Enable() Desaturation(GVAR.OptionsFrame.RangeCheckInfo.Texture, false)
			TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.RangeDisplayPullDown)
		else
			GVAR.OptionsFrame.RangeCheckInfo:Disable() Desaturation(GVAR.OptionsFrame.RangeCheckInfo.Texture, true)
			TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.RangeDisplayPullDown)
		end

		TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.SortByPullDown)
		GVAR.OptionsFrame.SortByTitle:SetTextColor(1, 1, 1, 1)
		TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.SortDetailPullDown)
		GVAR.OptionsFrame.SortInfo:Enable() Desaturation(GVAR.OptionsFrame.SortInfo.Texture, false)

		TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.FontNamePullDown)
		GVAR.OptionsFrame.FontNameTitle:SetTextColor(1, 1, 1, 1)
		TEMPLATE.EnableSlider(GVAR.OptionsFrame.FontNameSlider)
		if BattlegroundTargets_Options[side].SummaryToggle[bracketSize] or
		   BattlegroundTargets_Options[side].ButtonFlagToggle[bracketSize] or
		   BattlegroundTargets_Options[side].ButtonHealthTextToggle[bracketSize] or
		   BattlegroundTargets_Options[side].ButtonFTargetCountToggle[bracketSize] or
		   BattlegroundTargets_Options[side].ButtonETargetCountToggle[bracketSize]
		then
			TEMPLATE.EnablePullDownMenu(GVAR.OptionsFrame.FontNumberPullDown)
			GVAR.OptionsFrame.FontNumberTitle:SetTextColor(1, 1, 1, 1)
			TEMPLATE.EnableSlider(GVAR.OptionsFrame.FontNumberSlider)
		else
			TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.FontNumberPullDown)
			GVAR.OptionsFrame.FontNumberTitle:SetTextColor(0.5, 0.5, 0.5, 1)
			TEMPLATE.DisableSlider(GVAR.OptionsFrame.FontNumberSlider)
		end

		TEMPLATE.EnableSlider(GVAR.OptionsFrame.ScaleSlider)
		GVAR.OptionsFrame.ScaleTitle:SetTextColor(1, 1, 1, 1)
		TEMPLATE.EnableSlider(GVAR.OptionsFrame.WidthSlider)
		GVAR.OptionsFrame.WidthTitle:SetTextColor(1, 1, 1, 1)
		TEMPLATE.EnableSlider(GVAR.OptionsFrame.HeightSlider)
		GVAR.OptionsFrame.HeightTitle:SetTextColor(1, 1, 1, 1)
		GVAR.OptionsFrame.TestShuffler:Show()
		-- ----------------------------------------
	else
		-- ----------------------------------------
		GVAR.OptionsFrame.LayoutTHText:SetTextColor(0.5, 0.5, 0.5, 1)
		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.LayoutTHx18)
		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.LayoutTHx24)
		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.LayoutTHx42)
		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.LayoutTHx81)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.LayoutSpace)

		GVAR.OptionsFrame.SummaryText:SetTextColor(0.5, 0.5, 0.5, 1)
		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.SummaryToggle)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.SummaryScale)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.SummaryPosition)

		if bracketSize == 40 then
			GVAR.OptionsFrame.CopySettings1:Hide()
			TEMPLATE.DisableIconButton(GVAR.OptionsFrame.CopySettings2)
		else
			GVAR.OptionsFrame.CopySettings1:Show()
			GVAR.OptionsFrame.CopySettings2:Show()
			TEMPLATE.DisableIconButton(GVAR.OptionsFrame.CopySettings1)
			TEMPLATE.DisableIconButton(GVAR.OptionsFrame.CopySettings2)
		end

		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowRole)
		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowSpec)
		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ClassIcon)
		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowLeader)
		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowRealm)
		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowPVPTrinket)

		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowTargetIndicator)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.TargetScaleSlider)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.TargetPositionSlider)
		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowFocusIndicator)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.FocusScaleSlider)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.FocusPositionSlider)
		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowFlag)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.FlagScaleSlider)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.FlagPositionSlider)
		GVAR.OptionsFrame.CarrierSwitchDisableFunc()
		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowAssist)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.AssistScaleSlider)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.AssistPositionSlider)

		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowFTargetCount)
		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowETargetCount)
		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.TargetofTarget)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.ToTScaleSlider)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.ToTPositionSlider)

		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowHealthBar)
		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowHealthText)

		TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.RangeCheck)
		GVAR.OptionsFrame.RangeCheckInfo:Disable() Desaturation(GVAR.OptionsFrame.RangeCheckInfo.Texture, true)
		TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.RangeDisplayPullDown)

		TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.SortByPullDown)
		GVAR.OptionsFrame.SortByTitle:SetTextColor(0.5, 0.5, 0.5, 1)
		TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.SortDetailPullDown)
		GVAR.OptionsFrame.SortInfo:Disable() Desaturation(GVAR.OptionsFrame.SortInfo.Texture, true)

		TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.FontNamePullDown)
		GVAR.OptionsFrame.FontNameTitle:SetTextColor(0.5, 0.5, 0.5, 1)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.FontNameSlider)
		TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.FontNumberPullDown)
		GVAR.OptionsFrame.FontNumberTitle:SetTextColor(0.5, 0.5, 0.5, 1)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.FontNumberSlider)

		TEMPLATE.DisableSlider(GVAR.OptionsFrame.ScaleSlider)
		GVAR.OptionsFrame.ScaleTitle:SetTextColor(0.5, 0.5, 0.5, 1)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.WidthSlider)
		GVAR.OptionsFrame.WidthTitle:SetTextColor(0.5, 0.5, 0.5, 1)
		TEMPLATE.DisableSlider(GVAR.OptionsFrame.HeightSlider)
		GVAR.OptionsFrame.HeightTitle:SetTextColor(0.5, 0.5, 0.5, 1)
		GVAR.OptionsFrame.TestShuffler:Hide()
		-- ----------------------------------------
	end
end



function BattlegroundTargets:DisableInsecureConfigWidges()
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.Minimap)

	TEMPLATE.DisableTabButton(GVAR.OptionsFrame.TabGeneral)
	TEMPLATE.DisableTabButton(GVAR.OptionsFrame.TabRaidSize10)
	TEMPLATE.DisableTabButton(GVAR.OptionsFrame.TabRaidSize15)
	TEMPLATE.DisableTabButton(GVAR.OptionsFrame.TabRaidSize40)

	TEMPLATE.DisableTabButton(GVAR.OptionsFrame.EnableFriendBracket)
	TEMPLATE.DisableTabButton(GVAR.OptionsFrame.EnableEnemyBracket)

	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.EnableFraction)

	TEMPLATE.DisableIconButton(GVAR.OptionsFrame.CopySettings1)
	TEMPLATE.DisableIconButton(GVAR.OptionsFrame.CopySettings2)

	GVAR.OptionsFrame.LayoutTHText:SetTextColor(0.5, 0.5, 0.5, 1)
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.LayoutTHx18)
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.LayoutTHx24)
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.LayoutTHx42)
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.LayoutTHx81)
	TEMPLATE.DisableSlider(GVAR.OptionsFrame.LayoutSpace)

	GVAR.OptionsFrame.SummaryText:SetTextColor(0.5, 0.5, 0.5, 1)
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.SummaryToggle)
	TEMPLATE.DisableSlider(GVAR.OptionsFrame.SummaryScale)
	TEMPLATE.DisableSlider(GVAR.OptionsFrame.SummaryPosition)

	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowRole)
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowSpec)
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ClassIcon)
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowLeader)
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowRealm)
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowPVPTrinket)

	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowTargetIndicator)
	TEMPLATE.DisableSlider(GVAR.OptionsFrame.TargetScaleSlider)
	TEMPLATE.DisableSlider(GVAR.OptionsFrame.TargetPositionSlider)
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowFocusIndicator)
	TEMPLATE.DisableSlider(GVAR.OptionsFrame.FocusScaleSlider)
	TEMPLATE.DisableSlider(GVAR.OptionsFrame.FocusPositionSlider)
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowFlag)
	TEMPLATE.DisableSlider(GVAR.OptionsFrame.FlagScaleSlider)
	TEMPLATE.DisableSlider(GVAR.OptionsFrame.FlagPositionSlider)
	GVAR.OptionsFrame.CarrierSwitchDisableFunc()
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowAssist)
	TEMPLATE.DisableSlider(GVAR.OptionsFrame.AssistScaleSlider)
	TEMPLATE.DisableSlider(GVAR.OptionsFrame.AssistPositionSlider)

	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowFTargetCount)
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowETargetCount)
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.TargetofTarget)
	TEMPLATE.DisableSlider(GVAR.OptionsFrame.ToTScaleSlider)
	TEMPLATE.DisableSlider(GVAR.OptionsFrame.ToTPositionSlider)

	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowHealthBar)
	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.ShowHealthText)

	TEMPLATE.DisableCheckButton(GVAR.OptionsFrame.RangeCheck)
	GVAR.OptionsFrame.RangeCheckInfo:Disable() Desaturation(GVAR.OptionsFrame.RangeCheckInfo.Texture, true)
	TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.RangeDisplayPullDown)

	TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.SortByPullDown)
	GVAR.OptionsFrame.SortByTitle:SetTextColor(0.5, 0.5, 0.5, 1)
	TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.SortDetailPullDown)
	GVAR.OptionsFrame.SortInfo:Disable() Desaturation(GVAR.OptionsFrame.SortInfo.Texture, true)

	TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.FontNamePullDown)
	GVAR.OptionsFrame.FontNameTitle:SetTextColor(0.5, 0.5, 0.5, 1)
	TEMPLATE.DisableSlider(GVAR.OptionsFrame.FontNameSlider)
	TEMPLATE.DisablePullDownMenu(GVAR.OptionsFrame.FontNumberPullDown)
	GVAR.OptionsFrame.FontNumberTitle:SetTextColor(0.5, 0.5, 0.5, 1)
	TEMPLATE.DisableSlider(GVAR.OptionsFrame.FontNumberSlider)

	TEMPLATE.DisableSlider(GVAR.OptionsFrame.ScaleSlider)
	GVAR.OptionsFrame.ScaleTitle:SetTextColor(0.5, 0.5, 0.5, 1)
	TEMPLATE.DisableSlider(GVAR.OptionsFrame.WidthSlider)
	GVAR.OptionsFrame.WidthTitle:SetTextColor(0.5, 0.5, 0.5, 1)
	TEMPLATE.DisableSlider(GVAR.OptionsFrame.HeightSlider)
	GVAR.OptionsFrame.HeightTitle:SetTextColor(0.5, 0.5, 0.5, 1)
	GVAR.OptionsFrame.TestShuffler:Hide()
end



function BattlegroundTargets:EnableInsecureConfigWidges()
	local BattlegroundTargets_Options = BattlegroundTargets_Options

	TEMPLATE.EnableTabButton(GVAR.OptionsFrame.TabGeneral, true)
	TEMPLATE.EnableTabButton(GVAR.OptionsFrame.TabRaidSize10, BattlegroundTargets_Options.Friend.EnableBracket[10] or BattlegroundTargets_Options.Enemy.EnableBracket[10])
	TEMPLATE.EnableTabButton(GVAR.OptionsFrame.TabRaidSize15, BattlegroundTargets_Options.Friend.EnableBracket[15] or BattlegroundTargets_Options.Enemy.EnableBracket[15])
	TEMPLATE.EnableTabButton(GVAR.OptionsFrame.TabRaidSize40, BattlegroundTargets_Options.Friend.EnableBracket[40] or BattlegroundTargets_Options.Enemy.EnableBracket[40])

	TEMPLATE.EnableTabButton(GVAR.OptionsFrame.EnableFriendBracket, BattlegroundTargets_Options.Friend.EnableBracket[testSize])
	TEMPLATE.EnableTabButton(GVAR.OptionsFrame.EnableEnemyBracket, BattlegroundTargets_Options.Enemy.EnableBracket[testSize])

	TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.EnableFraction)
	TEMPLATE.EnableCheckButton(GVAR.OptionsFrame.Minimap)

	BattlegroundTargets:CheckForEnabledBracket(testSize, fraction)
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:SetupMainFrameLayout(side)
	if inCombat or InCombatLockdown() then
		reCheckBG = true
		return
	end

	local BattlegroundTargets_Options = BattlegroundTargets_Options

	local LayoutTH    = BattlegroundTargets_Options[side].LayoutTH[currentSize]
	local LayoutSpace = BattlegroundTargets_Options[side].LayoutSpace[currentSize]
	local isToTFX -- target_of_target
	if BattlegroundTargets_Options[side].ButtonToTToggle[currentSize] and BattlegroundTargets_Options[side].ButtonToTPosition[currentSize] >= 9 then
		isToTFX = true
	end

	local button = GVAR[side.."Button"]

	if currentSize == 10 then
		for i = 1, currentSize do
			if LayoutTH == 81 then
				if i == 6 then
					button[i]:ClearAllPoints()
					button[i]:SetPoint("TOPLEFT", button[1], "TOPRIGHT", LayoutSpace, 0)
				elseif i > 1 then
					button[i]:ClearAllPoints()
					if isToTFX then
						button[i]:SetPoint("TOPRIGHT", button[(i-1)].ToTButton, "BOTTOMRIGHT", 0, 0)
					else
						button[i]:SetPoint("TOPLEFT", button[(i-1)], "BOTTOMLEFT", 0, 0)
					end
				end
			elseif LayoutTH == 18 then
				if i > 1 then
					button[i]:ClearAllPoints()
					if isToTFX then
						button[i]:SetPoint("TOPRIGHT", button[(i-1)].ToTButton, "BOTTOMRIGHT", 0, 0)
					else
						button[i]:SetPoint("TOPLEFT", button[(i-1)], "BOTTOMLEFT", 0, 0)
					end
				end
			end
		end
	elseif currentSize == 15 then
		for i = 1, currentSize do
			if LayoutTH == 81 then
				if i == 6 then
					button[i]:ClearAllPoints()
					button[i]:SetPoint("TOPLEFT", button[1], "TOPRIGHT", LayoutSpace, 0)
				elseif i == 11 then
					button[i]:ClearAllPoints()
					button[i]:SetPoint("TOPLEFT", button[6], "TOPRIGHT", LayoutSpace, 0)
				elseif i > 1 then
					button[i]:ClearAllPoints()
					if isToTFX then
						button[i]:SetPoint("TOPRIGHT", button[(i-1)].ToTButton, "BOTTOMRIGHT", 0, 0)
					else
						button[i]:SetPoint("TOPLEFT", button[(i-1)], "BOTTOMLEFT", 0, 0)
					end
				end
			elseif LayoutTH == 18 then
				if i > 1 then
					button[i]:ClearAllPoints()
					if isToTFX then
						button[i]:SetPoint("TOPRIGHT", button[(i-1)].ToTButton, "BOTTOMRIGHT", 0, 0)
					else
						button[i]:SetPoint("TOPLEFT", button[(i-1)], "BOTTOMLEFT", 0, 0)
					end
				end
			end
		end
	elseif currentSize == 40 then
		for i = 1, currentSize do
			if LayoutTH == 81 then
				if i == 6 then
					button[i]:ClearAllPoints()
					button[i]:SetPoint("TOPLEFT", button[1], "TOPRIGHT", LayoutSpace, 0)
				elseif i == 11 then
					button[i]:ClearAllPoints()
					button[i]:SetPoint("TOPLEFT", button[6], "TOPRIGHT", LayoutSpace, 0)
				elseif i == 16 then
					button[i]:ClearAllPoints()
					button[i]:SetPoint("TOPLEFT", button[11], "TOPRIGHT", LayoutSpace, 0)
				elseif i == 21 then
					button[i]:ClearAllPoints()
					button[i]:SetPoint("TOPLEFT", button[16], "TOPRIGHT", LayoutSpace, 0)
				elseif i == 26 then
					button[i]:ClearAllPoints()
					button[i]:SetPoint("TOPLEFT", button[21], "TOPRIGHT", LayoutSpace, 0)
				elseif i == 31 then
					button[i]:ClearAllPoints()
					button[i]:SetPoint("TOPLEFT", button[26], "TOPRIGHT", LayoutSpace, 0)
				elseif i == 36 then
					button[i]:ClearAllPoints()
					button[i]:SetPoint("TOPLEFT", button[31], "TOPRIGHT", LayoutSpace, 0)
				elseif i > 1 then
					button[i]:ClearAllPoints()
					if isToTFX then
						button[i]:SetPoint("TOPRIGHT", button[(i-1)].ToTButton, "BOTTOMRIGHT", 0, 0)
					else
						button[i]:SetPoint("TOPLEFT", button[(i-1)], "BOTTOMLEFT", 0, 0)
					end
				end
			elseif LayoutTH == 42 then
				if i == 11 then
					button[i]:ClearAllPoints()
					button[i]:SetPoint("TOPLEFT", button[1], "TOPRIGHT", LayoutSpace, 0)
				elseif i == 21 then
					button[i]:ClearAllPoints()
					button[i]:SetPoint("TOPLEFT", button[11], "TOPRIGHT", LayoutSpace, 0)
				elseif i == 31 then
					button[i]:ClearAllPoints()
					button[i]:SetPoint("TOPLEFT", button[21], "TOPRIGHT", LayoutSpace, 0)
				elseif i > 1 then
					button[i]:ClearAllPoints()
					if isToTFX then
						button[i]:SetPoint("TOPRIGHT", button[(i-1)].ToTButton, "BOTTOMRIGHT", 0, 0)
					else
						button[i]:SetPoint("TOPLEFT", button[(i-1)], "BOTTOMLEFT", 0, 0)
					end
				end
			elseif LayoutTH == 24 then
				if i == 21 then
					button[i]:ClearAllPoints()
					button[i]:SetPoint("TOPLEFT", button[1], "TOPRIGHT", LayoutSpace, 0)
				elseif i > 1 then
					button[i]:ClearAllPoints()
					if isToTFX then
						button[i]:SetPoint("TOPRIGHT", button[(i-1)].ToTButton, "BOTTOMRIGHT", 0, 0)
					else
						button[i]:SetPoint("TOPLEFT", button[(i-1)], "BOTTOMLEFT", 0, 0)
					end
				end
			elseif LayoutTH == 18 then
				if i > 1 then
					button[i]:ClearAllPoints()
					if isToTFX then
						button[i]:SetPoint("TOPRIGHT", button[(i-1)].ToTButton, "BOTTOMRIGHT", 0, 0)
					else
						button[i]:SetPoint("TOPLEFT", button[(i-1)], "BOTTOMLEFT", 0, 0)
					end
				end
			end
		end
	end
	BattlegroundTargets:SetupMonoblockPosition(side)
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:SetupMonoblockPosition(side) -- SUMPOSi
	local BattlegroundTargets_Options = BattlegroundTargets_Options

	local LayoutTH       = BattlegroundTargets_Options[side].LayoutTH[currentSize]
	local LayoutSpace    = BattlegroundTargets_Options[side].LayoutSpace[currentSize]
	local ButtonWidth    = BattlegroundTargets_Options[side].ButtonWidth[currentSize]
	local ButtonHeight   = BattlegroundTargets_Options[side].ButtonHeight[currentSize]
	local ButtonScale    = BattlegroundTargets_Options[side].ButtonScale[currentSize]
	local ButtonToTScale = BattlegroundTargets_Options[side].ButtonToTScale[currentSize]

	local totalWidth, totalHeight, totalToTHeight
	if currentSize == 10 then
		    if LayoutTH == 18 then totalWidth =    ButtonWidth                    totalHeight = 10*ButtonHeight totalToTHeight = totalHeight + (10*ButtonHeight*ButtonToTScale)
		elseif LayoutTH == 81 then totalWidth = (2*ButtonWidth) +    LayoutSpace  totalHeight =  5*ButtonHeight totalToTHeight = totalHeight + ( 5*ButtonHeight*ButtonToTScale)
		end
	elseif currentSize == 15 then
		    if LayoutTH == 18 then totalWidth =    ButtonWidth                    totalHeight = 15*ButtonHeight totalToTHeight = totalHeight + (15*ButtonHeight*ButtonToTScale)
		elseif LayoutTH == 81 then totalWidth = (3*ButtonWidth) + (2*LayoutSpace) totalHeight =  5*ButtonHeight totalToTHeight = totalHeight + ( 5*ButtonHeight*ButtonToTScale)
		end
	elseif currentSize == 40 then
		    if LayoutTH == 18 then totalWidth =    ButtonWidth                    totalHeight = 40*ButtonHeight totalToTHeight = totalHeight + (40*ButtonHeight*ButtonToTScale)
		elseif LayoutTH == 24 then totalWidth = (2*ButtonWidth) + (1*LayoutSpace) totalHeight = 20*ButtonHeight totalToTHeight = totalHeight + (20*ButtonHeight*ButtonToTScale)
		elseif LayoutTH == 42 then totalWidth = (4*ButtonWidth) + (3*LayoutSpace) totalHeight = 10*ButtonHeight totalToTHeight = totalHeight + (10*ButtonHeight*ButtonToTScale)
		elseif LayoutTH == 81 then totalWidth = (8*ButtonWidth) + (7*LayoutSpace) totalHeight =  5*ButtonHeight totalToTHeight = totalHeight + ( 5*ButtonHeight*ButtonToTScale)
		end
	end

	if BattlegroundTargets_Options[side].ButtonToTToggle[currentSize] and BattlegroundTargets_Options[side].ButtonToTPosition[currentSize] >= 9 then -- target_of_target
		totalHeight = totalToTHeight
	end

	if inBattleground and isDeadUpdateStop then
		GVAR[side.."IsGhostTexture"]:Show()
	end

	local MainFrame = GVAR[side.."MainFrame"]
	MainFrame:SetClampRectInsets(0, totalWidth*ButtonScale, 0, -(totalHeight*ButtonScale)) -- CLAMP_FIX_MAIN TODO
	MainFrame.MonoblockAnchor:SetSize(totalWidth, totalHeight)
	MainFrame.MainMoverFrame:SetSize(totalWidth, totalHeight)
	MainFrame.MainMoverButton:SetSize(totalWidth, totalHeight)

	local moverwidth = totalWidth*ButtonScale
	if moverwidth < 200 then
		moverwidth = 200
	end
	MainFrame.MainMoverButton[1]:SetWidth(moverwidth+40)
	MainFrame.MainMoverButton[2]:SetWidth(moverwidth+40)

	if BattlegroundTargets_Options[side].SummaryToggle[currentSize] then -- SUMMARY
		local SummaryPos = BattlegroundTargets_Options[side].SummaryPos[currentSize]
		local a1, a2, x, y
		    if SummaryPos == 1 then a1="TOP"         a2="BOTTOM"      x=  0 y=-10 --   0
		elseif SummaryPos == 2 then a1="TOPRIGHT"    a2="BOTTOMLEFT"  x=-10 y=-10 --  45
		elseif SummaryPos == 3 then a1="RIGHT"       a2="LEFT"        x=-10 y=  0 --  90
		elseif SummaryPos == 4 then a1="BOTTOMRIGHT" a2="TOPLEFT"     x=-10 y= 10 -- 135
		elseif SummaryPos == 5 then a1="BOTTOM"      a2="TOP"         x=  0 y= 10 -- 180
		elseif SummaryPos == 6 then a1="BOTTOMLEFT"  a2="TOPRIGHT"    x= 10 y= 10 -- 225
		elseif SummaryPos == 7 then a1="LEFT"        a2="RIGHT"       x= 10 y=  0 -- 270
		elseif SummaryPos == 8 then a1="TOPLEFT"     a2="BOTTOMRIGHT" x= 10 y=-10 -- 315
		elseif SummaryPos == 9 then a1="TOP"         a2="BOTTOM"      x=  0 y=-10 -- 360 => indie pos TODO
		else                        a1="TOP"         a2="BOTTOM"      x=  0 y=-10
		end

		local Summary = GVAR[side.."Summary"]
		Summary:ClearAllPoints()
		Summary:SetPoint(a1, GVAR[side.."MainFrame"].MonoblockAnchor, a2, x, y)
		Summary:SetScale(BattlegroundTargets_Options[side].SummaryScale[currentSize])
		Summary:Show()
	else
		GVAR[side.."Summary"]:Hide()
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:SetupButtonLayout(side)
	if inCombat or InCombatLockdown() then
		reSetLayout = true
		return
	end

	BattlegroundTargets:SetupMainFrameLayout(side)

	local BattlegroundTargets_Options = BattlegroundTargets_Options

	local ButtonScale              = BattlegroundTargets_Options[side].ButtonScale[currentSize]
	local ButtonWidth              = BattlegroundTargets_Options[side].ButtonWidth[currentSize]
	local ButtonHeight             = BattlegroundTargets_Options[side].ButtonHeight[currentSize]
	local ButtonFontNameSize       = BattlegroundTargets_Options[side].ButtonFontNameSize[currentSize]
	local fButtonFontNameStyle     = fontStyles[ BattlegroundTargets_Options[side].ButtonFontNameStyle[currentSize] ].font
	local ButtonFontNumberSize     = BattlegroundTargets_Options[side].ButtonFontNumberSize[currentSize]
	local fButtonFontNumberStyle   = fontStyles[ BattlegroundTargets_Options[side].ButtonFontNumberStyle[currentSize] ].font
	local ButtonRoleToggle         = BattlegroundTargets_Options[side].ButtonRoleToggle[currentSize]
	local ButtonSpecToggle         = BattlegroundTargets_Options[side].ButtonSpecToggle[currentSize]
	local ButtonClassToggle        = BattlegroundTargets_Options[side].ButtonClassToggle[currentSize]
	local ButtonFTargetCountToggle = BattlegroundTargets_Options[side].ButtonFTargetCountToggle[currentSize]
	local ButtonETargetCountToggle = BattlegroundTargets_Options[side].ButtonETargetCountToggle[currentSize]
	local ButtonTargetToggle       = BattlegroundTargets_Options[side].ButtonTargetToggle[currentSize]
	local ButtonTargetScale        = BattlegroundTargets_Options[side].ButtonTargetScale[currentSize]
	local ButtonTargetPosition     = BattlegroundTargets_Options[side].ButtonTargetPosition[currentSize]
	local ButtonFocusToggle        = BattlegroundTargets_Options[side].ButtonFocusToggle[currentSize]
	local ButtonFocusScale         = BattlegroundTargets_Options[side].ButtonFocusScale[currentSize]
	local ButtonFocusPosition      = BattlegroundTargets_Options[side].ButtonFocusPosition[currentSize]
	local ButtonFlagToggle         = BattlegroundTargets_Options[side].ButtonFlagToggle[currentSize]
	local ButtonFlagScale          = BattlegroundTargets_Options[side].ButtonFlagScale[currentSize]
	local ButtonFlagPosition       = BattlegroundTargets_Options[side].ButtonFlagPosition[currentSize]
	local ButtonAssistToggle       = BattlegroundTargets_Options[side].ButtonAssistToggle[currentSize]
	local ButtonAssistScale        = BattlegroundTargets_Options[side].ButtonAssistScale[currentSize]
	local ButtonAssistPosition     = BattlegroundTargets_Options[side].ButtonAssistPosition[currentSize]
	local ButtonRangeToggle        = BattlegroundTargets_Options[side].ButtonRangeToggle[currentSize]
	local ButtonRangeDisplay       = BattlegroundTargets_Options[side].ButtonRangeDisplay[currentSize]

	local B_uttonWidth_2  = ButtonWidth-2
	local B_uttonHeight_2 = ButtonHeight-2

	local fallbackFontSize = ButtonFontNameSize
	if ButtonHeight < ButtonFontNameSize then
		fallbackFontSize = ButtonHeight
	end

	local withIconWidth
	local iconNum = 0
	if ButtonRoleToggle and ButtonSpecToggle and ButtonClassToggle then
		iconNum = 3
	elseif (ButtonRoleToggle and ButtonSpecToggle) or (ButtonRoleToggle and ButtonClassToggle) or (ButtonSpecToggle and ButtonClassToggle) then
		iconNum = 2
	elseif ButtonRoleToggle or ButtonSpecToggle or ButtonClassToggle then
		iconNum = 1
	end
	local rangedisplayWidth = B_uttonHeight_2--/1.66--old:B_uttonHeight_2/2
	if ButtonRangeToggle and ButtonRangeDisplay < 7 then -- RANGE_DISP_LAY
		withIconWidth = (ButtonWidth - ( (B_uttonHeight_2*iconNum) + (rangedisplayWidth) ) ) - 2
	else
		withIconWidth = (ButtonWidth -   (B_uttonHeight_2*iconNum)                         ) - 2
	end

	local targetcountWidth = ButtonFontNumberSize * 1.5
	if ButtonFTargetCountToggle and ButtonETargetCountToggle then
		DATA[side].healthBarWidth = withIconWidth - targetcountWidth - targetcountWidth
	elseif ButtonFTargetCountToggle or ButtonETargetCountToggle then
		DATA[side].healthBarWidth = withIconWidth - targetcountWidth
	else
		DATA[side].healthBarWidth = withIconWidth
	end

	if ButtonRoleToggle then
		DATA[side].totHealthBarWidth = (ButtonWidth - (B_uttonHeight_2*2)) - 2
	else
		DATA[side].totHealthBarWidth = (ButtonWidth - (B_uttonHeight_2*1)) - 2
	end

	------------------------------
	local ButtonTargetToggle_quad
	local ButtonTargetToggle_leftPos
	if ButtonTargetToggle then
		ButtonTargetToggle_quad = B_uttonHeight_2 * ButtonTargetScale
		ButtonTargetToggle_leftPos = -ButtonTargetToggle_quad
		if ButtonTargetPosition >= 100 then
			ButtonTargetToggle_leftPos = ButtonWidth
		elseif ButtonTargetPosition > 0 then
			ButtonTargetToggle_leftPos = ( (ButtonTargetToggle_quad + ButtonWidth) * (ButtonTargetPosition/100) ) - ButtonTargetToggle_quad
		end
	end

	local ButtonFocusToggle_quad
	local ButtonFocusToggle_leftPos
	if ButtonFocusToggle then
		ButtonFocusToggle_quad = B_uttonHeight_2 * ButtonFocusScale
		ButtonFocusToggle_leftPos = -ButtonFocusToggle_quad
		if ButtonFocusPosition >= 100 then
			ButtonFocusToggle_leftPos = ButtonWidth
		elseif ButtonFocusPosition > 0 then
			ButtonFocusToggle_leftPos = ( (ButtonFocusToggle_quad + ButtonWidth) * (ButtonFocusPosition/100) ) - ButtonFocusToggle_quad
		end
	end

	local ButtonFlagToggle_quad
	local ButtonFlagToggle_leftPos
	local ButtonFlagToggle_orbcornerSize
	if ButtonFlagToggle then
		ButtonFlagToggle_quad = B_uttonHeight_2 * ButtonFlagScale
		ButtonFlagToggle_leftPos = -ButtonFlagToggle_quad
		if ButtonFlagPosition >= 100 then
			ButtonFlagToggle_leftPos = ButtonWidth
		elseif ButtonFlagPosition > 0 then
			ButtonFlagToggle_leftPos = ( (ButtonFlagToggle_quad + ButtonWidth) * (ButtonFlagPosition/100) ) - ButtonFlagToggle_quad
		end
		ButtonFlagToggle_orbcornerSize = B_uttonHeight_2/4
	end

	local ButtonAssistToggle_quad
	local ButtonAssistToggle_leftPos
	if ButtonAssistToggle then
		ButtonAssistToggle_quad = B_uttonHeight_2 * ButtonAssistScale
		ButtonAssistToggle_leftPos = -ButtonAssistToggle_quad
		if ButtonAssistPosition >= 100 then
			ButtonAssistToggle_leftPos = ButtonWidth
		elseif ButtonAssistPosition > 0 then
			ButtonAssistToggle_leftPos = ( (ButtonAssistToggle_quad + ButtonWidth) * (ButtonAssistPosition/100) ) - ButtonAssistToggle_quad
		end
	end

	local ButtonGroupSymbolSize = B_uttonHeight_2/1.25
	------------------------------

	local bbutton = GVAR[side.."Button"]
	for i = 1, currentSize do
		local button = bbutton[i]

		local lvl = button:GetFrameLevel()
		button.HealthTextButton:SetFrameLevel(lvl+1) -- xBUT
		button.ToTButton:SetFrameLevel(lvl+1)
		button.TargetTextureButton:SetFrameLevel(lvl+2)
		button.AssistTextureButton:SetFrameLevel(lvl+3)
		button.FocusTextureButton:SetFrameLevel(lvl+4)
		button.FlagTextureButton:SetFrameLevel(lvl+5)
		button.FlagDebuffButton:SetFrameLevel(lvl+6)

		button:SetScale(ButtonScale)

		button:SetSize(ButtonWidth, ButtonHeight)
		button.HighlightT:SetWidth(ButtonWidth)
		button.HighlightR:SetHeight(ButtonHeight)
		button.HighlightB:SetWidth(ButtonWidth)
		button.HighlightL:SetHeight(ButtonHeight)
		button.BackgroundX:SetSize(B_uttonWidth_2, B_uttonHeight_2)

		if ButtonRangeToggle and ButtonRangeDisplay < 7 then -- RANGE_DISP_LAY
			button.RangeTexture:Show()
			button.RangeTexture:SetSize(rangedisplayWidth, B_uttonHeight_2)
			button.RangeTxt:SetFont(fButtonFontNumberStyle, ButtonFontNumberSize-1, "OUTLINE")
			button.RangeTxt:SetHeight(fallbackFontSize)
		else
			button.RangeTexture:Hide()
			button.RangeTxt:Hide()
		end

		button.LeaderTexture:SetSize(ButtonGroupSymbolSize, ButtonGroupSymbolSize)
		button.LeaderTexture:SetPoint("LEFT", button, "LEFT", -(ButtonGroupSymbolSize/2), 0)

		-- role spec classicon
		button.RoleTexture:SetSize(B_uttonHeight_2, B_uttonHeight_2)
		button.SpecTexture:SetSize(B_uttonHeight_2, B_uttonHeight_2)
		button.ClassTexture:SetSize(B_uttonHeight_2, B_uttonHeight_2)

		if ButtonRoleToggle and ButtonSpecToggle and ButtonClassToggle then
			button.RoleTexture:Show()
			button.SpecTexture:Show()
			button.ClassTexture:Show()

			if ButtonRangeToggle and ButtonRangeDisplay < 7 then -- RANGE_DISP_LAY
				button.RoleTexture:SetPoint("LEFT", button.RangeTexture, "RIGHT", 0, 0)
			else
				button.RoleTexture:SetPoint("LEFT", button, "LEFT", 1, 0)
			end
			button.SpecTexture:SetPoint("LEFT", button.RoleTexture, "RIGHT", 0, 0)
			button.ClassTexture:SetPoint("LEFT", button.SpecTexture, "RIGHT", 0, 0)
			button.ClassColorBackground:SetPoint("LEFT", button.ClassTexture, "RIGHT", 0, 0)
		elseif ButtonRoleToggle and ButtonSpecToggle then
			button.RoleTexture:Show()
			button.SpecTexture:Show()
			button.ClassTexture:Hide()

			if ButtonRangeToggle and ButtonRangeDisplay < 7 then -- RANGE_DISP_LAY
				button.RoleTexture:SetPoint("LEFT", button.RangeTexture, "RIGHT", 0, 0)
			else
				button.RoleTexture:SetPoint("LEFT", button, "LEFT", 1, 0)
			end
			button.SpecTexture:SetPoint("LEFT", button.RoleTexture, "RIGHT", 0, 0)
			button.ClassColorBackground:SetPoint("LEFT", button.SpecTexture, "RIGHT", 0, 0)
		elseif ButtonRoleToggle and ButtonClassToggle then
			button.RoleTexture:Show()
			button.SpecTexture:Hide()
			button.ClassTexture:Show()

			if ButtonRangeToggle and ButtonRangeDisplay < 7 then -- RANGE_DISP_LAY
				button.RoleTexture:SetPoint("LEFT", button.RangeTexture, "RIGHT", 0, 0)
			else
				button.RoleTexture:SetPoint("LEFT", button, "LEFT", 1, 0)
			end
			button.ClassTexture:SetPoint("LEFT", button.RoleTexture, "RIGHT", 0, 0)
			button.ClassColorBackground:SetPoint("LEFT", button.ClassTexture, "RIGHT", 0, 0)
		elseif ButtonSpecToggle and ButtonClassToggle then
			button.RoleTexture:Hide()
			button.SpecTexture:Show()
			button.ClassTexture:Show()

			if ButtonRangeToggle and ButtonRangeDisplay < 7 then -- RANGE_DISP_LAY
				button.SpecTexture:SetPoint("LEFT", button.RangeTexture, "RIGHT", 0, 0)
			else
				button.SpecTexture:SetPoint("LEFT", button, "LEFT", 1, 0)
			end
			button.ClassTexture:SetPoint("LEFT", button.SpecTexture, "RIGHT", 0, 0)
			button.ClassColorBackground:SetPoint("LEFT", button.ClassTexture, "RIGHT", 0, 0)
		elseif ButtonRoleToggle then
			button.RoleTexture:Show()
			button.SpecTexture:Hide()
			button.ClassTexture:Hide()

			if ButtonRangeToggle and ButtonRangeDisplay < 7 then -- RANGE_DISP_LAY
				button.RoleTexture:SetPoint("LEFT", button.RangeTexture, "RIGHT", 0, 0)
			else
				button.RoleTexture:SetPoint("LEFT", button, "LEFT", 1, 0)
			end

			button.ClassColorBackground:SetPoint("LEFT", button.RoleTexture, "RIGHT", 0, 0)
		elseif ButtonSpecToggle then
			button.RoleTexture:Hide()
			button.SpecTexture:Show()
			button.ClassTexture:Hide()

			if ButtonRangeToggle and ButtonRangeDisplay < 7 then -- RANGE_DISP_LAY
				button.SpecTexture:SetPoint("LEFT", button.RangeTexture, "RIGHT", 0, 0)
			else
				button.SpecTexture:SetPoint("LEFT", button, "LEFT", 1, 0)
			end

			button.ClassColorBackground:SetPoint("LEFT", button.SpecTexture, "RIGHT", 0, 0)
		elseif ButtonClassToggle then
			button.RoleTexture:Hide()
			button.SpecTexture:Hide()
			button.ClassTexture:Show()

			if ButtonRangeToggle and ButtonRangeDisplay < 7 then -- RANGE_DISP_LAY
				button.ClassTexture:SetPoint("LEFT", button.RangeTexture, "RIGHT", 0, 0)
			else
				button.ClassTexture:SetPoint("LEFT", button, "LEFT", 1, 0)
			end

			button.ClassColorBackground:SetPoint("LEFT", button.ClassTexture, "RIGHT", 0, 0)
		else
			button.RoleTexture:Hide()
			button.SpecTexture:Hide()
			button.ClassTexture:Hide()

			if ButtonRangeToggle and ButtonRangeDisplay < 7 then -- RANGE_DISP_LAY
				button.ClassColorBackground:SetPoint("LEFT", button.RangeTexture, "RIGHT", 0, 0)
			else
				button.ClassColorBackground:SetPoint("LEFT", button, "LEFT", 1, 0)
			end
		end
		-- role spec classicon

		button.Name:SetFont(fButtonFontNameStyle, ButtonFontNameSize, "")
		button.Name:SetSize(DATA[side].healthBarWidth-2, fallbackFontSize)

		button.HealthBar:SetSize(DATA[side].healthBarWidth, B_uttonHeight_2)

		button.HealthText:SetFont(fButtonFontNumberStyle, ButtonFontNumberSize, "OUTLINE")
		button.HealthText:SetHeight(fallbackFontSize)

		button.ClassColorBackground:SetSize(DATA[side].healthBarWidth, B_uttonHeight_2)

		-- pvp_trinket_
		button.PVPTrinketTexture:SetSize(B_uttonHeight_2, B_uttonHeight_2)
		button.PVPTrinketTxt:SetFont(fButtonFontNumberStyle, ButtonFontNumberSize-1, "OUTLINE")
		button.PVPTrinketTxt:SetHeight(fallbackFontSize)

		-- target count
		if ButtonFTargetCountToggle and ButtonETargetCountToggle then
			button.TargetCountBackground:SetSize(targetcountWidth*2, B_uttonHeight_2)
			button.TargetCountBackground:Show()
		elseif ButtonFTargetCountToggle or ButtonETargetCountToggle then
			button.TargetCountBackground:SetSize(targetcountWidth, B_uttonHeight_2)
			button.TargetCountBackground:Show()
		else
			button.TargetCountBackground:Hide()
		end

		if ButtonFTargetCountToggle then
			button.FTargetCount:SetFont(fButtonFontNumberStyle, ButtonFontNumberSize, "")
			button.FTargetCount:SetSize(targetcountWidth, fallbackFontSize)
			button.FTargetCount:Show()
		else
			button.FTargetCount:Hide()
		end

		if ButtonETargetCountToggle then
			button.ETargetCount:SetFont(fButtonFontNumberStyle, ButtonFontNumberSize, "")
			button.ETargetCount:SetSize(targetcountWidth, fallbackFontSize)
			button.ETargetCount:Show()
		else
			button.ETargetCount:Hide()
		end
		-- target count

		if ButtonTargetToggle then
			button.TargetTexture:SetSize(ButtonTargetToggle_quad, ButtonTargetToggle_quad)
			button.TargetTexture:SetPoint("LEFT", button, "LEFT", ButtonTargetToggle_leftPos, 0)
			button.TargetTexture:Show()
		else
			button.TargetTexture:Hide()
		end

		if ButtonFocusToggle then
			button.FocusTexture:SetSize(ButtonFocusToggle_quad, ButtonFocusToggle_quad)
			button.FocusTexture:SetPoint("LEFT", button, "LEFT", ButtonFocusToggle_leftPos, 0)
			button.FocusTexture:Show()
		else
			button.FocusTexture:Hide()
		end

		if ButtonFlagToggle then
			button.FlagTexture:SetPoint("LEFT", button, "LEFT", ButtonFlagToggle_leftPos, 0)
			button.FlagTexture:Show()
			button.FlagDebuff:SetFont(fButtonFontNumberStyle, ButtonFontNumberSize-2, "OUTLINE")
			button.FlagDebuff:SetHeight(fallbackFontSize)
			button.FlagDebuff:Show()
			button.OrbCornerTL:SetSize(ButtonFlagToggle_orbcornerSize, ButtonFlagToggle_orbcornerSize)
			button.OrbCornerTR:SetSize(ButtonFlagToggle_orbcornerSize, ButtonFlagToggle_orbcornerSize)
			button.OrbCornerBL:SetSize(ButtonFlagToggle_orbcornerSize, ButtonFlagToggle_orbcornerSize)
			button.OrbCornerBR:SetSize(ButtonFlagToggle_orbcornerSize, ButtonFlagToggle_orbcornerSize)
			button.OrbCornerTL:Show()
			button.OrbCornerTR:Show()
			button.OrbCornerBL:Show()
			button.OrbCornerBR:Show()
		else
			button.FlagTexture:Hide()
			button.FlagDebuff:Hide()
			button.OrbCornerTL:Hide()
			button.OrbCornerTR:Hide()
			button.OrbCornerBL:Hide()
			button.OrbCornerBR:Hide()
		end

		if ButtonAssistToggle then
			button.AssistSourceTexture:SetSize(ButtonGroupSymbolSize, ButtonGroupSymbolSize)
			button.AssistSourceTexture:SetPoint("RIGHT", button, "RIGHT", (ButtonGroupSymbolSize/2), 0)
			button.AssistSourceTexture:Show()
			button.AssistTargetTexture:SetSize(ButtonAssistToggle_quad, ButtonAssistToggle_quad)
			button.AssistTargetTexture:SetPoint("LEFT", button, "LEFT", ButtonAssistToggle_leftPos, 0)
			button.AssistTargetTexture:Show()
		else
			button.AssistSourceTexture:Hide()
			button.AssistTargetTexture:Hide()
		end
	end

	if BattlegroundTargets_Options[side].ButtonToTToggle[currentSize] then -- target_of_target
		local ButtonToTScale    = BattlegroundTargets_Options[side].ButtonToTScale[currentSize]
		local ButtonToTPosition = BattlegroundTargets_Options[side].ButtonToTPosition[currentSize]

		local bbutton = GVAR[side.."Button"]
		for i = 1, currentSize do
			local button = bbutton[i]
			local ToTButton = button.ToTButton

			ToTButton:SetSize(ButtonWidth, ButtonHeight)

			local lvl = ToTButton:GetFrameLevel()
			ToTButton.HealthTextButton:SetFrameLevel(lvl+1) -- xBUT

			ToTButton.HighlightT:Hide()
			ToTButton.HighlightR:Hide()
			ToTButton.HighlightB:Hide()
			ToTButton.HighlightL:Hide()
			ToTButton.RangeTexture:Hide()
			ToTButton.RangeTxt:Hide()
			ToTButton.PVPTrinketTexture:Hide()
			ToTButton.PVPTrinketTxt:Hide()
			ToTButton.SpecTexture:Hide()
			ToTButton.ClassTexture:Hide()
			ToTButton.LeaderTexture:Hide()
			ToTButton.TargetCountBackground:Hide()
			ToTButton.FTargetCount:Hide()
			ToTButton.ETargetCount:Hide()
			ToTButton.TargetTextureButton:Hide()
			ToTButton.FocusTextureButton:Hide()
			ToTButton.FlagTextureButton:Hide()
			ToTButton.FlagDebuffButton:Hide()
			ToTButton.AssistTextureButton:Hide()

			ToTButton.BackgroundX:SetSize(ButtonWidth, ButtonHeight)

			ToTButton.FactionTexture:SetSize(B_uttonHeight_2-2, B_uttonHeight_2-2) -- -2
			if ButtonRoleToggle then
				ToTButton.RoleTexture:SetPoint("LEFT", ToTButton.FactionTexture, "RIGHT", 2, 0) -- -2
				ToTButton.RoleTexture:SetSize(B_uttonHeight_2, B_uttonHeight_2)
				ToTButton.RoleTexture:SetAlpha(1)
				ToTButton.ClassColorBackground:SetPoint("LEFT", ToTButton.RoleTexture, "RIGHT", 0, 0)
			else
				ToTButton.RoleTexture:SetAlpha(0)
				ToTButton.ClassColorBackground:SetPoint("LEFT", ToTButton.FactionTexture, "RIGHT", 2, 0) -- -2
			end

			ToTButton.ClassColorBackground:SetSize(DATA[side].totHealthBarWidth, B_uttonHeight_2)

			ToTButton.HealthBar:SetSize(DATA[side].totHealthBarWidth, B_uttonHeight_2)

			ToTButton.HealthText:SetFont(fButtonFontNumberStyle, ButtonFontNumberSize, "OUTLINE")
			ToTButton.HealthText:SetHeight(fallbackFontSize)

			ToTButton.Name:SetFont(fButtonFontNameStyle, ButtonFontNameSize, "")
			ToTButton.Name:SetSize(DATA[side].totHealthBarWidth - 2, fallbackFontSize)

			ToTButton:ClearAllPoints()
			if ButtonToTPosition == 1 then
				ToTButton:SetPoint("RIGHT", button, "LEFT", 0, 0)
			elseif ButtonToTPosition == 2 then
				ToTButton:SetPoint("RIGHT", button, "LEFT", -10, 0)
			elseif ButtonToTPosition == 3 then
				ToTButton:SetPoint("RIGHT", button, "LEFT", -20, 0)
			elseif ButtonToTPosition == 4 then
				ToTButton:SetPoint("RIGHT", button, "LEFT", -30, 0)
			elseif ButtonToTPosition == 5 then
				ToTButton:SetPoint("LEFT", button, "RIGHT", 0, 0)
			elseif ButtonToTPosition == 6 then
				ToTButton:SetPoint("LEFT", button, "RIGHT", 10, 0)
			elseif ButtonToTPosition == 7 then
				ToTButton:SetPoint("LEFT", button, "RIGHT", 20, 0)
			elseif ButtonToTPosition == 8 then
				ToTButton:SetPoint("LEFT", button, "RIGHT", 30, 0)
			elseif ButtonToTPosition == 9 then
				ToTButton:SetPoint("TOPRIGHT", button, "BOTTOMRIGHT", 0, 0)
			end

			button.HighlightR:ClearAllPoints()
			button.HighlightB:ClearAllPoints()
			button.HighlightL:ClearAllPoints()
			if ButtonToTPosition == 9 then
				button.HighlightR:SetPoint("TOPRIGHT", button.HighlightT, "TOPRIGHT", 0, 0)
				button.HighlightB:SetPoint("BOTTOMRIGHT", button.HighlightR, "BOTTOMRIGHT", 0, 0)
				button.HighlightL:SetPoint("TOPLEFT", button.HighlightT, "TOPLEFT", 0, 0)
			else
				button.HighlightR:SetPoint("RIGHT", 0, 0)
				button.HighlightB:SetPoint("BOTTOM", 0, 0)
				button.HighlightL:SetPoint("LEFT", 0, 0)
			end

			ToTButton:SetScale(ButtonToTScale)
		end
	end

	if BattlegroundTargets_Options[side].SummaryToggle[currentSize] then
		local Summary = GVAR[side.."Summary"]
		Summary.HealerFriend:SetFont(fButtonFontNumberStyle, ButtonFontNumberSize*2, "OUTLINE")
		Summary.HealerEnemy:SetFont(fButtonFontNumberStyle, ButtonFontNumberSize*2, "OUTLINE")
		Summary.TankFriend:SetFont(fButtonFontNumberStyle, ButtonFontNumberSize*2, "OUTLINE")
		Summary.TankEnemy:SetFont(fButtonFontNumberStyle, ButtonFontNumberSize*2, "OUTLINE")
		Summary.DamageFriend:SetFont(fButtonFontNumberStyle, ButtonFontNumberSize*2, "OUTLINE")
		Summary.DamageEnemy:SetFont(fButtonFontNumberStyle, ButtonFontNumberSize*2, "OUTLINE")
	end

	reSetLayout = false
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:SetupButtonTextures(side) -- BG_Faction_Dependent
	local BattlegroundTargets_Options = BattlegroundTargets_Options

	if BattlegroundTargets_Options[side].ButtonPvPTrinketToggle[currentSize] then -- pvp_trinket_
		local trinketTexture
		--[[if side == "Friend" then				---OLD
			if playerFactionDEF == 0 then
				trinketTexture = "Interface\\Icons\\INV_Jewelry_TrinketPVP_02" -- Horde
			else
				trinketTexture = "Interface\\Icons\\INV_Jewelry_TrinketPVP_01" -- Alliance
			end
		else
			if oppositeFactionBG == 0 then
				trinketTexture = "Interface\\Icons\\INV_Jewelry_TrinketPVP_02" -- Horde
			else
				trinketTexture = "Interface\\Icons\\INV_Jewelry_TrinketPVP_01" -- Alliance
			end
		end
		--]]
		if isLowLevel then 
			trinketTexture = 338784   --lowlevelpvptrinket3m
		else
			trinketTexture = 1322720  --newpvptalenttrinket2m
		end
		
		local button = GVAR[side.."Button"]
		for i = 1, currentSize do
			button[i].PVPTrinketTexture:SetTexture(trinketTexture)
		end
	end

	if not BattlegroundTargets_Options[side].ButtonFlagToggle[currentSize] then return end

	-- flag
	if isFlagBG == 1 or isFlagBG == 2 or isFlagBG == 3 then
		local flagIcon -- setup_flag_texture
		if playerFactionBG ~= playerFactionDEF then
			flagIcon = "Interface\\WorldStateFrame\\ColumnIcon-FlagCapture2" -- neutral_flag
		elseif playerFactionDEF == 0 then
			if isFlagBG == 2 then
				flagIcon = "Interface\\WorldStateFrame\\AllianceFlag"
			else
				flagIcon = "Interface\\WorldStateFrame\\HordeFlag"
			end
		else
			if isFlagBG == 2 then
				flagIcon = "Interface\\WorldStateFrame\\HordeFlag"
			else
				flagIcon = "Interface\\WorldStateFrame\\AllianceFlag"
			end
		end
		local quad = (BattlegroundTargets_Options[side].ButtonHeight[currentSize]-2) * BattlegroundTargets_Options[side].ButtonFlagScale[currentSize]
		local button = GVAR[side.."Button"]
		for i = 1, currentSize do
			button[i].FlagTexture:SetSize(quad, quad)
			button[i].FlagTexture:SetTexture(flagIcon)
			button[i].FlagTexture:SetTexCoord(0.15625001, 0.84374999, 0.15625001, 0.84374999)--(5/32, 27/32, 5/32, 27/32)
		end
	-- cart
	elseif isFlagBG == 4 then
		local flagIcon -- setup_flag_texture
		if playerFactionBG ~= playerFactionDEF then
			flagIcon = "Interface\\Minimap\\Vehicle-SilvershardMines-MineCart" -- neutral_flag
		elseif playerFactionDEF == 0 then
			flagIcon = "Interface\\Minimap\\Vehicle-SilvershardMines-MineCartRed"
		else
			flagIcon = "Interface\\Minimap\\Vehicle-SilvershardMines-MineCartBlue"
		end
		local quad = (BattlegroundTargets_Options[side].ButtonHeight[currentSize]-2) * BattlegroundTargets_Options[side].ButtonFlagScale[currentSize] * 1.1
		local button = GVAR[side.."Button"]
		for i = 1, currentSize do
			button[i].FlagTexture:SetSize(quad, quad)
			button[i].FlagTexture:SetTexture(flagIcon)
			button[i].FlagTexture:SetTexCoord(0.09375, 0.90625, 0.09375, 0.90625)--(3/32, 29/32, 3/32, 29/32)
		end
	-- orb
	elseif isFlagBG == 5 then
		local quad = (BattlegroundTargets_Options[side].ButtonHeight[currentSize]-2) * BattlegroundTargets_Options[side].ButtonFlagScale[currentSize] * 1.3
		local button = GVAR[side.."Button"]
		for i = 1, currentSize do
			button[i].FlagTexture:SetSize(quad, quad)
			button[i].FlagTexture:SetTexCoord(0.0625, 0.9375, 0.0625, 0.9375)--(2/32, 30/32, 2/32, 30/32)
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:RangeInfoText(buttonTxt)
	local rangeInfoTxt = ""
	for frc = 1, #FRAMES do
		local side = FRAMES[frc]
		local minRange, maxRange
		local rangeSpellCLASS = ranges[side][playerClassEN]
		if rangeSpellCLASS then
			local _, _, _, _, minR, maxR = GetSpellInfo(rangeSpellCLASS.id)
			minRange = minR
			maxRange = maxR
		end
		minRange = minRange or 0
		maxRange = maxRange or 0
		if side == "Friend" then
			rangeInfoTxt = rangeInfoTxt.."   "..L["Friendly Players"]..":\n\n"
		else
			rangeInfoTxt = rangeInfoTxt.."   "..L["Enemy Players"]..":\n\n"
		end
		rangeInfoTxt = rangeInfoTxt.."   |cffffffffCombatLog:|r 40 - max: |cffffff790-"..(40+maxRange).." (40+"..maxRange..")|r\n\n"
		rangeInfoTxt = rangeInfoTxt.."   |cffffffff"..L["Class"]..":|r\n"
		table_sort(class_IntegerSort, function(a, b) return a.loc < b.loc end)
		for i = 1, #class_IntegerSort do
			local classEN = class_IntegerSort[i].cid
			local rangeSpellId = ranges[side][classEN].id
			local rangeSpellLvl = ranges[side][classEN].lvl
			local name, _, _, _, minRange, maxRange = GetSpellInfo(rangeSpellId)
			local txtStr = "|cff"..classcolors[classEN].colorStr..class_IntegerSort[i].loc.."|r   "..(minRange or "?").."-"..(maxRange or "?").."   |cffffffff"..(name or L["Unknown"]).."|r   |cffbbbbbb(spell ID = "..rangeSpellId..", level = "..rangeSpellLvl..")|r"
			if classEN == playerClassEN then
				rangeInfoTxt = rangeInfoTxt..">>> "..txtStr.." <<<\n"
			else
				rangeInfoTxt = rangeInfoTxt.."     "..txtStr.."\n"
			end
		end
		if frc == 1 then
			rangeInfoTxt = rangeInfoTxt.."\n\n\n"
		end
	end
	buttonTxt:SetText(rangeInfoTxt)
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:Frame_Toggle(frame, show)
	if show then
		frame:Show()
	else
		if frame:IsShown() then
			frame:Hide()
		else
			frame:Show()
		end
	end
end

function BattlegroundTargets:Frame_SetupPosition(frameName, side)
	local BattlegroundTargets_Options = BattlegroundTargets_Options

	if frameName == "BattlegroundTargets_OptionsFrame" then
		local saveName = "OptionsFrame"
		local options = BattlegroundTargets_Options.FramePosition[saveName]
		if options then
			local x     = options.x or 0
			local y     = options.y or 0
			local point = options.point or "CENTER"
			local s     = options.s or 1
			_G[frameName]:ClearAllPoints()
			_G[frameName]:SetPoint(point, UIParent, point, x/s, y/s)
		else
			_G[frameName]:ClearAllPoints()
			_G[frameName]:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
		end
	else
		local saveName = side.."MainFrame"..currentSize
		local options = BattlegroundTargets_Options.FramePosition[saveName]
		if options then
			local x     = options.x or 0
			local y     = options.y or 0
			local point = options.point or "CENTER"
			local s     = options.s or 1
			_G[frameName]:ClearAllPoints()
			_G[frameName]:SetPoint(point, UIParent, point, x/s, y/s)
		else
			local x = -200
			if currentSize == 40 then
				x = -225
			end
			if side == "Enemy" then
				_G[frameName]:ClearAllPoints()
				_G[frameName]:SetPoint("TOPRIGHT", GVAR.OptionsFrame, "TOPLEFT", x, -400)
			else
				_G[frameName]:ClearAllPoints()
				_G[frameName]:SetPoint("TOPRIGHT", GVAR.OptionsFrame, "TOPLEFT", x, 0)
			end
			local X = _G[frameName]:GetLeft()
			local Y = _G[frameName]:GetTop()
			_G[frameName]:ClearAllPoints()
			_G[frameName]:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", X, Y)
		end
	end
end

function BattlegroundTargets:Frame_SavePosition(frameName, side)
	local BattlegroundTargets_Options = BattlegroundTargets_Options

	-- from LibWindow-1.1
	local frame = _G[frameName]
	local s = frame:GetScale()
	local left, top = frame:GetLeft()*s, frame:GetTop()*s
	local right, bottom = frame:GetRight()*s, frame:GetBottom()*s
	local pwidth, pheight = UIParent:GetWidth(), UIParent:GetHeight()
	local x, y, point
	if left < (pwidth-right) and left < abs((left+right)/2 - pwidth/2) then
		x = left
		point = "LEFT"
	elseif (pwidth-right) < abs((left+right)/2 - pwidth/2) then
		x = right-pwidth
		point = "RIGHT"
	else
		x = (left+right)/2 - pwidth/2
		point = ""
	end
	if bottom < (pheight-top) and bottom < abs((bottom+top)/2 - pheight/2) then
		y = bottom
		point = "BOTTOM"..point
	elseif (pheight-top) < abs((bottom+top)/2 - pheight/2) then
		y = top-pheight
		point = "TOP"..point
	else
		y = (bottom+top)/2 - pheight/2
	end
	if point == "" then
		point = "CENTER"
	end
	-- ------------------

	local saveName
	if frameName == "BattlegroundTargets_OptionsFrame" then
		saveName = "OptionsFrame"
		-- CLAMP_FIX_OPTIONS BEGIN
		local frameWidth = frame:GetWidth()
		--local frameHeight = frame:GetHeight()
		--print(floor(pwidth), floor(pheight), "#", "t:", floor(top), "l:", floor(left), "b:", floor(bottom), "r:", floor(right), "#", floor(frameWidth), floor(frameHeight))
		if -left > frameWidth-40 or -- LEFT
		   left > pwidth-40 or      -- RIGHT
		   bottom > pheight-40 or   -- TOP
		   top < 40                 -- BOTTOM
		then
			x = 0
			y = 0
			point = "CENTER"
			s = 1
		end
		-- CLAMP_FIX_OPTIONS END
	else
		saveName = side.."MainFrame"..currentSize
	end

	--print("saveName:", saveName, "x:", x, "y:", y, "point:", point, "scale:", s)

	BattlegroundTargets_Options.FramePosition[saveName] = {}
	BattlegroundTargets_Options.FramePosition[saveName].x = x
	BattlegroundTargets_Options.FramePosition[saveName].y = y
	BattlegroundTargets_Options.FramePosition[saveName].point = point
	BattlegroundTargets_Options.FramePosition[saveName].s = s

	_G[frameName]:ClearAllPoints()
	_G[frameName]:SetPoint(point, UIParent, point, x/s, y/s)
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:OptionsFrameHide()
	PlaySound163("igQuestListClose")
	isConfig = false
	BattlegroundTargets:EventRegister()
	TEMPLATE.EnableTextButton(GVAR.InterfaceOptions.CONFIG)

	for frc = 1, #FRAMES do
		local side = FRAMES[frc]
		DATA[side].MainMoverModeValue = false
		local MainFrame = side.."MainFrame"
		GVAR[MainFrame].MainMoverButton:Show()
		GVAR[MainFrame].MainMoverButton[1]:Show()
		GVAR[MainFrame].MainMoverButton[2]:Show()
		GVAR[MainFrame].MainMoverFrame:Hide()
		GVAR[MainFrame].MainMoverModeButton:SetChecked(false)
	end

	testData.Loaded = false
	BattlegroundTargets:DisableConfigMode()
end

function BattlegroundTargets:OptionsFrameShow()
	local BattlegroundTargets_Options = BattlegroundTargets_Options

	PlaySound163("igQuestListOpen")
	isConfig = true
	BattlegroundTargets:EventUnregister()
	TEMPLATE.DisableTextButton(GVAR.InterfaceOptions.CONFIG)

	BattlegroundTargets:Frame_SetupPosition("BattlegroundTargets_OptionsFrame")
	GVAR.OptionsFrame:StartMoving()
	GVAR.OptionsFrame:StopMovingOrSizing()

	if inBattleground then
		testSize = currentSize
	end

	GVAR.OptionsFrame.ConfigGeneral:Hide()
	GVAR.OptionsFrame.ConfigBrackets:Show()

	if testSize == 10 then
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabGeneral, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize10, true)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize15, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize40, nil)
	elseif testSize == 15 then
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabGeneral, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize10, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize15, true)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize40, nil)
	elseif testSize == 40 then
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabGeneral, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize10, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize15, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.TabRaidSize40, true)
	end

	if fraction == "Friend" then
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.EnableFriendBracket, true)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.EnableEnemyBracket, nil)
	else
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.EnableFriendBracket, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.EnableEnemyBracket, true)
	end

	if inCombat or InCombatLockdown() then
		BattlegroundTargets:DisableInsecureConfigWidges()
	else
		BattlegroundTargets:EnableInsecureConfigWidges()
	end

	if BattlegroundTargets_Options.Friend.EnableBracket[testSize] or BattlegroundTargets_Options.Enemy.EnableBracket[testSize] then
		BattlegroundTargets:EnableConfigMode()
	else
		BattlegroundTargets:DisableConfigMode()
	end
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:LocalizedFontNameTest(show, font)
	local BattlegroundTargets_Options = BattlegroundTargets_Options
	for frc = 1, #FRAMES do
		local side = FRAMES[frc]
		-- ----------
		if BattlegroundTargets_Options[side].EnableBracket[currentSize] then
			local button = GVAR[side.."Button"]
			if show then
				if font then
					local f = fontStyles[font].font
					local s = BattlegroundTargets_Options[side].ButtonFontNameSize[currentSize]
					for i = 1, currentSize do
						button[i].Name:SetFont(f, s, "")
					end
					if BattlegroundTargets_Options[side].ButtonToTToggle[currentSize] then -- target_of_target
						for i = 1, currentSize do
							button[i].ToTButton.Name:SetFont(f, s, "")
						end
					end
				end
				if IsModifierKeyDown() then return end
				button[1].Name:SetText(L["Test_abc_"])
				button[2].Name:SetText(L["Test_koKR_"])
				button[3].Name:SetText(L["Test_ruRU_"])
				button[4].Name:SetText(L["Test_zhCN_"])
				button[5].Name:SetText(L["Test_zhTW_"])
				button[6].Name:SetText(L["Test_Latin1_"])
				button[7].Name:SetText(L["Test_Latin2_"])
				button[8].Name:SetText(L["Test_Latin3_"])
				button[9].Name:SetText(L["Test_Latin4_"])
				button[10].Name:SetText(L["Test_Latin5_"])
			else
				if font then
					local f = fontStyles[ BattlegroundTargets_Options[side].ButtonFontNameStyle[currentSize] ].font
					local s = BattlegroundTargets_Options[side].ButtonFontNameSize[currentSize]
					for i = 1, currentSize do
						button[i].Name:SetFont(f, s, "")
					end
					if BattlegroundTargets_Options[side].ButtonToTToggle[currentSize] then -- target_of_target
						for i = 1, currentSize do
							button[i].ToTButton.Name:SetFont(f, s, "")
						end
					end
				end
				if isLowLevel then
					for i = 1, 10 do
						button[i].Name:SetText(playerLevel.." "..button[i].name4button)
					end
				else
					for i = 1, 10 do
						button[i].Name:SetText(button[i].name4button)
					end
				end
			end
		end
		-- ----------
	end
end

function BattlegroundTargets:LocalizedFontNumberTest(show, font)
	local BattlegroundTargets_Options = BattlegroundTargets_Options
	for frc = 1, #FRAMES do
		local side = FRAMES[frc]
		-- ----------
		if BattlegroundTargets_Options[side].EnableBracket[currentSize] then
			local button = GVAR[side.."Button"]
			if show then
				local f = fontStyles[font].font
				local s = BattlegroundTargets_Options[side].ButtonFontNumberSize[currentSize]
				for i = 1, currentSize do
					button[i].HealthText:SetFont(f, s, "OUTLINE")
					button[i].FTargetCount:SetFont(f, s, "")
					button[i].ETargetCount:SetFont(f, s, "")
					button[i].FlagDebuff:SetFont(f, s-2, "OUTLINE")
					button[i].RangeTxt:SetFont(f, s-1, "OUTLINE")
					button[i].PVPTrinketTxt:SetFont(f, s-1, "OUTLINE")
				end
				if BattlegroundTargets_Options[side].ButtonToTToggle[currentSize] then -- target_of_target
					for i = 1, currentSize do
						button[i].ToTButton.HealthText:SetFont(f, s, "OUTLINE")
					end
				end
				local Summary = GVAR[side.."Summary"]
				Summary.HealerFriend:SetFont(f, s*2, "OUTLINE")
				Summary.HealerEnemy:SetFont(f, s*2, "OUTLINE")
				Summary.TankFriend:SetFont(f, s*2, "OUTLINE")
				Summary.TankEnemy:SetFont(f, s*2, "OUTLINE")
				Summary.DamageFriend:SetFont(f, s*2, "OUTLINE")
				Summary.DamageEnemy:SetFont(f, s*2, "OUTLINE")
			else
				local f = fontStyles[ BattlegroundTargets_Options[side].ButtonFontNumberStyle[currentSize] ].font
				local s = BattlegroundTargets_Options[side].ButtonFontNumberSize[currentSize]
				for i = 1, currentSize do
					button[i].HealthText:SetFont(f, s, "OUTLINE")
					button[i].FTargetCount:SetFont(f, s, "")
					button[i].ETargetCount:SetFont(f, s, "")
					button[i].FlagDebuff:SetFont(f, s-2, "OUTLINE")
					button[i].RangeTxt:SetFont(f, s-1, "OUTLINE")
					button[i].PVPTrinketTxt:SetFont(f, s-1, "OUTLINE")
				end
				if BattlegroundTargets_Options[side].ButtonToTToggle[currentSize] then -- target_of_target
					for i = 1, currentSize do
						button[i].ToTButton.HealthText:SetFont(f, s, "OUTLINE")
					end
				end
				local Summary = GVAR[side.."Summary"]
				Summary.HealerFriend:SetFont(f, s*2, "OUTLINE")
				Summary.HealerEnemy:SetFont(f, s*2, "OUTLINE")
				Summary.TankFriend:SetFont(f, s*2, "OUTLINE")
				Summary.TankEnemy:SetFont(f, s*2, "OUTLINE")
				Summary.DamageFriend:SetFont(f, s*2, "OUTLINE")
				Summary.DamageEnemy:SetFont(f, s*2, "OUTLINE")
			end
		end
		-- ----------
	end
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:EnableConfigMode()
	if inCombat or InCombatLockdown() then
		reCheckBG = true
		return
	end

	local BattlegroundTargets_Options = BattlegroundTargets_Options

	currentSize = testSize
	if not testData.Loaded then
		newTestData()
		testData.Loaded = true
	end

	for frc = 1, #FRAMES do
		local side = FRAMES[frc]

		DATA[side].MainData = testData[side].MainTestDATA[currentSize]

		if BattlegroundTargets_Options[side].EnableBracket[currentSize] then
			BattlegroundTargets:Frame_SetupPosition("BattlegroundTargets_"..side.."MainFrame", side)

			GVAR[side.."MainFrame"]:EnableMouse(true)
			GVAR[side.."MainFrame"]:SetAlpha(1)
			GVAR[side.."MainFrame"]:Show() -- POSiCHK
			GVAR[side.."MainFrame"].MainMoverButton:Show()
			GVAR[side.."ScoreUpdateTexture"]:Show()
			GVAR[side.."IsGhostTexture"]:Show()

			BattlegroundTargets:ShufflerFunc("ShuffleCheck", side)
			BattlegroundTargets:SetupButtonLayout(side)
			BattlegroundTargets:MainDataUpdate(side)
			BattlegroundTargets:SetConfigButtonValues(side)

			local button = GVAR[side.."Button"]
			for i = 1, 40 do
				if i < currentSize+1 then
					button[i]:Show()
				else
					button[i]:Hide()
				end
			end
		else
			GVAR[side.."MainFrame"]:Hide()
			local button = GVAR[side.."Button"]
			for i = 1, 40 do
				button[i]:Hide()
			end
		end

	end

	-- delete global_OnUpdate
	for frc = 1, #FRAMES do
		local side = FRAMES[frc]
		GVAR[side.."MainFrame"]:SetScript("OnUpdate", nil)
		GVAR[side.."ScreenShot_Timer_Button"]:SetScript("OnUpdate", nil)
		GVAR[side.."Target_Timer_Button"]:SetScript("OnUpdate", nil)
		GVAR[side.."PVPTrinket_Timer_Button"]:SetScript("OnUpdate", nil)
		GVAR[side.."RangeCheck_Timer_Button"]:SetScript("OnUpdate", nil)
	end

	if BattlegroundTargets_Options.Friend.EnableBracket[currentSize] or BattlegroundTargets_Options.Enemy.EnableBracket[currentSize] then
		BattlegroundTargets:SetOptions(fraction)
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:DisableConfigMode()
	if inCombat or InCombatLockdown() then
		reCheckBG = true
		return
	end

	currentSize = testSize
	BattlegroundTargets:SetOptions(fraction)

	GVAR.FriendMainFrame:Hide()
	GVAR.EnemyMainFrame:Hide()
	for i = 1, 40 do
		GVAR.FriendButton[i]:Hide()
		GVAR.EnemyButton[i]:Hide()
	end

	if isConfig then return end

	local curTime = GetTime()
	BattlegroundTargets.targetCountTimer = 0 -- immediate update
	scoreFrequency = 0 -- immediate update
	BattlegroundTargets:BattlefieldCheck()

	if not inBattleground then return end

	local BattlegroundTargets_Options = BattlegroundTargets_Options

	if BattlegroundTargets_Options.Friend.EnableBracket[currentSize] or BattlegroundTargets_Options.Enemy.EnableBracket[currentSize] then
		BattlegroundTargets:CheckIfPlayerIsGhost()

		if BattlegroundTargets_Options.Friend.ButtonTargetToggle[currentSize] or BattlegroundTargets_Options.Enemy.ButtonTargetToggle[currentSize] then
			BattlegroundTargets:CheckPlayerTarget()
		end
		if BattlegroundTargets_Options.Friend.ButtonAssistToggle[currentSize] or BattlegroundTargets_Options.Enemy.ButtonAssistToggle[currentSize] then
			BattlegroundTargets:CheckAssist()
		end
		if BattlegroundTargets_Options.Friend.ButtonFocusToggle[currentSize] or BattlegroundTargets_Options.Enemy.ButtonFocusToggle[currentSize] then
			BattlegroundTargets:CheckPlayerFocus()
		end
	end

	for frc = 1, #FRAMES do
		local side = FRAMES[frc]
		if BattlegroundTargets_Options[side].EnableBracket[currentSize] then

			if BattlegroundTargets_Options[side].ButtonRangeToggle[currentSize] then
				BattlegroundTargets:UpdateRange(side, curTime)
			end

			if BattlegroundTargets_Options[side].ButtonFlagToggle[currentSize] then
				if isFlagBG >= 1 and isFlagBG <= 4 then--if isFlagBG == 1 or isFlagBG == 2 or isFlagBG == 3 or isFlagBG == 4 then
					local button = GVAR[side.."Button"][ DATA[side].Name2Button[ DATA[side].hasFlag ] ]
					if button then
						button.FlagTexture:SetAlpha(1)
						BattlegroundTargets:SetFlagDebuff(button, flagDebuff)
					end
				elseif isFlagBG == 5 then
					for k, v in pairs(hasOrb) do
						local button = GVAR[side.."Button"][ DATA[side].Name2Button[ v.name ] ]
						if button then
							button.orbColor = k
							button.FlagTexture:SetAlpha(1)
							button.FlagTexture:SetTexture(orbIDs[ orbColIDs[k] ].texture)
							BattlegroundTargets:SetFlagDebuff(button, v.orbval)
							BattlegroundTargets:SetOrbCorner(button, k)
						end
					end
				end
			else
				BattlegroundTargets:CheckFlagCarrierEND()
			end

			if BattlegroundTargets_Options[side].ButtonLeaderToggle[currentSize] then -- leader_
				local button = GVAR[side.."Button"][ DATA[side].Name2Button[ DATA[side].isLeader ] ]
				if button then
					button.LeaderTexture:SetAlpha(1)
				end
			end

			if curTime - scoreLastUpdate >= scoreWarning then
				GVAR[side.."ScoreUpdateTexture"]:Show()
			else
				GVAR[side.."ScoreUpdateTexture"]:Hide()
			end

		end
	end

end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:SetConfigButtonValues(side)
	local BattlegroundTargets_Options = BattlegroundTargets_Options

	local ButtonHealthBarToggle    = BattlegroundTargets_Options[side].ButtonHealthBarToggle[currentSize]
	local ButtonHealthTextToggle   = BattlegroundTargets_Options[side].ButtonHealthTextToggle[currentSize]
	local ButtonRangeToggle        = BattlegroundTargets_Options[side].ButtonRangeToggle[currentSize]
	local ButtonRangeDisplay       = BattlegroundTargets_Options[side].ButtonRangeDisplay[currentSize]
	local ButtonFTargetCountToggle = BattlegroundTargets_Options[side].ButtonFTargetCountToggle[currentSize]
	local ButtonETargetCountToggle = BattlegroundTargets_Options[side].ButtonETargetCountToggle[currentSize]
	local ButtonPvPTrinketToggle   = BattlegroundTargets_Options[side].ButtonPvPTrinketToggle[currentSize]

	local button = GVAR[side.."Button"]
	for i = 1, currentSize do
		local button = button[i]

		-- target, focus, flag, assist, leader
		button.TargetTexture:SetAlpha(0)
		button.HighlightT:SetColorTexture(0, 0, 0, 1)
		button.HighlightR:SetColorTexture(0, 0, 0, 1)
		button.HighlightB:SetColorTexture(0, 0, 0, 1)
		button.HighlightL:SetColorTexture(0, 0, 0, 1)
		button.FocusTexture:SetAlpha(0)
		button.FlagTexture:SetAlpha(0)
		button.FlagDebuff:SetText("")
		button.OrbCornerTL:SetAlpha(0)
		button.OrbCornerTR:SetAlpha(0)
		button.OrbCornerBL:SetAlpha(0)
		button.OrbCornerBR:SetAlpha(0)
		button.AssistTargetTexture:SetAlpha(0)
		button.AssistSourceTexture:SetAlpha(0)
		button.LeaderTexture:SetAlpha(0)

		-- health
		if ButtonHealthBarToggle then
			local width = DATA[side].healthBarWidth * (testData[side].Health[i] / 100)
			width = math_max(0.01, width)
			width = math_min(DATA[side].healthBarWidth, width)
			button.HealthBar:SetWidth(width)
		else
			button.HealthBar:SetWidth(DATA[side].healthBarWidth)
		end
		if ButtonHealthTextToggle then
			button.HealthText:SetText(testData[side].Health[i])
		else
			button.HealthText:SetText("")
		end

		-- targetcount
		if ButtonFTargetCountToggle then
			button.FTargetCount:SetText(testData[side].targetFCount[i])
		else
			button.FTargetCount:SetText("0")
		end
		if ButtonETargetCountToggle then
			button.ETargetCount:SetText(testData[side].targetECount[i])
		else
			button.ETargetCount:SetText("0")
		end

		-- range
		if ButtonRangeToggle then
			if testData[side].Range[i] < 40 then
				BattlegroundTargets:Range_Display(true, button, testData[side].Range[i])
			else
				BattlegroundTargets:Range_Display(false, button, nil, ButtonRangeDisplay)
			end
		else
			BattlegroundTargets:Range_Display(true, button, nil)
		end

		-- pvp_trinket_
		if ButtonPvPTrinketToggle then
			if testData[side].PVPTrinket[i].isEnable == 1 then
				button.PVPTrinketTexture:SetAlpha(1)
				button.PVPTrinketTxt:SetText(testData[side].PVPTrinket[i].isTime)
			else
				button.PVPTrinketTexture:SetAlpha(0)
				button.PVPTrinketTxt:SetText("")
			end
		else
			button.PVPTrinketTexture:SetAlpha(0)
			button.PVPTrinketTxt:SetText("")
		end
	end

	-- target_of_target
	if BattlegroundTargets_Options[side].ButtonToTToggle[currentSize] then
		local ButtonHealthBarToggle = BattlegroundTargets_Options[side].ButtonHealthBarToggle[currentSize]
		local ButtonHealthTextToggle = BattlegroundTargets_Options[side].ButtonHealthTextToggle[currentSize]
		local button = GVAR[side.."Button"]
		for i = 1, currentSize do
			local ToTButton = button[i].ToTButton
			if testData[side].TargetofTarget[i].rnd <= 33 then
				local totName =    testData[side].TargetofTarget[i].totName
				local classToken = testData[side].TargetofTarget[i].classToken
				local talentSpec = Textures.RoleIcon[ testData[side].TargetofTarget[i].talentSpec ]
				local isEnemy =    testData[side].TargetofTarget[i].isEnemy
				local num =        testData[side].TargetofTarget[i].healthvalue
				local colR = classcolors[classToken].r
				local colG = classcolors[classToken].g
				local colB = classcolors[classToken].b
				local colR5 = colR*0.5
				local colG5 = colG*0.5
				local colB5 = colB*0.5

				ToTButton.Name:SetText(totName)
				ToTButton.RoleTexture:SetTexCoord(talentSpec[1], talentSpec[2], talentSpec[3], talentSpec[4])

				if isEnemy == 2 then
					ToTButton.FactionTexture:SetTexture(Textures.EnemyIcon.path)
					ToTButton.FactionTexture:SetTexCoord(unpack(Textures.EnemyIcon.coords))
				else
					ToTButton.FactionTexture:SetTexture(Textures.FriendIcon.path)
					ToTButton.FactionTexture:SetTexCoord(unpack(Textures.FriendIcon.coords))
				end

				if ButtonHealthBarToggle then
					ToTButton.ClassColorBackground:SetColorTexture(colR5, colG5, colB5, 1)
					ToTButton.HealthBar:SetColorTexture(colR, colG, colB, 1)
					local width = DATA[side].totHealthBarWidth * (num / 100)
					width = math_max(0.01, width)
					width = math_min(DATA[side].totHealthBarWidth, width)
					ToTButton.HealthBar:SetWidth(width)
				else
					--ToTButton.ClassColorBackground:SetColorTexture(colR5, colG5, colB5, 1)
					ToTButton.HealthBar:SetColorTexture(colR, colG, colB, 1)
				end
				if ButtonHealthTextToggle then
					ToTButton.HealthText:SetText(num)
				else
					ToTButton.HealthText:SetText("")
				end

				ToTButton:SetAlpha(1)
			else
				ToTButton:SetAlpha(0)
			end
		end
	else
		local button = GVAR[side.."Button"]
		for i = 1, currentSize do
			button[i].ToTButton:SetAlpha(0)
		end
	end

	-- leader, target, focus, flag, assist
	isTargetButton = nil
	if BattlegroundTargets_Options[side].ButtonTargetToggle[currentSize] then
		local button = GVAR[side.."Button"][testData[side].IconTarget]
		button.TargetTexture:SetAlpha(1)
		button.HighlightT:SetColorTexture(0.5, 0.5, 0.5, 1)
		button.HighlightR:SetColorTexture(0.5, 0.5, 0.5, 1)
		button.HighlightB:SetColorTexture(0.5, 0.5, 0.5, 1)
		button.HighlightL:SetColorTexture(0.5, 0.5, 0.5, 1)
		isTargetButton = button
	end
	if BattlegroundTargets_Options[side].ButtonFocusToggle[currentSize] then
		GVAR[side.."Button"][testData[side].IconFocus].FocusTexture:SetAlpha(1)
	end
	if BattlegroundTargets_Options[side].ButtonFlagToggle[currentSize] then
		if currentSize == 10 or currentSize == 15 then
			if testData.CarrierDisplay == "flag" then
				local quad = (BattlegroundTargets_Options[side].ButtonHeight[currentSize]-2) * BattlegroundTargets_Options[side].ButtonFlagScale[currentSize]
				local button = GVAR[side.."Button"][testData[side].IconFlag.button]
				button.FlagTexture:SetSize(quad, quad)
				button.FlagTexture:SetTexture(Textures.flagTexture)
				button.FlagTexture:SetTexCoord(0.15625001, 0.84374999, 0.15625001, 0.84374999)--(5/32, 27/32, 5/32, 27/32)
				button.FlagTexture:SetAlpha(1)
				button.FlagDebuff:SetText(testData[side].IconFlag.txt)
			elseif testData.CarrierDisplay == "orb" then
				local quad = (BattlegroundTargets_Options[side].ButtonHeight[currentSize]-2) * BattlegroundTargets_Options[side].ButtonFlagScale[currentSize] * 1.3
				for k, v in pairs(testData[side].IconOrb) do
					if v.button then
						local button = GVAR[side.."Button"][v.button]
						button.FlagTexture:SetSize(quad, quad)
						button.FlagTexture:SetTexture(orbIDs[ k ].texture)
						button.FlagTexture:SetTexCoord(0.0625, 0.9375, 0.0625, 0.9375)--(2/32, 30/32, 2/32, 30/32)
						button.FlagTexture:SetAlpha(1)
						BattlegroundTargets:SetFlagDebuff(button, v.orbval)
						BattlegroundTargets:SetOrbCorner(button, orbIDs[k].color)
					end
				end
			elseif testData.CarrierDisplay == "cart" then
				local quad = (BattlegroundTargets_Options[side].ButtonHeight[currentSize]-2) * BattlegroundTargets_Options[side].ButtonFlagScale[currentSize] * 1.1
				local button = GVAR[side.."Button"][testData[side].IconFlag.button]
				button.FlagTexture:SetSize(quad, quad)
				button.FlagTexture:SetTexture(Textures.cartTexture)
				button.FlagTexture:SetTexCoord(0.09375, 0.90625, 0.09375, 0.90625)--(3/32, 29/32, 3/32, 29/32)
				button.FlagTexture:SetAlpha(1)
				button.FlagDebuff:SetText(testData[side].IconFlag.txt)
			end
		end
	end
	if BattlegroundTargets_Options[side].ButtonAssistToggle[currentSize] then
		GVAR[side.."Button"][testData[side].IconTargetAssi].AssistTargetTexture:SetAlpha(1)
		GVAR.FriendButton[testData.Friend.IconSourceAssi].AssistSourceTexture:SetAlpha(1)
	end
	if BattlegroundTargets_Options[side].ButtonLeaderToggle[currentSize] then
		GVAR[side.."Button"][testData[side].Leader].LeaderTexture:SetAlpha(1)
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:ClearConfigButtonValues(side, button, clearRange)
	local BattlegroundTargets_Options = BattlegroundTargets_Options

	-- colors
	button.colR  = 0
	button.colG  = 0
	button.colB  = 0
	button.colR5 = 0
	button.colG5 = 0
	button.colB5 = 0

	-- basic
	button.Name:SetText("")
	button.RoleTexture:SetTexCoord(0, 0, 0, 0)
	button.SpecTexture:SetTexture(nil)
	button.ClassTexture:SetTexCoord(0, 0, 0, 0)
	button.ClassColorBackground:SetColorTexture(0, 0, 0, 0)

	-- target
	button.TargetTexture:SetAlpha(0)
	button.HighlightT:SetColorTexture(0, 0, 0, 1)
	button.HighlightR:SetColorTexture(0, 0, 0, 1)
	button.HighlightB:SetColorTexture(0, 0, 0, 1)
	button.HighlightL:SetColorTexture(0, 0, 0, 1)

	-- targetcount
	button.FTargetCount:SetText("")
	button.ETargetCount:SetText("")

	-- focus
	button.FocusTexture:SetAlpha(0)

	-- flag
	button.FlagTexture:SetAlpha(0)
	button.FlagDebuff:SetText("")
	button.OrbCornerTL:SetAlpha(0)
	button.OrbCornerTR:SetAlpha(0)
	button.OrbCornerBL:SetAlpha(0)
	button.OrbCornerBR:SetAlpha(0)

	-- assist
	button.AssistTargetTexture:SetAlpha(0)
	button.AssistSourceTexture:SetAlpha(0)

	-- leader
	button.LeaderTexture:SetAlpha(0)

	-- pvp trinket
	button.PVPTrinketTexture:SetAlpha(0)
	button.PVPTrinketTxt:SetText("")

	-- health
	button.HealthBar:SetColorTexture(0, 0, 0, 0)
	button.HealthBar:SetWidth(DATA[side].healthBarWidth)
	button.HealthText:SetText("")

	-- target_of_target
	button.ToTButton:SetAlpha(0)
	button.ToTButton.Name:SetText("")
	button.ToTButton.ClassColorBackground:SetColorTexture(0, 0, 0, 0)
	button.ToTButton.RoleTexture:SetTexCoord(0, 0, 0, 0)
	button.ToTButton.FactionTexture:SetTexCoord(0, 0, 0, 0)
	button.ToTButton.HealthBar:SetColorTexture(0, 0, 0, 0)
	button.ToTButton.HealthBar:SetWidth(DATA[side].healthBarWidth)
	button.ToTButton.HealthText:SetText("")

	-- range
	button.RangeTexture:SetColorTexture(0, 0, 0, 0)

	if clearRange then
		if BattlegroundTargets_Options[side].ButtonRangeToggle[currentSize] then
			BattlegroundTargets:Range_Display(false, button, nil, BattlegroundTargets_Options[side].ButtonRangeDisplay[currentSize])
		else
			BattlegroundTargets:Range_Display(true, button, nil)
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:DefaultShuffle()
	for frc = 1, #FRAMES do
		local side = FRAMES[frc]
		-- health range
		for i = 1, 40 do
			testData[side].Health[i] = random(0,100)
			testData[side].Range[i] = random(0,100)
		end
		-- targetcount
		for i = 1, 40 do
			testData[side].targetFCount[i] = random(0,i)
			testData[side].targetECount[i] = random(0,i)
		end
		-- target_of_target
		for i = 1, 40 do
			testData[side].TargetofTarget[i] = random(0,100)
		end
		local isOneValueCheck = 0
		for i = 1, currentSize do
			if testData[side].TargetofTarget[i] > 33 then
				isOneValueCheck = isOneValueCheck + 1
			end
		end
		if isOneValueCheck == currentSize then
			testData[side].TargetofTarget[1] = 1
		end
		for i = 1, 40 do
			local rndnum = testData[side].TargetofTarget[i]
			local classToken = class_IntegerSort[ random(1,11) ].cid
			local talentSpec			
			if classToken ~= "DEMONHUNTER" then
				talentSpec = classes[ classToken ].spec[ random(1,3) ].role
			else
				talentSpec = classes[ classToken ].spec[ random(1,2) ].role
			end
			testData[side].TargetofTarget[i] = {
				rnd = rndnum,
				totName = L["Target of Target"]..i,
				classToken = classToken,
				talentSpec = talentSpec,
				isEnemy = random(1,2),
				healthvalue = random(1,100)
				}
		end
		-- target focus assi leader
		testData[side].IconTarget = random(1,10)
		testData[side].IconFocus = random(1,10)
		testData[side].IconTargetAssi = random(1,10)
		testData[side].IconSourceAssi = random(1,10)
		testData[side].Leader = random(1,10)
		-- flag
		testData[side].IconFlag.button = random(1,10)
		testData[side].IconFlag.txt = random(1,10)
		-- pvp_trinket_
		testData[side].PVPTrinket[ random(1,10) ] = { -- show at least one
			isEnable = 1,
			isTime = random(1,120)
		}
		for i = 1, 40 do
			testData[side].PVPTrinket[i] = {
				isEnable = random(1,2),
				isTime = random(1,120)
			}
		end
	end
	-- orb friend
	local count1 = 0
	for k, v in pairs(testData.Friend.IconOrb) do
		if count1 == 3 then break end
		if count1 == 0 then          --    10   20   30   40   50   60   70   80   90  100  100  100  100  100  100  100  100  100  100  100 - Increases damage done by x%.
			v.button = random(1,10)    --    -5  -10  -15  -20  -25  -30  -35  -40  -45  -50  -55  -60  -65  -70  -75  -80  -85  -90  -95 -100 - Reduces healing received by x%.
			v.orbval = random(1,20)*30 --->  30   60   90  120  150  180  210  240  270  300  330  360  390  420  450  480  510  540  570  600 - Increases damage taken by x%.
			count1 = 1
		else
			v.button = nil
			v.orbval = nil
			if random(0,100) > 50 then
				local b = random(1,10)
				local numExists
				for k2, v2 in pairs(testData.Friend.IconOrb) do
					if v2.button == b then
						numExists = true
						break
					end
				end
				if not numExists then
					v.button = b
					v.orbval = random(1,20)*30
					count1 = count1 + 1
				end
			end
		end
	end
	-- orb enemy
	local count2 = 0
	for k, v in pairs(testData.Enemy.IconOrb) do
		if count1 + count2 == 4 then break end
		if count2 == 0 then          --    10   20   30   40   50   60   70   80   90  100  100  100  100  100  100  100  100  100  100  100 - Increases damage done by x%.
			v.button = random(1,10)    --    -5  -10  -15  -20  -25  -30  -35  -40  -45  -50  -55  -60  -65  -70  -75  -80  -85  -90  -95 -100 - Reduces healing received by x%.
			v.orbval = random(1,20)*30 --->  30   60   90  120  150  180  210  240  270  300  330  360  390  420  450  480  510  540  570  600 - Increases damage taken by x%.
			count2 = 1
		else
			v.button = nil
			v.orbval = nil
			if random(0,100) > 50 then
				local b = random(1,10)
				local numExists
				for k2, v2 in pairs(testData.Enemy.IconOrb) do
					if v2.button == b then
						numExists = true
						break
					end
				end
				if not numExists then
					v.button = b
					v.orbval = random(1,20)*30
				end
			end
		end
	end
end

function BattlegroundTargets:ShufflerFunc(what, side)
	if what == "OnLeave" then
		GVAR.OptionsFrame:SetScript("OnUpdate", nil)
		GVAR.OptionsFrame.TestShuffler.Texture:SetSize(32, 32)
		GVAR.OptionsFrame.TestShuffler.TextureHighlight:SetSize(32, 32)
	elseif what == "OnEnter" then
		BattlegroundTargets.elapsed = 1
		BattlegroundTargets.progBit = true
		if not BattlegroundTargets.progNum then BattlegroundTargets.progNum = 0 end
		if not BattlegroundTargets.progMod then BattlegroundTargets.progMod = 0 end
		GVAR.OptionsFrame:SetScript("OnUpdate", function(self, elap)
			if inCombat then GVAR.OptionsFrame:SetScript("OnUpdate", nil) return end
			BattlegroundTargets.elapsed = BattlegroundTargets.elapsed + elap
			if BattlegroundTargets.elapsed < 0.4 then return end
			BattlegroundTargets.elapsed = 0
			BattlegroundTargets:Shuffle(BattlegroundTargets.shuffleStyle) -- :Shuffle( _SHUFFLE_
		end)
	elseif what == "OnClick" then
		GVAR.OptionsFrame.TestShuffler.Texture:SetSize(32, 32)
		GVAR.OptionsFrame.TestShuffler.TextureHighlight:SetSize(32, 32)
		BattlegroundTargets.shuffleStyle = not BattlegroundTargets.shuffleStyle
		if BattlegroundTargets.shuffleStyle then
			GVAR.OptionsFrame.TestShuffler.Texture:SetTexture("Interface\\Icons\\INV_Sigil_Thorim")
		else
			GVAR.OptionsFrame.TestShuffler.Texture:SetTexture("Interface\\Icons\\INV_Sigil_Mimiron")
		end
	elseif what == "OnMouseDown" then
		GVAR.OptionsFrame.TestShuffler.Texture:SetSize(30, 30)
		GVAR.OptionsFrame.TestShuffler.TextureHighlight:SetSize(30, 30)
	elseif what == "ShuffleCheck" then
		local BattlegroundTargets_Options = BattlegroundTargets_Options
		if BattlegroundTargets_Options[side].ButtonTargetToggle[currentSize] or
		   BattlegroundTargets_Options[side].ButtonToTToggle[currentSize] or
		   BattlegroundTargets_Options[side].ButtonFlagToggle[currentSize] or
		   BattlegroundTargets_Options[side].ButtonHealthBarToggle[currentSize] or
		   BattlegroundTargets_Options[side].ButtonHealthTextToggle[currentSize] or
		   BattlegroundTargets_Options[side].ButtonFocusToggle[currentSize] or
		   BattlegroundTargets_Options[side].ButtonAssistToggle[currentSize] or
		   BattlegroundTargets_Options[side].ButtonLeaderToggle[currentSize] or
		   BattlegroundTargets_Options[side].ButtonRangeToggle[currentSize] or
		   BattlegroundTargets_Options[side].ButtonPvPTrinketToggle[currentSize]
		then
			GVAR.OptionsFrame.TestShuffler:Show()
		else
			GVAR.OptionsFrame.TestShuffler:Hide()
		end
	end
end

function BattlegroundTargets:Shuffle(shuffleStyle) -- :Shuffle( _SHUFFLE_
	BattlegroundTargets.progBit = not BattlegroundTargets.progBit
	if BattlegroundTargets.progBit then
		GVAR.OptionsFrame.TestShuffler.TextureHighlight:SetAlpha(0)
	else
		GVAR.OptionsFrame.TestShuffler.TextureHighlight:SetAlpha(0.5)
	end

	if shuffleStyle then
		BattlegroundTargets:DefaultShuffle()
	else
		if BattlegroundTargets.progMod == 0 then
			BattlegroundTargets.progNum = BattlegroundTargets.progNum + 1
		else
			BattlegroundTargets.progNum = BattlegroundTargets.progNum - 1
		end
		if BattlegroundTargets.progNum >= 10 then
			BattlegroundTargets.progNum = 10
			BattlegroundTargets.progMod = 1
		elseif BattlegroundTargets.progNum <= 1 then
			BattlegroundTargets.progNum = 1
			BattlegroundTargets.progMod = 0
		end
		testData.Friend.IconTarget = BattlegroundTargets.progNum
		testData.Enemy.IconTarget  = BattlegroundTargets.progNum
		testData.Friend.IconFocus = BattlegroundTargets.progNum
		testData.Enemy.IconFocus  = BattlegroundTargets.progNum
		testData.Friend.IconTargetAssi = BattlegroundTargets.progNum
		testData.Enemy.IconTargetAssi  = BattlegroundTargets.progNum
		testData.Friend.IconSourceAssi = BattlegroundTargets.progNum
		testData.Enemy.IconSourceAssi  = BattlegroundTargets.progNum
		testData.Friend.Leader = BattlegroundTargets.progNum
		testData.Enemy.Leader  = BattlegroundTargets.progNum

		testData.Friend.IconFlag.button = BattlegroundTargets.progNum
		testData.Enemy.IconFlag.button  = BattlegroundTargets.progNum
		testData.Friend.IconFlag.txt = BattlegroundTargets.progNum
		testData.Enemy.IconFlag.txt  = BattlegroundTargets.progNum

		local num = BattlegroundTargets.progNum * 60 -- * 2 * 30
		for k, v in pairs(testData.Friend.IconOrb) do
			if v.button then
				v.button = BattlegroundTargets.progNum
				v.orbval = num
			end
		end
		for k, v in pairs(testData.Enemy.IconOrb) do
			if v.button then
				v.button = BattlegroundTargets.progNum
				v.orbval = num
			end
		end

		local num = BattlegroundTargets.progNum * 10
		for i = 1, 40 do
			testData.Friend.Health[i] = num
			testData.Enemy.Health[i] = num
			testData.Friend.Range[i] = 100
			testData.Enemy.Range[i] = 100
		end
		testData.Friend.Range[BattlegroundTargets.progNum] = 30
		testData.Enemy.Range[BattlegroundTargets.progNum] = 30
	end

	local BattlegroundTargets_Options = BattlegroundTargets_Options

	if BattlegroundTargets_Options.Friend.EnableBracket[currentSize] then
		BattlegroundTargets:SetConfigButtonValues("Friend")
	end
	if BattlegroundTargets_Options.Enemy.EnableBracket[currentSize] then
		BattlegroundTargets:SetConfigButtonValues("Enemy")
	end
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CopyAllSettings(sourceSize, sameSize)
	local destinationSize = 10
	if sourceSize == 10 then
		destinationSize = 15
	elseif sourceSize == 40 then
		destinationSize = 40
	end

	local sourceFraction = fraction
	local destinationFraction = fraction

	if sameSize then
		destinationSize = sourceSize
		if sourceFraction == "Enemy" then
			destinationFraction = "Friend"
			fraction = "Friend"
		else
			destinationFraction = "Enemy"
			fraction = "Enemy"
		end
	end

	BattlegroundTargets_Options[destinationFraction].LayoutTH[destinationSize]                 = BattlegroundTargets_Options[sourceFraction].LayoutTH[sourceSize]
	BattlegroundTargets_Options[destinationFraction].LayoutSpace[destinationSize]              = BattlegroundTargets_Options[sourceFraction].LayoutSpace[sourceSize]

	BattlegroundTargets_Options[destinationFraction].SummaryToggle[destinationSize]            = BattlegroundTargets_Options[sourceFraction].SummaryToggle[sourceSize]
	BattlegroundTargets_Options[destinationFraction].SummaryScale[destinationSize]             = BattlegroundTargets_Options[sourceFraction].SummaryScale[sourceSize]
	BattlegroundTargets_Options[destinationFraction].SummaryPos[destinationSize]               = BattlegroundTargets_Options[sourceFraction].SummaryPos[sourceSize]

	BattlegroundTargets_Options[destinationFraction].ButtonRoleToggle[destinationSize]         = BattlegroundTargets_Options[sourceFraction].ButtonRoleToggle[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonSpecToggle[destinationSize]         = BattlegroundTargets_Options[sourceFraction].ButtonSpecToggle[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonClassToggle[destinationSize]        = BattlegroundTargets_Options[sourceFraction].ButtonClassToggle[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonLeaderToggle[destinationSize]       = BattlegroundTargets_Options[sourceFraction].ButtonLeaderToggle[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonRealmToggle[destinationSize]        = BattlegroundTargets_Options[sourceFraction].ButtonRealmToggle[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonPvPTrinketToggle[destinationSize]   = BattlegroundTargets_Options[sourceFraction].ButtonPvPTrinketToggle[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonTargetToggle[destinationSize]       = BattlegroundTargets_Options[sourceFraction].ButtonTargetToggle[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonTargetScale[destinationSize]        = BattlegroundTargets_Options[sourceFraction].ButtonTargetScale[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonTargetPosition[destinationSize]     = BattlegroundTargets_Options[sourceFraction].ButtonTargetPosition[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonFTargetCountToggle[destinationSize] = BattlegroundTargets_Options[sourceFraction].ButtonFTargetCountToggle[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonETargetCountToggle[destinationSize] = BattlegroundTargets_Options[sourceFraction].ButtonETargetCountToggle[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonToTToggle[destinationSize]          = BattlegroundTargets_Options[sourceFraction].ButtonToTToggle[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonToTScale[destinationSize]           = BattlegroundTargets_Options[sourceFraction].ButtonToTScale[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonToTPosition[destinationSize]        = BattlegroundTargets_Options[sourceFraction].ButtonToTPosition[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonFocusToggle[destinationSize]        = BattlegroundTargets_Options[sourceFraction].ButtonFocusToggle[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonFocusScale[destinationSize]         = BattlegroundTargets_Options[sourceFraction].ButtonFocusScale[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonFocusPosition[destinationSize]      = BattlegroundTargets_Options[sourceFraction].ButtonFocusPosition[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonFlagToggle[destinationSize]         = BattlegroundTargets_Options[sourceFraction].ButtonFlagToggle[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonFlagScale[destinationSize]          = BattlegroundTargets_Options[sourceFraction].ButtonFlagScale[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonFlagPosition[destinationSize]       = BattlegroundTargets_Options[sourceFraction].ButtonFlagPosition[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonAssistToggle[destinationSize]       = BattlegroundTargets_Options[sourceFraction].ButtonAssistToggle[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonAssistScale[destinationSize]        = BattlegroundTargets_Options[sourceFraction].ButtonAssistScale[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonAssistPosition[destinationSize]     = BattlegroundTargets_Options[sourceFraction].ButtonAssistPosition[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonHealthBarToggle[destinationSize]    = BattlegroundTargets_Options[sourceFraction].ButtonHealthBarToggle[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonHealthTextToggle[destinationSize]   = BattlegroundTargets_Options[sourceFraction].ButtonHealthTextToggle[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonRangeToggle[destinationSize]        = BattlegroundTargets_Options[sourceFraction].ButtonRangeToggle[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonRangeDisplay[destinationSize]       = BattlegroundTargets_Options[sourceFraction].ButtonRangeDisplay[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonSortBy[destinationSize]             = BattlegroundTargets_Options[sourceFraction].ButtonSortBy[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonSortDetail[destinationSize]         = BattlegroundTargets_Options[sourceFraction].ButtonSortDetail[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonFontNameStyle[destinationSize]      = BattlegroundTargets_Options[sourceFraction].ButtonFontNameStyle[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonFontNameSize[destinationSize]       = BattlegroundTargets_Options[sourceFraction].ButtonFontNameSize[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonFontNumberStyle[destinationSize]    = BattlegroundTargets_Options[sourceFraction].ButtonFontNumberStyle[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonFontNumberSize[destinationSize]     = BattlegroundTargets_Options[sourceFraction].ButtonFontNumberSize[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonScale[destinationSize]              = BattlegroundTargets_Options[sourceFraction].ButtonScale[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonWidth[destinationSize]              = BattlegroundTargets_Options[sourceFraction].ButtonWidth[sourceSize]
	BattlegroundTargets_Options[destinationFraction].ButtonHeight[destinationSize]             = BattlegroundTargets_Options[sourceFraction].ButtonHeight[sourceSize]

	if fraction == "Friend" then
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.EnableFriendBracket, true)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.EnableEnemyBracket, nil)
	else
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.EnableFriendBracket, nil)
		TEMPLATE.SetTabButton(GVAR.OptionsFrame.EnableEnemyBracket, true)
	end

	BattlegroundTargets:ClickOnBracketTab(destinationSize, destinationFraction, "force")
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
local function sortfunc13(a, b) -- role / class / name | 13
	if a.talentSpec == b.talentSpec then
		if class_BlizzSort[ a.classToken ] == class_BlizzSort[ b.classToken ] then
			if a.name < b.name then return true end
		elseif class_BlizzSort[ a.classToken ] < class_BlizzSort[ b.classToken ] then return true end
	elseif a.talentSpec < b.talentSpec then return true end
end
local function sortfunc11(a, b) -- role / class / name | 11
	if a.talentSpec == b.talentSpec then
		if class_LocaSort[ a.classToken ] == class_LocaSort[ b.classToken ] then
			if a.name < b.name then return true end
		elseif class_LocaSort[ a.classToken ] < class_LocaSort[ b.classToken ] then return true end
	elseif a.talentSpec < b.talentSpec then return true end
end
local function sortfunc12(a, b) -- role / class / name | 12
	if a.talentSpec == b.talentSpec then
		if a.classToken == b.classToken then
			if a.name < b.name then return true end
		elseif a.classToken < b.classToken then return true end
	elseif a.talentSpec < b.talentSpec then return true end
end
local function sortfunc2(a, b) -- role / name | 2
	if a.talentSpec == b.talentSpec then
		if a.name < b.name then return true end
	elseif a.talentSpec < b.talentSpec then return true end
end
local function sortfunc33(a, b) -- class / role / name | 33
	if class_BlizzSort[ a.classToken ] == class_BlizzSort[ b.classToken ] then
		if a.talentSpec == b.talentSpec then
			if a.name < b.name then return true end
		elseif a.talentSpec < b.talentSpec then return true end
	elseif class_BlizzSort[ a.classToken ] < class_BlizzSort[ b.classToken ] then return true end
end
local function sortfunc31(a, b) -- class / role / name | 31
	if class_LocaSort[ a.classToken ] == class_LocaSort[ b.classToken ] then
		if a.talentSpec == b.talentSpec then
			if a.name < b.name then return true end
		elseif a.talentSpec < b.talentSpec then return true end
	elseif class_LocaSort[ a.classToken ] < class_LocaSort[ b.classToken ] then return true end
end
local function sortfunc32(a, b) -- class / role / name | 32
	if a.classToken == b.classToken then
		if a.talentSpec == b.talentSpec then
			if a.name < b.name then return true end
		elseif a.talentSpec < b.talentSpec then return true end
	elseif a.classToken < b.classToken then return true end
end
local function sortfunc43(a, b) -- class / name | 43
	if class_BlizzSort[ a.classToken ] == class_BlizzSort[ b.classToken ] then
		if a.name < b.name then return true end
	elseif class_BlizzSort[ a.classToken ] < class_BlizzSort[ b.classToken ] then return true end
end
local function sortfunc41(a, b) -- class / name | 41
	if class_LocaSort[ a.classToken ] == class_LocaSort[ b.classToken ] then
		if a.name < b.name then return true end
	elseif class_LocaSort[ a.classToken ] < class_LocaSort[ b.classToken ] then return true end
end
local function sortfunc42(a, b) -- class / name | 42
	if a.classToken == b.classToken then
		if a.name < b.name then return true end
	elseif a.classToken < b.classToken then return true end
end
local function sortfunc5(a, b) -- name | 5
	if a.name < b.name then return true end
end

function BattlegroundTargets:MainDataUpdate(side)
	local BattlegroundTargets_Options = BattlegroundTargets_Options

	if not BattlegroundTargets_Options[side].EnableBracket[currentSize] then
		wipe(DATA[side].Name2Button)
		for i = 1, currentSize do
			if DATA[side].MainData[i] then
				DATA[side].Name2Button[ DATA[side].MainData[i].name ] = i
			end
		end
		return
	end

	local ButtonSortBy             = BattlegroundTargets_Options[side].ButtonSortBy[currentSize]
	local ButtonSortDetail         = BattlegroundTargets_Options[side].ButtonSortDetail[currentSize]
	local ButtonSpecToggle         = BattlegroundTargets_Options[side].ButtonSpecToggle[currentSize]
	local ButtonClassToggle        = BattlegroundTargets_Options[side].ButtonClassToggle[currentSize]
	local ButtonLeaderToggle       = BattlegroundTargets_Options[side].ButtonLeaderToggle[currentSize]
	local ButtonRealmToggle        = BattlegroundTargets_Options[side].ButtonRealmToggle[currentSize]
	local ButtonFTargetCountToggle = BattlegroundTargets_Options[side].ButtonFTargetCountToggle[currentSize]
	local ButtonETargetCountToggle = BattlegroundTargets_Options[side].ButtonETargetCountToggle[currentSize]
	local ButtonPvPTrinketToggle   = BattlegroundTargets_Options[side].ButtonPvPTrinketToggle[currentSize]
	local ButtonToTToggle          = BattlegroundTargets_Options[side].ButtonToTToggle[currentSize]
	local ButtonHealthBarToggle    = BattlegroundTargets_Options[side].ButtonHealthBarToggle[currentSize]
	local ButtonHealthTextToggle   = BattlegroundTargets_Options[side].ButtonHealthTextToggle[currentSize]
	local ButtonTargetToggle       = BattlegroundTargets_Options[side].ButtonTargetToggle[currentSize]
	local ButtonFocusToggle        = BattlegroundTargets_Options[side].ButtonFocusToggle[currentSize]
	local ButtonFlagToggle         = BattlegroundTargets_Options[side].ButtonFlagToggle[currentSize]
	local ButtonAssistToggle       = BattlegroundTargets_Options[side].ButtonAssistToggle[currentSize]
	local ButtonRangeToggle        = BattlegroundTargets_Options[side].ButtonRangeToggle[currentSize]
	local SummaryToggle            = BattlegroundTargets_Options[side].SummaryToggle[currentSize]
	local TransliterationToggle    = BattlegroundTargets_Options.TransliterationToggle

	if ButtonSortBy == 1 then
		if ButtonSortDetail == 3 then
			table_sort(DATA[side].MainData, sortfunc13) -- role / class / name | 13
		elseif ButtonSortDetail == 1 then
			table_sort(DATA[side].MainData, sortfunc11) -- role / class / name | 11
		else
			table_sort(DATA[side].MainData, sortfunc12) -- role / class / name | 12
		end
	elseif ButtonSortBy == 2 then
		table_sort(DATA[side].MainData, sortfunc2) -- role / name | 2
	elseif ButtonSortBy == 3 then
		if ButtonSortDetail == 3 then
			table_sort(DATA[side].MainData, sortfunc33) -- class / role / name | 33
		elseif ButtonSortDetail == 1 then
			table_sort(DATA[side].MainData, sortfunc31) -- class / role / name | 31
		else
			table_sort(DATA[side].MainData, sortfunc32) -- class / role / name | 32
		end
	elseif ButtonSortBy == 4 then
		if ButtonSortDetail == 3 then
			table_sort(DATA[side].MainData, sortfunc43) -- class / name | 43
		elseif ButtonSortDetail == 1 then
			table_sort(DATA[side].MainData, sortfunc41) -- class / name | 41
		else
			table_sort(DATA[side].MainData, sortfunc42) -- class / name | 42
		end
	else
		table_sort(DATA[side].MainData, sortfunc5) -- name | 5
	end

	local curTime = GetTime()
	wipe(DATA[side].Name2Button)
	wipe(DATA[side].Name4Flag)
	local bname = GVAR[side.."Button"]
	for i = 1, currentSize do
		if DATA[side].MainData[i] then
			local button = bname[i]

			local qname       = DATA[side].MainData[i].name
			local qclassToken = DATA[side].MainData[i].classToken
			local qspecIcon   = DATA[side].MainData[i].specIcon
			local qtalentSpec = DATA[side].MainData[i].talentSpec

			DATA[side].Name2Button[qname] = i
			button.buttonNum = i

			local colR = classcolors[qclassToken].r
			local colG = classcolors[qclassToken].g
			local colB = classcolors[qclassToken].b
			button.colR  = colR
			button.colG  = colG
			button.colB  = colB
			button.colR5 = colR*0.5
			button.colG5 = colG*0.5
			button.colB5 = colB*0.5
			button.ClassColorBackground:SetColorTexture(button.colR5, button.colG5, button.colB5, 1)
			button.HealthBar:SetColorTexture(colR, colG, colB, 1)

			button.RoleTexture:SetTexCoord(Textures.RoleIcon[qtalentSpec][1], Textures.RoleIcon[qtalentSpec][2], Textures.RoleIcon[qtalentSpec][3], Textures.RoleIcon[qtalentSpec][4])

			local onlyname, realmname = qname
			if ButtonFlagToggle or not ButtonRealmToggle or TransliterationToggle then
				if strfind(qname, "-", 1, true) then
					onlyname, realmname = strmatch(qname, "(.-)%-(.*)$")
				end
				DATA[side].Name4Flag[onlyname] = i
			end

			if not ButtonRealmToggle then
				if TransliterationToggle then
					if not DATA.TransName[onlyname] then
						DATA.TransName[onlyname] = utf8replace(onlyname, TSL)
					end
					button.name4button = DATA.TransName[onlyname]
				else
					button.name4button = onlyname
				end
				if isLowLevel and DATA[side].Name2Level[qname] then
					button.Name:SetText(DATA[side].Name2Level[qname].." "..button.name4button)
				else
					button.Name:SetText(button.name4button)
				end
			else
				if TransliterationToggle then
					if not DATA.TransName[onlyname] then
						DATA.TransName[onlyname] = utf8replace(onlyname, TSL)
					end
					if realmname then
						button.name4button = DATA.TransName[onlyname] .. "-" .. realmname
					else
						button.name4button = DATA.TransName[onlyname]
					end
				else
					button.name4button = qname
				end
				if isLowLevel and DATA[side].Name2Level[qname] then
					button.Name:SetText(DATA[side].Name2Level[qname].." "..button.name4button)
				else
					button.Name:SetText(button.name4button)
				end
			end

			if not inCombat then
				button:SetAttribute("macrotext1", "/targetexact "..qname)
				button:SetAttribute("macrotext2", "/targetexact "..qname.."\n/focus\n/targetlasttarget")
			end

			if ButtonFocusToggle then
				if qname == playerFocusName then
					button.FocusTexture:SetAlpha(1)
					if not inCombat then
						button:SetAttribute("macrotext2", "/targetexact "..playerFocusName.."\n/clearfocus\n/targetlasttarget")
					end
				else
					button.FocusTexture:SetAlpha(0)
				end
			end

			if ButtonRangeToggle then
				button.RangeTexture:SetColorTexture(colR, colG, colB, 1)
			end

			if ButtonSpecToggle then
				button.SpecTexture:SetTexture(qspecIcon)
			end

			if ButtonClassToggle then
				button.ClassTexture:SetTexCoord(classes[qclassToken].coords[1], classes[qclassToken].coords[2], classes[qclassToken].coords[3], classes[qclassToken].coords[4])
			end

			if ButtonFTargetCountToggle then
				button.FTargetCount:SetText(DATA.TargetFCountNum[qname] or "0")
			end
			if ButtonETargetCountToggle then
				button.ETargetCount:SetText(DATA.TargetECountNum[qname] or "0")
			end

			local percentE = DATA[side].Name2Percent[qname]
			if percentE then
				if ButtonHealthBarToggle then
					local width = DATA[side].healthBarWidth * (percentE / 100)
					width = math_max(0.01, width)
					width = math_min(DATA[side].healthBarWidth, width)
					button.HealthBar:SetWidth(width)
				end
				if ButtonHealthTextToggle then
					button.HealthText:SetText(percentE)
				end
			end

			if ButtonTargetToggle then
				if qname == playerTargetName then
					button.HighlightT:SetColorTexture(0.5, 0.5, 0.5, 1)
					button.HighlightR:SetColorTexture(0.5, 0.5, 0.5, 1)
					button.HighlightB:SetColorTexture(0.5, 0.5, 0.5, 1)
					button.HighlightL:SetColorTexture(0.5, 0.5, 0.5, 1)
					button.TargetTexture:SetAlpha(1)
				else
					button.HighlightT:SetColorTexture(0, 0, 0, 1)
					button.HighlightR:SetColorTexture(0, 0, 0, 1)
					button.HighlightB:SetColorTexture(0, 0, 0, 1)
					button.HighlightL:SetColorTexture(0, 0, 0, 1)
					button.TargetTexture:SetAlpha(0)
				end
			end

			if ButtonFlagToggle then
				if qname == DATA[side].hasFlag then
					button.FlagTexture:SetAlpha(1)
					BattlegroundTargets:SetFlagDebuff(button, flagDebuff)
				elseif qname == hasOrb.Blue.name then
					button.FlagTexture:SetAlpha(1)
					button.FlagTexture:SetTexture("Interface\\MiniMap\\TempleofKotmogu_ball_cyan")
					BattlegroundTargets:SetFlagDebuff(button, hasOrb.Blue.orbval)
					button.OrbCornerTL:SetAlpha(0.15)
					button.OrbCornerTR:SetAlpha(0.15)
					button.OrbCornerBL:SetAlpha(0.15)
					button.OrbCornerBR:SetAlpha(1)
				elseif qname == hasOrb.Purple.name then
					button.FlagTexture:SetAlpha(1)
					button.FlagTexture:SetTexture("Interface\\MiniMap\\TempleofKotmogu_ball_purple")
					BattlegroundTargets:SetFlagDebuff(button, hasOrb.Purple.orbval)
					button.OrbCornerTL:SetAlpha(1)
					button.OrbCornerTR:SetAlpha(0.15)
					button.OrbCornerBL:SetAlpha(0.15)
					button.OrbCornerBR:SetAlpha(0.15)
				elseif qname == hasOrb.Green.name then
					button.FlagTexture:SetAlpha(1)
					button.FlagTexture:SetTexture("Interface\\MiniMap\\TempleofKotmogu_ball_green")
					BattlegroundTargets:SetFlagDebuff(button, hasOrb.Green.orbval)
					button.OrbCornerTL:SetAlpha(0.15)
					button.OrbCornerTR:SetAlpha(0.15)
					button.OrbCornerBL:SetAlpha(1)
					button.OrbCornerBR:SetAlpha(0.15)
				elseif qname == hasOrb.Orange.name then
					button.FlagTexture:SetAlpha(1)
					button.FlagTexture:SetTexture("Interface\\MiniMap\\TempleofKotmogu_ball_orange")
					BattlegroundTargets:SetFlagDebuff(button, hasOrb.Orange.orbval)
					button.OrbCornerTL:SetAlpha(0.15)
					button.OrbCornerTR:SetAlpha(1)
					button.OrbCornerBL:SetAlpha(0.15)
					button.OrbCornerBR:SetAlpha(0.15)
				else
					button.FlagTexture:SetAlpha(0)
					button.FlagDebuff:SetText("")
					button.OrbCornerTL:SetAlpha(0)
					button.OrbCornerTR:SetAlpha(0)
					button.OrbCornerBL:SetAlpha(0)
					button.OrbCornerBR:SetAlpha(0)
				end
			end

			if ButtonAssistToggle then
				if qname == playerAssistTargetName then
					button.AssistTargetTexture:SetAlpha(1)
				else
					button.AssistTargetTexture:SetAlpha(0)
				end
				if qname == isAssistName then
					button.AssistSourceTexture:SetAlpha(1)
				else
					button.AssistSourceTexture:SetAlpha(0)
				end
			end

			if ButtonLeaderToggle then -- leader_
				if qname == DATA[side].isLeader then
					button.LeaderTexture:SetAlpha(1)
				else
					button.LeaderTexture:SetAlpha(0)
				end
			end

			if ButtonPvPTrinketToggle then -- pvp_trinket_
				BattlegroundTargets:UpdatePvPTrinket(button, qname, curTime)
			end

			if ButtonToTToggle then -- target_of_target
				if button.ToTButton.totData then
					BattlegroundTargets:UpdateToTButton(button)
					button.ToTButton:SetAlpha(1)
				else
					button.ToTButton:SetAlpha(0)
				end
			end

		else
			local button = GVAR[side.."Button"][i]
			BattlegroundTargets:ClearConfigButtonValues(side, button, false)
			if not inCombat then
				button:SetAttribute("macrotext1", "")
				button:SetAttribute("macrotext2", "")
			end
		end
	end

	if isConfig then
		if SummaryToggle then --TODO summary option split results
			for frc = 1, #FRAMES do
				local fside = FRAMES[frc]
				DATA[fside].Roles = {0,0,0,0}
				for i = 1, currentSize do
					if DATA[fside].MainData[i] then
						local role = DATA[fside].MainData[i].talentSpec
						DATA[fside].Roles[role] = DATA[fside].Roles[role] + 1
					end
				end
				local Summary = GVAR[fside.."Summary"]
				Summary.HealerFriend:SetText(DATA.Friend.Roles[1]) -- HEALER  FRIEND
				Summary.TankFriend:SetText(DATA.Friend.Roles[2])   -- TANK    FRIEND
				Summary.DamageFriend:SetText(DATA.Friend.Roles[3]) -- DAMAGER FRIEND
				Summary.HealerEnemy:SetText(DATA.Enemy.Roles[1])   -- HEALER  ENEMY
				Summary.TankEnemy:SetText(DATA.Enemy.Roles[2])     -- TANK    ENEMY
				Summary.DamageEnemy:SetText(DATA.Enemy.Roles[3])   -- DAMAGER ENEMY
			end
		end
		if isLowLevel then -- LVLCHK
			local button = GVAR[side.."Button"]
			for i = 1, currentSize do
				button[i].Name:SetText(playerLevel.." "..button[i].name4button)
			end
		end
		return
	end

	if ButtonRangeToggle then
		BattlegroundTargets:UpdateRange(side, curTime)
	end

	-- SUMMARY
	if SummaryToggle then --TODO summary option split results
		local Summary = GVAR[side.."Summary"]
		Summary.HealerFriend:SetText(DATA.Friend.Roles[1]) -- HEALER  FRIEND
		Summary.TankFriend:SetText(DATA.Friend.Roles[2])   -- TANK    FRIEND
		Summary.DamageFriend:SetText(DATA.Friend.Roles[3]) -- DAMAGER FRIEND
		Summary.HealerEnemy:SetText(DATA.Enemy.Roles[1])   -- HEALER  ENEMY
		Summary.TankEnemy:SetText(DATA.Enemy.Roles[2])     -- TANK    ENEMY
		Summary.DamageEnemy:SetText(DATA.Enemy.Roles[3])   -- DAMAGER ENEMY
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:BattlefieldScoreUpdate()
	local curTime = GetTime()
	local diff = curTime - scoreLastUpdate
	if diff < scoreFrequency then return end
	if scoreCount > 60 then
		scoreFrequency = 5
	elseif scoreCount > 30 then
		scoreFrequency = 2
		scoreCount = scoreCount + 1
	else
		scoreCount = scoreCount + 1
	end

	if inCombat or InCombatLockdown() then
		if reCheckBG or diff >= scoreWarning then
			GVAR.FriendScoreUpdateTexture:Show()
			GVAR.EnemyScoreUpdateTexture:Show()
		else
			GVAR.FriendScoreUpdateTexture:Hide()
			GVAR.EnemyScoreUpdateTexture:Hide()
		end
		reCheckScore = true
		return
	end

	local wssf = WorldStateScoreFrame
	if wssf and wssf:IsShown() and wssf.selectedTab and wssf.selectedTab > 1 then
		return
	end

	reCheckScore = nil
	scoreLastUpdate = curTime

	GVAR.FriendScoreUpdateTexture:Hide()
	GVAR.EnemyScoreUpdateTexture:Hide()

	wipe(DATA.Friend.MainData)
	wipe(DATA.Enemy.MainData)
	DATA.Friend.Roles = {0,0,0,0} -- SUMMARY
	DATA.Enemy.Roles = {0,0,0,0} -- SUMMARY

	local numScore = GetNumBattlefieldScores()

	if not oppositeFactionREAL then
		for index = 1, numScore do
			local _, _, _, _, _, faction, race = GetBattlefieldScore(index)
			if faction == oppositeFactionBG then
				local n = RNA[race]
				if n == 0 then -- summary_flag_texture - 2 - set in bg
					GVAR.FriendSummary.Logo2:SetTexture("Interface\\FriendsFrame\\PlusManz-Horde")
					GVAR.EnemySummary.Logo2:SetTexture("Interface\\FriendsFrame\\PlusManz-Horde")
					oppositeFactionREAL = 0
					break
				elseif n == 1 then
					GVAR.FriendSummary.Logo2:SetTexture("Interface\\FriendsFrame\\PlusManz-Alliance")
					GVAR.EnemySummary.Logo2:SetTexture("Interface\\FriendsFrame\\PlusManz-Alliance")
					oppositeFactionREAL = 1
					break
				end
			end
		end
	end

	--[[
	for index = 1, numScore do
		local _, _, _, _, _, faction, race, _, classToken = GetBattlefieldScore(index)
		if race and faction and classToken then
			if not BattlegroundTargets_Options.RNA then BattlegroundTargets_Options.RNA = {} end
			if not BattlegroundTargets_Options.RNA[locale] then BattlegroundTargets_Options.RNA[locale] = {} end
			BattlegroundTargets_Options.RNA[locale][race] = 1
		end
	end
	--]]

	for index = 1, numScore do
		local name, _, _, _, _, faction, _, _, classToken, _, _, _, _, _, _, talentSpec = GetBattlefieldScore(index)
		--print("INPUT_NAME_CHECK: _score_", index, name, faction, classToken, talentSpec, "#", GetBattlefieldScore(index))

		

					--bad locale fix
					
		if classes[classToken].fix then
			if classes[classToken].fixname[talentSpec] ~= nill then
			--	print ("fixed: ".. talentSpec .. " to ".. classes[classToken].fixname[talentSpec])
				talentSpec = classes[classToken].fixname[talentSpec]
			end
		end

			--rus
			--if talentSpec == "Повелительница зверей" then talentSpec = "Повелитель зверей" end


		

		if not name then
			if not BattlegroundTargets.UnknownNameIndex then
				BattlegroundTargets.UnknownNameIndex = 1
				name = L["Unknown"]
			else
				BattlegroundTargets.UnknownNameIndex = BattlegroundTargets.UnknownNameIndex + 1
				name = L["Unknown"]..BattlegroundTargets.UnknownNameIndex
			end
		end

		if faction == oppositeFactionBG then

			local specrole = 4
			local specicon = nil
			local class = "ZZZFAILURE"
			if classToken then
				local token = classes[classToken] -- BGSPEC
				if token then
					if talentSpec and token.spec then
						for i = 1, #token.spec do
							if talentSpec == token.spec[i].specName then
								specrole = token.spec[i].role
								specicon = token.spec[i].icon
								break
							end
						end
					end
					class = classToken
				end
			end

			if not specicon then
				if not testData.specTest then testData.specTest = {} end
				if not testData.specTest[class] then testData.specTest[class] = {} end
				if not talentSpec then talentSpec = "talentSpec_is_unknown!" end
				if not testData.specTest[class][talentSpec] then
					testData.specTest[class][talentSpec] = {locale=locale, faction=faction, classToken=classToken, talentSpec=talentSpec, name=name}
					Print("ERROR#1 unknown spec:", locale, faction, classToken, talentSpec)
				end
			end

			DATA.Enemy.Roles[specrole] = DATA.Enemy.Roles[specrole] + 1 -- SUMMARY
			tinsert(DATA.Enemy.MainData, {
				name       = name,
				classToken = class,
				specIcon   = specicon,
				talentSpec = specrole
			})

		elseif faction == playerFactionBG then

			local specrole = 4
			local specicon = nil
			local class = "ZZZFAILURE"
			if classToken then
				local token = classes[classToken] -- BGSPEC
				if token then
					if talentSpec and token.spec then
						for i = 1, #token.spec do
							if talentSpec == token.spec[i].specName then
								specrole = token.spec[i].role
								specicon = token.spec[i].icon
								break
							end
						end
					end
					class = classToken
				end
			end
			--bad hotfix for ru locale
						

			if not specicon then
				if not testData.specTest then testData.specTest = {} end
				if not testData.specTest[class] then testData.specTest[class] = {} end
				if not talentSpec then talentSpec = "talentSpec_is_unknown" end
				if not testData.specTest[class][talentSpec] then
					testData.specTest[class][talentSpec] = {locale=locale, faction=faction, classToken=classToken, talentSpec=talentSpec}
					--Print("ERROR#2 unknown spec:", locale, faction, classToken, talentSpec)
				end
			end

			DATA.Friend.Roles[specrole] = DATA.Friend.Roles[specrole] + 1 -- SUMMARY
			tinsert(DATA.Friend.MainData, {
				name       = name,
				classToken = class,
				specIcon   = specicon,
				talentSpec = specrole
			})

		end
	end

	if BattlegroundTargets.GroupUpdateTimer and curTime > BattlegroundTargets.GroupUpdateTimer + 2 then
		--print("Group Update Timer:", curTime - BattlegroundTargets.GroupUpdateTimer)
		BattlegroundTargets:GroupUnitIDUpdate()
	end

	if BattlegroundTargets.TrackFaction and DATA.Enemy.MainData[1] then -- BG_FACTION_CHK
		for i = 1, #DATA.Enemy.MainData do
			if DATA.Enemy.MainData[i].name == playerName then
				BattlegroundTargets.ForceDefaultFaction = true
				break
			end
		end
		BattlegroundTargets.TrackFaction = nil
		if BattlegroundTargets.ForceDefaultFaction then
			BattlegroundTargets:BattlefieldCheck()
			return
		end
	end

	if DATA.Enemy.MainData[1] then
		BattlegroundTargets:MainDataUpdate("Enemy")
	end

	if DATA.Friend.MainData[1] then
		BattlegroundTargets:MainDataUpdate("Friend")
	end

	if not flagflag and isFlagBG > 0 then
		if DATA.Enemy.MainData[1] or DATA.Friend.MainData[1] then
			if BattlegroundTargets_Options.Friend.ButtonFlagToggle[currentSize] or BattlegroundTargets_Options.Enemy.ButtonFlagToggle[currentSize] then
				flagflag = true
				flagCHK = true
				BattlegroundTargets:CheckFlagCarrierSTART()
			end
		end
	end

	if reSizeCheck >= 10 then return end
	BattlegroundTargets:BattlefieldCheck()
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:BattlefieldCheck()
	if not inWorld then return end
	local _, instanceType = IsInInstance()
	if instanceType == "pvp" then
		BattlegroundTargets:IsBattleground()
	else
		BattlegroundTargets:IsNotBattleground()
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:IsBattleground()
	local BattlegroundTargets_Options = BattlegroundTargets_Options

	inBattleground = true

	-- Battleground name BEGIN ----------
	local bgName, zoneName, mapName

	if not currentBGMap then
		local queueStatus, queueMapName
		for i = 1, GetMaxBattlefieldID() do
			local queueStatus, queueMapName = GetBattlefieldStatus(i)
			--print(i, queueStatus, queueMapName, "#", GetBattlefieldStatus(i))
			if queueStatus == "active" then
				bgName = queueMapName
				break
			end
		end
		if bgMaps[bgName] then
			currentBGMap = bgName
			--print("currentBGMap1", bgName)
		end
	end

	if not currentBGMap then
		zoneName = GetRealZoneText()
		if bgMaps[zoneName] then
			currentBGMap = zoneName
			--print("currentBGMap2", zoneName)
		end
	end

	if not currentBGMap then
		local wmf = WorldMapFrame
		if wmf and not wmf:IsShown() then
			SetMapToCurrentZone()
			local mapId = GetCurrentMapAreaID()
			mapName = mapID[mapId]
			if bgMaps[mapName] then
				currentBGMap = mapName
				--print("currentBGMap3", mapName)
			end
		end
	end

	--print("reSizeCheck:", reSizeCheck, "#", currentBGMap, "#", "bgName:", bgName, "zoneName:", zoneName, "mapName:", mapName)

	if currentBGMap then
		reSizeCheck = 10
		currentSize = bgMaps[ currentBGMap ].bgSize
		isFlagBG = bgMaps[ currentBGMap ].flagBG
	else
		if reSizeCheck == 10 then
			Print("ERROR", "unknown battleground name", locale, currentBGMap, "#", "bgName:", bgName, "zoneName:", zoneName, "mapName:", mapName)
		end
		reSizeCheck = reSizeCheck + 1
		currentSize = 10
		isFlagBG = 0
	end
	-- Battleground name END ----------

	if IsRatedBattleground() then
		currentSize = 10
	end

	-- BG_FACTION_CHK
	if BattlegroundTargets.ForceDefaultFaction then
		if playerFactionDEF == 0 then
			playerFactionBG = 0   -- Horde
			oppositeFactionBG = 1 -- Alliance
		else--if playerFactionDEF == 1 then
			playerFactionBG = 1   -- Alliance
			oppositeFactionBG = 0 -- Horde
		end
		oppositeFactionREAL = nil -- reset real faction
	elseif not IsActiveBattlefieldArena() then
		local faction = GetBattlefieldArenaFaction()
		if faction == 0 then
			playerFactionBG = 0   -- Horde
			oppositeFactionBG = 1 -- Alliance
		elseif faction == 1 then
			playerFactionBG = 1   -- Alliance
			oppositeFactionBG = 0 -- Horde
		else
			Print("ERROR", "unknown battleground faction", locale, faction)
		end
		if playerFactionDEF ~= playerFactionBG then
			BattlegroundTargets.TrackFaction = true
		end
	end

	if playerLevel >= maxLevel then -- LVLCHK
		isLowLevel = nil
	else
		isLowLevel = true
	end

	if inCombat then
		reCheckBG = true
	else
		reCheckBG = false

		-- --------------------------------------------------------
		for frc = 1, #FRAMES do
			local side = FRAMES[frc]
			local button = GVAR[side.."Button"]
			-- ----------
			if BattlegroundTargets_Options[side].EnableBracket[currentSize] then
				BattlegroundTargets:Frame_SetupPosition("BattlegroundTargets_"..side.."MainFrame", side)
				GVAR[side.."MainFrame"]:EnableMouse(false)
				GVAR[side.."MainFrame"]:SetAlpha(0)
				GVAR[side.."MainFrame"]:Show() -- POSiCHK
				GVAR[side.."MainFrame"].MainMoverFrame:Hide()
				GVAR[side.."MainFrame"].MainMoverButton:Hide()
				GVAR[side.."ScoreUpdateTexture"]:Hide()
				GVAR[side.."IsGhostTexture"]:Hide()
				for i = 1, 40 do
					if i < currentSize+1 then
						BattlegroundTargets:ClearConfigButtonValues(side, button[i], true)
						button[i]:Show()
					else
						button[i]:Hide()
					end
				end
				BattlegroundTargets:SetupButtonLayout(side)
				BattlegroundTargets:SetupButtonTextures(side) -- BG_Faction_Dependent
				if BattlegroundTargets_Options[side].SummaryToggle[currentSize] then
					local Summary = GVAR[side.."Summary"]
					Summary.HealerFriend:SetText("0")
					Summary.TankFriend:SetText("0")
					Summary.DamageFriend:SetText("0")
					Summary.HealerEnemy:SetText("0")
					Summary.TankEnemy:SetText("0")
					Summary.DamageEnemy:SetText("0")
				end
			else
				GVAR[side.."MainFrame"]:Hide()
				for i = 1, 40 do
					button[i]:Hide()
				end
			end
			-- ----------
		end
		-- --------------------------------------------------------

		-- delete global_OnUpdate
		for frc = 1, #FRAMES do
			local side = FRAMES[frc]
			GVAR[side.."MainFrame"]:SetScript("OnUpdate", nil)
			GVAR[side.."ScreenShot_Timer_Button"]:SetScript("OnUpdate", nil)
			GVAR[side.."Target_Timer_Button"]:SetScript("OnUpdate", nil)
			GVAR[side.."PVPTrinket_Timer_Button"]:SetScript("OnUpdate", nil)
			GVAR[side.."RangeCheck_Timer_Button"]:SetScript("OnUpdate", nil)
		end

		-- set global_OnUpdate BEGIN -----------------------------------
		local side
		if BattlegroundTargets_Options.Enemy.EnableBracket[currentSize] then
			side = "Enemy"
		elseif BattlegroundTargets_Options.Friend.EnableBracket[currentSize] then
			side = "Friend"
		end

		-- battleground score BEGIN --
		if side then -- singleside
			BattlegroundTargets:BattlefieldScoreRequest()
			local elapsed = 0
			GVAR[side.."MainFrame"]:SetScript("OnUpdate", function(self, elap)
				elapsed = elapsed + elap
				if elapsed < scoreFrequency then return end
				elapsed = 0
				BattlegroundTargets:BattlefieldScoreRequest()
			end)
		end
		-- battleground score END -----

		--[[ -- screenshot_ BEGIN TEST --
		if side then -- singleside
			local elapsed = 0
			GVAR[side.."ScreenShot_Timer_Button"]:SetScript("OnUpdate", function(self, elap)
				elapsed = elapsed + elap
				if elapsed > 5 then
					if not inBattleground then return end
					if isConfig then return end
					--if inCombat then return end
					elapsed = 0
					Screenshot()
				end
			end)
		end
		--]] -- screenshot_ END --

		-- targeet target_of_target BEGIN --
		if side then -- singleside
			if BattlegroundTargets_Options.Friend.ButtonTargetToggle[currentSize] or
			   BattlegroundTargets_Options.Enemy.ButtonTargetToggle[currentSize] or
			   BattlegroundTargets_Options.Friend.ButtonToTToggle[currentSize] or
			   BattlegroundTargets_Options.Enemy.ButtonToTToggle[currentSize]
			then
				local elapsed = 0
				GVAR[side.."Target_Timer_Button"]:SetScript("OnUpdate", function(self, elap)
					elapsed = elapsed + elap
					if elapsed < targetFrequency then return end
					elapsed = 0
					BattlegroundTargets:CheckUnitTarget("target", playerTargetName)
				end)
			end
		end
		-- targeet target_of_target END --

		-- pvp_trinket_ BEGIN --
		if side then -- singleside
			if BattlegroundTargets_Options.Friend.ButtonPvPTrinketToggle[currentSize] or
			   BattlegroundTargets_Options.Enemy.ButtonPvPTrinketToggle[currentSize]
			then
				local elapsed = 0
				GVAR[side.."PVPTrinket_Timer_Button"]:SetScript("OnUpdate", function(self, elap)
					elapsed = elapsed + elap
					if elapsed < pvptrinketFrequency then return end
					elapsed = 0
					BattlegroundTargets:UpdateAllPvPTrinkets(true)
				end)
			end
		end
		-- pvp_trinket_ END --

		-- class_range_ BEGIN --
		local Friend_ButtonRangeToggle = BattlegroundTargets_Options.Friend.EnableBracket[currentSize] and BattlegroundTargets_Options.Friend.ButtonRangeToggle[currentSize]
		local Enemy_ButtonRangeToggle = BattlegroundTargets_Options.Enemy.EnableBracket[currentSize] and BattlegroundTargets_Options.Enemy.ButtonRangeToggle[currentSize]

		if Friend_ButtonRangeToggle and Enemy_ButtonRangeToggle then
			local elapsed = 0
			GVAR.EnemyRangeCheck_Timer_Button:SetScript("OnUpdate", function(self, elap)
				elapsed = elapsed + elap
				if elapsed > rangeFrequency then
					elapsed = 0
					for uName, uID in pairs(DATA.Friend.Name2UnitID) do
						local button = GVAR.FriendButton[ DATA.Friend.Name2Button[ uName ] ]
						if button then
							BattlegroundTargets:CheckClassRange("Friend", button, uID, uName, "onupdate")
						end
					end
					BattlegroundTargets:UpdateRange("Enemy", GetTime())
				end
			end)

		elseif Friend_ButtonRangeToggle then

			local elapsed = 0
			GVAR.FriendRangeCheck_Timer_Button:SetScript("OnUpdate", function(self, elap)
				elapsed = elapsed + elap
				if elapsed > rangeFrequency then
					elapsed = 0
					for uName, uID in pairs(DATA.Friend.Name2UnitID) do
						local button = GVAR.FriendButton[ DATA.Friend.Name2Button[ uName ] ]
						if button then
							BattlegroundTargets:CheckClassRange("Friend", button, uID, uName, "onupdate")
						end
					end
				end
			end)

		elseif Enemy_ButtonRangeToggle then

			local elapsed = 0
			GVAR.EnemyRangeCheck_Timer_Button:SetScript("OnUpdate", function(self, elap)
				elapsed = elapsed + elap
				if elapsed > rangeFrequency then
					elapsed = 0
					BattlegroundTargets:UpdateRange("Enemy", GetTime())
				end
			end)

		end
		-- class_range_ END --
		-- set global_OnUpdate END -----------------------------------
	end

	BattlegroundTargets:EventUnregister()
	BattlegroundTargets:EventRegister("showerror")
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:IsNotBattleground()
	if not inBattleground and not reCheckBG then return end

	--for k, v in pairs(eventTest) do print("eventtest:", k, v) end -- TEST
	--[[
	for k, v in pairs(SPELL_Range) do
		print("spellrange:", k, v, "#", SpellHasRange(k), "#", GetSpellInfo(k))
	end
	--]]

	inBattleground = false

	reCheckBG = nil
	reCheckScore = nil

	currentBGMap = nil
	reSizeCheck = 0

	oppositeFactionREAL = nil

	flagDebuff = 0 -- FLGRST
	flags = 0
	isFlagBG = 0
	flagCHK = nil
	flagflag = nil

	DATA.Friend.isLeader = nil
	DATA.Friend.hasFlag = nil
	DATA.Enemy.isLeader = nil
	DATA.Enemy.hasFlag = nil
	hasOrb = {Green={name=nil,orbval=nil},Blue={name=nil,orbval=nil},Purple={name=nil,orbval=nil},Orange={name=nil,orbval=nil}}

	scoreFrequency = 1
	scoreCount = 0

	BattlegroundTargets.ForceDefaultFaction = nil
	BattlegroundTargets.TrackFaction = nil
	BattlegroundTargets.UnknownNameIndex = nil

	if isLowLevel then -- LVLCHK
		BattlegroundTargets:CheckPlayerLevel()
	end
	BattlegroundTargets:EventUnregister()

	wipe(DATA.TargetCountNames) -- TC_DEFDEL
	wipe(DATA.TargetCountTargetID) -- TC_DEFDEL
	wipe(DATA.TargetFCountNum) -- TC_FRIEND_DEF
	wipe(DATA.TargetECountNum) -- TC_ENEMY_DEF
	wipe(DATA.TransName)
	wipe(DATA.FirstFlagCheck)
	wipe(DATA.PvPTrinketEndTime)

	for frc = 1, #FRAMES do
		local side = FRAMES[frc]
		if not isConfig then
			wipe(DATA[side].MainData)
		end
		wipe(DATA[side].Name4Flag)
		wipe(DATA[side].Name2Button)
		wipe(DATA[side].Name2Level)
		wipe(DATA[side].Name2Percent)
		wipe(DATA[side].Name2Range)
	end

	if testData.specTest then
		---debug( wait for next update
		--for k, v in pairs(testData.specTest) do
--			for k2, v2 in pairs(v) do
				--Print("ERROR#3 unknown spec:", v2.locale, v2.faction, v2.classToken, v2.talentSpec)
			--end
		
		--end
		testData.specTest = nil
	end

	if inCombat or InCombatLockdown() then
		reCheckBG = true
	else
		reCheckBG = false

		if playerFactionDEF == 0 then -- summary_flag_texture - 2 - reset
			GVAR.FriendSummary.Logo2:SetTexture("Interface\\FriendsFrame\\PlusManz-Alliance")
			GVAR.EnemySummary.Logo2:SetTexture("Interface\\FriendsFrame\\PlusManz-Alliance")
		elseif playerFactionDEF == 1 then
			GVAR.FriendSummary.Logo2:SetTexture("Interface\\FriendsFrame\\PlusManz-Horde")
			GVAR.EnemySummary.Logo2:SetTexture("Interface\\FriendsFrame\\PlusManz-Horde")
		else
			GVAR.FriendSummary.Logo2:SetTexture("Interface\\Timer\\Panda-Logo")
			GVAR.EnemySummary.Logo2:SetTexture("Interface\\Timer\\Panda-Logo")
		end

		-- delete global_OnUpdate
		for frc = 1, #FRAMES do
			local side = FRAMES[frc]
			GVAR[side.."MainFrame"]:SetScript("OnUpdate", nil)
			GVAR[side.."ScreenShot_Timer_Button"]:SetScript("OnUpdate", nil)
			GVAR[side.."Target_Timer_Button"]:SetScript("OnUpdate", nil)
			GVAR[side.."PVPTrinket_Timer_Button"]:SetScript("OnUpdate", nil)
			GVAR[side.."RangeCheck_Timer_Button"]:SetScript("OnUpdate", nil)
		end

		GVAR.FriendMainFrame:Hide()
		GVAR.EnemyMainFrame:Hide()
		for i = 1, 40 do
			GVAR.FriendButton[i].FocusTextureButton:SetScript("OnUpdate", nil) -- TODO
			GVAR.FriendButton[i]:Hide()
			GVAR.EnemyButton[i].FocusTextureButton:SetScript("OnUpdate", nil) -- TODO
			GVAR.EnemyButton[i]:Hide()
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:GroupRosterUpdate()
	local BattlegroundTargets_Options = BattlegroundTargets_Options

	BattlegroundTargets:GroupUnitIDUpdate()

	scoreFrequency = 0 -- immediate update
	BattlegroundTargets:BattlefieldScoreRequest()

	-- assist_
	if (BattlegroundTargets_Options.Friend.EnableBracket[currentSize] and BattlegroundTargets_Options.Friend.ButtonAssistToggle[currentSize]) or
	   (BattlegroundTargets_Options.Enemy.EnableBracket[currentSize] and BattlegroundTargets_Options.Enemy.ButtonAssistToggle[currentSize])
	then
		BattlegroundTargets:CheckAssist()
	end

	-- leader_
	if BattlegroundTargets_Options.Friend.EnableBracket[currentSize] and
	   BattlegroundTargets_Options.Friend.ButtonLeaderToggle[currentSize]
	then
		BattlegroundTargets:FriendLeaderUpdate()
	end
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:GroupUnitIDUpdate()
	wipe(DATA.Friend.Name2UnitID)
	local numMembers = GetNumGroupMembers()
	local verified = 0

	for num = 1, numMembers do
		local unitID = "raid"..num
		if UnitExists(unitID) then
			local fName, _, _, _, _, class = GetRaidRosterInfo(num)
			if fName then
				DATA.Friend.Name2UnitID[ fName ] = unitID
				DATA.Friend.UnitID2Name[ unitID ] = fName
				verified = verified + 1
			end
		end
	end

	if numMembers == verified then
		BattlegroundTargets.GroupUpdateTimer = nil
	else
		BattlegroundTargets.GroupUpdateTimer = GetTime()
	end

	--[[
	print("- BEGIN ---------------------------")
	print("numMembers:", numMembers, "verified:", verified)
	for k,v in pairs(DATA.Friend.Name2UnitID) do print(k,v) end
	print("- END ---------------------------")
	--]]
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:UpdateToTButton(sourceButton) -- target_of_target
	local ToTButton = sourceButton.ToTButton

	local totSide =     ToTButton.totData.totSide
	local totName =     ToTButton.totData.totName
	local totFullName = ToTButton.totData.totFullName
	local classToken =  ToTButton.totData.classToken
	local talentSpec =  Textures.RoleIcon[ ToTButton.totData.talentSpec ]
	local targetID =    ToTButton.totData.targetID

	local colR = classcolors[classToken].r
	local colG = classcolors[classToken].g
	local colB = classcolors[classToken].b
	local colR5 = colR*0.5
	local colG5 = colG*0.5
	local colB5 = colB*0.5

	--print("*totupd*", totSide, totFullName, "#", totName, "#", sourceButton.buttonNum, targetID)

	ToTButton.Name:SetText(totName)-- only name, no realm
	ToTButton.ClassColorBackground:SetColorTexture(colR5, colG5, colB5, 1)
	ToTButton.HealthBar:SetColorTexture(colR, colG, colB, 1)
	ToTButton.RoleTexture:SetTexCoord(talentSpec[1], talentSpec[2], talentSpec[3], talentSpec[4])

	local BattlegroundTargets_Options = BattlegroundTargets_Options
	local ButtonHealthBarToggle = BattlegroundTargets_Options[totSide].ButtonHealthBarToggle[currentSize]
	local ButtonHealthTextToggle = BattlegroundTargets_Options[totSide].ButtonHealthTextToggle[currentSize]

	if ButtonHealthBarToggle or ButtonHealthTextToggle then
		local percentE = DATA[totSide].Name2Percent[totFullName]
		if percentE then
			--------------------
			if ButtonHealthBarToggle then
				local width = DATA[totSide].totHealthBarWidth * (percentE / 100)
				width = math_max(0.01, width)
				width = math_min(DATA[totSide].totHealthBarWidth, width)
				ToTButton.HealthBar:SetWidth(width)
			end
			if ButtonHealthTextToggle then
				ToTButton.HealthText:SetText(percentE)
			end
			--------------------
		else
			--------------------
			local maxHealth = UnitHealthMax(targetID)
			if maxHealth then
				local health = UnitHealth(targetID)
				if health then
					local width = 0.01
					local percent = 0
					if maxHealth > 0 and health > 0 then
						local hvalue = maxHealth / health
						width = DATA[totSide].totHealthBarWidth / hvalue
						width = math_max(0.01, width)
						width = math_min(DATA[totSide].totHealthBarWidth, width)
						percent = floor( (100/hvalue) + 0.5 )
						percent = math_max(0, percent)
						percent = math_min(100, percent)
					end
					if ButtonHealthBarToggle then
						ToTButton.HealthBar:SetWidth(width)
					end
					if ButtonHealthTextToggle then
						ToTButton.HealthText:SetText(percent)
					end
				end
			end
			--------------------
		end
	end

	if totSide  == "Enemy" then
		ToTButton.FactionTexture:SetTexture(Textures.EnemyIcon.path)
		ToTButton.FactionTexture:SetTexCoord(unpack(Textures.EnemyIcon.coords))
	else
		ToTButton.FactionTexture:SetTexture(Textures.FriendIcon.path)
		ToTButton.FactionTexture:SetTexCoord(unpack(Textures.FriendIcon.coords))
	end
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CheckToTTarget(sourceButton, targetID, targetName, caller) -- target_of_target
	local totFullName, totName, totRealm
	if targetName then
		if DATA.Friend.Name4Flag[targetName] or DATA.Enemy.Name4Flag[targetName] then
			totName = targetName
		elseif strfind(targetName, "-", 1, true) then
			totName, totRealm = strmatch(targetName, "(.-)%-(.*)$")
		end
		totFullName = targetName
	else
		totFullName, totRealm = UnitName(targetID)
		totName = totFullName
		if totRealm and totRealm ~= "" then
			totFullName = totFullName.."-"..totRealm
		end
		--print("INPUT_NAME_CHECK: _TOT_", targetID, "#", totFullName, "#", caller)
	end

	local totSide, classToken, talentSpec
	local Friend_Name2Button = DATA.Friend.MainData[ DATA.Friend.Name2Button[totFullName] ]
	local Enemy_Name2Button = DATA.Enemy.MainData[ DATA.Enemy.Name2Button[totFullName] ]
	if Friend_Name2Button then
		totSide = "Friend"
		classToken = Friend_Name2Button.classToken
		talentSpec = Friend_Name2Button.talentSpec
	elseif Enemy_Name2Button then
		totSide = "Enemy"
		classToken = Enemy_Name2Button.classToken
		talentSpec = Enemy_Name2Button.talentSpec
	end

	if classToken then
		if BattlegroundTargets_Options.TransliterationToggle then
			if DATA.TransName[totName] then
				totName = DATA.TransName[totName]
			end
		end
		sourceButton.ToTButton.totData = {
			totSide = totSide,
			totName = totName,
			totFullName = totFullName,
			classToken = classToken,
			talentSpec = talentSpec,
			targetID = targetID,
		}
		BattlegroundTargets:UpdateToTButton(sourceButton)
		sourceButton.ToTButton:SetAlpha(1)
	else
		sourceButton.ToTButton.totData = nil
		sourceButton.ToTButton:SetAlpha(0)
	end
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
local function ct_substract(sourceName)
	local targetName = DATA.TargetCountNames[ sourceName ]
	if targetName then

		if DATA.Enemy.Name2Button[ targetName ] then -- enemy
			if DATA.TargetECountNum[ targetName ] then
				DATA.TargetECountNum[ targetName ] = math_max(0, DATA.TargetECountNum[ targetName ] - 1) -- TC_ENEMY_DEF
			end
		elseif DATA.Friend.Name2Button[ targetName ] then -- friend
			if DATA.TargetFCountNum[ targetName ] then
				DATA.TargetFCountNum[ targetName ] = math_max(0, DATA.TargetFCountNum[ targetName ] - 1) -- TC_FRIEND_DEF
			end
		end

		DATA.TargetCountNames[ sourceName ] = nil -- TC_DEFDEL
		DATA.TargetCountTargetID[ sourceName ] = nil -- TC_DEFDEL
	end
end

local function ct_check(targetID, sourceName, targetName)
	if not sourceName then return end
	if targetName then
		------------------
		local oldTargetName = DATA.TargetCountNames[ sourceName ]
		if oldTargetName and oldTargetName ~= targetName then
			ct_substract(sourceName)
		end

		if not DATA.TargetCountNames[ sourceName ] or DATA.TargetCountNames[ sourceName ] ~= targetName then
			DATA.TargetCountNames[ sourceName ] = targetName -- TC_DEFDEL
			DATA.TargetCountTargetID[ sourceName ] = targetID -- TC_DEFDEL
			-- ----------------------------------------------------
			if (DATA.Friend.Name2Button[ sourceName ] and DATA.Enemy.Name2Button[ targetName ]) or -- friend -> enemy
			   (DATA.Enemy.Name2Button[ sourceName ] and DATA.Friend.Name2Button[ targetName ])    -- enemy -> friend
			then
				-- TC_ENEMY_DEF ----------
				if DATA.TargetECountNum[ targetName ] then
					DATA.TargetECountNum[ targetName ] = DATA.TargetECountNum[ targetName ] + 1
				else
					DATA.TargetECountNum[ targetName ] = 1
				end
				 -- -----------------------
			elseif (DATA.Friend.Name2Button[ sourceName ] and DATA.Friend.Name2Button[ targetName ]) or -- friend -> friend
			       (DATA.Enemy.Name2Button[ sourceName ] and DATA.Enemy.Name2Button[ targetName ])      -- enemy -> enemy
			then
				-- TC_FRIEND_DEF ----------
				if DATA.TargetFCountNum[ targetName ] then
					DATA.TargetFCountNum[ targetName ] = DATA.TargetFCountNum[ targetName ] + 1
				else
					DATA.TargetFCountNum[ targetName ] = 1
				end
				-- ------------------------
			end
			-- ----------------------------------------------------
		end
		------------------
	else
		ct_substract(sourceName)
	end
end

--                                       "player", playerName, "target", nil
--                                       "player", playerName, "focus" , "name-realm"
function BattlegroundTargets:CheckTarget(friendID, friendName, targetID, targetName, caller) -- targetcount_ -- target_of_target
	if isDeadUpdateStop then return end
	if targetID == "focus" then return end -- targetcount_focus

	local BattlegroundTargets_Options = BattlegroundTargets_Options
	local TargetCount = BattlegroundTargets_Options.Enemy.ButtonETargetCountToggle[currentSize] or
	                    BattlegroundTargets_Options.Enemy.ButtonFTargetCountToggle[currentSize] or
	                    BattlegroundTargets_Options.Friend.ButtonFTargetCountToggle[currentSize] or
	                    BattlegroundTargets_Options.Friend.ButtonETargetCountToggle[currentSize]
	local Friend_ButtonToTToggle = BattlegroundTargets_Options.Friend.ButtonToTToggle[currentSize]
	local Enemy_ButtonToTToggle = BattlegroundTargets_Options.Enemy.ButtonToTToggle[currentSize]

	-- connections
	if TargetCount or Friend_ButtonToTToggle or Enemy_ButtonToTToggle then
		local curTime = GetTime()
		if curTime > BattlegroundTargets.targetCountTimer + targetCountFrequency then
			BattlegroundTargets.targetCountTimer = curTime
			wipe(DATA.TargetCountNames) -- TC_DEFDEL
			wipe(DATA.TargetCountTargetID) -- TC_DEFDEL
			wipe(DATA.TargetFCountNum) -- TC_FRIEND_DEF
			wipe(DATA.TargetECountNum) -- TC_ENEMY_DEF
			for fName, fID in pairs(DATA.Friend.Name2UnitID) do
				if DATA.Friend.Name2Button[ fName ] then
					-- BEGIN -------------
					local tID = fID.."target"
					local ftName = GetUnitFullName(tID)
					--print("ttct1:", tID, fName, ftName)
					ct_check(tID, fName, ftName)
					---------------
					if ftName and fName ~= ftName then
						local tID = fID.."targettarget"
						local fttName = GetUnitFullName(fID.."targettarget")
						--print("ttct2:", tID, ftName, fttName)
						ct_check(tID, ftName, fttName)
						---------------
						if fttName and ftName ~= fttName then
							local tID = fID.."targettargettarget"
							local ftttName = GetUnitFullName(fID.."targettargettarget")
							--print("ttct3:", tID, fttName, ftttName)
							ct_check(tID, fttName, ftttName)
							---------------
						end
					end
					-- END -------------
				end
			end
		else
			ct_check(targetID, friendName, targetName)
			if targetName ~= playername and targetID then
				local targettargetID = targetID.."target"
				local targettargetName = GetUnitFullName(targettargetID)
				ct_check(targettargetID, targetName, targettargetName)
			end
		end
	end

	-- target_of_target display
	if Friend_ButtonToTToggle or Enemy_ButtonToTToggle then
		for frc = 1, #FRAMES do
			local side = FRAMES[frc]
			if BattlegroundTargets_Options[side].EnableBracket[currentSize] then
				---------------
				local button = GVAR[side.."Button"]
				for i = 1, currentSize do
					if DATA[side].MainData[i] then
						---------------
						local sourceName = DATA[side].MainData[i].name
						local targetName = DATA.TargetCountNames[sourceName]
						if targetName then
							BattlegroundTargets:CheckToTTarget(button[i], DATA.TargetCountTargetID[sourceName], targetName, "checktarget")
						else
							button[i].ToTButton.totData = nil
							button[i].ToTButton:SetAlpha(0)
						end
						---------------
					else
						button[i].ToTButton.totData = nil
						button[i].ToTButton:SetAlpha(0)
					end
				end
				---------------
			end
		end
	end

	-- targetcount_ display
	if TargetCount then
		for frc = 1, #FRAMES do
			local side = FRAMES[frc]
			if BattlegroundTargets_Options[side].EnableBracket[currentSize] then
				---------------
				local button = GVAR[side.."Button"]
				for i = 1, currentSize do
					if DATA[side].MainData[i] then
						---------------
						local count = DATA.TargetFCountNum[ DATA[side].MainData[i].name ]
						if count then
							button[i].FTargetCount:SetText(count)
						else
							button[i].FTargetCount:SetText("0")
						end
						---------------
						local count = DATA.TargetECountNum[ DATA[side].MainData[i].name ]
						if count then
							button[i].ETargetCount:SetText(count)
						else
							button[i].ETargetCount:SetText("0")
						end
						---------------
					else
						button[i].FTargetCount:SetText("")
						button[i].ETargetCount:SetText("")
					end
				end
				---------------
			end
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CheckPlayerHealth(side, button, unitID, unitName, caller) -- health_
	local curTime = GetTime()
	if curTime < button.healthTimer + healthFrequency then
		return
	end

	--[[ _TIMER_
	local dif = curTime - button.healthTimer
	print("health:", side, button.buttonNum, unitID, unitName, "#", dif, "#", caller)
	--]]

	button.healthTimer = curTime

	local BattlegroundTargets_Options = BattlegroundTargets_Options
	local ButtonHealthBarToggle = BattlegroundTargets_Options[side].ButtonHealthBarToggle[currentSize]
	local ButtonHealthTextToggle = BattlegroundTargets_Options[side].ButtonHealthTextToggle[currentSize]

	if ButtonHealthBarToggle or ButtonHealthTextToggle then
		local width = 0.01
		local percent = 0

		local maxHealth = UnitHealthMax(unitID)
		if maxHealth then
			local health = UnitHealth(unitID)
			if health then
				if maxHealth > 0 and health > 0 then
					local hvalue = maxHealth / health
					width = DATA[side].healthBarWidth / hvalue
					width = math_max(0.01, width)
					width = math_min(DATA[side].healthBarWidth, width)
					percent = floor( (100/hvalue) + 0.5 )
					percent = math_max(0, percent)
					percent = math_min(100, percent)
				end
			end
		end

		DATA[side].Name2Percent[unitName] = percent

		if ButtonHealthBarToggle then
			button.HealthBar:SetWidth(width)
		end
		if ButtonHealthTextToggle then
			button.HealthText:SetText(percent)
		end

		if BattlegroundTargets_Options[side].EnableBracket[currentSize] and
		   BattlegroundTargets_Options[side].ButtonToTToggle[currentSize]
		then
			if percent == 0 then
				BattlegroundTargets:ClearToTButtonByName(unitName)
			elseif button.ToTButton.totData then
				BattlegroundTargets:UpdateToTButton(button)
				button.ToTButton:SetAlpha(1)
			end
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CheckPlayerTarget()
	local BattlegroundTargets_Options = BattlegroundTargets_Options

	playerTargetName = GetUnitFullName("target")

	for frc = 1, #FRAMES do
		local side = FRAMES[frc]
		if BattlegroundTargets_Options[side].EnableBracket[currentSize] then
			-- targeet reset all BEGIN -----
			local button = GVAR[side.."Button"]
			for i = 1, currentSize do
				button[i].TargetTexture:SetAlpha(0)
				button[i].HighlightT:SetColorTexture(0, 0, 0, 1)
				button[i].HighlightR:SetColorTexture(0, 0, 0, 1)
				button[i].HighlightB:SetColorTexture(0, 0, 0, 1)
				button[i].HighlightL:SetColorTexture(0, 0, 0, 1)
				button[i].FlagDebuffButton:SetScript("OnUpdate", nil)
			end
			-- targeet reset all END -----
		end
	end

	isTargetButton = nil
	local isTargetSide

	for frc = 1, #FRAMES do
		local side = FRAMES[frc]
		if BattlegroundTargets_Options[side].EnableBracket[currentSize] then
			-- targeet BEGIN -----
			local button = GVAR[side.."Button"][ DATA[side].Name2Button[ playerTargetName ] ]
			if button then
				if BattlegroundTargets_Options[side].ButtonTargetToggle[currentSize] then
					button.TargetTexture:SetAlpha(1)
					button.HighlightT:SetColorTexture(0.5, 0.5, 0.5, 1)
					button.HighlightR:SetColorTexture(0.5, 0.5, 0.5, 1)
					button.HighlightB:SetColorTexture(0.5, 0.5, 0.5, 1)
					button.HighlightL:SetColorTexture(0.5, 0.5, 0.5, 1)
				end
				isTargetButton = button
				isTargetSide = side
				break
			end
			-- targeet END -----
		end
	end

	BattlegroundTargets:CheckUnitTarget("target", playerTargetName)

	if not isTargetButton then return end

	-- -- carrier_debuff_ BEGIN -----
	if BattlegroundTargets_Options[isTargetSide].ButtonFlagToggle[currentSize] then
		if (DATA[isTargetSide].hasFlag and DATA[isTargetSide].hasFlag == playerTargetName) or isTargetButton.orbColor then
			local elapsed = carrierDebuffFrequency -- immediate init update
			isTargetButton.FlagDebuffButton:SetScript("OnUpdate", function(self, elap)
				elapsed = elapsed + elap
				if elapsed > carrierDebuffFrequency then
					elapsed = 0
					BattlegroundTargets:CarrierDebuffCheck(isTargetSide, isTargetButton, "target", playerTargetName)
				end
			end)
		end
	end
	-- -- carrier_debuff_ END -----
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CheckPlayerFocus()
	local BattlegroundTargets_Options = BattlegroundTargets_Options

	playerFocusName = GetUnitFullName("focus")

	-- reset focus_
	for frc = 1, #FRAMES do
		local side = FRAMES[frc]
		if BattlegroundTargets_Options[side].EnableBracket[currentSize] then
			local button = GVAR[side.."Button"]
			for i = 1, currentSize do
				button[i].FocusTexture:SetAlpha(0)
				button[i].FocusTextureButton:SetScript("OnUpdate", nil) -- TODO
			end
		end
	end

	if not playerFocusName then return end

	-- set focus_ -- TODO
	for frc = 1, #FRAMES do
		local side = FRAMES[frc]
		if BattlegroundTargets_Options[side].EnableBracket[currentSize] then
			local button = GVAR[side.."Button"][ DATA[side].Name2Button[ playerFocusName ] ]
			if button then
				-- focus_ BEGIN -----
				button.FocusTexture:SetAlpha(1)
				if not inCombat then
					button:SetAttribute("macrotext2", "/targetexact "..playerFocusName.."\n/clearfocus\n/targetlasttarget")
				end
				local elapsed = focusFrequency -- immediate init update
				button.FocusTextureButton:SetScript("OnUpdate", function(self, elap)
					elapsed = elapsed + elap
					if elapsed > focusFrequency then
						elapsed = 0
						BattlegroundTargets:CheckUnitTarget("focus", playerFocusName)
					end
				end)
				-- focus_ END -----
				break
			end
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:FriendLeaderUpdate() -- leader_
	for unitName, unitID in pairs(DATA.Friend.Name2UnitID) do
		if UnitIsGroupLeader(unitID) then
			local clrButton = GVAR.FriendButton
			for i = 1, currentSize do
				clrButton[i].LeaderTexture:SetAlpha(0)
			end
			local button = GVAR.FriendButton[ DATA.Friend.Name2Button[ unitName ] ]
			if button then
				DATA.Friend.isLeader = unitName
				button.leaderTimer = GetTime()
				button.LeaderTexture:SetAlpha(1)
			end
			return
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CheckLeader(side, button, unitID, unitName) -- leader_
	local BattlegroundTargets_Options = BattlegroundTargets_Options

	if not BattlegroundTargets_Options[side].ButtonLeaderToggle[currentSize] then return end

	if DATA[side].isLeader then
		local curTime = GetTime()
		if curTime < button.leaderTimer + leaderFrequency then
			return
		end
		button.leaderTimer = curTime
		if DATA[side].isLeader ~= unitName and UnitIsGroupLeader(unitID) then
			local clrButton = GVAR[side.."Button"]
			for i = 1, currentSize do
				clrButton[i].LeaderTexture:SetAlpha(0)
			end
			DATA[side].isLeader = unitName
			button.LeaderTexture:SetAlpha(1)
		end
	elseif UnitIsGroupLeader(unitID) then
		local clrButton = GVAR[side.."Button"]
		for i = 1, currentSize do
			clrButton[i].LeaderTexture:SetAlpha(0)
		end
		DATA[side].isLeader = unitName
		button.leaderTimer = GetTime()
		button.LeaderTexture:SetAlpha(1)
	end
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CheckAssist()
	local BattlegroundTargets_Options = BattlegroundTargets_Options

	isAssistUnitId = nil
	isAssistName = nil
	for i = 1, GetNumGroupMembers() do
		local name, _, _, _, _, _, _, _, _, role = GetRaidRosterInfo(i)
		if role == "MAINASSIST" and name then
			isAssistName = name
			isAssistUnitId = "raid"..i.."target"
			break
		end
	end

	-- reset assist_
	for frc = 1, #FRAMES do
		local side = FRAMES[frc]
		if BattlegroundTargets_Options[side].EnableBracket[currentSize] then
			local button = GVAR[side.."Button"]
			for i = 1, currentSize do
				button[i].AssistTargetTexture:SetAlpha(0)
				button[i].AssistSourceTexture:SetAlpha(0)
			end
		end
	end

	if not isAssistName then return end

	-- set source assist_
	if BattlegroundTargets_Options.Friend.EnableBracket[currentSize] then
		local button = GVAR.FriendButton[ DATA.Friend.Name2Button[isAssistName] ]
		if button then
			button.AssistSourceTexture:SetAlpha(1)
		end
	end

	playerAssistTargetName = GetUnitFullName(isAssistUnitId)

	if not playerAssistTargetName then return end

	-- set target assist_
	for frc = 1, #FRAMES do
		local side = FRAMES[frc]
		if BattlegroundTargets_Options[side].EnableBracket[currentSize] then
			local button = GVAR[side.."Button"][ DATA[side].Name2Button[playerAssistTargetName] ]
			if button then
				button.AssistTargetTexture:SetAlpha(1)
				break
			end
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CheckUnitTarget(unitID, unitName, isEvent)
	local friendID, friendName
	local targetID, targetName

	if isEvent then
		if not raidUnitID[unitID] then return end
		friendID   = unitID
		friendName = GetUnitFullName(unitID)
		targetID   = unitID.."target"
		targetName = GetUnitFullName(targetID)
	elseif unitID == "focus" then -- targetcount_focus
		friendID   = "player"
		friendName = playerName
		targetID   = "focus"
		targetName = unitName
	elseif unitID == "target" then -- targeet
		friendID   = "player"
		friendName = playerName
		targetID   = "target"
		targetName = unitName
	end
	-- friendName = nil is possible
	-- targetName = nil is possible
	--print("friendID:", friendID, "friendName:", friendName, "targetID:", targetID, "targetName:", targetName)

	BattlegroundTargets:CheckTarget(friendID, friendName, targetID, targetName, "checkunittarget") -- targetcount_ -- target_of_target
	BattlegroundTargets:UpdateAllPvPTrinkets() -- pvp_trinket_

	local side
	if DATA.Enemy.Name2Button[ targetName ] then
		side = "Enemy"
	elseif DATA.Friend.Name2Button[ targetName ] then
		side = "Friend"
	end
	if not side then return end

	-- real opposite faction check
	if not oppositeFactionREAL and side == "Enemy" then -- summary_flag_texture - 2 - set in bg
		local factionGroup = UnitFactionGroup(targetID)
		if factionGroup == "Horde" then
			GVAR.FriendSummary.Logo2:SetTexture("Interface\\FriendsFrame\\PlusManz-Horde")
			GVAR.EnemySummary.Logo2:SetTexture("Interface\\FriendsFrame\\PlusManz-Horde")
			oppositeFactionREAL = 0
		elseif factionGroup == "Alliance" then
			GVAR.FriendSummary.Logo2:SetTexture("Interface\\FriendsFrame\\PlusManz-Alliance")
			GVAR.EnemySummary.Logo2:SetTexture("Interface\\FriendsFrame\\PlusManz-Alliance")
			oppositeFactionREAL = 1
		end
	end

	local button = GVAR[side.."Button"][ DATA[side].Name2Button[targetName] ]
	if not button then return end

	local BattlegroundTargets_Options = BattlegroundTargets_Options
	if not BattlegroundTargets_Options[side].EnableBracket[currentSize] then return end

	BattlegroundTargets:CheckPlayerHealth(side, button, targetID, targetName, "checkunittarget") -- health_
	BattlegroundTargets:CheckCarrierDebuff(side, button, targetID, targetName, "checkunittarget") -- FLAGSPY -- carrier_debuff_
	BattlegroundTargets:CheckClassRange(side, button, targetID, targetName, "checkunittarget") -- class_range_
	BattlegroundTargets:CheckLeader(side, button, targetID, targetName) -- leader_

	-- target assist_
	if isAssistName and BattlegroundTargets_Options[side].ButtonAssistToggle[currentSize] then
		local curTime = GetTime()
		if isAssistName == friendName then
			local clrButton = GVAR[side.."Button"]
			for i = 1, currentSize do
				clrButton[i].AssistTargetTexture:SetAlpha(0)
			end
			playerAssistTargetName = targetName
			button.AssistTargetTexture:SetAlpha(1)
		elseif curTime > button.assistTimer + assistFrequency then
			button.assistTimer = curTime
			local clrButton = GVAR[side.."Button"]
			for i = 1, currentSize do
				clrButton[i].AssistTargetTexture:SetAlpha(0)
			end
			playerAssistTargetName = GetUnitFullName(isAssistUnitId)
			local nButton = GVAR[side.."Button"][ DATA[side].Name2Button[playerAssistTargetName] ]
			if nButton then
				nButton.AssistTargetTexture:SetAlpha(1)
			end
		end
	end

	-- level
	if isLowLevel and playerLevel ~= 100 then -- LVLCHK
		local level = UnitLevel(targetID) or 0
		if level > 0 then
			DATA[side].Name2Level[targetName] = level
			button.Name:SetText(level.." "..button.name4button)
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CheckUnitHealth(sourceID)
	local BattlegroundTargets_Options = BattlegroundTargets_Options

	for frc = 1, #FRAMES do
		local side = FRAMES[frc]
		if BattlegroundTargets_Options[side].EnableBracket[currentSize] then

			local targetID
			if side == "Enemy" then
				if raidUnitID[sourceID] then
					targetID = sourceID.."target"
				elseif playerUnitID[sourceID] then
					targetID = sourceID
				end
			else
				if raidUnitID[sourceID] then
					targetID = sourceID
				--elseif playerUnitID[sourceID] then
				--	targetID = sourceID
				end
			end

			-- -----
			if targetID then
				local uName = GetUnitFullName(targetID)
				local button = GVAR[side.."Button"][ DATA[side].Name2Button[ uName ] ]
				if button then
					BattlegroundTargets:CheckPlayerHealth(side, button, targetID, uName, "checkunithealth") -- health_
					BattlegroundTargets:CheckCarrierDebuff(side, button, targetID, uName, "checkunithealth") -- FLAGSPY -- carrier_debuff_
					BattlegroundTargets:CheckClassRange(side, button, targetID, uName, "checkunithealth") -- class_range_
				end
			end
			-- -----

		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CheckFlagCarrierCHECK(unitID, unitName) -- FLAGSPY
	if not DATA.FirstFlagCheck[unitName] then return end

	if isFlagBG >= 1 and isFlagBG <= 4 then--if isFlagBG == 1 or isFlagBG == 2 or isFlagBG == 3 or isFlagBG == 4 then

		-- enemy buff & debuff check
		for i = 1, 40 do
			local _, _, _, _, _, _, _, _, _, spellId = UnitBuff(unitID, i) --aby8
			if not spellId then break end
			if flagIDs[spellId] then
				DATA.Enemy.hasFlag = unitName
				flagDebuff = 0
				flags = flags + 1

				for j = 1, 40 do
					local _, _, count, _, _, _, _, _, _, spellId = UnitDebuff(unitID, j) --aby8
					if not spellId then break end
					if debuffIDs[spellId] then
						flagDebuff = count
						break
					end
				end

				local button = GVAR.EnemyButton
				for j = 1, currentSize do
					button[j].FlagTexture:SetAlpha(0)
					button[j].FlagDebuff:SetText("")
				end
				local button = GVAR.EnemyButton[ DATA.Enemy.Name2Button[unitName] ]
				if button then
					button.FlagTexture:SetAlpha(1)
					BattlegroundTargets:SetFlagDebuff(button, flagDebuff)
				end

				BattlegroundTargets:CheckFlagCarrierEND()
				return
			end
		end

	elseif isFlagBG == 5 then

		-- enemy debuff check
		if flags >= totalFlags[isFlagBG] then
			BattlegroundTargets:CheckFlagCarrierEND()
			return
		end
		for i = 1, 40 do
			local _, _, _, _, _, _, _, _, _, spellId, _, _, _, _, val2 = UnitDebuff(unitID, i) --aby8
			--print(i, spellId, val2, "#", UnitDebuff(unitID, i))
			if not spellId then break end
			if orbIDs[spellId] then
				flags = flags + 1 -- FLAG_TOK_CHK

				local button = GVAR.EnemyButton[ DATA.Enemy.Name2Button[unitName] ]
				if button then
					local oID = orbIDs[spellId]
					hasOrb[ oID.color ].name = unitName
					hasOrb[ oID.color ].orbval = val2
					button.orbColor = oID.color
					button.FlagTexture:SetAlpha(1)
					button.FlagTexture:SetTexture(oID.texture)
					BattlegroundTargets:SetFlagDebuff(button, val2)
					BattlegroundTargets:SetOrbCorner(button, oID.color)
				end

				if flags >= totalFlags[isFlagBG] then
					BattlegroundTargets:CheckFlagCarrierEND()
					return
				end
				break
			end
		end

	end

	DATA.FirstFlagCheck[unitName] = nil

	local x
	for k in pairs(DATA.FirstFlagCheck) do
		x = true
		break
	end
	if not x then
		BattlegroundTargets:CheckFlagCarrierEND()
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CheckFlagCarrierSTART() -- FLAGSPY
	local BattlegroundTargets_Options = BattlegroundTargets_Options

	if isFlagBG >= 1 and isFlagBG <= 4 then--if isFlagBG == 1 or isFlagBG == 2 or isFlagBG == 3 or isFlagBG == 4 then

		-- friend buff & debuff check
		local function chk()
			for num = 1, GetNumGroupMembers() do
				local unitID = "raid"..num
				for i = 1, 40 do
					local _, _, _, _, _, _, _, _, _, spellId = UnitBuff(unitID, i) --aby8
					if not spellId then break end
					if flagIDs[spellId] then
						flagDebuff = 0
						flags = 1

						for j = 1, 40 do
							local _, _, count, _, _, _, _, _, _, spellId = UnitDebuff(unitID, j) --aby8
							if not spellId then break end
							if debuffIDs[spellId] then
								flagDebuff = count
								break
							end
						end

						-- ----------
						if BattlegroundTargets_Options.Friend.ButtonFlagToggle[currentSize] then
							local button = GVAR.FriendButton
							for j = 1, currentSize do
								button[j].FlagTexture:SetAlpha(0)
								button[j].FlagDebuff:SetText("")
							end
							local name = GetUnitFullName(unitID)
							local button = GVAR.FriendButton[ DATA.Friend.Name2Button[name] ]
							if button then
								DATA.Friend.hasFlag = name
								button.FlagTexture:SetAlpha(1)
								BattlegroundTargets:SetFlagDebuff(button, flagDebuff)
							end
						end
						-- ----------

						return
					end
				end
			end
		end
		chk()

	elseif isFlagBG == 5 then

		-- friend debuff check
		for num = 1, GetNumGroupMembers() do
			for i = 1, 40 do
				local _, _, _, _, _, _, _, _, _, spellId, _, _, _, _, val2 = UnitDebuff("raid"..num, i) --aby8
				if not spellId then break end
				if orbIDs[spellId] then
					flags = flags + 1 -- FLAG_TOK_CHK

					-- ----------
					if BattlegroundTargets_Options.Friend.ButtonFlagToggle[currentSize] then
						local name = GetUnitFullName("raid"..num)
						local button = GVAR.FriendButton[ DATA.Friend.Name2Button[name] ]
						if button then
							local oID = orbIDs[spellId]
							hasOrb[ oID.color ].name = name
							hasOrb[ oID.color ].orbval = val2
							button.orbColor = oID.color
							button.FlagTexture:SetAlpha(1)
							button.FlagTexture:SetTexture(oID.texture)
							BattlegroundTargets:SetFlagDebuff(button, val2)
							BattlegroundTargets:SetOrbCorner(button, oID.color)
						end

						if flags >= totalFlags[isFlagBG] then
							BattlegroundTargets:CheckFlagCarrierEND()
							return
						end
					end
					-- ----------

					break
				end
			end
		end

	end

	if flags >= totalFlags[isFlagBG] then
		BattlegroundTargets:CheckFlagCarrierEND()
	else
		wipe(DATA.FirstFlagCheck)
		for i = 1, #DATA.Enemy.MainData do
			DATA.FirstFlagCheck[ DATA.Enemy.MainData[i].name ] = 1
		end
		BattlegroundTargets:RegisterEvent("UNIT_TARGET")
		BattlegroundTargets:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
		BattlegroundTargets:RegisterEvent("PLAYER_TARGET_CHANGED")
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CheckFlagCarrierEND() -- FLAGSPY
	local BattlegroundTargets_Options = BattlegroundTargets_Options

	flagCHK = nil

	wipe(DATA.FirstFlagCheck)

	BattlegroundTargets:EventUnregister()
	BattlegroundTargets:EventRegister()
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:SetFlagDebuff(button, value)
	if value and value > 0 then
		button.FlagDebuff:SetText(value)
	else
		button.FlagDebuff:SetText("")
	end
end

function BattlegroundTargets:SetOrbCorner(button, color)
	if color == "Blue" then
		button.OrbCornerTL:SetAlpha(0.15)
		button.OrbCornerTR:SetAlpha(0.15)
		button.OrbCornerBL:SetAlpha(0.15)
		button.OrbCornerBR:SetAlpha(1)
	elseif color == "Purple" then
		button.OrbCornerTL:SetAlpha(1)
		button.OrbCornerTR:SetAlpha(0.15)
		button.OrbCornerBL:SetAlpha(0.15)
		button.OrbCornerBR:SetAlpha(0.15)
	elseif color == "Green" then
		button.OrbCornerTL:SetAlpha(0.15)
		button.OrbCornerTR:SetAlpha(0.15)
		button.OrbCornerBL:SetAlpha(1)
		button.OrbCornerBR:SetAlpha(0.15)
	elseif color == "Orange" then
		button.OrbCornerTL:SetAlpha(0.15)
		button.OrbCornerTR:SetAlpha(1)
		button.OrbCornerBL:SetAlpha(0.15)
		button.OrbCornerBR:SetAlpha(0.15)
	end
end

function BattlegroundTargets:OrbReturnCheck(message)
	--print("orbreturncheck", message)
	local orbColor = strmatch(message, FLG["TOK_PATTERN_RETURNED"]) -- Temple of Kotmogu: orb was returned
	if orbColor then
		local color = orbData(orbColor)
		wipe(hasOrb[color])
		flags = flags - 1 -- FLAG_TOK_CHK
		if flags < 0 then
			flags = 0
		end

		local BattlegroundTargets_Options = BattlegroundTargets_Options
		for frc = 1, #FRAMES do
			local side = FRAMES[frc]
			if BattlegroundTargets_Options[side].EnableBracket[currentSize] then
				local button = GVAR[side.."Button"]
				for i = 1, currentSize do
					if button[i].orbColor == color then
						button[i].orbColor = nil
						button[i].FlagTexture:SetAlpha(0)
						button[i].FlagDebuff:SetText("")
						button[i].OrbCornerTL:SetAlpha(0)
						button[i].OrbCornerTR:SetAlpha(0)
						button[i].OrbCornerBL:SetAlpha(0)
						button[i].OrbCornerBR:SetAlpha(0)
						return
					end
				end
			end
		end

	end
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CheckCarrierDebuff(side, button, uID, uName, caller) -- FLAGSPY -- carrier_debuff_
	if isFlagBG == 0 then return end

	local BattlegroundTargets_Options = BattlegroundTargets_Options
	if not BattlegroundTargets_Options[side].ButtonFlagToggle[currentSize] then return end

	local curTime = GetTime()
	if curTime < button.carrierDebuffTimer + carrierDebuffFrequency then
		return
	end
	button.carrierDebuffTimer = curTime

	if flagCHK then
		BattlegroundTargets:CheckFlagCarrierCHECK(uID, uName)
	end
	if DATA[side].hasFlag == uName or button.orbColor then
		BattlegroundTargets:CarrierDebuffCheck(side, button, uID, uName)
	end
end

function BattlegroundTargets:CarrierDebuffCheck(side, button, uID, uName) -- carrier_debuff_
	if isFlagBG > 0 and isFlagBG < 5 then
		-- flag
		for i = 1, 40 do
			local _, _, count, _, _, _, _, _, _, spellId = UnitDebuff(uID, i) --aby8
			--print(uID, uName, i, "#", spellId, count, "#", UnitDebuff(uID, i))
			if debuffIDs[spellId] then
				flagDebuff = count
				BattlegroundTargets:SetFlagDebuff(button, flagDebuff)
				return
			end
			if not spellId then return end
		end
	elseif isFlagBG == 5 then
		-- orb
		for i = 1, 40 do
			local _, _, _, _, _, _, _, _, _, spellId, _, _, _, _, val2 = UnitDebuff(uID, i) --aby8
			--print(uID, uName, i, "#", spellId, val2, "#", UnitDebuff(uID, i))
			if orbIDs[spellId] then
				local hasflg
				for k, v in pairs(hasOrb) do
					if v.name == uName then
						hasflg = true
						break
					end
				end
				if not hasflg then
					flags = flags + 1 -- FLAG_TOK_CHK
				end

				local oID = orbIDs[spellId]
				hasOrb[ oID.color ].name = uName
				hasOrb[ oID.color ].orbval = val2
				button.orbColor = oID.color
				button.FlagTexture:SetAlpha(1)
				button.FlagTexture:SetTexture(oID.texture)
				BattlegroundTargets:SetFlagDebuff(button, val2)
				BattlegroundTargets:SetOrbCorner(button, oID.color)

				if flagCHK and flags >= totalFlags[isFlagBG] then
					BattlegroundTargets:CheckFlagCarrierEND()
				end
				return
			end
			if not spellId then return end
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CarrierCheck(message, messageFaction)
	--print("carriercheck", isFlagBG, "#", message, "#", messageFaction)
	if isFlagBG == 1 or isFlagBG == 3 then
		BattlegroundTargets:Carrier_WG_TP(message, messageFaction)
	elseif isFlagBG == 2 then
		BattlegroundTargets:Carrier_EOTS(message, messageFaction)
	elseif isFlagBG == 4 then
		BattlegroundTargets:Carrier_DG(message, messageFaction)
	elseif isFlagBG == 5 then
		BattlegroundTargets:Carrier_TOK(message, messageFaction)
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- Warsong Gulch & Twin Peaks ------------------------------------------------------------------------------------------
function BattlegroundTargets:Carrier_WG_TP(message, messageFaction)
	if messageFaction ~= playerFactionBG then
		-- -------------------------------------------------------------------------
		local fc = strmatch(message, FLG["WG_TP_DG_PATTERN_PICKED1"]) or -- Warsong Gulch & Twin Peaks: flag was picked
		           strmatch(message, FLG["WG_TP_DG_PATTERN_PICKED2"])    -- Warsong Gulch & Twin Peaks: flag was picked
		if fc then
			flags = flags + 1
			for i = 1, currentSize do
				GVAR.FriendButton[i].FlagTexture:SetAlpha(0)
				GVAR.FriendButton[i].FlagDebuff:SetText("")
			end
			if flagCHK then
				BattlegroundTargets:CheckFlagCarrierEND()
			end
			-- 1.) check for name-server
			for fullname, fullnameButtonNum in pairs(DATA.Friend.Name2Button) do -- DATA.Friend.Name2Button and DATA.Friend.Name4Flag have same buttonNum
				if fullname == fc then
					local button = GVAR.FriendButton[fullnameButtonNum]
					if button then
						button.FlagTexture:SetAlpha(1)
						BattlegroundTargets:SetFlagDebuff(button, flagDebuff)
						DATA.Friend.hasFlag = fullname
						return
					end
					return
				end
			end
			-- 2.) check for name only
			for name, buttonNum in pairs(DATA.Friend.Name4Flag) do
				if name == fc then
					local button = GVAR.FriendButton[buttonNum]
					if button then
						button.FlagTexture:SetAlpha(1)
						BattlegroundTargets:SetFlagDebuff(button, flagDebuff)
						for fullname, fullnameButtonNum in pairs(DATA.Friend.Name2Button) do -- DATA.Friend.Name2Button and DATA.Friend.Name4Flag have same buttonNum
							if buttonNum == fullnameButtonNum then
								DATA.Friend.hasFlag = fullname
								return
							end
						end
					end
					return
				end
			end
			-- ---
		-- -------------------------------------------------------------------------
		elseif strmatch(message, FLG["WG_TP_DG_MATCH_CAPTURED"]) then -- Warsong Gulch & Twin Peaks: flag was captured
			for i = 1, currentSize do
				GVAR.FriendButton[i].FlagTexture:SetAlpha(0)
				GVAR.FriendButton[i].FlagDebuff:SetText("")
				GVAR.EnemyButton[i].FlagTexture:SetAlpha(0)
				GVAR.EnemyButton[i].FlagDebuff:SetText("")
			end
			DATA.Friend.hasFlag = nil
			DATA.Enemy.hasFlag = nil
			flagDebuff = 0
			flags = 0
			if flagCHK then
				BattlegroundTargets:CheckFlagCarrierEND()
			end
		-- -------------------------------------------------------------------------
		elseif strmatch(message, FLG["WG_TP_DG_MATCH_DROPPED"]) then -- Warsong Gulch & Twin Peaks: flag was dropped
			for i = 1, currentSize do
				GVAR.FriendButton[i].FlagTexture:SetAlpha(0)
				GVAR.FriendButton[i].FlagDebuff:SetText("")
			end
			DATA.Friend.hasFlag = nil
			flags = flags - 1
			if flags <= 0 then
				flagDebuff = 0
				flags = 0
			end
		end
		-- -------------------------------------------------------------------------
	else
		-- -------------------------------------------------------------------------
		local efc = strmatch(message, FLG["WG_TP_DG_PATTERN_PICKED1"]) or -- Warsong Gulch & Twin Peaks: flag was picked
		            strmatch(message, FLG["WG_TP_DG_PATTERN_PICKED2"])    -- Warsong Gulch & Twin Peaks: flag was picked
		if efc then
			flags = flags + 1
			for i = 1, currentSize do
				GVAR.EnemyButton[i].FlagTexture:SetAlpha(0)
				GVAR.EnemyButton[i].FlagDebuff:SetText("")
			end
			if flagCHK then
				BattlegroundTargets:CheckFlagCarrierEND()
			end
			-- 1.) check for name-server
			for fullname, fullnameButtonNum in pairs(DATA.Enemy.Name2Button) do -- DATA.Enemy.Name2Button and DATA.Enemy.Name4Flag have same buttonNum
				if fullname == efc then
					local button = GVAR.EnemyButton[fullnameButtonNum]
					if button then
						button.FlagTexture:SetAlpha(1)
						BattlegroundTargets:SetFlagDebuff(button, flagDebuff)
						DATA.Enemy.hasFlag = fullname
						return
					end
					return
				end
			end
			-- 2.) check for name only
			for name, buttonNum in pairs(DATA.Enemy.Name4Flag) do
				if name == efc then
					local button = GVAR.EnemyButton[buttonNum]
					if button then
						button.FlagTexture:SetAlpha(1)
						BattlegroundTargets:SetFlagDebuff(button, flagDebuff)
						for fullname, fullnameButtonNum in pairs(DATA.Enemy.Name2Button) do -- DATA.Enemy.Name2Button and DATA.Enemy.Name4Flag have same buttonNum
							if buttonNum == fullnameButtonNum then
								DATA.Enemy.hasFlag = fullname
								return
							end
						end
					end
					return
				end
			end
			-- ---
		-- -------------------------------------------------------------------------
		elseif strmatch(message, FLG["WG_TP_DG_MATCH_CAPTURED"]) then -- Warsong Gulch & Twin Peaks: flag was captured
			for i = 1, currentSize do
				GVAR.FriendButton[i].FlagTexture:SetAlpha(0)
				GVAR.FriendButton[i].FlagDebuff:SetText("")
				GVAR.EnemyButton[i].FlagTexture:SetAlpha(0)
				GVAR.EnemyButton[i].FlagDebuff:SetText("")
			end
			DATA.Friend.hasFlag = nil
			DATA.Enemy.hasFlag = nil
			flagDebuff = 0
			flags = 0
			if flagCHK then
				BattlegroundTargets:CheckFlagCarrierEND()
			end
		-- -------------------------------------------------------------------------
		elseif strmatch(message, FLG["WG_TP_DG_MATCH_DROPPED"]) then -- Warsong Gulch & Twin Peaks: flag was dropped
			for i = 1, currentSize do
				GVAR.EnemyButton[i].FlagTexture:SetAlpha(0)
				GVAR.EnemyButton[i].FlagDebuff:SetText("")
			end
			DATA.Enemy.hasFlag = nil
			flags = flags - 1
			if flags <= 0 then
				flagDebuff = 0
				flags = 0
			end
		end
		-- -----------------------------------------------------------------------------------------------------------------
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- Eye of the Storm ----------------------------------------------------------------------------------------------------
function BattlegroundTargets:Carrier_EOTS(message, messageFaction)
	local BattlegroundTargets_Options = BattlegroundTargets_Options

	-- ---------------------------------------------------------------------------
	if message == FLG["EOTS_STRING_DROPPED"] or        -- Eye of the Storm: flag was dropped
	   strmatch(message, FLG["EOTS_PATTERN_CAPTURED"]) -- Eye of the Storm: flag was captured
	then
		if BattlegroundTargets_Options.Friend.EnableBracket[currentSize] then
			for i = 1, currentSize do
				GVAR.FriendButton[i].FlagTexture:SetAlpha(0)
				GVAR.FriendButton[i].FlagDebuff:SetText("")
			end
			DATA.Friend.hasFlag = nil
		end
		if BattlegroundTargets_Options.Enemy.EnableBracket[currentSize] then
			for i = 1, currentSize do
				GVAR.EnemyButton[i].FlagTexture:SetAlpha(0)
				GVAR.EnemyButton[i].FlagDebuff:SetText("")
			end
			DATA.Enemy.hasFlag = nil
		end
		flagDebuff = 0
		if flagCHK then
			BattlegroundTargets:CheckFlagCarrierEND()
		end
		return
	end

	local flagcarrier = strmatch(message, FLG["EOTS_PATTERN_PICKED"]) -- Eye of the Storm: flag was picked
	if flagcarrier then

		if flagCHK then
			BattlegroundTargets:CheckFlagCarrierEND()
		end

		for frc = 1, #FRAMES do
			local side = FRAMES[frc]
			-- -----
			if BattlegroundTargets_Options[side].EnableBracket[currentSize] then
				local button = GVAR[side.."Button"]
				for i = 1, currentSize do
					button[i].FlagTexture:SetAlpha(0)
					button[i].FlagDebuff:SetText("")
				end

				-- 1.) check for name-server
				for fullname, fullnameButtonNum in pairs(DATA[side].Name2Button) do -- DATA[side].Name2Button and DATA[side].Name4Flag have same buttonNum
					if fullname == flagcarrier then
						local button = GVAR[side.."Button"][fullnameButtonNum]
						if button then
							button.FlagTexture:SetAlpha(1)
							BattlegroundTargets:SetFlagDebuff(button, flagDebuff)
							DATA[side].hasFlag = fullname
							return
						end
						return
					end
				end
				-- 2.) check for name only
				for name, buttonNum in pairs(DATA[side].Name4Flag) do
					if name == flagcarrier then
						local button = GVAR[side.."Button"][buttonNum]
						if button then
							button.FlagTexture:SetAlpha(1)
							BattlegroundTargets:SetFlagDebuff(button, flagDebuff)
							for fullname, fullnameButtonNum in pairs(DATA[side].Name2Button) do -- DATA[side].Name2Button and DATA[side].Name4Flag have same buttonNum
								if buttonNum == fullnameButtonNum then
									DATA[side].hasFlag = fullname
									return
								end
							end
						end
						return
					end
				end
			end
			-- -----
		end

	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- Deepwind Gorge ------------------------------------------------------------------------------------------------------
function BattlegroundTargets:Carrier_DG(message, messageFaction)
	local side = "Enemy"
	if messageFaction == playerFactionBG then
		side = "Friend"
	end

	local BattlegroundTargets_Options = BattlegroundTargets_Options
	if not BattlegroundTargets_Options[side].EnableBracket[currentSize] then return end

	-- -------------------------------------------------------------------------
	if strmatch(message, FLG["WG_TP_DG_MATCH_DROPPED"]) or -- Deepwind Gorge: flag dropped
	   strmatch(message, FLG["WG_TP_DG_MATCH_CAPTURED"])   -- Deepwind Gorge: flag captured
	then
		local button = GVAR[side.."Button"]
		for i = 1, currentSize do
			button[i].FlagTexture:SetAlpha(0)
			button[i].FlagDebuff:SetText("")
		end
		DATA[side].hasFlag = nil
		flags = flags - 1
		if flags <= 0 then
			flagDebuff = 0
			flags = 0
		end
		if flagCHK then
			BattlegroundTargets:CheckFlagCarrierEND()
		end
	-- -------------------------------------------------------------------------
	else
	-- -------------------------------------------------------------------------
		local flagcarrier = strmatch(message, FLG["WG_TP_DG_PATTERN_PICKED1"]) or -- Deepwind Gorge: flag picked
		                    strmatch(message, FLG["WG_TP_DG_PATTERN_PICKED2"])    -- Deepwind Gorge: flag picked
		if flagcarrier then
			flags = flags + 1
			local button = GVAR[side.."Button"]
			for i = 1, currentSize do
				button[i].FlagTexture:SetAlpha(0)
				button[i].FlagDebuff:SetText("")
			end
			if flagCHK then
				BattlegroundTargets:CheckFlagCarrierEND()
			end
			-- 1.) check for name-server
			for fullname, fullnameButtonNum in pairs(DATA[side].Name2Button) do -- DATA[side].Name2Button and DATA[side].Name4Flag have same buttonNum
				if fullname == flagcarrier then
					local button = GVAR[side.."Button"][fullnameButtonNum]
					if button then
						button.FlagTexture:SetAlpha(1)
						button.FlagDebuff:SetText("")
						DATA[side].hasFlag = fullname
						return
					end
					return
				end
			end
			-- 2.) check for name only
			for name, buttonNum in pairs(DATA[side].Name4Flag) do
				if name == flagcarrier then
					local button = GVAR[side.."Button"][buttonNum]
					if button then
						button.FlagTexture:SetAlpha(1)
						button.FlagDebuff:SetText("")
						for fullname, fullnameButtonNum in pairs(DATA[side].Name2Button) do -- DATA[side].Name2Button and DATA[side].Name4Flag have same buttonNum
							if buttonNum == fullnameButtonNum then
								DATA[side].hasFlag = fullname
								return
							end
						end
					end
					return
				end
			end
			-- ---
		end
	end
	-- -------------------------------------------------------------------------
end
-- ---------------------------------------------------------------------------------------------------------------------

-- Temple of Kotmogu ---------------------------------------------------------------------------------------------------
function BattlegroundTargets:Carrier_TOK(message, messageFaction)
	local side = "Enemy"
	if messageFaction == playerFactionBG then
		side = "Friend"
	end

	local BattlegroundTargets_Options = BattlegroundTargets_Options
	if not BattlegroundTargets_Options[side].EnableBracket[currentSize] then return end

	-- -------------------------------------------------------------------------
	local orbCarrier, orbColor = strmatch(message, FLG["TOK_PATTERN_TAKEN"]) -- Temple of Kotmogu: orb was taken
	if orbCarrier and orbColor then
		local color, texture = orbData(orbColor)
		--print("orb taken", side, orbCarrier, orbColor, color)
		wipe(hasOrb[color])
		flags = flags + 1 -- FLAG_TOK_CHK
		if flagCHK and flags >= totalFlags[isFlagBG] then
			BattlegroundTargets:CheckFlagCarrierEND()
		end
		local button = GVAR[side.."Button"]
		for i = 1, currentSize do
			if button[i].orbColor == color then
				button[i].orbColor = nil
				button[i].FlagTexture:SetAlpha(0)
				button[i].FlagDebuff:SetText("")
				button[i].OrbCornerTL:SetAlpha(0)
				button[i].OrbCornerTR:SetAlpha(0)
				button[i].OrbCornerBL:SetAlpha(0)
				button[i].OrbCornerBR:SetAlpha(0)
				break
			end
		end
		-- 1.) check for name-server
		for fullname, fullnameButtonNum in pairs(DATA[side].Name2Button) do -- DATA[side].Name2Button and DATA[side].Name4Flag have same buttonNum
			if fullname == orbCarrier then
				local button = GVAR[side.."Button"][fullnameButtonNum]
				if button then

					local unitID = DATA.Friend.Name2UnitID[ fullname ]
					if unitID then
						BattlegroundTargets:CarrierDebuffCheck("Friend", button, unitID, fullname)
					else
						button.orbColor = color
						button.FlagTexture:SetAlpha(1)
						button.FlagTexture:SetTexture(texture)
						BattlegroundTargets:SetFlagDebuff(button, hasOrb[ color ].orbval)
						BattlegroundTargets:SetOrbCorner(button, color)
						hasOrb[color].name = fullname
					end
					return

				end
				return
			end
		end
		-- 2.) check for name only
		for name, buttonNum in pairs(DATA[side].Name4Flag) do
			if name == orbCarrier then
				local button = GVAR[side.."Button"][buttonNum]
				if button then

					for fullname, fullnameButtonNum in pairs(DATA[side].Name2Button) do -- DATA[side].Name2Button and DATA[side].Name4Flag have same buttonNum
						if buttonNum == fullnameButtonNum then

							local unitID = DATA.Friend.Name2UnitID[ fullname ]
							if unitID then
								BattlegroundTargets:CarrierDebuffCheck("Friend", button, unitID, fullname)
							else
								button.orbColor = color
								button.FlagTexture:SetAlpha(1)
								button.FlagTexture:SetTexture(texture)
								BattlegroundTargets:SetFlagDebuff(button, hasOrb[ color ].orbval)
								BattlegroundTargets:SetOrbCorner(button, color)
								hasOrb[color].name = fullname
							end
							return

						end
					end

				end
				return
			end
		end
		-- ---
	end
	-- -------------------------------------------------------------------------
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:UpdateAllPvPTrinkets(force) -- pvp_trinket_
	local curTime = GetTime()
	if not force and curTime < BattlegroundTargets.pvptrinketTimer + pvptrinketFrequency then
		return
	end

	--[[ _TIMER_
	local dif = curTime - BattlegroundTargets.pvptrinketTimer
	print("pVptrinket:", dif)
	--]]

	BattlegroundTargets.pvptrinketTimer = curTime

	local BattlegroundTargets_Options = BattlegroundTargets_Options
	for frc = 1, #FRAMES do
		local side = FRAMES[frc]
		if BattlegroundTargets_Options[side].EnableBracket[currentSize] and
		   BattlegroundTargets_Options[side].ButtonPvPTrinketToggle[currentSize]
		then
			local button = GVAR[side.."Button"]
			for i = 1, currentSize do
				if DATA[side].MainData[i] then
					BattlegroundTargets:UpdatePvPTrinket(button[i], DATA[side].MainData[i].name, curTime)
				end
			end
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:UpdatePvPTrinket(button, unitName, curTime) -- pvp_trinket_
	if DATA.PvPTrinketEndTime[unitName] then
		local trinketTime = floor(DATA.PvPTrinketEndTime[unitName] - curTime)
		if trinketTime > 0 then

		--icon change
				--print (button, unitName, curTime ,DATA.PvPTrinketId[unitName] )
			local id = DATA.PvPTrinketId[unitName]
			if not isLowLevel then
				if id == 195710 or				--lowlevel
				   id == 208683 then        	--pvptrinkettalent
				   button.PVPTrinketTexture:SetTexture( GetSpellTexture(id) )
				end
			end
			
			
			button.PVPTrinketTexture:SetAlpha(1)
			button.PVPTrinketTxt:SetText(trinketTime)
		else
			DATA.PvPTrinketEndTime[unitName] = nil
			if DATA.PvPTrinketId[unitName] == 214027 then 
				button.PVPTrinketTexture:SetAlpha(0.3)
			else
			button.PVPTrinketTexture:SetAlpha(0)
			end
			button.PVPTrinketTxt:SetText("")
		end
	else
		if DATA.PvPTrinketId[unitName] == 214027 then 
			button.PVPTrinketTexture:SetAlpha(0.3)
		else
		button.PVPTrinketTexture:SetAlpha(0)
		end
		button.PVPTrinketTxt:SetText("")
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
local function CombatLogPVPTrinketCheck(clEvent, spellId, sourceName) -- pvp_trinket_
	if pvptrinketIDs[spellId] and clEvent == "SPELL_CAST_SUCCESS" then
		--print("cl trinket:", clEvent, spellId, sourceName)
		-- --------------------
		local enemyButton = GVAR.EnemyButton[ DATA.Enemy.Name2Button[sourceName] ]
		if enemyButton then
			local BattlegroundTargets_Options = BattlegroundTargets_Options
			if BattlegroundTargets_Options.Enemy.EnableBracket[currentSize] and
			   BattlegroundTargets_Options.Enemy.ButtonPvPTrinketToggle[currentSize]
			then
				local curTime = GetTime()
				DATA.PvPTrinketEndTime[sourceName] = floor(curTime + pvptrinketIDs[spellId])
				DATA.PvPTrinketId[sourceName] = spellId
				BattlegroundTargets:UpdatePvPTrinket(enemyButton, sourceName, curTime)
			end
			return
		end
		-- --------------------
		local friendButton = GVAR.FriendButton[ DATA.Friend.Name2Button[sourceName] ]
		if friendButton then
			local BattlegroundTargets_Options = BattlegroundTargets_Options
			if BattlegroundTargets_Options.Friend.EnableBracket[currentSize] and
			   BattlegroundTargets_Options.Friend.ButtonPvPTrinketToggle[currentSize]
			then
				local curTime = GetTime()
				DATA.PvPTrinketEndTime[sourceName] = floor(curTime + pvptrinketIDs[spellId])
				DATA.PvPTrinketId[sourceName] = spellId
				BattlegroundTargets:UpdatePvPTrinket(friendButton, sourceName, curTime)
			end
		end
		-- --------------------
	end
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
local function range_check(side, unitID)
	if DATA[side].rangeSpellName then
		if IsSpellInRange(DATA[side].rangeSpellName, unitID) == 1 then
			return DATA[side].rangeMax
		end
	else
		if UnitInCheckedRange(unitID) then
			return 40 -- inDefaultRange
		elseif CheckInteractDistance(unitID, 3) then -- 3: Duel = 9.9 -- ?11/35? TODO_CHK
			return 10
		elseif CheckInteractDistance(unitID, 1) then -- 1: Inspect = 28 -- ?11/35? TODO_CHK
			return 28
		end
	end
	return false
end

local function clrc_idcheck(button, name) -- name is always enemy
	for tcnSourceName, tcnTargetName in pairs(DATA.TargetCountNames) do -- TC_DEFDEL_same -- search target count for source name
		if name == tcnTargetName then
			local targetID = DATA.TargetCountTargetID[tcnSourceName] -- TC_DEFDEL_same -- target id is never nil
			local isRange = range_check("Enemy", targetID)
			if isRange then
				DATA.Enemy.Name2Range[name] = isRange
				BattlegroundTargets:Range_Display(true, button, isRange)
				return true
			else
				DATA.Enemy.Name2Range[name] = nil
				BattlegroundTargets:Range_Display(false, button, nil, BattlegroundTargets_Options.Enemy.ButtonRangeDisplay[currentSize])
			end
			return false
		end
	end
end

local function CombatLogRangeCheck(sourceName, destName, spellId)
	if not SPELL_Range[spellId] then
		local _, _, _, _, _, maxRange = GetSpellInfo(spellId)
		if not maxRange then return end
		SPELL_Range[spellId] = maxRange
	end

	--print("INPUT_NAME_CHECK: _CL_", sourceName, destName, spellId, "range:", SPELL_Range[spellId])

	if DATA.Friend.Name2Button[ sourceName ] and DATA.Friend.Name2Button[ destName ] then return end

	local isMatch

	local sourceButton = GVAR.EnemyButton[ DATA.Enemy.Name2Button[sourceName] ]
	-- source is enemy ----------------------------------------
	if sourceButton then
		while true do
			if DATA.Enemy.Name2Percent[sourceName] == 0 then
				DATA.Enemy.Name2Range[sourceName] = nil
				BattlegroundTargets:Range_Display(false, sourceButton, nil, BattlegroundTargets_Options.Enemy.ButtonRangeDisplay[currentSize])
				break--while_break
			end

			local curTime = GetTime()
			if curTime < sourceButton.rangeTimer + rangeFrequency then
				break--while_break
			end

			--[[ _TIMER_
			local dif = curTime - sourceButton.rangeTimer
			print("rAngecheck:", "Enemy", sourceName, sourceButton.buttonNum, "#", dif, "#", SPELL_Range[spellId], "CLrange: _sourceButton_")
			--]]

			sourceButton.rangeTimer = curTime

			-- --------------------------------------------- BEGIN
			-- source: enemy | dest: playerName
			if destName == playerName then
				isMatch = true
				if SPELL_Range[spellId] <= 40 then -- inDefaultRange
					DATA.Enemy.Name2Range[sourceName] = SPELL_Range[spellId]
					BattlegroundTargets:Range_Display(true, sourceButton, DATA.Enemy.Name2Range[sourceName])
				else
					DATA.Enemy.Name2Range[sourceName] = nil
					BattlegroundTargets:Range_Display(false, sourceButton, nil, BattlegroundTargets_Options.Enemy.ButtonRangeDisplay[currentSize])
				end
			-- --------------------------------------------- END

			-- --------------------------------------------- BEGIN
			-- source: enemy | dest: friend
			elseif DATA.Friend.Name2Button[destName] then
				isMatch = true
				local is = clrc_idcheck(sourceButton, sourceName)
				if is then
					break--while_break
				end
				local friendID = DATA.Friend.Name2UnitID[destName]
				if friendID and SPELL_Range[spellId] <= 40 then -- inDefaultRange +
					local isRange = range_check("Friend", friendID)
					if isRange then
						DATA.Enemy.Name2Range[sourceName] = SPELL_Range[spellId] + isRange
						BattlegroundTargets:Range_Display(true, sourceButton, DATA.Enemy.Name2Range[sourceName])
						break--while_break
					end
				end
				DATA.Enemy.Name2Range[sourceName] = nil
				BattlegroundTargets:Range_Display(false, sourceButton, nil, BattlegroundTargets_Options.Enemy.ButtonRangeDisplay[currentSize])
			-- --------------------------------------------- END

			-- --------------------------------------------- BEGIN
			-- source: enemy | dest: enemy
			elseif DATA.Enemy.Name2Button[destName] then
				isMatch = true
				clrc_idcheck(sourceButton, sourceName)
				clrc_idcheck(sourceButton, destName)
			-- --------------------------------------------- END
			end
		break--while_break
		end
	end
	-- source is enemy ----------------------------------------

	if isMatch then return end

	local destButton = GVAR.EnemyButton[ DATA.Enemy.Name2Button[destName] ]
	-- dest is enemy ----------------------------------------
	if destButton then

		if DATA.Enemy.Name2Percent[destName] == 0 then
			DATA.Enemy.Name2Range[destName] = nil
			BattlegroundTargets:Range_Display(false, destButton, nil, BattlegroundTargets_Options.Enemy.ButtonRangeDisplay[currentSize])
			return
		end

		local curTime = GetTime()
		if curTime < destButton.rangeTimer + rangeFrequency then
			return
		end

		--[[ _TIMER_
		local dif = curTime - destButton.rangeTimer
		print("rAngecheck:", "Enemy", destName, destButton.buttonNum, "#", dif, "#", SPELL_Range[spellId], "CLrange: _destButton_")
		--]]

		destButton.rangeTimer = curTime

		-- --------------------------------------------- BEGIN
		-- dest: enemy | source: playerName
		if sourceName == playerName then
			if SPELL_Range[spellId] <= 40 then -- inDefaultRange
				DATA.Enemy.Name2Range[destName] = SPELL_Range[spellId]
				BattlegroundTargets:Range_Display(true, destButton, DATA.Enemy.Name2Range[destName])
			else
				DATA.Enemy.Name2Range[destName] = nil
				BattlegroundTargets:Range_Display(false, destButton, nil, BattlegroundTargets_Options.Enemy.ButtonRangeDisplay[currentSize])
			end
		-- --------------------------------------------- END

		-- --------------------------------------------- BEGIN
		-- dest: enemy | source: friend
		elseif DATA.Friend.Name2Button[sourceName] then
			clrc_idcheck(destButton, destName)
		-- --------------------------------------------- END
		end

	end
	-- dest is enemy ----------------------------------------
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CheckClassRange(side, button, unitID, unitName, caller) -- class_range_
	local curTime = GetTime()
	if curTime < button.rangeTimer + rangeFrequency then
		return
	end

	if unitName == playerName then return end

	local BattlegroundTargets_Options = BattlegroundTargets_Options
	if not BattlegroundTargets_Options[side].ButtonRangeToggle[currentSize] then return end

	--[[ _TIMER_
	local dif = curTime - button.rangeTimer
	print("rAngecheck:", side, unitName, button.buttonNum, "#", dif, "#", unitID, IsSpellInRange(DATA[side].rangeSpellName, unitID), "classrange", caller)
	--]]

	button.rangeTimer = curTime

	local isRange = range_check(side, unitID)
	if isRange then
		DATA[side].Name2Range[unitName] = isRange
		BattlegroundTargets:Range_Display(true, button, isRange)
	else
		DATA[side].Name2Range[unitName] = nil
		BattlegroundTargets:Range_Display(false, button, nil, BattlegroundTargets_Options[side].ButtonRangeDisplay[currentSize])
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:UpdateRange(side, curTime)
	local BattlegroundTargets_Options = BattlegroundTargets_Options
	local ButtonRangeDisplay = BattlegroundTargets_Options[side].ButtonRangeDisplay[currentSize]
	local button = GVAR[side.."Button"]
	for i = 1, currentSize do
		if DATA[side].MainData[i] then
			local name = DATA[side].MainData[i].name
			if name == playerName then
				BattlegroundTargets:Range_Display(true, button[i], nil)
			elseif DATA[side].Name2Range[name] then
				BattlegroundTargets:Range_Display(true, button[i], DATA[side].Name2Range[name])
			else
				DATA[side].Name2Range[name] = nil
				BattlegroundTargets:Range_Display(false, button[i], nil, ButtonRangeDisplay)
			end
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:ClearRangeData(side)
	local BattlegroundTargets_Options = BattlegroundTargets_Options
	if not BattlegroundTargets_Options[side].ButtonRangeToggle[currentSize] then return end
	wipe(DATA[side].Name2Range)
	local ButtonRangeDisplay = BattlegroundTargets_Options[side].ButtonRangeDisplay[currentSize]
	local button = GVAR[side.."Button"]
	for i = 1, currentSize do
		if DATA[side].MainData[i] then
			if DATA[side].MainData[i].name == playerName then
				BattlegroundTargets:Range_Display(true, button[i], nil)
			else
				BattlegroundTargets:Range_Display(false, button[i], nil, ButtonRangeDisplay)
			end
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:Range_Display(state, button, distance, display) -- RANGE_DISP_LAY
	if state then
		if distance and distance > 0 and distance ~= 40 then -- inDefaultRange
			--print("range_display:", distance)
			button.RangeTxt:SetText(distance)
		else
			button.RangeTxt:SetText("")
		end
		button.BackgroundX:SetAlpha(1)
		button.TargetCountBackground:SetAlpha(1)
		button.ClassColorBackground:SetAlpha(1)
		button.RangeTexture:SetAlpha(1)
		button.HealthBar:SetAlpha(1)
		button.RoleTexture:SetAlpha(1)
		button.SpecTexture:SetAlpha(1)
		button.ClassTexture:SetAlpha(1)
		button.ClassColorBackground:SetColorTexture(button.colR5, button.colG5, button.colB5, 1)
		button.HealthBar:SetColorTexture(button.colR, button.colG, button.colB, 1)
	elseif display == 1 then -- STD 100
		button.RangeTxt:SetText("")
		button.BackgroundX:SetAlpha(1)
		button.TargetCountBackground:SetAlpha(1)
		button.ClassColorBackground:SetAlpha(1)
		button.RangeTexture:SetAlpha(0)
		button.HealthBar:SetAlpha(1)
		button.RoleTexture:SetAlpha(1)
		button.SpecTexture:SetAlpha(1)
		button.ClassTexture:SetAlpha(1)
	elseif display == 2 then -- STD 50
		button.RangeTxt:SetText("")
		button.BackgroundX:SetAlpha(0.5)
		button.TargetCountBackground:SetAlpha(0.1)
		button.ClassColorBackground:SetAlpha(0.5)
		button.RangeTexture:SetAlpha(0)
		button.HealthBar:SetAlpha(0.5)
		button.RoleTexture:SetAlpha(0.5)
		button.SpecTexture:SetAlpha(0.5)
		button.ClassTexture:SetAlpha(0.5)
	elseif display == 3 then -- STD 10
		button.RangeTxt:SetText("")
		button.BackgroundX:SetAlpha(0.3)
		button.TargetCountBackground:SetAlpha(0.1)
		button.ClassColorBackground:SetAlpha(0.25)
		button.RangeTexture:SetAlpha(0)
		button.HealthBar:SetAlpha(0.1)
		button.RoleTexture:SetAlpha(0.25)
		button.SpecTexture:SetAlpha(0.25)
		button.ClassTexture:SetAlpha(0.25)
	elseif display == 4 then -- STD 100 mono
		button.RangeTxt:SetText("")
		button.BackgroundX:SetAlpha(1)
		button.TargetCountBackground:SetAlpha(1)
		button.ClassColorBackground:SetAlpha(1)
		button.RangeTexture:SetAlpha(0)
		button.HealthBar:SetAlpha(1)
		button.RoleTexture:SetAlpha(1)
		button.SpecTexture:SetAlpha(1)
		button.ClassTexture:SetAlpha(1)
		button.ClassColorBackground:SetColorTexture(0.2, 0.2, 0.2, 1)
		button.HealthBar:SetColorTexture(0.4, 0.4, 0.4, 1)
	elseif display == 5 then -- STD 50 mono
		button.RangeTxt:SetText("")
		button.BackgroundX:SetAlpha(0.5)
		button.TargetCountBackground:SetAlpha(0.1)
		button.ClassColorBackground:SetAlpha(0.5)
		button.RangeTexture:SetAlpha(0)
		button.HealthBar:SetAlpha(0.5)
		button.RoleTexture:SetAlpha(0.5)
		button.SpecTexture:SetAlpha(0.5)
		button.ClassTexture:SetAlpha(0.5)
		button.ClassColorBackground:SetColorTexture(0.2, 0.2, 0.2, 1)
		button.HealthBar:SetColorTexture(0.4, 0.4, 0.4, 1)
	elseif display == 6 then -- STD 10 mono
		button.RangeTxt:SetText("")
		button.BackgroundX:SetAlpha(0.3)
		button.TargetCountBackground:SetAlpha(0.1)
		button.ClassColorBackground:SetAlpha(0.25)
		button.RangeTexture:SetAlpha(0)
		button.HealthBar:SetAlpha(0.1)
		button.RoleTexture:SetAlpha(0.25)
		button.SpecTexture:SetAlpha(0.25)
		button.ClassTexture:SetAlpha(0.25)
		button.ClassColorBackground:SetColorTexture(0.2, 0.2, 0.2, 1)
		button.HealthBar:SetColorTexture(0.4, 0.4, 0.4, 1)
	elseif display == 7 then -- X 10
		button.RangeTxt:SetText("")
		button.BackgroundX:SetAlpha(0.3)
		button.TargetCountBackground:SetAlpha(0.1)
		button.ClassColorBackground:SetAlpha(0.25)
		button.RangeTexture:SetAlpha(0)
		button.HealthBar:SetAlpha(0.1)
		button.RoleTexture:SetAlpha(0.25)
		button.SpecTexture:SetAlpha(0.25)
		button.ClassTexture:SetAlpha(0.25)
	elseif display == 8 then -- X 100 mono
		button.RangeTxt:SetText("")
		button.BackgroundX:SetAlpha(1)
		button.TargetCountBackground:SetAlpha(1)
		button.ClassColorBackground:SetAlpha(1)
		button.RangeTexture:SetAlpha(0)
		button.HealthBar:SetAlpha(1)
		button.RoleTexture:SetAlpha(1)
		button.SpecTexture:SetAlpha(1)
		button.ClassTexture:SetAlpha(1)
		button.ClassColorBackground:SetColorTexture(0.2, 0.2, 0.2, 1)
		button.HealthBar:SetColorTexture(0.4, 0.4, 0.4, 1)
	elseif display == 9 then -- X 50 mono
		button.RangeTxt:SetText("")
		button.BackgroundX:SetAlpha(0.5)
		button.TargetCountBackground:SetAlpha(0.1)
		button.ClassColorBackground:SetAlpha(0.5)
		button.RangeTexture:SetAlpha(0)
		button.HealthBar:SetAlpha(0.5)
		button.RoleTexture:SetAlpha(0.5)
		button.SpecTexture:SetAlpha(0.5)
		button.ClassTexture:SetAlpha(0.5)
		button.ClassColorBackground:SetColorTexture(0.2, 0.2, 0.2, 1)
		button.HealthBar:SetColorTexture(0.4, 0.4, 0.4, 1)
	else--if display == 10 then -- X 10 mono
		button.RangeTxt:SetText("")
		button.BackgroundX:SetAlpha(0.3)
		button.TargetCountBackground:SetAlpha(0.1)
		button.ClassColorBackground:SetAlpha(0.25)
		button.RangeTexture:SetAlpha(0)
		button.HealthBar:SetAlpha(0.1)
		button.RoleTexture:SetAlpha(0.25)
		button.SpecTexture:SetAlpha(0.25)
		button.ClassTexture:SetAlpha(0.25)
		button.ClassColorBackground:SetColorTexture(0.2, 0.2, 0.2, 1)
		button.HealthBar:SetColorTexture(0.4, 0.4, 0.4, 1)
	end
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CheckPlayerLevel() -- LVLCHK
	if playerLevel == maxLevel then
		isLowLevel = nil
		BattlegroundTargets:UnregisterEvent("PLAYER_LEVEL_UP")
	elseif playerLevel < maxLevel then
		isLowLevel = true
		BattlegroundTargets:RegisterEvent("PLAYER_LEVEL_UP")
	else--if playerLevel > maxLevel then
		isLowLevel = nil
		BattlegroundTargets:UnregisterEvent("PLAYER_LEVEL_UP")
		Print("ERROR", "wrong level", locale, playerLevel, maxLevel)
	end
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CheckFaction()
	local faction = UnitFactionGroup("player")
	if faction == "Horde" then
		playerFactionDEF   = 0 -- Horde
		oppositeFactionDEF = 1 -- Alliance
		BattlegroundTargets:UnregisterEvent("NEUTRAL_FACTION_SELECT_RESULT")
	elseif faction == "Alliance" then
		playerFactionDEF   = 1 -- Alliance
		oppositeFactionDEF = 0 -- Horde
		BattlegroundTargets:UnregisterEvent("NEUTRAL_FACTION_SELECT_RESULT")
	elseif faction == "Neutral" then
		playerFactionDEF   = 2 -- Neutral (eg.: Pandaren)
		oppositeFactionDEF = 2 -- Neutral (eg.: Pandaren)
		BattlegroundTargets:RegisterEvent("NEUTRAL_FACTION_SELECT_RESULT")
	else
		Print("ERROR", "unknown faction", locale, faction)
		playerFactionDEF   = 1 -- Dummy
		oppositeFactionDEF = 0 -- Dummy
	end
	playerFactionBG   = playerFactionDEF
	oppositeFactionBG = oppositeFactionDEF

	if playerFactionDEF == 0 then -- setup_flag_texture
		Textures.flagTexture = "Interface\\WorldStateFrame\\HordeFlag"
		Textures.cartTexture = "Interface\\Minimap\\Vehicle-SilvershardMines-MineCartRed"
		if GVAR.FriendSummary and GVAR.FriendSummary.Logo1 then -- summary_flag_texture - 12 - initial reset
			GVAR.FriendSummary.Logo1:SetTexture("Interface\\FriendsFrame\\PlusManz-Horde")
			GVAR.EnemySummary.Logo1:SetTexture("Interface\\FriendsFrame\\PlusManz-Horde")
			GVAR.FriendSummary.Logo2:SetTexture("Interface\\FriendsFrame\\PlusManz-Alliance")
			GVAR.EnemySummary.Logo2:SetTexture("Interface\\FriendsFrame\\PlusManz-Alliance")
		end
	elseif playerFactionDEF == 1 then
		Textures.flagTexture = "Interface\\WorldStateFrame\\AllianceFlag"
		Textures.cartTexture = "Interface\\Minimap\\Vehicle-SilvershardMines-MineCartBlue"
		if GVAR.FriendSummary and GVAR.FriendSummary.Logo1 then -- summary_flag_texture - 12 - initial reset
			GVAR.FriendSummary.Logo1:SetTexture("Interface\\FriendsFrame\\PlusManz-Alliance")
			GVAR.EnemySummary.Logo1:SetTexture("Interface\\FriendsFrame\\PlusManz-Alliance")
			GVAR.FriendSummary.Logo2:SetTexture("Interface\\FriendsFrame\\PlusManz-Horde")
			GVAR.EnemySummary.Logo2:SetTexture("Interface\\FriendsFrame\\PlusManz-Horde")
		end
	else
		Textures.flagTexture = "Interface\\WorldStateFrame\\ColumnIcon-FlagCapture2" -- neutral_flag
		Textures.cartTexture = "Interface\\Minimap\\Vehicle-SilvershardMines-MineCart" -- neutral_flag
	end
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:ClearToTButtonByName(unitName)
	local BattlegroundTargets_Options = BattlegroundTargets_Options
	--TODO use DATA.TargetCountNames
	for frc = 1, #FRAMES do
		local side = FRAMES[frc]
		if BattlegroundTargets_Options[side].EnableBracket[currentSize] and
		   BattlegroundTargets_Options[side].ButtonToTToggle[currentSize]
		then
			local button = GVAR[side.."Button"]
			for i = 1, currentSize do
				local totdata = button[i].ToTButton.totData
				if totdata and totdata.totFullName == unitName then
					button[i].ToTButton.totData = nil
					button[i].ToTButton:SetAlpha(0)
				end
			end
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:CheckIfPlayerIsGhost(state)
	if not inBattleground then return end
	if not state and UnitIsGhost("player") then
		isDeadUpdateStop = true

		GVAR.FriendIsGhostTexture:Show()
		GVAR.EnemyIsGhostTexture:Show()

		BattlegroundTargets:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
		BattlegroundTargets:UnregisterEvent("UNIT_TARGET")
		BattlegroundTargets:UnregisterEvent("PLAYER_TARGET_CHANGED")
		BattlegroundTargets:UnregisterEvent("PLAYER_FOCUS_CHANGED")

		BattlegroundTargets:ClearRangeData("Friend")
		BattlegroundTargets:ClearRangeData("Enemy")

		--[[ TEST
		Screenshot()
		--]]
	else
		isDeadUpdateStop = false
		if isConfig then return end
		GVAR.FriendIsGhostTexture:Hide()
		GVAR.EnemyIsGhostTexture:Hide()

		BattlegroundTargets.targetCountTimer = 0 -- immediate update

		BattlegroundTargets:EventRegister()
	end
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:BattlefieldScoreRequest()
	local wssf = WorldStateScoreFrame
	if wssf and wssf:IsShown() then
		return
	end
	SetBattlefieldScoreFaction()
	RequestBattlefieldScoreData()
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
function BattlegroundTargets:EventRegister(showerror)
	if not inBattleground then return end

	local BattlegroundTargets_Options = BattlegroundTargets_Options

	if not BattlegroundTargets_Options.Friend.EnableBracket[currentSize] and
	   not BattlegroundTargets_Options.Enemy.EnableBracket[currentSize]
	then
		return
	end

	if isLowLevel then -- LVLCHK
		BattlegroundTargets:RegisterEvent("UNIT_TARGET")
	end

	-- health_
	if BattlegroundTargets_Options.Friend.ButtonHealthBarToggle[currentSize] or BattlegroundTargets_Options.Friend.ButtonHealthTextToggle[currentSize] or
	   BattlegroundTargets_Options.Enemy.ButtonHealthBarToggle[currentSize] or BattlegroundTargets_Options.Enemy.ButtonHealthTextToggle[currentSize]
	then
		BattlegroundTargets:RegisterEvent("UNIT_TARGET")
		BattlegroundTargets:RegisterEvent("UNIT_HEALTH_FREQUENT")
		BattlegroundTargets:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	end

	-- targetcount_
	if BattlegroundTargets_Options.Friend.ButtonFTargetCountToggle[currentSize] or
	   BattlegroundTargets_Options.Friend.ButtonETargetCountToggle[currentSize] or
	   BattlegroundTargets_Options.Enemy.ButtonFTargetCountToggle[currentSize] or
	   BattlegroundTargets_Options.Enemy.ButtonETargetCountToggle[currentSize]
	then
		BattlegroundTargets:RegisterEvent("UNIT_TARGET")
	end

	-- targeet
	if BattlegroundTargets_Options.Friend.ButtonTargetToggle[currentSize] or
	   BattlegroundTargets_Options.Enemy.ButtonTargetToggle[currentSize]
	then
		BattlegroundTargets:RegisterEvent("PLAYER_TARGET_CHANGED")
	end

	-- target_of_target
	if BattlegroundTargets_Options.Friend.ButtonToTToggle[currentSize] or
	   BattlegroundTargets_Options.Enemy.ButtonToTToggle[currentSize]
	then
		BattlegroundTargets:RegisterEvent("PLAYER_TARGET_CHANGED")
		BattlegroundTargets:RegisterEvent("UNIT_TARGET")
	end

	-- focus_
	if BattlegroundTargets_Options.Friend.ButtonFocusToggle[currentSize] or
	   BattlegroundTargets_Options.Enemy.ButtonFocusToggle[currentSize]
	then
		BattlegroundTargets:RegisterEvent("PLAYER_FOCUS_CHANGED")
	end

	-- -----
	if BattlegroundTargets_Options.Friend.ButtonFlagToggle[currentSize] or
	   BattlegroundTargets_Options.Enemy.ButtonFlagToggle[currentSize]
	then
		if isFlagBG > 0 then
			BattlegroundTargets:RegisterEvent("UNIT_TARGET")
			BattlegroundTargets:RegisterEvent("CHAT_MSG_BG_SYSTEM_HORDE")
			BattlegroundTargets:RegisterEvent("CHAT_MSG_BG_SYSTEM_ALLIANCE")
			if isFlagBG == 5 then
				BattlegroundTargets:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
			end
		end
	end

	-- assist_
	if BattlegroundTargets_Options.Friend.ButtonAssistToggle[currentSize] or
	   BattlegroundTargets_Options.Enemy.ButtonAssistToggle[currentSize]
	then
		BattlegroundTargets:RegisterEvent("UNIT_TARGET")
	end

	-- leader_
	if BattlegroundTargets_Options.Friend.ButtonLeaderToggle[currentSize] or
	   BattlegroundTargets_Options.Enemy.ButtonLeaderToggle[currentSize]
	then
		BattlegroundTargets:RegisterEvent("UNIT_TARGET")
	end
	if BattlegroundTargets_Options.Friend.EnableBracket[currentSize] and
	   BattlegroundTargets_Options.Friend.ButtonLeaderToggle[currentSize]
	then
		BattlegroundTargets:RegisterEvent("PARTY_LEADER_CHANGED")
	end

	-- pvp_trinket_
	if BattlegroundTargets_Options.Friend.ButtonPvPTrinketToggle[currentSize] or
	   BattlegroundTargets_Options.Enemy.ButtonPvPTrinketToggle[currentSize]
	then
		BattlegroundTargets:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end

	-- class_range_
	for frc = 1, #FRAMES do
		local side = FRAMES[frc]
		DATA[side].rangeSpellName = nil
		DATA[side].rangeMin = nil
		DATA[side].rangeMax = nil
		if BattlegroundTargets_Options[side].ButtonRangeToggle[currentSize] then
			local errortxt
			local rangeSpellCLASS = ranges[side][playerClassEN]
			if rangeSpellCLASS then
				local rangeSpellID = rangeSpellCLASS.id
				local isKnown = IsSpellKnown(rangeSpellID)
				local SpellName, _, _, _, Min, Max = GetSpellInfo(rangeSpellID)
				DATA[side].rangeSpellName = SpellName
				DATA[side].rangeMin = Min
				DATA[side].rangeMax = Max
				if isKnown and SpellName and Min and Min >= 0 and Max and Max > 0 then
					BattlegroundTargets:RegisterEvent("UNIT_HEALTH_FREQUENT")
					BattlegroundTargets:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
					BattlegroundTargets:RegisterEvent("PLAYER_TARGET_CHANGED")
					BattlegroundTargets:RegisterEvent("UNIT_TARGET")
				else
					local rangeSpellLEVEL = rangeSpellCLASS.lvl -- Friend: DKN72 HUN42 MAG29 MON18 ROG78 WLK18 WRR72 | Enemy: MON14 ROG12
					if rangeSpellLEVEL > playerLevel then
						errortxt = "WARNING rangecheck LEVEL - Level: "..rangeSpellLEVEL.." > "..(playerLevel or "0").." SpellID: "..(rangeSpellID or "-")
					else
						errortxt = "WARNING rangecheck UNKNOWN - SpellID: "..(rangeSpellID or "-")
					end
				end
			else
				errortxt = "ERROR rangecheck CLASS - Class: "..(playerClassEN or "-")
			end
			if errortxt and showerror then
				Print(errortxt, locale, side, "SpellName:", DATA[side].rangeSpellName, "Min:", DATA[side].rangeMin, "Max:", DATA[side].rangeMax)
			end
		end
	end
	if BattlegroundTargets_Options.Enemy.ButtonRangeToggle[currentSize] then
		BattlegroundTargets:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end

	BattlegroundTargets:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")
	BattlegroundTargets:RegisterEvent("GROUP_ROSTER_UPDATE")
	BattlegroundTargets:RegisterEvent("PLAYER_DEAD")
	BattlegroundTargets:RegisterEvent("PLAYER_UNGHOST")
	BattlegroundTargets:RegisterEvent("PLAYER_ALIVE")
end

function BattlegroundTargets:EventUnregister()
	BattlegroundTargets:UnregisterEvent("UPDATE_BATTLEFIELD_SCORE")
	BattlegroundTargets:UnregisterEvent("GROUP_ROSTER_UPDATE")
	BattlegroundTargets:UnregisterEvent("PLAYER_DEAD")
	BattlegroundTargets:UnregisterEvent("PLAYER_UNGHOST")
	BattlegroundTargets:UnregisterEvent("PLAYER_ALIVE")
	BattlegroundTargets:UnregisterEvent("UNIT_HEALTH_FREQUENT")
	BattlegroundTargets:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
	BattlegroundTargets:UnregisterEvent("UNIT_TARGET")
	BattlegroundTargets:UnregisterEvent("PLAYER_TARGET_CHANGED")
	BattlegroundTargets:UnregisterEvent("PLAYER_FOCUS_CHANGED")
	BattlegroundTargets:UnregisterEvent("PARTY_LEADER_CHANGED")
	BattlegroundTargets:UnregisterEvent("CHAT_MSG_BG_SYSTEM_HORDE")
	BattlegroundTargets:UnregisterEvent("CHAT_MSG_BG_SYSTEM_ALLIANCE")
	BattlegroundTargets:UnregisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	BattlegroundTargets:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end
-- ---------------------------------------------------------------------------------------------------------------------



-- ---------------------------------------------------------------------------------------------------------------------
local function OnEvent(self, event, ...)
	--if not eventTest[event] then eventTest[event] = 1 else eventTest[event] = eventTest[event] + 1 end -- TEST
	--if isConfig then print("###", isConfig, event) end if not isConfig then print("***", isConfig, event) end
	if event == "PLAYER_REGEN_DISABLED" then
		inCombat = true
		if isConfig then
			if not inWorld then return end
			BattlegroundTargets:DisableInsecureConfigWidges()
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		inCombat = false
		if reCheckBG then
			if not inWorld then return end
			BattlegroundTargets:BattlefieldCheck()
		end
		if reCheckScore then
			if not inWorld then return end
			BattlegroundTargets:BattlefieldScoreRequest()
		end
		if rePosMain then
			rePosMain = nil
			if GVAR.FriendMainFrame:IsShown() then
				BattlegroundTargets:Frame_SavePosition("BattlegroundTargets_FriendMainFrame", "Friend")
			end
			if GVAR.EnemyMainFrame:IsShown() then
				BattlegroundTargets:Frame_SavePosition("BattlegroundTargets_EnemyMainFrame", "Enemy")
			end
		end
		if reSetLayout then
			if not inWorld then return end
			if BattlegroundTargets_Options.Friend.EnableBracket[currentSize] then
				BattlegroundTargets:SetupButtonLayout("Friend")
			end
			if BattlegroundTargets_Options.Enemy.EnableBracket[currentSize] then
				BattlegroundTargets:SetupButtonLayout("Enemy")
			end
		end
		if isConfig then
			if not inWorld then return end
			BattlegroundTargets:EnableInsecureConfigWidges()
			if BattlegroundTargets_Options.Friend.EnableBracket[currentSize] or BattlegroundTargets_Options.Enemy.EnableBracket[currentSize] then
				BattlegroundTargets:EnableConfigMode()
			else
				BattlegroundTargets:DisableConfigMode()
			end
		end

	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, clEvent, _, _, sourceName, sourceFlags, _, _, destName, destFlags, _, spellId = CombatLogGetCurrentEventInfo()
		if not sourceFlags or band(sourceFlags, 0x00000400) == 0 then return end
		CombatLogPVPTrinketCheck(clEvent, spellId, sourceName)
		if not destFlags or band(destFlags, 0x00000400) == 0 then return end
		if sourceName == destName then return end
		---[[ TEST
		range_CL_Throttle = range_CL_Throttle + 1
		if range_CL_Throttle > range_CL_Frequency then
			range_CL_Throttle = 0
			range_CL_Frequency = random(1,3)
			return
		end
		--]]
		CombatLogRangeCheck(sourceName, destName, spellId)

	elseif event == "UNIT_HEALTH_FREQUENT" then
		local arg1 = ...
		BattlegroundTargets:CheckUnitHealth(arg1)
	elseif event == "UNIT_TARGET" then
		local arg1 = ...
		BattlegroundTargets:CheckUnitTarget(arg1, nil, 1)
	elseif event == "UPDATE_MOUSEOVER_UNIT" then
		BattlegroundTargets:CheckUnitHealth("mouseover")
	elseif event == "PLAYER_TARGET_CHANGED" then
		BattlegroundTargets:CheckPlayerTarget()
	elseif event == "PLAYER_FOCUS_CHANGED" then
		BattlegroundTargets:CheckPlayerFocus()

	elseif event == "UPDATE_BATTLEFIELD_SCORE" then
		BattlegroundTargets:BattlefieldScoreUpdate()
	elseif event == "GROUP_ROSTER_UPDATE" then
		BattlegroundTargets:GroupRosterUpdate()
	elseif event == "PARTY_LEADER_CHANGED" then
		BattlegroundTargets:FriendLeaderUpdate()

	elseif event == "CHAT_MSG_BG_SYSTEM_HORDE" then
		local arg1 = ...
		BattlegroundTargets:CarrierCheck(arg1, 0)
	elseif event == "CHAT_MSG_BG_SYSTEM_ALLIANCE" then
		local arg1 = ...
		BattlegroundTargets:CarrierCheck(arg1, 1)
	elseif event == "CHAT_MSG_RAID_BOSS_EMOTE" then
		local arg1 = ...
		BattlegroundTargets:OrbReturnCheck(arg1)

	elseif event == "PLAYER_DEAD" then
		BattlegroundTargets:CheckIfPlayerIsGhost(true)
	elseif event == "PLAYER_UNGHOST" then
		BattlegroundTargets:CheckIfPlayerIsGhost(true)
	elseif event == "PLAYER_ALIVE" then
		BattlegroundTargets:CheckIfPlayerIsGhost()

	elseif event == "ZONE_CHANGED_NEW_AREA" then
		if isConfig then return end
		BattlegroundTargets:BattlefieldCheck()

	elseif event == "PLAYER_LEVEL_UP" then -- LVLCHK
		local arg1 = ...
		if arg1 then
			playerLevel = arg1
			BattlegroundTargets:CheckPlayerLevel()
		end

	elseif event == "NEUTRAL_FACTION_SELECT_RESULT" then
		BattlegroundTargets:CheckFaction()

	elseif event == "PLAYER_LOGIN" then
		BuildBattlegroundMapTable()
		BattlegroundTargets:CheckFaction()
		BattlegroundTargets:InitOptions()
		BattlegroundTargets:CreateInterfaceOptions()
		BattlegroundTargets:LDBcheck()
		BattlegroundTargets:CreateFrames()
		BattlegroundTargets:CreateOptionsFrame()
		tinsert(UISpecialFrames, "BattlegroundTargets_OptionsFrame")
		BattlegroundTargets:UnregisterEvent("PLAYER_LOGIN")
	elseif event == "PLAYER_ENTERING_WORLD" then
		inWorld = true
		BattlegroundTargets:CheckPlayerLevel() -- LVLCHK
		BattlegroundTargets:BattlefieldCheck()
		if BattlegroundTargets_Options.Friend.EnableBracket[currentSize] or BattlegroundTargets_Options.Enemy.EnableBracket[currentSize] then
			BattlegroundTargets:CheckIfPlayerIsGhost()
		end
		BattlegroundTargets:CreateMinimapButton()
		if not BattlegroundTargets_Options.FirstRun then
			BattlegroundTargets:Frame_Toggle(GVAR.OptionsFrame)
			BattlegroundTargets_Options.FirstRun = true
		end
		BattlegroundTargets:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end
-- ---------------------------------------------------------------------------------------------------------------------

BattlegroundTargets:RegisterEvent("PLAYER_REGEN_DISABLED")
BattlegroundTargets:RegisterEvent("PLAYER_REGEN_ENABLED")
BattlegroundTargets:RegisterEvent("ZONE_CHANGED_NEW_AREA")
BattlegroundTargets:RegisterEvent("PLAYER_LOGIN")
BattlegroundTargets:RegisterEvent("PLAYER_ENTERING_WORLD")
BattlegroundTargets:SetScript("OnEvent", OnEvent)
