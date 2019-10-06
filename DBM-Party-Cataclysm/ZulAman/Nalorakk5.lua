local mod	= DBM:NewMod(187, "DBM-Party-Cataclysm", 10, 77)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(23576)
mod:SetEncounterID(1190)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 42398 42402",
	"CHAT_MSG_MONSTER_YELL"
)
mod.onlyHeroic = true

local warnBear			= mod:NewAnnounce("WarnBear", 4, 39414)
local warnBearSoon		= mod:NewAnnounce("WarnBearSoon", 3, 39414)
local warnNormal		= mod:NewAnnounce("WarnNormal", 4, 39414)
local warnNormalSoon	= mod:NewAnnounce("WarnNormalSoon", 3, 39414)
local warnSilence		= mod:NewSpellAnnounce(42398, 3)
local warnSurge			= mod:NewTargetNoFilterAnnounce(42402)

local timerSurgeCD		= mod:NewNextTimer(8, 42402, nil, nil, nil, 3)
local timerBear			= mod:NewTimer(30, "TimerBear", 39414, nil, nil, 6)
local timerNormal		= mod:NewTimer(30, "TimerNormal", 39414, nil, nil, 6)

local berserkTimer		= mod:NewBerserkTimer(600)

mod:AddBoolOption("InfoFrame")

local surgeDebuff = DBM:GetSpellInfo(42402)

function mod:OnCombatStart(delay)
	timerSurgeCD:Start(-delay)
	timerBear:Start()
	warnBearSoon:Schedule(25)
	berserkTimer:Start(-delay)
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(L.PlayerDebuffs)
		DBM.InfoFrame:Show(5, "playerbaddebuff", surgeDebuff)
	end
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 42398 and self:AntiSpam(4) then
		warnSilence:Show()
	elseif args.spellId == 42402 then
		warnSurge:Show(args.destName)
		timerSurgeCD:Start()
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellBear or msg:find(L.YellBear) then
		timerBear:Cancel()
		timerSurgeCD:Cancel()
		warnBearSoon:Cancel()
		warnBear:Show()
		timerNormal:Start()
		warnNormalSoon:Schedule(25)
	elseif msg == L.YellNormal or msg:find(L.YellNormal) then
		timerNormal:Cancel()
		warnNormalSoon:Cancel()
		warnNormal:Show()
		timerSurgeCD:Start()
		timerBear:Start()
		warnBearSoon:Schedule(40)
	end
end
