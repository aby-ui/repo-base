local mod	= DBM:NewMod("Anub'Rekhan", "DBM-Naxx", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190516165414")
mod:SetCreatureID(15956)
mod:SetEncounterID(1107)
mod:SetModelID(15931)
mod:RegisterCombat("combat_yell", L.Pull1, L.Pull2)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 28785 54021",
	"SPELL_AURA_REMOVED 28785 54021",
	"UNIT_DIED"
)

local warningLocustSoon		= mod:NewSoonAnnounce(28785, 2)
local warningLocustFaded	= mod:NewFadesAnnounce(28785, 1)

local specialWarningLocust	= mod:NewSpecialWarningSpell(28785, nil, nil, nil, 2, 2)

local timerLocustIn			= mod:NewCDTimer(80, 28785, nil, nil, nil, 6)
local timerLocustFade 		= mod:NewBuffActiveTimer(26, 28785, nil, nil, nil, 6)

mod:AddBoolOption("ArachnophobiaTimer", true, "timer")


function mod:OnCombatStart(delay)
	if self:IsDifficulty("normal25") then
		timerLocustIn:Start(90 - delay)
		warningLocustSoon:Schedule(80 - delay)
	else
		timerLocustIn:Start(91 - delay)
		warningLocustSoon:Schedule(76 - delay)
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(28785, 54021) then  -- Locust Swarm
		specialWarningLocust:Show()
		specialWarningLocust:Play("aesoon")
		timerLocustIn:Stop()
		if self:IsDifficulty("normal25") then
			timerLocustFade:Start(23)
		else
			timerLocustFade:Start(19)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(28785, 54021)
	and args.auraType == "BUFF" then
		warningLocustFaded:Show()
		timerLocustIn:Start()
		warningLocustSoon:Schedule(62)
	end
end

function mod:UNIT_DIED(args)
	if self.Options.ArachnophobiaTimer and not DBM.Bars:GetBar(L.ArachnophobiaTimer) then
		local cid = self:GetCIDFromGUID(args.destGUID)
		if cid == 15956 then		-- Anub'Rekhan
			DBM.Bars:CreateBar(1200, L.ArachnophobiaTimer)
			warningLocustSoon:Cancel()
			timerLocustFade:Cancel()
			timerLocustIn:Cancel()
		end
	end
end
