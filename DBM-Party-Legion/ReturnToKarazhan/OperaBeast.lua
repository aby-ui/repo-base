local mod	= DBM:NewMod(1827, "DBM-Party-Legion", 11, 860)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "heroic,mythic,challenge"

mod:SetRevision("20220116042005")
mod:SetCreatureID(114329, 114522, 114330, 114328)
mod:SetEncounterID(1957)--Shared (so not used for encounter START since it'd fire 3 mods)
mod:DisableESCombatDetection()--However, with ES disabled, EncounterID can be used for BOSS_KILL/ENCOUNTER_END
mod:SetUsedIcons(1)
--mod:SetHotfixNoticeRev(14922)
mod:SetBossHPInfoToHighest()
--mod.respawnTime = 30

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 228025 228019 227987 232153",
	"SPELL_AURA_APPLIED 228013 228221 228225 227985",
	"SPELL_AURA_REMOVED 232156 228221",
	"SPELL_PERIODIC_DAMAGE 228200",
	"SPELL_PERIODIC_MISSED 228200",
	"UNIT_DIED"
)

--TODO: Timers
--Babblet
local warnSevereDusting				= mod:NewTargetAnnounce(228221, 3)
--Cogglestone
local warnKaraKazham				= mod:NewSpellAnnounce(232153, 2)

--Luminore
local specWarnBurningBlaze			= mod:NewSpecialWarningMove(228193, nil, nil, nil, 1, 2)
local specWarnHeatWave				= mod:NewSpecialWarningInterrupt(228025, "HasInterrupt", nil, nil, 1, 2)
--Mrs.Cauldrons
local specWarnDrenched				= mod:NewSpecialWarningMoveTo(228013, nil, nil, nil, 1)--Voice?
local specWarnLeftovers				= mod:NewSpecialWarningInterrupt(228019, "HasInterrupt", nil, nil, 1, 2)
--Babblet
local specWarnSevereDusting			= mod:NewSpecialWarningRun(228221, nil, nil, nil, 4, 2)
local specWarnSultryheat			= mod:NewSpecialWarningDispel(228225, "MagicDispeller", nil, nil, 1, 2)
--Coggleston
local specWarnDentArmor				= mod:NewSpecialWarningDefensive(227985, nil, nil, nil, 1, 2)
local specWarnDinnerBell			= mod:NewSpecialWarningInterrupt(227987, "HasInterrupt", nil, nil, 1, 2)

--Luminore
local timerHeatWaveCD				= mod:NewCDTimer(26, 228025, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)
--Mrs.Cauldrons
local timerLeftoversCD				= mod:NewCDTimer(17, 228019, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)
--Babblet
local timerSevereDustingCD			= mod:NewCDTimer(12, 228221, nil, nil, nil, 3)
--Coggleston
local timerDentArmorCD				= mod:NewCDTimer(20, 227985, nil, "Tank|Healer", nil, 5)
local timerDinnerBellCD				= mod:NewCDTimer(10.9, 227987, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)

--local berserkTimer				= mod:NewBerserkTimer(300)

mod:AddSetIconOption("SetIconOnDusting", 228221, true, false, {1})
--mod:AddInfoFrameOption(198108, false)

local burningBlaze = DBM:GetSpellInfo(228193)

function mod:OnCombatStart(delay)
	self:SetStage(1)
	timerLeftoversCD:Start(7.3-delay)
	timerHeatWaveCD:Start(31.6-delay)
end

function mod:OnCombatEnd()

end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 228025 then
		timerHeatWaveCD:Start()
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnHeatWave:Show(args.sourceName)
			specWarnHeatWave:Play("kickcast")
		end
	elseif spellId == 228019 then
		timerLeftoversCD:Start()
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnLeftovers:Show(args.sourceName)
			specWarnLeftovers:Play("kickcast")
		end
	elseif spellId == 227987 then
		timerDinnerBellCD:Start()
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnDinnerBell:Show(args.sourceName)
			specWarnDinnerBell:Play("kickcast")
		end
	elseif spellId == 232153 then
		warnKaraKazham:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 228013 then
		if args:IsPlayer() then
			specWarnDrenched:Show(burningBlaze)
		end
	elseif spellId == 228221 then
		timerSevereDustingCD:Update(0, 12)
		if args:IsPlayer() then
			specWarnSevereDusting:Show()
			specWarnSevereDusting:Play("justrun")
			specWarnSevereDusting:ScheduleVoice(1, "keepmove")
		else
			warnSevereDusting:Show(args.destName)
		end
		if self.Options.SetIconOnDusting then
			self:SetIcon(args.destName, 1)
		end
	elseif spellId == 228225 and not args:IsDestTypePlayer() then
		specWarnSultryheat:Show(args.destName)
		specWarnSultryheat:Play("dispelnow")
	elseif spellId == 227985 then
		timerDentArmorCD:Start()
		if args:IsPlayer() then
			specWarnDentArmor:Show()
			specWarnDentArmor:Play("defensive")
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 232156 then--Spectral Service
		self:SetStage(2)
		timerDinnerBellCD:Start(8)
		timerDentArmorCD:Start(15.5)
	elseif spellId == 228221 and self.Options.SetIconOnDusting then
		self:SetIcon(args.destName, 0)
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 228200 and destGUID == UnitGUID("player") and self:AntiSpam(2, 1) then
		specWarnBurningBlaze:Show()
		specWarnBurningBlaze:Play("runaway")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 114329 then--Luminore
		timerHeatWaveCD:Stop()
	elseif cid == 114522 then--Mrs.Cauldrons
		timerLeftoversCD:Stop()
	elseif cid == 114330 then--Babblet
		timerSevereDustingCD:Stop()
	elseif cid == 114328 then--Coggleston (Needed, pretty sure fight is over here)

	end
end

--[[
function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 206341 then

	end
end
--]]
