local mod	= DBM:NewMod(634, "DBM-Party-WotLK", 13, 284)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(34657, 34701, 34702, 34703, 34705, 35569, 35570, 35571, 35572, 35617)
mod:SetEncounterID(334, 336, 2022)

mod:RegisterCombat("combat")
mod:SetWipeTime(60)--prevent wipe for no vehicle user
mod:SetDetectCombatInVehicle(false)

mod:RegisterKill("yell", L.YellCombatEnd)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 67528",
	"SPELL_CAST_SUCCESS 66045",
	"SPELL_AURA_APPLIED 66043 67534 67594"
)

local warnHealingWave		= mod:NewSpellAnnounce(67528, 2)
local warnPolymorph			= mod:NewTargetAnnounce(66043, 1)

local specWarnPoison		= mod:NewSpecialWarningMove(67594, nil, nil, nil, 1, 8)
local specWarnHaste			= mod:NewSpecialWarningDispel(66045, "MagicDispeller", nil, nil, 1, 2)
local specWarnHex			= mod:NewSpecialWarningDispel(67534, "RemoveCurse", nil, nil, 1, 2)

function mod:SPELL_CAST_START(args)
	if args.spellId == 67528 then								-- Healing Wave
		warnHealingWave:Show()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 66045 and not args:IsDestTypePlayer() then-- Haste
		specWarnHaste:Show(args.destName)
		specWarnHaste:Play("dispelboss")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 66043 then								-- Polymorph on <x>
		warnPolymorph:Show(args.destName)
	elseif args.spellId == 67534 and self:CheckDispelFilter() then							-- Hex of Mending on <x>
		specWarnHex:Show(args.destName)
		specWarnHex:Play("helpdispel")
	elseif args.spellId == 67594 and args:IsPlayer() then		-- Standing in Poison Bottle.
		specWarnPoison:Show()
		specWarnPoison:Play("watchfeet")
	end
end

