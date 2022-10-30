local _, T = ...
local EV, L, U, S = T.Evie, T.L, T.Util, T.Shadows

local Animations = {}
local FollowerList, MissionRewards, BoardEX, CAGHost
local MissionGroup_HoldUpdate

local function GetFollowerInfo(fid)
	local fi = C_Garrison.GetFollowerInfo(fid)
	fi.autoCombatSpells, fi.autoCombatAutoAttack = C_Garrison.GetFollowerAutoCombatSpells(fid, fi.level)
	fi.autoCombatantStats = C_Garrison.GetFollowerAutoCombatStats(fid)
	return fi
end
local function Board_HasCompanion()
	local f = CovenantMissionFrame.MissionTab.MissionPage.Board.framesByBoardIndex
	for i=0,4 do
		local ii = f[i].info
		if ii and not ii.isAutoTroop then
			return true
		end
	end
	return false
end

local function Puck_Up(self)
    self.HealthBar.HealthValue:SetPoint("CENTER", 9, 3)
end

local function Board_GetBaseFollowerInfo(slot, skipTroops, rewardXP, noBoardIndex)
	local f = CovenantMissionFrame.MissionTab.MissionPage.Board.framesByBoardIndex[slot]
	local ii, willLevel = f.info
	if ii and not (skipTroops and ii.isAutoTroop) then
		local acs = C_Garrison.GetFollowerAutoCombatStats(ii.followerID)
		if rewardXP then
			willLevel = not ii.isMaxLevel and ii.xp and ii.levelXP and (ii.xp + rewardXP) >= ii.levelXP
		end
		return {boardIndex=noBoardIndex ~= true and slot or nil, id=ii.followerID, oid=ii.garrFollowerID, stats=acs, auto=f.autoCombatAutoAttack.autoCombatSpellID, spells=f.autoCombatSpells, willLevel=willLevel}
	end
end
local function Board_GetZeroGroup()
	local ff, s0,s1,s2,s3,s4 = CovenantMissionFrame.MissionTab.MissionPage.Board.framesByBoardIndex
	for i=4, 0, -1 do
		s0, s1, s2, s3, s4 = ff[i].info and ff[i].info.garrFollowerID or nil, s0, s1, s2, s3
	end
	return U.GetPartyID(s0,s1,s2,s3,s4) or 0
end
local GetMissionEnemies = U.GetMissionEnemies
local function Board_SetSimResult(sim)
	local rewardXP, lm, ff = MissionRewards and MissionRewards.xpGainL or 0, 0, CovenantMissionFrame.MissionTab.MissionPage.Board.framesByBoardIndex
	if sim and sim.res and sim.res.hadWins and not sim.res.hadLosses then
		rewardXP = MissionRewards and MissionRewards.xpGain or 0
	end
	for i=0,4 do
		local ii = ff[i].info
		if ii and not ii.isAutoTroop and not ii.isMaxLevel and ii.xp and ii.levelXP and (ii.xp + rewardXP) >= ii.levelXP then
			lm = lm + 2^i
		end
	end
	BoardEX:SetSimResult(sim, lm)
end
local function Board_IsEqualToGroup(g)
	local f = CovenantMissionFrame.MissionTab.MissionPage.Board.framesByBoardIndex
	for i=0,4 do
		local ii, gi = f[i].info, g[i]
		if (not ii) ~= (not gi) or (ii and ii.followerID ~= gi.id) then
			return false
		end
	end
	return true
end

local CAG, SetSimResultHint = {} do
	local simArch, simArch2, reSim, state, deadline
	local function GetGroupTags()
		local f = CovenantMissionFrame.MissionTab.MissionPage.Board.framesByBoardIndex
		local mi  = CovenantMissionFrame.MissionTab.MissionPage.missionInfo
		local tag, htag = (mi.missionID) .. ":" .. (mi.missionScalar or 0), ""
		for i=0,4 do
			local ii = f[i].info
			if ii then
				local stats = C_Garrison.GetFollowerAutoCombatStats(ii.followerID)
				tag = tag .. ":" .. i .. ":" .. stats.attack .. ":" .. ii.followerID
				htag = htag .. ":" .. stats.currentHealth
			end
		end
		htag = tag .. htag
		return htag, tag
	end
	local function cmpBoardIndex(a,b)
		return a.boardIndex < b.boardIndex
	end
	local function GetComputedGroupTags(g)
		local mi  = CovenantMissionFrame.MissionTab.MissionPage.missionInfo
		local tag, htag = (mi.missionID) .. ":" .. (mi.missionScalar or 0), ""
		local m = {}
		for i=1,#g do
			m[i] = g[i]
		end
		table.sort(m, cmpBoardIndex)
		for i=1,#m do
			local ii = m[i]
			local stats = ii.stats
			tag = tag .. ":" .. ii.boardIndex .. ":" .. stats.attack .. ":" .. ii.id
			htag = htag .. ":" .. stats.currentHealth
		end
		htag = tag .. htag
		return htag, tag
	end
	local function qdeadline(root)
		return debugprofilestop() > deadline or (root.res.hadLosses and root.res.hadWins)
	end
	local function qdeadlineorloss(root)
		return debugprofilestop() > deadline or root.res.hadLosses
	end
	local function isDone(res, endOnAnyLoss)
		return res and (res.isFinished or ((res.hadWins or endOnAnyLoss) and res.hadLosses))
	end
	local function setupRetry()
		if reSim then
			state.reCount = state.reCount + reSim.res.n
			state[reSim.res.hadLosses and "reLow" or "reHigh"], state.reTry, reSim = state.reTry, nil
		end
		if not (state.reRange and state.reLow < state.reRange) or (state.reHigh and state.reHigh - state.reLow < 2^-11) then
			if state.reHigh then
				state.reFinish = state.reStart + state.reRangeT*state.reHigh
			end
			reSim, state.reTry, state.reLow, state.reHigh, state.reTeam, state.reStart, state.reRange, state.reRangeT = nil
			return
		end
		local rteam, tryRe = state.reTeam
		if not rteam then
			rteam = {}
			for i=1, #state.team do
				local s, d = state.team[i], {}
				for k,v in pairs(s) do
					d[k] = v
				end
				rteam[i], s, d = d, s.stats, {}
				for k,v in pairs(s) do
					d[k] = v
				end
				rteam[i].stats = d
			end
			state.reTeam, tryRe = rteam, state.reRange
		else
			tryRe = (state.reLow + state.reHigh)/2
		end
		for i=1,#rteam do
			local rs, s = rteam[i].stats, state.team[i].stats
			if s.currentHealth < s.maxHealth then
				rs.currentHealth = math.min(s.maxHealth, math.floor(s.currentHealth + tryRe*s.maxHealth+0.5))
			end
		end
		state.reTry, reSim = tryRe, T.VSim:New(state.reTeam, state.enemies, state.espell, state.mid, state.msc)
		return true
	end
	function CAG:GatherMissionData()
		local team, reRange, reRangeT = {}, 0, 0 do
			for i=0,4 do
				local ii, acs = Board_GetBaseFollowerInfo(i)
				if ii then
					team[#team+1], acs = ii, ii.stats
					if acs.currentHealth < acs.maxHealth then
						reRange = math.max(reRange, 1 - acs.currentHealth/acs.maxHealth)
						reRangeT = math.max(reRangeT, acs.minutesHealingRemaining or 0)
					end
				end
			end
		end
		local mi = CovenantMissionFrame.MissionTab.MissionPage.missionInfo
		local me, espell = GetMissionEnemies(mi.missionID)
		reRangeT = reRange > 0 and 60*reRangeT/reRange or nil
		return {team=team, enemies=me, espell=espell, mid=mi.missionID, msc=mi.missionScalar,
			reStart=reRange > 0 and GetServerTime() or nil, reRange=reRange > 0 and reRange or nil, reRangeT=reRangeT, reCount=reRange > 0 and 0 or nil, reLow=0}
	end
	function CAG:Start(overrideDeadline)
		local tag, rtag = GetGroupTags()
		if not state or state.tag ~= tag then
			local os, md = state, CAG:GatherMissionData()
			local isRefresh = os and os.rtag == rtag
			state, md.tag, md.rtag, reSim = md, tag, rtag, nil
			if isRefresh and os.reFinish and md.reStart then
				md.reFinish, md.reStart, md.reRange, md.reRangeT, md.reLow = os.reFinish, nil, nil
			elseif simArch2 and not isRefresh then
				simArch2 = nil
			end
			simArch = T.VSim:New(md.team, md.enemies, md.espell, md.mid, md.msc)
			md.missingSpells, simArch.dropForks = simArch.res.hadMissingSpells, true
			deadline = debugprofilestop() + (overrideDeadline or 40)
			simArch:Run(qdeadline)
			return not isDone(simArch.res) or setupRetry()
		end
		return not (isDone(simArch.res) and not state.reStart)
	end
	function CAG:Run()
		if not simArch then
			return true
		end
		deadline = debugprofilestop() + 12
		if reSim then
			if isDone(reSim.res, true) then
				return not setupRetry()
			else
				reSim:Run(qdeadlineorloss)
			end
		elseif isDone(simArch.res) then
			simArch.outOfDateHealth = GetGroupTags() ~= (state and state.tag)
			return not (simArch.res.hadLosses and setupRetry())
		else
			simArch:Run(qdeadline)
		end
	end
	function CAG:GetResult()
		local rc = state and state.reCount
		if rc and reSim then
			rc = rc + reSim.res.n
		end
		return simArch, state and state.missingSpells, state and (state.reFinish or state.reStart and true) or nil, rc, (state and state.reHigh and state.reHigh*state.reRangeT)
	end
	function CAG:GetCachedResultSim()
		if simArch and not isDone(simArch) and simArch2 and isDone(simArch2) then
			return simArch2
		end
		simArch2 = nil
		return simArch
	end
	function CAG:Reset()
		simArch, simArch2, reSim, state = nil
	end
	function SetSimResultHint(g, sim)
		state = CAG:GatherMissionData()
		local ng = {}
		for slot, ii in pairs(g) do
			local nge = {boardIndex=slot}
			for k,v in pairs(ii) do
				nge[k] = v
			end
			ng[#ng+1] = nge
		end
		state.tag, state.rtag = GetComputedGroupTags(ng)
		simArch, simArch2, state.team, state.missingSpells = sim, sim, ng, sim.res.hadMissingSpells
	end
	EV.GARRISON_MISSION_NPC_CLOSED = CAG.Reset
end
local Tact = {} do
	local state, deadline
	local function cmpFollowerID(a,b)
		return a.followerID < b.followerID
	end
	local function cmppool(a,b)
		if a.troop ~= b.troop then
			return a.troop
		end
		return a.oid < b.oid
	end
	local function GetGroupTags()
		local f = CovenantMissionFrame.MissionTab.MissionPage.Board.framesByBoardIndex
		local mi  = CovenantMissionFrame.MissionTab.MissionPage.missionInfo
		local tag, htag = (mi.missionID) .. ":" .. (mi.missionScalar or 0), ""
		local m = {}
		for i=0,4 do
			local ii = f[i].info
			if ii and not ii.isAutoTroop then
				m[#m+1] = ii
			end
		end
		table.sort(m, cmpFollowerID)
		for i=1,#m do
			local ii = m[i]
			local stats = C_Garrison.GetFollowerAutoCombatStats(ii.followerID) or ii.autoCombatantStats
			tag = tag .. ":" .. i .. ":" .. stats.attack .. ":" .. ii.followerID
			htag = htag .. ":" .. stats.currentHealth
		end
		htag = tag .. htag
		return htag, tag
	end
	local function orderGroupID(gid, zg)
		return gid == 0 and zg or gid == zg and 0 or gid
	end
	local function GetHealthScore(rm)
		return (rm[18] or 0)*5+4-state.cpenalty
	end
	local function interrupt(root, _forkID, _nForks)
		local res = root.res
		state.numFutures = state.numFutures + 1
		if res.hadLosses or debugprofilestop() >= deadline or GetHealthScore(res.min) < state.bestScore then
			return true
		end
	end
	function Tact:Run()
		if not state then
			return true
		end
		deadline = debugprofilestop() + 15
		repeat
			local sim = state.csim
			if not sim then
				local ng, cg = state.nextGroup
				if ng >= state.numGroups then
					state.finished = true
					local g = state.bestGroup and U.GetShuffleGroup(state.pool, state.bestGroup)
					return true, g, state.bestSim, state.bestGroup
				end
				state.nextGroup, cg = ng + 1, orderGroupID(ng, state.zeroGroup)
				local team, numTroops, wmask = U.GetShuffleGroup(state.pool, cg)
				if (state.baseMaxScore - numTroops) > state.bestScore then
					sim = T.VSim:New(team, state.enemies, state.espell, state.missionID, state.missionScalar)
					sim.wmask, sim.dropForks = wmask, true
					state.csim, state.cgroup, state.cpenalty = sim, cg, numTroops
					state.numFutures = state.numFutures + 1
				end
			end
			if sim then
				sim:Run(interrupt)
				if sim.res.hadLosses then
					state.csim = nil
				elseif sim.res.isFinished then
					local h = GetHealthScore(sim.res.min)
					if h > state.bestScore then
						state.bestScore, state.bestGroup, state.bestSim = h, state.cgroup, sim
					end
					state.csim = nil
				end
			end
		until debugprofilestop() > deadline
	end
	function Tact:GatherMissionData()
		local mi = CovenantMissionFrame.MissionTab.MissionPage.missionInfo
		local me, espell = GetMissionEnemies(mi.missionID)
		local pool, maxHP = U.GetPoolTroopBase(), 0 do
			local rewardXP = MissionRewards and MissionRewards.xpGain or 0
			for i=0,4 do
				local fi = Board_GetBaseFollowerInfo(i, true, rewardXP, true)
				pool[#pool+1], maxHP = fi, maxHP + (fi and not fi.willLevel and fi.stats.maxHealth or 0)
			end
			table.sort(pool, cmppool)
		end
		return {missionID=mi.missionID, missionScalar=mi.missionScalar, enemies=me, espell=espell, pool=pool, baseMaxScore=4 + 5*maxHP}
	end
	function Tact:Start()
		if not Board_HasCompanion() then
			return
		end
		local os, ht, it = state, GetGroupTags()
		if os and not (it ~= os.itag or (os.finished and os.htag ~= ht)) then
			return
		end
		state = self:GatherMissionData()
		local ng = 3^(7-#state.pool)
		for i=1, #state.pool-2 do
			ng = ng * (6-i)
		end
		state.numGroups, state.nextGroup, state.bestGroup, state.bestScore = ng, 0, false, -1e12
		state.numFutures, state.htag, state.itag = 0, ht, it
		if os and os.itag == state.itag and os.bestGroup then
			state.zeroGroup = os.bestGroup
		else
			state.zeroGroup = Board_GetZeroGroup()
		end
		self.zeroGroup, self.transferGroup = state.zeroGroup, nil
		return true
	end
	function Tact:IsRunning()
		if state and not state.finished then
			return true, state.nextGroup, state.numGroups, state.numFutures, state.bestGroup
		elseif state and GetGroupTags() == state.htag then
			return false, true, not not state.bestGroup
		else
			return false, false, Board_HasCompanion()
		end
	end
	function Tact:Interrupt()
		if state and state.bestGroup then
			return U.GetShuffleGroup(state.pool, state.bestGroup)
		end
	end
	function Tact:GetBest(g)
		if state and state.bestGroup and state.bestSim then
			g = g or U.GetShuffleGroup(state.pool, state.bestGroup)
			self.transferGroup = state.bestGroup
			return g, state.bestSim
		end
	end
	function Tact:CheckBoard()
		if state and not state.finished and state.itag ~= select(2, GetGroupTags()) then
			state = nil
		end
	end
	function Tact:Reset()
		state = nil
	end
end

local function GenBoardMask()
	local m, MP = 0, CovenantMissionFrame.MissionTab.MissionPage
	for i=0,12 do
		local f = MP.Board.framesByBoardIndex[i]
		if f and f.name and f:IsShown() then
			m = m + 2^i
		end
	end
	return m
end
local function GetIncomingAAMask(slot, bm)
	local r, VS = 0, T.VSim
	local f = CovenantMissionFrame.MissionTab.MissionPage.Board.framesByBoardIndex
	local mid = CovenantMissionFrame.MissionTab.MissionPage.missionInfo.missionID

	local board = U.GetMaskBoard(bm)
	if slot < 5 then
		for _,v in pairs((GetMissionEnemies(mid, true))) do
			local i = v.boardIndex
			local aa = T.KnownSpells[v.auto]
			if aa and VS.GetTargets(i, aa.t, board)[1] == slot then
				r = bit.bor(r, 2^i)
			end
		end
	else
		for i=0, 4 do
			if bm % 2^(i+1) >= 2^i then
				local faa = f[i].autoCombatAutoAttack
				local aa = T.KnownSpells[faa and faa.autoCombatSpellID]
				if aa and VS.GetTargets(i, aa.t, board)[1] == slot then
					r = bit.bor(r, 2^i)
				end
			end
		end
	end

	return r
end
local function Puck_OnEnter(self)
	if not self.name then
		if GameTooltip:IsOwned(self) then
			GameTooltip:Hide()
		end
		return
	end
	local mid = CovenantMissionFrame.MissionTab.MissionPage.missionInfo.missionID
	local bi, bm = self.boardIndex, GenBoardMask()
	local info, acs = self.info
	if bi > 4 then
		for _,v in pairs((GetMissionEnemies(mid, true))) do
			if v.boardIndex == bi then
				info, acs = v, {currentHealth=v.health, maxHealth=v.maxHealth, attack=v.attack}
				break
			end
		end
	end
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	local aa = GetIncomingAAMask(bi, bm)
	local inc = aa and aa > 0 and (HIGHLIGHT_FONT_COLOR_CODE .. L"Incoming attacks:" .. " " .. U.FormatTargetBlips(aa, bm, nil, "240:60:0", true))
	U.SetFollowerInfo(GameTooltip, info, self.autoCombatSpells, acs, mid, bi, bm, false, inc)
	U.AddCombatantSimInfo(GameTooltip, self.boardIndex, (CAG:GetResult()))
	GameTooltip:Show()
	self:GetBoard():ShowHealthValues()
end
local function Puck_OnLeave(self)
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
	self:GetBoard():HideHealthValues()
end
local function EnvironmentEffect_OnEnter(self)
	local info = self.info
	if not info then return end
	local sid = info.autoCombatSpellID
	local pfx = T.KnownSpells[sid] and "" or "|TInterface/EncounterJournal/UI-EJ-WarningTextIcon:0|t "
	local mi = CovenantMissionFrame.MissionTab.MissionPage.missionInfo
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", -8, 0)
	GameTooltip:ClearLines()
	GameTooltip:AddDoubleLine(pfx .. "|T" .. info.icon .. ":0:0:0:0:64:64:4:60:4:60|t " .. info.name, "|cffa8a8a8" .. (L"[CD: %dT]"):format(info.cooldown) .. "|r")
	local guideLine = U.GetAbilityGuide(sid, -1, GenBoardMask(), false)
	local od = U.GetAbilityDescriptionOverride(info and info.autoCombatSpellID, nil, mi and mi.missionScalar)
	local dc = od and 0.60 or 0.95
	GameTooltip:AddLine(info.description, dc, dc, dc, 1)
	if od then
		GameTooltip:AddLine(od, 0.45, 1, 0, 1)
	end
	if guideLine then
		GameTooltip:AddLine(guideLine, 0.45, 1, 0, 1)
	end
	GameTooltip:Show()
end
local function EnvironmentEffect_OnLeave(self)
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end
local function EnvironmentEffect_OnNameUpdate(self_name)
	local ee = self_name:GetParent()
	ee:SetHitRectInsets(0, math.min(-100, -self_name:GetStringWidth()), 0, 0)
end
local function Predictor_OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
	GameTooltip:SetText(ITEM_QUALITY_COLORS[5].hex .. L"Cursed Adventurer's Guide")
	--GameTooltip:AddLine(ITEM_UNIQUE, 1,1,1, 1)
	GameTooltip:AddLine(L"Use: Read the guide, determining the fate of your adventuring party.", 0, 1, 0, 1)
	GameTooltip:AddLine(L'"Do not believe its lies! Balance druids are not emergency rations."', 1, 0.835, 0.09, 1)
	GameTooltip:Show()
end
local function Predictor_ShowResult(self, sim, incompleteModel, recoverUntil, recoverFutures, recoverHighBound)
	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
	local res = sim.res
	local rngModel = res.hadDrops or (res.hadWins and res.hadLosses)
	local inProgress = not res.isFinished and not rngModel
	local oodBuild = not GetBuildInfo():match("^9%.2%.")
	local hprefix = (oodBuild or incompleteModel) and "|TInterface/EncounterJournal/UI-EJ-WarningTextIcon:0|t " or ""
	if inProgress then
		hprefix = hprefix .. "|cffff3300" .. L"Preliminary:" .. "|r "
	end
	if rngModel then
		GameTooltip:SetText(hprefix .. L"Curse of Uncertainty", 1, 0.20, 0)
	else
		GameTooltip:SetText(hprefix .. (sim.won and "|cff00ff00".."|TInterface/RaidFrame/ReadyCheck-Ready:14|t"..L"Victorious" or "|cffff0000".."|TInterface/RaidFrame/ReadyCheck-NotReady:15|t"..L"Defeated"))
	end
	Board_SetSimResult(sim)

	if incompleteModel then
		GameTooltip:AddLine(L"Not all abilities have been taken into account.", 0.9,0.25,0.15)
	end
	if inProgress then
		GameTooltip:AddLine(L"Not all outcomes have been examined.", 0.9, 0.25, 0.15, 1)
	end
	if sim.outOfDateHealth then
		GameTooltip:AddLine(L"Companion health has changed.", 0.9, 0.25, 0.15, 1)
	end
	if incompleteModel or inProgress or sim.outOfDateHealth then
		GameTooltip:AddLine(" ")
	end

	local flavor = nil
	if rngModel then
		GameTooltip:AddLine(L"The guide shows you a number of possible futures. In some, the adventure ends in triumph; in others, a particularly horrible failure.", 1,1,1,1)
		if not incompleteModel then
			flavor = L'"With your luck, there is only one way this ends."'
		end
	else
		local lo, hi, c = res.min, res.max, NORMAL_FONT_COLOR
		local turns = lo[17] ~= hi[17] and lo[17] .. " - " .. hi[17] or lo[17]
		if inProgress and not incompleteModel then
			GameTooltip:AddLine(L"Futures considered:" .. " |cffffffff" .. BreakUpLargeNumbers(res.n or 0), c.r, c.g, c.b)
		end
		if turns then
			GameTooltip:AddLine((sim.won and L"Turns taken: %s" or L"Turns survived: %s"):format("|cffffffff" .. turns .. "|r"), c.r, c.g, c.b)
		end
		if sim.won then
			local troopCount, troopHealth1, troopHealth2, troopHealthMax = 0, 0, 0, 0
			local rewardXP = MissionRewards.xpGain or 0
			for i=0,4 do
				local hmin, hmax = lo[i], hi[i]
				local f = CovenantMissionFrame.MissionTab.MissionPage.Board.framesByBoardIndex[i]
				local e = sim.board[i]
				if f and f.name and f:IsShown() and f.info and hmin and e then
					local fi = f.info
					if fi.isAutoTroop then
						troopCount, troopHealth1, troopHealth2, troopHealthMax = troopCount + 1, troopHealth1 + hmin, troopHealth2 + hmax, troopHealthMax + (e.maxHP or 0)
					else
						local chp = hmin == hmax and hmin or ((hmin == 0 and "|cffff40200|r" or hmin) .. " |cffffffff-|r " .. hmax)
						local isUp = fi.xp and fi.levelXP and not fi.isMaxLevel and (fi.xp + rewardXP) >= fi.levelXP and "|A:bags-greenarrow:0:0|a" or ""
						GameTooltip:AddDoubleLine(f.name .. isUp, chp .. "/" .. e.maxHP, 1,1,1, hmax > 0 and 0 or 1, hmax > 0 and 1 or 0.3, 0.15)
					end
				end
			end
			if troopCount > 0 then
				local hmin, hmax = troopHealth1, troopHealth2
				local chp = hmin == hmax and hmin or ((hmin == 0 and "|cffff40200|r" or hmin) .. " |cffffffff-|r " .. hmax)
				GameTooltip:AddDoubleLine(FOLLOWERLIST_LABEL_TROOPS, chp .. "/" .. troopHealthMax, 1,1,1, troopHealth2 > 0 and 0 or 1, troopHealth2 > 0 and 1 or 0.3, 0.15)
			end
		else
			local hmin, hmax, maxHP = lo[15], hi[15], 0
			for i=5,12 do
				local e = sim.board[i]
				maxHP = maxHP + (e and e.maxHP or 0)
			end
			local chp = hmin == hmax and hmin or (hmin .. " - " .. hmax)
			hmin, hmax = math.ceil(hmin/maxHP*100), math.ceil(hmax/maxHP*100)
			local cr = hmin == hmax and hmin or (hmin .. "% - " .. hmax)
			GameTooltip:AddLine((L"Remaining enemy health: %s"):format("|cffffffff" .. chp .. " (" .. cr .. "%)|r"), c.r, c.g, c.b)
		end
		if not incompleteModel then
			if inProgress then
				flavor = L'"... or not. Better read this thing to the end."'
			elseif lo[sim.won and 13 or 15] == 0 then
				flavor = sim.won and L'"Snatch victory from the jaws of defeat!"' or L'"So close, and yet so far."'
			else
				flavor = L'"Was there ever any doubt?"'
			end
			if not sim.won then
				flavor = "\n" .. flavor
			end
		end
	end
	if res.hadLosses and recoverUntil and not inProgress then
		if recoverUntil == true then
			local nc = NORMAL_FONT_COLOR
			if recoverFutures > 0 or recoverHighBound then
				GameTooltip:AddLine(" ")
			end
			GameTooltip:AddLine(L"Checking health recovery...", 0.45, 1, 0)
			if recoverFutures > 0 then
				GameTooltip:AddDoubleLine(L"Futures considered:", BreakUpLargeNumbers(recoverFutures), nc.r, nc.g, nc.b, 1,1,1)
			end
			if recoverHighBound then
				local mi = CovenantMissionFrame.MissionTab.MissionPage.missionInfo
				local cc = recoverHighBound < (mi and mi.offerEndTime and mi.offerEndTime-GetTime() or 0) and "|cffffffff" or "|cffe86000"
				GameTooltip:AddLine((L"Would win if started in: %s"):format("|cffffffff <= |r" .. cc .. U.GetTimeStringFromSeconds(recoverHighBound, false, true, true) .. "|r"), nc.r, nc.g, nc.b)
			end
		else
			local rl = math.max(0, recoverUntil - GetServerTime())
			local mi = CovenantMissionFrame.MissionTab.MissionPage.missionInfo
			local cc = rl < (mi and mi.offerEndTime and mi.offerEndTime-GetTime() or 0) and "|cffffffff" or "|cffe86000"
			GameTooltip:AddLine((L"Would win if started in: %s"):format(cc .. U.GetTimeStringFromSeconds(rl, false, true, true) .. "|r"), 0.45, 1, 0.15)
		end
	end
	if flavor then
		GameTooltip:AddLine(flavor, 1, 0.835, 0.09, 1)
	end
	GameTooltip:Show()
end
local function Predictor_OnUpdate(self, elapsed)
	local rcd, isDone = (self.rsCooldown or 0) - elapsed, CAG:Run()
	if isDone then
		self:SetScript("OnUpdate", nil)
		Board_SetSimResult(CAG:GetCachedResultSim())
	end
	if (rcd < 0 or isDone) and GameTooltip:IsOwned(self) then
		Predictor_ShowResult(self, CAG:GetResult())
		rcd = 0.125
	end
	self.rsCooldown = rcd
end
local function Predictor_DoStart(self, budget)
	if CAG:Start(budget) then
		self.rsCooldown = 0.125
		self:SetScript("OnUpdate", Predictor_OnUpdate)
	end
end
local function Predictor_OnClick(self)
	Predictor_DoStart(self)
	Predictor_ShowResult(self, CAG:GetResult())
end
local function Predictor_OnLeave(self)
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end
local function Tact_ScheduledBoardCheck()
	Tact.pendingBoardCheck = nil
	return Tact:CheckBoard()
end
local function MissionGroup_OnUpdate()
	if MissionGroup_HoldUpdate == GetTime() then return end
	if not Tact.pendingBoardCheck then
		Tact.pendingBoardCheck = 1
		C_Timer.After(0, Tact_ScheduledBoardCheck)
	end
	local o = GameTooltip:IsVisible() and GameTooltip:GetOwner() or GetMouseFocus()
	if o and not o:IsForbidden() and o.GetScript then
		local l, p, t = 3, o, CovenantMissionFrame.MissionTab.MissionPage.Board
		while p and p ~= t and l > 0 and p.GetParent and p.IsForbidden and not p:IsForbidden() do
			l, p = l-1, p:GetParent()
		end
		if p == t then
			o:GetScript("OnEnter")(o)
		end
	end
	FollowerList:SyncToBoard()
	Predictor_DoStart(CAGHost, 1)
	Board_SetSimResult(CAG:GetCachedResultSim())
end
local function MissionRewards_OnShow(self)
	local MP = CovenantMissionFrame.MissionTab.MissionPage
	local mi = MP.missionInfo
	local d = mi and mi.duration
	MP.Stage.Title:SetText(mi and mi.name or "")
	self.Rewards:SetRewards(mi and mi.xp, mi and mi.rewards)
	self.Duration:SetText(d and L"Duration:" .. " |cffffffff" .. d or "")
	local xpL, xp = mi and mi.xp or 0, 0
	for i=1,mi and mi.rewards and #mi.rewards or 0 do
		local r = mi.rewards[i]
		if r.followerXP then
			xp = xp + r.followerXP
		end
	end
	self.xpGain, self.xpGainL = xpL+xp, xpL
	if FollowerList then
		FollowerList:SyncXPGain(self.xpGain)
	end
end
local function HealAllButton_DoUpdate()
	local ff = CovenantMissionFrame.FollowerList
	local m = ff.followers and "CalculateHealAllFollowersCost" or "OnShow"
	ff[m](ff)
end
local function HealAllButton_OnUpdate(self, elapsed)
	local tl = (self.timeLeft or 0) - elapsed
	if tl > 0 then
		self.timeLeft = tl
		return
	end
	self.timeLeft = 0.125
	return HealAllButton_DoUpdate()
end
local HealAllButton_ScheduleUpdate do
	local hold
	local function HealAllButton_DelayedUpdate()
		hold = nil
		return HealAllButton_DoUpdate()
	end
	function HealAllButton_ScheduleUpdate()
		if FollowerList:IsVisible() and not hold then
			hold = 1
			C_Timer.After(0, HealAllButton_DelayedUpdate)
		end
	end
end
local function MissionView_OnShow()
	if not FollowerList then
		FollowerList = T.CreateObject("OneTime", "AdventurerRoster", CovenantMissionFrame)
		FollowerList:ClearAllPoints()
		FollowerList:SetPoint("BOTTOM", CovenantMissionFrameFollowers, "BOTTOM", 0, -32)
		S[FollowerList].HealAllButton:SetScript("OnUpdate", HealAllButton_OnUpdate)
		EV.GARRISON_FOLLOWER_HEALED = HealAllButton_ScheduleUpdate
	end
	FollowerList:Refresh(MissionRewards and MissionRewards.xpGain)
	FollowerList:Show()
	CovenantMissionFrameFollowers:Hide()
end
local function MissionView_OnHide()
	if FollowerList then
		FollowerList:Hide()
	end
	CovenantMissionFrameFollowers:Show()
	CAG:Reset()
end
local function MissionView_GetGroup()
	local g, hc, zh = {}, false, false
	local f = CovenantMissionFrame.MissionTab.MissionPage.Board.framesByBoardIndex
	for i=0,5 do
		local fi = f[i]
		if fi and fi.name and fi.info and fi:IsShown() then
			g[i], hc = fi.info.followerID, hc or not fi.info.isAutoTroop
			if not (zh or fi.info.isAutoTroop) then
				local cs = C_Garrison.GetFollowerAutoCombatStats(g[i])
				zh = (cs and cs.currentHealth or 0) == 0
			end
		end
	end
	return g, hc, zh
end

local function MissionPage_OnClick(self, button)
	if button == "RightButton" then
		local mid = CovenantMissionFrame.MissionTab.MissionPage.missionInfo.missionID
		local g, hc = MissionView_GetGroup()
		if mid and hc then
			U.StoreMissionGroup(mid, g, true)
			PlaySound(165966)
		end
	end
	GarrisonMissionPage_OnClick(self, button)
	PlaySound(169049)
end
local function MissionPageFollower_OnMouseUp(self, frame, button)
	if button == "RightButton" and not (frame.GetInfo and frame:GetInfo() or frame.info) then
		return MissionPage_OnClick(self:GetMissionPage(), button)
	end
	return CovenantMissionFrame.OnMouseUpMissionFollower(self, frame, button)
end
local function MissionStart_OnClick(_self, button)
	local mid = CovenantMissionFrame.MissionTab.MissionPage.missionInfo.missionID
	local g, hc, zh = MissionView_GetGroup()
	if not hc then
		return
	elseif button == "RightButton" and not zh then
		U.StartMissionWithDelay(mid, g)
	else
		U.StoreMissionGroup(mid, g, true)
		PlaySound(165965)
	end
	CovenantMissionFrame:CloseMission()
end
local function MissionStart_OnEnter(self)
	if self:IsEnabled() then
		local send = NORMAL_FONT_COLOR_CODE .. L"Send Tentative Parties" .. "|r"
		GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 3)
		GameTooltip:SetText(L"Assign Tentative Party")
		GameTooltip:AddLine((L"Tentative parties can be changed until you click %s."):format(send), 1,1,1,1)
		if select(3, MissionView_GetGroup()) then
			GameTooltip:AddLine("|n|cffff8000" .. COVENANT_MISSIONS_COMPANIONS_MISSING_HEALTH, 1, 0.5, 0)
		else
			GameTooltip:AddLine("|n|TInterface/TUTORIALFRAME/UI-TUTORIAL-FRAME:14:12:0:-1:512:512:10:70:330:410|t " .. L"Start the adventure", 0.5, 0.8, 1)
		end
		GameTooltip:Show()
	elseif self.tooltip then
		GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 3);
		GameTooltip:SetText(self.tooltip, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b, RED_FONT_COLOR.a, true);
		GameTooltip:Show();
	end
end
local function Shuffler_OnEnter(self, source)
	GameTooltip:Hide()
	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
	GameTooltip:SetText(ITEM_QUALITY_COLORS[5].hex .. L"Cursed Tactical Guide")
	local sb = T.CreateObject("Singleton", "TooltipProgressBar")
	sb:Hide()
	local isRunning, a1, a2, a3, a4 = Tact:IsRunning()
	if isRunning then
		local nc = NORMAL_FONT_COLOR
		GameTooltip:AddDoubleLine(L"Futures considered:", BreakUpLargeNumbers(a3), 1,1,1, nc.r, nc.g, nc.b)
		if a4 then
			local ex = a4 and a4 ~= Tact.transferGroup and a4 ~= Tact.zeroGroup and "|A:flightpath:0:0|a " or ""
			GameTooltip:AddLine(ex .. L"Use: Interrupt the guide's deliberations.", 0, 1, 0, 1)
		end
		sb:Activate(GameTooltip, a1, a2)
		return
	elseif (a1 and not a2) or source == "update" then -- finished, no group                                                        
		GameTooltip:AddLine("|TInterface\\AddOns\\VenturePlan\\Libs\\tu:::::256:256:178:234:4:60|t "..L"Victory could not be guaranteed.", 1,1,1)
	else -- not running, not finished
		--GameTooltip:AddLine(ITEM_UNIQUE, 1,1,1, 1)
		GameTooltip:AddLine(L"Use: Let the book select troops and battle tactics.", 0, 0.8, 1, 1)
		local c = a2 and WHITE_FONT_COLOR or RED_FONT_COLOR -- can start?
		GameTooltip:AddLine(L"Requires a companion in the party", c.r, c.g, c.b)
		GameTooltip:AddLine(L'"Chapter 1: Mages Must Melee."', 1, 0.835, 0.09, 1)
	end
	GameTooltip:Show()
end
local function Shuffler_OnLeave(self)
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end
local function Shuffler_AssignGroup(g, sim)
	SetSimResultHint(g, sim)
	MissionGroup_HoldUpdate = GetTime()
	local f = CovenantMissionFrame.MissionTab.MissionPage.Board.framesByBoardIndex
	for i=0,4 do
		if f[i].info then
			CovenantMissionFrame:RemoveFollowerFromMission(f[i], true)
		end
	end
	for slot, ii in pairs(g) do
		CovenantMissionFrame:AssignFollowerToMission(f[slot], GetFollowerInfo(ii.id))
	end
	MissionGroup_HoldUpdate = nil
	MissionGroup_OnUpdate()
end
local function Shuffler_OnUpdate(self)
	local sself, fin, g = S[self], Tact:Run()
	local t = GameTooltip:IsOwned(self)
	sself.ThinkingIcon:SetShown(not (fin or t))
	if fin then
		self:SetScript("OnUpdate", nil)
		sself.NewGroupIcon:Hide()
		sself.ThinkingIcon:Hide()
		if g then
			if not Board_IsEqualToGroup(g) then
				Shuffler_AssignGroup(Tact:GetBest(g))
			else
				PlaySound(SOUNDKIT.UI_ADVENTURES_ADVENTURER_SLOTTED)
			end
			Animations.Flare:Restart()
			Shuffler_OnLeave(self)
			return
		elseif not t and select(2, Tact:IsRunning()) then
			Animations.Doom:Restart()
		end
	else
		local _, _1, _2, _3, a4 = Tact:IsRunning()
		sself.NewGroupIcon:SetShown(a4 and a4 ~= Tact.transferGroup and a4 ~= Tact.zeroGroup or false)
	end
	if t then
		Shuffler_OnEnter(self, "update")
	end
end
local function Shuffler_OnClick(self)
	local ir, a1, a2 = Tact:IsRunning()
	if ir then
		local g, sim = Tact:GetBest()
		if g then
			Shuffler_AssignGroup(g, sim)
		end
	elseif not a1 and Tact:Start() then
		self:SetScript("OnUpdate", Shuffler_OnUpdate)
		Shuffler_OnUpdate(self)
	elseif a2 then
		local g, sim = Tact:GetBest()
		if not Board_IsEqualToGroup(g) then
			Shuffler_AssignGroup(g, sim)
		else
			PlaySound(SOUNDKIT.UI_ADVENTURES_ADVENTURER_SLOTTED)
		end
		Animations.Flare:Restart()
		Shuffler_OnLeave(self)
	end
	PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
end
local function Shuffler_OnHide()
	Tact:Reset()
end
local function Hinter_OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
	GameTooltip:SetText(ITEM_QUALITY_COLORS[5].hex .. L"Cursed Adventuring Log")
	--GameTooltip:AddLine(ITEM_UNIQUE, 1,1,1,1)
	GameTooltip:AddLine(L"Use: Remember the adventuring parties that have succeeded here in the past.", 0, 1, 0, 1)
	GameTooltip:AddLine(L'"Some of the entires do not appear to be written by your hand."', 1, 0.835, 0.09, 1)
	GameTooltip:Show()
end
local function Hinter_OnClick(self)
	local mi = CovenantMissionFrame.MissionTab.MissionPage.missionInfo
	local mid = mi.missionID
	local ga = U.GetSuggestedGroups(mid, 8, 3, mi.offerEndTime)
	if ga and #ga.ord > 0 then
		if GameTooltip:IsOwned(self) then GameTooltip:Hide() end
		local gl, sl = T.CreateObject("Singleton", "GroupList")
		U.FlushMissionPredictionQueue()
		sl:Acquire(self, nil, 24, nil, true)
		sl:SetGroups(mid, mi.offerEndTime, mi.cost, ga)
		gl:SetPoint("BOTTOM", self, "TOP", 32, 0)
		gl:SetFrameLevel(2000)
	else
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
		GameTooltip:SetText(ITEM_QUALITY_COLORS[5].hex .. L"Cursed Adventuring Log")
		--GameTooltip:AddLine(ITEM_UNIQUE, 1,1,1,1)
		GameTooltip:AddLine(L"The log appears to contain nothing useful at the moment.", 1, 0, 0, 1)
		GameTooltip:Show()
	end
end
local function Hinter_OnUpdate(self)
	if U.RunMissionPredictionQueue(5) then
		self:SetScript("OnUpdate", nil)
	end
end
local function HookOnShow(f, h)
	f:HookScript("OnShow", h)
	if f:IsVisible() then
		h(f)
	end
end

function EV:I_ADVENTURES_UI_LOADED()
	local MP = CovenantMissionFrame.MissionTab.MissionPage
	for i=0,12 do
		local f = MP.Board.framesByBoardIndex[i]
		f:SetScript("OnUpdate", Puck_Up)
		f:SetScript("OnEnter", Puck_OnEnter)
		f:SetScript("OnLeave", Puck_OnLeave)
		for i=1,2 do
			f.AbilityButtons[i]:EnableMouse(false)
			f.AbilityButtons[i]:SetMouseMotionEnabled(false)
		end
	end
	MP.CloseButton:SetScript("OnKeyDown", function(self, key)
		self:SetPropagateKeyboardInput(key ~= "ESCAPE")
		if key == "ESCAPE" then
			self:Click()
		end
	end)
	CAGHost = T.CreateObject("IconButton", MP.Board, 32, "Interface/Icons/INV_Misc_Book_01")
	CAGHost:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	CAGHost:SetPoint("BOTTOMLEFT", 11, 62)
	CAGHost:SetScript("OnEnter", Predictor_OnEnter)
	CAGHost:SetScript("OnLeave", Predictor_OnLeave)
	CAGHost:SetScript("OnClick", Predictor_OnClick)
	local cal = T.CreateObject("CommonHoverTooltip", T.CreateObject("IconButton", MP.Board, 32, "interface/icons/inv_misc_groupneedmore"))
	cal:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	cal:SetPoint("BOTTOMLEFT", CAGHost, "BOTTOMRIGHT", 6, 0)
	cal:SetScript("OnEnter", Hinter_OnEnter)
	cal:SetScript("OnClick", Hinter_OnClick)
	function EV.I_MPQ_ITEM_ADDED() cal:SetScript("OnUpdate", Hinter_OnUpdate) end
	local cat = T.CreateObject("IconButton", MP.Board, 46, "Interface/Icons/INV_Misc_Book_06") do
		local f, s = CreateFrame("Frame", nil, cat), T.CreateObject("Shadow", cat)
		f:SetAllPoints()
		local t = f:CreateTexture(nil, "OVERLAY")
		t:SetAtlas("worldquest-tracker-questmarker")
		t:SetPoint("TOPRIGHT", 6, 6)
		t:SetSize(16,16)
		t:Hide()
		s.NewGroupIcon = t
		s.ThinkingIcon = T.CreateObject("OneTime", "ThinkingAnim", cat)
		cat:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		cat:SetPoint("TOPLEFT", CAGHost, "TOPRIGHT", -32, 50) 
		cat:SetScript("OnEnter", Shuffler_OnEnter)
		cat:SetScript("OnLeave", Shuffler_OnLeave)
		cat:SetScript("OnClick", Shuffler_OnClick)
		cat:SetScript("OnHide", Shuffler_OnHide)
	end
	do -- Animations
		local lowHost = CreateFrame("Frame", nil, MP.Board)
		lowHost:SetClipsChildren(true)
		lowHost:SetPoint("BOTTOMLEFT", 0, -40)
		lowHost:SetPoint("TOPRIGHT", MP.Board, "BOTTOMRIGHT", 0, 255)
		local highHost = CreateFrame("Frame", nil, MP.Board)
		highHost:SetPoint("BOTTOMLEFT", 0, -40)
		highHost:SetPoint("TOPRIGHT")
		highHost:SetClipsChildren(true)
		highHost:SetFrameLevel(2000)
		Animations.Flare = T.CreateObject("OneTime", "FlareAnim", lowHost, cat)
		Animations.Doom = T.CreateObject("OneTime", "DoomAnim", highHost, cat)
		lowHost:SetScript("OnHide", function()
			Animations.Flare:Stop()
			Animations.Doom:Stop()
		end)
	end
	MP.Stage.EnvironmentEffectFrame:SetScript("OnEnter", EnvironmentEffect_OnEnter)
	MP.Stage.EnvironmentEffectFrame:SetScript("OnLeave", EnvironmentEffect_OnLeave)
	hooksecurefunc(MP.Stage.EnvironmentEffectFrame.Name, "SetText", EnvironmentEffect_OnNameUpdate)
	hooksecurefunc(CovenantMissionFrame, "AssignFollowerToMission", MissionGroup_OnUpdate)
	hooksecurefunc(CovenantMissionFrame, "RemoveFollowerFromMission", MissionGroup_OnUpdate)
	MP:SetScript("OnClick", MissionPage_OnClick)
	HookOnShow(CovenantMissionFrame, function()
		CovenantMissionFrame:RegisterCallback(CovenantMission.Event.OnFollowerFrameMouseUp, MissionPageFollower_OnMouseUp, CovenantMissionFrame)
	end)
	MP.StartMissionButton:SetScript("OnClick", MissionStart_OnClick)
	MP.StartMissionButton:SetScript("OnEnter", MissionStart_OnEnter)
	MP.StartMissionButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	MP.StartMissionButton:SetText(L"Assign Party")
	CovenantMissionFrame.GetSystemSpecificStartMissionFailureMessage = function() end
	local s = CovenantMissionFrame.MissionTab.MissionPage.Stage
	s.Title:SetPoint("LEFT", s.Header, "LEFT", 100, 9)
	local ir = T.CreateObject("InlineRewardBlock", s.MouseOverTitleFrame)
	MissionRewards = ir
	ir:SetPoint("LEFT", s.Header, "LEFT", 100, -16)
	ir.Duration = ir:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	ir.Duration:SetPoint("LEFT", ir, "RIGHT", 4, 0)
	hooksecurefunc(CovenantMissionFrame, "SetTitle", function()
		MissionRewards_OnShow(ir)
		BoardEX:SetSimResult(nil)
	end)
	hooksecurefunc(CovenantMissionFrame:GetMissionPage(), "Show", MissionView_OnShow)
	MP.Board:HookScript("OnHide", MissionView_OnHide)
	MP.Board:HookScript("OnShow", MissionView_OnShow)
	hooksecurefunc(CovenantMissionFrameFollowers, "UpdateFollowers", function()
		if MP.Board:IsVisible() and not (S[T.MissionList] and S[T.MissionList]:IsVisible()) then
			MissionView_OnShow()
		end
	end)
	MP.Stage.Title:SetWidth(320)
	BoardEX = T.CreateObject("OneTime", "BoardEx")
	return "remove"
end
