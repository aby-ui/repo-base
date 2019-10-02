local mod	= DBM:NewMod("Rabbit", "DBM-DMF")
local L		= mod:GetLocalizedStrings()

<<<<<<< HEAD
mod:SetRevision("20190808015842")
=======
mod:SetRevision("20190806183534")
>>>>>>> 0c4c352d04b9b16e45411ea8888c232424c574e4
mod:SetCreatureID(58336)
mod:SetModelID(328)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 114078"
)

local warnTeeth				= mod:NewTargetAnnounce(114078, 4)

local yellTeeth				= mod:NewYell(114078)

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 114078 then
		warnTeeth:Show(args.destName)
		if args:IsPlayer() then
			yellTeeth:Yell()
		end
	end
end
