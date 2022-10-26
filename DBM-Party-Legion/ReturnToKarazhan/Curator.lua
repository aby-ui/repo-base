local mod	= DBM:NewMod(1836, "DBM-Party-Legion", 11, 860)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "heroic,mythic,challenge"

mod:SetRevision("20221016002954")
mod:SetCreatureID(114462)
mod:SetEncounterID(1964)
--mod:SetUsedIcons(1)
--mod:SetHotfixNoticeRev(14922)
--mod.respawnTime = 30

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 234416 227267",
	"SPELL_AURA_APPLIED 227254",
	"SPELL_AURA_REMOVED 227254",
	"SPELL_PERIODIC_DAMAGE 227465",
	"SPELL_PERIODIC_MISSED 227465",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--[[
(ability.id = 227267 or ability.id = 234416) and type = "cast" or ability.id = 227254 and (type = "applybuff" or type = "removebuff")
 or type = "dungeonencounterstart" or type = "dungeonencounterend"
--]]
local warnAdds						= mod:NewSpellAnnounce(227267, 2)--if not cast too often make special warning?
local warnEvo						= mod:NewSpellAnnounce(227254, 1)
local warnEvoOver					= mod:NewEndAnnounce(227254, 2)

local specWarnPowerDischarge		= mod:NewSpecialWarningGTFO(227465, nil, nil, nil, 1, 8)

local timerSummonAddCD				= mod:NewNextTimer(9.7, 227267, nil, nil, nil, 1)
local timerPowerDischargeCD			= mod:NewCDTimer(12.2, 227465, nil, nil, nil, 3)
local timerEvoCD					= mod:NewCDTimer(58, 227254, nil, nil, nil, 6, nil, nil, nil, 1, 4)
local timerEvo						= mod:NewBuffActiveTimer(20, 227254, nil, nil, nil, 6)

--local berserkTimer					= mod:NewBerserkTimer(300)

function mod:OnCombatStart(delay)
	timerSummonAddCD:Start(6-delay)
	timerPowerDischargeCD:Start(13.5)
	timerEvoCD:Start(self:IsMythicPlus() and 50 or 58-delay)
end

--function mod:OnCombatEnd()

--end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if (spellId == 234416 or spellId == 227267) and self:AntiSpam(3, 1) then
		warnAdds:Show()
		timerSummonAddCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 227254 then
		timerSummonAddCD:Stop()
		timerPowerDischargeCD:Stop()
		warnEvo:Show()
		timerEvo:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 227254 then
		warnEvoOver:Show()
		timerEvoCD:Start(self:IsMythicPlus() and 49.1 or 58)
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 227465 and destGUID == UnitGUID("player") and self:AntiSpam(2, 2) then
		specWarnPowerDischarge:Show()
		specWarnPowerDischarge:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 227278 then
		timerPowerDischargeCD:Start()
	end
end

