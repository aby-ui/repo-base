local _, T = ...
if T.Mark ~= 50 then return end
local G, L, E = T.Garrison, T.L, T.Evie
local Nine = T.Nine or _G
local C_Garrison = Nine.C_Garrison

local function HookOnShow(self, OnShow)
	self:HookScript("OnShow", OnShow)
	if self:IsVisible() then OnShow(self) end
end

function T.SetCacheTooltip(GameTooltip, current, cv, mv, st, md)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(GARRISON_CACHE)
	local tl = st+md-GetServerTime()
	if tl > 5400 then
		tl = SPELL_TIME_REMAINING_HOURS:format((tl+3599)/3600)
	elseif tl > 90 then
		tl = SPELL_TIME_REMAINING_MIN:format((tl+59)/60)
	elseif tl > 0 then
		tl = SPELL_TIME_REMAINING_SEC:format(tl)
	else
		tl = nil
	end
	if tl then
		GameTooltip:AddLine(tl, 0.25,1,0.15)
	end
	GameTooltip:AddLine(" ")
	if cv and cv > 0 then
		local cc = cv == mv and 0.1 or 1
		GameTooltip:AddLine(GARRISON_LANDING_COMPLETED:format(cv, mv), cc,1,cc)
	end
	if type(current) == "number" then
		local cc = HIGHLIGHT_FONT_COLOR_CODE
		if current == 1e4 then
			cc = RED_FONT_COLOR_CODE
		elseif current + cv >= 1e4 then
			cc = ORANGE_FONT_COLOR_CODE
		end
		GameTooltip:AddLine("\n" .. CURRENCY_TOTAL_CAP:format(cc, current, 1e4))
	end
	GameTooltip:Show()
end
function T.SetRecruitTooltip(GameTooltip, recruitTime)
	GameTooltip:SetText((select(2, C_Garrison.GetBuildingInfo(35))))
	local dt = GetServerTime()-recruitTime
	if dt < 604800 then
		GameTooltip:AddLine("\n" .. (L"Last recruited: %s ago"):format("|cffffffff" .. SecondsToTime(dt) .. "|r"))
	else
		GameTooltip:AddLine("|n" .. GREEN_FONT_COLOR_CODE .. AVAILABLE)
	end
	GameTooltip:Show()
end

local function Ship_OnEnter(self, ...)
	if self.buildingID == -1 and self.plotID == -42 then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		T.SetCacheTooltip(GameTooltip, select(2, Nine.GetCurrencyInfo(824)), G.GetResourceCacheInfo())
		self.UpdateTooltip = Ship_OnEnter
	elseif self.buildingID == -1 and self.plotID == -43 then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		T.SetRecruitTooltip(GameTooltip, select(3,G.GetRecruitInfo()))
		self.UpdateTooltip = Ship_OnEnter
	else
		GarrisonLandingPageReportShipment_OnEnter(self, ...)
		local n = C_Garrison.GetFollowerInfoForBuilding(self.plotID)
		if n and GameTooltip:IsShown() then
			GameTooltipTextLeft2:SetText(GARRISON_LANDING_SHIPMENT_LABEL .. " |cff909090(" .. n .. ")")
			GameTooltip:Show()
		end
	end
end
local function Ship_SetCache(ship)
	local cv, mv, st, md = G.GetResourceCacheInfo()
	if not (ship and cv) then return end
	ship:SetScript("OnEnter", Ship_OnEnter)
	ship.Done:SetShown(cv == mv)
	ship.Border:SetShown(cv < mv)
	ship.BG:SetShown(cv < mv)
	ship.Count:SetText(cv > 0 and cv or "")
	SetPortraitToTexture(ship.Icon, "Interface\\Icons\\INV_Garrison_Resource")
	ship.Icon:SetDesaturated(true)
	ship.Name:SetText(GARRISON_CACHE)
	if cv == mv then
		ship.Swipe:SetCooldownUNIX(0, 0);
	else
		ship.Swipe:SetCooldownUNIX(st, md);
	end
	ship.buildingID, ship.plotID = -1, -42
	ship:Show()
	return true
end
local function Ship_SetRecruit(ship)
	local dt, lim = G.GetRecruitInfo()
	if not (ship and dt and G.HasLevelTwoInn()) then return end
	ship:SetScript("OnEnter", Ship_OnEnter)
	local done = dt >= lim
	ship.Done:SetShown(done)
	ship.Border:SetShown(not done)
	ship.BG:SetShown(not done)
	ship.Count:SetText("")
	SetPortraitToTexture(ship.Icon, "Interface\\Icons\\INV_Garrison_Hearthstone")
	ship.Icon:SetDesaturated(true)
	ship.Name:SetText((select(2, C_Garrison.GetBuildingInfo(35))))
	if done then
		ship.Swipe:SetCooldownUNIX(0, 0);
	else
		ship.Swipe:SetCooldownUNIX(GetServerTime()-dt, lim);
	end
	ship.buildingID, ship.plotID = -1, -43
	ship:Show()
	return true
end
hooksecurefunc("GarrisonLandingPageReport_GetShipments", function(self)
	if GarrisonLandingPage.garrTypeID >= 3 then return end
	local index, ship = self.shipmentsPool.numActiveObjects, self.shipmentsPool:Acquire()
	ship:SetPoint("TOPLEFT", 60 + mod(index, 3) * 105, -105 - floor(index / 3) * 100)
	if Ship_SetRecruit(ship) then
		index, ship = self.shipmentsPool.numActiveObjects, self.shipmentsPool:Acquire()
		ship:SetPoint("TOPLEFT", 60 + mod(index, 3) * 105, -105 - floor(index / 3) * 100)
	end
	if not Ship_SetCache(ship) then
		self.shipmentsPool:Release(ship)
	end
end)

function E:SHOW_LOOT_TOAST(rt, rl, _q, _4, _5, _6, source)
	if rt == "currency" and source == 10 and rl:match("currency:824") and GarrisonLandingPageReport:IsVisible() then
		GarrisonLandingPageReport_GetShipments(GarrisonLandingPageReport)
	end
end
local function addCacheResources(self, id)
	if id == 824 then
		local cv, mv = G.GetResourceCacheInfo()
		if cv and cv > 0 then
			self:AddLine(GARRISON_CACHE .. ": |cffff" .. (cv < mv and "ffff" or "1010") .. BreakUpLargeNumbers(cv) .. "/" .. BreakUpLargeNumbers(mv))
			self:Show()
		end
	end
end
local function addCacheResourcesByLink(self, idx)
	addCacheResources(self, tonumber((Nine.GetCurrencyListLink(idx) or ""):match("currency:(%d+)") or 0))
end
for i=1,GameTooltip ~= _G.GameTooltip and 2 or 1 do
	local tip = i == 1 and GameTooltip or _G.GameTooltip
	hooksecurefunc(tip, "SetCurrencyByID", addCacheResources)
	hooksecurefunc(tip, "SetCurrencyTokenByID", addCacheResources)
	hooksecurefunc(tip, "SetCurrencyToken", addCacheResourcesByLink)
end
hooksecurefunc(GarrisonLandingPage.Report.shipmentsPool, "ReleaseAll", function(self)
	local o = self.inactiveObjects
	for i=1,o and #o or 0 do
		if o[i].Swipe then
			-- Subsequent Acquire/Setup might not reset the swipe
			o[i].Swipe:Hide()
		end
	end
end)

local function ShowReportMissionExpirationTime()
	if GarrisonLandingPage.garrTypeID >= 3 then return end
	local items, buttons = GarrisonLandingPageReport.List.AvailableItems, GarrisonLandingPageReport.List.listScroll.buttons
	for i=1,#buttons do
		local item = buttons[i]:IsShown() and items[buttons[i].id]
		if item and item.offerTimeRemaining and item.offerEndTime then
			if item.offerEndTime - 8640000 <= GetTime() then
				buttons[i].MissionType:SetFormattedText("%s |cffa0a0a0(%s %s)|r",
					item.durationSeconds >= GARRISON_LONG_MISSION_TIME and (GARRISON_LONG_MISSION_TIME_FORMAT):format(item.duration) or item.duration,
					L"Expires in:", item.offerTimeRemaining)
			end
		end
	end
end
hooksecurefunc("GarrisonLandingPageReportList_UpdateAvailable", ShowReportMissionExpirationTime)
if GarrisonLandingPageReport:IsVisible() then ShowReportMissionExpirationTime() end

local hs = T.CreateLazyItemButton(GarrisonLandingPageReport, 110560)
hs:SetSize(24, 24)
hs:SetPoint("LEFT", GarrisonLandingPage, "TOPLEFT", 40, -63)
hs.Count:Hide()
HookOnShow(GarrisonLandingPageReport, function()
	local show = GarrisonLandingPage.garrTypeID < 3
	GarrisonLandingPageReport.Title:SetPoint("LEFT", GarrisonLandingPage.HeaderBar, "LEFT", show and 40 or 20, 0)
	hs:SetShown(show)
end)