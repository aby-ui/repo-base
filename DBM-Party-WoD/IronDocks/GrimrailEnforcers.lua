local mod	= DBM:NewMod(1236, "DBM-Party-WoD", 4, 558)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "normal,heroic,mythic,challenge,timewalker"
mod.upgradedMPlus = true

mod:SetRevision("20221016002954")
mod:SetCreatureID(80805, 80816, 80808)
mod:SetEncounterID(1748)
mod:SetBossHPInfoToHighest()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 163665 163390 163379",
	"SPELL_AURA_APPLIED 163689 181089",
	"SPELL_AURA_REMOVED 163689",
	"UNIT_DIED"
)

--[[
(ability.id = 163390 or ability.id = 163379 or ability.id = 163665) and type = "begincast"
 or (ability.id = 163689 or ability.id = 181089) and type = "applybuff"
 or type = "dungeonencounterstart" or type = "dungeonencounterend"
--]]
--Ahri'ok Dugru
mod:AddTimerLine(DBM:EJ_GetSectionInfo(10449))
local warnSphereEnd				= mod:NewEndAnnounce(163689, 1)

local specWarnSanguineSphere	= mod:NewSpecialWarningReflect(163689, "-Healer", nil, 2, 1, 2)

local timerSanguineSphere		= mod:NewTargetTimer(15, 163689, nil, nil, nil, 5, nil, DBM_COMMON_L.DAMAGE_ICON)
--Makogg Emberblade
mod:AddTimerLine(DBM:EJ_GetSectionInfo(10453))
local specWarnFlamingSlash		= mod:NewSpecialWarningDodge(163665, nil, nil, nil, 3, 2)--Devastating in challenge modes. move or die.
local specWarnLavaSwipe			= mod:NewSpecialWarningSpell(165152, nil, nil, nil, 2, 2)

local timerFlamingSlashCD		= mod:NewNextTimer(29, 163665, nil, nil, nil, 3, nil, nil, nil, 1, 4)
local timerLavaSwipeCD			= mod:NewNextTimer(29, 165152, nil, nil, nil, 3)
--Neesa Nox
mod:AddTimerLine(DBM:EJ_GetSectionInfo(10456))
local warnOgreTraps				= mod:NewCastAnnounce(163390, 3)

local specWarnBigBoom			= mod:NewSpecialWarningSpell(163379, nil, nil, nil, 2, 2)--maybe use switch.

local timerOgreTrapsCD			= mod:NewCDTimer(24.4, 163390, nil, nil, nil, 3)--25-30 variation.

function mod:OnCombatStart(delay)
	timerFlamingSlashCD:Start(4.6-delay)
	timerOgreTrapsCD:Start(11.5-delay)
	timerLavaSwipeCD:Start(14.3 - delay)
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 163665 then
		specWarnFlamingSlash:Show()
		specWarnFlamingSlash:Play("chargemove")
		if self:IsNormal() then
			timerFlamingSlashCD:Start(41.5)
		else
			timerFlamingSlashCD:Start()
		end
	elseif spellId == 163390 then
		warnOgreTraps:Show()
		timerOgreTrapsCD:Start()
	elseif spellId == 163379 then
		specWarnBigBoom:Show()
		specWarnBigBoom:Play("watchstep")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 163689 then
		specWarnSanguineSphere:Show(args.destName)
		specWarnSanguineSphere:Play("stopattack")
		local unitid
		for i = 1, 3 do
			if UnitGUID("boss"..i) == args.destGUID then
				unitid = "boss"..i
			end
		end
		if unitid then
			local _, _, _, _, duration, expires = DBM:UnitBuff(unitid, args.spellName)
			if expires then
				timerSanguineSphere:Start(expires-GetTime(), args.destName)
			end
		end
	elseif args.spellId == 181089 then--Encounter event
		specWarnLavaSwipe:Show()
		specWarnLavaSwipe:Play("shockwave")
		if self:IsHard() then
			timerLavaSwipeCD:Start()--29
		else
			timerLavaSwipeCD:Start(41.5)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 163689 then
		timerSanguineSphere:Cancel(args.destName)
		warnSphereEnd:Show()
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 80805 then--Makogg Emberblade
		timerFlamingSlashCD:Cancel()
		timerLavaSwipeCD:Cancel()
	elseif cid == 80808 then--Neesa Nox
		timerOgreTrapsCD:Cancel()
	elseif cid == 80816 then
		timerSanguineSphere:Cancel()
	end
end
