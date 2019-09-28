local mod	= DBM:NewMod(191, "DBM-Party-Cataclysm", 10, 77)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190421035925")
mod:SetCreatureID(23863)
mod:SetEncounterID(1194)
mod:SetZone()
mod:SetUsedIcons(8)

mod:RegisterCombat("combat")
mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 43093 17207 43150 97497 42402",
	"SPELL_AURA_REMOVED 43093 42594 42606 42607 42608",
	"SPELL_CAST_START 42594 42606 42607 42608 97930",
	"SPELL_CAST_SUCCESS 43095",
	"SPELL_DAMAGE 43217",
	"SPELL_MISSED 43217"
)
mod.onlyHeroic = true

local warnThrow				= mod:NewTargetNoFilterAnnounce(43093, 3)
local warnWhirlwind			= mod:NewSpellAnnounce(17207, 3)
local warnBear				= mod:NewSpellAnnounce(42594, 3)
local warnEagle				= mod:NewSpellAnnounce(42606, 3)
local warnLynx				= mod:NewSpellAnnounce(42607, 3)
local warnDragonhawk		= mod:NewSpellAnnounce(42608, 3)
local warnParalysis			= mod:NewSpellAnnounce(43095, 4)--Bear Form
local warnSurge				= mod:NewTargetNoFilterAnnounce(42402, 3)--Bear Form
local warnClawRage			= mod:NewTargetNoFilterAnnounce(43150, 3)--Lynx Form
local warnLightningTotem	= mod:NewSpellAnnounce(97930, 4)--Eagle Form

local specWarnFlameBreath	= mod:NewSpecialWarningMove(97497, nil, nil, nil, 1, 2)
local specWarnBurn			= mod:NewSpecialWarningMove(43217, nil, nil, nil, 1, 2)

local timerThrow			= mod:NewNextTimer(15, 43093, nil, nil, nil, 5, nil, DBM_CORE_HEALER_ICON)
local timerParalysisCD		= mod:NewNextTimer(27, 43095, nil, nil, nil, 5, nil, DBM_CORE_HEALER_ICON..DBM_CORE_MAGIC_ICON)
local timerSurgeCD			= mod:NewNextTimer(8.5, 42402, nil, nil, nil, 3)--Bear Form Ability, same mechanic as bear boss, cannot soak more than 1 before debuff fades or you will die.
local timerLightningTotemCD	= mod:NewNextTimer(17, 97930, nil, nil, nil, 1, nil, DBM_CORE_DAMAGE_ICON)--Eagle Form Ability.

mod:AddSetIconOption("ThrowIcon", 43093, false, false, {8})
mod:AddSetIconOption("ClawRageIcon", 43150, false, false, {8})
mod:AddBoolOption("InfoFrame")

local surgeDebuff = DBM:GetSpellInfo(42402)

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 43093 then
		warnThrow:Show(args.destName)
		timerThrow:Start()
		if self.Options.ThrowIcon then
			self:SetIcon(args.destName, 8)
		end
	elseif args.spellId == 17207 then
		warnWhirlwind:Show()
	elseif args.spellId == 43150 then
		warnClawRage:Show(args.destName)
		if self.Options.ClawRageIcon then
			self:SetIcon(args.destName, 8, 5)
		end
	elseif args.spellId == 97497 and args:IsPlayer() and self:IsInCombat() and self:AntiSpam(3, 1) then
		specWarnFlameBreath:Show()
		specWarnFlameBreath:Play("watchfeet")
	elseif args.spellId == 42402 then
		warnSurge:Show(args.destName)
		timerSurgeCD:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 43093 and self.Options.ThrowIcon then
		self:SetIcon(args.destName, 0)
	elseif args.spellId == 42594 then--Bear
		timerSurgeCD:Cancel()
		timerParalysisCD:Cancel()
		if self.Options.InfoFrame then
			DBM.InfoFrame:Hide()
		end
	elseif args.spellId == 42606 then--Eagle
		timerLightningTotemCD:Cancel()
	elseif args.spellId == 42607 then--Lynx

	elseif args.spellId == 42608 then--Dragonhawk

	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 42594 then
		timerThrow:Cancel()
		warnBear:Show()
		timerParalysisCD:Start(2.5)
		timerSurgeCD:Start()
		if self.Options.InfoFrame then
			DBM.InfoFrame:SetHeader(L.PlayerDebuffs)
			DBM.InfoFrame:Show(5, "playerbaddebuff", surgeDebuff)
		end
	elseif args.spellId == 42606 then
		timerThrow:Cancel()
		warnEagle:Show()
		timerLightningTotemCD:Start(10)
	elseif args.spellId == 42607 then
		timerThrow:Cancel()
		warnLynx:Show()
	elseif args.spellId == 42608 then
		timerThrow:Cancel()
		warnDragonhawk:Show()
	elseif args.spellId == 97930 then
		timerThrow:Cancel()
		warnLightningTotem:Show()
		timerLightningTotemCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 43095 then
		warnParalysis:Show()
		timerParalysisCD:Start()
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 43217 and destGUID == UnitGUID("player") and self:AntiSpam(3, 2) then
		specWarnBurn:Show()
		specWarnBurn:Play("watchfeet")
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE
