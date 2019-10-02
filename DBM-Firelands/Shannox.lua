local mod	= DBM:NewMod(195, "DBM-Firelands", nil, 78)
local L		= mod:GetLocalizedStrings()
local Riplimb	= DBM:EJ_GetSectionInfo(2581)
local Rageface	= DBM:EJ_GetSectionInfo(2583)

mod:SetRevision("20190821185238")
mod:SetCreatureID(53691)
mod:SetEncounterID(1205)
mod:SetZone()
mod:SetUsedIcons(1, 2) -- cross(7) is hard to see in redish environment?
--mod:SetModelSound("Sound\\Creature\\SHANNOX\\VO_FL_SHANNOX_SPAWN.ogg", "Sound\\Creature\\SHANNOX\\VO_FL_SHANNOX_KILL_04.ogg")
--Long: Yes, I smell them too, Riplimb. Outsiders encroach on the Firelord's private grounds. Find their trail. Find them for me, that I may dispense punishment!
--Short: Dog food!

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 100002 99840",
	"SPELL_CAST_SUCCESS 99947",
	"SPELL_SUMMON 99836 99839",
	"SPELL_AURA_APPLIED 100415 100167 99837 99937",
	"SPELL_AURA_APPLIED_DOSE 99945 99937",
	"SPELL_AURA_REMOVED 99945 99937",
	"UNIT_HEALTH boss1 boss2 boss3",
	"UNIT_DIED"
)

--[[
(ability.id = 100002 or ability.id = 99840) and type = "begincast"
 or ability.id = 99947 and type = "cast"
 or (ability.id = 99836 or ability.id = 99839) and type = "summon"
 or type = "death"
--]]
local warnFaceRage				= mod:NewTargetNoFilterAnnounce(99947, 4)
local warnRage					= mod:NewTargetAnnounce(100415, 3)
local warnWary					= mod:NewTargetAnnounce(100167, 2, nil, false)
local warnTears					= mod:NewStackAnnounce(99937, 3, nil, "Tank|Healer")
local warnSpear					= mod:NewSpellAnnounce(100002, 3)--warn for this instead of magmaflare until/if rip dies.
local warnMagmaRupture			= mod:NewSpellAnnounce(99840, 3)
local warnCrystalPrison			= mod:NewTargetNoFilterAnnounce(99836, 2)--On by default, not as often, and useful for tanks or kiters
local warnImmoTrap				= mod:NewTargetAnnounce(99839, 2, nil, false)--Spammy, off by default for those who want it.
local warnCrystalPrisonTrapped	= mod:NewTargetNoFilterAnnounce(99837, 4)--Player is in prison.
local warnPhase2Soon			= mod:NewPrePhaseAnnounce(2, 3)

local specWarnSpear				= mod:NewSpecialWarningSpell(100002, false, nil, nil, 1, 2)
local specWarnRage				= mod:NewSpecialWarningDefensive(100415, nil, nil, nil, 1, 2)
local specWarnFaceRage			= mod:NewSpecialWarningTarget(99947, false, nil, nil, 1, 2)
local specWarnImmTrap			= mod:NewSpecialWarningMove(99839, nil, nil, nil, 1, 2)
local specWarnImmTrapNear		= mod:NewSpecialWarningClose(99839, nil, nil, nil, 1, 2)
local yellImmoTrap				= mod:NewShortYell(99839)
local specWarnCrystalTrap		= mod:NewSpecialWarningMove(99836, nil, nil, nil, 3, 2)
local specWarnCrystalTrapNear	= mod:NewSpecialWarningClose(99836, nil, nil, nil, 1, 2)
local yellCrystalTrap			= mod:NewShortYell(99836)
local specWarnTears				= mod:NewSpecialWarningStack(99937, "Tank", 8, nil, nil, 1, 6)

local timerRage					= mod:NewTargetTimer(15, 100415, nil, "Healer", nil, 5, nil, DBM_CORE_HEALER_ICON)
local timerWary					= mod:NewTargetTimer(25, 100167, nil, false, nil, 5)
local timerTears				= mod:NewTargetTimer(26, 99937, nil, "Tank|Healer", nil, 5, nil, DBM_CORE_TANK_ICON)
local timerCrystalPrison		= mod:NewTargetTimer(10, 99837, nil, nil, nil, 5)--Dogs Only
local timerCrystalPrisonCD		= mod:NewCDTimer(25.5, 99836, nil, nil, nil, 3)--Seems consistent timing, other trap is not.
local timerSpearCD				= mod:NewCDTimer(42, 100002, nil, nil, nil, 3)--Before riplimb dies
local timerMagmaRuptureCD		= mod:NewCDTimer(15, 99840, nil, nil, nil, 2)--After riplimb dies
local timerFaceRageCD			= mod:NewCDTimer(27, 99947, nil, false, nil, 3)--Has a 27-30 sec cd but off by default as it's subject to wild variation do to traps.

local berserkTimer				= mod:NewBerserkTimer(600)

mod:AddSetIconOption("SetIconOnFaceRage", 99945, false, false, {2})
mod:AddSetIconOption("SetIconOnRage", 100415, false, false, {1})

mod.vb.prewarnedPhase2 = false
mod.vb.ripLimbDead = false

function mod:ImmoTrapTarget(targetname)
	if not targetname then return end
	if targetname == UnitName("player") then
		specWarnImmTrap:Show()
		specWarnImmTrap:Play("runaway")
		yellImmoTrap:Yell()
	elseif self:CheckNearby(6, targetname) then
		specWarnImmTrapNear:Show(targetname)
		specWarnImmTrapNear:Play("runaway")
	else
		warnImmoTrap:Show(targetname)
	end
end

function mod:CrystalTrapTarget(targetname)
	if not targetname then return end
	if targetname == UnitName("player") then
		specWarnCrystalTrap:Show()
		specWarnCrystalTrap:Play("runaway")
		yellCrystalTrap:Yell()
	elseif self:CheckNearby(6, targetname) then
		specWarnCrystalTrapNear:Show(targetname)
		specWarnCrystalTrapNear:Play("runaway")
	else
		warnCrystalPrison:Show(targetname)
	end
end

function mod:OnCombatStart(delay)
	self.vb.prewarnedPhase2 = false
	self.vb.ripLimbDead = false
	timerCrystalPrisonCD:Start(8.4-delay)
	timerSpearCD:Start(20-delay)--High variation, just a CD?
	berserkTimer:Start(-delay)
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 100002 then--Only valid until rip dies
		if self.Options.SpecWarn100002spell then
			specWarnSpear:Show()
			specWarnSpear:Play("runaway")
		else
			warnSpear:Show()
		end
		timerSpearCD:Start()
	elseif spellId == 99840 and self.vb.ripLimbDead then	--This is cast after Riplimb dies.
		warnMagmaRupture:Show()
		timerMagmaRuptureCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 99947 then
		if self.Options.SpecWarn99947target then
			specWarnFaceRage:Show(args.destName)
			specWarnFaceRage:Play("healfull")
		else
			warnFaceRage:Show(args.destName)
		end
		timerFaceRageCD:Start()
		if self.Options.SetIconOnFaceRage then
			self:SetIcon(args.destName, 2)
		end
	end
end

function mod:SPELL_SUMMON(args)
	local spellId = args.spellId
	if spellId == 99836 then
		timerCrystalPrisonCD:Start()
		self:BossTargetScanner(53691, "CrystalTrapTarget", 0.05, 12, true)
	elseif spellId == 99839 then
		self:BossTargetScanner(53691, "ImmoTrapTarget", 0.05, 12, true)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 100415 then
		timerRage:Start(args.destName)
		if args:IsPlayer() then
			specWarnRage:Show()
			specWarnRage:Play("defensive")
		else
			warnRage:Show(args.destName)
		end
		if self.Options.SetIconOnRage then
			self:SetIcon(args.destName, 1, 15)
		end
	elseif spellId == 100167 then
		warnWary:Show(args.destName)
		timerWary:Start(args.destName)
	elseif spellId == 99837 then--Filter when the dogs get it?
		if args:IsDestTypePlayer() then
			warnCrystalPrisonTrapped:Show(args.destName)
		else--It's a trapped dog
			timerCrystalPrison:Start(args.destName)--make a 10 second timer for how long dog is trapped.
		end
	elseif spellId == 99937 then
		if args:IsPlayer() and (args.amount or 1) >= 8 then
			specWarnTears:Show(args.amount)
			specWarnTears:Play("stackhigh")
		elseif (args.amount or 1) % 3 == 0 then	--Warn every 3 stacks
			warnTears:Show(args.destName, args.amount or 1)
		end
		timerTears:Start(self:IsHeroic() and 30 or 26, args.destName)
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 99945 then
		if self.Options.SetIconOnFaceRage then
			self:SetIcon(args.destName, 0)
		end
	elseif spellId == 99937 then
		timerTears:Cancel(args.destName)
	end
end

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 53691 then
		local h = UnitHealth(uId) / UnitHealthMax(uId) * 100
		if h > 50 and self.vb.prewarnedPhase2 then
			self.vb.prewarnedPhase2 = false
		elseif h > 33 and h < 36 and not self.vb.prewarnedPhase2 and not self:IsHeroic() then
			self.vb.prewarnedPhase2 = true
			warnPhase2Soon:Show()
		end
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 53694 then
		timerSpearCD:Cancel()--Cancel it and replace it with other timer
		timerMagmaRuptureCD:Start(10)
		self.vb.ripLimbDead = true
	elseif cid == 53695 then
		timerFaceRageCD:Cancel()
	end
end
