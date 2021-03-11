local U, _, T = {}, ...
local EV = T.Evie
local L = newproxy(true) do
	local LT = T.LT or {}
	getmetatable(L).__call = function(_, k)
		return LT[k] or k
	end
end
T.Util, T.L, T.LT = U, L, nil

local overdesc = {
	[ 25]={L"Inflicts {} damage to all enemies in melee, and increases own damage dealt by 20% for three turns.", "damageATK"},
	[ 52]={L"Inflicts {} damage to all enemies at range.", "damageATK"},
	[ 85]=L"Reduces the damage taken by the closest ally by 5000% for two turns.",
	[107]={L"Debuffs all enemies, dealing {} damage this turn and during each of the next three turns.", "damageATK",
	       L"Increases all damage taken by the nearest enemy by {} for three turns.", "plusDamageTakenATK"},
	[121]={L"Reduces all enemies' damage dealt by {}% during the next turn.", "modDamageDealt"},
	[125]={L"Inflicts {} damage to a random enemy.", "damageATK"},
	[194]={L"Increases damage dealt by the closest ally by {} for two turns.", "plusDamageDealtATK",
	       L"Reduces all damage taken by the closest ally by {}% for two turns.", "modDamageTaken",
	       L"Inflicts {} damage to self.","damageATK"},
	[227]={L"Every other turn, a random enemy is attacked for {}% of their maximum health.", "damagePerc"},
	[242]={L"Heals the closest ally for {}.", "healATK",
	       L"Increases all damage taken by the closest ally by {}% for two turns.", "modDamageTaken"},
	[251]={L"Reduces all enemies' damage dealt by {}% for two turns.", "modDamageDealt"},
	[301]={L"Every other turn, a random enemy is attacked for {}% of their maximum health.", "damagePerc"},
}
local overdescUnscaledKeys = {damagePerc=1, modDamageDealt=1, modDamageTaken=1}
local covenFastHealingTalentID = {1078, 1081, 1075, 1084}

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
	local TP = T.VSim.TP
	local board, tm, isForked = GetMaskBoard(boardMask), 0, false
	for i=si.type and 0 or 1,#si do
		local ei = si[i] or si
		local eit = ei and ei.target
		if eit then
			isForked = isForked or TP.forkTargetMap[eit]
			local ta = TP.GetTargets(casterBoardIndex, TP.forkTargetMap[eit] or eit, board)
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
	local t = si.type
	local on, off = "|TInterface/Minimap/PartyRaidBlipsV2:8:8:0:0:64:32:0:20:0:20:255:120:0|t", "|TInterface/Minimap/PartyRaidBlipsV2:8:8:0:0:64:32:0:20:0:20:80:80:80|t"
	if t == "heal" or t == "nuke" or t == "nukem" or (si.duration and si.duration <= 1 and si.echo) then
		if si.echo then
			return on .. (off):rep(si.echo-1) .. on
		end
	elseif (t == "heal" or t == "nuke") and (si.duration and si.duration > 1) then
		return on .. (off):rep(si.duration-1)
	elseif t == "aura" then
		local r, p = (si.noFirstTick or si.period) and off or on, si.period or 1
		for i=2, si.duration do
			r = r .. (i % p == 0 and on or off)
		end
		return r
	end
end

do -- Tentative Groups
	local groups, followerMissionID = {}, {}
	local autoTroops = {["0xFFFFFFFFFFFFFFFF"]=1, ["0xFFFFFFFFFFFFFFFE"]=1}
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
	function U.ShowMission(mid, listFrame)
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
			local MP = CovenantMissionFrame.MissionTab.MissionPage
			MP:Show()
			CovenantMissionFrame:ShowMission(mi)
			listFrame:Hide()
			for i=0, g and 4 or -1 do
				local f = g[i]
				if f then
					CovenantMissionFrame:AssignFollowerToMission(MP.Board.framesByBoardIndex[i], GetFollowerInfo(f))
				end
			end
		end
	end
	function U.StoreMissionGroup(mid, gt, disbandGroups)
		if gt and next(gt) ~= nil then
			for _, v in pairs(gt) do
				U.ReleaseTentativeFollower(v, disbandGroups, true)
			end
			groups[mid] = gt
			for _, v in pairs(gt) do
				if not autoTroops[v] then
					followerMissionID[v] = mid
				end
			end
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
	local function nextTent(_, k)
		local mid, g = next(groups, k)
		if mid then
			local nt = 0
			for i=0,4 do
				if autoTroops[g[i]] then
					nt = nt + 1
				end
			end
			return mid, nt
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
		end
		startQueue[mid], startQueueLength = ng, oql + (startQueue[mid] and 0 or 1)
		if oql == 0 then
			queuePing()
		end
		EV("I_MISSION_QUEUE_CHANGED")
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
				repeat
					nl, xp = nl + 1, xp - xpTable[nl]
				until nl < 60 and xp < (xpTable[nl] or 1e6)
				fi.newLevel, fi.xpToNextLevel = nl, xpTable[nl] and (xpTable[nl]-xp) or nil
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
			if mid ~= mi.missionID and not cc then return end
			if not (acr and acr.combatLog and #acr.combatLog > 0) then return end
			if mid == mi.missionID or securecall(error, whineAboutUnexpectedState("Unexpected mission completion", mid, (cc and "C" or "c") .. (ok and "K" or "k")), 2) then
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

function U.GetTimeStringFromSeconds(sec, shorter, roundUp, disallowSeconds)
	local h = roundUp and math.ceil or math.floor
	if sec < 90 and not disallowSeconds then
		return (shorter and COOLDOWN_DURATION_SEC or INT_GENERAL_DURATION_SEC):format(sec < 0 and 0 or h(sec))
	elseif (sec < 3600*(shorter and shorter ~= 2 and 3 or 1) and (sec % 3600 >= 1 or sec < 3600)) then
		return (shorter and COOLDOWN_DURATION_MIN or INT_GENERAL_DURATION_MIN):format(h(sec/60))
	elseif sec <= 3600*72 and not shorter then
		sec = h(sec/60)*60
		local m = math.ceil(sec % 3600 / 60)
		return INT_GENERAL_DURATION_HOURS:format(math.floor(sec / 3600)) .. (m > 0 and " " .. INT_GENERAL_DURATION_MIN:format(m) or "")
	elseif sec <= 3600*72 then
		return (shorter and COOLDOWN_DURATION_HOURS or INT_GENERAL_DURATION_HOURS):format(h(sec/3600))
	else
		return (shorter and COOLDOWN_DURATION_DAYS or INT_GENERAL_DURATION_DAYS):format(h(sec/84600))
	end
end
function U.GetCompanionRecoveryTime(missingShare)
	local fastHealing = C_Garrison.GetTalentInfo(covenFastHealingTalentID[C_Covenants.GetActiveCovenantID()] or 1075)
	return missingShare * (fastHealing and fastHealing.researched and 49600 or 60000)
end
function U.SetFollowerInfo(GameTooltip, info, autoCombatSpells, autoCombatantStats, mid, boardIndex, boardMask, showHealthFooter)
	local mhp, hp, atk, role, aat, level
	autoCombatantStats = autoCombatantStats or info and (info.followerID and C_Garrison.GetFollowerAutoCombatStats(info.followerID) or info.autoCombatantStats)
	if info then
		role, level = info.role, info.level and ("|cffa8a8a8" .. UNIT_LEVEL_TEMPLATE:format(info.level)) or ""
	end
	if autoCombatantStats then
		local s1 = autoCombatSpells and autoCombatSpells[1]
		mhp, hp, atk = autoCombatantStats.maxHealth, autoCombatantStats.currentHealth, autoCombatantStats.attack
		aat = T.VSim.TP:GetAutoAttack(role, boardIndex, mid, s1 and s1.autoCombatSpellID)
	end
	
	GameTooltip:ClearLines()
	GameTooltip:AddDoubleLine(info.name, level or "")

	local atype = U.FormatTargetBlips(GetTargetMask(T.KnownSpells[aat], boardIndex, boardMask), boardMask, " ")
	if atype == "" then
		atype = aat == 11 and " " .. L"(melee)" or aat == 15 and " " .. L"(ranged)" or ""
	else
		atype = "  " .. atype
	end
	GameTooltip:AddLine("|A:ui_adv_health:20:20|a" .. (hp and BreakUpLargeNumbers(hp) or "???") .. (mhp and mhp ~= hp and ("|cffa0a0a0/|r" .. BreakUpLargeNumbers(mhp)) or "").. "  |A:ui_adv_atk:20:20|a" .. (atk and BreakUpLargeNumbers(atk) or "???") .. "|cffa8a8a8" .. atype, 1,1,1)
	if info and info.isMaxLevel == false and info.xp and info.levelXP and info.level and not info.isAutoTroop then
		GameTooltip:AddLine(GARRISON_FOLLOWER_TOOLTIP_XP:gsub("%%[^%%]*d", "%%s"):format(BreakUpLargeNumbers(info.levelXP - info.xp)), 0.7, 0.7, 0.7)
	end

	for i=1, autoCombatSpells and #autoCombatSpells or 0 do
		local s = autoCombatSpells[i]
		GameTooltip:AddLine(" ")
		local si = T.KnownSpells[s.autoCombatSpellID]
		local pfx = si and "" or "|TInterface/EncounterJournal/UI-EJ-WarningTextIcon:0|t "
		local cdt = s.cooldown ~= 0 and (L"[CD: %dT]"):format(s.cooldown) or SPELL_PASSIVE_EFFECT
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

	if showHealthFooter and info and info.status ~= GARRISON_FOLLOWER_ON_MISSION and autoCombatantStats and autoCombatantStats.currentHealth < autoCombatantStats.maxHealth then
		local rt = U.GetCompanionRecoveryTime(1 - (autoCombatantStats.currentHealth/autoCombatantStats.maxHealth))
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("|cffffd926" .. (L"Full recovery in %s"):format(U.GetTimeStringFromSeconds(rt, false, true, true)), 1, 0.85, 0.15, 1)
	end

	GameTooltip:Show()
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
	if not (si and si.type ~= "nop") then
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
	if si.healATK or si.damageATK or si.healPerc or si.damagePerc then
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
function U.GetAbilityDescriptionOverride(spellID, atk)
	local si = T.KnownSpells[spellID]
	if si and si.type == "nop" then
		return L"It does nothing."
	end
	local od = overdesc[spellID]
	if type(od) == "table" then
		local o
		for i=1, #od, 2 do
			local vk = od[i+1]
			local vv = si and si[vk]
			for i=1,si and not vv and #si or 0 do
				vv = vv or si[i][vk]
			end
			local rv = vv and (overdescUnscaledKeys[vk] and (vv < 0 and -vv or vv) or atk and math.floor(vv*(atk or -1)/100)) or ""
			o = (i > 1 and o .. " " or "") .. od[i]:gsub("{}", rv)
		end
		od = o
	end
	return od
end
