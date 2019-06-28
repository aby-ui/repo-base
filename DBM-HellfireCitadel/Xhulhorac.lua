local mod	= DBM:NewMod(1447, "DBM-HellfireCitadel", nil, 669)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143352")
mod:SetCreatureID(93068)
mod:SetEncounterID(1800)
mod:SetZone()
mod:SetUsedIcons(8, 7, 6, 4, 2, 1)
mod.respawnTime = 29

mod:RegisterCombat("combat")


mod:RegisterEventsInCombat(
	"SPELL_CAST_START 190223 186453 190224 186783 186546 186490 189775 189779 188939",
	"SPELL_CAST_SUCCESS 186407 186333 186490 189775 186453 186783 186271 186292",
	"SPELL_AURA_APPLIED 186073 186063 186134 186135 186407 186333 186500 189777 186448 187204 186785",
	"SPELL_AURA_APPLIED_DOSE 186073 186063 186448 186785 187204",
	"SPELL_AURA_REMOVED 189777",
	"INSTANCE_ENCOUNTER_ENGAGE_UNIT",
	"UNIT_DIED",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--(target.id = 94185 or target.id =  94239) and type = "death" or (ability.id = 190223 or ability.id = 190224 or ability.id = 186453 or ability.id = 186783 or ability.id = 186546 or ability.id = 189779 or ability.id = 186490 or ability.id = 189775) and type = "begincast" or (ability.id = 186407 or ability.id = 186333) and type = "cast" or ability.id = 187204 and type = "applybuff"
--Fire Phase
----Boss
local warnFelPortal					= mod:NewSpellAnnounce(187003, 2, nil, nil, nil, nil, nil, 2)
local warnFelSurge					= mod:NewTargetAnnounce(186407, 3)
local warnFelStrike					= mod:NewSpellAnnounce(186271, 3, nil, "Tank")
local warnImps						= mod:NewCountAnnounce("ej11694", 2, 112866, "Melee")
----Adds
local warnFelChains					= mod:NewTargetAnnounce(186490, 3)
local warnEmpoweredFelChains		= mod:NewTargetAnnounce(189775, 3)--Mythic
--Void Phase
----Boss
local warnVoidPortal				= mod:NewSpellAnnounce(187006, 2, nil, nil, nil, nil, nil, 2)
local warnVoidSurge					= mod:NewTargetAnnounce(186333, 3)
local warnVoidStrike				= mod:NewSpellAnnounce(186292, 3, nil, "Tank")
local warnVoids						= mod:NewCountAnnounce("ej11714", 2, 697, "Ranged")
----
--End Phase
local warnPhase3					= mod:NewPhaseAnnounce(3, 2, nil, nil, nil, nil, nil, 2)
local warnOverwhelmingChaos			= mod:NewCountAnnounce(187204, 4)

--Fight Wide
local specWarnFelTouched			= mod:NewSpecialWarningYou(186134, false)
local specWarnFelsinged				= mod:NewSpecialWarningMove(186073, nil, nil, nil, 1, 2)--Fire GTFO
local specWarnVoidTouched			= mod:NewSpecialWarningYou(186135, false)
local specWarnWastingVoid			= mod:NewSpecialWarningMove(186063, nil, nil, nil, 1, 2)--Void GTFO
local specWarnPhasing				= mod:NewSpecialWarningTaunt(189047, nil, nil, nil, 1, 2)--May need smarter code.
--Fire Phase
----Boss
local specWarnFelStrike				= mod:NewSpecialWarningSpell(186271, "Tank")
local specWarnFelSurge				= mod:NewSpecialWarningYou(186407, nil, nil, nil, 1, 2)
local yellFelSurge					= mod:NewYell(186407)
local specWarnImps					= mod:NewSpecialWarningSwitchCount("ej11694", "Dps")
----Adds
local specWarnFelBlazeFlurry		= mod:NewSpecialWarningDefensive(186453, "Tank", nil, nil, 3, 2)
local specWarnFelChains				= mod:NewSpecialWarningYou(186490)
local specWarnEmpoweredFelChains	= mod:NewSpecialWarningYou(189775)
local yellFelChains					= mod:NewYell(186490)
--Void Phase
----Boss
local specWarnVoidStrike			= mod:NewSpecialWarningSpell(186292, "Tank")
local specWarnVoidSurge				= mod:NewSpecialWarningYou(186333, nil, nil, nil, 1, 5)
local yellVoidSurge					= mod:NewYell(186333)
local specWarnVoids					= mod:NewSpecialWarningCount("ej11714", "Ranged")
----Adds
local specWarnWitheringGaze			= mod:NewSpecialWarningDefensive(186783, "Tank", nil, nil, 1, 2)
local specWarnBlackHole				= mod:NewSpecialWarningCount(186546, nil, nil, nil, 2)
local specWarnEmpBlackHole			= mod:NewSpecialWarningCount(189779, nil, nil, nil, 2)--Mythic

--Fire Phase
----Boss
local timerFelStrikeCD				= mod:NewCDTimer(13, 186271, nil, "Tank", nil, 5, nil, DBM_CORE_TANK_ICON)--15.8-17
local timerFelSurgeCD				= mod:NewCDTimer(29, 186407, nil, "-Tank", 2, 3, nil, nil, nil, 1, 3)
local timerImpCD					= mod:NewNextTimer(25, "ej11694", nil, nil, nil, 1, 112866, nil, nil, 3, 4)
----Big Add
local timerFelBlazeFlurryCD			= mod:NewCDTimer(12.9, 186453, nil, "Tank", nil, 5, nil, DBM_CORE_TANK_ICON)
local timerFelChainsCD				= mod:NewCDTimer(30, 186490, nil, "-Tank", nil, 3)--30-34. Often 34 but it can and will be 30 sometimes.
--Void Phase
----Boss
local timerVoidStrikeCD				= mod:NewCDTimer(15, 186292, nil, "Tank", nil, 5, nil, DBM_CORE_TANK_ICON)
local timerVoidSurgeCD				= mod:NewCDTimer(29, 186333, nil, "-Tank", 2, 3, nil, nil, nil, 2, 3)
local timerVoidsCD					= mod:NewNextTimer(30, "ej11714", nil, "Ranged", nil, 1, 697)
----Big Add
local timerWitheringGazeCD			= mod:NewCDTimer(22, 186783, nil, "Tank", 2, 5, nil, DBM_CORE_TANK_ICON)
local timerBlackHoleCD				= mod:NewCDCountTimer(29.5, 186546, nil, "-Tank", 2, 5)
local timerEmpBlackHoleCD			= mod:NewCDCountTimer(29.5, 189779, 186546, "-Tank", 2, 5, nil, DBM_CORE_DEADLY_ICON)
--End Phase
local timerOverwhelmingChaosCD		= mod:NewNextCountTimer(10, 187204, nil, nil, 2, 2, nil, DBM_CORE_HEALER_ICON)

--local berserkTimer					= mod:NewBerserkTimer(360)

--Warning behavior choices for Chains.
--Cast only gives original target, not all targets, but does so 3 seconds faster. It allows the person to move early and change other players they affect with chains by pre moving.
--Applied gives all targets, this is the easier strat for most users, where they wait until everyone has it, then run in different directions.
--Both, gives users ALL the information for everything so they can decide on their own. This will be default until I can see what becomes more popular. Maybe both will be what everyone ends up preferring.
mod:AddRangeFrameOption(5, 189775)--Mythic
mod:AddSetIconOption("SetIconOnImps", "ej11694", true, true)
mod:AddDropdownOption("ChainsBehavior", {"Cast", "Applied", "Both"}, "Both", "misc")

mod.vb.EmpFelChainCount = 0
mod.vb.phase = 1
mod.vb.impCount = 0
mod.vb.impActive = 0
mod.vb.voidCount = 0
mod.vb.blackHoleCount = 0
mod.vb.bothDead = 0
local playerTanking = 0--1 Vanguard, 2 void walker
local UnitExists, UnitGUID, UnitDetailedThreatSituation = UnitExists, UnitGUID, UnitDetailedThreatSituation
local AddsSeen = {}

local debuffFilter
local debuffName, vanguardTank, voidwalkerTank = DBM:GetSpellInfo(189775), DBM:GetSpellInfo(186135), DBM:GetSpellInfo(186134)
do
	debuffFilter = function(uId)
		if DBM:UnitDebuff(uId, debuffName) then
			return true
		end
	end
end

local function updateRangeFrame(self)
	if not self.Options.RangeFrame then return end
	if self.vb.EmpFelChainCount > 0 then
		if DBM:UnitDebuff("Player", debuffName) then
			DBM.RangeCheck:Show(5)
		else
			DBM.RangeCheck:Show(5, debuffFilter)
		end
	else
		DBM.RangeCheck:Hide()
	end
end

--You can use their first cast, but scheduling is more accurate from what i've tested
--First cast will break if imps are stunned/interrupted by gorefiends grip on spawn and don't begin their first cast
--not to mention their first cast is a good 1.5-2 seconds after spawn, if it isn't prevented
local function ImpRepeater(self)
	self.vb.impCount = self.vb.impCount + 1
	self.vb.impActive = self.vb.impActive + 3
	if self.Options.SpecWarnej11694switchcount then
		specWarnImps:Show(self.vb.impCount)
	else
		warnImps:Show(self.vb.impCount)
	end
	timerImpCD:Start(nil, self.vb.impCount+1)
	self:Schedule(25, ImpRepeater, self)
	if self.Options.SetIconOnImps then
		if self.vb.impActive > 0 then--Last set isn't dead yet, use alternate icons
			self:ScanForMobs(94231, 0, 5, 3, 0.2, 10, "SetIconOnImps")
		else
			self:ScanForMobs(94231, 0, 8, 3, 0.2, 10, "SetIconOnImps")
		end
	end
end

local function VoidsRepeater(self)
	self.vb.voidCount = self.vb.voidCount + 1
	if self.Options.SpecWarnej11714count then
		specWarnVoids:Show(self.vb.voidCount)
	else
		warnVoids:Show(self.vb.voidCount)
	end
	timerVoidsCD:Start(nil, self.vb.voidCount+1)
	self:Schedule(30, VoidsRepeater, self)
end

function mod:VoidTarget(targetname, uId)
	if not targetname then return end
	DBM:Debug("Void teleport on: "..targetname, 2)
end

function mod:FelChains(targetname, uId)
	if targetname == UnitName("player") then
		if self:AntiSpam(5, 3) then
			specWarnFelChains:Show()
			yellFelChains:Yell()
		end
	else
		warnFelChains:Show(targetname)
	end
end

function mod:EmpoweredFelChains(targetname, uId)
	if targetname == UnitName("player") then
		specWarnEmpoweredFelChains:Show()
		yellFelChains:Yell()--Continue using shorter yell
	else
		warnEmpoweredFelChains:Show(targetname)
	end
end

function mod:OnCombatStart(delay)
	self.vb.EmpFelChainCount = 0
	self.vb.phase = 1
	self.vb.impCount = 0
	self.vb.impActive = 0
	self.vb.voidCount = 0
	self.vb.blackHoleCount = 0
	self.vb.bothDead = 0
	playerTanking = 0
	table.wipe(AddsSeen)
	timerFelStrikeCD:Start(8-delay)
	timerFelSurgeCD:Start(21-delay)
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end 

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 190223 then
		for i = 1, 5 do
			local bossUnitID = "boss"..i
			if UnitExists(bossUnitID) and UnitGUID(bossUnitID) == args.sourceGUID then
				if UnitDetailedThreatSituation("player", bossUnitID) then--We are highest threat target
					specWarnFelStrike:Show()--So show tank warning
					return
				else
					--Not Tanking
					if self.vb.phase >= 3 and playerTanking == 1 and not DBM:UnitDebuff("player", vanguardTank) then--Vanguard Tank
						--You're the Vanguard tank and do NOT have aggro for this strike or void debuff, taunt NOW
						local targetName = UnitName(bossUnitID.."target") or DBM_CORE_UNKNOWN
						if self:AntiSpam(3, targetName) then
							specWarnPhasing:Show(targetName)
							specWarnPhasing:Play("tauntboss")
						end
					end
				end
			end
		end
		warnFelStrike:Show()--Should not show if specWarnFelStrike did
	elseif spellId == 190224 then
		for i = 1, 5 do
			local bossUnitID = "boss"..i
			if UnitExists(bossUnitID) and UnitGUID(bossUnitID) == args.sourceGUID then
				if UnitDetailedThreatSituation("player", bossUnitID) then--We are highest threat target
					specWarnVoidStrike:Show()--So show tank warning
					return
				else
					--Not Tanking
					if self.vb.phase >= 3 and playerTanking == 2 and not DBM:UnitDebuff("player", voidwalkerTank) then--VoidWalker Tank
						--You're the void walker tank and do NOT have aggro for this strike or fel debuff, taunt NOW
						local targetName = UnitName(bossUnitID.."target") or DBM_CORE_UNKNOWN
						if self:AntiSpam(3, targetName) then
							specWarnPhasing:Show(targetName)
							specWarnPhasing:Play("tauntboss")
						end
					end
				end
			end
		end
		warnVoidStrike:Show()--Should not show if specWarnVoidStrike did
	elseif spellId == 186453 then
		for i = 1, 5 do
			local bossUnitID = "boss"..i
			if UnitExists(bossUnitID) and UnitGUID(bossUnitID) == args.sourceGUID and UnitDetailedThreatSituation("player", bossUnitID) then--We are highest threat target
				playerTanking = 1--Set player tanking to vanguard
				specWarnFelBlazeFlurry:Show()--So show tank warning
				specWarnFelBlazeFlurry:Play("defensive")
				break
			end
		end
	elseif spellId == 186783 then
		for i = 1, 5 do
			local bossUnitID = "boss"..i
			if UnitExists(bossUnitID) and UnitGUID(bossUnitID) == args.sourceGUID and UnitDetailedThreatSituation("player", bossUnitID) then--We are highest threat target
				playerTanking = 2--Set player tanking to void walker
				specWarnWitheringGaze:Show()--So show tank warning
				specWarnWitheringGaze:Play("defensive")
				break
			end
		end
	elseif spellId == 186546 then
		self.vb.blackHoleCount = self.vb.blackHoleCount + 1
		specWarnBlackHole:Show(self.vb.blackHoleCount)
		if self.vb.blackHoleCount == 2 then
		--Smart auto correct may not be needed. I've never seen a log where this wasn't delayed at least 9 seconds.
		--I have seen some delayed as much as 12 though, so timer auto correct would still be more accurate...
		--But that level of pickyness may not be worth complexity and testing involved for auto correct code
		--https://www.warcraftlogs.com/reports/yWRb9vqd7JBPar6L#fight=4&type=summary&view=events&pins=2%24Off%24%23244F4B%24expression%24(ability.id+%3D+186783+or+ability.id+%3D+186546)+and+type+%3D+%22begincast%22+or+ability.id+%3D+186783+and+type+%3D+%22removedebuff%22
			timerBlackHoleCD:Start(39, self.vb.blackHoleCount+1)
		else
			timerBlackHoleCD:Start(nil, self.vb.blackHoleCount+1)
		end
	elseif spellId == 189779 then
		self.vb.blackHoleCount = self.vb.blackHoleCount + 1
		specWarnEmpBlackHole:Show(self.vb.blackHoleCount)
		timerEmpBlackHoleCD:Start(nil, self.vb.blackHoleCount+1)
	elseif spellId == 186490 then
		if self.Options.ChainsBehavior ~= "Applied" then--Start timer and scanner if method is Both or Cast. Both prefers cast over applied, for the timer.
			self:ScheduleMethod(0.1, "BossTargetScanner", args.sourceGUID, "FelChains", 0.1, 16)
		end
	elseif spellId == 189775 then
		if self.Options.ChainsBehavior ~= "Applied" then--Start timer and scanner if method is Both or Cast. Both prefers cast over applied, for the timer.
			self:ScheduleMethod(0.1, "BossTargetScanner", args.sourceGUID, "EmpoweredFelChains", 0.1, 16)
		end
	elseif spellId == 188939 then
		self:ScheduleMethod(0.2, "BossTargetScanner", args.sourceGUID, "VoidTarget", 0.1, 16)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 186407 then
		timerFelSurgeCD:Start()
	elseif spellId == 186333 then
		timerVoidSurgeCD:Start()
	elseif spellId == 186490 then
		if self.Options.ChainsBehavior == "Applied" then--Start timer here if method is set to only applied
			timerFelChainsCD:Start()
		else
			timerFelChainsCD:Start(27)--30-3 for timer to be for cast BEGIN
		end
	elseif spellId == 189775 then
		if self.Options.ChainsBehavior == "Applied" then--Start timer here if method is set to only applied
			timerFelChainsCD:Start()
		else
			timerFelChainsCD:Start(27)--30-3
		end
	elseif spellId == 186453 then
		timerFelBlazeFlurryCD:Start()
	elseif spellId == 186783 then
		timerWitheringGazeCD:Start()
	elseif spellId == 186271 then--190223 is not valid, because it returns target boss had at cast start, even if a taunt happened mid cast.
		timerFelStrikeCD:Start()
		if self.vb.phase >= 3 then
			if playerTanking == 2 then--VoidWalker Tank
				--Fel strike just finished, void strike next so voidwalker tank needs to take it
				if not args:IsPlayer() then
					if self:AntiSpam(3, args.destName) then
						specWarnPhasing:Show(args.destName)
						specWarnPhasing:Play("tauntboss")
					end
				end
			elseif self.vb.bothDead == 2 and playerTanking == 0 then
				if not args:IsPlayer() then--Just warn whoever THIS strike didn't hit
					if self:AntiSpam(3, args.destName) then
						specWarnPhasing:Show(args.destName)
						specWarnPhasing:Play("tauntboss")
					end
				else
					specWarnPhasing:Play("changemt")
				end
			else
				specWarnPhasing:Play("changemt")
			end
		end
	elseif spellId == 186292 then--190224 is not valid, because it returns target boss had at cast start, even if a taunt happened mid cast.
		if self.vb.phase >= 3 then
			if playerTanking == 1 then--Vanguard Tank
				--void strike just finished, fel strike next so vanguard tank needs to take it
				if not args:IsPlayer() then
					if self:AntiSpam(3, args.destName) then
						specWarnPhasing:Show(args.destName)
						specWarnPhasing:Play("tauntboss")
					end
				end
			elseif self.vb.bothDead == 2 and playerTanking == 0 then
				if not args:IsPlayer() then
					if self:AntiSpam(3, args.destName) then
						specWarnPhasing:Show(args.destName)
						specWarnPhasing:Play("tauntboss")
					end
				else
					specWarnPhasing:Play("changemt")
				end
			else
				specWarnPhasing:Play("changemt")
			end
			timerVoidStrikeCD:Start(13)
		else
			timerVoidStrikeCD:Start()
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 186063 and args:IsPlayer() and self:AntiSpam(2, 1) then
		specWarnWastingVoid:Show()
		specWarnWastingVoid:Play("runaway")
	elseif spellId == 186073 and args:IsPlayer() and self:AntiSpam(2, 2) then
		specWarnFelsinged:Show()
		specWarnFelsinged:Play("runaway")
	elseif spellId == 186135 and args:IsPlayer() then
		specWarnVoidTouched:Show()
	elseif spellId == 186134 and args:IsPlayer() then
		specWarnFelTouched:Show()
	elseif spellId == 186407 then
		warnFelSurge:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			specWarnFelSurge:Show()
			yellFelSurge:Yell()
			specWarnFelSurge:Play("runout")
		end
	elseif spellId == 186333 then
		warnVoidSurge:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			specWarnVoidSurge:Show()
			yellVoidSurge:Yell()
			specWarnVoidSurge:Play("186333")
		end
	elseif spellId == 186500 and self.Options.ChainsBehavior ~= "Cast" then--Chains! (show warning if type is applied or both)
		warnFelChains:CombinedShow(0.3, args.destName)
		if args:IsPlayer() and self:AntiSpam(5, 3) then
			specWarnFelChains:Show()
			yellFelChains:Yell()
		end
	elseif spellId == 189777 then--Mythic chains
		self.vb.EmpFelChainCount = self.vb.EmpFelChainCount + 1
		if self.Options.ChainsBehavior ~= "Cast" then
			warnEmpoweredFelChains:CombinedShow(0.3, args.destName)
			if args:IsPlayer() then
				specWarnEmpoweredFelChains:Show()
				yellFelChains:Yell()
			end	
		end
		updateRangeFrame(self)
	elseif spellId == 187204 then
		local amount = args.amount or 1
		warnOverwhelmingChaos:Show(amount)
		timerOverwhelmingChaosCD:Start(nil, amount+1)
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 189777 then
		self.vb.EmpFelChainCount = self.vb.EmpFelChainCount - 1
		updateRangeFrame(self)
	end
end

--187196 is usuable with UNIT_SPELLCAST_SUCCEEDED, but it doesn't have which add is coming out, so it'd require a counting variable
--187039 combat log event is usuable for second add but first add doesn't have combat log event
--I just trust INSTANCE_ENCOUNTER_ENGAGE_UNIT more, especially if blizzard screws with hidden events some more
function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	for i = 1, 5 do
		local uId = "boss"..i
		local unitGUID = UnitGUID(uId)
		if unitGUID and not AddsSeen[unitGUID] then
			AddsSeen[unitGUID] = true
			local cid = self:GetCIDFromGUID(unitGUID)
			if cid == 94185 then--Vanguard Akkelion
				if self.Options.ChainsBehavior == "Applied" then--Sync timer up with applied
					timerFelChainsCD:Start(15)
				else--Sync tiner up with cast
					timerFelChainsCD:Start(12)
				end
				timerFelBlazeFlurryCD:Start(5.5)
			elseif cid == 94239 then--Omnus
				timerWitheringGazeCD:Start(4)
				timerBlackHoleCD:Start(18, 1)
			end
		end
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 94185 then--Vanguard Akkelion
		self.vb.bothDead = self.vb.bothDead + 1
		timerFelBlazeFlurryCD:Stop()
		timerFelChainsCD:Stop()
		if self:IsMythic() then
			timerFelChainsCD:Start(28)
		else
			if playerTanking == 1 then
				playerTanking = 0--Vanguard died, set player tanking to 0
			end
		end
	elseif cid == 94239 then--Omnus
		self.vb.bothDead = self.vb.bothDead + 1
		timerWitheringGazeCD:Stop()
		timerBlackHoleCD:Stop()
		if self:IsMythic() then
			timerEmpBlackHoleCD:Start(18, self.vb.blackHoleCount+1)
		else
			if playerTanking == 2 then
				playerTanking = 0--Omnus died, set player tanking to 0
			end
		end
	elseif cid == 94231 then--Imps
		self.vb.impActive = self.vb.impActive - 1
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 187003 then--Activate Fel Portal
		warnFelPortal:Play("phasechange")
		warnFelPortal:Show()
		if not self:IsLFR() then
			timerImpCD:Start(10)
			self:Schedule(10, ImpRepeater, self)
		end
	elseif spellId == 187006 then--Activate Void Portal
		warnVoidPortal:Play("phasechange")
		warnVoidPortal:Show()
		timerFelStrikeCD:Stop()
		timerFelSurgeCD:Stop()
		if not self:IsLFR() then
			timerVoidsCD:Start(10.5)
			self:Schedule(10.5, VoidsRepeater, self)
		end
		if self:IsMythic() then
			timerVoidStrikeCD:Start(9.5)--Only true in mythic, since phase 3 is triggered at end of this
		end
	elseif spellId == 187225 and not self:IsMythic() then--Phase 2 (Purple Mode). Event happens in mythic but is skipped, so should be ignored for CPU saving
		self.vb.phase = 2
		timerVoidStrikeCD:Start(8.5)--TODO, reverify?
		timerVoidSurgeCD:Start(17.8)--TODO, reverify?
	elseif spellId == 189047 then--Phase 3 (Shadowfel Phasing)
		self.vb.phase = 3
		warnPhase3:Show()
		warnPhase3:Play("phasechange")
		if not self:IsMythic() then
			timerVoidStrikeCD:Stop()--Regardless of what was left on timer, he will use it immediately after shadowfel phasing
		end
		timerVoidSurgeCD:Stop()
		timerFelSurgeCD:Start(7)
		timerFelStrikeCD:Start(8)
		timerVoidSurgeCD:Start(16)--Regardless of what was left on timer, this resets to 16
	elseif spellId == 187209 then--Overwhelming Chaos (Activation)
		self.vb.phase = 4
		timerImpCD:Stop()
		timerVoidsCD:Stop()
		self:Unschedule(ImpRepeater)
		self:Unschedule(VoidsRepeater)
		timerOverwhelmingChaosCD:Start(nil, 1)
	end
end
