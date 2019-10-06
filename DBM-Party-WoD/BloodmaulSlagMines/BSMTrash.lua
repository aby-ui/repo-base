local mod	= DBM:NewMod("BSMTrash", "DBM-Party-WoD", 2)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
--mod:SetModelID(47785)
mod:SetZone()

mod.isTrashMod = true

mod:RegisterEvents(
	"SPELL_AURA_APPLIED 164597 151548 151697 151965 151558 151581",
	"SPELL_CAST_START 152298 151447 151545"
)
local warnCinderSplash					= mod:NewSpellAnnounce(152298, 3)

local specWarnCrush						= mod:NewSpecialWarningDodge(151447, "Tank", nil, nil, 1, 2)
local specWarnRoar						= mod:NewSpecialWarningInterrupt(151545, "HasInterrupt", nil, 2, 1, 2)--Maybe healer need warning too, if interrupt gets off, healer can't heal for 5 seconds
local specWarnLavaBurst					= mod:NewSpecialWarningInterrupt(151558, "HasInterrupt", nil, 2, 1, 2)
local specWarnSuppressionField			= mod:NewSpecialWarningInterrupt(151581, "HasInterrupt", nil, 2, 1, 2)--Maybe healer need warning too, if interrupt gets off, healer can't heal for 5 seconds
local specWarnStoneBulwark				= mod:NewSpecialWarningDispel(164597, "MagicDispeller", nil, nil, 1, 2)
local specWarnBloodRage					= mod:NewSpecialWarningDispel(151548, "MagicDispeller", nil, nil, 1, 2)
local specWarnSubjugate					= mod:NewSpecialWarningDispel(151697, "Healer", nil, nil, 1, 2)
local specWarnSlaversRage				= mod:NewSpecialWarningDispel(151965, "RemoveEnrage", nil, nil, 1, 2)

local isTrivial = mod:IsTrivial(110)

function mod:SPELL_AURA_APPLIED(args)
	if not self.Options.Enabled or self:IsDifficulty("normal5") or isTrivial then return end
	local spellId = args.spellId
	if spellId == 164597 and not args:IsDestTypePlayer() then
		specWarnStoneBulwark:Show(args.destName)
		specWarnStoneBulwark:Play("helpdispel")
	elseif spellId == 151548 and not args:IsDestTypePlayer() and self:IsValidWarning(args.sourceGUID) then--Antispam
		specWarnBloodRage:Show(args.destName)
		specWarnBloodRage:Play("helpdispel")
	elseif spellId == 151697 and self:CheckDispelFilter() then
		specWarnSubjugate:Show(args.destName)
		specWarnSubjugate:Play("helpdispel")
	elseif spellId == 151965 then
		specWarnSlaversRage:Show(args.destName)
		specWarnSlaversRage:Play("enrage")
	end
end

function mod:SPELL_CAST_START(args)
	if not self.Options.Enabled or self:IsDifficulty("normal5") or isTrivial then return end
	local spellId = args.spellId
	if spellId == 152298 and self:AntiSpam(5, 1) then
		warnCinderSplash:Show()
	elseif spellId == 151447 then
		specWarnCrush:Show()
		specWarnCrush:Play("shockwave")
	elseif spellId == 151545 and self:IsValidWarning(args.sourceGUID) and self:CheckInterruptFilter(args.sourceGUID, false, true) then--Antispam
		specWarnRoar:Show(args.sourceName)
		specWarnRoar:Play("kickcast")
	elseif spellId == 151558 and self:IsValidWarning(args.sourceGUID) and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnLavaBurst:Show(args.sourceName)
		specWarnLavaBurst:Play("kickcast")
	elseif spellId == 151581 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnSuppressionField:Show(args.sourceName)
		specWarnSuppressionField:Play("kickcast")
	end
end
