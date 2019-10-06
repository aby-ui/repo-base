local mod	= DBM:NewMod(635, "DBM-Party-WotLK", 13, 284)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(35119)
--mod:SetEncounterID(338, 339, 2023)--DO NOT ENABLE. Confessor and Eadric are both flagged as same encounterid ("Argent Champion")
--mod:SetZone()

mod:RegisterCombat("combat")
mod:RegisterKill("yell", L.YellCombatEnd)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 66935 66867",
	"SPELL_AURA_APPLIED 66940 66889 66905"
)


local warnHammerofRighteous		= mod:NewSpellAnnounce(66867, 3)
local warnVengeance             = mod:NewTargetNoFilterAnnounce(66889, 3)

local specwarnRadiance			= mod:NewSpecialWarningLookAway(66935, nil, nil, nil, 2, 2)
local specwarnHammerofJustice	= mod:NewSpecialWarningDispel(66940, "Healer", nil, nil, 1, 2)
local specwarnHammerofRighteous	= mod:NewSpecialWarningYou(66905, nil, nil, nil, 1, 2)

function mod:SPELL_CAST_START(args)
	if args.spellId == 66935 then
		specwarnRadiance:Show(args.sourceName)
		specwarnRadiance:Play("turnaway")
	elseif args.spellId == 66867 then
		warnHammerofRighteous:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 66940 and self:CheckDispelFilter() then
		specwarnHammerofJustice:Show(args.destName)
		specwarnHammerofJustice:Play("helpdispel")
	elseif args.spellId == 66889 then
		warnVengeance:Show(args.destName)
	elseif args.spellId == 66905 and args:IsPlayer() then
		specwarnHammerofRighteous:Show()
		specwarnHammerofRighteous:Play("useitem")
	end
end
