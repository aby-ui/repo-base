local mod	= DBM:NewMod("AuchTrash", "DBM-Party-WoD", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
--mod:SetModelID(47785)
mod:SetZone()

mod.isTrashMod = true

mod:RegisterEvents(
	"SPELL_CAST_START 157173 157797 154527 154623 160312"
)

local warnVoidShell					= mod:NewSpellAnnounce(160312, 3)

local specWarnBendWill				= mod:NewSpecialWarningInterrupt(154527, "HasInterrupt", nil, 2, 1, 2)
local specWarnVoidShell				= mod:NewSpecialWarningDispel(160312, "MagicDispeller", nil, nil, 1, 2)
local specWarnVoidMending			= mod:NewSpecialWarningInterrupt(154623, "HasInterrupt", nil, 2, 1, 2)
local specWarnFelStomp				= mod:NewSpecialWarningDodge(157173, "Tank", nil, nil, 1, 2)
local specWarnArbitersHammer		= mod:NewSpecialWarningInterrupt(157797, "HasInterrupt", nil, 2, 1, 2)

local isTrivial = mod:IsTrivial(110)

function mod:SPELL_CAST_START(args)
	if not self.Options.Enabled or self:IsDifficulty("normal5") or isTrivial then return end
	local spellId = args.spellId
	if spellId == 157173 then
		specWarnFelStomp:Show()
		specWarnFelStomp:Play("shockwave")
	elseif spellId == 157797 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnArbitersHammer:Show(args.sourceName)
		specWarnArbitersHammer:Play("kickcast")
	elseif spellId == 154527 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnBendWill:Show(args.sourceName)
		specWarnBendWill:Play("kickcast")
	elseif spellId == 154623 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnVoidMending:Show(args.sourceName)
		specWarnVoidMending:Play("kickcast")
	elseif spellId == 160312 then
		if self.Options.SpecWarn160312dispel then
			specWarnVoidShell:Schedule(2, SPELL_TARGET_TYPE13_DESC)--"enemies"
			specWarnVoidShell:ScheduleVoice(2, "helpdispel")
		else
			warnVoidShell:Schedule(2)
		end
	end
end
