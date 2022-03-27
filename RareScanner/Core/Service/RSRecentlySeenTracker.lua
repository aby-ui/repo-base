-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

local RSRecentlySeenTracker = private.NewLib("RareScannerRecentlySeenTracker")

-- RareScanner database libraries
local RSConfigDB = private.ImportLib("RareScannerConfigDB")
local RSGeneralDB = private.ImportLib("RareScannerGeneralDB")

-- RareScanner internal libraries
local RSConstants = private.ImportLib("RareScannerConstants")
local RSLogger = private.ImportLib("RareScannerLogger")
local RSUtils = private.ImportLib("RareScannerUtils")
local RSTimeUtils = private.ImportLib("RareScannerTimeUtils")

-- Timers
local RESET_RECENTLY_SEEN_TIMER

---============================================================================
-- Tracks notifications
---============================================================================

local recently_seen_entities = {}
local VIGNETTE_ID_SEPARATOR = "-"

local function InitResetRecentlySeenTimer()
	if (RESET_RECENTLY_SEEN_TIMER) then
		return
	end
	
	RESET_RECENTLY_SEEN_TIMER = C_Timer.NewTicker(RSConstants.CHECK_RESET_RECENTLY_SEEN_TMER, function()
		for entityID, entityInfo in pairs (recently_seen_entities) do
			local currenTime = time()
			
			-- If its an entity that spawns only in one spot
			if (type(entityInfo) == "number") then
				if (currenTime > (entityInfo + RSConstants.RECENTLY_SEEN_RESET_TIMER)) then
					RSLogger:PrintDebugMessage(string.format("ResetRecentlySeen[%s] (mono)", entityID))
					recently_seen_entities[entityID] = nil
					RSGeneralDB.DeleteRecentlySeen(entityID)
				end			
			-- If its an entity that spawns in multiple spots at the same time
			else
				for time, info in pairs (entityInfo) do
					if (currenTime > (time + RSConstants.RECENTLY_SEEN_RESET_TIMER)) then
						if (RSUtils.GetTableLength(recently_seen_entities[entityID]) == 1) then
							recently_seen_entities[entityID] = nil
							RSLogger:PrintDebugMessage(string.format("ResetRecentlySeen[%s] (multi/last)", entityID))
							RSGeneralDB.DeleteRecentlySeen(entityID)
							break;
						else
							recently_seen_entities[entityID][time] = nil
							RSLogger:PrintDebugMessage(string.format("ResetRecentlySeen[%s] (multi)", entityID))
						end
					end
				end
			end
		end
	end)
end

function RSRecentlySeenTracker.AddRecentlySeen(entityID, atlasName, isNavigating)
	if (isNavigating) then
		return
	end
	
	-- Initializes timer
	InitResetRecentlySeenTimer()
	
	local currentTime = time()
	
	-- If not spawning in multiple places at the same time stores only the time
	if (entityID and (RSUtils.Contains(RSConstants.NPCS_WITH_MULTIPLE_SPAWNS, entityID) or RSUtils.Contains(RSConstants.CONTAINERS_WITH_MULTIPLE_SPAWNS, entityID))) then
		-- Extracts info from internal database
		local entityInfo = RSGeneralDB.GetAlreadyFoundEntity(entityID)
		if (entityInfo) then
			if (not recently_seen_entities[entityID]) then
				recently_seen_entities[entityID] = {}
			end
			
			recently_seen_entities[entityID][currentTime] = {}
			recently_seen_entities[entityID][currentTime].x = entityInfo.coordX
			recently_seen_entities[entityID][currentTime].y = entityInfo.coordY
			recently_seen_entities[entityID][currentTime].mapID = entityInfo.mapID
			recently_seen_entities[entityID][currentTime].atlasName = atlasName
			
			RSGeneralDB.SetRecentlySeen(entityID)
			RSLogger:PrintDebugMessage(string.format("AddRecentlySeen[%s] (multi) [%s]", entityID, RSTimeUtils.TimeStampToClock(currentTime)))
		end
	-- Otherwise stores also the coordinates
	else
		recently_seen_entities[entityID] = currentTime
		RSGeneralDB.SetRecentlySeen(entityID)
		RSLogger:PrintDebugMessage(string.format("AddRecentlySeen[%s] (mono) [%s]", entityID, RSTimeUtils.TimeStampToClock(currentTime)))
	end
end

function RSRecentlySeenTracker.RemoveRecentlySeen(entityID)
	local entityInfo = recently_seen_entities[entityID]
	
	if (not entityInfo) then
		return
	end
	
	-- If its an entity that spawns only in one spot
	if (type(entityInfo) == "number") then
		RSLogger:PrintDebugMessage(string.format("RemoveRecentlySeen[%s] (mono)", entityID))
		recently_seen_entities[entityID] = nil
		RSGeneralDB.DeleteRecentlySeen(entityID)
		return
	end
	
	-- If its an entity that spawns in multiple spots at the same time
					
	-- Calculates the distance between all of them and the player
	local timeDistances = {}
	
	for time, info in pairs (entityInfo) do
		local playerMapPosition = C_Map.GetPlayerMapPosition(info.mapID, "player")
		if (playerMapPosition) then
			local x, y = playerMapPosition:GetXY()
			local distance = RSUtils.DistanceBetweenCoords(x, info.x, y, info.y)
			timeDistances[time] = distance
		end
	end
	
	-- If for whatever reason it couldnt get the players coordinates it will be empty
	if (RSUtils.GetTableLength(timeDistances) == 0) then
		return
	end
	
	-- And removes the closest to the player
	local distances = {}
	for time, distance in pairs (timeDistances) do
		table.insert(distances, distance)
	end
	
	local min = math.min(unpack(distances))
	for time, distance in pairs (timeDistances) do
		if (distance == min) then
			if (RSUtils.GetTableLength(recently_seen_entities[entityID]) == 1) then
				RSLogger:PrintDebugMessage(string.format("RemoveRecentlySeen[%s,x=%s,y=%s] (multi/last)", entityID, recently_seen_entities[entityID][time].x, recently_seen_entities[entityID][time].y))
			else
				RSLogger:PrintDebugMessage(string.format("RemoveRecentlySeen[%s,x=%s,y=%s] (multi)", entityID, recently_seen_entities[entityID][time].x, recently_seen_entities[entityID][time].y))
			end
			
			recently_seen_entities[entityID][time] = nil
			break
		end
	end
end

function RSRecentlySeenTracker.IsRecentlySeen(entityID, x, y)
	if (not entityID) then
		return false
	end
	
	-- If it isnt cached in this session check database 
	local entityInfo = recently_seen_entities[entityID]
	if (not entityInfo) then
		return RSGeneralDB.IsRecentlySeen(entityID)
	end
	
	-- If its an entity that spawns only in one spot
	if (type(entityInfo) == "number") then
		return true
	end
	
	-- If its an entity that spawns in multiple spots then check all the coordinates
	for time, info in pairs (entityInfo) do
		if (info.x == x and info.y == y) then
			return true
		end
	end

	-- Otherwise it isnt recently seen
	return false
end

function RSRecentlySeenTracker.GetAllRecentlySeenSpots()
	return recently_seen_entities
end