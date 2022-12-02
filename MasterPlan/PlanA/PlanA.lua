local addonName, T = ...
local E, api, cdata = T.Evie, {}
local C = C_Garrison
local GarrisonLandingPageMinimapButton = ExpansionLandingPageMinimapButton


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
	a:SetScaleTo(SCALE_MAX, SCALE_MAX)
	a:SetStartDelay(5)
	a:SetDuration(1)
	a:SetOrder(1)
	a:SetChildKey("MPWarningTexture")
	a = ag:CreateAnimation("Scale")
	a:SetScaleTo(SCALE_MIN, SCALE_MIN)
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
        tex:SetAlpha(0)
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
do
	local followerTabNames = {[2]=GARRISON_FOLLOWERS, [3]=FOLLOWERLIST_LABEL_CHAMPIONS, [9]=FOLLOWERLIST_LABEL_CHAMPIONS, [111]=COVENANT_MISSIONS_FOLLOWERS}
	local function ShowLanding(_, page)
		HideUIPanel(GarrisonLandingPage)
		ShowGarrisonLandingPage(page)
		local fn = followerTabNames[page or C.GetLandingPageGarrisonType()]
		if fn then
			GarrisonLandingPage.FollowerList.LandingPageHeader:SetText(fn)
			GarrisonLandingPageTab2:SetText(fn)
		end
		if ExpansionLandingPage and ExpansionLandingPage:IsVisible() then
			HideUIPanel(ExpansionLandingPage)
		end
	end
	local function IsLandingPageVisible()
		return GarrisonLandingPage and GarrisonLandingPage:IsVisible()
	end
	local function IsExpansionPageVisible()
		return ExpansionLandingPage and ExpansionLandingPage:IsVisible()
	end
	local landingChoiceMenu, landingChoices
	GarrisonLandingPageMinimapButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	GarrisonLandingPageMinimapButton:HookScript("PreClick", function(self, b)
		self.landingVisiblePriorToClick = IsLandingPageVisible() and GarrisonLandingPage.garrTypeID
		self.expansionPageVisiblePriorToClick = IsExpansionPageVisible()
		if b == "RightButton" then
			local soundOK, soundID = PlaySound(SOUNDKIT.UI_GARRISON_GARRISON_REPORT_OPEN)
			self.startSoundID = soundOK and soundID
		end
	end)
	GarrisonLandingPageMinimapButton:HookScript("OnClick", function(self, b)
		if b == "LeftButton" then
			if IsLandingPageVisible() and not (IsExpansionPageVisible() or self.expansionPageVisiblePriorToClick) and GarrisonLandingPage.garrTypeID ~= C.GetLandingPageGarrisonType() then
				ShowLanding(nil, C.GetLandingPageGarrisonType())
			end
			return
		elseif b == "RightButton" then
			if (C.GetLandingPageGarrisonType() or 0) > 3 then
				if self.landingVisiblePriorToClick then
					ShowLanding(nil, self.landingVisiblePriorToClick)
				else
					HideUIPanel(GarrisonLandingPage)
				end
				if ExpansionLandingPage and ExpansionLandingPage:IsVisible() and not self.expansionPageVisiblePriorToClick then
					HideUIPanel(ExpansionLandingPage)
				end
				if self.startSoundID then
					local startID, soundOK, soundID, _ = self.startSoundID, PlaySound(SOUNDKIT.UI_GARRISON_GARRISON_REPORT_OPEN)
					StopSound(startID)
					_, self.startSoundID = soundOK and soundID and StopSound(soundID), nil
					local endID = soundOK and soundID and soundID > startID and (soundID - startID) < 10 and soundID or startID
					for i=startID+1, endID-1 do
						StopSound(i)
					end
				end
				if not landingChoiceMenu then
					landingChoiceMenu = CreateFrame("Frame", "MPLandingChoicesDrop", UIParent, "UIDropDownMenuTemplate")
				end
				landingChoices = wipe(landingChoices or {})
				landingChoices[#landingChoices+1] = C.GetNumFollowers(1) > 0 and {text=GARRISON_LANDING_PAGE_TITLE, func=ShowLanding, arg1=2, notCheckable=true} or nil
				landingChoices[#landingChoices+1] = C.GetNumFollowers(4) > 0 and {text=ORDER_HALL_LANDING_PAGE_TITLE, func=ShowLanding, arg1=3, notCheckable=true} or nil
				landingChoices[#landingChoices+1] = C.GetNumFollowers(22) > 0 and {text=WAR_CAMPAIGN, func=ShowLanding, arg1=9, notCheckable=true} or nil
				landingChoices[#landingChoices+1] = C.GetNumFollowers(123) > 0 and {text=COVENANT_MISSIONS_TITLE, func=ShowLanding, arg1=111, notCheckable=true} or nil
				GameTooltip:Hide()
				EasyMenu(landingChoices, landingChoiceMenu, "cursor", 0, 0, "MENU", 4)
				DropDownList1:ClearAllPoints()
				local x, y = self:GetCenter()
				local w, h = UIParent:GetSize()
				local u, r = y*2 > h, x*2 > w
				local p1 = (u and "TOP" or "BOTTOM") .. (r and "RIGHT" or "LEFT")
				local p2 = (u and "TOP" or "BOTTOM") .. (r and "LEFT" or "RIGHT")
				DropDownList1:SetPoint(p1, self, p2, r and 10 or -10, u and -8 or 8)
			elseif GarrisonLandingPage.garrTypeID == 3 then
				ShowLanding(nil, 2)
			end
		end
		self.startSoundID = nil
	end)
end
hooksecurefunc("ShowGarrisonLandingPage", function(pg)
	pg = (pg or C_Garrison.GetLandingPageGarrisonType() or 0)
	if pg < 3 and pg > 0 then
		LoadMP()
	end
end)
if (GARRISON_LANDING_COVIEW_PATCH_VERSION or 0) < 3 then
	GARRISON_LANDING_COVIEW_PATCH_VERSION = 3
	hooksecurefunc("ShowGarrisonLandingPage", function(pg)
		if GARRISON_LANDING_COVIEW_PATCH_VERSION ~= 3 then
			return
		end
		pg = (pg or C_Garrison.GetLandingPageGarrisonType() or 0)
		if pg ~= 111 and GarrisonLandingPage.SoulbindPanel then
			GarrisonLandingPage.FollowerTab.autoSpellPool:ReleaseAll()
			GarrisonLandingPage.FollowerTab.autoCombatStatsPool:ReleaseAll()
			GarrisonLandingPage.FollowerTab.AbilitiesFrame:Layout()
			GarrisonLandingPage.FollowerTab.CovenantFollowerPortraitFrame:Hide()
		end
		if pg > 2 and GarrisonThreatCountersFrame then
			GarrisonThreatCountersFrame:Hide()
		end
		if pg > 3 then
			GarrisonLandingPage.FollowerTab.NumFollowers:SetText("")
		end
		if GarrisonLandingPageReport.Sections then
			GarrisonLandingPageReport.Sections:SetShown(pg == 111)
		end
	end)
end

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
		cdata.cacheSize = (C_QuestLog.IsQuestFlaggedCompleted(37485) or q > 500) and 1000 or cdata.cacheSize
		CheckCacheWarning()
	end
end
function E:PLAYER_LOGOUT()
	if cdata.lastCacheTime then
		local gr = C_CurrencyInfo.GetCurrencyInfo(824).quantity
		local oil = C_CurrencyInfo.GetCurrencyInfo(1101).quantity
		cdata.curRes, cdata.curOil = gr and gr > 0 and gr or nil, oil and oil > 0 and oil or nil
	elseif next(MasterPlanAG.IgnoreRewards) == nil then
		MasterPlanAG.IgnoreRewards = nil
	end
end
E.ZONE_CHANGED = CheckCacheWarning

MasterPlanA = api

SLASH_MASTERPLAN1, SlashCmdList.MASTERPLAN = "/masterplan", function()
	print("|cff0080ffMasterPlan|r v" .. GetAddOnMetadata("MasterPlan", "Version") .. " (" .. (IsAddOnLoaded("Blizzard_GarrisonUI") and "G" or "N") .. (IsAddOnLoaded("MasterPlan") and "O" or "A") .. ")")
end
