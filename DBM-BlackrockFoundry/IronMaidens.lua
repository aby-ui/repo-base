local mod	= DBM:NewMod(1203, "DBM-BlackrockFoundry", nil, 457)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143352")
mod:SetCreatureID(77557, 77231, 77477)
mod:SetEncounterID(1695)
mod:SetZone()
mod:SetBossHPInfoToHighest()
mod:SetUsedIcons(5, 4, 3, 2, 1)
--mod:SetModelSound("sound\\creature\\marak\\vo_60_ironmaidens_marak_08.ogg", "sound\\creature\\marak\\vo_60_ironmaidens_marak_08.ogg")
mod.respawnTime = 29.5

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 158708 158707 158692 158599 155794 158078 156626 158008 156109",
	"SPELL_CAST_SUCCESS 157854 157886 156109 155794",
	"SPELL_AURA_APPLIED 158702 164271 156214 158315 158010 159724 156631 156601",
	"SPELL_AURA_REMOVED 159724 156631 158010",
	"SPELL_PERIODIC_DAMAGE 158683",
	"SPELL_ABSORBED 158683",
	"UNIT_DIED",
	"RAID_BOSS_WHISPER",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"CHAT_MSG_MONSTER_YELL",
	"CHAT_MSG_ADDON",
	"UNIT_SPELLCAST_SUCCEEDED boss1 boss2 boss3",
	"UNIT_POWER_FREQUENT boss1 boss2 boss3"
)

local Ship	= DBM:EJ_GetSectionInfo(10019)
local Marak = DBM:EJ_GetSectionInfo(10033)
local Sorka = DBM:EJ_GetSectionInfo(10030)
local Garan = DBM:EJ_GetSectionInfo(10025)

--(ability.id = 158078 or ability.id = 156626 or ability.id = 155794 or ability.id = 158008 or ability.id = 156109) and type = "begincast" or ability.id = 164271 and type = "cast" or ability.name = "Sabotage"
--Ship
local warnPhase2						= mod:NewPhaseAnnounce(2, 2, nil, nil, nil, nil, nil, 2)
local warnShip							= mod:NewTargetAnnounce("ej10019", 3, 76204, nil, nil, nil, nil, 2)
local warnBombardmentAlpha				= mod:NewCountAnnounce(157854, 3)--From ship, but affects NON ship.
----Blackrock Deckhand
local warnProtectiveEarth				= mod:NewSpellAnnounce(158707, 3, nil, false, 2)--Could not verify
----Shattered Hand Deckhand
local warnFixate						= mod:NewTargetAnnounce(158702, 3, nil, false, 2)--extremely spammy
--Ground
----Admiral Gar'an
local warnRapidFire						= mod:NewTargetCountAnnounce(156631, 4)
local warnPenetratingShot				= mod:NewTargetCountAnnounce(164271, 3)
----Enforcer Sorka
local warnBladeDash						= mod:NewTargetCountAnnounce(155794, 3, nil, "Ranged|Tank")
local warnConvulsiveShadows				= mod:NewTargetCountAnnounce(156214, 3, nil, "Healer")
local warnDarkHunt						= mod:NewTargetCountAnnounce(158315, 4, nil, "Healer")
----Marak the Blooded
local warnBloodRitual					= mod:NewTargetCountAnnounce(158078, 3)
local warnBloodsoakedHeartseeker		= mod:NewTargetCountAnnounce(158010, 4, nil, "Healer")
local warnSanguineStrikes				= mod:NewTargetAnnounce(156601, 3, nil, "Healer")

--Ship
local specWarnBombardmentOmega			= mod:NewSpecialWarningCount(157886, nil, nil, nil, 3)--From ship, but affects NON ship.
local specWarnReturnBase				= mod:NewSpecialWarning("specWarnReturnBase")
local specWarnBoatEnded					= mod:NewSpecialWarningEnd("ej10019")
----Blackrock Deckhand
local specWarnEarthenbarrier			= mod:NewSpecialWarningInterrupt(158708, "-Healer", nil, 2, nil, 2)
----Shattered Hand Deckhand
local specWarnDeadlyThrow				= mod:NewSpecialWarningSpell(158692, "Tank")
local specWarnFixate					= mod:NewSpecialWarningYou(158702)
----Bleeding Hollow Deckhand
local specWarnCorruptedBlood			= mod:NewSpecialWarningMove(158683)
--Ground
----Admiral Gar'an
local specWarnRapidFire					= mod:NewSpecialWarningRun(156631, nil, nil, nil, 4, 2)
local yellRapidFire						= mod:NewYell(156631)
local specWarnRapidFireNear				= mod:NewSpecialWarningClose(156631, false, nil, nil, 1, 2)
local specWarnPenetratingShot			= mod:NewSpecialWarningYou(164271, nil, nil, nil, 1, 2)
local specWarnPenetratingShotOther		= mod:NewSpecialWarningTargetCount(164271, false)
local yellPenetratingShot				= mod:NewYell(164271)
local specWarnDeployTurret				= mod:NewSpecialWarningSwitch(158599, "RangedDps", nil, 3, 3, 2)--Switch warning since most need to switch and kill, but on for EVERYONE because tanks/healers need to avoid it while it's up
----Enforcer Sorka
local specWarnBladeDash					= mod:NewSpecialWarningYou(155794, nil, nil, nil, 1, 2)
local specWarnBladeDashOther			= mod:NewSpecialWarningClose(155794, nil, nil, nil, 1, 2)
local specWarnConvulsiveShadows			= mod:NewSpecialWarningMoveAway(156214, nil, nil, nil, 1, 2)--Does this still drop lingering shadows, if not moveaway is not appropriate
local specWarnConvulsiveShadowsOther	= mod:NewSpecialWarningTargetCount(156214, false)
local yellConvulsiveShadows				= mod:NewYell(156214, nil, false)
local specWarnDarkHunt					= mod:NewSpecialWarningYou(158315, nil, nil, nil, 1, 2)
local specWarnDarkHuntOther				= mod:NewSpecialWarningTarget(158315, false)--Healer may want this, or raid leader
----Marak the Blooded
local specWarnBloodRitual				= mod:NewSpecialWarningYou(158078, nil, nil, nil, 1, 2)
local specWarnBloodRitualOther			= mod:NewSpecialWarningTargetCount(158078, "Tank", nil, nil, 1, 2)
local yellBloodRitual					= mod:NewYell(158078)
local specWarnBloodsoakedHeartseeker	= mod:NewSpecialWarningRun(158010, nil, nil, nil, 4, 2)
local yellHeartseeker					= mod:NewYell(158010, nil, false)

--Ship
mod:AddTimerLine(Ship)
local timerShipCD						= mod:NewNextCountTimer(198, "ej10019", nil, nil, nil, 6, 76204, nil, nil, 1, 5)
local timerBombardmentAlphaCD			= mod:NewNextTimer(18, 157854, nil, nil, nil, 2, nil, DBM_CORE_DEADLY_ICON)
local timerWarmingUp					= mod:NewCastTimer(90, 158849, nil, nil, nil, 6, nil, nil, nil, 1, 5)
--Ground
----Admiral Gar'an
mod:AddTimerLine(Garan)
local timerRapidFireCD					= mod:NewCDTimer(30, 156626, nil, nil, nil, 3)
local timerDarkHuntCD					= mod:NewCDCountTimer(13.5, 158315, nil, false, nil, 3)--Important to know you have it, not very important to know it's coming soon.
local timerPenetratingShotCD			= mod:NewCDCountTimer(28.8, 164271, nil, nil, nil, 3)--22-30 at least. maybe larger variation.
local timerDeployTurretCD				= mod:NewCDCountTimer(20.2, 158599, nil, nil, nil, 1, nil, DBM_CORE_DAMAGE_ICON)--20.2-23.5
----Enforcer Sorka
mod:AddTimerLine(Sorka)
local timerBladeDashCD					= mod:NewCDCountTimer(20, 155794, nil, "Ranged|Tank", nil, 5, nil, DBM_CORE_TANK_ICON, nil, mod:IsTank() and 3, 4)
local timerConvulsiveShadowsCD			= mod:NewNextCountTimer(55.6, 156214, nil, nil, nil, 3)--Timer only enabled on mythic, On non mythic, it's just an unimportant dot. On mythic, MUCH more important because user has to run out of raid and get dispelled.
----Marak the Blooded
mod:AddTimerLine(Marak)
local timerBloodRitualCD				= mod:NewCDCountTimer(20, 158078, nil, nil, nil, 5, nil, DBM_CORE_TANK_ICON, nil, mod:IsTank() and 2, 4)
local timerHeartSeekerCD				= mod:NewCDCountTimer(70, 158010, nil, "Ranged", nil, 3)

mod:AddSetIconOption("SetIconOnRapidFire", 156626, true)
mod:AddSetIconOption("SetIconOnBloodRitual", 158078, true)
mod:AddSetIconOption("SetIconOnHeartSeeker", 158010, true)
mod:AddHudMapOption("HudMapOnRapidFire", 156631)--Yellow markers
mod:AddHudMapOption("HudMapOnBloodRitual", 158078)--Red markers
mod:AddBoolOption("filterBladeDash3", false)
mod:AddBoolOption("filterBloodRitual3", false)

mod.vb.phase = 1
mod.vb.ship = 0
mod.vb.alphaOmega = 0
mod.vb.bloodRitual = 0
mod.vb.bladeDash = 1
mod.vb.penetratingShot = 0
mod.vb.convulsiveShadows = 0
mod.vb.heartseeker = 0
mod.vb.darkHunt = 0
mod.vb.turret = 0
mod.vb.rapidfire = 0
mod.vb.shadowsWarned = false
mod.vb.boatMissionActive = false
mod.vb.lastBoatPower = 0
local preyDebuff, bloodcallingDebuff = DBM:GetSpellInfo(170395), DBM:GetSpellInfo(170405)

local playerOnBoat = false

--For canceling timers if player is on boat team, timers will return when they get off boat
local function checkBoatOn(self, count)
	if UnitInVehicle("player") then--Returns true when on the hook/transport
		playerOnBoat = true
		timerBloodRitualCD:Stop()
		timerRapidFireCD:Stop()
		timerBladeDashCD:Stop()
		timerHeartSeekerCD:Stop()
		timerConvulsiveShadowsCD:Stop()
		timerPenetratingShotCD:Stop()
		timerBombardmentAlphaCD:Stop()
		DBM:Debug("Player Entering Boat")
	elseif count < 20 then
		self:Schedule(1, checkBoatOn, self, count + 1)
	end
end

function mod:ConvulsiveTarget(targetname, uId)
	if not targetname then return end
	self.vb.shadowsWarned = true
	local noFilter = false
	if not DBM.Options.DontShowFarWarnings then
		noFilter = true
	end
	if (noFilter or not playerOnBoat) then
		if self.Options.SpecWarn156214target then
			specWarnConvulsiveShadowsOther:Show(self.vb.convulsiveShadows, targetname)
		else
			warnConvulsiveShadows:Show(self.vb.convulsiveShadows, targetname)--Combined because a bad lingeringshadows drop may have multiple.
		end
		if self:IsMythic() and targetname == UnitName("player") then
			specWarnConvulsiveShadows:Show()
			yellConvulsiveShadows:Yell()
			specWarnConvulsiveShadows:Play("runaway")
		end
	end
end

function mod:BladeDashTarget(targetname, uId)
	if self:IsMythic() and self:AntiSpam(5, 3) then
		if targetname == UnitName("player") then
			if DBM:UnitDebuff("player", preyDebuff) and self.Options.filterBladeDash3 then return end
			specWarnBladeDash:Show()
			specWarnBladeDash:Play("targetyou")
		elseif self:CheckNearby(8, targetname) then
			specWarnBladeDashOther:Show(targetname)
			specWarnBladeDashOther:Play("runaway")
		else
			warnBladeDash:Show(self.vb.bladeDash, targetname)
		end
	end
end

function mod:OnCombatStart(delay)
	self.vb.phase = 1
	self.vb.ship = 0
	self.vb.alphaOmega = 1
	self.vb.bloodRitual = 0
	self.vb.bladeDash = 1
	self.vb.penetratingShot = 0
	self.vb.convulsiveShadows = 0
	self.vb.heartseeker = 0
	self.vb.darkHunt = 0
	self.vb.turret = 0
	self.vb.rapidfire = 0
	self.vb.boatMissionActive = false
	self.vb.lastBoatPower = 0
	playerOnBoat = false
	timerBladeDashCD:Start(8-delay, 1)
	timerBloodRitualCD:Start(12.4-delay, 1)
	timerRapidFireCD:Start(15.5-delay, 1)
	timerShipCD:Start(59.5-delay, 1)
	self:RegisterShortTermEvents(
		"UNIT_HEALTH_FREQUENT boss1 boss2 boss3"
	)
	DBM:AddMsg("Warning: This mod is completely and utterly broken with no proper way to detect boat phase ending or player location, both of which timers/other features HEAVILY replied upon")
end

function mod:OnCombatEnd()
	self:UnregisterShortTermEvents()
	if self.Options.HudMapOnRapidFire or self.Options.HudMapOnBloodRitual then
		DBMHudMap:Disable()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	local noFilter = false
	if not DBM.Options.DontShowFarWarnings then
		noFilter = true
	end
	if spellId == 158078 then
		self.vb.bloodRitual = self.vb.bloodRitual + 1
		if noFilter or not playerOnBoat then--Blood Ritual. Still safest way to start timer, in case no sync
			timerBloodRitualCD:Start(nil, self.vb.bloodRitual+1)
		end
	elseif spellId == 156626 then--Rapid Fire. Still safest way to start timer, in case no sync
		self.vb.rapidfire = self.vb.rapidfire + 1
		if noFilter or not playerOnBoat then
			timerRapidFireCD:Start(nil, self.vb.rapidfire+1)
		end
	elseif spellId == 158599 then
		self.vb.turret = self.vb.turret + 1
		if (noFilter or not playerOnBoat) then
			specWarnDeployTurret:Show()
			specWarnDeployTurret:Play("158599")
			timerDeployTurretCD:Start(nil, self.vb.turret+1)
		end
	elseif spellId == 155794 then
		if noFilter or not playerOnBoat then
			self:ScheduleMethod(0.1, "BossTargetScanner", 77231, "BladeDashTarget", 0.1, 16)
			timerBladeDashCD:Stop()
			timerBladeDashCD:Start(nil, self.vb.bladeDash+1)
		end
	elseif spellId == 158008 then
		self.vb.heartseeker = self.vb.heartseeker + 1
		if noFilter or not playerOnBoat then
			timerHeartSeekerCD:Start(nil, self.vb.heartseeker+1)
		end
	--Begin Deck Abilities
	elseif spellId == 158708 and (noFilter or playerOnBoat) then
		specWarnEarthenbarrier:Show(args.sourceName)
		specWarnEarthenbarrier:Play("kickcast")
	elseif spellId == 158707 and (noFilter or playerOnBoat) then
		warnProtectiveEarth:Show()
	elseif spellId == 158692 and (noFilter or playerOnBoat) then
		specWarnDeadlyThrow:Show()
	elseif spellId == 156109 then
		self.vb.shadowsWarned = false
		--This count will be off if target dies during cast and boss recasts.
		--However, unlike blade dash, it cannot be moved to success do to spread mechanic
		self.vb.convulsiveShadows = self.vb.convulsiveShadows + 1
		self:ScheduleMethod(0.1, "BossTargetScanner", 77231, "ConvulsiveTarget", 0.1, 13, true, nil, nil, nil, true)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	local noFilter = false
	if not DBM.Options.DontShowFarWarnings then
		noFilter = true
	end
	if spellId == 157854 then
		if noFilter or not playerOnBoat then
			warnBombardmentAlpha:Show(self.vb.alphaOmega)
			timerBombardmentAlphaCD:Start()
		end
	elseif spellId == 157886 and (noFilter or not playerOnBoat) then
		specWarnBombardmentOmega:Show(self.vb.alphaOmega)
		self.vb.alphaOmega = self.vb.alphaOmega + 1
	elseif spellId == 156109 and self:IsMythic() then
		if noFilter or not playerOnBoat then
			timerConvulsiveShadowsCD:Start(nil, self.vb.convulsiveShadows+1)
		end
	elseif spellId == 155794 then
		self.vb.bladeDash = self.vb.bladeDash + 1
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	local noFilter = false
	if not DBM.Options.DontShowFarWarnings then
		noFilter = true
	end
	if spellId == 164271 then
		self.vb.penetratingShot = self.vb.penetratingShot + 1
		if noFilter or not playerOnBoat then
			if self.Options.SpecWarn164271target then
				specWarnPenetratingShotOther:Show(self.vb.penetratingShot, args.destName)
			else
				warnPenetratingShot:Show(self.vb.penetratingShot, args.destName)
			end
			timerPenetratingShotCD:Start(nil, self.vb.penetratingShot+1)
			if args:IsPlayer() then
				specWarnPenetratingShot:Show()
				yellPenetratingShot:Yell()
				specWarnPenetratingShot:Play("gathershare")
			end
		end
	elseif spellId == 156214 and not self.vb.shadowsWarned and (noFilter or not playerOnBoat) then
		--Count not showed here because spreads aren't counted
		warnConvulsiveShadows:CombinedShow(0.5, args.destName)--Combined because a bad lingeringshadows drop may have multiple.
		if args:IsPlayer() and self:IsMythic() then
			specWarnConvulsiveShadows:Show()
			yellConvulsiveShadows:Yell()
			specWarnConvulsiveShadows:Play("runaway")
		end
	elseif spellId == 158315 then
		self.vb.darkHunt = self.vb.darkHunt + 1
		if (noFilter or not playerOnBoat) then
			if args:IsPlayer() then
				specWarnDarkHunt:ScheduleVoice(1.5, "defensive")
				specWarnDarkHunt:Show()
			else
				if self.Options.SpecWarn158315target then
					specWarnDarkHuntOther:Show(self.vb.darkHunt, args.destName)
				else
					warnDarkHunt:Show(self.vb.darkHunt, args.destName)
				end
			end
			timerDarkHuntCD:Start(nil, self.vb.darkHunt+1)
		end
	elseif spellId == 158010 then
		if self.Options.SetIconOnHeartSeeker and not self:IsLFR() then
			self:SetSortedIcon(1, args.destName, 3, 3)
		end
		if (noFilter or not playerOnBoat) then
			warnBloodsoakedHeartseeker:CombinedShow(0.5, self.vb.heartseeker, args.destName)
			if args:IsPlayer() then
				specWarnBloodsoakedHeartseeker:Show()
				yellHeartseeker:Yell()
				specWarnBloodsoakedHeartseeker:Play("scatter")
			end
		end
	elseif spellId == 159724 then
		if self.Options.SetIconOnBloodRitual and not self:IsLFR() then
			self:SetIcon(args.destName, 2)
		end
		if (noFilter or not playerOnBoat) then
			if self.Options.HudMapOnBloodRitual then
				DBMHudMap:RegisterRangeMarkerOnPartyMember(spellId, "highlight", args.destName, 3.5, 7, 1, 0, 0, 0.5, nil, true, 2):Pulse(0.5, 0.5)
			end
			if args:IsPlayer() then
				yellBloodRitual:Yell()
				if DBM:UnitDebuff("player", bloodcallingDebuff) and self.Options.filterBloodRitual3 then return end
				specWarnBloodRitual:Show()
				specWarnBloodRitual:Play("targetyou")
			else
				if self.Options.SpecWarn158078targetcount then
					specWarnBloodRitualOther:Show(self.vb.bloodRitual, args.destName)
					specWarnBloodRitualOther:Play("helpsoak")
				else
					warnBloodRitual:Show(self.vb.bloodRitual, args.destName)
				end
				specWarnBloodRitual:Play("farfromline")--Good sound fit for everyone ELSE
			end
		end
	elseif spellId == 156631 then
		if self:AntiSpam(5, args.destName) then--check antispam so we don't warn if we got a user sync 3 seconds ago.
			if self.Options.SetIconOnRapidFire and not self:IsLFR() then
				self:SetIcon(args.destName, 1, 7)
			end
			if (noFilter or not playerOnBoat) then
				if self:CheckNearby(5, args.destName) and self.Options.SpecWarn156631close then
					specWarnRapidFireNear:Show(args.destName)
					specWarnRapidFireNear:Play("runaway")
				else
					warnRapidFire:Show(self.vb.rapidfire, args.destName)
				end
				if self.Options.HudMapOnRapidFire then
					DBMHudMap:RegisterRangeMarkerOnPartyMember(spellId, "highlight", args.destName, 5, 9, 1, 1, 0, 0.5, nil, true, 1):Pulse(0.5, 0.5)
				end
			end
		end
	elseif spellId == 156601 then
		warnSanguineStrikes:Show(args.destName)
		--warnSanguineStrikes:Play("healall")
	--Begin Deck Abilities
	elseif spellId == 158702 and (noFilter or playerOnBoat) then
		warnFixate:CombinedShow(0.5, args.destName)
		if args:IsPlayer() and self:AntiSpam(3, 1) then--it spams sometimes
			specWarnFixate:Show()
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 159724 and self.Options.SetIconOnBloodRitual and not self:IsLFR() then
		self:SetIcon(args.destName, 0)
		if self.Options.HudMapOnBloodRitual then
			DBMHudMap:FreeEncounterMarkerByTarget(spellId, args.destName)
		end
	elseif spellId == 158010 and self.Options.SetIconOnHeartSeeker and not self:IsLFR() then
		self:SetIcon(args.destName, 0)
	elseif spellId == 156631 and self.Options.HudMapOnRapidFire then
		DBMHudMap:FreeEncounterMarkerByTarget(spellId, args.destName)
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 158683 and destGUID == UnitGUID("player") and self:AntiSpam(2, 2) then
		specWarnCorruptedBlood:Show()
	end
end
mod.SPELL_ABSORBED = mod.SPELL_PERIODIC_DAMAGE

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 77477 then--Marak
		timerBloodRitualCD:Stop()
		timerHeartSeekerCD:Stop()
	elseif cid == 77557 then--Gar'an
		timerRapidFireCD:Stop()
		timerPenetratingShotCD:Stop()
		timerDeployTurretCD:Stop()
	elseif cid == 77231 then--Sorka
		timerBladeDashCD:Stop()
		timerConvulsiveShadowsCD:Stop()
		timerDarkHuntCD:Stop()
	elseif cid == 78351 or cid == 78341 or cid == 78343 then--boat bosses
		--No longer used
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 158849 then
		timerWarmingUp:Start()
		--No emote trigger, backup
		if not self.vb.boatMissionActive then
			--self:Schedule(1, checkBoatOn, self, 1)
			local cid = self:GetUnitCreatureId(uId)
			self.vb.boatMissionActive = cid
			self.vb.lastBoatPower = 0
			--Timers that always cancel on mythic, regardless of boss going up
			if self:IsMythic() then
				timerBladeDashCD:Stop()
				timerBloodRitualCD:Stop()
				timerHeartSeekerCD:Stop()
			else--This cancels in all modes
				timerHeartSeekerCD:Stop()
			end
			if cid == 77477 then--Marak
				timerBloodRitualCD:Stop()
				warnShip:Play("1695ukurogg")
			elseif cid == 77231 then--Sorka
				timerBladeDashCD:Stop()
				timerConvulsiveShadowsCD:Stop()
				timerDarkHuntCD:Stop()
				warnShip:Play("1695gorak")
			elseif cid == 77557 then--Gar'an
				timerRapidFireCD:Stop()
				timerPenetratingShotCD:Stop()
				timerDeployTurretCD:Stop()
				warnShip:Play("1695uktar")
			end
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, npc)
	if msg:find(L.shipMessage) then
		self:Schedule(1, checkBoatOn, self, 1)
		self.vb.lastBoatPower = 0
		self.vb.ship = self.vb.ship + 1
		self.vb.alphaOmega = 1
		warnShip:Show(npc)
		if self.vb.ship < 3 then
			timerShipCD:Start(nil, self.vb.ship+1)
		end
		--Timers that always cancel on mythic, regardless of boss going up
		if self:IsMythic() then
			self:Schedule(3, function()
				timerBladeDashCD:Stop()
				timerBloodRitualCD:Stop()
				timerHeartSeekerCD:Stop()
			end)
		else--This cancels in all modes
			self:Schedule(3, function()
				timerHeartSeekerCD:Stop()
			end)
		end
		--Timers that always cancel on mythic, regardless of boss going up
		timerBombardmentAlphaCD:Start(14.5)
		if npc == Marak then
			self.vb.boatMissionActive = 77477
			self:Schedule(3, function()
				timerBloodRitualCD:Stop()
			end)
			warnShip:Play("1695ukurogg")
		elseif npc == Sorka then
			self.vb.boatMissionActive = 77231
			self:Schedule(3, function()
				timerBladeDashCD:Stop()
				timerConvulsiveShadowsCD:Stop()
				timerDarkHuntCD:Stop()
			end)
			warnShip:Play("1695gorak")
		elseif npc == Garan then
			self.vb.boatMissionActive = 77557
			self:Schedule(3, function()
				timerRapidFireCD:Stop()
				timerPenetratingShotCD:Stop()
				timerDeployTurretCD:Stop()
			end)
			warnShip:Play("1695uktar")
		end
	end
end

--"<9.87 23:50:29> [CHAT_MSG_MONSTER_YELL] CHAT_MSG_MONSTER_YELL#Too slow!#Enforcer Sorka###Etsi
--"<10.92 23:50:30> [DBM_Announce] DBM_Announce#Blade Dash on |r|cff9382c9Etsi|r|cffffb200 near you", -- [691]
function mod:CHAT_MSG_MONSTER_YELL(msg, npc, _, _, targetname)
	if msg:find(L.EarlyBladeDash) then
		if self:IsMythic() and self:AntiSpam(5, 3) then
			if targetname == UnitName("player") then
				if DBM:UnitDebuff("player", preyDebuff) and self.Options.filterBladeDash3 then return end
				specWarnBladeDash:Show()
			elseif self:CheckNearby(8, targetname) then
				specWarnBladeDashOther:Show(targetname)
			else
				warnBladeDash:Show(self.vb.bladeDash, targetname)
			end
		end
	end
end

--Rapid fire is still 3 seconds faster to use emote instead of debuff.
--Bigwigs doesn't sync Rapid Fire like DBM does, but they do sync ALL RAID_BOSS_WHISPER events.
--So we can this for rapidfire targets sent by both bigwigs and DBM
function mod:CHAT_MSG_ADDON(prefix, msg, channel, targetName)
	if prefix ~= "Transcriptor" then return end
	if msg:find("spell:156626") then--Rapid fire
		targetName = Ambiguate(targetName, "none")
		if self:AntiSpam(5, targetName) then--Set antispam if we got a sync, to block 3 second late SPELL_AURA_APPLIED if we got the early warning
			if self.Options.SetIconOnRapidFire and not self:IsLFR() then
				self:SetIcon(targetName, 1, 10)
			end
			if DBM.Options.DontShowFarWarnings and playerOnBoat then return end--Anything below this line doesn't concern people on boat
			if self:CheckNearby(5, targetName) and self.Options.SpecWarn156631close then
				specWarnRapidFireNear:Show(targetName)
				specWarnRapidFireNear:Play("runaway")
			else
				warnRapidFire:Show(self.vb.rapidfire, targetName)
			end
			if self.Options.HudMapOnRapidFire then
				DBMHudMap:RegisterRangeMarkerOnPartyMember(156631, "highlight", targetName, 5, 12, 1, 1, 0, 0.5, nil, true, 1):Pulse(0.5, 0.5)
			end
		end
	end
end

--Rapid fire is still 3 seconds faster to use emote instead of debuff.
function mod:RAID_BOSS_WHISPER(msg)
	if msg:find("spell:156626") then
		specWarnRapidFire:Show()
		yellRapidFire:Yell()
		specWarnRapidFire:Play("runout")
		specWarnRapidFire:ScheduleVoice(2, "keepmove")
	end
end

function mod:UNIT_HEALTH_FREQUENT(uId)
	local hp = UnitHealth(uId) / UnitHealthMax(uId)
	if hp < 0.20 and self.vb.phase ~= 2 then
		timerShipCD:Stop()
		self.vb.phase = 2
		warnPhase2:Show()
		warnPhase2:Play("ptwo")
		self:UnregisterShortTermEvents()
	end
end

function mod:UNIT_POWER_FREQUENT(uId, type)
	if type == "ALTERNATE" then
		if self.vb.boatMissionActive then
			local altPower = UnitPower(uId, 10)
			if altPower > self.vb.lastBoatPower then--Gaining power, someones on the boat
				self.vb.lastBoatPower = altPower
			elseif altPower < self.vb.lastBoatPower then--Power reset, boat phase ended
				DBM:Debug("checkBoatPlayer finished")
				timerBombardmentAlphaCD:Stop()
				timerWarmingUp:Stop()
				if playerOnBoat then -- leave boat
					playerOnBoat = false
					specWarnReturnBase:Show()
				else
					specWarnBoatEnded:Show()
				end
				self.vb.bladeDash = 1
				self.vb.bloodRitual = 0
				local bossPower = UnitPower("boss1")--All bosses have same power, doesn't matter which one checked
				--These abilites resume when boat phase ends with thes timers, they do NOT resume previous timers where they left off.
				timerBladeDashCD:Stop()
				timerBladeDashCD:Start(8, 1)
				timerBloodRitualCD:Stop()
				timerBloodRitualCD:Start(12.5, 1)--Variation on this may be same as penetrating shot variation. when it's marak returning from boat may be when it's 9.7
				--These are altered by boat ending, even though boss continues casting it during boat phases.
				timerRapidFireCD:Stop()
				timerRapidFireCD:Start(16, self.vb.rapidfire+1)
				if bossPower >= 30 then
					if self.vb.boatMissionActive == 77557 then--When garan returning, penetrating is always 27-28
						timerPenetratingShotCD:Start(30, self.vb.penetratingShot+1)
					else--When not garan returning, it's 3 second sooner
						timerPenetratingShotCD:Stop()
						timerPenetratingShotCD:Start(27, self.vb.penetratingShot+1)
					end
					timerConvulsiveShadowsCD:Stop()
					timerConvulsiveShadowsCD:Start(39.5, self.vb.convulsiveShadows+1)
					timerHeartSeekerCD:Stop()
					timerHeartSeekerCD:Start(60, self.vb.heartseeker+1)
				end
				self.vb.boatMissionActive = false
			end
		end
	end
end
