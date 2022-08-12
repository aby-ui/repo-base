local addonName, T = ...
local E, api, cdata = T.Evie, {}
local C = C_Garrison

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
	local function ShowLanding(_, page)
		HideUIPanel(GarrisonLandingPage)
		local b = GarrisonLandingPageFollowerList.listScroll.buttons
		if ((page or C_Garrison.GetLandingPageGarrisonType()) == 111) ~= (b and b[1] and not b[1].DownArrow) then
			for i=1,#b do
				b[i]:Hide()
			end
			GarrisonLandingPageFollowerList.listScroll.buttons = nil
		end
		ShowGarrisonLandingPage(page)
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
			local openOK, openID = PlaySound(SOUNDKIT.UI_GARRISON_9_0_OPEN_LANDING_PAGE)
			local closeOK, closeID = PlaySound(SOUNDKIT.UI_GARRISON_9_0_CLOSE_LANDING_PAGE)
			self.openSoundID2 = openOK and openID
			self.closeSoundID2 = closeOK and closeID
		end
	end)
	GarrisonLandingPageMinimapButton:HookScript("OnClick", function(self, b)
		if b == "LeftButton" then
			if GarrisonLandingPage.garrTypeID ~= C.GetLandingPageGarrisonType() then
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
				MaybeStopSound(self.openSoundID)
				MaybeStopSound(self.closeSoundID)
				MaybeStopSound(self.openSoundID2)
				MaybeStopSound(self.closeSoundID2)
				if not landingChoiceMenu then
					landingChoiceMenu = CreateFrame("Frame", "WPLandingChoicesDrop", UIParent, "UIDropDownMenuTemplate")
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
				MaybeStopSound(self.closeSoundID)
				MaybeStopSound(self.closeSoundID2)
			end
		end
	end)
	GarrisonLandingPageMinimapButton:HookScript("PostClick", function(self)
		self.closeSoundID, self.openSoundID, self.closeSoundID2, self.openSoundID2 = nil
	end)
end
hooksecurefunc("ShowGarrisonLandingPage", function(pg)
	pg = (pg or C_Garrison.GetLandingPageGarrisonType() or 0)
	if pg < 3 and pg > 0 then
		LoadMP()
	end
end)
if (GARRISON_LANDING_COVIEW_PATCH_VERSION or 0) < 1 then
	GARRISON_LANDING_COVIEW_PATCH_VERSION = 1
	local lastNineMode = nil
	hooksecurefunc("ShowGarrisonLandingPage", function(pg)
		if GARRISON_LANDING_COVIEW_PATCH_VERSION ~= 1 then
			return
		end
		pg = (pg or C_Garrison.GetLandingPageGarrisonType() or 0)
		local thisNineMode = pg == 111 and 9 or 8
		if thisNineMode ~= 9 and GarrisonLandingPage.SoulbindPanel then
			GarrisonLandingPage.FollowerTab.autoSpellPool:ReleaseAll()
			GarrisonLandingPage.FollowerTab.autoCombatStatsPool:ReleaseAll()
			GarrisonLandingPage.FollowerTab.AbilitiesFrame:Layout()
			GarrisonLandingPage.FollowerTab.CovenantFollowerPortraitFrame:Hide()
		end
		if pg > 2 and GarrisonThreatCountersFrame then
			GarrisonThreatCountersFrame:Hide()
		end
		if lastNineMode and thisNineMode ~= lastNineMode then
			for i=1,#GarrisonLandingPageFollowerList.listScroll.buttons do
				GarrisonLandingPageFollowerList.listScroll.buttons[i]:Hide()
			end
			wipe(GarrisonLandingPageFollowerList.listScroll.buttons)
			GarrisonLandingPageFollowerList.listScroll.buttons = nil
			GarrisonLandingPageFollowerList:Initialize(GarrisonLandingPageFollowerList.followerType)
		end
		if GarrisonLandingPageReport.Sections then
			GarrisonLandingPageReport.Sections:SetShown(thisNineMode == 9)
		end
		lastNineMode = thisNineMode
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
	print("|cff0080ffMasterPlan|r v" .. GetAddOnMetadata("MasterPlan", "Version") .. " \"" .. (GetAddOnMetadata("MasterPlan", "X-Version-Key") or "-") .. "\" (" .. (IsAddOnLoaded("Blizzard_GarrisonUI") and "G" or "N") .. (IsAddOnLoaded("MasterPlan") and "O" or "A") .. ")")
end
