local mod	= DBM:NewMod("GunshipBattle", "DBM-Icecrown", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417005949")
local addsIcon
local bossID
--mod:SetEncounterID(1099)--No ES fires this combat
mod:RegisterCombat("combat")
mod:SetCreatureID(37215, 37540) -- Orgrim's Hammer, The Skybreaker
mod:SetMinSyncRevision(119)
if UnitFactionGroup("player") == "Alliance" then
	mod:SetMainBossID(37215)
	mod:SetModelID(30416)		-- High Overlord Saurfang
	addsIcon = 23334
	bossID = 36939
else
	mod:SetMainBossID(37540)
	mod:SetModelID(30508)		-- Muradin Bronzebeard
	addsIcon = 23336
	bossID = 36948
end

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 71195 71193 71188 69652 69651 69638",
	"SPELL_AURA_APPLIED_DOSE 69638",
	"SPELL_AURA_REMOVED 69705",
	"SPELL_CAST_START 69705",
	"UNIT_SPELLCAST_SUCCEEDED boss1 boss2"
)

mod:RegisterEvents(
	"CHAT_MSG_MONSTER_YELL"
)

--TODO, see if IEEU fires here and if we need yell triggers for engage
local warnBelowZero			= mod:NewSpellAnnounce(69705, 4)
local warnExperienced		= mod:NewTargetAnnounce(71188, 1, nil, false)		-- might be spammy
local warnVeteran			= mod:NewTargetAnnounce(71193, 2, nil, false)		-- might be spammy
local warnElite				= mod:NewTargetAnnounce(71195, 3, nil, false)		-- might be spammy
local warnBattleFury		= mod:NewStackAnnounce(69638, 2, nil, "Tank|Healer", 2)
local warnBladestorm		= mod:NewSpellAnnounce(69652, 3, nil, "Melee")
local warnWoundingStrike	= mod:NewTargetAnnounce(69651, 2)
local warnAddsSoon			= mod:NewAnnounce("WarnAddsSoon", 2, addsIcon)

local timerCombatStart		= mod:NewCombatTimer(42)
local timerBelowZeroCD		= mod:NewNextTimer(33.5, 69705, nil, nil, nil, 5)
local timerBattleFuryActive	= mod:NewBuffFadesTimer(17, 69638, nil, "Tank|Healer", nil, 5, nil, DBM_CORE_TANK_ICON)
local timerAdds				= mod:NewTimer(60, "TimerAdds", addsIcon, nil, nil, 1)

mod.vb.firstMage = false

local function Adds(self)
	timerAdds:Stop()
	timerAdds:Start()
	warnAddsSoon:Cancel()
	warnAddsSoon:Schedule(55)
	self:Unschedule(Adds)
	self:Schedule(60, Adds, self)
end

function mod:OnCombatStart(delay)
	timerAdds:Start(15-delay)--First adds might come early or late so timer should be taken as a proximity only.
	warnAddsSoon:Schedule(10)
	self:Schedule(15, Adds, self)
	self.vb.firstMage = false
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 71195 then
		warnElite:Show(args.destName)
	elseif args.spellId == 71193 then
		warnVeteran:Show(args.destName)
	elseif args.spellId == 71188 then
		warnExperienced:Show(args.destName)
	elseif args.spellId == 69652 then
		warnBladestorm:Show()
	elseif args.spellId == 69651 then
		warnWoundingStrike:Show(args.destName)
	elseif args.spellId == 69638 and self:GetCIDFromGUID(args.destGUID) == bossID then
		timerBattleFuryActive:Start()		-- only a timer for 1st stack
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args.spellId == 69638 and self:GetCIDFromGUID(args.destGUID) == bossID then
		if args.amount % 5 == 0 then		-- warn every 5 stacks
			warnBattleFury:Show(args.destName, args.amount or 1)
		end
		timerBattleFuryActive:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 69705 then
		timerBelowZeroCD:Start()
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 69705 then
		warnBelowZero:Show()
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 72340 then
		DBM:EndCombat(self)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:find(L.PullAlliance) or msg:find(L.PullHorde) then
		timerCombatStart:Start()
	elseif (msg:find(L.AddsAlliance) or msg:find(L.AddsHorde)) and self:IsInCombat() then
		self:Unschedule(Adds)
		Adds(self)
	elseif (msg:find(L.MageAlliance) or msg:find(L.MageHorde)) and self:IsInCombat() then
		if not self.vb.firstMage then
			timerBelowZeroCD:Start(3.2)
			self.vb.firstMage = true
		else
			timerBelowZeroCD:Update(30.3, 33.5)--Update the below zero timer to correct it with yells since it tends to be off depending on how bad your cannon operators are.
		end
	end
end
