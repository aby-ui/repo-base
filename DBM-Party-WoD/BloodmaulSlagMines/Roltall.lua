local mod	= DBM:NewMod(887, "DBM-Party-WoD", 2, 385)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(75786)
mod:SetEncounterID(1652)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 153247 152940 152939",
	"SPELL_AURA_APPLIED 153227",
	"SPELL_PERIODIC_DAMAGE 153227",
	"SPELL_ABSORBED 153227"
)

local warnHeatWave				= mod:NewSpellAnnounce(152940, 3, nil, nil, nil, nil, nil, 2)
local warnBurningSlag			= mod:NewSpellAnnounce(152939, 3)
local warnFieryBoulder			= mod:NewCountAnnounce(153247, 4)

local specWarnFieryBoulder		= mod:NewSpecialWarningCount(153247, nil, nil, 2, 2, 2)--Important to everyone
local specWarnBurningSlagFire	= mod:NewSpecialWarningMove(152939, nil, nil, 2, 1, 8)

local timerFieryBoulderCD		= mod:NewNextTimer(13.3, 153247, nil, nil, nil, 3)--13.3-13.4 Observed
local timerHeatWave				= mod:NewBuffActiveTimer(9.5, 152940, nil, nil, nil, 2)
local timerHeatWaveCD			= mod:NewNextTimer(9.5, 152940, nil, nil, nil, 2)--9.5-9.8 Observed
local timerBurningSlagCD		= mod:NewNextTimer(10.7, 152939, nil, nil, nil, 3)--10.7-11 Observed

mod.vb.boulderCount = 0
mod.vb.burningSlagCast = false--More robust than using a really huge anti spam, because this will work with recovery, antispam won't

function mod:OnCombatStart(delay)
	self.vb.boulderCount = 0
	self.vb.burningSlagCast = false
	timerFieryBoulderCD:Start(8-delay)
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 153247 then--Boulder
		if self.vb.burningSlagCast then self.vb.burningSlagCast = false end
		self.vb.boulderCount = self.vb.boulderCount + 1
		if self.vb.boulderCount == 1 then
			specWarnFieryBoulder:Show(self.vb.boulderCount)
			specWarnFieryBoulder:Play("153247")
		else
			warnFieryBoulder:Show(self.vb.boulderCount)
		end
		if self.vb.boulderCount == 3 then
			timerHeatWaveCD:Start()
			self.vb.boulderCount = 0
		else
			timerFieryBoulderCD:Start(3.5)--Not to be confused with cast timer, that's 3 seconds. The previous meteor WILL hit ground before next cast.
		end
	elseif spellId == 152940 then--Heat Wave
		warnHeatWave:Show()
		timerHeatWave:Start()
		timerBurningSlagCD:Start()
		warnHeatWave:Play("aesoon")
	elseif spellId == 152939 and not self.vb.burningSlagCast then--Burning Slag
		self.vb.burningSlagCast = true
		warnBurningSlag:Show()
		timerFieryBoulderCD:Start()
		--warnBurningSlag:Play("firecircle") not proper voice. disable.
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 153227 and args:IsPlayer() and self:AntiSpam(2, 1) then
		specWarnBurningSlagFire:Show()
		specWarnBurningSlagFire:Play("watchfeet")
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 153227 and destGUID == UnitGUID("player") and self:AntiSpam(2, 1) then
		specWarnBurningSlagFire:Show()
		specWarnBurningSlagFire:Play("watchfeet")
	end
end
mod.SPELL_ABSORBED = mod.SPELL_PERIODIC_DAMAGE
