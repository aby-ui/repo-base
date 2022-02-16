local mod	= DBM:NewMod(1499, "DBM-Party-Legion", 6, 726)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "heroic,mythic,challenge"

mod:SetRevision("20220116042005")
mod:SetCreatureID(98206)
mod:SetEncounterID(1828)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 197776 212030 197810"
)

--TODO, evalulate normal mode tmers more for slash and fissure, seem longer cded there.
local specWarnBat					= mod:NewSpecialWarningSwitch("ej12489", "Tank", nil, nil, 1, 2)
local specWarnFissure				= mod:NewSpecialWarningDodge(197776, nil, nil, nil, 2, 2)
local specWarnSlash					= mod:NewSpecialWarningSpell(212030, nil, nil, nil, 2, 2)
local specWarnSlam					= mod:NewSpecialWarningSpell(197810, nil, nil, nil, 3, 2)

local timerBatCD					= mod:NewNextTimer(31, "ej12489", nil, nil, nil, 1, 183219)--31.1 i saw for lowest time but might be some variation
--Both 13 unless delayed by other interactions. Seems similar to archimondes timer code with a hard ICD mechanic.
local timerFissureCD				= mod:NewCDTimer(23, 197776, nil, nil, nil, 3)--Maybe 23 now?
local timerSlashCD					= mod:NewCDTimer(25, 212030, nil, nil, nil, 3, nil, DBM_COMMON_L.DEADLY_ICON)--25-30
local timerSlamCD					= mod:NewCDTimer(47, 197810, nil, nil, nil, 2)--Possibly 40 but delayed by ICD triggering

--Boss seems to have intenal 6 second ICD and cannot cast any two spells within 6 seconds of another (minus summon bats)
--[[
local function updateAlltimers(ICD)
	if timerFissureCD:GetRemaining() < ICD then
		local elapsed, total = timerFissureCD:GetTime()
		local extend = ICD - (total-elapsed)
		DBM:Debug("timerFissureCD extended by: "..extend, 2)
		timerFissureCD:Cancel()
		timerFissureCD:Update(elapsed, total+extend)
	end
	if timerSlashCD:GetRemaining() < ICD then
		local elapsed, total = timerSlashCD:GetTime()
		local extend = ICD - (total-elapsed)
		DBM:Debug("timerSlashCD extended by: "..extend, 2)
		timerSlashCD:Cancel()
		timerSlashCD:Update(elapsed, total+extend)
	end
	if timerSlamCD:GetRemaining() < ICD then
		local elapsed, total = timerSlamCD:GetTime()
		local extend = ICD - (total-elapsed)
		DBM:Debug("timerSlamCD extended by: "..extend, 2)
		timerSlamCD:Cancel()
		timerSlamCD:Update(elapsed, total+extend)
	end
end
--]]

--"<4.91 00:06:09> [ENCOUNTER_START] ENCOUNTER_START#1828#General Xakal#23#5", -- [7]
--"<25.11 00:06:30> [CLEU] SPELL_DAMAGE#Creature-0-3887-1516-9671-100393-00005B6FAC#Dread Felbat#Player-1169-07BF1788#Orlene-CenarionCircle#197788#Bombardment#389587#-1", --
local function blizzardHatesBossMods(self)
	specWarnBat:Show()
	specWarnBat:Play("mobsoon")
	timerBatCD:Start()
	self:Schedule(31, blizzardHatesBossMods, self)
end

function mod:OnCombatStart(delay)
	timerFissureCD:Start(5-delay)
	timerSlashCD:Start(13-delay)
	timerBatCD:Start(20-delay)
	self:Schedule(20, blizzardHatesBossMods, self)
	timerSlamCD:Start(35.8-delay)
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 197776 then
		specWarnFissure:Show()
		specWarnFissure:Play("watchstep")
		timerFissureCD:Start()
		--updateAlltimers(6)
	elseif spellId == 212030 then
		specWarnSlash:Show()
		specWarnSlash:Play("watchwave")
		timerSlashCD:Start()
		--updateAlltimers(6)
	elseif spellId == 197810 then
		specWarnSlam:Show()
		specWarnSlam:Play("carefly")
		timerSlamCD:Start()
		--updateAlltimers(7)--Verify is actually 7 and not 6 like others
	end
end
