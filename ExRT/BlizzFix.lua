local GlobalAddonName, ExRT = ...

-- RELOAD UI short command
SLASH_RELOADUI1 = "/rl"
SlashCmdList["RELOADUI"] = ReloadUI

if ExRT.isClassic then
	if not SpecializationSpecName then
		SpecializationSpecName = ExRT.NULLfunc
	end
end