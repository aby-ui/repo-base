local mod	= DBM:NewMod("ArtifactQueen", "DBM-Challenges", 3)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "normal,timewalker"

mod:SetRevision("20220407221113")
mod:SetCreatureID(116484, 116499, 116496)--Sigryn, Jarl Velbrand, Runeseer Faljar
mod:SetEncounterID(2059)
mod:SetBossHPInfoToHighest()
mod.soloChallenge = true

mod:RegisterCombat("combat")
mod:SetReCombatTime(20, 5)--Basically killing of recombat restriction. mage tower lets you spam retry, we want the mod to let you

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 238694 237870 237947 237945 237857 237952",
	"SPELL_CAST_SUCCESS 237849 238432",
	"SPELL_AURA_APPLIED 237947",
	"SPELL_AURA_REMOVED 237947",
	"UNIT_DIED",
	"UNIT_SPELLCAST_SUCCEEDED boss1 boss2 boss3"
)
--Notes:
--TODO, all. mapids, mob iDs, win event to stop timers (currently only death event stops them)
--Damage

--Sigryn
local warnHurlAxe				= mod:NewSpellAnnounce(237870, 2, nil, false)
local warnAdvance				= mod:NewSpellAnnounce(237849, 2)

--Sigryn
local specWarnThrowSpear		= mod:NewSpecialWarningDodge(238694, nil, nil, nil, 1, 2)
local specWarnBloodFather		= mod:NewSpecialWarningTarget(237945, nil, nil, nil, 3, 7)
local specWarnDarkWings			= mod:NewSpecialWarningDodge(237772, nil, nil, nil, 2, 2)
--Jarl Velbrand
local specWarnBerserkersRage	= mod:NewSpecialWarningRun(237947, nil, nil, nil, 4, 2)
local specWarnBladeStorm		= mod:NewSpecialWarningRun(237857, nil, nil, nil, 4, 2)
--
local specWarnRunicDetonation	= mod:NewSpecialWarningMoveTo(237914, nil, nil, nil, 1, 12)
local specWarnKnowledge			= mod:NewSpecialWarningSwitch(237952, nil, nil, nil, 1, 2)

--Sigryn
--Timers obviously affected by CC usage
local timerThrowSpearCD			= mod:NewCDTimer(13.4, 238694, nil, nil, nil, 3)
--local timerAdvanceCD			= mod:NewCDTimer(13.4, 237849, nil, nil, nil, 2)
local timerBloodFatherCD		= mod:NewCDCountTimer(13.4, 237945, nil, nil, nil, 2, nil, nil, nil, 1, 4)
local timerDarkWingsCD			= mod:NewCDTimer(20, 237772, nil, nil, nil, 3)
--Jarl Velbrand
local timerBerserkersRageCD		= mod:NewCDCountTimer(13.4, 237947, nil, nil, nil, 3)
local timerBladeStormCD			= mod:NewCDCountTimer(13.4, 237857, nil, nil, nil, 2)
--Runeseer Faljar
local timerRunicDetonationCD	= mod:NewCDCountTimer(13.4, 237914, nil, nil, nil, 5)
local timerKnowledgeCD			= mod:NewCDCountTimer(13.4, 237952, nil, nil, nil, 3)

mod:AddNamePlateOption("NPAuraOnPresence", 237947)

--This may not be accurate way to do it, it may be some kind of shared CD like HFC council and just be grossly affected by CCs
--These are ones consistent between 4 pulls (including kill) though
local bladeStormTimers = {125.0, 105.0, 30.0}
local berserkerRageTimers = {26.0, 175.0}
local bloodFatherTimers = {61.0, 70.0, 100.0}
local ancestralKnowledgeTimers = {98.4, 69.2, 118.4, 66.3, 26.7, 27.1, 27.5}--Rest 25
--[[
--I mean, there is some consistency until 4 and 5. I'm not sure if this is result of CC though or RNG
["237914-Runic Detonation"] = "pull:43.7, 14.6, 87.5, 56.3, 14.2, 13.3",
["237914-Runic Detonation"] = "pull:43.4, 13.4, 87.4, 10.9, 47.4, 12.6, 10.5",
["237914-Runic Detonation"] = "pull:43.5, 14.6, 87.5, 11.0, 44.1, 10.9, 13.4",
--]]
local bloodCount = 0
local bladeCount = 0
local berserkerCount = 0
local runicDetonationCount = 0
local knowledgeCast = 0

function mod:OnCombatStart(delay)
	bloodCount = 0
	bladeCount = 0
	berserkerCount = 0
	runicDetonationCount = 0
	knowledgeCast = 0
	timerThrowSpearCD:Start(14.4)
	--timerAdvanceCD:Start(20.5)
	timerBerserkersRageCD:Start(26, 1)
	timerRunicDetonationCD:Start(43, 1)
	timerBloodFatherCD:Start(61, 1)
	timerKnowledgeCD:Start(98, 1)
	timerBladeStormCD:Start(125, 1)
	timerDarkWingsCD:Start(146)
	if self.Options.NPAuraOnPresence then
		DBM:FireEvent("BossMod_EnableHostileNameplates")
	end
end

function mod:OnCombatEnd()
	if self.Options.NPAuraOnPresence  then
		DBM.Nameplate:Hide(true, nil, nil, nil, true)
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 238694 then
		specWarnThrowSpear:Show()
		specWarnThrowSpear:Play("watchstep")
		timerThrowSpearCD:Start()
	elseif spellId == 237870 then
		warnHurlAxe:Show()
	elseif spellId == 237947 then
		berserkerCount = berserkerCount + 1
		specWarnBerserkersRage:Show()
		specWarnBerserkersRage:Play("justrun")
		local timer = berserkerRageTimers[berserkerCount+1]
		if timer then
			timerBerserkersRageCD:Start(timer, berserkerCount+1)
		end
	elseif spellId == 237945 then
		bloodCount = bloodCount + 1
		specWarnBloodFather:Show(args.sourceName)
		specWarnBloodFather:Play("crowdcontrol")
		local timer = bloodFatherTimers[bloodCount+1]
		if timer then
			timerBloodFatherCD:Start(timer, bloodCount+1)
		end
	elseif spellId == 237857 then
		bladeCount = bladeCount + 1
		specWarnBladeStorm:Show()
		specWarnBladeStorm:Play("justrun")
		local timer = bladeStormTimers[bladeCount+1]
		if timer then
			timerBladeStormCD:Start(timer, bladeCount+1)
		end
	elseif spellId == 237952 then
		knowledgeCast = knowledgeCast + 1
		specWarnKnowledge:Show()
		specWarnKnowledge:Play("targetchange")
		local timer = ancestralKnowledgeTimers[knowledgeCast+1] or 25
		if timer then
			timerKnowledgeCD:Start(timer, knowledgeCast+1)
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if (spellId == 237849 or spellId == 238432) and self:AntiSpam(5, 1) then
		warnAdvance:Show()
		--timerAdvanceCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 237947 then
		if self.Options.NPAuraOnPresence then
			DBM.Nameplate:Show(true, args.destGUID, spellId, nil, 20)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 237947 then
		if self.Options.NPAuraOnPresence then
			DBM.Nameplate:Show(true, args.destGUID, spellId)
		end
	end
end

function mod:UNIT_DIED(args)
	if args.destGUID == UnitGUID("player") then--Solo scenario, a player death is a wipe
		DBM:EndCombat(self, true)
	end
	--local cid = self:GetCIDFromGUID(args.destGUID)
--	if cid == 177933 then--Variss

--	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 237914 then--Runic Detonation
		runicDetonationCount = runicDetonationCount + 1
		specWarnRunicDetonation:Show(RUNES)
		specWarnRunicDetonation:Play("getinyellowrunes")
		timerRunicDetonationCD:Start()
	elseif spellId == 237772 then--Dark Wings
		specWarnDarkWings:Show()
		specWarnDarkWings:Play("stilldanger")
		timerDarkWingsCD:Start()
	end
end
