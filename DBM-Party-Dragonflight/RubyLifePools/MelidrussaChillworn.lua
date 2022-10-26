local mod	= DBM:NewMod(2488, "DBM-Party-Dragonflight", 7, 1202)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221018010841")
mod:SetCreatureID(188252)
mod:SetEncounterID(2609)
--mod:SetUsedIcons(1, 2, 3)
mod:SetHotfixNoticeRev(20221017000000)
--mod:SetMinSyncRevision(20211203000000)
--mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 372851 396044 373046",
	"SPELL_AURA_APPLIED 372682 373022 372988 373680",
	"SPELL_AURA_APPLIED_DOSE 372682",
	"SPELL_AURA_REMOVED 372682 372988 373680",
	"SPELL_AURA_REMOVED_DOSE 372682",
	"SPELL_PERIODIC_DAMAGE 372963",
	"SPELL_PERIODIC_MISSED 372963"
)

--TODO, target scan Chillstorm if boss looks at victim
--[[
(ability.id = 372851 or ability.id = 396044 or ability.id = 373046) and type = "begincast"
 or ability.id = 373680 and (type = "applybuff" or type = "removebuff")
 or type = "dungeonencounterstart" or type = "dungeonencounterend"
--]]
local warnFrozenSolid							= mod:NewTargetNoFilterAnnounce(373022, 4, nil, "Healer")
local warnChillstorm							= mod:NewSpellAnnounce(372851, 3)
local warnIceBulwark							= mod:NewSpellAnnounce(372988, 4)

local specWarnPrimalChill						= mod:NewSpecialWarningStack(372682, nil, 8, nil, nil, 1, 6)
local specWarnHailbombs							= mod:NewSpecialWarningDodge(396044, nil, nil, nil, 2, 2)
local yellChillstorm							= mod:NewYell(372851)
local specWarnFrostOverload						= mod:NewSpecialWarningInterrupt(373680, "HasInterrupt", nil, nil, 1, 2)
local specWarnAwakenWhelps						= mod:NewSpecialWarningSwitch(373046, "-Healer", nil, nil, 1, 2)
local specWarnGTFO								= mod:NewSpecialWarningGTFO(372851, nil, nil, nil, 1, 8)

local timerChillstormCD							= mod:NewCDTimer(24.2, 372851, nil, nil, nil, 3)
local timerHailbombsCD							= mod:NewCDTimer(24.2, 396044, nil, nil, nil, 3)
--local timerFrostOverloadCD					= mod:NewCDTimer(24.2, 373680, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)--Appears health based, keep an eye on it
--local timerAwakenWhelpsCD						= mod:NewCDTimer(35, 373046, nil, nil, nil, 5, nil, DBM_COMMON_L.TANK_ICON..DBM_COMMON_L.DAMAGE_ICON)--Appears health based, keep an eye on it

--local berserkTimer							= mod:NewBerserkTimer(600)

--mod:AddRangeFrameOption("8")
mod:AddInfoFrameOption(372682, true)
--mod:AddSetIconOption("SetIconOnStaggeringBarrage", 361018, true, false, {1, 2, 3})

local chillStacks = {}

function mod:stormTarget(targetname)
	if not targetname then return end
	if targetname == UnitName("player") then
		yellChillstorm:Yell()
	end
end

function mod:OnCombatStart(delay)
	table.wipe(chillStacks)
	timerHailbombsCD:Start(4.7-delay)
	timerChillstormCD:Start(11.9-delay)
--	if self:IsMythic() then
--		timerFrostOverloadCD:Start(36.2-delay)--Not timer based, seemingly health based like whelps
--	end
--	timerAwakenWhelpsCD:Start(27.8-delay)--Health based?
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(DBM:GetSpellInfo(372682))
		DBM.InfoFrame:Show(5, "table", chillStacks, 1)
	end
end

function mod:OnCombatEnd()
	table.wipe(chillStacks)
--	if self.Options.RangeFrame then
--		DBM.RangeCheck:Hide()
--	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 372851 then
		self:ScheduleMethod(0.2, "BossTargetScanner", args.sourceGUID, "stormTarget", 0.1, 8, true)
		warnChillstorm:Show()
		timerChillstormCD:Start()
	elseif spellId == 396044 then
		specWarnHailbombs:Show()
		specWarnHailbombs:Play("shockwave")
		timerHailbombsCD:Start()
	elseif spellId == 373046 then
		specWarnAwakenWhelps:Show()
		specWarnAwakenWhelps:Play("killmob")
--		timerAwakenWhelpsCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 372682 then
		local amount = args.amount or 1
		chillStacks[args.destName] = amount
		if self.Options.InfoFrame then
			DBM.InfoFrame:UpdateTable(chillStacks, 0.2)
		end
		if args:IsPlayer() and amount >= 8 then
			specWarnPrimalChill:Cancel()--Possible to get multiple applications at once so we throttle by scheduling
			specWarnPrimalChill:Schedule(0.2, amount)
			specWarnPrimalChill:ScheduleVoice(0.2, "stackhigh")
		end
	elseif spellId == 373022 then
		warnFrozenSolid:CombinedShow(1, args.destName)--Slower aggregation to reduce spam
	elseif spellId == 373680 then
		if not self:IsMythic() then--Interruptable at any time on non mythic
			specWarnFrostOverload:Show(args.destName)
			specWarnFrostOverload:Play("kickcast")
		end
		timerHailbombsCD:Stop()
		timerChillstormCD:Stop()
	elseif spellId == 372988 then
		warnIceBulwark:Show()
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 372682 then
		chillStacks[args.destName] = nil
		if self.Options.InfoFrame then
			DBM.InfoFrame:UpdateTable(chillStacks, 0.2)
		end
	elseif spellId == 372988 then--Ice Bulwark Removed, now can interrupt on mythic and mythic+
		specWarnFrostOverload:Show(args.destName)
		specWarnFrostOverload:Play("kickcast")
	elseif spellId == 373680 then
		--True, at least in M+
		timerHailbombsCD:Start(6)
		timerChillstormCD:Start(13.3)
--		timerAwakenWhelpsCD:Start(23)
--		timerFrostOverloadCD:Start(32.7)--Second one might be timer based even though first one isn't?
	end
end

function mod:SPELL_AURA_REMOVED_DOSE(args)
	local spellId = args.spellId
	if spellId == 372682 then
		chillStacks[args.destName] = args.amount or 1
		if self.Options.InfoFrame then
			DBM.InfoFrame:UpdateTable(chillStacks, 0.2)
		end
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 372963 and destGUID == UnitGUID("player") and self:AntiSpam(2, 4) then
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE
