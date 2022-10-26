local mod	= DBM:NewMod(2483, "DBM-Party-Dragonflight", 6, 1203)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220813230158")
mod:SetCreatureID(186737)
mod:SetEncounterID(2583)
--mod:SetUsedIcons(1, 2, 3)
--mod:SetHotfixNoticeRev(20220322000000)
--mod:SetMinSyncRevision(20211203000000)
--mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 386781 387151 388008",
--	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED 386881",
--	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED 386881",
	"SPELL_PERIODIC_DAMAGE 387150",
	"SPELL_PERIODIC_MISSED 387150"
--	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--TODO, detect icy devastator target and not show range frame entire fight, just when icy is out?
--local warnStaggeringBarrage						= mod:NewSpellAnnounce(361018, 3)

--local specWarnInfusedStrikes					= mod:NewSpecialWarningStack(361966, nil, 8, nil, nil, 1, 6)
local specWarnFrostBomb							= mod:NewSpecialWarningMoveAway(386781, nil, nil, nil, 1, 2)
local yellFrostBomb								= mod:NewYell(386781)
local yellFrostBombFades						= mod:NewShortFadesYell(386781)
local specWarnIcyDevastator						= mod:NewSpecialWarningMoveAway(387151, nil, nil, nil, 1, 2)
local yellIcyDevastator							= mod:NewYell(387151)
local specWarBelowZero							= mod:NewSpecialWarningMoveTo(388008, nil, nil, nil, 3, 2)
local specWarnGTFO								= mod:NewSpecialWarningGTFO(387150, nil, nil, nil, 1, 8)

local timerFrostBombCD							= mod:NewAITimer(35, 386781, nil, nil, nil, 3)
local timerIcyDevastatorCD						= mod:NewAITimer(35, 387151, nil, nil, nil, 3)
local timerBelowZeroCD							= mod:NewAITimer(35, 388008, nil, nil, nil, 2)
--local timerDecaySprayCD							= mod:NewAITimer(35, 376811, nil, nil, nil, 5, nil, DBM_COMMON_L.TANK_ICON)

--local berserkTimer							= mod:NewBerserkTimer(600)

mod:AddRangeFrameOption(8, 387151)
--mod:AddInfoFrameOption(361651, true)
--mod:AddSetIconOption("SetIconOnStaggeringBarrage", 361018, true, false, {1, 2, 3})

local vaultRuin = DBM:GetSpellInfo(388072)

function mod:EruptionTarget(targetname)
	if not targetname then return end
	if targetname == UnitName("player") then
		specWarnIcyDevastator:Show()
		specWarnIcyDevastator:Play("runout")
		yellIcyDevastator:Yell()
	end
end

function mod:OnCombatStart(delay)
	timerFrostBombCD:Start(1-delay)
	timerIcyDevastatorCD:Start(1-delay)
	timerBelowZeroCD:Start(1-delay)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(8)
	end
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
	if spellId == 386781 then
		timerFrostBombCD:Start()
	elseif spellId == 387151 then
		timerIcyDevastatorCD:Start()
		self:ScheduleMethod(0.2, "BossTargetScanner", args.sourceGUID, "EruptionTarget", 0.1, 6, true)
	elseif spellId == 388008 then
		specWarBelowZero:Show(vaultRuin)
		specWarBelowZero:Play("findshelter")
		timerBelowZeroCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 362805 then

	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 386881 then
		if args:IsPlayer() then
			specWarnFrostBomb:Show()
			specWarnFrostBomb:Play("runout")
			yellFrostBomb:Yell()
			yellFrostBombFades:Countdown(spellId)
		end
	end
end
--mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 386881 then
		if args:IsPlayer() then
			yellFrostBombFades:Cancel()
		end
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 387150 and destGUID == UnitGUID("player") and self:AntiSpam(2, 4) then
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
