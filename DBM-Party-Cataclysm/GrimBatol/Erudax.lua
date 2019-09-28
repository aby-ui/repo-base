local mod	= DBM:NewMod(134, "DBM-Party-Cataclysm", 3, 71)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(40484)
mod:SetEncounterID(1049)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 75861 75792",
	"SPELL_CAST_START 75763 79467",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

local warnBinding		= mod:NewTargetAnnounce(75861, 3)
local warnFeeble		= mod:NewTargetAnnounce(75792, 3, nil, "Tank|Healer", 2)
local warnUmbralMending	= mod:NewSpellAnnounce(75763, 4)

local specWarnMending	= mod:NewSpecialWarningInterrupt(75763, nil, nil, nil, 1, 2)
local specWarnGale		= mod:NewSpecialWarningSpell(75664, nil, nil, nil, 2, 2)
local specWarnAdds		= mod:NewSpecialWarningSwitch("ej3378", "Dps", nil, nil, 3, 2)

local timerFeebleCD		= mod:NewCDTimer(26, 75792, nil, "Tank", nil, 5, nil, DBM_CORE_TANK_ICON)
local timerFeeble		= mod:NewTargetTimer(3, 75792, nil, "Tank|Healer", 2, 5)
local timerGale			= mod:NewCastTimer(5, 75664, nil, nil, nil, 2)
local timerGaleCD		= mod:NewCDTimer(55, 75664, nil, nil, nil, 2)
local timerAddsCD		= mod:NewCDTimer(54.5, 75704, nil, nil, nil, 1)

function mod:OnCombatStart(delay)
	timerFeebleCD:Start(16-delay)
	timerGaleCD:Start(23-delay)
--	timerAddsCD:Start(95-delay)--First ones don't start until boss reaches % health of some sort?
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 75861 then
		warnBinding:CombinedShow(0.3, args.destName)
	elseif spellId == 75792 then
		warnFeeble:Show(args.destName)
		timerFeebleCD:Start()
		if self:IsDifficulty("normal") then
			timerFeeble:Start(args.destName)
		else
			timerFeeble:Start(5, args.destName)
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(75763, 79467) and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnMending:Show()
		specWarnMending:Play("kickcast")
	end
end

--Sometimes boss fails to cast gale so no SPELL_CAST_START event. This ensures we still detect cast and start timers
function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 75656 then
		specWarnGale:Show()
		specWarnGale:Play("findshelter")
		timerGale:Start()
		timerGaleCD:Start()
	elseif spellId == 75704 then
		specWarnAdds:Show()
		specWarnAdds:Play("killmob")
		timerAddsCD:Start()
	end
end
