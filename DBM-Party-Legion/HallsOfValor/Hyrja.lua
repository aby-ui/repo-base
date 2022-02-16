local mod	= DBM:NewMod(1486, "DBM-Party-Legion", 4, 721)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220116042005")
mod:SetCreatureID(95833)
mod:SetEncounterID(1806)

mod:RegisterCombat("combat")
mod:SetWipeTime(120)

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 192048 192133 192132",
	"SPELL_AURA_REMOVED 192048",
	"SPELL_CAST_START 192158 192018 192307 200901 192288",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--Notes: Saw no timer consistency since they are all over the place based on where boss is dragged.
--TODO: maybe figure out how dragging boss around affects timers. Might be worth the work for a 5 man boss though.
--["192044-Expel Light"] = "pull:79.7, 26.6, 30.3, 24.3, 30.3",
--Maybe add a searing light interrupt helper if it matters enough on mythic+
local warnExpelLight				= mod:NewTargetAnnounce(192048, 3)
local warnPhase2					= mod:NewPhaseAnnounce(2, 2, nil, nil, nil, nil, nil, 2)

local specWarnShieldOfLight			= mod:NewSpecialWarningDefensive(192018, "Tank", nil, nil, 3, 2)--Journal lies, this is NOT dodgable
local specWarnSanctify				= mod:NewSpecialWarningDodge(192158, nil, nil, nil, 2, 5)
local specWarnEyeofStorm			= mod:NewSpecialWarningMoveTo(200901, nil, nil, nil, 2, 2)
local specWarnExpelLight			= mod:NewSpecialWarningMoveAway(192048, nil, nil, nil, 2, 2)
local yellExpelLight				= mod:NewYell(192048)
local specWarnSearingLight			= mod:NewSpecialWarningInterrupt(192288, "HasInterrupt", nil, nil, 1, 2)

local timerShieldOfLightCD			= mod:NewCDTimer(28, 192018, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON, nil, mod:IsTank() and 2, 4)--28-34
local timerSpecialCD				= mod:NewNextTimer(30, 200736, nil, nil, nil, 2, 200901, DBM_COMMON_L.DEADLY_ICON, nil, 1, 4)--Shared timer by eye of storm and Sanctify
--local timerExpelLightCD			= mod:NewCDTimer(24, 192048, nil, nil, nil, 3)--More review 24-30

mod:AddRangeFrameOption(8, 192048)

local eyeShortName = DBM:GetSpellInfo(91320)--Inner Eye

function mod:OnCombatStart(delay)
	self:SetStage(1)
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 192048 then
		if args:IsPlayer() then
			specWarnExpelLight:Show()
			specWarnExpelLight:Play("runout")
			yellExpelLight:Yell()
			if self.Options.RangeFrame then
				DBM.RangeCheck:Hide()
			end
		else
			warnExpelLight:Show(args.destName)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 192048 and args:IsPlayer() and self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 192158 or spellId == 192307 then
		specWarnSanctify:Show()
		specWarnSanctify:Play("watchorb")
		if spellId == 192307 then
			timerSpecialCD:Start()
		end
	elseif spellId == 192018 then
		specWarnShieldOfLight:Show()
		specWarnShieldOfLight:Play("defensive")
		timerShieldOfLightCD:Start()
	elseif spellId == 200901 then
		specWarnEyeofStorm:Show(eyeShortName)
		specWarnEyeofStorm:Play("findshelter")
		if self.vb.phase == 2 then
			timerSpecialCD:Start()
		end
	elseif spellId == 192288 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnSearingLight:Show(args.sourceName)
		specWarnSearingLight:Play("kickcast")
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 192130 then
		self:SetStage(2)
		warnPhase2:Show()
		warnPhase2:Play("ptwo")
		timerSpecialCD:Start(8.5)
		timerShieldOfLightCD:Start(24)
	end
end
