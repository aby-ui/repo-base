local mod	= DBM:NewMod("CrucibleofStormsTrash", "DBM-CrucibleofStorms")
local L		= mod:GetLocalizedStrings()

<<<<<<< HEAD
mod:SetRevision("20190808015842")
=======
mod:SetRevision("20190806183534")
>>>>>>> 0c4c352d04b9b16e45411ea8888c232424c574e4
--mod:SetModelID(47785)
mod:SetZone()
mod.isTrashMod = true

mod:RegisterEvents(
	"SPELL_CAST_START 293957"
)

local specWarnMaddeningGaze				= mod:NewSpecialWarningDodge(293957, nil, nil, nil, 2, 2)

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 293957 and self:AntiSpam(4, 1) then
		specWarnMaddeningGaze:Show()
		specWarnMaddeningGaze:Play("shockwave")
	end
end
