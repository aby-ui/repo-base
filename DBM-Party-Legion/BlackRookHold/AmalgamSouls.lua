local mod	= DBM:NewMod(1518, "DBM-Party-Legion", 1, 740)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220116185401")
mod:SetCreatureID(98542)
mod:SetEncounterID(1832)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 194966",
	"SPELL_CAST_START 195254 194966 194956 196078"
)

local warnSwirlingScythe			= mod:NewTargetNoFilterAnnounce(195254, 2)
local warnSoulEchoes				= mod:NewTargetAnnounce(194966, 2)
local warnCallSouls					= mod:NewSpellAnnounce(196078, 2)--Change to important warning if it becomes more relevant.

local specWarnReapSoul				= mod:NewSpecialWarningDodge(194956, "Tank", nil, nil, 3, 2)
local specWarnSoulEchos				= mod:NewSpecialWarningRun(194966, nil, nil, nil, 1, 2)
local specWarnSwirlingScythe		= mod:NewSpecialWarningDodge(195254, nil, nil, nil, 1, 2)
local yellSwirlingScythe			= mod:NewYell(195254)
local specWarnSwirlingScytheNear	= mod:NewSpecialWarningClose(195254, nil, nil, nil, 1, 2)

local timerSwirlingScytheCD			= mod:NewCDTimer(20.5, 195254, nil, nil, nil, 3)--20-27
local timerSoulEchoesCD				= mod:NewNextTimer(27.5, 194966, nil, nil, nil, 3)
local timerReapSoulCD				= mod:NewNextTimer(13, 194956, nil, nil, nil, 5, nil, DBM_COMMON_L.TANK_ICON..DBM_COMMON_L.DEADLY_ICON)

--mod:AddRangeFrameOption(5, 194966)

function mod:ScytheTarget(targetname, uId)
	if not targetname then
		warnSwirlingScythe:Show(DBM_COMMON_L.UNKNOWN)
		return
	end
	if targetname == UnitName("player") then
		specWarnSwirlingScythe:Show()
		specWarnSwirlingScythe:Play("runaway")
		yellSwirlingScythe:Yell()
	elseif self:CheckNearby(6, targetname) then
		specWarnSwirlingScytheNear:Show(targetname)
		specWarnSwirlingScytheNear:Play("runaway")
	else
		warnSwirlingScythe:Show(targetname)
	end
end

function mod:SoulTarget(targetname, uId)
	if not targetname then
		return
	end
	if self:AntiSpam(3, targetname) then
		if targetname == UnitName("player") then
			specWarnSoulEchos:Show()
			specWarnSoulEchos:Play("runaway")
			specWarnSoulEchos:ScheduleVoice(1, "keepmove")
		else
			warnSoulEchoes:Show(targetname)
		end
	end
end

function mod:OnCombatStart(delay)
	timerSwirlingScytheCD:Start(8-delay)
	timerSoulEchoesCD:Start(15.5-delay)
	timerReapSoulCD:Start(20-delay)
end

function mod:OnCombatEnd()
--	if self.Options.RangeFrame then
--		DBM.RangeCheck:Hide()
--	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 194966 and self:AntiSpam(3, args.destName) then--Backup Soul echos warning that's 2 seconds slower than target scan
		if args:IsPlayer() then
			specWarnSoulEchos:Show()
			specWarnSoulEchos:Play("runaway")
			specWarnSoulEchos:ScheduleVoice(1, "keepmove")
		else
			warnSoulEchoes:Show(args.destName)
		end
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 195254 then
		timerSwirlingScytheCD:Start()
		self:BossTargetScanner(98542, "ScytheTarget", 0.05, 12, true)--Can target tank if no one else is left, but if this causes probelm add tank filter back
	elseif spellId == 194966 then
		timerSoulEchoesCD:Start()
		self:BossTargetScanner(98542, "SoulTarget", 0.1, 20, true, nil, nil, nil, true)--Always filter tank, because if scan fails debuff will be used.
	elseif spellId == 194956 then
		specWarnReapSoul:Show()
		specWarnReapSoul:Play("shockwave")
		timerReapSoulCD:Start()
	elseif spellId == 196078 then
		warnCallSouls:Show()
		timerReapSoulCD:Stop()
		timerSwirlingScytheCD:Stop()
		timerSoulEchoesCD:Stop()
	end
end
