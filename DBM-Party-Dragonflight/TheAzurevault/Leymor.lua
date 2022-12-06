local mod	= DBM:NewMod(2492, "DBM-Party-Dragonflight", 6, 1203)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221206015003")
mod:SetCreatureID(186644)
mod:SetEncounterID(2582)
mod:SetUsedIcons(1, 2, 3)
mod:SetHotfixNoticeRev(20221127000000)
--mod:SetMinSyncRevision(20211203000000)
--mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 374364 374567 386660 374789",
	"SPELL_CAST_SUCCESS 374720",
	"SPELL_AURA_APPLIED 374567",
--	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED 374567"
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
--	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--TODO, verify number of players affected by explosive eruption
--TODO, who does Errupting Fissure target? verify target scan
--[[
(ability.id = 374364 or ability.id = 374567 or ability.id = 386660 or ability.id = 374789) and type = "begincast"
 or ability.id =  374720 and type = "cast"
 or type = "dungeonencounterstart" or type = "dungeonencounterend"
--]]
local warnLeylineSprouts						= mod:NewSpellAnnounce(374364, 3)
local warnExplosiveEruption						= mod:NewTargetNoFilterAnnounce(374567, 4)

local specWarnExplosiveEruption					= mod:NewSpecialWarningYouPos(374567, nil, nil, nil, 1, 2)
local yellExplosiveEruption						= mod:NewShortPosYell(374567)
local yellExplosiveEruptionFades				= mod:NewIconFadesYell(374567)
local specWarnConsumingStomp					= mod:NewSpecialWarningSpell(374720, nil, nil, nil, 2, 2)
local specWarnEruptingFissure					= mod:NewSpecialWarningDodge(386660, nil, nil, nil, 2, 2)
local yellEruptingFissure						= mod:NewYell(386660)
local specWarnInfusedStrike						= mod:NewSpecialWarningDefensive(374789, nil, nil, nil, 1, 2)
--local specWarnGTFO							= mod:NewSpecialWarningGTFO(340324, nil, nil, nil, 1, 8)

local timerLeylineSproutsCD						= mod:NewCDTimer(48.1, 374364, nil, nil, nil, 3)
local timerExplosiveEruptionCD					= mod:NewCDTimer(49.7, 374567, nil, nil, nil, 3)
local timerConsumingStompCD						= mod:NewCDTimer(49.7, 374720, nil, nil, nil, 2, nil, DBM_COMMON_L.DEADLY_ICON)
local timerEruptingFissureCD					= mod:NewCDTimer(49.7, 386660, nil, nil, nil, 3)
local timerInfusedStrikeCD						= mod:NewCDTimer(49.7, 374789, nil, "Tank|Healer", nil, 5, nil, DBM_COMMON_L.TANK_ICON)

--local berserkTimer							= mod:NewBerserkTimer(600)

--mod:AddRangeFrameOption("8")
--mod:AddInfoFrameOption(361651, true)
mod:AddSetIconOption("SetIconOnExplosiveEruption", 374567, true, false, {1, 2, 3})

mod.vb.DebuffIcon = 1

function mod:EruptionTarget(targetname)
	if not targetname then return end
	if targetname == UnitName("player") then
		yellEruptingFissure:Yell()
	end
end

function mod:OnCombatStart(delay)
	timerLeylineSproutsCD:Start(3.2-delay)
	timerInfusedStrikeCD:Start(10.1-delay)
	timerEruptingFissureCD:Start(20.2-delay)
	timerExplosiveEruptionCD:Start(30.7-delay)
	timerConsumingStompCD:Start(45.3-delay)
end

--function mod:OnCombatEnd()
--	if self.Options.RangeFrame then
--		DBM.RangeCheck:Hide()
--	end
--	if self.Options.InfoFrame then
--		DBM.InfoFrame:Hide()
--	end
--end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 374364 then
		warnLeylineSprouts:Show()
		timerLeylineSproutsCD:Start()
	elseif spellId == 374567 then
		self.vb.DebuffIcon = 1
		timerExplosiveEruptionCD:Start()
	elseif spellId == 386660 then
		self:ScheduleMethod(0.2, "BossTargetScanner", args.sourceGUID, "EruptionTarget", 0.1, 8, true)
		specWarnEruptingFissure:Show()
		specWarnEruptingFissure:Play("shockwave")
		timerEruptingFissureCD:Start()
	elseif spellId == 374789 then
		if self:IsTanking("player", "boss1", nil, true) then
			specWarnInfusedStrike:Show()
			specWarnInfusedStrike:Play("defensive")
		end
		timerInfusedStrikeCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 374720 then
		specWarnConsumingStomp:Show()
		specWarnConsumingStomp:Play("aesoon")
		timerConsumingStompCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 374567 then
		local icon = self.vb.DebuffIcon
		if self.Options.SetIconOnExplosiveEruption then
			self:SetIcon(args.destName, icon)
		end
		if args:IsPlayer() then
			specWarnExplosiveEruption:Show(self:IconNumToTexture(icon))
			specWarnExplosiveEruption:Play("mm"..icon)
			yellExplosiveEruption:Yell(icon, icon)
			yellExplosiveEruptionFades:Countdown(spellId, nil, icon)
		else
			warnExplosiveEruption:CombinedShow(0.5, args.destName)
		end
		self.vb.DebuffIcon = self.vb.DebuffIcon + 1
	end
end
--mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 374567 then
		if self.Options.SetIconOnExplosiveEruption then
			self:SetIcon(args.destName, 0)
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
