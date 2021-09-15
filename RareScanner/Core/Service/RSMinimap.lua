-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local ADDON_NAME, private = ...

local HBD_Pins = LibStub("HereBeDragons-Pins-2.0")

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
		if (not POI.worldmap and (not playerCoordX or not playerCoodY or RSUtils.DistanceBetweenCoords(tonumber(POI.x), playerCoordX, tonumber(POI.y), playerCoodY) <= RSConstants.MAXIMUN_MINIMAP_DISTANCE_RANGE)) then
			pin.Texture:SetTexture(POI.Texture)
			pin.Texture:SetScale(RSConfigDB.GetIconsMinimapScale())
			HBD_Pins:AddMinimapIconMap(RSMinimap, pin, POI.mapID, tonumber(POI.x), tonumber(POI.y), false, false)
		end
	
		-- Adds overlay if active
		if (RSGeneralDB.HasOverlayActive(POI.entityID)) then
			pin:ShowOverlay()
		end

		-- Adds guide if active
		if (RSGeneralDB.HasGuideActive(POI.entityID)) then
			pin:ShowGuide()
		end
	end
end
