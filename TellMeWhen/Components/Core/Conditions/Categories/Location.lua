-- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--		Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--		Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak
-- --------------------


if not TMW then return end

local TMW = TMW
local L = TMW.L
local print = TMW.print

local date = date

local CNDT = TMW.CNDT
local Env = CNDT.Env


local IsInInstance, GetInstanceDifficulty, GetInstanceInfo = 
	  IsInInstance, GetInstanceDifficulty, GetInstanceInfo


local ConditionCategory = CNDT:GetCategory("LOCATION", 1.5, L["CNDTCAT_LOCATION"], false, true)





TMW:RegisterUpgrade(73019, {
	condition = function(self, condition)
		if condition.Type == "INSTANCE" then
			condition.Type = "INSTANCE2"
			condition.Checked = false
			-- We give a metatable to add one to the indexes because the indexes did shift +1 from the old to the new condition.
			CNDT:ConvertSliderCondition(condition, 0, 11, setmetatable({}, {__index=function(s,k) return k+1 end}))
		end
	end,
})
local actuallyOutsideMapIDs = {
	[1116] = true,	-- 	Draenor (gets reported as an instance if you were in your garrison and left)

	[1152] = true,	-- 	FW Horde Garrison Level 1
	[1330] = true,	-- 	FW Horde Garrison Level 2
	[1153] = true,	-- 	FW Horde Garrison Level 3
	[1154] = true,	-- 	FW Horde Garrison Level 4
	[1158] = true,	-- 	SMV Alliance Garrison Level 1
	[1331] = true,	-- 	SMV Alliance Garrison Level 2
	[1159] = true,	-- 	SMV Alliance Garrison Level 3
	[1160] = true,	-- 	SMV Alliance Garrison Level 4
}
ConditionCategory:RegisterCondition(1,	 "INSTANCE2", {
	text = L["CONDITIONPANEL_INSTANCETYPE"],
	tooltip = L["CONDITIONPANEL_INSTANCETYPE_DESC"],

	unit = false,
	bitFlagTitle = L["CONDITIONPANEL_BITFLAGS_CHOOSEMENU_TYPES"],
	bitFlags = {
		[01] = {order=01, text=L["CONDITIONPANEL_INSTANCETYPE_NONE"],                                space=true,   }, -- None (Outside)
		[02] = {order=02, text=BATTLEGROUND,                                                                       }, -- Battleground
		[03] = {order=03, text=ARENA,                                                                space=true,   }, -- Arena


		[04] = {order=10, text=DUNGEON_DIFFICULTY_5PLAYER,                                                         }, -- 5-player
		[05] = {order=11, text=DUNGEON_DIFFICULTY_5PLAYER_HEROIC,                                                  }, -- 5-player Heroic
		[11] = {order=12, text=format("%s (%s)", DUNGEON_DIFFICULTY_5PLAYER, CHALLENGE_MODE),                      }, -- Challenge Mode 5-man
		[24] = {order=13, text=format("%s (%s)", DUNGEON_DIFFICULTY_5PLAYER, PLAYER_DIFFICULTY_TIMEWALKER or "TW"),}, -- Warlords 5-man Timewalker
		[23] = {order=14, text=format("%s (%s)", DUNGEON_DIFFICULTY_5PLAYER, PLAYER_DIFFICULTY6),    space=true,   }, -- Warlords 5-man Mythic


		[14] = {order=17, text=GUILD_CHALLENGE_TYPE4,                                                              }, -- Normal scenario
		[13] = {order=18, text=HEROIC_SCENARIO,                                                      space=true,   }, -- Heroic scenario


		[18] = {order=21, text=format("%s (%s)", PLAYER_DIFFICULTY3, FLEX_RAID),                                   }, -- Warlords LFR Flex
		[15] = {order=22, text=format("%s (%s)", PLAYER_DIFFICULTY1, FLEX_RAID),                                   }, -- Warlords Normal Flex
		[16] = {order=23, text=format("%s (%s)", PLAYER_DIFFICULTY2, FLEX_RAID),                                   }, -- Warlords Heroic Flex
		[17] = {order=24, text=PLAYER_DIFFICULTY6,                                                   space=true,   }, -- Warlords Mythic

		[10] = {order=31, text=L["CONDITIONPANEL_INSTANCETYPE_LEGACY"]:format(RAID_FINDER),                        }, -- LFR (legacy, non-flex)
		[06] = {order=32, text=L["CONDITIONPANEL_INSTANCETYPE_LEGACY"]:format(RAID_DIFFICULTY_10PLAYER),           }, -- 10-player raid (legacy)
		[07] = {order=33, text=L["CONDITIONPANEL_INSTANCETYPE_LEGACY"]:format(RAID_DIFFICULTY_25PLAYER),           }, -- 25-player raid (legacy)
		[08] = {order=34, text=L["CONDITIONPANEL_INSTANCETYPE_LEGACY"]:format(RAID_DIFFICULTY_10PLAYER_HEROIC),    }, -- 10-player heroic raid (legacy)
		[09] = {order=35, text=L["CONDITIONPANEL_INSTANCETYPE_LEGACY"]:format(RAID_DIFFICULTY_25PLAYER_HEROIC),    }, -- 25-player heroic raid (legacy)
		[12] = {order=36, text=L["CONDITIONPANEL_INSTANCETYPE_LEGACY"]:format(RAID_DIFFICULTY_40PLAYER),           }, -- 40-man raid (legacy)

	},

	icon = "Interface\\Icons\\Spell_Frost_Stun",
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		GetZoneType2 = function()
			local _, z = IsInInstance()			

			local _, _, instanceDifficulty, _, _, _, _, instanceMapID = GetInstanceInfo()

			-- Fix mapIDs that are really outside, but get reported wrong.
			if actuallyOutsideMapIDs[instanceMapID] then
				instanceDifficulty = 0
			end

			
			if z == "pvp" then
				-- Battleground           (__ -> 02)
				return 2
			elseif z == "arena" then
				-- Arena                  (__ -> 03)
				return 3
			elseif instanceDifficulty == 0 then
				-- None                   (__ -> 01)
				return 1
			else
				-- 5 man normal           (01 -> 04)
				-- 5 man heroic           (02 -> 05)
				-- 10 man normal          (03 -> 06)
				-- 25 man normal          (04 -> 07)
				-- 10 man heroic          (05 -> 08)
				-- 25 man heroic          (06 -> 09)
				-- LFR                    (07 -> 10)
				-- Challenge Mode         (08 -> 11)
				-- 40 man                 (09 -> 12)
				if instanceDifficulty <= 9 then
					return 3 + instanceDifficulty
				end

				-- heroic scenario        (11 -> 13)
				-- scenario               (12 -> 14)
				if instanceDifficulty <= 12 then
					return 2 + instanceDifficulty
				end

				-- Normal Flex            (14 -> 15)
				-- Heroic Flex            (15 -> 16)
				-- Mythic                 (16 -> 17)
				-- LFR Flex               (17 -> 18)
				if instanceDifficulty <= 17 then
					return 1 + instanceDifficulty
				end


				-- 40 man Event raid      (18 -> 12) (level 100 molten core, remap to 40 man raid)
				if instanceDifficulty == 18 then
					return 12
				end

				-- 5 man Event dungeon    (19 -> 04) (level 90 UBRS at WoD launch, remap to 5 man dungeon)
				if instanceDifficulty == 19 then
					return 4
				end

				-- Skip 19 so we can end this legacy silliness of keeping things sequential
				-- (A relic from the days when this condition was slider-based).

				-- 25 man Event scenario  (20 -> 20) (unused)
				-- Mythic 5 man           (23 -> 23)
				-- Timewalker 5 man       (24 -> 24)
				return instanceDifficulty
			end
		end,
	},
	funcstr = [[BITFLAGSMAPANDCHECK( GetZoneType2() )]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("ZONE_CHANGED_NEW_AREA"),
			ConditionObject:GenerateNormalEventString("PLAYER_DIFFICULTY_CHANGED")
	end,
})


ConditionCategory:RegisterCondition(1.1, "GROUPSIZE", {
	text = L["CONDITIONPANEL_GROUPSIZE"],
	tooltip = L["CONDITIONPANEL_GROUPSIZE_DESC"],
	min = 0,
	max = 40,
	unit = false,
	icon = "Interface\\Icons\\spell_deathknight_armyofthedead",
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		GetInstanceInfo = GetInstanceInfo,
	},
	funcstr = [[select(9, GetInstanceInfo()) c.Operator c.Level]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("INSTANCE_GROUP_SIZE_CHANGED"),
			ConditionObject:GenerateNormalEventString("UPDATE_INSTANCE_INFO")
	end,
})


ConditionCategory:RegisterCondition(1.5, "ZONEPVP", {
	text = L["CONDITIONPANEL_ZONEPVP"],
	tooltip = L["CONDITIONPANEL_ZONEPVP_DESC"],

	unit = false,
	bitFlagTitle = L["CONDITIONPANEL_BITFLAGS_CHOOSEMENU_TYPES"],
	bitFlags = {
	    none = 		{order=1, text=NONE,},
	    sanctuary = {order=2, text=SANCTUARY_TERRITORY:trim("()（）"),},
	    friendly = 	{order=3, text=FACTION_CONTROLLED_TERRITORY:format(FRIENDLY):trim("()（）"),},
	    contested = {order=4, text=CONTESTED_TERRITORY:trim("()（）"),},
	    hostile = 	{order=5, text=FACTION_CONTROLLED_TERRITORY:format(HOSTILE):trim("()（）"),},
	    combat = 	{order=6, text=COMBAT_ZONE:trim("()（）"),},
		-- Only use the TMW translation if it exists for arena (ffa):
	    arena = 	{order=7, text=rawget(L, "CONDITIONPANEL_ZONEPVP_FFA") or FREE_FOR_ALL_TERRITORY:trim("()（）"), },
	},

	icon = "Interface\\Icons\\inv_bannerpvp_01",
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		GetZonePVPInfo = GetZonePVPInfo,
	},
	funcstr = [[BITFLAGSMAPANDCHECK( GetZonePVPInfo() or "none" )]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("ZONE_CHANGED_NEW_AREA"),
			ConditionObject:GenerateNormalEventString("ZONE_CHANGED_INDOORS"),
			ConditionObject:GenerateNormalEventString("ZONE_CHANGED")
	end,
})


TMW:RegisterUpgrade(73019, {
	condition = function(self, condition)
		if condition.Type == "GROUP" then
			condition.Type = "GROUP2"
			condition.Checked = false
			-- We give a metatable to add one to the indexes because the indexes did shift +1 from the old to the new condition.
			CNDT:ConvertSliderCondition(condition, 0, 2, setmetatable({}, {__index=function(s,k) return k+1 end}))
		end
	end,
})
ConditionCategory:RegisterCondition(2,	 "GROUP2", {
	text = L["CONDITIONPANEL_GROUPTYPE"],
	tooltip = L["CONDITIONPANEL_GROUPTYPE_DESC"],

	unit = false,
	bitFlagTitle = L["CONDITIONPANEL_BITFLAGS_CHOOSEMENU_TYPES"],
	bitFlags = {
		[1] = SOLO,
		[2] = PARTY,
		[3] = RAID,
	},

	icon = "Interface\\Calendar\\MeetingIcon",
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		IsInRaid = IsInRaid,
		IsInGroup = IsInGroup,
	},
	funcstr = [[BITFLAGSMAPANDCHECK( ((IsInRaid() and 3) or (IsInGroup() and 2) or 1) )]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("GROUP_ROSTER_UPDATE")
	end,
})



ConditionCategory:RegisterSpacer(10)

--[[
	
]]

function CNDT:GetBitFlag(conditionSettings, index)
	if type(conditionSettings.BitFlags) == "table" then
		return conditionSettings.BitFlags[index]
	else
		local flag = bit.lshift(1, index-1)
		return bit.band(conditionSettings.BitFlags, flag) == flag
	end
end

TMW:RegisterUpgrade(85001, {
	flagConversions = {
		[1] = 12, -- kalimdor
		[2] = 13, -- ek
		[3] = 101, -- outland
		[4] = 113, -- northrend
		[5] = 948, -- maelstrom
		[6] = 424, -- panda
		[7] = 572, -- Draenor
		[8] = 619, -- broken
		[9] = 905, -- argus
	},
	condition = function(self, condition)
		if condition.Type == "LOC_CONTINENT" then
			local existing = { BitFlags = condition.BitFlags }
			condition.BitFlags = {}
			for old, new in pairs(self.flagConversions) do
				if CNDT:GetBitFlag(condition, old) then
					condition.BitFlags[new] = true
				end
			end
		end
	end,
})

ConditionCategory:RegisterCondition(13,   "LOC_CONTINENT", {
	text = L["CONDITIONPANEL_LOC_CONTINENT"],

	unit = false,
	bitFlagTitle = L["CONDITIONPANEL_BITFLAGS_CHOOSEMENU_CONTINENT"],
	bitFlags = (function()
		if GetContinentMaps then -- Pre-wow-80000
			local t = GetContinentMaps()
			for continentID in pairs(t) do
				t[continentID] = GetContinentName(continentID)
			end
			return t
		else -- post-wow-80000
			local t = {}
			-- 946 is the cosmic map ID.
			for id, mapInfo in pairs(C_Map.GetMapChildrenInfo(946, Enum.UIMapType.Continent, true)) do
				t[mapInfo.mapID] = mapInfo.name
			end
			return t
		end
	end)(),

	nooperator = true,
	icon = "Interface\\Icons\\inv_misc_map02",
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		GetCurrentMapContinent = _G.GetCurrentMapContinent or function()
			local mapID = C_Map.GetBestMapForUnit("player")
			if not mapID then return nil end
			local mapInfo = C_Map.GetMapInfo(mapID)
			while mapInfo do
				if mapInfo.mapType == Enum.UIMapType.Continent then
					return mapInfo.mapID
				end
				mapInfo = C_Map.GetMapInfo(mapInfo.parentMapID);
			end
			
			return nil
		end,
	},
	funcstr = [[BITFLAGSMAPANDCHECK( GetCurrentMapContinent() )]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("ZONE_CHANGED"),
			ConditionObject:GenerateNormalEventString("ZONE_CHANGED_NEW_AREA")
	end,
})

ConditionCategory:RegisterCondition(14,   "LOC_ZONE", {
	text = L["CONDITIONPANEL_LOC_ZONE"],

	bool = true,

	unit = false,
	name = function(editbox)
		editbox:SetTexts(L["CONDITIONPANEL_LOC_ZONE_LABEL"], L["CONDITIONPANEL_LOC_ZONE_DESC"])
	end,
	useSUG = "zone",
	allowMultipleSUGEntires = true,

	icon = "Interface\\Icons\\inv_misc_map09",
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		GetZoneText = GetZoneText,
	},
	funcstr = [[BOOLCHECK(MULTINAMECHECK(  GetZoneText()  ))]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("ZONE_CHANGED"),
			ConditionObject:GenerateNormalEventString("ZONE_CHANGED_NEW_AREA")
	end,
})

ConditionCategory:RegisterCondition(15,   "LOC_SUBZONE", {
	text = L["CONDITIONPANEL_LOC_SUBZONE"],
	tooltip = L["CONDITIONPANEL_LOC_SUBZONE_DESC"],

	bool = true,

	unit = false,
	name = function(editbox)
		editbox:SetTexts(L["CONDITIONPANEL_LOC_SUBZONE_LABEL"], L["CONDITIONPANEL_LOC_SUBZONE_BOXDESC"])
	end,
	useSUG = "subzone",
	allowMultipleSUGEntires = true,

	nooperator = true,
	icon = "Interface\\Icons\\inv_misc_map07",
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		GetSubZoneText = GetSubZoneText,
	},
	funcstr = [[BOOLCHECK(MULTINAMECHECK(  GetSubZoneText()  ))]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("ZONE_CHANGED"),
			ConditionObject:GenerateNormalEventString("ZONE_CHANGED_NEW_AREA")
	end,
})

local zoneTextCache = {[GetZoneText() or ""] = true}
local subZoneTextCache = {[GetZoneText() or ""] = true}
local function zoneCacher()
	zoneTextCache[GetZoneText() or ""] = true
	subZoneTextCache[GetSubZoneText() or ""] = true
end
CNDT:RegisterEvent("ZONE_CHANGED", zoneCacher)
CNDT:RegisterEvent("ZONE_CHANGED_NEW_AREA", zoneCacher)

TMW:RegisterCallback("TMW_OPTIONS_LOADED", function()
	local SUG = TMW.SUG

	local Module = SUG:NewModule("zoneBase", SUG:GetModule("default"))
	Module.noMin = true
	Module.noTexture = true
	Module.showColorHelp = false

	function Module:Table_GetNormalSuggestions(suggestions, tbl)
		local lastName = SUG.lastName

		for name in pairs(tbl) do
			if name ~= "" and strfind(strlower(name), lastName) then
				suggestions[#suggestions + 1] = name
			end
		end
	end
	function Module:Entry_AddToList_1(f, name)
		f.Name:SetText(name)
		f.tooltiptitle = name
		f.insert = name
	end


	local Module = SUG:NewModule("zone", SUG:GetModule("zoneBase"))
	function Module:Table_Get()
		return zoneTextCache
	end
	local Module = SUG:NewModule("subzone", SUG:GetModule("zoneBase"))
	function Module:Table_Get()
		return subZoneTextCache
	end
end)
