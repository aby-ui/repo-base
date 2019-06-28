local mod	= DBM:NewMod(853, "DBM-SiegeOfOrgrimmarV2", nil, 369)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143417")
mod:SetCreatureID(71152, 71153, 71154, 71155, 71156, 71157, 71158, 71160, 71161)
mod:SetEncounterID(1593)
mod:DisableESCombatDetection()
mod:SetZone()
mod:SetUsedIcons(3, 1)
mod:SetBossHPInfoToHighest()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 142725 142726 142727 142728 142729 142730 142416 143709 143280 143974 142315 143243 143339 148676",
	"SPELL_CAST_SUCCESS 142528 142232",
	"SPELL_AURA_APPLIED 143339 142532 142533 142534 142671 142564 143939 143974 143701 143759 143337 143358 142948",
	"SPELL_AURA_APPLIED_DOSE 143339",
	"SPELL_AURA_REMOVED 142564 143939 143974 143700 142948 143339 142671 143542",
	"SPELL_PERIODIC_DAMAGE 143735",
	"SPELL_PERIODIC_MISSED 143735",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"CHAT_MSG_MONSTER_EMOTE",
	"UNIT_DIED"
)

----------------------------------------------------------------------------------------------------------------------------------------
-- A moment of silence to remember Malik the Unscathed, the 10th paragon that perished an honorable death in battle against Shek'zeer --
----------------------------------------------------------------------------------------------------------------------------------------
--All
local warnActivated					= mod:NewTargetAnnounce(118212, 3, 143542)
--Kil'ruk the Wind-Reaver
local warnDeathFromAbove			= mod:NewTargetAnnounce(142232, 3)
--Xaril the Poisoned-Mind
local warnToxicInjection			= mod:NewSpellAnnounce(142528, 3)
mod:AddBoolOption("warnToxicCatalyst", true, "announce")
local warnToxicCatalystBlue			= mod:NewCastAnnounce(142725, 4, nil, nil, nil, false)
local warnToxicCatalystRed			= mod:NewCastAnnounce(142726, 4, nil, nil, nil, false)
local warnToxicCatalystYellow		= mod:NewCastAnnounce(142727, 4, nil, nil, nil, false)
local warnToxicCatalystOrange		= mod:NewCastAnnounce(142728, 4, nil, nil, nil, false)--Heroic
local warnToxicCatalystPurple		= mod:NewCastAnnounce(142729, 4, nil, nil, nil, false)--Heroic
local warnToxicCatalystGreen		= mod:NewCastAnnounce(142730, 4, nil, nil, nil, false)--Heroic
--Kaz'tik the Manipulator
local warnMesmerize					= mod:NewTargetAnnounce(142671, 3)
--Korven the Prime
local warnEncaseInAmber				= mod:NewTargetAnnounce(142564, 4)
--Iyyokuk the Lucid
local warnCalculated				= mod:NewTargetAnnounce(144095, 3)--Wild variation on timing noted, 34-130.8 variation (wtf)
--Ka'roz the Locust
local warnFlash						= mod:NewTargetCountAnnounce("ej8058", 3)
--Rik'kal the Dissector
local warnInjection					= mod:NewStackAnnounce(143339, 3)
local warnMutate					= mod:NewTargetCountAnnounce(143337, 3)
local warnParasitesLeft				= mod:NewAddsLeftAnnounce("ej8065", 3, 143383, "Tank")
--Hisek the Swarmkeeper
local warnAim						= mod:NewTargetCountAnnounce(142948, 4)
local warnRapidFire					= mod:NewSpellAnnounce(143243, 3)

--All
local specWarnActivated				= mod:NewSpecialWarningTarget(118212)
local specWarnActivatedVulnerable	= mod:NewSpecialWarning("specWarnActivatedVulnerable", "Tank")--Alternate activate warning to warn a tank not to pick up a specific boss
--Kil'ruk the Wind-Reaver
local specWarnGouge					= mod:NewSpecialWarningYou(143939)
local specWarnGougeOther			= mod:NewSpecialWarningTarget(143939, "Tank|Healer")
local specWarnDeathFromAbove		= mod:NewSpecialWarningYou(142232)
local specWarnDeathFromAboveNear	= mod:NewSpecialWarningClose(142232)
local yellDeathFromAbove			= mod:NewYell(142232)
local specWarnReave					= mod:NewSpecialWarningSpell(148676, nil, nil, nil, 2)--Heroic
--Xaril the Poisoned-Mind
local specWarnCausticBlood			= mod:NewSpecialWarningSpell(142315, "Tank")
local specWarnToxicBlue				= mod:NewSpecialWarningYou(142532)
local specWarnToxicRed				= mod:NewSpecialWarningYou(142533)
local specWarnToxicYellow			= mod:NewSpecialWarningYou(142534)
local specWarnCatalystBlue			= mod:NewSpecialWarningYou(142725, nil, nil, nil, 3)--Only one you don't move away from others for. This one you need to move TO others (although we cannot tell you who since multiple blues go out and you must use multiple stack groups, not just 1.
local specWarnCatalystRed			= mod:NewSpecialWarningMoveAway(142726, nil, nil, nil, 3)
local specWarnCatalystYellow		= mod:NewSpecialWarningMoveAway(142727, nil, nil, nil, 3)
local specWarnCatalystOrange		= mod:NewSpecialWarningMoveAway(142728, nil, nil, nil, 3)--Heroic
local specWarnCatalystPurple		= mod:NewSpecialWarningMoveAway(142729, nil, nil, nil, 3)--Heroic
local specWarnCatalystGreen			= mod:NewSpecialWarningMoveAway(142730, nil, nil, nil, 3)--Heroic
mod:AddBoolOption("yellToxicCatalyst", true, "misc")--And lastly, combine yells
local yellCatalystBlue				= mod:NewYell(142725, nil, nil, false)
local yellCatalystRed				= mod:NewYell(142726, nil, nil, false)
local yellCatalystYellow			= mod:NewYell(142727, nil, nil, false)
local yellCatalystOrange			= mod:NewYell(142728, nil, nil, false)
local yellCatalystPurple			= mod:NewYell(142729, nil, nil, false)
local yellCatalystGreen				= mod:NewYell(142730, nil, nil, false)
--Kaz'tik the Manipulator
local specWarnMesmerize				= mod:NewSpecialWarningYou(142671)
local specWarnMesmerizeOther		= mod:NewSpecialWarningTarget(142671, false)--Person who grabs korven's amber wants this
local yellMesmerize					= mod:NewYell(142671)
local specWarnKunchongs				= mod:NewSpecialWarningSwitch("ej8043", "Dps")
--Korven the Prime
local specWarnShieldBash			= mod:NewSpecialWarningSpell(143974, "Tank")
local specWarnShieldBashOther		= mod:NewSpecialWarningTarget(143974, "Tank|Healer")
local specWarnEncaseInAmber			= mod:NewSpecialWarningTarget(142564, "Dps")--Better than switch because on heroic, you don't actually switch to amber, you switch to a NON amber target. Plus switch gives no targetname
--Iyyokuk the Lucid
local specWarnCalculated			= mod:NewSpecialWarningYou(142416)
local yellCalculated				= mod:NewYell(142416, nil, false)
local specWarnInsaneCalculationFire	= mod:NewSpecialWarningSpell(142416, nil, nil, nil, 2)
--Ka'roz the Locust
local specWarnFlashCast				= mod:NewSpecialWarningSpell(143701, nil, nil, nil, 2)--I realize two abilities on same boss both using same sound is less than ideal, but user can change it now, and 1 or 3 feel appropriate for both of these
local specWarnFlash					= mod:NewSpecialWarningYou("ej8058")--Flash is name of his charge ability
local specWarnFlashNear				= mod:NewSpecialWarningClose("ej8058")
local specWarnWhirlingNear			= mod:NewSpecialWarningClose(143701)--Whirling is name of debuff applied if you get hit by flash (avoidable) No special warning needed for on YOU, but special warning needed if near you to avoid damage
local yellFlash						= mod:NewYell("ej8058")
local yellWhirling					= mod:NewYell(143701, nil, false)
local specWarnHurlAmber				= mod:NewSpecialWarningSpell(143759, nil, nil, nil, 2)--I realize two abilities on same boss both using same sound is less than ideal, but user can change it now, and 1 or 3 feel appropriate for both of these
local specWarnCausticAmber			= mod:NewSpecialWarningMove(143735)--Stuff on the ground
--Skeer the Bloodseeker
local specWarnBloodletting			= mod:NewSpecialWarningSwitch(143280, "-Healer")
--Rik'kal the Dissector
local specWarnMutate				= mod:NewSpecialWarningYou(143337)
local specWarnParasiteFixate		= mod:NewSpecialWarningYou(143358, false)
local specWarnInjection				= mod:NewSpecialWarningSpell(143339, "Tank", nil, nil, 3)
local specWarnMoreParasites			= mod:NewSpecialWarning("specWarnMoreParasites", "Tank")
--Hisek the Swarmkeeper
local specWarnAim					= mod:NewSpecialWarningYou(142948)
local yellAim						= mod:NewYell(142948)
local specWarnAimOther				= mod:NewSpecialWarningTarget(142948)
local specWarnRapidFire				= mod:NewSpecialWarningSpell(143243, nil, nil, nil, 2)

local timerJumpToCenter				= mod:NewCastTimer(6.5, 143545)
--Kil'ruk the Wind-Reaver
local timerGouge					= mod:NewTargetTimer(10, 143939, nil, "Tank", nil, 5)
local timerReaveCD					= mod:NewCDTimer(33, 148676, nil, nil, nil, 2, nil, DBM_CORE_HEALER_ICON)
local timerDFACD					= mod:NewCDTimer(34, 142232, nil, nil, nil, 3)--34-43 variation
--Xaril the Poisoned-Mind
local timerToxicCatalystCD			= mod:NewCDTimer(33, "ej8036", nil, nil, nil, 3)
--Kaz'tik the Manipulator
local timerMesmerizeCD				= mod:NewCDTimer(34, 142671, nil, nil, nil, 3)
--Korven the Prime
local timerShieldBash				= mod:NewTargetTimer(6, 143974, nil, "Tank")
local timerShieldBashCD				= mod:NewCDTimer(17, 143974, nil, "Tank", nil, 5, nil, DBM_CORE_TANK_ICON)
local timerEncaseInAmber			= mod:NewTargetTimer(10, 142564)
local timerEncaseInAmberCD			= mod:NewCDTimer(30, 142564, nil, nil, nil, 5, nil, nil, nil, 1, 4)--Technically a next timer but we use cd cause it's only cast if someone is low when it comes off 30 second internal cd. VERY important timer for heroic
--Iyyokuk the Lucid
local timerInsaneCalculation		= mod:NewBuffActiveTimer(15, 142808)
local timerInsaneCalculationCD		= mod:NewCDTimer(25, 142416, nil, nil, nil, 3)--25 is minimum but variation is wild (25-50 second variation)
--Ka'roz the Locust
local timerFlashCD					= mod:NewCDTimer(62, 143701, nil, nil, nil, 3)
local timerWhirling					= mod:NewBuffFadesTimer(5, 143701, nil, false)
local timerHurlAmberCD				= mod:NewCDTimer(62, 143759, nil, nil, nil, 3)--TODO< verify cd on spell itself. in my logs he died after only casting it once every time.
--Skeer the Bloodseeker
local timerBloodlettingCD			= mod:NewCDTimer(35, 143280, nil, nil, nil, 1)--35-65 variable. most of the time it's around 42 range
--Rik'kal the Dissector
local timerMutate					= mod:NewBuffFadesTimer(20, 143337, nil, false)
local timerMutateCD					= mod:NewCDCountTimer(31.5, 143337, nil, nil, nil, 3)
local timerInjectionCD				= mod:NewNextTimer(9.5, 143339, nil, "Tank", nil, 5, nil, DBM_CORE_TANK_ICON, nil, 2, 4)
--Hisek the Swarmkeeper
--local timerAim						= mod:NewTargetTimer(5, 142948)--or is it 7, conflicting tooltips
local timerAimCD					= mod:NewCDCountTimer(39.5, 142948, nil, nil, nil, 3)
local timerRapidFireCD				= mod:NewCDTimer(47, 143243, nil, nil, nil, 2, nil, DBM_CORE_DEADLY_ICON)--Heroic, 47-50 variation

local berserkTimer					= mod:NewBerserkTimer(720)

mod:AddRangeFrameOption("6/5/3")
mod:AddSetIconOption("SetIconOnAim", 142948, false)
mod:AddSetIconOption("SetIconOnMesmerize", 142671, false)
mod:AddArrowOption("AimArrow", 142948, false, true)

local calculatingDude, readyToFight = DBM:EJ_GetSectionInfo(8012), DBM:GetSpellInfo(143542)
local vulnerable1, vulnerable2, vulnerable3, vulnerable4 = DBM:GetSpellInfo(143279), DBM:GetSpellInfo(143275), DBM:GetSpellInfo(142929), DBM:GetSpellInfo(142931)
local catalystBlue, catalystRed, catalystYellow = DBM:GetSpellInfo(142532), DBM:GetSpellInfo(142533), DBM:GetSpellInfo(142534)
local RedDebuffs = {DBM:GetSpellInfo(143605), DBM:GetSpellInfo(143610), DBM:GetSpellInfo(143615), DBM:GetSpellInfo(143620), (DBM:GetSpellInfo(143627))}
local PurpleDebuffs = {DBM:GetSpellInfo(143606), DBM:GetSpellInfo(143611), DBM:GetSpellInfo(143616), DBM:GetSpellInfo(143621), (DBM:GetSpellInfo(143628))}
local BlueDebuffs = {DBM:GetSpellInfo(143607), DBM:GetSpellInfo(143612), DBM:GetSpellInfo(143617), DBM:GetSpellInfo(143622), (DBM:GetSpellInfo(143629))}
local GreenDebuffs = {DBM:GetSpellInfo(143608), DBM:GetSpellInfo(143613), DBM:GetSpellInfo(143618), DBM:GetSpellInfo(143623), (DBM:GetSpellInfo(143630))}
local YellowDebuffs = {DBM:GetSpellInfo(143610), DBM:GetSpellInfo(143614), DBM:GetSpellInfo(143619), DBM:GetSpellInfo(143624), (DBM:GetSpellInfo(143631))}

local SwordDebuffs = {DBM:GetSpellInfo(143605), DBM:GetSpellInfo(143606), DBM:GetSpellInfo(143607), DBM:GetSpellInfo(143608), (DBM:GetSpellInfo(143609))}
local DrumDebuffs = {DBM:GetSpellInfo(143610), DBM:GetSpellInfo(143611), DBM:GetSpellInfo(143612), DBM:GetSpellInfo(143613), (DBM:GetSpellInfo(143614))}
local BombDebuffs = {DBM:GetSpellInfo(143615), DBM:GetSpellInfo(143616), DBM:GetSpellInfo(143617), DBM:GetSpellInfo(143618), (DBM:GetSpellInfo(143619))}
local MantidDebuffs = {DBM:GetSpellInfo(143620), DBM:GetSpellInfo(143621), DBM:GetSpellInfo(143622), DBM:GetSpellInfo(143623), (DBM:GetSpellInfo(143624))}
local StaffDebuffs = {DBM:GetSpellInfo(143627), DBM:GetSpellInfo(143628), DBM:GetSpellInfo(143629), DBM:GetSpellInfo(143630), (DBM:GetSpellInfo(143631))}

local AllDebuffs = {
	DBM:GetSpellInfo(143605), DBM:GetSpellInfo(143606), DBM:GetSpellInfo(143607), DBM:GetSpellInfo(143608), DBM:GetSpellInfo(143609),
	DBM:GetSpellInfo(143610), DBM:GetSpellInfo(143611), DBM:GetSpellInfo(143612), DBM:GetSpellInfo(143613), DBM:GetSpellInfo(143614),
	DBM:GetSpellInfo(143615), DBM:GetSpellInfo(143616), DBM:GetSpellInfo(143617), DBM:GetSpellInfo(143618), DBM:GetSpellInfo(143619),
	DBM:GetSpellInfo(143620), DBM:GetSpellInfo(143621), DBM:GetSpellInfo(143622), DBM:GetSpellInfo(143623), DBM:GetSpellInfo(143624),
	DBM:GetSpellInfo(143627), DBM:GetSpellInfo(143628), DBM:GetSpellInfo(143629), DBM:GetSpellInfo(143630), (DBM:GetSpellInfo(143631))
}

local FlavorTable = {
	[71161] = L.KilrukFlavor,--Kil'ruk the Wind-Reaver
	[71157] = L.XarilFlavor,--Xaril the Poisoned-Mind
	[71156] = L.KaztikFlavor,--Kaz'tik the Manipulator
	[71155] = L.KorvenFlavor2,--Korven the Prime
	[71160] = L.IyyokukFlavor,--Iyyokuk the Lucid
	[71154] = L.KarozFlavor,--Ka'roz the Locust
	[71152] = L.SkeerFlavor,--Skeer the Bloodseeker
	[71158] = L.RikkalFlavor,--Rik'kal the Dissector
	[71153] = L.hisekFlavor--Hisek the Swarmkeeper
}

local expectedWhirlCount = 4
------------------
--Tables, can't recover
local activatedTargets = {}--A table, for the 3 on pull
local activeBossGUIDS = {}
--Not important, don't need to recover
local calculatedShape, calculatedNumber, calculatedColor  = nil, nil, nil
local lastWhirl = nil
local mathNumber = 100
--Important, needs recover
mod.vb.mutateCount = 0
mod.vb.aimCount = 0
mod.vb.parasitesActive = 0
mod.vb.whirlCast = 0
mod.vb.whirlTime = 0
mod.vb.aimActive = false
mod.vb.mutateActive = false
mod.vb.flashActive = false
mod.vb.toxicInjection = false--Workaround blizzard bug (double check if hotfix live and if workaround still needed on heroic)

local function warnActivatedTargets(self, vulnerable)
	if #activatedTargets > 1 then
		warnActivated:Show(table.concat(activatedTargets, "<, >"))
		specWarnActivated:Show(table.concat(activatedTargets, ", "))
	else
		warnActivated:Show(activatedTargets[1])
		if vulnerable and self:IsTank() then
			specWarnActivatedVulnerable:Show(activatedTargets[1])
		else
			specWarnActivated:Show(activatedTargets[1])
		end
	end
	table.wipe(activatedTargets)
end

local function showRangeFrame()--Only called by mutate
	DBM.RangeCheck:Show(3)
	mod.vb.mutateActive = true
end

local function hideRangeFrame()--Only called by flash
	mod.vb.flashActive = false
	if not mod.vb.aimActive and not mod.vb.mutateActive then
		DBM.RangeCheck:Hide()
	end
end

local function CheckBosses(self)
	local vulnerable = false
	for i = 1, 5 do
		local unitID = "boss"..i
		local unitGUID = UnitGUID(unitID)
		--Only 3 bosses activate on pull, however now the inactive or (next boss to activate) also fires IEEU. As such, we have to filter that boss by scaning for readytofight. Works well though.
		if UnitExists(unitID) and not activeBossGUIDS[unitGUID] and not DBM:UnitBuff(unitID, readyToFight) then
			activeBossGUIDS[unitGUID] = true
			activatedTargets[#activatedTargets + 1] = UnitName(unitID)
			--Activation Controller
			local cid = self:GetCIDFromGUID(unitGUID)
			if cid == 71152 then--Skeer the Bloodseeker
				timerBloodlettingCD:Start(5)--5-6
				if DBM:UnitDebuff("player", vulnerable1) then vulnerable = true end
			elseif cid == 71158 then--Rik'kal the Dissector
				timerInjectionCD:Start(8)
				timerMutateCD:Start(23, 1)
				if DBM:UnitDebuff("player", vulnerable2) then vulnerable = true end
			elseif cid == 71153 then--Hisek the Swarmkeeper
				timerAimCD:Start(32, 1)--Might be 35-37 with unitdebuff filter
				if self:IsMythic() then
					timerRapidFireCD:Start(47.5)--47-50 with unitdebuff filter
				end
			elseif cid == 71161 then--Kil'ruk the Wind-Reaver
				if self:IsMythic() then
					timerReaveCD:Start(38.5)
				end
				self:StopRepeatedScan("DFAScan")
				self:ScheduleMethod(23, "StartRepeatedScan", unitGUID, "DFAScan", 0.25, true)--Not a large sample size, data shows it happen 29-30 seconds after IEEU fires on two different pulls. Although 2 is a poor sample
				--timerDFACD:Start()
				if DBM:UnitDebuff("player", vulnerable3) then vulnerable = true end
			elseif cid == 71157 then--Xaril the Poisoned-Mind
				timerToxicCatalystCD:Start(19.5)--May need tweaking by about a sec or two. Need some transcriptors
				if DBM:UnitDebuff("player", vulnerable4) then vulnerable = true end
			elseif cid == 71156 then--Kaz'tik the Manipulator
--				timerMesmerizeCD:Start(20)--Need transcriptor log. Seems WILDLY variable though and probably not useful
			elseif cid == 71155 then--Korven the Prime
				timerShieldBashCD:Start(19)--20seconds from REAL IEEU
			elseif cid == 71160 then--Iyyokuk the Lucid
				timerInsaneCalculationCD:Start()
			elseif cid == 71154 then--Ka'roz the Locust
				timerFlashCD:Start(14)--In final LFR test, he didn't cast this for 20 seconds. TODO check this change
				timerHurlAmberCD:Start(44)
			end--]]
		end
	end
	if #activatedTargets >= 1 then
		warnActivatedTargets(self, vulnerable)--Down here so we can send tank vulnerable status
	end
end

local function delayMonsterEmote(target)
	--Because now the raid boss emotes fire AFTER this and we need them first
	warnCalculated:Show(target)
	timerInsaneCalculation:Start()
	timerInsaneCalculationCD:Start()
	if target == UnitName("player") then
		specWarnCalculated:Show()
		if not mod:IsDifficulty("lfr25") then
			yellCalculated:Yell()
		end
	else--it's not us, so now lets check activated criteria for target based on previous emotes
		local criteriaMatched = false--Now to start checking matches.
		if calculatedColor == "Red" then
			for _, spellname in ipairs(RedDebuffs) do
				local _, _, count = DBM:UnitDebuff("player", spellname)
				if count then--Found
					criteriaMatched = true
					break
				end
			end
		elseif calculatedColor == "Purple" then
			for _, spellname in ipairs(PurpleDebuffs) do
				local _, _, count = DBM:UnitDebuff("player", spellname)
				if count then--Found
					criteriaMatched = true
					break
				end
			end
		elseif calculatedColor == "Blue" then
			for _, spellname in ipairs(BlueDebuffs) do
				local _, _, count = DBM:UnitDebuff("player", spellname)
				if count then--Found
					criteriaMatched = true
					break
				end
			end
		elseif calculatedColor == "Green" then
			for _, spellname in ipairs(GreenDebuffs) do
				local _, _, count = DBM:UnitDebuff("player", spellname)
				if count then--Found
					criteriaMatched = true
					break
				end
			end
		elseif calculatedColor == "Yellow" then
			for _, spellname in ipairs(YellowDebuffs) do
				local _, _, count = DBM:UnitDebuff("player", spellname)
				if count then--Found
					criteriaMatched = true
					break
				end
			end
		elseif calculatedShape == "Sword" then
			for _, spellname in ipairs(SwordDebuffs) do
				local _, _, count = DBM:UnitDebuff("player", spellname)
				if count then--Found
					criteriaMatched = true
					break
				end
			end
		elseif calculatedShape == "Drum" then
			for _, spellname in ipairs(DrumDebuffs) do
				local _, _, count = DBM:UnitDebuff("player", spellname)
				if count then--Found
					criteriaMatched = true
					break
				end
			end
		elseif calculatedShape == "Bomb" then
			for _, spellname in ipairs(BombDebuffs) do
				local _, _, _, count = UnitDebuff("player", spellname)
				if count then--Found
					criteriaMatched = true
					break
				end
			end
		elseif calculatedShape == "Mantid" then
			for _, spellname in ipairs(MantidDebuffs) do
				local _, _, count = DBM:UnitDebuff("player", spellname)
				if count then--Found
					criteriaMatched = true
					break
				end
			end
		elseif calculatedShape == "Staff" then
			for _, spellname in ipairs(StaffDebuffs) do
				local _, _, count = DBM:UnitDebuff("player", spellname)
				if count then--Found
					criteriaMatched = true
					break
				end
			end
		elseif calculatedNumber then
			for _, spellname in ipairs(AllDebuffs) do
				local _, _, count = DBM:UnitDebuff("player", spellname)
				if count then--Found
					if count == calculatedNumber then
						criteriaMatched = true
					end
					break
				end
			end
		end
		if criteriaMatched then
			specWarnCalculated:Show()
			if not mod:IsDifficulty("lfr25") then
				yellCalculated:Yell()
			end
		end
	end
end

--Another pre target scan (ie targets player BEFORE cast like iron qon)
function mod:DFAScan(targetname)
	self:StopRepeatedScan("DFAScan")
	warnDeathFromAbove:Show(targetname)
	timerDFACD:Start()
	if targetname == UnitName("player") then
		specWarnDeathFromAbove:Show()
		yellDeathFromAbove:Yell()
	elseif self:CheckNearby(10, targetname) then
		specWarnDeathFromAboveNear:Show(targetname)
	end
end

function mod:FlashScan(targetname)
	if targetname ~= lastWhirl then
		lastWhirl = targetname
		self.vb.whirlCast = self.vb.whirlCast + 1
		warnFlash:Show(self.vb.whirlCast, targetname)
		if targetname == UnitName("player") then
			specWarnFlash:Show()
			yellFlash:Yell()
		elseif self:CheckNearby(10, targetname) then
			specWarnFlashNear:Show(targetname)
		end
	end
	if self.vb.whirlCast >= expectedWhirlCount or (GetTime() - self.vb.whirlTime) > 20 then
		self:StopRepeatedScan("FlashScan")
	end
end

function mod:OnCombatStart(delay)
	table.wipe(activeBossGUIDS)
	table.wipe(activatedTargets)
	calculatedShape = nil
	calculatedNumber = nil
	calculatedColor = nil
	self.vb.mutateCount = 0
	self.vb.aimCount = 0
	if self:IsMythic() then
		self.vb.parasitesActive = 0
	else
		DBM:AddMsg(DBM_CORE_DYNAMIC_ADD_COUNT)
	end
	self.vb.aimActive = false
	self.vb.mutateActive = false
	self.vb.flashActive = false
	self.vb.toxicInjection = false
	self:RegisterShortTermEvents(
		"INSTANCE_ENCOUNTER_ENGAGE_UNIT"--We register here to make sure we wipe vb.on pull
	)
	timerJumpToCenter:Start(-delay)
	berserkTimer:Start(-delay)
	mathNumber = 100
end

function mod:OnCombatEnd()
	self:UnregisterShortTermEvents()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.AimArrow then
		DBM.Arrow:Hide()
	end
end

--"<13.6 19:16:29> [UNIT_SPELLCAST_SUCCEEDED] Iyyokuk the Lucid [[boss2:Jump to Center::0:143545]]", -- [95]
--^don't let above fool you, not all of the paragons fire this spell!!! that is why we MUST use IEEU
function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	self:Unschedule(CheckBosses)
	self:Schedule(1, CheckBosses, self)--Delay check to make sure we run function only once on pull
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 142725 then
		timerToxicCatalystCD:Start()
		if self.Options.warnToxicCatalyst then
			warnToxicCatalystBlue:Show()
		end
		if DBM:UnitDebuff("player", catalystBlue) then
			specWarnCatalystBlue:Show()
			if self.Options.yellToxicCatalyst then
				yellCatalystBlue:Yell()
			end
		end
	elseif spellId == 142726 then
		timerToxicCatalystCD:Start()
		if self.Options.warnToxicCatalyst then
			warnToxicCatalystRed:Show()
		end
		if DBM:UnitDebuff("player", catalystRed) then
			specWarnCatalystRed:Show()
			if self.Options.yellToxicCatalyst then
				yellCatalystRed:Yell()
			end
		end
	elseif spellId == 142727 then
		timerToxicCatalystCD:Start()
		if self.Options.warnToxicCatalyst then
			warnToxicCatalystYellow:Show()
		end
		if DBM:UnitDebuff("player", catalystYellow) then
			specWarnCatalystYellow:Show()
			if self.Options.yellToxicCatalyst then
				yellCatalystYellow:Yell()
			end
		end
	elseif spellId == 142728 then
		timerToxicCatalystCD:Start()
		if self.Options.warnToxicCatalyst then
			warnToxicCatalystOrange:Show()
		end
		if DBM:UnitDebuff("player", catalystRed, catalystYellow) then--Red or Yellow
			specWarnCatalystOrange:Show()
			if self.Options.yellToxicCatalyst then
				yellCatalystOrange:Yell()
			end
		end
	elseif spellId == 142729 then
		timerToxicCatalystCD:Start()
		if self.Options.warnToxicCatalyst then
			warnToxicCatalystPurple:Show()
		end
		if DBM:UnitDebuff("player", catalystRed, catalystBlue) then--Red or Blue
			specWarnCatalystPurple:Show()
			if self.Options.yellToxicCatalyst then
				yellCatalystPurple:Yell()
			end
		end
	elseif spellId == 142730 then
		timerToxicCatalystCD:Start()
		if self.Options.warnToxicCatalyst then
			warnToxicCatalystGreen:Show()
		end
		if DBM:UnitDebuff("player", catalystYellow, catalystBlue) then--Yellow or Blue
			specWarnCatalystGreen:Show()
			if self.Options.yellToxicCatalyst then
				yellCatalystGreen:Yell()
			end
		end
	elseif spellId == 142416 then
		specWarnInsaneCalculationFire:Show()
	elseif spellId == 143709 then
		self.vb.flashActive = true
		specWarnFlashCast:Show()
		timerFlashCD:Start()
		self.vb.whirlCast = 0
		self.vb.whirlTime = GetTime()
		lastWhirl = nil
		expectedWhirlCount = self:IsMythic() and 5 or 4
		self:StartRepeatedScan(args.sourceGUID, "FlashScan", 0.03, true)
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(6)--Range assumed, spell tooltips not informative enough
			self:Schedule(5, hideRangeFrame)
		end
	elseif spellId == 143280 then
		specWarnBloodletting:Show()
		timerBloodlettingCD:Start()
	elseif spellId == 143974 then
		specWarnShieldBash:Show()
		timerShieldBashCD:Start()
	elseif spellId == 142315 then
		for i = 1, 5 do
			local bossUnitID = "boss"..i
			if UnitExists(bossUnitID) and UnitGUID(bossUnitID) == args.sourceGUID and UnitDetailedThreatSituation("player", bossUnitID) then--We are highest threat target
				specWarnCausticBlood:Show()--So show tank warning
				break
			end
		end
	elseif spellId == 143243 then
		warnRapidFire:Show()
		specWarnRapidFire:Show()
		timerRapidFireCD:Start()
	elseif spellId == 143339 then
		for i = 1, 5 do
			local bossUnitID = "boss"..i
			if UnitExists(bossUnitID) and UnitGUID(bossUnitID) == args.sourceGUID and UnitDetailedThreatSituation("player", bossUnitID) then
				local elapsed, total = timerMutateCD:GetTime(self.vb.mutateCount+1)
				local remaining = total - elapsed
				if self:IsMythic() and (remaining < 20) and (self.vb.parasitesActive < 2) and not DBM:UnitDebuff("player", args.spellName) then--NEED to know Mythic number of parasites
					specWarnMoreParasites:Show()
				else--We want to block attack and not spawn anything
					specWarnInjection:Show()
				end
				timerInjectionCD:Start()
				break
			end
		end
	elseif spellId == 148676 then
		specWarnReave:Show()
		timerReaveCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 142528 then
		self.vb.toxicInjection = true
		warnToxicInjection:Show()
		timerToxicCatalystCD:Start(20)
	elseif spellId == 142232 then
		self:StopRepeatedScan("DFAScan")
		self:ScheduleMethod(28, "StartRepeatedScan", args.sourceGUID, "DFAScan", 0.25, true)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 143339 then
		local amount = args.amount or 1
		warnInjection:Show(args.destName, amount)
	elseif spellId == 142532 and args:IsPlayer() then
		specWarnToxicBlue:Show()
	elseif spellId == 142533 and args:IsPlayer() then
		specWarnToxicRed:Show()
	elseif spellId == 142534 and args:IsPlayer() then
		specWarnToxicYellow:Show()
	elseif spellId == 142671 then
		warnMesmerize:Show(args.destName)
		timerMesmerizeCD:Start()
		if args.IsPlayer() then
			specWarnMesmerize:Show()
			yellMesmerize:Yell()
		else
			specWarnMesmerizeOther:Show(args.destName)
			specWarnKunchongs:Show()
		end
		if self.Options.SetIconOnMesmerize then
			self:SetIcon(args.destName, 1)
		end
	elseif spellId == 142564 then
		warnEncaseInAmber:Show(args.destName)
		specWarnEncaseInAmber:Show(args.destName)
		timerEncaseInAmber:Start(args.destName)
		timerEncaseInAmberCD:Start()
	elseif spellId == 143939 then
		timerGouge:Start(args.destName)
		if args.IsPlayer() then
			specWarnGouge:Show()
		else
			specWarnGougeOther:Show(args.destName)
		end
	elseif spellId == 143974 then
		timerShieldBash:Start(args.destName)
		for i = 1, 5 do
			local bossUnitID = "boss"..i
			if UnitExists(bossUnitID) and UnitGUID(bossUnitID) == args.sourceGUID and not UnitDetailedThreatSituation("player", bossUnitID) then--We are not highest threat target
				specWarnShieldBashOther:Show(args.destName)--So warn AGAIN
				break
			end
		end
	elseif spellId == 143701 then
		if args.IsPlayer() then
			timerWhirling:Start()
		else
			local uId = DBM:GetRaidUnitId(args.destName)
			if uId then
				local inRange = DBM.RangeCheck:GetDistance("player", uId)
				if inRange and inRange < 6 then
					specWarnWhirlingNear:Show(args.destName)
				end
			end
		end
	elseif spellId == 143759 then
		specWarnHurlAmber:Show()
		timerHurlAmberCD:Start()
	elseif spellId == 143337 then
		if self:AntiSpam(2, 3) then
			self.vb.mutateCount = self.vb.mutateCount + 1
			timerMutateCD:Start(nil, self.vb.mutateCount+1)
			if self.Options.RangeFrame then
				self.vb.mutateActive = false
				if not self.vb.aimActive and not self.vb.flashActive then
					DBM.RangeCheck:Hide()--Hide it if aim isn't active, otherwise, delay hide call until hide is called by SPELL_AURA_REMOVED for aim
				end
				self:Schedule(26.5, showRangeFrame)--Show about 5 seconds before mutate cast
			end
		end
		warnMutate:CombinedShow(0.5, self.vb.mutateCount, args.destName)
		if args.IsPlayer() then
			specWarnMutate:Show()
			timerMutate:Start()
		end
	elseif spellId == 143358 and args.IsPlayer() then
		specWarnParasiteFixate:Show()
	elseif spellId == 142948 then
		self.vb.aimCount = self.vb.aimCount + 1
		self.vb.aimActive = true
		warnAim:Show(self.vb.aimCount, args.destName)
		--[[--New difficulties, unable to verify all this for a while.
		if self:IsDifficulty("lfr25") then
			timerAim:Start(7, args.destName)
		elseif self:IsDifficulty("normal25", "heroic25") then
			timerAim:Start(6, args.destName)
		else
			timerAim:Start(nil, args.destName)
		end--]]
		timerAimCD:Start(nil, self.vb.aimCount+1)
		if args.IsPlayer() then
			specWarnAim:Show()
			yellAim:Yell()
		else
			specWarnAimOther:Show(args.destName)
		end
		if self.Options.RangeFrame then
--			if self:IsDifficulty("normal25", "heroic25") then
				DBM.RangeCheck:Show(3)--Have to assume 3 for all now, because all group sizes will now either be 30, or 20. Until we know for sure
--			else
--				DBM.RangeCheck:Show(5)
--			end
		end
		if self.Options.SetIconOnAim then
			self:SetIcon(args.destName, 3)
		end
		if self.Options.AimArrow then
			DBM.Arrow:ShowRunTo(args.destName, 3, 5)
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 142564 then
		timerEncaseInAmber:Cancel(args.destName)
	elseif spellId == 143939 then
		timerGouge:Cancel(args.destName)
	elseif spellId == 143974 then
		timerShieldBash:Cancel(args.destName)
	elseif spellId == 143700 and self.Options.RangeFrame and not self.vb.mutateActive and not self.vb.aimActive and not self.vb.flashActive then
		DBM.RangeCheck:Hide()
	elseif spellId == 142948 then
		self.vb.aimActive = false
		if self.Options.RangeFrame then
			if not self.vb.mutateActive and not self.vb.flashActive then--Don't call hide because frame is needed by mutate and will be hiden after that.
				DBM.RangeCheck:Hide()
			end
		end
		if self.Options.SetIconOnAim then
			self:SetIcon(args.destName, 0)
		end
	elseif spellId == 143339 then
		if self:IsMythic() then
			self.vb.parasitesActive = self.vb.parasitesActive + 4--Assumed, probably 5-7. All other modes will now be variable which means this warning is now mythic only
		end
	elseif spellId == 142671 and self.Options.SetIconOnMesmerize then
		self:SetIcon(args.destName, 0)
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 143735 and destGUID == UnitGUID("player") and self:AntiSpam(2, 2) then
		specWarnCausticAmber:Show()
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 71161 then--Kil'ruk the Wind-Reaver
		self:StopRepeatedScan("DFAScan")
		timerReaveCD:Cancel()
	elseif cid == 71157 then--Xaril the Poisoned-Mind
		timerToxicCatalystCD:Cancel()
	elseif cid == 71155 then--Korven the Prime
		timerShieldBashCD:Cancel()
		timerEncaseInAmberCD:Cancel()
	elseif cid == 71160 then--Iyyokuk the Lucid
		timerInsaneCalculationCD:Cancel()
	elseif cid == 71154 then--Ka'roz the Locust
		self:StopRepeatedScan("FlashScan")
		timerFlashCD:Cancel()
		timerHurlAmberCD:Cancel()
	elseif cid == 71152 then--Skeer the Bloodseeker
		timerBloodlettingCD:Cancel()
	elseif cid == 71158 then--Rik'kal the Dissector
		timerMutateCD:Cancel()
		timerInjectionCD:Cancel()
		self:Unschedule(showRangeFrame)
	elseif cid == 71153 then--Hisek the Swarmkeeper
		timerAimCD:Cancel()
		timerRapidFireCD:Cancel()
	elseif cid == 71578 and self:IsMythic() then--Amber Parasite
		self.vb.parasitesActive = self.vb.parasitesActive - 1
		warnParasitesLeft:Show(self.vb.parasitesActive)
	elseif cid == 71156 then--Kaz'tik the Manipulator
		timerMesmerizeCD:Cancel()
	end

	if FlavorTable[cid] then
		local x = math.random(1, mathNumber)
		if x == 50 then--1% chance yay
			SendChatMessage(FlavorTable[cid], "SAY")
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)--This emote comes second, so we have to parse things backwards by delaying CHAT_MSG_MONSTER_EMOTE event until this data is complete
	if self:AntiSpam(3, 1) then
		calculatedShape = nil
		calculatedNumber = nil
		calculatedColor = nil
	end
	--UPDATE. Seems now colors and shapes can avoid localizing with icons and color codes
	--Still need to localize 5 numbers in 10 languages so 50 localizations instead of 150
	if msg:find("FFFF0000") then
		calculatedColor = "Red"
	elseif msg:find("FFFF00FF") then
		calculatedColor = "Purple"
	elseif msg:find("FF0000FF") then
		calculatedColor = "Blue"
	elseif msg:find("FF00FF00") then
		calculatedColor = "Green"
	elseif msg:find("FFFFFF00") then
		calculatedColor = "Yellow"
	elseif msg:find("ABILITY_IYYOKUK_SWORD") then
		calculatedShape = "Sword"
	elseif msg:find("ABILITY_IYYOKUK_DRUM") then
		calculatedShape = "Drum"
	elseif msg:find("ABILITY_IYYOKUK_BOMB") then
		calculatedShape = "Bomb"
	elseif msg:find("ABILITY_IYYOKUK_MANTID") then
		calculatedShape = "Mantid"
	elseif msg:find("ABILITY_IYYOKUK_STAFF") then
		calculatedShape = "Staff"
	elseif msg:find(L.one) then
		calculatedNumber = 0--1 stacks actually return as 0 in checks
	elseif msg:find(L.two) then
		calculatedNumber = 2
	elseif msg:find(L.three) then
		calculatedNumber = 3
	elseif msg:find(L.four) then
		calculatedNumber = 4
	elseif msg:find(L.five) then
		calculatedNumber = 5
	end
end

function mod:CHAT_MSG_MONSTER_EMOTE(msg, npc, _, _, target)
	local targetname = DBM:GetUnitFullName(target)
	if npc == calculatingDude then
		self:Unschedule(delayMonsterEmote)
		self:Schedule(0.2, delayMonsterEmote, targetname)
	end
end
