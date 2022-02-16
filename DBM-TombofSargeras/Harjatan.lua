local mod	= DBM:NewMod(1856, "DBM-TombofSargeras", nil, 875)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220116144653")
mod:SetCreatureID(116407)
mod:SetEncounterID(2036)
--mod:SetBossHPInfoToHighest()
--mod:SetUsedIcons(1)
mod:SetHotfixNoticeRev(16282)
mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 232174 231904 234194 240319 241590",
	"SPELL_CAST_SUCCESS 231854 231729 234129",
	"SPELL_AURA_APPLIED 231998 231729 231904 234016 241600 233429 232061",
	"SPELL_AURA_APPLIED_DOSE 231998",
	"SPELL_AURA_REMOVED 233429 234016 241600",
	"SPELL_AURA_REMOVED_DOSE 233429",
	"SPELL_PERIODIC_DAMAGE 231768",
	"SPELL_PERIODIC_MISSED 231768",
	"UNIT_DIED",
	"INSTANCE_ENCOUNTER_ENGAGE_UNIT",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--[[
(ability.id = 232174 or ability.id = 231904) and type = "begincast" or
(ability.id = 231854 or ability.id = 232061) and type = "cast" or
(ability.id = 233429 or ability.id = 232061) and (type = "applybuff" or type = "removebuff") or
(target.id = 116569 or target.id = 117596 or target.id = 117522 or target.id = 120545) and type = "death" or
(ability.id = 241590 or ability.id = 240319 or ability.id = 234194) and type = "begincast" or (abilty.id = 231729 or ability.id = 234129 or ability.id = 234016) and type = "cast"
--]]
--Harjatan
local warnJaggedAbrasion			= mod:NewStackAnnounce(231998, 2, nil, "Tank")
local warnFrigidBlows				= mod:NewStackAnnounce(233429, 2)
--Razorjaw Wavemender
local warnAqueousBurst				= mod:NewTargetAnnounce(231729, 2, nil, false)--Spammy
--Razorjaw Gladiator
local warnDrivenAssault				= mod:NewTargetAnnounce(234016, 3, nil, false)--Spammy
--Mythic (Eggs and tadpoles)
local warnSicklyFixate				= mod:NewTargetAnnounce(241600, 4)

--Harjatan
local specWarnJaggedAbrasion		= mod:NewSpecialWarningStack(231998, nil, 4, nil, nil, 1, 6)
local specWarnJaggedAbrasionOther	= mod:NewSpecialWarningTaunt(231998, nil, nil, nil, 1, 2)
local specWarnUncheckedRage			= mod:NewSpecialWarningCount(231854, nil, nil, nil, 2, 2)
local specWarnDrenchingWaters		= mod:NewSpecialWarningMove(231768, nil, nil, nil, 1, 2)
local specWarnCommandingroar		= mod:NewSpecialWarningSwitch(232192, "-Healer", nil, nil, 1, 2)
local specWarnDrawIn				= mod:NewSpecialWarningSpell(232061, nil, nil, nil, 1, 2)
local specWarnFrostyDischarge		= mod:NewSpecialWarningSpell(232174, nil, nil, nil, 1, 2)
--Razorjaw Wavemender
local specWarnAqueousBurst			= mod:NewSpecialWarningMoveAway(231729, nil, nil, nil, 1, 2)
local yellAqueousBurst				= mod:NewShortYell(231729)
local specWarnTendWounds			= mod:NewSpecialWarningInterrupt(231904, "HasInterrupt")
local specWarnTendWoundsDispel		= mod:NewSpecialWarningDispel(231904, "MagicDispeller")
--Razorjaw Gladiator
local specWarnDrivenAssault			= mod:NewSpecialWarningRun(234016, nil, nil, 2, 4, 2)
--Mythic (Eggs and tadpoles)
local specWarnHatching				= mod:NewSpecialWarningSwitch(240319, nil, nil, 2, 1, 2)
local specWarnSicklyFixate			= mod:NewSpecialWarningRun(241600, nil, nil, 2, 4, 2)
local specWarnTantrum				= mod:NewSpecialWarningSpell(241590, nil, nil, nil, 2, 2)

--Harjatan
mod:AddTimerLine(BOSS)
local timerUncheckedRageCD			= mod:NewNextCountTimer(20, 231854, nil, nil, nil, 2, nil, nil, nil, 1, 4)--5 power per second heroic, 20 seconds for 100 energy
local timerDrawInCD					= mod:NewNextTimer(59, 232061, nil, nil, nil, 6)
local timerCommandingRoarCD			= mod:NewNextTimer(31.8, 232192, nil, nil, nil, 1)
mod:AddTimerLine(DBM_COMMON_L.ADDS)
--Razorjaw Wavemender
local timerAqueousBurstCD			= mod:NewCDTimer(6, 231729, nil, false, nil, 3)--6-8
--Razorjaw Gladiator
local timerDrivenAssault			= mod:NewTargetTimer(10, 234016, nil, false, nil, 3)--Too many spawn, this would be spammy so off by default
local timerSplashCleaveCD			= mod:NewCDTimer(12, 234129, nil, false, nil, 5, nil, DBM_COMMON_L.TANK_ICON)
--Mythic
mod:AddTimerLine(ENCOUNTER_JOURNAL_SECTION_FLAG12)
local timerHatchingCD				= mod:NewNextTimer(40.6, 240319, nil, nil, nil, 1)--40.6-42

local berserkTimer					= mod:NewBerserkTimer(360)

--mod:AddSetIconOption("SetIconOnShield", 228270, true)
--mod:AddInfoFrameOption(227503, true)
--mod:AddRangeFrameOption("5/8/15")
mod:AddNamePlateOption("NPAuraOnSicklyFixate", 241600)
mod:AddNamePlateOption("NPAuraOnDrivenAssault", 234016)
mod:AddSetIconOption("SetIconOnWavemender", "ej14555", true, true)

mod.vb.rageCount = 0
local seenMobs = {}

function mod:OnCombatStart(delay)
	self.vb.rageCount = 0
	table.wipe(seenMobs)
	timerUncheckedRageCD:Start(-delay, 1)
	specWarnUncheckedRage:Schedule(16-delay, 1)
	specWarnUncheckedRage:ScheduleVoice(16-delay, "gathershare")
	timerCommandingRoarCD:Start(17.3-delay)
	timerDrawInCD:Start(58-delay)
	if not self:IsEasy() then
		if self:IsMythic() then
			timerHatchingCD:Start(30.5-delay)
			berserkTimer:Start(360-delay)
		end
	else
		berserkTimer:Start(480-delay)--Confirm in LFR too?
	end
	if self.Options.NPAuraOnSicklyFixate and self:IsMythic() or self.Options.NPAuraOnDrivenAssault then
		DBM:FireEvent("BossMod_EnableHostileNameplates")
	end
end

function mod:OnCombatEnd()
--	if self.Options.RangeFrame then
--		DBM.RangeCheck:Hide()
--	end
--	if self.Options.InfoFrame then
--		DBM.InfoFrame:Hide()
--	end
	if self.Options.NPAuraOnSicklyFixate and self:IsMythic() or self.Options.NPAuraOnDrivenAssault then
		DBM.Nameplate:Hide(true, nil, nil, nil, true, true)
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 232174 then
		specWarnFrostyDischarge:Show()
		specWarnFrostyDischarge:Play("phasechange")
		self.vb.rageCount = 0
		timerCommandingRoarCD:Start(17.1)
		timerUncheckedRageCD:Start(21.1, 1)--21.1-23.5
		specWarnUncheckedRage:Schedule(17, 1)
		specWarnUncheckedRage:Play(17, "gathershare")
		timerDrawInCD:Start()
		if self:IsMythic() then
			timerHatchingCD:Start(30)
		end
	elseif spellId == 231904 then
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnTendWounds:Show(args.sourceName)
			specWarnTendWounds:Play("kickcast")
		end
	elseif spellId == 234194 then
		--warnFrostySpittle:Show()
		--timerFrostySpittleCD:Start(nil, args.sourceGUID)
	elseif spellId == 241590 then
		specWarnTantrum:Show()
		specWarnTantrum:Play("aesoon")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 231729 then
		timerAqueousBurstCD:Start(nil, args.sourceGUID)
	elseif spellId == 231854 then--Unchecked Rage
		self.vb.rageCount = self.vb.rageCount + 1
		timerUncheckedRageCD:Start(nil, self.vb.rageCount+1)
		specWarnUncheckedRage:Schedule(17, self.vb.rageCount+1)
		specWarnUncheckedRage:ScheduleVoice(17, "gathershare")
	elseif spellId == 234129 then
		timerSplashCleaveCD:Start(nil, args.sourceGUID)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 231998 then
		local uId = DBM:GetRaidUnitId(args.destName)
		if self:IsTanking(uId) then
			local amount = args.amount or 1
			if amount >= 4 then--Lasts 30 seconds, cast every 5 seconds, swapping will be at 6
				if args:IsPlayer() then--At this point the other tank SHOULD be clear.
					specWarnJaggedAbrasion:Show(amount)
					specWarnJaggedAbrasion:Play("stackhigh")
				else--Taunt as soon as stacks are clear, regardless of stack count.
					if not UnitIsDeadOrGhost("player") and not DBM:UnitDebuff("player", args.spellName) then
						specWarnJaggedAbrasionOther:Show(args.destName)
						specWarnJaggedAbrasionOther:Play("tauntboss")
					else
						warnJaggedAbrasion:Show(args.destName, amount)
					end
				end
			else
				if amount % 2 == 0 then
					warnJaggedAbrasion:Show(args.destName, amount)
				end
			end
		end
	elseif spellId == 231729 then
		warnAqueousBurst:CombinedShow(1, args.destName)
		if args:IsPlayer() then
			specWarnAqueousBurst:Show()
			specWarnAqueousBurst:Play("runout")
			yellAqueousBurst:Yell()
		end
	elseif spellId == 231904 then
		specWarnTendWoundsDispel:Show(args.destName)
		if self.Options.SpecWarn231904dispel then
			specWarnTendWoundsDispel:Play("dispelnow")
		end
	elseif spellId == 234016 then
		timerDrivenAssault:Start(10, args.destName)
		warnDrivenAssault:CombinedShow(1, args.destName)
		if args:IsPlayer() and self:AntiSpam(3, 4) then
			specWarnDrivenAssault:Show()
			specWarnDrivenAssault:Play("justrun")
			specWarnDrivenAssault:ScheduleVoice(1, "keepmove")
		end
		if self.Options.NPAuraOnDrivenAssault then
			DBM.Nameplate:Show(true, args.sourceGUID, spellId)
		end
	elseif spellId == 241600 then
		warnSicklyFixate:CombinedShow(0.5, args.destName)
		if args:IsPlayer() and self:AntiSpam(3, 3) then
			specWarnSicklyFixate:Show()
			specWarnSicklyFixate:Play("justrun")
			specWarnSicklyFixate:ScheduleVoice(1, "keepmove")
		end
		if self.Options.NPAuraOnSicklyFixate then
			DBM.Nameplate:Show(true, args.sourceGUID, spellId)
		end
	elseif spellId == 232061 then
		timerUncheckedRageCD:Stop()
		specWarnUncheckedRage:Cancel()
		specWarnUncheckedRage:CancelVoice()
		timerCommandingRoarCD:Stop()
		timerDrawInCD:Stop()
		specWarnDrawIn:Show()
		specWarnDrawIn:Play("phasechange")
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 233429 then
		local amount = args.amount or 0
		if amount < 4 or self:AntiSpam(5, 1) then
		--Every 5 seconds or every stack under 4
			warnFrigidBlows:Show(args.destName, amount)
		end
	elseif spellId == 234016 then
		timerDrivenAssault:Stop(args.destName)
		if self.Options.NPAuraOnDrivenAssault then
			DBM.Nameplate:Hide(true, args.sourceGUID, spellId)
		end
	elseif spellId == 241600 then
		if self.Options.NPAuraOnSicklyFixate then
			DBM.Nameplate:Hide(true, args.sourceGUID, spellId)
		end
	end
end
mod.SPELL_AURA_REMOVED_DOSE = mod.SPELL_AURA_REMOVED

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 231768 and destGUID == UnitGUID("player") and self:AntiSpam(2, 2) then
		specWarnDrenchingWaters:Show()
		specWarnDrenchingWaters:Play("runaway")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 116569 then--Razorjaw Wavemender
		timerAqueousBurstCD:Stop(args.destGUID)
	elseif cid == 117596 then--Razorjaw Gladiator
		timerSplashCleaveCD:Stop(args.destGUID)
	--elseif cid == 117522 then--Darkscale Taskmaster
		--timerFrostySpittleCD:Stop(args.destGUID)
	elseif cid == 120545 then--Incubated Egg

	end
end

--"<26.92 17:09:49> [INSTANCE_ENCOUNTER_ENGAGE_UNIT] Fake Args:#boss1#false#false#false#??#nil#normal#0#boss2#false#false#false#??#nil#normal#0#boss3#false#false#false#??#nil#normal#0#boss4#false#false#false#??#nil#normal#0#boss5#false#false#false#??#nil#normal#0#Real Args:", -- [74]
--"<26.93 17:09:49> [UNIT_TARGETABLE_CHANGED] nameplate3#false#false#true#Razorjaw Gladiator#Creature-0-2083-1676-7590-117596-00011E36EB#elite#10751230", -- [75]
--"<26.93 17:09:49> [UNIT_TARGETABLE_CHANGED] nameplate4#false#false#true#Razorjaw Gladiator#Creature-0-2083-1676-7590-117596-00009E36EB#elite#10751230", -- [76]
--Didn't live long enough to see if IEEU would work for these, based on above it wouldn't or it wouldn't be as fast as UNIT_TARGETABLE_CHANGED. However UNIT_TARGETABLE_CHANGED might rely on nameplate unitIDs
function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	for i = 1, 5 do
		local unitID = "boss"..i
		local GUID = UnitGUID(unitID)
		if GUID and not seenMobs[GUID] then
			seenMobs[GUID] = true
			local cid = self:GetCIDFromGUID(GUID)
			if cid == 116569 then--Razorjaw Wavemender
				--timerAqueousBurstCD:Start(1, GUID)
				if self.Options.SetIconOnWavemender then
					self:ScanForMobs(GUID, 0, 8, 2, nil, 12, "SetIconOnWavemender")
				end
			end
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 232192 then--Commanding Roar
		specWarnCommandingroar:Show()
		specWarnCommandingroar:Play("killmob")
		timerCommandingRoarCD:Start()
	elseif spellId == 240347 then--Warn Players of Hatching Eggs
		specWarnHatching:Show()
		specWarnHatching:Play("killmob")
		timerHatchingCD:Start()
	end
end

