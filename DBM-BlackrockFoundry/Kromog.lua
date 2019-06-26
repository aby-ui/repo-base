local mod	= DBM:NewMod(1162, "DBM-BlackrockFoundry", nil, 457)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143352")
mod:SetCreatureID(77692)
mod:SetEncounterID(1713)
mod:SetZone()
mod.respawnTime = 29.5

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 157060 157054 156704 157592 158217",
	"SPELL_CAST_SUCCESS 158130 170469",
	"SPELL_AURA_APPLIED 156766 161923 173917 156852 157059 156861",
	"SPELL_AURA_APPLIED_DOSE 156766"
)

--Expression:  (ability.id = 157060 or ability.id = 158217) and type = "begincast" or ability.id = 173917 and type = "applybuff"
--TODO, FUCK this fight and it's timers. It's impossible to make them correct in all cases. they are just FAR too god damn variable
--https://www.warcraftlogs.com/reports/rHwKLVfXPQCYBcvW#fight=3&view=events&pins=2%24Off%24%23244F4B%24expression%24(ability.id+%3D+157060+or+ability.id+%3D+158217)+and+type+%3D+%22begincast%22+or+ability.id+%3D+173917+and+type+%3D+%22applybuff%22
--https://www.warcraftlogs.com/reports/W3Z9mzCvYADkfyG6#fight=27&view=events&pins=2%24Off%24%23244F4B%24expression%24(ability.id+%3D+157060+or+ability.id+%3D+158217)+and+type+%3D+%22begincast%22+or+ability.id+%3D+173917+and+type+%3D+%22applybuff%22
--https://www.warcraftlogs.com/reports/kvpLjynmPgNMFJtB#fight=13&view=events&pins=2%24Off%24%23244F4B%24expression%24(ability.id+%3D+157060+or+ability.id+%3D+158217)+and+type+%3D+%22begincast%22+or+ability.id+%3D+173917+and+type+%3D+%22applybuff%22+
--https://www.warcraftlogs.com/reports/dPLkxbZpCQj7R3D2#fight=8&view=events&pins=2%24Off%24%23244F4B%24expression%24(ability.id+%3D+157060+or+ability.id+%3D+158217)+and+type+%3D+%22begincast%22+or+ability.id+%3D+173917+and+type+%3D+%22applybuff%22
--https://www.warcraftlogs.com/reports/tyV24fQzhNnKjbDk#pins=2%24Off%24%23244F4B%24expression%24+(ability.id+%3D+157060+or+ability.id+%3D+158217)+and+type+%3D+%22begincast%22+or+ability.id+%3D+173917+and+type+%3D+%22applybuff%22&view=events&fight=6
--Even more variations I don't have off hand. Basically because the cds are variable, and the two abilities delay eachother, it's a roulette and toss up what the fuck is even gonna happen from pull to pull.
--I still hold I at least try to get a lot closer than BW does which has even more wrong timers. However, it's IMPOSSIBLE to ever get them correct without the damn wow source code
local warnCrushingEarth				= mod:NewTargetAnnounce(161923, 3, nil, false)--Players who failed to move. Off by default since announcing failures is not something DBM generally does by default. Can't announce pre cast unfortunately. No detection
local warnStoneGeyser				= mod:NewSpellAnnounce(158130, 2)
local warnWarpedArmor				= mod:NewStackAnnounce(156766, 2, nil, "Tank")
local warnFrenzy					= mod:NewSpellAnnounce(156861, 3)

local specWarnGraspingEarth			= mod:NewSpecialWarningMoveTo(157060, nil, DBM_CORE_AUTO_SPEC_WARN_OPTIONS.spell:format(157060), nil, nil, 2)
local specWarnThunderingBlows		= mod:NewSpecialWarningSpell(157054, nil, nil, nil, 3)
local specWarnRipplingSmash			= mod:NewSpecialWarningDodge(157592, nil, nil, nil, 2, 2)
local specWarnStoneBreath			= mod:NewSpecialWarningCount(156852, nil, nil, nil, 2, 2)
local specWarnSlam					= mod:NewSpecialWarningDefensive(156704, "Tank", nil, nil, 1, 2)
local specWarnWarpedArmor			= mod:NewSpecialWarningStack(156766, nil, 2)
local specWarnWarpedArmorOther		= mod:NewSpecialWarningTaunt(156766)
local specWarnTremblingEarth		= mod:NewSpecialWarningCount(173917, nil, nil, nil, 2)
local specWarnCalloftheMountain		= mod:NewSpecialWarningCount(158217, nil, nil, nil, 3, 2)

local timerGraspingEarthCD			= mod:NewCDTimer(114, 157060, nil, nil, nil, 6)--Unless see new logs on normal showing it can still be 111, raising to 115, average i saw was 116-119
local timerThunderingBlowsCD		= mod:NewNextTimer(12, 157054, nil, nil, nil, 2, nil, DBM_CORE_DEADLY_ICON, nil, 1, 4)
local timerRipplingSmashCD			= mod:NewCDTimer(21, 157592, nil, nil, nil, 3)--If it comes off CD early enough into ThunderingBlows/Grasping Earth, he skips a cast. Else, he'll cast it very soon after.
local timerStoneBreathCD			= mod:NewCDCountTimer(22, 156852, nil, nil, nil, 2, nil, DBM_CORE_HEALER_ICON)
local timerSlamCD					= mod:NewCDTimer(23, 156704, nil, "Tank", nil, 5, nil, DBM_CORE_TANK_ICON)
local timerWarpedArmorCD			= mod:NewCDTimer(14, 156766, nil, "Tank", nil, 5, nil, DBM_CORE_TANK_ICON)
local timerTremblingEarthCD			= mod:NewCDTimer(153.5, 173917, nil, nil, nil, 6)
local timerTremblingEarth			= mod:NewBuffActiveTimer(25, 173917, nil, nil, nil, 6, nil, nil, nil, 2, 4)
local timerCalloftheMountain		= mod:NewCastTimer(5, 158217, nil, nil, nil, 2, nil, DBM_CORE_DEADLY_ICON)

local berserkTimer					= mod:NewBerserkTimer(540)

mod.vb.mountainCast = 0
mod.vb.stoneBreath = 0
mod.vb.tremblingCast = 0
mod.vb.frenzied = false

function mod:OnCombatStart(delay)
	self.vb.mountainCast = 0
	self.vb.stoneBreath = 0
	self.vb.frenzied = false
	timerStoneBreathCD:Start(8-delay, 1)--8-10
	timerWarpedArmorCD:Start(15-delay)
	timerSlamCD:Start(14.5-delay)--first can be 14.5-26. Most of time it's 18-20
	timerRipplingSmashCD:Start(23.5-delay)
	timerGraspingEarthCD:Start(50-delay)--50-61 variable
	berserkTimer:Start(-delay)
	if self:IsMythic() then
		--Confirmed multiple pulls, ability IS 61 seconds after engage, but 9 times out of 10, delayed by the 50-61 variable cd that's on grasping earth, thus why it APPEARS to have 84-101 second timer most of time.
		timerTremblingEarthCD:Start(61-delay)
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 157060 then
		specWarnGraspingEarth:Show(RUNES)
		timerStoneBreathCD:Stop()
		if self:IsLFR() then
			timerThunderingBlowsCD:Start(20.5)
			timerStoneBreathCD:Start(28, self.vb.stoneBreath+1)
		else
			timerThunderingBlowsCD:Start()
			timerStoneBreathCD:Start(31, self.vb.stoneBreath+1)--Verified it happens on mythic, if rune of trembling earth doesn't come first
		end
		timerSlamCD:Stop()
		timerRipplingSmashCD:Stop()
		timerWarpedArmorCD:Stop()
		specWarnGraspingEarth:Play("157060")
		if self:IsMythic() then
			timerGraspingEarthCD:Start(66)
			local remaining = timerTremblingEarthCD:GetRemaining()
			if remaining < 32 then
				DBM:Debug("Trembling earth CD extended by Grasping Earth")
				timerTremblingEarthCD:Stop()
				timerTremblingEarthCD:Start(32)
			end
		else
			timerGraspingEarthCD:Start()
			timerRipplingSmashCD:Start(35)
		end
	elseif spellId == 157054 then
		specWarnThunderingBlows:Show()
		--Hide rune arrow and hud at this point, if thundering is being cast, runes vanished
		self:RuneOver()
		--Starting timers for slam and rippling seem useless, 10-30 sec variation for first ones.
		--after that they get back into their consistency
	elseif spellId == 157592 then
		specWarnRipplingSmash:Show()
		if self.vb.frenzied then
			timerRipplingSmashCD:Start(18.2)
		else
			timerRipplingSmashCD:Start()
		end
		specWarnRipplingSmash:Play("shockwave")
	elseif spellId == 156704 then
		specWarnSlam:Show()
		specWarnSlam:Play("defensive")
		timerSlamCD:Start()
	elseif spellId == 158217 then
		self.vb.mountainCast = self.vb.mountainCast + 1
		specWarnCalloftheMountain:Show(self.vb.mountainCast)
		timerCalloftheMountain:Start()
		specWarnCalloftheMountain:Play("findshelter")
		if self.vb.mountainCast == 3 then--Start timers for resume normal phase
			timerStoneBreathCD:Start(8.7, self.vb.stoneBreath+1)--Or 12
			timerWarpedArmorCD:Start(12.2)--12.2-17
			--First slam and first rippling still too variable to start here.
			--after that they get back into their consistency
			--Rippling smash is WILDLY variable on mythic, to point that any timer for it is completely useless
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 158130 or spellId == 170469 then--Are both used? eliminate one that isn't if not
		warnStoneGeyser:Show()
		--Does it need a special warning?
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 156766 then
		local amount = args.amount or 1
		if self.vb.frenzied then
			timerWarpedArmorCD:Start(10.2)
		else
			timerWarpedArmorCD:Start()
		end
		if amount >= 2 then
			if args:IsPlayer() then
				specWarnWarpedArmor:Show(amount)
			else--Taunt as soon as stacks are clear, regardless of stack count.
				if not DBM:UnitDebuff("player", args.spellName) and not UnitIsDeadOrGhost("player") then
					specWarnWarpedArmorOther:Show(args.destName)
				else
					warnWarpedArmor:Show(args.destName, amount)
				end
			end
		else
			warnWarpedArmor:Show(args.destName, amount)
		end
	elseif spellId == 161923 then
		warnCrushingEarth:CombinedShow(0.5, args.destName)
	elseif spellId == 173917 then
		self.vb.mountainCast = 0
		self.vb.tremblingCast = self.vb.tremblingCast + 1
		specWarnTremblingEarth:Show(self.vb.tremblingCast)
		timerTremblingEarth:Start()
		timerSlamCD:Stop()
		timerRipplingSmashCD:Stop()
		timerWarpedArmorCD:Stop()
		timerStoneBreathCD:Stop()
		timerTremblingEarthCD:Schedule(25)
		local remaining = timerGraspingEarthCD:GetRemaining()
		if remaining < 50 then--Will come off cd during mythic phase, update timer because mythic phase is coded to prevent this from happening and will push ability to about 12-17 seconds after mythic phase ended
			DBM:Debug("Grasping earth CD extended by Trembling Earth")
			timerGraspingEarthCD:Stop()--Prevent timer debug from complaining
			timerGraspingEarthCD:Start(62)
		end
	elseif spellId == 156852 then
		self.vb.stoneBreath = self.vb.stoneBreath + 1
		specWarnStoneBreath:Show(self.vb.stoneBreath)
		timerStoneBreathCD:Start(nil, self.vb.stoneBreath+1)
		specWarnStoneBreath:Play("breathsoon")
	elseif spellId == 157059 and args:IsPlayer() then
		specWarnGraspingEarth:Play("safenow")
		self:RuneOver()
	elseif spellId == 156861 then
		self.vb.frenzied = true
		warnFrenzy:Show()
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED
