local _, T = ...
if T.Mark ~= 50 then return end
local EV, G, L = T.Evie, T.Garrison, T.L

local Nine = T.Nine or _G
local C_Garrison = Nine.C_Garrison

local roamingParty, easyDrop = T.MissionsUI.roamingParty, T.MissionsUI.easyDrop
local MISSION_PAGE_FRAME = GarrisonMissionFrame.MissionTab.MissionPage
local SHIP_MISSION_PAGE = GarrisonShipyardFrame.MissionTab.MissionPage

local function HideOwnedGameTooltip(self)
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end
local function HookOnShow(self, OnShow)
	self:HookScript("OnShow", OnShow)
	if self:IsVisible() then OnShow(self) end
end

do -- Feed FrameXML updates to Evie
	local function FollowerList_OnUpdateData(self)
		local p = self:GetParent()
		if not (p == GarrisonLandingPage and C_Garrison.GetLandingPageGarrisonType() == 3) then
			EV("FXUI_GARRISON_FOLLOWER_LIST_UPDATE", p)
		end
	end
	hooksecurefunc(GarrisonMissionFrame.FollowerList, "UpdateData", FollowerList_OnUpdateData)
	hooksecurefunc(GarrisonLandingPage.FollowerList, "UpdateData", FollowerList_OnUpdateData)
end

do -- GarrisonFollowerList_SortFollowers
	local toggle = CreateFrame("CheckButton", nil, GarrisonMissionFrameFollowers, "InterfaceOptionsCheckButtonTemplate")
	toggle:SetSize(24, 24) toggle:SetHitRectInsets(0,0,0,0)
	toggle:SetPoint("LEFT", GarrisonMissionFrameFollowers.SearchBox, "RIGHT", 12, 0)
	toggle:SetScript("OnClick", function(self)
		MasterPlan:SetSortFollowers(self:GetChecked())
	end)
	
	local missionFollowerSort do
		local finfo, cinfo, tinfo, mlvl
		local statusPriority = {
		  [GARRISON_FOLLOWER_WORKING] = 5,
		  [GARRISON_FOLLOWER_ON_MISSION] = 4,
		  [GARRISON_FOLLOWER_EXHAUSTED] = 3,
		  [GARRISON_FOLLOWER_INACTIVE] = 2,
		  [""]=1,
		}
		local function cmp(a, b)
			local af, bf = finfo[a], finfo[b]
			local ac, bc = af.isCollected and 1 or 0, bf.isCollected and 1 or 0
			if ac == bc then
				ac, bc = statusPriority[af.status] or 6, statusPriority[bf.status] or 6
			end
			if ac == bc then
				ac, bc = cinfo[af.followerID] and (#cinfo[af.followerID])*100 or 0, cinfo[bf.followerID] and (#cinfo[bf.followerID])*100 or 0
				ac, bc = ac + (tinfo[af.followerID] and #tinfo[af.followerID] or 0), bc + (tinfo[bf.followerID] and #tinfo[bf.followerID] or 0)
				if (ac > 0) ~= (bc > 0) then
					return ac > 0
				elseif ac > 0 and ((af.level >= mlvl) ~= (bf.level >= mlvl)) then
					return af.level >= mlvl
				end
			end
			if ac == bc then
				ac, bc = af.level, bf.level
			end
			if ac == bc then
				ac, bc = af.iLevel, bf.iLevel
			end
			if ac == bc then
				ac, bc = af.quality, bf.quality
			end
			if ac == bc then
				ac, bc = 0, strcmputf8i(af.name, bf.name)
			end
			return ac > bc
		end
		function missionFollowerSort(t, followers, counters, traits, level)
			finfo, cinfo, tinfo, mlvl = followers, counters, traits, level
			table.sort(t, cmp)
			finfo, cinfo, tinfo, mlvl = nil
		end
	end
	local oldSortFollowers = GarrisonFollowerList_SortFollowers
	function GarrisonFollowerList_SortFollowers(self)
		local checkIgnore = self == GarrisonMissionFrame.FollowerList
		local followerCounters = GarrisonMissionFrame.followerCounters
		local followerTraits = GarrisonMissionFrame.followerTraits
		for k,v in pairs(self.followers) do
			local tmid = G.GetFollowerTentativeMission(v.followerID)
			if tmid and (v.status or "") == "" then
				v.status = GARRISON_FOLLOWER_IN_PARTY
			elseif checkIgnore and (v.status or "") == "" and T.config.ignore[v.followerID] then
				v.status = GARRISON_FOLLOWER_WORKING
			end
		end
		toggle:SetShown(GarrisonMissionFrame.MissionTab:IsShown())
		local mi = MISSION_PAGE_FRAME.missionInfo
		if followerCounters and followerTraits and GarrisonMissionFrame.MissionTab:IsVisible() and mi and MasterPlan:GetSortFollowers() then
			return missionFollowerSort(self.followersList, self.followers, followerCounters, followerTraits, mi.level)
		end
		return oldSortFollowers(self)
	end
	function EV:MP_SETTINGS_CHANGED(s)
		if (s == nil or s == "sortFollowers") then
			if GarrisonMissionFrame:IsVisible() then
				GarrisonMissionFrame.FollowerList:UpdateFollowers()
			end
			toggle:SetChecked(MasterPlan:GetSortFollowers())
		end
	end
end

local GarrisonFollower_OnDoubleClick do -- Adding followers to missions
	local old = GarrisonFollowerListButton_OnClick
	local function resetAndReturn(followerList, ...)
		followerList.canExpand = true
		followerList:UpdateData()
		return ...
	end
	local function AddToMission(fi)
		local BASE = fi.followerTypeID == 1 and GarrisonMissionFrame or GarrisonShipyardFrame
		local PAGE = fi.followerTypeID == 1 and MISSION_PAGE_FRAME or SHIP_MISSION_PAGE
		
		local mi, f = PAGE.missionInfo, PAGE.Followers
		
		if mi.numFollowers == 1 then
			BASE:AssignFollowerToMission(f[1], fi)
			return
		end
		for i=1, mi.numFollowers do
			if not f[i].info then
				BASE:AssignFollowerToMission(f[i], fi)
				return
			end
		end
		
		local f1, f2, f3 = f[1].info, f[2].info, f[3].info
		f1, f2, f3 = f1 and f1.followerID, f2 and f2.followerID, f3 and f3.followerID
		local g = G.GetBackfillMissionGroups(mi, G.GroupFilter.IDLE, G.GetMissionDefaultGroupRank(mi), 1, f1, f2, f3, fi.followerID)
		if g and g[1] then
			local p1, p2, p3 = g[1][5], g[1][6], g[1][7]
			for i=1,mi.numFollowers do
				if p1 ~= f1 and p2 ~= f1 and p3 ~= f1 then
					BASE:AssignFollowerToMission(f[i], fi)
					break
				end
				f1, f2 = f2, f3
			end
		end
	end
	function GarrisonFollowerListButton_OnClick(self, ...)
		if self.PortraitFrame and self.PortraitFrame:IsMouseOver() and MISSION_PAGE_FRAME.missionInfo and MISSION_PAGE_FRAME:IsShown() then
			local followerList = self:GetFollowerList()
			followerList.canExpand = false
			return resetAndReturn(followerList, old(self, ...))
		end
		return old(self, ...)
	end
	function GarrisonFollower_OnDoubleClick(self)
		if self.PortraitFrame and self.PortraitFrame:IsMouseOver() then
			local mi, fi = MISSION_PAGE_FRAME.missionInfo, self.info
			if fi and fi.followerID and mi and mi.missionID and fi.status == nil then
				GarrisonMissionFrame.FollowerList:CollapseButton(self)
				AddToMission(fi, mi)
			elseif fi and fi.status == GARRISON_FOLLOWER_IN_PARTY then
				local f = MISSION_PAGE_FRAME.Followers
				for i=1, #f do
					if f[i].info and f[i].info.followerID == fi.followerID then
						GarrisonMissionFrame:RemoveFollowerFromMission(f[i], true)
						break
					end
				end
			end
		end
	end
	local function AddShipToMission(_, fid)
		AddToMission(C_Garrison.GetFollowerInfo(fid))
		GarrisonShipyardFrame.FollowerList:UpdateFollowers()
	end
	local origShipMenu = GarrisonShipyardFollowerOptionDropDown.initialize
	function GarrisonShipyardFollowerOptionDropDown.initialize(self, ...)
		local fid = self.followerID
		local tmid = fid and G.GetFollowerTentativeMission(fid)
		if SHIP_MISSION_PAGE:IsShown() and tmid and SHIP_MISSION_PAGE.missionInfo.missionInfo ~= tmid then
			local info = UIDropDownMenu_CreateInfo()
			info.text, info.notCheckable = GARRISON_MISSION_ADD_FOLLOWER, true
			info.func, info.arg1, info.arg2 = AddShipToMission, fid
			UIDropDownMenu_AddButton(info)
		end
		return origShipMenu(self, ...)
	end
end
function EV:FXUI_GARRISON_FOLLOWER_LIST_UPDATE(frame)
	local buttons = frame.FollowerList.listScroll.buttons
	local mi = MISSION_PAGE_FRAME:IsShown() and MISSION_PAGE_FRAME.missionInfo
	local mlvl = mi and G.GetFMLevel(mi)
	for i=1, #buttons do
		local btn = buttons[i]
		if btn.Follower then btn = btn.Follower end
		local follower = btn.info
		if btn:IsShown() and follower and (follower.followerTypeID or 4) < 3 and btn.XPBar then
			local st = btn.XPBar.statusText
			if not st then
				st = btn:CreateFontString(nil, "ARTWORK", "TextStatusBarText")
				st:SetTextColor(0.7, 0.6, 0.85)
				st:SetPoint("TOPRIGHT", -4, -44)
				btn.UpArrow:ClearAllPoints() btn.UpArrow:SetPoint("TOP", 16, -38)
				btn.DownArrow:ClearAllPoints() btn.DownArrow:SetPoint("TOP", 16, -38)
				btn.XPBar.statusText = st
				btn:SetScript("OnDoubleClick", GarrisonFollower_OnDoubleClick)
			end
			if mi then
				local ef = G.GetLevelEfficiency(G.GetFMLevel(follower), mlvl)
				if ef < 0.5 then
					btn.PortraitFrame.Level:SetTextColor(1, 0.1, 0.1)
				elseif ef < 1 then
					btn.PortraitFrame.Level:SetTextColor(1, 0.5, 0.25)
				else
					btn.PortraitFrame.Level:SetTextColor(1, 1, 1)
				end
			else
				btn.PortraitFrame.Level:SetTextColor(1, 1, 1)
			end
			if not follower.isCollected or follower.status == GARRISON_FOLLOWER_INACTIVE or follower.levelXP == 0 then
				st:SetText("")
			else
				st:SetFormattedText(L"%s XP", BreakUpLargeNumbers(follower.levelXP - follower.xp))
			end
		end
	end
end
local function FollowerList_UpdateShip(self)
	local buttons = self.listScroll.buttons
	local mi = SHIP_MISSION_PAGE:IsShown() and SHIP_MISSION_PAGE.missionInfo
	for i=1, #buttons do
		local btn = buttons[i]
		if btn:IsShown() then
			local follower, st = btn.info, btn.XPBar.statusText
			if not st then
				st = btn:CreateFontString(nil, "ARTWORK", "TextStatusBarText")
				st:SetTextColor(0.7, 0.6, 0.85)
				st:SetPoint("BOTTOMLEFT", btn.XPBar, "TOPLEFT", 1, -3)
				btn.XPBar.statusText = st
			end
			if not follower.isCollected or follower.status == GARRISON_FOLLOWER_INACTIVE or follower.levelXP == 0 then
				st:SetText("")
			else
				st:SetFormattedText(L"%s XP", BreakUpLargeNumbers(follower.levelXP - follower.xp))
			end
			local tmid = G.GetFollowerTentativeMission(follower.followerID)
			if follower.status == GARRISON_FOLLOWER_ON_MISSION then
				btn.Status:SetText(C_Garrison.GetFollowerMissionTimeLeft(follower.followerID))
			elseif follower.status == GARRISON_FOLLOWER_IN_PARTY and tmid and tmid ~= (mi and mi.missionID) then
				btn.Status:SetFormattedText("%s: %s", L"In Tentative Party", C_Garrison.GetMissionName(tmid))
			end
		end
	end
end
hooksecurefunc(GarrisonShipyardFrame.FollowerList, "UpdateData", FollowerList_UpdateShip)
hooksecurefunc(GarrisonLandingPage.ShipFollowerList, "UpdateData", FollowerList_UpdateShip)
do -- Follower counter button tooltips
	local fake, old = {}
	local function OnEnter(self, ...)
		old, fake.info = self, self.info
		return GarrisonMissionMechanicFollowerCounter_OnEnter(self, ...)
	end
	hooksecurefunc("GarrisonFollowerButton_UpdateCounters", function(_, self)
		if old and (fake.info ~= old.info or not (old:IsShown() and old:IsMouseOver())) then
			if false then --FIXME
				GarrisonMissionMechanicFollowerCounter_OnLeave(fake)
			end
			old, fake.info = nil
		end
		for i=1,#self.Counters do
			local self = self.Counters[i]
			self:SetScript("OnEnter", OnEnter)
			if self:IsShown() and self:IsMouseOver() then
				OnEnter(self)
			end
		end
	end)
end

local function GetRewardsDesc(mid)
	local r, mi = "", C_Garrison.GetBasicMissionInfo(mid)
	if mi and mi.rewards then
		for k,v in pairs(mi.rewards) do
			if v.currencyID == 0 then
				r = r .. " |TInterface\\MoneyFrame\\UI-GoldIcon:0|t"
			elseif v.icon then
				r = r .. " |T" .. v.icon .. ":0|t"
			elseif v.currencyID then
				local c = select(3, Nine.GetCurrencyInfo(v.currencyID))
				r = r .. " |T" .. (c or "Interface/Icons/Temp") .. ":0|t"
			elseif v.itemID then
				r = r .. " |T" .. GetItemIcon(v.itemID) .. ":0|t"
			end
		end
	end
	return r
end
local function FollowerButton_OnEnter(self)
	if (not MISSION_PAGE_FRAME:IsVisible() and IsAddOnLoaded("SmartFollowerManager")) then
		local info, id = self.info
		local GetAbility = C_Garrison[info.garrFollowerID and "GetFollowerAbilityAtIndex" or "GetFollowerAbilityAtIndexByID"]
		local GetTrait = C_Garrison[info.garrFollowerID and "GetFollowerTraitAtIndex" or "GetFollowerTraitAtIndexByID"]

		id = info.followerID
		GarrisonFollowerTooltip:ClearAllPoints()
		GarrisonFollowerTooltip:SetPoint("TOPLEFT", self, "TOPRIGHT", 0, 4)
		GarrisonFollowerTooltip_Show(info.garrFollowerID or info.followerID,
			not not info.isCollected, info.quality, info.level,
			info.xp, info.levelXP, info.iLevel,
			GetAbility(id, 1), GetAbility(id, 2), GetAbility(id, 3), GetAbility(id, 4),
			GetTrait(id, 1), GetTrait(id, 2), GetTrait(id, 3), GetTrait(id, 4),
			false
		)
		
		return
	end
	
	local tmid = self and self.id and G.GetFollowerTentativeMission(self.id)
	if tmid then
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint("TOPLEFT", self, "TOPRIGHT", 4, 4)
		GameTooltip:SetText(L"In Tentative Party")
		GameTooltip:AddDoubleLine(C_Garrison.GetMissionName(tmid), GetRewardsDesc(tmid), 1,1,1)
		if MISSION_PAGE_FRAME:IsVisible() then
			GameTooltip:AddLine("|n|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:14:12:0:-1:512:512:10:70:330:410|t " .. GARRISON_MISSION_ADD_FOLLOWER, 0.5, 0.8, 1)
		end
		GameTooltip:Show()
	elseif GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end
local function FollowerButton_OnLeave(self)
	GarrisonFollowerTooltip:Hide()
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end
function EV:FXUI_GARRISON_FOLLOWER_LIST_UPDATE(frame)
	local buttons, fl = frame.FollowerList.listScroll.buttons, G.GetFollowerInfo()
	local mi = MISSION_PAGE_FRAME.missionInfo
	local mid = mi and mi.missionID
	local upW, upA = G.GetUpgradeRange()
	for i=1, #buttons do
		local b = buttons[i].Follower
		local fi = fl[b and b.id]
		if fi and b and b:IsShown() then
			local tmid = G.GetFollowerTentativeMission(fi.followerID)
			local status, ns = b.info.status or ""
			if tmid then
				ns = tmid == mid and GARRISON_FOLLOWER_IN_PARTY or L"In Tentative Party"
			elseif T.config.ignore[fi.followerID] then
				if fi.status == nil and status == GARRISON_FOLLOWER_WORKING then
					ns = L"Ignored"
				elseif fi.status == GARRISON_FOLLOWER_INACTIVE or fi.status == GARRISON_FOLLOWER_WORKING then
					ns = fi.status .. " " .. L"Ignored"
				end
			end
			if ns then
				b.Status:SetText(ns)
			end
			if fi.level == T.FOLLOWER_LEVEL_CAP then
				local _weaponItemID, weaponItemLevel, _armorItemID, armorItemLevel = C_Garrison.GetFollowerItems(fi.followerID)
				local itext = ITEM_LEVEL_ABBR .. " " .. fi.iLevel
				if weaponItemLevel < upW or armorItemLevel < upA then
					itext = itext .. "|cff20e020+|r"
				end
				if (ns or status) == "" and weaponItemLevel ~= armorItemLevel then
					itext = itext .. " (" .. weaponItemLevel .. "/" .. armorItemLevel .. ")"
				end
				b.ILevel:SetText(itext)
			end
			if frame == GarrisonMissionFrame then
				b:SetScript("OnEnter", FollowerButton_OnEnter)
				b:SetScript("OnLeave", FollowerButton_OnLeave)
			end
		end
	end
end
local function mousewheelListUpdate(self, ...)
	HybridScrollFrame_OnMouseWheel(self, ...)
	local buttons = self.buttons
	for i = 1, #buttons do
		if buttons[i]:IsMouseOver() then
			local oe = buttons[i]:GetScript("OnEnter")
			if oe then
				oe(buttons[i])
				return
			end
		end
	end
end
GarrisonMissionFrame.FollowerList.listScroll:SetScript("OnMouseWheel", mousewheelListUpdate)
GarrisonLandingPage.FollowerList.listScroll:SetScript("OnMouseWheel", mousewheelListUpdate)
GarrisonRecruitSelectFrame.FollowerList.listScroll:SetScript("OnMouseWheel", mousewheelListUpdate)

local function Mechanic_OnClick(self)
	T.Mechanic_OnClick(self)
end
local function Mechanic_OnEnter(self)
	local mi = MISSION_PAGE_FRAME.missionInfo
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
	G.SetThreatTooltip(GameTooltip, tostring(self.info.icon), nil, G.GetFMLevel(mi))
	GameTooltip:Show()
end
hooksecurefunc(GarrisonMissionFrame, "SetEnemies", function(_, f, enemies)
	for i=1, #enemies do
		local m = f.Enemies[i] and f.Enemies[i].Mechanics
		for i=1,m and #m or 0 do
			if not m[i].highlight then
				m[i].highlight = m[i]:CreateTexture(nil, "HIGHLIGHT")
				m[i].highlight:SetAllPoints()
				m[i].highlight:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
				m[i].highlight:SetBlendMode("ADD")
				m[i]:SetScript("OnClick", Mechanic_OnClick)
				m[i]:SetScript("OnEnter", Mechanic_OnEnter)
				m[i]:SetScript("OnLeave", HideOwnedGameTooltip)
			end
			m[i].hasCounter = nil
			m[i].Check:Hide()
			m[i].Anim:Stop()
		end
	end
end)
local function UpdateHover(_, frame)
	if frame:IsMouseOver() and frame:IsShown() then
		local	ol, oe = frame:GetScript("OnLeave"), frame:GetScript("OnEnter")
		if ol then
			securecall(ol, frame)
		end
		if oe then
			oe(frame)
		end
	end
end
hooksecurefunc(GarrisonMissionFrame, "AssignFollowerToMission", UpdateHover)
hooksecurefunc(GarrisonMissionFrame, "RemoveFollowerFromMission", UpdateHover)
hooksecurefunc(GarrisonShipyardFrame, "AssignFollowerToMission", UpdateHover)
hooksecurefunc(GarrisonShipyardFrame, "RemoveFollowerFromMission", UpdateHover)

local lfgButton do
	local seen = MISSION_PAGE_FRAME.Stage:CreateFontString(nil, "OVERLAY", "GameFontNormalMed2")
	seen:SetPoint("TOPLEFT", MISSION_PAGE_FRAME.Stage.MissionEnv, "BOTTOMLEFT", 0, -3)
	seen:SetJustifyH("LEFT")
	MISSION_PAGE_FRAME.Stage.MissionSeen = seen
	
	lfgButton = CreateFrame("Button", nil, MISSION_PAGE_FRAME.Stage)
	lfgButton:SetSize(33,33)
	lfgButton:SetHighlightTexture("?") local hi = lfgButton:GetHighlightTexture()
	hi:SetAtlas("groupfinder-eye-highlight", true)
	hi:SetBlendMode("ADD")
	hi:SetAlpha(0.25)
	local border = lfgButton:CreateTexture(nil, "OVERLAY")
	border:SetSize(52, 52)
	border:SetPoint("TOPLEFT", 1, -1.5)
	border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
	local ico = lfgButton:CreateTexture(nil, "ARTWORK")
	ico:SetNonBlocking(false)
	ico:SetTexture("Interface\\LFGFrame\\BattlenetWorking28")
	ico:SetAllPoints()
	local curIco, nextSwap = 28, 0.08
	lfgButton:SetScript("OnUpdate", function(self, elapsed)
		local goal, animate
		if easyDrop:IsOpen(self) then
			goal = 17
		else
			goal, animate = 28, self:IsMouseOver()
		end
		if curIco ~= goal or animate then
			if nextSwap < elapsed then
				curIco, nextSwap = (curIco + 1) % 29, 0.08
				local curIco = curIco > 4 and curIco < 9 and (8-curIco) or (curIco == 16 and 15) or curIco
				ico:SetTexture("Interface\\LFGFrame\\BattlenetWorking" .. curIco)
			else
				nextSwap = nextSwap - elapsed
			end
		end
	end)
	lfgButton:SetScript("OnHide", function(self)
		curIco, nextSwap, self.clickOpen = 28, 0.08
		ico:SetTexture("Interface\\LFGFrame\\BattlenetWorking28")
		if easyDrop:IsOpen(self) then
			CloseDropDownMenus()
		end
		HideOwnedGameTooltip(self)
	end)
	lfgButton:SetScript("OnEnter", function(self)
		easyDrop:DelayOpenClick(self)
	end)
	lfgButton:SetScript("OnLeave", HideOwnedGameTooltip)

	lfgButton:SetScript("OnClick", function(self)
		local PAGE_FRAME = self:GetParent():GetParent()
		if not easyDrop:CheckToggle(self) then
			return
		end

		local mi, ff = PAGE_FRAME.missionInfo, PAGE_FRAME.Followers
		local f1, f2, f3 = ff[1].info, ff[2].info, ff[3].info
		f1, f2, f3 = f1 and f1.followerID, mi.numFollowers > 1 and f2 and f2.followerID, mi.numFollowers > 1 and f3 and f3.followerID

		local mm = G.GetSuggestedGroupsMenu(mi, f1, f2, f3)
		if mm and #mm > 1 then
			easyDrop:Open(self, mm, "TOPRIGHT", self, "TOPLEFT", -2, 12)
			return
		end
		easyDrop:CancelOpen(self)
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint("TOPRIGHT", self, "TOPLEFT", 0, 0)
		GameTooltip:SetText(L"No groups available")
		GameTooltip:Show()
	end)
	
	MISSION_PAGE_FRAME:HookScript("OnShow", function()
		lfgButton:SetParent(MISSION_PAGE_FRAME.Stage)
		lfgButton:SetPoint("TOPRIGHT", MISSION_PAGE_FRAME.Stage, "TOPRIGHT", -6, -28)
	end)
	SHIP_MISSION_PAGE:HookScript("OnShow", function()
		lfgButton:SetParent(SHIP_MISSION_PAGE.Stage)
		lfgButton:SetPoint("TOPRIGHT", SHIP_MISSION_PAGE.Stage, "TOPRIGHT", -6, -28)
		lfgButton:Show()
	end)
end
local function clearSearch()
	local sb = GarrisonMissionFrameFollowers.SearchBox
	if sb:GetText() == sb.clearText then
		sb:SetText("")
	end
	sb.clearText = nil
end
hooksecurefunc(GarrisonMissionFrame, "ShowMission", function()
	clearSearch()
	local mi = MISSION_PAGE_FRAME.missionInfo
	local _, expTime = G.GetMissionSeen(mi and mi.missionID, mi)
	if expTime ~= "" then
		MISSION_PAGE_FRAME.Stage.MissionSeen:SetText(L"Expires in:" .. " " .. HIGHLIGHT_FONT_COLOR_CODE .. expTime)
	else
		MISSION_PAGE_FRAME.Stage.MissionSeen:SetText("")
	end
	lfgButton:Show()
end)
EV.GARRISON_MISSION_NPC_CLOSED = clearSearch

do -- Save tentative party on minimize
	local function Minimize_OnClick(self)
		local PAGE = self:GetParent()
		local mi = PAGE.missionInfo
		local mid, f1, f2, f3 = mi.missionID
		for i=1, mi.numFollowers do
			local fi = PAGE.Followers[mi.numFollowers+1-i].info
			f1, f2, f3 = fi and fi.followerID, f1, f2
			if mid and f1 then
				C_Garrison.RemoveFollowerFromMission(mid, f1)
			end
		end
		G.SaveMissionParty(mi.missionID, f1, f2, f3)
		roamingParty:DropFollowers(f1, f2, f3)
		PAGE.CloseButton:Click()
	end
	local function Minimize_OnHide(self)
		local PAGE = self:GetParent()
		if PAGE.missionInfo and PAGE:IsShown() then
			self:Click()
		end
	end
	local function OnAssignFollower(_, _, info)
		if info and info.followerID then
			if G.GetFollowerTentativeMission(info.followerID) then
				(info.followerTypeID == 1 and GarrisonMissionFrame or GarrisonShipyardFrame).FollowerList.dirtyList = true
			end
			G.DissolveMissionByFollower(info.followerID)
			G.PushFollowerPartyStatus(info.followerID)
		end
	end
	local function ClickMinimize(self)
		self.MinimizeButton:Click()
	end
	hooksecurefunc(GarrisonMissionFrame, "AssignFollowerToMission", OnAssignFollower)
	hooksecurefunc(GarrisonShipyardFrame, "AssignFollowerToMission", OnAssignFollower)
	
	for i=1,2 do
		local PAGE = i == 1 and MISSION_PAGE_FRAME or SHIP_MISSION_PAGE
		PAGE.CloseButton:SetSize(32, 32)
		PAGE.CloseButton:SetPoint("TOPRIGHT", 2, 2)
		PAGE:SetScript("OnClick", ClickMinimize)

		local min = CreateFrame("Button", nil, PAGE, "UIPanelCloseButtonNoScripts")
		PAGE.MinimizeButton = min
		min:SetNormalTexture("Interface\\Buttons\\UI-Panel-HideButton-Up")
		min:SetPushedTexture("Interface\\Buttons\\UI-Panel-HideButton-Down")
		min:SetPoint("RIGHT", PAGE.CloseButton, "LEFT", 8, 0)
		min:SetHitRectInsets(0,8,0,0)
		min:SetScript("OnClick", Minimize_OnClick)
		min:SetScript("OnHide", Minimize_OnHide)
	end
end

do -- GarrisonFollowerTooltip xp textures
	local tf, tf2 = GarrisonFollowerTooltip, GarrisonShipyardFollowerTooltip
	repeat
		tf.XPGained = tf:CreateTexture(nil, "ARTWORK", nil, 2)
		tf.XPGained:SetColorTexture(1, 0.8, 0.2)
		tf.XPRewardBase = tf:CreateTexture(nil, "ARTWORK", nil, 2)
		tf.XPRewardBase:SetColorTexture(0.6, 1, 0)
		tf.XPRewardBase:SetPoint("TOPLEFT", tf.XPBar, "TOPRIGHT")
		tf.XPRewardBase:SetPoint("BOTTOMLEFT", tf.XPBar, "BOTTOMRIGHT")
		tf.XPRewardBonus = tf:CreateTexture(nil, "ARTWORK", nil, 2)
		tf.XPRewardBonus:SetColorTexture(0, 0.75, 1)
		tf.XPRewardBonus:SetPoint("TOPLEFT", tf.XPRewardBase, "TOPRIGHT")
		tf.XPRewardBonus:SetPoint("BOTTOMLEFT", tf.XPRewardBase, "BOTTOMRIGHT")
		tf, tf2 = tf2
	until not tf
	local function setFollowerData(self, data)
		self.lastShownData = data
		if self.XPGained then
			self.XPGained:Hide()
			self.XPRewardBase:Hide()
			self.XPRewardBonus:Hide()
		end
	end
	hooksecurefunc("GarrisonFollowerTooltipTemplate_SetGarrisonFollower", setFollowerData)
	hooksecurefunc("GarrisonFollowerTooltipTemplate_SetShipyardFollower", setFollowerData)
end
do -- Projected XP rewards
	local function MissionFollower_OnEnter(self)
		local mf = MISSION_PAGE_FRAME:IsVisible() and MISSION_PAGE_FRAME or SHIP_MISSION_PAGE
		if self.info and mf.missionInfo then
			G.ExtendMissionInfoWithXPRewardData(mf.missionInfo, true)
			G.ExtendFollowerTooltipProjectedRewardXP(mf.missionInfo, self.info)
		end
	end
	for i=1,3 do
		MISSION_PAGE_FRAME.Followers[i]:HookScript("OnEnter", MissionFollower_OnEnter)
		SHIP_MISSION_PAGE.Followers[i]:HookScript("OnEnter", MissionFollower_OnEnter)
	end
end
do -- Counter-follower lists
	local itip = CreateFrame("GameTooltip", "MPInnerTip", nil, "GameTooltipTemplate") do
		itip:SetBackdrop(nil)
		itip:SetPadding(0, 0)
		itip:SetScript("OnHide", function(self)
			self:Hide()
			self:SetParent(nil)
			self:ClearAllPoints()
		end)
		itip:SetScript("OnUpdate", function(self)
			local atip = self:GetParent()
			if not atip then
				return self:Hide()
			end
			local il, al, at, iw = self:GetLeft(), atip:GetLeft(), atip:GetTop(), self:GetWidth()
			if not (il and al and at and iw) then
				return
			end
			local lm = il - al
			atip:SetWidth(math.max(245, lm + iw))
			if atip.Description then
				atip.Description:SetWidth(atip:GetWidth()+atip:GetLeft()-atip.Description:GetLeft()-10)
			end
			local tw = atip:GetWidth() - lm - 18
			if tw > self:GetWidth() then
				self:SetMinimumWidth(tw)
				self:Show()
			end
			self:Show()
			atip:SetHeight(at-self:GetTop()+self:GetHeight()+2)
		end)
		function itip:ActivateFor(owner, ...)
			if owner then
				self:SetParent(owner)
				self:SetOwner(owner, "ANCHOR_PRESERVE")
				self:ClearAllPoints()
				self:SetPoint(...)
			end
		end
	end
	
	if false then --FIXME
		hooksecurefunc("GarrisonFollowerTooltipTemplate_SetGarrisonFollower", function(self, _info)
			for i=1,#self.Abilities do
				local ci = self.Abilities[i].CounterIcon
				if ci:IsShown() then
					ci:SetMask("")
					ci:SetTexCoord(4/64,60/64,4/64,60/64)
				end
			end
		end)
	end
	
	hooksecurefunc("GarrisonFollowerAbilityTooltipTemplate_SetAbility", function(self, aid)
		if false then --FIXME
			self.CounterIcon:SetMask("")
			self.CounterIcon:SetTexCoord(4/64,60/64,4/64,60/64)
		end
		if not aid or not self.Details or aid >= 331 then
			return
		elseif self.Details:IsShown() then
			itip:ActivateFor(self, "TOPLEFT", self.CounterIcon, "BOTTOMLEFT", -14, 16)
		else
			itip:ActivateFor(self, "TOPLEFT", self.Description, "BOTTOMLEFT", -10, 12)
		end
		local tid = aid and not C_Garrison.GetFollowerAbilityIsTrait(aid) and C_Garrison.GetFollowerAbilityCounterMechanicInfo(aid)
		if self.Details:IsShown() and tid then
			G.SetThreatTooltip(itip, tid, nil, nil, nil, true)
		else
			G.SetTraitTooltip(itip, aid, nil, nil, true)
			return
		end
		itip:Show()
	end)
	GarrisonMissionMechanicFollowerCounterTooltip:HookScript("OnShow", function(self)
		local mech = G.GetMechanicInfo(tostring(self.Icon:GetTexture()))
		if mech then
			if self.CounterName:IsShown() then
				itip:ActivateFor(self, "TOPLEFT", self.CounterIcon, "BOTTOMLEFT", -10, 16)
			else
				itip:ActivateFor(self, "TOPLEFT", self.Name, "BOTTOMLEFT", -10, 0)
			end
			G.SetThreatTooltip(itip, mech, nil, nil, nil, true)
			itip:Show()
		end
	end)
	GarrisonMissionMechanicTooltip:HookScript("OnShow", function(self)
		local mech = self:GetParent().CloseMission and G.GetMechanicInfo(tostring(self.Icon:GetTexture()))
		if mech then
			itip:ActivateFor(self, "TOPLEFT", self.Description, "BOTTOMLEFT", -10, 16)
			G.SetThreatTooltip(itip, mech, nil, self.missionLevel, nil, true)
			itip:Show()
		end
	end)
end
do -- suppress completion toast while missions UI is visible
	local registered = false
	HookOnShow(GarrisonMissionFrame, function()
		if AlertFrame:IsEventRegistered("GARRISON_MISSION_FINISHED") then
			registered = true
			AlertFrame:UnregisterEvent("GARRISON_MISSION_FINISHED")
		end
	end)
	GarrisonMissionFrame:HookScript("OnHide", function()
		if registered then
			AlertFrame:RegisterEvent("GARRISON_MISSION_FINISHED")
			registered = false
		end
	end)
end
do -- Mission page rewards
	local function Reward_OnClick(self)
		if IsModifiedClick("CHATLINK") then
			local q, text = self.quantity and self.quantity > 1 and self.quantity .. " " or ""
			if self.itemID then
				text = select(2, GetItemInfo(self.itemID))
				if text then
					text = q .. text
				end
			elseif self.currencyID and self.currencyID > 0 and self.currencyQuantity then
				text = self.currencyQuantity .. " " .. Nine.GetCurrencyLink(self.currencyID, self.currencyQuantity)
			elseif self.title then
				text = q .. self.title
			end
			if text then
				ChatEdit_InsertLink(text)
			end
		end
	end
	hooksecurefunc("GarrisonMissionPage_SetReward", function(self, reward)
		self.quantity = reward.quantity or reward.followerXP
		self:SetScript("OnMouseUp", Reward_OnClick)
	end)
end

local function SetFollowerIgnore(_, fid, val)
	MasterPlan:SetFollowerIgnored(fid, val)
	GarrisonMissionFrame.FollowerList.dirtyList = true
	GarrisonMissionFrame.FollowerList:UpdateFollowers()
end
hooksecurefunc(GarrisonFollowerOptionDropDown, "initialize", function(self)
	local fi = self.followerID and C_Garrison.GetFollowerInfo(self.followerID)
	if fi and fi.isCollected then
		DropDownList1.numButtons = DropDownList1.numButtons - 1
		
		local info, ignored = UIDropDownMenu_CreateInfo(), T.config.ignore[fi.followerID]
		info.text, info.notCheckable = ignored and L"Unignore" or L"Ignore", true
		info.func, info.arg1, info.arg2 = SetFollowerIgnore, fi.followerID, not ignored
		UIDropDownMenu_AddButton(info)
		
		info.text, info.func = CANCEL
		UIDropDownMenu_AddButton(info)
	end
end)

do -- Follower headcounts
	local mf = GarrisonMissionFrame.MissionTab.MissionList.MaterialFrame
	local ff = CreateFrame("Frame", nil, mf)
	local fs = ff:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge")
	ff.Text, mf.MPHeadcount = fs, ff
	local ni, nw, nx, nm = 0, 0, 0, 0
	ff:SetPoint("TOPLEFT")
	ff:SetPoint("BOTTOMRIGHT", mf, "BOTTOMLEFT", 190, 0)
	fs:SetPoint("LEFT", 16, 0)
	ff:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
		GameTooltip:AddLine(GARRISON_FOLLOWERS_TITLE, 1,1,1)
		if ni > 0 then
			GameTooltip:AddLine("|cff40ff40" .. ni .. " " .. L"Idle")
		end
		if nx > 0 then
			GameTooltip:AddLine("|cffc864ff" .. nx .. " " .. L"Idle (max-level)")
		end
		if nw > 0 then
			GameTooltip:AddLine(nw .. " " .. GARRISON_FOLLOWER_WORKING)
		end
		if nm > 0 then
			GameTooltip:AddLine("|cff80dfff" .. nm .. " " .. GARRISON_FOLLOWER_ON_MISSION)
		end
		GameTooltip:Show()
	end)
	ff:SetScript("OnLeave", HideOwnedGameTooltip)
	for _, s in pairs({mf:GetRegions()}) do
		if s:IsObjectType("FontString") and s:GetText() == GARRISON_YOUR_MATERIAL then
			s:Hide()
		end
	end
	local function sync()
		ni, nw, nx, nm = 0, 0, 0, 0
		for k, v in pairs(G.GetFollowerInfo(1)) do
			if not v.isCollected or T.config.ignore[k] or v.followerTypeID ~= 1 then
			elseif v.status == GARRISON_FOLLOWER_WORKING then
				nw = nw + 1
			elseif v.status == GARRISON_FOLLOWER_ON_MISSION then
				nm = nm + 1
			elseif (v.status or "") ~= "" and v.status ~= GARRISON_FOLLOWER_IN_PARTY then
			elseif v.level == T.FOLLOWER_LEVEL_CAP and v.quality >= 4 then
				nx = nx + 1
			else
				ni = ni + 1
			end
		end
		local ico, spacer, t = "|TInterface\\FriendsFrame\\UI-Toast-FriendOnlineIcon:11:11:3:0:32:32:8:24:8:24:", "|TInterface\\Buttons\\UI-Quickslot2:9:9:0:0:64:64:31:32:31:32|t"
		if ni > 0 then t = ni .. ico .. "50:255:50|t" end
		if nx > 0 then t = (t and t .. spacer or "") .. nx .. ico .. "200:100:255|t" end
		if nw > 0 then t = (t and t .. spacer or "") .. nw .. ico .. "255:208:0|t" end
		if nm > 0 then t = (t and t .. spacer or "") .. nm .. ico .. "125:230:255|t" end
		fs:SetText(t or "")
		local _, nr = Nine.GetCurrencyInfo(824)
		local low = nr and nr < 150 and 0 or 1
		mf.Materials:SetTextColor(1, low, low)
	end
	
	hooksecurefunc(GarrisonMissionFrame, "UpdateCurrency", sync)
	EV.GARRISON_MISSION_NPC_OPENED = sync
	HookOnShow(mf, sync)
end
do -- Garrison Resources in shipyard
	local mf = GarrisonShipyardFrameFollowers.MaterialFrame
	local ff, fs, fi = CreateFrame("Frame", nil, mf), mf:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge"), mf:CreateTexture()
	fi:SetSize(30, 30)
	fi:SetPoint("LEFT", 8, 0)
	fi:SetAtlas("GarrMission_CurrencyIcon-Material")
	ff:SetWidth(190) ff:SetPoint("TOPLEFT") ff:SetPoint("BOTTOMLEFT")
	fs:SetPoint("LEFT", 40, 0)
	ff:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint("BOTTOMLEFT", mf, "TOPRIGHT")
		GameTooltip:SetCurrencyTokenByID(GARRISON_CURRENCY)
		GameTooltip:Show()
	end)
	ff:SetScript("OnLeave", HideOwnedGameTooltip)
	for _, s in pairs({mf:GetRegions()}) do
		if s:IsObjectType("FontString") and s:GetText() == GARRISON_YOUR_MATERIAL then
			s:Hide()
		end
	end
	local function sync()
		local _, cur = Nine.GetCurrencyInfo(GARRISON_CURRENCY)
		fs:SetText(BreakUpLargeNumbers(cur or 0))
	end
	
	hooksecurefunc(GarrisonShipyardFrame, "UpdateCurrency", sync)
	EV.GARRISON_SHIPYARD_NPC_OPENED = sync
	HookOnShow(mf, sync)
end

do -- Reward item tooltips
	local r = MISSION_PAGE_FRAME.RewardsFrame.Rewards
	local oe = r[1]:GetScript("OnEnter")
	local function Reward_OnEnter(self, ...)
		if self.itemID then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			G.SetItemTooltip(GameTooltip, self.itemID)
			GameTooltip:Show()
		else
			oe(self, ...)
		end
	end
	for i=1,#r do
		r[i]:SetScript("OnEnter", Reward_OnEnter)
	end
end
do -- Ship re-fitting
	local refit = CreateFrame("Frame", "MPShipRefitContainer") do
		T.CreateEdge(refit, {edgeFile="Interface/Tooltips/UI-Tooltip-Border", bgFile="Interface/DialogFrame/UI-DialogBox-Background-Dark", tile=true, edgeSize=16, tileSize=16, insets={left=3,right=3,bottom=3,top=3}},  nil, 0xffffbf3f)
		refit:SetSize(240, 90)
		refit:EnableMouse(true)
		local text = refit:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		text:SetPoint("LEFT", 6, 6)
		text:SetPoint("RIGHT", -6, 6)
		refit.text = text
		refit:SetScript("OnHide", function(self)
			self:SetParent(nil)
			self:ClearAllPoints()
			self:Hide()
			self.itemID = nil
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end)
		refit:SetScript("OnShow", function(self)
			self:SetFrameStrata("HIGH")
			self:RegisterEvent("PLAYER_REGEN_DISABLED")
			self:Sync()
		end)
		refit:SetScript("OnEvent", refit.Hide)
		refit:Hide()
		
		local eq, slots = {}, {} do
			local eqContainer, sContainer = CreateFrame("Frame", nil, refit), CreateFrame("Frame", nil, refit)
			eqContainer:SetHeight(24)
			eqContainer:SetPoint("TOP", 0, -6)
			sContainer:SetHeight(32)
			sContainer:SetPoint("BOTTOM", 0, 6)
			local function Equipment_OnClick(self)
				refit.itemID = self:GetChecked() and GetItemCount(self.itemID) > 0 and self.itemID or nil
				refit:SyncButtonState()
			end
			function refit:SyncButtonState()
				local cid = refit.itemID
				local ok = not not cid
				for i=1,#eq do
					eq[i]:SetChecked(eq[i].itemID == cid)
				end
				for i=1,#slots do
					slots[i]:SetEnabled(ok and not slots[i].lock)
				end
				refit.text:SetText(ok and L"Select equipment to replace" or L"Select equipment to install")
			end
			local function ShowMixedTooltip(self)
				if self.itemID then
					GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6)
					GameTooltip:SetHyperlink("item:" .. self.itemID)
					if GetItemCount(self.itemID) == 0 then
						GameTooltip:AddLine(L"You do not have this in your bags.", 1, 0.3, 0)
					end
					GameTooltip:Show()
				else
					GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -6)
					G.SetTraitTooltip(GameTooltip, self.traitID, nil, true)
					GameTooltip:Show()
				end
			end
			local function SetUpEquipmentRefit(self)
				local id = self:GetID()
				local fi = SHIP_MISSION_PAGE.Followers[math.ceil(id/2)].info
				local aid = fi and C_Garrison.GetFollowerAbilityAtIndex(fi.followerID, 2 - id % 2) or 0
				if aid > 0 then
					self:SetAttribute("type", "macro")
					self:SetAttribute("macrotext", SLASH_STOPSPELLTARGET1 .. "\n" .. SLASH_USE1 .. " item:" .. refit.itemID)
					self.followerID, self.abilityID = fi.followerID, aid
					UIParent:UnregisterEvent("CURRENT_SPELL_CAST_CHANGED")
				end
			end
			local function CompleteEquipmentRefit(self)
				UIParent:RegisterEvent("CURRENT_SPELL_CAST_CHANGED")
				if self.followerID and self.abilityID then
					C_Garrison.CastSpellOnFollowerAbility(self.followerID, self.abilityID)
					self:SetAttribute("type", nil)
					self:SetAttribute("macrotext", nil)
					self.followerID, self.slotID, refit.itemID = nil
					refit:SyncButtonState()
				end
			end
			for i=1,8 do
				local b = CreateFrame("CheckButton", nil, eqContainer)
				local ico = b:CreateTexture(nil, "BACKGROUND")
				ico:SetAllPoints()
				b.icon = ico
				ico:SetTexture("Interface/Icons/Temp")
				b:SetNormalTexture("Interface/Icons/Temp")
				b:GetNormalTexture():SetColorTexture(0,0,0,0)
				b:SetPushedTexture("Interface/Buttons/UI-QuickSlot-Depress")
				b:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square")
				b:SetCheckedTexture("Interface/Buttons/CheckButtonHilight")

				b:SetSize(24, 24)
				b:SetPoint("LEFT", 28*i-28, 0)
				b:SetScript("OnClick", Equipment_OnClick)
				b:SetScript("OnEnter", ShowMixedTooltip)
				b:SetScript("OnLeave", HideOwnedGameTooltip)
				eq[i] = b
			end
			for i=1,6 do
				local b = CreateFrame("Button", nil, sContainer, "SecureActionButtonTemplate", i)
				b:SetSize(32, 32)
				local ico, border = b:CreateTexture(), b:CreateTexture(nil, "OVERLAY")
				b.icon, b.border = ico, border
				ico:SetAllPoints()
				border:SetAllPoints()
				ico:SetTexture("Interface/Icons/Temp")
				b:SetNormalTexture("Interface/Icons/Temp")
				b:GetNormalTexture():SetColorTexture(0,0,0,0)
				b:SetPushedTexture("Interface/Buttons/UI-QuickSlot-Depress")
				b:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square")
				b:SetPoint("LEFT", i*34-34 + math.floor(i/2-0.5)*12, 0)
				b:SetMotionScriptsWhileDisabled(true)
				b:SetScript("OnEnter", ShowMixedTooltip)
				b:SetScript("OnLeave", HideOwnedGameTooltip)
				b:SetScript("PreClick", SetUpEquipmentRefit)
				b:SetScript("PostClick", CompleteEquipmentRefit)
				b:Disable()
				b:Hide()
				slots[i] = b
			end
		end
		local function SetItem(b, id)
			b.itemID = id
			b.icon:SetTexture(GetItemIcon(id))
			b.icon:SetDesaturated(GetItemCount(id) == 0)
			b:Show()
		end
		local function countTraitThreats(nf, tid)
			local n, t = 0, 0
			for i=1,nf do
				local fi = SHIP_MISSION_PAGE.Followers[i].info
				for j=1,2 do
					if fi and C_Garrison.GetFollowerAbilityAtIndex(fi.followerID, j) == tid then
						n = n + 1
					end
				end
			end
			for i=1,#SHIP_MISSION_PAGE.Enemies do
				local e = SHIP_MISSION_PAGE.Enemies[i]
				for j=1,e:IsShown() and #e.Mechanics or 0 do
					local m = e.Mechanics[j]
					if m:IsShown() and T.EquipmentCounters[m.mechanicID] == tid then
						t = t + 1
					end
				end
			end
			return n, t
		end
		function refit.Sync()
			if InCombatLockdown() then return end
			local ns, mi = 2, SHIP_MISSION_PAGE.missionInfo
			SetItem(eq[1], 127886)
			SetItem(eq[2], 127894)
			
			local hasUncounteredThreats = false
			for i=1,#SHIP_MISSION_PAGE.Enemies do
				local e = SHIP_MISSION_PAGE.Enemies[i]
				for j=1,e:IsShown() and #e.Mechanics or 0 do
					local m = e.Mechanics[j]
					local iid = T.EquipmentTraitItems[T.EquipmentCounters[m.mechanicID]]
					if m:IsShown() and not m.Check:IsShown() then
						hasUncounteredThreats = true
						for k=1,iid and ns or 0 do
							if eq[k].itemID == iid then
								iid = nil
								break
							end
						end
						if iid then
							ns = ns + 1
							SetItem(eq[ns], iid)
						end
					end
				end
			end
			for i=ns+1,#eq do
				eq[i]:Hide()
			end

			local hasEquipmentSlots, numSlotShips, numFishingNets = false, 0, 0
			for i=1,3 do
				local fi, numSlots = mi and i <= mi.numFollowers and SHIP_MISSION_PAGE.Followers[i].info, 0
				for j=1,2 do
					local s, a = slots[i*2+j-2], fi and C_Garrison.GetFollowerAbilityAtIndex(fi.followerID, j) or 0
					if a > 0 then
						local cc, ct = G.GetFollowerRerollConstraints(fi.followerID)
						numSlots, hasEquipmentSlots = numSlots + 1, true
						s.traitID = a
						s.icon:SetTexture(C_Garrison.GetFollowerAbilityIcon(a))
						local nc, nt = countTraitThreats(mi and mi.numFollowers or 0, a)
						local cof = C_Garrison.GetFollowerAbilityCounterMechanicInfo(a)
						local isReplacable = ct and (cof and cc[cof] or not cof and ct[T.EquivTrait[a] or a])
						
						if isReplacable and (nt == 0 or nc > nt) then
							s.border:SetAtlas("bags-glow-green")
							s.border:Show()
						elseif nt > 0 then
							s.border:SetAtlas(nc <= nt and "bags-glow-blue" or "bags-glow-heirloom")
							s.border:Show()
						else
							s.border:Hide()
						end
						if a == 305 then
							numFishingNets = numFishingNets + 1
						end
						s:Show()
					else
						s:Hide()
					end
				end
				if numSlots > 0 then
					numSlotShips = numSlotShips + 1
				end
			end
			
			eq[1]:GetParent():SetWidth(math.max(1,ns*28-4))
			slots[1]:GetParent():SetWidth((mi and mi.numFollowers or 1)*78-10)
			refit:SyncButtonState()
			refit.dirty = nil
			
			local mayRefit = (numFishingNets < numSlotShips) or (hasEquipmentSlots and hasUncounteredThreats)
			refit.trigger:SetShown(mayRefit)
			if not mayRefit then
				refit:Hide()
			end
		end
		function refit.SyncLater()
			if not refit.dirty then
				refit.dirty = true
				T.After0(refit.Sync)
			end
		end
	end
	local trigger = CreateFrame("Button", "MPShipRefitTrigger", SHIP_MISSION_PAGE) do
		local b = trigger
		b:SetSize(26, 26)
		b:SetPoint("RIGHT", -16, 32)--SHIP_MISSION_PAGE.Followers[3], "")
		b:SetNormalTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
		b:GetNormalTexture():SetTexCoord(0.90039063, 0.95117188, 0.04980469, 0.07519531)
		b:SetHighlightTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
		b:GetHighlightTexture():SetTexCoord(0.72656250, 0.77734375, 0.06738281, 0.09277344)
		b:GetHighlightTexture():SetBlendMode("ADD")
		b:SetPushedTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
		b:GetPushedTexture():SetTexCoord(0.63476563, 0.68554688, 0.06738281, 0.09277344)
		local t = b:CreateTexture(nil, "OVERLAY")
		t:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
		t:SetTexCoord(0.90625000, 0.94726563, 0.00097656, 0.02050781)
		t:SetSize(20, 20)
		t:SetPoint("CENTER")
		b:SetScript("OnMouseDown", function() t:SetPoint("CENTER", 1, -1) end)
		b:SetScript("OnMouseUp", function() t:SetPoint("CENTER") end)
		refit.trigger = trigger
	end
	trigger:SetScript("OnClick", function(self)
		if InCombatLockdown() then return end
		if refit:IsShown() then return refit:Hide() end
		refit:SetParent(SHIP_MISSION_PAGE)
		refit:SetPoint("RIGHT", self, "LEFT", -4, -20)
		refit:Show()
	end)
	
	hooksecurefunc(GarrisonShipyardFrame, "UpdateMissionData", refit.SyncLater)
end
do
	local ctlContainer = CreateFrame("Frame", nil, GarrisonShipyardFrame.MissionTab.MissionList) do
		ctlContainer:Hide()
		SHIP_MISSION_PAGE.MPStatContainer = ctlContainer
		ctlContainer:SetPoint("BOTTOM")
		ctlContainer:SetSize(108, 43)
		local t, is, ts = ctlContainer:CreateTexture(nil, "BACKGROUND"), 18, 1/16
		t:SetAtlas("Garr_Mission_MaterialFrame")
		t:SetTexCoord(0, ts, 0, 1)
		t:SetPoint("TOPLEFT")
		t:SetPoint("BOTTOMRIGHT", ctlContainer, "BOTTOMLEFT", is, 0)
		t = ctlContainer:CreateTexture(nil, "BACKGROUND")
		t:SetTexCoord(ts, 1-ts, 0, 1)
		t:SetAtlas("Garr_Mission_MaterialFrame")
		t:SetPoint("TOPLEFT", is, 0)
		t:SetPoint("BOTTOMRIGHT", -is, 0)
		t = ctlContainer:CreateTexture(nil, "BACKGROUND")
		t:SetTexCoord(1-ts, 1, 0, 1)
		t:SetAtlas("Garr_Mission_MaterialFrame")
		t:SetPoint("TOPRIGHT")
		t:SetPoint("BOTTOMLEFT", ctlContainer, "BOTTOMRIGHT", -is, 0)
		t = ctlContainer:CreateTexture(nil, "ARTWORK")
		t:SetSize(30,30)
		t:SetPoint("RIGHT", -8, 0)
		t:SetAtlas("ShipMission_CurrencyIcon-Oil", false)
		t = ctlContainer:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge")
		t:SetPoint("RIGHT", -35, 0)
		t:SetText("44,444")
		ctlContainer.MaterialCount = t
	end
	local function sync()
		ctlContainer.MaterialCount:SetText(BreakUpLargeNumbers(select(2, Nine.GetCurrencyInfo(1101)) or 0))
		ctlContainer:SetFrameLevel(GarrisonShipyardFrame.BorderFrame:GetFrameLevel()+1)
		ctlContainer:SetWidth((ctlContainer.MaterialCount:GetStringWidth() or 50) + 52)
		if ctlContainer:IsVisible() then
			C_Garrison.RequestShipmentInfo()
		end
	end
	EV.CURRENCY_DISPLAY_UPDATE = sync
	ctlContainer:SetScript("OnShow", sync)
	ctlContainer:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint("BOTTOM", self, "TOP")
		GameTooltip:SetText("!")
		GameTooltipTextLeft1:SetText("")
		for i=1, 2 do
			local on, oc, oi = Nine.GetCurrencyInfo(i == 1 and 1101 or 824)
			GameTooltip:AddDoubleLine(("|T%s:0:0:0:0:64:64:6:58:6:58|t %s"):format(oi, on), NORMAL_FONT_COLOR_CODE .. BreakUpLargeNumbers(oc), 1,1,1)
		end
		local sid, name = C_Garrison.GetOwnedBuildingInfoAbbrev(98)
		local ts, _, _, tl = select(5, C_Garrison.GetLandingPageShipmentInfo(sid))
		local sf, nf = C_Garrison.GetFollowers(2), 0
		local atCap = (#sf + (ts or 0)) == C_Garrison.GetFollowerSoftCap(2)
		for i=1,#sf do
			if sf[i].status == nil then
				nf = nf + 1
			end
		end
		if tl then
		elseif ts == 1 then
			tl = "|cff20c020" .. L"Ready"
		else
			tl = (atCap and "|cffc0c0c0" or "|cffc02020") .. L"Idle"
		end
		local outof = atCap and "|cffc0c0c0/" or "|cffc02020/"
		GameTooltip:AddDoubleLine("|TInterface\\Icons\\INV_Garrison_Cargoship:0:0:0:0:64:64:6:58:6:58|t " .. L"Idle ships", nf .. outof .. #sf, 1,1,1)
		GameTooltip:AddDoubleLine("|TInterface\\Icons\\Garrison_Build:0:0:0:0:64:64:6:58:6:58|t " .. name, tl, 1,1,1)
		GameTooltip:Show()
	end)
	ctlContainer:SetScript("OnLeave", HideOwnedGameTooltip)
	ctlContainer:Show()
end