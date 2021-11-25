local mod	= DBM:NewMod(2437, "DBM-Party-Shadowlands", 9, 1194)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20211125075428")
mod:SetCreatureID(175616)
mod:SetEncounterID(2425)
mod:SetHotfixNoticeRev(20210824000000)--2021, 08, 24

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 348350 346204",
	"SPELL_CAST_SUCCESS 345770",
	"SPELL_AURA_APPLIED 353414 348128 345770",
	"SPELL_AURA_REMOVED 345770"
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
--	"UNIT_DIED"
--	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--TODO, fix event for interrogation targetting, it's likely wrong, maybe https://ptr.wowhead.com/spell=345990/containment-cell instead?
--Improve/add timers for armed/disarmed phases because it'll probably alternate a buffactive timer instead of CD
--TODO, what do with https://ptr.wowhead.com/spell=347964/rotary-body-armor ?
local warnArmedSecurity				= mod:NewSpellAnnounce(346204, 2)
local warnFullyArmed				= mod:NewSpellAnnounce(348128, 3, nil, "Tank|Healer")
local warnInpoundContraband			= mod:NewTargetNoFilterAnnounce(345770, 2)--Not filtered, because if it's on a tank or healer its kinda important
local warnInpoundContrabandEnded	= mod:NewEndAnnounce(345770, 1)

local specWarnInterrogation			= mod:NewSpecialWarningRun(353414, nil, nil, nil, 4, 2)
local yellInterrogation				= mod:NewYell(353414)
local specWarnInterrogationOther	= mod:NewSpecialWarningSwitch(353414, "Dps", nil, nil, 1, 2)
local specWarnInpoundContraband		= mod:NewSpecialWarningYou(345770, nil, nil, nil, 1, 2)
--local specWarnGTFO				= mod:NewSpecialWarningGTFO(320366, nil, nil, nil, 1, 8)

local timerInterrogationCD			= mod:NewCDTimer(42.5, 353414, nil, nil, nil, 3)--42.5-52
local timerArmedSecurityCD			= mod:NewCDTimer(37.7, 346204, nil, nil, nil, 6)--37.7--57
local timerImpoundContrabandCD		= mod:NewCDTimer(31.6, 345770, nil, nil, nil, 3)
--local timerStichNeedleCD			= mod:NewAITimer(15.8, 320200, nil, nil, nil, 5, nil, DBM_COMMON_L.HEALER_ICON)--Basically spammed

function mod:OnCombatStart(delay)
	timerArmedSecurityCD:Start(7.2-delay)
	timerImpoundContrabandCD:Start(18.1-delay)
	timerInterrogationCD:Start(32.7-delay)
	local trashMod = DBM:GetModByName("TazaveshTrash")
	if trashMod then
		trashMod.isTrashModBossFightAllowed = true
	end
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
	local trashMod = DBM:GetModByName("TazaveshTrash")
	if trashMod then
		trashMod.isTrashModBossFightAllowed = false
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 348350 then
		timerInterrogationCD:Start()
	elseif spellId == 346204 then
		warnArmedSecurity:Show()
		timerArmedSecurityCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 345770 then
		timerImpoundContrabandCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 353414 and args:IsDestTypePlayer() then
		if args:IsPlayer() then
			specWarnInterrogation:Show()
			specWarnInterrogation:Play("targetyou")
			yellInterrogation:Yell()
		else
			specWarnInterrogationOther:Show()
			specWarnInterrogationOther:Play("targetchange")
		end
	elseif spellId == 348128 then
		warnFullyArmed:Show()
	elseif spellId == 345770 then
		warnInpoundContraband:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			specWarnInpoundContraband:Show()
			specWarnInpoundContraband:Play("targetyou")
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 322681 then
		if args:IsPlayer() then
			warnInpoundContrabandEnded:Show()
		end
	end
end

--[[
function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 320366 and destGUID == UnitGUID("player") and self:AntiSpam(2, 2) then
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 164578 then

	end
end


function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 257453  then

	end
end
--]]
