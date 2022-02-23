local mod	= DBM:NewMod(1997, "DBM-AntorusBurningThrone", nil, 946)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220216092721")
mod:SetCreatureID(122369, 122333, 122367)--Chief Engineer Ishkar, General Erodus, Admiral Svirax
mod:SetEncounterID(2070)
mod:SetBossHPInfoToHighest()
mod:SetUsedIcons(7, 8)
mod:SetHotfixNoticeRev(16939)
mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 244625 246505 253040 245227",
	"SPELL_CAST_SUCCESS 244722 244892 245227 253037 245174",
	"SPELL_AURA_APPLIED 244737 244892 253015 244172",
	"SPELL_AURA_APPLIED_DOSE 244892 244172",
	"SPELL_AURA_REMOVED 244737 253015",
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
	"UNIT_SPELLCAST_SUCCEEDED boss1 boss2 boss3"
)

local Svirax = DBM:EJ_GetSectionInfo(16126)
local Ishkar = DBM:EJ_GetSectionInfo(16128)
local Erodus = DBM:EJ_GetSectionInfo(16130)
--TODO, boss health was reporting unknown in streams, verify/fix boss CIDs
--[[
(ability.id = 244625 or ability.id = 253040 or ability.id = 245227 or ability.id = 125012 or ability.id = 125014 or ability.id = 126258) and type = "begincast"
 or (ability.id = 244722 or ability.id = 244892) and type = "cast" or (ability.id = 245174 or ability.id = 244947) and type = "summon"
 or ability.id = 253015
--]]
--General
mod:AddTimerLine(GENERAL)
local warnOutofPod						= mod:NewTargetNoFilterAnnounce("ej16098", 2, 244141)
local warnExploitWeakness				= mod:NewStackAnnounce(244892, 2, nil, "Tank")
local warnPsychicAssault				= mod:NewStackAnnounce(244172, 3, nil, "-Tank", 2)

--local specWarnGTFO					= mod:NewSpecialWarningGTFO(238028, nil, nil, nil, 1, 2)
local specWarnExploitWeakness			= mod:NewSpecialWarningTaunt(244892, nil, nil, nil, 1, 2)
local specWarnPsychicAssaultStack		= mod:NewSpecialWarningStack(244172, nil, 10, nil, nil, 1, 6)
local specWarnPsychicAssault			= mod:NewSpecialWarningMove(244172, nil, nil, nil, 3, 2)--Two diff warnings cause we want to upgrade to high priority at 19+ stacks
local specWarnAssumeCommand				= mod:NewSpecialWarningSwitch(253040, "Tank", nil, nil, 1, 2)

local timerExploitWeaknessCD			= mod:NewCDTimer(8.5, 244892, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON, nil, 2, 3)
local timerAssumeCommandCD				= mod:NewNextTimer(90, 245227, nil, nil, nil, 6, nil, nil, nil, 2, 4)

--local berserkTimer					= mod:NewBerserkTimer(600)
----Admiral Svirax
mod:AddTimerLine(Svirax)
local warnShockGrenade					= mod:NewTargetAnnounce(244737, 3, nil, false, 2)

local specWarnShockGrenade				= mod:NewSpecialWarningMoveAway(244737, nil, nil, nil, 1, 2)
local yellShockGrenade					= mod:NewShortYell(244737)
local yellShockGrenadeFades				= mod:NewShortFadesYell(244737)
local specWarnFusillade					= mod:NewSpecialWarningMoveTo(244625, nil, nil, nil, 1, 5)

local timerShockGrenadeCD				= mod:NewCDTimer(14.7, 244737, nil, nil, nil, 3, nil, DBM_COMMON_L.HEROIC_ICON)
local timerFusilladeCD					= mod:NewNextCountTimer(29.3, 244625, nil, nil, nil, 2, nil, DBM_COMMON_L.DEADLY_ICON, nil, 3, 4)

mod:AddRangeFrameOption(8, 244737)
----Chief Engineer Ishkar
mod:AddTimerLine(Ishkar)
local warnEntropicMine					= mod:NewSpellAnnounce(245161, 2)

--local specWarnEntropicMine				= mod:NewSpecialWarningDodge(245161, nil, nil, nil, 1, 2)

local timerEntropicMineCD				= mod:NewCDTimer(10, 245161, nil, nil, nil, 3)
----General Erodus
mod:AddTimerLine(Erodus)
--local warnSummonReinforcements			= mod:NewSpellAnnounce(245546, 2, nil, false, 2)
local warnDemonicCharge					= mod:NewTargetAnnounce(253040, 2, nil, false, 2)

local specWarnSummonReinforcements		= mod:NewSpecialWarningSwitch(245546, nil, nil, nil, 1, 2)

local timerSummonReinforcementsCD		= mod:NewNextTimer(8.4, 245546, nil, nil, nil, 1, nil, DBM_COMMON_L.DAMAGE_ICON, nil, 1, 4)

mod:AddSetIconOption("SetIconOnAdds", 245546, true, true)
-------Adds
local specWarnPyroblast					= mod:NewSpecialWarningInterrupt(246505, "HasInterrupt", nil, nil, 1, 2)
local specWarnDemonicChargeYou			= mod:NewSpecialWarningYou(253040, nil, nil, nil, 1, 2)
local specWarnDemonicCharge				= mod:NewSpecialWarningClose(253040, nil, nil, nil, 1, 2)
local yellDemonicCharge					= mod:NewYell(253040)

local felShield = DBM:GetSpellInfo(244910)
mod.vb.FusilladeCount = 0
mod.vb.lastIcon = 8

function mod:DemonicChargeTarget(targetname, uId)
	if not targetname then return end
	if targetname == UnitName("player") then
		if self:AntiSpam(3, 5) then
			specWarnDemonicChargeYou:Show()
			specWarnDemonicChargeYou:Play("runaway")
			yellDemonicCharge:Yell()
		end
	elseif self:AntiSpam(3.5, 2) and self:CheckNearby(10, targetname) then
		specWarnDemonicCharge:Show(targetname)
		specWarnDemonicCharge:Play("watchstep")
	else
		warnDemonicCharge:Show(targetname)
	end
end

function mod:OnCombatStart(delay)
	self.vb.FusilladeCount = 0
	self.vb.lastIcon = 8
	--In pod
	timerEntropicMineCD:Start(5.1-delay)
	--Out of Pod
	timerSummonReinforcementsCD:Start(8-delay)
	timerAssumeCommandCD:Start(90-delay)
	if self:IsMythic() then
		timerShockGrenadeCD:Start(15)
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 244625 then
		self.vb.FusilladeCount = self.vb.FusilladeCount + 1
		specWarnFusillade:Show(felShield)
		specWarnFusillade:Play("findshield")
		timerFusilladeCD:Start(nil, self.vb.FusilladeCount+1)
	elseif spellId == 246505 then
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnPyroblast:Show(args.sourceName)
			specWarnPyroblast:Play("kickcast")
		end
	elseif spellId == 253040 then
		self:BossTargetScanner(args.sourceGUID, "DemonicChargeTarget", 0.2, 9)
	elseif spellId == 245227 then--Assume Command (entering pod)
		specWarnAssumeCommand:Show()
		specWarnAssumeCommand:Play("targetchange")
		timerShockGrenadeCD:Stop()
		timerExploitWeaknessCD:Stop()
		timerExploitWeaknessCD:Start(8)--8-14 (basically depends how fast you get there) If you heroic leap and are super fast. it's cast pretty much instantly on mob activation
		local cid = self:GetCIDFromGUID(args.sourceGUID)
		if cid == 122369 then--Chief Engineer Ishkar
			timerEntropicMineCD:Start(8)
			timerFusilladeCD:Stop()--Seems this timer resets too
			timerFusilladeCD:Start(15.9, 1)--Start Updated Fusillade
			--TODO, reinforcements fix
		elseif cid == 122333 then--General Erodus
			timerSummonReinforcementsCD:Start(11)--Starts elite ones
		elseif cid == 122367 then--Admiral Svirax
			self.vb.FusilladeCount = 0
			timerFusilladeCD:Start(15, 1)
			timerSummonReinforcementsCD:Stop()--Seems this timer resets too
			timerSummonReinforcementsCD:Start(16)--Start updated reinforcements timer
		end
		if self:IsMythic() then
			timerShockGrenadeCD:Start(9.7)
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 244722 then
		timerShockGrenadeCD:Start()--21
	elseif spellId == 244892 then
		timerExploitWeaknessCD:Start()
	elseif spellId == 245227 then--Assume Command
		timerAssumeCommandCD:Start(90)
	elseif spellId == 253037 then
		if args:IsPlayer() then
			specWarnDemonicChargeYou:Show()
			specWarnDemonicChargeYou:Play("runaway")
			yellDemonicCharge:Yell()
		elseif self:CheckNearby(10, args.destName) then
			specWarnDemonicCharge:Show(args.destName)
			specWarnDemonicCharge:Play("watchstep")
		else
			warnDemonicCharge:Show(args.destName)
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 244737 then
		warnShockGrenade:CombinedShow(1, args.destName)
		if args:IsPlayer() then
			specWarnShockGrenade:Show()
			specWarnShockGrenade:Play("runout")
			yellShockGrenade:Yell()
			yellShockGrenadeFades:Countdown(5, 3)
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(8)
			end
		end
	elseif spellId == 244892 then
		local uId = DBM:GetRaidUnitId(args.destName)
		if self:IsTanking(uId) then
			local amount = args.amount or 1
			if amount >= 2 then
				local _, _, _, _, _, expireTime = DBM:UnitDebuff("player", spellId)
				local remaining
				if expireTime then
					remaining = expireTime-GetTime()
				end
				if not UnitIsDeadOrGhost("player") and (not remaining or remaining and remaining < 8) then
					specWarnExploitWeakness:Show(args.destName)
					specWarnExploitWeakness:Play("tauntboss")
				else
					warnExploitWeakness:Show(args.destName, amount)
				end
			else
				warnExploitWeakness:Show(args.destName, amount)
			end
		end
	elseif spellId == 244172 then
		local amount = args.amount or 1
		if args:IsPlayer() then
			if amount == 10 or amount == 15 then
				if amount >= 19 then--High priority
					specWarnPsychicAssault:Show()
					specWarnPsychicAssault:Play("otherout")
				else--Just a basic stack warning
					specWarnPsychicAssaultStack:Show(amount)
					specWarnPsychicAssaultStack:Play("stackhigh")
				end
			end
		else
			if amount >= 10 and amount % 5 == 0 then
				warnPsychicAssault:Show(args.destName, amount)
			end
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 244737 then
		if args:IsPlayer() then
			yellShockGrenadeFades:Cancel()
			if self.Options.RangeFrame then
				DBM.RangeCheck:Hide()
			end
		end
	end
end

--[[
function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 228007 and destGUID == UnitGUID("player") and self:AntiSpam(2, 4) then
		specWarnGTFO:Show()
		specWarnGTFO:Play("runaway")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE
--]]

--"<14.68 23:07:26> [UNIT_SPELLCAST_SUCCEEDED] General Erodus(??) [[boss3:Summon Reinforcements::3-2083-1712-2166-245546-00015E79FE:245546]]", -- [121]
function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if (spellId == 245161 or spellId == 245304) and self:AntiSpam(5, 1) then
		warnEntropicMine:Show()
		--warnEntropicMine:Play("watchstep")
		timerEntropicMineCD:Start()
	elseif spellId == 245785 then--Pod Spawn Transition Cosmetic Missile
		local name = UnitName(uId)
		local GUID = UnitGUID(uId)
		warnOutofPod:Show(name)
		local cid = self:GetCIDFromGUID(GUID)
		if cid == 122369 then--Chief Engineer Ishkar
			timerEntropicMineCD:Stop()
		elseif cid == 122333 then--General Erodus
			timerSummonReinforcementsCD:Stop()--Elite ones
		elseif cid == 122367 then--Admiral Svirax
			timerFusilladeCD:Stop()
		end
	elseif spellId == 245546 then--Summon Reinforcements (major adds)
		specWarnSummonReinforcements:Show()
		specWarnSummonReinforcements:Play("killmob")
		timerSummonReinforcementsCD:Start(35)
		if self.Options.SetIconOnAdds then
			self:ScanForMobs(122890, 0, self.vb.lastIcon, 1, nil, 12, "SetIconOnAdds")
		end
		if self.vb.lastIcon == 8 then
			self.vb.lastIcon = 7
		else
			self.vb.lastIcon = 8
		end
	end
end
