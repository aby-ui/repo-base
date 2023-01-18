local mod	= DBM:NewMod("d1963", "DBM-Challenges", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20230117064011")

mod:RegisterCombat("scenario", 2162)--1911-1912 are outdoor areas
mod.noStatistics = true

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 288210 292903 295985 296748 295001 294362 318995 304075 296523 270248 270264 270348 263085 215710 294526 294533 298844 297018 295942 294165 330118 258935 308026 335528 277040 329608 330438 330471 294401 294517 296839 297020 242391 330573 332165 258938 329422 329423 329930 329908 329909 81008 351931 353769 353573 354490 351090",
	"SPELL_AURA_APPLIED 304093 277040 294526",
	"SPELL_AURA_APPLIED_DOSE 303678",
	"SPELL_AURA_REMOVED 277040",
	"SPELL_PERIODIC_DAMAGE 294607",
	"SPELL_PERIODIC_MISSED 294607"
)

--TODO, verifying howling souls spellId, user submitted and unverified from logs. SpellId given is used in eye of azshara. Can use torghast reusuing it though.
--TODO https://shadowlands.wowhead.com/spell=303678/bone-shrapnel? not sure what i can do about it in a mod though, it's instant cast on death. warn when they are getting low if melee?
--TODO https://shadowlands.wowhead.com/spell=299150/unnatural-power? boss buff stacks, basic DPS check
--TODO, alert when a deadsoul scavenger is nearby?
--TODO, 352215 cries of tormented fear interruptable?
--TODO, right event for https://www.wowhead.com/spell=354493/soul-breaker#used-by-npc
--TODO, is https://www.wowhead.com/spell=351621/impaling-spikes#guides the one with bone spikes coming out of ground that do massive damage? I need to get right spell for that and add a dodge/interrrupt to it
local warnMightySlam				= mod:NewCastAnnounce(296748, 3)--Cast time to short to really dodge, this is just alert to at least mentally prepare for damage spike

--The Maw (WIP, current combat handling doesn't permit this yet)
--local specWarnMagmaWave				= mod:NewSpecialWarningDodge(345454, nil, nil, nil, 2, 2)--SPELL_CAST_START
--Torghast
local specWarnHowlingSouls			= mod:NewSpecialWarningSpell(215710, nil, nil, nil, 2, 2)
local specWarnMassiveStrike			= mod:NewSpecialWarningDodge(292903, nil, nil, nil, 2, 2)
local specWarnMeteor				= mod:NewSpecialWarningDodge(270264, nil, nil, nil, 2, 2)
local specWarnRatTrap				= mod:NewSpecialWarningDodge(295942, nil, nil, nil, 2, 2)
local specWarnFanningtheFlames		= mod:NewSpecialWarningDodge(308026, nil, nil, nil, 2, 2)
local specWarnCrushingSlam			= mod:NewSpecialWarningDodge(329908, nil, nil, nil, 2, 2)
local specWarnProphecyOfDeath		= mod:NewSpecialWarningDodge(330471, nil, nil, nil, 2, 2)
local specWarnDiscordantBarrage		= mod:NewSpecialWarningDodge(294401, nil, nil, nil, 2, 2)
local specWarnBindSouls				= mod:NewSpecialWarningDodge(297020, nil, nil, nil, 2, 2)
local specWarnInferno				= mod:NewSpecialWarningDodge(335528, nil, nil, nil, 2, 2)
local specWarnCarrionSwarm			= mod:NewSpecialWarningDodge(353573, nil, nil, nil, 2, 2)
local specWarnTorturingSwipe		= mod:NewSpecialWarningDodge(354490, nil, nil, nil, 2, 2)
local specWarnQuake					= mod:NewSpecialWarningJump(81008, nil, nil, nil, 2, 2)

local specWarnGroundCrush			= mod:NewSpecialWarningRun(295985, nil, nil, nil, 4, 2)
--local specWarnMightySlam			= mod:NewSpecialWarningRun(296748, nil, nil, nil, 4, 2)
local specWarnWhirlwind				= mod:NewSpecialWarningRun(295001, nil, nil, nil, 4, 2)
local specWarnSoulblastNova			= mod:NewSpecialWarningRun(294533, nil, nil, nil, 4, 2)
local specWarnCrushingStomp			= mod:NewSpecialWarningRun(329909, nil, nil, nil, 4, 2)
local specWarnPainBringer			= mod:NewSpecialWarningRun(351931, nil, nil, nil, 4, 2)
local specWarnDeafeningHowl			= mod:NewSpecialWarningCast(296523, "SpellCaster", nil, nil, 1, 2)
local specWarnBoneShrapnel			= mod:NewSpecialWarningStack(303678, nil, 4, nil, nil, 1, 6)
local specWarnMassCripple			= mod:NewSpecialWarningDispel(304093, "RemoveMagic", nil, nil, 1, 2)
local specWarnCurseofFrailtyDispel	= mod:NewSpecialWarningDispel(294526, "RemoveCurse", nil, nil, 1, 2)
--local yellScorchedFeet			= mod:NewYell(315385)
local specWarnNecroticBolt			= mod:NewSpecialWarningInterrupt(288210, "HasInterrupt", nil, nil, 1, 2)
local specWarnShadowBoltVolley		= mod:NewSpecialWarningInterrupt(294362, "HasInterrupt", nil, nil, 1, 2)
local specWarnBindofFallen			= mod:NewSpecialWarningInterrupt(304075, false, nil, 2, 1, 2)
local specWarnConflagrate			= mod:NewSpecialWarningInterrupt(270248, "HasInterrupt", nil, nil, 1, 2)
local specWarnFireballVolley		= mod:NewSpecialWarningInterrupt(270348, "HasInterrupt", nil, nil, 1, 2)
local specWarnTerrifyingRoar		= mod:NewSpecialWarningInterrupt(263085, "HasInterrupt", nil, nil, 1, 2)
local specWarnCurseofFrailty		= mod:NewSpecialWarningInterrupt(294526, "HasInterrupt", nil, nil, 1, 2)
local specWarnFearsomeHowl			= mod:NewSpecialWarningInterrupt(298844, "HasInterrupt", nil, 2, 1, 2)
local specWarnFearsomeShriek		= mod:NewSpecialWarningInterrupt(332165, "HasInterrupt", nil, nil, 1, 2)
local specWarnTerrifyingScreech		= mod:NewSpecialWarningInterrupt(329930, "HasInterrupt", nil, nil, 1, 2)
local specWarnPhasingRoar			= mod:NewSpecialWarningInterrupt(294517, "HasInterrupt", nil, nil, 1, 2)
local specWarnDeathBlast			= mod:NewSpecialWarningInterrupt(296839, "HasInterrupt", nil, nil, 1, 2)
local specWarnAccursedStrength		= mod:NewSpecialWarningInterrupt(294165, "HasInterrupt", nil, nil, 1, 2)
local specWarnWitheringRoar			= mod:NewSpecialWarningInterrupt(330118, "HasInterrupt", nil, nil, 1, 2)
local specWarnInnerFlames			= mod:NewSpecialWarningInterrupt(258935, "HasInterrupt", nil, nil, 1, 2)
local specWarnSoulofMist			= mod:NewSpecialWarningInterrupt(277040, "HasInterrupt", nil, nil, 1, 2)
local specWarnTerror				= mod:NewSpecialWarningInterrupt(242391, "HasInterrupt", nil, nil, 1, 2)
local specWarnBountyOfTheForest		= mod:NewSpecialWarningInterrupt(330573, "HasInterrupt", nil, nil, 1, 2)
local specWarnShadowboltVolley		= mod:NewSpecialWarningInterrupt(353769, "HasInterrupt", nil, nil, 1, 2)
local specWarnPersecute				= mod:NewSpecialWarningInterrupt(351090, "HasInterrupt", nil, nil, 1, 2)
local specWarnSoulofMistDispel		= mod:NewSpecialWarningDispel(277040, "MagicDispeller", nil, nil, 1, 2)
local specWarnGTFO					= mod:NewSpecialWarningGTFO(303594, nil, nil, nil, 1, 8)

mod:AddNamePlateOption("NPAuraOnSoulofMist", 277040)

--Antispam IDs for this mod: 1 run away, 2 dodge, 3 dispel, 4 incoming damage, 5 you/role, 6 GTFO, 7 misc
local warnedGUIDs = {}

--[[
function mod:DefiledGroundTarget(targetname, uId)
	if not targetname then return end
	if targetname == UnitName("player") then
		yellDefiledGround:Yell()
	end
end
--]]

function mod:OnCombatStart(delay)
	table.wipe(warnedGUIDs)
	if self.Options.NPAuraOnSoulofMist then
		DBM:FireEvent("BossMod_EnableHostileNameplates")
	end
end

function mod:OnCombatEnd()
	table.wipe(warnedGUIDs)
	if self.Options.NPAuraOnSoulofMist then
		DBM.Nameplate:Hide(true, nil, nil, nil, true, true)--isGUID, unit, spellId, texture, force, isHostile, isFriendly
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if not self:IsValidWarning(args.sourceGUID, nil, true) then return end--Filter all casts done by mobs in combat with npcs/other mobs.
	if spellId == 292903 and self:AntiSpam(3, 2) then
		specWarnMassiveStrike:Show()
		specWarnMassiveStrike:Play("shockwave")
	elseif spellId == 308026 and self:AntiSpam(3, 2) then
		specWarnFanningtheFlames:Show()
		specWarnFanningtheFlames:Play("shockwave")
	elseif spellId == 329908 and self:AntiSpam(3, 2) then
		specWarnCrushingSlam:Show()
		specWarnCrushingSlam:Play("shockwave")
	elseif spellId == 353573 and self:AntiSpam(3, 2) then
		specWarnCarrionSwarm:Show()
		specWarnCarrionSwarm:Play("shockwave")
	elseif spellId == 354490 and self:AntiSpam(3, 2) then
		specWarnTorturingSwipe:Show()
		specWarnTorturingSwipe:Play("shockwave")
	elseif spellId == 215710 and self:AntiSpam(4, 4) then
		specWarnHowlingSouls:Show()
		specWarnHowlingSouls:Play("aesoon")
	elseif spellId == 270264 and self:AntiSpam(3, 2) then
		specWarnMeteor:Show()
		specWarnMeteor:Play("watchstep")
	elseif spellId == 295942 and self:AntiSpam(3, 2) then
		specWarnRatTrap:Show()
		specWarnRatTrap:Play("watchstep")
	elseif spellId == 330471 and self:AntiSpam(3, 2) then
		specWarnProphecyOfDeath:Show()
		specWarnProphecyOfDeath:Play("watchstep")
	elseif spellId == 294401 and self:AntiSpam(3, 2) then
		specWarnDiscordantBarrage:Show()
		specWarnDiscordantBarrage:Play("watchstep")
	elseif spellId == 297020 and self:AntiSpam(3, 2) then
		specWarnBindSouls:Show()
		specWarnBindSouls:Play("watchstep")
	elseif spellId == 335528 and self:AntiSpam(3, 7) then
		specWarnInferno:Show()
		specWarnInferno:Play("watchstep")
	elseif spellId == 81008 and self:AntiSpam(3, 7) then
		specWarnQuake:Schedule(0.75)
		specWarnQuake:ScheduleVoice(0.75, "jumpnow")
	elseif spellId == 295985 then
		if self:AntiSpam(4, 1) then
			specWarnGroundCrush:Show()
			specWarnGroundCrush:Play("justrun")
		end
	elseif spellId == 296748 and self:AntiSpam(4, 7) then
		warnMightySlam:Show()
	elseif spellId == 295001 and self:AntiSpam(4, 1) then
		specWarnWhirlwind:Show()
		specWarnWhirlwind:Play("justrun")
	elseif spellId == 294533 and self:AntiSpam(4, 1) then
		specWarnSoulblastNova:Show()
		specWarnSoulblastNova:Play("justrun")
	elseif spellId == 329909 and self:AntiSpam(4, 1) then
		specWarnCrushingStomp:Show()
		specWarnCrushingStomp:Play("justrun")
	elseif spellId == 351931 and self:AntiSpam(4, 1) then
		specWarnPainBringer:Show()
		specWarnPainBringer:Play("justrun")
	elseif (spellId == 296523 or spellId == 318995) and self:AntiSpam(4, 5) then
		specWarnDeafeningHowl:Show()
		specWarnDeafeningHowl:Play("stopcast")
	elseif spellId == 288210 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnNecroticBolt:Show(args.sourceName)
		specWarnNecroticBolt:Play("kickcast")
	elseif spellId == 294362 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnShadowBoltVolley:Show(args.sourceName)
		specWarnShadowBoltVolley:Play("kickcast")
	elseif spellId == 304075 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnBindofFallen:Show(args.sourceName)
		specWarnBindofFallen:Play("kickcast")
	elseif spellId == 270248 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnConflagrate:Show(args.sourceName)
		specWarnConflagrate:Play("kickcast")
	elseif spellId == 270348 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnFireballVolley:Show(args.sourceName)
		specWarnFireballVolley:Play("kickcast")
	elseif (spellId == 329608 or spellId == 263085) and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnTerrifyingRoar:Show(args.sourceName)
		specWarnTerrifyingRoar:Play("kickcast")
	elseif spellId == 294526 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnCurseofFrailty:Show(args.sourceName)
		specWarnCurseofFrailty:Play("kickcast")
	elseif spellId == 294165 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnAccursedStrength:Show(args.sourceName)
		specWarnAccursedStrength:Play("kickcast")
	elseif spellId == 277040 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnSoulofMist:Show(args.sourceName)
		specWarnSoulofMist:Play("kickcast")
	elseif spellId == 330118 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnWitheringRoar:Show(args.sourceName)
		specWarnWitheringRoar:Play("kickcast")
	elseif (spellId == 258935 or spellId == 258938 or spellId == 329422 or spellId == 329423) and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnInnerFlames:Show(args.sourceName)
		specWarnInnerFlames:Play("kickcast")
	elseif (spellId == 297018 or spellId == 298844 or spellId == 330438) and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnFearsomeHowl:Show(args.sourceName)
		specWarnFearsomeHowl:Play("kickcast")
	elseif spellId == 298844 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnPhasingRoar:Show(args.sourceName)
		specWarnPhasingRoar:Play("kickcast")
	elseif spellId == 296839 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnDeathBlast:Show(args.sourceName)
		specWarnDeathBlast:Play("kickcast")
	elseif spellId == 242391 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnTerror:Show(args.sourceName)
		specWarnTerror:Play("kickcast")
	elseif spellId == 332165 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnFearsomeShriek:Show(args.sourceName)
		specWarnFearsomeShriek:Play("kickcast")
	elseif spellId == 329930 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnTerrifyingScreech:Show(args.sourceName)
		specWarnTerrifyingScreech:Play("kickcast")
	elseif spellId == 330573 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnBountyOfTheForest:Show(args.sourceName)
		specWarnBountyOfTheForest:Play("kickcast")
	elseif spellId == 353769 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnShadowboltVolley:Show(args.sourceName)
		specWarnShadowboltVolley:Play("kickcast")
	elseif spellId == 351090 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnPersecute:Show(args.sourceName)
		specWarnPersecute:Play("kickcast")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 303678 and args:IsPlayer() then
		local amount = args.amount or 1
		if amount >= 4 and self:AntiSpam(3, 5) then
			specWarnBoneShrapnel:Show(amount)
			specWarnBoneShrapnel:Play("stackhigh")
		end
	elseif spellId == 304093 and self:IsValidWarning(args.destGUID) and args:IsDestTypePlayer() and self:CheckDispelFilter() then
		specWarnMassCripple:CombinedShow(0.5, args.destName)
		specWarnMassCripple:ScheduleVoice(0.5, "helpdispel")
	elseif spellId == 294526 and self:IsValidWarning(args.destGUID) and args:IsDestTypePlayer() and self:CheckDispelFilter() then
		specWarnCurseofFrailtyDispel:CombinedShow(0.5, args.destName)
		specWarnCurseofFrailtyDispel:ScheduleVoice(0.5, "helpdispel")
	elseif spellId == 277040 then
		if self:IsValidWarning(args.destGUID) and args:IsDestTypeHostile() and self:AntiSpam(3, 5) then
			specWarnSoulofMistDispel:Show(args.destName)
			specWarnSoulofMistDispel:Play("helpdispel")
		end
		if self.Options.NPAuraOnSoulofMist then
			DBM.Nameplate:Show(true, args.sourceGUID, spellId, nil, 9)
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 277040 then
		if self.Options.NPAuraOnSoulofMist then
			DBM.Nameplate:Hide(true, args.sourceGUID, spellId)
		end
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 294607 and destGUID == UnitGUID("player") and self:AntiSpam(2, 6) then -- Death Pool
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE
