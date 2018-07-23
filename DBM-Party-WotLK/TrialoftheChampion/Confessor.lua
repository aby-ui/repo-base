local mod	= DBM:NewMod(636, "DBM-Party-WotLK", 13, 284)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 236 $"):sub(12, -3))
mod:SetCreatureID(34928)
--mod:SetEncounterID(338, 339, 2023)--DO NOT ENABLE. Confessor and Eadric are both flagged as same encounterid ("Argent Champion")
--mod:SetZone()

mod:RegisterCombat("combat")
mod:RegisterKill("yell", L.YellCombatEnd)

mod:RegisterEventsInCombat(
   "SPELL_AURA_APPLIED",
   "SPELL_AURA_REMOVED"
)

local warnReflectiveShield	= mod:NewTargetAnnounce(66515, 2)
local warnRenew				= mod:NewTargetAnnounce(66537, 2)
local warnOldWounds			= mod:NewTargetAnnounce(66620, 3)
local timerOldWounds		= mod:NewTargetTimer(12, 66620)
local warnHolyFire			= mod:NewTargetAnnounce(66538, 3)
local timerHolyFire			= mod:NewTargetTimer(8, 66538)
local warnShadows			= mod:NewTargetAnnounce(66619, 2)
local timerShadows          = mod:NewTargetTimer(5, 66619)
local specwarnRenew			= mod:NewSpecialWarningDispel(66537, "MagicDispeller")

local shielded = false

function mod:OnCombatStart(delay)
   shielded = false
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 66515 then												-- Shield Gained
		warnReflectiveShield:Show(args.destName)
		shielded = true
	elseif args.spellId == 66537 and not args:IsDestTypePlayer() then	-- Renew
		if args.destName == L.name and shielded then
			-- nothing, she casted it on herself and you cant dispel
		else
            warnRenew:Show(args.destName)
			specwarnRenew:Show(args.destName)
		end
	elseif args.spellId == 66620 then									-- Old Wounds
		warnOldWounds:Show(args.destName)
		timerOldWounds:Show(args.destName)
	elseif args.spellId == 66538 and args:IsDestTypePlayer() then	-- Holy Fire
		warnHolyFire:Show(args.destName)
		timerHolyFire:Show(args.destName)
	elseif args.spellId == 66619 then									-- Shadows of the Past
		warnShadows:Show(args.destName)
		timerShadows:Show(args.destName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 66515 then
		shielded = false
	elseif args.spellId == 66538 then									-- Holy Fire
		timerHolyFire:Cancel(args.destName)
	elseif args.spellId == 66619 then									-- Shadows of the Past
		timerShadows:Cancel(args.destName)
	end
end