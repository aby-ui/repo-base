local mod	= DBM:NewMod(1686, "DBM-Party-Legion", 9, 777)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "normal,heroic,mythic"

mod:SetRevision("20220909231726")
mod:SetCreatureID(101950)
mod:SetEncounterID(1846)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
--	"SPELL_AURA_APPLIED 201146",
	"SPELL_CAST_START 201920 201153 201148"
)

--TODO: review timers for hysteria and Doom later, right now they are all over place and unreliable
--NOTE: Even more data, i'm confident everything he does is based on health, no timers.
local warnShadowCrash				= mod:NewSpellAnnounce(201920, 3)

local specWarnDoom					= mod:NewSpecialWarningDefensive(201148, "Tank", nil, nil, 1, 2)
--local specWarnHysteria				= mod:NewSpecialWarningDispel(201146, "Healer", nil, nil, 1, 2)
local specWarnEternalDarkness		= mod:NewSpecialWarningSwitch(201153, "-Healer", nil, nil, 3, 2)

--local timerShadowCrashCD			= mod:NewCDTimer(8.7, 201920, nil, nil, nil, 3)--8-23 second variation, no thank you.
--local timerEternalDarknessCD		= mod:NewCDTimer(37.5, 201153, nil, nil, nil, 1)

function mod:OnCombatStart(delay)
--	timerEternalDarknessCD:Start(14-delay)--Maybe not a timer?
end

--[[
function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 201146 then
		specWarnHysteria:Show(args.destName)
		specWarnHysteria:Play("dispelnow")
	end
end
--]]

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 201920 then
		warnShadowCrash:Show()
--		timerShadowCrashCD:Start()
	elseif spellId == 201153 then
		specWarnEternalDarkness:Show()
		specWarnEternalDarkness:Play("mobkill")
--		timerEternalDarknessCD:Start()
	elseif spellId == 201148 then
		specWarnDoom:Show()
		specWarnDoom:Play("defensive")
	end
end
