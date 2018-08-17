local addonName, T = ...
local E, api, cdata = T.Evie, {}

local function gett(t, k, ...)
	if not k then
		return t
	elseif type(t[k]) ~= "table" then
		t[k] = {}
	end
	return gett(t[k], ...)
end

local CheckCacheWarning do
	local ag = GarrisonLandingPageMinimapButton:CreateAnimationGroup()
	ag:SetLooping("REPEAT")
	local tex = GarrisonLandingPageMinimapButton:CreateTexture(nil, "ARTWORK")
	tex:SetPoint("CENTER")
	tex:SetAtlas("GarrLanding-CircleGlow", true)
	tex:SetBlendMode("ADD")
	tex:SetAlpha(0)
	tex:SetVertexColor(1, 0, 0)
	GarrisonLandingPageMinimapButton.MPWarningTexture = tex
	local SCALE_MAX, SCALE_MIN = 1.1, 0.9
	local a = ag:CreateAnimation("Scale")
	a:SetToScale(SCALE_MAX, SCALE_MAX)
	a:SetStartDelay(5)
	a:SetDuration(1)
	a:SetOrder(1)
	a:SetChildKey("MPWarningTexture")
	a = ag:CreateAnimation("Scale")
	a:SetToScale(SCALE_MIN, SCALE_MIN)
	a:SetOrder(2)
	a:SetDuration(1)
	a:SetChildKey("MPWarningTexture")
	a = ag:CreateAnimation("Alpha")
	a:SetDuration(1)
	a:SetFromAlpha(0)
	a:SetToAlpha(1)
	a:SetStartDelay(5)
	a:SetOrder(1)
	a:SetChildKey("MPWarningTexture")
	a = ag:CreateAnimation("Alpha")
	a:SetDuration(1)
	a:SetFromAlpha(1)
	a:SetToAlpha(0)
	a:SetOrder(2)
	a:SetChildKey("MPWarningTexture")
	ag:SetScript("OnStop", function()
		tex:SetAlpha(0)
	end)
	local UNIT_TIME, WARN_BUFFER, mute = 600, 96, false
	GarrisonLandingPageMinimapButton:HookScript("OnClick", function()
		mute = true
		ag:Stop()
	end)
	function CheckCacheWarning()
		local lct = C_Garrison.IsOnGarrisonMap() and cdata and cdata.lastCacheTime
		local td, sz = lct and (GetServerTime()-lct)/UNIT_TIME or 0, tonumber(cdata and cdata.cacheSize) or 500
		if td >= (sz-WARN_BUFFER) then
			tex:SetVertexColor(1, td >= sz and 0 or 0.35, 0)
			if not (mute or ag:IsPlaying()) then
				ag:Play()
			end
		else
			ag:Stop()
			mute = false
		end
	end
end
local LoadMPOnShow, LoadMP do
	local doLoad = true
	function LoadMP()
		if doLoad then
			doLoad = nil
			LoadAddOn("MasterPlan")
		end
	end
	function LoadMPOnShow(f)
		if f:IsShown() then
			LoadMP()
		elseif doLoad then
			f:HookScript("OnShow", LoadMP)
		end
	end
end
local function ShowLanding(page)
	HideUIPanel(GarrisonLandingPage)
	ShowGarrisonLandingPage(page)
	if page and page < 3 then
		LoadMP()
	end
end
local function MaybeStopSound(sound)
	return sound and StopSound(sound)
end
local landingChoiceMenu, landingChoices
GarrisonLandingPageMinimapButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
GarrisonLandingPageMinimapButton:HookScript("PreClick", function(self, b)
	self.landingVisiblePriorToClick = GarrisonLandingPage and GarrisonLandingPage:IsVisible() and GarrisonLandingPage.garrTypeID
	if b == "RightButton" then
		local openOK, openID = PlaySound(SOUNDKIT.UI_GARRISON_GARRISON_REPORT_OPEN)
		local closeOK, closeID = PlaySound(SOUNDKIT.UI_GARRISON_GARRISON_REPORT_CLOSE)
		self.openSoundID = openOK and openID
		self.closeSoundID = closeOK and closeID
	end
end)
GarrisonLandingPageMinimapButton:HookScript("OnClick", function(self, b)
	if b == "LeftButton" then
		if GarrisonLandingPage.garrTypeID ~= C_Garrison.GetLandingPageGarrisonType() then
			ShowLanding(C_Garrison.GetLandingPageGarrisonType())
		end
		return
	elseif b == "RightButton" then
		if (C_Garrison.GetLandingPageGarrisonType() or 0) > 3 then
			if self.landingVisiblePriorToClick then
				ShowLanding(self.landingVisiblePriorToClick)
			else
				HideUIPanel(GarrisonLandingPage)
			end
			MaybeStopSound(self.openSoundID)
			MaybeStopSound(self.closeSoundID)
			if not landingChoiceMenu then
				landingChoiceMenu = CreateFrame("Frame", "MP_LandingChoicesDrop", UIParent, "UIDropDownMenuTemplate")
				local function ShowLanding_(_, ...)
					return ShowLanding(...)
				end
				landingChoices = {
					{text=GARRISON_LANDING_PAGE_TITLE, func=ShowLanding_, arg1=2, notCheckable=true},
					{text=ORDER_HALL_LANDING_PAGE_TITLE, func=ShowLanding_, arg1=3, notCheckable=true},
					{text=WAR_CAMPAIGN, func=ShowLanding_, arg1=C_Garrison.GetLandingPageGarrisonType(), notCheckable=true},
				}
			end
			EasyMenu(landingChoices, landingChoiceMenu, "cursor", 0, 0, "MENU", 4)
		elseif GarrisonLandingPage.garrTypeID == 3 then
			ShowLanding(2)
			MaybeStopSound(self.closeSoundID)
		end
	end
end)
GarrisonLandingPageMinimapButton:HookScript("PostClick", function(self)
	self.closeSoundID, self.openSoundID = nil, nil
end)
hooksecurefunc("ShowGarrisonLandingPage", function(pg)
	if pg < 3 then
		LoadMP()
	end
end)

function E:ADDON_LOADED(addon)
	if addon == addonName then
		cdata = gett(_G, "MasterPlanAG", GetRealmName(), UnitName("player"))
		cdata.class, cdata.faction, cdata.cacheSize = select(2,UnitClass("player")), UnitFactionGroup("player"), cdata.cacheSize ~= 750 and cdata.cacheSize or nil
		setmetatable(api, {__index={data=cdata}})
		CheckCacheWarning()
		gett(_G, "MasterPlanAG", "IgnoreRewards")
		return "remove"
	end
end
function E:ADDON_LOADED(addon)
	if addon == "Blizzard_GarrisonUI" then
		LoadMPOnShow(GarrisonMissionFrame)
		LoadMPOnShow(GarrisonShipyardFrame)
		LoadMPOnShow(GarrisonRecruiterFrame)
	end
end
function E:SHOW_LOOT_TOAST(rt, rl, q, _4, _5, _6, source)
	if rt == "currency" and source == 10 and rl:match("currency:824") then
		cdata.lastCacheTime = GetServerTime()
		cdata.cacheSize = (IsQuestFlaggedCompleted(37485) or q > 500) and 1000 or cdata.cacheSize
		CheckCacheWarning()
	end
end
function E:PLAYER_LOGOUT()
	if cdata.lastCacheTime then
		local _, gr = GetCurrencyInfo(824)
		local _, oil = GetCurrencyInfo(1101)
		cdata.curRes, cdata.curOil = gr and gr > 0 and gr or nil, oil and oil > 0 and oil or nil
	elseif next(MasterPlanAG.IgnoreRewards) == nil then
		MasterPlanAG.IgnoreRewards = nil
	end
end
E.ZONE_CHANGED = CheckCacheWarning

MasterPlanA = api

SLASH_MASTERPLAN1, SlashCmdList.MASTERPLAN = "/masterplan", function()
	print("|cff0080ffMasterPlan|r v" .. GetAddOnMetadata("MasterPlan", "Version") .. " \"" .. (GetAddOnMetadata("MasterPlan", "X-Version-Key") or "-") .. "\" (" .. (IsAddOnLoaded("Blizzard_GarrisonUI") and "G" or "N") .. (IsAddOnLoaded("MasterPlan") and "O" or "A") .. ")")
end
