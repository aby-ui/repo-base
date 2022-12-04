local mod	= DBM:NewMod(2510, "DBM-Party-Dragonflight", 8, 1204)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221204033441")
mod:SetCreatureID(189727)
mod:SetEncounterID(2617)
--mod:SetUsedIcons(1, 2, 3)
--mod:SetHotfixNoticeRev(20220322000000)
--mod:SetMinSyncRevision(20211203000000)
--mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 386757 386559 390111",
	"SPELL_CAST_SUCCESS 385963",
	"SPELL_AURA_APPLIED 385963"
--	"SPELL_AURA_APPLIED_DOSE",
--	"SPELL_AURA_REMOVED",
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
--	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--[[
(ability.id = 386757 or ability.id = 386559 or ability.id = 390111) and type = "begincast"
 or ability.id = 385963 and type = "cast"
 or type = "dungeonencounterstart" or type = "dungeonencounterend"
--]]
--TODO, review longer logs since heroic is undertuned
local warnFrostCyclone							= mod:NewTargetNoFilterAnnounce(390111, 3)

local specWarnHailstorm							= mod:NewSpecialWarningMoveTo(386757, nil, nil, nil, 2, 2)
local specWarnGlacialSurge						= mod:NewSpecialWarningDodge(386559, nil, nil, nil, 2, 2)
local specWarnFrostCyclone						= mod:NewSpecialWarningMoveAway(390111, nil, nil, nil, 1, 2, 4)
local yellFrostCyclone							= mod:NewYell(390111)
local specWarnFrostShock						= mod:NewSpecialWarningDispel(385963, "RemoveMagic", nil, nil, 1, 2)
--local specWarnGTFO							= mod:NewSpecialWarningGTFO(340324, nil, nil, nil, 1, 8)

local timerHailstormCD							= mod:NewCDTimer(25, 386757, nil, nil, nil, 2, nil, DBM_COMMON_L.DEADLY_ICON)
local timerGlacialSurgeCD						= mod:NewCDTimer(22, 386559, nil, nil, nil, 3)
local timerFrostCycloneCD						= mod:NewAITimer(35, 390111, nil, nil, nil, 3, nil, DBM_COMMON_L.MYTHIC_ICON)
local timerFrostShockCD							= mod:NewCDTimer(11, 385963, nil, nil, nil, 3, nil, DBM_COMMON_L.MAGIC_ICON)

--local berserkTimer							= mod:NewBerserkTimer(600)

--mod:AddRangeFrameOption("8")
--mod:AddInfoFrameOption(361651, true)
--mod:AddSetIconOption("SetIconOnStaggeringBarrage", 361018, true, false, {1, 2, 3})

local boulder = DBM:GetSpellInfo(386222)

function mod:FrostCycloneTarget(targetname)
	if not targetname then return end
	if targetname == UnitName("player") then
		specWarnFrostCyclone:Show()
		specWarnFrostCyclone:Play("runout")
		yellFrostCyclone:Yell()
	else
		warnFrostCyclone:Show(targetname)
	end
end

function mod:OnCombatStart(delay)
	timerFrostShockCD:Start(6-delay)
	timerHailstormCD:Start(10-delay)
	timerGlacialSurgeCD:Start(22-delay)
	if self:IsMythic() then
		timerFrostCycloneCD:Start(1-delay)
	end
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
	if spellId == 386757 then
		specWarnHailstorm:Show(boulder)
		specWarnHailstorm:Play("findshelter")
		timerHailstormCD:Start()
	elseif spellId == 386559 then
		specWarnGlacialSurge:Show()
		specWarnGlacialSurge:Play("watchstep")--or watchring maybe?
		timerGlacialSurgeCD:Start()
	elseif spellId == 390111 then
		self:ScheduleMethod(0.1, "BossTargetScanner", args.sourceGUID, "FrostCycloneTarget", 0.1, 6, true)
		timerFrostCycloneCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 385963 then
		timerFrostShockCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 361966 and self:CheckDispelFilter("magic") then
		specWarnFrostShock:Show(args.destName)
		specWarnFrostShock:Play("helpdispel")
	end
end
--mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 361966 then

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
