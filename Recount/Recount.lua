Recount = LibStub("AceAddon-3.0"):NewAddon("Recount", "AceConsole-3.0",--[["AceEvent-3.0",]] "AceComm-3.0", "AceTimer-3.0")
local Recount = _G.Recount
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

local SM = LibStub:GetLibrary("LibSharedMedia-3.0")
local AceLocale = LibStub("AceLocale-3.0")
local L = AceLocale:GetLocale( "Recount" )

local DataVersion	= "1.3"
local FilterSize	= 20
local RampUp		= 5
local RampDown		= 10

Recount.Version = tonumber(string.sub("$Revision: 1459 $", 12, -3))


local _G = _G
local abs = abs
local assert = assert
local collectgarbage = collectgarbage
local date = date
local getmetatable = getmetatable
local ipairs = ipairs
local math_floor = math.floor
local math_fmod = math.fmod
local pairs = pairs
local setmetatable = setmetatable
local string_format = string.format
local string_lower = string.lower
local string_match = string.match
local tinsert = table.insert
local tonumber = tonumber
local tremove = table.remove
local type = type
local unpack = unpack

local GetNumGroupMembers = GetNumGroupMembers
local GetNumPartyMembers = GetNumPartyMembers or GetNumSubgroupMembers
local GetNumRaidMembers = GetNumRaidMembers or GetNumGroupMembers
local GetTime = GetTime
local IsInRaid = IsInRaid
local UnitAffectingCombat = UnitAffectingCombat
local UnitClass = UnitClass
local UnitExists = UnitExists
local UnitGUID = UnitGUID
local UnitInParty = UnitInParty
local UnitIsFriend = UnitIsFriend
local UnitIsPlayer = UnitIsPlayer
local UnitIsTrivial = UnitIsTrivial
local UnitLevel = UnitLevel
local UnitName = UnitName

local CreateFrame = CreateFrame

local InterfaceOptionsFrame = InterfaceOptionsFrame
local UIParent = UIParent

local RecountTempTooltip = RecountTempTooltip

Recount.events = CreateFrame("Frame")

Recount.events:SetScript("OnEvent", function(self, event, ...)
	if not Recount[event] then
		return
	end

	Recount[event](Recount, ...)
end)

local dbCombatants
-- Elsia: This is straight from GUIDRegistryLib-0.1 by ArrowMaster
local bit_bor	= bit.bor
local bit_band	= bit.band

local COMBATLOG_OBJECT_AFFILIATION_MINE		= COMBATLOG_OBJECT_AFFILIATION_MINE		or 0x00000001
local COMBATLOG_OBJECT_AFFILIATION_PARTY	= COMBATLOG_OBJECT_AFFILIATION_PARTY	or 0x00000002
local COMBATLOG_OBJECT_AFFILIATION_RAID		= COMBATLOG_OBJECT_AFFILIATION_RAID		or 0x00000004
local COMBATLOG_OBJECT_AFFILIATION_OUTSIDER	= COMBATLOG_OBJECT_AFFILIATION_OUTSIDER	or 0x00000008
local COMBATLOG_OBJECT_AFFILIATION_MASK		= COMBATLOG_OBJECT_AFFILIATION_MASK		or 0x0000000F
-- Reaction
local COMBATLOG_OBJECT_REACTION_FRIENDLY	= COMBATLOG_OBJECT_REACTION_FRIENDLY	or 0x00000010
local COMBATLOG_OBJECT_REACTION_NEUTRAL		= COMBATLOG_OBJECT_REACTION_NEUTRAL		or 0x00000020
local COMBATLOG_OBJECT_REACTION_HOSTILE		= COMBATLOG_OBJECT_REACTION_HOSTILE		or 0x00000040
local COMBATLOG_OBJECT_REACTION_MASK		= COMBATLOG_OBJECT_REACTION_MASK		or 0x000000F0
-- Ownership
local COMBATLOG_OBJECT_CONTROL_PLAYER		= COMBATLOG_OBJECT_CONTROL_PLAYER		or 0x00000100
local COMBATLOG_OBJECT_CONTROL_NPC			= COMBATLOG_OBJECT_CONTROL_NPC			or 0x00000200
local COMBATLOG_OBJECT_CONTROL_MASK			= COMBATLOG_OBJECT_CONTROL_MASK			or 0x00000300
-- Unit type
local COMBATLOG_OBJECT_TYPE_PLAYER			= COMBATLOG_OBJECT_TYPE_PLAYER			or 0x00000400
local COMBATLOG_OBJECT_TYPE_NPC				= COMBATLOG_OBJECT_TYPE_NPC				or 0x00000800
local COMBATLOG_OBJECT_TYPE_PET				= COMBATLOG_OBJECT_TYPE_PET				or 0x00001000
local COMBATLOG_OBJECT_TYPE_GUARDIAN		= COMBATLOG_OBJECT_TYPE_GUARDIAN		or 0x00002000
local COMBATLOG_OBJECT_TYPE_OBJECT			= COMBATLOG_OBJECT_TYPE_OBJECT			or 0x00004000
local COMBATLOG_OBJECT_TYPE_MASK			= COMBATLOG_OBJECT_TYPE_MASK			or 0x0000FC00

-- Special cases (non-exclusive)
local COMBATLOG_OBJECT_TARGET				= COMBATLOG_OBJECT_TARGET				or 0x00010000
local COMBATLOG_OBJECT_FOCUS				= COMBATLOG_OBJECT_FOCUS				or 0x00020000
local COMBATLOG_OBJECT_MAINTANK				= COMBATLOG_OBJECT_MAINTANK				or 0x00040000
local COMBATLOG_OBJECT_MAINASSIST			= COMBATLOG_OBJECT_MAINASSIST			or 0x00080000
local COMBATLOG_OBJECT_RAIDTARGET1			= COMBATLOG_OBJECT_RAIDTARGET1			or 0x00100000
local COMBATLOG_OBJECT_RAIDTARGET2			= COMBATLOG_OBJECT_RAIDTARGET2			or 0x00200000
local COMBATLOG_OBJECT_RAIDTARGET3			= COMBATLOG_OBJECT_RAIDTARGET3			or 0x00400000
local COMBATLOG_OBJECT_RAIDTARGET4			= COMBATLOG_OBJECT_RAIDTARGET4			or 0x00800000
local COMBATLOG_OBJECT_RAIDTARGET5			= COMBATLOG_OBJECT_RAIDTARGET5			or 0x01000000
local COMBATLOG_OBJECT_RAIDTARGET6			= COMBATLOG_OBJECT_RAIDTARGET6			or 0x02000000
local COMBATLOG_OBJECT_RAIDTARGET7			= COMBATLOG_OBJECT_RAIDTARGET7			or 0x04000000
local COMBATLOG_OBJECT_RAIDTARGET8			= COMBATLOG_OBJECT_RAIDTARGET8			or 0x08000000
local COMBATLOG_OBJECT_NONE					= COMBATLOG_OBJECT_NONE					or 0x80000000
local COMBATLOG_OBJECT_SPECIAL_MASK			= COMBATLOG_OBJECT_SPECIAL_MASK			or 0xFFFF0000

local LIB_FILTER_RAIDTARGET	= bit_bor(
	COMBATLOG_OBJECT_RAIDTARGET1, COMBATLOG_OBJECT_RAIDTARGET2, COMBATLOG_OBJECT_RAIDTARGET3, COMBATLOG_OBJECT_RAIDTARGET4,
	COMBATLOG_OBJECT_RAIDTARGET5, COMBATLOG_OBJECT_RAIDTARGET6, COMBATLOG_OBJECT_RAIDTARGET7, COMBATLOG_OBJECT_RAIDTARGET8
)
local LIB_FILTER_ME = bit_bor(
	COMBATLOG_OBJECT_AFFILIATION_MINE, COMBATLOG_OBJECT_REACTION_FRIENDLY, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_PLAYER
)
local LIB_FILTER_MY_PET = bit_bor(
	COMBATLOG_OBJECT_AFFILIATION_MINE,
	COMBATLOG_OBJECT_REACTION_FRIENDLY,
	COMBATLOG_OBJECT_CONTROL_PLAYER,
	COMBATLOG_OBJECT_TYPE_PET
)
local LIB_FILTER_PARTY	= bit_bor(COMBATLOG_OBJECT_TYPE_PLAYER, COMBATLOG_OBJECT_AFFILIATION_PARTY)
local LIB_FILTER_RAID	= bit_bor(COMBATLOG_OBJECT_TYPE_PLAYER, COMBATLOG_OBJECT_AFFILIATION_RAID)
local LIB_FILTER_GROUP	= bit_bor(LIB_FILTER_PARTY, LIB_FILTER_RAID)

local Default_Profile = {
	profile = {
		Colors = {
			["Window"] = {
				["Title"] = { r = 1, g = 0, b = 0, a = 1},
				["Background"]= { r = 24 / 255, g = 24 / 255, b = 24 / 255, a = 1},
				["Title Text"] = {r = 1, g = 1, b = 1, a = 1},
			},
			["Bar"] = {
				["Bar Text"] = {r = 1, g = 1, b = 1},
				["Total Bar"] = { r = 0.75, g = 0.75, b = 0.75},
			},
			["Other Windows"] = {
				["Title"] = { r = 1, g = 0, b = 0, a = 1},
				["Background"] = { r = 24 / 255, g = 24 / 255, b = 24 / 255, a = 1},
				["Title Text"] = {r = 1, g = 1, b = 1, a = 1},
			},
			["Detail Window"] = {
			},
			["Class"] = {
				["HUNTER"] = { r = 0.67, g = 0.83, b = 0.45, a = 1 },
				["WARLOCK"] = { r = 0.58, g = 0.51, b = 0.79, a = 1 },
				["PRIEST"] = { r = 1.0, g = 1.0, b = 1.0, a = 1 },
				["PALADIN"] = { r = 0.96, g = 0.55, b = 0.73, a = 1 },
				["MAGE"] = { r = 0.41, g = 0.8, b = 0.94, a = 1 },
				["ROGUE"] = { r = 1.0, g = 0.96, b = 0.41, a = 1 },
				["DRUID"] = { r = 1.0, g = 0.49, b = 0.04, a = 1 },
				["SHAMAN"] = { r = 0.14, g = 0.35, b = 1.0, a = 1 },
				["WARRIOR"] = { r = 0.78, g = 0.61, b = 0.43, a = 1 },
				["DEATHKNIGHT"] = { r = 0.77, g = 0.12, b = 0.23, a = 1 },
				["MONK"] = { r = 0, g = 1.0, b = 0.59, a = 1 },
				["DEMONHUNTER"] = { r = 0.64, g = 0.19, b = 0.79, a = 1 },
				["PET"] = { r = 0.09, g = 0.61, b = 0.55, a = 1 },
				--["GUARDIAN"] = { r = 0.61, g = 0.09, b = 0.09 },
				["MOB"] = { r = 0.58, g = 0.24, b = 0.63, a = 1 },
				["UNKNOWN"] = { r = 0.1, g = 0.1, b = 0.1, a = 1 },
				["HOSTILE"] = { r = 0.5, g = 0, b = 0, a = 1 },
				["UNGROUPED"] = { r = 0.63, g = 0.58, b = 0.24, a = 1 },
			},
			["Realtime"] = {
			},
			["Names"] = {
			}
		},
		MaxFights = 5,
		--[[Window = {
			--ShowCurAndLast = false,
		},]]
		ReportLines = 10,
		MessagesTracked = 50,
		GlobalStatusBar = false,
		AutoDelete = true,
		AutoDeleteCombatants = true, -- Elsia: set this to true to reduce data accumulation
		AutoDeleteTime = 180,
		AutoDeleteNewInstance = true, -- Elsia: set this to true
		ConfirmDeleteInstance = true, -- Elsia: Get annoying popup box?
		LastInstanceName = "", -- Elsia: Last instance is empty by default
		DeleteNewInstanceOnly = true,
		DeleteJoinRaid = true,
		ConfirmDeleteRaid = true,
		DeleteJoinGroup = true,
		ConfirmDeleteGroup = true,
		BarTexture = "BantoBar",
		MergePets = true,
		MergeAbsorbs = true,
		MergeDamageAbsorbs = true,
		RecordCombatOnly = true,
		SegmentBosses = false,
		MainWindowVis = true,
		MainWindowMode = 1,
		Locked = false,
		EnableSync = false, -- Elsia: Default enable sync is set to true again now, thanks to lazy syncing
		GlobalDataCollect = true, -- Elsia: Global toggle for data collection
		HideCollect = false, -- Elsia: Hide Recount window when not collecting data
		HidePetBattle = false,
		Font = "Arial Narrow",
		Scaling = 1,
		Modules = {
			HealingTaken = true,
			OverhealingDone = true,
			Deaths = true,
			DOTUptime = true,
			HOTUptime = true,
			Activity = true,
		},
		MainWindow = {
			Buttons = {
				ReportButton = true,
				FileButton = true,
				ConfigButton = true,
				ResetButton = true,
				LeftButton = true,
				RightButton = true,
				CloseButton = true,
			},
			RowHeight = 14,
			RowSpacing = 1,
			AutoHide = false,
			ShowScrollbar = true, -- Elsia: Allow toggle of scrollbar
			HideTotalBar = true,
			BarText = {
				RankNum = true,
				ServerName = false,
				PerSec = true,
				Percent = true,
				NumFormat = 1,
			},
			Position = {
				x = 0,
				y = 0,
				w = 140,
				h = 200,
			},
		},
		Filters = {
			Show = {
				Self = true,
				Grouped = true,
				Ungrouped = true, -- Elsia: Default show leaving party members
				Hostile = false,
				Pet = false,
				Trivial = false,
				Nontrivial = false,
				Boss = false,
				Unknown = false,
			},
			Data = {
				Self = true,
				Grouped = true,
				Ungrouped = false, -- Elsia: Removed to reduce default data accumulation
				Hostile = false,
				Pet = true,
				Trivial = false,
				Nontrivial = false,
				Boss = true,
				Unknown = true,
			},
			TimeData = {
				Self = false,
				Grouped = false, -- Elsia: Removed Default timed on for groups
				Ungrouped = false,
				Hostile = false,
				Pet = false,
				Trivial = false,
				Nontrivial = false,
				Boss = false, -- Elsia:Removed Default timed on for bosses
				Unknown = false,
			},
			TrackDeaths = {
				Self = true,
				Grouped = true,
				Ungrouped = false,
				Hostile = false,
				Pet = true,
				Trivial = false,
				Nontrivial = false,
				Boss = true,
				Unknown = false,
			},
		},
		ZoneFilters = {
			none = true, -- Elsia: These fields are named after what IsInInstance() returns for types.
			pvp = true,
			arena = true,
			scenario = true,
			party = true,
			raid = true,
		},
		GroupFilters = {
			[1] = true, -- Solo
			[2] = true, -- Party
			[3] = true, -- Raid
		},
		FilterDeathType = {
			DAMAGE = true,
			HEAL = true,
			MISC = true,
		},
		FilterDeathIncoming = {
			[true] = true,
			[false] = false
		},
		RealtimeWindows = { },
		ClampToScreen = false,
	},
}

--SM:Register("statusbar", "Aluminium",			[[Interface\Addons\Recount\Textures\statusbar\Aluminium]])
--SM:Register("statusbar", "Armory",				[[Interface\Addons\Recount\Textures\statusbar\Armory]])
--SM:Register("statusbar", "BantoBar",			[[Interface\Addons\Recount\Textures\statusbar\BantoBar]])
--SM:Register("statusbar", "Flat",				[[Interface\Addons\Recount\Textures\statusbar\Flat]])
--SM:Register("statusbar", "Minimalist",			[[Interface\Addons\Recount\Textures\statusbar\Minimalist]])
--SM:Register("statusbar", "Otravi",				[[Interface\Addons\Recount\Textures\statusbar\Otravi]])
--SM:Register("statusbar", "Empty",				[[Interface\Addons\Recount\Textures\statusbar\Empty]])

BINDING_HEADER_RECOUNT = "Recount"
BINDING_NAME_RECOUNT_PREVIOUSPAGE = L["Show previous main page"]
BINDING_NAME_RECOUNT_NEXTPAGE = L["Show next main page"]
BINDING_NAME_RECOUNT_DAMAGE = L["Display"].." "..L["Damage Done"]
BINDING_NAME_RECOUNT_DPS = L["Display"].." "..L["DPS"]
BINDING_NAME_RECOUNT_FRIENDLYFIRE = L["Display"].." "..L["Friendly Fire"]
BINDING_NAME_RECOUNT_DAMAGETAKEN = L["Display"].." "..L["Damage Taken"]
BINDING_NAME_RECOUNT_HEALING = L["Display"].." "..L["Healing Done"]
BINDING_NAME_RECOUNT_HEALINGTAKEN = L["Display"].." "..L["Healing Taken"]
BINDING_NAME_RECOUNT_OVERHEALING = L["Display"].." "..L["Overhealing Done"]
BINDING_NAME_RECOUNT_DEATHS = L["Display"].." "..L["Deaths"]
BINDING_NAME_RECOUNT_DOTS = L["Display"].." "..L["DOT Uptime"]
BINDING_NAME_RECOUNT_HOTS = L["Display"].." "..L["HOT Uptime"]
BINDING_NAME_RECOUNT_ACTIVITY = L["Display"].." "..L["Activity"]
BINDING_NAME_RECOUNT_DISPELS = L["Display"].." "..L["Dispels"]
BINDING_NAME_RECOUNT_DISPELLED = L["Display"].." "..L["Dispelled"]
BINDING_NAME_RECOUNT_INTERRUPTS = L["Display"].." "..L["Interrupts"]
BINDING_NAME_RECOUNT_RESURRECT = L["Display"].." "..L["Ressers"]
BINDING_NAME_RECOUNT_CCBREAKER = L["Display"].." "..L["CC Breakers"]
BINDING_NAME_RECOUNT_MANA = L["Display"].." "..L["Mana Gained"]
BINDING_NAME_RECOUNT_ENERGY = L["Display"].." "..L["Energy Gained"]
BINDING_NAME_RECOUNT_RAGE = L["Display"].." "..L["Rage Gained"]
BINDING_NAME_RECOUNT_RUNICPOWER = L["Display"].." "..L["Runic Power Gained"]
BINDING_NAME_RECOUNT_LUNAR_POWER = L["Display"].." "..L["Astral Power Gained"]
BINDING_NAME_RECOUNT_MAELSTROM = L["Display"].." "..L["Maelstorm Gained"]
BINDING_NAME_RECOUNT_FURY = L["Display"].." "..L["Fury Gained"]
BINDING_NAME_RECOUNT_PAIN = L["Display"].." "..L["Pain Gained"]

BINDING_NAME_RECOUNT_REPORT_MAIN = L["Report the Main Window Data"]
BINDING_NAME_RECOUNT_REPORT_DETAILS = L["Report the Detail Window Data"]
BINDING_NAME_RECOUNT_RESET_DATA = L["Resets the data"]
BINDING_NAME_RECOUNT_SHOW_MAIN = L["Shows the main window"]
BINDING_NAME_RECOUNT_HIDE_MAIN = L["Hides the main window"]
BINDING_NAME_RECOUNT_TOGGLE_MAIN = L["Toggles the main window"]
BINDING_NAME_RECOUNT_TOGGLE_PAUSE = L["Toggle pause of global data collection"]
BINDING_NAME_RECOUNT_TOGGLE_MERGEPETS = L["Toggle merge pets"]

local optFrame

local function deepcopy(object)
	local lookup_table = {}
	local function _copy(object)
		if type(object) ~= "table" then
			return object
		elseif lookup_table[object] then
			return lookup_table[object]
		end
		local new_table = {}
		lookup_table[object] = new_table
		for index, value in pairs(object) do
			new_table[_copy(index)] = _copy(value)
		end
		return setmetatable(new_table, getmetatable(object))
	end
	return _copy(object)
end

Recount.consoleOptions = {
	name = L["Recount"],
	type = 'group',
	args = {
		confdesc = {
			order = 1,
			type = "description",
			name = L["Config Access"].."\n",
			cmdHidden = true
		},
		windesc = {
			order = 10,
			type = "description",
			name = L["Window Options"].."\n",
			cmdHidden = true
		},
		syncdesc = {
			order = 20,
			type = "description",
			name = L["Sync Options"].."\n",
			cmdHidden = true
		},
		datadesc = {
			order = 30,
			type = "description",
			name = L["Data Options"].."\n",
			cmdHidden = true
		},
		[L["gui"]] = {
			order = 2,
			name = L["GUI"],
			desc = L["Open Ace3 Config GUI"],
			type = 'execute',
			func = function()
				-- Resike: Throws an error in AceConfigDialog if clicked twice.
				InterfaceOptionsFrame:Hide()
				AceConfigDialog:SetDefaultSize("Recount", 500, 550)
				AceConfigDialog:Open("Recount")
			end
		},
		[L["sync"]] = {
			order = 21,
			name = L["Sync"],
			desc = L["Toggles sending synchronization messages"],
			type = 'toggle',
			get = function(info)
				return Recount.db.profile.EnableSync
			end,
			set = function(info, v)
				if v then -- Elsia: Make sure it's on before enabling, an event might intervene
					Recount:ConfigComm()
					Recount:Print("Lazy Sync enabled")
				end
				Recount.db.profile.EnableSync = v
				if not v then -- Elsia: Make sure it's off before disabling, an event might intervene
					Recount:FreeComm()
					Recount:Print("Lazy Sync disabled")
				end
			end,
		},
		[L["reset"]] = {
			order = 31,
			name = L["Reset"],
			desc = L["Resets the data"],
			type = 'execute',
			func = function()
				Recount:ResetData()
			end
		},
		[L["verChk"]] = {
			order = 22,
			name = L["VerChk"],
			desc = L["Displays the versions of players in the raid"],
			type = 'execute',
			func = function()
				Recount:ReportVersions()
			end
		},
		[L["show"]] = {
			order = 12,
			name = L["Show"],
			desc = L["Shows the main window"],
			type = 'execute',
			func = function()
				Recount.MainWindow:Show()
				Recount:RefreshMainWindow()
			end,
			dialogHidden = true
		},
		[L["pause"]] = {
			order = 23,
			name = L["Pause"],
			desc = L["Toggle pause of global data collection"],
			type = 'execute',
			func = function()
				if not Recount.db.profile.GlobalDataCollect then
					Recount:SetGlobalDataCollect(true)
					Recount:Print(L["Data collection turned on"])
				else
					Recount:SetGlobalDataCollect(false)
					Recount:Print(L["Data collection turned off"])
				end
			end,
		},
		hide = {
			order = 13,
			name = L["Hide"],
			desc = L["Hides the main window"],
			type = 'execute',
			func = function()
				Recount.MainWindow:Hide()
			end,
			dialogHidden = true
		},
		toggle = {
			order = 11,
			name = L["Toggle"],
			desc = L["Toggles the main window"],
			type = 'execute',
			func = function()
				if Recount.MainWindow:IsShown() then
					Recount.MainWindow:Hide()
				else
					Recount.MainWindow:Show()
					Recount:RefreshMainWindow()
				end
			end
		},
		config = {
			order = 3,
			name = L["Config"],
			desc = L["Shows the config window"],
			type = 'execute',
			func = function()
				Recount:ShowConfig()
			end
		},
		resetpos = {
			order = 14,
			name = L["ResetPos"],
			desc = L["Resets the positions of the detail, graph, and main windows"],
			type = 'execute',
			func = function()
				Recount:ResetPositions()
			end
		},
		lock = {
			order = 15,
			name = L["Lock"],
			desc = L["Toggles windows being locked"],
			type = 'toggle',
			get = function(info)
				return Recount.db.profile.Locked
			end,
			set = function(info, v)
				Recount.db.profile.Locked = v
				Recount:LockWindows(v)
			end,
		},
		maxfights = {
			order = 31,
			name = L["Recorded Fights"],
			desc = L["Set the maximum number of recorded fight segments"],
			type = 'range',
			min = 1,
			max = 25,
			step = 1,
			get = function(info)
				return Recount.db.profile.MaxFights
			end,
			set = function(info, v)
				if v < Recount.db.profile.MaxFights then
					Recount.Fights:DeleteOverflowFights(v)
				end
				Recount.db.profile.MaxFights = v
			end,
		},
		FrameStrata = {
			type = "select",
			order = 17,
			name = L["Frame Strata"],
			desc = L["Controls the frame strata of the Recount windows. Default: MEDIUM"],
			values = { -- A hack to sort them in the menu
				["1-BACKGROUND"] = "BACKGROUND",
				["2-LOW"] = "LOW",
				["3-MEDIUM"] = "MEDIUM",
				["4-HIGH"] = "HIGH",
				["5-DIALOG"] = "DIALOG",
				["6-FULLSCREEN"] = "FULLSCREEN",
				["7-FULLSCREEN_DIALOG"] = "FULLSCREEN_DIALOG",
				["8-TOOLTIP"] = "TOOLTIP",
			},
			get = function(info)
				return Recount.db.profile.FrameStrata or "3-MEDIUM"
			end,
			set = function(info, value)
				Recount.db.profile.FrameStrata = value
				Recount:SetStrataAndClamp()
			end,
		},
		ClampToScreen = {
			type = "toggle",
			name = L["Clamp To Screen"],
			desc = L["Controls whether the Recount windows can be dragged offscreen"],
			order = 16,
			get = function(info)
				return Recount.db.profile.ClampToScreen
			end,
			set = function(info, value)
				Recount.db.profile.ClampToScreen = value
				Recount:SetStrataAndClamp()
			end,
		},
	}
}

Recount.consoleOptions2 = deepcopy(Recount.consoleOptions)

Recount.consoleOptions2.args.report = {
	order = 32,
	name = L["Report"],
	type = 'group',
	desc = L["Allows the data of a window to be reported"],
	args = {
		detail = {
			type = "select",
			name = L["Detail"],
			order = 2,
			desc = L["Report the Detail Window Data"],
			values = {
				["Say"] = "Say",
				["Party"] = "Party",
				["Raid"] = "Raid",
				["Guild"] = "Guild",
				["Officer"] = "Officer",
				["Gui"] = "GUI",
			},
			get = function(info)
				return "Select"
			end,
			set = function(info, value)
				if string_lower(value) == "gui" then
					Recount:ShowReport("Detail", Recount.ReportDetail)
				else
					Recount.db.profile.ReportLines = Recount.db.profile.ReportLines or 10
					Recount:ReportDetail(Recount.db.profile.ReportLines, string_lower(value), "")
				end
			end,
		},
		main = {
			type = "select",
			name = L["Main"],
			order = 1,
			desc = L["Report the Main Window Data"],
			values = {
				["Say"] = "Say",
				["Party"] = "Party",
				["Raid"] = "Raid",
				["Guild"] = "Guild",
				["Officer"] = "Officer",
				["Gui"] = "GUI",
			},
			get = function(info)
				return "Select"
			end,
			set = function(info, value)
				if string_lower(value) == "gui" then
					Recount:ShowReport("Main", Recount.ReportData)
				else
					Recount.db.profile.ReportLines = Recount.db.profile.ReportLines or 10
					Recount:ReportData(Recount.db.profile.ReportLines, string_lower(value), "")
				end
			end,
		},
		lines = {
			order = 3,
			name = L["Lines Reported"],
			desc = L["Set the maximum number of lines to report"],
			type = 'range',
			min = 1,
			max = 25,
			step = 1,
			get = function(info)
				return Recount.db.profile.ReportLines or 10
			end,
			set = function(info, v)
				Recount.db.profile.ReportLines = v
			end,
		},
	}
}

Recount.consoleOptions2.args.realtime = {
	name = L["Realtime"],
	type = 'group',
	desc = L["Specialized Realtime Graphs"],
	args = {
		netfps = {
			name = L["Network and FPS"],
			type = 'group',
			inline = true,
			args = {
				fps = {
					name = L["FPS"],
					desc = L["Starts a realtime window tracking your FPS"],
					type = 'execute',
					func = function()
						Recount:CreateRealtimeWindow("FPS", "FPS", "")
					end
				},
				lag = {
					name = L["Lag"],
					desc = L["Starts a realtime window tracking your latency"],
					type = 'execute',
					func = function()
						Recount:CreateRealtimeWindow("Latency", "LAG", "")
					end
				},
				uptraffic = {
					name = L["Upstream Traffic"],
					desc = L["Starts a realtime window tracking your upstream traffic"],
					type = 'execute',
					func = function()
						Recount:CreateRealtimeWindow("Upstream Traffic", "UP_TRAFFIC", "")
					end
				},
				downtraffic = {
					name = L["Downstream Traffic"],
					desc = L["Starts a realtime window tracking your downstream traffic"],
					type = 'execute',
					func = function()
						Recount:CreateRealtimeWindow("Downstream Traffic", "DOWN_TRAFFIC", "")
					end
				},
				bandwidth = {
					name = L["Available Bandwidth"],
					desc = L["Starts a realtime window tracking amount of available AceComm bandwidth left"],
					type = 'execute',
					func = function()
						Recount:CreateRealtimeWindow("Bandwidth Available", "AVAILABLE_BANDWIDTH", "")
					end
				},
			},
		},
		raid = {
			name = L["Raid"],
			desc = L["Tracks your entire raid"],
			type = 'group',
			inline = true,
			args = {
				dps = {
					name = L["DPS"],
					desc = L["Tracks Raid Damage Per Second"],
					type = 'execute',
					func = function()
						Recount:CreateRealtimeWindow("!RAID", "DAMAGE", "Raid DPS")
					end
				},
				dtps = {
					name = L["DTPS"],
					desc = L["Tracks Raid Damage Taken Per Second"],
					type = 'execute',
					func = function()
						Recount:CreateRealtimeWindow("!RAID", "DAMAGETAKEN", "Raid DTPS")
					end
				},
				hps = {
					name = L["HPS"],
					desc = L["Tracks Raid Healing Per Second"],
					type = 'execute',
					func = function()
						Recount:CreateRealtimeWindow("!RAID", "HEALING", "Raid HPS")
					end
				},
				htps = {
					name = L["HTPS"],
					desc = L["Tracks Raid Healing Taken Per Second"],
					type = 'execute',
					func = function()
						Recount:CreateRealtimeWindow("!RAID", "HEALINGTAKEN", "Raid HTPS")
					end
				},
			}
		}
	}
}

function Recount:PLAYER_REGEN_ENABLED()
	Recount:ResetDataUnsafe()
end

function Recount:ZONE_CHANGED_NEW_AREA()
	Recount:DetectInstanceChange()
end

function Recount:PLAYER_ENTERING_WORLD()
	Recount:DetectInstanceChange()
end

function Recount:PET_BATTLE_OPENING_START()
	Recount:PetBattleUpdate()
end

function Recount:PET_BATTLE_CLOSE()
	Recount:PetBattleUpdate()
end

function Recount:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	Recount:BossFound()
end

function Recount:ReportVersions() -- Elsia: Functionified so GUI can use it too
	if GetNumGroupMembers() == 0 then
		Recount:Print(L["No other Recount users found."])
	else
		if Recount.VerTable then -- Elsia: Fixed nil error on non sync situation.
			Recount:Print(L["Displaying Versions"]..":")
			for k, v in pairs(Recount.VerTable) do
				Recount:Print(k.." "..v)
			end
		end
	end
end

function Recount:ShowCombatantList()
	for k, v in pairs(dbCombatants) do
		Recount:Print(k.." "..(v.Name or "nil").." "..(v.type or "nil").." "..(v.level or "nil").." "..(v.enClass or "nil").." "..(v.GUID or "nil"))
	end
	Recount:ShowNrCombatants()
end

function Recount:NrCombatants()
	local counter = 0
	for k, v in pairs(dbCombatants) do
		counter = counter + 1
	end
	return counter
end

function Recount:ShowNrCombatants()
	Recount:Print(Recount:NrCombatants())
end

function Recount:ResetData()
	if UnitAffectingCombat("player") then
		Recount.events:RegisterEvent("PLAYER_REGEN_ENABLED")
	else
		Recount:ResetDataUnsafe()
	end
end

function Recount:ResetDataUnsafe()
	Recount.events:UnregisterEvent("PLAYER_REGEN_ENABLED")
	if Recount.GraphWindow then
		Recount.GraphWindow:Hide()
		Recount.GraphWindow.LineGraph:LockXMin(false)
		Recount.GraphWindow.LineGraph:LockXMax(false)
		Recount.GraphWindow.TimeRangeSet = false
	end
	if Recount.DetailWindow then
		Recount.DetailWindow:Hide()
	end
	for k, v in pairs(dbCombatants) do
		Recount:DeleteGuardianOwnerByGUID(dbCombatants[k])
		dbCombatants[k] = nil
	end
	for k, v in pairs(Recount.db2.CombatTimes) do
		Recount.db2.CombatTimes[k] = nil
	end
	if Recount.MainWindow and Recount.MainWindow.DispTableSorted then
		Recount.MainWindow.DispTableSorted = Recount:GetTable()
		Recount.MainWindow.DispTableLookup = Recount:GetTable()
	end
	if Recount.MainWindow then
		Recount:RefreshMainWindow()
	end
	if #Recount.db2.FoughtWho > 0 then
		Recount:SendReset() -- Elsia: Sync the reset if we actually fought something
	end
	Recount.db2.FoughtWho = { }
	Recount:ResetTableCache()
	if Recount.db.profile.CurDataSet ~= "CurrentFightData" and Recount.db.profile.CurDataSet ~= "LastFightData" then
		Recount.db.profile.CurDataSet = "OverallData"
	end
	if RecountDeathTrack then
		RecountDeathTrack:DeleteAllTracks()
		RecountDeathTrack:SetFight(Recount.db.profile.CurDataSet)
	end
	Recount.db2.FightNum = 0
	for k, v in pairs(dbCombatants) do
		v.LastFightIn = 0
	end
	-- Perform a garbage collect if they are resetting the data
	collectgarbage()
end

function Recount:FindUnit(name)
	local unit = Recount:GetUnitIDFromName(name) -- We shouldn't need to find roster units.
	if unit then
		return unit
	end
	unit = Recount:FindTargetedUnit(name)
	return unit
end

function Recount:ResetFightData(data)
	if not data then
		data = { }
	else
		for k, v in pairs(data) do
			if type(v) == "table" then
				Recount:ResetFightData(v)
			elseif type(v) == "number" then
				data[k] = 0
			elseif type(v) == "string" then
				data[k] = nil
			elseif type(v) == "boolean" then
				data[k] = nil
			end
		end
	end
end

function Recount:InitFightData(data)
	-- Init Data tracked
	data.Damage = 0
	data.FDamage = 0
	data.DamageTaken = 0
	data.Healing = 0
	data.HealingTaken = 0
	data.Overhealing = 0
	data.DeathCount = 0
	data.DOT_Time = 0
	data.HOT_Time = 0
	data.Interrupts = 0
	data.Dispels = 0
	data.Dispelled = 0
	data.ActiveTime = 0
	data.TimeHeal = 0
	data.TimeDamage = 0
	data.CCBreak = 0
	data.ManaGain = 0
	data.EnergyGain = 0
	data.RageGain = 0
	data.RunicPowerGain = 0
	data.Ressed = 0
	-- Ability Data
	data.Attacks = Recount:GetTable()
	data.FAttacks = Recount:GetTable()
	data.Heals = Recount:GetTable()
	data.OverHeals = Recount:GetTable()
	data.DOTs = Recount:GetTable()
	data.HOTs = Recount:GetTable()
	data.InterruptData = Recount:GetTable()
	data.CCBroken = Recount:GetTable()
	-- Interaction Data
	data.DamagedWho = Recount:GetTable() -- Who did I damage?
	data.FDamagedWho = Recount:GetTable() -- Who did I damage?
	data.WhoDamaged = Recount:GetTable() -- Who damaged me?
	data.HealedWho = Recount:GetTable() -- Who did I heal?
	data.WhoHealed = Recount:GetTable() -- Who healed me?
	data.DispelledWho = Recount:GetTable() -- Who did I dispel?
	data.WhoDispelled = Recount:GetTable() -- Who dispelled me?
	data.TimeSpent = Recount:GetTable() -- Where did I spend my time
	data.TimeDamaging = Recount:GetTable() -- Where did I spend my time attacking
	data.TimeHealing = Recount:GetTable() -- Where did I spend my time healing
	data.ManaGained = Recount:GetTable() -- Where did I gain mana
	data.EnergyGained = Recount:GetTable() -- Where did I gain energy
	data.RageGained = Recount:GetTable() -- Where did I gain rage
	data.RunicPowerGained = Recount:GetTable() -- Where did I gain runic power
	data.ManaGainedFrom = Recount:GetTable() -- Where did I gain mana
	data.EnergyGainedFrom = Recount:GetTable() -- Where did I gain energy
	data.RageGainedFrom = Recount:GetTable() -- Where did I gain rage
	data.RunicPowerGainedFrom = Recount:GetTable() -- Where did I gain runic power
	data.PartialResist = Recount:GetTable() -- What spells partially resisted
	data.PartialBlock = Recount:GetTable() -- What attacks partially blocked
	data.PartialAbsorb = Recount:GetTable() -- What damage partially absorbed
	data.RessedWho = Recount:GetTable()
	-- Elemental Tracking
	data.ElementDone = Recount:GetTable()
	data.ElementDoneResist = Recount:GetTable()
	data.ElementDoneBlock = Recount:GetTable()
	data.ElementDoneAbsorb = Recount:GetTable()
	data.ElementTaken = Recount:GetTable()
	data.ElementTakenResist = Recount:GetTable()
	data.ElementTakenBlock = Recount:GetTable()
	data.ElementTakenAbsorb = Recount:GetTable()
	data.ElementHitsDone = Recount:GetTable()
	data.ElementHitsTaken = Recount:GetTable()
end

function Recount:CreateOwnerFlags(nameFlags)
	local ownerFlags = bit_band(nameFlags, COMBATLOG_OBJECT_AFFILIATION_MASK + COMBATLOG_OBJECT_REACTION_MASK + COMBATLOG_OBJECT_CONTROL_MASK)
	if bit_band(nameFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) ~= 0 then
		ownerFlags = ownerFlags + COMBATLOG_OBJECT_TYPE_PLAYER
	else -- NPC
		ownerFlags = ownerFlags + COMBATLOG_OBJECT_TYPE_NPC
	end
	return ownerFlags
end

local FlagsToUnitID = {
	[COMBATLOG_OBJECT_TARGET]				= "target",
	[COMBATLOG_OBJECT_FOCUS]				= "focus",
	[COMBATLOG_OBJECT_MAINTANK]				= "maintank",
	[COMBATLOG_OBJECT_MAINASSIST]			= "mainassist",
	[COMBATLOG_OBJECT_RAIDTARGET1]			= "raid1target",
	[COMBATLOG_OBJECT_RAIDTARGET2]			= "raid2target",
	[COMBATLOG_OBJECT_RAIDTARGET3]			= "raid3target",
	[COMBATLOG_OBJECT_RAIDTARGET4]			= "raid4target",
	[COMBATLOG_OBJECT_RAIDTARGET5]			= "raid5target",
	[COMBATLOG_OBJECT_RAIDTARGET6]			= "raid6target",
	[COMBATLOG_OBJECT_RAIDTARGET7]			= "raid7target",
	[COMBATLOG_OBJECT_RAIDTARGET8]			= "raid8target",
}

function Recount:FindPetUnitFromFlags(unitFlags, unitGUID)
	if bit_band(unitFlags, COMBATLOG_OBJECT_TYPE_PET) == 0 then -- Elsia: Has to be a pet. Guardians don't yet have unitids
		return
	end
	-- Check for my pet
	if bit_band(unitFlags, COMBATLOG_OBJECT_TYPE_PET) ~= 0 and bit_band(COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0 then
		return "pet" -- Elsia: My pet is easy
	end
	-- Check for raid and party pets.
	if bit_band(unitFlags, COMBATLOG_OBJECT_TYPE_PET) ~= 0 and bit_band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_RAID + COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0 then
		if bit_band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) ~= 0 then
			local Num = GetNumRaidMembers()
			if IsInRaid() and Num > 0 then
				for i = 1, Num do
					if unitGUID == UnitGUID("raidpet"..i) then
						return "raidpet"..i
					end
				end
			end
		elseif bit_band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_PARTY) ~= 0 then
			local Num = GetNumPartyMembers()
			if not IsInRaid() and Num > 0 then
				for i = 1, Num do
					if unitGUID == UnitGUID("partypet"..i) then
						return "partypet"..i
					end
				end
			end
		end
	end
	return nil
end

function Recount:FindUnitFromFlags(unitname, unitFlags)
	-- Elisa: This check excludes pets.
	if bit_band(unitFlags, COMBATLOG_OBJECT_TYPE_PLAYER) ~= 0 and bit_band(unitFlags, COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_RAID + COMBATLOG_OBJECT_AFFILIATION_MINE) ~= 0 then
		return unitname -- Elsia: Covers all non-pet players in raid
	end
	-- This returns all target-inferable units from flags.
	for k, v in pairs(FlagsToUnitID) do
		if bit_band(k, unitFlags) ~= 0 then
			local vname, vrealm = UnitName(v)
			if vname and vname == unitname then
				return v
			end
		end
	end
	return nil
end

function Recount:FindGuardianFromTooltip(nameGUID)
	RecountTempTooltip:SetOwner(UIParent, "ANCHOR_NONE")
	RecountTempTooltip:ClearLines()
	RecountTempTooltip:SetHyperlink("unit:"..nameGUID)
	if RecountTempTooltip:NumLines() > 0 then
		local petName = _G["RecountTempTooltipTextLeft1"]:GetText()
		return petName
	else
		return nil
	end
end

function Recount:ScanGUIDTooltip(nameGUID)
    local newGUIDparts = {('-'):split(nameGUID)}
	local NPCID = tonumber(newGUIDparts[6])
	local spawnUID = tonumber(newGUIDparts[7], 16)
	local nameGUID2 = string_format("%s-%s-%s-%s-%s-%d-%10X", newGUIDparts[1], newGUIDparts[2], newGUIDparts[3], newGUIDparts[4], newGUIDparts[5], NPCID, spawnUID)
	Recount:Print(NPCID.." "..nameGUID.." "..nameGUID2)
	RecountTempTooltip:SetOwner(UIParent, "ANCHOR_NONE")
	RecountTempTooltip:ClearLines()
	RecountTempTooltip:SetHyperlink("unit:" .. nameGUID2)
	local tooltipName = "RecountTempTooltip"
	local textLeft, textRight, ttextLeft, ttextRight
	for idx = 1, RecountTempTooltip:NumLines() do
		ttextLeft = _G[tooltipName.."TextLeft"..idx]
		if ttextLeft then
			textLeft = ttextLeft:GetText()
			if textLeft then
				Recount:Print("left"..idx..": "..textLeft)
			end
		else
			textLeft = nil
		end
		ttextRight = _G[tooltipName.."TextRight"..idx]
		if ttextRight then
			textRight = ttextRight:GetText()
			if textRight then
				Recount:Print("right"..idx..": "..textRight)
			end
		else
			textRight = nil
		end
	end
end

function Recount:GetGuardianOwnerByGUID(nameGUID)
	return Recount.GuardianOwnerGUIDs and Recount.GuardianOwnerGUIDs[nameGUID]
end

function Recount:GetInheritGuardian(owner, name)
	local latestGuardian = owner.GuardianReverseGUIDs[name].LatestGuardian
	local petName = owner.Pet
	local petGUID = owner.GuardianReverseGUIDs and owner.GuardianReverseGUIDs[petName] and owner.GuardianReverseGUIDs[petName].GUIDs[latestGuardian]
	return petName, petGUID
end

function Recount:TrackGuardianOwnerByGUID(owner, name, nameGUID)
	owner.GuardianReverseGUIDs = owner.GuardianReverseGUIDs or { }
	Recount.GuardianOwnerGUIDs = Recount.GuardianOwnerGUIDs or { }
	local oldGUID = owner.GuardianReverseGUIDs and owner.GuardianReverseGUIDs[name] and type(owner.GuardianReverseGUIDs[name]) ~= "string"
	local latestGuardian = 0
	if not oldGUID then
		owner.GuardianReverseGUIDs[name] = {}
		owner.GuardianReverseGUIDs[name].LatestGuardian = 0
		owner.GuardianReverseGUIDs[name].GUIDs = {}
		owner.GuardianReverseGUIDs[name].GUIDs[latestGuardian] = nameGUID
		Recount.GuardianOwnerGUIDs[nameGUID] = owner.Name
	else
		if not owner.GuardianReverseGUIDs[name].LatestGuardian then
			owner.GuardianReverseGUIDs[name].LatestGuardian = 0
			owner.GuardianReverseGUIDs[name].GUIDs = {}
		end
		latestGuardian = owner.GuardianReverseGUIDs[name].LatestGuardian + 1
		owner.GuardianReverseGUIDs[name].GUIDs[latestGuardian] = nameGUID
		if latestGuardian > 12 then -- Elsia: Max guardians set to 20 for now: edit, reduced to 12 to improve performance
			latestGuardian = 0
		end
		owner.GuardianReverseGUIDs[name].LatestGuardian = latestGuardian
		Recount.GuardianOwnerGUIDs[nameGUID] = owner.Name
	end
end

function Recount:DeleteGuardianOwnerByGUID(owner)
	if owner.GuardianReverseGUIDs then
		for k, v in pairs(owner.GuardianReverseGUIDs) do
			if Recount.GuardianOwnerGUIDs and owner.GuardianReverseGUIDs[v] and owner.GuardianReverseGUIDs[v].GUIDs then
				for i, v2 in ipairs(owner.GuardianReverseGUIDs[v].GUIDs) do
					Recount.GuardianOwnerGUIDs[v2] = nil
				end
			end
		end
	end
end

function Recount:IsFriend(flags)
	return bit_band(flags, COMBATLOG_OBJECT_REACTION_FRIENDLY) ~= 0
end

function Recount:IsPlayer(flags)
	return bit_band(flags, COMBATLOG_OBJECT_TYPE_PLAYER) == COMBATLOG_OBJECT_TYPE_PLAYER
end

function Recount:IsPet(flags)
	return bit_band(flags, COMBATLOG_OBJECT_TYPE_PET + COMBATLOG_OBJECT_TYPE_GUARDIAN) ~= 0
end

function Recount:InGroup(flags)
	return bit_band(flags, COMBATLOG_OBJECT_AFFILIATION_MINE + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_RAID) ~= 0
end

function Recount:IsFriendlyFire(srcFlags, dstFlags)
	return (bit_band(srcFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) ~= 0) and (bit_band(dstFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) ~= 0)
	--return (Recount:IsFriend(srcFlags) == Recount:IsFriend(dstFlags)) and ((Recount:IsPlayer(srcFlags) or Recount:IsPet(srcFlags)) and (Recount:IsPlayer(dstFlags) or Recount:IsPet(dstFlags))) -- We only care for friendly fire between players now Edit: and pets
end

local lastSummonPetName
local lastSummonPetGUID
local lastSummonOwnerName
local lastSummonOwnerGUID

function Recount:AddPetCombatant(nameGUID, petName, nameFlags, ownerGUID, owner, ownerFlags)
	if lastSummonOwnerGUID and lastSummonOwnerGUID == nameGUID then
		Recount:DPrint("Inheriting Pet: ".. lastSummonPetName.." from ".. petName)
		petName = lastSummonPetName
		nameGUID = lastSummonPetGUID
	else
		lastSummonPetName = petName
		lastSummonPetGUID = nameGUID
		lastSummonOwnerName = owner
		lastSummonOwnerGUID = ownerGUID
	end
	--local name = petName.." <"..owner..">"
	--local combatant = dbCombatants[name] or { }
	--[[if bit_band(ownerFlags, COMBATLOG_OBJECT_AFFILIATION_MINE + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_RAID+COMBATLOG_OBJECT_REACTION_FRIENDLY) == 0 then
		--return -- Elsia: We only keep affiliated or friendly pets. These flags can be horribly wrong unfortunately
	end
	if petName:match("<(.-)>") or owner:match("<(.-)>") then
		--Recount:DPrint(petName.." : "..owner.." !Double owner detected! Please report the trace below")
		--Recount:DPrint(debugstack(2, 3, 2))
	end]]
	local inheritowner = Recount:GetGuardianOwnerByGUID(ownerGUID)
	if inheritowner then -- This should only happen for pets of pets such as greater elementals
		owner = inheritowner
	end
	local name = petName.." <"..owner..">"
	local combatant = dbCombatants[name] or { }
	--local elementschool = petName:match("(.*) Elemental Totem")
	--Recount:Print(petName.." "..(elementschool or "nil").." "..nameGUID:sub(3,-1)) -- This line needs adjusted to 6.0.2 GUID system to ever function
	--if bit_band(nameFlags, COMBATLOG_OBJECT_TYPE_GUARDIAN) then
		--[[local mobid = tonumber(nameGUID:sub(3 + 6, 3 + 9), 16) -- Removed this for inheritance testing; this line needs adjusted to 6.0.2 GUID system to ever function
		if Recount.ElementalMobID[mobid] then -- This really summoned a greater fire elemental totem, which is what we really care about.

			--Recount:Print("Elem!")
			gopts = {nameGUID, petName, nameFlags, ownerGUID, owner, ownerFlags }
			Recount:ScheduleTimer("AddGreaterElemental", 0.2, gopts)
		--else
			--Recount:Print(mobid)
		end]]
		if dbCombatants[owner] then -- We have a valid stored owner.
			Recount:TrackGuardianOwnerByGUID(dbCombatants[owner], petName, nameGUID)
		else
			Recount:SetOwner(combatant, name, owner, ownerGUID, ownerFlags)
			if dbCombatants[owner] then -- We have a valid stored owner.
				Recount:TrackGuardianOwnerByGUID(dbCombatants[owner], petName, nameGUID)
			--[[else
				Recount.tempGuards = Recount.tempGuards or {}
				Recount.tempGuards[ownerGUID] = {}
				Recount.tempGuards[ownerGUID].name = owner
				Recount:TrackGuardianOwnerByGUID(Recount.tempGuards[ownerGUID], petName, nameGUID)
				Recount:DPrint("special guardian tracking: "..owner.." "..petName)
				end]]
			end
		end
	--end
	--[[if Recount.tempGuards[petGUID] and dbCombatants[owner] then -- This propagates temporary guardians forward. Note that this ignores flags
		petName, nameGUID = Recount:GetInheritGuardian(Recount.tempGuards[petGUID], petName)
		name = petName.." <"..owner..">"
		Recount:DPrint("special guardian tracking: "..name.." "..nameGUID)
		Recount.tempGuards = nil -- Get rid of it to avoid accummulation
	end]]
	combatant.GUID = nameGUID
	combatant.LastFlags = nameFlags
	if combatant.Name then -- Already have such a pet!
		--Recount:DPrint("Pet1: "..name.." "..owner.." "..petName)
		return
	end
	combatant.ownerName = owner
	combatant.Name = petName
	Recount:SetOwner(combatant, name, owner, ownerGUID, ownerFlags)
	combatant.type = "Pet"
	combatant.enClass = "PET"
	-- Elsia: We inherit flags from owner, as currently 2.4 ptr the pet flags are not useful (typically 0xa28 for outsider, neutral, npc)
	combatant.unit = Recount:FindPetUnitFromFlags(nameFlags, nameGUID)
	if combatant.unit then
		combatant.level = UnitLevel(combatant.unit)
	else
		combatant.level = dbCombatants[owner].level -- Elsia: For guardians and other unidentifiable unitid pets, assume the owner level (heuristic)
	end
	--Recount:DPrint("Pet2: "..name.." "..owner.." "..petName)
	combatant.LastFightIn = Recount.db2.FightNum
	combatant.UnitLockout = Recount.CurTime
end

function Recount:AddCombatant(name, owner, nameGUID, nameFlags, ownerGUID)
	local combatant = { }
	if not nameFlags then
		Recount:Print("Improper: ".. name.." "..(nameFlags or "nil"))

		return -- Elsia: Improper!
	end
	combatant.GUID = nameGUID
	-- Handle Attributes that can be extracted from flags.
	local inGroup = Recount:InGroup(nameFlags) -- bit_band(nameFlags, COMBATLOG_OBJECT_AFFILIATION_MINE + COMBATLOG_OBJECT_AFFILIATION_PARTY+COMBATLOG_OBJECT_AFFILIATION_RAID) ~= 0
	local isPlayer = Recount:IsPlayer(nameFlags) -- bit_band(nameFlags, COMBATLOG_OBJECT_TYPE_PLAYER) == COMBATLOG_OBJECT_TYPE_PLAYER
	local isFriend = Recount:IsFriend(nameFlags) -- bit_band(nameFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) ~= 0
	-- Handle identified pets
	if owner then
		combatant.Name = string_match(name,"(.-) <")
		if not combatant.Name then -- Elsia: not sure when this can happen
			--Recount:DPrint("EEK:"..name.." "..owner)
			combatant.Name = name
			name = name.." <"..owner..">"
			--Recount:DPrint(name)
		end
		--[[if combatant.Name:match("<(.-)>") or owner:match("<(.-)>") then
			--Recount:DPrint(combatant.Name.." : "..owner.." !Double owner detected! Please report the trace below")
			--Recount:DPrint(debugstack(2, 3, 2))
		end]]
		Recount:SetOwner(combatant, name, owner, ownerGUID, Recount:CreateOwnerFlags(nameFlags))
		if Recount.db.profile.MergePets then
			Recount:AddAmount(dbCombatants[owner], "Damage", 0)
			Recount:AddAmount(dbCombatants[owner], "Healing", 0)
		end
		combatant.ownerName = owner
		combatant.type = "Pet"
		combatant.enClass = "PET"
		combatant.level = 1
		--[[combatant.unit = Recount:FindPetUnitFromFlags(nameFlags, nameGUID)
		if combatant.unit then
			combatant.level = UnitLevel(combatant.unit)
		else
			combatant.level = dbCombatants[owner].level -- Elsia: For guardians and other unidentifiable unitid pets, assume the owner level (heuristic)
		end]]
	else
		-- Handle non-pet units
		combatant.Name = name
		combatant.Owner = false -- Not a pet
		-- Handle Friendly combatants
		if isFriend and (inGroup or isPlayer) then
			-- Can find Unit from this
			--unit = Recount:FindUnitFromFlags(name, nameFlags)
			--if unit and combatant.isPlayer then -- Player Units
			if isPlayer then -- Player Units
				if Recount.PlayerName == name then
					combatant.type = "Self"
					local _
					_, combatant.enClass = UnitClass("player")
					combatant.level = UnitLevel("player")
				-- Handle Friendly grouped combatants
				elseif inGroup then
					local unit = Recount:FindUnitFromFlags(name, nameFlags)
					combatant.type = "Grouped"
					local _
					_, combatant.enClass = UnitClass(unit)
					combatant.level = UnitLevel(unit)
				-- Handle Friendly ungrouped combatants
				else
					combatant.type = "Ungrouped"
					local unit = Recount:FindTargetedUnit(name)
					if unit then
						local _
						_, combatant.enClass = UnitClass(unit)
						combatant.level = UnitLevel(unit)
					else
						combatant.enClass = "UNGROUPED" -- Check for target uid here
						combatant.level = 1
					end
				end
			--[[else
				Recount:DPrint("Got non-player grouped entity: "..name) -- Elsia: This proves to be pets!
				Recount:DPrint(debugstack(2, 3, 2))]]
			end
			--combatant.unit = unit
			--combatant.level = UnitLevel(unit)
		-- Handle hostile combatants
		elseif isPlayer then
			combatant.type = "Hostile"
			local unit = Recount:FindTargetedUnit(name)
			if unit then
				local _
				_, combatant.enClass = UnitClass(unit)
				combatant.level = UnitLevel(unit)
			else
				combatant.enClass = "HOSTILE" -- Check for target uid here
				combatant.level = 1
			end
		elseif bit_band(nameFlags, COMBATLOG_OBJECT_NONE) ~= COMBATLOG_OBJECT_NONE then -- Mob units that were flag targets
			combatant.enClass = "MOB"
			local unit = Recount:FindTargetedUnit(name)
			combatant.level = unit and UnitLevel(unit) or 1
			if unit and UnitIsTrivial(unit) then
				combatant.type = "Trivial"
			elseif combatant.level == -1 or Recount.IsBoss(nameGUID) then
				combatant.level = -1
				combatant.type = "Boss"
			else
				combatant.type = "Nontrivial"
			end
			combatant.enClass = "MOB"
		else
			--Recount:DPrint("Unknown spotted")
			combatant.type = "Unknown"
			combatant.enClass = "UNKNOWN"
		end
	end
	combatant.LastFightIn = Recount.db2.FightNum
	combatant.UnitLockout = Recount.CurTime
	dbCombatants[name] = combatant
	Recount:InitCombatant(name)
end

function Recount:InitCombatant(name)
	local combatant = dbCombatants[name]
	combatant.Fights = { }
end

function Recount:PartyPetOwnerFromGUID(who, petName, petGUID, petFlags)
	local ownerName, ownerGUID = Recount:FindOwnerPetFromGUID(petName, petGUID)
	--Recount:SetOwner(who, petName, ownerName, ownerGUID, Recount:CreateOwnerFlags(petFlags))
end

function Recount:SetOwner(who, petName, owner, ownerGUID, ownerFlags)
	if owner then
		if not dbCombatants[owner] then
			Recount:AddCombatant(owner, nil, ownerGUID, ownerFlags)
		end
		if not dbCombatants[owner].Pet then
			dbCombatants[owner].Pet = { }
		end
		for i, k in ipairs(dbCombatants[owner].Pet) do -- Prevent multi-pet registration
			if k == petName then
				return
			end
		end
		tinsert(dbCombatants[owner].Pet, petName)
	end
end

Recount.LastGroupCheck = 0
function Recount:GroupCheck()
	local gettime = GetTime()
	if Recount.LastGroupCheck > gettime and gettime - Recount.LastGroupCheck <= 0.25 then
		return
	end
	Recount.LastGroupCheck = gettime + 0.25
	for k, v in pairs(dbCombatants) do
		if k ~= Recount.PlayerName then
			--local Unit = Recount:GetUnitIDFromName(k)
			local Unit = UnitInParty(k)
			-- Must be in our group
			if Unit then
				v.unit = Unit
				v.type = "Grouped"
			elseif v.type == "Grouped" then
				v.type = "Ungrouped"
				Recount:DeleteVersion(k)
			end
		end
	end
end

local FilterWeights = { }
local FilterMiddle = 0
function Recount:CreateFilterWeights()
	local sum = 0
	local val, widthUp, widthDown
	local DownAt = FilterSize - RampDown
	widthUp = 1 / RampUp
	widthDown = 1 / RampDown
	for i = 1, FilterSize do
		if i <= RampUp then
			val = i * widthUp
			FilterWeights[#FilterWeights + 1] = val
			sum = sum + val
		elseif i <= DownAt then
			FilterWeights[#FilterWeights + 1] = 1
			sum = sum + 1
		else
			val = (FilterSize - i + 1) * widthDown
			FilterWeights[#FilterWeights + 1] = val
			sum = sum + val
		end
	end
	for i = 1, FilterSize do
		FilterWeights[i] = FilterWeights[i] / sum
		FilterMiddle = FilterMiddle + i * FilterWeights[i]
	end
	FilterMiddle = math_floor(FilterMiddle) - 1
end

local LinComp = 0.3
function Recount:CheckIfAlmostLinear(TimeData, NewTime, NewVal)
	if #TimeData[1] <= 1 or (NewTime - TimeData[1][#TimeData[1]]) > 10 then
		return false
	end
	local MidTime = TimeData[1][#TimeData[1]]
	local MidValue = TimeData[2][#TimeData[2]]
	local Width = NewTime - TimeData[1][#TimeData[1] - 1]
	local Lerp = (MidTime - TimeData[1][#TimeData[1] - 1]) / Width
	local LinValue = Lerp * NewVal + (1 - Lerp) * TimeData[2][#TimeData[2] - 1]
	if Lerp > 0.5 then
		Lerp = 1 - Lerp
	end
	local Weight = (MidValue - LinValue) / (Lerp * Width)
	if Weight < 0 then
		Weight = -Weight
	end
	if Weight < LinComp then
		return true
	end
	return false
end

function Recount:IsTimeDataActive()
	local filters = Recount.db.profile.Filters
	for k, v in pairs(filters.TimeData) do
		if v and filters.Data[k] then
			Recount.TickTimeData = true
			return
		end
	end
	Recount.TickTimeData = nil
end

function Recount:TimeTick()
	if not Recount.db.profile.GlobalDataCollect or not Recount.CurrentDataCollect then
		return
	end
	local Time = GetTime()
	-- First check if combat status changed
	if Recount.InCombat then
		Recount:CheckCombat(Time)
	end
	Recount.CurTime = Time
	Recount.UnitLockout = Time - 5
	if Recount.TickTimeData then
		local TimeCheck = Time - FilterSize - 1
		local gotdeleted
		-- Need to increment where data gets put and erase the old ones
		Recount.TimeStep = Recount.TimeStep + 1
		if Recount.TimeStep > FilterSize then
			Recount.TimeStep = 1
		end
		local filters = Recount.db.profile.Filters
		for name, v in pairs(Recount.db2.combatants) do
			local ctype = v.type
			if filters.Data[ctype] and filters.TimeData[ctype] and v.TimeLast and v.TimeLast["OVERALL"] and v.TimeLast["OVERALL"] >= TimeCheck then -- Elsia: Added global collection switch
				-- First threat data
				for k, v2 in pairs(v.TimeWindows) do
					local Temp
					local NewEntry = 0
					if v.TimeLast and v.TimeLast[k] and v.TimeLast[k] >= TimeCheck then
						-- Something is strange here but this works
						for k, v3 in ipairs(v2) do
							Temp = (FilterSize - k) + Recount.TimeStep
							if Temp > FilterSize then
								NewEntry = NewEntry + v3 * FilterWeights[Temp-FilterSize]
							else
								NewEntry = NewEntry + v3 * FilterWeights[Temp]
							end
						end
						-- Need to set where we will be putting new data to 0
						v2[Recount.TimeStep] = 0
					end
					v.TimeData = v.TimeData or {}
					v.TimeData[k] = v.TimeData[k] or {{},{}}
					local TimeData = v.TimeData[k]
					if NewEntry ~= 0 then
						-- Do we need a leading zero?
						if not v.TimeNeedZero or not v.TimeNeedZero[k] then
							TimeData[1][#TimeData[1] + 1] = Time - 1 - FilterMiddle
							TimeData[2][#TimeData[2] + 1] = 0

							v.TimeNeedZero = v.TimeNeedZero or {}
							v.TimeNeedZero[k] = true
						end
						if not Recount:CheckIfAlmostLinear(TimeData, Time - FilterMiddle, NewEntry) then
							TimeData[1][#TimeData[1] + 1] = Time - FilterMiddle
							TimeData[2][#TimeData[2] + 1] = NewEntry
						else
							-- If almost linear write over the old value
							TimeData[1][#TimeData[1]] = Time - FilterMiddle
							TimeData[2][#TimeData[2]] = NewEntry
						end
					elseif v.TimeNeedZero and v.TimeNeedZero[k] then -- Check if we need a trailing zero
						TimeData[1][#TimeData[1] + 1] = Time - FilterMiddle
						TimeData[2][#TimeData[2] + 1 ] = 0
						v.TimeNeedZero = v.TimeNeedZero or {}
						v.TimeNeedZero[k] = false
					end
				end
			end
			local idler = v.type == "Unknown" or v.enClass == "UNKNOWN" or (not filters.Data[v.type] and not filters.Show[v.type])
			v.LastActive = v.LastActive or Time
			if idler and Time - v.LastActive > 30 then
				Recount:DeleteCombatant(name)
				Recount:DPrint("Deleted: "..name)
				gotdeleted = true
			--[[elseif idler then
				Recount:Print(name.."t: "..(Time-v.LastActive))]]
			end
			--[[if name == Recount.Player and not v.inGroup then
				Recount:GroupCheck()
				--if not v.inGroup then
				--Recount:DPrint("Yikes, can't get player into group status!")
				--end
			end]]
		end
		if gotdeleted then
			Recount:SetMainWindowMode(Recount.db.profile.MainWindowMode)
			Recount:FullRefreshMainWindow()
		end
		if Recount.db.profile.AutoDelete and math_fmod(Time, 10) == 0 then
			Recount:DeleteOldTimeData(Time)
		end
	end
end

function Recount:PutInCombat()
	Recount.InCombat = true
	Recount.InCombatT = Recount.CurTime
	Recount.InCombatT2 = GetTime()
	Recount.InCombatF = date("%H:%M:%S")
	Recount.FightingWho = ""
	Recount.FightingLevel = 0
	if Recount.db.profile.MainWindow.AutoHide then
		Recount.MainWindow:Hide()
	end
	if Recount.db.profile.CurDataSet == "LastFightData" then
		Recount.db.profile.CurDataSet = "CurrentFightData"
	end
	-- If current mode is not overall data we need to reset disp table
	if Recount.db.profile.CurDataSet == "CurrentFightData" then -- Elsia: Fix for double entry in CurAndLast mode
		Recount.MainWindow.DispTableSorted = Recount:GetTable()
		Recount.MainWindow.DispTableLookup = Recount:GetTable()
	end

	if RecountDeathTrack then
		RecountDeathTrack:SetFight(Recount.db.profile.CurDataSet)
	end
end

function Recount:CheckCombat(Time)
	if Recount:CheckPartyCombatWithPets() then
		if Recount.db.profile.EnableSync then
			Recount:CheckVisible()
		end
	else
		Recount:LeaveCombat(Time)
	end
end

-- Moved into a seperate function
function Recount:LeaveCombat(Time)
	if Recount.db.profile.MainWindow.AutoHide then
		Recount.RefreshMainWindow()
		Recount.MainWindow:Show()
	end
	-- Did we actually fight someone?
	Recount.InCombat = false
	if (Recount.FightingWho == "") then
		return
	end
	-- Elsia: Only sync for actual fights
	if Recount.db.profile.GlobalDataCollect and Recount.CurrentDataCollect and Recount.db.profile.EnableSync then -- Elsia: Only sync if collecting
		Recount:BroadcastLazySync()
	end
	if abs(Time - Recount.InCombatT) > 3 then
		Recount.db2.CombatTimes[#Recount.db2.CombatTimes + 1] = {Recount.InCombatT, Time, Recount.InCombatF, date("%H:%M:%S"),Recount.FightingWho}
		-- Save current data as the last fight
		Recount.Fights:MoveFights()
		if Recount.db.profile.CurDataSet == "CurrentFightData" then
			Recount.db.profile.CurDataSet = "LastFightData"
		end
		-- If current mode is not overall data we need to reset disp table
		if Recount.db.profile.CurDataSet ~= "OverallData" then
			Recount.MainWindow.DispTableSorted = Recount:GetTable()
			Recount.MainWindow.DispTableLookup = Recount:GetTable()
		end
		Recount.db2.FightNum = Recount.db2.FightNum + 1
	else
		Recount.Fights:CopyCurrentFights()
	end
end

function Recount:DeleteOldTimeData(Time)
	local DeleteTime = Time - 60 * Recount.db.profile.AutoDeleteTime
	for name, v in pairs(dbCombatants) do
		if v.TimeData then
			for _, Check in pairs(v.TimeData) do
				while Check[1][1] and Check[1][1] < DeleteTime do
					tremove(Check[1],1)
					tremove(Check[2],1)
				end
			end
		end
	end
	local Fights = Recount.db2.CombatTimes
	while Fights[1] and Fights[1][2] < DeleteTime do
		tremove(Fights, 1)
	end
end

function Recount:FixLastTime()
	local Time = GetTime()
	for name, v in pairs(dbCombatants) do
		v.LastAbility = Time
	end
end

function Recount:DelayedResizeWindows()
	Recount:ResizeMainWindow()
	--DelayedResizeWindows = nil
end

function Recount:HandleProfileChanges()
	if not Recount.MainWindow then
		return
	end
	Recount:SetBarTextures(Recount.db.profile.BarTexture)
	Recount:RestoreMainWindowPosition(Recount.db.profile.MainWindow.Position.x, Recount.db.profile.MainWindow.Position.y, Recount.db.profile.MainWindow.Position.w, Recount.db.profile.MainWindow.Position.h)
	Recount:ResizeMainWindow()
	Recount:FullRefreshMainWindow()
	Recount:SetupMainWindowButtons()
	if Recount.db.profile.GraphWindow then
		Recount.GraphWindow:ClearAllPoints()
		Recount.GraphWindow:SetPoint("TOPLEFT",UIParent,"TOPLEFT",Recount.db.profile.GraphWindowX, Recount.db.profile.GraphWindowY)
	end
	if Recount.db.profile.DetailWindow then
		Recount.DetailWindow:ClearAllPoints()
		Recount.DetailWindow:SetPoint("TOPLEFT",UIParent,"TOPLEFT",Recount.db.profile.DetailWindowX, Recount.db.profile.DetailWindowY)
	end
	Recount.profilechange = true
	Recount:CloseAllRealtimeWindows()
	if Recount.db.profile.RealtimeWindows then
		local Windows = Recount.db.profile.RealtimeWindows
		for k, v in pairs(Windows) do
			if v[8] and v[8] == true then -- Elsia: Make sure to respect closed windows as closed on startup
				Recount:CreateRealtimeWindowSized(v[1], v[2], v[3], v[4], v[5], v[6], v[7])
			end
		end
	end
	if not Recount.db.profile.CurDataSet then
		Recount.db.profile.CurDataSet = "OverallData"
	end
	Recount.Colors:UpdateAllColors()
	Recount.profilechange = nil
	Recount:ShowConfig()
	Recount:SetStrataAndClamp()
	Recount:LockWindows(Recount.db.profile.Locked)
end

function Recount:InitCombatData()
	Recount.db2.combatants = Recount.db2.combatants or { }
	Recount.db2.CombatTimes = Recount.db2.CombatTimes or { }
	Recount.db2.FoughtWho = Recount.db2.FoughtWho or { }
end

function Recount.LocalizeCombatants()
	dbCombatants = Recount.db2.combatants
end

function Recount:OnInitialize()
	local acedb = LibStub:GetLibrary("AceDB-3.0")
	Recount.db = acedb:New("RecountDB", Default_Profile)
	--Recount.db2 = acedb:New("RecountPerCharDB", DefaultConfig)
	RecountPerCharDB = RecountPerCharDB or { }
	Recount.db2 = RecountPerCharDB
	Recount.db2.char = nil -- Elsia: Dump old db data hard.
	Recount.db2.global = nil
	Recount:InitCombatData()
	Recount.LocalizeCombatants()
	self.db.RegisterCallback( self, "OnNewProfile", "HandleProfileChanges" )
	self.db.RegisterCallback( self, "OnProfileReset", "HandleProfileChanges" )
	self.db.RegisterCallback( self, "OnProfileChanged", "HandleProfileChanges" )
	self.db.RegisterCallback( self, "OnProfileCopied", "HandleProfileChanges" )
	Recount.consoleOptions2.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(Recount.db)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Recount", Recount.consoleOptions2, "recount")
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("Recount Report", Recount.consoleOptions2.args.report)
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("Recount Realtime", Recount.consoleOptions2.args.realtime)
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("Recount Blizz", Recount.consoleOptions)
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("Recount Profile", Recount.consoleOptions2.args.profile)
	AceConfigDialog:AddToBlizOptions("Recount Blizz", "Recount")
	AceConfigDialog:AddToBlizOptions("Recount Profile", "Profile", "Recount")
	AceConfigDialog:AddToBlizOptions("Recount Report", "Report", "Recount")
	AceConfigDialog:AddToBlizOptions("Recount Realtime", "Realtime", "Recount")
	if Recount.db2["version"] ~= DataVersion then
		Recount:ResetData()
		Recount.db2.version = DataVersion
	end
	RecountTempTooltip = CreateFrame("GameTooltip", "RecountTempTooltip", nil, "GameTooltipTemplate")
	RecountTempTooltip:SetOwner(UIParent, "ANCHOR_NONE")
	Recount.TimeStep = 1
	Recount.InCombat = false
	Recount.db.profile.CurDataSet = Recount.db.profile.CurDataSet or "OverallData"
	if Recount.db.profile.CurDataSet == "CurrentFightData" then
		Recount.db.profile.CurDataSet = "LastFightData"
	end
	Recount.FightingLevel = 0
	Recount.CurTime = GetTime()
	Recount.CurrentDataCollect = true
	Recount:CreateMainWindow()
	Recount:CreateDetailWindow()
	Recount:CreateGraphWindow()
	Recount:CreateFilterWeights()
	Recount:InitOrder()
	Recount:SetupMainWindow()
	Recount:ScheduleTimer("DelayedResizeWindows",0.1)
	SM.RegisterCallback(Recount, "LibSharedMedia_Registered", "UpdateBarTextures")
	SM.RegisterCallback(Recount, "LibSharedMedia_SetGlobal", "UpdateBarTextures")
	if Recount.db.profile.BarTexture then
		Recount:SetBarTextures(Recount.db.profile.BarTexture)
	end
	if Recount.db.profile.GraphWindowX then
		Recount.GraphWindow:ClearAllPoints()
		Recount.GraphWindow:SetPoint("TOPLEFT",UIParent,"TOPLEFT",Recount.db.profile.GraphWindowX, Recount.db.profile.GraphWindowY)
	end
	if Recount.db.profile.DetailWindowX then
		Recount.DetailWindow:ClearAllPoints()
		Recount.DetailWindow:SetPoint("TOPLEFT",UIParent,"TOPLEFT",Recount.db.profile.DetailWindowX, Recount.db.profile.DetailWindowY)
	end
	if Recount.db.profile.RealtimeWindows then
		local Windows = Recount.db.profile.RealtimeWindows
		for k, v in pairs(Windows) do
			if v[8] and v[8] == true then -- Elsia: Make sure to respect closed windows as closed on startup
				Recount:CreateRealtimeWindowSized(v[1], v[2], v[3], v[4], v[5], v[6], v[7])
			end
		end
	end
	Recount.PlayerName = UnitName("player")
	Recount.PlayerGUID = nil
	Recount.PlayerLevel = UnitLevel("player")
	Recount:PreloadConfig() -- To avoid script running too long problems when using config in combat. Unfortunately increases memory footprint, blame blizz if you must.
	--Recount.GuardiansGUIDs = { } -- No need to db, guardians are not persistent GUIDs
	--Recount.LatestGuardian = 0
	Recount.EventNum = { }
	Recount.EventNum["DAMAGE"] = { }
	Recount.EventNum["HEALING"] = { }
	if Recount.db.profile.EnableSync then
		Recount:ConfigComm()
	end
	Recount:FixLastTime()
	--Recount:ScaleWindows(Recount.db.profile.Scaling, true)
	Recount:ScaleWindows(Recount.db.profile.Scaling) -- Elsia: Bug: Even for first time we need in place code for scaling.
	Recount:SetStrataAndClamp()
	Recount:LockWindows(Recount.db.profile.Locked)
end

function Recount:OnEnable()
	Recount:IsTimeDataActive() -- Make sure we don't tick time data if we don't have to.
	Recount.TimeTick() -- Elsia: Prevent that time data is not initialized when an event comes in before the first tick.
	Recount:ScheduleTimer("GroupCheck", 2) -- Elsia: Lowered this and synced duration with party based collection check
	Recount:ScheduleRepeatingTimer("TimeTick", 1)
	--Recount.events:RegisterEvent("Threat_Activate") -- Elsia: Threat-1.0 deactivated until Threat-2.0 is ready.
	--Recount.events:RegisterEvent("Threat_Deactivate")
	--Recount.events:RegisterEvent("UNIT_PET")
	--Recount.events:RegisterEvent("PLAYER_PET_CHANGED")
	Recount.events:RegisterEvent("ZONE_CHANGED_NEW_AREA") -- Elsia: This is needed for zone change deletion and collection
	Recount.events:RegisterEvent("PLAYER_ENTERING_WORLD") -- Attempt to fix Onyxia instance entrance which isn't a new zone.
	Recount.events:RegisterEvent("PET_BATTLE_OPENING_START")
	Recount.events:RegisterEvent("PET_BATTLE_CLOSE")
	Recount:DetectInstanceChange() -- Elsia: We need to do this regardless for Zone filtering.
	--if Recount.db.profile.DeleteJoinRaid or Recount.db.profile.DeleteJoinGroup then
	Recount:ScheduleTimer("InitPartyBasedDeletion", 2) -- Elsia: Wait 2 seconds before enabling auto-delete to prevent startup popups.
	--end -- Elsia: This is obsolete due to deletion code also handling visibility and solo collection checks.
	-- Parser Events
	Recount.events:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	Recount.events:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
	if RecountDeathTrack then
		RecountDeathTrack:SetFight(Recount.db.profile.CurDataSet)
	end
	Recount.HasEnabled = true
end

function Recount:PetBattleUpdate()
	if Recount.db.profile.HidePetBattle and C_PetBattles.IsInBattle() and Recount.MainWindow:IsShown() then
		Recount.MainWindow:Hide()

		Recount.MainWindow.wasHidden = true
	else
		if Recount.db.profile.HidePetBattle and not Recount.MainWindow:IsShown() and Recount.MainWindow.wasHidden then
			Recount.MainWindow:Show()

			Recount.MainWindow.wasHidden = nil
		end
	end

	Recount:RefreshMainWindow()
end

function Recount:OnDisable()
	if not Recount.HasEnabled then
		return
	end
	Recount.HasEnabled = false
	Recount:UnregisterAllEvents()
end

function Recount:Threat_Activate()
	Recount.ThreatActive = true
end

function Recount:Threat_Deactivate()
	Recount.ThreatActive = false
end

local Tables = { }
function Recount:FreeTable(t)
	if type(t) ~= "table" then
		return
	end
	for k in pairs(t) do
		t[k] = nil
	end
	for _, v in pairs(Tables) do
		if v == t then
			return
		end
	end
	tinsert(Tables, t)
end

function Recount:FreeTableRecurse(t)
	-- Check the table first before recursing
	for _, v in pairs(Tables) do
		if v == t then
			return
		end
	end
	for k in pairs(t) do
		if type(t[k]) == "table" then
			Recount:FreeTableRecurse(t[k])
		end
		t[k] = nil
	end
	tinsert(Tables, t)
end

function Recount:FreeTableRecurseLimit(t, depth)
	-- Check the table first before recursing
	if depth < 0 then
		return
	end
	for k in pairs(t) do
		if type(t[k]) == "table" then
			Recount:FreeTableRecurseLimit(t[k], depth - 1)
		end
		t[k] = nil
	end
	tinsert(Tables, t)
end

function Recount:GetTable()
	local t
	if #Tables > 0 then
		t = Tables[1]
		tremove(Tables, 1)
		if #t > 0 then
			Recount:Print("WARNING! For some reason there is "..#t.." entries left. There is probably a table in use that shouldn't have been freed")
		end
		return t
	else
		return { }
	end
end

function Recount:ResetTableCache()
	Tables = Recount:GetTable()
end

function Recount:ResetPositions()
	Recount:ResetPositionAllWindows()
end

--[[local TestPie
local Amount = 0
function Recount:TestPie()
	TestPie:ResetPie()
	TestPie:AddPie(Amount,{0.0, 1.0, 0.0})
	TestPie:CompletePie({0.2, 0.2, 1.0})

	Amount = Amount + 1
	if Amount >= 100 then
		Amount = 1
	end
end

local function TestPieChart()
	local Graph = LibStub:GetLibrary("LibGraph-2.0")
	local g = Graph:CreateGraphPieChart("TestPieChart", UIParent, "LEFT", "LEFT", 0, 0, 150, 150)
	TestPie = g
	g:AddPie(35, {1.0, 0.0, 0.0})
	g:AddPie(21, {0.0, 1.0, 0.0})
	g:CompletePie({0.2, 0.2, 1.0})
	Recount:ScheduleRepeatingTimer("PieTest", Recount.TestPie, 0)
end]]
