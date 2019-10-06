local mod	= DBM:NewMod(622, "DBM-Party-WotLK", 9, 282)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(27654)
mod:SetEncounterID(528, 529, 2016)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"UNIT_DIED"
)

mod:AddBoolOption("MakeitCountTimer", true, "timer")

function mod:UNIT_DIED(args)
	if not self:IsDifficulty("normal5") then
		if self.Options.MakeitCountTimer and not DBM.Bars:GetBar(L.MakeitCountTimer) then
			local cid = self:GetCIDFromGUID(args.destGUID)
			if cid == 27654 then		-- Drakos The Interrogator
				DBM.Bars:CreateBar(1200, L.MakeitCountTimer)
			end
		end
	end
end