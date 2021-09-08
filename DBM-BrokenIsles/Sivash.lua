local mod	= DBM:NewMod(1885, "DBM-BrokenIsles", 1, 822)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20210905144823")
mod:SetCreatureID(117470)
--mod:SetEncounterID(1880)--Bosses don't fire BOSS_KILL or have encounter IDs at time of this update
mod:SetReCombatTime(20)
mod:EnableWBEngageSync()--Enable syncing engage in outdoors

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 233996",
	"UNIT_SPELLCAST_SUCCEEDED"
)

local warnSubmerge					= mod:NewTargetAnnounce(241433, 2)
local warnSummonHonorGuard			= mod:NewSpellAnnounce(233968, 3)

local specWarnTidalWave				= mod:NewSpecialWarningDodge(233996, nil, nil, nil, 2, 2)
local specWarnSubmerge				= mod:NewSpecialWarningDodge(241433, nil, nil, nil, 1, 2)
local specWarnSubmergeNear			= mod:NewSpecialWarningClose(241433, nil, nil, nil, 1, 2)

local timerTidalWaveCD				= mod:NewCDTimer(20.6, 233996, nil, nil, nil, 3)--20.6-24.7
local timerSummonHonorGuardCD		= mod:NewCDTimer(24, 233968, nil, nil, nil, 1)--24-25
local timerSubmergeCD				= mod:NewCDTimer(12.4, 241433, nil, nil, nil, 3)--13.3-15.9

--mod:AddReadyCheckOption(37460, false)

function mod:SubmergeTarget(targetname, uId)
	if not targetname then return end
	if targetname == UnitName("player") then
		specWarnSubmerge:Show()
		specWarnSubmerge:Play("runout")
	elseif self:CheckNearby(10, targetname) then
		specWarnSubmergeNear:Show(targetname)
		specWarnSubmergeNear:Play("watchstep")
	else
		warnSubmerge:Show(targetname)
	end
end

function mod:OnCombatStart(delay, yellTriggered)
	if yellTriggered then

	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 233996 then
		specWarnTidalWave:Show()
		specWarnTidalWave:Play("watchwave")
		timerTidalWaveCD:Start()
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 233968 and self:AntiSpam(4, 1) then--Summon Honor Guard
		warnSummonHonorGuard:Show()
		timerSummonHonorGuardCD:Start()
	elseif spellId == 241433 and self:AntiSpam(4, 2) then
		specWarnSubmerge:Show()
		specWarnSubmerge:Play("watchstep")
		timerSubmergeCD:Start()
		self:BossTargetScanner(UnitGUID(uId), "SubmergeTarget", 0.2, 5)
	end
end
