local mod	= DBM:NewMod(2388, "DBM-Party-Shadowlands", 8, 1189)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20211125075428")
mod:SetCreatureID(162100)
mod:SetEncounterID(2360)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 319650 319685 319713",
	"SPELL_CAST_SUCCESS 319654",
--	"SPELL_AURA_APPLIED",
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
	"CHAT_MSG_RAID_BOSS_EMOTE"
--	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--TODO, maybe track https://shadowlands.wowhead.com/spell=319657/essence-surge when stack rage is known, adding now has potential to be spammy
--TODO, tweak interrupt count for Hungering Drain to reset at appropriate count when cast frequency known?
--[[
(ability.id = 319650 or ability.id = 319685 or ability.id = 319713) and type = "begincast"
 or ability.id = 319654 and type = "cast"
 --]]
--local warnBlackPowder				= mod:NewTargetAnnounce(257314, 4)

local specWarnViciousHeadbutt		= mod:NewSpecialWarningDefensive(319650, "Tank", nil, nil, 1, 2)
local specWarnHungeringDrain		= mod:NewSpecialWarningInterruptCount(319654, "HasInterrupt", nil, nil, 1, 2)
local specWarnSeveringSmash			= mod:NewSpecialWarningSpell(319685, nil, nil, nil, 2, 2)
local specWarnJuggernautRush		= mod:NewSpecialWarningYou(319713, nil, nil, nil, 1, 2)
local yellJuggernautRush			= mod:NewYell(319713)
local yellJuggernautRushFades		= mod:NewShortFadesYell(319713)
local specWarnJuggernautRushSoak	= mod:NewSpecialWarningMoveTo(319713, nil, nil, nil, 1, 2)
--local specWarnGTFO					= mod:NewSpecialWarningGTFO(257274, nil, nil, nil, 1, 8)

local timerViciousHeadbuttCD		= mod:NewCDTimer(18.2, 319650, nil, nil, nil, 5, nil, DBM_COMMON_L.TANK_ICON)--18.2 unless delayed by other abilities
local timerHungeringDrainCD			= mod:NewCDTimer(19.4, 319654, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)
local timerSeveringSmashCD			= mod:NewCDTimer(38.9, 319685, nil, nil, nil, 6)
local timerJuggernautRushCD			= mod:NewCDTimer(18.2, 319713, nil, nil, nil, 3)

mod:AddSetIconOption("SetIconOnJuggernaut", 319713, true, false, {1})

mod.vb.interruptCount = 0
mod.vb.headbuttCount = 0

function mod:OnCombatStart(delay)
	self.vb.interruptCount = 0
	self.vb.headbuttCount = 0
	timerViciousHeadbuttCD:Start(5.9-delay)
	timerHungeringDrainCD:Start(10.7-delay)
	timerJuggernautRushCD:Start(15.5-delay)
	timerSeveringSmashCD:Start(34.2-delay)
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 319650 then
		self.vb.headbuttCount = self.vb.headbuttCount + 1
		specWarnViciousHeadbutt:Show()
		specWarnViciousHeadbutt:Play("defensive")
		if timerSeveringSmashCD:GetRemaining() >= 18.2 then
			timerViciousHeadbuttCD:Start()
		end
	elseif spellId == 319685 then
		specWarnSeveringSmash:Show()
		specWarnSeveringSmash:Play("specialsoon")
		timerSeveringSmashCD:Start()
		--Severing Smash resets other timers
		timerViciousHeadbuttCD:Stop()
		timerHungeringDrainCD:Stop()
		timerJuggernautRushCD:Stop()
		timerViciousHeadbuttCD:Start(12)
		timerHungeringDrainCD:Start(17)
		timerJuggernautRushCD:Start(21.8)
	elseif spellId == 319713 then
		if timerSeveringSmashCD:GetRemaining() >= 18.2 then
			timerJuggernautRushCD:Start()
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 319654 then
		if timerSeveringSmashCD:GetRemaining() >= 19.4 then
			timerHungeringDrainCD:Start()
		end
		self.vb.interruptCount = self.vb.interruptCount + 1
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			local count = self.vb.interruptCount
			specWarnHungeringDrain:Show(args.sourceName, count)
			if count == 1 then
				specWarnHungeringDrain:Play("kick1r")
			elseif count == 2 then
				specWarnHungeringDrain:Play("kick2r")
			elseif count == 3 then
				specWarnHungeringDrain:Play("kick3r")
			elseif count == 4 then
				specWarnHungeringDrain:Play("kick4r")
			elseif count == 5 then
				specWarnHungeringDrain:Play("kick5r")
			else--Shouldn't happen, but fallback rules never hurt
				specWarnHungeringDrain:Play("kickcast")
			end
		end
	end
end

--[[
function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 194966 then

	end
end
--]]

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, npc, _, _, target)
	if msg:find("spell:319713") then
		local targetname = DBM:GetUnitFullName(target)
		if targetname then
			if self.Options.SetIconOnJuggernaut then
				self:SetIcon(targetname, 1, 5)
			end
			if targetname == UnitName("player") then
				specWarnJuggernautRush:Show()
				specWarnJuggernautRush:Play("targetyou")
				yellJuggernautRush:Yell()
				yellJuggernautRushFades:Countdown(4)
			else
				specWarnJuggernautRushSoak:Show(targetname)
				specWarnJuggernautRushSoak:Play("gathershare")
			end
		end
	end
end

--[[
function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 309991 and destGUID == UnitGUID("player") and self:AntiSpam(2, 2) then
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 257453  then

	end
end
--]]
