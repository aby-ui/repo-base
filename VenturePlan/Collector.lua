local _, T = ...
local EV = T.Evie
local LibParse = LibStub("LibParse");

local function serialize(data)
	return LibParse:JSONEncode(data)
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
	if nc + oc < 20 then
		return #logs+1
	elseif novel then
		return oc > 19 and oi or ni
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
		local novel, nok, om = isNovelLog(cr, checkpoints)
		cr.predictionCorrect = not novel
		cr.differentOutcome = not om
		cr.addonVersion = GetAddOnMetadata("VenturePlan", "Version")
		local st = serialize(cr)
		--if st == nil then return end;
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
	local missionReportString = ""
	for i=1,VP_MissionReports and #VP_MissionReports or 0 do
		missionReportString = (i > 1 and missionReportString .. "\n" or "") .. VP_MissionReports[i][1]
	end
	return missionReportString
end
function T.GetMissionReportInfo(mid)
	if mid == LR_MissionID then
		return LR_Novelty
	end
end