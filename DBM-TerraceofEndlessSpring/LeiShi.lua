local mod	= DBM:NewMod(729, "DBM-TerraceofEndlessSpring", nil, 320)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("2019041710000")
mod:SetCreatureID(62983)--62995 Animated Protector
mod:SetEncounterID(1506)

mod:RegisterCombat("combat")
mod:RegisterKill("yell", L.Victory)--Kill detection is aweful. No death, no special cast. yell is like 40 seconds AFTER victory. terrible.
mod:SetUsedIcons(8, 7, 6, 5, 4, 3) -- on 25 heroic 6 guards spawn.

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 123250 123505 123461 123121 123705",
	"SPELL_AURA_APPLIED_DOSE 123121 123705",
	"SPELL_AURA_REMOVED 123250 123121 123461",
	"SPELL_CAST_START 123244 123705",
	"UNIT_HEALTH boss1",--UNIT_HEALTH_FREQUENT maybe not needed. It's too high cpu usage.
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

local warnProtect						= mod:NewSpellAnnounce(123250, 2)
local warnHideOver						= mod:NewAnnounce("warnHideOver", 2, 123244)--Because we can. with creativeness, the boss returning is detectable a full 1-2 seconds before even visible. A good signal to stop aoe and get ready to return norm DPS
local warnGetAway						= mod:NewCountAnnounce(123461, 3)
local warnSpray							= mod:NewStackAnnounce(123121, 3, nil, "Tank|Healer")

local specWarnAnimatedProtector			= mod:NewSpecialWarningSwitch("ej6224", "-Healer")
local specWarnHide						= mod:NewSpecialWarningCount(123244, nil, nil, nil, 2)
local specWarnGetAway					= mod:NewSpecialWarningSpell(123461, nil, nil, nil, 2)
local specWarnSpray						= mod:NewSpecialWarningStack(123121, "Tank", 6)
local specWarnSprayOther				= mod:NewSpecialWarningTaunt(123121)

local timerSpecialCD					= mod:NewTimer(50, "timerSpecialCD", 123250, nil, nil, 6)--Variable, 49.5-55 seconds
local timerSpray						= mod:NewTargetTimer(10, 123121, nil, "Tank|Healer", nil, 5)
local timerGetAway						= mod:NewBuffActiveTimer(30, 123461, nil, nil, nil, 6)
local timerScaryFogCD					= mod:NewNextTimer(10, 123705)

local berserkTimer						= mod:NewBerserkTimer(600)

mod:AddBoolOption("RangeFrame", true)
mod:AddSetIconOption("SetIconOnProtector", "ej6224", false, true)

local specialsCast = 0
local hideActive = false
local lastProtect = 0
local specialRemaining = 0
local lostHealth = 0
local prevlostHealth = 0
local hideTime = 0
local hideName = DBM:GetSpellInfo(123244)

local bossTank
do
	bossTank = function(uId)
		return mod:IsTanking(uId, "boss1")
	end
end

function mod:ScaryFogRepeat()
	timerScaryFogCD:Cancel()
	self:UnscheduleMethod("ScaryFogRepeat")
	local interval = 10 * (1/(1+lostHealth))--Seems that Scray Fog interval reduced by her casting speed. / EJ lies? seems on heroic, her casting speed increases by 1% per 1% health lost. (lfr: 0.8, normal: 0.9, heroic: 1.0?)
	timerScaryFogCD:Start(interval)
	self:ScheduleMethod(interval, "ScaryFogRepeat")
end

function mod:OnCombatStart(delay)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(3, bossTank)
	end
	hideTime = 0
	specialsCast = 0
	hideActive = false
	lastProtect = 0
	specialRemaining = 0
	lostHealth = 0
	prevlostHealth = 0
	timerSpecialCD:Start(30.5-delay, 1)--Variable, 30.5-37 (or aborted if 80% protect happens first)
	if self:IsHeroic() then
		berserkTimer:Start(420-delay)
	else
		berserkTimer:Start(-delay)
	end
end

function mod:OnCombatEnd()
	self:UnregisterShortTermEvents()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 123250 then
		local elapsed, total = timerSpecialCD:GetTime(specialsCast+1)
		specialRemaining = total - elapsed
		lastProtect = GetTime()	
		warnProtect:Show()
		specWarnAnimatedProtector:Show()
		self:Schedule(0.2, function()
			timerSpecialCD:Cancel()
		end)
	elseif spellId == 123505 and self.Options.SetIconOnProtector then
		self:ScanForMobs(args.destGUID, 0, 8, nil, 0.05, 6)
	elseif spellId == 123461 then
		specialsCast = specialsCast + 1
		warnGetAway:Show(specialsCast)
		specWarnGetAway:Show()
		timerSpecialCD:Start(nil, specialsCast+1)
		if self:IsHeroic() then
			timerGetAway:Start(45)
		else
			timerGetAway:Start()
		end
	elseif spellId == 123121 then
		local uId = DBM:GetRaidUnitId(args.destName)
		if self:IsTanking(uId, "boss1") then--Only want sprays that are on tanks, not bads standing on tanks.
			local amount = args.amount or 1
			timerSpray:Start(args.destName)
			if amount % 3 == 0 then
				warnSpray:Show(args.destName, amount)
				if amount >= 6 and args:IsPlayer() then
					specWarnSpray:Show(amount)
				else
					if amount >= 6 and not DBM:UnitDebuff("player", args.spellName) and not UnitIsDeadOrGhost("player") then
						specWarnSprayOther:Show(args.destName)
					end
				end
			end
		end
	elseif spellId == 123705 and self:AntiSpam(2.5, 1) then
		self:ScaryFogRepeat()
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 123250 then
		if timerSpecialCD:GetTime(specialsCast+1) == 0 then -- failsafe. (i.e : 79.8% hide -> protect... bar remains)
			local protectElapsed = GetTime() - lastProtect
			local specialCD = specialRemaining - protectElapsed
			if specialCD < 5 then 
				timerSpecialCD:Start(5, specialsCast+1)
			else
				timerSpecialCD:Start(specialCD, specialsCast+1)
			end
		end
	elseif spellId == 123121 then
		timerSpray:Cancel(args.destName)
	elseif spellId == 123461 then
		timerGetAway:Cancel()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 123244 then
		hideTime = GetTime()
		specialsCast = specialsCast + 1
		hideActive = true
		timerScaryFogCD:Cancel()
		self:UnscheduleMethod("ScaryFogRepeat")
		specWarnHide:Show(specialsCast)
		timerSpecialCD:Start(nil, specialsCast+1)
		self:SetWipeTime(60)--If she hides at 1.6% or below, she will be killed during hide. In this situration, yell fires very slowly. This hack can prevent recording as wipe.
		self:RegisterShortTermEvents(
			"INSTANCE_ENCOUNTER_ENGAGE_UNIT"--We register on hide, because it also fires just before hide, every time and don't want to trigger "hide over" at same time as hide.
		)
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(3)--Show everyone during hide
		end
	elseif spellId == 123705 then
		self:ScaryFogRepeat()
	end
end

function mod:UNIT_HEALTH(uId)
	local currentHealth = 1 - (UnitHealth(uId) / UnitHealthMax(uId))
	if currentHealth and currentHealth < 1 and currentHealth > prevlostHealth then -- Failsafe.
		lostHealth = currentHealth
		prevlostHealth = currentHealth
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 127524 then
		DBM:EndCombat(self)
	end	
end

--Fires twice when boss returns, once BEFORE visible (and before we can detect unitID, so it flags unknown), then once a 2nd time after visible
--"<233.9> [INSTANCE_ENCOUNTER_ENGAGE_UNIT] Fake Args:#nil#nil#Unknown#0xF130F6070000006C#normal#0#nil#nil#nil#nil#normal#0#nil#nil#nil#nil#normal#0#nil#nil#nil#nil#normal#0#Real Args:", -- [14168]
function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT(event)
	if hideActive then
        hideActive = false
		return
	end
	self:SetWipeTime(3)
	self:UnregisterShortTermEvents()--Once boss appears, unregister event, so we ignore the next two that will happen, which will be 2nd time after reappear, and right before next Hide.
	warnHideOver:Show(hideName)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(3, bossTank)--Go back to showing only tanks
	end
end
