local mod	= DBM:NewMod(1185, "DBM-Party-WoD", 1, 547)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143517")
mod:SetCreatureID(75839)--Soul Construct
mod:SetEncounterID(1686)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 153002 153006 157465",
	"SPELL_DAMAGE 161457",
	"SPELL_MISSED 161457"
)

local specWarnHolyShield		= mod:NewSpecialWarningTarget(153002, nil, nil, nil, 1, 2)
local yellHolyShield			= mod:NewYell(153002)
local specWarnConsecreatedLight	= mod:NewSpecialWarningSpell(153006, nil, nil, nil, 3, 2)
local specWarnFate				= mod:NewSpecialWarningSpell(157465, nil, nil, nil, 2, 2)
local specWarnSanctifiedGround	= mod:NewSpecialWarningMove(161457, nil, nil, nil, 1, 8)

local timerHolyShieldCD			= mod:NewNextTimer(47, 153002, nil, nil, nil, 3, nil, nil, nil, 1, 4)
local timerConsecratedLightCD	= mod:NewNextTimer(7, 153006, nil, nil, nil, 2, nil, DBM_CORE_DEADLY_ICON, nil, 2, 4)
local timerConsecratedLight		= mod:NewBuffActiveTimer(8, 153006)
local timerFateCD				= mod:NewCDTimer(37, 157465, nil, nil, nil, 3)--Need more logs to confirm

function mod:ShieldTarget(targetname, uId)
	if not targetname then return end
	specWarnHolyShield:Show(targetname)
	specWarnHolyShield:Play("findshield")
	if targetname == UnitName("player") then
		yellHolyShield:Yell()
	end
end

function mod:OnCombatStart(delay)
	timerFateCD:Start(25-delay)
	timerHolyShieldCD:Start(30-delay)
end

function mod:OnCombatEnd()

end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 153002 then
		self:BossTargetScanner(75839, "ShieldTarget", 0.02, 16)
		timerConsecratedLightCD:Start()
		timerHolyShieldCD:Start()
	elseif spellId == 153006 then
		specWarnConsecreatedLight:Show()
		specWarnConsecreatedLight:Play("findshelter")
		timerConsecratedLight:Start()
	elseif spellId == 157465 then
		specWarnFate:Show()
		specWarnFate:Play("watchstep")
		timerFateCD:Start()
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 161457 and destGUID == UnitGUID("player") and self:AntiSpam() then
		specWarnSanctifiedGround:Show()
		specWarnSanctifiedGround:Play("watchfeet")
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE
