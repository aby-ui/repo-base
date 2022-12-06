local mod	= DBM:NewMod(2473, "DBM-Party-Dragonflight", 1, 1196)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221206015003")
mod:SetCreatureID(186120)
mod:SetEncounterID(2568)
mod:SetUsedIcons(8, 7, 6, 5)
--mod:SetHotfixNoticeRev(20220322000000)
--mod:SetMinSyncRevision(20211203000000)
--mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 376811 381770 377559 376934",
	"SPELL_CAST_SUCCESS 377859",
	"SPELL_SUMMON 376797",
	"SPELL_AURA_APPLIED 377222 378022 377864",
	"SPELL_AURA_APPLIED_DOSE 377864",
	"SPELL_AURA_REMOVED 377222 378022",
	"SPELL_PERIODIC_DAMAGE 378054",
	"SPELL_PERIODIC_MISSED 378054"
--	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--TODO, proper phasing and timer updates
--TODO, better stack alert handling, maybe dispel special warning for RemoveDisease?
--[[
(ability.id = 376811 or ability.id = 377559 or ability.id = 376934) and type = "begincast"
 or ability.id = 377859 and type = "cast"
 or type = "dungeonencounterstart" or type = "dungeonencounterend"
 or ability.id = 381770 and type = "begincast"
--]]
local warnGraspingVines							= mod:NewSpellAnnounce(376933, 2)
local warnConsume								= mod:NewTargetNoFilterAnnounce(377222, 4)
local warnDecaySpray							= mod:NewSpellAnnounce(376811, 2)
local warnInfectiousSpit						= mod:NewStackAnnounce(377864, 2, nil, "Healer|RemoveDisease")

--local yellInfusedStrikes						= mod:NewShortFadesYell(361966)
local specWarnGraspingVines						= mod:NewSpecialWarningRun(376933, nil, nil, nil, 4, 2)
local specWarnGushingOoze						= mod:NewSpecialWarningInterrupt(381770, "HasInterrupt", nil, nil, 1, 2)
local specWarnGTFO								= mod:NewSpecialWarningGTFO(378054, nil, nil, nil, 1, 8)
local specWarnVineWhip							= mod:NewSpecialWarningDefensive(377559, nil, nil, nil, 1, 2)

local timerGraspingVinesCD						= mod:NewCDTimer(47.3, 376933, nil, nil, nil, 6)
local timerConsume								= mod:NewTargetTimer(10, 377222, nil, false, 2, 3, nil, DBM_COMMON_L.DAMAGE_ICON)
local timerDecaySprayCD							= mod:NewCDTimer(22.5, 376811, nil, nil, nil, 1, nil, DBM_COMMON_L.DAMAGE_ICON)
local timerInfectiousSpitCD						= mod:NewCDTimer(20.1, 377864, nil, nil, nil, 3, nil, DBM_COMMON_L.DISEASE_ICON)
local timerVineWhipCD							= mod:NewCDTimer(14.1, 377559, nil, nil, nil, 5, nil, DBM_COMMON_L.TANK_ICON)

--local berserkTimer							= mod:NewBerserkTimer(600)

--mod:AddRangeFrameOption("8")
mod:AddInfoFrameOption(378022, true)
mod:AddSetIconOption("SetIconOnDecaySpray", 376811, true, 5, {8, 7, 6, 5})

mod:GroupSpells(377222, 378022)--Consume with Consuming

mod.vb.addIcon = 8

function mod:OnCombatStart(delay)
	timerVineWhipCD:Start(6-delay)
	timerDecaySprayCD:Start(12.1-delay)
	timerGraspingVinesCD:Start(15.8-delay)
	timerInfectiousSpitCD:Start(26-delay)
end

function mod:OnCombatEnd()
--	if self.Options.RangeFrame then
--		DBM.RangeCheck:Hide()
--	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 376811 then
		self.vb.addIcon = 8
		timerDecaySprayCD:Start()
	elseif spellId == 381770 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnGushingOoze:Show(args.sourceName)
		specWarnGushingOoze:Play("kickcast")
	elseif spellId == 377559 then
		if self:IsTanking("player", "boss1", nil, true) then
			specWarnVineWhip:Show()
			specWarnVineWhip:Play("defensive")
		end
		timerVineWhipCD:Start()
	elseif spellId == 376934 then
		if DBM:UnitDebuff("player", 383875) then--Partially Digested
			specWarnGraspingVines:Show()
			specWarnGraspingVines:Play("justrun")
		else
			warnGraspingVines:Show()
		end
		timerGraspingVinesCD:Start()--47.3
		--Timer restarts
		timerInfectiousSpitCD:Restart(10.2)
		timerVineWhipCD:Restart(10.9)
		timerDecaySprayCD:Restart(17)--17-20, but it does still restart here
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 377859 then
		timerInfectiousSpitCD:Start()
	end
end

function mod:SPELL_SUMMON(args)
	local spellId = args.spellId
	if spellId == 376797 then
		if self.Options.SetIconOnDecaySpray then
			self:ScanForMobs(args.destGUID, 2, self.vb.addIcon, 1, nil, 12, "SetIconOnDecaySpray")
		end
		self.vb.addIcon = self.vb.addIcon - 1
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 377222 then--On Player
		warnConsume:CombinedShow(0.3, args.destName)
		timerConsume:Start(args.destName)
	elseif spellId == 378022 then--On Boss
		if self.Options.InfoFrame then
			DBM.InfoFrame:SetHeader(args.spellName)
			DBM.InfoFrame:Show(2, "enemyabsorb", nil, args.amount, "boss1")
		end
	elseif spellId == 377864 then
		warnInfectiousSpit:Show(args.destName, args.amount or 1)
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 377222 then
		timerConsume:Stop(args.destName)
	elseif spellId == 378022 then--On Boss
		if self.Options.InfoFrame then
			DBM.InfoFrame:Hide()
		end
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 378054 and destGUID == UnitGUID("player") and self:AntiSpam(2, 2) then
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
