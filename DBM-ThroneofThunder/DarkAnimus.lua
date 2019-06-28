local mod	= DBM:NewMod(824, "DBM-ThroneofThunder", nil, 362)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143417")
mod:SetCreatureID(69427)
mod:SetEncounterID(1576)
mod:SetZone()
mod:SetUsedIcons(1)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 136594 138763 139867 139869",
	"SPELL_CAST_SUCCESS 138644",
	"SPELL_AURA_APPLIED 138569 138609 138780 139537 138691",
	"SPELL_AURA_APPLIED_DOSE 138569",
	"SPELL_AURA_REMOVED 138609 138569 138691",
	"SPELL_DAMAGE 138405",
	"SPELL_MISSED 138618",
	"RAID_BOSS_WHISPER"
)

local warnCrimsonWake				= mod:NewTargetAnnounce(138480, 3)
local warnMatterSwap				= mod:NewTargetAnnounce(138609, 3)--Debuff.
local warnMatterSwapped				= mod:NewAnnounce("warnMatterSwapped", 3, 138618)--Actual swap(caused by dispel)
local warnExplosiveSlam				= mod:NewStackAnnounce(138569, 2, nil, "Tank|Healer")
--Boss
local warnActivation				= mod:NewCastAnnounce(139537, 3, 60)
local warnAnimaRing					= mod:NewTargetAnnounce(136954, 3, nil, "Tank")
local warnAnimaFont					= mod:NewTargetAnnounce(138691, 3)
local warnEmpowerGolem				= mod:NewTargetAnnounce(138780, 3)

local specWarnCrimsonWakeYou		= mod:NewSpecialWarningRun(138480, nil, nil, nil, 4)--Kiter
local specWarnCrimsonWake			= mod:NewSpecialWarningMove(138485)--Standing in stuff left behind by kiter
local yellCrimsonWake				= mod:NewYell(138480)
local specWarnMatterSwap			= mod:NewSpecialWarningYou(138609)
local specWarnExplosiveSlam			= mod:NewSpecialWarningStack(138569, nil, 4)--Assumed value drycode, won't know until cd is observed
local specWarnExplosiveSlamOther	= mod:NewSpecialWarningTarget(138569, "Tank")--Not black and white, so not using Taunt type warning
--Boss
local specWarnAnimaRing				= mod:NewSpecialWarningYou(136954)
local specWarnAnimaRingOther		= mod:NewSpecialWarningTarget(136954, false)
local yellAnimaRing					= mod:NewYell(136954)
local specWarnAnimaFont				= mod:NewSpecialWarningYou(138691)
local specWarnInterruptingJolt		= mod:NewSpecialWarningCount(138763, nil, nil, nil, 2)

local timerMatterSwap				= mod:NewTargetTimer(12, 138609)--If not dispelled, it ends after 12 seconds regardless
local timerExplosiveSlam			= mod:NewTargetTimer(25, 138569, nil, "Tank|Healer")
--Boss
local timerAnimusActivation			= mod:NewCastTimer(60, 139537, nil, nil, nil, 6, nil, nil, nil, 1, 5)--LFR only
local timerSiphonAnimaCD			= mod:NewNextCountTimer(20, 138644)--Needed mainly for heroic. not important on normal/LFR
local timerAnimaRingCD				= mod:NewNextTimer(24.2, 136954, nil, "Tank", nil, 5, nil, DBM_CORE_TANK_ICON, nil, 2, 4)--Updated/Verified post march 19 hotfix
local timerAnimaFontCD				= mod:NewCDTimer(25, 138691, nil, nil, nil, 3)
local timerInterruptingJolt			= mod:NewCastTimer(2.2, 138763)
local timerInterruptingJoltCD		= mod:NewCDCountTimer(21.5, 138763, nil, nil, nil, 2, nil, nil, nil, 1, 4)--seems 23~24 normal and lfr. every 21.5 exactly on heroic
local timerEmpowerGolemCD			= mod:NewCDTimer(16, 138780)

local berserkTimer					= mod:NewBerserkTimer(600)

local crimsonWake = DBM:GetSpellInfo(138485)--Debuff ID I believe, not cast one. Same spell name though
local siphon = 0
local jolt = 0

mod:AddBoolOption("SetIconOnFont", true)

local function PowerDelay()
	local power = UnitPower("boss1")
	if power >= 70 and power < 75 then
		timerInterruptingJoltCD:Start(18, 1)
	end
end

function mod:AnimaRingTarget(targetname)
	warnAnimaRing:Show(targetname)
	if targetname == UnitName("player") then
		specWarnAnimaRing:Show()
		yellAnimaRing:Yell()
	else
		specWarnAnimaRingOther:Show(targetname)
	end
end

function mod:OnCombatStart(delay)
	siphon = 0
	jolt = 0
	berserkTimer:Start(-delay)
	self:RegisterShortTermEvents(
		"INSTANCE_ENCOUNTER_ENGAGE_UNIT"--We register here to prevent detecting first heads on pull before variables reset from first engage fire. We'll catch them on delayed engages fired couple seconds later
	)
end

function mod:OnCombatEnd()
	self:UnregisterShortTermEvents()
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 136954 then
		self:BossTargetScanner(69427, "AnimaRingTarget", 0.02, 12)
		timerAnimaRingCD:Start()
	elseif args:IsSpellID(138763, 139867, 139869) then--Normal version is 2.2 sec cast. Heroic is 1.4 second cast. LFR is 3.8 sec cast (thus why it has different spellid)
		jolt = jolt + 1
		specWarnInterruptingJolt:Show(jolt)
		if self:IsDifficulty("lfr25") then
			timerInterruptingJolt:Start(3.8)
		else
			timerInterruptingJolt:Start()
		end
		if self:IsHeroic() then
			timerInterruptingJoltCD:Start(nil, jolt+1)
		else
			timerInterruptingJoltCD:Start(23, jolt+1)
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 138644 and self:IsHeroic() then--Only start on heroic, on normal it's 6 second cd, not worth using timer there
		siphon = siphon + 1
		timerSiphonAnimaCD:Start(nil, siphon+1)
		self:Schedule(2, PowerDelay)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 138569 then
		local uId = DBM:GetRaidUnitId(args.destName)
		if self:IsTanking(uId, "boss1") then--Only want sprays that are on tanks, not bads standing on tanks.
			local amount = args.amount or 1
			warnExplosiveSlam:Show(args.destName, amount)
			timerExplosiveSlam:Start(args.destName)
			if args:IsPlayer() then
				if amount >= 4 then
					specWarnExplosiveSlam:Show(amount)
				end
			else
				if amount >= 4 and not DBM:UnitDebuff("player", args.spellName) and not UnitIsDeadOrGhost("player") then
					specWarnExplosiveSlamOther:Show(args.destName)
				end
			end
		end
	elseif spellId == 138609 then
		warnMatterSwap:Show(args.destName)
		timerMatterSwap:Start(args.destName)
		if args:IsPlayer() then
			specWarnMatterSwap:Show()
		end
	elseif spellId == 138780 then
		warnEmpowerGolem:Show(args.destName)
		timerEmpowerGolemCD:Start()
	elseif spellId == 139537 then
		warnActivation:Show()
		timerAnimusActivation:Start()
	elseif spellId == 138691 then
		warnAnimaFont:Show(args.destName)
		timerAnimaFontCD:Start()
		if args:IsPlayer() then
			specWarnAnimaFont:Show()
		end
		if self.Options.SetIconOnFont then
			self:SetIcon(args.destName, 1)--star
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 138609 then
		timerMatterSwap:Cancel(args.destName)
	elseif spellId == 138569 then
		timerExplosiveSlam:Cancel(args.destName)
	elseif spellId == 138691 and self.Options.SetIconOnFont then
		self:SetIcon(args.destName, 0)
	end
end

function mod:SPELL_DAMAGE(sourceGUID, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 138485 and destGUID == UnitGUID("player") and self:AntiSpam(2, 1) then
		specWarnCrimsonWake:Show()
	elseif spellId == 138618 then
		if sourceGUID == destGUID then return end--Filter first event then grab both targets from second event, as seen from log example above
		warnMatterSwapped:Show(spellName, DBM:GetFullPlayerNameByGUID(sourceGUID), DBM:GetFullPlayerNameByGUID(destGUID))
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

--Seems to have no debuff event on combat log. Could possibly use UNIT_AURA, but this should be tremendous cpu, plus hard to code in LFR since MANY large up at once
function mod:RAID_BOSS_WHISPER(msg, npc)
	if npc == crimsonWake then--In case target scanning fails, personal warnings still always go off. Target scanning is just so everyone else in raid knows who it's on (since only target sees this emote)
		if self:AntiSpam(3, 1) then--This actually doesn't spam, but we ues same antispam here so that the MOVE warning doesn't fire at same time unless you fail to move for 2 seconds
			specWarnCrimsonWakeYou:Show()
		end
		if not self:IsDifficulty("lfr25") then
			yellCrimsonWake:Yell()
		end
		self:SendSync("WakeTarget", UnitGUID("player"))
	end
end

function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	if UnitExists("boss1") and self:GetCIDFromGUID(UnitGUID("boss1")) == 69427 then
		self:UnregisterShortTermEvents()--Once boss is out, unregister event, since we need it no longer.
		if self:IsHeroic() then
			timerAnimaFontCD:Start(14)
			timerAnimaRingCD:Start(23)
			timerSiphonAnimaCD:Start(120, 1)--VERY important on heroic. boss activaet on pull, you have 2 minutes to do as much with adds as you can before he starts using siphon anima
		elseif self:IsDifficulty("normal10", "normal25") then
			timerSiphonAnimaCD:Start(5.3, 1)
		end
	end
end

function mod:OnSync(msg, guid)
	if msg == "WakeTarget" and guid then
		warnCrimsonWake:Show(DBM:GetFullPlayerNameByGUID(guid))
	elseif msg == "TestFunction" then
		timerAnimaRingCD:Start(13)
		timerInterruptingJoltCD:Start(11)
	end
end
