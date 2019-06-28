local mod	= DBM:NewMod(1153, "DBM-Highmaul", nil, 477)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143352")
mod:SetCreatureID(79015)
mod:SetEncounterID(1723)
mod:SetZone()
mod:SetUsedIcons(8, 7, 6, 3, 2, 1)--Don't know total number of icons needed yet
--Could not find sound path on internet

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 162185 162184 172747 163517 162186 172895",
	"SPELL_CAST_SUCCESS 161612",
	"SPELL_AURA_APPLIED 156803 162186 161242 163472 172895 172917",
	"SPELL_AURA_REMOVED 162186 163472 172895 156803",
	"SPELL_DAMAGE 161612 161576",
	"SPELL_ABSORBED 161612 161576",
	"SPELL_MISSED 161612 161576",
	"CHAT_MSG_MONSTER_YELL"
)

local warnCausticEnergy				= mod:NewTargetAnnounce(161242, 3, nil, "Melee", 2)
local warnTrample					= mod:NewTargetAnnounce(163101, 3)--Technically it's supression field, then trample, but everyone is going to know it more by trample cause that's the part of it that matters
local warnExpelMagicFrost			= mod:NewTargetAnnounce(161411, 3)
local warnExpelMagicArcane			= mod:NewTargetAnnounce(162186, 4)
local warnBallsSoon					= mod:NewPreWarnAnnounce(161612, 6.5, 2)
local warnBallsHit					= mod:NewCountAnnounce(161612, 2)
local warnMC						= mod:NewTargetAnnounce(163472, 4)--Mythic
local warnForfeitPower				= mod:NewCastAnnounce(163517, 4, nil, nil, false, 2)--Definitely Spammy (can have 8 up at once)
local warnExpelMagicFel				= mod:NewTargetAnnounce(172895, 4)

local specWarnNullBarrier			= mod:NewSpecialWarningTarget(156803)--Only warn for boss
local specWarnVulnerability			= mod:NewSpecialWarningTarget(160734)--Switched to target warning since some may be assined adds, some to boss, but all need to know when this phase starts
local specWarnTrample				= mod:NewSpecialWarningYou(163101, nil, nil, nil, nil, 2)
local yellTrample					= mod:NewYell(163101)
local specWarnTrampleNear			= mod:NewSpecialWarningClose(163101)
local specWarnExpelMagicFire		= mod:NewSpecialWarningMoveAway(162185, nil, nil, nil, nil, 2)
local specWarnExpelMagicShadow		= mod:NewSpecialWarningSpell(162184, "Healer", nil, nil, nil, 2)
local specWarnExpelMagicFrostYou	= mod:NewSpecialWarningYou(161411, false)
local specWarnExpelMagicFrost		= mod:NewSpecialWarningSpell(161411, false, nil, nil, nil, 2)
local specWarnExpelMagicArcaneYou	= mod:NewSpecialWarningMoveAway(162186, nil, nil, nil, 3, 2)
local specWarnExpelMagicArcane		= mod:NewSpecialWarningTaunt(162186, nil, nil, nil, nil, 2)
local yellExpelMagicArcane			= mod:NewYell(162186)
local specWarnBallsSoon				= mod:NewSpecialWarningPreWarn(161612, nil, 6.5, nil, nil, nil, 2)
local specWarnMC					= mod:NewSpecialWarningSwitch(163472, "Dps", nil, nil, 1, 2)
local specWarnForfeitPower			= mod:NewSpecialWarningInterrupt(163517)--Spammy?
local specWarnExpelMagicFel			= mod:NewSpecialWarningYou(172895)--Maybe needs "do not move" warning or at very least "try not to move" since sometimes you have to move for trample.
local specWarnExpelMagicFelFades	= mod:NewSpecialWarning("specWarnExpelMagicFelFades", nil, nil, nil, 3, 2)--No generic that describes this
local yellExpelMagicFel				= mod:NewYell(172895)
local specWarnExpelMagicFelMove		= mod:NewSpecialWarningMove(172917)--Under you (fire). If not enough maybe add periodic damage too?

local timerVulnerability			= mod:NewBuffActiveTimer(23, 160734, nil, nil, nil, 6)--more like 23-24 than 20
local timerTrampleCD				= mod:NewCDTimer(16, 163101, nil, nil, nil, 3)
local timerExpelMagicFire			= mod:NewBuffFadesTimer(11.5, 162185, nil, false, 2, 5, nil, nil, nil, 1, 4)
local timerExpelMagicFireCD			= mod:NewCDTimer(58, 162185, nil, nil, nil, 3)--58-66 Variation
local timerExpelMagicFrost			= mod:NewBuffActiveTimer(20, 161411, nil, false, 3)
local timerExpelMagicFrostCD		= mod:NewCDTimer(60, 161411, nil, nil, nil, 2)--60-63 variation
local timerExpelMagicShadowCD		= mod:NewCDTimer(59, 162184, nil, "Tank|Healer", nil, 5)--60-63 variation
local timerExpelMagicArcane			= mod:NewTargetTimer(10, 162186, nil, "Tank|Healer")
local timerExpelMagicArcaneCD		= mod:NewCDTimer(26, 162186, nil, "Tank", nil, 5, nil, DBM_CORE_TANK_ICON)--26-32
local timerBallsCD					= mod:NewNextCountTimer(30, 161612, nil, nil, nil, 5, nil, nil, nil, 1, 5)
mod:AddTimerLine(ENCOUNTER_JOURNAL_SECTION_FLAG12)
local timerExpelMagicFelCD			= mod:NewCDTimer(15.5, 172895, nil, "-Tank", 2, 3, nil, DBM_CORE_HEROIC_ICON)--Mythic
local timerExpelMagicFel			= mod:NewBuffFadesTimer(12, 172895, nil, nil, nil, 5, nil, nil, nil, 3, 4)--Mythic

mod:AddRangeFrameOption("5")
mod:AddSetIconOption("SetIconOnMC", 163472, false)
mod:AddSetIconOption("SetIconOnFel", 172895, false)
mod:AddArrowOption("FelArrow", 172895, true, 3)
mod:AddHudMapOption("HudMapOnMC", 163472)
mod:AddHudMapOption("HudMapForFel", 172895)

mod.vb.ballsCount = 0
mod.vb.shieldCharging = false
mod.vb.fireActive = false
local lastX, LastY = nil, nil--Not in VB table because it player personal position
local barName, arcaneDebuff = DBM:GetSpellInfo(156803), DBM:GetSpellInfo(162186)

local function closeRange(self)
	if self.Options.RangeFrame and not DBM:UnitDebuff("player", arcaneDebuff) then
		DBM.RangeCheck:Hide()
	end
	self.vb.fireActive = false
end

local function ballsWarning(self)
	DBM:Debug("Balls should be falling in 6.5 second")
	if UnitPower("player", 10) > 0 then--Player is soaker
		specWarnBallsSoon:Show()--Player who soaks
		specWarnBallsSoon:Play("161612")
	else
		warnBallsSoon:Show()--Everyone else
	end
end

local function checkBossForgot(self)
	DBM:Debug("checkBossForgot ran, which means expected balls 10 seconds late, starting 20 second timer for next balls")
--	self.vb.ballsCount = self.vb.ballsCount + 1
	timerBallsCD:Start(20, self.vb.ballsCount+1)
	self:Schedule(13.5, ballsWarning, self)
end

local function returnPosition(self)
	specWarnExpelMagicFelFades:Show()
	specWarnExpelMagicFelFades:Play("172895")
	if self.Options.FelArrow and lastX and LastY then
		DBM.Arrow:ShowRunTo(lastX, LastY, 0, 5)
	end
end

function mod:FrostTarget(targetname, uId)
	warnExpelMagicFrost:Show(targetname)
	if targetname == UnitName("player") then
		specWarnExpelMagicFrostYou:Show()
	end
end

function mod:OnCombatStart(delay)
	self.vb.ballsCount = 0
	self.vb.shieldCharging = false
	self.vb.fireActive = false
	timerExpelMagicFireCD:Start(6-delay)
	timerExpelMagicArcaneCD:Start(30-delay)
	timerBallsCD:Start(36-delay, 1)
	timerExpelMagicFrostCD:Start(40-delay)
	timerExpelMagicShadowCD:Start(55-delay)
	self:Schedule(29.5-delay, ballsWarning, self)
	if self:IsMythic() then
		timerExpelMagicFelCD:Start(5-delay)
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.FelArrow then
		DBM.Arrow:Hide()
	end
	if self.Options.HudMapOnMC or self.Options.HudMapForFel then
		DBMHudMap:Disable()
	end
end

function mod:ArcaneTarget()
	local targetName, uId = self:GetBossTarget(79015)
	local tanking, status = UnitDetailedThreatSituation("player", "boss1")
	if tanking or (status == 3) then--Player is current target
		specWarnExpelMagicArcaneYou:Show()--So show tank warning
		specWarnExpelMagicArcaneYou:Play("runout")
	else
		if self:AntiSpam(3.5, targetName) then--Set anti spam with target name
			specWarnExpelMagicArcane:Show(targetName)--Sometimes targetname is nil, and then it warns for unknown, but with the new status == 3 check, it'll still warn correct tank, so useful anyways
			specWarnExpelMagicArcane:Play("changemt")
		end
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 162185 then
		self.vb.fireActive = true
		specWarnExpelMagicFire:Schedule(5)--Give you about 4 seconds to spread out
		--Even if you AMS or resist debuff, need to avoid others that didn't, so rangecheck now here
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(5)
		end
		timerExpelMagicFire:Start()
		if self.vb.shieldCharging then
			timerExpelMagicFireCD:Start(87)
		else
			timerExpelMagicFireCD:Start()
		end
		specWarnExpelMagicFire:Play("scattersoon")
		specWarnExpelMagicFire:ScheduleVoice(5, "scatter")
		self:Schedule(11.5, closeRange, self)
	elseif spellId == 162184 then
		specWarnExpelMagicShadow:Show()
		if self.vb.shieldCharging then
			timerExpelMagicShadowCD:Start(87)
			DBM:Debug("timerExpelMagicShadowCD started during charging phase, adding 27 seconds")
		else
			timerExpelMagicShadowCD:Start()
		end
		specWarnExpelMagicShadow:Play("healall")
	elseif args:IsSpellID(172747) then
		specWarnExpelMagicFrost:Show()
		if self.vb.shieldCharging then
			timerExpelMagicFrostCD:Start(83)
			DBM:Debug("timerExpelMagicShadowCD started during charging phase, adding 23 seconds")
		else
			timerExpelMagicFrostCD:Start()
		end
		if not self:IsLFR() then
			timerExpelMagicFrost:Start()
		else
			timerExpelMagicFrost:Start(21.5)
		end
		specWarnExpelMagicFrost:Play("161411")
		self:BossTargetScanner(79015, "FrostTarget", 0.1, 16)
	elseif spellId == 163517 then
		warnForfeitPower:Show()
		if self:CheckInterruptFilter(args.sourceGUID) then
			specWarnForfeitPower:Show(args.sourceName)
		end
	elseif spellId == 162186 then
		self:ScheduleMethod(0.1, "ArcaneTarget")
	elseif spellId == 172895 then
		timerExpelMagicFelCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 161612 and self:AntiSpam(5, 4) then--This won't show balls that hit, only ones caught. Balls that hit require high cpu spell_damage event
		self:SendSync("Ball")
	end
end

function mod:SPELL_DAMAGE() -- captures spellid 161612, 161576
	if self:AntiSpam(5, 4) then
		self:SendSync("Ball")
	end
end
mod.SPELL_ABSORBED = mod.SPELL_DAMAGE
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 156803 then
		self.vb.shieldCharging = false
		specWarnNullBarrier:Show(args.destName)
	elseif spellId == 162186 then
		timerExpelMagicArcane:Start(args.destName)
		if self.vb.shieldCharging then--Sometimes debuff land during shield charging, if this happens, it's still extended
			timerExpelMagicArcaneCD:Start(49)--26+23
			DBM:Debug("timerExpelMagicArcaneCD started during charging phase, adding 23 seconds")
		else
			timerExpelMagicArcaneCD:Start()
		end
		if args:IsPlayer() then--Still do yell and range frame here, in case DK
			yellExpelMagicArcane:Yell()
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(5)
			end
		else
			if self:AntiSpam(3.5, args.destName) and self:IsTank() then--if antispam matches cast start warning, it won't warn again, if name is different, it'll trigger new warning
				specWarnExpelMagicArcane:Show(args.destName)
				specWarnExpelMagicArcane:Play("changemt")
			else
				warnExpelMagicArcane:Show(args.destName)
			end
		end
	elseif spellId == 161242 and self:AntiSpam(23, args.destName) and not self:IsLFR() then--Players may wabble in and out of it and we don't want to spam warnings.
		warnCausticEnergy:CombinedShow(1, args.destName)--Two targets on mythic, which is why combinedshow. (10 on LFR. too much spam and not important, so disabled in LFR)
	elseif spellId == 163472 then
		warnMC:CombinedShow(0.5, args.destName)
		if self:AntiSpam(3, 1) then
			specWarnMC:Show()
			specWarnMC:Play("findmc")
		end
		if self.Options.SetIconOnMC then
			self:SetSortedIcon(1, args.destName, 8, nil, true)--TODO, find out number of targets and add
		end
		if self.Options.HudMapOnMC then
			DBMHudMap:RegisterRangeMarkerOnPartyMember(spellId, "highlight", args.destName, 3.5, 0, 1, 0, 0, 0.5, nil, true, 1):Pulse(0.5, 0.5)
		end
	elseif spellId == 172895 then
		warnExpelMagicFel:CombinedShow(0.5, args.destName)
		if args:IsPlayer() then
			specWarnExpelMagicFel:Show()
			timerExpelMagicFel:Start()
			yellExpelMagicFel:Schedule(11)--Yell right before expire, not apply
			if not self:HasMapRestrictions() then
				lastX, LastY = UnitPosition("player")
				self:Schedule(7, returnPosition, self)
				if self.Options.HudMapForFel then
					DBMHudMap:RegisterStaticMarkerOnPartyMember(spellId, "highlight", args.destName, 3, 12, 0, 1, 0, 0.5, nil, nil, 4):Pulse(0.5, 0.5)
				end
			end
		end
		if self.Options.SetIconOnFel then
			self:SetSortedIcon(1, args.destName, 1, 3)
		end
	elseif spellId == 172917 and args:IsPlayer() then
		specWarnExpelMagicFelMove:Show()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 162186 and args:IsPlayer() and self.Options.RangeFrame and not self.vb.fireActive then
		DBM.RangeCheck:Hide()
	elseif spellId == 163472 then
		if self.Options.SetIconOnMC then
			self:SetIcon(args.destName, 0)
		end
		if self.Options.HudMapOnMC then
			DBMHudMap:FreeEncounterMarkerByTarget(spellId, args.destName)
		end
	elseif spellId == 172895 then
		if args:IsPlayer() then
			lastX, LastY = nil, nil
			if self.Options.FelArrow then
				DBM.Arrow:Hide()
			end
			if self.Options.HudMapForFel then
				DBMHudMap:FreeEncounterMarkerByTarget(spellId, args.destName)
			end
		end
		if self.Options.SetIconOnFel then
			self:SetIcon(args.destName, 0)
		end
	elseif spellId == 156803 then--Null barrier fall off boss
		DBM:Debug("Koragh Lost his shield")
		self.vb.shieldCharging = true
		specWarnVulnerability:Show(args.destName)
		timerVulnerability:Start()
		timerTrampleCD:Stop()
		--Here we making a fucking mess, because his timers pause during shield phase then resume. All with different rates from one another
		if self:IsMythic() then
		--Fel https://www.warcraftlogs.com/reports/kDzfJ812QZgpwa9h#view=events&pins=2%24Off%24%23244F4B%24expression%24ability.id+%3D+172895+and+type+%3D%22begincast%22+or+ability.id+%3D+156803+and+(type+%3D+%22applybuff%22+or+type+%3D+%22removebuff%22)&fight=11
			local felRemaining = timerExpelMagicFelCD:GetRemaining()
			if felRemaining > 0 then--Basically, a 0 0 check.
				timerExpelMagicFelCD:Start(felRemaining+23)
			end
		end
		--Frost https://www.warcraftlogs.com/reports/kDzfJ812QZgpwa9h#view=events&pins=2%24Off%24%23244F4B%24expression%24ability.id+%3D+172747+and+type+%3D+%22begincast%22+or+ability.id+%3D+156803+and+(type+%3D+%22applybuff%22+or+type+%3D+%22removebuff%22)&fight=11
		--https://www.warcraftlogs.com/reports/6bF47HT9hN3Xcj2n#view=events&pins=2%24Off%24%23244F4B%24expression%24ability.id+%3D+172747+and+type+%3D+%22begincast%22+or+ability.id+%3D+156803+and+(type+%3D+%22applybuff%22+or+type+%3D+%22removebuff%22)&fight=40
		local frostRemaining = timerExpelMagicFrostCD:GetRemaining()
		if frostRemaining > 0 then--Basically, a 0 0 check.
			timerExpelMagicFrostCD:Start(frostRemaining+23)--Not perfect. It's every 60 seconds exacty, unless delayed by shield phase, then it's remaining+24-27
		end
		--Shadow https://www.warcraftlogs.com/reports/kDzfJ812QZgpwa9h#view=events&pins=2%24Off%24%23244F4B%24expression%24ability.id+%3D+162184+and+type+%3D+%22begincast%22+or+ability.id+%3D+156803+and+(type+%3D+%22applybuff%22+or+type+%3D+%22removebuff%22)&fight=1
		local shadowRemaining = timerExpelMagicShadowCD:GetRemaining()
		if shadowRemaining > 0 then--Basically, a 0 0 check.
			timerExpelMagicShadowCD:Start(shadowRemaining+27)--Note the difference, shadow is +27-30 not +23-26
		end
		--Arcane https://www.warcraftlogs.com/reports/kDzfJ812QZgpwa9h#view=events&pins=2%24Off%24%23244F4B%24expression%24ability.id+%3D+162186+and+type+%3D+%22applydebuff%22+or+ability.id+%3D+156803+and+(type+%3D+%22applybuff%22+or+type+%3D+%22removebuff%22)&fight=9
		local arcaneRemaining = timerExpelMagicArcaneCD:GetRemaining()
		if arcaneRemaining > 0 then--Basically, a 0 0 check.
			timerExpelMagicArcaneCD:Start(arcaneRemaining+27)--Note the difference, shadow is +27-30 not +23-26
		end
		--Fire https://www.warcraftlogs.com/reports/kDzfJ812QZgpwa9h#view=events&pins=2%24Off%24%23244F4B%24expression%24ability.id+%3D+162185+and+type+%3D+%22begincast%22+or+ability.id+%3D+156803+and+(type+%3D+%22applybuff%22+or+type+%3D+%22removebuff%22)&fight=12
		--https://www.warcraftlogs.com/reports/Wj4MnfLQ8t3HzFgy#fight=10&type=summary&view=events&pins=2%24Off%24%23244F4B%24expression%24ability.id+%3D+162185+and+type+%3D+%22begincast%22+or+ability.id+%3D+156803+and+(type+%3D+%22applybuff%22+or+type+%3D+%22removebuff%22)
		local fireRemaining = timerExpelMagicFireCD:GetRemaining()
		if fireRemaining > 0 then--Basically, a 0 0 check.
			timerExpelMagicFireCD:Start(fireRemaining+27)--Note the difference, shadow is +27-30 not +23-26
		end
		--Balls
		local ballsRemaining = timerBallsCD:GetRemaining(self.vb.ballsCount+1)
		if ballsRemaining == 0 then
			DBM:Debug("Koragh lost his balls?")--Should not happen, but just in case, i want to see when it does clearly
			return
		end
		--http://worldoflogs.com/reports/umazvvirdsanfg8a/xe/?s=11657&e=12290&x=spell+%3D+%22Overflowing+Energy%22+or+spellid+%3D+156803&page=1
		if ballsRemaining > 5 then--If 5 seconds or less on timer, balls are already falling and will not be delayed. If remaining >5 it'll be delayed by 20 seconds (entirety of charge phase)
			timerBallsCD:Stop()
			timerBallsCD:Start(ballsRemaining+23, self.vb.ballsCount+1)
			specWarnBallsSoon:Cancel()
			self:Unschedule(ballsWarning)
			self:Unschedule(checkBossForgot)--Cancel check boss forgot
			self:Schedule(ballsRemaining+16.5, ballsWarning, self)
			self:Schedule(ballsRemaining+33, checkBossForgot, self)--Fire checkbossForgot 5 seconds after raid should have soaked or taken damage
			DBM:Debug("timerBallsCD is extending by 23 seconds due to shield phase")
		else
			DBM:Debug("remaining less than 5, no action taken")
		end	
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg, _, _, _, target)
	if msg:find(L.supressionTarget1) or msg:find(L.supressionTarget2) or msg:find(L.supressionTarget3) or msg:find(L.supressionTarget4) then
		self:SendSync("ChargeTo", target)--Sync since we have poor language support for many languages.
	end
end

function mod:OnSync(msg, targetname)
	if not self:IsInCombat() then return end
	if msg == "ChargeTo" and targetname and not self.vb.shieldCharging then
		timerTrampleCD:Start()
		local target = DBM:GetUnitFullName(targetname)
		if target and self:AntiSpam(3, target) then--Syncs sending from same realm don't send realm name, while other realms do, so it bypasses sync spam code since two diff args. So filter here after GetUnitFullName
			warnTrample:Show(target)
			if target == UnitName("player") then
				specWarnTrample:Show()
				yellTrample:Yell()
				specWarnTrample:Play("runaway")
			elseif self:CheckNearby(10, target) then
				specWarnTrampleNear:Show(target)
			end
		end
	--There no Overflowing Energy for 81 second, this should never happen. What happened? CLEU range? (I think range issue is impossible. No player is out of range during playing rest druid. And the room is not enough large to occur CLEU issue.)
	--12/26 22:11:41.504  SPELL_DAMAGE,Vehicle-0-3152-1228-6882-79015-00001D58EE,"Koragh",0x10a48,0x0,Player-2110-056C48C0,"__",0x514,0x0,161576,"Overflowing Energy",0x40,0000000000000000,0,0,0,0,0,0,0,0,0.00,0.00,0,16512,-1,64,0,0,7914,nil,nil,nil,nil <-- Soak failure
	--12/26 22:12:03.793  SPELL_AURA_REMOVED,Vehicle-0-3152-1228-6882-79015-00001D58EE,"Koragh",0xa48,0x0,Vehicle-0-3152-1228-6882-79015-00001D58EE,"Koragh",0xa48,0x0,156803,"Nullification Barrier",0x1,BUFF,0,0 <---- Shield Phase Start
	--12/26 22:12:34.340  SPELL_CAST_SUCCESS,Vehicle-0-3152-1228-6882-79015-00001D58EE,"Koragh",0xa48,0x0,Player-2110-057062D7,"___",0x512,0x0,161612,"Overflowing Energy",0x40,0000000000000000,0,0,0,0,0,0,0,0,0.00,0.00,0 <-- Soak happens (30 + 22.5 sec. correct)
	--12/26 22:13:04.340  -- Expected to fall ball, but nothing.
	--12/26 22:13:11.402  SPELL_AURA_REMOVED,Vehicle-0-3152-1228-6882-79015-00001D58EE,"Koragh",0xa48,0x0,Vehicle-0-3152-1228-6882-79015-00001D58EE,"Koragh",0xa48,0x0,156803,"Nullification Barrier",0x1,BUFF,0,0 <---- Shield Phase Start
	--12/26 22:13:55.372  SPELL_CAST_SUCCESS,Vehicle-0-3152-1228-6882-79015-00001D58EE,"Koragh",0xa48,0x0,Player-2110-057062D7,"___",0x512,0x0,161612,"Overflowing Energy",0x40,0000000000000000,0,0,0,0,0,0,0,0,0.00,0.00,0 <-- Soak happens (51 sec after failure occurs)
	elseif msg == "Ball" then
		DBM:Debug("Balls hit or were soaked checkBossForgot should be unscheduling, if checkBossForgot fires in 10 seconds, something is wrong with self:Unschedule")
		self.vb.ballsCount = self.vb.ballsCount + 1
		self:Unschedule(ballsWarning)
		self:Unschedule(checkBossForgot)
		timerBallsCD:Stop()--Sometimes balls still hit even with > 5-6 seconds, cancel timers an count
		local timer
		if self.vb.shieldCharging then
			timer = 52
			DBM:Debug("timerBallsCD started during shield charging, 52.5 second timer started")
		else
			timer = 30
			DBM:Debug("timerBallsCD started in regular phase, 30 second timer started")
		end
		warnBallsHit:Show(self.vb.ballsCount)
		timerBallsCD:Start(timer, self.vb.ballsCount+1)
		self:Schedule(timer-6.5, ballsWarning, self)
		self:Schedule(timer+10, checkBossForgot, self)--Fire checkbossForgot 10 seconds after raid should have soaked or taken damage
	end
end
