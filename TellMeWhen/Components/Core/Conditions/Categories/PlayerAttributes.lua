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

local IsInInstance, GetInstanceDifficulty, GetNumShapeshiftForms, GetShapeshiftFormInfo = 
	  IsInInstance, GetInstanceDifficulty, GetNumShapeshiftForms, GetShapeshiftFormInfo
local GetPetActionInfo, GetNumTrackingTypes, GetTrackingInfo = 
	  GetPetActionInfo, GetNumTrackingTypes, GetTrackingInfo
	  
	  
local ConditionCategory = CNDT:GetCategory("ATTRIBUTES_PLAYER", 2, L["CNDTCAT_ATTRIBUTES_PLAYER"], false, false)




ConditionCategory:RegisterCondition(3,	 "MOUNTED", {
	text = L["CONDITIONPANEL_MOUNTED"],

	bool = true,
	
	unit = PLAYER,
	icon = "Interface\\Icons\\Ability_Mount_Charger",
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		IsMounted = IsMounted,
	},
	funcstr = [[BOOLCHECK( IsMounted() )]],
})
ConditionCategory:RegisterCondition(4,	 "SWIMMING", {
	text = L["CONDITIONPANEL_SWIMMING"],

	bool = true,
	
	unit = PLAYER,
	icon = "Interface\\Icons\\Spell_Shadow_DemonBreath",
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		IsSwimming = IsSwimming,
	},
	funcstr = [[BOOLCHECK( IsSwimming() )]],
	--events = absolutely no events (SPELL_UPDATE_USABLE is close, but not close enough)
})
ConditionCategory:RegisterCondition(5,	 "RESTING", {
	text = L["CONDITIONPANEL_RESTING"],

	bool = true,
	
	unit = PLAYER,
	icon = "Interface\\CHARACTERFRAME\\UI-StateIcon",
	tcoords = {0.0625, 0.453125, 0.046875, 0.421875},
	Env = {
		IsResting = IsResting,
	},
	funcstr = [[BOOLCHECK( IsResting() )]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("PLAYER_UPDATE_RESTING"),
			ConditionObject:GenerateNormalEventString("PLAYER_ENTERING_WORLD")
	end,
})
ConditionCategory:RegisterCondition(5.2, "INPETBATTLE", {
	text = L["CONDITIONPANEL_INPETBATTLE"],

	bool = true,
	
	unit = PLAYER,
	icon = "Interface\\Icons\\pet_type_critter",
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		IsInBattle = C_PetBattles.IsInBattle,
	},
	funcstr = [[BOOLCHECK( IsInBattle() )]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("PET_BATTLE_OPENING_START"),
			ConditionObject:GenerateNormalEventString("PET_BATTLE_CLOSE")
	end,
})

ConditionCategory:RegisterCondition(5.3, "OVERRBAR", {
	text = L["CONDITIONPANEL_OVERRBAR"],
	tooltip = L["CONDITIONPANEL_OVERRBAR_DESC"],

	bool = true,
	
	unit = PLAYER,
	icon = "Interface\\Icons\\Ability_Vehicle_SiegeEngineCharge",
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		HasOverrideActionBar = HasOverrideActionBar,
	},
	funcstr = [[BOOLCHECK( HasOverrideActionBar() )]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("UPDATE_OVERRIDE_ACTIONBAR")
	end,
})

ConditionCategory:RegisterCondition(5.4, "WARMODE", {
	text = L["CONDITIONPANEL_WARMODE"],

	bool = true,
	
	unit = PLAYER,
	icon = "Interface\\Icons\\achievement_arena_2v2_5",
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		IsWarModeDesired = C_PvP.IsWarModeDesired,
	},
	funcstr = [[BOOLCHECK( IsWarModeDesired() )]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("PLAYER_FLAGS_CHANGED")
	end,
})

local NumShapeshiftForms
local GetShapeshiftForm = GetShapeshiftForm
TMW:RegisterCallback("TMW_GLOBAL_UPDATE", function()
	NumShapeshiftForms = GetNumShapeshiftForms()
end)


ConditionCategory:RegisterSpacer(5.5)

local FirstStances = {
	DRUID = 5487, 		-- Bear Form
	ROGUE = 1784, 		-- Stealth
}
ConditionCategory:RegisterCondition(6,	 "STANCE", {
	text = 	pclass == "DRUID" and L["SHAPESHIFT"] or
			L["STANCE"],

	bool = true,
	
	name = function(editbox)
		editbox:SetTexts(L["STANCE"], L["STANCE_DESC"])
		editbox:SetLabel(L["STANCE_LABEL"])
	end,
	useSUG = "stances",
	allowMultipleSUGEntires = true,
	unit = PLAYER,
	icon = function()
		return GetSpellTexture(FirstStances[pclass] or FirstStances.WARRIOR) or GetSpellTexture(FirstStances.WARRIOR)
	end,
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		GetShapeshiftForm = function()
			-- very hackey function because of inconsistencies in blizzard's GetShapeshiftForm
			local i = GetShapeshiftForm()
			if pclass == "ROGUE" and i > 1 then	--vanish and shadow dance return 3 when active, vanish returns 2 when shadow dance isnt learned. Just treat everything as stealth
				i = 1
			end
			if i > NumShapeshiftForms then 	--many Classes return an invalid number on login, but not anymore!
				i = 0
			end

			if i == 0 then
				return NONE
			else
				local icons, active, catable, spellID = GetShapeshiftFormInfo(i)
				return spellID and GetSpellInfo(spellID) or ""
			end
		end
	},
	funcstr = [[BOOLCHECK(MULTINAMECHECK(  GetShapeshiftForm() or ""  ))]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("UPDATE_SHAPESHIFT_FORM")
	end,
	hidden = not FirstStances[pclass],
})

ConditionCategory:RegisterSpacer(6.5)



ConditionCategory:RegisterCondition(12,	 "AUTOCAST", {
	text = L["CONDITIONPANEL_AUTOCAST"],
	tooltip = L["CONDITIONPANEL_AUTOCAST_DESC"],

	bool = true,
	
	unit = PET,
	name = function(editbox)
		editbox:SetTexts(L["CONDITIONPANEL_AUTOCAST"], L["CNDT_ONLYFIRST"])
		editbox:SetLabel(L["SPELLTOCHECK"])
	end,
	useSUG = true,
	icon = "Interface\\Icons\\ability_physical_taunt",
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		GetSpellAutocast = GetSpellAutocast,
	},
	funcstr = [[BOOLCHECK( select(2, GetSpellAutocast(c.NameString)) )]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("PET_BAR_UPDATE")
	end,
})



TMW:RegisterUpgrade(73019, {
	condition = function(self, condition)
		if condition.Type == "PETMODE" then
			condition.Type = "PETMODE2"
			condition.Checked = false

			CNDT:ConvertSliderCondition(condition, 1, 3)
		end
	end,
})
local PetModes = {
	PET_MODE_ASSIST = 1,
	PET_MODE_DEFENSIVE = 2,
	PET_MODE_PASSIVE = 3,
}
ConditionCategory:RegisterCondition(13.1, "PETMODE2", {
	text = L["CONDITIONPANEL_PETMODE"],
	tooltip = L["CONDITIONPANEL_PETMODE_DESC"],

	bitFlagTitle = L["CONDITIONPANEL_BITFLAGS_CHOOSEMENU_TYPES"],
	bitFlags = {
		[0] = L["CONDITIONPANEL_PETMODE_NONE"],
		[1] = PET_MODE_ASSIST,
		[2] = PET_MODE_DEFENSIVE,
		[3] = PET_MODE_PASSIVE
	},

	unit = false,
	icon = PET_ASSIST_TEXTURE,
	tcoords = CNDT.COMMON.standardtcoords,

	Env = {
		GetActivePetMode2 = function()
			for i = NUM_PET_ACTION_SLOTS, 1, -1 do -- go backwards since they are probably at the end of the action bar
				local name, _, isToken, isActive = GetPetActionInfo(i)
				if isToken and isActive and PetModes[name] then
					return PetModes[name]
				end
			end
			return 0
		end,
	},
	funcstr = [[BITFLAGSMAPANDCHECK( GetActivePetMode2() )]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("UNIT_PET", "player"),
			ConditionObject:GenerateNormalEventString("PET_BAR_UPDATE")
	end,
})

TMW:RegisterUpgrade(73019, {
	condition = function(self, condition)
		if condition.Type == "PETSPEC" then
			condition.Type = "PETSPEC2"
			condition.Checked = false
			CNDT:ConvertSliderCondition(condition, 0, 3)
		end
	end,
})
ConditionCategory:RegisterCondition(14.1, "PETSPEC2", {
	text = L["CONDITIONPANEL_PETSPEC"],
	tooltip = L["CONDITIONPANEL_PETSPEC_DESC"],

	bitFlagTitle = L["CONDITIONPANEL_UNITSPEC_CHOOSEMENU"],
	bitFlags = {
		[0] = NONE,
		[1] = L["PET_TYPE_FEROCITY"],
		[2] = L["PET_TYPE_TENACITY"],
		[3] = L["PET_TYPE_CUNNING"]
	},

	hidden = pclass ~= "HUNTER",
	unit = false,
	icon = "Interface\\Icons\\Ability_Druid_DemoralizingRoar",
	tcoords = CNDT.COMMON.standardtcoords,

	Env = {
		GetSpecialization = GetSpecialization
	},
	funcstr = [[BITFLAGSMAPANDCHECK( GetSpecialization(nil, true) or 0 )]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("UNIT_PET", "player"),
			ConditionObject:GenerateNormalEventString("PET_SPECIALIZATION_CHANGED")
	end,
})


ConditionCategory:RegisterSpacer(15.5)


Env.Tracking = {}
function CNDT:MINIMAP_UPDATE_TRACKING()
	wipe(Env.Tracking)
	for i = 1, GetNumTrackingTypes() do
		local name, _, active = GetTrackingInfo(i)
		Env.Tracking[strlower(name)] = active and 1 or nil
	end
end
ConditionCategory:RegisterCondition(16,	 "TRACKING", {
	text = L["CONDITIONPANEL_TRACKING"],
	tooltip = L["CONDITIONPANEL_TRACKING_DESC"],

	bool = true,
	
	unit = PLAYER,
	name = function(editbox)
		editbox:SetTexts(L["CONDITIONPANEL_TRACKING"], L["CNDT_ONLYFIRST"])
		editbox:SetLabel(L["SPELLTOCHECK"])
	end,
	useSUG = "tracking",
	icon = "Interface\\MINIMAP\\TRACKING\\None",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = function(ConditionObject, c)
		-- this event handling it is really extensive, so keep it in a handler separate from the condition
		CNDT:RegisterEvent("MINIMAP_UPDATE_TRACKING")
		CNDT:MINIMAP_UPDATE_TRACKING()
	
		return [[BOOLCHECK( Tracking[c.NameString] )]]
	end,
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("MINIMAP_UPDATE_TRACKING")
	end,
})



ConditionCategory:RegisterSpacer(17)


ConditionCategory:RegisterCondition(18,	 "BLIZZEQUIPSET", {
	text = L["CONDITIONPANEL_BLIZZEQUIPSET"],
	tooltip = L["CONDITIONPANEL_BLIZZEQUIPSET_DESC"],

	bool = true,
	
	unit = PLAYER,
	name = function(editbox)
		editbox:SetTexts(L["CONDITIONPANEL_BLIZZEQUIPSET_INPUT"], L["CONDITIONPANEL_BLIZZEQUIPSET_INPUT_DESC"])
		editbox:SetLabel(L["EQUIPSETTOCHECK"])
	end,
	useSUG = "blizzequipset",
	icon = "Interface\\Icons\\inv_box_04",
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		GetEquipmentSetID = C_EquipmentSet.GetEquipmentSetID,
		GetEquipmentSetInfo = C_EquipmentSet.GetEquipmentSetInfo,
	},
	funcstr = [[GetEquipmentSetID(c.NameRaw) and BOOLCHECK( select(4, GetEquipmentSetInfo(GetEquipmentSetID(c.NameRaw))) )]],
	events = function(ConditionObject, c)
		return
			--ConditionObject:GenerateNormalEventString("EQUIPMENT_SWAP_FINISHED") -- this doesn't fire late enough to get updated returns from GetEquipmentSetInfoByName
			ConditionObject:GenerateNormalEventString("BAG_UPDATE"), -- this is slightly overkill, but it is the first event that fires when the return value of GetEquipmentSetInfoByName has changed
			ConditionObject:GenerateNormalEventString("EQUIPMENT_SETS_CHANGED") -- this is needed to handle saving an equipment set that is alredy equipped
	end,
})

