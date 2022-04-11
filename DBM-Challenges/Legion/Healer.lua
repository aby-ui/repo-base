local mod	= DBM:NewMod("ArtifactHealer", "DBM-Challenges", 3)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "normal,timewalker"

mod:SetRevision("20220409212508")
mod:SetCreatureID(118488)--Lord Erdris Thorn
mod.soloChallenge = true

mod:RegisterCombat("combat")
mod:SetWipeTime(600)--This mod lets you leave combat for as long as you want, so basically have to hard disable auto wipe detection
mod:SetReCombatTime(20, 5)--Basically killing of recombat restriction. mage tower lets you spam retry, we want the mod to let you
mod:SetZone(1220, 1710)--doesn't need fully disabled zone detection, can only be queuedd from broken shore

mod:RegisterEvents(
	"ZONE_CHANGED_NEW_AREA",
	"LOADING_SCREEN_DISABLED"
)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 235823",
	"SPELL_AURA_APPLIED 235984 237188",
	"SPELL_AURA_APPLIED_DOSE 235833",
	"UNIT_DIED"
)
--Notes:
--TODO, all. mapids, mob iDs, win event to stop timers (currently only death event stops them)
--TODO, stage 2 detection
--TODO< probably won't need both LSD and ZCNA, just gotta fix core before testing which one is ideal
--Healer
-- Need ignite soul equiv name/ID.
-- Need fear name/Id

local warnArcaneBlitz		= mod:NewStackAnnounce(235833, 2)

local specWarnManaSting		= mod:NewSpecialWarningMoveTo(235984, nil, nil, nil, 1, 2)
local specWarnArcaneBlitz	= mod:NewSpecialWarningStack(235833, nil, 4, nil, nil, 1, 6)--Fine tune the numbers
local specWarnIgniteSoul	= mod:NewSpecialWarningYou(237188, nil, nil, nil, 3, 2)
local specWarnKnifeDance	= mod:NewSpecialWarningInterrupt(235823, nil, nil, nil, 1, 2)

--local timerEarthquakeCD	= mod:NewNextTimer(60, 237950, nil, nil, nil, 2)
local timerIgniteSoulCD		= mod:NewAITimer(18, 237188, nil, nil, nil, 3, nil, DBM_COMMON_L.DEADLY_ICON, nil, 3, 4)

function mod:OnCombatStart(delay)
	self:SetStage(1)
end

--Fix for not starting combat on initial mod load
--local currentZoneID = select(8, GetInstanceInfo())
--if currentZoneID == 1710 then
--	DBM:Schedule(1, DBM.StartCombat, DBM, mod, 0, "Hack")
--end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 235833 then
		local amount = args.amount or 1
		if amount % 2 == 0 then
			if amount >= 4 then
				specWarnArcaneBlitz:Show(amount)
				specWarnArcaneBlitz:Play("stackhigh")
			else
				warnArcaneBlitz:Show(args.destName, amount)
			end
		end
	elseif spellId == 235984 and args:IsPlayer() then
		specWarnManaSting:Show(DBM_COMMON_L.ALLY)
		specWarnManaSting:Play("findshelter")
	elseif spellId == 237188 then
		specWarnIgniteSoul:Show()
		specWarnIgniteSoul:Play("targetyou")
		timerIgniteSoulCD:Start()
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_CAST_START(args)
	if args.spellId == 235823 then
		specWarnKnifeDance:Show(args.sourceName)
		specWarnKnifeDance:Play("kickcast")
	end
end

do
	local friendlyNPCS = {
		[118447] = true,--Commander Jarod Shadowsong
		[118448] = true,--Granny Marl
		[118451] = true--Callie Carrington
	}

	function mod:UNIT_DIED(args)
		local cid = self:GetCIDFromGUID(args.destGUID)
		if friendlyNPCS[cid] then
			DBM:EndCombat(self, true)
		end
	end
end

do
	local function delayedZoneCheck(self)
		if DBM:GetCurrentArea() == 1710 then
			DBM:StartCombat(self, 0, "Hack")
		elseif DBM:GetCurrentArea() ~= 1710 then
			DBM:EndCombat(self, true)
		end
	end
	function mod:LOADING_SCREEN_DISABLED()
		self:Unschedule(delayedZoneCheck)
		self:Schedule(1, delayedZoneCheck, self)
		self:Schedule(3, delayedZoneCheck, self)
	end
	mod.OnInitialize = mod.LOADING_SCREEN_DISABLED
	mod.ZONE_CHANGED_NEW_AREA	= mod.LOADING_SCREEN_DISABLED
end
