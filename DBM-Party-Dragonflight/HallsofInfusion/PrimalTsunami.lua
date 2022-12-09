local mod	= DBM:NewMod(2511, "DBM-Party-Dragonflight", 8, 1204)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221208071706")
mod:SetCreatureID(189729)
mod:SetEncounterID(2618)
--mod:SetUsedIcons(1, 2, 3)
mod:SetHotfixNoticeRev(20221207000000)
--mod:SetMinSyncRevision(20211203000000)
--mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 387504 387571 388760 388424 387559",
	"SPELL_AURA_APPLIED 387585",
--	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED 387585"
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
--	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--TODO: Warn Undertow? It's only used if tank is messing up
--[[
(ability.id = 387504 or ability.id = 387571 or ability.id = 388760 or ability.id = 388424 or ability.id = 387559) and type = "begincast"
 or ability.id = 387585
 or type = "dungeonencounterstart" or type = "dungeonencounterend"
--]]
--Stage One: Violent Swells
mod:AddTimerLine(DBM:EJ_GetSectionInfo(25529))
local warnFocusedDeluge							= mod:NewCastAnnounce(387571, 3)--On for everyone, since there will likely be many slow tanks in pugs
local warnInfusedGlobule						= mod:NewSpellAnnounce(387474, 2)
local warnTempestsFury							= mod:NewSpellAnnounce(388424, 3)

local specWarnSquallBuffet						= mod:NewSpecialWarningYou(387504, nil, nil, nil, 1, 2)
local specWarnRogueWaves						= mod:NewSpecialWarningDodge(388760, nil, nil, nil, 2, 2, 4)
--local yellInfusedStrikes						= mod:NewYell(361966)
--local specWarnGTFO							= mod:NewSpecialWarningGTFO(340324, nil, nil, nil, 1, 8)

local timerSquallBuffetCD						= mod:NewCDTimer(35, 387504, DBM_COMMON_L.TANKCOMBO, "Tank|Healer", nil, 5, nil, DBM_COMMON_L.TANK_ICON)--Squall Buffet/Focused Deluge tank combo
local timerRogueWavesCD							= mod:NewCDTimer(13, 388760, nil, nil, nil, 3, nil, DBM_COMMON_L.MYTHIC_ICON)
local timerInfusedGlobuleCD						= mod:NewCDTimer(19.1, 387474, nil, nil, nil, 3)
local timerTempestsFuryCD						= mod:NewCDTimer(29.9, 388424, nil, nil, nil, 2)

--Stage Two: Infused Waters
mod:AddTimerLine(DBM:EJ_GetSectionInfo(25531))
local warnSubmerged								= mod:NewSpellAnnounce(387585, 2)
local warnSubmergedEnded						= mod:NewEndAnnounce(387585, 2)

local timerSubmergedCD							= mod:NewCDTimer(29.9, 387585, nil, nil, nil, 6)

--mod:AddRangeFrameOption("8")
--mod:AddInfoFrameOption(361651, true)
--mod:AddSetIconOption("SetIconOnStaggeringBarrage", 361018, true, false, {1, 2, 3})

mod.vb.rogueCount = 0

function mod:OnCombatStart(delay)
	self:SetStage(1)
	self.vb.rogueCount = 0
	timerTempestsFuryCD:Start(4-delay)
	timerInfusedGlobuleCD:Start(8-delay)--12
	timerSquallBuffetCD:Start(18-delay)
	timerSubmergedCD:Start(52.1-delay)--Phasing timer
	if self:IsMythic() then
		timerRogueWavesCD:Start(15-delay)
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
--		timerSquallBuffetCD:Start()--NEED MORE DATA
		if self:IsTanking("player", "boss1", nil, true) then
			specWarnSquallBuffet:Show()
			specWarnSquallBuffet:Play("carefly")
		end
	elseif spellId == 387571 then
		warnFocusedDeluge:Show()
	elseif spellId == 388760 then
		self.vb.rogueCount = self.vb.rogueCount + 1
		specWarnRogueWaves:Show()
		specWarnRogueWaves:Play("watchwave")
		timerRogueWavesCD:Start(self.vb.rogueCount == 1 and 15 or 13)
	elseif spellId == 388424 then
		warnTempestsFury:Show()
		timerTempestsFuryCD:Start()
	elseif spellId == 387559 then
		warnInfusedGlobule:Show()
		timerInfusedGlobuleCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 387585 then--Submerged
		self:SetStage(2)
		warnSubmerged:Show()
		timerSquallBuffetCD:Stop()
		timerInfusedGlobuleCD:Stop()
		timerTempestsFuryCD:Stop()
		timerRogueWavesCD:Stop()

--		timerInfusedGlobuleCD:Start(2)--Boss didn't use this during submerged on M0 despite what jouranl says
	end
end
--mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 387585 and self.vb.phase == 2 then--Submerged
		self:SetStage(1)
		self.vb.rogueCount = 0
		warnSubmerged:Show()
		timerTempestsFuryCD:Start(7)
		timerInfusedGlobuleCD:Start(11)
		--NEED MORE DATA, drycoded
		timerSquallBuffetCD:Start(21)
		timerSubmergedCD:Start(55)
		if self:IsMythic() then
			timerRogueWavesCD:Start(18)
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
