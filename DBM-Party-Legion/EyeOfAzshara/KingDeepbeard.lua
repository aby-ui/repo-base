local mod	= DBM:NewMod(1491, "DBM-Party-Legion", 3, 716)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220116042005")
mod:SetCreatureID(91797)
mod:SetEncounterID(1812)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 193152 193093 193018",
	"SPELL_CAST_SUCCESS 193051"
)

--TODO: Info frame that shows all player name and sheild remaining for Gaseous Bubbles
local specWarnQuake					= mod:NewSpecialWarningSpell(193152, nil, nil, nil, 2, 2)
local specWarnCallSeas				= mod:NewSpecialWarningDodge(193051, nil, nil, nil, 2, 2)
local specWarnGroundSlam			= mod:NewSpecialWarningDodge(193093, "Tank", nil, nil, 3, 2)
local specWarnBubbles				= mod:NewSpecialWarningSpell(193018, "-Tank", nil, nil, 1, 6)

local timerQuakeCD					= mod:NewCDTimer(21.8, 193152, nil, nil, nil, 2)--21-25
local timerCallSeasCD				= mod:NewNextTimer(30, 193051, nil, nil, nil, 2)
local timerGroundSlamCD				= mod:NewCDTimer(18.2, 193093, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON)--18.2-30
local timerBubblesCD				= mod:NewNextTimer(32, 193018, nil, "-Tank", nil, 3, nil, DBM_COMMON_L.DEADLY_ICON)

mod:AddRangeFrameOption(5, 193152)

function mod:OnCombatStart(delay)
--	timerGroundSlamCD:Start(6-delay)--More data, 6-32? pssht
	timerBubblesCD:Start(10-delay)
	timerQuakeCD:Start(15-delay)
	timerCallSeasCD:Start(20-delay)
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 193152 then
		specWarnQuake:Show()
		specWarnQuake:Play("range5")
		timerQuakeCD:Start()
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(5, nil, nil, nil, nil, 5.5)
		end
	elseif spellId == 193093 then
		specWarnGroundSlam:Show()
		specWarnGroundSlam:Play("shockwave")
		timerGroundSlamCD:Start()
	elseif spellId == 193018 then
		specWarnBubbles:Show()
		specWarnBubbles:Play("takedamage")
		timerBubblesCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 193051 then
		specWarnCallSeas:Show()
		specWarnCallSeas:Play("watchstep")
		timerCallSeasCD:Start()
	end
end
