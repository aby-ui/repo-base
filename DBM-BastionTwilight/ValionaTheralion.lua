local mod	= DBM:NewMod(157, "DBM-BastionTwilight", nil, 72)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143316")
mod:SetCreatureID(45992, 45993)
mod:SetEncounterID(1032)
mod:SetZone()
mod:SetUsedIcons(6, 7, 8)
--mod:SetModelSound("Sound\\Creature\\Chogall\\VO_BT_Chogall_BotEvent10.ogg", "Sound\\Creature\\Valiona\\VO_BT_Valiona_Event06.ogg")
--Long: Valiona, Theralion put them in their place!
--Short: Enter twilight!

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REFRESH",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START",
	"SPELL_DAMAGE",
	"SPELL_MISSED",
	"SPELL_HEAL",
	"SPELL_PERIODIC_HEAL",
	"RAID_BOSS_EMOTE",
	"UNIT_AURA player",
	"UNIT_SPELLCAST_SUCCEEDED boss1 boss2"
)

--Valiona Ground Phase
local warnBlackout					= mod:NewTargetAnnounce(86788, 3)
local warnDevouringFlames			= mod:NewSpellAnnounce(86840, 3)
local warnDazzlingDestruction		= mod:NewCountAnnounce(86408, 4)--Used by Theralion just before landing
--Theralion Ground Phase
local warnFabFlames					= mod:NewTargetAnnounce(86505, 3)
local warnEngulfingMagic			= mod:NewTargetAnnounce(86622, 3)
local warnDeepBreath				= mod:NewCountAnnounce(86059, 4)--Used by Valiona just before landing

local warnTwilightShift				= mod:NewStackAnnounce(93051, 2)

--Valiona Ground Phase
local specWarnDevouringFlames		= mod:NewSpecialWarningSpell(86840, nil, nil, nil, 2)
local specWarnDazzlingDestruction	= mod:NewSpecialWarningSpell(86408, nil, nil, nil, 2)
local specWarnBlackout				= mod:NewSpecialWarningYou(86788)
mod:AddBoolOption("TBwarnWhileBlackout", false, "announce")
local specWarnTwilightBlast			= mod:NewSpecialWarningMove(86369, false)
local specWarnTwilightBlastNear		= mod:NewSpecialWarningClose(86369, false)
local yellTwilightBlast				= mod:NewYell(86369, nil, false)
--Theralion Ground Phase
local specWarnDeepBreath			= mod:NewSpecialWarningSpell(86059, nil, nil, nil, 2)
local specWarnFabulousFlames		= mod:NewSpecialWarningMove(86505)
local specWarnFabulousFlamesNear	= mod:NewSpecialWarningClose(86505)
local yellFabFlames					= mod:NewYell(86505)
local specWarnTwilightMeteorite		= mod:NewSpecialWarningYou(88518)
local yellTwilightMeteorite			= mod:NewYell(88518, nil, false)
local specWarnEngulfingMagic		= mod:NewSpecialWarningMoveAway(86622, nil, nil, nil, 3)
local yellEngulfingMagic			= mod:NewYell(86622)

local specWarnTwilightZone			= mod:NewSpecialWarningStack(86214, nil, 20)

--Valiona Ground Phase
local timerBlackout					= mod:NewTargetTimer(15, 86788, nil, nil, nil, 5, nil, DBM_CORE_MAGIC_ICON..DBM_CORE_HEALER_ICON)
local timerBlackoutCD				= mod:NewCDTimer(45.5, 86788, nil, nil, nil, 3, nil, DBM_CORE_MAGIC_ICON..DBM_CORE_DEADLY_ICON)
local timerDevouringFlamesCD		= mod:NewCDTimer(40, 86840, nil, nil, nil, 3)
local timerNextDazzlingDestruction	= mod:NewNextTimer(132, 86408, nil, nil, nil, 3)
--Theralion Ground Phase
local timerTwilightMeteorite		= mod:NewCastTimer(6, 86013)		
local timerEngulfingMagic			= mod:NewBuffFadesTimer(20, 86622)
local timerEngulfingMagicNext		= mod:NewCDTimer(35, 86622, nil, nil, nil, 3)--30-40 second variations.
local timerNextFabFlames			= mod:NewNextTimer(15, 86505, nil, nil, nil, 3)
local timerNextDeepBreath			= mod:NewNextTimer(98, 86059, nil, nil, nil, 3)

local timerTwilightShift			= mod:NewTargetTimer(100, 93051, nil, "Tank", 2, 5, nil, DBM_CORE_TANK_ICON)
local timerTwilightShiftCD			= mod:NewCDTimer(20, 93051, nil, "Tank", 2, 5, nil, DBM_CORE_TANK_ICON)

local berserkTimer					= mod:NewBerserkTimer(600)

mod:AddBoolOption("TwilightBlastArrow", false)
mod:AddBoolOption("BlackoutIcon")
mod:AddBoolOption("EngulfingIcon")
mod:AddBoolOption("RangeFrame")
mod:AddInfoFrameOption(86788, true)

mod.vb.blackoutCount = 0
local engulfingMagicTargets = {}
local engulfingMagicIcon = 7
local dazzlingCast = 0
local breathCast = 0
local lastFab = 0--Leave this custom one, we use reset gettime on it in extra places and that cannot be done with prototype
local markWarned = false
local ValionaLanded = false
local meteorTarget, fabFlames = DBM:GetSpellInfo(88518), DBM:GetSpellInfo(86497)

local function showEngulfingMagicWarning()
	warnEngulfingMagic:Show(table.concat(engulfingMagicTargets, "<, >"))
	timerEngulfingMagic:Start()
	table.wipe(engulfingMagicTargets)
	engulfingMagicIcon = 7
end

local function markRemoved()
	markWarned = false
end

local function valionaDelay()
	timerEngulfingMagicNext:Cancel()
	timerBlackoutCD:Start(10)
	timerDevouringFlamesCD:Start(25)
	if mod.Options.RangeFrame then
		DBM.RangeCheck:Show(8)
	end
end

local function theralionDelay()
	timerDevouringFlamesCD:Cancel()
	timerBlackoutCD:Cancel()
	timerNextFabFlames:Start(10)
	timerEngulfingMagicNext:Start(15)
	timerNextDeepBreath:Start()
	ValionaLanded = false
	if mod.Options.RangeFrame then
		DBM.RangeCheck:Show(10)
	end
end

local function AMSTimerDelay()
	timerTwilightShiftCD:Start()
end

function mod:FabFlamesTarget()
	local targetname, uId = self:GetBossTarget(45993)
	if not targetname then return end
	warnFabFlames:Show(targetname)
	if targetname == UnitName("player") then
		specWarnFabulousFlames:Show()
		yellFabFlames:Yell()
		lastFab = GetTime()--Trigger the anti spam here so when we pre warn it thrown at them we don't double warn them again for taking 1 tick of it when it lands.
	else
		if uId then
			local inRange = DBM.RangeCheck:GetDistance("player", uId)
			if inRange and inRange < 11 then--What's exact radius of this circle?
				specWarnFabulousFlamesNear:Show(targetname)
			end
		end
	end
end

function mod:TwilightBlastTarget()
	local targetname = self:GetBossTarget(45993)
	if not targetname then return end
	if self.Options.TBwarnWhileBlackout or self.vb.blackoutCount == 0 then
		if targetname == UnitName("player") then
			specWarnTwilightBlast:Show()
			yellTwilightBlast:Yell()
		else
			local uId = DBM:GetRaidUnitId(targetname)
			if uId then
				local inRange = DBM.RangeCheck:GetDistance("player", uId)
				if inRange and inRange < 9 then
					specWarnTwilightBlastNear:Show(targetname)
					if self.Options.TwilightBlastArrow then
						local x, y = UnitPosition(uId)
						DBM.Arrow:ShowRunAway(x, y, 8, 5)
					end
				end
			end
		end
	end
end

function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
	timerBlackoutCD:Start(10-delay)
	timerDevouringFlamesCD:Start(25.5-delay)
	timerNextDazzlingDestruction:Start(85-delay)
	self.vb.blackoutCount = 0
	dazzlingCast = 0
	breathCast = 0
	lastFab = 0
	markWarned = false
	ValionaLanded = true
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(8)
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 86788 then
		self.vb.blackoutCount = self.vb.blackoutCount + 1
		warnBlackout:Show(args.destName)
		timerBlackout:Start(args.destName)
		timerBlackoutCD:Start()
		if self.Options.BlackoutIcon then
			self:SetIcon(args.destName, 8)
		end
		if args:IsPlayer() then
			specWarnBlackout:Show()
		end
		if self.Options.InfoFrame and not DBM.InfoFrame:IsShown() then
			DBM.InfoFrame:SetHeader(args.spellName)
			DBM.InfoFrame:Show(6, "playerabsorb", args.spellName, select(16, DBM:UnitDebuff(args.destName, args.spellName)))
		end
	elseif args.spellId == 86622 then
		engulfingMagicTargets[#engulfingMagicTargets + 1] = args.destName
		timerEngulfingMagicNext:Start()
		if args:IsPlayer() then
			specWarnEngulfingMagic:Show()
			yellEngulfingMagic:Yell()
		end
		if self.Options.EngulfingIcon then
			self:SetIcon(args.destName, engulfingMagicIcon)
			engulfingMagicIcon = engulfingMagicIcon - 1
		end
		self:Unschedule(showEngulfingMagicWarning)
		if (self:IsDifficulty("heroic25") and #engulfingMagicTargets >= 3) or (self:IsDifficulty("normal25", "heroic10") and #engulfingMagicTargets >= 2) or (self:IsDifficulty("normal10") and #engulfingMagicTargets >= 1) then
			showEngulfingMagicWarning()
		else
			self:Schedule(0.3, showEngulfingMagicWarning)
		end
	elseif args.spellId == 93051 then
		warnTwilightShift:Show(args.destName, args.amount or 1)
		timerTwilightShift:Cancel(args.destName.." (1)")
		timerTwilightShift:Cancel(args.destName.." (2)")
		timerTwilightShift:Cancel(args.destName.." (3)")
		timerTwilightShift:Cancel(args.destName.." (4)")
		timerTwilightShift:Cancel(args.destName.." (5)")
		timerTwilightShift:Show(args.destName.." ("..tostring(args.amount or 1)..")")
		timerTwilightShiftCD:Start()
		self:Unschedule(AMSTimerDelay)
		self:Schedule(20, AMSTimerDelay)--Cause when a DK AMSes it we don't get another timer.
	elseif args.spellId == 86214 and args:IsPlayer() then
		if (args.amount or 1) >= 20 and self:AntiSpam(5, 1) then
			specWarnTwilightZone:Show(args.amount)
		end
	end
end

mod.SPELL_AURA_REFRESH = mod.SPELL_AURA_APPLIED

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 86788 then
		self.vb.blackoutCount = self.vb.blackoutCount - 1
		if self.Options.InfoFrame and self.vb.blackoutCount == 0 then
			DBM.InfoFrame:Hide()
		end
		timerBlackout:Cancel(args.destName)
		if self.Options.BlackoutIcon then
			self:SetIcon(args.destName, 0)
		end
	elseif args.spellId == 86622 then
		if self.Options.EngulfingIcon then
			self:SetIcon(args.destName, 0)
		end
	elseif args.spellId == 93051 then
		timerTwilightShift:Cancel(args.destName.." (1)")
		timerTwilightShift:Cancel(args.destName.." (2)")
		timerTwilightShift:Cancel(args.destName.." (3)")
		timerTwilightShift:Cancel(args.destName.." (4)")
		timerTwilightShift:Cancel(args.destName.." (5)")
	end
end	

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(86840, 90950) then--Strange to have 2 cast ids instead of either 1 or 4
		warnDevouringFlames:Show()
		timerDevouringFlamesCD:Start()
		specWarnDevouringFlames:Show()
	elseif args.spellId == 86408 then
		dazzlingCast = dazzlingCast + 1
		warnDazzlingDestruction:Show(dazzlingCast)
		if dazzlingCast == 1 then
			specWarnDazzlingDestruction:Show()
		elseif dazzlingCast == 3 then
			self:Schedule(5, theralionDelay)--delayed so we don't cancel blackout timer until after 3rd cast.
			dazzlingCast = 0
		end
	elseif args.spellId == 86369 then--First cast of this is true phase change, as theralion can still cast his grounded phase abilities until he's fully in air casting this instead.
		self:ScheduleMethod(0.1, "TwilightBlastTarget")
		if not ValionaLanded then
			timerNextFabFlames:Cancel()
			ValionaLanded = true
		end
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 86505 and destGUID == UnitGUID("player") and GetTime() - lastFab > 3 then
		specWarnFabulousFlames:Show()
		lastFab = GetTime()
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE--Absorbs still show as spell missed, such as PWS, but with this you'll still get a special warning to GTFO, instead of dbm waiting til your shield breaks and you take a second tick :)

function mod:RAID_BOSS_EMOTE(msg)
	if msg == L.Trigger1 or msg:find(L.Trigger1) then
		breathCast = breathCast + 1
		warnDeepBreath:Show(breathCast)
		if breathCast == 1 then
			timerNextDeepBreath:Cancel()
			specWarnDeepBreath:Show()
			timerNextDazzlingDestruction:Start()
			self:Schedule(40, valionaDelay)--We do this cause you get at least one more engulfing magic after this emote before they completely switch so we need a method to cancel bar more appropriately
		elseif breathCast == 3 then
			breathCast = 0
		end
	end
end

function mod:UNIT_AURA(uId)
	if DBM:UnitDebuff("player", meteorTarget) and not markWarned then
		specWarnTwilightMeteorite:Show()
		timerTwilightMeteorite:Start()
		yellTwilightMeteorite:Yell()
		markWarned = true
		self:Schedule(7, markRemoved)
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	local spellName = DBM:GetSpellInfo(spellId)--Shit workaround, fix
	if spellName == fabFlames and not ValionaLanded and self:AntiSpam(2, 2) then
		self:ScheduleMethod(0.1, "FabFlamesTarget")
		timerNextFabFlames:Start()
		lastFab = GetTime()
	end
end
