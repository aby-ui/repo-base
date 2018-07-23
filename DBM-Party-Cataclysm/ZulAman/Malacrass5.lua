local mod	= DBM:NewMod(190, "DBM-Party-Cataclysm", 10, 77)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 174 $"):sub(12, -3))
mod:SetCreatureID(24239)
mod:SetEncounterID(1193)
mod:SetZone()

mod:RegisterCombat("combat")
mod:SetMinCombatTime(30)	-- Prevent pre-maturely combat-end in cases where none targets the boss?

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_PERIODIC_DAMAGE",
	"SPELL_PERIODIC_MISSED"
)
mod.onlyHeroic = true

local warnSiphon			= mod:NewTargetAnnounce(43501, 3)
local warnSpiritBolts		= mod:NewSpellAnnounce(43383, 3)
local warnSpiritBoltsSoon	= mod:NewSoonAnnounce(43383, 5, 2)
local warnFireNovaTotem		= mod:NewSpellAnnounce(43436, 3)
local warnHolyLight			= mod:NewCastAnnounce(43451, 4)
local warnFlashHeal			= mod:NewCastAnnounce(43431, 4)
local warnHealingWave		= mod:NewCastAnnounce(43548, 4)
local warnLifebloom			= mod:NewTargetAnnounce(43421, 4)

local specWarnFireNovaTotem	= mod:NewSpecialWarningSpell(43436, false)
local specWarnHolyLight		= mod:NewSpecialWarningInterrupt(43451)
local specWarnFlashHeal		= mod:NewSpecialWarningInterrupt(43431)
local specWarnHealingWave	= mod:NewSpecialWarningInterrupt(43548)
local specWarnLifebloom		= mod:NewSpecialWarningDispel(43421, "MagicDispeller")
local specWarnConsecration	= mod:NewSpecialWarningMove(43429)
local specWarnRainofFire	= mod:NewSpecialWarningMove(43440)
local specWarnDeathNDecay	= mod:NewSpecialWarningMove(61603)

local timerSiphon			= mod:NewTimer(30, "TimerSiphon", 43501)
local timerSpiritBolts		= mod:NewBuffActiveTimer(5, 43383)
local timerSpiritBoltsNext	= mod:NewNextTimer(36, 43383)

local function getClass(name)
	local class
	if UnitName("player") == name then
		class = select(2, UnitClass("player"))
	else
		local nameString = "%s-%s"	-- "PlayerName-RealmName"
		for uId, i in DBM:GetGroupMembers() do
			local n, r = UnitName(uId)	-- PlayerName, RealmName
			if n == name or (n and r and nameString:format(n,r) == name) then
				class = select(2, UnitClass("party"..i))
				break
			end
		end
	end
	if class then
		class = class:sub(0, 1):upper()..class:sub(2):lower()
	end
	return class or "unknown"
end

function mod:OnCombatStart(delay)
	timerSpiritBoltsNext:Start(15-delay)
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 43451 then					--Paladin Heal (Holy Light)
		warnHolyLight:Show()
		specWarnHolyLight:Show(args.sourceName)
	elseif args.spellId == 43431 then				--Priest Heal (Flash Heal)
		warnFlashHeal:Show()
		specWarnFlashHeal:Show(args.sourceName)
	elseif args.spellId == 43548 then				--Shaman Heal (Healing Wave)
		warnHealingWave:Show()
		specWarnHealingWave:Show(args.sourceName)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 43436 then					--Shaman (Fire Nova Totem)
		warnFireNovaTotem:Show()
		specWarnFireNovaTotem:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 43501 then
		local class = getClass(args.destName)
		warnSiphon:Show(args.destName)
		timerSiphon:Start(args.spellName, class)
	elseif args.spellId == 43383 then
		warnSpiritBolts:Show()
		warnSpiritBoltsSoon:Schedule(31)
		timerSpiritBolts:Start()
		timerSpiritBoltsNext:Start()
	elseif args.spellId == 43421 then
		warnLifebloom:Show(args.destName)
		specWarnLifebloom:Show(args.destName)
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 43429 and destGUID == UnitGUID("player") and self:AntiSpam(3) then		--Paladin (Consecration)
		specWarnConsecration:Show()
	elseif spellId == 43440 and destGUID == UnitGUID("player") and self:AntiSpam(3) then	--Warlock(Rain of Fire)
		specWarnRainofFire:Show()
	elseif spellId == 61603 and destGUID == UnitGUID("player") and self:AntiSpam(3) then	--Death Knight(Death and Decay)
		specWarnDeathNDecay:Show()
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE
