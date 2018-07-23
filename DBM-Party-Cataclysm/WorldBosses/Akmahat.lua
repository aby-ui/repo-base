local mod	= DBM:NewMod("Akmahat", "DBM-Party-Cataclysm", 15)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 184 $"):sub(12, -3))
mod:SetCreatureID(50063)
mod:SetModelID(34573)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED"
)
mod.onlyNormal = true

local warnShockwave			= mod:NewSpellAnnounce(94968, 2, nil, "Tank|Healer")
local warnSandsofTime		= mod:NewTargetAnnounce(93578, 2)
local warnFuryofSands		= mod:NewSpellAnnounce(94946, 3)
local warnMantle			= mod:NewSpellAnnounce(93561, 4)

local specWarnFuryofSands	= mod:NewSpecialWarningSpell(94946, nil, nil, nil, 2)
local specWarnMantle		= mod:NewSpecialWarningSpell(93561)

local timerShockwaveCD		= mod:NewCDTimer(16, 94968)--Every 16 seconds shockwave and fury alternate unless mantle, is cast, then it's 18 seconds cause of the cast delay of mantle affecting both CDs
local timerFuryofSandsCD	= mod:NewCDTimer(16, 94946)
local timerSandsofTime		= mod:NewBuffFadesTimer(15, 93578)
local timerSandsofTimeCD	= mod:NewCDTimer(25, 93578)
local timerMantleCD			= mod:NewCDTimer(43, 93561, nil, nil, nil, 5)--42.8-46.5 variations. a CD timer will suffice of 43

local sandsTargets = {}
local sandsDebuffs = 0

local function showSandsgWarning()
	warnSandsofTime:Show(table.concat(sandsTargets, "<, >"))
	table.wipe(sandsTargets)
end

function mod:OnCombatStart(delay)
	timerMantleCD:Start(23-delay)--Highly variable, i don't like it
	timerShockwaveCD:Start(-delay)
	timerFuryofSandsCD:Start(11-delay)
	sandsDebuffs = 0
	table.wipe(sandsTargets)
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 93561 then
		warnMantle:Show()
		specWarnMantle:Show()
		timerMantleCD:Start()
	elseif args.spellId == 94946 then
		warnFuryofSands:Show()
		specWarnFuryofSands:Show()
		timerFuryofSandsCD:Start()
	elseif args.spellId == 94968 then
		warnShockwave:Show()
		timerShockwaveCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 93561 then
		--Do infoframe things
	elseif args.spellId == 93578 then
		sandsTargets[#sandsTargets + 1] = args.destName
		sandsDebuffs = sandsDebuffs + 1
		timerSandsofTime:Start()
		timerSandsofTimeCD:Start()
		self:Unschedule(showSandsgWarning)
		self:Schedule(0.3, showSandsgWarning)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 93561 then
		--End infoframe things
	elseif args.spellId == 93578 then
		sandsDebuffs = sandsDebuffs - 1
		if sandsDebuffs == 0 then
			timerSandsofTime:Cancel()
		end
	end
end
