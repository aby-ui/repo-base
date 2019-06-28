local mod	= DBM:NewMod(687, "DBM-MogushanVaults", nil, 317)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143417")
mod:SetCreatureID(60701, 60708, 60709, 60710)--Adds: 60731 Undying Shadow, 60958 Pinning Arrow
mod:SetEncounterID(1436)
mod:SetZone()
mod:SetBossHPInfoToHighest()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 117539 117837 117756 117737 117697 118303 118135",
	"SPELL_AURA_REMOVED 118303",
	"SPELL_CAST_SUCCESS 117685 117506 117910",
	"SPELL_CAST_START 118162 117506 117628 117697 117833 117708 117948 117961",
	"SPELL_DAMAGE 117558 117921",
	"SPELL_MISSED 117558 117921",
	"UNIT_SPELLCAST_SUCCEEDED boss1 boss2 boss3 boss4",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"CHAT_MSG_MONSTER_YELL"
)

--on heroic 2 will be up at same time, so most announces are "target" type for source distinction.
--Unless it's a spell that doesn't directly affect the boss (ie summoning an add isn't applied to boss, it's a new mob).
--Zian
local warnChargedShadows		= mod:NewTargetAnnounce(117685, 2)
local warnUndyingShadows		= mod:NewSpellAnnounce(117506, 3)--Target scanning?
local warnFixate				= mod:NewTargetAnnounce(118303, 4)--Maybe spammy late fight, if zian is first boss you get? (adds are immortal, could be many up)
local warnShieldOfDarknessSoon	= mod:NewAnnounce("DarknessSoon", 4, 117697, nil, nil, true)
local warnShieldOfDarkness		= mod:NewTargetAnnounce(117697, 4)
--Meng
local warnCrazyThought			= mod:NewCastAnnounce(117833, 2, nil, nil, false)--Just doesn't seem all that important right now.
local warnMaddeningShout		= mod:NewSpellAnnounce(117708, 4)
local warnCrazed				= mod:NewTargetAnnounce(117737, 3)--Basically stance change
local warnCowardice				= mod:NewTargetAnnounce(117756, 3)--^^
local warnDelirious				= mod:NewTargetAnnounce(117837, 4, nil, "RemoveEnrage|Tank")--Heroic Ability
--Qiang
local warnAnnihilate			= mod:NewCastAnnounce(117948, 4)
local warnFlankingOrders		= mod:NewSpellAnnounce(117910, 4)
local warnImperviousShieldSoon	= mod:NewPreWarnAnnounce(117961, 5, 3)--Less dangerous than Shield of darkness, doesn't need as much spam
local warnImperviousShield		= mod:NewTargetAnnounce(117961, 4)--Heroic Ability
--Subetai
local warnVolley				= mod:NewSpellAnnounce(118094, 3)--118088 trigger ID, but we use the other ID cause it has a tooltip/icon
local warnPinnedDown			= mod:NewTargetAnnounce(118135, 4)--We warn for this one since it's more informative then warning for just Rain of Arrows
local warnPillage				= mod:NewTargetAnnounce(118047, 3)
local warnSleightOfHand			= mod:NewTargetAnnounce(118162, 4)--Heroic Ability
--All
local warnActivated				= mod:NewTargetAnnounce(118212, 3, 78740)

--Zian
local specWarnUndyingShadow		= mod:NewSpecialWarningSwitch("ej5854", "Dps")
local specWarnFixate			= mod:NewSpecialWarningRun(118303, nil, nil, nil, 4)
local yellFixate				= mod:NewYell(118303)
local specWarnCoalescingShadows	= mod:NewSpecialWarningMove(117558)
local specWarnShadowBlast		= mod:NewSpecialWarningInterrupt(117628, false)--very spammy. better to optional use
local specWarnShieldOfDarkness	= mod:NewSpecialWarningTarget(117697, nil, nil, nil, 3)--Heroic Ability
local specWarnShieldOfDarknessD	= mod:NewSpecialWarningDispel(117697, "MagicDispeller")--Heroic Ability
--Meng
local specWarnMaddeningShout	= mod:NewSpecialWarningSpell(117708, nil, nil, nil, 2)
local specWarnCrazyThought		= mod:NewSpecialWarningInterrupt(117833, false)--At discretion of whoever to enable. depending on strat, you may NOT want to interrupt these (or at least not all of them)
local specWarnDelirious			= mod:NewSpecialWarningDispel(117837, "RemoveEnrage|Tank")--Heroic Ability
--Qiang
local specWarnAnnihilate		= mod:NewSpecialWarningSpell(117948)--Maybe tweak options later or add a bool for it, cause on heroic, it's not likely ranged will be in front of Qiang if Zian or Subetai are up.
local specWarnFlankingOrders	= mod:NewSpecialWarningSpell(117910, nil, nil, nil, 2)
local specWarnImperviousShield	= mod:NewSpecialWarningTarget(117961)--Heroic Ability
--Subetai
local specWarnVolley			= mod:NewSpecialWarningSpell(118094, nil, nil, nil, 2)
local specWarnPinningArrow		= mod:NewSpecialWarningSwitch("ej5861", "Dps")
local specWarnPillage			= mod:NewSpecialWarningMove(118047)--Works as both a You and near warning
local specWarnSleightOfHand		= mod:NewSpecialWarningTarget(118162)--Heroic Ability

--Zian
local timerChargingShadowsCD	= mod:NewCDTimer(12, 117685)
local timerUndyingShadowsCD		= mod:NewCDTimer(41.5, 117506, nil, nil, nil, 1)--For most part it's right, but i also think on normal he can only summon a limited amount cause he did seem to skip one? leaving a CD for now until know for sure.
local timerFixate			  	= mod:NewTargetTimer(20, 118303)
local timerUSRevive				= mod:NewTimer(60, "timerUSRevive", 117539, nil, nil, 1)
local timerShieldOfDarknessCD  	= mod:NewNextTimer(42.5, 117697, nil, nil, nil, 5, nil, nil, nil, 3, 4)
--Meng
local timerMaddeningShoutCD		= mod:NewCDTimer(47, 117708, nil, nil, nil, 3)--47-50 sec variation. So a CD timer instead of next.
local timerDeliriousCD			= mod:NewCDTimer(20.5, 117837, nil, "RemoveEnrage", nil, 5)
--Qiang
local timerMassiveAttackCD		= mod:NewCDTimer(5, 117921)--This timer needed for all players to figure out Flanking Orders moves.
local timerAnnihilateCD			= mod:NewNextTimer(39, 117948, nil, nil, nil, 3)
local timerFlankingOrdersCD		= mod:NewCDTimer(40, 117910)--Every 40 seconds on normal, but on heroic it has a 40-50 second variation so has to be a CD bar instead of next
local timerImperviousShieldCD	= mod:NewCDTimer(42, 117961, nil, nil, nil, 5, nil, nil, nil, 1, 4)
--Subetai
local timerVolleyCD				= mod:NewNextTimer(41, 118094, nil, nil, nil, 3)
local timerRainOfArrowsCD		= mod:NewTimer(50.5, "timerRainOfArrowsCD", 118122, nil, nil, 3)--heroic 41s fixed cd. normal and lfr 50.5~60.5 variable cd.
local timerPillageCD			= mod:NewNextTimer(41, 118047)
local timerSleightOfHandCD		= mod:NewCDTimer(42, 118162)
local timerSleightOfHand		= mod:NewBuffActiveTimer(11, 118162)--2+9 (cast+duration)

local berserkTimer				= mod:NewBerserkTimer(600)

mod:AddBoolOption("RangeFrame", "Ranged")--For multiple abilities. the abiliies don't seem to target melee (unless a ranged is too close or a melee is too far.)

local Zian = DBM:EJ_GetSectionInfo(5852)
local Meng = DBM:EJ_GetSectionInfo(5835)
local Qiang = DBM:EJ_GetSectionInfo(5841)
local Subetai = DBM:EJ_GetSectionInfo(5846)
local rainTimerText = DBM_CORE_AUTO_TIMER_TEXTS.cd:format(DBM:GetSpellInfo(118122))
local bossesActivated = {}
local zianActive = false
local mengActive = false
local qiangActive = false
local subetaiActive = false
local pinnedTargets = {}
local diedShadow = {}

local function warnPinnedDownTargets()
	warnPinnedDown:Show(table.concat(pinnedTargets, "<, >"))
	specWarnPinningArrow:Show()
	table.wipe(pinnedTargets)
end

function mod:OnCombatStart(delay)
	table.wipe(bossesActivated)
	table.wipe(pinnedTargets)
	table.wipe(diedShadow)
	zianActive = false
	mengActive = false
	subetaiActive = false
	qiangActive = true
	berserkTimer:Start(-delay)
	timerAnnihilateCD:Start(10.5)
	timerFlankingOrdersCD:Start(25)
	if self:IsHeroic() then
		rainTimerText = DBM_CORE_AUTO_TIMER_TEXTS.next:format(DBM:GetSpellInfo(118122))
		timerImperviousShieldCD:Start(40.7)
		warnImperviousShieldSoon:Schedule(35.7)
	else
		rainTimerText = DBM_CORE_AUTO_TIMER_TEXTS.cd:format(DBM:GetSpellInfo(118122))
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 117539 and not diedShadow[args.destGUID] then--They only ressurrect once so only start timer once per GUID
		diedShadow[args.destGUID] = true
		timerUSRevive:Start(args.destGUID)--Basically, the rez timer for a defeated Undying Shadow that is going to re-animate in 60 seconds.
	elseif spellId == 117837 then
		warnDelirious:Show(args.destName)
		specWarnDelirious:Show(args.destName)
		timerDeliriousCD:Start()
	elseif spellId == 117756 then
		warnCowardice:Show(args.destName)
	elseif spellId == 117737 then
		warnCrazed:Show(args.destName)
	elseif spellId == 117697 then
		specWarnShieldOfDarknessD:Show(args.destName)
	elseif spellId == 118303 then
		warnFixate:Show(args.destName)
		timerFixate:Start(args.destName)
		if args:IsPlayer() then
			specWarnFixate:Show()
			yellFixate:Yell()
		end
	elseif spellId == 118135 then
		pinnedTargets[#pinnedTargets + 1] = args.destName
		self:Unschedule(warnPinnedDownTargets)
		self:Schedule(0.3, warnPinnedDownTargets)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 118303 then
		timerFixate:Cancel(args.destName)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 117685 then
		warnChargedShadows:Show(args.destName)
		timerChargingShadowsCD:Start()
	elseif spellId == 117506 then
		warnUndyingShadows:Show()
		if zianActive then
			timerUndyingShadowsCD:Start()
		else
			timerUndyingShadowsCD:Start(85)
		end
	elseif spellId == 117910 then
		warnFlankingOrders:Show()
		specWarnFlankingOrders:Show()
		if qiangActive then
			timerFlankingOrdersCD:Start()
		else
			timerFlankingOrdersCD:Start(75)
		end
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 118162 then
		warnSleightOfHand:Show(args.sourceName)
		specWarnSleightOfHand:Show(args.sourceName)
		timerSleightOfHand:Start()
		timerSleightOfHandCD:Start()
	elseif spellId == 117506 then
		warnUndyingShadows:Show()
		timerUndyingShadowsCD:Start()
	elseif spellId == 117628 then
		specWarnShadowBlast:Show(args.sourceName)
	elseif spellId == 117697 then
		warnShieldOfDarkness:Show(args.sourceName)
		specWarnShieldOfDarkness:Show(args.sourceName)
		warnShieldOfDarknessSoon:Schedule(37.5, 5)--Start pre warning with regular warnings only as you don't move at this point yet.
		warnShieldOfDarknessSoon:Schedule(38.5, 4)
		warnShieldOfDarknessSoon:Schedule(39.5, 3)
		warnShieldOfDarknessSoon:Schedule(40.5, 2)
		warnShieldOfDarknessSoon:Schedule(41.5, 1)
		timerShieldOfDarknessCD:Start()
	elseif spellId == 117833 then
		warnCrazyThought:Show()
		specWarnCrazyThought:Show(args.sourceName)
	elseif spellId == 117708 then
		warnMaddeningShout:Show()
		specWarnMaddeningShout:Show()
		if mengActive then
			timerMaddeningShoutCD:Start()
		else
			timerMaddeningShoutCD:Start(77)
		end
	elseif spellId == 117948 then
		warnAnnihilate:Show()
		specWarnAnnihilate:Show()
		if self:IsHeroic() then
			timerAnnihilateCD:Start(32.5)
		else
			timerAnnihilateCD:Start()
		end
	elseif spellId == 117961 then
		warnImperviousShield:Show(args.sourceName)
		specWarnImperviousShield:Show(args.sourceName)
		timerImperviousShieldCD:Start()
		if self:IsDifficulty("heroic10") then--Is this still different?
			warnImperviousShieldSoon:Schedule(57)
			timerImperviousShieldCD:Start(62)
		else
			warnImperviousShieldSoon:Schedule(37)
			timerImperviousShieldCD:Start()
		end
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 117558 and destGUID == UnitGUID("player") and self:AntiSpam(3, 4) then
		specWarnCoalescingShadows:Show()
	elseif spellId == 117921 and self:AntiSpam(3, 5) then
		timerMassiveAttackCD:Start()
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 118088 and self:AntiSpam(2, 1) then--Volley
		warnVolley:Show()
		specWarnVolley:Show()
		timerVolleyCD:Start()
	elseif spellId == 118121 and self:AntiSpam(2, 2) then--Rain of Arrows
		if self:IsHeroic() then
			timerRainOfArrowsCD:Start(41, rainTimerText)
		else
			timerRainOfArrowsCD:Start(nil, rainTimerText)
		end
--	"<63.5 21:23:16> [UNIT_SPELLCAST_SUCCEEDED] Qiang the Merciless [[boss1:Inactive Visual::0:118205]]", -- [14066]
--	"<63.5 21:23:16> [UNIT_SPELLCAST_SUCCEEDED] Qiang the Merciless [[boss1:Cancel Activation::0:118219]]", -- [14068]
	elseif spellId == 118205 and self:AntiSpam(2, 3) then--Inactive Visual
		if UnitName(uId) == Zian then
			zianActive = false
			timerChargingShadowsCD:Cancel()
			timerShieldOfDarknessCD:Cancel()
			warnShieldOfDarknessSoon:Cancel()
			timerUndyingShadowsCD:Start(30)--This boss retains Undying Shadows
			if self.Options.RangeFrame and not subetaiActive then--Close range frame, but only if zian is also not active, otherwise we still need it
				DBM.RangeCheck:Hide()
			end
		elseif UnitName(uId) == Meng then
			mengActive = false
			timerDeliriousCD:Cancel()
			timerMaddeningShoutCD:Start(30)--This boss retains Maddening Shout
		elseif UnitName(uId) == Qiang then
			qiangActive = false
			timerMassiveAttackCD:Cancel()
			timerAnnihilateCD:Cancel()
			timerImperviousShieldCD:Cancel()
			warnImperviousShieldSoon:Cancel()
			timerFlankingOrdersCD:Start(30)--This boss retains Flanking Orders
		elseif UnitName(uId) == Subetai then
			subetaiActive = false
			timerVolleyCD:Cancel()
			timerRainOfArrowsCD:Cancel()
			timerSleightOfHandCD:Cancel()
			timerPillageCD:Start(30)--This boss retains Pillage
			if self.Options.RangeFrame and not zianActive then--Close range frame, but only if subetai is also not active, otherwise we still need it
				DBM.RangeCheck:Hide()
			end
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, _, _, _, target)
	if msg:find("spell:118047") then
		local target = DBM:GetUnitFullName(target)
		if subetaiActive then
			timerPillageCD:Start()
		else
			timerPillageCD:Start(75)
		end
		if target then
			warnPillage:Show(target)
			if target == UnitName("player") then
				specWarnPillage:Show()
			else
				local uId = DBM:GetRaidUnitId(target)
				if uId then
					local inRange = DBM.RangeCheck:GetDistance("player", uId)
					if inRange and inRange < 9 then
						specWarnPillage:Show()
					end
				end
			end
		end
	end
end

--Phase change controller. Even for pull.
function mod:CHAT_MSG_MONSTER_YELL(msg, boss)
	if not self:IsInCombat() or bossesActivated[boss] then return end--Ignore yells out of combat or from bosses we already activated.
	if not bossesActivated[boss] then bossesActivated[boss] = true end--Once we activate off bosses first yell, add them to ignore.
	if boss == Zian then
		warnActivated:Show(boss)
		zianActive = true
		timerChargingShadowsCD:Start()
		timerUndyingShadowsCD:Start(20)
		if self:IsHeroic() then
			warnShieldOfDarknessSoon:Schedule(35, 5)--Start pre warning with regular warnings only as you don't move at this point yet.
			warnShieldOfDarknessSoon:Schedule(36, 4)
			warnShieldOfDarknessSoon:Schedule(37, 3)
			warnShieldOfDarknessSoon:Schedule(38, 2)
			warnShieldOfDarknessSoon:Schedule(39, 1)
			timerShieldOfDarknessCD:Start(40)
		end
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(8)
		end
	elseif boss == Meng then
		warnActivated:Show(boss)
		mengActive = true
		if self:IsHeroic() then
			timerDeliriousCD:Start()
			timerMaddeningShoutCD:Start(40)--On heroic, he skips first cast as a failsafe unless you manage to kill it within 20 seconds. otherwise, first cast will actually be after about 40-45 seconds. Since this is VERY hard to do right now, lets just automatically skip it for now. Maybe find a better way to fix it later if it becomes a problem this expansion
		else
			timerMaddeningShoutCD:Start(20.5)
		end
	elseif boss == Qiang then
		warnActivated:Show(boss)
	elseif boss == Subetai then
		warnActivated:Show(boss)
		subetaiActive = true
		timerVolleyCD:Start(5)
		timerPillageCD:Start(25)
		if self:IsHeroic() then
			timerSleightOfHandCD:Start(40.7)
			timerRainOfArrowsCD:Start(40, rainTimerText)
		else
			timerRainOfArrowsCD:Start(15, rainTimerText)
		end
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(8)
		end
	end
end
