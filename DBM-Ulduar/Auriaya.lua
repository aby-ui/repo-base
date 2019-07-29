local mod	= DBM:NewMod("Auriaya", "DBM-Ulduar")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417005949")

mod:SetCreatureID(33515)--34014--Add this (kitties) to pull detection when it can be ignored in kill
mod:SetEncounterID(1131)
mod:SetModelID(28651)
mod:RegisterCombat("combat")
--mod:RegisterKill("kill", 33515)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 64678 64389 64386 64688 64422",
	"SPELL_AURA_APPLIED 64396",
	"SPELL_DAMAGE 64459 64675",
	"SPELL_MISSED 64459 64675",
	"UNIT_DIED"
)

local warnSwarm 		= mod:NewTargetAnnounce(64396, 2)
local warnFearSoon	 	= mod:NewSoonAnnounce(64386, 1)
local warnCatDied 		= mod:NewAnnounce("WarnCatDied", 3, 64455)
local warnCatDiedOne	= mod:NewAnnounce("WarnCatDiedOne", 3, 64455)

local specWarnFear		= mod:NewSpecialWarningSpell(64386, nil, nil, nil, 2, 2)
local specWarnBlast		= mod:NewSpecialWarningInterrupt(64389, "HasInterrupt", nil, 2, 1, 2)
local specWarnVoid 		= mod:NewSpecialWarningMove(64675, nil, nil, nil, 1, 2)
local specWarnSonic		= mod:NewSpecialWarningMoveTo(64688, nil, nil, nil, 2, 2)

local enrageTimer		= mod:NewBerserkTimer(600)
local timerDefender 	= mod:NewTimer(35, "timerDefender", 64455, nil, nil, 1)
local timerNextFear 	= mod:NewNextTimer(35.5, 64386, nil, nil, nil, 4)
local timerNextSwarm 	= mod:NewNextTimer(36, 64396, nil, nil, nil, 1)
local timerNextSonic 	= mod:NewNextTimer(27, 64688, nil, nil, nil, 2)
local timerSonic		= mod:NewCastTimer(64688, nil, nil, nil, 2)

mod.vb.catLives = 9

function mod:OnCombatStart(delay)
	mod.vb.catLives = 9
	enrageTimer:Start(-delay)
	timerNextFear:Start(40-delay)
	timerNextSonic:Start(60-delay)
	timerDefender:Start(60-delay)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(64678, 64389) then -- Sentinel Blast
		specWarnBlast:Show(args.sourceName)
		specWarnBlast:Play("kickcast")
	elseif args.spellId == 64386 then -- Terrifying Screech
		specWarnFear:Show()
		specWarnFear:Play("fearsoon")
		timerNextFear:Schedule(2)
		warnFearSoon:Schedule(34)
	elseif args:IsSpellID(64688, 64422) then --Sonic Screech
		specWarnSonic:Show(TANK)
		specWarnSonic:Play("gathershare")
		timerSonic:Start()
		timerNextSonic:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 64396 then -- Guardian Swarm
		warnSwarm:Show(args.destName)
		timerNextSwarm:Start()
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if (spellId == 64459 or spellId == 64675) and destGUID == UnitGUID("player") and self:AntiSpam(3) then -- Feral Defender Void Zone
		specWarnVoid:Show()
		specWarnVoid:Play("runaway")
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 34035 then
		self.vb.catLives = self.vb.catLives - 1
		if self.vb.catLives > 0 then
			if self.vb.catLives == 1 then
				warnCatDiedOne:Show()
				timerDefender:Start()
			else
				warnCatDied:Show(self.vb.catLives)
				timerDefender:Start()
         	end
		end
	end
end
