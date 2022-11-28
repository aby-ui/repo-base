local mod	= DBM:NewMod(1139, "DBM-Party-WoD", 6, 537)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "normal,heroic,mythic,challenge,timewalker"

mod:SetRevision("20221127051031")
mod:SetCreatureID(75509)
mod:SetEncounterID(1677)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 153240 153153 164974",
	"SPELL_AURA_APPLIED 153094"
)

--[[
(ability.id = 153240 or ability.id = 153153 or ability.id = 164974) and type = "cast"
 or type = "dungeonencounterstart" or type = "dungeonencounterend"
--]]
local warnDaggerFall			= mod:NewSpellAnnounce(153240, 3)

local specWarnDarkCommunion		= mod:NewSpecialWarningSwitch(153153, nil, nil, 2, 1, 2)--On Test, even tank and healer needed to dps to kill it. I'm going to assume it's an overtuning and at least excempt healer.
local specWarnWhispers			= mod:NewSpecialWarningSpell(153094, nil, nil, nil, 2, 2)
local specWarnDarkEclipse		= mod:NewSpecialWarningSpell(164974, nil, nil, nil, 3, 12)

--local timerDaggerfallCD			= mod:NewCDTimer(15.7, 153240, nil, nil, nil, 3)--15-20, or 57
local timerDarkCommunionCD		= mod:NewCDTimer(46.1, 153153, nil, nil, nil, 1, nil, DBM_COMMON_L.DAMAGE_ICON)--Can get delayed by a lot
local timerDarkEclipseCD		= mod:NewCDTimer(45.5, 164974, nil, nil, nil, 6)--Can get delayed by a lot

function mod:OnCombatStart(delay)
--	timerDaggerfallCD:Start(8.7-delay)
	timerDarkCommunionCD:Start(24-delay)
	timerDarkEclipseCD:Start(44.9-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 153240 then
		warnDaggerFall:Show()
--		timerDaggerfallCD:Stop()
	elseif spellId == 153153 then
		specWarnDarkCommunion:Show()
		specWarnDarkCommunion:Play("killmob")
		timerDarkCommunionCD:Start()

--		timerDaggerfallCD:Restart(43.6)
	elseif spellId == 164974 then
		specWarnDarkEclipse:Show()
		specWarnDarkEclipse:Play("touchwhiteshrooms")
		timerDarkEclipseCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 153094 then
		specWarnWhispers:Show()
		specWarnWhispers:Play("aesoon")
	end
end
