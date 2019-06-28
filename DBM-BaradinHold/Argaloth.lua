local mod	= DBM:NewMod(139, "DBM-BaradinHold", nil, 74)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("2019041705904")
mod:SetCreatureID(47120)
mod:SetEncounterID(1033)
mod:SetZone()
mod:SetUsedIcons(1, 2, 3, 4, 5, 6, 7, 8)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START",
	"SPELL_DAMAGE",
	"SPELL_MISSED",
	"UNIT_HEALTH boss1"
)

local warnConsuming			= mod:NewTargetAnnounce(88954, 3)
local warnMeteorSlash		= mod:NewSpellAnnounce(88942, 4)
local warnFirestorm			= mod:NewSpellAnnounce(88972, 4)
local warnFirestormSoon		= mod:NewSoonAnnounce(88972, 3)

local specWarnMeteorSlash	= mod:NewSpecialWarningSpell(88942, "Tank")
local specWarnFirestormCast	= mod:NewSpecialWarningSpell(88972, nil, nil, nil, true)
local specWarnFirestorm		= mod:NewSpecialWarningMove(89000)

local timerConsuming		= mod:NewBuffFadesTimer(15, 88954, nil, "Healer", 2, 5, nil, DBM_CORE_HEALER_ICON..DBM_CORE_MAGIC_ICON)
local timerConsumingCD		= mod:NewCDTimer(24, 88954, nil, "Healer", 2, 5, nil, DBM_CORE_HEALER_ICON)
local timerMeteorSlash		= mod:NewNextTimer(15, 88942, nil, nil, nil, 5, nil, DBM_CORE_TANK_ICON)
local timerFirestorm		= mod:NewBuffActiveTimer(15, 88972, nil, nil, nil, 6)
local timerFirestormCast	= mod:NewCastTimer(3, 88972, nil, nil, nil, 2)

local berserkTimer			= mod:NewBerserkTimer(300)

mod:AddBoolOption("SetIconOnConsuming", false)

local consumingTargets = {}
local consumingIcon = 8
local prewarnedFirestorm = false
local consuming = 0

local function showConsumingWarning()
	warnConsuming:Show(table.concat(consumingTargets, "<, >"))
	table.wipe(consumingTargets)
	consumingIcon = 8
	prewarnedFirestorm = false
end

function mod:OnCombatStart(delay)
	table.wipe(consumingTargets)
	consumingIcon = 8
	berserkTimer:Start(-delay)
	consuming = 0
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 88954 then
		consuming = consuming + 1--Count raid members who got consuming
		timerConsuming:Start()
		timerConsumingCD:Start()
		consumingTargets[#consumingTargets + 1] = args.destName
		if self.Options.SetIconOnConsuming then
			self:SetIcon(args.destName, consumingIcon)
			consumingIcon = consumingIcon - 1
		end
		self:Unschedule(showConsumingWarning)
		if (self:IsDifficulty("normal10") and #consumingTargets >= 3) or (self:IsDifficulty("normal25") and #consumingTargets >= 8) then
			showConsumingWarning()
		else
			self:Schedule(0.3, showConsumingWarning)
		end
	elseif args.spellId == 88972 then
		timerFirestorm:Start()
	elseif args.spellId == 88942 then--Debuff application not cast, special warning for tank taunts.
		if self:AntiSpam(3, 1) then
			warnMeteorSlash:Show()
			timerMeteorSlash:Start()
			specWarnMeteorSlash:Show()
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 88954 then
		consuming = consuming - 1--Count raid members who had it dispelled
		if self.Options.SetIconOnConsuming then
			self:SetIcon(args.destName, 0)
		end
		if consuming == 0 then--End Buff active timer when no raid members have it
			timerConsuming:Cancel()
		end
	elseif args.spellId == 88972 then
		timerMeteorSlash:Start(13)
		timerConsumingCD:Start(9)
	end
end
	
function mod:SPELL_CAST_START(args)
	if args.spellId == 88972 then
		warnFirestorm:Show()
		specWarnFirestormCast:Show()
		timerMeteorSlash:Cancel()
		timerConsumingCD:Cancel()
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 89000 and destGUID == UnitGUID("player") and self:AntiSpam(3, 2) then -- Flames on ground from Firestorm
		specWarnFirestorm:Show()
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 47120 then
		local h = UnitHealth(uId) / UnitHealthMax(uId) * 100
		if h > 75 or h > 45 and h < 55 then
			prewarnedFirestorm = false
		elseif not prewarnedFirestorm and (h > 69 and h < 72 or h > 35 and h < 38) then
			warnFirestormSoon:Show()
			prewarnedFirestorm = true
		end
	end
end
