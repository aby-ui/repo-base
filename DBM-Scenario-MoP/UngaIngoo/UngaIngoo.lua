local mod	= DBM:NewMod("d499", "DBM-Scenario-MoP")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 122 $"):sub(12, -3))
mod:SetZone()

mod:RegisterCombat("scenario", 1048)

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"UNIT_SPELLCAST_SUCCEEDED target focus",
	"SCENARIO_UPDATE"
)
mod.onlyNormal = true

--Captain Ook
local warnOrange			= mod:NewTargetAnnounce(121895, 3)

--Captain Ook
local specWarnOrange		= mod:NewSpecialWarningSpell(121895)

--Captain Ook
--local timerOrangeCD		= mod:NewCDTimer(45, 121895)--Not good sample size, could be inaccurate

local timerKegRunner		= mod:NewAchievementTimer(240, 7232)

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 121934 and self:AntiSpam() then
		self:SendSync("Phase3")
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 121895 and self:AntiSpam() then
		self:SendSync("Orange")
	end
end

function mod:OnSync(msg)
	if msg == "Phase3" then
		timerKegRunner:Cancel()
--		timerOrangeCD:Start()
	elseif msg == "Orange" then
		warnOrange:Show()
		specWarnOrange:Show()
	end
end

function mod:SCENARIO_UPDATE(newStep)
	local _, currentStage = C_Scenario.GetInfo()
	if currentStage == 2 then
		timerKegRunner:Start()
	end
end
