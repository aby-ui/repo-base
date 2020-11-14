-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

local RSWaypoints = private.NewLib("RareScannerWaypoints")

-- RareScanner database libraries
local RSGeneralDB = private.ImportLib("RareScannerGeneralDB")
local RSConfigDB = private.ImportLib("RareScannerConfigDB")

---============================================================================
-- Ingame waypoints
---============================================================================

local function AddWaypoint(entityID)
	C_Map.ClearUserWaypoint();

	local entityInfo = RSGeneralDB.GetAlreadyFoundEntity(entityID)
	if (entityInfo and entityInfo.coordX and entityInfo.coordY) then
		local uiMapPoint = UiMapPoint.CreateFromCoordinates(entityInfo.mapID, entityInfo.coordX, entityInfo.coordY);
		C_Map.SetUserWaypoint(uiMapPoint);
		C_SuperTrack.SetSuperTrackedUserWaypoint(true);
	end
end

function RSWaypoints.AddWorldMapWaypoint(mapID, x, y)
	if (RSConfigDB.IsAddingWorldMapIngameWaypoints() and mapID and x and y) then
		C_Map.ClearUserWaypoint();
		
		local uiMapPoint = UiMapPoint.CreateFromCoordinates(mapID, x, y);
		C_Map.SetUserWaypoint(uiMapPoint);
		C_SuperTrack.SetSuperTrackedUserWaypoint(true);
	end
end

function RSWaypoints.AddWaypoint(entityID)
	if (entityID and RSConfigDB.IsWaypointsSupportEnabled()) then
		AddWaypoint(entityID)
	end
end

function RSWaypoints.AddWaypointFromVignette(vignetteInfo, manuallyFired)
	-- If not automatic waypoints
	if (not manuallyFired and not RSConfigDB.IsAddingWaypointsAutomatically()) then
		return
	end

	-- Extract info from vignnette
	local _, _, _, _, _, entityID, _ = strsplit("-", vignetteInfo.objectGUID);
	if (entityID) then
		entityID = tonumber(entityID)
	else
		return
	end

	-- Adds the waypoint
	AddWaypoint(entityID)
end
