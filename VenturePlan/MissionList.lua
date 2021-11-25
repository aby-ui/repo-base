local _, T = ...
local EV, L, U, S = T.Evie, T.L, T.Util, T.Shadows

local SetAchievementReward do
	function SetAchievementReward(ar, mid)
	    ar.assetID = mid
		ar.achievementID = 14844
		local Acs = {[2250]=1,[2251]=2,[2252]=3,[2253]=4,[2254]=5,[2255]=6,[2256]=7,[2258]=8,[2259]=9,[2260]=10}
		if Acs[mid] then
			ar:Show()
			local com = select(3, GetAchievementCriteriaInfo(14844, Acs[mid]))
			if ( com == false ) then
		    	ar.icon:SetTexCoord(0.348, 0.578, 0.348, 0.535)
			else
				ar.icon:SetTexCoord(0.055, 0.289, 0.074, 0.262)
	       end
		else
			ar:Hide()
		end
	end
end
local MissionPage, MissionList
function EV:GARRISON_MISSION_NPC_CLOSED()
	if MissionList then
		S[MissionList]:ReturnToTop()
	end
end
local function LogCounter_OnClick()
	local cb = MissionPage.CopyBox
	cb.Title:SetText(L"Wanted: Adventure Reports")
	cb.Intro:SetText(L"The Cursed Adventurer's Guide hungers. Only the tales of your companions' adventures, conveyed in excruciating detail, will satisfy it.")
	cb.FirstInputBoxLabel:SetText(L"To submit your adventure reports," .. "|n" .. L"1. Visit:")
	cb.SecondInputBoxLabel:SetText(L"2. Upload the following text in the logs channel:")
	cb.ResetButton:SetText(L"Reset Adventure Reports")
	cb.FirstInputBox:SetText("https://discord.gg/NKrmT28Nvk")
	cb.FirstInputBox:SetCursorPosition(0)
	cb.SecondInputBox:SetText(T.ExportMissionReports())
	cb.SecondInputBox:SetCursorPosition(0)
	cb:Show()
	PlaySound(170567)
end
local function LogCounter_Update()
	local lc, c = MissionPage.LogCounter, T.GetMissionReportCount()
	lc:SetShown(c > 0)
	lc:SetText("|cffffffff"..BreakUpLargeNumbers(c).."|r")
end

local bufferedTentativeGroup = {}
local function ConfigureMission(me, mi, haveSpareCompanions, availAnima)
	local mid = mi.missionID
	local emi = C_Garrison.GetMissionEncounterIconInfo(mid)
	local ms = S[me]
	mi.encounterIconInfo, mi.isElite, mi.isRare = emi, emi.isElite, emi.isRare
	
	ms.missionID, ms.baseXPReward = mid, mi.xp or 0
	ms.Name:SetText(mi.name)
	if (mi.description or "") ~= "" then
		ms.Description:SetText(mi.description)
	end
	
	local timeNow = GetTime()
	local expirePrefix, expireAt, expireRoundUp = false, nil, nil, false
	ms.completableAfter = nil
	if mi.offerEndTime then
		expirePrefix = "|A:worldquest-icon-clock:0:0:0:0|a"
		expireAt = mi.offerEndTime
	elseif mi.timeLeftSeconds then
		ms.completableAfter = timeNow+mi.timeLeftSeconds
		ms.ProgressBar.Text:SetText("")
		ms.ProgressBar:SetProgressCountdown(ms.completableAfter, mi.durationSeconds, L"Click to complete", true, true)
	elseif mi.completed then
		ms.completableAfter = timeNow-1
		ms.ProgressBar:SetProgress(1)
		ms.ProgressBar.Text:SetText(L"Click to complete")
	end
	ms.ProgressBar:SetMouseMotionEnabled(ms.completableAfter and ms.completableAfter <= timeNow)
	ms.ExpireTime.tooltipHeader = L"Adventure Expires In:"
	ms.ExpireTime.tooltipCountdownTo = expireAt
	me:SetCountdown(expirePrefix, expireAt, nil, nil, 2, expireRoundUp)
	ms.Rewards:SetRewards(mi.xp, mi.rewards)
	SetAchievementReward(ms.AchievementReward, mid)
	
	local cost = (mi.cost or 0) + (mi.hasTentativeGroup and U.GetTentativeMissionTroopCount(mid) or 0)
	local isSufficientAnima = not availAnima or (cost <= availAnima)
	local isMissionActive = not not (mi.completed or mi.timeLeftSeconds)
	local veilShade = mi.timeLeftSeconds and 0.65 or 1
	local showDoomRun = haveSpareCompanions and not isMissionActive and isSufficientAnima and not mi.hasTentativeGroup
	local showTentative = not not mi.hasTentativeGroup and not isMissionActive
	local showPendingStart = showTentative and mi.hasPendingStart
	local shiftView = showDoomRun or showTentative
	ms.Veil:SetShown(isMissionActive)
	ms.ProgressBar:SetShown(isMissionActive and not mi.isFakeStart)
	ms.ViewButton:SetShown(not isMissionActive)
	ms.ViewButton:SetText(showPendingStart and L"Starting soon..." or isSufficientAnima and (showTentative and L"Edit party" or L"Select adventurers") or L"Insufficient anima")
	ms.DoomRunButton:Hide()
	ms.DoomRunButton:SetShown(showDoomRun)
	ms.TentativeClear:SetShown(showTentative)
	ms.TentativeMarker:SetShown(showTentative)
	ms.ViewButton:SetPoint("BOTTOM", shiftView and 20 or 0, 12)
	for i=1,#ms.Rewards do
		ms.Rewards[i].RarityBorder:SetVertexColor(veilShade, veilShade, veilShade)
	end
	
	local mdi = C_Garrison.GetMissionDeploymentInfo(mid)
	local hasNovelSpells, totalHP, totalATK, enemies = false, 0, 0, mdi.enemies
	for i=1,#enemies do
		local e = enemies[i]
		for j=1, hasNovelSpells and 0 or #e.autoCombatSpells do
			if not T.KnownSpells[e.autoCombatSpells[j].autoCombatSpellID] then
				hasNovelSpells = true
			end
		end
		totalHP, totalATK = totalHP + e.health, totalATK + e.attack
	end
	local tag = "[" .. (mi.missionScalar or 0) .. (mi.isElite and L"Elite".."]" or mi.isRare and L"Rare".."]" or "]")
	if hasNovelSpells then
		tag = tag .. " |TInterface/EncounterJournal/UI-EJ-WarningTextIcon:16:16|t"
	end
	ms.enemyATK:SetText(BreakUpLargeNumbers(totalATK))
	ms.enemyHP:SetText(BreakUpLargeNumbers(totalHP))
	ms.animaCost:SetText(BreakUpLargeNumbers(cost))
	ms.duration:SetText(mi.duration)
	ms.statLine:SetWidth(ms.duration:GetRight() - ms.statLine:GetLeft())
	ms.TagText:SetText(tag)
	ms:SetGroupPortraits(showTentative and U.GetTentativeGroup(mid, bufferedTentativeGroup) or U.GetInProgressGroup(mi.followers, bufferedTentativeGroup), isMissionActive, ms.Description)
	
	me:Show()
end
local function cmpMissionInfo(a,b)
	local ac, bc = a.completed or a.timeLeftSeconds == 0, b.completed or b.timeLeftSeconds == 0
	if ac ~= bc then
		return ac
	end
	ac, bc = a.timeLeftSeconds, b.timeLeftSeconds
	if (not ac) ~= (not bc) then
		return not ac
	end
	if ac ~= bc then
		return ac < bc
	end
	ac, bc = a.hasPendingStart, b.hasPendingStart
	if ac ~= bc then
		return bc
	end
	ac, bc = a.hasTentativeGroup, b.hasTentativeGroup
	if ac ~= bc then
		return bc
	end
	ac, bc = zPaiXu[lbs[a.missionID]], zPaiXu[lbs[b.missionID]]
	if (ac == nil or lbs[a.missionID] == "Unknown") then
	    print("|cffffcd00VenturePlan：|r|cffff4500任务ID:  |r|cffffcd00["..a.missionID.."]|r|cffff4500没有类型数据，请在aPaiXu.lua里添加该任务类型。|r")
		ac = 0
	end
	if (bc == nil or lbs[b.missionID] == "Unknown") then
		bc = 0
	end
	if ac == bc then
	    local atime, btime = a.offerEndTime, b.offerEndTime
		if atime and btime and atime ~= btime then
			return atime < btime
		end
	end
	return ac < bc
end
local function pushMissionSet(ni, missions, skip, ...)
	if not missions then return ni end
	table.sort(missions, cmpMissionInfo)
	for i=1, #missions do
		local mid = missions[i].missionID
		for j=skip and #skip or 0, 0, -1 do
			if j == 0 then
				ni = ni + 1, ConfigureMission(MissionList.Missions[ni], missions[i], ...)
			elseif skip[j].missionID == mid then
				break
			end
		end
	end
	return ni
end
local function UpdateMissions()
	MissionList.dirty = nil
	MissionList.clearedRewardSync = nil
	local missions = C_Garrison.GetAvailableMissions(123) or {}
	local inProgressMissions = C_Garrison.GetInProgressMissions(123)
	local cMissions = C_Garrison.GetCompleteMissions(123)
	local numFreeCompanions, numAssignedCompanions, haveUnassignedRookies, haveRookies = 0, 0, false, false do
		local ft = C_Garrison.GetFollowers(123)
		for i=1,#ft do
			local fi = ft[i]
			if fi.isCollected and fi.status ~= GARRISON_FOLLOWER_ON_MISSION then
				numFreeCompanions = numFreeCompanions + 1
				local hasTG = U.FollowerHasTentativeGroup(fi.followerID)
				if hasTG then
					numAssignedCompanions = numAssignedCompanions + 1
				end
				if not (haveUnassignedRookies or fi.isMaxLevel or hasTG) then
					haveUnassignedRookies = true
				end
			end
			haveRookies = haveRookies or (fi.isCollected and not fi.isMaxLevel)
		end
	end
	EV("I_OBSERVE_AVAIL_MISSIONS", missions)
	for i=1,#missions do
		local m = missions[i]
		local mid = m.missionID
		if not m.timeLeftSeconds then
			local sg = 0
			for j=1, m.rewards and #m.rewards or 0 do
				local i = m.rewards[j]
				if i.currencyID == 1828 and sg < 3 then
					sg = 3
				elseif i.followerXP and sg < 2 then
					sg = haveRookies and 2 or j == 1 and -1 or sg
				elseif i.itemID and C_Item.IsAnimaItemByID(i.itemID) and sg < 1 then
					sg = 1
				elseif sg < 0 then
					sg = 0
				end
			end
			m.sortGroup = sg
		end
		m.hasTentativeGroup = U.MissionHasTentativeGroup(mid)
		m.hasPendingStart = U.IsMissionStartingSoon(mid)
	end
	for i=1,inProgressMissions and #inProgressMissions or 0 do
		missions[#missions+1] = inProgressMissions[i]
	end
	
	local ni, anima = 1, C_CurrencyInfo.GetCurrencyInfo(1813)
	anima = (anima and anima.quantity or 0)
	ni = pushMissionSet(ni, cMissions, missions, haveUnassignedRookies, anima)
	ni = pushMissionSet(ni, missions, nil, haveUnassignedRookies, anima)
	ni = pushMissionSet(ni, inProgressMissions, missions, haveUnassignedRookies, anima)
	MissionList.numMissions = ni-1
	for i=ni, #MissionList.Missions do
		MissionList.Missions[i]:Hide()
	end
	MissionPage.hasCompletedMissions = cMissions and #cMissions > 0 or false
	MissionPage.UnButton:Sync()
	MissionPage.CompanionCounter:SetText(numFreeCompanions-numAssignedCompanions)
end
local function CheckItemRewards(w)
	local hadItems, hadUnknowns = false, false
	for j=2,3 do
		local rw = S[w].Rewards[j]
		if rw and rw:IsShown() and rw.itemID and (not rw.itemLink or rw.itemLink:match("|h%[%]|h")) then
			hadItems, hadUnknowns = true, hadUnknowns or (GetItemInfo(rw.itemLink or rw.itemID) == nil)
		end
	end
	return hadItems, hadUnknowns
end
local function CheckRewardCache()
	if MissionList.clearedRewardSync == true or not S[MissionList]:IsVisible() then
		return
	end
	local mwa, isCleared = MissionList.Missions, true
	for i=1,#mwa do
		local w = mwa[i]
		if w:IsShown() then
			local refresh, unclear = CheckItemRewards(w)
			local mi = refresh and C_Garrison.GetBasicMissionInfo(S[w].missionID)
			if mi and mi.rewards then
				S[w].Rewards:SetRewards(mi.xp, mi.rewards)
			end
			isCleared = isCleared and not unclear
		end
	end
	MissionList.clearedRewardSync = isCleared
end

local function QueueListSync()
	if S[MissionList]:IsShown() and not MissionList.dirty then
		MissionList.dirty = true
		C_Timer.After(0, UpdateMissions)
	end
end
local function UBSync(e, o)
	if MissionPage and MissionPage.UnButton then
		MissionPage.UnButton:Sync()
	end
	if e == "I_TENTATIVE_GROUPS_CHANGED" then
		QueueListSync()
	elseif e == "I_COMPLETE_QUEUE_UPDATE" and (o == "DONE" or o == "ABORT") and MissionList then
		S[MissionList]:CheckScrollRange()
	end
end
local function MissionComplete_Toast(_, mid, won, mi)
	local toast = MissionPage:AcquireToast()
	local novel = T.GetMissionReportInfo and T.GetMissionReportInfo(mid)
	local outSuf = novel == 1 and " |A:garrmission_countercheck:0:1.2|a" or novel == 2 and " |A:garrmission_counterhalfcheck:0:1.2|a" or novel == 3 and " |A:common-icon-redx:0:0|a" or ""
	toast.Header:SetText((won and ("|cff00aaff" .. L"Victorious") or ("|cffff0000" .. L"Defeated")) .. outSuf)
	if won then
		toast.Sheen:SetVertexColor(0, 1, 0)
		toast.PreGlow:SetVertexColor(1, 0.90, 0.90)
		PlaySound(165974)
	else
		toast.Sheen:SetVertexColor(0, 0.66, 1)
		toast.PreGlow:SetVertexColor(0.80, 0.90, 1)
		PlaySound(165976)
	end
	toast.Detail:SetText(mi and mi.name or C_Garrison.GetMissionName(mid))
	S[toast].Rewards:SetRewards(nil, mi and mi.rewards)
	local nct = 0
	for i=1, mi.followerInfo and #mi.followerInfo or 0 do
		local fi = mi.followerInfo[i]
		if fi.newLevel then
			nct = nct + 1
			C_Timer.After(0.075*nct, function()
				local toast = MissionPage:AcquireToast(true)
				toast.Sheen:SetVertexColor(0, 0.55, 1)
				toast.PreGlow:SetVertexColor(1, 0.90, 0.90)
				toast.Header:SetText(UNIT_LEVEL_TEMPLATE:format(fi.newLevel))
				toast.Detail:SetText(fi.name)
				toast.Portrait:SetTexture(fi.portraitIconID)
				PlaySound(167127, nil, false)
			end)
		end
	end
end

local function HookAndCallOnShow(frame, f)
	frame:HookScript("OnShow", f)
	if frame:IsVisible() then
		f(frame)
	end
end
function EV:I_ADVENTURES_UI_LOADED()
	MissionPage = T.CreateObject("MissionPage", CovenantMissionFrame.MissionTab)
	MissionList = MissionPage.MissionList
	T.MissionList = MissionList
	local lc = MissionPage.LogCounter
	lc.tooltipHeader, lc.tooltipText = "|cff1eff00" .. L"Adventure Report", NORMAL_FONT_COLOR_CODE .. L"A detailed record of an adventure completed by your companions." .. "|n|n|cff1eff00" .. L"Use: Feed the Cursed Adventurer's Guide."
	lc:SetScript("OnClick", LogCounter_OnClick)
	HookAndCallOnShow(CovenantMissionFrame.MissionTab.MissionList, function(self)
		self:Hide()
		S[MissionPage]:Show()
	end)
	HookAndCallOnShow(S[MissionList], function()
		CovenantMissionFrameFollowers:Hide()
		UpdateMissions()
		LogCounter_Update()
	end)
	EV.I_STORED_LOG_UPDATE = LogCounter_Update
	EV.GARRISON_MISSION_LIST_UPDATE = QueueListSync
	EV.GARRISON_MISSION_FINISHED = QueueListSync
	EV.I_MISSION_LIST_UPDATE = QueueListSync
	EV.I_DELAYED_START_UPDATE = QueueListSync
	EV.GET_ITEM_INFO_RECEIVED = CheckRewardCache
	EV.I_TENTATIVE_GROUPS_CHANGED = UBSync
	EV.I_MISSION_QUEUE_CHANGED = UBSync
	EV.I_COMPLETE_QUEUE_UPDATE = UBSync
	EV.I_MISSION_COMPLETION_STEP = MissionComplete_Toast
	MissionPage.CopyBox.ResetButton:SetScript("OnClick", function(self)
		EV("I_RESET_STORED_LOGS")
		self:GetParent():Hide()
	end)
	EV.I_UPDATE_CURRENCY_SHIFT = function(e, cid)
		local p = MissionPage.ProgressCounter:GetScript("OnEvent")
		p(MissionPage.ProgressCounter, e, cid)
	end
	return "remove"
end