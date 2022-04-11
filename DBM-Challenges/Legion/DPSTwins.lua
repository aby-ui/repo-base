local mod	= DBM:NewMod("ArtifactTwins", "DBM-Challenges", 3)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "normal,timewalker"

mod:SetRevision("20220407221113")
mod:SetCreatureID(116409, 116410)--Raest Magespear, Karam Magespear
mod:SetBossHPInfoToHighest()
mod.soloChallenge = true

mod:RegisterCombat("combat")
mod:SetReCombatTime(20, 5)--Basically killing of recombat restriction. mage tower lets you spam retry, we want the mod to let you

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 235317 235578",
	"SPELL_CAST_SUCCESS 235426",
	"UNIT_DIED",
	"UNIT_SPELLCAST_SUCCEEDED boss1 boss2"
)

--General
local warnPhase					= mod:NewPhaseChangeAnnounce()
--Karam
local warnRisingDragon			= mod:NewSpellAnnounce(235426, 3)

--Karam
local specWarnFixate			= mod:NewSpecialWarningRun(202081, nil, nil, nil, 4, 2)
--Raest
local specWarnGrasp				= mod:NewSpecialWarningInterrupt(235578, nil, nil, nil, 1, 2)
local specWarnRift				= mod:NewSpecialWarningSwitch(235446, nil, nil, nil, 1, 2)
local specWarnRune				= mod:NewSpecialWarningMoveTo(236460, nil, nil, nil, 1, 12)

--Karam
local timerRisingDragonCD		= mod:NewCDTimer(35, 235426, nil, nil, nil, 2)
--Raest
local timerHandCD				= mod:NewNextTimer(28, 235580, nil, nil, nil, 1, 235578, DBM_COMMON_L.DAMAGE_ICON, nil, 1, 4)
local timerGraspCD				= mod:NewCDTimer(15, 235578, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)
local timerRuneCD				= mod:NewCDTimer(35, 236460, nil, nil, nil, 5, nil, nil, nil, 2, 4)

mod.vb.phase = 1

function mod:OnCombatStart(delay)
	self.vb.phase = 1
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 235317 then--Dismiss (cast by Raest Magespear for phase 2 and phase 4 start)
		self.vb.phase = self.vb.phase + 1
		if self.vb.phase == 2 then
			warnPhase:Show(DBM_CORE_L.AUTO_ANNOUNCE_TEXTS.stage:format(2))
		else--4
			warnPhase:Show(DBM_CORE_L.AUTO_ANNOUNCE_TEXTS.stage:format(4))
			timerHandCD:Stop()
		end
	elseif spellId == 235578 then--Grasp from Beyond
		specWarnGrasp:Show(args.sourceName)
		specWarnGrasp:Play("kickcast")
		timerGraspCD:Start(15, args.sourceGUID)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 235426 then
		warnRisingDragon:Show()
	end
end

function mod:UNIT_DIED(args)
	if args.destGUID == UnitGUID("player") then--Solo scenario, a player death is a wipe
		DBM:EndCombat(self, true)
	end
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 116409 then--Raest
		DBM:EndCombat(self)
	elseif cid == 118698 then--Hand
		timerGraspCD:Stop(args.destGUID)
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 202081 then--Fixate (Karam Magespear returning in phase 3 and 5)
		specWarnFixate:Show()
		specWarnFixate:Play("justrun")
		specWarnFixate:ScheduleVoice(1.5, "keepmove")
		if self.vb.phase >= 2 then--Should filter fixate done on pull
			self.vb.phase = self.vb.phase + 1
			timerHandCD:Start(9)
			if self.vb.phase == 3 then
				warnPhase:Show(DBM_CORE_L.AUTO_ANNOUNCE_TEXTS.stage:format(3))
			else--5
				warnPhase:Show(DBM_CORE_L.AUTO_ANNOUNCE_TEXTS.stage:format(5))
				timerRuneCD:Start(18.2)
				timerRisingDragonCD:Start(25)--Only one time? need more data to be sure
			end
		end
	elseif spellId == 235580 then--Hand from Beyond
		timerHandCD:Start()
	elseif spellId == 236468 then--Rune of Summoning
		specWarnRune:Show(RUNES)
		specWarnRune:Play("getinyellowrunes")
		timerRuneCD:Start()
	elseif spellId == 235525 then--Tear Rift (about 3 seconds after Dismiss)
		specWarnRift:Show()
		specWarnRift:Play("killmob")
	end
end

--[[
--"<53.75 21:03:46> [CHAT_MSG_MONSTER_EMOTE] |TInterface\\Icons\\spell_shaman_earthquake:20|t%s readies itself to charge!#Jormog the Behemoth###Kylistà##0#0##0#12#nil#0#false#false#false#false", -- [133]
function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg:find("Interface\\Icons\\spell_shaman_earthquake") then
		specWarnCharge:Show()
		specWarnCharge:Play("chargemove")
	end
end
--]]
