local mod	= DBM:NewMod("d647", "DBM-Scenario-MoP")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("2019041710000")
mod:SetZone()

mod:RegisterCombat("scenario", 1144)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"CHAT_MSG_MONSTER_YELL",
	"UNIT_SPELLCAST_SUCCEEDED target focus"
)

--Trash (and somewhat Urtharges)
local warnStoneRain				= mod:NewSpellAnnounce(142139, 3)--Hit debuff, interrupt or move out of it
local warnSpellShatter			= mod:NewCastAnnounce(141421, 3, 2, nil, "SpellCaster", 2)--Spell interrupt. Cast time is long enough to /stopcasting this
local warnSummonFieryAnger		= mod:NewCastAnnounce(141488, 3, 2.5)
local warnDetonate				= mod:NewCastAnnounce(141456, 4, 5)--Can kill or run away from. It's actually more practical to ignore it and let it kill itself to speed up run
--Urtharges the Destroyer
local warnRuptureLine			= mod:NewTargetAnnounce(141418, 3)
local warnCallElemental			= mod:NewSpellAnnounce(141872, 4)
--Echo of Y'Shaarj
local warnMalevolentForce		= mod:NewCastAnnounce(142840, 4, 2)

--Trash (and somewhat Urtharges)
local specWarnStoneRain			= mod:NewSpecialWarningSpell(142139, nil, nil, nil, 2)--Let you choose to interrupt it or move out of it.
local specWarnSpellShatter		= mod:NewSpecialWarningCast(141421, "SpellCaster", nil, 3)
local specWarnSummonFieryAnger	= mod:NewSpecialWarningInterrupt(141488)
local specWarnDetonate			= mod:NewSpecialWarningRun(141456)--Technically can kill it too vs run, but I favor run strategy more.
--Urtharges the Destroyer
local specWarnRuptureLine		= mod:NewSpecialWarningMove(141418)
local specWarnCallElemental		= mod:NewSpecialWarningSpell(141872)
--Echo of Y'Shaarj
local specWarnMalevolentForce	= mod:NewSpecialWarningInterrupt(142840)--Not only cast by last boss but trash near him as well, interrupt important for both. Although only bosses counts for achievement.

--Trash
local timerSpellShatter			= mod:NewCastTimer(2, 141421, nil, "SpellCaster")

function mod:SPELL_CAST_START(args)
	if args.spellId == 142139 and self:AntiSpam(3, 1) then
		warnStoneRain:Show()
		specWarnStoneRain:Show()
	elseif args.spellId == 141421 then
		warnSpellShatter:Show()
		specWarnSpellShatter:Show()
		timerSpellShatter:Start(nil, args.sourceGUID)
	elseif args.spellId == 141421 and self:AntiSpam(3, 2) then
		warnSummonFieryAnger:Show()
		specWarnSummonFieryAnger:Show(args.sourceName)
	elseif args.spellId == 142840 then
		warnMalevolentForce:Show()
		specWarnMalevolentForce:Show(args.sourceName)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 141418 then
		warnRuptureLine:Show(args.destName)
		if args:IsPlayer() then
			specWarnRuptureLine:Show()
		end
	elseif args.spellId == 141456 then
		warnDetonate:Show()
		specWarnDetonate:Show()
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 141872 and self:AntiSpam(3, 1) then--Call Elemental
		self:SendSync("CallElemental")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if (msg == L.summonElemental or msg:find(L.summonElemental)) and self:AntiSpam(3, 1) then
		self:SendSync("CallElemental")
	end
end

function mod:OnSync(msg)
	if msg == "CallElemental" then
		warnCallElemental:Show()
		specWarnCallElemental:Show()
	end
end
