local mod	= DBM:NewMod("GRDTrash", "DBM-Party-WoD", 3)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221015205747")
--mod:SetModelID(47785)

mod.isTrashMod = true

mod:RegisterEvents(
	"SPELL_AURA_APPLIED 176025 166340 171900",
	"SPELL_AURA_APPLIED_DOSE 166340",
	"SPELL_CAST_START 166675 176032",
	"SPELL_CAST_SUCCESS 163966",
	"SPELL_PERIODIC_DAMAGE 176033",
	"SPELL_ABSORBED 176033"
)

--TODO, add https://www.wowhead.com/spell=166380/reckless-slash ?
local warnLavaWreath					= mod:NewTargetNoFilterAnnounce(176025, 4)
local warnThunderousBreath				= mod:NewSpellAnnounce(171900, 3)

local specWarnActivating				= mod:NewSpecialWarningInterrupt(163966, false, nil, 2, 1, 8)
local specWarnLavaWreath				= mod:NewSpecialWarningMoveAway(176025, nil, nil, nil, 1, 2)
local specWarnFlametongueGround			= mod:NewSpecialWarningMove(176033, nil, nil, nil, 1, 8)--Ground aoe, may add an earlier personal warning if target scanning works.
local specWarnShrapnelblast				= mod:NewSpecialWarningDodge(166675, nil, nil, 2, 3, 2)--160943 boss version, 166675 trash version.
local specWarnThunderzone				= mod:NewSpecialWarningMove(166340, nil, nil, nil, 1, 8)

function mod:SPELL_AURA_APPLIED(args)
	if not self.Options.Enabled then return end
	local spellId = args.spellId
	if spellId == 176025 then
		if args:IsPlayer() then
			specWarnLavaWreath:Show()
			specWarnLavaWreath:Play("runout")
		else
			warnLavaWreath:Show(args.destName)
		end
	elseif spellId == 166340 and args:IsPlayer() and self:AntiSpam(2, 3) then
		specWarnThunderzone:Show()
		specWarnThunderzone:Play("watchfeet")
	elseif spellId == 171900 then
		warnThunderousBreath:Show()
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_CAST_START(args)
	if not self.Options.Enabled then return end
	local spellId = args.spellId
	if spellId == 166675 and self:AntiSpam(2, 1) then
		if self:IsTanking("player", nil, nil, true, args.sourceGUID) then
			specWarnShrapnelblast:Show()
			specWarnShrapnelblast:Play("shockwave")
		end
	elseif spellId == 176032 then
		if self:IsTank() then
			specWarnFlametongueGround:Show()--Pre warn here for tanks, because this attack also massively buffs trash damage if they are standing in the fire too.
			specWarnFlametongueGround:Play("watchfeet")
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if not self.Options.Enabled then return end
	local spellId = args.spellId
	if spellId == 163966 and self:AntiSpam(3, 3) then
		specWarnActivating:Show(args.sourceName)
		specWarnActivating:Play("crowdcontrol")
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 176033 and destGUID == UnitGUID("player") and self:AntiSpam(2, 2) and not self:IsTrivial() then
		specWarnFlametongueGround:Show()
		specWarnFlametongueGround:Play("watchfeet")
	end
end
mod.SPELL_ABSORBED = mod.SPELL_PERIODIC_DAMAGE
