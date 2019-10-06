local mod	= DBM:NewMod(1227, "DBM-Party-WoD", 8, 559)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143517")
mod:SetCreatureID(76021)
mod:SetEncounterID(1758)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 161203 162600",
	"SPELL_CAST_START 161199 161203 155037",
	"SPELL_PERIODIC_DAMAGE 161288",
	"SPELL_ABSORBED 161288",
	"UNIT_DIED",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

local warnRejuvSerumCast			= mod:NewCastAnnounce(161203, 3)

local specWarnDebilitatingFixation	= mod:NewSpecialWarningInterrupt(161199, "HasInterrupt", nil, 3, 3, 2)
local specWarnEruption				= mod:NewSpecialWarningDodge(155037, "Tank", nil, nil, 1, 2)
local specWarnRejuvSerum			= mod:NewSpecialWarningDispel(161203, "MagicDispeller", nil, nil, 1, 2)
local specWarnToxicFumes			= mod:NewSpecialWarningDispel(162600, "RemovePoison", nil, 2, 1, 2)
local specWarnVilebloodSerum		= mod:NewSpecialWarningMove(161288, nil, nil, nil, 1, 8)

local timerDebilitatingCD			= mod:NewNextTimer(20, 161199, nil, nil, nil, 4, nil, DBM_CORE_INTERRUPT_ICON, nil, mod:IsTank() and 2, 4)--Every 20 seconds exactly, at least in challenge mode.
local timerEruptionCD				= mod:NewCDTimer(10, 155037, nil, false, nil, 5)--10-15 sec variation. May be distracting or spammy since two of them
--local timerRejuvSerumCD			= mod:NewCDTimer(33, 161203, nil, "MagicDispeller", nil, 5)--33-40sec variation. Could also be health based so disabled for now.
local timerVilebloodSerumCD			= mod:NewCDTimer(9.5, 161209, nil, nil, nil, 3)--every 9-10 seconds

function mod:OnCombatStart(delay)
--	timerRejuvSerumCD:Start(22.5-delay)--Insufficent sample size
	timerDebilitatingCD:Start(12-delay)--Insufficent sample size
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 161203 and not args:IsDestTypePlayer() then
		specWarnRejuvSerum:Show(args.destName)
--		timerRejuvSerumCD:Start()
		specWarnRejuvSerum:Play("dispelboss")
	elseif spellId == 162600 and self:CheckDispelFilter() then
		specWarnToxicFumes:Show(args.destName)
		specWarnToxicFumes:Play("dispelnow")
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 161199 then
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnDebilitatingFixation:Show(args.sourceName)
			specWarnDebilitatingFixation:Play("kickcast")
		end
		timerDebilitatingCD:Start()
	elseif spellId == 161203 then
		warnRejuvSerumCast:Show()
	elseif spellId == 155037 and self:IsInCombat() then
		specWarnEruption:Show()
		specWarnEruption:Play("watchstep")
		timerEruptionCD:Start(nil, args.sourceGUID)
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 161288 and destGUID == UnitGUID("player") then
		if self:AntiSpam(2, 1) then
			specWarnVilebloodSerum:Show()
			specWarnVilebloodSerum:Play("watchfeet")
		end
	end
end
mod.SPELL_ABSORBED = mod.SPELL_PERIODIC_DAMAGE

function mod:UNIT_DIED(args)
	if self:GetCIDFromGUID(args.destGUID) == 82556 then
		timerEruptionCD:Cancel(args.destGUID)
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
--	"<58.9 23:54:07> [UNIT_SPELLCAST_SUCCEEDED] Drakonid Monstrosity [[target:Vileblood Serum::0:161209]]", -- [1996]
	if spellId == 161209 and self:AntiSpam(3, 2) then
		timerVilebloodSerumCD:Start()
		if self:AntiSpam(2, 1) then
			specWarnVilebloodSerum:Show()--Always dropped on all players when cast, so moving during cast gets 0 ticks.
			specWarnVilebloodSerum:Play("watchfeet")
		end
	end
end
