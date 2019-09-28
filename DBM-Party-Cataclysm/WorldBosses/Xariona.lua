local mod	= DBM:NewMod("Xariona", "DBM-Party-Cataclysm", 15)
local L		= mod:GetLocalizedStrings()

mod:SetRevision((string.sub("20190414033732", 1, -5)):sub(12, -3))
mod:SetCreatureID(50061)
mod:SetModelID(32229)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 93556 93546",
	"SPELL_CAST_SUCCESS 93553",
	"SPELL_AURA_APPLIED 93551",
	"SPELL_AURA_REMOVED 93551",
	"UNIT_POWER_FREQUENT",
	"UNIT_SPELLCAST_SUCCEEDED"
)
mod.onlyNormal = true

local warnTwilightZone			= mod:NewSpellAnnounce(93553, 2)--Used for protection against UnleashedMagic
local warnTwilightFissure		= mod:NewTargetNoFilterAnnounce(93546, 3)--Typical void zone.
local warnTwilightBuffet		= mod:NewTargetNoFilterAnnounce(93551, 3, nil, "Healers", 2)
local warnUnleashedMagicSoon	= mod:NewPreWarnAnnounce(93556, 10, 3)

local specWarnUnleashedMagic	= mod:NewSpecialWarningMoveTo(93556, nil, nil, nil, 3, 2)
local specWarnTwilightFissure	= mod:NewSpecialWarningYou(93546, nil, nil, nil, 1, 2)

local timerTwilightFissureCD	= mod:NewCDTimer(23, 93546, nil, nil, nil, 3)
local timerTwilightZoneCD		= mod:NewNextTimer(30, 93553, nil, nil, nil, 3)
local timerTwilightBuffetCD		= mod:NewCDTimer(20, 93551, nil, nil, nil, 3, nil, DBM_CORE_MAGIC_ICON)
local timerTwilightBuffet		= mod:NewTargetTimer(10, 93551, nil, "Healer", nil, 5, nil, DBM_CORE_HEALER_ICON..DBM_CORE_MAGIC_ICON)
local timerUnleashedMagicCD		= mod:NewCDTimer(66, 93556, nil, nil, nil, 2)--66 Cd but least priority spell, she will cast breath, fissure zone or buffet before this, so overlapping CDs often delay this upwards to 5 seconds late

local specialCharging = false
local hasPower = false
local zoneName = DBM:GetSpellInfo(93553)

function mod:FissureTarget()
	local targetname = self:GetBossTarget(50061)
	if not targetname then return end
	if targetname == UnitName("player") then
		specWarnTwilightFissure:Show()
		specWarnTwilightFissure:Play("targetyou")
	else
		warnTwilightFissure:Show(targetname)
	end
end

function mod:OnCombatStart(delay)
	specialCharging = false
	hasPower = false
	timerTwilightBuffetCD:Start(10-delay)
	timerTwilightZoneCD:Start(-delay)--Not a large sample size but seems like it'd be right.
	timerTwilightFissureCD:Start(-delay)--May not be right, not a large sample size
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 93556 then
		specWarnUnleashedMagic:Show(zoneName)
		specWarnUnleashedMagic:Play("findshelter")
		timerUnleashedMagicCD:Start()
	elseif args.spellId == 93546 then
		self:ScheduleMethod(0.2, "FissureTarget")
		timerTwilightFissureCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 93553 then
		warnTwilightZone:Show()
		timerTwilightZoneCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 93551 then
		warnTwilightBuffet:Show(args.destName)
		timerTwilightBuffet:Start(args.destName)
		timerTwilightBuffetCD:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 93551 then
		timerTwilightBuffet:Cancel(args.destName)
	end
end

function mod:UNIT_POWER_FREQUENT(uId)
	if self:GetUnitCreatureId(uId) == 50061 and UnitPower(uId) == 70 and specialCharging then
		warnUnleashedMagicSoon:Schedule(8)
		timerUnleashedMagicCD:Start(18)--Start a bar in case one doesn't exist, so update function can do it's thing after.
		timerUnleashedMagicCD:Update(48, 66)--Create/update bar here if one doesn't exist or it's wrong (since it varies sometimes if she delays her energy gain spell)
	elseif self:GetUnitCreatureId(uId) == 50061 and UnitPower(uId) >= 0 and not hasPower then
		hasPower = true
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 93554 and not specialCharging then -- Fury of the twilight flight. Sometimes she bugs and doesn't cast this,if she doesnt, she won't gain unit power and thus won't use any specials.
		specialCharging = true
		if not hasPower then--She retains power from previous wipes, so only start this bar if it's 0 on engage, otherwise don't bother, let update function start it later
			timerUnleashedMagicCD:Start()
		end
	end
end
