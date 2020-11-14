-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

local RSTomtom = private.NewLib("RareScannerTomtom")

-- RareScanner database libraries
local RSGeneralDB = private.ImportLib("RareScannerGeneralDB")
local RSConfigDB = private.ImportLib("RareScannerConfigDB")

---============================================================================
-- Tomtom integration
---============================================================================

local tomtom_waypoint

function RSTomtom.AddWorldMapTomtomWaypoint(mapID, x, y, name)
	if (TomTom and RSConfigDB.IsAddingWorldMapTomtomWaypoints() and mapID and x and y and name) then
		if (tomtom_waypoint) then
			TomTom:RemoveWaypoint(tomtom_waypoint)
		end
		
		tomtom_waypoint = TomTom:AddWaypoint(mapID, x, y, {
			title = name,
			persistent = false,
			minimap = false,
			world = false,
			cleardistance = 25
		})
	end
end

function RSTomtom.AddTomtomWaypoint(npcID, name)
	if (TomTom and RSConfigDB.IsTomtomSupportEnabled() and npcID and name) then
		if (tomtom_waypoint) then
			TomTom:RemoveWaypoint(tomtom_waypoint)
		end
		local npcInfo = RSGeneralDB.GetAlreadyFoundEntity(npcID)
		if (npcInfo and npcInfo.coordX and npcInfo.coordY) then
			tomtom_waypoint = TomTom:AddWaypoint(npcInfo.mapID, tonumber(npcInfo.coordX), tonumber(npcInfo.coordY), {
				title = name,
				persistent = false,
				minimap = false,
				world = false,
				cleardistance = 25
			})
		end
	end
end

function RSTomtom.AddTomtomWaypointFromVignette(vignetteInfo, manuallyFired)
	-- If not automatic waypoints
	if (not manuallyFired and not RSConfigDB.IsAddingTomtomWaypointsAutomatically()) then
		return
	end

	-- Extract info from vignnette
	local _, _, _, _, _, npcID, _ = strsplit("-", vignetteInfo.objectGUID);
	if (npcID) then
		npcID = tonumber(npcID)
	else
		return
	end

	-- Adds the waypoint
	RSTomtom.AddTomtomWaypoint(npcID, vignetteInfo.name)
end
