local mod	= DBM:NewMod("Emalon", "DBM-VoA")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417005949")
mod:SetCreatureID(33993)
mod:SetEncounterID(1127)
mod:SetModelID(27108)
mod:SetUsedIcons(8)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 64216 65279",
	"SPELL_HEAL 64218",
	"SPELL_AURA_APPLIED 64217",
	"SPELL_AURA_REMOVED 64217"
)

local warnOverCharge		= mod:NewSpellAnnounce(64218, 4)

local specWarnNova			= mod:NewSpecialWarningRun(65279, nil, nil, nil, 4, 2)

local timerNova				= mod:NewCastTimer(65279, nil, nil, nil, 2)
local timerNovaCD			= mod:NewCDTimer(45, 65279, nil, nil, nil, 2)--Varies, 45-60seconds in between nova's
local timerOvercharge		= mod:NewNextTimer(45, 64218, nil, nil, nil, 5, nil, DBM_CORE_DAMAGE_ICON)
local timerMobOvercharge	= mod:NewTimer(20, "timerMobOvercharge", 64217, nil, nil, 5, DBM_CORE_DAMAGE_ICON)

local timerEmalonEnrage		= mod:NewTimer(360, "EmalonEnrage", 26662)

mod:AddBoolOption("RangeFrame")
mod:AddSetIconOption("SetIconOnOvercharge", 64218, true, true)

function mod:OnCombatStart(delay)
	timerOvercharge:Start(-delay)
	timerNovaCD:Start(20-delay)
	timerEmalonEnrage:Start(-delay)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(10)
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 64216 or args.spellId == 65279 then
		timerNova:Start()
		timerNovaCD:Start()
		specWarnNova:Show()
		specWarnNova:Play("justrun")
	end
end

function mod:SPELL_HEAL(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 64218 then
		warnOverCharge:Show()
		timerOvercharge:Start()
		if self.Options.SetIconOnOvercharge then
			self:ScanForMobs(destGUID, 2, 8, 1, 0.2, 10, "SetIconOnOvercharge")
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 64217 then	-- 1 of 10 stacks (+1 each 2 seconds)
		timerMobOvercharge:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 64217 then
		timerMobOvercharge:Stop()
	end
end

