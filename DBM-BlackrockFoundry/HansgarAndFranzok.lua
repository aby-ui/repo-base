local mod	= DBM:NewMod(1155, "DBM-BlackrockFoundry", nil, 457)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143352")
mod:SetCreatureID(76974, 76973)
mod:SetEncounterID(1693)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 160838 160845 160847 160848 153470",
	"UNIT_SPELLCAST_SUCCEEDED boss1 boss2",
	"UNIT_TARGETABLE_CHANGED"
)

--TODO, find target scanning for skullcracker. Also, find out how it behaves when it's more than 1 target (just recast?)
--TODO, collect more data to figure out how roar starts/resumes on jump down. One pull/kill is not a sufficient sampling.
local warnSkullcracker					= mod:NewSpellAnnounce(153470, 3, nil, false)--This seems pretty worthless.
local warnJumpSlam						= mod:NewTargetCountAnnounce("ej9854", 3)--Find pretty icon

local specWarnJumpSlam					= mod:NewSpecialWarningYou("ej9854", nil, nil, nil, 1, 2)
local specWarnJumpSlamNear				= mod:NewSpecialWarningClose("ej9854", nil, nil, nil, 1, 2)
local yellJumpSlam						= mod:NewYell("ej9854")
local specWarnDisruptingRoar			= mod:NewSpecialWarningCast(160838, "SpellCaster", nil, 2, nil, 2)
--Move specWarnCripplingSupplex to a health check, warn when near 85, 55, or 25%
local specWarnCripplingSupplex			= mod:NewSpecialWarningPreWarn(156938, "Tank|Healer", 3, nil, 3, 3)--pop a cooldown.
local specWarnSearingPlates				= mod:NewSpecialWarningSpell(161570, nil, nil, nil, 2, 2)
local specWarnStampers					= mod:NewSpecialWarningSpell(174825, nil, nil, nil, 2, 2)
local specWarnSearingPlatesEnd			= mod:NewSpecialWarningEnd(161570, nil, nil, nil, 1, 2)
local specWarnStampersEnd				= mod:NewSpecialWarningEnd(174825, nil, nil, nil, 1, 2)

local timerDisruptingRoar				= mod:NewCastTimer(2.5, 160838, nil, "SpellCaster")
local timerDisruptingRoarCD				= mod:NewCDTimer(45, 160838, nil, "SpellCaster")
local timerSkullcrackerCD				= mod:NewCDTimer(22, 153470, nil, "Healer", nil, 5, nil, DBM_CORE_HEALER_ICON)
local timerCripplingSupplex				= mod:NewCastTimer(9.5, 156938, nil, "Tank|Healer", nil, 5, nil, DBM_CORE_TANK_ICON, nil, 2, 4)
local timerJumpSlamCD					= mod:NewNextTimer(34, "ej9854", nil, nil, nil, 3)
mod:AddTimerLine(ENCOUNTER_JOURNAL_SECTION_FLAG12)
local timerSmartStamperCD				= mod:NewNextTimer(12, 162124, nil, nil, nil, 6, nil, DBM_CORE_HEROIC_ICON, nil, 1, 4)--Activation

--local berserkTimer						= mod:NewBerserkTimer(360)

mod.vb.phase = 1
mod.vb.stamperDodgeCount = 0
mod.vb.bossUp = "NoBody"
mod.vb.firstJump = false
mod.vb.jumpCount = 0
local cachedGUID = nil

function mod:JumpTarget(targetname, uId)
	if not targetname then return end
	self.vb.jumpCount = self.vb.jumpCount + 1
	if targetname == UnitName("player") then
		specWarnJumpSlam:Show()
		specWarnJumpSlam:Play("targetyou")
		yellJumpSlam:Yell()
	elseif self:CheckNearby(12, targetname) then--Near warning disabled on mythic, mythic mechanic requires being near it on purpose. Plus raid always stacked
		specWarnJumpSlamNear:Show(targetname)
		specWarnJumpSlamNear:Play("runaway")
	else
		warnJumpSlam:Show(self.vb.jumpCount, targetname)--No reason to show this if you got a special warning. so reduce spam and display this only to let you know jump is far away and you're safe
	end
	self:BossTargetScanner(76973, "JumpTarget", 0.2, 40, true, nil, nil, targetname)
end

function mod:OnCombatStart(delay)
	self.vb.phase = 1
	self.vb.stamperDodgeCount = 0
	self.vb.bossUp = "NoBody"
	self.vb.firstJump = false
	timerSkullcrackerCD:Start(20-delay)
	timerJumpSlamCD:Start(20.5-delay)
	timerDisruptingRoarCD:Start(-delay)
	if self:IsMythic() then
		timerSmartStamperCD:Start(13-delay)
--		berserkTimer:Start(-delay)
	end
end

function mod:OnCombatEnd()

end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if args:IsSpellID(160838, 160845, 160847, 160848) then
		specWarnDisruptingRoar:Show()
		timerDisruptingRoarCD:Start()
		specWarnDisruptingRoar:Play("stopcast")
		local uId = DBM:GetUnitIdFromGUID(args.sourceGUID)
		if uId then
			local _, _, _, startTime, endTime = UnitCastingInfo(uId)
			local time = ((endTime or 0) - (startTime or 0)) / 1000
			if time then
				timerDisruptingRoar:Start(time)
			end
		end
	elseif spellId == 153470 then
		warnSkullcracker:Show()
		timerSkullcrackerCD:Stop()--avoid false timer debug if boss cancels cast to dodge stamper then starts cast again
		timerSkullcrackerCD:Start()
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if (spellId == 156220 or spellId == 156883) and self.vb.bossUp == "NoBody" then--Tactical Retreat (156883 has lots of invalid casts, so self.vb.bossUp to filter)
		self.vb.phase = self.vb.phase + 1
		DBM:Debug("Tactical Retreat "..UnitName(uId)..". Phase:"..self.vb.phase)
		self.vb.stamperDodgeCount = 0
		self.vb.bossUp = UnitName(uId)
		local cid = self:GetCIDFromGUID(UnitGUID(uId))
		if cid == 76974 then--Fran
			timerDisruptingRoarCD:Stop()
			timerSkullcrackerCD:Stop()
		elseif cid == 76973 then--Hans
			timerJumpSlamCD:Stop()
		end
		self:BossTargetScannerAbort(76973, "JumpTarget")--Seems to interrupt jumping if EITHER boss jumps up
		--The triggers are these percentages for sure but there is a delay before they do it so it always appears later, but the trigger has been triggered
		if self.vb.phase == 2 then--First belt 85% (15 Energy) (fire plates)
			specWarnSearingPlates:Show()
			specWarnSearingPlates:Play("watchstep")
		elseif self.vb.phase == 3 then--Second belt 55% (45 Energy) (Stampers)
			specWarnStampers:Show()
			specWarnStampers:Play("watchstep")
		elseif self.vb.phase == 4 then--Second belt 25% (75 Energy) (Fire plates, then stampers)
			specWarnSearingPlates:Show()
			specWarnSearingPlates:Play("watchstep")	
		end
	elseif spellId == 156546 or spellId == 156542 then
		specWarnCripplingSupplex:Schedule(6)--warn 3 seconds before, stun removed in 6.1
		timerCripplingSupplex:Start()
	elseif spellId == 157926 then--Jump Activation
		self.vb.firstJump = false--So reset firstjump
		self.vb.jumpCount = 0
		DBM:Debug("157926: Jump Activation")
		cachedGUID = UnitGUID(uId)
		timerJumpSlamCD:Start()
	elseif spellId == 157922 then--First jump must use 157922
		local temptarget = UnitName(uId.."target") or "nil"
		if not self.vb.firstJump then
			DBM:Debug("157922: firstJump true")
			self.vb.firstJump = true
			self:BossTargetScanner(76973, "JumpTarget", 0.1, 80, true)--Don't include tank in first scan should be enough of a filter for first, it'll grab whatever first non tank target he gets and set that as first jump target and it will be valid
		else--Not first jump
			DBM:Debug("157922: firstJump false")
		end
	elseif spellId == 157925 then--Jump Slam (this id seems to fire when ended)
		DBM:Debug("157925: jumps ended")
		self:BossTargetScannerAbort(76973, "JumpTarget")
	end
end

--Currently functional on 6.0.3. But yell method may still be needed in 6.1
function mod:UNIT_TARGETABLE_CHANGED(uId)
	if UnitExists(uId) then--Return, not retreat
		local cid = self:GetCIDFromGUID(UnitGUID(uId))
		if cid == 76973 then--Hansgar
			timerJumpSlamCD:Start(6.8)
		end
		self.vb.bossUp = "NoBody"
		if self.vb.phase == 4 then--Stampers activate on their own after 3rd jump away, when they return.
			specWarnStampers:Show()
			specWarnStampers:Play("watchstep")
		else
			if self.vb.phase == 2 then
				specWarnSearingPlatesEnd:Show()
				if self:IsMythic() then
					timerSmartStamperCD:Start()
					specWarnSearingPlatesEnd:Play("gather")--Must restack for smart stampers
				else
					specWarnSearingPlatesEnd:Play("safenow")
				end
			else
				specWarnStampersEnd:Show()
				if self:IsMythic() then
					timerSmartStamperCD:Start()
					specWarnStampersEnd:Play("gather")--Must restack for smart stampers
				else
					specWarnStampersEnd:Play("safenow")
				end
			end
		end
	end
end
