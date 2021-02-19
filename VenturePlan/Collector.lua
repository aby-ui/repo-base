local _, T = ...
local EV = T.Evie

local serialize do
	local sigT, sigN = {}
	local sReg, sRegRev, sign = {__index={true, false, "newHealth", "oldHealth", "maxHealth", "boardIndex", "type", "casterBoardIndex", "spellID", "auraType", "effectIndex", "targetInfo", "schoolMask", "points", "events" , "missionID", "missionScalar"}}, {__index={}}, string.char(77,85,119,83,110,77,105)
	for k,v in pairs(sReg.__index) do sRegRev.__index[v] = k end
	for i, c in ("01234qwertyuiopasdfghjklzxcvbnm5678QWERTYUIOPASDFGHJKLZXCVBNM9"):gmatch("()(.)") do sigT[i-1], sigT[c], sigN = c, i-1, i end

	local function checksum(s)
		local h = (134217689 * #s) % 17592186044399
		for i=1,#s,4 do
			local a, b, c, d = s:match("(.?)(.?)(.?)(.?)", i)
			a, b, c, d = sigT[a], (sigT[b] or 0) * sigN, (sigT[c] or 0) * sigN^2, (sigT[d] or 0) * sigN^3
			h = (h * 211 + a + b + c + d) % 17592186044399
		end
		return h % 3298534883309
	end
	local function nenc(v, b, rest)
		if b == 0 then return v == 0 and rest or error("numeric overflow") end
		local v1 = v % sigN
		local v2 = (v - v1) / sigN
		return nenc(v2, b - 1, sigT[v1] .. (rest or ""))
	end
	local function cenc(c)
		local b, m = c:byte(), sigN-1
		return sigT[(b - b % m) / m] .. sigT[b % m]
	end
	local function venc(v, t, reg)
		if reg[v] then
			table.insert(t, sigT[1] .. sigT[reg[v]])
		elseif type(v) == "table" then
			local n = math.min(sigN-1, #v)
			for i=n,1,-1 do venc(v[i], t, reg) end
			table.insert(t, sigT[3] .. sigT[n])
			for k,v2 in pairs(v) do
				if not (type(k) == "number" and k >= 1 and k <= n and k % 1 == 0) then
					venc(v2, t, reg)
					venc(k, t, reg)
					table.insert(t, sigT[4])
				end
			end
		elseif type(v) == "number" then
			if v % 1 ~= 0 then error("non-integer value") end
			if v < -1000000 then error("integer underflow") end
			table.insert(t, sigT[5] .. nenc(v + 1000000, 4))
		elseif type(v) == "string" then
			table.insert(t, sigT[6] .. v:gsub("[^a-zA-Z5-8]", cenc) .. "9")
		else
			table.insert(t, sigT[1] .. ((v == true and sigT[1]) or (v == nil and sigT[0]) or sigT[2]))
		end
		return t
	end
	local function tenc(t, rt)
		local u, ua = {}, {}
		for i=1,#t do
			local k = t[i]
			if #k < 4 then
			elseif u[k] then
				u[k] = u[k] + 1
			else
				ua[#ua+1], u[k] = k, 1
			end
		end
		local freeSlot = 5
		while rt[freeSlot] ~= nil do
			freeSlot = freeSlot + 1
		end
		table.sort(ua, function(a, b)
			return (#a-2)*(u[a]-1) > (#b-2)*(u[b]-1)
		end)
		for i=math.max(1, sigN-freeSlot+1), #ua do
			u[ua[i]], ua[i] = nil
		end
		for i=1,#t do
			local uk = u[t[i]]
			if uk == nil then
			elseif type(uk) == "string" then
				t[i] = uk
			elseif freeSlot < sigN and uk > 1 then
				u[t[i]], t[i] = sigT[1] .. sigT[freeSlot], t[i] .. sigT[2] .. sigT[freeSlot]
				freeSlot = freeSlot + 1
			end
		end
		return t
	end

	local ops = {"local ops, sigT, sigN, s, r, pri = {}, ...\nlocal cdec, ndec = function(c, l) return string.char(sigT[c]*(sigN-1) + sigT[l]) end, function(s) local r = 0 for i=1,#s do r = r * sigN + sigT[s:sub(i,i)] end return r end",
		"s[d+1], d, pos = r[sigT[pri:sub(pos,pos)]], d + 1, pos + 1",
		"r[sigT[pri:sub(pos,pos)]], pos = s[d], pos + 1",
		"local t, n = {}, sigT[pri:sub(pos,pos)]\nfor i=1,n do t[i] = s[d-i+1] end\ns[d - n + 1], d, pos = t, d - n + 1, pos + 1",
		"s[d-2][s[d]], d = s[d-1], d - 2",
		"s[d+1], d, pos = ndec(pri:sub(pos, pos + 3)) - 1000000, d + 1, pos + 4",
		"d, s[d+1], pos = d + 1, pri:match('^(.-)9()', pos)\ns[d] = s[d]:gsub('([0-4])(.)', cdec)",
		"s[d-1], d = s[d-1]+s[d], d - 1",
		"s[d-1], d = s[d-1]*s[d], d - 1",
		"s[d-1], d = s[d-1]/s[d], d - 1",
		"function ops.bind(...) s, r, pri = ... end\nreturn ops"
	}
	for i=2,#ops-1 do
		ops[i] = ("ops[%q] = function(d, pos)\n %s\n return d, pos\nend"):format(sigT[i-1], ops[i])
	end
	ops = loadstring(table.concat(ops, "\n"))(sigT, sigN)

	function serialize(t)
		local rt = setmetatable({}, sRegRev)
		local payload = table.concat(tenc(venc(t, {}, rt), sReg.__index), "")
		return ((sign .. nenc(checksum(sign .. payload), 7) .. payload))
	end
end
local function GetCompletedMissionInfo(mid)
	local ma = C_Garrison.GetCompleteMissions(123)
	for i=1,#ma do
		if ma[i].missionID == mid then
			return ma[i]
		end
	end
end

local LR_MissionID, LR_Novelty

local generateCheckpoints do
	local hex = {}
	for i=0,12 do hex[i] = ("%x"):format(i) end
	local function checkpointBoard(b)
		local r = ""
		for i=0,12 do
			local lh = b[i] or 0
			if lh > 0 then
				r = (r ~= "" and r .. "_" or "") .. hex[i] .. ":" .. lh
			end
		end
		return r
	end
	function generateCheckpoints(cr)
		local eei = cr.environment
		local envs = eei and eei.autoCombatSpellInfo
		local checkpoints, b = {}, {[-1]=envs and true or nil}
		for i=1,#cr.encounters do
			local e = cr.encounters[i]
			b[e.boardIndex] = e.health
		end
		for _, v in pairs(cr.followers) do
			b[v.boardIndex] = v.health
		end
		checkpoints[0] = checkpointBoard(b)
		for t=1,#cr.log do
			local e = cr.log[t].events
			for i=1,#e do
				local ti = e[i].targetInfo
				local cidx = e[i].casterBoardIndex
				if not b[cidx] then
					return false
				end
				for i=1,ti and #ti or 0 do
					local tii = ti[i]
					local tidx = tii.boardIndex
					if not b[tidx] then
						return false
					elseif tii.newHealth then
						b[tidx] = tii.newHealth
					end
				end
			end
			checkpoints[t] = checkpointBoard(b)
		end
		if checkpoints[#checkpoints] == checkpoints[#checkpoints-1] then
			checkpoints[#checkpoints] = nil
		end
		return true, checkpoints
	end
end
local function checkpointMatch(truth, sim)
	if truth == sim then return true end
	for u, top, range in sim:gmatch("(.:)(%d+)%-?(%d*)") do
		local rh = truth:match(u .. "(%d+)")
		if not rh then return false end
		rh = rh + 0
		top, range = top + 0, range ~= "" and range+0 or 0
		if not (rh <= top and rh >= (top-range)) then
			return false
		end
	end
	for u in truth:gmatch("(.:)") do
		if not sim:match(u .. "%d") then
			return false
		end
	end
	return true
end
local function checkSim(cr, checkpoints)
	local eei = cr.environment
	local envs = eei and eei.autoCombatSpellInfo
	local sim = T.VSim:New(cr.followers, cr.encounters, envs, cr.missionID, cr.missionScalar, 0)
	sim:AddFightLogOracles(cr.log)
	sim:Run()
	local outcome = (not sim.won) == (not cr.winner)
	if #checkpoints ~= #sim.checkpoints then
		return false, outcome
	end
	for i=0,#checkpoints do
		if not checkpointMatch(checkpoints[i], sim.checkpoints[i]) then
			return false, outcome
		end
	end
	return true, outcome
end
local function isNovelLog(cr, checkpoints)
	local ok, ret, ret2 = pcall(checkSim, cr, checkpoints)
	return not (ok and ret), ok, ret2
end
local function findReportSlot(logs, st, novel)
	local nc, oc, nt, ot, ni, oi = 0, 0
	for i=1,#logs do
		local li = logs[i]
		if li[1] == st then
			return i
		elseif li.novel then
			nc = nc + 1
			if nc == 1 or nt > li.ts then
				nt, ni = li.ts, i
			end
		else
			oc = oc + 1
			if oc == 1 or ot > li.ts then
				ot, oi = li.ts, i
			end
		end
	end
	if nc + oc < 99 then
		return #logs+1
	elseif novel then
		return oc > 49 and oi or ni
	else
		return nc > 50 and ni or oi
	end
end
function EV:GARRISON_MISSION_COMPLETE_RESPONSE(mid, _canCom, _suc, _bonusOK, _followerDeaths, autoCombatResult)
	if not (autoCombatResult and autoCombatResult.combatLog and mid and C_Garrison.GetFollowerTypeByMissionID(mid) == 123) then return end
	local cr = {
		log=autoCombatResult.combatLog, winner=autoCombatResult.winner, missionID=mid,
		meta={lc=GetLocale(), ts=math.floor(GetServerTime()/86400), cb=select(2,GetBuildInfo()), dv=1},
	}
	cr.encounters = C_Garrison.GetMissionCompleteEncounters(mid)
	cr.environment = C_Garrison.GetAutoMissionEnvironmentEffect(mid)
	for _, v in pairs(cr.encounters) do
		v.scale, v.portraitFileDataID, v.mechanics, v.height, v.displayID = nil
		if v.autoCombatSpells then
			for _, s in pairs(v.autoCombatSpells) do
				s.previewMask, s.schoolMask, s.icon, s.spellTutorialFlag = nil
			end
		end
	end
	if cr.environment and cr.environment.autoCombatSpellInfo then
		local s = cr.environment.autoCombatSpellInfo
		s.previewMask, s.schoolMask, s.icon, s.spellTutorialFlag = nil
	end
	
	local fm, mi = {}, GetCompletedMissionInfo(mid)
	for i=1,#mi.followers do
		local fid = mi.followers[i]
		local mci = C_Garrison.GetFollowerMissionCompleteInfo(fid)
		local stat = C_Garrison.GetFollowerAutoCombatStats(fid)
		local spa = C_Garrison.GetFollowerAutoCombatSpells(fid, mci.level)
		for _, s in pairs(spa) do
			s.previewMask, s.schoolMask, s.icon, s.spellTutorialFlag = nil
		end
		fm[fid] = {
			name=mci.name, role=mci.role, level=mci.level,
			boardIndex=mci.boardIndex, health=stat.currentHealth, maxHealth=stat.maxHealth, attack=stat.attack,
			spells=spa,
		}
	end
	cr.followers = fm
	cr.missionScalar = mi.missionScalar
	cr.missionName = mi.name
	local ok, checkpoints = generateCheckpoints(cr)
	if ok then
		local st, novel, nok, om = serialize(cr), isNovelLog(cr, checkpoints)
		VP_MissionReports = VP_MissionReports or {}
		VP_MissionReports[findReportSlot(VP_MissionReports, st, novel)] = {st, ts=cr.meta.ts, novel=novel}
		LR_MissionID, LR_Novelty = mid, nok and (novel and (om and 2 or 3) or 1) or 0
		EV("I_STORED_LOG_UPDATE")
	end
end
function EV:I_RESET_STORED_LOGS()
	VP_MissionReports = nil
	EV("I_STORED_LOG_UPDATE")
end
function T.GetMissionReportCount()
	return type(VP_MissionReports) == "table" and #VP_MissionReports or 0
end
function T.ExportMissionReports()
	local s = ""
	for i=1,VP_MissionReports and #VP_MissionReports or 0 do
		s = (i > 1 and s .. "::" or "") .. VP_MissionReports[i][1]
	end
	return (s:gsub(("."):rep(72), "%0 "):gsub(" ?$", ".", 1))
end
function T.GetMissionReportInfo(mid)
	if mid == LR_MissionID then
		return LR_Novelty
	end
end
