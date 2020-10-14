-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local RareScanner = LibStub("AceAddon-3.0"):GetAddon("RareScanner")
local ADDON_NAME, private = ...

-- Locales
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner");

-- RareScanner database libraries
local RSNpcDB = private.ImportLib("RareScannerNpcDB")
local RSContainerDB = private.ImportLib("RareScannerContainerDB")
local RSGeneralDB = private.ImportLib("RareScannerGeneralDB")
local RSEventDB = private.ImportLib("RareScannerEventDB")
local RSConfigDB = private.ImportLib("RareScannerConfigDB")

-- RareScanner general libraries
local RSLogger = private.ImportLib("RareScannerLogger")
local RSConstants = private.ImportLib("RareScannerConstants")
local RSUtils = private.ImportLib("RareScannerUtils")
local RSTimeUtils = private.ImportLib("RareScannerTimeUtils")

-- RareScanner service libraries
local RSMinimap = private.ImportLib("RareScannerMinimap")
local RSLoot = private.ImportLib("RareScannerLoot")


-- Tooltips
local RareScannerMapTooltip = LibStub('LibQTip-1.0RS')
local ItemToolTip = CreateFrame("GameTooltip", "RSMapItemToolTip", nil, "GameTooltipTemplate")
ItemToolTip:SetScale(0.8)
local ItemToolTipComp1 = CreateFrame("GameTooltip", "RSMapItemToolTipComp1", nil, "GameTooltipTemplate")
ItemToolTipComp1:SetScale(0.6)
local ItemToolTipComp2 = CreateFrame("GameTooltip", "RSMapItemToolTipComp2", nil, "GameTooltipTemplate")
ItemToolTipComp2:SetScale(0.6)
ItemToolTip.shoppingTooltips = { ItemToolTipComp1, ItemToolTipComp2 }

-- Constants
local TOOLTIP_MAX_WIDTH = 250


RSRarePinMixin = CreateFromMixins(MapCanvasPinMixin);
 
function RSRarePinMixin:OnLoad()
	self:SetScalingLimits(1, 0.75, 1.0);
end

function RSRarePinMixin:OnAcquired(POI)
	self:UseFrameLevelType("PIN_FRAME_LEVEL_VIGNETTE", self:GetMap():GetNumActivePinsByTemplate("RSRarePinTemplate"));
	
	self.POI = POI
	self.Texture:SetTexture(POI.Texture)
	self.Texture:SetScale(RSConfigDB.GetIconsWorldMapScale())
	self.HighlightTexture:SetAtlas(atlasName, true);
	self:SetPosition(POI.x, POI.y);
end

local function showItemToolTip(cell, args)
	local itemLink, itemClassID, itemSubClassID = unpack(args)
	ItemToolTip:SetOwner(cell:GetParent(), "ANCHOR_LEFT")
	ItemToolTip:SetHyperlink(itemLink)
	ItemToolTip:AddLine("RareScanner: "..AL["LOOT_TOGGLE_FILTER"], 1,1,0)
	ItemToolTip:AddDoubleLine(GetItemClassInfo(itemClassID), GetItemSubClassInfo(itemClassID, itemSubClassID), 1, 1, 0, 1 ,1, 0);
	ItemToolTip:Show()
end

local function showItemComparationTooltip(cell)
	if (IsShiftKeyDown() and ItemToolTip:IsShown()) then
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
	local itemClassID, itemSubClassID, itemLink = unpack(args)

	if (IsControlKeyDown()) then
		DressUpItemLink(itemLink)
	elseif (IsAltKeyDown()) then
		if (private.db.loot.filteredLootCategories[itemClassID][itemSubClassID]) then
			private.db.loot.filteredLootCategories[itemClassID][itemSubClassID] = false
			RSLogger:PrintMessage(string.format(AL["LOOT_CATEGORY_FILTERED"], GetItemClassInfo(itemClassID), GetItemSubClassInfo(itemClassID, itemSubClassID)))
		else
			private.db.loot.filteredLootCategories[itemClassID][itemSubClassID] = true
			RSLogger:PrintMessage(string.format(AL["LOOT_CATEGORY_NOT_FILTERED"], GetItemClassInfo(itemClassID), GetItemSubClassInfo(itemClassID, itemSubClassID)))
		end
	end
end

local function showAchievementTooltip(cell, achievementLink)
	ItemToolTip:SetOwner(cell:GetParent(), "ANCHOR_LEFT")
	ItemToolTip:SetHyperlink(achievementLink)
	ItemToolTip:Show()
end
 
function RSRarePinMixin:OnMouseEnter()
	if (self.tooltip) then
		RareScannerMapTooltip:Release(self.tooltip)
		self.tooltip:Hide()
		self.tooltip = nil
	end
	local tooltip = RareScannerMapTooltip:Acquire("RsMapToolTip", 10, "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER")
	self.tooltip = tooltip 
	tooltip:SetFrameLevel(2000)
	tooltip:ClearAllPoints()
	tooltip:SetClampedToScreen(true)
	tooltip:SetScript("OnLeave", function()
		if (MouseIsOver(self.tooltip)) then
			return
		end
		RareScannerMapTooltip:Release(self.tooltip)
		self.tooltip:Hide()
		self.tooltip = nil
	end)
	
	-- NPC name
	local line = tooltip:AddLine()
	tooltip:SetCell(line, 1, RSUtils.TextColor(self.POI.name, "3399FF"), nil, "LEFT", 10)
	
	-- Debug
	if (RSConstants.DEBUG_MODE) then
    line = tooltip:AddLine()
    tooltip:SetCell(line, 1, RSUtils.TextColor(self.POI.entityID, "FFFFCC"), nil, "LEFT", 10)
	end
	
	-- Last time seen
	line = tooltip:AddLine()
	if (self.POI.isDiscovered) then
		tooltip:SetCell(line, 1, string.format(AL["MAP_TOOLTIP_SEEN"], RSUtils.TextColor(RSTimeUtils.TimeStampToClock(self.POI.foundTime, true), "FF8000")), nil, "LEFT", 10)
	else
		tooltip:SetCell(line, 1, RSUtils.TextColor(AL["MAP_TOOLTIP_NOT_FOUND"], "FF0000"), nil, "LEFT", 10, nil, nil, nil, TOOLTIP_MAX_WIDTH)
	end
	
	-- Adds lines for special events
	RareScanner:AddSpecialEventsLines(self, tooltip)
	
	-- Achievement
	if (self.POI.achievementLink) then
		line = tooltip:AddLine()
		tooltip:SetCell(line, 1, RSUtils.TextColor(string.format(AL["MAP_TOOLTIP_ACHIEVEMENT"], self.POI.achievementLink), "FFFFCC"), nil, "LEFT", 10, nil, nil, nil, TOOLTIP_MAX_WIDTH)
		tooltip:SetCellScript(line, 1, "OnEnter", showAchievementTooltip, self.POI.achievementLink)
		tooltip:SetCellScript(line, 1, "OnLeave", hideItemToolTip)
	end
	
	-- Notes
	if (AL[string.format("NOTE_%s", self.POI.entityID)] ~= string.format("NOTE_%s", self.POI.entityID)) then
		line = tooltip:AddLine()
		tooltip:SetCell(line, 1, RSUtils.TextColor(AL[string.format("NOTE_%s", self.POI.entityID)], "FFFFCC"), nil, "LEFT", 10, nil, nil, nil, TOOLTIP_MAX_WIDTH)
	end
	
	-- Loot
	if (RSConfigDB.IsShowingLootOnWorldMap()) then
		local itemsIDs
		if (self.POI.isNpc) then
			itemsIDs = RSNpcDB.GetNpcLoot(self.POI.entityID)
		elseif (self.POI.isContainer) then
			itemsIDs = RSContainerDB.GetContainerLoot(self.POI.entityID)
		end

		-- Apply loot filters
		local itemsIDsFiltered = {}
		if (itemsIDs and next(itemsIDs) ~= nil) then
			for i, itemID in ipairs(itemsIDs) do
				local itemLink, itemRarity, itemEquipLoc, iconFileDataID, itemClassID, itemSubClassID = RSGeneralDB.GetItemInfo(itemID)
				if (iconFileDataID and not RSLoot.IsFiltered(itemID, itemLink, itemRarity, itemEquipLoc, itemClassID, itemSubClassID)) then
          tinsert(itemsIDsFiltered, itemID)
        end
			end
		end
		
		-- Add loot to the tooltip
		if (next(itemsIDsFiltered) ~= nil) then
			line = tooltip:AddSeparator(1, 1)
			line = tooltip:AddLine()
		
			local j
			for i, itemID in ipairs(itemsIDsFiltered) do
				j = (i - floor(i/10) * 10)
				if (j == 0) then
					j = 10
				end
			
				local itemLink, itemRarity, itemEquipLoc, iconFileDataID, itemClassID, itemSubClassID = RSGeneralDB.GetItemInfo(itemID)
				tooltip:SetCell(line, j, "|T"..iconFileDataID..":24|t", nil, "CENTER", 1, nil, nil, nil, nil, 24)
				tooltip:SetCellScript(line, j, "OnEnter", showItemToolTip, { itemLink, itemClassID, itemSubClassID });
				tooltip:SetCellScript(line, j, "OnKeyDown", showItemComparationTooltip);
				tooltip:SetCellScript(line, j, "OnKeyUp", hideItemComparationTooltip);
				tooltip:SetCellScript(line, j, "OnLeave", hideItemToolTip)
				tooltip:SetCellScript(line, j, "OnMouseDown", filterItem, { itemClassID, itemSubClassID, itemLink })
				
				if (floor(j%10) == 0) then
					line = tooltip:AddLine()
				end
			end
			
			-- fill with white spaces
			if (j < 9) then
				for k=j+1, 10 do
					tooltip:SetCell(line, k, "", nil, "CENTER", 1, nil, nil, nil, nil, 24)
				end
			end
		end
	end

	-- Text to display command to auto tag as dead/completed/opened
	if ((self.POI.isNpc and not self.POI.isDead) or (self.POI.isContainer and not self.POI.isOpened) or (self.POI.isEvent and not self.POI.isCompleted)) then
		-- Separator
		line = tooltip:AddSeparator(1, 1)
		line = tooltip:AddLine()
		
		local text
		if (self.POI.isNpc) then
			text = AL["MAP_TOOLTIP_KILLED"]
		elseif (self.POI.isContainer) then
			text = AL["MAP_TOOLTIP_CONTAINER_LOOTED"]
		elseif (self.POI.isEvent) then
			text = AL["MAP_TOOLTIP_EVENT_DONE"]
		end
		
		tooltip:SetCell(line, 1, RSUtils.TextColor(text, "00FF00"), nil, "LEFT", 10, nil, nil, nil, TOOLTIP_MAX_WIDTH)
	-- Otherwise text showing the time remaining to be available again
	else
		-- Separator
		line = tooltip:AddSeparator(1, 1)
		line = tooltip:AddLine()
		
		local rareKilledTime = RSNpcDB.GetNpcKilledRespawnTime(self.POI.entityID)
		local containerOpenedTime = RSContainerDB.GetContainerOpenedRespawnTime(self.POI.entityID)
		local eventCompletedTime = RSEventDB.GetEventCompletedRespawnTime(self.POI.entityID)
		
		if (rareKilledTime and self.POI.isNpc) then
			local rareKilledTimeLeft = rareKilledTime - time()
			if (rareKilledTimeLeft > 0) then
				tooltip:SetCell(line, 1, RSUtils.TextColor(string.format(AL["MAP_TOOLTIP_ALREADY_KILLED"], RSTimeUtils.TimeStampToClock(rareKilledTimeLeft)), "FF0000"), nil, "LEFT", 10, nil, nil, nil, TOOLTIP_MAX_WIDTH)
			else
				tooltip:SetCell(line, 1, RSUtils.TextColor(string.format(AL["MAP_TOOLTIP_ALREADY_KILLED"], AL["MAP_NEVER"]), "FF0000"), nil, "LEFT", 10, nil, nil, nil, TOOLTIP_MAX_WIDTH)
			end
		elseif (containerOpenedTime and self.POI.isContainer) then
			local containerOpenedTimeLeft = containerOpenedTime - time()
			if (containerOpenedTime > 0) then
				tooltip:SetCell(line, 1, RSUtils.TextColor(string.format(AL["MAP_TOOLTIP_ALREADY_OPENED"], RSTimeUtils.TimeStampToClock(containerOpenedTimeLeft)), "FF0000"), nil, "LEFT", 10, nil, nil, nil, TOOLTIP_MAX_WIDTH)
			else
				tooltip:SetCell(line, 1, RSUtils.TextColor(string.format(AL["MAP_TOOLTIP_ALREADY_OPENED"], AL["MAP_NEVER"]), "FF0000"), nil, "LEFT", 10, nil, nil, nil, TOOLTIP_MAX_WIDTH)
			end
		elseif (eventCompletedTime and self.POI.isEvent) then
			local eventOpenedTimeLeft = eventCompletedTime - time()
			if (eventCompletedTime > 0) then
				tooltip:SetCell(line, 1, RSUtils.TextColor(string.format(AL["MAP_TOOLTIP_ALREADY_COMPLETED"], RSTimeUtils.TimeStampToClock(eventOpenedTimeLeft)), "FF0000"), nil, "LEFT", 10, nil, nil, nil, TOOLTIP_MAX_WIDTH)
			else
				tooltip:SetCell(line, 1, RSUtils.TextColor(string.format(AL["MAP_TOOLTIP_ALREADY_COMPLETED"], AL["MAP_NEVER"]), "FF0000"), nil, "LEFT", 10, nil, nil, nil, TOOLTIP_MAX_WIDTH)
			end
		end
	end
	
	-- Overlay
	local overlay = nil
  if (self.POI.isNpc) then
   overlay = RSNpcDB.GetInternalNpcOverlay(self.POI.entityID, self.POI.mapID)
  elseif (self.POI.isContainer) then
   overlay = RSContainerDB.GetInternalContainerOverlay(self.POI.entityID, self.POI.mapID)
  end 
  
	if (overlay) then
		line = tooltip:AddSeparator(1, 1)
		line = tooltip:AddLine()
		tooltip:SetCell(line, 1, RSUtils.TextColor(AL["MAP_TOOLTIP_SHOW_OVERLAY"], "00FF00"), nil, "LEFT", 10, nil, nil, nil, TOOLTIP_MAX_WIDTH)
	end
	
	tooltip:SmartAnchorTo(self)
	tooltip:Show()
end
 
function RSRarePinMixin:OnMouseLeave()
	-- Release the tooltip if not checking items
	if (MouseIsOver(self.tooltip)) then
		return
	end
	RareScannerMapTooltip:Release(self.tooltip)
	self.tooltip = nil
end

function RSRarePinMixin:OnMouseDown(button)
	if (button == "LeftButton") then
		--Killed if discovered
		if (IsShiftKeyDown()) then
			-- Ignored
			if (self.POI.isNpc) then
				RareScanner:ProcessKill(self.POI.entityID, true)
				self:Hide();
			elseif (self.POI.isContainer) then
				RareScanner:ProcessOpenContainer(self.POI.entityID, true)
				self:Hide();
			elseif (self.POI.isEvent) then
				RareScanner:ProcessCompletedEvent(self.POI.entityID, true)
				self:Hide();
			end
		-- Toggle overlay
		else
			-- If overlay showing then hide it
			local overlayEntityID = RSGeneralDB.GetOverlayActive()
			if (overlayEntityID) then
				self:GetMap():RemoveAllPinsByTemplate("RSOverlayTemplate");
				if (overlayEntityID ~= self.POI.entityID) then
					self:ShowOverlay()
				else
					RSGeneralDB.RemoveOverlayActive()
				end
			else
				self:ShowOverlay()
			end
		end
		
		-- Refresh minimap
		RSMinimap.RefreshAllData(true)
	end
end

function RSRarePinMixin:ShowOverlay()
    -- Overlay
  local overlay = nil
  if (self.POI.isNpc) then
   overlay = RSNpcDB.GetInternalNpcOverlay(self.POI.entityID, self.POI.mapID)
  elseif (self.POI.isContainer) then
   overlay = RSContainerDB.GetInternalContainerOverlay(self.POI.entityID, self.POI.mapID)
  end
  
	if (overlay) then
		for _, coordinates in ipairs (overlay) do
			local x, y = strsplit("-", coordinates)
			self:GetMap():AcquirePin("RSOverlayTemplate", tonumber(x), tonumber(y), self);
		end
		RSGeneralDB.SetOverlayActive(self.POI.entityID)
	else
		RSGeneralDB.RemoveOverlayActive()
	end
end

function RSRarePinMixin:OnReleased()
	if (self.tooltip) then
		self.tooltip:Hide()
		RareScannerMapTooltip:Release(self.tooltip)
		self.tooltip = nil
	end
	ItemToolTip:Hide()
end

-- Auxiliar functions
function RareScanner:AddSpecialEventsLines(self, tooltip)
	-- Nothing to implement, this method will be hooked wherever its needed
end