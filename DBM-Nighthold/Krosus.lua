local mod	= DBM:NewMod(1713, "DBM-Nighthold", nil, 786)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220116144653")
mod:SetCreatureID(101002)
mod:SetEncounterID(1842)
--mod:SetUsedIcons(8, 7, 6, 3, 2, 1)
mod:SetHotfixNoticeRev(15740)
mod.respawnTime = 29--or 30

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 205368 205370 205420 209017 206351 205862 205361",
	"SPELL_AURA_APPLIED 206677 205344",
	"SPELL_AURA_APPLIED_DOSE 206677",
	"SPELL_AURA_REMOVED 205344",
	"UNIT_DIED",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--(ability.id = 205368 or ability.id = 205370 or ability.id = 205420 or ability.id = 205361) and type = "begincast"
local warnExpelOrbDestro			= mod:NewTargetCountAnnounce(205344, 4)
local warnSlamSoon					= mod:NewAnnounce("warnSlamSoon", 4, 205862, nil, nil, true)
local warnSlam						= mod:NewCountAnnounce(205862, 2)--Regular slams don't need special warn, only bridge smashing ones

local specWarnSearingBrand			= mod:NewSpecialWarningStack(206677, nil, 4, nil, 2, 1, 6)--Lets go with 4 for now
local specWarnSearingBrandOther		= mod:NewSpecialWarningTaunt(206677, nil, nil, nil, 1, 2)
local specWarnFelBeam				= mod:NewSpecialWarningDodge(205368, nil, nil, nil, 2, 2)
local specWarnOrbDestro				= mod:NewSpecialWarningMoveAway(205344, nil, nil, nil, 3, 2)
local yellOrbDestro					= mod:NewFadesYell(205344)
local specWarnBurningPitch			= mod:NewSpecialWarningCount(205420, nil, nil, nil, 2, 6)
local specWarnSlam					= mod:NewSpecialWarningRun(205862, nil, nil, nil, 4, 2)
local specWarnFelBlast				= mod:NewSpecialWarningInterrupt(209017, false, nil, 2, 1, 2)
local specWarnFelBurst				= mod:NewSpecialWarningInterrupt(206351, "HasInterrupt", nil, nil, 1, 2)

local timerSearingBrand				= mod:NewTargetTimer(20, 206677, nil, "Tank", nil, 5)
local timerFelBeamCD				= mod:NewNextCountTimer(16, 205368, 173303, nil, nil, 3)--Short text "Beam"
local timerOrbDestroCD				= mod:NewNextCountTimer(16, 205344, DBM_COMMON_L.ORB, nil, nil, 3, nil, DBM_COMMON_L.DEADLY_ICON, nil, 3, 4)--Shor timer text "Orb"
local timerBurningPitchCD			= mod:NewNextCountTimer(16, 205420, nil, nil, 2, 5)
local timerSlamCD					= mod:NewNextCountTimer(30, 205862, nil, nil, nil, 3, nil, DBM_COMMON_L.DEADLY_ICON, nil, 1, 4)

local berserkTimer					= mod:NewBerserkTimer(360)--technically not a berserk, but raid instantly wipes during final bridge smash, at 6 minutes.

mod:AddRangeFrameOption(5, 206351)
mod:AddSetIconOption("SetIconOnAdds", "ej12914", true, true)
mod:AddArrowOption("ArrowOnBeam3", 205368, true)

local burningPitchDebuff = DBM:GetSpellInfo(215944)
local mobGUIDs = {}
--Beams (205370/205368 Combined)
local lolBeamTimers = {5, 15, 30, 30, 23, 27, 30, 44, 14, 16, 14, 16, 22, 60}--LFR & Normal
local heroicBeamTimers = {7.0, 29.0, 30.0, 42.0, 16.0, 16.0, 14.0, 16.0, 27.0, 54.0, 26.0, 5, 5, 16, 5, 12, 12, 5, 13}--Complete up to berserk (not yet verified in 7.1.5)
						--8.0, 29.0, 30.0, 45.0, 16.0, 16.0, 14.0, 16.0, 27.0, 55.0, 26.0, 43.0--Dec 7th. However Double beams aren't combined in these so can't really merge cleanly
local mythicBeamTimers = {6, 16, 16, 16, 14, 16, 27, 55, 26, 4.7, 21.3, 4.7, 12.2, 12, 4.7, 13.2, 19, 4.7, 25.2, 4.7, 25.2, 4.7}--(up to 5:55, missing 5 seconds?)
--Orbs
local lolOrbTimers = {70.0, 40.0, 60.0, 25.0, 60.0, 37.0, 15.0, 15.0, 30.0}--LFR and Normal
local heroicOrbTimers = {19.9, 60.0, 23.0, 62.0, 27.0, 25.0, 15.0, 15.4, 14.6, 30, 55}--Verified Dec 7
local mythicOrbTimers = {13, 62, 27, 25, 14.9, 15, 15, 30, 55.1, 38, 30, 12, 18}--(up to 5:55, missing 5 seconds?)
--Pitch
local lolBurningPitchTimers = {38.0, 102.0, 85.0, 90.0}--LFR and Normal
local heroicBurningPitchTimers = {49.8, 85.0, 90.0, 94}--Verified Dec 7
local mythicBurningPitchTimers = {45.0, 90, 93.9, 78}
local minAmount, maxAmount = 2, 4
mod.vb.burningEmbers = 0
mod.vb.slamCount = 0
mod.vb.beamCount = 0
mod.vb.orbCount = 0
mod.vb.pitchCount = 0
mod.vb.firstBeam = 0--0 Not sent, 1 Left, 2 Right

--/run DBMUpdateKrosusBeam(wasLeft)
--Global on purpose for external mod support
--DBM:GetModByName("1713"):SendBigWigsSync("firstBeamWasLeft")
_G["DBMUpdateKrosusBeam"] = function(wasLeft)
	if wasLeft then
		mod.vb.firstBeam = 1
		if not mod:IsLFR() then
			mod:SendBigWigsSync("firstBeamWasLeft")
		end
	else
		mod.vb.firstBeam = 2
		if not mod:IsLFR() then
			mod:SendBigWigsSync("firstBeamWasRight")
		end
	end
end

function mod:OnCombatStart(delay)
	if self:IsTrivial() or self:IsLFR() then
		minAmount, maxAmount = 8, 16
	elseif self:IsNormal() then
		minAmount, maxAmount = 4, 8
	elseif self:IsHeroic() then
		minAmount, maxAmount = 3, 6
	else--Mythic
		minAmount, maxAmount = 2, 4
	end
	table.wipe(mobGUIDs)
	self.vb.burningEmbers = 0
	self.vb.slamCount = 0
	self.vb.beamCount = 0
	self.vb.orbCount = 0
	self.vb.pitchCount = 0
	self.vb.firstBeam = 0
	warnSlamSoon:Countdown(90)
	timerSlamCD:Start(-delay, 1)
	berserkTimer:Start(-delay)
	if self:IsMythic() then
		timerFelBeamCD:Start(6-delay, 1)
		timerOrbDestroCD:Start(13-delay, 1)
		timerBurningPitchCD:Start(45-delay, 1)
	elseif self:IsHeroic() then
		timerFelBeamCD:Start(5-delay, 1)
		timerOrbDestroCD:Start(20-delay, 1)
		timerBurningPitchCD:Start(50-delay, 1)
	else
		timerFelBeamCD:Start(5-delay, 1)
		timerBurningPitchCD:Start(38-delay, 1)
		timerOrbDestroCD:Start(70-delay, 1)
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 205368 or spellId == 205370 then--205370 left, 205368 right (right no longer is used)
		self.vb.beamCount = self.vb.beamCount + 1
		specWarnFelBeam:Show()
		local nextCount = self.vb.beamCount + 1
		local timerText = nextCount
		if self.vb.firstBeam == 2 then--First Beam Right
			if self.vb.beamCount % 2 == 0 then--Coming from left (facing boss)
				specWarnFelBeam:Play("moveright")
				timerText = L.MoveLeft--Timer text is backwards cause it's for NEXT beam
				if self.Options.ArrowOnBeam3 then
					DBM.Arrow:ShowStatic(270, 4)
				end
			else--coming from right (facing boss)
				specWarnFelBeam:Play("moveleft")
				timerText = L.MoveRight--Timer text is backwards cause it's for NEXT beam
				if self.Options.ArrowOnBeam3 then
					DBM.Arrow:ShowStatic(90, 4)
				end
			end
		elseif self.vb.firstBeam == 1 then--First Beam Left
			if self.vb.beamCount % 2 == 0 then--Coming from right (facing boss)
				specWarnFelBeam:Play("moveleft")
				timerText = L.MoveRight--Timer text is backwards cause it's for NEXT beam
				if self.Options.ArrowOnBeam3 then
					DBM.Arrow:ShowStatic(90, 4)
				end
			else--coming from left (facing boss)
				specWarnFelBeam:Play("moveright")
				timerText = L.MoveLeft--Timer text is backwards cause it's for NEXT beam
				if self.Options.ArrowOnBeam3 then
					DBM.Arrow:ShowStatic(270, 4)
				end
			end
		else
			specWarnFelBeam:Play("shockwave")
		end
		local timers = self:IsMythic() and mythicBeamTimers[nextCount] or self:IsHeroic() and heroicBeamTimers[nextCount] or lolBeamTimers[nextCount]
		if timers then
			timerFelBeamCD:Start(timers, timerText)
		end
	elseif spellId == 205420 then
		self.vb.pitchCount = self.vb.pitchCount+ 1
		specWarnBurningPitch:Show(self.vb.pitchCount)
		if DBM:UnitDebuff("player", burningPitchDebuff) then
			specWarnBurningPitch:Play("watchstep")
		else
			specWarnBurningPitch:Play("helpsoak")
		end
		local nextCount = self.vb.pitchCount + 1
		local timers = self:IsMythic() and mythicBurningPitchTimers[nextCount] or self:IsHeroic() and heroicBurningPitchTimers[nextCount] or lolBurningPitchTimers[nextCount]
		if timers then
			timerBurningPitchCD:Start(timers, nextCount)
		end
	elseif spellId == 209017 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnFelBlast:Show(args.sourceName)
		specWarnFelBlast:Play("kickcast")
	elseif spellId == 206351 then
		if not mobGUIDs[args.sourceGUID] then
			mobGUIDs[args.sourceGUID] = true
			self.vb.burningEmbers = self.vb.burningEmbers + 1
			if self.Options.RangeFrame and not DBM.RangeCheck:IsShown() then
				DBM.RangeCheck:Show(5)
			end
			if self.Options.SetIconOnAdds then
				self:ScanForMobs(args.sourceGUID, 0, 8, 8, nil, 15, "SetIconOnAdds")
			end
		end
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnFelBurst:Show(args.sourceName)
			specWarnFelBurst:Play("kickcast")
		end
	elseif spellId == 205862 then
		self.vb.slamCount = self.vb.slamCount + 1
		timerSlamCD:Start(nil, self.vb.slamCount+1)
		if self.vb.slamCount % 3 == 0 then
			specWarnSlam:Show()
			specWarnSlam:Play("justrun")
			warnSlamSoon:Countdown(90)
		else
			warnSlam:Show(self.vb.slamCount)
			if self:IsTank() then
				specWarnSlam:Play("helpsoak")
			else
				specWarnSlam:Play("watchstep")
			end
		end
	elseif spellId == 205361 then
		self.vb.orbCount = self.vb.orbCount + 1
		local nextCount = self.vb.orbCount+1
		local timers = self:IsMythic() and mythicOrbTimers[nextCount] or self:IsHeroic() and heroicOrbTimers[nextCount] or lolOrbTimers[nextCount]
		if timers then
			timerOrbDestroCD:Start(timers, nextCount)
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 206677 then
		local uId = DBM:GetRaidUnitId(args.destName)
		if self:IsTanking(uId) then
			local amount = args.amount or 1
			timerSearingBrand:Start(args.destName)
			if amount >= minAmount then
				if args:IsPlayer() then
					if amount >= maxAmount then
						specWarnSearingBrand:Show(amount)
						specWarnSearingBrand:Play("stackhigh")
					end
				else
					if not DBM:UnitDebuff("player", args.spellName) and not UnitIsDeadOrGhost("player") then
						specWarnSearingBrandOther:Show(args.destName)
						specWarnSearingBrandOther:Play("tauntboss")
					end
				end
			end
		end
	elseif spellId == 205344 then
		if args:IsPlayer() then--Still do yell and range frame here, in case DK
			specWarnOrbDestro:Show()
			specWarnOrbDestro:Play("runout")
			yellOrbDestro:Yell(5)
			yellOrbDestro:Schedule(4, 1)
			yellOrbDestro:Schedule(3, 2)
			yellOrbDestro:Schedule(2, 3)
		else
			warnExpelOrbDestro:Show(self.vb.orbCount, args.destName)
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 205344 then
		if args:IsPlayer() then
			yellOrbDestro:Cancel()
		end
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 104262 then--Burning Ember
		self.vb.burningEmbers = self.vb.burningEmbers - 1
		mobGUIDs[args.destGUID] = nil
		if self.Options.RangeFrame and self.vb.burningEmbers == 0 then
			DBM.RangeCheck:Hide()
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 205383 then--Fel Beam (fires for left and right) Does not fire for double beams
		DBM:Debug("Single Beam", 2)
	elseif spellId == 215961 then--Double Beam (fires for the double beam sequence where you get both beams back to back. Only fires at start of it not each beam*)
		DBM:Debug("Double Beam", 2)
	end
end

--Listen for Krosus Assist on Bigwigs Comms to make compat with mod much easier for elvador
function mod:OnBWSync(msg)
	if msg == "firstBeamWasLeft" then
		self.vb.firstBeam = 1
		DBM:Debug("Recieved Left Beam Sync")
	elseif msg == "firstBeamWasRight" then
		self.vb.firstBeam = 2
		DBM:Debug("Recieved Right Beam Sync")
	end
end
