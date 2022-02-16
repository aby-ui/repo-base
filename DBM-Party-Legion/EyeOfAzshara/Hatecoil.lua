local mod	= DBM:NewMod(1490, "DBM-Party-Legion", 3, 716)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220116042005")
mod:SetCreatureID(91789)
mod:SetEncounterID(1811)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 193698",
	"SPELL_CAST_START 193682 193597"
)

--TODO, maybe add a "get back in boss area warning" if you take Crackling Thunder damage
--TODO, more curse notes perhaps? Add special warning for player maybe?
--[[
1. Healer--193712+18
2. 3 dps--193716+24.5
3. healer--193712+16.5
4. Everyone--193717+30
5. 1 healer, 1 tank, 1 dps--193716+17
6. Everyone--193717+19
--]]
local warnCurseofWitch				= mod:NewTargetNoFilterAnnounce(193698, 3)

local specWarnStaticNova			= mod:NewSpecialWarning("specWarnStaticNova", nil, DBM_CORE_L.AUTO_SPEC_WARN_OPTIONS.dodge:format(193597), nil, 3, 2)
local specWarnFocusedLightning		= mod:NewSpecialWarning("specWarnFocusedLightning", nil, DBM_CORE_L.AUTO_SPEC_WARN_OPTIONS.soon:format(193611), nil, 1)
local specWarnAdds					= mod:NewSpecialWarningSwitch(193682, "Tank", nil, nil, 1, 2)
local yellCurseofWitch				= mod:NewShortFadesYell(193698)

local timerAddsCD					= mod:NewCDTimer(47, 193682, nil, nil, nil, 1)--47-51
local timerStaticNovaCD				= mod:NewCDTimer(34, 193597, nil, nil, nil, 2, nil, DBM_COMMON_L.DEADLY_ICON, nil, 1, 4)
local timerFocusedLightningCD		= mod:NewNextTimer(15.5, 193611, nil, nil, nil, 3)

function mod:OnCombatStart(delay)
	timerStaticNovaCD:Start(10.5-delay)
	timerAddsCD:Start(19-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 193698 then
		warnCurseofWitch:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			yellCurseofWitch:Countdown(spellId)
		end
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 193682 then
		specWarnAdds:Show()
		specWarnAdds:Play("mobsoon")
		timerAddsCD:Start()
	elseif spellId == 193597 then
		specWarnStaticNova:Show()
		specWarnStaticNova:Play("findshelter")
		timerFocusedLightningCD:Start()
		specWarnFocusedLightning:Schedule(10)--5 seconds before focused lightning cast
	end
end
