local mod	= DBM:NewMod(859, "DBM-Pandaria", nil, 322, 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 122 $"):sub(12, -3))
mod:SetCreatureID(71954)
mod:SetReCombatTime(20)
mod:SetZone()

mod:RegisterCombat("combat_yell", L.Pull)
mod:RegisterKill("yell", L.Victory, L.VictoryDem)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 144610 144611 144608",
	"SPELL_AURA_APPLIED 144606",
	"SPELL_AURA_APPLIED_DOSE 144606",
	"UNIT_SPELLCAST_SUCCEEDED target focus"
)

local warnOxenFortitude			= mod:NewStackAnnounce(144606, 2, nil, false)--144607 player version, but better to just track boss and announce stacks

local specWarnHeadbutt			= mod:NewSpecialWarningSpell(144610, "Tank")
local specWarnMassiveQuake		= mod:NewSpecialWarningSpell(144611, nil, nil, nil, 2)
local specWarnCharge			= mod:NewSpecialWarningDodge(144609, "Melee")--66 and 33%. Maybe add pre warns

local timerHeadbuttCD			= mod:NewCDTimer(47, 144610, nil, "Tank", nil, 5)
local timerMassiveQuake			= mod:NewBuffActiveTimer(13, 144611)
local timerMassiveQuakeCD		= mod:NewCDTimer(48, 144611, nil, nil, nil, 2)

mod:AddReadyCheckOption(33117, false)

function mod:OnCombatStart(delay, yellTriggered)
	if yellTriggered then
		timerHeadbuttCD:Start(16-delay)
		timerMassiveQuakeCD:Start(45-delay)
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 144610 then
		specWarnHeadbutt:Show()
		timerHeadbuttCD:Start()
	elseif spellId == 144611 then
		specWarnMassiveQuake:Show()
		timerMassiveQuake:Start()
		timerMassiveQuakeCD:Start()
	elseif spellId == 144608 then
		specWarnCharge:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 144606 then
		warnOxenFortitude:Show(args.destName, args.amount or 1)
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 148318 or spellId == 148317 or spellId == 149304 and self:AntiSpam(3, 2) then--use all 3 because i'm not sure which ones fire on repeat kills
		self:SendSync("Victory")
	end
end

function mod:OnSync(msg)
	if msg == "Victory" and self:IsInCombat() then
		DBM:EndCombat(self)
	end
end
