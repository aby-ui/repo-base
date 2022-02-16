local mod	= DBM:NewMod(1706, "DBM-Nighthold", nil, 786)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220127091734")
mod:SetCreatureID(102263)
mod:SetEncounterID(1849)
mod:DisableESCombatDetection()--Remove if blizz fixes trash firing ENCOUNTER_START
mod:SetUsedIcons(8, 7, 6, 5, 4, 3, 2, 1)
--mod:SetHotfixNoticeRev(12324)
mod.respawnTime = 30

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 204275 204372 204316 204471",
	"SPELL_CAST_SUCCESS 204316",
	"SPELL_SUMMON 204292",
	"SPELL_AURA_APPLIED 204531 204459 204697 204744",
	"SPELL_AURA_REMOVED 204459 204697",
	"SPELL_PERIODIC_DAMAGE 204744",
	"SPELL_PERIODIC_MISSED 204744",
	"UNIT_SPELLCAST_SUCCEEDED boss1",
	"UNIT_SPELLCAST_INTERRUPTED boss1"
)

--TODO, Mythic Transform casts still push timers back by 3-6 seconds. timer correction gets even more tedius with that so feeling lazy about that for now.
--I believe he'll just use whatever abilities he's ready to use after his stun is gone. So maybe just extend timers that expire during stun, or just leave be.
--[[
(ability.id = 204372 or ability.id = 204316 or ability.id = 204471) and type = "begincast" or
ability.id = 204292 and type = "summon" or
ability.id = 204459
--]]
local warnBrokenShard				= mod:NewSpellAnnounce(204292, 2, nil, false, 2)
local warnVulnerable				= mod:NewTargetAnnounce(204459, 1)
local warnRed						= mod:NewSpellAnnounce(214661, 2)
local warnGreen						= mod:NewSpellAnnounce(214652, 2)
local warnBlue						= mod:NewSpellAnnounce(204292, 2)

local specWarnTether				= mod:NewSpecialWarningYou(204531, nil, nil, nil, 1, 12)
local specWarnArcanoslash			= mod:NewSpecialWarningDefensive(204275, "Tank", nil, nil, 1, 2)
local specWarnCallofScorp			= mod:NewSpecialWarningSwitch(204372, "Tank", nil, nil, 1, 2)--Determine common strat for dps switching
local specWarnFocusedBlast			= mod:NewSpecialWarningDodge(204471, nil, nil, nil, 2, 2)
local specWarnShockwave				= mod:NewSpecialWarningMoveTo(204316, nil, nil, nil, 3, 2)
local specWarnVulnerableStarted		= mod:NewSpecialWarningSwitch(204459, false, nil, nil, 1)
local specWarnVulnerableOver		= mod:NewSpecialWarningEnd(204459, false, nil, nil, 1)--Special warning because anything that came off cd during stun, is being cast immediately
local specWarnToxicChit				= mod:NewSpecialWarningMove(204744, nil, nil, nil, 1, 2)

local timerArcanoslashCD			= mod:NewCDTimer(9.6, 204275, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON)
local timerCallofScorpidCD			= mod:NewCDTimer(20.3, 204372, 88879, nil, nil, 1, nil, nil, nil, 2, 4)--20-22 Unless delayed by shockwave/stun then as high as 40
local timerShockwaveCD				= mod:NewCDTimer(57.9, 204316, nil, nil, nil, 2, nil, DBM_COMMON_L.DEADLY_ICON, nil, 1, 4)--58-60
local timerFocusedBlastCD			= mod:NewCDTimer(30.4, 204471, nil, nil, nil, 3, nil, nil, nil, 3, 4)--30-34 (32.8 NEW data)
local timerVulnerable				= mod:NewBuffFadesTimer(15, 204459, nil, nil, nil, 6)

mod:AddSetIconOption("SetIconOnVolatileScorpion", 204697, true, true)
mod:AddInfoFrameOption(204284)

mod.vb.volatileScorpCount = 0

local shardName, goodDebuff = DBM:GetSpellInfo(204292), DBM:GetSpellInfo(204284)

function mod:OnCombatStart(delay)
	self.vb.volatileScorpCount = 0
	timerArcanoslashCD:Start(5-delay)
	timerFocusedBlastCD:Start(13-delay)
	timerCallofScorpidCD:Start(-delay)--21.7
	timerShockwaveCD:Start(56.2-delay)--56.9
--	if self:IsMythic() then
--		timerVolatileFragments:Start(28-delay)
--	end
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 204275 and self:AntiSpam(5, 1) then
		if self:IsTanking("player", "boss1", nil, true) then
			specWarnArcanoslash:Show()
			specWarnArcanoslash:Play("defensive")
		end
		timerArcanoslashCD:Start()
	elseif spellId == 204372 then
		timerCallofScorpidCD:Start()
		if self.Options.SpecWarn204372switch and self:AntiSpam(3.5, 2) then--Even if enabled, only special warn once every 3.5 seconds
			specWarnCallofScorp:Show()
			specWarnCallofScorp:Play("killmob")
		end
	elseif spellId == 204316 then
		specWarnShockwave:Show(shardName)
		specWarnShockwave:Play("findshelter")
		--specWarnShockwave:CancelVoice()--In case boss stutter cases or starts cast over
		--specWarnShockwave:ScheduleVoice(3.5, "safenow")
		timerShockwaveCD:Start()
		local scorptAdjust = 11
		local blastElapsed, blastTotal = timerFocusedBlastCD:GetTime()
		local blastRemaining = blastTotal - blastElapsed
		if blastRemaining < 11 then--delayed by shockwave
			scorptAdjust = 14--Blast will always come before scorpid, if blast takes 11 second spot, scorpid is pushed to 14sec spot
			timerFocusedBlastCD:Stop()
			if blastTotal == 0 then--Just in case timer expired just before cast
				DBM:Debug("experimental timer extend firing for Focused Blast. Extend amount: "..11, 2)
				timerFocusedBlastCD:Start(11)
			else
				local extend = 11 - blastTotal
				DBM:Debug("experimental timer extend firing for Focused Blast. Extend amount: "..extend, 2)
				timerFocusedBlastCD:Update(blastElapsed, blastTotal+extend)
			end
		end
		local elapsed, total = timerCallofScorpidCD:GetTime()
		local remaining = total - elapsed
		if remaining < scorptAdjust then--delayed by shockwave
			timerCallofScorpidCD:Stop()
			if total == 0 then--Just in case timer expired just before cast
				DBM:Debug("experimental timer extend firing for call of scorpid. Extend amount: "..scorptAdjust, 2)
				timerCallofScorpidCD:Start(scorptAdjust)
			else
				local extend = scorptAdjust - remaining
				DBM:Debug("experimental timer extend firing for call of scorpid. Extend amount: "..extend, 2)
				timerCallofScorpidCD:Update(elapsed, total+extend)
			end
		end
		if self.Options.InfoFrame then
			DBM.InfoFrame:SetHeader(DBM_COMMON_L.NO_DEBUFF:format(goodDebuff))
			DBM.InfoFrame:Show(5, "playergooddebuff", goodDebuff)
		end
	elseif spellId == 204471 then
		specWarnFocusedBlast:Show()
		specWarnFocusedBlast:Play("watchstep")
		timerFocusedBlastCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 204316 and self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_SUMMON(args)
	local spellId = args.spellId
	if spellId == 204292 then
		warnBrokenShard:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 204531 then
		if args:IsPlayer() then
			specWarnTether:Show()
			specWarnTether:Play("breakchain")
		end
	elseif spellId == 204459 then
		if self.Options.SpecWarn204459switch then
			specWarnVulnerableStarted:Show()
		else
			warnVulnerable:Show(args.destName)
		end
		timerVulnerable:Start()
		timerFocusedBlastCD:Stop()
		timerCallofScorpidCD:Stop()
		local shockwaveElapsed, shockwaveTotal = timerShockwaveCD:GetTime()
		local shockwaveRemaining = shockwaveTotal - shockwaveElapsed
		if shockwaveRemaining < 14 then
			--Shockwave immediately coming out of stun
			--Shockwave will trigger new timers for scorpid and focused blast
			timerShockwaveCD:Stop()
			timerShockwaveCD:Start(15)
			DBM:Debug("experimental timer extend firing for shockwave. Extend amount: 14. Blast and scorpid will be delayed", 2)
		else
			--Focused blast coming out of stun followed by scorpid
			timerFocusedBlastCD:Start(18)
			timerCallofScorpidCD:Start(21)
			DBM:Debug("Shockwaves cd is long enough to allow Focused Blast to proceed next", 2)
		end
	elseif spellId == 204697 then--Red scorpion
		if self.Options.SpecWarn204372switch and self:AntiSpam(3.5, 2) then--Even if enabled, only special warn once every 3.5 seconds
			specWarnCallofScorp:Show()
			specWarnCallofScorp:Play("killmob")
		end
		self.vb.volatileScorpCount = self.vb.volatileScorpCount + 1
		if self.Options.SetIconOnVolatileScorpion then
			local icon = 9 - self.vb.volatileScorpCount
			self:ScanForMobs(args.destGUID, 2, icon, 1, nil, 10, "SetIconOnVolatileScorpion")
		end
	elseif spellId == 204744 and args:IsPlayer() and self:AntiSpam(2, 3) then
		specWarnToxicChit:Show()
		specWarnToxicChit:Play("runaway")
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 204459 then
		specWarnVulnerableOver:Show()
	elseif spellId == 204697 then--Red scorpion
		self.vb.volatileScorpCount = self.vb.volatileScorpCount - 1
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 204744 and destGUID == UnitGUID("player") and self:AntiSpam(2, 3) then
		specWarnToxicChit:Show()
		specWarnToxicChit:Play("runaway")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 214800 then--Transform(Red)
		warnRed:Show()
--		timerAcidicFragments:Start()
	elseif spellId == 215042 then--Transform(Green)
		warnGreen:Show()
--		timerCrystallineFragments:Start()
	elseif spellId == 215055 then--Transform(Blue)
		warnBlue:Show()
--		timerVolatileFragments:Start()
	end
end

--Shockwave does NOT go on cooldown if he doesn't finish cast. This happens if he gets stunned before cast finishes
function mod:UNIT_SPELLCAST_INTERRUPTED(uId, _, spellId)
	if spellId == 204316 then--Shockwave
		timerShockwaveCD:Stop()
		if self.Options.InfoFrame then
			DBM.InfoFrame:Hide()
		end
	end
end
