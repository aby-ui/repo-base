local mod	= DBM:NewMod(1208, "DBM-Party-WoD", 5, 556)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "normal,heroic,mythic,challenge,timewalker"

mod:SetRevision("20220116042005")
mod:SetCreatureID(82682)
mod:SetEncounterID(1751)--TODO: Verify, Label was "Boss 3"

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 168885",
	"SPELL_AURA_APPLIED 166492 166572 166726 166475 166476 166477",
	"SPELL_INTERRUPT"
)

--Again, too lazy to work on CD timers, someone else can do it. raid mods are putting too much strain on me to give 5 man mods as much attention
--Probalby should also add a close warning for Frozen Rain
local warnFrostPhase			= mod:NewSpellAnnounce(166476, 2, nil, nil, nil, nil, nil, 2)
local warnArcanePhase			= mod:NewSpellAnnounce(166477, 2, nil, nil, nil, nil, nil, 2)

local specWarnParasiticGrowth	= mod:NewSpecialWarningCount(168885, "Tank")--No voice ideas for this
--local specWarnFireBloom			= mod:NewSpecialWarningSpell(166492, nil, nil, nil, 2)
local specWarnFrozenRainMove	= mod:NewSpecialWarningMove(166726, nil, nil, nil, 1, 8)

local timerParasiticGrowthCD	= mod:NewCDCountTimer(11.5, 168885, nil, "Tank|Healer", 2, 5, nil, DBM_COMMON_L.TANK_ICON)--Every 12 seconds unless comes off cd during fireball/frostbolt, then cast immediately after.

mod.vb.ParasiteCount = 0

function mod:OnCombatStart(delay)
	self.vb.ParasiteCount = 0
	timerParasiticGrowthCD:Start(32.5-delay, 1)
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 168885 then
		self.vb.ParasiteCount = self.vb.ParasiteCount + 1
		specWarnParasiticGrowth:Show(self.vb.ParasiteCount)
		timerParasiticGrowthCD:Stop()
		timerParasiticGrowthCD:Start(nil, self.vb.ParasiteCount+1)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	--if args:IsSpellID(166492, 166572) and self:AntiSpam(12) then--Because the dumb spell has no cast Id, we can only warn when someone gets hit by one of rings.
		--specWarnFireBloom:Show()
		--specWarnFireBloom:Play("firecircle")
	if spellId == 166726 and args:IsPlayer() and self:AntiSpam(2) then--Because dumb spell has no cast Id, we can only warn when people get debuff from standing in it.
		specWarnFrozenRainMove:Show()
		specWarnFrozenRainMove:Play("watchfeet")
	elseif spellId == 166476 then
		warnFrostPhase:Show()
		warnFrostPhase:Play("ptwo")
	elseif spellId == 166477 then
		warnArcanePhase:Show()
		warnArcanePhase:Play("pthree")
	end
end

function mod:SPELL_INTERRUPT(args)
	if type(args.extraSpellId) == "number" and args.extraSpellId == 168885 then
		timerParasiticGrowthCD:Stop()
		self.vb.ParasiteCount = 0
		timerParasiticGrowthCD:Start(30, 1)
	end
end
