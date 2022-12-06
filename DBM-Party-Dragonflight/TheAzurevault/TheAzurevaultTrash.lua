local mod	= DBM:NewMod("TheAzurevaultTrash", "DBM-Party-Dragonflight", 6)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221205064214")
--mod:SetModelID(47785)
mod.isTrashMod = true

mod:RegisterEvents(
	"SPELL_CAST_START 391136 370764 386526 387564 377105 370766",
	"SPELL_CAST_SUCCESS 374885 371358",
	"SPELL_AURA_APPLIED 371007 395492 375596"
--	"SPELL_AURA_APPLIED_DOSE 339528",
--	"SPELL_AURA_REMOVED 339525"
)

--TODO, I don't think shoulder slam target scan worked, maybe try again though.
local warnNullStomp							= mod:NewCastAnnounce(386526, 2)
local warnShoulderSlam						= mod:NewCastAnnounce(391136, 2)
local warnPiercingShards					= mod:NewCastAnnounce(370764, 4)
local warnIceCutter							= mod:NewCastAnnounce(377105, 4, nil, nil, "Tank|Healer")
local warnSplinteringShards					= mod:NewTargetAnnounce(371007, 2)
local warScornfulHaste						= mod:NewTargetNoFilterAnnounce(395492, 2)
local warnErraticGrowth						= mod:NewTargetNoFilterAnnounce(375596, 2)

local specWarnUnstablePower					= mod:NewSpecialWarningDodge(374885, nil, nil, nil, 2, 2)
local specWarnForbiddenKnowledge			= mod:NewSpecialWarningDodge(371358, nil, nil, nil, 2, 2)
local specWarnNullStomp						= mod:NewSpecialWarningDodge(386526, false, nil, 2, 2, 2)
local specWarnCrystallineRupture			= mod:NewSpecialWarningDodge(370766, nil, nil, nil, 2, 2)
--local specWarnShoulderSlam					= mod:NewSpecialWarningMoveAway(391136, nil, nil, nil, 1, 2)
--local yellShoulderSlam						= mod:NewYell(391136)
local specWarnSplinteringShards				= mod:NewSpecialWarningMoveAway(371007, nil, nil, nil, 1, 2)
local yellSplinteringShards					= mod:NewYell(371007)
local yellErraticGrowth						= mod:NewYell(375596)
local specWarnMysticVapors					= mod:NewSpecialWarningInterrupt(387564, "HasInterrupt", nil, nil, 1, 2)
local specWarnWakingBane					= mod:NewSpecialWarningInterrupt(386546, "HasInterrupt", nil, nil, 1, 2)

--local playerName = UnitName("player")

--Antispam IDs for this mod: 1 run away, 2 dodge, 3 dispel, 4 incoming damage, 5 you/role, 6 misc

--[[
function mod:ShoulderSlamTarget(targetname)
	if not targetname then return end
	if targetname == UnitName("player") then
		if self:AntiSpam(4, 5) then
			specWarnShoulderSlam:Show()
			specWarnShoulderSlam:Play("runout")
		end
		yellShoulderSlam:Yell()
	end
end
--]]

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 391136 then
		warnShoulderSlam:Show()
--		self:ScheduleMethod(0.1, "BossTargetScanner", args.sourceGUID, "ShoulderSlamTarget", 0.1, 8)
	elseif spellId == 370764 and self:AntiSpam(5, 6) then
		warnPiercingShards:Show()
	elseif spellId == 377105 and self:AntiSpam(3, 6) then
		warnIceCutter:Show()
	elseif spellId == 386526 and self:AntiSpam(3, 2) then
		if self.Options.SpecWarn386526dodge then
			specWarnNullStomp:Show()
			specWarnNullStomp:Play("watchstep")
		else
			warnNullStomp:Show()
		end
	elseif spellId == 370766 and self:AntiSpam(3, 2) then
		specWarnCrystallineRupture:Show()
		specWarnCrystallineRupture:Play("watchstep")
	elseif spellId == 387564 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnMysticVapors:Show(args.sourceName)
		specWarnMysticVapors:Play("kickcast")
	elseif spellId == 386546 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnWakingBane:Show(args.sourceName)
		specWarnWakingBane:Play("kickcast")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 374885 and self:AntiSpam(3, 2) then
		specWarnUnstablePower:Show()
		specWarnUnstablePower:Play("watchstep")
	elseif spellId == 371358 and self:AntiSpam(3, 2) then
		specWarnForbiddenKnowledge:Show()
		specWarnForbiddenKnowledge:Play("watchstep")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if not self.Options.Enabled then return end
	local spellId = args.spellId
	if spellId == 371007 then
		warnSplinteringShards:CombinedShow(0.5, args.destName)
		if args:IsPlayer() then
			specWarnSplinteringShards:Show()
			specWarnSplinteringShards:Play("runout")
			yellSplinteringShards:Yell()
		end
	elseif spellId == 395492 then
		warScornfulHaste:CombinedShow(0.3, args.destName)
	elseif spellId == 375596 then
		warnErraticGrowth:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			yellErraticGrowth:Yell()
		end
	end
end
--mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

--[[
function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 339525 and args:IsPlayer() then

	end
end
--]]
