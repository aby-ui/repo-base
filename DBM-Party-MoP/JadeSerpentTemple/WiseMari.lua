local mod	= DBM:NewMod(672, "DBM-Party-MoP", 1, 313)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 111 $"):sub(12, -3))
mod:SetCreatureID(56448)
mod:SetEncounterID(1418)
mod:SetZone()
mod:SetUsedIcons(8)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 106653",
	"SPELL_CAST_START 106526 106612",
	"SPELL_DAMAGE 115167",
	"SPELL_MISSED 115167",
	"UNIT_DIED",
	"UNIT_TARGET_UNFILTERED"
)

local warnBubbleBurst			= mod:NewCastAnnounce(106612, 3)
local warnAddsLeft				= mod:NewAddsLeftAnnounce("ej5616", 2, 106526)

local specWarnLivingWater		= mod:NewSpecialWarningSwitch("ej5616", "-Healer")
local specWarnCorruptingWaters	= mod:NewSpecialWarningMove(115167)
local specWarnShaResidue		= mod:NewSpecialWarningMove(106653)

local timerLivingWater			= mod:NewCastTimer(5.5, 106526)
--local timerLivingWaterCD		= mod:NewCDTimer(13, 106526, nil, nil, nil, 1)
local timerWashAway				= mod:NewNextTimer(8, 106334)

mod:AddBoolOption("SetIconOnAdds", false)

mod.vb.addsRemaining = 4--Also 4 on heroic?
mod.vb.firstAdd = false
local addsName = DBM:EJ_GetSectionInfo(5616)

function mod:UNIT_TARGET_UNFILTERED()
	if self.Options.SetIconOnAdds and not DBM.Options.DontSetIcons and UnitName("target") == addsName then
		SetRaidTarget("target", 8)
	end
end

function mod:OnCombatStart(delay)
	self.vb.addsRemaining = 4
	self.vb.firstAdd = false
	timerLivingWater:Start(13-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 106653 and args:IsPlayer() and self:AntiSpam(4, 1) then
		specWarnShaResidue:Show()
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 106526 then--Call Water
		if not self.vb.firstAdd then
			self.vb.firstAdd = true
		else
			timerLivingWater:Start()
		end
		specWarnLivingWater:Schedule(5.5)
	elseif args.spellId == 106612 then--Bubble Burst (phase 2)
		warnBubbleBurst:Show()
		timerWashAway:Start()
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 115167 and destGUID == UnitGUID("player") and self:AntiSpam(2, 1) then
		specWarnCorruptingWaters:Show()
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 56511 then--Corrupt Living Water
		self.vb.addsRemaining = self.vb.addsRemaining - 1
		warnAddsLeft:Show(self.vb.addsRemaining)
	end
end
