-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local ADDON_NAME, private = ...

-- Locales
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner");

-- RareScanner database libraries
local RSNpcDB = private.ImportLib("RareScannerNpcDB")
local RSCollectionsDB = private.ImportLib("RareScannerCollectionsDB")
local RSGeneralDB = private.ImportLib("RareScannerGeneralDB")
local RSMapDB = private.ImportLib("RareScannerMapDB")
local RSConfigDB = private.ImportLib("RareScannerConfigDB")
local RSAchievementDB = private.ImportLib("RareScannerAchievementDB")

-- RareScanner general libraries
local RSConstants = private.ImportLib("RareScannerConstants")
local RSLogger = private.ImportLib("RareScannerLogger")
local RSUtils = private.ImportLib("RareScannerUtils")

-- RareScanner service libraries
local RSMap = private.ImportLib("RareScannerMap")
local RSNpcPOI = private.ImportLib("RareScannerNpcPOI")
local RSLootTooltip = private.ImportLib("RareScannerLootTooltip")

-- Thirdparty
local LibDD = LibStub:GetLibrary("LibUIDropDownMenu-4.0")
local LibDialog = LibStub("LibDialog-1.0")

-----------------------------------------------------
-- Filters panel
-----------------------------------------------------

RSExplorerFilters = { };

local filterCollectionsID = 1
local filterStateID = 2
local filters = { }

local currentContinentDropDownValues = { }

local function MapByName_Sort(mapIDs)
	local comparison = function(mapID1, mapID2)
		local mapName1 = RSMap.GetMapName(mapID1)
		local mapName2 = RSMap.GetMapName(mapID2)

		-- Otherwise order by name
		local strCmpResult = strcmputf8i(mapName1, mapName2);
		if (strCmpResult ~= 0) then
			return strCmpResult < 0;
		end
	end
				
	table.sort(mapIDs, comparison)
end

local function AddContinentDropDownValue(npcID, npcInfo, continentDropDownValuesNotSorted)
	if (RSNpcDB.IsInternalNpcMultiZone(npcID)) then
		for mapID, _ in pairs (npcInfo.zoneID) do
			local continentID = RSMapDB.GetContinentOfMap(mapID)
			if (continentID) then
				if (not continentDropDownValuesNotSorted[continentID]) then
					continentDropDownValuesNotSorted[continentID] = {}
				end
				if (not RSUtils.Contains(continentDropDownValuesNotSorted[continentID], mapID)) then
					table.insert(continentDropDownValuesNotSorted[continentID], mapID)
				end
			end
		end
	else
		local continentID = RSMapDB.GetContinentOfMap(npcInfo.zoneID)
		if (continentID) then
			if (not continentDropDownValuesNotSorted[continentID]) then
				continentDropDownValuesNotSorted[continentID] = {}
			end
			if (not RSUtils.Contains(continentDropDownValuesNotSorted[continentID], npcInfo.zoneID)) then
				table.insert(continentDropDownValuesNotSorted[continentID], npcInfo.zoneID)
			end
		end
	end
end

local function PopulateContinentDropDown(mainFrame, continentDropDown)
	local collectionsLoot = RSCollectionsDB.GetAllEntitiesCollectionsLoot()[RSConstants.ITEM_SOURCE.NPC]
	
	local _, _, classIndex = UnitClass("player");
	currentContinentDropDownValues = { }
	local continentDropDownValuesNotSorted = { }
	if (RSUtils.GetTableLength(filters) > 0) then
		for npcID, npcInfo in pairs (RSNpcDB.GetAllInternalNpcInfo()) do
			local filtered = false
			
			-- Ignore if part of a disabled event
			if (RSNpcDB.IsDisabledEvent(npcID)) then
				filtered = true
			end
			
			-- Ignore if dead
			if (not filters[RSConstants.EXPLORER_FILTER_DEAD] and RSNpcDB.IsNpcKilled(npcID)) then
				filtered = true
			end
			
			-- Ignore if filtered
			if (not filtered and not filters[RSConstants.EXPLORER_FILTER_FILTERED] and RSConfigDB.IsNpcFiltered(npcID)) then
				filtered = true
			end
			
			-- Add if matches collections
			if (not filtered) then
				if (filters[RSConstants.EXPLORER_FILTER_DROP_MOUNTS] and collectionsLoot and collectionsLoot[npcID] and RSUtils.GetTableLength(collectionsLoot[npcID][RSConstants.ITEM_TYPE.MOUNT]) > 0) then
					AddContinentDropDownValue(npcID, npcInfo, continentDropDownValuesNotSorted)
				elseif (filters[RSConstants.EXPLORER_FILTER_DROP_PETS] and collectionsLoot and collectionsLoot[npcID] and RSUtils.GetTableLength(collectionsLoot[npcID][RSConstants.ITEM_TYPE.PET]) > 0) then
					AddContinentDropDownValue(npcID, npcInfo, continentDropDownValuesNotSorted)
				elseif (filters[RSConstants.EXPLORER_FILTER_DROP_TOYS] and collectionsLoot and collectionsLoot[npcID] and RSUtils.GetTableLength(collectionsLoot[npcID][RSConstants.ITEM_TYPE.TOY]) > 0) then
					AddContinentDropDownValue(npcID, npcInfo, continentDropDownValuesNotSorted)
				elseif (filters[RSConstants.EXPLORER_FILTER_DROP_APPEARANCES] and collectionsLoot and collectionsLoot[npcID] and collectionsLoot[npcID][RSConstants.ITEM_TYPE.APPEARANCE] and RSUtils.GetTableLength(collectionsLoot[npcID][RSConstants.ITEM_TYPE.APPEARANCE][classIndex]) > 0) then
					AddContinentDropDownValue(npcID, npcInfo, continentDropDownValuesNotSorted)
				elseif (filters[RSConstants.EXPLORER_FILTER_PART_ACHIEVEMENT] and RSAchievementDB.GetNotCompletedAchievementLink(npcID)) then
					AddContinentDropDownValue(npcID, npcInfo, continentDropDownValuesNotSorted)
				elseif (filters[RSConstants.EXPLORER_FILTER_WITHOUT_COLLECTIBLES] and (not collectionsLoot or not collectionsLoot[npcID])) then
					AddContinentDropDownValue(npcID, npcInfo, continentDropDownValuesNotSorted)
				end
			end
		end
    end
    
    -- Sort continents by name
    local continentsSorted = { }
   	for continentID, _ in pairs(continentDropDownValuesNotSorted) do
   		table.insert(continentsSorted, continentID)
   	end
	MapByName_Sort(continentsSorted)

	-- Sort maps by name
	for continentID, mapIDs in pairs (continentDropDownValuesNotSorted) do
		local mapIDs = continentDropDownValuesNotSorted[continentID]
		MapByName_Sort(mapIDs)
		currentContinentDropDownValues[continentID] = mapIDs
	end
	
	-- Tries to select the previous continent/map
	local previousContinentID = RSConfigDB.GetExplorerContinenMapID()
	local previousMapID = RSConfigDB.GetExplorerMapID()
	if (previousContinentID and previousMapID and RSUtils.Contains(continentsSorted, previousContinentID) and RSUtils.Contains(currentContinentDropDownValues[previousContinentID], previousMapID)) then
		LibDD:UIDropDownMenu_SetText(continentDropDown, RSMap.GetMapName(previousMapID))
		mainFrame:ShowContentPanels()
		mainFrame.ScanRequired:Hide()
	-- Otherwise select the first map available
	elseif (RSUtils.GetTableLength(continentsSorted) > 0) then
   		for _, continentID in ipairs(continentsSorted) do
   			RSConfigDB.SetExplorerContinentMapID(continentID)
   			local mapID = currentContinentDropDownValues[continentID][1]
   			RSConfigDB.SetExplorerMapID(mapID)
			LibDD:UIDropDownMenu_SetText(continentDropDown, RSMap.GetMapName(mapID))
			break
	   	end
	   	
		mainFrame:ShowContentPanels()
		mainFrame.ScanRequired:Hide()
	else
		LibDD:UIDropDownMenu_SetText(continentDropDown, AL["EXPLORER_NO_RESULTS"])
		mainFrame:HideContentPanels()
		mainFrame.ScanRequired.ScanRequiredText:SetText(AL["EXPLORER_NO_RESULTS"])
		mainFrame.ScanRequired.StartScanningButton:Hide()
		mainFrame.ScanRequired:Show()
		mainFrame.Filters:Show()
   	end
end

local function FilterDropDownMenu_Initialize(self)
	local mainFrame = self.mainFrame
	local dropDown = self.FilterDropDown
	local continentDropDown = self.ContinentDropDown
	LibDD:UIDropDownMenu_SetWidth(dropDown, 100)
	LibDD:UIDropDownMenu_Initialize(dropDown, function(self, level, menuList)
		if ((level or 1) == 1) then
  			local info = LibDD:UIDropDownMenu_CreateInfo()
  			info.text = AL["EXPLORER_FILTER_COLLECTIONS"]
  			info.menuList = filterCollectionsID
  			info.hasArrow = true
  			info.notCheckable = true
  			LibDD:UIDropDownMenu_AddButton(info)
  			
  			info = LibDD:UIDropDownMenu_CreateInfo()
  			info.text = AL["EXPLORER_FILTER_STATE"]
  			info.menuList = filterStateID
  			info.hasArrow = true
  			info.notCheckable = true
  			LibDD:UIDropDownMenu_AddButton(info)
		else
			local refreshList = function(self, filterID)
				local filtered
  				if (filters[filterID]) then
  					filters[filterID] = nil
  					filtered = false
  				else
  					filters[filterID] = true
  					filtered = true
  				end
  				
  				if (filterID == RSConstants.EXPLORER_FILTER_DROP_MOUNTS) then
  					RSConfigDB.SetSearchingMounts(filtered)
  				elseif (filterID == RSConstants.EXPLORER_FILTER_DROP_PETS) then
  					RSConfigDB.SetSearchingPets(filtered)
  				elseif (filterID == RSConstants.EXPLORER_FILTER_DROP_TOYS) then
  					RSConfigDB.SetSearchingToys(filtered)
  				elseif (filterID == RSConstants.EXPLORER_FILTER_DROP_APPEARANCES) then
  					RSConfigDB.SetSearchingAppearances(filtered)
  				elseif (filterID == RSConstants.EXPLORER_FILTER_DEAD) then
  					RSConfigDB.SetShowDead(filtered)
  				elseif (filterID == RSConstants.EXPLORER_FILTER_FILTERED) then
  					RSConfigDB.SetShowFiltered(filtered)
  				elseif (filterID == RSConstants.EXPLORER_FILTER_WITHOUT_COLLECTIBLES) then
  					RSConfigDB.SetShowWithoutCollectibles(filtered)
  				end
	    			
				-- Refresh
				mainFrame:Refresh()
  			end
  			
			if (menuList == filterCollectionsID) then
				local info = LibDD:UIDropDownMenu_CreateInfo()
	  			info.text = AL["EXPLORER_FILTER_MOUNTS"]
	  			info.arg1 = RSConstants.EXPLORER_FILTER_DROP_MOUNTS
	  			info.checked = filters[RSConstants.EXPLORER_FILTER_DROP_MOUNTS]
	  			info.func = refreshList
	  			info.keepShownOnClick = true;
	  			LibDD:UIDropDownMenu_AddButton(info, level)
	  			
	  			info = LibDD:UIDropDownMenu_CreateInfo()
	  			info.text = AL["EXPLORER_FILTER_PETS"]
	  			info.arg1 = RSConstants.EXPLORER_FILTER_DROP_PETS
	  			info.checked = filters[RSConstants.EXPLORER_FILTER_DROP_PETS]
	  			info.func = refreshList
	  			info.keepShownOnClick = true;
	  			LibDD:UIDropDownMenu_AddButton(info, level)
	  			
	  			info = LibDD:UIDropDownMenu_CreateInfo()
	  			info.text = AL["EXPLORER_FILTER_TOYS"]
	  			info.arg1 = RSConstants.EXPLORER_FILTER_DROP_TOYS
	  			info.checked = filters[RSConstants.EXPLORER_FILTER_DROP_TOYS]
	  			info.func = refreshList
	  			info.keepShownOnClick = true;
	  			LibDD:UIDropDownMenu_AddButton(info, level)
	  			
	  			info = LibDD:UIDropDownMenu_CreateInfo()
	  			info.text = AL["EXPLORER_FILTER_APPEARANCES"]
	  			info.arg1 = RSConstants.EXPLORER_FILTER_DROP_APPEARANCES
	  			info.checked = filters[RSConstants.EXPLORER_FILTER_DROP_APPEARANCES]
	  			info.func = refreshList
	  			info.keepShownOnClick = true;
	  			LibDD:UIDropDownMenu_AddButton(info, level)
	  			
--	  			info = LibDD:UIDropDownMenu_CreateInfo()
--	  			info.text = AL["EXPLORER_FILTER_ACHIEVEMENT"]
--	  			info.arg1 = RSConstants.EXPLORER_FILTER_PART_ACHIEVEMENT
--	  			info.checked = filters[RSConstants.EXPLORER_FILTER_PART_ACHIEVEMENT]
--	  			info.func = refreshList
--	  			info.keepShownOnClick = true;
--	  			LibDD:UIDropDownMenu_AddButton(info, level)
			elseif (menuList == filterStateID) then
				local info = LibDD:UIDropDownMenu_CreateInfo()
	  			info.text = AL["EXPLORER_FILTER_DEAD"]
	  			info.arg1 = RSConstants.EXPLORER_FILTER_DEAD
	  			info.checked = filters[RSConstants.EXPLORER_FILTER_DEAD]
	  			info.func = refreshList
	  			info.keepShownOnClick = true;
	  			LibDD:UIDropDownMenu_AddButton(info, level)
	  			
	  			info = LibDD:UIDropDownMenu_CreateInfo()
	  			info.text = AL["EXPLORER_FILTER_FILTERED"]
	  			info.arg1 = RSConstants.EXPLORER_FILTER_FILTERED
	  			info.checked = filters[RSConstants.EXPLORER_FILTER_FILTERED]
	  			info.func = refreshList
	  			info.keepShownOnClick = true;
	  			LibDD:UIDropDownMenu_AddButton(info, level)
	  			
	  			info = LibDD:UIDropDownMenu_CreateInfo()
	  			info.text = AL["EXPLORER_FILTER_WITHOUT_COLLECTIBLES"]
	  			info.arg1 = RSConstants.EXPLORER_FILTER_WITHOUT_COLLECTIBLES
	  			info.checked = filters[RSConstants.EXPLORER_FILTER_WITHOUT_COLLECTIBLES]
	  			info.func = refreshList
	  			info.keepShownOnClick = true;
	  			LibDD:UIDropDownMenu_AddButton(info, level)
			end
		end
 	end)

	LibDD:UIDropDownMenu_SetText(dropDown, AL["EXPLORER_FILTERS"])
end

local function ContinentDropDownMenu_Initialize(self)
	local mainFrame = self.mainFrame
	local dropDown = self.ContinentDropDown
	local collectionsLoot = RSCollectionsDB.GetAllEntitiesCollectionsLoot()[RSConstants.ITEM_SOURCE.NPC]
				
	LibDD:UIDropDownMenu_SetWidth(dropDown, 200)
	LibDD:UIDropDownMenu_Initialize(dropDown, function(self, level, menuList)
		if ((level or 1) == 1) then
			local continentsSorted = { }
		   	for continentID, _ in pairs(currentContinentDropDownValues) do
		   		table.insert(continentsSorted, continentID)
		   	end
			MapByName_Sort(continentsSorted)
			   	
	    	for _, continentID in ipairs(continentsSorted) do
	    		local continentName = RSMap.GetMapName(continentID)
				if (continentName) then
					-- Add continent list
		  			local info = LibDD:UIDropDownMenu_CreateInfo()
		  			info.text = continentName
		  			info.checked = continentID == RSConfigDB.GetExplorerContinenMapID()
		  			info.menuList = continentID
		  			info.hasArrow = true
		  			LibDD:UIDropDownMenu_AddButton(info)
		  		end
	    	end
	    else
	    	for continentID, mapIDs in pairs(currentContinentDropDownValues) do
	    		if (continentID == menuList) then
	    			for _, mapID in ipairs (mapIDs) do
						local mapName = RSMap.GetMapName(mapID)
		
		  				local info = LibDD:UIDropDownMenu_CreateInfo()
			  			info.text = mapName
			  			info.arg1 = mapName
			  			info.arg2 = mapID
			  			info.checked = mapID == RSConfigDB.GetExplorerMapID()
			  			info.func = function(self, mapName, mapID)
			  				RSConfigDB.SetExplorerContinentMapID(menuList)
			  				RSConfigDB.SetExplorerMapID(mapID)
			  				LibDD:UIDropDownMenu_SetText(dropDown, mapName)
			  				LibDD:CloseDropDownMenus()
			  				
			  				-- Refresh list
			  				mainFrame.RareNPCList:UpdateRareList()
			  			end
			  			LibDD:UIDropDownMenu_AddButton(info, level)
			  		end
	  			end
	  		end
	    end
 	end)
end

function RSExplorerFilters:Initialize(mainFrame)
	if (mainFrame.initialized) then
		mainFrame:Refresh()
	else
		self.mainFrame = mainFrame
		self.FilterDropDown = LibDD:Create_UIDropDownMenu("FilterDropDown", self)
		self.FilterDropDown:SetPoint("LEFT", 0, 1)
		self.ContinentDropDown = LibDD:Create_UIDropDownMenu("ContinentDropDown", self)
		self.ContinentDropDown:SetPoint("LEFT", self.FilterDropDown, "RIGHT", -10, 0)
		FilterDropDownMenu_Initialize(self)
		PopulateContinentDropDown(self.mainFrame, self.ContinentDropDown)
		ContinentDropDownMenu_Initialize(self)
		
		self.RestartScanningButton:SetText(AL["EXPLORER_RESCANN"])
		self.RestartScanningButton.tooltip = AL["EXPLORER_RESCANN_DESC"]
	end
end

function RSExplorerFilters:RestartScanning(self, button)
	local mainFrame = self:GetParent().mainFrame
	mainFrame.ScanRequired.ScanRequiredText:SetText(AL["EXPLORER_SCAN_MANUAL"])
	mainFrame.ScanRequired.StartScanningButton:SetText(AL["EXPLORER_START_SCAN"])
	mainFrame.ScanRequired.StartScanningButton:Show()
	mainFrame.ScanRequired:Show()
	mainFrame:HideContentPanels()
end

-----------------------------------------------------
-- Rare list panel
-----------------------------------------------------

RSExplorerRareList = { };

local RARE_BUTTON_HEIGHT = 56;
local RARE_LIST_BUTTON_OFFSET = -6;
local RARE_LIST_BUTTON_INITIAL_OFFSET = -7;
local RARE_TEXTURE_OFFSET = -24;

function RSExplorerRareList_GetButtonHeight()
	return RARE_BUTTON_HEIGHT;
end

function RSExplorerRareList_GetTopButton(self, offset)
	local buttonHeight = self.listScroll.buttonHeight;
	local raresList = self.raresList;
	local totalHeight = 0;
	for i = 1, #raresList do
		local height = RARE_BUTTON_HEIGHT - RARE_LIST_BUTTON_OFFSET;
		totalHeight = totalHeight + height;
		if (totalHeight > offset) then
			return i - 1, height + offset - totalHeight;
		end
	end
	
	--We're scrolled completely off the bottom
	return #self.raresList, 0;
end

function RSExplorerRareList_Sort(self)
	local raresList = self.raresList
	local raresListInfo = self.raresListInfo
	
	local comparison = function(npcID1, npcID2) --whether the first argument should be before the second argument in the sequence
		-- Order by missing collectibles
		if (raresListInfo[npcID1].hasMissingMount ~= raresListInfo[npcID2].hasMissingMount) then
			if (raresListInfo[npcID1].hasMissingMount) then return true end
			if (raresListInfo[npcID2].hasMissingMount) then return false end
		end
				
		if (raresListInfo[npcID1].hasMissingPet ~= raresListInfo[npcID2].hasMissingPet) then
			if (raresListInfo[npcID1].hasMissingPet) then return true end
			if (raresListInfo[npcID2].hasMissingPet) then return false end
		end
				
		if (raresListInfo[npcID1].hasMissingToy ~= raresListInfo[npcID2].hasMissingToy) then
			if (raresListInfo[npcID1].hasMissingToy) then return true end
			if (raresListInfo[npcID2].hasMissingToy) then return false end
		end
				
		if (raresListInfo[npcID1].hasMissingAppearance ~= raresListInfo[npcID2].hasMissingAppearance) then
			if (raresListInfo[npcID1].hasMissingAppearance) then return true end
			if (raresListInfo[npcID2].hasMissingAppearance) then return false end
		end
				
		if (raresListInfo[npcID1].dead ~= raresListInfo[npcID2].dead) then
			if (raresListInfo[npcID1].dead) then return false end
			if (raresListInfo[npcID2].dead) then return true end
		end
				
		if (raresListInfo[npcID1].filtered ~= raresListInfo[npcID2].filtered) then
			if (raresListInfo[npcID1].filtered) then return false end
			if (raresListInfo[npcID2].filtered) then return true end
		end
		
		-- Otherwise order by name
		local strCmpResult = strcmputf8i(raresListInfo[npcID1].name, raresListInfo[npcID2].name);
		if (strCmpResult ~= 0) then
			return strCmpResult < 0;
		end
	end
	
	-- Order
	table.sort(self.raresList, comparison);
end

function RSExplorerRareList:Initialize(mainFrame)
	self.mainFrame = mainFrame
	local _, _, classIndex = UnitClass("player");
	self.classIndex = classIndex
	self.listScroll.update = function() self:UpdateData(); end;
	self.listScroll.dynamic = function(offset) return RSExplorerRareList_GetTopButton(self, offset) end;

	HybridScrollFrame_CreateButtons(self.listScroll, "RSExplorerListTemplate", 7, RARE_LIST_BUTTON_INITIAL_OFFSET, nil, nil, nil, RARE_LIST_BUTTON_OFFSET);
	self:UpdateRareList();
end

function RSExplorerRareList:AddFilteredRareToList(npcID, npcInfo, npcName)
	if (self.raresListInfo[npcID]) then
		return
	end
	
	self.raresListInfo[npcID] = {}
	self.raresListInfo[npcID].mapID = npcInfo.zoneID
	self.raresListInfo[npcID].displayID = npcInfo.displayID
	self.raresListInfo[npcID].name = npcName
	self.raresListInfo[npcID].filtered = RSConfigDB.IsNpcFiltered(npcID)
	self.raresListInfo[npcID].dead = RSNpcDB.IsNpcKilled(npcID)
					
	tinsert(self.raresList, npcID)
	
	-- add extra information
	local collectionsLoot = RSCollectionsDB.GetAllEntitiesCollectionsLoot()
	if (collectionsLoot[RSConstants.ITEM_SOURCE.NPC] and collectionsLoot[RSConstants.ITEM_SOURCE.NPC][npcID]) then
		if (RSUtils.GetTableLength(collectionsLoot[RSConstants.ITEM_SOURCE.NPC][npcID][RSConstants.ITEM_TYPE.MOUNT]) > 0) then
			self.raresListInfo[npcID].hasMissingMount = true
		else
			self.raresListInfo[npcID].hasMissingMount = false
		end
		if (RSUtils.GetTableLength(collectionsLoot[RSConstants.ITEM_SOURCE.NPC][npcID][RSConstants.ITEM_TYPE.PET]) > 0) then
			self.raresListInfo[npcID].hasMissingPet = true
		else
			self.raresListInfo[npcID].hasMissingPet = false
		end
		if (RSUtils.GetTableLength(collectionsLoot[RSConstants.ITEM_SOURCE.NPC][npcID][RSConstants.ITEM_TYPE.TOY]) > 0) then
			self.raresListInfo[npcID].hasMissingToy = true
		else
			self.raresListInfo[npcID].hasMissingToy = false
		end
		if (collectionsLoot[RSConstants.ITEM_SOURCE.NPC][npcID][RSConstants.ITEM_TYPE.APPEARANCE] and RSUtils.GetTableLength(collectionsLoot[RSConstants.ITEM_SOURCE.NPC][npcID][RSConstants.ITEM_TYPE.APPEARANCE][self.classIndex]) > 0) then
			self.raresListInfo[npcID].hasMissingAppearance = true
		else
			self.raresListInfo[npcID].hasMissingAppearance = false
		end
	end
end

function RSExplorerRareList:UpdateRareList()
	self.raresList = {}
	self.raresListInfo = {}
	self.selectedNpcId = nil
	self.mapID = RSConfigDB.GetExplorerMapID()
	
	-- Load list
	for npcID, npcName in pairs(RSNpcDB.GetAllNpcNames()) do
		if (RSNpcDB.IsInternalNpcInMap(npcID, self.mapID, false)) then
			local npcInfo = RSNpcDB.GetInternalNpcInfoByMapID(npcID, self.mapID)
			
			if (npcInfo and npcInfo.displayID) then
				local filtered = false
				-- Ignore if dead
				if (not filters[RSConstants.EXPLORER_FILTER_DEAD] and RSNpcDB.IsNpcKilled(npcID)) then
					filtered = true
				end
				
				-- Ignore if filtered
				if (not filtered and not filters[RSConstants.EXPLORER_FILTER_FILTERED] and RSConfigDB.IsNpcFiltered(npcID)) then
					filtered = true
				end
			
				if (not filtered) then
					local collectionsLoot = RSCollectionsDB.GetAllEntitiesCollectionsLoot()[RSConstants.ITEM_SOURCE.NPC]
					
					if (filters[RSConstants.EXPLORER_FILTER_DROP_MOUNTS] and collectionsLoot and collectionsLoot[npcID] and RSUtils.GetTableLength(collectionsLoot[npcID][RSConstants.ITEM_TYPE.MOUNT]) > 0) then
						self:AddFilteredRareToList(npcID, npcInfo, npcName)
					end
						
					if (filters[RSConstants.EXPLORER_FILTER_DROP_PETS] and collectionsLoot and collectionsLoot[npcID] and RSUtils.GetTableLength(collectionsLoot[npcID][RSConstants.ITEM_TYPE.PET]) > 0) then
						self:AddFilteredRareToList(npcID, npcInfo, npcName)
					end
								
					if (filters[RSConstants.EXPLORER_FILTER_DROP_TOYS] and collectionsLoot and collectionsLoot[npcID] and RSUtils.GetTableLength(collectionsLoot[npcID][RSConstants.ITEM_TYPE.TOY]) > 0) then
						self:AddFilteredRareToList(npcID, npcInfo, npcName)
					end
								
					if (filters[RSConstants.EXPLORER_FILTER_DROP_APPEARANCES] and collectionsLoot and collectionsLoot[npcID] and collectionsLoot[npcID][RSConstants.ITEM_TYPE.APPEARANCE] and RSUtils.GetTableLength(collectionsLoot[npcID][RSConstants.ITEM_TYPE.APPEARANCE][self.classIndex]) > 0) then
						self:AddFilteredRareToList(npcID, npcInfo, npcName)
					end
								
					if (filters[RSConstants.EXPLORER_FILTER_PART_ACHIEVEMENT] and RSAchievementDB.GetNotCompletedAchievementLink(npcID, self.mapID)) then
						self:AddFilteredRareToList(npcID, npcInfo, npcName)
					end
								
					if (filters[RSConstants.EXPLORER_FILTER_WITHOUT_COLLECTIBLES] and ((not collectionsLoot or not collectionsLoot[npcID]) or (collectionsLoot[npcID][RSConstants.ITEM_TYPE.APPEARANCE] and RSUtils.GetTableLength(collectionsLoot[npcID][RSConstants.ITEM_TYPE.APPEARANCE][self.classIndex]) == 0))) then
						self:AddFilteredRareToList(npcID, npcInfo, npcName)
					end
				end
			else
				RSLogger:PrintDebugMessage(string.format("RSExplorerRareList:UpdateRareList: [npcID=%s]. Saltado por no tener informacion o displayID", npcID))
			end
		end
	end
	
	-- Sort
	RSExplorerRareList_Sort(self)
				
	-- Scroll to top
	HybridScrollFrame_ScrollToIndex(self.listScroll, 1, RSExplorerRareList_GetButtonHeight);
	self:Show()	
	self:UpdateData()
	
	-- Select first NPC	
	if (not self.selectedNpcId and RSUtils.GetTableLength(self.raresList) > 0) then
		self:SelectNpc(self.raresList[1])
	end
end

local function ToggleButtonTexture(activeTextures, texture, hasMissingType)
	if (hasMissingType) then
		texture:ClearAllPoints();
		texture:SetPoint("TOPRIGHT", -2 + (activeTextures * RARE_TEXTURE_OFFSET), -2)
		texture:Show()
		return activeTextures + 1
	else
		texture:Hide()
		return activeTextures
	end
end

function RSExplorerRareList:UpdateData()
	local scrollFrame = self.listScroll;
	local offset = HybridScrollFrame_GetOffset(scrollFrame);
	local buttons = scrollFrame.buttons;
	local numButtons = #buttons;
	local numRares = #self.raresList
	
	local skipped = 0
	for i = 1, numButtons do
		local button = buttons[i];
		local index = offset + i + skipped; -- adjust index
		local npcID = self.raresList[index]
		
		if (index <= numRares) then
			local retOk, _ = pcall(SetPortraitTextureFromCreatureDisplayID, button.RareNPC.PortraitFrame.Portrait, self.raresListInfo[npcID].displayID)
			if (not retOk) then
				RSLogger:PrintDebugMessage(string.format("RSExplorerRareList:UpdateData: [npcID=%s][displayID=%s] Error al cargar el portaretrato.", npcID, self.raresListInfo[npcID].npcInfo.displayID or "nil"))
			end
			
			local activeTextures = 0
			activeTextures = ToggleButtonTexture(activeTextures, button.RareNPC.MountTexture, self.raresListInfo[npcID].hasMissingMount)
			activeTextures = ToggleButtonTexture(activeTextures, button.RareNPC.PetTexture, self.raresListInfo[npcID].hasMissingPet)
			activeTextures = ToggleButtonTexture(activeTextures, button.RareNPC.ToyTexture, self.raresListInfo[npcID].hasMissingToy)
			activeTextures = ToggleButtonTexture(activeTextures, button.RareNPC.AppearanceTexture, self.raresListInfo[npcID].hasMissingAppearance)
			
			if (self.selectedNpcId and self.selectedNpcId == npcID) then
				button.RareNPC.Selected:Show()
			else
				button.RareNPC.Selected:Hide()
			end
			
			button.RareNPC.npcID = npcID
			button.RareNPC.mapID = self.raresListInfo[npcID].mapID
			button.RareNPC.Name:SetText(self.raresListInfo[npcID].name)
			
			if (self.raresListInfo[npcID].dead) then
				button.RareNPC.Name:SetTextColor(0, 1, 1, 1)
			elseif (self.raresListInfo[npcID].filtered) then
				button.RareNPC.Name:SetTextColor(0.83, 0.83, 0.83, 1)
			else
				button.RareNPC.Name:SetTextColor(1, 0.85, 0, 1)
			end
			
			if (self.raresListInfo[npcID].filtered) then
				button.RareNPC.PortraitFrame.Portrait:SetDesaturated(1)
				button.RareNPC.MountTexture:SetDesaturated(1)
				button.RareNPC.PetTexture:SetDesaturated(1)
				button.RareNPC.ToyTexture:SetDesaturated(1)
				button.RareNPC.AppearanceTexture:SetDesaturated(1)
			else
				button.RareNPC.PortraitFrame.Portrait:SetDesaturated(nil)
				button.RareNPC.MountTexture:SetDesaturated(nil)
				button.RareNPC.PetTexture:SetDesaturated(nil)
				button.RareNPC.ToyTexture:SetDesaturated(nil)
				button.RareNPC.AppearanceTexture:SetDesaturated(nil)
			end
			
			button:Show()
		else
			button:Hide()
		end
	end
	
	-- calculate the total height to pass to the HybridScrollFrame
	local totalHeight = -RARE_LIST_BUTTON_INITIAL_OFFSET;
	for i = 1, numRares do
		totalHeight = totalHeight + (RARE_BUTTON_HEIGHT - RARE_LIST_BUTTON_OFFSET);
	end

	local displayedHeight = numButtons * scrollFrame.buttonHeight;
	HybridScrollFrame_Update(scrollFrame, totalHeight, displayedHeight);
end

local function RSExplorerLoadMap(mapID, mapFrame)
	-- Initialize variables
	if (not mapFrame.detailLayerPool) then
		mapFrame.detailLayerPool = CreateFramePool("FRAME", mapFrame, "RSMapCanvasDetailLayerTemplate");
		mapFrame.iconsPool = CreateFramePool("FRAME", mapFrame, "RSMapCanvasDetailIconsTemplate");
		mapFrame.overlayIconsPool = CreateFramePool("FRAME", mapFrame, "RSMapCanvasDetailIconsTemplate");
	end
	
	-- Load map frame
	mapFrame.detailLayerPool:ReleaseAll();
	
	local layers = C_Map.GetMapArtLayers(mapID);	
	for layerIndex, layerInfo in ipairs(layers) do
		local detailLayer = mapFrame.detailLayerPool:Acquire();
		detailLayer:SetAllPoints(mapFrame);
		detailLayer:SetMapAndLayer(mapID, layerIndex, mapFrame);
		detailLayer:Show();
	end
end

local function AddIcon(icon, texture, x, y, r, g, b)
	icon.Texture:SetTexture(texture)
	if (r and g and b) then
		icon.Texture:SetVertexColor(r, g, b, 0.4)
		icon.Texture:SetDrawLayer("ARTWORK");
	else
		icon.Texture:SetDrawLayer("OVERLAY");
	end
	
	local xOffset = 0
	local yOffset = 0
	if (x > 1) then
		xOffset = ((x / 100) * icon:GetParent():GetWidth()) / 100
		yOffset = ((y / 100) * icon:GetParent():GetHeight()) / 100
	else
		xOffset = x * icon:GetParent():GetWidth()
		yOffset = y * icon:GetParent():GetHeight()
	end
	
	icon:SetPoint("CENTER", icon:GetParent(), "TOPLEFT", xOffset, -yOffset)
	icon:Show()
end

function RSExplorerRareListButton_OnClick(self, button)
	local mainFrame = self:GetParent():GetParent():GetParent():GetParent().mainFrame
	if (button == "LeftButton") then
		mainFrame.RareNPCList:SelectNpc(self.npcID)
	elseif (button == "RightButton") then
		local npcName = RSNpcDB.GetNpcName(self.npcID)
		if (RSConfigDB.IsNpcFiltered(self.npcID)) then
			RSLogger:PrintMessage(AL["ENABLED_SEARCHING_RARE"]..npcName)
			RSConfigDB.SetNpcFiltered(self.npcID, true)
		else
			RSLogger:PrintMessage(AL["DISABLED_SEARCHING_RARE"]..npcName)
			RSConfigDB.SetNpcFiltered(self.npcID, false)
		end
		mainFrame:Refresh()
	end
end

function RSExplorerRareListButton_OnEnter(self)
	local mainFrame = self:GetParent():GetParent():GetParent():GetParent().mainFrame
	local tooltip = mainFrame.Tooltip
	tooltip:SetOwner(self, "ANCHOR_LEFT")
	tooltip:SetText(RSNpcDB.GetNpcName(self.npcID))
	tooltip:AddLine(AL["EXPLORER_BUTTON_TOOLTIP1"], 1, 1, 1)
	if (RSConfigDB.IsNpcFiltered(self.npcID)) then
		tooltip:AddLine(AL["EXPLORER_BUTTON_TOOLTIP2"], 1, 1, 1)
	else
		tooltip:AddLine(AL["EXPLORER_BUTTON_TOOLTIP3"], 1, 1, 1)
	end
	tooltip:Show()
end

function RSExplorerRareListButton_OnLeave(self)
	local mainFrame = self:GetParent():GetParent():GetParent():GetParent().mainFrame
	local tooltip = mainFrame.Tooltip
	tooltip:Hide()
end

function RSExplorerRareList:AddItems(parentFrame, itemType)
	local mainFrame = self:GetParent()
	
	local collectionsLoot = RSCollectionsDB.GetAllEntitiesCollectionsLoot()[RSConstants.ITEM_SOURCE.NPC]
	if (collectionsLoot and collectionsLoot[self.selectedNpcId]) then
		local itemIDs = nil
		if (itemType == RSConstants.ITEM_TYPE.APPEARANCE and collectionsLoot[self.selectedNpcId][itemType] and collectionsLoot[self.selectedNpcId][itemType][self.classIndex]) then
			itemIDs = collectionsLoot[self.selectedNpcId][itemType][self.classIndex]
		else
			itemIDs = collectionsLoot[self.selectedNpcId][itemType]
		end
		
	    if (RSUtils.GetTableLength(itemIDs) > 0) then
	    	parentFrame.NoItems:Hide()
			local xOffset = 0
			local yOffset = itemType == RSConstants.ITEM_TYPE.APPEARANCE and 60 or 0
			local numItemsRow = 0
			local numRow = 0
			local maxLines = 4
			local maxItemsPerRow = 6
	    	for _, itemID in ipairs(itemIDs) do
	    		local _, _, _, _, icon, _, _ = GetItemInfoInstant(itemID)
	    		local lootItem = mainFrame.lootItemsPool:Acquire();
	    		
	    		if (math.fmod(numItemsRow, maxItemsPerRow) == 0) then
	    			xOffset = xOffset + 10
	    		else
	    			xOffset = xOffset + lootItem:GetWidth() + 2
	    		end
	    		
	    		lootItem.itemID = itemID
	    		lootItem.Icon:SetTexture(icon)
	    		lootItem.isMount = itemType == RSConstants.ITEM_TYPE.MOUNT
	    		lootItem.isPet = itemType == RSConstants.ITEM_TYPE.PET
	    		lootItem.istoy = itemType == RSConstants.ITEM_TYPE.TOY
	    		lootItem.isAppearance = itemType == RSConstants.ITEM_TYPE.APPEARANCE
	    		
	    		lootItem:SetPoint("LEFT", parentFrame, "LEFT", xOffset, yOffset)
	    		lootItem:Show()
	    		
	    		numItemsRow = numItemsRow + 1
	    		
	    		if (math.fmod(numItemsRow, maxItemsPerRow) == 0) then
    				numRow = numRow + 1
    				if (numRow == maxLines) then
    					break
    				end
    				
    				xOffset = 0
    				numItemsRow = 0
    				if (numRow > 1 and itemType ~= RSConstants.ITEM_TYPE.APPEARANCE) then
		    			break
		    		else	    			
		    			yOffset = yOffset - lootItem:GetHeight() - 2 
		    		end
    			end
	    	end
		else
	    	parentFrame.NoItems:Show()
		end
	else
    	parentFrame.NoItems:Show()
	end
end

function RSExplorerRareList:SelectNpc(npcID)
	local mainFrame = self:GetParent()
	self.selectedNpcId = npcID
	self:UpdateData()
	
	local internalInfo = RSNpcDB.GetInternalNpcInfoByMapID(npcID, self.mapID)
	
	-- Name
	mainFrame.RareInfo.Name:SetText(RSNpcDB.GetNpcName(npcID))
	
	-- Map
	local mapFrame = mainFrame.RareInfo.Map
	RSExplorerLoadMap(self.mapID, mapFrame)
	
	-- Icons / Spawning points
	mapFrame.overlayIconsPool:ReleaseAll()
	if (internalInfo.overlay) then
		local r, g, b = RSConfigDB.GetWorldMapOverlayColour(1)
		
		for _, coordinates in ipairs (internalInfo.overlay) do
			local x, y = strsplit("-", coordinates)
			local overlayIcon = mapFrame.overlayIconsPool:Acquire();
			AddIcon(overlayIcon, RSConstants.OVERLAY_SPOT_TEXTURE, tonumber(x), tonumber(y), r, g, b)
		end
	end
		
	-- Icons / Skull
	mapFrame.iconsPool:ReleaseAll()
	local npcPOI = RSNpcPOI.GetNpcPOI(npcID, self.mapID, internalInfo, RSGeneralDB.GetAlreadyFoundEntity(npcID))
	if (npcPOI) then
		local mainIcon = mapFrame.iconsPool:Acquire();
		AddIcon(mainIcon, npcPOI.Texture, internalInfo.x, internalInfo.y)
	end
	
	-- Achievement
	if (RSUtils.GetTableLength(npcPOI.achievementIDs) > 0) then
		for _, achievementID in ipairs(npcPOI.achievementIDs) do
			mainFrame.RareInfo.AchievementIcon.achievementLink = RSAchievementDB.GetCachedAchievementInfo(achievementID).link
			mainFrame.RareInfo.AchievementIcon:Show()
			break
		end
	else
		mainFrame.RareInfo.AchievementIcon:Hide()
	end
	
	-- Loot
	mainFrame.lootItemsPool:ReleaseAll();
	self:AddItems(mainFrame.RareInfo.Mounts, RSConstants.ITEM_TYPE.MOUNT)
	self:AddItems(mainFrame.RareInfo.Pets, RSConstants.ITEM_TYPE.PET)
	self:AddItems(mainFrame.RareInfo.Toys, RSConstants.ITEM_TYPE.TOY)
	self:AddItems(mainFrame.RareInfo.Appearances, RSConstants.ITEM_TYPE.APPEARANCE)
end

-----------------------------------------------------
-- Loot items
-----------------------------------------------------

function RSExplorerRareInfoLootItem_OnEnter(self)
	local mainFrame = self:GetParent():GetParent()
	local tooltip = mainFrame.Tooltip
	local itemIcon = self
	local item = Item:CreateFromItemID(self.itemID)
	item:ContinueOnItemLoad(function()
		tooltip:SetOwner(itemIcon, "BOTTOM_LEFT")
		tooltip:SetHyperlink(item:GetItemLink())
		
		-- Adds extra information
		RSLootTooltip.AddRareScannerInformation(tooltip, item:GetItemLink(), self.itemID)

		tooltip:Show()
	end)
end

function RSExplorerRareInfoLootItem_OnLeave(self)
	local mainFrame = self:GetParent():GetParent()
	local tooltip = mainFrame.Tooltip
	tooltip:Hide()
end

function RSExplorerRareInfoAchievement_OnEnter(self)
	local mainFrame = self:GetParent():GetParent()
	local tooltip = mainFrame.Tooltip
	tooltip:SetOwner(self, "BOTTOM_LEFT")
	tooltip:SetHyperlink(self.achievementLink)
	tooltip:Show()
end

function RSExplorerRareInfoAchievement_OnLeave(self)
	local mainFrame = self:GetParent():GetParent()
	local tooltip = mainFrame.Tooltip
	tooltip:Hide()
end

function RSExplorerRareInfoLootItem_OnClick(self, button)
	local itemIcon = self
	local item = Item:CreateFromItemID(self.itemID)
	item:ContinueOnItemLoad(function()
		if (IsControlKeyDown()) then
			if (itemIcon.isMount) then
				DressUpMountLink(item:GetItemLink())
			elseif (itemIcon.isPet) then
				DressUpBattlePetLink(item:GetItemLink())
			elseif (itemIcon.isAppearance) then
				DressUpItemLink(item:GetItemLink())
			end
		elseif (IsShiftKeyDown()) then
			ChatEdit_LinkItem(self.itemID, item:GetItemLink())
		end
	end)
end

-----------------------------------------------------
-- Rare detail frame
-----------------------------------------------------

RSExplorerDetailMap = { };

function RSExplorerDetailMap:OnLoad()
	self.detailTilePool = CreateTexturePool(self, "BACKGROUND", -7, "RSMapCanvasDetailTileTemplate");
	self.overlayTexturePool = CreateTexturePool(self, "ARTWORK", 0, "RSMapCanvasDetailTileTemplate");
	self.textureLoadGroup = CreateFromMixins(TextureLoadingGroupMixin);
end

function RSExplorerDetailMap:SetMapAndLayer(mapID, layerIndex, mapFrame)
	local mapArtID = C_Map.GetMapArtID(mapID) -- phased map art may be different for the same mapID
	if (self.mapID ~= mapID or self.mapArtID ~= mapArtID or self.layerIndex ~= layerIndex) then
		self.mapID = mapID;
		self.mapArtID = mapArtID;
		self.layerIndex = layerIndex;
		self:RefreshDetailTiles(mapFrame);
	end
end

function RSExplorerDetailMap:RefreshDetailTiles(mapFrame)
	self.detailTilePool:ReleaseAll();
	self.overlayTexturePool:ReleaseAll();
	self.textureLoadGroup:Reset();
	self.isWaitingForLoad = true;
	
	local layers = C_Map.GetMapArtLayers(self.mapID);
	local layerInfo = layers[self.layerIndex];
	local numDetailTilesRows = math.ceil(layerInfo.layerHeight / layerInfo.tileHeight);
	local numDetailTilesCols = math.ceil(layerInfo.layerWidth / layerInfo.tileWidth);
	local textures = C_Map.GetMapArtLayerTextures(self.mapID, self.layerIndex);
	local exploredMapTextures = C_MapExplorationInfo.GetExploredMapTextures(self.mapID)
	
	local prevRowDetailTile;
	local prevColDetailTile;
	
	-- Add unexplored layer
	for tileCol = 1, numDetailTilesCols do
		for tileRow = 1, numDetailTilesRows do
			if tileRow == 1 then
				prevRowDetailTile = nil;
			end
			local detailTile = self.detailTilePool:Acquire();
			self.textureLoadGroup:AddTexture(detailTile);
			local textureIndex = (tileRow - 1) * numDetailTilesCols + tileCol;
			detailTile:SetTexture(textures[textureIndex], nil, nil, "TRILINEAR");
			detailTile:ClearAllPoints();
			if prevRowDetailTile then
				detailTile:SetPoint("TOPLEFT", prevRowDetailTile, "BOTTOMLEFT");
			else
				if prevColDetailTile then
					detailTile:SetPoint("TOPLEFT", prevColDetailTile, "TOPRIGHT");
				else
					detailTile:SetPoint("TOPLEFT", self);
				end
			end
			detailTile:SetDrawLayer("BACKGROUND", -8 + self.layerIndex);
			detailTile:Show();			
			prevRowDetailTile = detailTile;
			if tileRow == 1 then
				prevColDetailTile = detailTile;
			end
		end
	end
	
	-- Add explored overlay
	if (exploredMapTextures) then
		local TILE_SIZE_WIDTH = layerInfo.tileWidth;
		local TILE_SIZE_HEIGHT = layerInfo.tileHeight;
		for i, exploredTextureInfo in ipairs(exploredMapTextures) do
			local numTexturesWide = ceil(exploredTextureInfo.textureWidth/TILE_SIZE_WIDTH);
			local numTexturesTall = ceil(exploredTextureInfo.textureHeight/TILE_SIZE_HEIGHT);
			local texturePixelWidth, textureFileWidth, texturePixelHeight, textureFileHeight;
			for j = 1, numTexturesTall do
				if ( j < numTexturesTall ) then
					texturePixelHeight = TILE_SIZE_HEIGHT;
					textureFileHeight = TILE_SIZE_HEIGHT;
				else
					texturePixelHeight = mod(exploredTextureInfo.textureHeight, TILE_SIZE_HEIGHT);
					if ( texturePixelHeight == 0 ) then
						texturePixelHeight = TILE_SIZE_HEIGHT;
					end
					textureFileHeight = 16;
					while(textureFileHeight < texturePixelHeight) do
						textureFileHeight = textureFileHeight * 2;
					end
				end
				for k = 1, numTexturesWide do
					local texture = self.overlayTexturePool:Acquire();
					self.textureLoadGroup:AddTexture(texture);
					if ( k < numTexturesWide ) then
						texturePixelWidth = TILE_SIZE_WIDTH;
						textureFileWidth = TILE_SIZE_WIDTH;
					else
						texturePixelWidth = mod(exploredTextureInfo.textureWidth, TILE_SIZE_WIDTH);
						if ( texturePixelWidth == 0 ) then
							texturePixelWidth = TILE_SIZE_WIDTH;
						end
						textureFileWidth = 16;
						while(textureFileWidth < texturePixelWidth) do
							textureFileWidth = textureFileWidth * 2;
						end
					end
					texture:SetWidth(texturePixelWidth);
					texture:SetHeight(texturePixelHeight);
					texture:SetTexCoord(0, texturePixelWidth/textureFileWidth, 0, texturePixelHeight/textureFileHeight);
					texture:SetPoint("TOPLEFT", exploredTextureInfo.offsetX + (TILE_SIZE_WIDTH * (k-1)), -(exploredTextureInfo.offsetY + (TILE_SIZE_HEIGHT * (j - 1))));
					texture:SetTexture(exploredTextureInfo.fileDataIDs[((j - 1) * numTexturesWide) + k], nil, nil, "TRILINEAR");
					texture:SetDrawLayer("ARTWORK", -1);
					texture:Show();
				end
			end
		end
	end
	
	-- Rescale
	local mapWidth = layerInfo.layerWidth
	if (mapWidth ~= mapFrame:GetWidth()) then
		local scaleFactor = mapFrame:GetWidth() / mapWidth
		self:SetScale(scaleFactor)
	end
	
	self:RefreshAlpha()
end


function RSExplorerDetailMap:OnUpdate()
	if self.isWaitingForLoad and self.textureLoadGroup:IsFullyLoaded() then
		self.isWaitingForLoad = nil;
		self:RefreshAlpha();
		self.textureLoadGroup:Reset();
	end
end
function RSExplorerDetailMap:RefreshAlpha()
	if (not self.isWaitingForLoad) then
		self:SetAlpha(1);
	else
		self:SetAlpha(0);
	end
end

-----------------------------------------------------
-- Control frames
-----------------------------------------------------

RSExplorerControl = {}

function RSExplorerControl:Initialize(mainFrame)
	self.mainFrame = mainFrame
	self.ApplyFiltersButton:SetText(AL["EXPLORER_FILTERING"])
	self.ApplyFiltersButton.tooltip = string.format(AL["EXPLORER_FILTERING_DESC"], AL["EXPLORER_FILTERS"], AL["EXPLORER_FILTER_COLLECTIONS"])
	self.CreateProfilesBackupCheckButton.Text:SetText(AL["EXPLORER_CREATE_BACKUP"])
	self.CreateProfilesBackupCheckButton.tooltip = string.format(AL["EXPLORER_CREATE_BACKUP_DESC"], AL["EXPLORER_FILTERING"])
	self.CreateProfilesBackupCheckButton:SetChecked(RSConfigDB.IsCreateProfileBackup())
	self.CreateProfilesBackupCheckButton.func = function(self, checked)
		RSConfigDB.SetCreateProfileBackup(checked)
	end
	
	self.AutoFilterCheckButton.Text:SetText(AL["EXPLORER_AUTO_FILTER"])
	self.AutoFilterCheckButton.tooltip = AL["EXPLORER_AUTO_FILTER_DESC"]
	self.AutoFilterCheckButton:SetChecked(RSConfigDB.IsAutoFilteringOnCollect())
	self.AutoFilterCheckButton.func = function(self, checked)
		RSConfigDB.SetAutoFilteringOnCollect(checked)
	end
	
	self.FilterWorldmapCheckButton.Text:SetText(AL["FILTER_NPCS_ONLY_MAP"])
	self.FilterWorldmapCheckButton.tooltip = AL["FILTER_NPCS_ONLY_MAP_DESC"]
	self.FilterWorldmapCheckButton:SetChecked(RSConfigDB.IsNpcFilteredOnlyOnWorldMap())
	self.FilterWorldmapCheckButton.func = function(self, checked)
		RSConfigDB.SetNpcFilteredOnlyOnWorldMap(checked)
	end
end

function RSExplorerControl:StartScanning(self, button)
	if (self:IsShown()) then
		self:Hide()
		self:GetParent().ScanProcessText:Show()
		
		local manualScan = self:GetParent().ScanRequiredText:GetText() == AL["EXPLORER_SCAN_MANUAL"]
		
		RSCollectionsDB.ApplyCollectionsEntitiesFilters(function()
			local mainFrame = self:GetParent():GetParent()
	    	self:GetParent():Hide()
			self:GetParent().ScanProcessText:Hide()
    		mainFrame.RareInfo:Show()
			mainFrame:Initialize()
	    end, self:GetParent().ScanProcessText, manualScan)
	end
end

function RSExplorerControl:ApplyFilters(self, button)
	local mainFrame = self:GetParent().mainFrame
	local data = {
		callback = function()
			mainFrame:Refresh()
			local subdata = {
				filters = filters
			}
			LibDialog:Spawn(RSConstants.APPLY_COLLECTIONS_LOOT_FILTERS, subdata)
		end,
		filters = filters
	}
	LibDialog:Spawn(RSConstants.EXPLORER_FILTERING_DIALOG, data)
end

-----------------------------------------------------
-- Explorer main frame
-----------------------------------------------------

RSExplorerMixin = { };

function RSExplorerMixin:OnLoad()
	self.lootItemsPool = CreateFramePool("Button", self.RareInfo, "RSExplorerRareInfoLootItemTemplate");
	self.RareInfo.Mounts.Texture:SetTexture("Interface\\AddOns\\RareScanner\\Media\\Textures\\MountsCorner.blp")
	self.RareInfo.Mounts.Texture:SetVertexColor(1,1,1,0.5)
	self.RareInfo.Mounts.NoItems:SetText(AL["EXPLORER_NO_MISSING_MOUNTS"])
	self.RareInfo.Pets.Texture:SetTexture("Interface\\AddOns\\RareScanner\\Media\\Textures\\PetsCorner.blp")
	self.RareInfo.Pets.Texture:SetVertexColor(1,1,1,0.5)
	self.RareInfo.Pets.NoItems:SetText(AL["EXPLORER_NO_MISSING_PETS"])
	self.RareInfo.Toys.Texture:SetTexture("Interface\\AddOns\\RareScanner\\Media\\Textures\\ToysCorner.blp")
	self.RareInfo.Toys.Texture:SetVertexColor(1,1,1,0.5)
	self.RareInfo.Toys.NoItems:SetText(AL["EXPLORER_NO_MISSING_TOYS"])
	self.RareInfo.Appearances.Texture:SetTexture("Interface\\AddOns\\RareScanner\\Media\\Textures\\AppearancesCorner.blp")
	self.RareInfo.Appearances.Texture:SetVertexColor(1,1,1,0.5)
	self.RareInfo.Appearances.NoItems:SetText(AL["EXPLORER_NO_MISSING_APPEARANCES"])
	self:RegisterForDrag("LeftButton");
	tinsert(UISpecialFrames, self:GetName());
end

function RSExplorerMixin:HideContentPanels()
	self.RareInfo:Hide()
	self.RareNPCList:Hide()
	self.RareNPCList.background:Hide()
	self.RareNPCList.ElevatedFrame:Hide()
	self.RareNPCList.listScroll:Hide()
	self.Filters:Hide()
	self.Control:Hide()
end

function RSExplorerMixin:ShowContentPanels()
	self.RareInfo:Show()
	self.RareNPCList:Show()
	self.RareNPCList.background:Show()
	self.RareNPCList.ElevatedFrame:Show()
	self.RareNPCList.listScroll:Show()
	self.Filters:Show()
	self.Control:Show()
end

function RSExplorerMixin:Initialize()
	filters[RSConstants.EXPLORER_FILTER_DROP_MOUNTS] = RSConfigDB.IsSearchingMounts()
	filters[RSConstants.EXPLORER_FILTER_DROP_PETS] = RSConfigDB.IsSearchingPets()
	filters[RSConstants.EXPLORER_FILTER_DROP_TOYS] = RSConfigDB.IsSearchingToys()
	filters[RSConstants.EXPLORER_FILTER_DROP_APPEARANCES] = RSConfigDB.IsSearchingAppearances()
	filters[RSConstants.EXPLORER_FILTER_DEAD] = RSConfigDB.IsShowDead()
	filters[RSConstants.EXPLORER_FILTER_FILTERED] = RSConfigDB.IsShowFiltered()
	filters[RSConstants.EXPLORER_FILTER_WITHOUT_COLLECTIBLES] = RSConfigDB.IsShowWithoutCollectibles()
	
	self.Filters:Initialize(self);
	self.RareNPCList:Initialize(self);
	self.Control:Initialize(self);
	self.initialized = true
end

function RSExplorerMixin:OnShow()
    -- check if there is a new database and the whole scan should be done
    if (not RSCollectionsDB.IsCollectionsScanDoneWithCurrentVersion()) then
    	self.ScanRequired.ScanRequiredText:SetText(AL["EXPLORER_SCAN_REQUIRED"])
    	self.ScanRequired.StartScanningButton:SetText(AL["EXPLORER_START_SCAN"])
    	self.ScanRequired.StartScanningButton:Show()
    	self.ScanRequired:Show()
    	self:HideContentPanels()
    -- check if only the current class is missing in the scan
    elseif (not RSCollectionsDB.IsCollectionsScanByClassDone()) then
    	self.ScanRequired.ScanRequiredText:SetText(AL["EXPLORER_SCAN_CLASS_REQUIRED"])
    	self.ScanRequired.StartScanningButton:SetText(AL["EXPLORER_START_SCAN"])
    	self.ScanRequired.StartScanningButton:Show()
    	self.ScanRequired:Show()
    	self:HideContentPanels()
    elseif (not self.initialized) then
		self:Initialize()
	end
	
	self:Show()
end

function RSExplorerMixin:Refresh()
	if (self.initialized) then
		PopulateContinentDropDown(self, self.Filters.ContinentDropDown)
		self.RareNPCList:UpdateRareList()
	end
end

function RSExplorerMixin:ShowTooltip(self, message)
	local tooltip = self:GetParent().mainFrame.Tooltip
	tooltip:SetOwner(self, "ANCHOR_CURSOR")
	tooltip:AddLine(self.tooltip, 1, 1, 1, true)
	tooltip:Show()
end

function RSExplorerMixin:HideTooltip(self)
	local tooltip = self:GetParent().mainFrame.Tooltip
	tooltip:Hide()
end
