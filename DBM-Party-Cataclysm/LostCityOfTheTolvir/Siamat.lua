local mod	= DBM:NewMod(122, "DBM-Party-Cataclysm", 5, 69)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(44819)
mod:SetEncounterID(1055)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 84982",	
	"SPELL_CAST_START 84522 91872",
	"SPELL_CAST_SUCCESS 84589 83066 83151",
	"SPELL_SUMMON 84547 84553 84554"
)

local warnStaticShock		= mod:NewCountAnnounce(84547, 4)	-- Summons a "Servant of Siamat"
local warnThunderCrash		= mod:NewCastAnnounce(84522, 3)
local warnDeflectingWinds	= mod:NewSpellAnnounce(84589, 3)
local warnWailingWinds		= mod:NewSpellAnnounce(83066, 3)--Useful?
local warnAbsorbStorms		= mod:NewSpellAnnounce(83151, 2, nil, false, 2)
local warnGatheredStorms	= mod:NewSpellAnnounce(84982, 3)
local warnLightningCharge	= mod:NewCastAnnounce(91872, 3)

local specWarnPhase2Soon	= mod:NewSpecialWarning("specWarnPhase2Soon", true, nil, nil, 2, 2)

local timerThunderCrash		= mod:NewCastTimer(3, 84522, nil, nil, nil, 3)
local timerWailingWinds		= mod:NewBuffActiveTimer(6, 83066, nil, nil, nil, 3)
local timerAbsorbStorms		= mod:NewCDTimer(33, 83151, nil, false, 2)
local timerGatheredStorms	= mod:NewBuffActiveTimer(25, 84982, nil, false, 2)
local timerPhase2Start		= mod:NewPhaseTimer(5)

mod.vb.servantSpawn = 0
mod.vb.thirdServant = 0

function mod:OnCombatStart(delay)
	self.vb.servantSpawn = 0
	self.vb.thirdServant = 0
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 84982 then
		warnGatheredStorms:Show()
		timerGatheredStorms:Start()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 84522 then
		warnThunderCrash:Show()
		timerThunderCrash:Start()
	elseif spellId == 91872 then
		warnLightningCharge:Show()
		if args.sourceGUID == self.vb.thirdServant then--Third add to have spawned is dying and casting Lightning Charge
			specWarnPhase2Soon:Show()
			specWarnPhase2Soon:Play("ptwo")
			timerPhase2Start:Start()--Phase 2 starts 5 seconds after 3rd add casts static charge regardless of whether or not other adds are dead.
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 84589 then
		warnDeflectingWinds:Show()
	elseif spellId == 83066 then
		warnWailingWinds:Show()
		timerWailingWinds:Start()
	elseif spellId == 83151 then
		warnAbsorbStorms:Show()
		timerAbsorbStorms:Start()
	end
end

function mod:SPELL_SUMMON(args)
	if args:IsSpellID(84547, 84553, 84554) then
		self.vb.servantSpawn = self.vb.servantSpawn + 1
		warnStaticShock:Show(self.vb.servantSpawn)
		if self.vb.thirdServant == 3 then--Third add spawned
			self.vb.thirdServant = args.destGUID
		end
	end
end