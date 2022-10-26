local mod	= DBM:NewMod(2511, "DBM-Party-Dragonflight", 8, 1204)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220830020512")
mod:SetCreatureID(189729)
mod:SetEncounterID(2618)
--mod:SetUsedIcons(1, 2, 3)
--mod:SetHotfixNoticeRev(20220322000000)
--mod:SetMinSyncRevision(20211203000000)
--mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 387504 387571 388760 388424 387357",
	"SPELL_CAST_SUCCESS 388486",
	"SPELL_SUMMON 387474",
--	"SPELL_AURA_APPLIED",
--	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED 387618"
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
--	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--TODO: Warn Undertow? It's only used if tank is messing up
--TODO: Literally ANY phase 2 data. Again, fight is so undertuned on heroic that no one has even seen this bosses stage 2 because it dies in 20-30 seconds
--Stage One: Violent Swells
mod:AddTimerLine(DBM:EJ_GetSectionInfo(25529))
local warnFocusedDeluge							= mod:NewCastAnnounce(387571, 3)--On for everyone, since there will likely be many slow tanks in pugs
local warnInfusedGlobule						= mod:NewSpellAnnounce(387474, 2)
local warnTempestsFury							= mod:NewSpellAnnounce(388424, 3)

local specWarnSquallBuffet						= mod:NewSpecialWarningYou(387504, nil, nil, nil, 1, 2)
local specWarnRogueWaves						= mod:NewSpecialWarningDodge(388760, nil, nil, nil, 2, 2, 4)
--local yellInfusedStrikes						= mod:NewYell(361966)
--local specWarnGTFO							= mod:NewSpecialWarningGTFO(340324, nil, nil, nil, 1, 8)

local timerSquallBuffetCD						= mod:NewAITimer(35, 387504, DBM_COMMON_L.TANKCOMBO, "Tank|Healer", nil, 5, nil, DBM_COMMON_L.TANK_ICON)--Squall Buffet/Focused Deluge tank combo
local timerRogueWavesCD							= mod:NewAITimer(35, 388760, nil, nil, nil, 3, nil, DBM_COMMON_L.MYTHIC_ICON)
local timerInfusedGlobuleCD						= mod:NewAITimer(17.5, 387474, nil, nil, nil, 3)
local timerTempestsFuryCD						= mod:NewAITimer(29.9, 388424, nil, nil, nil, 2)

--Stage Two: Infused Waters
mod:AddTimerLine(DBM:EJ_GetSectionInfo(25531))
local warnCastAway								= mod:NewSpellAnnounce(388486, 2)
local warnCrashingTsunami						= mod:NewCastAnnounce(387357, 3)
local warnInfuse								= mod:NewFadesAnnounce(387618, 2)

local timerCastAwayCD							= mod:NewAITimer(29.9, 388486, nil, nil, nil, 6)
local timerCrashingTsunamiCD					= mod:NewAITimer(29.9, 387357, nil, nil, nil, 3)

--mod:AddRangeFrameOption("8")
--mod:AddInfoFrameOption(361651, true)
--mod:AddSetIconOption("SetIconOnStaggeringBarrage", 361018, true, false, {1, 2, 3})

function mod:OnCombatStart(delay)
	self:SetStage(1)
	timerSquallBuffetCD:Start(1-delay)--16
	timerInfusedGlobuleCD:Start(1-delay)--12
	timerTempestsFuryCD:Start(1-delay)--4
	timerCastAwayCD:Start(1-delay)
	if self:IsMythic() then
		timerRogueWavesCD:Start(1-delay)
	end
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
	if spellId == 387504 then
		timerSquallBuffetCD:Start()
		if self:IsTanking("player", "boss1", nil, true) then
			specWarnSquallBuffet:Show()
			specWarnSquallBuffet:Play("carefly")
		end
	elseif spellId == 387571 then
		warnFocusedDeluge:Show()
	elseif spellId == 388760 then
		specWarnRogueWaves:Show()
		specWarnRogueWaves:Play("watchwave")
		timerRogueWavesCD:Start()
	elseif spellId == 388424 then
		warnTempestsFury:Show()
		timerTempestsFuryCD:Start()
	elseif spellId == 387357 then
		warnCrashingTsunami:Show()
		timerCrashingTsunamiCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 388486 then
		self:SetStage(2)
		timerSquallBuffetCD:Stop()
		timerInfusedGlobuleCD:Stop()
		timerTempestsFuryCD:Stop()
		timerRogueWavesCD:Stop()

		timerCrashingTsunamiCD:Start(2)
		timerInfusedGlobuleCD:Start(2)
	end
end

function mod:SPELL_SUMMON(args)
	local spellId = args.spellId
	if spellId == 387474 and self:AntiSpam(3, 1) then
		warnInfusedGlobule:Show()
		timerInfusedGlobuleCD:Start()
	end
end

--[[
function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 387618 then

	end
end
--mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED
--]]

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 387618 and self.vb.phase == 2 then--Assumed
		self:SetStage(1)
		warnInfuse:Show()
		timerSquallBuffetCD:Start(3)
		timerInfusedGlobuleCD:Start(3)
		timerTempestsFuryCD:Start(3)
		timerCastAwayCD:Start(3)
		if self:IsMythic() then
			timerRogueWavesCD:Start(3)
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
