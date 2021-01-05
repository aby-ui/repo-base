local _, T = ...
local EV = T.Evie

local mapOpened, addonLoaded
function EV:ADVENTURE_MAP_OPEN(followerID)
	if mapOpened and addonLoaded then
		return "remove"
	end
	mapOpened = followerID == 123
	if mapOpened and IsAddOnLoaded("Blizzard_GarrisonUI") then
		addonLoaded = true
		EV("I_ADVENTURES_UI_LOADED")
	end
end
function EV:ADDON_LOADED(aname)
	if aname == "Blizzard_GarrisonUI" and not addonLoaded then
		addonLoaded = true
		if mapOpened then
			EV("I_ADVENTURES_UI_LOADED")
		end
		return "remove"
	end
end