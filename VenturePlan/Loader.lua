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

function EV:ADDON_LOADED()
	if CovenantSanctumFrame and CovenantSanctumFrame.UpgradesTab then
		local d = CovenantSanctumFrame.UpgradesTab.DepositButton
		if d and COVENANT_SANCTUM_TUTORIAL4 then
			d:HookScript("PreClick", function(self)
				local na = HelpTip and HelpTip.framePool and HelpTip.framePool.numActiveObjects
				if type(na) == "number" and na > 0 then
					HelpTip:Acknowledge(self:GetParent(), COVENANT_SANCTUM_TUTORIAL4)
					HelpTip.framePool:ReleaseAll()
				end
			end)
		end
		return "remove"
	end
end
