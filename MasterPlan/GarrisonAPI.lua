local api, _, T = {}, ...
if T.Mark ~= 50 then return end
local EV, L = T.Evie, newproxy(true)
getmetatable(L).__call = function(_,k) if T.L then L = T.L return L(k) end return k end
local FOLLOWER_ITEM_LEVEL_CAP, MENTOR_FOLLOWER, INF = T.FOLLOWER_ITEM_LEVEL_CAP, T.MENTOR_FOLLOWER, math.huge
local FOLLOWER_LEVEL_CAP, FOLLOWER_LEVEL_BASE = T.FOLLOWER_LEVEL_CAP, T.FOLLOWER_LEVEL_BASE
local unfreeStatusOrder = {[GARRISON_FOLLOWER_WORKING]=2, [GARRISON_FOLLOWER_INACTIVE]=1}

local Nine = T.Nine or _G
local C_Garrison = Nine.C_Garrison

local function getShoppingTooltips(tip)
	local GameTooltip = _G.GameTooltip
	if tip[0] == GameTooltip[0] and not GameTooltip:IsForbidden() then
		return GameTooltip.shoppingTooltips
	end
end

hooksecurefunc(C_Garrison, "MarkMissionComplete", function(mid)
	EV("MP_MARK_MISSION_COMPLETE", mid)
end)

local tentativeState, tentativeParties = {}, {} do
	T.tentativeState = tentativeState
	local notifyChange do
		local pending = false
		local function doNotify()
			pending = false
			EV("MP_TENTATIVE_PARTY_UPDATE")
		end
		function notifyChange()
			if not pending then
				pending = true
				T.After0(doNotify)
			end
		end
	end
	local function dissolve(mid, doNotUpdate)
		local p = tentativeParties[mid]
		if p then
			local f1, f2, f3 = p[1], p[2], p[3]
			tentativeParties[mid], tentativeState[f1 or 0], tentativeState[f2 or 0], tentativeState[f3 or 0] = nil
			if not doNotUpdate then
				notifyChange()
			end
			return f1, f2, f3
		end
	end
	local function tentativeFullNext(typeID, mid)
		local mid, p = next(tentativeParties, mid)
		if mid then
			if #p == C_Garrison.GetMissionMaxFollowers(mid) and C_Garrison.GetFollowerTypeByMissionID(mid) == typeID then
				return mid, p[1], p[2], p[3]
			end
			return tentativeFullNext(typeID, mid)
		end
	end
	function api.GetMissionParty(mid, quiet)
		return dissolve(mid, quiet)
	end
	function api.SaveMissionParty(mid, f1, f2, f3)
		dissolve(mid, true)
		dissolve(tentativeState[f1], true)
		dissolve(tentativeState[f2], true)
		dissolve(tentativeState[f3], true)
		if not f2 then f2, f3 = f3 end
		if not f1 then f1, f2, f3 = f2, f3 end
		tentativeParties[mid] = (f1 or f2 or f3) and {f1, f2, f3} or nil
		tentativeState[f1 or 0], tentativeState[f2 or 0], tentativeState[f3 or 0] = mid, mid, mid
		notifyChange()
	end
	function api.HasTentativeParty(mid)
		local p = tentativeParties[mid]
		return p and #p or 0
	end
	function api.GetTentativePartyCount(typeID)
		local total, ready = 0,0
		for k,v in pairs(tentativeParties) do
			if C_Garrison.GetFollowerTypeByMissionID(k) ~= typeID then
			elseif #v == C_Garrison.GetMissionMaxFollowers(k) then
				ready = ready + 1
			else
				total = total + 1
			end
		end
		return ready, total+ready
	end
	function api.GetReadyTentativeParties(typeID)
		return tentativeFullNext, typeID
	end
	function api.GetFollowerTentativeMission(fid)
		return tentativeState[fid]
	end
	function api.DissolveMissionByFollower(fid)
		dissolve(tentativeState[fid])
	end
	function api.DissolveAllTentativeParties(typeID)
		if next(tentativeParties) or next(tentativeState) then
			for k in pairs(tentativeParties) do
				if C_Garrison.GetFollowerTypeByMissionID(k) == typeID then
					dissolve(k, true)
				end
			end
			notifyChange()
		end
	end
	function EV:MP_MISSION_START(mid, f1, f2, f3)
		dissolve(mid, true)
		dissolve(tentativeState[f1], true)
		dissolve(tentativeState[f2], true)
		dissolve(tentativeState[f3], true)
		notifyChange()
	end
	function EV:GARRISON_MISSION_STARTED(_tid, id)
		dissolve(id)
	end
end

local f, data = CreateFrame("Frame"), {}
f:SetScript("OnUpdate", function(self) wipe(data) self:Hide() end)

do
	local watching, onZone, onOpen, onClose
	function onZone()
		if not (C_Garrison.IsOnGarrisonMap() or GarrisonMissionFrame:IsVisible()) then
			EV("MP_RELEASE_CACHES")
			EV.UnregisterEvent("GARRISON_MISSION_NPC_OPENED", onOpen)
			watching = nil
			return "remove"
		end
	end
	function onClose()
		if watching then return end
		EV.ZONE_CHANGED = onZone
		EV.GARRISON_MISSION_NPC_OPENED = onOpen
		watching = 1
		onZone()
	end
	function onOpen()
		EV.UnregisterEvent("ZONE_CHANGED", onZone)
		watching = nil
		return "remove"
	end
	EV.GARRISON_MISSION_NPC_CLOSED = onClose
end

local parseTime = {} do
	local captures = {} do
		local function proc(fm, f, s)
			local t, pat = nil, fm:gsub("%%d", "\0"):gsub("[()%[%].%-+*?%%]", "%%%0")
			for chunk, inner in pat:gmatch("(|4(.-);)") do
				local it = {[0]=chunk:gsub("[()%[%].%-+*%%]", "%%%0")}
				for var in inner:gmatch("[^:]+") do
					it[#it+1] = var
				end
				t = t or {}
				t[#t+1] = it
			end
			if t then
				local nv = {}
				for i=1,#t do nv[i] = 1 end
				while 1 do
					local pat = pat
					for i=1,#nv do
						pat = pat:gsub(t[i][0], t[i][nv[i]])
					end
					captures[#captures+1], captures[#captures+2], captures[#captures+3] = "^" .. pat:gsub("%z", "(%%d+)") .. "$", f, s
					for i=#nv, 0, -1 do
						if i == 0 then return end
						nv[i] = nv[i] % #t[i] + 1
						if nv[i] > 1 then break end
					end
				end
			else
				captures[#captures+1], captures[#captures+2], captures[#captures+3] = "^" .. pat:gsub("%z", "(%%d+)") .. "$", f, s
			end
		end
		proc(GARRISON_DURATION_DAYS, 86400, 0)
		proc(GARRISON_DURATION_DAYS_HOURS, 86400, 3600)
		proc(GARRISON_DURATION_HOURS, 3600, 0)
		proc(GARRISON_DURATION_HOURS_MINUTES, 3600, 60)
		proc(GARRISON_DURATION_MINUTES, 60, 0)
		proc(GARRISON_DURATION_SECONDS, 1, 0)
	end
	setmetatable(parseTime, {__index=function(self, k)
		if k == nil then return 0 end
		local ret = INF
		for i=1,#captures, 3 do
			local a, b = k:match(captures[i])
			if a then
				ret = tonumber(a) * captures[i+1] + (b and tonumber(b) * captures[i+2] or 0)
				break
			end
		end
		self[k] = ret
		return ret
	end})
end
function api.GetSecondsFromTimeString(time)
	local t = parseTime[time]
	return t and t > 59 and (t + 60) or t
end
function api.GetTimeStringFromSeconds(sec)
	if sec < 60 then
		return GARRISON_DURATION_SECONDS:format(sec < 0 and 0 or sec)
	elseif sec < 3600 then
		return GARRISON_DURATION_MINUTES:format(sec/60)
	elseif sec < 84600 then
		return (sec % 3600 < 60 and GARRISON_DURATION_HOURS or GARRISON_DURATION_HOURS_MINUTES):format(sec/3600, (sec/60) % 60)
	else
		return (sec % 86400 < 3600 and GARRISON_DURATION_DAYS or GARRISON_DURATION_DAYS_HOURS):format(sec/84600, (sec/3600) % 24)
	end
end

local dropFollowers, missionEndTime = {}, {} do -- Start/Available capture
	local complete, startQueue, startQueueSize, it = {}, {}, 0, 1
	function api.GetAvailableMissions(mt)
		local t = C_Garrison.GetAvailableMissions(mt or 1) or {}
		securecall(api.ObserveMissions, t, 1)
		local i, n, nit, dropCost = 1, #t, it % 2 + 1, 0
		while i <= n do
			local mid = t[i].missionID
			if complete[mid] then
				t[i], complete[mid], n, dropCost, t[n] = i < n and t[n] or nil, nit, n - 1, dropCost + (t[i].cost or 0)
			else
				i = i + 1
			end
		end
		it = nit
		for k,v in pairs(complete) do
			if v ~= nit then
				complete[k] = nil
			end
		end
		for k,v in pairs(dropFollowers) do
			if not complete[v] then
				dropFollowers[k] = nil
			end
		end
		return t, dropCost
	end
	function api.StartMission(id)
		local mi, f1, f2, f3 = C_Garrison.GetBasicMissionInfo(id)
		if not mi then return error("Mission is not available") end
		for j=1,#mi.followers do
			local fid = mi.followers[j]
			dropFollowers[fid], f1, f2, f3 = id, fid, f1, f2
		end
		local nf = (f1 and 1 or 0) + (f2 and 1 or 0) + (f3 and 1 or 0)
		if nf ~= mi.numFollowers then return error(tostring(mi.numFollowers) .. " followers expected; " .. nf .. " assigned") end
		complete[id], missionEndTime[id] = it, time()+select(2,C_Garrison.GetPartyMissionInfo(id))
		C_Garrison.StartMission(id)
		wipe(data)
		EV("MP_MISSION_START", id, f1, f2, f3)
		return f1, f2, f3
	end
	function api.IsMissionAvailable(id)
		if not complete[id] and C_Garrison.GetMissionTimes(id) ~= nil and C_Garrison.GetMissionSuccessChance(id) == nil then
			local mi = C_Garrison.GetBasicMissionInfo(id)
			return mi and mi.state == -2 and mi or nil
		end
	end
	local function releaseQueued(mid, toTentative)
		local q = startQueue[mid]
		if q then
			startQueueSize, missionEndTime[mid], startQueue[mid], complete[mid] = startQueueSize - 1
			local f1, f2, f3 = q[1], q[2], q[3]
			for i=1,3 do
				if f1 then
					C_Garrison.RemoveFollowerFromMission(mid, f1)
					dropFollowers[f1] = nil
				end
				f1, f2, f3 = f2, f3, f1
			end
			if toTentative then
				api.SaveMissionParty(mid, f1, f2, f3)
			end
		end
	end
	local function pushStart(id, f1, f2, f3)
		local mi, _, cgr = C_Garrison.GetBasicMissionInfo(id), Nine.GetCurrencyInfo(824)
		if not mi or (cgr or 0) < (mi.cost or 0) then
			releaseQueued(id)
			EV("MP_MISSION_REJECT", id, f1, f2, f3)
			return
		end
		local mif = mi.followers
		for i=1,mif and #mif or 0 do
			C_Garrison.RemoveFollowerFromMission(id, mif[i])
		end
		local p1, p2 = f1, f2
		for i=1, mi.numFollowers do
			if C_Garrison.GetFollowerMissionTimeLeft(p1) ~= nil then
				releaseQueued(id)
				EV("MP_MISSION_REJECT", id, f1, f2, f3)
				return
			end
			C_Garrison.AddFollowerToMission(id, p1)
			p1, p2, dropFollowers[p1] = p2, f3, id
		end
		complete[id], missionEndTime[id] = it, 5+time()+select(2,C_Garrison.GetPartyMissionInfo(id))
		wipe(data)
		C_Garrison.StartMission(id)
		return true
	end
	local function startQueuePing()
		if next(startQueue) then
			C_Timer.After(0.5, startQueuePing)
		end
		api.SuppressFollowerEvents(1) --FIXME: MP doesn't use false-start for ship groups
		for k, v in pairs(startQueue) do
			pushStart(k, v[1], v[2], v[3])
		end
		api.ReleaseFollowerEvents(1)
	end
	function api.StartMissionQueue(id, f1, f2, f3)
		local fi, fc = api.GetFollowerInfo(), C_Garrison.GetMissionMaxFollowers(id) or 0
		for i=1,fc do
			local fi = fi[i == 1 and f1 or i == 2 and f2 or i == 3 and f3]
			if not (fi and C_Garrison.GetFollowerMissionTimeLeft(fi.followerID) == nil) then
				fc = 0
				break
			end
		end
		if fc < 1 then
			EV("MP_MISSION_REJECT", id, f1, f2, f3)
			return
		end
		if not next(startQueue) then
			C_Timer.After(0.5, startQueuePing)
		end
		startQueue[id], startQueueSize = {f1, f2, f3}, startQueueSize + (startQueue[id] and 0 or 1)
		if pushStart(id, f1, f2, f3) then
			EV("MP_MISSION_START", id, f1, f2, f3)
		end
	end
	function api.AbortMissionQueue()
		if startQueueSize > 0 then
			for k in pairs(startQueue) do
				releaseQueued(k, true)
			end
			startQueueSize = 0
			EV("MP_MISSION_START_QUEUE", startQueueSize)
		end
	end
	function api.GetNumPendingMissionStarts()
		return startQueueSize
	end
	function EV:GARRISON_MISSION_STARTED(_tid, id)
		if startQueue[id] then
			startQueueSize, startQueue[id] = startQueueSize - 1
			EV("MP_MISSION_START_QUEUE", startQueueSize)
		end
	end
	function EV:GARRISON_MISSION_NPC_CLOSED()
		wipe(complete)
		wipe(dropFollowers)
		wipe(missionEndTime)
		wipe(startQueue)
		if startQueueSize > 0 then
			startQueueSize = 0
			EV("MP_MISSION_START_QUEUE", startQueueSize)
		end
	end
end

local function SetFollowerInfo(t)
	local ft, now, um = {}, time(), 0
	local TC, ET = T.TraitCost, T.EquivTrait
	for i=1,#t do
		local v = t[i]
		if v.isCollected then
			local fid, tc, counters, traits, ship = v.followerID, 0, {}, {}, v.followerTypeID == 2
			if v.followerTypeID == 2 then
				for j=1,2 do
					local q = j == 1 and C_Garrison.GetFollowerAbilityAtIndex or C_Garrison.GetFollowerTraitAtIndex
					for i=1,2 do
						local aid = q(fid, i)
						if aid > 0 then
							traits[aid], counters[aid], tc = aid, C_Garrison.GetFollowerAbilityCounterMechanicInfo(aid), tc + (TC[ET[aid] or aid] or 0)
						end
					end
				end
			else
				for i=1,3 do
					local aid, tid = C_Garrison.GetFollowerAbilityAtIndex(fid, i), C_Garrison.GetFollowerTraitAtIndex(fid, i)
					if ship then
						if tid > 0 then
							counters[tid] = C_Garrison.GetFollowerAbilityCounterMechanicInfo(tid)
						end
						if aid > 0 then
							traits[aid] = aid
						end
					else
						if aid > 0 then
							counters[aid] = C_Garrison.GetFollowerAbilityCounterMechanicInfo(aid)
						end
						if tid > 0 then
							traits[tid], tc = tid, tc + (TC[ET[tid] or tid] or 0)
						end
					end
				end
			end
			v.counters, v.traits, v.traitCost, v.isCombat = counters, traits, tc, v.isCollected and not unfreeStatusOrder[v.status] or false
			local tls = C_Garrison.GetFollowerMissionTimeLeftSeconds(fid)
			if v.quality >= 4 and v.level == FOLLOWER_LEVEL_CAP then um = um + 1 end
			ft[fid], v.missionEndTime, v.affinity = v, tls and (now + tls) or nil, T.Affinities[v.garrFollowerID or v.followerID]
		end
	end
	if um > 10 then T.config.goldRewardThreshold = 0 end
	for k,v in pairs(dropFollowers) do
		local f = ft[k]
		if not f.missionEndTime then
			f.status, f.missionEndTime = GARRISON_FOLLOWER_ON_MISSION, missionEndTime[v]
		end
	end
	data.followers = ft
	f:Show()
end
local function followerIDcmp(a, b)
	return a.followerID < b.followerID
end
function api.MergeFollowersAndShipyard(f)
	local g, s = f(1), f(2)
	for i=1,g and s and #s or 0 do
		g[#g+1] = s[i]
	end
	return g or s or {}
end
function api.GetFollowerInfo(refresh)
	if not data.followers or refresh then
		SetFollowerInfo(api.MergeFollowersAndShipyard(C_Garrison.GetFollowers))
	end
	return data.followers
end
function api.GetFollowerIdentity(includeInactive, includeStatus, folType)
	local f = C_Garrison.GetFollowers(folType)
	local last = #f
	for i=last, 1, -1 do
		if not f[i].isCollected then
			f[i], last, f[last] = last ~= i and f[last] or nil, last - 1
		end
	end
	table.sort(f, followerIDcmp)
	local ignore, sig = T.config.ignore, ""
	for i=1,#f do
		local v = f[i]
		if includeInactive or v.status ~= GARRISON_FOLLOWER_INACTIVE then
			local k, q = v.followerID, ""
			q = "#" .. k .. "-" .. v.level .. "-" .. v.iLevel
			for j=1,4 do
				q = q .. "#" .. (C_Garrison.GetFollowerAbilityAtIndex(k, j) or 0) .. "#" .. (C_Garrison.GetFollowerTraitAtIndex(k, j) or 0)
			end
			sig = sig .. q .. (v.status == GARRISON_FOLLOWER_INACTIVE and "#in#" or "#") .. (includeStatus and (dropFollowers[k] and GARRISON_FOLLOWER_ON_MISSION or v.status ~= GARRISON_FOLLOWER_IN_PARTY and v.status or ".") .. "#" .. (tentativeState[k] or "-") or "") .. (ignore[k] and "i" or "-")
		end
	end
	return sig
end
function api.PushFollowerPartyStatus(fid)
	if data.followers and data.followers[fid] then
		data.followers[fid].status = GARRISON_FOLLOWER_IN_PARTY
	end
end
function api.GetCounterInfo()
	if not data.counters then
		local ci = {}
		for fid, info in pairs(api.GetFollowerInfo()) do
			local u1, u2
			for _,k in pairs(info.counters) do
				if k ~= u1 and k ~= u2 then
					local t = ci[k] or {}
					ci[k], t[#t+1], u1, u2 = t, fid, k, u1
				end
			end
		end
		data.counters = ci
		f:Show()
	end
	return data.counters
end
function api.GetDoubleCounters(skipInactive)
	local ckey = skipInactive and "counters2" or "counters2i"
	if not data[ckey] then
		local rt, aai, cai = {}, C_Garrison.GetFollowerAbilityAtIndex, C_Garrison.GetFollowerAbilityCounterMechanicInfo
		local keepInactive = not skipInactive
		for fid, fi in pairs(api.GetFollowerInfo()) do
			if not T.config.ignore[fid] and (keepInactive or fi.status ~= GARRISON_FOLLOWER_INACTIVE) and fi.followerTypeID == 1 then
				if fi.quality >= 4 then
					local c1, c2 = cai(aai(fid, 1)), cai(aai(fid, 2))
					local k, k2 = c1*100 + c2, c2*100 + c1
					local tk = rt[k] or {key=k}
					tk[#tk + 1], rt[k], rt[k2] = fi.followerID, tk, tk
				end
				local sc = T.SpecCounters[fi.classSpec]
				if sc then
					local lockedCounter = api.GetFollowerLockedCounterInfo(fi.garrFollowerID or fi.followerID)
					for i=1,#sc do
						for j=lockedCounter and #sc or (i+1),#sc do
							local c1, c2 = sc[i], lockedCounter or sc[j]
							local k, k2 = -(c1*100 + c2), -(c2*100 + c1)
							local tk = rt[k] or {key=k}
							tk[#tk + 1], rt[k], rt[k2] = fi.followerID, tk, tk
						end
					end
				end
			end
		end
		data[ckey] = rt
		f:Show()
	end
	return data[ckey]
end
function api.GetFollowerTraits()
	if not data.traits then
		local ci, et = {}, T.EquivTrait
		for fid, info in pairs(api.GetFollowerInfo()) do
			local afid = info.followerTypeID == 1 and info.affinity and info.affinity > 0 and info.affinity
			if afid then
				local t = ci[afid] or {}
				ci[afid], t = t, t.affine or {}
				ci[afid].affine, t[#t+1] = t, fid
			end
			for k in pairs(info.traits) do
				repeat
					local t = ci[k] or {}
					ci[k], t[#t+1], k = t, fid, et[k]
				until not k
			end
		end
		data.traits = ci
		f:Show()
	end
	return data.traits
end
do -- api.GetMechanicInfo(mid/tex)
	local counter, desc = {}, {}
	local function addCounter(k, tid)
		local id, _, tex = C_Garrison.GetFollowerAbilityCounterMechanicInfo(tid)
		if id then
			local lc = tostring(tex):lower()
			counter[k], counter[id], counter[lc], counter[lc:gsub("%.blp$","")] = tid, tid, tid, tid
		end
	end
	local function populate()
		for _, fid in pairs({6, 118, 127, 131, 138, 140, 144}) do
			for _, a in pairs(C_Garrison.GetFollowerAbilities(fid)) do
				for k,t in pairs(a.counters) do
					local lc = tostring(t.icon):lower()
					counter[k], counter[lc], counter[lc:gsub("%.blp$","")], desc[k] = a.id, a.id, a.id, t.description
				end
			end
		end
		for k, v in pairs(T.EnvironmentCounters) do
			addCounter(k, v)
		end
		for k, v in pairs(T.EquipmentCounters) do
			addCounter(k, v)
		end
	end
	function api.GetMechanicInfo(mid)
		if type(mid) == "string" then
			mid = mid:lower():gsub("%.blp$","")
		end
		if populate then
			populate = populate()
		end
		if counter[mid] then
			local id, name, tex = C_Garrison.GetFollowerAbilityCounterMechanicInfo(counter[mid])
			return id, name, tex, desc[id]
		elseif mid == 85 then
			return 85, L"Expert Captain", "Interface\\Icons\\INV_Helmet_66", ""
		end
	end
end
function api.GetMissionThreats(missionID)
	local ret, rn, en = {}, 1, select(8,C_Garrison.GetMissionInfo(missionID))
	for i=1,#en do
		local mech = en[i].mechanics
		for i=1,#mech do
			ret[rn], rn = mech[i].mechanicTypeID, rn + 1
		end
	end
	return ret
end
do -- sortByFollowerLevels
	local lvl
	local function cmp(a,b)
		local af, bf, ac, bc = lvl[a], lvl[b], a, b
		if (not af) ~= (not bf) then
			return not not af
		elseif af and bf then
			ac, bc = unfreeStatusOrder[af.status] or 3, unfreeStatusOrder[bf.status] or 3
			if ac == bc and (not T.config.ignore[af.followerID]) ~= (not T.config.ignore[bf.followerID]) then
				return not T.config.ignore[af.followerID]
			end
			if ac == bc then
				ac, bc = af.level or 0, bf.level or 0
				if ac == bc and ac == FOLLOWER_LEVEL_CAP then
					ac, bc = af.iLevel or 0, bf.iLevel or 0
				end
			end
			if ac == bc then
				ac, bc = C_Garrison.GetFollowerQuality(a), C_Garrison.GetFollowerQuality(b)
			end
		end
		if ac == bc then ac, bc = a, b end
		return ac > bc
	end
	function api.sortByFollowerLevels(counters, finfo)
		lvl = finfo
		table.sort(counters, cmp)
		lvl = nil
		return counters
	end
end
function api.GetFMLevel(fmInfo, mentor)
	return fmInfo and (mentor and mentor >= fmInfo.iLevel and mentor or fmInfo.level == FOLLOWER_LEVEL_CAP and fmInfo.iLevel > 600 and fmInfo.iLevel or fmInfo.level) or 0
end
function api.GetLevelEfficiency(fLevel, mLevel)
	local ld, md = (mLevel or 0) - fLevel, mLevel and (mLevel > 600 and 15 or 3) or 0
	return ld <= 0 and 1 or ld < md and (md-ld)/md or 0
end
function api.GetFollowerLevelDescription(fid, mlvl, fi, mentor, mid, gi)
	local fi = fi or api.GetFollowerInfo()[fid]
	if not fi then
		return "[??] " .. tostring(fid)
	end
	local tooLow, q = api.GetLevelEfficiency(api.GetFMLevel(fi, mentor), mlvl) < 0.5, fi and fi.quality or 0
	local lc, away = ITEM_QUALITY_COLORS[tooLow and 0 or q].hex, fi.missionEndTime
	if fi.status == GARRISON_FOLLOWER_INACTIVE then
		away = "|cffccc78f (" .. GARRISON_FOLLOWER_INACTIVE .. ")"
	elseif fi.status == GARRISON_FOLLOWER_WORKING then
		away = YELLOW_FONT_COLOR_CODE .. " (" .. GARRISON_FOLLOWER_WORKING .. ")"
	elseif away then
		away = "|cffa0a0a0 (" .. api.GetTimeStringFromSeconds(away-time()) .. ")"
	elseif mid and (api.GetFollowerTentativeMission(fi.followerID) or mid) ~= mid then
		away = "|cffa0a0a0 (" .. L"In Tentative Party" .. ")"
	elseif T.config.ignore[fid] then
		away = RED_FONT_COLOR_CODE .. " (" .. L"Ignored" .. ")"
	else
		away = ""
	end
	if fi.followerTypeID == 1 and fi.level == FOLLOWER_LEVEL_CAP and fi.quality >= 4 and tooLow then
		away = ITEM_QUALITY_COLORS[4].hex .. L"*" .. (away ~= "" and "|r " .. away or "|r")
	end
	if gi and mlvl and (fi.level < FOLLOWER_LEVEL_CAP or fi.quality < 4) then
		local xpd, base, bonus = fi.levelXP - fi.xp, api.GetFollowerXPGain(fi, mlvl, gi[2], gi[8], mentor)
		if gi[1] == 100 then base, bonus = base + bonus, 0 end
		if xpd <= base then
			away = " |cff10ff10+" .. away
		elseif xpd <= (base + bonus) then
			away = " |cff00aaff+" .. away
		end
	end
	if fi.followerTypeID == 2 then
		return ('%s"%s"|r%s'):format(ITEM_QUALITY_COLORS[fi.quality].hex, fi.name, away)
	end
	return ("%s[%d]|r %s%s|r%s"):format(lc, fi.level < FOLLOWER_LEVEL_CAP and fi.level or fi.iLevel, HIGHLIGHT_FONT_COLOR_CODE, fi.name, away)
end
function api.GetOtherCounterIcons(fi, mechanic)
	local fid, reorder, firstID, ret = fi.followerID, mechanic == nil
	for i=1,2 do
		local aid = C_Garrison.GetFollowerAbilityAtIndex(fid, i)
		if aid ~= 0 then
			local mid, _, ico = C_Garrison.GetFollowerAbilityCounterMechanicInfo(aid)
			if reorder then
				if i == 1 then
					firstID = mid or aid
				elseif mid and mid < firstID then
					mechanic = mid
				end
			end
			if mid and mid == mechanic then
				ret, mechanic = (ret and ret .. " " or "") .. "|T" .. ico .. ":0:0:0:0:64:64:6:58:6:58|t"
			elseif mid then
				ret = "|T" .. ico .. ":0:0:0:0:64:64:6:58:6:58|t" .. (ret and " " .. ret or "")
			end
		end
	end
	return ret or ""
end
function api.GetNumIdleCombatFollowers(followers)
	local ret = 0
	for k,v in pairs(followers or api.GetFollowerInfo()) do
		if v.isCollected and (v.status == nil or v.status == GARRISON_FOLLOWER_IN_PARTY) then
			ret = ret + 1
		end
	end
	return ret
end

do -- CompleteMissions/AbortCompleteMissions
	local curStack, curRewards, curFollowers, curCallback, curOverflow
	local curSalvage, curPlayerXP = {[114120]=0, [114119]=0, [114116]=0, [140590]=0, [139593]=0}, {}
	local curState, curIndex, completionStep, lastAction, delayIndex, delayMID
	local function checkSalvage(addRewards)
		for k,v in pairs(curSalvage) do
			local nv = GetItemCount(k) or 0
			if addRewards and nv > v then
				local ik = "item:" .. k
				curRewards[ik] = curRewards[ik] or {itemID=k, quantity=0}
				curRewards[ik].quantity = curRewards[ik].quantity + nv - v
			end
			curSalvage[k] = nv
		end
		local nxp, nlvl = UnitXP("player"), UnitLevel("player")
		if addRewards and curPlayerXP[1] and (curPlayerXP[1] < nxp or curPlayerXP[3] < nlvl) then
			curRewards.xp = curRewards.xp or {playerXP=0}
			curRewards.xp.playerXP = curRewards.xp.playerXP + (curPlayerXP[3] < nlvl and curPlayerXP[2] or 0) + nxp - curPlayerXP[1]
		end
		curPlayerXP[1], curPlayerXP[2], curPlayerXP[3] = nxp, UnitXPMax("player"), nlvl
	end
	local delayOpen, delayRoll do
		local function delay(state, f, d)
			local function delay(minDelay)
				if curState == state and curIndex == delayIndex and curStack[delayIndex].missionID == delayMID then
					local time = GetTime()
					if not minDelay and (not lastAction or (time-lastAction >= d)) then
						lastAction = GetTime()
						f(curStack[curIndex].missionID)
						C_Timer.After(d, delay)
					else
						C_Timer.After(math.max(0.1, d + lastAction - time, minDelay or 0), delay)
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
		if curState == "ABORT" or curState == "DONE" then
			checkSalvage(true)
			securecall(curCallback, curState, curStack, curRewards, curFollowers, curOverflow)
			curState, curStack, curRewards, curFollowers, curIndex, curCallback, delayMID, delayIndex = nil
		end
	end
	local function isWastingCurrency(mi)
		if mi.rewards then
			mi.skipped = nil
			for k,v in pairs(mi.rewards) do
				if v.currencyID then
					local rew, cur, tmax, _ = v.quantity * api.GetRewardMultiplier(mi, v.currencyID)
					if v.currencyID > 0 then
						_, cur, _, _, _, tmax = Nine.GetCurrencyInfo(v.currencyID)
					else
						cur, tmax = GetMoney(), 1e11-1
					end
					if tmax > 0 and (cur+rew-tmax) > rew * T.config.currencyWasteThreshold then
						mi.skipped, curState, curIndex = true, "NEXT", curIndex + 1
						completionStep("GARRISON_MISSION_NPC_OPENED", "IMMEDIATE")
						return true
					end
				end
			end
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
	function completionStep(ev, ...)
		if not curState then return end
		local mi = curStack[curIndex]
		while mi and (mi.succeeded or mi.failed) do
			mi, curIndex = curStack[curIndex+1], curIndex + 1
		end
		if (ev == "GARRISON_MISSION_NPC_CLOSED" and mi) or not mi then
			curState = mi and "ABORT" or "DONE"
			C_Timer.After(... == "IMMEDIATE" and 0 or 0.5, delayDone)
		elseif curState == "NEXT" and ev == "GARRISON_MISSION_NPC_OPENED" then
			api.ExtendMissionInfoWithParty(mi)
			if not mi.completed then
				curState, delayIndex, delayMID = "COMPLETE", curIndex, mi.missionID
				delayOpen(... ~= "IMMEDIATE" and 0.2)
			elseif not isWastingCurrency(mi) then
				curState, delayIndex, delayMID = "BONUS", curIndex, mi.missionID
				delayRoll(... ~= "IMMEDIATE" and 0.2)
			end
		elseif curState == "COMPLETE" and ev == "GARRISON_MISSION_COMPLETE_RESPONSE" then
			local mid, cc, ok = ...
			if mid ~= mi.missionID and not cc then return end
			if mid == mi.missionID or securecall(error, whineAboutUnexpectedState("Unexpected mission completion", mid, (cc and "C" or "c") .. (ok and "K" or "k")), 2) then
				if ok then
					api.ExtendMissionInfoWithParty(mi)
					mi.state, curState = 0, "BONUS"
				else
					mi.failed, curState, curIndex = cc and true or nil, "NEXT", curIndex + 1
				end
				if cc then
					securecall(curCallback, "STEP", curStack, curRewards, curFollowers, ok and "COMPLETE" or "FAIL", mi.missionID)
				end
				if ok then
					if isWastingCurrency(mi) then return end
					delayIndex, delayMID = curIndex, mi.missionID
					delayRoll(0.2)
				else
					C_Timer.After(0.45, delayStep)
				end
			end
		elseif curState == "BONUS" and ev == "GARRISON_MISSION_BONUS_ROLL_COMPLETE" then
			local mid, _ok = ...
			if mid == mi.missionID or securecall(error, whineAboutUnexpectedState("Unexpected bonus roll completion", mid, _ok and "K" or "k"), 2) then
				mi.succeeded, curState, curIndex = true, "NEXT", curIndex + 1
				if mi.rewards then
					for k,r in pairs(mi.rewards) do
						if r.currencyID and r.quantity then
							local ik, q = "cur:" .. r.currencyID, r.quantity
							q = floor(r.quantity * api.GetRewardMultiplier(mi, r.currencyID))
							curRewards[ik] = curRewards[ik] or {quantity=0, currencyID=r.currencyID}
							curRewards[ik].quantity = curRewards[ik].quantity + q
						elseif r.itemID and r.quantity then
							local ik = "item:" .. r.itemID
							curRewards[ik] = curRewards[ik] or {itemID=r.itemID, quantity=0}
							curRewards[ik].quantity = curRewards[ik].quantity + r.quantity
						end
					end
				end
				securecall(curCallback, "STEP", curStack, curRewards, curFollowers, "LOOT", mi.missionID)
			end
		end
	end
	function EV:GARRISON_FOLLOWER_XP_CHANGED(_, fid, xpAward, oldXP, olvl, oqual)
		if curState then
			curFollowers[fid] = curFollowers[fid] or {olvl=olvl, oqual=oqual, xpAward=0, oxp=oldXP}
			curFollowers[fid].xpAward = curFollowers[fid].xpAward + xpAward
		end
	end
	function EV:UI_ERROR_MESSAGE(msg)
		if curState and msg == ERR_ITEM_INVENTORY_FULL_SATCHEL then
			curOverflow = true
		end
	end
	EV.GARRISON_MISSION_NPC_OPENED, EV.GARRISON_MISSION_NPC_CLOSED = completionStep, completionStep
	EV.GARRISON_MISSION_BONUS_ROLL_COMPLETE, EV.GARRISON_MISSION_COMPLETE_RESPONSE = completionStep, completionStep
	function api.CompleteMissions(stack, callback)
		curStack, curCallback, curRewards, curFollowers, curOverflow = stack, callback, {}, {}
		curState, curIndex = "NEXT", 1, checkSalvage(false)
		completionStep("GARRISON_MISSION_NPC_OPENED", "IMMEDIATE")
	end
	function api.AbortCompleteMissions()
		completionStep("GARRISON_MISSION_NPC_CLOSED")
	end
	function api.GetCompletionState()
		return curState, curIndex, curStack, curRewards, curFollowers, curOverflow
	end
end

do -- GetMissionSeen
	local lastOffer, expire = {}, T.MissionExpire
	function api.ObserveMissions(missions, mtype)
		local dnow = GetServerTime() - GetTime()
		if not missions then
			missions, mtype = C_Garrison.GetAvailableMissions() or {}, "*"
		end
		for i=1,#missions do
			local mi = missions[i]
			local ex, oet = expire[mi.missionID], mi.offerEndTime
			if oet and ex and ex > 0 then
				lastOffer[mi.missionID] = floor(dnow + oet - ex * 3600)
			end
			local p = tentativeParties[mi.missionID]
			if p then
				p.tag = true
			end
		end

		local d = false
		for k,v in pairs(tentativeParties) do
			if (mtype == "*" or C_Garrison.GetFollowerTypeByMissionID(k) == mtype) and not v.tag then
				api.GetMissionParty(k, true)
				d = true
			end
			v.tag = nil
		end
		if d then
			EV("MP_TENTATIVE_PARTY_UPDATE")
		end
	end
	local shortHourFormat = GARRISON_DURATION_HOURS:gsub("%%[%d$]*d", "%%s")
	function api.GetMissionSeen(mid, mi)
		local mi, lastAppeared, now = mi or C_Garrison.GetBasicMissionInfo(mid), lastOffer[mid], GetServerTime()
		local tl = mi and mi.offerEndTime and (mi.offerEndTime - GetTime()) or -1
		return tl, mi and mi.offerTimeRemaining or tl >= 0 and api.GetTimeStringFromSeconds(tl) or "", tl >= 0 and shortHourFormat:format(math.floor(tl/3600+0.5)) or "", lastAppeared and (now-lastAppeared)
	end
	function T._SetMissionSeenTable(seenTable)
		if type(seenTable) == "table" then
			for k,v in pairs(seenTable) do
				if type(k) == "number" and type(v) == "number" then
					lastOffer[k] = v
				end
			end
		end
	end
	function T._GetMissionSeenTable()
		if next(lastOffer) ~= nil then
			return lastOffer
		end
	end
end

do -- PrepareAllMissionGroups/GetMissionGroups {sc xp gr ti p1 p2 p3 xp pb}
	local msf, msi, msd, finfo, msiMentorIndex, mentorLevel = {}, {}, {}
	local suppressFollowerEvents, releaseFollowerEvents do
		local level, frames, followers = 0
		local function failsafe()
			if level > 0 then
				level = 1
				releaseFollowerEvents()
			end
		end
		function suppressFollowerEvents(mt)
			if level == 0 then
				frames, followers = {GetFramesRegisteredForEvent("GARRISON_FOLLOWER_LIST_UPDATE")}, {}
				for i=1,#frames do
					frames[i]:UnregisterEvent("GARRISON_FOLLOWER_LIST_UPDATE")
				end
				local mmi = C_Garrison.GetAvailableMissions(mt) or {}
				for i=1,#mmi do
					for k,v in pairs(mmi[i].followers) do
						C_Garrison.RemoveFollowerFromMission(mmi[i].missionID, v)
						followers[v] = mmi[i].missionID
					end
				end
				T.After0(failsafe)
			end
			level = level + 1
		end
		function releaseFollowerEvents(mt)
			assert(level > 0, "release not matched to suppress")
			level = level - 1
			if level == 0 then
				for i=1,(not mt) and 2 or 1 do
					local mt = not mt and i or mt
					local mmi = C_Garrison.GetAvailableMissions(mt) or {}
					for i=1,#mmi do
						for k,v in pairs(mmi[i].followers) do
							C_Garrison.RemoveFollowerFromMission(mmi[i].missionID, v)
						end
					end
					for f, m in pairs(followers) do
						C_Garrison.AddFollowerToMission(m, f)
					end
				end
				for i=1,#frames do
					frames[i]:RegisterEvent("GARRISON_FOLLOWER_LIST_UPDATE")
				end
				frames, followers = nil, nil
			end
		end
		api.SuppressFollowerEvents, api.ReleaseFollowerEvents = suppressFollowerEvents, releaseFollowerEvents
	end
	local function cmp_level(a, b)
		local a, b = finfo[a], finfo[b]
		return (a.level + a.iLevel) > (b.level + b.iLevel)
	end
	local function doPrepareMissionGroups(mmi)
		for i=1,#mmi do
			api.GetMissionGroups(mmi[i].missionID, i > 1, mmi[i])
		end
	end
	function api.PrepareAllMissionGroups(mtype)
		suppressFollowerEvents(mtype)
		local mmi = C_Garrison.GetAvailableMissions(mtype or 1) or {}
		securecall(api.ObserveMissions, mmi, mtype or 1)
		securecall(doPrepareMissionGroups, mmi)
		releaseFollowerEvents(mtype)
		return mmi
	end
	function api.GetMissionGroups(mid, trustValid, omi)
		local mt = C_Garrison.GetFollowerTypeByMissionID(mid)
		if not trustValid or not msi[1] or not securecall(assert, msi.typeID == mt, "trust/type mismatch") then
			finfo, msiMentorIndex, mentorLevel = api.GetFollowerInfo()
			local valid, fn = true, 1
			for k,v in pairs(finfo) do
				if v.isCollected and v.status ~= GARRISON_FOLLOWER_INACTIVE  and v.followerTypeID == mt then
					local key = v.level .. "#" .. v.iLevel
					for i=1,4 do
						key = key .. "#" .. (C_Garrison.GetFollowerAbilityAtIndex(k, i) or 0) .. "#" .. (C_Garrison.GetFollowerTraitAtIndex(k, i) or 0)
					end
					msi[fn], fn, msf[k], valid = k, fn+1, key, valid and msf[k] == key
				end
			end
			for i=fn,#msi do
				valid, msi[i] = false
			end
			table.sort(msi, cmp_level)
			for i=1,#msi do
				if finfo[msi[i]].garrFollowerID == MENTOR_FOLLOWER then
					msiMentorIndex, mentorLevel = i, finfo[msi[i]].iLevel
					break
				end
			end
			for k in pairs(msf) do
				if not (finfo[k] and finfo[k].isCollected and finfo[k].status ~= GARRISON_FOLLOWER_INACTIVE) then
					valid, msf[k] = false
				end
			end
			if not valid then wipe(msd) end
			msi.typeID, finfo = mt, nil
		end
		local ret = msd[mid]
		if not ret or (omi and ret.hasBonusEffect ~= omi.hasBonusEffect) then
			local mi = C_Garrison.GetBasicMissionInfo(mid)
			if not mi then
				return false
			elseif mi.numFollowers > #msi then
				msd[mid] = {hasBonusEffect=mi.hasBonusEffect}
				return msd[mid]
			end
			
			local baseCurrency, curID, chestXP, _, baseXP = 0, -1, 0, C_Garrison.GetMissionInfo(mid)
			for k,r in pairs(mi.rewards) do
				if r.currencyID and not T.TraitStack[curID] then
					baseCurrency, curID = r.quantity, r.currencyID
				elseif r.followerXP then
					chestXP = chestXP + r.followerXP
				end
			end
			
			suppressFollowerEvents(mt)
			
			local fn, t, fm, m, mn = #msi, {}, {}, {hasBonusEffect=mi.hasBonusEffect}, 1
			fm[1] = fn
			for i=2,mi.numFollowers do
				fm[1], fm[2], fm[3] = fm[1] - 1, fm[1], fm[2]
			end
			t[1], t[2], t[3] = fm[1], fm[2], fm[3]

			local i1, i2, i3 = 1, mi.numFollowers > 1 and 2 or -1, mi.numFollowers > 2 and 3 or -1
			local af, rf, nf, getXPMul = C_Garrison.AddFollowerToMission, C_Garrison.RemoveFollowerFromMission, mi.numFollowers, api.GetBuffsXPMultiplier
			local GetPartyMissionInfo, mentorSlot = C_Garrison.GetPartyMissionInfo
			repeat
				for i=nf,1,-1 do
					rf(mid, msi[t[i]])
					t[i] = t[i] % fm[i] + 1
					if t[i] > 1 or i == 1 then
						if not af(mid, msi[t[i]]) then error("Failed to add follower " .. i .. ":" .. tostring(t[i]) .. ":" .. tostring(msi[t[i]]) .. " to " .. tostring(mid)) end
						for j=i+1, nf do
							t[j]=t[j-1]+1
							if not af(mid, msi[t[j]]) then error("Failed to add follower " .. j .. ":" .. tostring(t[j]) .. ":" .. tostring(msi[t[j]]) .. " to " .. tostring(mid)) end
						end
						if msiMentorIndex and (mentorSlot or i) >= i then
							mentorSlot = nil
							for j=i,nf do
								if t[j] == msiMentorIndex then
									mentorSlot = j
									break
								end
							end
						end
						break
					end
				end
				local _totalTimeString, totalTimeSeconds, _isMissionTimeImproved, successChance, partyBuffs, _isEnvMechanicCountered, xpBonus, materialMultiplier, goldMultiplier = GetPartyMissionInfo(mid)
				m[mn], mn = {successChance, baseXP+xpBonus, baseCurrency*(curID == 0 and (goldMultiplier or 1) or (materialMultiplier and materialMultiplier[curID] or 1)), totalTimeSeconds, msi[t[i1]], msi[t[i2]], msi[t[i3]], chestXP * (partyBuffs and getXPMul(partyBuffs) or 1), curID, mentorSlot and mentorLevel}, mn + 1
			until t[1] == fm[1] and t[2] == fm[2] and t[3] == fm[3]
			
			for i=1,nf do
				C_Garrison.RemoveFollowerFromMission(mid, msi[t[i]])
			end
			msd[mid], ret = m, m
			releaseFollowerEvents(mt)
		end
		return ret
	end
	function EV:MP_RELEASE_CACHES()
		msd, msf, msi = {}, {}, {}
	end
end
function api.GetFilteredMissionGroups(minfo, filter, cmp, limit)
	local mg = api.GetMissionGroups(minfo.missionID)
	local best, finfo, sorted, now = {}, api.GetFollowerInfo(), false, time()
	for i=1,mg and #mg or 0 do
		local this = mg[i]
		if filter ~= nil and not filter(this, finfo, minfo) then
		elseif not limit or best[limit] == nil then
			best[#best+1] = this
			if limit and best[limit] then
				table.sort(best, function(a,b) return cmp(a, b, finfo, minfo) end)
				sorted = true
			end
		elseif cmp(this, best[limit], finfo, minfo) then
			best[limit] = this
			for i=limit-1, 1, -1 do
				if cmp(best[i], best[i+1], finfo, minfo) then
					break
				end
				best[i+1], best[i] = best[i], best[i+1]
			end
		end
	end
	if not sorted then
		table.sort(best, function(a,b) return cmp(a, b, finfo, minfo, now) end)
	end
	return best
end
local backfillGroupMatch do -- GetBackfillMissionGroups(minfo, filter, cmp, f1, f2, f3, f4)
	function backfillGroupMatch(g, nf, f1, f2, f3, f4)
		local g1, g2, g3 = g[5], g[6], g[7]
		local nm = f4 and (f4 == g1 or f4 == g2 or f4 == g3) and 1 or 0
		if f4 and nm == 0 then return end
		nm = nm + (f1 and (f1 == g1 or f1 == g2 or f1 == g3) and 1 or 0)
		        + (f2 and (f2 == g1 or f2 == g2 or f2 == g3) and 1 or 0)
		        + (f3 and (f3 == g1 or f3 == g2 or f3 == g3) and 1 or 0)
		return (nm == ((f1 and 1 or 0) + (f2 and 1 or 0) + (f3 and 1 or 0)) or nm == nf)
	end
	local filter, f1, f2, f3, f4
	local function backfillFilter(res, finfo, minfo)
		return backfillGroupMatch(res, minfo.numFollowers, f1, f2, f3, f4) and filter(res, finfo, minfo)
	end
	function api.GetBackfillMissionGroups(mi, afilter, cmp, limit, af1, af2, af3, af4)
		filter, f1, f2, f3, f4 = afilter, af1, af2, af3, af4
		return api.GetFilteredMissionGroups(mi, (af1 or af2 or af3 or af4) and backfillFilter or afilter, cmp or api.GetMissionDefaultGroupRank(mi), limit)
	end
end
do -- api.GetBuffsXPMultiplier(buffs)
	local xpBuffs = {[80]=0.30, [236]=0.35, [285]=0.5, [291]=0.5, [319]=0.5, [321]=0.5}
	function api.GetBuffsXPMultiplier(buffs)
		local mul = 1
		for i=1,#buffs do
			mul = mul + (xpBuffs[buffs[i]] or 0)
		end
		return mul
	end
end
function api.GetFollowerXPGain(fi, mlvl, base, bonus, mentor)
	if fi.quality >= 4 and fi.level == FOLLOWER_LEVEL_CAP then
		base, bonus = 0, 0
	elseif base > 0 or bonus > 0 then
		mentor, fi = mentor or 0, fi.traits and fi or api.GetFollowerInfo()[fi.followerID] or fi
		local flvl = fi.level == FOLLOWER_LEVEL_CAP and fi.iLevel or fi.level
		local tmul = fi.traits and fi.traits[29] and 1.50 or 1
		local emul = api.GetLevelEfficiency(mentor > flvl and mentor or flvl, mlvl)
		if base > 0 then
			base = base * tmul * emul
			if flvl < FOLLOWER_LEVEL_CAP and fi.xp + base > fi.levelXP then
				emul = api.GetLevelEfficiency(mentor > (flvl+1) and mentor or (flvl == 99 and 600 or (flvl+1)), mlvl)
			end
		end
		bonus = bonus * tmul * emul
	end
	return base, bonus
end
local risk = {} do
	setmetatable(risk, {__index=function(self, c)
		local rew, ret = T.config.riskReward
		if c == 100 then
			ret = 1
		elseif rew == 1 then
			ret = c/100
		elseif rew < 1 then
			ret = c * rew
		else
			ret = c + (1-c) * (rew-1)
		end
		self[c] = ret
		return ret
	end})
	function EV:MP_SETTINGS_CHANGED(s)
		if s == nil or s == "riskReward" then
			wipe(risk)
		end
	end
end
local timeHorizon, computeEquivXP, computeEarliestCompletion, flushGroupAnnotations do -- +api.GetSuggestedGroupsForMission
	local max, min, weakKeys = math.max, math.min, {__mode="k"}
	local equivXP, expectedXP, edtime = setmetatable({}, weakKeys), setmetatable({}, weakKeys), setmetatable({}, weakKeys)
	function computeEquivXP(g, finfo, minfo, force)
		local ret1, ret2
		if not force then
			ret1, ret2 = equivXP[g], expectedXP[g]
		end
		if not ret1 then
			local mlvl, conf, finfo = api.GetFMLevel(minfo), T.config, finfo or api.GetFollowerInfo()
			local risk, baseXP, bonusXP, mentor = risk[g[1]], g[2], g[8], g[10]
			local ecap, decay = conf.xpCapGrace, conf.levelDecay
			
			local expected, balanced = 0, 0
			for i=1, minfo.numFollowers do
				local fi = finfo[g[4+i]]
				local flvl, base, bonus = fi.level, api.GetFollowerXPGain(fi, mlvl, baseXP, bonusXP, mentor)
				if base > 0 or bonus > 0 then
					local ld = flvl - minfo.level - (flvl < 94 and 1 or 0) - (flvl < 98 and 1 or 0)
					ld = decay^(ld < 0 and 0 or ld > 3 and 3 or ld)
					if (flvl == 99 and fi.quality == 4) or (flvl == FOLLOWER_LEVEL_CAP and fi.quality == 3) then
						local cap = fi.levelXP - fi.xp
						balanced = balanced + (base + risk*max(0, min(bonus, cap + ecap - base))) * ld
						expected = expected + max(0, min(base, cap)) + g[1]/100 * max(0, min(bonus, cap - base))
					else
						balanced, expected = balanced + (base + risk * bonus) * ld, expected + base + g[1]/100 * bonus
					end
				end
			end
			ret1, ret2 = balanced, floor(expected)
			equivXP[g], expectedXP[g] = ret1, ret2
		end
		return ret1, ret2
	end
	function computeEarliestCompletion(g, finfo, minfo, force, now)
		local now, depart, complete = now or time()
		if not force then
			depart = edtime[g]
		end
		if depart == nil then
			local finfo, mid = finfo or api.GetFollowerInfo(), minfo.missionID
			for i=5, g[7] and 7 or g[6] and 6 or 5 do
				local f = finfo[g[i]]
				local tl = f.status == GARRISON_FOLLOWER_ON_MISSION and f.missionEndTime
				if not tl then
					local drop = dropFollowers[f.followerID]
					tl = drop and (missionEndTime[drop] or INF)
				end
				if not tl and (api.GetFollowerTentativeMission(f.followerID) or mid) ~= mid then
					tl = now
				end
				if tl and (depart or tl) <= tl then
					depart = tl
				end
			end
			depart = depart == INF and (now + 35999) or depart or false
			edtime[g] = depart
		end
		if (timeHorizon or 0) > 0 then
			local depart = (depart or now) <= now and now or depart
			if depart < timeHorizon and depart - T.config.timeHorizonMin - now > 0 then
				complete = timeHorizon + g[4]
			else
				complete = depart + g[4]
				complete = complete > timeHorizon and complete or timeHorizon
			end
		else
			complete = ((depart or now) <= now and now or depart) + g[4]
		end
		return complete, depart
	end
	function api.GetMissionGroupXP(g, minfo)
		return computeEquivXP(g, nil, minfo, false)
	end
	function api.GetMissionGroupDeparture(g, minfo)
		local _, edt = computeEarliestCompletion(g, nil, minfo)
		return edt
	end
	function flushGroupAnnotations(g)
		equivXP[g], expectedXP[g], edtime[g] = nil
	end

	local setFocusRank do
		local orank, f1, checkTime, mlvl
		local function focusRank(a, b, finfo, minfo, now)
			local ar, a1, a2 = risk[a[1]], api.GetFollowerXPGain(f1, mlvl, a[2], a[8], a[10])
			local br, b1, b2 = risk[b[1]], api.GetFollowerXPGain(f1, mlvl, b[2], b[8], b[10])
			local ac, bc = a1+a2*ar, b1+b2*br
			if ac > 0 and bc > 0 and (ac == bc or checkTime) then
				local at = computeEarliestCompletion(a, finfo, minfo, false, now)-now
				local bt = computeEarliestCompletion(b, finfo, minfo, false, now)-now
				if at ~= bt then
					ac, bc = ac/at, bc/bt
				end
			end
			if ac ~= bc then
				return ac > bc
			end
			return orank(a, b, finfo, minfo, now)
		end
		function setFocusRank(fi, mi, rank, order)
			orank, checkTime = rank, order == "xptime"
			f1, mlvl = fi, mi and api.GetFMLevel(mi)
			return focusRank
		end
	end
	local function expectedFocusGain(fi, mlvl, g)
		local base, bonus = api.GetFollowerXPGain(fi, mlvl, g[2], g[8], g[10])
		return base + bonus*g[1]/100
	end

	local groupCache, lastTimeHorizon = {}
	local prepareRun, getSuggestedGroups, completeRun do
		local rank2, finfo, now, defValid, useFocus, order, f1, f2, f3
		function prepareRun(_order, _f1, _f2, _f3, mtype)
			order, f1, f2, f3 = _order, _f1, _f2, _f3
			local fid
			fid, finfo = api.GetFollowerIdentity(false, true, mtype), api.GetFollowerInfo(mtype)
			fid = (order == "xptime" and "T" or "!") .. fid .. "#-ROAM-#" .. (f1 or "!") .. "-" .. (f2 or "!") .. "-" .. (f3 or "!")
			timeHorizon = time() + T.config.timeHorizon
			if groupCache._identity ~= fid or math.abs((lastTimeHorizon or 0) - timeHorizon) > 180 then
				wipe(groupCache)
			end
			if not next(groupCache) then
				lastTimeHorizon = timeHorizon
				groupCache._identity = fid
			end
			wipe(edtime)
	
			for id,v in pairs(finfo) do
				local st, ic = v.status, v.isCollected
				v.valid = ic and not T.config.ignore[id] and (st == nil or st == GARRISON_FOLLOWER_IN_PARTY or st == GARRISON_FOLLOWER_ON_MISSION)
				v.away = (ic and st == GARRISON_FOLLOWER_ON_MISSION or dropFollowers[id]) or tentativeState[id]
			end

			rank2, now, defValid = api.GroupRank.threats2, time(), not (f1 or f2 or f3)
			useFocus = finfo[not (f2 or f3) and f1]
			useFocus = useFocus and (useFocus.level < FOLLOWER_LEVEL_CAP or useFocus.quality < 4) and useFocus
		end
		function getSuggestedGroups(mi, trustValid)
			local mid, rank, rt = mi.missionID, api.GetMissionDefaultGroupRank(mi, order)
			local mig, nf, sg, a, a2, b, b2, c = api.GetMissionGroups(mid, trustValid, mi), mi.numFollowers, 0
			local irank, rank2 = useFocus and rt == "xp" and setFocusRank(useFocus, mi, rank, order) or rank, rank2
			if mi.followerTypeID == 2 and rt == "resources" then irank, rank2 = rank2, irank end
			for i=1,#mig do
				local g = mig[i]
				local isValid, isAway = defValid or backfillGroupMatch(g, nf, f1, f2, f3), false
				for i=5, isValid and 4+nf or 0 do
					local fi = finfo[g[i]]
					if not (fi and fi.valid) then
						isValid = false
						break
					elseif (fi.away or mid) ~= mid then
						isAway = true
					end
				end
				if not isValid then
				elseif isAway then
					c = c and irank(c, g, finfo, mi, now) and c or g
				else
					if a == nil or irank(g, a, finfo, mi, now) then
						a, a2 = g, a
					elseif a2 == nil or irank(g, a2, finfo, mi, now) then
						a2 = g
					end
					if b == nil or rank2(g, b, finfo, mi, now) then
						b, b2 = g, b
					elseif b2 == nil or rank2(g, b2, finfo, mi, now) then
						b2 = g
					end
				end
			end
			sg = {a, rankType=rt, rankFunc=rank}
			if b and b ~= a then
				sg[#sg+1] = b
			elseif b2 and b2 ~= a then
				sg[#sg+1] = b2
			elseif a2 then
				sg[#sg+1] = a2
			end
			if c and (sg[1] == nil or irank(c, sg[1], finfo, mi, now)) then
				sg[#sg+1] = c
			end
			for i=1,#sg do
				sg[i][11] = useFocus and expectedFocusGain(useFocus, api.GetFMLevel(mi), sg[i])
			end
			return sg
		end
		function completeRun()
			setFocusRank()
			finfo, now, defValid, useFocus, timeHorizon, order, f1, f2, f3 = nil
		end
	end

	function api.GetSuggestedGroupsForAllMissions(mtype, order, f1, f2, f3)
		prepareRun(order, f1, f2, f3, mtype)
		local missions, tv = api.PrepareAllMissionGroups(mtype), false
		for i=1,#missions do
			local mi = missions[i]
			if not groupCache[mi.missionID] then
				groupCache[mi.missionID], tv = getSuggestedGroups(mi, tv), true
			end
		end
		completeRun()
		return groupCache
	end
	function api.GetSuggestedGroupsForMission(mi, order, f1, f2, f3)
		prepareRun(order, f1, f2, f3, mi.followerTypeID)
		if not groupCache[mi.missionID] then
			groupCache[mi.missionID] = getSuggestedGroups(mi, false)
		end
		completeRun()
		return groupCache[mi.missionID]
	end
	local function wipeAll()
		edtime, equivXP, expectedXP, groupCache = setmetatable({}, weakKeys), setmetatable({}, weakKeys), setmetatable({}, weakKeys), setmetatable({}, weakKeys)
	end
	local function wipeActive()
		edtime,groupCache = setmetatable({}, weakKeys), setmetatable({}, weakKeys)
	end
	EV.GARRISON_FOLLOWER_XP_CHANGED = wipeAll
	EV.GARRISON_MISSION_NPC_CLOSED = wipeAll
	EV.MP_MISSION_START = wipeActive
	EV.MP_TENTATIVE_PARTY_UPDATE = wipeActive
	EV.GARRISON_MISSION_NPC_OPENED = wipeActive
	EV.MP_RELEASE_CACHES = wipeAll
end
api.GroupRank, api.GroupFilter = {}, {} do
	local function computeDingScore(g, finfo)
		if not g.dingScore then
			local a, b, c = 1200, 1200, 1200
			for i=5,7 do
				local fi = finfo[g[i]]
				if fi and fi.xp and fi.levelXP and fi.levelXP > 0 then
					a, b, c = floor((fi.levelXP-fi.xp)/100), a, b
				end
			end
			b, c = b > c and c or b, b > c and b or c
			a, b = a > b and b or a, a > b and a or b
			b, c = b > c and c or b, b > c and b or c
			g.dingScore = -(a * 10000 + b * 100 + c)
		end
		return g.dingScore
	end
	local function success(a, b, finfo, minfo, now)
		local ac, bc, ah, bh = a[1], b[1]
		if ac == bc then
			ac, bc = a[3] * risk[a[1]], b[3] * risk[b[1]]
		end
		if ac == bc then
			bc, ah = computeEarliestCompletion(a, finfo, minfo, false, now)
			ac, bh = computeEarliestCompletion(b, finfo, minfo, false, now)
		end
		if ac == bc then
			ac, bc = computeEquivXP(a, finfo, minfo), computeEquivXP(b, finfo, minfo)
			if ac == bc and ac > 0 then
				ac, bc = computeDingScore(a, finfo), computeDingScore(b, finfo)
			end
		end
		if (ac == bc) and (not ah) ~= (not bh) then
			ac, bc = bh and 1 or 0, 0
		end
		if ac == bc then
			ac, bc = 0, 0
			for i=1,minfo.numFollowers do
				ac = ac - finfo[a[4+i]].traitCost + finfo[b[4+i]].traitCost
			end
		end
		if ac == bc then
			ac, bc = a[4], b[4]
		end
		return ac > bc
	end
	local function res(a, b, finfo, minfo, now)
		for i=3,9,6 do
			if a[i] > 0 or b[i] > 0 then
				local ac, bc = risk[a[1]] * a[i], risk[b[1]] * b[i]
				if ac ~= bc then
					return ac > bc
				end
			end
		end
		return success(a,b, finfo, minfo, now)
	end
	local function xp(a, b, finfo, minfo, now)
		local ac, bc = computeEquivXP(a, finfo, minfo), computeEquivXP(b, finfo, minfo)
		if ac == bc and ac > 0 then
			ac = computeEarliestCompletion(b, finfo, minfo, false, now)
			bc = computeEarliestCompletion(a, finfo, minfo, false, now)
		end
		if ac == bc then
			return success(a,b, finfo, minfo, now)
		end
		return ac > bc
	end
	function api.GroupRank.threats2(a, b, ...)
		local ac, bc = a[1], b[1]
		if ac == bc then
			ac, bc = a[3] * risk[a[1]], b[3] * risk[b[1]]
		end
		if ac == bc then
			return xp(a, b, ...)
		end
		return ac > bc
	end
	function api.GroupRank.xptime(a, b, finfo, minfo, now)
		local ac, bc = computeEquivXP(a, finfo, minfo), computeEquivXP(b, finfo, minfo)
		if (ac > 0) ~= (bc > 0) then
			return ac > 0
		end
		local at, bt = computeEarliestCompletion(a, finfo, minfo, false, now)-now, computeEarliestCompletion(b, finfo, minfo, false, now)-now
		local a2, b2 = ac/at, bc/bt
		if a2 ~= b2 then
			return a2 > b2
		elseif ac ~= bc then
			return ac > bc
		end
		return success(a,b, finfo, minfo, now)
	end
	function api.GroupRank.shipxp(a, b, finfo, minfo, now)
		local ac, bc = computeEquivXP(a, finfo, minfo), computeEquivXP(b, finfo, minfo)
		if (ac > 0) ~= (bc > 0) then
			return ac > 0
		end
		return success(a,b, finfo, minfo, now)
	end
	api.GroupRank.threats, api.GroupRank.resources, api.GroupRank.xp = success, res, xp
end
function api.GetMissionDefaultGroupRank(mi, order)
	local rew = api.HasSignificantRewards(mi)
	local key = (rew or "minor") == "minor" and "xp" or (rew == "resource" or rew == "gold") and "resources" or "threats"
	local key2 = key == "xp" and (mi.followerTypeID == 2 and (T.config.allowShipXP and "shipxp" or "threats") or order == "xptime" and "xptime") or key
	return api.GroupRank[key2], key
end
function api.GroupFilter.IDLE(res, finfo, minfo)
	local mid = minfo.missionID
	for i=5,4+minfo.numFollowers do
		local fi = finfo[res[i]]
		if not (fi and (fi.status == nil or fi.status == GARRISON_FOLLOWER_IN_PARTY) and not T.config.ignore[fi.followerID] and not dropFollowers[fi.followerID] and (api.GetFollowerTentativeMission(fi.followerID) or mid) == mid) then
			return false
		end
	end
	return true
end
function api.GroupFilter.ACTIVE(res, finfo, minfo)
	for i=5,4+minfo.numFollowers do
		local fi = finfo[res[i]]
		if not (fi and fi.status ~= GARRISON_FOLLOWER_INACTIVE and not T.config.ignore[fi.followerID]) then
			return false
		end
	end
	return true
end
function api.IsLevelAppropriateToken(itemID)
	local ts = T.TokenSlots[itemID]
	if ts then
		local _, _, _, tl = GetItemInfo(itemID)
		if not tl then return end
		for s=ts, ts + (ts > 10 and 1 or 0) do
			local iid = GetInventoryItemID("player", s)
			local l = iid and select(4, GetItemInfo(iid))
			if l and l <= tl then
				return true
			end
		end
		return false
	else
		local cl = T.CrateLevels[itemID]
		if cl then
			return cl >= (select(2,GetAverageItemLevel()) - T.config.crateLevelGrace)
		end
	end
end
do -- HasSignificantRewards(minfo)
	local cache = {}
	function api.HasSignificantRewards(mi)
		local mid = mi.missionID
		local ret = cache[mid]
		if ret ~= nil then
		elseif mi.type == "Ship-Legendary" or mi.offeredGarrMissionTextureID ~= 0 then
			ret = true
		elseif mi.rewards then
			local allGR, allXP, over, hasMinor, gold = true, true, T.XPMissions[mid], false
			if over then
				allGR, gold = false, over
			else
				for _, r in pairs(mi.rewards) do
					if r.currencyID == 0 then
						gold = r.quantity*(1+mi.numFollowers)
					elseif not r.followerXP then
						if T.MinorRewards[r.itemID] or api.IsLevelAppropriateToken(r.itemID) == false then
							hasMinor = "minor"
						else
							allXP = false
						end
					end
					if not T.TraitStack[r.currencyID] then
						allGR = false
					end
				end
			end
			ret = allGR and not allXP and "resource" or (gold and gold > T.config.goldRewardThreshold and "gold") or not allXP or hasMinor
		else
			ret = false
		end
		cache[mid] = ret
		return ret
	end
	function EV:MP_RELEASE_CACHES()
		cache = {}
	end
end
do -- api.GetSuggestedGroupsMenu(mi, f1, f2, f3)
	local function SetGroup(_, group)
		local CURRENT_FRAME = (GarrisonMissionFrame:IsVisible() and GarrisonMissionFrame or GarrisonShipyardFrame)
		local CURRENT_PAGE = CURRENT_FRAME.MissionTab.MissionPage
		local rf = CURRENT_PAGE.RewardsFrame
		local mi, oc = CURRENT_PAGE.missionInfo, rf.currentChance
		CURRENT_FRAME:ClearParty()
		for i=1,mi.numFollowers do
			rf.currentChance = oc
			CURRENT_FRAME:AssignFollowerToMission(CURRENT_PAGE.Followers[i], C_Garrison.GetFollowerInfo(group[4+i]))
		end
	end
	local function SecondsToShortTime(sec)
		local m, s, out = (sec % 3600) / 60, sec % 60
		if sec >= 3600 then out = HOUR_ONELETTER_ABBR:format(sec/3600) end
		if m > 0 then out = (out and out .. " " or "") .. MINUTE_ONELETTER_ABBR:format(m) end
		if s > 0 then out = (out and out .. " " or "") .. SECOND_ONELETTER_ABBR:format(s) end
		return out or ""
	end
	local function ShowGroupTip(self, g, mi)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		api.SetGroupTooltip(GameTooltip, g, mi)
		GameTooltip:Show()
	end
	local function addToMenu(mm, groups, mi, primary)
		for i=1,#groups do
			local g = groups[i]
			local sc, rq, rt, xp, res, text = g[1] .. "%", g[3] or 0, g[9]
			local _, expectedXP = api.GetMissionGroupXP(g, mi)
			if (expectedXP or 0) >= 1 then
				xp = (L"%s XP"):format(BreakUpLargeNumbers(floor(expectedXP)))
			end
			if g[1] <= 0 then
			elseif rt == 824 and rq > 0 then
				res = floor(g[1]*rq/100) .. " |TInterface\\Garrison\\GarrisonCurrencyIcons:20:20:0:-2:128:128:12:52:12:52|t"
			elseif rt == 823 and rq > 0 then
				res = floor(g[1]*rq/100) .. " |T" .. select(3,Nine.GetCurrencyInfo(rt)) .. ":14:14:0:0:64:64:4:60:4:60|t"
			elseif rt == 0 and rq > 0 then
				local r = g[1]*rq/100
				res = GetMoneyString(r - r % 1e4)
			end
			if (primary == "xp" and xp) or (primary == "resources"  and res) then
				text = (primary == "xp" and xp or res) .. ", " .. sc .. (primary == "resources" and xp and ", " .. xp or "")
			else
				text = sc .. (xp and ", " .. xp or "")
			end
			text = text .. " (" .. SecondsToShortTime(g[4]) .. ")"
			
			mm[#mm+1] = { text = text, notCheckable=true, tooltipOnButton=ShowGroupTip, func=SetGroup, arg1=g, arg2=mi}
		end
	end
	local function dominating(a,b, faultTies)
		return a[1] >= b[1] and a[3] >= b[3] and a[4] <= b[4] and (a[1] > b[1] or a[3] > b[3] or faultTies)
	end
	local function getBaseReward(mi)
		if mi.rewards then
			for k,v in pairs(mi.rewards) do
				if (v.currencyID == 0 or v.currencyID == 824 or v.currencyID == 1101 or v.currencyID == 823) then
					return v.quantity
				end
			end
		end
	end
	function api.GetSuggestedGroupsMenu(mi, f1, f2, f3)
		local finfo, nf, mid, now = api.GetFollowerInfo(), mi.numFollowers, mi.missionID, time()
		local np, fin = (f1 and 1 or 0) + (f2 and 1 or 0) + (f3 and 1 or 0), 4+nf
		local hasPartialParty = np > 0 and np < nf
		local rank, rt = api.GetMissionDefaultGroupRank(mi)
		local trank = rt ~= "threats" and api.GroupRank.threats2
		local ag, fg, pg, ds, br = api.GetMissionGroups(mid, nil, mi), {}, hasPartialParty and {} or nil, mi.durationSeconds, getBaseReward(mi)
		for i=1,#ag do
			local ok, g = true, ag[i]
			for i=5,fin do
				local fid = g[i]
				local fi = finfo[fid]
				if not (fi and (fi.status == nil or fi.status == GARRISON_FOLLOWER_IN_PARTY) and not T.config.ignore[fid] and not dropFollowers[fid] and (api.GetFollowerTentativeMission(fid) or mid) == mid) then
					ok = false
					break
				end
			end
			if ok then
				local isPartialMatch
				if hasPartialParty then
					local p1, p2, p3 = g[5], g[6], g[7]
					local nm = (f1 and (f1 == p1 or f1 == p2 or f1 == p3) and 1 or 0)
					         + (f2 and (f2 == p1 or f2 == p2 or f2 == p3) and 1 or 0)
					         + (f3 and (f3 == p1 or f3 == p2 or f3 == p3) and 1 or 0)
					isPartialMatch = nm == np
				end
				for i=1,isPartialMatch and 2 or 1 do
					local sg = i == 2 and pg or fg
					if sg[3] and not rank(g, sg[3], finfo, mi, now) then
					elseif sg[1] == nil or rank(g, sg[1], finfo, mi, now) then
						sg[1], sg[2], sg[3] = g, sg[1], sg[2]
					elseif sg[2] == nil or rank(g, sg[2], finfo, mi, now) then
						sg[2], sg[3] = g, sg[2]
					elseif sg[3] == nil or rank(g, sg[3], finfo, mi, now) then
						sg[3] = g
					end
					if trank and (sg[4] == nil or trank(g, sg[4], finfo, mi, now)) then
						sg[4] = g
					end
					local tk, rk = "t" .. (ds/g[4]), br and g[3] and "r" .. g[3]
					if sg[tk] == nil or rank(g, sg[tk], finfo, mi, now) then
						sg[tk] = g
					end
					if rk and (sg[rk] == nil or rank(g, sg[rk], finfo, mi, now)) then
						sg[rk] = g
					end
				end
			end
		end
		if fg[1] == nil and (not pg or pg[1] == nil) then
			return
		end
		local mm = {}
		for i=pg and pg[1] and 2 or 1,1,-1 do
			local sg = i == 2 and pg or fg
			if sg[4] then
				for i=1,3 do
					if sg[i] and not trank(sg[4], sg[i], finfo, mi, now) then
						sg[4] = nil
						break
					end
				end
			end
			for i=#sg,2,-1 do
				local b = sg[i]
				for j=1,i-1 do
					if dominating(sg[j], b) then
						table.remove(sg, i)
						break
					end
				end
			end
			for i=br and nf or 0,1,-1 do
				local g = sg["r" .. br*i]
				for j=1,g and #sg or 0 do
					if g == sg[j] or dominating(sg[j], g, true) then
						g = nil
						break
					end
				end
				if g then
					sg[#sg+1] = g
				end
			end
			for i=nf,0,-1 do
				local g = sg["t" .. (2^i)]
				for j=1,g and #sg or 0 do
					if g[4] == sg[j][4] or dominating(sg[j], g) then
						g = nil
						break
					end
				end
				if g then
					sg[#sg+1] = g
				end
			end
			if #sg > 0 then
				table.sort(sg, function(a,b) return rank(a,b, finfo, mi, now) end)
				mm[#mm+1] = {text = i == 2 and L"Complete party" or L"Suggested groups", isTitle=true, notCheckable=true}
				addToMenu(mm, sg, mi, rt)
			end
		end
		return mm
	end
end

do -- api.GetUpgradeItems(ilevel, isArmor)
	local function walk(ilvl, t, pos)
		for i=pos,#t,2 do
			if t[i+1] > ilvl and GetItemCount(t[i]) > 0 then
				return t[i], walk(ilvl, t, i + 2)
			end
		end
	end
	function api.GetUpgradeItems(ilevel, isWeapon)
		return walk(ilevel, T.ItemLevelUpgrades[isWeapon and "WEAPON" or "ARMOR"], 1)
	end
	function api.GetUpgradeRange()
		local t, rW, rA  = T.ItemLevelUpgrades.WEAPON
		for i=1,2 do
			local limit = 0
			for i=1,#t, 2 do
				if GetItemCount(t[i]) > 0 and limit < t[i+1] then
					limit = t[i+1]
				end
			end
			t, rA, rW = T.ItemLevelUpgrades.ARMOR, limit, rA
		end
		return rW, rA
	end
end
function api.ExtendMissionInfoWithXPRewardData(mi, force)
	local bmul, base, extra, mentor, bonus
	if not force then
		bmul, base, extra, mentor, bonus = mi.groupXPBuff, mi.baseXP, mi.extraXP, mi.mentorLevel, mi.bonusXP
	end
	if bmul == nil or extra == nil then
		local _, _, _, sc, pb, _, exp = C_Garrison.GetPartyMissionInfo(mi.missionID)
		bmul, extra, mi.successChance = api.GetBuffsXPMultiplier(pb), exp, mi.successChance or sc
	end
	if base == nil then
		_, base = C_Garrison.GetMissionInfo(mi.missionID)
	end
	if mentor == nil then
		local _, milvl = C_Garrison.GetPartyMentorLevels(mi.missionID)
		mentor = (milvl or 0) > 0 and milvl
	end
	if bonus == nil then
		bonus = 0
		for k,v in pairs(mi.rewards) do
			if v.followerXP then bonus = bonus + v.followerXP end
		end
	end
	mi.groupXPBuff, mi.baseXP, mi.extraXP, mi.bonusXP, mi.mentorLevel = bmul, base, extra, bonus, mentor
	return bmul, base, extra, bonus, mentor
end
function api.ExtendMissionInfoWithParty(mi)
	local _, mm, gm
	_, _, _, mi.successChance, _, _, _, mm, gm = C_Garrison.GetPartyMissionInfo(mi.missionID)
	if not mi.rewards then return end
	for k,v in pairs(mi.rewards) do
		if v.currencyID then
			api.GetRewardMultiplier(mi, v.currencyID, true, mm, gm)
		end
	end
end
function api.ExtendFollowerTooltipProjectedRewardXP(mi, fi)
	local tip = fi and (fi.followerTypeID == 1 and GarrisonFollowerTooltip or GarrisonShipyardFollowerTooltip)
	if mi and fi and tip and tip:IsShown() and tip.XPBarBackground:IsShown() then
		local bmul, base, extraXP, bonus, mentor = api.ExtendMissionInfoWithXPRewardData(mi)
		if base and extraXP and bmul and (fi.levelXP or 0) ~= 0 then
			local base, bonus = api.GetFollowerXPGain(fi, api.GetFMLevel(mi), extraXP + base, bonus * bmul, mentor)
			local toLevel, wmul = fi.levelXP - fi.xp, tip.XPBarBackground:GetWidth()/fi.levelXP
			tip.XPBarBackground:SetColorTexture(0.25, 0.25, 0.25)
			if tip.XPBar:IsShown() then
				tip.XPRewardBase:SetPoint("TOPLEFT", tip.XPBar, "TOPRIGHT")
				tip.XPRewardBase:SetPoint("BOTTOMLEFT", tip.XPBar, "BOTTOMRIGHT")
			else
				tip.XPRewardBase:SetPoint("TOPLEFT", tip.XPBarBackground, "TOPLEFT")
				tip.XPRewardBase:SetPoint("BOTTOMLEFT", tip.XPBarBackground, "BOTTOMLEFT")
			end
			tip.XPRewardBase:SetWidth(math.max(0.01, math.min(toLevel, base)*wmul))
			tip.XPRewardBonus:SetWidth(math.max(0.01, math.min(toLevel-base, bonus)*wmul))
			tip.XPRewardBonus:SetShown(bonus > 0 and toLevel > base)
			tip.XPRewardBase:SetShown(base > 0)
			if base > 0 then
				local xpt = "|cff99ff00" .. BreakUpLargeNumbers(floor(base)) .. "|r"
				if bonus > 0 then xpt = xpt .. "+|cff00bfff" .. BreakUpLargeNumbers(floor(bonus)) .. "|r" end
				local toDing = fi.levelXP - fi.xp
				local baseText = BreakUpLargeNumbers(toDing)
				if toDing <= floor(base) then
					baseText = "|cff99ff00" .. baseText .. "|r"
				elseif toDing <= floor(base + bonus) then
					baseText = "|cff00bfff" .. baseText .. "|r"
				end
				baseText = (fi.level == FOLLOWER_LEVEL_CAP and GARRISON_FOLLOWER_TOOLTIP_UPGRADE_XP or GARRISON_FOLLOWER_TOOLTIP_XP):gsub("%%[%d$]*d", "%%s"):format(baseText)
				tip.XP:SetText(baseText .. "|n" .. (L"Reward: %s XP"):format(xpt))
			end
		else
			tip.XPRewardBonus:Hide()
			tip.XPRewardBase:Hide()
		end
	end
end
function api.ExtendFollowerTooltipGainedXP(tip, awardXP, fi)
	if tip.XP:IsShown() and (awardXP or 0) > 0 then
		tip.XP:SetText(tip.XP:GetText() .. "|n|cff10ff10" .. (L"%s XP gained"):format(BreakUpLargeNumbers(awardXP)))
		if tip.XPGained and (fi and fi.levelXP or 0) > 0 then
			tip.XPGained:ClearAllPoints()
			tip.XPGained:SetPoint("TOPRIGHT", tip.XPBar)
			tip.XPGained:SetPoint("BOTTOMRIGHT", tip.XPBar)
			tip.XPGained:SetWidth(math.max(0.01, math.min(fi.xp, awardXP)*tip.XPBarBackground:GetWidth()/fi.levelXP))
			tip.XPGained:Show()
		end
	end
end

local FollowerEstimator, ShipEstimator, FTraitStack, STraitStack = {}, {}, T.TraitStack, T.ShipTraitStack
local EnvironmentCounters, EnvironmentGhosts, EnvironmentBonus = T.EnvironmentCounters, T.EnvironmentGhosts, T.EnvironmentBonus
function FollowerEstimator.GetMemberPool(includeInactive, moreFollowers, forceInclude)
	local f, ni, et = C_Garrison.GetFollowers(1), 1, T.EquivTrait
	for i=1,#f do
		local fi = f[i]
		if fi.isCollected and (includeInactive or fi.status ~= GARRISON_FOLLOWER_INACTIVE) and (forceInclude and fi.followerID == forceInclude or not T.config.ignore[fi.followerID]) then
			local fid, affinity = fi.followerID, T.Affinities[fi.garrFollowerID] or 0
			local counters, traits = {}, {-affinity}
			for i=1,3 do
				local a = C_Garrison.GetFollowerAbilityAtIndex(fid, i)
				a = a and a > 0 and C_Garrison.GetFollowerAbilityCounterMechanicInfo(a)
				if a then
					counters[#counters+1] = a
				end
				a = C_Garrison.GetFollowerTraitAtIndex(fid, i)
				if a and a > 0 then
					a = et[a] or a
					traits[#traits + 1] = a
					if a == affinity then
						fi.saffinity = true
					end
				end
			end
			fi.counters, fi.traits, fi.affinity, f[ni], ni = counters, traits, affinity, fi, ni + 1
		end
	end
	for i=#f,ni,-1 do
		f[i] = nil
	end
	for i=1, moreFollowers and #moreFollowers or 0 do
		f[ni+i-1] = moreFollowers[i]
	end
	for i=1,#f do
		local fi = f[i]
		fi.cLevel = fi.level >= FOLLOWER_LEVEL_CAP and (fi.iLevel - 300) or ((fi.level-FOLLOWER_LEVEL_BASE)*30)
		fi.active, fi.working = fi.status ~= GARRISON_FOLLOWER_INACTIVE and 1 or 0, fi.status == GARRISON_FOLLOWER_WORKING and 1 or 0
	end
	return f, ni-1, #f
end
function FollowerEstimator.PrepareCounters()
	return {[6]=0}, {[221]=0, [79]=0, [77]=0, [76]=0, [201]=0, [202]=0, [232]=0, [256]=0, [47]=0}, FTraitStack, T.MoreTraitStack
end
function FollowerEstimator.EvaluateGroup(mi, counters, traits, fa, fb, fc, scratch)
	local mlvl, rew, mc, umc = mi[1], mi[4], scratch or {}, false
	local nc, tv = traits[201]*2 + traits[202]*4, rew == 123858 and 3 or 6
	local cap = (#mi-5)*tv do
		local time, env, genv = mi[3]*2^-traits[221], mi[5], EnvironmentGhosts[rew] do
			local exo, apx, brt = traits[325], traits[324], traits[244]
			nc = nc + (env == 13 and 1 or 2) * (traits[EnvironmentCounters[env]] or 0) + traits[(time >= 25200) and 76 or 77]*2 + traits[47]*6
			if exo and exo > 0 then
				nc = nc + exo*(env == 16 and 5 or 2)
			end
			if apx and apx > 0 then
				nc = nc + apx * (EnvironmentBonus[324][env] or 0)
			end
			if brt and brt > 0 and mi[2] == 1 then
				nc = nc + 6
			end
			if genv then
				nc = nc + 3*((apx and apx*EnvironmentBonus[324][genv] or 0) + 2*(traits[EnvironmentCounters[genv]] or 0))
			end
		end
		
		local lc, cn = mi[6], 1
		for i=7, #mi+1 do
			local c = mi[i]
			if c == lc then
				cn = cn + 1
			else
				local h = counters[lc] or 0
				if h < cn then
					mc[lc], umc = (cn - h)*tv, true
				end
				lc, cn, nc = c, 1, nc + tv * (h > cn and cn or h)
			end
		end
	end
	if nc < cap then
		local ra, rb, rc = fa.affinity or 0, fb.affinity, fc and fc.affinity
		local sa, sb, sc = fa.saffinity, fb.saffinity, fc and fc.saffinity
		if ra == rc or rb == rc then rc, sc = nil end
		if ra == rb or not rb then rb, sb, rc, sc = rc, sc end
		repeat
			local nt, nf = traits[ra] or 0, traits[-ra] or 0
			if nt == 0 or ra == 0 or nf == 0 then
			elseif nf > 1 then
				nc = nc + nt*3
			else
				nc = nc + (nt - (sa and 1 or 0))*3
			end
			ra, rb, sa, sb, rc = rb, rc, sb, sc
		until nc >= cap or not ra
	end
	if nc < cap and mc[6] then
		local h, l = 4*traits[232], mc[6]
		mc[6], nc = l > h and l - h or 0, nc + (h > l and l or h)
	end
	local amlvl, bmlvl, cmlvl = mlvl, mlvl, mlvl
	local mentorIndex = (traits[248] or 0) > 0 and (fa.garrFollowerID == MENTOR_FOLLOWER and 1 or fb.garrFollowerID == MENTOR_FOLLOWER and 2 or 3)

	if nc < cap then
		local la, lb, lc, lm, mx
		if mlvl >= FOLLOWER_LEVEL_CAP then
			la, lb, lc, lm, mx, mlvl = fa.iLevel, fb.iLevel, fc and fc.iLevel, 15, FOLLOWER_ITEM_LEVEL_CAP, mlvl == FOLLOWER_LEVEL_CAP and 600 or mlvl
		else
			la, lb, lc, lm, mx = fa.level, fb.level, fc and fc.level, 3, FOLLOWER_LEVEL_CAP
		end
		local ga, gb, gc, toCap = 1, 1, 1, mx-mlvl
		for i=1,3 do
			for j=1,fa and #fa.counters or 0 do
				local c = fa.counters[j]
				local v = mc[c] or 0
				ga = ga + (v > 2 and 2 or v) -- this can be very wrong
			end
			fa, fb, fc, ga, gb, gc = fb, fc, fa, gb, gc, ga
		end
		gc = fc and gc or 0
		
		if mentorIndex then
			ga = ga + gb + gc
			ga, gb, gc = mentorIndex == 1 and ga or 0, mentorIndex == 2 and ga or 0, mentorIndex == 3 and ga or 0
		end
		
		local maxGain = (ga+gb+gc)*(toCap < lm and toCap/lm or 1)
		if cap-nc >= maxGain then
			nc, mlvl = nc + maxGain, mlvl + (toCap < lm and toCap or lm)
			amlvl, bmlvl, cmlvl = mlvl, mlvl, mlvl
		elseif maxGain > 0 then
			if toCap < lm then
				ga, gb, gc = ga * toCap, gb * toCap, gc * toCap
			else
				ga, gb, gc, mx = ga * lm, gb * lm, gc * lm, mlvl + lm
			end
			la = la < mlvl and mlvl or la > mx and mx or la
			lb = lb < mlvl and mlvl or lb > mx and mx or lb
			lc = lc and (lc < mlvl and mlvl or lc > mx and mx or lc) or mx
			local cc, gap = ga*(lm+la-mx) + gb*(lm+lb-mx) + gc*(lm+lc-mx), (cap-nc)*lm*lm
			if cc < gap then
				local sa, sb, sc = 3,2,1
				if gb < gc then lb, lc, gb, gc, sb, sc = lc, lb, gc, gb, sc, sb end
				if ga < gb then la, lb, ga, gb, sa, sb = lb, la, gb, ga, sb, sa end
				if gb < gc then lb, lc, gb, gc, sb, sc = lc, lb, gc, gb, sc, sb end
				nc, gap = cap, gap - cc
				for i=1,3 do
					if ga > 0 then
						local t = ga*(mx-la)
						if gap <= t then
							gap, amlvl = 0, math.ceil(la + gap/ga)
						elseif gap > 0 then
							amlvl, gap = mx, gap - t
						end
					end
					ga, gb, gc, la, lb, lc, amlvl, bmlvl, cmlvl = gb, gc, ga, lb, lc, la, bmlvl, cmlvl, amlvl
				end
				if sb < sc then bmlvl, cmlvl, sb, sc = cmlvl, bmlvl, sc, sb end
				if sa < sb then amlvl, bmlvl, sa, sb = bmlvl, amlvl, sb, sa end
				if sb < sc then bmlvl, cmlvl, sb, sc = cmlvl, bmlvl, sc, sb end
			else
				amlvl, bmlvl, cmlvl, nc = la, lb, lc, cap
			end
		end
	end
	if mentorIndex then
		amlvl, bmlvl, cmlvl = mentorIndex == 1 and amlvl or 0, mentorIndex == 2 and bmlvl or 0, mentorIndex == 3 and cmlvl or 0
	end

	if umc and scratch then
		wipe(scratch)
	end
	
	local rp = 100
	if nc < cap then
		local ex = fc and 6 or fb and 4 or 2
		rp = (nc + ex) * 100 / (cap + ex)
		rp = rp - rp % 1
	end
	local ts = FTraitStack[rew]
	local stack = (traits[ts] or 0) + (ts == 79 and traits[256] or 0)*2
	return rp, stack, amlvl, bmlvl, cmlvl
end
function FollowerEstimator.SaveGroup(best, traits, fa, fb, fc, sc, amlvl, bmlvl, cmlvl, a, b, c)
	local na, nw = (fa.active or 0) + (b and fb.active or 0) + (c and fc.active or 0), 3 - (fa.working or 0) - (b and fb.working or 0) - (c and fc.working or 0)
	local la, lb, lc = fa.cLevel, fb.cLevel, c and fc.cLevel
	local ga, gb, gc = amlvl > FOLLOWER_LEVEL_CAP and (amlvl - 300) or ((amlvl-FOLLOWER_LEVEL_BASE)*30), bmlvl > FOLLOWER_LEVEL_CAP and (bmlvl - 300) or ((bmlvl-FOLLOWER_LEVEL_BASE)*30), c and (cmlvl > FOLLOWER_LEVEL_CAP and (cmlvl - 300) or ((cmlvl-FOLLOWER_LEVEL_BASE)*30)) or 0
	local gap = (ga > la and (ga - la) or 0) + (b and gb > lb and (gb - lb) or 0) + (c and gc > lc and (gc - lc) or 0)
	local hi, lo, ohi = sc + 65536 * (na * 4 + nw) + (32767-gap), traits[221], best[1]
	if hi >= ohi then
		if hi > ohi or lo > best[6] then
			best[1], best[2], best[3], best[4], best[5], best[6] = hi, a, b, c, amlvl + 1e3*bmlvl + (c and 1e6*cmlvl or 0), lo
		end
		local ia, ib, ic = fa.followerID or a, fb and fb.followerID or b, fc and fc.followerID or c
		if hi > ohi then
			best[7], best[8], best[9], best[10], best[11] = c and 3 or 2, ia, ib, ic, 1
		else
			best[11] = best[11] + 1
			for i=8,best[7] > 0 and 10 or 0 do
				local fo = best[i]
				if fo and fo ~= ia and fo ~= ib and fo ~= ic then
					best[7], best[i] = best[7] - 1
				end
			end
		end
		return true
	end
end
function FollowerEstimator.GetGroup(best, mi, f, counters, traits, stack, sc)
	wipe(counters) wipe(traits)
	local bt = {nil, nil, nil, nil, sc, floor(best[5]), 0}
	local uf, u1, u2, u3 = 0, best[8], best[9], best[10]
	for i=1, mi[2] do
		local fi = f[best[1+i]]
		local fid = fi.followerID
		bt[i] = fid
		for i=1,2 do
			local s, t = fi[i == 1 and "counters" or "traits"], i == 1 and counters or traits
			for i=1,#s do
				local v = s[i]
				t[v] = (t[v] or 0) + 1
			end
		end
		if fi.garrFollowerID == MENTOR_FOLLOWER then
			bt.mentorLevel = floor(max(fi[fi.level > 99 and "iLevel" or "level"], best[5] % 1000^i / 1000^(i-1)))
		end
		if fid == u1 or fid == u2 or fid == u3 then
			uf = uf + 2^(i-1)
		end
	end
	
	bt[4] = FTraitStack[mi[4]] and stack or nil
	bt.used, bt.variants = uf, best[11]
	bt.time = mi[3]*2^-(traits[221] or 0)
	bt.ttrait = bt.time >= 25200 and 76 or 77
	local lc, cn, h
	for i=6, #mi do
		local c = mi[i]
		if c == lc then
			cn = cn + 1
		else
			lc, cn, h = c, 1, counters[c] or 0
		end
		if c == 6 and traits[232] then
			local nh = h + traits[232]/2
			bt.dtrait, h = h < lc and (nh <= lc and 1 or 2) or nil, nh
		end
		bt[1+i] = (h >= cn + 1) and 2 or h >= cn or (h == cn-0.5 and (mi[4] == 123858 or 0.5) or nil)
	end
	return bt
end
function ShipEstimator.GetMemberPool()
	local f, ni, et = C_Garrison.GetFollowers(2), 1, T.EquivTrait
	for i=1,#f do
		local fi = f[i]
		if not T.config.ignore[fi.followerID] then
			local fid, counters, traits = fi.followerID, {}, {}
			for i=1,2 do
				local a, t = C_Garrison.GetFollowerAbilityAtIndex(fid, i), C_Garrison.GetFollowerTraitAtIndex(fid, i)
				local at = i == 1 and T.ShipAffinityMap[t]
				if at then traits[1], fi.affinity = -at, at end
				repeat
					local cid = a > 0 and C_Garrison.GetFollowerAbilityCounterMechanicInfo(a)
					if cid then
						counters[#counters + 1] = cid
					else
						traits[#traits + 1] = et[a] or a
					end
					a, t = t
				until not a
			end
			fi.counters, fi.traits = counters, traits
			f[ni], ni = fi, ni + 1
		end
	end
	for i=#f,ni,-1 do
		f[i] = nil
	end
	return f, #f, #f
end
function ShipEstimator.PrepareCounters()
	return {}, {[292]=0}, STraitStack
end
function ShipEstimator.EvaluateGroup(mi, counters, traits, fa, fb, fc, _scratch)
	local threat = mi[2]*2
	local score, c = threat + traits[292]*3 + (mi[3] >= 43200 and traits[294] or 0)*4, threat == 6

	local lc, cn = mi[6], 1
	for i=7,#mi+1 do
		local c = mi[i]
		if c == lc then
			cn = cn + 1
		else
			local m, h = T.StrongNavalThreats[lc] or 6, counters[lc] or 0
			lc, cn, threat, score = c, 1, threat + m*cn, score + m*(h > cn and cn or h)
		end
	end
	
	if score < threat then
		local ra, rb, rc = fa.affinity or 0, fb.affinity, c and fc.affinity
		local sa, sb, sc = fa.saffinity, fb.saffinity, c and fc.saffinity
		if ra == rc or rb == rc then rc, sc = nil end
		if ra == rb or not rb then rb, sb, rc, sc = rc, sc end
		repeat
			local nt, nf = traits[ra] or 0, traits[-ra] or 0
			if nt == 0 or ra == 0 or nf == 0 then
			elseif nf > 1 then
				score = score + nt*6
			else
				score = score + (nt - (sa and 1 or 0))*6
			end
			ra, rb, sa, sb, rc = rb, rc, sb, sc
		until score >= threat or not ra
	end
	
	local base = mi[5]
	local rp = score < threat and math.floor(base+(100-base)*score/threat+.5) or 100
	return rp, traits[STraitStack[mi[4]]] or 0
end
function ShipEstimator.SaveGroup(best, _traits, fa, fb, fc, sc, _amlvl, _bmlvl, _cmlvl, a, b, c)
	local cb, ia, ib, ic = best[1], fa.followerID or a, fb and fb.followerID or b, fc and fc.followerID or c
	if cb < sc then
		best[1], best[2], best[3], best[4], best[5], best[6], best[7], best[8] = sc, a,b,c, c and 3 or b and 2 or 1, ia,ib,ic
	elseif cb == sc and best[5] > 0 then
		for i=6,8 do
			local f = best[i]
			if f and f ~= ia and f ~= ib and f ~= ic then
				best[5], best[i] = best[5] - 1
			end
		end
	end
end
function ShipEstimator.GetGroup(best, mi, f, counters, traits, stack, sc)
	wipe(counters) wipe(traits)
	local bt, uf = {nil, nil, nil, STraitStack[mi[4]] and stack, sc, nil, 0}, 0
	local u1, u2, u3 = best[6], best[7], best[8]
	for i=1, mi[2] do
		local fi = f[best[1+i]]
		local fid = fi.followerID
		bt[i] = fid
		for i=1,2 do
			local s, t = fi[i == 1 and "counters" or "traits"], i == 1 and counters or traits
			for i=1,#s do
				local v = s[i]
				t[v] = (t[v] or 0) + 1
			end
		end
		if fid == u1 or fid == u2 or fid == u3 then
			uf = uf + 2^(i-1)
		end
	end
	bt.used = uf
	
	local lc, cn, h
	for i=6, #mi do
		local c = mi[i]
		if c == lc then
			cn = cn + 1
		else
			lc, cn, h = c, 1, counters[c] or 0
		end
		bt[1+i] = (h >= cn + 1) and 2 or h >= cn or nil
	end
	
	return bt
end
function api.GetGroupMemberPool(mt, ...)
	return (mt == 1 and FollowerEstimator or ShipEstimator).GetMemberPool(...)
end
function api.UpdateGroupEstimates(missions, followers, yield, bMax)
	local best, bkey, ms = {}, {}, {} do
		for i=1,#missions do
			local mi = missions[i].s
			if mi and not missions[i].drop then
				local sz, res = mi[2], {-1}
				local t = ms[sz] or {}
				t[#t+1], ms[sz], best[mi], bkey[res] = mi, t, res, missions[i][1]
			end
		end
	end
	local est = C_Garrison.GetFollowerTypeByMissionID(missions[1][1]) == 1 and FollowerEstimator or ShipEstimator
	local mt, f = est == FollowerEstimator and 1 or 2, followers
	local nf1, nf = bMax and bMax or #f, #f -- TODO: moreFollowers thingy.

	local scratch, counters, traits = {}, est.PrepareCounters()
	local EvaluateGroup, SaveGroup, s1, doStack = est.EvaluateGroup, est.SaveGroup, 17179869184, bit.band(T.config.interestStack,2^mt/2)>0
	local consideredGroups, totalGroups = 0 do
		local re, n1, n2, n3 = nf > nf1 and nf-nf1 or 0, ms[1] and #ms[1] or 0, ms[2] and #ms[2] or 0, ms[3] and #ms[3] or 0
		nf1, totalGroups = nf1+1, nf * n1 + (nf1*(nf1-1)/2+re*nf1) * n2 + (nf1*(nf1-1)*(nf1-2)/6 + re*nf1*(nf1-1)/2) * n3
		if yield then yield(0,0,0) end
	end
	
	local s,a, b,c,mi,fa,fb,fc = 1,nf+1
	while a >= 1 do
		local nF, rF
		if s == 3 then
			rF, nF = fc, c > 1 and f[c-1]
			s, fc, c = nF and 3 or 2, nF, nF and c-1 or nil
		elseif s == 2 then
			rF, nF, mi = fb, b > 1 and f[b-1], ms[2]
			s, fb, b = nF and 3 or 1, nF, nF and b-1 or nil, yield and yield(1, consideredGroups, totalGroups)
		else
			rF, nF, mi = fa, a > 1 and f[a-1], ms[1]
			s, fa, a = 2, nF, a-1
		end
		for i=1,rF and 2 or 0 do
			local s, t = rF[i == 1 and "counters" or "traits"], i == 1 and counters or traits
			for i=1,#s do
				local v = s[i]
				t[v] = t[v] - 1
			end
		end
		for i=1,nF and 2 or 0 do
			local s, t = nF[i == 1 and "counters" or "traits"], i == 1 and counters or traits
			for i=1,#s do
				local v = s[i]
				t[v] = (t[v] or 0) + 1
			end
		end
		for i=1,nF and mi and #mi or 0 do
			local mi, sc = mi[i]
			local best, rp, rm, amlvl, bmlvl, cmlvl = best[mi], EvaluateGroup(mi, counters, traits, fa, fb, fc, scratch)
			consideredGroups, sc = consideredGroups+1, (rp * (1 + (doStack and rm or 0)) * 16 + rm) * s1
			if best[1] - sc < s1 and SaveGroup(best, traits, fa, fb, fc, sc, amlvl, bmlvl, cmlvl, a, b, c) then
				local ua, ub, uc, score, bk = fa.useMarks, fb and fb.useMarks, fc and fc.useMarks, best[1], bkey[best]
				for j=1,mi[2] do
					if not ua then
					elseif ua[bk] ~= score then
						ua[bk], ua[-bk] = score, 1
					else
						ua[-bk] = ua[-bk] + 1
					end
					ua, ub = ub, uc
				end
			end
		end
		if not c and s == 3 then
			c, mi = b >= nf1 and nf1 or b, ms[3]
		elseif not b and s == 2 then
			b = a >= nf1 and nf1 or a
		end
	end
	
	local ret, GetGroup = {}, est.GetGroup
	for i=1,#missions do
		local mi = missions[i]
		local best = best[mi and mi.s]
		if best and best[1] > 0 then
			local head = math.floor(best[1]/s1)
			local stack = head % 16
			local gg = GetGroup(best, mi.s, f, counters, traits, stack, (head-stack)/16/(1 + (doStack and stack or 0)))
			ret[mi[1]], gg.mi = gg, mi
		end
		local bk = bkey[best]
		for j=1,bk and best and #f or 0 do
			if f[j].useMarks then
				f[j].useMarks[bk], f[j].useMarks[-bk] = f[j].useMarks[bk] == best[1] and f[j].useMarks[-bk] or nil
			end
		end
	end
	
	return ret
end
do -- +api.GetSuggestedMissionUpgradeGroups(missions, ojob, f1, f2, f3)
	local upgroups, summaries, tt, gt = {}, {}, {}, {0,0,0, nil,nil,nil, 0,0,0}
	function EV:MP_RELEASE_CACHES()
		upgroups, summaries = {}, {}
	end
	function api.GetMissionSummary(mi)
		local mid = mi.missionID
		local s = summaries[mid]
		if not s then
			local rt
			if mi.rewards then
				for k,v in pairs(mi.rewards) do
					if v.itemID then
						rt = v.itemID
					elseif v.currencyID then
						rt = rt or v.currencyID
					end
				end
			end
			local _, _, _, _, env, _, _, en = C_Garrison.GetMissionInfo(mid)
			s = {
				mi.level == FOLLOWER_LEVEL_CAP and mi.iLevel > 600 and mi.iLevel or mi.level,
				mi.numFollowers,
				mi.durationSeconds,
				rt or 1,
				mi.followerTypeID == 2 and select(4,C_Garrison.GetPartyMissionInfo(mi.missionID)) or env and api.GetMechanicInfo(tostring(env)) or 0,
			}
			for i=1,#en do
				local mech = en[i].mechanics
				for i=1,#mech do
					tt[#tt+1] = mech[i].mechanicTypeID
				end
			end
			table.sort(tt)
			for i=1,#tt do
				s[5+i], tt[i] = tt[i]
			end
			summaries[mid] = s
		end
		return s
	end
	local function hasMaxedGroup(mi, rt)
		local groups, cs, cmax, cval = mi.groups
		if rt == "resources" and mi.rewards then
			for k,v in pairs(mi.rewards) do
				local cid = v.currencyID
				if cid then
					cs, cval = cid, v.quantity
					cmax = cval * ((T.TraitStack[cid] and mi.numFollowers or 0) + 1)
					break
				end
			end
		end
		for i=1,groups and #groups or 0 do
			local g = groups[i]
			if g[1] == 100 and g[cs] == cmax then
				return true
			end
		end
		return false, cs, cval
	end
	local function procJobs(jobs, yield)
		yield()
		local best = api.UpdateGroupEstimates(jobs, api.GetGroupMemberPool(1, true), yield)
		local finfo, now = api.GetFollowerInfo(), time()
		for i=1,#jobs do
			local j = jobs[i]
			upgroups[j[1]] = false
			local b, mi = best[j[1]], j[2]
			if b then
				gt[1], gt[3], gt[4], gt[5], gt[6], gt[7], gt[9] = b[5], j[4]*(1 + (b[4] or 0)), b.time, b[1], b[2], b[3], j[3]
				flushGroupAnnotations(gt)
				local og, rank = mi.groups, mi.groups and mi.groups.rankFunc
				if not (rank and ((og[1] and not rank(gt, og[1], finfo, mi, now)) or (#og > 1 and not rank(gt, og[#og], finfo, mi, now)))) then
					b.cslot, b.cval = j[3], gt[j[3]]
					upgroups[j[1]], mi.upgroup = b, b
				end
			end
		end
		yield(2, 1, 1)
	end
	local coJobs = setmetatable({}, {__mode="k"})
	local function cmp1(a,b)
		return a[1] < b[1]
	end
	function api.GetSuggestedMissionUpgradeGroups(missions, ojob, f1, f2, f3)
		local fid = api.GetFollowerIdentity(true, false, 1)
		if upgroups.identity ~= fid then
			wipe(upgroups)
			upgroups.identity = fid
		end
		local noRoamers, oc, job = not (f1 or f2 or f3), coJobs[ojob]
		for i=1,#missions do
			local mi, rt, mid = missions[i]
			rt, mid, mi.upgroup = noRoamers and mi.level == FOLLOWER_LEVEL_CAP and mi.numFollowers > 1 and mi.groups and mi.groups.rankType, mi.missionID
			if rt == "threats" or rt == "resources" then
				local hasMaxed, curID, baseValue = hasMaxedGroup(mi, rt)
				if hasMaxed then
				elseif upgroups[mid] == nil then
					job = job or {}
					job[#job + 1] = {mid, mi, curID or -1, baseValue or 0, s=api.GetMissionSummary(mi)}
				else
					mi.upgroup = upgroups[mid]
				end
			end
		end
		if job then
			table.sort(job, cmp1)
			if oc and #oc == #job and oc.fid == fid then
				local diff = false
				for i=1,#job do
					local a, b = job[i], oc[i]
					if a[1] ~= b[1] or a[3] ~= b[3] or a[4] ~= b[4] then
						diff = true
						break
					end
				end
				if not diff then
					return ojob
				end
			end
			local cw = coroutine.create(procJobs)
			coJobs[cw], job.fid = job, fid
			coroutine.resume(cw, job, coroutine.yield)
			return cw
		end
	end
end
function api.GetFollowerRerollConstraints(fid)
	local tf = C_Garrison.GetFollowerInfo(fid)
	local mt, isInactive = tf.followerTypeID, tf.status == GARRISON_FOLLOWER_INACTIVE
	local info = tf.isCollected and api.GetBestGroupInfo(mt, isInactive, false)
	if not info then return end
	
	local est = mt == 1 and FollowerEstimator or ShipEstimator
	local f = est.GetMemberPool(isInactive)
	for i=1,#f do
		f[f[i].followerID] = f[i]
	end
	
	local tf, scratch, counters, traits, ts, mts = f[fid], {}, est.PrepareCounters()
	local tfsa, tfa, cc, ct, lt = tf.saffinity, tf.affinity, {}, {}, T.LockTraits
	for i=1,2 do
		local s, d = tf[i == 1 and "counters" or "traits"], i == 1 and cc or ct
		for i=1,#s do
			if s[i] > 0 then
				d[s[i]] = i
			end
		end
	end
	
	local hasInterestedMissions, hasDoubleCounter, rt = false, tf.counters[1] == tf.counters[2]
	for _, mi, b in api.MoIMissions(mt, info) do
		local idx = b and (b[1] == fid and 1 or b[2] == fid and 2 or b[3] == fid and 3)
		if idx and b.used and api.IsInterestedInMoI(mi) and b.used % (2^idx) >= 2^(idx-1) then
			hasInterestedMissions, rt = true, mi.s[4]
			for j=1,mi.s[2] do
				for i=1,2 do
					local s, t = f[b[j]][i == 1 and "counters" or "traits"], i == 1 and counters or traits
					for i=1,#s do
						local v = s[i]
						t[v] = (t[v] or 0) + 1
					end
				end
			end
			ct[ts[rt] or 0], ct[mts and mts[rt] or 0] = nil, nil
			local fa, fb, fc = f[b[1]], f[b[2]], f[b[3] or b[2]]
			local bgv = est.EvaluateGroup(mi.s, counters, traits, fa, fb, fc, scratch)
			for i=1,2 do
				local s, t = i == 1 and cc or ct, i == 1 and counters or traits
				for k in pairs(s) do
					if not lt[k] then
						local d = hasDoubleCounter and i == 1 and 2 or 1
						t[k] = t[k] - d
						if tfsa and tfa == k and i == 2 then
							tf.saffinity = false
						end
						local gv = est.EvaluateGroup(mi.s, counters, traits, fa, fb, fc, scratch)
						if gv < bgv then
							s[k] = nil
						end
						t[k], tf.saffinity = t[k] + d, tfsa
					end
				end
			end
			
			for j=1,mi.s[2] do
				for i=1,2 do
					local s, t = f[b[j]][i == 1 and "counters" or "traits"], i == 1 and counters or traits
					for i=1,#s do
						local v = s[i]
						t[v] = t[v] - 1
					end
				end
			end
		end
	end
	
	local at = C_Garrison.GetFollowerAbilities(tf.garrFollowerID)
	for k,v in pairs(at) do
		local t = v.isTrait and ct or cc
		local k = v.isTrait and v.id or C_Garrison.GetFollowerAbilityCounterMechanicInfo(v.id)
		t[k] = t[k] and "soft"
	end
	
	return cc, ct, hasInterestedMissions
end

function api.GetRewardMultiplier(minfo, curID, passingMultiplierData, mm, gm)
	local k = "rewardMultiplier" .. (curID or "N")
	local ret = minfo[k]
	if not ret and curID then
		if not passingMultiplierData then
			mm, gm = select(8, C_Garrison.GetPartyMissionInfo(minfo.missionID))
		end
		if curID == 0 then
			ret = gm or 1
		else
			ret = mm and mm[curID] or 1
		end
		minfo[k] = ret
	end
	return ret or 1
end

function api.GetMoIRewardIcon(rid)
	if rid == 0 then
		return "|TInterface\\Icons\\INV_Misc_Coin_01:14:14:0:0:64:64:4:60:4:60|t"
	elseif rid < 2000 then
		return "|T" .. (select(3,Nine.GetCurrencyInfo(rid)) or "Interface/Icons/Temp") .. ":14:14:0:0:64:64:4:60:4:60|t"
	else
		return "|T" .. (GetItemIcon(rid) or "Interface/Icons/Temp") .. ":14:14:0:0:64:64:4:60:4:60|t"
	end
	return ""
end

local function addFollowerList(tip, info, finfo, mlvl, showInactive, thisMech, specDup)
	api.sortByFollowerLevels(info, finfo)
	for i=1,#info do
		if info[i] ~= specDup then
			local fi = finfo[info[i]]
			if not showInactive and fi.status == GARRISON_FOLLOWER_INACTIVE then
				tip:AddLine((L"+%d Inactive (hold ALT to view)"):format(#info-i+1), 0.8, 0.78, 0.56)
				break
			end
			local p = specDup and select(4, api.CountUniqueRerolls(T.SpecCounters[fi.classSpec], info[i]))
			p = p and p .. " " or ""
			tip:AddDoubleLine(api.GetFollowerLevelDescription(info[i], mlvl, finfo[info[i]]), p .. api.GetOtherCounterIcons(finfo[info[i]], thisMech), 1,1,1)
		end
	end
end
function api.countFreeFollowers(f, finfo)
	local ret, finfo = 0, finfo or api.GetFollowerInfo()
	for i=1,f and #f or 0 do
		local st = finfo[f[i]].status
		if not (st == GARRISON_FOLLOWER_INACTIVE or st == GARRISON_FOLLOWER_WORKING or T.config.ignore[f[i]]) then
			ret = ret + 1
		end
	end
	return ret
end
function api.CountUniqueRerolls(counters, thisFollowerID)
	local finfo, c = api.GetFollowerInfo(), counters
	local dc, novel, inact = api.GetDoubleCounters(), 0, 0
	
	local me = finfo[thisFollowerID]
	local lockedCounter = api.GetFollowerLockedCounterInfo(me and (me.garrFollowerID or me.followerID) or thisFollowerID)
	local total = 0
	
	for i=1,#c do
		for j=lockedCounter and #c or (i+1), #c do
			local c1, c2 = c[i], lockedCounter or c[j]
			local ft, ac, ic = dc[c1*100 + c2], 0, 0
			for i=1,ft and #ft or 0 do
				if ft[i] == thisFollowerID then
				elseif finfo[ft[i]].status ~= GARRISON_FOLLOWER_INACTIVE then
					ac = ac + 1
					break
				else
					ic = ic + 1
				end
			end
			total = total + 1
			if ac == 0 and ic == 0 then
				novel = novel + 1
			elseif ac == 0 then
				inact = inact + 1
			end
		end
	end
	
	local desc = inact > 0 and "|cffccc78f" .. (novel > 0 and "+" or "") .. inact .. "|r" or ""
	desc = (novel > 0 and "|cff20ff20" .. novel .. "|r" or "") .. desc .. "|cffffffff/" .. total
	return novel, inact, total, desc
end
do -- GetFollowerLockedCounterInfo(fid)
	local lockedCounterCache = {}
	function api.GetFollowerLockedCounterInfo(fid)
		local cl = lockedCounterCache[fid]
		if not fid or cl == false then
			return
		elseif cl then
			return cl
		end
		local fat = C_Garrison.GetFollowerAbilities(fid)
		for k,v in pairs(fat) do
			if not v.isTrait and v.id and v.counters then
				cl = cl or next(v.counters)
			end
		end
		lockedCounterCache[fid] = cl or false
		return cl
	end
end
function api.SetClassSpecTooltip(self, specId, specName, ab1, ab2)
	local fi
	if type(specId) == "table" then
		fi, specId, specName = specId, specId.classSpec, specId.className
	end
	
	local c = T.SpecCounters[specId]
	if not c then return end
	
	self:ClearLines()

	local ci, finfo, dropCounter = api.GetCounterInfo(), api.GetFollowerInfo(), not ab2 and ab1 or nil
	local dct = api.GetDoubleCounters()
	if specName then
		self:AddLine(specName, 1,1,1)
		self:AddLine(L"Potential counters:")
		local lockedCounter = api.GetFollowerLockedCounterInfo(fi and (fi.garrFollowerID or fi.followerID))
		
		local leftLine
		for i=1,#c do
			for j=lockedCounter and #c or (i+1), #c do
				local pc, lc = lockedCounter or c[j], c[i]
				local lct, lpt = dct[pc*100+lc], dct[-(pc*100+lc)]
				local _, _, pi = api.GetMechanicInfo(pc)
				local _, _, li = api.GetMechanicInfo(lc)
				local pt = "|T" .. pi .. ":16:16:0:0:64:64:5:59:5:59|t"
				if leftLine then
					local rt = pt .. "|T" .. li .. ":16:16:0:0:64:64:5:59:5:59|t"
					local rf, ra, rp = api.countFreeFollowers(lct, finfo), lct and #lct or 0, lpt and #lpt or 0
					rt = (rf == 0 and ra == 0 and "0" or "") .. (rf > 0 and "|cff20ff20" .. rf .. "|r" or "") .. (ra > rf and (rf > 0 and "+" or "") .. "|cffccc78f" .. (ra - rf) .. "|r" or "") .. "|cffa0a0a0/" .. rp .. " " .. rt
					self:AddDoubleLine(leftLine, rt, 1,1,1, 1,1,1)
					leftLine = nil
				else
					local lt = pt .. "|T" .. li .. ":16:16:0:0:64:64:5:59:5:59|t"
					local lf, la, lp = api.countFreeFollowers(lct, finfo), lct and #lct or 0, lpt and #lpt or 0
					leftLine = lt .. " " .. (lf == 0 and la == 0 and "0" or "") .. (lf > 0 and "|cff20ff20" .. lf .. "|r" or "") .. (la > lf and (lf > 0 and "+" or "") .. "|cffccc78f" .. (la - lf) .. "|r" or "") .. "|cffa0a0a0/" .. lp
				end
			end
		end
		if leftLine then
			self:AddLine(leftLine, 1,1,1)
		end
	else
		self:AddLine(ITEM_QUALITY_COLORS[4].hex .. L"Epic Ability")
		self:AddLine(L"An additional random ability is unlocked when this follower reaches epic quality." .. "|n ", 1,1,1, 1)
		self:AddLine(L"Potential counters:")
		for i=1,#c do
			if c[i] == dropCounter then
				dropCounter = nil
			else
				local _, name, ico = api.GetMechanicInfo(c[i])
				local counters = ci[c[i]]
				local freeCount, totalCount = api.countFreeFollowers(counters, finfo), counters and #counters or 0
				local counts = (freeCount > 0 and "|cff20ff20" .. freeCount or "0") .. "|r+|cffccc78f" .. (totalCount - freeCount)
				self:AddDoubleLine("|TInterface\\Buttons\\UI-Quickslot2:13:2:-1:0:64:64:31:32:31:32|t|T" .. ico .. ":0:0:0:0:64:64:5:59:5:59|t " .. name, counts, 1,1,1, 1,1,1)
			end
		end
	end
	
	self:SetBackdropColor(0,0,0)
	
	local novel, inact, _, rerollDesc = api.CountUniqueRerolls(c, fi and fi.followerID)
	if novel > 0 or inact > 0 then
		self:AddDoubleLine(L"Unique ability rerolls:", rerollDesc)
	end
	
	if fi and fi.quality >= 4 and fi.isCollected then
		local a1, a2 = C_Garrison.GetFollowerAbilityAtIndex(fi.followerID, 1), C_Garrison.GetFollowerAbilityAtIndex(fi.followerID, 2)
		a1, a2 = C_Garrison.GetFollowerAbilityCounterMechanicInfo(a1), C_Garrison.GetFollowerAbilityCounterMechanicInfo(a2)
		local sd = dct[a1 < a2 and (a1 * 100 + a2) or (a2 * 100 + a1)]
		if sd and #sd > 1 then
			self:AddLine(" ")
			self:AddLine(L"Duplicate counters" .. ":")
			addFollowerList(self, sd, finfo, nil, true, nil, fi.followerID)
		end
	end
	
	self:Show()
	return true
end
function api.SetTraitTooltip(tip, id, info, showInactive, skipDescription)
	if not showInactive then T.SetModifierSensitiveTip(api.SetTraitTooltip, tip, id, info, showInactive, skipDescription) end
	local finfo, showInactive = api.GetFollowerInfo(), showInactive or IsShiftKeyDown() or IsAltKeyDown()
	local ico, nl = "|T" .. C_Garrison.GetFollowerAbilityIcon(id) .. ":0:0:0:0:64:64:4:60:4:60|t ", skipDescription and "" or "|n"
	if skipDescription then
		tip:SetText(" ")
	else
		tip:SetText(ico .. C_Garrison.GetFollowerAbilityName(id))
		tip:AddLine(C_Garrison.GetFollowerAbilityDescription(id), 1,1,1, 1)
		local mid, mname, mico = C_Garrison.GetFollowerAbilityCounterMechanicInfo(id)
		if mid and mid > 0 then
			tip:AddLine("|n" .. GARRISON_ABILITY_COUNTERS .. "|T" .. mico .. ":0:0:0:0:64:64:4:60:4:60|t |cffffffff" .. mname, 0.698, 0.941, 1)
		end
	end
	if info == nil then info = api.GetFollowerTraits()[id] end
	if info and #info > 0 then
		tip:AddLine(nl .. L"Followers with this trait:", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
		addFollowerList(tip, info, finfo, nil, showInactive)
	elseif id and id < 331 then
		tip:AddLine(nl .. L"You have no followers with this trait.", 1,0.50,0, 1)
	end
	info = info and info.affine
	if not info then
	elseif info == true or #info == 0 then
		tip:AddLine("|n" .. L"You have no followers who activate this trait.", 1,0.50,0, 1)
	else
		tip:AddLine("|n" .. L"Followers activating this trait:", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
		addFollowerList(tip, info, finfo, nil, showInactive)
	end
end
function api.SetThreatTooltip(tip, id, info, missionLevel, showInactive, skipDescription)
	if not showInactive then T.SetModifierSensitiveTip(api.SetThreatTooltip, tip, id, info, missionLevel, showInactive, skipDescription) end
	local finfo, showInactive = api.GetFollowerInfo(), showInactive or IsShiftKeyDown() or IsAltKeyDown()
	local id, name, ico, desc = api.GetMechanicInfo(id)
	if skipDescription then
		tip:SetText(" ")
	else
		tip:SetText("|T" .. ico .. ":0:0:0:0:64:64:4:60:4:60|t " .. name)
		tip:AddLine(desc or "", 1,1,1, 1)
	end
	if info == nil then info = api.GetCounterInfo()[id] end
	if info and #info > 0 then
		tip:AddLine((skipDescription and "" or "|n") .. L"Can be countered by:", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
		addFollowerList(tip, info, finfo, missionLevel, showInactive, id)
	elseif id then
		local eq = T.EquipmentTraitQuests[T.EquipmentCounters[id]]
		if eq then
			tip:AddLine((skipDescription and "" or "|n") .. L"No ships are equipped to handle this mechanic.", 1,0.50,0, 1)
		else
			tip:AddLine((skipDescription and "" or "|n") .. L"You have no followers to counter this mechanic.", 1,0.50,0, 1)
		end
	end
end
function api.SetFollowerListTooltip(tip, header, list, showInactive, finfo)
	tip:SetText(header or " ")
	addFollowerList(tip, list, finfo or api.GetFollowerInfo(), nil, showInactive)
end
local prefixTip do
	local hooked = {}
	local function writePrefix(self)
		local t = hooked[self]
		GameTooltip_ClearMoney(self)
		if t and t[1] then
			self:AddLine(t[1],t[2],t[3],t[4])
			t[1],t[2],t[3],t[4] = nil
		end
	end
	function prefixTip(tip, text, r,g,b)
		local t = hooked[tip] or {}
		t[1],t[2],t[3],t[4] = text, r, g, b
		tip:SetText("?")
		if not hooked[tip] then
			tip:HookScript("OnTooltipCleared", writePrefix)
			hooked[tip] = t
		end
	end
end
function api.SetItemTooltip(tip, id)
	local cs = T.TokenSlots[id]
	tip:SetItemByID(id)
	local sta = getShoppingTooltips(tip)
	if cs and sta then
		T.SetModifierSensitiveTip(api.SetItemTooltip, tip, id)
		local st1, st2 = sta[1], sta[2]
		if IsModifiedClick("COMPAREITEMS") or GetCVarBool("alwaysCompareItems") then
			local ofsFrame, oy = GameTooltip, -8
			if GetInventoryItemID("player", cs) then
				st1:SetOwner(tip, "ANCHOR_NONE")
				st1:SetPoint("TOPRIGHT", tip, "TOPLEFT", -2, oy)
				prefixTip(st1, CURRENTLY_EQUIPPED, 0.5, 0.5, 0.5)
				st1:SetInventoryItem("player", cs)
				st1:Show()
				ofsFrame, oy = st1, 0
			end
			if cs > 10 and GetInventoryItemID("player", cs+1) then
				st2:SetOwner(GameTooltip, "ANCHOR_NONE")
				st2:SetPoint("TOPRIGHT", ofsFrame, "TOPLEFT", -2, oy)
				prefixTip(st2, CURRENTLY_EQUIPPED, 0.5, 0.5, 0.5)
				st2:SetInventoryItem("player", cs+1)
				st2:Show()
			end
		else
			st1:Hide()
			st2:Hide()
		end
	end
end
local function doSetCurrencyTraitTip(owner, id, tip)
	if IsModifiedClick("COMPAREITEMS") or GetCVarBool("alwaysCompareItems") then
		tip:SetOwner(owner, "ANCHOR_NONE")
		tip:SetPoint("TOPRIGHT", owner, "TOPLEFT", -2, -4)
		prefixTip(tip, L"Amount affected by", 0.5, 0.5, 0.5)
		api.SetTraitTooltip(tip, T.TraitDisplayMap and T.TraitDisplayMap[id] or id)
		tip:Show()
	else
		tip:Hide()
	end
	T.SetModifierSensitiveTip(doSetCurrencyTraitTip, owner, id, tip)
end
function api.SetCurrencyTraitTip(tip, id, ftype)
	local ts = T[ftype == 2 and "ShipTraitStack" or "TraitStack"][id]
	local sta = getShoppingTooltips(tip)
	if ts and sta and sta[1] then
		doSetCurrencyTraitTip(tip, ts, sta[1])
	end
end
function api.SetGroupTooltip(tip, g, mi)
	tip:ClearLines()
	local rq, rt, rl = g[3], g[9], ""
	if rq <= 0 then
	elseif rt == 0 then
		rl = GetMoneyString(rq - rq % 1e4)
	elseif rt > 0 then
		rl = rq .. " |T" .. (select(3,Nine.GetCurrencyInfo(rt)) or "Interface/Icons/Temp") .. ":14:14:0:0:64:64:4:60:4:60|t"
	end
	tip:AddDoubleLine(g[1] .. "% |cffc0c0c0(" .. SecondsToTime(g[4]) .. ")", rl)
	local finfo, ml = api.GetFollowerInfo(), api.GetFMLevel(mi)
	for i=1,mi.numFollowers do
		tip:AddLine(api.GetFollowerLevelDescription(g[4+i], ml, finfo[g[4+i]], g[10], mi.missionID, g))
	end
	local _, exp = api.GetMissionGroupXP(g, mi)
	if (exp or 0) > 0 then
		local exp = BreakUpLargeNumbers(floor(exp))
		tip:AddLine((L"+%s experience expected"):format(exp))
	end
end
function api.SetUpGroupTooltip(tip, g, mi)
	local cid, cq
	if mi.rewards then
		for k,v in pairs(mi.rewards) do
			if v.currencyID then
				cid, cq = v.currencyID, v.quantity
				break
			end
		end
	end
	if cid then
		cq = cq * (1 + (g[4] or 0))
		if cid == 0 then
			cq = GetMoneyString(cq - cq % 1e4)
		elseif cid > 0 then
			cq = cq .. " |T" .. (select(3,Nine.GetCurrencyInfo(cid)) or "Interface/Icons/Temp") .. ":14:14:0:0:64:64:4:60:4:60|t"
		else
			cid = nil
		end
	end
	if cid then
		tip:ClearLines()
		tip:AddDoubleLine(g[5] .. "% |cffc0c0c0(" .. SecondsToTime(g.time) .. ")", cq)
	else
		tip:SetText(g[5] .. "% |cffc0c0c0(" .. SecondsToTime(g.time) .. ")")
	end
	local finfo, mlvl = api.GetFollowerInfo(), api.GetFMLevel(mi)
	local blvl, mentor = g[6], g.mentorLevel or 0
	for i=1,mi.numFollowers do
		local mlvl = blvl and blvl % 1e3 or mlvl
		blvl, mlvl = blvl and (blvl - mlvl) / 1e3, mlvl == 600 and FOLLOWER_LEVEL_CAP or mlvl
		local fi = finfo[g[i]]
		local fl = api.GetFMLevel(fi)
		if fl >= mlvl or mentor >= mlvl then
			tip:AddLine(api.GetFollowerLevelDescription(g[i], mlvl, finfo[g[i]], mentor, mi.missionID))
		else
			tip:AddDoubleLine(api.GetFollowerLevelDescription(g[i], mlvl, finfo[g[i]], mentor, mi.missionID), "|TInterface\\PetBattles\\BattleBar-AbilityBadge-Strong-Small:0|t|cffff0000" .. mlvl)
		end
	end
	if (g.cval or 0) > 0 then
		local r = g.cslot == 3 and g.cval .. " |TInterface\\Garrison\\GarrisonCurrencyIcons:14:14:0:0:128:128:12:52:12:52|t" or GetMoneyString(g.cval)
		tip:AddLine(REWARDS .. ": |cffffffff" .. r) --TODO
	end
end
function api.GetUnderLevelledFollower(g, mi)
	local finfo, mlvl = api.GetFollowerInfo(), api.GetFMLevel(mi)
	local blvl, mentor = g[6], g.mentorLevel or 0
	for i=1,mi.numFollowers do
		local mlvl = blvl and blvl % 1e3 or mlvl
		blvl = blvl and (blvl - mlvl) / 1e3
		local fi = finfo[g[i]]
		local fl = api.GetFMLevel(fi)
		if fl < mlvl and mentor < mlvl then
			return g[i]
		end
	end
end
function api.SetDoubleCountersTooltip(tip, ci)
	T.SetModifierSensitiveTip(api.SetDoubleCountersTooltip, tip, ci)
	local showInactive = IsAltKeyDown()
	tip:SetText("|TInterface\\Icons\\Inv_Misc_Book_11:0:0:0:0:64:64:4:60:4:60|t " .. L"Duplicate counters")
	local finfo, skip, oico = api.GetFollowerInfo(), 0
	for i=1,ci and #ci or 0 do
		local ico = api.GetOtherCounterIcons(finfo[ci[i]])
		local show = showInactive or (ico == oico and finfo[ci[i]].status ~= GARRISON_FOLLOWER_INACTIVE)
		if not show and ico ~= oico and ci[i+1] then
			show = finfo[ci[i+1]].status ~= GARRISON_FOLLOWER_INACTIVE
			oico = ico
		end
		if show then
			tip:AddDoubleLine(api.GetFollowerLevelDescription(ci[i], nil, finfo[ci[i]]), ico, 1,1,1)
		else
			skip = skip + 1
		end
	end
	if skip > 0 then
		tip:AddLine((L"+%d Inactive (hold ALT to view)"):format(skip), 0.8, 0.78, 0.56)
	elseif (ci and #ci or 0) == 0 then
		tip:AddLine(L"You have no followers with duplicate counter combinations.", 1,1,1, 1)
	end
end
function api.SetCounterComboTip(tip, id1, id2)
	local finfo = api.GetFollowerInfo()
	local id1, name1, ico1, _desc1 = api.GetMechanicInfo(id1)
	local id2, name2, ico2, _desc2 = api.GetMechanicInfo(id2)
	
	tip:SetText("|T" .. ico1 .. ":0:0:0:0:64:64:4:60:4:60|t " .. name1 .. " |cffffffff+|r |T" .. ico2 .. ":0:0:0:0:64:64:4:60:4:60|t " .. name2)
	local info, hasLines = api.GetCounterInfo()[id1], false
	if info then
		api.sortByFollowerLevels(info, finfo)
		for i=1,#info do
			local fi = finfo[info[i]]
			local a1, a2 = C_Garrison.GetFollowerAbilityAtIndex(fi.followerID, 1), C_Garrison.GetFollowerAbilityAtIndex(fi.followerID, 2)
			if (a1 or 0)*(a2 or 0) > 0 then
				a1, a2 = C_Garrison.GetFollowerAbilityCounterMechanicInfo(a1), C_Garrison.GetFollowerAbilityCounterMechanicInfo(a2)
			else
				a1, a2 = nil
			end
			if (a1 == id1 and a2 == id2) or (a1 == id2 and a2 == id1) then
				if not hasLines then
					tip:AddLine(L"Can be countered by:", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
					hasLines = true
				end
				local p = select(4, api.CountUniqueRerolls(T.SpecCounters[fi.classSpec], info[i]))
				p = p and p .. " " or ""
				tip:AddDoubleLine(api.GetFollowerLevelDescription(info[i], nil, finfo[info[i]]), p, 1,1,1)
			end
		end
	end

	if not hasLines then
		local di = api.GetDoubleCounters()[-id1*100 - id2]
		if di and #di > 0 then
			tip:AddLine(L"Could be countered by re-rolling:", 1,0.50,0, 1)
			addFollowerList(tip, di, finfo, nil, true)
		else
			tip:AddLine(L"You have no followers to counter this mechanic.", 1,0.50,0, 1)
		end
	end
end
function api.SetCounterTraitTip(tip, cid, tid)
	local finfo = api.GetFollowerInfo()
	local _, name1, ico1, _desc1 = api.GetMechanicInfo(cid)
	local name2, ico2 = C_Garrison.GetFollowerAbilityName(tid), C_Garrison.GetFollowerAbilityIcon(tid)
	tip:SetText("|T" .. ico1 .. ":0:0:0:0:64:64:4:60:4:60|t " .. name1 .. " |cffffffff+|r |T" .. ico2 .. ":0:0:0:0:64:64:4:60:4:60|t " .. name2)
	local info, hasLines = api.GetCounterInfo()[cid], false
	if info then
		api.sortByFollowerLevels(info, finfo)
		for i=1,#info do
			local fi = finfo[info[i]]
			if fi.traits[tid] then
				if not hasLines then
					tip:AddLine(L"Can be countered by:", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
					hasLines = true
				end
				local p = select(4, api.CountUniqueRerolls(T.SpecCounters[fi.classSpec], info[i]))
				tip:AddDoubleLine(api.GetFollowerLevelDescription(info[i], nil, fi), p or "", 1,1,1)
			end
		end
	end

	if not hasLines then
		local info = api.GetFollowerTraits()[tid]
		for i=1,info and #info or 0 do
			local fi = finfo[info[i]]
			local hasCounter, sc = false, T.SpecCounters[fi.classSpec]
			for i=1,sc and #sc or 0 do
				if sc[i] == cid then
					hasCounter = true
					break
				end
			end
			if hasCounter then
				if not hasLines then
					tip:AddLine(L"Could be countered by re-rolling:", 1,0.50,0, 1)
					hasLines = true
				end
				tip:AddDoubleLine(api.GetFollowerLevelDescription(info[i], nil, fi), api.GetOtherCounterIcons(fi), 1,1,1)
			end
		end
		if not hasLines then
			tip:AddLine(L"You have no followers to counter this mechanic.", 1,0.50,0, 1)
		end
	end
end
local function GetCounterIconsByKey(key)
	local c1, c2 = math.floor(key/100), key%100
	local _, _, i1 = api.GetMechanicInfo(c1)
	local _, _, i2 = api.GetMechanicInfo(c2)
	return (i1 and "|T" .. i1 .. ":16:16:0:0:64:64:5:59:5:59|t|T" or "|T") .. i2 .. ":16:16:0:0:64:64:5:59:5:59|t"
end
function api.SetFollowerCloneTip(tip, cl, isCollected)
	local numLines = tip:NumLines()
	if cl.cR > 0 then
		tip:AddLine((isCollected and L"Required by %s |4Mission of Interest:Missions of Interest;." or L"Improves %s |4Mission of Interest:Missions of Interest;."):format(cl.cR))
	end
	if cl.cM > cl.cR then
		tip:AddLine((L"Usable in %s groups for %s Missions of Interest."):format(cl.cG, cl.cM))
	end
	if cl.lM > 0 then
		if cl.cM > 0 or cl.cR > 0 then
			tip:AddLine(" ")
		end
		tip:AddLine(ITEM_QUALITY_COLORS[4].hex .. L"Levelled to Epic:")
		tip:AddDoubleLine(L"Average:", (L"%.1f groups / %.1f missions"):format(cl.lG, cl.lM), nil,nil,nil, 1,1,1)
		if cl.ceR then
			tip:AddDoubleLine(L"Best Improvement:", (L"%d |4mission:missions;"):format(cl.ceR.nR) .. " " .. GetCounterIconsByKey(cl.ceR.key), nil,nil,nil, 1,1,1)
		end
		if cl.ceG and (not cl.ceR or cl.ceR.nR < cl.ceG.nG) then
			tip:AddDoubleLine(L"Most Groups:", (L"%d |4group:groups;"):format(cl.ceG.nG) .. " " .. GetCounterIconsByKey(cl.ceG.key), nil,nil,nil, 1,1,1)
		end
		if cl.ceM and (not cl.ceR or cl.ceR.nR < cl.ceM.nM) then
			tip:AddDoubleLine(L"Most Missions:", (L"%d |4group:groups;"):format(cl.ceM.nM) .. " " .. GetCounterIconsByKey(cl.ceM.key), nil,nil,nil, 1,1,1)
		end
	end
	if cl.eM > 0 then
		if cl.cM > 0 or cl.cR > 0 or cl.lM > 0 then
			tip:AddLine(" ")
		end
		local cq = cl.quality or 0
		tip:AddLine(ITEM_QUALITY_COLORS[5].hex .. (cq <= 3 and L"Retraining at Epic:" or L"Retraining:"))
		tip:AddDoubleLine(L"Average:", (L"%.1f groups / %.1f missions"):format(cl.eG, cl.eM), nil,nil,nil, 1,1,1)
		if cl.crR then
			tip:AddDoubleLine(L"Best Improvement:", (L"%d |4mission:missions;"):format(cl.crR.nR) .. " " .. GetCounterIconsByKey(cl.crR.key), nil,nil,nil, 1,1,1)
		end
		if cl.crG and (not cl.crR or cl.crR.nR < cl.crG.nG) then
			tip:AddDoubleLine(L"Most Groups:", (L"%d |4group:groups;"):format(cl.crG.nG) .. " " .. GetCounterIconsByKey(cl.crG.key), nil,nil,nil, 1,1,1)
		end
		if cl.crM and (not cl.crR or cl.crR.nR < cl.crM.nM) then
			tip:AddDoubleLine(L"Most Missions:", (L"%d |4mission:missions;"):format(cl.crM.nM) .. " " .. GetCounterIconsByKey(cl.crM.key), nil,nil,nil, 1,1,1)
		end
	end
	
	if cl.req then
		local addHeader, cc, overflow, cur, lastLeft, lastRight = true, 0, 0, cl.cur
		for i=1,2 do
			for _, mi in api.MoIMissions(1) do
				local mid = mi[1]
				if cl.req[mid] and api.IsInterestedInMoI(mi) and (i == 2) == (not (cur and cur[mid])) then
					if addHeader then
						tip:AddLine("|n" .. L"Could improve groups for:")
						addHeader = false
					end
					cc, lastLeft, lastRight = cc + 1, api.GetMoIRewardIcon(mi.s[4]) .. " " .. (C_Garrison.GetMissionName(mid) or mid), (i == 1 and "|cff00ff00" or "") .. cl.req[mid] .. "/" .. cl.rerollWeight
					if cc < 6 or i == 1 or IsAltKeyDown() then
						tip:AddDoubleLine(lastLeft, lastRight, 1,1,1, 1,1,1)
					else
						overflow = overflow + 1
					end
				end
			end
		end
		if overflow > 1 then
			tip:AddLine((L"+ %d other missions"):format(overflow), 0.8, 0.8, 0.8)
		elseif overflow == 1 then
			tip:AddDoubleLine(lastLeft, lastRight, 1,1,1, 1,1,1)
		end
	end
	if tip:NumLines() == numLines then
		tip:AddLine(L"Not useful with current traits.", 0.95, 0.45, 0, 1)
	end
	tip:Show()
end

do -- api.GetResourceCacheInfo
	local STEP_INTERVAL, STEP_SIZE, STORE_FLOOR, STORE_CEIL = 600, 1, 10, 500
	local function getCacheData()
		return MasterPlanA.data.lastCacheTime, tonumber(MasterPlanA.data.cacheSize) or STORE_CEIL
	end
	function api.GetResourceCacheInfo(lt, sz)
		if not lt then
			lt, sz = securecall(getCacheData)
		end
		if lt and lt > 0 then
			local cur = min(sz, floor((GetServerTime()-lt)/STEP_INTERVAL)*STEP_SIZE)
			return cur < STORE_FLOOR and 0 or cur, sz, lt, sz/STEP_SIZE*STEP_INTERVAL
		end
	end
	function api.GetRecruitInfo()
		local rt = MasterPlanA.data.recruitTime
		local dt = type(rt) == "number" and GetServerTime()-rt
		return dt, 604800, rt
	end
end

function api.HasLevelTwoInn()
	local a, b = C_Garrison.GetOwnedBuildingInfoAbbrev(25), C_Garrison.GetOwnedBuildingInfoAbbrev(22)
	return a == 35 or a == 36 or b == 35 or b == 36
end
function api.GetMissionPoolIdentity(mt)
	if mt ~= 1 then
		local m = T.ShipMissionReplacements
		for i=1,#m do
			local c = m[i]
			for j=2,#c do
				local _, _, _, la = api.GetMissionSeen(c[j])
				if la then
					for j=2,#c do
						local e = T.ShipInterestPool[j-1]
						e[1], e.s[4] = c[j], c[1]
					end
					return ""
				end
			end
		end
		return ""
	end

	local ls, mp = T.config.legendStep, T.InterestPool
	local c2, c3 = ls > 0 or Nine.IsQuestFlaggedCompleted(35998), ls > 1 or Nine.IsQuestFlaggedCompleted(36013)
	T.config.legendStep = c3 and 2 or c2 and 1 or nil
	local ng = not (C_Garrison.GetOwnedBuildingInfoAbbrev(25) == 36 or C_Garrison.GetOwnedBuildingInfoAbbrev(22) == 36)
	
	for i=1,#mp do
		local m = mp[i]
		local r = m.s[4]
		m.drop = ((ng and m[4] == 35) or (c2 and r == 115280) or (c3 and r == 115510)) and true or nil
	end
	
	return string.char(65 + (c3 and 2 or c2 and 1 or 0) + (ng and 4 or 0))
end
do -- api.GetBestGroupInfo()
	local tag, res, job = {}, {}, {}
	local function baseRun(this, ck, notifyEvent, run, ...)
		job[ck] = this
		local ret = run(...)
		if job[ck] == this then
			res[ck], job[ck] = ret, nil
			EV(notifyEvent, ret)
		end
	end
	function api.GetBestGroupInfo(mt, includeInactive, allowStart)
		assert(type(mt) == "number" and type(includeInactive) == "boolean")
		local ck = mt .. (includeInactive and "i" or "a") .. (bit.band(T.config.interestStack, 2^mt/2) > 0 and "S" or "C")
		local ident = api.GetMissionPoolIdentity(mt) .. "/" .. api.GetFollowerIdentity(includeInactive, false, mt)
		if ident ~= tag[ck] then
			tag[ck], res[ck], job[ck] = ident, nil, nil
		end
		if allowStart and not (res[ck] or (job[ck] and coroutine.status(job[ck]) ~= "dead")) then
			local pool = mt == 1 and T.InterestPool or T.ShipInterestPool
			local job = coroutine.create(baseRun)
			coroutine.resume(job, job, ck, "MP_MOI_GROUPS_READY", api.UpdateGroupEstimates, pool, api.GetGroupMemberPool(mt, includeInactive), coroutine.yield)
		end
		return res[ck], not res[ck] and (allowStart and job[ck]) or nil
	end
	function api.IsInterestedInMoI(moi)
		local mb = T.InterestMask[moi[5] or moi.s[4]] or 0
		return T.config.interestMask % 2^mb < 2^(mb-1)
	end
	local nextMission, nextShipMission do
		local function nextFor(pool)
			return function(best, id)
				id = id + 1
				local p = pool[id]
				if not p then
				elseif p.drop then
					return nextMission(best, id)
				else
					return id, p, best and best[p[1]]
				end
			end
		end
		nextMission, nextShipMission = nextFor(T.InterestPool), nextFor(T.ShipInterestPool)
	end
	function api.MoIMissions(mt, best)
		return mt == 1 and nextMission or nextShipMission, best, 0
	end
	function EV:MP_RELEASE_CACHES()
		res, tag, job = {}, {}, {}, {}
	end
	
	local function annotateClones(clones, f, cur)
		local cs, sw, ew, double = T.SpecCounters[f.classSpec], 0, 0
		for i=2,#cs do
			if cs[i-1] == cs[i] then
				double = cs[i]
				break
			end
		end
		local cc = f.counters[2] == nil and f.counters[1] or nil
		for k,v in pairs(clones) do
			if type(k) == "number" then
				local c1, c2 = math.floor(k/100), k % 100
				local w = c1 == 0 and 0 or (c1 == c2) and 1 or (c1 == double or c2 == double) and 2 or 1
				local ec = ((c1 == cc or c2 == cc) and w or 0)
				v.weight, sw, ew, v.epic, v.key = w, sw + w, ew + ec, ec, k
			end
		end
		clones.rerollWeight, clones.levelWeight, clones.cur, clones.quality = sw, ew, cur, f.quality
		return clones
	end
	local function synthFollower(fi, at, rtid)
		fi.affinity, rtid = T.Affinities[fi.followerID], rtid and (rtid .. "#" .. fi.followerID)
		fi.followerID, fi.garrFollowerID = "Sx" .. fi.followerID, fi.followerID

		local counters, traits, et = {}, {-fi.affinity}, T.EquivTrait
		for i=1,#at do
			local isTrait, id = at[i].isTrait, at[i].id
			rtid = rtid and (rtid .. ":" .. id)
			if isTrait then
				id = et[id] or id
				traits[#traits+1], fi.saffinity = id, fi.saffinity or (id == -fi.affinity)
			else
				counters[#counters+1] = C_Garrison.GetFollowerAbilityCounterMechanicInfo(id)
			end
		end
		fi.counters, fi.traits = counters, traits

		return fi, rtid
	end
	local function runRecruitProspects(rt, yield)
		for i=1,#rt do
			local fi, ct = rt[i]
			fi.useMarks, fi.clones, ct = {}, {}, T.SpecCounters[fi.classSpec]
			local c1, c2 = fi.counters[1], fi.counters[2] or 0
			c1, c2 = c1 < c2 and c1 or c2, c1 < c2 and c2 or c1
			local skey = c1*100+c2
			fi.clones[skey] = fi

			local lockedCounter = api.GetFollowerLockedCounterInfo(fi.garrFollowerID or fi.followerID)
			for i=1,#ct do
				for j=lockedCounter and #ct or (i+1),#ct do
					local a, b = ct[i], lockedCounter or ct[j]
					local key = a*100+b
					if not fi.clones[key] then
						local cl = {}
						for k,v in pairs(fi) do
							cl[k] = v
						end
						rt[#rt+1], cl.counters, cl.useMarks, fi.clones[key] = cl, {a, b}, {}, cl
					end
				end
			end
		end
		
		local fp, nf1 = api.GetGroupMemberPool(1, false, rt)
		local ret, gc, groups = {}, {}, api.UpdateGroupEstimates(T.InterestPool, fp, yield, nf1)
		for k,v in pairs(groups) do
			gc[k] = v.variants
		end
		for i=1,3 do
			local t, c = {}, {}
			for k,v in pairs(rt[i].clones) do
				c[k] = v.useMarks
				for k, v in pairs(c[k]) do
					gc[k] = gc[k] - v
				end
			end
			ret[i], t.classSpec, t.clones, c.gc = t, rt[i].classSpec, annotateClones(c, rt[i], rt[i].useMarks), gc
		end
		ret.gc = gc
		
		return ret
	end
	local function runRerollProspects(fid, isInactive, yield)
		local mm
		if type(fid) == "number" then
			mm = {(synthFollower(C_Garrison.GetFollowerInfo(fid), C_Garrison.GetFollowerAbilities(fid)))}
			fid = mm[1].followerID
		end
		local ft, me = api.GetGroupMemberPool(1, isInactive, mm, fid)
		for i=1,#ft do
			if ft[i].followerID == fid then
				me, ft[i], ft[#ft] = ft[i], i < #ft and ft[#ft] or nil
				break
			end
		end
		me.active, me.working = 1, 0
		
		local bMax, ct, clones = #ft, T.SpecCounters[me.classSpec], {}
		local lockedCounter = api.GetFollowerLockedCounterInfo(me.garrFollowerID or me.followerID or fid)
		for i=1,#ct do
			for j=lockedCounter and #ct or (i+1),#ct do
				local a, b = ct[i], lockedCounter or ct[j]
				local key = a*100+b
				if not clones[key] then
					local cl = {}
					for k,v in pairs(me) do
						cl[k] = v
					end
					ft[#ft+1], cl.counters, cl.useMarks, clones[key] = cl, {a, b}, {}, cl
				end
			end
		end
		
		local ret, gc, groups = {}, {}, api.UpdateGroupEstimates(T.InterestPool, ft, yield, bMax)
		for k,v in pairs(groups) do
			gc[k] = v.variants
		end
		for k,v in pairs(clones) do
			ret[k] = v.useMarks
			for k, v in pairs(ret[k]) do
				gc[k] = gc[k] - v
			end
		end
		ret.gc = gc
		
		local c1, c2 = me.counters[1], me.counters[2]
		local cur = c2 and c1 and (ret[c2*100+c1] or ret[c1*100+c2]) or nil
		return annotateClones(ret, me, cur)
	end
	function api.GetRecruitGroupProspects(allowStart)
		local ck, rt, rtid, _ = "rec" .. (T.config.interestStack % 2 > 0 and "S" or "C"), C_Garrison.GetAvailableRecruits(), ""
		for i=1,#rt do
			_, rtid = synthFollower(rt[i], C_Garrison.GetRecruitAbilities(i), rtid)
		end
		rtid = rtid .. "//" .. api.GetMissionPoolIdentity(1) .. "//" .. api.GetFollowerIdentity(false, true, 1)
		if rtid ~= tag[ck] then
			tag[ck], res[ck], job[ck] = rtid, nil, nil
		end
		
		if allowStart and not (res[ck] or (job[ck] and coroutine.status(job[ck]) ~= "dead")) then
			local job = coroutine.create(baseRun)
			assert(coroutine.resume(job, job, ck, "MP_RECRUIT_PROSPECTS_READY", runRecruitProspects, rt, coroutine.yield))
		end
		
		return res[ck], not res[ck] and (allowStart and job[ck]) or nil
	end
	function api.GetRerollProspects(fid, allowStart)
		local ck = "reroll-" .. (T.config.interestStack % 2 > 0 and "S" or "C") .. fid
		local isInactive = type(fid) == "string" and C_Garrison.GetFollowerStatus(fid) == GARRISON_FOLLOWER_INACTIVE
		local rtid = api.GetMissionPoolIdentity(1) .. "//" .. api.GetFollowerIdentity(isInactive, true, 1)
		if rtid ~= tag[ck] then
			tag[ck], res[ck], job[ck] = rtid, nil, nil
		end
		
		if allowStart and not (res[ck] or (job[ck] and coroutine.status(job[ck]) ~= "dead")) then
			local job = coroutine.create(baseRun)
			assert(coroutine.resume(job, job, ck, "MP_REROLL_PROSPECTS_READY", runRerollProspects, fid, isInactive, coroutine.yield))
		end
		
		return res[ck], not res[ck] and (allowStart and job[ck]) or nil
	end
	function api.AnnotateCloneProspects(clones)
		clones.req = nil
		for k,v in pairs(clones) do
			if type(k) == "number" then
				v.nR, v.nG, v.nM = 0, 0, 0
			end
		end
		
		local gc = clones.gc
		for _, mi in api.MoIMissions(1) do
			if api.IsInterestedInMoI(mi) then
				local gc, mid = gc[mi[1]], mi[1]
				for k,v in pairs(clones) do
					local ng = type(k) == "number" and v[mid]
					if ng and ng > 0 then
						v.nG, v.nM = v.nG + ng, v.nM + 1
						if gc == 0 then
							v.nR = v.nR + 1
							clones.req = clones.req or {}
							clones.req[mid] = (clones.req[mid] or 0) + v.weight
						end
					end
				end
			end
		end
		
		local sR, sUG, sUM, lR, lUG, lUM, cw, ew = 0,0,0, 0,0,0, clones.rerollWeight, math.max(1,clones.levelWeight)
		local eR, eG, eM, rR, rG, rM
		for k,v in pairs(clones) do
			if type(k) == "number" then
				local w, ew, nR, nG, nM = v.weight, v.epic, v.nR, v.nG, v.nM
				sR, sUG, sUM = sR + w*nR, sUG + w*nG, sUM + w*nM
				lR, lUG, lUM = lR + ew*nR, lUG + ew*nG, lUM + ew*nM
				if ew > 0 then
					eR, eG, eM = eR and eR.nR >= v.nR and eR or v, eG and eG.nG >= v.nG and eG or v, eM and eM.nM >= v.nM and eM or v
				end
				rR, rG, rM = rR and rR.nR >= v.nR and rR or v, rG and rG.nG >= v.nG and rG or v, rM and rM.nM >= v.nM and rM or v
			end
		end
		
		local m, cur = clones, clones.cur
		m.eR, m.eG, m.eM = sR/cw, sUG/cw, sUM/cw
		m.lR, m.lG, m.lM = lR/ew, lUG/ew, lUM/ew
		m.cR, m.cG, m.cM = cur and cur.nR or 0, cur and cur.nG or 0, cur and cur.nM or 0
		m.ceR, m.ceG, m.ceM, m.crR, m.crG, m.crM = eR and eR.nR > 0 and eR, eG and eG.nG > 0 and eG, eM and eM.nM > 0 and eM, rR and rR.nR > 0 and rR, rG and rG.nG > 0 and rG, rM and rM.nM > 0 and rM
		return m
	end
end

T.Garrison = api