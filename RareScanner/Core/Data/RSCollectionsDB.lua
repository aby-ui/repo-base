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

---============================================================================
-- Transmog locations (added in 9.2.5)
---============================================================================

local TRANSMOG_LOCATIONS = {
	["HEADSLOT"] = { Enum.TransmogCollectionType.Head };
	["SHOULDERSLOT"] = { Enum.TransmogCollectionType.Shoulder };
	["BACKSLOT"] = { Enum.TransmogCollectionType.Back };
	["CHESTSLOT"] = { Enum.TransmogCollectionType.Chest };
	["SHIRTSLOT"] = { Enum.TransmogCollectionType.Shirt };
	["TABARDSLOT"] = { Enum.TransmogCollectionType.Tabard };
	["WRISTSLOT"] = { Enum.TransmogCollectionType.Wrist };
	["HANDSSLOT"] = { Enum.TransmogCollectionType.Hands };
	["WAISTSLOT"] = { Enum.TransmogCollectionType.Waist };
	["LEGSSLOT"] = { Enum.TransmogCollectionType.Legs };
	["FEETSLOT"] = { Enum.TransmogCollectionType.Feet };
	["MAINHANDSLOT"] = { Enum.TransmogCollectionType.Wand, Enum.TransmogCollectionType.OneHAxe, Enum.TransmogCollectionType.OneHSword, Enum.TransmogCollectionType.OneHMace, Enum.TransmogCollectionType.Dagger, Enum.TransmogCollectionType.Fist, Enum.TransmogCollectionType.TwoHAxe, Enum.TransmogCollectionType.TwoHSword, Enum.TransmogCollectionType.TwoHMace, Enum.TransmogCollectionType.Staff, Enum.TransmogCollectionType.Polearm, Enum.TransmogCollectionType.Bow, Enum.TransmogCollectionType.Gun, Enum.TransmogCollectionType.Crossbow, Enum.TransmogCollectionType.Warglaives, Enum.TransmogCollectionType.Paired };
	["SECONDARYHANDSLOT"] = { Enum.TransmogCollectionType.Shield, Enum.TransmogCollectionType.Holdable };
}

---============================================================================
-- Manage database
---============================================================================

local function ResetEntitiesCollectionsLoot(manualScan)
	-- If the version didnt change, then there is no need to clear the whole database
	if (not private.dbglobal.lastCollectionsScanVersion) then
		private.dbglobal.lastCollectionsScanVersion = {}
	end
	
	if (not private.dbglobal.lastCollectionsScanVersion[RSConstants.CURRENT_LOOT_DB_VERSION]) then
		private.dbglobal.lastCollectionsScanVersion[RSConstants.CURRENT_LOOT_DB_VERSION] = {}
		private.dbglobal.entity_collections_loot = {}
	elseif (not private.dbglobal.entity_collections_loot) then
		private.dbglobal.entity_collections_loot = {}
	end
	
	local _, _, classIndex = UnitClass("player");
	if (not private.dbglobal.lastCollectionsScanVersion[RSConstants.CURRENT_LOOT_DB_VERSION][classIndex]) then
		private.dbglobal.lastCollectionsScanVersion[RSConstants.CURRENT_LOOT_DB_VERSION][classIndex] = true
	end
	
	-- Resets common loot and its class missing appearances
	if (manualScan) then
		for i, source in pairs (RSConstants.ITEM_SOURCE) do
			if (private.dbglobal.entity_collections_loot[source]) then
				for entityID, itemTypes in pairs (private.dbglobal.entity_collections_loot[source]) do
					for itemType, _ in pairs (private.dbglobal.entity_collections_loot[source][entityID]) do
						if (itemType ~= RSConstants.ITEM_TYPE.APPEARANCE) then
							private.dbglobal.entity_collections_loot[source][entityID][itemType] = nil
						else
							for classID, _ in pairs (private.dbglobal.entity_collections_loot[source][entityID][itemType]) do
								if (classID == classIndex) then
									private.dbglobal.entity_collections_loot[source][entityID][itemType][classIndex] = nil
								end
							end
							
							if (RSUtils.GetTableLength(private.dbglobal.entity_collections_loot[source][entityID][itemType][classIndex]) == 0) then
								private.dbglobal.entity_collections_loot[source][entityID][itemType][classIndex] = nil
							end
						end
						
						if (RSUtils.GetTableLength(private.dbglobal.entity_collections_loot[source][entityID][itemType]) == 0) then
								private.dbglobal.entity_collections_loot[source][entityID][itemType] = nil
							end
					end
					
					if (RSUtils.GetTableLength(private.dbglobal.entity_collections_loot[source][entityID]) == 0) then
						private.dbglobal.entity_collections_loot[source][entityID] = nil
					end
				end
				
				if (RSUtils.GetTableLength(private.dbglobal.entity_collections_loot[source]) == 0) then
					private.dbglobal.entity_collections_loot[source] = nil
				end
			end
		end
	end
end

local function UpdateEntityCollection(itemID, entityID, source, itemType)
	if (not RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source]) then
		RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source] = {}
	end
	
	if (not RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID]) then
		RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID] = {}
	end
	
	if (not RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID][itemType]) then
		RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID][itemType] = {}
	end
	
	if (itemType == RSConstants.ITEM_TYPE.APPEARANCE) then
		local _, _, classIndex = UnitClass("player");
		if (not RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID][itemType][classIndex]) then
			RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID][itemType][classIndex] = {}
		end
		
		if (not RSUtils.Contains(RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID][itemType][classIndex], itemID)) then
			table.insert(RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID][itemType][classIndex], itemID)
			RSLogger:PrintDebugMessage(string.format("UpdateEntityCollection: Añadido itemID [%s], del tipo [%s], clase [%s], para la entidad [%s]. Origen [%s].", itemID, itemType, classIndex, entityID, source))
		end
	elseif (not RSUtils.Contains(RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID][itemType], itemID)) then
		table.insert(RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID][itemType], itemID)
		RSLogger:PrintDebugMessage(string.format("UpdateEntityCollection: Añadido itemID [%s], del tipo [%s], para la entidad [%s]. Origen [%s].", itemID, itemType, entityID, source))
	end
end

---============================================================================
-- Toys
---============================================================================

local function UpdateNotCollectedToys(routines, routineTextOutput)
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
	local notCollectedToyRoutine = RSRoutines.LoopIndexRoutineNew()
	notCollectedToyRoutine:Init(C_ToyBox.GetNumFilteredToys, 50, 
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
			
			if (routineTextOutput) then
				routineTextOutput:SetText(string.format(AL["EXPLORER_MISSING_TOYS"], RSUtils.GetTableLength(private.dbglobal.not_colleted_toys)))
			end
		end
	)
	table.insert(routines, notCollectedToyRoutine)
end

local function GetNotCollectedToys()
	return private.dbglobal.not_colleted_toys
end

local function CheckUpdateToy(itemID, entityID, source, checkedItems)
	-- If cached use it
	if (checkedItems[RSConstants.ITEM_TYPE.TOY][itemID]) then
		UpdateEntityCollection(itemID, entityID, source, RSConstants.ITEM_TYPE.TOY)
	else
		if (RSUtils.Contains(GetNotCollectedToys(), itemID)) then
			UpdateEntityCollection(itemID, entityID, source, RSConstants.ITEM_TYPE.TOY)
			checkedItems[RSConstants.ITEM_TYPE.TOY][itemID] = true
			return true
		end
	
		return false
	end
end

function RSCollectionsDB.RemoveNotCollectedToy(itemID, callback) --NEW_TOY_ADDED
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
			for entityID, itemTypes in pairs (RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source]) do
				local lootList = RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID][RSConstants.ITEM_TYPE.TOY]
				if (lootList) then
					for i = #lootList, 1, -1 do
						if (lootList[i] == itemID) then
							if (table.getn(lootList) == 1) then
								RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID][RSConstants.ITEM_TYPE.TOY] = nil
							else
								RSLogger:PrintDebugMessage(string.format("RemoveNotCollectedToy[%s]: Eliminado coleccionable de la lista de la entidad [%s].", itemID, entityID))
								table.remove(lootList, i)
							end
							
							-- Check if the entity doesn't have more collections
							if (RSUtils.GetTableLength(RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID]) == 0) then
								RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID] = nil
								
								-- Filter
								if (RSConfigDB.IsAutoFilteringOnCollect()) then
									if (source == RSConstants.ITEM_SOURCE.NPC) then
										RSConfigDB.SetNpcFiltered(entityID, false)
										RSLogger:PrintDebugMessage(string.format("RemoveNotCollectedToy[%s]: Filtrado NPC [%s] por no disponer de mas coleccionables.", itemID, entityID))
										if (RSNpcDB.GetNpcName(entityID)) then
											RSLogger:PrintMessage(string.format(AL["EXPLORER_AUTOFILTER"], RSNpcDB.GetNpcName(entityID)))
										end
									elseif (source == RSConstants.ITEM_SOURCE.CONTAINER) then
										RSConfigDB.SetContainerFiltered(entityID, false)
										RSLogger:PrintDebugMessage(string.format("RemoveNotCollectedToy[%s]: Filtrado Contenedor [%s] por no disponer de mas coleccionables.", itemID, entityID))
										if (RSContainerDB.GetContainerName(entityID)) then
											RSLogger:PrintMessage(string.format(AL["EXPLORER_AUTOFILTER"], RSContainerDB.GetContainerName(entityID)))
										end
									end
								end
							end
							
							if (callback) then
								callback()
							end
							
							break
						end
					end
				end
			end
		end
    end
end

---============================================================================
-- Pets
---============================================================================

local function UpdateNotCollectedPetIDs(routines, routineTextOutput)
	-- Backup settings
	local filterCollected = C_PetJournal.IsFilterChecked(LE_PET_JOURNAL_FILTER_COLLECTED)
	local filterNotCollected = C_PetJournal.IsFilterChecked(LE_PET_JOURNAL_FILTER_NOT_COLLECTED)
	
	-- Prepare filters
	C_PetJournal.SetFilterChecked(LE_PET_JOURNAL_FILTER_COLLECTED, false)
	C_PetJournal.SetFilterChecked(LE_PET_JOURNAL_FILTER_NOT_COLLECTED, true)
	C_PetJournal.SetAllPetTypesChecked(true)
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
			
			if (routineTextOutput) then
				routineTextOutput:SetText(string.format(AL["EXPLORER_MISSING_PETS"], RSUtils.GetTableLength(private.dbglobal.not_colleted_pets_ids)))
			end
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
	if (checkedItems[RSConstants.ITEM_TYPE.PET][itemID]) then
		UpdateEntityCollection(itemID, entityID, source, RSConstants.ITEM_TYPE.PET)
	else
		local creatureID = GetPetID(itemID)
		if (creatureID) then			
			if (RSUtils.Contains(GetNotCollectedPetsIDs(), creatureID)) then
				UpdateEntityCollection(itemID, entityID, source, RSConstants.ITEM_TYPE.PET)
				checkedItems[RSConstants.ITEM_TYPE.PET][itemID] = true
			end
			
			return true
		end
		
		return false
	end
end

function RSCollectionsDB.RemoveNotCollectedPet(petGUID, callback) --NEW_PET_ADDED
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
			for entityID, itemTypes in pairs (RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source]) do
				local lootList = RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID][RSConstants.ITEM_TYPE.PET]
				if (lootList) then
					for i = #lootList, 1, -1 do
						if (lootList[i] == GetPetItemID(creatureID)) then
							if (table.getn(lootList) == 1) then
								RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID][RSConstants.ITEM_TYPE.PET] = nil
							else
								RSLogger:PrintDebugMessage(string.format("RemoveNotCollectedPet[%s]: Eliminado coleccionable de la lista de la entidad [%s].", petGUID, entityID))
								table.remove(lootList, i)
							end
							
							-- Check if the entity doesn't have more collections
							if (RSUtils.GetTableLength(RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID]) == 0) then
								RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID] = nil
								
								-- Filter
								if (RSConfigDB.IsAutoFilteringOnCollect()) then
									if (source == RSConstants.ITEM_SOURCE.NPC) then
										RSConfigDB.SetNpcFiltered(entityID, false)
										RSLogger:PrintDebugMessage(string.format("RemoveNotCollectedPet[%s]: Filtrado NPC [%s] por no disponer de mas coleccionables.", petGUID, entityID))
										if (RSNpcDB.GetNpcName(entityID)) then
											RSLogger:PrintMessage(string.format(AL["EXPLORER_AUTOFILTER"], RSNpcDB.GetNpcName(entityID)))
										end
									elseif (source == RSConstants.ITEM_SOURCE.CONTAINER) then
										RSConfigDB.SetContainerFiltered(entityID, false)
										RSLogger:PrintDebugMessage(string.format("RemoveNotCollectedPet[%s]: Filtrado Contenedor [%s] por no disponer de mas coleccionables.", petGUID, entityID))
										if (RSContainerDB.GetContainerName(entityID)) then
											RSLogger:PrintMessage(string.format(AL["EXPLORER_AUTOFILTER"], RSContainerDB.GetContainerName(entityID)))
										end
									end
								end
							end
							
							if (callback) then
								callback()
							end
							
							break
						end
					end
				end
			end
		end
    end
end

---============================================================================
-- Mounts
---============================================================================

local function UpdateNotCollectedMountIDs(routines, routineTextOutput)
	-- Backup settings
	local colletedFilter = C_MountJournal.GetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_NOT_COLLECTED)
	local notColletedFilter = C_MountJournal.GetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_NOT_COLLECTED)
	local notUnusableFilter = C_MountJournal.GetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_UNUSABLE)
	
	-- Prepare filters
	C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_COLLECTED, false);
	C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_NOT_COLLECTED, true);
	C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_UNUSABLE, true);
	C_MountJournal.SetSearch("");
	C_MountJournal.SetAllSourceFilters(true)
	C_MountJournal.SetAllTypeFilters(true)
	
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
			-- Recover settings
			C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_COLLECTED, colletedFilter);
			C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_NOT_COLLECTED, notColletedFilter);
			C_MountJournal.SetCollectedFilterSetting(LE_MOUNT_JOURNAL_FILTER_UNUSABLE, notUnusableFilter);
			
			RSLogger:PrintDebugMessage(string.format("UpdateNotCollectedMountIDs. [%s no conseguidas].", RSUtils.GetTableLength(private.dbglobal.not_colleted_mounts_ids)))
			
			if (routineTextOutput) then
				routineTextOutput:SetText(string.format(AL["EXPLORER_MISSING_MOUNTS"], RSUtils.GetTableLength(private.dbglobal.not_colleted_mounts_ids)))
			end
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
			if (RSUtils.Contains(internalItemID, itemID)) then
				return mountID
			end
		end
	end
	
	return nil
end

local function CheckUpdateMount(itemID, entityID, source, checkedItems)
	-- If cached use it
	if (checkedItems[RSConstants.ITEM_TYPE.MOUNT][itemID]) then
		UpdateEntityCollection(itemID, entityID, source, RSConstants.ITEM_TYPE.MOUNT)
	else
		local mountID = GetMountID(itemID)
		if (mountID) then		
			if (RSUtils.Contains(GetNotCollectedMountsIDs(), mountID)) then
				UpdateEntityCollection(itemID, entityID, source, RSConstants.ITEM_TYPE.MOUNT)
				checkedItems[RSConstants.ITEM_TYPE.MOUNT][itemID] = true
			end
			
			return true
		end
		
		return false
	end
end

function RSCollectionsDB.RemoveNotCollectedMount(mountID, callback) --NEW_MOUNT_ADDED
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
			for entityID, itemTypes in pairs (RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source]) do
				local lootList = RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID][RSConstants.ITEM_TYPE.MOUNT]
				if (lootList) then
					for i = #lootList, 1, -1 do
						if (RSUtils.Contains(GetMountItemID(mountID), lootList[i])) then
							if (table.getn(lootList) == 1) then
								RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID][RSConstants.ITEM_TYPE.MOUNT] = nil
							else
								RSLogger:PrintDebugMessage(string.format("RemoveNotCollectedMount[%s]: Eliminado coleccionable de la lista de la entidad [%s].", mountID, entityID))
								table.remove(lootList, i)
							end
							
							-- Check if the entity doesn't have more collections
							if (RSUtils.GetTableLength(RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID]) == 0) then
								RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID] = nil
								
								-- Filter
								if (RSConfigDB.IsAutoFilteringOnCollect()) then
									if (source == RSConstants.ITEM_SOURCE.NPC) then
										RSConfigDB.SetNpcFiltered(entityID, false)
										RSLogger:PrintDebugMessage(string.format("RemoveNotCollectedMount[%s]: Filtrado NPC [%s] por no disponer de mas coleccionables.", mountID, entityID))
										if (RSNpcDB.GetNpcName(entityID)) then
											RSLogger:PrintMessage(string.format(AL["EXPLORER_AUTOFILTER"], RSNpcDB.GetNpcName(entityID)))
										end
									elseif (source == RSConstants.ITEM_SOURCE.CONTAINER) then
										RSConfigDB.SetContainerFiltered(entityID, false)
										RSLogger:PrintDebugMessage(string.format("RemoveNotCollectedMount[%s]: Filtrado Contenedor [%s] por no disponer de mas coleccionables.", mountID, entityID))
										if (RSContainerDB.GetContainerName(entityID)) then
											RSLogger:PrintMessage(string.format(AL["EXPLORER_AUTOFILTER"], RSContainerDB.GetContainerName(entityID)))
										end
									end
								end
							end
							
							if (callback) then
								callback()
							end
							
							break
						end
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

local function UpdateNotCollectedAppearanceItemIDs(routines, routineTextOutput)
	private.dbchar.not_colleted_appearances_item_ids = {}
	
	-- Query	
	for transmogLocationName, transmogCollectionTypes in pairs (TRANSMOG_LOCATIONS) do
		local transmogLocation = TransmogUtil.GetTransmogLocation(transmogLocationName, Enum.TransmogType.Appearance, Enum.TransmogModification.Main)
		for _, categoryID in ipairs (transmogCollectionTypes) do
			local name, _, _, _, _ = C_TransmogCollection.GetCategoryInfo(categoryID) -- Returns name only for the current class proficiencie, so if there is no name, this class cannot transmog it
			local visualsList = C_TransmogCollection.GetCategoryAppearances(categoryID, transmogLocation)
			if (name and visualsList) then
				local notCollectedAppearanceItemIDs = RSRoutines.LoopIndexRoutineNew()
				notCollectedAppearanceItemIDs:Init(C_TransmogCollection.GetCategoryAppearances, 100, 
					function(context, j)
						if (not context.counter) then
							context.counter = 0
						end
						if (not visualsList[j].isCollected) then
							context.counter = context.counter + 1
							local sources = C_TransmogCollection.GetAppearanceSources(visualsList[j].visualID, context.arguments[1], context.arguments[2])
							for k = 1, #sources do
								if (sources[k].sourceType == 4 or sources[k].sourceType == 2) then --World drop/quest
									AddAppearanceItemID(sources[k].visualID, sources[k].itemID)
							
									if (not private.dbchar.not_colleted_appearances_item_ids[sources[k].itemID]) then
										private.dbchar.not_colleted_appearances_item_ids[sources[k].itemID] = true
									end
								end
							end
						end
					end,
					function(context)
						local name, _, _, _, _ = C_TransmogCollection.GetCategoryInfo(context.arguments[1])
						RSLogger:PrintDebugMessage(string.format("UpdateNotCollectedAppearanceItemIDs. [%s] [%s no conseguidas].", name, context.counter or "0"))
						
						if (routineTextOutput) then
							routineTextOutput:SetText(string.format(AL["EXPLORER_MISSING_APPEARANCES"], context.counter or "0", name))
						end
					end,
					categoryID,
					transmogLocation
				)
				table.insert(routines, notCollectedAppearanceItemIDs)
			end
		end
	end
end

local function GetNotCollectedAppearanceItemIDs()
	return private.dbchar.not_colleted_appearances_item_ids
end

local function DropNotCollectedAppearance(appearanceID)
	if (private.dbglobal.appearances_item_id and appearanceID and private.dbglobal.appearances_item_id[appearanceID]) then
		if (GetNotCollectedAppearanceItemIDs()) then
			local itemIDs = private.dbglobal.appearances_item_id[appearanceID]
			for _, itemID in ipairs (itemIDs) do
				if (GetNotCollectedAppearanceItemIDs()[itemID]) then
					RSLogger:PrintDebugMessage(string.format("DropNotCollectedAppearance[%s]. Eliminado item [%s].", appearanceID, itemID))
					GetNotCollectedAppearanceItemIDs()[itemID] = nil
				end
			end
		end

		private.dbglobal.appearances_item_id[appearanceID] = nil
		RSLogger:PrintDebugMessage(string.format("DropNotCollectedAppearance[%s]. Eliminada apariencia.", appearanceID))
		
		return true
	end
	
	return false
end

local function CheckUpdateAppearance(itemID, entityID, source, checkedItems)
	-- If cached use it
	if (checkedItems[RSConstants.ITEM_TYPE.APPEARANCE][itemID]) then
		UpdateEntityCollection(itemID, entityID, source, RSConstants.ITEM_TYPE.APPEARANCE)
		
		return true
	-- Otherwise query
	else				
		if (GetNotCollectedAppearanceItemIDs() and GetNotCollectedAppearanceItemIDs()[itemID]) then
			UpdateEntityCollection(itemID, entityID, source, RSConstants.ITEM_TYPE.APPEARANCE)
			
			if (not checkedItems[RSConstants.ITEM_TYPE.APPEARANCE][itemID]) then
				checkedItems[RSConstants.ITEM_TYPE.APPEARANCE][itemID] = true
			end
			
			return true
		end
		
		return false
	end
end

function RSCollectionsDB.IsNotcollectedAppearance(itemID)
	if (not GetNotCollectedAppearanceItemIDs()) then
		return nil
	end
	
	if (GetNotCollectedAppearanceItemIDs()[itemID]) then
		return true
	end
	
	return false
end

function RSCollectionsDB.RemoveNotCollectedAppearance(appearanceID, callback) --TRANSMOG_COLLECTION_UPDATED
	if (appearanceID and GetAppearanceItemIDs(appearanceID) and table.getn(GetAppearanceItemIDs(appearanceID)) ~= nil) then	
		RSLogger:PrintDebugMessage(string.format("RemoveNotCollectedAppearance[%s]", appearanceID))
		
		local routines = {}
	
		-- Update filters
		for source, info in pairs (RSCollectionsDB.GetAllEntitiesCollectionsLoot()) do
			local removeNotCollectedAppearanceRoutine = RSRoutines.LoopRoutineNew()
			removeNotCollectedAppearanceRoutine:Init(function() return RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source] end, 20,
				function(context, entityID, _)
					local classIndexes = RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID][RSConstants.ITEM_TYPE.APPEARANCE]
					if (classIndexes) then
						for classIndex, lootList in pairs (classIndexes) do
							for i = #lootList, 1, -1 do
								if (RSUtils.Contains(GetAppearanceItemIDs(appearanceID), lootList[i])) then
									if (table.getn(lootList) == 1) then
										RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID][RSConstants.ITEM_TYPE.APPEARANCE][classIndex] = nil
									else
										RSLogger:PrintDebugMessage(string.format("RemoveNotCollectedAppearance[%s]: Eliminado coleccionable de la lista de la entidad [%s].", appearanceID, entityID))
										table.remove(lootList, i)
									end
									
									-- Check if the entity doesn't have more collections for other classes
									if (RSUtils.GetTableLength(RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID][RSConstants.ITEM_TYPE.APPEARANCE]) == 0) then
										RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID][RSConstants.ITEM_TYPE.APPEARANCE] = nil
									end
									
									-- Check if the entity doesn't have more collections
									if (RSUtils.GetTableLength(RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID]) == 0) then
										RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source][entityID] = nil
										
										-- Filter
										if (RSConfigDB.IsAutoFilteringOnCollect()) then
											if (source == RSConstants.ITEM_SOURCE.NPC) then
												RSConfigDB.SetNpcFiltered(entityID, false)
												RSLogger:PrintDebugMessage(string.format("RemoveNotCollectedAppearance[%s]: Filtrado NPC [%s] por no disponer de mas coleccionables.", appearanceID, entityID))
												if (RSNpcDB.GetNpcName(entityID)) then
													RSLogger:PrintMessage(string.format(AL["EXPLORER_AUTOFILTER"], RSNpcDB.GetNpcName(entityID)))
												end
											elseif (source == RSConstants.ITEM_SOURCE.CONTAINER) then
												RSConfigDB.SetContainerFiltered(entityID, false)
												RSLogger:PrintDebugMessage(string.format("RemoveNotCollectedAppearance[%s]: Filtrado Contenedor [%s] por no disponer de mas coleccionables.", appearanceID, entityID))
												if (RSContainerDB.GetContainerName(entityID)) then
													RSLogger:PrintMessage(string.format(AL["EXPLORER_AUTOFILTER"], RSContainerDB.GetContainerName(entityID)))
												end
											end
										end
									end
									
									break
								end
							end
						end
					end
				end,
				function(context) end
			)
			tinsert(routines, removeNotCollectedAppearanceRoutine)
		end
		
		local chainRoutines = RSRoutines.ChainLoopRoutineNew()
		chainRoutines:Init(routines)
		chainRoutines:Run(function(context)
			-- Drops not collected appearance
			local dropped = DropNotCollectedAppearance(appearanceID)
			if (dropped and callback) then
				callback()
			end
		end)
    end
end

---============================================================================
-- Collections database
---============================================================================

local function CheckUpdateCollectibles(checkedItems, getter, source, routines, routineTextOutput)
	local checkUpdateCollectiblesRoutine = RSRoutines.LoopRoutineNew()
	checkUpdateCollectiblesRoutine:Init(getter, 30, 
		function(context, entityID, items)
			for _, itemID in ipairs (items) do
				if (not checkedItems[itemID]) then							
					-- Check if appearance
					if (not checkedItems[RSConstants.ITEM_TYPE.TOY][itemID] and not checkedItems[RSConstants.ITEM_TYPE.PET][itemID] and not checkedItems[RSConstants.ITEM_TYPE.MOUNT][itemID]) then
						CheckUpdateAppearance(itemID, entityID, source, checkedItems)
					end
					
					-- Check if toy
					if (not checkedItems[RSConstants.ITEM_TYPE.APPEARANCE][itemID] and not checkedItems[RSConstants.ITEM_TYPE.PET][itemID] and not checkedItems[RSConstants.ITEM_TYPE.MOUNT][itemID]) then
						CheckUpdateToy(itemID, entityID, source, checkedItems)
					end
							
					-- Check if pet
					if (not checkedItems[RSConstants.ITEM_TYPE.APPEARANCE][itemID] and not checkedItems[RSConstants.ITEM_TYPE.TOY][itemID] and not checkedItems[RSConstants.ITEM_TYPE.MOUNT][itemID]) then
						CheckUpdatePet(itemID, entityID, source, checkedItems)
					end
					
					-- Check if mount
					if (not checkedItems[RSConstants.ITEM_TYPE.APPEARANCE][itemID] and not checkedItems[RSConstants.ITEM_TYPE.TOY][itemID] and not checkedItems[RSConstants.ITEM_TYPE.PET][itemID]) then
						CheckUpdateMount(itemID, entityID, source, checkedItems)
					end
					
					if (not checkedItems[RSConstants.ITEM_TYPE.APPEARANCE][itemID] and not checkedItems[RSConstants.ITEM_TYPE.PET][itemID] and not checkedItems[RSConstants.ITEM_TYPE.TOY][itemID] and not checkedItems[RSConstants.ITEM_TYPE.MOUNT][itemID]) then
						checkedItems[itemID] = true
					end
				end
			end
		end,
		function(context)
			RSLogger:PrintDebugMessage(string.format("CheckUpdateCollectibles. [%s]. Finalizado.", source == RSConstants.ITEM_SOURCE.NPC and "NPCs" or "Contenedores"))
			
			if (routineTextOutput) then
				if (source == RSConstants.ITEM_SOURCE.NPC) then
					routineTextOutput:SetText(string.format(AL["EXPLORER_FOUND_NPCS"], RSUtils.GetTableLength(RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source])))
				else
					routineTextOutput:SetText(string.format(AL["EXPLORER_FOUND_CONTAINERS"], RSUtils.GetTableLength(RSCollectionsDB.GetAllEntitiesCollectionsLoot()[source])))
				end
			end
		end
	)
	table.insert(routines, checkUpdateCollectiblesRoutine)
end

local function UpdateEntitiesCollections(callback, routineTextOutput, manualScan)
	-- Reset outdated data
	ResetEntitiesCollectionsLoot(manualScan)
	
	local checkedItems = {}
	checkedItems[RSConstants.ITEM_TYPE.APPEARANCE] = {}
	checkedItems[RSConstants.ITEM_TYPE.TOY] = {}
	checkedItems[RSConstants.ITEM_TYPE.PET] = {}
	checkedItems[RSConstants.ITEM_TYPE.MOUNT] = {}
	
	local routines = {}
	
	-- Sync npc loot
	CheckUpdateCollectibles(checkedItems, RSNpcDB.GetAllInteralNpcLoot, RSConstants.ITEM_SOURCE.NPC, routines, routineTextOutput)
	RSLogger:PrintDebugMessage("UpdateEntitiesCollections. Actualizada la lista de collecionables de NPCs no conseguidos.")
	
	-- Sync container loot
	CheckUpdateCollectibles(checkedItems, RSContainerDB.GetAllInteralContainerLoot, RSConstants.ITEM_SOURCE.CONTAINER, routines, routineTextOutput)
	RSLogger:PrintDebugMessage("UpdateEntitiesCollections. Actualizada la lista de collecionables de contenedores no conseguidos.")
		
	-- Launch all the routines in order
	local chainRoutines = RSRoutines.ChainLoopRoutineNew()
	chainRoutines:Init(routines)
	chainRoutines:Run(function(context)
		checkedItems = nil
		RSLogger:PrintMessage(AL["LOG_DONE"])
		RSLogger:PrintDebugMessage("UpdateEntitiesCollections: Finalizado proceso.")
		callback()
	end)
end

local loaded = false
local function LoadNotCollectedItems(callback, routineTextOutput, manualScan)
	RSLogger:PrintMessage(AL["LOG_FETCHING_COLLECTIONS"])
	
	-- Prepare not collected queries routines
	local routines = {}
	UpdateNotCollectedToys(routines, routineTextOutput)
	UpdateNotCollectedPetIDs(routines, routineTextOutput)
	UpdateNotCollectedMountIDs(routines, routineTextOutput)
	UpdateNotCollectedAppearanceItemIDs(routines, routineTextOutput)
	
	-- Launch all the routines in order
	local chainRoutines = RSRoutines.ChainLoopRoutineNew()
	chainRoutines:Init(routines)
	chainRoutines:Run(function(context)
		loaded = true
		RSLogger:PrintMessage(AL["LOG_DONE"])
		RSLogger:PrintMessage(AL["LOG_FILTERING_ENTITIES"])
		UpdateEntitiesCollections(callback, routineTextOutput, manualScan)
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

function RSCollectionsDB.ApplyCollectionsEntitiesFilters(callback, routineTextOutput, manualScan)	
	-- Loads all not collected items if not done in this session --
	if (not loaded) then
		LoadNotCollectedItems(callback, routineTextOutput, manualScan)
	else
		UpdateEntitiesCollections(callback, routineTextOutput, manualScan)
	end
end

function RSCollectionsDB.ApplyFilters(filters, callback)	
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
	
	local routines = {}
	
	-- Filter all NPCs
	RSConfigDB.FilterAllNPCs(routines)
	RSConfigDB.FilterAllContainers(routines)
	
	-- Remove filters for NPCs with collections
	if (RSCollectionsDB.GetAllEntitiesCollectionsLoot() and RSCollectionsDB.GetAllEntitiesCollectionsLoot()[RSConstants.ITEM_SOURCE.NPC]) then
		local collectionsLoot = RSCollectionsDB.GetAllEntitiesCollectionsLoot()[RSConstants.ITEM_SOURCE.NPC]
		local _, _, classIndex = UnitClass("player");
		
		local removeNPCFilterByCollectionRoutine = RSRoutines.LoopRoutineNew()
		removeNPCFilterByCollectionRoutine:Init(RSNpcDB.GetAllInternalNpcInfo, 500, 
			function(context, npcID, _)
				local removeFilter = false
				if (filters[RSConstants.EXPLORER_FILTER_DROP_MOUNTS] and collectionsLoot[npcID] and RSUtils.GetTableLength(collectionsLoot[npcID][RSConstants.ITEM_TYPE.MOUNT]) > 0) then
					removeFilter = true
				elseif (filters[RSConstants.EXPLORER_FILTER_DROP_PETS] and collectionsLoot[npcID] and RSUtils.GetTableLength(collectionsLoot[npcID][RSConstants.ITEM_TYPE.PET]) > 0) then
					removeFilter = true
				elseif (filters[RSConstants.EXPLORER_FILTER_DROP_TOYS] and collectionsLoot[npcID] and RSUtils.GetTableLength(collectionsLoot[npcID][RSConstants.ITEM_TYPE.TOY]) > 0) then
					removeFilter = true
				elseif (filters[RSConstants.EXPLORER_FILTER_DROP_APPEARANCES] and collectionsLoot[npcID] and collectionsLoot[npcID][RSConstants.ITEM_TYPE.APPEARANCE] and RSUtils.GetTableLength(collectionsLoot[npcID][RSConstants.ITEM_TYPE.APPEARANCE][classIndex]) > 0) then
					removeFilter = true
				end
				
				if (removeFilter) then
					RSConfigDB.SetNpcFiltered(npcID, true)
					
					for npcIDpostEvent, npcIDPpreEvent in pairs (RSConstants.NPCS_WITH_PRE_NPCS) do
						if (npcIDpostEvent == npcID or npcIDPpreEvent == npcID) then
							RSConfigDB.SetNpcFiltered(npcIDpostEvent, true)
							RSConfigDB.SetNpcFiltered(npcIDPpreEvent, true)
							break
						end
					end
				end
			end,
			function(context)
				RSLogger:PrintDebugMessage("ApplyFilters. Eliminados filtros de NPCs con coleccionables aun no conseguidos")
			end
		)
		table.insert(routines, removeNPCFilterByCollectionRoutine)
	end
	
	-- Remove filters for Containers with collections
	if (RSCollectionsDB.GetAllEntitiesCollectionsLoot() and RSCollectionsDB.GetAllEntitiesCollectionsLoot()[RSConstants.ITEM_SOURCE.CONTAINER]) then
		local collectionsLoot = RSCollectionsDB.GetAllEntitiesCollectionsLoot()[RSConstants.ITEM_SOURCE.CONTAINER]
		local _, _, classIndex = UnitClass("player");
		
		local removeContainerFilterByCollectionRoutine = RSRoutines.LoopRoutineNew()
		removeContainerFilterByCollectionRoutine:Init(RSContainerDB.GetAllInternalContainerInfo, 500, 
			function(context, containerID, _)
				local removeFilter = false
				if (filters[RSConstants.EXPLORER_FILTER_DROP_MOUNTS] and collectionsLoot[containerID] and RSUtils.GetTableLength(collectionsLoot[containerID][RSConstants.ITEM_TYPE.MOUNT]) > 0) then
					removeFilter = true
				elseif (filters[RSConstants.EXPLORER_FILTER_DROP_PETS] and collectionsLoot[containerID] and RSUtils.GetTableLength(collectionsLoot[containerID][RSConstants.ITEM_TYPE.PET]) > 0) then
					removeFilter = true
				elseif (filters[RSConstants.EXPLORER_FILTER_DROP_TOYS] and collectionsLoot[containerID] and RSUtils.GetTableLength(collectionsLoot[containerID][RSConstants.ITEM_TYPE.TOY]) > 0) then
					removeFilter = true
				elseif (filters[RSConstants.EXPLORER_FILTER_DROP_APPEARANCES] and collectionsLoot[containerID] and collectionsLoot[containerID][RSConstants.ITEM_TYPE.APPEARANCE] and RSUtils.GetTableLength(collectionsLoot[containerID][RSConstants.ITEM_TYPE.APPEARANCE][classIndex]) > 0) then
					removeFilter = true
				end
				
				if (removeFilter) then
					RSConfigDB.SetContainerFiltered(containerID, true)
				end
			end,
			function(context)
				RSLogger:PrintDebugMessage("ApplyFilters. Eliminados filtros de Contenedores con coleccionables aun no conseguidos")
			end
		)
		table.insert(routines, removeContainerFilterByCollectionRoutine)
	end
			
	-- Launch all the routines in order
	local chainRoutines = RSRoutines.ChainLoopRoutineNew()
	chainRoutines:Init(routines)
	chainRoutines:Run(function(context)	
		RSLogger:PrintDebugMessage("ApplyFilters: Finalizado proceso.")
		
		if (callback) then
			callback()
		end
	end)
end

function RSCollectionsDB.GetAllEntitiesCollectionsLoot()
	return private.dbglobal.entity_collections_loot
end

function RSCollectionsDB.IsCollectionsScanDoneWithCurrentVersion()
	if (private.dbglobal.lastCollectionsScanVersion and private.dbglobal.lastCollectionsScanVersion[RSConstants.CURRENT_LOOT_DB_VERSION]) then
		return true
	end
	
	return false
end

function RSCollectionsDB.IsCollectionsScanByClassDone()
	local _, _, classIndex = UnitClass("player");
	if (private.dbglobal.lastCollectionsScanVersion and private.dbglobal.lastCollectionsScanVersion[RSConstants.CURRENT_LOOT_DB_VERSION]) then
		return private.dbglobal.lastCollectionsScanVersion[RSConstants.CURRENT_LOOT_DB_VERSION][classIndex]
	end
	
	return nil
end