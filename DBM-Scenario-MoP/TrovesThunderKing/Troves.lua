local mod	= DBM:NewMod("d620", "DBM-Scenario-MoP")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 122 $"):sub(12, -3))
mod:SetZone()

mod:RegisterCombat("scenario", 1135)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED",
	"UNIT_AURA player"
)
mod.onlyNormal = true

local warnStoneSmash		= mod:NewCastAnnounce(139777, 3, nil, nil, false)

local specWarnMightycrash	= mod:NewSpecialWarningMove(136844)
local specWarnSaurok		= mod:NewSpecialWarningSpell(140009)

local timerEvent			= mod:NewBuffFadesTimer(299, 140000, nil, nil, nil, 6)
local timerStoneSmash		= mod:NewCastTimer(3, 139777, nil, false)

local countdownEvent		= mod:NewCountdownFades(299, 140000, nil, nil, 10)

local timerStarted = false
local timerDebuff = DBM:GetSpellInfo(140000)

local function endCombatDelay()
	DBM:EndCombat(mod)
	timerStarted = false
end

function mod:OnCombatEnd()
	self:UnregisterShortTermEvents()
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 139777 then
		warnStoneSmash:Show()
		timerStoneSmash:Start(3, args.sourceGUID)
	elseif args.spellId == 136844 then
		specWarnMightycrash:Show()
	end
end

--"<165.2 19:33:11> [UNIT_SPELLCAST_SUCCEEDED] Unknown [[target:Suddenly, a Treasure Saurok!::0:140009]]", -- [191]
--"<165.2 19:33:11> [CLEU] SPELL_AURA_APPLIED#false#0xF131130E0003BB9B#Unknown#68168#0#0xF131130E0003BB9B#Unknown#68168#0#139812#Take the Loot and Run!#1#BUFF", -- [192]
function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 139812 then
		specWarnSaurok:Show()
	end
end

function mod:LOADING_SCREEN_DISABLED()
	self:Schedule(2, endCombatDelay)--Then, wait even longer to ensure even slow computers have completed LOADING_SCREEN_DISABLED stuff in core.
end

do
	--Apparently this doesn't fire in combat log, have to use UNIT_AURA instead.
	function mod:UNIT_AURA(uId)
		if DBM:UnitDebuff("player", timerDebuff) and not timerStarted then
			timerStarted = true
			timerEvent:Start()
			countdownEvent:Start()
		elseif not DBM:UnitDebuff("player", timerDebuff) and timerStarted then
			timerStarted = false
			timerEvent:Cancel()
			countdownEvent:Cancel()
			self:RegisterShortTermEvents(--First need to wait until after loading screen disabled fires before we end combat, to prevent auto recombat.
				"LOADING_SCREEN_DISABLED"
			)
		end
	end
end
