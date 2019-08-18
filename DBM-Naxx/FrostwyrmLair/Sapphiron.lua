local mod	= DBM:NewMod("Sapphiron", "DBM-Naxx", 5)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190817015124")
mod:SetCreatureID(15989)
mod:SetEncounterID(1119)
mod:SetModelID(16033)
mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 28522",
	"RAID_BOSS_EMOTE",
	"SPELL_CAST_SUCCESS 28542 55665"
)

local warnDrainLifeNow	= mod:NewSpellAnnounce(28542, 2)
local warnDrainLifeSoon	= mod:NewSoonAnnounce(28542, 1)
local warnIceBlock		= mod:NewTargetAnnounce(28522, 2)
local warnAirPhaseSoon	= mod:NewAnnounce("WarningAirPhaseSoon", 3, "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendUnBurrow.blp")
local warnAirPhaseNow	= mod:NewAnnounce("WarningAirPhaseNow", 4, "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendUnBurrow.blp")
local warnLanded		= mod:NewAnnounce("WarningLanded", 4, "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendBurrow.blp")

local warnDeepBreath	= mod:NewSpecialWarning("WarningDeepBreath", nil, nil, nil, 1, 2)
local yellIceBlock		= mod:NewYell(28522)

local timerDrainLife	= mod:NewCDTimer(22, 28542, nil, nil, nil, 3, nil, DBM_CORE_CURSE_ICON)
local timerAirPhase		= mod:NewTimer(66, "TimerAir", "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendUnBurrow.blp", nil, nil, 6)
local timerLanding		= mod:NewTimer(28.5, "TimerLanding", "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendBurrow.blp", nil, nil, 6)
local timerIceBlast		= mod:NewTimer(9.3, "TimerIceBlast", 15876, nil, nil, 2, DBM_CORE_DEADLY_ICON)

local berserkTimer		= mod:NewBerserkTimer(900)

local noTargetTime = 0
mod.vb.isFlying = false
local UnitAffectingCombat = UnitAffectingCombat

local function resetIsFlying(self)
	self.vb.isFlying = false
end

local function Landing()
	warnAirPhaseSoon:Schedule(56)
	warnLanded:Show()
	timerAirPhase:Start()
end

function mod:OnCombatStart(delay)
	noTargetTime = 0
	self.vb.isFlying = false
	warnAirPhaseSoon:Schedule(38.5 - delay)
	timerAirPhase:Start(48.5 - delay)
	berserkTimer:Start(-delay)
	self:RegisterOnUpdateHandler(function(self, elapsed)
		if not self:IsInCombat() then return end
		local foundBoss, target
		for uId in DBM:GetGroupMembers() do
			local unitID = uId.."target"
			if self:GetUnitCreatureId(unitID) == 15989 and UnitAffectingCombat(unitID) then
				target = DBM:GetUnitFullName(unitID.."target")
				foundBoss = true
				break
			end
		end
		if foundBoss and not target then
			noTargetTime = noTargetTime + elapsed
		elseif foundBoss then
			noTargetTime = 0
		end
		if noTargetTime > 0.5 and not self.vb.isFlying then
			noTargetTime = 0
			self.vb.isFlying = true
			self:Schedule(60, resetIsFlying, self)
			timerDrainLife:Cancel()
			timerAirPhase:Cancel()
			warnAirPhaseNow:Show()
			timerLanding:Start()
		end
	end, 0.2)
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 28522 then
		warnIceBlock:CombinedShow(0.5, args.destName)
		if args:IsPlayer() then
			yellIceBlock:Yell()
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(28542, 55665) then -- Life Drain
		warnDrainLifeNow:Show()
		warnDrainLifeSoon:Schedule(18.5)
		timerDrainLife:Start()
	end
end

function mod:RAID_BOSS_EMOTE(msg)
	if msg == L.EmoteBreath or msg:find(L.EmoteBreath) then
		self:SendSync("DeepBreath")
	end
end

function mod:OnSync(event)
	if event == "DeepBreath" then
		timerIceBlast:Start()
		timerLanding:Update(14)
		self:Schedule(14.5, Landing, self)
		warnDeepBreath:Show()
		warnDeepBreath:Play("findshelter")
	end
end
