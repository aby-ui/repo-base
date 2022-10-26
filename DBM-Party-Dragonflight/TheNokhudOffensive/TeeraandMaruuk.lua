local mod	= DBM:NewMod(2478, "DBM-Party-Dragonflight", 3, 1198)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221015205747")
mod:SetCreatureID(186339, 186338)
mod:SetEncounterID(2581)
--mod:SetUsedIcons(1, 2, 3)
mod:SetBossHPInfoToHighest()
--mod:SetHotfixNoticeRev(20220322000000)
--mod:SetMinSyncRevision(20211203000000)
--mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 382670 386063 385339 386547 385434 382836",
--	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED 384808",
--	"SPELL_AURA_APPLIED_DOSE",
--	"SPELL_AURA_REMOVED"
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
	"UNIT_DIED"
--	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--[[
(ability.id = 382670 or ability.id = 386063 or ability.id = 385339 or ability.id = 386547 or ability.id = 385434 or ability.id = 382836) and type = "begincast"
 or (target.id = 186339 or target.id = 186338) and type = "death"
--]]
--Teera
mod:AddTimerLine(DBM:EJ_GetSectionInfo(25552))
local warnRepel									= mod:NewCastAnnounce(386547, 3, nil, nil, nil, nil, nil, 2)
local warnSpiritLeap							= mod:NewSpellAnnounce(385434, 3)

local specWarnGaleArrow							= mod:NewSpecialWarningDodge(382670, nil, nil, nil, 2, 2)
local specWarnGuardianWind						= mod:NewSpecialWarningInterrupt(384808, "HasInterrupt", nil, nil, 1, 2)

local timerGaleArrowCD							= mod:NewAITimer(35, 382670, nil, nil, nil, 3)--Acts as Gale Arrow and Frightful Roar timer (they are paired abilities)
local timerSpiritLeapCD							= mod:NewAITimer(35, 385434, nil, nil, nil, 3)

--Maruuk
mod:AddTimerLine(DBM:EJ_GetSectionInfo(25546))
local warnFrightfulRoar							= mod:NewCastAnnounce(386063, 3, nil, nil, nil, nil, nil, 2)--Not a special warning, since I don't want to layer 2 special warings for same pair

local specWarnEarthsplitter						= mod:NewSpecialWarningDodge(385339, nil, nil, nil, 2, 2)
local specWarnBrutalize							= mod:NewSpecialWarningDefensive(382836, nil, nil, nil, 1, 2)

local timerEarthSplitterCD						= mod:NewAITimer(35, 385339, nil, nil, nil, 3, nil, DBM_COMMON_L.DEADLY_ICON)--Acts as timer for both this and Repel (they are paired abilities)
local timerBrutalizeCD							= mod:NewAITimer(35, 382836, nil, "Tank|Healer", nil, 5, nil, DBM_COMMON_L.TANK_ICON)

--local berserkTimer							= mod:NewBerserkTimer(600)

--mod:AddRangeFrameOption("8")
--mod:AddInfoFrameOption(361651, true)
--mod:AddSetIconOption("SetIconOnStaggeringBarrage", 361018, true, false, {1, 2, 3})

--[[
--Use for spirit leap if it's on players and scanable
function mod:ArrowTarget(targetname)
	if not targetname then return end
	if targetname == UnitName("player") then
		specWarnHeavyArrow:Show()
		specWarnHeavyArrow:Play("targetyou")
		yellHeavyArrow:Yell()
	else
		warnHeavyArrow:Show(targetname)
	end
end
--]]

function mod:OnCombatStart(delay)
	--Terra
	timerGaleArrowCD:Start(1-delay)
	timerSpiritLeapCD:Start(1-delay)
	--Maruuk
	timerEarthSplitterCD:Start(1-delay)
	timerBrutalizeCD:Start(1-delay)
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
	if spellId == 382670 then
		specWarnGaleArrow:Show()
		specWarnGaleArrow:Play("watchstep")
		timerGaleArrowCD:Start()
	elseif spellId == 386063 then
		warnFrightfulRoar:Show()
		warnFrightfulRoar:Play("fearsoon")
	elseif spellId == 385339 then
		specWarnEarthsplitter:Show()
		specWarnEarthsplitter:Play("watchstep")
		timerEarthSplitterCD:Start()
	elseif spellId == 386547 then
		warnRepel:Show()
		warnRepel:Play("carefly")
	elseif spellId == 385434 then
--		self:ScheduleMethod(0.2, "BossTargetScanner", args.sourceGUID, "ArrowTarget", 0.1, 8, true)
		warnSpiritLeap:Show()
		timerSpiritLeapCD:Start()
	elseif spellId == 382836 then
		if self:IsTanking("player", nil, nil, true, args.sourceGUID) then
			specWarnBrutalize:Show()
			specWarnBrutalize:Play("defensive")
		end
		timerBrutalizeCD:Start()
	end
end

--[[
function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 362805 then

	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 384808 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnGuardianWind:Show(args.sourceName)
		specWarnGuardianWind:Play("kickcast")
	end
end
--mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 361966 then

	end
end
--]]

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 186339 then--Teera
		timerGaleArrowCD:Stop()
		timerSpiritLeapCD:Stop()
	elseif cid == 186338 then--Maruuk
		timerEarthSplitterCD:Stop()
		timerBrutalizeCD:Stop()
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
