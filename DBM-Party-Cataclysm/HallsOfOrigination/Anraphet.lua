local mod	= DBM:NewMod(126, "DBM-Party-Cataclysm", 4, 70)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(39788)
mod:SetEncounterID(1075)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"CHAT_MSG_MONSTER_SAY"
)

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 75603 77336 77235 76956",
	"SPELL_AURA_REMOVED 75603",
	"SPELL_CAST_START 76184 75622 77241"
)

local warnAlphaBeams		= mod:NewSpellAnnounce(76184, 4)
local warnOmegaStance		= mod:NewSpellAnnounce(75622, 4)
local warnNemesis			= mod:NewTargetNoFilterAnnounce(75603, 3, nil, "Healer", 2)
local warnBubble			= mod:NewTargetNoFilterAnnounce(77336, 3)
local warnImpale			= mod:NewTargetNoFilterAnnounce(77235, 3)
local warnInferno			= mod:NewSpellAnnounce(77241, 3)

local specWarnAlphaBeams	= mod:NewSpecialWarningMove(76956, nil, nil, nil, 1, 8)

local timerAlphaBeams		= mod:NewBuffActiveTimer(16, 76184, nil, nil, nil, 6)
local timerAlphaBeamsCD		= mod:NewCDTimer(47, 76184, nil, nil, nil, 3)
local timerOmegaStance		= mod:NewBuffActiveTimer(8, 75622, nil, nil, nil, 6)
local timerOmegaStanceCD	= mod:NewCDTimer(47, 75622, nil, nil, nil, 6)
local timerNemesis			= mod:NewTargetTimer(5, 75603, nil, "Healer", 2, 5, nil, DBM_CORE_HEALER_ICON..DBM_CORE_MAGIC_ICON)
local timerBubble			= mod:NewCDTimer(15, 77336, nil, nil, nil, 3, nil, DBM_CORE_DAMAGE_ICON)
local timerImpale			= mod:NewTargetTimer(3, 77235, nil, nil, nil, 3)
local timerImpaleCD			= mod:NewCDTimer(20, 77235, nil, nil, nil, 3)
local timerInferno			= mod:NewCDTimer(17, 77241, nil, nil, nil, 2)

local timerGauntlet			= mod:NewAchievementTimer(300, 5296, "achievementGauntlet")

function mod:OnCombatStart(delay)
	timerAlphaBeamsCD:Start(10-delay)
	timerOmegaStanceCD:Start(35-delay)
	timerGauntlet:Cancel()--it actually cancels a few seconds before engage but this doesn't require localisation and extra yell checks.
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 75603 then
		warnNemesis:Show(args.destName)
		timerNemesis:Start(args.destName)
	elseif args.spellId == 77336 then
		warnBubble:Show(args.destName)
		timerBubble:Show()
	elseif args.spellId == 77235 then
		warnImpale:Show(args.destName)
		timerImpale:Start(args.destName)
		timerImpaleCD:Start()
	elseif args.spellId == 76956 and args:IsPlayer() then
		specWarnAlphaBeams:Show()
		specWarnAlphaBeams:Play("watchfeet")
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 75603 then
		timerNemesis:Cancel(args.destName)
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 76184 then
		warnAlphaBeams:Show()
		timerAlphaBeams:Start()
		timerAlphaBeamsCD:Start()
	elseif args.spellId == 75622 then
		warnOmegaStance:Show()
		timerOmegaStance:Start()
		timerOmegaStanceCD:Start()
	elseif args.spellId == 77241 then
		warnInferno:Show()
		timerInferno:Start()
	end
end

function mod:CHAT_MSG_MONSTER_SAY(msg)
	if msg == L.Brann or msg:find(L.Brann) then
		self:SendSync("HoOGauntlet")
	end
end

function mod:OnSync(msg)
	if msg == "HoOGauntlet" then
		if not self:IsDifficulty("normal5") then
			timerGauntlet:Start()
		end
	end
end