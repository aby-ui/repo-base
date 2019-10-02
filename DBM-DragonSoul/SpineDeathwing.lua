local mod	= DBM:NewMod(318, "DBM-DragonSoul", nil, 187)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190913151156")
mod:SetCreatureID(53879)
mod:SetEncounterID(1291)
mod:SetZone()
mod:SetUsedIcons(6, 5, 4, 3, 2, 1)
--mod:SetModelSound("sound\\CREATURE\\Deathwing\\VO_DS_DEATHWING_BACKEVENT_01.OGG", "sound\\CREATURE\\Deathwing\\VO_DS_DEATHWING_BACKSLAY_01.OGG")

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 105845 105847 105848 109379",
	"SPELL_CAST_SUCCESS 105219 105248",
	"SPELL_AURA_APPLIED 105248 105490 105479",
	"SPELL_AURA_APPLIED_DOSE 105248",
	"SPELL_AURA_REMOVED 105490 105479",
	"SPELL_DAMAGE",
	"SPELL_MISSED",
	"SWING_DAMAGE",
	"SWING_MISSED",
	"RAID_BOSS_EMOTE",
	"UNIT_DIED"
)

local warnAbsorbedBlood		= mod:NewStackAnnounce(105248, 2)
local warnResidue			= mod:NewCountAnnounce("ej4057", 3, nil, false)--This is HIGHLY inaccurate in 5.x, i do not know why right now. I'll actually log fight next week
local warnGrip				= mod:NewTargetAnnounce(105490, 4)
local warnNuclearBlast		= mod:NewCastAnnounce(105845, 4)
local warnSealArmor			= mod:NewAnnounce("warnSealArmor", 4, 105847)
local warnAmalgamation		= mod:NewSpellAnnounce("ej4054", 3, 106005)--Amalgamation spawning, give temp icon.

local specWarnRoll			= mod:NewSpecialWarningSpell("ej4050", nil, nil, nil, 2)--The actual roll
local specWarnTendril		= mod:NewSpecialWarning("SpecWarnTendril", nil, nil, nil, 3)--A personal warning for you only if you're not gripped 3 seconds after roll started
local specWarnGrip			= mod:NewSpecialWarningSpell(105490, "Dps")
local specWarnNuclearBlast	= mod:NewSpecialWarningRun(105845, "Melee", nil, nil, 4)
local specWarnSealArmor		= mod:NewSpecialWarningSpell(105847, "Dps")
local specWarnAmalgamation	= mod:NewSpecialWarningSpell("ej4054", false)

local timerSealArmor		= mod:NewCastTimer(23, 105847, nil, nil, nil, 6)
local timerBarrelRoll		= mod:NewCastTimer(5, "ej4050", nil, nil, nil, 2, nil, DBM_CORE_DEADLY_ICON, nil, 1, 3)
local timerGripCD			= mod:NewNextTimer(32, 105490, nil, nil, nil, 3)
local timerDeathCD			= mod:NewCDTimer(8.5, 106199, nil, nil, nil, 5)--8.5-10sec variation.

mod:AddBoolOption("InfoFrame", true)
mod:AddBoolOption("SetIconOnGrip", true)

mod.vb.shieldCount = 0
local sealArmorText = DBM_CORE_AUTO_ANNOUNCE_TEXTS.cast:format(DBM:GetSpellInfo(105847), 23)
local gripTargets = {}
local gripIcon = 6
local corruptionActive = {}
local residueNum = 0
local diedOozeGUIDS = {}
local numberOfPlayers = 1
local tendrilDebuff = DBM:GetSpellInfo(105563)

local function checkTendrils()
	if not DBM:UnitDebuff("player", tendrilDebuff) and not UnitIsDeadOrGhost("player") then
		specWarnTendril:Show()
	end
end

local function clearTendrils()
	if mod.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

local function showGripWarning()
	warnGrip:Show(table.concat(gripTargets, "<, >"))
	specWarnGrip:Show()
	table.wipe(gripTargets)
end

local function warningResidue()
	if residueNum >= 0 then -- (better to warn 0 on heroic)
		warnResidue:Show(residueNum)
	end
end

local function checkOozeResurrect(GUID)
	-- set min resurrect time to 5 sec. (guessed)
	if diedOozeGUIDS[GUID] and GetTime() - diedOozeGUIDS[GUID] > 5 then
		residueNum = residueNum - 1
		diedOozeGUIDS[GUID] = nil
		mod:Unschedule(warningResidue)
		mod:Schedule(1.25, warningResidue)
	end
end

local function countCorruptionActive()
	local count = 0
	for i, v in pairs(corruptionActive) do
		count = count + 1
	end
	return count
end

function mod:OnCombatStart(delay)
	self.vb.shieldCount = 0
	numberOfPlayers = DBM:GetNumRealGroupMembers()
	if self:IsDifficulty("lfr25") then
		sealArmorText = DBM_CORE_AUTO_ANNOUNCE_TEXTS.cast:format(DBM:GetSpellInfo(105847), 34.5)
	else
		sealArmorText = DBM_CORE_AUTO_ANNOUNCE_TEXTS.cast:format(DBM:GetSpellInfo(105847), 23)
	end
	table.wipe(gripTargets)
	table.wipe(corruptionActive)
	table.wipe(diedOozeGUIDS)
	gripIcon = 6
	residueNum = 0
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 105845 then
		warnNuclearBlast:Show()
		specWarnNuclearBlast:Show()
	elseif args:IsSpellID(105847, 105848) then--This still has 2 spellids, since it's locational, location based IDs did NOT get crunched.
		warnSealArmor:Show(sealArmorText)
		specWarnSealArmor:Show()
		if self:IsDifficulty("lfr25") then
			timerSealArmor:Start(34.5)
		else
			timerSealArmor:Start()
		end
	elseif spellId == 109379 then
		if not corruptionActive[args.sourceGUID] then
			corruptionActive[args.sourceGUID] = 0
			if self:IsDifficulty("normal25", "heroic25") then
				timerGripCD:Start(16, args.sourceGUID)
			else
				timerGripCD:Start(nil, args.sourceGUID)
			end
		end
		corruptionActive[args.sourceGUID] = corruptionActive[args.sourceGUID] + 1
		if corruptionActive[args.sourceGUID] == 2 and self:IsDifficulty("normal25", "heroic25") then
			timerGripCD:Update(8, 16, args.sourceGUID)
		elseif corruptionActive[args.sourceGUID] == 4 and self:IsDifficulty("normal10", "heroic10") then
			timerGripCD:Update(24, 32, args.sourceGUID)
		end
	end
end

-- not needed guid check. This is residue creation step.
function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 105219 then
		residueNum = residueNum + 1
		diedOozeGUIDS[args.sourceGUID] = GetTime()
		self:Unschedule(warningResidue)
		self:Schedule(1.25, warningResidue)
	elseif spellId == 105248 and diedOozeGUIDS[args.sourceGUID] then
		residueNum = residueNum - 1
		diedOozeGUIDS[args.sourceGUID] = nil
		self:Unschedule(warningResidue)
		self:Schedule(1.25, warningResidue)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 105248 then
		warnAbsorbedBlood:Cancel()--Just a little anti spam
		warnAbsorbedBlood:Schedule(1.25, args.destName, 1)
	elseif spellId == 105490 then
		gripTargets[#gripTargets + 1] = args.destName
		timerGripCD:Cancel(args.sourceGUID)
		if corruptionActive[args.sourceGUID] then
			corruptionActive[args.sourceGUID] = nil
		end
		if self.Options.SetIconOnGrip then
			if gripIcon == 0 then
				gripIcon = 6
			end
			self:SetIcon(args.destName, gripIcon)
			gripIcon = gripIcon - 1
		end
		self:Unschedule(showGripWarning)
		self:Schedule(0.3, showGripWarning)
	elseif spellId == 105479 then
		self.vb.shieldCount = self.vb.shieldCount + 1
		if self.Options.InfoFrame and not DBM.InfoFrame:IsShown() then
			DBM.InfoFrame:SetHeader(args.spellName)
			DBM.InfoFrame:Show(6, "playerabsorb", args.spellName, select(16, DBM:UnitDebuff(args.destName, args.spellName)))
		end
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	local spellId = args.spellId
	if spellId == 105248 then
		warnAbsorbedBlood:Cancel()--Just a little anti spam
		if args.amount == 9 then
			warnAbsorbedBlood:Show(args.destName, 9)
		else
			warnAbsorbedBlood:Schedule(1.25, args.destName, args.amount)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 105490 then
		if self.Options.SetIconOnGrip then
			self:SetIcon(args.destName, 0)
		end
	elseif spellId == 105479 then
		self.vb.shieldCount = self.vb.shieldCount - 1
		if self.Options.InfoFrame and self.vb.shieldCount == 0 then
			DBM.InfoFrame:Hide()
		end
	end
end

--Damage event that indicates an ooze is taking damage
--we check its GUID to see if it's a resurrected ooze and if so remove it from table.
--for WoW 5.x priest spell, Shadow Word: Pain (spellid = 124464) fires spell_damage event. (this is damage over time spell, but combat log records this spell as SPELL_DAMAGE event. not SPELL_PERIODIC_DAMAGE)
--this cause bad revive check, so only source SPELL_DAMAGE (fires when ooze dies again) and SWING_DAMAGE event will resolve this.
--although this change causes slow revive check, it will be better than shows bad residue count.
function mod:SPELL_DAMAGE(sourceGUID, _, _, _, destGUID)
	checkOozeResurrect(sourceGUID)
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:SWING_DAMAGE(sourceGUID, _, _, _, destGUID)
	checkOozeResurrect(sourceGUID)
end
mod.SWING_MISSED = mod.SWING_DAMAGE

function mod:RAID_BOSS_EMOTE(msg)
	if msg == L.DRoll or msg:find(L.DRoll) then
		self:Unschedule(checkTendrils)--In case you manage to spam spin him, we don't want to get a bunch of extra stuff scheduled.
		self:Unschedule(clearTendrils)--^
		if self:AntiSpam(3, 1) then
			specWarnRoll:Show()--Warn you right away.
		end
		self:Schedule(3, checkTendrils)--After 3 seconds of roll starting, check tendrals, you should have leveled him out by now if this wasn't on purpose.
		timerBarrelRoll:Cancel()
		if numberOfPlayers > 1 then
			timerBarrelRoll:Start(5)
			self:Schedule(8, clearTendrils)--Clearing 3 seconds after the roll should be sufficent
		else
			timerBarrelRoll:Start(10)
			self:Schedule(13, clearTendrils)--Clearing 3 seconds after the roll should be sufficent
		end
		if self.Options.InfoFrame and not DBM.InfoFrame:IsShown() then
			DBM.InfoFrame:SetHeader(L.NoDebuff:format(tendrilDebuff))
			DBM.InfoFrame:Show(5, "playergooddebuff", tendrilDebuff)
		end
	elseif msg == L.DLevels or msg:find(L.DLevels) then
		self:Unschedule(checkTendrils)
		self:Unschedule(clearTendrils)
		clearTendrils()
		timerBarrelRoll:Cancel()
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 53891 or cid == 56162 or cid == 56161 then
		timerGripCD:Cancel(args.sourceGUID)
		warnAmalgamation:Schedule(4.5)--4.5-5 seconds after corruption dies.
		specWarnAmalgamation:Schedule(4.5)
		if self:IsDifficulty("heroic10", "heroic25") then
			timerDeathCD:Start(args.destGUID)
		end
	elseif cid == 56341 or cid == 56575 then
		timerSealArmor:Cancel()
	end
end
