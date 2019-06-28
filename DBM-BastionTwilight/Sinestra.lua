local mod	= DBM:NewMod(168, "DBM-BastionTwilight", nil, 72)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143316")
mod:SetCreatureID(45213)
mod:SetEncounterID(1082, 1083)--Muiti encounter id. need to verify.
mod:SetZone()
mod:SetUsedIcons(1, 2, 3, 4, 5, 6, 7, 8)
--mod:SetModelSound("Sound\\Creature\\Sinestra\\VO_BT_Sinestra_Aggro01.ogg", "Sound\\Creature\\Sinestra\\VO_BT_Sinestra_Kill02.ogg")
--Long: We were fools to entrust an imbecile like Cho'gall with such a sacred duty! I will deal with you intruders myself!
--Short: Powerless....

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"CHAT_MSG_MONSTER_YELL",
	"SPELL_DAMAGE",
	"SPELL_MISSED",
	"UNIT_DIED"
)
mod.onlyHeroic = true

local warnBreath			= mod:NewSpellAnnounce(90125, 3)
local warnOrbSoon			= mod:NewAnnounce("WarnOrbSoon", 3, 92852, true, nil, true)--Still on by default but no longer plays it's own sounds
local warnOrbs				= mod:NewAnnounce("warnAggro", 4, 92852)
local warnWrack				= mod:NewTargetAnnounce(89421, 4)
local warnWrackJump			= mod:NewAnnounce("warnWrackJump", 3, 89421, false)--Not spammy at all (unless you're dispellers are retarded and make it spammy). Useful for a raid leader to coordinate quicker, especially on 10 man with low wiggle room.
local warnDragon			= mod:NewSpellAnnounce("ej3231", 3, 69002)
local warnPhase2			= mod:NewPhaseAnnounce(2)
local warnExtinction		= mod:NewSpellAnnounce(86227, 4)
local warnPhase3			= mod:NewPhaseAnnounce(3, 2)
local warnRedEssence		= mod:NewSpellAnnounce(87946, 3)

local specWarnOrbs			= mod:NewSpecialWarning("SpecWarnOrbs", nil, nil, nil, true)
local specWarnOrbOnYou		= mod:NewSpecialWarning("SpecWarnAggroOnYou")
local specWarnBreath		= mod:NewSpecialWarningSpell(90125, false, nil, nil, true)
local specWarnEggShield		= mod:NewSpecialWarningSpell(87654, "Ranged")
local specWarnEggWeaken		= mod:NewSpecialWarningSwitch("ej3238", "Ranged")
local specWarnIndomitable	= mod:NewSpecialWarningDispel(90045, "RemoveEnrage")

local timerBreathCD			= mod:NewCDTimer(21, 90125, nil, nil, nil, 2)
local timerOrbs				= mod:NewTimer(28, "TimerOrbs", 92852, nil, nil, 3, DBM_CORE_DEADLY_ICON, nil, 1, 4)
local timerWrack			= mod:NewNextTimer(61, 89421, nil, "Healer", nil, 5, nil, DBM_CORE_HEALER_ICON)
local timerExtinction		= mod:NewCastTimer(16, 86227)
local timerEggWeakening		= mod:NewTimer(4, "TimerEggWeakening", 61357)
local timerEggWeaken		= mod:NewTimer(30, "TimerEggWeaken", 61357, nil, nil, 5, DBM_CORE_DAMAGE_ICON)
local timerDragon			= mod:NewNextTimer(50, "ej3231", nil, nil, nil, 1, 69002)
local timerRedEssenceCD		= mod:NewNextTimer(22, 87946)--21-23 seconds after red egg dies
local timerRedEssence		= mod:NewBuffFadesTimer(180, 87946)

mod:AddBoolOption("SetIconOnOrbs", true)
mod:AddBoolOption("InfoFrame", false)--Does not filter tanks. not putting ugly hack in info frame, its simpley an aggro tracker

local eggDown = 0
local eggRemoved = false
local orbList = {}
local orbWarned = nil
local playerWarned = nil
local wrackName = DBM:GetSpellInfo(89421)
local wrackTargets = {}

local function resetPlayerOrbStatus()
	orbWarned = nil
	playerWarned = nil
end

local function isTank(unit)
	-- 1. check blizzard tanks first
	-- 2. check blizzard roles second
	-- 3. anyone with Sinestra Aggro
	if GetPartyAssignment("MAINTANK", unit, 1) then
		return true
	end
	if UnitGroupRolesAssigned(unit) == "TANK" then
		return true
	end
	if UnitIsUnit("boss1target", unit) then return true end
	return false
end

local function showOrbWarning(source)
	table.wipe(orbList)
	mod:Unschedule(showOrbWarning)
	if not IsInGroup() then--Solo, always orb target
		playerWarned = true
		specWarnOrbOnYou:Show()
		return
	end
	local _, _, difficulty = GetInstanceInfo()
	for i = 1, DBM:GetNumGroupMembers() do
		-- do some checks for 25/10 man raid size so we don't warn for ppl who are not in the instance
		if difficulty == 5 and i > 10 then return end
		if difficulty == 6 and i > 25 then return end
		local n = GetRaidRosterInfo(i)
		-- Has aggro on something, but not a tank
		if n and UnitThreatSituation(n) == 3 and not isTank(n) then
			orbList[#orbList + 1] = n
			if UnitIsUnit(n, "player") and not playerWarned then
				playerWarned = true
				specWarnOrbOnYou:Show()
			end
		end
	end
	if source == "spawn" then
		if #orbList >= 2 then--only warn for 2 or more.
			warnOrbs:Show(table.concat(orbList, "<, >"))
			-- if we could guess orb targets lets wipe the orb list in 5 sec
			-- if not then we might as well just save them for next time
			if mod.Options.SetIconOnOrbs then
				mod:ClearIcons()
				if orbList[1] then mod:SetIcon(orbList[1], 8) end
				if orbList[2] then mod:SetIcon(orbList[2], 7) end
				if orbList[3] then mod:SetIcon(orbList[3], 6) end
				if orbList[4] then mod:SetIcon(orbList[4], 5) end
				if orbList[5] then mod:SetIcon(orbList[5], 4) end
				if orbList[6] then mod:SetIcon(orbList[6], 3) end
				if orbList[7] then mod:SetIcon(orbList[7], 2) end
				if orbList[8] then mod:SetIcon(orbList[8], 1) end
			end
		else
			mod:Schedule(0.5, showOrbWarning, "spawn")--check again soon since we didn't have 2 yet.
		end
	elseif source == "damage" then--Orbs are damaging people, they are without a doubt targeting 2 players by now, although may still have others with aggro :\
		warnOrbs:Show(table.concat(orbList, "<, >"))
		mod:Schedule(10, resetPlayerOrbStatus)
		if mod.Options.SetIconOnOrbs then
			mod:ClearIcons()
			if orbList[1] then mod:SetIcon(orbList[1], 8) end
			if orbList[2] then mod:SetIcon(orbList[2], 7) end
			if orbList[3] then mod:SetIcon(orbList[3], 6) end
			if orbList[4] then mod:SetIcon(orbList[4], 5) end
			if orbList[5] then mod:SetIcon(orbList[5], 4) end
			if orbList[6] then mod:SetIcon(orbList[6], 3) end
			if orbList[7] then mod:SetIcon(orbList[7], 2) end
			if orbList[8] then mod:SetIcon(orbList[8], 1) end
		end
	end
end

function mod:OrbsRepeat()
	resetPlayerOrbStatus()
	timerOrbs:Start()
	if self.Options.WarnOrbSoon then
		warnOrbSoon:Schedule(23, 5)
		warnOrbSoon:Schedule(24, 4)
		warnOrbSoon:Schedule(25, 3)
		warnOrbSoon:Schedule(26, 2)
		warnOrbSoon:Schedule(27, 1)
	end
	specWarnOrbs:Show()--generic aoe warning on spawn, before we have actual targets yet.
	if self:IsInCombat() then
		self:ScheduleMethod(28, "OrbsRepeat")
		self:Schedule(0.5, showOrbWarning, "spawn")--Start spawn checks
	end
end

local function showWrackWarning()
	warnWrackJump:Show(wrackName, table.concat(wrackTargets, "<, >"))
	table.wipe(wrackTargets)
end

function mod:OnCombatStart(delay)
	eggDown = 0
	eggRemoved = false
	timerDragon:Start(16-delay)
	timerBreathCD:Start(21-delay)
	timerOrbs:Start(29-delay)
	table.wipe(orbList)
	orbWarned = nil
	playerWarned = nil
	table.wipe(wrackTargets)
	if self.Options.WarnOrbSoon then
		warnOrbSoon:Schedule(24-delay, 5)
		warnOrbSoon:Schedule(25-delay, 4)
		warnOrbSoon:Schedule(26-delay, 3)
		warnOrbSoon:Schedule(27-delay, 2)
		warnOrbSoon:Schedule(28-delay, 1)
	end
	self:ScheduleMethod(29-delay, "OrbsRepeat")
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(L.HasAggro)
		DBM.InfoFrame:Show(6, "playeraggro", 3)
	end
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 90125 then
		warnBreath:Show()
		specWarnBreath:Show()
		timerBreathCD:Start()
	elseif args.spellId == 86227 then
		warnExtinction:Show()
		timerExtinction:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 90045 then
		specWarnIndomitable:Show()
	elseif args.spellId == 89421 then--Cast wracks (10,25)
		warnWrack:Show(args.destName)
		timerWrack:Start()
	elseif args.spellId == 89435 then -- jumped wracks (10,25)
		wrackTargets[#wrackTargets + 1] = args.destName
		self:Unschedule(showWrackWarning)
		self:Schedule(0.3, showWrackWarning)
	elseif args.spellId == 87299 then
		eggDown = 0
		warnPhase2:Show()
		timerBreathCD:Cancel()
		timerOrbs:Cancel()
		if self.Options.WarnOrbSoon then
			warnOrbSoon:Cancel()
		end
		self:UnscheduleMethod("OrbsRepeat")
		if self.Options.SetIconOnOrbs then
			self:ClearIcons()
		end
	elseif args.spellId == 87654 then
		if self:AntiSpam(3) then
			timerDragon:Cancel()
			if eggRemoved then
				specWarnEggShield:Show()
			end
		end
	elseif args.spellId == 87946 and args:IsNPC() then--NPC check just simplifies it cause he gains the buff too, before he dies, less local variables this way.
		warnRedEssence:Show()
		timerRedEssence:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 87654 and self:AntiSpam(3) then
		timerEggWeaken:Show()
		specWarnEggWeaken:Show()
		eggRemoved = true
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, _, _, _, _, spellId)
	if spellId == 92852 and not orbWarned then
		orbWarned = true
		showOrbWarning("damage")
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellDragon or msg:find(L.YellDragon) then
		warnDragon:Show()
		timerDragon:Start()
	elseif msg == L.YellEgg or msg:find(L.YellEgg) then
		timerEggWeakening:Start()
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 46842 then
		eggDown = eggDown + 1
		if eggDown >= 2 then
			timerEggWeaken:Cancel()
			warnPhase3:Show()
			timerBreathCD:Start()
			timerOrbs:Start(30)
			timerDragon:Start()
			timerRedEssenceCD:Start()
			if self.Options.WarnOrbSoon then
				warnOrbSoon:Cancel()
				warnOrbSoon:Schedule(25, 5)
				warnOrbSoon:Schedule(26, 4)
				warnOrbSoon:Schedule(27, 3)
				warnOrbSoon:Schedule(28, 2)
				warnOrbSoon:Schedule(29, 1)
			end
			self:UnscheduleMethod("OrbsRepeat")
			self:ScheduleMethod(30, "OrbsRepeat")
		end
	end
end
