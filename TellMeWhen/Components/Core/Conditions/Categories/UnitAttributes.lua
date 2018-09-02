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

local _, pclass = UnitClass("Player")

local CNDT = TMW.CNDT
local Env = CNDT.Env


local ConditionCategory = CNDT:GetCategory("ATTRIBUTES_UNIT", 3, L["CNDTCAT_ATTRIBUTES_UNIT"], false, false)





ConditionCategory:RegisterCondition(1,    "EXISTS", {
	text = L["CONDITIONPANEL_EXISTS"],

	bool = true,
	
	icon = "Interface\\Icons\\ABILITY_SEAL",
	tcoords = CNDT.COMMON.standardtcoords,
	defaultUnit = "target",
	Env = {
		UnitExists = UnitExists,
	},
	funcstr = function(c)
		if c.Unit == "player" then
			return [[true]]
		else
			return [[BOOLCHECK( UnitExists(c.Unit) )]]
		end
	end,
	events = function(ConditionObject, c)
		--if c.Unit == "mouseover" then
			-- THERE IS NO EVENT FOR WHEN YOU ARE NO LONGER MOUSING OVER A UNIT, SO WE CANT USE THIS
			
		--	return "UPDATE_MOUSEOVER_UNIT"
		--else
			return
				ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit)) -- this should work
		--end
	end,
})

ConditionCategory:RegisterCondition(2,    "ALIVE", {
	text = L["CONDITIONPANEL_ALIVE"],
	tooltip = L["CONDITIONPANEL_ALIVE_DESC"],

	bool = true,
	
	icon = "Interface\\Icons\\Ability_Vanish",
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		UnitIsDeadOrGhost = UnitIsDeadOrGhost,
	},
	funcstr = [[not BOOLCHECK( UnitIsDeadOrGhost(c.Unit) )]], 
	events = function(ConditionObject, c)
		return
			ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit)),
			ConditionObject:GenerateNormalEventString("UNIT_HEALTH", CNDT:GetUnit(c.Unit))
	end,
})

ConditionCategory:RegisterCondition(3,    "COMBAT", {
	text = L["CONDITIONPANEL_COMBAT"],

	bool = true,
	
	icon = "Interface\\CharacterFrame\\UI-StateIcon",
	tcoords = {0.53, 0.92, 0.05, 0.42},
	Env = {
		UnitAffectingCombat = UnitAffectingCombat,
	},
	funcstr = [[BOOLCHECK( UnitAffectingCombat(c.Unit) )]],
	events = function(ConditionObject, c)
		if c.Unit == "player" then
			return
				ConditionObject:GenerateNormalEventString("PLAYER_REGEN_ENABLED"),
				ConditionObject:GenerateNormalEventString("PLAYER_REGEN_DISABLED")
		else
			return
				ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit)),
				ConditionObject:GenerateNormalEventString("UNIT_FLAGS", CNDT:GetUnit(c.Unit))
		end
	end,
})

ConditionCategory:RegisterCondition(4,    "VEHICLE", {
	text = L["CONDITIONPANEL_VEHICLE"],

	bool = true,
	
	icon = "Interface\\Icons\\Ability_Vehicle_SiegeEngineCharge",
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		UnitHasVehicleUI = UnitHasVehicleUI,
	},
	funcstr = [[BOOLCHECK( UnitHasVehicleUI(c.Unit) )]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit)),
			ConditionObject:GenerateNormalEventString("UNIT_ENTERED_VEHICLE", CNDT:GetUnit(c.Unit)),
			ConditionObject:GenerateNormalEventString("UNIT_EXITED_VEHICLE", CNDT:GetUnit(c.Unit))
	end,
})

ConditionCategory:RegisterCondition(5,    "PVPFLAG", {
	text = L["CONDITIONPANEL_PVPFLAG"],

	bool = true,
	
	icon = "Interface\\TargetingFrame\\UI-PVP-" .. UnitFactionGroup("player"),
	tcoords = {0.046875, 0.609375, 0.015625, 0.59375},
	Env = {
		UnitIsPVP = UnitIsPVP,
	},
	funcstr = [[BOOLCHECK( UnitIsPVP(c.Unit) )]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit)),
			ConditionObject:GenerateNormalEventString("UNIT_FACTION", CNDT:GetUnit(c.Unit))
	end,
})

ConditionCategory:RegisterCondition(6,    "REACT", {
	text = L["ICONMENU_REACT"],
	min = 1,
	max = 2,
	levelChecks = true,
	defaultUnit = "target",
	texttable = {[1] = L["ICONMENU_HOSTILE"], [2] = L["ICONMENU_FRIEND"]},
	nooperator = true,
	icon = "Interface\\Icons\\Warrior_talent_icon_FuryInTheBlood",
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		UnitIsEnemy = UnitIsEnemy,
		UnitReaction = UnitReaction,
	},
	funcstr = [[(((UnitIsEnemy("player", c.Unit) or ((UnitReaction("player", c.Unit) or 5) <= 4)) and 1) or 2) == c.Level]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit)),
			ConditionObject:GenerateNormalEventString("UNIT_FLAGS", CNDT:GetUnit(c.Unit)),
			ConditionObject:GenerateNormalEventString("UNIT_FLAGS", "player")
	end,
})

ConditionCategory:RegisterCondition(6.2,  "ISPLAYER", {
	text = L["ICONMENU_ISPLAYER"],

	bool = true,
	defaultUnit = "target",
	
	icon = "Interface\\Icons\\INV_Misc_Head_Human_02",
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		UnitIsPlayer = UnitIsPlayer,
	},
	funcstr = [[BOOLCHECK( UnitIsPlayer(c.Unit) )]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit))
	end,
})

ConditionCategory:RegisterCondition(6.7,  "INCHEALS", {
	text = L["INCHEALS"],
	tooltip = L["INCHEALS_DESC"],
	range = 50000,
	icon = "Interface\\Icons\\spell_holy_flashheal",
	tcoords = CNDT.COMMON.standardtcoords,
	formatter = TMW.C.Formatter.COMMANUMBER,
	Env = {
		UnitGetIncomingHeals = UnitGetIncomingHeals,
	},
	funcstr = function(c)
		return [[(UnitGetIncomingHeals(c.Unit) or 0) c.Operator c.Level]]
	end,
	events = function(ConditionObject, c)
		return
			ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit)),
			ConditionObject:GenerateNormalEventString("UNIT_HEAL_PREDICTION", CNDT:GetUnit(c.Unit))
	end,
})



ConditionCategory:RegisterSpacer(6.9)



ConditionCategory:RegisterCondition(7,    "SPEED", {
	text = L["SPEED"],
	tooltip = L["SPEED_DESC"],
	min = 0,
	max = 500,
	percent = true,
	formatter = TMW.C.Formatter.PERCENT,
	icon = "Interface\\Icons\\ability_rogue_sprint",
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		GetUnitSpeed = GetUnitSpeed,
	},
	funcstr = [[GetUnitSpeed(c.Unit)/]].. BASE_MOVEMENT_SPEED ..[[ c.Operator c.Level]],
	-- events = absolutely no events
})

ConditionCategory:RegisterCondition(8,    "RUNSPEED", {
	text = L["RUNSPEED"],
	tooltip = L["RUNSPEED_DESC"],
	min = 0,
	max = 500,
	percent = true,
	formatter = TMW.C.Formatter.PERCENT,
	icon = "Interface\\Icons\\ability_rogue_sprint",
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		GetUnitSpeed = GetUnitSpeed,
	},
	funcstr = [[select(2, GetUnitSpeed(c.Unit))/]].. BASE_MOVEMENT_SPEED ..[[ c.Operator c.Level]],
	-- events = absolutely no events
})

ConditionCategory:RegisterCondition(8.5,  "LIBRANGECHECK", {
	text = L["CNDT_RANGE"],
	tooltip = L["CNDT_RANGE_DESC"],
	min = 0,
	max = 100,
	formatter = TMW.C.Formatter:New(function(val)
		local LRC = LibStub("LibRangeCheck-2.0")
		if not LRC then
			return val
		end

		if val == 0 then
			return L["CNDT_RANGE_PRECISE"]:format(val)
		end

		for range in LRC:GetHarmCheckers() do
			if range == val then
				return L["CNDT_RANGE_PRECISE"]:format(val)
			end
		end
		for range in LRC:GetFriendCheckers() do
			if range == val then
				return L["CNDT_RANGE_PRECISE"]:format(val)
			end
		end

		return L["CNDT_RANGE_IMPRECISE"]:format(val)
	end),

	icon = "Interface\\Icons\\ability_hunter_snipershot",
	tcoords = CNDT.COMMON.standardtcoords,

	specificOperators = {["<="] = true, [">="] = true},

	applyDefaults = function(conditionData, conditionSettings)
		local op = conditionSettings.Operator

		if not conditionData.specificOperators[op] then
			conditionSettings.Operator = "<="
		end
	end,

	funcstr = function(c, parent)
		Env.LibRangeCheck = LibStub("LibRangeCheck-2.0")
		if not Env.LibRangeCheck then
			TMW:Error("The %s condition requires LibRangeCheck-2.0", L["CNDT_RANGE"])
			return "false"
		end

		if c.Operator == "<=" then
			return [[(select(2, LibRangeCheck:GetRange(c.Unit)) or huge) c.Operator c.Level]]
		elseif c.Operator == ">=" then
			return [[(LibRangeCheck:GetRange(c.Unit) or 0) c.Operator c.Level]]
		else
			TMW:Error("Bad operator %q for range check condition of %s", c.Operator, tostring(parent))
		end
	end,
	-- events = absolutely no events
})



ConditionCategory:RegisterSpacer(8.9)



ConditionCategory:RegisterCondition(8.95, "UNITISUNIT", {
	text = L["CONDITIONPANEL_UNITISUNIT"],
	tooltip = L["CONDITIONPANEL_UNITISUNIT_DESC"],

	bool = true,
	
	name = function(editbox)
		editbox:SetTexts(L["UNITTWO"], L["CONDITIONPANEL_UNITISUNIT_EBDESC"])
	end,
	useSUG = "units",
	icon = "Interface\\Icons\\spell_holy_prayerofhealing",
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		UnitIsUnit = UnitIsUnit,
	},
	funcstr = [[BOOLCHECK( UnitIsUnit(c.Unit, c.Unit2) )]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit)),
			ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Name))
	end,
})

ConditionCategory:RegisterCondition(9,    "NAME", {
	text = L["CONDITIONPANEL_NAME"],

	bool = true,
	
	name = function(editbox)
		editbox:SetTexts(L["CONDITIONPANEL_NAMETOMATCH"], L["CONDITIONPANEL_NAMETOOLTIP"])
	end,
	icon = "Interface\\LFGFrame\\LFGFrame-SearchIcon-Background",
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		UnitName = UnitName,
	},
	funcstr = [[BOOLCHECK(MULTINAMECHECK(  UnitName(c.Unit) or ""  ))]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit)),
			ConditionObject:GenerateNormalEventString("UNIT_NAME_UPDATE", CNDT:GetUnit(c.Unit))
	end,
})

ConditionCategory:RegisterCondition(9.5,  "NPCID", {
	text = L["CONDITIONPANEL_NPCID"],
	tooltip = L["CONDITIONPANEL_NPCID_DESC"],

	bool = true,
	
	defaultUnit = "target",
	name = function(editbox)
		editbox:SetTexts(L["CONDITIONPANEL_NPCIDTOMATCH"], L["CONDITIONPANEL_NPCIDTOOLTIP"])
	end,
	icon = "Interface\\LFGFrame\\LFGFrame-SearchIcon-Background",
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		UnitGUID = UnitGUID,
	},
	funcstr = [[BOOLCHECK(MULTINAMECHECK(  tonumber((UnitGUID(c.Unit) or ""):match(".-%-%d+%-%d+%-%d+%-%d+%-(%d+)")) ))]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit))
	end,
})

ConditionCategory:RegisterCondition(10,   "LEVEL", {
	text = L["CONDITIONPANEL_LEVEL"],
	min = -1,
	max = GetMaxPlayerLevel() + 3,
	texttable = function(i)
		if i == -1 then
			return BOSS
		end
		return i
	end,
	icon = "Interface\\TargetingFrame\\UI-TargetingFrame-Skull",
	tcoords = {0.05, 0.95, 0.03, 0.97},
	Env = {
		UnitLevel = UnitLevel,
	},
	funcstr = [[UnitLevel(c.Unit) c.Operator c.Level]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit)),
			ConditionObject:GenerateNormalEventString("UNIT_LEVEL", CNDT:GetUnit(c.Unit))
	end,
})

TMW:RegisterUpgrade(73019, {
	condition = function(self, condition)
		if condition.Type == "RAIDICON" then
			condition.Type = "RAIDICON2"
			condition.Checked = false
			CNDT:ConvertSliderCondition(condition, 0, 8)
		end
	end,
})
ConditionCategory:RegisterCondition(10.1,  "RAIDICON2", {
	text = L["CONDITIONPANEL_RAIDICON"],
	tooltip = L["CONDITIONPANEL_RAIDICON_DESC"],

	bitFlagTitle = L["CONDITIONPANEL_BITFLAGS_CHOOSEMENU_RAIDICON"],
	bitFlags = (function()
		local t = {[0]={
			order = 0,
			text = NONE,
		}}

		for i = 1, 8 do  -- Dont use NUM_RAID_ICONS since it is defined in Blizzard's CRF manager addon, which might not be loaded
			t[i] = {
				order = i,
				text = _G["RAID_TARGET_"..i],
				icon = "Interface/TargetingFrame/UI-RaidTargetingIcon_" .. i
			}
		end

		return t
	end)(),

	icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_8",

	Env = {
		GetRaidTargetIndex = GetRaidTargetIndex,
	},
	funcstr = [[ BITFLAGSMAPANDCHECK( GetRaidTargetIndex(c.Unit) or 0 ) ]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit)),
			ConditionObject:GenerateNormalEventString("RAID_TARGET_UPDATE")
	end,
})


TMW:RegisterUpgrade(73019, {
	unitClassifications = {
		"normal",
		"rare",
		"elite",
		"rareelite",
		"worldboss",
	},
	condition = function(self, condition)
		if condition.Type == "CLASSIFICATION" then
			condition.Type = "CLASSIFICATION2"
			condition.Checked = false
			CNDT:ConvertSliderCondition(condition, 1, #self.unitClassifications, self.unitClassifications)
		end
	end,
})
ConditionCategory:RegisterCondition(12.1, "CLASSIFICATION2", {
	text = L["CONDITIONPANEL_CLASSIFICATION"],
	tooltip = L["CONDITIONPANEL_CLASSIFICATION_DESC"],

	bitFlagTitle = L["CONDITIONPANEL_BITFLAGS_CHOOSEMENU_TYPES"],
	bitFlags = {
		normal    = {order = 1, text = L["normal"]},
		minus     = {order = 2, text = L["minus"]},
		rare      = {order = 3, text = L["rare"]},
		elite     = {order = 4, text = L["elite"]},
		rareelite = {order = 5, text = L["rareelite"]},
		worldboss = {order = 6, text = L["worldboss"]},
	},

	defaultUnit = "target",

	icon = "Interface\\Icons\\achievement_pvp_h_03",
	tcoords = CNDT.COMMON.standardtcoords,

	Env = {
		UnitClassification = UnitClassification,
	},
	funcstr = [[BITFLAGSMAPANDCHECK( UnitClassification(c.Unit) or "" )]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit)),
			ConditionObject:GenerateNormalEventString("UNIT_CLASSIFICATION_CHANGED", CNDT:GetUnit(c.Unit))
	end,
})

ConditionCategory:RegisterCondition(13,   "CREATURETYPE", {
	text = L["CONDITIONPANEL_CREATURETYPE"],

	bool = true,
	
	defaultUnit = "target",
	name = function(editbox)
		editbox:SetTexts(L["CONDITIONPANEL_CREATURETYPE_LABEL"], L["CONDITIONPANEL_CREATURETYPE_DESC"])
	end,
	useSUG = "creaturetype",
	allowMultipleSUGEntires = true,
	icon = "Interface\\Icons\\spell_shadow_summonfelhunter",
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		UnitCreatureType = UnitCreatureType,
	},
	funcstr = [[BOOLCHECK(MULTINAMECHECK(  UnitCreatureType(c.Unit) or ""  ))]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit))
	end,
})


ConditionCategory:RegisterCondition(13.1,   "UNITRACE", {
	text = L["CONDITIONPANEL_UNITRACE"],

	bitFlagTitle = L["CONDITIONPANEL_BITFLAGS_CHOOSERACE"],
	bitFlags = (function()
		local LBRace = LibStub("LibBabble-Race-3.0")
		local lookup = LBRace:GetBaseLookupTable()
		local function Name(name)
			-- Look up the race name without throwing LibBabble errors.
			if not lookup[name] then
				TMW:Debug("Missing LibBabble-Race-3.0 phrase for: " .. name)
				return name
			end
			return lookup[name]
		end
		local bitFlags = {
			["Human"] = {order = 1, text = Name("Human")},
			["Dwarf"] = {order = 2, text = Name("Dwarf")},
			["NightElf"] = {order = 3, text = Name("Night Elf")},
			["Gnome"] = {order = 4, text = Name("Gnome")},
			["Draenei"] = {order = 5, text = Name("Draenei")},
			["Worgen"] = {order = 6, text = Name("Worgen")},

			["VoidElf"] = {order = 6.1, text = Name("Void Elf")},
			["LightforgedDraenei"] = {order = 6.2, text = Name("Lightforged Draenei")},
			["DarkIronDwarf"] = {order = 6.3, text = Name("Dark Iron Dwarf"), space = true},

			["Orc"] = {order = 7, text = Name("Orc")},
			["Scourge"] = {order = 8, text = Name("Undead")},
			["Tauren"] = {order = 9, text = Name("Tauren")},
			["Troll"] = {order = 10, text = Name("Troll")},
			["BloodElf"] = {order = 11, text = Name("Blood Elf")},
			["Goblin"] = {order = 12, text = Name("Goblin")},

			["Nightborne"] = {order = 12.1, text = Name("Nightborne")},
			["HighmountainTauren"] = {order = 12.2, text = Name("Highmountain Tauren"), space = true},
			["MagharOrc"] = {order = 12.3, text = Name("Mag'har Orc")},

			["Pandaren"] = {order = 13, text = Name("Pandaren")},

		}

		for token, data in pairs(bitFlags) do
			data.atlas = TMW:GetRaceIconInfo(token)
			data.tcoords = CNDT.COMMON.standardtcoords
		end

		return bitFlags
	end)(),


	atlas = TMW:GetRaceIconInfo(select(2, UnitRace("player"))),
	tcoords = CNDT.COMMON.standardtcoords,
	
	defaultUnit = "target",
	Env = {
		UnitRace = UnitRace,
	},
	funcstr = [[BITFLAGSMAPANDCHECK( select(2, UnitRace(c.Unit)) )]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit))
	end,
})



ConditionCategory:RegisterSpacer(13.5)



ConditionCategory:RegisterCondition(17,   "THREATSCALED", {
	text = L["CONDITIONPANEL_THREAT_SCALED"],
	tooltip = L["CONDITIONPANEL_THREAT_SCALED_DESC"],
	min = 0,
	max = 100,
	defaultUnit = "target",
	formatter = TMW.C.Formatter.PERCENT,
	icon = "Interface\\Icons\\spell_misc_emotionangry",
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		UnitExists = UnitExists,
		UnitDetailedThreatSituation = UnitDetailedThreatSituation,
	},
	funcstr = [[UnitExists(c.Unit) and ((select(3, UnitDetailedThreatSituation("player", c.Unit)) or 0) c.Operator c.Level)]],
	-- events = absolutely no events
})

ConditionCategory:RegisterCondition(18,   "THREATRAW", {
	text = L["CONDITIONPANEL_THREAT_RAW"],
	tooltip = L["CONDITIONPANEL_THREAT_RAW_DESC"],
	min = 0,
	max = 130,
	defaultUnit = "target",
	formatter = TMW.C.Formatter.PERCENT,
	icon = "Interface\\Icons\\spell_misc_emotionhappy",
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		UnitExists = UnitExists,
		UnitDetailedThreatSituation = UnitDetailedThreatSituation,
	},
	funcstr = [[UnitExists(c.Unit) and ((select(4, UnitDetailedThreatSituation("player", c.Unit)) or 0) c.Operator c.Level)]],
	-- events = absolutely no events
})
