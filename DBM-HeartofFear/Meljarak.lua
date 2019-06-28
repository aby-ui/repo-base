local mod	= DBM:NewMod(741, "DBM-HeartofFear", nil, 330)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143417")
mod:SetCreatureID(62397)
mod:SetEncounterID(1498)
mod:SetZone()
mod:SetUsedIcons(1, 2)

mod:RegisterCombat("combat")

-- CC can be cast before combat. So needs to seperate SPELL_AURA_APPLIED for pre-used CCs before combat.
mod:RegisterEvents(
	"SPELL_AURA_REFRESH 122224",
	"SPELL_AURA_APPLIED 122224",
	"SPELL_AURA_REMOVED 122224"
)

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 121881 122064 122055",
	"SPELL_AURA_REFRESH 121881 122064 122055",
	"SPELL_AURA_REMOVED 121885",
	"SPELL_CAST_START 122406 121876 122064 122193 122149",
	"SPELL_DAMAGE 131830 122125 122064 121898",
	"SPELL_MISSED 131830 122125 122064 121898",
	"SPELL_PERIODIC_DAMAGE 131830 122125 122064 121898",
	"SPELL_PERIODIC_MISSED 131830 122125 122064 121898",
	"UNIT_DIED",
	"UNIT_SPELLCAST_SUCCEEDED boos1",
	"UNIT_AURA_UNFILTERED"
)

local warnImpalingSpear					= mod:NewPreWarnAnnounce(122224, 10, 3)--Pre warn your CC is about to break. Maybe need to localize it later to better explain what option is for.
local warnAmberPrison					= mod:NewTargetAnnounce(121881, 3)
local warnCorrosiveResin				= mod:NewTargetAnnounce(122064, 3)
local warnMending						= mod:NewCastAnnounce(122193, 4)
local warnQuickening					= mod:NewTargetCountAnnounce(122149, 4)
local warnKorthikStrike					= mod:NewTargetAnnounce(123963, 3)
local warnWindBomb						= mod:NewTargetAnnounce(131830, 4)

local specWarnWhirlingBlade				= mod:NewSpecialWarningSpell(121896, nil, nil, nil, 2)
local specWarnRainOfBlades				= mod:NewSpecialWarningSpell(122406, nil, nil, nil, 2)
local specWarnRecklessness				= mod:NewSpecialWarningTarget(125873)
local specWarnAmberPrison				= mod:NewSpecialWarningYou(121881)
local yellAmberPrison					= mod:NewYell(121881)
local specWarnAmberPrisonOther			= mod:NewSpecialWarningSpell(121881, false)--Only people who are freeing these need to know this.
local specWarnCorrosiveResin			= mod:NewSpecialWarningRun(122064)
local yellCorrosiveResin				= mod:NewYell(122064, nil, false)
local specWarnCorrosiveResinPool		= mod:NewSpecialWarningMove(122125)
local specWarnMending					= mod:NewSpecialWarningInterrupt(122193)--Whoever is doing this or feels responsible should turn it on.
local specWarnQuickening				= mod:NewSpecialWarningCount(122149, "MagicDispeller")--This is not stack warning.
local specWarnKorthikStrike				= mod:NewSpecialWarningYou(123963)
local specWarnKorthikStrikeOther		= mod:NewSpecialWarningTarget(123963, "Healer")
local yellKorthikStrike					= mod:NewYell(123963)
local specWarnWindBomb					= mod:NewSpecialWarningMove(131830, nil, nil, nil, 3)
local specWarnWhirlingBladeMove			= mod:NewSpecialWarningMove(121898)
local yellWindBomb						= mod:NewYell(131830)
local specWarnReinforcements			= mod:NewSpecialWarningTarget("ej6554", "-Healer", "specWarnReinforcements")--Also important to dps. (Espcially CC classes)

local timerRainOfBladesCD				= mod:NewCDTimer(48, 122406, nil, nil, nil, 2)--48-64 sec variation now. so much for it being a precise timer.
local timerRainOfBlades					= mod:NewBuffActiveTimer(7.5, 122406)
local timerRecklessness					= mod:NewBuffActiveTimer(30, 125873, nil, nil, nil, 6)--Heroic recklessness
local timerReinforcementsCD				= mod:NewNextCountTimer(50, "ej6554", nil, nil, nil, 1)--EJ says it's 45 seconds after adds die but it's actually 50 in logs. EJ is not updated for current tuning.
local timerImpalingSpear				= mod:NewTargetTimer(50, 122224, nil, nil, nil, 5, nil, nil, nil, 1, 10)--Filtered to only show your own target, may change to a popup option later that lets you pick whether you show ALL of them or your own (all will be spammy)
local timerAmberPrisonCD				= mod:NewCDTimer(36, 121876, nil, false, nil, 5)--Reduce bar spam like Zarthik / each add has their own CD. This is on by default since it concerns everyone.
local timerCorrosiveResinCD				= mod:NewCDTimer(36, 122064, nil, false, nil, 5)--^^
local timerResidue						= mod:NewBuffFadesTimer(120, 122055)
local timerMendingCD					= mod:NewNextTimer(37, 122193, nil, false, nil, 4)--To reduce bar spam, only those dealing with this should turn CD bar on, off by default / 37~37.5 sec
local timerQuickeningCD					= mod:NewNextTimer(37.3, 122149, nil, false, nil, 5)--^^37.3~37.6sec.
local timerKorthikStrikeCD				= mod:NewCDTimer(50, 123963)--^^
local timerWindBombCD					= mod:NewCDTimer(6, 131830, nil, nil, nil, 3)--^^

local berserkTimer						= mod:NewBerserkTimer(480)

mod:AddBoolOption("AmberPrisonIcons", true)

local Reinforcement = DBM:EJ_GetSectionInfo(6554)
local strikeSpell = DBM:GetSpellInfo(123963)
local addsCount = 0
local amberPrisonIcon = 2
local zarthikCount = 0
local firstStriked = false
local strikeTarget = nil
local windBombTargets = {}
local zarthikGUIDS = {}

local function clearWindBombTargets()
	table.wipe(windBombTargets)
end

function mod:OnCombatStart(delay)
	addsCount = 0
	amberPrisonIcon = 2
	zarthikCount = 0
	firstStriked = false
	strikeTarget = nil
	table.wipe(windBombTargets)
	table.wipe(zarthikGUIDS)
	timerKorthikStrikeCD:Start(18-delay)
	timerRainOfBladesCD:Start(60-delay)
	if not self:IsDifficulty("lfr25") then
		berserkTimer:Start(-delay)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 122224 and args.sourceGUID == UnitGUID("player") then
		warnImpalingSpear:Cancel()
		warnImpalingSpear:Schedule(40)
		timerImpalingSpear:Start(args.destName)
	elseif spellId == 121881 then--Not a mistake, 121881 is targeting spellid.
		warnAmberPrison:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			specWarnAmberPrison:Show()
			if not self:IsDifficulty("lfr25") then
				yellAmberPrison:Yell()
			end
		else
			specWarnAmberPrisonOther:Show()
		end
		if self.Options.AmberPrisonIcons then
			self:SetIcon(args.destName, amberPrisonIcon)
			if amberPrisonIcon == 2 then
				amberPrisonIcon = 1
			else
				amberPrisonIcon = 2
			end
		end
	elseif spellId == 122064 then
		warnCorrosiveResin:Show(args.destName)
		if args:IsPlayer() and self:AntiSpam(3, 5) then
			specWarnCorrosiveResin:Show()
			yellCorrosiveResin:Yell()
		end
	elseif spellId == 122055 and args:IsPlayer() then
		local _, _, _, _, duration, expires = DBM:UnitDebuff("player", args.spellName)
		if expires then
			timerResidue:Start(expires-GetTime())
		end
	end
end
mod.SPELL_AURA_REFRESH = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 122224 and args.sourceGUID == UnitGUID("player") then
		warnImpalingSpear:Cancel()
		timerImpalingSpear:Cancel(args.destName)
	elseif spellId == 121885 and self.Options.AmberPrisonIcons then--Not a mistake, 121885 is frozon spellid
		self:SetIcon(args.destName, 0)
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 122406 then
		specWarnRainOfBlades:Show()
		timerRainOfBlades:Start()
		timerRainOfBladesCD:Start()
	elseif spellId == 121876 then
		timerAmberPrisonCD:Start(36, args.sourceGUID)
	elseif spellId == 122064 then
		timerCorrosiveResinCD:Start(36, args.sourceGUID)
	elseif spellId == 122193 then
		warnMending:Show()
		timerMendingCD:Start(nil, args.sourceGUID)
		if args.sourceGUID == UnitGUID("target") or args.sourceGUID == UnitGUID("focus") then
			specWarnMending:Show(args.sourceName)
		end
	elseif spellId == 122149 then
		if not zarthikGUIDS[args.sourceGUID] then
			zarthikCount = zarthikCount + 1
			zarthikGUIDS[args.sourceGUID] = zarthikCount
		end
		local count = zarthikGUIDS[args.sourceGUID] -- This is set counter for dispel(1, 2, 3, 1, 2, 3.. repeats). Especailly for mass dispel. Very useful for PRIEST. NO SPAM. DO NOT REMOVE THIS. 
		warnQuickening:Show(count, args.sourceName)
		specWarnQuickening:Show(count)
		timerQuickeningCD:Start(nil, args.sourceGUID)
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, destName, _, _, spellId)
	if spellId == 131830 and not windBombTargets[destGUID] then
		windBombTargets[destGUID] = true
		warnWindBomb:CombinedShow(0.5, destName)
		timerWindBombCD:Start()
		self:Unschedule(clearWindBombTargets)
		self:Schedule(0.3, clearWindBombTargets)
		if destGUID == UnitGUID("player") and self:AntiSpam(3, 3) then
			specWarnWindBomb:Show()
			if not self:IsDifficulty("lfr25") then
				yellWindBomb:Yell()
			end
		end
	elseif spellId == 122125 and destGUID == UnitGUID("player") and self:AntiSpam(3, 4) then
		specWarnCorrosiveResinPool:Show()
	elseif spellId == 122064 and destGUID == UnitGUID("player") and self:AntiSpam(3, 5) then
		specWarnCorrosiveResin:Show()
	elseif spellId == 121898 and destGUID == UnitGUID("player") and not self:IsDifficulty("lfr25") and self:AntiSpam(3, 6) then
		specWarnWhirlingBladeMove:Show()
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE
mod.SPELL_PERIODIC_DAMAGE = mod.SPELL_DAMAGE
mod.SPELL_PERIODIC_MISSED = mod.SPELL_DAMAGE

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 62405 then--Sra'thik Amber-Trapper
		timerAmberPrisonCD:Cancel(args.destGUID)
		timerCorrosiveResinCD:Cancel(args.destGUID)
	elseif cid == 62408 then--Zar'thik Battle-Mender
		timerMendingCD:Cancel(args.destGUID)
		timerQuickeningCD:Cancel(args.destGUID)
		zarthikCount = 0
		table.wipe(zarthikGUIDS)
	elseif cid == 62402 then--The Kor'thik
		timerKorthikStrikeCD:Cancel()--No need for GUID cancelation, this ability seems to be off a timed trigger and they all do it together, unlike other mob sets.
		if self:IsHeroic() then
			timerKorthikStrikeCD:Start(79)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 124850 and self:AntiSpam(2, 1) then--Whirling Blade (Throw Cast spellid)
		specWarnWhirlingBlade:Show()
	elseif spellId == 123963 and self:AntiSpam(2, 2) then--Kor'thik Strike Trigger, only triggered once, then all non CCed Kor'thik cast the strike about 2 sec later
		if firstStriked then--first Strike 32~33 sec cd. after 2nd strike 50~51 sec cd.
			timerKorthikStrikeCD:Start()
		else
			firstStriked = true
			timerKorthikStrikeCD:Start(32)
		end
	elseif spellId == 125873 then -- If adds die before Recklessness fades, CLEU not firing at all. To prevent fail, changes Recklessness check to UNIT_SPELLCAST_SUCCEEDED.
		local mobname = UnitName(uId)
		addsCount = addsCount + 1
		specWarnRecklessness:Show(L.name)
		timerRecklessness:Start()
		timerReinforcementsCD:Start(50, addsCount)--We count them cause some groups may elect to kill a 2nd group of adds and start a second bar to form before first ends.
		specWarnReinforcements:Schedule(50, mobname)
	end
end

function mod:UNIT_AURA_UNFILTERED(uId)
	if DBM:UnitDebuff(uId, strikeSpell) and not strikeTarget then
		strikeTarget = uId
		local name = DBM:GetUnitFullName(uId)
		warnKorthikStrike:Show(name)
		if name == UnitName("player") then
			specWarnKorthikStrike:Show()
			yellKorthikStrike:Yell()
		else
			specWarnKorthikStrikeOther:Show(name)
		end
	elseif strikeTarget and strikeTarget == uId and not DBM:UnitDebuff(uId, strikeSpell) then
		strikeTarget = nil
	end
end
