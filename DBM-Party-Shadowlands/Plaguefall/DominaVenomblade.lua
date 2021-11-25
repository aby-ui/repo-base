local mod	= DBM:NewMod(2423, "DBM-Party-Shadowlands", 2, 1183)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20211125075428")
mod:SetCreatureID(164266)
mod:SetEncounterID(2385)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 325552 332313",
	"SPELL_CAST_SUCCESS 325245",
	"SPELL_AURA_APPLIED 325552 333353 336258",
	"SPELL_AURA_REMOVED 333353 336258"
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
--	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--TODO, pre warn ambush target?
--Track https://shadowlands.wowhead.com/spell=325545/shadowsilk-bulwark or warn dispel?
--[[
(ability.id = 325457 or ability.id = 325552 or ability.id = 332313) and type = "begincast"
 or (ability.id = 325245) and type = "cast"
--]]
--TODO, shadowclone removed and replaced with adds?
local warnAmbush					= mod:NewTargetNoFilterAnnounce(325245, 4)
local warnSolitaryPrey				= mod:NewYouAnnounce(336258, 4)

local specWarnAmbush				= mod:NewSpecialWarningYou(325245, nil, nil, nil, 1, 2)
local yellAmbush					= mod:NewYell(325245)
local yellAmbushFades				= mod:NewShortFadesYell(325245)
local specWarnSolitaryPrey			= mod:NewSpecialWarningYou(336258, false, nil, nil, 1, 2)--Off by default since it may feel excessively spammy if they move a lot
local specWarnCytotoxicSlash		= mod:NewSpecialWarningDispel(325552, "RemovePoison", nil, nil, 1, 2)
local specWarnCytotoxicSlashTank	= mod:NewSpecialWarningDefensive(325552, nil, nil, nil, 1, 2)
--local specWarnGTFO				= mod:NewSpecialWarningGTFO(257274, nil, nil, nil, 1, 8)

--local timerShadowcloneCD			= mod:NewCDTimer(13, 325457, nil, nil, nil, 6)
local timerBroodAssassinsCD			= mod:NewCDTimer(35.2, 332313, nil, nil, nil, 1)
local timerAmbushCD					= mod:NewCDTimer(19.4, 325245, nil, nil, nil, 3)--19.4-23
local timerSolitaryPrey				= mod:NewBuffFadesTimer(6, 336258, nil, nil, nil, 5)
local timerCytotoxicSlashCD			= mod:NewCDTimer(20.6, 325552, nil, nil, nil, 5, nil, DBM_COMMON_L.TANK_ICON)--20-23

mod:AddRangeFrameOption(5, 325245)

function mod:OnCombatStart(delay)
	timerAmbushCD:Start(6.1-delay)--9.1?
	timerCytotoxicSlashCD:Start(3.1-delay)--START
	timerBroodAssassinsCD:Start(15.2-delay)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(5)
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 325552 then
		timerCytotoxicSlashCD:Start()
	elseif spellId == 332313 then
		timerBroodAssassinsCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 325245 then
		timerAmbushCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 325552 then
		if self.Options.SpecWarn325552dispel and self:CheckDispelFilter() then
			specWarnCytotoxicSlash:Show(args.destName)
			specWarnCytotoxicSlash:Play("helpdispel")
		elseif args:IsPlayer() then
			specWarnCytotoxicSlashTank:Show()
			specWarnCytotoxicSlashTank:Play("defensive")
		end
	elseif spellId == 333353 then
		if args:IsPlayer() then
			specWarnAmbush:Show()
			specWarnAmbush:Play("targetyou")
			yellAmbush:Yell()
			yellAmbushFades:Countdown(spellId)
		else
			warnAmbush:Show(args.destName)
		end
	elseif spellId == 336258 and args:IsPlayer() and self:AntiSpam(3, 1) then
		if self.Options.SpecWarn336258you then
			specWarnSolitaryPrey:Show()
			specWarnSolitaryPrey:Play("targetyou")
		else
			warnSolitaryPrey:Show()
		end
		timerSolitaryPrey:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 333353 then
		if args:IsPlayer() then
			yellAmbushFades:Cancel()
		end
	elseif spellId == 336258 and args:IsPlayer() then
		timerSolitaryPrey:Stop()
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
