local mod	= DBM:NewMod(1432, "DBM-HellfireCitadel", nil, 669)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143352")
mod:SetCreatureID(92142, 92144, 92146)--Blademaster Jubei'thos (92142). Dia Darkwhisper (92144). Gurthogg Bloodboil (92146) 
mod:SetEncounterID(1778)
mod:SetZone()
--mod:SetUsedIcons(8, 7, 6, 4, 2, 1)
mod:SetBossHPInfoToHighest()
--mod.respawnTime = 20

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 184657 184476",
	"SPELL_CAST_SUCCESS 183480 184357 184355 184476",
	"SPELL_AURA_APPLIED 183701 184847 184360 184365 184449 184450 185065 185066 184652 184355",
	"SPELL_AURA_APPLIED_DOSE 184847 184355",
--	"SPELL_AURA_REMOVED",
	"SPELL_DAMAGE 186993",
	"SPELL_MISSED 186993",
	"SPELL_PERIODIC_DAMAGE 184652",
	"SPELL_PERIODIC_MISSED 184652",
	"UNIT_DIED",
	"RAID_BOSS_EMOTE",
	"UNIT_SPELLCAST_SUCCEEDED boss1 boss2 boss3"
)

local Dia		= DBM:EJ_GetSectionInfo(11489)
local Jubei		= DBM:EJ_GetSectionInfo(11488)
local Gurtogg	= DBM:EJ_GetSectionInfo(11490)

--(target.id = 92142 or target.id = 92144 or target.id = 92146) and type = "death" or (ability.id = 184657 or ability.id = 184476 or ability.id = 184355) and type = "begincast" or (ability.id = 184449 or ability.id = 183480 or ability.id = 184357) and type = "cast" or (ability.id = 183701 or ability.id = 184360 or ability.id = 184365) and type = "applydebuff" or ability.id = 184674
--TODO, add bloodboil. mythic only?
--Blademaster Jubei'thos
local warnMirrorImage				= mod:NewSpellAnnounce(183885, 2)
--Dia Darkwhisper
local warnMarkoftheNecromancer		= mod:NewTargetAnnounce(184449, 4, nil, false)--Off by default until i verify sp ellid, i don't want announce spam cause i guessed wrong one
local warnReapDelayed				= mod:NewAnnounce("reapDelayed", 2, 184476)
local warnReap						= mod:NewSpellAnnounce(184476, 4)--Generic warning if you don't have reap, just to know it's going on
--Gurtogg Bloodboil
local warnAcidicWound				= mod:NewStackAnnounce(184847, 2, nil, false, 2)--As of PTR, this required no swaps, just the person with fel rage pulling boss away from tank long enough to clear stacks
local warnFelRage					= mod:NewTargetCountAnnounce(184360, 4)

--Blademaster Jubei'thos
local specWarnFelstorm				= mod:NewSpecialWarningSpell(183701, nil, nil, nil, 2, 2)
--Dia Darkwhisper
local specWarnNightmareVisage		= mod:NewSpecialWarningCount(184657)--Doesn't option default, only warns highest threat
local specWarnReap					= mod:NewSpecialWarningMoveAway(184476, nil, nil, nil, 3, 2)--Everyone with Mark of Necromancer is going to drop void zones that last forever, they MUST get the hell out
local specWarnReapGTFO				= mod:NewSpecialWarningMove(30533, nil, DBM_CORE_AUTO_SPEC_WARN_OPTIONS.move:format(184652), nil, 1, 2)--On the ground version (GTFO)
local yellReap						= mod:NewYell(184476)
local specWarnDarkness				= mod:NewSpecialWarningSpell(184681, nil, nil, nil, 2)
--Gurtogg Bloodboil
local specWarnFelRage				= mod:NewSpecialWarningYou(184360)
local specWarnDemolishingLeap		= mod:NewSpecialWarningDodge(184366, nil, nil, nil, 2, 2)--Jumps around room, from side to side
local specWarnBloodBoil				= mod:NewSpecialWarningStack(184355, nil, 3)

mod:AddTimerLine(Jubei)
--Blademaster Jubei'thos
--local timerFelstormCD				= mod:NewCDTimer(30.5, 183701, nil, nil, nil, 2)
local timerMirrorImage				= mod:NewBuffActiveTimer(51.5, 183885, nil, nil, nil, 6, nil, nil, nil, 1, 5)--About 51.5
local timerMirrorImageCD			= mod:NewCDTimer(75, 183885, nil, nil, nil, 1)
local timerWickedStrikeCD			= mod:NewCDTimer(10.5, 186993, nil, nil, nil, 2)
mod:AddTimerLine(Dia)
--Dia Darkwhisper
local timerMarkofNecroCD			= mod:NewCDTimer(60, 184449, 28836, "Healer", nil, 5, nil, DBM_CORE_HEALER_ICON)
local timerReapCD					= mod:NewCDTimer(54, 184476, nil, nil, nil, 3, nil, nil, nil, 2, 4)--54-71
local timerNightmareVisageCD		= mod:NewCDTimer(30, 184657, nil, "Tank", nil, 5, nil, DBM_CORE_TANK_ICON)
local timerDarknessCD				= mod:NewCDTimer(75, 184681, nil, nil, nil, 2, nil, DBM_CORE_DEADLY_ICON, nil, 1, 5)
mod:AddTimerLine(Gurtogg)
--Gurtogg Bloodboil
local timerFelRageCD				= mod:NewCDCountTimer(60, 184360, nil, nil, nil, 3)--60-84 (maybe this is HP based, cause this variation is stupid)
local timerDemoLeapCD				= mod:NewCDTimer(75, 184366, nil, nil, nil, 2, nil, nil, nil, 1, 5)--Most will never see this ability since he's 3rd in the special rotation and he dies first in most strats
local timerTaintedBloodCD			= mod:NewNextCountTimer(15.8, 184357)
local timerBloodBoilCD				= mod:NewCDTimer(7.3, 184355, nil, false, nil, 3, nil, DBM_CORE_HEROIC_ICON)

local berserkTimer					= mod:NewBerserkTimer(600)

mod:AddRangeFrameOption(8, 184476)

mod.vb.DiaPushed = false
mod.vb.taintedBloodCount = 0
mod.vb.felRageCount = 0
mod.vb.diaDead = false
mod.vb.jubeiGone = false
mod.vb.jubeiDead = false
mod.vb.bloodboilDead = false
mod.vb.reapActive = false
--mod.vb.firstReap = false
mod.vb.visageCount = 0
local felRageTimers = {28, 64.2, 75}--Post august 14th hotfix timers.
local UnitExists, UnitGUID, UnitDetailedThreatSituation = UnitExists, UnitGUID, UnitDetailedThreatSituation
local markofNecroDebuff = DBM:GetSpellInfo(184449)--Spell name should work, without knowing what right spellid is, For this anyways.

--[[local function delayedReapCheck(self)
	--Fires 55 seconds after combat start, unless 50 second reap happens.
	if not self.vb.firstReap then--reap wasn't cast at 50 seconds, it'll be cast at 65+

	end
end--]]

--[[
--Fel rage variation table
30, 80, 63
31, 81, 60, 85
31, 81, 61
31, 81
31, 81
31, 80
30, 82
28, 80
31, 81, 61
--]]

function mod:OnCombatStart(delay)
	self.vb.DiaPushed = false
	self.vb.diaDead = false
	self.vb.jubeiGone = false
	self.vb.jubeiDead = false
	self.vb.bloodboilDead = false
	self.vb.reapActive = false
	self.vb.taintedBloodCount = 0
	self.vb.felRageCount = 0
	self.vb.visageCount = 0
	timerMarkofNecroCD:Start(7-delay)--7-13
	timerNightmareVisageCD:Start(15-delay)
--	timerFelstormCD:Start(20.5-delay)--Review
	timerFelRageCD:Start(28-delay, 1)--Almost always 30-31. but in rare cases i've seen as early as 28
	timerReapCD:Start(50-delay)--50-73 variation on pull. It's USUALLY between 65-67, because it's delayed by visage. But not always: reason https://www.warcraftlogs.com/reports/HN42ftpvVk3BYQjJ#fight=5&type=summary&view=events&pins=2%24Off%24%23244F4B%24expression%24(target.id+%3D+92142+or+target.id+%3D+92144+or+target.id+%3D+92146)+and+type+%3D+%22death%22+or+(ability.id+%3D+184657+or+ability.id+%3D+184476+or+ability.id+%3D+184355)+and+type+%3D+%22begincast%22+or+(ability.id+%3D+184449+or+ability.id+%3D+183480+or+ability.id+%3D+184357)+and+type+%3D+%22cast%22+or+(ability.id+%3D+183701+or+ability.id+%3D+184360+or+ability.id+%3D+184365)+and+type+%3D+%22applydebuff%22+or+ability.id+%3D+184674
	timerDarknessCD:Start(75-delay)
	berserkTimer:Start(-delay)
--	self:Schedule(55, delayedReapCheck, self)
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end 

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 184657 then
		self.vb.visageCount = self.vb.visageCount + 1
		timerNightmareVisageCD:Start(nil, self.vb.visageCount+1)
		for i = 1, 5 do--Maybe only 1-3 needed, but don't know if any adds take boss IDs, plus, it'll abort when it finds right one anyways
			local bossUnitID = "boss"..i
			if UnitExists(bossUnitID) and UnitGUID(bossUnitID) == args.sourceGUID and UnitDetailedThreatSituation("player", bossUnitID) then--We are highest threat target
				specWarnNightmareVisage:Show(self.vb.visageCount)--Show warning only to the tank she's on, not both tanks, avoid confusion
				break
			end
		end
		if not self.vb.DiaPushed then
			local elapsed, total = timerReapCD:GetTime()
			local remaining = total - elapsed
			if remaining < 16.5 then--delayed by visage
				timerReapCD:Stop()
				warnReapDelayed:Schedule(11.5)
				if total == 0 then--Pull reap delayed by visage
					DBM:Debug("experimental timer extend firing for reap. Extend amount: "..16.5)
					timerReapCD:Start(16.5)
				else
					local extend = 16.5 - remaining
					DBM:Debug("experimental timer extend firing for reap. Extend amount: "..extend)
					timerReapCD:Update(elapsed, total+extend)
				end
			end
		end
	elseif spellId == 184476 then
		timerMarkofNecroCD:Start(14)--Always 14 seconds after reap
--		if not self.vb.firstReap then
--			self.vb.firstReap = true
--			self:Unschedule(delayedReapCheck)
--		end
		self.vb.reapActive = true
		if not self.vb.DiaPushed then--Don't start cd timer for her final reap she casts at 30%
			timerReapCD:Start()
		end
		if DBM:UnitDebuff("player", markofNecroDebuff) and self:AntiSpam(5, 5) then
			specWarnReap:Show()
			yellReap:Yell()
			specWarnReap:Play("runout")
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(8)
			end
		else
			warnReap:Show()
		end
	elseif spellId == 184355 then
		timerBloodBoilCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 183480 and self:AntiSpam(8, 1) then
		self.vb.jubeiGone = true
		warnMirrorImage:Show()
		timerMirrorImage:Start()
		if not self.vb.bloodboilDead then--Leap is next if bloodboil not dead
			timerDemoLeapCD:Start(72.8)
		elseif not self.vb.diaDead then--Bloodboil is dead but dia isn't, darkness next
			timerDarknessCD:Start(72.8)
		else--Only Jubei left, mirror images will be next
			timerMirrorImageCD:Start(72.8)
		end
	elseif spellId == 184357 then
		self.vb.taintedBloodCount = self.vb.taintedBloodCount + 1
		timerTaintedBloodCD:Start(nil, self.vb.taintedBloodCount+1)
	elseif spellId == 184476 then
		self.vb.reapActive = false
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 183701 and args:GetDestCreatureID() == 92142 then--Only warn when jubei uses, not mirror image spam
		specWarnFelstorm:Show()
		specWarnFelstorm:Play("aesoon")
--		timerFelstormCD:Start()
	elseif spellId == 184847 and self:AntiSpam(4, 2) then--Probably stacks very rapidly, so using antispam for now until better method constructed
		local amount = args.amount or 1
		local uId = DBM:GetRaidUnitId(args.destName)
		if self:IsTanking(uId) then
			warnAcidicWound:Show(args.destName, amount)
		end
	elseif spellId == 184360 then
		self.vb.felRageCount = self.vb.felRageCount + 1
		local cooldown = felRageTimers[self.vb.felRageCount+1]
		if cooldown then
			timerFelRageCD:Start(cooldown, self.vb.felRageCount+1)
		else--Just start 60 second timer if we don't know timer
			timerFelRageCD:Start(nil, self.vb.felRageCount+1)
		end
		if args:IsPlayer() then
			specWarnFelRage:Show()
		else
			warnFelRage:Show(self.vb.felRageCount, args.destName)
		end
	elseif spellId == 184365 and not args:IsDestTypePlayer() then--IsDestTypePlayer because it could be wrong spellid and one applied to players when he lands on them, so to avoid spammy mess, filter
		specWarnDemolishingLeap:Show()
		specWarnDemolishingLeap:Play("runaway")
		if not self.vb.diaDead then--Dia is next in natural order, unless dead
			timerDarknessCD:Start()
		elseif not self.vb.jubeiDead then--Jubi if dia is dead.
			timerMirrorImageCD:Start()
		else--Only bloodboil is left, leap will repeat
			timerDemoLeapCD:Start()
		end
	elseif spellId == 184449 then--Confirmed correct CAST spellid (new targets from boss)
		warnMarkoftheNecromancer:CombinedShow(0.3, args.destName)
	elseif (spellId == 184450 or spellId == 185065 or spellId == 185066) and self.vb.reapActive and args:IsPlayer() and self:AntiSpam(5, 5) then--Dispel IDs.
		specWarnReap:Show()
		yellReap:Yell()
		specWarnReap:Play("runout")
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(8)--Guessed, could be 10
		end
	elseif spellId == 184652 and args:IsPlayer() and self:AntiSpam(1.75, 3) then
		specWarnReapGTFO:Show()
		specWarnReapGTFO:Play("runaway")
	elseif spellId == 184355 then
		local amount = args.amount or 1
		if not self:IsTank() and args:IsPlayer() and amount >= 3 then
			specWarnBloodBoil:Show(amount)
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

--[[
function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 155323 then
		if args:IsPlayer() and self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
	end
end--]]

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 92144 then--Dia Darkwhisper
		DBM:Debug("Dia died", 2)
		self.vb.diaDead = true
		timerMarkofNecroCD:Stop()
		timerNightmareVisageCD:Stop()
		local elapsed, total = timerDarknessCD:GetTime()
		timerDarknessCD:Stop()
		if elapsed > 0 then--Timer existed, which means it was next
			DBM:Debug("updating specials timer", 2)
			--So now we update next based on remaining bosses
			if not self.vb.jubeiDead then--Images next if jubei lives
				timerMirrorImageCD:Update(elapsed, total)
			else--Only bloodboil left, leap
				timerDemoLeapCD:Update(elapsed, total)
			end
		end
	--His doesn't work, other 2 do
	elseif cid == 92142 and not self.vb.jubeiDead then--Blademaster Jubei'thosr
		DBM:Debug("Jubei died (CLEU)", 2)
		self.vb.jubeiDead = true
		--timerFelstormCD:Stop()
		local elapsed, total = timerMirrorImageCD:GetTime()
		timerMirrorImageCD:Stop()
		if elapsed > 0 then--Timer existed, which means it was next
			DBM:Debug("updating specials timer", 2)
			--So now we update next based on remaining bosses
			if not self.vb.bloodboilDead then--Leap is next if bloodboil not dead
				timerDemoLeapCD:Update(elapsed, total)
			else--Only dia left left, darkness will be next
				timerDarknessCD:Update(elapsed, total)
			end
		end
	elseif cid == 92146 then--Gurthogg Bloodboil
		DBM:Debug("Gurthogg died", 2)
		self.vb.bloodboilDead = true
		timerFelRageCD:Stop()
		timerTaintedBloodCD:Stop()
		local elapsed, total = timerDemoLeapCD:GetTime()
		timerDemoLeapCD:Stop()
		if elapsed > 0 then--Timer existed, which means it was next
			DBM:Debug("updating specials timer", 2)
			--So now we update next based on remaining bosses
			if not self.vb.diaDead then--Dia lives, darkness next
				timerDarknessCD:Update(elapsed, total)
			else--Only jubei left, images.
				timerMirrorImageCD:Update(elapsed, total)
			end
		end
	end
end

function mod:RAID_BOSS_EMOTE(msg, npc)
	if msg:find("spell:184681") then
		specWarnDarkness:Show()
		if not self.vb.jubeiDead then--jubei is next in natural order, unless dead
			timerMirrorImageCD:Start()
		elseif not self.vb.bloodboilDead then--Bloodboil wasn't dead but jubei is, leap is next
			timerDemoLeapCD:Start()
		else--Only dia is left, darkness will repeat
			timerDarknessCD:Start()
		end
	elseif npc == Jubei and self.vb.jubeiGone then--Jubei Returning
		self.vb.jubeiGone = false
		timerMirrorImage:Stop()
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 187183 then--Mark of the Necromancer (30% version that marks half of enemies, Dia)
		self.vb.DiaPushed = true
		timerReapCD:Stop()
	--"<116.00 21:54:41> [UNIT_SPELLCAST_SUCCEEDED] Blademaster Jubei'thos(Omegal) [[boss2:Ghostly::0:190618]]", -- [7030]
	--"<116.05 21:54:41> [CHAT_MSG_MONSTER_YELL] CHAT_MSG_MONSTER_YELL#I am everburning!#Blademaster Jubei'thos#####0#0##0#196#nil#0#false#false#false", -- [7037]
	elseif spellId == 190618 and not self.vb.jubeiDead then--Jubei Dying
		DBM:Debug("Jubei died (UNIT_SPELLCAST_SUCCEEDED)", 2)
		self.vb.jubeiDead = true
		--timerFelstormCD:Stop()
		local elapsed, total = timerMirrorImageCD:GetTime()
		timerMirrorImageCD:Stop()
		if elapsed > 0 then--Timer existed, which means it was next
			DBM:Debug("updating specials timer", 2)
			--So now we update next based on remaining bosses
			if not self.vb.bloodboilDead then--Leap is next if bloodboil not dead
				timerDemoLeapCD:Update(elapsed, total)
			else--Only dia left left, darkness will be next
				timerDarknessCD:Update(elapsed, total)
			end
		end
	end
end

--Have to use damave event for wickedstrike because the Unit event becomes invisible once he dies.
function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 186993 and destGUID == UnitGUID("player") and self:AntiSpam(2, 4) then
		timerWickedStrikeCD:Start()
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 184652 and destGUID == UnitGUID("player") and self:AntiSpam(1.75, 3) then
		specWarnReapGTFO:Show()
		specWarnReapGTFO:Play("runaway")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE
