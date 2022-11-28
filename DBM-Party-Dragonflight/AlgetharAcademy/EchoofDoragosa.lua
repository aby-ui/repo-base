local mod	= DBM:NewMod(2514, "DBM-Party-Dragonflight", 5, 1201)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221128054351")
mod:SetCreatureID(190609)
mod:SetEncounterID(2565)
--mod:SetUsedIcons(1, 2, 3)
mod:SetHotfixNoticeRev(20221015000000)
--mod:SetMinSyncRevision(20211203000000)
--mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 374361 388822",
	"SPELL_CAST_SUCCESS 374343",
	"SPELL_AURA_APPLIED 389011 374350 389007",
	"SPELL_AURA_APPLIED_DOSE 389011",
	"SPELL_AURA_REMOVED 374350"
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
--	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--TODO, anounce https://www.wowhead.com/beta/spell=388901/arcane-rift spawns?
--TOOD, how frequent is https://www.wowhead.com/beta/spell=388951/uncontrolled-energy , announce them if not frequent? Seems like it'll ramp up fast though
--TODO, GTFO for arcane rift, could not find damage spellId for it
--TODO, add arcane missiles? i feel like this is something she probably casts very frequently
--Notes, Power Vaccume triggers 4 second ICD, Energy Bomb Triggers 8.5 ICD on Vaccuum but only 7 second ICD on Breath, Astraol breath triggers 7.5 ICD
--Notes, All of ICD adjustments can be done but for a 5 man boss with 3 abilities it seems overkill. Only perform correction on one case for now
--[[
(ability.id = 374361 or ability.id = 388822) and type = "begincast"
 or ability.id = 374343 and type = "cast"
 or type = "dungeonencounterstart" or type = "dungeonencounterend"
--]]
local warnOverwhelmingPoweer					= mod:NewCountAnnounce(389011, 3, nil, nil, DBM_CORE_L.AUTO_ANNOUNCE_OPTIONS.stack:format(389011))--Typical stack warnings have amount and playername, but since used as personal, using count object to just display amount then injecting option text for stack
local warnEnergyBomb							= mod:NewTargetAnnounce(374352, 3)

local specWarnOverwhelmingPower					= mod:NewSpecialWarningStack(389011, false, 3, nil, nil, 1, 6)
local specWarnAstralBreath						= mod:NewSpecialWarningDodge(374361, nil, nil, nil, 2, 2)
local specWarnPowerVacuum						= mod:NewSpecialWarningRun(388822, nil, nil, nil, 4, 2)
local specWarnEnergyBomb						= mod:NewSpecialWarningMoveAway(374352, nil, nil, nil, 1, 2)
local yellEnergyBomb							= mod:NewYell(374352)
local yellEnergyBombFades						= mod:NewShortFadesYell(374352)
local specWarnGTFO								= mod:NewSpecialWarningGTFO(389007, nil, nil, nil, 1, 8)

local timerAstralBreathCD						= mod:NewCDTimer(29, 374361, nil, nil, nil, 3)--29-32
local timerPowerVacuumCD						= mod:NewCDTimer(23.4, 388822, nil, nil, nil, 2)--23-29
local timerEnergyBombCD							= mod:NewCDTimer(14.1, 374352, nil, nil, nil, 3)--14.1-20
--local timerDecaySprayCD						= mod:NewAITimer(35, 376811, nil, nil, nil, 5, nil, DBM_COMMON_L.TANK_ICON)

--local berserkTimer							= mod:NewBerserkTimer(600)

--mod:AddRangeFrameOption("8")
mod:AddInfoFrameOption(389011, true)
--mod:AddSetIconOption("SetIconOnStaggeringBarrage", 361018, true, false, {1, 2, 3})

function mod:OnCombatStart(delay)
	timerEnergyBombCD:Start(15.9-delay)
	timerPowerVacuumCD:Start(24.9-delay)
	timerAstralBreathCD:Start(28.1-delay)
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(DBM:GetSpellInfo(389011))
		DBM.InfoFrame:Show(5, "playerdebuffstacks", 389011)
	end
end

function mod:OnCombatEnd()
--	if self.Options.RangeFrame then
--		DBM.RangeCheck:Hide()
--	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 374361 then
		specWarnAstralBreath:Show()
		specWarnAstralBreath:Play("breathsoon")
		timerAstralBreathCD:Start()
	elseif spellId == 388822 then
		specWarnPowerVacuum:Show()
		specWarnPowerVacuum:Play("justrun")
		timerPowerVacuumCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 374343 then
		timerEnergyBombCD:Start()
		local remaining = timerPowerVacuumCD:GetRemaining()
		if remaining < 8.5 then
			local adjust = 8.5 - remaining
			timerPowerVacuumCD:AddTime(adjust)
			DBM:Debug("timerPowerVacuumCD extended by: "..adjust)
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 389011 and args:IsPlayer() then
		local amount = args.amount or 1
		if self.Options.SpecWarn389011stack and amount == 3 then
			specWarnOverwhelmingPower:Show(amount)
			specWarnOverwhelmingPower:Play("stackhigh")
		else
			warnOverwhelmingPoweer:Show(amount)
		end
	elseif spellId == 374350 then
		warnEnergyBomb:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			specWarnEnergyBomb:Show()
			specWarnEnergyBomb:Play("runout")
			yellEnergyBomb:Yell()
			yellEnergyBombFades:Countdown(spellId)
		end
	elseif spellId == 389007 and args:IsPlayer() and self:AntiSpam(2, 4) then
		specWarnGTFO:Show(args.spellName)
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 374350 then
		if args:IsPlayer() then
			yellEnergyBombFades:Cancel()
		end
	end
end

--[[
function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 340324 and destGUID == UnitGUID("player") and self:AntiSpam(2, 4) then
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 353193 then

	end
end
--]]
