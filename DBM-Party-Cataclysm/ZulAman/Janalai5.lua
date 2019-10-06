local mod	= DBM:NewMod(188, "DBM-Party-Cataclysm", 10, 77)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(23578)
mod:SetEncounterID(1191)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 97497",
	"SPELL_CAST_START 43140",
	"CHAT_MSG_MONSTER_YELL"
)
mod.onlyHeroic = true

local warnFlameCast			= mod:NewSpellAnnounce(43140, 2)
local warnAddsSoon			= mod:NewSoonAnnounce(43962, 3)
local warnHatchAll			= mod:NewSpellAnnounce(43144, 4)

local specWarnFlameBreath	= mod:NewSpecialWarningMove(97497, nil, nil, nil, 1, 2)
local specWarnAdds			= mod:NewSpecialWarningSpell(43962, nil, nil, nil, 1, 2)
local specWarnBomb			= mod:NewSpecialWarningDodge(42630, nil, nil, nil, 2)
local specWarnHatchAll		= mod:NewSpecialWarningSpell(43144, "Tank", nil, nil, 1, 2)

local timerBomb				= mod:NewCastTimer(12, 42630, nil, nil, nil, 3)
local timerBombCD			= mod:NewNextTimer(30, 42630, nil, nil, nil, 3)
local timerAdds				= mod:NewNextTimer(65, 43962, nil, nil, nil, 1, nil, DBM_CORE_TANK_ICON..DBM_CORE_DAMAGE_ICON)--I'm not evey sure it's timed or health based but it definitely wasn't 92 seconds in my run it was 65

local berserkTimer			= mod:NewBerserkTimer(600)

function mod:OnCombatStart(delay)
	timerAdds:Start(12-delay)
	timerBombCD:Start(55-delay)--Needs verification of consistency.
	berserkTimer:Start(-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 97497 and args:IsPlayer() and self:AntiSpam() then
		specWarnFlameBreath:Show()
		specWarnFlameBreath:Play("runaway")
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 43140 then
		warnFlameCast:Show()	-- Seems he doesn't target the person :(
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellAdds or msg:find(L.YellAdds) then
		specWarnAdds:Show()
		specWarnAdds:Play("mobsoon")
		warnAddsSoon:Schedule(60)
		timerAdds:Start()
	elseif msg == L.YellBomb or msg:find(L.YellBomb) then
		specWarnBomb:Show()
		specWarnBomb:Play("watchstep")
		timerBomb:Start()
		timerBombCD:Start()
	elseif msg == L.YellHatchAll or msg:find(L.YellHatchAll) then
		warnHatchAll:Show()
		if self.Options.SpecWarn43144spell then
			specWarnHatchAll:Show()
			specWarnHatchAll:Play("mobsoon")
		else
			warnHatchAll:Show()
		end
	end
end