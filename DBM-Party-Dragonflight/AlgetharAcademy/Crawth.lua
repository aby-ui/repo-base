local mod	= DBM:NewMod(2495, "DBM-Party-Dragonflight", 5, 1201)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221128054542")
mod:SetCreatureID(191736)
mod:SetEncounterID(2564)
--mod:SetUsedIcons(1, 2, 3)
mod:SetHotfixNoticeRev(20221127000000)
--mod:SetMinSyncRevision(20211203000000)
--mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 377034 377004 376997",
	"SPELL_CAST_SUCCESS 377004 376781",
	"SPELL_AURA_APPLIED 376781 181089",
--	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED 376781"
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
--	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--Gale force not in combat log
--TODO, verify target scan
--[[
(ability.id = 377034 or ability.id = 377004 or ability.id = 376997) and type = "begincast"
 or ability.id = 376781
 or ability.id = 181089
 or type = "dungeonencounterstart" or type = "dungeonencounterend"
--]]
local warnPlayBall								= mod:NewSpellAnnounce(377182, 2, nil, nil, nil, nil, nil, 2)

local specWarnFirestorm							= mod:NewSpecialWarningDodge(376448, nil, nil, nil, 2, 2)
--local specWarnGaleForce						= mod:NewSpecialWarningSpell(376467, nil, nil, nil, 2, 2)
local specWarnOverpoweringGust					= mod:NewSpecialWarningDodge(377034, nil, nil, nil, 2, 2)
local yellOverpoweringGust						= mod:NewYell(377034)
local specWarnDeafeningScreech					= mod:NewSpecialWarningDodge(377004, nil, nil, nil, 2, 2)
local specWarnSavagePeck						= mod:NewSpecialWarningDefensive(376997, nil, nil, nil, 1, 2)
--local specWarnGTFO							= mod:NewSpecialWarningGTFO(340324, nil, nil, nil, 1, 8)

local timerFirestorm							= mod:NewBuffActiveTimer(12, 376448, nil, nil, nil, 1)
local timerOverpoweringGustCD					= mod:NewCDTimer(28.2, 377034, nil, nil, nil, 3)
local timerDeafeningScreechCD					= mod:NewCDTimer(22.7, 377004, nil, nil, nil, 3)
local timerSavagePeckCD							= mod:NewCDTimer(13.6, 376997, nil, "Tank|Healer", nil, 5, nil, DBM_COMMON_L.TANK_ICON)--Spell queued intoo oblivion often

--local berserkTimer							= mod:NewBerserkTimer(600)

mod:AddRangeFrameOption(4, 377004)
--mod:AddInfoFrameOption(361651, true)
--mod:AddSetIconOption("SetIconOnStaggeringBarrage", 361018, true, false, {1, 2, 3})

function mod:GustTarget(targetname)
	if not targetname then return end
	if targetname == UnitName("player") then
		yellOverpoweringGust:Yell()
	end
end

function mod:OnCombatStart(delay)
--	timerPlayBallCD:Start(1-delay)
	timerSavagePeckCD:Start(3.6-delay)
	timerDeafeningScreechCD:Start(10.1-delay)
	timerOverpoweringGustCD:Start(15.7-delay)
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
--	if self.Options.InfoFrame then
--		DBM.InfoFrame:Hide()
--	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 377034 then
		self:ScheduleMethod(0.2, "BossTargetScanner", args.sourceGUID, "GustTarget", 0.1, 8, true)
		specWarnOverpoweringGust:Show()
		specWarnOverpoweringGust:Play("shockwave")
		timerOverpoweringGustCD:Start()
	elseif spellId == 377004 then
		specWarnDeafeningScreech:Show()
		specWarnDeafeningScreech:Play("watchstep")
		timerDeafeningScreechCD:Start()
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(4)
		end
	elseif spellId == 376997 then
		timerSavagePeckCD:Start()
		if self:IsTanking("player", "boss1", nil, true) then
			specWarnSavagePeck:Show()
			specWarnSavagePeck:Play("defensive")
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 377004 then
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
	elseif spellId == 376781 then
		specWarnFirestorm:Show()
		specWarnFirestorm:Play("watchstep")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 376781 then
		timerFirestorm:Start()
		--Regardless of time remaining, crawth will cast these coming out of stun
		timerOverpoweringGustCD:Restart(12)
		timerDeafeningScreechCD:Restart(16.7)
		timerSavagePeckCD:Stop()--24.6, This one probably restarts too but also gets wierd spell queue and MIGHT not happen
	elseif spellId == 181089 and args:GetDestCreatureID() == 191736 then--Crawth getting buff is play ball starting
		warnPlayBall:Show()
		warnPlayBall:Play("phasechange")
	end
end
--mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 376781 then
		timerFirestorm:Stop()
	end
end

--[[
function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 340324 and destGUID == UnitGUID("player") and self:AntiSpam(2, 4) then
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 353193 then

	end
end
--]]
