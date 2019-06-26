local mod	= DBM:NewMod(173, "DBM-BlackwingDescent", nil, 73)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143316")
mod:SetCreatureID(41378)
mod:SetEncounterID(1025)
mod:SetZone()
mod:SetUsedIcons(1, 2, 3, 4, 6, 7, 8)
--mod:SetModelSound("Sound\\Creature\\Nefarian\\VO_BD_Nefarian_MaloriakIntro01.ogg", "Sound\\Creature\\Maloriak\\VO_BD_Maloriak_Event05.ogg")
--Long: Maloriak, try not to lose to these mortals. Semicompetent help is SO hard to create.
--Short: Mix and stir, apply heat...

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_INTERRUPT",
	"RAID_BOSS_EMOTE",
	"UNIT_HEALTH boss1"
)

local warnPhase					= mod:NewAnnounce("WarnPhase", 2)
local warnReleaseAdds			= mod:NewSpellAnnounce(77569, 3)
local warnRemainingAdds			= mod:NewAddsLeftAnnounce("ej2932", 2, 77569)
local warnFlashFreeze			= mod:NewTargetAnnounce(77699, 4)
local warnBitingChill			= mod:NewTargetAnnounce(77760, 3)
local warnRemedy				= mod:NewSpellAnnounce(77912, 3)
local warnArcaneStorm			= mod:NewSpellAnnounce(77896, 4)
local warnConsumingFlames		= mod:NewTargetAnnounce(77786, 3)
local warnScorchingBlast		= mod:NewSpellAnnounce(77679, 4)
local warnDebilitatingSlime		= mod:NewSpellAnnounce(77615, 2)
local warnMagmaJets				= mod:NewSpellAnnounce(78194, 4, nil, "Tank")
local warnEngulfingDarkness		= mod:NewSpellAnnounce(92754, 4, nil, "Tank|Healer")--Heroic Ability
local warnPhase2Soon			= mod:NewPrePhaseAnnounce(2, 3)
local warnPhase2				= mod:NewPhaseAnnounce(2, 4)
 
local timerPhase				= mod:NewTimer(49, "TimerPhase", 89250)--Just some random cauldron icon not actual spellid
local timerBitingChill			= mod:NewBuffFadesTimer(10, 77760)
local timerFlashFreeze			= mod:NewCDTimer(14, 77699)--Varies on other abilities CDs
local timerAddsCD				= mod:NewCDTimer(15, 77569, nil, "-Healer")--Varies on other abilities CDs
local timerArcaneStormCD		= mod:NewCDTimer(14, 77896)--Varies on other abilities CDs
local timerConsumingFlames		= mod:NewTargetTimer(10, 77786, nil, "Healer")
local timerScorchingBlast		= mod:NewCDTimer(10, 77679)--Varies on other abilities CDs
local timerDebilitatingSlime	= mod:NewBuffActiveTimer(15, 77615)
local timerMagmaJetsCD			= mod:NewNextTimer(10, 78194)
local timerEngulfingDarknessCD	= mod:NewNextTimer(12, 92754, nil, "Tank|Healer")--Heroic Ability

local specWarnBitingChill		= mod:NewSpecialWarningYou(77760)
local specWarnConsumingFlames	= mod:NewSpecialWarningYou(77786)
local specWarnSludge			= mod:NewSpecialWarningMove(92930)
local specWarnArcaneStorm		= mod:NewSpecialWarningInterrupt(77896, false)
local specWarnMagmaJets			= mod:NewSpecialWarningMove(78194, "Tank")
local specWarnEngulfingDarkness	= mod:NewSpecialWarningSpell(92754, "Tank|Healer")--Heroic Ability
local specWarnFlashFreeze		= mod:NewSpecialWarningTarget(77699, "Ranged")--On Heroic it has a lot more health.
local specWarnRemedy			= mod:NewSpecialWarningDispel(77912, "MagicDispeller")
local specWarnAdds				= mod:NewSpecialWarningSpell(77569, false)

local berserkTimer				= mod:NewBerserkTimer(420)

mod:AddBoolOption("FlashFreezeIcon")
mod:AddBoolOption("BitingChillIcon", false)
mod:AddBoolOption("ConsumingFlamesIcon", false)
mod:AddBoolOption("RangeFrame")
mod:AddBoolOption("SetTextures", true)--Just about ALL friendly spells cover dark sludge and make it very hard to see it.

local adds = 18
local AddsInterrupted = false
local bitingChillTargets = {}
local flashFreezeTargets = {}
local bitingChillIcon = 6
local flashFreezeIcon = 8
local prewarnedPhase2 = false
local CVAR = false
local Red = DBM:EJ_GetSectionInfo(2935)
local Green = DBM:EJ_GetSectionInfo(2941)
local Blue = DBM:EJ_GetSectionInfo(2938)
local Dark = DBM:EJ_GetSectionInfo(2943)

local function showBitingChillWarning()
	warnBitingChill:Show(table.concat(bitingChillTargets, "<, >"))
	table.wipe(bitingChillTargets)
	bitingChillIcon = 6
	timerBitingChill:Start()
end

local function showFlashFreezeWarning()
	warnFlashFreeze:Show(table.concat(flashFreezeTargets, "<, >"))
	table.wipe(flashFreezeTargets)
	flashFreezeIcon = 8
	timerFlashFreeze:Start()
end

local function InterruptCheck()
	if not AddsInterrupted then
		adds = adds - 3
		warnRemainingAdds:Show(adds)
	end
	AddsInterrupted = false
end

function mod:OnCombatStart(delay)
	if self:IsDifficulty("heroic10", "heroic25") then
		berserkTimer:Start(720-delay)--12 min berserk on heroic
	else
		berserkTimer:Start(-delay)--7 min on normal
	end
	adds = 18
	AddsInterrupted = false
	bitingChillIcon = 6
	flashFreezeIcon = 8
	prewarnedPhase2 = false
	CVAR = false
	timerArcaneStormCD:Start(10-delay)--10-15 seconds from pull
	timerAddsCD:Start()--This may or may not happen depending on arcane storms duration and when it was cast.
	timerPhase:Start(18.5-delay)
	table.wipe(bitingChillTargets)
	table.wipe(flashFreezeTargets)
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.SetTextures and not GetCVarBool("projectedTextures") and CVAR then
		SetCVar("projectedTextures", 1)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 77699 then
		flashFreezeTargets[#flashFreezeTargets + 1] = args.destName
		if mod:IsDifficulty("heroic10", "heroic25") then
			specWarnFlashFreeze:Show(args.destName)
		end
		if self.Options.FlashFreezeIcon then
			self:SetIcon(args.destName, flashFreezeIcon)
			flashFreezeIcon = flashFreezeIcon - 1
		end
		self:Unschedule(showFlashFreezeWarning)
		self:Schedule(0.3, showFlashFreezeWarning)
	elseif args.spellId == 77760 then
		bitingChillTargets[#bitingChillTargets + 1] = args.destName
		if self.Options.BitingChillIcon then
			self:SetIcon(args.destName, bitingChillIcon)
			bitingChillIcon = bitingChillIcon - 1
		end
		if args:IsPlayer() then
			specWarnBitingChill:Show()
		end
		self:Unschedule(showBitingChillWarning)
		self:Schedule(0.3, showBitingChillWarning)
	elseif args.spellId == 77912 and not args:IsDestTypePlayer() then
		warnRemedy:Show()
		specWarnRemedy:Show(args.destName)
	elseif args.spellId == 77786 then
		warnConsumingFlames:Show(args.destName)
		timerConsumingFlames:Start(args.destName)
		if self.Options.ConsumingFlamesIcon then
			self:SetIcon(args.destName, 7)
		end
		if args:IsPlayer() then
			specWarnConsumingFlames:Show()
		end
	elseif args.spellId == 77615 and self:AntiSpam(3, 1) then
		warnDebilitatingSlime:Show()
		timerDebilitatingSlime:Start()
	elseif args.spellId == 92930 and args:IsPlayer() and self:AntiSpam(3, 2) then
		specWarnSludge:Show()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 77699 then
		if self.Options.FlashFreezeIcon then
			self:SetIcon(args.destName, 0)
		end
	elseif args.spellId == 77760 then
		if self.Options.BitingChillIcon then
			self:SetIcon(args.destName, 0)
		end
	elseif args.spellId == 77786 then
		if self.Options.ConsumingFlamesIcon then
			self:SetIcon(args.destName, 0)
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 77569 then
		warnReleaseAdds:Show()
		specWarnAdds:Show()--Special case that does not use standardized melee/ranged check do to fact this one usually has very specific assignments and may have a melee assigned that has to be warned regardless of target.
		timerAddsCD:Start()
		if adds >= 3 then--only schedule it if there actually are adds left.
			self:Schedule(3, InterruptCheck)
		end
	elseif args.spellId == 77991 then
		warnPhase2:Show()
		timerMagmaJetsCD:Start()
		timerFlashFreeze:Cancel()
		timerScorchingBlast:Cancel()
		timerAddsCD:Cancel()
		timerEngulfingDarknessCD:Cancel()
		if self.Options.SetTextures and not GetCVarBool("projectedTextures") and CVAR then
			SetCVar("projectedTextures", 1)
		end
	elseif args.spellId == 92754 then
		warnEngulfingDarkness:Show()
		timerEngulfingDarknessCD:Start()
		if self:GetUnitCreatureId("target") == 41378 or self:GetBossTarget(33186) == DBM:GetUnitFullName("target") then--First check is for tank (tank is targeting boss), second check is for HEALER< IE, the HEALER is targeting the bosses TARGET
			specWarnEngulfingDarkness:Show()
		end
	elseif args.spellId == 77896 then
		warnArcaneStorm:Show()
		timerArcaneStormCD:Start()
		specWarnArcaneStorm:Show(args.sourceName)
	elseif args.spellId == 78194 then
		warnMagmaJets:Show()
		if self:IsDifficulty("heroic10", "heroic25") then
			timerMagmaJetsCD:Start(5)
		else
			timerMagmaJetsCD:Start()
		end
		if self:GetUnitCreatureId("target") == 41378 then--Add tank doesn't need this spam, just tank on mal.
			specWarnMagmaJets:Show()
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 77679 then
		warnScorchingBlast:Show()
		timerScorchingBlast:Start()
	end
end

function mod:SPELL_INTERRUPT(args)
	if type(args.extraSpellId) == "number" and (args.extraSpellId == 77569) then
		AddsInterrupted = true
	end
end

function mod:RAID_BOSS_EMOTE(msg)
	if msg == L.YellRed or msg:find(L.YellRed) then
		warnPhase:Show(Red)
		timerAddsCD:Start()
		timerArcaneStormCD:Start(19)
		timerScorchingBlast:Start(22)
		timerPhase:Start()
		timerFlashFreeze:Cancel()
		timerEngulfingDarknessCD:Cancel()
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
		if self.Options.SetTextures and not GetCVarBool("projectedTextures") and CVAR then
			SetCVar("projectedTextures", 1)
		end
	elseif msg == L.YellBlue or msg:find(L.YellBlue) then
		warnPhase:Show(Blue)
		timerPhase:Start()
		timerAddsCD:Start()
		timerArcaneStormCD:Start(19)
		timerFlashFreeze:Start(22)
		timerScorchingBlast:Cancel()
		timerEngulfingDarknessCD:Cancel()
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(6)
		end
		if self.Options.SetTextures and not GetCVarBool("projectedTextures") and CVAR then
			SetCVar("projectedTextures", 1)
		end
	elseif msg == L.YellGreen or msg:find(L.YellGreen) then
		warnPhase:Show(Green)
		timerPhase:Start()
		timerAddsCD:Start()
		timerArcaneStormCD:Start(12)--First one is always shorter in green phase then other 2.
		timerFlashFreeze:Cancel()
		timerScorchingBlast:Cancel()
		timerEngulfingDarknessCD:Cancel()
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
	elseif msg == L.YellDark or msg:find(L.YellDark) then
		warnPhase:Show(Dark)
		timerEngulfingDarknessCD:Start(16.5)
		timerPhase:Start(100)
		timerArcaneStormCD:Cancel()
		timerAddsCD:Cancel()
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
		if self.Options.SetTextures and GetCVarBool("projectedTextures") then
			CVAR = true
			SetCVar("projectedTextures", 0)
		end
	end
end

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 41378 then
		local h = UnitHealth(uId) / UnitHealthMax(uId) * 100
		if h > 35 and prewarnedPhase2 then
			prewarnedPhase2 = false
		elseif h > 24 and h < 29 and not prewarnedPhase2 then
			prewarnedPhase2 = true
			warnPhase2Soon:Show()
		end
	end
end
