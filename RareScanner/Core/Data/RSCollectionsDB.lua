-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local ADDON_NAME, private = ...

local LibDialog = LibStub("LibDialog-1.0")

local RSCollectionsDB = private.NewLib("RareScannerCollectionsDB")

-- Locales
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner");

-- RareScanner database libraries
local RSNpcDB = private.ImportLib("RareScannerNpcDB")
local RSContainerDB = private.ImportLib("RareScannerContainerDB")
local RSConfigDB = private.ImportLib("RareScannerConfigDB")

-- RareScanner libraries
local RSConstants = private.ImportLib("RareScannerConstants")
local RSLogger = private.ImportLib("RareScannerLogger")
local RSUtils = private.ImportLib("RareScannerUtils")
local RSRoutines = private.ImportLib("RareScannerRoutines")

local ITEM_SOURCE = {
	NPC = 1,
	CONTAINER = 2
}

local ITEM_TYPE = {
	APPEARANCE = 1,
	TOY = 2,
	PET = 3,
	MOUNT = 4,
	ANYTHING = 0
}

---============================================================================
-- Manage database
---============================================================================

local function ResetEntitiesCollectionsLoot()
	private.dbglobal.entity_collections_loot = {}
end

local function UpdateEntityCollection(itemID, entityID, source)
	if (not RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source]) then
		RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source] = {}
	end
	
	if (not RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID]) then
		RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID] = {}
	end
	
	if (not RSUtils.Contains(RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID], itemID)) then
		table.insert(RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID], itemID)
		RSLogger:PrintDebugMessage(string.format("UpdateEntityCollection: Añadido itemID [%s], para la entidad [%s]. Origen [%s].", itemID, entityID, source))
		
		-- Removes the entity filter
		if (source == ITEM_SOURCE.NPC) then
			RSConfigDB.SetNpcFiltered(entityID, true)
			
			if (RSConstants.NPCS_WITH_PRE_NPCS[entityID]) then
				RSConfigDB.SetNpcFiltered(RSConstants.NPCS_WITH_PRE_NPCS[entityID], true)
			end
		else
			RSConfigDB.SetContainerFiltered(entityID, true)
		end
	end
end

---============================================================================
-- Toys
---============================================================================

local function UpdateNotCollectedToys(routines)
	-- Backup settings
	local collectedShown = C_ToyBox.GetCollectedShown();
	local uncollectedShown = C_ToyBox.GetUncollectedShown();
	local unusableShown = C_ToyBox.GetUnusableShown();
	
	-- Prepare filters
	C_ToyBox.SetCollectedShown(false);
	C_ToyBox.SetUncollectedShown(true);
	C_ToyBox.SetUnusableShown(true);
	C_ToyBox.SetAllExpansionTypeFilters(true);
	C_ToyBox.SetFilterString("");
		
	for i=1,C_PetJournal.GetNumPetSources() do
		if (i == 1) then
			C_ToyBox.SetSourceTypeFilter(i, true) -- Drop source
		else
			C_ToyBox.SetSourceTypeFilter(i, false) -- Other source
		end
	end
	
	private.dbglobal.not_colleted_toys = {}
	
	-- Query
	local notCollectedToyROutine = RSRoutines.LoopIndexRoutineNew()
	notCollectedToyROutine:Init(C_ToyBox.GetNumFilteredToys, 50, 
		function(context, i)
			local toyID = C_ToyBox.GetToyFromIndex(i)
			local itemID, _, _, _, _, _ = C_ToyBox.GetToyInfo(toyID)
			tinsert(private.dbglobal.not_colleted_toys, itemID)
		end,
		function(context)
			-- Restore settings
			C_ToyBox.SetCollectedShown(collectedShown);
			C_ToyBox.SetUncollectedShown(uncollectedShown);
			C_ToyBox.SetUnusableShown(unusableShown);
			C_ToyBox.SetAllExpansionTypeFilters(true);
			C_ToyBox.SetAllSourceTypeFilters(true);
			
			RSLogger:PrintDebugMessage(string.format("UpdateNotCollectedToys. [%s no conseguidos].", RSUtils.GetTableLength(private.dbglobal.not_colleted_toys)))
		end
	)
	table.insert(routines, notCollectedToyROutine)
end

local function GetNotCollectedToys()
	return private.dbglobal.not_colleted_toys
end

local function CheckUpdateToy(itemID, entityID, source, checkedItems)
	-- If cached use it
	if (checkedItems[ITEM_TYPE.TOY][itemID]) then
		UpdateEntityCollection(itemID, entityID, source)
	else
		if (RSUtils.Contains(GetNotCollectedToys(), itemID)) then
			UpdateEntityCollection(itemID, entityID, source)
			checkedItems[ITEM_TYPE.TOY][itemID] = true
			return true
		end
	
		return false
	end
end

function RSCollectionsDB.RemoveNotCollectedToy(itemID) --NEW_TOY_ADDED
	if (itemID and GetNotCollectedToys() and table.getn(GetNotCollectedToys()) ~= nil) then		
		-- Drop missing toy
		for i = #private.dbglobal.not_colleted_toys, 1, -1 do
    		if (private.dbglobal.not_colleted_toys[i] == itemID) then
       			table.remove(private.dbglobal.not_colleted_toys, i)
				RSLogger:PrintDebugMessage(string.format("RemoveNotCollectedToy[%s]: Eliminado coleccionable conseguido.", itemID))
       			break
       		end
		end
		
		-- Update filters
		for source, info in pairs (RSCollectionsDB.GetAllEntitiesCollectionsLoot()) do
			for entityID, lootList in pairs (RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source]) do
				for i = #lootList, 1, -1 do
					if (lootList[i] == itemID) then
						-- If empty filter it
						if (table.getn(lootList) == 1) then
							RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID] = nil
						
							if (RSConfigDB.IsAutoFilteringOnCollect()) then
								if (source == ITEM_SOURCE.NPC) then
									RSConfigDB.SetNpcFiltered(entityID, false)
									RSLogger:PrintDebugMessage(string.format("RemoveNotCollectedToy[%s]: Filtrado NPC [%s] por no disponer de mas coleccionables.", itemID, entityID))
								elseif (source == ITEM_SOURCE.CONTAINER) then
									RSConfigDB.SetContainerFiltered(entityID, false)
									RSLogger:PrintDebugMessage(string.format("RemoveNotCollectedToy[%s]: Filtrado Contenedor [%s] por no disponer de mas coleccionables.", itemID, entityID))
								end
							end
						else
							RSLogger:PrintDebugMessage(string.format("RemoveNotCollectedToy[%s]: Eliminado coleccionable de la lista de la entidad [%s], pero esta no se filtra por disponer de otros collecionables.", itemID, entityID))
							table.remove(lootList, i)
						end
						
						break
					end
				end
			end
		end
    end
end

---============================================================================
-- Pets
---============================================================================

local function UpdateNotCollectedPetIDs(routines)
	-- Backup settings
	local filterCollected = C_PetJournal.IsFilterChecked(LE_PET_JOURNAL_FILTER_COLLECTED)
	local filterNotCollected = C_PetJournal.IsFilterChecked(LE_PET_JOURNAL_FILTER_NOT_COLLECTED)
	
	-- Prepare filters
	C_PetJournal.SetFilterChecked(LE_PET_JOURNAL_FILTER_COLLECTED, false)
	C_PetJournal.SetFilterChecked(LE_PET_JOURNAL_FILTER_NOT_COLLECTED, true)
	C_PetJournal.ClearSearchFilter()
	
	for i=1,C_PetJournal.GetNumPetSources() do
		if (i == 1) then
			C_PetJournal.SetPetSourceChecked(i, true) -- Drop source
		else
			C_PetJournal.SetPetSourceChecked(i, false) -- Other source
		end
	end
	
	private.dbglobal.not_colleted_pets_ids = {}
	
	-- Query
	local notCollectedPetIDs = RSRoutines.LoopIndexRoutineNew()
	notCollectedPetIDs:Init(C_PetJournal.GetNumPets, 50, 
		function(context, i)
			local _, _, _, _, _, _, _, _, _, _, companionID, _, _, _, _, _, _, _ = C_PetJournal.GetPetInfoByIndex(i)
			-- The first parameter is the petID but for some reason it comes nil, so we must use the companionID
			if (companionID) then
				table.insert(private.dbglobal.not_colleted_pets_ids, companionID)
			end
		end,
		function(context)
			-- Restore settings
			C_PetJournal.SetFilterChecked(LE_PET_JOURNAL_FILTER_COLLECTED, filterCollected)
			C_PetJournal.SetFilterChecked(LE_PET_JOURNAL_FILTER_NOT_COLLECTED, filterNotCollected)
			C_PetJournal.SetAllPetSourcesChecked(true)
			
			RSLogger:PrintDebugMessage(string.format("UpdateNotCollectedPetIDs. [%s no conseguidas].", RSUtils.GetTableLength(private.dbglobal.not_colleted_pets_ids)))
		end
	)
	table.insert(routines, notCollectedPetIDs)	
end

local function GetNotCollectedPetsIDs()
	return private.dbglobal.not_colleted_pets_ids
end

local function GetPetItemID(creatureID)
	if (creatureID) then
		return private.DROPPED_PET_IDS[creatureID]
	end
	
	return nil
end

local function GetPetID(itemID)
	if (itemID) then
		for petID, internalItemID in pairs(private.DROPPED_PET_IDS) do
			if (internalItemID == itemID) then
				return petID
			end
		end
	end
	
	return nil
end

local function CheckUpdatePet(itemID, entityID, source, checkedItems)
	-- If cached use it
	if (checkedItems[ITEM_TYPE.PET][itemID]) then
		UpdateEntityCollection(itemID, entityID, source)
	else
		local creatureID = GetPetID(itemID)
		if (creatureID) then			
			if (RSUtils.Contains(GetNotCollectedPetsIDs(), creatureID)) then
				UpdateEntityCollection(itemID, entityID, source)
				checkedItems[ITEM_TYPE.PET][itemID] = true
			end
			
			return true
		end
		
		return false
	end
end

function RSCollectionsDB.RemoveNotCollectedPet(petGUID) --NEW_PET_ADDED
	if (petGUID and GetNotCollectedPetsIDs() and table.getn(GetNotCollectedPetsIDs()) ~= nil) then
		local _, _, _, _, _, _, _, _, _, _, creatureID, _, _, _, _, _, _, _ = C_PetJournal.GetPetInfoByPetID(petGUID)
		if (not creatureID) then
			RSLogger:PrintDebugMessage(string.format("RemoveNotCollectedPet[%s]: No se ha localizado el creatureID asociado.", petGUID))
			return
		end
		
		-- Drop missing pet
		for i = #private.dbglobal.not_colleted_pets_ids, 1, -1 do
    		if (private.dbglobal.not_colleted_pets_ids[i] == creatureID) then
       			table.remove(private.dbglobal.not_colleted_pets_ids, i)
				RSLogger:PrintDebugMessage(string.format("RemoveNotCollectedPet[%s]: Eliminado coleccionable conseguido.", petGUID))
       			break
       		end
		end
		
		-- Update filters
		for source, info in pairs (RSCollectionsDB.GetAllEntitiesCollectionsLoot()) do
			for entityID, lootList in pairs (RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source]) do
				for i = #lootList, 1, -1 do
					if (lootList[i] == GetPetItemID(creatureID)) then
						-- If empty filter it
						if (table.getn(lootList) == 1) then
							RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID] = nil
						
							if (RSConfigDB.IsAutoFilteringOnCollect()) then
								if (source == ITEM_SOURCE.NPC) then
									RSConfigDB.SetNpcFiltered(entityID, false)
									RSLogger:PrintDebugMessage(string.format("RemoveNotCollectedPet[%s]: Filtrado NPC [%s] por no disponer de mas coleccionables.", petGUID, entityID))
								elseif (source == ITEM_SOURCE.CONTAINER) then
									RSConfigDB.SetContainerFiltered(entityID, false)
									RSLogger:PrintDebugMessage(string.format("RemoveNotCollectedPet[%s]: Filtrado Contenedor [%s] por no disponer de mas coleccionables.", petGUID, entityID))
								end
							end
						else
							RSLogger:PrintDebugMessage(string.format("RemoveNotCollectedPet[%s]: Eliminado coleccionable de la lista de la entidad [%s], pero esta no se filtra por disponer de otros collecionables.", petGUID, entityID))
							table.remove(lootList, i)
						end
						
						break
					end
				end
			end
		end
    end
end

---============================================================================
-- Mounts
---============================================================================

local function UpdateNotCollectedMountIDs(routines)
	-- Backup settings
	local colletedFilter = C_MountJournal.GetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_NOT_COLLECTED)
	local notColletedFilter = C_MountJournal.GetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_NOT_COLLECTED)
	local notUnusableFilter = C_MountJournal.GetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_UNUSABLE)
	
	-- Prepare filters
	C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_COLLECTED, false);
	C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_NOT_COLLECTED, true);
	C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_UNUSABLE, true);
	C_MountJournal.SetSearch("");
	
	for i=1,C_PetJournal.GetNumPetSources() do
		if (i == 1) then
			C_MountJournal.SetSourceFilter(i, true) -- Drop source
		else
			C_MountJournal.SetSourceFilter(i, false) -- Other source
		end
	end
	
	private.dbglobal.not_colleted_mounts_ids = {}
		
	-- Query
	local notCollectedMountIDs = RSRoutines.LoopIndexRoutineNew()
	notCollectedMountIDs:Init(C_MountJournal.GetNumMounts, 50, 
		function(context, i)
			local name, _, _, _, _, _, _, _, _, _, _, mountID = C_MountJournal.GetDisplayedMountInfo(i);
			if (mountID) then
				table.insert(private.dbglobal.not_colleted_mounts_ids, mountID)
			end
		end,
		function(context)
			-- Add mounts without specified source or wrong source
			for _, mountID in ipairs (RSConstants.MOUNTS_WITHOUT_SOURCE) do
				table.insert(private.dbglobal.not_colleted_mounts_ids, mountID)
			end
			
			-- Recover settings
			C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_COLLECTED, colletedFilter);
			C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_NOT_COLLECTED, notColletedFilter);
			C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_UNUSABLE, notUnusableFilter);
			C_MountJournal.SetAllSourceFilters(true)
			
			RSLogger:PrintDebugMessage(string.format("UpdateNotCollectedMountIDs. [%s no conseguidas].", RSUtils.GetTableLength(private.dbglobal.not_colleted_mounts_ids)))
		end
	)
	table.insert(routines, notCollectedMountIDs)
end

local function GetNotCollectedMountsIDs()
	return private.dbglobal.not_colleted_mounts_ids
end

local function GetMountItemID(mountID)
	if (mountID) then
		return private.DROPPED_MOUNT_IDS[mountID]
	end
	
	return nil
end

local function GetMountID(itemID)
	if (itemID) then
		for mountID, internalItemID in pairs(private.DROPPED_MOUNT_IDS) do
			if (internalItemID == itemID) then
				return mountID
			end
		end
	end
	
	return nil
end

local function CheckUpdateMount(itemID, entityID, source, checkedItems)
	-- If cached use it
	if (checkedItems[ITEM_TYPE.MOUNT][itemID]) then
		UpdateEntityCollection(itemID, entityID, source)
	else
		local mountID = GetMountID(itemID)
		if (mountID) then		
			if (RSUtils.Contains(GetNotCollectedMountsIDs(), mountID)) then
				UpdateEntityCollection(itemID, entityID, source)
				checkedItems[ITEM_TYPE.MOUNT][itemID] = true
			end
			
			return true
		end
		
		return false
	end
end

function RSCollectionsDB.RemoveNotCollectedMount(mountID) --NEW_MOUNT_ADDED
	if (mountID and GetNotCollectedMountsIDs() and table.getn(GetNotCollectedMountsIDs()) ~= nil) then
		RSLogger:PrintDebugMessage(string.format("RemoveNotCollectedMount[%s]", mountID))
	
		-- Drop missing mount
		for i = #private.dbglobal.not_colleted_mounts_ids, 1, -1 do
    		if (private.dbglobal.not_colleted_mounts_ids[i] == mountID) then
       			table.remove(private.dbglobal.not_colleted_mounts_ids, i)
				RSLogger:PrintDebugMessage(string.format("RemoveNotCollectedMount[%s]: Eliminado coleccionable conseguido.", mountID))
       			break
       		end
		end
		
		for source, _ in pairs (RSCollectionsDB.GetAllEntitiesCollectionsLoot()) do
			for entityID, lootList in pairs (RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source]) do
				for i = #lootList, 1, -1 do
					if (lootList[i] == GetMountItemID(mountID)) then
						-- If empty filter it
						if (table.getn(lootList) == 1) then
							RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID] = nil
						
							if (RSConfigDB.IsAutoFilteringOnCollect()) then
								if (source == ITEM_SOURCE.NPC) then
									RSConfigDB.SetNpcFiltered(entityID, false)
									RSLogger:PrintDebugMessage(string.format("RemoveNotCollectedMount[%s]: Filtrado NPC [%s] por no disponer de mas coleccionables.", mountID, entityID))
								elseif (source == ITEM_SOURCE.CONTAINER) then
									RSConfigDB.SetContainerFiltered(entityID, false)
									RSLogger:PrintDebugMessage(string.format("RemoveNotCollectedMount[%s]: Filtrado Contenedor [%s] por no disponer de mas coleccionables.", mountID, entityID))
								end
							end
						else
							RSLogger:PrintDebugMessage(string.format("RemoveNotCollectedMount[%s]: Eliminado coleccionable de la lista de la entidad [%s], pero esta no se filtra por disponer de otros collecionables.", mountID, entityID))
							table.remove(lootList, i)
						end
						
						break
					end
				end
			end
		end
    end
end

---============================================================================
-- Appearances
---============================================================================

local function AddAppearanceItemID(appearanceID, itemID)
	if (not private.dbglobal.appearances_item_id) then
		private.dbglobal.appearances_item_id = {}
	end
	
	if (not private.dbglobal.appearances_item_id[appearanceID]) then
		private.dbglobal.appearances_item_id[appearanceID] = {}
	end
	
	if (not RSUtils.Contains(private.dbglobal.appearances_item_id[appearanceID], itemID)) then
		table.insert(private.dbglobal.appearances_item_id[appearanceID], itemID)
	end
end

local function GetAppearanceItemIDs(appearanceID)
	if (private.dbglobal.appearances_item_id) then
		return private.dbglobal.appearances_item_id[appearanceID]
	end
	
	return nil
end

local function UpdateNotCollectedAppearanceItemIDs(routines)
	private.dbchar.not_colleted_appearances_item_ids = {}
	
	-- Query	
	for name, categoryID in pairs (Enum.TransmogCollectionType) do
		local visualsList = C_TransmogCollection.GetCategoryAppearances(categoryID)
		if (visualsList) then
			local notCollectedAppearanceItemIDs = RSRoutines.LoopIndexRoutineNew()
			notCollectedAppearanceItemIDs:Init(C_TransmogCollection.GetCategoryAppearances, 100, 
				function(context, j)
					if (not visualsList[j].isCollected) then
						local sources = C_TransmogCollection.GetAppearanceSources(visualsList[j].visualID)
						for k = 1, #sources do
							if (sources[k].sourceType == 4) then --World drop
								AddAppearanceItemID(sources[k].visualID, sources[k].itemID)
						
								if (not private.dbchar.not_colleted_appearances_item_ids[sources[k].itemID]) then
									private.dbchar.not_colleted_appearances_item_ids[sources[k].itemID] = true
								end
							end
						end
					end
				end,
				function(context)
					RSLogger:PrintDebugMessage(string.format("UpdateNotCollectedAppearanceItemIDs. [%s] [%s no conseguidas].", name, RSUtils.GetTableLength(private.dbchar.not_colleted_appearances_item_ids)))
				end,
				categoryID
			)
			table.insert(routines, notCollectedAppearanceItemIDs)
		end
	end
end

local function GetNotCollecteAppearanceItemIDs()
	return private.dbchar.not_colleted_appearances_item_ids
end

local function CheckUpdateAppearance(itemID, entityID, source, checkedItems)
	-- If cached use it
	if (checkedItems[ITEM_TYPE.APPEARANCE][itemID]) then
		UpdateEntityCollection(itemID, entityID, source)
		
		return true
	-- Otherwise query
	else				
		if (GetNotCollecteAppearanceItemIDs()[itemID]) then
			UpdateEntityCollection(itemID, entityID, source)
			
			if (not checkedItems[ITEM_TYPE.APPEARANCE][itemID]) then
				checkedItems[ITEM_TYPE.APPEARANCE][itemID] = true
			end
			
			return true
		end
		
		return false
	end
end

function RSCollectionsDB.RemoveNotCollectedAppearance(appearanceID) --TRANSMOG_COLLECTION_UPDATED
	if (appearanceID and GetAppearanceItemIDs(appearanceID) and table.getn(GetAppearanceItemIDs(appearanceID)) ~= nil) then	
		RSLogger:PrintDebugMessage(string.format("RemoveNotCollectedAppearance[%s]", appearanceID))
			
		-- Update filters
		for source, info in pairs (RSCollectionsDB.GetAllEntitiesCollectionsLoot()) do
			for entityID, lootList in pairs (RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source]) do
				for i = #lootList, 1, -1 do
					if (RSUtils.Contains(GetAppearanceItemIDs(appearanceID), lootList[i])) then
						-- If empty filter it
						if (table.getn(lootList) == 1) then
							RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID] = nil
						
							if (RSConfigDB.IsAutoFilteringOnCollect()) then
								if (source == ITEM_SOURCE.NPC) then
									RSConfigDB.SetNpcFiltered(entityID, false)
									RSLogger:PrintDebugMessage(string.format("RemoveNotCollectedAppearance[%s]: Filtrado NPC [%s] por no disponer de mas coleccionables.", appearanceID, entityID))
								elseif (source == ITEM_SOURCE.CONTAINER) then
									RSConfigDB.SetContainerFiltered(entityID, false)
									RSLogger:PrintDebugMessage(string.format("RemoveNotCollectedAppearance[%s]: Filtrado Contenedor [%s] por no disponer de mas coleccionables.", appearanceID, entityID))
								end
							end
						else
							RSLogger:PrintDebugMessage(string.format("RemoveNotCollectedAppearance[%s]: Eliminado coleccionable de la lista de la entidad [%s], pero esta no se filtra por disponer de otros collecionables.", appearanceID, entityID))
							table.remove(lootList, i)
						end
						
						break
					end
				end
			end
		end
		
		-- Drop missing appearance
		private.dbglobal.appearances_item_id[appearanceID] = nil
    end
end

---============================================================================
-- Collections database
---============================================================================

local function CheckUpdateCollectibles(checkedItems, getter, source, routines)
	local checkUpdateCollectiblesRoutine = RSRoutines.LoopRoutineNew()
	checkUpdateCollectiblesRoutine:Init(getter, 30, 
		function(context, entityID, items)
			for _, itemID in ipairs (items) do
				if (not checkedItems[itemID]) then							
					-- Check if appearance
					if (RSConfigDB.IsSearchingAppearances() and not checkedItems[ITEM_TYPE.TOY][itemID] and not checkedItems[ITEM_TYPE.PET][itemID] and not checkedItems[ITEM_TYPE.MOUNT][itemID]) then
						CheckUpdateAppearance(itemID, entityID, source, checkedItems)
					end
					
					-- Check if toy
					if (RSConfigDB.IsSearchingToys() and not checkedItems[ITEM_TYPE.APPEARANCE][itemID] and not checkedItems[ITEM_TYPE.PET][itemID] and not checkedItems[ITEM_TYPE.MOUNT][itemID]) then
						CheckUpdateToy(itemID, entityID, source, checkedItems)
					end
							
					-- Check if pet
					if (RSConfigDB.IsSearchingPets() and not checkedItems[ITEM_TYPE.APPEARANCE][itemID] and not checkedItems[ITEM_TYPE.TOY][itemID] and not checkedItems[ITEM_TYPE.MOUNT][itemID]) then
						CheckUpdatePet(itemID, entityID, source, checkedItems)
					end
					
					-- Check if mount
					if (RSConfigDB.IsSearchingMounts() and not checkedItems[ITEM_TYPE.APPEARANCE][itemID] and not checkedItems[ITEM_TYPE.TOY][itemID] and not checkedItems[ITEM_TYPE.PET][itemID]) then
						CheckUpdateMount(itemID, entityID, source, checkedItems)
					end
					
					if (not checkedItems[ITEM_TYPE.APPEARANCE][itemID] and not checkedItems[ITEM_TYPE.PET][itemID] and not checkedItems[ITEM_TYPE.TOY][itemID] and not checkedItems[ITEM_TYPE.MOUNT][itemID]) then
						checkedItems[itemID] = true
					end
				end
			end
		end,
		function(context)
			RSLogger:PrintDebugMessage(string.format("CheckUpdateCollectibles. [%s]. Finalizado.", source == ITEM_SOURCE.NPC and "NPCs" or "Contenedores"))
		end
	)
	table.insert(routines, checkUpdateCollectiblesRoutine)
end

local function UpdateEntitiesCollections()
	-- Reset outdated data
	ResetEntitiesCollectionsLoot()
	
	local routines = {}
	
	-- Filter all entities
	RSConfigDB.FilterAllNPCs(routines)
	RSConfigDB.FilterAllContainers(routines)
	
	local checkedItems = {}
	checkedItems[ITEM_TYPE.APPEARANCE] = {}
	checkedItems[ITEM_TYPE.TOY] = {}
	checkedItems[ITEM_TYPE.PET] = {}
	checkedItems[ITEM_TYPE.MOUNT] = {}
	
	-- Sync npc loot
	CheckUpdateCollectibles(checkedItems, RSNpcDB.GetAllInteralNpcLoot, ITEM_SOURCE.NPC, routines)
	RSLogger:PrintDebugMessage("UpdateEntitiesCollections. Actualizada la lista de collecionables de NPCs no conseguidos.")
	
	-- Sync container loot
	CheckUpdateCollectibles(checkedItems, RSContainerDB.GetAllInteralContainerLoot, ITEM_SOURCE.CONTAINER, routines)
	RSLogger:PrintDebugMessage("UpdateEntitiesCollections. Actualizada la lista de collecionables de contenedores no conseguidos.")
		
	-- Launch all the routines in order
	local chainRoutines = RSRoutines.ChainLoopRoutineNew()
	chainRoutines:Init(routines)
	chainRoutines:Run(function(context)
		checkedItems = nil
	
		RSLogger:PrintDebugMessage("UpdateEntitiesCollections: Finalizado proceso.")
		RSLogger:PrintMessage(AL["LOG_DONE"])
		
		-- Ask for setting loot filters
		LibDialog:Spawn(RSConstants.APPLY_COLLECTIONS_LOOT_FILTERS)
	end)
end

local loaded = false
local function LoadNotCollectedItems()
	RSLogger:PrintMessage(AL["LOG_FETCHING_COLLECTIONS"])
	
	-- Prepare not collected queries routines
	local routines = {}
	UpdateNotCollectedToys(routines)
	UpdateNotCollectedPetIDs(routines)
	UpdateNotCollectedMountIDs(routines)
	UpdateNotCollectedAppearanceItemIDs(routines)
	
	-- Launch all the routines in order
	local chainRoutines = RSRoutines.ChainLoopRoutineNew()
	chainRoutines:Init(routines)
	chainRoutines:Run(function(context)
		loaded = true
		RSLogger:PrintMessage(AL["LOG_DONE"])
		RSLogger:PrintMessage(AL["LOG_FILTERING_ENTITIES"])
		UpdateEntitiesCollections()
	end)
end

local function FindProfile(name)
	local profiles = {}
	for _, v in pairs(private.dbm:GetProfiles(profiles)) do
		if (v == name) then
			return true
		end
	end
	
	return false
end

function RSCollectionsDB.ApplyCollectionsEntitiesFilters()	
	-- Creates profile backup if selected
	if (RSConfigDB.IsCreateProfileBackup()) then
		local name = GetUnitName("player", true)
		local realmName = GetRealmName()
		local currentProfile = private.dbm:GetCurrentProfile()
		if (name) then
			local i = 0
			local backupProfileName = string.format("%s-%s_col_%s", name, realmName, i)
			while (FindProfile(backupProfileName)) do
				i = i + 1
				backupProfileName = string.format("%s-%s_col_%s", name, realmName, i)
			end
			
			private.dbm:SetProfile(backupProfileName)
			private.dbm:CopyProfile(currentProfile, true)
			RSLogger:PrintMessage(string.format(AL["COLLECTION_FILTERS_PROFILE_BACKUP_CREATED"], backupProfileName))
		end
	end
	
	-- Loads all not collected items if not done in this session --
	if (not loaded) then
		LoadNotCollectedItems()
	else
		UpdateEntitiesCollections()
	end
end

function RSCollectionsDB.GetAllEntitiesCollectionsLoot()
	return private.dbglobal.entity_collections_loot
end