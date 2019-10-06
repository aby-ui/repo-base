local mod	= DBM:NewMod(100, "DBM-Party-Cataclysm", 6, 64)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(46964)
mod:SetEncounterID(1072)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 93675 93707 93629",
	"SPELL_AURA_APPLIED_DOSE 93675",
	"SPELL_CAST_START 93520"
)

local warnMortalWound			= mod:NewStackAnnounce(93675, 2, nil, "Tank|Healer")
local warnGhouls				= mod:NewSpellAnnounce(93707, 4)
local warnPistolBarrage			= mod:NewSpellAnnounce(93520, 4)

local specWarnMortalWound		= mod:NewSpecialWarningStack(93675, nil, 5, nil, nil, 1, 6)
local specWarnCursedBullets		= mod:NewSpecialWarningDispel(93629, "RemoveCurse", nil, 2, 1, 2)

local timerGhouls				= mod:NewNextTimer(30, 93707, nil, nil, nil, 1)
local timerPistolBarrage		= mod:NewBuffActiveTimer(6, 93520, nil, nil, nil, 3)
local timerPistolBarrageNext	= mod:NewNextTimer(30, 93520, nil, nil, nil, 3, nil, DBM_CORE_HEROIC_ICON)

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 93675 then
		warnMortalWound:Show(args.destName, args.amount or 1)
		if args:IsPlayer() and (args.amount or 1) >= 5 then
			specWarnMortalWound:Show(args.amount)
			specWarnMortalWound:Play("stackhigh")
		end
	elseif args.spellId == 93707 then
		warnGhouls:Show()
		timerGhouls:Start()
	elseif args.spellId == 93629 and self:CheckDispelFilter() then
		specWarnCursedBullets:Show(args.destName)
		specWarnCursedBullets:Play("helpdispel")
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_CAST_START(args)
	if args.spellId == 93520 then
		warnPistolBarrage:Show()
		timerPistolBarrage:Start()
		timerPistolBarrageNext:Start()
	end
end