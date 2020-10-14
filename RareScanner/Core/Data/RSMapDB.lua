-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

local RSMapDB = private.NewLib("RareScannerMapDB")

-- RareScanner internal libraries
local RSLogger = private.ImportLib("RareScannerLogger")
local RSUtils = private.ImportLib("RareScannerUtils")
local RSConstants = private.ImportLib("RareScannerConstants")


---============================================================================
-- Auxiliar functions
---============================================================================

local function BelongsToZone(entityID, mapID, zoneIds, infoAlreadyFound, alreadyChecked)
  if (not entityID or not mapID or not zoneIds) then
    return false
  end
  
  -- Tries to find in main zone
  local zone = zoneIds[mapID]
  
  -- Tries to find in sub zone
  if (not zone) then
    for mainZoneID, subZonesIDs in pairs (private.SUBZONES_IDS) do
      if (RSUtils.Contains(subZonesIDs, mapID)) then
        zone = zoneIds[mainZoneID]
        break
      end
    end
  end
  
  if (zone) then
    if (RSUtils.Contains(zone, RSConstants.ALL_ZONES) or RSUtils.Contains(zone, C_Map.GetMapArtID(mapID))) then
      return true
    end
  elseif (not alreadyChecked) then
    if (infoAlreadyFound) then
      return BelongsToZone(entityID, infoAlreadyFound.mapID, zoneIds, infoAlreadyFound, true)
    end
  end
  
  return false
end

---============================================================================
-- Continents database
---============================================================================

function RSMapDB.GetContinentMapIDs()
	return private.CONTINENT_ZONE_IDS
end

function RSMapDB.IsMapInCurrentExpansion(mapID)
	if (not mapID) then
		return false
	end
	
	-- check if the map is in the continent
	for _, continentInfo in pairs (RSMapDB.GetContinentMapIDs()) do
		local mapInContinent = RSUtils.Contains(continentInfo.zones, mapID)
		
		-- check if the mapID is in a subzone into the continent
		if (not mapInContinent) then
			for _, parentMapID in ipairs (continentInfo.zones) do
				if (RSMapDB.IsMapInParentMap(parentMapID, mapID)) then
					mapInContinent = true
					break
				end
			end
		end
		
		if (mapInContinent) then
			if (not continentInfo.current) then
				return false
			elseif (RSUtils.Contains(continentInfo.current, RSConstants.ALL_ZONES) or RSUtils.Contains(continentInfo.current, mapID)) then
				return true
			end
		end
	end
	
	return false;
end

---============================================================================
-- Subzones database
---============================================================================

function RSMapDB.IsMapInParentMap(parentMapID, subzoneMapID)
	if (parentMapID and subzoneMapID) then
		local subzones = private.SUBZONES_IDS[parentMapID]
		if (subzones and RSUtils.Contains(subzones, subzoneMapID)) then
			return true;
		end
	end
	
	return false
end

---============================================================================
-- Warfronts state areas database
---============================================================================

function RSMapDB.GetWarfrontKillZoneIDs()
  return private.RESETABLE_WARFRONT_KILLS_ZONE_IDS
end

function RSMapDB.GeWarfrontKillZoneArtID(mapID)
  if (mapID) then
    return private.RESETABLE_WARFRONT_KILLS_ZONE_IDS[mapID]
  end
  
  return nil
end

function RSMapDB.IsEntityInWarfrontZone(entityID, mapID, infoAlreadyFound, alreadyChecked)
  return BelongsToZone(entityID, mapID, RSMapDB.GetWarfrontKillZoneIDs(), infoAlreadyFound, alreadyChecked)
end

---============================================================================
-- Permanent state areas database
---============================================================================

function RSMapDB.GetPermanentKillZoneIDs()
  return private.PERMANENT_KILLS_ZONE_IDS
end

function RSMapDB.GetPermanentKillZoneArtID(mapID)
  if (mapID) then
    return private.PERMANENT_KILLS_ZONE_IDS[mapID]
  end
  
  return nil
end

function RSMapDB.IsEntityInPermanentZone(entityID, mapID, infoAlreadyFound, alreadyChecked)
  return BelongsToZone(entityID, mapID, RSMapDB.GetPermanentKillZoneIDs(), infoAlreadyFound, alreadyChecked)
end

---============================================================================
-- Reseteable state areas database
---============================================================================

function RSMapDB.GetReseteableKillZoneIDs()
  return private.RESETABLE_KILLS_ZONE_IDS
end

function RSMapDB.GetReseteableKillZoneArtID(mapID)
  if (mapID) then
    return private.RESETABLE_KILLS_ZONE_IDS[mapID]
  end
  
  return nil
end

function RSMapDB.IsEntityInReseteableZone(entityID, mapID, infoAlreadyFound, alreadyChecked)
  return BelongsToZone(entityID, mapID, RSMapDB.GetReseteableKillZoneIDs(), infoAlreadyFound, alreadyChecked)
end

function RSMapDB.IsReseteableKillMapID(mapID, artID)
	if (mapID) then
		local reseteableArtIDs = RSMapDB.GetReseteableKillZoneArtID(mapID)
		if (reseteableArtIDs and (RSUtils.Contains(reseteableArtIDs, RSConstants.ALL_ZONES) or RSUtils.Contains(reseteableArtIDs, artID))) then
			return true;
		end
	end
	
	return false
end

---============================================================================
-- Zones without vignette
---============================================================================
--
function RSMapDB.IsZoneWithoutVignette(mapID)
  if (mapID and private.ZONES_WITHOUT_VIGNETTE[mapID]) then
    return RSUtils.Contains(private.ZONES_WITHOUT_VIGNETTE[mapID], C_Map.GetMapArtID(mapID))
  end
  
  return false
end

