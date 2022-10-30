local U, _, T = {}, ...
local EV = T.Evie
local L = newproxy(true) do
	local LT = T.LT or {}
	getmetatable(L).__call = function(_, k)
		return LT[k] or k
	end
end
T.Util, T.L, T.LT = U, L, nil
local HAVE_CANNED_GROUPS, CANNED_GROUPS = {}

U.FOLLOWER_XP_ITEMS = {
	[188655]=1,
	[188656]=1,
	[188657]=1,
}

local overdesc = {
	[ 25]={L"Inflicts {} damage to all enemies in melee, and increases own damage dealt by 20% for three turns.", "dp"},
	[120]={L"Increases all damage dealt by a random enemy by {}% for two turns.", "dom"},
	[194]={L"Buffs the closest ally, increasing all damage dealt by {1} and reducing all damage taken by {2}% for two turns. Inflicts {3} damage to self.", "dop", "dim", "dp"},
	[242]={L"Heals the closest ally for {1}, and increases all damage taken by the ally by {2}% for two turns.", "hp", "dim"},
	[223]={L"Debuffs all enemies, dealing {1} damage during each of the next {2} turns. Multiple applications of this effect overlap.", "eDamage", "duration1"},
	[300]={L"Debuffs all enemies, dealing {1} damage during each of the next {2} turns. Multiple applications of this effect overlap.", "eDamage", "duration1"},
	[227]={L"Every other turn, a random enemy is attacked for {}% of their maximum health.", "dh"},
	[301]={L"Every other turn, a random enemy is attacked for {}% of their maximum health.", "dh"},
}
local nonPassiveZeroCD = {[303]=1, [313]=1}
local CLOCK_ICON do
	local ai = C_Texture.GetAtlasInfo("auctionhouse-icon-clock")
	CLOCK_ICON = ("|T%s:0:0:0:-0.5:%d:%d:%d:%d:%d:%d:%%d:%%d:%%d|t "):format(ai.file, 2048, 2048, ai.leftTexCoord*2048, ai.rightTexCoord*2048, ai.topTexCoord*2048, ai.bottomTexCoord*2048)
end
local SPC = {} do
	local m = {}
	function m:__index(k)
		if type(VP_SPC) == "table" then
			return VP_SPC[k]
		end
	end
	function m:__newindex(k,v)
		if type(VP_SPC) ~= "table" then
			VP_SPC = {}
		end
		VP_SPC[k] = v
	end
	setmetatable(SPC, m)
end
local function acqTable(t, k, ...)
	if k == nil then
		return t
	elseif type(t[k]) ~= "table" then
		t[k] = {}
	end
	return acqTable(t[k], ...)
end
local MS_TIER = {} do
	for i, x in ("01027a152637482716493817394a2829183a4b4c2a3b19"):gmatch("()(..)") do
		MS_TIER[tonumber(x,16)] = (i+1)/2
	end
end
local torghastCompanions, torghastCompanionIDs = 10, {1213, 1214, 1215, 1216, 1217, 1220, 1221, 1222, 1223, 1257, 1267, 1268, 1269, 1277, 1278, 1279, 1280, 1281, 1282, 1306, 1307, 1308, 1309, 1310, 1311, 1325, 1326, 1327, 1328, 1329, 1330, 1331, 1332, 1333} do
	local r = {}
	for i=1,#torghastCompanionIDs do
		r[torghastCompanionIDs[i]] = 1
	end
	torghastCompanionIDs = r
end

local GetMaskBoard do
	local b, u, om = {}, {curHP=1}
	function GetMaskBoard(bm)
		if om == bm then
			return b
		end
		om = bm
		for i=0,12 do
			b[i] = bm % 2^(i+1) >= 2^i and u or nil
		end
		return b
	end
	U.GetMaskBoard = GetMaskBoard
end
local function GetTargetMask(si, casterBoardIndex, boardMask)
	if not (si and casterBoardIndex) then
		return 0
	end
	local board, tm, isForked = GetMaskBoard(boardMask), 0, false
	for i=si.h and 0 or 1,#si do
		local ei = si[i] or si
		local eit = ei and ei.t
		if eit then
			isForked = isForked or T.VSim.forkTargetMap[eit]
			local ta = T.VSim.GetTargets(casterBoardIndex, T.VSim.forkTargetMap[eit] or eit, board)
			for i=1,ta and #ta or 0 do
				tm = bit.bor(tm, 2^ta[i])
			end
		end
	end
	return tm + (isForked and tm > 0 and 2^18 or 0)
end
local GetBlipWidth do
	local blipMetric = UIParent:CreateFontString(nil, "BACKGROUND", "GameTooltipText")
	blipMetric:SetPoint("TOPLEFT")
	blipMetric:SetText("|TInterface/Minimap/PartyRaidBlipsV2:8:8|t")
	blipMetric:Hide()
	function GetBlipWidth()
		local _, sh = GetPhysicalScreenSize()
		blipMetric:SetText("|TInterface/Minimap/PartyRaidBlipsV2:8:8|t|TInterface/Minimap/PartyRaidBlipsV2:8:8|t")
		local w2 = blipMetric:GetStringWidth()
		blipMetric:SetText("|TInterface/Minimap/PartyRaidBlipsV2:8:8|t")
		local w1 = blipMetric:GetStringWidth()
		return (w2-w1+select(2,blipMetric:GetFont())*(sh*5/9000-0.7))/0.64*UIParent:GetScale()
	end
end
local function FormatSpellPulse(si)
	local t = si.h
	local bm = "|TInterface/Minimap/PartyRaidBlipsV2:8:8:0:0:64:32:0:20:0:20:%s|t"
	local on, off = bm:format("255:120:0"), bm:format("80:80:80")
	if t == "heal" or t == "nuke" or t == "nukem" or (si.d and si.d <= 1 and si.e) then
		if si.e then
			return on .. (off):rep(si.e-1) .. on
		end
	elseif t == "aura" then
		local r, p = si.p and (si.dp1 and bm:format("255:220:0") or off) or on, si.p or 1
		for i=2, si.d do
			r = r .. (i % p == 0 and on or off)
		end
		return r
	end
end
local FormatAbilityDescriptionOverride do
	local overdescUnscaledKeys = {dh=1, dom=1, dim=1}
	local function getSpellData(si, vk)
		local vv = si and si[vk]
		for i=1,si and not vv and #si or 0 do
			vv = vv or si[i][vk]
		end
		return vv
	end
	local function getSpellValue(si, vk, atk, ms)
		if vk == "eDamage" and ms and si.cATKb and si.cATKa and si.dp then
			return math.floor((si.cATKa+si.cATKb*ms)*si.dp/100)
		elseif vk == "duration1" then
			local vv = getSpellData(si, "d")
			return vv and (vv - 1)
		end
		local vv = getSpellData(si, vk)
		if vv then
			return overdescUnscaledKeys[vk] and (vv < 0 and -vv or vv) or atk and math.floor(vv*(atk or -1)/100)
		end
	end
	local repl = {}
	local function getReplacement(k)
		return repl[k ~= "" and (k+0) or 1]
	end
	function FormatAbilityDescriptionOverride(si, od, atk, ms)
		for i=2, #od do
			local rv = getSpellValue(si, od[i], atk, ms) or "??"
			repl[i-1] = rv
		end
		for i=#repl, #od, -1 do
			repl[i] = nil
		end
		return (od[1]:gsub("{(%d*)}", getReplacement))
	end
end

do -- Tentative Groups
	local groups, followerMissionID = {}, {}
	local autoTroops = {["0xFFFFFFFFFFFFFFFF"]=1, ["0xFFFFFFFFFFFFFFFE"]=1}
	local healthyCompanions = {}
	function EV:GARRISON_MISSION_NPC_CLOSED()
		groups, followerMissionID = {}, {}
	end
	function EV:GARRISON_MISSION_STARTED(_, mid)
		local g = groups[mid]
		if g then
			for i=0,4 do
				followerMissionID[g[i] or 0] = nil
			end
			groups[mid], followerMissionID[0] = nil
			EV("I_TENTATIVE_GROUPS_CHANGED")
		end
	end
	local function GetFollowerInfo(fid)
		local fi = C_Garrison.GetFollowerInfo(fid)
		fi.autoCombatSpells = C_Garrison.GetFollowerAutoCombatSpells(fid, fi.level)
		fi.autoCombatantStats = C_Garrison.GetFollowerAutoCombatStats(fid)
		return fi
	end
	local function StopBoardAnimations(board)
		local as, af = board.socketsByBoardIndex, board.framesByBoardIndex
		for i=0, 12 do
			local f, f2 = as[i], af[i]
			f.EnemyTargetingIndicatorFrame:Stop()
			f2.EnemyTargetingIndicatorFrame:Stop()
			if f.FriendlyTargetingIndicatorFrame then
				f.FriendlyTargetingIndicatorFrame:Stop()
			end
			for _, v in pairs(f.AuraContainer) do
				if type(v) == "table" and v.FadeIn then
					v.FadeIn:Stop()
				end
			end
		end
	end
	function U.SetMissionBoard(g)
		local MPB = CovenantMissionFrame.MissionTab.MissionPage.Board
		for i=0,4 do
			if MPB.framesByBoardIndex[i]:GetFollowerGUID() then
				CovenantMissionFrame:RemoveFollowerFromMission(MPB.framesByBoardIndex[i], false)
			end
		end
		for i=0, g and 4 or -1 do
			local fid = type(g[i]) == "table" and g[i].id or g[i]
			if fid then
				CovenantMissionFrame:AssignFollowerToMission(MPB.framesByBoardIndex[i], GetFollowerInfo(fid))
			end
		end
		StopBoardAnimations(MPB)
	end
	function U.ShowMission(mid, listFrame, overGroup)
		local mi, mi2, g = C_Garrison.GetMissionDeploymentInfo(mid), C_Garrison.GetBasicMissionInfo(mid), groups[mid]
		if mi and mi2 then
			for k,v in pairs(mi2) do
				mi[k] = mi[k] or v
			end
			mi.missionID = mid
			mi.encounterIconInfo = C_Garrison.GetMissionEncounterIconInfo(mid)
			PlaySound(SOUNDKIT.UI_GARRISON_COMMAND_TABLE_SELECT_MISSION)
			for i=0, g and 4 or -1 do
				followerMissionID[g[i] or 0] = nil
			end
			groups[mid], followerMissionID[0] = nil
			CovenantMissionFrame.MissionTab.MissionPage:Show()
			CovenantMissionFrame:ShowMission(mi)
			listFrame:Hide()
			U.SetMissionBoard(overGroup or g)
		end
	end
	function U.StoreMissionGroup(mid, gt, disbandGroups)
		if gt and next(gt) ~= nil then
			local gn = {}
			for k, v in pairs(gt) do
				U.ReleaseTentativeFollower(v, disbandGroups, true)
				gn[k] = v
				if not autoTroops[v] then
					followerMissionID[v] = mid
					healthyCompanions[v] = nil
				end
			end
			groups[mid] = gn
			EV("I_TENTATIVE_GROUPS_CHANGED")
		elseif gt == nil and groups[mid] then
			for _, v in pairs(groups[mid]) do
				followerMissionID[v] = nil
			end
			groups[mid] = nil
			EV("I_TENTATIVE_GROUPS_CHANGED")
		end
	end
	function U.ReleaseTentativeFollower(fid, disbandGroup, doNotNotify)
		local mid = followerMissionID[fid]
		local g = groups[mid]
		if not g then
			return
		end
		for k,v in pairs(g) do
			if disbandGroup or v == fid then
				g[k], followerMissionID[v] = nil
			end
		end
		if next(g) == nil then
			groups[mid] = nil
		end
		if g and not doNotNotify then
			EV("I_TENTATIVE_GROUPS_CHANGED")
		end
	end
	function U.ReleaseTentativeFollowerForMission(fid, mid, disbandGroup, doNotNotify)
		local omid = followerMissionID[fid]
		if omid and omid ~= mid then
			U.ReleaseTentativeFollower(fid, disbandGroup, doNotNotify)
		end
	end
	function U.MissionHasTentativeGroup(mid)
		return groups[mid] ~= nil
	end
	function U.GetTentativeMissionTroopCount(mid)
		local g, r = groups[mid], 0
		for i=0, g and 4 or -1 do
			r = r + (autoTroops[g[i]] and 1 or 0)
		end
		return r
	end
	function U.FollowerHasTentativeGroup(fid)
		local mid = followerMissionID[fid]
		return groups[mid] and mid
	end
	function U.DisbandTentativeGroups()
		groups, followerMissionID = {}, {}
		EV("I_TENTATIVE_GROUPS_CHANGED")
	end
	function U.HaveTentativeGroups()
		return next(groups) ~= nil
	end
	function U.SendTentativeGroups()
		for mid, g in pairs(groups) do
			U.SendMissionGroup(mid, g)
		end
	end
	function U.SendTentativeGroup(mid)
		local g = groups[mid]
		if g then
			U.SendMissionGroup(mid, g)
		end
	end
	function U.GetTentativeGroup(mid, into)
		local g = groups[mid]
		if g then
			into = type(into) == "table" and wipe(into) or {}
			for i=0,4 do
				into[i] = g[i]
			end
			return into
		end
	end
	local function nextTent(_, k)
		local mid, g = next(groups, k)
		if mid then
			local nt, zeroHealth = 0, false
			for i=0,4 do
				local fid = g[i]
				if autoTroops[fid] then
					nt = nt + 1
				elseif fid and not zeroHealth then
					if healthyCompanions[fid] or C_Garrison.GetFollowerAutoCombatStats(fid).currentHealth ~= 0 then
						healthyCompanions[fid] = true
					else
						zeroHealth = true
					end
				end
			end
			return mid, nt, zeroHealth
		end
	end
	function U.EnumerateTentativeGroups()
		return nextTent
	end
end
do -- startQueue
	local startQueue, startQueueLength = {}, 0
	function EV:GARRISON_MISSION_STARTED(_, mid)
		if startQueue[mid] then
			startQueueLength, startQueue[mid] = startQueueLength - 1, nil
			EV("I_MISSION_QUEUE_CHANGED")
			PlaySound(44323)
		end
	end
	function EV:GARRISON_MISSION_NPC_CLOSED()
		startQueue, startQueueLength = {}, 0
	end
	local function startMissionGroup(mid, g)
		local mi = C_Garrison.GetBasicMissionInfo(mid)
		for j=1,mi and mi.followers and #mi.followers or 0 do
			for b=0,4 do
				C_Garrison.RemoveFollowerFromMission(mid, mi.followers[j], b)
			end
		end
		local ok = mi and mi.canStart
		for i=0,mi and 4 or -1 do
			ok = ok and (g[i] == nil or C_Garrison.AddFollowerToMission(mid, g[i], i))
		end
		return ok and (C_Garrison.StartMission(mid) or true) or false
	end
	local function queuePing()
		if next(startQueue) then
			C_Timer.After(0.5, queuePing)
		end
		local oc = startQueueLength
		for mid, g in pairs(startQueue) do
			if not startMissionGroup(mid, g) then
				startQueueLength, startQueue[mid] = startQueueLength-1, nil
			end
		end
		if oc ~= startQueueLength then
			EV("I_MISSION_QUEUE_CHANGED")
		end
	end
	function U.IsStartingMissions()
		return startQueueLength > 0 and startQueueLength
	end
	function U.StopStartingMissions()
		startQueue, startQueueLength = {}, 0
	end
	function U.IsMissionInStartQueue(mid)
		return startQueue[mid] ~= nil
	end
	function U.SendMissionGroup(mid, g)
		local ng, oql = {}, startQueueLength
		for i=0,4 do
			ng[i] = g[i]
			local acs = g[i] and C_Garrison.GetFollowerAutoCombatStats(g[i])
			if acs and acs.currentHealth == 0 then
				return
			end
		end
		startQueue[mid], startQueueLength = ng, oql + (startQueue[mid] and 0 or 1)
		if oql == 0 then
			queuePing()
		end
		EV("I_MISSION_QUEUE_CHANGED")
	end
end
do -- delayStart
	local delayedStart, delayTime = {}, nil
	local stickHandle, stickLast, stickNext
	local function checkStart()
		local now = GetTime()
		if delayTime and now >= delayTime then
			delayTime = nil
			for k in pairs(delayedStart) do
				U.SendTentativeGroup(k)
				delayedStart[k] = nil
			end
			EV("I_DELAYED_START_UPDATE")
		elseif delayTime then
			C_Timer.After(math.max(0.005,delayTime-now), checkStart)
		end
	end
	local function tick()
		if not (delayTime and stickNext) then
			return
		end
		local now = GetTime()
		if stickNext > now then
			C_Timer.After(math.max(0.005, stickNext-now), tick)
		else
			stickHandle, stickLast = nil
			local wp, h = PlaySoundFile(1064507)
			if wp then
				stickHandle, stickLast = h, now
			end
			stickNext = nil
		end
	end
	local function cancelTicking()
		if stickHandle and stickLast and GetTime()-stickLast < 1 then
			StopSound(stickHandle)
			stickHandle, stickNext = nil
		end
	end
	local function startTicking(now)
		cancelTicking()
		stickNext = now
		tick()
		stickNext = now+0
		C_Timer.After(0, tick)
	end
	function U.HasDelayedStartMissions()
		return not not delayTime
	end
	function U.ClearDelayedStartMissions()
		wipe(delayedStart)
		cancelTicking()
		delayTime = nil
		EV("I_DELAYED_START_UPDATE")
	end
	function U.StartMissionWithDelay(mid, g)
		local mi, now = C_Garrison.GetBasicMissionInfo(mid), GetTime()
		if mi then
			U.StoreMissionGroup(mid, g, true)
			if mi.offerEndTime and (mi.offerEndTime-now) <= 4 then
				U.SendTentativeGroup(mid)
			else
				delayedStart[mid], delayTime = true, now+0
				C_Timer.After(0, checkStart)
				startTicking(now)
				EV("I_DELAYED_START_UPDATE")
				return true
			end
		end
	end
	function U.ClearDelayedStartMission(mid)
		delayedStart[mid] = nil
		if next(delayedStart) == nil then
			delayTime = nil
			cancelTicking()
		end
		EV("I_DELAYED_START_UPDATE")
	end
	function U.RushDelayedStartMissions()
		cancelTicking()
		delayTime = GetTime()-1
		return checkStart()
	end
	function U.IsMissionStartingSoon(mid)
		return not not delayedStart[mid]
	end
	function EV:I_TENTATIVE_GROUPS_CHANGED()
		local changed = false
		for k in pairs(delayedStart) do
			if not U.MissionHasTentativeGroup(k) then
				changed, delayedStart[k] = true, nil
			end
		end
		if changed then
			if next(delayedStart) == nil then
				delayTime = nil
			end
			EV("I_DELAYED_START_UPDATE")
		end
	end
	function EV:GARRISON_MISSION_NPC_CLOSED()
		if delayTime then
			delayTime = nil
			for k in pairs(delayedStart) do
				delayedStart[k] = nil
			end
			EV("I_DELAYED_START_UPDATE")
		end
	end
end
do -- completeQueue
	local curStack, curState, curIndex
	local completionStep, lastAction, delayIndex, delayMID
	local xpTable
	local function After(t, f)
		if t == 0 then
			securecall(f)
		else
			C_Timer.After(t, f)
		end
	end
	local delayOpen, delayRoll do
		local function delay(state, f, d)
			local function delay(minDelay)
				if curState == state and curIndex == delayIndex and curStack[delayIndex].missionID == delayMID then
					local time = GetTime()
					if not minDelay and (not lastAction or (time-lastAction >= d)) then
						lastAction = GetTime()
						f(curStack[curIndex].missionID)
						After(d, delay)
					else
						After(math.max(0.1, d + lastAction - time, minDelay or 0), delay)
					end
				end
			end
			return delay
		end
		delayOpen = delay("COMPLETE", C_Garrison.MarkMissionComplete, 0.4)
		delayRoll = delay("BONUS", C_Garrison.MissionBonusRoll, 0.4)
	end
	local function delayStep()
		completionStep("GARRISON_MISSION_NPC_OPENED")
	end
	local function delayDone()
		local os = curState
		if os == "ABORT" or os == "DONE" then
			curState, curStack, curIndex, delayMID, delayIndex, xpTable = nil
			EV("I_COMPLETE_QUEUE_UPDATE", os)
		end
	end

	local function whineAboutUnexpectedState(msg, mid, suf)
		local et = msg .. ": " .. tostring(mid) .. tostring(suf or "") .. " does not fit (" .. curIndex .. ";"
		for i=1,#curStack do
			local e = curStack[i]
			et = et .. " " .. tostring(e and e.missionID or "?") .. (e and e.skipped and "S" or "") .. (e and e.failed and "F" or "")
		end
		return et .. ")"
	end
	local function addFollowerInfo(mi, followers, didWin)
		local xpGain = mi.xp or 0
		local fa = {}
		for i=1, didWin and mi.rewards and #mi.rewards or 0 do
			xpGain = xpGain + (mi.rewards[i].followerXP or 0)
		end
		for i=1,#followers do
			local fi = C_Garrison.GetFollowerMissionCompleteInfo(followers[i].followerID)
			local xp = (fi.currentXP or 0) + xpGain
			if not fi.isTroop and (fi.maxXP or 0) > 0 and xp >= fi.maxXP then
				xpTable = xpTable or C_Garrison.GetFollowerXPTable(123)
				local nl = fi.level
				while (xpTable[nl] or 0) ~= 0 and xp >= xpTable[nl] do
					nl, xp = nl + 1, xp - xpTable[nl]
				end
				fi.newLevel, fi.xpToNextLevel = nl, (xpTable[nl] or 0) ~= 0 and (xpTable[nl]-xp) or nil
			end
			fa[i] = fi
		end
		mi.followerInfo = fa
	end
	function completionStep(ev, ...)
		if not curState then return end
		local mi = curStack[curIndex]
		while mi and (mi.succeeded or mi.failed) do
			mi, curIndex = curStack[curIndex+1], curIndex + 1
		end
		if (ev == "GARRISON_MISSION_NPC_CLOSED" and mi) or not mi then
			curState = mi and "ABORT" or "DONE"
			After(... == "IMMEDIATE" and 0 or 0.1, delayDone)
		elseif curState == "NEXT" and ev == "GARRISON_MISSION_NPC_OPENED" then
			EV("I_COMPLETE_QUEUE_UPDATE", "NEXT")
			if mi.completed then
				curState, delayIndex, delayMID = "BONUS", curIndex, mi.missionID
				C_Garrison.RegenerateCombatLog(delayMID)
				delayRoll(... ~= "IMMEDIATE" and 0.2)
			else
				curState, delayIndex, delayMID = "COMPLETE", curIndex, mi.missionID
				delayOpen(... ~= "IMMEDIATE" and 0.2)
			end
		elseif curState == "COMPLETE" and ev == "GARRISON_MISSION_COMPLETE_RESPONSE" then
			local mid, cc, ok, _brOK, followers, acr = ...
			if mid ~= mi.missionID then return end
			if not (acr and acr.combatLog and #acr.combatLog > 0) then
				C_Garrison.RegenerateCombatLog(mid)
				return
			elseif cc == false and ok == false then
				local bi = C_Garrison.GetBasicMissionInfo(mid)
				if not (bi and bi.completed) then
					return
				end
				cc, ok = true, acr.winner
			end
			addFollowerInfo(mi, followers, acr.winner)
			if ok then
				curState = "BONUS"
			else
				mi.failed, curState, curIndex = cc and true or nil, "NEXT", curIndex + 1
			end
			if ok then
				delayIndex, delayMID = curIndex, mi.missionID
				delayRoll(0.2)
			else
				-- Awkward: need other GMCR handlers to finish before a certain IMCS handler runs
				C_Timer.After(0, function()
					EV("I_MISSION_COMPLETION_STEP", mid, false, mi)
				end)
				After(0.45, delayStep)
			end
		elseif curState == "BONUS" and ev == "GARRISON_MISSION_BONUS_ROLL_COMPLETE" then
			local mid, ok = ...
			if mid ~= mi.missionID then
				securecall(error, whineAboutUnexpectedState("Unexpected bonus roll completion", mid, ok and "K" or "k"), 2)
			elseif ok then
				mi.succeeded, curState, curIndex = true, "NEXT", curIndex + 1
				EV("I_MISSION_COMPLETION_STEP", mid, true, mi)
			end
		end
	end
	EV.GARRISON_MISSION_NPC_OPENED, EV.GARRISON_MISSION_NPC_CLOSED = completionStep, completionStep
	EV.GARRISON_MISSION_BONUS_ROLL_COMPLETE, EV.GARRISON_MISSION_COMPLETE_RESPONSE = completionStep, completionStep

	function U.IsCompletingMissions()
		return curState ~= nil and (#curStack-curIndex+1) or nil
	end
	function U.StartCompletingMissions()
		curStack = C_Garrison.GetCompleteMissions(123)
		curState, curIndex = "NEXT", 1
		completionStep("GARRISON_MISSION_NPC_OPENED", "IMMEDIATE")
	end
	function U.StopCompletingMissions()
		if curState then
			completionStep("GARRISON_MISSION_NPC_CLOSED", "IMMEDIATE")
		end
	end
end
function U.InitiateMissionCompletion(mid)
	local cm = C_Garrison.GetCompleteMissions(123)
	for i=1, cm and #cm or 0 do
		local ci = cm[i]
		if ci.missionID == mid or mid == "first" then
			ci.encounterIconInfo = C_Garrison.GetMissionEncounterIconInfo(ci.missionID)
			return CovenantMissionFrame:InitiateMissionCompletion(ci)
		end
	end
end

function U.GetTimeStringFromSeconds(sec, shorter, roundUp, disallowSeconds)
	local h = roundUp and math.ceil or math.floor
	if sec < 90 and not disallowSeconds then
		return "|t" .. (shorter and COOLDOWN_DURATION_SEC or INT_GENERAL_DURATION_SEC):format(sec < 0 and 0 or h(sec))
	elseif (sec < 3600*(shorter and shorter ~= 2 and 3 or 1.65) and (sec % 3600 >= 1 or sec < 3600)) then
		return "|t" .. (shorter and COOLDOWN_DURATION_MIN or INT_GENERAL_DURATION_MIN):format(h(sec/60))
	elseif sec <= 3600*72 and not shorter then
		sec = h(sec/60)*60
		local m = math.ceil(sec % 3600 / 60)
		return "|t" .. INT_GENERAL_DURATION_HOURS:format(math.floor(sec / 3600)) .. (m > 0 and " " .. INT_GENERAL_DURATION_MIN:format(m) or "")
	elseif sec <= 3600*72 then
		return "|t" .. (shorter and COOLDOWN_DURATION_HOURS or INT_GENERAL_DURATION_HOURS):format(h(sec/3600))
	else
		return "|t" .. (shorter and COOLDOWN_DURATION_DAYS or INT_GENERAL_DURATION_DAYS):format(h(sec/84600))
	end
end
function U.SetFollowerInfo(GameTooltip, info, autoCombatSpells, autoCombatantStats, _mid, boardIndex, boardMask, showHealthFooter, postStatsLine)
	local mhp, hp, atk, level
	autoCombatantStats = autoCombatantStats or info and (info.followerID and C_Garrison.GetFollowerAutoCombatStats(info.followerID) or info.autoCombatantStats)
	local aa = info.auto or info.autoCombatAutoAttack and info.autoCombatAutoAttack.autoCombatSpellID
	if info then
		level = info.level and ("|cffa8a8a8" .. UNIT_LEVEL_TEMPLATE:format(info.level)) or ""
		if info.followerID and aa == nil then
			local _, faa = C_Garrison.GetFollowerAutoCombatSpells(info.followerID, info.level or 1)
			aa = faa and faa.autoCombatSpellID
		end
	end
	if autoCombatantStats then
		mhp, hp, atk = autoCombatantStats.maxHealth, autoCombatantStats.currentHealth, autoCombatantStats.attack
	end
	
	GameTooltip:ClearLines()
	GameTooltip:AddDoubleLine(info.name, level or "")

	local atype = U.FormatTargetBlips(GetTargetMask(T.KnownSpells[aa], boardIndex, boardMask), boardMask, " ")
	if atype == "" then
		atype = aa == 11 and " " .. L"(melee)" or aa == 15 and " " .. L"(ranged)" or ""
	else
		atype = "  " .. atype
	end
	GameTooltip:AddLine("|A:ui_adv_health:20:20|a" .. (hp and BreakUpLargeNumbers(hp) or "???") .. (mhp and mhp ~= hp and ("|cffa0a0a0/|r" .. BreakUpLargeNumbers(mhp)) or "").. "  |A:ui_adv_atk:20:20|a" .. (atk and BreakUpLargeNumbers(atk) or "???") .. "|cffa8a8a8" .. atype, 1,1,1)
	if postStatsLine then
		GameTooltip:AddLine(postStatsLine)
	end
	if info and info.isMaxLevel == false and info.xp and info.levelXP and info.level and not info.isAutoTroop then
		GameTooltip:AddLine(GARRISON_FOLLOWER_TOOLTIP_XP:gsub("%%[^%%]*d", "%%s"):format(BreakUpLargeNumbers(info.levelXP - info.xp)), 0.7, 0.7, 0.7)
	end

	for i=1, autoCombatSpells and #autoCombatSpells or 0 do
		local s = autoCombatSpells[i]
		GameTooltip:AddLine(" ")
		local si = T.KnownSpells[s.autoCombatSpellID]
		local pfx = si and "" or "|TInterface/EncounterJournal/UI-EJ-WarningTextIcon:0|t "
		local cdt = (s.cooldown ~= 0 or nonPassiveZeroCD[s.autoCombatSpellID]) and (L"[CD: %dT]"):format(s.cooldown) or SPELL_PASSIVE_EFFECT
		GameTooltip:AddDoubleLine(pfx .. "|T" .. s.icon .. ":0:0:0:0:64:64:4:60:4:60|t " .. NORMAL_FONT_COLOR_CODE .. s.name, "|cffa8a8a8" .. cdt .. "|r")
		local dc, guideLine = 0.95, U.GetAbilityGuide(s.autoCombatSpellID, boardIndex, boardMask)
		local od = U.GetAbilityDescriptionOverride(s.autoCombatSpellID, atk)
		if od then
			dc, guideLine = 0.60, od .. (guideLine and "|n" .. guideLine or "")
		end
		GameTooltip:AddLine(s.description, dc, dc, dc, 1)
		if guideLine then
			GameTooltip:AddLine("|cff73ff00" .. guideLine, 0.45, 1, 0, 1)
		end
	end

	if showHealthFooter and info and info.status ~= GARRISON_FOLLOWER_ON_MISSION and autoCombatantStats and autoCombatantStats.currentHealth < autoCombatantStats.maxHealth and autoCombatantStats.minutesHealingRemaining then
		local t = " " .. U.GetTimeStringFromSeconds(autoCombatantStats.minutesHealingRemaining*60, false, true, true)
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("|cffffd926" .. CLOCK_ICON:format(255, 0.85*255, 0.15*255) .. ADVENTURES_FOLLOWER_HEAL_TIME:format(t):gsub("  +", " "), 1, 0.85, 0.15, 1)
	end

	GameTooltip:Show()
end
function U.AddCombatantSimInfo(GameTooltip, boardIndex, sim)
	if not (sim and sim.res and sim.res.isFinished) then return end
	if not sim.board[boardIndex] then return end
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine("|TInterface/Icons/INV_Misc_Book_01:0:0:0:0:64:64:4:60:4:60|t " .. ITEM_QUALITY_COLORS[5].hex .. L"Cursed Adventurer's Guide")
	local lo, hi, dlo, dhi = sim.res.min[boardIndex], sim.res.max[boardIndex], sim.res.min[19+boardIndex], sim.res.max[19+boardIndex]
	GameTooltip:AddDoubleLine(RAID_HEALTH_TEXT_HEALTH .. HEADER_COLON, (lo ~= hi and lo .. " - " .. hi or lo) .. " / " .. sim.board[boardIndex].maxHP, 1,1,1, 1,1,1)
	if dlo ~= math.huge then
		local h = (L"Turns survived: %s"):format(""):gsub("%s+$", "")
		local hs = ""
		if hi > 0 then
			hs = " - "
		elseif dhi ~= dlo then
			hs = " - " .. (dhi-1)
		end
		GameTooltip:AddDoubleLine(h, (dlo-1) .. hs, 1,1,1, 1,1,1)
	end
end
function U.FormatTargetBlips(tm, bm, prefix, ac, padHeight)
	local isForked = tm >= 2^18
	tm = tm - (isForked and 2^18 or 0)
	ac = ac and ac .. "|t" or (isForked and "200:50:255|t" or "120:255:0|t")
	local r, xs, bw = "", 0, GetBlipWidth()
	local yd = bw/2
	if tm % 32 > 0 then
		local xo = 0
		for i=2,4 do
			local t, p = tm % 2^(i+1) >= 2^i, bm % 2^(i+1) >= 2^i
			r = r .. "|TInterface/Minimap/PartyRaidBlipsV2:8:8:" .. (xo .. ":" .. yd).. ":64:32:0:20:0:20:" .. (t and ac or p and "160:160:160|t" or "40:40:40|t")
			if i < 4 then
				i, xo = i - 2, xo - bw/2
				t, p = tm % 2^(i+1) >= 2^i, bm % 2^(i+1) >= 2^i
				r = r .. "|TInterface/Minimap/PartyRaidBlipsV2:8:8:" .. (xo .. ":" .. -yd).. ":64:32:0:20:0:20:" .. (t and ac or p and "160:160:160|t" or "40:40:40|t")
				xo = xo - bw/2
			end
		end
		xs = -bw
	end
	if tm >= 32 then
		local xo = xs
		for i=5,8 do
			local t, p = tm % 2^(i+1) >= 2^i, bm % 2^(i+1) >= 2^i
			r = r .. "|TInterface/Minimap/PartyRaidBlipsV2:8:8:" .. xo .. ":" .. -yd .. ":64:32:0:20:0:20:" .. (t and ac or p and "160:160:160|t" or "40:40:40|t")
			i, xo = i + 4, xo - bw
			t, p = tm % 2^(i+1) >= 2^i, bm % 2^(i+1) >= 2^i
			r = r .. "|TInterface/Minimap/PartyRaidBlipsV2:8:8:" .. xo .. ":" .. yd  .. ":64:32:0:20:0:20:" .. (t and ac or p and "160:160:160|t" or "40:40:40|t")
		end
	end
	if prefix and r ~= "" then
		r = prefix .. r
	end
	if r ~= "" and padHeight ~= false then
		r = r .. "|TInterface/Minimap/PartyRaidBlipsV2:19:1:0:0:64:32:62:63:0:2|t"
	end
	return r
end
function U.GetAbilityGuide(spellID, boardIndex, boardMask, padHeight)
	local si, guideLine = T.KnownSpells[spellID]
	if not (si and si.h ~= "nop") then
		return
	end
	if si.firstTurn then
		padHeight = true
	end
	local tm = GetTargetMask(si, boardIndex, boardMask)
	if tm > 0 then
		local b = U.FormatTargetBlips(tm, boardMask, nil, nil, padHeight)
		if b and b ~= "" then
			guideLine = L"Targets:" .. " " .. b
		end
	end
	if si.hp or si.dp or si.healPerc or si.dh then
		local p = FormatSpellPulse(si)
		if p then
			guideLine = L"Ticks:" .. " " .. p .. (guideLine and "    " .. guideLine or "")
		end
	end
	if si.firstTurn then
		guideLine = (L"First cast during turn %d."):format(si.firstTurn) .. (guideLine and "|n" .. guideLine or "")
	end
	return guideLine
end
function U.GetAbilityDescriptionOverride(spellID, atk, ms)
	local si = T.KnownSpells[spellID]
	if si and si.h == "nop" then
		return L"It does nothing."
	end
	local od = overdesc[spellID]
	if type(od) == "table" then
		od = FormatAbilityDescriptionOverride(si, od, atk, ms)
	end
	return od
end

function U.GetInProgressGroup(followers, into)
	into = type(into) == "table" and wipe(into) or {}
	for i=1, #followers do
		local fid = followers[i]
		local ii = C_Garrison.GetFollowerMissionCompleteInfo(fid)
		into[ii and ii.boardIndex or -1] = fid
	end
	into[-1] = nil
	return into
end

function U.GetNumMissingTorghastCompanions(followers)
	local c = 0
	for i=1,#followers do
		local fid = followers[i].garrFollowerID
		if torghastCompanionIDs[fid] then
			c = c + 1
		end
	end
	return torghastCompanions - c
end

function U.FollowerIsFavorite(id)
	local f = SPC.Favorites
	return f and f[id] or false
end
function U.FollowerSetFavorite(id, nv)
	local f = SPC.Favorites or {}
	f[id] = nv or nil
	SPC.Favorites = next(f) ~= nil and f or nil
end

function U.GetMissionEnemies(mid, skipEnv)
	local en = C_Garrison.GetMissionDeploymentInfo(mid).enemies
	for i=1,#en do
		local eni = en[i]
		local a = eni.autoCombatAutoAttack
		eni.auto, eni.autoCombatAutoAttack = a and a.autoCombatSpellID
	end
	local eei = skipEnv ~= true and C_Garrison.GetAutoMissionEnvironmentEffect(mid)
	return en, eei and eei.autoCombatSpellInfo or nil
end

function U.GetPoolTroopBase(idOnly)
	local pool, troops = {}, C_Garrison.GetAutoTroops(123)
	if troops[1].garrFollowerID > troops[2].garrFollowerID then
		troops[1], troops[2] = troops[2], troops[1]
	end
	for i=1,#troops do
		local fi = troops[i]
		if idOnly then
			pool[#pool+1] = fi.followerID
		else
			local spells, auto = C_Garrison.GetFollowerAutoCombatSpells(fi.followerID, fi.level)
			pool[#pool+1] = {
				stats=C_Garrison.GetFollowerAutoCombatStats(fi.followerID),
				spells=spells,
				auto=auto.autoCombatSpellID,
				id=fi.followerID,
				oid=fi.garrFollowerID,
				troop=true,
			}
		end
	end
	return pool
end
function U.GetPoolCompanion(fid, rewardXP, idOnly)
	if idOnly then return fid end
	local ii, willLevel = C_Garrison.GetFollowerInfo(fid or 0), nil
	if not ii then
		return
	elseif rewardXP then
		willLevel = not ii.isMaxLevel and ii.xp and ii.levelXP and (ii.xp + rewardXP) >= ii.levelXP
	end
	local acs = C_Garrison.GetFollowerAutoCombatStats(fid)
	local spells, aa = C_Garrison.GetFollowerAutoCombatSpells(fid, ii.level)
	return {id=ii.followerID, oid=ii.garrFollowerID, stats=acs, auto=aa.autoCombatSpellID, spells=spells, willLevel=willLevel}
end
do -- U.GetShuffleGroup(pool, gid)
	local pt = {}
	function U.GetShuffleGroup(pool, gid, skipMask)
		local g, ntroop, wmask, p, adv = {}, 0, 0
		for i=0,4 do
			pt[i] = i
		end
		for i=0, #pool-3 do
			p, adv = gid % (5-i), pool[3+i]
			p, gid = i+p, (gid - p) / (5-i)
			p, pt[p] = pt[p], pt[i]
			g[p], pt[i], wmask = adv, p, wmask + ((skipMask or adv.willLevel) and 0 or 2^p)
		end
		for i=#pool-2, 4 do
			p = gid % 3
			gid, adv = (gid - p) / 3, pool[p]
			if adv then
				g[pt[i]], ntroop = adv, ntroop + 1
			end
		end
		return g, ntroop, wmask
	end
end
do -- U.GetPartyID(b0, b1, b2, b3, b4)
	local GetTroopMap do
		local cco, tm
		function GetTroopMap()
			local ac = C_Covenants.GetActiveCovenantID()
			if cco ~= ac or tm == nil then
				local t = C_Garrison.GetAutoTroops(123)
				local t1, t2 = t[1].garrFollowerID, t[2].garrFollowerID
				cco, tm = ac, {[t1 < t2 and t1 or t2]=1, [t1 < t2 and t2 or t1]=2, [0]=0}
			end
			return tm, ac-1
		end
	end
	local sc = {}
	function U.GetPartyID(b0, b1, b2, b3, b4)
		local tm, aco = GetTroopMap()
		local ret, rmul, fret, nc, cl = 0, 1, 0, 0, 0
		for i=0,9 do sc[i] = i % 5 end
		for r=0,4 do
			local ch, ci = math.huge
			for i=0, 4 do
				local b = select(1+i, b0, b1, b2, b3, b4)
				if b and tm[b] == nil and b > cl and b < ch then
					ch, ci = b, sc[5+i]
				end
			end
			if ci == nil then break end
			sc[ci], sc[5+sc[r]] = sc[r], ci
			nc, cl, ret, rmul = nc + 1, ch, ret + rmul*(ci-r), rmul * (5-r)
			fret = fret and ch > 1200 and ch < 1456 and (fret*256 + ch-1200)
		end
		for i=nc,4 do
			i = select(1+sc[i], b0, b1, b2, b3, b4)
			ret, rmul = ret + rmul*tm[i or 0], rmul * 3
		end
		return ret, fret and aco >= 0 and aco < 4 and ((fret*1024 + ret)*8+aco*2) or nil
	end
	function U.GetPartyIDC(fgid)
		return (fgid - (fgid % 8192))/8192
	end
	function U.GetPartyIDS(fgid)
		return (fgid % 8192 - fgid % 8)/8
	end
end
do -- Saved Groups
	do
		local gf, co
		function U.GetFollowerIDByID(fid)
			local ac = C_Covenants.GetActiveCovenantID()
			if gf == nil or ac ~= co or gf[fid] == nil then
				gf, co = {}, ac
				for j=1,2 do
					local fa = C_Garrison[j == 1 and "GetFollowers" or "GetAutoTroops"](123)
					for i=1,#fa do
						gf[fa[i].garrFollowerID or 0] = fa[i].followerID
					end
				end
				gf[0] = nil
			end
			return gf[fid]
		end
	end
	function U.SaveMissionGroup(mid, b0, b1, b2, b3, b4)
		local ac = C_Covenants.GetActiveCovenantID()
		if (ac or 0) < 1 or ac > 4 then return end
		local _, fgid = U.GetPartyID(b0, b1, b2, b3, b4)
		if not fgid then return end
		local fr = U.GetPartyIDC(fgid)
		local ug = acqTable(SPC, "UsedGroups", mid*4+ac-1)
		local p, i = fgid, 1 repeat
			ug[i], p, i = p, ug[i], i+1
		until not p or U.GetPartyIDC(p) == fr or i == 10
	end
	function U.GetSavedGroupPool(fgid, rewardXP, idOnly)
		local ac = (C_Covenants.GetActiveCovenantID()-1)*2
		if ac ~= fgid % 8 then return end
		local pool = U.GetPoolTroopBase(idOnly)
		local fg, nc, r = U.GetPartyIDC(fgid), 0
		repeat
			r = fg % 256
			fg, pool[#pool+1], nc = (fg - r)/256, U.GetPoolCompanion(U.GetFollowerIDByID(r + 1200), rewardXP, idOnly), nc + 1
		until fg == 0
		return #pool == nc+2 and pool
	end
	function U.GetSavedGroupCompanions(fgid)
		local fg, r, c1,c2,c3,c4,c5 = U.GetPartyIDC(fgid)
		repeat
			r = fg % 256
			fg, c1,c2,c3,c4,c5 = (fg - r)/256, U.GetFollowerIDByID(r+1200), c1,c2,c3,c4
		until fg == 0
		return c1, c2, c3, c4, c5
	end
	function U.GetSavedGroup(fgid, rewardXP, idOnly)
		local pool = U.GetSavedGroupPool(fgid, rewardXP, idOnly)
		return pool and U.GetShuffleGroup(pool, U.GetPartyIDS(fgid))
	end
	local function HaveAllCompanions(fgid)
		local fg, r = U.GetPartyIDC(fgid)
		repeat
			r = fg % 256
			if not U.GetFollowerIDByID(r+1200) then break end
			fg = (fg - r)/256
		until fg == 0
		return fg == 0
	end
	function U.HaveSuggestedGroups(mid)
		local k = mid*4 + C_Covenants.GetActiveCovenantID() - 1
		if HAVE_CANNED_GROUPS[k] or (type(SPC.UsedGroups) == "table" and type(SPC.UsedGroups[k]) == "table" and #SPC.UsedGroups[k] > 0) then
			return true
		end
		local a = CANNED_GROUPS and CANNED_GROUPS[k]
		for i=1,a and #a or 0 do
			if HaveAllCompanions(a[i]) then
				HAVE_CANNED_GROUPS[k] = true
				return true
			end
		end
	end

	local tempGroupPref = {}
	local cmpGroupHint do
		local info, prefSaved, pref
		local function _cmpGroupHint(a,b)
			local ia, ib = info[a], info[b]
			local ac, bc = ia.rank, ib.rank
			if ac and bc then
				return ac < bc
			elseif ac or bc then
				return not bc
			end
			if prefSaved then
				ac, bc = not ia.saved, not ib.saved
				if ac ~= bc then
					return bc
				end
			end
			if pref then
				ac, bc = pref[a] or 0, pref[b] or 0
				if ac ~= bc then
					return ac > bc
				end
			end
			ac, bc = ia.readyAt, ib.readyAt
			if ac == bc then
			elseif ac and bc then
				return ac < bc
			elseif ac or bc then
				return not ac
			end
			ac, bc = ia.numTent, ib.numTent
			if ac ~= bc then
				return ac < bc
			end
			ac, bc = ia.useScore, ib.useScore
			if ac and bc and ac ~= bc then
				return ac < bc
			end
			ac, bc = ia.numTroop, ib.numTroop
			if ac ~= bc then
				return ac < bc
			end
			ac, bc = ia.numComps, ib.numComps
			if ac ~= bc then
				return ac < bc
			end
			ac, bc = ia.saved, ib.saved
			if ac and bc then
				return ac < bc
			elseif ac or bc then
				return not bc
			end
			return ia.uq < ib.uq
		end
		function cmpGroupHint(it, ps, prefs)
			info, prefSaved, pref = it, ps, prefs
			return _cmpGroupHint
		end
	end
	local function updateSortProps(uc, i, r)
		local k = r.ord[i]
		r.info[k].rank = i
		for _,v in pairs(r.groups[k]) do
			if not v.troop then
				uc[v.id] = (uc[v.id] or 0) + 1
			end
		end
		for j=i+1, #r.ord do
			local k2, us = r.ord[j], 0
			for _,v in pairs(r.groups[k2]) do
				if not v.troop then
					us = us + (uc[v.id] or 0)^2
				end
			end
			r.info[k2].useScore = us
		end
	end
	local function addGroup(r, uh, fgid, now, saved)
		local fg = U.GetPartyIDC(fgid)
		local g = uh[fg] == nil and U.GetSavedGroup(fgid)
		if g then
			local ntent, ntroop, ncomp, maxMTL = 0, 0, 0, nil
			for _,v in pairs(g) do
				if v.troop then
					ntroop = ntroop + 1
				else
					local mtl = C_Garrison.GetFollowerMissionTimeLeftSeconds(v.id)
					maxMTL = maxMTL and mtl and mtl > maxMTL and mtl or maxMTL or mtl
					ntent, ncomp = ntent + (U.FollowerHasTentativeGroup(v.id) and 1 or 0), ncomp + 1
				end
			end
			uh[fg], r.ord[#r.ord+1], r.groups[fgid] = 1, fgid, g
			r.info[fgid] = {readyAt=maxMTL and maxMTL+now or nil, numTent=ntent, numTroop=ntroop, numComps=ncomp, saved=saved, uq=#r.ord}
		end
	end
	function U.SetSuggestedGroupTempPreference(mid, fgid, pref)
		local gp = tempGroupPref[mid]
		if gp == nil then
			gp = {}
			tempGroupPref[mid] = gp
		end
		gp[fgid] = pref == nil and 0 or pref and 1 or -1
	end
	function U.GetSuggestedGroups(mid, limit, ownPrefLimit)
		local r, uh, mk = {ord={}, groups={}, info={}}, {}, mid*4 + C_Covenants.GetActiveCovenantID() - 1
		local now, t = GetTime(), type(SPC.UsedGroups) == "table" and SPC.UsedGroups[mk]
		for k=1,2 do
			for i=1,t and #t or 0 do
				addGroup(r, uh, t[i], now, k == 1 and i or nil)
			end
			t = CANNED_GROUPS and CANNED_GROUPS[mk]
		end
		local uc, tgpref = {}, tempGroupPref[mid]
		for i=1,math.min(#r.ord, limit or #r.ord) do
			table.sort(r.ord, cmpGroupHint(r.info, ownPrefLimit and ownPrefLimit >= i, tgpref))
			updateSortProps(uc, i, r)
		end
		cmpGroupHint()

		for i=#r.ord, (limit or #r.ord)+1, -1 do
			local k = r.ord[i]
			r.ord[i], r.groups[k], r.info[k] = nil
		end
		return r
	end
end

do
	local msc, runQueue, runQueueInfo = {}, {}, setmetatable({}, {__mode="k"})
	local function getMissionCache(mid)
		local cmi, bmi = msc[mid], C_Garrison.GetBasicMissionInfo(mid)
		if not bmi then
			msc[mid] = nil
			return
		elseif not (cmi and bmi and bmi.missionScalar == cmi.scalar) then
			local en, es = U.GetMissionEnemies(mid)
			cmi = {scalar=bmi.missionScalar, enemies=en, espell=es, h={}}
			msc[mid] = cmi
		end
		return cmi
	end
	local function isDone(res)
		return res.isFinished or (res.hadLosses and res.hadWins)
	end
	local function getPartyHealth(g)
		local h, m = 0, 0
		for i=0,4 do
			local v = g[i]
			if v then
				h, m = h + v.stats.currentHealth, m + v.stats.maxHealth
			end
		end
		return h, m
	end
	function U.GetMissionPrediction(mid, party, fgid)
		local cmi = getMissionCache(mid)
		local cp, oh, ocp = cmi[fgid], cmi.h[fgid]
		if party then
			local ch, mh = getPartyHealth(party)
			if cp then
				if oh.maxHealth ~= mh then
					cp = nil
				elseif oh.curHealth ~= ch then
					cp, ocp = nil, isDone(cp.res) and cp or nil
				end
			end
			if not cp then
				cp = T.VSim:New(party, cmi.enemies, cmi.espell, mid, cmi.scalar)
				cp.dropForks = true
				cmi[fgid], cmi.h[fgid] = cp, {o=ocp, maxHealth=mh, curHealth=ch}
			end
		end
		if cp and not isDone(cp.res) then
			if not runQueueInfo[cp] then
				runQueue[#runQueue+1] = cp
				runQueueInfo[cp] = {mid=mid, fgid=fgid}
				EV("I_MPQ_ITEM_ADDED")
			end
			ocp = ocp or cmi.h[fgid].o
		else
			ocp = nil
		end
		if ocp then
			return ocp.res, ocp, false
		end
		return cp.res, cp, true
	end

	local rqdeadline
	local function rqinterrupt(root)
		return debugprofilestop() > rqdeadline or (root.res.hadLosses and root.res.hadWins)
	end
	function U.FlushMissionPredictionQueue()
		if next(runQueue) ~= nil then
			runQueue = {}
			wipe(runQueueInfo)
		end
	end
	function U.RunMissionPredictionQueue(ms)
		rqdeadline = debugprofilestop() + (ms or 5)
		local s = runQueue[1]
		while s and debugprofilestop() <= rqdeadline do
			s:Run(rqinterrupt)
			if isDone(s.res) then
				local rqi = runQueueInfo[s]
				local wasGood = s.res.hadWins and not s.res.hadLosses or false
				s, runQueue[s], runQueueInfo[s] = runQueue[2], nil, nil
				for i=1,#runQueue do
					runQueue[i] = runQueue[i+1]
				end
				U.SetSuggestedGroupTempPreference(rqi.mid, rqi.fgid, wasGood)
				EV("I_MPQ_ITEM_FINISHED", rqi.mid, rqi.fgid)
			end
		end
		return s == nil
	end
	
	function EV:GARRISON_MISSION_NPC_CLOSED()
		if next(msc) ~= nil then
			msc, runQueue = {}, {}
			wipe(runQueueInfo)
		end
	end
end

function U.GetShiftedCurrencyValue(id, q)
	if id == 1889 and q and C_Covenants.GetActiveCovenantID() == SPC.ccsCoven then
		local s = SPC.ccsDelta
		q = q - (type(s) == "number" and s <= q and s or 0)
	end
	return q
end
function U.SetCurrencyValueShiftTarget(id, s)
	local c, co = C_CurrencyInfo.GetCurrencyInfo(id), C_Covenants.GetActiveCovenantID()
	if id ~= 1889 or not c then return end
	if SPC.ccsCoven ~= co then
		SPC.ccsLV, SPC.ccsLH = nil, nil
	end
	SPC.ccsCoven, SPC.ccsDelta = co, s and (c.quantity-s) or 0
	EV("I_UPDATE_CURRENCY_SHIFT", id)
end
function U.ObserveMissionShift(t, q)
	local c = C_Covenants.GetActiveCovenantID()
	local b, l, h = math.ceil((t-3)/4), 0, 0
	if b > 0 then
		l, h = (b-1)*4, b*4 - (b == 5 and 0 or 1)
	end
	if (q or h) <= h then return end
	if b == 0 or ((SPC.ccsLV or -5) == (q-1) and (SPC.ccsLH or 10) < l and SPC.ccsCoven == c) then
		SPC.ccsCoven, SPC.ccsDelta = c, q-l
		EV("I_UPDATE_CURRENCY_SHIFT", 1889)
	elseif U.GetShiftedCurrencyValue(1889, q) > h then
		SPC.ccsCoven, SPC.ccsDelta = c, nil
	end
	SPC.ccsLV, SPC.ccsLH = q, h
end
function EV:I_OBSERVE_AVAIL_MISSIONS(ma)
	for i=1,#ma do
		local t = MS_TIER[ma[i].missionID-2173]
		if t then
			local cv = C_CurrencyInfo.GetCurrencyInfo(1889)
			U.ObserveMissionShift(t, cv and cv.quantity)
			break
		end
	end
end

CANNED_GROUPS = {
[8688]={1173184, 476864, 583360, 624680, 1025720, 1050296, 1157160, 493240, 470104, 1058848, 173760, 607968, 485016, 181944, 190016, 549864, 557704, 566928, 573968, 590832, 599696, 616080, 1164264},
[8689]={165482, 411250, 68226, 84650, 132722, 116338, 140874, 1082994, 468506, 1025562, 1190490, 75370, 108066, 123402, 420434, 427514, 436818, 442930, 453210, 1092186},
[8736]={1173176, 477976, 1059048, 1049816, 607768, 470144, 494720, 617240, 552064, 1166464, 183064, 576280, 1024160, 484928, 558656, 566848, 583232, 591424, 599616, 174152},
[8737]={83922, 115970, 1082626, 142266, 66418, 1027202, 1191042, 167042, 75010, 419074, 1197434, 468186, 1091698, 125242, 411962, 444730, 134154, 437258, 1207090, 109722},
[8740]={300372032, 300945472, 1173544, 478104, 1050664, 1027208, 470152, 608656, 172920, 182112, 189304, 484216, 492408, 549872, 557944, 574328},
[8741]={140914, 411250, 1197682, 165450, 124490, 67194, 1189490, 132722, 443978, 468554, 117498, 1084154, 74298, 83410, 109106, 419282, 427474, 434746},
[8743]={273484382, 218621990, 218613974, 231540822, 218605638, 275581014, 286068294, 837198, 878158, 894582, 1025614, 1107534, 829006, 467518, 819774, 844470, 860734, 885430, 1098302, 910966},
[8744]={1173120, 478200, 1059152, 609392, 625736, 1050960, 173656, 181848, 190040, 468568, 484952, 493144, 1163720, 584056, 1157496, 549400, 558320, 566552, 574704, 591088},
[8745]={306325786, 306260250, 304253026, 117786, 1083090, 67162, 83546, 132698, 411226, 435922, 452306, 468570, 1090674, 124106, 427210, 107762, 419058, 443634, 1024938, 1205490},
[8747]={853598, 518246, 1116262, 509654, 829502, 1074902, 468694, 501342, 820950, 837214, 845526, 861910, 877814, 885758, 894198, 902510, 1065462, 1025022, 1098998, 1107190},
[8752]={300372032, 1172456, 478336, 607928, 493120, 1050176, 616120, 575040, 583232, 599656, 484968, 1058488, 181984, 1025600, 550584, 1164904},
[8753]={67138, 75330, 116290, 1082946, 141226, 420994, 1199234, 1191042, 166922, 411722, 445450, 1091658, 1027082, 1206946, 435778, 468546},
[8754]={1043588, 699524, 1133700, 527492, 631788, 469628, 534084, 640580, 656964, 665156, 673708, 689732, 541556, 680820, 721780, 1024524, 648172, 705516, 714284, 1032716},
[8755]={72700725566, 59278952406, 72709113774, 70561630286, 59274733550, 72707017022, 852494, 902862, 518102, 1107526, 509566, 468710, 1066686, 820966, 1099694, 501318, 1114638, 837230, 862126},
[8756]={1172464, 609016, 470152, 494360, 617200, 1051776, 600096, 183064, 551704, 576288, 584480, 1166104, 173656, 624216, 1156696, 486168, 568048, 1026840, 1058416, 191224},
[8757]={78418872210, 78662215802, 79226349690, 116650, 1083354, 75730, 419794, 468586, 411242, 436178, 443970, 1188402, 84666, 133818, 165162, 107418, 123402, 426546, 451482, 1024522},
[8759]={853582, 829046, 509550, 1074798, 902766, 518246, 1117342, 1067110, 467510, 1098294, 1106486, 820846, 501038, 862230, 845886, 870502, 894102, 836110, 885262, 877110},
[8760]={77068718064, 77070815216, 76894367752, 77043552240, 76917723120, 77041455088, 1174384, 469744, 494320, 551664, 576240, 584432, 617560, 486128, 601176, 609376},
[8761]={306253282, 116714, 75738, 141266, 1083370, 83922, 468586, 419794, 411210, 444010, 1205866, 1191066, 1091538, 108146, 124482, 165442},
[8762]={525892, 543716, 1042468, 632428, 665156, 1124268, 1133540, 690932, 724060, 699364, 1027044, 469988, 673348, 656964, 714308, 1033796, 639980, 680940, 1139332, 534084},
[8763]={853622, 501366, 510998, 904230, 1076206, 829398, 468950, 1100094, 821206, 1107926, 516662, 1114806, 837590, 862174, 886742, 894942},
[8764]={1174664, 271585344, 271010304, 121825960, 298855928, 298846776, 298273440, 271028288, 298348608, 298289704, 1050192, 494680},
[8765]={279064698, 276967626, 35719218, 42012314, 304154874, 1199258, 141250, 1189506, 165482},
[8766]={632868, 526972, 1043244, 699484, 534084, 665156, 673348, 689732, 1025660, 1033796, 1123908, 1132100, 468548, 542276, 649252, 657020},
[8767]={218605614, 218613950, 231540902, 229443622, 218622094, 273483894, 286066734, 218933286, 273524854, 286279966, 275630254, 231508134, 517726, 1115782, 501334, 509526},
[8768]={1173480, 298281728, 75970383728, 69416226976, 76504715392, 76531978280, 69405421696, 76498309096, 69416202400, 75824820200, 68843401344, 75967705064, 476792, 300074304, 157765760, 149073936},
[8769]={78418881154, 307276082, 306351650, 306654754, 306301234, 306630178, 307211810, 306309426, 307267890, 279063114, 304221730, 104925458, 107022866, 304171290},
[8770]={1043612, 527028, 1133356, 534628, 665700, 699180, 1141916, 1124452, 1034340, 543900, 469804, 632452, 715564, 1025668, 722676, 640756, 649196, 657028, 673484},
[8771]={273484086, 286066870, 218605910, 218623494, 225249462, 281873926, 229443766, 218613894, 286279990, 212314206, 222816598, 284018974, 517846, 1115862, 903254, 510038},
[8772]={300371656, 300945472, 300363360, 300920416, 300379848, 300387936, 301060160, 300068552, 300478072, 69412015616, 75967721544, 76385062672, 40959954432},
[8773]={20137526756642, 20143975507674, 20076860343586, 20095107671114, 20143967110098, 20144210437498, 20092962284538, 20133225505866, 77953404482, 71439559402, 77965944986, 77879922146},
[8774]={527012, 666356, 699484, 1043588, 633948, 1141852, 543836, 1133660, 1125508, 469788, 1035396, 1027204, 658588, 683140, 535708},
[8775]={59274422558, 55967205446, 59274415510, 853622, 218606126, 223152246, 229444190, 227346574, 262998158, 273148022, 275794102, 286320822, 286312990, 273098998},
[8780]={300372032, 1173144, 470104, 494680, 552024, 584800, 486496, 1051736, 609416, 616120, 601176, 568448, 183024, 575208, 1166424, 1059408},
[8781]={67178, 115250, 1081906, 140794, 75730, 419434, 1092538, 1197682, 468586, 1191042, 410162, 435818, 1204786, 84970, 134122, 442930},
[8782]={527492, 287838284, 170397772, 631788, 535524, 542276, 640940, 690092, 699004, 722540, 1025964, 1042348, 467828, 656244, 672388, 680820, 1130780, 647812, 705084, 713348},
[8783]={59274405766, 55965099950, 853542, 902902, 1099382, 517750, 501718, 1066614, 829166, 1073718, 467510, 1114806, 861934, 845550, 819766, 1106486},
[8784]={77041455200, 77043552440, 1173536, 485416, 1051384, 476856, 1058848, 1157152, 190096, 608248, 1166272, 174792, 467592, 492168, 550912, 557704},
[8785]={165450, 1190570, 1091098, 116298, 140826, 1083314, 1198674, 67106, 82850, 108026, 123442, 132002, 410530, 426914, 442930, 468474},
[8786]={470108, 525900, 534092, 542756, 632396, 640708, 657444, 665164, 682020, 689740, 698044, 722868, 674076, 706964, 715276, 1024644, 648060, 1032724, 1040916, 1122828},
[8787]={72751057094, 73245986126, 70024761134, 70016371006, 518710, 501326, 837238, 879278, 1026734, 1100422, 1107574, 894574, 828998, 509510, 1075798, 467510, 819766, 844342, 860726, 886030},
[8788]={300371560, 77069299496, 77070831416, 77041446696, 77042003768, 77043699512, 77070823224, 77068431144, 609368, 600816, 183024, 551664, 616000, 575088, 583280, 173680, 469792, 558704, 566848, 591544},
[8789]={116330, 1082986, 140906, 68218, 411722, 444490, 75370, 1189842, 124882, 165490, 83522, 132714, 419394, 1199002, 467626, 436026, 1206074, 1091178, 108386, 427874},
[8790]={178786380, 164106348, 264769644, 178925636, 134688844, 170397804, 262672452, 533484, 543116, 631428, 690788, 1041388, 1122468, 1130780, 647692, 655884, 674052, 706732, 1138972, 680820},
[8791]={218605766, 218622574, 273484022, 231542334, 281873982, 829038, 509550, 1074798, 468590, 820846, 1107566, 1116006, 836110, 860726, 885302, 893494, 844342, 877110, 1024566, 870478},
[8792]={300370720, 300067616, 301050656, 300378912, 300083880, 300486752, 300503136, 300478560, 271011424, 271159488, 1049624, 469072, 493648, 550992, 575568, 559184, 1026128, 182352},
[8793]={1092626, 68618, 132322, 85090, 141954, 76418, 117410, 1206914, 1190530, 1198722, 109186, 427954, 166530, 453250, 412650, 420530},
[8794]={525540, 1041988, 666236, 640628, 673396, 632396, 534132, 689780, 1123908, 542284, 1033796, 1140300, 722164, 1131020, 648436, 705780, 467468, 655916, 680492, 696876},
[8795]={281872550, 218949702, 218607054, 218615734, 231540822, 218622022, 229445214, 225249446, 1116990, 1075846, 1066638, 830118, 469638, 821894, 1107598, 870030},
[8809]={1091186, 84650, 1197682, 142354, 116298, 1082954, 66058, 74298, 131602, 410130, 418362, 434746, 106666, 123050, 164010, 426154, 442538, 450730, 467114, 1024170},
[8811]={852502, 501326, 518830, 895662, 1067694, 1116846, 1100462, 829046, 509878, 1073726, 467518, 819774, 835798, 843950, 860614, 876758, 885190, 1024214, 1106094, 901646},
[8812]={1174624, 609376, 477576, 175200, 183024, 469024, 486128, 493600, 550944, 568408, 575520, 583712, 1058088, 189976, 623552, 1049416, 1156032, 558056, 590824, 599016},
[8813]={140874, 67138, 83490, 132642, 75378, 411210, 468546, 1025602, 1091178, 1189442, 1205834, 1197642, 115210, 1082906, 107986, 123402, 164362, 419074, 426506, 434738},
[8815]={853622, 509910, 1075158, 829166, 516662, 1099262, 468590, 501318, 820846, 837230, 845782, 886382, 1065566, 1106526, 1116518, 860726, 877110, 893454, 901686, 1024526},
[8816]={300370112, 301050656, 300518176, 300944184, 300454080, 300083904, 300501792, 300486848, 69378158808, 69380559032, 1050728, 1157224, 485440, 191224, 469096, 493600, 1026152, 583760},
[8817]={279062690, 33640002, 304220682, 308366818, 115477986, 42085978, 279365786, 279333026, 35778106, 304517034, 109161954, 18942114, 166562, 1198722, 76458, 67154},
[8818]={526012, 665164, 632508, 1123908, 1033964, 1043620, 534252, 698044, 468548, 641660, 656964, 673348, 542756, 681660, 689764, 706548},
[8819]={281874150, 286068454, 218607174, 225251326, 231541526, 854726, 1117350, 502470, 517774, 1100966, 903870, 1066598, 510646, 830134, 1108614},
[8820]={300369152, 77069291224, 77041602296, 1172104, 592632, 476864, 1051384, 1166432, 1157760, 1059408, 468312, 492168, 550472, 566856, 575048, 583240, 616008},
[8821]={140914, 1189850, 165450, 134162, 1198762, 83930, 1083354, 116458, 1091586, 66466, 123810, 411210, 420882, 436146, 468594, 1025650},
[8822]={73713322588, 534084, 690812, 697924, 1026684, 1041988, 1132100, 542276, 658044, 715388, 665156, 723004, 468332, 673132, 681324, 1033580, 640340, 647812, 705156, 1139260},
[8823]={852542, 517750, 1066614, 1099742, 501366, 862174, 894942, 1115766, 845790, 878558, 902182, 829046, 509558, 1075246, 467518, 819774, 885310, 1024574, 1106494},
[8824]={300370112, 1173144, 1049576, 609008, 616120, 492520, 599736, 1157160, 468664, 181944, 550584, 575160, 583352, 1164984, 1058456, 485048},
[8825]={116330, 140874, 67138, 1084066, 125962, 166562, 445450, 1190922, 75338, 419442, 1197642, 468554, 411202, 436898, 1205874, 1091138},
[8826]={525892, 535644, 632508, 665276, 722980, 1041996, 1132580, 542756, 657444, 714788, 1025724, 690212, 467948, 697684, 640580, 648772, 673596, 682860, 706556, 1123996},
[8827]={70024759214, 59274405766, 59274422158, 853542, 509558, 1099382, 1115766, 870358, 1074806, 838678, 879278, 829038, 468598, 820814, 1107534, 861814},
[8828]={300371712, 1172464, 1051376, 478336, 1026800, 1166424, 486496, 1158240, 470104, 625760, 609008, 494720, 617240, 183424, 552064, 576640, 584832, 600856},
[8829]={1189842, 165482, 67178, 468586, 83570, 132722, 124522, 411242, 444010, 116290, 1082946, 140874, 1090458, 75330, 419394, 1198034, 435778},
[8830]={1125476, 527452, 267006028, 178786380, 264769604, 170397292, 178925644, 176689220, 632628, 1025004, 1131500, 468548, 533004, 541196, 639620, 649612, 655924, 672388, 680580, 705044},
[8831]={852502, 468590, 1099382, 1107566, 517990, 501358, 510990, 837230, 896022, 1115766, 1066606, 1025646, 829358, 1074758, 902766, 820486, 886022, 861806, 845422, 879158},
[8832]={300372040, 77041463392, 77068865752, 77068726368, 77041152064, 77069299808, 77068849248, 77041471704, 69525262400, 121827400, 298283072, 122104488, 271559328, 126005320, 157870640, 159959744, 262615104},
[8833]={42076194, 306269666, 104990762, 78496516442, 78108551994, 29026748306, 71680740090, 71433268906, 79226636514, 77877808474, 71512960426, 30643726682, 119605458, 115476642, 107367962, 276934650},
[8834]={665684, 527500, 287836364, 289935436, 162009164, 292032588, 264769636, 136841924, 178786380, 1042116, 683100, 690212, 1027164, 468676, 542404, 640708, 650340},
[8835]={281873982, 218615390, 286068294, 218607078, 853574, 518830, 502446, 1066734, 1116846, 903982, 510662, 1075910},
[8836]={300369656, 301051968, 300519488, 300945472, 300068928, 300363840, 300388416, 159862848, 268914752, 296177728, 149377088, 298274880, 469744, 271020104, 262721608, 298413560, 1051376, 1166064, 1026800, 494680},
[8837]={165482, 113412130, 304212002, 306252026, 306597874, 305115042, 119680602, 307276370, 109121562, 42076202, 262286938, 31574746, 1189482, 1083122, 116466, 75506},
[8838]={526012, 699484, 1043588, 665636, 633956, 1125476, 1035364, 543876, 1027204, 1141532, 1133340, 470148, 534164, 640700, 650332, 657004, 673468, 681660, 689852, 706244},
[8839]={218605614, 273483814, 286066734, 218613974, 283969582, 281873990, 275581174, 233637934, 231205102, 231188718, 517750, 501366, 1066606, 510046, 1115766, 1074934, 1107574, 829134},
[8840]={1173176, 485408, 1058568, 1165904, 191416, 609176, 174672, 557656, 582232, 623920, 1048856, 1156400, 182432, 467904, 475416, 492288, 550664, 573720, 590424, 1024280},
[8841]={31542730, 304213442, 306269634, 105023530, 304173082, 279006658, 308407746, 115978, 141114, 1083074, 66218, 131554, 74898, 106978, 418962, 426466, 442818, 451042, 468146, 1025202},
[8848]={300370592, 77068726488, 77069291736, 76896448696, 76932411608, 77041602744, 77068415040, 69378158664, 69525262400, 69380558912, 75969810616, 69416210496, 1050664, 485416, 625760, 175192, 1166384, 608696, 190304, 468632, 492520, 558056, 575128, 583040},
[8849]={84610, 132682, 140514, 116298, 1090186, 1083074, 1198074, 66066, 76730, 123442, 164402, 410162, 426546, 442930, 453202, 468234},
[8850]={170396332, 287836836, 68344613220, 73818321084, 534052, 542244, 640548, 673316, 689700, 698172, 1034044, 1140540, 1024292, 1130788, 467468, 647692, 680132, 704708, 712900, 721092},
[8851]={72170145990, 73296316614, 70548696478, 73233378734, 72159324366, 56046890318, 73233050918, 518830, 501366, 1099382, 1116846, 903878, 509518, 469558, 821814, 838198, 844342, 877838, 1025294, 1065526},
[8852]={1171664, 478336, 607848, 616040, 468704, 1057904, 1156832, 493160, 599656, 575200, 583392, 181864, 550504, 1164904, 485088, 1050336},
[8853]={116298, 68618, 1082954, 412682, 75370, 140194, 1189842, 166922, 1198346, 1091794, 419794, 467866, 435818, 1205146, 443290, 107418},
[8855]={218605638, 70011840710, 55967164614, 70548711310, 830478, 510990, 904206, 822286, 1099734, 1109006, 871438, 1115038, 895246, 836270, 860846, 885422, 844702, 910358, 877230, 1024566},
[8856]={300369152, 77069298256, 77043249160, 77068865608, 77071397080, 77041463512, 77041168600, 76898857176, 477216, 268996200, 76393566000, 38242037944, 159877912, 262335288, 151464728, 262721608},
[8857]={306654658, 35728954, 307277810, 306311154, 306352114, 306327010, 304229978, 279064154, 42085978, 306253466, 35720762, 105000538, 304516698, 113363194, 33639906, 277850186},
[8858]={526012, 534084, 542396, 632428, 640700, 657084, 665196, 673468, 681660, 689852, 697924, 714788, 1042428, 468668, 649292, 706276},
[8859]={231540982, 218605638, 218613974, 903982, 285732878, 212316182, 275230742, 283635726, 286281790, 286322238, 282086974, 229109318, 852542, 509686, 1066614, 1100486},
[8860]={300372040, 76894367488, 77041455216, 77068718176, 76932403416, 19730277157664, 19730161379408, 271585344, 296759368, 69405437736, 76504297232, 69382352400, 126316616, 149385128, 269013088, 124202928},
[8861]={306253274, 304254970, 306261946, 304214170, 309373554, 33630458, 104943330, 33672674, 29445698, 276966002, 119605514, 279367250},
[8862]={287836204, 170395692, 68355098772, 68447375300, 632388, 1140292, 699004, 1026684, 1133180, 542276, 690812, 534092, 706484, 649140, 682068, 657492},
[8863]={72170147302, 853582, 518950, 1067814, 1116990, 511134, 502590, 1076382, 871582, 903270, 822430, 1109150},
[8869]={83570, 132722, 1197682, 141274, 67178, 165482, 115250, 1082594, 1091938, 409802, 467146, 1024202, 73890, 106658, 123042, 417954, 426146, 434338, 442530, 450722},
[8872]={300369160, 300950816, 300067496, 300083872, 300378792, 300518056, 300945472, 301050536, 608320, 559168, 493632, 591936, 616032, 467496, 599648, 574352, 582544, 1163816, 181856, 550496},
[8873]={78418889050, 78418938170, 79226341570, 117378, 67266, 1082994, 412354, 76482, 1090130, 1190594, 125634, 166594, 419426, 467538, 435850, 442962, 107090, 426538, 451154, 1024594},
[8875]={853622, 231190158, 830118, 510662, 1075910, 469702, 1100486, 1108678, 517774, 838342, 887494, 894606, 819798, 860758, 1114670, 844374, 1065518, 877102, 1024598, 912070},
[8876]={1173176, 1059968, 470144, 476736, 494720, 1027200, 1050696, 609408, 173072, 181104, 188936, 484328, 549544, 574320, 582512, 598896},
[8877]={71439558922, 142346, 67138, 411202, 468546, 1025602, 1189442, 1197674, 124482, 165442, 443970, 116714, 1081906, 82482, 107018, 131594, 426506, 434698, 419394, 452162},
[8879]={855014, 501318, 517702, 1066566, 1107526, 837190, 509934, 894934, 903262, 869958, 1116118, 829046, 1073838, 467470, 819726, 885422, 1024526, 845382, 861766, 878150},
[8880]={477216, 300919456, 300361920, 300386496, 300075680, 300443840, 271585344, 269062216, 296751168, 268628040, 268611656, 298283072, 609056, 558744, 575120, 582640, 590792, 598296, 565768, 614920, 172632, 180504, 189016, 467224},
[8881]={304252962, 116330, 140874, 1082986, 67098, 134082, 1025562, 75330, 83530, 411202, 419434, 435818, 1090018, 106986, 123042, 426474, 442570, 467146, 1196874, 1204714},
[8883]={853582, 517750, 501278, 509510, 829046, 1074758, 836150, 860734, 877118, 886670, 1025494, 1065486, 467798, 819686, 901342, 1098222, 1106126, 1114566, 844302, 893454},
[8884]={1173224, 271010608, 1157184, 624704, 485440, 1058520, 175224, 608080, 189088, 616032, 558688, 575072, 591456, 583264, 493152, 599648},
[8885]={71439616218, 140898, 1198066, 132746, 84634, 116722, 1083498, 67690, 1206258, 428018, 75882, 419946, 107090, 452594, 411514, 436330},
[8887]={853646, 511142, 1100966, 1115190, 904358, 830630, 1076366, 501870, 895806, 879782, 822294, 1109158, 861238, 518254, 844854, 1068198, 912550, 871590, 469078, 836662},
[8888]={300369152, 300945472, 300953672, 301051976, 478344, 1051744, 271159360, 298282592, 123924552, 296726592, 126300232, 298405952, 1174624, 494688, 470112, 486496},
[8889]={304252962, 42012130, 21039314, 304155242, 305113122, 18942202, 306317346, 277293218, 31574082, 308422698, 113657890, 279342674},
[8890]={526372, 666716, 633948, 1043596, 1125468, 699484, 535644, 470156, 1141860, 1027212, 1035364, 543884, 673828, 690212, 714788, 722980, 641428, 649252, 657084, 681660},
[8891]={231542774, 853702, 517870, 903878, 1066614, 510662, 1115766, 1075910, 502470, 1099382, 871110, 1108678},
[8892]={1174264, 1050304, 493248, 583360, 485056, 609008, 469744, 1157880, 617200, 551664, 576240, 1166072, 174120, 559144, 624680},
[8893]={67178, 468586, 1190946, 166890, 75370, 1198722, 412650, 444370, 132682, 1027082, 124882, 140938},
[8894]={1043548, 698468, 633948, 542396, 526972, 724060, 470108, 1026084, 1132580, 658524, 683100, 1140772, 664940, 1123676, 715388, 534084, 648780, 673468, 706124, 640580},
[8895]={854662, 903142, 517766, 509550, 1108614, 1066934, 1075878, 502406, 895622, 1116086, 1099342, 468622, 820878, 871102, 829414},
[8896]={1174664, 1050296, 494680, 486496, 469024, 1156800, 624680, 1058848},
[8897]={67178, 35727394, 306595874, 113389146, 113364570, 262219818, 309472834, 279088578, 33640354, 119664074, 109465154, 276893242, 411242, 444010, 1189450},
[8898]={633948, 1043548, 527452, 535644, 1125468, 1027164, 543836, 1133660, 658524, 683100, 1141852, 470108, 699364, 715748, 723940, 691292, 642140, 650332, 666716, 674908},
[8899]={286068838, 218623438, 852622, 904342, 510662, 502430, 1076262, 871078, 1066606, 821926, 1099406, 1108646},
[8900]={300370112, 77069299928, 19729740302656, 19723186563368, 19729740253840, 19729740171920, 300068456, 300945472, 300085320, 69380559032, 121811016, 76504715480, 76393541424, 68877324080},
[8901]={20137526764906, 20282188350866, 18288541247146, 20136989902522, 18307333826138, 20143975507898, 20074159212242, 20136987805370, 20074706568186, 77888351834, 77951305842, 78953662658, 77965888058},
[8902]={527092, 632868, 665276, 1124028, 1043196, 1133660, 543836, 1027164, 534564, 699484, 1141852, 470108, 674916, 1034276, 690212, 642188},
[8903]={218605606, 218622150, 225249318, 286066734, 281872430, 231540662, 273483822, 218613830, 218949862, 286279870, 231188726, 283633846, 281528382},
[8904]={77043550848, 77070815296, 76898848840, 76894367816, 76894646336, 77041463512, 76506819888, 76504600560, 76361984592, 69524959448, 69525410008, 75970383936, 269045856, 157773936, 296185952, 124203072},
[8905]={78687374898, 78416783698, 304253090, 304212034, 304220282, 33630258, 33638466, 306262178, 306319378, 21049066, 42018866, 304173050},
[8906]={1125516, 1042516, 526020, 665164, 699172, 1140460, 543884, 1133708, 469076, 682068, 657492, 535692, 641108, 1026132, 633996, 1035404},
[8907]={231542262, 218622022, 218615414, 853582, 518830, 903982, 273500326, 282086982, 284184038, 1116846, 509686, 1100838, 1076014},
[8908]={300370600, 300945480, 76898840768, 77035180128, 76896743640, 76932419800, 1051784, 121827400, 298281632, 271116968, 298953376, 149072544, 1173176, 477216, 485408},
[8909]={35777994, 42018850, 78662142090, 78662192682, 78688267794, 26879264906, 79226374370, 26879274330, 71523536346, 29009971322, 77877824970, 77879961914, 276941514, 113668178, 277260530, 119958194},
[8910]={699132, 1141900, 470156, 527452, 632868, 658524, 722980, 1027164, 1042468, 1133660, 535644, 543836, 640708, 650340, 674556, 682020},
[8911]={231542902, 218615262, 853582, 518790, 904342, 273131558, 286280206, 283617318, 284182566, 212316182, 275230742, 273655854, 1115766, 511006, 829534, 1075294},
[8916]={1172128, 477288, 607160, 615112, 467656, 492232, 598728, 180936, 549576, 574152, 582344, 1163856, 1058928, 484160, 1049408, 566080, 172864, 189248, 557888, 623424},
[8917]={115242, 1081898, 139818, 65946, 1091794, 1198106, 74282, 418346, 467498, 410154, 434730, 442922, 124514, 1189514, 1204658, 106930, 164274, 426418, 82354, 131506},
[8919]={854782, 508462, 827990, 1073710, 1066038, 517894, 1116270, 901678, 467502, 870510, 819758, 1098286, 895846, 1106638, 501390, 837262, 845454, 861838, 878222, 886414},
[8920]={300371072, 300363840, 300388416, 300920896, 300945472, 300461768, 300380224, 300953664, 609168, 172712, 182064, 190296, 551064, 557856, 574240, 582432, 590624, 600216, 617288, 622872},
[8921]={33638442, 116210, 140506, 1090674, 1083066, 1197170, 67018, 75250, 410842, 419314, 435698, 451842, 106898, 123042, 164002, 426146, 442530, 467106, 1024162, 1188002},
[8923]={853614, 517862, 1067086, 1117318, 1099374, 509686, 828918, 1075718, 468230, 500238, 820486, 836230, 844102, 861326, 876870, 885062, 893094, 902286, 1024326, 1106086},
[8924]={1172464, 477096, 1158240, 609216, 1166264, 173000, 189024, 467904, 623560, 1024960, 1049536, 1057048, 180504, 483608, 491800, 549144, 557336, 565528, 573720, 581912},
[8925]={115218, 140954, 1082906, 1196882, 67018, 82410, 131562, 1089738, 74258, 410122, 418354, 434706, 106698, 123042, 164002, 426154, 442530, 450762, 467106, 1024162},
[8927]={853622, 501358, 828998, 509870, 895694, 1073718, 516310, 1066134, 467510, 819766, 836150, 844342, 860374, 876758, 884942, 901334, 1024206, 1097902, 1106126, 1114286},
[8928]={300369272, 300952344, 301051976, 300362520, 76504592568, 68843385024, 69416210096, 39854756024, 76393443120, 68876955440, 32334360648, 76506820368, 300518168, 296751168, 157773776, 268611656},
[8929]={20137520473426, 20281408226890, 2757924816066, 20092951799506, 18307319146346, 19939419342378, 20136989902754, 20281481627210, 20281406121538, 18350281434562, 20136996235146, 20000157025546, 42019066, 304222202, 33640002},
[8930]={525900, 632516, 698412, 1027172, 1035364, 1043596, 1124036, 543844, 666604, 470116, 1141860, 535692, 642188, 658572, 691340, 1132260},
[8931]={70011842094, 853614, 518830, 903982, 1067654, 1116870, 510766},
[8944]={1172032, 1060000, 609160, 616032, 468576, 493152, 599648, 181856, 550496, 575072, 583264, 1164896, 189592, 1049048, 483920, 565840, 1024472, 172624, 557648, 623184},
[8945]={141018, 1198026, 116362, 1083018, 66074, 1092530, 75722, 419426, 468458, 411114, 435810, 443882, 1188634, 1204778, 123674, 164634, 107050, 426538, 1024794, 82474},
[8947]={853486, 829030, 509542, 501654, 1074790, 902758, 1068198, 467982, 822198, 1099286, 1107438, 517134, 836646, 885318, 1116254, 1024702, 870494, 912550, 893726, 860718},
[8948]={300370592, 301051976, 300519496, 300380224, 300068936, 77071495232, 77041168576, 69412016192, 69380558912, 69378157224, 69399431840, 69407821888, 1173536, 625760, 1158240, 477216, 467944, 493560, 575488, 583680, 1025000, 181944, 550472, 567216},
[8949]={35737034, 306268194, 307277282, 306327010, 279005218, 306612258, 109137346, 306294242, 309481026, 42084386, 308365354, 116298, 1082954, 67026, 123442, 131594, 443658, 467506, 1024562},
[8950]={526012, 666724, 1124396, 631796, 468668, 534084, 542276, 640700, 657084, 673348, 681660, 689852, 1041844, 648732, 696844, 706076, 1034004, 1132300, 713348, 721540},
[8951]={281872422, 286068286, 218607174, 218624014, 231540982, 853582, 501366, 518830, 1116846, 1100462, 829046, 510598, 1075246, 878078, 893494, 1066246, 468558, 820814},
[8952]={1174664, 583400, 616488, 575208, 493648, 468712, 1164872, 599736, 182312, 551672, 1050704, 608288, 1058528, 486168, 558776, 1026128},
[8953]={67186, 116698, 1084194, 420842, 75858, 140906, 412650, 1197674, 468474, 1190890, 125930, 437258, 444730, 1091538, 1205826, 1026362},
[8954]={527452, 633948, 699004, 1043428, 1027044, 535644, 1133540, 658404, 543716, 691292, 723940, 1141732, 665156, 715748, 1125348, 674788, 705516, 468548, 642140, 649852},
[8955]={853742, 902734, 829406, 509398, 1075126, 1067694, 516670, 870366, 821134, 1107334, 501726, 468598, 1115718, 886350, 837518, 911086},
[8956]={300372032, 76928209080, 76894351576, 76361984592, 77068824768, 75970383968, 68860169944, 69525409976, 67235180528, 75967426752, 76498301112, 77035310688, 268905248, 269028128, 269011736, 298283072},
[8957]={77888350330, 77955459898, 78108592498, 77882059098, 77959694706, 10768959530, 77953403274, 8072005978, 78425221154, 67142543402, 29098100666, 78941063370, 70971952450, 71508764562},
[8958]={1043596, 543836, 699404, 1141852, 470156, 1035404, 682068, 642188, 657492, 1133660, 1125468, 715916, 666604, 535692, 691340},
[8959]={273483822, 286068654, 223152366, 853694, 517742, 1066606, 870006, 283953678, 282044462, 286117902, 285724686, 284216774, 902862, 509646, 501742, 1107926},
[8960]={300370720, 300952256, 77043642576, 77071364160, 77069291584, 77041152216, 76932419768, 76892270808, 485456, 575208, 583400, 591952, 608096, 558944, 181872, 550512, 173920, 190304, 599664, 616048},
[8961]={141954, 67210, 76418, 412290, 469994, 1027050, 1190530, 1198722, 125570, 166890, 428674, 445418, 115218, 1082954, 83210, 132322, 1090826, 1205514, 108106, 419402},
[8962]={526020, 631428, 664964, 1041796, 534084, 542276, 640580, 673348, 689732, 699004, 714308, 722500, 467468, 647692, 655884, 680460, 705036, 1024524, 1032716, 1122828},
[8963]={231542286, 218605734, 852502, 518790, 895622, 1067654, 1116806, 501326, 1108614, 510614, 903262, 830086, 1074766, 468558, 820814, 837198, 845390, 861774, 878158},
[8964]={300368816, 300519520, 301052000, 76896465088, 77034877000, 76932493496, 69525262488, 76896743608, 75969810640, 76898545736, 76506681440, 583400, 576632, 550992, 609400, 616048, 599768, 182016, 558704, 467616, 1024672, 1049104, 592672},
[8965]={142018, 411634, 1189874, 166890, 68226, 469994, 125570, 1026690, 445418, 1198066, 1205898, 1091570, 116322, 1082978, 419426, 435786, 75762, 451090, 83954, 107026},
[8966]={526020, 533852, 632036, 664804, 1041796, 1123796, 1131908, 543356, 640580, 673348, 689732, 706116, 468436, 647692, 655884, 680460, 1138884, 696844, 713228, 721420},
[8967]={57663809878, 70548711430, 58737864270, 70559533526, 72159324382, 70011842134, 70012153422, 1066638, 502830, 1115790, 510750, 903870, 821158, 1024894, 468622, 886374, 1107558, 911110, 837198, 870030},
[8968]={77041455128, 77070815280, 1173216, 494360, 1051296, 468704, 1025760, 617136, 584472, 183424, 552064, 484960},
[8969]={68218, 76770, 116290, 167002, 1191042, 142306, 1197994, 411562, 468906, 444330, 1084410, 124842},
[8970]={1042028, 665156, 527372, 1026740, 699060, 543412, 657020, 534124, 1141428, 1033796, 1123908, 689772, 632148, 674428, 641660, 706116, 468604, 648788, 681580, 714348},
[8971]={853934, 904342, 510006, 518182, 1117318, 1109126, 1068126, 470150, 502918, 830630, 1076374, 1100814, 871462, 1027206, 838630, 822406},
[8972]={300370624, 19585709566152, 300945480, 298274880, 77068865728, 76921933888, 77068791992, 77034860760, 69412016312, 39850274888, 76504592568, 69525270712, 271012032, 124211296, 300386520, 268930680},
[8973]={20137533056362, 19937808696698, 19958209791234, 19937259234666, 20143975556802, 19956599178498, 2345073190250, 5155268602167858, 5190391223615746, 5155268686103114, 5144366907720618, 5192196206690410, 77966239874, 29033040098, 78108895298, 70909028250},
[8974]={287838284, 170397796, 665284, 1124036, 526020, 699492, 543884, 1141860, 633996, 1027212, 1043612, 470156},
[8975]={273483814, 218623558, 286068198, 281873894, 275582998, 218935230, 283971142, 218926566, 223154198, 231190638, 231197414, 286281246, 212314830, 224914910, 229101694},
[8976]={76917722920, 76913528616, 77070814080, 76894359352, 76928208640, 76926111528, 1172336, 298856552, 271118456, 298823800, 468904, 493120, 1050576, 174752, 559776, 625312, 1157792, 575400},
[8977]={116290, 1082946, 140866, 67138, 469066, 412442, 445210, 75330, 1189602, 125602, 165602, 428066, 133154, 419394, 1025762, 1197674},
[8978]={68447375468, 534084, 632388, 640620, 665156, 673388, 689732, 697924, 707676, 722980, 1026004, 1123908, 468308, 541596, 656284, 680940, 648212, 713708, 1131140, 1139252},
[8979]={73233049582, 853214, 829158, 509670, 1074918, 902886, 468670, 820966, 1099854, 1107646, 516782, 837310, 886502, 895054, 845902, 1066606},
[8984]={1173184, 476864, 298283072, 298848328, 191176, 608968, 1058328, 173032, 181224, 467584, 492160, 549504, 557336, 565528, 573720, 581912, 590104, 598296, 614680, 622872},
[8985]={279088586, 116290, 140834, 1082946, 66186, 74290, 82482, 131634, 410130, 418362, 435466, 453202, 1197834, 106978, 123042, 426466, 442530, 467146, 1024162, 1188002},
[8987]={853574, 517750, 1066614, 501718, 828998, 509478, 1074718, 894854, 467478, 819734, 836118, 845350, 861374, 876750, 885222, 1024206, 1098182, 1106086, 1114278, 901646},
[8988]={1174264, 608928, 191416, 493120, 550464, 1050296, 468904, 1058336, 484928, 584672, 617480, 1025960, 1165520, 599776, 182344, 575560, 567008, 173792, 558816, 624352},
[8989]={116290, 1082946, 139826, 67138, 76930, 419554, 1198882, 411202, 435938, 443970, 1207074, 1189442, 1090674, 123082, 164042, 107058, 426546, 467546, 82122, 131274},
[8991]={853614, 829398, 509510, 1074798, 902766, 894982, 519190, 1116246, 1098294, 1106486, 820806, 500278, 470150, 838790, 863366, 846982, 1066006, 879750, 1027206, 871198},
[8992]={300368304, 300920896, 300945472, 300952224, 301060160, 300363360, 300386976, 124211264, 296177728, 155668544, 121827400, 121811016, 584800, 625760, 550944, 576240, 182304, 592992, 560224, 601176},
[8993]={67178, 140914, 83530, 124522, 132682, 165482, 411242, 444010, 468586, 1025642, 1189482, 1197682, 1205874, 75370, 427634, 435818},
[8994]={525892, 632868, 665276, 699484, 1042148, 1125108, 1133660, 543836, 1027164, 470108, 534572, 691300, 1140252, 640580, 648772, 656964, 673428, 681980, 706092, 714284},
[8995]={854278, 830478, 510990, 1075158, 517630, 468590, 501318, 821206, 837590, 846510, 886742, 894582, 1067966, 1117126, 1025646, 1099342},
[8996]={300371712, 300945488, 77070831400, 77071363880, 77070806824, 77070888744, 1174384, 271585184, 271003712, 298848200, 298856360, 268627880, 477232, 126316616, 296317008, 159961168},
[8997]={306326114, 306260730, 306350114, 306251810, 31533290, 304556282, 305113338, 279062602, 107023946, 276957306, 104974954, 113330442},
[8998]={1043604, 527388, 534084, 542332, 632404, 665156, 673348, 690812, 697980, 1026860, 1034876, 1123908, 640756, 650028, 657140, 681540},
[8999]={70022662438, 72172243230, 70024759302, 59274415558, 853502, 130525390, 281529102, 275630862, 275229462, 212314902, 275237622, 273132254, 518190, 509694, 1116246, 1074942},
[9000]={300370600, 271584032, 296749856, 76932100288, 76932485304, 76924031160, 69380559064, 76531847352, 68981813464, 32336466016, 76393443312, 68875137208, 269021256, 300510920, 157772056, 298291264},
[9001]={77879920954, 78416791866, 77888294346, 77888358626, 9160444098, 20137524667754, 20281942943402, 304254410, 304173050, 304213442, 42027042, 104992322},
[9002]={527452, 699484, 1124028, 665636, 1140820, 642188, 1035404, 683148, 543884, 1133668, 658572, 1026132, 1043596, 535692, 691340, 632876},
[9003]={854702, 519190, 903982, 1115766, 1067718, 511022, 502446, 1100454},
[9004]={300372032, 300945472, 77068865752, 77069299928, 76896448704, 77041586272, 77070823488, 76932100312, 1173544, 1050568, 583720, 493600, 469032, 616480, 575528},
[9005]={68258, 1190570, 125610, 133802, 166530, 84650, 411210, 76450, 1026730, 1083122, 444010},
[9006]={526372, 1026684, 1141372, 1041988, 542276, 632388, 1132100, 640940, 691292, 699004, 722860, 1123908, 649252, 665156, 682740, 658164},
[9007]={218605614, 286068286, 218623454, 231542414, 218613798, 1100822, 821934, 1108654, 1067814, 838318, 1026734, 871086, 469678, 879278, 1074798, 829174},
[9008]={77041463392, 76932403384, 77043552440, 77041537240, 76894367960, 19730161690840, 19729629112936, 19729618217560, 75967795416, 68982108232, 68845793464, 69525409864},
[9009]={5156874924139354, 5156874911556042, 79224195826, 9160445378, 19939417212314, 19959283574146, 20210526529546, 18306257988154, 20282018449850, 20143975507898, 20274502306226, 6881108109042},
[9010]={526372, 170395852, 287836364, 264767692, 136841420, 287975724, 164104396, 290074700, 292628676, 288010308, 176827052, 185215660},
[9011]={286068678, 231542414, 224915574, 132632662, 210235510, 273534622, 218607222, 281530494, 286060654, 281923670, 286044246, 286290126},
[9012]={300372040, 300378784, 300944032, 301050496, 300518048, 300067496, 300501696, 77035262168, 77070807104, 296323752, 268628040, 271584032, 149383840},
[9013]={78416791866, 33639874, 304221634, 279055938, 306318914},
[9014]={526252, 665156, 1123908, 534564, 690212, 632508, 698284, 1025724},
[9015]={854702, 502446, 518830, 1116846, 1067694},
[9016]={77041152112, 76504730344, 75967728336, 76932499744, 19721001313952, 19694185121392, 19694187136632, 19692566054328, 19592301209392, 19585743414544, 19592185865968, 17798392883904, 40949461072, 67230967800, 39340968304, 36648225480},
[9017]={78416793810, 77879922890, 9160444234, 78687373938, 78687326226, 77882068810, 33623634, 304171234, 42076386, 104990786},
[9018]={526324, 698356, 1124460, 1132652, 1141924, 543908, 1026156, 470180, 683172, 658596, 1043620, 665708, 641132, 1035428},
[9019]={73233067910, 73296318606, 73239695502, 854806, 1117350, 231190070, 130526894, 281530078, 281922198, 281841382, 281898726, 231198358, 519310, 510758, 904310, 502526},
[9020]={19730274936520, 300067040, 300452160, 300468544, 300919104, 298283072, 268609736, 159869632, 296184512, 296749120, 149383872, 271583568, 126306576, 126298408, 157870184, 159574320},
[9021]={308366818, 308416066, 279007282, 35720778, 304220226, 71512967866, 9154136394, 78425221266, 78498908978, 8082491602, 78660407274, 29033049690, 305113714, 119705026, 304508442, 113659378},
[9022]={74892062940, 525892, 632388, 1123908, 697924, 534204, 689852, 640700, 1132220, 681596, 1025724, 1033980, 542820, 657492, 469076, 714364},
[9023]={72172244630, 70011832662, 70024759446, 72759445830, 72159643846, 72163854542, 59274751774, 70603573318, 1117326, 519190, 273139878, 231583878, 1100606, 502470, 510726, 1067654},
[9024]={300369152, 300944152, 301052096, 76932115056, 76896448584, 76924022368, 76921630736, 77070945896, 1050688, 477248, 296758032, 271028440, 494752, 147269824, 262695592, 157847528},
[9025]={307277842, 42085946, 306317378, 35735618, 35784770, 42018978, 33640002, 306262074, 309481522, 42010786, 304230418, 105024994, 113371298, 119982146, 277253618, 29470194},
[9026]={665668, 534084, 640580, 1124268, 1042052, 689732, 1033796, 1141372, 542276, 525700, 1132100, 673708, 706668, 650404, 632452, 683172},
[9027]={281872454, 231542262, 853646, 502806, 903982, 519150, 510646, 1116806, 1067686, 896014, 1100454},
[9028]={1173584, 1058984, 190632, 1165480, 468944, 616040, 607848, 1156832, 493160, 599656, 575200, 583632, 567368, 486528, 1051776, 182344, 550984, 175232, 625792, 1027200},
[9029]={1090714, 116450, 66098, 1082026, 1199010, 74770, 139946, 418474, 467506, 410162, 434858, 1204906, 1191066, 442570, 106698, 123082, 164002, 426186, 82082, 131234},
[9031]={229444142, 500798, 828078, 508470, 901806, 1073718, 467510, 1097934, 819766, 1106486, 870118, 516302, 1068166, 835790, 860366, 884942, 1114278, 843982, 910494, 876750},
[9032]={300370656, 77044125544, 77043543912, 77043568488, 77070511968, 77041602472, 77070527856, 77041463288, 69525262280, 155685032, 295890592, 262631592, 296284328, 478000, 486152, 616152, 1157912},
[9033]={306260562, 307268210, 35768466, 304212106, 306604658, 35719290, 279054906, 105024090, 42068570, 305113690, 21048882, 109193946, 1198058, 141298, 76842},
[9034]={526436, 699548, 267006124, 178785956, 170397828, 289935052, 266866860, 178925740, 178892972, 535204, 542820, 657508, 691212, 469668, 642060, 650012, 674828},
[9035]={218622230, 231540918, 218615350, 286067246, 517766, 1066950, 501382, 1116142, 904238, 895078, 830510, 1076270, 1099742, 1107934, 870366, 821214},
[9036]={300372032, 1174256, 477936, 298274480, 271012008, 126308496, 268914832, 121827496, 147279536, 122105544, 269021248, 298412280, 157773448, 296184592},
[9037]={78662151770, 78425163866, 78496467034, 77882059530, 71445850202, 78496811146, 10773145722, 78488078426, 77882002202, 77879962282, 78488135818, 77965962042, 304173074, 42061282, 276900562, 262220346},
[9038]={525956, 534268, 543476, 632452, 665340, 699004, 1043188, 1124092, 1133300, 658164, 469748, 724060, 641820, 674612, 682780, 690996},
[9039]={72700725246, 57126922446, 853638, 519206, 903262, 283617438, 222800030, 212314670, 229091846, 128395454, 275228710, 1116798, 1066926, 510046, 1100806},
[9040]={77041454888, 77041152216, 19730302200024, 19694719814264, 19730129922328, 19693620619928, 19729740302968, 5049135248474672, 17624522205568, 17770574465536, 17630967064200, 19592299243648},
[9041]={5156856133649202, 19939417204002, 2204410906074, 20074698188034, 20074698180338, 19995790796690, 20075232954538, 19999557281034, 20143975556682, 2345073190170, 19956070680346},
[9042]={73818320972, 18897493959668, 19172376060916, 4485638773015484, 4485640920498444, 4909500480357108, 4909500505522652, 292171844, 287838276, 292630596, 73730223932},
[9043]={218622150, 231540982, 286068926, 58737536566, 70016370750, 72696187070, 72159627462, 57664121182, 73245649318, 231205446, 286116054, 132630822, 286281750},
[9056]={300369152, 300953664, 301050528, 300519032, 300945472, 486136, 609016, 174840, 191224, 470104, 592632, 494328, 181928, 550568, 558440, 575144, 566952, 583016, 1025704, 1164968},
[9057]={165610, 1197682, 83570, 132722, 1189490, 116290, 142290, 1083266, 66058, 125906, 412626, 1090842, 75754, 108522, 420898, 428010},
[9058]={527452, 665636, 1125468, 690940, 699132, 1035004, 1133340, 535292, 631788, 1025004, 469628, 542636, 639860, 655884, 672628, 680460, 1040692, 647812, 705084, 713228},
[9059]={218605606, 286066726, 273483814, 218621998, 231540982, 218615270, 281873990, 1099742, 501366, 518102, 1115766, 894942, 829006, 1075142, 1108950, 468934, 821230, 837254, 845806, 862190},
[9060]={77068718064, 1174264, 271020104, 271158880, 296759368, 494680, 576608, 584800, 1166424, 183024, 551664, 1051776, 469784, 175200, 191584, 1027160},
[9061]={33638434, 67178, 1206234, 445450, 1189482, 124522, 165482, 1197682, 1025642, 470026, 140914, 411602, 427634, 75370, 108506, 1083002},
[9062]={526620, 534204, 543836, 632508, 640700, 665276, 689852, 724060, 1026084, 1042108, 1124268, 1132220, 467948, 696964, 714268, 648772, 656852, 674196, 706092, 1033196},
[9063]={853982, 517862, 501366, 1067086, 509910, 1075158, 468950, 821206, 1099342, 1107566, 903126, 837230, 1114806, 886742, 894582, 845430},
[9064]={77070815296, 77043552320, 76894367816, 19684957268600, 19730151197264, 19730127841480, 77041471560, 19729624820232, 77035301552, 69382656152, 69414113064, 68868853832},
[9065]={5155206862021130, 5156918410683186, 5192177932116426, 5155225652503050, 5155224591344154, 5192177944699018, 19999548852226, 19937259226370, 6881108117242, 19957681349578, 19959354917866, 20281414510154},
[9066]={527500, 267004668, 266864844, 289933996, 288352468, 292032588, 287836844, 138940492, 68361498404, 19172376029668, 287845052, 178925764, 290074724, 292049012},
[9067]={218623454, 218615254, 286068214, 281873910, 72751056846, 70559534398, 57127243342, 56590380622, 73245650918, 59188432726, 273149526, 231206566, 286280310, 286314606},
[9068]={1172464, 477976, 271118480, 271585448, 296759440, 271003792, 608328, 1025600, 568448, 494720, 601216, 617240, 181704, 550104, 1164744, 484928, 558656, 575040, 591424, 175232},
[9069]={279063050, 116290, 1082946, 66058, 1027082, 1189962, 166922, 75330, 419394, 1198394, 468546, 410842, 125842, 445330, 437258, 1206730, 109002, 428450, 83346, 132378},
[9071]={853574, 828998, 509510, 1074758, 501798, 518182, 903110, 1067046, 468974, 1100118, 821230, 1107950, 886102, 837190, 1025606, 911398, 1115718, 895358, 861590, 845086},
[9072]={1173064, 475784, 1156672, 1059704, 190312, 606736, 1165160, 172680, 467472, 483856, 492048, 549392, 180512, 557344, 565536, 573728, 581920, 590112, 598304, 622800},
[9076]={76894366520, 76928208960, 77043550824, 77068717784, 76894351576, 77041455320, 1173184, 478304, 298848320, 485056, 494728, 552032, 470112, 625800, 1027208, 584840, 592992},
[9077]={141274, 67146, 444378, 75378, 1189490, 124890, 165490, 83530, 132682, 1091186, 1197642, 411250, 468594, 1205834, 109226, 427594},
[9078]={525292, 535284, 633588, 665276, 691292, 699484, 1027164, 1042468, 1124028, 1133300, 1035356, 543836, 468548, 640580, 658044, 673348, 1140076, 648892, 681540, 706236},
[9079]={853582, 518110, 1117206, 830126, 509918, 1075166, 903854, 468598, 1099262, 821214, 1107574, 501350, 837238, 861814, 886750, 894582},
[9080]={300369152, 300068928, 300084840, 300379744, 300502648, 300519008, 300953184, 301051488, 268914752, 298274880, 1173184, 486496, 1051376, 477216, 470104, 494680, 1027160, 1157880},
[9081]={132722, 83930, 68290, 411242, 1189490, 124522, 165482, 468586, 75866},
[9082]={525892, 535284, 665276, 699484, 1043188, 1124028, 691292, 1033916, 633588, 469028, 543884, 658572, 1131500, 640580, 648892, 673468, 1026044, 1140732, 681540, 706236},
[9083]={853462, 501358, 517710, 1066614, 1099742, 1107574, 1116126, 870006, 903262, 509550, 468598, 829174, 1074798, 837230},
[9085]={141250, 132698, 1091642, 1190586, 1197658, 165466, 124506, 83546, 443994, 115954, 1082250, 66082, 74274, 106682, 409786, 417978, 426170, 434362, 450746, 467130, 1024186},
[9088]={1173600, 493256, 1049112, 1025616, 550480, 615704, 599632, 573976, 582168, 181840, 1164880, 607880, 467840, 484952, 566864, 558672},
[9089]={116666, 142010, 67162, 1083322, 1199258, 412698, 445466, 1191058, 125978, 166938, 1027098, 76474, 469082, 437394, 419578, 1092282},
[9090]={1042532, 632932, 699180, 665700, 526436, 1122828, 534084, 715444, 722556, 1025620, 542332, 689732, 467484, 639500, 655900, 672268, 1131116, 1139308, 647692, 680460},
[9091]={853598, 509886, 903214, 1075134, 518806, 1067670, 830438, 501694, 895798, 1107550, 1116822, 838334, 886478, 1026750, 468606, 871062, 820262, 1100078, 862510},
[9092]={1174616, 300953344, 300478536, 300519488, 301051808, 300068928, 300470344, 300085312, 122105928, 262623296, 268914752, 608896, 484328, 494448, 1166032, 180864, 549504, 557696, 566248, 172992, 590464, 599016, 615400},
[9093]={78662150282, 78662142298, 116338, 140794, 1082986, 410890, 468194, 1025290, 1189130, 83562, 132714, 419434, 107018, 123402, 164362, 426506, 434738, 442930, 451122, 1204746},
[9095]={218605614, 218621998, 218615270, 231540974, 829046, 1074806, 468558, 820814, 837198, 862166, 878158, 886350, 1066134, 844342, 893454, 1024566, 1098254, 1106486, 1114638, 909878},
[9096]={300371560, 77043248904, 77043699464, 77068431552, 77071495232, 77070823488, 76896465088, 77043683128, 1172016, 583264, 468560, 617480, 494256, 591456, 1051384, 576136, 1025616},
[9097]={309374994, 116346, 85034, 134186, 67194, 140882, 1083010, 75386, 468602, 411258, 444386, 1198170, 1189458, 124538, 165458, 435794},
[9098]={266864988, 664556, 469628, 534084, 542276, 632388, 640580, 648772, 656964, 673348, 681540, 689732, 696844, 706004, 721460, 1024564, 713268, 1032756, 1122828, 1131060},
[9099]={73233051038, 73239693518, 72170145990, 56046890414, 57663811478, 59274407582, 73233370782, 72159316166, 519310, 904358, 1100582, 511142, 469086, 1108062, 1075286, 837726, 886878, 1066622, 1026142, 870486},
[9100]={1172096, 477576, 470112, 1027168, 1051384, 1059928, 1166432, 608696, 172552, 180864, 188936, 483848, 491800, 549144, 557336, 565528, 573720, 581912, 590104, 598296},
[9101]={1198762, 116362, 165450, 67186, 1189490, 468594, 411250, 140634, 1082834, 74250, 82442, 131594, 1089594, 106698, 123042, 418922, 426146, 434378, 442530, 450762},
[9104]={1173424, 608336, 477616, 493648, 470152, 182312, 583720, 485456, 617568, 576648, 601184, 1051016, 1057968, 551224, 1165624, 567608, 1026480, 559376, 1155600, 190024},
[9105]={306327010, 117730, 1084386, 66818, 410882, 443650, 75738, 1189122, 124162, 165122, 1025282, 83930, 1090498, 419074, 468146, 435418, 1205274, 427034, 108506, 133354},
[9107]={853582, 1100462, 502446, 518830, 1116846, 1067694, 509998, 829406, 1075846, 903134, 469518, 822214, 886102, 893902, 1106374, 836910, 860734, 846030, 1025742, 870838},
[9108]={300371072, 300519496, 300953664, 301051496, 301058720, 300085312, 300486728, 300919456, 268921512, 121811016, 469024, 552024, 493600, 584432, 1166064, 576240, 617096, 560224},
[9109]={126082, 1191042, 68618, 167042, 412682, 1027082, 444330, 468586, 1198762, 76450, 1083370, 140914, 435818},
[9110]={526012, 632868, 1043548, 1124028, 666716, 1140412, 1133660, 1035356, 690932, 697964, 542276, 1027164, 656724, 468548, 534084, 706116, 681300, 640700, 648772, 674428},
[9111]={854102, 516662, 501318, 1066606, 1107526, 902862, 1116838, 1099734, 509558, 468550, 837190, 1025606, 878198, 1074798, 869998, 886382},
[9112]={300369152, 77043560520, 77069299896, 77043249368, 77041463360, 19730301905168, 19730157496616, 19694620945016, 76391338168, 68875145408, 69525270744, 38239662152, 121825960, 296177760, 126307008, 268922976},
[9113]={78662152234, 20137600207098, 19937808696578, 18350283499954, 20281942951618, 20143967168186, 20137596012754, 20282188302506, 19937259234562, 19939421398570, 20076860344018, 18151089711922, 77888351834, 27950927418, 29033049434, 77959695690},
[9114]={525892, 1042044, 666356, 1124028, 542292, 1033916, 534204, 689852, 1140820, 699484, 1133732, 641108, 682068, 469076},
[9115]={70012153142, 854726, 231207046, 73245634542, 72171909254, 59280715670, 73245642566, 73144970574, 73296367662, 72073326134, 70024408398, 283971046, 218949702, 229101734, 273500334},
[9116]={300369152, 300944992, 296177728, 159862848, 298274880, 609376, 175200, 183032, 191216, 468664, 485416, 493608, 1024280, 1057048, 549504, 557696, 565888, 573960, 582152, 590464},
[9117]={140874, 68618, 116330, 75378, 411250, 1189490, 1205874, 1197642, 124530, 165450, 427634, 444018, 1082914, 1024202, 82482, 107058, 131634, 418354, 434738, 451122},
[9119]={218621998, 273483822, 231540974, 218605614, 218615390, 468958, 837598, 878558, 894582, 1107534, 1115766, 870006, 828886, 1074038, 819726, 844702, 861086, 885262, 1024526, 1098294},
[9124]={1174256, 190120, 476520, 1058152, 173776, 468688, 485072, 493264, 550608, 558800, 575184, 583376, 608272, 181608, 566632, 591208, 599400, 615784, 623976, 1025384},
[9125]={116290, 1083346, 142370, 1091482, 412706, 1190946, 1199138, 166946, 68410, 445450, 75730, 1207330, 83866, 108882, 124186, 132378, 427290, 436562, 453586, 468250},
[9126]={526076, 665340, 533004, 541924, 631428, 640684, 657068, 673452, 680940, 688772, 697324, 721900, 713188, 1025212, 1033524, 1040668, 467428, 705116, 1122588, 1130780},
[9127]={286068326, 273483974, 218622158, 218614302, 225249886, 221055582, 229444190, 283971606, 829046, 502822, 1076246, 904206, 468894, 821150, 837534, 846806, 886686, 1025950, 1099678, 911262},
[9128]={300369296, 300944176, 77043249168, 76932116568, 77043634328, 77071364248, 77068849304, 76921909336, 477280, 269061840, 298283216, 268931224, 157765720, 126300328, 147288240, 295874272},
[9129]={20137526822298, 20137600173466, 33640018, 304171634, 304252986, 78412580970, 78645415498, 77877816898, 71680796778, 26879274570, 26885621826, 29033048178, 309472850, 113412714, 31533186, 119950058},
[9130]={526036, 1124412, 699548, 469092, 534268, 542460, 632892, 640724, 665340, 682084, 689916, 1025788, 650396, 658228, 674972, 707740},
[9131]={218606230, 286068790, 218624054, 281872534, 231541286, 218927310, 218614534, 518126, 1116862, 502822, 1099766, 904342, 1066990, 830614, 1076374, 879662},
[9132]={300369152, 300944032, 77043265720, 77068726344, 77041561816, 76924022976, 77068709952, 76932100280, 271011904, 298283072, 155668544, 268931136, 268996680, 147279936, 296325192, 271159360},
[9133]={78662207802, 78662158650, 78412597562, 9145749226, 77888366938, 78663158578, 8608876474, 8619379002, 77888301402, 77879963074, 77888292794, 71439552114, 304173050, 42020506, 308415066, 104991322},
[9134]={526012, 666724, 1125476, 699124, 1027164, 1042108, 1033916, 534452, 1141492, 689852, 470108, 543476, 673836, 1133668, 642148, 658532},
[9135]={218621998, 218605606, 286068734, 231542422, 281872430, 218613974, 218934902, 275581174, 902902, 281520174, 281849318, 273133126, 1116870, 518126, 509686, 1074934},
[9136]={300369096, 301051496, 300945472, 191464, 609016, 173752, 183392, 468664, 485048, 493600, 550944, 559864, 566248, 574080, 582272, 590864, 599016, 615440, 623272, 1024640},
[9137]={140866, 1082994, 68226, 117410, 75338, 83530, 132674, 411210, 419442, 435826, 452170, 468546, 107018, 123402, 164362, 426506, 442890, 1024522, 1090058, 1188362},
[9138]={527372, 666716, 1125468, 633956, 266972812, 533020, 639516, 673228, 688668, 697324, 1025004, 1033460, 467468, 541196, 648412, 655884, 1132748, 1140940, 680460, 705052},
[9139]={218605606, 218623934, 286068846, 218614382, 281874430, 829046, 1074806, 468558, 820846, 837230, 845430, 861814, 877230, 885662, 893454, 1024526, 1065486, 1106446, 902726, 911438},
[9140]={1173120, 478320, 607632, 172960, 189344, 468888, 484616, 494024, 558480, 574864, 583056, 591248, 550208, 623040, 1024808, 1049384, 1057536, 1155480, 1164608, 180752},
[9141]={116674, 141930, 1082970, 66066, 76394, 82570, 131722, 411186, 453226, 1090786, 1189426, 1206890, 1197386, 106906, 123290, 164250, 426394, 467354, 1024410, 418322},
[9143]={853638, 502422, 518846, 509534, 829062, 1074782, 469614, 821870, 838254, 879214, 887406, 895278, 860974, 1065774, 1098142, 1114926, 844310, 901774, 1024534, 1106454},
[9144]={1173544, 271583904, 271142976, 271010464, 270708800, 268626600, 298281632, 298953376, 159869608, 298420896, 296749736, 269044392, 583320, 591512, 468672, 493248, 180512, 549152, 557344, 573728, 598304, 1024208, 565896, 615048},
[9145]={306269666, 306318818, 33639906, 35737154, 116418, 1083074, 1091458, 66786, 410490, 467834, 1024930, 1188730, 73938, 123050, 164010, 434346, 442538, 107066, 418722, 426514},
[9147]={853622, 502446, 830126, 509918, 1075166, 467878, 516670, 820134, 836518, 846150, 862534, 877118, 895246, 884950, 1024214, 1065134, 1097942, 1106134, 1114326, 901694},
[9148]={76894351432, 76894359144, 76894366360, 76896751680, 76915626048, 76917722832, 1172456, 476888, 296169688, 298290928, 271003864, 608320, 550616, 575552, 583744, 624704, 1025752, 1050208, 600168},
[9149]={306261594, 306350266, 306318906, 306253354, 279087290, 279365818, 306653370, 279390394, 279046330, 279947450, 278988986, 33638586, 117730, 142018, 1084026, 411234, 1189474, 1206978, 427586, 436858},
[9150]={524932, 534084, 542756, 632428, 641060, 665156, 690092, 698404, 722980, 1026084, 1034156, 1041996, 672668, 1122828, 1131140, 1139252, 467588, 648108, 656076, 680652},
[9151]={55965100270, 59274405886, 56046889198, 852854, 502398, 1117158, 519182, 1075190, 468582, 820878, 837262, 862918, 1065878, 879302, 886774, 894966},
[9152]={300370712, 77043552440, 76898848832, 77041455168, 76894646344, 77035163712, 485416, 1158240, 1026088, 1050304, 625760, 1166432, 609056, 190456, 173040, 559104, 575488, 582664, 181944, 550584},
[9153]={132722, 165450, 116298, 140994, 1082954, 1091098, 67138, 82450, 123410, 410130, 1188410, 75338, 108106, 419402, 427594, 435786},
[9154]={287838308, 633236, 664964, 1041396, 469748, 534092, 542284, 640588, 650332, 657084, 673356, 681548, 688772, 696964, 713708, 721900, 1131468, 705164, 1024532, 1032724},
[9155]={852542, 501366, 517710, 879278, 1026734, 1066574, 1099382, 1115766, 837238, 903878, 510662, 820854, 829046, 1074766, 467518, 1106494, 845390, 861774, 886350, 894542},
[9164]={76894351544, 76932403296, 77068718176, 77041463480, 77044125912, 77069291736, 76921917632, 77041602752, 298281632, 271018656, 123923112, 296759368, 268905128, 160000216, 296194144, 159879264},
[9165]={33639874, 78418889018, 78412597562, 78492338490, 9160435938, 78404192602, 78125338050, 77888358714, 79199029474, 29026814146, 71508773178, 78123240906, 304254434, 308366914, 107089434, 21047986},
[9166]={1125516, 527500, 666724, 264768172, 164106316, 176689228, 289935436, 134688836, 136843340, 138940492, 292170532, 632516, 698412, 1027172, 1043556, 470116, 683148, 658572, 674908},
[9167]={854702, 1116846, 903982, 518854, 1100486, 511014},
[9168]={300368800, 300945472, 301051968, 300380224, 300519488, 268913432, 271010584, 124209944, 121826104, 271585344, 485456, 1158240, 175200, 625760, 494680, 559144, 470104, 583720},
[9169]={132682, 83570, 165490, 304213442, 109194722, 113322026, 279365666, 35729346, 31524898, 104925218, 305115066, 309481026, 76482},
[9170]={525900, 534212, 665164, 1123916, 633956, 640708, 1140460, 698452, 470156, 1133708, 1027212, 1035404, 543716, 673356, 681548, 689732, 1041396, 648892, 657084, 706236},
[9171]={852542, 502766, 518110, 1068014, 1100462, 1116870, 821934, 1108654, 838318, 878198, 1075878, 904342, 510662, 469670, 871438, 830150},
[9172]={300369272, 271010616, 77068726456, 76896448728, 76898857176, 75854467136, 77041602776, 75820626136, 76498292832, 40924016856, 77041447008, 76898545736, 1058856, 608296, 583720, 591912, 180864, 549504, 558424, 566928, 574808, 598656, 616080, 467584},
[9173]={83530, 132682, 1205874, 165450, 427634, 443978, 124490, 68258, 116298, 140514, 1092538, 1082954, 75018, 107746, 410850, 435666},
[9174]={526372, 665644, 1125468, 699484, 633716, 534084, 640580, 689772, 722508, 1025612, 1033796, 1041996, 467468, 541196, 648420, 655884, 672356, 1131108, 1139292, 680580},
[9175]={519190, 852534, 830126, 509558, 1074806, 501246, 1066494, 1099022, 1115646, 468598, 820854, 837238, 895694, 844342, 860726, 877110, 885302, 901686, 1024566, 1106446},
[9176]={1173544, 476856, 470104, 1165904, 608256, 191176, 172920, 180864, 483968, 492160, 549504, 558056, 1057008, 565528, 573720, 581912, 590104, 598296, 614680, 622872},
[9177]={115250, 140754, 1081906, 66058, 131554, 74290, 82442, 410122, 418354, 434698, 452050, 467466, 1091938, 1196882, 106978, 123042, 164002, 426434, 442530, 1024162},
[9184]={77068718296, 77041455288, 76896751800, 608296, 493608, 583720, 1164992, 1058856, 600104, 576608, 550952, 182312, 617088, 624360, 174720, 1025728, 560104, 190024, 591552, 566856},
[9185]={140914, 68266, 1198762, 134162, 412290, 445098, 1206954, 1190570, 125570, 165490, 428714, 85010, 115218, 1082594, 76578, 420666, 437266, 1092386, 109706, 1027210},
[9186]={287836844, 68344614660, 689852, 665156, 1034156, 543356, 534204, 640580, 714668, 1025964, 682980, 1132460, 707196, 697804, 722500, 1139932, 648172, 468548, 656964, 673348},
[9187]={231540974, 830126, 510638, 1074806, 1100462, 1116990, 518854, 821934, 1108774, 502926, 1067718, 838318, 887614, 895806, 861958, 846654, 878702, 1026878, 871590, 912550},
[9188]={76896751800, 77041455168, 76928209080, 1173544, 1050664, 493512, 550856, 575432, 583624, 624584, 1165256, 174024, 1157064, 1058760, 559048, 1025992},
[9189]={116298, 1084426, 139794, 68258, 1092290, 1198906, 445242, 76938, 125754, 166674, 132354, 83202, 412690, 1191050, 420874, 1207098},
[9190]={287836844, 68353003268, 697924, 542276, 722860, 1141372, 1132100, 1025604, 632388, 640580, 534084, 689732, 469268, 707196, 650212, 674188, 681940, 656964, 714308, 1033796},
[9191]={73233049806, 853942, 518950, 1117206, 1067694, 1100462, 502590, 903982, 829006, 510638, 1108678, 895806, 879422, 1026758, 1075886, 821958},
[9192]={300370112, 300518168, 77041152184, 76932509768, 77041553472, 69412016224, 76924096584, 69378175168, 39850275032, 39852658872, 75823009888, 75969818816, 1173176, 1050664, 583720, 1157160, 625760, 190528},
[9193]={35786178, 306269642, 109137378, 33631802, 307277282, 309374434, 304515594, 33622050, 27348898, 304254402, 308358722, 115486178, 132722},
[9194]={526252, 665636, 1124388, 1140772, 697924, 1041988, 542276, 534084, 632388, 640580, 656964, 673348, 706236, 468548, 681540, 689732},
[9195]={218607174, 281873982, 218623934, 231542422, 853582, 1117206, 519190, 502438, 1100822, 879278, 1067694, 510662, 830254, 1076014},
[9196]={300370592, 301050528, 300945472, 300518048, 300378816, 300952256, 300067608, 300501696, 1173544, 493608, 1026088, 591912, 1165352},
[9197]={133802, 1190570, 166570, 84642, 68258, 1206954, 109226, 427634, 412290, 444018, 124530, 76482},
[9198]={526252, 665636, 1124388, 542276, 468548, 534084, 632388, 640580, 656964, 673348, 689732, 697924, 1041988, 681540, 714308, 722500},
[9199]={218605614, 281873862, 286068166, 218623438, 218951142, 225250886, 229445190, 221056582, 1116990, 1100582, 903846, 1067694, 510630, 1108654, 838318, 1026734},
[9200]={300368672, 268914752, 271010584, 77069299776, 76932411488, 77068415072, 77041446976, 76896448584, 39850275032, 76498292832, 37702791384, 76932485184, 478296, 300388416, 271584032, 296751176, 269021256, 296757952, 268987072, 269052608},
[9201]={78418889018, 79226292418, 79226341570, 78416826106, 71433268906, 78660110650, 71445850002, 9160444130, 77888301402, 78125280602, 77888366938, 78425164122, 119615130, 305172082, 277237394, 276950666},
[9202]={526012, 170502820, 534572, 542404, 640708, 689860, 1027172, 1033924, 1042116, 1123916, 1140420, 698412, 470116, 1132620, 682068, 657492},
[9203]={218615534, 273485262, 286068798, 281874374, 218951142, 225251366, 132623814, 275228718, 212315598, 229092934, 210217006, 283617326, 501366, 903982, 511126},
[9204]={300369272, 77041463512, 77041602776, 77044125880, 77070823488, 77041586392, 76898857176, 77068415072, 121827400, 122104488, 262621856, 143085632, 478296, 269054032, 269060920, 298289856},
[9205]={78416784178, 18288541255234, 20282186270386, 18350283507394, 18290147665586, 20143975556826, 18288537061018, 20092949693778, 20000094152042, 19999557281498, 2345081579154, 20133309392234, 42020466, 304212090, 18942194, 119615690},
[9206]={527500, 534212, 632868, 666364, 698412, 1042476, 1125116, 689860, 1140772, 640708, 470116, 542764, 658572, 683148, 715916, 724108},
[9207]={218623438, 218607078, 286068734, 218615822, 853622, 286281846, 286322326, 518822, 904342, 1117198, 1066638, 510046},
[9208]={1172464, 271010608, 121826104, 31186923712, 75854467256, 76506673344, 76506828992, 76507230400, 31186931904, 76507254976, 31797211352, 76532428896, 493600, 550944, 559144, 575520, 582640, 590832, 566976, 599744, 173040, 467944, 484336, 616128},
[9209]={78418879442, 78418888930, 79199062834, 71445891850, 78125321810, 71433275674, 71680731890, 71439568610, 78488152410, 78502766938, 78660045114, 78414686554, 132682, 435826, 452210, 1025610, 426554, 442938, 108106, 419402, 66066, 123410, 164370, 410130},
[9210]={525980, 1041884, 632444, 665644, 542764, 1124396, 656820, 696740, 714164, 722356, 1024420, 468316, 639396, 647588, 680356, 704708, 532900, 672164, 688548, 1032684},
[9211]={218604294, 229442190, 218621990, 218613974, 218933462, 231542342, 286068294, 281873982, 1075886, 468598, 821934, 837238, 877118, 1024574, 1065526, 1106494, 845390, 861774, 886350, 912406},
[9212]={300368792, 300952224, 300945472, 300386984, 301050648, 300501816, 300452664, 300083992, 121811016, 298281632, 122105928, 269062216, 149385280, 159877920, 271560776, 296169536},
[9213]={304221666, 78662215994, 77888366786, 79227292346, 9160484986, 71680741034, 79226276538, 78496475194, 26877216906, 71512960906, 77955419714, 78962051106, 119672290, 104943074, 42019026, 279367730},
[9214]={526372, 1125468, 665644, 468548, 534564, 542276, 632388, 640700, 657444, 682020, 690212, 697924, 714788, 722980, 1025604, 1033924},
[9215]={855062, 1117326, 519190, 1100822, 904342, 511126, 830614, 502438},
[9216]={1173536, 121827400, 298274880, 155668064, 271585344, 124210784, 121811016, 122105928, 126308416, 159862368, 262623296, 300074360, 298283072, 296751296, 271109832},
[9217]={78662217458, 78418921810, 78662503978, 78662159914, 79227301314, 78412590610, 78416825138, 278997242, 70902746690, 70909046058, 9158340138, 78125369386, 306252314, 276967562, 29437610, 279056434},
[9218]={525932, 1042516, 665276, 698044, 1124028, 1132220, 632548, 469028, 542756, 1140412, 1026084, 1033916, 706244, 648900, 658204, 682068},
[9219]={853614, 231188718, 130526862, 285724798, 212314350, 281521734, 132631262, 285732982, 281530494, 229101694, 902902, 511126},
[9220]={76894367960, 76894646344, 76898848832, 76917721680, 76919820352, 76921917504, 1173528, 477216, 298848320, 271583800, 269021256, 268906560, 552024, 1026080, 486496, 1158240, 625760, 609376, 175200, 560224},
[9221]={140874, 117410, 67178, 412322, 468586, 445058, 1198722, 1189482, 125570, 165482, 1026722, 76458, 133762, 83570, 1084098, 420898},
[9222]={525892, 542756, 632508, 658524, 665276, 683100, 698404, 715868, 724060, 1027164, 1042108, 1132580, 469628, 535172, 641780, 649972, 1123876, 1140116, 674548, 689852},
[9223]={59274405958, 59274422150, 70024759222, 55967198774, 55965101622, 70011825638, 852526, 517750, 1067694, 903982, 1100582, 1107534, 837198, 895622, 1115718, 886382, 871078, 1076246},
[9224]={300368848, 300945312, 300363840, 300920896, 300387128, 271010464, 149375648, 296176288, 300519496, 298273440, 121825960, 121809576, 1050664, 271019944, 262720168, 296251456, 1173424, 477104, 470104, 493632},
[9225]={306350114, 33638442, 305180130, 113330218, 35719202, 306261474, 304212002, 109217826, 119950794, 262614498, 280006706, 104974546, 1189490, 165482, 468594},
[9226]={526340, 665164, 1124036, 1034284, 1042516, 470116, 632908, 699532, 1027212, 534572, 542644, 641060, 658524, 673828, 682060, 689740, 714828, 723020},
[9227]={853622, 501366, 518830, 1116846, 510662, 1075910, 1067694, 904238, 469702, 821958, 1100590, 1108798},
[9228]={76932403272, 77068718296, 77070823488, 77069291592, 77068726488, 76932410168, 77041150624, 270725024, 271141200, 155364120, 268995360, 297986560, 485080, 1058488, 624312, 190136, 1156792, 1050688, 173752, 608200},
[9229]={35737146, 279064002, 309374890, 306326978, 306269826, 308424282, 309481386, 109137498, 133826, 109170426, 304197570, 115756634, 85034, 429066, 109578, 453642},
[9230]={170396476, 287836508, 267004700, 533124, 1132348, 468548, 542276, 632388, 640580, 657084, 673348, 681540, 647812, 688772, 697572, 705156, 1024500, 1139188, 713292, 721540},
[9231]={286068774, 231542902, 281873990, 57663793350, 56051084046, 56044793486, 852542, 1100846, 1116870, 519214, 904342, 830510, 511022, 1076270, 895806, 1068078, 1109038, 863278, 912430},
[9232]={300369304, 77043544136, 77043265752, 77041602776, 77041152216, 77044101192, 76932411608, 77068726488, 298274880, 121827400, 39879921728, 75969818840, 155668544, 271583912, 126308416, 268922944},
[9233]={20137524667754, 71424879290, 18290153997914, 18350283491858, 20281945032362, 20143975548634, 20137059108570, 2345073190490, 20144042673882, 20274972050794, 20095187363538, 18306258028122, 78123232818, 29022563802, 70986665410, 77965889498},
[9234]={266865348, 170395844, 287836844, 264769636, 665644, 1124396, 1042476, 633956, 1140780, 543884, 699532, 534212, 470156, 1133700, 648788, 706132},
[9235]={231541366, 218605638, 286068294, 218615822, 854702, 130527254, 132632510, 904342, 283635646, 286109694, 282095630, 273461334},
[9236]={300369264, 300953664, 300386976, 300945480, 77068726488, 76932534368, 77070527096, 76921909432, 159862848, 121811016, 69414121264, 76504600336, 268931136, 147279936, 262623296, 269053560},
[9237]={78662216498, 78662241050, 78418890290, 78416791586, 78412589634, 78662193194, 79226341498, 77888300986, 78402095554, 306327546, 42019066, 33630458, 304253162},
[9238]={526372, 1125516, 666764, 267006028, 170414148, 170504260, 170405956, 290074700, 470108, 698404, 1027164, 1141852, 1035404, 642188, 691340, 674916},
[9239]={218605614, 231540974, 218614014, 218622494, 286067294, 281872430, 130525422, 286314606, 285724318, 281538574, 132632742, 132624374, 903270, 231582462, 275558566, 212634342},
[9240]={300368304, 300953504, 301060160, 300519488, 301051968, 300363840, 300945472, 300920896, 478296, 155668544, 76361690624, 17770014222816, 149377088, 147279936, 143085632, 298291160},
[9241]={78662215338, 78412589370, 71439550354, 71437502354, 79226374338, 78660102458, 78660405562, 77882001298, 71523444626, 77879920674, 71517153170, 9160444578, 42019066, 29445698, 276909634, 304220762},
[9242]={526012, 1043228, 665644, 632548, 1125476, 699492, 1133700, 469028, 543836, 658524, 1026084, 1140772, 534572, 641068, 674916, 690220},
[9243]={218605606, 218621990, 218614382, 286068294, 281872430, 218933870, 218951142, 275581526, 902902, 281520166, 285716030, 273148526, 853614, 501366, 510766},
[9244]={300368672, 301050656, 300952344, 77070962760, 77071364168, 76892270656, 77041561672, 76898545736, 608288, 616152, 575160, 599768, 181944, 550584, 485048, 558776, 493240, 583352, 591544, 566968},
[9245]={117442, 1083018, 142098, 68626, 76818, 412322, 1198034, 85002, 420546, 470034, 1189850, 436906, 445450, 1207306, 1092738, 109578, 125962, 166922, 429066, 134154},
[9246]={527092, 632396, 664196, 672388, 688772, 696964, 1024644, 1041028, 1139332, 468908, 534444, 542276, 647812, 705516, 713228, 1032716, 1130932, 680940, 1122828, 640580},
[9247]={852534, 510630, 830126, 1075878, 903854, 500758, 1100814, 518102, 896134, 1116118, 1068046, 821926, 1107926, 837590, 862166, 886742, 468950, 846622, 871438, 878550},
[9248]={76924014656, 77041455320, 77070815416, 76896751800, 77043552320, 76894367816, 1173064, 1059816, 486136, 1165352, 476856, 625400, 609056, 1155720, 173760, 181952, 468592, 493248, 550592, 558784},
[9249]={84650, 133802, 1190530, 166530, 125610, 469634, 67146, 116322, 140874, 1082954, 1091506, 1197562, 75338, 108106, 411210, 420522},
[9250]={524932, 534372, 632468, 664964, 1043356, 1123796, 468668, 542396, 657092, 681660, 689780, 698044, 714388, 722580, 1024644, 1033604, 1132300, 639628, 649060, 672396},
[9251]={56046889278, 73233049798, 72159307974, 517750, 1067654, 1115766, 1099382, 511022, 1108678, 1076270, 912046, 904238, 468558, 820854, 837198, 845430, 861814, 878198, 886710, 894542},
[9252]={76917720040, 76894351544, 76894367928, 76894646368, 76898847112, 76919820072, 1172456, 477128, 297988168, 1058840, 1026112, 1050688, 608320, 624704, 583744, 485440, 1157184},
[9253]={279064130, 42085834, 35728962, 304229834, 109193378, 84674, 68258, 133826, 1199082, 1206954, 469666, 109226, 411274, 125602, 444042, 453290},
[9254]={1042076, 468548, 525892, 632388, 697924, 723700, 1025604, 1132460, 1140292, 542636, 1123908, 535284, 664964, 656964, 681540, 690932, 640012, 648860, 672300, 706012},
[9255]={59274405766, 55965099950, 852542, 1116990, 517774, 1066638, 1100782, 896142, 511126, 830238, 1076238, 1109006, 469102, 1026038, 871438, 821342},
[9272]={300369152, 300944152, 77070831416, 77068726488, 77035155648, 76930298048, 69412016192, 76820951224, 69405724736, 75969810616, 69416210496, 69518970944, 298848320, 75967819848, 19555133393584, 10485749705176, 126300352, 298412600, 268987072, 296184512},
[9273]={306261474, 78416791898, 10773186906, 78496516442, 78660102458, 9160444130, 26885630146, 71523444626, 78125271858, 78955759818, 77888292794, 71666050962, 304214010, 277295098, 277237754, 304508858},
[9274]={526372, 665644, 469028, 534612, 632508, 657452, 690220, 698404, 714796, 722988, 1026084, 1042148, 542764, 641068, 682028, 1034284},
[9275]={218605606, 218621998, 286068286, 273485374, 281873982, 218613974, 283618790, 212314158, 275228718, 283635270, 286313958, 273149510, 853622, 510662, 904230, 502470},
[9276]={77070815088, 1174568, 1050568, 1025992, 1059640, 476888, 469056, 494752, 486560, 616120, 1166496, 550584, 584864, 182304, 576672},
[9277]={1198066, 165514, 83674, 132826, 1091530, 469658, 142314, 68290, 412354, 76410, 117370, 1190594, 125634, 445090, 1084042, 436866},
[9278]={527372, 1042540, 633644, 1132276, 707748, 698100, 543396, 650404, 1141924, 683172, 1025780, 658596, 1125044, 715444, 723636, 666292, 468684, 534148, 642060, 674980},
[9279]={853606, 518854, 1116990, 1067718, 502430, 1100902, 896014, 510766, 904342, 1076390, 830206, 470182, 822438, 1108678, 838342, 887614, 846654},
[9280]={300369296, 77043559864, 77043683176, 77068431328, 77068832936, 76932100264, 77041602704, 77070823472, 76391337928, 75820625976, 69525262480, 31186922128, 300454072, 268914832, 271010128, 124211384},
[9281]={78416793178, 20137600206138, 20137767970090, 20094109492282, 19937808729354, 20274965718282, 20274951038218, 7568302875914, 20136981514266, 19937808680250, 18308929758794, 20143975515514, 77965953114, 78492273370, 78953695482, 79029160162},
[9282]={665316, 266864716, 287836236, 267004660, 170395724, 264767724, 164105868, 136841292, 1123948, 673364, 689788, 1140308, 534140, 1132260, 681556, 542292},
[9283]={218606126, 286068934, 281874630, 218624094, 58737880454, 58737864830, 59274414446, 57663803518, 855014, 286109886, 285733054, 59186327342, 212332662, 281898950, 283619014, 282095822},
[9284]={300370152, 159860992, 77069289936, 77068863952, 77068708304, 76359879112, 76506679752, 476752, 300476672, 75818527152, 19585734731960, 19585636149400, 271585280, 295880960, 271116896, 126299808},
[9285]={304173202, 78488152170, 78662158970, 78687382914, 78687317514, 78418938490, 78425172618, 78416784010, 78418873866, 119623746, 104933418, 276910146, 304254642},
[9286]={526436, 535220, 690868, 699060, 715444, 1026740, 1125044, 1141428, 1034932, 469684, 1043468, 1132276, 666756, 674844, 650388, 543772},
[9287]={502894, 519286, 1117294, 273485902, 218615886, 275247222, 231542854, 218935374, 281538734, 283971654, 229109854, 273141838, 511118, 904334, 1076366},
[9288]={300370152, 159860992, 77069289936, 77068863952, 77068708304, 76359879112, 76506679752, 476752, 300476672, 75818527152, 19585734731960, 19585636149400, 271585280, 295880960, 271116896, 126299808},
[9289]={304173202, 78488152170, 78662158970, 78687382914, 78687317514, 78418938490, 78425172618, 78416784010, 78418873866, 119623746, 104933418, 276910146, 304254642},
[9290]={526436, 535220, 690868, 699060, 715444, 1026740, 1125044, 1141428, 1034932, 469684, 1043468, 1132276, 666756, 674844, 650388, 543772},
[9291]={502894, 519286, 1117294, 273485902, 218615886, 275247222, 231542854, 218935374, 281538734, 283971654, 229109854, 273141838, 511118, 904334, 1076366},
[9292]={476864, 77068709984, 77068816600, 77068824792, 77069299808, 77068734560, 19729622427952, 298420256, 69525252208, 69416323000, 76395538544, 76395227480, 121817120, 140986400, 269019176, 269461544},
[9293]={85010, 304254882, 304558074, 304222114, 304156578, 304214010, 304517114, 119951274, 305115130, 113332130, 306352122, 277237754, 308357178},
[9294]={666764, 526412, 267006020, 170405956, 264908868, 287977540, 288354372, 170504260, 543724, 674556, 690220, 683108, 469036, 641108, 657492, 698412},
[9295]={501366, 273485742, 855062, 518110, 1100822, 1116126, 1068054, 470038, 510990, 1027094, 838678, 1076238, 904206, 822286},
[9312]={476864, 77068709984, 77068816600, 77068824792, 77069299808, 77068734560, 19729622427952, 298420256, 69525252208, 69416323000, 76395538544, 76395227480, 121817120, 140986400, 269019176, 269461544},
[9313]={85010, 304254882, 304558074, 304222114, 304156578, 304214010, 304517114, 119951274, 305115130, 113332130, 306352122, 277237754, 308357178},
[9314]={666764, 526412, 267006020, 170405956, 264908868, 287977540, 288354372, 170504260, 543724, 674556, 690220, 683108, 469036, 641108, 657492, 698412},
[9315]={501366, 273485742, 855062, 518110, 1100822, 1116126, 1068054, 470038, 510990, 1027094, 838678, 1076238, 904206, 822286},
[9320]={300369296, 77043559864, 77043683176, 77068431328, 77068832936, 76932100264, 77041602704, 77070823472, 76391337928, 75820625976, 69525262480, 31186922128, 300454072, 268914832, 271010128, 124211384},
[9321]={78416793178, 20137600206138, 20137767970090, 20094109492282, 19937808729354, 20274965718282, 20274951038218, 7568302875914, 20136981514266, 19937808680250, 18308929758794, 20143975515514, 77965953114, 78492273370, 78953695482, 79029160162},
[9322]={665316, 266864716, 287836236, 267004660, 170395724, 264767724, 164105868, 136841292, 1123948, 673364, 689788, 1140308, 534140, 1132260, 681556, 542292},
[9323]={218606126, 286068934, 281874630, 218624094, 58737880454, 58737864830, 59274414446, 57663803518, 855014, 286109886, 285733054, 59186327342, 212332662, 281898950, 283619014, 282095822},
[9324]={300369152, 300945472, 77041561672, 77043544248, 77070831416, 76892254424, 77035303128, 19729593068192, 40951566400, 68877373232, 37721952248, 76361985840},
[9325]={19939421398738, 5144347563590018, 5120022494126738, 5155224582963682, 5143935783600266, 5155071033671818, 5144074298401402, 5156857742213514, 4687366264520802, 77879922146, 70971895266, 79224236794, 30643709834},
[9326]={178786380, 138940492, 68447375300, 527372, 665644, 1125476, 699484, 1043596, 1133708, 633996, 470156, 543884, 1141892},
[9327]={218621990, 231540982, 286066934, 218606110, 218613830, 273149510, 281872990, 231188718, 275581174, 132632038, 286320854, 231155958, 273500702, 212324406},
[9328]={1173544, 477176, 1157160, 271585352, 271559336, 298420896, 298281632, 119713856, 269045832, 123923136, 126020264, 159976128, 180864, 549504, 557584, 565888, 573728, 581920, 598616, 615000, 172200, 467152, 491800, 590104},
[9329]={83570, 35786210, 308424162, 304220194, 306350114, 308448706, 113379370, 33679394, 306327010, 42084386, 308710882, 309472834, 115258, 1091218, 1081914, 66066, 73898, 106666, 409770, 418002, 434658, 450730, 467114, 1024170},
[9331]={501366, 853974, 829006, 894494, 508798, 1074046, 516550, 1097942, 467478, 819766, 836118, 844310, 860374, 876758, 884950, 1024214, 1065134, 1106134, 1114286, 901646},
[9332]={300370592, 300920904, 300387128, 271011904, 121827400, 300444472, 155668544, 298848320, 298283072, 268906560, 268921536, 271585352, 477216, 269013056, 300510008, 126316616},
[9333]={77888358746, 77888301282, 78662152034, 78125369658, 77888309594, 78425164122, 77888366938, 304507090, 33631858, 31535034, 18943626, 276909714},
[9334]={287838276, 170397796, 632556, 1043236, 699484, 535652, 1026092, 542764, 1133668, 642148, 658532, 1140780, 469076, 683148, 1035404, 691340},
[9335]={231542414, 853622, 519190, 273133030, 212316182, 273452518, 273468902, 1115766, 903982, 510662, 502438, 1100486},
[9336]={300372032, 300945472, 300363840, 77070952856, 77070962904, 77069267128, 77041585912, 76921934008, 69382655992, 268914752, 301050560, 149377088, 126308016},
[9337]={20143975506938, 5144781372072874, 5156914187018858, 706031439119114, 5156918410674994, 5156917949399162, 5156917882232986, 5155206864110106, 2007853743276770, 77953403434, 70980283834, 78108494394, 30706576810},
[9338]={68317294348, 526020, 699132, 470148, 632908, 1133700, 1027204, 1141900, 665644, 543884},
[9339]={55967205990, 218933462, 275581174, 231205102, 231188718, 273483822, 56046856110, 57127258310, 72608098222, 73144970894, 73287583678, 72610195574, 286279766, 275245294, 231583406, 281923310},
[9340]={300370152, 159860992, 77069289936, 77068863952, 77068708304, 76359879112, 76506679752, 476752, 300476672, 75818527152, 19585734731960, 19585636149400, 271585280, 295880960, 271116896, 126299808},
[9341]={304173202, 78488152170, 78662158970, 78687382914, 78687317514, 78418938490, 78425172618, 78416784010, 78418873866, 119623746, 104933418, 276910146, 304254642},
[9342]={526436, 535220, 690868, 699060, 715444, 1026740, 1125044, 1141428, 1034932, 469684, 1043468, 1132276, 666756, 674844, 650388, 543772},
[9343]={502894, 519286, 1117294, 273485902, 218615886, 275247222, 231542854, 218935374, 281538734, 283971654, 229109854, 273141838, 511118, 904334, 1076366},
[9344]={476864, 77068709984, 77068816600, 77068824792, 77069299808, 77068734560, 19729622427952, 298420256, 69525252208, 69416323000, 76395538544, 76395227480, 121817120, 140986400, 269019176, 269461544},
[9345]={85010, 304254882, 304558074, 304222114, 304156578, 304214010, 304517114, 119951274, 305115130, 113332130, 306352122, 277237754, 308357178},
[9346]={666764, 526412, 267006020, 170405956, 264908868, 287977540, 288354372, 170504260, 543724, 674556, 690220, 683108, 469036, 641108, 657492, 698412},
[9347]={501366, 273485742, 855062, 518110, 1100822, 1116126, 1068054, 470038, 510990, 1027094, 838678, 1076238, 904206, 822286},
[9348]={300370152, 159860992, 77069289936, 77068863952, 77068708304, 76359879112, 76506679752, 476752, 300476672, 75818527152, 19585734731960, 19585636149400, 271585280, 295880960, 271116896, 126299808},
[9349]={304173202, 78488152170, 78662158970, 78687382914, 78687317514, 78418938490, 78425172618, 78416784010, 78418873866, 119623746, 104933418, 276910146, 304254642},
[9350]={526436, 535220, 690868, 699060, 715444, 1026740, 1125044, 1141428, 1034932, 469684, 1043468, 1132276, 666756, 674844, 650388, 543772},
[9351]={502894, 519286, 1117294, 273485902, 218615886, 275247222, 231542854, 218935374, 281538734, 283971654, 229109854, 273141838, 511118, 904334, 1076366},
[9352]={476864, 77068709984, 77068816600, 77068824792, 77069299808, 77068734560, 19729622427952, 298420256, 69525252208, 69416323000, 76395538544, 76395227480, 121817120, 140986400, 269019176, 269461544},
[9353]={85010, 304254882, 304558074, 304222114, 304156578, 304214010, 304517114, 119951274, 305115130, 113332130, 306352122, 277237754, 308357178},
[9354]={666764, 526412, 267006020, 170405956, 264908868, 287977540, 288354372, 170504260, 543724, 674556, 690220, 683108, 469036, 641108, 657492, 698412},
[9355]={501366, 273485742, 855062, 518110, 1100822, 1116126, 1068054, 470038, 510990, 1027094, 838678, 1076238, 904206, 822286},
[9356]={300371584, 300944160, 300378816, 300388544, 300921024, 300478656, 301060168, 300519616, 486520, 1158264, 1059960, 173784, 1050328, 625784, 470176, 608336},
[9357]={165514, 84674, 132746, 124514, 1189474, 1198722, 68250, 76418, 412346},
[9358]={526012, 1043620, 1125468, 665636, 1141924, 543908, 1035428, 1133732, 470180, 699556, 1027236, 683172, 534092, 632388, 640700, 689740, 649324, 657084, 673508, 706244},
[9359]={853646, 519190, 469702, 821958, 1100486, 1107958, 501390, 895686, 1115910, 1075910, 846534, 1066598, 879302, 1026758, 870030, 912430},
[9360]={300368672, 301050560, 300952256, 271010464, 121825960, 300518176, 155667104, 121811016, 159862368, 1166024, 484936, 1050176, 1025720, 616000, 492160, 599616, 549504, 574088, 582160, 181824, 566848},
[9361]={117418, 141354, 1084074, 67138, 1092178, 75730, 1188770, 1205154, 107426, 426874, 125962, 166922, 1198346, 418682, 410442, 435098, 443210, 82090, 131242, 1024482},
[9362]={526012, 633596, 665324, 288352932, 467948, 533124, 541676, 639620, 648860, 656004, 673116, 680580, 689340, 697532, 714148, 722340, 705116, 1024484, 1032604, 1130668},
[9363]={286067294, 273485814, 218624014, 218614302, 231540982, 829406, 501758, 1075846, 1098302, 821926, 1107926, 893862, 836150, 860694, 885310, 844310, 877110, 1024566, 467510, 869278},
[9364]={1173216, 469784, 494360, 584472, 1050176, 552064, 1166464, 1026840, 576280, 1156832, 485088, 476896, 181984, 617200, 173792, 624352},
[9365]={116650, 67138, 141226, 75330, 1084026, 419754, 1197994, 468546, 411202, 436138, 443970, 1189442, 1207266, 109538, 124482, 165442},
[9366]={525892, 632388, 697924, 1043548, 666716, 542276, 1140292, 1025604, 1123908, 706172, 469668, 722540, 534084, 640940, 658404, 673348, 1032836, 1131500, 648772, 681540},
[9367]={853934, 509630, 902742, 1074758, 518846, 829134, 1107886, 870318, 501798, 837550, 1116078, 468550, 1066582, 820806, 1025966, 894894},
[9368]={300370440, 300944032, 300388416, 271011904, 300363848, 298274880, 300378912, 268914760, 124211272, 268921512, 122105920, 624720, 1027208, 1157200, 583760, 175200, 575568, 616512, 550976},
[9369]={68226, 132722, 165450, 411210, 445058, 1189490, 124650, 1206954, 1026690, 83570, 420546, 76482, 1083018},
[9370]={527092, 633956, 1043556, 699132, 1133668, 543844, 658532, 724068, 535652, 665324, 683108, 690260, 707676, 1026804, 641780, 1124988, 469436, 1139700, 648900, 673476},
[9371]={854702, 518110, 1075886, 510998, 468958, 501366, 820854, 837238, 878198, 886390, 895662, 1025654, 1065558, 1099342, 1107574, 1115766},
[9372]={77068717664, 76894366360, 76896750160, 77043550360, 76932402904, 77070813816, 77044124304, 19730268653784, 5013979338850824, 19694155385376, 9653060807176, 10208722496152},
[9373]={20137526765458, 4687382381142250, 5119886663697314, 5104491342922666, 5155089362854722, 5155225658835882, 5155090902106946, 5154106274554794, 4686557759996098, 5192062056079378, 1906973551428538, 5119943045678010},
[9374]={162009156, 170397764, 178786372, 68447374628, 68445277476, 73818180940, 68317293868, 43625483596, 19034939238804, 19172363355444, 19149819078548, 19172377961780},
[9375]={59274406270, 231540822, 218613974, 73287928126, 56048986038, 56046905462, 72700725134, 70559534966, 73298079142, 72213843614, 58731244078, 70024375982},
[9376]={300370712, 77068718264, 76894351576, 77043552280, 76896751800, 76919820352, 76932116664, 77041561672, 77070830224, 17769477655120, 126308296, 40387424008},
[9377]={20137526764906, 20137524675946, 5156918419071834, 600340886003818, 5192240465002858, 5192196735181178, 5108889938895346, 5155268608459234, 77879920674, 8610983578},
[9378]={73818181420, 526372, 1125476, 665644, 267004588, 288353060, 178925644, 287975628, 288010308, 170404516, 170502340, 699532, 134688844, 138940484, 290443484},
[9379]={55965099950, 231541342, 218621990, 218933870, 286066934, 72751056774, 58742082118, 72171891246, 59188422702, 33953393198, 72071229070, 70561278510, 286116094, 286314526, 212331238, 273139966},
[9380]={1173080, 271010080, 121825856, 298274816, 300074304, 300442944, 298283216, 269054128, 126300368, 296759472, 159879344, 269021344},
[9381]={306327074, 306251922, 306628754, 306613794, 78661003434, 78412623338, 26885629970, 26879264754, 71435364458, 71445850618, 9160484850, 77965961378, 113322690, 21049290, 304220290, 304171794},
[9382]={1043572, 527148, 665700, 699180, 633644, 1025788, 1132284, 542460, 657148, 714732, 673892, 1141548, 468612, 681604, 689908, 707740},
[9383]={853598, 273483926, 229443766, 218605742, 286066870, 218613910, 218622086, 283969718, 231205206, 130525286, 286117854, 284184070, 517726, 275622190, 281888902, 281489470},
[9384]={77043552440, 77041455168, 76896751800, 77068718144, 76932403264, 76894351432, 268922944, 76928290912, 68868862048, 76507254968, 69525409888, 75967410392, 40389521152, 38781020880, 75856259496, 75858374872},
[9385]={77879920954, 20281945040554, 20073087575402, 20000167560458, 20137063351994, 20137059157690, 18308929758962, 5192239760416882, 5192040501560146, 4681864948285858, 5192102778585138, 4686676932756002, 77961710386, 30620585986, 70980341218, 10756361642},
[9386]={1125516, 287836844, 170396332, 287976108, 264768292, 534572, 665636, 632516, 1140820, 1035044, 690260, 640748, 526012},
[9387]={218605614, 286068166, 281872422, 225250878, 218951142, 218934902, 218925598, 275582638, 130526862, 286314134, 132632510, 285733022, 904350, 511014, 273533142, 275558534},
}
