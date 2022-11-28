local mod	= DBM:NewMod(1487, "DBM-Party-Legion", 4, 721)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221128001010")
mod:SetCreatureID(95674, 99868)--First engage, Second engage
mod:SetEncounterID(1807)
mod:DisableEEKillDetection()--ENCOUNTER_END fires a wipe when fenryr casts stealth and runs to new location (P2)
mod:SetHotfixNoticeRev(20221127000000)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 196838 196543 197558",
	"SPELL_CAST_SUCCESS 196567 196512 207707",
	"SPELL_AURA_APPLIED 197556 196838",
	"SPELL_AURA_REMOVED 196838",
	"UNIT_DIED"
)

--TODO, Keep checking/fixing timers
--[[
(ability.id = 196838 or ability.id = 196543 or ability.id = 197558) and type = "begincast"
 or (ability.id = 196567 or ability.id = 196512 or ability.id = 207707) and type = "cast"
 or type = "dungeonencounterstart" or type = "dungeonencounterend"
--]]
local warnLeap							= mod:NewTargetAnnounce(197556, 2)
local warnPhase2						= mod:NewPhaseAnnounce(2, 2, nil, nil, nil, nil, nil, 2)
local warnFixate						= mod:NewTargetAnnounce(196838, 3)
local warnClawFrenzy					= mod:NewSpellAnnounce(196512, 2, nil, "Tank")

local specWarnLeap						= mod:NewSpecialWarningMoveAway(197556, nil, nil, nil, 1, 2)
local yellLeap							= mod:NewYell(197556)
local specWarnHowl						= mod:NewSpecialWarningCast(196543, "SpellCaster", nil, nil, 1, 2)
local specWarnFixate					= mod:NewSpecialWarningRun(196838, nil, nil, nil, 4, 2)
local specWarnFixateOver				= mod:NewSpecialWarningEnd(196838, nil, nil, nil, 1)
local specWarnWolves					= mod:NewSpecialWarningSwitch("ej12600", "Tank")

local timerLeapCD						= mod:NewCDTimer(31, 197556, nil, nil, nil, 3)--31-36
--local timerClawFrenzyCD					= mod:NewCDTimer(9.7, 196512, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON)--it is 10 sec, but is spell queued half the time it's not very accurate to enable
local timerHowlCD						= mod:NewCDTimer(31.5, 196543, nil, "SpellCaster", nil, 2)--32ish unless spell queued a little
local timerFixateCD						= mod:NewCDTimer(34.4, 196838, nil, nil, nil, 3)--Poor data, needs more to see if it has lower times
local timerWolvesCD						= mod:NewCDTimer(33.8, "ej12600", nil, nil, nil, 1, 199184)--33.8-41.2

mod:AddRangeFrameOption(10, 197556)

function mod:FixateTarget(targetname, uId)
	if not targetname then return end
	if self:AntiSpam(5, targetname) then
		if targetname == UnitName("player") then
			specWarnFixate:Show()
			specWarnFixate:Play("runaway")
			specWarnFixate:ScheduleVoice(1, "keepmove")
		else
			warnFixate:Show(targetname)
		end
	end
end

function mod:OnCombatStart(delay)
	self:SetWipeTime(5)
	--Initial timers also iffy as hell cause bilities can be a randomized order
--	timerHowlCD:Start(5-delay)
--	timerLeapCD:Start(8.1-delay)
--	timerClawFrenzyCD:Start(19-delay)--22
end

function mod:OnCombatEnd()
	self:UnregisterShortTermEvents()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 196838 then
		timerFixateCD:Start()
		self:BossTargetScanner(99868, "FixateTarget", 0.2, 12, true, nil, nil, nil, true)--Target scanning used to grab target 2-3 seconds faster. Doesn't seem to anymore?
	elseif spellId == 196543 then
		specWarnHowl:Show()
		specWarnHowl:Play("stopcast")
	elseif spellId == 197558 then
		timerLeapCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 196567 then--Stealth (boss retreat)
		--Stop all timers but not combat
		for _, v in ipairs(self.timers) do
			v:Stop()
		end
		--Artificially set no wipe to 30 minutes
		self:SetWipeTime(1800)
		--Scan for Boss to be re-enraged
		self:RegisterShortTermEvents(
			"ENCOUNTER_START",
			"ZONE_CHANGED_NEW_AREA"
		)
	elseif spellId == 196512 then
		warnClawFrenzy:Show()
	elseif spellId == 207707 and self:AntiSpam(2, 1) then--Wolves spawning out of stealth
		specWarnWolves:Show()
		timerWolvesCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 197556 then
		warnLeap:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			specWarnLeap:Show()
			specWarnLeap:Play("runout")
			yellLeap:Yell()
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(10)
			end
		end
	elseif spellId == 196838 then
		--Backup if target scan failed
		if self:AntiSpam(5, args.destName) then
			if args:IsPlayer() then
				specWarnFixate:Show()
				specWarnFixate:Play("runaway")
				specWarnFixate:ScheduleVoice(1, "keepmove")
			else
				warnFixate:Show(args.destName)
			end
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 197556 and args:IsPlayer() and self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	elseif spellId == 196838 and args:IsPlayer() then
		specWarnFixateOver:Show()
	end
end

function mod:ENCOUNTER_START(encounterID)
	--Re-engaged, kill scans and long wipe time
	if encounterID == 1807 and self:IsInCombat() then
--		self:SetWipeTime(5)
--		self:UnregisterShortTermEvents()
		warnPhase2:Show()
		warnPhase2:Play("ptwo")
		--Timers are still iffy but they will be watched in fenryr 2.0
--		timerHowlCD:Start(4.4)
--		timerWolvesCD:Start(6)
		--Any timers after this are even more iffy. I suspect boss retains boss energy or something and needs a better calculation
		--timerLeapCD:Start(9.3)--12-15
		--timerClawFrenzyCD:Start(12)--12-23
		--timerFixateCD:Start(20.2)--25-27.8
	end
end

function mod:UNIT_DIED(args)
	if self:GetCIDFromGUID(args.destGUID) == 99868 then
		DBM:EndCombat(self)
	end
end

function mod:ZONE_CHANGED_NEW_AREA()
	--Left zone
	--Normal wipes respawn you inside
	self:SetWipeTime(5)
	self:UnregisterShortTermEvents()
end
