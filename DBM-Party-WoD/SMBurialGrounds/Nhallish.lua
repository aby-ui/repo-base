local mod	= DBM:NewMod(1168, "DBM-Party-WoD", 6, 537)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "normal,heroic,mythic,challenge,timewalker"

mod:SetRevision("20221127051031")
mod:SetCreatureID(75829)
mod:SetEncounterID(1688)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 152801",
	"SPELL_AURA_APPLIED 152979 153067",
	"SPELL_AURA_REMOVED 152979",
	"SPELL_PERIODIC_DAMAGE 153070",
	"SPELL_ABSORBED 153070"
)

--[[
(ability.id = 152801 or ability.id = 153067) and type = "begincast"
 or ability.id = 152979 and type = "applydebuff"
 or type = "dungeonencounterstart" or type = "dungeonencounterend"
--]]
local specWarnVoidVortex		= mod:NewSpecialWarningRun(152801, nil, nil, 2, 4, 2)
local specWarnSoulShred			= mod:NewSpecialWarningSpell(152979, nil, nil, nil, 1, 2)
local specWarnVoidDevastation	= mod:NewSpecialWarningSpell(153067, nil, nil, nil, 2, 2)
local specWarnVoidDevastationM	= mod:NewSpecialWarningMove(153070, nil, nil, nil, 1, 8)

local timerVoidVortexCD			= mod:NewCDTimer(77, 152801, nil, nil, nil, 2)
local timerSoulShredCD			= mod:NewNextTimer(77, 152979, nil, nil, nil, 6)
local timerSoulShred			= mod:NewBuffFadesTimer(20, 152979)
local timerVoidDevastationCD	= mod:NewNextTimer(77, 153067, nil, nil, nil, 3)

function mod:OnCombatStart(delay)
	timerVoidVortexCD:Start(22.7-delay)
	timerSoulShredCD:Start(37-delay)
	timerVoidDevastationCD:Start(65.3-delay)
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 152801 then
		timerVoidVortexCD:Start()
		specWarnVoidVortex:Show()
		specWarnVoidVortex:Play("runaway")
	elseif spellId == 153067 then
		specWarnVoidDevastation:Show()
		specWarnVoidDevastation:Play("aesoon")
		timerVoidDevastationCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 152979 and self:AntiSpam() then--SPELL_CAST_SUCCESS is missing so have to scan for debuffs
		specWarnSoulShred:Show()
		timerSoulShredCD:Start()
		timerSoulShred:Start()
		specWarnSoulShred:Play("killspirit")
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 152979 and args:IsPlayer() then
		timerSoulShred:Cancel()
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, destName, _, _, spellId)
	if spellId == 153070 and destGUID == UnitGUID("player") and self:AntiSpam(2, 1) then
		specWarnVoidDevastationM:Show()
		specWarnVoidDevastationM:Play("watchfeet")
	end
end
mod.SPELL_ABSORBED = mod.SPELL_PERIODIC_DAMAGE
