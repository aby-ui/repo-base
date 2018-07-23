local mod	= DBM:NewMod(635, "DBM-Party-WotLK", 13, 284)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 236 $"):sub(12, -3))
mod:SetCreatureID(35119)
--mod:SetEncounterID(338, 339, 2023)--DO NOT ENABLE. Confessor and Eadric are both flagged as same encounterid ("Argent Champion")
mod:SetUsedIcons(8)
--mod:SetZone()

mod:RegisterCombat("combat")
mod:RegisterKill("yell", L.YellCombatEnd)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED"
)

local warnHammerofRighteous		= mod:NewSpellAnnounce(66867, 3)
local warnVengeance             = mod:NewSpellAnnounce(66889, 3)
local warnHammerofJustice		= mod:NewTargetAnnounce(66940, 2)
local timerVengeance			= mod:NewBuffActiveTimer(6, 66889)
local specwarnRadiance			= mod:NewSpecialWarning("specwarnRadiance")
local specwarnHammerofJustice	= mod:NewSpecialWarningDispel(66940, "Healer")

mod:AddBoolOption("SetIconOnHammerTarget", false)

function mod:SPELL_CAST_START(args)
	if args.spellId == 66935 then					-- Radiance Look Away!
		specwarnRadiance:Show()
	elseif args.spellId == 66867 then				-- Hammer of the Righteous
		warnHammerofRighteous:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 66940 then								-- Hammer of Justice on <Player>
		if self.Options.SetIconOnHammerTarget then
			self:SetIcon(args.destName, 8, 6)
		end
		warnHammerofJustice:Show(args.destName)
		specwarnHammerofJustice:Show(args.destName)
	elseif args.spellId == 66889 then							-- Vengeance
		warnVengeance:Show(args.destName)
		timerVengeance:Start(args.destName)
	end
end

