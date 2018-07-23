local mod = DBM:NewMod(602, "DBM-Party-WotLK", 16, 276)
local L = mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 236 $"):sub(12, -3))
mod:SetCreatureID(38113)
mod:SetEncounterID(839, 840, 1993)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_SUCCESS"
)

local warnWellCorruption		= mod:NewSpellAnnounce(72362, 3)
local warnCorruptedFlesh		= mod:NewSpellAnnounce(72363, 3)

local specWarnWellCorruption	= mod:NewSpecialWarningMove(72362)

local timerWellCorruptionCD		= mod:NewCDTimer(13, 72362)
local timerCorruptedFlesh		= mod:NewBuffActiveTimer(8, 72363)
local timerCorruptedFleshCD		= mod:NewCDTimer(20, 72363)

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 72362 and args:IsPlayer() then
		specWarnWellCorruption:Show()
	elseif args.spellId == 72363 then
		if self:AntiSpam(5) then
			warnCorruptedFlesh:Show()
			timerCorruptedFlesh:Start()
			timerCorruptedFleshCD:Start()
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 72362 then
		warnWellCorruption:Show()
		timerWellCorruptionCD:Start()
	end
end