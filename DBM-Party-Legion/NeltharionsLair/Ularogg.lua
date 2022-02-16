local mod	= DBM:NewMod(1665, "DBM-Party-Legion", 5, 767)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220116042005")
mod:SetCreatureID(91004)
mod:SetEncounterID(1791)
mod:SetHotfixNoticeRev(15186)
mod:SetUsedIcons(8)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 198496 216290 193375",
	"SPELL_CAST_SUCCESS 216290",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

local warnStrikeofMountain			= mod:NewTargetAnnounce(216290, 2)
local warnBellowofDeeps				= mod:NewSpellAnnounce(193375, 2)--Change to special warning if they become important enough to switch to
local warnStanceofMountain			= mod:NewSpellAnnounce(216249, 2)

local specWarnSunder				= mod:NewSpecialWarningDefensive(198496, "Tank", nil, 2, 1, 2)
local specWarnStrikeofMountain		= mod:NewSpecialWarningDodge(216290, nil, nil, nil, 1, 2)
local yellStrikeofMountain			= mod:NewYell(216290)

local timerSunderCD					= mod:NewCDTimer(7.5, 198496, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON)
local timerStrikeCD					= mod:NewCDTimer(15, 216290, nil, nil, nil, 3)
local timerStanceOfMountainCD		= mod:NewCDTimer(119.5, 216249, nil, nil, nil, 6)

function mod:OnCombatStart(delay)
	timerSunderCD:Start(7-delay)
	timerStrikeCD:Start(15.8-delay)
	--timerStanceOfMountainCD:Start(26.7-delay)
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 198496 then
		specWarnSunder:Show()
		specWarnSunder:Play("defensive")
		timerSunderCD:Start()
	elseif spellId == 216290 then
		timerStrikeCD:Start()
	elseif spellId == 193375 then
		warnBellowofDeeps:Show()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 216290 then
		if args:IsPlayer() then
			specWarnStrikeofMountain:Show()
			specWarnStrikeofMountain:Play("targetyou")
			yellStrikeofMountain:Yell()
		else
			warnStrikeofMountain:Show(args.destName)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 198509 then--Stance of the Mountain
		warnStanceofMountain:Show()
		timerSunderCD:Stop()
		timerStrikeCD:Stop()
		--timerStanceOfMountainCD:Stop()
		--timerStanceOfMountainCD:Start()--Only seems to do it once now
	elseif spellId == 198631 then--Stance of mountain ending
		timerSunderCD:Stop()
		timerStrikeCD:Stop()
		timerSunderCD:Start(3)
		timerStrikeCD:Start(16)
	end
end
