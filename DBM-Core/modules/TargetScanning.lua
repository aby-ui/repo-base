local _, private = ...

local twipe = table.wipe
local UnitExists, UnitPlayerOrPetInRaid, UnitGUID =
	UnitExists, UnitPlayerOrPetInRaid, UnitGUID

local module = private:NewModule("TargetScanning")

--Traditional loop scanning method tables
local targetScanCount = {}
local bossuIdCache = {}
--UNIT_TARGET scanning method table
local unitScanCount = 0
local unitMonitor = {}

function module:OnModuleEnd()
	twipe(targetScanCount)
	twipe(bossuIdCache)
	unitScanCount = 0
	twipe(unitMonitor)
end

do
	local L = DBM_CORE_L
	local bossTargetuIds = {
		"boss1", "boss2", "boss3", "boss4", "boss5", "focus", "target"
	}

	local function getBossTarget(guid, scanOnlyBoss)
		local name, uid, bossuid
		local cacheuid = bossuIdCache[guid] or "boss1"
		if UnitGUID(cacheuid) == guid then
			bossuid = cacheuid
			name = DBM:GetUnitFullName(cacheuid.."target")
			uid = cacheuid.."target"
			bossuIdCache[guid] = bossuid
		end
		if name then return name, uid, bossuid end
		for _, uId in ipairs(bossTargetuIds) do
			if UnitGUID(uId) == guid then
				bossuid = uId
				name = DBM:GetUnitFullName(uId.."target")
				uid = uId.."target"
				bossuIdCache[guid] = bossuid
				break
			end
		end
		if name or scanOnlyBoss then return name, uid, bossuid end
		-- Now lets check nameplates
		for i = 1, 40 do
			if UnitGUID("nameplate"..i) == guid then
				bossuid = "nameplate"..i
				name = DBM:GetUnitFullName("nameplate"..i.."target")
				uid = "nameplate"..i.."target"
				bossuIdCache[guid] = bossuid
				break
			end
		end
		if name then return name, uid, bossuid end
		-- failed to detect from default uIds, scan all group members's target.
		if IsInRaid() then
			for i = 1, GetNumGroupMembers() do
				if UnitGUID("raid"..i.."target") == guid then
					bossuid = "raid"..i.."target"
					name = DBM:GetUnitFullName("raid"..i.."targettarget")
					uid = "raid"..i.."targettarget"
					bossuIdCache[guid] = bossuid
					break
				end
			end
		elseif IsInGroup() then
			for i = 1, GetNumSubgroupMembers() do
				if UnitGUID("party"..i.."target") == guid then
					bossuid = "party"..i.."target"
					name = DBM:GetUnitFullName("party"..i.."targettarget")
					uid = "party"..i.."targettarget"
					bossuIdCache[guid] = bossuid
					break
				end
			end
		end
		return name, uid, bossuid
	end

	function module:GetBossTarget(mod, cidOrGuid, scanOnlyBoss)
		local name, uid, bossuid
		DBM:Debug("GetBossTarget firing for :"..tostring(mod).." "..tostring(cidOrGuid).." "..tostring(scanOnlyBoss), 3)
		if type(cidOrGuid) == "number" then--CID passed, slower and slighty more hacky scan
			cidOrGuid = cidOrGuid or mod.creatureId
			local cacheuid = bossuIdCache[cidOrGuid] or "boss1"
			if mod:GetUnitCreatureId(cacheuid) == cidOrGuid then
				bossuIdCache[cidOrGuid] = cacheuid
				bossuIdCache[UnitGUID(cacheuid)] = cacheuid
				name, uid, bossuid = getBossTarget(UnitGUID(cacheuid), scanOnlyBoss)
			else
				local found = false
				for _, uId in ipairs(bossTargetuIds) do
					if mod:GetUnitCreatureId(uId) == cidOrGuid then
						found = true
						bossuIdCache[cidOrGuid] = uId
						bossuIdCache[UnitGUID(uId)] = uId
						name, uid, bossuid = getBossTarget(UnitGUID(uId), scanOnlyBoss)
						break
					end
				end
				if not found and not scanOnlyBoss then
					if IsInRaid() then
						for i = 1, GetNumGroupMembers() do
							if mod:GetUnitCreatureId("raid"..i.."target") == cidOrGuid then
								bossuIdCache[cidOrGuid] = "raid"..i.."target"
								bossuIdCache[UnitGUID("raid"..i.."target")] = "raid"..i.."target"
								name, uid, bossuid = getBossTarget(UnitGUID("raid"..i.."target"))
								break
							end
						end
					elseif IsInGroup() then
						for i = 1, GetNumSubgroupMembers() do
							if mod:GetUnitCreatureId("party"..i.."target") == cidOrGuid then
								bossuIdCache[cidOrGuid] = "party"..i.."target"
								bossuIdCache[UnitGUID("party"..i.."target")] = "party"..i.."target"
								name, uid, bossuid = getBossTarget(UnitGUID("party"..i.."target"))
								break
							end
						end
					end
				end
			end
		else
			name, uid, bossuid = getBossTarget(cidOrGuid, scanOnlyBoss)
		end
		if uid then
			local cid = mod:GetUnitCreatureId(uid)
			if cid == 24207 or cid == 80258 or cid == 87519 then--filter shitter units like army of the dead that would otherwise throw off the target scan
				return nil, nil, nil
			end
		end
		return name, uid, bossuid
	end


	function module:BossTargetScannerAbort(mod, cidOrGuid, returnFunc)
		targetScanCount[cidOrGuid] = nil--Reset count for later use.
		mod:UnscheduleMethod("BossTargetScanner", cidOrGuid, returnFunc)
		DBM:Debug("Boss target scan for "..cidOrGuid.." should be aborting.", 2)
	end

	function module:BossTargetScanner(mod, cidOrGuid, returnFunc, scanInterval, scanTimes, scanOnlyBoss, isEnemyScan, isFinalScan, targetFilter, tankFilter, onlyPlayers)
		--Increase scan count
		cidOrGuid = cidOrGuid or mod.creatureId
		if not cidOrGuid then return end
		if not targetScanCount[cidOrGuid] then
			targetScanCount[cidOrGuid] = 0
			DBM:Debug("Boss target scan started for "..cidOrGuid, 2)
		end
		targetScanCount[cidOrGuid] = targetScanCount[cidOrGuid] + 1
		--Set default values
		scanInterval = scanInterval or 0.05
		scanTimes = scanTimes or 16
		local targetname, targetuid, bossuid = self:GetBossTarget(mod, cidOrGuid, scanOnlyBoss)
		DBM:Debug("Boss target scan "..targetScanCount[cidOrGuid].." of "..scanTimes..", found target "..(targetname or "nil").." using "..(bossuid or "nil"), 3)--Doesn't hurt to keep this, as level 3
		--Do scan
		if targetname and targetname ~= L.UNKNOWN and (not targetFilter or (targetFilter and targetFilter ~= targetname)) then
			if not IsInGroup() then scanTimes = 1 end--Solo, no reason to keep scanning, give faster warning. But only if first scan is actually a valid target, which is why i have this check HERE
			if (isEnemyScan and UnitIsFriend("player", targetuid) or (onlyPlayers and not UnitIsPlayer("player", targetuid)) or mod:IsTanking(targetuid, bossuid)) and not isFinalScan then--On player scan, ignore tanks. On enemy scan, ignore friendly player. On Only player, ignore npcs and pets
				if targetScanCount[cidOrGuid] < scanTimes then--Make sure no infinite loop.
					mod:ScheduleMethod(scanInterval, "BossTargetScanner", cidOrGuid, returnFunc, scanInterval, scanTimes, scanOnlyBoss, isEnemyScan, nil, targetFilter, tankFilter, onlyPlayers)--Scan multiple times to be sure it's not on something other then tank (or friend on enemy scan, or npc/pet on only person)
				else--Go final scan.
					self:BossTargetScanner(mod, cidOrGuid, returnFunc, scanInterval, scanTimes, scanOnlyBoss, isEnemyScan, true, targetFilter, tankFilter, onlyPlayers)
				end
			else--Scan success. (or failed to detect right target.) But some spells can be used on tanks, anyway warns tank if player scan. (enemy scan block it)
				targetScanCount[cidOrGuid] = nil--Reset count for later use.
				mod:UnscheduleMethod("BossTargetScanner", cidOrGuid, returnFunc)--Unschedule all checks just to be sure none are running, we are done.
				if (tankFilter and mod:IsTanking(targetuid, bossuid)) or (isFinalScan and isEnemyScan) or onlyPlayers and not UnitIsPlayer("player", targetuid) then return end--If enemyScan and playerDetected, return nothing
				local scanningTime = (targetScanCount[cidOrGuid] or 1) * scanInterval
				mod[returnFunc](mod, targetname, targetuid, bossuid, scanningTime)--Return results to warning function with all variables.
				DBM:Debug("BossTargetScanner has ended for "..cidOrGuid, 2)
			end
		else--target was nil, lets schedule a rescan here too.
			if targetScanCount[cidOrGuid] < scanTimes then--Make sure not to infinite loop here as well.
				mod:ScheduleMethod(scanInterval, "BossTargetScanner", cidOrGuid, returnFunc, scanInterval, scanTimes, scanOnlyBoss, isEnemyScan, nil, targetFilter, tankFilter, onlyPlayers)
			else
				targetScanCount[cidOrGuid] = nil--Reset count for later use.
				mod:UnscheduleMethod("BossTargetScanner", cidOrGuid, returnFunc)--Unschedule all checks just to be sure none are running, we are done.
			end
		end
	end
end

do
	--UNIT_TARGET Target scanning method
	local eventsRegistered = false
	function module:UNIT_TARGET_UNFILTERED(uId)
		--Active BossUnitTargetScanner
		if unitMonitor[uId] and UnitExists(uId.."target") and UnitPlayerOrPetInRaid(uId.."target") then
			DBM:Debug("unitMonitor for this unit exists, target exists in group", 2)
			local modId, returnFunc = unitMonitor[uId].modid, unitMonitor[uId].returnFunc
			DBM:Debug("unitMonitor: "..modId..", "..uId..", "..returnFunc, 2)
			if not unitMonitor[uId].allowTank then
				local tanking, status = UnitDetailedThreatSituation(uId, uId.."target")--Tanking may return 0 if npc is temporarily looking at an NPC (IE fracture) but status will still be 3 on true tank
				if tanking or (status == 3) then
					DBM:Debug("unitMonitor ending for unit without 'allowTank', ignoring target", 2)
					return
				end
			end
			local mod = DBM:GetModByName(modId)--The whole reason we store modId in unitMonitor,
			DBM:Debug("unitMonitor success for this unit, a valid target for returnFunc", 2)
			mod[returnFunc](mod, DBM:GetUnitFullName(uId.."target"), uId.."target", uId)--Return results to warning function with all variables.
			unitMonitor[uId] = nil
			unitScanCount = unitScanCount - 1
		end
		if unitScanCount == 0 then--Out of scans
			eventsRegistered = false
			self:UnregisterShortTermEvents()
			DBM:Debug("All target scans complete, unregistering events", 2)
		end
	end

	function module:BossUnitTargetScannerAbort(mod, uId)
		if not uId then--Not called with unit, means mod requested to clear all used units
			DBM:Debug("BossUnitTargetScannerAbort called without unit, clearing all unitMonitor units", 2)
			twipe(unitMonitor)
			unitScanCount = 0
			return
		end
		--If tank is allowed, return current target when scan ends no matter what.
		if unitMonitor[uId] and unitMonitor[uId].allowTank and UnitExists(uId.."target") and UnitPlayerOrPetInRaid(uId.."target") then
			DBM:Debug("unitMonitor unit exists, allowTank target exists", 2)
			local modId, returnFunc = unitMonitor[uId].modid, unitMonitor[uId].returnFunc
			DBM:Debug("unitMonitor: "..modId..", "..uId..", "..returnFunc, 2)
			DBM:Debug("unitMonitor found a target that probably is a tank", 2)
			mod[returnFunc](mod, DBM:GetUnitFullName(uId.."target"), uId.."target", uId)--Return results to warning function with all variables.
		end
		unitMonitor[uId] = nil
		unitScanCount = unitScanCount - 1
		DBM:Debug("Boss unit target scan should be aborting for "..uId, 2)
	end

	function module:BossUnitTargetScanner(mod, uId, returnFunc, scanTime, allowTank)
		--UNIT_TARGET event monitor target scanner. Will instantly detect a target change of a registered Unit
		--If target change occurs before this method is called (or if boss doesn't change target because cast ends up actually being on the tank, target scan will fail completely
		--If allowTank is passed, it basically tells this scanner to return current target of unitId at time of failure/abort when scanTime is complete
		unitMonitor[uId] = {}
		unitScanCount = unitScanCount + 1
		unitMonitor[uId].modid, unitMonitor[uId].returnFunc, unitMonitor[uId].allowTank = mod.id, returnFunc, allowTank
		mod:ScheduleMethod(scanTime or 1.5, "BossUnitTargetScannerAbort", uId)--In case of BossUnitTargetScanner firing too late, and boss already having changed target before monitor started, it needs to abort after x seconds
		if not eventsRegistered then
			eventsRegistered = true
			self:RegisterShortTermEvents("UNIT_TARGET_UNFILTERED")
			DBM:Debug("Registering UNIT_TARGET event for BossUnitTargetScanner", 2)
		end
	end
end

do
	local repeatedScanEnabled = {}
	--infinite scanner. so use this carefully.
	local function repeatedScanner(mod, cidOrGuid, returnFunc, scanInterval, scanOnlyBoss, includeTank)
		if repeatedScanEnabled[returnFunc] then
			cidOrGuid = cidOrGuid or mod.creatureId
			scanInterval = scanInterval or 0.1
			local targetname, targetuid, bossuid = module:GetBossTarget(mod, cidOrGuid, scanOnlyBoss)
			if targetname and (includeTank or not mod:IsTanking(targetuid, bossuid)) then
				mod[returnFunc](mod, targetname, targetuid, bossuid)
			end
			mod:Schedule(scanInterval, repeatedScanner, mod, cidOrGuid, returnFunc, scanInterval, scanOnlyBoss, includeTank)
		end
	end

	function module:StartRepeatedScan(mod, cidOrGuid, returnFunc, scanInterval, scanOnlyBoss, includeTank)
		repeatedScanEnabled[returnFunc] = true
		repeatedScanner(mod, cidOrGuid, returnFunc, scanInterval, scanOnlyBoss, includeTank)
	end

	function module:StopRepeatedScan(returnFunc)
		repeatedScanEnabled[returnFunc] = nil
	end
end
