local mod	= DBM:NewMod("Deathwhisper", "DBM-Icecrown", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417005949")
mod:SetCreatureID(36855)
mod:SetEncounterID(1100)
mod:SetModelID(30893)
mod:SetUsedIcons(4, 5, 6, 7, 8)
mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 71289 71001 71237 70674 71204",
	"SPELL_AURA_APPLIED_DOSE 71204",
	"SPELL_AURA_REMOVED 70842",
	"SPELL_CAST_START 71420 70900 70901 71236",
	"SPELL_SUMMON 71426",
	"CHAT_MSG_MONSTER_YELL",
	"UNIT_TARGET_UNFILTERED"
)

local warnAddsSoon					= mod:NewAnnounce("WarnAddsSoon", 2)
local warnDominateMind				= mod:NewTargetAnnounce(71289, 3)
local warnSummonSpirit				= mod:NewSpellAnnounce(71426, 2)
local warnReanimating				= mod:NewAnnounce("WarnReanimating", 3)
local warnDarkTransformation		= mod:NewSpellAnnounce(70900, 4)
local warnDarkEmpowerment			= mod:NewSpellAnnounce(70901, 4)
local warnPhase2					= mod:NewPhaseAnnounce(2, 1)
local warnTouchInsignificance		= mod:NewStackAnnounce(71204, 2, nil, "Tank|Healer")

local specWarnCurseTorpor			= mod:NewSpecialWarningYou(71237, nil, nil, nil, 1, 2)
local specWarnDeathDecay			= mod:NewSpecialWarningMove(71001, nil, nil, nil, 1, 2)
local specWarnTouchInsignificance	= mod:NewSpecialWarningStack(71204, nil, 3, nil, nil, 1, 6)
local specWarnVampricMight			= mod:NewSpecialWarningDispel(70674, "MagicDispeller", nil, nil, 1, 2)
local specWarnDarkMartyrdom			= mod:NewSpecialWarningRun(71236, "Melee", nil, nil, 4, 2)
local specWarnFrostbolt				= mod:NewSpecialWarningInterrupt(71420, "HasInterrupt", nil, 2, 1, 2)

local timerAdds						= mod:NewTimer(60, "TimerAdds", 61131, nil, nil, 1, DBM_CORE_TANK_ICON..DBM_CORE_DAMAGE_ICON)
local timerDominateMind				= mod:NewBuffActiveTimer(12, 71289)
local timerDominateMindCD			= mod:NewCDTimer(40, 71289, nil, nil, nil, 3)
local timerSummonSpiritCD			= mod:NewCDTimer(10, 71426, nil, false)
local timerTouchInsignificance		= mod:NewTargetTimer(30, 71204, nil, "Tank|Healer", nil, 5)

local berserkTimer					= mod:NewBerserkTimer(600)

mod:AddBoolOption("SetIconOnDominateMind", true)
mod:AddBoolOption("SetIconOnDeformedFanatic", true)
mod:AddBoolOption("SetIconOnEmpoweredAdherent", true)
mod:AddInfoFrameOption(70842, true)

local dominateMindTargets = {}
mod.vb.dominateMindIcon = 6
local deformedFanatic
local empoweredAdherent
local shieldName = DBM:GetSpellInfo(70842)

local function showDominateMindWarning(self)
	warnDominateMind:Show(table.concat(dominateMindTargets, "<, >"))
	timerDominateMind:Start()
	timerDominateMindCD:Start()
	table.wipe(dominateMindTargets)
	self.vb.dominateMindIcon = 6
end

local function addsTimer(self)
	timerAdds:Cancel()
	warnAddsSoon:Cancel()
	if self:IsDifficulty("heroic10") or self:IsDifficulty("heroic25") then
		warnAddsSoon:Schedule(40)	-- 5 secs prewarning
		self:Schedule(45, addsTimer, self)
		timerAdds:Start(45)
	else
		warnAddsSoon:Schedule(55)	-- 5 secs prewarning
		self:Schedule(60, addsTimer, self)
		timerAdds:Start()
	end
end

local function TrySetTarget(self)
	if DBM:GetRaidRank() >= 1 then
		for uId in DBM:GetGroupMembers() do
			if UnitGUID(uId.."target") == deformedFanatic and self.Options.SetIconOnDeformedFanatic then
				deformedFanatic = nil
				SetRaidTarget(uId.."target", 8)
			elseif UnitGUID(uId.."target") == empoweredAdherent and self.Options.SetIconOnEmpoweredAdherent then
				empoweredAdherent = nil
				SetRaidTarget(uId.."target", 7)
			end
			if not (deformedFanatic or empoweredAdherent) then
				break
			end
		end
	end
end

function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
	timerAdds:Start(7)
	warnAddsSoon:Schedule(4)			-- 3sec pre-warning on start
	self:Schedule(7, addsTimer, self)
	if not self:IsDifficulty("normal10") then
		timerDominateMindCD:Start(30)		-- Sometimes 1 fails at the start, then the next will be applied 70 secs after start ?? :S
	end
	table.wipe(dominateMindTargets)
	self.vb.dominateMindIcon = 6
	deformedFanatic = nil
	empoweredAdherent = nil
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(shieldName)
		DBM.InfoFrame:Show(2, "enemyabsorb", nil, UnitGetTotalAbsorbs("boss1"))
	end
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 71289 then
		dominateMindTargets[#dominateMindTargets + 1] = args.destName
		if self.Options.SetIconOnDominateMind then
			self:SetIcon(args.destName, self.vb.dominateMindIcon, 12)
		end
		self.vb.dominateMindIcon = self.vb.dominateMindIcon - 1
		self:Unschedule(showDominateMindWarning)
		if self:IsDifficulty("heroic10", "normal25") or (self:IsDifficulty("heroic25") and #dominateMindTargets >= 3) then
			showDominateMindWarning(self)
		else
			self:Schedule(0.9, showDominateMindWarning, self)
		end
	elseif args.spellId == 71001 and not self:IsTrivial(100) then
		if args:IsPlayer() then
			specWarnDeathDecay:Show()
			specWarnDeathDecay:Play("runaway")
		end
	elseif args.spellId == 71237 and args:IsPlayer() and not self:IsTrivial(100) then
		specWarnCurseTorpor:Show()
		specWarnCurseTorpor:Play("targetyou")
	elseif args.spellId == 70674 and not args:IsDestTypePlayer() and (UnitName("target") == L.Fanatic1 or UnitName("target") == L.Fanatic2 or UnitName("target") == L.Fanatic3) then
		specWarnVampricMight:Show(args.destName)
		specWarnVampricMight:Play("helpdispel")
	elseif args.spellId == 71204 then
		timerTouchInsignificance:Start(args.destName)
		local amount = args.amount or 1
		if args:IsPlayer() and amount >= 3 then
			specWarnTouchInsignificance:Show(amount)
			specWarnTouchInsignificance:Play("stackhigh")
		else
			warnTouchInsignificance:Show(args.destName, amount)
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 70842 then
		warnPhase2:Show()
		if self:IsDifficulty("normal10", "normal25") then
			timerAdds:Cancel()
			warnAddsSoon:Cancel()
			self:Unschedule(addsTimer)
		end
		if self.Options.InfoFrame then
			DBM.InfoFrame:Hide()
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 71420 and self:CheckInterruptFilter(args.sourceGUID) then
		specWarnFrostbolt:Show(args.sourceName)
		specWarnFrostbolt:Play("kickcast")
	elseif args.spellId == 70900 then
		warnDarkTransformation:Show()
		if self.Options.SetIconOnDeformedFanatic then
			deformedFanatic = args.sourceGUID
			TrySetTarget(self)
		end
	elseif args.spellId == 70901 then
		warnDarkEmpowerment:Show()
		if self.Options.SetIconOnEmpoweredAdherent then
			empoweredAdherent = args.sourceGUID
			TrySetTarget(self)
		end
	elseif args.spellId == 71236 and not self:IsTrivial(100) then
		specWarnDarkMartyrdom:Show()
		specWarnDarkMartyrdom:Play("justrun")
	end
end

function mod:SPELL_SUMMON(args)
	if args.spellId == 71426 and self:AntiSpam(5, 1) then -- Summon Vengeful Shade
		warnSummonSpirit:Show()
		timerSummonSpiritCD:Start()
	end
end

function mod:UNIT_TARGET_UNFILTERED()
	if empoweredAdherent or deformedFanatic then
		TrySetTarget(self)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellReanimatedFanatic or msg:find(L.YellReanimatedFanatic) then
		warnReanimating:Show()
	end
end
