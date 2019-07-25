local mod	= DBM:NewMod("GeneralVezax", "DBM-Ulduar")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190722195205")
mod:SetCreatureID(33271)
mod:SetEncounterID(1134)
mod:SetModelID(28548)
mod:SetUsedIcons(7, 8)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 62661 62662",
	"SPELL_AURA_APPLIED 62662",
	"SPELL_AURA_REMOVED 62662",
	"SPELL_CAST_SUCCESS 62660 63276 63364",
	"RAID_BOSS_EMOTE"
)

--TODO, log, detect, and cancel hardmode timer when any vapors get broken
local warnShadowCrash			= mod:NewTargetAnnounce(62660, 4)
local warnLeechLife				= mod:NewTargetNoFilterAnnounce(63276, 3)
local warnSaroniteVapor			= mod:NewCountAnnounce(63337, 2)

local specWarnShadowCrash		= mod:NewSpecialWarningDodge(62660, nil, nil, nil, 1, 2)
local specWarnShadowCrashNear	= mod:NewSpecialWarningClose(62660, nil, nil, nil, 1, 2)
local yellShadowCrash			= mod:NewYell(62660)
local specWarnSurgeDarkness		= mod:NewSpecialWarningDefensive(62662, nil, nil, 2, 1, 2)
local specWarnLifeLeechYou		= mod:NewSpecialWarningMoveAway(63276, nil, nil, nil, 3, 2)
local yellLifeLeech				= mod:NewYell(63276)
local specWarnLifeLeechNear 	= mod:NewSpecialWarningClose(63276, nil, nil, 2, 1, 2)
local specWarnSearingFlames		= mod:NewSpecialWarningInterruptCount(62661, "HasInterrupt", nil, nil, 1, 2)
local specWarnAnimus			= mod:NewSpecialWarningSwitch("ej17651", nil, nil, nil, 1, 2)

local timerEnrage				= mod:NewBerserkTimer(600)
local timerSurgeofDarkness		= mod:NewBuffActiveTimer(10, 62662, nil, "Tank", nil, 5, nil, DBM_CORE_TANK_ICON)
local timerNextSurgeofDarkness	= mod:NewCDTimer(61.7, 62662, nil, "Tank", nil, 5, nil, DBM_CORE_TANK_ICON)
local timerSaroniteVapors		= mod:NewNextCountTimer(30, 63322, nil, nil, nil, 5)
local timerShadowCrashCD		= mod:NewCDTimer(12, 62660, nil, "Ranged", nil, 3)
local timerLifeLeech			= mod:NewTargetTimer(10, 63276, nil, false, 2, 3)
local timerLifeLeechCD			= mod:NewCDTimer(20.4, 63276, nil, nil, nil, 3)
local timerHardmode				= mod:NewTimer(189, "hardmodeSpawn", nil, nil, nil, 1)

mod:AddBoolOption("SetIconOnShadowCrash", true)
mod:AddBoolOption("SetIconOnLifeLeach", true)

mod.vb.interruptCount = 0
mod.vb.vaporsCount = 0
local animusName = DBM:EJ_GetSectionInfo(17651)

function mod:ShadowCrashTarget(targetname, uId)
	if not targetname then return end
	if self.Options.SetIconOnShadowCrash then
		self:SetIcon(targetname, 8, 5)
	end
	if targetname == UnitName("player") then
		specWarnShadowCrash:Show()
		specWarnShadowCrash:Play("runaway")
		yellShadowCrash:Yell()
	elseif targetname then
		if uId then
			local inRange = CheckInteractDistance(uId, 2)
			if inRange then
				specWarnShadowCrashNear:Show(targetname)
				specWarnShadowCrashNear:Play("runaway")
			end
		end
	else
		warnShadowCrash:Show(targetname)
	end
end

function mod:OnCombatStart(delay)
	self.vb.interruptCount = 0
	self.vb.vaporsCount = 0
	timerShadowCrashCD:Start(10.9-delay)
	timerLifeLeechCD:Start(16.9-delay)
	timerSaroniteVapors:Start(30-delay, 1)
	timerEnrage:Start(-delay)
	timerHardmode:Start(-delay)
	timerNextSurgeofDarkness:Start(-delay)
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 62661 then	-- Searing Flames
		self.vb.interruptCount = self.vb.interruptCount + 1
		if self.vb.interruptCount == 4 then
			self.vb.interruptCount = 1
		end
		local kickCount = self.vb.interruptCount
		specWarnSearingFlames:Show(args.sourceName, kickCount)
		specWarnSearingFlames:Play("kick"..kickCount.."r")
	elseif args.spellId == 62662 then 
		local tanking, status = UnitDetailedThreatSituation("player", "boss1")
		if tanking or (status == 3) then--Player is current target
			specWarnSurgeDarkness:Show()
			specWarnSurgeDarkness:Play("defensive")
		end
		timerNextSurgeofDarkness:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 62662 then	-- Surge of Darkness
		timerSurgeofDarkness:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 62662 then	
		timerSurgeofDarkness:Stop()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 62660 then		-- Shadow Crash
		self:BossTargetScanner(33271, "ShadowCrashTarget", 0.05, 20)
		timerShadowCrashCD:Start()
	elseif args.spellId == 63276 then	-- Mark of the Faceless
		if self.Options.SetIconOnLifeLeach then
			self:SetIcon(args.destName, 7, 10)
		end
		timerLifeLeech:Start(args.destName)
		timerLifeLeechCD:Start()
		if args:IsPlayer() then
			specWarnLifeLeechYou:Show()
			specWarnLifeLeechYou:Play("runout")
			yellLifeLeech:Yell()
		else
			local uId = DBM:GetRaidUnitId(args.destName)
			if uId then
				local inRange = CheckInteractDistance(uId, 2)
				if inRange then
					specWarnLifeLeechNear:Show(args.destName)
					specWarnLifeLeechNear:Play("runaway")
				else
					warnLeechLife:Show(args.destName)
				end
			end
		end
	elseif args.spellId == 63364 then
		specWarnAnimus:Show()
		specWarnAnimus:Play("bigmob")
	end
end

function mod:RAID_BOSS_EMOTE(emote)
	if emote == L.EmoteSaroniteVapors or emote:find(L.EmoteSaroniteVapors) then
		self.vb.vaporsCount = self.vb.vaporsCount + 1
		warnSaroniteVapor:Show(self.vb.vaporsCount)
		if self.vb.vaporsCount < 6 then
			timerSaroniteVapors:Start(nil, self.vb.vaporsCount+1)
		end
	end
end
