local mod	= DBM:NewMod(112, "DBM-Party-Cataclysm", 7, 67)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(42188)
mod:SetEncounterID(1058)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 80467 78939",
	"SPELL_AURA_REMOVED 78939",
	"SPELL_CAST_START 78807 92426 78903",
	"UNIT_HEALTH boss1"
)

local warnShatterSoon		= mod:NewSoonAnnounce(78807, 3)
local warnBulwark			= mod:NewSpellAnnounce(78939, 3)
local warnEnrage			= mod:NewSpellAnnounce(80467, 3, nil, "Tank")
local warnEnrageSoon		= mod:NewSoonAnnounce(80467, 2, nil, "Tank")

local specWarnGroundSlam	= mod:NewSpecialWarningDodge(78903, "Tank", nil, nil, 1, 2)
local specWarnShatter		= mod:NewSpecialWarningRun(78807, "Melee", nil, 2, 4, 2)

--local timerShatterCD		= mod:NewCDTimer(19, 78807)
local timerBulwark			= mod:NewBuffActiveTimer(10, 78939, nil, nil, nil, 5, nil, DBM_CORE_MAGIC_ICON)
local timerBulwarkCD		= mod:NewCDTimer(20, 78939, nil, nil, nil, 5, nil, DBM_CORE_MAGIC_ICON)
local timerShatter			= mod:NewCastTimer(3, 78807, nil, "Melee", 2, 2, nil, DBM_CORE_DEADLY_ICON)

mod.vb.prewarnEnrage = false

function mod:OnCombatStart(delay)
	self.vb.prewarnEnrage = false
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 80467 then
		warnEnrage:Show()
	elseif args.spellId == 78939 then
		warnBulwark:Show()
		timerBulwark:Start()
		timerBulwarkCD:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 78939 then--This can be dispelled.
		timerBulwark:Cancel()
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 78807 then
		timerShatter:Start()
--		timerShatterCD:Start()
		specWarnShatter:Show()
		specWarnShatter:Play("justrun")
	elseif args.spellId == 92426 then
		warnShatterSoon:Show()
	elseif args.spellId == 78903 then
		specWarnGroundSlam:Show()
		specWarnGroundSlam:Play("shockwave")
	end
end

function mod:UNIT_HEALTH(uId)
	local h = UnitHealth(uId) / UnitHealthMax(uId)
	if h > 75 and self.vb.prewarnEnrage then
		self.vb.prewarnEnrage = false
	elseif h > 33 and h < 37 and not self.vb.prewarnEnrage then
		warnEnrageSoon:Show()
		self.vb.prewarnEnrage = true
	end
end