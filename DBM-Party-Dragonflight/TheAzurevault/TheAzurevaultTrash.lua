local mod	= DBM:NewMod("TheAzurevaultTrash", "DBM-Party-Dragonflight", 6)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20230124224352")
--mod:SetModelID(47785)
mod:SetZone(2515)

mod.isTrashMod = true

mod:RegisterEvents(
	"SPELL_CAST_START 391136 370764 386526 387564 377105 370766 386546 387067",
	"SPELL_CAST_SUCCESS 374885 371358 375652 375596",
	"SPELL_AURA_APPLIED 371007 395492 375596",
--	"SPELL_AURA_APPLIED_DOSE 339528",
--	"SPELL_AURA_REMOVED 339525",
	"UNIT_DIED",
	"GOSSIP_SHOW"
)

--TODO, I don't think shoulder slam target scan worked, maybe try again though.
--TODO, add erratic growth interrupt?
local warnNullStomp							= mod:NewCastAnnounce(386526, 2)
local warnShoulderSlam						= mod:NewCastAnnounce(391136, 2)
local warnPiercingShards					= mod:NewCastAnnounce(370764, 4)
local warnIceCutter							= mod:NewCastAnnounce(377105, 4, nil, nil, "Tank|Healer")
local warnWakingBane						= mod:NewCastAnnounce(386546, 3)
local warnSplinteringShards					= mod:NewTargetAnnounce(371007, 2)
local warScornfulHaste						= mod:NewTargetNoFilterAnnounce(395492, 2)
local warnErraticGrowth						= mod:NewTargetNoFilterAnnounce(375596, 2)

local specWarnUnstablePower					= mod:NewSpecialWarningDodge(374885, nil, nil, nil, 2, 2)
local specWarnForbiddenKnowledge			= mod:NewSpecialWarningDodge(371358, nil, nil, nil, 2, 2)
local specWarnNullStomp						= mod:NewSpecialWarningDodge(386526, false, nil, 2, 2, 2)
local specWarnShoulderSlam					= mod:NewSpecialWarningDodge(391136, false, nil, nil, 2, 2)
local specWarnCrystallineRupture			= mod:NewSpecialWarningDodge(370766, nil, nil, nil, 2, 2)
local specWarnWildEruption					= mod:NewSpecialWarningDodge(375652, nil, nil, nil, 2, 2)
local specWarnArcaneBash					= mod:NewSpecialWarningDefensive(387067, nil, nil, nil, 1, 2)
local specWarnSplinteringShards				= mod:NewSpecialWarningMoveAway(371007, nil, nil, nil, 1, 2)
local yellSplinteringShards					= mod:NewYell(371007)
local yellErraticGrowth						= mod:NewYell(375596)
--local specWarnErraticGrowth					= mod:NewSpecialWarningInterrupt(375596, "HasInterrupt", nil, nil, 1, 2)
local specWarnMysticVapors					= mod:NewSpecialWarningInterrupt(387564, "HasInterrupt", nil, nil, 1, 2)
local specWarnWakingBane					= mod:NewSpecialWarningInterrupt(386546, "HasInterrupt", nil, nil, 1, 2)

local timerWakingBaneCD						= mod:NewCDTimer(20.5, 386546, nil, "HasInterrupt", nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)
local timerErraticGrowthCD					= mod:NewCDTimer(21.5, 375596, nil, nil, nil, 3, nil, DBM_COMMON_L.MAGIC_ICON)
local timerShoulderSlamCD					= mod:NewCDTimer(10.9, 391136, nil, nil, nil, 3)
local timerArcaneBashCD						= mod:NewCDTimer(18.2, 387067, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON)

mod:AddBoolOption("AGBook", true)

--local playerName = UnitName("player")

--Antispam IDs for this mod: 1 run away, 2 dodge, 3 dispel, 4 incoming damage, 5 you/role, 6 misc

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 391136 then
		timerShoulderSlamCD:Start(10.9, args.sourceGUID)
		if self:AntiSpam(3, 2) then
			if self.Options.SpecWarn391136dodge then
				specWarnShoulderSlam:Show()
				specWarnShoulderSlam:Play("watchstep")
			else
				warnShoulderSlam:Show()
			end
		end
	elseif spellId == 370764 and self:AntiSpam(5, 6) then
		warnPiercingShards:Show()
	elseif spellId == 377105 and self:AntiSpam(3, 6) then
		warnIceCutter:Show()
	elseif spellId == 386526 and self:AntiSpam(3, 2) then
		if self.Options.SpecWarn386526dodge then
			specWarnNullStomp:Show()
			specWarnNullStomp:Play("watchstep")
		else
			warnNullStomp:Show()
		end
	elseif spellId == 370766 and self:AntiSpam(3, 2) then
		specWarnCrystallineRupture:Show()
		specWarnCrystallineRupture:Play("watchstep")
	elseif spellId == 387564 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnMysticVapors:Show(args.sourceName)
		specWarnMysticVapors:Play("kickcast")
	elseif spellId == 386546 then
		timerWakingBaneCD:Start(20, args.sourceGUID)
		if self.Options.SpecWarn386546interrupt and self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnWakingBane:Show(args.sourceName)
			specWarnWakingBane:Play("kickcast")
		elseif self:AntiSpam(3, 5) then
			warnWakingBane:Show()
		end
	elseif spellId == 387067 then
		timerArcaneBashCD:Start(18.2, args.sourceGUID)
		if self:IsTanking("player", nil, nil, true, args.sourceGUID) and self:AntiSpam(3, 5) then
			specWarnArcaneBash:Show()
			specWarnArcaneBash:Play("carefly")
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 374885 and self:AntiSpam(3, 2) then
		specWarnUnstablePower:Show()
		specWarnUnstablePower:Play("watchstep")
	elseif spellId == 371358 and self:AntiSpam(3, 2) then
		specWarnForbiddenKnowledge:Show()
		specWarnForbiddenKnowledge:Play("watchstep")
	elseif spellId == 375652 and self:AntiSpam(3, 2) then
		specWarnWildEruption:Show()
		specWarnWildEruption:Play("watchstep")
	elseif spellId == 375596 then
		timerErraticGrowthCD:Start(21.5, args.sourceGUID)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if not self.Options.Enabled then return end
	local spellId = args.spellId
	if spellId == 371007 then
		warnSplinteringShards:CombinedShow(0.5, args.destName)
		if args:IsPlayer() then
			specWarnSplinteringShards:Show()
			specWarnSplinteringShards:Play("runout")
			yellSplinteringShards:Yell()
		end
	elseif spellId == 395492 then
		warScornfulHaste:CombinedShow(0.3, args.destName)
	elseif spellId == 375596 then
		warnErraticGrowth:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			yellErraticGrowth:Yell()
		end
	end
end
--mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

--[[
function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 339525 and args:IsPlayer() then

	end
end
--]]

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 186740 then--Arcane Construct
		timerArcaneBashCD:Stop(args.destGUID)
	elseif cid == 187240 then--Drakonid Breaker
		timerShoulderSlamCD:Stop(args.destGUID)
	elseif cid == 186741 then--Drakonid Breaker
		timerWakingBaneCD:Stop(args.destGUID)
	elseif cid == 196115 or cid == 191164 then--Arcane Tender (one by entrance is diff id than ones before boss)
		timerErraticGrowthCD:Stop(args.destGUID)
	end
end

--[[
56056 Book 1
56057 book 1 return
56247 book 2
56379 book 2 return
56248 book 3
56378 book 3 return
56250 book 4
107756 book 4 return
56251 book 5
? Book 5 return
--]]
function mod:GOSSIP_SHOW()
	local gossipOptionID = self:GetGossipID()
	if gossipOptionID then
		DBM:Debug("GOSSIP_SHOW triggered with a gossip ID of: "..gossipOptionID)
		if self.Options.AGBook and (gossipOptionID == 56056 or gossipOptionID == 56057 or gossipOptionID == 56247 or gossipOptionID == 56379 or gossipOptionID == 56248 or gossipOptionID == 56378 or gossipOptionID == 56250 or gossipOptionID == 107756 or gossipOptionID == 56251) then -- Books
			self:SelectGossip(gossipOptionID)
		end
	end
end
