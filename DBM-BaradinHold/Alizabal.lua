local mod	= DBM:NewMod(339, "DBM-BaradinHold", nil, 74)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143316")
mod:SetCreatureID(55869)
mod:SetEncounterID(1332)
--mod:SetModelSound("sound\\CREATURE\\ALIZABAL\\VO_BH_ALIZABAL_INTRO_01.OGG", "sound\\CREATURE\\ALIZABAL\\VO_BH_ALIZABAL_RESET_01.OGG")
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED"
)

local warnBladeDance			= mod:NewSpellAnnounce(104995, 4)
local warnSkewer				= mod:NewTargetAnnounce(104936, 4, nil, "Tank|Healer")
local warnSeethingHate			= mod:NewTargetAnnounce(105067, 3)

local specWarnBladeDance		= mod:NewSpecialWarningRun(104995, nil, nil, nil, 4)
local specWarnSkewer			= mod:NewSpecialWarningSpell(104936, "Tank|Healer")
local specWarnSeethingHate		= mod:NewSpecialWarningYou(105067, "Tank")--off tank may need this warn. 

local timerBladeDance			= mod:NewBuffActiveTimer(15, 104995, nil, nil, nil, 6)
local timerBladeDanceCD			= mod:NewCDTimer(60, 104995, nil, nil, nil, 6)
local timerFirstSpecial			= mod:NewTimer(8, "TimerFirstSpecial", "136116")--Whether she casts skewer or seething after a blade dance is random. This generic timer just gives you a timer for whichever she'll do.
local timerSkewer				= mod:NewTargetTimer(8, 104936, nil, false, 2, 5, nil, DBM_CORE_TANK_ICON)
local timerSkewerCD				= mod:NewNextTimer(20.5, 104936, nil, "Tank", 2, 5, nil, DBM_CORE_TANK_ICON)
local timerSeethingHate			= mod:NewTargetTimer(9, 105067)
local timerSeethingHateCD		= mod:NewNextTimer(20.5, 105067, nil, nil, nil, 3)

local berserkTimer				= mod:NewBerserkTimer(300)

local firstspecial = false
local firstskewer = true
local firstseething = true
local bladeCasts = 0

function mod:OnCombatStart(delay)
	firstspecial = false
	firstskewer = true
	firstseething = true
	bladeCasts = 0
	timerFirstSpecial:Start(5.5-delay)
	timerBladeDanceCD:Start(26-delay) -- first blade dance variables 26~40 sec (sigh blizz sucks, it was always 35 on PTR)
	berserkTimer:Start(-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 104936 then
		if not firstspecial then--First special ability used after a blade dance, so the OTHER special is going to be cast in 8 seconds.
			timerFirstSpecial:Cancel()
			timerSeethingHateCD:Start(8)
			firstspecial = true
		end
		if not firstskewer then--First cast after blade dance, so there will be a 2nd cast in 20 seconds.
			timerSkewerCD:Start()
			firstskewer = true
		end
		warnSkewer:Show(args.destName)
		timerSkewer:Start(args.destName)
		specWarnSkewer:Show()
	elseif args.spellId == 105067 then--10m ID confirmed
		if not firstspecial then--First special ability used after a blade dance, so the OTHER special is going to be cast in 8 seconds.
			timerFirstSpecial:Cancel()
			timerSkewerCD:Start(8)
			firstspecial = true
		end
		if not firstseething then--First cast after blade dance, so there will be a 2nd cast in 20 seconds.
			timerSeethingHateCD:Start()
			firstseething = true
		end
		warnSeethingHate:Show(args.destName)
		timerSeethingHate:Start(args.destName)
		if args:IsPlayer() then		
			specWarnSeethingHate:Show()
		end
	elseif args.spellId == 105784 then--It seems the cast ID was disabled on live, so now gotta do this the dumb way.
		bladeCasts = bladeCasts + 1
		if bladeCasts > 1 then return end
		warnBladeDance:Show()
		specWarnBladeDance:Show()
		timerBladeDance:Start()
		if self:IsInCombat() then--Only start this on actual boss, not trash
			timerBladeDanceCD:Start()
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 105784 then
		if bladeCasts < 3 then return end
		firstspecial = false
		firstskewer = false
		firstseething = false
		bladeCasts = 0
		timerBladeDance:Cancel()
		timerFirstSpecial:Start()
	elseif args.spellId == 104936 then
		timerSkewer:Cancel(args.destName)
	elseif args.spellId == 105067 then
		timerSeethingHate:Cancel(args.destName)
	end
end
