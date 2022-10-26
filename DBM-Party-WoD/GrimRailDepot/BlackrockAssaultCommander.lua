local mod	= DBM:NewMod(1163, "DBM-Party-WoD", 3, 536)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "normal,heroic,mythic,challenge,timewalker"
mod.upgradedMPlus = true

mod:SetRevision("20221015205747")
mod:SetCreatureID(79545)
mod:SetEncounterID(1732)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 160681 166570",
	"SPELL_AURA_APPLIED_DOSE 160681 166570",
	"SPELL_CAST_START 163550 160680 160943",
	"UNIT_TARGETABLE_CHANGED"
)

--[[
(ability.id = 163550 or ability.id = 160680 or ability.id = 160943) and type = "begincast"
 or ability.id = 181089 and type = "applybuff"
--]]
local warnMortar				= mod:NewSpellAnnounce(163550, 3)
local warnPhase2				= mod:NewPhaseAnnounce(2, 2, nil, nil, nil, nil, nil, 2)
local warnSupressiveFire		= mod:NewTargetNoFilterAnnounce(160681, 2)--In a repeating loop
--local warnGrenadeDown			= mod:NewAnnounce("warnGrenadeDown", 1, "ej9711", nil, DBM_CORE_L.AUTO_ANNOUNCE_OPTIONS.spell:format("ej9711"))--Boss is killed by looting using these positive items on him.
--local warnMortarDown			= mod:NewAnnounce("warnMortarDown", 4, "ej9712", nil, DBM_CORE_L.AUTO_ANNOUNCE_OPTIONS.spell:format("ej9712"))--So warn when adds that drop them die
local warnPhase3				= mod:NewPhaseAnnounce(3, 2, nil, nil, nil, nil, nil, 2)

local specWarnSupressiveFire	= mod:NewSpecialWarningYou(160681, nil, nil, nil, 1, 2)
local yellSupressiveFire		= mod:NewYell(160681)
local specWarnShrapnelblast		= mod:NewSpecialWarningDodge(160943, nil, nil, 2, 3, 2)--160943 boss version, 166675 trash version.
local specWarnSlagBlast			= mod:NewSpecialWarningMove(166570, nil, nil, nil, 1, 8)

local timerSupressiveFire		= mod:NewTargetTimer(10, 160681, nil, nil, nil, 5)

local grenade = DBM:EJ_GetSectionInfo(9711)
local mortar = DBM:EJ_GetSectionInfo(9712)

function mod:SupressiveFireTarget(targetname, uId)
	if not targetname then return end
	if targetname == UnitName("player") then
		specWarnSupressiveFire:Show()
		specWarnSupressiveFire:Play("findshelter")
		yellSupressiveFire:Yell()
	else
		warnSupressiveFire:Show(targetname)
	end
end

function mod:OnCombatStart(delay)
	self:SetStage(1)
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 160681 and args:IsDestTypePlayer() then
		timerSupressiveFire:Start(args.destName)
	elseif spellId == 166570 and args.destGUID == UnitGUID("player") and self:AntiSpam() then
		specWarnSlagBlast:Show()
		specWarnSlagBlast:Play("watchfeet")
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 163550 then
		warnMortar:Show()
	elseif spellId == 160680 then
		self:BossTargetScanner(79548, "SupressiveFireTarget", 0.2, 15)
	elseif spellId == 160943 and self:AntiSpam(2, 1) then
		if self:IsTanking("player", nil, nil, true, args.sourceGUID) then
			specWarnShrapnelblast:Show()
			specWarnShrapnelblast:Play("shockwave")
		end
	end
end

function mod:UNIT_TARGETABLE_CHANGED()
	self:SetStage(0)
	if self.vb.phase == 2 then
		warnPhase2:Show()
		warnPhase2:Play("ptwo")
	elseif self.vb.phase == 3 then
		warnPhase3:Show()
		warnPhase3:Play("pthree")
	end
end
