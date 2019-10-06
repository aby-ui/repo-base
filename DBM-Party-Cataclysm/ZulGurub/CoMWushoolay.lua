local mod	= DBM:NewMod(180, "DBM-Party-Cataclysm", 11, 76, 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(52286)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 96697 96698",
	"SPELL_AURA_APPLIED 96710"
)
mod.onlyHeroic = true

local warnRush			= mod:NewTargetNoFilterAnnounce(96697, 3)
local warnRod			= mod:NewCastAnnounce(96698, 4)

local specWarnRush		= mod:NewSpecialWarningYou(96697, nil, nil, nil, 1, 2)--Assumed target scanning even works here, if it doesn't mod will be broken.
local specWarnRushNear	= mod:NewSpecialWarningClose(96697, nil, nil, nil, 1, 2)--Assumed target scanning even works here, if it doesn't mod will be broken.
local specWarnCloud		= mod:NewSpecialWarningMove(96710, nil, nil, nil, 1, 8)

local timerRushCD		= mod:NewNextTimer(25, 96697, nil, nil, nil, 3)

function mod:OnCombatStart(delay)
	timerRushCD:Start(15.5-delay)--Consistent?
end

function mod:LightingRushTarget()
	local targetname = self:GetBossTarget(52286)
	if not targetname then return end
	if targetname == UnitName("player") then
		specWarnRush:Show()
		specWarnRush:Play("targetyou")
	else
		local uId = DBM:GetRaidUnitId(targetname)
		if uId then
			local inRange = DBM.RangeCheck:GetDistance("player", uId)
			if inRange and inRange < 14 then
				specWarnRushNear:Show(targetname)
				specWarnRushNear:Play("runaway")
			else
				warnRush:Show(targetname)
			end
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 96697 then
		self:ScheduleMethod(0.2, "LightingRushTarget")
		timerRushCD:Start()
	elseif args.spellId == 96698 then
		warnRod:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 96710 and args:IsPlayer() then
		specWarnCloud:Show()
		specWarnCloud:Play("watchfeet")
	end
end