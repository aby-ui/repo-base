local mod	= DBM:NewMod(1903, "DBM-TombofSargeras", nil, 875)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220116041824")
mod:SetCreatureID(118523, 118374, 118518)--118523 Huntress kasparian, 118374 Captain Yathae Moonstrike, 118518 Prestess Lunaspyre
mod:SetEncounterID(2050)
--mod:SetBossHPInfoToHighest()
--mod:SetUsedIcons(1)
mod:SetHotfixNoticeRev(16282)
mod.respawnTime = 14

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 236442 236712 239379",
	"SPELL_CAST_SUCCESS 236694 236547 236518 233263 237561 236672 239264 236442",
	"SPELL_AURA_APPLIED 234995 234996 236550 236596 233264 233263 236712 239264 236519 237561 236305 243262",
	"SPELL_AURA_APPLIED_DOSE 234995 234996 239264",
	"SPELL_AURA_REMOVED 236712 233263 236305",
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
--	"CHAT_MSG_RAID_BOSS_EMOTE",
	"UNIT_SPELLCAST_SUCCEEDED boss1 boss2 boss3"
)

--[[
(ability.id = 236694 or ability.id = 236442 or ability.id = 239379 or ability.id = 236712) and type = "begincast" or
(ability.id = 237561 or ability.id = 236547 or ability.id = 236518 or ability.id = 233263 or ability.id = 239264 or ability.id = 236672) and type = "cast" or
(ability.id = 236305) and type = "applydebuff"
--]]
--Huntress Kasparian
--local warnTwilightGlaive			= mod:NewTargetAnnounce(237561, 3)
--Captain Yathae Moonstrike
local warnPhase2					= mod:NewPhaseAnnounce(2, 2, nil, nil, nil, nil, nil, 2)
--local warnIncorporealShot			= mod:NewTargetAnnounce(236305, 3)
local warnRapidShot					= mod:NewTargetAnnounce(236596, 3)
local warnTwilightVolley			= mod:NewTargetAnnounce(236442, 2)
--Priestess Lunaspyre
local warnPhase3					= mod:NewPhaseAnnounce(3, 2, nil, nil, nil, nil, nil, 2)
local warnLunarBeacon				= mod:NewTargetAnnounce(236712, 3)
local warnLunarFire					= mod:NewStackAnnounce(239264, 2, nil, "Tank")
local warnMoonBurn					= mod:NewTargetAnnounce(236519, 3)

--All
local specWarnFontofElune			= mod:NewSpecialWarningStack(236357, nil, 12, nil, 2, 1, 6)
local specWarnBerserk				= mod:NewSpecialWarningSpell(243262, nil, nil, nil, 3, 2)
--Huntress Kasparian
local specWarnGlaiveStorm			= mod:NewSpecialWarningDodge(239379, nil, nil, nil, 2, 2)
local specWarnTwilightGlaiveOther	= mod:NewSpecialWarningTarget(237561, nil, nil, nil, 2, 2)
local specWarnTwilightGlaive		= mod:NewSpecialWarningMoveAway(237561, nil, nil, nil, 2, 2)
local yellTwilightGlaive			= mod:NewYell(237561)
local specWarnDiscorporate			= mod:NewSpecialWarningMoveTo(236550, nil, nil, nil, 1, 7)
local specWarnDiscorporateSwap		= mod:NewSpecialWarningTaunt(236550, nil, nil, nil, 1, 2)
--Captain Yathae Moonstrike
local specWarnCallMoontalon			= mod:NewSpecialWarningSwitch(236694, "-Healer", nil, nil, 1, 2)
local specWarnTwilightVolley		= mod:NewSpecialWarningClose(236442, nil, nil, nil, 2, 2)
local specWarnTwilightVolleyYou		= mod:NewSpecialWarningYou(236442, nil, nil, nil, 1, 2)
local yellTwilightVolley			= mod:NewShortYell(236442)
local specWarnIncorpShot			= mod:NewSpecialWarningYou(236305, nil, nil, nil, 1, 2)
local yellIncorpShot				= mod:NewYell(236305)
local specWarnIncorpShotOther		= mod:NewSpecialWarningTarget(236305, nil, nil, nil, 1, 2)
local specWarnRapidShot				= mod:NewSpecialWarningYou(236596, nil, nil, nil, 1, 2)
local yellRapidShot					= mod:NewYell(236596, nil, false, 2)
--Priestess Lunaspyre
local specWarnEmbraceofEclipse		= mod:NewSpecialWarningTarget(233264, "Dps|Healer", nil, nil, 3)
local specWarnLunarBeacon			= mod:NewSpecialWarningMoveAway(236712, nil, nil, nil, 1, 2)
local yellLunarBeacon				= mod:NewFadesYell(236712)
local specWarnLunarFire				= mod:NewSpecialWarningStack(239264, nil, 2, nil, nil, 1, 2)
local specWarnLunarFireOther		= mod:NewSpecialWarningTaunt(239264, nil, nil, nil, 1, 2)
local specWarnMoonBurn				= mod:NewSpecialWarningMoveTo(236519, nil, DBM_CORE_L.AUTO_SPEC_WARN_OPTIONS.you:format(236519), nil, 1, 7)

--Huntress Kasparian
mod:AddTimerLine(DBM:EJ_GetSectionInfo(14992))
local timerGlaiveStormCD			= mod:NewNextCountTimer(54, 239379, nil, nil, nil, 3, nil, nil, nil, 1, 4)--Moon change special (but also used while inactive?)
--local timerTwilightGlaiveCD			= mod:NewCDTimer(7.5, 237561, nil, nil, nil, 3)--6.1-34
local timerMoonGlaiveCD				= mod:NewCDTimer(13.4, 236547, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON)--13.4-30 second variation, have fun with that
--Captain Yathae Moonstrike
mod:AddTimerLine(DBM:EJ_GetSectionInfo(14994))
local timerIncorporealShotCD		= mod:NewNextCountTimer(54, 236305, nil, nil, nil, 3, nil, nil, nil, 1, 4)--Moon change special (but also used while inactive?)
local timerCallMoontalonCD			= mod:NewCDTimer(31, 236694, nil, nil, nil, 1)
local timerTwilightVolleyCD			= mod:NewCDTimer(12.8, 236442, nil, nil, nil, 2)--Cast while inactive. 8.5--20
local timerRapidShotCD				= mod:NewCDTimer(18.2, 236596, nil, nil, nil, 3)--18.2 but sometimes 30
--Priestess Lunaspyre
mod:AddTimerLine(DBM:EJ_GetSectionInfo(14997))
local timerEmbraceofEclipseCD		= mod:NewNextCountTimer(54, 233264, nil, nil, nil, 5, nil, DBM_COMMON_L.HEALER_ICON..DBM_COMMON_L.DAMAGE_ICON, nil, 1, 4)--Moon change special (but also used while inactive in phase 1)
local timerLunarBeaconCD			= mod:NewCDTimer(20.6, 236712, nil, nil, nil, 3)--20.6-31.7
local timerLunarFireCD				= mod:NewCDTimer(11, 239264, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON)
local timerMoonBurnCD				= mod:NewCDTimer(23, 236519, nil, nil, nil, 3)--Used while inactive

local berserkTimer					= mod:NewBerserkTimer(660)

mod:AddSetIconOption("SetIconOnIncorpShot", 236305, true)
mod:AddInfoFrameOption(233263, true)
--mod:AddRangeFrameOption("5/8/15")

mod.vb.phase = 1
mod.vb.twilightGlaiveCount = 0
mod.vb.eclipseCount = 0
mod.vb.beaconCount = 0
mod.vb.moonTalonCount = 0
mod.vb.pulltime = 0
mod.vb.specialCount = 0
mod.vb.lastBeacon = false
local astralPurge = DBM:GetSpellInfo(234998)

function mod:VolleyTarget(targetname, uId)
	if not targetname then return end
	if targetname == UnitName("player") then
		specWarnTwilightVolleyYou:Show()
		specWarnTwilightVolleyYou:Play("runaway")
		yellTwilightVolley:Yell()
	elseif self:CheckNearby(10, targetname) then
		specWarnTwilightVolley:Show(targetname)
		specWarnTwilightVolley:Play("watchstep")
	else
		warnTwilightVolley:Show(targetname)
	end
end

function mod:BeaconTarget(targetname, uId)
	if not targetname then return end
	self.vb.lastBeacon = true
	if targetname == UnitName("player") then
		specWarnLunarBeacon:Show()
		specWarnLunarBeacon:Play("runout")
	else
		warnLunarBeacon:Show(targetname)
	end
end

--P1 Easy: Incorp Shot (P1 Heroic, Incorp and elcipse)
--P2 Easy: Eclipse (PS heroic, Eclipse and Glaives)
--P3 Eass: Glaives (PS heroic Glaives and Incorp)
function mod:OnCombatStart(delay)
	self.vb.phase = 1
	self.vb.twilightGlaiveCount = 0
	self.vb.eclipseCount = 0
	self.vb.beaconCount = 0
	self.vb.moonTalonCount = 0
	self.vb.specialCount = 0
	self.vb.pulltime = GetTime()
	timerMoonBurnCD:Start(9.1-delay)
	timerMoonGlaiveCD:Start(14.4-delay)--16.6 on lat mythic test
	timerTwilightVolleyCD:Start(15.5-delay)--15.5-17
	--timerTwilightGlaiveCD:Start(17.4-delay)
	timerIncorporealShotCD:Start(48-delay, 1)--Primary in phase 1 in all modes
	if not self:IsEasy() then
		timerEmbraceofEclipseCD:Start(48-delay, 1)--Secondary special for heroic/mythic
		if self:IsMythic() then
			berserkTimer:Start()--11 min
		end
	end
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 236442 then
		self:BossTargetScannerAbort(args.sourceGUID, "VolleyTarget")
		self:ScheduleMethod(0.2, "BossTargetScanner", args.sourceGUID, "VolleyTarget", 0.1, 9, true, nil, nil, nil, true)
	elseif spellId == 236712 then
		self.vb.beaconCount = self.vb.beaconCount + 1
		timerLunarBeaconCD:Start(20.7)
		--["236712-Lunar Beacon"] = "pull:359.7, 31.7, 54.8, 23.1, 31.7, 23.1, 31.8, 21.9, 20.7, 29.2",
		self:ScheduleMethod(0.2, "BossTargetScanner", args.sourceGUID, "BeaconTarget", 0.1, 12, true, nil, nil, nil, true)
	elseif spellId == 239379 then
		specWarnGlaiveStorm:Show()
		specWarnGlaiveStorm:Play("watchstep")
		timerGlaiveStormCD:Start(nil, self.vb.specialCount+1)
		if self:AntiSpam(5, 2) then
			self.vb.specialCount = self.vb.specialCount + 1
			for i = 1, 3 do
				local unitGUID = UnitGUID("boss"..i)
				if unitGUID then
					self:BossTargetScannerAbort(unitGUID, "VolleyTarget")
				end
			end
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 236694 then
		self.vb.moonTalonCount = self.vb.moonTalonCount + 1
		specWarnCallMoontalon:Show()
		specWarnCallMoontalon:Play("killbigmob")
		if self.vb.moonTalonCount == 1 then
			local remaining = GetTime() - self.vb.pulltime
			timerCallMoontalonCD:Start(260-remaining)
		end
	elseif spellId == 237561 then--^^
		self.vb.twilightGlaiveCount = self.vb.twilightGlaiveCount + 1
		--if self.vb.twilightGlaiveCount % 2 == 0 then
		--	timerTwilightGlaiveCD:Start(30)
		--else
			--timerTwilightGlaiveCD:Start(7.5)
		--end
		--["237561-Twilight Glaive"] = "pull:18.4, 18.3, 21.9, 20.7, 19.4, 34.0, 18.2, 24.4, 20.7, 26.7, 7.3",
		--["237561-Twilight Glaive"] = "pull:18.5, 18.2, 22.0, 19.1, 19.9, 34.9, 13.8, 22.0, 8.6, 20.7, 25.6, 7.3",
		--["237561-Twilight Glaive"] = "pull:18.6, 18.3, 21.8, 19.5, 18.2, 36.5, 23.1, 23.2, 20.7, 25.5, 7.3, 20.7, 25.5, 8.5, 20.6, 25.6, 8.5, 20.7, 26.8, 6.1, 19.5, 29.2, 7.3, 20.7, 26.8, 8.5, 20.7, 25.6, 8.5, 19.4, 26.7, 8.6, 20.5",
	elseif spellId == 236547 then
		timerMoonGlaiveCD:Start()
	elseif spellId == 236518 then
		if self.vb.phase == 3 then
			--timerMoonBurnCD:Start(16)--Not accurate in phase 3
		else
			timerMoonBurnCD:Start()
		end
	elseif spellId == 233263 then
		timerEmbraceofEclipseCD:Start(nil, self.vb.specialCount+1)
		if self:AntiSpam(5, 2) then
			self.vb.specialCount = self.vb.specialCount + 1
			for i = 1, 3 do
				local unitGUID = UnitGUID("boss"..i)
				if unitGUID then
					self:BossTargetScannerAbort(unitGUID, "VolleyTarget")
				end
			end
		end
	elseif spellId == 236672 then
		timerRapidShotCD:Start()
	elseif spellId == 239264 then
		timerLunarFireCD:Start()
	elseif spellId == 236442 then
		timerTwilightVolleyCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if (spellId == 234995 or spellId == 234996) and args:IsPlayer() then
		local amount = args.amount or 1
		if amount >= 12 and amount % 4 == 0 then
			specWarnFontofElune:Show(amount)
			if self:IsMythic() then
				specWarnFontofElune:Play("stackhigh")
			else
				specWarnFontofElune:Play("changemoon")
			end
		end
	elseif spellId == 239264 then
		local uId = DBM:GetRaidUnitId(args.destName)
		if self:IsTanking(uId) then
			local amount = args.amount or 1
			if amount >= 2 then--Lasts 30 seconds, unknown reapplication rate, fine tune!
				if args:IsPlayer() then--At this point the other tank SHOULD be clear.
					specWarnLunarFire:Show(amount)
					specWarnLunarFire:Play("stackhigh")
				else--Taunt as soon as stacks are clear, regardless of stack count.
					if not UnitIsDeadOrGhost("player") and not DBM:UnitDebuff("player", args.spellName) then
						specWarnLunarFireOther:Show(args.destName)
						specWarnLunarFireOther:Play("tauntboss")
					else
						warnLunarFire:Show(args.destName, amount)
					end
				end
			else
				warnLunarFire:Show(args.destName, amount)
			end
		end
	elseif spellId == 236550 then
		local uId = DBM:GetRaidUnitId(args.destName)
		if self:IsTanking(uId) then
			if args:IsPlayer() then
				specWarnDiscorporate:Show(astralPurge)
				specWarnDiscorporate:Play("changemoon")
			else
				specWarnDiscorporateSwap:Show(args.destName)
				specWarnDiscorporateSwap:Play("tauntboss")
			end
		end
	elseif spellId == 236596 then
		if args:IsPlayer() then
			specWarnRapidShot:Show()
			specWarnRapidShot:Play("targetyou")
			yellRapidShot:Yell()
		else
			warnRapidShot:Show(args.destName)
		end
	elseif spellId == 236305 then
		if self:AntiSpam(5, 3) then
			timerIncorporealShotCD:Start(nil, self.vb.specialCount+1)
		end
		if args:IsPlayer() then
			specWarnIncorpShot:Show()
			specWarnIncorpShot:Play("targetyou")
			yellIncorpShot:Yell()
		else
			specWarnIncorpShotOther:Show(args.destName)
			specWarnIncorpShotOther:Play("helpsoak")
		end
		if self.Options.SetIconOnIncorpShot then
			self:SetIcon(args.destName, 1)
		end
		if self:AntiSpam(5, 2) then
			self.vb.specialCount = self.vb.specialCount + 1
			for i = 1, 3 do
				local unitGUID = UnitGUID("boss"..i)
				if unitGUID then
					self:BossTargetScannerAbort(unitGUID, "VolleyTarget")
				end
			end
		end
	elseif spellId == 233264 then--Dpser Embrace of the Eclipse
		if not self:IsHealer() then
			specWarnEmbraceofEclipse:Show(args.destName)
			--specWarnEmbraceofEclipse:Play("targetchange")
		end
	elseif spellId == 233263 then--Healer Embrace of the Eclipse
		self.vb.eclipseCount = self.vb.eclipseCount + 1
		if self:IsHealer() then
			if self:AntiSpam(3, 1) then
				specWarnEmbraceofEclipse:Show(ALL)
				specWarnEmbraceofEclipse:Play("healall")
			end
		end
		if self.Options.InfoFrame and not DBM.InfoFrame:IsShown() then
			DBM.InfoFrame:SetHeader(args.spellName)
			DBM.InfoFrame:Show(6, "playerabsorb", args.spellName, select(16, DBM:UnitDebuff(args.destName, args.spellName)))
		end
	elseif spellId == 236712 then
		if args:IsPlayer() then
			if not self.vb.lastBeacon then
				specWarnLunarBeacon:Show()
				specWarnLunarBeacon:Play("runout")
			end
			yellLunarBeacon:Countdown(6)
		else
			if not self.vb.lastBeacon then
				warnLunarBeacon:Show(args.destName)
			end
		end
		self.vb.lastBeacon = false
	elseif spellId == 236519 then
		warnMoonBurn:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			specWarnMoonBurn:Show(astralPurge)
			specWarnMoonBurn:Play("changemoon")
		end
	elseif spellId == 237561 then
		if args:IsPlayer() then
			specWarnTwilightGlaive:Show()
			specWarnTwilightGlaive:Play("runout")
			yellTwilightGlaive:Yell()
		else
			specWarnTwilightGlaiveOther:Show(args.destName)
			specWarnTwilightGlaiveOther:Play("farfromline")
		end
	elseif spellId == 243262 and self:AntiSpam(3, 4) then
		specWarnBerserk:Show()
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 236712 and args:IsPlayer() then
		yellLunarBeacon:Cancel()
	elseif spellId == 233263 then
		self.vb.eclipseCount = self.vb.eclipseCount - 1
		if self.Options.InfoFrame and self.vb.eclipseCount == 0 then
			DBM.InfoFrame:Hide()
		end
	elseif spellId == 236305 then
		if self.Options.SetIconOnIncorpShot then
			self:SetIcon(args.destName, 1)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	--"<177.28 17:55:28> [UNIT_SPELLCAST_SUCCEEDED] Huntress Kasparian(Omegal) [[boss1:Captain Yathae Becomes Active Conversation::3-2083-1676-9420-243044-0023448060:243044]]", -- [3688]
	--"<177.62 17:55:28> [CHAT_MSG_MONSTER_SAY] No more dawdling, Kasparian! Victory shall be mine!#Captain Yathae Moonstrike###Omegal##0#0##0#451#nil#0#false#false#false#false", -- [3698]
	if spellId == 243044 then--Captain Yathae Becomes Active Conversation (Phase 2)
		self.vb.phase = 2
		local elapsedMoon, totalMoon = timerIncorporealShotCD:GetTime()--Grab current special from phase 1 special timer first
		warnPhase2:Show()
		warnPhase2:Play("ptwo")
		timerMoonGlaiveCD:Stop()
		timerTwilightVolleyCD:Stop()
		--timerTwilightGlaiveCD:Stop()
		timerIncorporealShotCD:Stop()--Stop Phase 1 special timer
		timerCallMoontalonCD:Start(8)
		--timerTwilightGlaiveCD:Start(6)
		timerTwilightVolleyCD:Start(10.9)
		timerRapidShotCD:Start(15.8)--Review
		--Phase 2 ability: Eclipse. Next phase ability used on heroic+: Glaive
		if self:IsEasy() then--Eclipse starts
			timerEmbraceofEclipseCD:Update(elapsedMoon, totalMoon)
		else--eclipse already running and glaive starts
			timerGlaiveStormCD:Update(elapsedMoon, totalMoon)
		end
	elseif spellId == 243047 then--Lunaspyre Becomes Active Conversation (Phase 3)
		self.vb.phase = 3
		local elapsedMoon, totalMoon = timerEmbraceofEclipseCD:GetTime()--Grab current special from phase 2 special timer first
		warnPhase3:Show()
		warnPhase3:Play("pthree")
		timerRapidShotCD:Stop()
		timerTwilightVolleyCD:Stop()
		timerEmbraceofEclipseCD:Stop()--Stop phase 2 Special timer
		timerMoonBurnCD:Stop()
		timerCallMoontalonCD:Stop()
		--timerTwilightGlaiveCD:Stop()
		--timerTwilightGlaiveCD:Start(3)
		timerLunarFireCD:Start(6)
		timerMoonBurnCD:Start(11)
		timerTwilightVolleyCD:Start(15.8)
		timerLunarBeaconCD:Start(18)
		--Phase 3 ability: Glaive. Next phase ability used on heroic+ (rolled around to phase 1): Incorpereal Shot
		if self:IsEasy() then--Glaive starts
			timerGlaiveStormCD:Update(elapsedMoon, totalMoon)
		else
			timerIncorporealShotCD:Update(elapsedMoon, totalMoon)
		end
	elseif spellId == 61207 then--Sets all internal CDs back to 7 seconds
		DBM:Debug("7 second internal CD activated")
		for i = 1, 3 do
			local unitGUID = UnitGUID("boss"..i)
			if unitGUID then
				self:BossTargetScannerAbort(unitGUID, "VolleyTarget")
			end
		end
		local elapsedVolley, totalVolley = timerTwilightVolleyCD:GetTime()
		local remaining = totalVolley - elapsedVolley
		local extend = 7 - (totalVolley-elapsedVolley)
		if totalVolley == 0 then
			DBM:Debug("7 second timerTwilightVolleyCD started", 2)
			timerTwilightVolleyCD:Start(7)
		elseif remaining < 7 then
			DBM:Debug(extend.." second timerTwilightVolleyCD extend activated", 2)
			timerTwilightVolleyCD:Update(elapsedVolley, totalVolley+extend)
		end
	end
end

