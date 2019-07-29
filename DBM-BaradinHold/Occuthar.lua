local mod	= DBM:NewMod(140, "DBM-BaradinHold", nil, 74)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417005904")
mod:SetCreatureID(52363)
mod:SetEncounterID(1250)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_DAMAGE",
	"SPELL_PERIODIC_DAMAGE",
	"RANGE_DAMAGE",
	"SWING_DAMAGE"
)

local warnSearingShadows		= mod:NewSpellAnnounce(96913, 2)
local warnEyes					= mod:NewSpellAnnounce(96920, 3)

local specWarnSearingShadows	= mod:NewSpecialWarningSpell(96913, "Tank")
local specWarnFocusedFire		= mod:NewSpecialWarningMove(97212)

local timerSearingShadows		= mod:NewCDTimer(24, 96913, nil, "Tank", 2, 5, nil, DBM_CORE_TANK_ICON)
local timerEyes					= mod:NewCDTimer(57.5, 96920, nil, nil, nil, 1)
local timerFocusedFire			= mod:NewCDTimer(16, 96884, nil, nil, nil, 3) -- 24 16 16, repeating pattern. Can vary by a couple seconds, ie be 26 18 18, but the pattern is same regardless.

local berserkTimer				= mod:NewBerserkTimer(300)

local focusedCast = 0

function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
	timerSearingShadows:Start(6-delay)--Need transcriptor to see what first one always is to be sure.
	timerEyes:Start(23-delay)--Need transcriptor to see what first one always is to be sure.
	timerFocusedFire:Start(-delay)--Need transcriptor to see what first one always is to be sure.
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 96920 then
		warnEyes:Show()
		timerEyes:Start()
		focusedCast = 0
		timerFocusedFire:Start()--eyes resets the CD of focused. Blizz hotfix makes more sense now.
	elseif args.spellId == 96913 then
		warnSearingShadows:Show()
		timerSearingShadows:Start()
		specWarnSearingShadows:Schedule(3.2)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 96884 then
		focusedCast = focusedCast + 1
		if focusedCast < 3 then--Don't start it after 3rd cast since eyes will be cast next and reset the CD, we start a bar there instead.
			timerFocusedFire:Start()
		end
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, _, _, _, overkill)
	if spellId == 97212 and destGUID == UnitGUID("player") and self:AntiSpam(3) then--Is this even right one? 96883, 101004 are ones that do a lot of damage?
		specWarnFocusedFire:Show()
	elseif (overkill or 0) > 0 then
		if self:GetCIDFromGUID(destGUID) == 52363 then--Hack cause occuthar doesn't die in combat log since 4.2. SO we look for a killing blow that has overkill.
			DBM:EndCombat(self)
		end
	end
end
mod.SPELL_PERIODIC_DAMAGE = mod.SPELL_DAMAGE
mod.RANGE_DAMAGE = mod.SPELL_DAMAGE

function mod:SPELL_MISSED(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 97212 and destGUID == UnitGUID("player") and self:AntiSpam(3) then--Is this even right one? 96883, 101004 are ones that do a lot of damage?
		specWarnFocusedFire:Show()
	end
end

function mod:SWING_DAMAGE(_, _, _, _, destGUID, _, _, _, _, overkill)
	if (overkill or 0) > 0 then
		if self:GetCIDFromGUID(destGUID) == 52363 then--Hack cause occuthar doesn't die in combat log since 4.2. SO we look for a killing blow that has overkill.
			DBM:EndCombat(self)
		end
	end
end
