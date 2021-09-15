-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

local RSLoot = private.NewLib("RareScannerLoot")

-- RareScanner database libraries
local RSConfigDB = private.ImportLib("RareScannerConfigDB")
local RSLootDB = private.ImportLib("RareScannerLootDB")

-- RareScanner general libraries
local RSLogger = private.ImportLib("RareScannerLogger")
local RSUtils = private.ImportLib("RareScannerUtils")
local RSTooltipScanners = private.ImportLib("RareScannerTooltipScanners")

---============================================================================
-- Filters to apply to the loot displayed under the main button and the worldmap
---============================================================================

local conduits = {}
local function IsConduitAlreadyCollected(itemID)
	if (not itemID) then
		return false;
	end
	
	-- load collected conduits the first time
	if (next(conduits) == nil) then
		for conduitType = 0, 3 do
			for _, collectionData in pairs(C_Soulbinds.GetConduitCollection(conduitType)) do
		        if (collectionData) then
					conduits[collectionData.conduitItemID] = true
				end
		    end
	    end
	elseif (conduits[itemID]) then
		return true
	end
	
	return false;
end

local function IsEquipable(itemClassID, itemSubClassID, itemEquipLoc)
	local _, _, classIndex = UnitClass("player");
	for categoryID, subcategories in pairs(private.CLASS_PROFICIENCIES[classIndex]) do
		if (categoryID == itemClassID) then
			if (not RSUtils.Contains(subcategories, itemSubClassID)) then
				return false
			end
			
			return true
		end
	end
	-- check if cloth and not cloak
	if (itemClassID == Enum.ItemClass.Armor and itemSubClassID == Enum.ItemArmorSubclass.Cloth and not RSUtils.Contains(private.CLOTH_CHARACTERES, classIndex) and itemEquipLoc ~= "INVTYPE_CLOAK") then --check if its cloth and not cloak
		return false
	end

	return true
end

local function IsToy(itemLink, itemID)
	if (RSLootDB.IsToy(itemID)) then
		return true
	elseif (RSTooltipScanners.ScanLoot(itemLink, TOY)) then
		RSLootDB.SetItemAsToy(itemID)
		return true
	end
end

local function IsFilteredByCategory(itemLink, itemID, itemClassID, itemSubClassID)
	-- If filtered by category
	if (RSConfigDB.GetLootFilterByCategory(itemClassID, itemSubClassID) == false) then
		-- We ignore toys from this filter because they are scattered all around
		if (IsToy(itemLink, itemID)) then
			return false
		end
		
		return true
	end
	
	return false
end

function RSLoot.IsFiltered(itemID, itemLink, itemRarity, itemEquipLoc, itemClassID, itemSubClassID)
	-- Quality filter
	if (itemRarity < tonumber(RSConfigDB.GetLootFilterMinQuality())) then
		RSLogger:PrintDebugMessageItemID(itemID, string.format("Item [%s]. Filtrado por su calidad.", itemID))
		return true
	end

	-- Category filter
	if (IsFilteredByCategory(itemLink, itemID, itemClassID, itemSubClassID)) then
		RSLogger:PrintDebugMessageItemID(itemID, string.format("Item [%s]. Filtrado por su categoria.", itemID))
		return true
	end
	
	-- Individual filter
	if (RSConfigDB.IsItemFiltered(itemID)) then
		RSLogger:PrintDebugMessageItemID(itemID, string.format("Item [%s]. Filtrado individualmente.", itemID))
		return true
	end

	-- Completed quests
	if (RSConfigDB.IsFilteringLootByCompletedQuest() and (itemClassID == Enum.ItemClass.Questitem or (itemClassID == Enum.ItemClass.Consumable and itemSubClassID == 8))) then --quest item
		local questIDs = RSLootDB.GetAssociatedQuestIDs(itemID)
		if (questIDs) then
			local filtered = false
			for i, questID in ipairs(questIDs) do
				if (C_QuestLog.IsQuestFlaggedCompleted(questID) or not C_TaskQuest.IsActive(questID)) then
					filtered = true
				else
					filtered = false
					break
				end
			end

			if (filtered) then
				RSLogger:PrintDebugMessageItemID(itemID, string.format("Item [%s]. Filtrado por su mision asociada.", itemID))
				return true;
			end
		end
	end

	-- Equipable filter
	if (RSConfigDB.IsFilteringLootByNotEquipableItems() and (itemClassID == Enum.ItemClass.Weapon or itemClassID == Enum.ItemClass.Armor)) then --weapons or armor
		if (not IsEquipable(itemClassID, itemSubClassID, itemEquipLoc)) then
			RSLogger:PrintDebugMessageItemID(itemID, string.format("Item [%s]. Filtrado por no ser equipable.", itemID))
			return true;
		end
	end

	-- Character class filter
	if (RSConfigDB.IsFilteringLootByNotMatchingClass() and RSTooltipScanners.ScanLoot(itemLink, string.gsub(ITEM_CLASSES_ALLOWED, ": %%s", ""))) then
		local localizedClass, _, _ = UnitClass("player")
		if (not RSTooltipScanners.ScanLoot(itemLink, localizedClass)) then
			RSLogger:PrintDebugMessageItemID(itemID, string.format("Item [%s]. Filtrado por clase.", itemID))
			return true;
		end
	end

	-- Character faction filter
	if (RSConfigDB.IsFilteringLootByNotMatchingFaction()) then
		local _, localizedFaction = UnitFactionGroup("player")
		if ((RSTooltipScanners.ScanLoot(itemLink, ITEM_REQ_ALLIANCE) and localizedFaction ~= FACTION_ALLIANCE) or (RSTooltipScanners.ScanLoot(itemLink, ITEM_REQ_HORDE) and localizedFaction ~= FACTION_HORDE)) then
			RSLogger:PrintDebugMessageItemID(itemID, string.format("Item [%s]. Filtrado por facción.", itemID))
			return true;
		end
	end

	-- Transmog filter
	if (RSConfigDB.IsFilteringLootByTransmog() and (itemClassID == Enum.ItemClass.Weapon or (itemClassID == Enum.ItemClass.Armor and itemSubClassID ~= Enum.ItemArmorSubclass.Generic))) then --weapons or armor (not rings, necks, etc.)
		if (not IsEquipable(itemClassID, itemSubClassID, itemEquipLoc)) then
			RSLogger:PrintDebugMessageItemID(itemID, string.format("Item [%s]. Filtrado por no ser equipable (Transmog check).", itemID))
			return true
		elseif (C_TransmogCollection.PlayerHasTransmog(itemID)) then
			RSLogger:PrintDebugMessageItemID(itemID, string.format("Item [%s]. Filtrado por ya tenerlo (Transmog check).", itemID))
			return true
		else
			if (not RSTooltipScanners.ScanLoot(itemLink, TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN)) then
				RSLogger:PrintDebugMessageItemID(itemID, string.format("Item [%s]. Filtrado por no ser transfigurable (Transmog check).", itemID))
				return true
			end
		end
	end

	-- Collection mount filter
	if (RSConfigDB.IsFilteringByCollected() and itemClassID == Enum.ItemClass.Miscellaneous and itemSubClassID == Enum.ItemMiscellaneousSubclass.Mount) then --mount
		if (RSTooltipScanners.ScanLoot(itemLink, ITEM_SPELL_KNOWN)) then
			RSLogger:PrintDebugMessageItemID(itemID, string.format("Item [%s]. Filtrado por haberlo conseguido ya (montura).", itemID))
			return true
		end
	end

	-- Collection pet filter
	-- Unique pets
	if (RSConfigDB.IsFilteringByCollected() and itemClassID == Enum.ItemClass.Miscellaneous and itemSubClassID == Enum.ItemMiscellaneousSubclass.CompanionPet) then --pets
		if (RSTooltipScanners.ScanLoot(itemLink, format(ITEM_PET_KNOWN, "1", "1")) or RSTooltipScanners.ScanLoot(itemLink, format(ITEM_PET_KNOWN, "3", "3"))) then
			RSLogger:PrintDebugMessageItemID(itemID, string.format("Item [%s]. Filtrado por haberlo conseguido ya (mascota).", itemID))
			return true
		end
	end

	-- Collection toy filter
	-- Toys have different categories under miscelanious
	if (RSConfigDB.IsFilteringByCollected()) then
		if (IsToy(itemLink, itemID) and RSTooltipScanners.ScanLoot(itemLink, ITEM_SPELL_KNOWN)) then
			RSLogger:PrintDebugMessageItemID(itemID, string.format("Item [%s]. Filtrado por haberlo conseguido ya (juguete).", itemID))
			return true
		end
	end
	
	-- Anima items filter
	if (RSConfigDB.IsFilteringAnimaItems()) then
		if (RSTooltipScanners.ScanLoot(itemLink, ANIMA)) then
			RSLogger:PrintDebugMessageItemID(itemID, string.format("Item [%s]. Filtrado por ser un objeto que da ánima.", itemID))
			return true
		end
	end
	
	-- Conduits filter
	if (RSConfigDB.IsFilteringConduitItems()) then
		if (C_Soulbinds.IsItemConduitByItemInfo(itemLink)) then
			-- First check if collected already
			if (IsConduitAlreadyCollected(itemID)) then
				RSLogger:PrintDebugMessageItemID(itemID, string.format("Item [%s]. Filtrado por haberlo conseguido ya (conducto).", itemID))
				return true
			-- Check if usable
			else
				local conduitInfo = RSLootDB.GetConduitInfo(itemID)
				if (conduitInfo and not C_SpecializationInfo.MatchesCurrentSpecSet(conduitInfo.specSetID)) then
					RSLogger:PrintDebugMessageItemID(itemID, string.format("Item [%s]. Filtrado por no poder usarlo por ser de otra clase (conducto).", itemID))
					return true
				end
			end
		end
	end
	
	return false
end
