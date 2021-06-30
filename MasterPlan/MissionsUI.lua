local _, T = ...
if T.Mark ~= 50 then return end
local L, EV, G, api = T.L, T.Evie, T.Garrison, {}

local Nine = T.Nine or _G
local C_Garrison = Nine.C_Garrison

local function HookOnShow(self, OnShow)
	self:HookScript("OnShow", OnShow)
	if self:IsVisible() then OnShow(self) end
end

local MISSION_PAGE_FRAME = GarrisonMissionFrame.MissionTab.MissionPage
local SHIP_MISSION_PAGE = GarrisonShipyardFrame.MissionTab.MissionPage
local RefreshActiveMissionsView, activeMissionsHandle
local RefreshAvailMissionsView, availMissionsHandle
local interestMissionsHandle

local Interest_RewardMap = {}

local function SetMissionsFrameTab(id)
	local mainFrame = GarrisonMissionFrame
	PlaySound(SOUNDKIT.UI_GARRISON_NAV_TABS);
	PanelTemplates_SetTab(mainFrame, id);
	mainFrame:SelectTab(id);
end

local function abridge(n)
	if n < 1e3 then
		return ("%d"):format(n)
	else
		return (L"%sk"):format((n >= 1e5 and "%d" or "%.2g"):format(n/1e3))
	end
end
local function oncePerFrame(f)
	local ff
	local function cf()
		ff = nil
		f()
	end
	return function()
		if not ff then
			ff = true
			T.After0(cf)
		end
	end
end
local function dismissTooltip(self)
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end
local function dismissTooltipAndHighlight(self)
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
	self:GetParent():UnlockHighlight()
end
local function OpenToMission(mi, f1, f2, f3, isResume)
	local FRAME, PAGE, _, s1, s2, s3, s4, s5, s6 = GarrisonMissionFrame, MISSION_PAGE_FRAME
	if not mi then
		return
	elseif mi.followerTypeID == 2 then
		FRAME, PAGE = GarrisonShipyardFrame, SHIP_MISSION_PAGE
	end
	
	if not (f1 or f2 or f3) then
		f1, f2, f3 = G.GetMissionParty(mi.missionID)
		if not (f1 or f2 or f3) then
			f1, f2, f3 = api.roamingParty:GetFollowers()
		else
			isResume = true
		end
	end
	if (f1 or f2 or f3) then
		if not f2 then
			f2, f3 = f3
		end
		if not f1 then
			f1, f2, f3 = f2, f3
		end
	else
		isResume = true
	end
	if isResume then
		_, s1 = PlaySound(SOUNDKIT.UI_GARRISON_COMMAND_TABLE_INCREASED_SUCCESS_CHANCE)
		_, s2 = PlaySound(SOUNDKIT.UI_GARRISON_COMMAND_TABLE_100_SUCCESS)
		_, s3 = PlaySound(SOUNDKIT.UI_GARRISON_MISSION_THREAT_COUNTERED)
		_, s4 = PlaySound(SOUNDKIT.UI_MISSION_200_PERCENT)
		_, s5 = PlaySound(SOUNDKIT.UI_GARRISON_COMMAND_TABLE_UNASSIGN_FOLLOWER)
		_, s6 = PlaySound(SOUNDKIT.UI_GARRISON_COMMAND_TABLE_REDUCED_SUCCESS_CHANCE)
	end
	
	PlaySound(SOUNDKIT.UI_GARRISON_COMMAND_TABLE_SELECT_MISSION)
	FRAME.MissionTab.MissionList:Hide()
	PAGE:Show()
	FRAME:ShowMission(mi)
	FRAME.followerCounters = C_Garrison.GetBuffedFollowersForMission(mi.missionID, false)
	FRAME.followerTraits = C_Garrison.GetFollowersTraitsForMission(mi.missionID, false)
	
	FRAME:ClearParty()
	if C_Garrison.GetNumFollowersOnMission(mi.missionID) > 0 then
		local ft = C_Garrison.GetBasicMissionInfo(mi.missionID).followers
		for i=1,#ft do
			C_Garrison.RemoveFollowerFromMission(mi.missionID, ft[i])
		end
	end
	for i=1, mi.numFollowers do
		if f1 then
			FRAME:AssignFollowerToMission(PAGE.Followers[i], C_Garrison.GetFollowerInfo(f1))
		end
		f1, f2, f3 = f2, f3, f1
	end
	if isResume then
		for i = 1, #PAGE.Enemies do
			local enemyFrame = PAGE.Enemies[i]
			for mechanicIndex = 1, #enemyFrame.Mechanics do
				local mech = enemyFrame.Mechanics[mechanicIndex]
				mech.Check:SetAlpha(mech.hasCounter and 1 or 0)
				mech.Check:SetShown(mech.hasCounter)
				mech.Anim:Stop()
			end
		end
		PAGE.RewardsFrame.currentChance = nil
		GarrisonMissionPageRewardsFrame_StopUpdate(PAGE.RewardsFrame)
		FRAME:UpdateMissionData(PAGE)
		PAGE.RewardsFrame.ChanceGlowAnim:Stop()
		PAGE.Stage.MissionEnvIcon.Anim:Stop()
	end
	FRAME:UpdateMissionParty(PAGE.Followers)
	FRAME.FollowerList:UpdateFollowers()
	for i=1,6 do
		s1, s2, s3, s4, s5, s6 = s2, s3, s4, s5, s6, s1 and StopSound(s1)
	end
end
local function FollowerTooltip_SetFollower(owner, info, skipDescriptions)
	local id = info.followerID
	GarrisonFollowerTooltip:ClearAllPoints()
	GarrisonFollowerTooltip:SetPoint("TOP", owner, "BOTTOM", 0, -2)
	GarrisonFollowerTooltip_Show(info.garrFollowerID or info.followerID,
		info.isCollected,
		C_Garrison.GetFollowerQuality(id),
		C_Garrison.GetFollowerLevel(id),
		C_Garrison.GetFollowerXP(id),
		C_Garrison.GetFollowerLevelXP(id),
		C_Garrison.GetFollowerItemLevelAverage(id),
		0,
		C_Garrison.GetFollowerAbilityAtIndex(id, 1),
		C_Garrison.GetFollowerAbilityAtIndex(id, 2),
		C_Garrison.GetFollowerAbilityAtIndex(id, 3),
		C_Garrison.GetFollowerAbilityAtIndex(id, 4),
		C_Garrison.GetFollowerTraitAtIndex(id, 1),
		C_Garrison.GetFollowerTraitAtIndex(id, 2),
		C_Garrison.GetFollowerTraitAtIndex(id, 3),
		C_Garrison.GetFollowerTraitAtIndex(id, 4),
		skipDescriptions)
end
local function FormatCountdown(sec)
	if sec >= 3600 then
		return (sec % 3600 < 60) and HOUR_ONELETTER_ABBR:format(sec / 3600) or L("%dh %dm"):format(sec / 3600, sec / 60 % 60)
	else
		return format(SecondsToTimeAbbrev(sec < 0 and 0 or sec))
	end
end
local GetAvailableResources do
	local numFollowers, garrResources, ctID
	local function forget()
		numFollowers, garrResources, ctID = nil
	end
	function GetAvailableResources(ftID, dropCost, missions)
		if ftID ~= ctID then
			local n, _, r = 0, Nine.GetCurrencyInfo(ftID == 1 and GARRISON_CURRENCY or 1101)
			for k,v in pairs(G.GetFollowerInfo()) do
				if v.isCombat and v.followerTypeID == ftID and (v.status == GARRISON_FOLLOWER_IN_PARTY or v.status == nil) and not T.config.ignore[v.followerID] and not G.GetFollowerTentativeMission(v.followerID) then
					n = n + 1
				end
			end
			for i=1,#missions do
				local mi = missions[i]
				if mi.cost and G.HasTentativeParty(mi.missionID) == mi.numFollowers then
					r = r - mi.cost
				end
			end
			numFollowers, garrResources, ctID = n, r, ftID
			T.After0(forget)
		end
		return numFollowers, garrResources - (dropCost or 0)
	end
end
MISSION_PAGE_FRAME.StartMissionButton:SetScript("OnClick", function()
	if (not MISSION_PAGE_FRAME.missionInfo.missionID) then
		return
	end
	local f1, f2, f3 = G.StartMission(MISSION_PAGE_FRAME.missionInfo.missionID)
	api.roamingParty:DropFollowers(f1, f2, f3)
	PlaySound(SOUNDKIT.UI_GARRISON_COMMAND_TABLE_MISSION_START)
	GarrisonMissionFrame:CloseMission()
	RefreshAvailMissionsView(true)
end)

do -- CreateLoader(parent, W, G, H)
	local fin, N, c = setmetatable({}, {__mode="k"}), 9, "16FF1F1DEDFC9C04F6128CFEE8FF08FD3016FE9B17FF8DD2706F6E"
	local function Loader_OnUpdate(self)
		if self.skipFrame then
			self.skipFrame = nil
			return
		elseif self.job then
			local t1, tlim, ok, er, i, x = debugprofilestop(), self.tlim
			repeat
				if coroutine.status(self.job) ~= "suspended" then
					break
				end
				ok, er, i, x = coroutine.resume(self.job)
				local tdiff, stop = debugprofilestop()-t1
				t1, tlim, stop = t1+tdiff, tlim-tdiff, tlim < 2*tdiff
			until not (i and x) or stop
			if not (fin[self.job] or ok) then
				if ok ~= nil then
					securecall(error, "CO: " .. tostring(er) .. "\n" .. debugstack(self.job))
				end
				for i=1,#self do
					self[i]:SetColorTexture(1, 0.1, 0)
				end
				return
			elseif i and x then
				local pg = x <= i and 9 or x > 0 and math.floor(i/x*10) or 0
				if pg ~= self.pg then
					for i=math.max(1, self.pg or 1), pg do
						local si = self[i]
						si:SetColorTexture(si.r or 0, si.g or 0, si.b or 0)
					end
					for i=pg+1, self.pg or 9 do
						self[i]:SetColorTexture(0,0,0, 0.25)
					end
					self.pg = pg
				end
				self.nf = (self.nf or 0) + 1
				return
			else
				for i=math.max(1, self.pg or 1), 9 do
					local si = self[i]
					si:SetColorTexture(si.r or 0, si.g or 0, si.b or 0)
				end
				fin[self.job or 1] = 1
				if self.OnFinish then
					securecall(self.OnFinish, self, self.nf or 0)
				end
				self.nf, self.job = 0
				if self.animHide then
					self.animHide:Stop()
				end
			end
		end
		if self.animHide and self:IsVisible() then
			self.animHide:Play()
		else
			self:Hide()
		end
	end
	local function Loader_OnHide(self)
		if self.animHide then
			self.animHide:Stop()
		end
		self:SetAlpha(1)
		self.nf, self.job = 0
		self:Hide()
	end
	function api.CreateLoader(parent, W, G, H, tlim, animHide)
		local WG, loader = W + G, CreateFrame("Frame", nil, parent)
		loader.tlim = tlim or 14
		loader:SetSize(WG*N-G, H)
		loader:Hide()
		for i=1,N do
			local tex = loader:CreateTexture(nil, "OVERLAY", nil, -8+i)
			tex:SetSize(W, H)
			local r,g,b = c:match("(%x%x)(%x%x)(%x%x)", 6*i-5)
			tex.r, tex.g, tex.b = tonumber(r or 64,16)/255, tonumber(g or 64,16)/255, tonumber(b or 64,16)/255
			tex:SetColorTexture(0,0,0, 0.25)
			tex:SetPoint("LEFT", WG*(i-1), 0)
			loader[i] = tex
		end
		if animHide then
			local ag = loader:CreateAnimationGroup()
			local aa = ag:CreateAnimation("Alpha")
			aa:SetStartDelay(0.4)
			aa:SetFromAlpha(1)
			aa:SetToAlpha(0)
			aa:SetDuration(0.6)
			ag:SetScript("OnFinished", function()
				loader:SetAlpha(1)
				loader:Hide()
			end)
			loader.animHide = ag
		end
		loader:SetScript("OnUpdate", Loader_OnUpdate)
		loader:SetScript("OnHide", Loader_OnHide)
		return loader
	end
end

local missionList = CreateFrame("Frame", "MasterPlanMissionList", GarrisonMissionFrameMissions) do
	missionList:SetAllPoints()
	missionList:Hide()
	local hidden = CreateFrame("Frame", nil, missionList) do
		hidden:Hide()
		hidden.Tab1, hidden.Tab2 = GarrisonMissionFrameMissionsTab1, GarrisonMissionFrameMissionsTab2
		missionList:SetScript("OnShow", function()
			GarrisonMissionFrameMissionsTab1:SetParent(hidden)
			GarrisonMissionFrameMissionsTab2:SetParent(hidden)
			GarrisonMissionFrameMissionsListScrollFrame:SetParent(hidden)
			GarrisonMissionFrameMissions.CompleteDialog:SetParent(hidden)
		end)
		missionList:SetScript("OnHide", function(self)
			GarrisonMissionFrameMissionsTab1:SetParent(self:GetParent())
			GarrisonMissionFrameMissionsTab2:SetParent(self:GetParent())
			GarrisonMissionFrameMissionsListScrollFrame:SetParent(self:GetParent())
			GarrisonMissionFrameMissions.CompleteDialog:SetParent(GarrisonMissionFrameMissions)
		end)
	end
	local ctlContainer = CreateFrame("Frame", nil, missionList) do
		missionList.ctlContainer = ctlContainer
		ctlContainer:SetPoint("BOTTOMLEFT", GarrisonMissionFrameMissions, "TOPLEFT", 6, 0)
		ctlContainer:SetHeight(43)
		ctlContainer:Hide()
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
		local function UpdateWidth(self, elapsed)
			local tl = self.timeLeft - elapsed
			if tl < 0 then
				self:SetWidth(self.goalWidth)
				self:SetScript("OnUpdate", nil)
			else
				local sw, gw = self.startWidth, self.goalWidth
				local cw = sw + (gw - sw) * (1-tl*5)
				self:SetWidth(cw)
				self.timeLeft = tl
			end
		end
		function ctlContainer:SetInnerWidth(width, now)
			width = width + 20
			if now then
				self:SetWidth(width)
				self:SetScript("OnUpdate", nil)
			else
				self.goalWidth, self.startWidth, self.timeLeft = width, self:GetWidth(), 0.2
				self:SetScript("OnUpdate", UpdateWidth)
			end
		end
		function ctlContainer:Steal(owner, resident)
			if self.resident then
				self.resident:ClearAllPoints()
				self.resident:Hide()
			end
			if owner then
				self:SetParent(owner)
				self:Show()
			else
				self:Hide()
			end
			self.resident = resident
			if resident then
				resident:SetPoint("LEFT", ctlContainer, "LEFT", 10, 0)
				resident:SetParent(self)
				resident:Show()
				self:SetInnerWidth(resident:GetWidth(), true)
			end
		end
	end
end
local hoverFocus = CreateFrame("Frame") do
	local OPEN_DELAY, CLOSE_DELAY, CLOSE_GRACE = 0.2, 0.4, 0.5
	function hoverFocus:Update(elapsed)
		if self.owner then
			if not (self.owner:IsVisible() and (self.checkFunc == nil or self.checkFunc(self.owner))) then
				self:Close()
			end
		end
		
		if self.closeOwner then
			if self.closeGrace then
				local tl = self.closeGrace - elapsed
				self.closeGrace = tl > 0 and tl or nil
			end
			local co, frame = self.closeOwner, self.frame
			if co:IsVisible() and (co:IsMouseOver(4,-4,-4,4) or (frame and frame:IsMouseOver(4,-4,-4,4))) then
				self.closeDelay = CLOSE_DELAY
			else
				local dl = self.closeDelay - elapsed
				if dl > 0 then
					self.closeDelay = dl
				else
					self:Close()
				end
			end
		end
		
		if self.openOwner then
			if self.openOwner:IsVisible() and self.openOwner:IsMouseOver(4,-4,-4,4) then
				local dl = self.openDelay - elapsed
				if dl > 0 then
					self.openDelay = dl
				else
					self.closeOwner, self.closeDelay, self.closeGrace = self.openOwner, CLOSE_DELAY, CLOSE_GRACE, self.openOwner:Click()
				end
			else
				self.openOwner = nil
			end
		end
		
		if not (self.owner or self.closeOwner or self.openOwner) then
			self:SetScript("OnUpdate", nil)
		end
	end
	function hoverFocus:Close()
		if self.closeFunc then
			securecall(self.closeFunc, self.owner)
		end
		self.closeFunc, self.owner, self.closeOwner = nil
	end
	function hoverFocus:Open(owner, frame, checkFunc, closeFunc)
		if self.owner then self:Close() end
		self.owner, self.frame, self.closeFunc, self.checkFunc, self.closeOwner, self.openOwner, self.closeGrace = owner, frame, closeFunc, checkFunc
		self:SetScript("OnUpdate", self.Update)
	end
	function hoverFocus:CheckToggle(owner)
		if self.owner == owner then
			if self.closeOwner == owner and self.closeGrace then
				self.closeOwner = nil
			else
				self:Close()
			end
		else
			return true
		end
	end
	function hoverFocus:DelayOpenClick(owner)
		if self.owner ~= owner then
			self.openOwner, self.openDelay = owner, OPEN_DELAY
			self:SetScript("OnUpdate", self.Update)
		end
	end
end
local easyDrop = CreateFrame("Frame", "MPDropDown", nil, "UIDropDownMenuTemplate") do
	api.easyDrop = easyDrop
	function easyDrop:IsOpen(owner)
		return self.owner == owner and UIDROPDOWNMENU_OPEN_MENU == self and DropDownList1:IsShown()
	end
	function easyDrop:Close()
		hoverFocus:Close()
	end
	function easyDrop:CancelOpen(owner)
		if hoverFocus.openOwner == owner then
			hoverFocus.openOwner = nil
		end
	end
	local function checkMenu()
		if UIDROPDOWNMENU_OPEN_MENU == easyDrop and DropDownList1:IsShown() then
			DropDownList1.isCounting = nil
			return true
		end
	end
	local function closeEasyDrop(owner)
		if UIDROPDOWNMENU_OPEN_MENU == easyDrop then
			CloseDropDownMenus()
		end
		if owner.OnEasyDropHide then
			securecall(owner.OnEasyDropHide, owner)
		end
		easyDrop.owner = nil
	end
	function easyDrop:Open(owner, menu, ...)
		self:Close()
		hoverFocus:Open(owner, DropDownList1, checkMenu, closeEasyDrop)
		self.owner, self.closeOwner, self.openOwner, self.closeGrace = owner
		EasyMenu(menu, self, "cursor", 9000, 9000, "MENU", 4)
		DropDownList1:ClearAllPoints()
		DropDownList1:SetPoint(...)
	end
	function easyDrop:CheckToggle(owner)
		return hoverFocus:CheckToggle(owner)
	end
	function easyDrop:Toggle(owner, ...)
		if hoverFocus:CheckToggle(owner) then
			self:Open(owner, ...)
		end
	end
	function easyDrop:DelayOpenClick(owner)
		if not self:IsOpen(owner) then
			hoverFocus:DelayOpenClick(owner)
		end
	end
end
local activeUI = CreateFrame("Frame", nil, missionList) do
	activeUI:SetSize(880, 22)
	activeUI:SetPoint("BOTTOMLEFT", GarrisonMissionFrameMissions, "TOPLEFT", 0, 4)
	activeUI:Hide()
	activeUI.CompleteAll = CreateFrame("Button", "MPCompleteAll", activeUI, "UIPanelButtonTemplate") do
		local b = activeUI.CompleteAll
		b:SetSize(200, 26)
		b:SetPoint("BOTTOM", -64, 5)
		b:SetText(L"Complete All")
		b:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		local function DissmissHelp(self)
			if self.ShowingHelp then
				HelpPlate_TooltipHide()
				self.ShowingHelp = nil
			end
		end
		b:SetScript("OnLeave", DissmissHelp)
		b:SetScript("OnHide", DissmissHelp)
		b:SetScript("OnKeyDown", function(self, key)
			self:SetPropagateKeyboardInput(key ~= "SPACE")
			if key == "SPACE" then
				self:Click()
			end
		end)
	end
	activeUI.orders = T.CreateLazyItemButton(activeUI, 122514) do
		activeUI.orders:SetSize(28, 28)
		activeUI.orders:SetPoint("BOTTOMRIGHT", -308, 3)
	end
	local ctl = CreateFrame("Frame") do
		ctl:SetSize(29, 22)
		activeUI.waste = CreateFrame("Button", nil, ctl) do
			local popup = CreateFrame("Frame", nil, UIParent) do
				local f = popup
				f:SetFrameStrata("DIALOG")
				f:SetSize(260, 68)
				T.CreateEdge(f, {edgeFile="Interface/Tooltips/UI-Tooltip-Border", bgFile="Interface/DialogFrame/UI-DialogBox-Background-Dark", tile=true, edgeSize=16, tileSize=16, insets={left=4,right=4,bottom=4,top=4}}, 0xf2000000, 0xffbfbfbf)
				f:SetHitRectInsets(-4, -4, 0, -4)
				f:EnableMouse(true)
				f:Hide()
				local t = f:CreateFontString(nil, "ARTWORK", "GameTooltipHeaderText")
				t:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
				t:SetText(L"Require Currency Reward")
				t:SetPoint("TOPLEFT", 10, -10)
				local s = CreateFrame("Slider", nil, popup)
				s:SetSize(236, 17)
				s:SetPoint("TOP", 0, -42)
				s:SetHitRectInsets(0,0,-10,-10)
				T.CreateEdge(s, {bgFile="Interface\\Buttons\\UI-SliderBar-Background", edgeFile="Interface\\Buttons\\UI-SliderBar-Border", tile=true, edgeSize=8, tileSize=8, insets={left=3,right=3,top=6,bottom=6}})
				s:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
				local tt = s:GetThumbTexture()
				tt:SetSize(24,32)
				tt:SetTexCoord(4/32, 28/32, 0, 1)
				s:SetOrientation("HORIZONTAL")
				s:SetValue(110)
				s:SetMinMaxValues(0, 100)
				s:SetValueStep(10)
				s:SetObeyStepOnDrag(true)
				t = s:CreateTexture(nil, "BACKGROUND")
				t:SetHeight(10)
				t:SetColorTexture(0, 1, 0)
				t:SetAlpha(0.25)
				t:SetPoint("LEFT", 3, 0)
				t:SetPoint("RIGHT", tt, "CENTER", 0, 0)
				t = s:CreateTexture(nil, "BACKGROUND")
				t:SetHeight(10)
				t:SetColorTexture(1, 0, 0)
				t:SetAlpha(0.25)
				t:SetPoint("RIGHT", -3, 0)
				t:SetPoint("LEFT", tt, "CENTER", 0, 0)
				local lo = s:CreateFontString(nil, "ARTWORK", "GameFontDisableSmallLeft")
				lo:SetPoint("BOTTOMLEFT", s, "TOPLEFT", 0, 0)
				lo:SetText("0%")
				local hi = s:CreateFontString(nil, "ARTWORK", "GameFontDisableSmallLeft")
				hi:SetPoint("BOTTOMRIGHT", s, "TOPRIGHT", 4, 0)
				hi:SetText("100%")
				local vt = s:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
				vt:SetPoint("BOTTOM", tt, "TOP", 0, -6)
				s:SetScript("OnValueChanged", function(_self, v, user)
					if user then
						T.config.currencyWasteThreshold = 1-v/100
					end
					vt:SetText(v .. "%")
					hi:SetAlpha(v < 90 and 1 or 0)
					lo:SetAlpha(v > 10 and 1 or 0)
				end)
				s:SetScript("OnShow", function(self)
					self:SetValue((1-T.config.currencyWasteThreshold)*100)
				end)
				s:SetValue(0)
			end
			local b = activeUI.waste
			b:SetSize(20, 20)
			b:SetPoint("LEFT", 4, 0)
			b:SetNormalTexture("Interface\\Minimap\\ObjectIcons")
			b:SetDisabledTexture("Interface\\Minimap\\ObjectIcons")
			b:SetHighlightTexture("Interface\\Minimap\\ObjectIcons")
			local nt = b:GetNormalTexture()
			nt:SetTexCoord(0, 32/256, 64/256, 96/256)
			nt:SetVertexColor(0.8, 0.8, 0.8)
			local dt = b:GetDisabledTexture()
			dt:SetTexCoord(0, 32/256, 64/256, 96/256)
			dt:SetDesaturated(true)
			dt:SetVertexColor(0.8, 0.8, 0.8)
			local ht = b:GetHighlightTexture()
			ht:SetTexCoord(0, 32/256, 64/256, 96/256)
			ht:SetAlpha(0.25)
			local function hidePopup()
				popup:Hide()
			end
			b:SetScript("OnClick", function(self)
				if hoverFocus:CheckToggle(self) then
					hoverFocus:Open(self, popup, nil, hidePopup)
					popup:SetPoint("TOPLEFT", self, "BOTTOMLEFT", -34, -2)
					popup:Show()
				end
			end)
			b:SetScript("OnEnter", function(self)
				hoverFocus:DelayOpenClick(self)
			end)
		end
	end
	activeUI:SetScript("OnShow", function(self)
		missionList.ctlContainer:Steal(self, ctl)
		RefreshActiveMissionsView(true)
	end)
	local lootFrame = CreateFrame("Frame", nil, activeUI) do
		local lf = lootFrame
		activeUI.lootFrame = lf
		lf:SetSize(560, 380)
		lf:SetPoint("CENTER", GarrisonMissionFrameMissions, "CENTER")
		local t = lf:CreateTexture(nil, "BACKGROUND", nil, -1)
		t:SetAllPoints(GarrisonMissionFrameMissions)
		t:SetColorTexture(0,0,0)
		t:SetAlpha(0.35)
		local w1, h1 = lf:GetSize()
		local w2, h2 = GarrisonMissionFrameMissions:GetSize()
		lf:SetHitRectInsets((w1-w2)/2, (w1-w2)/2, (h1-h2)/2, (h1-h2)/2)
		lf:EnableMouse(true) lf:EnableMouseWheel(true)
		lf:SetFrameStrata("DIALOG")
		t = lf:CreateTexture(nil, "BACKGROUND")
		t:SetAtlas("Garr_InfoBox-BackgroundTile", true)
		t:SetHorizTile(true) t:SetVertTile(true)
		t:SetAllPoints()
		t = lf:CreateTexture(nil, "BORDER")
		t:SetAtlas("_Garr_InfoBoxBorder-Top", true)
		t:SetHorizTile(true) t:SetPoint("TOPLEFT") t:SetPoint("TOPRIGHT")
		t = lf:CreateTexture(nil, "BORDER")
		t:SetAtlas("_Garr_InfoBoxBorder-Top", true)
		t:SetHorizTile(true) t:SetPoint("BOTTOMLEFT") t:SetPoint("BOTTOMRIGHT")
		t:SetTexCoord(0, 1, 1, 0)
		t = lf:CreateTexture(nil, "BORDER")
		t:SetAtlas("!Garr_InfoBoxBorder-Left", true)
		t:SetVertTile(true) t:SetPoint("TOPLEFT") t:SetPoint("BOTTOMLEFT")
		t = lf:CreateTexture(nil, "BORDER")
		t:SetAtlas("!Garr_InfoBoxBorder-Left", true)
		t:SetVertTile(true) t:SetPoint("TOPRIGHT") t:SetPoint("BOTTOMRIGHT")
		t:SetTexCoord(1,0, 0,1)
		t = lf:CreateTexture(nil, "BORDER", nil, -1)
		t:SetAtlas("!Garr_InfoBox-Left", true)
		t:SetPoint("TOPLEFT", -7, 0)
		t:SetPoint("BOTTOMLEFT", -7, 0)
		t:SetVertTile(true)
		t = lf:CreateTexture(nil, "BORDER", nil, -1)
		t:SetAtlas("!Garr_InfoBox-Left", true)
		t:SetPoint("TOPRIGHT", 7, 0)
		t:SetPoint("BOTTOMRIGHT", 7, 0)
		t:SetVertTile(true)
		t:SetTexCoord(1,0, 0,1)
		t = lf:CreateTexture(nil, "BORDER", nil, -1)
		t:SetAtlas("_Garr_InfoBox-Top", true)
		t:SetPoint("TOPLEFT", 0, 7)
		t:SetPoint("TOPRIGHT", 0, 7)
		t:SetHorizTile(true)
		t = lf:CreateTexture(nil, "BORDER", nil, -1)
		t:SetAtlas("_Garr_InfoBox-Top", true)
		t:SetPoint("BOTTOMLEFT", 0, -7)
		t:SetPoint("BOTTOMRIGHT", 0, -7)
		t:SetHorizTile(true)
		t:SetTexCoord(0,1, 1,0)
		t = lf:CreateTexture(nil, "BORDER", nil, 1)
		t:SetAtlas("Garr_InfoBoxBorder-Corner", true)
		t:SetPoint("TOPLEFT")
		t = lf:CreateTexture(nil, "BORDER", nil, 1)
		t:SetAtlas("Garr_InfoBoxBorder-Corner", true)
		t:SetPoint("TOPRIGHT") t:SetTexCoord(1,0, 0,1)
		t = lf:CreateTexture(nil, "BORDER", nil, 1)
		t:SetAtlas("Garr_InfoBoxBorder-Corner", true)
		t:SetPoint("BOTTOMLEFT") t:SetTexCoord(0,1, 1,0)
		t = lf:CreateTexture(nil, "BORDER", nil, 1)
		t:SetAtlas("Garr_InfoBoxBorder-Corner", true)
		t:SetPoint("BOTTOMRIGHT") t:SetTexCoord(1,0, 1,0)
		t = lf:CreateFontString(nil, "ARTWORK", "QuestFont_Super_Huge")
		t:SetPoint("TOP", 0, -12)
		t:SetText((GARRISON_MISSION_REPORT:gsub("\n", " ")))
		t = lf:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge")
		t:SetPoint("TOP", 0, -40)
		lf.numMissions = t
		t = lf:CreateTexture(nil, "BORDER", nil, 1)
		t:SetAtlas("Garr_InfoBox-CornerShadow", true)
		t:SetPoint("BOTTOMRIGHT", lf, "TOPLEFT")
		t = lf:CreateTexture(nil, "BORDER", nil, 1)
		t:SetAtlas("Garr_InfoBox-CornerShadow", true)
		t:SetPoint("BOTTOMLEFT", lf, "TOPRIGHT")
		t:SetTexCoord(1,0, 0,1)
		t = lf:CreateTexture(nil, "BORDER", nil, 1)
		t:SetAtlas("Garr_InfoBox-CornerShadow", true)
		t:SetPoint("TOPRIGHT", lf, "BOTTOMLEFT")
		t:SetTexCoord(0,1, 1,0)
		t = lf:CreateTexture(nil, "BORDER", nil, 1)
		t:SetAtlas("Garr_InfoBox-CornerShadow", true)
		t:SetPoint("TOPLEFT", lf, "BOTTOMRIGHT")
		t:SetTexCoord(1,0, 1,0)
		local function close(self)
			lootFrame:Hide()
			GarrisonMissionFrame.MissionComplete.completeMissions = C_Garrison.GetCompleteMissions(1)
			GarrisonMissionFrame:UpdateMissions()
			RefreshActiveMissionsView(self == lootFrame.Dismiss)
		end
		t = CreateFrame("Button", "MPLootSummaryDone", lootFrame, "UIPanelButtonTemplate")
		t:SetSize(200, 24) t:SetText(L"Done") t:SetPoint("BOTTOM", 0, 18)
		t:SetScript("OnClick", close)
		t:SetScript("OnKeyDown", function(self, key)
			self:SetPropagateKeyboardInput(key ~= "SPACE" and key ~= "ESCAPE")
			if key == "SPACE" then
				self:Click()
			elseif key == "ESCAPE" then
				lf.Dismiss2:Click()
			end
		end)
		t, lf.Dismiss = CreateFrame("Button", nil, lootFrame, "UIPanelCloseButtonNoScripts"), t
		t:SetSize(28, 28)
		t:SetPoint("TOPRIGHT", 0, -2)
		t:SetScript("OnClick", close)
		lf.Dismiss2 = t
		t = lf:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		t:SetPoint("BOTTOM", lf.Dismiss, "TOP", 0, 6)
		t:SetText(("|cffff2020%s|r|n%s"):format(L"You have no free bag slots.", L"Additional mission loot may be delivered via mail."))
		lf.noBagSlots = t
		lf:Hide()
		lf:SetScript("OnShow", function(self)
			if self.onShowSound then
				PlaySound(self.onShowSound)
				self.onShowSound = nil
			end
		end)
	end
	local lootContainer, SetFollower = CreateFrame("Frame", nil, lootFrame) do
		lootContainer:SetSize(490, 280)
		lootContainer:SetPoint("TOP", 0, -65)
		lootContainer:RegisterEvent("GET_ITEM_INFO_RECEIVED")
		lootContainer:SetScript("OnEvent", function(self)
			for i=1,#self.items do
				local ii = self.items[i]
				if ii.itemID and ii:IsShown() then
					ii:SetIcon(select(10, GetItemInfo(ii.itemID)) or GetItemIcon(ii.itemID) or "Interface\\Icons\\Temp")
				end
			end
		end)
		do
			local function AnimateXP(self, elapsed)
				if self.levelUp:IsShown() then return end
				local elapsed = self.xpGainElapsed + elapsed
				local prog = elapsed > 0.75 and 1 or (elapsed/0.75)
				self.xpProgressTex2:SetWidth(math.max(0.01, sin(90*prog) * self.xpGainWidth))
				if prog == 1 then
					self.xpGainWidth, self.xpGainElapsed = nil
					self:SetScript("OnUpdate", nil)
				else
					self.xpGainElapsed = elapsed
				end
			end
			function SetFollower(btn, info, award, oldQuality)
				if not info then return end
				local color = ITEM_QUALITY_COLORS[info.quality]
				btn.PortraitRingQuality:SetVertexColor(color.r, color.g, color.b)
				btn.LevelBorder:SetVertexColor(color.r, color.g, color.b)
				btn.Level:SetText(info.level);
				local pico = info.portraitIconID or 0
				btn.Portrait:SetTexture(pico ~= 0 and pico or "Interface\\Garrison\\Portraits\\FollowerPortrait_NoPortrait")
				if info.levelXP > info.xp and award > 0 then
					local baseXP = info.xp - math.min(info.xp, award)
					btn.xpProgressTex:SetWidth(math.max(0.01,46*baseXP/info.levelXP))
					btn.xpProgressTex2:SetWidth(0.01)
					btn.xpGainWidth, btn.xpGainElapsed = 46*math.min(info.xp - baseXP, award)/info.levelXP, 0
					btn.xpProgressTex2:Show()
					btn:SetScript("OnUpdate", AnimateXP)
					btn.xpProgressTex:SetShown(baseXP > 0)
					btn.xpProgressTex2:Show()
				else
					btn:SetScript("OnUpdate", nil)
					btn.xpProgressTex:Hide()
					btn.xpProgressTex2:Hide()
				end
				btn.info, btn.awardXP = info, award or 0
				if award and award > (info.xp or 0) or (oldQuality and oldQuality ~= info.quality) then
					lootFrame.onShowSound = SOUNDKIT.UI_GARRISON_COMMAND_TABLE_FOLLOWER_LEVEL_UP
					btn.levelUp:Show()
					btn.levelUp:SetAlpha(1)
					btn.levelUp.Anim:Play()
					btn.Level:SetFontObject(GameFontNormalSmall)
					btn.LevelUpAnim:Play()
				else
					btn.levelUp:SetAlpha(0)
					btn.levelUp:Hide()
					btn.LevelUpAnim:Stop()
					btn.Level:SetFontObject(GameFontHighlightSmall)
				end
				btn:Show()
			end
		end
		lootContainer.followers = {} do
			local function FollowerButton_OnEnter(self)
				local info = self.info
				FollowerTooltip_SetFollower(self, info)
				G.ExtendFollowerTooltipGainedXP(GarrisonFollowerTooltip, self.awardXP, info)
			end
			local function FollowerButton_OnClick(self)
				local id = self.info and self.info.followerID
				if id and IsModifiedClick("CHATLINK") then
					ChatEdit_InsertLink(C_Garrison.GetFollowerLink(id))
				end
			end
			local function LevelPulse_OnStop(self)
				self:GetParent().pulse:SetAlpha(0)
			end
			local function CreateFollower()
				local b = CreateFrame("Button", nil, lootContainer, "GarrisonFollowerPortraitTemplate")
				b.levelUp = CreateFrame("Frame", nil, b, "GarrisonFollowerLevelUpTemplate")
				b.levelUp:SetScale(0.5)
				b.levelUp:SetPoint("BOTTOM", 0, -47)
				b.xpProgressTex = b:CreateTexture(nil, "ARTWORK", nil, 2)
				b.xpProgressTex:SetPoint("TOPLEFT", b.LevelBorder, "TOPLEFT", 6, -6)
				b.xpProgressTex:SetTexture("Interface\\Buttons\\GradBlue")
				b.xpProgressTex:SetAlpha(0.4)
				b.xpProgressTex:SetSize(30, 12)
				b.xpProgressTex2 = b:CreateTexture(nil, "ARTWORK", nil, 2)
				b.xpProgressTex2:SetTexture("Interface\\Buttons\\GradBlue")
				b.xpProgressTex2:SetAlpha(0.6)
				b.xpProgressTex2:SetSize(30, 12)
				b.xpProgressTex2:SetPoint("LEFT", b.xpProgressTex, "RIGHT")
				b.pulse = b:CreateTexture(nil, "BORDER", nil, 0)
				b.pulse:SetAtlas("GarrMission_CurrentEncounter-Glow", true)
				b.pulse:SetPoint("CENTER", b.Portrait)
				b.pulse:SetAlpha(0)
				b.LevelUpAnim = b:CreateAnimationGroup()
				b.LevelUpAnim:SetLooping("REPEAT")
				b.LevelUpAnim:SetScript("OnStop", LevelPulse_OnStop)
				local t = b.LevelUpAnim:CreateAnimation("Alpha")
				t:SetEndDelay(1.25)
				t:SetDuration(1.5) t:SetFromAlpha(0) t:SetToAlpha(1)
				t:SetChildKey("pulse")
				local t = b.LevelUpAnim:CreateAnimation("Alpha")
				t:SetStartDelay(1.5) t:SetEndDelay(0.25)
				t:SetDuration(1) t:SetFromAlpha(1) t:SetToAlpha(0)
				t:SetChildKey("pulse")
				
				b:SetScript("OnEnter", FollowerButton_OnEnter)
				b:SetScript("OnLeave", GarrisonMissionPageFollowerFrame_OnLeave)
				b:SetScript("OnClick", FollowerButton_OnClick)
				b:Hide()
				return b
			end
			setmetatable(lootContainer.followers, {__index=function(self, k)
				local b = CreateFollower()
				self[k] = b
				return b
			end})
		end
		lootContainer.items = {} do
			local function OnEnter(self)
				GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
				if self.itemID then
					G.SetItemTooltip(GameTooltip, self.itemID)
				elseif self.tooltipHeader and self.tooltipText then
					GameTooltip:AddLine(self.tooltipHeader)
					GameTooltip:AddLine(self.tooltipText, 1,1,1)
				elseif self.currencyID then
					GameTooltip:SetCurrencyByID(self.currencyID)
				else
					GameTooltip:Hide()
					return
				end
				if self.tooltipExtra then
					GameTooltip:AddLine(self.tooltipExtra, 1,1,1)
				end
				GameTooltip:Show()
			end
			local function OnClick(self)
				local link
				if not IsModifiedClick("CHATLINK") then
				elseif self.itemID then
					link = select(2, GetItemInfo(self.itemID))
				elseif self.currencyID and self.currencyID > 0 then
					link = Nine.GetCurrencyLink(self.currencyID, tonumber(self.Quantity:GetText() or 1) or 1)
				end
				if link then
					ChatEdit_InsertLink(link)
				end
			end
			local function SetIcon(self, texture)
				self.Icon:SetTexture(texture)
				self.Icon:SetTexCoord(4/64, 60/64, 4/64, 60/64)
			end
			setmetatable(lootContainer.items, {__index=function(self, k)
				local i = CreateFrame("Button", nil, lootContainer)
				i:SetSize(46, 46)
				i.Icon = i:CreateTexture(nil, "ARTWORK")
				i.Icon:SetPoint("TOPLEFT", 3*46/64, -3*46/64)
				i.Icon:SetPoint("BOTTOMRIGHT", -3*46/64, 3*46/64)
				i.Border = i:CreateTexture(nil, "ARTWORK", 2)
				i.Border:SetAllPoints()
				i.Border:SetTexture("Interface\\Buttons\\UI-Quickslot2")
				i.Border:SetTexCoord(12/64,52/64,12/64,52/64)
				i.Quantity = i:CreateFontString(nil, "OVERLAY", "GameFontHighlightOutline")
				i.Quantity:SetPoint("BOTTOMRIGHT", -3, 4)
				i:SetScript("OnEnter", OnEnter)
				i:SetScript("OnLeave", dismissTooltip)
				i:SetScript("OnClick", OnClick)
				self[k], i.SetIcon = i, SetIcon
				return i
			end})
		end
	end
	lootContainer.nothing = lootContainer:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	lootContainer.nothing:SetPoint("CENTER")
	lootContainer.nothing:SetText(L"No loot received.")
	function activeUI:SetCompletionRewards(rewards, followers, numMissions, overflowLoot)
		lootFrame.noBagSlots:SetShown(overflowLoot)
		lootFrame.numMissions:SetFormattedText(GARRISON_NUM_COMPLETED_MISSIONS, numMissions or 1)
		lootFrame.onShowSound = SOUNDKIT[rewards and next(rewards) and "UI_GARRISON_COMMAND_TABLE_CHEST_UNLOCK_GOLD_SUCCESS" or "UI_GARRISON_COMMAND_TABLE_CHEST_UNLOCK"]
		
		local fi, fn = G.GetFollowerInfo(), 1
		for k,v in pairs(followers) do
			if v.xpAward and v.xpAward > 0 then
				SetFollower(lootContainer.followers[fn], fi[k], v.xpAward, v.oqual)
				fn = fn + 1
			end
		end
		for i=fn, #lootContainer.followers do
			lootContainer.followers[i]:Hide()
		end

		local ni = 1
		for k,v in pairs(rewards) do
			local quantity, icon, tooltipHeader, tooltipText, _, tooltipExtra = v.quantity
			if v.itemID then
				icon, tooltipExtra = select(10, GetItemInfo(v.itemID)) or GetItemIcon(v.itemID) or "Interface\\Icons\\Temp", v.itemID == 120205 and rewards.xp and rewards.xp.playerXP and XP_GAIN:format(BreakUpLargeNumbers(rewards.xp.playerXP)) or nil
			elseif v.currencyID == 0 then
				icon, tooltipHeader, tooltipText = "Interface\\Icons\\INV_Misc_Coin_02", GARRISON_REWARD_MONEY, GetMoneyString(v.quantity)
				quantity = floor(quantity/10000)
			elseif v.currencyID then
				_, _, icon = Nine.GetCurrencyInfo(v.currencyID)
			end
			if icon then
				local ib = lootContainer.items[ni]
				ib:SetPoint("CENTER", lootContainer.followers[fn], "CENTER", 0, 4)
				ib:SetIcon(icon)
				ib.Quantity:SetText(quantity > 1 and quantity)
				ib.itemID, ib.currencyID, ib.tooltipHeader, ib.tooltipText, ib.tooltipExtra = v.itemID, v.currencyID, tooltipHeader, tooltipText, tooltipExtra
				ib:Show()
				ni, fn = ni + 1, fn + 1
			end
		end
		for i=ni,#lootContainer.items do
			lootContainer.items[i]:Hide()
		end
		
		local numTotal = fn - 1 do
			local perRow, baseY = 9, 0, 0
			if numTotal <= 9 then
				perRow, baseY = numTotal, -76
			elseif numTotal <= 18 then
				perRow, baseY = 6, numTotal <= 12 and -64 or -32
			elseif numTotal <= 32 then
				perRow, baseY = 8, numTotal <= 24 and -24 or 0
			end
			local baseX = (504 - perRow*56)/2
			for i=1,numTotal do
				lootContainer.followers[i]:SetPoint("TOPLEFT", baseX + ((i-1) % perRow) * 56, baseY - 64*floor((i-1)/perRow))
			end
			lootContainer.count = numTotal
		end
		
		lootContainer.nothing:SetShown(ni == 1 and fn == 1)
		lootFrame:Show()
	end
end
local availUI = CreateFrame("Frame", nil, missionList) do
	availUI:SetSize(880, 22)
	availUI:SetPoint("BOTTOMLEFT", GarrisonMissionFrameMissions, "TOPLEFT", 0, 4)
	availUI:Hide()
	local ctl = CreateFrame("Frame") do
		ctl:SetSize(56, 22)
		local sortIndicator = CreateFrame("Button", nil, ctl) do
			sortIndicator:SetPoint("LEFT", 4, 0)
			sortIndicator:SetSize(20, 20)
			for i=1, 2 do
				local t = sortIndicator:CreateTexture(nil, i == 1 and "BACKGROUND" or "HIGHLIGHT")
				t:SetTexture("Interface\\Buttons\\SquareButtonTextures")
				t:SetTexCoord(0.45312500, 0.64062500, 0.01562500, 0.20312500)
				t:SetSize(14, 18)
				t:SetPoint("LEFT", 2, 4)
				if i == 1 then t:SetVertexColor(3/4, 3/4, 3/4) end
				t = sortIndicator:CreateTexture(nil, i == 1 and "BACKGROUND" or "HIGHLIGHT")
				t:SetTexture("Interface\\Buttons\\SquareButtonTextures")
				t:SetTexCoord(0.45312500, 0.64062500, 0.20312500, 0.01562500)
				t:SetSize(14, 18)
				t:SetPoint("LEFT", 2, -4)
				if i == 1 then t:SetVertexColor(3/4, 3/4, 3/4) end
			end
		
			local menu, sortOrders = {
				{text=L"Mission order:", isTitle=true, notCheckable=true},
				{text=L"Reward type", arg1="reward"},
				{text=L"Follower experience", arg1="xp"},
				{text=L"Follower experience per hour", arg1="xptime"},
				{text=L"Chance of success", arg1="threats"},
				{text=L"Mission level", arg1="level"},
				{text=L"Mission duration", arg1="duration"},
				{text=L"Mission expiration", arg1="expire"},
			}, {}
			local function isChecked(self)
				return T.config.availableMissionSort == self.arg1
			end
			for i=2,#menu do
				local m = menu[i]
				sortOrders[m.arg1], m.checked, m.func = m.text, isChecked, MasterPlan.SetMissionOrder
			end
			
			sortIndicator:SetScript("OnClick", function(self)
				easyDrop:Toggle(self, menu, "TOPLEFT", self, "BOTTOMLEFT", -24, -3)
			end)
			sortIndicator:SetScript("OnEnter", function(self)
				easyDrop:DelayOpenClick(self)
			end)
		end
		local horizon = CreateFrame("Button", nil, ctl) do
			horizon:SetPoint("LEFT", 30, 0)
			horizon:SetSize(20, 20)
			for i=1, 2 do
				local t = horizon:CreateTexture(nil, i == 1 and "BACKGROUND" or "HIGHLIGHT")
				t:SetTexture("Interface\\FriendsFrame\\StatusIcon-Away")
				t:SetSize(16,16)
				t:SetPoint("LEFT", 2, 0)
				t:SetTexCoord(2/16, 14/16, 2/16, 14/16)
				if i == 1 then
					t:SetVertexColor(3/4, 3/4, 3/4)
				end
			end
		
			local function isChecked(self)
				return T.config.timeHorizon == self.arg1
			end
			local menu = {
				{text=L"Time Horizon", isTitle=true, notCheckable=true, justifyH="CENTER"},
				{text=L"Instant", checked=isChecked, func=MasterPlan.SetTimeHorizon, arg1=0},
				{arg1=3600},
				{arg1=7200},
				{arg1=10800},
				{arg1=14400},
				{arg1=21600},
				{arg1=28800},
				{arg1=43200},
				{arg1=86400},
			}
			for i=3,#menu do
				menu[i].text, menu[i].checked, menu[i].func = INT_GENERAL_DURATION_HOURS:format(menu[i].arg1/3600), isChecked, MasterPlan.SetTimeHorizon
			end
			local function showHint()
				if easyDrop:IsOpen(horizon) then
					GameTooltip:SetOwner(horizon, "ANCHOR_PRESERVE")
					GameTooltip:ClearAllPoints()
					GameTooltip:SetPoint("TOPLEFT", DropDownList1, "TOPRIGHT", 4, 0)
					GameTooltip:SetText(L"Time Horizon")
					GameTooltip:AddLine(L"Time until you next expect to be able to interact with garrison missions.\n\nThis may affect suggested groups and mission sorting order.", 1,1,1,1)
					GameTooltip:Show()
				end
			end
			horizon:SetScript("OnClick", function(self)
				easyDrop:Toggle(self, menu, "TOPLEFT", self, "BOTTOMLEFT", -24, -3)
				showHint()
			end)
			horizon.OnEasyDropHide = dismissTooltip
			horizon:SetScript("OnEnter", function(self)
				easyDrop:DelayOpenClick(self)
				showHint()
			end)
		end
		local loader = api.CreateLoader(ctl, 10, 4, 10, 8, true) do
			loader:SetPoint("LEFT", horizon, "RIGHT", 8, 0)
			local baseWidth = ctl:GetWidth()
			loader:HookScript("OnShow", function()
				missionList.ctlContainer:SetInnerWidth(baseWidth + 8 + loader:GetWidth(), true)
			end)
			loader:HookScript("OnHide", function()
				missionList.ctlContainer:SetInnerWidth(baseWidth)
			end)
			availUI.loader = loader
		end
	end
	availUI:SetScript("OnShow", function(self)
		missionList.ctlContainer:Steal(self, ctl)
		RefreshAvailMissionsView(true)
		self.notebook:SetShown(GetItemCount(self.notebook.itemID) > 0)
	end)
	local roamingParty = CreateFrame("Frame", nil, availUI) do
		roamingParty:SetPoint("BOTTOMRIGHT", availUI, "BOTTOM", 106, -2)
		local slots = {}
		function roamingParty:GetFollowers()
			local a, b, c
			for i=#slots,1,-1 do
				a, b, c = slots[i].followerID, a, b
			end
			return a, b, c
		end
		function roamingParty:DropFollowers(f1, f2, f3)
			for i=1,#slots do
				local f = slots[i].followerID
				if f and (f == f1 or f == f2 or f == f3) then
					slots[i].followerID = nil
				end
			end
			self:Update()
		end
		function roamingParty:Update(changed)
			changed = changed or false
			for i=1,#slots do
				local f, fi = slots[i].followerID
				if f then
					fi = C_Garrison.GetFollowerInfo(f)
					if not fi or ((fi.status or "") ~= "" and fi.status ~= GARRISON_FOLLOWER_IN_PARTY) then
						changed, f = true
					end
				end
				if f then
					slots[i].portrait:SetTexture(fi.portraitIconID)
					slots[i].portrait:SetVertexColor(1, 1, 1)
				else
					slots[i].portrait:SetTexture("Interface\\Garrison\\Portraits\\FollowerPortrait_NoPortrait")
					slots[i].portrait:SetVertexColor(0.50, 0.50, 0.50)
				end
				slots[i].followerID = f
			end
			if changed then
				availMissionsHandle:Refresh(true)
			end
		end
		function roamingParty:Clear()
			for i=1,#slots do
				slots[i].followerID = nil
			end
			self:Update(true)
		end
		local function Roamer_SetFollower(_, slot, follower)
			local self = roamingParty
			if slots[slot].followerID ~= follower then
				for i=1,#slots do
					if slots[i].followerID == follower then
						slots[i].followerID = nil
					end
				end
				PlaySound(SOUNDKIT[follower and "UI_GARRISON_COMMAND_TABLE_ASSIGN_FOLLOWER" or "UI_GARRISON_COMMAND_TABLE_UNASSIGN_FOLLOWER"])
				slots[slot].followerID = follower
				self:Update(true)
			end
		end
		local function cmp(a,b)
			local am, bm = a.level == T.FOLLOWER_LEVEL_CAP and a.quality > 3, b.level == T.FOLLOWER_LEVEL_CAP and b.quality > 3
			if am ~= bm then
				return bm
			elseif a.level ~= b.level then
				return a.level > b.level
			elseif floor(a.iLevel/15) ~= floor(b.iLevel/15) then
				return a.iLevel > b.iLevel
			elseif a.quality ~= b.quality then
				return a.quality > b.quality
			else
				return strcmputf8i(a.name, b.name) < 0
			end
		end
		local function Roamer_OnEnter(self)
			if easyDrop:IsOpen(self) then
			elseif self.followerID then
				for i=1,#slots do
					if easyDrop:IsOpen(slots[i]) then
						return
					end
				end
				FollowerTooltip_SetFollower(self, C_Garrison.GetFollowerInfo(self.followerID))
			else
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
				GameTooltip:SetText(L"Select a follower to focus on")
				GameTooltip:AddLine(L"Group suggestions will be updated to include the selected follower.", 1,1,1,1)
				GameTooltip:Show()
			end
		end
		local function Roamer_OnLeave(self)
			GarrisonFollowerTooltip:Hide()
			if GameTooltip:IsOwned(self) then
				GameTooltip:Hide()
			end
		end
		local function RoamerMenu_OnMouse(self, _, id)
			if self and id then
				FollowerTooltip_SetFollower(self, C_Garrison.GetFollowerInfo(id))
				GarrisonFollowerTooltip:ClearAllPoints()
				GarrisonFollowerTooltip:SetPoint("LEFT", self, "RIGHT", 12, 0)
				return RoamerMenu_OnMouse
			else
				GarrisonFollowerTooltip:Hide()
			end
		end
		local function Roamer_OnClick(self, button)
			if GameTooltip:IsOwned(self) then
				GameTooltip:Hide()
			end
			if button == "RightButton" then
				Roamer_SetFollower(nil, self:GetID(), nil)
				GarrisonFollowerTooltip:Hide()
				self:GetScript("OnEnter")(self)
			elseif easyDrop:IsOpen(self) then
				CloseDropDownMenus()
				PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
				self:GetScript("OnEnter")(self)
			else
				PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
				local mn, f2, slot, cur = {}, C_Garrison.GetFollowers(1), self:GetID(), self.followerID
				local a1, a2, a3 = roamingParty:GetFollowers()
				table.sort(f2, cmp)
				for i=1,#f2 do
					local fi, fid = f2[i], f2[i].followerID
					if fi.isCollected and (fi.status or "") == "" and (fid == cur or (fid ~= a1 and fid ~= a2 and fid ~= a3)) and not T.config.ignore[fid] and not G.GetFollowerTentativeMission(fid) then
						mn[#mn+1] = {text=G.GetFollowerLevelDescription(fi.followerID, nil), func=Roamer_SetFollower, arg1=slot, arg2=fi.followerID, checked=cur==fi.followerID, tooltipOnButton=RoamerMenu_OnMouse}
					end
				end
				if cur then
					mn[#mn+1] = {text=REMOVE, func=Roamer_SetFollower, arg1=slot, justifyH="CENTER", notCheckable=true}
				end
				GarrisonFollowerTooltip:Hide()
				easyDrop:Open(self, mn, "TOP", self, "BOTTOM", 0, -2)
			end
		end
		for i=1,1 do
			local x = CreateFrame("Button", nil, roamingParty, nil, i)
			x:SetSize(36, 36)	x:SetPoint("LEFT", 40*i-38, 0) x:RegisterForClicks("LeftButtonUp", "RightButtonUp")
			local v = x:CreateTexture(nil, "ARTWORK", nil, 1) v:SetPoint("TOPLEFT", 3, -3) v:SetPoint("BOTTOMRIGHT", -3, 3) v:SetTexture("Interface\\Garrison\\Portraits\\FollowerPortrait_NoPortrait")
			slots[i], x.portrait = x, v
			local v = x:CreateTexture(nil, "ARTWORK", nil, 2) v:SetAllPoints() v:SetAtlas("Garr_FollowerPortrait_Ring", true)
			local v = x:CreateTexture(nil, "HIGHLIGHT") v:SetPoint("TOPLEFT", -2, 2) v:SetPoint("BOTTOMRIGHT", 1, -1) v:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight") v:SetBlendMode("ADD")
			x:SetScript("OnClick", Roamer_OnClick)
			x:SetScript("OnEnter", Roamer_OnEnter)
			x:SetScript("OnLeave", Roamer_OnLeave)
		end
		roamingParty:SetSize(#slots*40, 36)
		local function clearRP()
			roamingParty:Clear()
		end
		function EV:GARRISON_MISSION_NPC_CLOSED()
			T.After0(clearRP)
		end
	end
	availUI.SendTentative = CreateFrame("Button", "MPPokeTentativeParties", availUI, "UIPanelButtonTemplate") do
		local b = availUI.SendTentative
		b:SetSize(200, 26)
		b:SetPoint("BOTTOM", -64, 5)
		b:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		b:Hide()
		b:SetScript("OnLeave", dismissTooltip)
		b:SetScript("OnEnter", function(self)
			if G.GetNumPendingMissionStarts() > 0 or G.GetTentativePartyCount(1) == 0 then return end
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
			GameTooltip:SetText(L"Start Missions")
			if C_Garrison.IsAboveFollowerSoftCap(1) then
				GameTooltip:AddLine(GARRISON_MAX_FOLLOWERS_MISSION_TOOLTIP, 1, 0, 0, 1)
			else
				local rewards, rtext = {}, ""
				for mid, f1, f2, f3 in G.GetReadyTentativeParties(1) do
					local mi = C_Garrison.GetBasicMissionInfo(mid)
					local g = G.GetBackfillMissionGroups(mi, G.GroupFilter.ACTIVE, G.GroupRank.xp, 1, f1, f2, f3)[1]
					if not g then
						G.GetMissionParty(mid)
					else
						GameTooltip:AddDoubleLine(HIGHLIGHT_FONT_COLOR_CODE .. mi.name, g[1] .. "%")
						local sp, ct, cq, _, expectedXP = g[1]/100, g[9] or 0, g[3] or 0, G.GetMissionGroupXP(g, mi)
						if expectedXP > 0 then
							rewards.xp = (rewards.xp or 0) + expectedXP
						end
						if g[1] > 0 and cq > 0 then
							rewards[ct] = (rewards[ct] or 0) + cq*sp
						end
					end
				end
				if (rewards.xp or 0) > 0 then
					rtext = L("%s XP"):format(BreakUpLargeNumbers(rewards.xp))
				end
				if (rewards[0] or 0) >= 1e4 then
					rtext = rtext .. "  " .. GetMoneyString(rewards[0] - rewards[0] % 1e4)
				end
				rewards.xp, rewards[0] = nil
				for cid, cq in pairs(rewards) do
					rtext = rtext .. "  " .. floor(cq) .. " |T" .. (select(3,Nine.GetCurrencyInfo(cid)) or "Interface/Icons/Temp") .. ":12:12:0:0:64:64:4:60:4:60|t"
				end
				if rtext ~= "" then
					GameTooltip:AddDoubleLine(L"Expected rewards:", rtext, nil, nil, nil, 1,1,1)
				end
			end
			GameTooltip:AddLine("|n|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:14:12:0:-1:512:512:10:70:330:410|t " .. L"Clear all tentative parties.", 0.5, 0.8, 1)
			GameTooltip:Show()
		end)
		b:SetScript("OnClick", function(_, button)
			if G.GetNumPendingMissionStarts() > 0 then
				G.AbortMissionQueue()
				RefreshAvailMissionsView()
			elseif button == "RightButton" or G.GetTentativePartyCount(1) == 0 then
				G.DissolveAllTentativeParties(1)
				PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
			elseif not C_Garrison.IsAboveFollowerSoftCap(1) then
				G.SuppressFollowerEvents(1)
				for mid, p1, p2, p3 in G.GetReadyTentativeParties(1) do
					G.StartMissionQueue(mid, p1, p2, p3)
				end
				G.ReleaseFollowerEvents(1)
				PlaySound(SOUNDKIT.UI_GARRISON_COMMAND_TABLE_MISSION_START)
			end
		end)
		
		local syncLater do
			local synced = true
			local function sync()
				synced = true
				local np = G.GetNumPendingMissionStarts()
				local nr, nt = G.GetTentativePartyCount(1)
				b:SetShown(np > 0 or nt > 0)
				if b:IsShown() then
					local text
					if np > 0 then
						text = L("%d |4party:parties; remaining..."):format(np)
					else
						text = nr > 0 and L"Send Tentative Parties" or L"Clear Tentative Parties"
					end
					b:SetText(text)
					if GameTooltip:IsOwned(b) then
						if np == 0 then
							b:GetScript("OnEnter")(b)
						else
							GameTooltip:Hide()
						end
					end
				end
			end
			function syncLater()
				if synced then
					T.After0(sync)
					synced = false
				end
			end
			EV.MP_MISSION_START_QUEUE, EV.MP_TENTATIVE_PARTY_UPDATE = sync, syncLater
		end
		function EV:MP_MISSION_REJECT(mid)
			syncLater()
			G.GetMissionParty(mid, true)
			PlaySound(847)
		end
	end
	api.roamingParty = roamingParty
	availUI.notebook = T.CreateLazyItemButton(availUI, 122606) do
		availUI.notebook:SetSize(20, 20)
		availUI.notebook:SetPoint("LEFT", GarrisonMissionFrame.MissionTab.MissionList.MaterialFrame, "LEFT", 14, 0)
		availUI.notebook:SetScript("OnShow", function()
			local f = GarrisonMissionFrame.MissionTab.MissionList.MaterialFrame.MPHeadcount
			f.Text:SetPoint("LEFT", 40, 0)
		end)
		availUI.notebook:SetScript("OnHide", function()
			local f = GarrisonMissionFrame.MissionTab.MissionList.MaterialFrame.MPHeadcount
			f.Text:SetPoint("LEFT", 16, 0)
		end)
	end
end
local interestUI = CreateFrame("Frame", nil, missionList) do
	interestUI:Hide()
	interestUI.loader = api.CreateLoader(interestUI, 20, 30, 20)
	interestUI.loader:SetPoint("CENTER", GarrisonMissionFrameMissions)
	function interestUI.loader:OnFinish(nf)
		if nf > 2 then
			missionList.FadeIn:Play()
		end
	end
	local ctl = CreateFrame("Frame") do
		ctl:SetSize(83, 22)
		ctl:Hide()
		interestUI.excludeInactive = CreateFrame("CheckButton", nil, ctl) do
			local b = interestUI.excludeInactive
			b:SetSize(20, 20)
			b:SetPoint("LEFT", 3, 0)
			b:SetChecked(true)
			b:SetNormalTexture("Interface\\FriendsFrame\\UI-Toast-FriendOnlineIcon")
			b:SetHighlightTexture("Interface\\FriendsFrame\\UI-Toast-FriendOnlineIcon")
			b:SetCheckedTexture("Interface\\PetBattles\\DeadPetIcon")
			local nt = b:GetNormalTexture()
			nt:SetTexCoord(4/32,28/32, 4/32,28/32)
			nt:SetVertexColor(0.84, 0.76, 0.56)
			local ct = b:GetCheckedTexture()
			ct:SetBlendMode("BLEND")
			ct:ClearAllPoints()
			ct:SetSize(12, 12)
			ct:SetPoint("BOTTOMRIGHT")
			local ht = b:GetHighlightTexture()
			ht:SetTexCoord(4/32,28/32, 4/32,28/32)
			ht:SetAlpha(0.25)
			b:SetScript("OnClick", function(self)
				interestMissionsHandle:Show(not self:GetChecked())
				if GameTooltip:IsOwned(self) then
					self:GetScript("OnEnter")(self)
				end
			end)
			b:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_NONE")
				GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", -24, -4)
				GameTooltip:SetText(self:GetChecked() and L"Ignoring inactive followers" or L"Considering inactive followers")
				GameTooltip:AddLine(self:GetChecked() and L"Inactive followers are never included in suggested groups." or L"Inactive followers are only included in suggested groups when they are beneficial.", 1,1,1, 1)
				GameTooltip:Show()
				easyDrop:Close()
			end)
			b:SetScript("OnLeave", dismissTooltip)
		end
		interestUI.stackMode = CreateFrame("Button", nil, ctl) do
			local b = interestUI.stackMode
			b:SetSize(20, 20)
			b:SetPoint("LEFT", 30, 0)
			b:SetScript("OnClick", function(self)
				T.config.interestStack = bit.bxor(1, T.config.interestStack)
				interestMissionsHandle:Show(not interestUI.excludeInactive:GetChecked())
				if GameTooltip:IsOwned(self) then
					self:GetScript("OnEnter")(self)
				end
				self:GetScript("OnShow")(self)
			end)
			b:SetScript("OnShow", function(self)
				local tex = T.config.interestStack % 2 > 0 and "Interface/Minimap/TRACKING/Auctioneer" or "Interface/Minimap/TRACKING/Banker"
				self:SetNormalTexture(tex)
				self:GetNormalTexture():SetVertexColor(0.85, 0.85, 0.85, 0.90)
				self:SetHighlightTexture(tex)
				self:GetHighlightTexture():SetBlendMode("ADD")
				self:GetHighlightTexture():SetAlpha(0.25)
			end)
			b:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_NONE")
				GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", -51, -4)
				local isStacking = T.config.interestStack % 2 > 0
				GameTooltip:AddLine(isStacking and L"Prioritizing expected reward" or L"Prioritizing success chance")
				GameTooltip:AddLine(L"When a mission's reward can be increased by follower traits, groups can prioritize either the expected reward or mission success chance.", 1,1,1, 1)
				GameTooltip:Show()
				easyDrop:Close()
			end)
			b:SetScript("OnLeave", dismissTooltip)
		end
		interestUI.interestSet = CreateFrame("Button", nil, ctl) do
			local b = interestUI.interestSet
			b:SetSize(20, 20)
			b:SetPoint("LEFT", 57, 0)
			b:SetNormalTexture("Interface\\Minimap\\ObjectIcons")
			b:SetHighlightTexture("Interface\\Minimap\\ObjectIcons")
			local nt = b:GetNormalTexture()
			nt:SetTexCoord(64/256, 96/256, 192/256, 224/256)
			nt:SetVertexColor(0.8, 0.8, 0.8)
			local ht = b:GetHighlightTexture()
			ht:SetTexCoord(64/256, 96/256, 192/256, 224/256)
			ht:SetAlpha(0.25)
			local m = {
				{isTitle=true, text=L"Desirable rewards", notCheckable=true, justifyH="CENTER"},
				{arg1=118529},
				{arg1=122484},
				{arg1=120945},
				{arg1=994},
				{arg1=823},
				{arg1=824},
				{arg1=1101},
				{arg1=128315},
				{arg1=128430},
				{arg1=127748},
				{arg1=128313},
				{arg1=128316},
				{arg1=115280, text="|TInterface\\Minimap\\ObjectIcons:16:16:0:0:256:256:194:222:130:158|t |cffff8000" .. ITEM_QUALITY5_DESC},
			}
			local function toggleInterestBit(_, key)
				T.config.interestMask = bit.bxor(T.config.interestMask, 2^(T.InterestMask[key]-1))
				interestMissionsHandle:Show(not interestUI.excludeInactive:GetChecked())
			end
			local function checkInterestBit(self)
				local b, m = T.InterestMask[self.arg1], T.config.interestMask
				return (m % 2^b) < 2^(b-1)
			end
			local function ShowInterestFilterTip(self, arg1)
				if type(arg1) ~= "number" or arg1 < 1 then return end
				GameTooltip:SetOwner(self, "ANCHOR_NONE")
				GameTooltip:SetPoint("TOPLEFT", self, "TOPRIGHT", 16, 8)
				if arg1 < 2e3 then
					GameTooltip:SetCurrencyByID(arg1)
				else
					GameTooltip:SetItemByID(Interest_RewardMap[arg1] or arg1)
				end
			end
			for i=2,#m do
				m[i].func, m[i].checked, m[i].isNotRadio, m[i].keepShownOnClick, m[i].tooltipOnButton = toggleInterestBit, checkInterestBit, true, true, ShowInterestFilterTip
			end
			b:SetScript("OnClick", function(self)
				if m[#m].arg1 == 115280 and T.config.legendStep >= 2 then
					m[#m] = nil
				end
				for i=2,#m do
					local mi = m[i]
					if (not mi.text or mi.placeholder) then
						local key, name, ico, _ = mi.arg1
						if key > 2e3 then
							name, ico = GetItemInfo(key), GetItemIcon(key)
						else
							name, _, ico = Nine.GetCurrencyInfo(key)
						end
						mi.text, mi.placeholder = "|T" .. (ico or "Interaface\\Icons\\INV_Misc_QuestionMark") .. ":16:16:0:0:64:64:4:60:4:60|t " .. (name or ("#" .. key)), not name or nil
					end
				end
				easyDrop:Toggle(self, m, "TOPLEFT", self, "BOTTOMLEFT", -78, -3)
			end)
			b:SetScript("OnEnter", function(self)
				easyDrop:DelayOpenClick(self)
			end)
			b:SetScript("OnLeave", dismissTooltip)
		end
	end
	interestUI:SetScript("OnShow", function(self)
		missionList.ctlContainer:Steal(self, ctl)
		interestMissionsHandle:Show(not interestUI.excludeInactive:GetChecked())
	end)
end
do -- tabs
	local activeTab = CreateFrame("Button", "GarrisonMissionFrameTab3", GarrisonMissionFrame, "GarrisonMissionFrameTabTemplate", 1)
	local availTab, followerTab = GarrisonMissionFrameTab1, GarrisonMissionFrameTab2
	local interestTab = CreateFrame("Button", "GarrisonMissionFrameTab4", GarrisonMissionFrame, "GarrisonMissionFrameTabTemplate", 1)
	missionList.activeTab, missionList.availTab, missionList.interestTab, missionList.followerTab = activeTab, availTab, interestTab, followerTab
	activeTab:SetPoint("LEFT", availTab, "RIGHT", -5, 0)
	interestTab:SetPoint("LEFT", activeTab, "RIGHT", -5, 0)
	activeTab.Pulse = activeTab:CreateAnimationGroup() do
		local function cloneTexture(parent, key)
			local t, o = parent:CreateTexture(nil, "BORDER"), parent[key]
			t:SetTexture(o:GetTexture())
			t:SetTexCoord(o:GetTexCoord())
			t:SetAllPoints(o)
			t:SetBlendMode(o:GetBlendMode())
			return t
		end
		activeTab.p1, activeTab.p2 = cloneTexture(activeTab, "LeftHighlight"), cloneTexture(activeTab, "RightHighlight")
		activeTab.p3, activeTab.p4 = cloneTexture(activeTab, "MiddleHighlight"), activeTab:CreateTexture(nil, "BACKGROUND", nil, 1)
		activeTab.p4:SetPoint("TOPLEFT", activeTab.p3, "TOPLEFT", -16, -1)
		activeTab.p4:SetPoint("BOTTOMRIGHT", activeTab.p3, "BOTTOMRIGHT", 6, 12)
		activeTab.p4:SetTexture("Interface\\Buttons\\UI-ListBox-Highlight")
		activeTab.p4:SetBlendMode("ADD")
		activeTab.p4:SetTexCoord(16/128, 112/128, 0, 1)
		
		local ag = activeTab.Pulse
		ag:SetLooping("BOUNCE")
		for i=1,4 do
			local ap = ag:CreateAnimation("Alpha")
			ap:SetDuration(1.25)
			ap:SetFromAlpha(0)
			ap:SetToAlpha(i < 4 and 0.5 or 0.2)
			ap:SetChildKey("p" .. i)
		end
		ag:Play()
		ag:SetScript("OnStop", function()
			for i=1,4 do
				activeTab["p" .. i]:SetAlpha(0)
			end
		end)
	end
	GarrisonMissionFrameTab2:SetPoint("LEFT", interestTab, "RIGHT", -5, 0)
	PanelTemplates_DeselectTab(activeTab)
	PanelTemplates_DeselectTab(interestTab)
	local function ResizeTabs()
		PanelTemplates_TabResize(activeTab, 10)
		PanelTemplates_TabResize(availTab, 10)
		PanelTemplates_TabResize(interestTab, 10)
	end
	hooksecurefunc("GarrisonMissionListTab_SetTab", function(self)
		if missionList:IsShown() and self then
			PanelTemplates_SetTab(GarrisonMissionFrame, self:GetID() == 2 and 3 or 1)
		end
	end)
	local function SetTabState(tab, selected)
		if selected == nil then
			PanelTemplates_SetDisabledTabState(tab)
		else
			(selected and PanelTemplates_SelectTab or PanelTemplates_DeselectTab)(tab)
		end
	end
	local updateMissionTabs = oncePerFrame(function()
		local cm = GarrisonMissionFrame.MissionComplete.completeMissions
		activeTab:SetFormattedText(L"Active Missions (%d)", math.max(#GarrisonMissionFrameMissions.inProgressMissions, cm and #cm or 0))
		availTab:SetFormattedText(L"Available Missions (%d)", #GarrisonMissionFrameMissions.availableMissions)
		interestTab:SetText(L"Missions of Interest")
		ResizeTabs()
		T.After0(ResizeTabs)
		if #GarrisonMissionFrameMissions.inProgressMissions == 0 and (cm and #cm or 0) == 0 then
			SetTabState(activeTab, nil)
		else
			SetTabState(activeTab, GarrisonMissionFrame.selectedTab == 3)
		end
		
		if not missionList:IsShown() then
			SetTabState(interestTab, nil)
		else
			SetTabState(interestTab, GarrisonMissionFrame.selectedTab == 4)
		end
		SetTabState(availTab, GarrisonMissionFrame.selectedTab == 1)
		SetTabState(followerTab, GarrisonMissionFrame.selectedTab == 2)
		api.roamingParty:Update()
		api:SetMissionsUI(GarrisonMissionFrame.selectedTab)
		local cm = C_Garrison.GetCompleteMissions(1)
		if GarrisonMissionFrame.selectedTab == 3 or (not cm or #cm == 0) then
			activeTab.Pulse:Stop()
		else
			activeTab.Pulse:Play()
		end
	end)
	T.UpdateMissionTabs = updateMissionTabs
	hooksecurefunc(GarrisonMissionFrame, "UpdateMissions", updateMissionTabs)
	GarrisonMissionFrame:HookScript("OnShow", updateMissionTabs)
	hooksecurefunc("PanelTemplates_UpdateTabs", function(frame)
		if frame == GarrisonMissionFrame then
			updateMissionTabs()
		end
	end)
	activeTab:SetScript("OnClick", function()
		PlaySound(SOUNDKIT.UI_GARRISON_NAV_TABS)
		if GarrisonMissionFrame.MissionTab.MissionPage:IsShown() then
			GarrisonMissionFrame.MissionTab.MissionPage.MinimizeButton:Click()
		end
		if GarrisonMissionFrame.selectedTab ~= 1 and GarrisonMissionFrame.selectedTab ~= 3 then
			SetMissionsFrameTab(1)
		end
		PanelTemplates_SetTab(GarrisonMissionFrame, 3)
		if not missionList:IsShown() then
			GarrisonMissionListTab_SetTab(GarrisonMissionFrameMissionsTab2)
		end
		GarrisonMissionFrame:CheckCompleteMissions()
	end)
	availTab:SetScript("OnClick", function()
		PlaySound(SOUNDKIT.UI_GARRISON_NAV_TABS)
		SetMissionsFrameTab(1)
		if not missionList:IsShown() then
			GarrisonMissionListTab_SetTab(GarrisonMissionFrameMissionsTab1)
		end
	end)
	interestTab:SetScript("OnClick", function()
		PlaySound(SOUNDKIT.UI_GARRISON_NAV_TABS)
		if GarrisonMissionFrame.MissionTab.MissionPage:IsShown() then
			GarrisonMissionFrame.MissionTab.MissionPage.MinimizeButton:Click()
		end
		SetMissionsFrameTab(1)
		PanelTemplates_SetTab(GarrisonMissionFrame, 4)
		api:SetMissionsUI(4)
	end)
	hooksecurefunc("GarrisonMissionListTab_SetTab", updateMissionTabs)
	function EV:GARRISON_MISSION_FINISHED()
		if GarrisonMissionFrame:IsVisible() and GarrisonMissionFrame.selectedTab ~= 3 then
			updateMissionTabs()
			PlaySound(SOUNDKIT.UI_GARRISON_TOAST_MISSION_COMPLETE)
		end
	end
end

local GetActiveMissions, StartCompleteAll, CompleteMission, ClearCompletionState, GetFollowerXPAward do
	local completionMissions, mark, completionFollowers = {}, {}

	local function cmp(a,b)
		local ac, bc = a.readyTime, b.readyTime
		if (not ac) ~= (not bc) then
			return not ac
		elseif ac == bc then
			ac, bc = strcmputf8i(a.name, b.name), 0
		end
		return ac < bc
	end
	function GetActiveMissions()
		local rt, rn, now = {}, 1, time()
		
		wipe(mark)
		for i=1,#completionMissions do
			rt[rn], rn, mark[completionMissions[i].missionID or 0] = completionMissions[i], rn + 1, 1
		end
		for j=1,2 do
			local t = C_Garrison[j == 1 and "GetCompleteMissions" or "GetInProgressMissions"](1)
			for i=1,t and #t or 0 do
				local v = t[i]
				if not mark[v.missionID] then
					if j == 1 then
						completionMissions[#completionMissions+1], v.readyTime = v, now - 1
					end
					G.ExtendMissionInfoWithXPRewardData(v)
					if not v.readyTime then
						local tls = v.followers and v.followers[1] and C_Garrison.GetFollowerMissionTimeLeftSeconds(v.followers[1])
						v.readyTime = now + (tls or v.timeLeft and G.GetSecondsFromTimeString(v.timeLeft) or v.missionID/1000)
					end
					rt[rn], rn, mark[v.missionID or 0] = v, rn + 1, 1
				end
			end
		end
		table.sort(rt, cmp)
		table.sort(completionMissions, cmp)
		
		return rt
	end
	
	local function completeStep(state, stack, rew, fol, substate, mid)
		if (state == "DONE" or state == "ABORT") and activeUI.completionState == "RUNNING" then
			activeUI.completionState = state == "DONE" and "DONE" or nil
			if next(rew) or next(fol) then
				activeUI:SetCompletionRewards(rew, fol, #stack, not not substate)
			elseif state == "DONE" then
				activeUI.CompleteAll.ShowingHelp = true
				HelpPlate_TooltipHide()
				HelpPlateTooltip.ArrowDOWN:Show()
				HelpPlateTooltip.ArrowGlowDOWN:Show()
				HelpPlateTooltip:SetPoint("TOP", activeUI.CompleteAll, "BOTTOM", 0, -14)
				HelpPlateTooltip.Text:SetText((L"No missions could be completed without exceeding currency caps, violating the %s setting."):format("|cffffd100" .. L"Require Currency Reward" .. "|r") .. "\n\n" .. L"To temporarily ignore wasted currency and complete the skipped missions, right-click this button, or left-click individual missions below.")
				HelpPlateTooltip:Show()
			end
		end
		if (substate == "FAIL" or substate == "COMPLETE") and mid then
			PlaySound(substate == "FAIL" and 43501 or 43502, nil, false)
			activeMissionsHandle:SetAnimation(mid, substate)
		end
		completionFollowers = fol
		RefreshActiveMissionsView()
	end
	function StartCompleteAll()
		wipe(completionMissions)
		GetActiveMissions()
		if #completionMissions > 0 then
			activeUI.completionState = "RUNNING"
			G.CompleteMissions(completionMissions, completeStep)
			return true
		end
	end
	function CompleteMission(mi)
		GarrisonMissionFrame.MissionComplete:Show();
		GarrisonMissionFrame.MissionCompleteBackground:Show();
		GarrisonMissionFrame.MissionComplete.currentIndex = 1
		GarrisonMissionFrame.MissionComplete.completeMissions = {mi}
		GarrisonMissionFrame:MissionCompleteInitialize(GarrisonMissionFrame.MissionComplete.completeMissions, 1)
		GarrisonMissionFrame.MissionComplete.NextMissionButton.returnToActiveList = true
	end
	function ClearCompletionState()
		wipe(completionMissions)
		completionFollowers = nil
	end
	function GetFollowerXPAward(fid)
		local i = completionFollowers and completionFollowers[fid]
		return i and i.xpAward
	end
	EV.MP_RELEASE_CACHES = ClearCompletionState
end
activeUI.CompleteAll:SetScript("OnClick", function(_, button)
	PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
	if button ~= "RightButton" then
		StartCompleteAll()
	else
		GarrisonMissionFrame.MissionComplete.completeMissions = C_Garrison.GetCompleteMissions(1) or {}
		GarrisonMissionFrameMissions.CompleteDialog.BorderFrame.ViewButton:Click()
	end
end)

local core do
	function api.createScrollList(parent, w, h)
		local core, int, h = {}, {view={}}, h or 541
		local sf, sc, bar = CreateFrame("ScrollFrame", nil, parent) do
			sf:SetSize(w, h)
			sf:SetPoint("CENTER")
			bar = CreateFrame("Slider", nil, sf) do
				bar:SetWidth(19)
				bar:SetPoint("TOPRIGHT", 0, -6)
				bar:SetPoint("BOTTOMRIGHT", 0, 8)
				bar:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
				bar:GetThumbTexture():SetSize(18, 24)
				bar:GetThumbTexture():SetTexCoord(0.20, 0.80, 0.125, 0.875)
				bar:SetMinMaxValues(0, 100)
				bar:SetValue(0)
				local bg = bar:CreateTexture(nil, "BACKGROUND")
				bg:SetPoint("TOPLEFT", 0, 16)
				bg:SetPoint("BOTTOMRIGHT", 0, -14)
				bg:SetColorTexture(0,0,0)
				bg:SetAlpha(0.85)
				local top = bar:CreateTexture(nil, "ARTWORK")
				top:SetSize(24, 48)
				top:SetPoint("TOPLEFT", -4, 17)
				top:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-ScrollBar")
				top:SetTexCoord(0, 0.45, 0, 0.20)
				local bot = bar:CreateTexture(nil, "ARTWORK")
				bot:SetSize(24, 64)
				bot:SetPoint("BOTTOMLEFT", -4, -15)
				bot:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-ScrollBar")
				bot:SetTexCoord(0.515625, 0.97, 0.1440625, 0.4140625)
				local mid = bar:CreateTexture(nil, "ARTWORK")
				mid:SetPoint("TOPLEFT", top, "BOTTOMLEFT")
				mid:SetPoint("BOTTOMRIGHT", bot, "TOPRIGHT")
				mid:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-ScrollBar")
				mid:SetTexCoord(0, 0.45, 0.1640625, 1)
				local function Move(self)
					if int.props then
						bar:SetValue(bar:GetValue() - (2-self:GetID()) * int.props.entryHeight)
					end
				end
				local up = CreateFrame("Button", nil, bar, "UIPanelScrollUpButtonTemplate", 1)
				up:SetPoint("BOTTOM", bar, "TOP", 0, -2)
				local down = CreateFrame("Button", nil, bar, "UIPanelScrollDownButtonTemplate", 3)
				down:SetPoint("TOP", bar, "BOTTOM", 0, 2)
				up:SetScript("OnClick", Move)
				down:SetScript("OnClick", Move)
				sf:SetScript("OnMouseWheel", function(_, direction)
					(direction == 1 and up or down):Click()
				end)
				bar:SetScript("OnValueChanged", function(self, v, _isUserInteraction)
					local _, x = self:GetMinMaxValues()
					int:Update(v, true)
					up:SetEnabled(v > 0)
					down:SetEnabled(v < x)
				end)
				sf.Bar, bar.Up, bar.Down = bar, up, down
			end
			sc = CreateFrame("Frame", nil, sf) do
				sc:SetSize(w-2, h+10)
				sf:SetScrollChild(sc)
			end
			sf:SetScript("OnShow", function()
				int:Update(bar:GetValue())
			end)
			missionList.FadeIn = {} do
				local timeLeft
				local function fadeInFinish()
					sc:SetScript("OnUpdate", nil)
					sc:SetScript("OnHide", nil)
					sc:SetAlpha(1)
				end
				local function fadeIn(_, e)
					timeLeft = timeLeft-e
					if timeLeft < 0 then
						fadeInFinish()
					else
						sc:SetAlpha(cos(timeLeft*360))
					end
				end
				function missionList.FadeIn.Play()
					timeLeft = 0.25
					sc:SetScript("OnUpdate", fadeIn)
					sc:SetScript("OnHide", fadeInFinish)
				end
			end
		end
		local function Release(keepMin, keepMax)
			local t, w = int.view, int.props.widgets
			for k,v in pairs(t) do
				if k > keepMax or k < keepMin then
					v:SetParent(nil)
					v:ClearAllPoints()
					v:Hide()
					w[#w + 1], t[k] = v
				end
			end
		end
		function int:Update(ofs)
			if not self.props then return end
			if bar:GetValue() ~= ofs then return bar:SetValue(ofs) end
			local entryHeight, bot, w = self.props.entryHeight, ofs + sf:GetHeight(), self.props.widgets
			local baseIndex = (ofs - ofs % entryHeight) / entryHeight
			local maxIndex = (bot + entryHeight - bot % entryHeight) / entryHeight

			local minIndex, maxIndex, childLevel = max(1, baseIndex), min(#self.data, maxIndex), sc:GetFrameLevel()+1
			Release(minIndex, maxIndex)
			for i=minIndex,maxIndex do
				local f = self.view[i]
				if not f then
					f, w[#w] = w[#w] or securecall(self.props.Spawn)
					self.view[i] = f
				end
				if f then
					f:SetID(i)
					securecall(self.props.Update, f, self.data[i])
					f:SetParent(sc)
					f:SetFrameLevel(childLevel)
					f:SetPoint("TOP", -10, ofs - 2 - (i-1)*entryHeight)
					f:Show()
				end
			end
			local mf = T.GetMouseFocus()
			local oe = mf and T.IsDescendantOf(mf, sc) and mf:GetScript("OnEnter")
			if mf and oe and mf.IsEnabled and mf:IsEnabled() then
				oe(mf)
			end
		end

		function core:SetData(data, propsHandle)
			local reset = int.props ~= propsHandle
			if int.props and reset then
				Release(0, -1)
			end
			int.data, int.props = data, propsHandle
			if data and propsHandle then
				local mv = max(0, 3 + propsHandle.entryHeight * #data - sf:GetHeight())
				bar:SetMinMaxValues(0, mv > 10 and mv or 0)
				bar:GetScript("OnValueChanged")(bar, reset and 0 or bar:GetValue(), false)
			else
				bar:SetMinMaxValues(0, 0)
			end
		end
		function core:GetRowData(handle, row)
			local id = row:GetID()
			if int.props == handle and int.data and int.view[id] == row then
				return int.data[id]
			end
		end
		function core:Refresh(handle)
			if int.props == handle or handle == nil then
				int:Update(bar:GetValue())
			end
		end
		function core:SetShown(isShown)
			sf:SetShown(isShown)
		end
		function core:IsShown()
			return sf:IsShown()
		end
		function core:IsVisible()
			return sf:IsVisible()
		end
		function core:IsOwned(propsHandle)
			return int.props == propsHandle
		end
		function core:CreateHandle(createFunc, setFunc, entryHeight)
			return {Spawn=createFunc, Update=setFunc, entryHeight=entryHeight, widgets={}}
		end
		return core, sf
	end
	core, missionList.List = api.createScrollList(missionList, 882)
end
do -- CreateMissionButton
	local CreateRewards do
		local function Reward_OnEnter(self)
			if self.itemID then
				GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
				G.SetItemTooltip(GameTooltip, self.itemID)
			elseif self.tooltipTitle and self.tooltipText then
				GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
				GameTooltip:AddLine(self.tooltipTitle)
				GameTooltip:AddLine(self.tooltipText, 1,1,1,1)
				if self.tooltipTitle == GARRISON_REWARD_MONEY then
					G.SetCurrencyTraitTip(GameTooltip, 0, self.followerType)
				end
			elseif self.currencyID then
				GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
				GameTooltip:SetCurrencyByID(self.currencyID)
				G.SetCurrencyTraitTip(GameTooltip, self.currencyID, self.followerType)
			elseif self.bonusAbilityID and self.bonusInfo then
				GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
				GameTooltip:SetText(self.bonusInfo.name)
				GameTooltip:AddLine(self.bonusInfo.description, 1,1,1,1)
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(GARRISON_BONUS_EFFECT_TIME_ACTIVE:format(SecondsToTime(self.bonusInfo.duration)))
			else
				return
			end
			if self:GetParent():IsEnabled() then
				self:GetParent():LockHighlight()
			end
			if self.canIgnore then
				local prompt = self.isIgnored and L"Unignore" or "Ignore"
				GameTooltip:AddLine("|n|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:14:12:0:-1:512:512:10:70:330:410|t " .. prompt, 0.5, 0.8, 1)
			end
			GameTooltip:Show()
		end
		local function Reward_OnClick(self, button)
			if self.canIgnore and button == "RightButton" then
				local wasIgnored = self.isIgnored
				MasterPlan:SetRewardIgnore(self.canIgnore, not wasIgnored or nil, IsAltKeyDown())
				if wasIgnored and MasterPlan:IsRewardIgnored(self.canIgnore) then
					MasterPlan:SetRewardIgnore(self.canIgnore, false, IsAltKeyDown())
				end
			elseif IsModifiedClick("CHATLINK") then
				local qt, text, _ = self.quantity:GetText()
				if self.itemID then
					_, text = GetItemInfo(self.itemID)
				elseif self.currencyID and self.currencyID ~= 0 then
					text = Nine.GetCurrencyLink(self.currencyID, qt or 0)
				elseif self.tooltipTitle then
					text = self.tooltipTitle
				end
				qt = qt and not qt:match("|c") and qt or ""
				if text and qt ~= "" and qt ~= "1" then
					text = qt .. " " .. text
				end
				if text then
					ChatEdit_InsertLink(text)
				end
			end
		end
		local function CreateReward(parent, h)
			local r = CreateFrame("Button", nil, parent)
			r:SetSize(h, h)
			r:SetPoint("RIGHT", -12, 0)
			r:RegisterForClicks("LeftButtonUp", "RightButtonUp")
			local t = r:CreateTexture(nil, "BACKGROUND")
			t:SetAtlas("GarrMission_RewardsShadow")
			t:SetPoint("CENTER")
			t:SetSize(h+4, h+4)
			t = r:CreateTexture(nil, "BORDER")
			t:SetPoint("CENTER")
			t:SetSize(h+2, h+2)
			t:Hide()
			t, r.border = r:CreateTexture(nil, "BACKGROUND", nil, 1), t
			t:SetAllPoints()
			t:SetTexture("Interface\\ICONS\\Temp")
			r.icon = t
			t = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightOutline")
			local ins = h > 33 and 3 or 1
			t:SetPoint("BOTTOMRIGHT", 2-ins, ins)
			r.quantity = t
			r:SetScript("OnEnter", Reward_OnEnter)
			r:SetScript("OnLeave", dismissTooltipAndHighlight)
			r:SetScript("OnHide", dismissTooltipAndHighlight)
			r:SetScript("OnClick", Reward_OnClick)
			return r
		end
		local rewardsMT = {__index=function(self, k)
			local l = self[k-1]
			local r = CreateReward(l:GetParent(), self._h)
			r:SetPoint("RIGHT", l, "LEFT", -4, 0)
			self[k] = r
			return self[k]
		end}
		function CreateRewards(parent, h)
			return setmetatable({_h=h, [1]=CreateReward(parent, h)}, rewardsMT)
		end
	end
	local function RaiseVeil(self)
		self:SetFrameLevel(self:GetParent():GetFrameLevel()+5)
	end
	function api.CreateMissionButton(h, w)
		local b, w = CreateFrame("Button"), w or 845
		b:SetSize(w, h)
		
		local t = b:CreateTexture(nil, "BACKGROUND", nil, -1)
		t:SetAtlas("GarrMission_MissionParchment", true)
		t:SetPoint("TOPLEFT", 3, 0) t:SetPoint("BOTTOMRIGHT", -3, 0)
		t:SetVertTile(true) t:SetHorizTile(true)
		t = b:CreateTexture(nil, "BACKGROUND", nil, 1)
		t:SetAtlas("!GarrMission_Bg-Edge", true)
		t:SetVertTile(true)
		t:SetPoint("TOPLEFT", -10, 0)
		t:SetPoint("BOTTOMLEFT", -10, 0)
		t = b:CreateTexture(nil, "BACKGROUND", nil, 1)
		t:SetAtlas("!GarrMission_Bg-Edge", true)
		t:SetVertTile(true)
		t:SetPoint("TOPRIGHT", 10, 0)
		t:SetPoint("BOTTOMRIGHT", 10, 0)
		t:SetTexCoord(1,0, 0,1)
		t = b:CreateTexture(nil, "BACKGROUND", nil, 2)
		t:SetAtlas("_GarrMission_MissionListTopHighlight", true)
		t:SetHorizTile(true)
		t:SetPoint("TOPLEFT", 3, 0)
		t:SetPoint("TOPRIGHT", -3, 0)
		t = b:CreateTexture(nil, "BACKGROUND", nil, 2)
		t:SetAtlas("_GarrMission_Bg-BottomEdgeSmall", true)
		t:SetHorizTile(true)
		t:SetPoint("BOTTOMLEFT", 3, 0)
		t:SetPoint("BOTTOMRIGHT", -3, 0)
		t = b:CreateTexture(nil, "BORDER")
		t:SetAtlas("_GarrMission_TopBorder", true)
		t:SetPoint("TOPLEFT", 20, 4)
		t:SetPoint("TOPRIGHT", -20, 4)
		t = b:CreateTexture(nil, "BORDER")
		t:SetAtlas("_GarrMission_TopBorder", true)
		t:SetPoint("BOTTOMLEFT", 20, -4)
		t:SetPoint("BOTTOMRIGHT", -20, -4)
		t:SetTexCoord(0,1, 1,0)
		t = b:CreateTexture(nil, "BORDER", nil, 1)
		t:SetAtlas("GarrMission_TopBorderCorner", true)
		t:SetPoint("TOPLEFT", -5, 4)
		t = b:CreateTexture(nil, "BORDER", nil, 1)
		t:SetAtlas("GarrMission_TopBorderCorner", true)
		t:SetPoint("TOPRIGHT", 6, 4)
		t:SetTexCoord(1,0, 0,1)
		t = b:CreateTexture(nil, "BORDER", nil, 1)
		t:SetAtlas("GarrMission_TopBorderCorner", true)
		t:SetPoint("BOTTOMLEFT", -5, -4)
		t:SetTexCoord(0,1, 1,0)
		t = b:CreateTexture(nil, "BORDER", nil, 1)
		t:SetAtlas("GarrMission_TopBorderCorner", true)
		t:SetPoint("BOTTOMRIGHT", 6, -4)
		t:SetTexCoord(1,0, 1,0)
		t = b:CreateTexture(nil, "HIGHLIGHT")
		t:SetAtlas("_GarrMission_TopBorder-Highlight", true)
		t:SetHorizTile(true)
		t:SetPoint("TOPLEFT", 21, 4)
		t:SetPoint("TOPRIGHT", -22, 4)
		t = b:CreateTexture(nil, "HIGHLIGHT")
		t:SetAtlas("_GarrMission_TopBorder-Highlight", true)
		t:SetHorizTile(true)
		t:SetPoint("BOTTOMLEFT", 21, -4)
		t:SetPoint("BOTTOMRIGHT", -22, -4)
		t:SetTexCoord(0,1, 1,0)
		t = b:CreateTexture(nil, "HIGHLIGHT", nil, 1)
		t:SetAtlas("GarrMission_TopBorderCorner-Highlight", true)
		t:SetPoint("TOPLEFT", -5, 4)
		t = b:CreateTexture(nil, "HIGHLIGHT", nil, 1)
		t:SetAtlas("GarrMission_TopBorderCorner-Highlight", true)
		t:SetPoint("TOPRIGHT", 4, 4)
		t:SetTexCoord(1,0, 0,1)
		t = b:CreateTexture(nil, "HIGHLIGHT", nil, 1)
		t:SetAtlas("GarrMission_TopBorderCorner-Highlight", true)
		t:SetPoint("BOTTOMLEFT", -5, -4)
		t:SetTexCoord(0,1, 1,0)
		t = b:CreateTexture(nil, "HIGHLIGHT", nil, 1)
		t:SetAtlas("GarrMission_TopBorderCorner-Highlight", true)
		t:SetPoint("BOTTOMRIGHT", 4, -4)
		t:SetTexCoord(1,0, 1,0)
		t = b:CreateTexture(nil, "HIGHLIGHT", nil, 1)
		t:SetAtlas("GarrMission_ListGlow-Highlight")
		t:SetGradient("VERTICAL", 0.5, 0.5, 0.5, 1,1,1)
		t:SetPoint("TOPLEFT") t:SetPoint("TOPRIGHT")
		t:SetHeight(30/44*h) -- SCALE
		t = b:CreateTexture(nil, "BACKGROUND", nil, 5)
		t:SetAtlas("Garr_MissionList-IconBG")
		t:SetPoint("TOPLEFT", 0, -1)
		t:SetPoint("BOTTOMLEFT", 0, 1)
		t:SetWidth(46 + h) -- SCALE
		t, b.iconBG = b:CreateTexture(nil, "ARTWORK"), t
		t:SetPoint("LEFT", 56, 0) t:SetSize(h-16, h-16) -- SCALE
		t, b.mtype = b:CreateFontString(nil, "ARTWORK", "Game30Font"), t
		t:SetPoint("CENTER", b, "LEFT", 33, 0)
		t:SetTextColor(0.84, 0.72, 0.57)
		t, b.level = b:CreateFontString(nil, "ARTWORK", "QuestFont_Super_Huge"), t
		t:SetPoint("LEFT", 52+h, 0) -- SCALE
		t:SetTextColor(1,1,1)
		t:SetShadowColor(0,0,0)
		t:SetShadowOffset(1,-1)
		t, b.title = b:CreateTexture(nil, "ARTWORK", nil, 2), t
		t:SetAtlas("GarrMission_RareOverlay", true)
		t:SetPoint("BOTTOMLEFT", -5, -4)
		t, b.rare = CreateFrame("Frame", nil, b), t
		t:SetScript("OnShow", RaiseVeil)
		t, b.veil = t:CreateTexture(nil, "OVERLAY", nil, -1), t
		t:SetAllPoints(b)
		t:SetColorTexture(1,1,1)
		t:SetGradient("VERTICAL", 0.8, 0.8, 0.8, 0.6, 0.6, 0.6)
		t:SetBlendMode("MOD")
		
		b.veil.tex, b.rewards = t, CreateRewards(b, 32/44*h)
		b.rewards[1]:SetPoint("RIGHT", -14, 1)
		
		return b
	end
end
do -- CreateFollowerPortrait
	local function Follower_OnEnter(self)
		if self.followerID then
			if self:GetParent():IsEnabled() then
				self:GetParent():LockHighlight()
			end
			local info = C_Garrison.GetFollowerInfo(self.followerID)
			FollowerTooltip_SetFollower(self, info, not self.showAbilityDescriptions)
			if self.postEnter then
				self:postEnter(info)
			end
		end
		if GarrisonFollowerTooltip:GetTop() > self:GetBottom() then
			GarrisonFollowerTooltip:ClearAllPoints()
			GarrisonFollowerTooltip:SetPoint("BOTTOM", self, "TOP", 0, 2)
		end
	end
	local function Follower_OnLeave(self)
		GarrisonFollowerTooltip:Hide()
		self:GetParent():UnlockHighlight()
	end
	function api.CreateFollowerPortrait(parent, size, id)
		local x = CreateFrame("Button", nil, parent, nil, id)
		x:SetSize(size, size)
		local v = x:CreateTexture(nil, "ARTWORK", nil, 3)
		v:SetPoint("TOPLEFT", 3, -3) v:SetPoint("BOTTOMRIGHT", -3, 3)
		v, x.portrait = x:CreateTexture(nil, "ARTWORK", nil, 4), v
		v:SetPoint("TOPLEFT", -2, 2) v:SetPoint("BOTTOMRIGHT", 2, -2)
		v:SetAtlas("Garr_FollowerPortrait_Ring")
		v, x.ring = x:CreateTexture(nil, "HIGHLIGHT"), v
		v:SetPoint("TOPLEFT", -4, 2) v:SetPoint("BOTTOMRIGHT", 2, -2)
		v:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
		v:SetBlendMode("ADD")
		v = x:CreateTexture(nil, "ARTWORK", nil, 5)
		v:Hide()
		v:SetTexture("Interface\\Buttons\\IconBorder-GlowRing")
		v:SetPoint("TOPLEFT", 0,1)
		v:SetPoint("BOTTOMRIGHT", -2,2)
		v:SetBlendMode("ADD")
		x.glow = v
		x:SetScript("OnEnter", Follower_OnEnter)
		x:SetScript("OnLeave", Follower_OnLeave)
		x:SetScript("OnHide", Follower_OnLeave)
		return x
	end
end
local GroupButtonBase = {} do
	local function GroupButton_OnMouseUp(self)
		local tex = self.tex
		for i=1,6 do
			tex[i]:SetShown(i < 4)
		end
	end
	local function GroupButton_OnMouseDown(self)
		local tex, isDisabled = self.tex, self:GetButtonState() == "DISABLED"
		for i=1,6 do
			tex[i]:SetShown((i > 3) ~= isDisabled)
		end
	end
	function GroupButtonBase:New(parent, id)
		local b, bh, bw = CreateFrame("Button", nil, parent, nil, id), 24, 12
		b:SetSize(120, bh)
		local t, tt, tn = b:CreateTexture(nil, "BACKGROUND"), {}, 1
		t:SetPoint("LEFT") t:SetSize(bw, bh)
		t:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
		t:SetTexCoord(0.90039063, 0.925781255, 0.04980469, 0.07519531)
		t, tt[tn], tn = b:CreateTexture(nil, "BACKGROUND"), t, tn + 1
		t:SetPoint("RIGHT") t:SetSize(bw, bh)
		t:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
		t:SetTexCoord(0.925781255, 0.95117188, 0.04980469, 0.07519531)
		t, tt[tn], tn = b:CreateTexture(nil, "BACKGROUND"), t, tn + 1
		t:SetPoint("TOPLEFT", bw, 0) t:SetPoint("BOTTOMRIGHT", -bw, 0)
		t:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures_Tile")
		t:SetHorizTile(true)
		t:SetTexCoord(0,1, 0.00195313, 0.05273438)
		t, tt[tn], tn = b:CreateTexture(nil, "BACKGROUND"), t, tn + 1
		t:SetPoint("LEFT") t:SetSize(bw, bh)
		t:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
		t:SetTexCoord(0.63476563, 0.660156255, 0.06738281, 0.09277344)
		t, tt[tn], tn = b:CreateTexture(nil, "BACKGROUND"), t, tn + 1
		t:SetPoint("RIGHT") t:SetSize(bw, bh)
		t:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
		t:SetTexCoord(0.660156255, 0.68554688, 0.06738281, 0.09277344)
		t, tt[tn], tn = b:CreateTexture(nil, "BACKGROUND"), t, tn + 1
		t:SetPoint("TOPLEFT", bw, 0) t:SetPoint("BOTTOMRIGHT", -bw, 0)
		t:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures_Tile")
		t:SetHorizTile(true)
		t:SetTexCoord(0,1, 0.05664063, 0.10742188)
		t, tt[tn], tn = b:CreateTexture(nil, "HIGHLIGHT"), t, tn + 1
		t:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
		t:SetTexCoord(0.72656250, 0.751953125, 0.06738281, 0.09277344)
		t:SetSize(bw, bh) t:SetPoint("LEFT")
		t = b:CreateTexture(nil, "HIGHLIGHT")
		t:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures")
		t:SetTexCoord(0.751953125, 0.77734375, 0.06738281, 0.09277344)
		t:SetSize(bw, bh) t:SetPoint("RIGHT")
		t = b:CreateTexture(nil, "HIGHLIGHT")
		t:SetTexture("Interface\\EncounterJournal\\UI-EncounterJournalTextures_Tile")
		t:SetTexCoord(0,1, 0.11132813,0.16210938) t:SetHorizTile(true)
		t:SetPoint("TOPLEFT", bw, 0) t:SetPoint("BOTTOMRIGHT", -bw, 0)
		b.tex = tt
		GroupButton_OnMouseUp(b, true)
		b:SetPushedTextOffset(0, -1)
		b:SetNormalFontObject(GameFontHighlightSmall)
		b:SetText("!")
		b:GetFontString():SetTextColor(0.973, 0.902, 0.581)
		
		b:SetMotionScriptsWhileDisabled(true)
		b:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		b:SetScript("OnMouseDown", GroupButton_OnMouseDown)
		b:SetScript("OnMouseUp", GroupButton_OnMouseUp)
		
		return b
	end
	function GroupButtonBase:ShowTooltip(mi, canSetTentative, invert, g, ug)
		if g or ug then
			GameTooltip:SetOwner(self, "ANCHOR_PRESERVE")
			GameTooltip:ClearAllPoints()
			if invert then
				GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", -6, 0)
			else
				GameTooltip:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -6, 0)
			end
			if g then
				G.SetGroupTooltip(GameTooltip, g, mi)
				if canSetTentative then
					GameTooltip:AddLine("|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:14:12:0:-1:512:512:10:70:330:410|t " .. L"Set tentative party", 0.5, 0.8, 1)
				end
			else
				G.SetUpGroupTooltip(GameTooltip, ug, mi)
			end
			GameTooltip:Show()
		end
	end
	function GroupButtonBase:SetGroup(mi, g, minGroupButtonWidth, widthStep, rt, p1)
		local sc, sp, text = "|cffffffff" .. g[1] .. "%", g[1]/100
		local edt, ec, et, isxp, _, exp, tf = G.GetMissionGroupDeparture(g, mi), g[3]*sp, g[9]
		if ec > 0 and et == 824 then
			text = ("%d |TInterface\\Garrison\\GarrisonCurrencyIcons:0:0:0:0:128:128:12:52:12:52|t"):format(ec)
		elseif ec > 0 and et == 1101 then
			text = ("%d|TInterface\\Garrison\\GarrisonCurrencyIcons:0:0:0:2:128:128:70:104:68:104|t"):format(ec)
		elseif ec > 0 and et == 823 then
			text = ec .. " |T" .. select(3,Nine.GetCurrencyInfo(et)) .. ":0:0:0:1:64:64:4:60:4:60|t"
		elseif ec >= 1e4 and et == 0 and G.HasSignificantRewards(mi) == "gold" then
			text = GetMoneyString(ec - ec % 1e4)
		else
			if p1 and (g[11] and g[11] > 0) then
				tf, exp = "|cffd0ff73%s|r", g[11]
			else
				_, exp = G.GetMissionGroupXP(g, mi)
			end
			if (exp or 0) <= 0 then
			elseif T.config.availableMissionSort == "xptime" then
				text, isxp = (L"%s XP/h"):format(abridge(floor(exp*3600/g[4]))), true
			else
				text, isxp = (L"%s XP"):format(abridge(floor(exp))), true
			end
			text = tf and tf:format(text) or text
		end
		if edt then
			if text and not isxp then
				text = text .. ", " .. sc
			elseif rt == "threats" or not text then
				text = sc
			end
			text = "|cffb0b0b0" .. FormatCountdown(edt-time()) .. ": " .. text
		else
			text = (text and text .. ", " or "") .. sc
		end
		self:SetEnabled(not edt)
		self:SetText(text)
		local bw = self:GetFontString():GetStringWidth()+14
		bw = math.max(minGroupButtonWidth, bw)
		self:SetWidth(bw + (widthStep - bw % widthStep) % widthStep)
		self:Show()
	end
end
do -- activeMissionsHandle
	local anim = {}
	
	local function ActiveFollower_OnEnter(self, info)
		if info then
			local award = GetFollowerXPAward(info.followerID)
			if award then
				G.ExtendFollowerTooltipGainedXP(GarrisonFollowerTooltip, award, info)
			else
				local row = core:GetRowData(activeMissionsHandle, self:GetParent())
				G.ExtendFollowerTooltipProjectedRewardXP(row, info)
			end
		end
	end
	local function ActiveMission_OnClick(self)
		local mi = core:GetRowData(activeMissionsHandle, self)
		if IsModifiedClick("CHATLINK") then
			local missionLink = C_Garrison.GetMissionLink(mi.missionID)
			if (missionLink) then
				ChatEdit_InsertLink(missionLink)
			end
		elseif mi.readyTime and mi.readyTime < time() and not (mi.succeeded or mi.failed) and activeUI.completionState ~= "RUNNING" then
			CompleteMission(mi)
		elseif SpellCanTargetGarrisonMission() then
			C_Garrison.CastSpellOnMission(mi.missionID)
		end
	end
	local function Banner_OnPlay(self)
		local par = self:GetParent()
		local fail = self == par.Fail
		par.banner:SetVertexColor(fail and 1 or 0.2, fail and 0.2 or 1, 0.2)
		par.banner:Show()
	end
	local function Banner_OnStop(self)
		local par = self:GetParent()
		par.banner:Hide()
	end
	local function RefreshTimeOnShow(self)
		local ou = self:GetScript("OnUpdate")
		if ou then
			ou(self, math.huge)
		end
	end
	local function CreateActiveMission()
		local b = api.CreateMissionButton(44)
		b:SetScript("OnClick", ActiveMission_OnClick)
		b:SetScript("OnShow", RefreshTimeOnShow)
		
		local t = b:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		t:SetPoint("RIGHT", -160, 0)
		t:SetTextColor(0.84, 0.72, 0.57)
		b.status = t
		t = b:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		t:SetPoint("CENTER", b, "RIGHT", -120, 0)
		t:SetTextColor(0.84, 0.72, 0.57)
		b.chance = t
		t = b:CreateTexture(nil, "OVERLAY")
		t:SetAtlas("GarrMission_LevelUpBanner")
		t:SetPoint("CENTER", 0, -1) t:SetSize(832*1.3, 44*2.85)
		t:SetBlendMode("ADD")
		t:SetAlpha(0)
		b.banner = t
		
		for i=1,2 do
			local g = b:CreateAnimationGroup()
			g:SetToFinalAlpha(true)
			g:SetScript("OnPlay", Banner_OnPlay)
			g:SetScript("OnStop", Banner_OnStop)
			t = g:CreateAnimation("Alpha")
			t:SetChildKey("banner")
			t:SetFromAlpha(0) t:SetToAlpha(1)
			t:SetDuration(0.2)
			t = g:CreateAnimation("Scale")
			t:SetChildKey("banner")
			t:SetFromScale(0.3, 1) t:SetToScale(1, 1)
			t:SetDuration(0.4)
			t = g:CreateAnimation("Alpha")
			t:SetChildKey("banner")
			t:SetStartDelay(0.4) t:SetDuration(0.5)
			t:SetFromAlpha(1) t:SetToAlpha(0)
			b[i == 1 and "Fail" or "Success"] = g
		end
		
		b.followers = {}
		for i=1,3 do
			t = api.CreateFollowerPortrait(b, 32, i)
			t:SetPoint("RIGHT", -265-34*i, 1)
			t.postEnter, b.followers[i] = ActiveFollower_OnEnter, t
		end
	
		return b
	end
	local function TimerUpdate(self, elapsed)
		local te = self.throttle or 0
		if te > elapsed then
			self.throttle = te - elapsed
			return
		end
		local mi = core:GetRowData(activeMissionsHandle, self)
		if mi and mi.readyTime and mi.state ~= 0 then
			local sec = mi.readyTime - time()
			if sec > 0 then
				self.status:SetText(G.GetTimeStringFromSeconds(sec))
			end
			if sec < -1 then
				self:SetScript("OnUpdate", nil)
				RefreshActiveMissionsView(false)
			else
				self.throttle = sec > 60 and ((sec % 60 - 1) % 60 + 2) or 1
			end
		end
	end
	local function SetActiveMission(self, d)
		local mid = d.missionID
		self.level:SetText((d.isRare and "|cff4DB5FF" or "") .. (d.level == T.FOLLOWER_LEVEL_CAP and d.iLevel > 600 and d.iLevel or d.level))
		self.rare:SetShown(d.isRare or false)
		self.iconBG:SetVertexColor(0, d.isRare and 0.012 or 0, d.isRare and 0.291 or 0, 0.4)
		self.mtype:SetAtlas(d.typeAtlas)
		self.title:SetText(d.name)
		local tl, col, state = d.readyTime-time(), ""
		self:SetScript("OnUpdate", nil)
		if tl > 0 then
			self:SetScript("OnUpdate", TimerUpdate)
			TimerUpdate(self, math.huge)
			state = G.GetTimeStringFromSeconds(tl)
		elseif d.failed then
			col, state = "|cffff2020", L"Failed"
		elseif d.skipped then
			col, state = "|cffb0ff20", L"Skipped"
		elseif d.succeeded or d.completed or (d.state and d.state >= 0) then
			col, state = "|cff20ff20", L"Success"
		else
			col, state = "|cffffea10", L"Ready"
		end
		self.status:SetText(col .. state)
		self.chance:SetText(d.successChance and (d.successChance .. "%") or "")
		
		local sanim = anim[mid]
		if sanim or (self.Fail.id ~= mid and (self.Fail:IsPlaying() or self.Success:IsPlaying())) then
			self.Fail.id = mid
			self.Fail:Stop()
			self.Success:Stop()
			if sanim then
				self[sanim == "COMPLETE" and "Success" or "Fail"]:Play()
			end
		end
		
		local nr, nf, r = 1, 1
		if type(d.followers) == "table" then
			local fin, fi, w = G.GetFollowerInfo()
			for i=1,#d.followers do
				fi, w = fin[d.followers[i]], self.followers[nf]
				if fi and w then
					w.followerID, nf = fi.followerID, nf + 1
					w.portrait:SetTexture(fi.portraitIconID)
					local ct = (fi.level < 100 or fi.quality < 4) and ITEM_QUALITY_COLORS[fi.quality]
					if ct then
						w.glow:SetVertexColor(ct.r, ct.g, ct.b)
						w.glow:Show()
					else
						w.glow:Hide()
					end
					w:Show()
				end
			end
		end
		if type(d.rewards) == "table" then
			for k,v in pairs(d.rewards) do
				local icon, quant = v.icon, v.quantity ~= 1 and v.quantity
				r, nr = self.rewards[nr], nr + 1
				r.itemID, r.tooltipTitle, r.tooltipText, r.currencyID = v.itemID, v.title, v.tooltip, v.currencyID
				if v.followerXP then
					quant = abridge(v.followerXP)
				elseif v.currencyID then
					quant = v.quantity * G.GetRewardMultiplier(d, v.currencyID)
					if v.currencyID == 0 then
						quant, r.tooltipText = abridge(quant/10000), GetMoneyString(quant)
					else
						quant = abridge(quant)
					end
				elseif v.itemID then
					local _, _, q, l, _, _, _, _, _, tex = GetItemInfo(v.itemID)
					l, icon = T.CrateLevels[v.itemID] or l, tex or GetItemIcon(v.itemID)
					if v.quantity == 1 and q and l and l > 500 then
						quant = ITEM_QUALITY_COLORS[q].hex .. l
					end
				end
				r.quantity:SetText(quant or "")
				r.icon:SetTexture(icon or "Interface/Icons/Temp")
				r:Show()
			end
		end

		for i=nr, #self.rewards do
			self.rewards[i]:Hide()
		end
		for i=nf, #self.followers do
			self.followers[i]:Hide()
		end
		self.veil:SetShown(tl > 0)
	end
	activeMissionsHandle = core:CreateHandle(CreateActiveMission, SetActiveMission, 48)
	function activeMissionsHandle:Activate(force)
		if force then
			ClearCompletionState()
		end
		local am, hasComplete = GetActiveMissions(), false
		for i=1,#am do
			local m = am[i]
			if m.readyTime <= time() and not (m.succeeded or m.failed) then
				hasComplete = true
				break
			end
		end
		core:SetData(am, activeMissionsHandle)
		wipe(anim)
		activeUI.CompleteAll:SetShown(not activeUI.lootFrame:IsShown() and (hasComplete and activeUI.completionState ~= "RUNNING"))
		if force then
			if #am == 0 then
				SetMissionsFrameTab(1)
			end
		end
	end
	function activeMissionsHandle:SetAnimation(mid, state)
		anim[mid] = state
	end
end
do -- availMissionsHandle
	local used = {}
	local CreateThreat, SetThreat = {} do
		local GetThreatColor do
			local threatColors={[0]={1,0,0}, {0.15, 0.45, 1}, {0.20, 0.45, 1}, {1, 0.55, 0}, {0,1,0}}
			function GetThreatColor(counters, missionLevel, finfo, threatID, used)
				if not missionLevel then return 1,1,1 end
				local finfo, quality, bk = finfo or G.GetFollowerInfo(), 0
				for i=1,counters and #counters or 0 do
					local fi = finfo[counters[i]]
					local ld, mt = G.GetLevelEfficiency(G.GetFMLevel(fi), missionLevel), fi.missionEndTime and 0 or 2
					local uk = fi.isCombat and (threatID .. "#" .. i)
					if not fi.isCombat or (used and used[uk]) or T.config.ignore[fi.followerID] then
					elseif ld == 1 and quality < (2+mt) then
						quality, bk = 2+mt, uk
						if mt == 2 then break end
					elseif ld == 0.5 and quality < (1+mt) then
						quality, bk = 1+mt, uk
					end
				end
				if bk then used[bk] = 1 end
				return unpack(threatColors[quality])
			end
		end
		local function Threat_OnEnter(self)
			self:GetParent():LockHighlight()
			GameTooltip:SetOwner(self, "ANCHOR_TOP")
			G.SetThreatTooltip(GameTooltip, self.id, nil, self.missionLevel)
			GameTooltip:Show()
		end
		function CreateThreat(parent)
			local b = CreateFrame("Button", nil, parent, "GarrisonAbilityCounterTemplate")
			b:SetScript("OnEnter", Threat_OnEnter)
			b:SetScript("OnLeave", dismissTooltipAndHighlight)
			return b
		end
		function SetThreat(self, icon, threatID, level, counters, followers, used)
			self.id, self.missionLevel = threatID, level
			self.Icon:SetTexture(icon)
			self.Border:SetVertexColor(GetThreatColor(counters, level, followers, threatID, used))
			self:Show()
		end
	end
	local CreateGroupButton do
		local function GroupButton_OnEnter(self)
			self:GetParent():LockHighlight()
			local mi = core:GetRowData(availMissionsHandle, self:GetParent())
			local g = mi.groups and mi.groups[self:GetID()]
			GroupButtonBase.ShowTooltip(self, mi, self:IsEnabled(), false, g, mi.upgroup)
		end
		local function GroupButton_OnClick(self, button)
			local mi = core:GetRowData(availMissionsHandle, self:GetParent())
			local g = mi.groups and mi.groups[self:GetID()]
			if not g then
				local ug, ss = mi.upgroup
				for i=1,mi.numFollowers do
					ss = (ss and ss .. "/" or "") .. C_Garrison.GetFollowerName(ug[i])
				end
				local sb = GarrisonMissionFrameFollowers.SearchBox
				sb:SetText(ss)
				sb.clearText = ss
				local ifid = G.GetUnderLevelledFollower(ug, mi) or ug[1]
				GarrisonMissionFrameTab2:Click()
				GarrisonMissionFrame.selectedFollower = ifid
				GarrisonMissionFrame.FollowerTab.followerList:ShowFollower(ifid)
				EV("MP_FORCE_FOLLOWER_TAB", ifid)
			elseif button == "RightButton" then
				G.SaveMissionParty(mi.missionID, g[5], g[6], g[7])
				api.roamingParty:DropFollowers(g[5], g[6], g[7])
			else
				OpenToMission(mi, g[5], g[6], g[7])
			end
		end
		function CreateGroupButton(...)
			local b = GroupButtonBase:New(...)
			b:SetScript("OnEnter", GroupButton_OnEnter)
			b:SetScript("OnLeave", dismissTooltipAndHighlight)
			b:SetScript("OnClick", GroupButton_OnClick)
			return b
		end
	end
	local function AvailMission_OnClick(self)
		local mi = core:GetRowData(availMissionsHandle, self)
		if IsModifiedClick("CHATLINK") then
			local missionLink = C_Garrison.GetMissionLink(mi.missionID)
			if (missionLink) then
				ChatEdit_InsertLink(missionLink)
			end
		elseif mi.missionID then
			OpenToMission(mi)
		end
	end
	local function CreateAvailMission()
		local b = api.CreateMissionButton(64)
		b.title:ClearAllPoints()
		b.title:SetPoint("TOPLEFT", 68+48, -9)
		b.level:ClearAllPoints()
		b.level:SetPoint("CENTER", b, "LEFT", 31, 4)
		b:SetScript("OnClick", AvailMission_OnClick)
		local t = b:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge2")
		t:SetPoint("BOTTOMLEFT", b.title, "BOTTOMRIGHT", 6, 0)
		t:SetTextColor(0.8, 0.8, 0.8)
		t, b.stats = b:CreateTexture(nil, "BACKGROUND", nil, 3), t
		t:SetSize(780, 62)
		t:SetPoint("RIGHT")
		t, b.loc = b:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall"), t
		t:SetTextColor(0.84, 0.72, 0.57)
		t:SetPoint("TOP", b, "TOPLEFT", 78, -5)
		t, b.expire = b:CreateFontString(nil, "ARTWORK", "GameFontNormal"), t
		t:SetPoint("TOP", b.level, "BOTTOM", 0, -1)
		t, b.followers = {}, t
		
		for i=1,7 do
			t[i] = CreateThreat(b)
		end
		t[1]:SetPoint("TOPRIGHT", b, "RIGHT", -128, 23)
		t[3]:SetPoint("BOTTOMRIGHT", b, "RIGHT", -143, -21)
		t[2]:SetPoint("RIGHT", t[1], "LEFT", -9, 0)
		t[4]:SetPoint("RIGHT", t[3], "LEFT", -9, 0)
		t[5]:SetPoint("RIGHT", t[2], "LEFT", -9, 0)
		t[6]:SetPoint("RIGHT", t[4], "LEFT", -9, 0)
		t[7]:SetPoint("RIGHT", t[5], "LEFT", -9, 0)
		t, b.threats = {}, t
		
		for i=1,4 do
			t[i] = CreateGroupButton(b, i)
			t[i]:SetPoint("LEFT", t[i-1], "RIGHT", 4, 0)
		end
		t[1]:ClearAllPoints()
		t[1]:SetPoint("BOTTOMLEFT", 112, 5)
		b.groups = t

		return b
	end
	local function SetAvailableMission(self, d)
		self.level:SetText((d.isRare and "|cff4DB5FF" or "") .. (d.level == T.FOLLOWER_LEVEL_CAP and d.iLevel > 600 and d.iLevel or d.level))
		self.rare:SetShown(d.isRare or false)
		self.iconBG:SetVertexColor(0, d.isRare and 0.012 or 0, d.isRare and 0.291 or 0, 0.4)
		self.mtype:SetAtlas(d.typeAtlas)
		self.title:SetText(d.name)
		local summary = d.duration
		if d.durationSeconds >= GARRISON_LONG_MISSION_TIME then
			summary = format(GARRISON_LONG_MISSION_TIME_FORMAT, summary)
		end
		self.stats:SetFormattedText(PARENS_TEMPLATE, summary)
		local _, _, expTimeShort = G.GetMissionSeen(d.missionID, d)
		self.expire:SetText(expTimeShort or "")

		if d.locTextureKit then
			self.loc:SetAtlas(d.locTextureKit.."-List")
		end
		self.loc:SetShown(not not d.locTextureKit)
		local fol = "" do
			local nf = G.HasTentativeParty(d.missionID)
			for i=1, d.numFollowers do
				fol = fol .. "|TInterface\\FriendsFrame\\UI-Toast-FriendOnlineIcon:11:11:3:0:32:32:8:24:8:24:" ..
				      (nf < i and "214:170:115|t" or "255:180:0|t")
			end
		end
		self.followers:SetText(fol)

		local nr, isIgnored = 1, d.ord0 == -1
		if type(d.rewards) == "table" then
			for k,v in pairs(d.rewards) do
				local icon, quant, r = v.icon, v.quantity ~= 1 and v.quantity
				r, nr = self.rewards[nr], nr + 1
				r.itemID, r.tooltipTitle, r.tooltipText, r.currencyID, r.isIgnored, r.canIgnore = v.itemID, v.title, v.tooltip, v.currencyID, isIgnored
				r.border:Hide()
				if v.followerXP then
					quant, r.canIgnore = v.followerXP, d.level == T.FOLLOWER_LEVEL_CAP and "f:xp10" or d.level < (T.FOLLOWER_LEVEL_BASE+5) and "f:xp90" or "f:xp95"
				elseif v.currencyID == 0 then
					quant = floor(v.quantity/10000)
					r.tooltipText, r.canIgnore = GetMoneyString(v.quantity), "c:0"
				elseif v.currencyID then
					r.canIgnore = "c:" .. v.currencyID
				elseif v.itemID then
					local _, _, q, l, _, _, _, _, _, tex = GetItemInfo(v.itemID)
					r.canIgnore, icon, l = "i:" .. v.itemID, tex or GetItemIcon(v.itemID), T.CrateLevels[v.itemID] or l
					if v.quantity == 1 and q and l and l > 40 then
						quant = ITEM_QUALITY_COLORS[q].hex .. l
						if G.IsLevelAppropriateToken(v.itemID) then
							local ac = q == 3 and "blue" or q == 4 and "purple" or "green"
							r.border:SetAtlas("loottoast-itemborder-" .. ac)
							r.border:Show()
						end
					end
				end
				if r.canIgnore and not isIgnored and MasterPlan:IsRewardIgnored(r.canIgnore) then
					r.isIgnored = true
				end
				r.quantity:SetText(quant or "")
				r.icon:SetTexture(icon or "Interface/Icons/Temp")
				r.icon:SetDesaturated(r.isIgnored)
				if r.isIgnored then
					r.icon:SetVertexColor(0.8,0.4,0.4)
				elseif isIgnored then
					r.icon:SetVertexColor(0.8,0.6,0.6)
				else
					r.icon:SetVertexColor(1,1,1)
				end
				r:Show()
			end
		end
		for i=nr, #self.rewards do
			self.rewards[i]:Hide()
		end
		
		local cinfo, finfo, mlvl = G.GetCounterInfo(), G.GetFollowerInfo(), G.GetFMLevel(d)
		local enemies, ename, edesc, etex, _ = d.enemies, d.envName, d.envDescription, d.envTexture
		if not (enemies and ename and edesc and etex) then
			_, _, ename, edesc, etex, _, _, enemies = C_Garrison.GetMissionInfo(d.missionID)
			d.enemies, d.envName, d.envDescription, d.envTexture = enemies, ename, edesc, etex
		end
		local nt, tt, used = 1, self.threats, wipe(used) or used
		for i=1,#enemies do
			local mech = enemies[i].mechanics
			for i=1,#mech do
				local minfo = mech[i]
				local id = minfo.mechanicTypeID
				nt = nt + 1, SetThreat(tt[nt], minfo.icon, id, mlvl, cinfo[id], finfo, used)
			end
		end
		for i=nt,#tt do
			tt[i]:Hide()
		end

		local sg, p1, p2, p3 = d.groups, api.roamingParty:GetFollowers()
		p1 = not (p2 and p3) and p1
		local minGroupButtonWidth = GetLocale():match("zh") and 125 or 110
		for i=1,#sg do
			GroupButtonBase.SetGroup(self.groups[i], d, sg[i], minGroupButtonWidth, 10, sg.rankType, p1)
		end
		for i=#sg + (d.upgroup and 2 or 1), #self.groups do
			self.groups[i]:Hide()
		end
		if d.upgroup and self.groups[#sg+1] then
			local b = self.groups[#sg+1]
			b:SetText("|TInterface\\Buttons\\UI-MicroStream-Green:0:0:0:0:32:32:6:24:24:6|t")
			b:Enable()
			b:SetWidth(25)
			b:Show()
		end
		
		self.veil:SetShown(d.ord0 == -3)
	end
	local GetAvailableMissions do
		local roamingParty = api.roamingParty
		local function cmp(a,b)
			local ac, bc = a.ord0, b.ord0
			if ac == bc then
				ac, bc = a.ord, b.ord
			end
			if ac == bc then
				ac, bc = a.ord1, b.ord1
			end
			if ac == bc then
				ac, bc = a.level, b.level
			end
			if ac == bc then
				ac, bc = a.iLevel, b.iLevel
			end
			if ac == bc then
				ac, bc = 0, strcmputf8i(a.name, b.name)
			end
			return ac > bc
		end
		local fields, eg, cw = {threats=1}, {0, [3]=0,[4]=0, [9]=0, [11]=0}, {}
		local function sortMissions(missions, nf, nr)
			local order, horizon = T.config.availableMissionSort, T.config.timeHorizon
			local field = fields[order] or 1
			local naf = C_Garrison.GetNumActiveFollowers(1)
			local groupCache = naf <= 25 and G.GetSuggestedGroupsForAllMissions(1, order, roamingParty:GetFollowers()) or {}
			local checkReq = (nf < 3 or nr < 100) and T.config.availableMissionSort ~= "expire"
			local p1, p2, p3 = api.roamingParty:GetFollowers()
			p1 = not (p2 and p3) and p1
			if p1 then
				local f1 = G.GetFollowerInfo()[p1]
				if not (f1 and (f1.level < T.FOLLOWER_LEVEL_CAP or f1.quality < 4)) then
					p1 = nil
				end
			end
			
			local _, resq = Nine.GetCurrencyInfo(824)
			cw[824] = resq < 3e3 and 10 or (resq < 7e3 and 6 or 3)
			local _, oilq = Nine.GetCurrencyInfo(1101)
			cw[1101] = C_Garrison.HasShipyard() and (oilq < 1e3 and 11 or 2) or 1
			cw[823], cw[0], cw.minor = 4, 5, 1.5
			
			for i=1, #missions do
				local mi, g = missions[i]
				local mid, sr = mi.missionID, G.HasSignificantRewards(mi)
				local sg = groupCache[mid] or {}
				mi.groups, g = sg, sg[1] and not G.GetMissionGroupDeparture(sg[1], mi) and sg[1] or eg
				mi.ord1 = (cw[g[9]] or cw[sr] or (sr and 8) or 0) * 1e16 + g[1]*g[3]*1e3 + (sr and g[1] or 0)
				
				if order == "duration" then
					mi.ord = -mi.durationSeconds
				elseif order == "expire" then
					local max = mi.offerEndTime or G.GetMissionSeen(mid, mi)
					mi.ord = (max or -1) >= 0 and -floor(max/1800) or -math.huge
				elseif order == "level" then
					local i, l = mi.iLevel, mi.level
					mi.ord = l == T.FOLLOWER_LEVEL_CAP and i > 600 and i or l
				elseif order == "reward" then
					mi.ord, mi.ord1 = mi.ord1, (g[11] or 0)*1e8 + ((g[5] and G.GetMissionGroupXP(g, mi) or 0)) * 100 + (g and g[1] or 0)
				elseif g[5] and (order == "xp" or order == "xptime") then
					local xp = p1 and (g[11] or 0) or G.GetMissionGroupXP(g, mi) or 0
					mi.ord = order == "xptime" and xp/max(g[4], horizon) or xp
				else
					mi.ord = g[5] and g[field] or -math.huge
				end
				local tc = G.HasTentativeParty(mid)
				if tc == mi.numFollowers then
					mi.ord0 = -2
				elseif checkReq and mi.numFollowers > (nf + tc) or (mi.cost > nr) then
					mi.ord0 = -3
				elseif MasterPlan:IsMissionIgnored(mi) then
					mi.ord0 = -1
				else
					mi.ord0 = 0
				end
			end
			table.sort(missions, cmp)
		end
		function GetAvailableMissions()
			local missions, droppedMissionCost = G.GetAvailableMissions(1)
			securecall(sortMissions, missions, GetAvailableResources(1, droppedMissionCost, missions))
			local job = securecall(G.GetSuggestedMissionUpgradeGroups, missions, availUI.loader.job, roamingParty:GetFollowers())
			availUI.loader.job, availUI.loader.skipFrame = job, true
			if job then
				availUI.loader:Show()
			end
			GarrisonMissionFrame.MissionTab.MissionList.EmptyListString:SetText(#missions > 0 and "" or GARRISON_EMPTY_MISSION_LIST)
			return missions
		end
	end
	local timeToNextRefresh = 0
	availUI:SetScript("OnUpdate", function(_, elapsed)
		if timeToNextRefresh < elapsed then
			availMissionsHandle:Refresh(false)
		else
			timeToNextRefresh = timeToNextRefresh - elapsed
		end
	end)
	function availUI.loader.OnFinish()
		availMissionsHandle:Refresh(false)
	end
	availMissionsHandle = core:CreateHandle(CreateAvailMission, SetAvailableMission, 67)
	function availMissionsHandle:Activate(full)
		timeToNextRefresh = 60
		if full then
			core:SetData(GetAvailableMissions(), availMissionsHandle)
		else
			core:Refresh(availMissionsHandle)
		end
	end
	function availMissionsHandle:Refresh(reload)
		if core:IsOwned(self) and core:IsShown() then
			if availUI:IsVisible() then
				availMissionsHandle:Activate(reload)
			else
				core:SetData()
			end
		end
	end
	do -- RefreshAvailMissionsView
		local isFullRefresh, ph, isDirty = true, {}
		local function DoRefresh()
			local reload = isFullRefresh
			isDirty, isFullRefresh = nil
			availMissionsHandle:Refresh(reload)
		end
		function RefreshAvailMissionsView(force)
			if core:IsShown() and (force or core:IsOwned(availMissionsHandle)) then
				if not isDirty then
					isDirty, isFullRefresh = true, isFullRefresh or force or not core:IsOwned(availMissionsHandle)
					if not core:IsOwned(availMissionsHandle) then
						core:SetData(ph, availMissionsHandle)
					end
					T.After0(DoRefresh)
				end
			end
		end
		function EV:GARRISON_MISSION_LIST_UPDATE()
			if availUI:IsVisible() then
				RefreshAvailMissionsView(true)
			end
		end
	end
	function EV:MP_SETTINGS_CHANGED(s)
		if s == "availableMissionSort" or s == "timeHorizon" or s == "missionIgnore" then
			availMissionsHandle:Refresh(true)
		end
	end
	function EV:MP_TENTATIVE_PARTY_UPDATE()
		if availUI:IsVisible() then
			RefreshAvailMissionsView(true)
		end
	end
end
do -- interestMissionsHandle
	local usefulTraits, mappedRewards = setmetatable({}, T.AlwaysTraits), Interest_RewardMap
	local function Threat_OnEnter(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		G.SetThreatTooltip(GameTooltip, self.id, nil, self.missionLevel)
		GameTooltip:Show()
	end
	local function CreateThreat(parent)
		local b = CreateFrame("Frame", nil, parent)
		b:SetSize(21, 21)
		local t = b:CreateTexture(nil, "ARTWORK")
		t:SetAllPoints()
		t, b.Icon = b:CreateTexture(nil, "ARTWORK", nil, 1), t
		t:SetAtlas("GarrMission_EncounterAbilityBorder-Lg")
		t:SetSize(34.5, 34.5)
		t:SetPoint("CENTER")
		b.Border, b.info = t, {}
		b:SetScript("OnEnter", Threat_OnEnter)
		b:SetScript("OnLeave", dismissTooltip)
		return b
	end
	local function SetThreat(self, level, tid, _, icon)
		self.id, self.missionLevel = tid, level
		self.Icon:SetTexture(icon)
	end
	local function InterestFollower_OnClick(self)
		if self.followerID then
			local fid = self.followerID
			GarrisonMissionFrame.selectedFollower = fid
			GarrisonMissionFrame.FollowerTab.followerList:ShowFollower(fid)
			GarrisonMissionFrameTab2:Click()
			EV("MP_FORCE_FOLLOWER_TAB", fid)
			local fl, idx, btn = GarrisonMissionFrameFollowers.followers do
				for i=1,#fl do
					if fl[i].followerID == fid then
						idx = i
						break
					end
				end
				if idx then
					local fl = GarrisonMissionFrameFollowers.followersList
					for j=1,2 do
						for i=1,#fl do
							if fl[i] == idx then
								btn = i
								break
							end
						end
						if btn then
							break
						else
							GarrisonMissionFrameFollowers.SearchBox:SetText("")
						end
					end
				end
			end
			if btn then
				local v = 62*btn - 62
				GarrisonMissionFrameFollowersListScrollFrameScrollBar:SetValue(v)
				HybridScrollFrame_SetOffset(GarrisonMissionFrameFollowersListScrollFrame, v)
			end
		end
	end
	local function InterestFollower_OnEnter(self, info)
		local data = core:GetRowData(interestMissionsHandle, self:GetParent())
		if info and data and data.best then
			local me, s, best, fi = info.followerID, data.s, data.best, G.GetFollowerInfo()
			for i=1,#GarrisonFollowerTooltip.Abilities do
				local b = GarrisonFollowerTooltip.Abilities[i]
				local tid, prefix = b:IsShown() and G.GetMechanicInfo(tostring(b.CounterIcon:GetTexture())), false
				if tid then
					for j=#s,6,-1 do
						if s[j] == tid then
							prefix = data.best[j+1] == 2 and "|cfff0ff10" or "|cff10ff10"
							break
						end
					end
					b.Details:SetText((prefix or "|cffa0a0a0")  .. b.Details:GetText())
				end
			end
			wipe(usefulTraits)
			usefulTraits[T.EnvironmentCounters[s[5]] or 0] = 1
			for k,v in pairs(T.EnvironmentBonus) do
				if v[s[5]] then
					usefulTraits[k] = 1
				end
			end
			local ts = T.TraitStack[s[4]]
			usefulTraits[best.ttrait or 0] = 1
			usefulTraits[ts or 0] = 1
			usefulTraits[ts == 79 and 256 or 0] = 1
			usefulTraits[232] = best.dtrait
			for i=1,data.s[2] do
				local fi = fi[best[i]]
				if best[i] ~= me and fi and fi.affinity and fi.affinity > 0 then
					usefulTraits[fi.affinity] = 1
				end
			end
			for i=1,(info.quality or 0)-1 do
				local b = GarrisonFollowerTooltip.Traits[i]
				local t = C_Garrison.GetFollowerTraitAtIndex(info.followerID, i) or 0
				if b and t > 0 then
					local ut = (usefulTraits[t] or usefulTraits[T.EquivTrait[t]])
					local c = ut and (ut == 2 and "|cffdcff0a" or "|cff10ff10") or "|cffa0a0a0"
					b.Name:SetText(c .. (b.Name:GetText() or ""))
				end
			end
			local mlvl2 = self.targetLevel
			if (mlvl2 or 0) > 600 then
				local m = "|cffa0a0a0" .. GARRISON_FOLLOWER_ITEM_LEVEL:format(info.iLevel) .. (info.iLevel < mlvl2 and "|cffff2020" or "")  .. " (" .. mlvl2 .. ")"
				if info.quality >= 4 and info.level >= T.FOLLOWER_LEVEL_CAP then
					GarrisonFollowerTooltip.ILevel:SetText(m)
				else
					GarrisonFollowerTooltip.ClassSpecName:SetText(info.className .. " - " .. m)
				end
			end
		end
	end
	local function CreateInterestMission()
		local b = api.CreateMissionButton(58)
		b.title:ClearAllPoints()
		b.title:SetPoint("TOPLEFT", 68+42-15, -9)
		b.level:ClearAllPoints()
		b.level:SetPoint("CENTER", b, "LEFT", 40, 7)
		b.rare:Hide()
		b.veil:Hide()
		b.mtype:Hide()
		b.iconBG:SetVertexColor(0, 0, 0, 0.4)
		b.iconBG:SetWidth(85)
		b:Disable()

		local t = b:CreateTexture(nil, "BACKGROUND", nil, 3)
		t:SetSize(780, 62)
		t:SetPoint("RIGHT")
		t, b.loc = b:CreateTexture(nil, "BACKGROUND", nil, 6), t
		t:SetAtlas("GarrMission_MissionParchment")
		t:SetVertexColor(0.25, 0.25, 0.25)
		t:SetTexCoord(0, 1, 0, 0.25)
		t:SetHorizTile(true)
		t:SetAllPoints()
		t:Hide()
		t, b.altBG = b:CreateFontString(nil, "ARTWORK", "GameFontNormal"), t
		t:SetPoint("TOP", b.level, "BOTTOM", 0, -1)
		t:SetAlpha(0.8)
		t:SetTextColor(0.83, 0.66, 0.45)
		t, b.fc = b:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge"), t
		t, b.chance = b:CreateFontString(nil, "ARTWORK", "GameFontNormal"), t
		t:SetPoint("TOP", b.chance, "BOTTOM", 0, -1)
		t, b.fstack = b:CreateFontString(nil, "ARTWORK", "GameFontNormal"), t
		t:SetPoint("TOPLEFT", b.title, "BOTTOMLEFT", 0, -2)
		t, b.seen = {}, t
		for i=1,7 do
			t[i] = CreateThreat(b)
			t[i]:SetPoint("RIGHT", t[i-1], "LEFT", -10, 0)
		end
		t[1]:ClearAllPoints()
		t[1]:SetPoint("TOPRIGHT", -140, -5)
		t[4]:SetPoint("TOPRIGHT", t[1], "BOTTOMRIGHT", -15.5, -3)
		t[7]:SetPoint("RIGHT", t[3], "LEFT", -10, 0)
		b.threats = t
		
		b.followers = {}
		for i=1,3 do
			t = api.CreateFollowerPortrait(b, 42, i)
			t:SetPoint("RIGHT", -225-44*i, 1)
			t:SetScript("OnClick", InterestFollower_OnClick)
			t.showAbilityDescriptions, b.followers[i], t.postEnter = true, t, InterestFollower_OnEnter
		end
		
		return b
	end
	local unusedFollowers = CreateFrame("Button") do
		unusedFollowers:SetSize(880, 38)
		local c, t = {}, unusedFollowers:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		t:SetPoint("BOTTOM", unusedFollowers, "TOP", 0, 4)
		unusedFollowers.ufollowers, unusedFollowers.label = c, t
		for i=1,21 do
			t = api.CreateFollowerPortrait(unusedFollowers, 34, i)
			t:SetPoint("BOTTOMLEFT", 36*i-35, 4)
			t:SetScript("OnClick", InterestFollower_OnClick)
			c[i], t.showAbilityDescriptions = t, true
		end
	end
	local function SetUnusedFollowers(self, d)
		local isRed = d.lType == "redundant"
		self.veil:Hide()
		self.altBG:Show()
		for i=1,#self.rewards do
			self.rewards[i]:Hide()
		end
		for i=1,#self.followers do
			self.followers[i]:Hide()
		end
		for i=1,#self.threats do
			self.threats[i]:Hide()
		end
		self.level:SetText("")
		self.fc:SetText("")
		self.title:SetText("")
		self.seen:SetText("")
		self.chance:SetText("")
		self.fstack:SetText("")
		self.mtype:SetColorTexture(0,0,0,0)
		unusedFollowers:SetParent(self)
		unusedFollowers:SetPoint("BOTTOM")
		unusedFollowers.label:SetText(isRed and L"Redundant followers:" or L"Inactive followers:")
		local finfo, uf = G.GetFollowerInfo(), unusedFollowers.ufollowers
		for i=1,#d do
			local fb, fi = uf[i], finfo[d[i]]
			if fb and fi then
				fb.followerID = fi.followerID
				fb.portrait:SetTexture(fi.portraitIconID or 0)
				fb:Show()
			end
		end
		for i=#d+1,#uf do
			uf[i]:Hide()
		end
		unusedFollowers:SetWidth(36 * math.min(#d, #uf))
		unusedFollowers:Show()
	end
	local function SetInterestMission(self, d)
		if d.unused then
			return SetUnusedFollowers(self, d.unused)
		else
			if unusedFollowers:GetParent() == self then
				unusedFollowers:SetParent(nil)
				unusedFollowers:Hide()
			end
			self.altBG:Hide()
		end
		local s, best, mname = d.s, d.best, C_Garrison.GetMissionName(d[1])
		self.level:SetText(s[1])
		self.title:SetText(mname ~= "" and mname or (L"Future Mission #%d"):format(d[1]))
		self.loc:SetAtlas(T.MissionLocationBanners[d[2]] .. "-List")
		self.fc:SetText(best and best.variants and ("|TInterface\\FriendsFrame\\UI-Toast-ChatInviteIcon:12:12:0:0:32:32:6:28:4:26:214:170:115|t: " .. best.variants) or ("|TInterface\\FriendsFrame\\UI-Toast-FriendOnlineIcon:11:11:3:0:32:32:8:24:8:24:214:170:115|t"):rep(s[2]))
		self.veil:SetShown(d.redundantIgnored)

		local mc, isAvailable, lastAppeared = T.MissionCoalescing[s[4]]
		for i=0, mc and #mc or 0 do
			local id = d[1] + (i > 0 and mc[i] or 0)
			local _, _, _, la = G.GetMissionSeen(id)
			isAvailable = isAvailable or G.IsMissionAvailable(id)
			lastAppeared = la and (la <= (lastAppeared or la)) and la or lastAppeared
		end
		if (lastAppeared or 0) > 0 and not isAvailable then
			self.seen:SetFormattedText(L"Last offered: %s ago", "|cffffffff" .. SecondsToTime(lastAppeared) .. "|r")
		else
			self.seen:SetText(isAvailable and (L"Available; expires in %s"):format("|cffffffff" .. (isAvailable.offerTimeRemaining or "?") .. "|r") or "")
		end
		
		for i=1, #self.threats do
			local tb, tid = self.threats[i], s[5+i]
			tb:SetShown(tid)
			if tid then
				SetThreat(tb, d[2], G.GetMechanicInfo(tid))
				local countered = best and best[6+i]
				if not countered or countered == 0 then
					tb.Border:SetVertexColor(1, 0.2, 0.2)
				elseif countered == true or countered and countered >= 1 then
					tb.Border:SetVertexColor(0.2, 1, 0.2)
				else
					tb.Border:SetVertexColor(1, 0.65, 0.1)
				end
			end
		end
		local nf, blvl, mentor, finfo = best and s[2] or 0, best and best[6], best and best.mentorLevel or 0, G.GetFollowerInfo()
		local muf = best and best.used or 0
		for i=1,nf do
			local mlvl = blvl and blvl % 1e3 or d[2]
			blvl = blvl and (blvl - mlvl) / 1e3
			local fb, fi, usedGlow = self.followers[i], finfo[best[i]]
			if not fi then
				fb:Hide()
			else
				fb.followerID, fb.targetLevel = best[i], (mentor < mlvl or fi.garrFollowerID == T.MENTOR_FOLLOWER) and mlvl or 0
				fb.portrait:SetTexture(fi and fi.portraitIconID or 0)
				fb.glow:Hide()
				if fi.status == GARRISON_FOLLOWER_INACTIVE then
					fb.portrait:SetVertexColor(0.2, 0.2, 1)
				elseif fb.targetLevel > (mlvl > T.FOLLOWER_LEVEL_CAP and fi.iLevel or fi.level) then
					fb.portrait:SetVertexColor(1, 0.6, 0.6)
					fb.glow:Show()
					fb.glow:SetVertexColor(1,0,0)
					usedGlow = true
				else
					fb.portrait:SetVertexColor(1,1,1)
				end
				if not usedGlow and muf % 2^i >= 2^(i-1) then
					fb.glow:Show()
					fb.glow:SetVertexColor(1, 0.8, 0)
				end
				fb:Show()
			end
		end
		for i=nf+1, #self.followers do
			self.followers[i]:Hide()
		end
		self.chance:SetText(best and ("%d%%"):format(best[5]) or "")
		if best and best[5] >= 100 then
			self.chance:SetTextColor(0, 1, 0)
		else
			self.chance:SetTextColor(1, 0.55, 0)
		end
		if best and best[4] and nf > 0 then
			local nf = T.UniqueTraits[T.TraitStack[s[4]]] or nf
			local ms = nf * (T.MaxTraitStack[s[4]] or 1)
			self.chance:SetPoint("RIGHT", -70, 6)
			self.fstack:SetText(best[4] .. "/" .. ms .. " |T" .. C_Garrison.GetFollowerAbilityIcon(T.TraitStack[s[4]]) .. ":0:0:0:0:64:64:4:60:4:60|t")
			local r, g, b = 0.1, 1, 0.1
			if best[4] < nf then r, g, b = 1, 0.55, 0 end
			self.fstack:SetTextColor(r,g,b)
		else
			self.chance:SetPoint("RIGHT", -70, 0)
			self.fstack:SetText("")
		end
		
		local r, rt = self.rewards[1], mappedRewards[s[4]] or s[4]
		if rt == 0 then
			local rq = d[3] * (1+(best and best[4] or 0))
			r.tooltipTitle, r.tooltipText, r.currencyID, r.itemID = GARRISON_REWARD_MONEY, GetMoneyString(rq), 0
			r.icon:SetTexture("Interface\\Icons\\INV_Misc_Coin_02")
			r.quantity:SetFormattedText("%d", rq / 1e4)
		elseif rt < 2e3 then
			local rq = d[3] * (1 + (best and best[4] or 0))
			r.currencyID, r.itemID, r.tooltipTitle, r.tooltipText = rt
			r.quantity:SetText(rq > 1 and rq or "")
			r.icon:SetTexture((select(3,Nine.GetCurrencyInfo(rt))))
		else
			r.itemID, r.currencyID, r.tooltipTitle, r.tooltipText = rt
			r.quantity:SetText(d[3] > 1 and d[3] or "")
			r.icon:SetTexture(select(10, GetItemInfo(r.itemID)) or GetItemIcon(r.itemID) or "Interface/Icons/Temp")
		end
		r:Show()
	end
	interestMissionsHandle = core:CreateHandle(CreateInterestMission, SetInterestMission, 60)
	local emptyTable, missions = {}, {}
	local updateRedundantFollowers do
		local unusedEntry = {unused={}}
		local function mcmp(a, b)
			local ac, bc = a == unusedEntry, b == unusedEntry
			if ac == bc then
				ac, bc = b.redundantIgnored, a.redundantIgnored
				if ac == bc then
					ac = a.ord < b.ord
				end
			end
			return ac
		end
		function updateRedundantFollowers(missions)
			local finfo = G.GetFollowerInfo()
			local uf, ua, hasInactive = {}, unusedEntry.unused
			wipe(ua)
			
			for k, v in pairs(finfo) do
				if v.status ~= GARRISON_FOLLOWER_INACTIVE and v.status ~= GARRISON_FOLLOWER_WORKING and not T.config.ignore[k] and v.followerTypeID == 1 then
					uf[k] = true
				end
			end
			for i=1,#missions do
				local mi = missions[i]
				local b, keep = mi.best, G.IsInterestedInMoI(mi)
				mi.redundantIgnored, mi.ord = not keep, mi.ord or i
				if b and keep then
					local muf = b and b.used
					for j=1, mi.s[2] do
						if finfo[b[j]].status == GARRISON_FOLLOWER_INACTIVE then
							if not hasInactive then
								wipe(uf)
							end
							hasInactive, uf[b[j]] = true, 1
						elseif not hasInactive and muf % (2^j) >= 2^(j-1) then
							uf[b[j] or 0] = nil
						end
					end
				end
			end
			table.sort(missions, mcmp)
			
			for k in pairs(uf) do
				ua[#ua + 1] = k
			end
			
			if #ua > 0 then
				table.sort(ua, function(a,b)
					a, b = finfo[a], finfo[b]
					local ac, bc = a.level + a.iLevel, b.level + b.iLevel
					if ac == bc then
						ac, bc = a.name, b.name
					end
					return ac < bc
				end)
				ua.lType = hasInactive and "inactive" or "redundant"
				table.insert(missions, 1, unusedEntry)
			end
		end
	end
	local function updateDisplayFromInfo(info)
		wipe(missions) do
			local ni = 1
			for _, m, b in G.MoIMissions(1, info) do
				if not m.drop then
					missions[ni], ni, m.best = m, ni + 1, b
				end
			end
		end
		local ts = T.TraitStack
		for k,r in pairs(T.MissionRewardSets) do
			for i=1,#r do
				local c, r = 0, r[i]
				for i=3,r[2] > 0 and #r or 0 do
					c = c + (tonumber(GetStatistic(r[i]) or 0) or 0)
				end
				if c >= r[2] then
					mappedRewards[k], r[2], ts[k] = r[1], 0, ts[k] or r.ts
					break
				end
			end
		end
		updateRedundantFollowers(missions)
		return missions
	end
	function interestMissionsHandle:Show(includeInactive)
		interestUI.excludeInactive:SetChecked(not includeInactive)
		local info, job = G.GetBestGroupInfo(1, includeInactive, true)
		if not info then
			core:SetData(emptyTable, interestMissionsHandle)
			interestUI.loader.job = job
			interestUI.loader:Show()
			return
		else
			interestUI.loader:Hide()
		end
		core:SetData(updateDisplayFromInfo(info), interestMissionsHandle)
	end
	function EV:MP_MOI_GROUPS_READY()
		if core:IsOwned(interestMissionsHandle) and core:IsShown() then
			interestMissionsHandle:Show(not interestUI.excludeInactive:GetChecked())
		end
	end
	function EV:MP_RELEASE_CACHES()
		missions, interestMissionsHandle.ident = {}
	end
end
do -- Ships
	local function CreateMissionPoI(parent)
		local f = CreateFrame("FRAME", nil, parent)
		f:SetAllPoints()
		for i=1,2 do
			local t = f:CreateTexture(nil, "ARTWORK", nil, i)
			t:SetSize(22-5*i, 22-5*i)
			t:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMaskSmall")
			t:SetPoint("CENTER", f, "TOPRIGHT", -12, -12)
			f[i == 1 and "outer" or "inner"] = t
		end
		local t = f:CreateTexture(nil, "ARTWORK", nil, 3)
		t:SetSize(12, 5)
		t:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMaskSmall")
		t:SetTexCoord(0, 1, 7/12, 1)
		t:SetPoint("BOTTOM", f.inner, "BOTTOM")
		f.innerLow = t
		f.outer:SetVertexColor(0.2, 0.2, 0.2)
		f.inner:SetVertexColor(0, 1, 0)
		
		parent.MPUI = f
		return f
	end
	local function GetViableSuggestedGroup(mi)
		local sg = G.GetSuggestedGroupsForMission(mi)
		sg = sg and sg[1]
		if sg and not G.GetMissionGroupDeparture(sg, mi) then
			return sg
		end
	end
	local function ShipMission_OnClick(self, button)
		if IsModifiedClick("CHATLINK") and self.info then
			ChatEdit_InsertLink(C_Garrison.GetMissionLink(self.info.missionID))
		elseif self.info.canStart then
			local f1, f2, f3
			if button == "RightButton" then
				local sg = GetViableSuggestedGroup(self.info)
				if sg then
					f1, f2, f3 = sg[5], sg[6], sg[7]
				end
			end
			OpenToMission(self.info, f1, f2, f3)
		end
	end
	local ShipMission_OnEnter do
		local tipGroup = GarrisonShipyardMapMissionTooltip:CreateFontString(nil, "ARTWORK", "GameFontHighlightLeft")
		tipGroup:SetTextColor(0.5, 0.8, 1)
		hooksecurefunc("GarrisonShipyardMapMission_SetTooltip", function() tipGroup:Hide() end)
		local function describeGroup(sg, mi)
			local exp, sp = G.GetMissionGroupXP(sg, mi), sg[1]/100
			local ex, ce, ct = exp >= 1 and ("; " .. (L"%s XP"):format(BreakUpLargeNumbers(floor(exp)))) or "", sg[3]*sp, sg[9]
			if ct == 0 and ce > 1e4 then ex = ex .. "; " .. GetMoneyString(ce - ce % 1e4) end
			return sg[1] .. "%" .. (ex or "")
		end
		function ShipMission_OnEnter(self, ...)
			local mi = self.info
			GarrisonShipyardMapMission_OnEnter(self, ...)
			if mi and mi.canStart and GarrisonShipyardMapMissionTooltip:IsShown() then
				local tipText, sg, lg, ld = "", G.GetSuggestedGroupsForMission(mi)
				sg, lg = sg and sg[1], sg and sg[#sg]
				if sg and not G.GetMissionGroupDeparture(sg, mi) then
					tipText = string.format("|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:14:12:0:-1:512:512:10:70:330:410|t %s: |cffffffff%s", L"Suggested group", describeGroup(sg, mi))
				end
				ld = lg and G.GetMissionGroupDeparture(lg, mi)
				if ld then
					tipText = string.format("|cffb0b0b0%s:|cffffffff %s%s%s", FormatCountdown(ld-time()), describeGroup(lg, mi), tipText ~= "" and "\n|r" or "", tipText)
				end
				if tipText ~= "" then
					tipGroup:SetText(tipText)
					tipGroup:Show()
					GarrisonShipyardMapMission_AnchorToBottomWidget(tipGroup, 0, -12)
					GarrisonShipyardMapMission_SetBottomWidget(tipGroup)
					tipGroup:SetWidth(math.max(180, (GarrisonShipyardMapMissionTooltip:GetWidth() or 16) - 12))
					GarrisonShipyardMapMissionTooltip:SetHeight(GarrisonShipyardMapMissionTooltip:GetHeight() + tipGroup:GetHeight()+12)
					return
				end
			end
		end
		hooksecurefunc("GarrisonShipyardMapMission_UpdateTooltipSize", function(self)
			if tipGroup:IsVisible() then
				GarrisonShipyardMapMissionTooltip:SetHeight(self:GetHeight() + tipGroup:GetHeight()+12)
			end
		end)
	end
	local function getGroupColor(s)
		local c = T.config
		if not s then
			return 0.4, 0.4, 0.4
		elseif s == 100 then
			return 0.2, 0.7, 1
		elseif c.ship4 > s then
			return 0.6, 0, 0
		elseif c.ship3 > s then
			return 1, 0.4, 0
		elseif c.ship2 > s then
			return 1, 0.9, 0
		elseif c.ship1 > s then
			return 0.2, 1, 0.2
		end
	end
	local function UpdateShipMissionMap()
		local self = GarrisonShipyardFrame.MissionTab.MissionList
		local sg = G.GetSuggestedGroupsForAllMissions(2)
		local oil = select(2, Nine.GetCurrencyInfo(1101)) or 0
		for i=1, #self.missions do
			local mission, frame = self.missions[i], self.missionFrames[i]
			if frame:IsShown() and not mission.inProgress then
				local ui, sg = frame.MPUI or CreateMissionPoI(frame), sg[mission.missionID]
				
				local fg, lg = sg and sg[1], sg and sg[#sg]
				fg = fg and not G.GetMissionGroupDeparture(fg, mission) and fg
				lg = lg and lg ~= fg and G.GetMissionGroupDeparture(lg, mission) and lg

				local nt, r, g, b, r2, g2, b2 = G.HasTentativeParty(mission.missionID)
				if nt == mission.numFollowers then
					r,g,b = 1, 0.2, 0.6
				elseif nt > 0 then
					r,g,b = 0.6, 0.2, 1
				elseif (mission.cost or 0) > oil then
					r,g,b = 1/4, 1/4, 1/4
				else
					r,g,b = getGroupColor(fg and fg[1])
					r2, g2, b2 = getGroupColor(lg and lg[1] or fg and fg[1])
				end
				ui.inner:SetVertexColor(r,g,b)
				ui.innerLow:SetVertexColor(r2 or r, g2 or g, b2 or b)
				ui:Show()
			elseif frame.MPUI then
				frame.MPUI:Hide()
			end
			frame:RegisterForClicks("LeftButtonUp", "RightButtonUp")
			frame:SetScript("OnClick", ShipMission_OnClick)
			frame:SetScript("OnEnter", ShipMission_OnEnter)
		end
	end
	do -- update hook
		local pendingUpdate
		local function runUpdate()
			pendingUpdate = false
			return UpdateShipMissionMap()
		end
		local function enqueueUpdate()
			if not pendingUpdate and GarrisonShipyardFrame.MissionTab.MissionList:IsVisible() then
				pendingUpdate = true
				T.After0(runUpdate)
			end
		end
		hooksecurefunc("GarrisonShipyardMap_UpdateMissions", enqueueUpdate)
		HookOnShow(GarrisonShipyardFrame.MissionTab.MissionList, enqueueUpdate)
	end
	local CreateGroupButton do
		local function ShipGroupButton_OnEnter(self)
			GroupButtonBase.ShowTooltip(self, SHIP_MISSION_PAGE.missionInfo, false, true, self.group)
		end
		local function ShipGroupButton_OnClick(self)
			OpenToMission(SHIP_MISSION_PAGE.missionInfo, unpack(self.group, 5, 7))
		end
		function CreateGroupButton(...)
			local b = GroupButtonBase:New(...)
			b:SetScript("OnEnter", ShipGroupButton_OnEnter)
			b:SetScript("OnLeave", dismissTooltip)
			b:SetScript("OnClick", ShipGroupButton_OnClick)
			return b
		end
	end
	local groups = CreateFrame("Frame", nil, SHIP_MISSION_PAGE)
	groups:SetSize(410, 24)
	groups.buttons = {CreateGroupButton(groups, 1), CreateGroupButton(groups, 2), CreateGroupButton(groups, 3), CreateGroupButton(groups, 4)}
	groups.buttons[1]:SetPoint("LEFT")
	groups:SetScript("OnHide", groups.Hide)
	for i=2,#groups.buttons do
		groups.buttons[i]:SetPoint("LEFT", groups.buttons[i-1], "RIGHT", 4, 0)
	end
	local noPendingSync = true
	local function syncMissionGroups()
		local Stage, mi = SHIP_MISSION_PAGE.Stage, SHIP_MISSION_PAGE.missionInfo
		Stage.Title:SetPoint("LEFT", Stage.Header, "LEFT", 98, 10)
		groups:SetPoint("BOTTOMLEFT", Stage.Header, "BOTTOMLEFT", 88, 4)
		groups:Show()
		local sg = mi and G.GetSuggestedGroupsForMission(SHIP_MISSION_PAGE.missionInfo)
		local sgn = sg and #sg or 0
		for i=sgn+1, #groups.buttons do
			groups.buttons[i]:Hide()
		end
		for i=1,sgn do
			local b, g = groups.buttons[i], sg[i]
			GroupButtonBase.SetGroup(b, mi, g, 100, 20, sg.rankType)
			b.group = g
		end
		noPendingSync = true
	end
	hooksecurefunc(GarrisonShipyardFrame, "ShowMission", syncMissionGroups)
	function EV.GARRISON_FOLLOWER_LIST_UPDATE()
		if noPendingSync and SHIP_MISSION_PAGE:IsVisible() then
			noPendingSync = false
			T.After0(syncMissionGroups)
		end
	end
end
do -- RefreshActiveMissionsView
	local isFullRefresh, isDirty = true
	local function DoRefresh()
		local force = isFullRefresh
		isFullRefresh, isDirty = nil
		if force or core:IsOwned(activeMissionsHandle) then
			activeMissionsHandle:Activate(force)
		end
		activeUI.orders:SetShown(GetItemCount(activeUI.orders.itemID) > 0)
	end
	function RefreshActiveMissionsView(force)
		if core:IsShown() and (force or core:IsOwned(activeMissionsHandle)) then
			isFullRefresh = isFullRefresh or force
			if not isDirty then
				isDirty = true
				T.After0(DoRefresh)
			end
		end
	end
end
function EV:GET_ITEM_INFO_RECEIVED()
	if core:IsVisible() then
		core:Refresh()
	end
end
function EV:GARRISON_MISSION_FINISHED()
	if activeUI:IsVisible() then
		RefreshActiveMissionsView(false)
	end
end
hooksecurefunc(GarrisonMissionFrame, "HideCompleteMissions", function(_, onClose)
	if not onClose and core:IsOwned(activeMissionsHandle) then
		RefreshActiveMissionsView(true)
	end
end)

local oldComplete = GarrisonMissionFrame.CheckCompleteMissions
function GarrisonMissionFrame:CheckCompleteMissions(onShow, ...)
	if not missionList:IsShown() then
		return oldComplete(self, onShow, ...)
	end
	if not GarrisonMissionFrame.MissionComplete:IsShown() then
		GarrisonMissionFrame.MissionComplete.completeMissions = C_Garrison.GetCompleteMissions(1) or {}
		if #GarrisonMissionFrame.MissionComplete.completeMissions > 0 then
			T.UpdateMissionTabs()
		end
	end
	local cm = C_Garrison.GetCompleteMissions(1)
	if onShow and not activeUI:IsVisible() and (cm and #cm or 0) > 0 then
		missionList.activeTab:Click()
	end
end
do -- periodic comleted missions check
	local isTimerRunning = false
	local function timer()
		if GarrisonMissionFrame:IsShown() then
			local cm = GarrisonMissionFrame.MissionComplete.completeMissions
			if (cm and #cm or 0) == 0 then
				GarrisonMissionFrame:CheckCompleteMissions()
			end
			C_Timer.After(15, timer)
			isTimerRunning = true
		else
			isTimerRunning = false
		end
	end
	HookOnShow(GarrisonMissionFrame, function()
		if not isTimerRunning then
			timer()
		end
	end)
end

function EV:MP_RELEASE_CACHES()
	core:SetData()
end

function api:SetMissionsUI(tab)
	availUI:SetShown(tab == 1)
	activeUI:SetShown(tab == 3)
	interestUI:SetShown(tab == 4)
	GarrisonMissionFrame.MissionTab.MissionList.selectedTab = 0
	GarrisonMissionFrame.MissionTab.MissionList.EmptyListString:SetAlpha(tab == 1 and 1 or 0)
	if not activeUI:IsShown() then
		if activeUI.completionState == "RUNNING" then
			G.AbortCompleteMissions()
		end
		activeUI.completionState = nil
		if GarrisonMissionFrame.MissionComplete:IsShown() then
			GarrisonMissionFrame:HideCompleteMissions(true)
		end
	end
	EV("MP_SHOW_MISSION_TAB", tab)
end
T.MissionsUI = api

function EV:ADDON_LOADED(a)
	if a ~= "MasterPlan" then return end
	missionList:Show()
	if GarrisonMissionFrameMissions.CompleteDialog:IsShown() then
		GarrisonMissionFrameMissions.CompleteDialog:Hide()
	end
	if GarrisonMissionFrame:IsShown() then
		T.UpdateMissionTabs()
		GarrisonMissionFrame:CheckCompleteMissions(true)
	end
	return "remove"
end