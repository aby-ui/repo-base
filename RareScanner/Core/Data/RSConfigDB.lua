-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

local RSConfigDB = private.NewLib("RareScannerConfigDB")

-- RareScanner database libraries
local RSNpcDB = private.ImportLib("RareScannerNpcDB")
local RSContainerDB = private.ImportLib("RareScannerContainerDB")
local RSEventDB = private.ImportLib("RareScannerEventDB")

-- RareScanner internal libraries
local RSConstants = private.ImportLib("RareScannerConstants")
local RSLogger = private.ImportLib("RareScannerLogger")


---============================================================================
-- Timers options
---============================================================================

function RSConfigDB.GetAutoHideButtonTime()
  return private.db.display.autoHideButton
end

function RSConfigDB.SetAutoHideButtonTime(value)
  private.db.display.autoHideButton = value
end

---============================================================================
-- Appearence options
---============================================================================

function RSConfigDB.GetButtonScale()
  return private.db.display.scale
end

function RSConfigDB.SetButtonScale(value)
  private.db.display.scale = value
end

function RSConfigDB.GetMarkerOnTarget()
  return private.db.general.marker
end

function RSConfigDB.IsLockingPosition()
  return private.db.display.lockPosition
end

function RSConfigDB.SetLockingPosition(value)
  private.db.display.lockPosition = value
end

---============================================================================
-- Sound options database
---============================================================================

function RSConfigDB.IsPlayingSound()
  return private.db.sound.soundDisabled
end

function RSConfigDB.SetPlayingSound(value)
  private.db.sound.soundDisabled = value
end

function RSConfigDB.GetSoundPlayedWithObjects()
  return private.db.sound.soundObjectPlayed
end

function RSConfigDB.SetSoundPlayedWithObjects(value)
  private.db.sound.soundObjectPlayed = value
end

function RSConfigDB.GetSoundPlayedWithNpcs()
  return private.db.sound.soundPlayed
end

function RSConfigDB.SetSoundPlayedWithNpcs(value)
  private.db.sound.soundPlayed = value
end

function RSConfigDB.GetSoundVolume()
  return private.db.sound.soundVolume
end

function RSConfigDB.SetSoundVolume(value)
  private.db.sound.soundVolume = value
end

---============================================================================
-- Display options database
---============================================================================

function RSConfigDB.IsButtonDisplaying()
  return private.db.display.displayButton
end

function RSConfigDB.SetButtonDisplaying(value)
  private.db.display.displayButton = value
end

function RSConfigDB.IsButtonDisplayingForContainers()
  return private.db.display.displayButtonContainers
end

function RSConfigDB.SetButtonDisplayingForContainers(value)
  private.db.display.displayButtonContainers = value
end

function RSConfigDB.IsDisplayingNavigationArrows()
  return private.db.display.enableNavigation
end

function RSConfigDB.SetDisplayingNavigationArrows(value)
  private.db.display.enableNavigation = value
end

function RSConfigDB.IsDisplayingRaidWarning()
  return private.db.display.displayRaidWarning
end

function RSConfigDB.SetDisplayingRaidWarning(value)
  private.db.display.displayRaidWarning = value
end

function RSConfigDB.IsDisplayingChatMessages()
  return private.db.display.displayChatMessage
end

function RSConfigDB.SetDisplayingChatMessages(value)
  private.db.display.displayChatMessage = value
end

function RSConfigDB.IsDisplayingLootBar()
  return private.db.loot.displayLoot
end

function RSConfigDB.SetDisplayingLootBar(value)
  private.db.loot.displayLoot = value
end

function RSConfigDB.IsDisplayingMarkerOnTarget()
  return private.db.general.showMaker
end

function RSConfigDB.SetDisplayingMarkerOnTarget(value)
  private.db.general.showMaker = value
end

function RSConfigDB.IsDisplayingModel()
  return private.db.display.displayMiniature
end

function RSConfigDB.SetDisplayingModel(value)
  private.db.display.displayMiniature = value
end

---============================================================================
-- Scanner filters database
---============================================================================

function RSConfigDB.IsScanningInInstances()
  return private.db.general.scanInstances
end

function RSConfigDB.SetScanningInInstance(value)
  private.db.general.scanInstances = value
end

function RSConfigDB.IsScanningWhileOnTaxi()
  return private.db.general.scanOnTaxi
end

function RSConfigDB.SetScanningWhileOnTaxi(value)
  private.db.general.scanOnTaxi = value
end

function RSConfigDB.IsScanningWorldMapVignettes()
  return private.db.general.scanWorldmapVignette
end

function RSConfigDB.SetScanningWorldMapVignettes(value)
  private.db.general.scanWorldmapVignette = value
end

function RSConfigDB.IsScanningForNpcs()
  return private.db.general.scanRares
end

function RSConfigDB.SetScanningForNpcs(value)
  private.db.general.scanRares = value
end

function RSConfigDB.IsScanningForContainers()
  return private.db.general.scanContainers
end

function RSConfigDB.SetScanningForContainers(value)
  private.db.general.scanContainers = value
end

function RSConfigDB.IsScanningForEvents()
  return private.db.general.scanEvents
end

function RSConfigDB.SetScanningForEvents(value)
  private.db.general.scanEvents = value
end

function RSConfigDB.IsScanningChatAlerts()
  return private.db.general.scanChatAlerts
end

function RSConfigDB.SetScanningChatAlerts(value)
  private.db.general.scanChatAlerts = value
end

---============================================================================
-- Zone filters database
---============================================================================

function RSConfigDB.GetAllFilteredZones()
	return private.db.general.filteredZones
end

function RSConfigDB.IsZoneFiltered(mapID)
	return private.db.general.filteredZones[mapID] == false
end

function RSConfigDB.IsZoneFilteredOnlyOnWorldMap()
  return private.db.zoneFilters.filterOnlyMap
end

function RSConfigDB.SetZoneFilteredOnlyOnWorldMap(value)
  private.db.zoneFilters.filterOnlyMap = value
end

function RSConfigDB.IsEntityZoneFiltered(entityID, atlasName)
	if (entityID and atlasName) then
		-- If npc
		if (RSConstants.IsNpcAtlas(atlasName)) then
			local npcInfo = RSNpcDB.GetInternalNpcInfo(entityID)
			if (RSNpcDB.IsInternalNpcMultiZone(entityID)) then
				for mapID, _ in pairs (npcInfo.zoneID) do
					if (private.db.general.filteredZones[mapID] == false) then
						return true;
					end
				end
			elseif (RSNpcDB.IsInternalNpcMonoZone(entityID) and RSConfigDB.IsZoneFiltered(npcInfo.zoneID)) then
				return true;
			end
		-- If container
		elseif (RSConstants.IsContainerAtlas(atlasName)) then
			local containerInfo = RSContainerDB.GetInternalContainerInfo(entityID)
			if (RSContainerDB.IsInternalContainerMultiZone(entityID)) then
			  for mapID, _ in pairs (containerInfo.zoneID) do
          if (private.db.general.filteredZones[mapID] == false) then
            return true;
          end
        end
      elseif (RSContainerDB.IsInternalContainerMonoZone(entityID) and RSConfigDB.IsZoneFiltered(containerInfo.zoneID)) then
        return true;
      end
		-- If event
		elseif (RSConstants.IsEventAtlas(atlasName)) then
			local eventInfo = RSEventDB.GetInternalEventInfo(entityID)
			if (eventInfo and RSConfigDB.IsZoneFiltered(eventInfo.zoneID)) then
				return true;
			end
		end
	end
	
	return false
end

function RSConfigDB:GetZoneFiltered(mapID)
	if (mapID) then
		return private.db.general.filteredZones[mapID]
	end
end

function RSConfigDB:SetZoneFiltered(mapID, value)
	private.db.general.filteredZones[mapID] = value
end


---============================================================================
-- Not discovered filters database
---============================================================================

function RSConfigDB.IsShowingNotDiscoveredMapIcons()
	return private.db.map.displayNotDiscoveredMapIcons
end

function RSConfigDB.SetShowingNotDiscoveredMapIcons(value)
  private.db.map.displayNotDiscoveredMapIcons = value
end

function RSConfigDB.SetShowingNotDiscoveredMapIcons(value)
  private.db.map.displayNotDiscoveredMapIcons = value
end

function RSConfigDB.IsShowingOldNotDiscoveredMapIcons()
	return private.db.map.displayOldNotDiscoveredMapIcons
end

function RSConfigDB.SetShowingOldNotDiscoveredMapIcons(value)
  private.db.map.displayOldNotDiscoveredMapIcons = value
end

function RSConfigDB.SetShowingOldNotDiscoveredMapIcons(value)
  private.db.map.displayOldNotDiscoveredMapIcons = value
end

---============================================================================
-- NPC filters database
---============================================================================

function RSConfigDB.IsShowingNpcs()
	return private.db.map.displayNpcIcons
end

function RSConfigDB.SetShowingNpcs(value)
  private.db.map.displayNpcIcons = value
end

function RSConfigDB.SetShowingNpcs(value)
  private.db.map.displayNpcIcons = value
end

function RSConfigDB.IsNpcFiltered(npcID)
	if (npcID) then
		return private.db.general.filteredRares[npcID] == false
	end
	
	return false
end

function RSConfigDB.SetNpcFiltered(npcID, value)
  if (npcID) then
    private.db.general.filteredRares[npcID] = value
  end
end

function RSConfigDB.IsNpcFilteredOnlyOnWorldMap()
  return private.db.rareFilters.filterOnlyMap
end

function RSConfigDB.SetNpcFilteredOnlyOnWorldMap(value)
  private.db.rareFilters.filterOnlyMap = value
end

function RSConfigDB.IsShowingFriendlyNpcs()
	return private.db.map.displayFriendlyNpcIcons
end

function RSConfigDB.SetShowingFriendlyNpcs(value)
  private.db.map.displayFriendlyNpcIcons = value
end

function RSConfigDB.IsShowingDeadNpcs()
	return private.db.map.keepShowingAfterDead
end

function RSConfigDB.SetShowingDeadNpcs(value)
  private.db.map.keepShowingAfterDead = value
end

function RSConfigDB.IsShowingDeadNpcsInReseteableZones()
	return private.db.map.keepShowingAfterDeadReseteable
end

function RSConfigDB.SetShowingDeadNpcsInReseteableZones(value)
  private.db.map.keepShowingAfterDeadReseteable = value
end

function RSConfigDB.IsMaxSeenTimeFilterEnabled()
	return private.db.map.maxSeenTime ~= 0
end

function RSConfigDB.EnableMaxSeenTimeFilter()
  -- If while disabled they setted the time through the options panel
  if (RSConfigDB.GetMaxSeenTimeFilter() > 0) then
   RSLogger:PrintDebugMessage(string.format("EnableMaxSeenTimeFilter [maxSeenTime = %s]", RSConfigDB.GetMaxSeenTimeFilter()))
   return;
  end
  
  if (private.db.map.maxSeenTimeBak and private.db.map.maxSeenTimeBak > 0) then
    RSConfigDB.SetMaxSeenTimeFilter(private.db.map.maxSeenTimeBak)
  -- Its possible that they enabled it though the options panel
  else
    RSConfigDB.SetMaxSeenTimeFilter(5, false)
  end
  RSLogger:PrintDebugMessage(string.format("EnableMaxSeenTimeFilter [maxSeenTime = %s]", RSConfigDB.GetMaxSeenTimeFilter()))
end

function RSConfigDB.DisableMaxSeenTimeFilter()
  private.db.map.maxSeenTimeBak = RSConfigDB.GetMaxSeenTimeFilter()
  RSConfigDB.SetMaxSeenTimeFilter(0, false)
  RSLogger:PrintDebugMessage(string.format("DisableMaxSeenTimeFilter [maxSeenTime = %s]", RSConfigDB.GetMaxSeenTimeFilter()))
end

function RSConfigDB.GetMaxSeenTimeFilter()
	return private.db.map.maxSeenTime
end

function RSConfigDB.SetMaxSeenTimeFilter(value, clearBak)
  private.db.map.maxSeenTime = value
  RSLogger:PrintDebugMessage(string.format("SetMaxSeenTimeFilter [maxSeenTime = %s]", value))
  if (clearBak) then
    private.db.map.maxSeenTimeBak = nil
  end
end

---============================================================================
-- Container filters database
---============================================================================

function RSConfigDB.IsShowingContainers()
	return private.db.map.displayContainerIcons
end

function RSConfigDB.SetShowingContainers(value)
  private.db.map.displayContainerIcons = value
end

function RSConfigDB.IsShowingGarrisonCache()
	return private.db.general.scanGarrison
end

function RSConfigDB.SetShowingGarrisonCache(value)
  private.db.general.scanGarrison = value
end

function RSConfigDB.IsShowingOpenedContainers()
	return private.db.map.keepShowingAfterCollected
end

function RSConfigDB.SetShowingOpenedContainers(value)
  private.db.map.keepShowingAfterCollected = value
end

function RSConfigDB.IsMaxSeenTimeContainerFilterEnabled()
	return private.db.map.maxSeenTimeContainer ~= 0
end

function RSConfigDB.EnableMaxSeenContainerTimeFilter()
  -- If while disabled they setted the time through the options panel
  if (RSConfigDB.GetMaxSeenContainerTimeFilter() > 0) then
   RSLogger:PrintDebugMessage(string.format("EnableMaxSeenContainerTimeFilter [maxSeenTimeContainer = %s]", RSConfigDB.GetMaxSeenContainerTimeFilter()))
   return;
  end
  
  if (private.db.map.maxSeenContainerTimeBak and private.db.map.maxSeenContainerTimeBak > 0) then
    RSConfigDB.SetMaxSeenContainerTimeFilter(private.db.map.maxSeenContainerTimeBak)
  -- Its possible that they enabled it though the options panel
  else
    RSConfigDB.SetMaxSeenContainerTimeFilter(RSConstants.PROFILE_DEFAULTS.profile.map.maxSeenTimeContainer, false)
  end
  RSLogger:PrintDebugMessage(string.format("EnableMaxSeenContainerTimeFilter [maxSeenTimeContainer = %s]", RSConfigDB.GetMaxSeenContainerTimeFilter()))
end

function RSConfigDB.DisableMaxSeenContainerTimeFilter()
  private.db.map.maxSeenContainerTimeBak = RSConfigDB.GetMaxSeenContainerTimeFilter()
  RSConfigDB.SetMaxSeenContainerTimeFilter(0, false)
  RSLogger:PrintDebugMessage(string.format("DisableMaxSeenContainerTimeFilter [maxSeenTimeContainer = %s]", RSConfigDB.GetMaxSeenContainerTimeFilter()))
end

function RSConfigDB.GetMaxSeenContainerTimeFilter()
	return private.db.map.maxSeenTimeContainer
end

function RSConfigDB.SetMaxSeenContainerTimeFilter(value, clearBak)
  private.db.map.maxSeenTimeContainer = value
  RSLogger:PrintDebugMessage(string.format("SetMaxSeenContainerTimeFilter [maxSeenTimeContainer = %s]", value))
  if (clearBak) then
    private.db.map.maxSeenContainerTimeBak = nil
  end
end

---============================================================================
-- Event filters database
---============================================================================

function RSConfigDB.IsShowingEvents()
	return private.db.map.displayEventIcons
end

function RSConfigDB.SetShowingEvents(value)
  private.db.map.displayEventIcons = value
end

function RSConfigDB.IsShowingCompletedEvents()
	return private.db.map.keepShowingAfterCompleted
end

function RSConfigDB.SetShowingCompletedEvents(value)
  private.db.map.keepShowingAfterCompleted = value
end

function RSConfigDB.IsMaxSeenTimeEventFilterEnabled()
  return private.db.map.maxSeenTimeEvent ~= 0
end

function RSConfigDB.EnableMaxSeenEventTimeFilter()
  -- If while disabled they setted the time through the options panel
  if (RSConfigDB.GetMaxSeenEventTimeFilter() > 0) then
   RSLogger:PrintDebugMessage(string.format("EnableMaxSeenEventTimeFilter [maxSeenTimeEvent = %s]", RSConfigDB.GetMaxSeenEventTimeFilter()))
   return;
  end
  
  if (private.db.map.maxSeenEventTimeBak and private.db.map.maxSeenEventTimeBak > 0) then
    RSConfigDB.SetMaxSeenEventTimeFilter(private.db.map.maxSeenEventTimeBak)
  -- Its possible that they enabled it though the options panel
  else
    RSConfigDB.SetMaxSeenEventTimeFilter(RSConstants.PROFILE_DEFAULTS.profile.map.maxSeenTimeEvent, false)
  end
  RSLogger:PrintDebugMessage(string.format("EnableMaxSeenEventTimeFilter [maxSeenTimeEvent = %s]", RSConfigDB.GetMaxSeenEventTimeFilter()))
end

function RSConfigDB.DisableMaxSeenEventTimeFilter()
  private.db.map.maxSeenEventTimeBak = RSConfigDB.GetMaxSeenEventTimeFilter()
  RSConfigDB.SetMaxSeenEventTimeFilter(0, false)
  RSLogger:PrintDebugMessage(string.format("DisableMaxSeenEventTimeFilter [maxSeenTimeEvent = %s]", RSConfigDB.GetMaxSeenEventTimeFilter()))
end

function RSConfigDB.GetMaxSeenEventTimeFilter()
  return private.db.map.maxSeenTimeEvent
end

function RSConfigDB.SetMaxSeenEventTimeFilter(value, clearBak)
  private.db.map.maxSeenTimeEvent = value
  RSLogger:PrintDebugMessage(string.format("SetMaxSeenEventTimeFilter [maxSeenTimeEvent = %s]", value))
  if (clearBak) then
    private.db.map.maxSeenEventTimeBak = nil
  end
end

---============================================================================
-- WorldMap icons scale
---============================================================================

function RSConfigDB.GetIconsWorldMapScale()
	return private.db.map.scale
end

function RSConfigDB.SetIconsWorldMapScale(value)
  private.db.map.scale = value
end

---============================================================================
-- Minimap icons scale
---============================================================================

function RSConfigDB.GetIconsMinimapScale()
	return private.db.map.minimapscale
end

---============================================================================
-- WorldMap loot
---============================================================================

function RSConfigDB.IsShowingLootOnWorldMap()
	return private.db.loot.displayLootOnMap
end

function RSConfigDB.SetShowingLootOnWorldMap(value)
  private.db.loot.displayLootOnMap = value
end

---============================================================================
-- Loot in general
---============================================================================

function RSConfigDB.GetMaxNumItemsToShow()
  return private.db.loot.numItems
end

function RSConfigDB.SetMaxNumItemsToShow(value)
  private.db.loot.numItems = value
end

function RSConfigDB.GetNumItemsPerRow()
  return private.db.loot.numItemsPerRow
end

function RSConfigDB.SetNumItemsPerRow(value)
  private.db.loot.numItemsPerRow = value
end

function RSConfigDB:GetLootTooltipPosition()
  return private.db.loot.lootTooltipPosition
end

function RSConfigDB:SetLootTooltipPosition(value)
  private.db.loot.lootTooltipPosition = value
end

---============================================================================
-- Loot filters
---============================================================================

function RSConfigDB.GetLootFilterMinQuality()
  return private.db.loot.lootMinQuality
end

function RSConfigDB.SetLootFilterMinQuality(value)
  private.db.loot.lootMinQuality = value
end

function RSConfigDB.SetLootFilterByCategory(itemClassID, itemSubClassID, value)
  if (itemClassID and itemSubClassID and private.db.loot.filteredLootCategories[itemClassID]) then
    private.db.loot.filteredLootCategories[itemClassID][itemSubClassID] = value
  end
end

function RSConfigDB.GetLootFilterByCategory(itemClassID, itemSubClassID)
  if (itemClassID and itemSubClassID and private.db.loot.filteredLootCategories[itemClassID]) then
    return private.db.loot.filteredLootCategories[itemClassID][itemSubClassID]
  end
  
  return nil
end

function RSConfigDB.IsFilteringLootByCompletedQuest()
  return private.db.loot.filterItemsCompletedQuest
end

function RSConfigDB.SetFilteringLootByCompletedQuest(value)
  private.db.loot.filterItemsCompletedQuest = value
end

function RSConfigDB.IsFilteringLootByNotEquipableItems()
  return private.db.loot.filterNotEquipableItems
end

function RSConfigDB.SetFilteringLootByNotEquipableItems(value)
  private.db.loot.filterNotEquipableItems = value
end

function RSConfigDB.IsFilteringLootByNotMatchingClass()
  return private.db.loot.filterNotMatchingClass
end

function RSConfigDB.SetFilteringLootByNotMatchingClass(value)
  private.db.loot.filterNotMatchingClass = value
end

function RSConfigDB.IsFilteringLootByNotMatchingFaction()
  return private.db.loot.filterNotMatchingFaction
end

function RSConfigDB.SetFilteringLootByNotMatchingFaction(value)
  private.db.loot.filterNotMatchingFaction = value
end

function RSConfigDB.IsFilteringLootByTransmog()
  return private.db.loot.showOnlyTransmogItems
end

function RSConfigDB.SetFilteringLootByTransmog(value)
  private.db.loot.showOnlyTransmogItems = value
end

function RSConfigDB.IsFilteringByCollected()
  return private.db.loot.filterCollectedItems
end

function RSConfigDB.SetFilteringByCollected(value)
  private.db.loot.filterCollectedItems = value
end

---============================================================================
-- Navigator options
---============================================================================

function RSConfigDB.IsNavigationLockEnabled()
  return private.db.display.navigationLockEntity
end

function RSConfigDB.SetNavigationLockEnabled(value)
  private.db.display.navigationLockEntity = value
end

---============================================================================
-- Waypoints
---============================================================================

function RSConfigDB.IsWaypointsSupportEnabled()
  return private.db.general.enableWaypointsSupport
end

function RSConfigDB.SetWaypointsSupportEnabled(value)
  private.db.general.enableWaypointsSupport = value
end

function RSConfigDB.IsAddingWaypointsAutomatically()
  return private.db.general.autoWaypoints
end

function RSConfigDB.SetAddingWaypointsAutomatically(value)
  private.db.general.autoWaypoints = value
end

function RSConfigDB.IsTomtomSupportEnabled()
  return private.db.general.enableTomtomSupport
end

function RSConfigDB.SetTomtomSupportEnabled(value)
  private.db.general.enableTomtomSupport = value
end

function RSConfigDB.IsAddingTomtomWaypointsAutomatically()
  return private.db.general.autoTomtomWaypoints
end

function RSConfigDB.SetAddingTomtomWaypointsAutomatically(value)
  private.db.general.autoTomtomWaypoints = value
end

---============================================================================
-- Worldmap searcher
---============================================================================

function RSConfigDB.SetShowingWorldMapSearcher(value)
  private.db.map.showingWorldMapSearcher = value
end

function RSConfigDB.IsShowingWorldMapSearcher()
  return private.db.map.showingWorldMapSearcher
end

function RSConfigDB.SetClearingWorldMapSearcher(value)
  private.db.map.cleanWorldMapSearcherOnHide = value
end

function RSConfigDB.IsClearingWorldMapSearcher()
  return private.db.map.cleanWorldMapSearcherOnHide
end