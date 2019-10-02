local mod	= DBM:NewMod(194, "DBM-Firelands", nil, 78)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190821185238")
mod:SetCreatureID(52530)
mod:SetEncounterID(1206)
mod:SetZone()
--mod:SetModelSound("Sound\\Creature\\ALYSRAZOR\\VO_FL_ALYSRAZOR_AGGRO.ogg", "Sound\\Creature\\ALYSRAZOR\\VO_FL_ALYSRAZOR_TRANSITION_02.ogg")
--Long: I serve a new master now, mortals!
--Short: Reborn in Flame!

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 99464",
	"SPELL_AURA_APPLIED 99362 99359 99308 99432 99844",
	"SPELL_AURA_APPLIED_DOSE 99844",
	"SPELL_AURA_REFRESH 99359",
	"SPELL_AURA_REMOVED 100744 99432 99362 99359 99844",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"CHAT_MSG_MONSTER_YELL"
)

--CombatStart timer uses an out of combat event
mod:RegisterEvents(
	"SPELL_CAST_START 101223 102111 100761 100744 100559"
)

--[[
(ability.id = 101223 or ability.id = 102111 or ability.id = 100761 or ability.id = 100744 or ability.id = 100559) and type = "begincast"
 or ability.id = 99464 and type = "cast"
 or ability.id = 99432 and type = "applybuff"
 or ability.id = 100744 and type = "removebuff"
--]]
local warnMolting				= mod:NewCountAnnounce(99464, 3)
local warnFirestormSoon			= mod:NewPreWarnAnnounce(100744, 10, 3)
local warnCataclysm				= mod:NewCastAnnounce(102111, 3)
local warnPhase					= mod:NewAnnounce("WarnPhase", 3, "136116")
local warnNewInitiate			= mod:NewAnnounce("WarnNewInitiate", 3, 61131)

local specWarnFirestorm			= mod:NewSpecialWarningSpell(100744, nil, nil, nil, 2, 2)
local specWarnFieroblast		= mod:NewSpecialWarningInterrupt(101223, "HasInterrupt", nil, 2, 1, 2)
local specWarnGushingWoundSelf	= mod:NewSpecialWarningYou(99308, false, nil, nil, 1, 2)
local specWarnTantrum			= mod:NewSpecialWarningSpell(99362, "Tank", nil, nil, 1, 2)
local specWarnGushingWoundOther	= mod:NewSpecialWarningTarget(99308, false, nil, nil, 1, 2)--There is no voice that really fits this

local timerCombatStart			= mod:NewCombatTimer(33)
local timerFieryVortexCD		= mod:NewNextTimer(179, 99794, nil, nil, nil, 6)
local timerMoltingCD			= mod:NewNextTimer(60, 99464, nil, nil, nil, 5)
local timerCataclysm			= mod:NewCastTimer(5, 102111, nil, nil, nil, 5)--Heroic
local timerCataclysmCD			= mod:NewCDTimer(31, 102111, nil, nil, nil, 5, nil, DBM_CORE_DEADLY_ICON, nil, 2, 4)--Heroic
local timerFirestormCD			= mod:NewCDTimer(83, 100744, nil, nil, nil, 2, nil, DBM_CORE_DEADLY_ICON, nil, 1, 4)--Heroic
local timerPhaseChange			= mod:NewTimer(33.5, "TimerPhaseChange", 99816, nil, nil, 6)
local timerHatchEggs			= mod:NewTimer(50, "TimerHatchEggs", 42471, nil, nil, 1)
local timerNextInitiate			= mod:NewTimer(32, "timerNextInitiate", 61131, nil, nil, 1)
local timerTantrum				= mod:NewBuffActiveTimer(10, 99362, nil, "Tank", nil, 5, nil, DBM_CORE_TANK_ICON)
local timerSatiated				= mod:NewBuffActiveTimer(15, 99359, nil, "Tank", nil, 5, nil, DBM_CORE_TANK_ICON)
local timerBlazingClaw			= mod:NewTargetTimer(15, 99844, nil, false, nil, 5)

mod:AddInfoFrameOption(98734, false)

mod.vb.initiatesSpawned = 0
mod.vb.cataCast = 0
mod.vb.moltCast = 0
local PowerLevel = DBM:GetSpellInfo(98734)

function mod:OnCombatStart(delay)
	if self:IsHeroic() then
		timerFieryVortexCD:Start(243-delay)--Probably not right.
		timerCataclysmCD:Start(32-delay)
		timerHatchEggs:Start(42-delay)
		timerFirestormCD:Start(94-delay)
		warnFirestormSoon:Schedule(84-delay)
		timerHatchEggs:Start(37-delay)
	else
		timerFieryVortexCD:Start(196-delay)
		timerHatchEggs:Start(47-delay)
	end
	timerNextInitiate:Start(27-delay, L.Both)--First one is same on both difficulties.
	self.vb.initiatesSpawned = 0
	self.vb.cataCast = 0
	self.vb.moltCast = 0
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(PowerLevel)
		DBM.InfoFrame:Show(5, "playerpower", 10, ALTERNATE_POWER_INDEX)
	end
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 101223 then
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnFieroblast:Show(args.sourceName)
			specWarnFieroblast:Play("kickcast")
		end
	elseif args:IsSpellID(102111, 100761) then
		self.vb.cataCast = self.vb.cataCast + 1
		warnCataclysm:Show()
		timerCataclysm:Start()
		if self.vb.cataCast == 1 or self.vb.cataCast == 3 then--Cataclysm is cast 5 times, but there is a firestorm in middle them affecting CD on 2nd and 4th, so you only want to start 30 sec bar after first and third
			timerCataclysmCD:Start()
		end
	elseif spellId == 100744 then
		specWarnFirestorm:Show()
		specWarnFirestorm:Play("aesoon")
		if self.vb.cataCast < 3 then--Firestorm is only cast 2 times per phase. This essencially makes cd bar only start once.
			timerFirestormCD:Start()
			warnFirestormSoon:Cancel()--Just in case it's wrong. WoL may not be perfect, i'll have full transcriptor logs soon.
			warnFirestormSoon:Schedule(73)
		end
	elseif spellId == 100559 then--Roots from the first pull RP
		timerCombatStart:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 99464 and self:IsNormal() then
		self.vb.moltCast = self.vb.moltCast + 1
		if self.vb.moltCast < 2 then
			timerMoltingCD:Start()
		end
		warnMolting:Show(self.vb.moltCast)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 99362 and ((args.sourceGUID == UnitGUID("target") and self:IsTank()) or not self:IsTank() and (args.sourceGUID == UnitGUID("targettarget") or args.sourceGUID == UnitGUID("focustargettarget"))) then--Only give warning if it's mob you're targeting and you're a tank, or you're targeting the tank it's on and he's targeting the bird.
		specWarnTantrum:Show()
		specWarnTantrum:Play("moveboss")
		timerTantrum:Start()
	elseif spellId == 99359 and ((args.sourceGUID == UnitGUID("target") and self:IsTank()) or not self:IsTank() and (args.sourceGUID == UnitGUID("targettarget") or args.sourceGUID == UnitGUID("focustargettarget"))) then--^^ Same as above only with diff spell
		timerSatiated:Start(self:IsHeroic() and 10 or 15)
	elseif spellId == 99308 then--Gushing Wound
		if args:IsPlayer() then
			specWarnGushingWoundSelf:Show()
			specWarnGushingWoundSelf:Play("defensive")
		else
			specWarnGushingWoundOther:Show(args.destName)
			specWarnGushingWoundOther:Play("stopheal")
		end
	elseif spellId == 99432 then--Burnout applied (0 energy)
		warnPhase:Show(3)
	elseif spellId == 99844 and args:IsDestTypePlayer() then
		timerBlazingClaw:Start(args.destName)
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	local spellId = args.spellId
	if spellId == 99844 and args:IsDestTypePlayer() then
		timerBlazingClaw:Start(args.destName)
	end
end

function mod:SPELL_AURA_REFRESH(args)
	local spellId = args.spellId
	if spellId == 99359 and ((args.sourceGUID == UnitGUID("target") and self:IsTank()) or not self:IsTank() and args.sourceGUID == UnitGUID("targettarget")) then--^^ Same as above only with diff spell
		timerSatiated:Start(self:IsHeroic() and 10 or 15)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 100744 then--Firestorm removed from boss. No reason for a heroic check here, this shouldn't happen on normal.
		timerHatchEggs:Start(16)
		if self.vb.cataCast < 3 then
			timerCataclysmCD:Start(10)--10 seconds after first firestorm ends
		else
			timerCataclysmCD:Start(20)--20 seconds after second one ends. (or so i thought, my new logs show only 4 cataclysms not 5. wtf. I hate inconsistencies
		end
	elseif spellId == 99432 and self:IsInCombat() then--Burnout removed (50 energy)
		warnPhase:Show(4)
	elseif spellId == 99362 and ((args.sourceGUID == UnitGUID("target") and self:IsTank()) or not self:IsTank() and args.sourceGUID == UnitGUID("targettarget")) then
		timerTantrum:Stop()
	elseif spellId == 99359 and ((args.sourceGUID == UnitGUID("target") and self:IsTank()) or not self:IsTank() and args.sourceGUID == UnitGUID("targettarget")) then--^^ Same as above only with diff spell
		timerSatiated:Stop()
	elseif spellId == 99844 then
		timerBlazingClaw:Stop(args.destName)
	end
end

do
	local initiate = DBM:EJ_GetSectionInfo(2834)
	local intiateTimers = {27, 31, 31, 21, 21, 21}
	local intiateHeroicTimers = {27, 22, 63, 21, 21, 40}
	local initiateSpawns = {
		[1] = L.Both,
		[2] = L.Both,
		[3] = L.East,
		[4] = L.West,
		[5] = L.East,
		[6] = L.West
	}
	function mod:CHAT_MSG_MONSTER_YELL(msg, mob)
		if not self:IsInCombat() then return end
		if msg == L.YellPhase2 or msg:find(L.YellPhase2) then--Basically the pre warn to feiry vortex
			warnPhase:Show(2)
			timerMoltingCD:Cancel()
			timerPhaseChange:Start(33, 3)
			self.vb.initiatesSpawned = 0
		elseif mob == initiate then--initiates yell when they spawn, and no other time
			self.vb.initiatesSpawned = self.vb.initiatesSpawned + 1
			warnNewInitiate:Show(initiateSpawns[self.vb.initiatesSpawned])
			if self.vb.initiatesSpawned == 6 then return end--All 6 are spawned, lets not create any timers.
			local nextText = initiateSpawns[self.vb.initiatesSpawned+1]
			local nextTimer = self:IsHeroic() and intiateHeroicTimers[self.vb.initiatesSpawned+1] or initiateSpawns[self.vb.initiatesSpawned+1]
			timerNextInitiate:Start(nextTimer, nextText)
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg:find("spell:99925") then
		warnPhase:Show(1)
		timerNextInitiate:Start(13.5, L.Both)
		if self:IsHeroic() then
			timerFieryVortexCD:Start(225)
			timerHatchEggs:Start(22)
			timerCataclysmCD:Start(18)
			timerFirestormCD:Start(70)
			warnFirestormSoon:Schedule(60)
			self.vb.cataCast = 0
		else
			timerFieryVortexCD:Start()
			timerHatchEggs:Start(32)
		end
	end
end
