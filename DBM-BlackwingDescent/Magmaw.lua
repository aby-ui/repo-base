local mod	= DBM:NewMod(170, "DBM-BlackwingDescent", nil, 73)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143316")
mod:SetCreatureID(41570)
mod:SetEncounterID(1024) --no ES fires this boss.
mod:SetZone()
--mod:SetModelSound("Sound\\Creature\\Nefarian\\VO_BD_Nefarian_MagmawIntro01.ogg", nil)
--Long: I found this fascinating specimen in the lava underneath this very room. Magmaw should provide an adequate challenge for your pathetic little band.
--Short: There isn't one

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_SUCCESS",
	"SPELL_SUMMON",
	"SPELL_DAMAGE",
	"SPELL_MISSED",
	"CHAT_MSG_MONSTER_YELL",
	"RAID_BOSS_EMOTE",
	"UNIT_HEALTH boss1",
	"UNIT_DIED"
)

local warnLavaSpew			= mod:NewSpellAnnounce(77689, 3, nil, "Healer")
local warnPillarFlame		= mod:NewSpellAnnounce(78006, 3)
local warnMoltenTantrum		= mod:NewSpellAnnounce(78403, 4)
local warnInferno			= mod:NewSpellAnnounce(92154, 4)
local warnMangle			= mod:NewTargetAnnounce(89773, 3)
local warnArmageddon		= mod:NewSpellAnnounce(92177, 4)
local warnPhase2Soon		= mod:NewPrePhaseAnnounce(2, 3)--heroic
local warnPhase2			= mod:NewPhaseAnnounce(2, 4)--heroic

local specWarnPillar		= mod:NewSpecialWarningSpell(78006, "Ranged")
local specWarnIgnition		= mod:NewSpecialWarningMove(92128)
local specWarnInfernoSoon   = mod:NewSpecialWarning("SpecWarnInferno")
local specWarnArmageddon	= mod:NewSpecialWarningSpell(92177, nil, nil, nil, true)

local timerLavaSpew			= mod:NewCDTimer(22, 77689, nil, "Healer")
local timerPillarFlame		= mod:NewCDTimer(32.5, 78006)--This timer is a CD timer. 30-40 seconds. Use your judgement.
local timerMangle			= mod:NewTargetTimer(30, 89773)
local timerExposed			= mod:NewBuffActiveTimer(30, 79011)
local timerMangleCD			= mod:NewCDTimer(95, 89773)
local timerInferno			= mod:NewNextTimer(35, 92154)
local timerArmageddon		= mod:NewCastTimer(8, 92177)

local berserkTimer			= mod:NewBerserkTimer(600)

mod:AddBoolOption("RangeFrame")

local geddonConstruct = 0
local prewarnedPhase2 = false

function mod:OnCombatStart(delay)
	geddonConstruct = 0
	prewarnedPhase2 = false
	timerPillarFlame:Start(30-delay)
	timerMangleCD:Start(90-delay)
	berserkTimer:Start(-delay)
	if self:IsDifficulty("heroic10", "heroic25") then
		timerInferno:Start(30-delay)
		specWarnInfernoSoon:Schedule(26-delay)
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end 

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 78006 then--More than one spellid?
		warnPillarFlame:Show()
		specWarnPillar:Show()
		timerPillarFlame:Start()
	elseif args.spellId == 78403 then
		warnMoltenTantrum:Show()
	elseif args.spellId == 89773 then
		warnMangle:Show(args.destName)
		timerMangle:Start(args.destName)
		timerMangleCD:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 89773 then
		timerMangle:Cancel(args.destName)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 77690 and self:AntiSpam(5, 1) then
		warnLavaSpew:Show()
		timerLavaSpew:Start()
	elseif args.spellId == 92177 then
		warnArmageddon:Show()
		specWarnArmageddon:Show()
		timerArmageddon:Start()
		geddonConstruct = args.sourceGUID--Cache last mob to cast armageddon
	end
end

function mod:SPELL_SUMMON(args)
	if args.spellId == 92154 then
		warnInferno:Show()
		specWarnInfernoSoon:Schedule(31)
		timerInferno:Start()
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 92128 and destGUID == UnitGUID("player") and self:AntiSpam(4, 2) then
		specWarnIgnition:Show()
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

-- heroic phase 2
function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellPhase2 or msg:find(L.YellPhase2) then
		timerInferno:Cancel()
		specWarnInfernoSoon:Cancel()
		warnPhase2:Show()
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(5)
		end
	end
end

function mod:RAID_BOSS_EMOTE(msg)
	if msg == L.Slump or msg:find(L.Slump) then
		timerPillarFlame:Start(15)--Resets to 15. If you don't get his head down by then he gives you new adds to mess with. (theory, don't have a lot of logs with chain screwups yet)
	elseif msg == L.HeadExposed or msg:find(L.HeadExposed) then
		timerExposed:Start()
		timerPillarFlame:Start(40)
	end
end

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 41570 and self:IsDifficulty("heroic10", "heroic25") then
		local h = UnitHealth(uId) / UnitHealthMax(uId) * 100
		if h > 40 and prewarnedPhase2 then
			prewarnedPhase2 = false
		elseif h > 29 and h < 34 and not prewarnedPhase2 then
			prewarnedPhase2 = true
			warnPhase2Soon:Show()
		end
	end
end

function mod:UNIT_DIED(args)
	if args.destGUID == geddonConstruct then--Check GUID of units dying if they match last armageddon casting construct. Better than CID alone so we don't cancel it if a diff one dies, but probably not perfect if two cast it at once heh.
		timerArmageddon:Cancel()
	end
end
