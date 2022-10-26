-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local ADDON_NAME, private = ...

-- Locales
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner");

-- LibQTip
local RareScannerMapTooltip = LibStub('LibQTip-1.0RS')

local RSTooltip = private.NewLib("RareScannerTooltip")

-- RareScanner database libraries
local RSNpcDB = private.ImportLib("RareScannerNpcDB")
local RSContainerDB = private.ImportLib("RareScannerContainerDB")
local RSGeneralDB = private.ImportLib("RareScannerGeneralDB")
local RSEventDB = private.ImportLib("RareScannerEventDB")
local RSConfigDB = private.ImportLib("RareScannerConfigDB")
local RSGuideDB = private.ImportLib("RareScannerGuideDB")
local RSAchievementDB = private.ImportLib("RareScannerAchievementDB")

-- RareScanner general libraries
local RSLogger = private.ImportLib("RareScannerLogger")
local RSConstants = private.ImportLib("RareScannerConstants")
local RSUtils = private.ImportLib("RareScannerUtils")
local RSTimeUtils = private.ImportLib("RareScannerTimeUtils")

-- RareScanner service libraries
local RSLootTooltip = private.ImportLib("RareScannerLootTooltip")
local RSNotes = private.ImportLib("RareScannerNotes")
local RSLoot = private.ImportLib("RareScannerLoot")
local RSLootTooltip = private.ImportLib("RareScannerLootTooltip")

--=====================================================
-- LibQtip provider for groups
--=====================================================

local provider, cellPrototype = RareScannerMapTooltip:CreateCellProvider()

local pinFramePool = CreateFramePool("FRAME", UIParent, "RSEntityPinTemplate");

local function GetTipAnchor(frame)
	local x, y = frame:GetCenter()
	if not x or not y then return "TOPLEFT", "BOTTOMLEFT" end
	local hhalf = (x > UIParent:GetWidth() * 2 / 3) and "RIGHT" or (x < UIParent:GetWidth() / 3) and "LEFT" or "LEFT"
	local vhalf = (y > UIParent:GetHeight() / 2) and "TOP" or "BOTTOM"
	return vhalf .. hhalf, frame, (vhalf == "TOP" and "BOTTOM" or "TOP") .. hhalf
end

function cellPrototype:SetupCell(cell, args)
	local parentPin, POI, groupTooltip = unpack(args)
	self.pin = pinFramePool:Acquire()
	self.pin:SetParent(self)
	self.pin:SetAllPoints(self)
	function self.pin:GetMap()
		return parentPin:GetMap()
	end
	self.pin:SetScript("OnEnter", function()
		RSTooltip.ShowSimpleTooltip(self.pin, groupTooltip)
		if (self.pin.tooltip) then
			self.pin.tooltip:ClearAllPoints();
			self.pin.tooltip:SetPoint(GetTipAnchor(groupTooltip))
			groupTooltip.tooltip = self.pin.tooltip
		end
	end)
	self.pin:SetScript("OnLeave", function()
		local _, _, relativePoint = GetTipAnchor(groupTooltip)
		if (RSUtils.Contains(relativePoint, "TOP") and not MouseIsOver(self.pin, 10) or RSUtils.Contains(relativePoint, "BOTTOM") and not MouseIsOver(self.pin, nil, -10)) then
			RSTooltip.HideTooltip(self.pin.tooltip)
			groupTooltip.tooltip = nil
		end
	end)
	self.pin.POI = POI
	self.pin.Texture:SetTexture(POI.Texture)
	--self.pin.Texture:SetScale(RSConfigDB.GetIconsWorldMapScale() - 0.3)
	-- So far leave the scale static, lets see what people think
	self.pin.Texture:SetScale(0.7)
	self.pin:Show()
	return self.pin:GetWidth(), self.pin:GetHeight()
end

function cellPrototype:ReleaseCell()
	pinFramePool:Release(self.pin)
	RSTooltip.ReleaseTooltip(self.pin.tooltip)
end

--=====================================================
-- Auxiliar tooltips functions
--=====================================================

local ItemToolTip = CreateFrame("GameTooltip", "RSMapItemToolTip", nil, "GameTooltipTemplate")
local ItemToolTipComp1 = CreateFrame("GameTooltip", "RSMapItemToolTipComp1", nil, "GameTooltipTemplate")
local ItemToolTipComp2 = CreateFrame("GameTooltip", "RSMapItemToolTipComp2", nil, "GameTooltipTemplate")
local InfoToolTip = CreateFrame("GameTooltip", "RSMapInfoToolTip", nil, "GameTooltipTemplate")
ItemToolTip.shoppingTooltips = { ItemToolTipComp1, ItemToolTipComp2 }

local function showItemToolTip(cell, args)
	local itemID, itemLink, itemClassID, itemSubClassID = unpack(args)
	ItemToolTip:SetScale(RSConfigDB.GetWorldMapLootAchievTooltipsScale())
	if (RSConfigDB.GetWorldMapLootAchievTooltipPosition() == "ANCHOR_LEFT") then
		ItemToolTip:SetOwner(cell:GetParent():GetParent():GetParent(), "ANCHOR_BOTTOMLEFT", 0, cell:GetParent():GetParent():GetParent():GetHeight())	
	elseif (RSConfigDB.GetWorldMapLootAchievTooltipPosition() == "ANCHOR_RIGHT") then
		ItemToolTip:SetOwner(cell:GetParent():GetParent():GetParent(), "ANCHOR_BOTTOMRIGHT", 0, cell:GetParent():GetParent():GetParent():GetHeight())	
	elseif (RSConfigDB.GetWorldMapLootAchievTooltipPosition() == "ANCHOR_TOPLEFT") then
		ItemToolTip:SetOwner(cell:GetParent():GetParent():GetParent(), "ANCHOR_LEFT")	
	elseif (RSConfigDB.GetWorldMapLootAchievTooltipPosition() == "ANCHOR_TOPRIGHT") then
		ItemToolTip:SetOwner(cell:GetParent():GetParent():GetParent(), "ANCHOR_RIGHT")	
	else
		ItemToolTip:SetOwner(cell:GetParent():GetParent():GetParent(), RSConfigDB.GetWorldMapLootAchievTooltipPosition())	
	end

	ItemToolTip:SetHyperlink(itemLink)
	ItemToolTip:SetFrameLevel(cell:GetParent():GetParent():GetParent():GetFrameLevel() + 100)
	
	-- Adds extra information
	RSLootTooltip.AddRareScannerInformation(ItemToolTip, itemLink, itemID, itemClassID, itemSubClassID)
	ItemToolTip:Show()
end

local function showItemComparationTooltip(cell)
	if (IsShiftKeyDown() and ItemToolTip:IsShown()) then
		ItemToolTipComp1:SetScale(RSConfigDB.GetWorldMapLootAchievTooltipsScale())
		ItemToolTipComp2:SetScale(RSConfigDB.GetWorldMapLootAchievTooltipsScale())
		ItemToolTipComp1:SetFrameLevel(2100)
		ItemToolTipComp2:SetFrameLevel(2100)
		GameTooltip_OnTooltipSetShoppingItem(ItemToolTip)
		GameTooltip_ShowCompareItem(ItemToolTip)
		cell:SetPropagateKeyboardInput(false)
	else
		cell:SetPropagateKeyboardInput(true)
	end
end

local function hideItemComparationTooltip(cell)
	GameTooltip_HideShoppingTooltips(ItemToolTip)
	cell:SetPropagateKeyboardInput(true)
end

local function hideItemToolTip(cell)
	ItemToolTip:Hide()
end

local function filterItem(cell, args)
	local itemID, itemClassID, itemSubClassID, itemLink = unpack(args)

	if (IsControlKeyDown()) then
		DressUpItemLink(itemLink)
		DressUpBattlePetLink(itemLink)
		DressUpMountLink(itemLink)
	elseif (IsAltKeyDown()) then
		if (IsShiftKeyDown()) then
			if (not RSConfigDB.GetItemFiltered(itemID)) then
				RSConfigDB.SetItemFiltered(itemID, true)
				RSLogger:PrintMessage(string.format(AL["LOOT_INDIVIDUAL_FILTERED"], itemLink))
			else
				RSConfigDB.SetItemFiltered(itemID, false)
				RSLogger:PrintMessage(string.format(AL["LOOT_INDIVIDUAL_NOT_FILTERED"], itemLink))
			end
			-- Refresh options panel (if its being initialized)
			if (private.loadFilteredItems) then
				private.loadFilteredItems()
			end
		else
			if (RSConfigDB.GetLootFilterByCategory(itemClassID, itemSubClassID)) then
				RSConfigDB.SetLootFilterByCategory(itemClassID, itemSubClassID, false)
				RSLogger:PrintMessage(string.format(AL["LOOT_CATEGORY_FILTERED"], GetItemClassInfo(itemClassID), GetItemSubClassInfo(itemClassID, itemSubClassID)))
			else
				RSConfigDB.SetLootFilterByCategory(itemClassID, itemSubClassID, true)
				RSLogger:PrintMessage(string.format(AL["LOOT_CATEGORY_NOT_FILTERED"], GetItemClassInfo(itemClassID), GetItemSubClassInfo(itemClassID, itemSubClassID)))
			end
		end
	end
end

local function hideInfoTooltip()
	InfoToolTip:Hide()
end

local function showInfoTooltip(cell, value)
	InfoToolTip:SetScale(RSConfigDB.GetWorldMapLootAchievTooltipsScale())
	InfoToolTip:SetOwner(cell, "ANCHOR_LEFT")
	InfoToolTip:SetFrameLevel(2100)
	InfoToolTip:SetText(value)
	InfoToolTip:Show()
end

local function showAchievementTooltip(cell, achievementLink)
	ItemToolTip:SetScale(RSConfigDB.GetWorldMapLootAchievTooltipsScale())
	ItemToolTip:SetOwner(cell:GetParent():GetParent():GetParent(), "ANCHOR_LEFT")
	ItemToolTip:SetHyperlink(achievementLink)
	ItemToolTip:Show()
end

--=====================================================
-- Tooltip lines
--=====================================================

function RSTooltip.ShowGroupTooltip(pin)
	-- If a tooltip is already being displayed, dont add another one
	if (pin.groupTooltip and not RSTooltip.HideGroupTooltip(pin.groupTooltip)) then
		return
	end

	local tpColumns = table.getn(pin.POI.POIs)

	local identation = {}
	for i=1, tpColumns do
		tinsert(identation, "CENTER");
	end

	-- Avoid to reuse one tooltip that for whatever reason was already opened
	local groupTooltip = RareScannerMapTooltip:Acquire("RsGroupMapToolTip", tpColumns, unpack(identation))
	RSTooltip.HideGroupTooltip(groupTooltip)
	groupTooltip = RareScannerMapTooltip:Acquire("RsGroupMapToolTip", tpColumns, unpack(identation))

	pin.groupTooltip = groupTooltip
	groupTooltip:SetScale(RSConfigDB.GetWorldMapTooltipsScale())
	groupTooltip:SetFrameLevel(2000)
	groupTooltip:ClearAllPoints()
	groupTooltip:SetClampedToScreen(true)
	groupTooltip:SetScript("OnLeave", function()
		RSTooltip.HideGroupTooltip(pin.groupTooltip)
	end)

	local line = groupTooltip:AddLine()
	for i, POI in ipairs (pin.POI.POIs) do
		groupTooltip:SetCell(line, i, { pin, POI, groupTooltip }, nil, "LEFT", 1, provider)
	end

	groupTooltip:SmartAnchorTo(pin)
	groupTooltip:Show()
end

local function AddLastTimeSeenTooltip(tooltip, pin)
	if (not RSConfigDB.IsShowingTooltipsSeen() or pin.POI.isDragonGlyph) then
		return
	end
	
	local line = tooltip:AddLine()
	if (pin.POI.isDiscovered) then
		tooltip:SetCell(line, 1, string.format(AL["MAP_TOOLTIP_SEEN"], RSUtils.TextColor(RSTimeUtils.TimeStampToClock(pin.POI.foundTime, true), "FF8000")), nil, "LEFT", 10, nil, nil, nil, RSConstants.TOOLTIP_MAX_WIDTH, RSConstants.TOOLTIP_MAX_WIDTH)
	else
		tooltip:SetCell(line, 1, RSUtils.TextColor(AL["MAP_TOOLTIP_NOT_FOUND"], "FF0000"), nil, "LEFT", 10, nil, nil, nil, RSConstants.TOOLTIP_MAX_WIDTH, RSConstants.TOOLTIP_MAX_WIDTH)
	end
end

local function AddAchievementTooltip(tooltip, pin, addSeparator)
	local achievementAdded = false
	if (not RSConfigDB.IsShowingTooltipsAchievements()) then
		return achievementAdded
	end
	
	if (RSUtils.GetTableLength(pin.POI.achievementIDs) > 0) then
		if (addSeparator) then
			tooltip:AddSeparator(1)
		end
			
		local line = tooltip:AddLine()	
		tooltip:SetLineColor(line, 0.9,0.8,0.2,0.2)
		tooltip:SetCell(line, 1, "|TInterface\\AddOns\\RareScanner\\Media\\Textures\\tooltip_shield:24:24:0:0|t", nil, "CENTER", 1, nil, nil, nil, nil, 24, 24)
		tooltip:SetCellScript(line, 1, "OnEnter", showInfoTooltip, ACHIEVEMENTS)
		tooltip:SetCellScript(line, 1, "OnLeave", hideInfoTooltip)
		
		local j
		local k
		for i, achievementID in ipairs(pin.POI.achievementIDs) do
			k = i + 1
			j = (k - floor(k/10) * 10)
			if (j == 0) then
				j = 10
			end
			
			tooltip:SetCell(line, j, "|T"..RSAchievementDB.GetCachedAchievementInfo(achievementID).icon..":24|t", nil, "LEFT", 1, nil, nil, nil, nil, 24, 24)
			tooltip:SetCellScript(line, j, "OnEnter", showAchievementTooltip, RSAchievementDB.GetCachedAchievementInfo(achievementID).link)
			tooltip:SetCellScript(line, j, "OnLeave", hideItemToolTip)
			
			if (floor(j%10) == 0) then
				line = tooltip:AddLine()
			end
		end

		-- fill with white spaces
		if (j < 9) then
			tooltip:SetCell(line, j+1, " ", nil, "LEFT", 10-j, nil, nil, nil, nil, 30 * (10 - j), 30 * (10 - j))
		end
		
		tooltip:AddSeparator(1)
		achievementAdded = true
	end
	
	return achievementAdded
end

local function AddNotesTooltip(tooltip, pin)
	if (not RSConfigDB.IsShowingTooltipsNotes()) then
		return
	end
	
	local note = RSNotes.GetNote(pin.POI.entityID, pin.POI.mapID)
	if (note) then
		local line = tooltip:AddLine()
		tooltip:SetCell(line, 1, RSUtils.TextColor(note, "FFFFCC"), nil, "LEFT", 10, nil, nil, nil, RSConstants.TOOLTIP_MAX_WIDTH, RSConstants.TOOLTIP_MAX_WIDTH)
	end
end

local function AddLootTooltip(tooltip, pin)	
	local lootAdded = false
	if (RSConfigDB.IsShowingLootOnWorldMap()) then
		local itemsIDs
		if (pin.POI.isNpc) then
			itemsIDs = RSNpcDB.GetNpcLoot(pin.POI.entityID)
		elseif (pin.POI.isContainer) then
			itemsIDs = RSContainerDB.GetContainerLoot(pin.POI.entityID)
		end

		-- Apply loot filters
		local itemsIDsFiltered = {}
		if (RSUtils.GetTableLength(itemsIDs) > 0) then
			for i, itemID in ipairs(itemsIDs) do
				local itemLink, itemRarity, itemEquipLoc, iconFileDataID, itemClassID, itemSubClassID = RSGeneralDB.GetItemInfo(itemID)
				if (iconFileDataID and not RSLoot.IsFiltered(pin.POI.entityID, itemID, itemLink, itemRarity, itemEquipLoc, itemClassID, itemSubClassID)) then
					local itemInfo = { itemID, itemLink, itemRarity, itemEquipLoc, iconFileDataID, itemClassID, itemSubClassID }
					tinsert(itemsIDsFiltered, itemInfo)
				end
			end
		end
			
		-- Sort loot by Class and SubClass
		table.sort(itemsIDsFiltered, function(a, b) 
			if a[6] == b[6] then
				return a[7] < b[7]
			else
				return a[6] < b[6] 
			end
		end)

		-- Add loot to the tooltip
		if (RSUtils.GetTableLength(itemsIDsFiltered) > 0) then
			tooltip:AddSeparator(1)
					
			local line = tooltip:AddLine()		

			local j
			for i, itemInfo in ipairs(itemsIDsFiltered) do
				local itemLink, itemRarity, itemEquipLoc, iconFileDataID, itemClassID, itemSubClassID = RSGeneralDB.GetItemInfo(itemInfo[1])
			
				j = (i - floor(i/10) * 10)
				if (j == 0) then
					j = 10
				end

				tooltip:SetCell(line, j, "|T"..iconFileDataID..":24|t", nil, "LEFT", 1, nil, nil, nil, nil, 20, 20)
				tooltip:SetCellScript(line, j, "OnEnter", showItemToolTip, { itemInfo[1], itemLink, itemClassID, itemSubClassID });
				tooltip:SetCellScript(line, j, "OnKeyDown", showItemComparationTooltip);
				tooltip:SetCellScript(line, j, "OnKeyUp", hideItemComparationTooltip);
				tooltip:SetCellScript(line, j, "OnLeave", hideItemToolTip)
				tooltip:SetCellScript(line, j, "OnMouseDown", filterItem, { itemInfo[1], itemClassID, itemSubClassID, itemLink })

				if (floor(j%10) == 0) then
					line = tooltip:AddLine()
				end
			end

			-- fill with white spaces
			if (j < 9) then
				tooltip:SetCell(line, j+1, " ", nil, "LEFT", 10-j, nil, nil, nil, nil, 30 * (10 - j), 30 * (10 - j))
			end

			tooltip:AddSeparator(1)
			lootAdded = true
		end
	end
	
	return lootAdded
end

local function AddStateTooltip(tooltip, pin)
	-- Skip if worldmap icon
	if (pin.POI.worldmap) then
		return
	end
	
	if ((pin.POI.isNpc and pin.POI.isDead) or (pin.POI.isContainer and pin.POI.isOpened) or (pin.POI.isEvent and pin.POI.isCompleted)) then
		local rareKilledTime = RSNpcDB.GetNpcKilledRespawnTime(pin.POI.entityID)
		local containerOpenedTime = RSContainerDB.GetContainerOpenedRespawnTime(pin.POI.entityID)
		local eventCompletedTime = RSEventDB.GetEventCompletedRespawnTime(pin.POI.entityID)

		local respawnTimer
		if (rareKilledTime and pin.POI.isNpc) then
			if (RSConfigDB.IsShowingTooltipsState()) then
				local rareKilledTimeLeft = rareKilledTime - time()
				if (rareKilledTimeLeft > 0) then
					respawnTimer = RSTimeUtils.TimeStampToClock(rareKilledTimeLeft)
				else
					respawnTimer = AL["MAP_NEVER"]
				end
			end
		elseif (containerOpenedTime and pin.POI.isContainer) then
			if (RSConfigDB.IsShowingTooltipsState()) then
				local containerOpenedTimeLeft = containerOpenedTime - time()
				if (containerOpenedTime > 0) then
					respawnTimer = RSTimeUtils.TimeStampToClock(containerOpenedTimeLeft)
				else
					respawnTimer = AL["MAP_NEVER"]
				end
			end
		elseif (eventCompletedTime and pin.POI.isEvent) then
			if (RSConfigDB.IsShowingTooltipsState()) then
				local eventOpenedTimeLeft = eventCompletedTime - time()
				if (eventCompletedTime > 0) then
					respawnTimer = RSTimeUtils.TimeStampToClock(eventOpenedTimeLeft)
				else
					respawnTimer = AL["MAP_NEVER"]
				end
			end
		end
		
		if (respawnTimer) then
			local line = tooltip:AddLine()	
			tooltip:SetCell(line, 1, RSUtils.TextColor(string.format(AL["MAP_TOOLTIP_RESPAWN"], respawnTimer), "FF0000"), nil, "LEFT", 10, nil, nil, nil, RSConstants.TOOLTIP_MAX_WIDTH, RSConstants.TOOLTIP_MAX_WIDTH)
		end
	end
end

local function AddGuideTooltip(tooltip, pin, addSeparator)
	if (not RSConfigDB.IsShowingTooltipsCommands()) then
		return false
	end
	
	-- Guide
	local guide = false
	if (pin.POI.isNpc) then
		guide = RSGuideDB.GetNpcGuide(pin.POI.entityID, pin.POI.mapID)
	elseif (pin.POI.isContainer) then
		guide = RSGuideDB.GetContainerGuide(pin.POI.entityID, pin.POI.mapID)
	else
		guide = RSGuideDB.GetEventGuide(pin.POI.entityID, pin.POI.mapID)
	end

	if (guide) then
		if (addSeparator) then
			tooltip:AddSeparator(1)
		end
		
		local line = tooltip:AddLine()	
		tooltip:SetCell(line, 1, "|TInterface\\AddOns\\RareScanner\\Media\\Textures\\tooltip_shortcuts:18:60:::128:128:0:96:64:96|t "..RSUtils.TextColor(AL["MAP_TOOLTIP_SHOW_GUIDE"], "05DFDC"), nil, "LEFT", 10, nil, nil, nil, RSConstants.TOOLTIP_MAX_WIDTH, RSConstants.TOOLTIP_MAX_WIDTH)
		return true
	end
	
	return false
end

local function AddOverlayTooltip(tooltip, pin, addSeparator)
	if (not RSConfigDB.IsShowingTooltipsCommands()) then
		return false
	end
	
	local overlay = nil
	if (pin.POI.isNpc) then
		overlay = RSNpcDB.GetInternalNpcOverlay(pin.POI.entityID, pin.POI.mapID)
	elseif (pin.POI.isContainer) then
		overlay = RSContainerDB.GetInternalContainerOverlay(pin.POI.entityID, pin.POI.mapID)
	end

	if (overlay) then
		if (addSeparator) then
			tooltip:AddSeparator(1)
		end
		
		local line = tooltip:AddLine()	
		tooltip:SetCell(line, 1, "|TInterface\\AddOns\\RareScanner\\Media\\Textures\\tooltip_shortcuts:18:60:::128:128:0:96:96:128|t "..RSUtils.TextColor(AL["MAP_TOOLTIP_SHOW_OVERLAY"], "FFF5EE"), nil, "LEFT", 10, nil, nil, nil, RSConstants.TOOLTIP_MAX_WIDTH, RSConstants.TOOLTIP_MAX_WIDTH)
		return true
	end
	
	return false
end

local function AddFilterTooltip(tooltip, pin, addSeparator)
	if (not RSConfigDB.IsShowingTooltipsCommands()) then
		return false
	end
	
	-- Skip if worldmap icon
	if (pin.POI.worldmap) then
		return false
	end
	
	if (addSeparator) then
		tooltip:AddSeparator(1)
	end
	
	local line = tooltip:AddLine()
	tooltip:SetCell(line, 1, "|TInterface\\AddOns\\RareScanner\\Media\\Textures\\tooltip_shortcuts:18:60:::128:128:0:96:0:32|t "..RSUtils.TextColor(AL["MAP_TOOLTIP_FILTER_ENTITY"], "00FF00"), nil, "LEFT", 10, nil, nil, nil, RSConstants.TOOLTIP_MAX_WIDTH, RSConstants.TOOLTIP_MAX_WIDTH)
	return true
end

local function AddWaypointsTooltip(tooltip, pin, addSeparator)
	if (not RSConfigDB.IsShowingTooltipsCommands()) then
		return false
	end
	
	if (not RSConfigDB.IsAddingWorldMapTomtomWaypoints() and not RSConfigDB.IsAddingWorldMapIngameWaypoints()) then
		return false
	end
	
	if (addSeparator) then
		tooltip:AddSeparator(1)
	end
	
	local line = tooltip:AddLine()
	tooltip:SetCell(line, 1, "|TInterface\\AddOns\\RareScanner\\Media\\Textures\\tooltip_shortcuts:18:60:::128:128:0:96:32:64|t "..RSUtils.TextColor(AL["MAP_TOOLTIP_ADD_WAYPOINT"], "FFFF00"), nil, "LEFT", 10, nil, nil, nil, RSConstants.TOOLTIP_MAX_WIDTH, RSConstants.TOOLTIP_MAX_WIDTH)
	return true
end

--=====================================================
-- Functions to show/hide the tooltip
--=====================================================

function RSTooltip.ShowGroupTooltip(pin)
	-- If a tooltip is already being displayed, dont add another one
	if (pin.groupTooltip and not RSTooltip.HideGroupTooltip(pin.groupTooltip)) then
		return
	end

	local tpColumns = table.getn(pin.POI.POIs)

	local identation = {}
	for i=1, tpColumns do
		tinsert(identation, "CENTER");
	end

	-- Avoid to reuse one tooltip that for whatever reason was already opened
	local groupTooltip = RareScannerMapTooltip:Acquire("RsGroupMapToolTip", tpColumns, unpack(identation))
	RSTooltip.HideGroupTooltip(groupTooltip)
	groupTooltip = RareScannerMapTooltip:Acquire("RsGroupMapToolTip", tpColumns, unpack(identation))

	pin.groupTooltip = groupTooltip
	groupTooltip:SetFrameLevel(2000)
	groupTooltip:ClearAllPoints()
	groupTooltip:SetClampedToScreen(true)
	groupTooltip:SetScript("OnLeave", function()
		RSTooltip.HideGroupTooltip(pin.groupTooltip)
	end)

	local line = groupTooltip:AddLine()
	for i, POI in ipairs (pin.POI.POIs) do
		groupTooltip:SetCell(line, i, { pin, POI, groupTooltip }, nil, "LEFT", 1, provider)
	end

	groupTooltip:SmartAnchorTo(pin)
	groupTooltip:Show()
end

function RSTooltip.ShowSimpleTooltip(pin, parentTooltip)
	-- If a tooltip is already being displayed, dont add another one
	if (pin.tooltip and not RSTooltip.HideTooltip(pin.tooltip)) then
		return
	end

	local tooltip = RareScannerMapTooltip:Acquire("RsSimpleMapToolTip", 10, "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER")
	pin.tooltip = tooltip
	tooltip:SetScale(RSConfigDB.GetWorldMapTooltipsScale())
	tooltip:SetFrameLevel(2000)
	tooltip:ClearAllPoints()
	--tooltip:SetCellMarginH(10)
	tooltip:SetClampedToScreen(true)
	tooltip:SetScript("OnLeave", function()
		RSTooltip.HideTooltip(pin.tooltip)
		if (parentTooltip and not MouseIsOver(parentTooltip)) then
			RSTooltip.HideGroupTooltip(parentTooltip)
		end
	end)

	-- NPC name
	local line = tooltip:AddLine()
	if (pin.POI.name) then
		tooltip:SetCell(line, 1, RSUtils.TextColor(pin.POI.name, "3399FF"), nil, "LEFT", 10, nil, nil, nil, RSConstants.TOOLTIP_MAX_WIDTH, RSConstants.TOOLTIP_MAX_WIDTH)
	else
		tooltip:SetCell(line, 1, RSUtils.TextColor(UKNOWNBEING, "3399FF"), nil, "LEFT", 10, nil, nil, nil, RSConstants.TOOLTIP_MAX_WIDTH, RSConstants.TOOLTIP_MAX_WIDTH)
	end

	-- Debug
	if (RSConstants.DEBUG_MODE) then
		line = tooltip:AddLine()
		tooltip:SetCell(line, 1, RSUtils.TextColor(pin.POI.entityID, "FFFFCC"), nil, "LEFT", 10, nil, nil, nil, RSConstants.TOOLTIP_MAX_WIDTH, RSConstants.TOOLTIP_MAX_WIDTH)
		local hasQuestID = false
		if (pin.POI.isNpc and RSNpcDB.GetNpcQuestIdFound(pin.POI.entityID) or (RSNpcDB.GetInternalNpcInfo(pin.POI.entityID) and RSNpcDB.GetInternalNpcInfo(pin.POI.entityID).questID)) then
			hasQuestID = true
		elseif (pin.POI.isContainer and RSContainerDB.GetContainerQuestIdFound(pin.POI.entityID) or (RSContainerDB.GetInternalContainerInfo(pin.POI.entityID) and RSContainerDB.GetInternalContainerInfo(pin.POI.entityID).questID)) then
			hasQuestID = true
		elseif (RSEventDB.GetEventQuestIdFound(pin.POI.entityID) or (RSEventDB.GetInternalEventInfo(pin.POI.entityID) and RSEventDB.GetInternalEventInfo(pin.POI.entityID).questID)) then
			hasQuestID = true
		end
		
		if (not hasQuestID) then
			line = tooltip:AddLine()
			tooltip:SetCell(line, 1, RSUtils.TextColor("No tiene QUESTID", "FF0000"), nil, "LEFT", 10, nil, nil, nil, RSConstants.TOOLTIP_MAX_WIDTH, RSConstants.TOOLTIP_MAX_WIDTH)
		end
	end
	
	-- Last time seen
	AddLastTimeSeenTooltip(tooltip, pin)

	-- Text to display command to auto tag as dead/completed/opened or the time remaining to be available again
	AddStateTooltip(tooltip, pin)

	-- Notes
	AddNotesTooltip(tooltip, pin)

	-- Adds lines for special events
	RSTooltip.AddSpecialEventsLines(pin, tooltip)

	-- Loot
	local lootAdded = AddLootTooltip(tooltip, pin)

	-- Achievement
	local achievementAdded = AddAchievementTooltip(tooltip, pin, not lootAdded)

	-- Text to display command to auto tag as dead/completed/opened or the time remaining to be available again
	local filterAdded = AddFilterTooltip(tooltip, pin, not lootAdded and not achievementAdded)

	-- Waypoints
	local waypointAdded = AddWaypointsTooltip(tooltip, pin, not filterAdded)

	-- Guide
	local guideAdded = AddGuideTooltip(tooltip, pin, not filterAdded and not waypointAdded)

	-- Overlay
	AddOverlayTooltip(tooltip, pin, not filterAdded and not waypointAdded and not guideAdded)
	
	tooltip:SmartAnchorTo(pin)
	tooltip:Show()
end

function RSTooltip.HideTooltip(tooltip)
	if (tooltip) then
		if (MouseIsOver(tooltip)) then
			return false
		end
		RareScannerMapTooltip:Release(tooltip)
		tooltip = nil
		return true
	end
end

function RSTooltip.HideGroupTooltip(groupTooltip)
	if (groupTooltip and groupTooltip.tooltip and groupTooltip.tooltip:IsShown()) then
		return false;
	end

	return RSTooltip.HideTooltip(groupTooltip)
end

function RSTooltip.ReleaseTooltip(tooltip)
	if (tooltip) then
		tooltip:Hide()
		RareScannerMapTooltip:Release(tooltip)
		tooltip = nil
	end
	ItemToolTip:Hide()
end

--=====================================================
-- Events overrider
--=====================================================

function RSTooltip.AddSpecialEventsLines(self, tooltip)
-- Nothing to implement, this method will be hooked wherever its needed
end
