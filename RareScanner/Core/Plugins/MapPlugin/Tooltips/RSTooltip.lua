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

-- RareScanner general libraries
local RSLogger = private.ImportLib("RareScannerLogger")
local RSConstants = private.ImportLib("RareScannerConstants")
local RSUtils = private.ImportLib("RareScannerUtils")
local RSTimeUtils = private.ImportLib("RareScannerTimeUtils")

-- RareScanner service libraries
local RSLoot = private.ImportLib("RareScannerLoot")

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
ItemToolTip:SetScale(0.8)
local ItemToolTipComp1 = CreateFrame("GameTooltip", "RSMapItemToolTipComp1", nil, "GameTooltipTemplate")
ItemToolTipComp1:SetScale(0.6)
local ItemToolTipComp2 = CreateFrame("GameTooltip", "RSMapItemToolTipComp2", nil, "GameTooltipTemplate")
ItemToolTipComp2:SetScale(0.6)
ItemToolTip.shoppingTooltips = { ItemToolTipComp1, ItemToolTipComp2 }

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
  local line = tooltip:AddLine()
  if (pin.POI.isDiscovered) then
    tooltip:SetCell(line, 1, string.format(AL["MAP_TOOLTIP_SEEN"], RSUtils.TextColor(RSTimeUtils.TimeStampToClock(pin.POI.foundTime, true), "FF8000")), nil, "LEFT", 10, nil, nil, nil, RSConstants.TOOLTIP_MAX_WIDTH)
  else
    tooltip:SetCell(line, 1, RSUtils.TextColor(AL["MAP_TOOLTIP_NOT_FOUND"], "FF0000"), nil, "LEFT", 10, nil, nil, nil, RSConstants.TOOLTIP_MAX_WIDTH)
  end
end

local function AddAchievementTooltip(tooltip, pin)
  if (pin.POI.achievementLink) then
    local line = tooltip:AddLine()
    tooltip:SetCell(line, 1, RSUtils.TextColor(string.format(AL["MAP_TOOLTIP_ACHIEVEMENT"], pin.POI.achievementLink), "FFFFCC"), nil, "LEFT", 10, nil, nil, nil, RSConstants.TOOLTIP_MAX_WIDTH)
    tooltip:SetCellScript(line, 1, "OnEnter", showAchievementTooltip, pin.POI.achievementLink)
    tooltip:SetCellScript(line, 1, "OnLeave", hideItemToolTip)
  end
end

local function AddNotesTooltip(tooltip, pin)
  if (AL[string.format("NOTE_%s", pin.POI.entityID)] ~= string.format("NOTE_%s", pin.POI.entityID)) then
    local line = tooltip:AddLine()
    tooltip:SetCell(line, 1, RSUtils.TextColor(AL[string.format("NOTE_%s", pin.POI.entityID)], "FFFFCC"), nil, "LEFT", 10, nil, nil, nil, RSConstants.TOOLTIP_MAX_WIDTH)
  elseif (AL[string.format("NOTE_%s_%s", pin.POI.entityID, pin.POI.mapID)] ~= string.format("NOTE_%s_%s", pin.POI.entityID, pin.POI.mapID)) then
    local line = tooltip:AddLine()
    tooltip:SetCell(line, 1, RSUtils.TextColor(AL[string.format("NOTE_%s_%s", pin.POI.entityID, pin.POI.mapID)], "FFFFCC"), nil, "LEFT", 10, nil, nil, nil, RSConstants.TOOLTIP_MAX_WIDTH)
  end
end

local function AddLootTooltip(tooltip, pin)
  if (RSConfigDB.IsShowingLootOnWorldMap()) then
    local itemsIDs
    if (pin.POI.isNpc) then
      itemsIDs = RSNpcDB.GetNpcLoot(pin.POI.entityID)
    elseif (pin.POI.isContainer) then
      itemsIDs = RSContainerDB.GetContainerLoot(pin.POI.entityID)
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
      local line = tooltip:AddLine()
      tooltip:AddSeparator(1.11)
	  line = tooltip:AddLine()
    
      local j
      for i, itemID in ipairs(itemsIDsFiltered) do
        j = (i - floor(i/10) * 10)
        if (j == 0) then
          j = 10
        end
      
        local itemLink, itemRarity, itemEquipLoc, iconFileDataID, itemClassID, itemSubClassID = RSGeneralDB.GetItemInfo(itemID)
        tooltip:SetCell(line, j, "|T"..iconFileDataID..":24|t", nil, "CENTER", 1, nil, nil, nil, nil, 24, 24)
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
          tooltip:SetCell(line, k, "", nil, "CENTER", 1, nil, nil, nil, nil, 24, 24)
        end
      end
	  
	  tooltip:AddSeparator(1.11)
    end
  end
end

local function AddStateTooltip(tooltip, pin)
  -- Separator
  local line = tooltip:AddLine()
  line = tooltip:AddLine()
  
  if ((pin.POI.isNpc and not pin.POI.isDead) or (pin.POI.isContainer and not pin.POI.isOpened) or (pin.POI.isEvent and not pin.POI.isCompleted)) then
    local text
    if (pin.POI.isNpc) then
      text = AL["MAP_TOOLTIP_KILLED"]
    elseif (pin.POI.isContainer) then
      text = AL["MAP_TOOLTIP_CONTAINER_LOOTED"]
    elseif (pin.POI.isEvent) then
      text = AL["MAP_TOOLTIP_EVENT_DONE"]
    end
    
    tooltip:SetCell(line, 1, RSUtils.TextColor(text, "00FF00"), nil, "LEFT", 10, nil, nil, nil, RSConstants.TOOLTIP_MAX_WIDTH)
  -- Otherwise text showing the time remaining to be available again
  else    
    local rareKilledTime = RSNpcDB.GetNpcKilledRespawnTime(pin.POI.entityID)
    local containerOpenedTime = RSContainerDB.GetContainerOpenedRespawnTime(pin.POI.entityID)
    local eventCompletedTime = RSEventDB.GetEventCompletedRespawnTime(pin.POI.entityID)
    
    if (rareKilledTime and pin.POI.isNpc) then
      local rareKilledTimeLeft = rareKilledTime - time()
      if (rareKilledTimeLeft > 0) then
        tooltip:SetCell(line, 1, RSUtils.TextColor(string.format(AL["MAP_TOOLTIP_ALREADY_KILLED"], RSTimeUtils.TimeStampToClock(rareKilledTimeLeft)), "FF0000"), nil, "LEFT", 10, nil, nil, nil, RSConstants.TOOLTIP_MAX_WIDTH)
      else
        tooltip:SetCell(line, 1, RSUtils.TextColor(string.format(AL["MAP_TOOLTIP_ALREADY_KILLED"], AL["MAP_NEVER"]), "FF0000"), nil, "LEFT", 10, nil, nil, nil, RSConstants.TOOLTIP_MAX_WIDTH)
      end
    elseif (containerOpenedTime and pin.POI.isContainer) then
      local containerOpenedTimeLeft = containerOpenedTime - time()
      if (containerOpenedTime > 0) then
        tooltip:SetCell(line, 1, RSUtils.TextColor(string.format(AL["MAP_TOOLTIP_ALREADY_OPENED"], RSTimeUtils.TimeStampToClock(containerOpenedTimeLeft)), "FF0000"), nil, "LEFT", 10, nil, nil, nil, RSConstants.TOOLTIP_MAX_WIDTH)
      else
        tooltip:SetCell(line, 1, RSUtils.TextColor(string.format(AL["MAP_TOOLTIP_ALREADY_OPENED"], AL["MAP_NEVER"]), "FF0000"), nil, "LEFT", 10, nil, nil, nil, RSConstants.TOOLTIP_MAX_WIDTH)
      end
    elseif (eventCompletedTime and pin.POI.isEvent) then
      local eventOpenedTimeLeft = eventCompletedTime - time()
      if (eventCompletedTime > 0) then
        tooltip:SetCell(line, 1, RSUtils.TextColor(string.format(AL["MAP_TOOLTIP_ALREADY_COMPLETED"], RSTimeUtils.TimeStampToClock(eventOpenedTimeLeft)), "FF0000"), nil, "LEFT", 10, nil, nil, nil, RSConstants.TOOLTIP_MAX_WIDTH)
      else
        tooltip:SetCell(line, 1, RSUtils.TextColor(string.format(AL["MAP_TOOLTIP_ALREADY_COMPLETED"], AL["MAP_NEVER"]), "FF0000"), nil, "LEFT", 10, nil, nil, nil, RSConstants.TOOLTIP_MAX_WIDTH)
      end
    end
  end
end

local function AddGuideTooltip(tooltip, pin)
  -- Guide
  local guide = nil
  if (pin.POI.isNpc) then
   guide = RSGuideDB.GetNpcGuide(pin.POI.entityID)
  elseif (pin.POI.isContainer) then
   guide = RSGuideDB.GetContainerGuide(pin.POI.entityID)
  else
   guide = RSGuideDB.GetEventGuide(pin.POI.entityID)
  end 
  
  if (guide) then
    local line = tooltip:AddLine()
    tooltip:SetCell(line, 1, RSUtils.TextColor(AL["MAP_TOOLTIP_SHOW_GUIDE"], "05DFDC"), nil, "LEFT", 10, nil, nil, nil, RSConstants.TOOLTIP_MAX_WIDTH)
  end
end

local function AddOverlayTooltip(tooltip, pin)
  -- Guide
  local overlay = nil
  if (pin.POI.isNpc) then
   overlay = RSNpcDB.GetInternalNpcOverlay(pin.POI.entityID, pin.POI.mapID)
  elseif (pin.POI.isContainer) then
   overlay = RSContainerDB.GetInternalContainerOverlay(pin.POI.entityID, pin.POI.mapID)
  end 
  
  if (overlay) then
    local line = tooltip:AddLine()
    tooltip:SetCell(line, 1, RSUtils.TextColor(AL["MAP_TOOLTIP_SHOW_OVERLAY"], "00FF00"), nil, "LEFT", 10, nil, nil, nil, RSConstants.TOOLTIP_MAX_WIDTH)
  end
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
  tooltip:SetFrameLevel(2000)
  tooltip:ClearAllPoints()
  tooltip:SetClampedToScreen(true)
  tooltip:SetScript("OnLeave", function()
    RSTooltip.HideTooltip(pin.tooltip)
    if (parentTooltip and not MouseIsOver(parentTooltip)) then
      RSTooltip.HideGroupTooltip(parentTooltip)
    end
  end)
  
   -- NPC name
  local line = tooltip:AddLine()
  tooltip:SetCell(line, 1, RSUtils.TextColor(pin.POI.name, "3399FF"), nil, "LEFT", 10)
  
  -- Debug
  if (RSConstants.DEBUG_MODE) then
    line = tooltip:AddLine()
    tooltip:SetCell(line, 1, RSUtils.TextColor(pin.POI.entityID, "FFFFCC"), nil, "LEFT", 10)
  end
  
  -- Last time seen
  AddLastTimeSeenTooltip(tooltip, pin)
  
  -- Adds lines for special events
  RSTooltip.AddSpecialEventsLines(pin, tooltip)
  
  -- Achievement
  AddAchievementTooltip(tooltip, pin)
  
  -- Notes
  AddNotesTooltip(tooltip, pin)
  
  -- Loot
  AddLootTooltip(tooltip, pin)
  
  -- Guide
  AddGuideTooltip(tooltip, pin)

  -- Text to display command to auto tag as dead/completed/opened or the time remaining to be available again
  AddStateTooltip(tooltip, pin)
  
  -- Overlay
  AddOverlayTooltip(tooltip, pin)
  
  tooltip:SmartAnchorTo(pin)
  tooltip:Show()
end

function RSTooltip.HideTooltip(tooltip)
  if (tooltip) then
    if (MouseIsOver(tooltip)) then
      return false;
    end
    RareScannerMapTooltip:Release(tooltip)
    tooltip = nil
    return true;
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