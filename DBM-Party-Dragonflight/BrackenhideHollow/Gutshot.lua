local mod	= DBM:NewMod(2472, "DBM-Party-Dragonflight", 1, 1196)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221206015003")
mod:SetCreatureID(186116)--194745 for Rotfang Hyena
mod:SetEncounterID(2567)
--mod:SetUsedIcons(1, 2, 3)
mod:SetHotfixNoticeRev(20221205000000)
--mod:SetMinSyncRevision(20211203000000)
--mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 384416 384827 385435 384633 384353",
	"SPELL_CAST_SUCCESS 383979",
	"SPELL_AURA_APPLIED 385356 384425 384764 384725 384638 384148 387889",
--	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED 384725 384638 387889 384148"
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
--	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--TODO, worth target scanning Meat Toss?
--TODO, CD feeding frenzy if it's shared cd
--TODO, does bounding leap have some kind of detection of target?
--TODO, is masters call actually interrupted or an invalid journal icon flag?
--TODO, verify some cast spellids which were iffy tooltip wise. This fight was still work in progress in build mod was made in
--[[
(ability.id = 384416 or ability.id = 384827 or ability.id = 385435 or ability.id = 384633 or ability.id = 384353) and type = "begincast"
 or ability.id = 383979 and type = "cast"
 or type = "dungeonencounterstart" or type = "dungeonencounterend"
--]]
local warnEnsnaringTrap							= mod:NewTargetNoFilterAnnounce(384148, 3)--Trap going out
local warnSmellLikeMeat							= mod:NewTargetNoFilterAnnounce(384425, 3)
local warnCallHyenas							= mod:NewSpellAnnounce(384827, 2)

local specWarnEnsnaringTrap						= mod:NewSpecialWarningYou(384148, nil, nil, nil, 1, 2)--Trap going out
local yellEnsnaringTrap							= mod:NewYell(384148, nil, false)--Trap going out
local specWarnFeedingFrenzy						= mod:NewSpecialWarningDispel(384764, "RemoveEnrage", nil, nil, 1, 2)--Buff on mob
local specWarnFeedingFrenzyYou					= mod:NewSpecialWarningRun(384725, nil, nil, nil, 4, 2)--Debuff on player
local specWarnMastersCall						= mod:NewSpecialWarningInterrupt(384638, "HasInterrupt", nil, nil, 1, 2)
local specWarnGutShot							= mod:NewSpecialWarningDefensive(384343, nil, nil, nil, 1, 2)--Trap going out
--local specWarnGTFO							= mod:NewSpecialWarningGTFO(340324, nil, nil, nil, 1, 8)

--mod:AddTimerLine(DBM:EJ_GetSectionInfo(24883))
local timerEnsnaringTrapCD						= mod:NewCDTimer(19.4, 384148, nil, nil, nil, 3)--Trap going out
local timerMeatTossCD							= mod:NewCDTimer(21.8, 384416, nil, nil, nil, 3)
local timerCallHyenasCD							= mod:NewCDTimer(35, 384827, nil, nil, nil, 1)--Need actual CD
local timerMastersCallCD						= mod:NewCDTimer(35, 384638, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)--Need actual CD
local timerGutShotCD							= mod:NewCDTimer(21.8, 384343, nil, nil, nil, 5, nil, DBM_COMMON_L.TANK_ICON)

--local berserkTimer							= mod:NewBerserkTimer(600)

mod:AddRangeFrameOption(4, 384558)
--mod:AddInfoFrameOption(361651, true)
--mod:AddSetIconOption("SetIconOnStaggeringBarrage", 361018, true, false, {1, 2, 3})
mod:AddNamePlateOption("NPAuraOnFixate", 384725)
mod:AddNamePlateOption("NPAuraOnMastersCall", 384638)
mod:AddNamePlateOption("NPAuraOnEnsnaringTrap", 384148)
mod:AddNamePlateOption("NPAuraOnHunterleadersTactics", 387889)

mod:GroupSpells(384764, 384725)--Group the two frenzy IDs

function mod:OnCombatStart(delay)
	timerEnsnaringTrapCD:Start(8.4-delay)
	timerGutShotCD:Start(12-delay)
	timerMeatTossCD:Start(20.5-delay)
	timerCallHyenasCD:Start(31-delay)
	timerMastersCallCD:Start(37-delay)
	if self.Options.NPAuraOnFixate or self.Options.NPAuraOnMastersCall or self.Options.NPAuraOnEnsnaringTrap or self.Options.NPAuraOnHunterleadersTactics then
		DBM:FireEvent("BossMod_EnableHostileNameplates")
	end
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(4)
	end
	DBM:AddMsg("still missing timers for a 2nd Call Hyenas and second Master's call due to undertuning of mythic 0 dungeons, if you see these casts and are logging, please share with DBM")
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
--	if self.Options.InfoFrame then
--		DBM.InfoFrame:Hide()
--	end
	if self.Options.NPAuraOnFixate or self.Options.NPAuraOnMastersCall or self.Options.NPAuraOnEnsnaringTrap or self.Options.NPAuraOnHunterleadersTactics then
		DBM.Nameplate:Hide(true, nil, nil, nil, true, true)
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 384416 then
		timerMeatTossCD:Start()
	elseif spellId == 384827 or spellId == 385435 then
		warnCallHyenas:Show()
		timerCallHyenasCD:Start()
	elseif spellId == 384633 then
--		timerMastersCallCD:Start()
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnMastersCall:Show(args.sourceName)
			specWarnMastersCall:Play("kickcast")
		end
	elseif spellId == 384353 then
		if self:IsTanking("player", "boss1", nil, true) then
			specWarnGutShot:Show()
			specWarnGutShot:Play("defensive")
		end
		timerGutShotCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 383979 then
		timerEnsnaringTrapCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 385356 then
		warnEnsnaringTrap:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			specWarnEnsnaringTrap:Show()
			specWarnEnsnaringTrap:Play("targetyou")
			yellEnsnaringTrap:Yell()
		end
	elseif spellId == 384425 then
		warnSmellLikeMeat:Show(args.destName)
	elseif spellId == 384764 and self:AntiSpam(3, 1) then
		specWarnFeedingFrenzy:Show(args.destName)
		specWarnFeedingFrenzy:Play("enrage")
	elseif spellId == 384725 and args:IsPlayer() then
		if self:AntiSpam(3, 2) then
			specWarnFeedingFrenzyYou:Show()
			specWarnFeedingFrenzyYou:Play("justrun")
		end
		if self.Options.NPAuraOnFixate then
			DBM.Nameplate:Show(true, args.sourceGUID, spellId, nil, 10)
		end
	elseif spellId == 384638 then
		if self.Options.NPAuraOnMastersCall then
			DBM.Nameplate:Show(true, args.destGUID, spellId, nil, 5)
		end
	elseif spellId == 384148 then
		if args:IsDestTypeHostile() then--Nameplates used to show them being used on adds
			if self.Options.NPAuraOnEnsnaringTrap then
				DBM.Nameplate:Show(true, args.destGUID, spellId, nil, 6)
			end
		else--Alerts are shown for players fucking them up

		end
	elseif spellId == 387889 then
		if self.Options.NPAuraOnHunterleadersTactics then
			DBM.Nameplate:Show(true, args.destGUID, spellId)
		end
	end
end
--mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 384725 and args:IsPlayer() then
		if self.Options.NPAuraOnFixate then
			DBM.Nameplate:Hide(true, args.sourceGUID, spellId)
		end
	elseif spellId == 384638 then
		if self.Options.NPAuraOnMastersCall then
			DBM.Nameplate:Hide(true, args.destGUID, spellId)
		end
	elseif spellId == 384148 and args:IsDestTypeHostile() then
		if self.Options.NPAuraOnEnsnaringTrap then
			DBM.Nameplate:Hide(true, args.destGUID, spellId)
		end
	elseif spellId == 387889 then
		if self.Options.NPAuraOnHunterleadersTactics then
			DBM.Nameplate:Show(true, args.destGUID, spellId)
		end
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
