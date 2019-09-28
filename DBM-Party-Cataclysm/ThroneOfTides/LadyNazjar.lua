local mod	= DBM:NewMod(101, "DBM-Party-Cataclysm", 9, 65)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(40586)
mod:SetEncounterID(1045)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 80564",
	"SPELL_AURA_REMOVED 75690 80564",
	"SPELL_CAST_START 75863 76008",
	"SPELL_CAST_SUCCESS 75700 75722",
	"UNIT_HEALTH boss1"
)

local warnWaterspout		= mod:NewSpellAnnounce(75863, 3)
local warnWaterspoutSoon	= mod:NewSoonAnnounce(75863, 2)
local warnGeyser			= mod:NewSpellAnnounce(75722, 3)
local warnFungalSpores		= mod:NewTargetNoFilterAnnounce(80564, 3, nil, "RemoveDisease", 2)

local specWarnShockBlast	= mod:NewSpecialWarningInterrupt(76008, nil, nil, nil, 1, 2)

local timerWaterspout		= mod:NewBuffActiveTimer(60, 75863, nil, nil, nil, 6)
local timerShockBlastCD		= mod:NewCDTimer(13, 76008, nil, "HasInterrupt", 2, 4, nil, DBM_CORE_INTERRUPT_ICON)
local timerGeyser			= mod:NewCastTimer(5, 75722, nil, nil, nil, 3)
local timerFungalSpores		= mod:NewBuffFadesTimer(15, 80564, nil, "RemoveDisease", 2, 5, nil, DBM_CORE_DISEASE_ICON)

local sporeTargets = {}
mod.vb.sporeCount = 0
local preWarnedWaterspout = false

function mod:OnCombatStart()
	table.wipe(sporeTargets)
	self.vb.sporeCount = 0
	preWarnedWaterspout = false
end

local function showSporeWarning()
	warnFungalSpores:Show(table.concat(sporeTargets, "<, >"))
	table.wipe(sporeTargets)
	timerFungalSpores:Start()
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 80564 then
		self.vb.sporeCount = self.vb.sporeCount + 1
		sporeTargets[#sporeTargets + 1] = args.destName
		self:Unschedule(showSporeWarning)
		self:Schedule(0.3, showSporeWarning)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 75690 then
		timerWaterspout:Cancel()
		timerShockBlastCD:Start(13)
	elseif args.spellId == 80564 then
		self.vb.sporeCount = self.vb.sporeCount - 1
		if self.vb.sporeCount == 0 then
			timerFungalSpores:Cancel()
		end	
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 75863 then
		warnWaterspout:Show()
		timerWaterspout:Start()
		timerShockBlastCD:Cancel()
	elseif args.spellId == 76008 then
		if self:CheckInterruptFilter(args.sourceGUID, false, true, true) then
			specWarnShockBlast:Show(args.sourceName)
			specWarnShockBlast:Play("kickcast")
		end
		timerShockBlastCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(75700, 75722) then
		warnGeyser:Show()
		timerGeyser:Start()
	end
end

function mod:UNIT_HEALTH(uId)
	local h = UnitHealth(uId) / UnitHealthMax(uId) * 100
	if (h > 80) or (h > 45 and h < 60) then
		preWarnedWaterspout = false
	elseif (h < 75 and h > 72 or h < 41 and h > 38) and not preWarnedWaterspout then
		preWarnedWaterspout = true
		warnWaterspoutSoon:Show()
	end
end