local mod	= DBM:NewMod(2509, "DBM-Party-Dragonflight", 5, 1201)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221204033441")
mod:SetCreatureID(194181)
mod:SetEncounterID(2562)
--mod:SetUsedIcons(1, 2, 3)
mod:SetHotfixNoticeRev(20221015000000)
mod:SetMinSyncRevision(20221015000000)
--mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 388537 386173 385958",
	"SPELL_CAST_SUCCESS 387691",
	"SPELL_AURA_APPLIED 386181",
--	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED 386181",
	"SPELL_PERIODIC_DAMAGE 386201",
	"SPELL_PERIODIC_MISSED 386201",
	"SPELL_ENERGIZE 386088"
--	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--TODO, find a log where orb actually hits boss to see affect on all timers, not just fissure
--TODO, review energy updating. it doesn't check out quite right. boss got 20 energy from 1 orb, timere reduced by 5.6 seconds (should have been 8)
--TODO, review a long heroic pull again without M0 or + mechanics involved to see true CDs with less spell queuing?
--[[
(ability.id = 388537 or ability.id = 386173 or ability.id = 385958) and type = "begincast"
 or ability.id = 387691 and type = "cast"
 or ability.id = 386088 and not type = "damage"
 or type = "dungeonencounterstart" or type = "dungeonencounterend"
--]]
local warnArcaneOrbs							= mod:NewCountAnnounce(385974, 3)
local warnManaBombs								= mod:NewTargetAnnounce(386173, 3)

local specWarnArcaneFissure						= mod:NewSpecialWarningDodge(388537, nil, nil, nil, 1, 2)
local specWarnManaBomb							= mod:NewSpecialWarningMoveAway(386181, nil, nil, nil, 1, 2)
local yellManaBomb								= mod:NewYell(386181)
local yellManaBombFades							= mod:NewShortFadesYell(386181)
local specWarnArcaneExpulsion					= mod:NewSpecialWarningDefensive(385958, nil, nil, nil, 1, 2)
local specWarnGTFO								= mod:NewSpecialWarningGTFO(386201, nil, nil, nil, 1, 8)

local timerArcaneOrbsCD							= mod:NewCDCountTimer(16.8, 385974, nil, nil, nil, 5)
local timerArcaneFissureCD						= mod:NewCDTimer(40.7, 388537, nil, nil, nil, 3)
local timerManaBombsCD							= mod:NewCDCountTimer(19.4, 386173, nil, nil, nil, 3)
local timerArcaneExpulsionCD					= mod:NewCDTimer(19.4, 385958, nil, nil, nil, 5, nil, DBM_COMMON_L.TANK_ICON)

--local berserkTimer							= mod:NewBerserkTimer(600)

--mod:AddRangeFrameOption("8")
mod:AddInfoFrameOption(391977, true)
--mod:AddSetIconOption("SetIconOnStaggeringBarrage", 361018, true, false, {1, 2, 3})

mod:GroupSpells(386173, 386181)--Mana Bombs with Mana Bomb

mod.vb.orbCount = 0
mod.vb.manaCount = 0

function mod:OnCombatStart(delay)
	self.vb.orbCount = 0
	self.vb.manaCount = 0
	timerArcaneOrbsCD:Start(2.1-delay, 1)
	timerArcaneExpulsionCD:Start(12.1-delay)
	timerManaBombsCD:Start(23.9-delay)
	timerArcaneFissureCD:Start(40.7-delay)
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(DBM:GetSpellInfo(391977))
		DBM.InfoFrame:Show(5, "playerdebuffstacks", 391977)
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
	if spellId == 388537 then
		specWarnArcaneFissure:Show()
		specWarnArcaneFissure:Play("watchstep")
		--Add 3.5 to existing manabomb and expulsion timers (Working Theory, need longer logs/larger sample)
		--It seems to hold so far though, and if they are also energy based it would make sense since he doesn't gain energy for 3 seccond cast
		--Of course if they are energy based, it also means the timers need to be corrected by SPELL_ENERGIZE as well :\
		timerManaBombsCD:AddTime(3.5, self.vb.manaCount+1)
		timerArcaneExpulsionCD:AddTime(3.5)
	elseif spellId == 386173 then
		--23.9, 26.7, 23, 26.7, 23
		--24.3, 26.7, 23, 26.7, 26.7
		self.vb.manaCount = self.vb.manaCount + 1
		--Timers only perfect alternate if boss execution is perfect, if any orbs hit boss alternation is broken
--		if self.vb.manaCount % 2 == 0 then
			timerManaBombsCD:Start(23, self.vb.manaCount+1)
--		else
--			timerManaBombsCD:Start(26.7, self.vb.manaCount+1)
--		end
	elseif spellId == 385958 then
		if self:IsTanking("player", "boss1", nil, true) then
			specWarnArcaneExpulsion:Show()
			specWarnArcaneExpulsion:Play("defensive")
		end
		timerArcaneExpulsionCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 387691 then
		self.vb.orbCount = self.vb.orbCount + 1
		warnArcaneOrbs:Show(self.vb.orbCount)
		--2, 21, 24.2, 20.6, 23.6, 20, 24.3
		--Timers only perfect alternate if boss execution is perfect, if any orbs hit boss alternation is broken
--		if self.vb.orbCount % 2 == 0 then
			timerArcaneOrbsCD:Start(20, self.vb.orbCount+1)
--		else
--			timerArcaneOrbsCD:Start(23.6, self.vb.orbCount+1)
--		end
	elseif spellId == 388537 then
		timerArcaneFissureCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 386181 then
		warnManaBombs:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			specWarnManaBomb:Show()
			specWarnManaBomb:Play("runout")
			yellManaBomb:Yell()
			yellManaBombFades:Countdown(spellId)
		end
	end
end
--mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 386181 then
		if args:IsPlayer() then
			yellManaBombFades:Cancel()
		end
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 386201 and destGUID == UnitGUID("player") and self:AntiSpam(2, 4) then
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:SPELL_ENERGIZE(_, _, _, _, destGUID, _, _, _, spellId, _, _, amount)
	if spellId == 386088 and destGUID == UnitGUID("boss1") then
		DBM:Debug("SPELL_ENERGIZE fired on Boss. Amount: "..amount)
		local bossPower = UnitPower("boss1")
		bossPower = bossPower / 2.5--2.5 energy per second, making it every ~40 seconds
		local remaining = 40-bossPower
		if remaining > 0 then
			local newTimer = 40-remaining
			timerArcaneFissureCD:Update(newTimer, 40)
		else
			timerArcaneFissureCD:Stop()
		end
	end
end

--[[
function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 353193 then

	end
end
--]]
