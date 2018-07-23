local mod	= DBM:NewMod(634, "DBM-Party-WotLK", 13, 284)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 236 $"):sub(12, -3))
mod:SetCreatureID(34657, 34701, 34702, 34703, 34705, 35569, 35570, 35571, 35572, 35617)
mod:SetEncounterID(334, 336, 2022)
mod:SetMinSyncRevision(7)--Could break if someone is running out of date version with higher revision

mod:RegisterCombat("combat")
mod:SetWipeTime(60)--prevent wipe for no vehicle user
mod:SetDetectCombatInVehicle(false)

mod:RegisterKill("yell", L.YellCombatEnd)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

local warnHealingWave		= mod:NewSpellAnnounce(67528, 2)
local warnHaste				= mod:NewTargetAnnounce(66045, 2)
local warnPolymorph			= mod:NewTargetAnnounce(66043, 1)
local warnHexOfMending		= mod:NewTargetAnnounce(67534, 1)
local specWarnPoison		= mod:NewSpecialWarningMove(67594)
local specWarnHaste			= mod:NewSpecialWarningDispel(66045, "MagicDispeller")

function mod:SPELL_CAST_START(args)
	if args.spellId == 67528 then								-- Healing Wave
		warnHealingWave:Show()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 66045 and not args:IsDestTypePlayer() then-- Haste
		warnHaste:Show(args.destName)
		specWarnHaste:Show(args.destName)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 66043 then								-- Polymorph on <x>
		warnPolymorph:Show(args.destName)
	elseif args.spellId == 67534 then							-- Hex of Mending on <x>
		warnHexOfMending:Show(args.destName)
	elseif args.spellId == 67594 and args:IsPlayer() then		-- Standing in Poison Bottle.
		specWarnPoison:Show()
	end
end

