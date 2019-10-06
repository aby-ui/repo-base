local mod	= DBM:NewMod(341, "DBM-Party-Cataclysm", 14, 186)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(54938)
mod:SetEncounterID(1339)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_DAMAGE",
	"SPELL_MISSED",
	"UNIT_HEALTH"
)

mod:RegisterEvents(
	"CHAT_MSG_MONSTER_SAY"
)
mod.onlyHeroic = true

local warnRighteousShear		= mod:NewTargetNoFilterAnnounce(103151, 2, nil, "Healer", 2)
local warnPurifyingLight		= mod:NewSpellAnnounce(103565, 3)
local prewarnPhase2				= mod:NewPrePhaseAnnounce(2, 2)
local warnTwilightShear			= mod:NewTargetNoFilterAnnounce(103363, 2, nil, "Healer", 2)
local warnCorruptingTwilight	= mod:NewSpellAnnounce(103767, 3)

local specwarnPurified			= mod:NewSpecialWarningMove(103653, nil, nil, nil, 1, 8)
local specwarnWaveVirtue		= mod:NewSpecialWarningMoveTo(103678, nil, nil, nil, 2)
local specwarnTwilight			= mod:NewSpecialWarningMove(103775, nil, nil, nil, 1, 8)
local specwarnWaveTwilight		= mod:NewSpecialWarningMoveTo(103780, nil, nil, nil, 2)

local timerCombatStart			= mod:NewTimer(51.5, "TimerCombatStart", 2457)
local timerWaveVirtueCD			= mod:NewNextTimer(30, 103678, nil, nil, nil, 2)--Will he do it more then once? if you are terrible and take > 30 sec to push him?
local timerWaveTwilightCD		= mod:NewNextTimer(30, 103780, nil, nil, nil, 2)--^

local warnedP2 = false
local waterShellName = DBM:GetSpellInfo(103744)

function mod:OnCombatStart(delay)
	warnedP2 = false
	timerWaveVirtueCD:Start(-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 103151 then
		warnRighteousShear:Show(args.destName)
	elseif args.spellId == 103565 then
		warnPurifyingLight:Show()
	elseif args:IsSpellID(103677, 103680, 103681) then--Spellids are locationsal. So figure out which one is switch could announce wave direction?
		specwarnWaveVirtue:Show(waterShellName)
		specwarnWaveVirtue:Play("findshelter")
	elseif args.spellId == 103363 then
		warnTwilightShear:Show(args.destName)
	elseif args.spellId == 103767 then
		warnCorruptingTwilight:Show()
	elseif args:IsSpellID(103782, 103783, 103784) then--Same as virtue
		specwarnWaveTwilight:Show(waterShellName)
		specwarnWaveTwilight:Play("findshelter")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 103754 then--Phase change from holy to shadow.
		timerWaveVirtueCD:Cancel()--Cancel this timer if he was pushed before he got to do it, which is entirely possible.
		timerWaveTwilightCD:Start(35)--Is this cast more then once?
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 103653 and destGUID == UnitGUID("player") and self:AntiSpam(5) then
		specwarnPurified:Show()
		specwarnPurified:Play("watchfeet")
	elseif spellId == 103775 and destGUID == UnitGUID("player") and self:AntiSpam(5) then
		specwarnTwilight:Show()
		specwarnTwilight:Play("watchfeet")
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 54938 then
		local h = UnitHealth(uId) / UnitHealthMax(uId) * 100
		if h > 80 and warnedP2 then
			warnedP2 = false
		elseif not warnedP2 and h > 63 and h < 67 then
			warnedP2 = true
			prewarnPhase2:Show()
		end
	end
end

--: 14:05:48.764

-- Timers from 2 logs so they most likely are incorrect :)  (?? = unknown, didnt happen)
-- "Holy" timers: X secs after combat start
	-- 1st Purifying Light after [4 or 5] secs

-- "Shadow" timers:  X secs after SPELL_AURA_APPLIED event for Twilight Epiphany
	-- 1st Twilight Shear after [15 or 12] secs
	-- 1st Corrupting Twilight after [17 or 17] secs

function mod:CHAT_MSG_MONSTER_SAY(msg)
	if msg == L.Event or msg:find(L.Event) then
		timerCombatStart:Start()
	end
end
