local mod	= DBM:NewMod(2353, "DBM-EternalPalace", nil, 1179)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("2019062320203")
mod:SetCreatureID(152364)
mod:SetEncounterID(2305)
mod:SetZone()
mod:SetUsedIcons(1, 2)
--mod:SetHotfixNoticeRev(16950)
--mod:SetMinSyncRevision(16950)
--mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 296546 296459 296894 302465 295916 296701 304098",
	"SPELL_CAST_SUCCESS 296737",
	"SPELL_AURA_APPLIED 296566 296737",
	"SPELL_AURA_REMOVED 296737",
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
	"UNIT_DIED",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--TODO, verify correct unshackled power spellid for LFR
--TODO, see if heroic timers changed.
--[[
(ability.id = 296546 or ability.id = 296459 or ability.id = 296894 or ability.id = 302465 or ability.id = 295916 or ability.id = 296701) and type = "begincast"
 or ability.id = 296737 and type = "cast"
 or type = "death" and target.id = 152512
--]]
local warnArcanadoBurst					= mod:NewSpellAnnounce(296430, 2)
local warnSquallTrap					= mod:NewSpellAnnounce(296459, 4)
local warnArcaneBomb					= mod:NewTargetNoFilterAnnounce(296737, 4)

--Rising Fury
local specWarnTideFistCast				= mod:NewSpecialWarningDefensive(296566, nil, nil, nil, 1, 2)
local specWarnTideFist					= mod:NewSpecialWarningTaunt(296566, nil, nil, nil, 1, 2)
local specWarnArcaneBomb				= mod:NewSpecialWarningMoveAway(296737, nil, nil, nil, 1, 2)
local yellArcaneBomb					= mod:NewPosYell(296737)
local yellArcaneBombFades				= mod:NewIconFadesYell(296737)
local specWarnUnshackledPower			= mod:NewSpecialWarningCount(296894, nil, nil, nil, 2, 2)
--Raging Storm
local specWarnAncientTempest			= mod:NewSpecialWarningSpell(295916, nil, nil, nil, 2, 2)
local specWarnGaleBuffet				= mod:NewSpecialWarningSpell(296701, nil, nil, nil, 2, 2)
--local specWarnGTFO						= mod:NewSpecialWarningGTFO(270290, nil, nil, nil, 1, 8)

--Rising Fury
mod:AddTimerLine(DBM:EJ_GetSectionInfo(20076))
local timerTideFistCD					= mod:NewNextCountTimer(58.2, 296546, nil, "Tank", nil, 5, nil, DBM_CORE_TANK_ICON, nil, mod:IsTank() and 2, 4)
local timerArcanadoBurstCD				= mod:NewNextCountTimer(58.2, 296430, nil, nil, nil, 3)
local timerArcaneBombCD					= mod:NewNextCountTimer(58.2, 296737, nil, "-Tank", nil, 3, nil, nil, nil, 3, 4)
local timerUnshacklingPowerCD			= mod:NewNextCountTimer(58.2, 296894, nil, nil, nil, 2, nil, DBM_CORE_HEALER_ICON, nil, 1, 4)
local timerAncientTempestCD				= mod:NewNextTimer(95.9, 295916, nil, nil, nil, 6)
--Raging Storm
mod:AddTimerLine(DBM:EJ_GetSectionInfo(20078))
local timerGaleBuffetCD					= mod:NewCDTimer(22.7, 296701, nil, nil, nil, 2)

--local berserkTimer					= mod:NewBerserkTimer(600)

--mod:AddRangeFrameOption(6, 264382)
--mod:AddInfoFrameOption(275270, true)
mod:AddSetIconOption("SetIconOnArcaneBomb", 296737, true, false, {1, 2})

mod.vb.unshackledCount = 0
mod.vb.arcanadoCount = 0
mod.vb.tideFistCount = 0
mod.vb.arcaneBombCount = 0
mod.vb.arcaneBombicon = 1
mod.vb.tempestStage = false
mod.vb.addsLeft = 1
mod.vb.difficultyName = "None"
local arcanadoTimers = {
	["lfr"] = {5.9, 12.0, 13.1, 10.5, 12.0, 13.1, 10.6},--Not verified
	["normal"] = {5.9, 12.0, 13.1, 10.5, 12.0, 13.1, 10.6},
	["heroic"] = {5.9, 12.0, 13.1, 10.5, 12.0, 13.1, 10.6},--Not Verified, but old ones were scrapped
	["mythic"] = {5.9, 12.0, 13.1, 10.5, 12.0, 13.1, 10.6}
}
local tideFistTimers = {
	["lfr"] = {15.1, 20.0, 19.0, 20.0},--Not verified
	["normal"] = {15.1, 20.0, 19.0, 20.0},
	["heroic"] = {15.1, 20.0, 19.0, 20.0},--Not Verified, but old ones were scrapped
	["mythic"] = {15.1, 20.0, 19.0, 20.0}
}
local unshackledPowerTimers = {
	["lfr"] = {10.0, 18.0, 18.0, 18.0, 18.0},--Not verified
	["normal"] = {10.0, 18.0, 18.0, 18.0, 18.0},--Same as mythic
	["heroic"] = {10.0, 18.0, 18.0, 18.0, 18.0},--Not Verified, but old ones were scrapped
	["mythic"] = {10.0, 18.0, 18.0, 18.0, 18.0}
}
local arcaneBombTimers = {
	["lfr"] = {7.1, 19.9, 22.1, 18.0, 25.5},--Not verified
	["normal"] = {7.1, 19.9, 22.1, 18.0, 25.5},--Same as Mythic
	["heroic"] = {7.1, 19.9, 22.1, 18.0, 25.5},--Not Verified, but old ones were scrapped
	["mythic"] = {7.1, 19.9, 22.1, 18.0, 25.5}
}

function mod:OnCombatStart(delay)
	self.vb.unshackledCount = 0
	self.vb.arcanadoCount = 0
	self.vb.tideFistCount = 0
	self.vb.arcaneBombCount = 0
	self.vb.arcaneBombicon = 1
	self.vb.tempestStage = false
	--Seem same in heroic and mythic thus far
	timerArcanadoBurstCD:Start(6-delay, 1)
	timerArcaneBombCD:Start(7-delay, 1)
	timerUnshacklingPowerCD:Start(10-delay, 1)
	timerTideFistCD:Start(15-delay, 1)
	timerAncientTempestCD:Start(95.8)
	if self:IsMythic() then
		self.vb.difficultyName = "mythic"
	elseif self:IsHeroic() then
		self.vb.difficultyName = "heroic"
	elseif self:IsNormal() then
		self.vb.difficultyName = "normal"
	else
		self.vb.difficultyName = "lfr"
	end
end

function mod:OnCombatEnd()
--	if self.Options.InfoFrame then
--		DBM.InfoFrame:Hide()
--	end
--	if self.Options.RangeFrame then
--		DBM.RangeCheck:Hide()
--	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 296546 then
		self.vb.tideFistCount = self.vb.tideFistCount + 1
		if self:IsTanking("player", "boss1", nil, true) then
			specWarnTideFistCast:Show()
			specWarnTideFistCast:Play("defensive")
		end
		local timer = tideFistTimers[self.vb.difficultyName][self.vb.tideFistCount+1]
		if timer then
			timerTideFistCD:Start(timer, self.vb.tideFistCount+1)
		end
	elseif spellId == 296459 then
		warnSquallTrap:Show()
	elseif spellId == 296894 or spellId == 302465 then--296894 verified heroic and mythic, 302465 unknown (maybe lfr)
		self.vb.unshackledCount = self.vb.unshackledCount + 1
		specWarnUnshackledPower:Show(self.vb.unshackledCount)
		specWarnUnshackledPower:Play("aesoon")
		local timer = unshackledPowerTimers[self.vb.difficultyName][self.vb.unshackledCount+1]
		if timer then
			timerUnshacklingPowerCD:Start(timer, self.vb.unshackledCount+1)
		end
	elseif spellId == 295916 then--Ancient Tempest (phase change)
		self.vb.tempestStage = true
		self.vb.arcaneBombCount = 0
		if self:IsMythic() then
			self.vb.addsLeft = 2
		else
			self.vb.addsLeft = 1
		end
		timerTideFistCD:Stop()
		timerArcanadoBurstCD:Stop()
		timerArcaneBombCD:Stop()
		timerUnshacklingPowerCD:Stop()
		specWarnAncientTempest:Show()
		specWarnAncientTempest:Play("phasechange")
		if self:IsMythic() then
			timerArcaneBombCD:Start(12.6, 1)
			timerGaleBuffetCD:Start(18)
		else
			timerArcaneBombCD:Start(17.1, 1)
			timerGaleBuffetCD:Start(22)
		end
	elseif spellId == 296701 or spellId == 304098 then
		if self:CheckBossDistance(args.sourceGUID, true, 34471) then--43 yards
			specWarnGaleBuffet:Show()
			specWarnGaleBuffet:Play("carefly")
		end
		timerGaleBuffetCD:Start(nil, args.sourceGUID)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 296737 and self:AntiSpam(5, 1) then
		self.vb.arcaneBombicon = 1
		self.vb.arcaneBombCount = self.vb.arcaneBombCount + 1
		local timer = self.vb.tempestStage and 20 or arcaneBombTimers[self.vb.difficultyName][self.vb.arcaneBombCount+1]
		if timer then
			timerArcaneBombCD:Start(timer, self.vb.arcaneBombCount+1)
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 296566 then
		if not args:IsPlayer() then
			specWarnTideFist:Show(args.destName)
			specWarnTideFist:Play("tauntboss")
		end
	elseif spellId == 296737 then
		warnArcaneBomb:CombinedShow(0.3, args.destName)
		local icon = self.vb.arcaneBombicon
		if args:IsPlayer() then
			specWarnArcaneBomb:Show()
			specWarnArcaneBomb:Play("runout")
			yellArcaneBomb:Yell(icon, icon, icon)
			yellArcaneBombFades:Countdown(spellId, nil, icon)
		end
		if self.Options.SetIconOnArcaneBomb then
			self:SetIcon(args.destname, self.vb.arcaneBombicon)
		end
		self.vb.arcaneBombicon = self.vb.arcaneBombicon + 1
	end
end
--mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 296737 then
		if args:IsPlayer() then
			yellArcaneBombFades:Cancel()
		end
		if self.Options.SetIconOnArcaneBomb then
			self:SetIcon(args.destname, 0)
		end
	end
end

--[[
function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 270290 and destGUID == UnitGUID("player") and self:AntiSpam(2, 2) then
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE
--]]

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 152512 then--Stormwraith
		timerGaleBuffetCD:Stop(args.destGUID)
		self.vb.addsLeft = self.vb.addsLeft - 1
		if self.vb.addsLeft == 0 then
			self.vb.tempestStage = false
			self.vb.unshackledCount = 0
			self.vb.arcanadoCount = 0
			self.vb.tideFistCount = 0
			self.vb.arcaneBombCount = 0
			timerArcaneBombCD:Stop()
			timerArcanadoBurstCD:Start(6, 1)
			timerArcaneBombCD:Start(7, 1)
			timerUnshacklingPowerCD:Start(10, 1)
			timerTideFistCD:Start(15, 1)
			timerAncientTempestCD:Start(95.8)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 296428 then--Arcanado Burst
		self.vb.arcanadoCount = self.vb.arcanadoCount + 1
		warnArcanadoBurst:Show(self.vb.arcanadoCount)
		local timer = arcanadoTimers[self.vb.difficultyName][self.vb.arcanadoCount+1]
		if timer then
			timerArcanadoBurstCD:Start(timer, self.vb.arcanadoCount+1)
		end
	end
end
