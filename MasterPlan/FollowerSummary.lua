local _, T = ...
if T.Mark ~= 50 then return end
local G, L, EV = T.Garrison, T.L, T.Evie

local Nine = T.Nine or _G
local C_Garrison = Nine.C_Garrison

local summaryTab = CreateFrame("Frame", nil, GarrisonMissionFrame, "GarrisonMissionBaseFrameTemplate") do
	summaryTab:Hide()
	summaryTab:SetSize(580, 565)
	summaryTab:SetPoint("TOPRIGHT", -35, -64)
	local t = summaryTab:CreateTexture(nil, "BORDER", nil, 3)
	t:SetAtlas("GarrMission_FollowerPageHeaderBG")
	t:SetPoint("TOPLEFT", 0, -5)
	t:SetPoint("BOTTOMRIGHT", summaryTab, "TOPRIGHT", 0, -58)
	t = summaryTab:CreateFontString(nil, "ARTWORK", "GameFontHighlightHuge")
	t:SetPoint("TOPLEFT", 16, -21)
	t:SetText(L"Follower Summary")
	summaryTab.NumFollowers = GarrisonMissionFrame.FollowerTab.NumFollowers
	local function syncState()
		summaryTab.accessButton:SetChecked(summaryTab:IsShown())
	end
	summaryTab:SetScript("OnShow", function(self)
		self.NumFollowers:SetParent(self)
		GarrisonMissionFrame.FollowerTab:Hide()
		GarrisonMissionFrame.selectedFollower = nil
		GarrisonMissionFrame.FollowerList:UpdateData()
		self.matrix:Sync()
		self.affin:Sync()
		self.stats:Sync()
		T.After0(syncState)
	end)
	GarrisonMissionFrame.FollowerTab:HookScript("OnShow", function(self)
		self.NumFollowers:SetParent(self)
		if summaryTab:IsShown() then
			summaryTab:Hide()
			T.After0(syncState)
		end
	end)
	GarrisonMissionFrame.SummaryTab = summaryTab
end
local matrix = CreateFrame("Frame", nil, summaryTab) do
	local rowHeaders, columnHeaders, grid = {}, {}, {}
	matrix:SetSize(350, 452)
	matrix:SetPoint("TOPLEFT", 16, -80)
	T.CreateEdge(matrix, {edgeFile="Interface/Tooltips/UI-Tooltip-Border", bgFile="Interface/DialogFrame/UI-DialogBox-Background-Dark", tile=true, edgeSize=16, tileSize=16, insets={left=3,right=3,bottom=3,top=3}}, nil, 0xffbf3f)
	local title = matrix:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("BOTTOM", matrix, "TOP", 0, 3)
	title:SetText(L"Counter and Trait Combinations")

	local function MB_Animate(self, elapsed)
		local et, s, g = (self.elapsed or 0) + elapsed, self.start, self.goal
		if et >= 0.35 then
			self:SetScript("OnUpdate", nil)
			self.bg:SetSize(self.goal, self.goal)
			self.goal, self.elapsed = nil
			return
		end
		self.elapsed = et
		local ps = s + (g-s)*sin(257*et)
		self.bg:SetSize(ps, ps)
		self.text:SetAlpha((ps-14)/16)
	end
	local function MB_OnHide(self)
		self:SetScript("OnUpdate", nil)
		self:SetScript("OnHide", nil)
		self.goal, self.elapsed = nil
		self.bg:SetSize(14, 14)
		self.text:SetAlpha(0)
		if GameTooltip:IsOwned(self) then
			GameTooltip:Hide()
		end
	end
	local function MB_OnEnter(self, _, skipTooltip)
		local id = self:GetID()
		local c = id % 10
		local r = 1 + (id - c) / 10
		local rid, cid = rowHeaders[r].id, columnHeaders[c].id
		self:SetScript("OnHide", MB_OnHide)
		self.start, self.goal, self.elapsed = self.bg:GetWidth(), 30, 0
		self:SetScript("OnUpdate", MB_Animate)
		self:SetScript("OnHide", MB_OnHide)
		if skipTooltip ~= "skip" then
			GameTooltip:SetOwner(self, "ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMRIGHT", 3, -3)
			if rowHeaders[r].isTrait then
				G.SetCounterTraitTip(GameTooltip, cid, rid)
			else
				G.SetCounterComboTip(GameTooltip, rid, cid)
			end
			GameTooltip:Show()
		end
	end
	local function MB_OnLeave(self)
		self.start, self.goal, self.elapsed = self.bg:GetWidth(), 14, 0
		self:SetScript("OnUpdate", MB_Animate)
		self:SetScript("OnHide", MB_OnHide)
		if GameTooltip:IsOwned(self) then
			GameTooltip:Hide()
		end
	end
	local function MB_OnClick(self)
		local id, p = self:GetID(), (IsAltKeyDown() or not self.hasFollowers) and "+" or ""
		local c = id % 10
		local r = 1 + (id - c) / 10
		local q = (rowHeaders[r].isTrait and "" or p) .. rowHeaders[r].name .. ";" .. p .. columnHeaders[c].name
		local sb = GarrisonMissionFrameFollowers.SearchBox:IsVisible() and GarrisonMissionFrameFollowers.SearchBox or
		           GarrisonLandingPage.FollowerList.SearchBox:IsVisible() and GarrisonLandingPage.FollowerList.SearchBox
		sb:SetText(q)
		sb.clearText = q
	end
	local eb = CreateFrame("Button", nil, matrix) do
		eb:SetPoint("TOPLEFT", 5, -5)
		eb:SetSize(32, 32)
		eb:RegisterForClicks("RightButtonUp")
		eb:SetScript("OnClick", function(self)
			local f = self.mode and MB_OnLeave or MB_OnEnter
			self.mode = not self.mode
			for k,v in pairs(grid) do
				f(v, nil, "skip")
			end
		end)
		eb:SetScript("OnLeave", function(self)
			if self.mode then
				self:Click()
			end
		end)
	end
	local traits = {79, 256, 314}
	for k=1,9+#traits do
		local name, ico, id, isTrait
		if k > 9 then
			id, isTrait = traits[k-9], true
			name, ico = C_Garrison.GetFollowerAbilityName(traits[k-9]), C_Garrison.GetFollowerAbilityIcon(traits[k-9])
		else
			id, name, ico = G.GetMechanicInfo(k > 4 and k+1 or k)
		end
		for i=1,k > 9 and 1 or 2 do
			local b = T.CreateMechanicButton(matrix)
			b:SetSize(32, 32)
			b:SetPoint("TOPLEFT", i > 1 and 34*k+5 or 5, i == 1 and -34*k-5 or -5)
			b.Icon:SetTexture(ico)
			b.id, b.name, b.isTrait = id, name, isTrait;
			(i == 1 and rowHeaders or columnHeaders)[k] = b
		end
		for j=1,9 do
			local b = CreateFrame("Button", nil, matrix, nil, k*10+j-10)
			b:SetSize(32, 32)
			b:SetPoint("TOPLEFT", 34*j+5, -34*k-5)
			b:SetNormalTexture("Interface\\CharacterFrame\\TempPortraitAlphaMaskSmall")
			b:SetNormalFontObject(GameFontNormalLargeOutline)
			b:SetText((k*10+j-10) % 24 + 1)
			b:SetScript("OnEnter", MB_OnEnter)
			b:SetScript("OnLeave", MB_OnLeave)
			b:SetScript("OnClick", MB_OnClick)
			local t = b:GetNormalTexture()
			t:SetDrawLayer("ARTWORK")
			t:ClearAllPoints()
			t:SetPoint("CENTER")
			t:SetSize(14, 14)
			t:SetVertexColor(0.15, 0.85, 0.15, 0.85)
			t, b.bg = b:GetFontString(), t
			t:SetTextColor(1,1,1)
			t:SetAlpha(0)
			b.text = t
			grid[b:GetID()] = b
		end
	end
	function matrix:Sync()
		local cti, di, tri, fi = G.GetCounterInfo(), G.GetDoubleCounters(), G.GetFollowerTraits(), G.GetFollowerInfo()
		for i=1,#rowHeaders do
			local r,c = rowHeaders[i], columnHeaders[i]
			local rid, rt = r.id, r.isTrait
			local ct = G.countFreeFollowers(rt and tri[rid] or cti[rid], fi) or 0
			ct = ct > 0 and ct or ""
			r.Count:SetText(ct)
			if c then
				c.Count:SetText(ct)
			end
			for j=1,#columnHeaders do
				local cid, c1, c2 = columnHeaders[j].id, grid[i*10+j-10], grid[j*10+i-10]
				local ca, ci, cr, br, bg, bb, ba, bt = 0, 0, 0
				if rt then
					local ct = tri[rid]
					for i=1,ct and #ct or 0 do
						local f = fi[ct[i]]
						if f then
							local found = false
							for k,v in pairs(f.counters) do
								found = found or v == cid
							end
							if not found then
								local st = T.SpecCounters[f.classSpec]
								for i=1,st and #st or 0 do
									if st[i] == cid then
										cr = cr + 1
									end
								end
							elseif f.status == GARRISON_FOLLOWER_INACTIVE then
								ci = ci + 1
							else
								ca = ca + 1
							end
						end
					end
				else
					local dkey = rid * 100 + cid
					local dk = di[dkey]
					for i=1,dk and #dk or 0 do
						local f = fi[dk[i]]
						if f.status == GARRISON_FOLLOWER_INACTIVE then
							ci = ci + 1
						else
							ca = ca + 1
						end
					end
					cr = di[-dkey] and #di[-dkey] or 0
				end
				if ca == ci and ci == 0 then
					br, bb, bg, ba, bt = 0.25,0.25,0.25, (rid == cid or cr == 0) and 0.20 or 1, cr > 0 and cr or ""
				elseif ca > 1 then
					br, bg, bb, ba, bt = 0.75, rt and 0.85 or 0.25, 0, 1, ca
				elseif ca > 0 and ci > 0 then
					br, bg, bb, ba, bt = 0, 0.4, 0, 1, ca
				elseif ca > 0 then
					br, bg, bb, ba, bt = 0, 0.95, 0, 1, ca
				elseif ci > 0 then
					br, bg, bb, ba, bt = 0.8, 0.78, 0.56, 1, ci
				end
				for i=1,rt and 1 or 2 do
					c1.bg:SetVertexColor(br, bg, bb, ba)
					c1:SetText(bt)
					c1.hasFollowers = (ca + ci) > 0
					c1 = c2
				end
			end
		end
	end
	summaryTab.matrix = matrix
end
local affin = CreateFrame("Frame", nil, summaryTab) do
	local rows = {}
	affin:SetSize(192, #T.UsableAffinities*26+9)
	affin:SetPoint("TOPLEFT", summaryTab.matrix, "TOPRIGHT", 6, 0)
	T.CreateEdge(affin, {edgeFile="Interface/Tooltips/UI-Tooltip-Border", bgFile="Interface/DialogFrame/UI-DialogBox-Background-Dark", tile=true, edgeSize=16, tileSize=16, insets={left=3,right=3,bottom=3,top=3}}, nil, 0xffbf3f)
	local title = affin:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("BOTTOM", affin, "TOP", 0, 3)
	title:SetText(L"Races")
	local mechanic_OnEnter
	local function race_OnEnter(self)
		mechanic_OnEnter(self)
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint("TOPRIGHT", self, "TOPLEFT", -2, 2)
	end
	for i=1,#T.UsableAffinities do
		local b, aid = T.CreateMechanicButton(affin), T.UsableAffinities[i]
		b:SetSize(24, 24)
		b:SetPoint("TOPLEFT", 5, 21-i*26)
		local t = b:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		t:ClearAllPoints()
		t:SetPoint("LEFT", 32, 0)
		b.Desc, rows[i], mechanic_OnEnter = t, b, b:GetScript("OnEnter")
		b:SetScript("OnEnter", race_OnEnter)
		b.Icon:SetTexture(C_Garrison.GetFollowerAbilityIcon(aid))
		b.id, b.isTrait, b.name = aid, true, C_Garrison.GetFollowerAbilityName(aid)
	end
	local function rowCmp(a, b)
		local ac, bc = a.s1, b.s1
		if ac == bc then
			ac, bc = a.s2, b.s2
		end
		return ac > bc
	end
	function affin:Sync()
		local ti, fi = G.GetFollowerTraits(), G.GetFollowerInfo()
		for i=1,#rows do
			local b = rows[i]
			local at = ti[b.id]
			local aft = at and at.affine ~= true and at.affine
			local cu, ca, ct = G.countFreeFollowers(at, fi), G.countFreeFollowers(aft, fi) or 0, aft and #aft or 0
			b.Count:SetText(cu > 0 and cu or "")
			local ot = "|cff808080" .. NONE
			if ca > 0 and ct > ca then
				ot = L("%d active"):format(ca) .. "; |cffccc78f" .. L("%d total"):format(ct)
			elseif ca > 0 then
				ot = L("%d active"):format(ca)
			elseif ct > 0 then
				ot = "|cffccc78f" .. L("%d total"):format(ct)
			end
			b.Desc:SetText(ot)
			b.s1, b.s2 = ca, ct-ca
		end
		table.sort(rows, rowCmp)
		for i=1,#rows do
			rows[i]:SetPoint("TOPLEFT", 5, 21-i*26)
		end
	end
	summaryTab.affin = affin
end
local stats = CreateFrame("Frame", nil, summaryTab) do
	local rows = {}
	stats:SetSize(192, 117)
	stats:SetPoint("BOTTOMLEFT", summaryTab.matrix, "BOTTOMRIGHT", 6, 0)
	T.CreateEdge(stats, {edgeFile="Interface/Tooltips/UI-Tooltip-Border", bgFile="Interface/DialogFrame/UI-DialogBox-Background-Dark", tile=true, edgeSize=16, tileSize=16, insets={left=3,right=3,bottom=3,top=3}}, nil, 0xffbf3f)
	local title = stats:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("BOTTOM", stats, "TOP", 0, 3)
	title:SetText(L"Statistics")
	for i=1,4 do
		local b = CreateFrame("Button", nil, stats)
		b:SetSize(180, 24)
		b:SetPoint("TOPLEFT", 5, 18-i*26)
		local t = b:CreateTexture()
		t:SetPoint("LEFT")
		t:SetSize(24, 24)
		t, b.Icon = b:CreateFontString(nil, "OVERLAY", "GameFontHighlight"), t
		t:SetJustifyH("LEFT")
		t:SetPoint("TOPLEFT", 30, 0)
		t:SetPoint("BOTTOMRIGHT", -6, 0)
		if i > 1 then
			b:SetNormalTexture("Interface\\Icons\\Temp")
			b:GetNormalTexture():SetColorTexture(0,0,0,0)
			b:SetPushedTexture("Interface/Buttons/UI-QuickSlot-Depress")
			b:GetPushedTexture():SetAllPoints(b.Icon)
			b:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
			b:GetHighlightTexture():SetAllPoints(b.Icon)
		end
		rows[i], b.Text = b, t
	end
	rows[1].Icon:SetTexture("Interface\\Icons\\INV_Misc_GroupLooking")
	rows[2].Icon:SetTexture("Interface\\Icons\\Garrison_ArmorUpgrade")
	rows[3].Icon:SetTexture("Interface\\Icons\\INV_Misc_Coin_01")
	rows[4].Icon:SetTexture("Interface\\Icons\\INV_Mushroom_11")
	rows[2]:SetScript("OnClick", function()
		local sb, q = GarrisonMissionFrameFollowers.SearchBox, L"Upgradable gear"
		sb:SetText(q)
		sb.clearText = q
	end)
	local function HideGameTooltip(self)
		if GameTooltip:IsOwned(self) then
			GameTooltip:Hide()
		end
	end
	local function CountUpgradableFollowers()
		local nuA, nuI, lcap, upW, upA = 0,0, T.FOLLOWER_LEVEL_CAP, G.GetUpgradeRange()
		for k,v in pairs(G.GetFollowerInfo()) do
			if v.followerTypeID == 1 and v.level == lcap then
				local _weaponItemID, weaponItemLevel, _armorItemID, armorItemLevel = C_Garrison.GetFollowerItems(k)
				if not (weaponItemLevel < upW or armorItemLevel < upA) then
				elseif v.status == GARRISON_FOLLOWER_INACTIVE then
					nuI = nuI + 1
				else
					nuA = nuA + 1
				end
			end
		end
		return nuA, nuI
	end
	rows[2]:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:SetText(L"Upgradable gear", 1,1,1)
		local aA, aI, wA, wI, cap, lcap = 0,0, 0,0, T.FOLLOWER_ITEM_LEVEL_CAP, T.FOLLOWER_LEVEL_CAP
		for k,v in pairs(G.GetFollowerInfo()) do
			if v.followerTypeID == 1 and v.level == lcap then
				local _weaponItemID, weaponItemLevel, _armorItemID, armorItemLevel = C_Garrison.GetFollowerItems(k)
				if v.status == GARRISON_FOLLOWER_INACTIVE then
					aI, wI = aI + cap - armorItemLevel, wI + cap - weaponItemLevel
				else
					aA, wA = aA + cap - armorItemLevel, wA + cap - weaponItemLevel
				end
			end
		end
		local wH = GetItemCount(114128)*3 + GetItemCount(114129)*6 + GetItemCount(114131)*9
		local aH = GetItemCount(114745)*3 + GetItemCount(114808)*6 + GetItemCount(114822)*9
		GameTooltip:AddDoubleLine(L"Weapon levels:", "|cffffffff" .. wA .. (wI > 0 and "|cffccc78f+" .. wI or "") .. (wH > 0 and " |cff00ff00" .. (L"(have %d)"):format(wH) or ""))
		GameTooltip:AddDoubleLine(L"Armor levels:", "|cffffffff" .. aA .. (aI > 0 and "|cffccc78f+" .. aI or "") .. (aH > 0 and " |cff00ff00" .. (L"(have %d)"):format(aH) or ""))
		local nuA, nuI = CountUpgradableFollowers()
		GameTooltip:AddLine("|n" .. (L"Upgrades are available for |cffffffff%d |4active follower:active followers;|r."):format(nuA) .. (nuI > 0 and " |cffccc78f" .. (L"(+%d inactive followers)"):format(nuI) or ""), nil, nil, nil, 1)
		GameTooltip:Show()
	end)
	rows[2]:SetScript("OnLeave", HideGameTooltip)
	rows[3]:RegisterForClicks("RightButtonUp")
	rows[3]:SetScript("OnClick", function(self)
		T.config.goldCollected, T.config.goldCollectedS = 0, 0
		self.Text:SetText(0)
		HideGameTooltip(self)
		self:GetScript("OnEnter")(self)
	end)
	rows[3]:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:SetText(select(2,GetAchievementInfo(328)), 1,1,1)
		local s = T.config.goldCollectedS
		if s >= 1e4 then
			GameTooltip:AddDoubleLine(L"From Naval Missions:", "|cffffffff" .. GetMoneyString(s - s % 1e4))
		end
		GameTooltip:AddLine("|n|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:14:12:0:-1:512:512:10:70:330:410|t " .. RESET, 0.5, 0.8, 1)
		GameTooltip:Show()
	end)
	rows[3]:SetScript("OnLeave", HideGameTooltip)
	rows[4]:RegisterForClicks("RightButtonUp")
	rows[4]:SetScript("OnClick", function(self)
		T.config.moC, T.config.moE, T.config.moV, T.config.moN = 0,0,0,0
		self.Text:SetText("???")
		HideGameTooltip(self)
		self:GetScript("OnEnter")(self)
	end)
	local function ncdf(m, v, l)
		local t, s, d, e = 0, math.max(16*v^0.5/10000,0.00001), 1/(2*v), math.exp(1)
		for i=m-8*v^0.5,l,s do
			t = t + e^(-(i-m)^2*d)
		end
		return t*s*(v*2*math.pi)^-0.5
	end
	local function formatPCT(p)
		local c = math.min(p, 1-p)
		return (c >= 0.10 and "%d%%" or c >= 0.01 and "%.1f%%" or "%.2f%%"):format(p*100)
	end
	local function SetLuckTooltip(GameTooltip)
		local c, e, v, n = T.config.moC, T.config.moE, T.config.moV, T.config.moN
		if n > 0 then
			GameTooltip:SetText(L"Luck", 1,1,1)
			local j = 4
			local nl, nh = ncdf(e+j/2, v+j/4, c), ncdf(e+j/2, v+j/4, c+j)
			local s = nh-nl > 0.02 and formatPCT(nl) .. "-" .. formatPCT(nh) or formatPCT(ncdf(e, v, c))
			GameTooltip:AddLine((L"Better than %s of players (based on %s uncertain missions)."):format("|cffffffff" .. s .. "|r", "|cffffffff" .. n .. "|r"), nil, nil, nil, 1)
			if IsAltKeyDown() then
				GameTooltip:AddLine(("|nX=%d E=%g V=%g"):format(c, e, v), 0.65, 0.65, 0.65)
			end
			GameTooltip:AddLine("|n|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:14:12:0:-1:512:512:10:70:330:410|t " .. RESET, 0.5, 0.8, 1)
			GameTooltip:Show()
		end
	end
	rows[4]:SetScript("OnEnter", function(self)
		if T.config.moN > 0 and (IsAltKeyDown() or self.Text:GetText() ~= "???") then
			GameTooltip:SetOwner(self, "ANCHOR_TOP")
			SetLuckTooltip(GameTooltip)
			T.SetModifierSensitiveTip(SetLuckTooltip, GameTooltip)
		end
	end)
	rows[4]:SetScript("OnLeave", HideGameTooltip)
	function stats:Sync()
		rows[1].Text:SetFormattedText(L"%d followers recruited", C_Garrison.GetNumFollowers(1))
		local uptext, nuA, nuI = "", CountUpgradableFollowers()
		if nuA == 0 then
			uptext = "|cffccc78f" .. L("%d total"):format(nuI)
		elseif nuI > 0 then
			uptext = L("%d active"):format(nuA) .. "; |cffccc78f" .. L("%d total"):format(nuI+nuA)
		else
			uptext = L("%d active"):format(nuA)
		end
		rows[2].Text:SetText(uptext)
		rows[3].Text:SetText(BreakUpLargeNumbers(floor(T.config.goldCollected/1e4)))
		rows[3].Text:SetText(BreakUpLargeNumbers(floor(T.config.goldCollected/1e4)))
		local mt = "???"
		if T.config.moV > 1 then
			mt = math.floor(1000 + 250*(T.config.moC - T.config.moE)/T.config.moV^0.5 + 0.5)
			local qi = math.min(math.floor(mt/250-2.5), 5)
			mt = (qi > 0 and ITEM_QUALITY_COLORS[qi].hex or "") .. BreakUpLargeNumbers(mt)
		end
		rows[4].Text:SetText(mt)
	end
	summaryTab.stats = stats
end
local accessButton = CreateFrame("CheckButton", nil, GarrisonMissionFrame) do
	accessButton:SetSize(24, 24)
	accessButton:SetPushedTexture("Interface/Buttons/UI-QuickSlot-Depress")
	accessButton:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square")
	accessButton:SetCheckedTexture("Interface/Buttons/CheckButtonHilight")
	accessButton:SetChecked(true)
	accessButton:Hide()
	local ico = accessButton:CreateTexture(nil, "ARTWORK")
	ico:SetAllPoints()
	ico:SetTexture("Interface/Icons/Achievement_Boss_CThun")
	accessButton:SetPoint("LEFT", GarrisonMissionFrameFollowers.SearchBox, "RIGHT", 15, 2)
	GarrisonMissionFrameTab2:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	GarrisonMissionFrameTab2:SetScript("OnClick", function(self, button)
		GarrisonMissionController_OnClickTab(self)
		if button == "RightButton" then
			summaryTab:Show()
		end
	end)
	hooksecurefunc(GarrisonMissionFrameFollowers, "ShowFollower", function()
		if GarrisonMissionFrame.selectedFollower and summaryTab:IsShown() then
			local mf = T.GetMouseFocus()
			if mf and mf.id and mf.info and mf.GetButtonState and mf:GetButtonState() == "PUSHED" then
				GarrisonMissionFrame.FollowerTab:Show()
			end
		end
	end)
	function EV:MP_SHOW_MISSION_TAB(tab)
		local st = accessButton:GetChecked()
		accessButton:SetShown(tab == 2)
		if tab ~= 2 then
			summaryTab:Hide()
		elseif st then
			summaryTab:Show()
		end
	end
	accessButton:SetScript("OnClick", function(self)
		local nv = self:GetChecked()
		GarrisonMissionFrame[nv and "SummaryTab" or "FollowerTab"]:Show()
		self:GetScript("OnLeave")(self)
		if not nv then
			GarrisonMissionFrame.selectedFollower = GarrisonMissionFrame.FollowerTab.followerID
			GarrisonMissionFrame.FollowerList:UpdateData()
		end
	end)
	accessButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(L"Follower Summary")
		GameTooltip:Show()
	end)
	accessButton:SetScript("OnLeave", function(self)
		if GameTooltip:IsOwned(self) then
			GameTooltip:Hide()
		end
	end)
	function EV:MP_FORCE_FOLLOWER_TAB(fid)
		accessButton:SetChecked(false)
		GarrisonMissionFrame.FollowerTab:Show()
		if fid and fid ~= GarrisonMissionFrame.selectedFollower then
			GarrisonMissionFrame.selectedFollower = fid
			GarrisonMissionFrame.FollowerList:UpdateData()
		end
	end
	summaryTab.accessButton = accessButton
end

GarrisonMissionFrame.SummaryTab:HookScript("OnShow", function(self)
	local mechanicsFrame = T.mechanicsFrame
	mechanicsFrame:SetParent(self)
	mechanicsFrame:ClearAllPoints()
	mechanicsFrame:SetPoint("LEFT", GarrisonMissionFrame.FollowerTab.NumFollowers, "RIGHT", 11, 0)
	mechanicsFrame:Show()
end)