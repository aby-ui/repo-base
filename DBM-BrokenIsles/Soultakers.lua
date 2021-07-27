local mod	= DBM:NewMod(1756, "DBM-BrokenIsles", 1, 822)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20210721041434")
mod:SetCreatureID(106981, 106982, 106984)--Captain Hring, Reaver Jdorn, Soultrapper Mevra
mod:SetEncounterID(1879)
mod:SetReCombatTime(20)
mod:EnableWBEngageSync()--Enable syncing engage in outdoors

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 213420 213522 213532 213665 213625 213606",
	"SPELL_AURA_APPLIED 213584 213625",
	"SPELL_AURA_REMOVED 213625",
	"UNIT_DIED"
)

--TODO, review warnings and promote/demote as needed. Especially MaraudingMists
--TODO, do these get boss unit IDs? if so fix UNIT_SPELLCAST_INTERRUPTED
--TODO, see how scuttle works exactly and get some hud charge lines in there.
--Captain Hring
local warnTentacleBash				= mod:NewCastAnnounce(213420, 2)
local warnShatterCrew				= mod:NewCastAnnounce(213532, 3)
--Reaver Jdorn
local warnMaraudingMists			= mod:NewCastAnnounce(213665, 3)
--Soultrapper Mevra

--Captain Hring
local specWarnCursedCrew			= mod:NewSpecialWarningSwitch(213522, "-Healer", nil, nil, 1, 2)
--Reaver Jdorn
local specWarnScuttle				= mod:NewSpecialWarningYou(213584, nil, nil, nil, 1, 2)
local specWarnExpelSoul				= mod:NewSpecialWarningMoveAway(213625, 1, nil, nil, 1, 2)
local specWarnMaraudingMists		= mod:NewSpecialWarningRun(213665, "Melee", nil, nil, 4, 2)
--Soultrapper Mevra
local specWarnSoulRend				= mod:NewSpecialWarningDodge(213606, nil, nil, nil, 2, 2)

--Captain Hring
local timerTentacleBashCD			= mod:NewCDTimer(15.9, 213420, nil, nil, nil, 3)--15.9-31.8
--local timerCursedCrewCD				= mod:NewAITimer(51, 213522, nil, nil, nil, 1)
--local timerShatterCrew			= mod:NewCastTimer(8, 213532, nil, nil, nil, 2)
--Reaver Jdorn
local timerMaraudingMistsCD			= mod:NewCDTimer(10.8, 213665, nil, nil, nil, 2)--10-25
--Soultrapper Mevra
local timerExpelSoulCD				= mod:NewCDTimer(8.5, 213625, nil, nil, 2, 3)
--local timerSoulRendCD				= mod:NewAITimer(51, 213606, nil, nil, nil, 3)

--mod:AddReadyCheckOption(37462, false)--Unknown quest flag
mod:AddRangeFrameOption(8, 213665)

function mod:OnCombatStart(delay, yellTriggered)
	if yellTriggered then

	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 213420 then
		warnTentacleBash:Show()
		timerTentacleBashCD:Start()
	elseif spellId == 213522 then
		specWarnCursedCrew:Show()
		specWarnCursedCrew:Play("killmob")
--		timerCursedCrewCD:Start()
	elseif spellId == 213532 then
		warnShatterCrew:Show()
--		timerShatterCrew:Start()
	elseif spellId == 213665 and self:CheckInterruptFilter(args.sourceGUID, true) then
		specWarnMaraudingMists:Show()
		specWarnMaraudingMists:Play("runout")
	elseif spellId == 213625 then
		timerExpelSoulCD:Start()
	elseif spellId == 213606 then
		specWarnSoulRend:Show()
		specWarnSoulRend:Play("watchstep")
--		timerSoulRendCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 213584 then
		if args:IsPlayer() then
			specWarnScuttle:Show()
		end
	elseif spellId == 213625 and args:IsPlayer() then
		specWarnExpelSoul:Show()
		specWarnExpelSoul:Play("runout")
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(8)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 213625 and args:IsPlayer() and self.Options.RangeFrame  then
		DBM.RangeCheck:Hide()
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 106981 then--Captain Hring
		timerTentacleBashCD:Stop()
--		timerCursedCrewCD:Stop()
--		timerShatterCrew:Stop()
	elseif cid == 106982 then--Reaver Jdorn
		timerMaraudingMistsCD:Stop()
	elseif cid == 106984 then--Soultrapper Mevra
		timerExpelSoulCD:Stop()
--		timerSoulRendCD:Stop()
	end
end
