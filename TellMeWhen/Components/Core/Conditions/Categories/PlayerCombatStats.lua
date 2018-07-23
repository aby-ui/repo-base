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

local min, format = min, format

Env.UnitStat = UnitStat
Env.GetHaste = GetHaste
Env.GetExpertise = GetExpertise
Env.GetCritChance = GetCritChance
Env.GetSpellCritChance = GetSpellCritChance
Env.GetMasteryEffect = GetMasteryEffect
Env.GetSpellBonusDamage = GetSpellBonusDamage
Env.GetSpellBonusHealing = GetSpellBonusHealing
	

TMW:RegisterUpgrade(71008, {
	replacements = {
		RANGEAP = "MELEEAP",
		RANGEDCRIT = "MELEECRIT",
		RANGEDHASTE = "MELEEHASTE",
		SPELLHEALING = "SPELLDMG",
		SPELLCRIT = "MELEECRIT",
		SPELLHASTE = "MELEEHASTE",
	},
	condition = function(self, condition)
		if self.replacements[condition.Type] then
			condition.Type = self.replacements[condition.Type]
		end
	end,
})


local ConditionCategory = CNDT:GetCategory("STATS", 6, L["CNDTCAT_STATS"], true, true)

ConditionCategory:RegisterCondition(1,	 "STRENGTH", {
	text = _G["SPELL_STAT1_NAME"],
	range = 2000,
	unit = PLAYER,
	formatter = TMW.C.Formatter.COMMANUMBER,
	icon = "Interface\\Icons\\spell_nature_strength",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = [[UnitStat("player", 1) c.Operator c.Level]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("UNIT_STATS", "player")
	end,
})
ConditionCategory:RegisterCondition(2,	 "AGILITY", {
	text = _G["SPELL_STAT2_NAME"],
	range = 2000,
	unit = PLAYER,
	formatter = TMW.C.Formatter.COMMANUMBER,
	icon = "Interface\\Icons\\spell_holy_blessingofagility",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = [[UnitStat("player", 2) c.Operator c.Level]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("UNIT_STATS", "player")
	end,
})
ConditionCategory:RegisterCondition(3,	 "STAMINA", {
	text = _G["SPELL_STAT3_NAME"],
	range = 2000,
	unit = PLAYER,
	formatter = TMW.C.Formatter.COMMANUMBER,
	icon = "Interface\\Icons\\spell_holy_wordfortitude",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = [[UnitStat("player", 3) c.Operator c.Level]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("UNIT_STATS", "player")
	end,
})
ConditionCategory:RegisterCondition(4,	 "INTELLECT", {
	text = _G["SPELL_STAT4_NAME"],
	range = 2000,
	unit = PLAYER,
	formatter = TMW.C.Formatter.COMMANUMBER,
	icon = "Interface\\Icons\\spell_holy_magicalsentry",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = [[UnitStat("player", 4) c.Operator c.Level]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("UNIT_STATS", "player")
	end,
})


ConditionCategory:RegisterSpacer(5)


ConditionCategory:RegisterCondition(6,	 "MELEECRIT", {
	text = STAT_CRITICAL_STRIKE,
	percent = true,
	formatter = TMW.C.Formatter.PERCENT,
	min = 0,
	max = 100,
	unit = PLAYER,
	icon = "Interface\\Icons\\Ability_CriticalStrike",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = [[max(GetCritChance(), GetSpellCritChance(2))/100 c.Operator c.Level]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("COMBAT_RATING_UPDATE")
	end,
})
ConditionCategory:RegisterCondition(7,	 "MELEEHASTE", {
	text = STAT_HASTE,
	percent = true,
	formatter = TMW.C.Formatter.PLUSPERCENT,
	min = 0,
	range = 100,
	unit = PLAYER,
	icon = "Interface\\Icons\\spell_nature_bloodlust",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = [[GetHaste()/100 c.Operator c.Level]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("UNIT_ATTACK_SPEED", "player")
	end,
})
ConditionCategory:RegisterCondition(8,	 "MASTERY", {
	text = STAT_MASTERY,
	min = 0,
	range = 100,
	formatter = TMW.C.Formatter.PERCENT,
	unit = PLAYER,
	icon = "Interface\\Icons\\spell_holy_championsbond",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = [[GetMasteryEffect() c.Operator c.Level]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("MASTERY_UPDATE")
	end,
})
ConditionCategory:RegisterCondition(9,	 "EXPERTISE", {		-- DEPRECATED
	text = _G["COMBAT_RATING_NAME"..CR_EXPERTISE],
	funcstr = "DEPRECATED",
	min = 0, 
	range = 100,
})


ConditionCategory:RegisterSpacer(10)


ConditionCategory:RegisterCondition(11,	"SPIRIT", {
	text = _G["SPELL_STAT5_NAME"],
	range = 2000,
	unit = PLAYER,
	formatter = TMW.C.Formatter.COMMANUMBER,
	icon = "Interface\\Icons\\spell_shadow_burningspirit",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = [[UnitStat("player", 5) c.Operator c.Level]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("UNIT_STATS", "player")
	end,
})
ConditionCategory:RegisterCondition(13, "MULTISTRIKE", {
	text = STAT_MULTISTRIKE,
	min = 0,
	range = 50,
	step = 0.1,
	formatter = TMW.C.Formatter.PERCENT,
	unit = PLAYER,
	icon = "Interface\\Icons\\Ability_UpgradeMoonGlaive",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = "DEPRECATED",
})
ConditionCategory:RegisterCondition(14, "LIFESTEAL", {
	text = STAT_LIFESTEAL,
	min = 0,
	range = 10,
	step = 0.1,
	formatter = TMW.C.Formatter.PERCENT,
	unit = PLAYER,
	icon = "Interface\\Icons\\Spell_Shadow_LifeDrain02",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = [[GetLifesteal() c.Operator c.Level]],
	Env = {
		GetLifesteal = GetLifesteal,
	},
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("LIFESTEAL_UPDATE")
	end,
})
ConditionCategory:RegisterCondition(15, "VERSATILITY", {
	text = STAT_VERSATILITY,
	min = 0,
	range = 50,
	step = 0.1,
	formatter = TMW.C.Formatter.PERCENT,
	unit = PLAYER,
	icon = "Interface\\Icons\\achievement_dungeon_icecrown_frostmourne",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = [[GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE) c.Operator c.Level]],
	Env = {
		CR_VERSATILITY_DAMAGE_DONE = CR_VERSATILITY_DAMAGE_DONE,
		GetCombatRatingBonus = GetCombatRatingBonus,
		GetVersatilityBonus = GetVersatilityBonus,
	},
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("COMBAT_RATING_UPDATE")
	end,
})
ConditionCategory:RegisterCondition(16, "AVOIDANCE", {
	text = STAT_AVOIDANCE,
	min = 0,
	range = 10,
	step = 0.1,
	formatter = TMW.C.Formatter.PERCENT,
	unit = PLAYER,
	icon = "Interface\\Icons\\spell_shadow_shadowward",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = [[GetAvoidance() c.Operator c.Level]],
	Env = {
		GetAvoidance = GetAvoidance,
	},
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("AVOIDANCE_UPDATE")
	end,
})


ConditionCategory:RegisterSpacer(30)

local UnitAttackPower = UnitAttackPower
ConditionCategory:RegisterCondition(30.5, "MELEEAP", {
	text = STAT_ATTACK_POWER,
	range = 5000,
	unit = PLAYER,
	formatter = TMW.C.Formatter.COMMANUMBER,
	icon = "Interface\\Icons\\INV_Sword_04",
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		MELEEAP_UnitAttackPower = function(unit)
			local base, pos, neg = c(unit)
			return base + pos + neg
		end,
	},
	funcstr = [[MELEEAP_UnitAttackPower("player") c.Operator c.Level]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("UNIT_ATTACK_POWER", "player")
	end,
})


if MAX_SPELL_SCHOOLS ~= 7 then
	TMW:Error("MAX_SPELL_SCHOOLS has changed, so the spell school dependent conditions need updating")
end
local GetSpellBonusDamage = GetSpellBonusDamage
ConditionCategory:RegisterCondition(31,	 "SPELLDMG", {
	text = STAT_SPELLPOWER,
	range = 5000,
	unit = PLAYER,
	formatter = TMW.C.Formatter.COMMANUMBER,
	icon = "Interface\\Icons\\spell_fire_flamebolt",
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		SPELLDMG_GetSpellBonusDamage = function()
			return min(
				GetSpellBonusDamage(2),
				GetSpellBonusDamage(3),
				GetSpellBonusDamage(4),
				GetSpellBonusDamage(5),
				GetSpellBonusDamage(6),
				GetSpellBonusDamage(7)
			)
		end,
	},
	funcstr = [[SPELLDMG_GetSpellBonusDamage() c.Operator c.Level]],
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("PLAYER_DAMAGE_DONE_MODS"),
			ConditionObject:GenerateNormalEventString("SPELL_POWER_CHANGED") --TMW.ISMOP
	end,
})


Env.GetManaRegen = GetManaRegen
ConditionCategory:RegisterCondition(35,	 "MANAREGEN", {
	text = MANA_REGEN,
	range = 1000/5,
	unit = PLAYER,
	texttable = function(k) return format(L["MP5"], TMW.C.Formatter.COMMANUMBER:Format(k)*5) end,
	icon = "Interface\\Icons\\spell_magic_managain",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = [[GetManaRegen() c.Operator c.Level]], -- anyone know of an event that can be reliably listened to to get this?
})
ConditionCategory:RegisterCondition(36,	 "MANAREGENCOMBAT", {
	text = MANA_REGEN_COMBAT,
	range = 1000/5,
	unit = PLAYER,
	texttable = function(k) return format(L["MP5"], TMW.C.Formatter.COMMANUMBER:Format(k)*5) end,
	icon = "Interface\\Icons\\spell_frost_summonwaterelemental",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = [[select(2, GetManaRegen()) c.Operator c.Level]],
})

