local mod	= DBM:NewMod(333, "DBM-DragonSoul", nil, 187)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143316")
mod:SetCreatureID(56173)
mod:SetEncounterID(1299)
mod:SetZone()
mod:SetUsedIcons(8)
--mod:SetModelSound("sound\\CREATURE\\Deathwing\\VO_DS_DEATHWING_MAELSTROMEVENT_01.OGG", "sound\\CREATURE\\Deathwing\\VO_DS_DEATHWING_MAELSTROMSPELL_04.OGG")

mod:RegisterCombat("combat")
mod:SetMinCombatTime(20)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 107018 106523 108813",
	"SPELL_CAST_SUCCESS 105651 110063",
	"SPELL_AURA_APPLIED 106548 106834 106400 106794 108649 106730",
	"SPELL_AURA_APPLIED_DOSE 106400 106730",
	"SPELL_AURA_REMOVED 106444 106794 108649 106730",
	"SPELL_SUMMON 109091",
	"UNIT_DIED",
	"UNIT_SPELLCAST_SUCCEEDED boss1 target mouseover"--target/mouseover needed for bolt died detection
)

local warnMutated					= mod:NewSpellAnnounce("ej4112", 3, 61618)
local warnElementiumBolt			= mod:NewSpellAnnounce(105651, 4)
local warnTentacle					= mod:NewSpellAnnounce(105551, 3)
local warnHemorrhage				= mod:NewSpellAnnounce(105863, 3)
local warnCataclysm					= mod:NewCastAnnounce(106523, 4)
local warnPhase2					= mod:NewPhaseAnnounce(2, 3)
local warnFragments					= mod:NewSpellAnnounce("ej4115", 4, 106708)--This needs a custom spell icon, EJ doesn't have icons for entires that are mobs
local warnTerror					= mod:NewSpellAnnounce("ej4117", 4, 106765)--This needs a fitting spell icon, trigger spell only has a gear.
local warnShrapnel					= mod:NewTargetAnnounce(106794, 3, nil, false)
local warnParasite					= mod:NewTargetAnnounce(108649, 2)
local warnUnstableCorruption		= mod:NewCastAnnounce(108813, 4, 10)
local warnTetanus					= mod:NewStackAnnounce(106730, 4, nil, false)
local warnCongealingBloodSoon		= mod:NewSoonAnnounce("ej4350", 4, 109089)--15%, 10%, 5% on heroic. spellid is 109089.

local specWarnMutated				= mod:NewSpecialWarningSwitch("ej4112", "-Healer")--Because tanks need to switch to it too.
local specWarnImpale				= mod:NewSpecialWarningYou(106400)
local specWarnImpaleOther			= mod:NewSpecialWarningTarget(106400, "Tank|Healer")
local specWarnElementiumBolt		= mod:NewSpecialWarningSpell(105651, nil, nil, nil, true)--Cast, helps you find the mark on ground and get into positions
local specWarnElementiumBoltDPS		= mod:NewSpecialWarningSwitch(105651, "Dps")--Warning for when to switch to dps it, because i really felt one warning didn't serve both meanings, one is an aoe/damage warning for cast, other should be specifically yelling at dps to kill it.
local specWarnTentacle				= mod:NewSpecialWarningSwitch("ej4103", "Dps")--Tanks not included in this one cause they may still have adds.
local specWarnHemorrhage			= mod:NewSpecialWarningSpell(105863, "-Healer")--Because tanks need to switch to it too.
local specWarnFragments				= mod:NewSpecialWarningSpell("ej4115", "Dps")--Not a "switch" warning because on normal a lot of groups choose to ignore these if they can burn boss and just pop dream. Let the raid leader decide strat on this one, not DBM.
local specWarnTerror				= mod:NewSpecialWarningSpell("ej4117")--Same as fragments.
local specWarnShrapnel				= mod:NewSpecialWarningYou(106794)
local specWarnParasite				= mod:NewSpecialWarningYou(108649)
local specWarnParasiteDPS			= mod:NewSpecialWarningSpell("ej4347", "Dps")--many raid teams using kalecgos buff. they do not target switch to parasite
local yellParasite					= mod:NewYell(108649)
local specWarnCongealingBlood		= mod:NewSpecialWarningSwitch("ej4350", "Dps")--15%, 10%, 5% on heroic. spellid is 109089.
local specWarnTetanus				= mod:NewSpecialWarningStack(106730, "Tank", 4)
local specWarnTetanusOther			= mod:NewSpecialWarningTarget(106730, "Tank")

local timerMutated					= mod:NewNextTimer(17, "ej4112", nil, nil, nil, 1, 61618)
local timerImpale					= mod:NewTargetTimer(49.5, 106400, nil, "Tank|Healer", nil, 5, nil, DBM_CORE_TANK_ICON)--45 plus 4 second cast plus .5 delay between debuff ID swap.
local timerImpaleCD					= mod:NewCDTimer(35, 106400, nil, "Tank|Healer", nil, 5, nil, DBM_CORE_TANK_ICON)
local timerElementiumCast			= mod:NewCastTimer(7.5, 105651, nil, nil, nil, 1)
local timerElementiumBlast			= mod:NewCastTimer(8, 105723, nil, nil, nil, 2, nil, nil, nil, 1, 4)--8-10 variation depending on where it's actually going to land. Uses the min time.
local timerElementiumBoltCD			= mod:NewNextTimer(55.5, 105651, nil, nil, nil, 1)
local timerHemorrhageCD				= mod:NewCDTimer(100.5, 105863, nil, nil, nil, 1)
local timerCataclysm				= mod:NewCastTimer(60, 106523, nil, nil, nil, 2, nil, DBM_CORE_DEADLY_ICON)
local timerCataclysmCD				= mod:NewCDTimer(130.5, 106523, nil, nil, nil, 2)--130.5-131.5 variations
local timerFragmentsCD				= mod:NewNextTimer(90, "ej4115", nil, nil, nil, 1, 106708)--Gear icon for now til i find something more suitable
local timerTerrorCD					= mod:NewNextTimer(90, "ej4117", nil, nil, nil, 1, 106765)--^
local timerShrapnel					= mod:NewBuffFadesTimer(6, 106794, nil, nil, nil, 3, nil, nil, nil, not mod:IsMelee() and 1, 4)
local timerParasite					= mod:NewTargetTimer(10, 108649, nil, nil, nil, 1)
local timerParasiteCD				= mod:NewCDTimer(60, 108649, nil, nil, nil, 3)
local timerUnstableCorruption		= mod:NewCastTimer(10, 108813, nil, nil, nil, 2, nil, nil, nil, 2, 4)
local timerTetanus					= mod:NewTargetTimer(6, 106730, nil, "Healer")
local timerTetanusCD				= mod:NewCDTimer(3.5, 106730, nil, "Tank", nil, 5, nil, DBM_CORE_TANK_ICON)

local berserkTimer					= mod:NewBerserkTimer(900)

mod:AddBoolOption("RangeFrame", true)--For heroic parasites, with debuff filtering.
mod:AddBoolOption("SetIconOnParasite", true)

local firstAspect = true
local engageCount = 0
local shrapnelTargets = {}
local warnedCount = 0
local activateTetanusTimers = false
local parasite = DBM:EJ_GetSectionInfo(4347)
local parasiteScan = 0
local parasiteCasted = false
local debuffFilterDebuff, NozPresence, AlexPresence = DBM:GetSpellInfo(108649), DBM:GetSpellInfo(106027), DBM:GetSpellInfo(106028)

local debuffFilter
do
	debuffFilter = function(uId)
		return DBM:UnitDebuff(uId, debuffFilterDebuff)
	end
end

function mod:updateRangeFrame()
	if not self.Options.RangeFrame then return end
	if DBM:UnitDebuff("player", debuffFilterDebuff) then
		DBM.RangeCheck:Show(10, nil)--Show everyone.
	else
		DBM.RangeCheck:Show(10, debuffFilter)--Show only people who have debuff.
	end
end

local function warnShrapnelTargets()
	warnShrapnel:Show(table.concat(shrapnelTargets, "<, >"))
	table.wipe(shrapnelTargets)
end

function mod:ScanParasite()
	local unitID
	local founded = false
	for uId in DBM:GetGroupMembers() do
		if UnitName(uId.."target") == parasite then
			unitID = uId.."target"
			founded = true
			break
		end
	end
	if founded then
		local _, _, _, startTime, endTime = UnitCastingInfo(unitID)
		local castTime = ((endTime or 0) - (startTime or 0)) / 1000
		timerUnstableCorruption:Update(parasiteScan * 0.1, castTime)
		warnUnstableCorruption = mod:NewCastAnnounce(108813, 4, castTime)
		warnUnstableCorruption:Show()
	elseif parasiteScan < 40 then -- failed scan. rescan for 40 times. (40 * 0.1 = 4 sec)
		parasiteScan = parasiteScan + 1
		self:ScheduleMethod(0.1, "ScanParasite")
	else -- if scan failure after 40 loops, use default 10 sec timer.
		timerUnstableCorruption:Update(parasiteScan * 0.1, 10)
		warnUnstableCorruption = mod:NewCastAnnounce(108813, 4, 10)
		warnUnstableCorruption:Show()		
	end
end

function mod:OnCombatStart(delay)
	firstAspect = true
	activateTetanusTimers = false
	engageCount = 0
	warnedCount = 0
	table.wipe(shrapnelTargets)
	berserkTimer:Start(-delay)
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	self:UnregisterShortTermEvents()
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 107018 then
		parasiteCasted = false
		if firstAspect then--The abilities all come 15seconds earlier for first one only
			firstAspect = false
			timerMutated:Start(11)
			warnMutated:Schedule(11)
			specWarnMutated:Schedule(11)
			timerImpaleCD:Start(22)
			timerElementiumBoltCD:Start(40.5)
			if self:IsDifficulty("heroic10", "heroic25") then
				timerHemorrhageCD:Start(55.5)
				timerParasiteCD:Start(11)
			else
				timerHemorrhageCD:Start(85.5)
			end
			timerCataclysmCD:Start(115.5)
		else
			timerMutated:Start()
			warnMutated:Schedule(17)
			specWarnMutated:Schedule(17)
			timerImpaleCD:Start(27.5)
			timerElementiumBoltCD:Start()
			if self:IsDifficulty("heroic10", "heroic25") then
				timerHemorrhageCD:Start(70.5)
				timerParasiteCD:Start(22)
			else
				timerHemorrhageCD:Start()
			end
			timerCataclysmCD:Start()
		end
	elseif spellId == 106523 then
		warnCataclysm:Show()
		timerCataclysm:Start()
	elseif spellId == 108813 then
		parasiteScan = 0
		self:ScanParasite()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 105651 then
		warnElementiumBolt:Show()
		specWarnElementiumBolt:Show()
		if not DBM:UnitBuff("player", NozPresence) and not UnitIsDeadOrGhost("player") then--Check for Nozdormu's Presence
			timerElementiumBlast:Start()
			specWarnElementiumBoltDPS:Schedule(10)
		else
			timerElementiumCast:Start()
			timerElementiumBlast:Start(20)
			specWarnElementiumBoltDPS:Schedule(7.5)
		end
	elseif spellId == 110063 then--Astral Recall. Thrall teleports off back platform back to front on defeat.
		self:SendSync("MadnessDown")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 106548 then--Arm/Wing Transition
		timerElementiumBoltCD:Cancel()
		timerHemorrhageCD:Cancel()--Does this one cancel in event you super overgear this and stomp his ass this fast?
		timerCataclysm:Cancel()
		timerCataclysmCD:Cancel()
	elseif spellId == 106834 then--Phase 2
		warnPhase2:Show()
		timerFragmentsCD:Start(10.5)
		timerTerrorCD:Start(35.5)
		if self:IsDifficulty("heroic10", "heroic25") then--Only register on heroic, we don't need on normal.
			self:RegisterShortTermEvents(
				"UNIT_HEALTH_FREQUENT boss1"
			)
		end
	elseif spellId == 106400 then
		timerImpale:Start(args.destName)
		timerImpaleCD:Start()
		if args:IsPlayer() then
			specWarnImpale:Show()
		else
			specWarnImpaleOther:Show(args.destName)
		end
	elseif spellId == 106794 then
		shrapnelTargets[#shrapnelTargets + 1] = args.destName
		self:Unschedule(warnShrapnelTargets)
		if args:IsPlayer() then
			specWarnShrapnel:Show()
			timerShrapnel:Start() -- Shrapnel debuff lasts 7 secs. But Shrapnel damages 1 sec early before debuff fades. So 6 sec timer will be more good.
		end
		if (self:IsDifficulty("normal10", "heroic10") and #shrapnelTargets >= 3) or (self:IsDifficulty("normal25", "heroic25", "lfr25") and #shrapnelTargets >= 8) then
			warnShrapnelTargets()
		else
			self:Schedule(0.3, warnShrapnelTargets)
		end
	elseif spellId == 108649 then
		warnParasite:Show(args.destName)
		timerParasite:Start(args.destName)
		self:updateRangeFrame()
		if args:IsPlayer() then
			specWarnParasite:Show()
			yellParasite:Yell()
		end
		if self.Options.SetIconOnParasite then
			self:SetIcon(args.destName, 8)
		end
		-- parasite comes regardless of Corruption status. only 2 times.
		if not parasiteCasted then
			timerParasiteCD:Start()
			parasiteCasted = true
		end
	elseif spellId == 106730 then -- Debuffs from adds
		local amount = args.amount or 1
		warnTetanus:Show(args.destName, amount)
		timerTetanus:Start(args.destName)
		if amount >= 4 then
			if args:IsPlayer() then
				specWarnTetanus:Show(amount)
			else
				if not UnitIsDeadOrGhost("player") and not DBM:UnitDebuff("player", args.spellName) then--You have no debuff and not dead
					specWarnTetanusOther:Show(args.destName)--So stop being a tool and taunt off other tank who has 4 stacks.
				end
			end
		end
		if activateTetanusTimers then -- Only track them when there is no Time Zone down (since we have no way to accurate track/detect whether or not they are tanked in it, ie slowed)
			timerTetanusCD:Start(args.sourceGUID)
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 106444 then
		timerImpale:Cancel(args.destName)
	elseif spellId == 106794 and args:IsPlayer() then
		timerShrapnel:Cancel()
	elseif spellId == 108649 then
		specWarnParasiteDPS:Show()
		if self.Options.SetIconOnParasite then
			self:SetIcon(args.destName, 0)
		end
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
	elseif spellId == 106730 then -- Debuffs from adds
		timerTetanus:Cancel(args.destName)
	end
end

function mod:SPELL_SUMMON(args)
	local spellId = args.spellId
	if spellId == 109091 and self:AntiSpam(10, 1) then--They spawn over like 8 seconds, not at same time, so we need a large anti spam.
		specWarnCongealingBlood:Show()
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 56471 then--Mutated Corruption
		timerImpaleCD:Cancel()
		timerImpale:Cancel()--Cancel impale debuff timers since they don't matter anymore until next platform (well after they cleared)
	elseif cid == 56311 then --Phase 2 Time Zone bubbles (yes it's an npc heh)
		activateTetanusTimers = true
	elseif cid == 56710 then
		timerTetanusCD:Cancel(args.destGUID)
	elseif cid == 57479 then
		timerUnstableCorruption:Cancel()
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 110663 and self:AntiSpam(2, 3) then--Elementium Meteor Transform (apparently this doesn't fire UNIT_DIED anymore, need to use this alternate method)
		self:SendSync("BoltDied")--Send sync because Elementium bolts do not have a bossN arg, which means event only fires if it's current target/focus.
	-- Actually i have a pretty good idea what problem is now. thinking about it, with no uId filter, it's triggering off a rogue in raid (also have hemorrhage spell)
	elseif spellId == 105863 then
		warnHemorrhage:Show()
		specWarnHemorrhage:Show()
	elseif spellId == 105551 then--Spawn Blistering Tentacles
		if not DBM:UnitBuff("player", AlexPresence) then--Check for Alexstrasza's Presence
			warnTentacle:Show()
			specWarnTentacle:Show()
		end
	elseif spellId == 106775 then--Summon Impaling Tentacle (Fragments summon)
		warnFragments:Show()
		specWarnFragments:Show()
		timerFragmentsCD:Start()
	elseif spellId == 106765 then--Summon Elementium Terror (Big angry add)
		activateTetanusTimers = false
		warnTerror:Show()
		specWarnTerror:Show()
		timerTerrorCD:Start()
	end
end

function mod:OnSync(msg)
	if msg == "BoltDied" then
		timerElementiumBlast:Cancel()--Lot of work just to cancel a timer, why the heck did blizz break this mob firing UNIT_DIED when it dies? Sigh.
	elseif msg == "MadnessDown" and self:IsInCombat() then
		DBM:EndCombat(self)
	end
end

function mod:UNIT_HEALTH_FREQUENT(uId)
	local hp = UnitHealth(uId) / UnitHealthMax(uId) * 100
	if hp > 15 and hp < 16.5 and warnedCount == 0 then
		warnedCount = 1
		warnCongealingBloodSoon:Show()
	elseif hp > 10 and hp < 11.5 and warnedCount == 1 then
		warnedCount = 2
		warnCongealingBloodSoon:Show()
	elseif hp > 5 and hp < 6.5 and warnedCount == 2 then
		warnedCount = 3
		warnCongealingBloodSoon:Show()
		self:UnregisterShortTermEvents()
	end
end
