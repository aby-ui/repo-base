local mod	= DBM:NewMod(1749, "DBM-BrokenIsles", 1, 822)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220116041824")
mod:SetCreatureID(107023)
mod:SetEncounterID(1880)
mod:SetReCombatTime(20)
mod:EnableWBEngageSync()--Enable syncing engage in outdoors

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 212867 212852",
	"SPELL_CAST_SUCCESS 212887",
	"SPELL_AURA_APPLIED 212943 212852 212884",
	"RAID_BOSS_WHISPER",
	"UNIT_SPELLCAST_SUCCEEDED target focus mouseover"
)

--TODO, adjust specWarnCracklingJoltNear spam threshold as needed
local warnStaticCharge				= mod:NewTargetAnnounce(212887, 3)
local warnLightningRod				= mod:NewTargetAnnounce(212943, 2)

local specWarnCracklingJolt			= mod:NewSpecialWarningDodge(212841, nil, nil, nil, 1, 2)
local specWarnCracklingJoltNear		= mod:NewSpecialWarningClose(212841, nil, nil, nil, 1, 2)
local specWarnStaticCharge			= mod:NewSpecialWarningYou(212887, nil, nil, nil, 1, 2)
local specWarnLightningRod			= mod:NewSpecialWarningRun(212943, nil, nil, nil, 4, 2)
local specWarnBreath				= mod:NewSpecialWarningDefensive(212852, nil, nil, nil, 1, 2)
local specWarnBreathSwap			= mod:NewSpecialWarningTaunt(212852, nil, nil, nil, 1, 2)
local specWarnStorm					= mod:NewSpecialWarningMove(212884, nil, nil, nil, 1, 2)

local timerCracklingJoltCD			= mod:NewCDTimer(11, 212841, nil, nil, nil, 3)
local timerLightningStormCD			= mod:NewCDTimer(30.5, 212867, nil, nil, nil, 3)
local timerStaticChargeCD			= mod:NewCDTimer(40.2, 212887, nil, "-Tank", nil, 3)
local timerStormBreathCD			= mod:NewCDTimer(23.1, 212852, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON)

--mod:AddReadyCheckOption(37460, false)

local function checkTankSwap(self, targetName, spellName)
	if not DBM:UnitDebuff("player", spellName) then
		specWarnBreathSwap:Show(targetName)
		specWarnBreathSwap:Play("tauntboss")
	end
end

function mod:OnCombatStart(delay, yellTriggered)
	if yellTriggered then

	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 212867 then
		timerLightningStormCD:Start()
	elseif spellId == 212852 then
		local _, unitID = self:GetCurrentTank(args.sourceGUID)
		if unitID and UnitIsUnit("player", unitID) then
			specWarnBreath:Show()
			specWarnBreath:Play("defensive")
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 212887 then
		timerStaticChargeCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 212887 then
		if args:IsPlayer() then
			specWarnStaticCharge:Show()
			specWarnStaticCharge:Play("runout")
		else
			warnStaticCharge:Show(args.destName)
		end
	elseif spellId == 212943 then
		warnLightningRod:CombinedShow(0.5, args.destName)
		if args:IsPlayer() then
			specWarnLightningRod:Show()
			specWarnLightningRod:Play("runaway")
		end
	elseif spellId == 212852 then
		local uId = DBM:GetRaidUnitId(args.destName)
		if self:IsTanking(uId) then
			self:Unschedule(checkTankSwap)
			self:Schedule(0.5, checkTankSwap, self, args.destName, args.spellName)
		end
	elseif spellId == 212884 and args:IsPlayer() then
		specWarnStorm:Show()
		specWarnStorm:Play("runaway")
	end
end

function mod:RAID_BOSS_WHISPER(msg)
	if msg:find("spell:212841") then
		specWarnCracklingJolt:Show()
		specWarnCracklingJolt:Play("watchstep")
	end
end

function mod:OnTranscriptorSync(msg, targetName)
	if msg:find("spell:212841") then
		targetName = Ambiguate(targetName, "none")
		if self:CheckNearby(4, targetName) and self:AntiSpam(4, 1) then
			specWarnCracklingJoltNear:Show(targetName)
			specWarnCracklingJoltNear:Play("watchstep")
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 212837 and self:AntiSpam(4, 2) then--Only event. not targetting boss no timer sorry!
		--Could sync, but I don't want to spam comms for this, that's just stupid.
		timerCracklingJoltCD:Start()
	end
end

