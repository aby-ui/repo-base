local AN, T, EV, U = ...
_G[AN], EV, U = 22, T.Evie, T.Util

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

SLASH_VENTUREPLAN1, SLASH_VENTUREPLAN2 = "/ventureplan", "/vp"
function SlashCmdList.VENTUREPLAN(msg)
	local v, at, a = msg:match("^%s*(%S+)%s*(.-)$")
	if v == "set-campaign-progress" then
		a = tonumber(at)
		if a and a >= 0 and a <= 20 or at == "nil" then
			U.SetCurrencyValueShiftTarget(1889, a)
		end
		local c = C_CurrencyInfo.GetCurrencyInfo(1889)
		c = U.GetShiftedCurrencyValue(1889, c and c.quantity) or "{0..20}"
		print("|cff20a0ff/ventureplan |r|cffffffffset-campaign-progress|r |cff20ff20" .. c .. "|r|cffa0a0a0|||r|cff20ff20nil")
		return
	end
	print("|cff20a0ffVenture Plan |r|cffffffff" .. GetAddOnMetadata("VenturePlan", "Version"))
end
