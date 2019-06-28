local mod	= DBM:NewMod(825, "DBM-ThroneofThunder", nil, 362)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143417")
mod:SetCreatureID(67977)
mod:SetEncounterID(1565)
mod:SetZone()
mod:SetUsedIcons(8, 7, 6, 5, 4, 3)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 133939 136294 135251 134920",
	"SPELL_AURA_APPLIED 133971 133974",
	"SPELL_AURA_REMOVED 137633",
	"SPELL_CAST_SUCCESS 134476 134031",
	"UNIT_AURA boss1",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

local warnBite						= mod:NewSpellAnnounce(135251, 3, nil, "Tank")
local warnRockfall					= mod:NewSpellAnnounce(134476, 2)
local warnKickShell					= mod:NewAnnounce("warnKickShell", 2, 134031)
local warnShellConcussion			= mod:NewTargetAnnounce(136431, 1)

local specWarnCallofTortos			= mod:NewSpecialWarningSpell(136294)
local specWarnQuakeStomp			= mod:NewSpecialWarningCount(134920, nil, nil, nil, 2)
local specWarnRockfall				= mod:NewSpecialWarningSpell(134476, false, nil, nil, 2)
local specWarnStoneBreath			= mod:NewSpecialWarningInterrupt(133939, nil, nil, 2, 3)
local specWarnCrystalShell			= mod:NewSpecialWarning("specWarnCrystalShell", false)
local specWarnSummonBats			= mod:NewSpecialWarningSwitch("ej7140", "Tank")--Dps can turn it on too, but not on by default for dps cause quite frankly dps should NOT switch right away, tank needs to get aggro first and where they spawn is semi random.

local timerBiteCD					= mod:NewCDTimer(8, 135251, nil, "Tank", nil, 5)
local timerRockfallCD				= mod:NewCDTimer(10, 134476, nil, nil, nil, 3)
local timerCallTortosCD				= mod:NewNextTimer(60.5, 136294, nil, nil, nil, 1)
local timerStompCD					= mod:NewCDCountTimer(47, 134920, nil, nil, nil, 2, nil, nil, nil, 1, 4)
local timerBreathCD					= mod:NewCDTimer(46, 133939, nil, nil, nil, 4, nil, nil, nil, 2, 4)--TODO, adjust timer when Growing Anger is cast, so we can use a Next bar more accurately
local timerSummonBatsCD				= mod:NewCDTimer(45, "ej7140", nil, nil, nil, 1, 136685)--45-47. This doesn't always sync up to furious stone breath. Longer fight goes on more out of sync they get. So both bars needed I suppose
local timerStompActive				= mod:NewBuffActiveTimer(10.8, 134920)--Duration of the rapid caveins
local timerShellConcussion			= mod:NewBuffFadesTimer(20, 136431)

local berserkTimer					= mod:NewBerserkTimer(780)

mod:AddBoolOption("InfoFrame")
mod:AddSetIconOption("SetIconOnTurtles", "ej7129", false, true)
mod:AddBoolOption("ClearIconOnTurtles", false)--Different option, because you may want auto marking but not auto clearing. or you may want auto clearning when they "die" but not auto marking when they spawn
mod:AddBoolOption("AnnounceCooldowns", "RaidCooldown")

local shelldName, shellConcussion = DBM:GetSpellInfo(137633), DBM:GetSpellInfo(136431)
local stompActive = false
local stompCount = 0
local firstRockfall = false--First rockfall after a stomp
local shellsRemaining = 0
local lastConcussion = 0
local kickedShells = {}
local addsActivated = 0
local startIcon = 8
local alternateSet = false

local function clearStomp()
	stompActive = false
	firstRockfall = false--First rockfall after a stomp
	if mod:AntiSpam(9, 1) then--prevent double warn.
		warnRockfall:Show()
		specWarnRockfall:Show()
		timerRockfallCD:Start()--Resume normal CDs, first should be 5 seconds after stomp spammed ones
	end
end

local function checkCrystalShell()
	if not DBM:UnitDebuff("player", shelldName) and not UnitIsDeadOrGhost("player") then
		local percent = (UnitHealth("player") / UnitHealthMax("player")) * 100
		if percent > 90 then
			specWarnCrystalShell:Show(shelldName)
		end
		mod:Unschedule(checkCrystalShell)
		mod:Schedule(3, checkCrystalShell)
	end
end

function mod:OnCombatStart(delay)
	stompActive = false
	stompCount = 0
	firstRockfall = false--First rockfall after a stomp
	shellsRemaining = 0
	lastConcussion = 0
	addsActivated = 0
	startIcon = 8
	alternateSet = false
	table.wipe(kickedShells)
	timerRockfallCD:Start(15-delay)
	timerCallTortosCD:Start(21-delay)
	timerStompCD:Start(27-delay, 1)
	timerBreathCD:Start(-delay)
	if self:IsHeroic() then
		if self.Options.InfoFrame then
			DBM.InfoFrame:SetHeader(L.WrongDebuff:format(shelldName))
			DBM.InfoFrame:Show(5, "playergooddebuff", shelldName)
		end
		checkCrystalShell()
		berserkTimer:Start(600-delay)
	else
		berserkTimer:Start(-delay)
	end
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 133939 then
		if not self:IsDifficulty("lfr25") then
			specWarnStoneBreath:Show(args.sourceName)
		end
		timerBreathCD:Start()
	elseif spellId == 136294 then
		if self:AntiSpam(5, 4) then
			specWarnCallofTortos:Show()
		end
		if self:AntiSpam(59, 3) then -- On below 10%, he casts Call of Tortos always. This cast ignores cooldown, so filter below 10% cast.
			timerCallTortosCD:Start()
		end
	elseif spellId == 135251 then
		warnBite:Show()
		timerBiteCD:Start()
	elseif spellId == 134920 then
		stompActive = true
		stompCount = stompCount + 1
		specWarnQuakeStomp:Show(stompCount)
		timerStompActive:Start()
		timerRockfallCD:Start(7.4)--When the spam of rockfalls start
		timerStompCD:Start(nil, stompCount+1)
		if self.Options.AnnounceCooldowns then
			DBM:PlayCountSound(stompCount)
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 133971 then--Shell Block (turtles dying and becoming kickable)
		shellsRemaining = shellsRemaining + 1
		addsActivated = addsActivated - 1
		if DBM:GetRaidRank() > 0 and self.Options.ClearIconOnTurtles then
			for uId in DBM:GetGroupMembers() do
				local unitid = uId.."target"
				local guid = UnitGUID(unitid)
				if args.destGUID == guid then
					SetRaidTarget(unitid, 0)
				end
			end
		end
	elseif spellId == 133974 and self.Options.SetIconOnTurtles then--Spinning Shell
		if self:AntiSpam(5, 6) then
			if addsActivated >= 1 then--1 or more add is up from last set
				if alternateSet then--We check whether we started with skull last time or moon
					startIcon = 5--Start with moon if we used skull last time
					alternateSet = false
				else
					startIcon = 8--Start with skull if we used moon last time
					alternateSet = true
				end
			else--No turtles are up at all
				startIcon = 8--Always start with skull
				alternateSet = true--And reset alternate status so we use moon next time (unless all are dead again, then re always reset to skull)
			end
			self:ScanForMobs(args.destGUID, 0, startIcon, 3, 0.2, 10)
		end
		addsActivated = addsActivated + 1
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 137633 and args:IsPlayer() then
		checkCrystalShell()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 134476 then
		if stompActive then--10 second cd normally, but cd is disabled when stomp active
			if not firstRockfall then--Announce first one only and ignore the next ones spammed for about 9-10 seconds
				firstRockfall = true
				warnRockfall:Show()
				specWarnRockfall:Show()--To warn of massive incoming for the 9 back to back rockfalls that are incoming
				self:Schedule(10, clearStomp)
			end
		else
			if self:AntiSpam(9, 1) then--sometimes clearstomp doesn't work? i can't find reason cause all logs match this system exactly.
				warnRockfall:Show()
				specWarnRockfall:Show()
				timerRockfallCD:Start()
			end
		end
	elseif spellId == 134031 and not kickedShells[args.destGUID] then--Kick Shell
		kickedShells[args.destGUID] = true
		shellsRemaining = shellsRemaining - 1
		warnKickShell:Show(args.spellName, args.sourceName, shellsRemaining)
	end
end

--Does not show in combat log, so UNIT_AURA must be used instead
function mod:UNIT_AURA(uId)
	local _, _, _, _, duration, expires = DBM:UnitDebuff(uId, shellConcussion)
	if expires and lastConcussion ~= expires then
		lastConcussion = expires
		timerShellConcussion:Start()
		if self:AntiSpam(3, 2) then
			warnShellConcussion:Show(L.name)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 136685 then --Don't filter main tank, bat tank often taunts boss just before bats for vengeance, otherwise we lose threat to dps. Then main tank taunts back after bats spawn and we go get them, fully vengeanced (if you try to pick up bats without vengeance you will not hold aggro for shit)
		specWarnSummonBats:Show()
		timerSummonBatsCD:Start()
	end
end
