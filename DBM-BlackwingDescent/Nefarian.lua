local mod	= DBM:NewMod(174, "DBM-BlackwingDescent", nil, 73)
local L		= mod:GetLocalizedStrings()
local Nefarian	= DBM:EJ_GetSectionInfo(3279)
local Onyxia	= DBM:EJ_GetSectionInfo(3283)

mod:SetRevision("20190625143316")
mod:SetCreatureID(41376, 41270)
mod:SetEncounterID(1026) -- ES fires when Nefarian engaged.
mod:SetZone()
--mod:SetModelSound("Sound\\Creature\\Nefarian\\VO_BD_Nefarian_Event09.ogg", "Sound\\Creature\\Nefarian\\VO_BD_Nefarian_Event13.ogg")
--"Ha ha ha ha ha! The heroes have made it to the glorious finale. I take it you are in good spirits? Prepared for the final battle? Then gaze now upon my ultimate creation! RISE, SISTER!" = "Nefarian\\VO_BD_Nefarian_Event01",
--Long: I have tried to be an accommodating host, but you simply will not die! Time to throw all pretense aside and just... KILL YOU ALL!.
--Short: You really have to want it!

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_SUCCESS",
	"SPELL_DAMAGE 81007",
	"SPELL_MISSED 81007",
	"CHAT_MSG_MONSTER_YELL",
	"RAID_BOSS_EMOTE"
)

local warnOnyTailSwipe			= mod:NewAnnounce("OnyTailSwipe", 3, 77827)--we only care about onyxia's tailswipe. Nefarian's shouldn't get in the way or you're doing it wrong.
local warnNefTailSwipe			= mod:NewAnnounce("NefTailSwipe", 3, 77827, false)--but for those that might care for whatever reason, we include his too, off by default.
local warnOnyShadowflameBreath	= mod:NewAnnounce("OnyBreath", 3, 77826, "Tank")
local warnNefShadowflameBreath	= mod:NewAnnounce("NefBreath", 3, 77826, "Tank")
local warnBlastNova				= mod:NewSpellAnnounce(80734, 3, nil, false)--Can be spammy so now off by default.
local warnCinder				= mod:NewTargetAnnounce(79339, 4)
local warnPhase2				= mod:NewPhaseAnnounce(2)
local warnPhase3				= mod:NewPhaseAnnounce(3)
local warnDominion				= mod:NewTargetAnnounce(79318, 3)
local warnShadowBlaze			= mod:NewSpellAnnounce(81031, 4)--May be quirky
local warnShadowblazeSoon		= mod:NewAnnounce("warnShadowblazeSoon", 2, 81031, "Tank", nil, true)--Back to on by default for tanks until option isn't tied to sound.

local specWarnElectrocute		= mod:NewSpecialWarningSpell(81198, nil, nil, nil, true)
local specWarnBlastsNova		= mod:NewSpecialWarningInterrupt(80734)
local specWarnDominion			= mod:NewSpecialWarningYou(79318)
local specWarnStolenPower		= mod:NewSpecialWarningStack(80627, nil, 150)
local specWarnCinder			= mod:NewSpecialWarningYou(79339)
local specWarnCinderMove		= mod:NewSpecialWarningMoveAway(79339, true, "specWarnCinderMove", nil, 3)
local yellCinder				= mod:NewYell(79339)
local specWarnShadowblaze		= mod:NewSpecialWarningMove(81007)
local specWarnShadowblazeSoon	= mod:NewSpecialWarning("specWarnShadowblazeSoon", "Tank")

local timerBlastNova			= mod:NewCastTimer(1.5, 80734)
local timerElectrocute			= mod:NewCastTimer(5, 81198)
local timerNefLanding			= mod:NewTimer(30, "timerNefLanding", 78620)
local timerShadowflameBarrage	= mod:NewBuffActiveTimer(150, 78621)
local timerOnySwipeCD			= mod:NewTimer(10, "OnySwipeTimer", 77827)--10-20 second cd (18 being the most consistent)
local timerNefSwipeCD			= mod:NewTimer(10, "NefSwipeTimer", 77827, false)--Same as hers, but not synced.
local timerOnyBreathCD			= mod:NewTimer(12, "OnyBreathTimer", 77826, "Tank|Healer")--12-20 second variations
local timerNefBreathCD			= mod:NewTimer(12, "NefBreathTimer", 77826, "Tank|Healer")--same as above
local timerCinder				= mod:NewBuffFadesTimer(8, 79339)--Heroic Ability
local timerCinderCD				= mod:NewCDTimer(22, 79339)--Heroic Ability (Every 22-25 seconds, 25 being most common but we gotta use 22 for timer cause of that small chance it's that).
local timerDominionCD			= mod:NewNextTimer(15, 79318, nil, not "Tank")
local timerShadowBlazeCD		= mod:NewCDTimer(10, 81031, nil, nil, nil, 5, nil, DBM_CORE_TANK_ICON, nil, 2, 4)

local berserkTimer				= mod:NewBerserkTimer(630)

mod:AddBoolOption("RangeFrame", true)
mod:AddBoolOption("SetIconOnCinder", true)
mod:AddBoolOption("InfoFrame", true)
mod:AddBoolOption("SetWater", true)

local shadowblazeTimer = 35
local cinderIcons = 8
local playerDebuffs = 0
local cinderTargets	= {}
local cinderDebuff = DBM:GetSpellInfo(79339)
local dominionTargets = {}
local lastBlaze = 0--Do NOT use prototype for this, it's updated in a special way using different triggers then when method is called.
local CVAR = false
local shadowBlazeSynced = false
local Charge = DBM:EJ_GetSectionInfo(3284)

--Credits to Caleb for original concept, modified with yell sync and timer tweaks.
function mod:ShadowBlazeFunction()
	lastBlaze = GetTime()
	if shadowblazeTimer > 15 then
		shadowblazeTimer = shadowblazeTimer - 5
	elseif shadowblazeTimer > 10 and self:IsDifficulty("heroic10", "heroic25") then
		shadowblazeTimer = shadowblazeTimer - 5
	end
	warnShadowBlaze:Show()
	if not shadowBlazeSynced then
		specWarnShadowblazeSoon:Schedule(shadowblazeTimer - 5, L.ShadowBlazeEstimate)--Pre warning 5 seconds prior to be safe, until we sync timer and know for sure.
	else
		warnShadowblazeSoon:Schedule(shadowblazeTimer - 5, L.ShadowBlazeExact:format(5))--Start pre warning with regular warnings only as you don't move at this point yet.
		warnShadowblazeSoon:Schedule(shadowblazeTimer - 4, L.ShadowBlazeExact:format(4))
		warnShadowblazeSoon:Schedule(shadowblazeTimer - 3, L.ShadowBlazeExact:format(3))
		warnShadowblazeSoon:Schedule(shadowblazeTimer - 2, L.ShadowBlazeExact:format(2))
		specWarnShadowblazeSoon:Schedule(shadowblazeTimer - 1, L.ShadowBlazeExact:format(1))--Special warn at 1 seconds to hall ass at this time.
	end
	timerShadowBlazeCD:Start(shadowblazeTimer)
	self:ScheduleMethod(shadowblazeTimer, "ShadowBlazeFunction")
end

local cindersDebuffFilter
do
	cindersDebuffFilter = function(uId)
		return DBM:UnitDebuff(uId, cinderDebuff)
	end
end

local function warnCinderTargets(self)
	if self.Options.RangeFrame then
		if DBM:UnitDebuff("player", cinderDebuff) then--You have debuff, show everyone
			DBM.RangeCheck:Show(10, nil)
		else--You do not have debuff, only show players who do
			DBM.RangeCheck:Show(10, cindersDebuffFilter)
		end
	end
	warnCinder:Show(table.concat(cinderTargets, "<, >"))
	timerCinder:Start()
	timerCinderCD:Start()
	table.wipe(cinderTargets)
	cinderIcons = 8
end

local function warnDominionTargets()
	warnDominion:Show(table.concat(dominionTargets, "<, >"))
	timerDominionCD:Start()
	table.wipe(dominionTargets)
end

function mod:OnCombatStart(delay)
	shadowBlazeSynced = false
	shadowblazeTimer = 35
	playerDebuffs = 0
	CVAR = false
	table.wipe(cinderTargets)
	table.wipe(dominionTargets)
	timerNefLanding:Start(-delay)
	if self:IsDifficulty("heroic10", "heroic25") then
		berserkTimer:Start(-delay)
		timerDominionCD:Start(50-delay)
	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(Charge)
		DBM.InfoFrame:Show(2, "enemypower", 2, ALTERNATE_POWER_INDEX)
	end
	if self.Options.SetWater and GetCVarBool("cameraWaterCollision") then
		CVAR = true--Cvar was true on pull so we remember that.
		SetCVar("cameraWaterCollision", 0)
	end
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.SetWater and not GetCVarBool("cameraWaterCollision") and CVAR then--Only turn it back on if it's off now, but it was on when we pulled.
		SetCVar("cameraWaterCollision", 1)
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 77826 then
		if args:GetSrcCreatureID() == 41270 then--Source is onyxia
			warnOnyShadowflameBreath:Show()
			timerOnyBreathCD:Start()
		else--if not onyxia then it's nef
			warnNefShadowflameBreath:Show()
			timerNefBreathCD:Start()
		end
	elseif args.spellId == 80734 then
		if args.sourceGUID == UnitGUID("target") then--Only show warning/timer for your own target.
			warnBlastNova:Show()
			specWarnBlastsNova:Show(args.sourceName)
			if self:IsDifficulty("heroic10", "heroic25") then
				timerBlastNova:Start()
			else
				timerBlastNova:Start(4)--4 second hurp cast on normal since 4.2
			end
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 79339 then
		cinderTargets[#cinderTargets + 1] = args.destName
		playerDebuffs = playerDebuffs + 1
		if args:IsPlayer() then
			specWarnCinder:Show()
			specWarnCinderMove:Schedule(3)
			yellCinder:Yell()
		end
		if self.Options.SetIconOnCinder then
			self:SetIcon(args.destName, cinderIcons)
			cinderIcons = cinderIcons - 1
		end
		self:Unschedule(warnCinderTargets)
		if (self:IsDifficulty("heroic25") and #cinderTargets >= 3) or (self:IsDifficulty("heroic10") and #cinderTargets >= 1) then
			warnCinderTargets(self)
		else
			self:Schedule(0.3, warnCinderTargets, self)
		end
	elseif args.spellId == 79318 then
		dominionTargets[#dominionTargets + 1] = args.destName
		if args:IsPlayer() then
			specWarnDominion:Show()
		end
		self:Unschedule(warnDominionTargets)
		if (self:IsDifficulty("heroic25") and #dominionTargets >= 5) or (self:IsDifficulty("heroic10") and #dominionTargets >= 2) then
			warnDominionTargets()
		else
			self:Schedule(0.3, warnDominionTargets)
		end
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args.spellId == 80627 and args:IsPlayer() and (args.amount or 1) >= 150 then
		specWarnStolenPower:Show(args.amount)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 79339 then
		playerDebuffs = playerDebuffs - 1
		if args:IsPlayer() and self.Options.RangeFrame and playerDebuffs >= 1 then
			DBM.RangeCheck:Show(10, cindersDebuffFilter)--Change to debuff filter based check since theirs is gone but there are still cinders in raid.
		end
		if self.Options.RangeFrame and playerDebuffs == 0 then--All of them are gone. We do it this way since some may cloak/bubble/iceblock early and we don't want to just cancel range finder if 1 of 3 end early.
			DBM.RangeCheck:Hide()
		end
		if self.Options.SetIconOnCinder then
			self:SetIcon(args.destName, 0)
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 77827 then
		if args:GetSrcCreatureID() == 41270 then
			warnOnyTailSwipe:Show()
			timerOnySwipeCD:Start()
		else
			warnNefTailSwipe:Show()
			timerNefSwipeCD:Start()
		end
	end
end

function mod:SPELL_DAMAGE(sourceGUID, sourceName, sourceFlags, _, destGUID, _, _, _, spellId)
	if spellId == 81007 and destGUID == UnitGUID("player") and self:AntiSpam(4) then
		specWarnShadowblaze:Show()
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellPhase2 or msg:find(L.YellPhase2) then
		if self.Options.InfoFrame then
			DBM.InfoFrame:Hide()
		end
		warnPhase2:Show()
		timerOnySwipeCD:Cancel()
		timerNefSwipeCD:Cancel()
		timerOnyBreathCD:Cancel()
		timerNefBreathCD:Cancel()
		timerDominionCD:Cancel()
		timerShadowflameBarrage:Start()
		if self:IsDifficulty("heroic10", "heroic25") then
			timerCinderCD:Start(11.5)--10+ cast, since we track application not cast.
		end
	elseif msg == L.YellPhase3 or msg:find(L.YellPhase3) then
		lastBlaze = 0
		warnPhase3:Show()
		timerCinderCD:Cancel()
		timerShadowflameBarrage:Cancel()
		timerShadowBlazeCD:Start(12)--Seems to vary some, 12 should be a happy medium, it can be off 1-2 seconds though.
		self:ScheduleMethod(12, "ShadowBlazeFunction")
	elseif msg == L.YellShadowBlaze or msg:find(L.YellShadowBlaze) then--He only does this sometimes, it's not a trigger to replace loop, more so to correct it.
		shadowBlazeSynced = true
		self:UnscheduleMethod("ShadowBlazeFunction")--Unschedule any running stuff
		specWarnShadowblazeSoon:Cancel()--^^
		timerShadowBlazeCD:Stop()--^^ Auto corrections still occur more then once, lets make sure to unschedule audio countdown as well so we don't start getting 2 running.
		if GetTime() - lastBlaze <= 3 then--The blaze timer is too fast, since the actual cast happened immediately after the method ran. So reschedule functions using last timing which should be right just a little fast. :)
			warnShadowblazeSoon:Schedule(shadowblazeTimer - 5, L.ShadowBlazeExact:format(5))--Start pre warning with regular warnings only as you don't move at this point yet.
			warnShadowblazeSoon:Schedule(shadowblazeTimer - 4, L.ShadowBlazeExact:format(4))
			warnShadowblazeSoon:Schedule(shadowblazeTimer - 3, L.ShadowBlazeExact:format(3))
			warnShadowblazeSoon:Schedule(shadowblazeTimer - 2, L.ShadowBlazeExact:format(2))
			specWarnShadowblazeSoon:Schedule(shadowblazeTimer - 1, L.ShadowBlazeExact:format(1))--Special warn at 1 seconds to hall ass at this time.
			timerShadowBlazeCD:Start(shadowblazeTimer)
			self:ScheduleMethod(shadowblazeTimer, "ShadowBlazeFunction")
		elseif GetTime() - lastBlaze >= 6 then--It's been a considerable amount of time since last blaze, which means timer is slow cause he cast it before a new time stamp could be created.
			self:ShadowBlazeFunction()--run function immediately, the function will handle the rest.
		end
	end
end

function mod:RAID_BOSS_EMOTE(msg)
	if (msg == L.NefAoe or msg:find(L.NefAoe)) and self:IsInCombat() then
		specWarnElectrocute:Show()
		timerElectrocute:Start()
	end
end
