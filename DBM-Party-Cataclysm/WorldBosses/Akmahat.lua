local mod	= DBM:NewMod("Akmahat", "DBM-Party-Cataclysm", 15)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(50063)
mod:SetModelID(34573)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 93561 94946 94968",
	"SPELL_AURA_APPLIED 93561 93578",
	"SPELL_AURA_REMOVED 93561 93578"
)
mod.onlyNormal = true

local warnShockwave			= mod:NewSpellAnnounce(94968, 2, nil, "Tank|Healer")
local warnSandsofTime		= mod:NewTargetNoFilterAnnounce(93578, 2)

local specWarnFuryofSands	= mod:NewSpecialWarningDodge(94946, nil, nil, nil, 2, 2)
local specWarnMantle		= mod:NewSpecialWarningSpell(93561, nil, nil, nil, 1, 2)

local timerShockwaveCD		= mod:NewCDTimer(16, 94968, nil, nil, nil, 3)--Every 16 seconds shockwave and fury alternate unless mantle, is cast, then it's 18 seconds cause of the cast delay of mantle affecting both CDs
local timerFuryofSandsCD	= mod:NewCDTimer(16, 94946, nil, nil, nil, 3)
local timerSandsofTime		= mod:NewBuffFadesTimer(15, 93578, nil, "Healer", nil, 5, nil, DBM_CORE_HEALER_ICON..DBM_CORE_MAGIC_ICON)
local timerSandsofTimeCD	= mod:NewCDTimer(25, 93578, nil, nil, nil, 3, nil, DBM_CORE_MAGIC_ICON)
local timerMantleCD			= mod:NewCDTimer(43, 93561, nil, nil, nil, 5, nil, DBM_CORE_DAMAGE_ICON)--42.8-46.5 variations. a CD timer will suffice of 43

local sandsTargets = {}
mod.vb.sandsDebuffs = 0

local function showSandsgWarning()
	warnSandsofTime:Show(table.concat(sandsTargets, "<, >"))
	table.wipe(sandsTargets)
end

function mod:OnCombatStart(delay)
	timerMantleCD:Start(23-delay)--Highly variable, i don't like it
	timerShockwaveCD:Start(-delay)
	timerFuryofSandsCD:Start(11-delay)
	self.vb.sandsDebuffs = 0
	table.wipe(sandsTargets)
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 93561 then
		specWarnMantle:Show()
		specWarnMantle:Play("attackshield")
		timerMantleCD:Start()
	elseif args.spellId == 94946 then
		specWarnFuryofSands:Show()
		specWarnFuryofSands:Play("watchstep")
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
		self.vb.sandsDebuffs = self.vb.sandsDebuffs + 1
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
		self.vb.sandsDebuffs = self.vb.sandsDebuffs - 1
		if self.vb.sandsDebuffs == 0 then
			timerSandsofTime:Cancel()
		end
	end
end
