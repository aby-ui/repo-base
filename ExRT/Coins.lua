local GlobalAddonName, ExRT = ...

if ExRT.isClassic then
	return
end 

local module = ExRT.mod:New("Coins",ExRT.L.Coins,true)
local ELib,L = ExRT.lib,ExRT.L

function module.main:ADDON_LOADED()
	if VExRT then
		VExRT.Coins = nil
	end
end