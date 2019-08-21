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

local CNDT = TMW.CNDT
local Env = CNDT.Env
local strlowerCache = TMW.strlowerCache

local _, pclass = UnitClass("Player")

local GetTalentInfo, GetNumTalents, GetGlyphLink, GetSpellInfo = 
      GetTalentInfo, GetNumTalents, GetGlyphLink, GetSpellInfo
local GetSpecializationInfo, GetNumSpecializationsForClassID, GetSpecializationInfoForClassID, GetNumClasses, GetClassInfo = 
      GetSpecializationInfo, GetNumSpecializationsForClassID, GetSpecializationInfoForClassID, GetNumClasses, GetClassInfo
local GetNumBattlefieldScores, RequestBattlefieldScoreData, GetBattlefieldScore, GetNumArenaOpponents, GetArenaOpponentSpec =
      GetNumBattlefieldScores, RequestBattlefieldScoreData, GetBattlefieldScore, GetNumArenaOpponents, GetArenaOpponentSpec

local ConditionCategory = CNDT:GetCategory("TALENTS", 1.4, L["CNDTCAT_TALENTS"], true, false)





local specNameToRole = {}
local SPECS = CNDT:NewModule("Specs", "AceEvent-3.0")
function SPECS:UpdateUnitSpecs()
	local _, z = IsInInstance()

	if next(Env.UnitSpecs) then
		wipe(Env.UnitSpecs)
		TMW:Fire("TMW_UNITSPEC_UPDATE")
	end

	if z == "arena" then
		for i = 1, GetNumArenaOpponents() do
			local unit = "arena" .. i

			local name, server = UnitName(unit)
			if name and name ~= UNKNOWN then
				local specID = GetArenaOpponentSpec(i)
				name = name .. (server and "-" .. server or "")
				Env.UnitSpecs[name] = specID
			end
		end

		TMW:Fire("TMW_UNITSPEC_UPDATE")

	elseif z == "pvp" then
		RequestBattlefieldScoreData()

		for i = 1, GetNumBattlefieldScores() do
			local name, _, _, _, _, _, _, _, classToken, _, _, _, _, _, _, talentSpec = GetBattlefieldScore(i)
			if name then
				local specID = specNameToRole[classToken][talentSpec]
				Env.UnitSpecs[name] = specID
			end
		end
		
		TMW:Fire("TMW_UNITSPEC_UPDATE")
	end
end
function SPECS:PrepareUnitSpecEvents()
	SPECS:RegisterEvent("UNIT_NAME_UPDATE",   "UpdateUnitSpecs")
	SPECS:RegisterEvent("ARENA_OPPONENT_UPDATE", "UpdateUnitSpecs")
	SPECS:RegisterEvent("GROUP_ROSTER_UPDATE", "UpdateUnitSpecs")
	SPECS:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateUnitSpecs")
	SPECS.PrepareUnitSpecEvents = TMW.NULLFUNC
end
ConditionCategory:RegisterCondition(0.1,  "UNITSPEC", {
	text = L["CONDITIONPANEL_UNITSPEC"],
	tooltip = L["CONDITIONPANEL_UNITSPEC_DESC"],

	bitFlagTitle = L["CONDITIONPANEL_UNITSPEC_CHOOSEMENU"],
	bitFlags = (function()
		local t = {}
		for i = 1, GetNumClasses() do
			local _, class, classID = GetClassInfo(i)
			specNameToRole[class] = {}

			for j = 1, GetNumSpecializationsForClassID(classID) do
				local specID, spec, desc, icon = GetSpecializationInfoForClassID(classID, j)
				specNameToRole[class][spec] = specID
				t[specID] = {
					order = specID,
					text = PLAYER_CLASS:format(RAID_CLASS_COLORS[class].colorStr, spec, LOCALIZED_CLASS_NAMES_MALE[class]),
					icon = icon,
					tcoords = CNDT.COMMON.standardtcoords
				}
			end
		end
		return t
	end)(),

	icon = function() return select(4, GetSpecializationInfo(1)) end,
	tcoords = CNDT.COMMON.standardtcoords,

	Env = {
		UnitSpecs = {},
		UnitSpec = function(unit)
			if UnitIsUnit(unit, "player") then
				local spec = GetSpecialization()
				return spec and GetSpecializationInfo(spec) or 0
			else
				local name, server = UnitName(unit)
				if name then
					name = name .. (server and "-" .. server or "")
					return Env.UnitSpecs[name] or 0
				end
			end

			return 0
		end,
	},
	funcstr = function(c)
		return [[ BITFLAGSMAPANDCHECK( UnitSpec(c.Unit) ) ]]
	end,
	events = function(ConditionObject, c)
		if c.Unit ~= "player" then
			-- Don't do these if we're definitely checking player,
			-- since there's really no reason to.
			SPECS:PrepareUnitSpecEvents()
			SPECS:UpdateUnitSpecs()
		end

		return
			ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit)),
			ConditionObject:GenerateNormalEventString("TMW_UNITSPEC_UPDATE"),
			ConditionObject:GenerateNormalEventString("PLAYER_TALENT_UPDATE")
	end,
})


TMW:RegisterUpgrade(73019, {
	-- Convert "CLASS" to "CLASS2"
	classes = {
		"DEATHKNIGHT",
		"DRUID",
		"HUNTER",
		"MAGE",
		"PRIEST",
		"PALADIN",
		"ROGUE",
		"SHAMAN",
		"WARLOCK",
		"WARRIOR",
		"MONK",
	},
	condition = function(self, condition)
		if condition.Type == "CLASS" then
			condition.Type = "CLASS2"
			condition.Checked = false
			for i = 1, GetNumClasses() do
				local name, token, classID = GetClassInfo(i)
				if token == self.classes[condition.Level] then
					condition.BitFlags = {[i] = true}
					return
				end
			end
		end
	end,
})
ConditionCategory:RegisterCondition(0.2,  "CLASS2", {
	text = L["CONDITIONPANEL_CLASS"],

	bitFlagTitle = L["CONDITIONPANEL_BITFLAGS_CHOOSECLASS"],
	bitFlags = (function()
		local t = {}
		for i = 1, GetNumClasses() do
			local name, token, classID = GetClassInfo(i)
			t[i] = {
				order = i,
				text = PLAYER_CLASS_NO_SPEC:format(RAID_CLASS_COLORS[token].colorStr, name),
				icon = "Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",
				tcoords = {
					(CLASS_ICON_TCOORDS[token][1]+.02),
					(CLASS_ICON_TCOORDS[token][2]-.02),
					(CLASS_ICON_TCOORDS[token][3]+.02),
					(CLASS_ICON_TCOORDS[token][4]-.02),
				}
			}
		end
		return t
	end)(),

	icon = "Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",
	tcoords = {
		CLASS_ICON_TCOORDS[pclass][1]+.02,
		CLASS_ICON_TCOORDS[pclass][2]-.02,
		CLASS_ICON_TCOORDS[pclass][3]+.02,
		CLASS_ICON_TCOORDS[pclass][4]-.02,
	},

	Env = {
		UnitClass = UnitClass,
	},
	funcstr = function(c)
		return [[ BITFLAGSMAPANDCHECK( select(3, UnitClass(c.Unit)) or 0 ) ]]
	end,
	events = function(ConditionObject, c)
		return
			ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit)) -- classes cant change, so this is all we should need
	end,
})


TMW:RegisterUpgrade(73019, {
	playerDungeonRoles = {
		"NONE",
		"DAMAGER",
		"HEALER",
		"TANK",
	},
	condition = function(self, condition)
		if condition.Type == "ROLE" then
			condition.Type = "ROLE2"
			condition.Checked = false
			CNDT:ConvertSliderCondition(condition, 1, #self.playerDungeonRoles, self.playerDungeonRoles)
		end
	end,
})
ConditionCategory:RegisterCondition(0.3,  "ROLE2", {
	text = L["CONDITIONPANEL_ROLE"],
	tooltip = L["CONDITIONPANEL_ROLE_DESC"],

	bitFlagTitle = L["CONDITIONPANEL_BITFLAGS_CHOOSEMENU_TYPES"],
	bitFlags = {
		NONE = 		{order = 1, text=NONE },
		TANK = 		{order = 2, text=TANK, icon = "Interface/AddOns/TellMeWhen/Textures/TANK", },
		HEALER = 	{order = 3, text=HEALER, icon = "Interface/AddOns/TellMeWhen/Textures/HEALER", },
		DAMAGER = 	{order = 4, text=DAMAGER, icon = "Interface/AddOns/TellMeWhen/Textures/DAMAGER", },
	},

	icon = "Interface\\Addons\\TellMeWhen\\Textures\\DAMAGER",
	Env = {
		UnitGroupRolesAssigned = UnitGroupRolesAssigned,
	},
	funcstr = [[BITFLAGSMAPANDCHECK( UnitGroupRolesAssigned(c.Unit) ) ]],
	events = function(ConditionObject, c)
		-- The unit change events should actually cover many of the changes
		-- (at least for party and raid units, but roles only exist in party and raid anyway.)
		return
			ConditionObject:GetUnitChangedEventString(CNDT:GetUnit(c.Unit)),
			ConditionObject:GenerateNormalEventString("PLAYER_ROLES_ASSIGNED"),
			ConditionObject:GenerateNormalEventString("ROLE_CHANGED_INFORM")
	end,
})



ConditionCategory:RegisterSpacer(6)



ConditionCategory:RegisterCondition(7,	 "SPEC", {
	text = L["UIPANEL_SPEC"],
	tooltip = L["UIPANEL_SPEC"],
	min = 1,
	max = 2,
	levelChecks = true,
	texttable = {
		[1] = L["UIPANEL_PRIMARYSPEC"],
		[2] = L["UIPANEL_SECONDARYSPEC"],
	},
	nooperator = true,
	unit = PLAYER,
	icon = "Interface\\Icons\\achievement_general",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = "DEPRECATED",
})

ConditionCategory:RegisterCondition(8,	 "TREE", {
	old = true,
	text = L["UIPANEL_SPECIALIZATION"],
	min = 1,
	max = GetNumSpecializations,
	texttable = function(i) return select(2, GetSpecializationInfo(i)) end,
	unit = PLAYER,
	icon = function() return select(4, GetSpecializationInfo(1)) end,
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		GetSpecialization = GetSpecialization
	},
	funcstr = [[(GetSpecialization() or 0) c.Operator c.Level]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("PLAYER_SPECIALIZATION_CHANGED", "player")
	end,
})



TMW:RegisterUpgrade(80002, {
	condition = function(self, condition)
		if condition.Type == "TREEROLE" then
			condition.Type = "TREEROLE2"
			condition.Checked = false
			CNDT:ConvertSliderCondition(condition, 1, 3, {
				[1] = "TANK",
				[2] = "DAMAGER",
				[3] = "HEALER",
			})
		end
	end,
})
ConditionCategory:RegisterCondition(8.1, "TREEROLE2", {
	text = L["UIPANEL_SPECIALIZATIONROLE"],
	tooltip = L["UIPANEL_SPECIALIZATIONROLE_DESC"],

	bitFlagTitle = L["CONDITIONPANEL_BITFLAGS_CHOOSEMENU_TYPES"],
	bitFlags = {
		TANK =    {order = 1, text=TANK, icon = "Interface/AddOns/TellMeWhen/Textures/TANK", },
		HEALER =  {order = 2, text=HEALER, icon = "Interface/AddOns/TellMeWhen/Textures/HEALER", },
		DAMAGER = {order = 3, text=DAMAGER, icon = "Interface/AddOns/TellMeWhen/Textures/DAMAGER", },
	},

	unit = PLAYER,
	icon = "Interface\\Addons\\TellMeWhen\\Textures\\HEALER",
	Env = {
		GetCurrentSpecializationRole = TMW.GetCurrentSpecializationRole,
	},
	funcstr = [[BITFLAGSMAPANDCHECK( GetCurrentSpecializationRole() ) ]],
	events = function(ConditionObject, c)
		if pclass == "WARRIOR" then
			return
				ConditionObject:GenerateNormalEventString("PLAYER_SPECIALIZATION_CHANGED", "player"),
				ConditionObject:GenerateNormalEventString("UPDATE_SHAPESHIFT_FORM")-- Check for gladiator stance.
		else
			return
				ConditionObject:GenerateNormalEventString("PLAYER_SPECIALIZATION_CHANGED", "player")
		end
	end,
})


CNDT.Env.TalentMap = {}
CNDT.Env.PvpTalentMap = {}
function CNDT:PLAYER_TALENT_UPDATE()
	wipe(Env.TalentMap)
	for tier = 1, MAX_TALENT_TIERS do
		for column = 1, NUM_TALENT_COLUMNS do
			local id, name, _, selected = GetTalentInfo(tier, column, 1)
			local lower = name and strlowerCache[name]
			if lower then
				Env.TalentMap[lower] = selected
				Env.TalentMap[id] = selected
			end
		end
	end

	wipe(Env.PvpTalentMap)
	local ids = C_SpecializationInfo.GetAllSelectedPvpTalentIDs()
	for _, id in pairs(ids) do
		local _, name = GetPvpTalentInfoByID(id);
		local lower = name and strlowerCache[name]
		if lower then
			Env.PvpTalentMap[lower] = true
			Env.PvpTalentMap[id] = true
		end
	end
end
ConditionCategory:RegisterCondition(9,	 "TALENTLEARNED", {
	text = L["UIPANEL_TALENTLEARNED"],

	bool = true,
	
	unit = PLAYER,
	name = function(editbox)
		editbox:SetTexts(L["SPELLTOCHECK"], L["CNDT_ONLYFIRST"])
	end,
	useSUG = "talents",
	icon = function() return select(3, GetTalentInfo(1, 1, 1)) end,
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = function(ConditionObject, c)
		-- this is handled externally because TalentMap is so extensive a process,
		-- and if it ends up getting processed in an OnUpdate condition, it could be very bad.
		CNDT:RegisterEvent("PLAYER_TALENT_UPDATE")
		CNDT:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", "PLAYER_TALENT_UPDATE")
		CNDT:PLAYER_TALENT_UPDATE()
	
		return [[BOOLCHECK( TalentMap[LOWER(c.NameFirst)] )]]
	end,
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("PLAYER_TALENT_UPDATE"),
			ConditionObject:GenerateNormalEventString("ACTIVE_TALENT_GROUP_CHANGED")
	end,
})


CNDT.Env.AzeriteEssenceMap = {}
CNDT.Env.AzeriteEssenceMap_MAJOR = {}
function CNDT:AZERITE_ESSENCE_UPDATE()
	wipe(Env.AzeriteEssenceMap)
	wipe(Env.AzeriteEssenceMap_MAJOR)
	local milestones = C_AzeriteEssence.GetMilestones()
	if not milestones then return end
	
	for _, slot in pairs(milestones) do
		if slot.unlocked then
			local equippedEssenceId = C_AzeriteEssence.GetMilestoneEssence(slot.ID)
			if equippedEssenceId then
				local essence = C_AzeriteEssence.GetEssenceInfo(equippedEssenceId)
				local name = essence.name
				local id = essence.ID

				local lower = name and strlowerCache[name]
				if lower then
					Env.AzeriteEssenceMap[lower] = true
					Env.AzeriteEssenceMap[id] = true

					-- Slot 0 is the major slot. There doesn't seem to be any other way to identify it.
					if slot.slot == 0 then 
						Env.AzeriteEssenceMap_MAJOR[lower] = true
						Env.AzeriteEssenceMap_MAJOR[id] = true
					end
				end
			end
		end
	end
end

for i, kind in TMW:Vararg("", "_MAJOR") do
	ConditionCategory:RegisterCondition(9.1 + i/10,	"AZESSLEARNED" .. kind, {
		text = L["UIPANEL_AZESSLEARNED" .. kind],
		bool = true,
		unit = PLAYER,
		name = function(editbox)
			editbox:SetTexts(L["SPELLTOCHECK"], L["CNDT_ONLYFIRST"])
		end,
		useSUG = "azerite_essence",
		icon = "Interface\\Icons\\" .. (kind == "" and "inv_radientazeritematrix" or "spell_azerite_essence_15"),
		tcoords = CNDT.COMMON.standardtcoords,
		funcstr = function(ConditionObject, c)
			CNDT:RegisterEvent("AZERITE_ESSENCE_UPDATE")
			CNDT:RegisterEvent("AZERITE_ESSENCE_ACTIVATED", "AZERITE_ESSENCE_UPDATE")
			CNDT:AZERITE_ESSENCE_UPDATE()
			
			return [[BOOLCHECK( AzeriteEssenceMap]] .. kind .. [[[LOWER(c.NameFirst)] )]]
		end,
		events = function(ConditionObject, c)
			return
				ConditionObject:GenerateNormalEventString("AZERITE_ESSENCE_UPDATE"),
				ConditionObject:GenerateNormalEventString("AZERITE_ESSENCE_ACTIVATED")
		end,
	})
end



ConditionCategory:RegisterCondition(9,	 "PTSINTAL", {
	text = L["UIPANEL_PTSINTAL"],
	funcstr = "DEPRECATED",
	min = 0,
	max = 5,
})



ConditionCategory:RegisterCondition(10,	 "PVPTALENTLEARNED", {
	text = L["UIPANEL_PVPTALENTLEARNED"],

	bool = true,
	
	unit = PLAYER,
	name = function(editbox)
		editbox:SetTexts(L["SPELLTOCHECK"], L["CNDT_ONLYFIRST"])
	end,
	useSUG = "pvptalents",
	icon = 1322720,
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = function(ConditionObject, c)
		-- this is handled externally because PvpTalentMap is so extensive a process,
		-- and if it ends up getting processed in an OnUpdate condition, it could be very bad.
		CNDT:RegisterEvent("PLAYER_TALENT_UPDATE")
		CNDT:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", "PLAYER_TALENT_UPDATE")
		CNDT:PLAYER_TALENT_UPDATE()
	
		return [[BOOLCHECK( PvpTalentMap[LOWER(c.NameFirst)] )]]
	end,
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("PLAYER_TALENT_UPDATE"),
			ConditionObject:GenerateNormalEventString("ACTIVE_TALENT_GROUP_CHANGED")
	end,
})


ConditionCategory:RegisterCondition(11,	 "GLYPH", {
	text = L["UIPANEL_GLYPH"],
	tooltip = L["UIPANEL_GLYPH_DESC"],

	bool = true,
	
	unit = PLAYER,
	name = function(editbox)
		editbox:SetTexts(L["GLYPHTOCHECK"], L["CNDT_ONLYFIRST"])
	end,
	icon = "Interface\\Icons\\inv_inscription_tradeskill01",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = "DEPRECATED",
})