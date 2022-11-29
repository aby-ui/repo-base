local mod	= DBM:NewMod(2477, "DBM-Party-Dragonflight", 3, 1198)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221128090806")
mod:SetCreatureID(186151)
mod:SetEncounterID(2580)
--mod:SetUsedIcons(1, 2, 3)
mod:SetHotfixNoticeRev(20221127000000)
--mod:SetMinSyncRevision(20211203000000)
--mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 375943 375937 375929 376723 376725 376892 376827 376829 376727",
	"SPELL_CAST_SUCCESS 376634 376730 376864",
	"SPELL_AURA_APPLIED 376634 376864 376827",
--	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED 376634 376864 376727",
	"SPELL_PERIODIC_DAMAGE 376899",
	"SPELL_PERIODIC_MISSED 376899",
	"UNIT_DIED"
--	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--TODO, timers with longer logs to verify upheavel and iron spear P1 timers
--[[
(ability.id = 375943 or ability.id = 376892 or ability.id = 375937 or ability.id = 376827 or ability.id = 375929 or ability.id = 376829 or ability.id = 376723 or ability.id = 376727) and type = "begincast"
 or (ability.id = 376634 or ability.id = 376730 or ability.id = 376864) and type = "cast"
 or target.id = 190294 and type = "death"
 or ability.id = 376727 and type = "removebuff"
 or type = "dungeonencounterstart" or type = "dungeonencounterend"
--]]
--Stage One: Balakar's Might
mod:AddTimerLine(DBM:EJ_GetSectionInfo(25185))
local warnSavageStrike							= mod:NewSpellAnnounce(375929, 4, nil, "Tank|Healer")
local warnIronSpear								= mod:NewTargetAnnounce(376634, 2)

local specWarnIronSpear							= mod:NewSpecialWarningMoveAway(376634, nil, nil, nil, 1, 2)
local yellIronSpear								= mod:NewYell(376634)
local yellIronSpearFades						= mod:NewShortFadesYell(376634)
local specWarnUpheaval							= mod:NewSpecialWarningDodge(375943, nil, nil, nil, 2, 2)
local specWarnRendingStrike						= mod:NewSpecialWarningDefensive(375937, nil, nil, nil, 1, 2)

local timerIronSpearCD							= mod:NewCDTimer(37, 376634, nil, nil, nil, 3)--Need more data
local timerUpheavalCD							= mod:NewCDTimer(37, 375943, nil, nil, nil, 3)--Need data at all
local timerRendingStrikeCD						= mod:NewCDCountTimer(16.5, 375937, nil, nil, nil, 5, nil, DBM_COMMON_L.TANK_ICON)--CD used for both rending and savage

--Intermission: Stormwinds
mod:AddTimerLine(DBM:EJ_GetSectionInfo(25192))
local warnStormwinds							= mod:NewSpellAnnounce(376730, 2)

local specWarnStormBolt							= mod:NewSpecialWarningInterrupt(376725, "HasInterrupt", nil, nil, 1, 2)

--Stage Two: The Storm Unleashed
mod:AddTimerLine(DBM:EJ_GetSectionInfo(25187))
local warnPhase2								= mod:NewPhaseAnnounce(2, 2)
local warnStaticSpear							= mod:NewTargetAnnounce(376864, 2)
local warnThunderStrike							= mod:NewSpellAnnounce(376829, 4, nil, "Tank|Healer")

local specWarnStaticSpear						= mod:NewSpecialWarningMoveAway(376864, nil, nil, nil, 1, 2)
local yellStaticSpear							= mod:NewYell(376864)
local yellStaticSpearFades						= mod:NewShortFadesYell(376864)
local specWarnCracklingUpheaval					= mod:NewSpecialWarningDodge(376892, nil, nil, nil, 2, 2)
local specWarnConductiveStrike					= mod:NewSpecialWarningDefensive(376827, nil, nil, nil, 1, 2)
local specWarnConductiveStrikeDispel			= mod:NewSpecialWarningDispel(376827, "RemoveMagic", nil, nil, 1, 2)
local specWarnGTFO								= mod:NewSpecialWarningGTFO(376899, nil, nil, nil, 1, 8)

local timerStaticSpearCD						= mod:NewCDTimer(38.3, 376864, nil, nil, nil, 3)
local timerCracklingUpheavalCD					= mod:NewCDTimer(38.3, 376892, nil, nil, nil, 3)
local timerConductiveStrikeCD					= mod:NewCDCountTimer(17, 376827, nil, nil, nil, 5, nil, DBM_COMMON_L.TANK_ICON)--CD used for both Condutive and Thunder

--local berserkTimer							= mod:NewBerserkTimer(600)

--mod:AddRangeFrameOption("8")
--mod:AddInfoFrameOption(361651, true)
--mod:AddSetIconOption("SetIconOnStaggeringBarrage", 361018, true, false, {1, 2, 3})

mod.vb.addsLeft = 0
mod.vb.comboCount = 0

function mod:OnCombatStart(delay)
	self.vb.addsLeft = 0
	self.vb.comboCount = 0
	self:SetStage(1)
	timerRendingStrikeCD:Start(8-delay, 1)
	timerIronSpearCD:Start(18-delay)
	timerUpheavalCD:Start(37-delay)
end

--function mod:OnCombatEnd()
--	if self.Options.RangeFrame then
--		DBM.RangeCheck:Hide()
--	end
--	if self.Options.InfoFrame then
--		DBM.InfoFrame:Hide()
--	end
--end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 375943 then
		specWarnUpheaval:Show()
		specWarnUpheaval:Play("watchstep")
--		timerUpheavalCD:Start()
	elseif spellId == 376892 then
		specWarnCracklingUpheaval:Show()
		specWarnCracklingUpheaval:Play("watchstep")
		timerCracklingUpheavalCD:Start()
	elseif spellId == 375937 then
		self.vb.comboCount = self.vb.comboCount + 1
		if self:IsTanking("player", "boss1", nil, true) then
			specWarnRendingStrike:Show()
			specWarnRendingStrike:Play("defensive")
		end
		--No longer alternates in P1, and is now also used in p2, wtf?
--		local timer = (self.vb.comboCount % 2 == 0) and 15 or 22
		timerRendingStrikeCD:Start(nil, self.vb.comboCount+1)
	elseif spellId == 376827 then
		self.vb.comboCount = self.vb.comboCount + 1
		if self:IsTanking("player", "boss1", nil, true) then
			specWarnConductiveStrike:Show()
			specWarnConductiveStrike:Play("defensive")
		end
		local timer = (self.vb.comboCount % 2 == 0) and 17 or 22
		timerConductiveStrikeCD:Start(timer, self.vb.comboCount+1)
	elseif spellId == 375929 then
		warnSavageStrike:Show()
	elseif spellId == 376829 then
		warnThunderStrike:Show()
	elseif spellId == 376727 then--Boss casting Siphon Power
		self:SetStage(1.5)
		timerIronSpearCD:Stop()
		timerUpheavalCD:Stop()
		timerRendingStrikeCD:Stop()
	elseif spellId == 376723 then--Adds casting Transfer Power
		self.vb.addsLeft = self.vb.addsLeft + 1
	elseif spellId == 376725 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnStormBolt:Show(args.sourceName)
		specWarnStormBolt:Play("kickcast")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 376634 then
--		timerIronSpearCD:Start()
	elseif spellId == 376730 and self:AntiSpam(3, 1) then
		warnStormwinds:Show()
	elseif spellId == 376864 then
		timerStaticSpearCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 376634 then
		if args:IsPlayer() then
			specWarnIronSpear:Show()
			specWarnIronSpear:Play("runout")
			yellIronSpear:Yell()
			yellIronSpearFades:Countdown(spellId)
		else
			warnIronSpear:Show(args.destName)
		end
	elseif spellId == 376864 then
		if args:IsPlayer() then
			specWarnStaticSpear:Show()
			specWarnStaticSpear:Play("runout")
			yellStaticSpear:Yell()
			yellStaticSpearFades:Countdown(spellId)
		else
			warnStaticSpear:Show(args.destName)
		end
	elseif spellId == 376827 and self:CheckDispelFilter("magic") then
		specWarnConductiveStrikeDispel:Show(args.destName)
		specWarnConductiveStrikeDispel:Play("helpdispel")
	end
end
--mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 376634 and args:IsPlayer() then
		yellIronSpearFades:Cancel()
	elseif spellId == 376864 and args:IsPlayer() then
		yellStaticSpearFades:Cancel()
	elseif spellId == 376727 then
		self:SetStage(2)
		self.vb.comboCount = 0
		warnPhase2:Show()
		timerConductiveStrikeCD:Start(8, 1)
		timerStaticSpearCD:Start(18)
		timerCracklingUpheavalCD:Start(37)
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 190294 then--Nokhud Stormcaster
		self.vb.addsLeft = self.vb.addsLeft - 1
		--Unused for now
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 376899 and destGUID == UnitGUID("player") and self:AntiSpam(3, 2) then
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

--[[
function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 353193 then

	end
end
--]]
