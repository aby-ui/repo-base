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

-- RareScanner services
local RSMap = private.ImportLib("RareScannerMap")

-- RareScanner general libraries
local RSConstants = private.ImportLib("RareScannerConstants")
local RSLogger = private.ImportLib("RareScannerLogger")
local RSUtils = private.ImportLib("RareScannerUtils")

---============================================================================
-- Update minimap icons
---============================================================================

local previousMapID
local pinFramesPool
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

function RSMinimap.RemoveAllData()
	if (pinFramesPool) then
		HBD_Pins:RemoveAllMinimapIcons(RSMinimap)
		for pin in pinFramesPool:EnumerateActive() do
			if (pin.overlayFramesPool) then
				HBD_Pins:RemoveAllMinimapIcons(pin)
				pin.overlayFramesPool:ReleaseAll()
			end
			if (pin.guideFramesPool) then
				HBD_Pins:RemoveAllMinimapIcons(pin)
				pin.guideFramesPool:ReleaseAll()
			end
		end
		pinFramesPool:ReleaseAll()
	end
end

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
	
	-- Gets player coordinates
	local playerMapPosition = C_Map.GetPlayerMapPosition(mapID, "player")
	local playerCoordX
	local playerCoodY
	if (playerMapPosition) then
		playerCoordX, playerCoodY = playerMapPosition:GetXY()
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
		if (not POI.worldmap and (not playerCoordX or not playerCoodY or RSUtils.DistanceBetweenCoords(RSUtils.FixCoord(POI.x), playerCoordX, RSUtils.FixCoord(POI.y), playerCoodY) <= RSConstants.MAXIMUN_MINIMAP_DISTANCE_RANGE)) then
			pin.Texture:SetTexture(POI.Texture)
			pin.Texture:SetScale(RSConfigDB.GetIconsMinimapScale())
			HBD_Pins:AddMinimapIconMap(RSMinimap, pin, POI.mapID, RSUtils.FixCoord(POI.x), RSUtils.FixCoord(POI.y), false, false)
		end
	
		-- Adds overlay if active
		if (RSGeneralDB.HasOverlayActive(POI.entityID)) then
			local overlayInfo = RSGeneralDB.GetOverlayActive(POI.entityID)
			local r, g, b = RSConfigDB.GetWorldMapOverlayColour(overlayInfo.colourID)
			pin:ShowOverlay(r, g, b)
		end

		-- Adds guide if active
		if (RSGeneralDB.HasGuideActive(POI.entityID)) then
			pin:ShowGuide()
		end
	end
end
