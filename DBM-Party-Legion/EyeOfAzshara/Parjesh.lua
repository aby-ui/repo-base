local mod	= DBM:NewMod(1480, "DBM-Party-Legion", 3, 716)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220217011830")
mod:SetCreatureID(91784)
mod:SetEncounterID(1810)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 192094",
	"SPELL_CAST_START 192072 192073 196563 197502 191900"
)

--Notes: Boss always casts 191900 (Crashing wave) few seconds before impaling spear. It doesn't really need it's own warning
--TODO, interrupt warnings for adds maybe.
local warnImpalingSpear				= mod:NewTargetNoFilterAnnounce(192094, 4)

local specWarnReinforcements		= mod:NewSpecialWarningSwitch(192072, "Tank", nil, nil, 1, 2)
local specWarnCrashingwave			= mod:NewSpecialWarningDodge(191900, nil, nil, nil, 2, 2)
local specWarnImpalingSpear			= mod:NewSpecialWarningMoveTo(192094, nil, nil, nil, 3, 8)
local yellImpalingSpear				= mod:NewYell(192094)
local specWarnRestoration			= mod:NewSpecialWarningInterrupt(197502, "HasInterrupt", nil, nil, 1, 2)

local timerHatecoilCD				= mod:NewCDTimer(28, 192072, nil, nil, nil, 1)--Review more for sequence
local timerSpearCD					= mod:NewCDTimer(28, 192094, nil, nil, nil, 3)

mod.vb.firstReinforcement = 0--1 melee 2 cacster

function mod:OnCombatStart(delay)
	self.vb.firstReinforcement = 0
--	timerHatecoilCD:Start(3-delay)--Instantly on pull
	timerSpearCD:Start(28-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 192094 then
		timerSpearCD:Start()
		if args:IsPlayer() then
			specWarnImpalingSpear:Show(DBM_COMMON_L.ADDS)
			yellImpalingSpear:Yell()
			specWarnImpalingSpear:Play("behindmob")
		else
			warnImpalingSpear:Show(args.destName)
		end
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 192073 and self:IsNormal() then--Caster mob
		specWarnReinforcements:Show()
		specWarnReinforcements:Play("bigmobsoon")
		if self.vb.firstReinforcement == 0 then
			self.vb.firstReinforcement = 2
		end
		timerHatecoilCD:Start(self.vb.firstReinforcement == 2 and 20 or 32)
	elseif spellId == 192072 and self:IsNormal() then--Melee mob
		specWarnReinforcements:Show()
		specWarnReinforcements:Play("bigmobsoon")
		if self.vb.firstReinforcement == 0 then
			self.vb.firstReinforcement = 1
		end
		timerHatecoilCD:Start(self.vb.firstReinforcement == 1 and 20 or 32)
	elseif spellId == 196563 then--Both of them (heroic+)
		specWarnReinforcements:Show()
		specWarnReinforcements:Play("bigmobsoon")
		timerHatecoilCD:Start()
	elseif spellId == 197502 then
		specWarnRestoration:Show(args.sourceName)
		specWarnRestoration:Play("kickcast")
	elseif spellId == 191900 then
		specWarnCrashingwave:Show()
		specWarnCrashingwave:Play("chargemove")
	end
end
