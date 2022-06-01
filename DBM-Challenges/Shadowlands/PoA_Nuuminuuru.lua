local mod	= DBM:NewMod("Nuuminuuru", "DBM-Challenges", 1)
--L		= mod:GetLocalizedStrings()

mod.statTypes = "normal,heroic,mythic,challenge"

mod:SetRevision("20220530062110")
mod:SetCreatureID(172410)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 345680",
	"SPELL_CAST_SUCCESS 345441",
	"UNIT_SPELLCAST_SUCCEEDED"
)

local specWarnSymbioticShield			= mod:NewSpecialWarningSwitch(345441, nil, nil, nil, 1, 2)
local specWarnVolatileBurst				= mod:NewSpecialWarningSwitch(345680, nil, nil, nil, 1, 2)

local timerSymbioticShieldCD			= mod:NewCDTimer(41.4, 345441, nil, nil, nil, 1)
local timerNewFaerieCD					= mod:NewCDTimer(30.3, 345685, nil, nil, nil, 1)--Bursting Faerie, basically volatile burst CD
local berserkTimer						= mod:NewBerserkTimer(480)

function mod:OnCombatStart(delay)
	timerNewFaerieCD:Start(20.3-delay)
	timerSymbioticShieldCD:Start(40.9-delay)
	if self:IsHard() then
		berserkTimer:Start(100-delay)
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 345680 then
		specWarnVolatileBurst:Show()
		specWarnVolatileBurst:Play("killmob")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 345441 then
		specWarnSymbioticShield:Show()
		specWarnSymbioticShield:Play("killmob")
		timerSymbioticShieldCD:Start()
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 333198 or spellId == 348955 then--[DNT] Set World State: Win Encounter-/Kill Credit to Player Only
		DBM:EndCombat(self)
	elseif spellId == 345685 and self:AntiSpam(3, 1) then
		timerNewFaerieCD:Start()
	end
end
