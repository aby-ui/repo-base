local mod	= DBM:NewMod("ArtifactHealer", "DBM-Challenges", 2)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 105 $"):sub(12, -3))
mod:SetZone()--Healer (1710), Tank (1698), DPS (1703-The God-Queen's Fury), DPS (Fel Totem Fall)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED 235984 237188",
	"SPELL_AURA_APPLIED_DOSE 235833",
	"UNIT_DIED"
)
mod.noStatistics = true
--Notes:
--TODO, all. mapids, mob iDs, win event to stop timers (currently only death event stops them)
--Healer
-- Need ignite soul equiv name/ID.
-- Need fear name/Id

local warnArcaneBlitz			= mod:NewStackAnnounce(235833, 2)

local specWarnManaSling			= mod:NewSpecialWarningMoveTo(235984, nil, nil, nil, 1, 2)
local specWarnArcaneBlitz		= mod:NewSpecialWarningStack(235833, nil, 4, nil, nil, 1, 6)--Fine tune the numbers
local specWarnIgniteSoul		= mod:NewSpecialWarningYou(237188, nil, nil, nil, 3, 2)

--local timerEarthquakeCD		= mod:NewNextTimer(60, 237950, nil, nil, nil, 2)
local timerIgniteSoulCD			= mod:NewAITimer(18, 237188, nil, nil, nil, 3, nil, DBM_CORE_DEADLY_ICON)

local countdownIngiteSoul		= mod:NewCountdownFades("AltTwo9", 237188)

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 235833 then
		local amount = args.amount or 1
		if amount % 2 == 0 then
			if amount >= 4 then
				specWarnArcaneBlitz:Show(amount)
				specWarnArcaneBlitz:Play("stackhigh")
			else
				warnArcaneBlitz:Show(args.destName, amount)
			end
		end
	elseif spellId == 235984 and args:IsPlayer() then
		specWarnManaSling:Show(DBM_ALLY)
		specWarnManaSling:Play("findshelter")
	elseif spellId == 237188 then
		countdownIngiteSoul:Start()
		specWarnIgniteSoul:Show()
		specWarnIgniteSoul:Play("targetyou")
		timerIgniteSoulCD:Start()
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:UNIT_DIED(args)
	if args.destGUID == UnitGUID("player") then--Solo scenario, a player death is a wipe
		timerIgniteSoulCD:Stop()
	end
end
