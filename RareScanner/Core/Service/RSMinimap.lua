-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local ADDON_NAME, private = ...

-- Locales
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner");

-- Minimap pins
local HBD_Pins = LibStub("HereBeDragons-Pins-2.0")

-- Minimap icon
local ldi = LibStub("LibDBIcon-1.0")

local RSMinimap = private.NewLib("RareScannerMinimap")

-- RareScanner database libraries
local RSGeneralDB = private.ImportLib("RareScannerGeneralDB")
local RSConfigDB = private.ImportLib("RareScannerConfigDB")
local RSNpcDB = private.ImportLib("RareScannerNpcDB")
local RSContainerDB = private.ImportLib("RareScannerContainerDB")
local RSEventDB = private.ImportLib("RareScannerEventDB")
local RSGuideDB = private.ImportLib("RareScannerGuideDB")

-- RareScanner services
local RSMap = private.ImportLib("RareScannerMap")
local RSNpcPOI = private.ImportLib("RareScannerNpcPOI")
local RSContainerPOI = private.ImportLib("RareScannerContainerPOI")
local RSEventPOI = private.ImportLib("RareScannerEventPOI")
local RSGuidePOI = private.ImportLib("RareScannerGuidePOI")

-- RareScanner general libraries
local RSConstants = private.ImportLib("RareScannerConstants")
local RSLogger = private.ImportLib("RareScannerLogger")
local RSUtils = private.ImportLib("RareScannerUtils")

---============================================================================
-- Minimap button
---============================================================================

local MINIMAP_BUTTON_NAME = "RareScannerMinimapIcon"

function RSMinimap.LoadMinimapButton()
	local RareScannerMinimapLDB = LibStub("LibDataBroker-1.1"):NewDataObject("RareScannerLDB", {
		type = "data source",
		text = "RareScanner",
		label = "RareScanner",
		icon = RSConstants.NORMAL_NPC_TEXTURE,
		OnClick = function(self, button) 
			if (button == "LeftButton") then
				RSExplorerFrame:Show()
			elseif (button == "RightButton") then
				InterfaceOptionsFrame_OpenToCategory("RareScanner")
				InterfaceOptionsFrame_OpenToCategory("RareScanner")
			end
		end,
		OnTooltipShow = function(tooltip)
			tooltip:SetText("RareScanner")
			tooltip:AddLine(AL["MINIMAP_ICON_TOOLTIP1"], 1, 1, 1)
			tooltip:AddLine(AL["MINIMAP_ICON_TOOLTIP2"], 1, 1, 1)
		end
	})
	
	ldi:Register(MINIMAP_BUTTON_NAME, RareScannerMinimapLDB, RSConfigDB.GetMMinimapButtonDB()) 
end

function RSMinimap.ToggleMinimapButton() 
	if (RSConfigDB.IsShowingMinimapButton()) then 
		ldi:Show(MINIMAP_BUTTON_NAME) 
	else 
		ldi:Hide(MINIMAP_BUTTON_NAME) 
	end 
end

---============================================================================
-- All layerers
---============================================================================

local previousMapID
local pinFramesPool
local overlayFramesPool
local guideFramesPool

function RSMinimap.RemoveAllData()
	HBD_Pins:RemoveAllMinimapIcons(RSMinimap)
	
	if (pinFramesPool) then
		pinFramesPool:ReleaseAll()
	end
	
	if (overlayFramesPool) then
		overlayFramesPool:ReleaseAll()
	end
	
	if (guideFramesPool) then
		guideFramesPool:ReleaseAll()
	end
end

---============================================================================
-- Entities layer
---============================================================================

function RSMinimap.RefreshAllData(forzed)
	-- Ignore if minimap not available
	if (not Minimap:IsVisible()) then
		RSMinimap.RemoveAllData()
		return
	end
	
	-- Ignore if not showing icons in the minimap
	if (not RSConfigDB:IsShowingMinimapIcons()) then
		RSMinimap.RemoveAllData()
		return
	end

	-- Gets MAPID from players position
	local mapID = C_Map.GetBestMapForUnit("player")
	if (not mapID or mapID == 0) then
		return
	end

	-- If same zone ignore it
	if (not forzed and previousMapID and previousMapID == mapID) then
		return
	end

	-- Initialize pool
	if (not pinFramesPool) then
		pinFramesPool = CreateFramePool("FRAME", Minimap, "RSMinimapPinTemplate");
	end

	-- Release current pins
	RSMinimap.RemoveAllData()

	-- Otherwise refresh data
	previousMapID = mapID

	-- Loads new pins
	local POIs = RSMap.GetMapPOIs(mapID, false, true)
	if (not POIs) then
		return
	end

	for _, POI in ipairs (POIs) do
		local pin = pinFramesPool:Acquire()
		pin.POI = POI
			
		-- Ignore POIs from worldmap
		if (not POI.worldmap) then
			pin.Texture:SetTexture(POI.Texture)
			pin.Texture:SetScale(RSConfigDB.GetIconsMinimapScale())
			HBD_Pins:AddMinimapIconMap(RSMinimap, pin, POI.mapID, RSUtils.FixCoord(POI.x), RSUtils.FixCoord(POI.y), false, false)
		end
	end
	
	-- Adds overlay if active
	for entityID, _ in pairs (RSGeneralDB.GetAllOverlayActive()) do
		RSMinimap.AddOverlay(entityID)
	end
	
	-- Adds guide if active
	if (RSGeneralDB.GetGuideActive()) then
		RSMinimap.AddGuide(RSGeneralDB.GetGuideActive())
	end
end

function RSMinimap.RefreshEntityState(entityID)
	if (pinFramesPool) then
		for pin in pinFramesPool:EnumerateActive() do
			local POI = pin.POI
			if (POI.entityID == entityID) then
				HBD_Pins:RemoveMinimapIcon(RSMinimap, pin)
				
				local isFiltered = false
				if (POI.isNpc) then
					POI = RSNpcPOI.GetNpcPOI(entityID, POI.mapID, RSNpcDB.GetInternalNpcInfo(entityID), RSGeneralDB.GetAlreadyFoundEntity(entityID))
					if (POI.isDead and not RSConfigDB.IsShowingDeadNpcs()) then
						isFiltered = true
					end
				elseif (POI.isContainer) then
					POI = RSContainerPOI.GetContainerPOI(entityID, POI.mapID, RSContainerDB.GetInternalContainerInfo(entityID), RSGeneralDB.GetAlreadyFoundEntity(entityID))
					if (POI.isOpened and not RSConfigDB.IsShowingOpenedContainers()) then
						isFiltered = true
					end
				elseif (POI.isEvent) then
					POI = RSEventPOI.GetEventPOI(entityID, POI.mapID, RSEventDB.GetInternalEventInfo(entityID), RSGeneralDB.GetAlreadyFoundEntity(entityID))
					if (POI.isCompleted and not RSConfigDB.IsShowingCompletedEvents()) then
						isFiltered = true
					end
				end
				
				if (isFiltered) then
					pinFramesPool:Release(pin)
				else
					pin.Texture:SetTexture(POI.Texture)
					pin.Texture:SetScale(RSConfigDB.GetIconsMinimapScale())
					HBD_Pins:AddMinimapIconMap(RSMinimap, pin, POI.mapID, RSUtils.FixCoord(POI.x), RSUtils.FixCoord(POI.y), false, false)
				end
				
				break
			end
		end
	end
end

function RSMinimap.HideIcon(entityID)
	if (pinFramesPool) then
		for pin in pinFramesPool:EnumerateActive() do
			local POI = pin.POI
			if (POI.entityID == entityID) then
				HBD_Pins:RemoveMinimapIcon(RSMinimap, pin)
				break
			end
		end
	end
end

---============================================================================
-- Overlay layer
---============================================================================

function RSMinimap.AddOverlay(entityID)
	-- Gets MAPID from players position
	local mapID = C_Map.GetBestMapForUnit("player")
	if (not mapID or mapID == 0) then
		return
	end
	
	-- Check if the entity is actually active
	local overlayActive = RSGeneralDB.GetOverlayActive(entityID)
	if (not overlayActive) then
		return
	end
	
	-- Gets the information of the entity
	local isNpc = false
	local isContainer = false
	if (RSNpcDB.GetInternalNpcInfo(entityID)) then
		isNpc = true
	elseif (RSContainerDB.GetInternalContainerInfo(entityID)) then
		isContainer = true
	end
	
	-- Check if the entity belongs to that map
	if ((isNpc and not RSNpcDB.IsInternalNpcInMap(entityID, mapID)) or (isContainer and not RSContainerDB.IsInternalContainerInMap(entityID, mapID))) then
		return
	end
	
	-- Initializes the pool
	if (not overlayFramesPool) then
		overlayFramesPool = CreateFramePool("FRAME", Minimap, "RSMinimapPinTemplate");
	end

	local overlay = nil
	if (isNpc) then
		overlay = RSNpcDB.GetInternalNpcOverlay(entityID, mapID)
	elseif (isContainer) then
		overlay = RSContainerDB.GetInternalContainerOverlay(entityID, mapID)
	end

	if (overlay) then
		local r, g, b = RSConfigDB.GetWorldMapOverlayColour(overlayActive.colourID)		
		for _, coordinates in ipairs (overlay) do
			local x, y = strsplit("-", coordinates)
			local pin = overlayFramesPool:Acquire()
			pin.POI = {}
			pin.POI.entityID = entityID
			if (isNpc) then
				pin.POI.name = RSNpcDB.GetNpcName(entityID)
			elseif (isContainer) then
				pin.POI.name = RSContainerDB.GetContainerName(entityID)
			end
			
			pin.Texture:SetTexture(RSConstants.OVERLAY_SPOT_TEXTURE)
			pin.Texture:SetVertexColor(r, g, b, 0.7)
			HBD_Pins:AddMinimapIconMap(RSMinimap, pin, mapID, RSUtils.FixCoord(x), RSUtils.FixCoord(y), false, false)
		end
	end
end

function RSMinimap.RemoveOverlay(entityID)
	if (overlayFramesPool) then
		for pin in overlayFramesPool:EnumerateActive() do
			if (pin.POI.entityID == entityID) then
				overlayFramesPool:Release(pin)
				HBD_Pins:RemoveMinimapIcon(RSMinimap, pin)
			end
		end
	end
end

---============================================================================
-- Guide layer
---============================================================================

function RSMinimap.AddGuide(entityID)
	-- Gets MAPID from players position
	local mapID = C_Map.GetBestMapForUnit("player")
	if (not mapID or mapID == 0) then
		return
	end
	
	-- Check if the entity is actually active
	if (not RSGeneralDB.GetGuideActive() or RSGeneralDB.GetGuideActive() ~= entityID) then
		return
	end
	
	-- Initializes the pool
	if (not guideFramesPool) then
		guideFramesPool = CreateFramePool("FRAME", Minimap, "RSMinimapPinTemplate");
	end

	local guide = nil
	if (RSNpcDB.GetInternalNpcInfo(entityID)) then
		guide = RSGuideDB.GetNpcGuide(entityID, mapID)
	elseif (RSContainerDB.GetInternalContainerInfo(entityID)) then
		guide = RSGuideDB.GetContainerGuide(entityID, mapID)
	else
		guide = RSGuideDB.GetEventGuide(entityID, mapID)
	end

	if (guide) then
		for pinType, info in pairs (guide) do
			if (not info.questID or not C_QuestLog.IsQuestFlaggedCompleted(info.questID)) then
				local POI = RSGuidePOI.GetGuidePOI(entityID, pinType, info)
				local pin = guideFramesPool:Acquire()
				pin.POI = POI
				pin.Texture:SetTexture(POI.texture)
				pin.Texture:SetScale(RSConfigDB.GetIconsMinimapScale())
				HBD_Pins:AddMinimapIconMap(RSMinimap, pin, mapID, POI.x, POI.y, false, false)
			end
		end
	end
end

function RSMinimap.RemoveGuide(entityID)
	if (guideFramesPool) then
		for pin in guideFramesPool:EnumerateActive() do
			if (pin.POI.entityID == entityID) then
				guideFramesPool:Release(pin)
				HBD_Pins:RemoveMinimapIcon(RSMinimap, pin)
			end
		end
	end
end
