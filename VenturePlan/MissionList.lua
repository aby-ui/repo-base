local _, T = ...
local EV, L, U, S = T.Evie, T.L, T.Util, T.Shadows

local AddMissionAchievementInfo do
	local missionCreditCriteria = {}
	function AddMissionAchievementInfo(missions)
		if not missions or #missions == 0 then
			return missions
		end
		if not next(missionCreditCriteria) then
			local aid=14844
			for i=1,GetAchievementNumCriteria(aid) do
				local _, ct, com, _, _, _, _, asid, _, cid = GetAchievementCriteriaInfo(aid, i)
				if ct == 174 and asid then
					missionCreditCriteria[asid] = aid*2 + cid*1e6 + (com and 1 or 0)
				end
			end
		end
		if next(missionCreditCriteria) and missions then
			for i=1,#missions do
				local mi = missions[i]
				local mid = mi.missionID
				local ai = missionCreditCriteria[mid]
				if ai then
					mi.achievementID = math.floor(ai % 1e6 / 2)
					if ai % 2 == 1 then
						mi.achievementComplete = true
					else
						local cid = math.floor(ai / 1e6)
						local _, _, isComplete = GetAchievementCriteriaInfoByID(mi.achievementID, cid)
						mi.achievementComplete, missionCreditCriteria[mid] = isComplete, isComplete and ai + 1 or ai
					end
				end
			end
		end
		return missions
	end
end

local MissionPage, MissionList

local startedMissions, finishedMissions, FlagMissionFinish, GetReservedAnima = {}, {} do
	local followerLock, costLock, lockedCosts = {}, {}, 0
	hooksecurefunc(C_Garrison, "StartMission", function(mid)
		if not mid or C_Garrison.GetFollowerTypeByMissionID(mid) ~= 123 then return end
		startedMissions[mid] = 1
		local mi = C_Garrison.GetBasicMissionInfo(mid)
		local et = GetTime()+(mi and mi.durationSeconds or 3600)
		for i=1,mi and mi.followers and #mi.followers or 0 do
			local fid = mi.followers[i]
			followerLock[fid] = et
			U.ReleaseTentativeFollowerForMission(fid, mid, true)
		end
		lockedCosts, costLock[mid] = lockedCosts - (costLock[mid] or 0) + (mi and mi.cost or 0), mi and mi.cost or nil
	end)
	function EV:ADVENTURE_MAP_CLOSE()
		startedMissions = {}
		finishedMissions = {}
		followerLock = {}
		costLock, lockedCosts = {}, 0
		if MissionList then
			S[MissionList]:ReturnToTop()
		end
	end
	function EV:GARRISON_MISSION_STARTED(_, mid)
		if mid then
			startedMissions[mid] = nil
		end
		if costLock[mid] then
			lockedCosts, costLock[mid] = lockedCosts - costLock[mid], nil
		end
	end
	function EV:I_MARK_FALSESTART_FOLLOWERS(fa)
		for i=1,fa and #fa or 0 do
			local fi = fa[i]
			local et = followerLock[fi.followerID]
			if et and not fi.isAutoTroop then
				fi.status = GARRISON_FOLLOWER_ON_MISSION
				fi.missionTimeEnd = et
			end
		end
	end
	function FlagMissionFinish(mid)
		if mid then
			finishedMissions[mid] = 1
		end
	end
	function GetReservedAnima()
		return lockedCosts
	end
end

local function LogCounter_OnClick()
	local cb = MissionPage.CopyBox
	cb.Title:SetText(L"Wanted: Adventure Reports")
	cb.Intro:SetText(L"The Cursed Adventurer's Guide hungers. Only the tales of your companions' adventures, conveyed in excruciating detail, will satisfy it.")
	cb.FirstInputBoxLabel:SetText(L"To submit your adventure reports," .. "|n" .. L"1. Visit:")
	cb.SecondInputBoxLabel:SetText(L"2. Copy the following text:")
	cb.ResetButton:SetText(L"Reset Adventure Reports")
	cb.FirstInputBox:SetText("https://www.townlong-yak.com/addons/venture-plan/submit-reports")
	cb.FirstInputBox:SetCursorPosition(0)
	cb.SecondInputBox:SetText(T.ExportMissionReports())
	cb.SecondInputBox:SetCursorPosition(0)
	cb:Show()
	PlaySound(170567)
end
local function LogCounter_Update()
	local lc, c = MissionPage.LogCounter, T.GetMissionReportCount()
	lc:SetShown(c > 0)
	lc:SetText(BreakUpLargeNumbers(c))
end

local function ConfigureMission(me, mi, isAvailable, haveSpareCompanions, availAnima)
	local mid = mi.missionID
	local emi = C_Garrison.GetMissionEncounterIconInfo(mid)
	local ms = S[me]
	mi.encounterIconInfo, mi.isElite, mi.isRare = emi, emi.isElite, emi.isRare
	
	ms.missionID, ms.isAvailable, ms.offerEndTime = mid, isAvailable, mi.offerEndTime
	ms.baseCost, ms.baseCostCurrency = mi.basecost, mi.costCurrencyTypesID
	ms.baseXPReward = mi.xp or 0
	ms.Name:SetText(mi.name)
	if (mi.description or "") ~= "" then
		ms.Description:SetText(mi.description)
	end
	
	local mdi = C_Garrison.GetMissionDeploymentInfo(mid)
	
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
	me:SetCountdown(expirePrefix, expireAt, nil, nil, true, expireRoundUp)
	ms.Rewards:SetRewards(mdi.xp, mi.rewards)
	ms.AchievementReward.assetID = mi.missionID
	ms.AchievementReward.achievementID = mi.achievementID
	ms.AchievementReward:SetShown(mi.achievementID and not mi.achievementComplete)
	
	local cost = (mi.cost or 0) + (mi.hasTentativeGroup and U.GetTentativeMissionTroopCount(mid) or 0)
	local isSufficientAnima = not availAnima or (cost <= availAnima)
	local isMissionActive = not not (mi.completed or mi.timeLeftSeconds)
	local veilShade = mi.timeLeftSeconds and 0.65 or 1
	local showDoomRun = haveSpareCompanions and not isMissionActive and isSufficientAnima and not mi.hasTentativeGroup
	local showTentative = not not mi.hasTentativeGroup
	local shiftView = showDoomRun or showTentative
	ms.Veil:SetShown(isMissionActive)
	ms.ProgressBar:SetShown(isMissionActive and not mi.isFakeStart)
	ms.ViewButton:SetShown(not isMissionActive)
	ms.ViewButton:SetText(isSufficientAnima and (showTentative and L"Edit party" or L"Select adventurers") or L"Insufficient anima")
	ms.DoomRunButton:SetShown(showDoomRun)
	ms.TentativeClear:SetShown(showTentative)
	ms.ViewButton:SetPoint("BOTTOM", shiftView and 20 or 0, 12)
	for i=1,#ms.Rewards do
		ms.Rewards[i].RarityBorder:SetVertexColor(veilShade, veilShade, veilShade)
	end
	local hasNovelSpells, enemies = false, mdi.enemies
	for i=1,#enemies do
		for j=1,#enemies[i].autoCombatSpells do
			if not T.KnownSpells[enemies[i].autoCombatSpells[j].autoCombatSpellID] then
				hasNovelSpells = true
			end
		end
	end
	
	local di, totalHP, totalATK = C_Garrison.GetMissionDeploymentInfo(mi.missionID), 0, 0
	for i=1,di and di.enemies and #di.enemies or 0 do
		local e = di.enemies[i]
		if e then
			totalHP = totalHP + e.health
			totalATK = totalATK + e.attack
		end
	end
	local tag = "[" .. (mi.missionScalar or 0) .. (mi.isElite and "+]" or mi.isRare and "*]" or "]")
	if hasNovelSpells then
		tag = tag .. " |TInterface/EncounterJournal/UI-EJ-WarningTextIcon:16:16|t"
	end
	ms.enemyATK:SetText(BreakUpLargeNumbers(totalATK))
	ms.enemyHP:SetText(BreakUpLargeNumbers(totalHP))
	ms.animaCost:SetText(BreakUpLargeNumbers(cost))
	ms.duration:SetText(mi.duration)
	ms.statLine:SetWidth(ms.duration:GetRight() - ms.statLine:GetLeft())
	ms.TagText:SetText(tag)
	
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
	ac, bc = a.hasTentativeGroup, b.hasTentativeGroup
	if ac ~= bc then
		return ac
	end
	ac, bc = a.offerEndTime, b.offerEndTime
	if ac and bc and ac ~= bc then
		return ac < bc
	end
	ac, bc = a.durationSeconds, b.durationSeconds
	if ac and bc and ac ~= bc then
		return ac < bc
	end
	return a.name < b.name
end
local function UpdateMissions()
	MissionList.dirty = nil
	MissionList.clearedRewardSync = nil
	local missions = C_Garrison.GetAvailableMissions(123) or {}
	local inProgressMissions = C_Garrison.GetInProgressMissions(123)
	local cMissions = C_Garrison.GetCompleteMissions(123)
	local numFreeCompanions, numFreeCompanionsL = 0, 0 do
		local ft = C_Garrison.GetFollowers(123)
		EV("I_MARK_FALSESTART_FOLLOWERS", ft)
		for i=1,#ft do
			local fi = ft[i]
			if fi.isCollected and fi.status ~= GARRISON_FOLLOWER_ON_MISSION then
				numFreeCompanions = numFreeCompanions + 1
				if not fi.isMaxLevel and not U.FollowerHasTentativeGroup(fi.followerID) then
					numFreeCompanionsL = numFreeCompanionsL + 1
				end
			end
		end
	end
	for i=1,#missions do
		local m = missions[i]
		local mid = m.missionID
		if startedMissions[mid] and not m.timeLeftSeconds then
			m.timeLeftSeconds, m.offerEndTime = m.durationSeconds
		end
		m.hasTentativeGroup = U.MissionHasTentativeGroup(mid)
	end
	for i=1,inProgressMissions and #inProgressMissions or 0 do
		missions[#missions+1] = inProgressMissions[i]
	end
	for i=1,cMissions and #cMissions or 0 do
		local cid = cMissions[i].missionID
		for j=1, inProgressMissions and #inProgressMissions or 0 do
			if inProgressMissions[j].missionID == cid then
				cid = nil
				break
			end
		end
		if cid and not finishedMissions[cid] then
			missions[#missions+1] = cMissions[i]
		end
	end
	AddMissionAchievementInfo(missions)
	table.sort(missions, cmpMissionInfo)
	
	local anima = C_CurrencyInfo.GetCurrencyInfo(1813)
	anima = (anima and anima.quantity or 0) - GetReservedAnima()
	local Missions = MissionList.Missions
	for i=1,#missions do
		ConfigureMission(Missions[i], missions[i], true, numFreeCompanionsL > 0, anima)
	end
	MissionList.numMissions = #missions
	for i=#missions+1, #Missions do
		Missions[i]:Hide()
	end
	MissionPage.hasCompletedMissions = cMissions and #cMissions > 0 or false
	MissionPage.UnButton:Sync()
	MissionPage.CompanionCounter:SetText(numFreeCompanions)
end
local function CheckRewardCache()
	if MissionList.clearedRewardSync == true or not S[MissionList]:IsVisible() then
		return
	end
	local mwa, isCleared = MissionList.Missions, true
	for i=1,#mwa do
		local w = mwa[i]
		if w:IsShown() then
			for j=2,3 do
				local rw = S[w].Rewards[j]
				if rw:IsShown() and rw.itemID and rw.itemLink and rw.itemLink:match("|h%[%]|h") then
					local mi = C_Garrison.GetBasicMissionInfo(S[w].missionID)
					S[w].Rewards:SetRewards(mi.xp, mi.rewards)
					isCleared = nil
					break
				end
			end
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
local function UBSync(e)
	if MissionPage and MissionPage.UnButton then
		MissionPage.UnButton:Sync()
	end
	if e == "I_TENTATIVE_GROUPS_CHANGED" then
		QueueListSync()
	end
end
local function MissionComplete_Toast(_, mid, won, mi)
	local toast = MissionPage:AcquireToast()
	local novel = T.GetMissionReportInfo and T.GetMissionReportInfo(mid)
	local outSuf = novel == 1 and " |A:garrmission_countercheck:0:1.2|a" or novel == 2 and " |A:garrmission_counterhalfcheck:0:1.2|a" or novel == 3 and " |A:common-icon-redx:0:0|a" or ""
	toast.Outcome:SetText((won and ("|cff00aaff" .. L"Victorious") or ("|cffff0000" .. L"Defeated")) .. outSuf)
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
	toast.Icon:SetTexture("Interface/Icons/Temp")
	toast.IconBorder:Hide()
	for i=1, mi and mi.rewards and #mi.rewards or 0 do
		local rew = mi.rewards[i]
		if rew.icon then
			toast.Icon:SetTexture(rew.icon)
		elseif rew.itemID then
			toast.Icon:SetTexture(GetItemIcon(rew.itemID))
		end
		if rew.currencyID then
			toast.IconBorder:SetAtlas("loottoast-itemborder-gold")
			toast.IconBorder:Show()
			local ci = C_CurrencyInfo.GetCurrencyContainerInfo(rew.currencyID, rew.quantity)
			if ci then
				toast.Icon:SetTexture(ci.icon)
				local lb = LOOT_BORDER_BY_QUALITY[ci.quality]
				if lb then
					toast.IconBorder:SetAtlas(lb)
				end
			end
			if rew.currencyID == 1828 then
				toast.IconBorder:SetAtlas("loottoast-itemborder-orange")
			end
			break
		elseif rew.itemID or rew.itemLink then
			local r = select(3,GetItemInfo(rew.itemLink or rew.itemID)) or select(3,GetItemInfo(rew.itemID))
			toast.IconBorder:Show()
			if r and r > 1 then
				toast.IconBorder:SetAtlas(
					(r == 2) and "loottoast-itemborder-green"
					or r == 3 and "loottoast-itemborder-blue"
					or r == 4 and "loottoast-itemborder-purple"
					or "loottoast-itemborder-orange"
				)
			else
				toast.IconBorder:Hide()
			end
			break
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
	hooksecurefunc(C_Garrison, "MissionBonusRoll", FlagMissionFinish)
	EV.I_STORED_LOG_UPDATE = LogCounter_Update
	EV.GARRISON_MISSION_LIST_UPDATE = QueueListSync
	EV.GARRISON_MISSION_FINISHED = QueueListSync
	EV.I_MISSION_LIST_UPDATE = QueueListSync
	EV.GET_ITEM_INFO_RECEIVED = CheckRewardCache
	EV.I_TENTATIVE_GROUPS_CHANGED = UBSync
	EV.I_MISSION_QUEUE_CHANGED = UBSync
	EV.I_COMPLETE_QUEUE_UPDATE = UBSync
	EV.I_MISSION_COMPLETION_STEP = MissionComplete_Toast
	MissionPage.CopyBox.ResetButton:SetScript("OnClick", function(self)
		EV("I_RESET_STORED_LOGS")
		self:GetParent():Hide()
	end)
	return "remove"
end
