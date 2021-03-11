local _, T = ...
local EV, L, U, S = T.Evie, T.L, T.Util, T.Shadows

local FollowerList, MissionRewards

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
	local r, TP = 0, T.VSim.TP
	local f = CovenantMissionFrame.MissionTab.MissionPage.Board.framesByBoardIndex
	local mid = CovenantMissionFrame.MissionTab.MissionPage.missionInfo.missionID

	local board = U.GetMaskBoard(bm)
	if slot < 5 then
		for _,v in pairs(C_Garrison.GetMissionDeploymentInfo(mid).enemies) do
			local i = v.boardIndex
			local fi = f[i]
			local s1 = fi.autoCombatSpells and fi.autoCombatSpells[1]
			local aa = T.KnownSpells[TP:GetAutoAttack(v.role, i, mid, s1 and s1.autoCombatSpellID)]
			if aa and TP.GetTargets(i, aa.target, board)[1] == slot then
				r = bit.bor(r, 2^i)
			end
		end
	else
		for i=0, 4 do
			if bm % 2^(i+1) >= 2^i then
				local fi = f[i]
				local v, s1 = fi.info, fi.autoCombatSpells and fi.autoCombatSpells[1]
				local aa = T.KnownSpells[T.VSim.TP:GetAutoAttack(v.role, nil, nil, s1 and s1.autoCombatSpellID)]
				if aa and TP.GetTargets(i, aa.target, board)[1] == slot then
					r = bit.bor(r, 2^i)
				end
			end
		end
	end

	return r
end
local function GetFollowerInfo(fid)
	local fi = C_Garrison.GetFollowerInfo(fid)
	fi.autoCombatSpells = C_Garrison.GetFollowerAutoCombatSpells(fid, fi.level)
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
		for _,v in pairs(C_Garrison.GetMissionDeploymentInfo(mid).enemies) do
			if v.boardIndex == bi then
				info, acs = v, {currentHealth=v.health, maxHealth=v.maxHealth, attack=v.attack}
				break
			end
		end
	end
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	U.SetFollowerInfo(GameTooltip, info, self.autoCombatSpells, acs, mid, bi, bm, false)
	local aa = GetIncomingAAMask(bi, bm)
	if aa and aa > 0 then
		local nc = NORMAL_FONT_COLOR
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(L"Incoming attacks:" .. " " .. U.FormatTargetBlips(aa, bm, nil, "240:60:0", false), nc.r, nc.g, nc.b)
	end
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
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", -8, 0)
	GameTooltip:ClearLines()
	GameTooltip:AddDoubleLine(pfx .. "|T" .. info.icon .. ":0:0:0:0:64:64:4:60:4:60|t " .. info.name, "|cffa8a8a8" .. (L"[CD: %dT]"):format(info.cooldown) .. "|r")
	local guideLine = U.GetAbilityGuide(sid, -1, GenBoardMask(), false)
	local od = U.GetAbilityDescriptionOverride(info and info.autoCombatSpellID)
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
	ee:SetHitRectInsets(0, min(-100, -self_name:GetStringWidth()), 0, 0)
end
local CAG, SetSimResultHint = {} do
	local simArch, reSim, state, deadline
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
	local function isDone(res)
		return res and (res.isFinished or (res.hadWins and res.hadLosses))
	end
	local function setupRetry()
		if reSim then
			state[reSim.res.hadLosses and "reLow" or "reHigh"], state.reTry, reSim = state.reTry, nil
		end
		if not (state.reRange and state.reLow < state.reRange) or (state.reHigh and state.reHigh - state.reLow < 2^-11) then
			if state.reHigh then
				state.reFinish = state.reStart+U.GetCompanionRecoveryTime(state.reHigh)
			end
			reSim, state.reTry, state.reLow, state.reHigh, state.reTeam, state.reStart, state.reRange = nil
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
		local team, reRange = {}, 0 do
			local f = CovenantMissionFrame.MissionTab.MissionPage.Board.framesByBoardIndex
			for i=0,4 do
				local ii = f[i].info
				if ii then
					local acs = C_Garrison.GetFollowerAutoCombatStats(ii.followerID)
					team[#team+1] = {boardIndex=i, role=ii.role, stats=acs, spells=f[i].autoCombatSpells}
					if acs.currentHealth < acs.maxHealth then
						reRange = math.max(reRange or 0, 1 - acs.currentHealth/acs.maxHealth)
					end
				end
			end
		end
		local mi  = CovenantMissionFrame.MissionTab.MissionPage.missionInfo
		local eei = C_Garrison.GetAutoMissionEnvironmentEffect(mi.missionID)
		local mdi = C_Garrison.GetMissionDeploymentInfo(mi.missionID)
		local espell = eei and eei.autoCombatSpellInfo
		return {team=team, enemies=mdi.enemies, espell=espell, mid=mi.missionID, msc=mi.missionScalar,
			reStart=reRange > 0 and GetServerTime() or nil, reRange=reRange > 0 and reRange or nil, reLow=0}
	end
	function CAG:Start()
		local tag, rtag = GetGroupTags()
		if not state or state.tag ~= tag then
			local os, md, ms = state, CAG:GatherMissionData()
			state, md.tag, md.rtag, reSim = md, tag, rtag, nil
			if os and os.rtag == rtag and os.reFinish and md.reStart then
				md.reFinish, md.reStart, md.reRange, md.reLow = os.reFinish, nil
			end
			simArch, ms = T.VSim:New(md.team, md.enemies, md.espell, md.mid, md.msc)
			md.missingSpells, simArch.dropForks = ms and next(ms) and true or nil, true
			deadline = debugprofilestop() + 40
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
			if isDone(reSim.res) then
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
		return simArch, state and state.missingSpells, state and (state.reFinish or state.reStart and true) or nil
	end
	function CAG:Reset()
		simArch, reSim, state = nil
	end
	function SetSimResultHint(g, sim, ms)
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
		simArch, state.team, state.missingSpells = sim, ng, ms and next(ms) and true or nil
	end
	EV.GARRISON_MISSION_NPC_CLOSED = CAG.Reset
end
local Tact = {} do
	local pt, state, deadline = {}
	local function cmpFollowerID(a,b)
		return a.followerID < b.followerID
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
	local function GetShuffleGroup(gid)
		local rgid, g, um, maxScore, pen, wmask = gid, {}, 0, 4, 0, 0
		for i=0,4 do
			pt[i] = i
		end
		for i=1, #state.companions do
			local p, li, ci = rgid % (6-i), 5-i, state.companions[i]
			rgid = (rgid - p) / (6-i)
			p, pt[li], pt[p] = pt[p], pt[p], pt[li]
			g[p], um = ci, um + 2^p
			if not ci.willLevel then
				maxScore, wmask = maxScore + 5*ci.stats.maxHealth, wmask + 2^p
			end
		end
		for p=0, 4-#state.companions do
			p = pt[p]
			local i = rgid % 3
			rgid = (rgid - i) / 3
			local ti = state.troops[i+1]
			if ti then
				g[p], pen = ti, pen + 1
			end
		end
		return g, maxScore-pen, pen, wmask
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
				local ng = state.nextGroup
				if ng >= state.numGroups then
					state.finished = true
					local g = state.bestGroup and GetShuffleGroup(state.bestGroup)
					if g then
						SetSimResultHint(g, state.bestSim, state.bestMiss)
					end
					return true, g
				end
				local ms, team, maxScore, troopPenalty, wmask = nil, GetShuffleGroup(ng)
				if maxScore > state.bestScore then
					sim, ms = T.VSim:New(team, state.enemies, state.espell, state.missionID, state.missionScalar)
					sim.wmask, sim.dropForks = wmask, true
					state.csim, state.cmiss, state.cgroup, state.cpenalty = sim, ms, ng, troopPenalty
					state.numFutures = state.numFutures + 1
				end
				state.nextGroup = ng+1
			end
			if sim then
				sim:Run(interrupt)
				if sim.res.hadLosses then
					state.csim = nil
				elseif sim.res.isFinished then
					local h = GetHealthScore(sim.res.min)
					if h > state.bestScore then
						state.bestScore, state.bestGroup, state.bestSim, state.bestMiss = h, state.cgroup, sim, state.cmiss
					end
					state.csim = nil
				end
			end
		until debugprofilestop() > deadline
	end
	function Tact:GatherMissionData()
		local mi = CovenantMissionFrame.MissionTab.MissionPage.missionInfo
		local eei = C_Garrison.GetAutoMissionEnvironmentEffect(mi.missionID)
		local mdi = C_Garrison.GetMissionDeploymentInfo(mi.missionID)
		local espell = eei and eei.autoCombatSpellInfo
		local ct, tt = {}, {} do
			local f = CovenantMissionFrame.MissionTab.MissionPage.Board.framesByBoardIndex
			local rewardXP = MissionRewards and MissionRewards.xpGain or 0
			for i=0,4 do
				local ii = f[i].info
				if ii and not ii.isAutoTroop then
					local willLevel = not ii.isMaxLevel and ii.xp and ii.levelXP and (ii.xp + rewardXP) >= ii.levelXP
					local acs = C_Garrison.GetFollowerAutoCombatStats(ii.followerID) or ii.autoCombatantStats
					ct[#ct+1] = {role=ii.role, stats=acs, spells=f[i].autoCombatSpells, id=ii.followerID, willLevel=willLevel}
				end
			end
			for _, fi in ipairs(C_Garrison.GetAutoTroops(123)) do
				tt[#tt+1] = {
					role=fi.role,
					stats=C_Garrison.GetFollowerAutoCombatStats(fi.followerID),
					spells=C_Garrison.GetFollowerAutoCombatSpells(fi.followerID, fi.level),
					id=fi.followerID,
				}
			end
		end
		return {missionID=mi.missionID, missionScalar=mi.missionScalar, enemies=mdi.enemies, espell=espell, companions=ct, troops=tt}
	end
	function Tact:Start()
		if not Board_HasCompanion() then
			return
		end
		local ht, it = GetGroupTags()
		if state and not (it ~= state.itag or (state.finished and state.htag ~= ht)) then
			return true
		end
		state = self:GatherMissionData()
		local ng = 3^(5-#state.companions)
		for i=1, #state.companions do
			ng = ng * (6-i)
		end
		state.numGroups, state.nextGroup, state.bestGroup, state.bestScore = ng, 0, false, -1e12
		state.numFutures, state.htag, state.itag = 0, ht, it
		return true
	end
	function Tact:IsRunning()
		if state and not state.finished then
			return true, state.nextGroup, state.numGroups, state.numFutures, not not state.bestGroup
		elseif state and GetGroupTags() == state.htag then
			return false, true, not not state.bestGroup
		else
			return false, false, Board_HasCompanion()
		end
	end
	function Tact:Interrupt()
		if state and state.bestGroup then
			local g = GetShuffleGroup(state.bestGroup)
			SetSimResultHint(g, state.bestSim, state.bestMiss)
			return g
		end
	end
	function Tact:CheckBoard(later)
		if later then
			if not Tact.pendingBoardCheck then
				C_Timer.After(0, Tact.CheckBoard)
			end
			Tact.pendingBoardCheck = true
			return
		end
		Tact.pendingBoardCheck = nil
		if state and not state.finished and state.itag ~= select(2, GetGroupTags()) then
			state = nil
		end
	end
	function Tact:Reset()
		state = nil
	end
end
local function Predictor_OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
	GameTooltip:SetText(ITEM_QUALITY_COLORS[5].hex .. L"Cursed Adventurer's Guide")
	GameTooltip:AddLine(ITEM_UNIQUE, 1,1,1, 1)
	GameTooltip:AddLine(L"Use: Read the guide, determining the fate of your adventuring party.", 0, 1, 0, 1)
	GameTooltip:AddLine(L'"Do not believe its lies! Balance druids are not emergency rations."', 1, 0.835, 0.09, 1)
	GameTooltip:Show()
end
local function Predictor_ShowResult(self, sim, incompleteModel, recoverUntil)
	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
	local res = sim.res
	local rngModel = res.hadDrops or (res.hadWins and res.hadLosses)
	local inProgress = not res.isFinished and not rngModel
	local oodBuild = GetBuildInfo() ~= "9.0.5"
	local hprefix = (oodBuild or incompleteModel) and "|TInterface/EncounterJournal/UI-EJ-WarningTextIcon:0|t " or ""
	if inProgress then
		hprefix = hprefix .. "|cffff3300" .. L"Preliminary:" .. "|r "
	end
	if rngModel then
		GameTooltip:SetText(hprefix .. L"Curse of Uncertainty", 1, 0.20, 0)
	else
		GameTooltip:SetText(hprefix .. (sim.won and L"Victorious" or L"Defeated"), 1,1,1)
	end

	if incompleteModel then
		GameTooltip:AddLine(L"Not all abilities have been taken into account.", 0.9,0.25,0.15)
	elseif oodBuild then
		GameTooltip:AddLine(L"The Guide may be out of date.", 0.9,0.25,0.15)
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
				flavor = (L'"%s possible futures and counting..."'):format(BreakUpLargeNumbers(res.n or 0))
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
			GameTooltip:AddLine(L"Checking health recovery...", 0.45, 1, 0)
		else
			local rl = math.max(0, recoverUntil - GetServerTime())
			GameTooltip:AddLine((L"Would win if started in: %s"):format("|cffffffff" .. U.GetTimeStringFromSeconds(rl, false, true, true) .. "|r"), 0.45, 1, 0.15, 1)
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
	end
	if (rcd < 0 or isDone) and GameTooltip:IsOwned(self) then
		Predictor_ShowResult(self, CAG:GetResult())
		rcd = 0.125
	end
	self.rsCooldown = rcd
end
local function Predictor_OnClick(self)
	if CAG:Start() then
		self.rsCooldown = 0.125
		self:SetScript("OnUpdate", Predictor_OnUpdate)
	end
	Predictor_ShowResult(self, CAG:GetResult())
end
local function Predictor_OnLeave(self)
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end
local function MissionGroup_OnUpdate()
	Tact:CheckBoard(true)
	local o = GameTooltip:IsVisible() and GameTooltip:GetOwner() or GetMouseFocus()
	if o and not o:IsForbidden() and o:GetScript("OnEnter") and o:GetParent():GetParent() == CovenantMissionFrame.MissionTab.MissionPage.Board then
		o:GetScript("OnEnter")(o)
	end
	FollowerList:SyncToBoard()
end
local function MissionRewards_OnShow(self)
	local MP = CovenantMissionFrame.MissionTab.MissionPage
	local mi = MP.missionInfo
	local d = mi and mi.duration
	MP.Stage.Title:SetText(mi and mi.name or "")
	self.Rewards:SetRewards(mi and mi.xp, mi and mi.rewards)
	self.Duration:SetText(d and L"Duration:" .. " |cffffffff" .. d or "")
	local xp = mi and mi.xp or 0
	for i=1,mi and mi.rewards and #mi.rewards or 0 do
		local r = mi.rewards[i]
		if r.followerXP then
			xp = xp + r.followerXP
		end
	end
	self.xpGain = xp
	if FollowerList then
		FollowerList:SyncXPGain(xp)
	end
end
local function MissionView_OnShow()
	if not FollowerList then
		FollowerList = T.CreateObject("FollowerList", CovenantMissionFrame)
		FollowerList:ClearAllPoints()
		FollowerList:SetPoint("BOTTOM", CovenantMissionFrameFollowers, "BOTTOM", 0, 8)
	end
	FollowerList:Refresh(MissionRewards and MissionRewards.xpGain)
	FollowerList:Show()
	CovenantMissionFrameFollowers:Hide()
	CovenantMissionFrameFollowers.MaterialFrame:SetParent(FollowerList)
	CovenantMissionFrameFollowers.HealAllButton:SetParent(FollowerList)
end
local function MissionView_OnHide()
	if FollowerList then
		FollowerList:Hide()
	end
	CovenantMissionFrameFollowers:Show()
	CovenantMissionFrameFollowers.MaterialFrame:SetParent(CovenantMissionFrameFollowers)
	CovenantMissionFrameFollowers.HealAllButton:SetParent(CovenantMissionFrameFollowers)
end
local function Mission_StoreTentativeGroup()
	if IsAltKeyDown() then
		return
	end
	local g, hc = {}, false
	local mid = CovenantMissionFrame.MissionTab.MissionPage.missionInfo.missionID
	local f = CovenantMissionFrame.MissionTab.MissionPage.Board.framesByBoardIndex
	for i=0,5 do
		local fi = f[i]
		if fi and fi.name and fi.info and fi:IsShown() then
			g[i], hc = fi.info.followerID, hc or not fi.info.isAutoTroop
		end
	end
	if hc then
		U.StoreMissionGroup(mid, g, true)
	end
end
local function Shuffler_OnEnter(self)
	GameTooltip:Hide()
	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
	GameTooltip:SetText(ITEM_QUALITY_COLORS[5].hex .. L"Cursed Tactical Guide")
	local isRunning, a1, a2, a3, a4 = Tact:IsRunning()
	if isRunning then
		local nc = NORMAL_FONT_COLOR
		GameTooltip:AddDoubleLine(L"Futures considered:", BreakUpLargeNumbers(a3), 1,1,1, nc.r, nc.g, nc.b)
		if a4 then
			GameTooltip:AddLine(L"Use: Interrupt the guide's deliberations.", 0, 1, 0, 1)
		end
		T.CreateObject("SharedTooltipProgressBar"):Activate(GameTooltip, a1, a2)
		return
	elseif a1 and not a2 then -- finished, no group
		GameTooltip:AddLine(L"Victory could not be guaranteed.", 1,1,1)
	else -- not running, not finished
		GameTooltip:AddLine(ITEM_UNIQUE, 1,1,1, 1)
		GameTooltip:AddLine(L"Use: Let the book select troops and battle tactics.", 0, 1, 0, 1)
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
local function Shuffler_AssignGroup(g)
	local f = CovenantMissionFrame.MissionTab.MissionPage.Board.framesByBoardIndex
	for i=0,4 do
		if f[i].info then
			CovenantMissionFrame:RemoveFollowerFromMission(f[i], true)
		end
	end
	for slot, ii in pairs(g) do
		CovenantMissionFrame:AssignFollowerToMission(f[slot], GetFollowerInfo(ii.id))
	end
end
local function Shuffler_OnUpdate(self)
	local fin, g = Tact:Run()
	if fin then
		self:SetScript("OnUpdate", nil)
		if g then
			Shuffler_OnLeave(self)
			return Shuffler_AssignGroup(g)
		end
	end
	if GameTooltip:IsOwned(self) then
		Shuffler_OnEnter(self)
	end
end
local function Shuffler_OnClick(self)
	local ir, _, _, hg = Tact:IsRunning()
	if ir then
		local g = hg and Tact:Interrupt()
		if g then
			Shuffler_AssignGroup(g)
		end
	elseif Tact:Start() then
		self:SetScript("OnUpdate", Shuffler_OnUpdate)
		Shuffler_OnUpdate(self)
	end
	PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
end
local function Shuffler_OnHide()
	Tact:Reset()
end

function EV:I_ADVENTURES_UI_LOADED()
	local MP = CovenantMissionFrame.MissionTab.MissionPage
	for i=0,12 do
		local f = MP.Board.framesByBoardIndex[i]
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
	local cag = T.CreateObject("IconButton", MP.Board, 64, "Interface/Icons/INV_Misc_Book_01")
	cag:SetPoint("BOTTOMLEFT", 24, 4)
	cag:SetScript("OnEnter", Predictor_OnEnter)
	cag:SetScript("OnLeave", Predictor_OnLeave)
	cag:SetScript("OnClick", Predictor_OnClick)
	local cat = T.CreateObject("IconButton", MP.Board, 32, "Interface/Icons/INV_Misc_Book_06")
	cat:SetPoint("TOPLEFT", cag, "TOPRIGHT", 4, 0)
	cat:SetScript("OnEnter", Shuffler_OnEnter)
	cat:SetScript("OnLeave", Shuffler_OnLeave)
	cat:SetScript("OnClick", Shuffler_OnClick)
	cat:SetScript("OnHide", Shuffler_OnHide)
	MP.Stage.EnvironmentEffectFrame:SetScript("OnEnter", EnvironmentEffect_OnEnter)
	MP.Stage.EnvironmentEffectFrame:SetScript("OnLeave", EnvironmentEffect_OnLeave)
	hooksecurefunc(MP.Stage.EnvironmentEffectFrame.Name, "SetText", EnvironmentEffect_OnNameUpdate)
	hooksecurefunc(CovenantMissionFrame, "AssignFollowerToMission", MissionGroup_OnUpdate)
	hooksecurefunc(CovenantMissionFrame, "RemoveFollowerFromMission", MissionGroup_OnUpdate)
	MP.CloseButton:HookScript("PreClick", Mission_StoreTentativeGroup)
	local s = CovenantMissionFrame.MissionTab.MissionPage.Stage
	s.Title:SetPoint("LEFT", s.Header, "LEFT", 100, 9)
	local ir = T.CreateObject("InlineRewardBlock", s)
	MissionRewards = ir
	ir:SetPoint("LEFT", s.Header, "LEFT", 100, -16)
	ir.Duration = ir:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	ir.Duration:SetPoint("LEFT", ir, "RIGHT", 4, 0)
	hooksecurefunc(CovenantMissionFrame, "SetTitle", function()
		MissionRewards_OnShow(ir)
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
	return false
end