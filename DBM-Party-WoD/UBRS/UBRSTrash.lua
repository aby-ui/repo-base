local mod	= DBM:NewMod("UBRSTrash", "DBM-Party-WoD", 8)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
--mod:SetModelID(47785)
mod:SetZone()

mod.isTrashMod = true

mod:RegisterEvents(
	"SPELL_AURA_APPLIED 155586 155498",
	"SPELL_CAST_START 155505 169088 169151 155572 155586 155588 154039 155037",
	"UNIT_DIED",
	"UNIT_SPELLCAST_SUCCEEDED"
)

local warnDebilitatingRay				= mod:NewCastAnnounce(155505, 4)
local warnEarthPounder					= mod:NewSpellAnnounce(154749, 4, nil, "Melee")

local specWarnRejuvSerumDispel			= mod:NewSpecialWarningDispel(155498, "MagicDispeller", nil, 2, 1, 2)
local specWarnDebilitatingRay			= mod:NewSpecialWarningInterrupt(155505, "HasInterrupt", nil, 2, 1, 2)
local specWarnSummonBlackIronDread		= mod:NewSpecialWarningInterrupt(169088, "HasInterrupt", nil, 2, 1, 2)
local specWarnSummonBlackIronVet		= mod:NewSpecialWarningInterrupt(169151, "HasInterrupt", nil, 2, 1, 2)
local specWarnVeilofShadow				= mod:NewSpecialWarningInterrupt(155586, "HasInterrupt", nil, 2, 1, 2)--Challenge mode only(little spammy for mage)
local specWarnVeilofShadowDispel		= mod:NewSpecialWarningDispel(155586, "RemoveCurse", nil, 2, 1, 2)
local specWarnShadowBoltVolley			= mod:NewSpecialWarningInterrupt(155588, "HasInterrupt", nil, 2, 1, 2)
local specWarnSmash						= mod:NewSpecialWarningDodge(155572, "Tank", nil, nil, 1, 2)
local specWarnFranticMauling			= mod:NewSpecialWarningDodge(154039, "Tank", nil, nil, 1, 2)
local specWarnEruption					= mod:NewSpecialWarningDodge(155037, "Tank", nil, nil, 1, 2)

local timerSmashCD						= mod:NewCDTimer(13, 155572, nil, nil, nil, 3)
local timerEruptionCD					= mod:NewCDTimer(10, 155037, nil, false, nil, 3)--10-15 sec variation. May be distracting or spammy since two of them

local isTrivial = mod:IsTrivial(110)

function mod:SPELL_AURA_APPLIED(args)
	if not self.Options.Enabled or self:IsDifficulty("normal5") or isTrivial then return end
	local spellId = args.spellId
	if spellId == 155586 and self:CheckDispelFilter() then
		specWarnVeilofShadowDispel:Show(args.destName)
		specWarnVeilofShadowDispel:Play("helpdispel")
	elseif spellId == 155498 and not args:IsDestTypePlayer() then
		specWarnRejuvSerumDispel:Show(args.destName)
		specWarnRejuvSerumDispel:Play("dispelboss")
	end
end

function mod:SPELL_CAST_START(args)
	if not self.Options.Enabled or self:IsDifficulty("normal5") or isTrivial then return end
	local spellId = args.spellId
	if spellId == 155505 then
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then 
			specWarnDebilitatingRay:Show(args.sourceName)
			specWarnDebilitatingRay:Play("kickcast")
		else
			warnDebilitatingRay:Show()
		end
	elseif spellId == 169088 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnSummonBlackIronDread:Show(args.sourceName)
		specWarnSummonBlackIronDread:Play("kickcast")
	elseif spellId == 169151 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnSummonBlackIronVet:Show(args.sourceName)
		specWarnSummonBlackIronVet:Play("kickcast")
	elseif spellId == 155586 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnVeilofShadow:Show(args.sourceName)
		specWarnVeilofShadow:Play("kickcast")
	elseif spellId == 155588 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnShadowBoltVolley:Show(args.sourceName)
		specWarnShadowBoltVolley:Play("kickcast")
	elseif spellId == 155572 then
		if self:AntiSpam(2, 1) then
			specWarnSmash:Show()
			specWarnSmash:Play("shockwave")
		end
		timerSmashCD:Start(nil, args.sourceGUID)
	elseif spellId == 154039 and self:AntiSpam(2, 2) then
		specWarnFranticMauling:Show()
		specWarnFranticMauling:Play("shockwave")
	elseif spellId == 155037 then
		specWarnEruption:Show()
		specWarnEruption:Play("shockwave")
		timerEruptionCD:Start(nil, args.sourceGUID)
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 77033 then
		timerSmashCD:Cancel(args.destGUID)
	elseif cid == 82556 then
		timerEruptionCD:Cancel(args.destGUID)
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 154749 and self:AntiSpam(2, 3) then
		warnEarthPounder:Show()
	end
end
