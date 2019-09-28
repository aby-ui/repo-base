local mod	= DBM:NewMod(1207, "DBM-Party-WoD", 5, 556)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(83894, 83892, 83893)--Dulhu 83894, Gola 83892, Telu
mod:SetEncounterID(1757)
mod:SetBossHPInfoToHighest()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 168082 168041 168105 168383 175997",
	"SPELL_CAST_SUCCESS 168375",
	"SPELL_AURA_APPLIED 168105 168041 168520",
	"SPELL_AURA_REMOVED 168520",
	"SPELL_PERIODIC_DAMAGE 167977",
	"SPELL_ABSORBED 167977",
	"UNIT_DIED"
)

--Timers are too difficult to do, rapidTides messes up any chance of ever having decent timers.
local warnGraspingVine				= mod:NewTargetNoFilterAnnounce(168375, 2)
local warnShapersFortitude			= mod:NewTargetNoFilterAnnounce(168520, 3)

local specWarnRevitalizingWaters	= mod:NewSpecialWarningInterrupt(168082, "HasInterrupt", nil, 2, 1, 2)
local specWarnBriarskin				= mod:NewSpecialWarningInterrupt(168041, false, nil, nil, 1, 2)--if you have more than one interruptor, great. but off by default because we can't assume you can interrupt every bosses abilities. and heal takes priority
local specWarnBriarskinDispel		= mod:NewSpecialWarningDispel(168041, false, nil, nil, 1, 2)--Not as important as rapid Tides and to assume you have at least two dispellers is big assumption
local specWarnRapidTidesDispel		= mod:NewSpecialWarningDispel(168105, "MagicDispeller", nil, nil, 3, 2)
local specWarnSlash					= mod:NewSpecialWarningDodge(168383, nil, nil, nil, 2, 2)
local yellSlash						= mod:NewYell(168383)
local specWarnNoxious				= mod:NewSpecialWarningRun(175997, nil, nil, 2, 4, 2)
local specWarnBramble				= mod:NewSpecialWarningMove(167977, nil, nil, nil, 1, 8)

local timerShapersFortitude			= mod:NewTargetTimer(8, 168520, nil, false, 2, 5)
local timerNoxiousCD				= mod:NewCDTimer(16, 175997, nil, "Melee", nil, 2)
local timerGraspingVineCD			= mod:NewNextTimer(31.5, 168375, nil, nil, nil, 3)

mod:AddNamePlateOption("NPAuraOnFort", 168520)

mod.vb.lastGrasping = nil

function mod:OnCombatStart(delay)
	self.vb.lastGrasping = nil
	if self.Options.NPAuraOnFort then
		DBM:FireEvent("BossMod_EnableHostileNameplates")
	end
end

function mod:OnCombatEnd()
	if self.Options.NPAuraOnFort then
		DBM.Nameplate:Hide(true, nil, nil, nil, true, true)
	end
end

function mod:GraspingVineTarget(targetname, uId)
	if not targetname then 
		self.vb.lastGrasping = nil
		return
	end
	warnGraspingVine:Show(targetname)
	self.vb.lastGrasping = targetname
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 168082 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnRevitalizingWaters:Show(args.sourceName)
		if self:IsTank() then
			specWarnRevitalizingWaters:Play("kickcast")
		else
			specWarnRevitalizingWaters:Play("helpkick")
		end
	elseif spellId == 168041 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnBriarskin:Show(args.sourceName)
		specWarnBriarskin:Play("kickcast")
	elseif spellId == 168383 then
		if self.vb.lastGrasping and self.vb.lastGrasping == UnitName("player") then
			yellSlash:Yell()
		else
			specWarnSlash:Show()
			specWarnSlash:Play("watchstep")
		end
	elseif spellId == 175997 then
		specWarnNoxious:Show()
		timerNoxiousCD:Start()
		specWarnNoxious:Play("justrun")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 168375 then
		self:BossTargetScanner(83894, "GraspingVineTarget", 0.05, 10)
		timerGraspingVineCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 168105 then
		specWarnRapidTidesDispel:Show(args.destName)
		specWarnRapidTidesDispel:Play("dispelboss")
	elseif spellId == 168041 then
		specWarnBriarskinDispel:Show(args.destName)
		specWarnBriarskinDispel:Play("dispelboss")
	elseif spellId == 168520 then
		warnShapersFortitude:Show(args.destName)
		timerShapersFortitude:Start(args.destName)
		if self.Options.NPAuraOnFort then
			DBM.Nameplate:Show(true, args.destGUID, spellId, nil, 8)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 168520 then
		timerShapersFortitude:Cancel(args.destName)
		if self.Options.NPAuraOnFort then
			DBM.Nameplate:Hide(true, args.destGUID, spellId)
		end
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 167977 and destGUID == UnitGUID("player") and self:AntiSpam(2, 1) then
		specWarnBramble:Show()
		specWarnBramble:Play("watchfeet")
	end
end
mod.SPELL_ABSORBED = mod.SPELL_PERIODIC_DAMAGE

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 83894 then
		timerNoxiousCD:Cancel()
	end
end
