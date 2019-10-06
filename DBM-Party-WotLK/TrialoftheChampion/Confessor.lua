local mod	= DBM:NewMod(636, "DBM-Party-WotLK", 13, 284)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(34928)
--mod:SetEncounterID(338, 339, 2023)--DO NOT ENABLE. Confessor and Eadric are both flagged as same encounterid ("Argent Champion")
--mod:SetZone()

mod:RegisterCombat("combat")
mod:RegisterKill("yell", L.YellCombatEnd)

mod:RegisterEventsInCombat(
   "SPELL_AURA_APPLIED 66515 66537 66620 66538 66619",
   "SPELL_AURA_REMOVED 66515 66538 66619"
)

local warnReflectiveShield	= mod:NewTargetNoFilterAnnounce(66515, 2)
local warnOldWounds			= mod:NewTargetAnnounce(66620, 3)

local specwarnRenew			= mod:NewSpecialWarningDispel(66537, "MagicDispeller", nil, nil, 1, 2)
local specwarnHolyFire		= mod:NewSpecialWarningDispel(66538, "Healer", nil, nil, 1, 2)
local specwarnShadows		= mod:NewSpecialWarningDispel(66619, "Healer", nil, nil, 1, 2)

local timerHolyFire			= mod:NewTargetTimer(8, 66538, nil, "Healer", 2, 5, nil, DBM_CORE_MAGIC_ICON)
local timerShadows          = mod:NewTargetTimer(5, 66619, nil, "Healer", 2, 5, nil, DBM_CORE_MAGIC_ICON)

mod.vb.shielded = false

function mod:OnCombatStart(delay)
   self.vb.shielded = false
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 66515 then												-- Shield Gained
		warnReflectiveShield:Show(args.destName)
		self.vb.shielded = true
	elseif args.spellId == 66537 and not args:IsDestTypePlayer() then	-- Renew
		if args.destName == L.name and self.vb.shielded then
			-- nothing, she casted it on herself and you cant dispel
		else
			specwarnRenew:Show(args.destName)
			specwarnRenew:Play("dispelboss")
		end
	elseif args.spellId == 66620 then									-- Old Wounds
		warnOldWounds:Show(args.destName)
	elseif args.spellId == 66538 and args:IsDestTypePlayer() then	-- Holy Fire
		if self:CheckDispelFilter() then
			specwarnHolyFire:Show(args.destName)
			specwarnHolyFire:Play("helpdispel")
		end
		timerHolyFire:Show(args.destName)
	elseif args.spellId == 66619 and args:IsDestTypePlayer() then			-- Shadows of the Past
		if self:CheckDispelFilter() then
			specwarnShadows:Show(args.destName)
			specwarnShadows:Play("helpdispel")
		end
		timerShadows:Show(args.destName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 66515 then
		self.vb.shielded = false
	elseif args.spellId == 66538 then									-- Holy Fire
		timerHolyFire:Cancel(args.destName)
	elseif args.spellId == 66619 then									-- Shadows of the Past
		timerShadows:Cancel(args.destName)
	end
end
