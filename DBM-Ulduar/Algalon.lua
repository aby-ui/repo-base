local mod	= DBM:NewMod("Algalon", "DBM-Ulduar")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143403")
mod:SetCreatureID(32871)
mod:SetEncounterID(1130)
mod:DisableEEKillDetection()--EE always fires wipe
mod:SetMinSyncRevision(234)
mod:SetModelID(28641)
--mod:SetModelSound("Sound\\Creature\\AlgalonTheObserver\\UR_Algalon_Aggro01.ogg", "Sound\\Creature\\AlgalonTheObserver\\UR_Algalon_Slay02.ogg")
mod:RegisterCombat("combat")
mod:RegisterKill("yell", L.YellKill)
mod:SetWipeTime(60)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 64584 64443",
	"SPELL_CAST_SUCCESS 65108 64122 64598 62301",
	"SPELL_AURA_APPLIED 64412",
	"SPELL_AURA_APPLIED_DOSE 64412",
	"SPELL_AURA_REMOVED 64412",
	"RAID_BOSS_EMOTE",
--	"CHAT_MSG_MONSTER_YELL",
	"UNIT_SPELLCAST_SUCCEEDED boss1",
	"UNIT_HEALTH boss1"
)

local warnPhase2				= mod:NewPhaseAnnounce(2)
local warnPhase2Soon			= mod:NewAnnounce("WarnPhase2Soon", 2)
local announcePreBigBang		= mod:NewPreWarnAnnounce(64584, 10, 3)
local announceBlackHole			= mod:NewSpellAnnounce(65108, 2)
local announcePhasePunch		= mod:NewStackAnnounce(65108, 4, nil, "Tank|Healer")

local specwarnStarLow			= mod:NewSpecialWarning("warnStarLow", "Tank|Healer", nil, nil, 1, 2)
local specWarnPhasePunch		= mod:NewSpecialWarningStack(64412, nil, 4, nil, nil, 1, 6)
local specWarnBigBang			= mod:NewSpecialWarningSpell(64584, nil, nil, nil, 3, 2)
local specWarnCosmicSmash		= mod:NewSpecialWarningDodge(64596, nil, nil, nil, 2, 2)

local enrageTimer				= mod:NewBerserkTimer(360)
local timerNextBigBang			= mod:NewNextTimer(90.5, 64584, nil, nil, nil, 2)
local timerBigBangCast			= mod:NewCastTimer(8, 64584, nil, nil, nil, 2, nil, DBM_CORE_DEADLY_ICON)
local timerNextCollapsingStar	= mod:NewTimer(15, "NextCollapsingStar", 227161)
local timerCDCosmicSmash		= mod:NewCDTimer(24.6, 64596, nil, nil, nil, 3)
local timerCastCosmicSmash		= mod:NewCastTimer(4.5, 64596)
local timerPhasePunch			= mod:NewTargetTimer(45, 64412, nil, "Tank", 2, 5, nil, DBM_CORE_TANK_ICON)
local timerNextPhasePunch		= mod:NewNextTimer(15.5, 64412, nil, "Tank", 2, 5, nil, DBM_CORE_TANK_ICON)

mod:AddInfoFrameOption(64122, true)

local sentLowHP = {}
local warnedLowHP = {}
mod.vb.warned_preP2 = false

function mod:OnCombatStart(delay)
	self.vb.warned_preP2 = false
	table.wipe(sentLowHP)
	table.wipe(warnedLowHP)
	if self.Options.InfoFrame and not self:IsTrivial(80) then
		DBM.InfoFrame:SetHeader(L.HealthInfo)
		DBM.InfoFrame:Show(5, "health", 18000)
	end
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(64584, 64443) then 	-- Big Bang
		timerBigBangCast:Start()
		timerNextBigBang:Start()
		announcePreBigBang:Schedule(80)
		specWarnBigBang:Show()
		if self:IsTank() then
			specWarnBigBang:Play("defensive")
		else
			specWarnBigBang:Play("findshelter")
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(65108, 64122) then 	-- Black Hole Explosion
		announceBlackHole:Show()
	elseif args:IsSpellID(64598, 62301) then	-- Cosmic Smash
		timerCastCosmicSmash:Start()
		timerCDCosmicSmash:Start()
		specWarnCosmicSmash:Show()
		specWarnCosmicSmash:Play("watchstep")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 64412 then
		timerNextPhasePunch:Start()
		local amount = args.amount or 1
		if args:IsPlayer() and amount >= 4 then
			specWarnPhasePunch:Show(args.amount)
			specWarnPhasePunch:Play("stackhigh")
		end
		timerPhasePunch:Start(args.destName)
		announcePhasePunch:Show(args.destName, amount)
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 64412 then
		timerPhasePunch:Cancel(args.destName)
	end
end

function mod:RAID_BOSS_EMOTE(msg)
	if msg == L.Emote_CollapsingStar or msg:find(L.Emote_CollapsingStar) then
		timerNextCollapsingStar:Start()
	end
end

--[[
function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.Phase2 or msg:find(L.Phase2) then
		timerNextCollapsingStar:Cancel()
		warnPhase2:Show()
	end
end
--]]

function mod:UNIT_HEALTH(uId)
	local cid = self:GetUnitCreatureId(uId)
	local guid = UnitGUID(uId)
	if cid == 32871 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.23 and not self.vb.warned_preP2 then
		self.vb.warned_preP2 = true
		warnPhase2Soon:Show()
	elseif cid == 32955 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.25 and not sentLowHP[guid] then
		sentLowHP[guid] = true
		self:SendSync("lowhealth", guid)
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 65311 then--Supermassive Fail (fires when he becomes actually active)
		timerNextCollapsingStar:Start(16)
		timerCDCosmicSmash:Start(26)
		announcePreBigBang:Schedule(80)
		timerNextBigBang:Start(90)
		enrageTimer:Start(360)
	elseif spellId == 65256 then--Self Stun (phase 2)
		timerNextCollapsingStar:Stop()
		warnPhase2:Show()
	end
end

function mod:OnSync(msg, guid)
	if msg == "lowhealth" and guid and not warnedLowHP[guid] then
		warnedLowHP[guid] = true
		if self:AntiSpam(2.5, 1) then
			specwarnStarLow:Show()
			specwarnStarLow:Play("aesoon")
		end
	end
end
