local mod	= DBM:NewMod("HoVTrash", "DBM-Party-Legion", 4)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220116042005")
--mod:SetModelID(47785)

mod.isTrashMod = true

mod:RegisterEvents(
	"SPELL_CAST_START 199805 192563 199726"
)

local warnCrackle					= mod:NewTargetAnnounce(199805, 2)

local specWarnCrackle				= mod:NewSpecialWarningDodge(199805, nil, nil, nil, 1, 2)
local yellCrackle					= mod:NewYell(199805)
local specWarnCleansingFlame		= mod:NewSpecialWarningInterrupt(192563, "HasInterrupt", nil, nil, 1, 2)
local specWarnUnrulyYell			= mod:NewSpecialWarningInterrupt(199726, "HasInterrupt", nil, nil, 1, 2)

function mod:CrackleTarget(targetname, uId)
	if not targetname then
		warnCrackle:Show(DBM_COMMON_L.UNKNOWN)
		return
	end
	if targetname == UnitName("player") then
		specWarnCrackle:Show()
		specWarnCrackle:Play("watchstep")
		yellCrackle:Yell()
	else
		warnCrackle:Show(targetname)
	end
end

function mod:SPELL_CAST_START(args)
	if not self.Options.Enabled then return end
	local spellId = args.spellId
	if spellId == 199805 then
		self:BossTargetScanner(args.sourceGUID, "CrackleTarget", 0.1, 9)
	elseif spellId == 192563 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnCleansingFlame:Show(args.sourceName)
		specWarnCleansingFlame:Play("kickcast")
	elseif spellId == 199726 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnUnrulyYell:Show(args.sourceName)
		specWarnUnrulyYell:Play("kickcast")
	end
end
