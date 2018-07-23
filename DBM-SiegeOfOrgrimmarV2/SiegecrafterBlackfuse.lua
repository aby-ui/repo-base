local mod	= DBM:NewMod(865, "DBM-SiegeOfOrgrimmarV2", nil, 369)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 111 $"):sub(12, -3))
mod:SetCreatureID(71504)--71591 Automated Shredder
mod:SetEncounterID(1601)
mod:SetZone()
mod:SetUsedIcons(8, 7, 6, 5, 4, 3, 2, 1)--More mines than ew can give icons to on 25 man. it uses all 8 and then runs out on heroic :\

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 143265 144208",
	"SPELL_CAST_SUCCESS 145774 143385",
	"SPELL_SUMMON 143641",
	"SPELL_AURA_APPLIED 145365 143385 145444 144210 144236 145269 145580 144466 143856",
	"SPELL_AURA_APPLIED_DOSE 143385 145444 143856",
	"SPELL_AURA_REFRESH 143385",
	"SPELL_AURA_REMOVED 143385 144236 145269",
	"UNIT_DIED",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"RAID_BOSS_WHISPER"
)

--Siegecrafter Blackfuse
local warnLaunchSawblade				= mod:NewTargetAnnounce(143265, 3)
local warnElectroStaticCharge			= mod:NewStackAnnounce(143385, 2, nil, "Tank")
--Automated Shredders
local warnAutomatedShredder				= mod:NewCountAnnounce("ej8199", 3, 85914)
local warnOverload						= mod:NewStackAnnounce(145444, 3)
local warnDeathFromAbove				= mod:NewTargetAnnounce(144208, 4)--Player target, not vulnerable shredder target. (should always be cast on highest threat target, but i like it still being a "target" warning)
--The Assembly Line
local warnAssemblyLine					= mod:NewCountAnnounce("ej8202", 3, 85914, "Dps")
local warnInactive						= mod:NewTargetAnnounce(138089, 1)
local warnLaserFixate					= mod:NewTargetAnnounce(143828, 3, 143867)
local warnReadyToGo						= mod:NewTargetAnnounce(145580, 4)--Crawler mine not dead fast enough

--Siegecrafter Blackfuse
local specWarnLaunchSawblade			= mod:NewSpecialWarningYou(143265)
local yellLaunchSawblade				= mod:NewYell(143265)
local specWarnProtectiveFrenzy			= mod:NewSpecialWarningTarget(145365, "Tank")
local specWarnOvercharge				= mod:NewSpecialWarningTarget(145774)
--Automated Shredders
local specWarnAutomatedShredder			= mod:NewSpecialWarningCount("ej8199", "Tank")--No sense in dps switching when spawn, has damage reduction. This for tank pickup
local specWarnDeathFromAbove			= mod:NewSpecialWarningYou(144208)
local specWarnDeathFromAboveNear		= mod:NewSpecialWarningClose(144208)
local specWarnAutomatedShredderSwitch	= mod:NewSpecialWarningSwitch("ej8199", false)--Strat dependant, you may just ignore them and have tank kill them with laser pools
--The Assembly Line
local specWarnCrawlerMine				= mod:NewSpecialWarningSwitch("ej8212", "-Healer")
local specWarnAssemblyLine				= mod:NewSpecialWarningCount("ej8202", false)--Not all in raid need, just those assigned
local specWarnShockwaveMissile			= mod:NewSpecialWarningSpell(143641, nil, nil, nil, 2)
local specWarnReadyToGo					= mod:NewSpecialWarningTarget(145580)
local specWarnLaserFixate				= mod:NewSpecialWarningRun(143828, nil, nil, 2, 4)
local yellLaserFixate					= mod:NewYell(143828)
local specWarnSuperheated				= mod:NewSpecialWarningMove(143856)--From lasers. Hard to see, this warning will help a ton
local specWarnMagneticCrush				= mod:NewSpecialWarningSpell(144466, nil, nil, nil, 2)
local specWarnCrawlerMineFixate			= mod:NewSpecialWarningRun("ej8212", "Melee", nil, 2, 4)
local yellCrawlerMineFixate				= mod:NewYell("ej8212", nil, false)

--Siegecrafter Blackfuse
local timerProtectiveFrenzy				= mod:NewBuffActiveTimer(10, 145365, nil, false, nil, nil, nil, nil, nil, 2)
local timerElectroStaticCharge			= mod:NewTargetTimer(60, 143385, nil, "Tank")
local timerElectroStaticChargeCD		= mod:NewCDTimer(17, 143385, nil, "Tank", nil, 5, nil, DBM_CORE_TANK_ICON)--17-22 second variation
local timerLaunchSawbladeCD				= mod:NewCDTimer(10, 143265, nil, nil, nil, 3)--10-15sec cd
--Automated Shredders
local timerAutomatedShredderCD			= mod:NewNextTimer(60, "ej8199", nil, "Tank", nil, 1, 85914, DBM_CORE_TANK_ICON)
local timerOverloadCD					= mod:NewCDCountTimer(10, 145444, nil, nil, nil, 2, nil, DBM_CORE_HEALER_ICON)
local timerDeathFromAboveDebuff			= mod:NewTargetTimer(5, 144210, nil, "-Healer")
local timerDeathFromAboveCD				= mod:NewNextTimer(40, 144208, nil, "-Healer")
--The Assembly Line
local timerAssemblyLineCD				= mod:NewNextCountTimer(40, "ej8202", nil, "Dps", nil, 5, 59193, DBM_CORE_DAMAGE_ICON)
local timerPatternRecognition			= mod:NewBuffFadesTimer(60, 144236, nil, false)
local timerLaserFixate					= mod:NewBuffFadesTimer(15, 143828)
local timerBreakinPeriod				= mod:NewTargetTimer(60, 145269, nil, false)--Many mines can be up at once so timer off by default do to spam
local timerMagneticCrush				= mod:NewBuffActiveTimer(30, 144466)

local countdownAssemblyLine				= mod:NewCountdown(40, "ej8202", false)
local countdownShredder					= mod:NewCountdown(60, "ej8199", "Tank")
local countdownElectroStatic			= mod:NewCountdown("Alt17", 143385, "Tank")

mod:AddInfoFrameOption("ej8202")
mod:AddSetIconOption("SetIconOnMines", "ej8212", false, true)
mod:AddSetIconOption("SetIconOnlaserFixate", 143828, false)
mod:AddSetIconOption("SetIconOnSawBlade", 143265, false)

--Upvales, don't need variables
--Names very long in english, makes frame HUGE, may switch to shorter localized names
local assemblyLine = DBM:EJ_GetSectionInfo(8202)
local crawlerMine = DBM:EJ_GetSectionInfo(8212)
local shockwaveMissile = DBM:EJ_GetSectionInfo(8205)
local laserTurret = DBM:EJ_GetSectionInfo(8208)
local electroMagnet = DBM:EJ_GetSectionInfo(8210)
local assemblyName = {
	[71606] = shockwaveMissile, -- Deactivated Missile Turret
	[71790] = crawlerMine, -- Disassembled Crawler Mines
	[71751] = laserTurret, -- Deactivated Laser Turret
	[71694] = electroMagnet, -- Deactivated Electromagnet
}

--Not important, don't need to recover
--Important, needs recover
mod.vb.shockwaveOvercharged = false
mod.vb.weapon = 0
mod.vb.shredderCount = 0

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
		table.wipe(lines)
		table.wipe(sortedLines)
		if mod.vb.weapon == 1 or mod.vb.weapon == 2 or mod.vb.weapon == 4 then
			addLine(shockwaveMissile, laserTurret.." , "..crawlerMine)
		elseif mod.vb.weapon == 3 then
			addLine(shockwaveMissile, laserTurret.." , "..electroMagnet)
		elseif mod.vb.weapon == 5 then
			addLine(shockwaveMissile, electroMagnet.." , "..crawlerMine)
		elseif mod.vb.weapon == 6 then
			addLine(crawlerMine, laserTurret.." , "..crawlerMine)
		elseif mod.vb.weapon == 7 then
			addLine(shockwaveMissile, laserTurret.." , "..crawlerMine)
		elseif mod.vb.weapon == 8 then
			addLine(shockwaveMissile, electroMagnet.." , "..crawlerMine)
		elseif mod.vb.weapon == 9 then
			addLine(laserTurret, crawlerMine.." , "..laserTurret)
		elseif mod.vb.weapon == 10 then
			addLine(shockwaveMissile, crawlerMine.." , "..laserTurret)
		elseif mod.vb.weapon == 11 then
			addLine(shockwaveMissile, electroMagnet.." , "..shockwaveMissile)
		elseif mod.vb.weapon == 12 then
			addLine(electroMagnet, crawlerMine.." , "..laserTurret)
		else
			addLine(_G["UNKNOWN"], "")
		end
		return lines, sortedLines
	end
end

function mod:LaunchSawBladeTarget(targetname, uId)
	warnLaunchSawblade:Show(targetname)
	if self.Options.SetIconOnSawBlade then
		self:SetIcon(targetname, 1, 3)
	end
end

--May be two up at once so can't use generic boss scanner.
function mod:DeathFromAboveTarget(sGUID)
	local targetname = nil
	for uId in DBM:GetGroupMembers() do
		if UnitGUID(uId.."target") == sGUID then
			targetname = DBM:GetUnitFullName(uId.."targettarget")
			break
		end
	end
	if not targetname then return end
	warnDeathFromAbove:Show(targetname)
	if targetname == UnitName("player") then
		specWarnDeathFromAbove:Show()
	elseif self:CheckNearby(10, targetname) then
		specWarnDeathFromAboveNear:Show(targetname)
	end
end

function mod:OnCombatStart(delay)
	self.vb.weapon = 0
	self.vb.shredderCount = 0
	self.vb.shockwaveOvercharged = false
	timerAutomatedShredderCD:Start(35-delay, 1)
	countdownShredder:Start(35-delay)
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 143265 then
		timerLaunchSawbladeCD:Start()
		self:BossTargetScanner(71504, "LaunchSawBladeTarget", 0.1, 16)
	elseif spellId == 144208 then
		timerDeathFromAboveCD:Start(args.sourceGUID)
		self:ScheduleMethod(0.2, "DeathFromAboveTarget", args.sourceGUID)--Always targets tank, so 1 scan all needed
		specWarnAutomatedShredderSwitch:Schedule(3)--Better here then when debuff goes up, give dps 2 seconds rampup time so spells in route when debuff goes up.
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 145774 then
		specWarnOvercharge:Show(args.destName)
		local cid = self:GetCIDFromGUID(args.destGUID)
		if cid == 71638 then
			self.vb.shockwaveOvercharged = true
		else
			self.vb.shockwaveOvercharged = false
		end
	elseif spellId == 143385 then
		timerElectroStaticChargeCD:Start()
		countdownElectroStatic:Start()
	end
end

function mod:SPELL_SUMMON(args)
	local spellId = args.spellId
	if spellId == 143641 then--Missile Launching
		specWarnShockwaveMissile:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 145365 then
		specWarnProtectiveFrenzy:Show(args.destName)
		timerProtectiveFrenzy:Start()
		for i = 1, 5 do
			if UnitExists("boss"..i) and UnitIsDead("boss"..i) then
				local cId = self:GetUnitCreatureId("boss"..i)
				if assemblyName[cId] then
					warnInactive:Show(assemblyName[cId])
				end
			end
		end
	elseif spellId == 143385 and args:IsDestTypePlayer() then
		local amount = args.amount or 1
		warnElectroStaticCharge:Show(args.destName, amount)
		timerElectroStaticCharge:Start(args.destName)
	elseif spellId == 145444 then
		local amount = args.amount or 1
		warnOverload:Show(args.destName, amount)
		timerOverloadCD:Start(nil, amount+1)
	elseif spellId == 144210 and not args:IsDestTypePlayer() then
		timerDeathFromAboveDebuff:Start(args.destName)
	elseif spellId == 144236 and args:IsPlayer() then
		timerPatternRecognition:Start()
	elseif spellId == 145269 then
		if self:AntiSpam(20, 3) then
			specWarnCrawlerMine:Show()
			if self.Options.SetIconOnMines then
				self:ScanForMobs(71788, 0, 8, nil, 0.1, 20)
			end
		end
		timerBreakinPeriod:Start(args.destName, args.destGUID)
	elseif spellId == 145580 then
		warnReadyToGo:Show(args.destName)
		specWarnReadyToGo:Show(args.destName)
	elseif spellId == 144466 and self:AntiSpam(35, 1) then--Only way i see to detect magnet activation, antispam is so it doesn't break if a player dies during it.
		specWarnMagneticCrush:Show()
		timerMagneticCrush:Start()
	elseif spellId == 143856 and args:IsPlayer() and self:AntiSpam(2, 2) then
		specWarnSuperheated:Show()
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REFRESH(args)
	local spellId = args.spellId
	if spellId == 143385 and args:IsDestTypePlayer() then
		local amount = args.amount or 1
		warnElectroStaticCharge:Show(args.destName, amount)
		timerElectroStaticCharge:Start(args.destName)
		timerElectroStaticChargeCD:Start()
		countdownElectroStatic:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 143385 then
		timerElectroStaticCharge:Cancel(args.destName)
	elseif spellId == 144236 and args:IsPlayer() then
		timerPatternRecognition:Cancel()
	elseif spellId == 145269 then
		timerBreakinPeriod:Cancel(args.destName, args.destGUID)
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 71591 then
		timerDeathFromAboveCD:Cancel(args.destGUID)
		timerOverloadCD:Cancel()
	end
end

function mod:RAID_BOSS_WHISPER(msg)
	if msg:find("spell:143266") then--Target scanning works on this one, but is about 1 second slower than emote. emote is .2 seconds after SPELL_CAST_START, but target scanning can't grab right target until like 1.0 or 1.2 sec into cast
		specWarnLaunchSawblade:Show()
		yellLaunchSawblade:Yell()
	--"<55.7 18:31:39> [RAID_BOSS_WHISPER] RAID_BOSS_WHISPER#|TInterface\\Icons\\Ability_Siege_Engineer_Detonate.blp:20|tA Crawler Mine has targeted you!#Crawler Mine#0#true", -- [4345]
	elseif msg:find("Ability_Siege_Engineer_Detonate") then--Doesn't show in combat log at all (what else is new)
		specWarnCrawlerMineFixate:Show()
		yellCrawlerMineFixate:Yell()
	elseif msg:find("Ability_Siege_Engineer_Superheated") then
		specWarnLaserFixate:Show()
		yellLaserFixate:Yell()
		timerLaserFixate:Start()
		self:SendSync("LockedOnTarget", UnitGUID("player"))
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, npc, _, _, target)
	if msg == L.newWeapons or msg:find(L.newWeapons) then
		self.vb.weapon = self.vb.weapon + 1
		warnAssemblyLine:Show(self.vb.weapon)
		specWarnAssemblyLine:Show(self.vb.weapon)
		timerAssemblyLineCD:Start(nil, self.vb.weapon + 1)
		countdownAssemblyLine:Start()
		if self.Options.InfoFrame then
			DBM.InfoFrame:SetHeader(assemblyLine.."("..self.vb.weapon..")")
			if not DBM.InfoFrame:IsShown() then
				DBM.InfoFrame:Show(1, "function", updateInfoFrame, false, false, true)
			else
				DBM.InfoFrame:Update()
			end
		end
	elseif msg == L.newShredder or msg:find(L.newShredder) then
		self.vb.shredderCount = self.vb.shredderCount + 1
		warnAutomatedShredder:Show(self.vb.shredderCount)
		specWarnAutomatedShredder:Show(self.vb.shredderCount)
		timerDeathFromAboveCD:Start(18)
		timerAutomatedShredderCD:Start(nil, self.vb.shredderCount+14)
		countdownShredder:Start()
	end
end

function mod:OnSync(msg, guid)
	if msg == "LockedOnTarget" and guid and self:IsInCombat() then
		local targetName = DBM:GetFullPlayerNameByGUID(guid)
		warnLaserFixate:Show(targetName)
		if self.Options.SetIconOnlaserFixate then
			self:SetIcon(targetName, 7, 6)--Maybe adjust timing or add smart code to remove right away if that target dies.
		end
	end
end
