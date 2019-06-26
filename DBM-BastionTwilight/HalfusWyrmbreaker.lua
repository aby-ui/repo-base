local mod	= DBM:NewMod(156, "DBM-BastionTwilight", nil, 72)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143316")
mod:SetCreatureID(44600)
mod:SetEncounterID(1030)
mod:SetZone()
--mod:SetModelSound("Sound\\Creature\\Chogall\\VO_BT_Chogall_BotEvent02.ogg", "Sound\\Creature\\Halfus\\VO_BT_Halfus_Event07.ogg")
--Long: Halfus! Hear me! The master calls, the master wants! Protect our secrets, Halfus! Destroy the intruders! Murder for his glory, murder for his hunger!
--Short: Dragons to my side!

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_CAST_START"
)

local warnBreath			= mod:NewSpellAnnounce(83707, 3)
local warnVengeance			= mod:NewSpellAnnounce(87683, 3)
local warnParalysis			= mod:NewSpellAnnounce(84030, 2)
local warnMalevolentStrike	= mod:NewStackAnnounce(83908, 2, nil, "Tank|Healer")

local specWarnFuriousRoar	= mod:NewSpecialWarningSpell(83710, nil, nil, nil, 2)
local specWarnShadowNova	= mod:NewSpecialWarningInterrupt(83703, "HasInterrupt")
local specWarnMalevolent	= mod:NewSpecialWarningStack(83908, nil, 8)

local timerFuriousRoar		= mod:NewCDTimer(30, 83710, nil, nil, nil, 2)
local timerBreathCD			= mod:NewCDTimer(20, 83707, nil, nil, nil, 2)--every 20-25 seconds.
local timerParalysis		= mod:NewBuffActiveTimer(12, 84030)
local timerParalysisCD		= mod:NewCDTimer(35, 84030)
local timerNovaCD			= mod:NewCDTimer(7.2, 83703, nil, "HasInterrupt", 2, 4, nil, DBM_CORE_INTERRUPT_ICON)--7.2 is actually exact next timer, but since there are other variables like roars, or paralysis that could mis time it, we use CD bar instead so we don't give false idea of precision.
local timerMalevolentStrike	= mod:NewTargetTimer(30, 83908, nil, "Tank|Healer", nil, 5, nil, DBM_CORE_TANK_ICON)

local berserkTimer			= mod:NewBerserkTimer(360)

function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
	if mod:IsDifficulty("heroic10", "heroic25") then--On heroic we know for sure the drake has breath ability.
		timerBreathCD:Start(10-delay)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 87683 then
		warnVengeance:Show()
	elseif args.spellId == 84030 then
		warnParalysis:Show()
		timerParalysis:Start()
		timerParalysisCD:Start()
	elseif args.spellId == 83908 then
		timerMalevolentStrike:Start(args.destName)
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args.spellId == 87683 then
		warnVengeance:Show()
	elseif args.spellId == 83908 then
		local amount = args.amount or 1
		timerMalevolentStrike:Start(args.destName)
		if amount % 4 == 0 or amount >= 10 then		-- warn every 4th stack and every stack if 10 or more
			warnMalevolentStrike:Show(args.destName, amount)
		end
		if args:IsPlayer() and amount >= 8 then
			specWarnMalevolent:Show(amount)
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 83710 and self:AntiSpam(6) then
		specWarnFuriousRoar:Show()
		timerFuriousRoar:Cancel()--We Cancel any scheduled roar timers before doing anything else.
		timerFuriousRoar:Start()--And start a fresh one.
		timerFuriousRoar:Schedule(30)--If it comes off CD while he's stunned by paralysis, he no longer waits to casts it after stun, it now consumes his CD as if it was cast on time. This is why we schedule this timer. So we get a timer for next roar after a stun.
	elseif args.spellId == 83707 then
		warnBreath:Show()
		timerBreathCD:Start()
	elseif args.spellId == 83703 then
		specWarnShadowNova:Show(args.sourceName)
		timerNovaCD:Start()
	end
end
