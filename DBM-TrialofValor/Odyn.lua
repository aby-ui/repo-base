local mod	= DBM:NewMod(1819, "DBM-TrialofValor", nil, 861)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220116041824")
mod:SetCreatureID(114263, 114361, 114360)--114263 Odyn, 114361 Hymdall, 114360 Hyrja
mod:SetEncounterID(1958)
--mod:SetBossHPInfoToHighest()
mod:SetMainBossID(114263)
mod:SetUsedIcons(1)
mod:SetHotfixNoticeRev(15581)
mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 228003 228012 228171 231013",
	"SPELL_CAST_SUCCESS 228012 228028 228162 231350 227629",
	"SPELL_AURA_APPLIED 228029 227807 227959 227626 228918 227490 227491 227498 227499 227500 231311 231342 231344 231345 231346 229579 229580 229581 229582 229583 229584",
	"SPELL_AURA_APPLIED_DOSE 227626",
	"SPELL_AURA_REMOVED 228029 227807 227959 227490 227491 227498 227499 227500 231311 231342 231344 231345 231346 229584",
	"SPELL_PERIODIC_DAMAGE 228007 228683",
	"SPELL_PERIODIC_MISSED 228007 228683",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"UNIT_SPELLCAST_SUCCEEDED boss1 boss2 boss3"
)

--TODO, phase 3 storms (area of affect). not in combat log or even transcriptor. appears every 30 seconds give or take. verify in more attempts and add scheduler for it
--TODO, Cleansing flame timers/target announces?
--Stage 1: Halls of Valor was merely a set back
local hymdall = DBM:EJ_GetSectionInfo(14005)
local hyrja = DBM:EJ_GetSectionInfo(14006)

local warnDancingBlade				= mod:NewCountAnnounce(228003, 3)--Change if target scanning works, but considering it doesn't in 5 man version of this spell, omitting for now
local warnRevivify					= mod:NewCastAnnounce(228171, 4)
local warnExpelLight				= mod:NewTargetAnnounce(228028, 3)
local warnShieldofLight				= mod:NewTargetCountAnnounce(228270, 3, nil, nil, nil, nil, nil, nil, true)
--Stage 2: Stuff
local warnPhase2					= mod:NewPhaseAnnounce(2, 2)
--Stage 3: Odyn immitates lei shen
local warnPhase3					= mod:NewPhaseAnnounce(3, 2)
local warnStormofJustice			= mod:NewTargetAnnounce(227807, 3)

--Stage 1: Halls of Valor was merely a set back
local specWarnDancingBlade			= mod:NewSpecialWarningMove(228003, nil, nil, nil, 1, 2)
--local yellDancingBlade			= mod:NewYell(228003)
local specWarnHornOfValor			= mod:NewSpecialWarningMoveAway(228012, nil, nil, nil, 1, 2)
local specWarnExpelLight			= mod:NewSpecialWarningMoveAway(228028, nil, nil, nil, 1, 2)
local yellExpelLight				= mod:NewYell(228028)
local specWarnShieldofLight			= mod:NewSpecialWarningYou(228270, nil, nil, nil, 1, 2)
local yellShieldofLightFades		= mod:NewFadesYell(228270)
local specWarnBranded				= mod:NewSpecialWarningMoveTo(227503, nil, nil, nil, 3, 6)
local yellBranded					= mod:NewPosYell(227490, DBM_CORE_L.AUTO_YELL_CUSTOM_POSITION)
--Stage 2: Odyn immitates margok
local specWarnOdynsTest				= mod:NewSpecialWarningCount(227626, nil, DBM_CORE_L.AUTO_SPEC_WARN_OPTIONS.stack:format(5, 159515), nil, 1, 2)
local specWarnOdynsTestOther		= mod:NewSpecialWarningTaunt(227626, nil, nil, nil, 1, 2)
local specWarnShatterSpears			= mod:NewSpecialWarningDodge(231013, false, nil, 2, 2, 2)--Every 8 seconds, so off by default
local specWarnHyrja					= mod:NewSpecialWarningSwitch("ej14006", nil, nil, nil, 1, 2)
local specWarnHymall				= mod:NewSpecialWarningSwitch("ej14005", nil, nil, nil, 1, 2)

--Stage 3: Odyn immitates lei shen
local specWarnStormofJustice		= mod:NewSpecialWarningMoveAway(227807, nil, nil, nil, 1, 2)
local yellStormofJustice			= mod:NewYell(227807)
local specWarnStormforgedSpear		= mod:NewSpecialWarningRun(228918, nil, nil, nil, 4, 2)
local specWarnStormforgedSpearOther	= mod:NewSpecialWarningTaunt(228918, nil, nil, nil, 1, 2)
local specWarnCleansingFlame		= mod:NewSpecialWarningMove(228683, nil, nil, nil, 1, 2)
--Mythic
local specWarnRunicBrand			= mod:NewSpecialWarningYouPos(231297, nil, nil, 2, 3, 6)
local yellRunicBrand				= mod:NewPosYell(231297, DBM_CORE_L.AUTO_YELL_CUSTOM_POSITION)

--Adds (stage 1 and 2)
mod:AddTimerLine(hymdall)
local timerDancingBladeCD			= mod:NewNextTimer(31, 228003, nil, nil, nil, 3)--Alternating two times
local timerHornOfValorCD			= mod:NewNextCountTimer(32, 228012, nil, nil, nil, 2, nil, nil, nil, 2, 4)--Alternating two times
mod:AddTimerLine(hyrja)
local timerExpelLightCD				= mod:NewNextTimer(32, 228028, nil, nil, nil, 3)--Alternating two times
local timerShieldofLightCD			= mod:NewNextCountTimer(32, 228270, nil, nil, nil, 3, nil, nil, nil, 3, 4)--Alternating two times
--Stage 1: Halls of Valor was merely a set back
mod:AddTimerLine(SCENARIO_STAGE:format(1))
local timerDrawPowerCD				= mod:NewNextTimer(70, 227503, nil, nil, nil, 6, nil, nil, nil, 1, 4)
local timerDrawPower				= mod:NewCastTimer(33, 227629, nil, nil, nil, 2, nil, DBM_COMMON_L.DEADLY_ICON, nil, 1, 4)
--Stage 2: Odyn immitates margok
mod:AddTimerLine(SCENARIO_STAGE:format(2))
local timerSpearCD					= mod:NewNextTimer(8, 227697, nil, nil, nil, 3)
local timerHymdallCD				= mod:NewNextTimer(70, "ej14005", nil, nil, nil, 1, 228012, DBM_COMMON_L.DAMAGE_ICON)
local timerHyrjaCD					= mod:NewNextTimer(70, "ej14006", nil, nil, nil, 1, 228270, DBM_COMMON_L.DAMAGE_ICON)
--Stage 3: Odyn immitates lei shen
mod:AddTimerLine(SCENARIO_STAGE:format(3))
local timerStormOfJusticeCD			= mod:NewNextTimer(10.9, 227807, nil, nil, nil, 3)
local timerStormforgedSpearCD		= mod:NewNextTimer(10.9, 228918, 71466, "Tank|Healer", nil, 5, nil, DBM_COMMON_L.TANK_ICON..DBM_COMMON_L.DEADLY_ICON, nil, 2, 4)
--Mythic
mod:AddTimerLine(ENCOUNTER_JOURNAL_SECTION_FLAG12)
local timerRunicBrandCD				= mod:NewNextTimer(35, 231297, nil, nil, nil, 3, nil, DBM_COMMON_L.HEROIC_ICON, nil, 1, 4)
local timerRadiantSmite				= mod:NewCastTimer(7.5, 231350, nil, nil, nil, 2, nil, DBM_COMMON_L.HEROIC_ICON)

--local berserkTimer				= mod:NewBerserkTimer(300)

mod:AddSetIconOption("SetIconOnShield", 228270, true)
mod:AddInfoFrameOption(227503, true)
mod:AddRangeFrameOption("5/8/15")
mod:AddNamePlateOption("NPAuraOnBranded", 227503, true)

mod.vb.phase = 1
mod.vb.hornCasting = false
mod.vb.hornCast = 0
mod.vb.shieldCast = 0
mod.vb.expelLightCast = 0
mod.vb.dancingBladeCast = 0
mod.vb.brandActive = false
local drawTable = {}
local playerProtected = false
--Mythic Timers
local dancingBladeTimers = {15.0, 20.1, 19.9, 25.0, 20.0}
local hornTimers = {8.1, 22.0, 20.0, 35.0}
local shieldTimers = {20.0, 20.0, 33.0, 22.0, 20.0}
local expelLightTimers = {25.0, 20.0, 15.0, 30.0, 20.0}

local debuffFilter
local playerDebuff = nil
local spellName, protected, expelLight, stormOfJustice = DBM:GetSpellInfo(231311), DBM:GetSpellInfo(229584), DBM:GetSpellInfo(228028), DBM:GetSpellInfo(227807)
do
	debuffFilter = function(uId)
		if not playerDebuff then return true end
		if not DBM:UnitDebuff(uId, playerDebuff) then
			return true
		end
	end
end

local function updateRangeFrame(self)
	if not self.Options.RangeFrame then return end
	if self.vb.brandActive then
		DBM.RangeCheck:Show(15, debuffFilter)--There are no 15 yard items that are actually 15 yard, this will round to 18 :\
	elseif DBM:UnitDebuff("player", expelLight) or DBM:UnitDebuff("player", stormOfJustice) then
		DBM.RangeCheck:Show(8)
	elseif self.vb.hornCasting then--Spread for Horn of Valor
		DBM.RangeCheck:Show(5)
	else
		DBM.RangeCheck:Hide()
	end
end

local updateInfoFrame
do
	local lines = {}
	local sortedLines = {}
	local function addLine(key, value)
		-- sort by insertion order
		lines[key] = value
		sortedLines[#sortedLines + 1] = key
	end
	updateInfoFrame = function()
		local total = 0
		table.wipe(lines)
		table.wipe(sortedLines)
		if drawTable[227490] then--Purple K (NE)
			addLine(drawTable[227490], "|TInterface\\Icons\\Boss_OdunRunes_Purple.blp:12:12|tNE|TInterface\\Icons\\Boss_OdunRunes_Purple.blp:12:12|t")
		end
		if drawTable[227491] then--Orange N (SE)
			addLine(drawTable[227491], "|TInterface\\Icons\\Boss_OdunRunes_Orange.blp:12:12|tSE|TInterface\\Icons\\Boss_OdunRunes_Orange.blp:12:12|t")
		end
		if drawTable[227498] then--Yellow H (SW)
			addLine(drawTable[227498], "|TInterface\\Icons\\Boss_OdunRunes_Yellow.blp:12:12|tSW|TInterface\\Icons\\Boss_OdunRunes_Yellow.blp:12:12|t")
		end
		if drawTable[227499] then--Blue fishies (NW)
			addLine(drawTable[227499], "|TInterface\\Icons\\Boss_OdunRunes_Blue.blp:12:12|tNW|TInterface\\Icons\\Boss_OdunRunes_Blue.blp:12:12|t")
		end
		if drawTable[227500] then--Green box (N)
			addLine(drawTable[227500], "|TInterface\\Icons\\Boss_OdunRunes_Green.blp:12:12|tN|TInterface\\Icons\\Boss_OdunRunes_Green.blp:12:12|t")
		end
		if mod:IsMythic() then
			if playerProtected then
				addLine(protected, "|cFF088A08"..YES.."|r")
			else
				addLine(protected, "|cffff0000"..NO.."|r")
			end
		else
			if #sortedLines == 0 then
				DBM.InfoFrame:Hide()
			end
		end
		return lines, sortedLines
	end
end

function mod:OnCombatStart(delay)
	self.vb.phase = 1
	self.vb.hornCasting = false
	self.vb.hornCast = 0
	self.vb.shieldCast = 0
	self.vb.expelLightCast = 0
	self.vb.dancingBladeCast = 0
	self.vb.brandActive = false
	table.wipe(drawTable)
	playerDebuff = nil
	if self:IsMythic() then
		timerHornOfValorCD:Start(8-delay, 1)
		timerDancingBladeCD:Start(15-delay)
		timerShieldofLightCD:Start(20-delay, 1)
		timerExpelLightCD:Start(25-delay)
		timerDrawPowerCD:Start(35-delay)
	elseif not self:IsEasy() then
		timerHornOfValorCD:Start(8-delay, 1)
		timerDancingBladeCD:Start(16-delay)
		timerShieldofLightCD:Start(23-delay, 1)
		timerExpelLightCD:Start(32-delay)
		timerDrawPowerCD:Start(40-delay)
	else--LFR/Normal
		timerHornOfValorCD:Start(10-delay, 1)
		timerDancingBladeCD:Start(20-delay)
		timerShieldofLightCD:Start(30-delay, 1)
		timerExpelLightCD:Start(40-delay)
		if self:IsNormal() then
			timerDrawPowerCD:Start(45-delay)
		end
	end
	if self.Options.NPAuraOnBranded then
		DBM:FireEvent("BossMod_EnableHostileNameplates")
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
	if self.Options.NPAuraOnBranded then
		DBM.Nameplate:Hide(false, nil, nil, nil, true, true)
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 228003 then
		self.vb.dancingBladeCast = self.vb.dancingBladeCast + 1
		warnDancingBlade:Show(self.vb.dancingBladeCast)
		if self.vb.phase == 1 then
			if self:IsMythic() then
				local timer = dancingBladeTimers[self.vb.dancingBladeCast+1]
				if timer then
					timerDancingBladeCD:Start(timer)
				end
			elseif self:IsEasy() then
				if self.vb.dancingBladeCast == 1 or self.vb.dancingBladeCast == 5 or self.vb.dancingBladeCast == 9 then
					timerDancingBladeCD:Start(30)
				else
					timerDancingBladeCD:Start(20)
				end
			else
				if self.vb.dancingBladeCast % 2 == 0 then
					timerDancingBladeCD:Start(39)
				else
					timerDancingBladeCD:Start(31)
				end
			end
		else
			timerDancingBladeCD:Start(12)
		end
	elseif spellId == 228012 then
		self.vb.hornCasting = true
		self.vb.hornCast = self.vb.hornCast + 1
		specWarnHornOfValor:Show()
		specWarnHornOfValor:Play("scatter")
		if self.vb.phase == 1 then
			if self:IsMythic() then
				local timer = hornTimers[self.vb.hornCast+1]
				if timer then
					timerHornOfValorCD:Start(timer, self.vb.hornCast+1)
				end
			elseif self:IsEasy() then
				if self.vb.hornCast % 2 == 0 then
					--timerHornOfValorCD:Start(43, self.vb.hornCast+1)--More data needed. Probably has an alternation
				else
					timerHornOfValorCD:Start(70)
				end
			else
				if self.vb.hornCast % 2 == 0 then
					timerHornOfValorCD:Start(43, self.vb.hornCast+1)
				else
					timerHornOfValorCD:Start(27, self.vb.hornCast+1)
				end
			end
		else
			timerHornOfValorCD:Start(30, self.vb.hornCast+1)--Need more data
		end
		updateRangeFrame(self)
	elseif spellId == 228171 and self:AntiSpam(2, 2) then
		warnRevivify:Show()
	elseif spellId == 231013 then
		specWarnShatterSpears:Show()
		specWarnHornOfValor:Play("watchorb")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 228012 then
		self.vb.hornCasting = false
		updateRangeFrame(self)
	elseif spellId == 228028 then
		self.vb.expelLightCast = self.vb.expelLightCast + 1
		if self.vb.phase == 1 then
			if self:IsMythic() then
				local timer = expelLightTimers[self.vb.expelLightCast+1]
				if timer then
					timerExpelLightCD:Start(timer)
				end
			elseif self:IsEasy() then
				if self.vb.expelLightCast % 2 == 0 then
					timerExpelLightCD:Start(50)
				else
					timerExpelLightCD:Start(20)
				end
			else
				if self.vb.expelLightCast % 2 == 0 then
					timerExpelLightCD:Start(38)
				else
					timerExpelLightCD:Start(32)
				end
			end
		else
			timerExpelLightCD:Start(18.2)
		end
	elseif spellId == 228162 then--Cast finished, cleanup icons
		if self.Options.SetIconOnShield then
			self:SetIcon(args.destName, 0)
		end
	elseif spellId == 231350 then
		self.vb.brandActive = false
		updateRangeFrame(self)
	elseif spellId == 227629 and self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 228029 then
		warnExpelLight:CombinedShow(0.3, args.destName)--TODO: Confirm can be more than one target
		if args:IsPlayer() then
			specWarnExpelLight:Show()
			specWarnExpelLight:Play("runout")
			yellExpelLight:Yell()
			updateRangeFrame(self)
		end
	elseif spellId == 227807 or spellId == 227959 then--Add and non add version
		warnStormofJustice:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			specWarnStormofJustice:Show()
			specWarnStormofJustice:Play("runout")
			yellStormofJustice:Yell()
			updateRangeFrame(self)
		end
	elseif spellId == 227626 then
		local amount = args.amount or 1
		if (amount == 5 or amount >= 9) and self:AntiSpam(3, 3) then--First warning at 5, then a decent amount of time until 8. then spam every 3 seconds at 8 and above.
			if self:IsTanking("player", "boss1", nil, true) then
				specWarnOdynsTest:Show(amount)
				specWarnOdynsTest:Play("changemt")
			else
				specWarnOdynsTestOther:Show(L.name)
				specWarnOdynsTestOther:Play("changemt")
			end
		end
	elseif spellId == 228918 then
		timerStormforgedSpearCD:Start()--If this can miss, move it to a success event.
		if args:IsPlayer() then
			specWarnStormforgedSpear:Show()
			specWarnStormforgedSpear:Play("justrun")
		else
			specWarnStormforgedSpearOther:Show(args.destName)
			specWarnStormforgedSpearOther:Play("tauntboss")
		end
	elseif spellId == 227490 or spellId == 227491 or spellId == 227498 or spellId == 227499 or spellId == 227500 then--Branded (Draw Power Runes)
		drawTable[spellId] = args.destName
		if spellId == 227490 and args:IsPlayer() then--Purple K (NE)
			specWarnBranded:Show("|TInterface\\Icons\\Boss_OdunRunes_Purple.blp:12:12|tNE|TInterface\\Icons\\Boss_OdunRunes_Purple.blp:12:12|t")
			specWarnBranded:Play("mm3")
			yellBranded:Yell(3, args.spellName, 3)
		elseif spellId == 227491 and args:IsPlayer() then--Orange N (SE)
			specWarnBranded:Show("|TInterface\\Icons\\Boss_OdunRunes_Orange.blp:12:12|tSE|TInterface\\Icons\\Boss_OdunRunes_Orange.blp:12:12|t")
			specWarnBranded:Play("mm2")
			yellBranded:Yell(2, args.spellName, 2)
		elseif spellId == 227498 and args:IsPlayer() then--Yellow H (SW)
			specWarnBranded:Show("|TInterface\\Icons\\Boss_OdunRunes_Yellow.blp:12:12|tSW|TInterface\\Icons\\Boss_OdunRunes_Yellow.blp:12:12|t")
			specWarnBranded:Play("mm1")
			yellBranded:Yell(1, args.spellName, 1)
		elseif spellId == 227499 and args:IsPlayer() then--Blue fishies (NW)
			specWarnBranded:Show("|TInterface\\Icons\\Boss_OdunRunes_Blue.blp:12:12|tNW|TInterface\\Icons\\Boss_OdunRunes_Blue.blp:12:12|t")
			specWarnBranded:Play("mm6")
			yellBranded:Yell(6, args.spellName, 6)
		elseif spellId == 227500 and args:IsPlayer() then--Green box (N)
			specWarnBranded:Show("|TInterface\\Icons\\Boss_OdunRunes_Green.blp:12:12|tN|TInterface\\Icons\\Boss_OdunRunes_Green.blp:12:12|t")
			specWarnBranded:Play("mm4")
			yellBranded:Yell(4, args.spellName, 4)
		end
		if self.Options.InfoFrame then
			if not DBM.InfoFrame:IsShown() then
				DBM.InfoFrame:SetHeader(args.spellName)
				DBM.InfoFrame:Show(6, "function", updateInfoFrame, false, false, true)
			else
				DBM.InfoFrame:Update()
			end
		end
		if self.Options.NPAuraOnBranded then
			DBM.Nameplate:Show(true, args.sourceGUID, spellId)
		end
	elseif spellId == 229579 or spellId == 229580 or spellId == 229581 or spellId == 229582 or spellId == 229583 then--Branded (Mythic Phase 1/2 non fixate rune debuffs)
		if spellId == 229579 and args:IsPlayer() then--Purple K (NE)
			specWarnBranded:Show("|TInterface\\Icons\\Boss_OdunRunes_Purple.blp:12:12|tNE|TInterface\\Icons\\Boss_OdunRunes_Purple.blp:12:12|t")
			specWarnBranded:Play("mm3")
		elseif spellId == 229580 and args:IsPlayer() then--Orange N (SE)
			specWarnBranded:Show("|TInterface\\Icons\\Boss_OdunRunes_Orange.blp:12:12|tSE|TInterface\\Icons\\Boss_OdunRunes_Orange.blp:12:12|t")
			specWarnBranded:Play("mm2")
		elseif spellId == 229581 and args:IsPlayer() then--Yellow H (SW)
			specWarnBranded:Show("|TInterface\\Icons\\Boss_OdunRunes_Yellow.blp:12:12|tSW|TInterface\\Icons\\Boss_OdunRunes_Yellow.blp:12:12|t")
			specWarnBranded:Play("mm1")
		elseif spellId == 229582 and args:IsPlayer() then--Blue fishies (NW)
			specWarnBranded:Show("|TInterface\\Icons\\Boss_OdunRunes_Blue.blp:12:12|tNW|TInterface\\Icons\\Boss_OdunRunes_Blue.blp:12:12|t")
			specWarnBranded:Play("mm6")
		elseif spellId == 229583 and args:IsPlayer() then--Green box (N)
			specWarnBranded:Show("|TInterface\\Icons\\Boss_OdunRunes_Green.blp:12:12|tN|TInterface\\Icons\\Boss_OdunRunes_Green.blp:12:12|t")
			specWarnBranded:Play("mm4")
		end
	elseif spellId == 231311 or spellId == 231342 or spellId == 231344 or spellId == 231345 or spellId == 231346 then--Runic Brand (Phase 3 Mythic)
		if args:IsPlayer() then
			playerDebuff = spellId
			if spellId == 231311 then--Purple K (NE)
				specWarnRunicBrand:Show("|TInterface\\Icons\\Boss_OdunRunes_Purple.blp:12:12|t")
				specWarnRunicBrand:Play("mm3")
				yellRunicBrand:Yell(3, args.spellName, 3)
			elseif spellId == 231342 then--Orange N (SE)
				specWarnRunicBrand:Show("|TInterface\\Icons\\Boss_OdunRunes_Orange.blp:12:12|t")
				specWarnRunicBrand:Play("mm2")
				yellRunicBrand:Yell(2, args.spellName, 2)
			elseif spellId == 231344 then--Yellow H (SW)
				specWarnRunicBrand:Show("|TInterface\\Icons\\Boss_OdunRunes_Yellow.blp:12:12|t")
				specWarnRunicBrand:Play("mm1")
				yellRunicBrand:Yell(1, args.spellName, 1)
			elseif spellId == 231345 then--Blue fishies (NW)
				specWarnRunicBrand:Show("|TInterface\\Icons\\Boss_OdunRunes_Blue.blp:12:12|t")
				specWarnRunicBrand:Play("mm6")
				yellRunicBrand:Yell(6, args.spellName, 6)
			elseif spellId == 231346 then--Green box (N)
				specWarnRunicBrand:Show("|TInterface\\Icons\\Boss_OdunRunes_Green.blp:12:12|t")
				specWarnRunicBrand:Play("mm4")
				yellRunicBrand:Yell(4, args.spellName, 4)
			end
			updateRangeFrame(self)
		end
	elseif spellId == 229584 and args:IsPlayer() then
		playerProtected = true
		if self.Options.InfoFrame then
			DBM.InfoFrame:Update()
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 228029 then
		if args:IsPlayer() then
			updateRangeFrame(self)
		end
	elseif spellId == 227807 or spellId == 227959 then--Add and non add version
		if args:IsPlayer() then
			updateRangeFrame(self)
		end
	elseif spellId == 227503 then--Draw power, assumed
		timerDrawPower:Stop()
	elseif spellId == 227490 or spellId == 227491 or spellId == 227498 or spellId == 227499 or spellId == 227500 then--Branded (Draw Power Runes)
		drawTable[spellId] = nil
		if self.Options.InfoFrame then
			DBM.InfoFrame:Update()
		end
		if self.Options.NPAuraOnBranded then
			DBM.Nameplate:Hide(true, args.sourceGUID, spellId)
		end
	elseif spellId == 231311 or spellId == 231342 or spellId == 231344 or spellId == 231345 or spellId == 231346 then--Branded (Draw Power Runes)
		if args:IsPlayer() then
			playerDebuff = nil
		end
	elseif spellId == 229584 and args:IsPlayer() then
		playerProtected = false
		if self.Options.InfoFrame then
			DBM.InfoFrame:Update()
		end
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 228007 and destGUID == UnitGUID("player") and self:AntiSpam(2, 1) then
		specWarnDancingBlade:Show()
		specWarnDancingBlade:Play("runaway")
	elseif spellId == 228683 and destGUID == UnitGUID("player") and self:AntiSpam(2, 4) then
		specWarnCleansingFlame:Show()
		specWarnCleansingFlame:Play("runaway")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

--"<35.57 16:56:12> [CHAT_MSG_RAID_BOSS_EMOTE] |TInterface\\Icons\\ABILITY_PRIEST_FLASHOFLIGHT.BLP:20|t Hyrja targets |cFFFF0000Wakmagic|r with |cFFFF0404|Hspell:228162|h[Shield of Light]|h|r!#Hyrja###Wakmagic##0#0##0#476#nil#0#false#false#false#false", -- [241]
function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, npc, _, _, target)
	if msg:find("spell:228162") then
		self.vb.shieldCast = self.vb.shieldCast + 1
		if self.vb.phase == 1 then
			if self:IsMythic() then
				local timer = shieldTimers[self.vb.shieldCast+1]
				if timer then
					timerShieldofLightCD:Start(timer, self.vb.shieldCast+1)
				end
			else
				if self.vb.shieldCast % 2 == 0 then
					timerShieldofLightCD:Start(38, self.vb.shieldCast+1)
				else
					timerShieldofLightCD:Start(32, self.vb.shieldCast+1)
				end
			end
		else
			timerShieldofLightCD:Start(25)
		end
		local targetname = DBM:GetUnitFullName(target)
		if targetname then
			if targetname == UnitName("player") then
				specWarnShieldofLight:Show()
				specWarnShieldofLight:Play("targetyou")
				yellShieldofLightFades:Schedule(2.8, 1)
				yellShieldofLightFades:Schedule(1.8, 2)
				yellShieldofLightFades:Schedule(0.8, 3)
			else
				warnShieldofLight:Show(self.vb.shieldCast, targetname)
			end
			if self.Options.SetIconOnShield then
				self:SetIcon(targetname, 1)
			end
		end
	--"<269.72 17:21:06> [CHAT_MSG_RAID_BOSS_EMOTE] |cFFFF0000Hyrja|r leaps back into battle!#Hyrja###Odyn##0#0##0#344#nil#0#false#false#false#false", -- [1538]
	elseif npc and target and target == L.name then--Odyn only target when it's a leap into battle.
		if npc == hyrja then
			self.vb.shieldCast = 0
			specWarnHyrja:Show()
			specWarnHyrja:Play("bigmob")
			timerExpelLightCD:Start(4.7)
			timerShieldofLightCD:Start(9.7)
			if self:IsMythic() then
				timerHymdallCD:Start(64)
			elseif self:IsHeroic() then
				timerHymdallCD:Start(67)
			end
		elseif npc == hymdall then
			self.vb.hornCast = 0
			specWarnHymall:Show()
			specWarnHymall:Play("bigmob")
			timerDancingBladeCD:Start(5)
			timerHornOfValorCD:Start(9.5, 1)
			if self:IsMythic() then
				timerHyrjaCD:Start(67)
			elseif self:IsHeroic() then
				timerHyrjaCD:Start(70)
			end
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	--"<51.36 16:56:28> [UNIT_SPELLCAST_SUCCEEDED] Odyn(??) [[boss1:Draw Power::3-3198-1648-10280-227503-000A6050FC:227503]]", -- [376]
	if spellId == 227503 or spellId == 229576 then--Draw Power
		timerDrawPower:Start()
		if self:IsEasy() then
			timerDrawPowerCD:Start(75)--LFR phase 2 verified. Might still be 70 in heroic though. no logs long enough for phase 2
		elseif self:IsMythic() then
			timerDrawPowerCD:Start(65)--65 in phase 1, 66 in phase 2 but i'm ok with using 65 for both for now
		else
			timerDrawPowerCD:Start()
		end
		--if self.vb.phase == 2 then
		--	timerSpearCD:Stop()
		--	timerSpearCD:Start(35)
		--end
	--"<150.12 16:58:07> [UNIT_SPELLCAST_SUCCEEDED] Odyn(??) [[boss1:Test for Players::3-3198-1648-10280-229168-000660515F:229168]]", -- [1347]
	--"<156.10 16:58:13> [UNIT_SPELLCAST_SUCCEEDED] Odyn(??) [[boss1:Leap into Battle::3-3198-1648-10280-227882-0001605165:227882]]", -- [1382]
	--"<159.34 16:58:16> [UNIT_SPELLCAST_SUCCEEDED] Odyn(??) [[boss1:Spear Transition - Holy::3-3198-1648-10280-228734-0004E05168:228734]]", -- [1395]
	elseif spellId == 231297 then--Phase 3 mythic runic Brand
		self.vb.brandActive = true
		timerRadiantSmite:Start()
		timerRunicBrandCD:Start()
	elseif spellId == 229168 then--Test for Players (Phase 1 end)
		warnPhase2:Show()
		self.vb.hornCast = 0--Verify
		self.vb.shieldCast = 0--Verify
		self.vb.expelLightCast = 0--Verify
		self.vb.dancingBladeCast = 0--Verify
		timerDancingBladeCD:Stop()
		timerHornOfValorCD:Stop()
		timerExpelLightCD:Stop()
		timerShieldofLightCD:Stop()
		timerDrawPowerCD:Stop()
		timerDrawPower:Stop()
		timerSpearCD:Start(13)
		if self:IsEasy() then
			timerDrawPowerCD:Start(53)
		elseif self:IsMythic() then
			timerDrawPowerCD:Start(45)
		else
			timerDrawPowerCD:Start(48)
		end
		--Timers above started in earliest possible place
		--Timer started at jump though has to be delayed to avoid phase 1 ClearAllDebuffs events
		if self.Options.InfoFrame then
			DBM.InfoFrame:Hide()
		end
	elseif spellId == 227882 then--Jump into Battle (phase 2 begin)
		self.vb.phase = 2
		if not self:IsEasy() then
			timerHyrjaCD:Start(16)
		end
	elseif spellId == 34098 and self.vb.phase == 2 then--ClearAllDebuffs (any of bosses leaving)
		local cid = self:GetUnitCreatureId(uId)
		if cid == 114361 then--Hymdall
			timerDancingBladeCD:Stop()
			timerHornOfValorCD:Stop()
		elseif cid == 114360 then--Hyrja
			timerExpelLightCD:Stop()
			timerShieldofLightCD:Stop()
		end
	elseif spellId == 227697 then--Spear of Light
		if self:IsMythic() then
			timerSpearCD:Start(7)
		else
			timerSpearCD:Start()
		end
		specWarnShatterSpears:Show()
		specWarnShatterSpears:Play("watchorb")
	--"<487.37 21:38:02> [CHAT_MSG_MONSTER_YELL] It seems I have been too gentle. Have at thee!#Odyn#####0#0##0#191#nil#0#false#false#false#false", -- [2839]
	--"<489.60 21:38:04> [UNIT_SPELLCAST_SUCCEEDED] Odyn(??) [[boss1:Spear Transition - Thunder::3-2012-1648-3815-228740-00058AC2FC:228740]]", -- [2940]
	--"<489.60 21:38:04> [UNIT_SPELLCAST_SUCCEEDED] Odyn(??) [[boss1:Arcing Storm::3-2012-1648-3815-229254-00060AC2FC:229254]]", -- [2941]
	elseif spellId == 228740 then--Spear Transition - Thunder (Phase 3 begin)
		self.vb.phase = 3
		timerHymdallCD:Stop()
		timerHyrjaCD:Stop()
		timerDrawPower:Stop()
		timerDrawPowerCD:Stop()
		warnPhase3:Show()
		timerStormOfJusticeCD:Start(4)
		timerStormforgedSpearCD:Start(9)
		if self:IsMythic() then
			timerRunicBrandCD:Start(21)
		end
	end
end
