local mod	= DBM:NewMod(171, "DBM-BlackwingDescent", nil, 73)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143316")
mod:SetCreatureID(41442)
mod:SetEncounterID(1022)
mod:SetZone()
mod:SetUsedIcons(8)
--mod:SetModelSound("Sound\\Creature\\Nefarian\\VO_BD_Nefarian_AtramedesIntro.ogg", "Sound\\Creature\\Atramedes\\VO_BD_Atramedes_Event03.ogg")
--Long: Atramedes, are you going deaf as well as blind? Hurry up and kill them all.
--Short: Death waits in the darkness!

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"UNIT_DIED",
	"CHAT_MSG_MONSTER_YELL",
	"UNIT_AURA player"
)

local warnSonarPulse		= mod:NewSpellAnnounce(77672, 3)
local warnSonicBreath		= mod:NewSpellAnnounce(78075, 3)
local warnTracking			= mod:NewTargetAnnounce(78092, 4)
local warnAirphase			= mod:NewSpellAnnounce("ej3081", 3, "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendUnBurrow.blp")
local warnGroundphase		= mod:NewSpellAnnounce("ej3061", 2, "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendBurrow.blp")
local warnShieldsLeft		= mod:NewAddsLeftAnnounce("ej3073", 2, 77611)
local warnAddSoon			= mod:NewSoonAnnounce("ej3082", 3, 92685)
local warnPhaseShift		= mod:NewSpellAnnounce(92681, 3)
local warnObnoxious			= mod:NewCastAnnounce(92677, 4, nil, false)
local warnSearingFlameSoon	= mod:NewSoonAnnounce(77840, 3, nil, false)

local specWarnSearingFlame	= mod:NewSpecialWarningSpell(77840, nil, nil, nil, 2)
local specWarnSonarPulse	= mod:NewSpecialWarningSpell(77672, false, nil, nil, 2)
local specWarnTracking		= mod:NewSpecialWarningRun(78092, nil, nil, nil, 4)
local specWarnPestered		= mod:NewSpecialWarningYou(92685)
local yellPestered			= mod:NewYell("ej3082")
local specWarnObnoxious		= mod:NewSpecialWarningInterrupt(92677, "Melee")
local specWarnAddTargetable	= mod:NewSpecialWarningSwitch("ej3082", "Ranged")

local timerSonarPulseCD		= mod:NewCDTimer(10, 77672)
local timerSonicBreath		= mod:NewCDTimer(41, 78075)
local timerSearingFlame		= mod:NewCDTimer(45, 77840)
local timerAirphase			= mod:NewNextTimer(85, "ej3081", nil, nil, nil, nil, "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendUnBurrow.blp")--These both need more work
local timerGroundphase		= mod:NewNextTimer(31.5, "ej3061", nil, nil, nil, nil, "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendBurrow.blp")--I just never remember to log and /yell at right times since they lack most accurate triggers.

local berserkTimer			= mod:NewBerserkTimer(600)

mod:AddBoolOption("TrackingIcon")
mod:AddBoolOption("InfoFrame")

local shieldsLeft = 10
local pestered = DBM:GetSpellInfo(92685)
local pesteredWarned = false
local SoundLevel = DBM:EJ_GetSectionInfo(3072)

local function groundphase()
	timerAirphase:Start()
	timerSonicBreath:Start(25)
	timerSearingFlame:Start()
	warnSearingFlameSoon:Schedule(40)
end

function mod:OnCombatStart(delay)
	timerSonarPulseCD:Start(-delay)
	timerSonicBreath:Start(25-delay)
	warnSearingFlameSoon:Schedule(40-delay)
	timerSearingFlame:Start(-delay)
	timerAirphase:Start(90-delay)
	shieldsLeft = 10
	pesteredWarned = false
	if self:IsDifficulty("heroic10", "heroic25") then
		berserkTimer:Start(-delay)
	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(SoundLevel)
		DBM.InfoFrame:Show(5, "playerpower", 10, ALTERNATE_POWER_INDEX)
	end
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end 

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 78092 then
		warnTracking:Show(args.destName)
		if args:IsPlayer() then
			specWarnTracking:Show()
		end
		if self.Options.TrackingIcon then
			self:SetIcon(args.destName, 8)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 78092 then
		if self.Options.TrackingIcon then
			self:SetIcon(args.destName, 0)
		end
	elseif args.spellId == 92681 then--Phase shift removed, add targetable/killable.
		specWarnAddTargetable:Show(args.destName)
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 92677 then
		warnObnoxious:Show()
		if self:IsMelee() and (self:GetUnitCreatureId("target") == 49740 or self:GetUnitCreatureId("focus") == 49740) or not self:IsMelee() then
			specWarnObnoxious:Show(args.sourceName)--Only warn for melee targeting him or exclicidly put him on focus, else warn regardless if he's your target/focus or not if you aren't a melee
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 78075 then
		timerSonicBreath:Start()
		warnSonicBreath:Show()
	elseif args.spellId == 77840 then
		specWarnSearingFlame:Show()
	elseif args.spellId == 92681 then--Add is phase shifting which means a new one is spawning, or an old one is changing target cause their first target died.
		warnPhaseShift:Show()
		pesteredWarned = false--Might need more work on this.
	elseif args.spellId == 77672 then--Sonar Pulse (the discs)
		warnSonarPulse:Show()
		specWarnSonarPulse:Show()
		timerSonarPulseCD:Start()
	end
end

function mod:UNIT_DIED(args)
	if self:IsInCombat() and args:IsNPC() and self:GetCIDFromGUID(args.destGUID) ~= 49740 then
		shieldsLeft = shieldsLeft - 1
		warnShieldsLeft:Show(shieldsLeft)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.Airphase or msg:find(L.Airphase)  then
		warnAirphase:Show()
		timerSonicBreath:Cancel()
		timerSonarPulseCD:Cancel()
		timerGroundphase:Start()
		self:Schedule(31.5, groundphase)
	elseif msg == L.NefAdd or msg:find(L.NefAdd)  then
		warnAddSoon:Show()--Unfortunately it seems quite random when he does this so i cannot add a CD bar for it. i see variations as large as 20 seconds in between to a minute in between.
	end
end

function mod:UNIT_AURA(uId)
	if pesteredWarned then return end
	if DBM:UnitDebuff("player", pestered) then
		pesteredWarned = true--This aura is a periodic trigger, so we don't want to spam warn for it.
		specWarnPestered:Show()
		yellPestered:Yell()
	end
end
