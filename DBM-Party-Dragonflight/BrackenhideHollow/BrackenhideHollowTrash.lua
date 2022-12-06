local mod	= DBM:NewMod("BrackenhideHollowTrash", "DBM-Party-Dragonflight", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221205015333")
--mod:SetModelID(47785)
mod.isTrashMod = true

mod:RegisterEvents(
	"SPELL_CAST_START 382555 367500 388060",
	"SPELL_AURA_APPLIED 382555 383087"
--	"SPELL_AURA_APPLIED_DOSE 339528",
--	"SPELL_AURA_REMOVED 339525"
)

local warnHidiousCackle						= mod:NewCastAnnounce(367500, 4)
local warnWitheringContagion				= mod:NewTargetAnnounce(383087, 3)

local specWarnRagestorm						= mod:NewSpecialWarningRun(382555, "Melee", nil, nil, 4, 2)
local specWarnRagestormDispel				= mod:NewSpecialWarningDispel(382555, "RemoveEnrage", nil, nil, 1, 2)
local specWarnWitheringContagion			= mod:NewSpecialWarningMoveAway(383087, nil, nil, nil, 1, 2)
local specWarnStinkBreath					= mod:NewSpecialWarningDodge(388060, nil, nil, nil, 2, 2)
local yellWitheringContagion				= mod:NewYell(383087)

local specWarnHidiousCackle					= mod:NewSpecialWarningInterrupt(367500, "HasInterrupt", nil, nil, 1, 2)

--local playerName = UnitName("player")

--Antispam IDs for this mod: 1 run away, 2 dodge, 3 dispel, 4 incoming damage, 5 you/role, 6 misc

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 382555 and self:AntiSpam(3, 1) then
		specWarnRagestorm:Show()
		specWarnRagestorm:Play("justrun")
	elseif spellId == 367500 then
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnHidiousCackle:Show(args.sourceName)
			specWarnHidiousCackle:Play("kickcast")
		elseif self:AntiSpam(3, 5) then
			warnHidiousCackle:Show()
		end
	elseif spellId == 388060 and self:AntiSpam(3, 2) then
		specWarnStinkBreath:Show()
		specWarnStinkBreath:Play("shockwave")
	end
end


function mod:SPELL_AURA_APPLIED(args)
	if not self.Options.Enabled then return end
	local spellId = args.spellId
	if spellId == 382555 and self:AntiSpam(3, 5) then
		specWarnRagestormDispel:Show(args.destName)
		specWarnRagestormDispel:Play("enrage")
	elseif spellId == 383087 then
		warnWitheringContagion:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			specWarnWitheringContagion:Show()
			specWarnWitheringContagion:Play("range5")
			yellWitheringContagion:Yell()
		end
	end
end
--mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

--[[
function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 339525 and args:IsPlayer() then

	end
end
--]]
