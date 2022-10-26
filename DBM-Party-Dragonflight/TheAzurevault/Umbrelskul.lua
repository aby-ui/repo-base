local mod	= DBM:NewMod(2508, "DBM-Party-Dragonflight", 6, 1203)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220923021804")
mod:SetCreatureID(186738)
mod:SetEncounterID(2584)
--mod:SetUsedIcons(1, 2, 3)
--mod:SetHotfixNoticeRev(20220322000000)
--mod:SetMinSyncRevision(20211203000000)
--mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 384978 384699 385399 385075",
--	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED 384978"
--	"SPELL_AURA_APPLIED_DOSE",
--	"SPELL_AURA_REMOVED",
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
--	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--TODO, Current under-tuning makes the crystals and fracture completely inconsiquential. Until that changes, not much to do with those.
--TODO, target scan arcane eruption?
--TODO, it looks like blizzard killed off 385527 mechanic
local warnArcaneEruption						= mod:NewSpellAnnounce(385075, 3)

--local specWarnInfusedStrikes					= mod:NewSpecialWarningStack(361966, nil, 8, nil, nil, 1, 6)
local specWarnDragonStomp						= mod:NewSpecialWarningDefensive(384978, nil, nil, nil, 1, 2)
local specWarnDragonStompDebuff					= mod:NewSpecialWarningDispel(384978, "RemoveMagic", nil, nil, 1, 2)
local specWarnCrystallineRoar					= mod:NewSpecialWarningDodge(384699, nil, nil, nil, 3, 2)
local specWarnUnleashedDestruction				= mod:NewSpecialWarningSpell(385399, nil, nil, nil, 2, 2)
--local yellInfusedStrikes						= mod:NewYell(361966)
--local specWarnGTFO							= mod:NewSpecialWarningGTFO(340324, nil, nil, nil, 1, 8)

local timerDragonStompCD						= mod:NewAITimer(35, 384978, nil, "Tank|Healer|RemoveMagic", nil, 5, nil, DBM_COMMON_L.TANK_ICON..DBM_COMMON_L.MAGIC_ICON)
local timerCrystallineRoarCD					= mod:NewAITimer(35, 384699, nil, nil, nil, 3, nil, DBM_COMMON_L.DEADLY_ICON)
local timerUnleashedDestructionCD				= mod:NewAITimer(35, 385399, nil, nil, nil, 2)
local timerArcaneEruptionCD						= mod:NewAITimer(35, 385075, nil, nil, nil, 3)

--local berserkTimer							= mod:NewBerserkTimer(600)

--mod:AddRangeFrameOption("8")
--mod:AddInfoFrameOption(385527, "RemoveCurse")
--mod:AddSetIconOption("SetIconOnStaggeringBarrage", 361018, true, false, {1, 2, 3})

function mod:OnCombatStart(delay)
	timerDragonStompCD:Start(1-delay)
	timerCrystallineRoarCD:Start(1-delay)
	timerUnleashedDestructionCD:Start(1-delay)
	timerArcaneEruptionCD:Start(1-delay)
--	if self.Options.InfoFrame then
--		DBM.InfoFrame:SetHeader(DBM:GetSpellInfo(385527))
--		DBM.InfoFrame:Show(5, "playerdebuffremaining", 385527)
--	end
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
	if spellId == 384978 then
		if self:IsTanking("player", "boss1", nil, true) then
			specWarnDragonStomp:Show()
			specWarnDragonStomp:Play("defensive")
		end
		timerDragonStompCD:Start()
	elseif spellId == 384699 then
		specWarnCrystallineRoar:Show()
		specWarnCrystallineRoar:Play("shockwave")
		timerCrystallineRoarCD:Start()
	elseif spellId == 385399 then
		specWarnUnleashedDestruction:Show()
		specWarnUnleashedDestruction:Play("carefly")
		timerUnleashedDestructionCD:Start()
	elseif spellId == 385075 then
		warnArcaneEruption:Show()
		timerArcaneEruptionCD:Start()
	end
end

--[[
function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 362805 then

	end
end
--]]

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 384978 then
		local uId = DBM:GetRaidUnitId(args.destName)
		if self:IsTanking(uId) and self:CheckDispelFilter("magic") then
			specWarnDragonStompDebuff:Show(args.destName)
			specWarnDragonStompDebuff:Play("helpdispel")
		end
	end
end
--mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

--[[
function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 361966 then

	end
end

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
