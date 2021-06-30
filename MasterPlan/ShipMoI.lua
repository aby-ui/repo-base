local _, T = ...
if T.Mark ~= 50 then return end
local L, G, EV, api = T.L, T.Garrison, T.Evie, T.MissionsUI

local Nine = T.Nine or _G
local C_Garrison = Nine.C_Garrison

local function dismissTooltip(self)
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end

local moiContainer, core, loader = CreateFrame("Frame", "MPShipMoI", GarrisonShipyardFrame, "GarrisonBaseInfoBoxTemplate") do
	moiContainer:SetPoint("TOPLEFT", 33, -64)
	moiContainer:SetPoint("BOTTOMRIGHT", -35, 34)
	moiContainer:Hide() do
		local t = moiContainer:CreateTexture(nil, "BORDER", nil, 4)
		t:SetAtlas("_Garr_InfoBoxBorder-Top", true)
		t:SetHorizTile(true)
		t:SetTexCoord(0,1, 1,0)
		t:SetPoint("BOTTOMLEFT")
		t:SetPoint("BOTTOMRIGHT")
		t = moiContainer:CreateTexture(nil, "BORDER", nil, 5)
		t:SetAtlas("Garr_InfoBoxBorder-Corner", true)
		t:SetTexCoord(0,1, 1,0)
		t:SetPoint("BOTTOMLEFT")
		t = moiContainer:CreateTexture(nil, "BORDER", nil, 5)
		t:SetAtlas("Garr_InfoBoxBorder-Corner", true)
		t:SetTexCoord(1,0, 1,0)
		t:SetPoint("BOTTOMRIGHT")
	end
	core, moiContainer.List = api.createScrollList(moiContainer, 882)
	GarrisonShipyardFrame.InterestTab = moiContainer
	loader = api.CreateLoader(moiContainer, 20, 30, 20)
	loader:SetPoint("CENTER")
	local fadeIn = moiContainer.List:CreateAnimationGroup() do
		local a = fadeIn:CreateAnimation("Alpha")
		a:SetFromAlpha(0)
		a:SetToAlpha(1)
		a:SetDuration(0.25)
	end
	
	function loader:OnFinish(nf)
		if nf > 2 then
			fadeIn:Play()
		end
	end
end
local moiHandle do
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
		t:SetSize(34.5, 34.5)
		t:SetPoint("CENTER")
		b.Border, b.info = t, {}
		b:SetScript("OnEnter", Threat_OnEnter)
		b:SetScript("OnLeave", dismissTooltip)
		return b
	end
	local function SetThreat(self, level, tid, _, icon)
		self.id, self.missionLevel = tid, level
		self.Border:SetAtlas(T.StrongNavalThreats[tid] and "GarrMission_EncounterAbilityBorder-Lg" or "GarrMission_WeakEncounterAbilityBorder-Lg")
		self.Icon:SetTexture(icon)
	end
	local function CreateShipInterestMission()
		local b = api.CreateMissionButton(58)
		b.title:ClearAllPoints()
		b.title:SetPoint("TOPLEFT", 68+42-35, -9)
		b.level:ClearAllPoints()
		b.level:SetPoint("CENTER", b, "LEFT", 30, 7)
		b.rare:Hide()
		b.veil:Hide()
		b.mtype:Hide()
		b.iconBG:SetVertexColor(0, 0, 0, 0.4)
		b.iconBG:SetWidth(65)
		b:Disable()

		local t = b:CreateTexture(nil, "BACKGROUND", nil, 3)
		t:SetSize(780, 62)
		t:SetPoint("RIGHT")
		t, b.loc = b:CreateFontString(nil, "ARTWORK", "GameFontNormal"), t
		t:SetPoint("TOP", b.level, "BOTTOM", 0, -1)
		t:SetAlpha(0.8)
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
		b.rewards[1].followerType = 2
		b.veil:Hide()
		
		return b
	end
	local function SetShipInterestMission(self, d)
		local s, best, mname = d.s, d.best, C_Garrison.GetMissionName(d[1])
		self.title:SetText(mname ~= "" and mname or (L"Future Mission #%d"):format(d[1]))
		self.fc:SetText(("|TInterface\\FriendsFrame\\UI-Toast-FriendOnlineIcon:11:11:3:0:32:32:8:24:8:24:214:170:115|t"):rep(s[2]))

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
		local nf = best and s[2] or 0
		self.chance:SetText(best and ("%d%%"):format(best[5]) or "")
		local sc = best and best[5] or 0
		if sc >= 100 then
			self.chance:SetTextColor(0, 1, 0.25)
		elseif sc >= 90 then
			self.chance:SetTextColor(0.95, 1, 0)
		else
			self.chance:SetTextColor(1, 0.45, 0)
		end

		local ab = best and best[4] and nf > 0 and T.ShipTraitStack[s[4]]
		ab = T.TraitDisplayMap and T.TraitDisplayMap[ab] or ab
		if ab then
			self.chance:SetPoint("RIGHT", -70, 6)
			self.fstack:SetText(best[4] .. "/" .. nf .. " |T" .. C_Garrison.GetFollowerAbilityIcon(ab) .. ":0:0:0:0:64:64:4:60:4:60|t")
			local r, g, b = 0.1, 1, 0.1
			if best[4] < nf then r, g, b = 1, 0.55, 0 end
			self.fstack:SetTextColor(r,g,b)
		else
			self.chance:SetPoint("RIGHT", -70, 0)
			self.fstack:SetText("")
		end
	
		local r, rt = self.rewards[1], s[4]
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
	moiHandle = core:CreateHandle(CreateShipInterestMission, SetShipInterestMission, 60)
	moiContainer:SetScript("OnShow", function()
		GarrisonShipyardFrame.MissionTab:Hide()
		GarrisonShipyardFrame.FollowerTab:Hide()
		GarrisonShipyardFrame.FollowerList:Hide()
		local info, job = G.GetBestGroupInfo(2, false, true)
		if info then
			-- This part is actually cheating.
			for _, mi, b in G.MoIMissions(2, info) do
				mi.best = b
			end
			core:SetData(T.ShipInterestPool, moiHandle)
		else
			core:SetData()
			loader.job = job
			loader:Show()
		end
	end)
	function EV:MP_MOI_GROUPS_READY()
		if moiContainer:IsVisible() then
			moiContainer:GetScript("OnShow")(moiContainer)
		end
	end
end

local moiTab = CreateFrame("Button", "GarrisonShipyardFrameTab3", GarrisonShipyardFrame, "GarrisonMissionFrameTabTemplate", 3) do
	local availTab, followerTab = GarrisonShipyardFrameTab1, GarrisonShipyardFrameTab2
	moiTab:SetPoint("LEFT", availTab, "RIGHT", -5, 0)
	followerTab:SetPoint("LEFT", moiTab, "RIGHT", -5, 0)
	moiTab:SetText(L"Missions of Interest")
	PanelTemplates_DeselectTab(moiTab)
	PanelTemplates_TabResize(moiTab, 10)

	moiTab:SetScript("OnClick", function()
		PlaySound(SOUNDKIT.UI_GARRISON_NAV_TABS)
		GarrisonShipyardFrame:SelectTab(3)
	end)
	hooksecurefunc(GarrisonShipyardFrame, "SelectTab", function(_, id)
		if id == 3 then
			PanelTemplates_SelectTab(moiTab)
			PanelTemplates_DeselectTab(availTab)
			PanelTemplates_DeselectTab(followerTab)
			moiContainer:Show()
		else
			moiContainer:Hide()
			PanelTemplates_DeselectTab(moiTab)
		end
	end)
end